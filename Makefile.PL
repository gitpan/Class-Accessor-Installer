use inc::Module::Install;
include 'Module::AutoInstall';

name 'Class-Accessor-Installer';
all_from 'lib/Class/Accessor/Installer.pm';
perl_version '5.006';

requires 'Sub::Name';
requires 'UNIVERSAL::require';
requires 'Vim::Tag';

feature 'Generated documentation',
    - default => 1,
    'Pod::Generated' => '0.02';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
