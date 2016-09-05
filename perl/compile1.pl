#!/usr/local/bin/perl

# CGI script that compiles a Perl script
# and checks syntax.

use CGI qw/:standard/;
print header,
      start_html('Perl Script Checker'),
      h1('Perl Script Compiler'),
      start_form,
      "Script name: ",textfield('scriptName'),p,
      "Compile only (include -c flag) ? ", 
      checkbox_group(-name     =>'compile',
                     -values   =>['on'],
                     -defaults =>['on']), p,
      submit,
      end_form,
      hr;

if (param()) {
    $scriptName = param('scriptName');
    $scriptName =~ m{(.*)/([^/]*)}o;
    ($dir, $file) = ($1, $2);

    if ($dir eq "/cgi-bin") {
        $dir = "/usr/local/apache/cgi-bin";
    }
    elsif ($dir eq "/fcgi") {
        $dir = "/usr/local/apache/fcgi-bin";
    }
    else {
        $dir = "/usr/local/apache/htdocs" . $dir;
    }

    $output1 = `cd ${dir}`;
    $compile = "c" if param('compile');
    $perl    = '/usr/local/bin/perl';
    $options = '-' . ${compile} . 'w';
    $output2 = `${perl} ${options} ./${file} 2>&1`;
    print pre($output2), "\n";
}
