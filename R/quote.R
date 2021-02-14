
.quoteurl <- "https://api.twelvedata.com/quote"

##' Retrieve Securities Quotes Data from \sQuote{twelvedata}
##'
##' The function has been named \code{get_quote()} to not clash with the base R function
##' \code{quote}.
##' @title Quote Data Accessor for \sQuote{twelvedata}
##' @param sym (character) A (single or vector) symbol understood by the backend as a stock
##' symbol, foreign exchange pair, or more. See the \sQuote{twelvedata} documentation for
##' details on what is covered.
##' @param interval (character) A valid interval designator ranging form \dQuote{1min} to
##' \dQuote{1month}. Currently supported are 1, 5, 15, 30 and 45 minutes, 1, 2, 4 hours (using
##' suffix \sQuote{h}, as well as \dQuote{1day}, \dQuote{1week} and \dQuote{1month}.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param exchange (optional, character) A selection of the exchange for which data for
##' \dQuote{sym} is requested, default value is unset.
##' @param country (optional, character) A selection of the country exchange for which data
##' for \dQuote{sym} is requested, default value is unset.
##' @param volume_time_period (optional, numeric) The number of days to use when computing
##' average volume, default is 9.
##' @param type (optional, character) A valid security type selection, if set it must be one of
##' \dQuote{Stock} (the default), \dQuote{Index}, \dQuote{ETF} or \dQuote{REIT}. Default is
##' unset via the \code{NA} character value. This field may require the premium subscription.
##' @param dp (optional, numeric) The number of decimal places returned on floating point
##' numbers. The value can be between 0 and 11, with a default value of 5.
##' @param timezone (optional, character) The timezone of the returned time stamp. This parameter
##' is optional. Possible values are \dQuote{Exchange} (the default) to return the
##' exchange-supplied value, \dQuote{UTC} to use UTC, or a value IANA timezone name such as
##' \dQuote{America/New_York} (see \code{link{OlsonNames}} to see the values R knows). Note
##' that the IANA timezone values are case-sensitive.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object with as many rows
##' as there were symbols in the request.
##' @seealso \url{https://twelvedata.com/docs}
##' @author Dirk Eddelbuettel
get_quote <- function(sym,
                      interval = c("1min", "5min", "15min", "30min", "45min",
                                   "1h", "2h", "4h", "1day", "1week", "1month"),
                      as = c("data.frame", "raw"),
                      exchange = "",
                      country = "",
                      volume_time_period = 9,
                      type = c(NA_character_, "Stock", "Index", "ETF", "REIT"),
                      dp = 5,
                      timezone = NA_character_,
                      apikey) {

    if (missing(apikey)) apikey <- .get_apikey()
    interval <- match.arg(interval)
    as <- match.arg(as)
    type <- match.arg(type)

    qry <- paste0(.quoteurl, "?",
                  "symbol=", sym,
                  "&interval=", interval,
                  "&apikey=", apikey)
    if (exchange != "") qry <- paste0(qry, "&exchange=", exchange)
    if (country != "") qry <- paste0(qry, "&country=", country)
    if (volume_time_period != 9) qry <- paste0(qry, "&volume_time_period=", volume_time_period)
    if (!is.na(type)) qry <- paste0(qry, "&type=", type)
    if (dp != 5) qry <- paste0(qry, "&dp=", dp)
    if (!is.na(timezone)) qry <- paste0(qry, "&timezone=", timezone)

    accessed <- format(Sys.time())
    res <- RcppSimdJson::fload(qry)
    if (as == "raw") return(res)

    if (length(sym) == 1) {
        reslist <- list(res=res)
    } else {
        reslist <- res
    }

    ## loop over result elements
    ret <- lapply(reslist, function(elem) {
        res <- as.data.frame(elem)
        res$datetime <- as.POSIXct(res$datetime)
        for (field in c("open", "high", "low", "close", "volume", "previous_close", "change",
                        "percent_change", "average_volume", "fifty_two_week.low",
                        "fifty_two_week.high", "fifty_two_week.low_change",
                        "fifty_two_week.high_change", "fifty_two_week.low_change_percent",
                        "fifty_two_week.high_change_percent"))
            res[[field]] <- as.numeric(res[[field]])
        attr(res, "accessed") <- accessed
        res
    })

    ## if it was just one element, flatten the list, else name it
    if (length(ret) == 1) {
        ret <- ret[[1]]
    } else {
        names(ret) <- sym
        ret <- do.call(rbind, ret)
    }
    ret

}
