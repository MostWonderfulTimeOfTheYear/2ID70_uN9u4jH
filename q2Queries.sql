SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
WITH CourseOfferGradesBelow(CourseId, Below) AS (SELECT co.CourseId, COUNT(co.CourseId) AS Below FROM CourseRegistrations as cr, CourseOffers as co WHERE cr.Grade < %1% AND co.CourseOfferId=cr.CourseOfferId GROUP BY co.CourseId),CourseOfferGradesAbove(CourseId, Above) AS ( SELECT co.CourseId, COUNT(co.CourseId) AS Above FROM CourseRegistrations as cr, CourseOffers as co WHERE cr.Grade >= %1% AND co.CourseOfferId=cr.CourseOfferId GROUP BY co.CourseId)SELECT cogb.CourseId, (1. * (coga.Above) / (cogb.Below + coga.Above)) as percentagePassing FROM CourseOfferGradesBelow AS cogb, CourseOfferGradesAbove coga WHERE cogb.CourseId=coga.CourseId GROUP BY cogb.CourseId, coga.Above, cogb.Below  ORDER BY cogb.CourseId;
SELECT 0;
SELECT 0;
SELECT 0;
