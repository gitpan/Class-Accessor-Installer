use inc::Module::Install;
name 'Class-Accessor-Installer';
all_from 'lib/Class/Accessor/Installer.pm';
perl_version '5.006';

requires 'Sub::Name';

build_requires 'Test::More' => '0.70';

use_standard_tests;
auto_include;
WriteAll;
