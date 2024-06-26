FROM docker.io/library/postgres:16.3-bookworm

ENV POSTGRES_DB=lotto
COPY sql/00-lotto-db.sql sql/01-users.sh /docker-entrypoint-initdb.d/
