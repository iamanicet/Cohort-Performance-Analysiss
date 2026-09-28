-- 08(b.query)_course_cohort_ranking.sql
-- Purpose: rank every course/cohort combination that has run in the program 
-- by attendance rate, alongside its completion rate, to spot which specific
-- offerings are underperforming and whether any course repeats near the 
-- bottom across multiple cohorts.

WITH att AS (
   SELECT 
      e.course_id,
      e.cohort_id,
      ROUND(100.0 * SUM(a.status IN ('Present', 'Late')) / COUNT(*),1) AS attendance_rate
	FROM enrolments e 
    JOIN attendance a ON a.enrolment_id = e.enrolment_id
    WHERE a.status != 'Not Recorded'
    GROUP BY e.course_id, e.cohort_id
),
comp AS (
 SELECT 
     course_id,
     cohort_id,
     ROUND(100.0 * SUM(status = 'Completed') / COUNT(*), 1) AS completion_rate,
     COUNT(*) AS enrolled 
	FROM enrolments
    GROUP BY course_id, cohort_id
)
SELECT
  c.course_name,
  ch.cohort_label,
  att.attendance_rate,
  comp.completion_rate,
  comp.enrolled
FROM att
JOIN comp ON att.course_id = comp.course_id AND att.cohort_id = comp.cohort_id
JOIN courses c ON c.course_id = att.course_id
JOIN cohorts ch ON ch.cohort_id = att.cohort_id
WHERE ch.end_date < CURDATE()   -- exclude Cohort 6, still in progress
ORDER BY att.attendance_rate ASC;

-- Result: with Cohort 6 excluded, the true bottom of the ranking is 
-- Data Analysis/Cohort 5 (49.4% attendance, 11.5% completion) and 
-- Data Analysis/Cohort 4 (50.4%, 0.0%) - Data Analysis is the only 
-- course that repeats near the bottom across two different cohorts, 
-- both from the same Cohort 4-5 window flagged in query 11 for its 
-- record-keeping gap (57-63% Unknown status), so low completion here 
-- should be read with that caveat, not as a standalone course problem.

-- Decision made from this query, to be applied consistently:
-- * In-progress cohorts (end_date >= today) are always excluded from 
-- any ranking or comparison that includes completion_rate, otherwise 
-- they falsely appear as the worst performers by default.