// ==UserScript==
// @name         Youtube shorts redirect
// @namespace    https://youtube.com
// @version      0.4
// @description  Youtuebe shorts > watch redirect
// @author       Fuim, taybart
// @match        *://*.youtube.com/*
// @icon         https://www.google.com/s2/favicons?domain=youtube.com
// @grant        none
// @run-at       document-start
// @license      GNU GPLv2
// ==/UserScript==
var oldHref = document.location.href
if (window.location.href.indexOf('youtube.com/shorts') > -1) {
  window.location.replace(
    window.location.toString().replace('/shorts/', '/watch?v='),
  )
}
window.onload = function () {
  const bodyList = document.querySelector('body')
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((_mutation) => {
      if (oldHref != document.location.href) {
        oldHref = document.location.href
        if (window.location.href.indexOf('youtube.com/shorts') > -1) {
          window.location.replace(
            window.location.toString().replace('/shorts/', '/watch?v='),
          )
        }
      }
    })
  })
  var config = {
    childList: true,
    subtree: true,
  }
  observer.observe(bodyList, config)
}
