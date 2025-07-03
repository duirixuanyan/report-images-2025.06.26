# Model Architecture

> **Relevant source files**
> * [readme.md](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md)

## Purpose and Scope

This document describes the architecture of the GreenLight model system, focusing on its JSON-based model definitions, academic foundations, and system components. The GreenLight platform uses a modular approach where models are defined in JSON format and processed by the Python greenlight package to create dynamic simulations of greenhouse and crop systems.

## Architectural Overview

The GreenLight model architecture is built on JSON model definitions that encode academic literature into computable mathematical models. The system integrates greenhouse climate dynamics, crop growth models, and lighting extensions through a modular JSON-based approach that allows for transparent and reusable model definitions.

### JSON Model Architecture

JSON-based Model Definition Structure

```mermaid
flowchart TD

VanthoorGH["greenhouse_vanthoor_2011_chapter_8.json"]
VanthoorCrop["crop_vanthoor_2011_chapter_9_simplified.json"]
KatzinExt["extension_greenhouse_katzin_2021_vanthoor_2011.json"]
GLPackage["greenlight Python Package"]
MainEntry["greenlight.main"]
Variables["variables"]
Constants["constants"]
Inputs["inputs"]
Equations["equations"]

VanthoorGH --> Variables
VanthoorGH --> Constants
VanthoorGH --> Inputs
VanthoorGH --> Equations
VanthoorCrop --> Variables
VanthoorCrop --> Constants
VanthoorCrop --> Inputs
VanthoorCrop --> Equations
KatzinExt --> Variables
KatzinExt --> Constants
KatzinExt --> Inputs
KatzinExt --> Equations
Variables --> GLPackage
Constants --> GLPackage
Inputs --> GLPackage
Equations --> GLPackage

subgraph subGraph3 ["JSON Model Components"]
    Variables
    Constants
    Inputs
    Equations
end

subgraph greenlight/ ["greenlight/"]
    GLPackage
    MainEntry
    GLPackage --> MainEntry
end

subgraph models/katzin_2021/definition/ ["models/katzin_2021/definition/"]
    KatzinExt

subgraph vanthoor_2011/ ["vanthoor_2011/"]
    VanthoorGH
    VanthoorCrop
end
end
```

Sources: [readme.md L56-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L60)

### Model Processing Flow

```mermaid
flowchart TD

AcademicLit["Academic Literature<br>Katzin (2021), Vanthoor (2011)"]
JSONDefs["JSON Model Definitions<br>greehouse_vanthoor_2011_chapter_8.json<br>crop_vanthoor_2011_chapter_9_simplified.json<br>extension_greenhouse_katzin_2021_vanthoor_2011.json"]
GLPackage["greenlight Package<br>Model Processing Engine"]
SimEngine["Simulation Engine<br>Numerical Integration"]
Results["Simulation Results<br>Time Series Output"]
CLI["python -m greenlight.main"]
DialogBox["Configuration Dialog Box"]

AcademicLit --> JSONDefs
JSONDefs --> GLPackage
GLPackage --> SimEngine
SimEngine --> Results
CLI --> GLPackage
DialogBox --> GLPackage

subgraph subGraph0 ["User Interface"]
    CLI
    DialogBox
end
```

Sources: [readme.md L32-L37](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L32-L37)

 [readme.md L52-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L60)

## Academic Foundations

The GreenLight model architecture is built on established academic literature that provides the theoretical foundation for the mathematical models implemented in JSON format.

### Literature-to-Implementation Mapping

Academic Literature to JSON Model Implementation

```mermaid
flowchart TD

Vanthoor2011["Vanthoor (2011)<br>A model-based greenhouse design method"]
Katzin2021["Katzin (2021)<br>Energy Saving by LED Lighting in Greenhouses"]
Chapter8["Chapter 8<br>Greenhouse Model"]
Chapter9["Chapter 9<br>Crop Model"]
Chapter7["Chapter 7<br>LED Extension"]
GHJson["greenhouse_vanthoor_2011_chapter_8.json"]
CropJson["crop_vanthoor_2011_chapter_9_simplified.json"]
LEDJson["extension_greenhouse_katzin_2021_vanthoor_2011.json"]

Vanthoor2011 --> Chapter8
Vanthoor2011 --> Chapter9
Katzin2021 --> Chapter7
Chapter8 --> GHJson
Chapter9 --> CropJson
Chapter7 --> LEDJson

subgraph subGraph2 ["JSON Model Files"]
    GHJson
    CropJson
    LEDJson
end

subgraph subGraph1 ["Theoretical Chapters"]
    Chapter8
    Chapter9
    Chapter7
end

subgraph subGraph0 ["Academic Literature"]
    Vanthoor2011
    Katzin2021
end
```

Sources: [readme.md L52-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L60)

### Model Component Structure

The JSON model definitions follow a consistent structure that encodes the academic models into computable form:

| Component | Description | JSON Elements |
| --- | --- | --- |
| **variables** | Dynamic state variables that change over time | Temperature, humidity, CO2, biomass |
| **constants** | Fixed parameters and physical properties | Heat transfer coefficients, geometries |
| **inputs** | External forcing variables | Weather data, control signals |
| **equations** | Mathematical relationships between variables | ODEs, algebraic equations |

Sources: [readme.md L56-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L60)

## Core Model Components

### Greenhouse Model (Vanthoor 2011 Chapter 8)

The greenhouse component models the physical greenhouse structure and climate dynamics, implemented in `greenhouse_vanthoor_2011_chapter_8.json`:

Greenhouse Model Structure

```mermaid
flowchart TD

SolarRad["Solar Radiation<br>PAR, NIR, FIR"]
HeatFlows["Heat Flows<br>Convection, radiation"]
EnergyStore["Energy Storage<br>Thermal mass"]
Ventilation["Ventilation<br>Roof/side vents"]
Screens["Screens<br>Thermal/blackout"]
Structure["Structure<br>Cover, floor"]
TempDyn["Temperature Dynamics<br>Air compartments"]
HumidDyn["Humidity Dynamics<br>Vapor pressure"]
CO2Dyn["CO2 Dynamics<br>Concentration"]

subgraph greenhouse_vanthoor_2011_chapter_8.json ["greenhouse_vanthoor_2011_chapter_8.json"]

subgraph subGraph2 ["Energy Balance"]
    SolarRad
    HeatFlows
    EnergyStore
end

subgraph subGraph1 ["Physical Structure"]
    Ventilation
    Screens
    Structure
end

subgraph subGraph0 ["Climate Dynamics"]
    TempDyn
    HumidDyn
    CO2Dyn
end
end
```

Sources: [readme.md L56-L57](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L57)

### Crop Model (Vanthoor 2011 Chapter 9)

The crop component models plant growth and physiological processes, implemented in `crop_vanthoor_2011_chapter_9_simplified.json`:

Crop Model Structure

```mermaid
flowchart TD

Carbohydrates["Carbohydrate Buffer<br>Assimilate pool"]
Partitioning["Partitioning<br>Leaf, stem, fruit"]
Respiration["Maintenance Respiration<br>Temperature dependent"]
StomatalCond["Stomatal Conductance<br>VPD, CO2, light"]
WaterUptake["Water Uptake<br>Root system"]
EnergyBalance["Energy Balance<br>Latent heat"]
LightResp["Light Response<br>PAR utilization"]
CO2Resp["CO2 Response<br>Carboxylation"]
TempResp["Temperature Response<br>Enzyme kinetics"]

subgraph crop_vanthoor_2011_chapter_9_simplified.json ["crop_vanthoor_2011_chapter_9_simplified.json"]

subgraph subGraph2 ["Growth Development"]
    Carbohydrates
    Partitioning
    Respiration
end

subgraph Transpiration ["Transpiration"]
    StomatalCond
    WaterUptake
    EnergyBalance
end

subgraph Photosynthesis ["Photosynthesis"]
    LightResp
    CO2Resp
    TempResp
end
end
```

Sources: [readme.md L59](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L59-L59)

### LED Extension (Katzin 2021)

The LED extension adds supplemental lighting capabilities, implemented in `extension_greenhouse_katzin_2021_vanthoor_2011.json`:

LED Extension Structure

```mermaid
flowchart TD

LightControls["Light Controls<br>On/off, dimming"]
HeatIntegration["Heat Integration<br>Energy balance"]
CropResponse["Crop Response<br>Photosynthesis enhancement"]
PAROutput["PAR Output<br>Photosynthetic radiation"]
NIROutput["NIR Output<br>Near-infrared radiation"]
HeatOutput["Heat Output<br>Convective, radiative"]
LEDProps["LED Properties<br>Efficiency, spectrum"]
HPSProps["HPS Properties<br>Efficiency, spectrum"]
LampGeometry["Lamp Geometry<br>Toplights, interlights"]

subgraph extension_greenhouse_katzin_2021_vanthoor_2011.json ["extension_greenhouse_katzin_2021_vanthoor_2011.json"]

subgraph subGraph2 ["Control Integration"]
    LightControls
    HeatIntegration
    CropResponse
end

subgraph subGraph1 ["Light Distribution"]
    PAROutput
    NIROutput
    HeatOutput
end

subgraph subGraph0 ["Lamp Characteristics"]
    LEDProps
    HPSProps
    LampGeometry
end
end
```

Sources: [readme.md L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L60-L60)

## Structure Integration and Data Flow

The GreenLight model integrates the above components in a unified structure, where changes in one component affect others through a network of ordinary differential equations (ODEs).

### Data Flow Diagram

```mermaid
flowchart TD

WeatherData["Weather Data<br>- Global Radiation<br>- Temperature<br>- Humidity<br>- CO2<br>- Wind<br>- Sky Temperature"]
InputSet["setGlInput"]
Parameters["Parameter Set<br>- Physical Constants<br>- Geometry<br>- Materials<br>- Control Settings"]
ParamSet["setGlParams"]
Controls["Control Inputs/Rules<br>- Heating<br>- Ventilation<br>- Screens<br>- Lamps"]
ControlSet["setGlControls/setGlControlRules"]
ModelInstance["GreenLight Model Instance"]
ODEsystem["ODE System<br>- Climate Dynamics<br>- Crop Growth<br>- Energy Flows"]
Solver["DyMoMa Solver"]
Results["Simulation Results"]
Climate["Climate Outputs<br>- Indoor Temperature<br>- Humidity<br>- CO2"]
Crop["Crop Outputs<br>- Photosynthesis<br>- Growth<br>- Yield"]
Energy["Energy Outputs<br>- Heating<br>- Lighting<br>- Total Energy Use"]

WeatherData --> InputSet
Parameters --> ParamSet
Controls --> ControlSet
InputSet --> ModelInstance
ParamSet --> ModelInstance
ControlSet --> ModelInstance
ModelInstance --> ODEsystem
ODEsystem --> Solver
Solver --> Results
Results --> Climate
Results --> Crop
Results --> Energy
```

Sources: [Code/createGreenLightModel/createGreenLightModel.m L73-L128](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L73-L128)

## State Variables

The GreenLight model uses a state-based approach, where the condition of the greenhouse is described by a set of state variables that evolve over time according to the ODEs.

### Key State Variables

| Category | State Variables | Description |
| --- | --- | --- |
| Climate | `tAir`, `tTop`, `vpAir`, `vpTop`, `co2Air`, `co2Top` | Temperature, vapor pressure, and CO2 concentration in the main and top compartments |
| Structure | `tCov`, `tThScr`, `tBlScr`, `tCanE`, `tCanI` | Temperatures of cover, screens, and canopy (external and internal) |
| Heating | `tPipe`, `tGroPipe` | Pipe rail and grow pipe temperatures |
| Lighting | `tLamp`, `tIntLamp` | Top and interlight lamp temperatures |
| Soil | `tFlr`, `tSo1`-`tSo5` | Floor and soil layer temperatures |
| Crop | `cBuf`, `cFruit`, `cLeaf`, `cStem` | Carbohydrate buffer and dry weight of plant components |

Sources: [Code/createGreenLightModel/createGreenLightModel.m L80](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L80-L80)

## Control Systems

The GreenLight model supports two different approaches to controlling the greenhouse environment:

### Rule-Based Control

When no control trajectory is provided, the model uses rule-based control that mimics typical greenhouse climate control strategies:

* Heating control based on temperature setpoints
* Ventilation based on temperature and humidity
* Screen control based on outside conditions and humidity
* Lighting control based on time, radiation, and temperature

```mermaid
flowchart TD

Sensors["Sensor Values<br>- Indoor Temperature<br>- Humidity<br>- CO2<br>- Outdoor Conditions"]
DecisionLogic["Decision Logic<br>- Setpoints<br>- P-bands<br>- Rules"]
Actuators["Actuator Controls<br>- Heating<br>- Ventilation<br>- Screens<br>- Lamps<br>- CO2 Dosing"]

subgraph subGraph0 ["Rule-Based Control"]
    Sensors
    DecisionLogic
    Actuators
    Sensors --> DecisionLogic
    DecisionLogic --> Actuators
end
```

Sources: [Code/createGreenLightModel/createGreenLightModel.m L122-L124](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L122-L124)

 [Code/createGreenLightModel/setGlParams.m L323-L368](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L323-L368)

### Trajectory-Based Control

When control trajectories are provided, the model follows these predefined control actions:

* Time series for screen positions
* Time series for ventilation openings
* Time series for pipe temperatures
* Time series for lamp operation
* Time series for CO2 injection

```mermaid
flowchart TD

TimeValues["Time Series<br>of Control Values"]
Interpolation["Interpolation<br>at Simulation Time"]
Actuators["Actuator Controls<br>- Heating<br>- Ventilation<br>- Screens<br>- Lamps<br>- CO2 Dosing"]

subgraph subGraph0 ["Trajectory-Based Control"]
    TimeValues
    Interpolation
    Actuators
    TimeValues --> Interpolation
    Interpolation --> Actuators
end
```

Sources: [Code/createGreenLightModel/createGreenLightModel.m L85-L116](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L85-L116)

## Model Creation Process

The creation of a GreenLight model follows a well-defined process managed by the `createGreenLightModel` function:

1. **Create base DynamicModel**: Instantiate a new model object from DyMoMa
2. **Set parameters**: Define physical constants and greenhouse properties
3. **Set inputs**: Configure the weather data inputs
4. **Define time**: Set simulation time range and step size
5. **Define controls**: Set up control variables (heating, ventilation, screens, etc.)
6. **Define states**: Create state variables for temperatures, humidity, CO2, etc.
7. **Set lamp parameters**: Configure according to lamp type (HPS, LED, none)
8. **Set control method**: Either rule-based or trajectory-based
9. **Set auxiliary states**: Define derived variables
10. **Set ODEs**: Define the differential equations for state evolution
11. **Set initial values**: Initialize all state variables

This process creates a complete model instance ready for simulation.

Sources: [Code/createGreenLightModel/createGreenLightModel.m L1-L128](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/createGreenLightModel.m#L1-L128)

## Parameter Categories

The model includes over 200 parameters organized into functional categories:

### General Model Parameters

Physical constants, heat transfer coefficients, and optical properties affecting the entire model.

Sources: [Code/createGreenLightModel/setGlParams.m L45-L104](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L45-L104)

### Location and Structure Parameters

Parameters for greenhouse geometry, construction, and geographical location.

Sources: [Code/createGreenLightModel/setGlParams.m L106-L131](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L106-L131)

### Component-Specific Parameters

Parameters for specific greenhouse components such as:

* Roof, floor, and soil
* Heating systems (pipe rail and grow pipes)
* Screens (thermal, blackout, shadow)
* Lamps (toplights and interlights)

Sources: [Code/createGreenLightModel/setGlParams.m L132-L223](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L132-L223)

 [Code/createGreenLightModel/setGlParams.m L369-L419](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L369-L419)

### Crop Parameters

Parameters related to photosynthesis, growth, and development.

Sources: [Code/createGreenLightModel/setGlParams.m L273-L322](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L273-L322)

### Control Parameters

Setpoints and bands for climate control strategies.

Sources: [Code/createGreenLightModel/setGlParams.m L323-L368](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L323-L368)

## Advanced Features

The GreenLight model includes several advanced features that extend its capabilities:

### Multi-Span Modeling

The model can represent multi-span greenhouses with appropriate scaling of parameters.

### Multiple Climate Zones

Separate top and main compartments with air exchange between them.

### Supplemental Lighting Options

Support for both top-lighting and inter-lighting with different technologies.

### Heat Harvesting

Modeling of heat buffers for storing excess heat for later use.

Sources: [Code/createGreenLightModel/setGlParams.m L422-L425](https://github.com/davkat1/GreenLight/blob/089602e3/Code/createGreenLightModel/setGlParams.m#L422-L425)

## Summary

The GreenLight model architecture integrates climate, crop, energy, and lighting components in a comprehensive greenhouse simulation framework. Its modular structure allows for flexible configuration of different greenhouse designs and control strategies, making it a powerful tool for research on greenhouse energy efficiency, particularly for comparing different lighting technologies.