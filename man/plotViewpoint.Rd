% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/viewPoints.R
\name{plotViewpoint}
\alias{plotViewpoint}
\title{Plot coverage around a virtual 4C viewpoint}
\usage{
plotViewpoint(x, region, ylab = "Signal", xlab = NULL, ...)
}
\arguments{
\item{x}{a GInteractions object which is output from viewPoint}

\item{region}{The genomic region to plot}

\item{ylab}{Y axis label.}

\item{xlab}{X axis label. By default this is the chromosome of the region 
that is being plotted.}

\item{...}{additional arguments to plot}
}
\value{
Coverage that is plotted (invisibly)
}
\description{
Plots coverage of interactions around a given viewpoint. This function requires 
the output of `viewPoint()` as input. You should additionally specify the total 
region you wish to plot.
}
\examples{
data(hic_example_data)
library(GenomicRanges)
pos <- GRanges(seqnames='chr15', ranges=IRanges(start=59477709, end=59482708))
region <- GRanges(seqnames='chr15', ranges=IRanges(start=58980209, end=59980208))
vp <- viewPoint(hic_example_data, pos, region)
plotViewpoint(vp, region)

}
