

## Ari Emdur
## Practice Exercise 7

setwd("D:/DocsRepo/RBasics/Practice7")
getwd()
rm(list=ls())
library(MASS)

# Based on the painters data frame from the MASS library: Create a data frame,
# d1, which contains observations with Colour >=17 and School equals .
d1<-painters[painters$Colour>=17 & painters$School=="D",]
d1
# Create a data frame, d2, that contains only Da Udine and Barocci. 
d2<-painters[is.element(row.names(painters), c("Da Udine","Barocci")),]
d2

# Create a data frame, d3, which contains observations with Colour >=17 
# and School equals , but only with the Composition and Drawing variables.
d3<-painters[painters$Colour>=17 & painters$School =="D", c("Composition","Drawing")]
d3

# Creating Variables. 
#  Create a categorical variable Comp_cat with three approximate equal levels 
# based on Composition. 
#  First, find the cutting points, including minmum, first quartile, third quartile, 
# and maximum values. 
boundary <- quantile(painters$Composition,seq(0,1,by=1/3)) 
boundary

# Use the cut function to create the variable Comp_cat and label each level with
# names I, II, and III. 
Comp_cat<- cut(painters$Composition, boundary, labels=c("I","II","III"),
               include.lowest = T, right = F)

#  Use the ifelse functions to accomplish the same task:
Comp_cat2<-ifelse(painters$Composition < boundary[2], "I", 
                  ifelse(painters$Composition < boundary[3], "II", "III"))

#  Use appropriate function to check if the results from the two methods above
# produce the same result. 
identical(Comp_cat, Comp_cat2)
table(Comp_cat,Comp_cat2)

#  Use the + operator to create a three-level ordinal
# variable with result equaling to 1, 2, and 3. The number of elements within
# each level are approximately equal.
Comp_ord<- 1 + (painters$Composition >= boundary[2]) + (painters$Composition >= boundary[3])
Comp_ord
table(Comp_cat,Comp_ord)

# Consider the following named vector:
convert<-c(A = "One", B = "Two", C = "Three", D = "Four", E = "Five",
           F = "Six", G = "Seven", H = "Eight")
convert

# Based on the School variable from the painters data frame, create a variable,
# School_new, by converting A to One, B to Two, C to Three, etc.

School_new<-convert[as.character(painters$School)]
table(painters$School, School_new)

# Based on the quine data frame from the MASS library, 
# sort the variables based on the following order:
head(quine)

#  Eth in ascending order, Days in descending order 
quine1<-quine[order(quine$Eth, -quine$Days),]
quine1

#  Eth in ascending order, Sex in desending order, and Days in descending order 
quine2<-quine[order(quine$Eth, -xtfrm(quine$Sex), -quine$Days),]
quine2

nrow(quine)
#There are 146 observations in the quine data frame. Use an appropriate function
#to find out the number of unique observations.
nrow(unique(quine))

# There are four factors in the quine data frame, including Eth, Sex, Age, and
# Lrn. How many unique levels among these four factors?
nrow(unique(quine[1:4]))

# or

nrow(unique(quine[c("Eth","Sex","Age","Lrn")]))

#  How many unique levels among Eth and Sex factors? 
nrow(unique(quine[1:2]))

# or

nrow(unique(quine[c("Eth", "Sex")]))

# Create a data frame that contains the maximum Days value for each level of Eth
# and Sex variables. You can follow the steps below to acomplish this task:

# Sort the quine data frame by Eth, Sex and Days variable. Only the Days
# variable needs to be sorted in descending order, so the the maximum value will
# be placed on the top within each level. Name the sorted data frame,
# quine_order.
quine_order<-quine[order(quine$Eth, quine$Sex, -quine$Days),]
quine_order

# Use the duplicated function to find out which rows are duplicated based on the
# Eth and Sex variable. You can name the result as dup_vector.
dup_vector<-duplicated(quine_order[c("Eth","Sex")])
dup_vector

# Negate the dup_vector, which is a logical vector indicating the non-duplicated
# rows. You can name the result as non_dup_vector.
non_dup_vector<-!dup_vector
non_dup_vector

# Use the non_dup_vector to create the data frame that contains the maximum Days
# value for each level of Eth and Sex variables.
quine_order[non_dup_vector, c("Eth","Sex","Days")]

# Write one or more R commands to verify the result above is correct:
sapply(split(quine$Days, list(quine$Eth, quine$Sex)), max)

tapply(quine$Days, list(quine$Eth, quine$Sex), max)

# Consider the following data frame:
dat <- data.frame( 
  ID = c(rep("A01", 3), rep("A02", 2), "A03", "A04", rep("A05", 2)),
  visit = c(3:1, 1, 2, 1,1,1,2), 
  score = c(3,8,2,5,8,4,4,4,5))
dat

# Based on this data frame, create a data frame that contains only one
# observation for each patient that contains the maximum score along with the
# corresponding visiting time.
datSplit<-split(dat, dat$ID)
r<-data.frame()
for (i in 1:length(datSplit)){
  one<-datSplit[[i]]
  index<-which(one$score == max(one$score))
  select<-one[index,]
  r<-rbind(r, select)
}
r

# Write a function, myTable, that is used to tabulate the character variables
# from a given data frame. 

# The first argument of the function is the name of the
# data frame, 

# the second argument is a character vector that contains the names
# of character variables you want to tabulate.
myTable<-function(dat,varList){
  result<-data.frame()
  for(i in 1:length(varList)){
    tab<-table(dat[[varList[i]]]) # Why do we [[ here ?
    tab.dat<-as.data.frame(tab)
    tab.percent<-as.data.frame(prop.table(tab))
    one.table<-data.frame(
      Varname = c(varList[i], rep(" ", nrow(tab.dat)-1)),
      Levels = tab.dat$Var1,
      count = tab.dat$Freq,
      percent = round(tab.percent$Freq*100, 2)
    )
    result<-rbind(result, one.table)
  }
  return(result)
}
myTable(quine,c("Eth"))


  
  
  

