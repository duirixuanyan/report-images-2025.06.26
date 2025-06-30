## 核心组件

`core` 目录包含了构成 GreenLightPlus 项目基础的核心模块：

+   `green_light_model.py`: 定义了 `GreenLightModel` 类，这是创建和管理温室模拟模型的核心组件。
    
+   `greenhouse_env.py`: 实现了 `GreenhouseEnv` 类，这是一个用于温室控制强化学习的自定义 OpenAI Gym 环境。该环境允许训练 AI 模型以实现最优的温室管理。
    
+   `greenhouse_geometry.py`: 包含 `GreenhouseGeometry` 类，负责在 OpenStudio 中处理和构建温室的物理结构。
    
+   `greenlight_energyplus_simulation.py`: 定义了 `GreenhouseSimulation` 类，将 GreenLight 模型与 EnergyPlus 集成以进行全面的能源模拟。
    

这些核心模块共同提供了一个灵活而强大的框架，用于模拟温室环境、能源消耗和作物生长，以及训练 AI 模型来优化温室运营。

[代码结构](https://botanicbyte.com/Code_Structure "代码结构")[1.1 green\_light\_model](https://botanicbyte.com/Code_Structure/core/green_light_model "1.1 green_light_model")