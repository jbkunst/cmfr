# devtools::load_all()
library(tidyverse)
library(cmfr)
try(dir.create("data-raw/balance"))

dlinks <- cmf_besb_links()

# sequential --------------------------------------------------------------
t0   <- Sys.time()

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

diff <- Sys.time() - t0
diff

balance <- dir("data-raw/balance", full.names = TRUE) |>
  map(readRDS)

# balance |> map(count) |>  bind_rows()
#
# balance |> map(count, periodo) |>  bind_rows()
#
balance <- bind_rows(balance)
#
# balance |>
#   filter(modelo == "b1", cod_ifi == "001", X1 == 100000000)
#
# balance |> count(ifi, sort = TRUE)

usethis::use_data(balance, overwrite = TRUE)


# cuentas de interés ------------------------------------------------------
url_ci <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vRDHh6MySOTWcdV_hZwttunAJ4BrIB7C1w-G75md6pgYnt9I1V8CwXi-2NsVo1VN8kI2yjdjKZS04_n/pub?gid=305536026&single=true&output=csv"

cuentas_interes <- readr::read_csv(
  base::url(url_ci),
  show_col_types = FALSE
  )

usethis::use_data(cuentas_interes, overwrite = TRUE)

# parallel ----------------------------------------------------------------
# library(furrr)
#
# try(dir.create("data-raw/balance-parallel"))
#
# t0   <- Sys.time()
#
# plan(multisession, workers = 12)
#
# dlinks |>
#   # head() |>
#   select(fecha, link) |>
#   future_pwalk(function(fecha, link){
#
#     # fecha <- lubridate::ymd("2023-03-01")
#     # link  <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-69329_recurso_1.zip"
#
#     cli::cli_progress_step("{format(fecha, \"%Y%m\")}")
#
#     fout <- str_glue("data-raw/balance-parallel/{format(fecha, \"%Y%m\")}.rds")
#
#     if(fs::file_exists(fout)) return(TRUE)
#
#     daux <- cmf_besb_data(link)
#
#     saveRDS(daux, fout)
#
#   })
#
# diff2 <- Sys.time() - t0
# diff2
#
# balance2 <- dir("data-raw/balance-parallel/", full.names = TRUE) |>
#   map(readRDS)
#
# balance2 <- bind_rows(balance2)
#
# usethis::use_data(balance2, overwrite = TRUE)


# compare -----------------------------------------------------------------
# rm(diff, diff2, t0)
#
# balance  <- balance  |>
#   arrange(periodo, cod_ifi, modelo, X1) |>
#   mutate(across(where(is.numeric), ~ replace_na(.x, 0)))
#
# balance2 <- balance2 |>
#   arrange(periodo, cod_ifi, modelo, X1) |>
#   mutate(across(where(is.numeric), ~ replace_na(.x, 0)))
#
# all.equal(balance, balance2)
#
# table(balance$periodo == balance2$periodo)
# which(!balance$periodo == balance2$periodo)
#
# table(balance$modelo == balance2$modelo)
# which(!balance$modelo == balance2$modelo)
#
# balance2

