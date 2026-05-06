{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['iata_code', 'mes_anio', 'tipo_carga'],
    incremental_strategy = 'merge'
) }}

SELECT
    UPPER(TRIM(AEROPUERTO))                 AS aeropuerto,
    UPPER(TRIM(IATA_CODE))                  AS iata_code,
    TONELADAS::FLOAT                        AS toneladas,
    VARIACION_PCT::FLOAT                    AS variacion_pct,
    MES_ANIO::TEXT                          AS mes_anio,
    RANKING_MERCANCIAS::INT                 AS ranking_mercancias,
    TONELADAS_ANIO_ANTERIOR::FLOAT          AS toneladas_anio_anterior,
    CUOTA_RED_PCT::FLOAT                    AS cuota_red_pct,
    KG_POR_OPERACION_ESTIMADO::FLOAT        AS kg_por_operacion_estimado,
    UPPER(TRIM(TIPO_CARGA))                 AS tipo_carga
FROM {{ source('bronze', 'RAW_AENA_MERCANCIAS') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}