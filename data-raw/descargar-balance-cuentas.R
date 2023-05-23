# devtools::load_all()
library(tidyverse)
library(cmfr)
try(dir.create("data-raw/balance"))

dlinks <- cmf_besb_links()

# sequential --------------------------------------------------------------
t0   <- Sys.time()

dlinks |>
  select(fecha, link) |>
  # head(3) |>
  pwalk(function(fecha, link){

    # fecha <- lubridate::ymd("2023-03-01")
    # link  <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-69329_recurso_1.zip"

    cli::cli_progress_step("{format(fecha, \"%Y%m\")}")

    fout <- str_glue("data-raw/balance/{format(fecha, \"%Y%m\")}.rds")

    if(fs::file_exists(fout)) return(TRUE)

    daux <- cmf_besb_data(link)

    saveRDS(daux, fout)

  })

diff <- Sys.time() - t0
diff

balance <- dir("data-raw/balance", full.names = TRUE) |>
  map(readRDS)

# checks
balance |> map(count) |>  bind_rows()
balance |> map(count, periodo) |>  bind_rows()

balance <- bind_rows(balance)

# checks
balance |> filter(modelo == "b1", cod_ifi == "001", X1 == 100000000)
balance |> count(ifi, sort = TRUE)

usethis::use_data(balance, overwrite = TRUE, compress = "xz")


# instituciones financieras -----------------------------------------------
# obtenemos el ultimo nombre
# mas color
instituciones_financieras <- balance |>
  dplyr::arrange(dplyr::desc(periodo)) |>
  dplyr::distinct(cod_ifi, .keep_all = TRUE) |>
  dplyr::distinct(cod_ifi, ifi)

instituciones_financieras <- instituciones_financieras |>
  mutate(
    color = case_when(
      ifi == "BANCO SANTANDER-CHILE"          ~ "#e50000",
      ifi == "BANCO DEL ESTADO DE CHILE"      ~ "#fe8c01",
      ifi == "BANCO DE CHILE"                 ~ "#0a1464",
      ifi == "BANCO DE CRÉDITO E INVERSIONES" ~ "#37474f",
      ifi == "SCOTIABANK CHILE"               ~ "#ec111a",
      ifi == "BANCO BICE"                     ~ "#1976d2",
      ifi == "BANCO ITAÚ CHILE"               ~ "#1a5493",

      ifi == "BANCO FALABELLA"                ~ "#43b02a",
      ifi == "BANCO RIPLEY"                   ~ "#523178",
      ifi == "BANCO CONSORCIO"                ~ "#003da5",
      ifi == "BANCO SECURITY"                 ~ "#6a2f92",
      ifi == "BANCO INTERNACIONAL"            ~ "#001a72",

      ifi == "" ~ "#",
      ifi == "" ~ "#",
      ifi == "" ~ "#",
      ifi == "" ~ "#",
      ifi == "" ~ "#",

      TRUE                                    ~ NA
    )
  )

instituciones_financieras |> filter(is.na(color)) |> sample_frac(1)
instituciones_financieras |> filter(is.na(color)) |> arrange(cod_ifi)

instituciones_financieras <- instituciones_financieras |>
  mutate(color = coalesce(color, "#A0A0A0"))

usethis::use_data(instituciones_financieras, overwrite = TRUE)

# cuentas de interés ------------------------------------------------------
url_ci <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vRDHh6MySOTWcdV_hZwttunAJ4BrIB7C1w-G75md6pgYnt9I1V8CwXi-2NsVo1VN8kI2yjdjKZS04_n/pub?gid=305536026&single=true&output=csv"

cuentas <- readr::read_csv(
  base::url(url_ci),
  show_col_types = FALSE
  )

usethis::use_data(cuentas, overwrite = TRUE)

# test --------------------------------------------------------------------
d <- semi_join(
  balance |> filter(modelo == "b1", periodo >= 202001),
  cuentas |> filter(codigo_contable == 1300000),
  by = join_by(X1 == codigo_contable)
) |>
  filter(as.numeric(cod_ifi) < 900) |>
  mutate(ifi = forcats::fct_reorder(ifi, X2, .desc = TRUE))

# d |> arrange(desc(X2))
d |> arrange(desc(ifi))

ggplot(d) +
  geom_line(
    aes(
      x = ymd(str_c(periodo, "01")),
      y = X2,
      color = ifi,
      group = ifi
      )
    ) +
  facet_wrap(vars(ifi))
