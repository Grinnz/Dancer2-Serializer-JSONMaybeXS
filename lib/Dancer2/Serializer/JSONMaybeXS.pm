package Dancer2::Serializer::JSONMaybeXS;

use Moo;
use JSON::MaybeXS ();
use Scalar::Util 'blessed';

our $VERSION = '0.001';

with 'Dancer2::Core::Role::Serializer';

has '+content_type' => ( default => sub {'application/json;charset=UTF-8'} );

sub serialize {
	my ($self, $entity, $options) = @_;
	
	my $config = $self->config;
	
	foreach (keys %$config) {
		$options->{$_} = $config->{$_} unless exists $options->{$_};
	}
	
	$options->{utf8} = 1 if !defined $options->{utf8};
	
	JSON::MaybeXS->new($options)->encode($entity);
}

sub deserialize {
	my ($self, $entity, $options) = @_;
	
	$options->{utf8} = 1 if !defined $options->{utf8};
	JSON::MaybeXS->new($options)->decode($entity);
}

1;

=head1 NAME

Dancer2::Serializer::JSONMaybeXS - Serializer for handling JSON data

=head1 SYNOPSIS

 use Dancer2;
 set serializer => 'JSONMaybeXS';

=head1 DESCRIPTION

This is a serializer engine for the L<Dancer2> web framework that allows you to
turn Perl data structures into JSON output and vice-versa. It uses
L<JSON::MaybeXS>, a faster and cleaner interface to XS and pure-perl JSON
modules than L<JSON>.pm.

=head1 METHODS

=head2 deserialize

 my $data = $serializer->deserialize($string);

Deserializes a JSON string into a Perl data structure.

=head2 serialize

 my $string = $serializer->serialize($data);

Serializes a Perl data structure into a JSON string.

=head1 BUGS

Report any issues on the public bugtracker.

=head1 AUTHOR

Dan Book <dbook@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2016 by Dan Book.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=head1 SEE ALSO

L<Dancer2::Serializer::JSON>
