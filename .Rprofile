# from https://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/

# Set CRAN mirror to avoid being asked every time
local({r <- getOption("repos")
       r["CRAN"] <- 'http://cran.r-project.org'
       options(repos=r)
       })


options(stringsAsFactors=FALSE)

options(max.print=100)

options(scipen=10) # never use scientific notation to express very small or very large numbers

options(editor="vim")

# options(show.signif.stars=FALSE) # turn off significance stars

options(menu.graphics=FALSE) # prefer text console

options(prompt="> ")
options(continue="... ")  # If we forget a ) at the end of the line the default + is difficult to notice
                          # use ... just like the Python REPL does

options(width = 80)

q <- function(save="no", ...) { # Change the default behaviour of q() to quit without saving
  quit(save=save, ...)
}

utils::rc.settings(ipck=TRUE) # tab-complete packagenames for use in library() or require() calls.

.First <- function(){
  if(interactive()) {
    library(utils)
    timestamp(,prefix=paste("##------ [",getwd(),"] ", sep="")) # The ‘timestamp’ function writes a timestamp 
                                                                # (or other message) into the
                                                                # history and echos it to the console. 
    # Just insert a timestamp in the history file so that is easier to read / search on the history file
  }
}

.Last <- function(){
  if(interactive()) {
    hist_file <- Sys.getenv("R_HISTFILE")
    if(hist_file=="") hist_file <- "~/.RHistory"
    savehistory(hist_file) # Write history file when exiting R
  }
}


# Enable colorized output
if(Sys.getenv("TERM") %in%  c("xterm-256color", "screen-256color")) {
  require("colorout") # don't use library() because it may not be installed
  # color is NOT on CRAN
  # git clone https://github.com/jalvesaq/colorout.git
  # R CMD INSTALL colorout
}

sshhh <- function(a.package){
  suppressWarnings(suppressPackageStartupMessages(
    library(a.package, character.only=TRUE)))
}

auto.loads <- c("dplyr", "ggplot2")

if(interactive()){
  # load th auto.loads packages silently 
  # suppressing warnings
  invisible(sapply(auto.loads, sshhh))
}


# Create a hidden namespace where we can store functions
# This functions will survive a call to rm(list=ls())
# which will remove everything in the current namespace. 
# See http://www.gettinggeneticsdone.com/2013/07/customize-rprofile.html
.env <- new.env()
attach(.env)

.env$unrowname <- function(x) { 
  # removes any row names a data.frame might have
  rownames(x) <- NULL
  x
}

.env$unfactor <- function(df) {
  # sanely undo a factor() call
  id <- sapply(df, is.factor)
  df[id] <- lapply(df[id], as.character)
  df
}



message("\n*** sucessfully loaded .Rprofile ***\n")


# Good practice
# * Run scripts with R/Rscript --vanilla / #!/usr/bin/Rscript --vanilla to ignore
#   configuration files to make sure that yoor script will run on other systems
# * Or the .Rprofile to another name so it's not used by defaults then create an alias that uses the .Rprofile.ecerulm
#   alias aR="R_PROFILE_USER=~/.Rprofile.ecerulm R"
