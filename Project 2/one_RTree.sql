------ 1R Classifier ------
-- Script to model 1R Classifier

CONNECT TO SAMPLE;

-- drop the tables we're about to create, in case they already exist
DROP TABLE FREQUENT_CLASS;

-- create the tables
CREATE TABLE FREQUENT_CLASS("COLUMNNO" INTEGER, "ATT" VARCHAR(10), "CLASS_COUNT" INTEGER, "DECISION" VARCHAR(10));

INSERT INTO FREQUENT_CLASS
WITH TEMP1 AS(SELECT COLUMNNO, ATT,COUNT(DECISION) AS CLASS_COUNT,DECISION FROM TRAIN_DATASET GROUP BY COLUMNNO,ATT,DECISION),
TEMP2 AS(SELECT COLUMNNO,ATT,MAX(CLASS_COUNT) AS MAX_CLASS_COUNT FROM TEMP1 GROUP BY COLUMNNO,ATT),
TEMP3 AS(SELECT T1.COLUMNNO, T1.ATT, T1.CLASS_COUNT, T1.DECISION FROM TEMP1 AS T1 ,TEMP2 AS T2 WHERE T1.CLASS_COUNT=T2.MAX_CLASS_COUNT AND T1.COLUMNNO=T2.COLUMNNO)
SELECT * FROM TEMP3; -- CALCUALTE THE MOST FREQUENT COLUMN IN THE DATASET

-- drop the tables we're about to create, in case they already exist
DROP TABLE SPLIT_ATTR;

-- create the tables
CREATE TABLE SPLIT_ATTR("COLNO" INTEGER);

INSERT INTO SPLIT_ATTR
WITH TEMP1 AS(SELECT T.COLUMNNO,COUNT(T.COLUMNNO) AS ERROR_COUNT FROM TRAIN_DATASET AS T, FREQUENT_CLASS AS F WHERE T.COLUMNNO=F.COLUMNNO AND T.ATT=F.ATT AND T.DECISION!=F.DECISION GROUP BY T.COLUMNNO),
TEMP2 AS(SELECT COLUMNNO,ERROR_COUNT FROM TEMP1 WHERE ERROR_COUNT= (SELECT MIN(ERROR_COUNT) FROM TEMP1))
SELECT COLUMNNO FROM TEMP2; -- SPLIT WITH RESPECT TO MOST FREQUENT ITEM 

CALL GET_ACCURACY_1R_TREE(?,?,?);

---- CLEAN UP ----
TERMINATE;
