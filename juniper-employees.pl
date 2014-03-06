#!/usr/bin/perl

use HTML::TableExtract;

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
      if($org =~ m/^juniper/){
        print("$$row[1] $$row[0] ($$row[2])\n");
      }
    }
  }
}



