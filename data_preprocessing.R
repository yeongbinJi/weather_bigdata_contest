#데이터 

#buy 데이터 
buy=read.csv("buy_data.csv", head=TRUE, fileEncoding="UTF-8")
head(buy)
table(buy$big_cat)
elec=buy[buy$big_cat=="냉난방가전",]; elec
beauty=buy[buy$big_cat=="뷰티",]; beauty
food=buy[buy$big_cat=="식품",]; food
food$date<- as.Date(as.character(food$date), format="%Y%m%d")
food$date<- as.numeric(food$date)
food<-food[-1]
table(food$sm_cat)
#반응변수 범주형 1,2를 0,1로 변환
food$sex = ifelse(food$sex=="F", 1, 0)
food$sex= factor(food$sex)

#sns 데이터 
sns=read.csv("sns_data.csv", header=T, fileEncoding="UTF-8")
head(sns)
sns$date<- as.Date(as.character(sns$date), format="%Y%m%d")
sns$date<- as.numeric(sns$date)
str(sns)
snsfood=sns[sns$big_cat=="식품",]; snsfood

#특보 데이터 
library(lubridate)
library(dplyr)
cold = read.csv("weather_cold.csv")
dry = read.csv("weather_dry.csv")
heat = read.csv("weather_heat.csv")
snow = read.csv("weather_snow.csv")
storm = read.csv("weather_storm.csv")
wind = read.csv("weather_wind.csv")

cold <- format(as.POSIXct(cold$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
cold <- unique(cold)
dry <- format(as.POSIXct(dry$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
dry <- unique(dry)
heat <- format(as.POSIXct(heat$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
heat <- unique(heat)
snow <- format(as.POSIXct(snow$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
snow <- unique(snow)
storm <- format(as.POSIXct(storm$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
storm <- unique(storm)
wind <- format(as.POSIXct(wind$fc_tma, "%Y%m%d %H:%M:%S"), format = "%Y-%m-%d")
wind <- unique(wind)

cold <- data.frame(cold,1)
dry <- data.frame(dry,1)
heat <- data.frame(heat,1)
snow <- data.frame(snow,1)
storm <- data.frame(storm,1)
wind <- data.frame(wind,1)
colnames(cold) <- c("date", "cold")
colnames(dry) <- c("date", "dry")
colnames(heat) <- c("date", "heat")
colnames(snow) <- c("date", "snow")
colnames(storm) <- c("date", "storm")
colnames(wind) <- c("date", "wind")

date <- seq(as.Date('2018-01-01'), as.Date('2019-12-31'), by="days")
bigdata <- data.frame(date)
colnames(bigdata) <- c("date")

head(bigdata)
cold$date<-as.Date(cold$date)
dry$date<-as.Date(dry$date)
heat$date<-as.Date(heat$date)
snow$date<-as.Date(snow$date)
storm$date<-as.Date(storm$date)
wind$date<-as.Date(wind$date)

join <- left_join(bigdata, cold, by=c('date'))
join[is.na(join)] <- 0
join <- left_join(join, dry, by=c('date'))
join[is.na(join)] <- 0
join <- left_join(join, heat, by=c('date'))
join[is.na(join)] <- 0
join <- left_join(join, snow, by=c('date'))
join[is.na(join)] <- 0
join <- left_join(join, storm, by=c('date'))
join[is.na(join)] <- 0
join <- left_join(join, wind, by=c('date'))
join[is.na(join)] <- 0
#write.csv(join, file="dt_list.csv")

warn=join; warn
warn$date<- as.Date(warn$date)
warn$date<- as.numeric(warn$date)

#기상청 전국 관측소 20180101~20191231까지 일기온, 강수량 데이터 
raintemp=read.csv("OBS_AWS_DD_20210610164150.csv", header=T); raintemp
library(lubridate)
library(dplyr)
head(raintemp)
raintemp <- raintemp[,3:5]
raintemp <- na.omit(raintemp)
mean_raintemp <- aggregate(raintemp[,2:3], list(raintemp$일시), mean)
head(mean_raintemp)
colnames(mean_raintemp) <- c("일시", "mean_celsius", "mean_rain")

max_raintemp <- aggregate(raintemp[,2:3], list(raintemp$일시), max)
head(max_raintemp)
colnames(max_raintemp) <- c("일시", 'max_celsius', 'max_rain')

min_raintemp <- aggregate(raintemp[,2], list(raintemp$일시), min)
head(min_raintemp)
colnames(min_raintemp) <- c("일시", "min_celsius")

median_raintemp <- aggregate(raintemp[,2:3], list(raintemp$일시), median)
colnames(median_raintemp) <- c("일시", "median_celsius", "median_rain")
head(median_raintemp)

raintemp <- left_join(max_raintemp, min_raintemp, by = c("일시"))
raintemp <- left_join(raintemp, median_raintemp, by = c("일시"))
raintemp <- left_join(raintemp, mean_raintemp, by = c("일시"))
head(raintemp)
#write.csv(raintemp, "raintemp.csv")

raintemp$일시<- as.Date(raintemp$일시)
raintemp$일시<- as.numeric(raintemp$일시)


#풍속, 습도 데이터 
wind1 <- read.csv("wind.csv")
wind2 <- read.csv("wind2.csv")

humidity1 <- read.csv("humidity.csv")
humidity2 <- read.csv("humidity2.csv")

wind<- rbind(wind1, wind2)

wind <- wind[,3:4]
wind <- na.omit(wind)
wind$일시 <- format(as.POSIXct(wind$일시, "%Y%m%d %H:%M"), format = "%Y-%m-%d")

humi <- rbind(humidity1, humidity2)
humi <- na.omit(humi)
humi$일시 <- format(as.POSIXct(humi$일시, '%Y%m%d %H:%M'), format = "%Y-%m-%d")
humi <- humi[,3:4]
head(humi)

mean_wind <- aggregate(wind[,2], list(wind$일시), mean)
head(mean_wind)
colnames(mean_wind) <- c("일시", "mean_wind")

max_wind <- aggregate(wind[,2], list(wind$일시), max)
colnames(max_wind) <- c("일시", "max_wind")

median_wind <- aggregate(wind[,2], list(wind$일시), median)
colnames(median_wind) <- c("일시", "median_wind")

mean_humi <- aggregate(humi[,2], list(humi$일시), mean)
colnames(mean_humi) <- c("일시", "mean_humi")
head(mean_humi)

median_humi <- aggregate(humi[,2], list(humi$일시), median)
colnames(median_humi) <- c("일시", "median_humi")
head(median_humi)

#불쾌 지수 
cal <- function(x, y){
  return(1.8*x - 0.55*(1-y/100)*(1.8*x-26)+32)
}

discom <- cal(raintemp$mean_celsius, median_humi$median_humi) 

max_wind$일시 <- as.Date(max_wind$일시)
median_wind$일시 <- as.Date(median_wind$일시)
mean_wind$일시 <- as.Date(mean_wind$일시)

windang <- left_join(max_wind,median_wind, by = c("일시"))
windang <- left_join(windang, mean_wind, by = c("일시"))
windang <- cbind(windang, discom)
head(windang)


#미세먼지 PM10
air <- read.csv("air.csv", header = T,  fileEncoding="UTF-8")
air <- air[-c(1,2)]; head(air)
max_air <- aggregate(air[,2], list(air$date), max)
colnames(max_air) <- c("date", "max_air")

median_air <- aggregate(air[,2], list(air$date), median)
colnames(median_air) <- c("date", "median_air")

mean_air <- aggregate(air[,2], list(air$date), mean)
colnames(mean_air) <- c("date", "mean_air")
head(mean_air)

min_air <- aggregate(air[,2], list(air$date), min)
colnames(min_air) <- c("date", "min_air")
head(min_air)

airdirt <- left_join(max_air, median_air, by = c("date"))
airdirt <- left_join(airdirt, mean_air, by = c("date"))
airdirt <- left_join(airdirt, min_air, by = c("date"))
head(airdirt)


#날씨 데이터 병합
weather=cbind(raintemp, windang[-1], airdirt[-1]); head(weather)
colnames(weather)[1] <- "date"

datafinal<- function(n=18261) {
  total<- numeric()
  final <- numeric()
  for(i in 17532:n) {
    x1 <- food[food$date==i,]
    x2 <- data.frame(food[food$date==i,1], weather[weather$date==i,2:16]) 
    x2 <- x2[rep(nrow(x2), each = length(which(food$date==i))),]
    x3 <- data.frame(food[food$date==i,1], warn[warn$date==i,2:7])
    x3 <- x3[rep(nrow(x3), each = length(which(food$date==i))),]
    total <- cbind(x1, x2[2:16], x3[2:7])
    #print(total)
    final <- rbind(final, total)
  }
  return(final)
}
bin=datafinal(); bin
bin$date<-as.Date(bin$date, origin="1970-1-1")
str(bin)


library(data.table)
library(dplyr)
library(rlang)
data1 <- bin
data1$sex <- as.numeric(data1$sex)
cate = data1 %>% select(big_cat, sm_cat, wind) %>% group_by(big_cat, sm_cat) %>% summarise(mean(wind)) %>% select(big_cat, sm_cat)
big_data = expand.grid(date=unique(data1$date), sex=c(1,0), age=c(20,30,40,50,60), "sm_cat" = unique(data1$sm_cat))
big_data = left_join(big_data, cate, by='sm_cat')

big_data <- left_join(big_data, data1, by=c('date','sex','age','sm_cat','big_cat'))
big_data$qty <- ifelse(is.na(big_data$qty), 0, big_data$qty)
head(big_data)
big_data$date<-as.Date(big_data$date)
big_data$date<-as.numeric(big_data$date)

datafinal2<- function(n=18261) {
  total<- numeric()
  final <- numeric()
  for(i in 17532:n) {
    x1 <- big_data[big_data$date==i,]
    x2 <- data.frame(big_data[big_data$date==i,1], weather[weather$date==i,2:16]) 
    x2 <- x2[rep(nrow(x2), each = length(which(big_data$date==i))),]
    x3 <- data.frame(big_data[big_data$date==i,1], warn[warn$date==i,2:7])
    x3 <- x3[rep(nrow(x3), each = length(which(big_data$date==i))),]
    total <- cbind(x1[1:6], x2[2:16], x3[2:7])
    #print(total)
    final <- rbind(final, total)
  }
  return(final)
}
bin2=datafinal2(); bin2
str(bin2)
bin2$date<-as.Date(bin2$date, origin = '1970-01-01')

library(data.table)
dt <- bin2
head(dt)
snsfood <- snsfood[,-1]
snsfood$date<-as.Date(snsfood$date, origin = "1970-01-01")
head(snsfood)
joined <- left_join(dt, snsfood, by=c('date', 'big_cat', 'sm_cat'))
head(joined); str(joined)
fwrite(joined, 'full_data.csv', row.names = F)
############################################################################################################################


library(dplyr)
library(tidyverse)
library(lubridate)
data2 <- read.csv('ratiodata.csv', fileEncoding = 'utf-8')
data3 <- data2[,-c(7,8,12,16)]

head(data3)
food2 = data2[,c(1,2,26)]
head(food2)
cate = unique(food2$sm_cat)
cate
date = unique(food2$date)
date

cate1 <- data3$sm_cat
date1 <- data3$date

head(data3)

data3$tom_max_celsius <- 0

head(data3)
data3$date <- as.Date(data3$date)
data3$date = as.numeric(data3$date)

library(dplyr)
add_tom <- function(data3,colname){
  full_dt = data3[1,]
  new_col_name = paste('tom_',colname,sep='')
  full_dt[,new_col_name] <- 0
  
  for (i in unique(data3$sm_cat)){
    temp = data3[data3$sm_cat==i,colname]
    temp = c(temp[2:730],0)
    data_temp <- data3[data3$sm_cat==i,]
    data_temp[new_col_name] <- temp
    full_dt = rbind(full_dt, data_temp)
  }
  full_dt = full_dt[-1,]
  return (full_dt)
}

aa = add_tom(data3, 'max_celsius')
aa = add_tom(aa, 'min_celsius')
dim(aa)
head(aa)

min_temp1 <- -11.4
max_temp1 <- 6.3

a1 = aa
a1$tom_max_celsius <- ifelse(a1$date==18216, max_temp1, a1$tom_max_celsius)
a1$tom_min_celsius <- ifelse(a1$date==18216, min_temp1, a1$tom_min_celsius)
a1$date <- as.Date(a1$date, origin='1970-01-01')
head(a1)

a1$month <- month(a1$date)

write.csv(a1, 'final_full_data.csv', row.names = FALSE)
########################################################################################################################################


library(dplyr)
library(tidyverse)
library(lubridate)

finaldata <- read.csv('final_full_data.csv')

head(finaldata)

finaldata$date <- as.Date(finaldata$date)
finaldata$date = as.numeric(finaldata$date)

full_data <- numeric()
for (i in unique(finaldata$sm_cat)){
  temp <- finaldata %>% filter(sm_cat==i)
  temp$cnt1 <- c(subset(temp, date==17532)$cnt, temp$cnt[1:(730-1)])
  temp$cnt2 <- c(subset(temp, date==17532)$cnt,subset(temp, date==17533)$cnt,temp$cnt[1:(730-2)])
  temp$cnt_3days <- (temp$cnt + temp$cnt1 + temp$cnt2)/3
  full_data <- rbind(full_data, temp)
}
full_data <- full_data[,-c(36,37)]
full_data$date <- as.Date(full_data$date, origin='1970-01-01')
head(full_data)

write.csv(full_data, "finally.csv", row.names = FALSE)
#######################################################################################################################################



#14개 데이터 정리
library(data.table)
library(dplyr)
data<- read.csv('finally.csv')
data$cold <- as.factor(data$cold)
data$dry <- as.factor(data$dry)
data$heat <- as.factor(data$heat)
data$snow <- as.factor(data$snow)
data$storm <- as.factor(data$storm)
data$wind <- as.factor(data$wind)
str(data)

data$sm_cat <- gsub('해초류 ', '해초류', data$sm_cat)

unique(data$sm_cat)
food = data[,c(1,2,22)]
head(food)
cate = unique(food$sm_cat)
cate
category = data.frame(1:212, cate)
colnames(category) <- c('cate_num','cate_name')
date = unique(food$date)
date

make <- function(food){
  data <- 1:730
  for (i in unique(food$sm_cat)){
    sum <- subset(food, food$sm_cat==i)['sum']
    data <- cbind(data, sum)
  }
  return(data)
}


new <- numeric()
new <- make(food)
new <- new[,-1]
rownames(new) <- date
colnames(new) <- cate
head(new)


mat <- matrix(0, nrow = 2, ncol = 212)
colnames(mat) <- cate
rownames(mat) <- c("summ", "cv")

colnames(food)
colnames(food)
food <- left_join(food, category, by=c('sm_cat'='cate_name'))
summ <- food %>% group_by(cate_num) %>% summarise(total_sum=sum(sum))
summ1 <- summ$total_sum
mat[1,] <-summ1


cv <- food %>% group_by(sm_cat) %>% summarise(cv1=sd(sum)/mean(sum))
cv1 <- cv$cv1
mat[2,] <- cv1
event <- t(mat)
event <- data.frame(event)

plot(event[,1],event[,2], xlab = "sum", ylab = "cv")
abline(v= 48090 ,h= 0.5346,col="red")
summary(event[,1])
summary(event[,2])
event$sm_cat <- rownames(event)


#군집별 r-squared
smooth <- event %>% filter(summ<48090 & cv<0.5346)
intermittent <- event %>% filter(summ>=48090 & cv<0.5346)
lumpy <- event %>% filter(summ<48090 & cv>=0.5346)
erratic <- event %>% filter(summ>=48090 & cv>=0.5346)

dim(smooth); dim(intermittent); dim(lumpy); dim(erratic)


smooth1 <- left_join(data, smooth, by="sm_cat")
smooth2 <- na.omit(smooth1)
#r-squared-smooth
sm_cat <- c(0,0)
rsquared <- c(0,0)
df <- data.frame(sm_cat, rsquared)

library(data.table)
str(smooth2)

for (i in unique(smooth2$sm_cat)){
  smooth3 <- smooth2[smooth2$sm_cat==i, -c(1,2,3,37,38)]
  gfit = lm(smooth3$sum~., data=smooth3)  
  an1=anova(gfit)
  su1=summary(gfit)
  df <- rbind(df, c(i, su1$adj.r.squared))
}
library(dplyr)
#df <- df[-c(1,2),]
df %>% arrange(rsquared, ascending=F)


intermittent1 <- left_join(data, intermittent, by="sm_cat")
intermittent2 <- na.omit(intermittent1)
#r-squared-intermittent
sm_cat <- c(0,0)
rsquared <- c(0,0)
df <- data.frame(sm_cat, rsquared)

library(data.table)
str(intermittent2)

for (i in unique(intermittent2$sm_cat)){
  intermittent3 <- intermittent2[intermittent2$sm_cat==i, -c(1,2,3,37,38)]
  gfit = lm(intermittent3$sum~., data=intermittent3)  
  an1=anova(gfit)
  su1=summary(gfit)
  df <- rbind(df, c(i, su1$adj.r.squared))
}
library(dplyr)
#df <- df[-c(1,2),]
df %>% arrange(rsquared, ascending=F)



lumpy1 <- left_join(data, lumpy, by="sm_cat")
lumpy2 <- na.omit(lumpy1)
#r-squared-lumpy
sm_cat <- c(0,0)
rsquared <- c(0,0)
df <- data.frame(sm_cat, rsquared)

library(data.table)
str(lumpy2)

for (i in unique(lumpy2$sm_cat)){
  lumpy3 <- lumpy2[lumpy2$sm_cat==i, -c(1,2,3,37,38)]
  gfit = lm(lumpy3$sum~., data=lumpy3)  
  an1=anova(gfit)
  su1=summary(gfit)
  df <- rbind(df, c(i, su1$adj.r.squared))
}
library(dplyr)
#df <- df[-c(1,2),]
df %>% arrange(rsquared, ascending=F)



erratic1 <- left_join(data, erratic, by="sm_cat")
erratic2 <- na.omit(erratic1)
#r-squared-erratic
sm_cat <- c(0,0)
rsquared <- c(0,0)
df <- data.frame(sm_cat, rsquared)

library(data.table)
str(erratic2)

for (i in unique(erratic2$sm_cat)){
  erratic3 <- erratic2[erratic2$sm_cat==i,  -c(1,2,3,37,38)]
  gfit = lm(erratic3$sum~., data=erratic3)  
  an1=anova(gfit)
  su1=summary(gfit)
  df <- rbind(df, c(i, su1$adj.r.squared))
}
library(dplyr)
#df <- df[-c(1,2),]
df %>% arrange(rsquared, ascending=F)


cc=data[data$sum==0, 1:2]
unique(cc$sm_cat)

setdiff(df[df$rsquared>0.4,'sm_cat'] , unique(cc$sm_cat))