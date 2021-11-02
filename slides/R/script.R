#!/usr/bin/env Rscript

# carregar modelo
loaded_model <-tidypredict::as_parsed_model(yaml::read_yaml("my_model.yml"))
# input
input <- jsonlite::fromJSON("input.json", flatten = FALSE)
# calcular predição
pred <- tidypredict::tidypredict_to_column(as.data.frame(input), loaded_model)
# output
jsonlite::stream_out(pred, verbose = FALSE)