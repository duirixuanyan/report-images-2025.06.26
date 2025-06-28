# 高级主题

> **相关源文件**
> * [gl_gym/environments/observations.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py)
> * [gl_gym/environments/rewards.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py)

本节介绍构成 GreenLight-Gym 强化学习环境核心的复杂技术组件。这些高级系统负责处理实现温室控制仿真所需的复杂经济建模、多模态感知和参数管理。

本节内容侧重于实现细节和架构决策，适用于需要理解、修改或扩展核心系统的用户。关于智能体的基本用法和训练流程，请参见 [Reinforcement Learning](/BartvLaatum/GreenLight-Gym2/4-reinforcement-learning)。关于结果分析和性能指标，请参见 [Analysis and Visualization](/BartvLaatum/GreenLight-Gym2/5-analysis-and-visualization)。

## 系统集成架构

GreenLight-Gym 的高级组件采用模块化设计模式，专用子系统分别处理仿真环境的不同方面。核心集成通过 `TomatoEnv` 类实现，该类协调奖励计算、观测处理和参数管理等各个部分的交互。

```mermaid
flowchart TD

TomatoEnv["TomatoEnv<br>环境协调器"]
GLCore["GreenLight C++ 核心<br>物理仿真"]
BaseReward["BaseReward<br>抽象接口"]
GreenhouseReward["GreenhouseReward<br>经济模型"]
CostCalculation["成本计算<br>供热、CO2、电力"]
ViolationPenalties["违规惩罚<br>约束执行"]
BaseObs["BaseObservations<br>抽象接口"]
ClimateObs["室内气候观测<br>CO2、温度、相对湿度"]
CropObs["作物基础观测<br>作物状态"]
ControlObs["控制观测<br>当前动作"]
WeatherObs["天气观测<br>当前天气"]
TimeObs["时间观测<br>时间特征"]
ForecastObs["天气预报观测<br>未来天气"]
ConfigSystem["配置系统<br>YAML参数加载"]
UncertaintyInjection["不确定性注入<br>参数扰动"]
ResultsCollection["结果收集<br>状态与指标存储"]

TomatoEnv --> BaseReward
TomatoEnv --> BaseObs
TomatoEnv --> ConfigSystem
TomatoEnv --> ResultsCollection
GLCore --> GreenhouseReward
GLCore --> ClimateObs
GLCore --> CropObs

subgraph subGraph3 ["参数管理"]
    ConfigSystem
    UncertaintyInjection
    ResultsCollection
    ConfigSystem --> UncertaintyInjection
end

subgraph subGraph2 ["观测系统"]
    BaseObs
    ClimateObs
    CropObs
    ControlObs
    WeatherObs
    TimeObs
    ForecastObs
    BaseObs --> ClimateObs
    BaseObs --> CropObs
    BaseObs --> ControlObs
    BaseObs --> WeatherObs
    BaseObs --> TimeObs
    BaseObs --> ForecastObs
end

subgraph subGraph1 ["奖励系统"]
    BaseReward
    GreenhouseReward
    CostCalculation
    ViolationPenalties
    BaseReward --> GreenhouseReward
    GreenhouseReward --> CostCalculation
    GreenhouseReward --> ViolationPenalties
end

subgraph subGraph0 ["环境核心"]
    TomatoEnv
    GLCore
    GLCore --> TomatoEnv
end
```

**来源:** [gl_gym/environments/rewards.py L1-L232](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L1-L232)

 [gl_gym/environments/observations.py L1-L182](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L1-L182)

## 经济建模框架

奖励系统实现了一个全面的经济模型，能够反映温室运营中的真实财务考量。`GreenhouseReward` 类是主要的实现方式，其通过作物收入与运营成本的差额来计算利润。

| 成本类别 | 组成部分 | 计算方法 |
| --- | --- | --- |
| 固定成本 | 温室、CO2系统、灯具、遮阳帘 | 年度成本按时间步长分摊 |
| 变动成本 | 供热、电力、CO2施用 | 能耗 × 单价 |
| 收入 | 果实产量 | 生长速率 × 单价（€/kg） |
| 罚金 | 约束违规、控制违规 | 加权罚金函数 |

```mermaid
flowchart TD

FruitGrowth["果实生长<br>x[25] - x_prev[25]"]
DMToFM["干物质转鲜物质<br>dmfm 转换"]
FruitPrice["果实价格<br>€/kg"]
Revenue["收入<br>€/m²/时间步"]
HeatingCost["供暖成本<br>u[0] × heating_price"]
ElecCost["电力成本<br>u[4] × elec_price"]
CO2Cost["CO2成本<br>u[1] × co2_price"]
FixedCost["固定成本<br>每日摊销"]
TotalCosts["总成本<br>€/m²/时间步"]
ConstraintViolations["约束违规<br>CO2、温度、湿度"]
ControlViolations["控制违规<br>夜间灯光使用"]
WeightedPenalties["加权罚金<br>pen_weights × violations"]
Profit["最终奖励<br>缩放利润 - 罚金"]

Revenue --> Profit
TotalCosts --> Profit
WeightedPenalties --> Profit

subgraph subGraph2 ["罚金系统"]
    ConstraintViolations
    ControlViolations
    WeightedPenalties
    ConstraintViolations --> WeightedPenalties
    ControlViolations --> WeightedPenalties
end

subgraph subGraph1 ["成本计算"]
    HeatingCost
    ElecCost
    CO2Cost
    FixedCost
    TotalCosts
    HeatingCost --> TotalCosts
    ElecCost --> TotalCosts
    CO2Cost --> TotalCosts
    FixedCost --> TotalCosts
end

subgraph subGraph0 ["收入计算"]
    FruitGrowth
    DMToFM
    FruitPrice
    Revenue
    FruitGrowth --> DMToFM
    DMToFM --> FruitPrice
    FruitPrice --> Revenue
end
```

**来源:** [gl_gym/environments/rewards.py L22-L232](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L22-L232)

 [gl_gym/environments/rewards.py L172-L184](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L172-L184)

 [gl_gym/environments/rewards.py L218-L231](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L218-L231)

## 多模态观测架构

观测系统采用模块化设计，不同的观测模块负责捕捉温室环境的不同方面。每个模块都实现了 `BaseObservations` 接口，并且可以组合使用，以构建全面的状态表示。

```mermaid
flowchart TD

Climate["室内气候观测<br>['co2_air', 'temp_air', 'rh_air', 'pipe_temp']"]
Crop["作物基础观测<br>['24CanTemp', 'cFruit', 'tSum']"]
Control["控制观测<br>['uBoil', 'uCo2', 'uThScr', 'uVent', 'uLamp', 'uBlScr']"]
Weather["天气观测<br>['glob_rad', 'temp_out', 'rh_out', 'co2_out', 'wind_speed']"]
Time["时间观测<br>['timestep', 'day_sin', 'day_cos', 'hour_sin', 'hour_cos']"]
Forecast["天气预测观测<br>未来天气 × Np 步"]
RawStates["原始状态<br>env.x, env.u, env.weather_data"]
UnitConversion["单位转换<br>co2dens2ppm, vaporPres2rh"]
Normalization["归一化<br>时间编码"]
ObservationVector["最终观测向量<br>np.ndarray"]

Climate --> RawStates
Crop --> RawStates
Control --> RawStates
Weather --> RawStates
Time --> RawStates
Forecast --> RawStates

subgraph subGraph1 ["状态处理流程"]
    RawStates
    UnitConversion
    Normalization
    ObservationVector
    RawStates --> UnitConversion
    UnitConversion --> Normalization
    Normalization --> ObservationVector
end

subgraph subGraph0 ["观测模块类型"]
    Climate
    Crop
    Control
    Weather
    Time
    Forecast
end
```

**来源:** [gl_gym/environments/observations.py L59-L182](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L59-L182)

 [gl_gym/environments/observations.py L70-L77](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L70-L77)

 [gl_gym/environments/observations.py L149-L161](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L149-L161)

## 数据流与处理流程

高级系统通过结构化的流水线处理信息，将原始仿真数据转化为对强化学习智能体有意义的观测和奖励。

```mermaid
flowchart TD

SimState["仿真状态<br>env.x（27个状态）"]
ControlInputs["控制输入<br>env.u（6个控制量）"]
WeatherData["天气数据<br>env.weather_data"]
Parameters["模型参数<br>env.p（参数向量）"]
ObservationProcessing["观测处理"]
RewardCalculation["奖励计算"]
ConstraintChecking["约束检查"]
ClimateModule["IndoorClimateObservations.compute_obs()（室内气候观测）"]
CropModule["BasicCropObservations.compute_obs()（作物基础观测）"]
ControlModule["ControlObservations.compute_obs()（控制观测）"]
WeatherModule["WeatherObservations.compute_obs()（天气观测）"]
TimeModule["TimeObservations.compute_obs()（时间观测）"]
EconomicCalc["GreenhouseReward._gains()（收益计算）"]
CostCalc["GreenhouseReward._variable_costs()（可变成本计算）"]
ViolationCalc["GreenhouseReward.output_violations()（违规输出计算）"]
ObsVector["观测向量<br>特征拼接"]
RewardValue["奖励值<br>经济表现归一化"]
ViolationPenalties["违规惩罚<br>约束执行"]

SimState --> ObservationProcessing
ControlInputs --> ObservationProcessing
WeatherData --> ObservationProcessing
SimState --> RewardCalculation
ControlInputs --> RewardCalculation
Parameters --> RewardCalculation
SimState --> ConstraintChecking
ObservationProcessing --> ClimateModule
ObservationProcessing --> CropModule
ObservationProcessing --> ControlModule
ObservationProcessing --> WeatherModule
ObservationProcessing --> TimeModule
RewardCalculation --> EconomicCalc
RewardCalculation --> CostCalc
ConstraintChecking --> ViolationCalc
ClimateModule --> ObsVector
CropModule --> ObsVector
ControlModule --> ObsVector
WeatherModule --> ObsVector
TimeModule --> ObsVector
EconomicCalc --> RewardValue
CostCalc --> RewardValue
ViolationCalc --> ViolationPenalties

subgraph Outputs ["输出"]
    ObsVector
    RewardValue
    ViolationPenalties
end

subgraph subGraph2 ["模块实现"]
    ClimateModule
    CropModule
    ControlModule
    WeatherModule
    TimeModule
    EconomicCalc
    CostCalc
    ViolationCalc
end

subgraph subGraph1 ["处理模块"]
    ObservationProcessing
    RewardCalculation
    ConstraintChecking
end

subgraph subGraph0 ["输入数据源"]
    SimState
    ControlInputs
    WeatherData
    Parameters
end
```

**来源：** [gl_gym/environments/observations.py L70-L112](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L70-L112)

 [gl_gym/environments/rewards.py L172-L231](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L172-L231)

## 详细组件覆盖

以下小节为每个高级系统组件提供了全面的技术文档：

* **[奖励系统](/BartvLaatum/GreenLight-Gym2/6.1-reward-system)**：经济建模、成本计算、约束违规和利润优化
* **[观测系统](/BartvLaatum/GreenLight-Gym2/6.2-observation-system)**：多模态传感模块、状态处理和特征工程
* **[参数管理](/BartvLaatum/GreenLight-Gym2/6.3-parameter-management)**：配置处理、不确定性注入和模型参数控制
* **[工具与实用程序](/BartvLaatum/GreenLight-Gym2/6.4-utilities-and-tools)**：用于数据处理、状态初始化和系统工具的支持函数

每个小节都包含了详细的实现细节、配置选项，以及为使用 GreenLight-Gym 框架的研究人员和开发者提供的扩展指导。

**来源：** [gl_gym/environments/rewards.py L1-L232](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/rewards.py#L1-L232)

 [gl_gym/environments/observations.py L1-L182](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/observations.py#L1-L182)