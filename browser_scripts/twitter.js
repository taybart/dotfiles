// ==UserScript==
// @name         Twitter remove right sidebar
// @version      0.0.1
// @namespace    https://twitter.com
// @description  fixes twitter ui
// @match        https://twitter.com/
// @match        https://twitter.com/*
// @match        https://www.twitter.com/
// @match        https://www.twitter.com/*
// @grant        none
// ==/UserScript==

;(() => {
  var head, style
  head = document.getElementsByTagName('head')[0]
  if (!head) {
    return
  }
  style = document.createElement('style')
  // style.type = 'text/css'
  style.innerHTML = `
  [data-testid="sidebarColumn"] {
    display: none !important;
  }
  .r-rthrr5 {
    width: 600px !important;
  }`
  head.appendChild(style)
})()
