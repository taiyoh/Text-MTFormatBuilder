use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder::Ping" };

do {
    my $ping = Text::MTFormatBuilder::Ping->new(
        content => 'test'
    );
    my $export = $ping->export;
    my $ref = <<'.';
PING:
test
-----
.
    is $export, $ref, "exported text";
};

do {
    my $ping = Text::MTFormatBuilder::Ping->new(
        content => 'test',
        ip      => '1.2.3.4',
        title   => 'bbbb',
        url     => 'http://example.com',
        blog_name  => 'aaaaaaaaaaaaa',
        date  => '01/31/2002 03:31:05 PM'
    );
    my $export = $ping->export;
    my $ref = <<'.';
PING:
TITLE: bbbb
URL: http://example.com
IP: 1.2.3.4
BLOG NAME: aaaaaaaaaaaaa
DATE: 01/31/2002 03:31:05 PM
test
-----
.
    is $export, $ref, "exported text";
};

done_testing;
