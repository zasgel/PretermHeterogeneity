library(rtracklayer)
library(liftOver)
library(GenomicRanges)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

ED <- as.data.frame(fread('pgcAN2.2019-07.vcf.tsv'))
IM$MAF <- 1-IM$Freq1
head(ED)


chainobjexct <- import.chain('hg19ToHg38.over.chain')
ED$new_chr <- paste0("chr",ED$CHROM)
ED$hg19_bp <- ED$POS
ED$startField <- ED$POS
ED$endField <- ED$POS

grGWAS2 <- makeGRangesFromDataFrame(
  ED,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T)

results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_bp <- results$start
head(results)



subset_results_hg38 <- results[, c("CHROM", "SNP", "A1", "A2", "BETA", "P","SE", "hg38_bp"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_bp"] <- "BP"
head(subset_results_hg38)

# Specify the file name
output_file <- "ED_hg38.txt"

# Write the datEDame to a tab-delimited text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Compress the file using gzip
system(paste("gzip", output_file))# Specify the file name
