CREATE MATERIALIZED VIEW excellentStudents(studentid,gpa) AS
	With noFailure(studentid,degreeid) AS(
			SELECT studentregistrationstodegrees.studentid,studentregistrationstodegrees.degreeid
			FROM studentregistrationstodegrees,courseregistrations
			WHERE studentregistrationstodegrees.studentregistrationid=courseregistrations.studentregistrationid
			GROUP BY studentregistrationstodegrees.studentid, studentregistrationstodegrees.degreeid
			HAVING MIN(courseregistrations.grade)>=5),
	maxGrade(studentid,degreeid,courseid,maxgrade,ect) AS(
			SELECT studentregistrationstodegrees.studentid,studentregistrationstodegrees.degreeid,courseoffers.courseid,max(courseregistrations.grade),courses.ects
			FROM studentregistrationstodegrees,courseregistrations,courses,courseoffers
			WHERE studentregistrationstodegrees.studentregistrationid=courseregistrations.studentregistrationid AND
			  courseoffers.courseofferid=courseregistrations.courseofferid AND courses.courseid=courseoffers.courseid AND 
			  (studentregistrationstodegrees.studentid, studentregistrationstodegrees.degreeid) IN (SELECT studentid,degreeid
										FROM noFailure)
			GROUP BY studentregistrationstodegrees.studentid, studentregistrationstodegrees.degreeid,courseoffers.courseid,courses.ects),
	nerdyStudents(studentid,degreeid,weightedtotalgrades,totalects) AS(
	SELECT studentid,degreeid, SUM (maxgrade*ect) AS weightedtotalgrades, SUM (ect) AS totalects
	FROM maxGrade
	GROUP BY studentid, degreeid)
	SELECT nerdyStudents.studentid,CAST (nerdyStudents.weightedtotalgrades AS FLOAT)/CAST(nerdyStudents.totalects AS FLOAT) as gpa
	FROM nerdyStudents, degrees
	WHERE nerdyStudents.degreeid=degrees.degreeid AND nerdyStudents.totalects>=degrees.totalects;
Create TEMP VIEW sufficientGrade(studentid,degreeid,courseid,ect) AS
	SELECT studentregistrationstodegrees.studentid,studentregistrationstodegrees.degreeid,courseoffers.courseid,max(courseregistrations.grade),courses.ects
	FROM studentregistrationstodegrees, courseregistrations,courses,courseoffers
	WHERE studentregistrationstodegrees.studentregistrationid=courseregistrations.studentregistrationid AND
		courses.courseid=courseoffers.courseid AND courseoffers.courseofferid=courseregistrations.courseofferid 
	AND courseregistrations.grade>=5
	GROUP BY studentregistrationstodegrees.studentid, studentregistrationstodegrees.degreeid,courseoffers.courseid,courses.ects;
Create TEMP VIEW totalECTS(studentid,degreeid,totalECTS) AS
	SELECT sufficientGrade.studentid,sufficientGrade.degreeid, SUM(sufficientGrade.ect) AS totalECTS
	FROM sufficientGrade
	GROUP BY sufficientGrade.studentid,sufficientGrade.degreeid;
CREATE TEMP VIEW activeStudents(studentid,degreeid) AS 
	SELECT totalECTS.studentid,degrees.degreeid
	FROM totalECTS, degrees
	WHERE totalECTS.degreeid=degrees.degreeid AND totalECTS.totalECTS<degrees.totalects;
CREATE INDEX idx_studentToDegree ON StudentRegistrationsToDegrees(DegreeId, StudentId);
CREATE MATERIALIZED VIEW ExcellentCourseStudents(StudentId, NumberOfCoursesWhereExcellent) AS
    WITH
        HighestGradeCourseOffers AS (
            SELECT cr.CourseOfferId, Max(Grade) AS highestGrade 
                FROM CourseRegistrations AS cr, CourseOffers AS co 
                    WHERE co.CourseOfferId=cr.CourseOfferId AND co.Quartile=1 AND co.Year=2018 
                        GROUP BY cr.CourseOfferId
        )
    SELECT st2deg.StudentId, COUNT(st2deg.StudentId) AS numberOfCoursesWhereExcellent 
        FROM HighestGradeCourseOffers AS gco, StudentRegistrationsToDegrees AS st2deg, CourseRegistrations AS cr 
            WHERE gco.CourseOfferId=cr.CourseOfferId AND cr.StudentRegistrationId=st2deg.StudentRegistrationId AND cr.Grade=gco.highestGrade 
                GROUP BY st2deg.StudentId;
