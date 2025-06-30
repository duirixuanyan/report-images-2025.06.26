1.4 温室模拟

## GreenhouseSimulation 类详细说明

`GreenhouseSimulation` 类是 GreenLightPlus 项目的核心组件，负责集成 EnergyPlus 模拟和 GreenLight 模型。它管理模拟流程、处理数据交换并计算关键性能指标。

## 类定义与初始化[](#class-definition-and-initialization)

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

此初始化方法设置了模拟所需的所有基本参数和状态。

## 主要方法[](#main-methods)

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

此方法在模拟开始时设置各种传感器句柄，以便后续数据获取。

### `on_after_new_environment_warmup_complete`[](#on_after_new_environment_warmup_complete)

```python
def on_after_new_environment_warmup_complete(self, state):
    """This method is called after warmup is complete"""
    if not self.simulation_started:
        self.simulation_started = True
        self.total_minutes = 0  # Reset total minutes
```

此方法在模拟预热完成后调用，标志着模拟的正式开始。

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

这是模拟的核心方法，在每个时间步结束时调用。它负责更新模型状态、计算产量和能耗。

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

该方法启动并运行整个模拟过程。

### `get_results`[](#get_results)

```python
def get_results(self):
    return self.total_yield, self.lampIn, self.boilIn
```

该方法返回模拟的主要结果：总产量、照明能耗和加热能耗。

## 核心功能分析[](#core-functionality-analysis)

1.  **EnergyPlus与GreenLight模型集成**:
    
    +   使用EnergyPlus API运行建筑能耗模拟
    +   在每个时间步更新GreenLight模型状态
2.  **动态数据交换**:
    
    +   从EnergyPlus获取环境数据(温度、湿度等)
    +   将这些数据传输给GreenLight模型用于作物生长模拟
3.  **时间管理**:
    
    +   精确追踪模拟时间，处理日期转换
    +   确保GreenLight模型与EnergyPlus模拟时间同步
4.  **性能指标计算**:
    
    +   计算总产量、照明能耗和加热能耗
    +   每个时间步更新这些指标
5.  **灵活的初始化**:
    
    +   支持从成熟或未成熟作物状态开始模拟
    +   允许自定义生长季节长度和开始日期
6.  **传感器数据处理**:
    
    +   设置并使用多个传感器句柄获取模拟数据
    +   处理关键参数如室内外温度、湿度
7.  **模拟过程控制**:
    
    +   使用回调函数管理模拟的不同阶段(开始、预热完成、时间步结束)

## 注意事项[](#considerations)

+   确保提供正确的EnergyPlus API实例和文件路径
+   `init_state`中的参数设置会显著影响模拟结果，需要根据实际温室条件调整
+   模拟期间的数据交换(如温度、湿度更新)对结果准确性至关重要
+   性能指标(产量、能耗)的计算方法可能需要根据具体研究需求调整
+   对于长期模拟，需监控内存使用情况，可能需要定期清理或优化数据存储
+   解释模拟结果时应考虑EnergyPlus和GreenLight模型的假设和局限性

[1.3 greenhouse\_geometry](https://botanicbyte.com/Code_Structure/core/greenhouse_geometry "1.3 greenhouse_geometry")GreenLightPlus