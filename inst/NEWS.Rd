\name{NEWS}
\title{News for Package \pkg{td}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/td/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/td/issues/#1}{##1}}

\section{Changes in version 0.0.5 (2021-10-28)}{
  \itemize{
    \item New functions to access twelvedata reference data (Kenneth in
    \ghpr{4} addressubf \ghit{3})
  }
}

\section{Changes in version 0.0.4 (2021-06-05)}{
  \itemize{
    \item The version comparison was corrected and the package no longer
    (formally) depends on R (>= 4.0.0)
    \item Very minor README.md edits
  }
}

\section{Changes in version 0.0.3 (2021-05-29)}{
  \itemize{
    \item The package now (formally) depends on R (>= 4.0.0) as it uses
    a recently added R function for the default config file.
    \item A few URLs were updated in the README.md file
  }
}

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

