# <1> Load `internet.csv` into a data frame
internetData = read.csv("internet.csv", header = TRUE)
# <2> Show the first 6 items in `internetData`
head(internetData)
# <3> Get the names of the variables
names(internetData)

# <4> What type of data store Internet_users, One_yr_growth, One_yr_population_change
#     and Penetration?
# Comment:
# (1)Internet_users is quantitative because it shows the quantity of internet
#    users
# (2)One_yr_growth is quantitative because it shows the percentage growth of 
#    new internet users
# (3)One_yr_population_change is qualitative because it doesn't give any info 
#    about the exact percentage of population change - only whether it's positive
#    or negative
# (4)Penetration is quantitative because it shows the percentage of internet
#    users based on the whole population of the country

# <5> Descriptive statistics about the above-mentioned variables
summary(internetData$Internet_users)
summary(internetData$One_yr_growth)

summary(internetData$One_yr_population_change) 
# Comment: this data is qualitative so we cannot express its descriptive statistic
#          with min,max and quartiles.
                                               
summary(internetData$Penetration)

# <6> Countries with min/max penetration
attach(internetData)
internetData[Penetration == max(Penetration),] # max
intrenetData[Penetration == min(Penetration),] # min
detach(internetData)

# <7> One_yr_growth less than 0.05
attach(internetData)
internetData[One_yr_growth < 0.05,]
detach(internetData)

# <8> Density growth histogram of countries with negative penetration
attach(internetData)
negativeGrowth = internetData[One_yr_population_change == "negative", "One_yr_growth"]
hist(negativeGrowth, xlab="Negative growth", prob=T)
lines(density(negativeGrowth), col="red")
# Comment: We can see from the density graph that the growth percentage is not
#          symmetric and it's biased towards 0.
detach(internetData)

# <9> Comparing One_yr_growth with One_yr_population_change
boxplot(internetData$One_yr_growth ~ internetData$One_yr_population_change)
# Comment: We have two categories of data - negative and positive. By using a
#          boxplot we can clearly see the distributions of the growths assigned to
#          either quality.
#          The conclusion is that there's a bigger positive growth because it's mean
#          is quite bigger than the negative growth.


# <10> Correlation between Internet users and Penetration
attach(internetData)
plot(Internet_users, Penetration)
abline(lm(Internet_users ~ Penetration), col="red")
cor(rank(Internet_users), rank(Penetration))
# Comment: There's hardly any visual correlation between the count of internet users
#          and the overall penetration. This is even more obvious when we 
#          calculate the correlation coefficient of the two variables.
detach(internetData)
