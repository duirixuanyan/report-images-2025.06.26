室内气候预测模型是一种先进的机器学习系统，旨在基于多种环境输入预测室内温度和湿度。该模型针对特定城市区域和屋顶类型定制，并可适配不同建筑规模和条件。它采用具有时序特征的复杂神经网络架构，利用历史数据预测未来环境状况。

该模型由多个先进的神经网络组件构建而成，用于处理时间序列数据以完成室内温度和水汽压的预测任务。以下是模型架构各部分的详细说明：

```python
if __name__ == "__main__":
    # 1. Initialize the model
    model_instance = WeatherModel(
        city_name="Amsterdam",
        roof_type="triangle",
        past_time_steps=2,
        forecast_steps=1,
        quantiles=0.5,
    )
 
    # 2. Load and preprocess the data
    features, labels = model_instance.load_data()
 
    # Split the data into training, validation, and test sets, and get the label scaler
    (
        features_train,
        features_val,
        features_test,
        labels_train,
        labels_val,
        labels_test,
        scaler_labels,
    ) = model_instance.preprocess_data(features, labels)
 
    # 3. Build the model
    input_dim = features_train.shape[-1]  # Get the input dimension
    model_instance.model = model_instance.build_model(input_dim)
 
    # 4. Train the model
    trained_model, history = model_instance.train_model(
        features_train, labels_train, features_val, labels_val
    )
 
    # 5. Evaluate the model
    model_instance.evaluate_prediction()
 
```

```python
import os
import random
from datetime import datetime
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from joblib import dump, load
from tensorflow.keras import layers, models, callbacks
from sklearn.preprocessing import RobustScaler
 
class WeatherModel:
    def __init__(
        self,
        city_name,
        roof_type,
        past_time_steps=2,  # Number of past time steps
        time_step=5,  # Time step interval
        forecast_steps=1,  # Number of future time steps to predict
        quantiles=0.5,
        window_size=24
        * 12
        * 7,  # One week, used to divide the training set, validation set, and test set
        prediction_days=180,  # Number of days to predict
    ):
        # Basic parameters
        self.city_name = city_name  # Name of the city for the weather model
        self.roof_type = roof_type  # Type of the roof
        self.area = 400  # Area of the roof
 
        # Model structure parameters
        self.neurons_layer1 = 128  # Number of neurons in the first layer
        self.neurons_layer2 = 16  # Number of neurons in the second layer
        self.num_heads = 12  # Number of attention heads in the transformer model
        self.key_dim = 4  # Dimension of the key in the transformer model
        self.dropout_rate = 0.2  # Dropout rate in the model
 
        # Training parameters
        self.epochs = 100  # Number of training epochs
        self.batch_size = 512  # Batch size for training
        self.learning_rate = 0.001  # Initial learning rate
        self.min_lr = 1e-8  # Minimum learning rate
        self.patience1 = 24  # Early stopping patience
        self.patience2 = 4  # Learning rate decay patience
 
        # Time series parameters, default time step interval is 5 minutes
        self.past_time_steps = past_time_steps  # Number of past time steps to consider
        self.time_step = time_step  # Time step interval
        self.forecast_steps = forecast_steps  # Number of future time steps to predict
        self.window_size = window_size  # Window size for splitting the dataset
        self.prediction_days = prediction_days  # Number of days to predict
 
        # Loss function parameters
        self.lr_reduce_factor = (
            0.5  # Factor by which to reduce learning rate when a plateau is encountered
        )
        self.quantiles = quantiles  # Quantile interval for the loss function
 
    def load_data(self):
        # Read data from CSV files
        feature_data = pd.read_csv(
            f"data/weather_data/EPW_{self.city_name}_{self.roof_type}_{self.time_step}_{self.area}.csv",
            parse_dates=["DateTime"],  # Parse the "DateTime" column as dates
            index_col="DateTime",  # Use the "DateTime" column as the index
        )
 
        label_data = pd.read_csv(
            f"data/energyPlus/eplusout_{self.city_name}_{self.roof_type}_{self.time_step}_{self.area}.csv",
            parse_dates=["DateTime"],  # Parse the "DateTime" column as dates
            index_col="DateTime",  # Use the "DateTime" column as the index
        )
 
        print(
            f"Loading feature data from: data/weather_data/{self.city_name}_EnergyPlus.csv"
        )
        print(
            f"Loading label data from: data/energyPlus/eplusout_{self.city_name}_{self.roof_type}_{self.past_time_steps}_{self.area}.csv"
        )
 
        # Index the feature data using the index of the label data
        feature_data.index = label_data.index
 
        # Select the required columns
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
 
        features = feature_data[feature_columns]
        labels = label_data[label_columns]
 
        # Add the labels to the features after extracting them
        features = pd.concat([features, labels], axis=1)
 
        # Remove "window_opening_actual" from labels
        labels = labels.drop(columns=["window_opening_actual"])
 
        return features, labels
 
    def create_dataset(self, X, y):
        Xs, ys = [], []
        for i in range(len(X) - self.past_time_steps - self.forecast_steps + 1):
            # Append the past time steps of X to Xs
            Xs.append(X[i : (i + self.past_time_steps)])
            # Append the forecast steps of y to ys
            ys.append(
                y[
                    i
                    + self.past_time_steps : i
                    + self.past_time_steps
                    + self.forecast_steps
                ]
            )
        return np.array(Xs), np.array(ys)
 
    def preprocess_data(self, features, labels):
        # Use RobustScaler instead of the original MinMaxScaler
        scaler_features = RobustScaler()
        scaler_labels = RobustScaler()
 
        # Convert pandas dataframes to numpy arrays
        features = features.to_numpy()
        labels = labels.to_numpy()
 
        print(f"features shape: {features.shape}")
        print(f"labels shape: {labels.shape}")
 
        # Create the dataset
        features, labels = self.create_dataset(features, labels)
 
        # Split the dataset into training, validation, and test sets
        features_train, features_val, features_test = [], [], []
        labels_train, labels_val, labels_test = [], [], []
 
        for i in range(0, len(features) - self.window_size, self.window_size):
            train_size = int(self.window_size * 0.6)
            val_size = int(self.window_size * 0.2)
            test_size = self.window_size - train_size - val_size
 
            # Append the corresponding segments to the training, validation, and test sets
            features_train.append(features[i : i + train_size])
            features_val.append(features[i + train_size : i + train_size + val_size])
            features_test.append(
                features[i + train_size + val_size : i + self.window_size]
            )
 
            labels_train.append(labels[i : i + train_size])
            labels_val.append(labels[i + train_size : i + train_size + val_size])
            labels_test.append(labels[i + train_size + val_size : i + self.window_size])
 
        # Concatenate the lists into numpy arrays
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
 
        # Save the scalers
        os.makedirs("data/pth/", exist_ok=True)
        dump(scaler_features, "data/pth/scaler_features.joblib")
        dump(scaler_labels, "data/pth/scaler_labels.joblib")
 
        # Transform the training, validation, and test data
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
        labels_val = labels_val.reshape(-1, self.forecast_steps, labels_val.shape[-1])
        labels_test = labels_test.reshape(
            -1, self.forecast_steps, labels_test.shape[-1]
        )
 
        return (
            features_train,
            features_val,
            features_test,
            labels_train,
            labels_val,
            labels_test,
            scaler_labels,
        )
 
    def gated_residual_network(self, x, hidden_units):
        # Gated Linear Unit (GLU)
        # First, we transform the input x using a dense layer and split it into two parts
        x_transformed = layers.Dense(hidden_units * 2, activation="linear")(x)
        split_gate = tf.split(x_transformed, num_or_size_splits=2, axis=-1)
        # The GLU activation is the product of the tanh of the first part and the sigmoid of the second part
        output = tf.nn.tanh(split_gate[0]) * tf.nn.sigmoid(split_gate[1])
        # Apply layer normalization to the output
        output = layers.LayerNormalization()(output)
        # Transform the original input x to have the same shape as output
        x_transformed = layers.Dense(hidden_units, activation="linear")(x)
        # Add the transformed input to the output (residual connection)
        output = x_transformed + output
        return output
 
    def encoder_block(self, input_layer):
        # Self-attention mechanism
        self_attention_out = layers.MultiHeadAttention(
            num_heads=self.num_heads, key_dim=self.key_dim
        )(input_layer, input_layer, input_layer)
        # Gated Residual Network (GRN)
        grn_out = self.gated_residual_network(self_attention_out, self.neurons_layer1)
        # Bidirectional LSTM
        lstm_out, _, _, _, _ = layers.Bidirectional(
            layers.LSTM(self.neurons_layer2, return_sequences=True, return_state=True)
        )(grn_out)
        # Another GRN
        grn_out = self.gated_residual_network(lstm_out, self.neurons_layer1)
        return grn_out
 
    def decoder_block(self, encoder_outputs):
        combined_output = encoder_outputs
        # Generate a query by passing the combined output through a dense layer
        query = layers.Dense(combined_output.shape[-1])(combined_output)
        # Self-attention mechanism
        self_attention_out = layers.MultiHeadAttention(
            num_heads=self.num_heads, key_dim=self.key_dim
        )(query, query, query)
        # Cross-attention mechanism, using the generated query and the encoder outputs as keys and values
        cross_attention_out = layers.MultiHeadAttention(
            num_heads=self.num_heads, key_dim=self.key_dim
        )(self_attention_out, combined_output, combined_output)
        # GRN
        grn_out = self.gated_residual_network(cross_attention_out, self.neurons_layer1)
        # Bidirectional LSTM
        lstm_out = layers.Bidirectional(
            layers.LSTM(self.neurons_layer2, return_sequences=False)
        )(grn_out)
        # Another GRN
        grn_out = self.gated_residual_network(lstm_out, self.neurons_layer1)
        return grn_out
 
    def multihead_attention_module(self, encoded_features):
        num_features = len(encoded_features)
        # Use a dense layer to learn the weights for each feature encoder output
        weight_generator = tf.keras.layers.Dense(num_features, activation="softmax")
        # Compute the weights for each feature encoder output
        feature_weights = weight_generator(tf.concat(encoded_features, axis=-1))
        weighted_features = []
        for i in range(num_features):
            # Expand to (batch_size, past_time_steps, 1)
            weight = feature_weights[:, :, i : i + 1]
            weight = tf.broadcast_to(weight, tf.shape(encoded_features[i]))
            # Multiply the feature encoder output by its weight
            weighted_feature = encoded_features[i] * weight
            weighted_features.append(weighted_feature)
        # Combine all the weighted feature encoder outputs
        combined_weighted_features = tf.add_n(weighted_features)
        # Apply multi-head attention mechanism
        multihead_attention_layer = tf.keras.layers.MultiHeadAttention(
            num_heads=self.num_heads, key_dim=combined_weighted_features.shape[-1]
        )
        multihead_attention_outputs = multihead_attention_layer(
            combined_weighted_features, combined_weighted_features
        )
        # Add a dropout layer
        dropout_out = layers.Dropout(self.dropout_rate)(multihead_attention_outputs)
        return dropout_out
 
    def build_model(self, input_dim):
        # Define model inputs, creating multiple inputs based on the number of features
        input_layers = [
            layers.Input(shape=(self.past_time_steps, 1)) for _ in range(input_dim)
        ]  # Weather data for the past 7 days
 
        # Encode each feature
        encoded_features = []
        for i in range(input_dim):
            # Input Encoder
            encoder_out = self.encoder_block(
                input_layers[i],
            )
            # We take the output of the encoder as the encoding result of this feature
            encoded_feature = encoder_out
            encoded_features.append(encoded_feature)
 
        # Use multi-head attention module
        multihead_attention_outputs = self.multihead_attention_module(
            encoded_features,
        )
 
        # Output Decoder
        decoder_out = self.decoder_block(
            multihead_attention_outputs,
        )
 
        # Dropout layer
        dropout_out = layers.Dropout(self.dropout_rate)(decoder_out)
 
        # Output layer
        # output_layer = layers.Dense(2 , activation="tanh")(dropout_out)
        output_layer = layers.Dense(2 * self.forecast_steps, activation="linear")(
            dropout_out
        )
 
        output_layer = layers.Reshape((self.forecast_steps, 2))(output_layer)
 
        # Create model
        model = models.Model(
            inputs=input_layers, outputs=output_layer
        )  # Here, inputs need to be changed to input_layers
 
        # Compile model...
        # loss=quantile_loss,loss='mean_squared_error'
        model.compile(
            optimizer=tf.optimizers.Adam(learning_rate=self.learning_rate),
            loss=self.quantiles_loss,
        )
        return model
 
    def train_model(self, features_train, labels_train, features_val, labels_val):
        features_train = [
            features_train[:, :, i : i + 1] for i in range(features_train.shape[-1])
        ]
        features_val = [
            features_val[:, :, i : i + 1] for i in range(features_val.shape[-1])
        ]
 
        # Set callback functions
        os.makedirs("data/checkpoint/", exist_ok=True)
        checkpoint_filepath = f"data/checkpoint/model_weights_{self.roof_type}_{self.quantiles}_{self.past_time_steps}_{self.forecast_steps}_{self.city_name}.h5"
        log_dir = "data/logs/fit/" + datetime.now().strftime("%Y%m%d-%H%M%S")
 
        # Check if a checkpoint exists
        if os.path.exists(checkpoint_filepath):
            print(f"Loading weights from {checkpoint_filepath}")
            self.model.load_weights(checkpoint_filepath)
        else:
            print("No checkpoint found. Training model from scratch.")
 
        # Create EarlyStopping and ModelCheckpoint callbacks
        callbacks = [
            tf.keras.callbacks.EarlyStopping(
                monitor="val_loss",
                patience=self.patience1,
                restore_best_weights=True,
            ),
            tf.keras.callbacks.TensorBoard(log_dir),
            tf.keras.callbacks.ReduceLROnPlateau(
                monitor="val_loss",
                factor=self.lr_reduce_factor,
                patience=self.patience2,
                min_lr=self.min_lr,
            ),
            tf.keras.callbacks.ModelCheckpoint(
                filepath=checkpoint_filepath,
                save_weights_only=True,
                monitor="val_loss",
                mode="min",
                save_best_only=True,
            ),
        ]
        # Train the model
        history = self.model.fit(
            features_train,
            labels_train,
            epochs=self.epochs,
            batch_size=self.batch_size,
            callbacks=callbacks,
            validation_data=(features_val, labels_val),
        )
 
        # Save the model as an H5 file
        self.model.save(
            f"data/pth/{self.roof_type}_{self.quantiles}_{self.past_time_steps}_{self.forecast_steps}_{self.city_name}.h5"
        )
 
        return self.model, history
 
    def calculate_rrmse(self, y_true, y_pred):
        # Calculate the Root Relative Mean Squared Error (RRMSE) between the true and predicted values
        return np.sqrt(np.mean((y_true - y_pred) ** 2) / np.mean(y_true**2))
 
    def quantiles_loss(self, y_true, y_pred):
        # Calculate the quantile loss between the true and predicted values
        error = y_true - y_pred
        loss = tf.where(
            error >= 0, self.quantiles * error, (self.quantiles - 1) * error
        )
        return tf.reduce_mean(loss)
 
    def calculate_accuracy(
        self, y_true, y_pred, temp_threshold=1, humidity_threshold=10
    ):
        # Calculate the accuracy of temperature and humidity predictions
        temp_error = np.abs(y_pred[:, 0] - y_true[:, 0])
        humidity_error = np.abs(y_pred[:, 1] - y_true[:, 1])
 
        temp_acc = np.mean(temp_error < temp_threshold)
        humidity_acc = np.mean(humidity_error < humidity_threshold)
 
        acc = (temp_acc + humidity_acc) / 2
        err = 1 - acc
 
        return acc, err, temp_acc, humidity_acc
 
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
            rrmse_humidity_sum += self.calculate_rrmse(y_true[:, t, 1], y_pred[:, t, 1])
 
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
        metrics["r2_average"] = (metrics["r2_temperature"] + metrics["r2_humidity"]) / 2
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
 
    def visualize_results(self, predictions_inverse, labels_inverse):
        # Print the shapes of the inverse predictions and labels
        print("Shape of predictions_inverse:", predictions_inverse.shape)
        print("Shape of labels_inverse:", labels_inverse.shape)
 
        for selected_timesteps in range(self.forecast_steps):
            # Get the predicted and label values for the selected forecast step
            selected_predictions = predictions_inverse[:, selected_timesteps, :]
            selected_labels = labels_inverse[:, selected_timesteps, :]
 
            # Calculate RRMSE for the selected timestep
            rrmse_temperature = self.calculate_rrmse(
                selected_labels[:, 0], selected_predictions[:, 0]
            )
            rrmse_humidity = self.calculate_rrmse(
                selected_labels[:, 1], selected_predictions[:, 1]
            )
 
            # Create scatter plots
            fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(15, 10))
 
            # Temperature
            axes[0, 0].scatter(
                selected_labels[:, 0],
                selected_predictions[:, 0],
                color="blue",
                alpha=0.6,
            )
            axes[0, 0].plot(
                [selected_labels[:, 0].min(), selected_labels[:, 0].max()],
                [selected_labels[:, 0].min(), selected_labels[:, 0].max()],
                color="red",
                linestyle="--",
            )
            axes[0, 0].set_xlabel("Actual Indoor Temperature")
            axes[0, 0].set_ylabel("Predicted Indoor Temperature")
            axes[0, 0].set_title(
                f"Actual vs. Predicted Indoor Temperature for Forecast Step {selected_timesteps+1}\nRRMSE: {rrmse_temperature:.2f}"
            )
 
            # Time series plot of actual and predicted temperature
            axes[0, 1].plot(selected_labels[:, 0], color="blue", label="Actual")
            axes[0, 1].plot(selected_predictions[:, 0], color="red", label="Predicted")
            axes[0, 1].set_xlabel("Time")
            axes[0, 1].set_ylabel("Temperature")
            axes[0, 1].set_title(
                f"Actual vs. Predicted Indoor Temperature Over Time for Forecast Step {selected_timesteps+1}"
            )
            axes[0, 1].legend()
 
            # Humidity
            axes[1, 0].scatter(
                selected_labels[:, 1],
                selected_predictions[:, 1],
                color="green",
                alpha=0.6,
            )
            axes[1, 0].plot(
                [selected_labels[:, 1].min(), selected_labels[:, 1].max()],
                [selected_labels[:, 1].min(), selected_labels[:, 1].max()],
                color="red",
                linestyle="--",
            )
            axes[1, 0].set_xlabel("Actual Indoor Vapor Pressure(Pa)")
            axes[1, 0].set_ylabel("Predicted Indoor Vapor Pressure(Pa)")
            axes[1, 0].set_title(
                f"Actual vs. Predicted Indoor Vapor Pressure(Pa) for Forecast Step {selected_timesteps+1}\nRRMSE: {rrmse_humidity:.2f}"
            )
 
            # Time series plot of actual and predicted humidity
            axes[1, 1].plot(selected_labels[:, 1], color="blue", label="Actual")
            axes[1, 1].plot(selected_predictions[:, 1], color="red", label="Predicted")
            axes[1, 1].set_xlabel("Time")
            axes[1, 1].set_ylabel("Vapor Pressure(Pa)")
            axes[1, 1].set_title(
                f"Actual vs. Predicted Indoor Vapor Pressure(Pa) Over Time for Forecast Step {selected_timesteps+1}"
            )
            axes[1, 1].legend()
 
            # Display the plots
            plt.tight_layout()
            plt.show()
 
    def evaluate_prediction(self):
        # Define the path of the model
        model_pth = f"data/pth/{self.roof_type}_{self.quantiles}_{self.past_time_steps}_{self.forecast_steps}_{self.city_name}.h5"
 
        print(f"Loading model from : {model_pth} ...")
 
        # Load your data
        features, labels = self.load_data()
 
        print(f"evaluate_prediction features shape: {features.shape}")
        print(f"evaluate_prediction labels shape: {labels.shape}")
 
        # Convert the data to numpy arrays
        features = features.to_numpy()
        labels = labels.to_numpy()
 
        # Create the dataset
        features, labels = self.create_dataset(features, labels)
 
        print(f"evaluate_prediction features shape1: {features.shape}")
        print(f"evaluate_prediction labels shape1: {labels.shape}")
 
        # Reshape the data to fit the scaler
        features = features.reshape(-1, features.shape[-1])
        labels = labels.reshape(-1, labels.shape[-1])
 
        print(f"evaluate_prediction features shape2: {features.shape}")
        print(f"evaluate_prediction labels shape2: {labels.shape}")
 
        # Load the scalers
        scaler_labels = load("data/pth/scaler_labels.joblib")
        scaler_features = load("data/pth/scaler_features.joblib")
 
        # Transform all the data
        features = scaler_features.transform(features)
        labels = scaler_labels.transform(labels)
 
        # Reshape the data to fit the model input
        features = features.reshape(-1, self.past_time_steps, features.shape[-1])
        labels = labels.reshape(-1, self.forecast_steps, labels.shape[-1])
 
        # Load the model
        model = models.load_model(
            f"{model_pth}", custom_objects={"quantiles_loss": self.quantiles_loss}
        )
 
        # Randomly select a window of 7 days of data for prediction
        idx = random.randint(0, len(features) - int(self.prediction_days * 12 * 24))
        print(f"idx: {idx}")
        features_test = [
            features[idx : idx + int(self.prediction_days * 12 * 24), :, i : i + 1]
            for i in range(features.shape[-1])
        ]
        labels_test = labels[idx : idx + int(self.prediction_days * 12 * 24)]
 
        # Make predictions
        predictions = model.predict(features_test)
 
        # Reshape the data for inverse normalization
        predictions_2D = predictions.reshape(-1, predictions.shape[-1])
        labels_test_2D = labels_test.reshape(-1, labels_test.shape[-1])
 
        # Inverse normalize the predictions and actual values
        predictions_inverse_2D = scaler_labels.inverse_transform(predictions_2D)
        labels_inverse_2D = scaler_labels.inverse_transform(labels_test_2D)
 
        # Reshape the inverse normalized data to its original shape
        predictions_inverse = predictions_inverse_2D.reshape(predictions.shape)
        labels_inverse = labels_inverse_2D.reshape(labels_test.shape)
 
        # Calculate metrics
        metrics = self.calculate_metrics(labels_inverse, predictions_inverse)
        for name, value in metrics.items():
            print(f"{name}: {value * 100:.2f}%")
 
        # Visualize the results
        self.visualize_results(predictions_inverse, labels_inverse)
 
        # Combine the predictions and actual values into a DataFrame
        combined_df = pd.DataFrame(
            {
                "Predicted Temperature": predictions_inverse[:, :, 0].flatten(),
                "Actual Temperature": labels_inverse[:, :, 0].flatten(),
                "Predicted Humidity": predictions_inverse[:, :, 1].flatten(),
                "Actual Humidity": labels_inverse[:, :, 1].flatten(),
            }
        )
 
        # Save the combined data to a CSV file
        combined_df.to_csv("combined_predictions_labels.csv", index=False)
        print("Combined predictions and labels have been saved to a CSV file.")
```