-- Move synced fields to the facebook table
alter table account drop column first_name;
alter table account drop column last_name;
alter table account drop column date_of_birth;
alter table account drop column gender;

alter table facebook_account
  add column first_name character varying(50),
  add column last_name character varying(50),
  add column date_of_birth date,
  add column gender character(1);

-- For new Facebook users, facebook_id can be bigger than max_integer in
-- Postgres
alter table facebook_account
alter column facebook_id type bigint;

alter table account drop column country_id;
alter table account add column country_code character(2);

create index account_email_by_verify_code on account_email using btree (verify_code);
alter table account add column auth_code character varying(36);
create index account_by_auth_code on account using btree (auth_code);

-- #326 start
ALTER TABLE account ADD COLUMN created_ip character varying(15);
CREATE INDEX account_by_created_ip ON account USING btree (created_ip);
-- #326 end
