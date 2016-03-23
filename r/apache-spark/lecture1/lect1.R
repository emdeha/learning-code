############ lecture 1 #############

#help - https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf
#in RStudio - click on command and press F1 or bottom right viewer help 
#run selected code or current line with ctrl+enter
#in terminal type R to start session ot Rscript to run a file

#system commands

R.Version()
Sys.time()

#calc

17+17.23+5.49+24.74

#set working directory

setwd("/home/petko/workspace/class/lecture1")

# vectors
# there are other types of objects e.g. list, matrices, data frames, factors, fucntions 

x<-c(1,4,10.5,0.2,"a")
xxx=as.numeric(x)
x<-c(1,4,10.5,0.2)
x[1]
xxx*2
1/x
c(x,x)
c(min(x),max(x))
sum(x)
length(x)
mode(x)
typeof(x)
sqrt(i)

#latex example

sqrt(0+1i)
f <- file('sqrt/sqrt.tex')
writeLines(c(
  "\\documentclass[12pt]{article}", 
  "\\usepackage{amsfonts}", 
  "\\begin{document}",
  "\\title{sqrt(i)}",
  "\\maketitle",
  "\\[\\sqrt{z}=\\sqrt{re^{i\\varphi}}=\\sqrt{r}e^{i\\varphi/2}=\\sqrt{r}\\left(\\cos\\frac{\\varphi}{2}+i\\sin\\frac{\\varphi}{2}\\right)\\]",
  paste("\\[\\sqrt{i}=", 
  sqrt(0+1i),"\\]",sep=''),
  "\\end{document}"),f)
close(f)
cos(pi/4)
sqrt(2)/2
  
#more vectors

y<-c("a","b","c")
paste(y[1:2],y[2:3])
paste(y[2],y[3], sep = '')
mode(y)

#sequences

c(1:20)
seq(1,2,by = 0.5)
rep(y, each = 2)
rep(y, times = 2)
x[1] < -2
z <- c(1:3,NA); is.na(z)
z
z[!is.na(z)]

#Linux/Unix type commands 

cat(x,file="test1.txt",append=T,fill=T)
cat(x,file="test1.txt",append=T,fill=T)
zz<-cat(paste(LETTERS, 1:26), fill = F)
zzz<-print(paste(month.name, 1:12), fill = F, quote = F)
grep(1,c(zzz,zzz))
zzz[grep("a",zzz,ignore.case=T)]

#modes - all elements of a vector are of the same mode (with one tiny exception), thus vector has a mode 

zz <- 0:9
zz <- as.character(zz)
zz <- as.numeric(zz)
ee <- numeric()
ee[6] <- 17
ee<-ee[2*1:3]
ee<-ee[3*1:3]
length(ee) <- 1
class(ee)

#factors
vect=c(1,2,3,1,1,4,5,2,3,5)

state <- c("tas", "sa", "qld", "nsw", "nsw", "nt", "wa", "wa",
             "qld", "vic", "nsw", "vic", "qld", "qld", "sa", "tas",
             "sa", "nt", "wa", "vic", "qld", "nsw", "nsw", "wa",
             "sa", "act", "nsw", "vic", "vic", "act")
statef <- factor(state)
levels(statef)
summary(statef)
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56,
             61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46,
             59, 46, 58, 43)
tapply(incomes, statef, mean)
tapply(incomes, statef, sd)

#check wa

check.wa <-tapply(incomes, statef, identity)[8]
check.wa
mode(check.wa)
check.wa
check.wa[1]
check.wa[[1]]
check.wa[[1]][2]
names(check.wa)
check.wa[2]
check.wa[["wa"]][2]
check.wa$wa[1]
mean(check.wa[[1]])
check.wa<-as.numeric(check.wa)
check.wa<-as.vector(check.wa)
mean(check.wa)
check.wa<-unlist(check.wa)
mean(check.wa)
check.wa
names(check.wa)
check.wa["wa2"]
check.wa1<-unname(check.wa)

#like var, sd uses denominator n-1

sqrt(sum((check.wa-mean(check.wa))^2)/(length(check.wa)-1))

#slice

genders <- c("M", "F", "M", "F", "F", "M", "F", "F", "F", "F", "F", "M", "M",
             "F", "F", "F", "M", "F", "F", "F", "F", "F", "M", "M", "M", "M",
             "M", "M", "M", "M")
table(genders)
gendersf <- factor(genders)
levels(gendersf)
summary(gendersf)
tapply(incomes, list(statef,gendersf), mean)

#arrays

aa <- c(1:60)
dim(aa) <- c(5,4,3)
aa
aa[5,,]
aa[2,3,]
aa[,,10]
aa<-array(1:60, dim = c(2,3,10))

# print out all multiples of 5 in aa with similar calls

# more arrays

aa<-array(c(1,1,1,0), dim = c(2,2))
bb<-array(c(2,1,3,2), dim = c(2,2))
out <- aa%o%bb
out
out <- outer(aa,bb,"+")
out
aa<-aperm(bb,2:1)
t(aa)
d <- outer(0:9, 0:9)
fr <- table(outer(d, d, "-"))
plot(as.numeric(names(fr)), fr, ylim = c(0,600),type="h", xlab="Determinant", ylab="Frequency")
d[10,10]-d[3,3]
#matrices - arrays with 2 indices - some functions: nrow, ncol, diag, crossprod, eigen etc

xx<-c(1,2)
aa
bb
aa * bb
sm<-aa%*%bb
sm
t(sm) == sm
xx %*% sm %*% xx

#give an easy matrix to generate all fibonachi numbers via repetitive %*%, fib <- array(c(?,?,?,?), dim = c(2,2))
#which of amongst aa,bb,sm,sm%*%sm define scalar product?

#more matrices

c(aa)
rbind(aa,bb)
cbind(sm,sm)
determinant(sm, logarithm = FALSE)
solve(aa,xx)
ff<-lsfit(aa,xx,intercept = F)
summary(ff)
ff$coefficients
ff$residuals

# read files and basic plots - first data frames

test<-read.csv("test.csv",header = F)
test1 <- read.table("test1.txt")
chart<-read.csv("chart.csv", quote="'")
max(chart$ART_sys)
mode(chart)
typeof(chart)
chart$time <- as.numeric(chart$ts)
str(chart)

#pdf("bp.pdf")

plot(chart$time, chart$ART_dia, ylim=range(c(chart$ART_sys, chart$ART_dia)), xlab = "time", ylab = "bp", main = "Measures", type = "l", col="blue")
lines(chart$time, chart$ART_sys, type = "s", col  = "red")
legend(1, 150, legend=c("sys", "dia"), col=c("red", "blue"), lty=1:1, cex=0.8)

#dev.off()

