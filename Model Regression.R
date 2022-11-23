rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 
library(VGAM); library(xtable)

load("crash_base.RData")
crash <- crash[,c(1,2,4:7,9,15:20)]
save(crash, file = "crash.RData")


fit.1 <- vglm(severity ~ Road.Class + Speed.Limit + Weather + Time.of.Day + Type.of.Collision + At.Intersection.Flag, data = crash, family = cumulative(parallel = F ~ Road.Class),
              trace = T)

# Return coefficients explanation below Road.Class City Street and Time.Of.Day Day are base categories
s <- summaryvglm(fit.1); s
# The vglm function uses the stopping ratio method. Essentially we are looking at the odds of the dependent variable
# being lower than a specific category, versus being higher than a specific category.
# As a result, when the Beta coefficient is high in the positive direction, the probability of the dependent variable
# stopping at a category is also higher. When the Beta coefficient is low in the negative direction, the probability 
# of the dependent variable stopping at the category is low.
# When interpreting within the relationship to our variables, since being in a higher category is bad (death is the highest category)
# It is considered 'good' if Beta is high, and 'bad' if Beta is low. 

# Saving the coefficient matrix, but adjusting it to let it be a bit easier to pass on to
# Other funciton by changing the rownames of the matrix into its own column
coeff.matrix <- s@coef3; coeff.matrix
coeff.matrix <- cbind(coeff.matrix,c(rownames(coeff.matrix)))
colnames(coeff.matrix) <- c(colnames(coeff.matrix)[1:4], "Variable")
rownames(coeff.matrix) <- NULL
coeff.matrix <- data.frame(coeff.matrix[,c(5,1:4)])

predict(fit.1, newdata = data.frame(Road.Class = "TOLLWAY",
                                    Speed.Limit = 45,
                                    Weather = "Normal Weather",
                                    Type.of.Collision = "OPPOSITE",
                                    Time.of.Day = "Morning",
                                    At.Intersection.Flag = "FALSE"
                                    ), se.fit = T)

p1 <- c(c(1,0,0,0),c(rep(0,28)),45,0,c(0,0,0),c(0,1,0,0),0); p1
p2 <- c(c(1,0,0,0),c(1,rep(0,27)),45,0,c(0,0,0),c(0,1,0,0),0); p2
p3 <- c(c(0,0,1,0),c(rep(0,2),1,rep(0,25)),45,0,c(0,0,0),c(0,1,0,0),0); p3
p4 <- c(c(0,1,0,0),c(rep(0,21),1,rep(0,6)),45,0,c(0,0,0),c(0,1,0,0),0); p4
vcov <- vcov(fit.1)


sqrt(t(p4) %*% vcov %*% p4)

qt(0.025, (96854 + 42)/4, lower.tail = F)

m1 <- matrix(1, nrow = 5, ncol = 5)

m2 <- matrix(c(1,2,3,4,5), nrow = 5, ncol = 5)
m1 + m2

save(coeff.matrix, file = "Coeff.RData")
save(vcov, file = "vcov.RData")
load("Coeff.RData")
load("crash.RData")
load("vcov.RData")


# Code test methods ----

unique(crash$Road.Class)
