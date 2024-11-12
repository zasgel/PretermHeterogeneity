library(rtracklayer)
library(liftOver)
library(GenomicRanges)
library(data.table)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

# Correct the file extension
file_path <- 'anxiety.meta.full.fs.tbl'


# Load the data using fread and convert to data frame
AD <- as.data.frame(fread(file_path))
head(AD)
AD$MAF <- 1-AD$Freq1

chain <- import.chain("hg19ToHg38.over.chain")
AD$new_chr <- paste0("chr",AD$CHR)
AD$hg19_bp <- AD$BP
AD$startField <- AD$BP
AD$endField <- AD$BP

grGWAS2 <- makeGRangesFromDataFrame(
  AD,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T,
  na.rm=TRUE)


results <- liftOver(grGWAS2, chain)
results<- as.data.frame(results)
results$hg38_bp <- results$start
head(results)


subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "hg38_bp", "Beta", "P","StdErr", "MAF","TotalN"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
names(subset_results_hg38)[names(subset_results_hg38) == "StdErr"] <- "SE"
names(subset_results_hg38)[names(subset_results_hg38) == "TotalN"] <- "OBS_CT"
names(subset_results_hg38) <- toupper(names(subset_results_hg38))
head(subset_results_hg38)

# Specify the file name
output_file <- "AD_hg38.txt"

# Write the dataset to a tab-delMSitMS text file
write.table(subset_results_hg38, file = output_file, sep = " ", quote = FALSE, row.names = FALSE, col.names = TRUE)
write.table(subset_results_hg38, file = "AD_hg38.csv", sep = ",", quote = FALSE, row.names = FALSE, col.names = TRUE)


# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name


