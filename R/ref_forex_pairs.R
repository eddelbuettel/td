
.refforexpairsurl <- "https://api.twelvedata.com/forex_pairs"

##' Retrieve Reference Data for Forex Pairs from \sQuote{twelvedata}
##'
##' \code{ref_forex_pairs}.
##' @title Reference Data Accessor for Forex Pairs from \sQuote{twelvedata}
##' @param sym (optional, character)  A (single or vector) currency pair according to ISO 4217 standard codes with slash(/) delimiter.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param currency_base (optional, character) Base currency name. Default value is unset.
##' @param currency_quote (optional, character) Quote currency name. Default value is unset.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_forex_pairs <- function(sym = "",
                            as = c("data.frame", "raw"),
                            currency_base = "",
                            currency_quote = "",
                            apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)

  qry <- paste0(.refforexpairsurl, "?",
                "&apikey=", apikey)
  if (sym[1] != "") qry <- paste0(qry, "&symbol=", sym)
  if (currency_base != "") qry <- paste0(qry, "&currency_base=", currency_base)
  if (currency_quote != "") qry <- paste0(qry, "&currency_quote=", currency_quote)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  if(length(qry) == 1) res <- list(res)

  names(res) <- sym
  dat <- lapply(res, function(x){
    if(x$status != "ok") stop(x$message, call. = FALSE)
    if(is.null(x$data)) warning("A query returned NULL data.", call. = FALSE)
    dat <- x$data
    dat
  })
  dat <- do.call("rbind", dat)

  if(is.null(dat)) stop("The API returned NULL. Try to change your query.", call. = FALSE)

  attr(dat, which = "accessed") <- accessed

  dat
}
