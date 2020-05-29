/*
Composition of czech account number into one text string
*/

DROP FUNCTION IF EXISTS helpers.bank_account (text, text, text);

CREATE OR REPLACE FUNCTION helpers.bank_account (
	IN in_bank_prefix text
	, IN in_bank_account text
	, IN in_bank_code_ident text
)
RETURNS text
AS
$bank_account$
DECLARE
		l_prefix text;
		l_bank_account text;
BEGIN
		IF helpers.empty(in_bank_prefix) THEN l_prefix := null;
			  ELSE l_prefix := concat (in_bank_prefix, '-');
		END IF;

		IF helpers.empty(in_bank_account) THEN l_bank_account := null;
				ELSE l_bank_account := concat(l_prefix, in_bank_account, '/', in_bank_code_ident)::text;
		END IF;

RETURN l_bank_account;
END;
$bank_account$
LANGUAGE PLPGSQL
STABLE
SECURITY DEFINER
COST 100
;

-- TEST
SELECT * FROM helpers.bank_account (
	in_bank_prefix := null
	, in_bank_account := '296561456'
	, in_bank_code_ident := '0600'
);
