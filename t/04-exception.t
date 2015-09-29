use v6;

use Test;
use XML::Parser::Tiny;

throws-like { XML::Parser::Tiny.new.parse("<") }, X::XML::Parser::Tiny::Invalid;

done-testing;
