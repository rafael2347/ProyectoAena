{{ config(
    schema = 'GOLD',
    materialized = 'table'
) }}

WITH fechas AS (
    SELECT DISTINCT fecha_vuelo AS fecha
    FROM {{ ref('vuelos') }}
    WHERE fecha_vuelo IS NOT NULL

    UNION

    SELECT DISTINCT
        TO_DATE('01-' || mes_anio, 'DD-YYYY-MM') AS fecha
    FROM {{ ref('pasajeros') }}
    WHERE mes_anio IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['fecha']) }}    AS tiempo_sk,
    fecha,
    DATE_PART('year', fecha)::INT                       AS anio,
    DATE_PART('month', fecha)::INT                      AS mes,
    DATE_PART('quarter', fecha)::INT                    AS trimestre,
    MONTHNAME(fecha)                                     AS nombre_mes,
    'Q' || DATE_PART('quarter', fecha)::TEXT            AS nombre_trimestre,
    DATE_PART('dow', fecha)::INT                        AS dia_semana,
    DAYNAME(fecha)                                       AS nombre_dia,
    CASE DATE_PART('month', fecha)::INT
        WHEN 6 THEN TRUE WHEN 7 THEN TRUE
        WHEN 8 THEN TRUE ELSE FALSE
    END                                                  AS es_temporada_alta
FROM fechas
ORDER BY fecha