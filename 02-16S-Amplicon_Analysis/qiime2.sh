#https://qiime2.org/
#qiime2 ver. 2021.4

#import raw reads
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path manifest.csv --output-path paired-end-demux.qza --input-format PairedEndFastqManifestPhred33V2

#dada2: trim, filter, merge
qiime dada2 denoise-paired --i-demultiplexed-seqs paired-end-demux.qza --p-trunc-len-f 250 --p-trunc-len-r 180  --p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-q 2 --o-table dada2-table.qza --o-representative-sequences dada2-rep-seqs.qza --o-denoising-stats denoise.statsqiime feature-table tabulate-seqs --i-data rep-seqs.qza --o-visualization rep-seqs.qzv
qiime feature-table filter-features --i-table dada2.table.qza --p-min-frequency 5 --p-min-samples 2 --o-filtered-table dada2.table.filtered.qza
qiime feature-table summarize --i-table dada2.table.filtered.qza --o-visualization dada2.table.filtered.qzv --m-sample-metadata-file metadata.txt

＃calculate alpha diversity
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences dada2-rep-seqs.qza --o-alignment aligned-rep-seqs.qza --o-masked-alignment masked-aligned-rep-seqs.qza --o-tree unrooted-tree.qza --o-rooted-tree rooted-tree.qza
qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree.qza --i-table dada2-table.qza --p-sampling-depth 9999 --m-metadata-file metadata.txt --output-dir core-metrics-results

qiime diversity alpha-group-significance --i-alpha-diversity core-metrics-results/faith_pd_vector.qza --m-metadata-file metadata.run1.txt --o-visualization core-metrics-results/faith_pd_vector.qzv
qiime diversity alpha-group-significance --i-alpha-diversity core-metrics-results/evenness_vector.qza --m-metadata-file metadata.run1.txt --o-visualization core-metrics-results/evenness-group-significance.qzv
qiime diversity beta-group-significance --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza --m-metadata-file metadata.txt --m-metadata-column degradation --o-visualization core-metrics-results/unweighted_unifrac-degradation-significance.qzv --p-pairwise

#perform permanova analysis
beta-group-significance --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza --m-metadata-file metadata.txt --m-metadata-column location --p-method permanova --p-pairwise TRUE --p-permutations 9999 --o-visualization core-metrics-results/permanova-wunifrac.qzv
