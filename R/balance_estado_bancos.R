#' Balance y Estado de Situación Bancos
#'
#' @examples
#'
#' cmf_besb_links()
#'
#' @export
cmf_besb_links <- function(){

  url <- "https://www.cmfchile.cl/portal/estadisticas/617/w3-propertyvalue-28917.html"

  base_url <- dirname(url)

  # cmf_html <- rvest::read_html(url)

  els <- rvest::read_html(url) |>
    rvest::html_nodes(".format-zip")

  dlinks <- tibble::tibble(
    mes  = els |> rvest::html_text("title"),
    link = els |> rvest::html_nodes("a") |> rvest::html_attr("href")
  )

  dlinks <- dlinks |>
    dplyr::mutate(
      mes = stringr::str_to_lower(.data$mes),
      link = stringr::str_c(base_url, .data$link, sep = "/")
    )

  dlinks <- dlinks |>
    tidyr::separate(.data$mes, c("mes", "anio"), sep = "\\s+")

  dlinks <- dlinks |>
    dplyr::mutate(
      mes = stringr::str_sub(.data$mes, 1, 3),
      mes = mes3_esp_to_eng(.data$mes),
      dia = 1,
      fecha = paste(.data$anio, .data$mes, .data$dia, sep = "-"),
      fecha = lubridate::ymd(fecha)
    )

  dlinks <- dlinks |>
    dplyr::select(fecha, mes, anio, dia, link)

  dlinks

}

#' @export
cmb_besb_importar <- function(archivo){

  # archivo <- "C:/Users/jbkun/AppData/Local/Temp/RtmpucdLZi/202301/b1202301001.txt"

  modelo <- archivo |>
    basename() |>
    stringr::str_sub(1, 2)

  periodo <- archivo |>
    basename() |>
    stringr::str_sub(3, 8)

  meta_data <- readr::read_tsv(
    archivo,
    n_max = 1,
    col_names = c("cod_ifi", "ifi"),
    show_col_types = FALSE,
    col_types = c("c", "c")
    )

  data <- readr::read_tsv(
    archivo,
    skip = 1,
    col_names = FALSE,
    show_col_types = FALSE,
    progress = FALSE,
  )

  data <- data |>
    mutate(across(where(is.character), readr::parse_number))

  data <- bind_cols(meta_data, data) |>
    mutate(
      modelo = modelo,
      periodo = periodo,
      .before = 1
    )

  data

}

#' @export
cmf_besb_data <- function(url_file){

  # url_file <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-43001_recurso_1.zip"
  # url_file <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-60721_recurso_1.zip"
  # url_file <- "https://www.cmfchile.cl/portal/estadisticas/617/articles-42982_recurso_1.zip"

  tmp_file <- tempfile(fileext = ".zip")
  tmp_dir  <- dirname(tmp_file)

  download.file(url_file, tmp_file)

  dfiles <- unzip(tmp_file, list = TRUE, overwrite = TRUE)

  periodo <- dfiles[["Name"]] |>
    basename() |>
    stringr::str_sub(3, 8) |>
    stringr::str_subset("[0-9]{6}") |>
    unique()

  stopifnot(length(periodo) == 1)

  unzip(tmp_file, exdir = dirname(tmp_file), overwrite = TRUE)

  files <- fs::dir_ls(file.path(tmp_dir), recurse = TRUE)

  files <- files |>
    stringr::str_subset(stringr::str_c("/(b1|b2|c1|c2|r1)", periodo)) |>
    stringr::str_subset("txt$")

  data <- purrr::map(files, cmb_besb_importar)

  data <- dplyr::bind_rows(data)

  data

}