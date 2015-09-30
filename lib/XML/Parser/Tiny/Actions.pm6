#!/usr/bin/env perl6

use v6;

unit class XML::Parser::Tiny::Actions;

method TOP ($/) {
  make {
    head => $<head>.ast,
    body => $<body_item>.ast,
  };
}

method head ($/) {
  make [$<head_item>>>.ast]
}

method head_item ($/) {
  make {
    name => $<name>.ast,
    attr => $<attribute>>>.ast.flat.hash
  };
}

method body_item ($/) {
  make $/.values[0].ast;
}

method short ($/) {
  make {
    name => $<name>.ast,
    attr => $<attribute>>>.ast.flat.hash,
    data => [],
  };
}

method long ($/) {
  make {
    name => $/.list[0].hash{'name'}.ast,
    attr => $<attribute>>>.ast.flat.hash,
    data => $<inner> eq [] ?? $<inner> !! do {
      my $result = [];
      for $<inner>>>.ast.flat.grep({$_.defined}) {
        if $_ ~~ Str && $result && $result[$result.end] ~~ Str {
          $result[$result.end] ~= $_;
        } else {
          $result.push($_);
        }
      }
      $result;
    },
  };
}

method inner ($/) {
    make $/.values[0].ast;
}

method data_list ($/) {
    make $<data>>>.ast.flat.join;
}

method data ($/) {
    make $/.values[0].ast;
}

method data_chars ($/) {
    make ~$/;
}

method cdata ($/) {
    make $/.substr(9, $/.chars - 12);
}

method attribute ($/) {
    make $<name>.ast => $<value>.ast;
}

method name ($/) {
    make ~$/;
}

method value ($/) {
    make $/.values[0].ast;
}

method value_apos_list ($/) {
    make $<value_apos>>>.ast.flat.join;
}

method value_quot_list ($/) {
    make $<value_quot>>>.ast.flat.join;
}

method value_apos ($/) {
    make $/.values[0].ast;
}

method value_quot ($/) {
    make $/.values[0].ast;
}

method value_apos_chars ($/) {
    make ~$/;
}

method value_quot_chars ($/) {
    make ~$/;
}

method entity ($/) {
    make $/.values[0].ast;
}

method lt ($/) { make '<' }
method gt ($/) { make '>' }
method amp ($/) { make '&' }
method apos ($/) { make "'" }
method quot ($/) { make '"' }
method num ($/) { make chr( $/.substr(2, $/.chars - 3) ) }

