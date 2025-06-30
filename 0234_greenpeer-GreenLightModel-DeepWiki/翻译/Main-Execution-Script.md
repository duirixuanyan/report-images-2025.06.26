# Main Execution Script

> **Relevant source files**
> * [main.py](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py)

## Purpose and Scope

This document covers the `main.py` script, which serves as the primary demonstration and example of how to use the GreenLightModel system. The script illustrates a complete workflow from model initialization through simulation execution to energy consumption analysis. For detailed information about the GreenLightModel class methods and parameters, see [GreenLightModel Class Reference](/greenpeer/GreenLightModel/3.1-greenlightmodel-class-reference). For information about the underlying MATLAB integration, see [MATLAB Engine Interface](/greenpeer/GreenLightModel/4.1-matlab-engine-interface).

## Script Overview

The `main.py` script provides a concrete example of the typical usage pattern for the GreenLightModel system. It demonstrates the essential workflow steps including model instantiation, parameter configuration, simulation execution, energy consumption calculations, and proper resource cleanup.

The script is structured as a linear execution flow that showcases the core capabilities of the system in approximately 50 lines of code. It serves both as functional example code and as a reference implementation for users wanting to understand proper usage patterns.

**Sources:** [main.py L1-L48](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L1-L48)

## Execution Flow and Workflow

### Script Execution Flow

```mermaid
flowchart TD

A["Script Start"]
B["time.time()"]
C["GreenLightModel()"]
D["Configure gl parameters<br>tSpNight, tSpDay"]
E["model.run_green_light()<br>filename='sample'<br>weatherInput='bei'"]
F["model.quit()"]
G["calculate_energy_consumption()<br>lampIn, boilIn, co2inj"]
H["Print Results"]
I["Print Execution Time"]
J["Script End"]

A --> B
B --> C
C --> D
D --> E
E --> F
F --> G
G --> H
H --> I
I --> J
```

The execution follows a straightforward sequential pattern where each step depends on the successful completion of the previous step. The script implements proper resource management by explicitly calling `model.quit()` to terminate the MATLAB engine before proceeding to post-processing calculations.

**Sources:** [main.py L1-L48](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L1-L48)

### Method Call Sequence

```mermaid
sequenceDiagram
  participant main.py Script
  participant GreenLightModel Instance
  participant MATLAB Engine

  main.py Script->>GreenLightModel Instance: GreenLightModel()
  GreenLightModel Instance-->>main.py Script: model instance
  main.py Script->>GreenLightModel Instance: run_green_light(filename, weatherInput, etc.)
  GreenLightModel Instance->>MATLAB Engine: Execute simulation
  MATLAB Engine-->>GreenLightModel Instance: simulation results (gl)
  GreenLightModel Instance-->>main.py Script: gl dictionary
  main.py Script->>GreenLightModel Instance: quit()
  GreenLightModel Instance->>MATLAB Engine: Terminate engine
  main.py Script->>GreenLightModel Instance: calculate_energy_consumption(gl, "qLampIn", "qIntLampIn")
  GreenLightModel Instance-->>main.py Script: lampIn value
  main.py Script->>GreenLightModel Instance: calculate_energy_consumption(gl, "hBoilPipe", "hBoilGroPipe")
  GreenLightModel Instance-->>main.py Script: boilIn value
  main.py Script->>GreenLightModel Instance: calculate_energy_consumption(gl, "mcExtAir")
  GreenLightModel Instance-->>main.py Script: co2inj value
```

**Sources:** [main.py L8-L37](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L8-L37)

## Configuration and Parameters

### Initial Parameter Configuration

The script demonstrates parameter configuration through the `gl` dictionary structure that contains greenhouse operational parameters:

| Parameter | Value | Unit | Description |
| --- | --- | --- | --- |
| `tSpNight` | 28.5 | °C | Temperature set point for dark period |
| `tSpDay` | 29.5 | °C | Temperature set point for light period |

These parameters are passed to the simulation through the `initial_gl` argument in the `run_green_light` method call at [main.py L26](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L26-L26)

**Sources:** [main.py L11-L16](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L11-L16)

### Simulation Configuration

The script configures the simulation execution with specific parameters passed to `model.run_green_light()`:

```mermaid
flowchart TD

A["run_green_light() Parameters"]
B["filename='sample'"]
C["weatherInput='bei'"]
D["seasonLength=1/24/6"]
E["firstDay=1"]
F["isMature=False"]
G["lampType='led'"]
H["initial_gl=gl"]
I["Output file naming"]
J["Beijing weather data"]
K["10-minute simulation"]
L["January 1st start"]
M["Small crop start"]
N["LED lighting system"]
O["Temperature parameters"]

A --> B
A --> C
A --> D
A --> E
A --> F
A --> G
A --> H
B --> I
C --> J
D --> K
E --> L
F --> M
G --> N
H --> O
```

The `seasonLength` value of `1/24/6` represents a 10-minute simulation period, calculated as 1 day ÷ 24 hours ÷ 6 (since there are 6 five-minute intervals per hour).

**Sources:** [main.py L19-L27](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L19-L27)

## Energy Consumption Calculations

### Post-Simulation Analysis

After simulation completion and MATLAB engine termination, the script performs three energy consumption calculations using the `calculate_energy_consumption` method:

| Calculation | MATLAB Variables | Description | Units |
| --- | --- | --- | --- |
| `lampIn` | `"qLampIn"`, `"qIntLampIn"` | Lamp energy consumption | MJ m⁻² |
| `boilIn` | `"hBoilPipe"`, `"hBoilGroPipe"` | Boiler energy consumption | MJ m⁻² |
| `co2inj` | `"mcExtAir"` | CO₂ injection usage | kg m⁻² |

### Energy Calculation Code Entity Mapping

```mermaid
flowchart TD

A["calculate_energy_consumption(gl, 'qLampIn', 'qIntLampIn')"]
B["calculate_energy_consumption(gl, 'hBoilPipe', 'hBoilGroPipe')"]
C["calculate_energy_consumption(gl, 'mcExtAir')"]
D["qLampIn<br>Primary lamp heat"]
E["qIntLampIn<br>Internal lamp heat"]
F["hBoilPipe<br>Boiler pipe heat"]
G["hBoilGroPipe<br>Boiler ground pipe heat"]
H["mcExtAir<br>External air mass flow"]
I["lampIn"]
J["boilIn"]
K["co2inj"]

A --> D
A --> E
A --> I
B --> F
B --> G
B --> J
C --> H
C --> K

subgraph subGraph2 ["Python Result Variables"]
    I
    J
    K
end

subgraph subGraph1 ["MATLAB Variable Names"]
    D
    E
    F
    G
    H
end

subgraph subGraph0 ["Python Method Calls"]
    A
    B
    C
end
```

The energy consumption calculations are performed at [main.py L33-L37](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L33-L37)

 and utilize the simulation results stored in the `gl` dictionary returned by the `run_green_light` method.

**Sources:** [main.py L33-L37](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L33-L37)

## Performance Monitoring and Output

The script includes execution time measurement using `time.time()` calls at the beginning [main.py L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L5-L5)

 and end [main.py L45](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L45-L45)

 of execution. Results are formatted and displayed with clear section dividers using `"--" * 40` for visual separation.

The output format provides structured information about energy consumption metrics followed by total execution time, enabling users to assess both simulation results and performance characteristics.

**Sources:** [main.py L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L5-L5)

 [main.py L39-L47](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L39-L47)