#---
#title: "Chlorophyll a averaging"
#format: html
#editor: visual
#author: Jonathan & Olivier
#---

install.packages("dplyr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("tidync")
install.packages("doParallel")
install.packages("rerddap")
install.packages("plyr")
install.packages("ncdf4")
install.packages("tidyverse")
install.packages("viridis")
install.packages("heatwaveR")
install.packages("na.tools")
install.packages("zoo")
install.packages("gganimate")
install.packages("knitr")

library("dplyr")
library("lubridate")
library("ggplot2")
library("tidync")
library("doParallel")
library("rerddap")
library("plyr")
library("ncdf4")
library("tidyverse")
library("viridis")
library("heatwaveR")
library("na.tools")
library("zoo")
library("gganimate")
library("knitr")


rm(list = ls())
filename = paste0('IMOS_aggregation_20230717T022328Z.nc')
nc <- nc_open("IMOS_aggregation_20230717T022328Z.nc")

#------------------------------------------------------------------------------------------------------

chl <- ncvar_get(nc, varid = 'chl_oc3')


num_obs <- dim(nc$dim$time$vals)

data.list <- vector("list", num_obs)

for (i in 1:num_obs) {
  data <- data.frame(chlorophyll = chl[ , ,i])
  data.list[[i]] <- data
}


spatav_exp3 <- function(df) {
  col_means = sapply(df, function(x) mean(x, na.rm = T))
  point_mean = mean(col_means)
  return(point_mean)
}


results <- data.frame()

for (i in seq_along(data.list)) {
  current_results <- spatav_exp3(data.list[[i]]) 
  results <- rbind(results, current_results)
}


interp <- function(x) {
  na_indices <- which(is.nan(x))
  for (i in na_indices) {
    left_val <- NA
    right_val <- NA
    
    if (i > 1) {
      left_val <- x[i - 1]
    }
    if (i < length(x)) {
      right_val <- x[i + 1]
    }
    x[i] <- mean(c(left_val, right_val), na.rm = T)
  }
  return(x)
}


chl.interp <- interp(results$X0.376462923946287)
chl.interp <- data.frame(chl.interp)

date_string <- data.frame(nc$dim$time$vals)

date.fin <- as.Date(date_string$nc.dim.time.vals)
date.POSIX <- as.POSIXct(date.fin, origin = "1990-1-1", tz = "GMT")


t <- data.frame(date.fin)


years_to_add = 20


chla <- data.frame(t = t$date.fin, Chla = chl.interp$chl.interp)
chla$t <- as.POSIXct(chla$t, format = "y%/m%/d%")

chla$t <- chla$t + years(years_to_add)

plot(chla)

#--------------------------------------------------------------------------------------------
#zoom on summer 21/22

# Convert the 'date.fin' column to Date format
chla$t <- as.Date(chla$t)

# Subset the data for the desired time range (December 2021 to February 2022)
start_date <- as.Date("2021-12-01")
end_date <- as.Date("2022-02-28")
chla_subset <- subset(chla, t >= start_date & t <= end_date)

# Plot the data using ggplot2
library(ggplot2)

ggplot(chla_subset, aes(x = t, y = Chla)) +
  geom_line() +
  labs(title = "Chlorophyll Concentration",
       x = "Date: 2021/22", y = "Chla") +
  theme_minimal()

#-------------------------------------------------------------------------------

# Convert the 'date.fin' column to Date format
chla$t <- as.Date(chla$t)

# Subset the data for the desired time range (December to February)
subsetDF_chla <- chla %>%
  filter(month(t) %in% c(12, 1, 2))

# Extract day and month from the 't' column
subsetDF_chla <- subsetDF_chla %>%
  mutate(day = day(t), month = month(t))



#--------------------------------------------------------------
# Create an empty dataframe to store the averages
averages_df <- data.frame(Day_Month = character(), Average_Chla = numeric(), stringsAsFactors = FALSE)

# Loop through unique day and month combinations
for (day_month_combo in unique(paste(subsetDF_chla$day, subsetDF_chla$month, sep = "-"))) {
  # Extract day and month from the current combination
  day_month <- strsplit(day_month_combo, "-")[[1]]
  day <- as.integer(day_month[1])
  month <- as.integer(day_month[2])
  
  # Subset the data for the current day and month
  subset_data <- subsetDF_chla %>%
    filter(day == day_month[1], month == day_month[2])
  
  # Calculate the average 'Chla' for the current group
  avg_chla <- mean(subset_data$Chla, na.rm = TRUE)
  
  # Create a new row as a single-row dataframe with the calculated average
  new_row <- data.frame(
    Day_Month = paste(day, month, sep = "-"),  # Combine day and month into one column
    Average_Chla = avg_chla
  )
  
  # Append the new row to the existing dataframe
  averages_df <- rbind(averages_df, new_row)
}


#--------------------------------------------------------------------------------
#Daily averages for summer months

# Convert Day_Month to factor and manually set the order of levels
averages_df$Day_Month <- factor(averages_df$Day_Month,
                                levels = c(paste(1:31, 12:12, sep = "-"),
                                           paste(1:31, 1:1, sep = "-"),
                                           paste(1:29, 2:2, sep = "-")))

# Create the ggplot with vertical labels
ggplot(averages_df, aes(x = Day_Month, y = Average_Chla, group = 1)) +
  geom_line(colour = "chartreuse4") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))