_____/* PROFIT ANALYSIS */_____

/* Que.1. Within the space of the last three years, what was the profit worth of 
the breweries, inclusive of the anglophone and the francophone territories */
SELECT
	CASE
		WHEN countries IN ('Nigeria', 'Benin', 'Senegal', 'Ghana', 'Togo') 
		THEN 'Territories'
		ELSE 'Nothing'
		END AS "Territories",
	SUM(profit) "Profit_Worth"
FROM 
	international_breweries.pabod
GROUP BY 1

---Alternatively
SELECT 
	SUM(profit) AS "Profit_Worth"
FROM 
	international_breweries.pabod

/* Que.2. Compare the total profit between these two territories in order for the 
territory manager, Mr. Stone made a strategic decision that will aid profit 
maximization in 2020 */
SELECT 
	CASE
		WHEN countries IN ('Nigeria', 'Ghana') THEN 'Anglophone'
		ELSE 'Francophone'
		END AS "Territories",
	SUM(profit) "Total_Profit"
FROM 
	international_breweries.pabod
GROUP BY 1

/* Que.3. Country that generated the highest profit in 2019? */
SELECT 
	countries "Country",
	SUM(profit) "Highest_Profit"
FROM 
	international_breweries.pabod
WHERE 
	years = '2019'
GROUP BY 
	"Country"
ORDER BY
	"Highest_Profit" DESC
LIMIT 1

/* Que.4. Help him find the year with the highest profit? */
SELECT 
	years "Year",
	SUM(profit) "Highest_Profit"
FROM 
	international_breweries.pabod
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.5. Which month in the three years was the least profit generated? */
SELECT 
	months, 
	years, 
	SUM(profit) "Least_Profitable"
FROM 
	international_breweries.pabod
GROUP BY 1, 2
ORDER BY 3
LIMIT 1

/* Que.6. What was the minimum profit in the month of December 2018? */
SELECT 
	months, 
	MIN(profit) "Min_Profit"
FROM 
	international_breweries.pabod
WHERE 
	years = '2018' AND months = 'December'
GROUP BY 1

/* Que.7. Compare the profit in percentage for each of the month in 2019? */
CREATE VIEW Monthly_Profit_2019 AS
SELECT 
	months, 
	SUM(profit)
FROM 
	international_breweries.pabod
WHERE 
	years = '2019'
GROUP BY
	months

With Total_Profit_IN_2019 AS(
	SELECT 
		SUM(Monthly_Profit_2019.SUM) as Total_Profit_IN_2019
	FROM 
		Monthly_Profit_2019)	
SELECT 
	Profits_by_months_2019.Months,
	CONCAT(ROUND(((Profits_by_months_2019.SUM * 100)/Total_Profit_IN_2019), 2), '%') AS "Profit_%"
FROM 
	Profits_by_Months_2019, Total_Profit_IN_2019
	
---Alternatively
SELECT 
	months, 
	SUM(profit) AS "Profit",
	ROUND(SUM(CAST(profit AS decimal))/ 
		  (SELECT 
		   		SUM(CAST(profit AS decimal))
			FROM 
		   		international_breweries.pabod WHERE years = '2019') * 100, 2) AS "Percentage"
FROM 
	international_breweries.pabod
WHERE 
	years = '2019'
GROUP BY 1

/* Que.8. Which particular brand generated the highest profit in Senegal? */
SELECT 
	brands, 
	SUM(profit)"Highest_Profit"
FROM 
	international_breweries.pabod
WHERE 
	countries = 'Senegal'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

_____/* BRAND ANALYSIS */_____

/* Que.1. Within the last two years, the brand manager wants to know the top three brands
consumed in the francophone countries. */
SELECT 
	brands, 
	SUM(quantity) "Top_Consumed_Brands"
FROM 
	international_breweries.pabod
WHERE 
	years IN ('2019', '2018') 
	AND countries IN ('Benin', 'Senegal', 'Togo')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3

/* Que.2. Find out the top two choice of consumer brands in Ghana? */
SELECT 
	brands "Consumer_Brands", 
	SUM(quantity) "Quantity"
FROM 
	international_breweries.pabod
WHERE 
	countries = 'Ghana'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2

/* Que.3. Find out the details of beers consumed in the past three years in the most oil reached
country in West Africa? */
SELECT 
	brands, 
	SUM(quantity) AS total_quantity,
	SUM(cost) AS total_cost,
	SUM(profit) AS total_profit
FROM 
	international_breweries.pabod
WHERE 
	brands NOT LIKE '%malt' 
	AND countries = 'Nigeria'
GROUP BY 1
ORDER BY 2 DESC

/* Que.4. Favorites malt brand in Anglophone region between 2018 and 2019? */
SELECT 
	brands "Favorite_Brand", 
	SUM(quantity) "Quantity"
FROM 
	international_breweries.pabod
WHERE 
	years IN ('2018', '2019') 
	AND brands ILIKE '%malt' AND countries IN ('Nigeria', 'Ghana')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.5. Which brands sold the highest in 2019 in Nigeria? */
SELECT 
	brands "Top_Brand", 
	SUM(quantity) "Quantity"
FROM 
	international_breweries.pabod
WHERE 
	years = '2019' AND countries = 'Nigeria'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.6. Favorites brand in South_South region in Nigeria? */
SELECT 
	brands "Favorite_Brand", 
	SUM(quantity) "Quantity"
FROM 
	international_breweries.pabod
WHERE 
	countries = 'Nigeria' 
	AND region = 'southsouth'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.7. Bear consumption in Nigeria? */
SELECT 
	countries, 
	SUM(quantity) "Total_Quantity"
FROM 
	international_breweries.pabod
WHERE 
	countries = 'Nigeria' 
	AND brands NOT ILIKE '%malt'
GROUP BY 1;
---OR
SELECT 
	brands, 
	SUM(quantity) "Total_Quantity"
FROM 
	international_breweries.pabod
WHERE 
	countries = 'Nigeria' 
	AND brands NOT ILIKE '%malt'
GROUP BY 1

/* Que.8. Level of consumption of Budweiser in the regions in Nigeria? */
SELECT 
	brands, 
	region, 
	SUM(quantity) "Consumption"
FROM 
	international_breweries.pabod
WHERE 
	brands ILIKE 'budweiser' 
	AND countries = 'Nigeria'
GROUP BY 1, 2

/* Que.9. Level of consumption of Budweiser in the regions in Nigeria in 2019? */
SELECT 
	brands, 
	SUM(quantity) "Consumption",
	region 
FROM 
	international_breweries.pabod
WHERE 
	brands ILIKE 'budweiser' 
	AND countries = 'Nigeria' 
	AND years = '2019'
GROUP BY 1, 3

____/* COUNTRIES ANALYSIS */____

/* Que.1. Country with the highest consumption of beer? */
SELECT 
	countries, 
	SUM(quantity) "Highest_Consumption"
FROM 
	international_breweries.pabod
WHERE 
	brands NOT ILIKE '%malt'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.2. Highest sales personnel of Budweiser in Senegal? */
SELECT 
	sales_rep, 
	SUM(quantity) "Quantity"
FROM 
	international_breweries.pabod
WHERE 
	brands ilike 'budweiser' 
	AND countries = 'Senegal'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Que.3. Country with the highest profit of the fourth quarter in 2019? */
SELECT 
	countries, 
	SUM(profit) "Highest_Profit"
FROM 
	international_breweries.pabod
WHERE 
	months IN ('October', 'November', 'December') 
	AND years = '2019'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
