usethis::use_package("purrr")
usethis::use_package("dplyr")
usethis::use_package("readr")
usethis::use_package("tibble")
usethis::use_package("rlang")
usethis::use_package("rvest")
usethis::use_package("stringr")
usethis::use_package("lubridate")
usethis::use_package("tidyr")
usethis::use_package("fs")

usethis::use_mit_license()

usethis::use_readme_rmd()

usethis::use_github_actions_badge()

usethis::use_github_action_check_standard()

# pkgdown -----------------------------------------------------------------
usethis::use_pkgdown()
usethis::use_pkgdown_github_pages()

# test pkgdown ------------------------------------------------------------
pkgdown::init_site()
pkgdown::build_home(preview = TRUE)

