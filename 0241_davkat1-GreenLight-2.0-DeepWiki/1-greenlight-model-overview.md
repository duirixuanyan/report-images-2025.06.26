# GreenLight Model Overview

> **Relevant source files**
> * [readme.md](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md)

## Purpose and Scope

GreenLight is a Python platform for creating, modifying, and combining dynamic models, with a focus on horticultural greenhouses and crops. The platform serves as a tool for **open science**, enabling transparent, reusable, and shareable research in dynamic modeling.

The platform enables researchers and practitioners to:

* Create and simulate dynamic greenhouse and crop models
* Combine existing models with extensions and modifications
* Implement models from academic literature in a standardized format
* Run location-specific simulations using weather data
* Share and reproduce modeling research transparently

Key capabilities include:

* JSON-based model definitions for transparency and modularity
* Integration of academic literature into executable models
* Command-line interface with interactive configuration
* Support for weather data integration
* Extensible architecture for custom model development

For installation instructions and system requirements, see [Installation and Requirements](/davkat1/GreenLight/1.1-installation-and-requirements). For details on the repository structure, see [Repository Structure](/davkat1/GreenLight/1.2-repository-structure).

Sources: [readme.md L2](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L2-L2)

 [readme.md L15-L18](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L15-L18)

## Platform Architecture

GreenLight is built on a modular Python architecture that separates model definitions, simulation engine, and user interfaces.

### Overall System Architecture

```mermaid
flowchart TD

CLI["python -m greenlight.main"]
DialogBox["Interactive Configuration Dialog"]
NotebookAPI["Jupyter Notebook Interface"]
ScriptAPI["Python Script API"]
GLPackage["greenlight/ Package"]
MainModule["greenlight.main"]
SimEngine["Simulation Engine"]
ModelLoader["JSON Model Loader"]
ModelsDir["models/ Directory"]
KatzinDef["models/katzin_2021/definition/"]
GreenhouseJSON["greenhouse_vanthoor_2011_chapter_8.json"]
CropJSON["crop_vanthoor_2011_chapter_9_simplified.json"]
ExtensionJSON["extension_greenhouse_katzin_2021_vanthoor_2011.json"]
WeatherData["Weather Data Input"]
UserConfig["User Configuration"]
ModelParams["Model Parameters"]
DocsDir["docs/ Directory"]
NotebooksDir["notebooks/ Directory"]
ScriptsDir["scripts/ Directory"]

CLI --> MainModule
DialogBox --> MainModule
NotebookAPI --> GLPackage
ScriptAPI --> GLPackage
ModelLoader --> ModelsDir
WeatherData --> SimEngine
UserConfig --> SimEngine
ModelParams --> SimEngine
GLPackage --> DocsDir
GLPackage --> NotebooksDir
GLPackage --> ScriptsDir

subgraph subGraph4 ["Documentation & Examples"]
    DocsDir
    NotebooksDir
    ScriptsDir
end

subgraph subGraph3 ["External Data"]
    WeatherData
    UserConfig
    ModelParams
end

subgraph subGraph2 ["Model Definitions"]
    ModelsDir
    KatzinDef
    GreenhouseJSON
    CropJSON
    ExtensionJSON
    ModelsDir --> KatzinDef
    KatzinDef --> GreenhouseJSON
    KatzinDef --> CropJSON
    KatzinDef --> ExtensionJSON
end

subgraph subGraph1 ["GreenLight Core Platform"]
    GLPackage
    MainModule
    SimEngine
    ModelLoader
    MainModule --> SimEngine
    SimEngine --> ModelLoader
end

subgraph subGraph0 ["User Interface Layer"]
    CLI
    DialogBox
    NotebookAPI
    ScriptAPI
end
```

Sources: [readme.md L33-L34](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L33-L34)

 [readme.md L76-L82](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L76-L82)

 [readme.md L56-L60](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L60)

## Academic Foundations

GreenLight implements models from established academic literature, providing a bridge between theoretical research and practical simulation tools.

### Literature to Implementation Mapping

```mermaid
flowchart TD

Katzin2021["Katzin (2021) Energy Saving by LED Lighting in Greenhouses"]
Vanthoor2011["Vanthoor (2011) A model-based greenhouse design method"]
Chapter8["Vanthoor Chapter 8: Greenhouse Model Theory"]
Chapter9["Vanthoor Chapter 9: Crop Model Theory"]
Chapter7["Katzin Chapter 7: LED Extension Theory"]
GreenhouseModel["greenhouse_vanthoor_2011_chapter_8.json"]
CropModel["crop_vanthoor_2011_chapter_9_simplified.json"]
LEDExtension["extension_greenhouse_katzin_2021_vanthoor_2011.json"]
KatzinDir["models/katzin_2021/definition/"]
VanthoorDir["models/katzin_2021/definition/vanthoor_2011/"]

Vanthoor2011 --> Chapter8
Vanthoor2011 --> Chapter9
Katzin2021 --> Chapter7
Chapter8 --> GreenhouseModel
Chapter9 --> CropModel
Chapter7 --> LEDExtension
GreenhouseModel --> VanthoorDir
CropModel --> VanthoorDir
LEDExtension --> KatzinDir

subgraph subGraph3 ["Implementation Directory"]
    KatzinDir
    VanthoorDir
end

subgraph subGraph2 ["JSON Model Files"]
    GreenhouseModel
    CropModel
    LEDExtension
end

subgraph subGraph1 ["Theoretical Components"]
    Chapter8
    Chapter9
    Chapter7
end

subgraph subGraph0 ["Academic Literature"]
    Katzin2021
    Vanthoor2011
end
```

The platform implements these models as JSON definitions that can be read, modified, and combined. Users are encouraged to read the original literature alongside the JSON files to understand the model structure and variables.

Sources: [readme.md L52-L61](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L61)

## Model Structure

GreenLight models are defined using JSON files that specify variables, constants, inputs, and equations in a standardized format.

### JSON Model Architecture

```mermaid
flowchart TD

ModelFile["Model JSON File"]
Variables["variables: Dynamic state elements"]
Constants["constants: Fixed parameters"]
Inputs["inputs: External forcing data"]
Equations["equations: Mathematical relationships"]
StateVars["State Variables: x.variable"]
AuxVars["Auxiliary Variables: a.variable"]
ControlVars["Control Variables: u.variable"]
DisturbVars["Disturbance Variables: d.variable"]
PhysicalParams["Physical Constants: p.parameter"]
ModelParams["Model Parameters: gl.parameter"]
InitialVals["Initial Values: x0.variable"]

Variables --> StateVars
Variables --> AuxVars
Variables --> ControlVars
Variables --> DisturbVars
Constants --> PhysicalParams
Constants --> ModelParams
Constants --> InitialVals

subgraph subGraph2 ["Parameter Types"]
    PhysicalParams
    ModelParams
    InitialVals
end

subgraph subGraph1 ["Model Categories"]
    StateVars
    AuxVars
    ControlVars
    DisturbVars
end

subgraph subGraph0 ["JSON Model Definition"]
    ModelFile
    Variables
    Constants
    Inputs
    Equations
    ModelFile --> Variables
    ModelFile --> Constants
    ModelFile --> Inputs
    ModelFile --> Equations
end
```

Each JSON model file contains structured definitions that can be combined with other models to create complex simulations. The naming conventions (x., a., u., d., p., gl.) provide clear categorization of model elements.

Sources: [readme.md L56-L61](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L56-L61)

 [readme.md L67-L68](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L67-L68)

## User Interface and Workflow

GreenLight provides multiple entry points for different user scenarios, from simple simulations to advanced model development.

### User Interaction Flow

```mermaid
flowchart TD

BasicUser["Basic User: Simple Simulation"]
LocationUser["Location User: Weather Data"]
ResearchUser["Research User: Model Analysis"]
DevUser["Developer: Platform Extension"]
CommandLine["python -m greenlight.main"]
DialogInterface["Interactive Dialog Box"]
NotebookInterface["Jupyter Notebooks"]
ScriptInterface["Python Scripts"]
ConfigDialog["Configuration Dialog"]
WeatherSetup["Weather Data Setup"]
ModelSelection["Model Selection"]
ParamAdjustment["Parameter Adjustment"]
ModelLoading["JSON Model Loading"]
SimulationRun["Simulation Execution"]
ResultsGeneration["Results Generation"]
Analysis["Data Analysis"]

BasicUser --> CommandLine
LocationUser --> CommandLine
ResearchUser --> NotebookInterface
DevUser --> ScriptInterface
DialogInterface --> ConfigDialog
ParamAdjustment --> ModelLoading
NotebookInterface --> ModelLoading
ScriptInterface --> ModelLoading

subgraph subGraph3 ["Execution Flow"]
    ModelLoading
    SimulationRun
    ResultsGeneration
    Analysis
    ModelLoading --> SimulationRun
    SimulationRun --> ResultsGeneration
    ResultsGeneration --> Analysis
end

subgraph subGraph2 ["Configuration Process"]
    ConfigDialog
    WeatherSetup
    ModelSelection
    ParamAdjustment
    ConfigDialog --> WeatherSetup
    WeatherSetup --> ModelSelection
    ModelSelection --> ParamAdjustment
end

subgraph subGraph1 ["Interface Methods"]
    CommandLine
    DialogInterface
    NotebookInterface
    ScriptInterface
    CommandLine --> DialogInterface
end

subgraph subGraph0 ["Entry Points"]
    BasicUser
    LocationUser
    ResearchUser
    DevUser
end
```

The primary entry point `python -m greenlight.main` launches an interactive dialog box for configuration, making the platform accessible to users without programming experience.

Sources: [readme.md L30-L37](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L30-L37)

 [readme.md L43-L46](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L43-L46)

## Data Flow and Processing

GreenLight processes multiple data sources through a structured pipeline from inputs to simulation results.

### Data Processing Pipeline

```mermaid
flowchart TD

WeatherData["Weather Data Files"]
UserInputs["User Configuration via Dialog"]
ModelDefs["JSON Model Definitions"]
DefaultParams["Default Parameters"]
MainModule["greenlight.main"]
ModelParser["JSON Model Parser"]
SimulationEngine["Dynamic Simulation Engine"]
DataValidator["Input Data Validator"]
VariableMapping["Variable Mapping"]
EquationSolver["Equation Solver"]
StateIntegration["State Integration"]
ControlLogic["Control Logic"]
TimeSeriesResults["Time Series Results"]
StateTrajectories["State Trajectories"]
ControlOutputs["Control Outputs"]
AnalysisData["Analysis Data"]

WeatherData --> DataValidator
UserInputs --> MainModule
ModelDefs --> ModelParser
DefaultParams --> ModelParser
ModelParser --> VariableMapping
ControlLogic --> TimeSeriesResults
StateIntegration --> StateTrajectories
ControlLogic --> ControlOutputs

subgraph subGraph3 ["Output Generation"]
    TimeSeriesResults
    StateTrajectories
    ControlOutputs
    AnalysisData
    StateTrajectories --> AnalysisData
end

subgraph subGraph2 ["Model Integration"]
    VariableMapping
    EquationSolver
    StateIntegration
    ControlLogic
    VariableMapping --> EquationSolver
    EquationSolver --> StateIntegration
    StateIntegration --> ControlLogic
end

subgraph subGraph1 ["greenlight Package Processing"]
    MainModule
    ModelParser
    SimulationEngine
    DataValidator
    MainModule --> SimulationEngine
    DataValidator --> SimulationEngine
end

subgraph subGraph0 ["Input Sources"]
    WeatherData
    UserInputs
    ModelDefs
    DefaultParams
end
```

Sources: [readme.md L39-L41](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L39-L41)

 [readme.md L71](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L71-L71)

## Repository Organization

The GreenLight repository follows a structured organization that separates platform code, model definitions, documentation, and examples.

### Repository Structure

| Directory | Purpose | Key Contents |
| --- | --- | --- |
| `greenlight/` | Core Python platform implementation | Main module, simulation engine, utilities |
| `models/` | JSON model definition files | Katzin 2021 models, Vanthoor 2011 models |
| `docs/` | Platform documentation | Installation, usage, model format guides |
| `notebooks/` | Example Jupyter notebooks | Interactive examples and tutorials |
| `scripts/` | Python example scripts | Command-line usage examples |

Sources: [readme.md L76-L82](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L76-L82)

### Data Flow in GreenLight

```mermaid
flowchart TD

A["Weather Data<br>(loadSelYearHiRes.m)"]
B["Model Inputs<br>(setGlInput.m)"]
C["GreenLight Model<br>(createGreenLightModel.m)"]
D["Simulation<br>(runScenarios/*.m)"]
E["Simulation Results"]
F["Post-Simulation Analysis"]
G["Energy Analysis<br>(energyAnalysis.m)"]
H["Visualization<br>(barEnergyFluxes.m)"]
I["Greenhouse Parameters<br>(setGlParams.m)"]
J["Lamp Parameters<br>(setDefaultLampParams.m)"]
K["Control Rules<br>(setGlControlRules.m)"]

A --> B
B --> C
C --> D
D --> E
E --> F
F --> G
F --> H
I --> C
J --> C
K --> C
```

This diagram shows how data flows through the GreenLight system, from inputs like weather data and parameters, through model creation and simulation, to results analysis.

Sources: [inputs/loadSelYearHiRes.m](https://github.com/davkat1/GreenLight/blob/089602e3/inputs/loadSelYearHiRes.m)

 [createGreenLightModel/setGlInput.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setGlInput.m)

 [createGreenLightModel/createGreenLightModel.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/createGreenLightModel.m)

 [runScenarios/exampleSimulation.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/exampleSimulation.m)

 [postSimAnalysis/energyAnalysis.m](https://github.com/davkat1/GreenLight/blob/089602e3/postSimAnalysis/energyAnalysis.m)

 [postSimAnalysis/barEnergyFluxes.m](https://github.com/davkat1/GreenLight/blob/089602e3/postSimAnalysis/barEnergyFluxes.m)

## Code Organization

The GreenLight codebase is organized into several key directories that handle different aspects of the model:

```mermaid
flowchart TD

A["GreenLight Repository"]
B["createGreenLightModel/"]
C["inputs/"]
D["postSimAnalysis/"]
E["runScenarios/"]
F["serviceFunctions/"]
B1["createGreenLightModel.m"]
B2["setGlParams.m"]
B3["setDefaultLampParams.m"]
B4["Other setup functions"]
C1["Reference year SEL2000/"]
C2["energyPlus/"]
C3["loadGreenhouseData.m"]
D1["energyAnalysis.m"]
D2["barEnergyFluxes.m"]
D3["plotTemps.m"]
E1["exampleSimulation.m"]
E2["runWorldSimulations.m"]
E3["evaluateClimateModel*.m"]
F1["Conversion functions"]
F2["Utility functions"]

A --> B
A --> C
A --> D
A --> E
A --> F
B --> B1
B --> B2
B --> B3
B --> B4
C --> C1
C --> C2
C --> C3
D --> D1
D --> D2
D --> D3
E --> E1
E --> E2
E --> E3
F --> F1
F --> F2
```

Sources: [readme.md L171-L244](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L171-L244)

## Connecting Model Concepts to Code

```mermaid
flowchart TD

A["Greenhouse Climate"]
A1["setGlOdes.m<br>(Climate ODEs)"]
A2["evaluateClimateModelHps.m/Led.m<br>(Climate Evaluation)"]
B["Energy Use"]
B1["energyAnalysis.m<br>(Energy Calculations)"]
B2["evaluateEnergyUseHps.m/Led.m<br>(Energy Evaluation)"]
C["Lighting Systems"]
C1["setDefaultLampParams.m<br>(Modern Lamps)"]
C2["setBleiswijk2010HpsParams.m<br>(HPS Configuration)"]
C3["setBleiswijk2010LedParams.m<br>(LED Configuration)"]
D["Control Systems"]
D1["setGlControlRules.m<br>(Control Logic)"]
D2["setGlControls.m<br>(Control Trajectories)"]
E["Simulation Scenarios"]
E1["exampleSimulation.m<br>(Basic Example)"]
E2["runWorldSimulations.m<br>(Global Comparison)"]
E3["heatByLightScript.m<br>(Heating by Light)"]

A --> A1
A --> A2
B --> B1
B --> B2
C --> C1
C --> C2
C --> C3
D --> D1
D --> D2
E --> E1
E --> E2
E --> E3
```

This diagram connects high-level greenhouse concepts to the specific code files that implement them, helping users navigate the codebase.

Sources: [createGreenLightModel/setGlOdes.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setGlOdes.m)

 [runScenarios/evaluateClimateModelHps.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateClimateModelHps.m)

 [runScenarios/evaluateClimateModelLed.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateClimateModelLed.m)

 [postSimAnalysis/energyAnalysis.m](https://github.com/davkat1/GreenLight/blob/089602e3/postSimAnalysis/energyAnalysis.m)

 [runScenarios/evaluateEnergyUseHps.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateEnergyUseHps.m)

 [runScenarios/evaluateEnergyUseLed.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateEnergyUseLed.m)

 [createGreenLightModel/setDefaultLampParams.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setDefaultLampParams.m)

 [createGreenLightModel/setBleiswijk2010HpsParams.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setBleiswijk2010HpsParams.m)

 [createGreenLightModel/setBleiswijk2010LedParams.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setBleiswijk2010LedParams.m)

 [createGreenLightModel/setGlControlRules.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setGlControlRules.m)

 [createGreenLightModel/setGlControls.m](https://github.com/davkat1/GreenLight/blob/089602e3/createGreenLightModel/setGlControls.m)

 [runScenarios/exampleSimulation.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/exampleSimulation.m)

 [runScenarios/runWorldSimulations.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/runWorldSimulations.m)

 [runScenarios/heatByLightScript.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/heatByLightScript.m)

## Usage Workflow

A typical workflow for using GreenLight includes:

1. **Model Creation**: Use `createGreenLightModel.m` to create a greenhouse model
2. **Parameter Configuration**: Set appropriate parameters for the greenhouse and lighting system
3. **Simulation Execution**: Run the model with specific weather data and conditions
4. **Results Analysis**: Analyze the results using the post-simulation tools

### Example Simulations

The repository provides several example simulations:

* `exampleSimulation.m` - Basic simulation with different lamp settings using Dutch reference year weather data
* `exampleSimulation2.m` - Simulation of a modern greenhouse with detailed configuration
* `exampleCropModel.m` - Simple example using only the crop component
* `runWorldSimulations.m` - Simulations across different global locations

Sources: [readme.md L106-L169](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L106-L169)

 [runScenarios/exampleSimulation.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/exampleSimulation.m)

 [runScenarios/exampleSimulation2.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/exampleSimulation2.m)

 [runScenarios/exampleCropModel.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/exampleCropModel.m)

 [runScenarios/runWorldSimulations.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/runWorldSimulations.m)

## Research Applications

GreenLight has been used in several published research studies:

1. **Climate Model Evaluation** (Katzin et al., 2020) * Comparing simulated and measured greenhouse climate data * Evaluating model performance for both HPS and LED lighting
2. **Energy Use Comparison** (Katzin et al., 2020) * Evaluating energy consumption differences between HPS and LED lighting * Validating model energy predictions against measured data
3. **Global Energy Savings Analysis** (Katzin et al., 2021) * Analyzing greenhouse performance across different world locations * Quantifying potential energy savings from transitioning to LED lighting
4. **Heating by Light Strategy Analysis** (Katzin et al., 2023) * Investigating using light not just for plant growth but as a heating strategy * Evaluating energy trade-offs and efficiency of different heating approaches

For more detailed information on these research applications, see [Applications and Research](/davkat1/GreenLight/6-applications-and-research).

Sources: [readme.md L27-L56](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L27-L56)

 [runScenarios/evaluateClimateModelHps.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateClimateModelHps.m)

 [runScenarios/evaluateClimateModelLed.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateClimateModelLed.m)

 [runScenarios/evaluateEnergyUseHps.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateEnergyUseHps.m)

 [runScenarios/evaluateEnergyUseLed.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/evaluateEnergyUseLed.m)

 [runScenarios/runWorldSimulations.m](https://github.com/davkat1/GreenLight/blob/089602e3/runScenarios/runWorldSimulations.m)

## Compatibility and Requirements

GreenLight is compatible with MATLAB 2015b and later versions. It requires the [DyMoMa package](https://github.com/davkat1/GreenLight/blob/089602e3/DyMoMa package)

 (specifically version 1.0.1) to function properly. For more details about installation and requirements, see [Installation and Requirements](/davkat1/GreenLight/1.1-installation-and-requirements).

Sources: [readme.md L13-L17](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L13-L17)