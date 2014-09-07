use v6;
use lib 'lib';
use Test;
use XML::Parser::Tiny::Grammar;

my @valid = (
  "<?xml?><simple/>",
  "<rss></rss>",
  "<rss />",
  "<?xml ver='1.0' ?><simple/>",
  "<?xml ver='1.0' ?><simple />",
  "<?xml ver='1.0' ?><simple key=''/>",
  "<?xml ver=\"1.0\" ?><simple key=\"\"/>",
  "<?xml ver=\"1.0\" ?><simple key='value'/>",
  "<?xml ver=\"1.0\" ?><simple key=\"value\"/>",
  "<?xml ver='1.0' xxx=\"yyy\" ?><simple key1=\"value1\" key2='value2'/>",
  "<?xml ver='1.0' yyy='zzz' ?><simple></simple>",
  "<?x?><simple key1=\"value1\" key2='value2'></simple>",
  "<?x?><simple key1=\"val'ue1\" key2='val\"ue2'></simple>",
  "<?x?><?xml-bebebe?><simple />",
  "<?x?>  <:::tag_-name />",
  "<?x?>  <_tag:-na.me key:na.me_-='1<2>3' />",
  "<?x?><!-- comment --><tag />",
  "<?x?><tag /><!--comment-->",
  "<?x <!-- -->?><tag />",
  "<tag <!-- comment --> />",
  "<tag <!-- comment --> k='v'/>",
  "<tag k='v' <!-- --> />",
  "<tag k='v' <!-- /> --> />",
  "<tag <!-- k= --> k='v' />",
  "<tag <!-- ></tag> --> ></tag>",
  "<tag><!-- <foo > --></tag>",
  "<tag><!-- --></tag>",
  "<tag></tag> <!-- -->",
  "<tag <!-- --> ></tag>",
  "<?x?><tag /><!-- <!-- <!-- -->",
  "<?x?><!-- x --><tag /><!-- y -->",
  "<?x?><alpha><beta /></alpha>",
  "<?x?><alpha><beta /><beta /><beta /></alpha>",
  "<?x?><alpha><beta></beta></alpha>",
  "<?x?><alpha><beta></beta><beta></beta></alpha>",
  "<?x?><alpha><beta><gamma /></beta><beta><gamma></gamma></beta></alpha>",
  "<?x?><alpha a='b'><beta c=\"d\" e='f'><gamma g='h' /></beta><beta i='j' /><gamma k='l'/></alpha>",
  "<?x?><tag>bebebe some data</tag>",
  "<?x?><x><tag1>bebebe</tag1><tag2>123123</tag2></x>",
  "<?x?><x><tag1>bebebe&lt;tag2&gt;&lt;/tag2&gt;123123</tag1></x>",
  "<?x?><l1><l2>#(*/\%!|]'^:_-</l2><l2><l3><!-- --></l3><l3>Проверка проверка</l3></l2></l1>",
  "<?x?><tag><![CDATA[]]></tag>",
  "<?x?><tag><![CDATA[test]]></tag>",
  "<?x?><tag><![CDATA[</tag>]]></tag>",
  "<?x?><tag><![CDATA[]]]]]]></tag>",
  "<?x?><tag><![CDATA[]>]]></tag>",
  "<?x?><tag><![CDATA[ <!-- ]>]]></tag>",
  "<body>hello <em>there</em></body>",
  "<body>hello <![CDATA[there]]></body>",
  "<body>aaa <![CDATA[bbb]]> <em>ccc</em></body>",
  "<body>aaa <em>bbb <![CDATA[ccc]]></em></body>",
  "<body>aaa <em>bbb <strong>ccc</strong></em> <![CDATA[ddd]]> eee <!-- fff --> ggg</body>",
  "<?xml version=\"&amp;&gt;xxx&quot;&apos;yyy&lt;&#7654321;\" ?><doc />",
  "<?xml encoding='&amp;&lt;xxx&gt;&quot;yyy&apos;&#123456;'?><doc />",
  "<?xml ?><doc aaa=\"xxx&amp;&lt;&gt;&#123;yyy&quot;&apos;\" />",
  "<?xml ?><doc aaa='&amp;&lt;&gt;yyy&#456;&quot;&apos;zzz' />",
  "<?xml key=\"&lt;\" ?><doc key='&gt;' />",
  "<!DOCTYPE html><html />",
  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html><head /><body>foo</body></html>",
  '<!DOCTYPE sgml [
     <!ELEMENT sgml ANY>
     <!ENTITY % std    "standard SGML">
     <!ENTITY % play     "Hamlet">
     <!ENTITY % author "William Shakespeare">
  ]>
  <sgml>To be or not to be? - William Shakespeare.</sgml>',
  "<?xml version=\"&amp;&gt;&quot;&apos;&lt;&#7654321;\" encoding='&amp;&lt;xxx&gt;&quot;yyy&apos;&#123456;'?><doc><do.c><![CDATA[ any data <html> ]]></do.c> <!-- <tag /> --> <!-- 123 --> <tag attr1='any value' attr2=\"other value\">\r\n\t <some:other:tag id='12' key=''/> <and_one_more> bebebe <!-- comment --> </and_one_more></tag></doc>",
  q{<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="http://eax.me/wp-content/plugins/google-sitemap-generator/sitemap.xsl"?><!-- generator="wordpress/3.4.1" -->
<!-- sitemap-generator-url="http://www.arnebrachhold.de" sitemap-generator-version="3.2.8" -->
<!-- generated-on="29.08.2012 03:05" -->
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">	<url>
		<loc>http://eax.me/</loc>
		<lastmod>2012-08-29T03:04:32+00:00</lastmod>
		<changefreq>daily</changefreq>
		<priority>1.0</priority>
	</url>
	<url>
		<loc>http://eax.me/redis/</loc>
		<lastmod>2012-08-29T03:04:32+00:00</lastmod>
		<changefreq>monthly</changefreq>
		<priority>0.2</priority>
	</url>
	<url>
		<loc>http://eax.me/perl-on-android/</loc>
		<lastmod>2012-08-26T12:52:28+00:00</lastmod>
		<changefreq>monthly</changefreq>
		<priority>0.2</priority>
	</url>
</urlset>
  },
  q{<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" media="screen" href="/~d/styles/rss2russianfull.xsl"?><?xml-stylesheet type="text/css" media="screen" href="http://feeds.feedburner.com/~d/styles/itemcontent.css"?><rss xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:sy="http://purl.org/rss/1.0/modules/syndication/" xmlns:slash="http://purl.org/rss/1.0/modules/slash/" version="2.0">

<channel>
	<title>Записки программиста</title>
	
	<link>http://eax.me</link>
	<description>Операционные системы, скрипты,  компьютерные сети, безопасность, алгоритмы, блогинг, девайсы и пр</description>
	<lastBuildDate>Wed, 29 Aug 2012 03:04:32 +0000</lastBuildDate>
	<language>ru-RU</language>
	<sy:updatePeriod>hourly</sy:updatePeriod>
	<sy:updateFrequency>1</sy:updateFrequency>
	<generator>http://wordpress.org/?v=3.4.1</generator>
		<atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="self" type="application/rss+xml" href="http://feeds.feedburner.com/eaxme" /><feedburner:info xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" uri="eaxme" /><atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="hub" href="http://pubsubhubbub.appspot.com/" /><feedburner:emailServiceId xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0">eaxme</feedburner:emailServiceId><feedburner:feedburnerHostname xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0">http://feedburner.google.com</feedburner:feedburnerHostname><feedburner:feedFlare xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" href="http://fusion.google.com/add?feedurl=http%3A%2F%2Ffeeds.feedburner.com%2Feaxme" src="http://buttons.googlesyndication.com/fusion/add.gif">Subscribe with Google</feedburner:feedFlare><feedburner:feedFlare xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" href="http://lenta.yandex.ru/settings.xml?name=feed&amp;url=http%3A%2F%2Ffeeds.feedburner.com%2Feaxme" src="http://lenta.yandex.ru/i/addfeed.gif">?????? ? ??????.?????</feedburner:feedFlare><item>
		<title>Написал свой первый Perl-скрипт для Android</title>
		<link>http://eax.me/perl-on-android/</link>
		<comments>http://eax.me/perl-on-android/#comments</comments>
		<pubDate>Mon, 27 Aug 2012 05:00:55 +0000</pubDate>
		<dc:creator>Eax</dc:creator>
				<category><![CDATA[Perl]]></category>
		<category><![CDATA[Android]]></category>
		<category><![CDATA[Кодинг]]></category>
		<category><![CDATA[Скрипты]]></category>

		<guid isPermaLink="false">http://eax.me/?p=10615</guid>
		<description><![CDATA[Есть такой проект под названием Scripting Layer for Android (SL4A). Это штука, которая позволяет запускать на Android-устройствах скрипты, написанные на Perl, Python, JRuby, Lua, JavaScript и других языках. Устанавливается SL4A следующим образом. Переходим по этой ссылке и находим там файл с именами вроде sl4a_r6.apk. При клике по имени файла перед вами появится страница для загрузки [...]]]></description>
		<wfw:commentRss>http://eax.me/perl-on-android/feed/</wfw:commentRss>
		<slash:comments>2</slash:comments>
		</item>
		<item>
		<title>Памятка по управлению пакетами в Debian</title>
		<link>http://eax.me/debian-packages/</link>
		<comments>http://eax.me/debian-packages/#comments</comments>
		<pubDate>Wed, 15 Aug 2012 06:56:49 +0000</pubDate>
		<dc:creator>Eax</dc:creator>
				<category><![CDATA[UNIX]]></category>
		<category><![CDATA[Debian]]></category>
		<category><![CDATA[FreeBSD]]></category>
		<category><![CDATA[Linux]]></category>
		<category><![CDATA[ОС]]></category>

		<guid isPermaLink="false">http://eax.me/?p=10199</guid>
		<description><![CDATA[Помните, как некоторое время назад у меня не срослось с установкой FreeBSD на Asus Eee PC 1215P и я был вынужден поставить Xubuntu? Тот случай неиллюзорно намекнул мне, что поддержка железа операционной системой имеет большее значение, нежели я полагал. Притом не только на десктопе &#8212; на серверах также требуется поддержка сетевых карт, RAID контроллеров и [...]]]></description>
		<wfw:commentRss>http://eax.me/debian-packages/feed/</wfw:commentRss>
		<slash:comments>11</slash:comments>
		</item>
		
	</channel>
</rss><!-- Dynamic page generated in 2.515 seconds. --><!-- Cached page generated by WP-Super-Cache on 2012-08-29 10:35:48 -->

  }, 
);

my @invalid = (
  "<?xml?>",
  "<??><ok/>",
  "<?xml<ok/>",
  "<ok /><?xml ?>",
  "<?xml /><doc />",
  "<? xml ?><doc />",
  "<?xml ?>< doc />",
  "<doc ?>",
  "<doc key='&123;' />",
  "<doc key='&#;' />",
  "<doc key='&;' />",
  "<doc key=\"&bebebe;\" />",
  "<doc key=\"&amp\" />",
  "<doc key=\"&#123\" />",
  "&lt;doc />",
  "<?xml ?&gt;<doc></doc>",
  "<doc &#123; key='1' />",
  "<?xml &amp; ?><doc></doc>",
  "<?xml ?>&lt;<doc></doc>",
  "<?xml ver='1.0' ?><tag>",
  "<?xml ver='1.0' ?><tag/></tag>",
  "<?xml ver='1.0' ?><tag key= />",
  "<?xml ver='1.0' ?><tag key=value />",
  "<?xml ver='1.0' ?><tag key='val'ue' />",
  "<?xml ver='1.0' ?><tag key=\"al\"ue\" />",
  "<?x?><tag name />",
  "<!-- -->",
  "<?x?><tag=name />",
  "<?x?><tag key name='123' />",
  "<?x?><.tag />",
  "<?x?><0tag />",
  "<?x?><-tag />",
  "<!-- --><?x?><tag />",
  "<?x?><tag<!-- bebebe -->name />",
  "<?x?><tag key<!-- -->name='val' />",
  "<?x?><tag key<!-- -->='val' />",
  "<?x?><tag key=<!-- -->'val' />",
  "<?x?><<!-- -->tag />",
  "<?x?><tag /<!-- -->>",
  "<<!-- -->?x?><tag />",
  "<?x?<!-- -->><tag />",
  "<?<!-- -->x ?><tag />",
  "<tag><<!-- -->/tag>",
  "<tag></<!-- -->tag>",
  "<tag></tag<!-- -->>",
  "<?x <?y?>?><tag />",
  "<body>hello <ab>there</cd></body>",
  "<body>hel<!-- lo <![CDATA[th --> ere]]></body>",
  "<body>aaa <![CDATA[<em>bbb]]> ccc </em></body>",
  "<![CDATA[ccc]]>",
  "<body>aaa</body><![CDATA[bbb]]>",
  "<alpha><beta></alpha></beta>",
  "<alpha <beta></beta> ></alpha>",
  "<alpha <beta></beta> />",
  "<alpha <beta/> ></alpha>",
  "<alpha <beta/> />",
  "<alpha><beta><alpha></alpha></alpha></beta>",
  "<tag bebebe some data />",
  "<?x?><tag1>bebebe</tag1><tag2>123123</tag2>",
  "<?x?><x><tag1>beb</ebe</tag1>",
  "<?x?><x><tag1>beb>ebe</tag1>",
  "<?x?><x><tag1>beb<foo />ebe</tag1>",
  "<?x?><tag><![CDATA[]]</tag>",
  "<?x?><tag><![CDATA[]></tag>",
  "<?x?><tag><!CDATA[]]></tag>",
  "<?x?><tag><![CDATA[data1]]>data2]]></tag>",
  "<?x?><![CDATA[<tag>]]><tag></tag>",
  "<?x?><tag></tag><!CDATA[<tag>]]>",
  "<?x?><tag <!CDATA[<tag>]]> />",
  "<?x<![CDATA[]]>?><tag />",
);

my %tests;
%tests{$_} = True for @valid.values;
%tests{$_} = False for @invalid.values;

my $grammar = XML::Parser::Tiny::Grammar;

for %tests.kv -> $key, $val {
  ok($grammar.parse($key).Bool == $val);
}

done;
