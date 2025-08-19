library(ggplot2)
count<-read.table("countCOG-inputR-Cparaputrificum.tsv", header = T, check.names = F,sep="\t")

countonly <- as.matrix(count[,c(2:4)])

datCOG <- data.frame(Group = rep(count$`COG category`, each = 3),
                  Sub   = factor(names(count)[2:4],
                                 levels = names(count)[c(2,3,4)]),
                  Value = as.vector(t(countonly)))
datCOG <- within(datCOG,
                 Position <- factor(Group,
                                    levels = as.character(unique(Group))))

p <- ggplot(datCOG, aes(x=Position, y = Value))
p <- p + theme_bw() + theme(panel.grid = element_blank())
p <- p + theme(axis.text.x = element_text(angle = 45,  size=10, face = "bold", hjust = 1))
p <- p + geom_bar(aes(fill = Sub), stat="identity", position = "dodge", width=.5)
p <- p + scale_fill_manual(values = c("#5B9BD5", "#ED7D31", "#A5A5A5"))
  p <- p + labs(title = "",  y = "Proportion (%)", x = "COG functional category")
  p <- p + guides(fill=guide_legend(title= "Class"))
  p <- p + theme(axis.title.y = element_text(size = 12,  face = "bold", angle = 90, margin=margin(0,20,0,0)))
  p <- p + theme(axis.title.x = element_text(size = 12,  face = "bold", angle = 00, margin=margin(30,0,0,0)))
  p <- p + theme(plot.margin = unit(c(0,1,1,2), "cm"))
  p <- p + ylim(0, 20)
  p <- p + theme(legend.position = c(.86, .81))
  p

  ggsave("pangenome-COG-histogram.svg",
         width = 40,
         height = 20,
         units = "cm")
  
  ggsave("pangenome-COG-histogram.pdf",
         width = 40,
         height = 20,
         units = "cm")