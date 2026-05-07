{{ config(
    schema = 'SILVER',
    materialized = 'table'
) }}

SELECT
    UPPER(TRIM(CODIGO_IATA))                AS codigo_iata,
    TRIM(NOMBRE_COMERCIAL)                  AS nombre_comercial,
    TRIM(PAIS_ORIGEN)                       AS pais_origen,
    UPPER(TRIM(PAIS_ISO))                   AS pais_iso,
    TRIM(GRUPO_AEREO)                       AS grupo_aereo,
    TRIM(CATEGORIA)                         AS categoria,
    TRIM(ALIANZA)                           AS alianza,
    ANIO_FUNDACION::INT                     AS anio_fundacion,
    TRIM(CALLSIGN)                          AS callsign,
    FLOTA_ESTIMADA::INT                     AS flota_estimada,
    DESTINOS_DESDE_ESPANIA::INT             AS destinos_desde_espania,
    RATING_PUNTUALIDAD_2025::FLOAT          AS rating_puntualidad_2025,
    INGRESOS_ANUALES_MUSD::FLOAT            AS ingresos_anuales_musd,
    EMPLEADOS_ESTIMADOS::INT                AS empleados_estimados,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ        AS _inserted_at
FROM {{ source('bronze', 'RAW_AEROLINEAS') }}