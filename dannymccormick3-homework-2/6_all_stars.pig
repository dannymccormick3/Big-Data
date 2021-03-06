o_salary = LOAD '/data/cs4266/baseball/Salaries.csv' using PigStorage(',') AS (yearid:chararray,teamid:chararray,lgid:chararray,playerid:chararray,salary:int);
sal = FILTER o_salary BY playerid != 'playerID' AND yearid == '2000';
o_all_star = LOAD '/data/cs4266/baseball/AllstarFull.csv' using PigStorage(',') AS (playerid:chararray,yearid:chararray,gamenum:chararray,gameid:chararray,teamid:chararray,lgid:chararray,gp:chararray,startingpos:chararray);
all_star = FILTER o_all_star BY playerid != 'playerID' AND yearid == '2000';
together = JOIN sal BY playerid LEFT OUTER, all_star BY playerid;
all_star_together = FILTER together BY gamenum IS NULL;
all_star_group = group all_star_together ALL;
all_star_salary = FOREACH all_star_group GENERATE AVG(all_star_together.salary);
not_star_together = FILTER together BY gamenum IS NOT NULL;
not_star_group = group not_star_together ALL;
not_star_salary = FOREACH not_star_group GENERATE AVG(not_star_together.salary);
--result_salary = UNION all_star_salary, not_star_salary;
DUMP all_star_salary;