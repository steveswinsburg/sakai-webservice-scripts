#!/usr/bin/perl

#web service test




################################################################################
# INCLUDES
################################################################################

use lib qw(../lib/); 	#locally installed set of Perl modules

use warnings;		# warnings for log files etc - can turn off after testing - could also use -w switch up top but this is easier to get to!

use Switch;			# provides Perl case/switch statement support
use XML::Simple;	# provides XML parsing and generation support
use Data::Dumper;	# provides easy printout for arrays and hashes
use LWP::UserAgent; 
use HTTP::Request; 
use HTTP::Response;
use Crypt::SSLeay;


################################################################################
# GO
################################################################################

my $url = 'https://web-services-dev.une.edu.au/class-list/245612';
print $url."\n";
			
						
#@args = ("wget", "--no-check-certificate", $url);
#my $content = system(@args) == 0 or warn "system @args failed: $?";

=pod			
if ($? == -1) {
	print "failed to execute: $!\n";
} elsif ($? & 127) {
	printf "child died with signal %d, %s coredump\n", ($? & 127),  ($? & 128) ? 'with' : 'without';
}
else {
	printf "child exited with value %d\n", $? >> 8;
}
=cut			
#print $content;
#exit;

			
my $ua = LWP::UserAgent->new(); 
$ua->agent("TLCadmin/1.0");

my $req = HTTP::Request->new(GET => $url); 
										 
my $response = $ua->request($req);

#print Dumper($response);


if ($response->is_success) {
	print $response->as_string;
} else {
	print "Failed: ", $response->status_line, "\n";
}
#if ($response->is_error()) {
#	 printf " %s\n", $response->status_line;
#} else {
#	 my $count;
#	 my $bytes;
#	 my $content = $response->content();
#	 $bytes = length $content;
#	 $count = ($content =~ tr/\n/\n/);
#	 printf "%s (%d lines, %d bytes)\n", $response->title(), $count, $bytes; } 
					
#}


