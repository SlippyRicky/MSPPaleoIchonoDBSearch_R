CREATE OR REPLACE FUNCTION get_image_ids(tags varchar[])
RETURNS INTEGER[]
LANGUAGE plpgsql
AS $$
DECLARE
    result_ids INTEGER[];
    image_id INTEGER;
BEGIN
    -- Initialize the result array
    result_ids := '{}';
	
    -- Iterate over each image
    FOR image_id IN SELECT DISTINCT your_image_id FROM ImageTable LOOP
        -- Check if the image has all the specified tags
        IF (SELECT COUNT(*) = array_length(tags, 1)
            FROM unnest(tags) AS tag
            WHERE tag IN (SELECT tag_column FROM ImageTable WHERE your_image_id = image_id))
        THEN
            -- Add the image ID to the result array
            result_ids := result_ids || image_id;
        END IF;
    END LOOP;

    -- Return the result array
    RETURN result_ids;
END;
$$;

