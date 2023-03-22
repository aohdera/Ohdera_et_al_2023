library(ggplot2)
library(ggpubr)
library(dplyr)

cx <- read.table("cx_substrate_settlement.txt",header=TRUE)
cx <- as.data.frame(cx)
cx.deep <- filter(cx, depth == "deep")
cx.shal <- filter(cx,depth=="shallow")
#Plot figure 1A
cx.deep$treatment <- factor(cx.deep$treatment, levels=unique(cx.deep$treatment))
ggplot(cx.deep, aes(x = treatment, y = settlement))+geom_boxplot(outlier.color="black",outlier.shape=16,outlier.size=2,size=0.75)+theme(axis.title=element_text(size=20,face="bold"),axis.text=element_text(color="black",size=16, face="bold"),panel.background=element_blank(),axis.line=element_line(color="black",size=1),axis.text.x = element_text(angle = 45, vjust = 0.8, hjust=0.8,face="bold",size=12))+labs(title="deep",y="% Settled and Metamrophosed")+ylim(0,100)
#statstics
shapiro.test(cx.deep$settlement)
kruskal.test(settlement ~ treatment, data=cx.deep)
pairwise.wilcox.test(cx.deep$settlement, cx.deep$treatment,p.adjust.method = "BH",exact=FALSE)

#Plot figure 1B
cx.shal$treatment <- factor(cx.shal$treatment, levels=unique(cx.shal$treatment))
ggplot(cx.shal, aes(x = treatment, y = settlement))+geom_boxplot(outlier.color="black",outlier.shape=16,outlier.size=2,size=0.75)+theme(axis.title=element_text(size=20,face="bold"),axis.text=element_text(color="black",size=16, face="bold"),panel.background=element_blank(),axis.line=element_line(color="black",size=1),axis.text.x = element_text(angle = 45, vjust = 0.8, hjust=0.8,face="bold",size=12))+labs(title="deep",y="% Settled and Metamrophosed")+ylim(0,100)
#statstics
shapiro.test(cx.shal$settlement)
kruskal.test(settlement ~ treatment, data=cx.shal)
pairwise.wilcox.test(cx.shal$settlement, cx.shal$treatment,p.adjust.method = "BH",exact=FALSE)
