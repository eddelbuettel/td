
.refsymbolsearchurl <- "https://api.twelvedata.com/symbol_search"

##' Retrieve Reference Data for Symbol Search from \sQuote{twelvedata}
##'
##' \code{ref_symbol_search}.
##' @title Reference Data Accessor for Symbol Search from \sQuote{twelvedata}
##' @param sym (required, character) Symbol to search for.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param output_size (required, character) Defaults to 30. Max is 120.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_symbol_search <- function(sym,
                              as = c("data.frame", "raw"),
                              output_size = 30,
                              apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)

  if(output_size > 120) stop("Max output size is 120.", call. = FALSE)

  qry <- paste0(.refsymbolsearchurl, "?",
                "&apikey=", apikey)

  qry <- paste0(qry, "&symbol=", sym)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  res <- list(res)

  dat <- lapply(res, function(x){
    if(x$status != "ok") stop(x$message, call. = FALSE)
    dat <- x$data
    dat
  })
  dat <- do.call("rbind", dat)

  if(is.null(dat)) stop("The API returned NULL data.", call. = FALSE)

  attr(dat, which = "accessed") <- accessed

  dat
}
