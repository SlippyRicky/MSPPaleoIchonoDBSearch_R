#
# This provides database editing examples.
#
# Explore these to learn how you can edit the database.
#


rm(list=ls())


#################### Software Set Up ######################
install.packages("RPostgreSQL")
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
table  <- dbGetQuery(con, query)



########### 1. Update data (changes to the table from the dataset)

# Set all rows in "sex" column into "male" from table "msp"
query <- "UPDATE msp SET sex = 'male';"
dbExecute(con, query)

# Set "sex" column of the "C. cristata" row in "specimen" column to "male"
query <- "UPDATE msp
          SET sex = 'female'
          WHERE specimen = 'C. cristata';"
dbExecute(con, query)



########### 2. Delete data (changes to the table from the dataset)

# Delete the table "msp"
query <- "DELETE FROM msp"
dbExecute(con, query)

# Delete the "C. cristata" row in "specimen" column from table "msp"
query <- "DELETE FROM msp
          WHERE specimen = 'C. cristata';"
dbExecute(con, query)



########### 3. Order data (changes to the table from the dataset)

# Get ordered table "msp" based on "picture number" in ascending order
query <- "SELECT * FROM msp ORDER BY \"picture number\";"
# Or
query <- "SELECT * FROM msp ORDER BY specimen ASC;"
dbExecute(con, query)

# Get ordered table "msp" based on "picture number" in descending order
query <- "SELECT * FROM msp ORDER BY \"picture number\" desc;"
dbExecute(con, query)

# Get ordered table "msp" based on "specimen" first, then picture number"
query <- "SELECT * FROM msp ORDER BY specimen,\"picture number\";"
dbExecute(con, query)



########### 4. Editing in R could be done by more R functions




