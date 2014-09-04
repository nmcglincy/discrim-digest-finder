# 
# Presumes that:
# 	EMBOSS is present and in the PATH
#	this file has be made executable by chmod u+x emboss-commands.sh
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