// ==UserScript==
// @name         Open in Archive.is
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  Open current page in archive.is (whitelist mode)
// @author       You
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function () {
  "use strict"

  const whitelist = ["nytimes.com", "bloomberg.com"]

  // Check if current site is in whitelist
  function isWhitelisted() {
    const currentHost = window.location.hostname
    return whitelist.some((site) => currentHost.endsWith(site))
  }

  // Only run on whitelisted sites
  if (!isWhitelisted()) return

  // Create button
  const button = document.createElement("button")
  button.textContent = "Archive"
  button.style.position = "fixed"
  button.style.top = "10px"
  button.style.right = "10px"
  button.style.zIndex = "999999"
  button.style.padding = "8px 12px"
  button.style.backgroundColor = "#4CAF50"
  button.style.color = "white"
  button.style.border = "none"
  button.style.borderRadius = "4px"
  button.style.cursor = "pointer"
  button.style.fontWeight = "bold"

  // Add click handler
  button.addEventListener("click", function () {
    const currentUrl = window.location.href
    const archiveUrl =
      "https://archive.is/?run=1&url=" + encodeURIComponent(currentUrl)
    window.open(archiveUrl, "_blank")
  })

  document.body.appendChild(button)
})();
