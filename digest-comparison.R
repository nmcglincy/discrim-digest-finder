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
# 
# fragment size analysis
data.l
foo = lapply(data.l, lapply, function(x) {sort(as.vector(x$X5frag, mode = "integer"))})
str(foo)
lapply(foo, unlist)
setdiff(names(foo[[1]]), names(foo[[2]]))
setdiff(names(foo[[2]]), names(foo[[1]]))
setequal(names(foo[[1]]), names(foo[[2]]))
union(names(foo[[1]]), names(foo[[2]]))
intersect(names(foo[[1]]), names(foo[[2]]))
?setdiff
length(names(foo[[1]])); length(names(foo[[2]]))
setdiff(foo[[1]], foo[[2]])
foo[[1]]

enzNames = intersect(names(foo[[1]]), names(foo[[2]]))
abs(foo[[1]][["AatII"]] - foo[[2]][["AatII"]])

for (i in enzNames) {
	abs(foo[[1]][[i]] - foo[[2]][[i]])
}
?equal