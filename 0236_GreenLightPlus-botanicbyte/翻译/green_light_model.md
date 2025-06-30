## GreenLightModel 类详细说明

`GreenLightModel` 类是 GreenLightPlus 项目的核心组件，负责模拟温室环境和补光系统。本文档详细分析了该类的结构、功能和实现细节。

## 类概述[](#class-overview)

`GreenLightModel` 类允许用户运行温室环境模拟，包括补光系统。它集成了来自多个模块的功能，如天气数据处理、控制策略加载和参数设置，以提供全面的温室模拟能力。

## 主要属性[](#main-attributes)

+   `filename`: 模型结果的输出文件名
+   `first_day`: 模拟开始日期
+   `lampType`: 使用的灯具类型 (LED 或 HPS)
+   `isMature`: 是否从成熟作物阶段开始模拟
+   `controls_file`: 控制策略文件路径
+   `epw_path`: EPW 天气文件路径
+   `csv_path`: CSV 天气文件路径
+   `artificialWeather`: 是否使用人工天气数据
+   `controls`: 控制策略数据
+   `u`: ODE 求解器的 'u' 参数矩阵
+   `weather`: 天气数据
+   `elevation`: 海拔参数
+   `gl`: GreenLight 模型数据和参数
+   `d`: ODE 求解器的 'd' 参数矩阵

## 主要方法[](#main-methods)

### `__init__`[](#__init__)

初始化 `GreenLightModel` 实例，设置基本参数和文件路径。

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

该方法用于设置模型的初始参数，包括文件名、开始日期、灯具类型、作物成熟状态、控制文件路径和天气数据文件路径。

### `_get_weather_data_path`[](#_get_weather_data_path)

确定天气数据文件的路径，必要时将EPW格式转换为CSV格式。

```python
def _get_weather_data_path(self):
    if self.csv_path is None:
        return convert_epw2csv(epw_path=self.epw_path, time_step=5)
    return self.csv_path
```

该方法检查是否提供了CSV文件路径。如果没有，则调用`convert_epw2csv`函数将EPW文件转换为CSV格式。

### `_load_weather_data`[](#_load_weather_data)

从指定路径加载天气数据，并根据起始行和结束行进行切片。

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

该方法负责加载天气数据。支持人工生成的天气数据、MAT文件和CSV文件格式。根据提供的起始行和结束行对数据进行切片。

### `_set_elevation`[](#_set_elevation)

根据天气数据设置海拔高度属性。

```python
def _set_elevation(self):
    if self.weather.shape[0] > 0 and self.weather.shape[1] >= 10:
        self.elevation = self.weather[0, 9]
    else:
        self.elevation = 0
        print("Warning: weather data is not properly initialized.")
```

该方法从天气数据中提取海拔高度信息。如果天气数据不完整，则将海拔高度设为0并发出警告。

### `_load_controls`[](#_load_controls)

如果提供了控制文件，则加载控制策略。

```python
def _load_controls(self):
    if self.controls_file is not None:
        controls = pd.read_csv(self.controls_file, header=None, skiprows=1)
        self.controls = controls.to_numpy()
        print(f"controls.shape: {self.controls.shape}")
```

该方法从CSV文件加载控制策略数据并将其转换为NumPy数组。

### `_initialize_green_light_model`[](#_initialize_green_light_model)

使用提供的灯类型、天气数据和控制策略初始化GreenLight模型。

```python
def _initialize_green_light_model(self):
    self.gl = create_green_light_model(self.lampType, self.weather, self.controls)
    self.gl = set_params4ha_world_comparison(self.gl)
    self.gl["p"]["hElevation"] = self.elevation
```

该方法创建GreenLight模型，设置比较参数，并设置海拔参数。

### `_set_dependent_params`[](#_set_dependent_params)

设置GreenLight模型的依赖参数。

```python
def _set_dependent_params(self):
    self.gl = set_dep_params(self.gl)
```

该方法调用`set_dep_params`函数来设置模型的依赖参数。

### `_prepare_ode_parameters`[](#_prepare_ode_parameters)

准备ODE求解器所需的'd'和'u'参数矩阵。

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

该方法为ODE求解器准备参数矩阵。它会处理'd'参数矩阵，如果提供了控制文件，还会准备'u'参数矩阵。

### `_prepare_data_and_params`[](#_prepare_data_and_params)

准备GreenLight模型模拟所需的数据和参数。

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

该方法整合了数据准备的所有步骤，包括加载天气数据、设置海拔高度、加载控制策略、初始化模型、设置依赖参数以及准备ODE参数。

### `run_model`[](#run_model)

运行GreenLight模型并生成结果。这是该类的核心方法，整合了所有其他方法的功能。

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

该方法是模型运行的核心，执行以下步骤：

1.  确定天气数据的起始和结束行
2.  准备数据和参数
3.  如果提供了额外参数，则更新模型参数
4.  如果从成熟作物开始，则设置初始条件
5.  设置ODE求解器的参数和方法
6.  创建ODESolver实例并求解微分方程
7.  调整结果的时间分辨率
8.  返回模拟结果

## 核心功能分析[](#core-functionality-analysis)

1.  **天气数据处理**：
    
    +   支持EPW和CSV格式的天气数据
    +   可使用人工生成的天气数据进行模拟
    +   提供数据切片功能以模拟特定时间段
2.  **控制策略集成**：
    
    +   允许从外部CSV文件加载控制策略
    +   支持动态更新模型参数
3.  **模型初始化**：
    
    +   可以从成熟作物阶段开始模拟
    +   支持设置不同类型的补光系统(LED或HPS)
    +   自动处理依赖参数设置
4.  **ODE求解**：
    
    +   使用`scipy.integrate.solve_ivp`求解微分方程组
    +   支持调整求解器参数和方法
    +   采用后向微分公式(BDF)方法进行数值积分
5.  **结果处理**：
    
    +   支持调整结果的时间分辨率
    +   生成包含所有相关参数和状态变量的完整模拟结果字典

## 注意事项[](#considerations)

+   确保提供正确的天气数据文件路径(EPW或CSV格式)
+   控制策略文件(如使用)应符合预定义格式
+   模拟时间步长(`time_step`)影响计算精度和效率，需适当调整
+   使用人工天气数据时，确保数据格式符合模型预期
+   长期模拟需注意内存使用，可能需要分段处理或优化数据存储
+   更新模型参数(通过`gl_params`)时，确保新参数与模型结构兼容
+   `isMature`参数仅在模拟第一步(`step=0`)时生效

[1. 核心组件](https://botanicbyte.com/Code_Structure/core "1. Core Components")[1.2 greenhouse_env](https://botanicbyte.com/Code_Structure/core/greenhouse_env "1.2 greenhouse_env")