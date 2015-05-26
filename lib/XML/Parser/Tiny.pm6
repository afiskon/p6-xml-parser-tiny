#!/usr/bin/env perl6

use v6;
use XML::Parser::Tiny::Grammar;
use XML::Parser::Tiny::Actions;

unit class XML::Parser::Tiny;

has $!grammar = XML::Parser::Tiny::Grammar;
has $!actions = XML::Parser::Tiny::Actions.new;

method parse (Str $xml) {
    if my $m = $!grammar.parse($xml, :$!actions) {
        return $m.ast;
    } else {
        die 'Invalid XML';
    }
}

=begin pod

=head1 NAME

XML::Parser::Tiny is a module for parsing XML documents.

=head1 SYNOPSYS

=begin code
use XML::Parser::Tiny;

my $xml = q{<?xml version="1.0" charset="UTF-8" ?>
    <doc>aaa<bbb key='&lt;&#43;&gt;' ><![CDATA[<ccc>]]></bbb>ddd</doc>
};

my $parser = XML::Parser::Tiny.new;
my $tree = $parser.parse($xml);
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
#                   "key" => "<+>",
#                 },
#                 "data" => [ "<ccc>" ]
#             },
#             "ddd"
#         ]
#     }
# }
=end code

=head1 DESCRIPTION

A module for parsing XML documents.

=head1 METHODS

=head2 parse(Str $xml)

Converts XML into structure represented in SYNOPSYS section.
This method throws an exception in case of errors.

=head1 AUTHOR

Alexandr Alexeev, <eax at cpan.org> (L<http://eax.me/>)

=head1 COPYRIGHT

Copyright 2012 Alexandr Alexeev

This program is free software; you can redistribute it and/or modify it
under the same terms as Rakudo Perl 6 itself.

=end pod

