## Detailed Explanation of GreenLightModel Class

The `GreenLightModel` class is a core component of the GreenLightPlus project, responsible for simulating greenhouse environments and supplemental lighting systems. This document provides a detailed analysis of the class structure, functionality, and implementation details.

## Class Overview[](#class-overview)

The `GreenLightModel` class allows users to run greenhouse environment simulations, including supplemental lighting systems. It integrates functionalities from multiple modules, such as weather data processing, control strategy loading, and parameter setting, to provide comprehensive greenhouse simulation capabilities.

## Main Attributes[](#main-attributes)

+   `filename`: Output filename for model results
+   `first_day`: Start date of the simulation
+   `lampType`: Type of lamp used (LED or HPS)
+   `isMature`: Whether to start simulation from mature crop stage
+   `controls_file`: Path to the control strategy file
+   `epw_path`: Path to the EPW weather file
+   `csv_path`: Path to the CSV weather file
+   `artificialWeather`: Whether to use artificial weather data
+   `controls`: Control strategy data
+   `u`: 'u' parameter matrix for ODE solver
+   `weather`: Weather data
+   `elevation`: Elevation parameter
+   `gl`: GreenLight model data and parameters
+   `d`: 'd' parameter matrix for ODE solver

## Main Methods[](#main-methods)

### `__init__`[](#__init__)

Initializes a `GreenLightModel` instance, setting basic parameters and file paths.

```python
def __init__(self, filename="", first_day=1, lampType="led", gl_params=None, 
             isMature=False, controls_file=None, epw_path=None, csv_path=None):
    self.filename = filename
    self.first_day = first_day
    self.lampType = lampType
    self.isMature = isMature
    self.controls_file = controls_file
    self.epw_path = epw_path
    self.artificialWeather = False
    self.controls = None
    self.u = None
    self.csv_path = csv_path
```

This method sets the initial parameters for the model, including filename, start date, lamp type, crop maturity status, control file path, and weather data file path.

### `_get_weather_data_path`[](#_get_weather_data_path)

Determines the path of the weather data file, converting EPW to CSV format if necessary.

```python
def _get_weather_data_path(self):
    if self.csv_path is None:
        return convert_epw2csv(epw_path=self.epw_path, time_step=5)
    return self.csv_path
```

This method checks if a CSV file path is provided. If not, it calls the `convert_epw2csv` function to convert the EPW file to CSV format.

### `_load_weather_data`[](#_load_weather_data)

Loads weather data from the specified path and slices it based on start and end rows.

```python
def _load_weather_data(self, path, season_length, start_row, end_row):
    self.lampType = self.lampType.lower() if self.lampType.lower() in ["hps", "led"] else "none"
 
    if self.artificialWeather:
        return make_artificial_input(5)[start_row:end_row]
 
    ext = os.path.splitext(path)[1]
    if ext == ".mat":
        weather_data = cut_energy_plus_data(self.first_day, season_length, path)
    elif ext == ".csv":
        weather_data = cut_energy_plus_data_csv(self.first_day, season_length, path)
    else:
        raise ValueError("Unsupported weather data file format")
 
    return weather_data[start_row:end_row]
```

This method is responsible for loading weather data. It supports artificially generated weather data, MAT files, and CSV file formats. It slices the data based on the provided start and end rows.

### `_set_elevation`[](#_set_elevation)

Sets the elevation attribute based on weather data.

```python
def _set_elevation(self):
    if self.weather.shape[0] > 0 and self.weather.shape[1] >= 10:
        self.elevation = self.weather[0, 9]
    else:
        self.elevation = 0
        print("Warning: weather data is not properly initialized.")
```

This method extracts elevation information from the weather data. If weather data is incomplete, it sets elevation to 0 and issues a warning.

### `_load_controls`[](#_load_controls)

Loads control strategy if a control file is provided.

```python
def _load_controls(self):
    if self.controls_file is not None:
        controls = pd.read_csv(self.controls_file, header=None, skiprows=1)
        self.controls = controls.to_numpy()
        print(f"controls.shape: {self.controls.shape}")
```

This method loads control strategy data from a CSV file and converts it to a NumPy array.

### `_initialize_green_light_model`[](#_initialize_green_light_model)

Initializes the GreenLight model using the provided lamp type, weather data, and control strategy.

```python
def _initialize_green_light_model(self):
    self.gl = create_green_light_model(self.lampType, self.weather, self.controls)
    self.gl = set_params4ha_world_comparison(self.gl)
    self.gl["p"]["hElevation"] = self.elevation
```

This method creates the GreenLight model, sets parameters for comparison, and sets the elevation parameter.

### `_set_dependent_params`[](#_set_dependent_params)

Sets dependent parameters for the GreenLight model.

```python
def _set_dependent_params(self):
    self.gl = set_dep_params(self.gl)
```

This method calls the `set_dep_params` function to set dependent parameters for the model.

### `_prepare_ode_parameters`[](#_prepare_ode_parameters)

Prepares 'd' and 'u' parameter matrices for the ODE solver.

```python
def _prepare_ode_parameters(self):
    d_arrays = list(self.gl["d"].values())
    time_column = d_arrays[0][:, 0:1]
    value_columns = [arr[:, 1:2] for arr in d_arrays]
    self.d = np.hstack([time_column, *value_columns])
 
    if self.controls_file is not None:
        u_values = list(self.gl["u"].values())
        first_columns = u_values[0][:, :2]
        other_columns = [value[:, 1:2] for value in u_values[1:]]
        self.u = np.hstack((first_columns, *other_columns))
```

This method prepares parameter matrices for the ODE solver. It processes the 'd' parameter matrix and, if a control file is provided, prepares the 'u' parameter matrix.

### `_prepare_data_and_params`[](#_prepare_data_and_params)

Prepares data and parameters required for GreenLight model simulation.

```python
def _prepare_data_and_params(self, season_length, start_row, end_row):
    weather_data_path = self._get_weather_data_path()
    self.weather = self._load_weather_data(weather_data_path, season_length, start_row, end_row)
    
    self._set_elevation()
    self._load_controls()
    self._initialize_green_light_model()
    self._set_dependent_params()
    self._prepare_ode_parameters()
```

This method integrates all steps of data preparation, including loading weather data, setting elevation, loading control strategies, initializing the model, setting dependent parameters, and preparing ODE parameters.

### `run_model`[](#run_model)

Runs the GreenLight model and generates results. This is the core method of the class, integrating the functionality of all other methods.

```python
def run_model(self, gl_params=None, season_length=1/24, season_interval=1/24/12,
              step=0, start_row=None, end_row=None, time_step=60):
    if start_row is None or end_row is None:
        rows_in_each_interval = int(season_interval * 12 * 24)
        start_row = step * rows_in_each_interval
        end_row = start_row + rows_in_each_interval
 
    self._prepare_data_and_params(season_length, start_row, end_row)
 
    if gl_params:
        gl_params = extract_last_value_from_nested_dict(gl_params)
        for key, value in gl_params.items():
            if isinstance(value, dict):
                self.gl[key].update(value)
            else:
                self.gl[key] = value
 
    if self.isMature and step == 0:
        print("Start with a mature crop")
        self.gl["x"]["cFruit"] = 2.8e5
        self.gl["x"]["cLeaf"] = 0.9e5
        self.gl["x"]["cStem"] = 2.5e5
        self.gl["x"]["tCanSum"] = 3000
 
    time = self.gl["t"]
    initial_states = list(self.gl["x"].values())
    options = {
        "atol": 1e-6,
        "rtol": 1e-3,
    }
    solver = "BDF"
 
    solver_instance = ODESolver(self.u, self.gl)
    sol = solve_ivp(
        solver_instance.ode,
        time,
        initial_states,
        dense_output=True,
        method=solver,
        **options,
    )
 
    self.gl = change_res(self.gl, self.d, sol, time_step)
 
    return self.gl
```

This method is the core of model execution. It performs the following steps:

1.  Determines the start and end rows for weather data.
2.  Prepares data and parameters.
3.  Updates model parameters if additional parameters are provided.
4.  Sets initial conditions if starting with a mature crop.
5.  Sets parameters and method for the ODE solver.
6.  Creates an ODESolver instance and solves the differential equations.
7.  Adjusts the time resolution of the results.
8.  Returns the simulation results.

## Core Functionality Analysis[](#core-functionality-analysis)

1.  **Weather Data Processing**:
    
    +   Supports EPW and CSV format weather data.
    +   Can use artificially generated weather data for simulation.
    +   Provides data slicing functionality to simulate specific time periods.
2.  **Control Strategy Integration**:
    
    +   Allows loading control strategies from external CSV files.
    +   Supports dynamic updating of model parameters.
3.  **Model Initialization**:
    
    +   Can start simulation from mature crop stage.
    +   Supports setting different types of supplemental lighting systems (LED or HPS).
    +   Automatically handles dependent parameter settings.
4.  **ODE Solving**:
    
    +   Uses `scipy.integrate.solve_ivp` to solve systems of differential equations.
    +   Supports adjusting solver parameters and methods.
    +   Employs the Backward Differentiation Formula (BDF) method for numerical integration.
5.  **Result Processing**:
    
    +   Supports adjusting the time resolution of results.
    +   Generates comprehensive simulation result dictionaries, including all relevant parameters and state variables.

## Considerations[](#considerations)

+   Ensure correct weather data file paths are provided (EPW or CSV format).
+   Control strategy files (if used) should conform to the predefined format.
+   Simulation time step (`time_step`) affects calculation accuracy and efficiency; adjust as needed.
+   When using artificial weather data, ensure the data format is consistent with model expectations.
+   For long-term simulations, be aware of memory usage; segmented processing or data storage optimization may be necessary.
+   When updating model parameters (via `gl_params`), ensure new parameters are compatible with the model structure.
+   The `isMature` parameter only takes effect in the first step of simulation (`step=0`).

[1\. Core Components](https://botanicbyte.com/Code_Structure/core "1. Core Components")[1.2 greenhouse\_env](https://botanicbyte.com/Code_Structure/core/greenhouse_env "1.2 greenhouse_env")