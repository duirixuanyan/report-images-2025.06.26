1.4 Greenhouse Simulation

## Detailed Explanation of GreenhouseSimulation Class

The `GreenhouseSimulation` class is a core component of the GreenLightPlus project responsible for integrating EnergyPlus simulation and GreenLight model. It manages the simulation process, handles data exchange, and calculates key performance indicators.

## Class Definition and Initialization[](#class-definition-and-initialization)

```python
class GreenhouseSimulation:
 
    def __init__(self, api, epw_path, idf_path, csv_path, output_directory, first_day, season_length, isMature=False):
        super().__init__()
        self.api = api
        self.epw_path = epw_path
        self.idf_path = idf_path
        self.csv_path = csv_path
        self.output_directory = output_directory
        self.last_time_step = None
        self.total_minutes = 0
        self.simulation_started = False
        self.isMature = isMature
 
        # Initialize various sensor handles as None
        self.temp_sensor_handle = None
        self.rh_sensor_handle = None
        self.temp_outdoor_sensor_handle = None
        self.outdoor_air_temp_handle = None
        self.humidity_ratio_handle = None
 
        # Growth cycle parameters
        self.season_length = season_length  # Length of growth cycle, in days
        self.season_interval = self.season_length  # Time interval for each model run, in days
        self.first_day = first_day  # First day date of the growth cycle
 
        # Initialize yield and energy consumption
        self.total_yield = 0
        self.lampIn = 0
        self.boilIn = 0
        self.current_step = 0
 
        # Create GreenLight model instance, initial state is immature
        self.model = GreenLightModel(
            first_day=self.first_day, isMature=self.isMature, epw_path=self.epw_path, csv_path=self.csv_path)
 
        # Initialize state parameters
        self.init_state = {
            "p": {
                # Greenhouse structure settings
                'psi': 22,  # Mean greenhouse cover slope [degrees]
                'aFlr': 668,  # Floor area [m^2]
                'aCov': 1405,  # Surface of the cover including side walls [m^2]
                'hAir': 6.5,  # Height of the main compartment [m]
                'hGh': 6.905,  # Mean height of the greenhouse [m]
                'aRoof': 39*2,  # Maximum roof ventilation area
                'hVent': 1.3,  # Vertical dimension of single ventilation opening [m]
                'cDgh': 0.75,  # Ventilation discharge coefficient [-]
                'lPipe': 1.25,  # Length of pipe rail system [m m^-2]
                'phiExtCo2': 7.2e4*4e4/1.4e4,  # Capacity of CO2 injection [mg s^-1]
                'pBoil': 300*668,  # Capacity of boiler for the entire greenhouse [W]
 
                # Control settings
                'co2SpDay': 1000,  # CO2 setpoint during the light period [ppm]
                'tSpNight': 18.5,  # temperature set point dark period [°C]
                'tSpDay': 19.5,  # temperature set point light period [°C]
                'rhMax': 87,  # maximum relative humidity [%]
                'ventHeatPband': 4,  # P-band for ventilation due to high temperature [°C]
                'ventRhPband': 50,  # P-band for ventilation due to high RH [% humidity]
                'thScrRhPband': 10,  # P-band for screen opening due to high RH [% humidity]
                'lampsOn': 0,  # time of day to switch on lamps [h]
                'lampsOff': 18,  # time of day to switch off lamps [h]
                'lampsOffSun': 400,  # lamps off if radiation above this value [W m^-2]
                'lampRadSumLimit': 10  # Daily radiation sum limit for lamp use [MJ m^-2 day^-1]
            }
        }
```

This initialization method sets up all the basic parameters and states needed for the simulation.

## Main Methods[](#main-methods)

### `on_begin_new_environment`[](#on_begin_new_environment)

```python
def on_begin_new_environment(self, state):
    """This method is called when the simulation starts a new environment (year/cycle)"""
    # Get indoor temperature sensor handle
    self.temp_sensor_handle = self.api.exchange.get_variable_handle(
        state, "Zone Air Temperature", "GREENHOUSE ZONE ROOF"
    )
    if self.temp_sensor_handle == -1:
        print("Unable to find indoor temperature sensor handle.")
        sys.exit(1)
 
    # Get indoor relative humidity sensor handle
    self.rh_sensor_handle = self.api.exchange.get_variable_handle(
        state, "Zone Air Relative Humidity", "GREENHOUSE ZONE ROOF"
    )
    if self.rh_sensor_handle == -1:
        print("Unable to find indoor relative humidity sensor handle.")
        sys.exit(1)
 
    # Get outdoor air temperature sensor handle
    self.outdoor_air_temp_handle = self.api.exchange.get_variable_handle(
        state, "Site Outdoor Air Drybulb Temperature", "Environment"
    )
    if self.outdoor_air_temp_handle == -1:
        print("Unable to find outdoor air temperature sensor handle.")
 
    # Get indoor air humidity ratio sensor handle
    self.humidity_ratio_handle = self.api.exchange.get_variable_handle(
        state, "Zone Air Humidity Ratio", "GREENHOUSE ZONE ROOF"
    )
    if self.humidity_ratio_handle == -1:
        print("Unable to find indoor air humidity ratio sensor handle.")
```

This method sets up various sensor handles at the start of the simulation for subsequent data retrieval.

### `on_after_new_environment_warmup_complete`[](#on_after_new_environment_warmup_complete)

```python
def on_after_new_environment_warmup_complete(self, state):
    """This method is called after warmup is complete"""
    if not self.simulation_started:
        self.simulation_started = True
        self.total_minutes = 0  # Reset total minutes
```

This method is called after the simulation warmup is complete, marking the official start of the simulation.

### `on_end_of_zone_timestep_after_zone_reporting`[](#on_end_of_zone_timestep_after_zone_reporting)

```python
def on_end_of_zone_timestep_after_zone_reporting(self, state):
    """This method is called at the end of each zone time step"""
    # Read current indoor temperature
    current_temperature = self.api.exchange.get_variable_value(
        state, self.temp_sensor_handle)
 
    # Read current outdoor temperature
    current_outdoor_temperature = self.api.exchange.get_variable_value(
        state, self.outdoor_air_temp_handle)
 
    # Read current indoor air humidity ratio
    current_humidity_ratio = self.api.exchange.get_variable_value(
        state, self.humidity_ratio_handle)
 
    # Calculate current indoor saturated vapor pressure
    ATMOSPHERIC_PRESSURE = 101325  # Standard atmospheric pressure in Pascal (Pa)
    vpTop = (current_humidity_ratio / (0.621945 +
             current_humidity_ratio)) * ATMOSPHERIC_PRESSURE
 
    if self.simulation_started:
        current_time_float = self.api.exchange.current_time(state)
        if self.last_time_step is None:
            # Handle the first time step separately
            self.start_time = 0
            self.end_time = current_time_float * 60
            self.total_minutes = self.end_time
        else:
            # Calculate the minutes of the current time step
            current_minutes = current_time_float * 60
 
            # If the current time step's minutes are less than the previous time step's, it indicates a new day
            if current_minutes < self.last_time_step * 60:
                current_minutes += 1440  # Add minutes of a day
 
            # Update total minutes
            self.total_minutes += current_minutes - self.last_time_step * 60
 
            # Calculate start time and end time
            self.start_time = self.end_time
            self.end_time = self.total_minutes
 
        # Update last_time_step variable
        self.last_time_step = current_time_float
 
        # Run the model, update the start and end times of data to be called based on EnergyPlus output time
        gl = self.model.run_model(gl_params=self.init_state, season_length=self.season_length, season_interval=self.season_interval,
                                  start_row=int(self.start_time), end_row=int(self.end_time),
                                  step=self.current_step)
 
        print(f"start_time: {self.start_time}, end_time: {self.end_time}, step: {self.current_step} season_length: {self.season_length}, season_interval: {self.season_interval}")
 
        self.init_state = gl
 
        # Update GreenLight model state with EnergyPlus output data, achieving data transfer
        self.init_state['x']["tTop"][-1][-1] = current_temperature
        self.init_state['x']["vpTop"][-1][-1] = vpTop
 
        self.current_step += 1
 
        # Calculate fruit yield
        dmc = 0.06
        self.total_yield += 1e-6 * \
            calculate_energy_consumption(gl, "mcFruitHar") / dmc
 
        # Calculate energy consumption from lighting and heating
        self.lampIn += 1e-6 * \
            calculate_energy_consumption(gl, "qLampIn", "qIntLampIn")
        self.boilIn += 1e-6 * \
            calculate_energy_consumption(gl, "hBoilPipe", "hBoilGroPipe")
```

This is the core method of the simulation, called at the end of each time step. It is responsible for updating model state, calculating yield and energy consumption.

### `run`[](#run)

```python
def run(self):
    # Create a new state
    state = self.api.state_manager.new_state()
 
    # Register callback functions for simulation start and end
    self.api.runtime.callback_begin_new_environment(
        state, self.on_begin_new_environment)
    self.api.runtime.callback_after_new_environment_warmup_complete(
        state, self.on_after_new_environment_warmup_complete)
    self.api.runtime.callback_end_zone_timestep_after_zone_reporting(
        state, self.on_end_of_zone_timestep_after_zone_reporting)
 
    # Execute simulation
    self.api.runtime.run_energyplus(
        state,
        [
            "-w", self.epw_path,  # Weather file
            "-d", self.output_directory,  # Output directory
            "-r", "-x", "-m", self.idf_path,  # Simulation options and IDF file path
        ]
    )
```

This method starts and runs the entire simulation process.

### `get_results`[](#get_results)

```python
def get_results(self):
    return self.total_yield, self.lampIn, self.boilIn
```

This method returns the main results of the simulation: total yield, lighting energy consumption, and heating energy consumption.

## Core Functionality Analysis[](#core-functionality-analysis)

1.  **Integration of EnergyPlus and GreenLight Model**:
    
    +   Uses EnergyPlus API to run building energy simulations.
    +   Updates GreenLight model state at each time step.
2.  **Dynamic Data Exchange**:
    
    +   Retrieves environmental data (temperature, humidity, etc.) from EnergyPlus.
    +   Passes this data to the GreenLight model for crop growth simulation.
3.  **Time Management**:
    
    +   Accurately tracks simulation time, handling day transitions.
    +   Ensures synchronization of GreenLight model and EnergyPlus simulation times.
4.  **Performance Indicator Calculation**:
    
    +   Calculates total yield, lighting energy consumption, and heating energy consumption.
    +   Updates these indicators at each time step.
5.  **Flexible Initialization**:
    
    +   Supports starting simulation from mature or immature crop states.
    +   Allows customization of growing season length and start date.
6.  **Sensor Data Processing**:
    
    +   Sets up and uses multiple sensor handles to obtain simulation data.
    +   Processes key parameters such as indoor and outdoor temperature, humidity.
7.  **Simulation Process Control**:
    
    +   Uses callback functions to manage different stages of simulation (start, warmup completion, time step end).

## Considerations[](#considerations)

+   Ensure correct EnergyPlus API instance and file paths are provided.
+   Parameter settings in `init_state` significantly impact simulation results and need to be adjusted based on actual greenhouse conditions.
+   Data exchange during simulation (e.g., temperature, humidity updates) is crucial for result accuracy.
+   Calculation methods for performance indicators (yield, energy consumption) may need adjustment based on specific research needs.
+   For long-term simulations, monitor memory usage; periodic cleanup or optimization of data storage may be necessary.
+   Interpretation of simulation results should consider the assumptions and limitations of both EnergyPlus and GreenLight models.

[1.3 greenhouse\_geometry](https://botanicbyte.com/Code_Structure/core/greenhouse_geometry "1.3 greenhouse_geometry")GreenLightPlus