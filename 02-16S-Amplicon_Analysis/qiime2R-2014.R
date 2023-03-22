library(qiime2R)
library(ggplot2)
library(dplyr)
library(tibble)

metadata<-read_q2metadata("metadata.txt")
uwu<-read_qza("unweighted_unifrac_pcoa_results.qza")
wu<-read_qza("weighted_unifrac_pcoa_results.qza")
shannon<-read_qza("shannon_vector.qza")
shannon<-shannon$data %>% rownames_to_column("SampleID") #  move the sample names to a new column that matches the metadata and merge
shannon_filt<-shannon_filt$data %>% rownames_to_column("SampleID")

uwu$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(metadata) %>%
  left_join(shannon) %>%
  ggplot(aes(x=PC1, y=PC2, color=location, shape=depth)) +
  geom_point(alpha=1) + 
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="PCOA") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="location")
ggsave("unWeightedPCoA.png", height=4, width=5, device="png")  

wu$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(metadata) %>%
  left_join(shannon_filt) %>%
  ggplot(aes(x=PC1, y=PC2, color=location, shape=depth)) +
  geom_point(alpha=1) + #alpha controls transparency and helps when points are overlapping
  theme_q2r() +
  scale_shape_manual(values=c(16,1), name="PCOA") + #see http://www.sthda.com/sthda/RDoc/figure/graphs/r-plot-pch-symbols-points-in-r.png for numeric shape codes
  scale_size_continuous(name="Shannon Diversity") +
  scale_color_discrete(name="location")
ggsave("WeightedPCoA.png", height=4, width=5, device="png") # save a PDF 3 inches by 4 inches

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

SVs<-read_qza("dada2.table.filtered.qza")$data
taxonomy<-read_qza("taxonomy.qza")$data %>% parse_taxonomy()
taxasums<-summarize_taxa(SVs, taxonomy)$Family
taxa_barplot(taxasums, metadata, "location", ntoplot = 20)
ggsave("barplot.silva20.pdf", height=4, width=8, device="pdf") # save a PDF 4 inches by 8 inches

#Heatmap
taxa_heatmap(taxasums, metadata, "location", ntoplot=35)
ggsave("heatmap.silva.pdf", height=4, width=8, device="pdf") # save a PDF 4 inches by 8 inches

