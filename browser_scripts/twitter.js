// ==UserScript==
// @name         twitter
// @version      0.0.1
// @namespace    https://twitter.com
// @description  fixes twitter ui
// @match        https://twitter.com/
// @match        https://twitter.com/*
// @match        https://www.twitter.com/
// @match        https://www.twitter.com/*
// @match        https://x.com/
// @match        https://x.com/*
// @match        https://www.x.com/
// @match        https://www.x.com/*
// @grant        none
// ==/UserScript==

; (() => {
  const head = document.getElementsByTagName('head')[0]
  if (!head) {
    return
  }
  const style = document.createElement('style')
  // style.type = 'text/css'
  style.innerHTML = `
  header[role=banner] {
    display: none !important;
  }
  [data-testid="primaryColumn"] {
    margin-left: 50%;
  }
  [data-testid="sidebarColumn"] {
    display: none !important;
  }

  .r-rthrr5 {
    width: 600px !important;
  }`
  head.appendChild(style)

  // remove ads
  setInterval(function() {
    let allSpans = document.getElementsByTagName('span')
    if (typeof allSpans !== 'undefined') {
      for (let i = 0; i < allSpans.length; i++) {
        if (typeof allSpans[i].innerText !== 'undefined') {
          if (allSpans[i].innerText == 'Ad') {
            allSpans[
              i
            ].parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.remove()
          }
          if (allSpans[i].innerText == 'Promoted Tweet') {
            allSpans[i].remove()
          }
        }
      }
    }
  }, 1500)
})()
