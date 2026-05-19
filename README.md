# 🛫 Proyecto AENA


Este repo es un proyecto dbt de la mano de Snowflake y con cuadro de mandos en **Power BI**.

## 📋 Descripción

Pipeline de datos end-to-end para el análisis del tráfico aéreo de la red de aeropuertos de AENA. 
Incluye ingesta de datos en Bronze, transformación y limpieza en Silver, modelado dimensional en Gold 
y visualización en Power BI.

## 🏗️ Arquitectura

```
Bronze → Silver → Gold → Power BI **Modelo incremental**
```

| Capa | Descripción | Materialización |
|---|---|---|
| Bronze | Datos crudos tal como llegan | Tablas raw |
| Silver | Datos limpios y estandarizados | Incremental + Merge |
| Gold | Modelo dimensional para análisis | Dims (table) + Facts (incremental) |

## 📁 Estructura del proyecto

```
models/
  silver/          # Limpieza, normalización de datos, sería la carpeta staging
  gold/            # Sería la carpeta marts
    dims/          # Dimensiones: aeropuerto, aerolínea, ruta, tiempo
    facts/         # Hechos: tráfico, vuelos
snapshots/         # SCD Tipo 2: aeropuertos, aerolíneas, rutas (son las tablas que muy raro sería que cambiaran)
```

## 📦 Fuentes de datos (Bronze)

| Tabla | Descripción |
|---|---|
| RAW_TRAFICO | Pasajeros, operaciones y mercancías por aeropuerto y mes |
| RAW_VUELOS | Vuelos individuales con puntualidad y ocupación |
| RAW_AEROPUERTOS | Catálogo de aeropuertos de la red AENA |
| RAW_AEROLINEAS | Catálogo de aerolíneas operadoras |
| RAW_RUTAS | Rutas entre pares de aeropuertos |
| RAW_AENA_RED_AGRUPADA | Métricas agregadas de toda la red |

## 🎯 Casos de uso

1. **Análisis de tráfico de pasajeros por aeropuerto** → ¿Qué aeropuertos concentran más tráfico y cómo evolucionan mes a mes?
2. **Análisis de puntualidad por aerolínea y ruta** → ¿Qué aerolíneas y rutas acumulan más retrasos y por qué?

## ⚙️ Pre-requisitos

Antes de poder ejecutar este proyecto, asegúrate de tener:

- ✅ Acceso a la cuenta de **Snowflake**
- ✅ Las siguientes bases de datos creadas en Snowflake:
  -`AENA_DWH` con schemas `BRONZE`, `SILVER` y `GOLD`
- ✅ El warehouse `DBT_WH` con tamaño `X-SMALL`
- ✅ Cuenta en **dbt Cloud** con el proyecto conectado al repo
- ✅ **Power BI Desktop** con conexión a Snowflake configurada

## 🚀 Cómo ejecutar

```bash
# Instalar dependencias
dbt deps

# Ejecutar y testear todo
dbt build

# Solo Silver
dbt build --select silver

# Solo Gold
dbt build --select gold

# Snapshots SCD2
dbt snapshot

# Full refresh (cuando hay cambios estructurales)
dbt build --full-refresh

o en su caso usar el entorno de pro que hace un `dbt build`
```

## 📸 Snapshots SCD2

Se aplica SCD Tipo 2 sobre las dimensiones que cambian lentamente:
- `scd_aeropuertos` → cambios en capacidad, terminales, red operadora
- `scd_aerolineas` → cambios en flota, alianza, rating
- `scd_rutas` → cambios en tarifa, frecuencia, estado activo

## 🧪 Tests

Los modelos incluyen tests de calidad en `schema.yml`:
- `not_null` en claves primarias y columnas críticas
- `unique` en surrogate keys
- `accepted_values` en categorías
- `dbt_utils.accepted_range` en métricas numéricas
