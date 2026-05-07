{{ config(
    schema = 'GOLD',
    materialized = 'incremental',
    unique_key = 'vuelo_id',
    incremental_strategy = 'merge'
) }}

SELECT
    -- Surrogate keys para joins con dims
    {{ dbt_utils.generate_surrogate_key(['v.codigo_aerolinea']) }}      AS aerolinea_sk,
    {{ dbt_utils.generate_surrogate_key(['v.aeropuerto_origen']) }}     AS aeropuerto_origen_sk,
    {{ dbt_utils.generate_surrogate_key(['v.aeropuerto_destino']) }}    AS aeropuerto_destino_sk,
    {{ dbt_utils.generate_surrogate_key(['v.fecha_vuelo']) }}           AS tiempo_sk,

    -- Claves naturales
    v.vuelo_id,
    v.codigo_aerolinea,
    v.aeropuerto_origen,
    v.aeropuerto_destino,
    v.fecha_vuelo,
    v.mes_anio,
    v.estado_vuelo,
    v.tipo_operacion,

    -- Métricas
    v.retraso_salida_min,
    v.retraso_llegada_min,
    v.pasajeros_a_bordo,
    v.capacidad_asientos,
    v.load_factor,
    v.distancia_km,

    -- Métricas derivadas
    CASE WHEN v.retraso_llegada_min <= 15
        THEN TRUE ELSE FALSE
    END                                                                  AS es_puntual,
    CASE
        WHEN v.retraso_llegada_min <= 0   THEN 'A tiempo'
        WHEN v.retraso_llegada_min <= 15  THEN 'Retraso leve'
        WHEN v.retraso_llegada_min <= 60  THEN 'Retraso moderado'
        ELSE 'Retraso grave'
    END                                                                  AS categoria_retraso

FROM {{ ref('vuelos') }} v

{% if is_incremental() %}
    WHERE v.fecha_vuelo > (SELECT MAX(fecha_vuelo) FROM {{ this }})
{% endif %}