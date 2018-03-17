\name{lm.disp}
\alias{lm.disp}
\alias{summary.dispmod}
\alias{print.summary.dispmod}

\title{Gaussian dispersion models}

\description{This function estimates Gaussian dispersion regression models.}
\usage{
lm.disp(formula, var.formula, data = list(), maxit = 30, 
        epsilon = glm.control()$epsilon, subset, na.action = na.omit, 
        contrasts = NULL, offset = NULL)
}
\arguments{
\item{formula}{a symbolic description of the mean function of the model to be fit. For the details of model formula specification see \code{\link{lm}} and \code{\link{formula}}.}
\item{var.formula}{a symbolic description of the variance function of the model to be fit. This must be a one-sided formula; if omitted the same terms used for the mean function are used. For the details of model formula specification see \code{\link{lm}} and \code{\link{formula}}.}
\item{data}{an optional data frame containing the variables in the model. By default the variables are taken from \code{environment(formula)}, typically the environment from which the function is called.}
\item{maxit}{integer giving the maximal number of iterations for the model fitting procedure.}
\item{epsilon}{tolerance value for checking convergence. See \code{\link{glm.control}}.}
\item{subset}{an optional vector specifying a subset of observations to be used in the fitting process.}
\item{na.action}{a function which indicates what should happen when the data contain \code{NA}'s. By default is set to \code{na.omit}, but other possibilities are available; see \code{\link{na.omit}}.}
\item{contrasts}{an optional list as described in the \code{contrasts.arg} argument of \code{\link{model.matrix.default}}.}
\item{offset}{this can be used to specify an a priori known component to be included in the linear predictor during fitting.  An \code{offset} term can be included in the formula instead or as well, and if both are specified their sum is used.}
}
\details{
Gaussian dispersion models allow to model variance heterogeneity in Gaussian regression analysis using a log-linear model for the variance. 

Suppose a response \eqn{y} is modelled as a function of a set of \eqn{p} predictors \eqn{x} through the linear model

\deqn{y_i = \beta'x_i + e_i}

where \eqn{e_i \sim N(0, \sigma^2)}{e_i ~ N(0, \sigma^2)} under homogeneity. 

Variance heterogeneity is modelled as

\deqn{V(e_i) = \sigma^2 = \exp(\lambda'z_i)}{V(e_i) = \sigma^2 = exp(\lambda'z_i)}

where \eqn{z_i} may contain some or all the variables in \eqn{x_i} and other variables not included in \eqn{x_i}; \eqn{z_i} is however assumed to contain a constant term.

The full model can be expressed as

\deqn{E(y|x) = \beta'x}
\deqn{V(y|x) = \exp(\lambda'z)}{V(y|x) = exp(\lambda'z)}

and it is fitted by maximum likelihood following the algorithm described in Aitkin (1987).
}

\value{
\code{lm.dispmod()} returns an object of class \code{"dispmod"}.

The \code{summary} method can be used to obtain and print a summary of the results.  

An object of class \code{"dispmod"} is a list containing the following components:

\item{call}{the matched call.}
\item{mean}{an object of class \code{"glm"} giving the fitted model for the mean function; see \code{\link{glm}}}
\item{var}{an object of class \code{"glm"} giving the fitted model for the variance function; see \code{\link{glm}}.}
\item{initial.deviance}{the value of the deviance at the beginning of the iterative procedure, i.e. assuming constant variance.}
\item{deviance}{the value of the deviance at the end of the iterative procedure.}
}
\references{
Aitkin, M. (1987), Modelling variance heterogeneity in normal regression models using GLIM, \emph{Applied Statistics}, 36, 332--339.
}
\note{Based on a similar procedure available in Arc (Cook and Weisberg, \url{http://www.stat.umn.edu/arc})}
\seealso{
\code{\link{lm}}, \code{\link{glm}}, \code{\link{glm.binomial.disp}}, \code{\link{glm.poisson.disp}}, \code{\link[car]{ncvTest}}.
}
\examples{
data(minitab)
minitab <- within(minitab, y <- V^(1/3) )
mod <- lm(y ~ H + D, data = minitab)
summary(mod)

mod.disp1 <- lm.disp(y ~ H + D, data = minitab)
summary(mod.disp1)

mod.disp2 <- lm.disp(y ~ H + D, ~ H, data = minitab)
summary(mod.disp2)

# Likelihood ratio test
deviances <- c(mod.disp1$initial.deviance,
               mod.disp2$deviance, 
               mod.disp1$deviance)
lrt <- c(NA, abs(diff(deviances)))
cbind(deviances, lrt, p.value = 1-pchisq(lrt, 1))

# quadratic dispersion model on D (as discussed by Aitkin)
mod.disp4 <- lm.disp(y ~ H + D, ~ D + I(D^2), data = minitab)
summary(mod.disp4)

r <- mod$residuals
phi.est <- mod.disp4$var$fitted.values
plot(minitab$D, log(r^2))
lines(minitab$D, log(phi.est))
}

\keyword{models}
\keyword{regression}
