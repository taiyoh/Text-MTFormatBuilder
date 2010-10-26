use Test::More;

BEGIN { use_ok "Text::MTFormatBuilder::MetaData" };

do {
    my $metadata = Text::MTFormatBuilder::MetaData->new;
    my $export = $metadata->export;
    my $ref = <<'.';
CONVERT BREAKS: 0
ALLOW COMMENTS: 1
ALLOW PINGS: 1
-----
.
    is $export, $ref, "exported text";
};

do {
    my $metadata = Text::MTFormatBuilder::MetaData->new;
    $metadata->author('aaaa');
    $metadata->title('bbbb');
    $metadata->date('01/31/2002 03:31:05 PM');
    $metadata->primary_category('Hoge');
    my $export = $metadata->export;
    my $ref = <<'.';
AUTHOR: aaaa
TITLE: bbbb
DATE: 01/31/2002 03:31:05 PM
PRIMARY CATEGORY: Hoge
CONVERT BREAKS: 0
ALLOW COMMENTS: 1
ALLOW PINGS: 1
-----
.
    is $export, $ref, "exported text";
};

do {
    my $metadata = Text::MTFormatBuilder::MetaData->new;
    $metadata->author('aaaa');
    $metadata->title('bbbb');
    $metadata->date('01/31/2002 03:31:05 PM');
    $metadata->primary_category('Hoge');
    $metadata->append_category('fuga');
    $metadata->append_category('piyo');
    my $export = $metadata->export;
    my $ref = <<'.';
AUTHOR: aaaa
TITLE: bbbb
DATE: 01/31/2002 03:31:05 PM
PRIMARY CATEGORY: Hoge
CONVERT BREAKS: 0
ALLOW COMMENTS: 1
ALLOW PINGS: 1
CATEGORY: fuga
CATEGORY: piyo
-----
.
    is $export, $ref, "exported text";
};

done_testing;
