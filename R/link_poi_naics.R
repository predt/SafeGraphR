#' Use a Core Places file to Create a POI-NAICS crosswalk
#'
#' Feed this function the most recent Core Places file, and it will give you back a \code{data.table} with two columns: \code{safegraph_place_id} and \code{naics_code}. Saving this file is recommended. Then, provide this object to \code{read_shop} or \code{read_many_shop} so that you can use \code{'naics_code'} in the \code{by} argument.
#'
#' @param filename The filename of the \code{ZIP} Core Places file.
#' @param dir The directory that the file is in.
#' @param exdir Name of the directory to unzip to.
#' @param cleanup Set to \code{TRUE} to delete all the unzipped files after being read in.
#' @param silent Suppress timing messages.
#' @export

link_poi_naics <- function(filename, dir = '.', exdir = dir, cleanup = TRUE, silent = FALSE) {

  # Where's our zip?
  if (!(stringr::str_sub(dir,nchar(dir)) == '/')) {
    dir <- paste0(dir,'/')

  }
  f <- paste0(dir,filename)

  # Get the list of files
  files_in_zip <- utils::unzip(f,list=TRUE)$Name
  # Only the .csv.gzs count
  files_in_zip <- files_in_zip[grep('\\.csv\\.gz',files_in_zip)]
  # And unzip
  utils::unzip(f, files = files_in_zip, exdir = exdir)

  files_in_zip %>%
    paste0(dir,.) %>%
    purrr:map(function(x) {
      if (!silent) {
        message(paste('Starting to read',x,'at',Sys.time()))
      }
      patterns <- fread(x, select = c('safegraph_place_id',
                                      'naics_code'))
      patterns <- patterns[!is.na(naics_code)]
      file.remove(x)
      return(patterns)
    }) %>%
    rbindlist() %>%
    unique() %>%
    return()

}
