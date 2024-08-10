
INSERT INTO safeqr."user" (
    id, 
    cognitoid, 
    firstname, 
    lastname, 
    email, 
    source, 
    password, 
    salt, 
    cognito_id, 
    first_name, 
    last_name
) VALUES (
    'test-unique-id', 
    'test-cognito-id', 
    'Test', 
    'User', 
    'test.user@example.com', 
    'test-source', 
    'test-password-hash', 
    'test-salt', 
    NULL, 
    NULL, 
    NULL
);


-- Insert into QR_Code_Types table
-- Insert additional QR code types into the qr_code_types table
INSERT INTO safeqr.qr_code_types (type, description, prefix, table_name) VALUES 
('URL', 'Uniform Resource Locator', 'http://', 'url'),
('URL', 'Uniform Resource Locator', 'https://', 'url'),
('EMAIL', 'Email Address', 'mailto:', 'email'),
('PHONE', 'Phone Number', 'tel:', 'phone'),
('SMS', 'Short Message Service', 'smsto:', 'sms'),
('GEOLOCATION', 'Geographic Location', 'geo:', 'geolocation'),
('WIFI', 'Wireless Network Configuration', 'WIFI:', 'wifi'),
('BITCOIN', 'Cryptocurrency Address', 'bitcoin:', 'bitcoin'),
('VCARD', 'Virtual Contact File', 'BEGIN:VCARD', 'vcard'),
('TEXT', 'Text', '', 'text');


-- Insert into QR_Code table
INSERT INTO safeqr.qr_code (id, qr_code_type_id, user_id, contents, created_at) VALUES
(gen_random_uuid(), 1, 'test-unique-id', 'http://example.com', CURRENT_TIMESTAMP),
(gen_random_uuid(), 2, NULL, 'https://example.com', CURRENT_TIMESTAMP),
(gen_random_uuid(), 3, 'test-unique-id', 'mailto:test@example.com', CURRENT_TIMESTAMP);

-- Insert into Scan_History table
INSERT INTO safeqr.scan_history (qr_code_id, user_id) VALUES
((SELECT id FROM safeqr.qr_code LIMIT 1), 'test-unique-id'),
((SELECT id FROM safeqr.qr_code LIMIT 1 OFFSET 1), 'test-unique-id'),
((SELECT id FROM safeqr.qr_code LIMIT 1 OFFSET 2), 'test-unique-id');

-- Insert into Scan_Bookmark table
INSERT INTO safeqr.scan_bookmark (qr_code_id, user_id, active) VALUES
((SELECT id FROM safeqr.qr_code LIMIT 1), 'test-unique-id', 'ACTIVE'),
((SELECT id FROM safeqr.qr_code LIMIT 1 OFFSET 1), 'test-unique-id', 'ACTIVE'),
((SELECT id FROM safeqr.qr_code LIMIT 1 OFFSET 2), 'test-unique-id', 'DELETED');

-- Insert into URL table
INSERT INTO safeqr.url (id, qr_code_id, url, query, fragment) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code WHERE contents LIKE 'http://%' LIMIT 1), 'http://example.com', 'key=value', 'fragment'),
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code WHERE contents LIKE 'https://%' LIMIT 1), 'https://example.com', 'key=value', 'fragment');

-- Insert into Text table
INSERT INTO safeqr.text (id, qr_code_id, text) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code WHERE contents = 'Some text' LIMIT 1), 'Some example text');

-- Insert into Phone table
INSERT INTO safeqr.phone (id, qr_code_id, phone) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), '+1234567890');

-- Insert into SMS table
INSERT INTO safeqr.sms (id, qr_code_id, phone, message) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), '+1234567890', 'This is a test SMS message.');

-- Insert into Email table
INSERT INTO safeqr.email (id, qr_code_id, email, title, message) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code WHERE contents LIKE 'mailto:%' LIMIT 1), 'test@example.com', 'Test Email', 'This is a test email body.');

-- Insert into GeoLocation table
INSERT INTO safeqr.geolocation (id, qr_code_id, latitude, longitude) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), 37.7749, -122.4194);

-- Insert into Wifi table
INSERT INTO safeqr.wifi (id, qr_code_id, ssid, password, encryption, hidden) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), 'TestSSID', 'password123', 'WPA2', FALSE);

-- Insert into Bitcoin table
INSERT INTO safeqr.bitcoin (id, qr_code_id, address, amount, message) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', 5000000000, 'Test Bitcoin transaction');

-- Insert into VCard table
INSERT INTO safeqr.vcard (id, qr_code_id, version, name, organisation, title, address, tel_work, tel_cell, email, url) VALUES
(gen_random_uuid(), (SELECT id FROM safeqr.qr_code LIMIT 1), '4.0', 'John Doe', 'Example Corp', 'Developer', '1234 Elm St, Springfield, IL', '+1234567890', '+0987654321', 'johndoe@example.com', 'http://example.com');