{{ config(materialized='view') }}

WITH latest_partition AS (
    Select
        MAX(loadDate) as maxPartition
    FROM series_data.seriesinfo
)

Select
    series_id,
    supersector_code,
    industry_code,
    seasonal,
    series_title,
    data_type_code,
    footnote_codes,
    begin_year,
    begin_period,
    end_year,
    end_period,
    FROM series_data.seriesinfo
    WHERE loadDate = (SELECT maxPartition FROM latest_partition ) and length(series_id) > 0