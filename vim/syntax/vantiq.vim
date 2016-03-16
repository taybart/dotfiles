if exists("b:current_syntax")
    finish
endif

syntax keyword vantiqIdentKeyword RULE var
syntax keyword vantiqStructsKeyword if for
syntax keyword vantiqNullKeyword null Null NULL
syntax match vantiqParen    "("
syntax match vantiqFunction     "\w\+\s*(" contains=vantiqParen
syntax match vantiqObjKey     "\w\+\s*:"
syntax keyword vantiqSQLKeyword TIMEOUT INTO SERIES BEFORE AND WHERE WHEN AS INSERT UPDATE PUBLISH OCCURS ON WITHIN CONSTRAIN
syntax match vantiqComment "\/\/.*$"
syntax region vantiqString start='"' end='"'
syntax match vantiqNumber '\s\d\+'
syntax match vantiqNumber '[-+]\d\+'

highlight def link vantiqIdentKeyword Identifier
highlight def link vantiqStructsKeyword Structure
highlight def link vantiqFunction Function
highlight def link vantiqObjKey String
highlight def link vantiqSQLKeyword Define
highlight def link vantiqNullKeyword Define
highlight def link vantiqComment Comment
highlight def link vantiqString String
highlight def link vantiqNumber Number


let b:current_syntax = "vantiq"
