# Data Handling

> **Relevant source files**
> * [.gitignore](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore)
> * [readme.md](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md)

This document covers GreenLight's data handling architecture, including input data management, output generation, and privacy considerations. The platform processes weather data, model configurations, and simulation results while maintaining strict data privacy practices.

For specific guidance on weather data acquisition and usage, see [Weather Data](/davkat1/GreenLight/3.1-weather-data). For detailed data management practices and directory structures, see [Input and Output Data](/davkat1/GreenLight/3.2-input-and-output-data).

## Data Architecture Overview

GreenLight processes multiple data types through a structured pipeline that separates external data sources from the core simulation engine while maintaining privacy and reproducibility.

```mermaid
flowchart TD

WeatherSources["Weather Data Sources"]
UserConfig["User Configuration"]
ModelDefs["JSON Model Definitions"]
InputDataDir["input_data/ directories"]
DataDir["data/ directories"]
ModelsDir["models/ directory"]
MainEntry["greenlight.main"]
SimEngine["Simulation Engine"]
ModelLoader["Model Definition Loader"]
WeatherProcessor["Weather Data Processor"]
ConfigProcessor["Configuration Processor"]
ModelParser["JSON Model Parser"]
OutputDir["output/ directories"]
ResultsData["Simulation Results"]
AnalysisData["Analysis Outputs"]
GitIgnore[".gitignore exclusions"]
LocalOnly["Local-only data storage"]

WeatherSources --> InputDataDir
UserConfig --> ConfigProcessor
ModelDefs --> ModelsDir
InputDataDir --> WeatherProcessor
DataDir --> WeatherProcessor
ModelsDir --> ModelParser
WeatherProcessor --> SimEngine
ConfigProcessor --> MainEntry
ModelParser --> ModelLoader
SimEngine --> OutputDir
GitIgnore --> InputDataDir
GitIgnore --> DataDir
GitIgnore --> OutputDir
LocalOnly --> InputDataDir
LocalOnly --> DataDir
LocalOnly --> OutputDir

subgraph subGraph5 ["Privacy Controls"]
    GitIgnore
    LocalOnly
end

subgraph subGraph4 ["Output Layer"]
    OutputDir
    ResultsData
    AnalysisData
    OutputDir --> ResultsData
    OutputDir --> AnalysisData
end

subgraph subGraph3 ["Data Processing"]
    WeatherProcessor
    ConfigProcessor
    ModelParser
end

subgraph subGraph2 ["GreenLight Core"]
    MainEntry
    SimEngine
    ModelLoader
    MainEntry --> SimEngine
    ModelLoader --> SimEngine
end

subgraph subGraph1 ["Data Input Layer"]
    InputDataDir
    DataDir
    ModelsDir
end

subgraph subGraph0 ["External Data Sources"]
    WeatherSources
    UserConfig
    ModelDefs
end
```

Sources: [readme.md L40-L41](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L40-L41)

 [.gitignore L100-L113](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L100-L113)

## Data Types and Sources

The GreenLight platform handles several distinct data categories, each with specific handling requirements and storage patterns.

| Data Type | Source | Storage Location | Privacy Level |
| --- | --- | --- | --- |
| Weather Data | External APIs/Files | `data/`, `**/input_data/` | High - Location sensitive |
| Model Definitions | JSON Files | `models/` directory | Public - Version controlled |
| User Configuration | Dialog Interface | Runtime memory | Medium - User preferences |
| Simulation Results | Engine Output | `**/output/`, `output/` | Medium - Derived data |
| Analysis Outputs | Post-processing | `**/output/` | Medium - Derived data |

The platform distinguishes between **configuration data** (model definitions stored in version control) and **runtime data** (weather inputs and simulation outputs excluded from version control).

Sources: [.gitignore L100-L113](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L100-L113)

 [readme.md L77-L81](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L77-L81)

## Privacy and Security Considerations

GreenLight implements strict data privacy controls, recognizing that weather data can be location-sensitive and simulation results may contain proprietary information.

### Data Exclusion Strategy

The platform uses comprehensive `.gitignore` patterns to prevent sensitive data from entering version control:

```mermaid
flowchart TD

CodeBase["Source Code"]
ModelDefs["Model Definitions"]
Documentation["Documentation"]
Examples["Example Scripts"]
DataDirs["data/ directories"]
InputDataDirs["**/input_data/ directories"]
OutputDirs["**/output/ directories"]
ModelOutputs["/output/"]
GitIgnoreRules[".gitignore rules"]
LocalOnlyNote["Local-only storage"]
PrivacyComment["Privacy sensitive comment"]

GitIgnoreRules --> DataDirs
GitIgnoreRules --> InputDataDirs
GitIgnoreRules --> OutputDirs
GitIgnoreRules --> ModelOutputs
PrivacyComment --> DataDirs
LocalOnlyNote --> InputDataDirs
LocalOnlyNote --> OutputDirs

subgraph subGraph2 ["Privacy Controls"]
    GitIgnoreRules
    LocalOnlyNote
    PrivacyComment
end

subgraph subGraph1 ["Locally Excluded"]
    DataDirs
    InputDataDirs
    OutputDirs
    ModelOutputs
end

subgraph subGraph0 ["Version Controlled"]
    CodeBase
    ModelDefs
    Documentation
    Examples
end
```

The exclusion strategy includes an explicit privacy comment: *"do not upload data to git. Its slow and privacy sensitive"*.

Sources: [.gitignore L100-L103](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L100-L103)

### Exception Handling

While most data is excluded, the platform allows for controlled inclusion of demonstration data using Git's force-add mechanism: `git add -f data/...` for specific demo or dummy datasets.

Sources: [.gitignore L102](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L102-L102)

## Data Flow Process

The data handling process follows a structured pipeline from external sources through processing to final output, with privacy controls applied at each stage.

```mermaid
flowchart TD

WeatherFiles["Weather Data Files"]
UserDialog["Configuration Dialog"]
JSONModels["JSON Model Files"]
InputValidation["Input Validation"]
DataLoading["Data Loading"]
ModelParsing["Model Parsing"]
SimulationExecution["python -m greenlight.main"]
ResultGeneration["Result Generation"]
OutputStorage["Output Storage"]
DataAnalysis["Data Analysis"]
InputDataStorage["**/input_data/"]
DataStorage["data/"]
OutputStorage_["**/output/"]
ModelStorage["models/"]

WeatherFiles --> InputDataStorage
WeatherFiles --> DataStorage
JSONModels --> ModelStorage
InputDataStorage --> DataLoading
DataStorage --> DataLoading
ModelStorage --> ModelParsing
UserDialog --> InputValidation
SimulationExecution --> ResultGeneration
ResultGeneration --> OutputStorage_
OutputStorage_ --> DataAnalysis

subgraph subGraph3 ["Storage Locations"]
    InputDataStorage
    DataStorage
    OutputStorage_
    ModelStorage
end

subgraph subGraph2 ["Output Stage"]
    ResultGeneration
    OutputStorage
    DataAnalysis
end

subgraph subGraph1 ["Processing Stage"]
    InputValidation
    DataLoading
    ModelParsing
    SimulationExecution
    InputValidation --> SimulationExecution
    DataLoading --> SimulationExecution
    ModelParsing --> SimulationExecution
end

subgraph subGraph0 ["Input Stage"]
    WeatherFiles
    UserDialog
    JSONModels
end
```

The process ensures that sensitive input data never leaves the local environment while maintaining separation between configuration and runtime data.

Sources: [readme.md L31-L37](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L31-L37)

 [.gitignore L104-L113](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L104-L113)

## Directory Structure for Data

GreenLight employs a consistent directory structure that separates different data types while maintaining privacy boundaries.

### Standard Directory Pattern

```python
project_root/
├── data/                     # Excluded from version control
├── models/                   # Version controlled model definitions
├── **/input_data/           # Weather and input data (excluded)
│   └── .gitkeep            # Preserves directory structure
├── **/output/              # Simulation results (excluded) 
│   └── .gitkeep            # Preserves directory structure
└── output/                 # General output directory (excluded)
```

### Directory-Specific Handling

* **`data/` directories**: General data storage, privacy-sensitive, completely excluded
* **`**/input_data/` patterns**: Weather data and external inputs, excluded but structure preserved
* **`**/output/` patterns**: Model-specific outputs, excluded but structure preserved
* **`models/` directory**: JSON model definitions, version controlled and public
* **`.gitkeep` files**: Maintain directory structure in version control while excluding contents

The pattern `<model_name>/output/` provides model-specific output organization while maintaining consistent exclusion rules.

Sources: [.gitignore L103-L113](https://github.com/davkat1/GreenLight/blob/089602e3/.gitignore#L103-L113)