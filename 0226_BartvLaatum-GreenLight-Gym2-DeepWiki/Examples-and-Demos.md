# 示例与演示

> **相关源文件**
> * [images/GLGymArchitecture2.svg](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/GLGymArchitecture2.svg)
> * [images/cost_metrics_comparison.png](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/cost_metrics_comparison.png)
> * [images/cumulative_reward.png](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/cumulative_reward.png)
> * [images/timeseries_state.png](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/timeseries_state.png)

本页面展示了 GreenLight-Gym 系统输出、训练结果及关键功能的可视化示例。内容包括训练曲线示例、状态轨迹可视化、配置示例，以及将系统组件映射到具体代码实体的架构图。

关于训练过程的详细信息，请参见 [Training Process](/BartvLaatum/GreenLight-Gym2/4.2-training-process)。关于分析工具和方法，请参见 [Analysis and Visualization](/BartvLaatum/GreenLight-Gym2/5-analysis-and-visualization)。

## 系统架构与代码实体

下图将自然语言系统描述映射到 GreenLight-Gym 代码库中的具体代码实体：

**核心系统组件与代码映射**

```

```

来源: [greenlight_gym/envs/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/envs/)

 [greenlight_gym/training/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/training/)

 [greenlight_gym/analysis/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/analysis/)

 [configs/agents/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/configs/agents/)

## 训练结果示例

系统会生成全面的训练指标和可视化结果。以下是强化学习训练实验的典型输出示例。

**累计奖励学习曲线**

训练过程中会生成累计奖励曲线，展示智能体在各回合中的表现。这些曲线反映了收敛趋势，并对比了不同智能体（PPO、SAC、基于规则）与基线的表现。

![累计奖励](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/Cumulative Reward)

该可视化展示了：

* PPO 智能体表现（蓝色）
* SAC 智能体表现（橙色）
* 基于规则的基线（绿色）
* 横轴为训练回合
* 纵轴为每回合累计奖励

**状态轨迹可视化**

时间序列图展示了温室状态变量在控制回合中的变化过程：

![状态轨迹](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/State Trajectories)

该图展示了：

* 温室空气温度（°C）
* CO2 浓度（ppm）
* 相对湿度（%）
* 控制动作（加热、通风、CO2 注入）
* 天气条件（外部温度、太阳辐射）

来源: [images/cumulative_reward.png](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/cumulative_reward.png)

 [images/timeseries_state.png](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/images/timeseries_state.png)

## 数据流与实验流程

下图展示了数据在完整实验流程中的流动及其对应的代码实体：

**实验执行流程**

```

```

来源: [greenlight_gym/training/experiment_manager.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/training/experiment_manager.py)

 [configs/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/configs/)

 [data/weather/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/data/weather/)

 [greenlight_gym/analysis/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/analysis/)

## 配置示例

### 环境配置

以下为 `TomatoEnv.yml` 的关键参数配置示例：

```yaml
environment:
  name: "TomatoEnv"
  simulation_length: 8760  # hours (1 year)
  step_size: 1  # hour
  weather_file: "data/weather/NLD_2021.csv"
  
  observations:
    modules:
      - "climate"
      - "crop" 
      - "control"
      - "weather"
      - "time"
    
  rewards:
    economic_weight: 1.0
    constraint_penalty: 100.0
    
  control_bounds:
    heating: [0, 300]  # W/m²
    ventilation: [0, 1]  # fraction
    co2_injection: [0, 7.2e-4]  # kg/m²/s
```

### 智能体配置

PPO智能体训练的 `ppo.yml` 配置示例：

```yaml
agent:
  type: "PPO"
  policy: "MlpPolicy"
  
  hyperparameters:
    learning_rate: 3e-4
    n_steps: 2048
    batch_size: 64
    n_epochs: 10
    gamma: 0.99
    clip_range: 0.2
    
  training:
    total_timesteps: 1000000
    eval_freq: 10000
    save_freq: 50000
```

来源: [configs/environments/TomatoEnv.yml](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/configs/environments/TomatoEnv.yml)

 [configs/agents/ppo.yml](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/configs/agents/ppo.yml)

## 观测模块示例

系统提供了多种观测模块，可灵活组合使用：

**观测模块架构**

```

```

来源: [greenlight_gym/envs/observations/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/envs/observations/)

## 奖励系统演示

奖励计算将经济效益与约束违规情况结合：

| 奖励组成 | 权重 | 描述 | 代码参考 |
| --- | --- | --- | --- |
| **经济效益** | 1.0 | 作物销售收入减去能源成本 | `GreenhouseReward.calculate_economic_reward()` |
| **温度约束** | -100.0 | 超出温度范围的惩罚 | `GreenhouseReward.temperature_penalty()` |
| **湿度约束** | -50.0 | 湿度违规的惩罚 | `GreenhouseReward.humidity_penalty()` |
| **CO2约束** | -25.0 | CO2超出最优范围的惩罚 | `GreenhouseReward.co2_penalty()` |

**奖励计算示例：**

```
Total Reward = Economic Performance + Constraint Penalties
             = 0.85 + (-2.1) + (-0.3) + (-0.1)
             = -1.65
```

来源: [greenlight_gym/envs/rewards/greenhouse_reward.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/envs/rewards/greenhouse_reward.py)

## 分析输出示例

### 性能指标表

| 智能体类型 | 平均奖励 | 能耗 (kWh/m²) | 约束违规率 | 训练时长 |
| --- | --- | --- | --- | --- |
| PPO | 2.34 ± 0.12 | 125.6 ± 8.3 | 12.3% | 4.2 小时 |
| SAC | 2.18 ± 0.15 | 132.1 ± 9.7 | 15.7% | 3.8 小时 |
| 基于规则 | 1.85 ± 0.08 | 145.2 ± 5.1 | 8.1% | 不适用 |

### 不确定性分析结果

系统支持通过扰动模型参数进行不确定性分析：

```

```

来源: [greenlight_gym/analysis/uncertainty_analysis.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/analysis/uncertainty_analysis.py)

 [greenlight_gym/analysis/parameter_sensitivity.py](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/analysis/parameter_sensitivity.py)

## 命令行用法示例

### 训练 PPO 智能体

```
python -m greenlight_gym.training.train_agent \
  --agent configs/agents/ppo.yml \
  --env configs/environments/TomatoEnv.yml \
  --output results/ppo_experiment
```

### 运行超参数搜索

```
python -m greenlight_gym.training.run_sweep \
  --sweep configs/sweeps/ppo_hyperparameter_sweep.yml \
  --project greenhouse_optimization
```

### 生成分析图表

```
python -m greenlight_gym.analysis.generate_plots \
  --results results/ppo_experiment \
  --output plots/analysis_plots
```

来源: [greenlight_gym/training/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/training/)

 [greenlight_gym/analysis/](https://github.com/BartvLaatum/GreenLight-Gym2/blob/f4a2727d/greenlight_gym/analysis/)