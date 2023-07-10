library(cmfr)
library(tidyverse)
library(kunstomverse)
library(showtext)

data("balance")
data("instituciones_financieras")

theme_set(theme_knst(base_size = 12))
font_add_google("IBM Plex Sans", "ibm")
showtext_auto()

d <- balance |>
  filter(
    modelo == "b1",
    periodo > 201901,
    # X1 == 2200100, # DAP
    X1 == 1304000, # Hipoteacario
    as.numeric(cod_ifi) < 900
    ) |>
  mutate(
    total_dap = X2 + X3 + X4 + X5,
    ifi2 = fct_lump_n(ifi, n = 6, w = total_dap, other_level = "Otros")
  ) |>
  group_by(periodo, ifi2) |>
  summarise(total_dap = sum(total_dap)/1e6, .groups = "drop")

d

colores <- instituciones_financieras |>
  select(ifi, color) |>
  deframe()

colores <- c(colores, c("Otros" = "#A0A0A0"))

d |>
  mutate(label = if_else(periodo == max(periodo), as.character(ifi2), NA_character_)) |>
  ggplot(aes(yyyymm::ym_to_date(periodo), total_dap, color = ifi2)) +
  geom_line(size = 2) +
  ggrepel::geom_text_repel(aes(label = label), nudge_x = 1, na.rm = TRUE, size = 2) +
  scale_color_manual(values = colores) +
  theme_minimal()
