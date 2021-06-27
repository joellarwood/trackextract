#' Create excerpts from audio file
#'
#' Takes a single audio file and exports a series of files of a given length.
#' These excerpts are written to an output folder in the working directory.
#' The files can either be gated samples of an increasing length or samples of a set length.
#'
#'
#' @param path The path to the audio file to be created. Must be .mp3 or .wav
#' @param gate TRUE/FALSE. If TRUE then n gated excerpts are created where the length of each exported excerpt is the length of the previously exported excerpt plus the length argument. If FALSE then n excerpts are created of the audio file where the length is equal to the length defined in the length argument
#' @param start The time (in milliseconds) that the first excerpt should be taken from.
#' @param random TRUE/FALSE. If TRUE then samples are taken from random start points after the specified start point throughout the audio file. If FALSE then samples are sequentially taken from the start point. If gate is TRUE then a random start point after the defined start is used
#' @param excerpt_length The time (in milliseconds) of samples extracted/gates
#' @param n The number of samples/gates to create
#' @param categorize TRUE/FALSE. If TRUE extracts the name of the folder the audio file is immediately stored in and treats it as the category the audio belongs to  and creates a corresponding folder in the output directory.
#' @export
#' @examples
#' \dontrun{
#' #' ## These examples are not reproducible path should be replaced witht the path to your audio files
#' #----
#' ## Extract 7 1second excerpts from the beginning of the sad_song
#' extract_track(
#'   path = "tracks/sad/sad_song.wav",
#'   gate = FALSE,
#'   start = 0,
#'   random = TRUE,
#'   excerpt_length = 1000,
#'   n = 7,
#'   categorize = T
#' )
#'
#' ## Randomly take 10 500ms excerpts from the beginning of the happy_song
#' extract_track(
#'   path = "tracks/happy/happy_song.wav",
#'   gate = FALSE,
#'   start = 0,
#'   random = TRUE,
#'   excerpt_length = 1000,
#'   n = 10,
#'   categorize = T
#' )
#'
#' ## Extract 5 gates of 200ms from a random start point of the sad_song
#' gate_track(
#'   path = "tracks/sad/sad_song.wav",
#'   gate = TRUE,
#'   start = 0,
#'   random = TRUE,
#'   excerpt_length = 200,
#'   n = 5,
#'   categorize = T
#' )
#' }
track_extract <- function(path, gate, start = 0, random, excerpt_length, n, categorize = TRUE) {
  ### Check path exists
  if (!(file.exists(path))) {
    stop(
      paste("The file", path, "does not exist")
    )
  }

  ### Get the file extension
  extension <- stringr::str_extract(path, "\\.(...)$")

  if (!extension %in% c(".mp3", ".wav")) {
    stop("Audio file must be .mp3 or .wav")
  }

  if (extension == ".mp3") {
    audio <- tuneR::readMP3(path)
  }

  if (extension == ".wav") {
    audio <- tuneR::readWave(path)
  }

  ## load in sound file
  ## Split file path into names according to "/" delim
  path_elements <- stringr::str_split(path, "/")[[1]]

  ## Name of audio
  original_file <- path_elements[length(path_elements)]
  ## Remove extension
  original_file <- gsub(extension, "", original_file)

  if (categorize) {
    category <- path_elements[length(path_elements) - 1]
  }

  ## Create output folder pathname
  output_path <- paste0(getwd(), "/output")

  if (categorize) {
    output_path <- paste0(output_path, "/", category)
  }

  ## If path does not exist then create the directory
  if (!file.exists(output_path)) {
    dir.create(output_path, recursive = TRUE)
  }

  ### Get the sampling rate
  sample_rate <- audio@samp.rate

  ### Get the length of the file
  totlen <- length(audio)

  ### Get the lengths of the audio in milliseconds
  totms <- (length(audio) / sample_rate) * 1000


  ## Define excerpt length in number of samples

  num_samples <- (excerpt_length / 1000) * sample_rate

  ### If gate == FALSE

  if (gate == FALSE) {

    ## Get track start positions
    ### IF not random
    if (random == FALSE) {
      start_position <- seq.int(
        from = start,
        by = excerpt_length,
        length.out = n
      )
    }
    ## IF random then draw n random starting points

    if (random == TRUE) {


      ## Sample from positions to get a starting sample
      start_position <- sample(
        seq.int(
          from = start,
          to = totms - excerpt_length,
          by = 100 # increment sequence in 100ms blocks
        ),
        size = n
      )
    }

    ## Create Loop
    for (start in start_position) {

      ### Get the start position
      start_position <- (start / 1000) * sample_rate

      ### Get the end position
      ## Get the end in MS
      end <- start + excerpt_length
      end_position <- (end / 1000) * sample_rate

      ## Subset the WAVE to number of samples equivalent to given gate length
      tmp_wave <- audio[start_position:end_position]

      ## Name outfile
      new_file_name <- paste(start, end, original_file, sep = "-")

      ## set export location
      location <- paste0(
        output_path,
        "/",
        new_file_name,
        ".wav"
      )

      ## Print export locatiom
      message("File written to", location)

      ## Export gated file
      tuneR::writeWave(
        tmp_wave,
        filename = location
      )
    }
  }

  ### IF gate == TRUE
  if (gate == TRUE) {

    ## IF random then draw n random starting points

    if (random == TRUE) {
      ## Sample from positions to get a starting sample
      start <- sample(
        seq.int(
          from = start,
          to = totms - excerpt_length,
          by = 100 # increment sequence in 100ms blocks
        ),
        size = 1
      )
    }

    ## Get track end positions

    end_position <- seq.int(
      from = start + excerpt_length,
      by = excerpt_length,
      length.out = n
    )

    ## Loop through end posotions
    for (end in end_position) {

      ## Get the start position
      start_position <- (start / 1000) * sample_rate

      ## Get the end position according to samples
      end_position <- (end / 1000) * sample_rate

      ## Subset the WAVE to number of samples equivalent to given gate length
      tmp_wave <- audio[start_position:end_position]

      ## Name outfile
      new_file_name <- paste(start, end, original_file, sep = "-")

      ## set export location
      location <- paste0(
        output_path,
        "/",
        new_file_name,
        ".wav"
      )

      ## Print export locatiom
      message("File written to", location)

      ## Export gated file
      tuneR::writeWave(
        tmp_wave,
        filename = location
      )
    }
  }
}
