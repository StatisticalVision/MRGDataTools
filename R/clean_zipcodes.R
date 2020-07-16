#' This function attempts to detect and clean up suspected ZIP codes. Will strip "ZIP+4" suffixes to
#' match format of zipcode data.frame. Restores leading zeros, converts invalid entries to NAs, and
#' returns character vector. Note that this function does not attempt to find a matching ZIP code in
#' the database, but rather examines formatting alone
#'
#' @param zips character vector of suspect entries
#' @return character vector containing cleaned ZIP codes with NAs for non-conforming entries


clean.zipcodes = function(zips) {
  zips = as.character(zips)
  zips = gsub("\\s", "", zips)
  zips = gsub("^([0-9]+)-[0-9]+", "\\1", zips)
  zips[grepl("[^0-9]", zips)] = NA
  zips[grepl("^$", zips)] = NA
  zips = gsub("^([0-9]{3})$", "00\\1", zips)
  zips = gsub("^([0-9]{4})$", "0\\1", zips)
  return(zips)
}
