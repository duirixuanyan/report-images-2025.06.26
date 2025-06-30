## GreenhouseEnv 类详细说明

`GreenhouseEnv` 类是一个遵循 OpenAI Gym 接口标准的自定义强化学习环境。该环境模拟温室系统，使AI强化学习代理能够学习如何优化温室温度控制，以实现作物产量和能源效率的最大化。

## 类概述[](#class-overview)

`GreenhouseEnv` 类继承自 `gym.Env`，并实现了标准的强化学习环境接口，包括 `step`、`reset` 和 `render` 方法。它使用 `GreenLightModel` 来模拟温室的物理过程，并定义了观测空间和动作空间。

## 主要属性[](#main-attributes)

+   `first_day`: 模拟的起始日期
+   `new_first_day`: 每个episode随机选择的新起始日期  
+   `isMature`: 作物是否从成熟状态开始
+   `epw_path`: 气象数据文件路径
+   `season_length`: 模拟季节长度(天)
+   `season_interval`: 每次模型运行的时间间隔(天)
+   `current_step`: 当前模拟步数
+   `init_state`: 初始状态参数
+   `target_yield`: 目标产量
+   `target_yield_unit_energy_input`: 单位产量的目标能耗
+   `target_harvest_unit_energy_input`: 单位收获量的目标能耗
+   `model`: GreenLightModel实例
+   `yield_unit_energy_input`: 实际单位产量能耗
+   `total_energy_input`: 总能耗
+   `growth_energy_input`: 生长期能耗
+   `harvest_energy_input`: 收获期能耗
+   `harvest_unit_energy_input`: 单位收获量能耗
+   `total_yield`: 总产量
+   `total_reward`: 累计奖励
+   `cost_penalty`: 成本惩罚
+   `yield_change`: 产量变化
+   `action_space`: 动作空间(温度控制)
+   `observation_space`: 观测空间

## 主要方法[](#main-methods)

### `__init__`[](#__init__)

初始化 `GreenhouseEnv` 实例

```python
def __init__(self, env_config):
    super(GreenhouseEnv, self).__init__()
    
    # Initialize various attributes
    self.first_day = env_config.get("first_day", 1)
    self.new_first_day = random.randint(90, 120)
    self.isMature = env_config.get("isMature", False)
    self.epw_path = env_config.get("epw_path", "")
    self.season_length = env_config.get("season_length", 60)
    self.season_interval = env_config.get("season_interval", 1/24)
    self.current_step = env_config.get("current_step", 0)
    self.init_state = env_config.get("init_state", {})
    self.target_yield = env_config.get("target_yield", 0)
    self.target_yield_unit_energy_input = env_config.get("target_yield_unit_energy_input", 0)
    self.target_harvest_unit_energy_input = env_config.get("target_harvest_unit_energy_input", 0)
 
    # Initialize GreenLightModel
    self.model = GreenLightModel(epw_path=self.epw_path, first_day=self.new_first_day, isMature=self.isMature)
 
    # Initialize performance indicators
    self.yield_unit_energy_input = 0
    self.total_energy_input = 0
    self.growth_energy_input = 0
    self.harvest_energy_input = 0
    self.harvest_unit_energy_input = 0
    self.total_yield = 0
    self.total_reward = 0
    self.cost_penalty = 0
    self.yield_change = 0
 
    # Run initial model
    self.new_gl = self.model.run_model(gl_params=self.init_state, season_length=self.season_length,
                                       season_interval=self.season_interval, step=self.current_step)
 
    # Define action space and observation space
    self.action_space = gym.spaces.Discrete(11)
    self.observation_space = gym.spaces.Box(low=np.array([...]), high=np.array([...]), shape=(14,), dtype=np.float64)
 
    self.episode_unit_energy_inputs = []
    self.episode_total_yields = []
```

该方法用于设置环境的初始参数，创建GreenLightModel实例，并定义动作空间和观察空间。

### `step`[](#step)

执行一个环境步骤，处理给定的动作，并返回下一个状态、奖励和其他信息。

```python
def step(self, action):
    self.gl = self.new_gl
    is_daytime = self.gl["d"]["isDay"]
    temperature_change = action + 18
 
    if is_daytime == 1:
        self.gl["p"]["tSpDay"] = temperature_change
    else:
        self.gl["p"]["tSpNight"] = temperature_change
 
    self.new_gl = self.model.run_model(self.gl, self.season_length, self.season_interval, self.current_step)
    self.current_step += 1
 
    observation = self._get_observation()
    reward = self._get_reward()
    terminated, is_mature = self._is_done()
    truncated = False
    info = {}
 
    return observation, reward, terminated, truncated, info
```

该方法是强化学习环境的核心部分。它接收一个动作(温度控制)，更新环境状态，并返回新的观察值、奖励和终止信号。

### `_get_observation`[](#_get_observation)

获取当前环境状态的观察值。

```python
def _get_observation(self):
    day_of_year = self.new_first_day + self.current_step * self.season_interval
 
    lampIn = 1e-6 * calculate_energy_consumption(self.new_gl, "qLampIn", "qIntLampIn")
    boilIn = 1e-6 * calculate_energy_consumption(self.new_gl, "hBoilPipe", "hBoilGroPipe")
 
    self.total_energy_input += lampIn + boilIn
 
    dmc = 0.06
    self.yield_change = 1e-6 * calculate_energy_consumption(self.new_gl, "mcFruitHar") / dmc
    self.total_yield += self.yield_change
 
    self.new_gl = extract_last_value_from_nested_dict(self.new_gl)
 
    params = [
        ("p", "tSpNight"), ("p", "tSpDay"), ("p", "co2SpDay"),
        ("x", "co2Air"), ("x", "vpAir"), ("x", "tAir"), ("x", "cFruit"),
        ("a", "mcOrgAir"), ("a", "mcAirBuf"), ("d", "iGlob"), ("d", "tOut")
    ]
 
    param_values = [self.new_gl[param[0]][param[1]] for param in params]
    current_obs = np.array([day_of_year, *param_values, lampIn, boilIn])
 
    return current_obs
```

该方法计算并返回当前环境状态的观测向量，包括日期、各种环境参数和能耗数据。

### `_get_reward`[](#_get_reward)

计算当前状态的奖励值。

```python
def _get_reward(self):
    terminated, is_mature = self._is_done()
 
    if not is_mature:
        cFruit_growth = self.new_gl["x"]["cFruit"] - self.gl["x"]["cFruit"]
        reward = cFruit_growth * 1e-3
        self.growth_energy_input = self.total_energy_input
        self.harvest_period_hours = self.season_length * 24 - self.current_step
    else:
        reward = self.yield_change * 1e3
        harvest_passed_hours = self.current_step - (self.season_length * 24 - self.harvest_period_hours)
        harvest_progress = harvest_passed_hours / self.harvest_period_hours
        
        incremental_target_yield = self.target_yield * (0.1 + 0.9 * harvest_progress)
        
        if self.total_yield >= incremental_target_yield:
            reward *= 1.2
        else:
            reward *= 0.8
        
        self.harvest_energy_input = self.total_energy_input - self.growth_energy_input
        self.harvest_unit_energy_input = self.harvest_energy_input / self.total_yield
        
        if self.harvest_unit_energy_input <= self.target_harvest_unit_energy_input:
            reward *= 1.2
        else:
            reward *= 0.8
 
    if terminated:
        self.yield_unit_energy_input = self.total_energy_input / self.total_yield
        energy_diff_pct = (self.target_yield_unit_energy_input - self.yield_unit_energy_input) / self.target_yield_unit_energy_input
        yield_diff_pct = (self.total_yield - self.target_yield) / self.target_yield
        reward += (energy_diff_pct + yield_diff_pct) * self.total_reward
 
        self.episode_unit_energy_inputs.append(self.yield_unit_energy_input)
        self.episode_total_yields.append(self.total_yield)
 
    self.total_reward += reward
    return reward
```

该方法根据当前状态计算奖励值。它会考虑作物生长阶段、产量和能源效率等因素，并在训练结束时提供额外的奖励或惩罚。

### `_is_done`[](#_is_done)

判断当前训练周期是否已结束。

```python
def _is_done(self):
    terminated = self.current_step >= self.season_length * (1 / self.season_interval)
    is_mature = self.new_gl["a"]["mcFruitHar"] > 0.01
    return terminated, is_mature
```

该方法检查是否已达到季节长度或作物是否成熟。

### `reset`[](#reset)

将环境重置为初始状态。

```python
def reset(self, *, seed=None, options=None):
    self.current_step = 0
    self.gl = self.init_state
    self.new_gl = self.model.run_model(gl_params=self.init_state, season_length=self.season_length,
                                       season_interval=self.season_interval, step=self.current_step)
 
    # Reset various energy consumption and yield variables
    self.total_energy_input = 0
    self.growth_energy_input = 0
    self.harvest_energy_input = 0
    self.harvest_unit_energy_input = 0
    self.yield_unit_energy_input = 0
    self.total_yield = 0
    self.total_reward = 0
    self.cost_penalty = 0
 
    info = {}
    observation = self._get_observation()
 
    return observation, info
```

该方法在每个新训练周期开始时调用，重置所有状态变量并返回初始观测值。

### `render`[](#render)

渲染环境的可视化界面。在当前实现中是一个空方法。

## 核心功能分析[](#core-functionality-analysis)

1.  **动态环境模拟**:
    
    +   使用`GreenLightModel`模拟温室环境的物理过程
    +   支持不同的起始日期，增加训练多样性
2.  **灵活的动作空间**:
    
    +   使用离散动作空间控制温度，范围从18°C到28°C
    +   根据昼夜状态调整不同的温度设置
3.  **复杂的观测空间**:
    
    +   包含14个连续变量，涵盖温室环境的各个方面
    +   观测值包括时间信息、环境参数和能源消耗数据
4.  **多目标奖励函数**:
    
    +   考虑作物生长、产量和能源效率
    +   针对不同生长阶段(生长期和收获期)使用不同的奖励计算方法
    +   包含对目标产量和能源效率的动态评估
5.  **环境重置机制**:
    
    +   为每个新训练周期随机选择起始日期
    +   重置所有状态变量，确保每次训练相互独立
6.  **性能追踪**:
    
    +   记录每个训练周期的单位能耗和总产量
    +   提供详细的性能指标，有助于评估和调整强化学习算法

## 注意事项[](#considerations)

+   确保提供正确的天气数据文件路径(EPW格式)
+   初始状态参数(`init_state`)对模拟结果有重大影响，需要仔细设置
+   奖励函数的设计直接影响学习效果，可能需要根据具体需求进行调整
+   观测空间的范围设置应根据实际情况调整，确保覆盖所有可能状态
+   当前环境未实现`render`方法，如需可视化需要额外开发
+   使用该环境进行训练时，建议使用支持连续动作空间的强化学习算法

[1.1 greenlight模型](https://botanicbyte.com/Code_Structure/core/green_light_model "1.1 green_light_model")[1.3 温室几何结构](https://botanicbyte.com/Code_Structure/core/greenhouse_geometry "1.3 greenhouse_geometry")