attach(faithful)
boxplot(scale(eruptions)[ , 1], scale(waiting)[ , 1])
plot(waiting, eruptions)

data(faithful)
attach(faithful)
plot(waiting, eruptions)
cov(waiting, eruptions)
cor(waiting, eruptions)
plot(waiting, eruptions)
abline(lm(eruptions ~ waiting))
detach(faithful)

x = c(1, 5, 9, 20, 23)
rank(x)
y = c(1, 5, 5, 5, 23)
rank(y)
cor(rank(x), rank(y))
z = c(55, 10, 16, 5, 1)
cor(rank(x), rank(z))
plot(rank(x), rank(z))

a = seq(0, 4, .1)
plot(a, a^2, type = "l")
curve(x^2, 0, 4)

mileage = c(0 ,4, 8, 12, 16, 20, 24, 28, 32)
tread = c(394, 329, 291, 255, 229, 204, 179, 163, 150)
plot(mileage, tread, type="l")
points(mileage, tread, col = "red")


weight = c(150, 135, 210, 140)
height = c(65, 61, 70, 65)
gender = c("F", "F", "M", "F")
study = data.frame(weight, height, gender)
row.names(study) = c("Mary", "Alice", "Bob", "Judy")
names(study) = c("Weight", "Height", "Gender")
study[ , "Weight"]
study[ , 1]
study[ , 1:2]
study["Mary", ]
study["Mary", "Weight"]
study[["Weight"]]
study[study$Gender=="F", ]
rm(weight)

data(PlantGrowth)
attach(PlantGrowth)
levels(PlantGrowth$group)
weight.ctrl=weight[group == "ctrl"]
weight.trt1=weight[group == "trt1"]
weight.trt2=weight[group == "trt2"]
boxplot(weight.ctrl, weight.trt1, weight.trt2)
unstack(PlantGrowth)
boxplot(unstack(PlantGrowth))
boxplot(...)
detach(PlantGrowth)

library(MASS); data(Cars93);attach(Cars93)
price = cut(Price, c(0, 12, 20, max(Price)))
levels(price)=c("cheap", "okay", "expensive")
mpg=cut(MPG.highway, c(0,20,30,max(MPG.highway)))
levels(mpg)=c("bad", "okay", "good")
table(Type)
table(price, Type)
table(price, Type, mpg)
barplot(table(price, Type), beside=T)
barplot(table(Type, price), beside=T)
detach(Cars93)
