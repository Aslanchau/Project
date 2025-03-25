-- Data Cleaning
SELECT *
FROM layoffs;

-- 1. Remove Duplicate
-- 2. Standardize the Data
-- 3. Null values or Blank values
-- 4. Removes any Columns

CREATE TABLE layoffs_staging -- Mình sẽ thực hành trên data mới, không đụng vào raw data, như khi làm công ty cũng vậy.
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Remove Duplicate
-- Check duplicate
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Oyster';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)

DELETE
FROM duplicate_cte
WHERE row_num > 1;

--  Tạo một bảng mới để chỉnh sửa không ảnh hưởng lên bảng gốc
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0; -- Cần tắt safe update để có thể sử dụng DELETE
SET SQL_SAFE_UPDATES = 1; -- Bật lại safe update để tránh delete hoặc update nhẫm lẫn

DELETE -- Delete duplicate
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company); -- Xoá các khoảng trắng đầu và cuối

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Giả sử dữ liêu có biến là "Crypto" và "CryptoCurrency"
-- Ta xử lý như sau:
-- B1: Check dữ liệu :  		SELECT *
-- 								FROM layoffs-staging2
-- 								WHERE industry LIKE 'Crypto%';
-- ----------------------------------------------------------
-- B2: Cập nhật lại dữ liệu: 	UPDATE layoffs_staging2
-- 								SET industry = 'Crypto'
-- 								WHERE industry LIKE 'Crypto%'


SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Giả sử dữ liệu có biến có dấu "." cuối
-- B1:  SELECT DISTINCT coutry, TRIM(TRAILING '.', FROM country)
-- 		FROM layoffs_staging2
-- 		ORDER BY 1;
-- ----------------------------------------------------------
-- B2:  UPDATE layoffs_staging2
-- 		SET country = TRIM(TRAILING '.', FROM country
-- 		WHERE country LIKE 'United States%'

SELECt *
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Null values or Blank values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT st1.industry, st2.industry
FROM layoffs_staging2 st1
JOIN layoffs_staging2 st2
	ON st1.company = st2.company
    AND st1.location = st2.location
WHERE (st1.industry IS NULL OR st1.industry = '')
AND st2.industry IS NOT NULL;

UPDATE layoffs_staging2 st1
JOIN layoffs_staging2 st2
	ON st1.company = st2.company
SET st1.industry = st2.industry
WHERE (st1.industry IS NULL OR st1.industry = '')
AND st2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off	IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off	IS NULL;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Remove any columns

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;






















