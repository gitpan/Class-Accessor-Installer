package Class::Accessor::Installer;

use warnings;
use strict;
use Sub::Name;
use UNIVERSAL::require;


our $VERSION = '0.02';


sub install_accessor {
    my ($self, %args) = @_;

    my ($pkg, $name, $code) = @args{ qw/pkg name code/ };

    unless (defined $pkg) {
        $pkg = ref $self || $self;
    }

    $name = [ $name ] unless ref $name eq 'ARRAY';

    for my $sub (@$name) {
        no strict 'refs';
        *{"${pkg}::${sub}"} = subname "${pkg}::${sub}" => $code;

        for my $doc_type (qw(purpose example)) {
            next unless defined $args{$doc_type};

            # don't use() it - this installer should still work if we don't
            # have Pod::Generated

            Pod::Generated->require;
            next if $@;

            my $spec = $args{$doc_type};
            $spec = [ $spec ] unless ref $spec eq 'ARRAY';
            for my $doc_el (@$spec) {
                $doc_el =~ s/^\s*|\s*$//sg;
                Pod::Generated::add_doc($pkg, 'CODE', $sub, $doc_type, $doc_el);
            }
        }
    }
}


1;

__END__



=head1 NAME

Class::Accessor::Installer - install an accessor subroutine

=head1 SYNOPSIS

    package Class::Accessor::Foo;

    use base 'Class::Accessor::Installer';

    sub mk_foo_accessors {
        my ($self, @fields) = @_;
        my $class = ref $self || $self;

        for my $field (@fields) {
            $self->install_accessor(
                sub     => "${field}_foo",
                code    => sub { ... },
                purpose => 'Does this, that and the other',
                example => [
                    "my \$result = $class->${field}_foo(\$value)",
                    "my \$result = $class->${field}_foo(\$value, \$value2)",
                }
            );
        }

    }


=head1 DESCRIPTION

This mixin class provides a method that will install a coderef. There are
other modules that do this, but this one is a bit more specific to the needs
of L<Class::Accessor::Complex> and friends.

It is intended as a mixin, that is, your accessor-generating class should
inherit from this class.

=head2 METHODS

=over 4

=item install_accessor

Takes as arguments a named hash. The following keys are recognized:

=over 4

=item pkg

The package into which to install the subroutine. If this argument is omitted,
it will inspect C<$self> to determine the package. Class::Accessor::*
accessor generators are typically used like this:

    __PACKAGE__
        ->mk_new
        ->mk_array_accessors(qw(foo bar));

Therefore C<install_accessor()> can determine the right package into which to
install the subroutine.

=item name

The name or names to use for the subroutine. You can either pass a single
string or a reference to an array of strings. Each string is interpreted as a
subroutine name inside the given package, and the code reference is installed
into the appropriate typeglob.

Why would you want to install a subroutine in more than one place inside your
package? For example, L<Class::Accessor::Complex> often creates aliases so the
user can choose the version of the name that reads more naturally.

An example of this usage would be:

        $self->install_accessor(
            name => [ "clear_${field}", "${field}_clear" ],
            code => sub { ... }
        );

=item code

This is the code reference that should be installed.

=item purpose

A string describing the generated method. This information can be used by
L<Pod::Generated> to automatically generate pod documentation during C<make>
time.

=item example

One or more examples of using the method. These will also be used in the
generated documentation. The value can be a string or an reference to an array
of strings.

=back

The installed subroutine is named using L<Sub::Name>, so it shows up with a
meaningful name in stack traces (instead of as C<__ANON__>). However, the
inside the debugger, the subroutine still shows up as C<__ANON__>. You might
therefore want to use the following lines at the beginning of your subroutine:

        $self->install_accessor(
            name => $field,
            code => sub {
                local $DB::sub = local *__ANON__ = "${class}::${field}"
                    if defined &DB::DB && !$Devel::DProf::VERSION;
                ...
        );

Now the subroutine will be named both in a stack trace and inside the
debugger.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<classaccessorinstaller> tag.

=head1 VERSION 
                   
This document describes version 0.02 of L<Class::Accessor::Installer>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-class-accessor-installer@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
