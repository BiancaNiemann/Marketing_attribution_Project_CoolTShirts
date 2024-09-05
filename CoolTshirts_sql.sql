/*Count the campaigns*/
SELECT utm_campaign, COUNT(utm_campaign)
FROM page_visits
GROUP BY utm_campaign;

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

/*Count the sources*/
SELECT utm_source, COUNT(utm_source)
FROM page_visits
GROUP BY utm_source;

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

/*How are campaign and source related*/
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

/*What pages are on CoolTshirts website*/
SELECT DISTINCT page_name
FROM page_visits;

/*Group campaigns and count first touches*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_source,
		pv.utm_campaign,
    COUNT(pv.utm_campaign) AS 'Total campaign'
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 2
ORDER BY 3 DESC;

/*Group campaigns and count last touches*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_source,
		pv.utm_campaign,
    COUNT(pv.utm_campaign) AS 'Total campaign'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 2
ORDER BY 3 DESC;

/*How many visitors make a purchase*/
SELECT page_name, COUNT(DISTINCT user_id)
FROM page_visits
WHERE  page_name = '4 - purchase';

/*OR total users per page*/
SELECT page_name, COUNT(DISTINCT user_id)
FROM page_visits
GROUP BY page_name;

/*How many last touches on purchase page*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT page_name,
    pv.utm_source,
		pv.utm_campaign,
    COUNT(pv.utm_campaign) AS 'Total campaign'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 3
ORDER BY 4 DESC;

