#NAMES

fdir<-list.files("~/ncbi-genomes-2019-05-19",
                 pattern=".txt",full.names=T)
fdir<-(c(fdir[1:448]))  #Remove files 449 and 450
#fdir<-data.frame(c(fdir[1:448]))

#Read the txt files, including # header containing names
assem.n<-lapply(fdir, function(i) {
  read.delim(i,
             sep=" ",
             header=F,
             fill=T,
             comment.char="") })

top_only<- function(x) '[' (x[1:20,])
assem.n<-lapply(assem.n,top_only)
cut_columns<- function(x) x[,2:7]
assem.n<-lapply(assem.n,cut_columns)

get_name<- function (x) '[' (x[which(x[,]=="Organism"),])
        get_name3<- function(x) {
          x[which(x[,]=="Organism"),]
        }
        nn3<-lapply(assem.n,get_name3) #identical to nn

nn<-lapply(assem.n,get_name)


# nametest5<-assem.n[[5]]
# nametest5[grep("Organism",nametest5),]
#Get name based on row locations.... !doesn't work for all files
# get_name<- function(x){
#   x[3,4:6]
# }
# #apply function to all files
# N<- lapply(assem.n, get_name)

#names<-data.frame(ncol=4)
#organism_names<- for (i in seq_along(assemblies)) {
#  r<-get_name(assemblies[[i]])
#cbind(r,names)
#  print(r)
#}


paste_species<- function(name_) {
  paste(name_$V5, name_$V6, sep=" ")
}
lnames<- lapply(nn,paste_species)

# dfnames <- data.frame(matrix(unlist(lnames), nrow=length(lnames), byrow=T),stringsAsFactors=FALSE)

lna<-rbind.data.frame((cbind(lnames)), make.row.names = F)
colnames(lna)<-"Organism"
lna<-cbind("ID"=rownames(lna), lna)


#Check if ID matches the organism's original position in the
#list of assemblies files:
print(lna[448,])
print(nn[[448]])
print(assem.n[[448]])



