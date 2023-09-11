-- All storm data
SELECT 
	* 
FROM 
	storms
	;
	
-- 'Katrina' storm data
SELECT 
	  s.name
	, s.date
	, s.time
	, s.status
	, s.category
	, s.wind
	, s.pressure
	, s.tropical_storm_force_diameter
	, s.hurricane_force_diameter
FROM 
	storms s
WHERE
	1=1
	AND s.name = 'Katrina'
	AND EXTRACT(year FROM s.date) = 2005
	;
	

-- Hurricane name and category ordered by date	
SELECT   
	  s.date
	, s.name
	, s.category
FROM 
	storms s
WHERE 
	s.status = 'hurricane'
GROUP BY 
	  s.name
	, s.date
	, s.category
ORDER BY
	  s.date
	;


-- Number of days each hurricane lasted by year
WITH count_of_days AS (
SELECT 
	  s.date
	, s.name
	, EXTRACT(year FROM date) AS year
FROM
	storms s 
WHERE 
	1=1
	AND s.status = 'hurricane'
GROUP BY 
	   s.name
	 , s.date
ORDER BY 
	s.date
		)	
		
SELECT 
	  cod.name
	, COUNT(name) AS number_of_days_lasted
	, cod.year
FROM 
	count_of_days cod
GROUP BY  
	  cod.name
	, cod.year
ORDER BY
	  cod.year
	, cod.name
	;
	
	
-- Does storm intensity increase as the air pressure drops?
SELECT 
	  s.name
	, s.date
	, s.time
	, s.status
	, s.category
	, s.wind
	, MIN(s.pressure) AS pressure
FROM 
	storms s
GROUP BY
	  s.name
	, s.date
	, s.time
	, s.status
	, s.category
	, s.wind
	, s.pressure
ORDER BY 
	pressure -- as the air pressure decreases wind speed and storm intensity increases
	;
	
	
-- Strongest hurricanes from the year 2000 and later ordered by category and wind speed and hour of the day
SELECT 
	 CONCAT(s.name, ' ', '(', EXTRACT(year FROM s.date), ')') AS name_and_year
	, MAX(s.category) AS Category
	, s.wind AS wind_speed_knots
	, CONCAT(EXTRACT(month FROM s.date), '-', EXTRACT(day FROM s.date)) AS days
	, time AS Time_Of_Day
FROM 
	storms s
WHERE 
	1=1
	AND s.status = 'hurricane'
	AND s.date > '2000-01-01'
GROUP BY 
	    s.name
	  , s.category
	  , s.date
	  , s.wind
	  , s.time
ORDER BY 
	   s.category desc
	 , s.wind desc
	 , time_of_day 
	 ;
	
		