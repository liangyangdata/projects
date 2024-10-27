library(tidyverse)
library(tidymodels)
tidymodels_prefer()
data(ames)
ames <- ames |> mutate(Sale_Price = log10(Sale_Price))
ames  %>% head()


1+1
