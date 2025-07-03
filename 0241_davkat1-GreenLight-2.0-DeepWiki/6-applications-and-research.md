# Applications and Research

> **Relevant source files**
> * [readme.md](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md)

This document covers the research applications of the GreenLight platform and its role in supporting open science objectives in horticultural modeling. It explains how the platform facilitates transparent, reusable, and shareable research in dynamic modeling, particularly for greenhouse and crop systems.

For technical implementation details of the modeling framework, see [Model Architecture](/davkat1/GreenLight/2-model-architecture). For information about extending and modifying models for research purposes, see [Model Combination](/davkat1/GreenLight/2.3-model-combination).

## Research Applications in Horticulture

GreenLight serves as a comprehensive platform for horticultural research, enabling scientists to investigate complex interactions between greenhouse climate, crop growth, and energy systems. The platform's modular architecture supports various research applications ranging from climate optimization to crop yield analysis.

### Primary Research Domains

The platform supports research across multiple interconnected domains:

| Research Domain | Key Applications | Model Components |
| --- | --- | --- |
| Greenhouse Climate Control | HVAC optimization, energy efficiency | `greenhouse_vanthoor_2011_chapter_8.json` |
| Crop Growth Modeling | Yield prediction, growth optimization | `crop_vanthoor_2011_chapter_9_simplified.json` |
| LED Lighting Research | Energy-efficient lighting systems | `extension_greenhouse_katzin_2021_vanthoor_2011.json` |
| Environmental Impact | Resource utilization, sustainability | Combined model systems |

### Research Workflow Integration

```mermaid
flowchart TD

ResearchQ["Research Question"]
Literature["Literature Review"]
Hypothesis["Hypothesis Development"]
ModelSelect["Model Selection"]
ModelCustom["Model Customization"]
ExpDesign["Experimental Design"]
JSONModels["JSON Model Definitions"]
GreenLightMain["greenlight.main Entry Point"]
SimEngine["Simulation Engine"]
WeatherData["Weather Data Input"]
ExpParams["Experimental Parameters"]
ValidationData["Validation Datasets"]
ResultAnalysis["Statistical Analysis"]
Visualization["Data Visualization"]
Publication["Scientific Publication"]
OpenScience["Open Science Sharing"]

Hypothesis --> ModelSelect
ModelSelect --> JSONModels
ModelCustom --> JSONModels
ExpDesign --> GreenLightMain
WeatherData --> SimEngine
ExpParams --> SimEngine
ValidationData --> SimEngine
SimEngine --> ResultAnalysis
OpenScience --> Literature

subgraph subGraph4 ["Analysis and Publication"]
    ResultAnalysis
    Visualization
    Publication
    OpenScience
    ResultAnalysis --> Visualization
    Visualization --> Publication
    Publication --> OpenScience
end

subgraph subGraph3 ["Data Integration"]
    WeatherData
    ExpParams
    ValidationData
end

subgraph subGraph2 ["Model Implementation"]
    JSONModels
    GreenLightMain
    SimEngine
    JSONModels --> SimEngine
    GreenLightMain --> SimEngine
end

subgraph subGraph1 ["GreenLight Platform Integration"]
    ModelSelect
    ModelCustom
    ExpDesign
end

subgraph subGraph0 ["Research Question Formulation"]
    ResearchQ
    Literature
    Hypothesis
    ResearchQ --> Literature
    Literature --> Hypothesis
end
```

Sources: [readme.md L15-L18](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L15-L18)

 [readme.md L52-L61](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L61)

## Open Science Framework

GreenLight is explicitly designed as a tool for open science, promoting transparency, reproducibility, and collaboration in dynamic modeling research. The platform's architecture supports key open science principles through its modular design and transparent model definitions.

### Open Science Capabilities

The platform enables open science through several key mechanisms:

**Transparent Model Architecture**: All model definitions are stored in human-readable JSON format, allowing researchers to inspect, understand, and verify model implementations. The modular structure in [models/katzin_2021/definition/](https://github.com/davkat1/GreenLight/blob/089602e3/models/katzin_2021/definition/)

 provides complete transparency of model equations and parameters.

**Reproducible Research**: The platform's deterministic simulation engine and version-controlled model definitions ensure that research results can be exactly reproduced by other researchers using the same inputs and model configurations.

**Collaborative Development**: The active Discord community [readme.md L11-L12](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L11-L12)

 and open-source licensing [readme.md L8-L9](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L8-L9)

 facilitate collaborative research and knowledge sharing among users.

### Community Collaboration Model

```mermaid
flowchart TD

Researchers["Researchers"]
Students["Graduate Students"]
Industry["Industry Partners"]
Developers["Platform Developers"]
Discord["Discord Community"]
GitHub["GitHub Repository"]
Publications["Academic Publications"]
ModelSharing["Model Sharing"]
CodeContrib["Code Contributions"]
DataSharing["Data Sharing"]
Documentation["Documentation"]
PeerReview["Peer Review"]
Testing["Model Validation"]
Reproducibility["Reproducibility Checks"]

Researchers --> Discord
Students --> Discord
Industry --> GitHub
Developers --> GitHub
Discord --> ModelSharing
GitHub --> CodeContrib
Publications --> DataSharing
ModelSharing --> PeerReview
CodeContrib --> Testing
DataSharing --> Reproducibility

subgraph subGraph3 ["Quality Assurance"]
    PeerReview
    Testing
    Reproducibility
end

subgraph subGraph2 ["Knowledge Sharing"]
    ModelSharing
    CodeContrib
    DataSharing
    Documentation
    Documentation --> ModelSharing
end

subgraph subGraph1 ["Collaboration Platforms"]
    Discord
    GitHub
    Publications
end

subgraph subGraph0 ["Research Community"]
    Researchers
    Students
    Industry
    Developers
end
```

Sources: [readme.md L11-L12](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L11-L12)

 [readme.md L17-L18](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L17-L18)

 [readme.md L83-L87](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L83-L87)

## Academic Literature Integration

The GreenLight platform is built upon a solid foundation of peer-reviewed academic literature, ensuring that research conducted using the platform is grounded in established scientific knowledge. The integration of academic models into the platform demonstrates how theoretical frameworks can be translated into practical simulation tools.

### Literature-to-Code Mapping

The platform implements models directly from academic publications, maintaining traceability from theoretical concepts to executable code:

```mermaid
flowchart TD

Katzin2021["Katzin (2021): Energy Saving by LED Lighting"]
Vanthoor2011["Vanthoor (2011): Model-based Greenhouse Design"]
VanthoorCh8["Chapter 8: Greenhouse Model"]
VanthoorCh9["Chapter 9: Crop Model"]
KatzinCh7["Chapter 7: LED Extension"]
GreenhouseJSON["greenhouse_vanthoor_2011_chapter_8.json"]
CropJSON["crop_vanthoor_2011_chapter_9_simplified.json"]
LEDExtJSON["extension_greenhouse_katzin_2021_vanthoor_2011.json"]
ModelLoader["Model Definition Loader"]
SimulationCore["greenlight Package Core"]
MainEntry["greenlight.main Entry Point"]

Katzin2021 --> KatzinCh7
Vanthoor2011 --> VanthoorCh8
Vanthoor2011 --> VanthoorCh9
VanthoorCh8 --> GreenhouseJSON
VanthoorCh9 --> CropJSON
KatzinCh7 --> LEDExtJSON
GreenhouseJSON --> ModelLoader
CropJSON --> ModelLoader
LEDExtJSON --> ModelLoader

subgraph subGraph3 ["Code Implementation"]
    ModelLoader
    SimulationCore
    MainEntry
    ModelLoader --> SimulationCore
    SimulationCore --> MainEntry
end

subgraph subGraph2 ["JSON Model Files"]
    GreenhouseJSON
    CropJSON
    LEDExtJSON
end

subgraph subGraph1 ["Theoretical Chapters"]
    VanthoorCh8
    VanthoorCh9
    KatzinCh7
end

subgraph subGraph0 ["Academic Publications"]
    Katzin2021
    Vanthoor2011
end
```

### Academic Validation Process

The platform's academic foundations provide built-in validation through established research:

| Model Component | Academic Source | Validation Method | Implementation File |
| --- | --- | --- | --- |
| Greenhouse Climate | Vanthoor (2011) Ch. 8 | Experimental validation in thesis | `greenhouse_vanthoor_2011_chapter_8.json` |
| Crop Growth | Vanthoor (2011) Ch. 9 | Literature comparison and field data | `crop_vanthoor_2011_chapter_9_simplified.json` |
| LED Integration | Katzin (2021) Ch. 7 | Experimental greenhouse studies | `extension_greenhouse_katzin_2021_vanthoor_2011.json` |

Sources: [readme.md L52-L61](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L52-L61)

 [readme.md L48-L61](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L48-L61)

## Research Use Cases and Applications

The GreenLight platform supports diverse research applications across multiple scales and domains within horticultural science. These applications demonstrate the platform's flexibility and utility for addressing various research questions.

### Simulation-Based Research Applications

**Climate Optimization Studies**: Researchers use the platform to investigate optimal climate control strategies by modifying parameters in the greenhouse model and analyzing energy consumption patterns. The `python -m greenlight.main` interface allows for systematic parameter exploration.

**Crop Yield Optimization**: The integrated crop model enables researchers to study the relationship between environmental conditions and crop productivity, supporting precision agriculture research and sustainable production strategies.

**Energy Efficiency Research**: The LED extension model facilitates research into energy-efficient lighting systems, allowing researchers to quantify energy savings and assess economic viability of different lighting strategies.

### Research Methodology Integration

```mermaid
flowchart TD

FactorialDesign["Factorial Experiments"]
SensitivityAnalysis["Sensitivity Analysis"]
Optimization["Multi-objective Optimization"]
UncertaintyAnalysis["Uncertainty Quantification"]
ScriptingAPI["Python Scripting API"]
NotebookEnv["Jupyter Notebooks"]
BatchSimulation["Batch Processing"]
ParameterSpace["Parameter Space Exploration"]
StatisticalAnalysis["Statistical Analysis"]
DataVisualization["Visualization Tools"]
ModelComparison["Model Comparison"]
ResultValidation["Result Validation"]
ScientificReports["Scientific Reports"]
DataPublication["Data Publication"]
ModelArchiving["Model Archiving"]
ReproducibilityPackages["Reproducibility Packages"]

FactorialDesign --> ScriptingAPI
SensitivityAnalysis --> NotebookEnv
Optimization --> BatchSimulation
UncertaintyAnalysis --> ParameterSpace
ScriptingAPI --> StatisticalAnalysis
NotebookEnv --> DataVisualization
BatchSimulation --> ModelComparison
ParameterSpace --> ResultValidation
StatisticalAnalysis --> ScientificReports
DataVisualization --> DataPublication
ModelComparison --> ModelArchiving
ResultValidation --> ReproducibilityPackages

subgraph subGraph3 ["Output Generation"]
    ScientificReports
    DataPublication
    ModelArchiving
    ReproducibilityPackages
end

subgraph subGraph2 ["Analysis Tools"]
    StatisticalAnalysis
    DataVisualization
    ModelComparison
    ResultValidation
end

subgraph subGraph1 ["GreenLight Integration"]
    ScriptingAPI
    NotebookEnv
    BatchSimulation
    ParameterSpace
end

subgraph subGraph0 ["Experimental Design"]
    FactorialDesign
    SensitivityAnalysis
    Optimization
    UncertaintyAnalysis
end
```

### Research Output and Impact

The platform supports the complete research lifecycle from hypothesis formulation to publication and knowledge dissemination. The modular architecture and transparent model definitions enable researchers to:

* **Validate Theoretical Models**: Compare simulation results with experimental data to validate model accuracy
* **Explore Design Alternatives**: Systematically evaluate different greenhouse designs and control strategies
* **Quantify Trade-offs**: Analyze relationships between energy consumption, crop yield, and economic performance
* **Share Research Assets**: Distribute model definitions, simulation scripts, and datasets for reproducible research

Sources: [readme.md L43-L46](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L43-L46)

 [readme.md L76-L81](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L76-L81)

 [readme.md L17-L18](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L17-L18)

## Community and Collaborative Research

The GreenLight platform fosters a collaborative research ecosystem that connects researchers, students, industry professionals, and platform developers. This community-driven approach enhances research quality and accelerates scientific progress through shared knowledge and resources.

### Active Research Community

The platform maintains an active research community through multiple channels:

**Discord Community**: The [GreenLight Discord server](https://discord.gg/nr62yfVe) serves as the primary hub for real-time collaboration, where researchers can post questions, share ideas, and seek assistance with modeling challenges.

**Contributor Network**: The platform benefits from contributions by researchers from multiple institutions, including Wageningen University & Research and Université Laval, representing diverse expertise in greenhouse technology and crop modeling.

**Open Source Collaboration**: The BSD 3-Clause-Clear License ensures that research conducted using the platform can be freely shared and built upon by other researchers, promoting cumulative scientific progress.

### Research Infrastructure Support

The platform provides comprehensive infrastructure to support collaborative research activities:

| Infrastructure Component | Purpose | Location |
| --- | --- | --- |
| Example Notebooks | Research methodology demonstration | `notebooks/` |
| Analysis Scripts | Reproducible analysis workflows | `scripts/` |
| Model Repository | Shared model definitions | `models/` |
| Documentation | Research guidance and tutorials | `docs/` |

Sources: [readme.md L11-L12](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L11-L12)

 [readme.md L83-L87](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L83-L87)

 [readme.md L8-L9](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L8-L9)

 [readme.md L76-L81](https://github.com/davkat1/GreenLight/blob/089602e3/readme.md#L76-L81)