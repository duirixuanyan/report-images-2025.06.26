# 概述

> **相关源文件**
> * [CITATION.cff](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/CITATION.cff)
> * [README.md](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md)
> * [images/GLGymArchitecture2.svg](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/GLGymArchitecture2.svg)
> * [setup.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py)

## 目的与范围

GreenLight-Gym 是一个用于温室作物生产系统控制的强化学习基准环境。它为复杂的温室气候模型提供了与 Gymnasium 兼容的接口，使研究人员能够训练和评估 RL 智能体，以优化温室操作，如加热、通风、CO2 注入和照明控制。

该系统使用 CasADi 在 C++ 中重新实现了高科技温室模型 [GreenLight](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/GreenLight)，并通过 Python 绑定，兼具计算效率和机器学习工作流的易用性。有关安装和设置的详细信息，请参见 [快速开始](/BartvLaatum/GreenLight-Gym2/2-getting-started)。关于具体组件的实现细节，请参见 [系统架构](/BartvLaatum/GreenLight-Gym2/3-system-architecture) 和 [强化学习](/BartvLaatum/GreenLight-Gym2/4-reinforcement-learning)。

**来源：** [README.md L1-L21](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L1-L21)

 [CITATION.cff L4-L6](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/CITATION.cff#L4-L6)

## 系统架构概览

GreenLight-Gym 采用多层架构，将计算密集型的温室仿真与 RL 训练基础设施分离：

```

```

### 配置管理

本系统使用基于 YAML 的配置文件来管理环境和智能体的参数：

* 环境配置：`gl_gym/configs/envs/TomatoEnv.yml`
* 智能体配置：`gl_gym/configs/agents/ppo.yml`、`sac.yml`
* 超参数搜索配置：用于超参数优化范围

**来源：** [README.md L104-L110](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L104-L110)

 [setup.py L17-L28](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L17-L28)

 [gl_gym/environments/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/environments/)

 [gl_gym/configs/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/configs/)

## 数据流与处理

系统通过一条明确的数据处理流程，从外部输入到训练好的模型，完成数据的处理：

```

```

该数据流展示了外部气象数据和配置参数如何流经仿真核心，生成用于强化学习训练的观测值和奖励，并具备全面的追踪与分析能力。

**来源：** [README.md L111-L133](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L111-L133)

 [gl_gym/RL/experiment_manager.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/RL/experiment_manager.py)

 [gl_gym/experiments/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/experiments/)

## 关键接口与入口

### 主要执行接口

运行实验的主要入口是通过实验管理器：

```
python gl_gym/RL/experiment_manager.py --env_id TomatoEnv --algorithm ppo
```

### 核心环境接口

`TomatoEnv` 类实现了 Gymnasium 接口，包含以下关键方法：

* `step()`: 执行一次仿真步
* `reset()`: 初始化环境状态
* `render()`: 可视化支持

### 配置接口

系统通过位于以下路径的 YAML 文件支持分层配置：

* `gl_gym/configs/envs/` - 环境参数
* `gl_gym/configs/agents/` - 算法超参数
* `gl_gym/configs/sweeps/` - 超参数搜索范围

### 分析接口

训练后分析可通过 `visualisations/` 目录下的脚本实现：

* `trajectories.py` - 状态与控制轨迹可视化
* `cost_metrics.py` - 经济性能对比
* `param_uncertainty.py` - 鲁棒性分析

**来源：** [README.md L113-L166](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L113-L166)

 [gl_gym/RL/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/RL/)

 [gl_gym/configs/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/configs/)

 [visualisations/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/visualisations/)