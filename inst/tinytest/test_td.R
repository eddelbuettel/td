
suppressMessages(library(td))

## there is not a lot we can without an API key
expect_error(time_series(sym="SPY", api=""))

## if we have an API key AND tests are opted-into, run basic tests
## we use an opt-in to not run down the query allotment
if ((Sys.getenv("RunTDTests","") == "yes")
    && td:::.get_apikey() != ""
    && requireNamespace("xts", quietly=TRUE)) {

    spy <- time_series(sym="SPY", interval="1min", outputsize=100, as="xts")

    expect_true(inherits(spy, "xts"))
    expect_equal(nrow(spy), 100)
}
