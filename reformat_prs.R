BIP <- fread("bip2024_afr_no23andMe")
head(BIP)
BIP$LOG <- log(BIP$OR)

write.table(BIP, file = 'bip2024_afr_no23andMe.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

BIP <- fread("bip2024_multianc_no23andMe.txt")
head(BIP)
BIP$LOG <- log(BIP$OR)
BIP$Direction <- NULL

write.table(BIP, file = 'bip2024_multianc_no23andMe.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

BIP$N <- BIP$Nca + BIP$Nco

mean(BIP$N)

ANX <- fread("ANX_AMR.txt")
head(ANX)
ANX$LOG <- log(ANX$OR)

write.table(ANX, file = 'ANX_AMR.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)


gwas_data <- fread("ANX_AFR.txt", header = TRUE)
gwas_data$beta <- gwas_data$Z / sqrt(2 * gwas_data$P * (1 - gwas_data$P) * gwas_data$N)
head(gwas_data)

write.table(gwas_data, file = 'ANX_AFR.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

data <- fread("ILAE_All_Epi_11.8.14.txt", header = TRUE)
data$SE <- 1 / sqrt(data$Weight)
data$Beta <- data$Zscore * data$SE
head(data)

write.table(data, file = 'ILAE_All_Epi_11.8.14.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
4452+	490708