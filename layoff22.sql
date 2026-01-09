-- Data Cleaning

select * 
From layoffs;

-- CREATING A REPLICA TABLE WHERE WE WILL DO OUR DATA CLEANING 

CREATE TABLE layoff2
like layoffs;

SELECT *
FROM layoff2;

-- INSERTING DATA INTO THE TABLE
INSERT into layoff2
SELECT * 
FROM layoffs;

-- REMOVING DUPLICATE
WITH CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoff2)
SELECT *
FROM  CTE
WHERE row_num>1;
-- WE CANNOT DELETE ROW_NUMBER THAT ARE > 2, THEREFORE WE HAVE TO CREATE A TABLE WITH ROW NUMBER

CREATE TABLE `layoff22` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT*
FROM layoff22;

-- INSERTING DATA INTO THE NEW TABLE WITH COLUMN NAME row_number
INSERT INTO layoff22
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoff2;

-- THESE ARE THE DUPLICATES
SELECT*
FROM layoff22
WHERE `row_number`>1;

-- DUPLICATE REMOVED
DELETE
FROM layoff22
WHERE `row_number`>1;

-- STANDARDIZING DATA: STANDATDIZING THE COMPANY COLUMN
SELECT DISTINCT (TRIM(company))
FROM layoff22;

UPDATE layoff22
SET company=TRIM(company);

SELECT DISTINCT (company)
FROM layoff22;

-- -- STANDATDIZING THE INDUSTRY COLUMN
SELECT DISTINCT (industry)
FROM layoff22
ORDER BY 1;

SELECT * 
FROM layoff22
WHERE industry LIKE 'Crypto%';

UPDATE layoff22
SET industry= 'Crypto'
WHERE industry LIKE 'Crypto%';

-- -- STANDATDIZING THE COUNTRY COLUMN
SELECT DISTINCT country, trim(trailing'.' from country)
FROM layoff22
WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoff22
SET country=trim(trailing'.' from country)
WHERE country LIKE 'United States%';


SELECT *
FROM layoff22;

-- STANDATDIZING THE DATE COLUMN
SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoff22;

UPDATE layoff22
SET `date`=str_to_date(`date`,'%m/%d/%Y');

SELECT *
FROM layoff22;

ALTER TABLE layoff22
MODIFY COLUMN `date` date;

-- HANDLING NULL VALUES FOR INDUSTRY
SELECT *
FROM layoff22
WHERE industry IS NULL
OR industry= '';

SELECT *
FROM layoff22
WHERE company = 'Airbnb';

-- JOINING THE TABLE TO ITSELF
SELECT t1.industry,t2.industry
FROM layoff22 T1
	JOIN layoff22 T2 
	ON T1.company=T2.company
WHERE (T1.industry is null or t1.industry='')
AND  T2.industry IS NOT NULL;


UPDATE layoff22
SET industry=null
where industry='';

UPDATE layoff22 T1
JOIN layoff22 T2 
	ON T1.company=T2.company
    SET T1.industry= T2.industry
WHERE T1.industry IS null
AND  T2.industry IS not NULL;

-- HANDLING NULL VALUES ON TOTAL_LAID_OFF AND PERCENTAGE_LAID_OFF COLUMNS

SELECT *
FROM layoff22
WHERE total_laid_off is null
AND percentage_laid_off is null;

-- DELETING THE ROWS
DELETE 
FROM layoff22
WHERE total_laid_off is null
AND percentage_laid_off is null;

SELECT *
FROM layoff22;

ALTER TABLE layoff22
DROP COLUMN `row_number`;

-- REMOVING COMPANIES WHERE TOTAL LAID OFF IS NULL
DELETE
FROM layoff22
WHERE total_laid_off is null;


 
