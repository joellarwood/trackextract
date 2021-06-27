
# trackextract

<!-- badges: start -->
<!-- badges: end -->

The goal of trackextract is to provide an easy way to create short excerpts from audio files that have already been categorised into folders. It provides the option to create gated excerpts, where each excerpt has the same start point and each excerpt is a set duration longer than the previous, or excerpts of a fixed duration from different points in the audio file. A random or user defined starting point can be set for gated excerpts. For excerpts of a fixed duration each excerpt can either begin from the end of the previous excerpt or can have a random start point. Functions are provided to either interact with a single audio file or a directory of audio files that can contain subfolders which categorise the audio file. Excerpts created by trackextract follow the naming structure `starttime(ms)-endtime(ms)-original file name`

Files may be either .wav or .mp3 but excerpts will be written as .wav

## Installation

This package can be installed from [GitHub](https://github.com/) with:

``` 
# install.packages("devtools")
devtools::install_github("joellarwood/trackextract")
```

## Example

`trackextract` is built on the assumption that audio files are stored within the working directory with the default `categorize = TRUE` assuming the files are categorised. 

```
+-- project
| +-- project.Rproj
| +-- audio
| | +-- category1
| | | +-- audio_file_1.mp3
| | +-- category2
| | | +-- audio_file_2.mp3
```

Audio files may be read in from outside of the working directory but they will be exported to an `output` folder inside of the working directory. 

To create 10 excerpts of 15seconds starting at a random time after 10 seconds into the track with a fixed duration of 1000ms of all audio files stored within `audio` the following code would be used: 
``` 
library(trackextract)

trackextract::track_extract_directory(
  path = "audio",
  gate = FALSE,
  start = 10000, #start point of the track is at 10seconds
  random = TRUE, #randomly select a start point for each excerpt after 10 seconds
  excerpt_length = 15000, #the length of each excerpt is 15 seconds
  n = 10, #create 10 excerpts
  categorize = T
)
```

Whereas to create 5 gated excerpts beginning from 10 seconds with a gate length of 250milliseconds this code would be used
``` 
library(trackextract)

trackextract::track_extract_directory(
  path = "audio",
  gate = TRUE,
  start = 10000, #start point of the track is at 10seconds
  random = FALSE, #The first excerpt will be taken from exactly 1000milliseconds
  excerpt_length = 250, #the length of each excerpt is 15 seconds
  n = 5, #create 5 gated excerpts
  categorize = T
)
```

This code would return the following in the working directory:
```
+-- project
| +-- project.Rproj
| +-- audio
| | +-- category1
| | | +-- audio_file_1.mp3
| | +-- category2
| | | +-- audio_file_2.mp3
| + outputs
| | +-- category1
| | | +--10000-10250-audio_file_1.mp3
| | | +--10000-10500-audio_file_1.mp3
| | | +--10000-10750-audio_file_1.mp3
| | | +--10000-11000-audio_file_1.mp3
| | | +--10000-11250-audio_file_1.mp3
| | +-- category2
| | | +--10000-10250-audio_file_2.mp3
| | | +--10000-10500-audio_file_2.mp3
| | | +--10000-10750-audio_file_2.mp3
| | | +--10000-11000-audio_file_2.mp3
| | | +--10000-11250-audio_file_2.mp3
```



