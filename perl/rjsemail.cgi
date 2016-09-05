# Archivists note:

   This script requires perl5


#!/usr/bin/perl -T
##
##  rjsemail.cgi - Simple, Safe, Generic CGI backend mail script.
##
##  by Robert Seymour <rseymour@rseymour.com>.
##     Copyright (c) 1995, 1996 Robert Seymour and Springer-Verlag.
##     All rights reserved, this script may be distributed in
##     electronic format and/or modified under the same terms as Perl 
##     itself.
##
##  CPAN menu entry:
#
# File Name: rjsemail.cgi
# File Size in BYTES: 5981
# Sender/Author/Poster: Robert J. Seymour <rseymour@rseymour.com>
# Subject: rjsemail.cgi - Simple, Safe, Generic CGI backend mail script.
#
# rjsemail.cgi provides a simple, safe, and generic backend for sending
# electronic mail from a CGI program.  This script is taint checked and
# does not allow insipid commands to be executed or information to be
# divulged through user inputted strings.  You can use this script as a
# common backend for all your mail sending (HTML page example included)
# or use it as a guide to safe use of subprocesses in CGI programs.


##  To use this script, you should create an HTML page (or script which 
##  generates an HTML page) with a submission form pointing to this  
script.
##  An example of this is shown below:
##
##  <HTML><HEAD><TITLE>Submit Feedback</TITLE></HEAD>
##  <BODY><H1>Submit Feedback</H1>
##  <p>Please feel free to enter in feedback below:</p>
##  <FORM METHOD="POST" ACTION="/cgi-bin/email.cgi">
##  <INPUT TYPE="HIDDEN" NAME="to" VALUE="webmaster@rseymour.com">
##  <P>Please enter in your email address:<BR>
##     <INPUT TYPE="TEXT" NAME="from" SIZE="40">
##  </P>
##  <P>Please input the subject of your message:<BR>
##     <INPUT TYPE="TEXT" NAME="subject" SIZE="40">
##  </P>
##  <P>Please input the body of the message:<BR>
##  <TEXTAREA NAME="body" ROWS="50" COLS="70">
##  </TEXTAREA>
##  <P><INPUT TYPE="SUBMIT" VALUE="Send Email">
##     <INPUT TYPE="RESET" VALUE="Reset Form">
##  </P>
##  </FORM>
##  </BODY>
##
##  You can also fix the subject header by making it a hidden field as 
##  well (and similarly for the other entries).  Note also that you need
##  not use the exact elements shown here, any HTML forms element which
##  generates a string as a value (i.e. selection lists, popup menus, or
##  others) will work.  Don't forget to the set the "to" email address
##  properly in your HTML page.


##  Use the CGI::* modules for CGI, log, and HTML processing.
use CGI::Carp;
use CGI::Form;
use strict;


##  Variable initializations (for use strict).
my($to,$admin,$from,$subject,$body,$sendmail,$query);

##  Where is sendmail located.
$sendmail = "/usr/lib/sendmail";

##  Set the path for security and taint checking.
$ENV{'PATH'} = "/usr/bin:/bin";


##  Create a new query object for CGI and HTML parsing.
$query = new CGI::Form();

##  If you want to hardcode any of these, just set them up by $sendmail
##  in the constants section, they will only be overriden if unset by
##  these statements.  You might also choose to append to the message
##  here to indicate that the from address is not verified.  In general,
##  I would advise you to set them in your pages, this lets the program
##  work for many different pages or submissions.
$to ||= $query->param("to");
$admin = $admin || $query->param("admin") || $query->param("to");
$from ||= $query->param("from");
$subject ||= $query->param("subject");
$body ||= $query->param("body");

##  Append a warning to the message about forgery and origin.
$body .= <<"EOHF";

--
Message sent via rjsemail.cgi, sender's address may be forged.

EOHF

##  Start sendmail taking input on STDIN to be sent off.  By using
##  sendmail -oit and writing to it with a here file (as below), we
##  avoid sh -c gotchas that backticks, system, or "| $mail $addr"
##  can fall victim to.  Searching for semi-colons isn't safe enough
##  and trying to scrub user inputted fields is both difficult and
##  hazardous.
open(MAIL,"| $sendmail -oi -t") || do {
  print $query->header();
  print $query->start_html(-title => "Error Sending Mail",
                           -author => $admin);
  print "<h1>Error Sending Mail</h1>\n";
  print "<p>Sendmail exited with error: $!, please go back in your\n";
  print "   browser and resubmit the email form or report the error\n";
  print qq/  to the administrator, <a  
href="mailto:$admin">$admin<\/a>"\n/;
  print "</p>\n";
  print $query->end_html(), "\n";
	
  ##  CGI::Carp makes semi-useful error entries in the httpd error log.
  die "Sendmail exited with error: $!\n";
};

##  Print message to sendmail filehandle.  Note that you can't create
##  a shell or escape out of this by entering in code to the text block 
##  or email fields (even backticks).  The to address is taken from the
##  submission form (use a hidden field) so that this same backend script
##  can service any number of HTML submission forms.
print MAIL <<"EOHF";
To: $to
From: $from
Subject: $subject
X-Mailer: rjsemail.cgi 1.0

$body
EOHF
close(MAIL);

##  Check exit status (the latter uses CGI::Carp).  Give the user
##  feedback through a HTML response.
if($?) {
  print $query->header();
  print $query->start_html(-title => "Error Sending Mail",
                           -author => $admin);
  print "<h1>Error Sending Mail</h1>\n";
  print "<p>Sendmail exited with error: $!, please go back in your\n";
  print "   browser and correct the email form or report the error\n";
  print qq/  to the administrator, <a  
href="mailto:$admin">&lt;$admin&gt;<\/a>"\n/;
  print "</p>\n";
  print $query->end_html(), "\n";
	
  ##  CGI::Carp makes semi-useful error logs in the httpd log.
  croak "Sendmail exited with error: $!\n";

} else {
  print $query->header();
  print $query->start_html(-title => "Thank You For Your Feedback",
                           -author => $admin);
  print "<h1>Thank Your For Your Feedback</h1>\n";
  print "<p>I appreciate your comments and will try to respond to\n";
  print "   your email shortly.\n</p>\n";
  print $query->end_html(), "\n";
}

##  End of rjsemail.cgi.
