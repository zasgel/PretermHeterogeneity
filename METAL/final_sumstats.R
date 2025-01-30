afr <- fread("allchr_finalrs_afr_new.txt")
amr <- fread("allchr_finalrs_amr_new.txt")
eur <- fread("allchr_finalrs_eur_new.txt")

###AFR
afr$TEST <- NULL
afr$L95 <- NULL
afr$U95 <- NULL
afr$T_STAT <- NULL
afr$ALT <- NULL
afr$A1_CT <- NULL
names(afr)[names(afr) == "P"] <- "p-value"
names(afr)[names(afr) == "OBS_CT"] <- "N"
names(afr)[names(afr) == "REF"] <- "A2"
names(afr)[names(afr) == "CHROM"] <- "CHR"


afr$SNP <- sub(".*_(rs[0-9]+).*", "\\1", afr$ID)
afr$LOG <- log(afr$OR)
head(afr)

write.table(afr, file = 'filtered/afr_final_new.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

afr$beta <- log(afr$OR)
afr[, abs_beta := abs(beta)] 

cutoff_95_beta <- quantile(afr$abs_beta, 0.95, na.rm = T)
cleaned_afr_95 <- afr[!is.na(afr$abs_beta) & afr$abs_beta <= cutoff_95_beta, ]

cleaned_afr_95$abs_beta <- NULL
cleaned_afr_95$beta <- NULL

write.table(cleaned_afr_95, file = 'afr_final_new_beta.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)


###AMR
amr$TEST <- NULL
amr$L95 <- NULL
amr$U95 <- NULL
amr$T_STAT <- NULL
amr$ALT <- NULL
amr$A1_CT <- NULL
names(amr)[names(amr) == "P"] <- "p-value"
names(amr)[names(amr) == "OBS_CT"] <- "N"
names(amr)[names(amr) == "REF"] <- "A2"
names(amr)[names(amr) == "CHROM"] <- "CHR"

amr$SNP <- sub(".*_(rs[0-9]+).*", "\\1", amr$ID)
amr$LOG <- log(amr$OR)
head(amr)

write.table(amr, file = 'filtered/amr_final_new.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

amr$beta <- log(amr$OR)
amr[, abs_beta := abs(beta)] 

cutoff_95_beta <- quantile(amr$abs_beta, 0.95, na.rm = T)
cleaned_amr_95 <- amr[!is.na(amr$abs_beta) & amr$abs_beta <= cutoff_95_beta, ]

cleaned_amr_95$abs_beta <- NULL
cleaned_amr_95$beta <- NULL
head(cleaned_amr_95)

write.table(cleaned_amr_95, file = 'amr_final_new_beta.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)


###EUR
eur$TEST <- NULL
eur$L95 <- NULL
eur$U95 <- NULL
eur$T_STAT <- NULL
eur$ALT <- NULL
eur$A1_CT <- NULL
names(eur)[names(eur) == "P"] <- "p-value"
names(eur)[names(eur) == "OBS_CT"] <- "N"
names(eur)[names(eur) == "REF"] <- "A2"
names(eur)[names(eur) == "CHROM"] <- "CHR"

eur$SNP <- sub(".*_(rs[0-9]+).*", "\\1", eur$ID)
eur$LOG <- log(eur$OR)
head(eur)

write.table(eur, file = 'filtered/eur_final_new.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

eur$beta <- log(eur$OR)
eur[, abs_beta := abs(beta)] 

cutoff_95_beta <- quantile(eur$abs_beta, 0.95, na.rm = T)
cleaned_eur_95 <- eur[!is.na(eur$abs_beta) & eur$abs_beta <= cutoff_95_beta, ]

cleaned_eur_95$abs_beta <- NULL
cleaned_eur_95$beta <- NULL
head(cleaned_eur_95)


write.table(cleaned_eur_95, file = 'eur_final_new_beta.txt', sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#######distribution
positive_cutoff <- log(cutoff_95_beta)
negative_cutoff <- -log(cutoff_95_beta)
par(mfrow = c(1, 2))
hist(afr$beta, breaks = 30, main = "Distribution of Effect Sizes", 
     xlab = "Effect Size", col = "gray80", border = "black")
abline(v = positive_cutoff, col = "black", lwd = 2, lty = 2) 
abline(v = negative_cutoff, col = "black", lwd = 2, lty = 2) 

hist(cleaned_afr_95$beta, breaks = 30, main = "Filtered Effect Sizes", 
     xlab = "Effect Size", col = "gray80", border = "black") 




