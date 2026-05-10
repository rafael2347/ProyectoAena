{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['iata_code', 'mes_anio'],
    incremental_strategy = 'merge',
    merge_update_columns = [
        'aeropuerto',
        'total_operaciones',
        'variacion_pct',
        'ranking_operaciones',
        'ops_anio_anterior',
        'pct_sobre_red',
        'promedio_diario_ops',
        'ocupacion_estimada_pax_op'
    ]
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
    OCUPACION_ESTIMADA_PAX_OP::FLOAT        AS ocupacion_estimada_pax_op,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ        AS datos_insertados
FROM {{ source('bronze', 'RAW_AENA_OPERACIONES') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}