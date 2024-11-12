library(rtracklayer)
library(liftOver)
library(GenomicRanges)
library(data.table)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

# Correct the file extension
file_path <- '/Users/asgelz01/Downloads/ADHD/ADHD2022_iPSYCH_deCODE_PGC.meta.gz'


# Load the data using fread and convert to data frame
ADHD <- as.data.frame(fread(file_path))
head(ADHD)

ADHD$N_total <- ADHD$Nca + ADHD$Nco
ADHD$freqA1_total <- (ADHD$Nca / ADHD$N_total) * ADHD$FRQ_A_38691 + (ADHD$Nco / ADHD$N_total) * ADHD$FRQ_U_186843
ADHD$MAF <- 1 - ADHD$freqA1_total

chain <- import.chain("hg19ToHg38.over.chain")
ADHD$new_chr <- paste0("chr",ADHD$CHR)
ADHD$hg19_bp <- ADHD$BP
ADHD$startField <- ADHD$BP
ADHD$endField <- ADHD$BP

grGWAS2 <- makeGRangesFromDataFrame(
  ADHD,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T,
  na.rm=TRUE)


results <- liftOver(grGWAS2, chain)
results<- as.data.frame(results)
results$hg38_bp <- results$start
head(results)


subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "hg38_bp", "OR", "P","SE","MAF","N_total"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
subset_results_hg38$LOG <- log10(subset_results_hg38$OR)
head(subset_results_hg38)

# Specify the file name
output_file <- "ADHD_hg38.txt"

# Write the dataset to a tab-delMSitMS text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name


