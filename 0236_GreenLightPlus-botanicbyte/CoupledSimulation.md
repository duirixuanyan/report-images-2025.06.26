Tutorial

5\. Coupled Simulation

## 5\. Coupled Simulation with EnergyPlus[](#5-coupled-simulation-with-energyplus)

GreenLightPlus provides functionality for coupled simulation with EnergyPlus, allowing users to perform more precise energy consumption and greenhouse environment simulations. This section will detail how to set up and run coupled simulations between GreenLightPlus and EnergyPlus.

### 5.1 Preparation[](#51-preparation)

First, ensure that you have installed both EnergyPlus and GreenLightPlus.

```bash
pip install GreenLightPlus
```

Then, import the necessary modules and set the EnergyPlus path:

```python
import sys
# Add EnergyPlus installation directory to Python module search path
sys.path.insert(0, "/Applications/EnergyPlus-23-2-0")
 
from GreenLightPlus import GreenhouseSimulation, convert_epw2csv
from pyenergyplus.api import EnergyPlusAPI
```

Note: Please adjust the path according to your EnergyPlus installation location.

### 5.2 Setting Simulation Parameters[](#52-setting-simulation-parameters)

Before starting the simulation, some basic parameters need to be set:

```python
# Create EnergyPlus API object
api = EnergyPlusAPI()
 
# Set weather file path
epw_path = "NLD_Amsterdam.062400_IWEC.epw" 
 
# Set model file path
idf_path = "data/model_files/greenhouse_half_circle.idf" 
 
# Convert EPW weather file to CSV file
csv_path = convert_epw2csv(
    epw_path=epw_path,
    time_step=1,  # Time step (minutes)
)
 
# Set output directory
output_directory = f"data/energyPlus/outputs"
 
# Set simulation start date (day of the year)
first_day = 91
 
# Set simulation days
season_length = 7
```

### 5.3 Creating and Running the Simulation[](#53-creating-and-running-the-simulation)

Use the GreenhouseSimulation class to create a simulation object and run the simulation:

```python
# Create simulation object
simulation = GreenhouseSimulation(
    api, 
    epw_path, 
    idf_path, 
    csv_path, 
    output_directory, 
    first_day, 
    season_length,
    isMature=True
)
 
# Run simulation
simulation.run()
```

### 5.4 Retrieving Simulation Results[](#54-retrieving-simulation-results)

After the simulation is complete, you can retrieve the results:

```python
# Get simulation results
total_yield, lampIn, boilIn = simulation.get_results()
 
print(f"Total yield: {total_yield} kg/m2, Lamp input: {lampIn} MJ/m2, Boiler input: {boilIn} MJ/m2")
```

### 5.5 Complete Code Example[](#55-complete-code-example)

Here's a complete code example demonstrating the entire coupled simulation process:

```python
import sys
sys.path.insert(0, "/Applications/EnergyPlus-23-2-0")
 
from GreenLightPlus import GreenhouseSimulation, convert_epw2csv
from pyenergyplus.api import EnergyPlusAPI
 
if __name__ == "__main__":
    api = EnergyPlusAPI()
    epw_path = "NLD_Amsterdam.062400_IWEC.epw" 
    idf_path = "data/model_files/greenhouse_half_circle.idf" 
    
    csv_path = convert_epw2csv(
        epw_path=epw_path,
        time_step=1,
    )
    
    output_directory = f"data/energyPlus/outputs"
    first_day = 91
    season_length = 7
    
    simulation = GreenhouseSimulation(api, epw_path, idf_path, csv_path, output_directory, first_day, season_length, isMature=True)
    simulation.run()
    
    total_yield, lampIn, boilIn = simulation.get_results()
    print(f"Total yield: {total_yield} kg/m2, Lamp input: {lampIn} MJ/m2, Boiler input: {boilIn} MJ/m2")
```

### 5.6 Parameter Explanation[](#56-parameter-explanation)

+   `api`: EnergyPlus API object
+   `epw_path`: EPW weather file path
+   `idf_path`: IDF model file path
+   `csv_path`: Path of the converted CSV weather file
+   `output_directory`: Output directory
+   `first_day`: Simulation start date (day of the year)
+   `season_length`: Number of simulation days
+   `isMature`: Whether it's a mature crop (boolean)

### 5.7 Considerations[](#57-considerations)

1.  Ensure EnergyPlus is correctly installed and the path is set correctly.
2.  Use appropriate EPW weather files and IDF model files. This example uses weather data from Amsterdam and a half-circle greenhouse model.
3.  The `convert_epw2csv` function is used to convert EPW files to CSV format, which may be useful for certain analyses.
4.  Simulation results include total yield (kg/m²), lamp input (MJ/m²), and boiler input (MJ/m²).

### 5.8 Extended Use[](#58-extended-use)

+   You can simulate different greenhouse structures and settings by modifying the IDF file.
+   This coupled simulation can be integrated into a larger optimization framework to find optimal greenhouse design and operation strategies.

By using the coupled simulation functionality of GreenLightPlus with EnergyPlus, you can perform more precise and comprehensive greenhouse performance analyses, providing strong support for greenhouse design and operational decisions.

[4\. Parametric Modeling of Greenhouse Geometry](https://botanicbyte.com/Tutorial/GreenhouseGeometry "4. Parametric Modeling of Greenhouse Geometry")[Code Structure](https://botanicbyte.com/Code_Structure "Code Structure")