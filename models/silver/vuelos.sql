{{ config(
    schema = 'SILVER',
    materialized = 'incremental',
    unique_key = 'vuelo_id',
    incremental_strategy = 'merge'
) }}

SELECT
    VUELO_ID::TEXT                          AS vuelo_id,
    UPPER(TRIM(CODIGO_AEROLINEA))           AS codigo_aerolinea,
    UPPER(TRIM(AEROPUERTO_ORIGEN))          AS aeropuerto_origen,
    UPPER(TRIM(AEROPUERTO_DESTINO))         AS aeropuerto_destino,
    UPPER(TRIM(ESTADO_VUELO))               AS estado_vuelo,
    RETRASO_SALIDA_MIN::INT                 AS retraso_salida_min,
    RETRASO_LLEGADA_MIN::INT                AS retraso_llegada_min,
    PASAJEROS_A_BORDO::INT                  AS pasajeros_a_bordo,
    CAPACIDAD_ASIENTOS::INT                 AS capacidad_asientos,
    LOAD_FACTOR::FLOAT                      AS load_factor,
    FECHA_VUELO::DATE                       AS fecha_vuelo,
    HORA_SALIDA_PROGRAMADA::TIME            AS hora_salida_programada,
    TIPO_OPERACION::INT                     AS tipo_operacion,
    DISTANCIA_KM::FLOAT                     AS distancia_km,
    MES_ANIO::TEXT                          AS mes_anio,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ        AS datos_insertados
FROM {{ source('bronze', 'RAW_VUELOS') }}
{% if is_incremental() %}
    WHERE FECHA_VUELO > (SELECT MAX(fecha_vuelo) FROM {{ this }})
{% endif %}