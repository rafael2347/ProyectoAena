{{ config(
    schema = 'GOLD',
    materialized = 'table'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['codigo_iata']) }}  AS aerolinea_sk,
    codigo_iata,
    nombre_comercial,
    pais_origen,
    pais_iso,
    grupo_aereo,
    categoria,
    alianza,
    anio_fundacion,
    callsign,
    flota_estimada,
    destinos_desde_espania,
    rating_puntualidad_2025,
    ingresos_anuales_musd,
    empleados_estimados
FROM {{ ref('aerolineas') }}