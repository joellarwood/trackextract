#' Create excerpts from a directory of audio files
#'
#' Takes a directory of audio files and exports a series of files of a given length.
#' These excerpts are written to an output folder in the working directory and can be categorised according to the folder the original file was stored within.
#' The files can either be gated samples of an increasing length or samples of a set length.
#'
#'
#' @param path The path to the parent directory containing audio files. Files can be categorised in folders inside of this directory
#' @param gate TRUE/FALSE. If TRUE then n gated excerpts are created where the length of each exported excerpt is the length of the previously exported excerpt plus the length argument. If FALSE then n excerpts are created of the audio file where the length is equal to the length defined in the length argument
#' @param start The time (in milliseconds) that the first excerpt should be taken from.
#' @param random TRUE/FALSE. If TRUE then samples are taken from random start points after the specified start point throughout the audio file. This start point is random for each audio file within the directory. If FALSE then samples are sequentially taken from the start point. If gate is TRUE then a random start point after the defined start is used.
#' @param excerpt_length The time (in milliseconds) of samples extracted/gates
#' @param n The number of samples/gates to create
#' @param categorize TRUE/FALSE. If TRUE extracts the name of the folder the audio file is immediately stored in and treats it as the category the audio belongs to  and creates a corresponding folder in the output directory.
#' @export
#' @examples
#' \dontrun{
#' ## These examples are not reproducible path should be replaced witht the path to your audio files
#' #----
#' ## Extract 7 1second excerpts from the beginning of all files stored within the "tracks" directory
#' extract_track(
#'   path = "tracks",
#'   gate = FALSE,
#'   start = 0,
#'   random = TRUE,
#'   excerpt_length = 1000,
#'   n = 7,
#'   categorize = T
#' )
#'
#'
#' ## Extract 5 gates of 200ms from a random start point for all files within the "tracks" directory
#' gate_track(
#'   path = "tracks/sad/sad_song.wav",
#'   gate = TRUE,
#'   start = 0,
#'   random = TRUE,
#'   excerpt_length = 200,
#'   n = 5,
#'   categorize = T
#' )
#'}

track_extract_directory <- function(path, gate, start = 0, random, excerpt_length, n, categorize = TRUE){

  ##Recursively search through directory for files that end in .mp3 or .wav

  files <- list.files(
    path,
    pattern = "\\.mp3$|\\.wav$",
    recursive = TRUE
  )

  ## Iterate through all files
  for(file in files){
    message("Processing", file)

    ##apply the track extract function to the file taking the arguments from the track_extract_function call
    track_extract(
      path = file,
      gate = gate,
      start = start,
      random = random,
      excerpt_length = excerpt_length,
      n = n,
      categorize = categorize
    )
  }
}
