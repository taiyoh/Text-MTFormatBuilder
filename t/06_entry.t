use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder::Entry" };

do {
    my $entry = Text::MTFormatBuilder::Entry->new(
        body => 'test_body',
        extended_body => 'test_extended_body',
        excerpt => 'test_excerpt'
    );
    $entry->author('author_test');
    $entry->title('title_test');
    my $export = $entry->export;
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
KEYWORDS:

-----


-----
.
    is $export, $ref, "exported text";
};

do {
    my $entry = Text::MTFormatBuilder::Entry->new(
        body => 'test_body',
        extended_body => 'test_extended_body',
        excerpt => 'test_excerpt'
    );
    $entry->author('author_test');
    $entry->title('title_test');
    $entry->add_comment({
        content => 'test'
    });
    $entry->add_comment({
        content => 'test2'
    });
    $entry->add_ping({
        content => 'test'
    });
    $entry->add_ping({
        content => 'test2'
    });
    my $export = $entry->export;
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
KEYWORDS:

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


-----
.
    is $export, $ref, "exported text";
};


done_testing;
