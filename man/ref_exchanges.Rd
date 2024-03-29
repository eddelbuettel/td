% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ref_exchanges.R
\name{ref_exchanges}
\alias{ref_exchanges}
\title{Reference Data Accessor for Exchanges from \sQuote{twelvedata}}
\usage{
ref_exchanges(
  type = c("stock", "etf", "index"),
  as = c("data.frame", "raw"),
  name = "",
  code = "",
  country = "",
  apikey
)
}
\arguments{
\item{type}{(character)  A (single) type for exchange for \dQuote{stock}, \dQuote{etf}
or \dQuote{index}. Defaults to \dQuote{stock}.}

\item{as}{(optional, character) A selector for the desired output format: one of
\dQuote{data.frame} (the default) or or \dQuote{raw}.}

\item{name}{(optional, character) Filter by exchange. Default is unset.}

\item{code}{(optional, character) Filter by exchange mic code. default is unset.}

\item{country}{(optional, character)  Filter by country name or alpha code. Default is unset.}

\item{apikey}{(optional character) An API key override, if missing a value cached from
package startup is used. The startup looks for either a file in the per-package config
directory provided by \code{tools::R_user_dir} (for R 4.0.0 or later), or the
\code{TWELVEDATA_API_KEY} variable.}
}
\value{
The requested data is returned as a \code{data.frame} object.
}
\description{
Retrieve Reference Data for Exchanges from \sQuote{twelvedata}
}
\details{
\code{ref_exchanges}.
}
\seealso{
\url{https://twelvedata.com/docs}
}
