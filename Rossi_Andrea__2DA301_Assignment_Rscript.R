# DA301: Advanced Analytics for Organisational Impact

# These scripts accompanied and complement the analysis for Turtle Games,
# consistent with the historical preferences and established workflow of the 
# sales department in utilizing this tool.
#
# This will allow the sales team to implement your analysis internally. 

# In R, we will perform statistical analysis to evaluate the distribution of 
# loyalty points (performance of loyalty system) and usability of data for 
# predictive modelling.  


###############################################################################

# Import  Libraries
library(dplyr)
library(ggplot2)
library(corrplot)
library(moments)
library(psych)

# Import and Describe the Data 

# Set working directory (N.B Change with your Environment Directory)
setwd(dir = "C:/Users/rossi/OneDrive/Desktop/Advance Statistics with Python and R. Turtle Games")

#Import data 
data <- read.csv(file.choose(),header=TRUE)

#Sense Check Data 
head(data)
str(data)

# Check missing values
missing_values <- sum(is.na(data))
print(missing_values)

# Check duplicated values 
num_duplicates <- sum(duplicated(data))
print(num_duplicates)

# Remove unnecessary columns  
data <- data %>% select(-review,-summary, product)

# Look at summary distribution 
summary(data)

# Look at report for full picture. 
DataExplorer:: create_report(data)


# 1) Exploratory Data Analysis. 

# Determine mean value variable for plotting 
mean_loyalty_points <- mean(data$loyalty_points)
print(mean_loyalty_points)

median_loyalty_points <- median(data$loyalty_points)


# Visualise Loyalty points Distribution with mean line

ggplot(data, aes(x = loyalty_points)) +
  geom_histogram(binwidth = 200, fill = "blue", color = "red", alpha = 0.6) +
  geom_vline(aes(xintercept = median_loyalty_points, color = "Median"), linetype = "dashed", size = 1) +
  labs(title = "Distribution of Loyalty Points", x = "Loyalty Points", y = "Frequency") +
  scale_x_continuous(breaks = seq(0, max(data$loyalty_points), by = 1000)) +
  scale_color_manual(name = "Statistics", values = c("Median" = "red")) +
  theme_minimal()



# Visualize distribution of Loyalty Points to display outliers differently.  

# Boxplot of Loyalty Points
ggplot(data, aes(y = loyalty_points)) +
  geom_boxplot(fill = 'grey80', notch = TRUE, outlier.colour = 'black') +
  labs(title = "Boxplot of Loyalty Points", y = "Loyalty Points") 
  
  
  
# Measures of Shape
  
# Shapiro-Wilk test for normality
shapiro.test(data$loyalty_points)

# Skewness Test 
skewness(data$loyalty_points)

# Kurtosis Test 
kurtosis(data$loyalty_points)

# Determine Range
range_loyalty_points <- range(data$loyalty_points)

# Calculate Difference between highest and lowest values
difference_high_low <- diff(range(data$loyalty_points))

# Calculate Interquartile Range (IQR)
iqr_loyalty_points <- IQR(data$loyalty_points)

# Calculate Standard Deviation
std_deviation_loyalty_points <- sd(data$loyalty_points)

# Display results
results <- list(
  Range = range_loyalty_points,
  Difference = difference_high_low,
  IQR = iqr_loyalty_points,
  Standard_Deviation = std_deviation_loyalty_points
)
print(results)




###########################################################################
# From our exploratory analysis we can conclude that loyalty points are not 
# normally distributed (w= 0.84), are positively skewed (skewness= 1.46) and
# exhibit heavy tail and sharper peak (Kurtosis = 4.70), suggesting the presence 
# of outlier and a concentration of values around the mean.
# 
#
#Loyalty points accumulated show high variability, with many customers having
#low frequencies and some being outliers. The high IQR (979.25) indicates that 
# even the middle 50% of the data spans a considerable range of points.
# (See data summary for more details.)

#For the business this suggest diverse spending and engagement behaviors and 
# opportunities of different engagement and targeted segmentation.

#############################################################################

# Visualise how loyalty points relate to Income, Spending Score and Age. (add best
# line of fit for visualisation in Technical Report)

# Scatterplot of Loyalty Points  vs Spending Score
ggplot(data, aes(x = spending_score, y = loyalty_points )) +
  geom_point(alpha = 0.5)+
  geom_smooth(method = "lm", se = FALSE, color = 'Red') +
  labs(title = "Loyalty Points vs Spending", x = "Spending Score", y = "Loyalty Points")+
  theme_minimal()


# Scatterplot of Loyalty Points vs Income
ggplot(data, aes(x = income, y = loyalty_points)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = 'Red') +
  labs(title = "Loyalty Points vs Income", x = "Income (£000s)", y = "Loyalty Points")+
  theme_minimal()

# Scatterplot of Loyalty Points  vs Age
ggplot(data, aes(x = age, y = loyalty_points)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = 'Red') +
  labs(title = "Loyalty Points vs Age", x = "Age (Years)", y = "Loyalty Points")+
  theme_minimal()




# Calculate Correlation 
# Create a subset of data with numerical variables only. 
numeric_data <- data %>%
  select_if(is.numeric)

# Calculate the correlation matrix
correlation_matrix <- cor(numeric_data, use = "complete.obs")
# View Matrix 
print(correlation_matrix)


corPlot(wine, cex = 2, overlay = FALSE)

###############################################################################
# see full observation on Jupyter Notebook. 

# Summary:
# Moderate-high correlation income vs loyalty points
# Moderate-high correlation spending score  vs loyalty points

# These shows some linearity but for customers with spending score of 60 or 
# yearly income of data are more spread out. 

# Age- loyalty point were found not correlated. 

###############################################################################

# Linear Regression for Predictive Modelling 

# N.b - The presence of highly skewed variables influence the distribution 
# of residuals making them, in turn, non-normal. We will check the distribution of
# residuals from MLR here, however for full details, see the Jupyter Notebook. 


# Create the multiple linear regression model
model <- lm(loyalty_points ~ income + spending_score, data = data)

summary(model)

###############################################################################
# R-squared : 84% of variation of loyalty points is explained by these variables 
# 
#
# Max and Min Residuals values (errors) are high, which indicate the presence of
# outliers and lack of fit for those extreme values.
# 50 % of data are within -350 and 291 loyalty points off.
# Residual standard error: 513.8  gives an idea of the average distance that the observed values fall from the regression line.
# Median residuals are however low, which is not bad. It indicates that the median
# prediction (central tendency) is far of observed value of 4.61 loyalty points. 
# 


#Check distribution of residuals 

# Get the model residuals
model_residuals = model$residuals

# Plot the result
hist(model_residuals)


# View residuals on a plot
plot(model$residuals)

#add a horizontal line at 0 
abline(0,0)


# Visualise Model Performance

# Plot actual vs. predicted values 
ggplot(data, aes(x = loyalty_points, y = predict(model, data))) +
  geom_point() +
  stat_smooth(method = "loess") + 
  labs(x = 'Observed Loyalty Points', y = 'Predicted Loyalty Points') +
  ggtitle('Observed vs. Predicted Loyalty Points')+
  theme_minimal()



##############################################################################

# Distribution of residuals is non normal. Despite the high correlation and hence 
# high R-squared the model has poor fit because the relationship between predictors 
# target variables is not entirely linear. 

# To this end, we will transform our target variable 
###############################################################################

# Transform 
data <- mutate(data,sqrt_loyalty_points = sqrt(loyalty_points))

# Check distribution of transformed loyalty points
hist(data$sqrt_loyalty_points)

# Check normality 
# Shapiro-Wilk test for normality
shapiro.test(data$sqrt_loyalty_points)

# Skewness Test 
skewness(data$sqrt_loyalty_points)

# Kurtosis Test 
kurtosis(data$sqrt_loyalty_points)

# Q-Q Plot
qqnorm(data$sqrt_loyalty_points)
qqline(data$sqrt_loyalty_points, col = "red")


################################################
# Whilst Skewness (0.45435) and Kurtosis (3.143861) test indicate a fairly normal 
# distribution, Shapiro test indicate not normal gaussian distribution. This is 
# not unusual since the Shapiro test is sensisitive to large datasets, where 
# even small deviations from normality can result in very low p-values.

#
# QQplot shows how bulk of the data is approximately normally distributed 
# after the square root transformation however lower and upper tails
# deviate from the red line, indicating that the data is not perfectly normally
# distributed in the extremes. 
#
# We can conclude that the distribution is fairly normal 
#############################################################################

# Run the MLR on transformed target variable
model_2 <- lm(sqrt_loyalty_points ~ income + spending_score, data = data)

summary(model_2)


# Transform back the predicted values to original scale to allow comparison with
# actual data

predicted_loyalty_sqrt <- predict(model_2, data)
predicted_original_scale <- predicted_loyalty_sqrt^2


# Plot Residuals  

ggplot(data, aes(x = loyalty_points, y = predicted_original_scale)) +
  geom_point() +
  stat_smooth(method = "loess") + 
  labs(x = 'Observed Loyalty Points', y = 'Predicted Loyalty Points') +
  ggtitle('Observed vs. Predicted Loyalty Points')

#############################################################################

# The linear line of fit suggests that the model is performing well overall
# in predicting loyalty points. 
#
#However error in prediction tend to be especially true for the extremes, indicating
#
# 
#specially for very low and very high values, indicating that the
#

############################################################################

# Check Predictions with new data

# Example with 3 new customer: 
# Customer a: Income =20, Spending Score = 27, Age = 35
# Customer b: Income =60, Spending Score = 71, Age = 43
# Customer c: Income =80, Spending Score = 59, Age = 60


new_data <- data.frame(income = c(20,60,80), spending_score = c(27,71,59))

# Predict Loyalty Points with new customers
predictions <- predict(model_2, new_data)
print(predictions)




