#!/usr/bin/perl -w

use SOAP::Lite;

#####################################################
# create-users.pl
# -----------------------
# Steve Swinsburg (s.swinsburg@lancaster.ac.uk)
#
# A script for adding a bunch of users accounts to Sakai
#
# Use of this script is entirely at your own risk.
# Run test-connection.pl first if you are not sure.
#
# REQUIREMENTS:
# 1. web services enabled on your Sakai box.
# 2. SOAP::List perl Module (perl -MCPAN -e 'install SOAP::Lite')
# 3. correct settings in this script, see below.
#
#####################################################

##################### EDIT HERE #####################

my $user = 'admin';
my $password = 'XXXXXXXXXXXXX';

my $loginURI = 'http://XXXXXXXXXXXXX:8080/sakai-axis/SakaiLogin.jws?wsdl';
my $scriptURI = 'http://XXXXXXXXXXXXXX:8080/sakai-axis/SakaiScript.jws?wsdl';

my $file = 'data/users.csv';

############## DO NOT EDIT BELOW HERE ###############








#START
print "\n";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

my $scriptsoap = SOAP::Lite
-> proxy($scriptURI)
-> uri($scriptURI);

#get session
my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";

#read file
open FILE, $file or die $!;
while (<FILE>) {
	@parts = split(/,/, $_);

	my $user = $parts[0];
	my $fname = $parts[1];
	my $lname = $parts[2];
	my $email = $parts[3];
	my $type = $parts[4];
	my $password = $parts[5];

	print "creating user: " . $user . "...";
	
	#my $result = $scriptsoap->addNewUser($session, $user, $fname, $lname, $email, $type, $password)->result;
	
	print $result . "\n";
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";


#END
print "\n";
exit;