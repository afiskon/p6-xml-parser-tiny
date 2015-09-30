#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Test;
use XML::Parser::Tiny;

my $parser = XML::Parser::Tiny.new;

dies-ok( { $parser.parse('trash') } );
ok( $parser.parse('<doc />') eqv {head=>[],body =>{name =>'doc',attr =>{},data=>[]}} );

done-testing;

