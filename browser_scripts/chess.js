// ==UserScript==
// @name         remove chess ad bar
// @version      0.0.1
// @namespace    https://chess.com
// @match        https://chess.com/
// @match        https://chess.com/*
// @match        https://www.chess.com/
// @match        https://www.chess.com/*
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
  .board-layout-ad {
    display: none;
  }
  #add-to-library-modal {
    display: none;
  }`
  head.appendChild(style)
})()
