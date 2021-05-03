library(data.table)

download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fips
baltimoreVehiclesNEI <- vehiclesNEI[fips == "24510",]

png("plot5.png")

ggplot(baltimoreVehiclesNEI, aes(factor(year), Emissions)) + geom_bar(stat = "identity", fill = "#FF9999", width = 0.75) + labs(x = "year", y = expression("Total PM"[2.5]* "Emission (10^5 Tons)")) + labs(title = expression("PM"[2.5]* "Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()