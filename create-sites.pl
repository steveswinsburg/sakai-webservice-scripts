#!/usr/bin/perl -w

use SOAP::Lite;

#####################################################
# create-sites.pl
# -----------------------
# Steve Swinsburg (s.teve.swinsburg@gmail.com)
#
# A script for adding a bunch of sites to Sakai
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
my $password = 'admin';

my $loginURI = 'http://localhost:8080/sakai-axis/SakaiLogin.jws?wsdl';
my $scriptURI = 'http://localhost:8080/sakai-axis/SakaiScript.jws?wsdl';

my $file = 'data/sites-10000.csv';

my $templateSiteId = '1416c38c-f90b-434d-b9c1-96f50b9e31cf';

############## DO NOT EDIT BELOW HERE ###############








#START
print "\n";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

my $scriptsoap = SOAP::Lite
-> proxy($scriptURI)
-> uri($scriptURI);

my $true = SOAP::Data->value('true')->type('boolean');
my $false = SOAP::Data->value('')->type('boolean');

#get session
my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";

#read file
open FILE, $file or die $!;
while (my $line = <FILE>) {
	
	chomp($line);
	@parts = split(/,/, $line);

	my $siteId = $parts[0];
	my $siteTitle = $parts[1];

	print "creating site: " . $siteId . "...";
	
	#uncomment this to actually create the site, currently it just tests.
	my $result = $scriptsoap->copySite($session, $templateSiteId, $siteId, $siteTitle, $siteTitle, $siteTitle, '', '', $false, '', $true, $false, '', 'project')->result;
	#### params are: String sessionid, String siteidtocopy, String newsiteid, String title, String description, String shortdesc, String iconurl, String infourl, boolean joinable, String joinerrole, boolean published, boolean publicview, String skin, String type

	print $result . "\n";
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";


#END
print "\n";
exit;