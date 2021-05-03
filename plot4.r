library(data.table)

download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Subset NEI data by Baltimore
baltimoreNEI <- NEI[fips == "24510",]

png("plot3.png")

ggplot(baltimoreNEI, aes(factor(year), Emissions, fill = type)) + geom_bar(stat = "identity") + facet_grid(.~type, scales = "free", space = "free") + labs(x = "year", y = expression("Total PM"[2.5]* "Emission (Tons)")) + labs(title = expression("PM"[2.5]* "Emissions, Baltimore City 1999-2008 by Source Type"))

dev.off()

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))



# Subset coal combustion related NEI data
combustionRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case = TRUE)
coalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case = TRUE) 
combustionSCC <- SCC[combustionRelated & coalRelated, SCC]
combustionNEI <- NEI[NEI[,SCC] %in% combustionSCC]

png("plot4.png")

ggplot(combustionNEI, aes(x = factor(year), y = Emissions/10^5)) + geom_bar(stat = "identity", fill ="#FF9999", width = 0.75) + labs(x = "year", y = expression("Total PM"[2.5]* "Emission (10^5 Tons)")) + labs(title = expression("PM"[2.5]* "Coal Combustion Source Emissions Across US from 1999-2008"))

dev.off()