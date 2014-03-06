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

my %vendor;
my %attend;
foreach my $meeting (74..$ARGV[0]){
  my %cnt;
  my $text;
  open(IETF,"ietf$meeting.html") or die();
  my @html = <IETF>;
  close(IETF);
  foreach(@html){ $text = $text . $_; }
  my $te = HTML::TableExtract->new();
  $te->parse($text);
  foreach my $ts ($te->tables) {
    if($ts->coords eq (1,1)){
      foreach my $row ($ts->rows) {
        my $org = lc($$row[2]);
        $cnt{$org}++;
        $attend{$meeting}++;
      }
    }
  }
  foreach(keys(%cnt)){
    # Unknown
    if($_ =~ m/^$/){ $vendor{unknown}{$meeting} += $cnt{$_}; }
    # Cisco
    elsif($_ =~ m/cisco/){ $vendor{cisco}{$meeting} += $cnt{$_}; }
    # Huawei
    elsif($_ =~ m/huawei/){ $vendor{huawei}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/futurewei/){ $vendor{huawei}{$meeting} += $cnt{$_}; }
    # Juniper
    elsif($_ =~ m/juniper/){ $vendor{juniper}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/contrail/){ $vendor{juniper}{$meeting} += $cnt{$_}; }
    # Ericsson
    elsif($_ =~ m/ericsson/){ $vendor{ericsson}{$meeting} += $cnt{$_}; }
    # ZTE
    elsif($_ =~ m/^zte /){ $vendor{zte}{$meeting} += $cnt{$_}; }
    # Nokia
    elsif($_ =~ m/nokia/){ $vendor{nsn}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/^nsn/){ $vendor{nsn}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/siemens/){ $vendor{nsn}{$meeting} += $cnt{$_}; }
    # Alcatel
    elsif($_ =~ m/alcatel/){ $vendor{alcatel}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/lucent/){ $vendor{alcatel}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/bell lab/){ $vendor{alcatel}{$meeting} += $cnt{$_}; }
    # Google
    elsif($_ =~ m/google/){ $vendor{google}{$meeting} += $cnt{$_}; }
    # Infinera
    elsif($_ =~ m/infinera/){ $vendor{infinera}{$meeting} += $cnt{$_}; }
    # Brocade
    elsif($_ =~ m/brocade/){ $vendor{brocade}{$meeting} += $cnt{$_}; }
    elsif($_ =~ m/vyatta/){ $vendor{brocade}{$meeting} += $cnt{$_}; }
    # Microsoft
    elsif($_ =~ m/microsoft/){ $vendor{microsoft}{$meeting} += $cnt{$_}; }
  }
  undef(%cnt);
}

print("Company");
foreach $meeting (74..$ARGV[0]){
  print(",IETF-$meeting");
}
print("\n");
foreach $company (sort keys(%vendor)){
  print("$company");
  foreach $meeting (74..$ARGV[0]){
    if($vendor{$company}{$meeting}){
      print(",$vendor{$company}{$meeting}");
    }else{ print(",0"); }
  }
  print("\n");
}
print("Total");
foreach $meeting (74..$ARGV[0]){
  print(",$attend{$meeting}");
}
print("\n");

