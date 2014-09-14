# DISCRIM-DIGEST.SH V1
# NJM, 20140913, BERKELEY CA
# 
# Presumes that:
# 	EMBOSS is present and in the PATH
#	this file has be made executable by chmod u+x emboss-commands.sh
# 
# Script is currently limiting to enzymes with a minimum site length of 4 nt, and that cut =< 4 
# times. Also enzymes that have cut ambiguity in their cut-site are not allowed.
# 
# do restrict on it
for i in $@
	do
	restrict -sequence $i -sitelen 4 -enzymes all -max 4 -solofragment -blunt -ambiguity N -plasmid Y -limit Y -alphabetic Y -auto Y
	done
# clean up output files
for a in $(ls *.restrict)
	do
		# removes empty lines, comment lines & the space at the beginning of lines
		# replaces '.' with the more meaningful 'NA'
		sed '/^$/d;/^#/d;s/^[ ]*//;s/\./NA/g' $a | tr -s ' ' '\t' > "slim_$a"
	done
Rscript digest-comparison.R
# 
# TODO - WOULD BE COOL TO BE ABLE TO SET THE MAX AND MIN NUMBER OF SITES IN OPTIONS etc.