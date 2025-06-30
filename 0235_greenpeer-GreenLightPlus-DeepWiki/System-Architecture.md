# System Architecture

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

## Purpose and Scope

This document provides a comprehensive overview of the GreenLightPlus system architecture, detailing how the four core components interact within the greenhouse simulation and optimization ecosystem. It covers the structural organization of the codebase, component relationships, data flow patterns, and external system integrations.

For installation and setup procedures, see [Installation and Setup](/greenpeer/GreenLightPlus/1.2-installation-and-setup). For detailed documentation of individual components, see [Core Components](/greenpeer/GreenLightPlus/2-core-components). For information about specific utility modules and supporting systems, see [Supporting Systems](/greenpeer/GreenLightPlus/3-supporting-systems).

## Core System Components

GreenLightPlus is built around four primary components that work together to provide comprehensive greenhouse simulation and optimization capabilities:

### Component Overview

```

```

**Core Component Responsibilities:**

| Component | Primary Class | Key Functions | Purpose |
| --- | --- | --- | --- |
| GreenLightModel | `GreenLightModel` | `run_model()`, `solve_ode()` | ODE-based greenhouse simulation |
| GreenhouseGeometry | `GreenhouseGeometry` | `create_houses()` | Geometric structure generation |
| GreenhouseSimulation | `GreenhouseSimulation` | `run()`, `get_results()` | EnergyPlus integration |
| GreenhouseEnv | `GreenhouseEnv` | `step()`, `reset()` | Gymnasium RL interface |

Sources: [README.md L40-L43](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L43)

 [README.md L45-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L45-L49)

## Component Interaction Architecture

The system follows a hierarchical architecture where `GreenLightModel` serves as the central simulation engine, with other components building upon its functionality:

### Interaction Flow

```mermaid
flowchart TD

CLI["GreenLight_Sim.cli:main()"]
API["Python API"]
GLM["GreenLightModel"]
ENV["GreenhouseEnv"]
SIM["GreenhouseSimulation"]
GEO["GreenhouseGeometry"]
ODE["ode.py"]
PARAMS["set_gl_params.py"]
STATES["set_gl_states.py"]
CONTROL["set_gl_control.py"]
AUX["set_gl_aux.py"]
FUNCS["funcs.py"]
CONVERT["convert_epw2csv.py"]
CO2["co2_dens2ppm.py"]
VP["vp2dens.py"]

CLI --> GLM
CLI --> ENV
CLI --> SIM
CLI --> GEO
API --> GLM
API --> ENV
GLM --> ODE
GLM --> FUNCS
GLM --> CONVERT

subgraph subGraph3 ["Service Layer"]
    FUNCS
    CONVERT
    CO2
    VP
    FUNCS --> CO2
    FUNCS --> VP
end

subgraph subGraph2 ["Model Construction Layer"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
    ODE --> PARAMS
    ODE --> STATES
    ODE --> CONTROL
    ODE --> AUX
end

subgraph subGraph1 ["Core Simulation Layer"]
    GLM
    ENV
    SIM
    GEO
    ENV --> GLM
    SIM --> GLM
end

subgraph subGraph0 ["User Interface Layer"]
    CLI
    API
end
```

**Key Interaction Patterns:**

1. **Composition**: `GreenhouseEnv` and `GreenhouseSimulation` both contain and control `GreenLightModel` instances
2. **Dependency**: `GreenLightModel` depends on model construction modules in `create_green_light_model/`
3. **Delegation**: Service functions provide specialized calculations used throughout the system

Sources: [pyproject.toml L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L48-L48)

 [README.md L40-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L49)

## Data Flow Architecture

The system processes data through a well-defined pipeline from input sources to analysis outputs:

### Data Processing Pipeline

```mermaid
flowchart TD

EPW["EPW weather files<br>Amsterdam.epw"]
IDF["EnergyPlus IDF files<br>greenhouse_half_circle.idf"]
PARAMS["Model parameters<br>init_state dict"]
CONV["convert_epw2csv()<br>Weather preprocessing"]
INIT["create_green_light_model<br>Parameter initialization"]
VALID["check_csv()<br>Data validation"]
GLM_CORE["GreenLightModel.run_model()<br>ODE integration"]
EP_SIM["EnergyPlusAPI<br>Building physics"]
RL_TRAIN["PPOConfig<br>Policy optimization"]
RESULTS["Simulation state dict<br>gl variable"]
CALC["calculate_energy_consumption()<br>Metrics extraction"]
PLOT["plot_green_light()<br>Visualization"]
YIELD["extract_last_value_from_nested_dict()<br>Yield calculation"]

EPW --> CONV
CONV --> GLM_CORE
IDF --> EP_SIM
PARAMS --> INIT
INIT --> GLM_CORE
VALID --> GLM_CORE
GLM_CORE --> RESULTS
EP_SIM --> RESULTS

subgraph subGraph3 ["Output Processing"]
    RESULTS
    CALC
    PLOT
    YIELD
    RESULTS --> CALC
    RESULTS --> PLOT
    RESULTS --> YIELD
end

subgraph subGraph2 ["Simulation Engines"]
    GLM_CORE
    EP_SIM
    RL_TRAIN
    GLM_CORE --> EP_SIM
    GLM_CORE --> RL_TRAIN
end

subgraph subGraph1 ["Data Processing"]
    CONV
    INIT
    VALID
    CONV --> VALID
end

subgraph subGraph0 ["Input Data Sources"]
    EPW
    IDF
    PARAMS
end
```

**Data Transformation Stages:**

1. **Input Processing**: Weather data converted from EPW to CSV format using `convert_epw2csv()`
2. **Parameter Initialization**: Model structure defined through `create_green_light_model` modules
3. **Simulation Execution**: ODE system solved via `GreenLightModel.run_model()`
4. **Result Extraction**: Metrics calculated using utility functions like `calculate_energy_consumption()`

Sources: [README.md L179-L262](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L179-L262)

 [README.md L296-L331](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L296-L331)

## External System Dependencies

GreenLightPlus integrates with several external systems to provide comprehensive simulation capabilities:

### Integration Architecture

```mermaid
flowchart TD

CORE["Core Components"]
UTILS["Utility Modules"]
NP["numpy<br>Numerical arrays"]
PD["pandas<br>Data manipulation"]
SP["scipy<br>ODE solving"]
GYM["gymnasium<br>RL framework"]
EP["EnergyPlus v23.2.0<br>Building simulation"]
OS["openstudio==3.6.1<br>Building modeling"]
RAY["ray[rllib]<br>Distributed RL"]
PPO["PPOConfig<br>Policy optimization"]
AWS["energyplus-weather.s3.amazonaws.com<br>Weather database"]
GDRIVE["Google Drive<br>gdown downloads"]

CORE --> NP
CORE --> PD
CORE --> SP
CORE --> GYM
CORE --> EP
CORE --> OS
CORE --> RAY
UTILS --> AWS
UTILS --> GDRIVE

subgraph subGraph4 ["External Data Sources"]
    AWS
    GDRIVE
end

subgraph subGraph3 ["Machine Learning"]
    RAY
    PPO
    RAY --> PPO
end

subgraph subGraph2 ["Simulation & Modeling"]
    EP
    OS
end

subgraph subGraph1 ["Scientific Computing Stack"]
    NP
    PD
    SP
    GYM
end

subgraph subGraph0 ["GreenLightPlus Core"]
    CORE
    UTILS
end
```

**Key External Dependencies:**

| System | Version | Integration Point | Purpose |
| --- | --- | --- | --- |
| EnergyPlus | v23.2.0 | `EnergyPlusAPI` | Building energy simulation |
| OpenStudio | 3.6.1 | IDF file processing | Building model management |
| Ray RLlib | Latest | `PPOConfig`, `GreenhouseEnv` | Distributed RL training |
| SciPy | Latest | `solve_ivp()` in ODE module | Differential equation solving |
| Gymnasium | Latest | `GreenhouseEnv` base class | RL environment framework |

Sources: [pyproject.toml L25-L33](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L25-L33)

 [README.md L55-L90](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L55-L90)

## Module Dependency Structure

The codebase is organized into a clear hierarchy of dependencies that supports maintainability and extensibility:

### Dependency Hierarchy

```mermaid
flowchart TD

FUNCS["funcs.py"]
CONV["convert_epw2csv.py"]
CO2["co2_dens2ppm.py"]
VP["vp2dens.py"]
CHECK["check_csv.py"]
ODE["ode.py"]
PARAMS["set_gl_params.py"]
STATES["set_gl_states.py"]
CONTROL["set_gl_control.py"]
AUX["set_gl_aux.py"]
GLM["green_light_model.py"]
GEO["greenhouse_geometry.py"]
ENV["greenhouse_env.py"]
SIM["greenlight_energyplus_simulation.py"]
PLOT["plot_green_light.py"]
ENERGY["energy_analysis.py"]
CLI["GreenLight_Sim.cli"]

ODE --> FUNCS
ODE --> CO2
ODE --> VP
GLM --> ODE
GLM --> CONV
GLM --> CHECK
ENV --> GLM
SIM --> GLM
GEO --> FUNCS
PLOT --> GLM
ENERGY --> GLM
CLI --> GLM
CLI --> ENV
CLI --> SIM
CLI --> GEO

subgraph subGraph4 ["Layer 5: Analysis & CLI"]
    PLOT
    ENERGY
    CLI
end

subgraph subGraph3 ["Layer 4: Integration Components"]
    ENV
    SIM
end

subgraph subGraph2 ["Layer 3: Core Components"]
    GLM
    GEO
end

subgraph subGraph1 ["Layer 2: Model Construction"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
end

subgraph subGraph0 ["Layer 1: Service Functions"]
    FUNCS
    CONV
    CO2
    VP
    CHECK
end
```

**Architectural Principles:**

1. **Layered Dependencies**: Higher layers depend on lower layers, preventing circular dependencies
2. **Service Layer Isolation**: Core mathematical and conversion functions isolated in service layer
3. **Component Composition**: Integration components compose rather than inherit from core components
4. **Single Responsibility**: Each module has a focused purpose within its layer

Sources: [README.md L40-L49](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L40-L49)

 [pyproject.toml L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L48-L48)