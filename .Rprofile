# from https://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/
local({r <- getOption("repos")
       r["CRAN"] <- 'http://cran.r-project.org'
       options(repos=r)
       })

options(stringsAsFactors=FALSE)

options(max.print=100)

options(scipen=10)

options(editor="vim")

options(menu.graphics=FALSE)

options(prompt="> ")
options(continue="... ")

options(width = 80)

q <- function(save="no", ...) {
  quit(save=save, ...)
}

utils::rc.settings(ipck=TRUE)

.First <- function(){
  if(interactive()) {
    library(utils)
    timestamp(,prefix=paste("##------ [",getwd(),"] ", sep=""))
  }
}

.Last <- function(){
  if(interactive()) {
    hist_file <- Sys.getenv("R_HISTFILE")
    if(hist_file=="") hist_file <- "~/.RHistory"
    savehistory(hist_file)
  }
}


if(Sys.getenv("TERM") == "xterm-256color")
  library("colorout")

sshhh <- function(a.package){
  suppressWarnings(suppressPackageStartupMessages(
    library(a.package, character.only=TRUE)))
}

auto.loads <- c("dplyr", "ggplot2")

if(interactive()){
  invisible(sapply(auto.loads, sshhh))
}


.env <- new.env()
attach(.env)

.env$unrowname <- function(x) {
  rownames(x) <- NULL
  x
}

.env$unfactor <- function(df) {
  id <- sapply(df, is.factor)
  df[id] <- lapply(df[id], as.character)
  df
}

message("\n*** sucessfully loaded .Rprofile ***\n")
