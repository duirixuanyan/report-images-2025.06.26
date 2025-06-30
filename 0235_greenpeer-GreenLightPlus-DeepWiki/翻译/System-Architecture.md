# 系统架构

> **相关源文件**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

## 目的和范围

本文档提供了 GreenLightPlus 系统架构的全面概述，详细说明了四个核心组件如何在温室模拟和优化生态系统中相互作用。它涵盖了代码库的结构组织、组件关系、数据流模式和外部系统集成。

有关安装和设置程序，请参阅[安装和设置](/greenpeer/GreenLightPlus/1.2-installation-and-setup)。有关各个组件的详细文档，请参阅[核心组件](/greenpeer/GreenLightPlus/2-core-components)。有关特定实用程序模块和支持系统的信息，请参阅[支持系统](/greenpeer/GreenLightPlus/3-supporting-systems)。

## 核心系统组件

GreenLightPlus 围绕四个主要组件构建，这些组件协同工作以提供全面的温室模拟和优化功能：

### 组件概述

```

```

**核心组件职责：**

| 组件 | 主要类 | 关键函数 | 用途 |
| --- | --- | --- | --- |
| GreenLightModel | `GreenLightModel` | `run_model()`, `solve_ode()` | 基于ODE的温室模拟 |
| GreenhouseGeometry | `GreenhouseGeometry` | `create_houses()` | 几何结构生成 |
| GreenhouseSimulation | `GreenhouseSimulation` | `run()`, `get_results()` | EnergyPlus集成 |
| GreenhouseEnv | `GreenhouseEnv` | `step()`, `reset()` | Gymnasium RL接口 |

来源：[README.md L40-L43](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L43)

 [README.md L45-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L45-L49)

## 组件交互架构

系统采用分层架构，其中 `GreenLightModel` 作为中央模拟引擎，其他组件基于其功能构建：

### 交互流程

```mermaid
flowchart TD

CLI["GreenLight_Sim.cli:主函数()"]
API["Python接口"]
GLM["温室光照模型"]
ENV["温室环境"]
SIM["温室模拟"]
GEO["温室几何"]
ODE["常微分方程模块"]
PARAMS["设置参数模块"]
STATES["设置状态模块"]
CONTROL["设置控制模块"]
AUX["辅助模块"]
FUNCS["功能函数模块"]
CONVERT["EPW转CSV模块"]
CO2["CO2密度转PPM模块"]
VP["水汽压转密度模块"]

CLI --> GLM
CLI --> ENV
CLI --> SIM
CLI --> GEO
API --> GLM
API --> ENV
GLM --> ODE
GLM --> FUNCS
GLM --> CONVERT

subgraph subGraph3 ["服务层"]
    FUNCS
    CONVERT
    CO2
    VP
    FUNCS --> CO2
    FUNCS --> VP
end

subgraph subGraph2 ["模型构建层"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
    ODE --> PARAMS
    ODE --> STATES
    ODE --> CONTROL
    ODE --> AUX
end

subgraph subGraph1 ["核心模拟层"]
    GLM
    ENV
    SIM
    GEO
    ENV --> GLM
    SIM --> GLM
end

subgraph subGraph0 ["用户界面层"]
    CLI
    API
end
```

**关键交互模式：**

1. **组合**: `GreenhouseEnv` 和 `GreenhouseSimulation` 都包含并控制 `GreenLightModel` 实例
2. **依赖**: `GreenLightModel` 依赖于 `create_green_light_model/` 中的模型构建模块
3. **委托**: 服务函数提供整个系统中使用的专门计算

来源: [pyproject.toml L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L48-L48)

 [README.md L40-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L49)

## 数据流架构

系统通过从输入源到分析输出的明确定义的管道处理数据：

### 数据处理管道

```mermaid
flowchart TD

EPW["EPW气象文件<br>Amsterdam.epw"]
IDF["EnergyPlus IDF文件<br>greenhouse_half_circle.idf"]
PARAMS["模型参数<br>init_state字典"]
CONV["convert_epw2csv()<br>气象数据预处理"]
INIT["create_green_light_model<br>参数初始化"]
VALID["check_csv()<br>数据验证"]
GLM_CORE["GreenLightModel.run_model()<br>ODE积分"]
EP_SIM["EnergyPlusAPI<br>建筑物理"]
RL_TRAIN["PPOConfig<br>策略优化"]
RESULTS["模拟状态字典<br>gl变量"]
CALC["calculate_energy_consumption()<br>指标提取"]
PLOT["plot_green_light()<br>可视化"]
YIELD["extract_last_value_from_nested_dict()<br>产量计算"]

EPW --> CONV
CONV --> GLM_CORE
IDF --> EP_SIM
PARAMS --> INIT
INIT --> GLM_CORE
VALID --> GLM_CORE
GLM_CORE --> RESULTS
EP_SIM --> RESULTS

subgraph subGraph3 ["输出处理"]
    RESULTS
    CALC
    PLOT
    YIELD
    RESULTS --> CALC
    RESULTS --> PLOT
    RESULTS --> YIELD
end

subgraph subGraph2 ["模拟引擎"]
    GLM_CORE
    EP_SIM
    RL_TRAIN
    GLM_CORE --> EP_SIM
    GLM_CORE --> RL_TRAIN
end

subgraph subGraph1 ["数据处理"]
    CONV
    INIT
    VALID
    CONV --> VALID
end

subgraph subGraph0 ["输入数据源"]
    EPW
    IDF
    PARAMS
end
```

**数据转换阶段：**

1. **输入处理**：使用 `convert_epw2csv()` 将天气数据从 EPW 格式转换为 CSV 格式
2. **参数初始化**：通过 `create_green_light_model` 模块定义模型结构
3. **仿真执行**：通过 `GreenLightModel.run_model()` 求解 ODE 系统
4. **结果提取**：使用 `calculate_energy_consumption()` 等实用函数计算指标

来源：[README.md L179-L262](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L179-L262)

 [README.md L296-L331](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L296-L331)

## 外部系统依赖

GreenLightPlus 与多个外部系统集成，以提供全面的仿真功能：

### 集成架构

```mermaid
flowchart TD

CORE["核心组件"]
UTILS["工具模块"]
NP["numpy<br>数值数组"]
PD["pandas<br>数据处理"]
SP["scipy<br>ODE求解"]
GYM["gymnasium<br>强化学习框架"]
EP["EnergyPlus v23.2.0<br>建筑模拟"]
OS["openstudio==3.6.1<br>建筑建模"]
RAY["ray[rllib]<br>分布式强化学习"]
PPO["PPOConfig<br>策略优化"]
AWS["energyplus-weather.s3.amazonaws.com<br>天气数据库"]
GDRIVE["Google Drive<br>gdown下载"]

CORE --> NP
CORE --> PD
CORE --> SP
CORE --> GYM
CORE --> EP
CORE --> OS
CORE --> RAY
UTILS --> AWS
UTILS --> GDRIVE

subgraph subGraph4 ["外部数据源"]
    AWS
    GDRIVE
end

subgraph subGraph3 ["机器学习"]
    RAY
    PPO
    RAY --> PPO
end

subgraph subGraph2 ["模拟与建模"]
    EP
    OS
end

subgraph subGraph1 ["科学计算栈"]
    NP
    PD
    SP
    GYM
end

subgraph subGraph0 ["GreenLightPlus核心"]
    CORE
    UTILS
end
```

**关键外部依赖:**

| 系统 | 版本 | 集成点 | 用途 |
| --- | --- | --- | --- |
| EnergyPlus | v23.2.0 | `EnergyPlusAPI` | 建筑能源模拟 |
| OpenStudio | 3.6.1 | IDF文件处理 | 建筑模型管理 |
| Ray RLlib | Latest | `PPOConfig`, `GreenhouseEnv` | 分布式强化学习训练 |
| SciPy | Latest | ODE模块中的`solve_ivp()` | 微分方程求解 |
| Gymnasium | Latest | `GreenhouseEnv`基类 | 强化学习环境框架 |

来源: [pyproject.toml L25-L33](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L25-L33)

 [README.md L55-L90](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L55-L90)

## 模块依赖结构

代码库被组织成一个清晰的依赖层次结构，支持可维护性和可扩展性：

### 依赖层次结构

```mermaid
flowchart TD

FUNCS["功能函数(funcs.py)"]
CONV["EPW转CSV(convert_epw2csv.py)"]
CO2["CO2密度转PPM(co2_dens2ppm.py)"]
VP["蒸汽压转密度(vp2dens.py)"]
CHECK["CSV检查(check_csv.py)"]
ODE["微分方程(ode.py)"]
PARAMS["参数设置(set_gl_params.py)"]
STATES["状态设置(set_gl_states.py)"]
CONTROL["控制设置(set_gl_control.py)"]
AUX["辅助设置(set_gl_aux.py)"]
GLM["greenlight模型(green_light_model.py)"]
GEO["温室几何(greenhouse_geometry.py)"]
ENV["温室环境(greenhouse_env.py)"]
SIM["EnergyPlus模拟(greenlight_energyplus_simulation.py)"]
PLOT["绘图(plot_green_light.py)"]
ENERGY["能耗分析(energy_analysis.py)"]
CLI["命令行界面(GreenLight_Sim.cli)"]

ODE --> FUNCS
ODE --> CO2
ODE --> VP
GLM --> ODE
GLM --> CONV
GLM --> CHECK
ENV --> GLM
SIM --> GLM
GEO --> FUNCS
PLOT --> GLM
ENERGY --> GLM
CLI --> GLM
CLI --> ENV
CLI --> SIM
CLI --> GEO

subgraph subGraph4 ["第5层: 分析与CLI"]
    PLOT
    ENERGY
    CLI
end

subgraph subGraph3 ["第4层: 集成组件"]
    ENV
    SIM
end

subgraph subGraph2 ["第3层: 核心组件"]
    GLM
    GEO
end

subgraph subGraph1 ["第2层: 模型构建"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
end

subgraph subGraph0 ["第1层: 服务功能"]
    FUNCS
    CONV
    CO2
    VP
    CHECK
end
```

**架构原则：**

1. **分层依赖**：高层依赖低层，防止循环依赖
2. **服务层隔离**：核心数学和转换函数在服务层中隔离
3. **组件组合**：集成组件通过组合而非继承来使用核心组件
4. **单一职责**：每个模块在其层级内都有明确的职责

来源：[README.md L40-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L49)

 [pyproject.toml L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L48-L48)