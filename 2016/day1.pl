#!/usr/bin/perl
package Position;

sub new {
	my $class = shift;
	my $config = shift || {};
	my $self = {
		_conf => $config,
		x => 0,
		y => 0,
		direction => 'N',
		histo => { 
			'0:0' => 1 
		},
	};

	return bless $self => $class; 
}

sub direction { 
	my $self = shift;
	my $param = shift;
	if ($self->{direction} eq 'N') {
		$self->{direction} = ($param eq 'R') ? 'E' : 'W';	
	} elsif ( $self->{direction} eq 'S' ) {
		$self->{direction} = ($param eq 'R') ? 'W' : 'E';	
	} elsif ( $self->{direction} eq 'E' ) {
		$self->{direction} = ($param eq 'R') ? 'S' : 'N';	
	} elsif ( $self->{direction} eq 'W' ) {
		$self->{direction} = ($param eq 'R') ? 'N' : 'S';	
	}

	printf "Direction : %s " => $self->{direction} if $self->{_conf}{debug};

	return $self;

} 

sub marche {
	my $self = shift;
	my $nb_pas = shift;

	printf "Marche : %d ", $nb_pas if $self->{_conf}{debug};

        if ($self->{direction} eq 'N') {
		# incremente y
		for (1..$nb_pas) {
			$self->{y}++;
			$self->register();
		}
        } elsif ( $self->{direction} eq 'S' ) {
                # decremente y
                for (1..$nb_pas) {
                        $self->{y}--;
                        $self->register();
                } 
        } elsif ( $self->{direction} eq 'E' ) {
		# incremente x
                for (1..$nb_pas) {
                        $self->{x}++;
                        $self->register();
                }
        } elsif ( $self->{direction} eq 'W' ) {
		# decremente x
                for (1..$nb_pas) {
                        $self->{x}--;
                        $self->register();
                }
        }


	return $self;
}

sub register {
	my $self = shift;
	my $map = sprintf('%s:%s' => $self->{x}, $self->{y});

	printf "Map: %s " => $map if $self->{_conf}{debug};
	
        if (exists ($self->{histo}{$map})) {
                print "Deja visité " if $self->{_conf}{debug};
		$self->distance($self->{_conf}{'stop_on_visited'} || 0);
                $self->{histo}{$map}++;
		exit if (exists $self->{_conf}{'stop_on_visited'});
        } else {
                $self->{histo}{$map} = 1;
        }


}

sub distance {
	my $self = shift;
	my $print = shift || 0;

	printf "Distance : %d " => (abs($self->{x}) + abs($self->{y})) if ($self->{_conf}{debug} || $print);

	print "\n" if $print;

	return $self;
}


package main;

use Data::Dumper;
use Getopt::Long;

my %config = (
	chain => 'R3, L2, L2, R4, L1, R2, R3, R4, L2, R4, L2, L5, L1, R5, R2, R2, L1, R4, R1, L5, L3, R4, R3, R1, L1, L5, L4, L2, R5, L3, L4, R3, R1, L3, R1, L3, R3, L4, R2, R5, L190, R2, L3, R47, R4, L3, R78, L1, R3, R190, R4, L3, R4, R2, R5, R3, R4, R3, L1, L4, R3, L4, R1, L4, L5, R3, L3, L4, R1, R2, L4, L3, R3, R3, L2, L5, R1, L4, L1, R5, L5, R1, R5, L4, R2, L2, R1, L5, L4, R4, R4, R3, R2, R3, L1, R4, R5, L2, L5, L4, L1, R4, L4, R4, L4, R1, R5, L1, R1, L5, R5, R1, R1, L3, L1, R4, L1, L4, L4, L3, R1, R4, R1, R1, R2, L5, L2, R4, L1, R3, L5, L2, R5, L4, R5, L5, R3, R4, L3, L3, L2, R2, L5, L5, R3, R4, R3, R4, R3, R1',
);

GetOptions(\%config, 'stop_on_visited', 'debug', 'chain=s');


my @chemin = split(', ' => $config{chain});

my $position = Position->new(\%config);

print "Chain: $config{chain}" if $position->{_conf}{debug};

for my $pas (@chemin) {
	printf "Demande : %s\n\t" => $pas if $position->{_conf}{debug};
	my ($sens, $nb_pas) = (substr($pas, 0, 1), substr($pas, 1));
	$position->direction($sens)->marche($nb_pas)->distance();
	print "\n---\n" if $position->{_conf}{debug};
}

$position->distance(1);

