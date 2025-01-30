###non-filtered
meta <- read.table("/Users/asgelz01/Downloads/METAL/build/bin/METAANALYSIS1.TBL", header = TRUE)
head(meta)

names(meta)[names(meta) == "P.value"] <- "p-value"
names(meta)[names(meta) == "MarkerName"] <- "SNP"
names(meta)[names(meta) == "Effect"] <- "beta"
names(meta)[names(meta) == "StdErr"] <- "SE"
names(meta)[names(meta) == "Position"] <- "BP"
names(meta)[names(meta) == "Chromosome"] <- "CHR"
names(meta)[names(meta) == "Allele1"] <- "A1"
names(meta)[names(meta) == "Allele2"] <- "A2"
meta$A1 <- toupper(meta$A1)
meta$A2 <- toupper(meta$A2)
meta$N <- 27711
head(meta)

write.table(meta, file = 'filtered/final_meta.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

meta$CHR <- NULL
meta$BP <- NULL

write.table(meta, file = 'filtered/fuma_meta.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)


##filtered
metaf <- read.table("/Users/asgelz01/Downloads/METAL/build/bin/METAANALYSIS1_filtered.TBL", header = TRUE)
head(metaf)

names(metaf)[names(metaf) == "P.value"] <- "p-value"
names(metaf)[names(metaf) == "MarkerName"] <- "SNP"
names(metaf)[names(metaf) == "Effect"] <- "beta"
names(metaf)[names(metaf) == "StdErr"] <- "SE"
names(metaf)[names(metaf) == "Position"] <- "BP"
names(metaf)[names(metaf) == "Chromosome"] <- "CHR"
names(metaf)[names(metaf) == "Allele1"] <- "A1"
names(metaf)[names(metaf) == "Allele2"] <- "A2"
metaf$A1 <- toupper(metaf$A1)
metaf$A2 <- toupper(metaf$A2)
metaf$N <- 27711
head(metaf)


write.table(metaf, file = 'filtered/final_meta_filtered.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
