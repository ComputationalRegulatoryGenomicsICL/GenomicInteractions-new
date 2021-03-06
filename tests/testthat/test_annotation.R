# test extraction of feature names from GRanges
data("mm9_refseq_promoters")
promoters <- head(mm9_refseq_promoters)
promoters_list <- head(split(mm9_refseq_promoters, mm9_refseq_promoters$id))

test_that("Feature names can be extracted from GRanges and GRangeslist objects", {
  promoter_names <- c("Dnajc3","NR_045746", "NR_033541", "NR_045747", "NR_046064", "NR_033535")
  promoter_ids <- c("100037258", "100038602", "100038608", "100038659", "100038728", "100038734")
  tx_names <- c("NM_008929", "NR_045746", "NR_033541", "NR_045747", "NR_046064", "NR_033535")
  
  expect_equal(.get_gr_names(promoters), promoter_names)
  # check extraction using id.col
  expect_equal(.get_gr_names(promoters, id.col = "id"), promoter_ids)
  expect_equal(.get_gr_names(promoters, id.col = "tx_name"), tx_names)
  expect_error(.get_gr_names(promoters, id.col = "x"))
  
  # check behaviour when no possible names present
  mcols(promoters) <- NULL
  expect_warning(.get_gr_names(unname(promoters)), "Ranges are not named and no ID column specified; using numeric IDs")
  expect_equal(suppressWarnings(.get_gr_names(unname(promoters))), as.character(1:6))
  
  # check behaviour for GRangesList
  expect_equal(.get_gr_names(promoters_list), promoter_ids)
  expect_warning(.get_gr_names(unname(promoters_list)), "GRangesList is not named; using numeric IDs")
  expect_equal(suppressWarnings(.get_gr_names(unname(promoters_list))), as.character(1:6))
  })

# test annotation
gi <- new("GenomicInteractions",
          metadata = list(experiment_name="test", description = "this is a test"),
          anchor1 = as.integer(c(1, 7, 8, 4, 5)),
          anchor2 = as.integer(c(6, 2, 10, 9, 3)),
          regions = GRanges(seqnames = S4Vectors::Rle(factor(c("chr1", "chr2")), c(6, 4)),
                            ranges = IRanges(start = c(1,6,3,4,5,7,2,3,4,5),
                                             width = c(10,9,6,7,6,10,9,8,7,8)),
                            strand = S4Vectors::Rle(c("+", "-", "+", "-"), c(2,4,1,3)),
                            seqinfo = Seqinfo(seqnames = paste("chr", 1:2, sep=""))),
          elementMetadata = DataFrame(counts = 1:5))

promoters <- GRanges(seqnames = S4Vectors::Rle(factor(c("chr1", "chr2")), c(2, 1)),
                     ranges = IRanges(c(9, 14, 11), width = 4:6),
                     strand = S4Vectors::Rle(strand(c("+", "-", "-"))),
                     seqinfo = Seqinfo(seqnames = paste("chr", 1:2, sep="")),
                     id = paste0("P", 1:3))

# Annotation by overlaps
annotateInteractions(gi, list(promoter = promoters), id.col = "id")

test_that("Annotate interactions returns expected results", {
  expect_node_class_one <- c("promoter", rep("distal", 4))
  expect_node_class_two <- c(rep("promoter", 3), rep("distal", 2))
  
  expect_ids_one <- c("P1", as.list(rep(NA, 4)))
  expect_ids_two <- c(c("P2", "P1","P3", as.list(rep(NA, 2))))
  
  expect_equal(anchorOne(gi)$node.class, expect_node_class_one)
  expect_equal(anchorTwo(gi)$node.class, expect_node_class_two)
  
  expect_equal(anchorOne(gi)$promoter.id, expect_ids_one)
  expect_equal(anchorTwo(gi)$promoter.id, expect_ids_two)
  })

## Annotation by setting mcols

# ## test summarisation
# 
# test_that("summariseByFeatures results are the same as before", {
#   expect_equal_to_reference(summariseByFeatures(gi, promoters, feature.name = "promoter"),
#                             file = "summariseByFeatures.rds")
# })
# 
# test_that("summariseByFeaturePairs results are the same as before", {
#   expect_equal_to_reference( summariseByFeaturePairs(gi, features.one = promoters, features.two = promoters, 
#                                                      feature.name.one = "promoter", feature.name.two = "promoter"),
#                             file = "summariseByFeaturePairs.rds")
# })


## Resetting annotation
resetAnnotations(gi)

test_that("resetting annotations removes mcols", {
  expect_false("signal" %in% names(mcols(anchorOne(gi))))
  expect_false("signal" %in% names(mcols(anchorTwo(gi))))
  
  expect_false("node.class" %in% names(mcols(anchorOne(gi))))
  expect_false("node.class" %in% names(mcols(anchorTwo(gi))))
  
  expect_true(length(mcols(anchorOne(gi)))==0)
  expect_true(length(mcols(anchorTwo(gi)))==0)
})

## Distance calculations

test_that("distance calculations work as expected", {
  expect_equal(calculateDistances(gi),
               c(6, NA, 2, NA, 2))
  expect_equal(calculateDistances(gi, method = "midpoint"),
               c(6, NA, 2, NA, 2))
  expect_equal(calculateDistances(gi, method = "inner"),
               c(-4, NA, -6, NA, -4))
  expect_equal(calculateDistances(gi, method = "outer"),
               c(16, NA, 10, NA, 8))
  expect_error(calculateDistances(gi, method = "my_method"))
})

one.df <- as.data.frame(anchorOne(gi))
two.df <- as.data.frame(anchorTwo(gi))

test_that("distance calculations on dataframes work as expected", {
  expect_equal(GenomicInteractions:::.calculateDistances.df(one.df, two.df),
               calculateDistances(gi))
  expect_equal(GenomicInteractions:::.calculateDistances.df(one.df, two.df, method = "midpoint"),
               calculateDistances(gi, method = "midpoint"))
  expect_equal(GenomicInteractions:::.calculateDistances.df(one.df, two.df, method = "inner"),
               calculateDistances(gi, method = "inner"))
  expect_equal(GenomicInteractions:::.calculateDistances.df(one.df, two.df, method = "outer"),
               calculateDistances(gi, method = "outer"))
  })

