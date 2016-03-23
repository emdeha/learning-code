simpleMove<-function(e,vect){
  if(is.na(match(e,vect))){
    return(e)
  }else{
    return(vect[match(e,vect)%%length(vect)+1])
  }
}

doubleMove <- function(e){
  simpleMove(simpleMove(e,a),b)
}

a<-c(1,3)
b<-c(2,3,4)
res<-sort(unique(c(a,b)))
perm<-sapply(res,doubleMove)
res
perm

simpleCyclic<-function(e,vect){
  vect[match(e,sort(vect))]
}


cc<-c(1)
cyc <-function(e,vect,st){
  if (simpleCyclic(e,vect)!=st){
    cc<<-c(cc,simpleCyclic(e,vect))
    cyc(simpleCyclic(e,vect),vect,st)
  }
}

cyc(1,perm,1)
cc










