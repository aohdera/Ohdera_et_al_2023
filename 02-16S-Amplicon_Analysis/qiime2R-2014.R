library(qiime2R)
library(ggplot2)
library(dplyr)
library(tibble)
metadata<-read_q2metadata("../01-RUN_2014/metadata.run1.txt")
uwunifrac<-read_qza("../01-RUN_2014/core-metrics-results/unweighted_unifrac_pcoa_results.qza")
uwu_filt<-read_qza("../01-RUN_2014/core-metrics-results-filtered/unweighted_unifrac_pcoa_results.qza")
wu_filt<-read_qza("../01-RUN_2014/core-metrics-results-filtered/weighted_unifrac_pcoa_results.qza")
shannon<-read_qza("../01-RUN_2014/core-metrics-results/shannon_vector.qza")
shannon_filt<-read_qza("../01-RUN_2014/core-metrics-results-filtered/shannon_vector.qza")
shannon<-shannon$data %>% rownames_to_column("SampleID") # this moves the sample names to a new column that matches the metadata and allows them to be merged
shannon_filt<-shannon_filt$data %>% rownames_to_column("SampleID")

uwunifrac$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(metadata) %>%
  left_join(shannon) %>%
  ggplot(aes(x=PC1, y=PC2, color=location, shape=degradation)) +
  geom_point(alpha=1) + #alpha controls transparency and helps when points are overlapping
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="PCOA") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="location")
ggsave("unWeightedPCoA.png", height=4, width=5, device="png") # save a PDF 3 inches by 4 inches

uwu_filt$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(metadata) %>%
  left_join(shannon_filt) %>%
  ggplot(aes(x=PC1, y=PC2, color=location, shape=degradation)) +
  geom_point(alpha=1) + #alpha controls transparency and helps when points are overlapping
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="PCOA") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="location")
ggsave("unWeightedPCoA.filtered.png", height=4, width=5, device="png") # save a PDF 3 inches by 4 inches

wu_filt$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(metadata) %>%
  left_join(shannon_filt) %>%
  ggplot(aes(x=PC1, y=PC2, color=location, shape=degradation)) +
  geom_point(alpha=1) + #alpha controls transparency and helps when points are overlapping
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="PCOA") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="location")
ggsave("WeightedPCoA.filtered.png", height=4, width=5, device="png") # save a PDF 3 inches by 4 inches


meta<-read_q2metadata("metadata.run1.txt")
uw_ufrac<-read_qza("unweighted_unifrac_pcoa_results.qza")
shan<-read_qza("shannon_vector.qza")
shan<-shan$data %>% rownames_to_column("SampleID") # this moves the sample names to a new column that matches the metadata and allows them to be merged
shan
uw_ufrac$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(meta) %>%
  left_join(shan) %>%
  ggplot(aes(x=PC1, y=PC2, color=`location`, shape=`degradation`)) +
  geom_point(alpha=0.5) + #alpha controls transparency and helps when points are overlapping
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="State") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="Location")
ggsave("unWeightedPCoA.png", height=4, width=5, device="png") # save a PDF 3 inches by 4 inches


metadata<-read_q2metadata("metadata.txt")
wunifrac<-read_qza("weighted_unifrac_pcoa_results.qza")
shannon<-read_qza("shannon_vector.qza")$data %>% rownames_to_column("SampleID") 

#Shannon H Plotting
metadata<-
  metadata %>% 
  left_join(shannon)
metadata %>%
  filter(!is.na(shannon)) %>%
  ggplot(aes(x=`temperature`, y=shannon, fill=`temperature`)) +
  stat_summary(geom="bar", fun.data=mean_se, color="black") + #here black is the outline for the bars
  geom_jitter(shape=21, width=0.2, height=0) +
  coord_cartesian(ylim=c(2,7)) + # adjust y-axis
  facet_grid(~`species`) + # create a panel for each body site
  xlab("Temperature") +
  ylab("Shannon Diversity") +
  theme_q2r() +
  scale_fill_manual(values=c("cornflowerblue","indianred")) + #specify custom colors
  theme(legend.position="none") #remove the legend as it isn't needed
ggsave("Shannon_by_abx.pdf", height=3, width=4, device="pdf") # save a PDF 3 inches by 4 inches


#Barplot
library(tidyverse)
library(qiime2R)

SVs<-read_qza("../01-RUN_2014/run1-dada2.table.filtered.qza")$data
taxonomy<-read_qza("../01-RUN_2014/run-1.taxonomy.qza")$data %>% parse_taxonomy()
taxasums<-summarize_taxa(SVs, taxonomy)$Family
taxa_barplot(taxasums, metadata, "location", ntoplot = 20)
ggsave("barplot.silva20.pdf", height=4, width=8, device="pdf") # save a PDF 4 inches by 8 inches

#Heatmap
taxa_heatmap(taxasums, metadata, "degradation", ntoplot=35)
ggsave("heatmap.silva.pdf", height=4, width=8, device="pdf") # save a PDF 4 inches by 8 inches

