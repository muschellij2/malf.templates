.onAttach <- function(...) {
  if (!interactive()) return()

  ack <- paste(
    'MICCAI 2012 Challenge on Multi-atlas Labelling Data: ',
    'This data is from OASIS project and the ',
    'labeled data as provided by Neuromorphometrics, Inc. ',
    '(http://Neuromorphometrics.com/) under academic subscription. ',
    'These references should be included in all publications.'
  )

  packageStartupMessage(paste(strwrap(ack), collapse = "\n"))
}