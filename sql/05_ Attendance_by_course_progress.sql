-- 04_ Attendance_by_course_progress
--
-- Question:
-- At what point in a course does attendance start to fall?
--
-- Courses have different lengths, so we divide each course 
-- into 10 parts and compare attendance across those parts.
--
-- 0 = beginning, 5 = middle , 9 = end
WITH course_date AS (
  -- Find the first and last date for each course and cohort .
  SELECT 
      e.course_id,
      e.cohort_id,
      MIN(a.session_date) AS first_date,
      MAX(a.session_date) AS last_date
      
	FROM enrolments e
    JOIN attendance a ON e.enrolment_id = a.enrolment_id
    GROUP BY e.course_id, e.cohort_id
),
course_progress AS (
    -- Find where each class falls within the course.
    
    SELECT 
       a.status,
       10* DATEDIFF(a.session_date, c.first_date)
       / DATEDIFF(c.last_date, c.first_date) AS decile
	FROM attendance a 
    
    JOIN enrolments e ON a.enrolment_id = e.enrolment_id
    JOIN course_date c ON e.course_id = c.course_id
        AND e.cohort_id = c.cohort_id
	WHERE a.status <> 'Not Recorded'
)


-- Calculate attendance for each part of the course 
SELECT 
    ROUND(decile) AS decile,
    
    ROUND(
    100* SUM(status IN ( 'Present', 'Late')) / COUNT(*),1
    ) AS attendance_rate,
    
    COUNT(*) AS n
    
FROM course_progress 
GROUP BY ROUND(decile)
ORDER BY decile;

-- 
-- Result: 
--
-- Attendance starts high at the beginning of the course
-- and declines as the course progresses.
