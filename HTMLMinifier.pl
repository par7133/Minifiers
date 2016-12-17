#!/usr/bin/perl
#
# HTMLMinifer v1.0 
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Daniele Bonini
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in the 
# Software without restriction, including without limitation the rights to use, 
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
# Software, and to permit persons to whom the Software is furnished to do so, subject 
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

use strict;
use warnings;

print "HTMLMinifier v1.0.\n"; 
print "Copyright 2014 Daniele Bonini. All rights reserved.\n";  
print "Author: Daniele Bonini\n";
print "Creation Date: Jun 27th, 2014\n";
print "Started at ", scalar(localtime), "\n";

# Initialization of the minifier components
use HTML::Packer;

my $HTMLpacker = HTML::Packer->init();

# Check of the arguments passed to the script
if (! $ARGV[0]) {
   print "\n\n";
   print "Invalid argument, source file is required!";
   print "\n";
   exit 1;
}
my $sourcefile = $ARGV[0];

my $destinationfile;
if ($ARGV[1]) {
  $destinationfile = $ARGV[1];
}
else {
  $destinationfile = $sourcefile . "m";
}

print "Source file: \'", $sourcefile, "\'\n";
print "Destination file: \'", $destinationfile, "\'\n";

# Check if the source file exists
if (! -T $sourcefile) {
   print "\n\n";
   print "Source file doesn't exist!";
   print "\n";
   exit 1;
}

# Check if the destinaton file exists
if (-T $destinationfile) {
   my $replace="";
   while (($replace ne "Y") && ($replace ne "N")) {
     print "\n\n";
     print "Destination file \'$destinationfile\' already exists. Do you want to continue and replace it? (Y/N)\n";
     chomp($replace=<STDIN>);
     if (uc($replace) eq "N") {
       exit 0;
     }
     last if (uc($replace) eq "Y");
   }
}

my @sourcetexta;
my $sourcetext;
my $minifiedtext;

# Read source file
open(SFILEH, $sourcefile) || die "Error accessing the source file \'$sourcefile\': $!";
if (! (@sourcetexta=<SFILEH>)) {
    die "Error reading the source file \'$sourcefile\': $!";
}
close(SFILEH);

print "\n";
print "Processing data..", "\n", "\n";

# Map the array of the source text to a string scalar to align to the 
# packer->minify method definition requirements
my $i;
for( $i=0; $i<=$#sourcetexta; $i=$i+1 ) {
  $sourcetext.=$sourcetexta[$i];
}

# Execute the minification
my $opts = {
    remove_comments       => 1,
    remove_newlines       => 1,
    do_javascript         => "best",
    do_stylesheet         => 0,
    no_compress_comment   => 1,
  };  
$minifiedtext = $HTMLpacker->minify( \$sourcetext, $opts );

# Output the result to the console
print $minifiedtext, "\n";

# Write the result to the destination file..
print "\n", "\n";
print "Saving to \'" . $destinationfile . "\'...", "\n";
print "\n", "\n";

open(DFILEH, ">$destinationfile") || die "Error creating the destination file \'$destinationfile\': $!";
if (! print DFILEH $minifiedtext, "\n" ) {
    die "Error saving the resulting data to \'$destinationfile\': $!";
}
close(DFILEH);

# Ending..
print "\n", "\n";
print "OK, done!";

exit 0;
