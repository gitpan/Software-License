package Software::License::Custom;
BEGIN {
  $Software::License::Custom::VERSION = '0.103000';
}
use strict;
use warnings;
use Carp;
use English qw( -no_match_vars );

use base 'Software::License';

# ABSTRACT: custom license handler

sub new {
   my ($class, $arg) = @_;

   my $filename = delete $arg->{filename};

   my $self = $class->SUPER::new($arg);

   $self->load_sections_from($filename) if defined $filename;

   return $self;
} ## end sub new

sub load_sections_from {
   my ($self, $filename) = @_;

   # Sections are kept inside a hash
   $self->{'Software::License::Custom'}{section_for} = \my %section_for;

   my $current_section = '';
   open my $fh, '<', $filename
      or croak "open('$filename'): $OS_ERROR";
   while (<$fh>) {
      if (my ($section) = m{\A __ (.*) __ \n\z}mxs) {
         ($current_section = $section) =~ s/\W+//gmxs;
      }
      else {
         $section_for{$current_section} .= $_;
      }
   }
   close $fh;

   # strip last newline from all items
   s{\n\z}{}mxs for values %section_for;

   return $self;
}

sub section_data {
   my ($self, $name) = @_;
   my $section = $self->{'Software::License::Custom'}{section_for}{$name};
   return defined($section) ? \$section : undef;
}

sub name       { shift->_fill_in('NAME') }
sub url        { shift->_fill_in('URL') }
sub meta2_name { shift->_fill_in('META2_NAME') }

# This is (also) a class method in the other modules, so we stick to this
# convention and the tests will be happy.
sub meta_name  {
   my $self = shift;
   return 'custom' unless ref $self;
   return $self->_fill_in('META_NAME')
}

1;


=pod

=head1 NAME

Software::License::Custom - custom license handler

=head1 VERSION

version 0.103000

=head1 DESCRIPTION

This module gives the possibility of
specifying all aspects related to a software license in a custom file.
This allows for setting custom dates, notices, etc. while still preserving
compatibility with all places where L<Software::License> is used, e.g.
L<Dist::Zilla>.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

