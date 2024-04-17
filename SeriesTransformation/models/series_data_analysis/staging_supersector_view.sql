{{ config(materialized='view') }}

WITH latest_partition AS (
    Select
        MAX(loadDate) as maxPartition
    FROM series_data.supersector
)

Select
    supersector_code,
    supersector_name
    FROM series_data.supersector
    WHERE loadDate = (SELECT maxPartition FROM latest_partition )