
if (!require("optparse", quietly = TRUE))
    install.packages("optparse",repos = "http://cran.us.r-project.org")
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager",repos = "http://cran.us.r-project.org")
if (!require("GEOquery", quietly = TRUE))
    BiocManager::install("GEOquery")
if (!require("Biobase", quietly = TRUE))
    BiocManager::install("Biobase")


## Input handling ----------------------
# Define the command-line options
option_list <- list(
    optparse::make_option(c("-d", "--destination_dir"), type = "character", default = ".", help = "Destination directory"),
    optparse::make_option(c("-f", "--filename"), type = "character", default = "metadata.csv", help = "Metadata filename"),
    optparse::make_option(c("-g", "--geo_accession"), type = "character", help = "GEO accession number")
)

# Parse the command-line options
opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

# Extract the input arguments
destination_dir <- opt$destination_dir
filename <- opt$filename
geo_accession <- opt$geo_accession

# Print the input arguments for confirmation
cat(paste0("Destination directory: ", destination_dir, "\n"))
cat(paste0("Output filename: ", filename, "\n"))
cat(paste0("GEO accession number: ", geo_accession, "\n"))


## Download and get the data --------------------------

# Download the data from GEO
gse <- GEOquery::getGEO(geo_accession, GSEMatrix = TRUE)

# Extract the metadata
metadata <- Biobase::pData(gse[[1]])

# Write the metadata to the destination file in the destination directory
output_file <- file.path(destination_dir, filename)
write.csv(metadata, output_file, row.names = FALSE, col.names = TRUE)
