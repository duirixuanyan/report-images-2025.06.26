教程

4\. 温室几何参数化建模

## 4\. 不同温室结构的参数化建模[](#4-parametric-modeling-of-different-greenhouse-structures)

GreenLightPlus 提供了强大的参数化建模功能，允许用户创建和模拟具有不同结构的各种温室模型。本节将详细介绍如何使用 GreenhouseGeometry 类来实现这一功能。

在开始之前，请确保已安装以下依赖项：

```bash
pip install GreenLightPlus
```

### 4.1 导入必要模块[](#41-import-necessary-modules)

首先，我们需要导入 GreenhouseGeometry 类：

```python
from GreenLightPlus import GreenhouseGeometry
```

### 4.2 定义温室屋顶类型[](#42-define-greenhouse-roof-types)

GreenLightPlus 支持多种温室屋顶类型，包括：

+   "triangle"        # 三角形屋顶
+   "half\_circle"    # 半圆形屋顶  
+   "flat\_arch"      # 平拱形屋顶
+   "gothic\_arch"    # 哥特式拱形屋顶
+   "sawtooth"        # 锯齿形屋顶
+   "sawtooth\_arch"  # 拱形锯齿屋顶

我们可以定义一个列表来包含所有这些类型:

```python
roof_types = [
    "triangle",
    "half_circle",
    "flat_arch",
    "gothic_arch",
    "sawtooth",
    "sawtooth_arch",
]
```

### 4.3 设置温室参数[](#43-set-greenhouse-parameters)

在创建温室模型之前，我们需要设置一系列参数。以下是一些关键参数及其描述：

```python
wall_height = 6.5  # Wall height (meters)
wall_width = 4     # Width of each roof segment (meters)
wall_length = 1.67 # Length of the greenhouse (meters)
num_segments = 6   # Number of roof segments
slope = 22         # Roof slope angle (degrees)
number_length = 1*10  # Number of greenhouses in the length direction
number_width = 1*10   # Number of greenhouses in the width direction
time_step = 60     # Simulation time step (minutes)
```

### 4.4 创建温室模型[](#44-create-greenhouse-model)

使用 GreenhouseGeometry 类创建温室模型。以下是一个完整示例，展示如何为每种屋顶类型创建模型：

```python
for roof_type in roof_types:
    print(f"Creating greenhouse with {roof_type} roof")
    
    greenhouse_model = GreenhouseGeometry(
        roof_type=roof_type,
        slope=slope,
        wall_height=wall_height,
        wall_width=wall_width,
        wall_length=wall_length,
        num_segments=num_segments,
        time_step=time_step,
        number_width=number_width,
        number_length=number_length,
        max_indoor_temp=60,
        min_indoor_temp=0,
        max_outdoor_temp=60,
        min_outdoor_temp=0,
        max_delta_temp=1,
        max_wind_speed=30,
        start_month=4,
        start_day=1,
        end_month=4,
        end_day=7,
    )
    
    greenhouse_model.create_houses()
```

### 4.5 参数说明[](#45-parameter-descriptions)

+   `roof_type`: 屋顶类型
+   `slope`: 屋顶倾斜角度(度)
+   `wall_height`: 墙体高度(米)
+   `wall_width`: 每个屋顶分段的宽度(米)
+   `wall_length`: 温室长度(米)
+   `num_segments`: 屋顶分段数量
+   `time_step`: 模拟时间步长(分钟)
+   `number_width`: 宽度方向上的温室数量
+   `number_length`: 长度方向上的温室数量
+   `max_indoor_temp`: 最高室内温度(°C)
+   `min_indoor_temp`: 最低室内温度(°C)
+   `max_outdoor_temp`: 最高室外温度(°C)
+   `min_outdoor_temp`: 最低室外温度(°C)
+   `max_delta_temp`: 最大室内外温差(°C)
+   `max_wind_speed`: 最大风速(米/秒)
+   `start_month`, `start_day`, `end_month`, `end_day`: 模拟时间范围

### 4.6 注意事项[](#46-notes)

1.  确保所有参数设置在合理范围内，以避免生成不切实际的温室模型。
2.  `wall_length`设置为1.67米可能是一个单元的长度。实际温室长度应为`wall_length * number_length`。
3.  模拟时间范围(4月1日至4月7日)可根据需要调整。
4.  `create_houses()`方法将根据设置的参数生成具体的温室几何模型。调用此方法前请确保所有必要参数已正确设置。

### 4.7 扩展应用[](#47-extended-use)

+   修改参数以创建不同规模和结构的温室。
+   将此代码集成到GreenLight中，研究不同温室结构对作物生长、能源效率等因素的影响。

通过使用这种参数化建模功能，您可以灵活创建和比较不同类型的温室结构，为优化温室设计提供有价值的数据支持。

[3\. 强化学习环境](https://botanicbyte.com/Tutorial/GreenhouseEnv "3. Reinforcement Learning Environment")[5\. 耦合模拟](https://botanicbyte.com/Tutorial/CoupledSimulation "5. Coupled Simulation")