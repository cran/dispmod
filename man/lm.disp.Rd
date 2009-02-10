\name{lm.disp}
\alias{lm.disp}
\alias{summary.dispmod}
\title{Normal dispersion models.}
\description{This function estimates normal dispersion regression models.}
\usage{
lm.disp(formula, var.formula, data = list(), maxit = 30, 
        epsilon = glm.control()$epsilon, subset, na.action = na.omit, 
        contrasts = NULL, offset = NULL)
}
\arguments{
\item{formula}{a symbolic description of the mean function of the model to be fit. For the details of model formula specification see \code{help(lm)} and \code{help(formula)}.}
\item{var.formula}{a symbolic description of the variance function of the model to be fit. This must be a one-sided formula; if omitted the same terms used for the mean function are used. For the details of model formula specification see \code{help(lm)} and \code{help(formula)}.}
\item{data}{an optional data frame containing the variables in the model. By default the variables are taken from `environment(formula)', typically the environment from which the function is called.}
\item{maxit}{integer giving the maximal number of iterations for the model fitting procedure.}
\item{epsilon}{positive convergence tolerance epsilon; the procedure converge when |dev - devold| < epsilon.}
\item{subset}{an optional vector specifying a subset of observations to be used in the fitting process.}
\item{na.action}{a function which indicates what should happen when the data contain `NA's.  The default is set by the `na.action' setting of `options', and is `na.fail' if that is unset. The default is `na.omit'.}
\item{contrasts}{an optional list. See the `contrasts.arg' of `model.matrix.default'.}
\item{offset}{this can be used to specify an a priori known component to be included in the linear predictor during fitting.  An `offset' term can be included in the formula instead or as well, and if both are specified their sum is used.}
}
\details{
Normal dispersion models allow to model variance heterogeneity in normal regression analysis using a log-linear model for the variance. 

Suppose a response \eqn{y} is modelled as a function of a set of \eqn{p} predictors \eqn{x} through the linear model
\deqn{y_i = \beta'x_i + e_i}
where 
\eqn{e_i \sim N(0,\sigma^2)}{e_i ~ N(0, \sigma^2)} 
under homogeneity. Variance heterogeneity is expressed as
\deqn{Var(e_i) = \sigma^2 = \exp(\lambda'z_i)}
where \eqn{z_i} may contain some or all the variables in \eqn{x_i} and other variables not included in \eqn{x_i}; \eqn{z_i} is however assumed to contain a constant term.
This model can be re-expressed also as
\deqn{E(y|x) = \beta'x}
\deqn{Var(y|x) = \exp(\lambda'z)}
and is fitted by maximum likelihood following the algorithm described in Aitkin (1987).
}

\value{
`lm.dispmod' returns an object of `class' `"dispmod"'.

The function `summary' is used to obtain and print a summary of the results.  

An object of class `"lm.dispmod"' is a list containing the following components:

\item{call}{the matched call.}
\item{mean}{an object of class `"glm"' giving the fitted model for the mean function.}
\item{var}{an object of class `"glm"' giving the fitted model for the variance function.}
\item{initial.deviance}{the value of the deviance at the beginning of the iterative procedure, i.e. assuming constant variance.}
\item{deviance}{the value of the deviance at the end of the iterative procedure.}
}
\references{
Aitkin, M. (1987), Modelling variance heterogeneity in normal regression models using GLIM, \emph{Applied Statistics}, \bold{36}, 332--339.
}
\author{Luca Scrucca, \email{luca@stat.unipg.it}}
\note{Based on a similar procedure available in Arc (Cook and Weisberg, \url{http://www.stat.umn.edu/arc})}
\seealso{
\code{\link{lm}}, \code{\link{glm}}, \code{\link{glm.binomial.disp}}, \code{\link{glm.poisson.disp}}, \code{\link[car]{ncv.test}} (in the \code{car} library).
}
\examples{
data(minitab)
attach(minitab)

y <- V^(1/3)
summary(mod <- lm(y ~ H + D))

summary(mod.disp1 <- lm.disp(y ~ H + D))
summary(mod.disp2 <- lm.disp(y ~ H + D, ~ H))

# Likelihood ratio test
deviances <- c(mod.disp1$initial.deviance, mod.disp2$deviance, mod.disp1$deviance)
lrt <- c(NA, abs(diff(deviances)))
cbind(deviances, lrt, p.value=1-pchisq(lrt, 1))

# quadratic dispersion model on D (as discussed by Aitkin)
summary(mod.disp4 <- lm.disp(y ~ H + D, ~ D + I(D^2)))
r <- mod$residuals
plot(D, log(r^2))
phi.est <- mod.disp4$var$fitted.values
lines(D, log(phi.est))
}
\keyword{models}
\keyword{regression}
