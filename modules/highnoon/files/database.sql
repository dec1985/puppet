CREATE TABLE account (
    id serial NOT NULL,
    display_name character varying(50) NOT NULL,
    password character varying(70),
    date_of_birth date,
    gender character(1),
    country_id integer,
    first_name character varying(50),
    last_name character varying(50),
    open boolean NOT NULL DEFAULT true,
    language character varying(10) NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE ONLY account
    ADD CONSTRAINT account_display_name_unique UNIQUE (display_name);
ALTER TABLE ONLY account
    ADD CONSTRAINT account_pk PRIMARY KEY (id);

CREATE TABLE account_email (
    account_id integer NOT NULL,
    email character varying(250) NOT NULL,
    verified boolean NOT NULL,
    verify_code character varying(36),
    created timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE ONLY account_email
    ADD CONSTRAINT account_email_pk PRIMARY KEY (email);

CREATE INDEX fki_account_email_to_account_fk ON account_email USING btree (account_id);
ALTER TABLE ONLY account_email
    ADD CONSTRAINT account_email_to_account_fk FOREIGN KEY (account_id) REFERENCES account(id) ON DELETE CASCADE;


CREATE TABLE facebook_account (
    facebook_id integer NOT NULL,
    account_id integer NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE ONLY facebook_account
    ADD CONSTRAINT pk_facebook_account PRIMARY KEY (facebook_id);

CREATE INDEX fki_facebook_account_to_account ON facebook_account USING btree (account_id);

ALTER TABLE ONLY facebook_account
    ADD CONSTRAINT fk_facebook_account_to_account FOREIGN KEY (account_id) REFERENCES account(id) ON DELETE CASCADE;
