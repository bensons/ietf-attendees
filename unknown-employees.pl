#!/usr/bin/perl

use HTML::TableExtract;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

$authorstatsURL = 'http://www.arkko.com/tools/allstats/authors.html';

$asHTML = get($authorstatsURL) or die("Cannot load authorstats index");
$asXML = XMLin($asHTML);
$asList = $asXML->{body}->{div}->{table}->{tbody}->{tr}->{td}->[1]->{div}->[1]->{table}->{tbody}->{tr}->{td}->{ul}->{li};
foreach $a (@$asList){
  my $link = $a->[0]->{href};
  my $name = $a->[0]->{content};
}

exit();

open(IETF,$ARGV[0]) or die();
@html = <IETF>;
close(IETF);
foreach(@html){ $text = $text . $_; }

$te = HTML::TableExtract->new();
$te->parse($text);

foreach $ts ($te->tables) {
  if($ts->coords eq (1,1)){
    foreach $row ($ts->rows) {
      $org = lc($$row[2]);
      $org =~ s/\ //g;
      if($org =~ m/^$/){
        print("$$row[1] $$row[0] ($$row[2])\n");
      }
    }
  }
}



