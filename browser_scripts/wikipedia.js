// ==UserScript==
// @name        Set wikipedia preferences
// @namespace   Violentmonkey Scripts
// @icon        https://en.wikipedia.org/static/favicon/wikipedia.ico
// @version     1.0.0
//
// @match       https://en.wikipedia.org/*
// @grant       none
// @run-at      document-start
//
// @author      taybart
// @description set prefs on wikipedia
// ==/UserScript==

; (function () {
  const COOKIE_NAME = 'enwikimwclientpreferences'
  const COOKIE_VALUE =
    'skin-theme-clientpref-os%2Cvector-feature-appearance-pinned-clientpref-0'

  // Check if cookie is already set correctly
  const existing = document.cookie
    .split('; ')
    .find((row) => row.startsWith(COOKIE_NAME + '='))

  if (!existing || existing.split('=')[1] !== COOKIE_VALUE) {
    // Set cookie for the wikipedia domain, with a long expiry
    const expires = new Date(
      Date.now() + 365 * 24 * 60 * 60 * 1000,
    ).toUTCString()
    document.cookie = `${COOKIE_NAME}=${COOKIE_VALUE}; domain=.wikipedia.org; path=/; expires=${expires}`

    // Reload so the server receives the cookie on the next request
    location.reload()
  }
})()
