# GreenhouseGeometry

> **相关源文件**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)

GreenhouseGeometry系统提供了结构建模能力，用于生成不同温室结构的几何模型。该组件负责创建具有各种屋顶配置的温室的详细几何表示，这些表示作为GreenLightPlus框架内环境模拟和能源分析的基础。

有关使用这些几何模型的核心模拟引擎的信息，请参阅[GreenLightModel](/greenpeer/GreenLightPlus/2.1-greenlightmodel)。有关利用这些几何结构的EnergyPlus集成的详细信息，请参阅[GreenhouseSimulation](/greenpeer/GreenLightPlus/2.2-greenhousesimulation)。

## 系统概述

GreenhouseGeometry系统以`GreenhouseGeometry`类为核心，该类可生成具有六种不同屋顶类型的参数化温室模型。该系统提供标准化的几何参数，可供GreenLightPlus生态系统中的其他组件用于模拟和分析。

```mermaid
flowchart TD

GG["GreenhouseGeometry类<br>greenhouse_geometry.py"]
RF["屋顶类型生成器"]
PG["参数生成器"]
GM["几何模型"]
RT["屋顶类型<br>三角形, 半圆形,<br>扁平拱形, 哥特式拱形,<br>锯齿形, 锯齿拱形"]
SP["结构参数<br>墙高, 墙宽,<br>墙长, 分段数,<br>坡度"]
EP["环境参数<br>最大室内温度,<br>最小室外温度,<br>最大风速"]
TP["时间参数<br>起始月, 起始日,<br>结束月, 结束日"]
IDM["IDF模型文件<br>EnergyPlus兼容"]
GM_OUT["几何模型<br>结构数据"]

RT --> GG
SP --> GG
EP --> GG
TP --> GG
GM --> IDM
GM --> GM_OUT

subgraph subGraph2 ["输出模型"]
    IDM
    GM_OUT
end

subgraph subGraph1 ["输入参数"]
    RT
    SP
    EP
    TP
end

subgraph subGraph0 ["GreenhouseGeometry系统"]
    GG
    RF
    PG
    GM
    GG --> RF
    GG --> PG
    RF --> GM
    PG --> GM
end
```

**来源**: [README.md L42](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L42-L42)

 [README.md L100-L159](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L100-L159)

## 支持的屋顶类型

GreenhouseGeometry系统支持六种不同的屋顶配置，每种都针对不同的结构、环境和经济需求进行了优化：

| 屋顶类型 | 标识符 | 特性描述 |
| --- | --- | --- |
| 三角形 | `triangle` | 简单的尖顶屋顶，带有线性坡度 |
| 半圆形 | `half_circle` | 带有半圆形轮廓的弧形屋顶 |
| 扁平拱形 | `flat_arch` | 具有扁平轮廓的拱形屋顶 |
| 哥特式拱形 | `gothic_arch` | 带有传统哥特式轮廓的尖拱 |
| 锯齿形 | `sawtooth` | 多个三角形段组成的锯齿状图案 |
| 锯齿拱形 | `sawtooth_arch` | 锯齿状配置的弧形段 |

```mermaid
flowchart TD

RT["屋顶类型参数"]
T["三角形"]
HC["半圆形"]
FA["扁平拱形"]
GA["哥特式拱形"]
ST["锯齿形"]
STA["锯齿拱形"]
GEN["几何模型生成"]
STRUCT["结构参数"]
OUTPUT["生成模型"]

T --> GEN
HC --> GEN
FA --> GEN
GA --> GEN
ST --> GEN
STA --> GEN

subgraph subGraph2 ["几何生成"]
    GEN
    STRUCT
    OUTPUT
    STRUCT --> GEN
    GEN --> OUTPUT
end

subgraph subGraph1 ["屋顶类型选择"]
    RT
    RT --> T
    RT --> HC
    RT --> FA
    RT --> GA
    RT --> ST
    RT --> STA

subgraph subGraph0 ["可用类型"]
    T
    HC
    FA
    GA
    ST
    STA
end
end
```

**来源**: [README.md L113-L120](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L113-L120)

 [README.md L32](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L32-L32)

## 核心参数

GreenhouseGeometry 类接受一组全面的参数，这些参数定义了温室模型的结构、环境和时间特性：

### 结构参数

```mermaid
flowchart TD

SM["start_month<br>模拟起始月份"]
SD["start_day<br>模拟起始日"]
EM["end_month<br>模拟结束月份"]
ED["end_day<br>模拟结束日"]
TS["time_step<br>时间步长(分钟)"]
MIT["min_indoor_temp<br>最低室内温度(°C)"]
MAIT["max_indoor_temp<br>最高室内温度(°C)"]
MOT["min_outdoor_temp<br>最低室外温度(°C)"]
MAOT["max_outdoor_temp<br>最高室外温度(°C)"]
MDT["max_delta_temp<br>最大温差(°C)"]
MWS["max_wind_speed<br>最大风速(m/s)"]
WH["wall_height<br>屋脊高度(m)"]
WW["wall_width<br>屋顶段宽度(m)"]
WL["wall_length<br>温室长度(m)"]
NS["num_segments<br>屋顶段数量"]
SL["slope<br>屋顶坡度(度)"]
NL["number_length<br>长度方向温室数量"]
NW["number_width<br>宽度方向温室数量"]

subgraph subGraph2 ["时间参数"]
    SM
    SD
    EM
    ED
    TS
end

subgraph subGraph1 ["环境约束"]
    MIT
    MAIT
    MOT
    MAOT
    MDT
    MWS
end

subgraph subGraph0 ["结构配置"]
    WH
    WW
    WL
    NS
    SL
    NL
    NW
end
```

**来源**: [README.md L125-L155](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L125-L155)

## 类结构与方法

GreenhouseGeometry 类遵循结构化的初始化和生成模式:

```mermaid
flowchart TD

INIT["init()<br>参数初始化"]
CH["create_houses()<br>主生成方法"]
VP["validate_parameters()<br>参数验证"]
GG["generate_geometry()<br>生成几何结构"]
CM["create_model()<br>创建模型"]
EF["export_files()<br>导出文件"]
IP["输入参数"]
VP_PARAMS["已验证参数"]
GEO_MODEL["几何模型"]
OUTPUT_FILES["输出文件"]

IP --> INIT
VP --> VP_PARAMS
VP_PARAMS --> GG
GG --> GEO_MODEL
GEO_MODEL --> CM
EF --> OUTPUT_FILES

subgraph subGraph2 ["参数流"]
    IP
    VP_PARAMS
    GEO_MODEL
    OUTPUT_FILES
end

subgraph subGraph1 ["GreenhouseGeometry类"]
    INIT
    CH
    INIT --> VP
    CH --> VP
    CH --> GG
    CH --> CM
    CH --> EF

subgraph subGraph0 ["内部方法"]
    VP
    GG
    CM
    EF
    CM --> EF
end
end
```

**来源**: [README.md L134-L158](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L134-L158)

## 与核心系统的集成

GreenhouseGeometry系统通过标准化接口与其他GreenLightPlus组件集成:

```mermaid
flowchart TD

GG["温室几何模块<br>greenhouse_geometry.py"]
GLM["greenlight模型<br>green_light_model.py"]
GS["温室模拟<br>greenlight_energyplus_simulation.py"]
GE["温室环境<br>greenhouse_env.py"]
EP["EnergyPlus<br>建筑模拟"]
IDF["IDF文件<br>几何定义"]
SP["结构参数<br>aFlr, aCov, hAir, hGh"]
GM["几何模型<br>屋顶配置"]
BM["建筑模型<br>能源模拟"]

GG --> SP
GG --> GM
GG --> IDF
SP --> GLM
GM --> GS
GS --> EP
EP --> BM

subgraph subGraph3 ["数据流"]
    SP
    GM
    BM
end

subgraph subGraph2 ["外部系统"]
    EP
    IDF
    IDF --> EP
end

subgraph subGraph1 ["核心系统"]
    GLM
    GS
    GE
    GLM --> GE
end

subgraph subGraph0 ["温室几何集成"]
    GG
end
```

**来源**: [README.md L42](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L42-L42)

 [README.md L188-L233](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L188-L233)

## 使用模式

使用GreenhouseGeometry的典型工作流程包括参数配置、实例化和模型生成:

```

```

**来源**: [README.md L109-L159](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L109-L159)

GreenhouseGeometry系统提供了基础结构数据，使得在整个GreenLightPlus仿真框架中能够进行精确的环境建模和能源分析。通过支持多种屋顶配置和全面的参数集，该系统能够对不同温室设计及其对能源性能和作物产量的影响进行对比分析。