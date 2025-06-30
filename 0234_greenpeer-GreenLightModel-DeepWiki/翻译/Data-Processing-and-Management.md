# Data Processing and Management

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md)
> * [gl_model.py](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py)

This document covers the comprehensive data processing and management capabilities of the GreenLightModel system, including input data handling, parameter processing, and output generation. The system manages three primary data streams: weather inputs, simulation parameters, and model outputs, with sophisticated processing pipelines that bridge Python and MATLAB environments.

For detailed information about specific aspects: weather data processing is covered in [Weather Data and Input Processing](/greenpeer/GreenLightModel/5.1-weather-data-and-input-processing), parameter handling in [Parameter Management](/greenpeer/GreenLightModel/5.2-parameter-management), and output processing in [Output Processing and Energy Calculations](/greenpeer/GreenLightModel/5.3-output-processing-and-energy-calculations).

## Data Processing Architecture

The GreenLightModel system implements a multi-stage data processing pipeline that transforms raw inputs into structured simulation outputs through coordinated Python and MATLAB operations.

### Data Flow Pipeline

```mermaid
flowchart TD

A["EnergyPlus Weather Files<br>(.mat format)"]
B["Artificial Weather Generation<br>makeArtificialInput()"]
C["User Parameters<br>(Python dictionaries)"]
D["Weather Data Loading<br>cutEnergyPlusData()"]
E["Parameter Processing<br>update_params()"]
F["Data Format Conversion<br>numpy arrays"]
G["MATLAB Engine Interface<br>matlab.engine"]
H["GreenLight Model<br>createGreenLightModel()"]
I["Simulation Solver<br>ode15s solver"]
J["Resolution Change<br>changeRes()"]
K["JSON Conversion<br>glObjToJson()"]
L["Energy Calculations<br>calculate_energy_consumption()"]
M["File Storage<br>save_to_json()"]
N["Python Dictionary<br>Return to user"]

A --> D
B --> F
C --> E
G --> H
J --> K

subgraph subGraph3 ["Output Processing"]
    K
    L
    M
    N
    K --> L
    K --> M
    K --> N
    L --> N
end

subgraph subGraph2 ["MATLAB Execution"]
    H
    I
    J
    H --> I
    I --> J
end

subgraph subGraph1 ["Python Processing Layer"]
    D
    E
    F
    G
    D --> F
    E --> G
    F --> G
end

subgraph subGraph0 ["Input Processing"]
    A
    B
    C
end
```

**Sources:** [gl_model.py L89-L203](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L89-L203)

### Core Data Processing Classes

The system's data processing is centralized in the `GreenLightModel` class, which orchestrates all data transformations and manages the interaction between Python and MATLAB environments.

```mermaid
classDiagram
    class GreenLightModel {
        +eng: matlab.engine
        +current_folder: str
        +output_folder: str
        +run_green_light()
        +update_params()
        +calculate_energy_consumption()
        +makeArtificialInput()
        +co2ppm2dens()
        +day_light_sum()
        +save_to_json()
        +params_from_string()
        +formula_result()
    }
    class WeatherData {
        +timestamps: ndarray
        +radiation: ndarray
        +temperature: ndarray
        +humidity: ndarray
        +co2: ndarray
        +wind: ndarray
        +sky_temp: ndarray
        +soil_temp: ndarray
        +daily_rad_sum: ndarray
    }
    class ParameterDict {
        +p: dict
        +x: dict
        +val: various
        +formula: str
    }
    class SimulationOutput {
        +a: dict
        +c: dict
        +d: dict
        +p: dict
        +t: dict
        +u: dict
        +x: dict
    }
    GreenLightModel --> WeatherData : "processes"
    GreenLightModel --> ParameterDict : "updates"
    GreenLightModel --> SimulationOutput : "generates"
```

**Sources:** [gl_model.py L21-L566](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L21-L566)

## Data Types and Formats

The system handles multiple data formats and performs automatic conversions between Python and MATLAB representations.

### Weather Data Structure

Weather data follows a standardized 9-column matrix format:

| Column | Description | Units | Code Reference |
| --- | --- | --- | --- |
| 0 | Timestamps | datenum | `weather[:, 0]` |
| 1 | Solar radiation | W m⁻² | `weather[:, 1]` |
| 2 | Air temperature | °C | `weather[:, 2]` |
| 3 | Humidity | kg m⁻³ | `weather[:, 3]` |
| 4 | CO₂ concentration | kg m⁻³ | `weather[:, 4]` |
| 5 | Wind speed | m s⁻¹ | `weather[:, 5]` |
| 6 | Sky temperature | °C | `weather[:, 6]` |
| 7 | Soil temperature | °C | `weather[:, 7]` |
| 8 | Daily radiation sum | MJ m⁻² day⁻¹ | `weather[:, 8]` |

**Sources:** [gl_model.py L301-L311](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L301-L311)

 [gl_model.py L314-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L314-L329)

### Parameter Management System

Parameters are organized in a hierarchical dictionary structure with support for formula-based dependent parameters:

```mermaid
flowchart TD

F["update_params()"]
G["params_from_string()"]
H["formula_result()"]
I["setParam() (MATLAB)"]
J["setParamVal() (MATLAB)"]
A["initial_gl (dict)"]
B["p (parameters)"]
C["x (state variables)"]
D["Parameter Values"]
E["Formula Strings"]

subgraph subGraph1 ["Processing Functions"]
    F
    G
    H
    I
    J
    F --> G
    G --> H
    F --> I
    F --> J
end

subgraph subGraph0 ["Parameter Structure"]
    A
    B
    C
    D
    E
    A --> B
    A --> C
    B --> D
    C --> D
    D --> E
end
```

**Sources:** [gl_model.py L205-L242](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L205-L242)

 [gl_model.py L440-L478](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L440-L478)

## Data Processing Operations

### Weather Data Processing

The system supports both real weather data from EnergyPlus files and artificially generated weather patterns:

```markdown
# Real weather data loading
weather = self.eng.cutEnergyPlusData(
    firstDay,
    seasonLength,
    os.path.join(self.data_folder(), weatherInput + "EnergyPlus.mat")
)

# Artificial weather generation
weather = self.makeArtificialInput(5)  # 5 days
```

The `makeArtificialInput` method generates realistic weather patterns using sinusoidal functions for temperature and radiation cycles.

**Sources:** [gl_model.py L100-L104](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L100-L104)

 [gl_model.py L297-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L297-L329)

### Parameter Formula Evaluation

The system supports complex parameter formulas using `sympy` for mathematical expression parsing:

```python
def formula_result(self, param_dict, formula_str, para_list):
    kwargs = {para: param_dict[para] for para in para_list if para != "pi"}
    formula_expr = parse_expr(formula_str)
    return float(formula_expr.evalf(subs=kwargs))
```

**Sources:** [gl_model.py L458-L478](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L458-L478)

### Energy Consumption Calculations

The system performs sophisticated energy calculations using numerical integration:

```python
def calculate_energy_consumption(self, gl, *array_keys):
    # Combine multiple parameter arrays
    combined_array += array_n
    # Calculate using trapezoidal rule
    energy_consumption = np.trapz(combined_array[:, 1], time_sequence) / 1e6
```

**Sources:** [gl_model.py L244-L281](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L244-L281)

## File I/O and Data Persistence

The system manages multiple file formats for input and output operations:

### Input Data Sources

* **EnergyPlus files**: `.mat` format containing weather data
* **Parameter dictionaries**: Python dict structures
* **Configuration files**: JSON format for settings

### Output Data Formats

* **JSON files**: Complete simulation results via `save_to_json()`
* **MATLAB files**: Native `.mat` format via MATLAB engine
* **Python dictionaries**: In-memory access to all simulation data

### Data Folder Structure

```mermaid
flowchart TD

A["current_folder"]
B["GreenLight/"]
C["Output/"]
D["Code/inputs/energyPlus/data/"]
E["Weather Files<br>(.mat format)"]
F["Results<br>(.json, .mat)"]
G["data_folder()"]
H["default_output_folder()"]

G --> D
H --> C

subgraph subGraph1 ["Access Methods"]
    G
    H
end

subgraph subGraph0 ["Data Organization"]
    A
    B
    C
    D
    E
    F
    A --> B
    B --> C
    B --> D
    D --> E
    C --> F
end
```

**Sources:** [gl_model.py L287-L295](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L287-L295)

## Data Validation and Error Handling

The system implements several data validation mechanisms:

* **Weather data validation**: Automatic checking of matrix dimensions and data types
* **Parameter validation**: Type checking and formula syntax validation
* **Numerical stability**: Configurable tolerance values for ODE solvers
* **File existence checks**: Verification of input file availability

**Sources:** [gl_model.py L107-L129](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L107-L129)

 [gl_model.py L176-L181](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L176-L181)

The data processing and management system provides a robust foundation for greenhouse simulation by handling complex data transformations, maintaining data integrity, and supporting flexible input/output operations across Python and MATLAB environments.