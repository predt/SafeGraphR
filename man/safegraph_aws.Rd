% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/safegraph_aws.R
\name{safegraph_aws}
\alias{safegraph_aws}
\title{Download SafeGraph data from AWS COVID Response}
\usage{
safegraph_aws(
  path = ".",
  patterns,
  bucket_only = FALSE,
  key,
  secret,
  region = "us-west-2",
  prefix = "",
  ...
)
}
\arguments{
\item{path}{The local directory to synchronize.}

\item{patterns}{The SafeGraph bucket to get from. Can be "weekly", "monthly", "distancing", "core", or, to get the baseline bucket, "none". v2 versions always selected.}

\item{bucket_only}{Instead of doing an \code{aws.s3::s3sync} call, just return the correct bucket as a string. Then you can use that to do your own \code{aws.s3::s3sync} call.}

\item{key}{A character string containing an AWS Access Key ID.}

\item{secret}{A character string containing an AWS Secret Access Key.}

\item{region}{A character string containing the AWS region.}

\item{prefix}{Leading part of the objects in the bucket must have this prefix. For example, to download social distancing data only from 2020, set this to "2020/".}

\item{...}{Additional parameters to be sent to \code{aws.s3::s3sync} and from there on to \code{aws.s3:s3HTTP}. "direction" will be ignored.}
}
\description{
This is a thin wrapper for \code{aws.s3::s3sync} that will aim you at the right directory to synchronize.
}
\details{
This function doesn't add too much, but it does make the default behavior you probably want a bit easier. If you plan to specify the \code{s3sync::aws.s3} "bucket" option yourself, this function is largely useless.
}
