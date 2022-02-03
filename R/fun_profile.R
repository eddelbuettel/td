
##' Retrieve Profile Data from \sQuote{twelvedata}.
##'
##' \code{fun_profile}.
##' @title Fundamental Data Accessor for the Profile from \sQuote{twelvedata}
##'      This API endpoint is available starting with the Grow plan.
##' @param sym (character)  A (single or vector) symbol for Indices. Defaults to unset.
##' @param exchange (optional, character)  Exchange. Defaults to unset.
##' @param country (optional, character)  An alpha code or country name. Defaults to unset.
##' @param apikey (optional character) An API key override, if missing a value cached from
##' package startup is used. The startup looks for either a file in the per-package config
##' directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
##' \code{TWELVEDATA_API_KEY} variable.
##' @return The requested data is returned as a \code{list} object.
##' @seealso \url{https://twelvedata.com/docs}
fun_profile <- function(sym,
                        exchange = "",
                        country = "",
                        apikey) {

  if (missing(apikey)) apikey <- .get_apikey()

  qry <- paste0("https://api.twelvedata.com/profile", "?",
                "&apikey=", apikey)
  qry <- paste0(qry, "&symbol=", sym)
  if (exchange[1] != "") qry <- paste0(qry, "&exchange=", exchange)
  if (country[1] != "") qry <- paste0(qry, "&country=", country)

  accessed <- format(Sys.time(), tz = "UTC")
  res <- RcppSimdJson::fload(qry)

  if(length(sym) == 1) res <- list(res)
  names(res) <- sym

  attr(res, which = "accessed") <- accessed

  res
}


