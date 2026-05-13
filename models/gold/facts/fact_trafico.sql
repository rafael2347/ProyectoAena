{{ config(
    schema = 'GOLD',
    materialized = 'incremental',
    unique_key = ['iata_code', 'mes_anio', 'tipo_trafico'],
    incremental_strategy = 'merge'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['p.iata_code']) }} AS aeropuerto_sk,
    {{ dbt_utils.generate_surrogate_key(['p.mes_anio']) }} AS tiempo_sk,

    p.iata_code,
    p.mes_anio,
    p.tipo_trafico,

    -- Métricas pasajeros
    p.total_pasajeros,
    p.pasajeros_anio_anterior,
    p.variacion_pct_pasajeros,
    p.cuota_red_pct,
    p.ranking_pasajeros,

    -- Métricas operaciones
    o.total_operaciones,
    o.ops_anio_anterior,
    o.variacion_pct_operaciones,
    o.promedio_diario_ops,
    o.ocupacion_estimada_pax_op,
    o.pct_sobre_red,
    o.ranking_operaciones,
    --redondea el resultado a dos decimas
    ROUND(p.total_pasajeros / NULLIF(o.total_operaciones, 0), 2) AS pasajeros_por_operacion

FROM {{ ref('pasajeros') }} p
LEFT JOIN {{ ref('operaciones') }} o
    ON p.iata_code = o.iata_code
    AND p.mes_anio = o.mes_anio

{% if is_incremental() %}
    WHERE p.mes_anio NOT IN (SELECT DISTINCT mes_anio FROM {{ this }})
{% endif %}