#' Generate a tempest object
#'
#' @param seed data frame with x, y, id
#' @param iterations how many times should we iterate the curl noise?
#' @param scale how large is each curl step?
#' @param curl_seed arguments Tto pass to curl_noise()
#' @param na.rm logical, remove NAs from seed
#'
#' @return a "tempest" ribbon, data frame with x, y, order, time and id
#' @export

time_tempest <- function(
  seed = seed_sticks(), # seed points
  iterations = 6,       # how many iterations to curl?
  scale = .02,          # size of the curl step
  curl_seed = NULL,
  na.rm = TRUE          # Remove NA values from the data.frame
) {

  if(apply(seed, 2, function(x) any(is.na(x))) && !na.rm) stop("Data contains NA's you should remove them if you want this to work. (don't be Dale)")

  if(apply(seed, 2, function(x) any(is.na(x))) && na.rm){
    seed<- dplyr::filter(.data = seed, !is.na(seed$x),!is.na(seed$y))
  }

  # iterate each point through curl noise
  ribbon <- list()
  ribbon[[1]] <- seed
  ribbon[[1]]$order <- 1:dim(seed)[1]

  for(i in 1:iterations) {

    # apply curl noise
    ribbon[[i+1]] <- ambient::curl_noise(
      ambient::gen_simplex,
      x = ribbon[[i]]$x,
      y = ribbon[[i]]$y,
      seed = curl_seed
    )

    # retain the id
    ribbon[[i+1]]$id <- ribbon[[i]]$id

    # order the steps by their length
    ribbon[[i+1]]$order <- sqrt(ribbon[[i+1]]$x^2 + ribbon[[i+1]]$y^2)
    ribbon[[i+1]]$order <- order(ribbon[[i+1]]$order)

    # rescale the curl noise
    ribbon[[i+1]]$x <- ribbon[[i]]$x + ribbon[[i+1]]$x * scale
    ribbon[[i+1]]$y <- ribbon[[i]]$y + ribbon[[i+1]]$y * scale
  }

  # unnest
  ribbon <- dplyr::bind_rows(ribbon, .id = "time")
  ribbon$time <- as.numeric(ribbon$time)

  return(ribbon)
}
