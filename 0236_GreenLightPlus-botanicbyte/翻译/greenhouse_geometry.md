## GreenhouseGeometry 类详细说明

`GreenhouseGeometry` 类是 GreenLightPlus 项目的核心组件，负责创建和管理温室几何结构。它使用 OpenStudio 库来构建温室的物理模型，包括墙壁、屋顶、窗户和通风系统。

## 类概述[](#class-overview)

该类定义了温室的物理结构，包括尺寸、材料属性、屋顶类型和通风系统。它还负责创建 OpenStudio 模型、设置模拟参数以及生成相应的 EnergyPlus 输入文件。

## 主要属性[](#main-attributes)

+   `roof_type`: 屋顶类型（如三角形、半圆形）
+   `wall_height`, `wall_width`, `wall_length`: 墙体尺寸
+   `number_width`, `number_length`: 宽度和长度方向上的单元数量
+   `slope`: 屋顶坡度
+   `num_segments`: 屋顶分段数量
+   `frame_width`: 框架宽度
+   `floor_area`: 地面面积
+   `roof_ventilation_area_left`, `roof_ventilation_area_right`: 屋顶通风面积
+   `model`: OpenStudio 模型实例

## 主要方法[](#main-methods)

### `__init__`[](#__init__)

初始化 `GreenhouseGeometry` 实例，设置基本参数并创建 OpenStudio 模型。

### `calculate_roof_height_relative_to_wall`[](#calculate_roof_height_relative_to_wall)

计算屋顶相对于墙体的高度。

### `calculate_trapezoidal_prism_volume`[](#calculate_trapezoidal_prism_volume)

计算梯形棱柱的体积。

### `calculate_window_area`[](#calculate_window_area)

计算屋顶窗户的面积。

### `create_default_construction_set`[](#create_default_construction_set)

创建默认的构造集。

### `create_space_and_type`[](#create_space_and_type)

创建空间和空间类型。

### `create_thermal_zone`[](#create_thermal_zone)

创建热区。

### `create_construction`[](#create_construction)

创建构造。

### `create_material`[](#create_material)

创建材料。

### `z_value_half_circle`, `z_value_triangle`, `z_value_flat_arch`, `z_value_gothic_arch`, `z_value_sawtooth`, `z_value_sawtooth_arch`[](#z_value_half_circle-z_value_triangle-z_value_flat_arch-z_value_gothic_arch-z_value_sawtooth-z_value_sawtooth_arch)

计算不同屋顶类型的z值。

### `calculate_total_window_area`[](#calculate_total_window_area)

计算总窗户面积。

### `create_schedule_type_limits`[](#create_schedule_type_limits)

创建计划类型限制。

### `create_default_day_schedule`[](#create_default_day_schedule)

创建默认日计划。

### `write_window_schedule_to_csv`[](#write_window_schedule_to_csv)

将窗户计划写入CSV文件。

### `create_window_schedule`[](#create_window_schedule)

创建窗户开启计划。

### `create_house_model`[](#create_house_model)

创建单个温室单元模型。

### `create_houses`[](#create_houses)

创建完整的温室模型。

### `calculate_surface_area_slope`[](#calculate_surface_area_slope)

计算表面积和坡度。

## 核心功能分析[](#core-functionality-analysis)

1.  **灵活的几何结构定义**:
    
    +   支持多种屋顶类型（三角形、半圆形、平拱形等）。
    +   可自定义墙体和屋顶尺寸。
2.  **详细的材料和构造定义**:
    
    +   定义地面、墙体、窗户和遮阳系统的材料属性。
    +   创建相应的OpenStudio材料和构造对象。
3.  **复杂屋顶结构模拟**:
    
    +   对屋顶进行分段以实现曲面更精确的模拟。
    +   计算每个屋顶分段的体积和几何特征。
4.  **自然通风模拟**:
    
    +   创建可操作的屋顶窗户。
    +   定义通风计划和控制参数。
5.  **模型生成与输出**:
    
    +   生成完整的OpenStudio模型。
    +   导出为EnergyPlus兼容的IDF文件。
6.  **多单元温室支持**:
    
    +   支持由多个相同单元组成的大型温室创建。
7.  **详细的几何计算**:
    
    +   计算关键参数如屋顶坡度和表面积。

## 注意事项[](#considerations)

+   确保正确设置初始参数，如墙体尺寸和屋顶类型，这些会直接影响模拟结果
+   屋顶类型选择会影响自然通风和能量传递，请根据实际情况谨慎选择
+   窗户计划创建涉及随机性，可能需要多次运行才能获得理想计划
+   对于大型或复杂的温室结构，模型生成可能需要较长时间
+   确保OpenStudio和EnergyPlus版本之间的兼容性

[1.2 greenhouse\_env](https://botanicbyte.com/Code_Structure/core/greenhouse_env "1.2 greenhouse_env")[1.4 温室模拟](https://botanicbyte.com/Code_Structure/core/greenlight_energyplus_simulation "1.4 温室模拟")