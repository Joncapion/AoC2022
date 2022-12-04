DROP TABLE IF EXISTS #prio_scores_higher;
DROP TABLE IF EXISTS #prio_scores_lower;
DROP TABLE IF EXISTS #scores;
DROP TABLE IF EXISTS #groups;

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

/*---------------STAR Two-----------------------------*/
DECLARE @group_size AS INT = 3,
		@group_number AS INT = 0

CREATE TABLE #groups (
	group_number INT,
	elf1 VARCHAR(100),
	elf2 VARCHAR(100),
	elf3 VARCHAR(100)
)

WHILE @group_number < (SELECT COUNT(*)/@group_size FROM [AoC2022].[day3].[data])
BEGIN
	INSERT INTO #groups
	SELECT
	@group_number,
	(SELECT content FROM [AoC2022].[day3].[data] WHERE row = (@group_number * @group_size)+1) AS elf1,
	(SELECT content FROM [AoC2022].[day3].[data] WHERE row = (@group_number * @group_size)+2) AS elf2,
	(SELECT content FROM [AoC2022].[day3].[data] WHERE row = (@group_number * @group_size)+3) AS elf3

SET @group_number = @group_number + 1
END

CREATE TABLE #scores (
	score INT)

DECLARE @prio AS INT = 1
WHILE @prio < 27
BEGIN
	
	INSERT INTO #scores
	SELECT 
		@prio
FROM #groups
where CHARINDEX((SELECT item FROM #prio_scores_lower WHERE prio = @prio) ,elf1 COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_lower WHERE prio = @prio) ,elf2 COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_lower WHERE prio = @prio) ,elf3 COLLATE latin1_general_cs_as) > 0

SET @prio = @prio +1
END

WHILE @prio < 57
BEGIN
	
	INSERT INTO #scores
	SELECT 
		@prio
FROM #groups
where CHARINDEX((SELECT item FROM #prio_scores_higher WHERE prio = @prio) ,elf1 COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_higher WHERE prio = @prio) ,elf2 COLLATE latin1_general_cs_as) > 0
AND CHARINDEX((SELECT item FROM #prio_scores_higher WHERE prio = @prio) ,elf3 COLLATE latin1_general_cs_as) > 0

SET @prio = @prio +1
END

SELECT SUM(score)
FROM #scores
