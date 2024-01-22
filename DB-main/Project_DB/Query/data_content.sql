-- Creating table for the serial primary key (this is relational to the picture_number in retable) and the image oid is stored in this table
create table data_content (
	image_id serial primary key,
	image_cfile_oid OID
);

-- IMPORTANT dont forget to change the file path in data_reference to a permissable directory in your computer otherwise psotgresql and other SQL programs wont have permission to access
DO $$ 
DECLARE
    row_data RECORD;									-- declaring row_data for the FOR loop
BEGIN
    FOR row_data IN (SELECT link_path FROM data_reference) LOOP
        DECLARE
            image_oid OID;								-- Large object decleration (this will store the image data)
        BEGIN
            -- Import the image into the Large Object
            image_oid := lo_import(row_data.link_path);

            -- Insert the Large Object OID into the new table
            INSERT INTO data_content (image_cfile_oid) VALUES (image_oid);

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error processing file: %', row_data.link_path;	-- For an error raise notice will cause an error but will allow the query to run through all the data											
        END;
    END LOOP;
END $$;