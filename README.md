# cmfr

<!-- badges: start -->
[![R-CMD-check](https://github.com/jbkunst/cmfr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jbkunst/cmfr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`cmfr` será un cliente R pequeño para descubrir, describir y descargar series estadísticas públicas de la Comisión para el Mercado Financiero de Chile (CMF), con foco inicial en BEST+.

El paquete está en desarrollo. La interfaz pública se definirá a partir del contrato real de la API oficial de BEST+, sin mantener compatibilidad con el experimento previo de este repositorio.

## Instalación

```r
# install.packages("devtools")
devtools::install_github("jbkunst/cmfr")
```

## Principios

- API pequeña y consistente en `snake_case`.
- Identificadores explícitos para descargar datos.
- Lenguaje humano solo en funciones `resolve_*()`.
- `tibble`s como salida principal.
- Sin clases complejas, caché, bases locales, gráficos ni modelamiento en el core.
- El paquete no conoce ni depende de LLMs, `ellmer` o MCP.

## BEST+

La fuente principal en evaluación es BEST+:

- <https://best.cmfchile.cl/inicio>
- <https://best.cmfchile.cl/api/acerca>

El primer caso de validación será obtener colocaciones de consumo por banco y entender cómo BEST+ representa series, instituciones, dimensiones y períodos.
