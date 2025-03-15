library(tidyverse)
library(cbbdata)
library(cbbplotR)
library(purrr)
library(gtExtras)
library(webshot2)

years <- (2008:2025)

csu_from_2008 <- map_dfr(years, ~cbd_torvik_player_season(year = .x,
                                          team = "Colorado St."))
csu_top_players <- csu_from_2008 |> 
  filter(mpg >= 20) |> 
  slice_max(bpm, n = 10) |> 
  select(player, year, g, bpm, ortg, drtg)

csu_top_players |> 
  gt(id = "player") |> 
  gt_theme_athletic() |> 
  cols_align(columns = c(player, year, g, bpm, ortg, drtg), 
             align = "center") |> 
  cols_label(
    player = "Name",
    year = "Year",
    g = "Games Played",
    bpm = "Box Plus/Minus",
    ortg = "Offensive Rating",
    drtg = "Defensive Rating") |> 
  fmt_number(columns = c(bpm, drtg), decimals = 2) |> 
  gt_hulk_col_numeric(bpm) |> 
  tab_header(title = "Top 10 CSU Players by Box Plus/Minus since 2008",
             subtitle = "Min. 20 minutes per game") |> 
  tab_source_note(source_note = md("Data from cbbdata/Bart Torvik 
                                   + Viz. by Micah Davis")) |> 
  gtsave_extra("Top 10 CSU Players.png")
