{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['iata_code', 'mes_anio', 'tipo_trafico'],
    incremental_strategy = 'merge',
    merge_update_columns = [
        'aeropuerto',
        'total_pasajeros',
        'variacion_pct',
        'ranking_pasajeros',
        'pasajeros_anio_anterior',
        'cuota_red_pct'
    ]
) }}

SELECT
    UPPER(TRIM(AEROPUERTO))             AS aeropuerto,
    UPPER(TRIM(IATA_CODE))              AS iata_code,
    TOTAL_PASAJEROS::BIGINT             AS total_pasajeros,
    VARIACION_PCT::FLOAT                AS variacion_pct,
    MES_ANIO::TEXT                      AS mes_anio,
    RANKING_PASAJEROS::INT              AS ranking_pasajeros,
    PASAJEROS_ANIO_ANTERIOR::BIGINT     AS pasajeros_anio_anterior,
    CUOTA_RED_PCT::FLOAT                AS cuota_red_pct,
    UPPER(TRIM(TIPO_TRAFICO))           AS tipo_trafico,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ    AS datos_insertados
FROM {{ source('bronze', 'RAW_AENA_PASAJEROS') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}