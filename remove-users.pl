#!/usr/bin/perl -w

use SOAP::Lite;

#####################################################
# remove-users.pl
# -----------------------
# Steve Swinsburg (s.swinsburg@lancaster.ac.uk)
#
# A script for deleting a bunch of users accounts from Sakai
#
# Use of this script is entirely at your own risk.
# Run test-connection.pl first if you are not sure.
#
# REQUIREMENTS:
# 1. web services enabled on your Sakai box.
# 2. SOAP::List perl Module (perl -MCPAN -e 'install SOAP::Lite')
# 3. If accessing Sakai via https, also install Crypt:SSLeay (perl -MCPAN -e 'install Crypt::SSLeay')
# 4. correct settings in this script, see below.
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

#get session
my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";

#read file
open FILE, "data/users.csv" or die $!;
while (<FILE>) {
	@parts = split(/,/, $_);

	my $user = $parts[0];

	print "removing user: " . $user . "...";
	
	#uncomment this to actually add the user, currently it just tests.
	#my $result = $scriptsoap->removeUser($session, $user)->result;
	
	print $result . "\n";
}
close(FILE);

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";


#END
print "\n";
exit;