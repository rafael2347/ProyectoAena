{{ config(
    schema = 'SILVER',
    materialized = 'table'
) }}

SELECT
    AIRPORT_ID::INT                         AS airport_id,
    UPPER(TRIM(IATA_CODE))                  AS iata_code,
    UPPER(TRIM(ICAO_CODE))                  AS icao_code,
    TRIM(NOMBRE)                            AS nombre,
    TRIM(CIUDAD)                            AS ciudad,
    TRIM(PAIS)                              AS pais,
    UPPER(TRIM(PAIS_ISO))                   AS pais_iso,
    LATITUD::FLOAT                          AS latitud,
    LONGITUD::FLOAT                         AS longitud,
    ALTITUD_FT::INT                         AS altitud_ft,
    TRIM(ZONA_HORARIA)                      AS zona_horaria,
    UPPER(TRIM(TIPO_AEROPUERTO))            AS tipo_aeropuerto,
    UPPER(TRIM(RED_OPERADORA))              AS red_operadora,
    CAPACIDAD_ANUAL_ESTIMADA::BIGINT        AS capacidad_anual_estimada,
    NUMERO_TERMINALES::INT                  AS numero_terminales,
    TIENE_ADUANA::BOOLEAN                   AS tiene_aduana,
    TIENE_CARGO::BOOLEAN                    AS tiene_cargo,
    ANIO_APERTURA::INT                      AS anio_apertura,
    CURRENT_TIMESTAMP::TIMESTAMP_LTZ        AS _inserted_at
FROM {{ source('bronze', 'RAW_AEROPUERTOS') }}