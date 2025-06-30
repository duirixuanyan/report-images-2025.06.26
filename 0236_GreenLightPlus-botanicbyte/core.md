## Core Components

The `core` directory contains the fundamental modules that form the backbone of the GreenLightPlus project:

+   `green_light_model.py`: Defines the `GreenLightModel` class, which is the central component for creating and managing greenhouse simulation models.
    
+   `greenhouse_env.py`: Implements the `GreenhouseEnv` class, a custom OpenAI Gym environment for reinforcement learning in greenhouse control. This environment allows AI models to be trained for optimal greenhouse management.
    
+   `greenhouse_geometry.py`: Contains the `GreenhouseGeometry` class, which handles the creation and management of the greenhouse's physical structure in OpenStudio.
    
+   `greenlight_energyplus_simulation.py`: Defines the `GreenhouseSimulation` class, which integrates the GreenLight model with EnergyPlus for comprehensive energy simulations.
    

These core modules work together to provide a flexible and powerful framework for simulating greenhouse environments, energy consumption, and crop growth, as well as for training AI models to optimize greenhouse operations.

[Code Structure](https://botanicbyte.com/Code_Structure "Code Structure")[1.1 green\_light\_model](https://botanicbyte.com/Code_Structure/core/green_light_model "1.1 green_light_model")