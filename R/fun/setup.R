Sys.setenv(TZ='UTC') # Fuso horario local

# carregar bibliotecas
suppressMessages(library(raster))
suppressMessages(library(ggplot2) )     # visualizacao de dados
suppressMessages(library(ggthemes)  )   # temas para visualizacao de dados
suppressMessages(library(sf)  )         # leitura e manipulacao de dados espaciais
suppressMessages(library(data.table)  ) # manipulacao de dados
# suppressMessages(library(read.dbc)  )   # leitura de bases relacionais em Microsoft Access
suppressMessages(library(geobr) )       # dados espaciais do brasil
suppressMessages(library(pbapply) )     # progress bar
suppressMessages(library(readr) )       # rapida leitura de dados 
suppressMessages(library(tidyr) )       # manipulacao de dados
suppressMessages(library(stringr) )     # operacoes em strings
suppressMessages(library(lubridate) )   # dados em data/horario
suppressMessages(library(fasttime)  )   # rapido processamento deddados em data/horario
suppressMessages(library(mapview) )     # visualizacao interativa dos dados
suppressMessages(library(RColorBrewer)) # paleta de cores
suppressMessages(library(extrafont) )   # fontes de texto
# suppressMessages(library(bit.64)  )     # lidar com numeros ee 64bits
suppressMessages(library(knitr))
suppressMessages(library(furrr))
suppressMessages(library(purrr))
suppressMessages(library(forcats))
suppressMessages(library(future.apply)) # Aplicar funcoes em paralelo
# suppressMessages(library(h3jsr)) # H3 grade hexagonal
suppressMessages(library(dplyr))
suppressMessages(library(hrbrthemes))
suppressMessages(library(beepr))
suppressMessages(library(patchwork))
suppressMessages(library(Hmisc)) # calcular quantis ponderados
suppressMessages(library(osmdata)) # Download de dados do OpenStreeteMaps (OSM)
suppressMessages(library(opentripplanner)) # Usar OTP de dentro do R: https://github.com/ITSLeeds/opentripplanner
suppressMessages(library(ggmap)) # geocoding
suppressMessages(library(h3jsr)) #h3 hex remotes::install_github("obrl-soil/h3jsr")
suppressMessages(library(bit64)) # viz large numbers
suppressMessages(library(quantreg))
suppressMessages(library(gtfstools))
suppressMessages(library(readxl))


munis_list <- list(
  
  # munis_df = tribble(
  #   ~code_muni, ~abrev_muni, ~name_muni,        ~abrev_estado,  ~map_plot_ratio_wh,
  #   2304400,    "for",       "Fortaleza",       "CE",           1.2,
  #   3550308,    "spo",       "Sao Paulo",       "SP",           0.65,
  #   3304557,    "rio",       "Rio de Janeiro",  "RJ",           1.91, 
  #   4106902,    "cur",       "Curitiba",        "PR",           0.62,
  #   4314902,    "poa",       "Porto Alegre",    "RS",           0.75,
  #   3106200,    "bho",       "Belo Horizonte",  "MG",           0.69,
  #   5300108,    "bsb",       "Brasilia",        "DF",           1.71,
  #   2927408,    "sal",       "Salvador",        "BA",           1.36,
  #   1302603,    "man",       "Manaus",          "AM",           1.27,           
  #   2611606,    "rec",       "Recife",          "PE",           0.68,
  #   5208707,    "goi",       "Goiania",         "GO",           0.93,
  #   1501402,    "bel",       "Belem",           "PA",           0.65,
  #   3518800,    "gua",       "Guarulhos",       "SP",           0.91,
  #   3509502,    "cam",       "Campinas",        "SP",           1.20,
  #   2111300,    "slz",       "Sao Luis",        "MA",           0.78,
  #   3304904,    "sgo",       "Sao Goncalo",     "RJ",           1.21,
  #   2704302,    "mac",       "Maceio",          "AL",           0.74,
  #   3301702,    "duq",       "Duque de Caxias", "RJ",           0.61,
  #   5002704,    "cgr",       "Campo Grande",    "MS",           0.87,
  #   2408102,    "nat",       "Natal",           "RN",           0.70
  # ) %>% setDT(),
  # 
  
  # munis_modo = tribble(
  #   ~abrev_muni, ~`2017`,  ~`2018`,  ~`2019`,  ~`2020`, 
  #   "for",       "todos",  "todos",  "todos",  "todos",     
  #   "spo",       "todos",  "todos",  "todos",  "todos",   
  #   "rio",       "ativo",  "todos",  "todos",  "todos",   
  #   "cur",       "todos",  "todos",  "todos",  "todos",   
  #   "poa",       "todos",  "todos",  "todos",  "todos",   
  #   "bho",       "todos",  "todos",  "todos",  "todos",   
  #   "bsb",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "sal",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "man",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "rec",       "ativo",  "ativo",  "todos",  "todos",   
  #   "goi",       "ativo",  "ativo",  "todos",  "todos",   
  #   "bel",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "gua",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "cam",       "todos",  "todos",  "todos",  "todos",   
  #   "slz",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "sgo",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "mac",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "duq",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "cgr",       "ativo",  "ativo",  "ativo",  "ativo",   
  #   "nat",       "ativo",  "ativo",  "ativo",  "ativo"   
  # ) %>% 
  #   pivot_longer(cols = `2017`:`2020`, names_to = "ano_modo", values_to = "modo") %>% 
  #   setDT(),
  
  munis_metro = tribble(
    ~abrev_muni, ~ano_metro,  ~code_muni,
    "for",       2017,     2304400,
    "spo",       2017,     3550308,
    "rio",       2017,     3304557,
    "cur",       2017,     4106902,
    "poa",       2017,     4314902,
    "bho",       2017,     3106200,
    "bsb",       2017,     5300108,
    "sal",       2017,     2927408,
    "man",       2017,     1302603,
    "rec",       2017,     2611606,
    "goi",       2017,     5208707,
    "bel",       2017,     1501402,
    "gua",       2017,     3518800,
    "cam",       2017,     3509502,
    "slz",       2017,     2111300,
    "sgo",       2017,     3304904,
    "mac",       2017,     2704302,
    "duq",       2017,     3301702,
    "cgr",       2017,     5002704,
    "nat",       2017,     2408102,
    
    "for",       2018,     2304400,
    "spo",       2018,     3550308,
    "rio",       2018,     3304557,
    "cur",       2018,     4106902,
    "poa",       2018,     4314902,
    "bho",       2018,     3106200,
    "bsb",       2018,     5300108,
    "sal",       2018,     2927408,
    "man",       2018,     1302603,
    "rec",       2018,     2611606,
    "goi",       2018,     5208707,
    "bel",       2018,     1501402,
    "gua",       2018,     3518800,
    "cam",       2018,     3509502,
    "slz",       2018,     2111300,
    "sgo",       2018,     3304904,
    "mac",       2018,     2704302,
    "duq",       2018,     3301702,
    "cgr",       2018,     5002704,
    "nat",       2018,     2408102,
    

  ) %>% setDT()
  
  
) 
