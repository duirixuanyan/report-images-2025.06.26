# System Configuration

> **Relevant source files**
> * [.gitignore](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/.gitignore)
> * [requirements.txt](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/requirements.txt)

This document covers the system-level configuration requirements, dependencies, and environment setup for the GreenLightModel system. It provides an overview of the configuration components needed to run the Python-MATLAB hybrid greenhouse simulation system.

For detailed dependency installation and environment setup procedures, see [Dependencies and Environment Setup](/greenpeer/GreenLightModel/6.1-dependencies-and-environment-setup). For development-specific configuration including version control setup, see [Development Configuration](/greenpeer/GreenLightModel/6.2-development-configuration).

## Configuration Overview

The GreenLightModel system requires configuration across multiple technology layers: Python package dependencies, MATLAB engine integration, and development environment setup. The system's hybrid architecture necessitates careful coordination between Python and MATLAB runtime environments.

## System Configuration Architecture

```mermaid
flowchart TD

J[".gitignore"]
K["Version Control"]
L["Project Structure"]
A["requirements.txt"]
B["scipy"]
C["numpy"]
D["matlabengine"]
E["matlab"]
F["sympy"]
G["MATLAB Runtime"]
H["GreenLight Model"]
I["DyMoMa Framework"]
M["Path Management"]
N["Engine Initialization"]
O["Resource Cleanup"]

D --> G
D --> M

subgraph subGraph3 ["Runtime Configuration"]
    M
    N
    O
    M --> N
    N --> O
end

subgraph subGraph1 ["MATLAB Environment"]
    G
    H
    I
    G --> H
    G --> I
end

subgraph subGraph0 ["Python Environment"]
    A
    B
    C
    D
    E
    F
    A --> B
    A --> C
    A --> D
    A --> E
    A --> F
end

subgraph subGraph2 ["Development Environment"]
    J
    K
    L
    J --> K
    K --> L
end
```

*Sources: [requirements.txt L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/requirements.txt#L1-L5)

 [.gitignore L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/.gitignore#L1-L5)*

## Core Configuration Files

The system uses a minimal set of configuration files that define dependencies and development environment settings:

| File | Purpose | Dependencies Managed |
| --- | --- | --- |
| `requirements.txt` | Python package dependencies | scipy, numpy, matlab, sympy, matlabengine |
| `.gitignore` | Version control exclusions | Python bytecode, system files, cache directories |

## Python Dependencies Configuration

```mermaid
flowchart TD

A["scipy"]
B["numpy"]
C["matlab"]
D["sympy"]
E["matlabengine"]
F["Scientific Computing"]
G["Array Operations"]
H["MATLAB Bridge"]
I["Symbolic Math"]
J["Engine Management"]
K["gl_model.py"]
L["Parameter Processing"]
M["Data Analysis"]

A --> F
B --> G
C --> H
D --> I
E --> J
F --> K
G --> K
H --> K
I --> L
J --> K

subgraph subGraph2 ["Core System Functions"]
    K
    L
    M
    K --> M
end

subgraph subGraph1 ["GreenLightModel Usage"]
    F
    G
    H
    I
    J
end

subgraph subGraph0 ["requirements.txt Dependencies"]
    A
    B
    C
    D
    E
end
```

*Sources: [requirements.txt L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/requirements.txt#L1-L5)*

The Python dependencies serve specific roles in the system:

* **scipy**: Scientific computing functions for numerical analysis and optimization
* **numpy**: Array operations and mathematical functions for data processing
* **matlab**: Base MATLAB integration support
* **sympy**: Symbolic mathematics for parameter formula evaluation
* **matlabengine**: Python-MATLAB engine interface for executing MATLAB code

## Version Control Configuration

The `.gitignore` file defines exclusion patterns for the development environment:

```mermaid
flowchart TD

A[".DS_Store"]
B["pycache/"]
C["*.pyc"]
D["*.pyo"]
E["*.pyd"]
F["System Files"]
G["Python Cache"]
H["Compiled Python"]
I["Optimized Python"]
J["Extension Modules"]
K["Clean Repository"]
L["Portable Code"]
M["Version Control"]

A --> F
B --> G
C --> H
D --> I
E --> J
F --> K
G --> L
H --> M
I --> M
J --> M

subgraph subGraph2 ["Development Impact"]
    K
    L
    M
end

subgraph subGraph1 ["File Categories"]
    F
    G
    H
    I
    J
end

subgraph subGraph0 ["Excluded File Types"]
    A
    B
    C
    D
    E
end
```

*Sources: [.gitignore L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/.gitignore#L1-L5)*

The exclusion patterns prevent platform-specific and generated files from being tracked:

* `.DS_Store`: macOS system metadata files
* `__pycache__/`: Python bytecode cache directories
* `*.pyc`, `*.pyo`: Compiled Python files
* `*.pyd`: Python extension modules (Windows)

## Environment Requirements

The system requires coordination between multiple runtime environments:

| Component | Requirement | Configuration Point |
| --- | --- | --- |
| Python Runtime | 3.x with pip package management | `requirements.txt` dependencies |
| MATLAB Engine | Compatible MATLAB installation | `matlabengine` package configuration |
| System Paths | Access to MATLAB and Python executables | Runtime path management |
| Memory Resources | Sufficient RAM for simulation data | No explicit configuration |

## Configuration Dependencies

```mermaid
sequenceDiagram
  participant Developer
  participant pip
  participant Python Runtime
  participant MATLAB Engine
  participant System Environment

  Developer->>pip: "pip install -r requirements.txt"
  pip->>Python Runtime: Install scipy, numpy, sympy
  pip->>MATLAB Engine: Install matlab, matlabengine
  Python Runtime->>System Environment: Verify package imports
  MATLAB Engine->>System Environment: Initialize engine connection
  System Environment->>Developer: Environment ready
  note over Developer,System Environment: Configuration validation occurs at runtime
```

*Sources: [requirements.txt L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/requirements.txt#L1-L5)

 [.gitignore L1-L5](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/.gitignore#L1-L5)*

The configuration process requires sequential dependency resolution, with MATLAB engine setup being the most complex step due to its external system dependencies.