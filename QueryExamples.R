#
# This provides query examples.
#
# Explore these to learn how you can retrieve specific datasets from the database.
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


###################### Examples of Query ######################

########### Query the tables
tables <- dbListTables(con)
print(tables)

########### 1. Get all information from the table "msp"
query1 <- "SELECT * FROM msp"
table1 <- dbGetQuery(con, query1)

########### 2. Get columns "specimen" and "bone" from the table "msp"
query2 <- "SELECT specimen, bone FROM msp"
table2 <- dbGetQuery(con, query2)

########### 3. Get all rows having "ulna" in column "bone" from the table "msp"
query3 <- "SELECT * FROM public.msp WHERE bone LIKE '%ulna%'"
table3 <- dbGetQuery(con, query3)

########### 4. Get columns "specimen" and "bone" from the table "msp", but only with rows having "A. pusilus_1" in column "specimen" and "rib" in column "bone".
query4 <- "SELECT specimen, bone FROM public.msp
           WHERE specimen LIKE '%A. pusilus_1%'
           AND bone LIKE '%rib%';"
table4 <- dbGetQuery(con, query4)

########### 5. Get ordered table "msp" based on "picture number" 
query5 <- 'SELECT * FROM public.msp
           ORDER BY "picture number" ASC'
table5 <- dbGetQuery(con, query5)

################# The following will be altered #################

########### 3. Order data
query <- "SELECT * FROM msp ORDER BY \"picture number\";"
query <- "SELECT * FROM msp ORDER BY specimen ASC;"
query <- "SELECT * FROM msp ORDER BY \"picture number\" desc;"
query <- "SELECT * FROM msp ORDER BY specimen,\"picture number\";"
dbExecute(con, query)
data <- dbGetQuery(con, query)

########### 4. Group data
query <- "SELECT specimen FROM msp GROUP BY specimen;"
query <- "SELECT specimen, count(1)
          FROM msp GROUP BY specimen;"
query <- "SELECT specimen, count(1),max(\"picture number\"),min(\"picture number\")
          FROM msp GROUP BY specimen;"
data <- dbGetQuery(con, query)

########### 5. Filter
query <- "SELECT specimen, count(1),max(\"picture number\")
          FROM msp GROUP BY specimen
          HAVING max(\"picture number\") < 1800;"

########### 6. Conditions
query <- "SELECT *
          FROM msp
          WHERE specimen = 'A. pusilus_1'
          AND bone = 'rib';"
query <- "SELECT *
          FROM msp
          WHERE specimen = 'A. pusilus_1'
          OR bone = 'humerus';"
query <- "SELECT *
          FROM msp
          WHERE specimen = 'A. pusilus_1'
          OR bone = 'humerus'
          AND sex = 'female';"
query <- "SELECT *
          FROM msp
          WHERE \"picture number\" IN (1800, 1801, 1802);"
query <- "SELECT *
          FROM msp
          WHERE bone NOT IN ('rib', 'humerus', 'scapula');"
query <- 'SELECT *
          FROM msp
          WHERE "editing user" IS NOT NULL;'
query <- "SELECT *
          FROM msp
          WHERE bone like '%ume%';"
query <- "SELECT *
          FROM msp
          WHERE bone like 'hum%';"
query <- "SELECT *
          FROM msp
          WHERE bone like '%rus';"
query <- "SELECT *
          FROM msp
          WHERE bone NOT like '%rus';"
query <- "SELECT *
          FROM msp
          WHERE \"picture number\" BETWEEN 1 AND 1800
          ORDER BY \"picture number\";"
query <- 'SELECT *
          FROM msp
          WHERE "editing user" IS NOT NULL;'


