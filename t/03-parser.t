#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Test;
use XML::Parser::Tiny;

my %tests = {
  "trash" => Nil,
  "<doc />" => { head => [], body => { name => 'doc', attr => {}, data => [] } },
};

my $parser = XML::Parser::Tiny.new;

for %tests.kv -> $in, $out {
  my $rslt = $parser.parse($in);
  ok($rslt eqv $out); 
}

done;

