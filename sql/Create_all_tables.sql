-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS safeqr;


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Enum for scan_history status
CREATE TYPE scan_status AS ENUM ('ACTIVE', 'INACTIVE');

-- safeqr."user" definition

-- Drop table

-- DROP TABLE safeqr."user";

CREATE TABLE safeqr."user" (
	id varchar(255) NOT NULL,
	"name" varchar(255) NULL,
	email varchar(255) NULL,
	"source" varchar(255) NULL,
	date_created timestamptz DEFAULT now() NULL,
	date_updated timestamptz DEFAULT now() NULL,
	roles _text NULL,
	status varchar(255) DEFAULT 'ACTIVE'::character varying NULL,
	gm

-- safeqr.qr_code_types definition

-- Drop table

-- DROP TABLE safeqr.qr_code_types;

CREATE TABLE safeqr.qr_code_types (
	id bigserial NOT NULL,
	"type" varchar(255) NOT NULL,
	description varchar(255) NULL,
	prefix varchar(255) NULL,
	table_name varchar(255) NULL,
	CONSTRAINT qr_code_types_pkey PRIMARY KEY (id)
);

-- safeqr.qr_code definition

-- Drop table

-- DROP TABLE safeqr.qr_code;

CREATE TABLE safeqr.qr_code (
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	qr_code_type_id int8 NULL,
	user_id varchar(255) NULL,
	contents text NULL,
	created_at timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT qr_code_pkey PRIMARY KEY (id),
	CONSTRAINT qr_code_qr_code_type_id_fkey FOREIGN KEY (qr_code_type_id) REFERENCES safeqr.qr_code_types(id),
	CONSTRAINT qr_code_user_id_fkey FOREIGN KEY (user_id) REFERENCES safeqr."user"(id)
);

-- safeqr.scan_history definition

-- Drop table

-- DROP TABLE safeqr.scan_history;

CREATE TABLE safeqr.scan_history (
	id bigserial NOT NULL,
	qr_code_id uuid NULL,
	user_id varchar(255) NULL,
	status varchar(255) DEFAULT 'ACTIVE'::safeqr.scan_status NULL,
	date_created timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
	date_updated timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
	bookmarked bool DEFAULT false NULL,
	CONSTRAINT scan_history_pkey PRIMARY KEY (id),
	CONSTRAINT scan_history_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.scan_bookmark definition

-- Drop table

-- DROP TABLE safeqr.scan_bookmark;

CREATE TABLE safeqr.scan_bookmark (
	id bigserial NOT NULL,
	qr_code_id uuid NULL,
	user_id varchar(255) NULL,
	status varchar(255) DEFAULT 'ACTIVE'::safeqr.bookmark_status NULL,
	date_created timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
	date_updated timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT scan_bookmark_pkey PRIMARY KEY (id),
	CONSTRAINT scan_bookmark_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.url definition

-- Drop table

-- DROP TABLE safeqr.url;

CREATE TABLE safeqr.url (
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	qr_code_id uuid NULL,
	"domain" text NULL,
	subdomain text NULL,
	top_level_domain text NULL,
	query text NULL,
	fragment text NULL,
	redirect int4 DEFAULT 0 NULL,
	"path" text NULL,
	redirect_chain _text NULL,
	hsts_header _text NULL,
	ssl_stripping _bool NULL,
	CONSTRAINT url_pkey PRIMARY KEY (id),
	CONSTRAINT url_qr_code_id_fkey FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id)
);

-- safeqr."text" definition

-- Drop table

-- DROP TABLE safeqr."text";

CREATE TABLE safeqr."text" (
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	qr_code_id uuid NULL,
	"text" varchar(2048) NULL,
	CONSTRAINT text_pkey PRIMARY KEY (id),
	CONSTRAINT text_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.phone definition

-- Drop table

-- DROP TABLE safeqr.phone;

CREATE TABLE safeqr.phone (
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	qr_code_id uuid NULL,
	phone text NULL,
	CONSTRAINT phone_pkey PRIMARY KEY (id),
	CONSTRAINT phone_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.sms definition

-- Drop table

-- DROP TABLE safeqr.sms;

CREATE TABLE safeqr.sms (
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	qr_code_id uuid NULL,
	phone text NULL,
	message text NULL,
	CONSTRAINT sms_pkey PRIMARY KEY (id),
	CONSTRAINT sms_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id)
);

-- Create Email table
CREATE TABLE safeqr.email (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    email VARCHAR(200),
    title VARCHAR(200),
    message VARCHAR(7089)
);

-- Create GeoLocation table
CREATE TABLE safeqr.geolocation (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

-- Create Wifi table
CREATE TABLE safeqr.wifi (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    ssid VARCHAR(200),
    password VARCHAR(200),
    encryption VARCHAR(200),
    hidden BOOLEAN
);

-- Create Bitcoin table
CREATE TABLE safeqr.bitcoin (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    address VARCHAR(200),
    amount BIGINT,
    message VARCHAR(250)
);

-- Create VCard table
CREATE TABLE safeqr.vcard (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    version VARCHAR(50),
    name VARCHAR(250),
    organisation VARCHAR(250),
    title VARCHAR(50),
    address VARCHAR(250),
    tel_work VARCHAR(250),
    tel_cell VARCHAR(250),
    email VARCHAR(250),
    url VARCHAR(2048)
);

-- safeqr.gmail_emails definition

-- Drop table

-- DROP TABLE safeqr.gmail_emails;

CREATE TABLE safeqr.gmail_emails (
	user_id varchar NOT NULL,
	subject text NULL,
	email_date timestamptz NULL,
	date_created timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	message_id varchar NOT NULL,
	history_id int8 NULL,
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	CONSTRAINT gmail_pk PRIMARY KEY (id),
	CONSTRAINT gmail_unique UNIQUE (user_id, message_id),
	CONSTRAINT gmail_user_fk FOREIGN KEY (user_id) REFERENCES safeqr."user"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.gmail_urls definition

-- Drop table

-- DROP TABLE safeqr.gmail_urls;

CREATE TABLE safeqr.gmail_urls (
	gmail_id uuid NOT NULL,
	image_url text NOT NULL,
	decoded_content varchar NULL,
	qr_code_id uuid NOT NULL,
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	CONSTRAINT gmail_urls_pk PRIMARY KEY (id),
	CONSTRAINT gmail_urls_unique UNIQUE (gmail_id, image_url, decoded_content),
	CONSTRAINT gmail_urls_gmail_emails_fk FOREIGN KEY (gmail_id) REFERENCES safeqr.gmail_emails(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT gmail_urls_qr_code_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- safeqr.gmail_cid definition

-- Drop table

-- DROP TABLE safeqr.gmail_cid;

CREATE TABLE safeqr.gmail_cid (
	gmail_id uuid NOT NULL,
	cid varchar NOT NULL,
	attachment_id text NOT NULL,
	decoded_content text NOT NULL,
	qr_code_id uuid NOT NULL,
	id uuid DEFAULT safeqr.uuid_generate_v4() NOT NULL,
	CONSTRAINT gmail_cid_pk PRIMARY KEY (id),
	CONSTRAINT gmail_cid_unique UNIQUE (gmail_id, cid, decoded_content),
	CONSTRAINT gmail_cid_gmail_emails_fk FOREIGN KEY (gmail_id) REFERENCES safeqr.gmail_emails(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT gmail_cid_qr_code_fk FOREIGN KEY (qr_code_id) REFERENCES safeqr.qr_code(id) ON DELETE CASCADE ON UPDATE CASCADE
);