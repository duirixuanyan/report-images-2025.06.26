# 贡献指南

> **相关源文件**
> * [LICENSE.txt](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

本文档提供了为GreenLightPlus项目做贡献的指南，包括许可要求、开发环境设置和项目结构信息。有关整体项目架构的信息，请参阅[系统架构](/greenpeer/GreenLightPlus/1.1-system-architecture)。有关代码库组织的详细信息，请参阅[项目结构](/greenpeer/GreenLightPlus/5.1-project-structure)。

## 许可和法律要求

GreenLightPlus采用GNU通用公共许可证第3版(GPLv3)分发，这是一种确保软件保持自由和开源的copyleft许可证。所有贡献必须与此许可证兼容。

### 许可证分类

| 组件 | 许可证 | 分类 |
| --- | --- | --- |
| 核心软件 | GPL v3 | Copyleft |
| 贡献内容 | GPL v3 | 必须与GPL兼容 |
| 依赖项 | 多种 | 参见依赖表 |

项目在[pyproject.toml L17](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L17-L17)中配置为GPL v3，完整许可证文本可在[LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)查看。

贡献者必须理解：

* 所有代码贡献将成为GPL v3许可代码库的一部分
* 衍生作品也必须采用GPL v3许可
* Copyleft性质要求分发时必须提供源代码
* 如许可证条款所述，不提供任何担保

**开发工作流 - 许可视角**

```

```

来源: [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)

 [pyproject.toml L17](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L17-L17)

## 开发环境设置

### Python 要求

项目要求 Python 3.8 或更高版本，如 [pyproject.toml L13](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L13-L13) 中所述

开发环境应包含运行时依赖和开发依赖。

**核心依赖**

| 包 | 版本 | 用途 |
| --- | --- | --- |
| `numpy` | 最新 | 数值计算 |
| `pandas` | 最新 | 数据处理 |
| `scipy` | 最新 | 科学计算 |
| `gymnasium` | 最新 | 强化学习环境框架 |
| `openstudio` | 3.6.1 | 建筑能源模拟 |
| `gdown` | 最新 | Google Drive 下载 |
| `ray[rllib]` | 最新 | 分布式强化学习 |

**开发依赖**

| 包 | 用途 |
| --- | --- |
| `pytest` | 单元测试框架 |
| `sphinx` | 文档生成 |
| `sphinx-rtd-theme` | 文档主题 |

### 安装流程

```markdown
# Clone the repository
git clone https://github.com/greenpeer/GreenLightPlus.git
cd GreenLightPlus

# Install in development mode with dev dependencies
pip install -e .[dev]
```

本项目使用 `setuptools` 作为构建后端，配置见 [pyproject.toml L2-L3](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L2-L3)

来源: [pyproject.toml L13](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L13-L13)

 [pyproject.toml L25-L33](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L25-L33)

 [pyproject.toml L35-L40](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L35-L40)

## 构建与打包系统

GreenLightPlus 采用现代 Python 打包配置，使用 `pyproject.toml` 并遵循 PEP 621 标准。

**构建系统配置**

```

```

### 项目元数据

项目在 [pyproject.toml L5-L24](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L5-L24) 中配置了以下元数据：

* **名称**: GreenLightPlus  
* **版本**: 2.5  
* **作者**: Daidai Qiu ([qiu.daidai@outlook.com](mailto:qiu.daidai@outlook.com))  
* **描述**: 温室模拟与优化工具包  
* **Python支持**: 3.8, 3.9, 3.10  
* **开发状态**: Alpha  
* **目标受众**: 科研领域  

### 命令行接口

该包提供了在 [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48) 中配置的CLI入口点：

```
GreenLightPlus = "GreenLight_Sim.cli:main"
```

这将 `GreenLightPlus` 命令映射到 `GreenLight_Sim.cli` 模块中的 `main` 函数。

### 包发现机制

构建系统使用自动包发现功能，配置见 [pyproject.toml L50-L54](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L50-L54)

:

```
[tool.setuptools]
include-package-data = true

[tool.setuptools.packages.find]
where = ["."]
```

来源: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

## 贡献者开发流程

### 代码组织原则

GreenLightPlus 采用模块化架构，贡献者在进行修改前应理解不同组件之间的关系。

**开发组件映射**

```

```

### 贡献领域

贡献者可以关注系统的不同领域：

| 领域 | 组件 | 所需专业知识 |
| --- | --- | --- |
| **核心模拟** | `green_light_model.py`, `ode.py` | 微分方程求解，植物建模 |
| **能源分析** | `greenlight_energyplus_simulation.py` | 建筑物理，EnergyPlus |
| **强化学习** | `greenhouse_env.py` | 强化学习算法，Gymnasium |
| **几何建模** | `greenhouse_geometry.py` | 3D建模，结构分析 |
| **数据处理** | `funcs.py`, `convert_epw2csv.py` | 数据转换，气象数据 |
| **可视化** | `plot_green_light.py` | 科学绘图，matplotlib |

### 开发依赖集成

开发工具通过可选依赖系统与主代码库集成：

* **pytest**: 用于运行所有模块的单元测试
* **sphinx**: 从文档字符串生成文档
* **sphinx-rtd-theme**: 保持文档样式一致

来源: [pyproject.toml L35-L40](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L35-L40)

## 测试与质量保证

### 测试框架

项目使用 `pytest` 作为主要测试框架，通过 [pyproject.toml L37](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L37-L37) 中的 `dev` 可选依赖组安装

### 测试策略

贡献者应确保其更改不会破坏现有功能：

1. 提交更改前运行现有测试
2. 为新功能添加测试
3. 确保关键模拟组件的测试覆盖率
4. 验证科学计算的数值准确性

### 质量标准

考虑到软件的科研性质，贡献应保持：

* **数值准确性**: 特别是微分方程求解和能量计算
* **物理有效性**: 确保温室物理保持真实
* **性能**: 保持大规模模拟的计算效率
* **可复现性**: 确保不同运行间结果一致

## 文档指南

### 文档生成

项目使用 Sphinx 生成文档，配置见 [pyproject.toml L38-L39](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L38-L39)

贡献者应：

1. 为所有公共函数和类编写清晰的文档字符串
2. 使用 Read the Docs 主题保持一致性
3. 记录任何新的依赖或配置变更
4. 修改系统架构时更新相关wiki页面

### 代码文档标准

* 科学函数使用 NumPy 风格文档字符串
* 包含参数的单位和物理意义
* 为复杂函数提供示例
* 记录任何外部系统集成(EnergyPlus, Ray等)

来源: [pyproject.toml L38-L39](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L38-L39)

## 项目URL与社区

项目为贡献者维护了以下重要URL：

| 资源 | URL | 用途 |
| --- | --- | --- |
| 主页 | [https://github.com/greenpeer/GreenLightPlus](https://github.com/greenpeer/GreenLightPlus) | 主仓库 |
| 错误报告 | [https://github.com/greenpeer/GreenLightPlus/issues](https://github.com/greenpeer/GreenLightPlus/issues) | 问题跟踪 |
| 源代码 | [https://github.com/greenpeer/GreenLightPlus](https://github.com/greenpeer/GreenLightPlus) | 代码访问 |

贡献者应使用GitHub Issues系统提交错误报告和功能请求，配置见 [pyproject.toml L42-L45](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L42-L45)

来源: [pyproject.toml L42-L45](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L42-L45)