#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Getopt::Std;
use vars qw($opt_h $opt_i $opt_o $opt_m);
&getopts('hi:o:t:m:');

my $usage = <<_EOH_;

## Options ###########################################
## Required:
# -i    input binary-PLINK prefix
# -o    output file
# -m    HIBAG model file

## Optional:
#

## Others:
# -h print help

_EOH_
    ;

die $usage if $opt_h;

# Get command line options
my $prefix  = $opt_i or die $usage;
my $outfile = $opt_o or die $usage;
my $model   = $opt_m or die $usage;

my $filename = basename($prefix);

#
my $Rfile = "/tmp/" . $filename . ".R";
open R, ">$Rfile" or die "Can't open the file [ $Rfile ].\n";
print R ""
    . 'library(HIBAG)' . "\n"
    . 'model.list <- get(load("' . $model . '"))' . "\n"
    . 'mygeno <- hlaBED2Geno(bed.fn="' . $prefix . '.bed", ' . "\n"
    . '                      fam.fn="' . $prefix . '.fam", ' . "\n"
    . '                      bim.fn="' . $prefix . '.bim")' . "\n"
    . 'hla.ids <- names(model.list)' . "\n"
    . 'for(hla.id in hla.ids) {' . "\n"
    . '  model <- hlaModelFromObj(model.list[[hla.id]])' . "\n"
    . '  summary(model)' . "\n"
    . '  cbind(frequency = model$hla.freq)' . "\n"
    . '  pred.guess <- predict(model, mygeno, type="response+prob")' . "\n"
    . '  summary(pred.guess)' . "\n"
    . '  write.table(pred.guess$value, file=paste0("' . $outfile . '", "_HLAtype_", hla.id, ".txt"), col.names=T, row.names=F, quote=F, sep="\t")' . "\n"
    . '}' . "\n";
close R;

system "R CMD BATCH $Rfile";
