-- so in order to make our logical key we have to find duplicate values in the table
select name, count(name)
from anime
group by name
HAVING count(name) > 1;
-- we have 2 dublicate values so lets find what is wrong about them 
select * from anime where name ='Shi Wan Ge Leng Xiaohua';
-- one of the Shi Wan Ge Leng Xiaohua anime is a movie so lets change to that 
update anime set name='Shi Wan Ge Leng Xiaohua Movie ' where anime_id = 33195;
-- and for the other duplicate value lets check it 
select * from anime where name ='Saru Kani Gassen';
-- same way one of them is movie so lets correct that 
update anime set name = 'Saru Kani Gassen Movie' where anime_id = 30059;

-- so for now we do not have duplicate values so we can make our name column unique 
alter table anime add unique (name);
