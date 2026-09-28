-- 05_schedule_comparison
--
-- Question :
-- Does the number of training days per week affect attendance?
--
-- Cohorts 2 to 5 used a three-day week (MWF), while Cohort 6
-- used a five day week (MTWTF).


SELECT 
    c.schedule,
	ROUND(100 * SUM( a.status IN ( 'Present' , 'Late' )) / COUNT(*)
    ) AS attendance_rate,
    COUNT(*) AS n
FROM attendance a
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id

WHERE a.status <> 'Not Recorded' 
GROUP BY c.schedule;

--
-- Result
-- Attendance is almost the same under both schedules :
-- 58.0% for the five day week and 58.9% for the three day week
-- The difference is less than one percentage point , suggesting 
-- that the change in weekly schedule had little difference in 
-- attendance based on the available data.

