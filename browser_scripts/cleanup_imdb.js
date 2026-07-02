// ==UserScript==
// @name         Cleanup IMDb
// @namespace    taybart scripts
// @version      1.0.0
// @description  Removes ads, popups, and clutter from IMDb title pages — just the movie info
// @author       taybart
// @match        *://www.imdb.com/title/*
// @icon         https://www.imdb.com/favicon.ico
// @grant        none
// @run-at       document-start
// ==/UserScript==

; (function() {
  'use strict'

  // ── CSS injected before page renders ──────────────────────────────────
  const style = document.createElement('style')
  style.textContent = `
    /* ═══════════════════════════════════════════════════════════════════
       DARK THEME
       ═══════════════════════════════════════════════════════════════════ */
    html,
    body,
    #__next {
      background-color: #111 !important;
      color: #ccc !important;
    }

    .ipc-page-wrapper,
    .ipc-page-content-container,
    .ipc-page-background--base,
    .ipc-page-background--baseAlt {
      background-color: transparent !important;
      background: transparent !important;
    }

    /* Hero section background override */
    section[data-testid="atf-wrapper-bg"] {
      background-color: #111 !important;
    }

    /* Fix gap from hidden inline20 leaderboard ad (fixed-wrap pushes content down) */
    .fixed-wrap.ipc-page-wrapper,
    .fixed-wrap.ipc-page-wrapper + section {
      top: 0 !important;
      margin-top: 0 !important;
      padding-top: 0 !important;
    }

    /* Smooth theme transition */
    #__next,
    .ipc-page-wrapper,
    section[data-testid="atf-wrapper-bg"] {
      transition: background-color 0.3s ease;
    }

    /* Main content card backgrounds */
    .ipc-page-section--base,
    .ipc-page-section--baseAlt {
      background-color: #1a1a1a !important;
    }

    a {
      color: #f5c518 !important;
    }
    a:hover {
      color: #ffe066 !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       HIDE ALL AD CONTAINERS
       ═══════════════════════════════════════════════════════════════════ */
    .nas-slot,
    .slot_wrapper,
    .cornerstone_slot,
    .first_party_ad_wrapper,
    .ad-placement,
    .afs_ads,
    .sponsored_label,
    .promoted-provider,
    .responsive-ppb,
    .inline20-page-background,
    #sis_pixel_r2,
    #cookie_sync_pixel,

    /* Ad slots by ID pattern */
    [id*="inline20"]:not(script):not(style),
    [id*="inline40"]:not(script):not(style),
    [id*="inline50"]:not(script):not(style),
    [id*="inline60"]:not(script):not(style),
    [id*="inline80"]:not(script):not(style),
    [id*="inlinebottom"]:not(script):not(style),
    [id*="adhesion"]:not(script):not(style),
    [id*="provider_promotion"]:not(script):not(style),
    [id*="sis_pixel"]:not(script):not(style),
    [id*="cookie_sync"]:not(script):not(style),

    /* Ads by cel_widget_id */
    [cel_widget_id*="inline"],
    [cel_widget_id*="adhesion"] {
      display: none !important;
      visibility: hidden !important;
      height: 0 !important;
      width: 0 !important;
      min-height: 0 !important;
      overflow: hidden !important;
      position: absolute !important;
      pointer-events: none !important;
      opacity: 0 !important;
      z-index: -1 !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       HIDE SIDEBAR / RIGHT RAIL
       ═══════════════════════════════════════════════════════════════════ */
    [data-test-id="right-rail-content-block"],
    .right-rail-more-to-explore,
    [data-testid="sidebar-sticky-block"],
    [data-testid="SidebarList-editorial"],
    [data-testid="DynamicFeature_EditorialLists"],
    [cel_widget_id="DynamicFeature_EditorialLists"] {
      display: none !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       MAKE MAIN CONTENT FULL-WIDTH (2-col -> single column)
       ═══════════════════════════════════════════════════════════════════ */
    .ipc-page-grid {
      display: block !important;
    }
    .ipc-page-grid__item--span-2 {
      width: 100% !important;
      max-width: 960px !important;
      margin: 0 auto !important;
      float: none !important;
      grid-column: auto !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       HIDE ANNOYING ELEMENTS
       ═══════════════════════════════════════════════════════════════════ */

    /* Sign-in coachmark / nag popup */
    .navbar__coachmark,
    .ipc-coachmark,
    .navbar__coachmark--hide {
      display: none !important;
    }

    /* "Use app" button in nav */
    .imdb-header__app-button,
    a.imdb-header__app-button {
      display: none !important;
    }

    /* Sub-nav bar (Cast & crew | User reviews | Trivia | FAQ | All topics) */
    [data-testid="hero-subnav-bar-left-block"],
    [data-testid="hero-subnav-bar-right-block"],
    [data-testid="hero-subnav-bar-topic-links"] {
      display: none !important;
    }

    /* IMDbPro upsell */
    [data-testid="hero-proupsell"],
    #ProUpsellLink,
    .pro-upsell,
    .navbar__imdbpro {
      display: none !important;
    }

    /* Videos & Photos sections */
    [data-testid="videos-section"],
    [data-testid="photos-section"] {
      display: none !important;
    }

    /* Awards section */
    [data-testid="awards"] {
      display: none !important;
    }

    /* "More like this" carousel */
    [data-testid="MoreLikeThis"],
    [cel_widget_id="StaticFeature_MoreLikeThis"] {
      display: none !important;
    }

    /* "Recently viewed" footer */
    .recently-viewed,
    [data-testid="heading-rvi"],
    section.recently-viewed-items {
      display: none !important;
    }

    /* Contribute / edit section */
    [data-testid="contribution"] {
      display: none !important;
    }

    /* Details / BoxOffice / TechSpecs tabs */
    [data-testid="Details"],
    [data-testid="BoxOffice"],
    [data-testid="TechSpecs"] {
      display: none !important;
    }

    /* Editorial lists in sidebar area */
    [data-testid="SidebarList-editorial"],
    [cel_widget_id="DynamicFeature_EditorialLists"] {
      display: none !important;
    }

    /* "What to watch" / "Top picks" interstitials */
    a[href*="what-to-watch"],
    a[href*="interest/all"] {
      display: none !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       CLEAN UP VIDEO PLAYER (hide ad overlays in player)
       ═══════════════════════════════════════════════════════════════════ */
    .jw-plugin-vast,
    .jw-flag-ads .jw-controlbar {
      display: none !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       HIDE COOKIE / PRIVACY BANNERS (Amazon-style)
       ═══════════════════════════════════════════════════════════════════ */
    #sp-cc,
    #sp-cc-accept,
    #cookie-consent-banner,
    #truste-consent-track,
    div[class*="cookie-consent"],
    div[class*="CookieConsent"] {
      display: none !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       CLEANER HERO SECTION
       ═══════════════════════════════════════════════════════════════════ */
    /* Make poster reasonable size */
    [data-testid="hero-media__poster"] img {
      max-height: 360px !important;
      width: auto !important;
    }

    /* Reduce clutter in plot area */
    [data-testid="plot"] {
      max-width: 600px !important;
      line-height: 1.7 !important;
      font-size: 15px !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       CLEANER TYPOGRAPHY
       ═══════════════════════════════════════════════════════════════════ */
    .ipc-title--section-title .ipc-title__text {
      font-weight: 600 !important;
      letter-spacing: -0.01em !important;
    }

    h1, h2, h3, h4 {
      color: #eee !important;
    }

    /* ═══════════════════════════════════════════════════════════════════
       MUTED SCROLLBARS
       ═══════════════════════════════════════════════════════════════════ */
    ::-webkit-scrollbar {
      width: 6px;
    }
    ::-webkit-scrollbar-track {
      background: #111;
    }
    ::-webkit-scrollbar-thumb {
      background: #333;
      border-radius: 3px;
    }
    ::-webkit-scrollbar-thumb:hover {
      background: #555;
    }

    /* ═══════════════════════════════════════════════════════════════════
       REMOVE LOADING SHIMMERS / PLACEHOLDERS
       ═══════════════════════════════════════════════════════════════════ */
    [class*="placeholder_pattern"],
    [class*="placeholder_fadeout"],
    [class*="placeholder_inline"] {
      display: none !important;
    }
  `
  document.documentElement.appendChild(style)

  // ── DOM cleanup ────────────────────────────────────────────────────────
  var sweepPending = false

  function sweep() {
    // Remove ad iframes (stop ad scripts, save bandwidth)
    document
      .querySelectorAll(
        'iframe[id*="inline" i], iframe[id*="adhesion" i], ' +
        'iframe[title="Advertisement" i], iframe[title*="ad content" i], ' +
        'iframe[id*="google_ads" i], iframe[id*="afs" i]',
      )
      .forEach(function(el) {
        el.removeAttribute('src')
        el.remove()
      })

    // Remove noscript ad fallbacks
    document
      .querySelectorAll(
        '.nas-slot noscript, .slot_wrapper noscript, .cornerstone_slot noscript',
      )
      .forEach(function(el) {
        el.remove()
      })

    // Kill sticky ad wrappers at the bottom of the page (adhesion)
    document
      .querySelectorAll('[id*="adhesion" i][id*="wrapper" i]')
      .forEach(function(el) {
        el.remove()
      })

    // Remove "Sponsored" labels
    document.querySelectorAll('.sponsored_label').forEach(function(el) {
      el.remove()
    })

    // Remove provider promotion bar
    document.querySelectorAll('.promoted-provider').forEach(function(el) {
      el.remove()
    })

    // Remove the sign-in coachmark if it appears dynamically
    var coachmark = document.querySelector('.navbar__coachmark')
    if (coachmark) coachmark.remove()

    // Remove the "Use app" button
    var appBtn = document.querySelector('.imdb-header__app-button')
    if (appBtn) appBtn.remove()

    // Fix layout: remove fixed-wrap class (pushes content down for hidden inline20)
    var pageWrapper = document.querySelector('.ipc-page-wrapper')
    if (pageWrapper && pageWrapper.classList.contains('fixed-wrap')) {
      pageWrapper.classList.remove('fixed-wrap')
      pageWrapper.style.top = ''
      pageWrapper.style.marginTop = ''
    }

    // Remove dynamically-injected modals/overlays
    document
      .querySelectorAll(
        '[role="dialog"]:has(iframe), ' +
        '[role="dialog"]:has([class*="signin" i]), ' +
        '[data-testid="promo-modal"], ' +
        '.tp-modal, .tp-backdrop, .tp-active',
      )
      .forEach(function(el) {
        el.remove()
      })

    sweepPending = false
  }

  // Debounced sweep via requestAnimationFrame to avoid thrashing
  function requestSweep() {
    if (!sweepPending) {
      sweepPending = true
      requestAnimationFrame(sweep)
    }
  }

  // Initial sweep once DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', requestSweep)
  } else {
    requestSweep()
  }

  // ── MutationObserver: catch dynamically-injected junk ─────────────────
  var observer = new MutationObserver(function() {
    requestSweep()
  })

  function startObserving() {
    if (document.body) {
      observer.observe(document.body, { childList: true, subtree: true })
    } else {
      requestAnimationFrame(startObserving)
    }
  }
  startObserving()

  // Stop observing after 15s (page should be settled)
  setTimeout(function() {
    observer.disconnect()
  }, 15000)

  // Periodic sweep for late-loading junk (every 5s, up to 45s)
  var sweepInterval = setInterval(requestSweep, 5000)
  setTimeout(function() {
    clearInterval(sweepInterval)
  }, 45000)
})()
