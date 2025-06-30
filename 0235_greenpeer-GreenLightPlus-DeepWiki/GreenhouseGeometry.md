# GreenhouseGeometry

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md)

The GreenhouseGeometry system provides structural modeling capabilities for generating geometric models of different greenhouse structures. This component is responsible for creating detailed geometric representations of greenhouses with various roof configurations, which serve as the foundation for environmental simulations and energy analysis within the GreenLightPlus framework.

For information about the core simulation engine that uses these geometric models, see [GreenLightModel](/greenpeer/GreenLightPlus/2.1-greenlightmodel). For details about EnergyPlus integration that leverages these geometric structures, see [GreenhouseSimulation](/greenpeer/GreenLightPlus/2.2-greenhousesimulation).

## System Overview

The GreenhouseGeometry system centers around the `GreenhouseGeometry` class, which generates parametric greenhouse models with six different roof types. The system provides standardized geometric parameters that can be consumed by other components in the GreenLightPlus ecosystem for simulation and analysis.

```mermaid
flowchart TD

GG["GreenhouseGeometry Class<br>greenhouse_geometry.py"]
RF["Roof Type Generator"]
PG["Parameter Generator"]
GM["Geometry Model"]
RT["Roof Types<br>triangle, half_circle,<br>flat_arch, gothic_arch,<br>sawtooth, sawtooth_arch"]
SP["Structural Parameters<br>wall_height, wall_width,<br>wall_length, num_segments,<br>slope"]
EP["Environmental Parameters<br>max_indoor_temp,<br>min_outdoor_temp,<br>max_wind_speed"]
TP["Temporal Parameters<br>start_month, start_day,<br>end_month, end_day"]
IDM["IDF Model Files<br>EnergyPlus Compatible"]
GM_OUT["Geometric Model<br>Structural Data"]

RT --> GG
SP --> GG
EP --> GG
TP --> GG
GM --> IDM
GM --> GM_OUT

subgraph subGraph2 ["Output Models"]
    IDM
    GM_OUT
end

subgraph subGraph1 ["Input Parameters"]
    RT
    SP
    EP
    TP
end

subgraph subGraph0 ["GreenhouseGeometry System"]
    GG
    RF
    PG
    GM
    GG --> RF
    GG --> PG
    RF --> GM
    PG --> GM
end
```

**Sources**: [README.md L42](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L42-L42)

 [README.md L100-L159](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L100-L159)

## Supported Roof Types

The GreenhouseGeometry system supports six distinct roof configurations, each optimized for different structural, environmental, and economic requirements:

| Roof Type | Identifier | Characteristics |
| --- | --- | --- |
| Triangle | `triangle` | Simple peaked roof with linear slopes |
| Semi-circular | `half_circle` | Curved roof with semicircular profile |
| Flat Arch | `flat_arch` | Arched roof with flattened profile |
| Gothic Arch | `gothic_arch` | Pointed arch with traditional gothic profile |
| Sawtooth | `sawtooth` | Multiple triangular segments in sawtooth pattern |
| Sawtooth Arch | `sawtooth_arch` | Arched segments in sawtooth configuration |

```mermaid
flowchart TD

RT["roof_type parameter"]
T["triangle"]
HC["half_circle"]
FA["flat_arch"]
GA["gothic_arch"]
ST["sawtooth"]
STA["sawtooth_arch"]
GEN["Geometric Model Generation"]
STRUCT["Structural Parameters"]
OUTPUT["Generated Model"]

T --> GEN
HC --> GEN
FA --> GEN
GA --> GEN
ST --> GEN
STA --> GEN

subgraph subGraph2 ["Geometry Generation"]
    GEN
    STRUCT
    OUTPUT
    STRUCT --> GEN
    GEN --> OUTPUT
end

subgraph subGraph1 ["Roof Type Selection"]
    RT
    RT --> T
    RT --> HC
    RT --> FA
    RT --> GA
    RT --> ST
    RT --> STA

subgraph subGraph0 ["Available Types"]
    T
    HC
    FA
    GA
    ST
    STA
end
end
```

**Sources**: [README.md L113-L120](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L113-L120)

 [README.md L32](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L32-L32)

## Core Parameters

The GreenhouseGeometry class accepts a comprehensive set of parameters that define the structural, environmental, and temporal characteristics of the greenhouse model:

### Structural Parameters

```mermaid
flowchart TD

SM["start_month<br>Simulation start month"]
SD["start_day<br>Simulation start day"]
EM["end_month<br>Simulation end month"]
ED["end_day<br>Simulation end day"]
TS["time_step<br>Time step (minutes)"]
MIT["min_indoor_temp<br>Minimum indoor temperature (°C)"]
MAIT["max_indoor_temp<br>Maximum indoor temperature (°C)"]
MOT["min_outdoor_temp<br>Minimum outdoor temperature (°C)"]
MAOT["max_outdoor_temp<br>Maximum outdoor temperature (°C)"]
MDT["max_delta_temp<br>Maximum temperature difference (°C)"]
MWS["max_wind_speed<br>Maximum wind speed (m/s)"]
WH["wall_height<br>Ridge height (m)"]
WW["wall_width<br>Width of roof segment (m)"]
WL["wall_length<br>Greenhouse length (m)"]
NS["num_segments<br>Number of roof segments"]
SL["slope<br>Roof slope angle (degrees)"]
NL["number_length<br>Number of greenhouses in length"]
NW["number_width<br>Number of greenhouses in width"]

subgraph subGraph2 ["Temporal Parameters"]
    SM
    SD
    EM
    ED
    TS
end

subgraph subGraph1 ["Environmental Constraints"]
    MIT
    MAIT
    MOT
    MAOT
    MDT
    MWS
end

subgraph subGraph0 ["Structural Configuration"]
    WH
    WW
    WL
    NS
    SL
    NL
    NW
end
```

**Sources**: [README.md L125-L155](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L125-L155)

## Class Structure and Methods

The GreenhouseGeometry class follows a structured initialization and generation pattern:

```mermaid
flowchart TD

INIT["init()<br>Parameter initialization"]
CH["create_houses()<br>Main generation method"]
VP["validate_parameters()"]
GG["generate_geometry()"]
CM["create_model()"]
EF["export_files()"]
IP["Input Parameters"]
VP_PARAMS["Validated Parameters"]
GEO_MODEL["Geometry Model"]
OUTPUT_FILES["Output Files"]

IP --> INIT
VP --> VP_PARAMS
VP_PARAMS --> GG
GG --> GEO_MODEL
GEO_MODEL --> CM
EF --> OUTPUT_FILES

subgraph subGraph2 ["Parameter Flow"]
    IP
    VP_PARAMS
    GEO_MODEL
    OUTPUT_FILES
end

subgraph subGraph1 ["GreenhouseGeometry Class"]
    INIT
    CH
    INIT --> VP
    CH --> VP
    CH --> GG
    CH --> CM
    CH --> EF

subgraph subGraph0 ["Internal Methods"]
    VP
    GG
    CM
    EF
    CM --> EF
end
end
```

**Sources**: [README.md L134-L158](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L134-L158)

## Integration with Core Systems

The GreenhouseGeometry system integrates with other GreenLightPlus components through standardized interfaces:

```mermaid
flowchart TD

GG["GreenhouseGeometry<br>greenhouse_geometry.py"]
GLM["GreenLightModel<br>green_light_model.py"]
GS["GreenhouseSimulation<br>greenlight_energyplus_simulation.py"]
GE["GreenhouseEnv<br>greenhouse_env.py"]
EP["EnergyPlus<br>Building Simulation"]
IDF["IDF Files<br>Geometry Definitions"]
SP["Structural Parameters<br>aFlr, aCov, hAir, hGh"]
GM["Geometric Models<br>Roof configurations"]
BM["Building Models<br>Energy simulation"]

GG --> SP
GG --> GM
GG --> IDF
SP --> GLM
GM --> GS
GS --> EP
EP --> BM

subgraph subGraph3 ["Data Flow"]
    SP
    GM
    BM
end

subgraph subGraph2 ["External Systems"]
    EP
    IDF
    IDF --> EP
end

subgraph subGraph1 ["Core Systems"]
    GLM
    GS
    GE
    GLM --> GE
end

subgraph subGraph0 ["GreenhouseGeometry Integration"]
    GG
end
```

**Sources**: [README.md L42](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L42-L42)

 [README.md L188-L233](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L188-L233)

## Usage Patterns

The typical workflow for using GreenhouseGeometry involves parameter configuration, instantiation, and model generation:

```

```

**Sources**: [README.md L109-L159](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/README.md#L109-L159)

The GreenhouseGeometry system provides the foundational structural data that enables accurate environmental modeling and energy analysis throughout the GreenLightPlus simulation framework. By supporting multiple roof configurations and comprehensive parameter sets, it enables comparative analysis of different greenhouse designs and their impact on energy performance and crop yield.