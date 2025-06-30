# 项目结构

> **相关源文件**
> * [create_green_light_model/ode.py](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

本文档详细解释了GreenLightPlus代码库的组织结构、模块依赖关系和架构模式。它作为技术参考，帮助开发人员理解代码的组织方式以及不同组件之间的交互。

有关高级系统架构和组件关系的信息，请参阅[系统架构](/greenpeer/GreenLightPlus/1.1-system-architecture)。有关模型内部结构和参数依赖的详细信息，请参阅[模型内部结构](/greenpeer/GreenLightPlus/5.2-model-internals)。

## 目录组织

GreenLightPlus代码库采用模块化架构，分为几个关键目录，每个目录在温室模拟生态系统中都有特定用途。

### 顶层目录结构

```

```

**来源**: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

 [create_green_light_model/ode.py L1-L133](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L1-L133)

### 核心组件文件

主要模拟组件作为独立的Python模块实现在根目录`GreenLightPlus/`下:

| 组件 | 文件 | 主要类/函数 |
| --- | --- | --- |
| 核心模拟引擎 | `green_light_model.py` | `GreenLightModel` |
| RL环境 | `greenhouse_env.py` | `GreenhouseEnv` |
| EnergyPlus集成 | `greenlight_energyplus_simulation.py` | `GreenhouseSimulation` |
| 几何生成 | `greenhouse_geometry.py` | `GreenhouseGeometry` |

**来源**: 根据高层系统架构图推断

## 模块依赖架构

代码库采用分层依赖结构，高层组件依赖于底层工具和模型构建模块。

### 核心依赖图

```

```

**来源**: [create_green_light_model/ode.py L20-L26](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L20-L26)

 [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48)

### 关键导入模式

`ODESolver` 类展示了整个代码库中使用的典型导入模式:

```javascript
from ..service_functions.funcs import *
from .set_gl_aux import set_gl_aux
from .set_gl_control import set_gl_control
from .set_gl_odes import set_gl_odes
```

该模式展示了:

* 使用相对路径的跨目录导入 (`..service_functions`)
* 使用相对路径的同目录导入 (`.set_gl_aux`)  
* 工具函数的通配符导入
* 模型构建的特定函数导入

**来源**: [create_green_light_model/ode.py L20-L23](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L20-L23)

## 数据流架构

代码库实现了清晰的数据流模式，外部输入在到达核心模拟引擎前会经过多个转换阶段。

### 数据处理流水线

```

```

**来源**: [create_green_light_model/ode.py L61-L87](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L61-L87)

 [create_green_light_model/ode.py L89-L133](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L89-L133)

### 关键数据结构

`ODESolver` 类管理着三个主要数据结构，用于表示模拟状态:

| 结构 | 类型 | 用途 | 关键方法 |
| --- | --- | --- | --- |
| `self.gl` | `dict` | GreenLight 模型实例 | 在 `ode(t, x)` 中更新 |
| `self.d` | `numpy.ndarray` | 不可控变量矩阵 | 通过 `sample_d(t)` 采样 |
| `self.u` | `numpy.ndarray` | 控制变量矩阵 | 通过 `sample_u(t)` 采样 |

**来源**: [create_green_light_model/ode.py L29-L38](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L29-L38)

 [create_green_light_model/ode.py L61-L87](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L61-L87)

## 包配置

该项目使用 `pyproject.toml` 中定义的现代 Python 打包标准。

### 项目元数据

```
[project]
name = "GreenLightPlus"
version = "2.5"
requires-python = ">=3.8"
```

### 依赖项

| 类别 | 包 | 版本 | 用途 |
| --- | --- | --- | --- |
| 核心科学计算 | `numpy`, `pandas`, `scipy` | 最新 | 数值计算 |
| 模拟仿真 | `gymnasium` | 最新 | 强化学习环境框架 |
| 建筑建模 | `openstudio` | `3.6.1` | EnergyPlus集成 |
| 机器学习 | `ray[rllib]` | 最新 | 分布式强化学习训练 |
| 数据管理 | `gdown` | 最新 | 模型下载 |

### 入口点

该包通过以下方式提供命令行接口:

```
[project.scripts]
GreenLightPlus = "GreenLight_Sim.cli:main"
```

这将创建一个系统级命令 `GreenLightPlus`，用于执行 `GreenLight_Sim.cli` 中的 `main()` 函数。

**来源**: [pyproject.toml L5-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L5-L48)

## 架构模式

### 组合优于继承

代码库倾向于使用组合模式，这在 `ODESolver` 类中尤为明显。该类聚合了多个数据结构，并将功能委托给专门的函数，而不是通过继承行为来实现。

### 功能分解

模型构建被分解为专门的函数：

* `set_gl_params()` - 参数初始化
* `set_gl_states()` - 状态初始化  
* `set_gl_control()` - 控制逻辑
* `set_gl_aux()` - 辅助计算
* `set_gl_odes()` - ODE系统定义

### 数据驱动配置

模拟引擎基于字典数据结构(`gl` dict)运行，这些结构可以在运行时动态配置和修改。

**来源**: [create_green_light_model/ode.py L119-L128](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L119-L128)