{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['agrupacion_id', 'mes_anio'],
    incremental_strategy = 'merge'
) }}

SELECT
    UPPER(TRIM(AGRUPACION_ID))          AS agrupacion_id,
    TRIM(DESCRIPCION)                   AS descripcion,
    TOTAL_PASAJEROS::BIGINT             AS total_pasajeros,
    VAR_PAX_PCT::FLOAT                  AS var_pax_pct,
    TOTAL_OPERACIONES::BIGINT           AS total_operaciones,
    VAR_OPS_PCT::FLOAT                  AS var_ops_pct,
    TONELADAS_MERCANCIAS::FLOAT         AS toneladas_mercancias,
    VAR_MERC_PCT::FLOAT                 AS var_merc_pct,
    MES_ANIO::TEXT                      AS mes_anio,
    PCT_PAX_SOBRE_RED::FLOAT            AS pct_pax_sobre_red,
    PCT_OPS_SOBRE_RED::FLOAT            AS pct_ops_sobre_red,
    PCT_MERC_SOBRE_RED::FLOAT           AS pct_merc_sobre_red,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ    AS _inserted_at
FROM {{ source('bronze', 'RAW_AENA_RED_AGRUPADA') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}