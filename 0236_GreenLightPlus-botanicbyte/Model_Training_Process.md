### Model Training Process Description[](#model-training-process-description)

The `train_model` function is responsible for training the deep learning model using the provided training and validation datasets. It is designed to handle time-series data, where features and labels are organized in sequences to predict future values.

+   **Feature Preparation**: Both the training and validation feature sets are reshaped into a list of arrays, where each array corresponds to a specific feature across all time steps. This is necessary because the model expects each feature to be fed into its respective input layer.
    
+   **Callback Setup**: Callbacks in Keras provide ways to perform actions at various stages of training (e.g., at the end of an epoch). In this case, several callbacks are used to monitor the training process, including:
    
    +   `EarlyStopping`: Stops training when a monitored metric has stopped improving, thus preventing overfitting. The `restore_best_weights` option ensures that the model reverts to the weights from the epoch with the best value of the validation loss.
    +   `TensorBoard`: Provides visualization for monitoring the model's training and validation metrics.
    +   `ReduceLROnPlateau`: Reduces the learning rate when a metric has stopped improving, which helps fine-tune the model by taking smaller steps when progress slows down.
    +   `ModelCheckpoint`: Saves the model at certain intervals, allowing for the preservation of the best performing model on the validation data.

```python
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
```

+   **Checkpoint Handling**: Before starting the training, the method checks for the existence of a saved model checkpoint. If found, the weights from this checkpoint are loaded, allowing the training to resume from the last saved state. If no checkpoint is found, the model is trained from scratch.

```python
# Check if a checkpoint exists
if os.path.exists(checkpoint_filepath):
    print(f"Loading weights from {checkpoint_filepath}")
    self.model.load_weights(checkpoint_filepath)
else:
    print("No checkpoint found. Training model from scratch.")
 
```

+   **Model Training**: The model is trained using the `fit` method, passing the prepared feature arrays and labels, along with the batch size, number of epochs, and callbacks. The training process is also monitored using the validation dataset.

```python
# Train the model
history = self.model.fit(
    features_train,
    labels_train,
    epochs=self.epochs,
    batch_size=self.batch_size,
    callbacks=callbacks,
    validation_data=(features_val, labels_val),
)
```

+   **Model Saving**: After training, the model is saved as an H5 file, preserving the architecture, weights, and training configuration. This enables the model to be reloaded and used for predictions without the need to retrain.

```python
# Save the model as an H5 file
self.model.save(
    f"data/pth/{self.roof_type}_{self.quantiles}_{self.past_time_steps}_{self.forecast_steps}_{self.city_name}.h5"
)
```

+   **Return Values**: The method returns the trained model and the history object, which contains the record of training/validation loss and any other metrics specified during model compilation.

### Complete Code[](#complete-code)

```python
def train_model(self, features_train, labels_train, features_val, labels_val):
# Reshape the training and validation features to have a separate input for each feature
features_train = [
    features_train[:, :, i: i + 1] for i in range(features_train.shape[-1])
]
features_val = [
    features_val[:, :, i: i + 1] for i in range(features_val.shape[-1])
]
 
# Set up the callbacks
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
```

Through this training process, the model learns to predict the future indoor temperature and vapor pressure based on historical weather-related features like outdoor temperature, vapor pressure, wind speed, sky temperature, and global irradiation. The use of callbacks and checkpointing ensures that the training is efficient and that the best possible model is preserved.

[Model Architecture](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Model_Architecture "Model Architecture")[Evaluation Metrics](https://botanicbyte.com/Indoor_Climate_Forecasting_Model/Evaluation_Metrics "Evaluation Metrics")