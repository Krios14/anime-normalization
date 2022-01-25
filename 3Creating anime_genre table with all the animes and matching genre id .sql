-- unfortunately there are some duplicate values in genres table so lets find and delete them 
select name,  count("name")
from genres g 
group by "name" ;
-- it turns out that since there is space in the begining of the world it count it as distinct genre 
SELECT distinct(TRIM(name)) AS TrimmedString from genres ;
-- we find out that with trimming our genres are nearly halfed 

-- for anime table we must use replace instead of trim since trim only deletes first space not all the spaces between commas 
select replace(genre,' ','') from anime;
--this is what we want let update the table 
update anime set genre =  replace(genre,' ','');

select  * from anime order by anime_id ;
select count(*) from anime;
-- we also need to trim genre table so lets do that 

alter table genres drop constraint lmao;
update genres set name =  replace(name ,' ','');
-- we will have duplicate values lets delete them 
select name,count(name)
from genres g 
group by name
HAVING count(name) > 1;

select * from genres g;
select distinct  name  from genres;
-- lets delete those rows 


DELETE FROM genres  
  WHERE ctid = ANY(ARRAY(SELECT ctid 
                  FROM (SELECT row_number() OVER (PARTITION BY "name"), ctid 
                           FROM genres) x 
                 WHERE x.row_number > 1));

                select * from genres g;
SELECT count(a.*)  
FROM anime a 
where  EXISTS 
      ( SELECT * 
        FROM genres g  
        WHERE a.genre LIKE '%' || g.name || '%'
      ) ;
-- we now have completed our genres table lets contunie 
-- we should reset the id of the genre table before contunie;
alter table genres drop column id;
alter table genres add id serial primary key;

select * from genres;

-- now we will match all the genres with the anime_id s so lets try that 

-- CREATION OF ANIME GENRE_TABLE 
select anime_id,genre  from anime;
-- lets create a table like this than we will split comma values in genre column 
-- now we have all the ids and genres lets split them apart 


SELECT 
  anime_id ,
  UNNEST(STRING_TO_ARRAY(genre, ',')) AS genre
FROM anime a ;

-- this is the result we wanted to see so lets create a new table and put this values into it after 

create table anime_genre( anime_id int8, genre varchar(30));
insert into anime_genre (anime_id,genre) SELECT 
  anime_id ,
  UNNEST(STRING_TO_ARRAY(genre, ',')) AS genre
FROM anime a ;

alter table anime_genre  alter column anime_id set not null;
alter table anime_genre  alter column genre set not null;

select * from anime_genre where genre is not null;



alter table anime_genre add genre_id int8;

-- now we have to put all the ids into the id table 

select distinct(genre) from anime_genre  where genre not in (select name from genres g);

-- we find out that some of the genres where not in genres table so lets add them in 

insert into genres(name) select distinct(genre) from anime_genre  where genre not in (select name from genres g);

select * from genres;
--       DISCLAIMER we will find out there is mistakes about the table but in first 54 rows we solve that problem 
--  you can still use insert into statement but it will add nothing since our new genres table has everything. 


-- finally we insert values from genres table now we have two foreign key in the anime_genre  table 
update anime_genre  
set genre_id = genres.id 
from genres where anime_genre.genre=genres."name";

select * from anime_genre;


-- lets make anime_id and genre_id foreign key 

ALTER TABLE anime_genre
    ADD CONSTRAINT fk_anime_genre_genre FOREIGN KEY (genre_id) REFERENCES genres  (id);
  ALTER TABLE anime_genre 
    ADD CONSTRAINT fk_anime_genre_anime FOREIGN KEY (anime_id) REFERENCES anime (anime_id);
   
 -- so those two now are foreign  key 
 -- for example following code wil give us all the  Shounen anime is our table 
 
 select * from anime where anime_id in (select anime_id from anime_genre where genre_id=8);
 
 
 --   we can simply solve this issue instead of doing all the work by using like clause but this is not how databases work 
 -- anime table violating first normal form since genre column is not atomic it containse several values. 
 --   We could use like clause and it will be fast but we only have 10k row i shape the database which it will run fast even with the millions of the records. 
 -- Furter improvements can be done
   

