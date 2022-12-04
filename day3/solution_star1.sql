DROP TABLE IF EXISTS #compartments;
DROP TABLE IF EXISTS #prio_scores_higher;
DROP TABLE IF EXISTS #prio_scores_lower;
DROP TABLE IF EXISTS #scores;

/*---------------prio tables START-------------------*/
WITH 
cte_tally AS
(
SELECT row_number() OVER (ORDER BY (SELECT 1)) AS n 
FROM sys.all_columns
)
SELECT 
  char(n) as item, IDENTITY(INT, 27,1) as prio
INTO #prio_scores_higher
FROM
  cte_tally
WHERE
  (n > 64 and n < 91);

WITH 
cte_tally AS
(
SELECT row_number() OVER (ORDER BY (SELECT 1)) AS n 
FROM sys.all_columns
)
SELECT 
  char(n) as item, IDENTITY(INT, 1,1) as prio
INTO #prio_scores_lower
FROM
  cte_tally
WHERE
  (n > 96 and n < 123);

/*---------------prio tables END----------------------*/

/*---------------STAR ONE-----------------------------*/
SELECT
	SUBSTRING(content,1,len(content)/2) as first_compartment,
	SUBSTRING(content,len(content)/2+1,len(content)/2) as second_compartment
INTO #compartments
FROM [AoC2022].[day3].[data]

CREATE TABLE #scores (
	score INT)

DECLARE @prio AS INT = 1
WHILE @prio < 27
BEGIN
	
	INSERT INTO #scores
	SELECT 
		@prio
FROM #compartments
where CHARINDEX((SELECT item FROM #prio_scores_lower WHERE prio = @prio) ,first_compartment COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_lower WHERE prio = @prio) ,second_compartment COLLATE latin1_general_cs_as) > 0

SET @prio = @prio +1
END

WHILE @prio < 57
BEGIN
	
	INSERT INTO #scores
	SELECT 
		@prio
FROM #compartments
where CHARINDEX((SELECT item FROM #prio_scores_higher WHERE prio = @prio) ,first_compartment COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_higher WHERE prio = @prio) ,second_compartment COLLATE latin1_general_cs_as) > 0

SET @prio = @prio +1
END

SELECT SUM(score)
FROM #scores
