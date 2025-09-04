// ==UserScript==
// @name        Redirect Fandom
// @namespace   https://fandom.com
// @description fandom to antifandom
// @include     https://*.fandom.*/*
// @include     https://antifandom.com/*
// ==/UserScript==

const loc = window.location
if (loc.host !== 'antifandom.com') {
  window.location = loc.href.replace('fandom', 'antifandom')
}
