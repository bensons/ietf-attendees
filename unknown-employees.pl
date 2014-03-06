#!/usr/bin/perl
#
#    ietf-attendee - tools to count IETF attendees from various companies
#    Copyright (C) 2014 Benson Schliesser, All Rights Reserved
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
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



