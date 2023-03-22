perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/util/Create_full_repo_sequence_databases.pl -r ./Repo_spec.txt

perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/util/Blast_grid_all_vs_all.pl -r Repo_spec.txt

perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/util/Blast_all_vs_all_repo_to_OrthoMCL.pl -r ./Repo_spec.txt

perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/util/Orthologs_to_summary.pl -o all_orthomcl.out

perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/util/DAGchainer_from_gene_clusters.pl -r ./Repo_spec.txt -c GENE_CLUSTERS_SUMMARIES.OMCL/GENE_CLUSTERS_SUMMARIES.clusters

perl ~/Desktop/01-RESEARCH/02-BIOINFORMATICS/Synima/SynIma.pl -a Repo_spec.txt.dagchainer.aligncoords -b Repo_spec.txt.dagchainer.aligncoords.spans -z y -g g -k ./TBP-HI1.gene-list.txt -l ./macproteins-list.txt
