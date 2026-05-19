{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = ['ruta_id', 'mes_anio'],
    incremental_strategy = 'merge',
    cluster_by = ['mes_anio'], 
    merge_update_columns = [
        'aeropuerto_origen',
        'aeropuerto_destino',
        'distancia_km',
        'tipo_ruta',
        'demanda',
        'operadores_principales',
        'frecuencia_semanal',
        'activa',
        'tiempo_vuelo_estimado_min',
        'tarifa_media_eur',
        'num_competidores'
    ]
) }}

SELECT
    RUTA_ID::TEXT                           AS ruta_id,
    UPPER(TRIM(AEROPUERTO_ORIGEN))          AS aeropuerto_origen,
    UPPER(TRIM(AEROPUERTO_DESTINO))         AS aeropuerto_destino,
    DISTANCIA_KM::FLOAT                     AS distancia_km,
    UPPER(TRIM(TIPO_RUTA))                  AS tipo_ruta,
    TRIM(DEMANDA)                           AS demanda,
    TRIM(OPERADORES_PRINCIPALES)            AS operadores_principales,
    FRECUENCIA_SEMANAL::INT                 AS frecuencia_semanal,
    ACTIVA::BOOLEAN                         AS activa,
    MES_ANIO::TEXT                          AS mes_anio,
    TIEMPO_VUELO_ESTIMADO_MIN::INT          AS tiempo_vuelo_estimado_min,
    TARIFA_MEDIA_EUR::FLOAT                 AS tarifa_media_eur,
    NUM_COMPETIDORES::INT                   AS num_competidores,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ        AS datos_insertados
FROM {{ source('bronze', 'RAW_RUTAS') }}
{% if is_incremental() %}
    WHERE MES_ANIO NOT IN (SELECT DISTINCT MES_ANIO FROM {{ this }})
{% endif %}