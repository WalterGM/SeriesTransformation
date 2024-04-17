{{ config(materialized = 'view') }}

WITH comparison_employees AS (
    SELECT
        supersector_info.supersector_name as supersector_name,
        SUM((CASE WHEN datatype_info.data_type_code =10 THEN CAST(value AS NUMERIC) ELSE 0 END )) women_employees,
        SUM((CASE WHEN datatype_info.data_type_code =1 THEN CAST(value AS NUMERIC) ELSE 0 END )) all_employees,
        d.CalendarYear year,
        d.CalendarYear||'-'||d.CalendarMonth month,
        d.CalendarYear||'-'||d.CalendarQuarter quarter
    FROM {{ ref('final_series_data_table') }} s INNER JOIN {{ref("dimdates")}} d
        ON REPLACE(s.period,"M0","")||s.year = d.CalendarMonth||d.CalendarYear
    WHERE  series_info.seasonal = 'S'
    GROUP BY ALL
)

SELECT
    supersector_name,
    women_employees,
    ABS(all_employees - women_employees) men_employees,
    month,
    quarter,
    year
FROM comparison_employees
ORDER BY month, quarter, year ASC
