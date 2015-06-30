#! /bin/sh

awk '/[NYZ]P\_/' ../mtrH_NPYP_CDS.paml | grep -P '^(?!Methano).+' | grep -oP '[ZNY]P\_[^-]+';




