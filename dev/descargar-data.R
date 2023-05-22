# devtools::load_all()
library(tidyverse)
library(cmfr)

try(dir.create("data-raw/balance"))

dlinks <- cmf_besb_links()

dlinks |>
  # head() |>
  select(fecha, link) |>
  pwalk(function(fecha, link){

    # fecha <- lubridate::ymd("2023-03-01")
    # link  <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-69329_recurso_1.zip"

    cli::cli_progress_step("{format(fecha, \"%Y%m\")}")

    fout <- str_glue("data-raw/balance/{format(fecha, \"%Y%m\")}.rds")

    if(fs::file_exists(fout)) return(TRUE)

    daux <- cmf_besb_data(link)

    saveRDS(daux, fout)

  })

data <- dir("data-raw/balance", full.names = TRUE) |>
  map(readRDS)

data |> map(count) |>  bind_rows()

data |> map(count, periodo) |>  bind_rows()

data <- bind_rows(data)

data |>
  filter(modelo == "b1", cod_ifi == "001", X1 == 100000000)

balance <- data

usethis::use_data(balance)
