
##  td -- R interface to 'twelvedata' API
##
##  Copyright (C) 2021  Dirk Eddelbuettel <edd@debian.org>
##
##  This file is part of td.
##
##  td is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  td is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with td.  If not, see <http://www.gnu.org/licenses/>.
.pkgenv <- new.env(parent=emptyenv())

.defaultFile <- function() {
    if (getRversion() >= "4.0.0") {
        tddir <- tools::R_user_dir("td")
        if (dir.exists(tddir)) {
            fname <- file.path(tddir, "api.dcf")
            if (file.exists(fname)) {
                return(fname)
            }
        }
    }
    return("")
}

.getKeyIntoPkgEnv <- function(silent=TRUE) {
    .pkgenv[["api"]] <- ""
    fname <- .defaultFile()
    if (fname != "") {
        res <- read.dcf(fname)
        if (!is.na(match("key", colnames(res)))) {
            .pkgenv[["api"]] <- res[[1, "key"]]
            if (!silent) packageStartupMessage("Setting API key from config file.")
        } else {
            if (!silent) packageStartupMessage("API key file found but no api entry.")
        }
    } else if ((ev <- Sys.getenv("TWELVEDATA_API_KEY")) != "") {
        .pkgenv[["api"]] <- ev
        if (!silent) packageStartupMessage("Setting API key from environment variable.")
    } else {
        if (!silent) packageStartupMessage(paste("No config file or environment variable",
                                                 "found: API access unlikely."))
    }

}

## called when functions get accessed directly; messages are prohibited
.onLoad <- function(libname, pkgname) {
    .getKeyIntoPkgEnv(silent=TRUE)
}

## called when the package is attached explicitly, messages permitted via packageStartupMessages()
.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching td version ", utils::packageVersion("td"), ". ", appendLF=FALSE)
    .getKeyIntoPkgEnv(silent=FALSE)
}
