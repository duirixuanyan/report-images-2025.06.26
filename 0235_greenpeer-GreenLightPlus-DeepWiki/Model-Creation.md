# Model Creation

> **Relevant source files**
> * [create_green_light_model/create_green_light_model.py](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py)
> * [create_green_light_model/set_gl_params.py](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_params.py)
> * [create_green_light_model/set_gl_states.py](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_states.py)

This document covers the components responsible for initializing and configuring the GreenLight model structure. The model creation system transforms input parameters and weather data into a fully configured GreenLight model instance ready for simulation. For information about using the created model in simulations, see [GreenLightModel](/greenpeer/GreenLightPlus/2.1-greenlightmodel). For details about configuring advanced model settings, see [Model Configuration](/greenpeer/GreenLightPlus/3.3-model-configuration).

## Overview

The model creation system provides the foundational layer that assembles all necessary components into a coherent GreenLight model instance. The system consists of a main orchestration function and specialized parameter-setting modules that configure different aspects of the greenhouse simulation model.

### Model Creation Workflow

```mermaid
flowchart TD

INPUT["Input Parameters<br>lampType, weather, controls, indoor"]
MAIN["create_green_light_model()"]
INIT["Initialize Model Dictionary<br>{'x': {}, 'a': {}, 'd': {}, 'p': {}, 'u': {}}"]
PARAMS["set_gl_params()<br>Physical and System Parameters"]
WEATHER["set_gl_weather()<br>Weather Input Data"]
TIME["set_gl_time()<br>Time Phase Configuration"]
LAMP["set_default_lamp_params()<br>Lighting System Parameters"]
CONTROL["set_gl_control_init()<br>Initial Control Values"]
STATES["set_gl_states_init()<br>Initial State Values"]
OUTPUT["Configured GreenLight Model<br>Ready for Simulation"]

INPUT --> MAIN
MAIN --> INIT
INIT --> PARAMS
PARAMS --> WEATHER
WEATHER --> TIME
TIME --> LAMP
LAMP --> CONTROL
CONTROL --> STATES
STATES --> OUTPUT
```

Sources: [create_green_light_model/create_green_light_model.py L34-L88](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py#L34-L88)

## Model Structure

The GreenLight model is organized as a dictionary with five main sections that contain different types of data and parameters.

### Model Dictionary Architecture

```mermaid
flowchart TD

GL["GreenLight Model Dictionary"]
X["x: State Variables<br>Dynamic simulation states"]
A["a: Auxiliary Variables<br>Calculated intermediate values"]
D["d: Disturbance Variables<br>Weather and external inputs"]
P["p: Parameters<br>Physical and system constants"]
U["u: Control Variables<br>Control system inputs"]
XSUB["tAir, tCan, co2Air<br>vpAir, cBuf, cLeaf<br>cStem, cFruit, etc."]
DSUB["Weather Time Series<br>Temperature, Humidity<br>Radiation, Wind"]
PSUB["Physical Constants<br>Material Properties<br>System Dimensions"]
USUB["Heating, Ventilation<br>CO2 Supply, Lighting<br>Screen Controls"]

GL --> X
GL --> A
GL --> D
GL --> P
GL --> U
X --> XSUB
D --> DSUB
P --> PSUB
U --> USUB
```

Sources: [create_green_light_model/create_green_light_model.py L60](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py#L60-L60)

 [create_green_light_model/set_gl_states.py L40-L135](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_states.py#L40-L135)

## Parameter Configuration

The parameter configuration system sets hundreds of physical, thermodynamic, and system-specific parameters required for accurate greenhouse simulation.

### Parameter Categories

| Category | Purpose | Key Parameters | Lines |
| --- | --- | --- | --- |
| Physical Constants | Fundamental physics | `sigma`, `g`, `R` | [set_gl_params.py L33-L37](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L33-L37) |
| Thermodynamic | Heat and mass transfer | `L`, `gamma`, `cPAir` | [set_gl_params.py L39-L46](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L39-L46) |
| Radiation | Light interaction | `etaGlobNir`, `k1Par`, `kFir` | [set_gl_params.py L47-L58](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L47-L58) |
| Material Properties | Substance characteristics | `rhoAir0`, `rhoSteel`, `mWater` | [set_gl_params.py L60-L67](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L60-L67) |
| Construction | Greenhouse structure | `aFlr`, `aCov`, `hAir` | [set_gl_params.py L96-L108](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L96-L108) |
| Canopy | Plant properties | `alfaLeafAir`, `rSMin`, `laiMax` | [set_gl_params.py L69-L75](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L69-L75) <br>  [set_gl_params.py L256-L287](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L256-L287) |
| Control | System operation | `tSpDay`, `co2SpDay`, `rhMax` | [set_gl_params.py L301-L335](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/set_gl_params.py#L301-L335) |

### Parameter Setting Process

```mermaid
flowchart TD

START["GreenLightParams.init()"]
PHYS["set_physical_constants()<br>Stefan-Boltzmann, gravity, gas constant"]
THERMO["set_thermodynamic_params()<br>Latent heat, specific heat capacities"]
RAD["set_radiation_params()<br>PAR/NIR ratios, extinction coefficients"]
MAT["set_material_properties()<br>Densities, molar masses"]
CANOPY["set_canopy_params()<br>Heat exchange, transpiration resistance"]
SOIL["set_soil_params()<br>Layer thicknesses, thermal properties"]
CONSTRUCT["set_construction_properties()<br>Areas, heights, heat exchange"]
VENT["set_ventilation_properties()<br>Areas, discharge coefficients"]
HEAT["set_heating_system_properties()<br>Pipe properties, boiler capacity"]
CONTROL["set_control_params()<br>Setpoints, dead zones, P-bands"]
CALC["set_heating_pipe_params()<br>set_air_density_params()<br>set_heat_capacity_params()"]

START --> PHYS
PHYS --> THERMO
THERMO --> RAD
RAD --> MAT
MAT --> CANOPY
CANOPY --> SOIL
SOIL --> CONSTRUCT
CONSTRUCT --> VENT
VENT --> HEAT
HEAT --> CONTROL
CONTROL --> CALC
```

Sources: [create_green_light_model/set_gl_params.py L394-L427](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_params.py#L394-L427)

## State Initialization

The state initialization system prepares all dynamic variables that will be tracked during simulation.

### State Variable Categories

```mermaid
flowchart TD

STATES["GreenLight Model States"]
ENV["Environmental States"]
CROP["Crop States"]
CO2["CO2 Concentrations<br>co2Air, co2Top"]
TEMP["Temperatures<br>tAir, tTop, tCan<br>tCovIn, tFlr, tPipe<br>tSo1-tSo5"]
VP["Vapor Pressures<br>vpAir, vpTop"]
TIME["Time Variables<br>time, tCan24"]
EQUIP["Equipment Temperatures<br>tLamp, tGroPipe<br>tIntLamp, tBlScr, tThScr"]
CARB["Carbohydrates<br>cBuf, cLeaf<br>cStem, cFruit"]
DEV["Development<br>tCanSum"]

STATES --> ENV
STATES --> CROP
ENV --> CO2
ENV --> TEMP
ENV --> VP
ENV --> TIME
ENV --> EQUIP
CROP --> CARB
CROP --> DEV
```

Sources: [create_green_light_model/set_gl_states.py L40-L135](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_states.py#L40-L135)

## Integration with System Components

The model creation system interfaces with other major system components to provide a complete simulation framework.

### Component Dependencies

```mermaid
flowchart TD

MC["Model Creation<br>create_green_light_model"]
SF["Service Functions<br>Weather Processing"]
GLM["GreenLightModel<br>ODE Solver"]
GE["GreenhouseEnv<br>RL Environment"]
GS["GreenhouseSimulation<br>EnergyPlus Integration"]

SF --> MC
MC --> GLM
MC --> GE
MC --> GS
MC --> GLM
MC --> GE
MC --> GS
```

Sources: [create_green_light_model/create_green_light_model.py L25-L31](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py#L25-L31)

## Usage Patterns

The model creation system supports different usage scenarios depending on the simulation requirements.

### Basic Model Creation

The primary entry point is the `create_green_light_model()` function which accepts:

* `lampType`: String specifying lamp technology (`'hps'`, `'led'`, or `''`)
* `weather`: Numerical array with weather time series data
* `controls`: Optional control trajectory data
* `indoor`: Optional indoor condition specifications

Sources: [create_green_light_model/create_green_light_model.py L34-L51](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py#L34-L51)

### Model Validation

The system includes parameter validation and initialization checks to ensure model consistency:

* Weather data format validation with expected columns
* Lamp type validation against supported options
* Parameter dependency calculations for derived values
* State array initialization with proper dimensions

Sources: [create_green_light_model/create_green_light_model.py L54-L57](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/create_green_light_model.py#L54-L57)

 [create_green_light_model/set_gl_params.py L216-L255](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/set_gl_params.py#L216-L255)