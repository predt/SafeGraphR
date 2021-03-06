#' Expand and collapse an integer JSON column
#'
#' This function accepts a \code{data.table} along with a set of grouping variables and a character-format integer-style JSON column (i.e. starts with square brackets, not curly).
#'
#' It expands that JSON column into long format, with one row per observation per value of the JSON column, and then collapses everything according to the set of grouping variables.
#'
#' @param dt data.table object
#' @param expand String indicating the JSON column to be expanded.
#' @param index String indicating the name of the new index column
#' @param by Character vector indicating the variables to group by after expanding. Set to \code{NULL} to aggregate across all initial rows, or set to \code{FALSE} to not aggregate at all (this will also add an \code{initial_rowno} column showing the original row number).
#' @param fun Function that takes a vector and returns a single value to use when collapsing to the \code{by} level.
#' @param na.rm Ignore missing values of \code{expand}
#' @param set_key Set the key of \code{dt} to \code{by}. Set to \code{FALSE} if you have already set the key or want it returned without key.
#' @export

expand_integer_json <- function(dt, expand,
                                index = 'index', by = NULL,
                                fun = sum, na.rm = TRUE, set_key = TRUE) {

  if (is.logical(by)) {
    set_key <- FALSE
  }

  if (set_key) {
    setkeyv(dt,by)
  }

  if (na.rm) {
    nmstatement <- paste0('!is.na(',expand,')')
    dt <- dt[eval(parse(text=nmstatement))]
  }

  if (class(by) == 'logical') {
    if (!by) {
      dt[,initial_rowno := 1:(.N)]
      by <- 'initial_rowno'
    }
  }

  # Read with from JSON and add
  exptext <- paste0(".(",expand,"= Reduce('+',purrr::map(",expand,",jsonlite::fromJSON)))")

  dt <- dt[,
     eval(parse(text=exptext)),
     by=by]

  indextext <- paste0(index,':= seq_len(.N)')

  dt[,eval(parse(text=indextext)),by=by]

  return(dt)
}


#' Expand and collapse a categorical JSON column
#'
#' This function accepts a \code{data.table} along with a set of grouping variables and a character-format category-style JSON column (i.e. starts with curly brackets, not square).
#'
#' WARNING: currently does not work properly if different rows have different categories.
#'
#' It expands that JSON column into long format, with one row per observation per value of the JSON column, and then collapses everything according to the set of grouping variables.
#'
#' @param dt data.table object
#' @param expand String indicating the JSON column to be expanded.
#' @param index String indicating the name of the new index column
#' @param by Character vector indicating the variables to group by after expanding. Set to \code{NULL} to aggregate across all initial rows, or set to \code{FALSE} to not aggregate at all (this will also add an \code{initial_rowno} column showing the original row number).
#' @param fun Function that takes a vector and returns a single value to use when collapsing to the \code{by} level.
#' @param na.rm Ignore missing values of \code{expand}
#' @param set_key Set the key of \code{dt} to \code{by}. Set to \code{FALSE} if you have already set the key or want it returned without key.
#' @export

expand_cat_json <- function(dt, expand,
                                index = 'index', by = NULL,
                                fun = sum, na.rm = TRUE, set_key = TRUE) {

  if (is.logical(by)) {
    set_key <- FALSE
  }

  if (set_key) {
    setkeyv(dt,by)
  }

  if (na.rm) {
    nmstatement <- paste0('!is.na(',expand,')')
    dt <- dt[eval(parse(text=nmstatement))]
  }

  if (class(by) == 'logical') {
    if (!by) {
      dt[,initial_rowno := 1:(.N)]
      by <- 'initial_rowno'
    }
  }

  # Strip the double quotes
  dt[,eval(parse(text='expand')) := stringr::str_replace_all(eval(parse(text=expand)), '\\"\\"','\\"')]

  # Read with fromJSON and add
  exptext <- paste0(".(",expand,"= Reduce('+',purrr::map(purrr::map(",
                    expand,",jsonlite::fromJSON),unlist)))")

  # The names
  catnames <- jsonlite::fromJSON(dt[[expand]][1]) %>% unlist() %>% names()

  dt <- dt[,
           eval(parse(text=exptext)),
           by=by]
  dt[,index := catnames, by = by]

  return(dt)
}
