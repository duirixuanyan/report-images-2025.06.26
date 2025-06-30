# Overview

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)
> * [README_zh.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README_zh.md)

This document provides a comprehensive overview of GreenLightPlus, a Python toolkit for greenhouse environment simulation and energy optimization. It covers the system's architecture, core components, and integration capabilities.

GreenLightPlus is designed for researchers, engineers, and developers working on greenhouse automation, energy optimization, and agricultural AI systems. For detailed usage examples, see [Usage Examples](/greenpeer/GreenLightPlus/4-usage-examples). For development information, see [Development](/greenpeer/GreenLightPlus/5-development).

## System Overview

GreenLightPlus is a Python-based greenhouse simulation and optimization platform that extends David Katzin's original MATLAB GreenLight model. The system provides four primary capabilities:

| Capability | Purpose | Primary Component |
| --- | --- | --- |
| Environment Simulation | Model greenhouse climate dynamics and crop growth | `GreenLightModel` |
| Energy Analysis | Detailed building energy consumption analysis | `GreenhouseSimulation` |
| AI Optimization | Reinforcement learning for control strategies | `GreenhouseEnv` |
| Structural Modeling | Generate greenhouse geometric configurations | `GreenhouseGeometry` |

The toolkit integrates with external systems including EnergyPlus v23.2.0 for building simulation, Ray RLlib for distributed reinforcement learning, and standard weather data formats (EPW files).

**Core Architecture**

```mermaid
flowchart TD

GLM["GreenLightModel<br>green_light_model.py<br>ODE simulation engine"]
GS["GreenhouseSimulation<br>greenlight_energyplus_simulation.py<br>EnergyPlus integration"]
GE["GreenhouseEnv<br>greenhouse_env.py<br>RL environment"]
GG["GreenhouseGeometry<br>greenhouse_geometry.py<br>Structure generation"]
CGLM["create_green_light_model/<br>Model initialization"]
SF["service_functions/<br>Data processing utilities"]
RA["result_analysis/<br>Visualization and metrics"]
EP["EnergyPlus v23.2.0<br>Building energy simulation"]
RAY["Ray RLlib<br>Distributed RL framework"]
WD["Weather data<br>EPW files, CSV processing"]

CGLM --> GLM
SF --> GLM
GLM --> RA
GS --> EP
GE --> RAY
SF --> WD
GG --> EP

subgraph External_Dependencies ["External Dependencies"]
    EP
    RAY
    WD
end

subgraph Supporting_Systems ["Supporting Systems"]
    CGLM
    SF
    RA
end

subgraph Core_Components ["Core Components"]
    GLM
    GS
    GE
    GG
    GLM --> GS
    GLM --> GE
end
```

Sources: [README.md L14-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L14-L50)

 [README.md L38-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L38-L50)

## Core Component Relationships

The four core components of GreenLightPlus operate in a hierarchical relationship where `GreenLightModel` serves as the central simulation engine that other components depend on or extend.

**Component Dependencies and Data Flow**

```mermaid
flowchart TD

ODE["ode.py<br>ODE system definition"]
PARAMS["set_gl_params.py<br>Parameter configuration"]
STATES["set_gl_states.py<br>State initialization"]
CONTROL["set_gl_control.py<br>Control logic"]
AUX["set_gl_aux.py<br>Auxiliary calculations"]
GLM["GreenLightModel<br>green_light_model.py<br>Primary simulation class"]
GS["GreenhouseSimulation<br>greenlight_energyplus_simulation.py<br>co-simulation wrapper"]
GE["GreenhouseEnv<br>greenhouse_env.py<br>gymnasium environment"]
GG["GreenhouseGeometry<br>greenhouse_geometry.py<br>IDF file generator"]
CONV["convert_epw2csv.py<br>Weather processing"]
FUNCS["funcs.py<br>Calculation utilities"]
PLOT["plot_green_light.py<br>Result visualization"]

ODE --> GLM
PARAMS --> GLM
STATES --> GLM
CONTROL --> GLM
AUX --> GLM
GLM --> GS
GLM --> GE
CONV --> GLM
FUNCS --> GLM
GLM --> PLOT

subgraph Utilities ["Service Layer"]
    CONV
    FUNCS
    PLOT
end

subgraph Extensions ["Component Extensions"]
    GS
    GE
    GG
    GG --> GS
end

subgraph Core_Engine ["Core Simulation Engine"]
    GLM
end

subgraph Model_Creation ["Model Creation Layer"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
end
```

**Key Integration Points:**

* **Model Initialization**: The `create_green_light_model/` directory contains modules that construct the ODE system, set parameters, and initialize states for `GreenLightModel`
* **Simulation Extensions**: Both `GreenhouseSimulation` and `GreenhouseEnv` wrap `GreenLightModel` to provide specialized interfaces
* **Data Processing**: Weather data flows through `convert_epw2csv.py` before reaching the simulation engine
* **Result Analysis**: Output from `GreenLightModel` is processed by visualization and analysis functions

Sources: [README.md L40-L50](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L50)

 [README.md L47-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L47-L49)

## External System Integration

GreenLightPlus integrates with multiple external systems to provide comprehensive greenhouse simulation and optimization capabilities.

**Integration Architecture**

```mermaid
flowchart TD

CLI["Command Line Interface<br>Entry points and scripts"]
GLM["GreenLightModel<br>Core simulation engine"]
GS["GreenhouseSimulation<br>EnergyPlus wrapper"]
GE["GreenhouseEnv<br>RL environment wrapper"]
NP["NumPy<br>Numerical arrays"]
PD["Pandas<br>Data manipulation"]
SP["SciPy<br>ODE solving"]
MPL["Matplotlib<br>Plotting backend"]
EP["EnergyPlus v23.2.0<br>Building physics engine"]
PYEP["pyenergyplus.api<br>Python API wrapper"]
IDF["IDF model files<br>Building definitions"]
GYM["Gymnasium<br>RL environment standard"]
RAY["Ray RLlib<br>Distributed RL framework"]
PPO["PPO Algorithm<br>Policy optimization"]
EPW["EPW weather files<br>energyplus-weather.s3.amazonaws.com"]
CSV["Processed weather data<br>convert_epw2csv output"]

GLM --> NP
GLM --> PD
GLM --> SP
GLM --> MPL
GS --> PYEP
GS --> IDF
GE --> GYM
GE --> RAY
CSV --> GLM

subgraph Data_Sources ["External Data"]
    EPW
    CSV
    EPW --> CSV
end

subgraph Machine_Learning ["ML and Optimization"]
    GYM
    RAY
    PPO
    RAY --> PPO
end

subgraph Building_Simulation ["Building Energy Simulation"]
    EP
    PYEP
    IDF
    PYEP --> EP
    IDF --> EP
end

subgraph Scientific_Stack ["Scientific Computing"]
    NP
    PD
    SP
    MPL
end

subgraph GreenLightPlus_Core ["GreenLightPlus Core System"]
    CLI
    GLM
    GS
    GE
    CLI --> GLM
    CLI --> GS
    CLI --> GE
end
```

**Integration Details:**

| External System | Integration Method | Primary Interface | Purpose |
| --- | --- | --- | --- |
| EnergyPlus | Python API (`pyenergyplus.api`) | `GreenhouseSimulation` class | Building energy analysis |
| Ray RLlib | Direct import and configuration | `GreenhouseEnv` as Gymnasium environment | Distributed RL training |
| Weather Data | AWS S3 downloads and CSV conversion | `convert_epw2csv.py` | Climate data processing |
| Scientific Stack | Standard Python imports | Throughout codebase | Numerical computation |

**Configuration Requirements:**

* EnergyPlus installation path must be added to Python `sys.path` [README.md L298-L299](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L298-L299)
* Weather files downloaded from AWS S3 bucket [README.md L85-L86](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L85-L86)
* Ray RLlib configuration through `PPOConfig` class [README.md L359-L433](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L359-L433)

Sources: [README.md L55-L96](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L55-L96)

 [README.md L288-L340](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L288-L340)

 [README.md L341-L452](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L341-L452)

## Data Processing Pipeline

GreenLightPlus implements a comprehensive data processing pipeline that transforms weather data, manages simulation states, and produces analysis outputs.

**Pipeline Architecture**

```mermaid
flowchart TD

EPW_RAW["EPW Weather Files<br>NLD_Amsterdam.062400_IWEC.epw"]
IDF_FILES["EnergyPlus IDF Files<br>greenhouse_half_circle.idf"]
INIT_PARAMS["Model Parameters<br>Greenhouse structure and control"]
CONV["convert_epw2csv()<br>Weather data conversion"]
VALID["Data validation<br>funcs.py utilities"]
MODEL_INIT["Model initialization<br>create_green_light_model/"]
GL_SIM["GreenLightModel.run_model()<br>ODE integration"]
EP_SIM["GreenhouseSimulation.run()<br>Co-simulation"]
RL_TRAIN["GreenhouseEnv.step()<br>RL training loop"]
METRICS["calculate_energy_consumption()<br>Energy and yield metrics"]
VIZ["plot_green_light()<br>Result visualization"]
CHECKPOINTS["Model checkpoints<br>RL policy storage"]

EPW_RAW --> CONV
IDF_FILES --> EP_SIM
INIT_PARAMS --> MODEL_INIT
VALID --> GL_SIM
MODEL_INIT --> GL_SIM
GL_SIM --> METRICS
EP_SIM --> METRICS
RL_TRAIN --> CHECKPOINTS

subgraph Output_Analysis ["Analysis and Output"]
    METRICS
    VIZ
    CHECKPOINTS
    METRICS --> VIZ
end

subgraph Simulation_Engines ["Simulation Layer"]
    GL_SIM
    EP_SIM
    RL_TRAIN
    GL_SIM --> EP_SIM
    GL_SIM --> RL_TRAIN
end

subgraph Processing_Layer ["Data Processing"]
    CONV
    VALID
    MODEL_INIT
    CONV --> VALID
end

subgraph Input_Data ["Input Data Sources"]
    EPW_RAW
    IDF_FILES
    INIT_PARAMS
end
```

**Processing Functions:**

| Stage | Function/Class | Input Format | Output Format | Purpose |
| --- | --- | --- | --- | --- |
| Weather Processing | `convert_epw2csv()` | EPW files | CSV time series | Climate data standardization |
| Model Creation | `create_green_light_model/` modules | Parameters dict | Model state dict | Simulation initialization |
| Simulation | `GreenLightModel.run_model()` | State dict + parameters | Updated state dict | Core greenhouse dynamics |
| Analysis | `calculate_energy_consumption()` | Simulation results | Scalar metrics | Performance evaluation |
| Visualization | `plot_green_light()` | Simulation results | Matplotlib figures | Result presentation |

**State Management:**

The system maintains simulation state through nested dictionaries containing:

* Physical parameters (`'p'` key) for greenhouse structure and control settings
* State variables for temperatures, humidity, CO2, and crop growth
* Time-series outputs for energy consumption and environmental conditions

Sources: [README.md L175-L286](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L175-L286)

 [README.md L187-L262](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L187-L262)

 [README.md L312-L338](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L312-L338)