library(rtracklayer)
library(liftOver)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

ipsych <- as.data.frame(fread('iPSYCH-PGC_ASD_Nov2017.gz'))
head(ipsych)

chainobjexct <- import.chain('hg19ToHg38.over.chain')
ipsych$new_chr <- paste0("chr",ipsych$CHR)
ipsych$hg19_bp <- ipsych$BP
ipsych$startField <- ipsych$BP
ipsych$endField <- ipsych$BP

grGWAS2 <- makeGRangesFromDataFrame(
  ipsych,seqnames.field = 'new_chr',keep.extra.columns = T)


results<- as.data.frame(liftOver(grGWAS,chainobjexct))
results$hg38_bp <- results$start
head(results)

subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "INFO", "OR", "SE", "P", "hg38_bp"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
head(subset_results_hg38)


#############LOG(OR)############
subset_results_hg38$LOG <- log10(subset_results_hg38$OR)
head(subset_results_hg38)


# Specify the file name
output_file <- "iPSYCH-PGC_ASD_Nov2017_hg38.txt"

# Write the dataframe to a tab-delimited text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name

