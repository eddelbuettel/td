
.refexchangesurl <- "https://api.twelvedata.com/exchanges"

##' Retrieve Reference Data for Exchanges from \sQuote{twelvedata}
##'
##' \code{ref_exchanges}.
##' @title Reference Data Accessor for Exchanges from \sQuote{twelvedata}
##' @param type (character)  A (single) type for exchange for \dQuote{stock}, \dQuote{etf}
##' or \dQuote{index}. Defaults to \dQuote{stock}.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param name (optional, character) Filter by exchange. Default is unset.
##' @param code (optional, character) Filter by exchange mic code. default is unset.
##' @param country (optional, character)  Filter by country name or alpha code. Default is unset.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_exchanges <- function(type = c("stock", "etf", "index"),
                        as = c("data.frame", "raw"),
                        name = "",
                        code = "",
                        country = "",
                        apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  type <- match.arg(type)
  as <- match.arg(as)

  qry <- paste0(.refexchangesurl, "?",
                "&apikey=", apikey)
  qry <- paste0(qry, "&type=", type)
  if (name != "") qry <- paste0(qry, "&name=", name)
  if (code != "") qry <- paste0(qry, "&code=", code)
  if (country != "") qry <- paste0(qry, "&country=", country)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  if(length(qry) == 1) res <- list(res)

  names(res) <- type
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
