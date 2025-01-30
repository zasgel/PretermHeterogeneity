# nonf-filtered
afr <- read.table("filtered/afr_final_new.txt", header = TRUE)
amr <- read.table("filtered/amr_final_new.txt", header = TRUE)
eur <- read.table("filtered/eur_final_new.txt", header = TRUE)

# Find common SNPs
common_snps <- Reduce(intersect, list(afr$SNP, amr$SNP, eur$SNP))

# Write the common SNPs to a file
write.table(common_snps, "filtered/common_snps.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

# Subset files based on common SNPs
afr_common <- afr[afr$SNP %in% common_snps, ]
amr_common <- amr[amr$SNP %in% common_snps, ]
eur_common <- eur[eur$SNP %in% common_snps, ]

head(afr_common)

# Save the filtered files
write.table(afr_common, "filtered/finalrs_afr_common.txt", row.names = FALSE, quote = FALSE, sep = "\t")
write.table(amr_common, "filtered/finalrs_amr_common.txt", row.names = FALSE, quote = FALSE, sep = "\t")
write.table(eur_common, "filtered/finalrs_eur_common.txt", row.names = FALSE, quote = FALSE, sep = "\t")

# filtered
afrf <- read.table("filtered/afr_final_new_beta.txt", header = TRUE)
amrf <- read.table("filtered/amr_final_new_beta.txt", header = TRUE)
eurf <- read.table("filtered/eur_final_new_beta.txt", header = TRUE)

# Find common SNPs
common_snpsf <- Reduce(intersect, list(afrf$SNP, amrf$SNP, eurf$SNP))

# Write the common SNPs to a file
write.table(common_snps, "filtered/common_snps_filtered.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

# Subset files based on common SNPs
afr_commonf <- afrf[afrf$SNP %in% common_snpsf, ]
amr_commonf <- amrf[amrf$SNP %in% common_snpsf, ]
eur_commonf <- eurf[eurf$SNP %in% common_snpsf, ]

head(afr_commonf)

# Save the filtered files
write.table(afr_commonf, "filtered/finalrs_afr_common_filtered.txt", row.names = FALSE, quote = FALSE, sep = "\t")
write.table(amr_commonf, "filtered/finalrs_amr_common_filtered.txt", row.names = FALSE, quote = FALSE, sep = "\t")
write.table(eur_commonf, "filtered/finalrs_eur_common_filtered.txt", row.names = FALSE, quote = FALSE, sep = "\t")

