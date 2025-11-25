/*
  SQL Script: 01_bottleneck_segmentation_raw.sql
  Purpose: Initial segmentation analysis to identify operational factors (bottlenecks) that drive up the Average Operational Cost Impact (OCI).
  Note: This script revealed that 'traffic_congestion_level' and 'route_risk_level' are continuous, necessitating further discretization (binning) in Python.
*/

-- Traffic Analysis: Attempts to group by continuous traffic level (revealed as too noisy)
WITH Traffic_Analysis AS (
    SELECT
        traffic_congestion_level,
        COUNT(T1.traffic_congestion_level) AS Total_Deliveries,
        ROUND(AVG(T1.Operational_Cost_Impact), 2) AS Avg_OCI
    FROM logistics T1
    GROUP BY traffic_congestion_level
    ORDER BY Avg_OCI DESC
),

-- Risk Analysis: Attempts to group by continuous risk level (revealed as too noisy)
Risk_Analysis AS (
    SELECT
        route_risk_level,
        ROUND(AVG(T2.Operational_Cost_Impact), 2) AS Avg_OCI
    FROM logistics T2
    GROUP BY route_risk_level
    ORDER BY Avg_OCI DESC
),

-- Warehouse Analysis: Groups into discrete high/low buckets (provided the key insight that warehouse time is NOT the bottleneck)
Warehouse_Analysis AS (
    SELECT
        CASE
            WHEN loading_unloading_time > 1.0 THEN 'High_Loading_Time'
            ELSE 'Low_Loading_Time'
        END AS Loading_Efficiency_Bucket,
        COUNT(*) AS Total_Deliveries,
        ROUND(AVG(T3.Operational_Cost_Impact), 2) AS Avg_OCI
    FROM logistics T3
    GROUP BY Loading_Efficiency_Bucket
    ORDER BY Avg_OCI DESC
)

-- Union the results into one table
SELECT 'Traffic_Level' AS Bottleneck_Factor, traffic_congestion_level AS Segment, Total_Deliveries, Avg_OCI FROM Traffic_Analysis
UNION ALL
SELECT 'Risk_Level' AS Bottleneck_Factor, route_risk_level AS Segment, NULL AS Total_Deliveries, Avg_OCI FROM Risk_Analysis
UNION ALL
SELECT 'Loading_Time' AS Bottleneck_Factor, Loading_Efficiency_Bucket AS Segment, Total_Deliveries, Avg_OCI FROM Warehouse_Analysis;