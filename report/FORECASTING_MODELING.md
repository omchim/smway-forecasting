# CO₂ Emissions Forecasting

## Overview
This project aims to forecast CO₂ emissions across multiple countries using historical data. By analyzing emissions from the mid-20th century to present, we built models to predict emissions for the years 2021 and 2022. Several preprocessing techniques, feature engineering, and different forecasting strategies were applied to develop an accurate model.

`For each section, you'll find a more detailed description within the notebook itself.<br/>`

## 1. Variable Analysis & Selection

### Excluded Variables
  - **Code**: Redundant with Country and will not be used.<br/>
  - **Population**: Only available for 2020, making it unreliable for historical forecasting.<br/>
  - **Density**: Derived from 2020 population data and remains constant across years, making it irrelevant.<br/>

### Retained & Processed Variables
  - **Calling Code**: Kept as it provides regional information useful for emissions patterns. Missing values were filled with corresponding country codes.<br/>
  - **CO₂ Emissions**: Zero emissions are treated as missing values.<br/>
  - **Area & % of World**: Only % of World retained due to high correlation with Area. Antarctica’s value was set artificially low to avoid misleading the model.<br/>
  - **Area**: Stable since 1950, treated as a fixed variable.<br/>

### Modeling Considerations
  - **Developing Countries**: Their data is less reliable due to imputation.<br/>
  - **Developed Countries**: Start reporting earlier and may provide more reliable data for forecasting.<br/>

## 2. Data Analysis

### 1. Variable Correlations & Insights
  - **Area and % of World**: Highly correlated; only % of World retained.<br/>
  - **Calling Code and Emissions**: Slight negative correlation, indicating that countries with lower calling codes tend to have higher emissions.<br/>
  - **Year and Emissions**: Positive correlation, suggesting an upward trend in emissions.<br/>

### 2. Country Size & Emissions
  - **Large Countries**: Countries like the USA, Russia, and China became major contributors post-1950. 
  - **Before 1900**: Emissions were dominated by smaller Western European countries.<br/>
  - **Post-1950 Data**: Considered more reliable for forecasting due to better representation of current global emissions trends.<br/>

### 3. Preprocessing Considerations
  - **Non-stationarity**: The data exhibits trends, requiring detrending or feature engineering.<br/>
  - **Residuals**: After modeling, residuals show no systematic errors, indicating the model could potentially capture essential data patterns.<br/>

### 4. Modeling Approach
  - **Data Post-1950**: Focused on data after 1950 to ensure reliability.<br/>
  - **Preferred Models**: Tree-based models like LightGBM preferred for their ability to handle non-stationary data better than ARIMA or linear regression.<br/>

### 5. Key Considerations for Forecasting
  - **High Variance**: The USA’s emissions dominate the dataset. Handling this high variance during model evaluation is crucial.<br/>

## 3. Feature Engineering

  - **Categorical Encoding**: LabelEncoder was used to encode categorical variables.<br/>
  - **Size Category**: Grouped countries into categories (e.g., "Very Large," "Large") based on their % of World value.<br/>
  - **Region Based on Calling Code**: The first digit of the calling code provides regional context.<br/>
  - **Log Transformation**: Applied to CO₂ emissions to handle large variations across countries.<br/>
  - **Calling Zone**: Categorized countries based on their calling codes (<100 for higher emitters, ≥100 for low emitters).<br/>
  - **Z-Score Detrending**: Applied to capture trends in the data while avoiding data leakage.<br/>
  - **Imputation**: Missing values were imputed using global growth patterns or real-world data.<br/>

## 4. Modeling

### Models Used
  - **Moving Average**: Used as a baseline with detrending feature.<br/>
  - **LightGBM**: Chosen as the primary model due to its strong performance in similar tasks.<br/>

### Forecasting Strategies
  - **Recursive Forecasting**: One year’s forecast is used as feature to predict the next year.<br/>
  - **Direct Forecasting**: A hybrid approach where we predict the first year, integrate the result into training data, and then rebuild the model to forecast the second year. Our version is optimized for only two-year-ahead forecasting.<br/>

### Evaluation Metrics
 For evaluation, we use **RMSE** as our primary metric because:
   - It penalizes large errors more, which is crucial when forecasting emissions, especially for small emitters.<br/>
   - It is expressed in the same unit as CO₂ emissions, making it more interpretable.<br/>

## 5. Evaluation

### **Baseline Model (Moving Average)**:
- A **moving average model** was used as a baseline.<br/>
- The **window size of 2 years** was found to yield the best results.<br/>
- The **average RMSE** from cross-validation (2010-2020) was **747.88 million**, which served as the baseline for comparison.<br/>

### **LightGBM Model**:
- **2019 and 2020** were used as test data.<br/>
- A **LightGBM model** was tested with **recursive forecasting** and **z-score detrending**, but the results were poorer, with an **RMSE of 36.31 trillion**.<br/>
- A **log-transformed model** also did not provide promising results.<br/>
- A **simple LightGBM configuration** with **recursive forecasting**, without detrending or log transformation, yielded better results with an **RMSE of 601.66 million**, surpassing the baseline.<br/>
- The **linear_tree = True** parameter was used to reduce the RMSE from **800 million** to **600 million**. This adjustment allowed the model to capture **local linear trends**, which were particularly beneficial for this problem.<br/>
- The model used **40 years of lag** and did not incorporate **trend features** at this stage.<br/>

### **Direct Forecasting**:
- With **trend features** such as **trend_squared** and **trend_exp**, the results significantly improved, achieving an **RMSE of 288 million**.<br/>
- The inclusion of the **first emission year** as a feature also improved the model, reducing the error by **40 million**.<br/>
- After testing various features, the most effective features were:
  - **Country**
  - **First digit from Calling Code** (representing region)
  - **Lag emissions** (up to 40 years)
  - **% of World**
  - **Trend squared and trend exponential**
  - **Calling Zone**
  - **First emission year**
- A final test with just the **first digit**, **% of world**, and **lag features** showed slight improvements in results.<br/>

### **Cross-validation Results (2014-2020)**:
- After running **cross-validation** from 2014-2020, using different lag values (from 2 to 40), while a **2-year lag** achieved the lowest average RMSE (**270 million**), it performed worse on recent predictions compared to a **24-year lag**, which better captured recent trends.  .<br/>
- For larger lags (greater than 2), the RMSE increased to over **350 million**.<br/>

### **LightGBM Hyperparameter Tuning**:
- Various **hyperparameters**, including **learning rate (0.1)** and **number of iterations (2000)**, were optimized for better model performance.<br/>
- The final parameters used for forecasting the years 2021 and 2022 were:

```python
lgb_params = {
    'objective': 'regression',
    'metric': 'rmse',
    'boosting_type': 'gbdt',
    'num_leaves': 64,
    'learning_rate': 0.01,
    'feature_fraction': 0.9,
    'num_iterations': 2000,
}
```
## 6. Forecasting 2021 - 2022

The forecasted emissions for 2021, and 2022 were:

- **2020**: 1.493036e+12
- **2021**: 1.533395e+12
- **2022**: 1.577771e+12

**Growth Rate Calculation:**

- **Growth rate from 2020 to 2021**:  2.68%

- **Growth rate from 2021 to 2022**:  3.2%


## 7. Next Steps
To enhance model performance and explore new opportunities, the following steps are recommended:<br/>
-  **Data Expansion**: Adding external data such as GDP or livable area could further refine predictions.<br/>
-  **Model Exploration**: Experiment with additional models to compare with LightGBM.<br/>
-  **Detrending Alternatives**: Explore other detrending techniques.<br/>
-  **Hyperparameter Tuning**: Further tune hyperparameters to improve model accuracy.<br/>

## 8. Conclusion**
By focusing on post-1950 data and applying feature engineering techniques, we successfully predicted emissions for 2021 and 2022 with reasonable accuracy, with a 3.2% growth rate from 2021 to 2022. However, there is still room for improvement, and incorporating additional data sources and refining the model could enhance predictions in future iterations.
