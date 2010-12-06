use strict;
use utf8;
use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder::Nifty" };
Text::MTFormatBuilder::Nifty->import('-Declare');

do {
    my $export = blog_export {
        entry {
            metadata {
                author 'author_test';
                title  'title_test';
            };
            body 'test_body';
            extended_body 'test_extended_body';
            excerpt 'test_excerpt';
        };
    };
    my $ref = <<'.';
AUTHOR: author_test
TITLE: title_test
CONVERT BREAKS: 0
ALLOW COMMENTS: 1
ALLOW PINGS: 1
-----
BODY:
test_body
-----
EXTENDED BODY:
test_extended_body
-----
EXCERPT:
test_excerpt
-----
--------
.
    note $export;
};


done_testing;
