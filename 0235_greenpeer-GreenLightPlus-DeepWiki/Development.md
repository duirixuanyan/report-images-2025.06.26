# Development

> **Relevant source files**
> * [LICENSE.txt](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

This section provides information for developers who want to contribute to or extend GreenLightPlus. It covers the project structure, development environment setup, and guidelines for contributing to the codebase.

For detailed information about the internal model structure and algorithms, see [Model Internals](/greenpeer/GreenLightPlus/5.2-model-internals). For contribution guidelines and licensing information, see [Contributing](/greenpeer/GreenLightPlus/5.3-contributing).

## Development Environment

GreenLightPlus is built as a modern Python package using the `setuptools` build system with a declarative configuration approach. The project targets Python 3.8+ and integrates with several external simulation and machine learning frameworks.

### Build System and Dependencies

The project uses a standard Python packaging structure defined in [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

:

| Component | Version/Requirement | Purpose |
| --- | --- | --- |
| Python | >=3.8 | Runtime environment |
| setuptools | >=61.0 | Build backend |
| numpy, pandas, scipy | Latest | Core scientific computing |
| gymnasium | Latest | RL environment framework |
| openstudio | ==3.6.1 | EnergyPlus integration |
| ray[rllib] | Latest | Distributed RL training |
| gdown | Latest | Model file downloads |

The project includes optional development dependencies for testing and documentation:

* `pytest` for unit testing
* `sphinx` and `sphinx-rtd-theme` for documentation generation

### Package Entry Points

The main CLI interface is exposed through the `GreenLightPlus` command, which maps to `GreenLight_Sim.cli:main` as defined in [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48)

## Development Workflow

### Development Tools Integration

```mermaid
flowchart TD

PYPROJ["pyproject.toml<br>Project Configuration"]
BUILD["setuptools<br>Build Backend"]
CLI["GreenLight_Sim.cli:main<br>Entry Point"]
SCI["Scientific Stack<br>numpy, pandas, scipy"]
ML["ML Framework<br>ray[rllib], gymnasium"]
SIM["Simulation Engine<br>openstudio==3.6.1"]
UTIL["Utilities<br>gdown"]
TEST["pytest<br>Unit Testing"]
DOC["sphinx + sphinx-rtd-theme<br>Documentation"]
LINT["Code Quality Tools"]
WHEEL["Wheel Distribution"]
PYPI["Package Index"]

PYPROJ --> SCI
PYPROJ --> ML
PYPROJ --> SIM
PYPROJ --> UTIL
PYPROJ --> TEST
PYPROJ --> DOC
BUILD --> WHEEL

subgraph Distribution ["Distribution"]
    WHEEL
    PYPI
    WHEEL --> PYPI
end

subgraph subGraph2 ["Development Tools"]
    TEST
    DOC
    LINT
end

subgraph subGraph1 ["Core Dependencies"]
    SCI
    ML
    SIM
    UTIL
end

subgraph subGraph0 ["Development Environment"]
    PYPROJ
    BUILD
    CLI
    PYPROJ --> BUILD
    BUILD --> CLI
end
```

**Development Workflow Architecture**

This diagram shows how the development environment is structured around the declarative configuration in `pyproject.toml`, which manages both runtime dependencies and development tooling.

Sources: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

### Code Architecture Overview

```mermaid
flowchart TD

MAIN["GreenLight_Sim.cli:main<br>Command Line Interface"]
GLM["green_light_model.py<br>GreenLightModel class"]
ENV["greenhouse_env.py<br>GreenhouseEnv class"]
SIM["greenlight_energyplus_simulation.py<br>GreenhouseSimulation class"]
GEO["greenhouse_geometry.py<br>GreenhouseGeometry class"]
ODE["ode.py<br>create_green_light_ode()"]
PARAMS["set_gl_params.py<br>setGlParams()"]
STATES["set_gl_states.py<br>setGlStates()"]
CONTROL["set_gl_control.py<br>setGlControl()"]
AUX["set_gl_aux.py<br>setGlAux()"]
FUNCS["funcs.py<br>Utility functions"]
CONVERT["convert_epw2csv.py<br>convertEpw2Csv()"]
CO2["co2_dens2ppm.py<br>co2Dens2Ppm()"]
VP["vp2dens.py<br>vp2Dens()"]
PLOT["plot_green_light.py<br>plotGreenLight()"]
ENERGY["energy_analysis.py<br>Energy analysis functions"]
YIELD["energy_yield_analysis.py<br>Yield analysis functions"]

MAIN --> GLM
MAIN --> ENV
MAIN --> SIM
MAIN --> GEO
GLM --> ODE
GLM --> FUNCS
GLM --> PLOT
GLM --> ENERGY
GLM --> YIELD

subgraph subGraph4 ["Analysis Tools"]
    PLOT
    ENERGY
    YIELD
end

subgraph subGraph3 ["Service Functions"]
    FUNCS
    CONVERT
    CO2
    VP
    FUNCS --> CONVERT
    FUNCS --> CO2
    FUNCS --> VP
end

subgraph subGraph2 ["Model Construction"]
    ODE
    PARAMS
    STATES
    CONTROL
    AUX
    ODE --> PARAMS
    ODE --> STATES
    ODE --> CONTROL
    ODE --> AUX
end

subgraph subGraph1 ["Core Simulation Modules"]
    GLM
    ENV
    SIM
    GEO
end

subgraph subGraph0 ["CLI Layer"]
    MAIN
end
```

**Core Code Architecture with Function Names**

This diagram maps the high-level system components to their actual implementation in the codebase, showing the primary classes and functions that developers will encounter.

Sources: [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48)

## Licensing and Legal Framework

GreenLightPlus is licensed under the GNU General Public License version 3 (GPL v3) as specified in [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)

 This copyleft license has important implications for development:

### GPL v3 Key Requirements

| Requirement | Implication for Development |
| --- | --- |
| Source code availability | All distributed versions must include source code |
| Derivative work licensing | Extensions must be GPL v3 compatible |
| Copyright notices | Must preserve existing copyright and license notices |
| Installation information | Must provide installation instructions for User Products |

The GPL v3 license ensures that GreenLightPlus remains free and open source, but developers must ensure any contributions or derivative works comply with the license terms.

### Project Metadata

The project is maintained by Daidai Qiu ([qiu.daidai@outlook.com](mailto:qiu.daidai@outlook.com)) and is classified as:

* Development Status: Alpha
* Intended Audience: Science/Research
* Topic: Scientific/Engineering

Sources: [pyproject.toml L8-L24](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L8-L24)

 [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)

## Integration Points

### External System Dependencies

GreenLightPlus integrates with several external systems that developers need to understand:

1. **EnergyPlus 3.6.1**: Building energy simulation engine accessed through OpenStudio
2. **Ray RLlib**: Distributed reinforcement learning framework for agent training
3. **Gymnasium**: Standard RL environment interface for agent-environment interaction

### Python Version Compatibility

The codebase supports Python 3.8, 3.9, and 3.10 as specified in [pyproject.toml L20-L22](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L20-L22)

 Developers should ensure compatibility across these versions when contributing.

## Development Standards

### Package Structure

The project follows standard Python package conventions with setuptools auto-discovery enabled through [pyproject.toml L53-L54](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L53-L54)

 The `include-package-data = true` directive ensures that non-Python files are included in distributions.

### Command Line Interface

The main entry point provides a unified interface to all GreenLightPlus functionality through the `GreenLightPlus` command, implemented in the `GreenLight_Sim.cli` module.

Sources: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

 [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)