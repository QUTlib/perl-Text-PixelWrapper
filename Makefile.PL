use inc::Module::Install;

name     'Text-PixelWrapper';
all_from 'Text/PixelWrapper.pm';

test_requires 'Test::More' => 0; #'0.62';
#recommends    'Text::Wrap' => 0; #'2005.082401';

WriteAll;

