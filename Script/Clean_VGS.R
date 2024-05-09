# Cleaning/wrangling script to sort sites and collection methods into designated folders from the VGS_DataEport Format.

# The script is designed to identify the most recent VGS export placed in the lab's "VGS_Export" folder under the AZGFD_LandSwap project.   
# Sourcing the script should overwrite the most recently collected data. 
library(dplyr)
#Data Stored
files<-as.data.frame(file.info(list.files(paste0(dirname(path.expand('~')),"/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/VGS_Export"),
                             full.names = T))) %>% tibble::rownames_to_column() %>% arrange(desc(mtime))

excel_sheets <- readxl::excel_sheets(files[1,1])
for(sheet in excel_sheets) {
  df <- readxl::read_excel(files[1,1], sheet = sheet)
  filtered_df <- df %>%
    filter(lubridate::year(lubridate::mdy(df$Date)) == max(lubridate::year(lubridate::mdy(Date)), na.rm = TRUE))
  SiteList <- split(filtered_df, filtered_df$SiteID)
  for (Site in SiteList) {
    if (unique(Site$EventType) == "Grazed class") {
      if (!dir.exists(paste0(dirname(path.expand('~')),
                             "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Utilization/",
                             unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))) {
        dir.create(paste0(dirname(path.expand('~')),
                          "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Utilization/",
                          unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))}
      readr::write_csv(Site,paste0(dirname(path.expand('~')),
                            "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Utilization/",unique(lubridate::year(lubridate::mdy(Site$Date))),"/",
                            unique(lubridate::mdy(Site$Date)),"_",unique(Site$SiteID),"_GC.csv"),append = F)}
    
    else if (unique(Site$EventType) == "Robel Pole/VOM") {
      if (!dir.exists(paste0(dirname(path.expand('~')),
                             "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Structure/",
                             unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))) {
        dir.create(paste0(dirname(path.expand('~')),
                          "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Structure/",
                          unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))}
      readr::write_csv(Site,paste0(dirname(path.expand('~')),
                            "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Structure/",unique(lubridate::year(lubridate::mdy(Site$Date))),"/",
                            unique(lubridate::mdy(Site$Date)),"_",unique(Site$SiteID),"_RP.csv"),append = F)} 
    
    else if (unique(Site$EventType) == "Comparative Yield") {
      if (!dir.exists(paste0(dirname(path.expand('~')),
                             "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",
                             unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))) {
        dir.create(paste0(dirname(path.expand('~')),
                          "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",
                          unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))}
      readr::write_csv(Site,paste0(dirname(path.expand('~')),
                            "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",unique(lubridate::year(lubridate::mdy(Site$Date))),"/",
                            unique(lubridate::mdy(Site$Date)),"_",unique(Site$SiteID),"_CY.csv"),append = F)} 
    
    else {
      if (!dir.exists(paste0(dirname(path.expand('~')),
                             "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",
                             unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))) {
        dir.create(paste0(dirname(path.expand('~')),
                          "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",
                          unique(lubridate::year(lubridate::mdy(Site$Date))),"/"))}
      readr::write_csv(Site,paste0(dirname(path.expand('~')),
                                "/Box/1.Ruyle_lab/1.Project_Data/XDiamond/AZGFD_LandSwap/Data/Production/",unique(lubridate::year(lubridate::mdy(Site$Date))),"/",
                                unique(lubridate::mdy(Site$Date)),"_",unique(Site$SiteID),"_DWR.csv"),append = F)}
  }
}

