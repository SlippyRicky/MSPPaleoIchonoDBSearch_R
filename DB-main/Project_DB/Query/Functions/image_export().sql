DROP FUNCTION IF EXISTS export_images(integer[], text);

CREATE OR REPLACE FUNCTION export_images(picture_numbers INT[], output_directory TEXT)
RETURNS VOID AS $$
DECLARE
    image_data OID;
    file_path TEXT;
    picture_num INTEGER;
    v_serial_id INTEGER; -- Renamed the variable to avoid ambiguity
BEGIN
    -- Loop through the provided picture numbers
    FOREACH picture_num IN ARRAY picture_numbers
    LOOP
        -- Retrieve serial ID from the relationship table based on picture_number
        SELECT image_id
        INTO v_serial_id
        FROM retable
        WHERE picture_num = picture_number;

        -- Retrieve image data from the database based on the v_serial_id
        SELECT image_cfile_oid
        INTO image_data
        FROM data_content
        WHERE serial_id = v_serial_id;

        -- Generate file path based on output_directory and picture_number
        file_path := output_directory || '/' || 'image_' || picture_num || '.jpg';

        -- Write image data to the specified file path
        PERFORM lo_export(image_data, file_path);

        RAISE NOTICE 'Image exported: %', file_path;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
