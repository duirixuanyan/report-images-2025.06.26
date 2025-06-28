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

CasADi["CasADi 框架"]
GLModel["GreenLight C++ 模型"]
PyBind["pybind11 绑定"]
BaseEnv["GreenLight 环境"]
TomatoEnv["番茄环境"]
ObsModules["观测模块"]
RewardSys["奖励系统"]
ExpMgr["实验管理器 experiment_manager.py"]
Agents["强化学习智能体（PPO/SAC）"]
Callbacks["训练回调"]
EnvConfigs["环境 YAML 配置"]
AgentConfigs["智能体 YAML 配置"]
SweepConfigs["超参数搜索配置"]
ResultsCollection["结果收集"]
Visualization["可视化脚本"]
Metrics["性能指标"]

PyBind --> BaseEnv
TomatoEnv --> ExpMgr
EnvConfigs --> TomatoEnv
AgentConfigs --> Agents
SweepConfigs --> ExpMgr
Agents --> ResultsCollection

subgraph subGraph4 ["分析层"]
    ResultsCollection
    Visualization
    Metrics
    ResultsCollection --> Visualization
    ResultsCollection --> Metrics
end

subgraph subGraph3 ["配置层"]
    EnvConfigs
    AgentConfigs
    SweepConfigs
end

subgraph subGraph2 ["强化学习训练层"]
    ExpMgr
    Agents
    Callbacks
    ExpMgr --> Agents
    ExpMgr --> Callbacks
end

subgraph subGraph1 ["Python 环境层"]
    BaseEnv
    TomatoEnv
    ObsModules
    RewardSys
    BaseEnv --> TomatoEnv
    TomatoEnv --> ObsModules
    TomatoEnv --> RewardSys
end

subgraph subGraph0 ["C++ 仿真层"]
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

GreenLightEnv["GreenLightEnv<br>（基类）"]
TomatoEnv["TomatoEnv<br>（主环境）"]
GreenLightModel["gl_gym.environments.models.greenlight_model<br>（C++ 扩展）"]
CasADiFunctions["CasADi 函数<br>（ODE 求解器）"]
BaseObs["基础观测"]
StateObs["状态观测"]
ClimateObs["室内气候观测"]
CropObs["作物基础观测"]
ControlObs["控制观测"]
WeatherObs["天气观测"]
TimeObs["时间观测"]
BaseReward["基础奖励"]
GreenhouseReward["温室奖励"]
GymnasiumAPI["gymnasium.Env<br>step()、reset()、render()"]
ActionSpace["spaces.Box(-1, 1)"]
ObsSpace["spaces.Box(obs_low, obs_high)"]

TomatoEnv --> GreenLightModel
TomatoEnv --> BaseObs
TomatoEnv --> BaseReward
TomatoEnv --> GymnasiumAPI
TomatoEnv --> ActionSpace
TomatoEnv --> ObsSpace

subgraph subGraph4 ["Gymnasium 接口"]
    GymnasiumAPI
    ActionSpace
    ObsSpace
end

subgraph subGraph3 ["奖励系统"]
    BaseReward
    GreenhouseReward
    BaseReward --> GreenhouseReward
end

subgraph subGraph2 ["观测系统"]
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

subgraph subGraph1 ["C++ 集成"]
    GreenLightModel
    CasADiFunctions
    GreenLightModel --> CasADiFunctions
end

subgraph subGraph0 ["核心环境类"]
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

RLAgent["RL智能体动作<br>[-1, 1] 范围"]
ActionScale["action_to_control()<br>缩放到控制边界"]
ControlInputs["控制输入 u<br>[CO2、加热、冷却等]"]
WeatherData["weather_data[时间步]<br>外部环境条件"]
Parameters["参数 p<br>模型常数"]
UncertaintyInj["parametric_crop_uncertainty()<br>参数扰动"]
GLModelEval["gl_model.evalF()<br>C++ ODE 积分"]
StateUpdate["状态 x 更新<br>温室动力学"]
ObsModules["观测模块<br>多种观测类型"]
ObsCompute["module.compute_obs()<br>提取观测值"]
ObsConcat["np.concatenate()<br>合并观测值"]
FinalObs["最终观测向量"]
RewardComp["reward.compute_reward()<br>经济绩效"]
InfoDict["信息字典<br>EPI、成本、违规"]

ControlInputs --> GLModelEval
StateUpdate --> ObsModules
StateUpdate --> RewardComp

subgraph subGraph3 ["奖励计算"]
    RewardComp
    InfoDict
    RewardComp --> InfoDict
end

subgraph subGraph2 ["观测生成"]
    ObsModules
    ObsCompute
    ObsConcat
    FinalObs
    ObsModules --> ObsCompute
    ObsCompute --> ObsConcat
    ObsConcat --> FinalObs
end

subgraph subGraph1 ["仿真执行"]
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

subgraph subGraph0 ["输入处理"]
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

EnvYAML["TomatoEnv.yml<br>环境参数"]
AgentYAML["ppo.yml / sac.yml<br>智能体超参数"]
SweepYAML["参数扫描配置<br>参数范围"]
EnvInit["TomatoEnv.init()<br>解析环境配置"]
ModuleInit["_init_observations()<br>初始化观测模块"]
RewardInit["_init_rewards()<br>初始化奖励函数"]
AgentInit["智能体初始化<br>解析智能体配置"]
ExpManager["实验管理器<br>协调训练"]
TrainingLoop["训练循环<br>智能体-环境交互"]
WandBLog["Weights & Biases<br>实验追踪"]

EnvYAML --> EnvInit
AgentYAML --> AgentInit
SweepYAML --> ExpManager
ModuleInit --> TrainingLoop
RewardInit --> TrainingLoop
AgentInit --> TrainingLoop

subgraph subGraph2 ["实验执行"]
    ExpManager
    TrainingLoop
    WandBLog
    ExpManager --> TrainingLoop
    TrainingLoop --> WandBLog
end

subgraph subGraph1 ["运行时初始化"]
    EnvInit
    ModuleInit
    RewardInit
    AgentInit
    EnvInit --> ModuleInit
    EnvInit --> RewardInit
end

subgraph subGraph0 ["配置文件"]
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