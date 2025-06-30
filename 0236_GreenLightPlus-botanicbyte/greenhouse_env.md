## Detailed Explanation of GreenhouseEnv Class

The `GreenhouseEnv` class is a custom reinforcement learning environment that follows the OpenAI Gym interface standard. This environment simulates a greenhouse system, allowing AI reinforcement learning agents to learn how to optimize greenhouse temperature control to maximize crop yield and energy efficiency.

## Class Overview[](#class-overview)

The `GreenhouseEnv` class inherits from `gym.Env` and implements the standard reinforcement learning environment interface, including `step`, `reset`, and `render` methods. It uses `GreenLightModel` to simulate the physical processes of the greenhouse and defines observation and action spaces.

## Main Attributes[](#main-attributes)

+   `first_day`: Starting date of the simulation
+   `new_first_day`: Randomly selected new starting date for each episode
+   `isMature`: Whether the crop starts from a mature state
+   `epw_path`: Path to weather data file
+   `season_length`: Length of simulated season (in days)
+   `season_interval`: Time interval for each model run (in days)
+   `current_step`: Current simulation step
+   `init_state`: Initial state parameters
+   `target_yield`: Target yield
+   `target_yield_unit_energy_input`: Target energy consumption per unit yield
+   `target_harvest_unit_energy_input`: Target energy consumption per unit harvest
+   `model`: GreenLightModel instance
+   `yield_unit_energy_input`: Actual energy consumption per unit yield
+   `total_energy_input`: Total energy consumption
+   `growth_energy_input`: Energy consumption during growth period
+   `harvest_energy_input`: Energy consumption during harvest period
+   `harvest_unit_energy_input`: Energy consumption per unit harvest
+   `total_yield`: Total yield
+   `total_reward`: Cumulative reward
+   `cost_penalty`: Cost penalty
+   `yield_change`: Yield change
+   `action_space`: Action space (temperature control)
+   `observation_space`: Observation space

## Main Methods[](#main-methods)

### `__init__`[](#__init__)

Initializes a `GreenhouseEnv` instance.

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

This method sets up the initial parameters for the environment, creates a GreenLightModel instance, and defines the action and observation spaces.

### `step`[](#step)

Executes one environment step, processes the given action, and returns the next state, reward, and other information.

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

This method is the core of the reinforcement learning environment. It takes an action (temperature control), updates the environment state, and returns the new observation, reward, and termination signals.

### `_get_observation`[](#_get_observation)

Retrieves the observation of the current environment state.

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

This method calculates and returns an observation vector of the current environment state, including date, various environmental parameters, and energy consumption.

### `_get_reward`[](#_get_reward)

Calculates the reward value for the current state.

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

This method calculates the reward based on the current state. It considers factors such as crop growth stage, yield, and energy efficiency, and provides additional rewards or penalties at the end of training.

### `_is_done`[](#_is_done)

Determines if the current episode has ended.

```python
def _is_done(self):
    terminated = self.current_step >= self.season_length * (1 / self.season_interval)
    is_mature = self.new_gl["a"]["mcFruitHar"] > 0.01
    return terminated, is_mature
```

This method checks if the season length has been reached or if the crop has matured.

### `reset`[](#reset)

Resets the environment to its initial state.

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

This method is called at the beginning of each new episode. It resets all state variables and returns the initial observation.

### `render`[](#render)

Renders a visualization of the environment. In this implementation, it's an empty method.

## Core Functionality Analysis[](#core-functionality-analysis)

1.  **Dynamic Environment Simulation**:
    
    +   Uses `GreenLightModel` to simulate the physical processes of the greenhouse environment.
    +   Supports different starting dates, increasing training diversity.
2.  **Flexible Action Space**:
    
    +   Uses a discrete action space to control temperature, ranging from 18°C to 28°C.
    +   Adjusts different temperature settings based on day/night status.
3.  **Complex Observation Space**:
    
    +   Contains 14 continuous variables, covering various aspects of the greenhouse environment.
    +   Observations include time information, environmental parameters, and energy consumption data.
4.  **Multi-Objective Reward Function**:
    
    +   Considers crop growth, yield, and energy efficiency.
    +   Uses different reward calculation methods for different growth stages (growth period and harvest period).
    +   Includes dynamic assessment of target yield and energy efficiency.
5.  **Environment Reset Mechanism**:
    
    +   Randomly selects a starting date for each new episode.
    +   Resets all state variables, ensuring the independence of each training session.
6.  **Performance Tracking**:
    
    +   Records unit energy consumption and total yield for each episode.
    +   Provides detailed performance metrics, helpful for evaluating and adjusting reinforcement learning algorithms.

## Considerations[](#considerations)

+   Ensure the correct weather data file path is provided (EPW format).
+   Initial state parameters (`init_state`) have a significant impact on simulation results and need to be carefully set.
+   The design of the reward function directly affects learning outcomes and may need to be adjusted based on specific requirements.
+   The range settings of the observation space should be adjusted according to actual conditions to ensure coverage of all possible states.
+   This environment does not implement the `render` method. If visualization is needed, additional development is required.
+   When using this environment for training, it is recommended to use reinforcement learning algorithms that support continuous action spaces.

[1.1 green\_light\_model](https://botanicbyte.com/Code_Structure/core/green_light_model "1.1 green_light_model")[1.3 greenhouse\_geometry](https://botanicbyte.com/Code_Structure/core/greenhouse_geometry "1.3 greenhouse_geometry")