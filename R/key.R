##' Store the \sQuote{twelvedata} API key
##'
##' An API key is required to access the functionality offered by the
##' \sQuote{twelvedata}. This function can store a copy in a per-user
##' configuration file. It relies on a the base R function \code{R_user_dir}
##' which offers a per-user configuration directory for the package. No
##' file or directory permissions are set explicitly or changed. As an
##' alternative the key can also be set in the environment variable
##' \code{TWELVEDATA_API_KEY} but doing so is the responsibility of the user.
##'
##' @note This function requires R version 4.0.0 or later to utilise the per-user
##' config directory accessor function. For older R versions, please use the alternate
##' approach of storying the API in the environment variable \code{TWELVEDATA_API_KEY}.
##' @title Store API key
##' @param apikey A character variable with the API key
##' @return \code{TRUE} is return invisibly but the function is invoked for the
##' side effect of storing the API key.
##' @author Dirk Eddelbuettel
store_key <- function(apikey) {
    if (R.version.string < "4.0.0")
        stop("This function relies on R version 4.0.0 or later.", call. = FALSE)

    tddir <- tools::R_user_dir("td")
    if (!dir.exists(tddir))
        dir.create(tddir)
    fname <- file.path(tddir, "api2.dcf")
    if (file.exists(fname))
        warning("Existing file found, so overwriting")
    con <- file(fname)
    cat("key:", apikey, file=con)
    close(con)
    invisible(TRUE)
}

## internal helper function to access package env, initially in time_series.R
.get_apikey <- function() {
    ## could add checks but ensure on what values to check for
    apikey <- .pkgenv[["api"]]
    if (apikey == "") stop("No query without key.", call. = FALSE)
    apikey
}
