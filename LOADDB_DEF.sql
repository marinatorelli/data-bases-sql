-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- -- SCRIPT FOR INSERTING ALL DATA FROM OLD TABLES ---------------------------
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- Inserting Makers, Managers, Publishers, and Studios
-- ----------------------------------------------------------------------------

INSERT INTO MAKERS(mk_name, mk_address)
(SELECT DISTINCT mk1_comp, mk1_addr FROM vinyl
UNION
SELECT DISTINCT mk2_comp, mk2_addr FROM vinyl);
-- 50 ROWS

INSERT INTO  MANAGERS(m_name, m_surn1,m_surn2,m_phone)
(SELECT DISTINCT mng_name,mng_surn1,mng_surn2,mng_phone FROM vinyl);
--125 ROWS

INSERT INTO PUBLISHERS (p_name, pub_phone)
(SELECT DISTINCT publisher, pub_phone FROM vinyl);
 --30 ROWS
 
INSERT INTO STUDIOS(s_name,s_adress,t_name,t_surname1,t_surname2)
(SELECT DISTINCT rec_studio,rs_address,tech_name,tech_surn1,tech_surn2 FROM vinyl); 
 --40 ROWS


-- ----------------------------------------------------------------------------
-- Inserting Artists (both solists and groups) and group Members
-- ----------------------------------------------------------------------------

INSERT INTO ARTISTS(name,nationality,language)
(SELECT DISTINCT artist,nationality,language FROM vinyl);  
--695 ROWS

INSERT INTO MEMBERS(group_name,role,name,start_g,end_g)
(SELECT DISTINCT artist, rol1, member1, MIN(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')), MAX(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')) 
FROM vinyl WHERE rol1 IS NOT NULL and member1 IS NOT NULL GROUP BY artist, rol1, member1);
--186 ROWS
INSERT INTO MEMBERS(group_name,role,name,start_g,end_g)
(SELECT DISTINCT artist, rol2, member2, MIN(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')), MAX(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')) 
FROM vinyl WHERE rol2 IS NOT NULL and member2 IS NOT NULL GROUP BY artist, rol2, member2);
--190 ROWS
INSERT INTO MEMBERS(group_name,role,name,start_g,end_g)
(SELECT DISTINCT artist, rol3, member3, MIN(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')), MAX(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')) 
FROM vinyl WHERE rol3 IS NOT NULL and member3 IS NOT NULL GROUP BY artist, rol3, member3);
-- 151 ROWS
INSERT INTO MEMBERS(group_name,role,name,start_g,end_g)
(SELECT DISTINCT artist, rol4, member4, MIN(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')), MAX(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')) 
FROM vinyl WHERE rol4 IS NOT NULL and member4 IS NOT NULL GROUP BY artist, rol4, member4);
--97 ROWS
INSERT INTO MEMBERS(group_name,role,name,start_g,end_g)
(SELECT DISTINCT artist, rol5, member5, MIN(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')), MAX(to_date (rel_date, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American')) 
FROM vinyl WHERE rol5 IS NOT NULL and member5 IS NOT NULL GROUP BY artist, rol5, member5);
-- 25 ROWS
-- Notice the implicit semantic applied regarding the membership periods 


-- ----------------------------------------------------------------------------
-- Inserting Discs, Songs, Tracks, Albums, singles and Rankings
-- ----------------------------------------------------------------------------

INSERT INTO DISCS (ISVN,artist,format,speed,hole,color,album, rel_date, publisher,mng_name,mng_surn1,mk1_comp,mk2_comp)
(SELECT DISTINCT ISVN,artist, CASE format when 'single' then 'S' else 'L' end format,speed,hole,color,album, 
                 TO_DATE(rel_date, 'dd-mm-yyyy','NLS_DATE_LANGUAGE=American'),publisher,mng_name,mng_surn1,mk1_comp,mk2_comp 
        FROM vinyl);
-- 21,561 ROWS

INSERT INTO SONGS (title,writer) 
(SELECT DISTINCT title, writer FROM vinyl);
-- 123,769 ROWS

INSERT INTO TRACKS(ISVN,trackN,side,writer,title_s,duration,studio)
(SELECT DISTINCT ISVN,track,case side when 'Side A' then 'A' else 'B' end side,writer,title, 
TO_NUMBER(SUBSTR(duration, 1,INSTR(duration,':',1,1)-1), '99')*60 + TO_NUMBER(SUBSTR(duration,INSTR(duration,':',1,1)+1), '99'),rec_studio
FROM vinyl); 

-- 146,278 ROWS

INSERT INTO ALBUMS (ISVN,copies,total)
(SELECT DISTINCT ISVN, rel_copies,tot_copies FROM vinyl WHERE format like 'LP%');
-- 8,791 ROWS

INSERT INTO SINGLES (ISVN,ISVN_ALB)
(SELECT DISTINCT a.isvn, MAX(b.isvn) 
   FROM (SELECT isvn, rel_copies,tot_copies, album, writer 
            FROM vinyl where format='single') a 
                 JOIN (SELECT isvn, title, writer FROM vinyl WHERE format like 'LP%') b ON (a.album=b.title and a.writer=b.writer) 
            GROUP BY a.isvn);
-- 12,770 ROWS

-- RANKINGS
INSERT INTO RANKINGS (ISVN,side, position,weeks)
(SELECT DISTINCT isvn, case side when 'Side A' then 'A' else 'B' end, rel_copies, NVL(tot_copies,1) 
    FROM vinyl where format='single' AND rel_copies IS NOT NULL);
-- 18,943 ROWS


-- ----------------------------------------------------------------------------
-- Inserting covers' staff: photographers, designers, etc.
-- ----------------------------------------------------------------------------

-- FRONT COVER
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk1_phtg, 1,INSTR(mk1_phtg,':',1,1)-1), 'A', SUBSTR(mk1_phtg,INSTR(mk1_phtg,':',1,1)+1)
FROM vinyl WHERE mk1_phtg IS NOT NULL);
-- 14,307 ROWS
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk1_draw, 1,INSTR(mk1_draw,':',1,1)-1), 'A', SUBSTR(mk1_draw,INSTR(mk1_draw,':',1,1)+1)
FROM vinyl WHERE mk1_draw IS NOT NULL);
-- 8,687 ROWS
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk1_layt, 1,INSTR(mk1_layt,':',1,1)-1), 'A', SUBSTR(mk1_layt,INSTR(mk1_layt,':',1,1)+1)
FROM vinyl WHERE mk1_layt IS NOT NULL);
-- 21,162 ROWS
-- BACK COVER
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk2_phtg, 1,INSTR(mk2_phtg,':',1,1)-1), 'B', SUBSTR(mk2_phtg,INSTR(mk2_phtg,':',1,1)+1)
FROM vinyl WHERE mk2_phtg IS NOT NULL);
-- 14,381 ROWS
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk2_draw, 1,INSTR(mk2_draw,':',1,1)-1), 'B', SUBSTR(mk2_draw,INSTR(mk2_draw,':',1,1)+1)
FROM vinyl WHERE mk2_draw IS NOT NULL);
-- 8,577 ROWS
INSERT INTO SLEEVES (ISVN,role,side,c_name)
(SELECT DISTINCT ISVN, SUBSTR(mk2_layt, 1,INSTR(mk2_layt,':',1,1)-1), 'B', SUBSTR(mk2_layt,INSTR(mk2_layt,':',1,1)+1)
FROM vinyl WHERE mk2_layt IS NOT NULL);
-- 21,123 ROWS


-- ----------------------------------------------------------------------------
-- Inserting Radio stations, and playbacks
-- ----------------------------------------------------------------------------

INSERT INTO RADIOS (name,address,web,e_mail,phone)
(SELECT DISTINCT station,st_Address,st_web,st_email,st_phone FROM hits);
-- 15 ROWS

INSERT INTO PLAYBACKS (station,playdatetime,ISVN,trackN,side)
WITH allHits AS
   (SELECT station, datetime, substr(uno,instr(uno,'/',1)+1) title, substr(uno,1,instr(uno,'/',1)-1) artist FROM
      (SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI') datetime, MIN(artist||'/'||title) uno
          FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=2
       UNION
       SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI')+1/2880 datetime, MAX(artist||'/'||title) uno
          FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=2 )
   UNION
   SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI') datetime, MAX(title) title, MAX(artist) artist
      FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=1 ),
   isvnHits AS (SELECT to_number(SUBSTR(artist,6)) isvn, title, datetime, station FROM allHits WHERE artist like 'ISVN:%')
(SELECT DISTINCT station,datetime,a.isvn, SUBSTR(MIN(b.side||b.trackn),2), SUBSTR(MIN(b.side||b.trackn),1,1)
   FROM isvnHits a JOIN TRACKS b ON (a.isvn=b.isvn and a.title=b.title_s)
   GROUP BY station,datetime,a.isvn
);
-- 4,925 ROWS

INSERT INTO PLAYBACKS (station,playdatetime,ISVN,trackN,side)
WITH allHits AS
   (SELECT station, datetime, substr(uno,instr(uno,'/',1)+1) title, substr(uno,1,instr(uno,'/',1)-1) artist FROM
      (SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI') datetime, MIN(artist||'/'||title) uno
          FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=2
       UNION
       SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI')+1/2880 datetime, MAX(artist||'/'||title) uno
          FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=2 )
   UNION
   SELECT STATION, TO_DATE(PLAYDATE||' '||PLAytime,'DD-MM-YYYY HH24:MI') datetime, MAX(title) title, MAX(artist) artist
      FROM HITS GROUP BY STATION, PLAYDATE, PLAYTIME HAVING COUNT('V')=1 ),
   artHits AS (SELECT artist, title, datetime, station FROM allHits WHERE artist not like 'ISVN:%'),
   myDiscs AS (SELECT station, datetime, title, isvn FROM (Select isvn,artist from discs) A JOIN artHits B ON(A.artist=B.artist)),
   rndTrack AS (SELECT station,datetime, MIN(tracks.isvn||'/'||trackn||'/'||side) fulltrack
                  FROM TRACKS JOIN myDiscs ON (tracks.title_s=mydiscs.title AND tracks.isvn=mydiscs.isvn) GROUP BY station,datetime)
SELECT station,datetime, substr(fulltrack,1,instr(fulltrack,'/',1)-1),
       substr(fulltrack, instr(fulltrack,'/',1,1)+1, instr(fulltrack,'/',1,2)-1-instr(fulltrack,'/',1,1)), 
       substr(fulltrack,instr(fulltrack,'/',1,2)+1)
       FROM rndTrack;
-- 45,072 ROWS


-- ----------------------------------------------------------------------------
-- Inserting orders related info: Clients and order_lines
-- ----------------------------------------------------------------------------

INSERT INTO CLIENTS (e_mail,name,surn1,surn2,birthdate,phone, address,DNI)
(SELECT DISTINCT cl_email, cl_name,cl_surn1,cl_surn2,to_date(cl_birth, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American'),cl_phone,cl_address,cl_dni 
   FROM purchases WHERE cl_email IS NOT NULL and cl_dni IS NOT NULL and cl_phone IS NOT NULL) 
MINUS (SELECT DISTINCT cl_email,cl_name,cl_surn1,cl_surn2,to_date(cl_birth, 'dd-month-yyyy', 'NLS_DATE_LANGUAGE=American'),cl_phone,cl_address,cl_dni 
         FROM purchases WHERE CL_DNI='06871656' AND CL_NAME='John' AND CL_SURN1='Doe');
-- 1,500 ROWS
-- There is a uniqueness ERROR (substract  tuple)

INSERT INTO SALE_LINE (ISVN,e_mail,order_s,qtty,delivery)
WITH datedisc AS (SELECT artist,album, MIN(rel_date) rel_date FROM discs group by artist,album),
     olddisc AS (SELECT isvn, artist,album FROM discs a JOIN datedisc b USING(artist,album,rel_date)),
     lines AS (SELECT d.ISVN, c.cl_email,c.orddate, count('X') qtty, MAX(dlvdate) dlvdate
                  FROM (SELECT DISTINCT cl_email, artist, album,
                               to_date(order_date,'dd-mm-yyyy') orddate, to_date(delvr_date,'dd-mm-yyyy') dlvdate
                           FROM purchases 
                           WHERE (cl_email IS NOT NULL) AND (CL_EMAIL<>'johnny@clients.vinylinc.com') ) c 
                  JOIN olddisc d USING(artist,album)
               GROUP BY d.ISVN, c.cl_email, c.orddate)
SELECT ISVN, cl_email, orddate, qtty, CASE WHEN orddate>dlvdate THEN orddate ELSE dlvdate end FROM lines;
-- 119,691 ROWS
-- Notice the implicit semantic for solving the semantic error (dlv date should be greater than or equal to ord date)
-- Notice that non valid clients (2) are skipped, and by joining with discs we solve purchases of non-existent discs

COMMIT;
