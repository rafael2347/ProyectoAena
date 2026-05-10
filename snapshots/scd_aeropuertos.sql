{% snapshot scd_aeropuertos %}

{{
    config(
        target_schema = 'SNAPSHOTS',
        unique_key = 'iata_code',
        strategy = 'check',
        check_cols = [
            'capacidad_anual_estimada',
            'numero_terminales',
            'tiene_aduana',
            'tiene_cargo',
            'red_operadora'
        ]
    )
}}

SELECT * FROM {{ ref('aeropuertos') }}

{% endsnapshot %}