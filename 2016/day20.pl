#!/usr/bin/env perl

package Range;

sub new {
        my $class = shift;
        my $self = [ 
		
	];

        return bless $self => $class;
}

sub check_inclusion {
	my $self = shift;
	my $range = shift;
	
	foreach my $inner (@$self) {
		return 1 if (($range->{max} <= $inner->{max}) && ($range->{min} >= $inner->{min}));
		if (( $inner->{min} < $range->{max} ) && ( $range->{max} > $inner->{max}  )) {
			$inner->{max} =  $range->{max};
			return 1;
		}
	}

	push @{$self} => $range;

	return 0;
}

sub filter {
	my $self = shift;

	my @ret = ();
	for my $r (sort {$a->{min} <=> $b->{min}} @{$self}) {
		if (scalar(@ret) == 0) { push @ret => $r; next };
		foreach my $inner (@ret) {
	                if (( $inner->{max} < $r->{max} ) && ( $r->{min} < $inner->{max}  )) {
        	                $inner->{max} =  $r->{max};
                	        next;
                	}
		}
		push @ret => $r;

	};

	@{ $self } = @ret;

}

1;

package Rules;

sub new {
	my $class = shift;
	my @range = split '-' => shift;
	
	my $self = {
		min => int($range[0]),
		max => int($range[1]),
	};
		
	return bless $self => $class;
}



1;

package main;

use Data::Dumper;

my $range = Range->new();
my $c = 0;

while (my $line = <STDIN>) {
	$c++;
	$line =~ s/[\r\n]+$//;

	my $rule = Rules->new($line);
	if ($range->check_inclusion($rule)) { 
		next;
	};

};

$range->filter();

printf "c:%d, r:%d\n" => ($c ,scalar @{$range});

for my $r (sort {$a->{min} <=> $b->{min}} @{$range}) {
	print Dumper $r
}

1;
