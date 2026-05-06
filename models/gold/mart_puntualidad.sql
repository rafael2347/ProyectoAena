{{ config(
    schema = 'GOLD',
    materialized = 'incremental',
    unique_key = ['vuelo_id'],
    incremental_strategy = 'merge'
) }}

SELECT
    --Dimensiones vuelo
    v.vuelo_id,
    v.mes_anio,
    v.fecha_vuelo,
    v.estado_vuelo,
    v.tipo_operacion,

    --Dimensiones aerolínea
    v.codigo_aerolinea,
    al.nombre_comercial                 AS aerolinea_nombre,
    al.pais_origen                      AS aerolinea_pais,
    al.categoria                        AS aerolinea_categoria,
    al.alianza,
    al.grupo_aereo,
    al.rating_puntualidad_2025,

    -- Dimensiones ruta
    v.aeropuerto_origen,
    v.aeropuerto_destino,
    ao.ciudad                           AS ciudad_origen,
    ad.ciudad                           AS ciudad_destino,
    ao.pais                             AS pais_origen,
    ad.pais                             AS pais_destino,
    v.distancia_km,

    --Métricas puntualidad
    v.retraso_salida_min,
    v.retraso_llegada_min,
    v.pasajeros_a_bordo,
    v.capacidad_asientos,
    v.load_factor,

    --Métricas derivadas
    CASE WHEN v.retraso_llegada_min <= 15 THEN TRUE ELSE FALSE END  AS es_puntual,
    CASE
        WHEN v.retraso_llegada_min <= 0   THEN 'A tiempo'
        WHEN v.retraso_llegada_min <= 15  THEN 'Retraso leve'
        WHEN v.retraso_llegada_min <= 60  THEN 'Retraso moderado'
        ELSE 'Retraso grave'
    END                                                             AS categoria_retraso

FROM {{ ref('vuelos') }} v
LEFT JOIN {{ ref('aerolineas') }} al
    ON v.codigo_aerolinea = al.codigo_iata
LEFT JOIN {{ ref('aeropuertos') }} ao
    ON v.aeropuerto_origen = ao.iata_code
LEFT JOIN {{ ref('aeropuertos') }} ad
    ON v.aeropuerto_destino = ad.iata_code

{% if is_incremental() %}
    WHERE v.fecha_vuelo > (SELECT MAX(fecha_vuelo) FROM {{ this }})
{% endif %}