教程

5\. 耦合模拟

## 5\. 与EnergyPlus的耦合模拟[](#5-coupled-simulation-with-energyplus)

GreenLightPlus提供了与EnergyPlus的耦合模拟功能，使用户能够进行更精确的能耗和温室环境模拟。本节将详细介绍如何设置和运行GreenLightPlus与EnergyPlus之间的耦合模拟。

### 5.1 准备工作[](#51-preparation)

首先，请确保您已安装EnergyPlus和GreenLightPlus。

```bash
pip install GreenLightPlus
```

然后，导入必要的模块并设置EnergyPlus路径：

```python
import sys
# Add EnergyPlus installation directory to Python module search path
sys.path.insert(0, "/Applications/EnergyPlus-23-2-0")
 
from GreenLightPlus import GreenhouseSimulation, convert_epw2csv
from pyenergyplus.api import EnergyPlusAPI
```

注意：请根据您的EnergyPlus安装位置调整路径。

### 5.2 设置模拟参数[](#52-setting-simulation-parameters)

在开始模拟之前，需要设置一些基本参数：

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

### 5.3 创建并运行模拟[](#53-creating-and-running-the-simulation)

使用 GreenhouseSimulation 类创建模拟对象并运行模拟：

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

### 5.4 获取模拟结果[](#54-retrieving-simulation-results)

模拟完成后，您可以获取结果：

```python
# Get simulation results
total_yield, lampIn, boilIn = simulation.get_results()
 
print(f"Total yield: {total_yield} kg/m2, Lamp input: {lampIn} MJ/m2, Boiler input: {boilIn} MJ/m2")
```

### 5.5 完整代码示例[](#55-complete-code-example)

这是一个展示完整耦合模拟过程的代码示例:

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

### 5.6 参数说明[](#56-parameter-explanation)

+   `api`: EnergyPlus API对象
+   `epw_path`: EPW气象文件路径  
+   `idf_path`: IDF模型文件路径
+   `csv_path`: 转换后的CSV气象文件路径
+   `output_directory`: 输出目录
+   `first_day`: 模拟开始日期(年积日)
+   `season_length`: 模拟天数
+   `isMature`: 是否为成熟作物(布尔值)

### 5.7 注意事项[](#57-considerations)

1.  确保EnergyPlus已正确安装且路径设置正确
2.  使用合适的EPW气象文件和IDF模型文件。本示例使用阿姆斯特丹气象数据和半圆形温室模型
3.  `convert_epw2csv`函数用于将EPW文件转换为CSV格式，可用于特定分析
4.  模拟结果包括总产量(kg/m²)、灯具输入(MJ/m²)和锅炉输入(MJ/m²)

### 5.8 扩展应用[](#58-extended-use)

+   通过修改IDF文件可以模拟不同的温室结构和设置
+   该耦合模拟可集成到更大的优化框架中，以寻找最优温室设计和运营策略

通过使用GreenLightPlus与EnergyPlus的耦合模拟功能，您可以进行更精确、更全面的温室性能分析，为温室设计和运营决策提供有力支持。

[4\. 温室几何参数化建模](https://botanicbyte.com/Tutorial/GreenhouseGeometry "4. 温室几何参数化建模")[代码结构](https://botanicbyte.com/Code_Structure "代码结构")