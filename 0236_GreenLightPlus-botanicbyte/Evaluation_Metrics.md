The `calculate_metrics` function computes several evaluation metrics to assess the performance of the model in predicting temperature and humidity. Here's a detailed description of each metric:

### Accuracy Metrics[](#accuracy-metrics)

```python
def calculate_metrics(self, y_true, y_pred):
    metrics = {}
 
    # Initialize sum values for all metrics
    r2_temperature_sum = 0
    r2_humidity_sum = 0
    rrmse_temperature_sum = 0
    rrmse_humidity_sum = 0
    acc_sum = 0
    err_sum = 0
    temp_acc_sum = 0
    humidity_acc_sum = 0
 
    # Loop through each time step to calculate metrics
    for t in range(y_true.shape[1]):
        # R2 and RRMSE calculations
        r2_temperature_sum += r2_score(y_true[:, t, 0], y_pred[:, t, 0])
        r2_humidity_sum += r2_score(y_true[:, t, 1], y_pred[:, t, 1])
        rrmse_temperature_sum += self.calculate_rrmse(
            y_true[:, t, 0], y_pred[:, t, 0]
        )
        rrmse_humidity_sum += self.calculate_rrmse(
            y_true[:, t, 1], y_pred[:, t, 1])
 
        # Accuracy calculations
        acc, err, temp_acc, humidity_acc = self.calculate_accuracy(
            y_true[:, t, :], y_pred[:, t, :]
        )
        acc_sum += acc
        err_sum += err
        temp_acc_sum += temp_acc
        humidity_acc_sum += humidity_acc
 
    # Average metrics over all time steps
    metrics["r2_temperature"] = r2_temperature_sum / y_true.shape[1]
    metrics["r2_humidity"] = r2_humidity_sum / y_true.shape[1]
    metrics["r2_average"] = (
        metrics["r2_temperature"] + metrics["r2_humidity"]) / 2
    metrics["rrmse_temperature"] = rrmse_temperature_sum / y_true.shape[1]
    metrics["rrmse_humidity"] = rrmse_humidity_sum / y_true.shape[1]
    metrics["rrmse_average"] = (
        metrics["rrmse_temperature"] + metrics["rrmse_humidity"]
    ) / 2
 
    # Average accuracy metrics
    metrics["acc"] = acc_sum / y_true.shape[1]
    metrics["err"] = err_sum / y_true.shape[1]
    metrics["temp_acc"] = temp_acc_sum / y_true.shape[1]
    metrics["humidity_acc"] = humidity_acc_sum / y_true.shape[1]
 
    print("Metrics: ", metrics)
 
    return metrics
```

### R-squared (R2)[](#r-squared-r2)

+   `r2_temperature` and `r2_humidity` are calculated separately for temperature and humidity predictions using the `r2_score` function.
+   These are summed for each time step and then averaged across all time steps to get `metrics["r2_temperature"]` and `metrics["r2_humidity"]`.
+   `metrics["r2_average"]` is the average of `metrics["r2_temperature"]` and `metrics["r2_humidity"]`, representing the overall R2 score for both temperature and humidity predictions.

### Relative Root Mean Square Error (RRMSE)[](#relative-root-mean-square-error-rrmse)

+   This is a normalized measure of the differences between values predicted by a model and the values actually observed from the environment that is being modeled.
+   Like R2, RRMSE is also calculated separately for temperature and humidity (`rrmse_temperature` and `rrmse_humidity`), averaged over all time steps.
+   `metrics["rrmse_average"]` is the average of `metrics["rrmse_temperature"]` and `metrics["rrmse_humidity"]`, indicating the overall RRMSE for both predictions.

```python
def calculate_rrmse(self, y_true, y_pred):
    return np.sqrt(np.mean((y_true - y_pred) ** 2) / np.mean(y_true**2))
 
```

### Accuracy (ACC)[](#accuracy-acc)

The `calculate_accuracy` function is designed to evaluate the prediction accuracy with respect to predefined thresholds for temperature and humidity:

```python
def calculate_accuracy(
    self, y_true, y_pred, temp_threshold=1, humidity_threshold=10
):
    temp_error = np.abs(y_pred[:, 0] - y_true[:, 0])
    humidity_error = np.abs(y_pred[:, 1] - y_true[:, 1])
 
    temp_acc = np.mean(temp_error < temp_threshold)
    humidity_acc = np.mean(humidity_error < humidity_threshold)
 
    acc = (temp_acc + humidity_acc) / 2
    err = 1 - acc
 
    return acc, err, temp_acc, humidity_acc
```

1.  **Temperature Accuracy (`temp_acc`)**:
    
    +   Calculated by the absolute error between the predicted and actual temperatures.
    +   A prediction is considered accurate if the absolute error is less than the `temp_threshold`.
    +   `temp_acc` is the proportion of temperature predictions within the acceptable error threshold.
2.  **Humidity Accuracy (`humidity_acc`)**:
    
    +   Calculated by the absolute error between the predicted and actual humidity levels.
    +   A prediction is considered accurate if the absolute error is less than the `humidity_threshold`.
    +   `humidity_acc` is the proportion of humidity predictions within the acceptable error threshold.
3.  **Overall Accuracy (`acc`)**:
    
    +   This is the average of `temp_acc` and `humidity_acc`, representing the proportion of all predictions that are within their respective acceptable error thresholds.
4.  **Error Rate (`err`)**:
    
    +   Calculated as one minus the overall accuracy.
    +   Represents the proportion of predictions that fall outside the acceptable error thresholds.

These accuracy metrics provide a comprehensive view of the model's performance, taking into account the accuracy of both temperature and humidity predictions. The use of error thresholds offers the flexibility to define what is considered an acceptable prediction, which can be tailored to the specific needs of the application.

[Model Training](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Training_Process "Model Training")[Evaluate Prediction](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/evaluate_prediction "Evaluate Prediction")