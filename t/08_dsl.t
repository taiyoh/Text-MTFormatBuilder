use strict;
use utf8;
use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder" };

Text::MTFormatBuilder->import('-Base');

do {
    my $export = transaction {
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
    is $export, $ref, "exported text";
};

do {
    my $export = transaction {
        for (1 .. 2) {
            entry {
                metadata {
                    author 'author_test';
                    title  'title_test';
                };
                body 'test_body';
                extended_body 'test_extended_body';
                excerpt 'test_excerpt';
                comment { content 'test'; };
                comment { content 'test2'; };
                ping { content 'test'; };
                ping { content 'test2'; };
            };
        }
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
COMMENT:
test
-----
COMMENT:
test2
-----
PING:
test
-----
PING:
test2
-----
--------
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
COMMENT:
test
-----
COMMENT:
test2
-----
PING:
test
-----
PING:
test2
-----
--------
.
    is $export, $ref, "exported text";
};


done_testing;
