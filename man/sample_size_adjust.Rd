% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample_size_adjust.R
\name{sample_size_adjust}
\alias{sample_size_adjust}
\title{Adjust SafeGraph Data for Sampling Size Differences}
\usage{
sample_size_adjust(
  data,
  from_id = "census_block_group",
  sample_num = "number_devices_residing",
  from_level = "cbg",
  to_level = "county",
  by = NULL,
  pop_data = NULL
)
}
\arguments{
\item{data}{A \code{data.frame} (or \code{tibble} or \code{data.table}) containing (among other things potentially) geographic ID variables and a variable for the number of SafeGraph devices observed in that area. Often this is from a \code{home-panel-summary} file.}

\item{from_id}{A character vector either giving the variable name of the census block group ID, or both the state FIPS and county FIPS variables (which must be numeric, and in state, then county order). Census block group must be specified if \code{from_level='cbg'}.}

\item{from_level}{Either \code{'cbg'} or \code{'county'}, indicating the geographic level that is to be adjusted.}

\item{to_level}{Either \code{'county'} or \code{'state'}, indicating the geographic level that the \code{from_level} components are to be adjusted to, for example \code{from_level='county'} and \code{to_level='state'} wouuld give an adjustment factor for each county as though each county in the state was sampled at the same rate.}

\item{by}{The data returned will be on the \code{from_level} level. Specify other vairables here to have it instead be on the \code{from_level}-\code{by} level, perhaps a timecode. \code{by} should not split the \code{from_level} counts. If, for example, \code{by} is used to split a county in two geographic subcounties, then the population adjustment will not be correct.}

\item{pop_data}{If a populatinon data file other than \code{data(cbg_pop)} or \code{data(county_pop)} should be used, enter it here. Should be in the same format, and with the same variable names, as \code{cbg_pop} if \code{from_level='cbg'}, or the same as \code{county_pop} if \code{from_level='county'}.}

\item{sample_id}{A character variable giving the variable name of the variable in \code{data} that has the number of SafeGraph observations.}
}
\description{
This function uses 2016 American Community Survey data to adjust SafeGraph counts for the portion of the population that is sampled. This function will return a \code{data.table} with two columns: a geographic ID and the variable \code{adjust_factor}, which you can merge into your data and then multiply whatever count variables you like by \code{adjust_factor} adjust them for sampling differences.
}
