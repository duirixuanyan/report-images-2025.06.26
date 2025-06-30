`calculate_metrics` 函数计算了多个评估指标，用于评估模型在预测温度和湿度方面的性能。以下是每个指标的详细说明：

### 准确度指标[](#accuracy-metrics)

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

### R平方 (R2)[](#r-squared-r2)

+   `r2_temperature` 和 `r2_humidity` 分别使用 `r2_score` 函数计算温度和湿度的预测值
+   这些值在每个时间步长上求和，然后对所有时间步长取平均得到 `metrics["r2_temperature"]` 和 `metrics["r2_humidity"]`
+   `metrics["r2_average"]` 是 `metrics["r2_temperature"]` 和 `metrics["r2_humidity"]` 的平均值，代表温度和湿度预测的整体R2分数

### 相对均方根误差 (RRMSE)[](#relative-root-mean-square-error-rrmse)

+   这是模型预测值与实际观测值之间差异的标准化度量
+   与R2类似，RRMSE也分别计算温度(`rrmse_temperature`)和湿度(`rrmse_humidity`)的误差，并对所有时间步长取平均
+   `metrics["rrmse_average"]` 是 `metrics["rrmse_temperature"]` 和 `metrics["rrmse_humidity"]` 的平均值，表示两种预测的整体RRMSE

```python
def calculate_rrmse(self, y_true, y_pred):
    return np.sqrt(np.mean((y_true - y_pred) ** 2) / np.mean(y_true**2))
 
```

### 准确率 (ACC)[](#accuracy-acc)

`calculate_accuracy` 函数用于评估预测准确率，基于预设的温度和湿度阈值:

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

1.  **温度准确率 (`temp_acc`)**:
    
    +   通过预测温度与实际温度之间的绝对误差计算
    +   当绝对误差小于 `temp_threshold` 时，认为预测准确
    +   `temp_acc` 表示在可接受误差阈值范围内的温度预测比例
2.  **湿度准确率 (`humidity_acc`)**:
    
    +   通过预测湿度与实际湿度之间的绝对误差计算
    +   当绝对误差小于 `humidity_threshold` 时，认为预测准确
    +   `humidity_acc` 表示在可接受误差阈值范围内的湿度预测比例
3.  **整体准确率 (`acc`)**:
    
    +   这是 `temp_acc` 和 `humidity_acc` 的平均值，表示所有预测中符合各自误差阈值的比例
4.  **错误率 (`err`)**:
    
    +   计算方式为1减去整体准确率
    +   表示超出可接受误差阈值的预测比例

这些准确率指标综合考虑了温度和湿度预测的准确性，全面评估模型性能。使用误差阈值可以灵活定义什么是可接受的预测，能够根据具体应用需求进行调整。

[模型训练](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Training_Process "Model Training")[评估预测](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/evaluate_prediction "Evaluate Prediction")