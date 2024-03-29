/* Step 1: Get the dataset

Import ** Automible_data.csv** to bigquery

## Step 2: Create table

Create a table called "cars_info"

## Cleaning data

## Step 1: Inspect the fuel_type column

According to the data’s description, the fuel_type column should only have two unique string values: diesel and gas. 
To check and make sure that’s true, I run the following query: */

SELECT
  DISTINCT fuel_type
FROM
  cars.car_info;

/* This confirms that the fuel_type column doesn’t have any unexpected values. 

## Step 2: Inspect the length column 

The length column should contain numeric measurements of the cars.
check the minimum and maximum lengths in the dataset align with the data description, which states that the lengths in this column should range from 141.1 to 208.1 */

SELECT
  MIN(length) AS min_length,
  MAX(length) AS max_length
FROM
  cars.car_info;
  
 /* results confirm that 141.1 and 208.1 are the minimum and maximum values respectively in this column 
  
## Step 3: Fill in missing data  
  
  Missing values can create errors or skew your results during analysis. I am going to check for nulls or missing values.
  check to see if the num_of_doors column contains null values */
  
  SELECT
  *
FROM
  cars.car_info 

WHERE 
 num_of_doors IS NULL;
 
 /* results I got the mazda and dodge num_of_doors with nulls entry
 In order to fill in these missing values, I check with the sales manager, who states that all Dodge gas sedans and all Mazda diesel sedans sold had four doors. */
 
UPDATE
  cars.car_info
SET
  num_of_doors = "four"
WHERE
  make = "dodge", make = "mazda"
  AND fuel_type = "gas"
  AND body_style = "sedan"; 
  
/* check if the changement was correctly applied */

SELECT
  *
FROM
  cars.car_info 

WHERE 
num_of_doors IS NULL;

/* results nulls have been updated to "four" door.

## Step 4: Identify potential errors */

check for other potential errors. Use SELECT DISTINCT to check what values exist in a column. 
check the num_of_cylinders column: 

SELECT
  DISTINCT num_of_cylinders
FROM
  cars.car_info;
  
/* After running this, I noticed that there are one too many rows. There are two entries for two cylinders: rows 6 and 7. But the two in row 7 is misspelled.
To correct the misspelling for all rows, I am going to run this query: */

UPDATE
  cars.car_info
SET
  num_of_cylinders = "two"
WHERE
  num_of_cylinders = "tow";
  
/* checking if it worked */

SELECT
  DISTINCT num_of_cylinders
FROM
  cars.car_info;
  
  /* Next I am going to check the compression_ratio column. According to the data description, the compression_ratio column values should range from 7 to 23. */

SELECT
  MIN(compression_ratio) AS min_compression_ratio,
  MAX(compression_ratio) AS max_compression_ratio
FROM
  cars.car_info

/* this returns a maximum of 70. 
But I know this is an error because the maximum value in this column should be 23, not 70. So the 70 is most likely a 7.0. */

SELECT
  MIN(compression_ratio) AS min_compression_ratio,
  MAX(compression_ratio) AS max_compression_ratio
FROM
  cars.car_info

WHERE
compression_ratio <> 70;

/* Now the highest value is 23, which aligns with the data description. 
I want to correct the 70 value. I check with the sales manager again, who says that this row was made in error and should be removed. 
Before I delete anything, I should check to see how many rows contain this errors value as a precaution so that I don’t end up deleting 50% of the data. */

SELECT
COUNT(*) AS num_of_rows_to_delete

FROM
cars.car_info

WHERE
compression_ratio = 70;

/* Turns out there is only one row with the errors 70 value. */

DELETE cars.car_info

WHERE compression_ratio = 70;

/* Step 5: Ensure consistency

check data for any inconsistencies that might cause errors. These inconsistencies can be tricky to spot — sometimes even something as simple as an extra space can cause a problem. */

 SELECT
  DISTINCT drive_wheels
FROM
  cars.car_info;

/* It appears that 4wd appears twice in results. However, because I used a SELECT DISTINCT statement to return unique values, this probably means there’s an extra space in one of the 4wd entries that makes it different from the other 4wd. */

SELECT
  DISTINCT drive_wheels,
  LENGTH(drive_wheels) AS string_length
FROM
  cars.car_info;
  
/* According to these results, some instances of the 4wd string have four characters instead of the expected three (4wd has 3 characters). In that case, I can use the TRIM function to remove all extra spaces in the drive_wheels column. */

UPDATE
  cars.car_info

SET
  drive_wheels = TRIM(drive_wheels)

WHERE TRUE;

/* Then, I run the SELECT DISTINCT statement again to ensure that there are only three distinct values in the drive_wheels column: */

 SELECT
  DISTINCT drive_wheels
FROM
  cars.car_info;

/* now there only three unique values in this column! Which means data is clean,  consistent, and ready for analysis!

Save new file */

SELECT
*
FROM 
cars.car_info;




