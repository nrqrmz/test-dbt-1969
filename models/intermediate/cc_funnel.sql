WITH clean_cc_funnel AS (SELECT * FROM {{ ref("stg_circle__funnel") }})

    ,clean_cc_funnel_priority AS (SELECT * FROM {{ ref("stg_circle__funnel_priority") }}) 

SELECT
  ### Key ###
  company
  ###########
  -- prospect infos --
  ,sector
  ,priority
  -- date --
  ,date_lead
  ,date_opportunity
  ,date_customer
  ,date_lost
  -- deal stage --
  ,CASE
    WHEN date_lost IS NOT NULL THEN "4 - Lost"
    WHEN date_customer IS NOT NULL THEN "3 - Customer"
    WHEN date_opportunity IS NOT NULL THEN "2 - Opportunity"
    WHEN date_lead IS NOT NULL THEN "1 - Lead"
    ELSE NULL
  END AS deal_stage
  -- rate --
  ,CASE
    WHEN date_lost IS NOT NULL THEN 0
    WHEN date_customer IS NOT NULL THEN 1
    ELSE NULL
  END AS lead2customer
  ,CASE
    WHEN date_lost IS NOT NULL THEN 0
    WHEN date_opportunity IS NOT NULL THEN 1
    ELSE NULL
  END AS lead2opportunity
  ,CASE
    WHEN date_lost IS NOT NULL AND date_opportunity IS NOT NULL THEN 0
    WHEN date_customer IS NOT NULL THEN 1
    ELSE NULL
  END AS opportunity2customer
  -- time --
  ,DATE_DIFF(date_customer,date_lead,DAY) AS lead2customer_time
  ,DATE_DIFF(date_opportunity,date_lead,DAY) AS lead2opportunity_time
  ,DATE_DIFF(date_customer,date_opportunity,DAY) AS opportunity2customer_time
FROM clean_cc_funnel
LEFT JOIN clean_cc_funnel_priority USING (company)