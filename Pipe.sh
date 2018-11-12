###Calculate the expression and read coverage for each 3'UTR isoform

for i in 4NQO Diauxic HS Control YMC1 YMC2 YMC3 YMC4
do
perl Cal_TPM.pl $i
done

### Merge all expression files from previous step

cat Yeast_3UTR_Expression.Control.txt Yeast_3UTR_Expression.4NQO.txt Yeast_3UTR_Expression.Diauxic.txt Yeast_3UTR_Expression.HS.txt Yeast_3UTR_Expression.YMC1.txt Yeast_3UTR_Expression.YMC2.txt Yeast_3UTR_Expression.YMC3.txt Yeast_3UTR_Expression.YMC4.txt > Yeast_3UTR_Expression.All.txt
sort -k1,1 -k2,2n Yeast_3UTR_Expression.All.txt -o Yeast_3UTR_Expression.All.txt

