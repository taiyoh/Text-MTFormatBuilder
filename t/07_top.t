use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder" };

do {
    my $builder = Text::MTFormatBuilder->new;
    my $entry = Text::MTFormatBuilder::Entry->new;
    $entry->body('test_body');
    $entry->extended_body('test_extended_body');
    $entry->excerpt('test_excerpt');
    $entry->author('author_test');
    $entry->title('title_test');
    $builder->append_entry($entry);
    my $export = $builder->export;
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
--------
.
    is $export, $ref, "exported text";
};

do {
    my $builder = Text::MTFormatBuilder->new;
    for (1 .. 2) {
        my $entry = Text::MTFormatBuilder::Entry->new;
        $entry->body('test_body');
        $entry->extended_body('test_extended_body');
        $entry->excerpt('test_excerpt');
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
        $builder->append_entry($entry);
    }
    my $export = $builder->export;
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
--------
.
    is $export, $ref, "exported text";
};


done_testing;
