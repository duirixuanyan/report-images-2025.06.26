## 2\. GreenLight 基本使用[](#2-basic-usage-of-greenlight)

开始前请确保已安装以下依赖项:

```bash
pip install GreenLightPlus
```

### 2.1 导入必要模块[](#21-import-necessary-modules)

```python
from GreenLightPlus import (
    GreenLightModel,
    extract_last_value_from_nested_dict,
    calculate_energy_consumption,
    plot_green_light,
)
```

### 2.2 设置基本参数[](#22-set-basic-parameters)

```python
season_length = 10  
season_interval = 10  
first_day = 91  
 
# Parameter Descriptions:
# - season_length: Length of the growth cycle (days), can be fractional
# - season_interval: Time interval for each model run (days), can be fractional, e.g., 1/24/4 means 15 minutes
# - first_day: The first day of the growth cycle (day of the year)
```

### 2.3 创建 GreenLight 模型实例[](#23-create-a-greenlight-model-instance)

```python
model = GreenLightModel(first_day=first_day, isMature=True, epw_path="NLD_Amsterdam.062400_IWEC.epw")
 
# Parameter Descriptions:
# - first_day: Start date of the simulation (day of the year)
# - isMature: Indicates whether the crop is mature
# - epw_path: Path to the weather data file
```

### 2.4 初始化模型状态和参数[](#24-initialize-model-state-and-parameters)

```python
init_state = {
    "p": {
        # Greenhouse structure settings
        'psi': 22,  # Average slope of greenhouse cover (degrees)
        'aFlr': 4e4,  # Floor area (m^2)
        'aCov': 4.84e4,  # Covered area, including side walls (m^2)
        'hAir': 6.3,  # Height of the main region (m)
        'hGh': 6.905,  # Average height of the greenhouse (m)
        'aRoof': 0.1169 * 4e4,  # Maximum roof ventilation area (m^2)
        'hVent': 1.3,  # Vertical size of a single vent (m)
        'cDgh': 0.75,  # Vent discharge coefficient (dimensionless)
        'lPipe': 1.25,  # Length of the pipe rail system (m/m^2)
        'phiExtCo2': 7.2e4 * 4e4 / 1.4e4,  # CO2 injection capacity for the entire greenhouse (mg/s)
        'pBoil': 300 * 4e4,  # Boiler capacity for the entire greenhouse (W)
 
        # Control settings
        'co2SpDay': 1000,  # CO2 set point during lighting (ppm)
        'tSpNight': 18.5,  # Temperature set point during dark period (°C)
        'tSpDay': 19.5,  # Temperature set point during lighting (°C)
        'rhMax': 87,  # Maximum relative humidity (%)
        'ventHeatPband': 4,  # P-band for high temperature ventilation (°C)
        'ventRhPband': 50,  # P-band for high relative humidity ventilation (% humidity)
        'thScrRhPband': 10,  # P-band for high relative humidity screen opening (% humidity)
        'lampsOn': 0,  # Time for lamps to turn on (h)
        'lampsOff': 18,  # Time for lamps to turn off (h)
        'lampsOffSun': 400,  # Turn off lamps when global radiation exceeds this value (W/m^2)
        'lampRadSumLimit': 10  # Use lamps when the predicted daily solar radiation sum is below this value (MJ/m^2/day)
    }
}
# Parameter Descriptions:
# - More parameters can be found in the greenlight/set_gl_params.py file
```

### 2.5 运行模型模拟[](#25-run-model-simulation)

```python
# Initialize cumulative variables
total_yield = 0  # Total yield (kg/m2)
lampIn = 0  # Lighting energy consumption (MJ/m2)
boilIn = 0  # Heating energy consumption (MJ/m2)
 
# Run the model based on the growth cycle and time interval
for current_step in range(int(season_length // season_interval)):
    # Run the model and get results
    gl = model.run_model(gl_params=init_state, 
                         season_length=season_length,
                         season_interval=season_interval, 
                         step=current_step)
    
    # Update initial state with current model output
    init_state = gl
    
    dmc = 0.06  # Dry Matter Content
 
    # Calculate the yield for the current step (kg/m2)
    # mcFruitHar is the mass of harvested fruit (g/m2), divided by dmc to convert to fresh weight
    current_yield = 1e-6 * calculate_energy_consumption(gl, 'mcFruitHar') / dmc
    print(f"Current yield: {current_yield:.2f} kg/m2")
 
    # Accumulate total yield
    total_yield += current_yield
 
    # Calculate and accumulate lighting energy consumption (MJ/m2)
    # qLampIn is the lamp input power (W/m2), qIntLampIn is the internal heat from lamps (W/m2)
    lampIn += 1e-6 * calculate_energy_consumption(gl, "qLampIn", "qIntLampIn")
 
    # Calculate and accumulate heating energy consumption (MJ/m2)
    # hBoilPipe is the pipe heating power (W/m2), hBoilGroPipe is the ground pipe heating power (W/m2)
    boilIn += 1e-6 * calculate_energy_consumption(gl, "hBoilPipe", "hBoilGroPipe")
```

### 2.6 输出结果[](#26-output-results)

```python
# Plot the model results
plot_green_light(gl)
```

### 2.7 完整代码示例[](#27-complete-code-example)

```python
from GreenLightPlus import (
    GreenLightModel,
    extract_last_value_from_nested_dict,
    calculate_energy_consumption,
    plot_green_light,
)
 
# Set simulation parameters
season_length = 10  # Length of the growth cycle (days), can be fractional
season_interval = 10  # Time interval for each model run (days), can be fractional, e.g., 1/24/4 means 15 minutes
first_day = 91  # The first day of the growth cycle (day of the year)
 
# Create a GreenLight model instance
# Parameter Descriptions:
# - first_day: Start date of the simulation (day of the year)
# - isMature: Indicates whether the crop is mature
# - epw_path: Path to the weather data file
model = GreenLightModel(first_day=first_day, isMature=True, epw_path="NLD_Amsterdam.062400_IWEC.epw")
 
# Initialize cumulative variables
total_yield = 0  # Total yield (kg/m2)
lampIn = 0  # Lighting energy consumption (MJ/m2)
boilIn = 0  # Heating energy consumption (MJ/m2)
 
# Initialize model state and parameters
init_state = {
    "p": {
        # Greenhouse structure settings
        'psi': 22,  # Average slope of greenhouse cover (degrees)
        'aFlr': 4e4,  # Floor area (m^2)
        'aCov': 4.84e4,  # Covered area, including side walls (m^2)
        'hAir': 6.3,  # Height of the main region (m) (ridge height is 6.5m, screen is 20cm below)
        'hGh': 6.905,  # Average height of the greenhouse (m)
        'aRoof': 0.1169 * 4e4,  # Maximum roof ventilation area (m^2)
        'hVent': 1.3,  # Vertical size of a single vent (m)
        'cDgh': 0.75,  # Vent discharge coefficient (dimensionless)
        'lPipe': 1.25,  # Length of the pipe rail system (m/m^2)
        'phiExtCo2': 7.2e4 * 4e4 / 1.4e4,  # CO2 injection capacity for the entire greenhouse (mg/s)
        'pBoil': 300 * 4e4,  # Boiler capacity for the entire greenhouse (W)
 
        # Control settings
        'co2SpDay': 1000,  # CO2 set point during lighting (ppm)
        'tSpNight': 18.5,  # Temperature set point during dark period (°C)
        'tSpDay': 19.5,  # Temperature set point during lighting (°C)
        'rhMax': 87,  # Maximum relative humidity (%)
        'ventHeatPband': 4,  # P-band for high temperature ventilation (°C)
        'ventRhPband': 50,  # P-band for high relative humidity ventilation (% humidity)
        'thScrRhPband': 10,  # P-band for high relative humidity screen opening (% humidity)
        'lampsOn': 0,  # Time for lamps to turn on (h)
        'lampsOff': 18,  #
 
 Time for lamps to turn off (h)
        'lampsOffSun': 400,  # Turn off lamps when global radiation exceeds this value (W/m^2)
        'lampRadSumLimit': 10  # Use lamps when the predicted daily solar radiation sum is below this value (MJ/m^2/day)
    }
}
 
# Run the model based on the growth cycle and time interval
for current_step in range(int(season_length // season_interval)):
    # Run the model and get results
    gl = model.run_model(gl_params=init_state, season_length=season_length,
                         season_interval=season_interval, step=current_step)
    init_state = gl
    dmc = 0.06  # Dry Matter Content
 
    # Calculate and print the current yield (kg/m2)
    current_yield = 1e-6 * calculate_energy_consumption(gl, 'mcFruitHar') / dmc
    print(f"Current yield: {current_yield:.2f} kg/m2")
 
    # Accumulate total fruit yield (kg/m2)
    total_yield += current_yield
 
    # Calculate and accumulate energy consumption from lighting and heating (MJ/m2)
    lampIn += 1e-6 * calculate_energy_consumption(gl, "qLampIn", "qIntLampIn")
    boilIn += 1e-6 * calculate_energy_consumption(gl, "hBoilPipe", "hBoilGroPipe")
 
# Print final results
print(f"Total yield: {total_yield:.2f} kg/m2")
print(f"Lighting energy consumption: {lampIn:.2f} MJ/m2")
print(f"Heating energy consumption: {boilIn:.2f} MJ/m2")
print(f"Energy consumption per unit yield: {(lampIn + boilIn)/total_yield:.2f} MJ/kg")
 
# Plot the model results
plot_green_light(gl)
```

[1. 安装](https://botanicbyte.com/Tutorial/Installation "1. 安装")[3. 强化学习环境](https://botanicbyte.com/Tutorial/GreenhouseEnv "3. 强化学习环境")