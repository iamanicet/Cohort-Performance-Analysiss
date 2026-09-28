-- 06_dropout_timing.sql
--
-- Question
-- Is there a pattern in attendance before students drop out?
--
-- We compare attendance in the final 30 days before a student's
-- last recorded attendance with their attendance earlier in the course.
--
-- Since we do not have an actual dropout date, the student's 
-- last recorded attendance is used as the approximate dropout point.


WITH last_attendance AS (

    -- Find the last attendance date for each student who eventually dropped out.
    SELECT 
        a.enrolment_id,
        MAX(a.session_date) AS last_attendance_date
	FROM attendance a
    JOIN enrolments e ON e.enrolment_id = a.enrolment_id
    WHERE e.status = 'Dropped'
    GROUP BY enrolment_id

)
-- Compare attendance in the final 30 days with attendance earlier in the course
SELECT 
    CASE
       WHEN DATEDIFF(la.last_attendance_date, a.session_date) <= 30
       THEN 'Last 30 days'
       ELSE ' Earlier'
	END AS period,
    
    ROUND( 100 * SUM(a.status IN ( 'Present', 'Late')) / COUNT(*), 1
		) AS attendance_rate,
        
        COUNT(*) AS sessions
	FROM attendance a
    JOIN last_attendance la ON a.enrolment_id = la.enrolment_id
    
    WHERE a.status <> 'Not Recorded'
         AND a.session_date  <= la.last_attendance_date
	GROUP BY period;
    
    --
    -- Result 
    --
    -- Attendance drops sharply before students leave.
    -- 16.6% in the final 30 days before their last recorded attendance.
    --
    -- This shows that declining attendance is a clear pattern 
    -- among students who eventually drop out.