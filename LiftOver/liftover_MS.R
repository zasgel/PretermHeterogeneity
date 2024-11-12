library(rtracklayer)
library(liftOver)
library(GenomicRanges)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

# Correct the file extension
file_path <- '/Users/asgelz01/Downloads/musculoskeletal.h.tsv.gz'

# Load the data using fread and convert to data frame
library(data.table)
MS <- as.data.frame(fread(file_path))
MS$MAF <- 1-MS$hm_effect_allele_frequency
head(MS)


chainobjexct <- import.chain("hg19ToHg38.over.chain")
MS$new_chr <- paste0("chr",MS$CHR)
MS$hg19_bp <- MS$BP
MS$startField <- MS$base_pair_location
MS$endField <- MS$BP

grGWAS2 <- makeGRangesFromDataFrame(
  MS,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T,
  na.rm=TRUE)

results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_bp <- results$start
head(results)



subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "Beta", "P","StdErr", "hg38_bp","MAF"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
names(subset_results_hg38)[names(subset_results_hg38) == "StdErr"] <- "SE"
head(subset_results_hg38)

# Specify the file name
output_file <- "MS_hg38.txt"

# Write the datMSame to a tab-delMSitMS text file
write.table(subset_results_hg38, file = output_file, sep = " ", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name

