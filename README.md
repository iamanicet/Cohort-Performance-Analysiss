# Program Performance Analysis for a Digital Skills Training Org.
**Evaluation cohort 1-6 to plan for cohort 7 for AReL(Action for Refugee Life)**

> **Disclaimer** No real student, instructor, enrolment or attendance record was used.
> The structure follows how AReL's real records look, but every row was generated for this exercise.
> The findings below show how the analysis works. They are not conclusions about AReL's actual cohorts.

## Executive Summary
AReL's Monitoring & Evaluation is planning Cohort 7 & needs to know what worked or
failed in the previous cohorts.
Using MySQL, I analyzed enrolment and attendance records to find where and when 
students disengage.
**Attendance** is weakest on **Fridays** and mainly drops about a third of the way 
through every course and students who dropout shows absence building month to month rather than stopping suddenly.
These findings lead to recommendations on schedule, mid-course support and record keeping 
for cohort 7.


### Key Highlights
- Friday -weakest attendance: 53.7%, Monday - Strongest attendance : 63.2%
- Attendance starts at 67%, falls to 53% about a third of the way in course and ends
  at 47% across all courses.
- Students who eventually dropped went from 29.7% absence in their 1st month to 70.8%
  in the 7th, while students who completed stayed between 24% and 26%.

## Business Problem
AReL runs cohort based skills training, with several courses running side by side in each
cohort. Six cohorts have run since 2023. Before Cohort 7 is finalised, the M&E Unit wants to
use what the first six cohorts show to decide what to keep, what to change and what to fix
in how records are kept.

The central question: **what do attendance and enrolment patterns across Cohorts 1 to 6
say about how Cohort 7 should be scheduled, supported and recorded?**

This is a program wide analysis. It is not about any single course.

**Problem Visual (Concept): the cohorts are not equally easy to evaluate**

| Cohort | Class days | Enrolments | Enrolments with Unknown status |
|---|---|---|---|
| Cohort 1 | Mon, Wed, Fri | 29 | 6.9% |
| Cohort 2 | Mon, Wed, Fri | 107 | 9.3% |
| Cohort 3 | Mon, Wed, Fri | 119 | 13.4% |
| Cohort 4 | Mon, Wed, Fri | 99 | 57.6% |
| Cohort 5 | Mon, Wed, Fri | 88 | 62.5% |
| Cohort 6 | Mon to Fri | 123 | 30.9% |

**Initial Insight:** In Cohorts 4 and 5, more than half of all enrolments have no recorded
outcome. Any question about completion is much harder to answer for those cohorts, so
attendance became the main measure.

## Methodology

**Analytical Approach**

- Reviewed how the seven tables connect before writing any analysis.
- Checked data quality first (enrolment status, missing contact details, unrecorded
  sessions) and decided how to handle each gap.
- Defined the measures before using them:
  - **Attendance rate:** sessions marked Present or Late, divided by all recorded sessions.
  - **Absence rate:** sessions marked Absent, divided by all recorded sessions.
- Answered each business question with its own SQL script, covering every cohort and course.
- Checked surprising results before trusting them, including splitting one result by
  student group to see whether something else was driving it.

**Assumptions**

- Present and Late count as attended. Absent and Excused count as not attended for
  attendance rate. For absence rate, only Absent counts, so Excused is not treated as absence.
- Sessions marked Not Recorded are left out of every rate. I do not guess whether the
  student was there.
- Unknown enrolment status is kept as its own group. It is never assumed to mean Completed
  or Dropped.
- In the month by month analysis, a "month" is a block of 30 days counted from the first
  class of that course and cohort, not a calendar month.
- "Stage of course" compares sessions by how far through their own course they fall, using
  each course and cohort's own first and last recorded class date.
- Every scheduled weekday between a cohort's start and end date is treated as a class day.
  No public holidays, cancelled classes or breaks are modelled.
- Instructor periods come from the start and end dates in the assignment table.

**Technical Implementation**

- **Data checks:** `01_data_quality_checks.sql` counts statuses, missing contact details and
  unrecorded sessions.
- **Day and month patterns:** `02` and `03` group attendance by day of week and by calendar
  month.
- **Course stage:** `04` uses two CTEs and `DATEDIFF` to place every session in one of ten
  stages of its own course run.
- **Schedule comparison:** `05` compares the three day and five day schedules.
- **Absence pattern before dropout:** `06` tracks absence rate by month of enrolment for each
  final status.
- **Instructor changes:** `07` compares attendance before and after each mid-course handoff.
- **Course and cohort ranking:** `08` ranks every course and cohort combination, using
  `COUNT(DISTINCT ...)` so each student is counted once.


## Skills

**Tools and Techniques Used**

- **SQL (MySQL 8.0 or later):** CTEs, multi table JOINs, GROUP BY and HAVING, CASE WHEN,
  COUNT(DISTINCT), date functions (DATEDIFF, DATE_FORMAT), casting.
- **Analysis methods:** data quality assessment, metric definition, trend analysis over
  calendar time and over a course's own timeline, before and after comparison, and checking
  a result by splitting it into subgroups.
- **Business concepts:** cohort evaluation, engagement and dropout patterns, early warning
  indicators, record keeping and data governance.
- **Communication:** turning results into recommendations and stating limits plainly.

## Results and Business Recommendations

**Key Results**

- **Friday is the weakest day.** 53.5% attendance on Fridays, 63.2% on Mondays. Friday is the
  weakest day in all six cohorts and in seven of the nine course records. In the other two,
  Thursday is a little lower.
- **Every course dips about a third of the way through.** Attendance opens at 67.4%, drops to
  53.4% at the 30 to 40 percent mark, recovers to about 66% around the middle, then slides to
  47.0% at the end. The dip appears in all nine course records. How far the late slide goes
  varies: Full Stack Development ends near 36%, while Full Stack Development and AI
  Engineering ends near 59%.
- **The lowest months come at the end of Cohorts 4 and 5.** Attendance falls to 34.1% in
  August 2025 and 31.4% in February 2026. March 2026 reads 32.2% but rests on very few
  sessions.
- **The five day week made little difference.** 58.0% attendance under the five day schedule
  (Cohort 6) against 58.9% under the three day schedule (Cohorts 1 to 5). This rests on one
  cohort.
- **Dropout is preceded by a build up.** For students who dropped, absence rose from 29.7% in
  the first month to 45.5% in the fifth, 63.9% in the sixth and 70.8% in the seventh.
  Completed students stayed between about 24% and 36%, and Active students between about 25%
  and 38%. Both showed a small bump in the third month, matching the mid-course dip, but
  neither kept climbing.
- **Unknown status behaves like Dropped.** Students with an Unknown status follow almost the
  same rising curve as students marked Dropped (26.4% in the first month, 68.2% in the
  seventh). This could mean some Unknown records are students who disengaged without it
  being recorded. It could also be a feature of how this simulated data was built, so it is
  a question to test on real records, not a finding.
- **The one large instructor result does not hold up.** Attendance in Data Analysis,
  Cohort 4 fell from 63.9% to 36.3% after an instructor change, while two other changes
  barely moved (60.3% to 60.0%, and 64.7% to 62.6%). But 14 of the 19 enrolments in that
  course have an Unknown status. Split by status, Active students went up after the change
  (61.7% to 64.9%), while Unknown students fell from 63.7% to 28.0% and Dropped students from
  75.5% to 38.3%. The drop follows the students who lose attendance late in a course, not
  the instructor change. With three changes in total, the data cannot say whether
  instructor changes affect attendance.
- **The weakest offerings cluster by cohort, not by course.** Of the eight lowest attendance
  rates, six belong to Cohorts 4 and 5 and two to Cohort 6. Every Cohort 4 and Cohort 5
  offering is below 60%, while Cohorts 1 to 3 range from 59.2% to 65.2%. These are also the
  cohorts with the most Unknown statuses.
- **Completion rates cannot be trusted for Cohorts 4 to 6.** 57.6% of Cohort 4 enrolments,
  62.5% of Cohort 5 and 30.9% of Cohort 6 have no recorded outcome, and Cohort 6 is still
  running. Across all cohorts, 178 of 565 enrolments (31.5%) are Unknown.

**Data quality at a glance:** 75.0% of students are missing an email and 75.0% are missing a
phone number. 1,873 of 58,944 attendance rows (3.2%) are Not Recorded.

**Business Recommendations**

1. **Reduce reliance on Friday sessions.** Friday is the weakest day in every cohort and in
   most courses. Move one session earlier in the week, or make Friday a lighter session.
2. **Plan a check-in at the 30 to 40 percent mark of every course.** The dip appears in all
   nine course records, so support timed just before it is likely to help across the program.
3. **Watch monthly absence for each student as an early warning.** Look for a sustained climb
   over several months, not one bad month, since completers also have a bump in month three.
   Test the rule on students whose outcome is not yet known before relying on it.
4. **Close out every enrolment at the end of each cohort.** More than half of Cohort 4 and
   Cohort 5 enrolments have no outcome, which blocks any reliable completion analysis. Record
   Completed or Dropped for every student before the next cohort starts.
5. **Treat the five day schedule as undecided.** It shows no clear cost or benefit yet, and
   one cohort is not enough to settle it.
6. **Do not judge instructor changes from this data.** Record enrolment outcomes properly,
   then compare like with like across more handoffs before drawing conclusions.


## Limitations

- **The data is simulated.** Nothing here has been checked against real AReL records, and
  simulated patterns are only as real as the way the data was built.
- **The Unknown and Dropped similarity may come from the simulation itself.** It should not
  be treated as evidence about real records.
- **The instructor result is confounded.** Only three handoffs exist, and the largest drop
  overlaps with a course where most students have an Unknown status.
- **The schedule comparison rests on one cohort** under the five day pattern.
- **Attendance rate treats Excused as not attended.** A different rule would change the
  numbers.
- **The early warning idea looks backwards.** It shows dropouts had rising absence. It has
  not been tested on who will drop next.
- **No holidays or cancelled classes are modelled,** which a real attendance record would
  contain.
- **The very last month of some courses rests on few sessions,** so those points are less
  steady than the rest.

## Next Steps

- **Repeat the analysis on real records** once statuses have been cleaned, and check which of
  these patterns survive.
- **Test the early warning rule** on a cohort where outcomes are still unknown, and measure
  how many students it flags correctly and incorrectly.
- **Revisit the schedule question** when Cohort 7 gives a second cohort to compare.
- **Rerun the instructor comparison** once statuses are recorded, so students with the same
  status can be compared before and after a change.
- **Build a dashboard** (for example in Power BI) so the M&E Unit can filter by cohort,
  course and day without writing SQL.

## Repository Structure

```
arel-cohort7-planning-project/
  README.md
  data/
      cohorts.csv
      courses.csv
      instructors.csv
      instructor_assignments.csv
      students.csv
      enrolments.csv
      attendance.csv
  sql/
      01_data_quality_checks.sql
      02_attendance_by_day_of_week.sql
      03_attendance_by_month.sql
      04_attendance_by_course_progress.sql
      05_schedule_comparison.sql
      06_absence_pattern_before_dropout.sql
      07_instructor_handoff_impact.sql
      08_course_cohort_ranking.sql
  docs/
      (screenshots of your charts)
```

SQL scripts directory: `/sql/`

## Contact

Name: Anicet Baraka CIza

LinkedIn: https://www.linkedin.com/in/anicetbarakaciza/?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BecQzM0I%2BRMO6dL%2BQo38lmw%3D%3D

GitHub: [Anicet Baraka Ciza] (https://github.com/iamanicet)

Email: cizaanicetbaraka@gmail.com
