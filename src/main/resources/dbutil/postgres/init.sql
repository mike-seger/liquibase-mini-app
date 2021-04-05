-- Fix connection issues with custom databases
--alter system set password_encryption = 'scram-sha-256';

--create table public.hba ( lines text );
--copy public.hba from '/home/pg_hba.conf';
--copy public.hba to '/var/lib/postgresql/data/pg_hba.conf';
--drop table public.hba;
--select pg_reload_conf();

-- Initialization
DROP SCHEMA IF EXISTS user01 CASCADE;
CREATE DATABASE user01_db;
CREATE USER user01 WITH PASSWORD 'secret';
GRANT ALL PRIVILEGES ON DATABASE user01_db TO user01;
GRANT CONNECT ON DATABASE user01_db TO user01;
\connect user01_db user01;
CREATE SCHEMA user01;
GRANT ALL PRIVILEGES ON SCHEMA user01 TO user01;

