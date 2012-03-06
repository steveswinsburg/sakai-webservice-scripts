#!/usr/bin/perl -w

use SOAP::Lite;

#####################################################
# sync-roles-in-sites.pl
# -----------------------
# Steve Swinsburg (s.swinsburg@lancaster.ac.uk)
#
# A script for synchronising roles and permissions 
# from a template site to sites.
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
my $password = 'XXXXXXXXX';

my $loginURI = 'http://XXXXXXXXXXXXXX:8080/sakai-axis/SakaiLogin.jws?wsdl';
my $scriptURI = 'http://XXXXXXXXXXXXXX:8080/sakai-axis/SakaiScript.jws?wsdl';

my $templateSite = '!site.template';
my @toSites = (
"/site/0033eee4-2cc3-4024-883f-98bb07bc2d29",
"/site/00444d19-2c66-4696-9da3-81ffadd830c3",
"/site/0044ae5e-7de5-4bd7-b21a-afd71b9caa83",
"/site/fff8a3bc-8046-4ebc-00c6-59ac16fa0d63"
);

my %roles = (
	access => 'Can read most contents and revise some contents as granted by the site maintainer.',
	maintain => 'Can read contents, revise, add, and delete both contents and participants in this site. Maintainers can do almost anything to this site, including deleting this site, remove other maintainers, and updating permissions for each tool.',
	contributor => 'Can read, revise, add, and delete most contents as granted by the site maintainer.',
	observer => 'Can read contents only. The least privilege.'
);

############## DO NOT EDIT BELOW HERE ###############









#START
print "\n";

my $loginsoap = SOAP::Lite
-> proxy($loginURI)
-> uri($loginURI);

my $scriptsoap = SOAP::Lite
-> proxy($scriptURI)
-> uri($scriptURI);

my $session = $loginsoap->login($user, $password)->result;
print "session is: " . $session . "\n";


foreach $site(@toSites) {
	print "processing site: " . $site . "\n";
	
	for my $role ( keys %roles ) {
        my $role_desc = $roles{$role};
   
		print "\t synchronising role: " . $role . "...";
		my $result = $scriptsoap->copyRole($session, $templateSite, $site, $role, $role_desc)->result;
		print $result . "\n";
	}
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";

#END
print "\n";
exit;