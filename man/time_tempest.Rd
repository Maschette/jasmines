% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform_tempest.R
\name{time_tempest}
\alias{time_tempest}
\title{Generate a tempest object}
\usage{
time_tempest(
  seed = seed_sticks(),
  iterations = 6,
  scale = 0.02,
  curl_seed = NULL,
  na.rm = TRUE
)
}
\arguments{
\item{seed}{data frame with x, y, id}

\item{iterations}{how many times should we iterate the curl noise?}

\item{scale}{how large is each curl step?}

\item{curl_seed}{arguments Tto pass to curl_noise()}

\item{na.rm}{logical, remove NAs from seed}
}
\value{
a "tempest" ribbon, data frame with x, y, order, time and id
}
\description{
Generate a tempest object
}
