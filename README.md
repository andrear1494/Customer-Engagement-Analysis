## Project Overview
I have been engaged by Turtle Games, a global game manufacturer and retailer that produces and sells its own products, as well as sources and sells products manufactured by other companies. Their product range includes books, board games, video games, and toys. This analysis will utilize customer review data (turtle_review.csv) to provide insights into various key strategic objectives with the ultimate aim of improving overall sales performance, customer retention and marketing approach.

In particular, this notebook will focus on the following objectives defined by Turtle Games: 
- Determine how customers accumulate loyalty points 
- Exploring the structure of data using decision trees 
- Exploring clusters in customer behaviour 
- Determine if can social data (e.g. customer reviews) be used in marketing campaigns.

Further statistical analysis and modelling will be instead performed in R consistent with the historical preferences and established workflow of the sales department in utilizing this tool. In R, we will evaluate the current performance of the loyalty points system and assess wheather the data can effectively support predictive modelling

## Data Source: 
turtle_reviews.csv 
metadata_turtle_games

**Analytical Approach**

1) **Business Problem Definition.**

2) **Data ingestion and Wrangling.**
Involved: cleaning for missing values, handling duplicates, and transforming data to ensure it was suitable for statistical modeling and machine learning.

3) **Analysis of variables influencing loyalty points accumulation.**
We performed linear regression to compute the influence of income and spending score change in loyalty points. MLR model was able to explain high variation of loyalty points, however heteroskedasticy and non linear patterns in distribution of residuals, confirmed poor fit and presence of underlying factors that the MLR was not able to capture. 

4) **Analysis of Feature importance with Decision Tree to handle non linearity.** 
Employing a Decision tree regressor allowed us to handle the non linearity observed and to better understand the structure found in the data, including, with feature importance ananlysis different categorical variables that could explain how customer engage with loyalty points. 

5) **Clustering with K-Means.**
Given the importance of income and spending score identified in previous analyses, K-Means clustering was performed to segment customers based on these attributes. This clustering analysis provides actionable insights into different customer segments, guiding targeted marketing efforts and personalized strategies for maximizing loyalty program effectiveness.

6) **Analysis of Sentiments:** to gauge opinions and customer satisfaction towards Turtle Games products. Sentiment is analysed through TextBlob after comparison with Vader's outputs on negative reviews through oversampling. 
Manual testing was conducted on three separate data frames. In this dataset, lengthy reviews  affected VADER's accuracy, while TextBlob exhibited high false negatives, notably misclassifying true positive reviews. Due to the higher risk associated with negative reviews for Turtle Games, we opted for TextBlob despite itsdrawbacks. These outputs were used to calculate sentiment across marketing segments and visualized using grouped chart.Findings should be interpreted cautiously but provide a foundation for automating
sentiment analysis. For future analysis, I recommend using VADER for short texts and TextBlob for longer reviews or employing advanced pretrained BERT models through PyTorch for contextual understanding.

See the report_pdf for the full methodological approach and insights.
