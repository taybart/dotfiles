// ==UserScript==
// @name         Cleanup IMDb
// @namespace    taybart
// @version      1.0.0
// @description  Removes ads, popups, and clutter from IMDb title pages — just the movie info
// @author       taybart
// @match        *://www.imdb.com/*
// @icon         https://www.imdb.com/favicon.ico
// @grant        none
// @run-at       document-start
// ==/UserScript==

;(function () {
  'use strict'

  // ── CSS injected before page renders ──────────────────────────────────
  const style = document.createElement('style')
  style.textContent = `
    /* ═══════════════════════════════════════════════════════════════════
       DARK THEME
       ═══════════════════════════════════════════════════════════════════ */
    :root,
    html,
    body {
      color-scheme: dark !important;
    }

    /* Remap IMDb's light ("base" / "light") design tokens to dark equivalents
       so all sections, cards, metadata lists, and modals render dark natively */
    :root,
    [class*="sc-"],
    [class*="ipc-"] {
      /* Base surfaces */
      --ipt-base-bg: #1a1a1a !important;
      --ipt-base-color: #1a1a1a !important;
      --ipt-base-rgb: 26, 26, 26 !important;
      --ipt-base-shade1-bg: #1f1f1f !important;
      --ipt-base-shade1-color: #1f1f1f !important;
      --ipt-base-shade1-rgb: 31, 31, 31 !important;
      --ipt-base-shade2-bg: #262626 !important;
      --ipt-base-shade2-color: #262626 !important;
      --ipt-base-shade2-rgb: 38, 38, 38 !important;
      --ipt-base-shade3-bg: #141414 !important;
      --ipt-base-shade3-color: #141414 !important;
      --ipt-base-shade3-rgb: 20, 20, 20 !important;
      --ipt-base-hover-bg: rgba(255, 255, 255, 0.08) !important;
      --ipt-base-pressed-bg: rgba(255, 255, 255, 0.16) !important;
      --ipt-base-border-color: rgba(255, 255, 255, 0.16) !important;

      /* Text & icons on base surfaces */
      --ipt-on-base-color: #eee !important;
      --ipt-on-base-rgb: 238, 238, 238 !important;
      --ipt-on-base-textPrimary-color: rgba(255, 255, 255, 0.92) !important;
      --ipt-on-base-textSecondary-color: rgba(255, 255, 255, 0.7) !important;
      --ipt-on-base-textHint-color: rgba(255, 255, 255, 0.5) !important;
      --ipt-on-base-textDisabled-color: rgba(255, 255, 255, 0.45) !important;
      --ipt-on-base-textIcon-color: rgba(255, 255, 255, 0.85) !important;

      /* Accent colors on base surfaces */
      --ipt-on-base-accent1-color: rgb(245, 197, 24) !important;
      --ipt-on-base-accent1-rgb: 245, 197, 24 !important;
      --ipt-on-base-accent2-color: rgb(87, 153, 239) !important;
      --ipt-on-base-accent2-rgb: 87, 153, 239 !important;
      --ipt-on-base-accent3-color: rgb(251, 60, 60) !important;
      --ipt-on-base-accent3-rgb: 251, 60, 60 !important;
      --ipt-on-base-accent4-color: rgb(103, 173, 75) !important;
      --ipt-on-base-accent4-rgb: 103, 173, 75 !important;
      --ipt-on-base-accent5-color: rgb(255, 117, 3) !important;
      --ipt-on-base-accent5-rgb: 255, 117, 3 !important;
      --ipt-on-base-accent6-color: rgb(168, 105, 226) !important;
      --ipt-on-base-accent6-rgb: 168, 105, 226 !important;
      --ipt-on-base-error-color: rgb(251, 60, 60) !important;
      --ipt-on-base-error-rgb: 251, 60, 60 !important;
      --ipt-focus-outline-on-base: 1px dashed rgb(255, 255, 255) !important;
      --ipt-focus-outline-on-base-default: 1px dashed rgb(255, 255, 255) !important;

      /* Component-level surface tokens */
      --ipc-pageSection-base-bg: #1a1a1a !important;
      --ipc-pageSection-base-rgb: 26, 26, 26 !important;
      --ipc-pageSection-baseAlt-bg: #1a1a1a !important;
      --ipc-pageSection-baseAlt-rgb: 26, 26, 26 !important;
      --ipc-listCard-base-bg: #222 !important;
      --ipc-listCard-base-rgb: 34, 34, 34 !important;
      --ipc-listCard-baseAlt-bg: #222 !important;
      --ipc-listCard-baseAlt-rgb: 34, 34, 34 !important;
      --ipc-prompt-base-bg: #1f1f1f !important;
      --ipc-prompt-base-rgb: 31, 31, 31 !important;
      --ipc-blockQuote-base-bg: #222 !important;
      --ipc-blockQuote-base-color: #222 !important;
      --ipc-blockQuote-base-accent1-bg: #312705 !important;
      --ipc-blockQuote-base-accent1-color: #312705 !important;
      --ipc-blockQuote-base-accent2-bg: #111f30 !important;
      --ipc-blockQuote-base-accent2-color: #111f30 !important;
      --ipc-blockQuote-base-accent3-bg: #320c0c !important;
      --ipc-blockQuote-base-accent3-color: #320c0c !important;
      --ipc-blockQuote-base-accent4-bg: #1f3417 !important;
      --ipc-blockQuote-base-accent4-color: #1f3417 !important;

      /* Tailwind / newer token variables */
      --color-light: #1a1a1a !important;
      --color-light-shade1: #1f1f1f !important;
      --color-light-shade2: #262626 !important;
      --color-light-shade3: #141414 !important;
      --color-light-border: rgba(255, 255, 255, 0.16) !important;
      --color-on-light: #eee !important;
      --color-on-light-textPrimary: rgba(255, 255, 255, 0.92) !important;
      --color-on-light-textSecondary: rgba(255, 255, 255, 0.7) !important;
      --color-on-light-textHint: rgba(255, 255, 255, 0.5) !important;
      --color-on-light-textDisabled: rgba(255, 255, 255, 0.45) !important;
      --color-on-light-textIcon: rgba(255, 255, 255, 0.85) !important;
      --color-on-light-accent1: rgb(245, 197, 24) !important;
      --color-on-light-accent2: rgb(87, 153, 239) !important;
      --color-on-light-accent3: rgb(251, 60, 60) !important;
      --color-on-light-accent4: rgb(103, 173, 75) !important;
      --color-on-light-accent5: rgb(255, 117, 3) !important;
      --color-on-light-accent6: rgb(168, 105, 226) !important;
    }

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

    /* Links — keep dark text on solid yellow accent buttons */
    a:not(.ipc-btn--core-accent1) {
      color: #f5c518 !important;
    }
    a:not(.ipc-btn--core-accent1):hover {
      color: #ffe066 !important;
    }
    .ipc-btn--core-accent1,
    .ipc-btn--core-accent1 * {
      color: #000 !important;
    }

    /* Hardcoded light components (search bar, scroll-to-top pill, avatar heart badge) */
    #nav-search-form,
    #nav-search-form .searchform__submit {
      background-color: #1f1f1f !important;
      color: #eee !important;
    }
    #suggestion-search {
      color: #eee !important;
    }
    #suggestion-search::placeholder {
      color: rgba(255, 255, 255, 0.5) !important;
    }
    .searchCatSelector__opener {
      border-right-color: rgba(255, 255, 255, 0.2) !important;
    }
    .ipc-scroll-to-top-button,
    .ipc-floating-button {
      background-color: #262626 !important;
      color: #eee !important;
      border: 1px solid rgba(255, 255, 255, 0.16) !important;
    }
    .ipc-scroll-to-top-button *,
    .ipc-floating-button * {
      color: #eee !important;
    }
    [class*="FavoritePeopleCTA_favPeopleButton"] {
      background-color: rgba(0, 0, 0, 0.65) !important;
      color: #eee !important;
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
    [data-testid="title-cast-styling-proupsell"],
    [data-testid*="proupsell" i],
    #ProUpsellLink,
    .pro-upsell,
    .navbar__imdbpro {
      display: none !important;
    }

    /* Blurred AI review summary sign-in gate & footer sign-in nag */
    .ipc-title:has(+ [data-testid="review-summary-teaser"]),
    [data-testid="review-summary-teaser"],
    [data-testid="reviews-sign-in-card"],
    .footer__sign-in {
      display: none !important;
    }

    /* Videos & Photos sections */
    [data-testid="videos-section"],
    [cel_widget_id="StaticFeature_Videos"],
    [data-testid="photos-section"],
    [data-testid="Photos"],
    [cel_widget_id="StaticFeature_Photos"] {
      display: none !important;
    }

    /* Awards section */
    [data-testid="awards"],
    [cel_widget_id="StaticFeature_Awards"] {
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

    /* Contribute / edit / news sections */
    [data-testid="contribution"],
    [cel_widget_id="StaticFeature_Contribution"],
    [data-testid="News"],
    [cel_widget_id="StaticFeature_News"] {
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

    /* "What to watch" / "Top picks" / "Related interests" interstitials */
    [data-testid="RelatedInterests"],
    [cel_widget_id="StaticFeature_RelatedInterests"],
    [cel_widget_id="DynamicFeature_TopPicks"],
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
      .forEach(function (el) {
        el.removeAttribute('src')
        el.remove()
      })

    // Remove noscript ad fallbacks
    document
      .querySelectorAll(
        '.nas-slot noscript, .slot_wrapper noscript, .cornerstone_slot noscript',
      )
      .forEach(function (el) {
        el.remove()
      })

    // Kill sticky ad wrappers at the bottom of the page (adhesion)
    document
      .querySelectorAll('[id*="adhesion" i][id*="wrapper" i]')
      .forEach(function (el) {
        el.remove()
      })

    // Remove "Sponsored" labels
    document.querySelectorAll('.sponsored_label').forEach(function (el) {
      el.remove()
    })

    // Remove provider promotion bar
    document.querySelectorAll('.promoted-provider').forEach(function (el) {
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
      .forEach(function (el) {
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
  var observer = new MutationObserver(function () {
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
  setTimeout(function () {
    observer.disconnect()
  }, 15000)

  // Periodic sweep for late-loading junk (every 5s, up to 45s)
  var sweepInterval = setInterval(requestSweep, 5000)
  setTimeout(function () {
    clearInterval(sweepInterval)
  }, 45000)
})()
