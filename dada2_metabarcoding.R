## Installation

install.packages('BiocManager')
BiocManager::install('dada2')


library(dada2)


## Filtering and Trimming

# setting up path to data
dataPath <- 'data'

rawForward <- list.files(dataPath, pattern="_R1_001.fastq", full.names = TRUE)
rawReverse <- list.files(dataPath, pattern="_R2_001.fastq", full.names = TRUE)
sampNames <- gsub('data/|_.*', '', rawForward)

# check quality
plotQualityProfile(rawForward)
plotQualityProfile(rawReverse)

# filtering
filterPath <- file.path(dataPath, "filtered")

filterForward <- file.path(filterPath,
                           paste0(sampNames, "_R1_trimmed.fastq.gz"))

filterReverse <- file.path(filterPath,
                           paste0(sampNames, "_R2_trimmed.fastq.gz"))


out <- filterAndTrim(fwd = rawForward, filt = filterForward, 
                     rev = rawReverse, filt.rev = filterReverse, 
                     compress = TRUE, multithread = TRUE)

head(out)

## Learn the Error Rates

errorsForward <- learnErrors(filterForward, multithread = TRUE)
errorsReverse <- learnErrors(filterReverse, multithread = TRUE)

plotErrors(errorsForward, nominalQ = TRUE)
plotErrors(errorsReverse, nominalQ = TRUE)


## Dereplication

derepForward <- derepFastq(filterForward, verbose = TRUE)
derepReverse <- derepFastq(filterReverse, verbose = TRUE)

names(derepForward) <- sampNames
names(derepReverse) <- sampNames

## Sequence inference

dadaForward <- dada(derepForward, err = errorsForward, multithread = TRUE)
dadaReverse <- dada(derepReverse, err = errorsReverse, multithread = TRUE)

dadaForward
dadaReverse

## Merge Paired-end Reads

merged <- mergePairs(dadaForward, derepForward, 
                     dadaReverse, derepReverse, 
                     verbose = TRUE)

# inspect the merger data.frame from the first sample
head(merged[[1]])


## Construct ASV Table

seqTab <- makeSequenceTable(merged)
dim(seqTab)

# inspect distribution of sequence lengths
table(nchar(getSequences(seqTab)))


## Remove Chimeras

seqTabClean <- removeBimeraDenovo(seqTab, method = 'consensus',
                                  multithread = TRUE, verbose = TRUE)
dim(seqTabClean)

# which percentage of our reads did we keep?
sum(seqTabClean) / sum(seqTab)


