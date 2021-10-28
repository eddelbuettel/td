
.refindicesurl <- "https://api.twelvedata.com/indices"

##' Retrieve Reference Data for Indices from \sQuote{twelvedata}
##'
##' \code{ref_indices}.
##' @title Reference Data Accessor for Indices from \sQuote{twelvedata}
##' @param sym (optional, character)  A (single or vector) symbol for Indices. Defaults to unset.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param country (optional, character)  An alpha code or country name. Defaults to unset.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_indices <- function(sym = "",
                    as = c("data.frame", "raw"),
                    country = "",
                    apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)

  qry <- paste0(.refindicesurl, "?",
                "&apikey=", apikey)
  if (sym[1] != "") qry <- paste0(qry, "&symbol=", sym)
  if (country != "") qry <- paste0(qry, "&country=", country)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  if(length(qry) == 1) res <- list(res)

  names(res) <- seq_along(res)
  dat <- lapply(res, function(x){
    if(x$status != "ok") stop(x$message, call. = FALSE)
    dat <- x$data
    dat
  })
  dat <- do.call("rbind", dat)

  if(is.null(dat)) stop("API returned NULL data. Try to change your query.", call. = FALSE)

  attr(dat, which = "accessed") <- accessed

  dat
}
