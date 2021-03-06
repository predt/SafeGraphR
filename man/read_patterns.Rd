% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_patterns.R
\name{read_patterns}
\alias{read_patterns}
\title{Read Safegraph Patterns}
\usage{
read_patterns(
  filename,
  dir = ".",
  by = NULL,
  fun = sum,
  na.rm = TRUE,
  filter = NULL,
  expand_int = NULL,
  expand_cat = NULL,
  expand_name = NULL,
  multi = NULL,
  naics_link = NULL,
  select = NULL,
  gen_fips = TRUE,
  start_date = NULL,
  silent = FALSE,
  ...
)
}
\arguments{
\item{filename}{The filename of the \code{.csv.gz} file.}

\item{dir}{The directory in which the file sits.}

\item{by}{A character vector giving the variable names of the level to be collapsed to using \code{sum(na.rm=TRUE)}. The resulting data will have X rows per unique combination of \code{by}, where X is 1 if no expand variables are specified, or the length of the expand variable if specified. Set to \code{NULL} to aggregate across all initial rows, or set to \code{FALSE} to not aggregate at all (this will also add an \code{initial_rowno} column showing the original row number).}

\item{fun}{Function to use to aggregate the expanded variable to the \code{by} level.}

\item{na.rm}{Whether to remove any missing values of the expanded before aggregating.}

\item{filter}{A character string describing a logical statement for filtering the data, for example \code{filter = 'state_fips == 6'} would give you only data from California. Will be used as an \code{i} argument in a \code{data.table}, see \code{help(data.table)}. Filtering here instead of afterwards can cut down on time and memory demands.}

\item{expand_int}{A character variable with the name of The first e JSON variable in integer format ([1,2,3,...]) to be expanded into rows. Cannot be specified along with \code{expand_cat}.}

\item{expand_cat}{A JSON variable in categorical format ({A: 2, B: 3, etc.}) to be expanded into rows.  Ignored if \code{expand_int} is specified.}

\item{expand_name}{The name of the new variable to be created with the category index for the expanded variable.}

\item{multi}{A list of named lists, for the purposes of creating a list of multiple processed files. This will vastly speed up processing over doing each of them one at a time. Each named list has the entry \code{name} as well as any of the options \code{by, fun, filter, expand_int, expand_cat, expand_name} as specified above. If specified, will override other entries of \code{by}, etc..}

\item{naics_link}{A \code{data.table}, possibly produced by \code{link_poi_naics}, that links \code{safegraph_place_id} and \code{naics_code}. This will allow you to include \code{'naics_code'} in the \code{by} argument. Technically you could have stuff other than \code{naics_code} in here and use that in \code{by} too, I won't stop ya.}

\item{select}{Character vector of variables to get from the file. Set to \code{NULL} to get all variables.}

\item{gen_fips}{Set to \code{TRUE} to use the \code{poi_cbg} variable to generate \code{state_fips} and \code{county_fips} variables. This will also result in \code{poi_cbg} being converted to character.}

\item{start_date}{The first date in the file, as a date object. If omitted, will assume that the filename begins YYYY-MM-DD.}

\item{silent}{Set to TRUE to suppress timecode message.}

\item{...}{Other arguments to be passed to \code{data.table::fread} when reading in the file. For example, \code{nrows} to only read in a certain number of rows.}
}
\description{
Be aware that the files this is designed to work with are large and this function may take a while to execute. This function takes a single \code{.csv.gz} SafeGraph patterns file and reads it in. The output is a \code{data.table} (or a list of them if multiple are specified) including the file \code{filename} collapsed and expanded in different ways.
}
\details{
Note that after reading in data, if \code{gen_fips = TRUE}, state and county names can be merged in using \code{data(fips_to_names)}.
}
