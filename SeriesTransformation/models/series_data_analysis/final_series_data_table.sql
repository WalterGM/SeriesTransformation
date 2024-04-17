{{config(
    materialized ='incremental',
    incremental_strategy = "insert_overwrite",
    partition_by ={
        "field": "year",
        "data_type": "int64",
        "range": {
            "start": 1939,
            "end": 2100,
            "interval": 1
        },
        "copy_partitions": true
    }
)}}

SELECT
    s.series_id,
    STRUCT(si.supersector_code, sp.supersector_name) as supersector_info,
    STRUCT(dt.data_type_code, dt.data_type_text) as datatype_info,
    STRUCT(industry_code, seasonal, series_title, begin_year, begin_period, end_year, end_period) as series_info,
    period,
    value,
    year
FROM series_data.series s INNER JOIN {{ref('staging_seriesinfo_view')}} si ON s.series_id = si.series_id
INNER JOIN  {{ref("staging_datatype_view")}} dt ON  cast(si.data_type_code as int64) = dt.data_type_code
INNER JOIN {{ref("staging_supersector_view")}} sp ON si.supersector_code = sp.supersector_code

{% if is_incremental() %}

WHERE year >= _dbt_max_partition

{% endif %}