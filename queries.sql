--  DATA ANALYSIS - E-COMMERCE

--  1. SESSION WITH ORDERS RATE BY COUNTRY
SELECT 
  s.country,
  COUNT(DISTINCT o.ga_session_id) * 100 / COUNT(DISTINCT s.ga_session_id) AS session_with_orders_percent,
  COUNT(DISTINCT s.ga_session_id) AS session_cnt
FROM `DA.session_params` s
LEFT JOIN `DA.order` o
  ON s.ga_session_id = o.ga_session_id
GROUP BY s.country
ORDER BY session_cnt DESC;

--  2. EMAIL OPEN RATE
SELECT
  es.letter_type,
  COUNT(DISTINCT es.id_message) AS email_sent_cnt,
  COUNT(DISTINCT eo.id_message) AS email_open_cnt,
  COUNT(DISTINCT eo.id_message) / COUNT(DISTINCT es.id_message) AS open_rate
FROM `data-analytics-mate.DA.email_sent` es
LEFT JOIN `data-analytics-mate.DA.email_open` eo
  ON es.id_message = eo.id_message
GROUP BY es.letter_type
ORDER BY open_rate DESC;

--  3. AVERAGE PRODUCT PRICE BY CATEGORY
SELECT
  p.category,
  AVG(p.price) AS avg_price
FROM `data-analytics-mate.DA.product` p
GROUP BY p.category
ORDER BY avg_price DESC;

--  4. REVENUE BY COUNTRY (BEDS CATEGORY)
SELECT
  sp.country,
  SUM(p.price) AS revenue,
  COUNT(o.item_id) AS total_orders
FROM `data-analytics-mate.DA.product` p
JOIN `data-analytics-mate.DA.order` o
  ON p.item_id = o.item_id
JOIN `data-analytics-mate.DA.session_params` sp
  ON o.ga_session_id = sp.ga_session_id
WHERE LOWER(p.category) = 'beds'
GROUP BY sp.country
ORDER BY total_orders DESC;

--  5. USER ENGAGEMENT BY DEVICE
SELECT
  sp.device,
  SAFE_DIVIDE(
    COUNTIF(param.value.string_value = '1'),
    COUNT(param.value.string_value)
  ) AS percent_session_engaged
FROM `data-analytics-mate.DA.event_params` t
CROSS JOIN UNNEST(t.event_params) AS param
JOIN `data-analytics-mate.DA.session_params` sp
  ON t.ga_session_id = sp.ga_session_id
WHERE param.key = 'session_engaged'
GROUP BY sp.device;
