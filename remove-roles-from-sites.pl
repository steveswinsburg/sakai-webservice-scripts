#!/usr/bin/perl -w

#use lib qw(/home/sakai/lib/); 
use SOAP::Lite;


my $user = 'admin';
my $password = 'XXXXXXXXX';

my $loginURI = "http://XXXXXXXXXXXX:8080/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "http://XXXXXXXXXXXXX:8080/sakai-axis/SakaiScript.jws?wsdl";

my @toSites = (
"/site/05326ef9-9e64-4dd9-abab-19fa06cb5890",                                                                                                                                            
"/site/Social _ Ethical Issues",                                                                             
"/site/f0d1e341-b10e-4d02-805f-af311572dd7d",                                                                
"/site/a142dac9-ab02-4102-8037-372001d744f6",                                                                
"/site/_Web 2.0_",                                                                                           
"/site/TMFA",                                                                                                
"/site/243a1fd0-770e-437f-0012-4f371cc59341",                                                                
"/site/myexperiment",                                                                                        
"/site/GENESIS",                                                                                             
"/site/mass",                                                                                                
"/site/a85ffaa1-eb48-4eac-806b-434daf910ea9",                                                                
"/site/NCeSS Hub",                                                                                           
"/site/0f658b31-6e15-49d4-8053-ea5c6373a57a",                                                                
"/site/51282705-e980-491c-8067-01b52ba027ce",                                                                
"/site/Mapping",                                                                                             
"/site/moses",                                                                                               
"/site/18e05b54-6c2e-4963-80a1-b56ef16ec87b",                                                                
"/site/0ce6e719-85c8-4972-009d-fbbfc9df0b7e",                                                                
"/site/7fe7cf29-eee9-4897-0021-72ea0f5d21cb",                                                                
"/site/e675fc96-d2c6-46e9-80e3-05e2324780dd",                                                                
"/site/7d5b2ad4-f9d4-478c-8012-119438c42642",                                                                
"/site/a53a944c-b06e-47b5-00bf-22867784f4cc",                                                                
"/site/e0a91f21-ac27-4627-0070-877684533fad",                                                                
"/site/stats",                                                                                               
"/site/5b7cc6d5-fcd4-49d2-ad64-3eb58ca819d1",                                                                
"/site/2e70ff16-5373-4829-983b-220d5b59ede9",                                                                
"/site/11f7b1d8-e31f-4f47-a18d-d1d258bca60d",                                                                
"/site/redress",                                                                                             
"/site/temp",                                                                                                
"/site/ncess",                                                                                               
"/site/76643474-ca4e-4779-87c2-849394e5b8e7",                                                                
"/site/e8e90e44-4c0f-4dd5-998e-cbcc8dc7e78c",                                                                
"/site/e4f3d17d-cdaf-4f0b-a093-8f5689851ce1",                                                                
"/site/47fa2e55-3e53-4306-a6ca-2016825e9381",                                                                
"/site/005d00b9-c40b-4670-9884-31def5d5860c",                                                                
"/site/7118fd8c-78f1-4b2a-862e-dbf9819060c4",                                                                
"/site/3203a720-6e0d-44e1-b5e1-24a5cd190410",                                                                
"/site/900244b0-a4bb-43c9-9894-d7d2b79be4a6"
);

my @rolesToRemove = ("member", "commit");



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
	
	foreach $role(@rolesToRemove) {
		print "\t removing role: " . $role . "...";
		my $result = $scriptsoap->removeRoleFromAuthzGroup($session, $site, $role)->result;
		print $result . "\n";
	}
}

# logout
my $logout = $loginsoap->logout($session)->result;
print "logging out: " . $logout . "\n";


#END
print "\n";
exit;