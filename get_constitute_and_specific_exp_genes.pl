#!/usr/bin/perl

open IN, "< Yeast_3UTR_Expression.All.1.txt";
open OT, "> Yeast_3UTR_Constitute_Genes.txt";

$line = <IN>;
print OT $line;
$k = 0;$m = 0;$n = 0;
while (<IN>) {
   chomp;
   @aa = split /\t/, $_;
   push @values, $_;
   $k++;
   if ($aa[10] >= 5) {
      $m++;
   } elsif ($aa[10] <= 1) {
      $n++;
   }
   if ($k == 1) {
      $gene = $aa[3];
   }
   if ($k == 8 and $m >= 7) {
      for ($i=0;$i<=$#values;$i++) {
         print OT "$values[$i]\n";
      }
      $constitute++;
      $k = 0;$m = 0;$n = 0;@values = ();
   } elsif ($k == 8 and $m == 1 and $n >= 6) {
      $specific++;
      $k = 0;$m = 0;$n = 0;@values = ();
   } elsif ($k == 8) {
      $k = 0;$m = 0;$n = 0;@values = ();
      if ($gene ne $aa[3]) {
          print "Wrong\t$_\n";
      }
   } else {
      if ($gene ne $aa[3]) {
          print "Wrong\t$_\n";
      }
   }
}

print "Constitute genes: $constitute\nSpecific genes: $specific\n";
