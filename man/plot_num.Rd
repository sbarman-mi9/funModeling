% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/numbers.R
\name{plot_num}
\alias{plot_num}
\title{Plotting numerical data}
\usage{
plot_num(data, bins = 10)
}
\arguments{
\item{data}{data frame}

\item{bins}{number of bar to plot each histogram, 10 by default}
}
\value{
plot containing all numerical variables
}
\description{
One plot containing all the numerical variables distribution
}
\examples{
plot_num(mtcars)
}

