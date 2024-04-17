{{ config(materialized='view') }}

WITH latest_partition AS (
    Select
        MAX(loadDate) as maxPartition
    FROM series_data.datatype
)

Select
    cast(data_type_code as int64) data_type_code,
    data_type_text
    FROM series_data.datatype
    WHERE loadDate = (SELECT maxPartition FROM latest_partition )