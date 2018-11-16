/*
1 How many campaigns and sources does CoolTShirts use and how are they related?
*/

SELECT COUNT(DISTINCT utm_campaign) AS total_campaigns
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS total_sources
FROM page_visits;

SELECT DISTINCT utm_campaign AS campaign, 
	utm_source AS source
FROM page_visits;

/*
2 What pages are on their website?
*/

SELECT DISTINCT page_name
FROM page_visits;

/*
3 How many first touches is each campaign responsible for?
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS campaign,
    COUNT(ft.first_touch_at) AS total_first_touches
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;
    
 /*
4 How many last touches is each campaign responsible for?
*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS campaign,
    COUNT(lt.last_touch_at) AS total_last_touches
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;   
  
 /*
5 How many visitors make a purchase?
*/

SELECT COUNT(DISTINCT user_id) AS total_customers
FROM page_visits
WHERE page_name = '4 - purchase';

 /*
6 How many last touches on the purchase page is each campaign responsible for?
*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT pv.utm_campaign AS campaign,
    COUNT(lt.last_touch_at) AS total_last_touch_customers
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;     
    
 /*
additional queries for the presentation
What is the typical user journey?
*/

SELECT page_name, 
	COUNT(user_id) AS total_visitors
FROM page_visits
GROUP BY 1;

SELECT page_name, 
	COUNT(DISTINCT user_id) AS total_unique_visitors
FROM page_visits
GROUP BY 1;
    
SELECT utm_campaign AS 'campaign',
 SUM(CASE
     WHEN page_name = '1 - landing_page'
         THEN 1
         ELSE 0
     END) AS 'landing_page',
 SUM(CASE
     WHEN page_name = '2 - shopping_cart'
         THEN 1
         ELSE 0
     END) AS 'shopping_cart',
 SUM(CASE
     WHEN page_name = '3 - checkout'
         THEN 1
         ELSE 0
     END) AS 'checkout',
 SUM(CASE
     WHEN page_name = '4 - purchase'
         THEN 1
         ELSE 0
     END) AS 'purchase'
 FROM page_visits
 GROUP BY 1;
 
 SELECT 
 user_id,
 utm_campaign AS 'campaign',
 SUM(CASE
     WHEN page_name = '1 - landing_page'
         THEN 1
         ELSE 0
     END) AS 'landing_page',
 SUM(CASE
     WHEN page_name = '2 - shopping_cart'
         THEN 1
         ELSE 0
     END) AS 'shopping_cart',
 SUM(CASE
     WHEN page_name = '3 - checkout'
         THEN 1
         ELSE 0
     END) AS 'checkout',
 SUM(CASE
     WHEN page_name = '4 - purchase'
         THEN 1
         ELSE 0
     END) AS 'purchase'
 FROM page_visits
 WHERE (user_id = 10162) 
 		OR (user_id = 10400) 
    OR (user_id = 99990) 
    OR (user_id = 99933)
 GROUP BY 1, 2;