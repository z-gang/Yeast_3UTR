#!/usr/bin/perl
### Usage: perl Cal_TPM.pl $sample

$sample = $ARGV[0]; ## 4NQO, HS, C1, C2...
open OT, "> Yeast_3UTR_Expression.$sample.txt";

$sum = 0;
foreach $p ("pos","neg") {
   open IN1, "< ../FindPeaks/peaks_${p}_strand.readcounts.$sample.bed";
   while (<IN1>) {
      chomp;
      @aa = split /\t/, $_;
      $d = ($aa[2] - $aa[1] + 1)/1000;
      if ($p eq "pos") {
         $region = $aa[0]."_".$aa[1]."_".$aa[5];
      } else {
         $region = $aa[0]."_".$aa[2]."_".$aa[5];
      }
      $rpk{$region} = $aa[6]/$d;
      $read{$region} = $aa[6];
      $sum += $aa[6]/$d;
   }
   close IN1;
}

$scale = $sum/1000000;

open IN2, "< ../PeakSummary/Yeast_3UTR_Peaks.Summary.txt";
$line1 = <IN2>;
while (<IN2>) {
   chomp;
   @aa = split /\t/, $_;
   $region = $aa[1]."_".$aa[2];
   $hash{$aa[3]} = $region;
}

open IN3, "< ../PeakSummary/Yeast_3UTR_Peaks.Final.bed";
$line2 = <IN3>;
while (<IN3>) {
   chomp;
   @aa = split /\t/, $_;
   @bb = split /\_/, $aa[3];
   @cc = split /\_/, $hash{$bb[0]};
   if ($aa[5] eq "+") {
      $region = $aa[0]."_".$aa[1]."_".$aa[5];
      $d = $aa[2] - $cc[1];
   } else {
      $region = $aa[0]."_".$aa[2]."_".$aa[5];
      $d = $cc[0] - $aa[1];
   }
   if ($rpk{$region} eq undef) {
      print "Wrong\t$_\n";
      next;
   }
   $tpm = $rpk{$region}/$scale;
   push @{$bb[0]}, $region;
   $exp{$region} = $tpm;
   $distance{$region} = $d;
}
close IN2;close IN3;

open IN4, "< ../PeakSummary/Yeast_3UTR_Peaks.Summary.txt";
chomp($line3 = <IN4>);
print OT "$line3\tSample\tTotalExp\tSUI\tLUI\tGroup\n";
while (<IN4>) {
   chomp;
   @aa = split /\t/, $_;
   @sorted = sort {$distance{$a} <=> $distance{$b}} @{$aa[3]};
   $sum_tpm = 0;$sum_reads = 0;
   for ($i=0;$i<=$#{$aa[3]};$i++) {
      $sum_tpm += $exp{${$aa[3]}[$i]};
      $sum_reads += $read{${$aa[3]}[$i]};
   }
   if ($sum_reads == 0) {
      print "$_\n";
      $sui = "NA";$lui = "NA";
   } else {
      $sui = $read{$sorted[0]}/$sum_reads;
      $lui = $read{$sorted[-1]}/$sum_reads;
   }
   print OT "$aa[0]\t$aa[1]\t$aa[2]\t$aa[3]\t";
   if ($aa[4] == 5 or $aa[4] == 6) {
      print OT "\>4\t";
   } else {
      print OT "$aa[4]\t";
   }
   print OT "$aa[5]\t$aa[6]\t$aa[7]\t$aa[8]\t$sample\t$sum_tpm\t$sui\t$lui\t";
   if ($aa[4] == 1) {
      print OT "Single\n";
   } else {
      print OT "Multi\n";
   }
}

