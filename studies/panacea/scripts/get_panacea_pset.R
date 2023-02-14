


library(tidyverse)


## Input handling ----------------------
# Define the command-line options
option_list <- list(
    optparse::make_option(c("-d", "--destination_dir"), type = "character", default = ".", help = "Destination directory"),
    optparse::make_option(c("-f", "--filename"), type = "character", default = "panacea.rds", help = "Output filename"),
    optparse::make_option(c("-m", "--metadata"), type = "character", help = "Input metadata file"),
    optparse::make_option(c("-e", "--expression"), type = "character", help = "Input expression file")
)

# Parse the command-line options
opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

# Extract the input arguments
destination_dir <- opt$destination_dir
filename <- opt$filename
metadata_file <- opt$metadata
expression_file <- opt$expression


metadata_file = "./download/metadata.csv"
expression_file = "./download/expression.csv"

# Print the input arguments for confirmation
cat(paste0("Destination directory: ", destination_dir, "\n"))
cat(paste0("Output filename: ", filename, "\n"))
cat(paste0("Input metadata file: ", metadata_file, "\n"))
cat(paste0("Input expression file: ", expression_file, "\n"))


counts = readr::read_csv(expression_file,show_col_types = FALSE)
metadata = readr::read_csv(metadata_file,show_col_types = FALSE)


## Cell Line annotation
cl_annot <- read_csv("https://raw.githubusercontent.com/BHKLAB-DataProcessing/Annotations/master/cell_annotation_all.csv")

cell_lines <- metadata$cell_line %>% unique()


cell_lines %in% cl_annot$unique.cellid
