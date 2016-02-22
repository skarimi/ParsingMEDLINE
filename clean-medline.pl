#!/usr/bin/perl
use strict;
use utf8;
#use warnings;

# Author: Sarvnaz Karimi
# Code to clean MEDLINE files to extract title and abstracts 
# It's written to be used feed to gnsim worde2vec and therefore it concatinates all the text. 

use XML::Simple;
use Data::Dumper;
use LWP::Simple;

# create object
my $xml = XML::Simple->new();

my @files = `ls medline*.xml`; 
foreach my $xmlfile (@files){
	chomp($xmlfile); 
	# print "$xmlfile..\n";
	# read XML file
	my $data = $xml->XMLin($xmlfile);
	#print Dumper($data); # to check the data structure of the XML files

	foreach my $c (@{$data->{MedlineCitation}})
	{	
		my $title = lc($c->{Article}{ArticleTitle});
		$title =~ s/^\[|\]$//g;
		print "$title"; # print title of the article
		
		if(exists $c->{Article}{Abstract}{AbstractText}){
			my $text = ""; 
			my $t =  $c->{Article}{Abstract}{AbstractText};
			if (ref($t) eq "ARRAY") { # this is for structured abstracts
				foreach my $txt (@{$c->{Article}{Abstract}{AbstractText}}){
					$text = $text." ".lc($txt->{content});
				}
			} else { 
				$text = $t; # this is for simple abstracts (no division of text)
			}
			$text =~ s/\.|\:|\;|\(|\)/ /g;
                        print $text;

		}
	}
}
