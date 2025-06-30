# Overview

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md)

## Purpose and Scope

The GreenLightModel repository provides a Python wrapper interface for the GreenLight MATLAB greenhouse simulation model. This system enables Python developers to run sophisticated greenhouse environment simulations with supplemental lighting scenarios, processing weather data, and calculating energy consumption metrics without requiring direct MATLAB programming knowledge.

The system bridges Python and MATLAB ecosystems by managing MATLAB engine instances, handling data format conversions, and providing a simplified API for complex greenhouse modeling workflows. For specific installation and setup instructions, see [Getting Started](/greenpeer/GreenLightModel/2-getting-started). For detailed API documentation, see [GreenLightModel Class Reference](/greenpeer/GreenLightModel/3.1-greenlightmodel-class-reference).

## System Architecture

The GreenLightModel system operates as a multi-layered hybrid architecture that orchestrates Python and MATLAB components:

### High-Level Architecture

```mermaid
flowchart TD

A["GreenLightModel"]
B["run_green_light()"]
C["calculate_energy_consumption()"]
D["update_params()"]
E["main.py"]
F["MATLAB Engine API"]
G["Path Management"]
H["Command Execution"]
I["Data Exchange"]
J["GreenLight Model"]
K["Greenhouse Simulation"]
L["DyMoMa Framework"]
M["Dynamic Modeling"]
N["GreenLight Extensions"]
O["JSON Serialization"]
P["Parameter Utilities"]
Q["Weather Data"]
R["EnergyPlus Format"]
S["Parameter Management"]
T["Formula Evaluation"]
U["Output Processing"]
V["Energy Calculations"]
W["JSON Export"]

A --> F
F --> J
F --> L
F --> N
A --> Q
A --> S
A --> U

subgraph subGraph3 ["Data Processing Layer"]
    Q
    R
    S
    T
    U
    V
    W
    Q --> R
    S --> T
    U --> V
    U --> W
end

subgraph subGraph2 ["MATLAB Execution Environment"]
    J
    K
    L
    M
    N
    O
    P
    J --> K
    L --> M
    N --> O
    N --> P
end

subgraph subGraph1 ["MATLAB Integration Layer"]
    F
    G
    H
    I
    F --> G
    F --> H
    F --> I
end

subgraph subGraph0 ["Python Interface Layer"]
    A
    B
    C
    D
    E
    A --> B
    A --> C
    A --> D
    E --> A
end
```

Sources: [README.md L1-L561](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L1-L561)

### Component Interaction Flow

```mermaid
sequenceDiagram
  participant User Script
  participant GreenLightModel
  participant MATLAB Engine
  participant GreenLight Model
  participant GreenLight Extensions
  participant File System

  User Script->>GreenLightModel: "GreenLightModel()"
  GreenLightModel->>MATLAB Engine: "start MATLAB engine"
  GreenLightModel->>MATLAB Engine: "add_paths()"
  User Script->>GreenLightModel: "update_params(param_dict)"
  GreenLightModel->>GreenLightModel: "formula_result()"
  GreenLightModel->>GreenLightModel: "params_from_string()"
  User Script->>GreenLightModel: "run_green_light()"
  GreenLightModel->>MATLAB Engine: "load weather data"
  GreenLightModel->>GreenLight Model: "create model instance"
  GreenLightModel->>GreenLight Model: "set parameters"
  GreenLightModel->>GreenLight Model: "execute simulation"
  GreenLight Model-->>GreenLightModel: "simulation results"
  GreenLightModel->>GreenLight Extensions: "convert to JSON"
  GreenLightModel->>File System: "save_to_json()"
  GreenLightModel-->>User Script: "return dictionary"
  User Script->>GreenLightModel: "calculate_energy_consumption()"
  GreenLightModel->>GreenLightModel: "process result arrays"
  GreenLightModel-->>User Script: "return energy metrics"
  User Script->>GreenLightModel: "quit()"
  GreenLightModel->>MATLAB Engine: "terminate engine"
```

Sources: [README.md L112-L172](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L112-L172)

 [README.md L188-L313](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L188-L313)

## Key Technologies and Dependencies

The system relies on several core technologies and external dependencies:

### Technology Stack

| Component | Technology | Purpose |
| --- | --- | --- |
| Primary Interface | Python 3.x | User-facing API and orchestration |
| Computational Engine | MATLAB R2016b+ | Greenhouse simulation execution |
| Integration Bridge | `matlabengine` | Python-MATLAB communication |
| Scientific Computing | `numpy`, `scipy`, `sympy` | Data processing and calculations |
| Weather Data | EnergyPlus format | Environmental input data |
| Output Format | JSON | Cross-platform data exchange |

### Core Dependencies

```mermaid
flowchart TD

O["EnergyPlus Weather"]
P["Environmental Data"]
Q["Parameter Files"]
R["Configuration"]
A["MATLAB Runtime"]
B["GreenLight Model"]
C["DyMoMa Framework"]
D["Dynamic Modeling"]
E["GreenLight Extensions"]
F["JSON Utils"]
G["matlabengine"]
H["Engine Communication"]
I["numpy"]
J["Array Processing"]
K["scipy"]
L["Scientific Computing"]
M["sympy"]
N["Formula Evaluation"]

A --> G
B --> G
C --> G
E --> G

subgraph subGraph1 ["Python Packages"]
    G
    H
    I
    J
    K
    L
    M
    N
    G --> H
    I --> J
    K --> L
    M --> N
end

subgraph subGraph0 ["External Systems"]
    A
    B
    C
    D
    E
    F
    A --> B
    C --> D
    E --> F
end

subgraph subGraph2 ["Data Sources"]
    O
    P
    Q
    R
    O --> P
    Q --> R
end
```

Sources: [README.md L60-L79](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L60-L79)

 [README.md L48-L67](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L48-L67)

## Data Flow and Processing Pipeline

The system processes data through several transformation stages:

### Data Processing Pipeline

```mermaid
flowchart TD

A["Weather Data"]
B["EnergyPlus Parser"]
C["User Parameters"]
D["update_params()"]
E["Configuration"]
F["run_green_light()"]
G["params_from_string()"]
H["formula_result()"]
I["Evaluated Parameters"]
J["Weather Matrix"]
K["GreenLight Simulation"]
L["ODE Solver"]
M["Time Series Results"]
N["GreenLight Extensions"]
O["JSON Conversion"]
P["save_to_json()"]
Q["calculate_energy_consumption()"]
R["Energy Metrics"]
S["JSON Files"]
T["Python Dictionary"]
U["User Application"]

D --> G
B --> J
I --> J
F --> J
M --> N
M --> Q
P --> S
R --> T

subgraph Results ["Results"]
    S
    T
    U
    T --> U
end

subgraph subGraph3 ["Output Processing"]
    N
    O
    P
    Q
    R
    N --> O
    O --> P
    Q --> R
end

subgraph subGraph2 ["MATLAB Execution"]
    J
    K
    L
    M
    J --> K
    K --> L
    L --> M
end

subgraph subGraph1 ["Parameter Management"]
    G
    H
    I
    G --> H
    H --> I
end

subgraph subGraph0 ["Input Processing"]
    A
    B
    C
    D
    E
    F
    A --> B
    C --> D
    E --> F
end
```

Sources: [README.md L234-L280](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L234-L280)

 [README.md L283-L298](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L283-L298)

 [README.md L485-L500](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L485-L500)

## System Capabilities

The GreenLightModel system provides comprehensive greenhouse simulation capabilities organized into functional areas:

### Core Simulation Features

* **Greenhouse Environment Modeling**: Complete thermal, humidity, and CO2 dynamics simulation
* **Supplemental Lighting**: Support for LED, HPS, and no-lighting scenarios via `lampType` parameter
* **Weather Integration**: Processing of EnergyPlus weather data or artificial weather generation
* **Crop Growth Modeling**: Mature and immature crop initialization options
* **Energy Analysis**: Automated calculation of lamp, boiler, and CO2 injection energy consumption

### Advanced Parameter Management

* **Formula-Based Parameters**: Dynamic parameter calculation using mathematical expressions
* **Dependent Parameter Resolution**: Automatic calculation of parameters that depend on other parameter values
* **Parameter Validation**: Built-in validation for parameter ranges and dependencies
* **Runtime Parameter Updates**: Ability to modify simulation parameters between runs

Sources: [README.md L234-L280](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L234-L280)

 [README.md L421-L453](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L421-L453)

 [README.md L216-L231](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L216-L231)