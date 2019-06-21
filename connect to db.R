library(RSQLite)
library(dbplyr)
library(dplyr)
library(DBI)

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "C:\\Users\\Kelly\\Documents\\Python\\Organisms\\Organismdb.db")

#Check if connection worked
attributes(con)
dbListTables(con)
dbExistsTable(con,"Organisms")

dbListFields(con,"Organisms")

#View table!
tbl(con,"Organisms")

#Get row count:
tally(tbl(con,"Organisms"))
#Show this query as SQL request:
show_query(tally(tbl(con,"Organisms")))


#Function to query assemblies
query<- function(nx) {
x<-dbSendQuery(con, 
               'SELECT * 
             FROM Organisms WHERE ScientificName == ?')
dbBind(x,list(nx))
z<-(dbFetch(x,n=1))
dbClearResult(x)
return(z)
# return(z)
#dbHasCompleted(x)
dbClearResult(x)
}

#Query assemblies and append new columns from SQLite database
db_results<-data.frame()
for (i in assemblies[,"Organism"]) {
  x<-query(i)
  if (nrow(x)==0) {
    x[nrow(x)+1,]<- c(rep("NULL",11))}
  db_results<-rbind(db_results,x)}
#Bind new columns to assemblies dataframe
assemblies_complete<-cbind(assemblies,db_results)

#If there are any entries missing in db_results, db_results won't cbind
#to assemblies(differing numbers of rows)

which(assemblies[,"Organism"] %starts% "Drosophila melanogaster")

#Check which rows are missing
'%!in%' <- function(x,y)!('%in%'(x,y))
which(assemblies[,"Organism"] %!in% db_results[,"ScientificName"])

which(db_results[,"ScientificName"] %!in% assemblies[,"Organism"])

#Verify that Organism matches Scientific Name in all rows
which(assemblies_complete[,"Organism"] != assemblies_complete[,"ScientificName"])
#rows 100,200 and 400 weren't in the database
assemblies_complete[c(100,200,400),]




