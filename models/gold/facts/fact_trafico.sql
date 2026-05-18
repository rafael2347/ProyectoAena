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
    COALESCE(o.total_operaciones, 0)            AS total_operaciones,
    COALESCE(o.ops_anio_anterior, 0)            AS ops_anio_anterior,
    COALESCE(o.variacion_pct_operaciones, 0)    AS variacion_pct_operaciones,
    COALESCE(o.promedio_diario_ops, 0)          AS promedio_diario_ops,
    COALESCE(o.ocupacion_estimada_pax_op, 0)    AS ocupacion_estimada_pax_op,
    COALESCE(o.pct_sobre_red, 0)                AS pct_sobre_red,
    COALESCE(o.ranking_operaciones, 0)          AS ranking_operaciones,
    COALESCE(ROUND(p.total_pasajeros / NULLIF(COALESCE(o.total_operaciones, 0), 0), 2), 0) AS pasajeros_por_operacion,

    -- Métricas mercancías
    COALESCE(m.toneladas, 0)                    AS toneladas,
    COALESCE(m.variacion_pct_mercancias, 0)     AS variacion_pct_mercancias,
    COALESCE(m.ranking_mercancias, 0)           AS ranking_mercancias,
    COALESCE(m.kg_por_operacion_estimado, 0)    AS kg_por_operacion_estimado

FROM {{ ref('pasajeros') }} p
LEFT JOIN {{ ref('operaciones') }} o
    ON p.iata_code = o.iata_code
    AND p.mes_anio = o.mes_anio
LEFT JOIN {{ ref('mercancias') }} m
    ON p.iata_code = m.iata_code
    AND p.mes_anio = m.mes_anio

{% if is_incremental() %}
    WHERE p.mes_anio NOT IN (SELECT DISTINCT mes_anio FROM {{ this }})
{% endif %}