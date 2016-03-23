# from last time - clear aperm and Sn
# explain correctly how Sn works, multiplication - Cauchy and cyclic notations 
# https://en.wikipedia.org/wiki/Symmetric_group
setwd("/home/petko/workspace/class/lecture2")


aa<-array(c(1:30),dim=c(2,3,5))
dim(aa)
aa<-aperm(aa,c(1,3))
dim(aa)
aa<-array(c(2,1,3,2), dim = c(2,2))
bb<-aa
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

# lecture 2
# matrices - arrays with 2 indices - some functions: nrow, ncol, diag, crossprod, eigen etc

diag(aa)
aa
bb
aa * bb
sm<-aa%*%bb
sm
sm%*%sm
t(sm) == sm
xx<-c(1,2)
xx %*% sm %*% xx

# give an easy matrix to generate all Fibonacci numbers via repetitive %*%, fib <- array(c(?,?,?,?), dim = c(2,2))
# which of amongst aa,bb,sm,sm%*%sm define scalar product?
# unimodular matrices etc, fib matrices almost infinite cyclic subgroup of unimodular group 

# functions and first data sets

pow = function(n,mat){
  if (n==1)  return (mat)
  if (n>1) return ( mat%*%pow(n-1,mat))
}
pow(5,aa)
solve(pow(2,aa))
el<-function(mat){mat[1,1]}
el(pow(5,aa))
fn<-array(c(1,1,1,0),dim = c(2,2))
fib <- function(n){
  el(pow(n,fn))
}
res<-data.frame(c(1:20),sapply(c(1:20),fib))
colnames(res)<-c("index","value")
res<-rbind(c(0,1),res)
res1<-data.frame(1:20)
colnames(res1)<-c("index")
res1$value<-sapply(res1$index,fib)
res1<-rbind(0:1,res1)
res1<-res1[order(-res1$index),]
str(res1)
sapply(res1,typeof)
sapply(res1,mode)
mode(res1)
class(res1)

# write a function that multiplies permutations in cyclic notation
# https://en.wikipedia.org/wiki/Permutation_matrix

# more matrices

c(aa)
rbind(aa,bb)
cbind(sm,sm)
determinant(aa, logarithm = FALSE)
solve(aa,xx)
ff<-lsfit(aa,xx,intercept = F)
summary(ff)
ff$qr
ff$residuals

# lists and dataframes

lst <- list(name="Fred", wife="Mary", no.children=3,child.ages=c(4,7,9))
lst
lst[4]
lst[[1]]
lst$name
lst[["name"]]

state <- c("tas", "sa", "qld", "nsw", "nsw", "nt", "wa", "wa",
           "qld", "vic", "nsw", "vic", "qld", "qld", "sa", "tas",
           "sa", "nt", "wa", "vic", "qld", "nsw", "nsw", "wa",
           "sa", "act", "nsw", "vic", "vic", "act")
statef <- factor(state)
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56,
             61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46,
             59, 46, 58, 43)
incomef <- factor(incomes)
accountants <- data.frame(home=statef, loot=incomes, shot=incomef)
str(accountants)

# as.data.frame

fm<-as.data.frame(lst)
tt<-list(aa=1:3,bb=1:4)
tt<-list(1:4,1:2)
tt<-list(letters,c("aa","bb"))
tt<-list(1:4,letters)
tt
ttt<-as.data.frame(tt)
ttt
# http://www.r-bloggers.com/converting-a-list-to-a-data-frame/ ??? maybe older R versions did that ??example 4,6


test4 <- list('Row1'=letters[1:5], 'Row2'=letters[1:7], 'Row3'=letters[8:14])
as.data.frame(test4)

# another example that works (super cool)

mlst <- list(A = 1:3, B = 1:5)
mlst
mlst <- data.frame(lNames = rep(names(mlst), lapply(mlst, length)),lVal = unlist(mlst),row.names = NULL)
mlst

# read files and basic plots

test<-read.csv("test.csv",header = F)
test1 <- read.table("test1.txt")
chart<-read.csv("chart.csv", quote="'")
class(chart)
max(chart$ART_sys)
mode(chart)
typeof(chart)
chart$time <- as.numeric(chart$ts)
str(chart)

pdf("bp.pdf")

plot(chart$time, chart$ART_dia, ylim=range(c(chart$ART_sys, chart$ART_dia)), xlab = "time", ylab = "bp", main = "Measures", type = "l", col="blue")
lines(chart$time, chart$ART_sys, type = "s", col  = "red")
legend(1, 150, legend=c("sys", "dia"), col=c("red", "blue"), lty=1:1, cex=0.8)

dev.off()
