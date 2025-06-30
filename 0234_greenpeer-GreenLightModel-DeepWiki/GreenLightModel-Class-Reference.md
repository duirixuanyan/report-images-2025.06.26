# GreenLightModel Class Reference

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md)
> * [__pycache__/gl_model.cpython-39.pyc](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/__pycache__/gl_model.cpython-39.pyc)
> * [gl_model.py](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py)

This document provides comprehensive reference documentation for the `GreenLightModel` class, the primary Python interface for greenhouse environment simulation. The class serves as a wrapper around the MATLAB-based GreenLight model, enabling Python-based control of sophisticated greenhouse simulations with supplemental lighting systems.

For information about the main execution patterns and example usage, see [Main Execution Script](/greenpeer/GreenLightModel/3.2-main-execution-script). For details about the underlying MATLAB integration mechanics, see [MATLAB Engine Interface](/greenpeer/GreenLightModel/4.1-matlab-engine-interface). For data processing workflows, see [Data Processing and Management](/greenpeer/GreenLightModel/5-data-processing-and-management).

## Class Architecture Overview

The `GreenLightModel` class acts as the central orchestrator for all greenhouse simulation operations, managing the complete lifecycle from initialization through simulation execution to result processing.

```mermaid
classDiagram
    class GreenLightModel {
        +current_folder: str
        +output_folder: str
        +eng: matlab.engine
        +init(output_folder=None)
        +add_paths(*args)
        +run_green_light(**kwargs)
        +update_params(gl, initial_gl)
        +calculate_energy_consumption(gl, *array_keys)
        +quit()
        +makeArtificialInput(length)
        +co2ppm2dens(temp, ppm)
        +day_light_sum(time, rad)
        +generate_datenum_list(start_datenum, num_days, interval_secs)
        +params_from_string(formular_str)
        +formula_result(param_dict, formula_str, para_list)
        +default_output_folder()
        +data_folder()
        +save_to_json(json_data, filename)
        +find_comment(var_name)
        +help(function_name)
    }
```

**Sources:** [gl_model.py L21-L566](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L21-L566)

## Core Functionality

The class provides five core methods that handle the primary simulation workflow:

### Initialization and Path Management

The constructor initializes the MATLAB engine and configures the required path structure for accessing MATLAB components.

```mermaid
flowchart TD

A["init(output_folder=None)"]
B["Set current_folder and output_folder"]
C["Create output directory if needed"]
D["Start MATLAB engine"]
E["Call add_paths()"]
F["Add GreenLight, DyMoMa, GreenLight_Extensions to MATLAB path"]

A --> B
B --> C
C --> D
D --> E
E --> F
```

**Sources:** [gl_model.py L51-L72](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L51-L72)

### Parameter Management System

The `update_params` method handles complex parameter processing including formula evaluation for dependent parameters.

```mermaid
flowchart TD

A["initial_gl dict"]
B["Check parameter category"]
C["Parameter type 'p'?"]
D["Set model parameters via setParam"]
E["Parameter type 'x'?"]
F["Set state values via setParamVal"]
G["Updated MATLAB gl object"]

A --> B
B --> C
C --> D
B --> E
E --> F
D --> G
F --> G
```

**Sources:** [gl_model.py L205-L242](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L205-L242)

### Main Simulation Execution

The `run_green_light` method orchestrates the complete simulation process from weather data loading through result generation.

```mermaid
sequenceDiagram
  participant Client
  participant GreenLightModel
  participant MATLAB Engine
  participant GreenLight Model

  Client->>GreenLightModel: run_green_light(params)
  GreenLightModel->>MATLAB Engine: cutEnergyPlusData(weather params)
  GreenLightModel->>MATLAB Engine: createGreenLightModel(lamp_type, weather, start_time)
  GreenLightModel->>MATLAB Engine: setParams4haWorldComparison(gl)
  GreenLightModel->>MATLAB Engine: setParam(gl, "hElevation", elevation)
  GreenLightModel->>MATLAB Engine: setDepParams(gl)
  GreenLightModel->>GreenLightModel: update_params(gl, initial_gl)
  GreenLightModel->>MATLAB Engine: solveFromFile(gl, "ode15s", options)
  GreenLightModel->>MATLAB Engine: changeRes(gl, 300.0)
  GreenLightModel->>MATLAB Engine: glObjToJson(gl)
  GreenLightModel->>GreenLightModel: save results if filename provided
  GreenLightModel->>Client: return Python dict
```

**Sources:** [gl_model.py L89-L203](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L89-L203)

## Method Categories

### Core Methods

| Method | Purpose | Key Parameters |
| --- | --- | --- |
| `add_paths` | Configure MATLAB search paths | `*args` - additional folder names |
| `update_params` | Apply parameter updates to model | `gl` - MATLAB object, `initial_gl` - parameter dict |
| `run_green_light` | Execute complete simulation | `filename`, `weatherInput`, `seasonLength`, `lampType` |
| `calculate_energy_consumption` | Compute energy metrics from results | `gl` - results dict, `*array_keys` - parameter names |
| `quit` | Terminate MATLAB engine | None |

**Sources:** [README.md L188-L194](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L188-L194)

 [gl_model.py L73-L285](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L73-L285)

### Utility Methods

The class provides extensive utility functions for data processing and analysis:

```mermaid
flowchart TD

A["Utility Methods"]
B["Data Generation"]
C["Unit Conversion"]
D["Time Processing"]
E["Parameter Processing"]
F["File Operations"]
G["System Helpers"]
B1["makeArtificialInput()"]
C1["co2ppm2dens()"]
D1["day_light_sum()"]
D2["generate_datenum_list()"]
E1["params_from_string()"]
E2["formula_result()"]
F1["save_to_json()"]
F2["default_output_folder()"]
F3["data_folder()"]
G1["find_comment()"]
G2["help()"]

A --> B
A --> C
A --> D
A --> E
A --> F
A --> G
B --> B1
C --> C1
D --> D1
D --> D2
E --> E1
E --> E2
F --> F1
F --> F2
F --> F3
G --> G1
G --> G2
```

**Sources:** [README.md L316-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L316-L329)

 [gl_model.py L297-L566](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L297-L566)

## Integration with MATLAB Components

The class manages integration with three key MATLAB components:

```mermaid
flowchart TD

A["GreenLightModel"]
B["matlab.engine"]
C["GreenLight Model"]
D["DyMoMa Framework"]
E["GreenLight_Extensions"]
C1["Core greenhouse simulation"]
D1["Dynamic modeling framework"]
E1["JSON serialization utilities"]
E2["Parameter manipulation tools"]

A --> B
B --> C
B --> D
B --> E
C --> C1
D --> D1
E --> E1
E --> E2
```

The MATLAB engine is initialized at construction and provides the bridge to execute MATLAB functions and manipulate MATLAB objects from Python.

**Sources:** [gl_model.py L68-L71](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L68-L71)

 [gl_model.py L82-L87](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L82-L87)

## Data Processing Capabilities

### Weather Data Processing

The class supports multiple weather input modes:

* **EnergyPlus files**: Real weather data loaded via `cutEnergyPlusData`
* **Artificial weather**: Generated using `makeArtificialInput` with configurable duration
* **Custom weather matrices**: 9-column format with radiation, temperature, humidity, CO2, wind, sky temperature, soil temperature, and daily radiation sums

**Sources:** [gl_model.py L100-L117](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L100-L117)

 [gl_model.py L297-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L297-L329)

### Energy Consumption Analysis

The `calculate_energy_consumption` method processes simulation results to compute energy metrics:

```mermaid
flowchart TD

A["Simulation Results (gl dict)"]
B["Extract parameter arrays by keys"]
C["Map second-level keys to top-level keys"]
D["Combine arrays for specified parameters"]
E["Apply trapezoidal integration"]
F["Convert to MJ/m² or kg/m²"]

A --> B
B --> C
C --> D
D --> E
E --> F
```

This method supports combining multiple parameters (e.g., `qLampIn`, `qIntLampIn` for total lamp energy) and returns integrated values over the simulation time period.

**Sources:** [gl_model.py L244-L281](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L244-L281)

## File Path Management

The class uses a structured approach to file and folder management:

| Method | Purpose | Default Path |
| --- | --- | --- |
| `default_output_folder` | Simulation output location | `GreenLight/Output/` |
| `data_folder` | Weather input data location | `GreenLight/Code/inputs/energyPlus/data/` |
| `save_to_json` | JSON result serialization | Uses `output_folder` with `.json` extension |

**Sources:** [gl_model.py L287-L295](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L287-L295)

 [gl_model.py L480-L505](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L480-L505)

## Error Handling and Resource Management

The class implements proper resource management for the MATLAB engine connection:

* Engine initialization occurs during construction
* Path configuration is automatic via `add_paths`
* Explicit cleanup via `quit()` method terminates the MATLAB engine
* JSON serialization handles MATLAB-to-Python data conversion safely

**Sources:** [gl_model.py L283-L285](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L283-L285)

 [gl_model.py L68-L71](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L68-L71)