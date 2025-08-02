// ==UserScript==
// @name        cleanup imdb.com
// @namespace   Violentmonkey Scripts
// @match       https://www.imdb.com/*
// @grant       none
// @version     1.0
// @author      taybart
// @description 7/23/2025, 1:16:06 PM
// ==/UserScript==



function removeAll(query) {
  const els = document.querySelectorAll(query)
  for (el of els) {
    console.log(`removing ${el}`)
    el.remove()
  }
}
removeAll('.graphic')
removeAll('.ipc-page-background.ipc-page-background--baseAlt.inline20-page-background')
removeAll('[data-test-id="right-rail-content-block"]')
removeAll('[aria-label]="Sponsored Content"')
//removeAll('.nas-slot')


function addGlobalStyle(css) {
    let head = document.getElementsByTagName('head')[0];
    if (!head) { return; }
    let style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = css;
    head.appendChild(style);
}

//addGobalStyle('.sc-e1aae3e0-1.eEFIsG.ipc-page-grid__item.ipc-page-grid__item--span-2 {grid-column: span 3 !important;}')
