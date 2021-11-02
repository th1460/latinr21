require(magrittr)
require(tidymodels)

# ler e preparar os dados

titanic <- titanic::titanic_train

titanic %<>% 
  dplyr::mutate(Sex = as.factor(Sex),
                Pclass = factor(Pclass,
                                labels = c("1st", "2nd", "3rd")),
                Survived = factor(Survived, labels = c("No", "Yes")))
titanic %<>% 
  dplyr::select(Sex, Pclass, Survived) |> 
  dplyr::as_tibble()

# ajustar e salvar o modelo

lr_mod <- logistic_reg() %>% set_engine("glm")
lr_fit <- lr_mod %>% fit(Survived ~ Sex + Pclass, data = titanic)

yaml::write_yaml(tidypredict::parse_model(lr_fit),"my_model.yml")

# deploy

# docker build th1460/titanic .
# docker push th1460/titanic

# ibmcloud login
# ibmcloud target -o thop100@hotmail.com -s dev
# zip -r titanic.zip exec script.R my_model.yml

# ibmcloud fn action create titanic titanic.zip --docker th1460/titanic --web true

# request

# ibmcloud fn action get <ACTION NAME> --url

input <- list(Sex = "male", Pclass = "3rd")

"https://us-south.functions.appdomain.cloud/api/v1/web/thop100@hotmail.com_dev/default/titanic.json" %>% 
  httr::POST(., body = input, encode = "json") %>% httr::content() %>% 
  .[c("Sex", "Pclass", "fit")] %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE)
