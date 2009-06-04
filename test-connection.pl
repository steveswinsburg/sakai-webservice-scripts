#!/usr/bin/perl -w

use SOAP::Lite;

#####################################################
# test-connection.pl
# -----------------------
# Steve Swinsburg (s.swinsburg@lancaster.ac.uk)
#
# Simple script for testing if your webservices are up.
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

############## DO NOT EDIT BELOW HERE ###############








#START
print "\n";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

#get session
my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";

#END
print "\n";
exit;