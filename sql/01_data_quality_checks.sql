-- 01_data_quality_checks.sql
-- Purpose: Check the underlying records before trusting any analysis  

USE arel;

-- Enrolment per status -- How Large is Unknown 
SELECT status, COUNT(*) AS total_enrolments
FROM enrolments 
GROUP BY status 
ORDER BY total_enrolments DESC;

-- 31.5%(195) of the enrolment records are unknown 

-- What share of student records are missing contact information
SELECT 
   SUM(email='') misiing_email,
   SUM(phone='') missing_phone
FROM students;
-- 75% of students have missing contact details

-- How many attendance sessions have no status recorded at all
SELECT  COUNT(*) AS total_sessions
FROM attendance 
GROUP BY status 
ORDER BY total_sessions DESC;

-- Not Recorded sessions as share of the whole attendance table
SELECT 
    ROUND(100.0* SUM(status = 'Not Recorded' ) / COUNT(*), 2) AS percentage_not_recorded
FROM attendance;

-- Decision made from these results, applied in every query
-- * Not recorded attendance rows are excluded from attendance 
-- (neither counter as attendance nor as absent )
