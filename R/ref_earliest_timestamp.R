
.refearliesttimestampurl <- "https://api.twelvedata.com/earliest_timestamp"

##' Retrieve Reference Data for Symbol Search from \sQuote{twelvedata}
##'
##' \code{ref_earliest_timestamp}.
##' @title Reference Data Accessor for Symbol Search from \sQuote{twelvedata}
##' @param sym (character) A (single or vector) symbol understood by the backend as a stock
##' symbol, foreign exchange pair, or more. See the \sQuote{twelvedata} documentation for
##' details on what is covered. In the case of a vector of arguments a list is returned.
##' @param interval (character) A valid interval designator ranging form \dQuote{1min} to
##' \dQuote{1month}. Currently supported are 1, 5, 15, 30 and 45 minutes, 1, 2, 4 hours (using
##' suffix \sQuote{h}, as well as \dQuote{1day}, \dQuote{1week} and \dQuote{1month}.
##' @param as (optional, character) A selector for the desired output format: one of
##' \dQuote{data.frame} (the default) or or \dQuote{raw}.
##' @param exchange (optional, character) A selection of the exchange for which data for
##' \dQuote{sym} is requested, default value is unset.
##' @param timezone (optional, character) The timezone of the returned time stamp. This parameter
##' is optional. Possible values are \dQuote{Exchange} (the default) to return the
##' exchange-supplied value, \dQuote{UTC} to use UTC, or a value IANA timezone name such as
##' \dQuote{America/New_York} (see \code{link{OlsonNames}} to see the values R knows). Note
##' that the IANA timezone values are case-sensitive. Note that intra-day data is converted to
##' an R datetime object (the standard \code{POSIXct} type) using the exchange timestamp in
##' the returned metadata, if present.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{data.frame} object.
##' @seealso \url{https://twelvedata.com/docs}
ref_earliest_timestamp <- function(sym,
                              interval = c("1min", "5min", "15min", "30min", "45min",
                                           "1h", "2h", "4h", "1day", "1week", "1month"),
                              as = c("data.frame", "raw"),
                              exchange = "",
                              timezone = NA_character_,
                              apikey) {

  if (missing(apikey)) apikey <- .get_apikey()
  as <- match.arg(as)
  interval <- match.arg(interval)

  qry <- paste0(.refearliesttimestampurl, "?",
                "&apikey=", apikey)

  qry <- paste0(qry, "&symbol=", sym)
  qry <- paste0(qry, "&interval=", interval)

  if(exchange != "") qry <- paste0(qry, "&exchange=", exchange)
  if(!is.na(timezone)) qry <- paste0(qry, "&timezone=", timezone)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)
  if (as == "raw") return(res)

  if("status" %in% names(res)){
    if(res$status != "ok") stop(res$message, call. = FALSE)
  }

  dat <- data.frame(datetime = as.POSIXct(res$datetime), unix_time = res$unix_time)
  attr(dat, which = "accessed") <- accessed

  dat
}
