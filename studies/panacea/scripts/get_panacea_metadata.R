


library(tidyverse)


## Input handling ----------------------
# Define the command-line options
option_list <- list(
    optparse::make_option(c("-d", "--destination_dir"), type = "character", default = ".", help = "Destination directory"),
    optparse::make_option(c("-f", "--filename"), type = "character", default = "expression.csv", help = "Output filename"),
    optparse::make_option(c("-i", "--input_file"), type = "character", help = "Input expression file")
)

# Parse the command-line options
opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

# Extract the input arguments
destination_dir <- opt$destination_dir
filename <- opt$filename
input_file <- opt$input_file

# Print the input arguments for confirmation
cat(paste0("Destination directory: ", destination_dir, "\n"))
cat(paste0("Output filename: ", filename, "\n"))
cat(paste0("Input expression file: ", input_file, "\n"))


counts = readr::read_csv(input_file,show_col_types = FALSE,n_max = 5)


meta_data = tibble(sampleid = colnames(counts)[-1]) %>%
    separate(sampleid,into = c("cell_line","treatmentid","dose","time"),sep = "_",remove = FALSE) %>%
    mutate(dose = as.numeric(dose)) %>%
    mutate(time = gsub("\\.\\.\\.[0-9]+","",x=time)) 


meta_data %>% readr::write_csv(file = file.path(destination_dir,filename))



