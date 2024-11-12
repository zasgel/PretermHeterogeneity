library(rtracklayer)
library(liftOver)
library(GenomicRanges)
library(data.table)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

# Correct the file extension
file_path <- 'pgc-bip2021-all.vcf.tsv'


# Load the data using fread and convert to data frame
BIP <- as.data.frame(fread(file_path))
head(BIP)

BIP$N_total <- BIP$N_CAS + BIP$N_CON
BIP$freqA1_total <- (BIP$N_CAS / BIP$N_total) * BIP$FCAS + (BIP$N_CON / BIP$N_total) * BIP$FCON
BIP$MAF <- 1 - BIP$freqA1_total


chainobjexct <- import.chain("hg19ToHg38.over.chain")
BIP$new_chr <- paste0("chr",BIP$CHROM)
BIP$hg19_bp <- BIP$POS
BIP$startField <- BIP$POS
BIP$endField <- BIP$POS

grGWAS2 <- makeGRangesFromDataFrame(
  BIP,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T,
  na.rm=TRUE)


results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_bp <- results$start
head(results)



subset_results_hg38 <- results[, c("CHROM", "SNP", "A1", "A2", "hg38_bp", "BETA", "P","SE", "MAF","N_total"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
names(subset_results_hg38)[names(subset_results_hg38) == "CHROM"] <- "CHR"
head(subset_results_hg38)

# Specify the file name
output_file <- "BIP_hg38.txt"

# Write the dataset to a tab-delMSitMS text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name


