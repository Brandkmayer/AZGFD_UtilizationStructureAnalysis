# Between year comparison of Production, Height for that year, Use for the following year, height after use and the assocaited  change. 

ResultsDir<- paste0(dirname(path.expand('~')),"/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Results/")

# Identify the most recent year
# Production
Production<-as.data.frame(file.info(list.files(paste0(ResultsDir,"Production"),full.names = T))) %>% 
  tibble::rownames_to_column() %>% arrange(desc(mtime))
Base <- readr::read_csv(Production[1,1])[,1:4]

# Height at Production
Structure<-as.data.frame(file.info(list.files(paste0(ResultsDir,"Structure"),full.names = T))) %>% 
  tibble::rownames_to_column() %>% arrange(desc(mtime))
Add <- cbind(Base,readr::read_csv(Structure[1,1])[,c(5)]) 
names(Add)[names(Add) == 'Measurements'] <- 'Structure At Production (In)'

# Use
Utilization<-as.data.frame(file.info(list.files(paste0(ResultsDir,"Utilization"),full.names = T))) %>% 
  tibble::rownames_to_column() %>% arrange(desc(mtime))
Add <- cbind(Add,readxl::read_xlsx(Utilization[1,1])[,c(4)]) 
names(Add)[names(Add) == 'Average'] <- 'Average Utilization (%)'

# Height at Use
Final <- cbind(Add,readr::read_csv(Structure[2,1])[,c(5)]) 
names(Final)[names(Final) == 'Measurements'] <- 'Structure After Use (In)'

# Difference of heights
Final$`Difference After Use` <- c(as.data.frame(Final[,5])-as.data.frame(Final[,7]))[[1]]
write.csv(Final,paste0(ResultsDir,"Utilization_Structure/StructureChange_",sub(".csv","",basename(Production[1,1])),".csv"))


# MYears <- data.table::rbindlist(lapply(list.files(paste0(ResultsDir,"Utilization_Structure"),full.names = T), read.csv)) 
# Mod <- lm(DifferenceAfterUse~Utilization + StructureAtProduction,data = MYears) 
# summary(Mod)
# plot(DifferenceAfterUse~Utilization,data = MYears)
