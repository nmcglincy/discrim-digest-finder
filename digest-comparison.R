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
enz.df = na.omit(join_all(enz.l))
enz.df = enz.df[order(enz.df[,2], decreasing = TRUE),]
enz.df
write.csv(enz.df, 
          file = "number-of-sites.csv",
          row.names = FALSE)
# 
str(data.l)
str(enz.l)
enz.df
# fragment size analysis
data.l
foo = lapply(data.l, lapply, function(x) {sort(as.vector(x$X5frag, mode = "integer"))})
str(foo)
enz.df


lapply(foo, lapply, length)
subset(enz.df, abs(slim_n40.restrict - slim_n5.restrict) > 0)
str(foo)
c(paste(unlist(foo$slim_n40.restrict$BalI), collapse = "_"),
  paste(unlist(foo$slim_n5.restrict$BalI), collapse = "_"))

foo[[1]][['AclI']]

N5.frags = character()
N40.frags = character()
for (i in subset(enz.df, abs(slim_n40.restrict - slim_n5.restrict) > 0)$enzyme) {
  N5.frags = c(N5.frags, paste(unlist(foo[[2]][[i]]), collapse = "_"))
  N40.frags = c(N40.frags, paste(unlist(foo[[1]][[i]]), collapse = "_"))
}
N5.frags
N40.frags


enzNames = intersect(names(foo[[1]]), names(foo[[2]]))


enz.df$slim_n40.restrict == enz.df$slim_n5.restrict
# FOR THE ENZYMES THAT DON'T CHANGE IN THE NUMBER OF SITES
tom = enz.df$enzyme[enz.df$slim_n40.restrict == enz.df$slim_n5.restrict]
# tom = na.omit(tom)
tom = tom[!is.na(tom)]
class(tom)
?na.omit
tom
for (i in tom) {
  i
  print(foo[[1]][[i]])
  print(foo[[2]][[i]])
}


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