-- Table for DB this is written in SQL--

-- For each table there will be a primary key that make it easier for creating specific queries (correspond to: picture_number, link_path)
-- This table describes all the tags for all the images, it includes the uncertainty for each tag
create table data_tags (
	logic_tag INTEGER primary key,
	specimen VARCHAR(255),
	uncertainty1 BOOLEAN, 				-- Bool type for TRUE or FALSE: uncertainty1 --> specimen, uncertainty2 --> bone
	bone VARCHAR(255),
	uncertainty2 BOOLEAN,
	sex VARCHAR(255),
	uncertainty3 BOOLEAN,
	age VARCHAR(255),
	uncertainty4 BOOLEAN,
	side_of_body VARCHAR(255),
	uncertainty5 BOOLEAN,
	plane_of_picture VARCHAR(255),
	uncertainty6 BOOLEAN,
	orientation VARCHAR(255),
	uncertainty7 BOOLEAN,
	picture_number int
);

-- This table is build specifically for the storing of the file path of the image in the server drive
create table data_reference (
	logic_tag INTEGER primary key,
	specimen VARCHAR(255),
	picture_number INTEGER,				-- Corresponding image number
	link_path VARCHAR(255)				-- File path
);

-- There is an additional table that data_content.sql. The reason it has to be separately declared is because of the datatype OID.