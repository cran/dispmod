\name{glm.poisson.disp}
\alias{glm.poisson.disp}
\title{Overdispersed Poisson log-linear models.}
\description{This function estimates overdispersed Poisson log-linear models using the approach discussed by Breslow N.E. (1984).}
\usage{
glm.poisson.disp(object, maxit = 30, verbose = TRUE)
}
\arguments{
\item{object}{an object of class `"glm"' providing a fitted binomial logistic regression model.}
\item{maxit}{integer giving the maximal number of iterations for the model fitting procedure.}
\item{verbose}{logical, if \code{TRUE} information are printed during each step of the algorithm.}
}
\details{
Breslow (1984) proposed an iterative algorithm for fitting overdispersed Poisson log-linear models. The method is similar to that proposed by Williams (1982) for handling overdispersion in logistic regression models (\code{\link{glm.binomial.disp}}). 

Suppose we observe \eqn{n} independent responses such that
\deqn{y_i|\lambda_i \sim \mathrm{Poisson}(\lambda_in_i)}{y_i|\lambda_i ~ Poisson(\lambda_i*n_i)}
for \eqn{i=1\ldots,n}.
The response variable \eqn{y_i} may be an event counts variable observed over a period of time (or in the space) of length \eqn{n_i}, whereas \eqn{\lambda_i} is the rate parameter. Then,
\deqn{E(y_i|\lambda_i) = \mu_i = \lambda_in_i=\exp(\log(n_i) + \log(\lambda_i))}{E(y_i|\lambda_i) = \mu_i = \lambda_i*n_i=\exp(\log(n_i) + \log(\lambda_i))}
where \eqn{\log(n_i)} is an offset and \eqn{\log(\lambda_i)=\beta'x_i} expresses the dependence of the Poisson rate parameter on a set of, say \eqn{p}, predictors. If the periods of time are all of the same length, we can set \eqn{n_i=1} for all \eqn{i} so the offset is zero.

The Poisson distribution has \eqn{E(y_i|\lambda_i)=Var(y_i|\lambda_i)}, but it may happen that the actual variance exceeds the nominal variance under the assumed probability model. Suppose now that \eqn{\theta_i=\lambda_i n_i} is a random variable distributed according to
\deqn{\theta_i \sim \mathrm{Gamma} (\mu_i, 1/\phi)}{\theta_i ~ Gamma (\mu_i, 1/\phi)}
where \eqn{E(\theta_i)=\mu_i} and \eqn{Var(\theta_i)=\mu_i^2\phi}{Var(\theta_i)=\mu_i^2 * \phi}. Thus, it can be shown that the unconditional mean and variance of \eqn{y_i} are given by
\deqn{E(y_i) = \mu_i}
and
\deqn{Var(y_i) = \mu_i + \mu_i^2\phi = \mu_i(1+\mu_i\phi)}{Var(y_i) = \mu_i + \mu_i^2 * \phi = \mu_i(1+\mu_i*\phi)}
Hence, for \eqn{\phi>0} we have overdispersion. It is interesting to note that the same mean and variance arise also if we assume a negative binomial distribution for the response variable.

The method proposed by Breslow uses an iterative algorithm for estimating the dispersion parameter \eqn{\phi} and hence the necessary weights \eqn{1/(1+\mu_i\hat{\phi})}{1/(1+\mu_i * \phi)} (for details see Breslow, 1984).
}
\value{
The function returns an object of class `"glm"' with the usual information (see \code{help(glm)}) and the added components:   
\item{dispersion}{the estimated dispersion parameter.}
\item{disp.weights}{the final weights used to fit the model.}
}
\references{
 Breslow, N.E. (1984), Extra-Poisson variation in log-linear models, 
\emph{Applied Statistics}, \bold{33}, 38--44.
}
\author{Luca Scrucca, \email{luca@stat.unipg.it}}
\note{Based on a similar procedure available in Arc (Cook and Weisberg, \url{http://www.stat.umn.edu/arc})}
\seealso{
\code{\link{lm}}, \code{\link{glm}}, \code{\link{lm.disp}}, \code{\link{glm.binomial.disp}}
}
\examples{
##-- Salmonella TA98 data

data(salmonellaTA98)
attach(salmonellaTA98)
log.x10 <- log(x+10)
mod <- glm(y ~ log.x10 + x, family=poisson(log)) 
summary(mod)

mod.disp <- glm.poisson.disp(mod)
summary(mod.disp)
mod.disp$dispersion

# compute predictions on a grid of x-values...
x0 <- seq(min(x), max(x), length=50) 
eta0 <- predict(mod, newdata=data.frame(log.x10=log(x0+10), x=x0), se=TRUE)
eta0.disp <- predict(mod.disp, newdata=data.frame(log.x10=log(x0+10), x=x0), se=TRUE)
# ... and plot the mean functions with variability bands
plot(x, y)
lines(x0, exp(eta0$fit))
lines(x0, exp(eta0$fit+2*eta0$se), lty=2)
lines(x0, exp(eta0$fit-2*eta0$se), lty=2)
lines(x0, exp(eta0.disp$fit), col=2)
lines(x0, exp(eta0.disp$fit+2*eta0.disp$se), lty=2, col=2)
lines(x0, exp(eta0.disp$fit-2*eta0.disp$se), lty=2, col=2)

##--  Holford's data

data(holford)
attach(holford)

mod <- glm(incid ~ offset(log(pop)) + Age + Cohort, family=poisson(log)) 
summary(mod)

mod.disp <- glm.poisson.disp(mod)
summary(mod.disp)
mod.disp$dispersion
}
\keyword{models}
\keyword{regression}
