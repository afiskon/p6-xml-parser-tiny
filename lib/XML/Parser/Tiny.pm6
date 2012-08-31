#!/usr/bin/env perl6

use v6;
use XML::Parser::Tiny::Grammar;
use XML::Parser::Tiny::Actions;

class XML::Parser::Tiny;

has $!grammar = XML::Parser::Tiny::Grammar;
has $!actions = XML::Parser::Tiny::Actions.new;

method parse (Str $xml) {
    if my $m = $!grammar.parse($xml, :$!actions) {
        return $m.ast;
    } else {
        return Nil;
    }
}

=begin pod

=head NAME

XML::Parser::Tiny is a module for parsing XML documents.

=head SYNOPSYS

     use XML::Parser::Tiny;
     my $parser = XML::Parser::Tiny.new;
     my $xml = q{<?xml version="1.0" charset="UTF-8" ?>
       <doc>aaa<bbb key='&lt;&#123;&gt;' ><![CDATA[<ccc>]]></bbb>ddd</doc>
     };
     if my $tree = $parser.parse($xml) {
         say $tree.perl;

         # {
         #     "head" => [
         #         {
         #             "name" => "xml",
         #             "attr" => {
         #                 "version" => "1.0",
         #                 "charset" => "UTF-8"
         #             }
         #         }
         #     ],
         #     "body" => {
         #         "name" => "doc",
         #         "attr" => {},
         #         "data" => [
         #             "aaa",
         #             {
         #                 "name" => "bbb",
         #                 "attr" => {
         #                   "key" => "<\{>"
         #                 },
         #                 "data" => [ "<ccc>" ]
         #             },
         #             "ddd"
         #         ]
         #     }
         # }

     }
 
=end pod


