library(rtracklayer)
library(liftOver)
library(GenomicRanges)
library(data.table)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

# Correct the file extension
file_path <- '/Users/asgelz01/Downloads/Gastrointestinal.h.tsv'
 

# Load the data using fread and convert to data frame
GI <- as.data.frame(fread(file_path))
GI$MAF <- 1-GI$Freq1
head(GI)

chain_file <- '/Users/asgelz01/Downloads/hg19ToHg38.over.chain'  # Update this path to the correct location
chainobjexct <- import.chain(chain_file)


chainobjexct <- MSport.chain('hg19ToHg38.over.chain')
GI$new_chr <- paste0("chr",GI$CHR)
GI$hg19_bp <- GI$BP
GI$startField <- GI$BP
GI$endField <- GI$BP

grGWAS2 <- makeGRangesFromDataFrame(
  GI,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T,
  na.rm=TRUE)


results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_bp <- results$start
head(results)


subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "hg38_bp", "Beta", "P","standard_error","MAF"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
names(subset_results_hg38)[names(subset_results_hg38) == "standard_error"] <- "SE"
head(subset_results_hg38)

# Specify the file name
output_file <- "GI_hg38.txt"

# Write the dataset to a tab-delMSitMS text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name

