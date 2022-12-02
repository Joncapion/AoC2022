DROP TABLE IF EXISTS #find_elfs;
DROP TABLE IF EXISTS #star1;
DROP TABLE IF EXISTS #star2;

SELECT *,
       CASE
           WHEN calories = 0 THEN
               1
           ELSE
               0
       END AS new_elf
INTO #find_elfs
FROM DFD_JGC.day1.data_star1;


SELECT *,
       SUM(new_elf) OVER (ORDER BY row) AS elf
INTO #star1
FROM #find_elfs;

SELECT TOP 1
       elf,
       SUM(calories) AS sum_cal
FROM #star1
GROUP BY elf
ORDER BY SUM(calories) DESC;

SELECT TOP 3
       elf,
       SUM(calories) AS sum_cal
INTO #star2
FROM #star1
GROUP BY elf
ORDER BY SUM(calories) DESC;


SELECT SUM(sum_cal) AS top_3_sum
FROM #star2;