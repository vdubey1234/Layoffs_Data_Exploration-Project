-- Exploratory Data Analytics

SELECT * FROM 
layoffs_staging2;

SELECT MAX(total_laid_off),MIN(total_laid_off)
FROM layoffs_staging2;

SELECT company, SUM(total_laid_off)
FROM
layoffs_staging2
GROUP BY company
ORDER BY  SUM(total_laid_off) DESC;

-- Same goes for industry,date,stage,country

SELECT `date`, SUM(total_laid_off)
FROM
layoffs_staging2
GROUP BY `date`
ORDER BY  SUM(total_laid_off) DESC;

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM
layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC;

WITH Rolling_Total  AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS Total
FROM
layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)
SELECT `Month`,Total,SUM(Total) OVER( ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

WITH Company_Year(Company,Year,Total_laid_Off) AS 
(
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC
) ,
Company_Year_Rank AS
(
SELECT *,DENSE_RANK() OVER (PARTITION BY Year ORDER BY Total_laid_Off DESC) AS rank_total
FROM 
Company_Year
WHERE Year IS NOT NULL
ORDER BY rank_total
)
SELECT * FROM
Company_Year_Rank
WHERE rank_total <= 5;

# Company_Year_Rank is a CTE (Common Table Expression)
# It's not a subquery — it's the second CTE in your WITH clause chain. 








