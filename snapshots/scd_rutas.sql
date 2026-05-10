{% snapshot scd_rutas %}

{{
    config(
        target_schema = 'SNAPSHOTS',
        unique_key = 'ruta_id',
        strategy = 'check',
        check_cols = [
            'activa',
            'tarifa_media_eur',
            'frecuencia_semanal',
            'num_competidores',
            'demanda'
        ]
    )
}}

SELECT * FROM {{ ref('rutas') }}

{% endsnapshot %}