WITH
listing_info_raw AS (
    SELECT
        '' AS property_id_sha,
        '' AS mc_export_property_id_sha,
        '(Rental)' AS pretty_address,
        '(Rental)' AS display_address
),
periods AS (
    SELECT
        true AS is_current_period,
        CAST('2020-11-09' AS date) AS start_date,
        CAST('2020-11-15' AS date) AS end_date
),
other_publisher_views_by_period AS (
    SELECT
        p.is_current_period,
        p.start_date,
        p.end_date,
        COALESCE(SUM(clv.streeteasy_page_views), 0) AS streeteasy_page_views,
        COALESCE(SUM(clv.trulia_page_views), 0) AS trulia_page_views,
        COALESCE(SUM(clv.zillow_page_views), 0) AS zillow_page_views,
        COALESCE(SUM(clv.realtor_page_views), 0) AS realtor_page_views
    FROM
        agent_insights_lt.agent_insights__combined_listing_views AS clv
        CROSS JOIN periods AS p
    WHERE
        clv.date BETWEEN p.start_date AND p.end_date
        OR p.is_current_period
)
SELECT * FROM other_publisher_views_by_period;
