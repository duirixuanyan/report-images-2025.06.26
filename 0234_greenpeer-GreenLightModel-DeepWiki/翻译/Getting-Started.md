# Getting Started

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md)
> * [main.py](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py)

This document provides a quick start guide for using the GreenLightModel system to run greenhouse simulations. It covers installation, basic usage patterns, and a simple working example. The GreenLightModel is a Python wrapper that interfaces with MATLAB-based greenhouse simulation models, allowing you to run complex environmental simulations and energy calculations from Python code.

For detailed information about the core Python classes and their methods, see [Core Python Components](/greenpeer/GreenLightModel/3-core-python-components). For advanced configuration and system extension, see [Advanced Topics](/greenpeer/GreenLightModel/7-advanced-topics).

## Prerequisites

Before using GreenLightModel, you need to have the following components installed and properly configured:

### Required Software

| Component | Version | Purpose |
| --- | --- | --- |
| MATLAB | R2016b or later | Core simulation engine |
| Python | 3.6+ | Wrapper interface |
| MATLAB Engine API | Latest | Python-MATLAB bridge |

### Required MATLAB Models

The system depends on three MATLAB repositories that must be available:

* **GreenLight**: Core greenhouse simulation model
* **DyMoMa**: Dynamic modeling framework
* **GreenLight_Extensions**: JSON utilities and parameter extensions

Sources: [README.md L60-L67](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L60-L67)

## Installation

### Method 1: Recommended Installation

Clone the repository and install Python dependencies:

```
git clone https://github.com/greenpeer/GreenLightModel
cd GreenLightModel
pip install -r requirements.txt
```

### Method 2: Manual Setup

If you need to manually configure the MATLAB dependencies:

```markdown
# Clone required MATLAB repositories
git clone https://github.com/davkat1/GreenLight.git
git clone https://github.com/davkat1/DyMoMa.git
git clone https://github.com/greenpeer/GreenLight_Extensions.git

# Install Python dependencies
pip install -r requirements.txt

# Install MATLAB Engine API
python -m pip install matlabengine
```

Place all repositories in the same parent directory for automatic path resolution.

Sources: [README.md L34-L79](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L34-L79)

## Basic Usage Workflow

The following diagram shows the typical workflow for using GreenLightModel:

**GreenLightModel Usage Workflow**

```

```

Sources: [main.py L1-L48](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L1-L48)

 [README.md L85-L108](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L85-L108)

## Quick Start Example

Here's a minimal working example that demonstrates the core functionality:

**Basic Simulation Setup**

```

```

The basic usage pattern follows this structure from [main.py L1-L48](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L1-L48)

:

```javascript
from gl_model import GreenLightModel

# 1. Create model instance
model = GreenLightModel()

# 2. Configure initial parameters
gl = {
    "p": {
        "tSpNight": 28.5,  # temperature set point dark period [°C]
        "tSpDay": 29.5,    # temperature set point light period [°C]
    }
}

# 3. Run simulation
gl = model.run_green_light(
    filename="sample",
    weatherInput="bei",
    seasonLength=1/24/6,  # 5 minute intervals
    firstDay=1,
    isMature=False,
    lampType="led",
    initial_gl=gl
)

# 4. Calculate energy consumption
lampIn = model.calculate_energy_consumption(gl, "qLampIn", "qIntLampIn")
boilIn = model.calculate_energy_consumption(gl, "hBoilPipe", "hBoilGroPipe") 
co2inj = model.calculate_energy_consumption(gl, "mcExtAir")

# 5. Clean up
model.quit()
```

Sources: [main.py L8-L30](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L8-L30)

## Understanding Key Parameters

The `run_green_light()` method accepts several important configuration parameters:

| Parameter | Type | Description | Default |
| --- | --- | --- | --- |
| `filename` | str | Output file name | "" |
| `weatherInput` | str | Weather data location | "bei" |
| `seasonLength` | float | Simulation duration (fraction of year) | 1/24/6 |
| `firstDay` | int | Start day (days since Jan 1) | 1 |
| `isMature` | bool | Start with mature crop | False |
| `lampType` | str | Lamp type: "led", "hps", "none" | "led" |
| `initial_gl` | dict | Initial model state | {} |

Sources: [README.md L249-L276](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L249-L276)

## Understanding the Output

The simulation returns a Python dictionary `gl` containing three main sections:

* **`gl['x']`**: State variables (temperatures, concentrations, etc.)
* **`gl['a']`**: Auxiliary variables (calculated values)
* **`gl['d']`**: Input data (weather, setpoints)

Energy consumption calculations are performed using the `calculate_energy_consumption()` method with specific array keys:

* **Lamp energy**: `"qLampIn"`, `"qIntLampIn"`
* **Boiler energy**: `"hBoilPipe"`, `"hBoilGroPipe"`
* **CO2 consumption**: `"mcExtAir"`

Sources: [main.py L33-L37](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/main.py#L33-L37)

 [README.md L284-L299](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L284-L299)

## Next Steps

After completing this basic setup:

1. **Explore Core Components**: See [GreenLightModel Class Reference](/greenpeer/GreenLightModel/3.1-greenlightmodel-class-reference) for detailed method documentation
2. **Configure Weather Data**: Learn about weather input processing in [Weather Data and Input Processing](/greenpeer/GreenLightModel/5.1-weather-data-and-input-processing)
3. **Advanced Parameters**: Understand the parameter system in [Parameter Management](/greenpeer/GreenLightModel/5.2-parameter-management)
4. **Energy Analysis**: Deep dive into energy calculations in [Output Processing and Energy Calculations](/greenpeer/GreenLightModel/5.3-output-processing-and-energy-calculations)
5. **System Extension**: For custom modifications, see [Extending and Customizing the System](/greenpeer/GreenLightModel/7.2-extending-and-customizing-the-system)

Sources: [README.md L184-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L184-L329)