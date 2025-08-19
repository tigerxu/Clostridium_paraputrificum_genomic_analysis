# BiocManager::install("ggimage", force = TRUE)

library(ggtreeExtra)
library(ggtree)
library(ggplot2)
library(ggnewscale)
library(treeio)
library(tidytree)
library(dplyr)
library(ggstar)

tree <- read.tree("42strainsFastTree-edit-midpoint.tre")

tree
ggtree(tree, layout="rectangular", branch.length = 'branch.length')

#Linking metadata to your tree data allows you to add specific annotations

metadata <- read.csv("41GCF-and-CP_SH01-metadata-final.csv", header = TRUE)

tippoint.colours <- c("Blood" = "red",
                      "Stool" = "magenta",
                      "Gut" = "darkgreen",
                      "-" = "grey")

tree1 <- ggtree(tree, layout="rectangular") %<+% metadata + xlim(NA, 2) + 
  geom_tippoint(aes(color = Source),
                size = 5,
                show.legend = TRUE) +
  geom_tiplab(align=TRUE, linetype='dashed', 
              size=4,
              offset = 0.03,
              linesize=.3) + 
  scale_color_manual(values = tippoint.colours,
                     limits = c("Blood", "Stool", "Gut", "-"),
                     labels = c("Blood", "Stool", "Gut", "Unknown")) + geom_treescale()
tree1 


# gheatmap
heatmapData = read.csv("42-genome-host.csv", row.names = 1)
rn <- rownames(heatmapData)
heatmapData <- as.data.frame(sapply(heatmapData, as.character))
rownames(heatmapData) <- rn

colorHost <- c("Human" = "orange", 
               "Mouse" = "blue",
               "-" = "grey")

tree2 <- gheatmap(tree1, heatmapData,
                  color = NULL,
                  offset = 0.25, 
                  width = 0.1,
                  colnames_position = "top",
                  colnames_offset_y = 0.5,
                  font.size = 5,
                  colnames = TRUE) +
  scale_fill_manual(name="Host",
                    values = colorHost,
                    labels = c("Human", "Mouse", "Unknown"),
                    limits = c("Human", "Mouse", "-")) 
tree2


tree3 <- tree2 + new_scale_fill()
tree4 <-  tree3 + 
  geom_tiplab(aes(label=Year),
               align = TRUE,
               size= 4,
               linetype=NA,
               offset= 0.43,
              as_ylab = FALSE,
               hjust=0)  +
  geom_tiplab(aes(label=Country),
              align = T,
              linetype = NA,
              size= 4,
              offset=0.52,
              hjust=0) +
  geom_tiplab(aes(label=Strain),
              align = T,
              linetype = NA,
              size= 4,
              offset=0.62,
              hjust=0)

tree4 +  theme(legend.position = c(.10, .82),
               legend.title=element_text(size=14), # The size should be adjusted with different devout.
               legend.text=element_text(size=12),
               legend.spacing.y = unit(0.2, "cm"))          

ggsave("42-CP-genomes-SNP-tree.pdf", width = 18, height = 10, dpi = 1200)
ggsave("42-CP-genomes-SNP-tree.svg", width = 18, height = 10, dpi = 1200)


