
.refetfurl <- "https://api.twelvedata.com/etf"

##' Retrieve Reference Data for ETFs from \sQuote{twelvedata}
##'
##' \code{ref_etf}.
##' @title Reference Data Accessor for ETFs from \sQuote{twelvedata}
##' @param sym (optional, character)  A (single or vector) symbol for ETFs. Defaults to unset.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_etf <- function(sym = "",
                    as = c("data.frame", "raw"),
                    apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)

  qry <- paste0(.refetfurl, "?",
                "&apikey=", apikey)
  if (sym[1] != "") qry <- paste0(qry, "&symbol=", sym)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  if(length(sym) == 1) res <- list(res)

  names(res) <- sym
  dat <- lapply(res, function(x){
    if(x$status != "ok") stop(x$message, call. = FALSE)
    dat <- x$data
    dat
  })
  dat <- do.call("rbind", dat)

  if(is.null(dat)) stop("The API returned NULL. Try to change your query.")

  attr(dat, which = "accessed") <- accessed

  dat
}
