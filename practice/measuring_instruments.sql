/*
* Create a table for test data
* Insert values for testing
* A function that returns a floating average value measured on an instrument. Displays the last 5 records.
* Cleaning up a test project
*/

CREATE SCHEMA mcza_test;

DROP TABLE IF EXISTS mcza_test.measuring_instruments;
DROP SEQUENCE IF EXISTS mcza_test.seq_measuring_instruments_id;

CREATE SEQUENCE mcza_test.seq_measuring_instruments_id
  INCREMENT 1
  MINVALUE 1
  START 1
  CACHE 1;

CREATE TABLE mcza_test.measuring_instruments (
  id integer NOT NULL DEFAULT nextval('mcza_test.seq_measuring_instruments_id'::regclass),
  instrument_id integer NOT NULL,
  measuring_number integer NOT NULL,
  value integer NOT NULL DEFAULT 0,
  created timestamp DEFAULT now(),
  CONSTRAINT dbo_measuring_instruments_pkey PRIMARY KEY (id),
  CONSTRAINT dbo_measuring_instruments_ident_key UNIQUE (instrument_id, measuring_number)
);

-- instrument 1
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 1, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 2, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 3, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 4, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 5, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 6, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 7, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 8, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 9, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (1, 10, floor(random() * (10 + 1)), now());

-- instrument 2
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 1, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 2, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 3, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 4, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 5, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 6, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 7, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 8, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 9, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (2, 10, floor(random() * (10 + 1)), now());

-- instrument 3
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 1, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 2, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 3, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 4, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 5, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 6, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 7, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 8, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 9, floor(random() * (10 + 1)), now());
INSERT INTO mcza_test.measuring_instruments (instrument_id, measuring_number, value, created) VALUES (3, 10, floor(random() * (10 + 1)), now());


DROP FUNCTION IF EXISTS mcza_test.moving_average();

CREATE OR REPLACE FUNCTION mcza_test.moving_average()
RETURNS TABLE(
    instrument_id integer
    , measuring_number integer
    , avg_last_5 numeric
)
AS $$
    BEGIN
        RETURN QUERY
        SELECT  
            s.instrument_id
            , s.measuring_number
            , s.av
        FROM (
            SELECT 
                mi.instrument_id
                , mi.measuring_number
                , avg(mi.value) OVER (PARTITION BY mi.instrument_id ORDER BY mi.measuring_number) AS av
            FROM mcza_test.measuring_instruments AS mi
            GROUP BY mi.instrument_id, mi.measuring_number, mi.value, mi.created  
            ORDER BY mi.created DESC
        ) AS s
        WHERE s.measuring_number >= 6
        ORDER BY instrument_id, measuring_number ASC    
    ;
    RETURN;
    END;
$$
LANGUAGE plpgsql
SECURITY DEFINER
;

SELECT * FROM mcza_test.moving_average();

-- DROP SCHEMA mcza_test CASCADE;
