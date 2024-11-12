library(rtracklayer)
library(liftOver)
library(GenomicRanges)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

IM <- as.data.frame(fread('Immune.tsv'))
IM$MAF <- 1-IM$Freq1
head(IM)


chainobjexct <- import.chain('hg19ToHg38.over.chain')
IM$new_chr <- paste0("chr",IM$CHR)
IM$hg19_bp <- IM$BP
IM$startField <- IM$BP
IM$endField <- IM$BP

grGWAS2 <- makeGRangesFromDataFrame(
  IM,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T)

results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_bp <- results$start
head(results)



subset_results_hg38 <- results[, c("CHR", "SNP", "A1", "A2", "Beta", "P","SE", "hg38_bp","MAF"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
head(subset_results_hg38)

# Specify the file name
output_file <- "IM_hg38.txt"

# Write the datIMame to a tab-delimitIM text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name
