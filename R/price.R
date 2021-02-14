.priceurl <- "https://api.twelvedata.com/price"

##' Retrieve Securities Real-Time Price Data from \sQuote{twelvedata}
##'
##' This is lightweight accessor which also returns the price. See \code{get_quote()} for a richer
##' return set.
##'
##' The function has been named \code{get_price()} to be consistent with the \code{get_quote()}
##' function.
##' @title Quote Data Accessor for \sQuote{twelvedata}
##' @param sym (character) A (single or vector) symbol understood by the backend as a stock
##' symbol, foreign exchange pair, or more. See the \sQuote{twelvedata} documentation for
##' details on what is covered. In the case of a vector of arguments a vector or prices is returned.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param exchange (optional, character) A selection of the exchange for which data for
##' \dQuote{sym} is requested, default value is unset.
##' @param country (optional, character) A selection of the country exchange for which data
##' for \dQuote{sym} is requested, default value is unset.
##' @param type (optional, character) A valid security type selection, if set it must be one of
##' \dQuote{Stock} (the default), \dQuote{Index}, \dQuote{ETF} or \dQuote{REIT}. Default is
##' unset via the \code{NA} character value. This field may require the premium subscription.
##' @param dp (optional, numeric) The number of decimal places returned on floating point
##' numbers. The value can be between 0 and 11, with a default value of 5.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned.
##' @seealso \url{https://twelvedata.com/docs}
##' @author Dirk Eddelbuettel
get_price <- function(sym,
                      as = c("data.frame", "raw"),
                      exchange = "",
                      country = "",
                      type = c(NA_character_, "Stock", "Index", "ETF", "REIT"),
                      dp = 5,
                      apikey) {

    if (missing(apikey)) apikey <- .get_apikey()
    as <- match.arg(as)
    type <- match.arg(type)

    qry <- paste0(.priceurl, "?",
                  "symbol=", sym,
                  "&apikey=", apikey)
    if (exchange != "") qry <- paste0(qry, "&exchange=", exchange)
    if (country != "") qry <- paste0(qry, "&country=", country)
    if (!is.na(type)) qry <- paste0(qry, "&type=", type)
    if (dp != 5) qry <- paste0(qry, "&dp=", dp)

    accessed <- format(Sys.time())
    res <- RcppSimdJson::fload(qry)
    if (as == "raw") return(res)

    res <- as.data.frame(res)
    res <- as.double(res)
    names(res) <- sym
    attr(res, "accessed") <- accessed
    res
}
