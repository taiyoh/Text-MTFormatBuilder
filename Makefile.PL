use inc::Module::Install;
name 'Text-MTFormatBuilder';
all_from 'lib/Text/MTFormatBuilder.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
