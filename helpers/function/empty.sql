
/*
Returns boolean if the element is null or empty string
*/

DROP FUNCTION IF EXISTS helpers.empty(ANYELEMENT);

CREATE OR REPLACE FUNCTION helpers.empty(
    IN in_v ANYELEMENT
) RETURNS BOOLEAN AS $empty$
DECLARE
    out_v BOOLEAN;
BEGIN
    IF in_v IS NULL OR length(in_v::text) = 0 THEN
        out_v := TRUE;
    ELSIF in_v::text ~ '^([,]{0,})$' THEN
        out_v := TRUE;
    END IF;
    RETURN COALESCE(out_v, FALSE);
END;
$empty$ 
LANGUAGE PLPGSQL;

-- TEST
SELECT * FROM helpers.empty(''::text);
SELECT * FROM helpers.empty(NULL::boolean);
SELECT * FROM helpers.empty('text'::text);
