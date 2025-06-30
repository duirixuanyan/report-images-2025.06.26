# Contributing

> **Relevant source files**
> * [LICENSE.txt](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt)
> * [pyproject.toml](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml)

This document provides guidelines for contributing to the GreenLightPlus project, including licensing requirements, development environment setup, and project structure information for contributors. For information about the overall project architecture, see [System Architecture](/greenpeer/GreenLightPlus/1.1-system-architecture). For details about the codebase organization, see [Project Structure](/greenpeer/GreenLightPlus/5.1-project-structure).

## License and Legal Requirements

GreenLightPlus is distributed under the GNU General Public License version 3 (GPLv3), which is a copyleft license that ensures the software remains free and open source. All contributions must be compatible with this license.

### License Classification

| Component | License | Classification |
| --- | --- | --- |
| Core Software | GPL v3 | Copyleft |
| Contributions | GPL v3 | Must be GPL-compatible |
| Dependencies | Various | See dependency table |

The project is configured as GPL v3 in [pyproject.toml L17](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L17-L17)

 and the full license text is available in [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)

 Contributors must understand that:

* All code contributions become part of the GPL v3 licensed codebase
* Derivative works must also be GPL v3 licensed
* The copyleft nature requires source code availability for distributions
* No warranty is provided as stated in the license terms

**Development Workflow - License Perspective**

```

```

Sources: [LICENSE.txt L1-L675](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/LICENSE.txt#L1-L675)

 [pyproject.toml L17](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L17-L17)

## Development Environment Setup

### Python Requirements

The project requires Python 3.8 or higher as specified in [pyproject.toml L13](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L13-L13)

 The development environment should include both runtime and development dependencies.

**Core Dependencies**

| Package | Version | Purpose |
| --- | --- | --- |
| `numpy` | Latest | Numerical computing |
| `pandas` | Latest | Data manipulation |
| `scipy` | Latest | Scientific computing |
| `gymnasium` | Latest | RL environment framework |
| `openstudio` | 3.6.1 | Building energy simulation |
| `gdown` | Latest | Google Drive downloads |
| `ray[rllib]` | Latest | Distributed RL |

**Development Dependencies**

| Package | Purpose |
| --- | --- |
| `pytest` | Unit testing framework |
| `sphinx` | Documentation generation |
| `sphinx-rtd-theme` | Documentation theme |

### Installation Process

```markdown
# Clone the repository
git clone https://github.com/greenpeer/GreenLightPlus.git
cd GreenLightPlus

# Install in development mode with dev dependencies
pip install -e .[dev]
```

The project uses `setuptools` as the build backend as configured in [pyproject.toml L2-L3](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L2-L3)

Sources: [pyproject.toml L13](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L13-L13)

 [pyproject.toml L25-L33](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L25-L33)

 [pyproject.toml L35-L40](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L35-L40)

## Build and Packaging System

GreenLightPlus uses a modern Python packaging configuration with `pyproject.toml` following PEP 621 standards.

**Build System Configuration**

```

```

### Project Metadata

The project is configured with the following metadata in [pyproject.toml L5-L24](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L5-L24)

:

* **Name**: GreenLightPlus
* **Version**: 2.5
* **Author**: Daidai Qiu ([qiu.daidai@outlook.com](mailto:qiu.daidai@outlook.com))
* **Description**: Greenhouse Simulation and Optimization Toolkit
* **Python Support**: 3.8, 3.9, 3.10
* **Development Status**: Alpha
* **Target Audience**: Science/Research

### Command Line Interface

The package provides a CLI entry point configured in [pyproject.toml L47-L48](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L47-L48)

:

```
GreenLightPlus = "GreenLight_Sim.cli:main"
```

This maps the `GreenLightPlus` command to the `main` function in the `GreenLight_Sim.cli` module.

### Package Discovery

The build system uses automatic package discovery as configured in [pyproject.toml L50-L54](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L50-L54)

:

```
[tool.setuptools]
include-package-data = true

[tool.setuptools.packages.find]
where = ["."]
```

Sources: [pyproject.toml L1-L55](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L1-L55)

## Development Workflow for Contributors

### Code Organization Principles

GreenLightPlus follows a modular architecture where contributors should understand the relationship between different components before making changes.

**Development Component Mapping**

```

```

### Contribution Areas

Contributors can focus on different areas of the system:

| Area | Components | Expertise Required |
| --- | --- | --- |
| **Core Simulation** | `green_light_model.py`, `ode.py` | ODE solving, plant modeling |
| **Energy Analysis** | `greenlight_energyplus_simulation.py` | Building physics, EnergyPlus |
| **Reinforcement Learning** | `greenhouse_env.py` | RL algorithms, Gymnasium |
| **Geometry Modeling** | `greenhouse_geometry.py` | 3D modeling, structural analysis |
| **Data Processing** | `funcs.py`, `convert_epw2csv.py` | Data transformation, weather data |
| **Visualization** | `plot_green_light.py` | Scientific plotting, matplotlib |

### Development Dependencies Integration

The development tools integrate with the main codebase through the optional dependencies system:

* **pytest**: For running unit tests across all modules
* **sphinx**: For generating documentation from docstrings
* **sphinx-rtd-theme**: For consistent documentation styling

Sources: [pyproject.toml L35-L40](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L35-L40)

## Testing and Quality Assurance

### Testing Framework

The project uses `pytest` as the primary testing framework, installed via the `dev` optional dependency group in [pyproject.toml L37](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L37-L37)

### Testing Strategy

Contributors should ensure their changes don't break existing functionality by:

1. Running existing tests before submitting changes
2. Adding tests for new functionality
3. Ensuring test coverage for critical simulation components
4. Validating numerical accuracy for scientific computations

### Quality Standards

Given the scientific nature of the software, contributions should maintain:

* **Numerical Accuracy**: Especially for ODE solving and energy calculations
* **Physical Validity**: Ensuring greenhouse physics remain realistic
* **Performance**: Maintaining computational efficiency for large simulations
* **Reproducibility**: Ensuring consistent results across runs

## Documentation Guidelines

### Documentation Generation

The project uses Sphinx for documentation generation, configured through [pyproject.toml L38-L39](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L38-L39)

 Contributors should:

1. Write clear docstrings for all public functions and classes
2. Use the Read the Docs theme for consistency
3. Document any new dependencies or configuration changes
4. Update relevant wiki pages when modifying system architecture

### Code Documentation Standards

* Use NumPy-style docstrings for scientific functions
* Include units and physical meanings for parameters
* Provide examples for complex functions
* Document any external system integrations (EnergyPlus, Ray, etc.)

Sources: [pyproject.toml L38-L39](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L38-L39)

## Project URLs and Community

The project maintains several important URLs for contributors:

| Resource | URL | Purpose |
| --- | --- | --- |
| Homepage | [https://github.com/greenpeer/GreenLightPlus](https://github.com/greenpeer/GreenLightPlus) | Main repository |
| Bug Reports | [https://github.com/greenpeer/GreenLightPlus/issues](https://github.com/greenpeer/GreenLightPlus/issues) | Issue tracking |
| Source Code | [https://github.com/greenpeer/GreenLightPlus](https://github.com/greenpeer/GreenLightPlus) | Code access |

Contributors should use the GitHub Issues system for bug reports and feature requests as configured in [pyproject.toml L42-L45](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L42-L45)

Sources: [pyproject.toml L42-L45](https://github.com/greenpeer/GreenLightPlus/blob/262399d9/pyproject.toml#L42-L45)