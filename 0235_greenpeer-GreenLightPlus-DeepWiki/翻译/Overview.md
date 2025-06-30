# 概述

> **相关源文件**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)
> * [README_zh.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README_zh.md)

本文档提供了 GreenLightPlus 的全面概述，这是一个用于温室环境模拟和能源优化的 Python 工具包。它涵盖了系统的架构、核心组件和集成能力。

GreenLightPlus 专为从事温室自动化、能源优化和农业 AI 系统的研究人员、工程师和开发人员而设计。有关详细使用示例，请参阅[使用示例](/greenpeer/GreenLightPlus/4-usage-examples)。有关开发信息，请参阅[开发](/greenpeer/GreenLightPlus/5-development)。

## 系统概述

GreenLightPlus 是一个基于 Python 的温室模拟和优化平台，它扩展了 David Katzin 的原始 MATLAB GreenLight 模型。该系统提供四个主要功能：

| 功能 | 用途 | 主要组件 |
| --- | --- | --- |
| 环境模拟 | 模拟温室气候动态和作物生长 | `GreenLightModel` |
| 能源分析 | 详细的建筑能源消耗分析 | `GreenhouseSimulation` |
| AI 优化 | 强化学习控制策略 | `GreenhouseEnv` |
| 结构建模 | 生成温室几何配置 | `GreenhouseGeometry` |

该工具包与外部系统集成，包括用于建筑模拟的 EnergyPlus v23.2.0、用于分布式强化学习的 Ray RLlib，以及标准天气数据格式（EPW 文件）。

**核心架构**

```mermaid
flowchart TD

GLM["GreenLightModel<br>green_light_model.py<br>常微分方程仿真引擎"]
GS["GreenhouseSimulation<br>greenlight_energyplus_simulation.py<br>EnergyPlus集成"]
GE["GreenhouseEnv<br>greenhouse_env.py<br>强化学习环境"]
GG["GreenhouseGeometry<br>greenhouse_geometry.py<br>结构生成"]
CGLM["create_green_light_model/<br>模型初始化"]
SF["service_functions/<br>数据处理工具"]
RA["result_analysis/<br>可视化和指标"]
EP["EnergyPlus v23.2.0<br>建筑能源仿真"]
RAY["Ray RLlib<br>分布式强化学习框架"]
WD["Weather data<br>EPW文件，CSV处理"]

CGLM --> GLM
SF --> GLM
GLM --> RA
GS --> EP
GE --> RAY
SF --> WD
GG --> EP

subgraph External_Dependencies ["外部依赖"]
    EP
    RAY
    WD
end

subgraph Supporting_Systems ["支持系统"]
    CGLM
    SF
    RA
end

subgraph Core_Components ["核心组件"]
    GLM
    GS
    GE
    GG
    GLM --> GS
    GLM --> GE
end
```

来源: [README.md L14-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L14-L50)

 [README.md L38-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L38-L50)

## 核心组件关系

GreenLightPlus 的四个核心组件在层次关系中运行，其中 `GreenLightModel` 作为中央仿真引擎，其他组件依赖或扩展它。

**组件依赖关系和数据流**

```mermaid
flowchart TD

ODE["ode.py<br>常微分方程系统定义"]
PARAMS["set_gl_params.py<br>参数配置"]
STATES["set_gl_states.py<br>状态初始化"]
CONTROL["set_gl_control.py<br>控制逻辑"]
AUX["set_gl_aux.py<br>辅助计算"]
GLM["GreenLightModel<br>green_light_model.py<br>主要仿真类"]
GS["GreenhouseSimulation<br>greenlight_energyplus_simulation.py<br>联合仿真包装器"]
GE["GreenhouseEnv<br>greenhouse_env.py<br>gymnasium环境"]
GG["GreenhouseGeometry<br>greenhouse_geometry.py<br>IDF文件生成器"]
CONV["convert_epw2csv.py<br>天气数据处理"]
FUNCS["funcs.py<br>计算工具"]
PLOT["plot_green_light.py<br>结果可视化"]

ODE --> GLM
PARAMS --> GLM
STATES --> GLM
CONTROL --> GLM
AUX --> GLM
GLM --> GS
GLM --> GE
CONV --> GLM
FUNCS --> GLM
GLM --> PLOT

subgraph Utilities ["服务层"]
    CONV
    FUNCS
    PLOT
end

subgraph Extensions ["组件扩展"]
    GS
    GE
    GG
    GG --> GS
end

subgraph Core_Engine ["核心仿真引擎"]
    GLM
end

subgraph Model_Creation ["模型创建层"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
end
```

**关键集成点：**

* **模型初始化**：`create_green_light_model/` 目录包含构建 ODE 系统、设置参数和为 `GreenLightModel` 初始化状态的模块
* **仿真扩展**：`GreenhouseSimulation` 和 `GreenhouseEnv` 都包装了 `GreenLightModel` 以提供专门的接口
* **数据处理**：天气数据通过 `convert_epw2csv.py` 流向仿真引擎
* **结果分析**：`GreenLightModel` 的输出由可视化和分析函数处理

来源：[README.md L40-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L50)

 [README.md L47-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L47-L49)

## 外部系统集成

GreenLightPlus 与多个外部系统集成，提供全面的温室仿真和优化功能。

**集成架构**

```mermaid
flowchart TD

CLI["命令行界面<br>入口点和脚本"]
GLM["GreenLightModel<br>核心仿真引擎"]
GS["GreenhouseSimulation<br>EnergyPlus包装器"]
GE["GreenhouseEnv<br>强化学习环境包装器"]
NP["NumPy<br>数值数组"]
PD["Pandas<br>数据操作"]
SP["SciPy<br>常微分方程求解"]
MPL["Matplotlib<br>绘图后端"]
EP["EnergyPlus v23.2.0<br>建筑物理引擎"]
PYEP["pyenergyplus.api<br>Python API包装器"]
IDF["IDF模型文件<br>建筑定义"]
GYM["Gymnasium<br>强化学习环境标准"]
RAY["Ray RLlib<br>分布式强化学习框架"]
PPO["PPO算法<br>策略优化"]
EPW["EPW天气文件<br>energyplus-weather.s3.amazonaws.com"]
CSV["处理后的天气数据<br>convert_epw2csv输出"]

GLM --> NP
GLM --> PD
GLM --> SP
GLM --> MPL
GS --> PYEP
GS --> IDF
GE --> GYM
GE --> RAY
CSV --> GLM

subgraph Data_Sources ["外部数据"]
    EPW
    CSV
    EPW --> CSV
end

subgraph Machine_Learning ["机器学习和优化"]
    GYM
    RAY
    PPO
    RAY --> PPO
end

subgraph Building_Simulation ["建筑能耗仿真"]
    EP
    PYEP
    IDF
    PYEP --> EP
    IDF --> EP
end

subgraph Scientific_Stack ["科学计算"]
    NP
    PD
    SP
    MPL
end

subgraph GreenLightPlus_Core ["GreenLightPlus核心系统"]
    CLI
    GLM
    GS
    GE
    CLI --> GLM
    CLI --> GS
    CLI --> GE
end
```

**集成详情：**

| 外部系统 | 集成方法 | 主要接口 | 用途 |
| --- | --- | --- | --- |
| EnergyPlus | Python API (`pyenergyplus.api`) | `GreenhouseSimulation` class | 建筑能耗分析 |
| Ray RLlib | 直接导入和配置 | `GreenhouseEnv` as Gymnasium environment | 分布式强化学习训练 |
| Weather Data | AWS S3下载和CSV转换 | `convert_epw2csv.py` | 气候数据处理 |
| Scientific Stack | 标准Python导入 | 整个代码库 | 数值计算 |

**配置要求：**

* EnergyPlus安装路径必须添加到Python `sys.path` [README.md L298-L299](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L298-L299)
* 从AWS S3存储桶下载天气文件 [README.md L85-L86](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L85-L86)
* 通过`PPOConfig`类配置Ray RLlib [README.md L359-L433](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L359-L433)

来源：[README.md L55-L96](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L55-L96)

 [README.md L288-L340](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L288-L340)

 [README.md L341-L452](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L341-L452)

## 数据处理管道

GreenLightPlus实现了一个全面的数据处理管道，用于转换天气数据、管理仿真状态并生成分析输出。

**管道架构**

```mermaid
flowchart TD

EPW_RAW["EPW 天气文件<br>NLD_Amsterdam.062400_IWEC.epw"]
IDF_FILES["EnergyPlus IDF 文件<br>greenhouse_half_circle.idf"]
INIT_PARAMS["模型参数<br>温室结构和控制"]
CONV["convert_epw2csv()<br>天气数据转换"]
VALID["数据验证<br>funcs.py 工具"]
MODEL_INIT["模型初始化<br>create_green_light_model/"]
GL_SIM["GreenLightModel.run_model()<br>ODE 积分"]
EP_SIM["GreenhouseSimulation.run()<br>协同仿真"]
RL_TRAIN["GreenhouseEnv.step()<br>强化学习训练循环"]
METRICS["calculate_energy_consumption()<br>能耗和产量指标"]
VIZ["plot_green_light()<br>结果可视化"]
CHECKPOINTS["模型检查点<br>强化学习策略存储"]

EPW_RAW --> CONV
IDF_FILES --> EP_SIM
INIT_PARAMS --> MODEL_INIT
VALID --> GL_SIM
MODEL_INIT --> GL_SIM
GL_SIM --> METRICS
EP_SIM --> METRICS
RL_TRAIN --> CHECKPOINTS

subgraph Output_Analysis ["分析和输出"]
    METRICS
    VIZ
    CHECKPOINTS
    METRICS --> VIZ
end

subgraph Simulation_Engines ["仿真层"]
    GL_SIM
    EP_SIM
    RL_TRAIN
    GL_SIM --> EP_SIM
    GL_SIM --> RL_TRAIN
end

subgraph Processing_Layer ["数据处理"]
    CONV
    VALID
    MODEL_INIT
    CONV --> VALID
end

subgraph Input_Data ["输入数据源"]
    EPW_RAW
    IDF_FILES
    INIT_PARAMS
end
```

**处理函数：**

| 阶段 | 函数/类 | 输入格式 | 输出格式 | 用途 |
| --- | --- | --- | --- | --- |
| 天气处理 | `convert_epw2csv()` | EPW 文件 | CSV 时间序列 | 气候数据标准化 |
| 模型创建 | `create_green_light_model/` 模块 | 参数字典 | 模型状态字典 | 仿真初始化 |
| 仿真 | `GreenLightModel.run_model()` | 状态字典 + 参数 | 更新的状态字典 | 核心温室动力学 |
| 分析 | `calculate_energy_consumption()` | 仿真结果 | 标量指标 | 性能评估 |
| 可视化 | `plot_green_light()` | 仿真结果 | Matplotlib 图形 | 结果展示 |

**状态管理：**

系统通过嵌套字典维护仿真状态，包含：

* 物理参数（`'p'` 键）用于温室结构和控制设置
* 温度、湿度、CO2 和作物生长的状态变量
* 能耗和环境条件的时间序列输出

来源：[README.md L175-L286](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L175-L286)

 [README.md L187-L262](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L187-L262)

 [README.md L312-L338](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L312-L338)