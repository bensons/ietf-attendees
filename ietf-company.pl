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
      $cnt{$org}++;
    }
  }
}

sub cntSort {
  $cnt{$b} <=> $cnt{$a};
}
sub vendorSort {
  $vendor{$b} <=> $vendor{$a};
}

foreach(sort cntSort keys(%cnt)){
  print("$_ ($cnt{$_})\n");
  # Unknown
  if($_ =~ m/^$/){ $vendor{unknown} += $cnt{$_}; }
  # Cisco
  elsif($_ =~ m/cisco/){ $vendor{cisco} += $cnt{$_}; }
  # Huawei
  elsif($_ =~ m/huawei/){ $vendor{huawei} += $cnt{$_}; }
  elsif($_ =~ m/futurewei/){ $vendor{huawei} += $cnt{$_}; }
  # Juniper
  elsif($_ =~ m/juniper/){ $vendor{juniper} += $cnt{$_}; }
  elsif($_ =~ m/contrail/){ $vendor{juniper} += $cnt{$_}; }
  # Ericsson
  elsif($_ =~ m/ericsson/){ $vendor{ericsson} += $cnt{$_}; }
  # ZTE
  elsif($_ =~ m/zte /){ $vendor{zte} += $cnt{$_}; }
  # Nokia
  elsif($_ =~ m/nokia/){ $vendor{nsn} += $cnt{$_}; }
  elsif($_ =~ m/^nsn/){ $vendor{nsn} += $cnt{$_}; }
  elsif($_ =~ m/siemens/){ $vendor{nsn} += $cnt{$_}; }
  # Alcatel
  elsif($_ =~ m/alcatel/){ $vendor{alcatel} += $cnt{$_}; }
  elsif($_ =~ m/lucent/){ $vendor{alcatel} += $cnt{$_}; }
  elsif($_ =~ m/bell lab/){ $vendor{alcatel} += $cnt{$_}; }
  # Infinera
  elsif($_ =~ m/infinera/){ $vendor{infinera} += $cnt{$_}; }
  # Brocade
  elsif($_ =~ m/brocade/){ $vendor{brocade} += $cnt{$_}; }
  elsif($_ =~ m/vyatta/){ $vendor{brocade} += $cnt{$_}; }
  # Microsoft
  elsif($_ =~ m/microsoft/){ $vendor{microsoft} += $cnt{$_}; }

}
print("====\n");
foreach(sort vendorSort keys(%vendor)){
  print("$_ ($vendor{$_})\n");
}

