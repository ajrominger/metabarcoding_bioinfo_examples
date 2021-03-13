n <- 8000
N <- n * 4


r11 <- scan('~/Desktop/foo/12S-mifishu-R1.fastq', what = character(),
            sep = '\n', n = N, skip = 0)
r21 <- scan('~/Desktop/foo/12S-mifishu-R2.fastq', what = character(),
            sep = '\n', n = N, skip = 0)
r12 <- scan('~/Desktop/foo/12S-mifishu-R1.fastq', what = character(),
            sep = '\n', n = N, skip = N)
r22 <- scan('~/Desktop/foo/12S-mifishu-R2.fastq', what = character(),
            sep = '\n', n = N, skip = N)


writeLines(r11, 'data/12S-myfishu-sub1_R1_001.fastq')
writeLines(r21, 'data/12S-myfishu-sub1_R2_001.fastq')
writeLines(r12, 'data/12S-myfishu-sub2_R1_001.fastq')
writeLines(r22, 'data/12S-myfishu-sub2_R2_001.fastq')

