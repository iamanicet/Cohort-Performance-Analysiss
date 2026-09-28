-- 03_attendance_by_month

-- Question
-- Does attendance decline as the courses progress ?

SELECT 
    DATE_FORMAT(session_date, '%Y-%m') AS month_,
    ROUND (
           100* SUM(status IN ('Present', 'Late')) / COUNT(*),
           1
           ) AS attendance_rate,
           
           COUNT(*) AS total_sessions
FROM attendance
WHERE status != 'Not Recorded'
GROUP BY month_;

-- Result:
--
-- Attendance starts high at the beginning of the program
-- and declines as the courses progress. 
