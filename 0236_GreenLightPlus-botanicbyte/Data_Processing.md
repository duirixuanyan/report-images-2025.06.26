```python
def load_data(self):
    # Load data from CSV files
    feature_data = pd.read_csv(
        f"./data/weather_data/EPW_{self.city_name}_{self.roof_type}_{self.time_step}_{self.area}.csv",
        # "data/weather_data/beijing_EnergyPlus.csv",
        parse_dates=["DateTime"],  # Parse the "DateTime" column as dates
        index_col="DateTime",  # Use the "DateTime" column as the index
    )
 
    label_data = pd.read_csv(
        f"./data/energyPlus/eplusout_{self.city_name}_{self.roof_type}_{self.time_step}_{self.area}.csv",
        parse_dates=["DateTime"],  # Parse the "DateTime" column as dates
        index_col="DateTime",  # Use the "DateTime" column as the index
    )
 
    print(
        f"Loading feature data from: data/weather_data/{self.city_name}_EnergyPlus.csv"
    )
    print(
        f"Loading label data from: data/energyPlus/eplusout_{self.city_name}_{self.roof_type}_{self.past_time_steps}_{self.area}.csv"
    )
 
    # Use the index of the label data for the feature data
    feature_data.index = label_data.index
 
    # Select the required columns,  "window_opening_actual",
    feature_columns = [
        "Outdoor global irradiation(W m⁻²)",
        "Outdoor air temperature(°C)",
        "Outdoor vapor pressure(Pa)",
        "Outdoor wind speed(m s⁻¹)",
        "Sky temperature(°C)",
    ]
 
    label_columns = [
        "ZoneAirTemperature °C",
        "Indoor Vapor Pressure(Pa)",
        "window_opening_actual",
    ]
 
    # Extract the selected columns from the feature and label data
    features = feature_data[feature_columns]
    labels = label_data[label_columns]
 
    # After extracting the labels, add them to the features
    features = pd.concat([features, labels], axis=1)
 
    # Remove "window_opening_actual" from labels
    labels = labels.drop(columns=["window_opening_actual"])
 
    # Return the features and labels
    return features, labels
```

```python
def create_dataset(self, X, y):
    # Initialize two empty lists for storing the input sequences (Xs) and the corresponding target sequences (ys)
    Xs, ys = [], []
 
    # Loop over the input data. The range of the loop is determined by the length of the input data,
    # the number of past time steps to consider, and the number of future time steps to forecast.
    for i in range(len(X) - self.past_time_steps - self.forecast_steps + 1):
        # For each iteration, append a sequence of past time steps from the input data to Xs
        Xs.append(X[i: (i + self.past_time_steps)])
 
        # Append a sequence of future time steps from the target data to ys.
        # The sequence starts from the end of the corresponding input sequence and has a length of forecast_steps
        ys.append(
            y[
                i
                + self.past_time_steps: i
                + self.past_time_steps
                + self.forecast_steps
            ]
        )
 
    # Convert the lists to numpy arrays and return them
    return np.array(Xs), np.array(ys)
```

```python
def preprocess_data(self, features, labels):
    # Replace the original MinMaxScaler with RobustScaler
    scaler_features = RobustScaler()
    scaler_labels = RobustScaler()
 
    # Convert the features and labels to numpy arrays
    features = features.to_numpy()
    labels = labels.to_numpy()
 
    # Print the shapes of the features and labels
    print(f"features shape: {features.shape}")
    print(f"labels shape: {labels.shape}")
 
    # Create the dataset using the create_dataset method
    features, labels = self.create_dataset(features, labels)
 
    # Initialize empty lists for training, validation, and test sets for both features and labels
    features_train, features_val, features_test = [], [], []
    labels_train, labels_val, labels_test = [], [], []
 
    # Loop over the features and labels and split them into training, validation, and test sets
    for i in range(0, len(features) - self.window_size, self.window_size):
        train_size = int(self.window_size * 0.6)
        val_size = int(self.window_size * 0.2)
        test_size = self.window_size - train_size - val_size
 
        features_train.append(features[i: i + train_size])
        features_val.append(
            features[i + train_size: i + train_size + val_size])
        features_test.append(
            features[i + train_size + val_size: i + self.window_size]
        )
 
        labels_train.append(labels[i: i + train_size])
        labels_val.append(
            labels[i + train_size: i + train_size + val_size])
        labels_test.append(
            labels[i + train_size + val_size: i + self.window_size])
 
    # Concatenate the lists to form numpy arrays
    features_train = np.concatenate(features_train)
    features_val = np.concatenate(features_val)
    features_test = np.concatenate(features_test)
 
    labels_train = np.concatenate(labels_train)
    labels_val = np.concatenate(labels_val)
    labels_test = np.concatenate(labels_test)
 
    # Reshape the data for scaling
    features_train = features_train.reshape(-1, features_train.shape[-1])
    features_val = features_val.reshape(-1, features_val.shape[-1])
    features_test = features_test.reshape(-1, features_test.shape[-1])
 
    # Reshape labels for scaling
    labels_train = labels_train.reshape(-1, labels_train.shape[-1])
    labels_val = labels_val.reshape(-1, labels_val.shape[-1])
    labels_test = labels_test.reshape(-1, labels_test.shape[-1])
 
    # Fit the scalers to the training data
    scaler_features.fit(features_train)
    scaler_labels.fit(labels_train)
 
    # Save the scalers for future use
    os.makedirs("data/pth/", exist_ok=True)
    dump(scaler_features, "data/pth/scaler_features.joblib")
    dump(scaler_labels, "data/pth/scaler_labels.joblib")
 
    # Transform the training, validation, and test data using the fitted scalers
    features_train = scaler_features.transform(features_train)
    features_val = scaler_features.transform(features_val)
    features_test = scaler_features.transform(features_test)
 
    labels_train = scaler_labels.transform(labels_train)
    labels_val = scaler_labels.transform(labels_val)
    labels_test = scaler_labels.transform(labels_test)
 
    # Reshape the features back to their original shape
    features_train = features_train.reshape(
        -1, self.past_time_steps, features_train.shape[-1]
    )
    features_val = features_val.reshape(
        -1, self.past_time_steps, features_val.shape[-1]
    )
    features_test = features_test.reshape(
        -1, self.past_time_steps, features_test.shape[-1]
    )
 
    # Reshape labels back to their original shape
    labels_train = labels_train.reshape(
        -1, self.forecast_steps, labels_train.shape[-1]
    )
    labels_val = labels_val.reshape(-1,
                                    self.forecast_steps, labels_val.shape[-1])
    labels_test = labels_test.reshape(
        -1, self.forecast_steps, labels_test.shape[-1]
    )
 
    # Return the preprocessed data and the label scaler
    return (
        features_train,
        features_val,
        features_test,
        labels_train,
        labels_val,
        labels_test,
        scaler_labels,
    )
 
```