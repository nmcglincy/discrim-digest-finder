# DIGEST-COMPARISON V1
# NJM, 20140913, BERKELEY CA
# 
# rm(list = ls())
# READ SLIMMED DOWN RESTRICT FILES INTO A LIST
files = list.files(pattern = "slim_*")
data.l = list()
for (i in 1:length(files)) {
  data.l[[i]] = read.table(file = files[[i]],
                           header = TRUE,
                           colClasses = "character")
}
# 
# MAKE THE NAMES OF THE LIST THE NAMES OF THE FILES
names(data.l) = files
# 
# REMOVE THE USELESS COLUMNS
data.l = lapply(data.l, function(x) {x = x[,1:9]})
#
# GENERATE A REPORT OF THE ENZYMES FOR WHICH THE NUMBER OF SITES IS DIFFERENT FOR THE 
# TWO PLASMIDS AND THE RESULTING FRAGMENTS
# 
# REORGANISE THE INTO A LIST OF LISTS OF DATAFRAME BY ENZYME
# PLASMID.LIST:ENZYME.LIST:DETAILS.DF
library(plyr)
data.l = lapply(data.l, dlply, .(Enzyme_name))
# 
# CALCULATING THE NUMBER OF SITES FOR EACH ENZYME
# PLASMID.LIST:ENZYME.LIST:VECTOR.OF.NO.SITES
enz.l = lapply(data.l, lapply, function(x) {length(unique(x$X5frag))})
# 
# PLASMID.LIST:DF.NO.SITES.BY.ENZ
enz.l = lapply(enz.l, ldply)
# 
# REFACTORING TO MAKE A COHERANT DATAFRAME
for (i in 1:length(enz.l)) {
  colnames(enz.l[[i]]) = c("enzyme", names(enz.l[i]))
  enz.l[[i]]$enzyme = as.factor(enz.l[[i]]$enzyme)
}
# 
# THIS ANALYSIS HAS A NUMBER OF HOLES
# 1. IT WON'T REPORT ENZYMES WERE ONE OF THE PLASMIDS HAS MORE OR LESS THAN THE MAX
#     OR MIN NUMBER OF SITES DETECTED BY RESTRICT, RESPECTIVELY.
# 2. FOLLOWING ON FROM THIS, IT WON'T DETECT THE ACQUISITION OF ENTIRELY NEW SITES IN
#     ONE PLASMID - BUT I FEEL THIS WOULD BE A POOR STRATEGY FOR A DIAGNOSTIC DIGEST,
#     AS IT WOULD BE DIFFICULT TO DISTINGUISH BETWEEN THE LACK OF A SINGLE SITE AND
#     THE DIGEST NOT WORKING.
enz.df = na.omit(join_all(enz.l))
enz.df = enz.df[order(enz.df[,2], decreasing = TRUE),]
enz.df.nu.sites = subset(enz.df, abs(enz.df[,2] - enz.df[,3]) > 0)
# 
# GETTING THE FRAGMENT LENGTHS
enz.frags = lapply(data.l, lapply, function(x) {sort(as.vector(x$X5frag, mode = "integer"))})
for (i in files) {
  assign(paste(i, ".frags", sep = ""), character())
}
for (i in 1:length(ls(pattern = "slim_*"))) {
  foo = character()
  for (x in enz.df.nu.sites$enzyme) {
    foo = c(foo, paste(unlist(enz.frags[[i]][[x]]), collapse = "_"))
  }
  enz.df.nu.sites = cbind(enz.df.nu.sites, assign(ls(pattern = "slim_*")[i], foo))
}
#
# GENERATING CSV REPORT
colnames(enz.df.nu.sites) = c(colnames(enz.df.nu.sites)[1:3], ls(pattern = "slim_*"))
write.csv(enz.df.nu.sites, 
  file = "diff-number-site.csv", 
  row.names = FALSE)
# 
# 
enz.df.fl = subset(enz.df, abs(enz.df[,2] - enz.df[,3]) == 0 & enz.df[,2] != 1)
for (i in files) {
  assign(paste(i, ".frags", sep = ""), character())
}
for (i in 1:length(ls(pattern = "slim_*"))) {
  foo = character()
  for (x in enz.df.fl$enzyme) {
      foo = c(foo, paste(unlist(enz.frags[[i]][[x]]), collapse = "_"))
  }
  enz.df.fl = cbind(enz.df.fl, assign(ls(pattern = "slim_*")[i], foo))
}
# WOULD BE COOL TO ENCAPSULATE THIS INTO A FUNCTION
# 
colnames(enz.df.fl) = c(colnames(enz.df.fl)[1:3], ls(pattern = "slim_*"))
enz.df.fl[,4] = as.character(enz.df.fl[,4])
enz.df.fl[,5] = as.character(enz.df.fl[,5])
enz.df.fl = enz.df.fl[!(enz.df.fl[,4] == enz.df.fl[,5]),]
enz.df.fl = enz.df.fl[order(nchar(enz.df.fl[,4])),]
write.csv(enz.df.fl, 
  file = "diff-frag-length.csv", 
  row.names = FALSE)
# 
# TODO - WOULD BE BETTER TO EXPLICITLY COMPARE THE VECTORS OF FRAGMENT SIZES AND
# TO ONLY SHOW THOSE THAT ARE DIFFERENT BY A CERTAIN AMOUNT, OR SOME SUCH. HERE
# YOU STILL HAVE TO LOOK DOWN A LIST, EVEN IF IT IS A FOCUSED ONE.