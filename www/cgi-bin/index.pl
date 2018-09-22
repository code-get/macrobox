#!/usr/bin/perl -wT
 
my $time        = localtime;
my $remote_id   = $ENV{REMOTE_HOST} || $ENV{REMOTE_ADDR};
my $admin_email = $ENV{SERVER_ADMIN};
 
print "Content-type: text/html\n\n";
print <<END_OF_PAGE;
<!DOCTYPE html>
<html>
<head>
   <title>Welcome</title>
</head>
<body>
   <h1>Welcome</h1>
</body>
</html>
END_OF_PAGE

