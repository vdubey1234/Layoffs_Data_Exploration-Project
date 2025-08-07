-- Data Cleaning 

SELECT * FROM 
layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null or Blank Values
-- 4. Remove any columns or rows

-- Duplicating from layoffs to staging_layoffs
-- Do not work with the raw data 

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Finding Duplicate Data

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging			
)
SELECT * FROM duplicate_cte
WHERE row_num >=2;

SELECT * FROM 
layoffs_staging 
WHERE company = 'Casper';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging			
)
DELETE
 FROM duplicate_cte
WHERE row_num >=2;

-- 	Standardizing data:

SELECT company,TRIM(company)
 FROM 
layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT industry 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United%';

SELECT *
FROM layoffs_staging2
ORDER BY 1;

# Alternative to remove dot from the end

SELECT DISTINCT(country), TRIM(TRAILING '.' FROM Country)
FROM layoffs_staging2
ORDER BY 1;

# Coverting the date text format to date format

SELECT date
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

# Changing the text format to date format, dont do this on raw table

-- Checking the NULL Data 

SELECT * FROM
layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- WE are deleting this data as we would not have its use to draw insights about the layoffs further

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * FROM 
layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON t1.company = t2.company 
      AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;      

UPDATE  layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON t1.company = t2.company 
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;  

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *  FROM 
layoffs_staging2
WHERE company = 'Airbnb';

-- Yes the actual table will be modified in this process of updating the table via inner join

DELETE FROM
layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM 
layoffs_staging2;



      





























