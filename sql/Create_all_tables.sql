-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS safeqr;


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Enum for scan_history status
CREATE TYPE scan_status AS ENUM ('active', 'inactive');



-- user table, need "" because user is a reserved word is postgres
CREATE TABLE safeqr."user" (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    source VARCHAR(255),
    date_created TIMESTAMPTZ DEFAULT now(),
    date_updated TIMESTAMPTZ DEFAULT now(),
    roles TEXT[],
    status VARCHAR(255) DEFAULT 'ACTIVE'
);


-- Create QR_Code_Types table
CREATE TABLE safeqr.qr_code_types (
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description VARCHAR(100),
    prefix VARCHAR(50),
    table_name VARCHAR(100)
);

-- Create QR_Code table
-- Allow for nullable user id for testing KIV
CREATE TABLE safeqr.qr_code (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_type_id INT REFERENCES safeqr.qr_code_types(id),
    user_id VARCHAR(255) REFERENCES safeqr."user"(id) NULL,
    contents VARCHAR(4096),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Scan_History table
CREATE TABLE safeqr.scan_history (
    id SERIAL PRIMARY KEY,
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    user_id VARCHAR(255) REFERENCES safeqr."user"(id),
    status scan_status DEFAULT 'active'
);

-- Create Scan_Bookmark table
CREATE TABLE safeqr.scan_bookmark (
    id SERIAL PRIMARY KEY,
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    user_id VARCHAR(255) REFERENCES safeqr."user"(id),
    active VARCHAR(7) CHECK (active IN ('ACTIVE', 'DELETED'))
);

-- Create URL table
CREATE TABLE safeqr.url (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    url VARCHAR(2048),
    query VARCHAR(2048),
    fragment VARCHAR(2048)
);

-- Create Text table
CREATE TABLE safeqr.text (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    text VARCHAR(2048)
);

-- Create Phone table
CREATE TABLE safeqr.phone (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    phone VARCHAR(100)
);

-- Create SMS table
CREATE TABLE safeqr.sms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES safeqr.qr_code(id),
    phone VARCHAR(100),
    message VARCHAR(160)
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