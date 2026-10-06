#Sourcing
source("R/00_load_packages.R")

# # Dietary Interview - Individual Foods, First Day
# DI_IF_FD <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/DR1IFF_L.xpt")
# 
# # Dietary Interview - Total Nutrient Intakes, First Day
# DI_TN_FD <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/DR1TOT_L.xpt")
# 
# # Dietary Interview Technical Support File - Food Codes
# DI_TS_FC <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/DRXFCD_L.xpt")
# 
# # Demographic Variables and Sample Weights
# DV_SW <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/DEMO_L.xpt")
#
# #Health Insurance Variable
# HIQ <- read_xpt ("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/HIQ_L.xpt")
# 
# # FPED 2017 - 2020
# FPED_2017_2020 <- read_csv("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/FPED_1720.csv")
#
## Exercise Variables
# PAQ <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/PAQ_L.xpt")
# saveRDS(PAQ, "C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/PAQ_L.rds")
# 
# #Alchohol Use Variables
# ALQ <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/ALQ_L.xpt")
# saveRDS(ALQ, "C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/ALQ_L.rds")
# 
# #Body Measurement Variables
# BMX <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/BMX_L.xpt")
# saveRDS(BMX, "C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/BMX_L.rds")
# 
# #Smoking Variables
# SMQ <- read_xpt("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/Raw Data/SMQ_L.xpt")
# saveRDS(SMQ, "C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/SMQ_L.rds")


DI_IF_FD <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/DR1IFF_L.rds") %>% 
  clean_names()
DI_TN_FD <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/DR1TOT_L.rds") %>% 
  clean_names()
DI_TS_FC <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/DRXFCD_L.rds") %>% 
  clean_names()
DV_SW <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/DEMO_L.rds") %>% 
  clean_names()
HIQ <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/HIQ_L.rds") %>% 
  clean_names()
fped_2017_2020 <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/FPED_1720.rds") %>% 
  clean_names()
PAQ <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/PAQ_L.rds") %>% 
  clean_names()
ALQ <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/ALQ_L.rds") %>% 
  clean_names()
BMX <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/BMX_L.rds") %>% 
  clean_names()
SMQ <- readRDS("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Data/RDS Converted Data/SMQ_L.rds") %>% 
  clean_names()