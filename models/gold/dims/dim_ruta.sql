{{ config(
    schema = 'GOLD',
    materialized = 'table'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['ruta_id']) }}  AS ruta_sk,
    ruta_id,
    aeropuerto_origen,
    aeropuerto_destino,
    distancia_km,
    tipo_ruta,
    demanda,
    frecuencia_semanal,
    activa,
    tiempo_vuelo_estimado_min,
    tarifa_media_eur,
    num_competidores,
    CASE
        WHEN distancia_km < 500   THEN 'Corto'
        WHEN distancia_km < 1500  THEN 'Medio'
        ELSE 'Largo'
    END                                                  AS categoria_distancia
FROM {{ ref('rutas') }}