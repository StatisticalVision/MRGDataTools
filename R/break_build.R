#' Break apart a long table and rebuild into a wide table
#'
#' \code{break_build} is a function that creates a wide-form table from a long-form table, similar
#' to \code{reshape}. A data table is broken into multiple sub-tables based on the unique values in
#' the specified BCol. These sub-tables are then merged together (by the IDCols) to create a
#' wide-form table.  If there is one ValCol, then that column is given the name of the entries
#' that generate that subtable. If there are multiple ValCols, then each ValCol is given a name prefixed
#' by the name of the entries that generate that subtable.
#'
#' This function does not work if the unique values of BCol cannot be column names (i.e. numbers).
#'
#' @param df a datatable
#' @param BCol the name of the break column
#' @param IDCols the names of columns that identify a row
#' @param ValCols the names columns that hold measurements
#' @return A table where ncol(table) = length(IDCols) +length(unique(BCol))*length(ValCols)
#' @examples
#' require(data.table)
#' sizes<-data.table(ID1=c("A","A","B","B","C","D","D","E"),
#'                   ID2=c(1,1,2,2,3,4,4,5),
#'                   measurement=c("height","width","height","width","height","height","weight","height"),
#'                   value1=c(72,36,70,34,60,64,180,64),
#'                   value2=c("80%","74%","70%","60%","40%","45%","65%","40%"))
#' wide_sizes<-break_build(sizes,IDCols = c("ID1","ID2"),BCol = "measurement",ValCols = c("value1","value2"))
#'
#' @seealso
#' \code{\link[data.table]{dcast}}
#' \code{\link[data.table]{melt}}
#' @export
break_build <- function (df,BCol,IDCols,ValCols) {
  setkeyv(df,BCol)
  #Scan the column for unique entries.  (For each entry, we will generate a sub-table.)
  NewCols <- unique(df[[BCol]]);
  if(NA %in% NewCols){
    warning("BCol contains NA, removing that category, rows will be lost.")
    NewCols <- NewCols[!is.na(NewCols)]
  }
  #An empty list that will hold a data table for each break.
  ldt <- list();
  #List of columns the information in which need to be in every sub-table.
  ColList <-c(IDCols,ValCols)

  for (bframe in NewCols) {
    #Create and store a subtable for a unique entry in bcol.
    ldt[[bframe]] = df[bframe,ColList, with=FALSE]
    #Create syntactically valid names
    prefixed <- make.names(paste(bframe,ValCols,sep="."))
    oneName <- make.names(bframe)
    #Prefix the Value columns with the name of the break, unless there is only one ValCol.
    if(length(ValCols)>1){setnames(ldt[[bframe]], ValCols, prefixed)
      } else {setnames(ldt[[bframe]], ValCols, oneName)}
  }
  #Recursively merge all the subtables together.
  Build<-Reduce(function(...) merge(...,by=IDCols,all=T),ldt)
  return(Build)
}

