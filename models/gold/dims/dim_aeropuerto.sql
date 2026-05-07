{{ config(
    schema = 'GOLD',
    materialized = 'table'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['iata_code']) }}   AS aeropuerto_sk,
    iata_code,
    icao_code,
    nombre,
    ciudad,
    pais,
    pais_iso,
    latitud,
    longitud,
    altitud_ft,
    zona_horaria,
    tipo_aeropuerto,
    red_operadora,
    capacidad_anual_estimada,
    numero_terminales,
    tiene_aduana,
    tiene_cargo,
    anio_apertura
FROM {{ ref('aeropuertos') }} 