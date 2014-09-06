use v6;
use lib 'lib';
use Test;
use XML::Parser::Tiny::Grammar;
use XML::Parser::Tiny::Actions;

my $xmlmap = q{<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="http://eax.me/wp-content/plugins/google-sitemap-generator/sitemap.xsl"?><!-- generator="wordpress/3.4.1" -->
<!-- sitemap-generator-url="http://www.arnebrachhold.de" sitemap-generator-version="3.2.8" -->
<!-- generated-on="29.08.2012 03:05" -->
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">	<url>
		<loc>http://eax.me/</loc>
		<lastmod>2012-08-29T03:04:32+00:00</lastmod>
		<changefreq>daily</changefreq>
		<priority>1.0</priority>
	</url>
	<url>
		<loc>http://eax.me/perl-on-android/</loc>
		<lastmod>2012-08-26T12:52:28+00:00</lastmod>
		<changefreq>monthly</changefreq>
		<priority>0.2</priority>
	</url>
</urlset>
  };

my $xmlmap_result = {
  head => [
    {
      name => 'xml',
      attr => {
        version => '1.0',
        encoding => 'UTF-8',
      },
    },
    {
      name => 'xml-stylesheet',
      attr => {
        type => 'text/xsl',
        href => 'http://eax.me/wp-content/plugins/google-sitemap-generator/sitemap.xsl',
      },
    },
  ], # head
  body => {
    name => 'urlset',
    attr => {
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd',
      'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
    },
    data => [
      {
        name => 'url',
        attr => {},
        data => [
          { name => 'loc', attr => {}, data => ['http://eax.me/'] },
          { name => 'lastmod', attr => {}, data => ['2012-08-29T03:04:32+00:00'] },
          { name => 'changefreq', attr => {}, data => ['daily'] },
          { name => 'priority', attr => {}, data => ['1.0'] },
        ],
      },
      {
        name => 'url',
        attr => {},
        data => [
          { name => 'loc', attr => {}, data => ['http://eax.me/perl-on-android/'] },
          { name => 'lastmod', attr => {}, data => ['2012-08-26T12:52:28+00:00'] },
          { name => 'changefreq', attr => {}, data => ['monthly'] },
          { name => 'priority', attr => {}, data => ['0.2'] },
        ],
      },
    ],
  }, # body
};

my %tests = (
  "<doc />" => { head => [], body => { name => 'doc', attr => {}, data => [] } },
  "<?xml ?><doc />" => { head => [ { name => 'xml', attr => {} } ], body => { name => 'doc', attr => {}, data => [] } },
  "<?xml aaa='bbb' ?><doc />" => { head => [ { name => 'xml', attr => { aaa => 'bbb'} } ], body => { name => 'doc', attr => {}, data => [] } },
  "<?xml ccc=\"ddd\" aaa='bbb' ?><doc />" => { head => [ { name => 'xml', attr => { aaa => 'bbb', ccc => 'ddd'} } ], body => { name => 'doc', attr => {}, data => [] } },
  "<?aaa ?><?bbb ?>   <doc />" => { head => [ { name => 'aaa', attr => {} }, { name => 'bbb', attr => {}} ], body => { name => 'doc', attr => {}, data => [] } },
  "<?aaa ?>   <?bbb ?><doc />" => { head => [ { name => 'aaa', attr => {} }, { name => 'bbb', attr => {}} ], body => { name => 'doc', attr => {}, data => [] } },
  "<?aaa x='1' ?><?bbb y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa <!-- --> x='1' ?><?bbb y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' <!-- --> ?><?bbb y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><!-- --><?bbb y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><!-- --> <!-- --><?bbb y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><?bbb <!-- --> y='2' ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><?bbb y='2' <!-- --> ?><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><?bbb y='2' ?><!-- --><doc />" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><?bbb y='2' ?><doc></doc>" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{},data=>[]}},
  "<?aaa x='1' ?><?bbb y='2' ?><doc z='3'></doc>" => {head=>[{name=>'aaa',attr=>{x=>'1'}},{name=>'bbb',attr=>{y=>'2'}}],body=>{name=>'doc',attr=>{z=>'3'},data=>[]}},
  "<doc></doc>" => { head => [], body => { name => 'doc', attr => {}, data => [] } },
  "<doc>xxx&lt;&amp;&gt;&apos;&quot;&#1060;yyy</doc>" => { head => [], body => { name => 'doc', attr => {}, data => [q{xxx<&>'"Фyyy}] } },
  "<doc key='xxx&lt;&amp;&gt;&apos;&quot;&#1060;yyy' />" => { head => [], body => { name => 'doc', attr => { key => q{xxx<&>'"Фyyy} }, data => [] } },
  "<doc key=\"xxx&lt;&amp;&gt;&apos;&quot;&#1060;yyy\" />" => { head => [], body => { name => 'doc', attr => { key => q{xxx<&>'"Фyyy} }, data => [] } },
  "<!-- xxx --><doc></doc>" => { head => [], body => { name => 'doc', attr => {}, data => [] } },
  "<doc><!-- yyy --></doc><!-- zzz -->" => { head => [], body => { name => 'doc', attr => {}, data => [] } },
  "<doc aaa='bbb' />" => { head => [], body => { name => 'doc', attr => { aaa => 'bbb' }, data => [] } },
  "<doc <!-- xxx --> aaa='bbb' />" => { head => [], body => { name => 'doc', attr => { aaa => 'bbb' }, data => [] } },
  "<doc aaa='bbb' ccc=\"ddd\" />" => { head => [], body => { name => 'doc', attr => { aaa => 'bbb', ccc => 'ddd' }, data => [] } },
  "<doc aaa='bbb' <!-- yyy --> ccc=\"ddd\" />" => { head => [], body => { name => 'doc', attr => { aaa => 'bbb', ccc => 'ddd' }, data => [] } },
  "<doc>bebe&amp;be</doc>" => { head => [], body => { name => 'doc', attr => {}, data => ['bebe&be'] } },
  "<doc>bebe<!-- aaa -->be</doc>" => { head => [], body => { name => 'doc', attr => {}, data => ['bebebe'] } },
  "<doc x=\"1\">bebebe</doc>" => { head => [], body => { name => 'doc', attr => {x=>'1'}, data => ['bebebe'] } },
  "<doc x=\"1\" y='2'>bebebe</doc>" => { head => [], body => { name => 'doc', attr => {x=>'1', y=>'2'}, data => ['bebebe'] } },
  "<doc><![CDATA[<html>&amp;]]></doc>" => { head => [], body => { name => 'doc', attr => {}, data => ['<html>&amp;'] } },
  "<doc>aaa<!-- --><![CDATA[</doc>]]>ccc</doc>" => { head => [], body => { name => 'doc', attr => {}, data => ['aaa</doc>ccc'] } },
  "<html><doc /></html>" => { head => [], body => { name => 'html', attr => {}, data => [{ name => 'doc', attr => {}, data => []}] } },
  "<html><doc></doc></html>" => { head => [], body => { name => 'html', attr => {}, data => [{ name => 'doc', attr => {}, data => []}] } },
  "<html x='1'><doc y='2'></doc></html>" => {head=>[],body=>{name=>'html',attr=>{x=>'1'},data=>[{name=>'doc',attr=>{y=>'2'},data=>[]}]}},
  "<html x='1'><!-- --><doc y='2'><!-- --></doc><!-- --></html>" => {head=>[],body=>{name=>'html',attr=>{x=>'1'},data=>[{name=>'doc',attr=>{y=>'2'},data=>[]}]}},
  "<html x='1'>aaa<doc y='2'>bbb</doc><![CDATA[ccc]]></html>" => {head=>[],body=>{name=>'html',attr=>{x=>'1'},data=>['aaa',{name=>'doc',attr=>{y=>'2'},data=>['bbb']},'ccc']}},
  $xmlmap => $xmlmap_result,
);

my $grammar = XML::Parser::Tiny::Grammar;
my $actions = XML::Parser::Tiny::Actions.new;
for %tests.kv -> $in, $out {
  my $m = $grammar.parse($in, :$actions);
  ok($m.ast eqv $out); 
}

done;

