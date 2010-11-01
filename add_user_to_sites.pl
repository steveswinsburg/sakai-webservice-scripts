#!/usr/bin/perl -w

# Add a user with a specified role to sites listed in a file: data/siteids.csv. 

use SOAP::Lite;

##################### EDIT HERE #####################

my $user = 'admin-user';
my $password = 'password';

my $loginURI = "[your server]/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "[your server]/sakai-axis/SakaiScript.jws?wsdl";

my $role = "Instructor";
my $eid = "username";

############## DO NOT EDIT BELOW HERE ###############


#START
print "\n";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

my $scriptsoap = SOAP::Lite
-> proxy($scriptURI)
-> uri($scriptURI);

my $ua = LWP::UserAgent->new( timeout => 90 );

my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";


#read file
open FILE, "data/siteids.csv" or die $!;
while (<FILE>) {
	@parts = split(/,/, $_);
	my $site = $parts[0];

	print "processing site: " . $site . "\n";
	
	print "\t Adding user: " . $eid . " as role: " . $role . "...";
	my $result = $scriptsoap->addMemberToSiteWithRole($session, $site, $eid, $role)->result;
	print $result . "\n";
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";

#END
print "\n";
exit;
