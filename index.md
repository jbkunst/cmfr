# cmfr

`cmfr` será un cliente R pequeño para descubrir, describir y descargar
series estadísticas públicas de la Comisión para el Mercado Financiero
de Chile (CMF), con foco inicial en BEST+.

El paquete está en desarrollo. La interfaz pública se definirá a partir
del contrato real de la API oficial de BEST+.

## Instalación

``` r

# install.packages("devtools")
devtools::install_github("jbkunst/cmfr")
```

## Diseño

La API de `cmfr` busca mantenerse pequeña y consistente:

- nombres en `snake_case`;
- identificadores explícitos para descargar datos;
- lenguaje humano limitado a funciones de resolución;
- `tibble`s como salida principal;
- sin clases complejas, caché, bases locales, gráficos ni modelamiento
  en el core;
- sin dependencia de LLMs, `ellmer` o MCP.

## BEST+

La fuente principal en evaluación es BEST+:

- <https://best.cmfchile.cl/inicio>
- <https://best.cmfchile.cl/api/acerca>

El primer caso de validación será obtener colocaciones de consumo por
banco y entender cómo BEST+ representa series, instituciones,
dimensiones y períodos.
