testthat::context("Build")

Sys.setlocale('LC_ALL','C')

# Simulate the creation of a new project
testthat::test_that("A Simple Article can be built", {
  testthat::skip_on_cran()
  # Save working directory
  original_wd <- getwd()
  # Get a temporary working directory
  wd <- tempfile("example")
  # Simulate File > New File > R Markdown... > From Template > Simple Article
  rmarkdown::draft(wd, template = "simple_article", package = "memoiR", edit = FALSE)
  # Go to temp directory
  setwd(wd)
  # Make it the current project
  usethis::proj_set(path = ".", force = TRUE)
  
  ## Sequence of actions to build a complete project
  # Build .gitignore
  build_gitignore()
  ## Activate source control, edit your files, commit
  # Build README
  build_readme()
  
  ## Scenario 1: no continuous integration
  # render: knit to downcute (interactively: click the Knit button)
  if (require("rmdformats")) {
    rmarkdown::render(
      input = list.files(pattern = "*.Rmd"), 
      output_format = "rmdformats::downcute"
    )    
  }
  # render: knit to pdf (interactively: click the Knit button)
  rmarkdown::render(
    input = list.files(pattern = "*.Rmd"), 
    output_format = "bookdown::pdf_book"
  )
  # Build GitHub Pages
  build_githubpages()
  ## Commit and push. Outputs will be in /docs of the master branch.
  
  ## Scenario 2: continuous integration
  # Build GitHub Actions workflow
  build_ghworkflow()
  ## Commit and push: GH Actions will render the documents and store them 
  ## in the gh-pages branch.
  
  ## End of the example: cleanup
  # Return to the original working directory and clean up
  setwd(original_wd)
  unlink(wd, recursive = TRUE)
})

testthat::test_that("A book can be built", {
  testthat::skip_on_cran()
  # Save working directory
  original_wd <- getwd()
  # Get a temporary working directory
  wd <- tempfile("example")
  # Simulate File > New File > R Markdown... > From Template > Memoir
  rmarkdown::draft(wd, template = "memoir", package = "memoiR", edit = FALSE)
  # Go to temp directory
  setwd(wd)
  # Make it the current project
  usethis::proj_set(path = ".", force = TRUE)
  # Delete the useless skeleton file
  tmpdir_vec <- strsplit(getwd(), "/", fixed = TRUE)[[1]]
  skeleton_name <- tmpdir_vec[length(tmpdir_vec)]
  unlink(paste(skeleton_name, ".Rmd", sep = ""))
  
  ## Sequence of actions to build a complete project
  # Build .gitignore
  build_gitignore()
  ## Activate source control, edit your files, commit
  # Build README
  build_readme()
  
  ## Scenario 1: no continuous integration
  # render: knit (interactively: click the Build the Book button)
  bookdown::render_book(
    input = "index.Rmd", 
    output_format = "bookdown::pdf_book"
  )
  bookdown::render_book(
    input = "index.Rmd", 
    output_format = "bookdown::gitbook"
  )
  ## Commit and push. Outputs will be in /docs of the master branch.
  
  ## Scenario 2: continuous integration
  # Build GitHub Actions workflow
  build_ghworkflow()
  ## Commit and push: GH Actions will render the documents and store them 
  ## in the gh-pages branch.
  
  ## End of the example: cleanup
  # Return to the original working directory and clean up
  setwd(original_wd)
  unlink(wd, recursive = TRUE)
})
