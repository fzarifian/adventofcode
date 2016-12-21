#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);
my $str = 'ffykfhsq';
my $i = 0;

my @s = ();

my $qr = qr/^[01234567]$/;

while (1) {
	my $md5 = md5_hex(sprintf '%s%d' => $str, $i);
	# printf "%s%d : $md5\n" => $str, $i;
	if (substr( $md5, 0, 5) eq '00000') {
		my ($pos, $char) = split '' => substr( $md5, 5, 2);
		# print $char;
		if ($pos !~ $qr) { $i++; next };
		print "$pos / $char\n";
		$s[$pos] = $char unless (defined $s[$pos]);
		last if (scalar (grep {defined($_)} @s) == 8);

	}
	$i++;
}

print join '' => @s;
