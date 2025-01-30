library(qqman)

afr <- fread('filtered/afr_final_new.txt')
afr <- afr %>% rename( 'BP' = 'POS')
head(afr)
amr <- fread('filtered/amr_final_new.txt')
amr <- amr %>% rename( 'BP' = 'POS')
eur <- fread('filtered/eur_final_new.txt')
eur <- eur %>% rename( 'BP' = 'POS')

afr$P <- afr$`p-value`
afr <- afr[!is.na(afr$P), ]
manhattan(afr, main = "Manhattan Plot (AFR)", col = c("black", "gray"))

amr$P <- amr$`p-value`
amr <- amr[!is.na(amr$P), ]
manhattan(amr, main = "Manhattan Plot (AMR)", col = c("black", "gray"))

eur$P <- eur$`p-value`
eur <- eur[!is.na(eur$P), ]
manhattan(eur, main = "Manhattan Plot (EUR)", col = c("black", "gray"))
head(eur)

meta <- read.table("/Users/asgelz01/Downloads/METAL/build/bin/METAANALYSIS1_nonfilter.TBL", header = TRUE)
head(meta)

meta$P <- meta$`p-value`
meta <- meta[!is.na(meta$P), ]
manhattan(meta, main = "Manhattan Plot (meta)", col = c("black", "gray"))

