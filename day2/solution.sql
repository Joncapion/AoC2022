DROP TABLE IF EXISTS #scores
DROP TABLE IF EXISTS #star2
DROP TABLE IF EXISTS #star2_scores

--Rock A, X
--Paper B, Y
--Scissor C, Z

SELECT 
	CASE
		WHEN me = 'X'
		THEN 1
		WHEN me = 'Y'
		THEN 2
		WHEN me = 'Z'
		THEN 3
	END as default_score,
	CASE
		WHEN elf = 'A'
			THEN
			CASE
				WHEN me = 'Y'
				THEN 6
				WHEN me = 'X'
				THEN 3
				ELSE 0
			END
		WHEN elf = 'B'
			THEN
			CASE
				WHEN me = 'Z'
				THEN 6
				WHEN me = 'Y'
				THEN 3
				ELSE 0
			END
		WHEN elf = 'C'
			THEN
			CASE
				WHEN me = 'X'
				THEN 6
				WHEN me = 'Z'
				THEN 3
				ELSE 0
			END
	END as winning_score
INTO #scores
FROM [AoC2022].[day2].[data]


SELECT sum(default_score) + sum(winning_score) as total_score
FROM #scores

--X lose
--Y draw
--Z win

--Rock A 1
--Paper B 2
--Scissor C 3

SELECT
	row,
	elf,
	me as outcome
INTO #star2
FROM day2.data

SELECT
	*,
	CASE
		WHEN outcome = 'Z'
			THEN
			(CASE
				WHEN elf = 'A'
				THEN 2
				WHEN elf = 'B'
				THEN 3
				WHEN elf = 'C'
				THEN 1
			END) + 6
		WHEN outcome = 'Y'
			THEN
			(CASE
				WHEN elf = 'A'
				THEN 1
				WHEN elf = 'B'
				THEN 2
				WHEN elf = 'C'
				THEN 3
			END) + 3
		WHEN outcome = 'X'
			THEN
			(CASE
				WHEN elf = 'A'
				THEN 3
				WHEN elf = 'B'
				THEN 1
				WHEN elf = 'C'
				THEN 2
			END) + 0
	END as score
INTO #star2_scores
FROM #star2

SELECT Sum(score) as total_score
FROM #star2_scores
