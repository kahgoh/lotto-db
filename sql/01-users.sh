#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER lotto WITH ENCRYPTED PASSWORD '$(< /run/secrets/${LOTTO_USER_PWD_SECRET} )';
	GRANT ALL PRIVILEGES ON DATABASE lotto TO lotto;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO lotto;
    GRANT USAGE ON SCHEMA public TO lotto;
EOSQL