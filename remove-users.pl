#!/usr/bin/perl -w

use SOAP::Lite;


my $user = 'admin';
my $password = 'admin';

my $loginURI = "http://btc222000003.lancs.ac.uk:8083/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "http://btc222000003.lancs.ac.uk:8083/sakai-axis/SakaiScript.jws?wsdl";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

my $scriptsoap = SOAP::Lite
-> proxy($scriptURI)
-> uri($scriptURI);



#START
print "\n";

#get session
my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";

#read file
open FILE, "data/users.csv" or die $!;
while (<FILE>) {
	@parts = split(/,/, $_);

	my $user = $parts[0];

	print "removing user: " . $user . "...";
	
	my $result = $scriptsoap->removeUser($session, $user)->result;
	
	print $result . "\n";
}
close(FILE);

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";


#END
print "\n";
exit;