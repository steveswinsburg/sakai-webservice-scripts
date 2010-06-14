#! /usr/bin/perl

# Script to migrate SAKAI_EVENT and SAKAI_SESSION information to another database
#
# Note that SESSION_HOSTNAME is non-standard and is not in OOTB the Sakai SAKAI_SESSION table
# (c/f http://jira.sakaiproject.org/jira/browse/SAK-6216)

use DBI;

require "/usr/local/sakaiconfig/dbauth.pl";

(my $host1, my $dbname1, my $user1, my $password1)= getProductionDbAuth ();
(my $host2, my $dbname2, my $user2, my $password2)= getArchiveDbAuth ();

my $debug = 0;

### Connect to dbs

$dbh1 = DBI->connect("DBI:mysql:database=$dbname1;host=$host1;port=3306", $user1, $password1) 
	|| die "Could not connect to production database $dbname1: $DBI::errstr";

$dbh2 = DBI->connect("DBI:mysql:database=$dbname2;host=$host2;port=3306", $user2, $password2)
	|| die "Could not connect to archive database $dbname2: $DBI::errstr";

# Archive everything > 24 hours old (86400 seconds)

my $archive_delay = 60*60*24;
my $timenow = time - $archive_delay;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timenow);

my $isotime = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec);

if ($debug) {
  print "archiving events and sessions before $isotime\n";
}

my $events_migrated = migrate_events($dbh1, $dbh2, $isotime);
my $session_migrated = migrate_session($dbh1, $dbh2, $isotime);

if ($debug) {
  print "Events migrated: $events_migrated\n";
  print "Sessions migrated: $session_migrated\n";
}

$dbh1->disconnect();
$dbh2->disconnect();

sub migrate_events( $$$ )
{
  my $dbh1 = shift;
  my $dbh2 = shift;
  my $targetdate = shift;

  my $rows_migrated;

  ## Note that we don't migrate EVENT_ID here.

  my $eventfields = "EVENT_DATE, EVENT, REF, SESSION_ID, EVENT_CODE";
  my $src_table = "SAKAI_EVENT";
  my $dest_table = "SAKAI_EVENT_ARCHIVE";

  $dbh2->do('set autocommit=0');

  my $eventsql = "SELECT $eventfields FROM $src_table WHERE EVENT_DATE < ?";
  my $sth1 = $dbh1->prepare($eventsql) or die "Couldn't prepare statement: " . $dbh1->errstr;

  my $insertsql = "INSERT INTO $dest_table ($eventfields) VALUES (?, ?, ?, ?, ?)";
  my $sth2 = $dbh2->prepare($insertsql) or die "Couldn't prepare statement: " . $dbh2->errstr;

  if ($debug) {
    # print "Archive query (bind $isotime): $eventsql\n";
  }

  $sth1->execute($targetdate)             # Execute the query
     or die "Couldn't execute statement: " . $sth->errstr;

  my $errors = 0;

  # Copy the records from db1 into db2
  while (@data = $sth1->fetchrow_array()) {
	if (!$sth2->execute($data[0], $data[1], $data[2], $data[3], $data[4])) {
		$errors++;
	}
  }

  $rows_migrated =  $sth1->rows;

  $sth1->finish;
  $sth2->finish;

  $dbh2->do('commit');

  if (!$errors) {
    $sth1 = $dbh1->prepare("DELETE FROM $src_table WHERE EVENT_DATE < ?");
    $sth1->execute($targetdate);
    $sth1->finish;
  } else {
   print "Errors migrating data: not deleting\n";
  }

 return $errors ? 0 : $rows_migrated;
}

sub migrate_session( $$$ )
{
  my $dbh1 = shift;
  my $dbh2 = shift;
  my $targetdate = shift;

  my $rows_migrated;

  my $sessionfields = "SESSION_ID, SESSION_SERVER, SESSION_USER, SESSION_IP, SESSION_USER_AGENT, SESSION_START, SESSION_END, SESSION_HOSTNAME ";
  my $src_table = "SAKAI_SESSION";
  my $dest_table = "SAKAI_SESSION_ARCHIVE";

  $dbh2->do('set autocommit=0'); 
  my $eventsql = "SELECT $sessionfields FROM $src_table WHERE SESSION_START < SESSION_END AND SESSION_END < ?";
  my $sth1 = $dbh1->prepare($eventsql) or die "Couldn't prepare statement: " . $dbh1->errstr;

  my $insertsql = "INSERT INTO $dest_table ($sessionfields) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
  my $sth2 = $dbh2->prepare($insertsql) or die "Couldn't prepare statement: " . $dbh2->errstr;

  $sth1->execute($targetdate)             # Execute the query
     or die "Couldn't execute statement: " . $sth->errstr;

  my $errors = 0;

  # Copy the records from db1 into db2
  while (@data = $sth1->fetchrow_array()) {
        if (!$sth2->execute($data[0], $data[1], $data[2], $data[3], $data[4], $data[5], $data[6], $data[7])) {
                $errors++;
        }
 }

  $rows_migrated =  $sth1->rows;

  $sth1->finish;
  $sth2->finish;

  $dbh2->do('commit');

 if (!$errors) {
    $sth1 = $dbh1->prepare("DELETE FROM $src_table WHERE SESSION_START < SESSION_END AND SESSION_END < ?");
    $sth1->execute($targetdate);
    $sth1->finish;
  } else {
   print "Errors migrating data: not deleting\n";
  }

  return $errors ? 0 : $rows_migrated;
}
