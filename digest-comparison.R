files = list.files(pattern = "newfile-*")
rm(file)
files
data.l = list()
for (i in 1:length(files)) {
	data.l[[i]] = read.table(file = files[[i]],
								header = TRUE,
								colClasses = "character")
}
str(data.l)
names(data.l) = files
?read.table
data.l = lapply(data.l, function(x) {x = x[,1:9]})
#
# length analysis
library(plyr)
enz.l = lapply(data.l, dlply, .(Enzyme_name))
str(enz.l)
