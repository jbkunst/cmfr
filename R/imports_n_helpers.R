#' @importFrom rlang .data
NULL

mes3_esp_to_eng <- function(x){

  stopifnot(all(nchar(x) == 3))

  dplyr::case_when(
    x == "ene" ~ "jan",
    x == "abr" ~ "apr",
    x == "ago" ~ "aug",
    x == "dic" ~ "dec",
    TRUE       ~ x
  )

}
