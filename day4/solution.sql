DROP TABLE IF EXISTS #clean

SELECT
	row,
	CAST(left(interval1, charindex('-', interval1) - 1) AS INT) as interval1_start,
	CAST(right(interval1, charindex('-', reverse(interval1))-1) AS INT) as interval1_end,
	CAST(left(interval2, charindex('-', interval2) - 1) AS INT) as interval2_start,
	CAST(right(interval2, charindex('-', reverse(interval2))-1) AS INT) as interval2_end
INTO #clean
FROM [AoC2022].[day4].[data]



SELECT 
	COUNT(*) as total
FROM #clean
WHERE (
	interval1_start BETWEEN interval2_start AND interval2_end
	AND interval1_end BETWEEN interval2_start AND interval2_end
)
OR
(
	interval2_start BETWEEN interval1_start AND interval1_end
	AND interval2_end BETWEEN interval1_start AND interval1_end
)

/*----------- STAR 2-----------------*/


SELECT
	COUNT(*) as total
FROM #clean
WHERE  interval1_start <= interval2_end AND interval1_end >= interval2_start