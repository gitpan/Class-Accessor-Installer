use inc::Module::Install;
include 'Module::AutoInstall';

name 'Class-Accessor-Installer';
all_from 'lib/Class/Accessor/Installer.pm';
perl_version '5.006';

requires 'Sub::Name';
requires 'UNIVERSAL::require';

feature 'Generated documentation',
    - default => 1,
    'Pod::Generated' => '0.02';

build_requires 'Test::More' => '0.70';

process_templates(
    first_year => 2007,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
);

use_standard_tests;
auto_install;
auto_include;
WriteAll;
