
.refstocksurl <- "https://api.twelvedata.com/stocks"

##' Retrieve Reference Data for Stocks from \sQuote{twelvedata}
##'
##' \code{ref_stocks}.
##' @title Reference Data Accessor for Stocks from \sQuote{twelvedata}
##' @param sym (optional, character) A (single or vector) symbol understood by the backend as a stock
##' symbol, foreign exchange pair, or more. See the \sQuote{twelvedata} documentation for
##' details on what is covered.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param exchange (optional, character) A selection of the exchange. Default value is unset.
##' @param country (optional, character) A selection of the country exchanges. Default value is unset.
##' @param type (optional, character) A valid security type selection, if set it must be one of
##' \code{formals(ref_stock)$type}, with \code{NA} as default.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_stocks <- function(sym = "",
                       as = c("data.frame", "raw"),
                       exchange = "",
                       country = "",
                       type = c(NA_character_, "EQUITY", "Common", "Common Stock", "American Depositary Receipt",
                                "Real Estate Investment Trust (REIT)", "Unit", "GDR", "Closed-end Fund",
                                "ETF", "Depositary Receipt", "Preferred Stock", "Limited Partnership",
                                "OTHER_SECURITY_TYPE", "Warrant", "STRUCTURED_PRODUCT", "Exchange-traded Note",
                                "Right", "FUND", "Trust", "Index", "Unit Of Beneficial Interest",
                                "MUTUALFUND", "New York Registered Shares"),
                       apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)
  type <- match.arg(type)

  qry <- paste0(.refstocksurl, "?",
                "&apikey=", apikey)
  if (sym[1] != "") qry <- paste0(qry, "&symbol=", sym)
  if (exchange != "") qry <- paste0(qry, "&exchange=", exchange)
  if (country != "") qry <- paste0(qry, "&country=", country)
  if (!is.na(type[1])) qry <- paste0(qry, "&type=", type)

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

  if(is.null(dat)) stop("The API returned NULL. Try to change your query.", call. = FALSE)

  attr(dat, which = "accessed") <- accessed

  dat
}
