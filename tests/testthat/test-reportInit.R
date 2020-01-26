context("initialisation of report instances")

test_that("reportInit() basic functionality", {

  # error on no report name
  expect_error(reportInit())
  
})