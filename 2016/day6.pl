use Data::Dumper;

my $h = [ ];

while (my $line = <STDIN>) {
	chomp($line);
	my @chars = split('' => $line);
	for my $i (0 .. $#chars) {
		$h->[$i]{$chars[$i]}++
	};

}

for my $letter (@$h) {
	my $r;
	my @sorted = sort {$letter->{$a} <=> $letter->{$b}} keys %$letter;
	# print Dumper \@sorted;
	print shift(@sorted);
}

