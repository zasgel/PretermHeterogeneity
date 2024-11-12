library(rtracklayer)
library(liftOver)
browseVignettes("liftOver")
browseVignettes("rtracklayer")

results <- as.data.frame(fread('Fetal_preterm_birth_NComms2019.txt'))
head(results)


chainobjexct <- import.chain('hg19ToHg38.over.chain')
results$new_chr <- paste0("chr",results$Chr)
results$hg19_BP <- results$Pos
results$startField <- results$Pos
results$endField <- results$Pos

grGWAS2 <- makeGRangesFromDataFrame(
  results,seqnames.field = 'new_chr',
  start.field = 'startField',
  end.field = 'endField',
  keep.extra.columns = T)

results<- as.data.frame(liftOver(grGWAS2,chainobjexct))
results$hg38_Pos <- results$start
results$N_total <- results$N_case + results$N_control
head(results)

subset_results_hg38 <- results[, c("Chr", "Rsid", "Effect_allele", "Non_effect_allele", "Effect", "P", "hg38_Pos",'N_total',"StdErr"), drop = FALSE]
names(subset_results_hg38)[names(subset_results_hg38) == "hg38_Pos"] <- "BP"
names(subset_results_hg38)[names(subset_results_hg38) == "Effect_allele"] <- "A1"
names(subset_results_hg38)[names(subset_results_hg38) == "Non_effect_allele"] <- "A2"
names(subset_results_hg38)[names(subset_results_hg38) == "Rsid"] <- "SNP"
names(subset_results_hg38)[names(subset_results_hg38) == "Effect"] <- "BETA"
names(subset_results_hg38)[names(subset_results_hg38) == "StdErr"] <- "SE"
head(subset_results_hg38)


# Specify the file name
output_file <- "Fetal_assoc_hg38.txt"

# Write the dataframe to a tab-delimited text file
write.table(subset_results_hg38, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Comresultsss the file using gzip
system(paste("gzip", output_file))# Specify the file name
