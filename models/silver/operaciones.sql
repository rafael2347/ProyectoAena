{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['iata_code', 'mes_anio'],
    incremental_strategy = 'merge'
) }}

SELECT
    UPPER(TRIM(AEROPUERTO))                 AS aeropuerto,
    UPPER(TRIM(IATA_CODE))                  AS iata_code,
    TOTAL_OPERACIONES::BIGINT               AS total_operaciones,
    VARIACION_PCT::FLOAT                    AS variacion_pct,
    MES_ANIO::TEXT                          AS mes_anio,
    RANKING_OPERACIONES::INT                AS ranking_operaciones,
    OPS_ANIO_ANTERIOR::BIGINT               AS ops_anio_anterior,
    PCT_SOBRE_RED::FLOAT                    AS pct_sobre_red,
    PROMEDIO_DIARIO_OPS::FLOAT              AS promedio_diario_ops,
    OCUPACION_ESTIMADA_PAX_OP::FLOAT        AS ocupacion_estimada_pax_op
FROM {{ source('bronze', 'RAW_AENA_OPERACIONES') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}