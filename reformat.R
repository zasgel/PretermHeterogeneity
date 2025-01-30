library(data.table)
####
BIP<- as.data.frame(fread('BIP_hg38.txt'))
colnames(BIP)[colnames(BIP) == "P"] <- "p-value"
colnames(BIP)[colnames(BIP) == "N_total"] <- "N"
colnames(BIP)[colnames(BIP) == "BETA"] <- "beta"
head(BIP)
max(BIP$N_total)
write.table(BIP, file = gzfile("BIP_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####

AD<- as.data.frame(fread('AD_hg38.txt'))
colnames(AD)[colnames(AD) == "P"] <- "p-value"
colnames(AD)[colnames(AD) == "OBS_CT"] <- "N"
colnames(AD)[colnames(AD) == "BETA"] <- "beta"
AD$A1 <- toupper(AD$A1)
AD$A2 <- toupper(AD$A2)
head(AD)
max(AD$N)
write.table(AD, file = gzfile("AD_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

###

EP<- as.data.frame(fread('EP_hg38.txt'))
colnames(EP)[colnames(EP) == "P"] <- "p-value"
colnames(EP)[colnames(EP) == "OBS_CT"] <- "N"
colnames(EP)[colnames(EP) == "Beta"] <- "beta"
colnames(EP)[colnames(EP) == "Allele1"] <- "A1"
colnames(EP)[colnames(EP) == "Allele2"] <- "A2"
head(EP)
max(EP$N)

write.table(EP, file = gzfile("EP_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

####
SCZ_pri<- as.data.frame(fread('SCZ_primary.txt'))
colnames(SCZ_pri)[colnames(SCZ_pri) == "PVAL"] <- "p-value"
colnames(SCZ_pri)[colnames(SCZ_pri) == "N_total"] <- "N"
colnames(SCZ_pri)[colnames(SCZ_pri) == "BETA"] <- "beta"
colnames(SCZ_pri)[colnames(SCZ_pri) == "ID"] <- "SNP"
head(SCZ_pri)
max(SCZ_pri$N, na.rm = TRUE)

write.table(SCZ_pri, file = gzfile("SCZ_pri_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

####
SCZ_eur<- as.data.frame(fread('SCZ_eur.txt'))
colnames(SCZ_eur)[colnames(SCZ_eur) == "P"] <- "p-value"
colnames(SCZ_eur)[colnames(SCZ_eur) == "N_total"] <- "N"
colnames(SCZ_eur)[colnames(SCZ_eur) == "BETA"] <- "beta"
head(SCZ_eur)
max(SCZ_eur$N)

write.table(SCZ_eur, file = gzfile("SCZ_eur_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####
PT<- as.data.frame(fread('Fetal_assoc_hg38.txt'))
colnames(PT)[colnames(PT) == "P"] <- "p-value"
colnames(PT)[colnames(PT) == "N_total"] <- "N"
colnames(PT)[colnames(PT) == "BETA"] <- "beta"
head(PT)

max(PT$N)

duplicates_in_SNP <- PT[duplicated(PT$SNP), ]

# Print duplicate SNPs if they exist
if (nrow(duplicates_in_SNP) > 0) {
  print("Duplicate SNPs found:")
  print(duplicates_in_SNP)
} else {
  print("No duplicate SNPs")
}

PT_unique <- PT[!duplicated(PT$SNP), ]
dim(PT)
dim(PT_unique)

write.table(PT, file = gzfile("PT_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
write.table(PT_unique, file ="PT_hg38_unique.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)


#####
ED<- as.data.frame(fread('ED_hg38.txt'))
ED$N <- 72517
colnames(ED)[colnames(ED) == "P"] <- "p-value"
colnames(ED)[colnames(ED) == "BETA"] <- "beta"
head(ED)

write.table(ED, file = gzfile("ED_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####
IM<- as.data.frame(fread('IM_hg38.txt'))
IM$N <- 41530 +443068
colnames(IM)[colnames(IM) == "P"] <- "p-value"
colnames(IM)[colnames(IM) == "Beta"] <- "beta"
head(IM)

write.table(IM, file = gzfile("IM_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####
GI<- as.data.frame(fread('GI_hg38.txt'))
GI$N <- 77978 + 406620 
colnames(GI)[colnames(GI) == "P"] <- "p-value"
colnames(GI)[colnames(GI) == "Beta"] <- "beta"
head(GI)

write.table(GI, file = gzfile("GI_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####
MS<- as.data.frame(fread('MS_hg38.txt'))
MS$N <- 106605 + 377993
colnames(MS)[colnames(MS) == "P"] <- "p-value"
colnames(MS)[colnames(MS) == "Beta"] <- "beta"
head(MS)

write.table(MS, file = gzfile("MS_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#####
ASD<- as.data.frame(fread('iPSYCH-PGC_ASD_Nov2017_hg38.txt'))
ASD$N <- 18382+ 27969 
colnames(ASD)[colnames(ASD) == "P"] <- "p-value"
ASD$LOG <- log(ASD$OR)
head(ASD)

write.table(ASD, file = gzfile("PGC_ASD_hg38.txt.gz"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

max(ASD$N)
mean(ASD$N)
