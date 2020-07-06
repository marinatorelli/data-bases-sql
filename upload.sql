INSERT INTO MANAGER SELECT DISTINCT mng_name, mng_surn1, mng_surn2, mng_phone FROM VINYL;

INSERT INTO RECORD_COMPANY SELECT DISTINCT publisher, pub_phone FROM VINYL;

INSERT INTO RECORDING_STUDIO SELECT DISTINCT rec_studio, rs_address, tech_name, tech_surn1, tech_surn2 FROM VINYL;

INSERT INTO ARTIST SELECT DISTINCT artist FROM VINYL;

INSERT INTO MEMBER SELECT DISTINCT member1, rol1, nationality, language, artist FROM VINYL WHERE rol1 IS NOT NULL;

INSERT INTO MEMBER SELECT DISTINCT member2, rol2, nationality, language, artist FROM VINYL WHERE member2 IS NOT NULL AND rol2 IS NOT NULL;

INSERT INTO MEMBER SELECT DISTINCT member3, rol3, nationality, language, artist FROM VINYL WHERE member3 IS NOT NULL AND rol3 IS NOT NULL;

INSERT INTO MEMBER SELECT DISTINCT member4, rol4, nationality, language, artist FROM VINYL WHERE member4 IS NOT NULL AND rol4 IS NOT NULL;

INSERT INTO MEMBER SELECT DISTINCT member5, rol5, nationality, language, artist FROM VINYL WHERE member5 IS NOT NULL AND rol5 IS NOT NULL;

INSERT INTO COVER SELECT DISTINCT mk1_comp, mk1_addr FROM VINYL;

INSERT INTO BACK_COVER SELECT DISTINCT mk2_comp, mk2_addr FROM VINYL;

INSERT INTO ALBUM_LP SELECT DISTINCT ISVN, album, speed, hole, artist, publisher, TO_DATE(rel_date, 'DD-MONTH-YYYY'), rel_copies, tot_copies, mng_phone, rec_studio, tech_name, tech_surn1, mk1_comp, mk1_addr, mk1_draw, mk1_layt, mk2_comp, mk2_addr, mk2_draw, mk2_layt FROM VINYL WHERE format = 'LP vinyl';

INSERT INTO ALBUM_SINGLE SELECT DISTINCT ISVN, album, speed, hole, artist, publisher, TO_DATE(rel_date, 'DD-MONTH-YYYY'), rel_copies, tot_copies, mng_phone, rec_studio, tech_name, tech_surn1, mk1_comp, mk1_addr, mk1_draw, mk1_layt, mk2_comp, mk2_addr, mk2_draw, mk2_layt FROM VINYL WHERE format = 'single' AND rel_copies IS NOT NULL AND tot_copies IS NOT NULL;

INSERT INTO SONG_LP SELECT DISTINCT title, side, track, duration, writer, isvn FROM VINYL WHERE format = 'LP vinyl';

INSERT INTO SONG_SINGLE SELECT DISTINCT title, side, track, duration, writer, isvn, rel_copies, tot_copies FROM VINYL WHERE format = 'single' AND rel_copies IS NOT NULL AND tot_copies IS NOT NULL;

INSERT INTO RADIO_STATION SELECT DISTINCT station, st_Address, st_web, st_email, st_phone FROM HITS;

INSERT INTO RADIO_HITS SELECT DISTINCT hits.title, hits.artist, vinyl.isvn, vinyl.rel_copies, vinyl.tot_copies, TO_DATE(hits.playdate, 'DD-MM-YYYY'), hits.playtime, hits.station FROM HITS, VINYL WHERE hits.title=vinyl.title AND hits.artist=vinyl.artist AND vinyl.format='single' AND vinyl.rel_copies IS NOT NULL AND vinyl.tot_copies IS NOT NULL;

INSERT INTO RADIO_HITS SELECT DISTINCT hits.title, vinyl.artist, SUBSTR(hits.artist, 6), vinyl.rel_copies, vinyl.tot_copies, TO_DATE(hits.playdate, 'DD-MM-YYYY'), hits.playtime, hits.station FROM HITS, VINYL WHERE hits.title=vinyl.title AND SUBSTR(hits.artist, 6) = vinyl.isvn AND vinyl.format='single' AND vinyl.rel_copies IS NOT NULL AND vinyl.tot_copies IS NOT NULL;

INSERT INTO CLIENT SELECT DISTINCT cl_name, cl_surn1, cl_surn2, cl_dni, cl_birth, cl_phone, cl_email, cl_address FROM PURCHASES WHERE cl_dni IS NOT NULL;

INSERT INTO PURCH SELECT DISTINCT purchases.cl_dni, purchases.cl_phone, vinyl.isvn, purchases.artist, TO_DATE(purchases.order_date, 'DD-MM-YYYY'), TO_DATE(purchases.delvr_date, 'DD-MM-YYYY') FROM PURCHASES, VINYL WHERE cl_dni IS NOT NULL AND vinyl.album=purchases.album AND vinyl.artist=purchases.artist AND vinyl.format='LP vinyl' AND TO_DATE(purchases.delvr_date, 'DD-MM-YYYY') >= TO_DATE(purchases.order_date, 'DD-MM-YYYY');