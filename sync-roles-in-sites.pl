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
# 3. correct settings in this script, see below.
#
#####################################################

##################### EDIT HERE #####################

my $user = 'admin';
my $password = 'XXXXXXXXXXXXX';

my $loginURI = 'http://XXXXXXXXXXXXX:8080/sakai-axis/SakaiLogin.jws?wsdl';
my $scriptURI = 'http://XXXXXXXXXXXXXX:8080/sakai-axis/SakaiScript.jws?wsdl';

my $templateSite = '!site.template';
my @toSites = (
"/site/05326ef9-9e64-4dd9-abab-19fa06cb5890",                                                                                                                                            
"/site/Social _ Ethical Issues",                                                                             
"/site/f0d1e341-b10e-4d02-805f-af311572dd7d",                                                                
"/site/a142dac9-ab02-4102-8037-372001d744f6",                                                                                                                                                            
"/site/76643474-ca4e-4779-87c2-849394e5b8e7",                                                                
"/site/e8e90e44-4c0f-4dd5-998e-cbcc8dc7e78c",                                                                
"/site/e4f3d17d-cdaf-4f0b-a093-8f5689851ce1",                                                                
"/site/47fa2e55-3e53-4306-a6ca-2016825e9381",                                                                
"/site/005d00b9-c40b-4670-9884-31def5d5860c",                                                                
"/site/7118fd8c-78f1-4b2a-862e-dbf9819060c4",                                                                
"/site/3203a720-6e0d-44e1-b5e1-24a5cd190410",                                                                
"/site/900244b0-a4bb-43c9-9894-d7d2b79be4a6"
);

my @roles = ("access", "maintain", "readonly", "privileged");


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
	
	foreach $role(@roles) {
		print "\t synchronising role: " . $role . "...";
		my $result = $scriptsoap->copyRole($session, $templateSite, $site, $role)->result;
		print $result . "\n";
	}
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";

#END
print "\n";
exit;