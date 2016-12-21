my $input = 'abcdefgh';

my $rx1 = qr/^swap position (\d+) with position (\d+)$/;
my $rx2 = qr/^swap letter (\w) with letter (\w)$/;
my $rx3 = qr/^rotate ((?:left)|(?:right)) (\d+) steps$/;
my $rx4 = qr/^rotate based on position of letter (\w)$/;
my $rx5 = qr/^reverse positions (\d+) through (\d+)$/;
my $rx6 = qr/^move position (\d+) to position (\d+)$/;



while (<STDIN>) {
	# /^swap position (\d+) with position (\d+)$/ 
	($_ =~ $rx1) && do {
		# means that the letters at indexes X and Y (counting from 0) should be swapped
		my ($pos1, $pos2) = ($1, $2);
		print STDERR "swap position $pos1 with position $pos2\n";

		my @input = split '' => $input;
		my ($a, $b) = ($input[$pos1], $input[$pos2]);

		$input[$pos1] = $b;
		$input[$pos2] = $a;

		$input = join '' => @input;

		next;
	};

	# /^swap letter (\w) with letter (\w)$/ 
	($_ =~ $rx2) && do {
		# means that the letters X and Y should be swapped (regardless of where they appear in the string).

		my ($letter1, $letter2) = ($1, $2);
		print STDERR "swap letter $letter1 with letter $letter2\n";

		my $pos1 = index $input, $letter1;
		my $pos2 = index $input, $letter2;

                my @input = split '' => $input;
                my ($a, $b) = ($input[$pos1], $input[$pos2]);

                $input[$pos1] = $b;
                $input[$pos2] = $a;

                $input = join '' => @input;


		next;
	};

	# /^rotate ((?:left)|(?:right)) (\d+) steps$/ 
	($_ =~ $rx3) && do {
		# means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
		my ($card, $steps) = ($1, $2);
		print STDERR "rotate $card $steps steps\n";

		my @input = split '' => $input;
	
		for (1..$steps) {
			if ($card eq 'left') {
				my $l = shift(@input);
				push @input => $l;
			} else {
				my $l = pop(@input);
				unshift @input => $l
			}
		}
		$input = join '' => @input;

		next;
	};

	# /^rotate based on position of letter (\w)$/
	($_ =~ $rx4) && do {
		# means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.

		my $letter = $1;
		print STDERR "rotate based on position of letter $letter\n";
		my $pos = index $input, $letter;

		my $steps = ($pos > 4) ? ($pos +1) : $pos;
		
		my @input = split '' => $input;
		for (0..$steps) {
			my $l = pop(@input);
                        unshift @input => $l
		}
		$input = join '' => @input;

		next;
	};

	# /^reverse positions (\d+) through (\d+)$/
	($_ =~ $rx5) && do {
		# means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
		my ($pos1, $pos2) = ($1, $2);
		print STDERR "reverse positions $pos1 through $pos2\n";



		next;
	};

	# /^move position (\d+) to position (\d+)$/
	($_ =~ $rx6) && do {
		# means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
		my ($pos1, $pos2) = ($1, $2);
		print STDERR "move position $pos1 to position $pos2\n";
		next;
	};

}
