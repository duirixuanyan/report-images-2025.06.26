# Weather Data and Input Processing

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md)
> * [gl_model.py](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py)

This document covers how the GreenLightModel system handles weather data input, including loading EnergyPlus weather files, generating artificial weather data, and converting data formats for use in greenhouse simulations. For information about parameter management and formula evaluation, see [Parameter Management](/greenpeer/GreenLightModel/5.2-parameter-management). For details about simulation output processing, see [Output Processing and Energy Calculations](/greenpeer/GreenLightModel/5.3-output-processing-and-energy-calculations).

## Weather Data Flow Architecture

The weather data processing system transforms external weather inputs into the specific format required by the GreenLight MATLAB simulation engine.

```

```

Sources: [gl_model.py L89-L203](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L89-L203)

 [gl_model.py L297-L439](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L297-L439)

## Weather Data Sources and Formats

The system supports two primary weather data sources:

### EnergyPlus Weather Files

Real weather data is loaded from EnergyPlus format files stored in the data directory. The system uses MATLAB's `cutEnergyPlusData` function to extract weather data for specific time periods.

```mermaid
sequenceDiagram
  participant GreenLightModel
  participant MATLAB Engine
  participant EnergyPlus File

  GreenLightModel->>MATLAB Engine: "cutEnergyPlusData(firstDay, seasonLength, filepath)"
  MATLAB Engine->>EnergyPlus File: "Load weather data"
  EnergyPlus File->>MATLAB Engine: "Raw weather matrix"
  MATLAB Engine->>GreenLightModel: "weather = np.array(weather, dtype=np.float64)"
  GreenLightModel->>GreenLightModel: "Process timestamps and elevation"
```

The weather file path is constructed as:

* Base directory: `GreenLight/Code/inputs/energyPlus/data/`
* File format: `{weatherInput}EnergyPlus.mat`

Sources: [gl_model.py L99-L104](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L99-L104)

 [gl_model.py L291-L295](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L291-L295)

### Artificial Weather Generation

When no real weather data is available, the system generates artificial weather patterns using the `makeArtificialInput` function.

| Weather Parameter | Column | Formula/Value | Unit |
| --- | --- | --- | --- |
| Timestamps | 0 | `generate_datenum_list(737485.5, length, 300)` | datenum |
| Radiation | 1 | `350 * max(0, sin(time * 2π / 86400))` | W m⁻² |
| Temperature | 2 | `5 * sin(time * 2π / 86400) + 15` | °C |
| Humidity | 3 | `0.006` (constant) | kg m⁻³ |
| CO2 | 4 | `co2ppm2dens(temperature, 410)` | kg m⁻³ |
| Wind Speed | 5 | `1.0` (constant) | m s⁻¹ |
| Sky Temperature | 6 | `temperature - 20` | °C |
| Soil Temperature | 7 | `20` (constant) | °C |
| Daily Light Sum | 8 | `day_light_sum(timestamps, radiation)` | MJ m⁻² day⁻¹ |

Sources: [gl_model.py L297-L329](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L297-L329)

## Weather Matrix Structure

The processed weather data is formatted as a 9-column matrix with 5-minute intervals:

```mermaid
flowchart TD

A["weather[:,0]<br>Timestamps [datenum]"]
B["weather[:,1]<br>Radiation [W m⁻²]"]
C["weather[:,2]<br>Temperature [°C]"]
D["weather[:,3]<br>Humidity [kg m⁻³]"]
E["weather[:,4]<br>CO2 [kg m⁻³]"]
F["weather[:,5]<br>Wind [m s⁻¹]"]
G["weather[:,6]<br>Sky Temp [°C]"]
H["weather[:,7]<br>Soil Temp [°C]"]
I["weather[:,8]<br>Daily Light [MJ m⁻² day⁻¹]"]
J["generate_datenum_list()"]
K["co2ppm2dens()"]
L["day_light_sum()"]

J --> A
K --> E
L --> I

subgraph subGraph1 ["Processing Functions"]
    J
    K
    L
end

subgraph subGraph0 ["Weather Matrix Structure"]
    A
    B
    C
    D
    E
    F
    G
    H
    I
end
```

Sources: [gl_model.py L300-L311](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L300-L311)

 [README.md L261-L271](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/README.md#L261-L271)

## Timestamp and Date Processing

### MATLAB Datenum Conversion

The system converts between Python datetime objects and MATLAB datenum format for compatibility with the MATLAB simulation engine.

```mermaid
flowchart TD

A["Python datetime"]
B["toordinal()"]
C["Unsupported markdown: list"]
D["MATLAB datenum"]
E["weather_datenum"]
F["Convert to Python datetime"]
G["Format as start_time string"]
H["Convert to seconds from start"]

D --> E

subgraph subGraph1 ["Weather Processing"]
    E
    F
    G
    H
    E --> F
    F --> G
    G --> H
end

subgraph subGraph0 ["Python Processing"]
    A
    B
    C
    D
    A --> B
    B --> C
    C --> D
end
```

The conversion process in `run_green_light`:

1. Extract weather datenum: `weather_datenum = weather[0, 0]`
2. Convert to Python datetime with timezone adjustment
3. Format as string: `'01-Jan-2005 01:00:00'` format
4. Normalize timestamps to seconds from simulation start

Sources: [gl_model.py L138-L152](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L138-L152)

 [gl_model.py L401-L438](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L401-L438)

### Datenum List Generation

The `generate_datenum_list` function creates timestamp sequences for artificial weather data:

```markdown
# Calculate number of 5-minute intervals
num_intervals = int(num_days * 24 * 60 * 60 / interval_secs)

# Generate datetime sequence
for i in range(num_intervals):
    current_datetime = start_datetime + timedelta(seconds=interval_secs * i)
    current_datenum = current_datetime.toordinal() + fractional_day
```

Sources: [gl_model.py L401-L438](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L401-L438)

## Supporting Weather Calculations

### CO2 Concentration Conversion

The `co2ppm2dens` function converts CO2 from parts per million to density using the ideal gas law:

```mermaid
flowchart TD

A["Input: Temperature [°C], PPM"]
B["Ideal Gas Law: pV = nRT"]
C["P = 101325 Pa<br>R = 8.3144598 J mol⁻¹ K⁻¹<br>M_CO2 = 44.01e-3 kg mol⁻¹"]
D["co2Dens = P × 10⁻⁶ × ppm × M_CO2 / (R × (temp + 273.15))"]
E["Output: CO2 Density [kg m⁻³]"]

A --> B
B --> C
C --> D
D --> E
```

Sources: [gl_model.py L331-L356](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L331-L356)

### Daily Light Sum Calculation

The `day_light_sum` function calculates cumulative daily solar radiation:

1. **Interval Detection**: Calculate time intervals between measurements
2. **Midnight Detection**: Find day boundaries using `np.diff(np.floor(time))`
3. **Daily Integration**: Sum radiation values within each 24-hour period
4. **Unit Conversion**: Convert from W m⁻² to MJ m⁻² day⁻¹

```mermaid
sequenceDiagram
  participant day_light_sum()
  participant Time Array
  participant Radiation Array

  day_light_sum()->>Time Array: "Calculate intervals"
  Time Array->>day_light_sum(): "interval = (time[1] - time[0]) * 86400"
  loop ["For each timestamp"]
    day_light_sum()->>Time Array: "Find midnight boundaries"
    day_light_sum()->>Radiation Array: "Sum radiation[mn_before:mn_after]"
    Radiation Array->>day_light_sum(): "Daily radiation sum"
  end
  day_light_sum()->>day_light_sum(): "Convert to MJ m⁻² day⁻¹"
```

Sources: [gl_model.py L358-L399](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L358-L399)

## Weather Data Integration

### Processing Pipeline

The complete weather processing pipeline in `run_green_light`:

1. **Data Loading**: Load EnergyPlus data or generate artificial data
2. **Format Conversion**: Convert to numpy array with float64 precision
3. **Elevation Extraction**: Extract elevation from 10th column if present
4. **Timestamp Processing**: Convert datenum to seconds from simulation start
5. **Matrix Preparation**: Format for MATLAB `createGreenLightModel` function

```mermaid
flowchart TD

A["Weather Input"]
B["Load/Generate Data"]
C["np.array(weather, dtype=float64)"]
D["Extract elevation"]
E["Process timestamps"]
F["createGreenLightModel(lamp_type, weather, start_time)"]

subgraph subGraph0 ["run_green_light Processing"]
    A
    B
    C
    D
    E
    F
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
end
```

Sources: [gl_model.py L99-L155](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L99-L155)

### Error Handling and Defaults

The system provides robust defaults for missing or invalid weather data:

* **Missing Weather**: Defaults to 5-day artificial dataset
* **Missing Elevation**: Defaults to 0 meters above sea level
* **Invalid Lamp Type**: Defaults to "none"
* **Empty Filename**: Simulation runs without saving output

Sources: [gl_model.py L114-L128](https://github.com/greenpeer/GreenLightModel/blob/98b32e39/gl_model.py#L114-L128)