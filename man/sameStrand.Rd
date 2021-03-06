% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processing.R
\name{sameStrand}
\alias{sameStrand}
\title{Tests whether anchors have the same strand.}
\usage{
sameStrand(GIObject)
}
\arguments{
\item{GIObject}{A GInteractions object}
}
\value{
A logical vector denoting with TRUE if both anchors of an interaction
 are on the same strand and FALSE otherwise.
}
\description{
This is designed for processing .bam files.
}
