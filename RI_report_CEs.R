#load libraries
library(dplyr)
library(splitstackshape)
library(tidyr)


##########################################

#read in csv report 
Data <- read.csv(file="Group1.csv")

#split and wrangle first part of data
T1 <- Data %>%
  select(-Group1_key, -NamFullName, -ColCollectionMethods,-ColSpecifics )%>%  #delete key and any columns that printed out in multiple rows: collector name, collection methods, collection specifics
  distinct()  #get distinct rows (collapse data)

#split and wrangle second part of data for collector names
T2 <- Data %>%
  select(ecollectionevents_key, NamFullName) #select only collections event key and collector name column
  
T2<- mutate(getanID(data =T2, id.vars = "ecollectionevents_key")) %>%
  spread(.id, NamFullName)

#rename columns
T2<- T2 %>%
  rename(ColName_1 = 2, ColName_2 = 3, ColName_3 = 4)

##########
#split and wrangle third part of data for collection methods
T3 <- Data %>%
  select(ecollectionevents_key, ColCollectionMethods)   #select only collections event key and col methods
  
T3<- mutate(getanID(data = T3, id.vars = "ecollectionevents_key")) %>%
  spread(.id, ColCollectionMethods)

#rename columns
T3<- T3 %>%
  rename(ColCollectionMethods_1 = 2, ColCollectionMethods_2 = 3, ColCollectionMethods_3 = 4)

#######
#split and wrangle third part of data for collection methods
T4 <- Data %>%
  select(ecollectionevents_key, ColSpecifics)   #select only collections event key and col specifics

T4<- mutate(getanID(data = T4, id.vars = "ecollectionevents_key")) %>%
  spread(.id, ColSpecifics)

#rename columns
T4<- T4 %>%
  rename(ColSpecifics_1 = 2, ColSpecifics_2 = 3, ColSpecifics_3 = 4)

#########
#merge two datasets together and last manipulation of separating "participant roles" into separate columns
T_merge1 <- full_join(T1, T2, by = 'ecollectionevents_key')
T_merge2 <- full_join(T_merge1, T3, by = 'ecollectionevents_key')
T_merge3 <- full_join(T_merge2, T4, by = 'ecollectionevents_key')

T_mergeFinal<- T_merge3 %>%
  separate(ColParticipantRole_tab, c('Role1', 'Role2', 'Role3'))%>%  #you will need to create enough rows for the maximum number of collectors in dataset
  separate(SecDepartment_tab, c('Dep1', 'Dep2')) #sep departments into columns

#write csv
write.csv(T_mergeFinal, file="Group1_wide.csv")
