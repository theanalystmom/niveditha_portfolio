SELECT * FROM us_household_project.ushouseholdincome;

SELECT * FROM us_household_project.ushouseholdincome_statistics;

ALTER TABLE us_household_project.ushouseholdincome_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT COUNT(id)
FROM us_household_project.ushouseholdincome;

SELECT COUNT(id)
FROM us_household_project.ushouseholdincome_statistics;

SET SQL_SAFE_UPDATES = 0;

 #Identifying duplicates
 SELECT id,COUNT(id)
 FROM us_household_project.ushouseholdincome
 GROUP BY id
 HAVING COUNT(id)>1;
 
 #Removing duplicates
delete from us_household_project.ushouseholdincome
where row_id IN(
				select row_id 
				from (
					  select row_id,id,
					  ROW_NUMBER() OVER(PARTITION BY id order by id)row_num
					  from us_household_project.ushouseholdincome
					  )duplicates
               where row_num> 1);
               

select State_Name,count(State_Name)
from us_household_project.ushouseholdincome
group by State_Name;

update us_household_project.ushouseholdincome
set State_Name = 'Alabama'
where State_Name = 'alabama';

#Populating the missing place
 select * 
 from us_household_project.ushouseholdincome
 where County = 'Autauga County'
 order by 1;
 
 update us_household_project.ushouseholdincome
set Place = 'Autaugaville'
where County = 'Autauga County'
and City = 'Vinemont';

select Type,Count(type)
from us_household_project.ushouseholdincome
group by Type;

update us_household_project.ushouseholdincome
set Type = 'Borough'
where Type = 'Boroughs';

select ALand,AWater
from us_household_project.ushouseholdincome
where (AWater = 0 or AWater = '' or AWater IS NULL)
AND (ALand = 0 or ALand = '' or ALand IS NULL);

#EDA

Select State_Name,ALand,AWater
from us_household_project.ushouseholdincome;

#The largest area and water by state
select State_Name, sum(ALand),sum(AWater)
from us_household_project.ushouseholdincome
group by State_Name
order by 2 desc 
limit 10;

select *
from us_household_project.ushouseholdincome u
inner join us_household_project.ushouseholdincome_statistics us
on u.id = us.id
where Mean <> 0;


#Highest Mean incomes
select u.State_Name,round(avg(Mean),1),round(avg(Median),1)
from us_household_project.ushouseholdincome u
inner join us_household_project.ushouseholdincome_statistics us
on u.id = us.id
where Mean <> 0
group by u.State_Name
order by 2 desc
limit 10
;

#Highest Median incomes
select u.State_Name,round(avg(Mean),1),round(avg(Median),1)
from us_household_project.ushouseholdincome u
inner join us_household_project.ushouseholdincome_statistics us
on u.id = us.id
where Mean <> 0
group by u.State_Name
order by 3 desc
limit 10
;


Select Type,count(Type),round(avg(Mean),1),round(avg(Median),1)
from us_household_project.ushouseholdincome u
inner join us_household_project.ushouseholdincome_statistics us
on u.id = us.id
where Mean <> 0
group by Type
having count(Type) > 100
order by 4 desc
limit 20;


select * 
from us_household_project.ushouseholdincome
where type = 'Community';

#Highest Income households by states

select u.State_Name,City,round(avg(Mean),1),round(avg(Median),1)
from us_household_project.ushouseholdincome u
inner join us_household_project.ushouseholdincome_statistics us
on u.id = us.id
group by u.State_Name, City
order by round(avg(Mean),1) desc;
