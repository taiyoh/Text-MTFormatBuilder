use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder::Comment" };

do {
    my $comment = Text::MTFormatBuilder::Comment->new(
        content => 'test'
    );
    my $export = $comment->export;
    my $ref = <<'.';
COMMENT:
test
-----
.
    is $export, $ref, "exported text";
};

do {
    my $comment = Text::MTFormatBuilder::Comment->new(
        content => 'test',
        ip      => '1.2.3.4',
        url     => 'http://example.com',
        author  => 'aaaa'
    );
    my $export = $comment->export;
    my $ref = <<'.';
COMMENT:
AUTHOR: aaaa
URL: http://example.com
IP: 1.2.3.4
test
-----
.
    is $export, $ref, "exported text";
};

done_testing;
