source("/home/suwu/github/pyEIF/Script/Load.R")

.path <- file.path(output_directory,"ProcessedData","EIF_COR_PRO_sig.csv")

assign("EIF_COR_PRO_sig",
       data.table::fread(.path ,data.table = FALSE) %>% 
         remove_rownames %>% 
         column_to_rownames(var="Gene_Symbol")) 

gene_ht1 <- ComplexHeatmap::Heatmap(
  as.matrix(EIF_COR_PRO_sig),
  heatmap_legend_param = list(
    title_gp = grid::gpar(fontsize = 12, fontface = "bold"), 
    labels_gp = grid::gpar(fontsize = 8, fontface = "bold"),
    title = "corr coefficient",
    legend_width = grid::unit(6, "cm"),
    direction = "horizontal",
    title_position = "lefttop"
  ),
  column_title = paste("Differential correlation heatmap"),
  column_title_gp = grid::gpar(fontsize = 15, fontface = "bold"),
  column_names_gp = grid::gpar(fontsize = 12, fontface = "bold"),
  column_names_rot = 0,
  
  show_row_names = FALSE,
  row_names_gp = grid::gpar(fontsize = 6),
  row_split = 4,
  #row_km = 4,
  row_title = "cluster %s",
  row_title_gp = grid::gpar(fontsize = 15, fontface = "bold"),
  row_dend_reorder = TRUE,
  cluster_row_slices = FALSE,
  border = TRUE #,
  #col = circlize::colorRamp2(
  #  c(-1, 0, 1),
  #  c("navy", "white", "firebrick3"))
)
gene_ht <- ComplexHeatmap::draw(gene_ht1,
                                merge_legends = TRUE,
                                heatmap_legend_side = "bottom",
                                annotation_legend_side = "bottom")

#pdf(file.path(path = output_directory,filename = "diff cor heatmap.pdf"),
pdf(file.path(output_directory, "Fig3","diff cor heatmap.pdf"),
width = 8,
height = 10,
useDingbats = FALSE
)
gene_ht1 <- ComplexHeatmap::draw(gene_ht)
dev.off()


.get_cluster_genes <- function(df1, df2) {
  cluster.geneID.list <- function(cluster_label) {
    c1 <- row.names(df1[ComplexHeatmap::row_order(df2)[[cluster_label]], ]) %>%
      as.data.frame(stringsAsFactors = FALSE) %>%
      stats::setNames("gene") %>%
      mutate(gene = str_replace_all(gene, " .*", ""))
    write.csv(c1, file= file.path(output_directory,"ProcessedData", 
                                  paste0("cluster", cluster_label,".csv")),
              row.names=FALSE)
    c1$entrez <- AnnotationDbi::mapIds(org.Hs.eg.db::org.Hs.eg.db,
                                       keys = toupper(c1$gene),
                                       column = "ENTREZID",
                                       keytype = "SYMBOL",
                                       multiVals = "first"
    )
    c1 <- stats::na.omit(c1)
    return(c1$entrez)
  }
  cluster.num <- c(1:4)
  names(cluster.num) <- paste("cluster", 1:4)
  return(lapply(cluster.num, cluster.geneID.list))
}


.cluster_pathway_analysis <- function(df) {
  ck.REACTOME <- clusterProfiler::compareCluster(
    geneClusters = df,
    readable = T,
    pvalueCutoff = 0.01,
    fun = "enrichPathway",
  )
  
  ck.REACTOME@compareClusterResult[["Description"]] <- gsub(
    "Homo sapiens\r: ", "", ck.REACTOME@compareClusterResult[["Description"]]
  )
  return(ck.REACTOME)
}
# ck.REACTOME <- .cluster_pathway_analysis(cluster.data)

.pathway_dotplot <- function(df, pathway) {
  p1 <- clusterProfiler::dotplot(df, 
                                 title = paste("The Most Enriched", 
                                               pathway, 
                                               "Pathways in CORs"),
                                 showCategory = 6,
                                 font.size = 10 #,
                                 #includeAll = FALSE
  ) +
    theme_bw() +
    theme(
      plot.title = black_bold_14,
      axis.title = element_blank(),
      axis.text.x = black_bold_12,
      axis.text.y = black_bold_12,
      axis.line.x = element_line(color = "black"),
      axis.line.y = element_line(color = "black"),
      panel.grid = element_blank(),
      legend.title = black_bold_12,
      legend.text = black_bold_12,
      strip.text = black_bold_12
    )
  print(p1)
  
  ggplot2::ggsave(
    path = file.path(output_directory,"Fig3"),
    filename = "pathway cluster.pdf",
    plot = p1,
    width = 9,
    height = 10,
    useDingbats = FALSE
  )
  
  return(NULL)
}
#.pathway_dotplot(df = ck.REACTOME, gene_name = "EIF3E", pathway = "REACTOME")

.plot_cluster_gene_network <- function(data, cluster_number) {
  p2 <- enrichplot::cnetplot(ReactomePA::enrichPathway(
    gene = data[[paste("cluster", cluster_number)]],
    pvalueCutoff = 0.05,
    readable = TRUE) %>%
      DOSE::setReadable("org.Hs.eg.db", "ENTREZID"),
    # layout = "kk",
    #colorEdge = TRUE,
    showCategory = 10,
    cex_label_category = 1.2,
    categorySize = "pvalue",
    cex_gene = 1.5,
    cex_label_gene = 0.8
  ) +
    ggtitle(paste("cluster", cluster_number)) +
    theme(plot.title = element_text(hjust = 0.5))
  print(p2)
  
  ggplot2::ggsave(
    path = file.path(output_directory, "Fig3"),
    filename = paste("COR","cluster", cluster_number, "cnet",".pdf"),
    plot = p2,
    width = 9,
    height = 9,
    useDingbats = FALSE
  )
  
}
#.plot_cluster_gene_network(data = cluster.data, cluster_number = 4, gene_name = "PIK3CA")

cluster.data <- .get_cluster_genes(df1 = as.matrix(EIF_COR_PRO_sig), 
                                   df2 = gene_ht)
ck.REACTOME <- .cluster_pathway_analysis(cluster.data)
.pathway_dotplot(df = ck.REACTOME,  pathway = "REACTOME")
lapply(c(1,2,3,4), 
       data = cluster.data, 
       .plot_cluster_gene_network)








