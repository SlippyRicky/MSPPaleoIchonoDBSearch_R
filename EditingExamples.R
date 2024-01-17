#
# This provides database editing examples.
#
# Explore these to learn how you can edit the database.
#

#################### Will be further refined ######################

rm(list=ls())




#################### Software Set Up ######################
#install.packages("RPostgreSQL")
library(RPostgreSQL)


###################### Connect Database ######################
con <- dbConnect(
  PostgreSQL(),
  dbname = "pro306",             #name of imported database
  port = 5432,                   #port of imported server
  user = "postgres",             #username
  password = "password")         #password


###################### Roll back commitment ######################
# Start editing
dbBegin(con)
# Roll back
dbRollback(con)
# Commit
dbCommit(con)
# Disconnect
dbDisconnect(con)


###################### Examples of editing ######################

########### Query the tables
tables <- dbListTables(con)
print(tables)

########### Load the initial table
query <- "SELECT * FROM msp;"
data  <- dbGetQuery(con, query)

########### 1. Update data
query <- "UPDATE msp SET sex = 'male';"
query <- "UPDATE msp
          SET sex = 'female'
          WHERE specimen = 'C. cristata';"
dbExecute(con, query)

########### 2. Delete data
query <- "DELETE FROM msp"
query <- "DELETE FROM msp
          WHERE specimen = 'C. cristata';"
dbExecute(con, query)

########### 3. Order data
query <- "SELECT * FROM msp ORDER BY \"picture number\";"
query <- "SELECT * FROM msp ORDER BY specimen ASC;"
query <- "SELECT * FROM msp ORDER BY \"picture number\" desc;"
query <- "SELECT * FROM msp ORDER BY specimen,\"picture number\";"
dbExecute(con, query)
data <- dbGetQuery(con, query)

























