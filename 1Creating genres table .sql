-- let create 2 column in order to pu values of genre into. Our table currently not atomic
-- since genre table contains many values 

alter table anime add g1 varchar(30);
-- lets put all the first values into g1 
update anime set g1=split_part(genre,',',1);

-- and make it for g2 
alter table anime add g2 varchar(30);
update anime set g2=split_part(genre,',',2);

-- lets create genre table so we can extract all the values in to that table
create table genre(name varchar(30));

select  
max(array_length(
    regexp_split_to_array(genre , ',')
    , 1
  ))
from anime a;
-- from that place we know that max values for the genre is 13 

select * from genre;
-- now there is nothing in the genre table lets add all the genres with comma seperation and after 
-- that we will delete duplicate rows
insert into genre(name) select distinct (split_part(genre,',',1)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',2)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',3)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',4)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',5)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',6)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',7)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',8)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',9)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',10)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',11)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',12)) from anime; 
insert into genre(name) select distinct (split_part(genre,',',13)) from anime; 

-- now lets take a look at genre table 
select * from genre;
-- now lets take a look at unique values 
select distinct * from genre;
-- delete empty and null rows 
delete from genre where name = '';
delete from genre where name is null;


-- now lets detect the duplicate rows 

select name, count(name) from genre group by name;
-- we have plenty lets delete them 


DELETE FROM genre
WHERE name IN
    (SELECT name
    FROM 
        (SELECT name,
         ROW_NUMBER() OVER( PARTITION BY name
        ORDER BY  name ) AS row_num
        FROM genre ) t
        WHERE t.row_num > 1 ); 
        
 -- lets check 
       
 select * from genres;
-- give it a id 

alter table genre add id serial primary key;
-- changing table name to diffrent thing since there is a also column name genre 
alter table genre rename to genres;

 select count (*) from anime;

SELECT a.*  
FROM anime a 
where  EXISTS 
      ( SELECT * 
        FROM genres g  
        WHERE a.genre LIKE '%' || g.name || '%'
      ) ;
      
 -- we got it all only null values is not in our genre table! 