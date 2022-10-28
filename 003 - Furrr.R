# Load libraries

library(purrr)  # v.0.3.4
library(future) # v.1.28.0
library(furrr)  # v.0.3.1
library(tictoc) # v.1.1

v <- c("hello", "world")

# purrr
map(v, ~.x)

# furrr
future_map(v, ~.x)


# So why use it?
tic()
nothingness <- map(rep(1, 7), ~Sys.sleep(.x))
toc()

# Because we can set a plan for furrr

# Sequential
plan(sequential)

tic()
nothingness <- future_map(rep(1, 7), ~Sys.sleep(.x))
toc()

# Parrallel
plan(multisession, workers = 7)

tic()
nothingness <- future_map(rep(1, 7), ~Sys.sleep(.x))
toc()