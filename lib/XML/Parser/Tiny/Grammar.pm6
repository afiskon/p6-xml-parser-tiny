#!/usr/bin/env perl6

use v6;

grammar XML::Parser::Tiny::Grammar;

token TOP {
    ^ <head> <.sp> <body_item> <.sp> $
}

token head {
    <head_item>* <.sp> <doctype>?
}

token head_item {
    '<?' <name> <attribute>*? <.sp> '?>' <.sp>
}

token body_item {
    <short> <.sp> | <long> <.sp>
}

token short {
    '<' <name> <attribute>*? <.sp> '/>'
}

token long {
    '<' (<name>) <attribute>*? <.sp> '>'
        <.sp> <inner>*
    '</' $0 '>'
}

token inner {
    <comment> | <data_list> | <cdata> | <body_item>
}

token cdata {
    '<![CDATA[' .*? ']]>'
}

token data_list {
    <data> +
}

token data {
    <data_chars> | <entity>
}

token data_chars {
    <-[<>&]>+
}

token attribute {
    \s <.sp> <name> '=' <value>
}

token name {
    <[a..zA..Z_:]> <[a..zA..Z0..9_:.-]>*
}

token value {
    <value_apos_list> | <value_quot_list>
}

token value_apos_list {
    '\'' <value_apos>* '\''
}

token value_quot_list {
    '"' <value_quot>* '"'
}

token value_apos {
    <value_apos_chars> | <entity>
}

token value_quot {
    <value_quot_chars> | <entity>
}

token value_apos_chars {
    <-['&]>+ 
}

token value_quot_chars {
    <-["&]>+ 
}

token sp {
    \s* | \s* <comment> <.sp>
}

token comment {
    '<!--' .*? '-->'
}

token entity {
    <amp> | <lt> | <gt> | <apos> | <quot> | <num>
}

token amp { '&amp;' }
token lt { '&lt;' }
token gt { '&gt;' }
token apos { '&apos;' }
token quot { '&quot;' }
token num { '&#' <[0..9]>+ ';' }

token doctype {
  '<!DOCTYPE' <.sp> <name> <.sp> <external_dtd>?
              <.sp> <internal_dtd>? <.sp> '>'
}

token external_dtd {
    <dtd_type> [<.sp> <value>] ** 1..2
}

token dtd_type { SYSTEM | PUBLIC }

token internal_dtd { 
    '['  [ <-[\'\"\]]>+? | <value>]+  ']'
}

