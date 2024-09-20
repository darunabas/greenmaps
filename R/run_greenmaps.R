#' @title Run \emph{GreenMaps}
#' @description This function runs the \emph{GreenMaps} shiny application
#' @param launch.browser Whether or not to launch a new browser window.
#' @param port The port for the shiny server to listen on. Defaults to a
#' random available port.
#'
#' @examples
#' if(interactive()) {
#' run_GreenMaps()
#' }
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
run_GreenMaps <- function(launch.browser = TRUE, port = getOption("shiny.port")) {
  app_path <- system.file("ShinyApp", package = "greenmaps")
  knitcitations::cleanbib()
  options("citation_format" = "pandoc")
  preexisting_objects <- ls(envir = .GlobalEnv)
  on.exit(rm(list = setdiff(ls(envir = .GlobalEnv), preexisting_objects),
             envir = .GlobalEnv))
  return(shiny::runApp(app_path, launch.browser = launch.browser, port = port))
}

#' @title Get GreenMaps Application Directory
#' @description This function returns the path to the top directory
#' of the \emph{GreenMaps} Shiny application.
#' @return A character string representing the file path to the top directory
#' of the \emph{GreenMaps} Shiny app.
#' @examples
#' appdir()
#' @export
appdir <- function() system.file("ShinyApp", package="greenmaps")

