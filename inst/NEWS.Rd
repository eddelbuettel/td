\name{NEWS}
\title{News for Package \pkg{td}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/td/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/td/issues/#1}{##1}}

\section{Changes in version 0.0.2 (2021-02-18)}{
  \itemize{
    \item The \code{time_series} is now vectorised and can return a list
    of return objects when given a vector of symbols
    \item The use of \code{tools::R_user_dir()} is now conditional on
    having R 4.0.0 or later, older versions can use env.var for api key
    \item New helper function \code{store_key} to save api key.
    \item New simple accessors \code{get_quote} and \code{get_price}
  }
}

\section{Changes in version 0.0.1 (2021-02-07)}{
  \itemize{
    \item Initial version and CRAN upload
  }
}

