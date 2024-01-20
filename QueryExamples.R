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

########### Get all information from the table "msp"
query1 <- "SELECT * FROM msp"
table1 <- dbGetQuery(con, query1)


########### 1.Select/exclude certain columns and/or rows 

# Get columns "specimen" and "bone" from the table "msp"
query2 <- "SELECT specimen, bone FROM msp"
table2 <- dbGetQuery(con, query2)

# Get all rows having "ulna" in column "bone" from the table "msp"
query3 <- "SELECT * FROM public.msp WHERE bone = 'ulna'"
table3 <- dbGetQuery(con, query3)

# Get columns "specimen" and "bone" from the table "msp", but only with rows having "A. pusilus_1" in column "specimen" and "rib" in column "bone".
query4 <- "SELECT specimen, bone FROM public.msp
           WHERE specimen = 'A. pusilus_1'
           AND bone = 'rib';"
table4 <- dbGetQuery(con, query4)

# Get all rows containing "ume" in column "bone" from the table "msp"
query5 <- "SELECT *
          FROM msp
          WHERE bone like '%ume%';"
table5 <- dbGetQuery(con, query5)

# Get all rows containing "hum" in column "bone", with "hum" as the start
query6 <- "SELECT *
          FROM msp
          WHERE bone like 'hum%';"
table6 <- dbGetQuery(con, query6)

# Get all rows containing "rus" in column "bone", with "rus" as the end
query7 <- "SELECT *
          FROM msp
          WHERE bone like '%rus';"
table7 <- dbGetQuery(con, query7)

# Get all rows not containing "ume" in column "bone" from the table "msp"
query8 <- "SELECT *
          FROM msp
          WHERE bone NOT like '%ume%';"
table8 <- dbGetQuery(con, query8)

# Get rows containing “1800"，“1801” and "1802" in column "picture number" from the table "msp"
query9 <- "SELECT *
          FROM msp
          WHERE \"picture number\" IN (1800, 1801, 1802);"
table9 <- dbGetQuery(con, query9)

# Get rows not containing “rib"，“humerus” and "scapula" in column "bone" from the table "msp"
query <- "SELECT *
          FROM msp
          WHERE bone NOT IN ('rib', 'humerus', 'scapula');"
table <- dbGetQuery(con, query)

# Find a certain cell from table "msp" by giving a certain row and column
query <- "SELECT bone
          FROM msp
          WHERE \"picture number\" = '1900';"
table <- dbGetQuery(con, query)



########### 2. Order data  (changes to tables in R only)

# Get ordered table "msp" based on "picture number" in ascending order
query <- "SELECT * FROM msp ORDER BY \"picture number\";"
# Or
query <- "SELECT * FROM msp ORDER BY specimen ASC;"
table <- dbGetQuery(con, query5)

# Get ordered table "msp" based on "picture number" in descending order
query <- "SELECT * FROM msp ORDER BY \"picture number\" desc;"
table <- dbGetQuery(con, query5)

# Get ordered table "msp" based on "specimen" first, then picture number"
query <- "SELECT * FROM msp ORDER BY specimen,\"picture number\";"
table <- dbGetQuery(con, query5)



########### 3. Group data

# Check all "specimen"s from the table "msp"
query <- "SELECT specimen FROM msp GROUP BY specimen;"
table <- dbGetQuery(con, query)

# Check all "specimen"s from the table "msp", and count each "specimen"
query <- "SELECT specimen, count(1)
          FROM msp GROUP BY specimen;"
table <- dbGetQuery(con, query)

# Check all "specimen"s from the table "msp", count each "specimen", and find the max/min number in their "picture number"
query <- "SELECT specimen, count(1),max(\"picture number\"),min(\"picture number\")
          FROM msp GROUP BY specimen;"
table <- dbGetQuery(con, query)

# Limit the max "picture number" be smaller than 1800
query <- "SELECT specimen, count(1),max(\"picture number\"),min(\"picture number\")
          FROM msp GROUP BY specimen
          HAVING max(\"picture number\") < 1800;"
table <- dbGetQuery(con, query)



########### 4. Conditions

# AND: both conditions are true
query <- "SELECT * FROM msp
          WHERE specimen = 'A. pusilus_1'
          AND bone = 'rib';"
table <- dbGetQuery(con, query)

# OR: any condition should be true
query <- "SELECT * FROM msp
          WHERE specimen = 'A. pusilus_1'
          OR bone = 'humerus';"
table <- dbGetQuery(con, query)

# AND & OR: in this case, both specimen = 'A. pusilus_1'and sex = 'female' should be true, or both bone = 'humerus' and sex = 'female' should be true
query <- "SELECT * FROM msp
          WHERE specimen = 'A. pusilus_1'
          OR bone = 'humerus'
          AND sex = 'female';"
table <- dbGetQuery(con, query)

# IS NOT NULL: select rows that is not null in column "editing user" from the table "msp"
query <- 'SELECT * FROM msp
          WHERE "editing user" IS NOT NULL;'
table <- dbGetQuery(con, query)

# BETWEEN: select rows that is between 1 and 1800 in column "picture number" from the table "msp"
query <- "SELECT * FROM msp
          WHERE \"picture number\" BETWEEN 1 AND 1800
          ORDER BY \"picture number\";"
table <- dbGetQuery(con, query)



########### 5. Join relational tables

# Join two tables "table1" and "table2" together, with the corresponding columns table1."ID" and table2."ID"
query <- "SELECT *
          FROM table1
          INNER JOIN table2
          ON table1.\"ID\" = table2.\"ID\";"
table <- dbGetQuery(con, query)

# Set "table1" and "table2" as t1 and t2 in query
query <- "SELECT *
          FROM table1 AS t1
          INNER JOIN table2 AS t2
          ON t1.\"ID\" = t2.\"ID\";"
table <- dbGetQuery(con, query)


