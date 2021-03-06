#' Pull state and county FIPS from CBG code
#'
#' This function takes a CBG code (as numeric or string) and returns the state and county FIPS codes associated with it.
#'
#' Why a list and not a vector? For \code{data.table} usage.
#'
#' @param cbg CBG code, in numeric or string form.
#' @param return Set to 'state' to get back only state FIPS, 'county' for only county, or 'both' for a list of both (state then county).
#' @export

fips_from_cbg <- function(cbg,return='both') {
  # work with string because we use nchar
  cbg <- as.character(cbg)

  # length of cbg string depends on whether it's a one-digit state fips or two
  onedigitfips <- (nchar(cbg) == 11)

  state <- as.numeric(stringr::str_sub(cbg,1,2 - onedigitfips))
  county <- as.numeric(stringr::str_sub(cbg,3 - onedigitfips,
                             5 - onedigitfips))

  if (return == 'both') {
    return(list(state,county))
  } else if (return == 'state') {
    return(state)
  } else if (return == 'county') {
    return(county)
  } else {
    stop('Invalid return option.')
  }
}


#' Row-binds data.tables in a list of lists
#'
#' This function takes a list of lists of \code{data.table}s, and then row-binds them by position or name. For example, if passed \code{list(list(first=A,second=B),list(first=C,second=D))}, you would get back \code{list(first=rbind(A,C),second=rbind(B,D))}.
#'
#' @param dtl List of lists of \code{data.table}s.
#' @param ignore_names If the list is named, match objects across lists only by their position in the list and not by their names.
#' @export

rbind_by_list_pos <- function(dtl,ignore_names=FALSE) {

  # How many tables are we binding
  ntabs <- length(dtl[[1]])

  retDT <- list()

  # If we go by position
  if (ignore_names | is.null(names(dtl[[1]]))) {
    for (i in 1:ntabs) {
      retDT[[i]] <- dtl %>%
        purrr::map(function(x) x[[i]]) %>%
        data.table::rbindlist()
    }
  } else {
    for (n in names(dtl[[1]])) {
      retDT[[n]] <- dtl %>%
        purrr::map(function(x) x[[n]]) %>%
        data.table::rbindlist()
    }
  }

  return(retDT)
}


#' Seven-Day Moving Average
#'
#' This function returns a (by default) seven-day moving average of the variable passed in. Make sure the data is pre-sorted by date, and grouped by the appropriate grouping. The data should have no gaps in time.
#'
#' @param x The variable to calculate the moving average of.
#' @param n The number of lags to cover in the moving average.
#' @export
ma <- function(x,n=7){
  if(length(x) >= 7) {
    return(as.numeric(stats::filter(as.ts(x),rep(1/n,n), sides=1)))
  }
  return(NA_real_)
}
