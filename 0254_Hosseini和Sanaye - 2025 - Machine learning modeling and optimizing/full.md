# Machine learning modeling and optimizing of greenhouse climate conditions

Seyed Aliakbar Hosseini, Sepehr Sanaye

# ARTICLEINFO

Keywords: Controlled environment agriculture (CEA) Machine learning optimization Greenhouse Irrigation management  $\mathrm{CO_2}$  enrichment Artificial lighting Humidification/Dehumidification

# ABSTRACT

Enhancing food security and increasing production efficiency can be achieved by adjusting various operating parameters in greenhouses that influence plant growth. These parameters include temperature, irrigation scheduling, humidity, supplemental carbon dioxide, sunlight exposure, and the use of artificial lighting on cloudy or low- light days. This study presents the results of an Artificial Neural Network- accelerated dynamic greenhouse model, which, for the first time, considers all of these parameters together and enables optimization of operational conditions based on minimizing the cost per kilogram of tomato yield over the cultivation period. The selected design variables are daytime temperature (for both day and night with artificial lighting), nighttime temperature (during the dark period), relative humidity, and carbon dioxide concentration. The use of the ANN reduced computation time considerably. Compared to typical greenhouse environmental settings (day time temperature  $= 22^{\circ}\mathrm{C}$ , night time temperature  $= 18^{\circ}\mathrm{C}$ , relative humidity  $= 80\%$ ,  $\mathrm{CO_2}$  concentration  $= 800$  ppm), the optimized environmental settings reduced production cost by  $6\%$ , lowering it from  $0.50\mathbb{S}.\mathrm{kg}^{- 1}$  to  $0.47\mathbb{S}.\mathrm{kg}^{- 1}$ . The optimum values of the objective function and design variables are  $0.47\mathbb{S}.\mathrm{kg}^{- 1}$ ,  $23.7^{\circ}\mathrm{C}$  for daytime temperature,  $16^{\circ}\mathrm{C}$  for nighttime temperature,  $68.2\%$  RH, and  $627.7$  ppm  $\mathrm{CO_2}$  concentration.

# Introduction

The human population is projected to surpass 9 billion by 2050 [1]. One of the major global concerns is the increasing demand for food, which is a direct result of population growth, urbanization, and drastic weather changes. Rising population levels, shifts in dietary habits, and continued economic growth are anticipated to drive a  $30 - 50\%$  increase in global demand for food, water, and energy within the next 10 years. Moreover, ensuring adequate access to these essential resources is explicitly addressed in three of the Seventeen United Nations Sustainable Development Goals (SDGs) set for achievement by 2030 [2]. Therefore, it is imperative to implement innovative solutions and adopt sustainable agricultural practices to effectively tackle this challenge. In recent years, controlled environment agriculture (CEA) has emerged as a promising solution for increasing food production efficiency to meet the rising global demand. By utilizing commercial greenhouses instead of traditional open- field cultivation, a viable solution can be provided to address this crucial issue.

In the commercial greenhouse, the off- season production, crop protection against sudden weather fluctuations and insects is possible. In comparison with the conventional open- field cultivation method, a commercial greenhouse has almost 10 times higher production efficiency, but its energy consumption is significantly higher [3]. Today, advancements in greenhouse technologies have pushed science- based solutions for optimal plant production by regulating internal climate growing factors such as temperature, light intensity, and  $\mathrm{CO_2}$  concentration [4]. Maintaining optimal parameter values within the greenhouse is crucial for enhancing production and crop quality, which results in high energy demands in controlled environments. Hence, it is crucial to examine air conditioning (heating or cooling), irrigation scheduling, humidification or dehumidification,  $\mathrm{CO_2}$  enrichment, and lighting throughout the crop growth cycle, taking into account the specific requirements of the cultivated plants. This is essential for two reasons: firstly, the climate conditions inside the greenhouse differ from the external environmental conditions, and secondly, continuous adjustments of environmental parameters are necessary due to the growth of the plants [5].

# Energy research related literature

The energy costs associated with greenhouse agricultural production

# Nomenclature

Symbols A Surface area  $(\mathrm{m^2})$ $\mathrm{A_{p}}$  Planting area  $(\mathrm{m^2})$  C Total cost  $(\Phi)$ $\mathbb{C}_{\mathrm{i}}$  Indoor  $\mathrm{CO_2}$  concentration  $(\mathrm{gCO_2.m^{- 3}})$ $\mathbb{C}_{\mathrm{in}}$ $\mathrm{CO_2}$  injection  $(\mathrm{gCO_2.m^{- 2}.h^{- 1}})$ $\mathbb{C}_0$  Outdoor  $\mathrm{CO_2}$  concentration  $(\mathrm{gCO_2.m^{- 3}})$ $\mathbb{C}_{\mathrm{inf}}$ $\mathrm{CO_2}$  exchange through leakage  $(\mathrm{gCO_2. m^{- 2}.h^{- 1}})$ $\mathbb{C}_{\mathrm{vent}}$ $\mathrm{CO_2}$  exchange ventilation  $(\mathrm{gCO_2. m^{- 2}.h^{- 1}})$ $\mathbb{D}_{\mathrm{e}}$  cumulative depth of evaporation (depletion) from the soil surface layer  $(\mathrm{mm})$ $\mathbb{D}_{\mathbb{r}}$  cumulative depth of evaporation (depletion) from the soil surface layer  $(\mathrm{mm})$ $\mathbb{E}_{\mathbb{C}}$  Inside cover surface condensation  $(\mathrm{kg.m^{- 2}.h^{- 1}})$ $\mathrm{E_{in}}$  Humidification/dehumidification  $(\mathrm{kg.m^{- 2}.h^{- 1}})$ $\mathrm{E_{inf}}$  Moisture exchange through leakage  $(\mathrm{kg.m^{- 2}.h^{- 1}})$ $\mathrm{E_{p}}$  Plant's evapotranspiration  $(\mathrm{kg.m^{- 2}.h^{- 1}})$ $\mathrm{E_T}$  Plant's evapotranspiration  $(\mathrm{kg.m^{- 2}.day^{- 1}})$ $\mathrm{ET_0}$  reference crop evapotranspiration  $(\mathrm{mm. day^{- 1}})$  Event Moisture exchange through ventilation  $(\mathrm{kg.m^{- 2}.h^{- 1}})$ $\mathbb{C}_{\mathrm{s}}$  Air water vapor pressure at saturation (kPa)  $\mathbb{C}_{\mathrm{i}}$  Air water vapor partial pressure (kPa) G Soil heat flux density  $(\mathrm{W.m^{- 2}})$  Gr Grashof number  $\mathrm{GR}_{\mathrm{net}}$  Net aboveground growth rate (gdryweight.  $\mathrm{m^{- 2}.h^{- 1}}$ $\mathbf{h}$  Convective heat transfer coefficient  $(\mathrm{W.m^{- 2}.C^{- 1}})$ $\mathbf{h}_{\mathrm{g}}$  Greenhouse height  $(\mathbf{m})$  Iled Electrical energy input to the lamps  $(\mathrm{W.m^{- 2}})$ $\mathrm{I_{sol}}$  Solar radiation  $(\mathrm{W.m^{- 2}})$ $\mathbf{k}_{\mathrm{sol}}$  Thermal conductivity of soil  $(\mathrm{W.m^{- 2}.C^{- 1}})$  1 Depth of first soil layer  $(\mathbf{m})$  LAI Leaf area index  $(\mathrm{m^2leaf.m^{- 2}ground})$ $\mathbb{L}_{\mathrm{e}}$  Mean pass length of beam radiation M Mass  $(\mathrm{kg})$  m Mass flow rate  $(\mathrm{kg.s^{- 1}})$  N Node number (node)  $\mathrm{P_g}$  Gross photosynthesis  $(\mathrm{gCO_2.m^{- 2}.h^{- 1}})$ $\mathrm{P_{gmax}}$  Maximum leaf photosynthetic rate  $(\mu \mathrm{mole.m^{- 2}.s^{- 1}})$

PPFD Photon Flux Density  $(\mu \mathrm{mole.m^{- 2}.s^{- 1}})$  Q Heat flux (W)  $\mathbb{Q}_{\mathrm{irr}}$  Water demand for irrigation  $(\mathrm{mm})$  qinf Air flow rate due to infiltration  $(\mathrm{m^3.h^{- 1}})$ $\mathbb{q}_{\mathrm{V}}$  Air flow rate due to ventilation  $(\mathrm{m^3. h^{- 1}})$ $\mathbb{R}_{\mathrm{m}}$  Maintenance respiration  $(\mathrm{gCO_2. m^{- 2}.h^{- 1}})$ $\mathbb{R}_{\mathrm{n}}$  Net radiation at the crop surface  $(\mathrm{W.m^{- 2}})$  T Temperature (C)  $\mathrm{V_{g}}$  Greenhouse volume  $(\mathrm{m^3})$ $\mathbb{V}_{\mathrm{g}}$  Outdoor wind speed  $(\mathrm{m.s^{- 1}})$  W Plant aboveground dry weight (gdryweight.  $\mathrm{m^{- 2}}$ $\mathrm{W_{f}}$  Total fruit dry weight (gdryweight.  $\mathrm{m^{- 2}}$  W Mature fruit dry weight (gdryweight.  $\mathrm{m^{- 2}}$ $\mathbf{X}\mathbf{i}$  Absolute water vapor concentration  $(\mathrm{kg.m - 3})$ $\mathbb{Z}_{\mathrm{r}}$  Rooting depth (m)

# Greek symbols

$\mathfrak{n}$  Solar radiation fraction that is absorbed by components  $\mathfrak{p}$  Reflectivity coefficient  $\mathfrak{p}_{\mathfrak{p}}$  Plant density (plant.  $\mathrm{m^{- 2}}$ $\beta_{\mathrm{st}}$  Reflectance of the plant stand  $\beta_{\mathrm{W}}$  Water density  $(\mathrm{kg.m^{- 3}})$ $\tau$  Transmissivity coefficient

# Subscripts

a Air ca Canopy C Cover rand Conduction conv Convection f Fruit i Inside of greenhouse inf infiltration led Light emitting diode (LED) o Outside of greenhouse p Plant sb Bar soil sol Solar trans Transpiration v ventilation

are substantial on a global scale [6]. Vadiee and Martin [7] conducted a study to analyze the energy requirements of two distinct types of greenhouses: closed greenhouses and conventional greenhouses. Closed greenhouses are specifically designed to maximize the utilization of solar energy by incorporating seasonal storage to retain excess heat during warmer seasons for use in colder seasons [8]. Conventional greenhouses are equipped with natural ventilation systems. The researchers utilized the TRNSYS software to evaluate the energy demands of these greenhouses. Their findings indicated that the heating demand of closed greenhouses is approximately five times lower than that of conventional ones. Building upon this, Abdarabouh et al. [9] developed a sustainable model of a renewable energy- based greenhouse equipped with cooling, ventilation, and shading systems. Mohebi and Roshandel [10] proposed a solar hybrid energy system with long- and short- term storage components under Tehran's climate. They found that increasing the solar collector area by  $70.5\%$  reduced the carbon emission rate by  $30\%$ . Similarly, Tafuni et al. [11] proposed a low- cost seasonal storage system based on gravel and water, reducing cost by  $28\%$  compared to water- only storage.

To better understand the interaction between crop growth and energy demand, Golzar et al. [12] developed an integrated model between plant growth and energy consumption. In a follow- up, Golzar et al. [13] minimized greenhouse production costs through integration of an energy- yield model and an economic model. The optimization findings revealed that considering the actual (non- subsidized) fuel price, instead of the subsidized rate, led to the selection of more energy- efficient technologies and lower temperature endpoints, which in turn resulted in a  $70\%$  reduction in energy consumption and a  $19\%$  decrease in climate change impacts. Furthermore, Mahmood et al. [14] conducted a study evaluating a tomato greenhouse in Qatar. The primary objective was to enhance cost- efficiency in greenhouse production using a single objective optimization approach. The findings of their investigation demonstrated that the optimal cost of greenhouse production was determined to be  $2.7\mathrm{~\AA~}\mathrm{kg}^{- 1}$ . In the experimental study conducted by Singh et al. [15], temperature measurements of different components within a greenhouse—such as plants, indoor air, soil, and the greenhouse covering—were recorded on a specific day. The researchers then extended the mathematical model to predict the instantaneous temperature distribution of these elements, accounting for energy exchange among components and between indoor and outdoor environments. According to the report provided by Nederhoff [16], tomato plants faster at higher daytime temperatures and lower nighttime temperatures. The height of plants more than doubled, and the leaf surface became  $18\%$  larger. Reversing this pattern (higher temperatures at night) had a

negative effect on plant growth.

# Water research related literature

Water research related literatureExcessive air humidity creates an ideal environment for pest and disease incidence [17]. On the contrary, low indoor RH can cause plant tissues to wither. To have favorable internal air humidity, humidification or dehumidification may be necessary. Crop evapotranspiration is a key variable for optimization of irrigation water productivity and designing irrigation scheduling in agriculture water management. Rahman et al. [18] created the DehumReq model to forecast dehumidification loads through a full heat and mass balance, accounting for plant transpiration, condensation, and infiltration. Al Miaari et al. [19] proposed an air treatment system that kept RH between  $61 - 96\%$  and temperature between  $24 - 29.5^{\circ}C$  in Lebanon. Taheri et al. [20] validated the real- time variations in temperature and humidity inside a tomato greenhouse in Iran during the months with the highest and lowest temperatures. This assessment was based on laboratory data. The researchers determined the water consumption for evaporative cooling and the energy demands of the greenhouse in different regions of Iran, considering the transpiration of the plants. Harmanto et al. [21] showed that tomato cultivation in greenhouses with drip irrigation uses  $20 - 25\%$  less water than in open fields. These studies demonstrate a shared goal: optimizing internal water use while preserving environmental balance.

# Carbon dioxide research related literature

Carbon dioxide research related literatureThe majority of plant species do not achieve their maximum photosynthetic capacity under typical atmospheric  $\mathrm{CO_2}$  levels [22]. Photosynthesis is a process in which light energy drives a chemical reaction between water and carbon dioxide  $(\mathrm{CO_2})$ , resulting in the production of sugar, which serves as food for plants [23]. Grasping how environmental  $\mathrm{CO_2}$  levels affect photosynthetic rates is crucial for optimizing plant growth across different agricultural environments. Nasrabadi et al. [24] proposed capturing emissions from a nearby gas turbine power plant and injecting it into greenhouses. Their findings indicated a  $50\%$  reduction in carbon emissions. Calegario et al. [25] measured the instantaneous respiration rate of tomato plants by the use of a continuous- flow method with a conductometric detector. The process involved placing the fruit in a chamber where the  $\mathrm{CO_2}$  produced during respiration passes through a Teflon membrane, dissolved in deionized water, and its conductivity was monitored. Their results showed a relative error of  $3\%$  at a  $\mathrm{CO_2}$  level of  $589~\mathrm{ppm}$ . Hidaka et al. [26] experimentally showed that localized  $\mathrm{CO_2}$  enrichment increased strawberry fruit weight by  $10 - 26\%$ . Akhlaq et al. [27] determined that  $700~\mathrm{ppm}$  was the optimal  $\mathrm{CO_2}$  concentration for improving tomato yield, fruit quality, and water use efficiency.

# Light research related literature

Light research related literatureIn conditions where natural sunlight is inadequate, the use of artificial lighting can significantly improve plant growth and productivity. Supplemental lighting is crucial for greenhouse crops during overcast and low- light days to ensure that they receive sufficient daily light exposure [28]. The critical segment of the light spectrum, ranging from 400 to  $700~\mathrm{nm}$ , is commonly known as photosynthetically active radiation (PAR). This range, which lies within the visible spectrum of sunlight, is highly beneficial for the biological growth of plants [29]. Tomatoes exhibit reduced growth in shaded environments. However, they balance this by augmenting leaf size, thereby enhancing the efficiency of light utilization and sustaining their growth [30]. In an experimental research, Zheng et al. [31] showed that photosynthetic rate peaked at a PPFD of  $240\mu \mathrm{mol}\cdot \mathrm{m}^{- 2}\cdot \mathrm{s}^{- 1}$ , with no further increase beyond this threshold. Katzin et al. [32] showed that replacing high pressure sodium (HPS) with LED lighting reduced energy use by 10- 25  $\%$ , while Kuijpers et al. [33] reported a  $30\%$  decrease in carbon emissions by switching greenhouse lighting from HPS to LED.

# Machine learning research related literature

As agricultural sustainability becomes increasingly urgent under climate change, greenhouse cultivation offers a pathway to ensure stable crop yields and efficient resource use. However, optimizing the complex interplay between environmental factors- such as temperature, humidity,  $\mathrm{CO_2}$  solar radiation, and irrigation- and plant physiology remains a major challenge. Historically, mechanistic models such as TOMOGRO and TOMSIM have been used to simulate tomato crop development under controlled environments. These models often focus on dry matter accumulation, leaf area dynamics, and temperature- light $\mathrm{CO_2}$  interactions [34- 35].

Despite their robustness, such models are rarely implemented in full across all interdependent systems due to computational burdens and the difficulty of modeling coupled heat, mass, and physiological processes over extended cultivation periods. Thus, most existing works simplify the greenhouse system by isolating subsystems- like microclimate forecasting (Sun and Chang [36]), energy consumption (Hoseinzadeh and Garcia [37]), or yield prediction (Oietus and Anagu [38])without integrating full system dynamics or operational economics.

To address these limitations, recent studies have explored the use of ANNs as surrogate models. ANNs have shown promise in forecasting internal greenhouse parameters with high accuracy and computational efficiency. For example, Sun and Chang [36] developed a hybrid Dynamic Factor- Random Forest- Artificial Neural Network (DF- RF- ANN) model that combined dynamic factor analysis, random forest- based feature selection, and a backpropagation neural network to predict internal temperature, RH, PAR, and  $\mathrm{CO_2}$  levels using external weather data. Their model reduced reliance on sensor infrastructure and achieved higher prediction accuracy compared to baseline backpropagation and long short- term memory (LSTM) models.

In another study, Hoseinzadeh and Garcia [37] applied Radial Basis Function (RBF) networks and ANNs during the Autonomous Greenhouse Challenge to estimate real- time values of total  $\mathrm{CO_2}$  use, heating demand, crop production, and plant transpiration. Their results demonstrated that data- driven models could effectively track dynamic cropenvironment interactions and support climate strategy optimization throughout the growth cycle. Specifically, the optimized RBF model achieved an  $\mathbb{R}^2$  of 0.98 and a RMSE of just 0.8 in forecasting tomato yield per square meter.

Cletus and Anagu [38] conducted a comparative analysis of multiple machine learning models- including ANNs, Bi- directional Long ShortTerm Memory Bi- LSTM), Gradient Boosting Machine GBM), and Random Forest- for greenhouse microclimate prediction. Their findings indicated that ANNs consistently achieved the highest prediction accuracy  $(\mathrm{R}^2\approx 0.999999)$  for both temperature and humidity, with the lowest mean squared error, demonstrating superior modeling fidelity.

However, while these studies confirm the value of ANNs in forecasting environmental conditions, they generally omit the integration of dynamic crop physiology, energy and mass balances, and economic cost modeling. In contrast, the present study develops a fully coupled, ANN- accelerated dynamic greenhouse model that enables optimization of operational conditions based on minimizing the cost per kilogram of tomato yield.

# Content and novelties

Content and noveltiesAs implied in the literature review, the effects of various factors are studied regarding the plant growth in greenhouses. Maintaining the required temperature through heating or cooling, irrigation scheduling and humidity management through humidification or dehumidification are some of those parameters. Other important factors include supplemental  $\mathrm{CO_2}$  injection, sunlight exposure (or the use of artificial lighting during cloudy or low- light periods), and impact of local outdoor

environmental conditions. It should be mentioned that evaluating temperature differences between greenhouse components (such as humid air, plants, soil, and greenhouse cover) and examining the effects of photosynthesis and plant respiration over time also affect the dynamic behavior of crop growth and its coverage. Considering the plant respiration leads to reducing supplemental  $\mathrm{CO_2}$  injection because the respiration process increases  $\mathrm{CO_2}$  levels in the environment [25]. Additionally, incorporating the temperatures of the greenhouse soil and the glass cover allows for accurate estimation of heat loss from the floor and from the glass cover to the outside environment, respectively [39]. Furthermore, accounting for the condensation of water droplets on the inner surface of the greenhouse glass cover reduces the greenhouse dehumidification load, as condensation decreases air humidity within the greenhouse. Moreover, considering soil water evaporation leads to a reduction in soil moisture levels, enabling precise estimation and determination of irrigation scheduling and water demand [40]. However, no reference was found to model all these factors simultaneously in an integrated and dynamic manner. The integration of physiology, microclimate, resource balance, and economics into a unified surrogate- based optimization framework has not been addressed in prior research. Thus, modeling and optimizing the requirements of heating, water, humidification, dehumidification,  $\mathrm{CO_2}$  injection, and artificial lighting during one full tomato cultivation period in the controlled solar greenhouse are investigated. A comprehensive modeling research document for controlled greenhouse indoor conditions, considering the simultaneous effects of the following detailed areas, was not found in existing literature:

- The process of plant respiration and the assessment of supplemental carbon dioxide requirements. 
- The determination of water requirements and the scheduling of irrigation. 
- The impact of different soil and greenhouse cover temperatures relative to the indoor air temperature which has significant effect on modeling results of the system. This interaction effects of different greenhouse component temperatures (such as the cover, plants, soil, and moist air temperatures) during the growth period have to be estimated for reaching more accurate system modeling. 
- Furthermore, estimation of multiple reflection effects of solar radiation among the greenhouse components, as well as the effects of plant growth, coverage, and shading on heat loss from the floor and greenhouse cover are also necessary for more accurate results of system modeling.

The notice to the above important detailed items, made the following novelty for the current research:

- Development of a dynamic plant growth model that captures key environmental factors and estimates resource requirements throughout the cultivation cycle. Hourly estimation of soil temperature and floor heat loss, considering plant shading effects throughout the growth period. Hourly estimation of greenhouse cover temperature to assess water condensation and thermal losses during a growth cycle. Use of an ANN surrogate model for fast, accurate optimization of production cost and key environmental parameters.

# Methods

In the current research, a greenhouse with tomato plant is analyzed (Fig. 1). The crop growth and photosynthesis occurred under the sun and artificial LED lighting. By developing comprehensive modeling and optimization processes, the optimal values of greenhouse environmental parameters at local climate conditions including temperature, humidity,  $\mathrm{CO_2}$  concentration, along with the requirements for heating, water, humidification, dehumidification, supplemental  $\mathrm{CO_2}$ , and artificial lighting are obtained throughout the entire cultivation period. It should be mention that cooling is omitted because the study specifically focuses on off- season tomato cultivation during a 200- day period from October 10 to April 30, which corresponds to the cold months in Tehran's climate. During this period, outdoor temperatures are consistently low, and simulation results confirmed that the cooling load is negligible or near zero. Therefore, only heating requirements are considered relevant for modeling and optimization.

![](images/4fa31b6ae5251072d70fbda5c84887e4f80b6896403cc95a91197dcd94ea8d94.jpg)  
Fig. 1. Schematic overview of controlled solar greenhouse.

# System modeling

Five subsections are applied for mathematical modeling of crop growth, air  $\mathrm{CO_2}$ , irrigation, air humidity, and energy as explained in Appendix A.

The comprehensive dynamic modeling flow diagram, as illustrated in Fig. 2, comprises two temporal loops: hourly and daily. The mathematical relationships between these equations over time show that four key parameters—LAI, plant weight, fruit dry weight, and mature fruit dry weight—along with irrigation, are determined daily by solving specific equations related to LAI, fruit dry weight, mature fruit dry weight, and soil water balance, respectively.

On an hourly basis, parameters such as temperatures of the cover, plant surface, and soil, heating requirements, humidification or dehumidification,  $\mathrm{CO_2}$  enrichment, and the number of nodes, are derived by solving seven crucial equations. These include the greenhouse cover energy balance, plant energy balance, soil energy balance, air energy balance, air humidity balance, air  $\mathrm{CO_2}$  balance, and an equation related to node development. These equations incorporate heat and mass transfer calculations as well as crop node development dynamics.

In this comprehensive study, a total of 13 equations are solved simultaneously to ensure precise modeling and prediction of greenhouse environmental conditions and crop growth dynamics. The physical properties of the greenhouse structure, physiological characteristics of the plant, and the conditions of both the external and internal environments are used as inputs for this dynamic modeling, ensuring accurate control and optimization of the greenhouse environment.

![](images/6f503e71a10b907ecec7d7995e4bda4676c843336047f98f7b4b05724fc21539.jpg)  
Fig. 2. Flowchart of comprehensive dynamic modeling of greenhouse.

# Artificial neural network

Given the time- intensive nature of comprehensive modeling and optimization, an ANN is utilized to reduce computation time. Subsequently, the ANN is coupled with a Genetic Algorithm (GA) to optimize greenhouse environmental conditions, enhancing crop production and reducing operational costs.

The ANN is utilized in this research for comprehensive modeling of greenhouse analysis. This supervised learning method involves training an algorithm on a dataset with corresponding input and output data to

learn a function that maps the input values to the output values [41]. According to Fig. 3. (a), about 3,000 sets of data points (randomly generated within the lower and upper range of each design variable) and 3,000 sets of data points for the objective function (corresponding to each set of input data) have been generated through MATLAB software. These data were employed to train the complex behavior of the comprehensive model by the neural network. Fig. 3. (b) shows that all 3,000 random data points of each design parameter were used as input data for the ANN, while the corresponding random data for production cost were the output data for ANN training.

The 3,000 data points refer to randomly generated combinations of four design (decision) variables: daytime temperature, nighttime temperature, RH, and  $\mathrm{CO_2}$  concentration. These variables were sampled within defined upper and lower bounds. For each of these 3,000 cases, the values were held constant throughout the 200- day cultivation period, and the dynamic model was run to simulate crop growth, energy and resource use, and yield under those specific conditions. Key time- dependent physiological variables such as LAI, dry matter accumulation, photosynthesis, and transpiration were updated daily/hourly within the simulation. This process resulted in 3,000 full- run simulations, each producing a corresponding objective function value (i. e., cost per kilogram of tomato yield). The resulting dataset- consisting of input variables and simulated performance- was then used to train the ANN as a surrogate model.

The ANN algorithm processes input data through multiple layers to model complex relationships. Hidden layers between the input and output layers consist of neurons that capture intricate patterns and improve predictive accuracy. Hidden neurons within each layer perform computations, apply transfer functions, and pass outputs to the next layer. The number of neurons determines the network's ability to model complex patterns without overfitting. Transfer functions introduce nonlinearity, enabling the model to represent complex data relationships. Common functions include the Log- Sigmoid for hidden layers and Purelip for the output layer, providing linear outputs. These elements are crucial for accurately modeling input- output relationships and enhancing the network's predictive capabilities.

# Optimization of greenhouse environmental conditions by genetic algorithm

For comprehensive and complex modeling of the solar greenhouse

![](images/350b7f2ceaf8c9feed9b0369fbe263fb52f54f8896d9c6c59e1e08eeb81b8f43.jpg)  
Fig. 3. Summary of ANN modeling and optimization procedures.

climate, GA offer several distinct advantages over other optimization techniques. GA is highly effective in handling non- linear and multidimensional problems, making them well- suited for intricate models involving energy balance, humidity,  $\mathrm{CO_2}$  levels, soil water balance, and crop growth. Unlike gradient- based methods, which require smooth and differentiable objective functions, GA can optimize functions that are discontinuous or have many local optima. As a population- based stochastic algorithm inspired by biological evolution, GA evaluates the fitness of each candidate solution and iteratively generates new populations through selection, crossover, and mutation, guiding the search toward optimal or near- optimal solutions [42].

To enhance the performance of GA and prevent them from getting stuck in local optima, several strategies have been employed. These steps involve expanding the population size, employing crossover and mutation techniques, crafting a suitable fitness function, and conducting multiple iterations with varying initial populations [43]. These strategies ensure a thorough exploration of the solution space and improve the likelihood of achieving an optimal solution. The GA tuning parameters (e.g., population size, crossover rate, mutation function) used in this study were selected based on a trial- and- error process. Multiple combinations were tested to balance solution accuracy and computational efficiency, and the final values listed in Table 6 were those that led to stable convergence without premature stagnation.

In this regard, single- objective optimization is examined by defining operational costs per unit weight of products by GA (Fig. 3. c). The optimization process is developed to identify optimal environmental parameters (temperature, humidity, and carbon dioxide concentration) with the aim of minimizing the objective function. The operation cost is the total cost of natural gas for greenhouse heating by boiler, water for humidification and irrigation,  $\mathrm{CO_2}$  for  $\mathrm{CO_2}$  enrichment, and electricity for supplemental lights. Constraints and limitations for decision variables are provided in Table 1.

A general overview of the greenhouse environmental modeling, developing ANN equivalent model, and optimization of the process is briefly depicted in Fig. 3.

# Uncertainty analysis

To ensure the accuracy and reliability of the reported outcomes, an uncertainty analysis is conducted based on typical sensor error margins despite the study not relying on direct sensor measurements to assess how such inaccuracies could influence key simulation outputs. This analysis helps in understanding the potential errors and their impact on the overall measurements, especially considering that uncertainties in real- world systems can arise from various sources, including input fluctuations, sensor inaccuracies, and parameter variability [44]. The relative uncertainty in crop growth parameters is estimated by the use of Eq. (1)

$$
A = f(x_{1},x_{2},\dots ,x_{n})
$$

$$
\sigma_{A} = \pm \sqrt{\sum_{i = 1}^{n}\left(\frac{\partial A}{\partial x_{i}}\sigma_{x_{i}}\right)^{2}} = \pm \sqrt{\left(\frac{\partial A}{\partial x_{1}}\sigma_{x_{1}}\right)^{2} + \left(\frac{\partial A}{\partial x_{2}}\sigma_{x_{2}}\right)^{2} + \dots + \left(\frac{\partial A}{\partial x_{n}}\sigma_{x_{n}}\right)^{2}}
$$

where,  $\sigma_{\mathrm{A}}$  is the combined standard uncertainty. A is the result of the measurement.  $\mathbf{x}_{\mathrm{i}}$  are the individual measurements.  $\sigma_{\mathrm{xi}}$  are the standard uncertainties of the individual measurements.

Table 1 Constraints and decision variable values.  

<table><tr><td>Range of values for decision variables</td><td>Constraints</td></tr><tr><td rowspan="2">20°C &amp;lt; daytimeT1 &amp;lt; 30°C</td><td>Heatingsupply ≥ Qin</td></tr><tr><td>Watersupply ≥ Qwater</td></tr><tr><td>12°C &amp;lt; nighttimeT1 &amp;lt; 20°C</td><td>CO2supply ≥ Cin</td></tr><tr><td>50% &amp;lt; RHc &amp;lt; 100%</td><td>Electricitysupply ≥ Iled</td></tr><tr><td>450ppm &amp;lt; Cc &amp;lt; 1150ppm</td><td>Electricitysupply ≥ Iled</td></tr></table>

As detailed in the crop growth modeling in Section A.1, mature fruit weight  $(\mathrm{Wm})$  is affected by several greenhouse environmental factors, including temperature,  $\mathrm{CO_2}$  concentration, light intensity, and relative humidity.

$$
W_{m} = f(CO_{2},I_{s},T_{i},RH)
$$

$$
w_{m} = \pm \sqrt{\left(\frac{\partial W_{m}}{\partial CO_{2}}\sigma_{CO_{2}}\right)^{2} + \left(\frac{\partial W_{m}}{\partial I_{s}}\sigma_{I_{s}}\right)^{2} + \left(\frac{\partial W_{m}}{\partial I_{i}}\sigma_{I_{i}}\right)^{2} + \left(\frac{\partial W_{m}}{\partial RH}\sigma_{RH}\right)^{2}}
$$

# Case study

To demonstrate the application of the proposed dynamic greenhouse modeling and optimization framework, tomato was selected as the target crop due to its sensitivity to environmental conditions, economic importance, and prevalence in controlled greenhouse production. The simulation in this study is for a semi- Quonset glass greenhouse with LED lighting and the geometry of  $25~\mathrm{m}$  long,  $8\mathrm{m}$  wide, and  $3.5\mathrm{m}$  high, located close to Tehran (35.7219N, 51.3347E) for growing tomatoes. The greenhouse is covered with  $4\mathrm{mm}$  of glass for roof and side walls. The LED lamp has a power of  $134~\mathrm{W.m^{- 2}}$  and irrigation is carried out using the drip technique in the current research. About 3.5 plants are transplanted per unit area. The cultivation period is 200 days from October 10 to April 30. Rest of the days are spent preparing and disinfecting the greenhouse for the subsequent cultivation. Also, because of hot weather and increasing open field products, controlled environment agriculture is not profitable in the warmer months.

# The price of natural gas, water, carbon dioxide and electricity

The price of natural gas, water,  $\mathrm{CO_2}$  and electricity for operational cost estimation are presented in Table 2.

General information regarding the tomato greenhouse environmental settings

Integrating the proposed model with existing greenhouse control systems involves utilizing advanced sensors and IoT devices to capture real- time data on temperature, humidity,  $\mathrm{CO_2}$  levels, soil water content and radiation. The ideal environmental conditions for tomato cultivation are according to Table 3.

The typical values of effecting parameters for environmental controlling cultivation of tomato crop in greenhouse are summarized below [12,32,40]:

The internal air temperature set points are maintained at  $22^{\circ}C$  during the day and  $18^{\circ}C$  at night. Internal air relative humidity is maintained at  $80\%$ $\mathrm{CO_2}$  is injected into a greenhouse environment in the presence of light, and the  $\mathrm{CO_2}$  setpoint is 800 ppm. Ventilation is applied under the following conditions: o Whenever internal air temperature exceeds the designated day/night temperature set points. During such ventilation, humidification and  $\mathrm{CO_2}$  injection are suspended.

Table 2 The price of natural gas, water,  $\mathrm{CO_2}$  and electricity for operational cost estimation [45,46].  

<table><tr><td>Formula</td><td>Parameter</td><td>Unit</td><td>Price</td></tr><tr><td>PCule = ∑PRuleQin</td><td>PFule</td><td>$kWh-1</td><td>0.0002</td></tr><tr><td rowspan="2">PCover = ∑PWater(Qir + Ein)</td><td>PWater</td><td>$m-3</td><td>0.008</td></tr><tr><td>ρw</td><td></td><td></td></tr><tr><td>PCover = ∑PCO2Cin</td><td>PCO2</td><td>$kg-1</td><td>0.1</td></tr><tr><td>PCover = ∑PCO2Cin</td><td>PCO2</td><td>$kWh-1</td><td>0.0018</td></tr><tr><td>PCover = ∑PElectricalityIed</td><td>PElectricality</td><td>$kWh-1</td><td></td></tr></table>

Table 3 Ideal environmental conditions for tomato crop.  

<table><tr><td>Environmental factor</td><td>Range [13]</td><td>Reason</td></tr><tr><td>Day time T1(C)</td><td>20–30</td><td>High temperatures damage tomato plant cells, reducing reproductive success, while low temperatures inhibit growth by slowing metabolic activities.</td></tr><tr><td>Night time T1(C)</td><td>14–20</td><td>The growth of tomato plants is faster at higher temperatures during the day and lower temperatures during the night.</td></tr><tr><td>RH (%)</td><td>50 – 100</td><td>High RH levels can create a conducive environment for fungal diseases, as excess moisture promotes the growth of pathogens. Conversely, low RH can lead to wilting and plant withering, as the plants may lose water more rapidly through transpiration.</td></tr><tr><td>CO2(ppm)</td><td>450—1150</td><td>CO2levels below 450 ppm can limit photosynthesis. Conversely, excessively high CO2levels can reduce stomatal conductance, negatively impacting plant water regulation and overall health.</td></tr><tr><td>Light intensity (MJ.m−2.day−1)</td><td>Up to 14</td><td>Additional light does not boost photosynthesis and may lead to photoinhibition, damaging the photosynthetic apparatus and reducing growth.</td></tr></table>

o Whenever indoor relative humidity exceeds the RH set point. However, the ventilation is forced to stop if indoor temperatures fall below the specified day/night temperature set points. The lamps operate for a maximum duration of  $18\mathrm{h}$  They are switched on whenever daily solar radiation was below  $14\mathrm{MJ.m^{- 2}}$ $\mathrm{day^{- 1}}$  and switched off when hourly solar radiation was above 600  $\mathrm{W.m^{- 2}}$  To avoid crop water stress, irrigation applies before or when the soil readily available water (RAW) is depleted.

# Weather input data

Fig. 4a and (b) display hourly solar radiation and the average temperature of Tehran throughout the cultivation period According to the Renewables.ninja dataset [47], the recorded maximum temperature reaches  $23.85^{\circ}C$  while the minimum temperature drops to  $- 8.43^{\circ}C$  with the average solar radiation  $170.57\mathrm{W.m^{- 2}}$  .Fig.5 presents the monthly average relative humidity values, which ranged from a maximum of  $56\%$  to a minimum of  $22.5\%$  using data sourced from the Iranian Meteorological Organization [48]. Furthermore, the highest and lowest average monthly ground temperatures  $23^{\circ}C$  in October and  $6^{\circ}C$  in January- were extracted and fitted from the data reported by

![](images/343a638aa136a2eeebfbe3a417842fa6a2de28b79ba7289bdc332a65ff2a34d7.jpg)  
Fig. 4. Tehran hourly (a) solar radiation and (b) ambient temperature [47].

![](images/d81e28e9be2733ee5d2b2681ab2311c468a088d3cfa066f1c3b4fc80bdf11bbc.jpg)  
Fig. 5. Tehran monthly average relative humidity and ground temperature [48,49].

Sanaye and Niroomand [49].

# Results and discussion

In this section, the model validation is investigated, showcasing its high accuracy and reliability. The next section demonstrates how the ANN provided a quick approximation model for the time- consuming standard model presented in various parts of Appendix A. Then, the sensitivity analysis is presented that highlights the impact of internal environmental factors on production cost (objective function). Optimization results are subsequently illustrated, demonstrating significant improvements in efficiency and performance. Additionally, a comparative analysis with previous studies underscores the superior accuracy and cost- efficiency of the current comprehensive dynamic model. Finally, an uncertainty analysis for the instrumentation measurements is conducted, ensuring robust and reliable findings.

# Validation of modeling results

In this section, validations are provided for crop growth models, solar radiation modeling received by the plant and soil, energy balance modeling, humidity balance modeling, and photosynthesis.

# Validation of crop growth modeling

To determine the validity of the developed modeling in the current

![](images/d6b86889532571a9b56be5059a9c443d41aa5758591ab37c3aa5fe66addb6480.jpg)

research, crop growth modeling results based on the equations (A.1) to (A.6) are compared with experimental results reported by Jones et al. [34], for similar plant growth input data (Table 4). Results show that the crop growth modeling results by current research has acceptable agreement with the experimental reports (Fig. 6).

# Validation of solar radiation modeling received by the plant and soil and energy balance

Fig. 7 (a) and (b) displays the proportion of solar radiation received by the plant and soil based on the equations 14 to 17 in Table A.8 with results reported at reference [39] respectively. Furthermore, Fig. 8 depicts the instantaneous distribution of temperature inside the greenhouse based on the equations A.11 to A.14 with experimental results reported at reference [50]. It is evident that the temperature is elevated during the noon hours. The data presented in these figures also show a good consistency with the current modeling results, with errors being less than  $5\%$  respectively.

# Validation of humidity balance modeling and crop photosynthesis

Fig. 9. (a) shows the accuracy of the current modeling results for humidity balance based on equation A.10 and Table A.6 with experimental results reported at reference [51]. Fig. 9(b) shows the plant photosynthesis based on the equation 7 in Table A.2 with experimental results reported at reference [52]. It is important to mention that the relative humidity decreases with rising the ambient temperatures because warmer air can hold more moisture, leading to a lower relative humidity even if the absolute moisture content remains constant. It is also clear that photosynthesis rates increase with the greater intensity of light observed around midday. The data presented in these figures also show good consistency with the current modeling results, with errors being less than  $5\%$

# Modeling results by artificial neural network

Table 5 presents the input parameters used for the ANN model. The dataset generation consists of 3000 instances, with 2100 used for training, 450 for testing, and 450 for validation. The ANN architecture includes 5 hidden layers with 8 neurons in each layer. Initial weights and biases are assigned randomly. The hidden layers utilize the Log- Sigmoid transfer function, while the output layer employs the Purelin transfer function. The learning rule applied is the Levenberg- Marquardt Back Propagation algorithm, known for its efficiency in training neural networks.

The final ANN architecture (5 hidden layers with 8 neurons each) was selected based on a trial- and- error approach. Multiple network structures were tested, including variations in the number of layers and neurons, using datasets of 1000, 2000, and 3000 samples. The selected configuration provided the best balance between prediction accuracy and generalization based on validation and test set performance.

To ensure a well- generalized ANN surrogate model, a comparative analysis was performed by training multiple network architectures with varying numbers of hidden layers (from 2 to 6) and neurons per layer (from 5 to 20). This process was repeated with different dataset sizes (1000, 2000, and 3000 samples) to evaluate sensitivity to training volume. The final architecture was selected based on its superior validation performance and generalization ability. Overfitting was mitigated through early stopping and performance tracking on separate validation and test sets. The final model achieved  $\mathbb{R}^2$  values above 0.99 on unseen data, confirming its robustness and predictive accuracy.

Table 4 Input data only for crop growth validation [34,35].  

<table><tr><td>Crop physiological properties</td><td>Value</td><td>Initial condition</td><td>Value</td></tr><tr><td>kF (node)</td><td>5</td><td>LAI (m2leaf.m-2ground)</td><td>0.003</td></tr><tr><td>Nb (node)</td><td>16</td><td>N (node)</td><td>2.4</td></tr><tr><td>NF (node)</td><td>10</td><td>W (gdryweight.m-2)</td><td>0.1</td></tr><tr><td>β (day-1)</td><td>0.0169</td><td>WF (gdryweight.m-2)</td><td>0</td></tr><tr><td>δ (m2leaf.node-1)</td><td>0.038</td><td>WM (gdryweight.m-2)</td><td>0</td></tr><tr><td></td><td></td><td>ρP (plant.m-2)</td><td>3.12</td></tr></table>

![](images/7712cff6b3a149a6fcc6fa7e6ebc2fca8223101e53ea5f681e738d52ea7593f0.jpg)  
Fig. 6. Validation of simulated crop dry weight (plant growth) over time based on the current dynamic model, compared with experimental results reported by Jones et al. [34].

To address the risk of overfitting, a systematic trial- and- error strategy was employed to tune the model architecture and evaluate its generalization capacity:

Multiple ANN architectures with different numbers of hidden layers and neurons per layer were trained. This was done using three different dataset sizes: 1000, 2000, and 3000 randomly generated data points, to test how the ANN responded to varying training volumes. For each case, the data was split into training  $(70\%)$ , validation  $(15\%)$ , and test  $(15\%)$  subsets. The best- performing model was selected based on validation performance, not just training error, to avoid overfitting. In all cases,  $\mathbb{R}^2$  and MSE were tracked on the test set to ensure good generalization, with the final model achieving  $\mathbb{R}^2 >0.99$

A well- trained surrogate model was achieved through this iterative architecture selection and dataset evaluation approach, without relying on overly deep or complex networks.

To clarify the accuracy of the ANN model, which is designed to train comprehensive modeling encompassing greenhouse components energy balance, humidity balance,  $\mathrm{CO_2}$  balance, soil water balance, and crop growth relations to estimate operational costs per product weight (objective function), the predicted values of the ANN model are compared with the results obtained by the current developed modeling. The mean squared error for training, test, and validation data are displayed in Fig. 10 (a). The ANN model met the best validation accuracy of 0.00023841 after epoch 580. According to Fig. 10 (b), the coefficient of determination  $(\mathbb{R}^2)$  for production costs is 0.9999. Therefore, this study clearly considers a well- trained ANN algorithm.

By utilizing the trained ANN for modeling of the greenhouse environmental conditions the run time for comprehensive modeling of greenhouse environmental conditions and the optimization process, reduced considerably. The ANN could emulate the behavior of the full model in a fraction of a second, enabling rapid evaluation of scenarios and efficient optimization.

![](images/1aefb6405dcc0f2ac4ea3df1db31b1e15f59b181db19ce08442758d1b3c66c59.jpg)  
Fig. 7. Validation of the modeling results with experimental findings for (a) the percentage of modeling solar radiation received by the plant and (b) the percentage of modeling solar radiation received by the soil with experimental results reported at reference [39]. The black and purple colors are for the curves in the left and right axes respectively. (For interpretation of the references to colour in this figure legend, the reader is referred to the web version of this article.)

![](images/2c16732ab8ee5e25533a7fae83acb5aa2d9b294bad133577a3fe1f1a7d6430fa.jpg)  
Fig. 8. The hourly temperature distribution inside the greenhouse with experimental results reported at reference [50]. The black and purple colors are for the curves in the left and right axes respectively. (For interpretation of the references to colour in this figure legend, the reader is referred to the web version of this article.)

# Sensitivity analysis

A sensitivity analysis is performed to identify the impact of varying environmental growing factors—specifically, changes of  $10\%$  in each parameter (daytime temperature, nighttime temperature, relative humidity, and  $\mathrm{CO_2}$  level)—affect the objective function (production costs). The effects of varying levels of these growth factors are compared against typical conditions suggested by the literature [12,32,40]. These typical conditions included a daytime temperature of  $22^{\circ}C$ , a nighttime temperature of  $18^{\circ}C$ , a relative humidity of  $80\%$ , a  $\mathrm{CO_2}$  concentration of  $800\mathrm{ppm}$ , and an artificial light intensity of  $134\mathrm{W.m^{- 2}}$ . Under these specified conditions, operational costs associated with the cultivation

Table 5 List of input parameter for ANN.  

<table><tr><td>Parameter</td><td>Values/Features</td></tr><tr><td>Dataset generation</td><td>3000</td></tr><tr><td>Number of training data</td><td>2100</td></tr><tr><td>Number of test data</td><td>450</td></tr><tr><td>Number of validation data</td><td>450</td></tr><tr><td>Number of hidden layers</td><td>5</td></tr><tr><td>Number of hidden neurons</td><td>8</td></tr><tr><td>Initial weights and bias values</td><td>Random</td></tr><tr><td>Transfer Function (hidden)</td><td>Log-Sigmoid</td></tr><tr><td>Transfer Function (output)</td><td>Power</td></tr><tr><td>Learning Rule</td><td>Levenberg-Marquardt Back Propagation</td></tr></table>

![](images/90560bebd45970d375a66d5fb368af6e718546e543a4c67fe1caed20f05e317c.jpg)  
Fig. 9. Validation of the developed modeling results with laboratory results for (a) the instantaneous distribution of relative humidity with experimental results reported at [51] and (b) plant photosynthesis with experimental results reported at reference [52]. The black and purple colors are for the curves in the left and right axes respectively. (For interpretation of the references to colour in this figure legend, the reader is referred to the web version of this article.)

![](images/2c07e1d14874e211a6d10eff4c7a32e9aa42b8fa33045c9fb07ef62589c86460.jpg)  
Fig. 10. ANN validation results: (a) MSE of ANN model and (b) Comparison between estimated data from present developed model and ANN predictions for the production cost.

process are determined to be  $1.36$ .  $\mathbb{S}.\mathrm{m}^{- 2}$  per cultivation cycle, with an expected crop yield of  $2.73\mathrm{kg}.\mathrm{m}^{- 2}$ , and production costs of  $0.5$ .  $\mathbb{S}.\mathrm{kg}^{- 1}$ . As indicates in Fig. 11, daytime and nighttime temperatures are found to play a crucial role in production costs. When daytime temperatures increased by  $10\%$  (to  $24.2^{\circ}\mathrm{C}$ ), a  $5.1\%$  increase in operational costs, amounting to  $1.43$ .  $\mathbb{S}.\mathrm{m}^{- 2}$ , is observed. However, this temperature elevation also led to a significant rise in crop yield by  $14.6\%$ , bringing it to  $3.13\mathrm{kg}.\mathrm{m}^{- 2}$ . Consequently, as temperature increases by  $10\%$ , crop yields are notably increased, even with the associated increase in heating costs, which results in a  $9.4\%$  reduction in production costs (objective function). The analysis shows that daytime and nighttime temperatures are the most influential parameters affecting the objective function, while variations in relative humidity and  $\mathrm{CO_2}$  concentration have a relatively smaller impact on production cost. This indicates that, within the optimization process, greater emphasis should be placed on the precise control and tuning of temperature variables, as they contribute more significantly to cost reduction. These findings validate the structure and priorities of the optimization strategy and confirm that the optimal environmental setpoints fall within the range where the system response is most sensitive and economically beneficial.

![](images/04fdc4a0eeaa9207d041ea89be97f976f5efb33ff9b91deea01383354b7a8a7f.jpg)  
Fig. 11. Effect of input parameters on production costs (objective function).

# Optimization results

In this section, the optimization results are presented, encompassing the optimum values of the objective function and design parameters. The findings cover crop photosynthesis and respiration, crop evapotranspiration and irrigation management, and an economic analysis of greenhouse operations.

# Optimum values of objective function and design parameters

The computations performed by the use of an Intel Core i9 12900 K processor with 24 virtual CPUs and 60 GB of RAM. The preliminary computation time for modeling results was about a minute; however, the estimated total computational time for optimization of the comprehensive modeling by MATLAB software was about  $83\mathrm{h}$ . With the application of a supervised machine learning approach, the time required for the optimization procedure decreased from  $83\mathrm{h}$  to  $2\mathrm{min}$ . Furthermore, generating data using the developed code in MATLAB software, which involved running 3,000 dynamic simulations, required approximately  $6\mathrm{h}$ . The optimization process run time was estimated based on the population size and the maximum number of generations. Although the maximum number of generations was set to 100, convergence was achieved after 50 generations. The GA tuning parameters for the converged results are listed in Table 6.

The optimal values of decision variables and the objective function are provided in Table 7.

The optimization framework was intentionally designed around constant environmental setpoints inside the greenhouse to maintain a simple tracking setpoint while capturing realistic, system- wide performance over the 200- day growing season. These setpoints fall within agronomically and operationally realistic ranges. The greenhouse's autonomous subsystems (e.g., heating, dehumidification,  $\mathrm{CO_2}$  injection, artificial lighting) operate dynamically to maintain internal conditions

Table 6 List of GA tuning parameters.  

<table><tr><td>Option</td><td>Values/Features</td></tr><tr><td>Population size</td><td>300</td></tr><tr><td>Crossover fraction</td><td>0.9</td></tr><tr><td>Function tolerance</td><td>10-6</td></tr><tr><td>Maximum generation</td><td>100</td></tr><tr><td>Elit count</td><td>30</td></tr><tr><td>Max stall generations</td><td>50</td></tr><tr><td>Number of decision variables</td><td>4</td></tr><tr><td>Mutation function</td><td>Gaussian</td></tr><tr><td>Selection function</td><td>Stochunif</td></tr><tr><td>Crossover function</td><td>Scattered</td></tr></table>

Table 7 The optimum values of decision variables and objective function.  

<table><tr><td>Item</td><td>Optimum value</td></tr><tr><td>Decision variable</td><td></td></tr><tr><td>Day time Temperature</td><td>23.76 C</td></tr><tr><td>Night time Temperature</td><td>16.02 C</td></tr><tr><td>RH</td><td>68.22 %</td></tr><tr><td>CO2</td><td>627.69 ppm</td></tr><tr><td>Objective function</td><td></td></tr><tr><td>production cost</td><td>0.47 $ .kg−1</td></tr></table>

as close as possible to these setpoints over time, responding to external climate fluctuations.

The optimized values align with the physiological needs of tomato plants, where moderate daytime temperatures (around  $23 - 24^{\circ}C)$  promote optimal photosynthetic enzyme activity without triggering heat stress or fruit abortion. The lower nighttime temperature  $(16^{\circ}C)$  reduces respiration losses, preserving more assimilates for fruit development. A relative humidity of approximately  $68\%$  maintains transpiration at levels that support nutrient transport while minimizing the risk of fungal diseases common at higher RH levels. The optimized  $\mathrm{CO_2}$  concentration of 627.7 ppm enhances photosynthesis efficiency compared to ambient levels, but avoids the diminishing returns and added cost of higher enrichment. Together, these setpoints represent a finely tuned balance between maximizing yield and minimizing operational cost inputs- particularly heating and  $\mathrm{CO_2}$  enrichment- resulting in the lowest cost per kilogram of production.

Under the optimized environmental conditions, the ripe fruit weight  $(\mathrm{W_m})$  at the end of the growth period was  $2.58\mathrm{kg}.\mathrm{m}^{- 2}$  .When supplemental lighting was added (compared to the case without it),  $\mathrm{W_m}$  increased by  $12\%$  from  $2.27\mathrm{kg}.\mathrm{m}^{- 2}$  to  $2.58\mathrm{kg}.\mathrm{m}^{- 2}$  . Likewise, adding  $\mathrm{CO_2}$  enrichment (raising the concentration from ambient 380 ppm to  $627.7\mathrm{ppm})$  led to a  $10\%$  increase in  $\mathrm{W_m}$  from  $2.32\mathrm{kg}.\mathrm{m}^{- 2}$  to  $2.58\mathrm{kg}$ $\mathrm{m}^{- 2}$

# Crop photosynthesis and respiration at the optimum point

Fig. 12a and b depict the daily rates of photosynthesis (based on Eq. 7 in Table A.2) and respiration of the plant (based on Eq. (1) in Table A.2), besides the daily plant weight change on the right vertical axis for both figures at the optimum point. Figures show that based on the input data from the case studied, as the plant grows, both photosynthesis and respiration rates increase.

# Crop evapotranspiration and irrigation management at the optimum point

Fig. 13 (a). illustrates the daily evapotranspiration rate (based on Eq. (1) in Table A.4) along with the daily plant weight changes on the right vertical axis of the figure at the optimum point. Fig. 13 (b). features irrigation management (based on Eq. 4 in Table A.4) and the corresponding daily plant evapotranspiration rate on the right vertical axis at the optimum point. Results indicate that as the plant grows, both evapotranspiration and water demand also increase.

Furthermore, the effective irrigation management is scheduled on 18 specific days during the depletion of water in the soil.

# Greenhouse economic analysis at the optimum point

Table 8 details the requirements and associated costs for heating, water (including irrigation and humidification), dehumidification, supplemental  $\mathrm{CO_2}$  and artificial lighting at the optimal point (situation).

# Comparison of current proposed comprehensive modeling results with results of models in the previous studies

As discussed in the literature review, only two studies conducted by Golzar et al. [13] and Mahmoud et al. [14] had covered more effective parameters in their research in controlled solar greenhouse.

However, in the above references, the temperature differences of greenhouse components which are used for estimating the greenhouse heat losses were not taken into account. In addition, the assumption of isothermal conditions led to the omission of water droplet condensation on the inner surface of the cover (ceiling and both side walls).

Furthermore, the impact of plant respiration on estimating supplemental carbon dioxide requirements was not also considered in the above references while it is considered in this research.

Moreover, in both references Stanghellini model [53] was used to estimate plant evapotranspiration without considering the water evaporation of soil in the greenhouse or the greenhouse irrigation schedule.

Finally, the plant photosynthesis in two above references was also estimated from another Stanghellini model [54] in which, the effects of photon flux density on photosynthesis was neglected.

Thus, with many differences between the proposed comprehensive modeling and optimization methods in the presented research and those reported at references [13] and [14], the results of their models for identical input values are compared in Table 9.

Results show that by the proposed modeling and optimization in this research, the greenhouse humidity reduces due to water vapor condensation on the inner surface of the cover. Thus, the temperature of the greenhouse cover is required to estimate the mass flow rate of the produced drain.

Additionally, for estimating the required supplemental carbon dioxide, it is essential to consider the data for the plant respiration during the daytime. Assumption of isothermal conditions of the greenhouse cover, soil, and air temperature which was used in references [13] and [14], leads to  $31\%$  and  $30\%$  errors in heat loss estimation from the cover and floor, respectively. Moreover, the comprehensive modeling

![](images/6dbf06b9fdc570060e11ffdd4598d8f5ef8de8f6e8220ecc40b7bd67f27d0485.jpg)  
Fig.12.  t  t 4. and the optimum values of design parameters.

![](images/08bd3eb7f066282bc35ec5b9c7bcc1d49c0b185766bfcf22047b9fb737d654fc.jpg)  
Fig.13.  t  t ig. 4. (a) and the optimum values of design parameters.

Table 8 The greenhouse energy, water,  $\mathrm{CO_2}$  artificial lighting requirements and their related costs at the optimum design point.  

<table><tr><td>Item</td><td>Requirement</td><td>Cost</td></tr><tr><td>Energy</td><td></td><td></td></tr><tr><td>Heating</td><td>741.53 (kW.m-2)</td><td>0.17 ($.m-2)</td></tr><tr><td>Water</td><td></td><td></td></tr><tr><td>Irrigation</td><td>534 (mm)</td><td>0.053 ($.m-2)</td></tr><tr><td>Humidification</td><td>1.85 (kg.m-2)</td><td>0.0001 ($.m-2)</td></tr><tr><td>Dehumidification</td><td>547.3 (kg.m-2)</td><td>-</td></tr><tr><td>CO2</td><td></td><td></td></tr><tr><td>CO2injection</td><td>8.71 (kg.m-2)</td><td>0.87 ($.m-2)</td></tr><tr><td>Light</td><td></td><td></td></tr><tr><td>Artificial lighting</td><td>98.22 (kW.m-2)</td><td>0.17 ($.m-2)</td></tr><tr><td>Total</td><td></td><td>1.22 ($.m-2)</td></tr></table>

Table 9 The comparison of results for the current proposed comprehensive model with those from similar studies for identical input values.  

<table><tr><td>Item</td><td>Present study</td><td>Reference [13,14]</td><td>Difference (%)</td></tr><tr><td>Heating</td><td></td><td></td><td></td></tr><tr><td>Qin(kW.m-2)</td><td>741.53</td><td>841.9</td><td>13</td></tr><tr><td>Heat loss</td><td></td><td></td><td></td></tr><tr><td>Qcond(kW.m-2)</td><td>314.67</td><td>410.08</td><td>30</td></tr><tr><td>Qconv(kW.m-2)</td><td>548.93</td><td>376.32</td><td>31</td></tr><tr><td>Photosynthesis</td><td></td><td></td><td></td></tr><tr><td>Pg(kg.m-2)</td><td>11.79</td><td>8.94</td><td>24</td></tr><tr><td>Respiration</td><td></td><td></td><td></td></tr><tr><td>Rm(kg.m-2)</td><td>7.3</td><td>0</td><td>100</td></tr><tr><td>Condensation</td><td></td><td></td><td></td></tr><tr><td>Ec(kg.m-2)</td><td>15.93</td><td>0</td><td>100</td></tr><tr><td>Irrigation</td><td></td><td></td><td></td></tr><tr><td>Qir(mm)</td><td>534.07</td><td>711.2</td><td>33</td></tr><tr><td>Operation cost</td><td></td><td></td><td></td></tr><tr><td>Qtotal(kg.m-2)</td><td>1.22</td><td>1.33</td><td>8.3</td></tr></table>

approach results in a  $13\%$  reduction in heating demand compared to the estimates based on relations provided in these references (lumped method).

Furthermore, by modeling plant photosynthesis, which includes the effects of photon flux from both sunlight and LED lamps,  $24\%$  discrepancy between results of this research and the previous results reported in literature ([13;14]) is observed.

Additionally, the irrigation scheduling reveals a  $33\%$  variance in water requirements in comparison with the theory and equations existing in literature.

However, estimations of the above items show that by proposing the developed comprehensive model in this research, the above differences decrease the operational cost by  $8.2\%$

Results of the proposed comprehensive modeling and optimization techniques in this research demonstrate significant improvements over previous models. By reducing greenhouse humidity through water vapor condensation and accurately estimating the mass flow rate of the drain, the model addresses key environmental factors. The assumption of isothermal conditions in previous studies led to substantial errors in heat loss estimation, which is corrected in the proposed modeling. Additionally, the approach to modeling of plant photosynthesis and irrigation scheduling reveals discrepancies with existing literature but ultimately results in  $8.2\%$  decrease in operational costs. These findings highlight the effectiveness of presented proposed model in optimizing greenhouse conditions and reducing operational cost.

# Uncertainty analysis results for the instrument measurements

As detailed in the crop growth modeling in Section A.1., mature fruit weight  $(W_{m})$  is influenced by several greenhouse environmental factors, including temperature,  $\mathrm{CO_2}$  concentration, light intensity, and relative humidity. The uncertainty analysis for ripe fruit weight requires measurements of these internal growing factors. The assumptions for the sensors used are as follows: temperature uncertainty is  $\pm 1^{\circ}\mathrm{C}$ ,  $\mathrm{CO_2}$  concentration uncertainty is  $\pm 30\mathrm{ppm}$ , solar radiation uncertainty is  $\pm 5\mathrm{W}$ ,  $\mathrm{m}^{- 2}$ , and air relative humidity uncertainty is  $\pm 5\%$ . The detailed uncertainties and their respective sensitivity coefficients are summarized in Table 10.

Thus, the corresponding uncertainty for the ripe fruit weight increase for the last day of cultivation is  $\pm 0.72\mathrm{g}$ .

Since the weight of final crop in one square meter was about  $2200\mathrm{g}$  in 200 days ( $11\mathrm{g}$  increase in daily tomato weight), thus the above result shows about  $6.5\%$  uncertainty for the tomato production weight due to instrumentation inaccuracy.

To evaluate the robustness of the optimization outcome under input uncertainty, uncertainty analysis—based on partial derivatives and sensor tolerances—estimated the total propagated uncertainty in crop

Table 10 Uncertainty analysis of environmental factors affecting mature fruit weight.  

<table><tr><td>Environmental factor</td><td>Standard uncertainty</td><td>Sensitivity coefficient</td></tr><tr><td rowspan="2">Temperature</td><td rowspan="2">σT1= 1° C</td><td>dwm/dT1= 0.72</td></tr><tr><td>dwm/dT1</td></tr><tr><td rowspan="2">CO2 concentration</td><td rowspan="2">σCO2= 30ppm</td><td>σCO2= -0.00017</td></tr><tr><td>dwm/dT2</td></tr><tr><td rowspan="2">Solar Radiation</td><td rowspan="2">σIa= 5W.m-2</td><td>σIa= 0.006</td></tr><tr><td>dwm/dT2</td></tr><tr><td>Relative humidity</td><td>σRH= 5%</td><td>σRH= 0.002</td></tr></table>

yield to be approximately  $6.5\%$  over the full cultivation period. Additionally, sensitivity analysis showed that varying each environmental parameter by  $\pm 10\%$  resulted in changes in yield and cost of less than 10  $\%$  in all cases. These results confirm that the model is relatively insensitive to moderate input fluctuations, indicating that sensor inaccuracies and environmental uncertainties are unlikely to significantly affect the optimization results. This affirms the practical reliability of the proposed approach.

# Conclusion

The impact of changing greenhouse environmental conditions (temperature, light, air humidity,  $\mathrm{CO_2}$  and irrigation) on the growth and yield of tomato crops and its corresponding operational costs are investigated in this research. This helps to reach a comprehensive analysis of the effect of altering growth factors (temperature, light, and  $\mathrm{CO_2}$ ) on both crop growth and operational and production costs which are not found in the existing literature. It is observed that, under the studied conditions, supplemental lighting or  $\mathrm{CO_2}$  injection, although enhancing crop growth and yield, has mild effect on the plant growth. By optimizing the greenhouse environmental conditions, the parameters influencing plant growth are selected to minimize operational costs per kilogram yield. This single- objective optimization ensures that the conditions are economically efficient while boosting crop production. These analyses can be utilized for management and decision- making in the context of modern agriculture. The main findings of this research are summarized as follows:

- The optimum values of design variables for reaching the lowest cost per kg of product (the most cost-effective production parameters) with input values of the case study were: production cost at  $0.47$ $\mathrm{kg}^{-1}$ , daytime temperature at  $23.7$ $\mathrm{^\circ C}$ , nighttime temperature at  $16$ $\mathrm{^\circ C}$ , relative humidity at  $68.2\%$  and  $\mathrm{CO_2}$  concentration at  $627.7$  ppm.- The dynamic simulation reveals that under optimal conditions and at cultivation period,  $741.53$ $\mathrm{kW.m^{-2}}$  for heating,  $1.85$ $\mathrm{kg.m^{-2}}$  water for humidification,  $547.31$ $\mathrm{kg.m^{-2}}$  for dehumidification,  $8.71$ $\mathrm{kg.m^{-2}}$ $\mathrm{CO_2}$  for  $\mathrm{CO_2}$  injection,  $534$ $\mathrm{mm}$  of water for irrigation, and  $98.2$ $\mathrm{kWh.m^{-2}}$  electricity for artificial lighting were required.-  $\mathrm{CO_2}$  enrichment and supplemental lighting under optimal conditions increased ripe fruit weight by only  $10\%$  and  $12\%$ , respectively, confirming their limited contribution to productivity relative to their cost.- The time taken for the optimization process was notably decreased by employing a combination of artificial neural networks and genetic algorithm.

While the current approach provides a comprehensive framework for managing greenhouse environmental factors and optimizing operational costs, there are several limitations that need to be acknowledged:

1- The employed relations for crop growth, photosynthesis, respiration, and evapotranspiration presented in this research are suitable for tomato plants and appropriate relations should be substituted for other crops with different physiological parameters.

2- The results are obtained for climate conditions of Tehran, characterized by hot, dry summers and cool, wet winters. These conditions should be appropriately modified for new environmental conditions and different climate zones.

3- The operational costs for water, electricity,  $\mathrm{CO_2}$ , and natural gas, may be different at various locations and the model needs to have correct cost values as input for economic analysis.

4- Many validation comparisons are utilized between modeling results and experimental data from various sources ([51] for humidity balance, [52] for crop photosynthesis, [39] for solar radiation absorbed by different components, [50] for energy balance, [34] for crop growth relations). However, due to using proper instrumentation with limited accuracy, there are some corresponding uncertainties with the required measurements which has to be performed to control the temperature, humidity,  $\mathrm{CO_2}$  level and lighting. Thus, this factor introduces deviations in results of real world with those predicted by the presented integrated model.

Future work can involve in a collaboration with greenhouse owners/ operators to collect relevant data and conduct pilot studies to test the model predictions. Another main suggestion for future work is application of renewable energy equipment for greenhouse energy needs and performing an economic analysis of cost- benefit for implementing renewable energy systems and estimating the payback period for this retrofit project.

# CRediT authorship contribution statement

Seyed Aliakbar Hosseini: Writing - original draft, Validation, Software, Methodology, Investigation, Formal analysis, Data curation. Sepehr Sanaye: Writing - review & editing, Supervision, Methodology, Investigation, Conceptualization.

# Declaration of competing interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

# Appendix A

Five subsections are applied for mathematical modeling of crop growth, air  $\mathrm{CO_2}$ , irrigation, air humidity, and energy as explained in Appendix A.

A.1. Crop growth modeling When nutrient and pest management practices are adequate, the growth and yield of tomatoes largely depend on temperature,  $\mathrm{CO_2}$ , and light intensity [55]. The crop growth modeling takes into account the following assumptions:

- It is considered that nutrient needs are fully met and the greenhouse was on fertile land with unlimited water supply.- It is assumed that the plants remained fully healthy throughout the cultivation period.- The condensate water on the inner surface of the glass cover is immediately removed to protect the plant from fungal disease.

By immediately removing condensate water on the inner surface of the glass cover, the study aims to prevent fungal diseases, thereby maintaining plant health. This ensures that the observed growth patterns are representative of optimal plant conditions, free from disease- related complications. Nutrient availability does not become a limiting factor in crop growth. This allows the study to focus on the effects of environmental factors (such as temperature, light, and  $\mathrm{CO_2}$  concentration) on crop performance, without the confounding influence of nutrient deficiencies.

TOMSIM and TOMOGRO are two dynamic models based on dry matter production that model tomato growth and yield [56]. In the current study, the reduced state variable of TOMOGRO [35] is taken into account to model tomato crop growth. This model uses five state variables: node (denotes a

particular location on a plant stem from which leaves, branches, or flowers originate), LAI (is a dimensionles metric employed in agriculture and ecology to measure the extent of leaf area within a specified land area), plant weight (expresses above ground plant dry weight including fruits, leaf and stem), fruit weight (all fruits dry weight), and mature fruit weight (just ripe fruit dry weight). Details of parameters in crop growth relations are provided in Table A.1. The rate of node development can be formulated as follow [34,35]:

$$
\frac{dN}{dt} = N_m f_N(T) \tag{A1}
$$

$\mathbf{f}_{\mathrm{N}}$  (T) is a function designed to adjust the rate of node development in response to variations in hourly temperature,  $\mathbb{N}_{\mathrm{m}}$  Represents the peak rate at which nodes appear. The Leaf Area Index parameter, which changes daily, is derived [34,35]:

$$
\frac{d(LAI)}{dt} = \rho_p\cdot \delta \cdot \lambda (T_d)\frac{e^{e^{\beta(N - N_b)}}}{1 + e^{\beta(N - N_b)}}\cdot \frac{dN}{dt} ifLAI< LAI_{max} \tag{A2}
$$

$$
\frac{d(LAI)}{dt} = 0gLAI\geq LAI_{max} \tag{A2}
$$

In Eq. (A.2),  $\frac{\mathrm{dN}}{\mathrm{d}t}$  is node development rate (Eq. (A.1). Above ground dry weight is then determined by applying the following formulation [34,35]:

$$
\frac{dW}{dt} = GR_{net}\qquad ifLAI< LAI_{max} \tag{A3}
$$

$$
\frac{dW}{dt} = GR_{net} - \rho_1\rho_p\frac{dN}{dt} ifLAI > LAI_{max} \tag{A3}
$$

In Eq. (A.3),  $\mathbf{GR}_{\mathrm{net}}$  denotes the net daily aboveground biomass growth rate, which is calculated based on crop photosynthesis  $\mathrm{P_g}$  Eq. 7 in Table A.2) and crop respiration (Rm, Eq. (1) in Table A.2). [34,35]:

$$
GR_{net} = E.(P_g - R_m).(1 - f_R(N)) \tag{A4}
$$

Crop photosynthesis is influenced by the environmental growing factors such as  $\mathrm{CO_2}$  concentration, and light intensity. Fruit dry weight and mature fruit dry weight are formulated below [34,35]:

$$
\begin{array}{l}\frac{dW_f}{dt} = GR_{net}\alpha_{f}f_F(T_d)\big(1 - e^{-\beta (N - N_f)}\big)g_{fday}ifN > N_{ff}\\ \displaystyle \frac{dW_m}{dt} = D_F(T_d)\big(W_f - W_m\big)ifN > N_{ff} + k_f \end{array} \tag{A6}
$$

Table A1 Details on parameter estimation and constants that were made on tomato crop growth relations [34,35]  

<table><tr><td>Parameter</td><td>Value</td><td>Description</td></tr><tr><td>fN(T)</td><td>min (1, min (0.25 + 0.025 T1, 2.5–0.05 T1))</td><td>Function to modify node development rate as a function of hourly temperature</td></tr><tr><td>fR(N)</td><td>max (0.02, 0.18–0.0032 N)</td><td>Fraction partitioning of biomass to roots as a function of development</td></tr><tr><td>fF(Td)</td><td>max (0, min (1, 0.0625(Td – Tmin)))</td><td>Function to modify partitioning to fruit vs. Average daily temperature (Td)</td></tr><tr><td>gTday</td><td>1–0.154 (Td – Tcr) if Td &amp;gt; Tcr</td><td>Function to reduce growth due to high daytime temperature (Td)</td></tr><tr><td>DF(Td) (day−1)</td><td>0.04 max (0, min (1, 0.0714 (Td – 9)))</td><td>Function for rate of development of fruit vs. average daily temperature (Td)</td></tr><tr><td>E</td><td>0.75</td><td>The efficiency at converting photosynthate to crop biomass</td></tr><tr><td>kr (node)</td><td>5</td><td>Development time from first fruit to first ripe fruit.</td></tr><tr><td>Nb (node)</td><td>16</td><td>Coefficient in expo-linear equation</td></tr><tr><td>Nff (node)</td><td>10</td><td>Nodes per plant when first fruit appears</td></tr><tr><td>Nm (node.day−1)</td><td>0.5</td><td>Maximum rate of node appearance</td></tr><tr><td>Tcr (°C)</td><td>24.9</td><td>The temperature above which fruit abortion begins</td></tr><tr><td>Tmin (°C)</td><td>8.5</td><td>The minimum temperature below which no fruit growth occurs</td></tr><tr><td>P1(g.node−1)</td><td>0.02</td><td>Loss of leaf dry weight per node after LAIMAX is reached</td></tr><tr><td>β (day−1)</td><td>0.0169</td><td>Coefficient in expo-linear equation</td></tr><tr><td>δ (m2leaf.node−1)</td><td>0.038</td><td>Maximum leaf area expansion per node, coefficient in expo-linear equation</td></tr><tr><td>θ (node−1)</td><td>0.135</td><td>Transition coefficient between vegetative and full fruit growth</td></tr><tr><td>αf (day−1)</td><td>0.8</td><td>Maximum partitioning of new growth to fruit</td></tr></table>

# A.2. Carbon dioxide balance modeling

Crop photosynthesis and respiration influence greenhouse  $\mathrm{CO_2}$  concentration [57]. The amount of  $\mathrm{CO_2}$  produced during respiration is always less than the amount of  $\mathrm{CO_2}$  taken during photosynthesis. Plants may not respond positively to supplemental  $\mathrm{CO_2}$  because of other limiting factors such as nutrients, water, and light. All factors need to be at optimum levels [23]. For  $\mathrm{CO_2}$  balance modeling the following assumption are considered:

- The greenhouse utilizes a recirculation fan, which mixes the indoor air uniformly, ensuring consistent  $\mathrm{CO_2}$  concentration throughout.

The well- mixed indoor air achieved by the recirculation fan ensures there are no spatial differences in  $\mathrm{CO_2}$  concentration. Consequently, all plants are exposed to the same  $\mathrm{CO_2}$  levels, promoting uniform growth.

- The  $\mathrm{CO_2}$  concentration is kept constant during cultivation period at day time.

The sensors in the greenhouse also monitor the  $\mathrm{CO_2}$  concentration. Any deviation from  $\mathrm{CO_2}$  concentration setpoint triggers the activation of the relevant devices to ensure that the  $\mathrm{CO_2}$  levels remain stable and within the desired range.

Plant photosynthesis estimation can be quantified through the utilization of different models, including the Stanghellini model [54], known for its estimation of crop  $\mathrm{CO_2}$  assimilation, and TOMOGRO [52]. While the Stanghellini model computes the  $\mathrm{CO_2}$  assimilation based on solar radiation and ambient  $\mathrm{CO_2}$  concentration without considering plant respiration, the TOMOGRO model is employed in this study. In the TOMOGRO model, plant photosynthesis is influenced by the photosynthetic photon flux density (PPFD) and ambient  $\mathrm{CO_2}$  levels. In addition, plant respiration is linked to the mass of mature fruit and plant weight. The greenhouse  $\mathrm{CO_2}$  balance for predicting hourly  $\mathrm{CO_2}$  injection can be written as [34,52]:

$$
h_{g}\frac{d c_{i}}{d t} = C_{i n} - C_{v e n t} - C_{i n f} - P_{g} - P_{m} \tag{A7}
$$

$C_\mathrm{in}$ $C_\mathrm{vent}$  and  $\mathrm{C_{inf}}$  are hourly  $\mathrm{CO_2}$  injection,  $\mathrm{CO_2}$  exchange through ventilation and infiltration respectively. Plant photosynthesis and maintenance respiration are calculated hourly as a function of the environmental conditions of the greenhouse and the physiological and morphological conditions [52].  $\mathrm{P_g}$  is the crop photosynthesis rate, and  $\mathbb{R}_{\mathrm{m}}$  is the maintenance respiration rate. Details of mass transfer equations in  $\mathrm{CO_2}$  balance are provided in Table A.2. Details of parameters in  $\mathrm{CO_2}$  balance relations are provided in Table A. 3.

Table A2 Details on the relations that were made on  $\mathrm{CO_2}$  mass balance.  

<table><tr><td>Relations</td><td>Parameter estimation</td><td>Reference</td></tr><tr><td>T−20
Rm = ∫Q1010
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
m
r
(1)</td><td>PPFD = Iledηled-PARζled-PAR + Isolτcηsol-PARζsol-PAR</td><td>(4)</td></tr><tr><td>Cinf = minf(c1−c0)</td><td>minf = ρaVa(K1+K2|T0−T1|+K3,Vo)</td><td>(5)</td></tr><tr><td>Cvent = mvent(c1−c0)</td><td>Pgmax = ∂Ci</td><td>(6)</td></tr><tr><td>Pg = DPgmaxln(1−m)Pgmax+QkPPFD
k
(1−m)Pgmax+QkPPFDexp(−kLAI)</td><td></td><td>(7)</td></tr></table>

Table A3 Constants for  $\mathrm{CO_2}$  balance modeling [33].  

<table><tr><td>Parameter</td><td>Value</td><td>Description</td></tr><tr><td>D</td><td>2.592</td><td>Coefficient to convert Pg from μmol(CO2).m−2.s−1 to g(CH2O).m−2.day−1</td></tr><tr><td>k</td><td>0.58</td><td>Light extinction coefficient</td></tr><tr><td>K1</td><td>0.1</td><td>Coefficient in Infiltration equation</td></tr><tr><td>K2</td><td>0.011</td><td>Coefficient in Infiltration equation</td></tr><tr><td>K3</td><td>0.034</td><td>Coefficient in Infiltration equation</td></tr><tr><td>m</td><td>0.1</td><td>Leaf light transmission coefficient</td></tr><tr><td>Qe (μmole CO2, μmole photon−1)</td><td>0.0645</td><td>Leaf quantum efficiency</td></tr><tr><td>Q10</td><td>1.4</td><td>A coefficient in maintenance respiration equation</td></tr><tr><td>rm</td><td>0.019</td><td>Maintenance respiration coefficient</td></tr><tr><td>∂ (μmole CO2m−2s−1,ppm−1)</td><td>0.0693</td><td>Carbon dioxide use efficiency by plant</td></tr><tr><td>ζled-PAR (μmolePAR.J−1)</td><td>5.4</td><td>Photons per joule in PAR emitted by LED</td></tr><tr><td>ζsol-PAR (μmolePAR.J−1)</td><td>4.6</td><td>Photons per joule in PAR emitted by sun</td></tr><tr><td>ηled-PAR</td><td>0.55</td><td>Fraction of lamp electrical input converted to PAR</td></tr><tr><td>ηsol-PAR</td><td>0.55</td><td>Fraction of solar energy converted to PAR</td></tr></table>

# A.3. Water/Irrigation balance modeling

The crop water requirement is the volume of water necessary for a crop to sustain optimal rates of evapotranspiration  $(\mathrm{E_T})$  , thereby preventing water stress [60] Estimating crop water requirements involves understanding the daily fluctuation rate of soil water content and crop evapotranspiration, in conjunction with effective irrigation management and scheduling. In this context, soil water balance is developed [40,61,62]:

$$
\begin{array}{rl} & D_r(i) = D_r(i - 1) - (P - RO)(i) - Q_r(i) - CR(i) + E_T(i) + DP(i)ifD_r(i)\leq RAW(i)\\ & D_r(i) = D_r(i - 1) - (P - RO)(i) - C(i) + E_T(i) + DP(i)ifD_r(i) > RAW(i) \end{array} \tag{A8}
$$

where  $\mathbb{D}_{\Gamma}$  is the water content in the root zone, (P- RO) is the difference between precipitation and runoff from the soil surface,  $\mathrm{Q}_{\mathrm{ir}}$  is the irrigation rate, CR is the groundwater recharge,  $\mathrm{E_T}$  is the rate of crop evapotranspiration and DP is the water loss out of the root zone by deep percolation. The Penman- Monteith equation is employed in this study to model crop evapotranspiration. The FAO Penman- Monteith equation is widely recognized for its accuracy in estimating crop evapotranspiration  $(\mathrm{E_T})$  , as it accounts for both crop transpiration and soil evaporation. This method integrates various physiological and climatic parameters, including solar radiation (to calculate net radiation), air temperature, RH, and wind speed, along with crop- specific factors such as LAI. In this approach, two coefficients are utilized: the basal crop coefficient  $(\mathrm{K_c})$  , which describes plant transpiration, and the soil water evaporation coefficient  $(\mathrm{K_e})$  , which describes evaporation from the soil surface. The estimation of  $\mathrm{K_e}$  necessitates deriving the daily water balance for the surface soil layer as follows [40]:

$$
D_{e}(i) = D_{e}(i - 1) - (P - RO)(i) - \frac{Q_{r}(i)}{f_{w}} +\frac{E_{e}(i)}{f_{ew}} +T_{ew}(i) + DP(i) \tag{A9}
$$

where  $\mathrm{D_e}$  expresses the cumulative depth of evaporation (depletion) following complete wetting at the end of day.  $\mathrm{E_e}$  denotes soil evaporation. Details of equations in irrigation modeling are provided in Table A.4. Details of parameters in soil water balance relations are provided in Table A.5.

Table A4 Details on the relations that were made on irrigation modeling [40].  

<table><tr><td>Relations</td><td colspan="2">Parameter estimation</td></tr><tr><td rowspan="2">ET = (Ke+Ke)∑24
i=1ET0</td><td rowspan="2">(1)</td><td>0.408Δ(Rn-G) + γ 900
Ti+273
Vi(εs-εt)</td></tr><tr><td>Δ+γ(1+0.34vi)</td></tr><tr><td>EE = KeET0</td><td>(2)</td><td>es=0.6108exp(17.27Tti/(273.3+Ti))</td></tr><tr><td>RAW = PTAW</td><td>(3)</td><td>Pt=Pt+0.04(5-Er)</td></tr><tr><td>Qr(i) = RAW(i)ifDf(i-1) &amp;gt; RAW(i)Qr(i) = 0ifDf(i-1) &amp;lt; RAW(i)</td><td>(4)</td><td>Rn=ηpsol</td></tr></table>

Table A5 Relations and constants for irrigation management modelling [40,61,62].  

<table><tr><td>Parameter</td><td>Value</td><td>Description</td></tr><tr><td>Δ (kPa.C-1)</td><td>4098 (0.6108exp(17.27Tt/273.3+Tt))</td><td>Slope of saturation vapor pressure curve</td></tr><tr><td>γ (kPa.C-1)</td><td>(Tt+273.3)2</td><td>Psychrometric constant</td></tr><tr><td>Ke</td><td>min((Kr(Kcmax-Kc)),fewKcmax)</td><td>Soil water evaporation coefficient</td></tr><tr><td>Kcmax</td><td>max
(1.2+(0.04(νt-2)-0.004(RHmin-45))h(3)0.3
, (Kc+0.05)</td><td>The maximum Kc immediately following wetting</td></tr><tr><td>Kr</td><td>TEW-Dc(i-1)</td><td>Dimensionless evaporation reduction coefficient</td></tr><tr><td>few</td><td>min((1-fc),fw)</td><td>Exposed and wetted soil fraction</td></tr><tr><td>h</td><td>LAI</td><td>Mean plant height</td></tr><tr><td>fc</td><td>Kc-Kcmin
(Kcmax-Kcmin)+0.5h</td><td>Effective fraction of soil surface covered by vegetation</td></tr><tr><td>TAW (mm)</td><td>1000(θFC-θWP)Zc</td><td>Total available soil water in the root zone</td></tr><tr><td>TEW (mm)</td><td>0</td><td>Maximum cumulative depth of evaporation (depletion) from the soil surface layer</td></tr><tr><td>Tew (mm)</td><td>0</td><td>Depth of transpiration from the exposed and wetted fraction of the soil surface layer</td></tr><tr><td>CR (mm)</td><td>0</td><td>The groundwater table was far below plant root zone</td></tr><tr><td>DP (mm)</td><td>0</td><td>Water applied to the soil is efficiently utilized by the crops.</td></tr><tr><td>fw</td><td>0.35</td><td>Average fraction of soil surface wetted by irrigation</td></tr><tr><td>Kcmin</td><td>0.15</td><td>The minimum Kc for dry bare soil with no ground cover</td></tr><tr><td>P (mm)</td><td>0</td><td>Because simulation was conducted in greenhouse, precipitation was ignored</td></tr><tr><td>Pt</td><td>0.4</td><td>Average fraction of Total TAW that can be depleted from the root zone before moisture stress</td></tr><tr><td>REW</td><td>9</td><td>Readily evaporable water</td></tr><tr><td>RO (mm)</td><td>0</td><td>Defined negligible due to the flat terrain</td></tr><tr><td>Ze</td><td>0.1</td><td>Depth of the surface soil layer that is subject to drying by way of evaporation</td></tr><tr><td>θFC</td><td>0.25</td><td>Soil water content at field capacity</td></tr><tr><td>θWP</td><td>0.12</td><td>Soil water content at wilting point</td></tr></table>

# A.4. Air humidity balance modeling

The main moisture source in the greenhouse is the plant transpiration. The moisture is added to the greenhouse by crop evapotranspiration and removed by condensation of water vapor on the internal cover surface. Based on the environmental conditions and greenhouse structure, infiltration can decrease or increase the humidity of the greenhouse. The humidity balance modeling takes into consideration the following assumptions:

A recirculation fan is used in the greenhouse to ensure that the indoor air is well mixed, providing consistent airspeed and RH levels.

The recirculation fan helps maintain uniform air relative RH levels throughout the greenhouse. By preventing spatial differences in RH, it ensures that all plants experience consistent humidity conditions.

The humidity is kept constant during cultivation.

The humidity sensors report the RH levels. Should there be any fluctuations from air humidity setpoints detected, the necessary equipment is engaged to sustain this humidity level consistently during the cultivation period.

Plant evapotranspiration estimation can be conducted using various methodologies, such as the Stanghellini model [53], which emphasizes on crop transpiration, and the FAO56 Penman- Monteith equation [40], which addresses crop evapotranspiration. The Stanghellini model tends to disregard irrigation management, excluding soil water evaporation within the greenhouse and focusing primarily on plant transpiration. Conversely, the Penman- Monteith equation accounts for crop evapotranspiration by considering irrigation strategies and the moisture introduced into the greenhouse environment via soil evaporation. Therefore, this investigation employs the Penman- Monteith model. The humidity balance for evaluating hourly humidification requirements can be calculated as follows [18,63,64]:

$$
h_g\frac{d\mathfrak{x}_i}{dt} = E_{in} + E_p - E_{inf} - E_{vent} - E_c \tag{A10}
$$

$\mathrm{E_{in}}$  represents hourly humidification or dehumidification load.  $\mathrm{E_p}$ $\mathrm{E_{inf}}$ $\mathrm{E}_{\mathrm{vent}}$  and  $\mathrm{E_c}$  are humidity added by plant evapotranspiration, humidity exchange due to greenhouse building infiltration, humidity exchange due to ventilation and the condensation rate of water droplets on the inner surface of the cover, respectively. Details of mass transfer equations in humidity balance are provided in Table A.6. Details of parameters in humidity balance relations are provided in Table A.7.

Table A6 Relations used in humidity mass balance.  

<table><tr><td>Relations</td><td>Parameter estimation</td><td>Reference</td></tr><tr><td rowspan="2">Einf= 0.622 × minf(ei - eo)</td><td rowspan="2">(1)</td><td rowspan="2">(4)</td></tr><tr></tr><tr><td rowspan="2">Event= 0.622 × mg(ei - eoc)</td><td rowspan="2">(2)</td><td rowspan="2">(5)</td></tr><tr></tr><tr><td rowspan="2">Ec= 3600 × 0.622 × hc(i(ei - eoc)</td><td rowspan="2">(3)</td><td rowspan="2">(6)</td></tr><tr></tr></table>

Table A7 Relations and constants for humidity balance modeling [40].  

<table><tr><td>Parameter</td><td>Value</td><td>Description</td></tr><tr><td>Tdewi (°C)</td><td>Aln(RH1/100) + RT1/A + BTi/B - ln(RH1/100) + BTi/A + T1/B</td><td>Inside air dewpoint temperature</td></tr><tr><td>Tdewo (°C)</td><td>Aln(RH0/100) + RT0/A + T0/B - ln(RH0/100) + RT0/A + T0/B</td><td>External air dewpoint temperature</td></tr><tr><td>A (°C)</td><td>243.11</td><td>Constan for estimating dewpoint temperature</td></tr><tr><td>B</td><td>0.011</td><td>Constan for estimating dewpoint temperature</td></tr><tr><td>Cpw (J.kg-1/°C-1)</td><td>4180</td><td>Specific heat of water</td></tr><tr><td>KPa)</td><td>101.325</td><td>Air pressure</td></tr></table>

# A.5. Energy balance modeling

To estimate heat losses from the floor and cover at ceiling of the greenhouse, the instantaneous temperature of the floor and cover is obtained. Assuming an equal temperature of different components inside the greenhouse lead to significant errors in estimating the heat losses over a cultivation period. According to Ref [39], in the present study, the greenhouse system is treated as a solar collector, comprising three semi- transparent covers (the greenhouse cover, the humid inside air, and the plants, which act as three parallel layers) and an absorber plate (the greenhouse soil). The energy balance model is based on the following assumptions:

The lumped method is applied for each component in the greenhouse. Each component is assumed to have a uniform temperature throughout the greenhouse such that the local (spatial) variations could not be captured.

In many practical applications, such as a greenhouse equipped with recirculation fans, temperature variations are relatively minor, making a uniform temperature assumption reasonable.

The plant canopy is considered as a semitransparent layer, encompassing aerial plant tissues and interstitial air. This layer is characterized by an effective reflectance  $(\rho_{\mathrm{ca}})$  and effective transmittance  $(\tau_{\mathrm{ca}})$  for global solar radiation incident on both the upper and lower surfaces of the plant layer.

Considering the plant canopy as a semitransparent layer for global solar radiation, accurately represents the interaction of sunlight with the complex structure of the canopy. This approach accounts for the partial absorption, reflection, and transmission of solar energy through the canopy, which affects photosynthesis, energy balance, and microclimate conditions within the greenhouse.

The integral properties (independent of the wavelength) are used for the radiative properties of greenhouse components.

By using average values for properties like reflectivity, transmissivity, and absorptivity, the model becomes simpler and more computationally efficient. This approach allows the model to focus on the most significant environmental factors affecting plant growth, rather than getting bogged down in the complexities of wavelength- dependent properties. However, since the temperatures within a greenhouse are typically not extremely high, the primary factors influencing reflectivity, transmissivity, and absorptivity are the material properties and the wavelengths of light rather than temperature variations, which tend to be minor within a controlled greenhouse environment.

The temperature of  $\mathrm{CO_2}$  and humidity added to the indoor environment is equal to the temperature of the indoor environment.

Keeping the added  $\mathrm{CO_2}$  and humidity at the same temperature as the indoor environment prevents sudden temperature changes that could stress the plants or alter the plant conditions.

The temperature is kept constant during cultivation.

The greenhouse is equipped with sensors that continuously report the internal temperature levels. If any fluctuations from daytime temperature and nighttime temperature setpoints are detected by the sensors, the corresponding devices or equipment are activated to maintain these temperature levels constant throughout the cultivation period.

The greenhouse is equipped with a recirculation fan, ensuring that the indoor air was well mixed, resulting in uniform airspeed and temperature.

The use of a recirculation fan in the greenhouse ensures that the indoor air is well mixed, leading to uniform airspeed. This results in no spatial differences in temperature, maintaining a consistent temperature across the entire cultivation area.

Hence, a more detailed energy balance equation is developed for individual components. The following energy balance equations for the greenhouse components is used [15,67,68]:

For cover:

$$
Q_{sol - c} - Q_{conv} - Q_{conv} = m_{c}c_{pc}\frac{dT_{c}}{dt} \tag{A11}
$$

where  $\mathrm{Q_{sol - c}}$ $\mathrm{Q_{conv}}$  and  $\mathrm{Q_{conv}}$  are greenhouse cover heat gain from solar, heat loss through convection to outside and inside the greenhouse respectively.

For plant:

$$
Q_{sol - p} - Q_{conv} - Q_{trans} = m_p c_p\frac{dT_p}{dt} \tag{A12}
$$

where,  $\mathrm{Q_{sol - p}}$  and  $\mathrm{Q_{conv}}$  are plant's heat gain from solar and heat loss through convection.  $\mathrm{Q_{trans}}$  denotes the absorption of heat from the greenhouse air by the plant, which is essentially the latent heat released by the plant's evapotranspiration, and is estimated based on the Penman- Monteith relation [40]. The Penman- Monteith equation, employed to model crop evapotranspiration, is integrally coupled with the crop growth relations and soil water balance, including irrigation scheduling, for an entire cultivation period. This comprehensive coupling allows for the accurate simulation of crop water requirements by considering the dynamic interactions between plant growth, soil moisture content, and the greenhouse microclimate (RH and temperature).

For soil:

$$
Q_{sol - sb} - Q_{convsb} - Q_{cond} = m_{sb}c_{pb}c_{pb}^{dT_{sb}}\frac{dT_{sb}}{dt} \tag{A13}
$$

where,  $\mathrm{Q_{sol - sb}}$  and  $\mathrm{Q_{convsb}}$  are soil's heat gain from solar and heat loss through convection.  $\mathrm{Q_{cond}}$  is related to conductive heat transfer through the greenhouse floor.

For humid air:

$$
Q_{in} + Q_{convin} + Q_{conv} + Q_{convsb} + Q_{inf} + Q_{vent} + Q_{lamp} + Q_{sol - a} = m_a c_{pa}\frac{dT_i}{dt} \tag{A14}
$$

where  $\mathrm{Q_{sol - a}}$ $\mathrm{Q_{vent}}$ $\mathrm{Q_{inf}}$  and  $\mathrm{Q_{lamp}}$  represent heat gain from solar, heat loss through ventilation and greenhouse building leakage, and heat dissipation for LED lamps, respectively.  $\mathrm{Q_{in}}$  expresses heating load to the greenhouse. Details of the heat and mass transfer equation are listed in Table A.8. Details of parameters in energy balance relations are provided in Table A.9.

Table A8 Relations used for greenhouse energy balance.  

<table><tr><td>Relations</td><td colspan="2">Heat and mass transfer coefficients</td><td>Reference</td></tr><tr><td rowspan="2">Qsol-c = AcηcIsol</td><td rowspan="2">(1)</td><td rowspan="2">ηc = (1 - τc - ρc) (1 + ρcτcτa2/1 - ρcaρcτa2/1 + ρcaρcτa2/1 - ρcaρcτa2/1)</td><td rowspan="2">(14)</td></tr><tr></tr><tr><td rowspan="2">Qsol-p = AgηpIsol</td><td rowspan="2">(2)</td><td rowspan="2">ηp = (1 - τca - ρca) (1 + ρcτca2/1 - ρcaρcτa2/1 + ρcτca2/1 - ρcaρcτa2/1)</td><td rowspan="2">(15)</td></tr><tr></tr><tr><td rowspan="2">Qsol-a = ApηaIsol</td><td rowspan="2">(3)</td><td rowspan="2">ηa = (1 - τw) (1 + ρpτa/1 - ρcaρcτa2/1 + ρwτcτp(1 + ρcτa/1 - ρcaρcτa2/1)</td><td rowspan="2">(16)</td></tr><tr></tr><tr><td rowspan="2">Qsol-sb = AgηsbIsol</td><td rowspan="2">(4)</td><td rowspan="2">ηsb = (1 - ρsb)τcaτca/1 - ρcaρcτa(1 - ρsb/ρca + ρcτca2w/1 - ρcaρcτa2/1)</td><td rowspan="2">(17)</td></tr><tr></tr><tr><td>Qconv = Achco(Tc - To)</td><td>(5)</td><td>hco = 2 + 1.2v</td><td>(18)</td></tr><tr><td>Qconv = Achci(Tc - Ti)</td><td>(6)</td><td>hci = 3|Ti - Tc|3</td><td>(19)</td></tr><tr><td>Qconvsb = Asbhsb(Tsb - Ti)</td><td>(7)</td><td>hsb = 10|Ti - Tsb|3</td><td>(20)</td></tr></table>

(continued on next page)

Table A8 (continued)  

<table><tr><td>Relations</td><td colspan="2">Heat and mass transfer coefficients</td><td>Reference</td></tr><tr><td>Qcovp = Acahp(Tp-Ti)</td><td>(8)</td><td>hp=14Gρ.33</td><td>[21]</td></tr><tr><td>Qinf = minfcpa(To-Ti)</td><td>(9)</td><td>τca=exp(-c1.LAI),c1=c2√((1-τl)2-ρl2)</td><td>[22]</td></tr><tr><td>3600</td><td>(10)</td><td>Vg</td><td>[15,39]</td></tr><tr><td>Qcond = Agksh(Ts-Tg)</td><td>(11)</td><td>τa=exp(-kagLe),Lg=360Ae</td><td>[23]</td></tr><tr><td>Qlamp = AgkshL</td><td>(12)</td><td>ρca=ρst(1-exp(-c2.LAI)),ρst=0.75ρl</td><td>[39,64]</td></tr><tr><td>Qtrans = AAgEp</td><td>(13)</td><td></td><td>[40,67,71]</td></tr><tr><td>Qvent =</td><td>(14)</td><td></td><td>[66]</td></tr><tr><td>minventcpa(To-Ti)</td><td></td><td></td><td></td></tr><tr><td>3600</td><td></td><td></td><td></td></tr></table>

Table A9 Constants for energy balance modeling [7,39,71].  

<table><tr><td>Parameter</td><td>Value</td><td>Description</td></tr><tr><td>c2</td><td>0.75</td><td>Coefficient for plant geometry</td></tr><tr><td>Cpa(J.kg-1.C-1)</td><td>1005</td><td>Specific heat of air</td></tr><tr><td>kA</td><td>0.87</td><td>Coefficient for plant geometry</td></tr><tr><td>kSB</td><td>0.7</td><td>Soil thermal conductivity</td></tr><tr><td>ηled,heat</td><td>0.45</td><td>Fraction of lamp electrical input converted to heat</td></tr><tr><td>ρc</td><td>0.08</td><td>Greenhouse glass cover reflectivity coefficient</td></tr><tr><td>ρl</td><td>0.25</td><td>Green leaf reflectance coefficient</td></tr><tr><td>ρsb</td><td>0.2</td><td>Soil reflectivity coefficient</td></tr><tr><td>τc</td><td>0.84</td><td>Greenhouse glass cover transmissivity coefficient</td></tr><tr><td>τl</td><td>0.25</td><td>Green leaf transmittance coefficient</td></tr><tr><td>λ (NJ.kg-1)</td><td>2.45</td><td>Latent heat of vaporization</td></tr></table>

# A.6. Coupling of modeling equations

The comprehensive modeling of the greenhouse environment includes the integration of several sub- models such as energy balance, humidity balance,  $\mathrm{CO_2}$  balance, soil water balance, and crop growth relations. As these sub- models are coupled, thus, the dynamic interactions within the greenhouse system are taken into account over the entire cultivation period. For example, the soil water balance model which manages the values of the soil moisture, is interlinked with the humidity and energy balance models. This dictates that crop evapotranspiration, which releases latent heat, affects the crop surface temperature, air humidity, and soil moisture levels. The comprehensive model also incorporates irrigation management and scheduling to ensure optimal water availability. Additionally, to estimate condensation rates on the inner cover surface of the greenhouse, it is essential to couple the energy and humidity balance models, as the condensation rate depends on the temperature of the cover surface. Finally, the crop growth model which is depend on the environmental conditions, is coupled with all other models, as these factors collectively influenced the crop performance.

A.6.1. Coupling energy balance with crop growth relation

The variables  $\eta_{\mathrm{p}}, \eta_{\mathrm{sb}}, \eta_{\mathrm{a}}$ , and  $\eta_{\mathrm{c}}$  (Eq. (14) to Eq. 17 in Table A.8) symbolize the solar radiation absorbed by plant, soil, humid air and cover respectively. The equations model the amount of radiation received by the cover, plant, humid air, and soil, respectively. It is important to highlight that these coefficients are interconnected, and due to the plant dynamic daily growth, these ratios undergo daily variations. The parameters  $\tau_{\mathrm{ca}}$  and  $\rho_{\mathrm{ca}}$  (Eq. 22 and Eq. 24 in Table A.8) refer to the plant transmittance coefficient for solar radiation and the reflectance coefficient for solar radiation (passing through the plant leaves to the soil), respectively. These two parameters are a function of LAI (Eq. (A.2)) and in this way, they couple with crop growth equations.

A.6.2. Coupling energy balance with the humidity balance, and crop growth relation

The condensation rate of water droplets on the inner surface  $(\mathrm{E}_{\mathrm{c}})$  of the greenhouse cover can be calculated using Eq. 3 in Table A.6. Given that calculating the condensation rate of droplets on the inner surface of the cover requires knowing the greenhouse cover temperature  $(\mathrm{e}_{\mathrm{sc}}$ , Eq. 6 from Table A.6 is the saturated vapor pressure at the greenhouse cover temperature), energy balance relationships of greenhouse cover (Eq. (A.11)) are coupled with humidity balance. Additionally, it was previously determined that the energy balance equation was coupled with plant growth relation (LAI, Eq. (A.2)).

A.6.3. Coupling energy balance with the humidity balance, soil water balance, and crop growth relation

The heat release due to crop evapotranspiration  $(\mathrm{Q}_{\mathrm{trans}})$ , can be estimated using Eq.12 in the Table A.8 based on the evapotranspiration of the plant  $(\mathrm{E}_{\mathrm{T}}$ , Eq. (1) in Table A.4).  $\mathrm{E}_{\mathrm{T}}$  is the main source of moisture production in the greenhouse, is brought into the humidity balance of the greenhouse air  $(\mathrm{E}_{\mathrm{p}}$ , Eq. (A.10)). The Penman- Monteith equation [40], employed to model crop evapotranspiration  $(\mathrm{E}_{\mathrm{T}}$ , Eq. (1) in Table A.4), is integrally coupled with the crop growth relations  $(\mathrm{K}_{\mathrm{e}}$  and  $\mathrm{K}_{\mathrm{c}}$  are the coefficients of soil water evaporation and plant transpiration, and according to Table A.5, are estimated based on plant height or LAI, (Eq. (A.2)), and soil water balance, including irrigation scheduling, for an entire cultivation period.  $\mathrm{ET}_{0}$  (Eq. 5 in Table A.4) is the reference relationship for plant evapotranspiration that takes into account environmental conditions (temperature and humidity).  $\mathrm{R}_{\mathrm{n}}$  (Eq. 8 in the Table A.4) is the radiation reaching the plant, which is a function of plant growth as  $\eta_{\mathrm{p}}$  (Eq. 15 in Table A.8) changes daily based on plant growth.

A.6.4. Coupling the  $\mathrm{CO}_{2}$  balance with energy balance and crop growth relation

Photosynthesis is the primary source of  $\mathrm{CO}_{2}$  reduction, and plant respiration is the primary source of  $\mathrm{CO}_{2}$  increase in the greenhouse environment. These processes are considered in the  $\mathrm{CO}_{2}$  balance equation (Eq. (A.7)).  $\mathrm{R}_{\mathrm{n}}$  (Eq. (1) in the Table A.2) directly related to plant weight (Eq. (A.3)) and ripe fruit weight (Eq. (A.6)). Crop photosynthesis (Pg, Eq. 7 in the Table A.2) is a function of LAI (Eq. (A.2)), photosynthesis photon flux density of sunlight and artificial light (Eq. 4 in the Table A.2), temperature and  $\mathrm{CO}_{2}$  concentration. Plant respiration depends on the environmental temperature,

plant weight (W, Eq. (A.3)), and ripe fruit weight (Wm, Eq. (A.6)). Appendix B

# B.1. Dynamic modeling results

In this section, the analysis covers solar radiation absorption by greenhouse components, and supplemental lighting requirement. B.1.1. Solar Radiation Absorption by Greenhouse Components.

Fig. B.1 illustrates the solar radiation absorbed by each greenhouse component throughout different days of the growing period based on the relationships in Eq. (14) to Eq. (17) in Table A.8 and crop growth equations (Eq. (A.1) to Eq. (A.6). Due to the dynamic nature of plant growth, the reflection of solar radiation among components, and the distinct radiative properties of each part, the proportion of radiation reaching each component varies. Consequently, the instantaneous temperatures of the greenhouse components are not the same.

Change in the absorbed radiation is considerable until the plant achieves its maximum coverage  $\mathrm{(LAI_{max})}$  , which occurs after one hundred days. Once the growing of the plant leaves finishes, the absorption of solar radiation by all components remain unchanged until the end of the growth cycle. Due to minimal plant coverage, most solar radiation reaches the greenhouse soil at the beginning of the plant growth. With passing the time, the plant leaves coverage increased which results in the plant higher radiation absorption (as well as reduction of radiation absorption by soil). The radiation absorbed by the greenhouse cover (nc) and the humid air (na) remains approximately constant during the cultivation period. The percentage of radiation energy lost by the greenhouse to the ambient environment (no) is estimated using the following equation:  $1 - (\eta \mathrm{p} + \eta \mathrm{sb} + \eta \mathrm{a} + \eta \mathrm{c})$  . Thus, the radiation energy lost by the greenhouse to the ambient  $\{\Pi_0\}$  , the radiation absorbed by the cover, and the radiation absorbed by the humid air are affected by the dynamic growth behavior of the plant.

![](images/1d41c61a65c0ee93df971e39b9da8bbecd6ee799b61e74b07cb4b989ab304532.jpg)  
Fig. B1. The percentage of solar radiation absorbed by the components of the greenhouse on different days. The initial conditions to obtain the results are the illustrated solar radiation in . (a). Red data: soil absorption, green data: plant absorption, black data: glass cover absorption, blue data: humid air absorption, purple data: solar radiation loss from the greenhouse.

# B.1.2. Supplemental lighting

To provide adequate light for extending day length and to increase the crop production on short, cloudy, and rainy days, artificial lighting (as well as heat emitted from LEDs) are required. These values are shown in Fig. B.2. (a) During the majority of autumn and winter periods, there is a noticeable requirement for supplemental lighting. The lighting duration of the greenhouse for these days are shown in Fig. B.2. (b). When the sun did not provide the plant daily light requirement (such as on cloudy and rainy days), artificial lighting is used to extend the day light. Therefore, the variation in lighting hours from day to day is caused by changes in solar radiation and the duration of artificial lighting.

![](images/deed5084dc1b452da8bec905b41bd140b6dc72193eb0843003d5068070f9f570.jpg)  
Fig. B2. (a) Daily electricity requirement and radiative heat of LED lamps and (b) Lighting duration of the greenhouse on different days. The initial conditions to obtain the results are the illustrated solar radiation in . (a).

# Data availability

The authors are unable or have chosen not to specify which data has been used.

# References

[1] Chen WH, Mattson NS, You F. Intelligent control and energy optimization in controlled environment agriculture via nonlinear model predictive control of semiclosed greenhouse. Appl Energy 2022;320. https://doi.org/10.1016/j.apenergy.2022.119334. [2] Esmaeli H, Roshandel R. Optimal design for solar greenhouses based on climate conditions. Renew Energy 2020;145:1255- 65. https://doi.org/10.1016/j.renene.2019.06.090. [3] Vadiee A, Yaghoubi M, Martin V, Bazargan- Lari Y. Energy analysis of solar blind system concept using energy system modelling. Sol Energy 2016;139:297- 308. https://doi.org/10.1016/j.solener.2016.09.039. [4] Badji A, Benseddik A, H. Bensaha, A. Boukhelifa, I. Hasrane, Design, technology, and management of greenhouse: a review, 2022, Elsevier Ltd. doi: 10.1016/j.jclepro.2022.133753. [5] Zhang M, Yan T, Wang W, Jia X, Wang J, Klemes JJ. Energy- saving design and control strategy towards modern sustainable greenhouse: a review. Renew Sustain Energy Rev Aug. 2022;164. https://doi.org/10.1016/j.rser.2022.112602. [6] Bazgaou A, et al. Effect of active solar heating system on microclimate, development, yield and fruit quality in greenhouse tomato production. Renew Energy 2021;165:237- 56. https://doi.org/10.1016/j.renene.2020.11.007. [7] Vadiee A, Martin V. Energy analysis and thermoeconomic assessment of the closed greenhouse - the largest commercial solar building. Appl Energy 2013;102: 1256- 66. https://doi.org/10.1016/j.apenergy.2012.06.051. [8] Vadiee A, Martin V. Energy management in horticultural applications through the closed greenhouse concept, state of the art, 2012. 10.1016/j.rser.2012.04.022. [9] Abedrabboh O, Kog M, Bicer Y. Modelling and analysis of a renewable energy- driven climate- controlled sustainable greenhouse for hot and arid climates. Energy Convers Manag 2022;273. https://doi.org/10.1016/j.enconman.2022.116412. [10] Mohebi P, Roshandel R. Optimal design and operation of solar energy system with heat storage for agricultural greenhouse heating. Energy Convers Manage: X 2023; 18. https://doi.org/10.1016/j.ecma.2023.100353. [11] Taftuni A, et al. Thermo- economic analysis of a low- cost greenhouse thermal solar plant with seasonal energy storage. Energy Convers Manag 2023;288. https://doi. org/10.1016/j.enconman.2023.117123. [12] Golzar F, N. Heeren S, Hellweg, and R. Roshandel, A novel integrated framework to evaluate greenhouse energy demand and crop yield production, 2018, Elsevier Ltd. doi: 10.1016/j.rser.2018.06.046. [13] Golzar F, Heeren N, Hellweg S, Roshandel R. Optimisation of energy- efficient greenhouses based on an integrated energy demand- yield production model. Biosyst Eng 2021;202:1- 15. https://doi.org/10.1016/j. biosystemseng.2020.11.012. [14] Mahmood F, Ghiat I, Hazrat B, M. Luqman, T. Al- Ansari, A framework based on an input- yield model for greenhouse optimisation for varying environmental conditions, Energy Convers Manage: X, p. 100555, 2024, doi: 10.1016/j. ecmx.2024.100555. [15] Singh G, Singh PP, Lubana PPS, Singh KG. Formulation and validation of a mathematical model of the microclimate of a greenhouse. Renew Energy 2006;31 (10):1541- 60. https://doi.org/10.1016/j.renene.2005.07.011. [16] https://www.tomatoesnz.co.nz/docsdocument/200- greenhouse- temperature- published- June- 2021. [17] Zong C, Li H, Zheng L, Song W. Evaluation and optimization of a new condensation dehumidification system with faa- coil units using low- cost cold source for greenhouses. J Clean Prod 2023;433. https://doi.org/10.1016/j. jclepro.2023.139805. [18] Rahman MS, Guo H, Han J. Dehumidification requirement modelling and control strategy for greenhouses in cold regions. Comput Electron Agric 2021;187. https:// doi.org/10.1161/j.compag.2021.106264. [19] Al Miaari A, El Khatib A, Ali HM. Design and thermal performance of an innovative greenhouse, Sustainable Energy Technol Assessm, 57, 2023, doi: 10.1016/j. seta.2023.103285. [20] Tahery D, Roshandel R, Avami A. An integrated dynamic model for evaluating the influence of ground to air heat transfer system on heating, cooling and CO2 supply in Greenhouses: considering crop transpiration. Renew Energy 2021;173:42- 56. https://doi.org/10.1016/j.renene.2021.03.120. [21] Harmanto V, Salokhe M, Babel MS, Tantau HJ. Water requirement of drip irrigated tomatoes grown in greenhouse in tropical environment, Agric Water Manag, 71 (3), 225- 242, 2005, doi: 10.1016/j.agwat.2004.09.003. [22] Zhang Y, Yasutake D, Hidaka K, Okayasu T, Kitano M, Hirota T. Crop- localised CO2 enrichment improves the microclimate, photosynthetic distribution and energy utilisation efficiency in a greenhouse. J Clean Prod 2022;371. https://doi.org/ 10.1016/j.jclepro.2022.133465. [23] Poudel M, Dunn B. Greenhouse carbon dioxide supplementation. Oklahoma Cooperative Extension Service; 2017. [24] Nasrabadi AM, Malaei O, Moghimi M, Sadeghi S, Hosseinalipour SM. Deep learning optimization of a combined CCHP and greenhouse for CO2 capturing; case study of Tehran. Energy Convers Manag 2022;267. https://doi.org/10.1016/j. enconman.2022.115946.

[25] Calegario FF, Cosso RG, F. V Almeida, A. L. Vercesi, and W. F. Jardim, Determination of the respiration rate of tomato fruit using flow analysis, 2000. [Online]. Available: www.elsevier.com/locate/postharvbio. [26] Hidaka K, et al. Crop- local CO2 enrichment improves strawberry yield and fuel use efficiency in protected cultivations. Sci Hortic 2022;301. https://doi.org/10.1016/ j.schicenta.2022.111104. [27] Akhlaq M, et al. Exploring adequate CO2 elevation for optimum tomato growth and yield under protected cultivation. J Plant Physiol 2023;289. https://doi.org/ 10.1016/j.jplph.2023.154093. [28] Hassanien RHE, Li M, Dong Lin W. Advanced applications of solar energy in agricultural greenhouses, 2016, Elsevier Ltd. doi: 10.1016/j.rser.2015.10.095. [29] Singh D, Basu C, Meinhardt- Wollweber M, Roth B. LEDs for energy efficient greenhouse光照. Sep. 01, 2015, Elsevier Ltd. doi: 10.1016/j.rser.2015.04.117. [30] Klaring HP, Krumbein A. The effect of constraining the intensity of solar radiation on the photosynthesis, growth, yield and product quality of tomato. J Agron Crop Sci 2013;199(5):351- 9. https://doi.org/10.1111/jac.12018. [31] Zheng Y et al., Effects of different light intensity on the growth of tomato seedlings in a plant factory, PLoS One, 18 (11). November, Nov, 2023. doi: 10.1371/journal. pone.0294876. [32] Katzin D, Marcelis LFM, van Mourik S. Energy savings in greenhouses by transition from high- pressure sodium to LED lighting. Appl Energy 2021;281. https://doi. org/10.1016/j.apenergy.2020.116019. [33] Kuijpers WJP, Katzin D, van Mourik S, Antunes DJ, Hemming S, van de Molengraft MJG. Lighting systems and strategies compared in an optimally controlled greenhouse. Biosyst Eng 2021;202:195- 216. https://doi.org/10.1016/j. biosystemseng.2020.12.006. [34] Jones JW, Kenig A, Vallejos CE. Reduced state- variable tomato growth model. Trans Am Soc Agric Eng 1999;42(1):255- 65. https://doi.org/10.13031/ 2013.13203. [35] Shamshiri RR, M. R. Mahadi, K. R. Thorp, W. I. W. Ismail, D. Ahmad, and H. C. Man, Adaptive management framework for evaluating and adjusting microclimate parameters in tropical greenhouse crop production systems, in Plant Engineering, InTech, 2017. doi: 10.1577/intechopen.69972. [36] Sun W, Chang FJ. Empowering greenhouse cultivation: dynamic factors and machine learning unite for advanced microclimate prediction. Water (switzerland) 2023;15(20):Oct. https://doi.org/10.3390/w15203548. [37] Hoseinzadeh S, Garcia DA. Can AI predict the impact of its implementation in greenhouse farming? Renew Sustain Energy Rev 2024;197. https://doi.org/ 10.1016/j.rser.2024.114423. [38] Cletus F, John AE. Comparative analysis of machine learning models for greenhouse microclimate prediction, Brilliance: Research of Artificial Intelligence, vol. 4, no. 1, pp. 162- 175, May 2024, doi: 10.47709/brilliance.v4i1.3783. [39] Abdel- Ghany AM, Al- Helal IM. Solar energy utilization by a greenhouse: General relations. Renew Energy 2011;36(1):189- 96. https://doi.org/10.1016/j. renene.2010.06.020. [40] Allen RG, Pereira LS, D. Raes, M. Smith, Crop evapotranspiration- Guidelines for computing crop water requirements- FAO irrigation and drainage paper 56, Fao, Rome, vol. 300, no. 9, p. D05109, 1998. [41] Raji Asadabadi MJ, Rad SH, Taraghi M, Moghimi M, Ahmadi R. ANN- boosted optimization and performance evaluation of a hybrid solar- geothermal high temperature cascaded ORC for electricity, liquid hydrogen, freshwater, and cooling purposes. Appl Therm Eng 2025;262:Mar. https://doi.org/10.1016/j. applthermaleng.2024.125251. [42] Sanare S, Ramezani S, Gholami J. Techno- economic optimization of regenerative indirect evaporative cooling systems with/without middle air flow return paths. Energy Convers Manag 2025;332. https://doi.org/10.1016/j. enconman.2025.119770. [43] Mehrenjani JR, Gharehghani A, Ahmadi S, Powell KM. Dynamic simulation of a triple- mode multi- generation system assisted by heat recovery and solar energy storage modules: Techno- economic optimization using machine learning approaches. Appl Energy 2023;348. https://doi.org/10.1016/j. appenergy.2023.121592. [44] Mahmood F, Govindan R, Al- Ansari T. Efficient energy management and temperature control of a high- tech greenhouse using an improved data- driven model predictive control. Energy Convers Manage: X 2025;26. https://doi.org/ 10.1016/j.ecmx.2025.100939. [45] Vanthoor BHE, et al. A methodology for model- based greenhouse design: Part 4, economic evaluation of different greenhouse designs: a Spanish case. Biosyst Eng 2012;111(4):336- 49. https://doi.org/10.1016/j.biosystemseng.2011.12.008. [46] https://www.globalpetrolprices.com/Iran. [47] https://www.renewables.ninja/news/raw- weather- data. [48] http://amarista.ir/. [49] Sanaye SNB. Horizontal ground coupled heat pump: thermal- economic modeling and optimization. Energy Convers Manag 2010;51:2600- 12. https://doi.org/ 10.1016/j.enconman.2010.05.026. [50] Mao Q, Li H, Ji C, Peng Y, Li T. Experimental study of ambient temperature and humidity distribution in large multi- span greenhouse based on different crop heights and ventilation conditions. Appl Therm Eng 2024;248. https://doi.org/ 10.1016/j.applthermaleng.2024.123176. [51] Liu R, Li M, Guzman JL, Rodriguez F. A fast and practical one- dimensional transient model for greenhouse temperature and humidity. Comput Electron Agric 2021;186. https://doi.org/10.1016/j.compag.2021.106186. [52] Zekki H, Gary C, Gosselin A, Gauthier L. Validation of a photosynthesis model through the use of the CO 2 balance of a greenhouse tomato canopy. Ann Bot 1999; 84(5):591- 8. [53] Cecilia Stanghellini TdJ. A model of humidity and its applications in a greenhouse.

[54] Stangheilini C Is, 9fJy, and C. Vitae, Transpiration of greenhouse crops : an aid to climate management, 1987. [Online]. Available: https://api.semanticscholar.org/CorpusID:83424473. [55] Jones JW, Dayan E, Allen LH, Van Keulen H, Challa H. Dynamic tomato growth and yield model (TOMGRO). Trans Am Soc Agric Eng 1991;34(2):663- 72. https://doi.org/10.13031/2013.31715. [56] Heuvelink E. Tomato growth and yield: quantitative analysis and synthesis. Wageningen University and Research; 1996. [57] Zhou X, Liu Q, Katzin D, Qian T, Heuvelink E, Marcelis LFM. Boosting the prediction accuracy of a process- based greenhouse climate- tomato production model by particle filtering and deep learning. Comput Electron Agric 2023;211. https://doi.org/10.1016/j.compag.2023.107980. [58] Katzin D, Marcelis LFM, van Hemlert EJ, van Mourik S. Heating greenhouses by light: a novel concept for intensive greenhouse production. Biosyst Eng 2023;230: 242- 76. https://doi.org/10.1016/j.biosystemseng.2023.04.003. [59] Trigui M, Barrington S, Gauthier L. A strategy for greenhouse climate control, part I: Model development. J Agric Eng Res 2001;78(4):407- 13. https://doi.org/10.1006/jaer.2000.0647. [60] Incrocci L et al., Irrigation management of European greenhouse vegetable crops, 2020, Elsevier B.V. doi: 10.1016/j.agwat.2020.106393. [61] Gong X, Qiu R, Sun J, Ge J, Li Y, Wang S. Evapotranspiration and crop coefficient of tomato grown in a solar greenhouse under full and deficit irrigation. Agric Water Manag 2020;235. https://doi.org/10.1016/j.agwat.2020.106154. [62] Zhang J, et al. Optimizing irrigation schedules of greenhouse tomato based on a comprehensive evaluation model. Agric Water Manag 2024;295. https://doi.org/10.1016/j.agwat.2024.108741. [63] Rahman MS, Guo H. Sensitivity analysis of the DehumReq model to evaluate the impact of predominant factors on dehumidification requirement of greenhouses in cold regions. Inf Process Agriculture 2023;10(2):216- 28. https://doi.org/10.1016/j.inpa.2022.01.004.

[64] Van Beveren PJM, Bontsema J, Van Straten G, Van Henten EJ. Minimal heating and cooling in a modern rose greenhouse. Appl Energy 2015;137:97- 109. https://doi.org/10.1016/j.apenergy.2014.09.083. [65] Kamrani F, Montazeri M, Banakar A, Ghobadian B, Pasdarshahri H. Experimental performance and evaluation of direct evaporative cooling system coupled with a desiccant wheel in a closed greenhouse. Energy Convers Manage: X 2023;20. https://doi.org/10.1016/j.ecmx.2023.100497. [66] Bambara J, Athienitis AK. Energy and economic analysis for the design of greenhouses with semi- transparent photovoltaic cladding. Renew Energy 2019;131:1274- 87. https://doi.org/10.1016/j.renener.2018.08.020. [67] Levitt HJ, Gaspar R. Energy budget for greenhouses in humid- temperate climate, 1988. [68] Vanthoor BHE, Stanghellini C, Van Henten EJ, De Visser PHB. A methodology for model- based greenhouse design: Part 1, a greenhouse climate model for a broad range of designs and climates. Biosyst Eng 2011;110(4):363- 77. https://doi.org/10.1016/j.biosystemseng.2011.06.001. [69] Zhang G, Ding X, Li T, Pu W, Lou W, Hou J. Dynamic energy balance model of a glass greenhouse: an experimental validation and solar energy analysis. Energy 2020;198. https://doi.org/10.1016/j.energy.2020.117281. [70] Roy JC, Boulard T, Kittas C, Wang S. Convective and ventilation transfers in greenhouses, part 1: the greenhouse considered as a perfectly stirred tank. Biosyst Eng 2002;83(1):1- 20. https://doi.org/10.1016/bioe.2002.0107. [71] Nauta A, Han J, Tasnim SH, Lubitz WD. A new greenhouse energy model for predicting the year- round interior microclimate of a commercial greenhouse in Ontario, Canada. Inf Process Agric 2023. https://doi.org/10.1016/j.inpa.2023.06.002.