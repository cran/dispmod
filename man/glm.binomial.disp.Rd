\name{glm.binomial.disp}
\alias{glm.binomial.disp}
\title{Overdispersed binomial logit models.}
\description{This function estimates overdispersed binomial logit models using the approach discussed by Williams (1982).}
\usage{
glm.binomial.disp(object, maxit = 30, verbose = TRUE)
}
\arguments{
\item{object}{an object of class `"glm"' providing a fitted binomial logistic regression model.}
\item{maxit}{integer giving the maximal number of iterations for the model fitting procedure.}
\item{verbose}{logical, if \code{TRUE} information are printed during each step of the algorithm.}
}
\details{
Extra-binomial variation in logistic linear models is discussed, among others, in Collett (1991). Williams (1982) proposed a quasi-likelihood approach for handling overdispersion in logistic regression models. 

Suppose we observe the number of successes \eqn{y_i} in \eqn{m_i} trials, for \eqn{i=1,\ldots,n}, such that 
\deqn{y_i|p_i \sim \mathrm{Binomial}(m_i, p_i)}{y_i|p_i ~ Binomial(m_i, p_i)}
\deqn{p_i \sim \mathrm{Beta}(\gamma, \delta)}{p_i ~ Beta(\gamma, \delta)}
Under this model, each of the \eqn{n} binomials has a different probability of success \eqn{p_i}, where \eqn{p_i} is a random draw from a beta distribution. Thus,
\deqn{E(p_i) = \frac{\gamma}{\gamma+\delta} = \theta}{E(p_i) = \gamma/(\gamma+\delta) = \theta}
\deqn{Var(p_i) = \phi\theta(1-\theta)}{Var(p_i) = \phi*\theta*(1-\theta)}
Assume \eqn{\gamma > 1} and \eqn{\delta > 1}, so that the beta density is equal to zero at both zero and one, and thus \eqn{0 < \phi \le 1/3}{0 < \phi <= 1/3}. From this, the unconditional mean and variance can be calculated:
\deqn{E(y_i) = m_i\theta}{E(y_i) = m_i*\theta}
\deqn{Var(y_i) = m_i\theta(1-\theta)(1+(m_i-1)\phi)}{Var(y_i) = m_i*\theta*(1-\theta)*(1+(m_i-1)*\phi)}
so unless \eqn{m_i=1} or \eqn{\phi=0}, the unconditional variance of \eqn{y_i} is larger than binomial variance.

Identical expressions for the mean and variance of \eqn{y_i} can be obtained if we assume that the $m_i$ counts on the i-th unit are dependent, with the same correlation \eqn{\phi}. In this case, \eqn{-1/(m_i-1) < \phi \le 1}{-1/(m_i-1) < \phi <= 1}.

The method proposed by Williams uses an iterative algorithm for estimating the dispersion parameter \eqn{\phi} and hence the necessary weights \eqn{1/(1+\phi(m_i-1))}{1/(1+\phi*(\mu_i - 1))} (for details see Williams, 1982).
}
}
\value{
The function returns an object of class `"glm"' with the usual information (see \code{help(glm)}) and the added components:   
\item{dispersion}{the estimated dispersion parameter.}
\item{disp.weights}{the final weights used to fit the model.}
}
\references{
Collett, D. (1991), \emph{Modelling Binary Data}, London: Chapman and Hall.

Williams, D. A. (1982), Extra-binomial variation in logistic linear models, 
\emph{Applied Statistics}, \bold{31}, 144--148.
}
\author{Luca Scrucca, \email{luca@stat.unipg.it}}
\note{Based on a similar procedure available in Arc (Cook and Weisberg, \url{http://www.stat.umn.edu/arc})}
\seealso{
\code{\link{lm}}, \code{\link{glm}}, \code{\link{lm.disp}}, \code{\link{glm.poisson.disp}}
}
\examples{
data(orobanche)
attach(orobanche)
h <- factor(host)
v <- factor(variety, levels=c("O.a75", "O.a73"))

mod <- glm(cbind(germinated, seeds-germinated) ~ h + v + h*v, family=binomial(logit))
summary(mod)

mod.disp <- glm.binomial.disp(mod)
summary(mod.disp)
mod.disp$dispersion
}
\keyword{models}
\keyword{regression}
