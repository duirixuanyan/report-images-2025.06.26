# 模型架构

> **相关源文件**
> * [readme.md](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md)

## 目的与范围

本文档描述了GreenLight模型系统的架构，重点介绍其基于JSON的模型定义、学术基础以及系统组件。GreenLight平台采用模块化方法，模型以JSON格式定义，并通过Python greenlight包进行处理，以创建温室和作物系统的动态模拟。

## 架构概述

GreenLight模型架构建立在JSON模型定义的基础上，这些定义将学术文献编码为可计算的数学模型。该系统通过模块化的JSON方法整合了温室气候动力学、作物生长模型和光照扩展，实现了透明且可重用的模型定义。

### JSON模型架构

基于JSON的模型定义结构

```mermaid
flowchart TD

VanthoorGH["greenhouse_vanthoor_2011_chapter_8.json"]
VanthoorCrop["crop_vanthoor_2011_chapter_9_simplified.json"]
KatzinExt["extension_greenhouse_katzin_2021_vanthoor_2011.json"]
GLPackage["greenlight Python包"]
MainEntry["greenlight.main"]
Variables["变量"]
Constants["常量"]
Inputs["输入"]
Equations["方程"]

VanthoorGH --> Variables
VanthoorGH --> Constants
VanthoorGH --> Inputs
VanthoorGH --> Equations
VanthoorCrop --> Variables
VanthoorCrop --> Constants
VanthoorCrop --> Inputs
VanthoorCrop --> Equations
KatzinExt --> Variables
KatzinExt --> Constants
KatzinExt --> Inputs
KatzinExt --> Equations
Variables --> GLPackage
Constants --> GLPackage
Inputs --> GLPackage
Equations --> GLPackage

subgraph subGraph3 ["JSON模型组件"]
    Variables
    Constants
    Inputs
    Equations
end

subgraph greenlight/ ["greenlight/"]
    GLPackage
    MainEntry
    GLPackage --> MainEntry
end

subgraph models/katzin_2021/definition/ ["models/katzin_2021/definition/"]
    KatzinExt

subgraph vanthoor_2011/ ["vanthoor_2011/"]
    VanthoorGH
    VanthoorCrop
end
end
```

来源: [readme.md L56-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L60)

### 模型处理流程

```mermaid
flowchart TD

AcademicLit["学术文献<br>Katzin (2021), Vanthoor (2011)"]
JSONDefs["JSON模型定义<br>greehouse_vanthoor_2011_chapter_8.json<br>crop_vanthoor_2011_chapter_9_simplified.json<br>extension_greenhouse_katzin_2021_vanthoor_2011.json"]
GLPackage["greenlight包<br>模型处理引擎"]
SimEngine["模拟引擎<br>数值积分"]
Results["模拟结果<br>时间序列输出"]
CLI["python -m greenlight.main"]
DialogBox["配置对话框"]

AcademicLit --> JSONDefs
JSONDefs --> GLPackage
GLPackage --> SimEngine
SimEngine --> Results
CLI --> GLPackage
DialogBox --> GLPackage

subgraph subGraph0 ["用户界面"]
    CLI
    DialogBox
end
```

来源: [readme.md L32-L37](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L32-L37)

 [readme.md L52-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L60)

## 学术基础

GreenLight模型架构建立在成熟的学术文献基础上，这些文献为以JSON格式实现的数学模型提供了理论基础。

### 文献到实现的映射

从学术文献到JSON模型实现

```mermaid
flowchart TD

Vanthoor2011["Vanthoor (2011)<br>基于模型的温室设计方法"]
Katzin2021["Katzin (2021)<br>温室LED照明的节能效果"]
Chapter8["第8章<br>温室模型"]
Chapter9["第9章<br>作物模型"] 
Chapter7["第7章<br>LED扩展"]
GHJson["greenhouse_vanthoor_2011_chapter_8.json"]
CropJson["crop_vanthoor_2011_chapter_9_simplified.json"]
LEDJson["extension_greenhouse_katzin_2021_vanthoor_2011.json"]

Vanthoor2011 --> Chapter8
Vanthoor2011 --> Chapter9
Katzin2021 --> Chapter7
Chapter8 --> GHJson
Chapter9 --> CropJson
Chapter7 --> LEDJson

subgraph subGraph2 ["JSON模型文件"]
    GHJson
    CropJson
    LEDJson
end

subgraph subGraph1 ["理论章节"]
    Chapter8
    Chapter9
    Chapter7
end

subgraph subGraph0 ["学术文献"]
    Vanthoor2011
    Katzin2021
end
```

来源: [readme.md L52-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L60)

### 模型组件结构

JSON模型定义遵循统一的结构，将学术模型编码为可计算形式:

| 组件 | 描述 | JSON元素 |
| --- | --- | --- |
| **variables** | 随时间变化的动态状态变量 | 温度、湿度、CO2、生物量 |
| **constants** | 固定参数和物理属性 | 传热系数、几何结构 |
| **inputs** | 外部驱动变量 | 天气数据、控制信号 |
| **equations** | 变量间的数学关系 | 常微分方程、代数方程 |

来源: [readme.md L56-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L60)

## 核心模型组件

### 温室模型 (Vanthoor 2011 第8章)

温室组件模拟物理温室结构和气候动态，实现于 `greenhouse_vanthoor_2011_chapter_8.json`:

温室模型结构

```mermaid
flowchart TD

SolarRad["太阳辐射<br>光合有效辐射,近红外,远红外"]
HeatFlows["热流<br>对流,辐射"]
EnergyStore["能量储存<br>热质量"]
Ventilation["通风系统<br>屋顶/侧窗通风"]
Screens["遮阳幕布<br>保温/遮光"]
Structure["建筑结构<br>覆盖层,地面"]
TempDyn["温度动态<br>空气分区"]
HumidDyn["湿度动态<br>水汽压"]
CO2Dyn["CO2动态<br>浓度"]

subgraph greenhouse_vanthoor_2011_chapter_8.json ["greenhouse_vanthoor_2011_chapter_8.json"]

subgraph subGraph2 ["能量平衡"]
    SolarRad
    HeatFlows
    EnergyStore
end

subgraph subGraph1 ["物理结构"]
    Ventilation
    Screens
    Structure
end

subgraph subGraph0 ["气候动态"]
    TempDyn
    HumidDyn
    CO2Dyn
end
end
```

来源: [readme.md L56-L57](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L57)

### 作物模型 (Vanthoor 2011 第9章)

作物组件模拟植物生长和生理过程，实现于 `crop_vanthoor_2011_chapter_9_simplified.json`:

作物模型结构

```mermaid
flowchart TD

Carbohydrates["碳水化合物缓冲池<br>同化物池"]
Partitioning["分配机制<br>叶、茎、果实"]
Respiration["维持呼吸<br>温度依赖"]
StomatalCond["气孔导度<br>水汽压差,CO2,光照"]
WaterUptake["水分吸收<br>根系系统"]
EnergyBalance["能量平衡<br>潜热"]
LightResp["光响应<br>光合有效辐射利用"]
CO2Resp["CO2响应<br>羧化作用"]
TempResp["温度响应<br>酶动力学"]

subgraph crop_vanthoor_2011_chapter_9_simplified.json ["crop_vanthoor_2011_chapter_9_simplified.json"]

subgraph subGraph2 ["生长发育"]
    Carbohydrates
    Partitioning
    Respiration
end

subgraph Transpiration ["蒸腾作用"]
    StomatalCond
    WaterUptake
    EnergyBalance
end

subgraph Photosynthesis ["光合作用"]
    LightResp
    CO2Resp
    TempResp
end
end
```

来源: [readme.md L59](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L59-L59)

### LED扩展模块 (Katzin 2021)

LED扩展模块增加了补光功能，实现在`extension_greenhouse_katzin_2021_vanthoor_2011.json`文件中:

LED扩展模块结构

```mermaid
flowchart TD

LightControls["灯光控制<br>开关/调光"]
HeatIntegration["热量整合<br>能量平衡"] 
CropResponse["作物响应<br>光合作用增强"]
PAROutput["光合有效辐射输出<br>光合作用辐射"]
NIROutput["近红外辐射输出<br>近红外辐射"]
HeatOutput["热量输出<br>对流/辐射"]
LEDProps["LED特性<br>效率/光谱"]
HPSProps["HPS特性<br>效率/光谱"]
LampGeometry["灯具几何<br>顶灯/行间灯"]

subgraph extension_greenhouse_katzin_2021_vanthoor_2011.json ["extension_greenhouse_katzin_2021_vanthoor_2011.json"]

subgraph subGraph2 ["控制整合"]
    LightControls
    HeatIntegration
    CropResponse
end

subgraph subGraph1 ["光分布"]
    PAROutput
    NIROutput
    HeatOutput
end

subgraph subGraph0 ["灯具特性"]
    LEDProps
    HPSProps
    LampGeometry
end
end
```

来源: [readme.md L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L60-L60)

## 结构整合与数据流

GreenLight模型将上述组件整合在一个统一结构中，其中某个组件的变化会通过常微分方程(ODEs)网络影响其他组件。

### 数据流图

```mermaid
flowchart TD

WeatherData["气象数据<br>- 总辐射<br>- 温度<br>- 湿度<br>- 二氧化碳<br>- 风速<br>- 天空温度"]
InputSet["setGlInput"]
Parameters["参数集<br>- 物理常数<br>- 几何结构<br>- 材料属性<br>- 控制设置"]
ParamSet["setGlParams"]
Controls["控制输入/规则<br>- 加热<br>- 通风<br>- 遮阳幕<br>- 灯具"]
ControlSet["setGlControls/setGlControlRules"]
ModelInstance["GreenLight模型实例"]
ODEsystem["ODE系统<br>- 气候动态<br>- 作物生长<br>- 能量流动"]
Solver["DyMoMa求解器"]
Results["模拟结果"]
Climate["气候输出<br>- 室内温度<br>- 湿度<br>- 二氧化碳"]
Crop["作物输出<br>- 光合作用<br>- 生长<br>- 产量"]
Energy["能量输出<br>- 加热<br>- 照明<br>- 总能耗"]

WeatherData --> InputSet
Parameters --> ParamSet
Controls --> ControlSet
InputSet --> ModelInstance
ParamSet --> ModelInstance
ControlSet --> ModelInstance
ModelInstance --> ODEsystem
ODEsystem --> Solver
Solver --> Results
Results --> Climate
Results --> Crop
Results --> Energy
```

来源: [Code/createGreenLightModel/createGreenLightModel.m L73-L128](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L73-L128)

## 状态变量

GreenLight模型采用基于状态的方法，通过一组随时间根据常微分方程(ODEs)变化的状态变量来描述温室状况。

### 关键状态变量

| 类别 | 状态变量 | 描述 |
| --- | --- | --- |
| 气候 | `tAir`, `tTop`, `vpAir`, `vpTop`, `co2Air`, `co2Top` | 主温室区和顶部区域的温度、水汽压和CO2浓度 |
| 结构 | `tCov`, `tThScr`, `tBlScr`, `tCanE`, `tCanI` | 覆盖层、幕布和冠层(外部和内部)的温度 |
| 加热 | `tPipe`, `tGroPipe` | 管道轨道和生长管道的温度 |
| 照明 | `tLamp`, `tIntLamp` | 顶部补光灯和层间补光灯的温度 |
| 土壤 | `tFlr`, `tSo1`-`tSo5` | 地面和不同土壤层的温度 |
| 作物 | `cBuf`, `cFruit`, `cLeaf`, `cStem` | 碳水化合物缓冲区和植物各器官的干物质重量 |

来源: [Code/createGreenLightModel/createGreenLightModel.m L80](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L80-L80)

## 控制系统

GreenLight模型支持两种不同的温室环境控制方法:

### 基于规则的控制

当未提供控制轨迹时，模型使用模拟典型温室气候控制策略的基于规则的控制:

* 基于温度设定值的加热控制
* 基于温度和湿度的通风控制 
* 基于外部条件和湿度的幕布控制
* 基于时间、辐射和温度的补光控制

```mermaid
flowchart TD

Sensors["传感器数值<br>- 室内温度<br>- 湿度<br>- 二氧化碳浓度<br>- 室外环境"]
DecisionLogic["决策逻辑<br>- 设定值<br>- P波段<br>- 规则"]
Actuators["执行器控制<br>- 加热<br>- 通风<br>- 遮阳幕<br>- 补光灯<br>- CO2补充"]

subgraph subGraph0 ["基于规则的控制"]
    Sensors
    DecisionLogic
    Actuators
    Sensors --> DecisionLogic
    DecisionLogic --> Actuators
end
```

来源: [Code/createGreenLightModel/createGreenLightModel.m L122-L124](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L122-L124)

 [Code/createGreenLightModel/setGlParams.m L323-L368](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L323-L368)

### 基于轨迹的控制

当提供控制轨迹时，模型会遵循这些预定义的控制操作：

* 幕布位置的时间序列
* 通风开度的时间序列  
* 管道温度的时间序列
* 补光灯运行的时间序列
* CO2补充的时间序列

```mermaid
flowchart TD

TimeValues["控制值时间序列"]
Interpolation["仿真时间插值"]
Actuators["执行器控制<br>- 加热<br>- 通风<br>- 遮阳幕<br>- 补光灯<br>- CO2补充"]

subgraph subGraph0 ["基于轨迹的控制"]
    TimeValues
    Interpolation
    Actuators
    TimeValues --> Interpolation
    Interpolation --> Actuators
end
```

来源: [Code/createGreenLightModel/createGreenLightModel.m L85-L116](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L85-L116)

## 模型创建流程

GreenLight模型的创建遵循由`createGreenLightModel`函数管理的明确定义流程:

1. **创建基础DynamicModel**: 从DyMoMa实例化新模型对象
2. **设置参数**: 定义物理常数和温室属性
3. **设置输入**: 配置气象数据输入
4. **定义时间**: 设置模拟时间范围和步长
5. **定义控制**: 设置控制变量(加热、通风、幕布等)
6. **定义状态**: 创建温度、湿度、CO2等状态变量
7. **设置灯具参数**: 根据灯具类型配置(HPS、LED或无)
8. **设置控制方法**: 基于规则或基于轨迹
9. **设置辅助状态**: 定义派生变量
10. **设置ODE**: 定义状态演化的微分方程
11. **设置初始值**: 初始化所有状态变量

此流程创建了一个完整的模型实例，准备进行模拟。

来源: [Code/createGreenLightModel/createGreenLightModel.m L1-L128](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L1-L128)

## 参数分类

该模型包含200多个参数，按功能分类组织:

### 通用模型参数

影响整个模型的物理常数、传热系数和光学特性。

来源: [Code/createGreenLightModel/setGlParams.m L45-L104](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L45-L104)

### 位置和结构参数

温室几何形状、构造和地理位置参数。

来源: [Code/createGreenLightModel/setGlParams.m L106-L131](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L106-L131)

### 组件特定参数

特定温室组件的参数，如:

* 屋顶、地板和土壤
* 加热系统(管道轨道和生长管道)
* 幕布(保温、遮光和阴影)
* 灯具(顶部照明和行间照明)

来源: [Code/createGreenLightModel/setGlParams.m L132-L223](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L132-L223)

 [Code/createGreenLightModel/setGlParams.m L369-L419](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L369-L419)

### 作物参数

与光合作用、生长和发育相关的参数。

来源: [Code/createGreenLightModel/setGlParams.m L273-L322](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L273-L322)

### 控制参数

气候控制策略的设定值和波段。

来源: [Code/createGreenLightModel/setGlParams.m L323-L368](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L323-L368)

## 高级功能

GreenLight模型包含多个扩展其能力的高级功能:

### 多跨建模

模型可以通过适当的参数缩放来表示多跨温室。

### 多气候区

具有空气交换的独立顶部和主隔间。

### 补充照明选项

支持不同技术的顶部照明和行间照明。

### 热量收集

用于储存多余热量供以后使用的热缓冲模型。

来源: [Code/createGreenLightModel/setGlParams.m L422-L425](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L422-L425)

## 总结

GreenLight模型架构将气候、作物、能源和照明组件集成在一个全面的温室模拟框架中。其模块化结构允许灵活配置不同的温室设计和控制策略，使其成为研究温室能源效率的强大工具，特别是在比较不同照明技术时。