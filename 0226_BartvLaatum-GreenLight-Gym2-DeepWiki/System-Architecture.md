# 系统架构

> **相关源文件**
> * [CITATION.cff](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/CITATION.cff)
> * [README.md](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md)
> * [gl_gym/environments/tomato_env.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py)
> * [setup.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py)

本文档概述了GreenLight-Gym的多层架构，重点介绍了C++仿真核心、Python环境接口与强化学习组件如何集成，构建完整的温室控制训练系统。关于各层的详细实现，请参见[仿真核心](/BartvLaatum/GreenLight-Gym2/3.1-simulation-core)、[环境接口](/BartvLaatum/GreenLight-Gym2/3.2-environment-interface)和[配置管理](/BartvLaatum/GreenLight-Gym2/3.3-configuration-management)。

## 架构概览

GreenLight-Gym采用分层架构，将数学建模、环境仿真和机器学习等关注点进行分离。该系统通过定义良好的接口，将高性能的C++数值计算与灵活的基于Python的强化学习实验相结合。

### 多层架构

```mermaid
flowchart TD

CasADi["CasADi Framework"]
GLModel["GreenLight C++ Model"]
PyBind["pybind11 Bindings"]
BaseEnv["GreenLightEnv"]
TomatoEnv["TomatoEnv"]
ObsModules["Observation Modules"]
RewardSys["Reward System"]
ExpMgr["experiment_manager.py"]
Agents["RL Agents (PPO/SAC)"]
Callbacks["Training Callbacks"]
EnvConfigs["Environment YAML Configs"]
AgentConfigs["Agent YAML Configs"]
SweepConfigs["Hyperparameter Sweep Configs"]
ResultsCollection["Results Collection"]
Visualization["Visualization Scripts"]
Metrics["Performance Metrics"]

PyBind --> BaseEnv
TomatoEnv --> ExpMgr
EnvConfigs --> TomatoEnv
AgentConfigs --> Agents
SweepConfigs --> ExpMgr
Agents --> ResultsCollection

subgraph subGraph4 ["Analysis Layer"]
    ResultsCollection
    Visualization
    Metrics
    ResultsCollection --> Visualization
    ResultsCollection --> Metrics
end

subgraph subGraph3 ["Configuration Layer"]
    EnvConfigs
    AgentConfigs
    SweepConfigs
end

subgraph subGraph2 ["RL Training Layer"]
    ExpMgr
    Agents
    Callbacks
    ExpMgr --> Agents
    ExpMgr --> Callbacks
end

subgraph subGraph1 ["Python Environment Layer"]
    BaseEnv
    TomatoEnv
    ObsModules
    RewardSys
    BaseEnv --> TomatoEnv
    TomatoEnv --> ObsModules
    TomatoEnv --> RewardSys
end

subgraph subGraph0 ["C++ Simulation Layer"]
    CasADi
    GLModel
    PyBind
    CasADi --> GLModel
    GLModel --> PyBind
end
```

**标题：GreenLight-Gym 多层架构**

来源: [README.md L12-L13](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L12-L13)

 [setup.py L17-L27](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L17-L27)

 [gl_gym/environments/tomato_env.py L27-L66](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L27-L66)

## 核心组件集成

系统的核心集成围绕 `TomatoEnv` 类展开，该类协调 C++ 仿真引擎、观测模块、奖励计算和强化学习智能体之间的交互。

### 环境类层级与依赖关系

```mermaid
flowchart TD

GreenLightEnv["GreenLightEnv<br>(Base Class)"]
TomatoEnv["TomatoEnv<br>(Main Environment)"]
GreenLightModel["gl_gym.environments.models.greenlight_model<br>(C++ Extension)"]
CasADiFunctions["CasADi Functions<br>(ODE Solver)"]
BaseObs["BaseObservations"]
StateObs["StateObservations"]
ClimateObs["IndoorClimateObservations"]
CropObs["BasicCropObservations"]
ControlObs["ControlObservations"]
WeatherObs["WeatherObservations"]
TimeObs["TimeObservations"]
BaseReward["BaseReward"]
GreenhouseReward["GreenhouseReward"]
GymnasiumAPI["gymnasium.Env<br>step(), reset(), render()"]
ActionSpace["spaces.Box(-1, 1)"]
ObsSpace["spaces.Box(obs_low, obs_high)"]

TomatoEnv --> GreenLightModel
TomatoEnv --> BaseObs
TomatoEnv --> BaseReward
TomatoEnv --> GymnasiumAPI
TomatoEnv --> ActionSpace
TomatoEnv --> ObsSpace

subgraph subGraph4 ["Gymnasium Interface"]
    GymnasiumAPI
    ActionSpace
    ObsSpace
end

subgraph subGraph3 ["Reward System"]
    BaseReward
    GreenhouseReward
    BaseReward --> GreenhouseReward
end

subgraph subGraph2 ["Observation System"]
    BaseObs
    StateObs
    ClimateObs
    CropObs
    ControlObs
    WeatherObs
    TimeObs
    BaseObs --> StateObs
    BaseObs --> ClimateObs
    BaseObs --> CropObs
    BaseObs --> ControlObs
    BaseObs --> WeatherObs
    BaseObs --> TimeObs
end

subgraph subGraph1 ["C++ Integration"]
    GreenLightModel
    CasADiFunctions
    GreenLightModel --> CasADiFunctions
end

subgraph subGraph0 ["Core Environment Classes"]
    GreenLightEnv
    TomatoEnv
    GreenLightEnv --> TomatoEnv
end
```

**标题：TomatoEnv 类的依赖关系与集成点**

来源: [gl_gym/environments/tomato_env.py L27-L37](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L27-L37)

 [gl_gym/environments/tomato_env.py L17-L25](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L17-L25)

 [gl_gym/environments/tomato_env.py L44-L49](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L44-L49)

## 数据流架构

系统通过一条清晰的数据管道处理信息，从气象输入到RL智能体决策，每一层都有明确的数据转换节点。

### 环境步进流程

```mermaid
flowchart TD

RLAgent["RL Agent Action<br>[-1, 1] range"]
ActionScale["action_to_control()<br>Scale to control bounds"]
ControlInputs["Control Inputs u<br>[CO2, heating, cooling, etc.]"]
WeatherData["weather_data[timestep]<br>External conditions"]
Parameters["Parameters p<br>Model constants"]
UncertaintyInj["parametric_crop_uncertainty()<br>Parameter perturbation"]
GLModelEval["gl_model.evalF()<br>C++ ODE integration"]
StateUpdate["State x update<br>Greenhouse dynamics"]
ObsModules["observation_modules<br>Multiple observation types"]
ObsCompute["module.compute_obs()<br>Extract observations"]
ObsConcat["np.concatenate()<br>Combine observations"]
FinalObs["Final observation vector"]
RewardComp["reward.compute_reward()<br>Economic performance"]
InfoDict["info dictionary<br>EPI, costs, violations"]

ControlInputs --> GLModelEval
StateUpdate --> ObsModules
StateUpdate --> RewardComp

subgraph subGraph3 ["Reward Calculation"]
    RewardComp
    InfoDict
    RewardComp --> InfoDict
end

subgraph subGraph2 ["Observation Generation"]
    ObsModules
    ObsCompute
    ObsConcat
    FinalObs
    ObsModules --> ObsCompute
    ObsCompute --> ObsConcat
    ObsConcat --> FinalObs
end

subgraph subGraph1 ["Simulation Execution"]
    WeatherData
    Parameters
    UncertaintyInj
    GLModelEval
    StateUpdate
    WeatherData --> GLModelEval
    Parameters --> UncertaintyInj
    UncertaintyInj --> GLModelEval
    GLModelEval --> StateUpdate
end

subgraph subGraph0 ["Input Processing"]
    RLAgent
    ActionScale
    ControlInputs
    RLAgent --> ActionScale
    ActionScale --> ControlInputs
end
```

**标题：TomatoEnv.step() 数据流管线**

来源: [gl_gym/environments/tomato_env.py L115-L146](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L115-L146)

 [gl_gym/environments/tomato_env.py L109-L113](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L109-L113)

 [gl_gym/environments/tomato_env.py L193-L198](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L193-L198)

## 配置与可扩展性

该架构通过 YAML 文件和模块化组件注册支持灵活配置，使得在不同观测空间、奖励函数和智能体类型之间轻松进行实验成为可能。

### 组件注册系统

| 组件类型         | 注册字典                | 示例组件                                      |
| --------------- | ---------------------- | --------------------------------------------- |
| 观测模块         | `OBSERVATION_MODULES`  | `StateObservations`、`IndoorClimateObservations`、`BasicCropObservations` |
| 奖励函数         | `REWARDS`              | `GreenhouseReward`                            |
| 强化学习算法     | Experiment Manager     | `ppo`、`sac`、基于规则的                      |

### 配置流程

```mermaid
flowchart TD

EnvYAML["TomatoEnv.yml<br>Environment parameters"]
AgentYAML["ppo.yml / sac.yml<br>Agent hyperparameters"]
SweepYAML["Sweep configurations<br>Parameter ranges"]
EnvInit["TomatoEnv.init()<br>Parse env config"]
ModuleInit["_init_observations()<br>Initialize observation modules"]
RewardInit["_init_rewards()<br>Initialize reward function"]
AgentInit["Agent initialization<br>Parse agent config"]
ExpManager["ExperimentManager<br>Orchestrate training"]
TrainingLoop["Training loop<br>Agent-environment interaction"]
WandBLog["Weights & Biases<br>Experiment tracking"]

EnvYAML --> EnvInit
AgentYAML --> AgentInit
SweepYAML --> ExpManager
ModuleInit --> TrainingLoop
RewardInit --> TrainingLoop
AgentInit --> TrainingLoop

subgraph subGraph2 ["Experiment Execution"]
    ExpManager
    TrainingLoop
    WandBLog
    ExpManager --> TrainingLoop
    TrainingLoop --> WandBLog
end

subgraph subGraph1 ["Runtime Initialization"]
    EnvInit
    ModuleInit
    RewardInit
    AgentInit
    EnvInit --> ModuleInit
    EnvInit --> RewardInit
end

subgraph subGraph0 ["Configuration Files"]
    EnvYAML
    AgentYAML
    SweepYAML
end
```

**标题：配置系统与运行时初始化**

来源: [gl_gym/environments/tomato_env.py L28-L66](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L28-L66)

 [gl_gym/environments/tomato_env.py L77-L81](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L77-L81)

 [gl_gym/environments/tomato_env.py L100-L101](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/tomato_env.py#L100-L101)

## 构建与集成系统

本系统使用 `pybind11` 为 C++ 仿真核心创建 Python 绑定，从而实现高性能数值计算与灵活的 Python 实验框架之间的无缝集成。

### C++ 扩展构建流程

| 构建组件         | 描述                                 | 文件参考 |
| --------------- | ------------------------------------ | -------- |
| 扩展定义         | `greenlight_model` 扩展模块          | [setup.py L17-L27](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L17-L27) |
| 包含目录         | CasADi 头文件、pybind11 头文件        | [setup.py L21](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L21-L21) |
| 库依赖           | CasADi 共享库                        | [setup.py L22-L23](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L22-L23) |
| 编译参数         | C++17 标准，位置无关代码              | [setup.py L25](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L25-L25) |

构建系统会自动发现 CasADi 的安装路径，并在执行 `pip install -e .` 时配置 Python 扩展模块，从而在 C++ 的 `GreenLight` 模型与 Python 的 `TomatoEnv` 接口之间建立直接桥梁。

来源: [setup.py L1-L44](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L1-L44)

 [README.md L34-L72](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L34-L72)

 [README.md L92-L100](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L92-L100)