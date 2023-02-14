


library(tidyverse)


## Input handling ----------------------
# Define the command-line options
option_list <- list(
    optparse::make_option(c("-d", "--destination_dir"), type = "character", default = ".", help = "Destination directory"),
    optparse::make_option(c("-f", "--filename"), type = "character", default = "expression.csv", help = "Output filename"),
    optparse::make_option(c("-i", "--input_files"), type = "character", help = "Input expression files")
)

# Parse the command-line options
opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

# Extract the input arguments
destination_dir <- opt$destination_dir
filename <- opt$filename
input_files <- strsplit(opt$input_files, ",")[[1]]

# Print the input arguments for confirmation
cat(paste0("Destination directory: ", destination_dir, "\n"))
cat(paste0("Output filename: ", filename, "\n"))
cat(paste0("Input expression files: ", input_files, "\n"))




list_counts <- lapply(input_files, function(inpF){
    
    counts <- readr::read_csv(file.path(destination_dir,inpF),show_col_types = FALSE) 
    
    cell_line <- strsplit(inpF,"_")[[1]][[2]]
    
    colnames(counts)[[1]] <- "gene_name"
    colnames(counts)[-1] = paste(cell_line, colnames(counts)[-1],sep = "_")
    counts$gene_name <- as.character(counts$gene_name)
    return(counts)
}) 

# make sure that the genes are matching between each table, before concatenating the columns
for(i in 1:(length(list_counts)-1)){
    for(j in 2:length(list_counts)){
        stopifnot(all(list_counts[[i]]$gene_name == list_counts[[j]]$gene_name))
    }
}

all_counts <- list_counts %>% purrr::reduce(.f = left_join,by="gene_name")

# Convert Entrez ID to gene symbols: 

annots <- AnnotationDbi::select(org.Hs.eg.db::org.Hs.eg.db, keys=as.character(all_counts$gene_name),
                 columns=c("SYMBOL"), keytype="ENTREZID")

all_counts <- all_counts %>% dplyr::mutate(gene_name = as.character(gene_name)) %>% 
    dplyr::left_join(annots, by = c(gene_name = "ENTREZID")) %>%
    dplyr::select(SYMBOL, everything(),-gene_name) %>% dplyr::filter(!is.na(SYMBOL))


all_counts %>% readr::write_csv(file = file.path(destination_dir,filename))



