// ==UserScript==
// @name        Redirect Fandom
// @namespace   https://fandom.com
// @description fandom to antifandom
// @include     https://*.fandom.*/*
// ==/UserScript==

const url = window.location.href
window.location = url.replace('fandom', 'antifandom')
