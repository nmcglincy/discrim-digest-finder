# Playing around with different EMBOSS commands to give the output I want
# 
# Presumes that:
# 	EMBOSS is present and in the PATH
#	this file has be made executable by chmod u+x emboss-commands.sh
# 
restrict -fragments -sequence X65923.embl
# this requires some commands, can I make them sensible defaults?
restrict -sequence N5.fasta -max 10 -solofragment 
