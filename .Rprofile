# |  (C) 2008-2024 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de
Sys.setenv(RENV_PATHS_LIBRARY = "renv/library")
if (Sys.info()[["sysname"]] == "Windows") {
  # make renv use R's default download function to prevent
  # curl: (35) schannel: next InitializeSecurityContext failed: Unknown error
  # (0x80092012) - The revocation function was unable to check revocation for the certificate.
  options(renv.download.override = utils::download.file)
}

# do not check if library and renv.lock are in sync, because normally renv.lock does not exist
options(renv.config.synchronized.check = FALSE,
        renv.config.user.profile = TRUE) # load user specific settings from ~/.Rprofile

source("renv/activate.R")

renvVersion <- package_version("1.0.7")
if (packageVersion("renv") != renvVersion) {
  renvLockExisted <- file.exists(renv::paths$lockfile())
  renv::install(paste0("renv@", renvVersion), prompt = FALSE)
  if (!renvLockExisted) {
    unlink(renv::paths$lockfile())
  }
  message("Installed renv version ", renvVersion, ". Please restart R.")
  q(status = 10)
}

if (!"https://rse.pik-potsdam.de/r/packages" %in% getOption("repos")) {
  options(repos = c(getOption("repos"), pik = "https://rse.pik-potsdam.de/r/packages"))
}

# bootstrapping, will only run once after this repo is freshly cloned
if (isTRUE(rownames(installed.packages(priority = "NA")) == "renv")) {
  message("R package dependencies are not installed in this renv, installing now...")
  renv::hydrate(prompt = FALSE, report = FALSE) # auto-detect and install all dependencies
  message("Finished installing R package dependencies.")
  if (!("upstream" %in% gert::git_remote_list()$name)) {
    gert::git_remote_add("https://github.com/magpiemodel/magpie.git", "upstream")
    message("Added upstream git remote pointing to magpiemodel/magpie.")
  }
}

# in case bootstrapping fails halfway, install piamenv and rely on requirement auto-fixing
if (tryCatch(packageVersion("piamenv"),
             error = function(e) package_version("0.0")) < package_version("0.3.4")) {
  renv::install("piamenv", prompt = FALSE)
}
