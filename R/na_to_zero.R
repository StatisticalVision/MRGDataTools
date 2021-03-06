#' Turn NAs in a datatable to zero
#'
#' This function works on the data.table in place.
#'
#' @param DT a data table passed by reference.
#' @param excluded a character vector of column names to exclude -all others included.
#' @param included a character vector of column names to include -all others excluded
#' @return No return value.  The data table is changed in place.

na_to_zero = function(DT, excluded=NULL,included=NULL) {
  if(is.null(excluded)&is.null(included)){
    for (j in seq_len(ncol(DT))) {
      set(DT,which(is.na(DT[[j]])),j,0)
    }
  } else if(is.null(excluded)&!is.null(included)){
    for(j in included) {
      set(DT,which(is.na(DT[[j]])),j,0)
    }
  } else if(!is.null(excluded)&is.null(included)){
    dtNames <- names(DT)
    included <- setdiff(dtNames,excluded)
    for(j in included) {
      set(DT,which(is.na(DT[[j]])),j,0)
    }
  }
}

