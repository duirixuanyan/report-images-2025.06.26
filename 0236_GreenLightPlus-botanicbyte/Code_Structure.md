## 1\. GreenLightPlus[](#1-greenlightplus)

* * *

## 2\. 项目结构[](#2-项目结构)

```markdown
├── LICENSE.txt
├── README.md
├── README_zh.md
├── __init__.py
├── core/
│   ├── green_light_model.py
│   ├── greenhouse_env.py
│   ├── greenhouse_geometry.py
│   ├── greenlight_energyplus_simulation.py
├── create_green_light_model/
│   ├── change_res.py
│   ├── create_green_light_model.py
│   ├── ode.py
│   ├── set_default_lamp_params.py
│   ├── set_dep_params.py
│   ├── set_gl_aux.py
│   ├── set_gl_control.py
│   ├── set_gl_control_init.py
│   ├── set_gl_odes.py
│   ├── set_gl_params.py
│   ├── set_gl_states.py
│   ├── set_gl_states_init.py
│   ├── set_gl_time.py
│   ├── set_gl_weather.py
│   ├── set_params4ha_world_comparison.py
├── result_analysis/
│   ├── energy_analysis.py
│   ├── energy_yield_analysis.py
│   ├── plot_green_light.py
├── service_functions/
│   ├── co2_dens2ppm.py
│   ├── co2_ppm2dens.py
│   ├── convert_epw2csv.py
│   ├── cut_energy_plus_data.py
│   ├── day_light_sum.py
│   ├── funcs.py
│   ├── make_artificial_input.py
│   ├── rh2vapor_dens.py
│   ├── vapor_dens2pres.py
│   ├── vp2dens.py
 
```

* * *

## 3\. 代码功能[](#3-代码功能)

+   `core/green_light_model.py`: Contains the GreenLightModel class, which is used to create model instances.
+   `service_functions/`: A folder containing general use functions.
    +   `rh2vapor_dens.py`: Converts relative humidity (in %) to vapor density (in kg H2O m^\-3).
    +   `make_artificial_input.py`: Creates an artificial dataset to use as input for a GreenLight model.
    +   `vapor_dens2pres.py`: Converts vapor density to vapor pressure for given temperature and vapor density values.
    +   `funcs.py`: Contains utility functions required by other functions in the package.
    +   `co2_dens2ppm.py`: Converts CO2 density to ppm.
    +   `vp2dens.py`: Converts vapor pressure to vapor density.
    +   `co2_ppm2dens.py`: Converts CO2 in ppm to density.
    +   `convert_epw2csv.py`: Converts EPW (EnergyPlus Weather) files to CSV format.
    +   `cut_energy_plus_data.py`: Processes and trims EnergyPlus simulation data.
    +   `day_light_sum.py`: Calculates daily light sums.
+   `create_green_light_model/`: A folder containing core functionality for creating and working with GreenLight model instances.
    +   `create_green_light_model.py`: Main function for creating a GreenLight model instance.
    +   `ode.py`: Solves a system of ODEs.
    +   `set_gl_states_init.py`: Sets the initial values for the GreenLight model states.
    +   `set_gl_control.py`: Sets the controls for the greenhouse model.
    +   `set_dep_params.py`: Sets the parameters according to the Vanthoor model.
    +   `set_gl_control_init.py`: Sets initial control variables for the greenhouse model.
    +   `set_params4ha_world_comparison.py`: Sets the parameters according to a modern 4 ha greenhouse.
    +   `set_gl_odes.py`: Sets the ODEs for the model.
    +   `set_gl_states.py`: Sets the states for the GreenLight model.
    +   `set_default_lamp_params.py`: Sets default settings for the lamp type in the GreenLight model.
    +   `set_gl_params.py`: Sets parameters for a GreenLight model based on the electronic appendices of Vanthoor (2011).
    +   `set_gl_time.py`: Sets the time phase for a GreenLight greenhouse model.
    +   `set_gl_aux.py`: Sets auxiliary states for the GreenLight greenhouse model.
    +   `set_gl_weather.py`: Sets weather-related parameters for the model.
    +   `change_res.py`: Changes the resolution of the GreenLight model solution by interpolating the solution at a different time step.
+   `result_analysis/`: A folder containing functions for analyzing and visualizing the results of GreenLight simulations.
    +   `energy_analysis.py`: Calculates the energy consumption for each component of the model.
    +   `plot_green_light.py`: Plots commonly used graphs to visualize model results.
    +   `energy_yield_analysis.py`: Returns the resulting energy use, light above the canopy, yield, and efficiency of a GreenLight simulation.
+   `core/greenhouse_env.py`: Defines the greenhouse environment parameters and conditions.
+   `core/greenhouse_geometry.py`: Handles the geometric aspects and calculations for the greenhouse model.
+   `core/greenlight_energyplus_simulation.py`: Manages the integration with EnergyPlus for advanced energy simulations.

* * *

[5\. Coupled Simulation](https://botanicbyte.com/Tutorial/CoupledSimulation "5. Coupled Simulation")[1\. Core Components](https://botanicbyte.com/Code_Structure/core "1. Core Components")