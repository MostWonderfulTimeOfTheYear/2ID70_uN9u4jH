SELECT 0;
SELECT 0;
SELECT 0;
WITH StudentsInDegree AS (SELECT st.StudentId, st.Gender FROM Students AS st, StudentRegistrationsToDegrees AS st2deg, Degrees AS deg  WHERE st2deg.DegreeId=deg.DegreeId AND st.StudentId=st2deg.StudentId AND deg.Dept=%1%) SELECT (1. * COUNT(*) / (SELECT COUNT(*) FROM StudentsInDegree)) AS percentage FROM StudentsInDegree WHERE Gender='F';
SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
