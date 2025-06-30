# Project Structure

> **Relevant source files**
> * [create_green_light_model/ode.py](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

This document provides a detailed explanation of the GreenLightPlus codebase organization, module dependencies, and architectural patterns. It serves as a technical reference for developers who need to understand how the code is organized and how different components interact.

For information about the high-level system architecture and component relationships, see [System Architecture](/greenpeer/GreenLightPlus/1.1-system-architecture). For details about model internals and parameter dependencies, see [Model Internals](/greenpeer/GreenLightPlus/5.2-model-internals).

## Directory Organization

The GreenLightPlus codebase follows a modular architecture organized into several key directories, each serving a specific purpose in the greenhouse simulation ecosystem.

### Top-Level Directory Structure

```

```

**Sources**: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

 [create_green_light_model/ode.py L1-L133](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L1-L133)

### Core Component Files

The main simulation components are implemented as standalone Python modules in the root `GreenLightPlus/` directory:

| Component | File | Primary Class/Function |
| --- | --- | --- |
| Core Simulation Engine | `green_light_model.py` | `GreenLightModel` |
| RL Environment | `greenhouse_env.py` | `GreenhouseEnv` |
| EnergyPlus Integration | `greenlight_energyplus_simulation.py` | `GreenhouseSimulation` |
| Geometry Generation | `greenhouse_geometry.py` | `GreenhouseGeometry` |

**Sources**: Inferred from high-level system architecture diagrams

## Module Dependency Architecture

The codebase follows a layered dependency structure where higher-level components depend on lower-level utilities and model construction modules.

### Core Dependency Graph

```

```

**Sources**: [create_green_light_model/ode.py L20-L26](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L20-L26)

 [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48)

### Key Import Patterns

The `ODESolver` class demonstrates the typical import pattern used throughout the codebase:

```javascript
from ..service_functions.funcs import *
from .set_gl_aux import set_gl_aux
from .set_gl_control import set_gl_control
from .set_gl_odes import set_gl_odes
```

This pattern shows:

* Cross-directory imports using relative paths (`..service_functions`)
* Intra-directory imports using relative paths (`.set_gl_aux`)
* Wildcard imports for utility functions
* Specific function imports for model construction

**Sources**: [create_green_light_model/ode.py L20-L23](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L20-L23)

## Data Flow Architecture

The codebase implements a clear data flow pattern where external inputs are processed through multiple transformation stages before reaching the core simulation engine.

### Data Processing Pipeline

```

```

**Sources**: [create_green_light_model/ode.py L61-L87](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L61-L87)

 [create_green_light_model/ode.py L89-L133](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L89-L133)

### Key Data Structures

The `ODESolver` class manages three primary data structures that represent the simulation state:

| Structure | Type | Purpose | Key Methods |
| --- | --- | --- | --- |
| `self.gl` | `dict` | GreenLight model instance | Updated in `ode(t, x)` |
| `self.d` | `numpy.ndarray` | Uncontrolled variables matrix | Sampled via `sample_d(t)` |
| `self.u` | `numpy.ndarray` | Control variables matrix | Sampled via `sample_u(t)` |

**Sources**: [create_green_light_model/ode.py L29-L38](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L29-L38)

 [create_green_light_model/ode.py L61-L87](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L61-L87)

## Package Configuration

The project uses modern Python packaging standards defined in `pyproject.toml`.

### Project Metadata

```
[project]
name = "GreenLightPlus"
version = "2.5"
requires-python = ">=3.8"
```

### Dependencies

| Category | Package | Version | Purpose |
| --- | --- | --- | --- |
| Core Scientific | `numpy`, `pandas`, `scipy` | Latest | Numerical computing |
| Simulation | `gymnasium` | Latest | RL environment framework |
| Building Modeling | `openstudio` | `3.6.1` | EnergyPlus integration |
| Machine Learning | `ray[rllib]` | Latest | Distributed RL training |
| Data Management | `gdown` | Latest | Model downloads |

### Entry Points

The package provides a command-line interface through:

```
[project.scripts]
GreenLightPlus = "GreenLight_Sim.cli:main"
```

This creates a system-wide command `GreenLightPlus` that executes the `main()` function in `GreenLight_Sim.cli`.

**Sources**: [pyproject.toml L5-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L5-L48)

## Architectural Patterns

### Composition Over Inheritance

The codebase favors composition patterns, particularly evident in the `ODESolver` class which aggregates multiple data structures and delegates functionality to specialized functions rather than inheriting behavior.

### Functional Decomposition

Model construction is broken into specialized functions:

* `set_gl_params()` - Parameter initialization
* `set_gl_states()` - State initialization
* `set_gl_control()` - Control logic
* `set_gl_aux()` - Auxiliary calculations
* `set_gl_odes()` - ODE system definition

### Data-Driven Configuration

The simulation engine operates on dictionary-based data structures (`gl` dict) that can be dynamically configured and modified during runtime.

**Sources**: [create_green_light_model/ode.py L119-L128](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/create_green_light_model/ode.py#L119-L128)