# 入门指南

> **相关源文件**
> * [.gitignore](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/.gitignore)
> * [CITATION.cff](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/CITATION.cff)
> * [README.md](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md)
> * [gl_gym/common/utils.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/common/utils.py)
> * [requirements.txt](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/requirements.txt)
> * [setup.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py)

本文档提供了 GreenLight-Gym 的安装说明、依赖项、构建流程以及基本设置，帮助你在本地系统上运行 GreenLight-Gym。内容涵盖了从前置条件到运行第一个强化学习实验的完整流程。

关于系统架构和组件的信息，请参见 [系统架构](/BartvLaatum/GreenLight-Gym2/3-system-architecture)。关于实验运行和智能体训练的详细信息，请参见 [训练流程](/BartvLaatum/GreenLight-Gym2/4.2-training-process)。

## 前置条件

在安装 GreenLight-Gym 之前，请确保你的系统满足以下要求：

### 必需软件组件

| 组件 | 要求 | 作用 |
| --- | --- | --- |
| **Weights & Biases 账号** | 在 wandb.ai 免费注册账号 | 实验追踪与日志记录 |
| **C++ 编译器** | 支持 C++17（GCC 7+，Clang 6+） | 构建 C++ 核心仿真模块 |
| **CasADi 库** | 版本 3.6.7 | 符号优化框架 |
| **Python** | 版本 3.11 | 运行环境 |

### CasADi 安装流程

本系统依赖 CasADi 3.6.7 作为核心优化引擎。在 Linux 系统上需从源码编译：

```

```

**CasADi 构建依赖项**

来源: [README.md L34-L76](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L34-L76)

## 安装流程

### 系统设置流程

```

```

Sources: [README.md L77-L101](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L77-L101)

### 分步安装指南

1. **克隆仓库**  
   ``` 
   git clone https://github.com/BartvLaatum/GreenLight-Gym2.git
   cd GreenLight-Gym2
   ```
2. **创建 Python 虚拟环境**  
   ```
   conda create -n greenlight_gym python==3.11
   conda activate greenlight_gym
   ```
3. **以可编辑模式安装包**  
   ```
   pip install -e .
   ```

安装过程会使用 [`setup.py`](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py) 文件来：

* 构建 C++ 扩展模块 `gl_gym.environments.models.greenlight_model`
* 链接 `/usr/local` 下的 CasADi 库
* 从 `requirements.txt` 安装 Python 依赖
* 配置符合 C++17 标准的 pybind11 绑定

### 构建系统组件

```

```

来源: [setup.py L17-L28](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/setup.py#L17-L28)

 [requirements.txt L1-L60](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/requirements.txt#L1-L60)

## 依赖概览

### 核心依赖

本系统依赖以下几个关键类别的依赖包：

| 类别 | 主要包 | 作用 |
| --- | --- | --- |
| **强化学习框架** | `stable_baselines3==2.6.0`, `sb3_contrib==2.6.0` | 强化学习算法 |
| **环境接口** | `gymnasium==1.0.0` | RL 环境接口 |
| **优化计算** | `torch==2.7.0`, `scipy==1.15.0` | 神经网络与科学计算 |
| **数据处理** | `numpy==1.26.4`, `pandas==2.2.3` | 数值运算与数据处理 |
| **可视化** | `matplotlib==3.10.0` | 绘图与分析 |
| **实验追踪** | `wandb==0.19.11` | 实验管理 |
| **配置管理** | `PyYAML==6.0.2` | YAML 配置加载 |

来源: [requirements.txt L1-L60](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/requirements.txt#L1-L60)

## 验证与快速开始

### 安装验证

安装完成后，可通过导入核心组件来验证环境配置：

```javascript
import gl_gym
from gl_gym.environments.tomato_env import TomatoEnv
from gl_gym.common.utils import load_env_params
```

### 基础环境测试

使用配置系统测试环境初始化：

```

```

来源: [gl_gym/common/utils.py L18-L36](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/gl_gym/common/utils.py#L18-L36)

### 第一个强化学习实验

运行一个基础的强化学习实验以验证安装是否成功：

```
python gl_gym/RL/experiment_manager.py --env_id TomatoEnv --algorithm ppo
```

该命令将会：

* 从 `gl_gym/configs/agents/ppo.yml` 加载配置文件
* 初始化 `TomatoEnv` 环境
* 启动 PPO 算法训练，并使用 Weights & Biases 进行日志记录
* 生成临时 C++ 编译文件（`.c`、`.o`、`.so`）

### 仓库结构

```

```

来源: [README.md L104-L110](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L104-L110)

## 常见安装问题

### CasADi 路径配置

如果 `setup.py` 无法找到 CasADi 库，请确认安装路径是否与下列位置一致：

* 头文件: `/usr/local/include/casadi`
* 库文件: `/usr/local/lib/libcasadi.so`

如果你的 CasADi 安装在其他目录，请在 [`setup.py L7-L9`](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/`setup.py#L7-L9) 中修改路径变量。

### 临时文件生成

在运行过程中，CasADi 的代码生成会创建临时文件（如 `jit_*.c`、`*.o`、`*.so`），这些文件不会自动清理。训练完成后可安全删除这些文件。

来源: [README.md L121](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/README.md#L121-L121)

[.gitignore L11](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/.gitignore#L11-L11)

系统现已准备好进行强化学习实验。请前往 [训练流程](/BartvLaatum/GreenLight-Gym2/4.2-training-process) 获取详细的实验配置与执行说明。