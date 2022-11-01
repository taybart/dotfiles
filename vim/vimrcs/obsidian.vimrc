
imap jk <Esc>
" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
" I like using H and L for beginning/end of line
nmap H ^
nmap L $

" Yank to system clipboard
set clipboard=unnamed

exmap W obcommand editor:save-file

" Available commands: editor:save-file
" editor:follow-link
" editor:open-link-in-new-leaf
" editor:open-link-in-new-split
" editor:open-link-in-new-window
" editor:focus-top
" editor:focus-bottom
" editor:focus-left
" editor:focus-right
" workspace:toggle-pin
" workspace:split-vertical
" workspace:split-horizontal
" workspace:toggle-stacked-tabs
" workspace:edit-file-title
" workspace:copy-path
" workspace:copy-url
" workspace:undo-close-pane
" workspace:export-pdf
" editor:rename-heading
" workspace:open-in-new-window
" workspace:move-to-new-window
" workspace:next-tab
" workspace:goto-tab-1
" workspace:goto-tab-2
" workspace:goto-tab-3
" workspace:goto-tab-4
" workspace:goto-tab-5
" workspace:goto-tab-6
" workspace:goto-tab-7
" workspace:goto-tab-8
" workspace:goto-last-tab
" workspace:previous-tab
" workspace:new-tab
" obsidian-excalidraw-plugin:excalidraw-download-lib
" obsidian-excalidraw-plugin:excalidraw-open
" obsidian-excalidraw-plugin:excalidraw-open-on-current
" obsidian-excalidraw-plugin:excalidraw-insert-transclusion
" obsidian-excalidraw-plugin:excalidraw-insert-last-active-transclusion
" obsidian-excalidraw-plugin:excalidraw-autocreate
" obsidian-excalidraw-plugin:excalidraw-autocreate-on-current
" obsidian-excalidraw-plugin:excalidraw-autocreate-popout
" obsidian-excalidraw-plugin:excalidraw-autocreate-and-embed
" obsidian-excalidraw-plugin:excalidraw-autocreate-and-embed-on-current
" obsidian-excalidraw-plugin:excalidraw-autocreate-and-embed-popout
" obsidian-excalidraw-plugin:export-svg
" obsidian-excalidraw-plugin:search-text
" obsidian-excalidraw-plugin:fullscreen
" obsidian-excalidraw-plugin:export-png
" obsidian-excalidraw-plugin:save
" obsidian-excalidraw-plugin:toggle-lock
" obsidian-excalidraw-plugin:scriptengine-store
" obsidian-excalidraw-plugin:delete-file
" obsidian-excalidraw-plugin:insert-link
" obsidian-excalidraw-plugin:insert-link-to-element
" obsidian-excalidraw-plugin:insert-link-to-element-group
" obsidian-excalidraw-plugin:insert-link-to-element-area
" obsidian-excalidraw-plugin:toggle-lefthanded-mode
" obsidian-excalidraw-plugin:reset-image-to-100
" obsidian-excalidraw-plugin:insert-image
" obsidian-excalidraw-plugin:release-notes
" obsidian-excalidraw-plugin:tray-mode
" obsidian-excalidraw-plugin:insert-md
" obsidian-excalidraw-plugin:insert-LaTeX-symbol
" obsidian-excalidraw-plugin:toggle-excalidraw-view
" obsidian-excalidraw-plugin:convert-to-excalidraw
" obsidian-excalidraw-plugin:convert-excalidraw
" app:go-back
" app:go-forward
" app:open-vault
" theme:use-dark
" theme:use-light
" theme:switch
" app:open-settings
" app:show-release-notes
" markdown:toggle-preview
" workspace:close
" workspace:close-others
" app:delete-file
" app:toggle-left-sidebar
" app:toggle-right-sidebar
" app:toggle-default-new-pane-mode
" app:open-help
" app:reload
" app:show-debug-info
" window:toggle-always-on-top
" window:zoom-in
" window:zoom-out
" window:reset-zoom
" file-explorer:new-file
" file-explorer:new-file-in-new-pane
" open-with-default-app:open
" file-explorer:move-file
" open-with-default-app:show
" editor:open-search
" editor:open-search-replace
" editor:focus
" editor:toggle-fold
" editor:fold-all
" editor:unfold-all
" editor:fold-less
" editor:fold-more
" editor:insert-wikilink
" editor:insert-embed
" editor:insert-link
" editor:insert-tag
" editor:set-heading
" editor:set-heading-0
" editor:set-heading-1
" editor:set-heading-2
" editor:set-heading-3
" editor:set-heading-4
" editor:set-heading-5
" editor:set-heading-6
" editor:toggle-bold
" editor:toggle-italics
" editor:toggle-strikethrough
" editor:toggle-highlight
" editor:toggle-code
" editor:toggle-blockquote
" editor:toggle-comments
" editor:toggle-bullet-list
" editor:toggle-numbered-list
" editor:toggle-checklist-status
" editor:cycle-list-checklist
" editor:insert-callout
" editor:swap-line-up
" editor:swap-line-down
" editor:attach-file
" editor:delete-paragraph
" editor:toggle-spellcheck
" editor:context-menu
" file-explorer:open
" file-explorer:reveal-active-file
" global-search:open
" switcher:open
" graph:open
" graph:open-local
" graph:animate
" backlink:open
" backlink:open-backlinks
" backlink:toggle-backlinks-in-document
" outgoing-links:open
" outgoing-links:open-for-current
" tag-pane:open
" daily-notes
" daily-notes:goto-prev
" daily-notes:goto-next
" insert-template
" insert-current-date
" insert-current-time
" note-composer:merge-file
" note-composer:split-file
" note-composer:extract-heading
" command-palette:open
" starred:open
" starred:star-current-file
" outline:open
" outline:open-for-current
" file-recovery:open
" editor:toggle-source

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
" exmap back obcommand app:go-back
" nmap <C-o> :back
" exmap forward obcommand app:go-forward
" nmap <C-i> :forward
