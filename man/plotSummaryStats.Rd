% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotSummaryStats.R
\name{plotSummaryStats}
\alias{plotSummaryStats}
\title{Plot summary statistics for a GInteractions object}
\usage{
plotSummaryStats(GIObject, other = 5, cut = 10)
}
\arguments{
\item{GIObject}{A GInteractions object}

\item{other}{Default 5. Passed to plotInteractionAnnotations. Interaction types making up fewer than 'other' percent of the total interactions will be consolidated into a single 'other' category.}

\item{cut}{Default 10. Passed to plotCounts.All interactions with counts > cut are consolidated into a single category.}
}
\value{
invisible(1)
}
\description{
Makes summary plots of the counts, interaction distances, interaction
annotations, and percentage of cis and trans interactions for a
GInteractions object using `plotCounts`, `plotDists`, `plotCisTrans`,
and `plotInteractionAnnotations`.
}
\examples{
data(hic_example_data)
plotSummaryStats(hic_example_data)
}
