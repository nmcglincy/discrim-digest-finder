rm(list = ls())
files = list.files(pattern = "slim_*")
data.l = list()
for (i in 1:length(files)) {
	data.l[[i]] = read.table(file = files[[i]],
                           header = TRUE,
                           colClasses = "character")
}
names(data.l) = files
data.l = lapply(data.l, function(x) {x = x[,1:9]})
#
# length analysis
library(plyr)
data.l = lapply(data.l, dlply, .(Enzyme_name))
enz.l = lapply(data.l, lapply, function(x) {length(unique(x$X5frag))})
enz.l = lapply(enz.l, ldply)
for (i in 1:length(enz.l)) {
  colnames(enz.l[[i]]) = c("enzyme", names(enz.l[i]))
  enz.l[[i]]$enzyme = as.factor(enz.l[[i]]$enzyme)
}
enz.df = join_all(enz.l)
enz.df = enz.df[order(enz.df[,2], decreasing = TRUE),]
write.csv(enz.df, 
          file = "number-of-sites.csv",
          row.names = FALSE)
