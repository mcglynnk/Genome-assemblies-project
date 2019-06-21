fdir<-list.files("~/ncbi-genomes-2019-05-19",
                 pattern=".txt",full.names=T)
fdir<-(c(fdir[1:448]))  #Remove files 449 and 450
colnames<-c("unit_name","mol_name","mol_type","seq_type","stat","value")

assem.data<-lapply(fdir, function(i){
  read.delim(i,
             sep="\t",
             header=F,
             fill=T,
             comment.char="#",
             col.names=colnames)})

get_total_length_val<- function (x) '[' (x[x$unit_name %starts% "Primary Assembly"
                          &x$mol_name %in% "all"
                          &x$mol_type %in% "all"
                          &x$seq_type %in% "all"
                          &x$stat %in% "total-length" ,"value"] )

get_ungapped_length_val<- function (x) '[' (x[x$unit_name %starts% "Primary Assembly"
                                   &x$mol_name %in% "all"
                                   &x$mol_type %in% "all"
                                   &x$seq_type %in% "all"
                                   &x$stat %in% "ungapped-length" ,"value"] )

get_mito_val<- function (x) '[' (x[x$unit_name %in% "non-nuclear"
                                      &x$mol_name %in% "MT"
                                      &x$mol_type %in% "Mitochondrion"
                                      &x$seq_type %in% "all"
                                      &x$stat %in% "total-length" ,"value"] )

get_total_length_allcols<- function (x) '[' (x[x$unit_name %starts% "Primary Assembly"
                                       &x$mol_name %in% "all"
                                       &x$mol_type %in% "all"
                                       &x$seq_type %in% "all"
                                       &x$stat %in% "total-length" ,] )
get_ungapped_length_allcols<- function (x) '[' (x[x$unit_name %starts% "Primary Assembly"
                                          &x$mol_name %in% "all"
                                          &x$mol_type %in% "all"
                                          &x$seq_type %in% "all"
                                          &x$stat %in% "ungapped-length" ,] )

get_mito_allcols<- function (x) '[' (x[x$unit_name %in% "non-nuclear"
                               &x$mol_name %in% "MT"
                               &x$mol_type %in% "Mitochondrion"
                               &x$seq_type %in% "all"
                               &x$stat %in% "total-length" ,] )

total_all<-lapply(assem.data,get_total_length_allcols)
ungapped_all<-lapply(assem.data,get_ungapped_length_allcols)
mito_all<-lapply(assem.data,get_mito_allcols)

total<-lapply(assem.data,get_total_length_val)
ungapped<-lapply(assem.data,get_ungapped_length_val)
mito<-lapply(assem.data,get_mito_val)

#testing
#nn5<-nn[[5]]
total5<-total[[5]]
ungapped5<-ungapped[[5]]
mito5<-mito[[5]]

comb.vals<-rbind(total5,ungapped5,mito5)
test<-t(comb.vals)
comb.val.colnames<-c("Organism","total length","ungapped length","total mito")
dttest<-data.frame(test[c("stat","value"),])
dttest<-cbind("Organism",dttest)
colnames(dttest)<-comb.val.colnames

#cbind twice makes a matrix
assem.data_vals<- rbind.data.frame(cbind(cbind(total),cbind(ungapped),cbind(mito)))
colnames(assem.data_vals)<-c("total","ungapped","mito")

`%starts%` <- function(x, string) {startsWith(as.character(x), string)}

#"%in%" <- function(x, table) match(x, table, nomatch = 0) > 0
#example `%allin%` <- function(x,table) {all(match(x,table,nomatch = 0L) > 0L)}
list(rep(1,4), rep(2,3), rep(3,2), rep(4,1))
mapply(rep, 1:4, 4:1) #equivalent

assem.data_vals<-cbind("ID"=rownames(assem.data_vals), assem.data_vals)