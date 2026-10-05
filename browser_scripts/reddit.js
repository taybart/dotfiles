// ==UserScript==
// @name         Reddit Declutter
// @namespace    taybart
// @version      1.2.0
// @description  Removes the left/right sidebars, in-feed ads, and the Google sign-in/One Tap prompt from new Reddit, and widens posts to use the reclaimed space.
// @match        https://www.reddit.com/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

;(function () {
  'use strict'

  // --- Block Google Sign-In / One Tap ------------------------------------
  // Reddit loads Google's Identity Services script (accounts.google.com/gsi/client)
  // and calls google.accounts.id.initialize()/.prompt(), which can trigger either
  // an in-page iframe prompt or the browser-native FedCM "One Tap" dialog. Neither
  // can be reliably removed after the fact (the native dialog isn't even part of
  // the page's DOM), so instead we install a frozen no-op stub at document-start,
  // before Reddit's real script has a chance to install itself. The real script
  // still loads, but its attempt to overwrite window.google silently fails,
  // leaving our no-ops in place for every call Reddit makes afterward.
  ;(function blockGoogleSignIn() {
    function noop() {}
    const idStub = {
      initialize: noop,
      prompt: function (cb) {
        if (typeof cb === 'function') {
          try {
            cb({
              isNotDisplayed: () => true,
              isSkippedMoment: () => true,
              isDismissedMoment: () => false,
              getNotDisplayedReason: () => 'unknown_reason',
              getSkippedReason: () => 'user_cancel',
              getMomentType: () => 'display',
            })
          } catch (e) {}
        }
      },
      renderButton: noop,
      disableAutoSelect: noop,
      storeCredential: function (cred, cb) {
        if (cb) cb()
      },
      cancel: noop,
      revoke: function (hint, cb) {
        if (cb) cb({ successful: true })
      },
      setLogLevel: noop,
    }
    const oauth2Stub = {
      initTokenClient: function () {
        return { requestAccessToken: noop }
      },
      initCodeClient: function () {
        return { requestCode: noop }
      },
      hasGrantedAllScopes: () => false,
      hasGrantedAnyScope: () => false,
      revoke: noop,
    }
    const accountsStub = { id: idStub, oauth2: oauth2Stub }
    const googleStub = { accounts: accountsStub }
    try {
      Object.freeze(idStub)
      Object.freeze(oauth2Stub)
      Object.freeze(accountsStub)
      Object.freeze(googleStub)
    } catch (e) {}
    try {
      Object.defineProperty(window, 'google', {
        value: googleStub,
        writable: false,
        configurable: false,
        enumerable: true,
      })
    } catch (e) {}
  })()

  const CSS = `
    /* Left nav sidebar (subreddit list / premium upsell) and right sidebar
       (People also ask, Related posts, subreddit info, etc). */
    #left-sidebar-container,
    #right-sidebar-container {
      display: none !important;
    }

    /* These two grids reserve column space for the sidebars even when
       hidden, so collapse them down to a single fluid column. */
    .grid-container {
      grid-template-columns: 1fr !important;
    }
    .main-container {
      grid-template-columns: minmax(0, 1fr) !important;
    }

    /* The content column has a fixed width class; let it expand to use
       the space the sidebars used to occupy. It also has an explicit
       grid-column-start: 2 (for the now-collapsed left sidebar column),
       which left a phantom empty column eating flex space on the left -
       override it to span the whole (now single-column) grid. */
    .subgrid-container {
      grid-column: 1 / -1 !important;
      width: min(1400px, 94vw) !important;
      max-width: none !important;
      margin-left: auto !important;
      margin-right: auto !important;
    }

    /* Sponsored posts/ads. Reddit uses a different custom element per
       placement: shreddit-ad-post in feeds, shreddit-comments-page-ad and
       shreddit-comment-tree-ad(s) interspersed in comment threads, and
       shreddit-sidebar-ad in the right rail (belt-and-suspenders, since the
       whole right sidebar is already hidden above). */
    shreddit-ad-post,
    shreddit-comments-page-ad,
    shreddit-comment-tree-ad,
    shreddit-comment-tree-ads,
    shreddit-sidebar-ad {
      display: none !important;
    }

    /* Fallback in case the legacy (non-FedCM) Google One Tap iframe ever
       renders despite the stub above. */
    #credential_picker_container,
    #credential_picker_iframe,
    iframe[src^="https://accounts.google.com/gsi/"] {
      display: none !important;
    }
  `

  const style = document.createElement('style')
  style.id = 'reddit-declutter-style'
  style.textContent = CSS
  ;(document.head || document.documentElement).appendChild(style)
})()
