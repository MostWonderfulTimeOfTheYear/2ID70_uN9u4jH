SELECT 0;
SELECT 0;
SELECT 0;
WITH StudentsInDegree AS (SELECT st.StudentId, st.Gender FROM Students AS st, StudentRegistrationsToDegrees AS st2deg, Degrees AS deg  WHERE st2deg.DegreeId=deg.DegreeId AND st.StudentId=st2deg.StudentId AND deg.Dept=%1%) SELECT (1. * COUNT(*) / (SELECT COUNT(*) FROM StudentsInDegree)) AS percentage FROM StudentsInDegree WHERE Gender='F';
WITH CourseOfferGradesBelow AS (SELECT co.CourseId, COUNT(co.CourseId) AS Below FROM CourseRegistrations as cr, CourseOffers as co WHERE cr.Grade < %1% AND co.CourseOfferId=cr.CourseOfferId GROUP BY co.CourseId),CourseOfferGradesAbove AS ( SELECT co.CourseId, COUNT(co.CourseId) AS Above FROM CourseRegistrations as cr, CourseOffers as co WHERE cr.Grade >= %1% AND co.CourseOfferId=cr.CourseOfferId GROUP BY co.CourseId)SELECT cogb.CourseId, (1. * (coga.Above) / (cogb.Below + coga.Above)) as percentagePassing FROM CourseOfferGradesBelow AS cogb, CourseOfferGradesAbove coga WHERE cogb.CourseId=coga.CourseId GROUP BY cogb.CourseId, coga.Above, cogb.Below  ORDER BY cogb.CourseId;
SELECT 0;
SELECT 0;
SELECT 0;
