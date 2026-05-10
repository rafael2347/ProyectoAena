{% snapshot scd_aerolineas %}

{{
    config(
        target_schema = 'SNAPSHOTS',
        unique_key = 'codigo_iata',
        strategy = 'check',
        check_cols = [
            'flota_estimada',
            'alianza',
            'rating_puntualidad_2025',
            'ingresos_anuales_musd',
            'empleados_estimados',
            'grupo_aereo'
        ]
    )
}}

SELECT * FROM {{ ref('aerolineas') }}

{% endsnapshot %}