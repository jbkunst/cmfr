# cmfr

<!-- badges: start -->
[![R-CMD-check](https://github.com/jbkunst/cmfr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jbkunst/cmfr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Repositorio de desarrollo de `cmfr`, un cliente R pequeño para datos estadísticos públicos de la Comisión para el Mercado Financiero de Chile (CMF), con foco inicial en BEST+.

## Estado

El paquete está en desarrollo temprano. El trabajo actual es entender y validar el contrato real de la API oficial de BEST+ antes de fijar la interfaz pública.

Primer caso de validación:

> colocaciones de consumo por banco

No se mantiene compatibilidad con el experimento anterior de este repositorio.

## Desarrollo

La intención es mantener el paquete deliberadamente pequeño:

- un core mínimo en `R/interface.R`;
- API pública en `snake_case`;
- `tibble`s como salida principal;
- identificadores explícitos para descargar datos;
- sin clases complejas, caché, bases locales, gráficos ni modelamiento en el core;
- sin lógica específica para LLMs, `ellmer` o MCP.

Instalación de la versión de desarrollo:

```r
# install.packages("devtools")
devtools::install_github("jbkunst/cmfr")
```

## Fuentes oficiales

- BEST+: <https://best.cmfchile.cl/inicio>
- API BEST+: <https://best.cmfchile.cl/api/acerca>

La portada de pkgdown vive separadamente en `pkgdown/index.md` para que la documentación del sitio pueda evolucionar sin convertir este README en la página principal del paquete.
