# Thermal environment model construction of Chinese solar greenhouse based on temperature-wave interaction theory

Yong Zhang a,b,\*, Lianghe Xu b,c, Xiaohong Zhu b,c, Bin He b, Yu Chen b,c

a College of Landscape Architecture and Art, Northwest A&F University, Yang Ling 712100, China  b Key Laboratory of Northwest Facilities Horticultural Engineering, Ministry of Agriculture and Rural Affairs, Northwest A&F University, Yang Ling 712100, China  c College of Horticulture, Northwest A&F University, Yang Ling 712100, China

# ARTICLEINFO

Article history:  Received 31 August 2022  Revised 28 October 2022  Accepted 7 November 2022  Available online 11 November 2022

Keywords:  Chinese solar greenhouse  Temperature wave interaction  Thermal environment model  Thermal performance design  Dimension analysis  Energy storage wall

# ABSTRACT

Chinese solar greenhouse (CSG) is an important energy- saving building to ensure the winter production of crops, but it still faces the problem of unbalanced supply and demand between actual thermal performance and crop temperature demand. The purpose of this study is to establish the relationship between greenhouse thermal environment simulation and thermal performance design and to put forward specific thermal performance requirements for the main heat storage components (walls) in the greenhouse design stage. Therefore, this study proposed a method to construct the thermal environment fluctuation model of Chinese solar greenhouse based on temperature- wave interaction theory. The method used dimensional analysis method to comprehensively analyze the related physical quantities of greenhouse thermal environment, explored the temperature fluctuation interaction among indoor air, energy storage wall and outdoor air, and constructed the thermal environment fluctuation model of Chinese solar greenhouse. Finally, the thermal environment fluctuation equation of Chinese solar greenhouse was established under the external climatic conditions in Xi'an, Shaanxi Province, and verified by the measured data of the experimental greenhouse. The experimental results show that the mean absolute error (MAE) between the predicted and measured indoor air temperature is  $0.56^{\circ}\mathrm{C}$ , the root mean square error (RMSE) is  $1.04^{\circ}\mathrm{C}$ , and the determination coefficient  $(\mathbb{R}^2)$  is 0.9956  $(n = 2822)$ . The model and equation accurately described the interaction between greenhouse internal components and the external greenhouse environment. The study put forward specific thermal performance design requirements for the main heat storage components (walls) in greenhouse, and also provided a new research method for the thermal environment model of Chinese solar greenhouse.

$\mathfrak{G}$  2022 The Author(s). Published by Elsevier B.V. This is an open access article under the CC BY- NC- ND license (http://creativecommons.org/licenses/by- nc- nd/4.0/).

# 1. Introduction

As of 2019, the total area of greenhouses in China has reached 1.9637 million hectares, of which the area of solar greenhouse is 57.74 million hectares [1], accounting for about  $29.4\%$  of the total area. Chinese solar greenhouse (CSG) has played a huge role in realizing the annual supply of fresh fruits and vegetables. However, in production practice, CSG still faces the dilemma of unequal supply and demand between actual production performance and crop temperature demand. This results in seasonal idleness and waste of a large number of new greenhouses, affecting the healthy development of the greenhouse industry. The fundamental reason for this is that in the process of greenhouse design and due to the lack of relevant basic theoretical research, there is a lack of clear thermal performance index requirements for key building components of greenhouses at the beginning of their industrial design.

# 1.1. Two widely used solutions

At present, there are two solutions widely recognized and applied. One is to establish a thermal environment model of solar greenhouse and select suitable cultivated crops according to the simulation results to improve greenhouse utilization efficiency. The construction methods and approaches of thermal environment models in existing research mainly include the following three types: (1) Mathematical calculation model based on heat transfer and thermodynamics. Wu et al. [2] considered the influence of crops on the thermal environment in the greenhouse, and established a temperature prediction mathematical model under the condition of crop growth in the solar greenhouse. Dong et al. [3]

# Nomenclature

$E$  Solar irradiance  $(W / m^2)$ $q_{sw}$  Heat flux of greenhouse energy storage wall  $(W / m^2)$ $q_{r}$  Heat flux of greenhouse front roof  $(W / m^2)$ $q_{iw}$  Heat flux of internal surface of greenhouse insulation wall  $(W / m^2)$ $S_{s}$  Solar radiation acceptance area of greenhouse  $(m^2)$ $S_{sw}$  Area of greenhouse energy storage wall  $(m^2)$ $S_{r}$  Area of greenhouse front roof  $(m^2)$ $S_{iw}$  Area of greenhouse insulation wall  $(m^2)$ $T_{i}$  Indoor air temperature  $(^{\circ}C)$ $T_{sw}$  Temperature of energy storage wall  $(^{\circ}C)$ $T_{o}$  Outdoor air temperature  $(^{\circ}C)$ $V_{i}$  Indoor air temperature volume  $(m^3)$ $P_{S}$  Solar radiation power of greenhouse (W)  $Psw$  Heat storage and release power of energy storage wall (W)  $Pr$  Heat conductive power of greenhouse front roof (W)  $Piw$  Heat conductive power of internal surface of greenhouse insulation wall (W)

$\overline{T_{sw}}$  Average temperature of the energy storage wall during daytime operation  $(^{\circ}C)$ $\overline{T_{sw - m}}$  Average temperature of the energy storage wall during the daytime operation stage of the regression model  $(^{\circ}C)$ $\overline{T_{i}}$  Average indoor air temperature during daytime operation  $(^{\circ}C)$ $\overline{T_{i - m}}$  Average indoor air temperature during the daytime operation stage of the regression model  $(^{\circ}C)$ $e$  Natural number (2.71828)  $T_{cc - day}$  Daytime temperature compensation curve of the regression model  $(^{\circ}C)$ $T_{cc - night}$  Nighttime temperature compensation curve of the regression model  $(^{\circ}C)$ $a,b,c,d,f,g,h,j,k,l,n,t,u,w,l,n$  Model parameters to be determined (- )

validated and analyzed the applicability of CSG in Canada using the optimized solar greenhouse thermal environment model. Liu et al. [4] divided the energy sources of indoor air into five categories: ventilation, air leakage, convection, water vapor liquidation, and plants, creating a transient greenhouse model that uses weather forecasts to predict future greenhouse climate conditions. Zhang et al. [5] based on energy balances between the greenhouse system and outside environment and each component in the greenhouse system established the mathematic model of thermal environment of solar greenhouse. Esmaeili et al. [6] built a greenhouse thermal model by analyzing and calculating the energy balance process of indoor air. The thermal environment model established by Baglivo et al. [7] can be used to analyze the temperature change rule of one year in greenhouse, which has positive significance for guiding the annual production of greenhouse. (2) Simulation model based on computational fluid dynamics (CFD). The applying CFD to simulate greenhouse is another effective way. Kim et al. [8] applied CFD simulation to analyze the indoor air temperature field and wind speed flow field. Wei et al. [9] studied the temperature distribution inside the greenhouse and the change rule of ventilation airflow through the established greenhouse CFD simulation model. Dhiman et al. [10] used CFD simulation to study the internal temperature variation of a greenhouse with heating pipes. Some researchers also used Transient System Simulation Program software to simulate the greenhouse thermal environment from the perspective of energy consumption analysis [11- 15]. (3) Data learning model based on neural network. Neural network models are also often used in greenhouse thermal environment simulation. Based on multi- layer perceptron neural network models, Taki et al. [16] took outside air temperature, wind speed, solar radiation on the roof, inside soil temperature and inside air humidity as input variables to establish a greenhouse temperature prediction model and accurately predict the indoor air temperature. Yu et al. [17] proposed a CSG temperature forecasting model based on the improved particle swarm optimization- least square support vector machine method, with the input variables of the outside temperature, air humidity, solar radiation, soil temperature, wind speed and soil moisture. Zou et al. [18] proposed a temperature and humidity prediction model based on convex bidirectional extreme learning machine to predict solar greenhouse temperature and humidity. Jung et al. [19] applied three deep- learning- based neural network models: Artificial neural network, Nonlinear autoregres-

sive exogenous model, and Recurrent neural networks- Long short- term memory, to predict environmental changes in temperature and humidity within a greenhouse. Moon et al. [20] utilized two- dimensional convolutional neural networks to establish the relationship between indoor temperature, outdoor temperature, indoor relative humidity, indoor  $\mathrm{CO_2}$  concentration, and radiation to estimate the greenhouse temperature environment.

Although these studies provide a rich theoretical basis and guiding experience for the planned production of greenhouses, they do not establish direct thermal performance requirements for greenhouse building components, and cannot directly determine the thermal performance design indicators of greenhouse components according to the temperature requirements in the greenhouse. So cannot guide the design process.

The other is to use the establishment of greenhouse optimization design model. It has always been the basis of greenhouse performance evaluation and greenhouse building structure design to explore the correspondence between thermal environment indexes and related physical parameters in solar greenhouse. Ma et al. [21] and Meng et al. [22] developed a visual simulation and prediction software for the thermal environment of solar greenhouse based on Visual Basic and Visual  $\mathbb{C} + +$  programming languages based on constructing a greenhouse thermal environment model. It can predict and evaluate the thermal environment performance of solar greenhouse with given greenhouse types and structural parameters, then determine the optimal design scheme. Zhang et al. [23] proposed a comprehensive evaluation model of weighted entropy and fuzzy optimization methods based on CFD simulation platform to improve the indoor temperature environment of CSG and optimize the thickness of north wall. Zhang et al. [24] and He et al. [25] analyzed the ventilation process of solar greenhouse based on CFD simulation, obtained the optimized structural design parameters of greenhouse ventilation system. Mazzeo et al. [11] further proposed that the appropriate glass material and ventilation area can be determined according to the climatic characteristics of different climatic regions. Chen et al. [26] derived the calculation equation of the geometric size of the passive solar greenhouse, which could quickly optimize the greenhouse structural parameters (greenhouse height- span ratio, span and north wall height, etc.) based on environmental data such as solar radiation and outdoor air temperature. Mahdavi et al. [27] evaluated and analyzed the effect of photovoltaic/photothermal

collectors on the thermal environment of greenhouses and proposed an optimized design.

Although these studies have proposed optimization schemes for greenhouse thermal performance from various aspects. However, the relationships between greenhouse components and environmental parameters established in these studies are mostly implicit in numerical formulas such as complex partial differential equations or computer software assembly programs. Therefore, there is no derivation to form a directly available multi- parameter coupling relationship equation.

A review of existing studies shows that both the use of simulation tools to simulate the performance of existing or designed greenhouses to verify the achieve degree of the design goals and the optimization of greenhouse structures according to simulation results are all based on the premise that all designs of a greenhouse have been completed before a subsequent series of analytical studies can be carried out. Its workflow is shown in Fig. 1(a). The workflow needs to repeat the 'optimization design- performance analysis' design process. This is essentially a posteriori evaluation and a working model of crop adaptation to greenhouse design.

However, the industry needs a greenhouse design method with crop demand as the core, and its brief workflow is shown in Fig. 1 (b). This is essentially a priori evaluation. It is an innovative design working for greenhouse design to serve crops. It is more conducive to solving the problem of unequal supply and demand between actual greenhouse thermal performance and crop temperature requirements.

# 1.2. An innovative solution

In view of the above industrial needs and research status, this study proposes to apply an innovative thermal environment model to establish a direct relationship between greenhouse indoor thermal environment and thermal performance of greenhouse components and outdoor environmental characteristics. Then use this direct connection to derive and determine the thermal perfor mance design index of the greenhouse construction according to the climatic characteristics of the external environment and the greenhouse thermal environment target. In order to realize the overall thermal performance optimization of the greenhouse in the design stage, and strive to fundamentally solve the problem of unequal supply and demand between the actual production thermal performance of the greenhouse and the temperature demand of the crop.

The dimensional analysis method is a method proposed by Backingham to establish a mathematical model in the field of physics. It can effectively analyze and explore the complex and unknown links between physical quantities, and establish a concise logical relationship between various physical quantities [28]. As the main heat storage structure in CSG, the energy storage wall plays a huge buffer role in maintaining the stability of indoor air temperature. At night, the energy storage wall can maintain a large heat release power value, so there is a direct and indirect connection between the temperature and indoor air temperature. Ling et al. [29] and Chen et al. [30] designed a hollow active- passive ventilation wall, using the air duct to transfer the surplus heat of the greenhouse to the inside of the wall, increasing the internal temperature of the wall, thus improving the indoor air temperature at night. Zhang et al. [31] and Ren et al. [32] designed a new type of straw block wall, which improved the stability of indoor thermal environment by using its large heat storage performance. Zhang et al. [5] analyzed 5 kinds of CSG with different back wall materials and found that there were significant differences in indoor air temperature at night. Guan et al. [33] designed a wall with a flat micro- heat pipe, which used the excellent thermal conductivity of the heat pipe to increase the wall temperature, thereby improving the indoor thermal environment. The thermal insulation layer on the outer surface of the wall can effectively reduce the lag effect of the wall temperature and improve the heat storage and release performance of the wall [34],  $60~\mathrm{mm}$  [35] and  $100~\mathrm{mm}$  [36] polystyrene insulation board and  $200~\mathrm{mm}$  [37] thick foamed cement can effectively reduce the wall night heat dissipation and

![](images/a2c83712c6ac35782edab4687bd9cd2bc50ac01392a9e47114ddd0bfba80bd58.jpg)  
Fig.1. Comparison of workflow.

improve the indoor temperature at night. Adding phase change materials to wall building materials can significantly change the heat storage and release characteristics of the wall [38]. Berroug et al. [39] designed a phase change energy storage wall, which changed the downward trend of wall temperature, thereby increasing the indoor air temperature at night. Zhang et al. [40] hung a large number of phase change blocks on the back wall skeleton of the assembled CSG, so that the back wall had a stable temperature change and improved the indoor thermal environment. The above research shows that changing the energy storage structure and material of the rear wall can change its original heat storage and release characteristics and temperature change law, thus affecting the indoor air temperature fluctuation law [41]. Therefore, this study proposes to use the temperature fluctuation law as the thermal performance design index of the energy storage wall. The first stage is the comprehensive analysis of greenhouse thermal environment- related physical quantities by dimensional analysis. The second stage is to explore the interaction of temperature fluctuation between the indoor air, the energy storage wall, and the outdoor air. The third stage is to establish the model and equation of the multi- parameter coupling response between the thermal environment of CSG, greenhouse structure parameters, and external meteorological characteristics. This is a feasible technical method to solve the above problems.

The main purpose of this paper is to establish a thermal environment model which can provide direct index requirements for greenhouse thermal performance design. We refer to as thermal environment fluctuation model of CSG.

Compared with the existing greenhouse thermal environment simulation model and thermal performance design model, the novelty of this paper is mainly reflected in the following two aspects:

1. The thermal environment fluctuation model of CSG is proposed, and the direct relationship between the thermal environment of greenhouse, the thermal performance of greenhouse components, and the characteristics of outdoor environment is established. The thermal performance design index of greenhouse construction can be deduced and determined according to the climate characteristics of external environment and the thermal environment target of greenhouse. It provides an innovative technical method for greenhouse thermal performance design based on crop demand.

2. The wave equation of multi-parameter coupling response of CSG thermal environment is derived, which can accurately and quickly calculates the thermal performance index of the main energy storage components (walls) in the greenhouse design stage, and provides direct index requirements for the scientific design of thermal performance of greenhouse building components.

In this paper, the Section 2 detailed describes the experimental greenhouse and experimental methods. The Section 3 discusses the construction method and process of the thermal environment fluctuation model of CSG in detail. The Section 4 verifies and analyzes the prediction results of the thermal environment fluctuation model of CSG. The Section 5 discusses the differences between different construction methods of thermal environment models in establishing the corresponding expression equations of thermal environment multi- parameter coupling.

# 2. Test materials and methods

# 2.1. Experimental greenhouse

In order to explore the temperature fluctuation interaction between the external environment temperature and the internal environment temperature of CSG and the temperature of its energy storage wall, an experimental greenhouse was built at Northwest A & F University. The experimental greenhouse (Fig. 2) is an equalscale scaling model of CSG. The span of the north and south regions of the greenhouse is  $920~\mathrm{mm}$  the length of the east and west region is  $1000\mathrm{mm}$  the ridge height is  $600~\mathrm{mm}$  and the greenhouse skeleton is surrounded by a  $134\mathrm{- mm}$  composite insulation structure (double- sided woodworking board, two- component polyurethane foam, double- sided woodworking board with dimensions of  $17~\mathrm{mm}$ $100~\mathrm{mm}$  and  $17~\mathrm{mm}$  respectively), which is collectively called the greenhouse insulation wall. The energy storage wall is located at the front side of the heat preservation wall and is the only heat storage and release structure in the greenhouse. The interval between the energy storage wall and the heat preservation wall is  $200~\mathrm{mm}$  In order to reduce the influence of ground heat dissipation on the test, the greenhouse ground adopts the same composite insulation structure. The transparent cover material for the front roof is  $5\mathrm{- mm}$  - thick glass and the insulation cover material is  $30 - \mathrm{mm}$  - thick composite heat preservation quilt. The experimental greenhouse has good air tightness that can effectively block the gas exchange inside and outside of the greenhouse. The physical parameters of the test greenhouse building materials are shown in Table 1.

# 2.2. Test methods and instruments

# 2.2.1. Test method

CSG is a semi- closed space system and its energy exchange with the outside world mainly includes conduction heat transfer, gap heat transfer, ground heat transfer, and radiation heat transfer. Due to the existence of a temperature difference inside and outside of the greenhouse, the process of conduction heat transfer always occurs in each enclosure structure of the greenhouse and the heat dissipation is related to the area and heat flux of the maintenance structure. Zhang et al. [42] found that the heat dissipation of the front roof, the rear roof, the rear wall, and the side wall of a brick- wall CSG at night (18:00 to 8:00 the next day) accounted for  $76.1\%$ $10.7\%$ $11.5\%$  and  $1.7\%$  of the total heat dissipation, respectively. Therefore, this study measured the heat flux of the conduction heat transfer of the front roof, the rear roof, the insulation rear wall, and the east- west mountain wall of the greenhouse. The gap heat transfer is generally calculated according to the CSG design specification (NY/T 3223- 2018). There are no additional direct measurement methods and the greenhouse air tightness in this experiment is good. Therefore, the discussion of gap heat transfer is not involved in this paper. Most of the heat accumulated by the greenhouse soil in the daytime will return to the indoor environment at night and only a small portion will enter the external environment through horizontal transmission [43]. In this study, the greenhouse ground is the heat insulation material consistent with the wall, so the heat transfer in the ground and the heat transfer through the enclosure structure are combined and analyzed. The external solar radiation periodically supplements the energy inside the CSG through the front roof. Some of the energy is stored in the form of internal energy, such as the energy storage wall. This process is related to the solar radiation entering the greenhouse and the heat flux on the surface of the energy storage wall. The energy storage wall is divided into the front and rear two heat storage and release planes.

# 2.2.2. Test instruments and test methods

This experiment was conducted from the perspective of CSG following the law of energy conservation, focusing on the air temperature inside and outside the greenhouse, the heat flux and temperature of the inner surface of the insulation wall, the inner surface of the front roof, the inner surface of the ground, the front and rear surfaces of the energy storage wall, and the solar irradiance near the inner surface of the front roof. The structure diagram

![](images/a8f90bb444681f3df0660a4841375a67932c6240bec9e17a0cec30346e3dd4e2.jpg)  
Fig. 2. Experimental greenhouses.

Table 1 Physical parameters of greenhouse building materials.  

<table><tr><td>Material</td><td>Heat storage coefficient W/(m²·k)</td><td>Thermal diffusivity mm²/s</td><td>Thermal conductivity W/(m·k)</td><td>Thickness m</td><td>Transmissivity %</td></tr><tr><td>Blockboard</td><td>0.13</td><td>1.964</td><td>0.261</td><td>0.017</td><td>-</td></tr><tr><td>Polyurethane foam</td><td>0.17</td><td>0.401</td><td>0.067</td><td>0.10</td><td>-</td></tr><tr><td>Concrete energy storage wall</td><td>0.52</td><td>2.543</td><td>1.322</td><td>0.08</td><td>-</td></tr><tr><td>Glass</td><td>0.22</td><td>4.920</td><td>1.079</td><td>0.005</td><td>86</td></tr><tr><td>Insulation quilt</td><td>0.15</td><td>0.854</td><td>0.128</td><td>0.03</td><td>-</td></tr></table>

of the test greenhouse and the layout of the measurement points are shown in Fig. 3.

The indoor air temperature  $(③)$  was recorded every 1 min by an accurate HOBO MX2301A and recorded. The temperature of the front surfaces  $(②)$  and rear surfaces  $(①)$  of the energy storage wall was read and stored every 1 min by an accurate HFM- 8 (sensor: HS- 30). The conduction heat flux density of the front surface (3) and back surface (2) of the energy storage wall, the inner surface of the east gable (4), the inner surface of the west gable (7), the inner surface of the ground (5), the inner surface of the insulation back wall (1) and the inner surface of the front roof (6) was recorded every 1 min by an accurate HFM- 8 (sensor: HS- 30). The total solar radiation heat flux in the greenhouse (6) was recorded every 1 min using an accurate HFM- 8 (sensor: TS- 34C). In addition, a weather station HOBO U30- NRC (sensor: S- THB- M002) was installed outside the test greenhouse to measure outdoor air tem

![](images/d3e6b243b8fa47a90ad27cabd731856d94e836660a4849978f575d8af7709851.jpg)  
Fig. 3. Schematic diagram of the test greenhouse structure and measuring point arrangement.

perature  $T_{i}$  and record data every 1 min. The specifications and accuracy of the sensor are shown in Table 2.

The energy storage wall is a precast concrete wall fabricated using C25 concrete (water, cement, sand ratio of 0.5: 1: 2, respectively) poured at  $900 \times 300 \times 80 \mathrm{mm}$  specifications with a smooth and homogeneous surface with standard curing of 28 days.

Note: 1. The circle in the schematic is the temperature measuring point and the triangle is the heat flux measuring point.

2. Heat flow is a directional vector whose direction points from high to low temperature and is always perpendicular to each isothermal line. In this study, the heat flow direction entering the indoor air of the CSG is defined as positive and the heat flow direction leaving the indoor air and entering other structures is defined as negative.

# 3. Construction method and process of the thermal environment fluctuation model of CSG

According to the construction principle of thermal environment fluctuation model of CSG, the following assumptions are made:

1. The energy storage wall is the most important heat storage structure in CSG. 
2. The indoor air temperature of CSG is uniform. 
3. The air tightness of CSG is good, and there is no gas substance exchange inside and outside the greenhouse.

# 3.1. Relevant physical dimensional analysis

Physical parameters directly related to the construction of the thermal environment in the CSG were selected for dimensional analysis. These parameters were solar irradiance, heat flux of the greenhouse energy storage wall, heat flux of the front roof of the greenhouse, heat flux of the inner surface of the greenhouse insulation wall, receiving area of solar radiation in the greenhouse, area of the greenhouse energy storage wall, area of the front roof of the greenhouse, area of the greenhouse insulation wall, indoor air temperature, temperature of the greenhouse energy storage wall (taking the average of the surface temperature front and rear), air temperature outside the greenhouse, and indoor air volume. Four basic dimensions of  $L$ ,  $M$ ,  $T$ , and  $\theta$  in the international basic dimension system are selected to express the above 12 physical dimensions, where  $L$  is the length dimension,  $M$  is the mass dimension,  $T$  is the time dimension, and  $\theta$  is the temperature dimension, as shown in Table 3.

$T_{i}$  is set as the target dependent variable of the thermal environment fluctuation model of CSG, which can be expressed by the function relation (1):

$$
T_{i} = f(T_{sw},T_{o},E,q_{sw},q_{r},q_{iw},S_{r},S_{sw},S_{m},S_{iw},V_{i}) \tag{1}
$$

and rewritten as a general expression form of the function relation.

Table 3 Physical quantity dimensional analysis.  

<table><tr><td>Physical quantity</td><td>Symbol</td><td>Unit</td><td>Dimensional</td></tr><tr><td>Solar irradiance</td><td>E</td><td>W·m−2</td><td>MT−3</td></tr><tr><td>Heat flux of greenhouse energy storage wall</td><td>qsw</td><td>W·m−2</td><td>MT−3</td></tr><tr><td>Heat flux of greenhouse front roof</td><td>qr</td><td>W·m−2</td><td>MT−3</td></tr><tr><td>Heat flux of internal surface of greenhouse insulation wall</td><td>qiw</td><td>W·m−2</td><td>MT−3</td></tr><tr><td>Solar radiation acceptance area of greenhouse</td><td>Ss</td><td>m2</td><td>L2</td></tr><tr><td>Area of greenhouse energy storage wall</td><td>Sw</td><td>m2</td><td>L2</td></tr><tr><td>Area of greenhouse front roof</td><td>Sw</td><td>m2</td><td>L2</td></tr><tr><td>Area of greenhouse insulation wall</td><td>Sw</td><td>m2</td><td>L2</td></tr><tr><td>Indoor air temperature</td><td>Ii</td><td>°C</td><td>θ</td></tr><tr><td>Temperature of energy storage wall</td><td>Tsw</td><td>°C</td><td>θ</td></tr><tr><td>Outdoor air temperature</td><td>To</td><td>°C</td><td>θ</td></tr><tr><td>Indoor air temperature volume</td><td>Vi</td><td>m3</td><td>L3</td></tr></table>

$$
f(T_{i},T_{sw},T_{o},E,q_{sw},q_{r},q_{iw},S_{t},S_{sw},S_{m},S_{iw},V_{i}) = 0 \tag{2}
$$

The dimensionless matrix A is thus established and the results are shown in Table 4.

The rank of matrix A is 3, so the homogeneous equation  $Ay = 0$  has  $12 - 3 = 9$  basic solutions. The results are shown in Table 5.

According to the Buckingham pi theorem of dimensional analysis [28], the corresponding dimension can be obtained from the basic solution matrix, and each dimension can be expressed as  $\pi_{1}$ ,  $\pi_{2}$ ,  $\pi_{3}$ ,  $\pi_{4}$ ,  $\pi_{5}$ ,  $\pi_{6}$ ,  $\pi_{7}$ ,  $\pi_{8}$ , and  $\pi_{9}$ , then:

$$
\pi_{1} = \frac{T_{i}}{T_{sw}},\pi_{2} = \frac{T_{o}}{T_{sw}},\pi_{3} = \frac{q_{sw}}{E}
$$

$$
\pi_{4} = \frac{q_{r}}{E},\pi_{5} = \frac{q_{iw}}{E},\pi_{6} = \frac{S_{sw}}{S_{s}} \tag{3}
$$

$$
\pi_{7} = \frac{S_{r}}{S_{s}},\pi_{8} = \frac{S_{iw}}{S_{s}},\pi_{9} = \frac{V_{i}}{S_{s}}
$$

There is a function  $F$  that makes

$$
F(\pi_{1},\pi_{2},\pi_{3},\pi_{4},\pi_{5},\pi_{6},\pi_{7},\pi_{8},\pi_{9}) = 0, \tag{4}
$$

which can be transformed into a special form with  $\pi_{I}$  as independent variable:

$$
\pi_{1} = \phi (\pi_{2},\pi_{3},\pi_{4},\pi_{5},\pi_{6},\pi_{7},\pi_{8},\pi_{9}). \tag{5}
$$

From Eq. (3) to Eq. (5)

$$
\frac{T_{i}}{T_{sw}} = \phi \left(\frac{T_{o}}{T_{sw}},\frac{q_{sw}}{E},\frac{q_{r}}{E},\frac{q_{iw}}{S_{s}},\frac{S_{sw}}{S_{s}},\frac{S_{r}}{S_{s}},\frac{S_{iw}}{S_{s}},\frac{V_{i}}{S_{s}}\right). \tag{6}
$$

In the formula,  $\phi$  is a function form and its specific form is determined by experimental derivation.

If the function is a power function, then

$$
\frac{T_{i}}{T_{sw}} = \frac{T_{o}}{T_{sw}}\frac{q_{sw}}{E}\frac{q_{r}}{E}\frac{q_{iw}}{E}\frac{q_{sw}}{S_{s}}\frac{f_{S}}{S_{s}}\frac{g_{SC}}{S_{s}}\frac{h_{W}}{S_{s}}\frac{V_{i}}{S_{s}}, \tag{7}
$$

Table 2 Specifications and accuracy of the sensors.  

<table><tr><td>Instrument name</td><td>Model</td><td>Measurement range</td><td>Accuracy</td><td>Resolution</td></tr><tr><td>(OUTDOOR)</td><td></td><td></td><td></td><td></td></tr><tr><td>Meteorological station</td><td>HOBO U30-NRC</td><td></td><td></td><td></td></tr><tr><td>Meteorature recorder</td><td>S-THB-M002</td><td>-40 ~ 70 °C</td><td>±0.3 °C</td><td>0.02 °C</td></tr><tr><td>(INDOOR)</td><td></td><td></td><td></td><td></td></tr><tr><td>Temperature and humidity recorder</td><td>HOBO MX2301A</td><td>-40 ~ 70 °C</td><td>±0.3 °C</td><td>0.04 °C</td></tr><tr><td>High precision heat flow data collector</td><td>HFM-8</td><td></td><td></td><td></td></tr><tr><td>Conductive heat flux sensor</td><td>HS-30</td><td>-200 ~ 200 kW/m²</td><td>±3%</td><td>0.1 W/m²</td></tr><tr><td></td><td></td><td>-180 ~ 300 °C</td><td>±3%</td><td>0.1 °C</td></tr><tr><td>Total solar radiation heat flux sensor</td><td>TS-34C</td><td>-200 ~ 200 kW/m²</td><td>±3%</td><td>0.1 W/m²</td></tr></table>

Table 4 Dimensional matrix.  

<table><tr><td>Dimensional</td><td>Ti</td><td>Tsw</td><td>To</td><td>E</td><td>qsw</td><td>qri</td><td>qiw</td><td>Ss</td><td>Ssw</td><td>Sr</td><td>Sww</td><td>Vi</td></tr><tr><td>L</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>2</td><td>2</td><td>2</td><td>2</td><td>3</td></tr><tr><td>M</td><td>0</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>T</td><td>0</td><td>0</td><td>0</td><td>-3</td><td>-3</td><td>-3</td><td>-3</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>θ</td><td>1</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr></table>

Table 5 Solving matrix.  

<table><tr><td>Physical quantity</td><td>Ti</td><td>Tsw</td><td>To</td><td>E</td><td>qsw</td><td>qri</td><td>qiw</td><td>Ss</td><td>Ssw</td><td>Sr</td><td>Sww</td><td>Vi</td></tr><tr><td>Solution 1</td><td>1</td><td>-1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 2</td><td>0</td><td>-1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 3</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 4</td><td>0</td><td>0</td><td>0</td><td>-1</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 5</td><td>0</td><td>0</td><td>0</td><td>-1</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 6</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>-1</td><td>1</td><td>0</td><td>0</td><td>0</td></tr><tr><td>Solution 7</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>-1</td><td>0</td><td>1</td><td>0</td><td>0</td></tr><tr><td>Solution 8</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>-1</td><td>0</td><td>0</td><td>1</td><td>0</td></tr><tr><td>Solution 9</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>-3/2</td><td>0</td><td>0</td><td>0</td><td>1</td></tr></table>

where  $a,b,c,d,f,g,h,$  and  $j$  are power function uncertain exponential values (the same is applied below).

The specific parameters of Eq. (7) need different greenhouse structures and types to deduce and confirm. In theory, five factors and three levels of orthogonal rotation using the orthogonal experiment method (a total of 15 greenhouse types) are needed. Based on the exploration and verification of the methodology of the thermal environment fluctuation model of CSG, this paper does not discuss the specific form of Eq. (7) but the influence of the greenhouse structure on the construction of the greenhouse thermal environment cannot be ignored. Therefore, this experiment adopts the method of merging basic physical quantities to offset the experimental requirements. Among them, the area of each enclosure and the indoor air volume are mutually substitutable, and both can reflect the geometrical parameters of the greenhouse. Therefore, the area parameters of each enclosure structure are retained, and the parameters of the greenhouse volume  $\mathbf{V}$  are simplified and discarded. The specific methods are as follows and the dimensional analysis is shown in Table 6.

$$
\begin{array}{c}{P_s = E*S_s}\\ {P_{sw} = q_{sw}*S_{sw}}\\ {P_r = q_r*S_r}\\ {P_{iw} = q_{iw}*S_{iw}} \end{array} \tag{8}
$$

$V_{i}$  is abandoned

In equation (8),  $P_{s}$  is the solar radiation power of the greenhouse,  $P_{sw}$  is the heat storage and release power of the energy storage wall,  $P_{r}$  is the heat conduction power of the front roof of the greenhouse, and  $P_{iw}$  is the heat conduction power of the greenhouse insulation wall.

Table 6 Analysis of physical dimensions after merging.  

<table><tr><td>Physical quantity</td><td>Symbol</td><td>Unit</td><td>Dimensional</td></tr><tr><td>Solar radiation power of greenhouse</td><td>Ps</td><td>W</td><td>L2MT-3</td></tr><tr><td>Heat storage and release power of energy storage wall</td><td>Psw</td><td>W</td><td>L2MT-3</td></tr><tr><td>Heat conductive power of greenhouse front roof</td><td>Pr</td><td>W</td><td>L2MT-3</td></tr><tr><td>Heat conductive power of internal surface of greenhouse insulation wall</td><td>Piw</td><td>W</td><td>L2MT-3</td></tr><tr><td>Indoor air temperature</td><td>Ti</td><td>℃</td><td>θ</td></tr><tr><td>Temperature of energy storage wall</td><td>Tsw</td><td>℃</td><td>θ</td></tr><tr><td>Outdoor air temperature</td><td>To</td><td>℃</td><td>θ</td></tr></table>

Using the reasoning method of Equations (1) - (7) above, the dimensionless function of indoor air temperature,  $T_{i}$ , after simplifying the physical quantity can be obtained as:

$$
T_{i} = \frac{T_{o}}{T_{sw}}\frac{a_{sw}}{P_{s}}\frac{b_{Pr}c_{Pr}}{P_{s}}\frac{d_{Iw}}{P_{s}} T_{sw}. \tag{9}
$$

Similarly, the dimensionless function of greenhouse energy storage wall temperature,  $T_{sw}$ , can be obtained as:

$$
T_{sw} = \frac{T_o}{T_i}\frac{a_{sw}}{P_s}\frac{b_{Pr}}{P_s}\frac{d_{Iw}}{P_s}\frac{d_{Iw}}{P_s} T_i. \tag{10}
$$

# 3.2. Diurnal variation of physical quantities in CSG

Fig. 4 is the measured data of a continuous greenhouse operation cycle (9:00 on Jan. 13th, 2021 to 9:00 on Jan. 14th, 2021) under typical sunny winter conditions in the experimental greenhouse. The opening and closing times of heat preservation are 9:34 and 17:22, respectively.

It can be seen from the figure that each curve in one operation cycle (except the outdoor air temperature curve) is divided into two parts and presents two completely different fluctuation laws. When the heat preservation quilt was opened, the heat power and temperature curves changed greatly and there was a strong energy exchange process inside and outside the greenhouse. During the period when the heat preservation quilt is closed, the solar radiation power of the greenhouse is always 0 W. Only the energy storage wall maintains a large heat release power and the average power is 37.39 W. The average power of the heat preservation wall and the front roof is 1.60 W and - 15.31 W, respectively, indicating that the energy storage wall plays a vital role in the construction of the greenhouse thermal environment.

# 3.3. Thermal environment fluctuation model of CSG

Based on the daily variation of physical parameters in the CSG, a dimensionless function equation is obtained by dimensional analysis reasoning that is structurally adjusted.

(1) A complete operation cycle of the greenhouse was divided into two operation stages, day and night, according to the opening-closing state of heat preservation.

(2) Remove  $P_{s}$  during nighttime operation.

![](images/012dd5184f8f8471124cc94fde08610ac267dfe0d18ba18aa39b2332e4ee7e3f.jpg)  
Fig. 4. Measured data of physical quantities in the CSG.

Finally, the thermal environment fluctuation model of CSG is obtained as:

Indoor air temperature: Day run phase:

$$
\begin{array}{c}{T_i = \left(\frac{T_o}{(T_{sw} - \frac{1}{2}(T_{sw}^{-} - T_{sw - m}^{-}))} +e\right)^a\left(\frac{P_{sw}}{P_s} +e\right)^b\left(\frac{P_r}{P_s} +e\right)^c\left(\frac{P_{iw}}{P_s} +e\right)^d (T_{sw}}}\\ {-\frac{1}{2} (T_{sw}^{-} - T_{sw - m}^{-})) - T_{cc - day}} \end{array}
$$

Night operation stage:

$$
T_{i} = \left(\frac{T_{o}}{T_{sw}} +e\right)^{k}\left(\frac{P_{r}}{P_{sw}} +e\right)^{l}\left(\frac{P_{iw}}{P_{sw}} +e\right)^{n}T_{sw} - T_{cc - night} \tag{12}
$$

Temperature of energy storage wall:

Day run phase:

$$
\begin{array}{c}{T_{sw} = \left(\frac{T_o}{(T_i - \frac{1}{2}(T_i - T_{i - m}^{-}))} +e\right)^f\left(\frac{P_{sw}}{P_s} +e\right)^g\left(\frac{P_r}{P_s} +e\right)^h\left(\frac{P_{iw}}{P_s} +e\right)^j (T_i}\\ {+\frac{1}{2} (T_i - T_{i - m}^{-})) + T_{cc - day}} \end{array} \tag{13}
$$

Night operation stage:

$$
T_{sw} = \left(\frac{T_o}{T_i} +e\right)^t\left(\frac{P_r}{P_{sw}} +e\right)^u\left(\frac{P_{iw}}{P_{sw}} +e\right)^w T_i + T_{cc - night} \tag{14}
$$

$T_{i}$  is the indoor air temperature of the CSG;  $T_{o}$  is the air temperature outside the CSG;  $P_{s}$  is the thermal power of solar radiation of the CSG;  $T_{sw}$  is the CSG energy storage wall temperature;  $T_{sw}$  is the average temperature of the energy storage wall during daytime operation;  $T_{sw - m}$  is the average temperature of the energy storage wall during the daytime operation stage of the regression model;  $T_{i}$  is the average indoor air temperature during daytime operation;  $T_{i}$  is the average indoor air temperature during the daytime operation stage of the regression model;  $P_{sw}$  is the heat storage and discharge power of the energy storage wall in the regression model;  $P_{r}$  is the heat conduction power of the front roof of the regression model;  $P_{iw}$  is the wall heat conduction power of the regression model;  $e$  is the natural number (2.71828);  $T_{cc - day}$  is the daytime temperature compensation curve of the regression model;  $T_{cc - night}$  is the nighttime temperature compensation curve of the regression model;  $a$ ,  $b$ ,  $c$ ,  $d$ ,  $f$ ,  $g$ ,  $h$ ,  $j$ ,  $k$ ,  $l$ ,  $n$ ,  $t$ ,  $u$ , and  $w$  are model parameters to be determined.

# 4. Results and analysis

During the model validation test, the test greenhouse was continuously monitored and recorded, between Dec. 21st, 2020 to Jan. 16th, 2021, lasting for 27 days. The winter solstice is on Dec. 22nd, 2020. The weather conditions are shown in Fig. 5. During the whole test period, the daily maximum solar radiation changed between  $164.5 \mathrm{W / m^2}$  and  $677.9 \mathrm{W / m^2}$ , and the outdoor air temperature changed between  $- 13.1 ^{\circ}\mathrm{C}$  and  $20.5 ^{\circ}\mathrm{C}$ . On continuous cloudy and snowy days, CSG usually takes measures such as artificial warming, light supplement, and daytime covering with thermal insulation quilt. At this time, the indoor air temperature is mainly affected by human factors and is less affected by the energy storage wall and the external air temperature. Therefore, the focus of the experiment analysis is the data collected on sunny days (Cloud Cover  $= 0 - 2$ , with sufficient solar radiation), and 3 days of the data are selected as typical days for detailed analysis. The 3 days selected are Jan. 1st, 2021, Jan. 13th, 2021, and Jan. 14th, 2021.

# 4.1. Solving the thermal environment fluctuation model of CSG

The model input is the measured data of a complete operation cycle (9:30 on Jan. 13th, 2021 to 9:30 on Jan. 14th, 2021) of a typical sunny winter in the CSG. The data includes: Indoor air temperature, Temperature of energy storage wall, Outdoor air temperature, Solar radiation power of greenhouse, Heat storage and release power of energy storage wall, Heat conductive power of greenhouse front roof, and Heat conductive power of internal surface of greenhouse insulation wall. SPSS 25 software is used for multiple linear regression analysis to solve the parameters to be determined in the model. The results are shown in Fig. 6 and Table 7.

Thus, the thermal environment wave equation of CSG in typical sunny winter in Xi'an area of Shaanxi is obtained. In this equation, the nighttime parameter  $k$  is 1, so the Eq. (13) can be obtained by simple deformation of the energy storage wall temperature  $T_{sw}$  solution function:

$$
T_{sw} = \frac{T_i + T_{cc - night}}{e\left(\frac{P_r}{P_{sw}} + e\right)^l\left(\frac{P_{iw}}{P_{sw}} + e\right)^n} -\frac{T_o}{e} \tag{15}
$$

$T_{i}$  is the indoor air temperature of the CSG;  $T_{o}$  is the air temperature outside the CSG;  $P_{sw}$  is the heat storage and discharge power of energy storage wall of regression model;  $P_{r}$  is the heat conduction power of the front roof of the regression model;  $P_{iw}$  is the

![](images/f36cbe3377880a1ace54826bfe579fe499195fdc6a0ef2a47f1c093dff61cb52.jpg)  
Fig. 5. Weather condition of the whole test period.

![](images/cf9a446f0bc3a6e4c15c87a6bbd1a32092bdc659ac47138b04c9e37061872167.jpg)  
Fig. 6. Temperature compensation curve of the regression model.

regression model of wall heat conduction power;  $T_{cc - night}$  is the night energy storage wall temperature compensation curve of the regression model,  $l$  and  $n$  is the parameter.

# 4.2. Verification results and analysis of the thermal environment wave equation of CSG

In order to verify the accuracy and rationality of the thermal environment wave equation of CSG established in this study, the measured data of 2 days (Jan. 1st, 2021, and Jan. 14th, 2021) under the same weather conditions were detailed and analyzed. The 2 days of measured data are shown in Fig. 7. The input data of the model are the energy storage wall (indoor air) temperature, the outdoor air temperature, and the solar radiation heat power while the output data is the indoor air (energy storage wall) temperature.

Fig. 7 and Table 8 show that the highest outdoor air temperature was  $7.9^{\circ}C$  on Jan. 1st, and  $20.5^{\circ}C$  on Jan. 14th. The temperature difference between the two days was  $12.6^{\circ}C$ . The maximum solar radiation heat power on Jan. 1st is  $509.9W$ , whereas the solar radiation heat power on Jan. 13th is  $586.2W$  and the difference is  $76.3W$ , which is about  $14.96\%$  of the maximum solar radiation heat power on Jan. 1st. Although the typical weather types are

Table 7 Solved parameters of the regression model.  

<table><tr><td>Item</td><td></td><td>Solving parameters</td><td>Regression results</td><td>Decision coefficient</td></tr><tr><td rowspan="10">Day run phase</td><td rowspan="4">Indoor air</td><td>a</td><td>1</td><td>0.990</td></tr><tr><td>b</td><td>-1.228</td><td></td></tr><tr><td>c</td><td>0.378</td><td></td></tr><tr><td>d</td><td>-0.074</td><td></td></tr><tr><td rowspan="6">Energy storage wall</td><td>Tsw-m</td><td>44.84</td><td></td></tr><tr><td>f</td><td>1.04</td><td>0.991</td></tr><tr><td>g</td><td>1.04</td><td></td></tr><tr><td>h</td><td>-1.66</td><td></td></tr><tr><td>j</td><td>-0.98</td><td></td></tr><tr><td>Ti-m</td><td>52.86</td><td></td></tr><tr><td rowspan="6">Night run phase</td><td rowspan="3">Indoor air</td><td>k</td><td>1</td><td>0.978</td></tr><tr><td>l</td><td>-0.7</td><td></td></tr><tr><td>n</td><td>-0.7</td><td></td></tr><tr><td rowspan="3">Energy storage wall</td><td>t</td><td>-0.72</td><td>0.981</td></tr><tr><td>u</td><td>0.57</td><td></td></tr><tr><td>w</td><td>0.48</td><td></td></tr></table>

![](images/2e7aedcde81bf28ad0a00734703744a283233b6d98e0f42994fbf41949feb69b.jpg)  
Fig. 7. Measured data of typical sunny temperature and solar radiation in the CSG.

Table 8 Extreme value data of typical sunny temperature and solar radiation.  

<table><tr><td>Time</td><td>Temperature of energy storage wall (℃)</td><td>Outdoor air temperature (℃)</td><td>Indoor air temperature (℃)</td><td>Solar radiation power of greenhouse (W)</td></tr><tr><td>2021.1.1</td><td>45.8</td><td>7.9</td><td>53.9</td><td>509.9</td></tr><tr><td>2021.1.13</td><td>60.3</td><td>17.8</td><td>67.8</td><td>586.2</td></tr><tr><td>2021.1.14</td><td>57.9</td><td>20.5</td><td>65.3</td><td>558.8</td></tr></table>

all sunny in the winter, there are great differences in the actual temperature conditions and the time is not continuous. The weather types, such as rain and snow in the middle interval, can better verify and analyze the accuracy and applicability of the thermal environment wave equation of CSG in typical sunny winter conditions.

# 4.2.1. Verification and analysis of indoor air temperature during daytime operation

The results in Fig. 8 show that the calculated values of indoor air temperature during the two days are consistent with the measured values and the curve is well fitted. Only during the period of 16:30 to 16:54 is there a negative deviation with an increasing trend and the temperature difference fluctuates within a small range during this period. During the entire operation stage, the average temperature error on Jan. 1st is  $1.53^{\circ}\mathrm{C}$ , the RMSE is  $2.06^{\circ}\mathrm{C}$ , the MAE is  $1.71^{\circ}\mathrm{C}$ ; the average temperature error on Jan. 14th is  $- 0.24^{\circ}\mathrm{C}$ , the RMSE is  $1.28^{\circ}\mathrm{C}$ , and the MAE is  $1.01^{\circ}\mathrm{C}$ .  $\mathbb{R}^2$  are 0.9897 and 0.9894 for Jan. 1st and 14th, respectively, after obtaining correlation analysis of the two- day data. This shows that the calculated values of daytime indoor air temperature are in good agreement with the measured values and the calculation accuracy of the two days is basically the same.

# 4.2.2. Verification and analysis of indoor air temperature during nighttime operation

Fig. 9 shows that the trend of indoor air temperature across two days is highly consistent with the measured value and the curve is well fitted. There is no large deviation period and the temperature difference fluctuation range is only approximately  $\pm 1.00^{\circ}\mathrm{C}$ . During the whole operation stage, the average temperature error on Jan. 1st was  $0.019^{\circ}\mathrm{C}$ , the RMSE is  $0.418^{\circ}\mathrm{C}$ , the MAE is  $0.280^{\circ}\mathrm{C}$ ; the average temperature error on Jan. 14th is  $0.303^{\circ}\mathrm{C}$ , the RMSE is  $0.597^{\circ}\mathrm{C}$ , and the MAE is  $0.428^{\circ}\mathrm{C}$ . The correlation analysis of the two- day data showed  $\mathbb{R}^2$  values of 0.9972 and 0.9971 for the 1st and 14th, respectively. Compared with the daytime, the calculated value of indoor air temperature at night is more consistent with the measured value and the calculation accuracy of the two days is basically the same.

![](images/ed4a7da1dc59ee1873975a7498301890e8e56abb45102ca3dcef404f72c0447f.jpg)  
Fig. 8. Verification and analysis of indoor air temperature during the day run phase.

![](images/7eec8cc51cd78205b8c3a944fd3e91026db9e0d889d03e9445e768a6bb36da0a.jpg)  
Fig. 9. Verification and analysis of indoor air temperature during the night run phase.

# 4.2.3. Validation and analysis of energy storage wall temperature during daytime operation

The results in Fig. 11- a show that the energy storage wall temperature calculation value has a large deviation only in the later stage of operation and the temperature difference gradually increases. In the first half of the operation stage (9:42 to approximately 15:30), the temperature difference only fluctuates within a small range of approximately  $\pm 2.00^{\circ}\mathrm{C}$ , but in the second half (15:30 to approximately 16:54), the temperature difference begins to increase exponentially, reaching a maximum value of about  $30^{\circ}\mathrm{C}$  before the insulation is closed.

After inspection, it is revealed that the deviation is caused by the opening- closing time of the insulation. The opening time of heat preservation on Jan. 13th is about  $30\mathrm{min}$  longer than that of the other two days. Therefore, the  $P_{\|}$ of Jan. 13th in the calculation model still maintains a large power value (about  $130\mathrm{W}$ ), which is about  $60\%$  higher than the actual value (about  $80\mathrm{W}$ ), resulting in large errors in temperature calculation models. During the entire operation stage, the average temperature error on Jan. 1st is  $0.37^{\circ}\mathrm{C}$ , the RMSE is  $4.45^{\circ}\mathrm{C}$ , the MAE is  $2.16^{\circ}\mathrm{C}$ ; the average temperature error on Jan. 14th is  $2.24^{\circ}\mathrm{C}$ , the RMSE is  $5.71^{\circ}\mathrm{C}$ , and the MAE is  $2.98^{\circ}\mathrm{C}$ . Correlation analysis of this two- day data shows that the  $\mathbb{R}^2$  values are 0.9067 and 0.8683, respectively. The larger RMSE and smaller  $\mathbb{R}^2$  indicate that the thermal environment wave equation of CSG has certain limitations in calculating the temperature of the daytime energy storage wall, requiring further adjustment and optimization.

According to the calculation of the heat flow data on the surface of the energy storage wall, the heat storage capacity of the energy storage wall during Jan. 1st and 14th was  $1984.57\mathrm{kJ}$  and  $2068.25\mathrm{kJ}$ , respectively.

# 4.2.4. Validation and analysis of energy storage wall temperature during nighttime operation

It can be seen from Fig. 10 that the calculated temperature of the energy storage wall during the night operation stage is highly consistent with the measured value. There was no large deviation. The temperature difference fluctuates between  $- 1.50^{\circ}\mathrm{C}$  and  $1.50^{\circ}\mathrm{C}$ . During the whole operation stage, the average temperature error on Jan. 1st is  $0.51^{\circ}\mathrm{C}$ , the RMSE is  $0.73^{\circ}\mathrm{C}$ , the MAE is  $0.56^{\circ}\mathrm{C}$ , the average temperature error on Jan. 14th is  $- 0.33^{\circ}\mathrm{C}$ , the RMSE is  $0.56^{\circ}\mathrm{C}$ , and the MAE is  $0.45^{\circ}\mathrm{C}$ . The correlation analysis of the two- day data showed that the  $\mathbb{R}^2$  values are 0.9975 and 0.9973, respectively. Compared with daytime, the calculated value of indoor air temperature at night is more consistent with the measured value and the calculation accuracy of these two days is basically the same.

According to the calculation of the heat flow data on the surface of the energy storage wall, the heat load of the energy storage wall is  $1578.72\mathrm{kJ}$  and  $1839.49\mathrm{kJ}$  respectively on the night of Jan. 1st and 14th.

# 4.3. Optimization research of the thermal environment wave equation of CSG

Under the premise of fully verifying the correctness of the thermal environment wave equation of CSG and in order to weaken the influence of the opening- closing time of the thermal insulation on the calculation results to further improve the applicability and accuracy of the thermal environment wave equation, a correlation analysis of several groups of physical quantities closely related to the generation of calculation errors was studied to explore structural optimization of the equation.

![](images/e15d05f19234170b28dbec28bde3bc71dd12c42ee445c65b3c1d664602fb3090.jpg)  
Fig. 10. Verification and analysis of the energy storage wall temperature during the night run phase.

![](images/9e39e1fe680852a32e7116946b57195eebbe0f986fbbad839716febfc4f793cd.jpg)  
Fig. 11. Verification and analysis of energy storage wall temperature in day run phase.

4.3.1. Optimization of the thermal environment wave equation of CSG

In the thermal environment wave equation of CSG established in this study,  $P_{iw}, P_{r},$  and  $P_{sw}$  are all generated in the regression solution of the model. On this basis, the model application personnel only need to draw the greenhouse  $T_{i}, T_{o}, P_{s}$  values and other data according to production demand and field meteorological data to calculate the thermal performance index parameters meeting production demand. Therefore, correlation analysis of  $P_{s}, P_{iw}, P_{r}, P_{sw},$  and other physical quantities closely related to the calculation error is carried out. The analysis results are shown in Table 9.

Table 9 shows that the best comprehensive correlation is between  $P_{s}$  and other physical quantities in the greenhouse with  $\mathbb{R}^2$  values of 0.673, 0.936, and 0.968. Therefore,  $P_{r}$  and  $P_{sw}$  in the thermal environment wave equation are structurally optimized by abandoning  $P_{iw}$  with low correlation and taking  $P_{s}$  as independent variables. The regression equations are:

$$
y_{1} = -0.418x + 98.623 \tag{16}
$$

And

wall, and  $y_{2}$  is the heat conduction power of the front roof of the greenhouse.

The optimized thermal environment wave equation of the energy storage wall during the daytime operation stage is obtained by combining eq. (16) and eq. (17) with eq. (13) and Table 7:

$$
\begin{array}{r l} & {T_{s w} = \left(\frac{T_{o}}{(T_{i} - \frac{1}{2}(T_{i}^{-} - 52.86))} +e\right)^{1}\left(\frac{(-0.418P_{s} + 98.623)}{P_{s}} +e\right)^{1.04}}\\ & {\qquad \times \left(\frac{(-0.366P_{s} - 45.843)}{P_{s}} +e\right)^{-1.66}\left(\frac{P_{i w}}{P_{s}} +e\right)^{-0.98}}\\ & {\qquad \times (T_{i} + \frac{1}{2} (\bar{T_{i}} -52.86)) + T_{c c - d a y}} \end{array} \tag{18}
$$

4.3.2. Verification and analysis of the optimized equation

In order to test the accuracy and rationality of the optimized equation, the above method is used to verify and analyze.

The results of Fig. 11 show that compared with the prediction of the temperature of the energy storage wall by Eq. (13) (Fig. 11- a), the prediction accuracy of the optimized Eq. (18) (Fig. 11- b) has been greatly improved. Compared with those values obtained before optimization, the MAE of the two days decreased by  $2.20^{\circ}C$  and  $4.51^{\circ}C$ , respectively. The absolute error decreased from  $30^{\circ}C$  to  $5^{\circ}C$ , and the  $\mathbb{R}^2$  value increased from 0.9067 to 0.9877,

Table 9 Correlation analysis of physical quantities.  

<table><tr><td>Coefficient of determination R²</td><td>P5</td><td>Piw</td><td>Pr</td><td>Psw</td></tr><tr><td>P5</td><td>1</td><td>0.6729</td><td>0.9362</td><td>0.9683</td></tr><tr><td>Piw</td><td>0.6729</td><td>1</td><td>0.4663</td><td>0.7934</td></tr><tr><td>Pr</td><td>0.9362</td><td>0.4663</td><td>1</td><td>0.8621</td></tr><tr><td>Psw</td><td>0.9683</td><td>0.7934</td><td>0.8621</td><td>1</td></tr></table>

which greatly weakened the calculation error caused by the different opening- closing times of the heat preservation quilt. The reason for this was that the fitted  $P_{r}$  and  $P_{sw}$  values obtained by regression Eq. (16) and Eq. (17) were closer to the actual values of the greenhouse under this condition according to the input value,  $P_{s}$ .

In summary, the fitting regression optimization effectively reduces the influence of the opening- closing time of the heat preservation quilt on model accuracy and improves the accuracy and adaptability of the equation.

# 4.4. Comparative analysis of prediction accuracy with existing modeling methods

The cumulative error of the two verification dates  $(n = 2822)$  of the thermal environment fluctuation model of CSG was calculated in detail, and compared with the greenhouse thermal environment model with common modeling methods. The results are shown in Table 10. The prediction accuracy of the thermal environment fluctuation model of CSG for indoor air and energy storage wall temperature is basically the same, and the difference of prediction accuracy is small. The average temperature errors are  $0.309^{\circ}C$  and  $- 0.130^{\circ}C$ , respectively, which are the best in all thermal environment models and far less than other models. The MAE are  $0.661^{\circ}C$  and  $0.760^{\circ}C$ , respectively, which are slightly higher than other thermal environment models. The RMSE are  $1.040^{\circ}C$  and  $1.135^{\circ}C$ , respectively, which are at a medium level in all thermal environment models. The  $R^2$  are 0.9956 and 0.9909, respectively. The correlation is excellent and much higher than other thermal environment models. The comparison results show that the thermal environment fluctuation model has higher prediction accuracy and is superior to most existing thermal environment models. It can not only effectively simulate and predict the thermal environment of indoor air, but also accurately calculate the temperature wave demand characteristics of energy storage wall.

# 5. Discussion

In this study, the dimensional analysis method is used to explore the interaction of the temperature fluctuation between the external environment, the indoor air and energy storage wall temperature. The thermal environment fluctuation model of CSG and the thermal environment wave equation of CSG are established, providing a universal, simple, and direct index requirement and design method for the thermal performance design of CSG building components.

Although a large number of studies have been reported on the greenhouse thermal environment model [47,48], these studies have not explored the interaction between the thermal environment in the greenhouse and the related physical quantities. As a relatively independent energy system, the CSG follows the energy conservation principle of classical thermodynamics. The energy flow of each physical process in the system jointly maintains a dynamic balance of the indoor thermal environment. By analysis of energy equations for these physical processes, a greenhouse thermal environment model can be established. Although the energy storage wall temperature and the indoor air temperature are often used as two verification objects of the thermal environment model [21,49], there are few studies on the interaction between the two. CFD can establish a complete simulation model of CSG based on mass, momentum, and energy conservation equations, as well as other model equations to calculate and obtain simulation results for the temperature field at any point in a greenhouse. However, the essence of the solution is to discretize a mathematical model of a continuous medium that describes fluid motion into a large algebraic equation group and establish an algorithm that can be solved on the computer. Temperature field simulation results at each point are essentially solution values without a physical meaning of the equation group [50]. Therefore, only algebraic relations can be established between each other and the algebraic relations are mostly high- order equations or equations with complex differential and partial differential equations. A simple model of interaction between physical quantities cannot be established.

Similarly, an error back propagation (BP) neural network completes the weight adjustment of a multi- layer feedforward neural network of nonlinear continuous function through the error back propagation algorithm and obtains the minimum error square sum network model to learn and store a large number of input- output mode mapping relations. This finally realizes the fitting and prediction of multiple nonlinear complex functions between input- output data [51,52]. In essence, the neural network model is also a numerical calculation and the operation process does not follow basic mathematical operation rules, the output result is a simple value with no physical meaning. The multi- parameter coupling interaction relationship constructed in this study follows mathematical operation rules in the input stage, the calculation stage, and the output stage. At the same time of numerical calculation, the unit of each physical quantity is calculated by the equation and the final output unit is in units of  $^\circ \mathrm{C}$ ; the output term is a temperature with physical significance. Therefore, compared with simulation calculations and neural networks, the multi-

Table 10 Model prediction accuracy analysis.  

<table><tr><td>Comparative literature</td><td></td><td>Modeling method</td><td>Mean temperature difference °C</td><td>MAE</td><td>RMSE</td><td>Measured temperature range °C</td><td></td></tr><tr><td rowspan="2">Thermal environment fluctuation model</td><td>Indoor air</td><td>-</td><td>0.309</td><td>0.661</td><td>1.040</td><td>1.7 ~ 65.2</td><td>0.9956</td></tr><tr><td>Energy storage wall</td><td>-</td><td>-0.130</td><td>0.760</td><td>1.135</td><td>6.0 ~ 58.0</td><td>0.9909</td></tr><tr><td>Zhang [44]</td><td></td><td>I</td><td>-</td><td>0.220</td><td>1.360</td><td>10.9 ~ 29.3</td><td>0.9600</td></tr><tr><td>Liu et al. [4]</td><td></td><td>I</td><td>-</td><td>-</td><td>2.600</td><td>25.8 ~ 66.9</td><td>-</td></tr><tr><td>Esmaeli et al. [6]</td><td></td><td>I</td><td>0.890</td><td>-</td><td>0.320</td><td>6.6 ~ 27.5</td><td>-</td></tr><tr><td>Dong et al. [3]</td><td></td><td>I</td><td>1.900</td><td>-</td><td>-</td><td>16.3 ~ 39.5</td><td>-</td></tr><tr><td>He et al. [25]</td><td></td><td>II</td><td>-</td><td>0.310</td><td>0.390</td><td>30.2 ~ 40.0</td><td>-</td></tr><tr><td>Saberian et al. [45]</td><td></td><td>II</td><td>-</td><td>-</td><td>1.880 ~ 3.030</td><td>53.2 ~ 63.1</td><td>0.7800 ~ 0.8900</td></tr><tr><td>Chen et al. [46]</td><td></td><td>II</td><td>1.4</td><td>-</td><td>0.900</td><td>19.0 ~ 27.2</td><td>-</td></tr><tr><td>Taki et al. [16]</td><td></td><td>III</td><td>-</td><td>-</td><td>0.230</td><td>36.2 ~ 65.6</td><td>0.9815</td></tr><tr><td>Zou et al. [18]</td><td></td><td>III</td><td>-</td><td>-</td><td>1.441</td><td>5.3 ~ 35.4</td><td>-</td></tr><tr><td>Jung et al. [19]</td><td></td><td>III</td><td>-</td><td>-</td><td>0.890</td><td>18.4 ~ 45.5</td><td>0.9400</td></tr></table>

ote: The corresponding data are not found in the original reference.

parameter coupling interaction relationship constructed by the dimensional analysis method can better describe the interaction relationship between various physical quantities.

In this study, the thermal environment fluctuation model of CSG was established by the dimensional analysis method. The input data of the model were the temperature of the energy storage wall (indoor air), the temperature of the air outside the greenhouse, and the thermal power of the solar radiation. The output data was the temperature of the indoor air (energy storage wall). The physical parameters can be mutually verified by theoretical derivation, which effectively compensates for the deficiencies of the above research methods for a greenhouse thermal environment and provides direct index requirements for scientific design of the thermal performance of greenhouse building components.

It should be noted that, due to the limited experimental conditions, this study did not make an in- depth exploration of greenhouse structure, type, and other physical quantities in the model, but the research ideas and methods have been discussed in detail. These deficiencies will be further supplemented and improved in future research.

# 6. Conclusions

The main purpose of this study is to establish a direct link between the thermal environment model of CSG and the thermal performance design of building components, and to provide direct index requirements for the thermal performance design of greenhouse. The main conclusions of this study are as follows:

1. The dimensional analysis method was used to comprehensively analyze the physical quantities related to greenhouse thermal environment. The temperature fluctuation interaction among indoor air, energy storage wall and outdoor air temperature in CSG was explored, and the thermal environment fluctuation model of CSG was established. The thermal performance design index of greenhouse construction can be deduced and determined according to the climatic characteristics of external environment and the thermal environment target of greenhouse, which provides an innovative technical method for the thermal performance design of greenhouse with crop demand as the core.

2. The wave equation of the multi-parameter coupling response between the thermal environment of CSG and the structural parameters of CSG and the external meteorological characteristics was derived. The thermal performance index parameter  $T_{sw}$  of the main energy storage components (walls) of the greenhouse can be accurately and quickly calculate in the greenhouse design stage, which provides direct index requirements for the scientific design of the thermal performance of greenhouse building components.

3. Based on the experimental greenhouse data, the thermal environment fluctuation model and equation of CSG were verified and analyzed. The results showed that under the typical sunny winter conditions, the MAE between the predicted and measured values of indoor air temperature was  $0.66^{\circ}\mathrm{C}$ , the RMSE was  $1.04^{\circ}\mathrm{C}$ , and the  $\mathbb{R}^2$  was  $0.9956$ $(\mathrm{n} = 2822)$ . The MAE between the predicted value and the measured value of the energy storage wall temperature was  $0.76^{\circ}\mathrm{C}$ , the RMSE was  $1.14^{\circ}\mathrm{C}$ , and the  $\mathbb{R}^2$  was  $0.9909$ $(\mathrm{n} = 2822)$ . The fluctuation model and equation accurately describe the interaction between the greenhouse thermal environment and the greenhouse internal components and the external environment, and have good simulation results.

The process and method of applying the thermal environment fluctuation model and equation of CSG to the simulation of greenhouse thermal environment and the calculation of thermal performance demand index proposed in this study can be easily applied to the simulation and design of other types and regional CSG.

In order to further optimize the scientific design of the thermal performance of the energy storage wall in the CSG, the future development direction of this study is to establish the thermal environment fluctuation model of CSG suitable for different climatic regions, and use the simulation results to guide the design and construction of the greenhouse to improve the actual thermal performance of the CSG in winter.

# CRediT authorship contribution statement

Yong Zhang: Supervision, Conceptualization, Methodology, Writing- review & correcting, Provide project support. Lianghe Xu: Methodology, Writing- original draft, Data analysis. Xiaohong Zhu: Data analysis, Data acquisition. Bin He: Data acquisition, Construction of the experiment platform. Yu Chen: Data curation, Investigation.

# Data availability

Data will be made available on request.

# Declaration of Competing Interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

# Acknowledgements

This work was supported by the National Key Research and Development Plan of Shaanxi Province (2018TSCXL, 2021QFY08- 01, 2016KTCL02- 02).

# Appendix A. Supplementary data

Supplementary data to this article can be found online at https://doi.org/10.1016/j.enbuild.2022.112648.

# References

[1] F. Qi, National Greenhouse Data System. http://data.sheshiyuanyi.com/AreaData/, in, 2019. [2] C. Wu, X. Zhao, W. Guo, Simulation and analysis of the temperature inside the sunlight greenhouse, Trans. Chin. Soc. Agric. Eng. 4 (2007) 190- 195. [3] S. Dong, M.S. Ahamed, C. Ma, H. Guo, A time- dependent model for predicting thermal environment of mono- slope solar greenhouses in cold regions, Energies 14 (18) (2021). [4] R. Liu, M. Li, J.L. Guzman, F. Rodriguez, A fact and practical one- dimensional transient model for greenhouse temperature and humidity, Comput. Electron. Agric. 186 (2021). [5] X. Zhang, J. Lv, M.M. Dawuda, J. Xie, J. Yu, Y. Gan, J. Zhang, Z. Tang, J. Li, Innovative passive heat- storage walls improve thermal performance and energy efficiency in Chinese solar greenhouses for non- arable lands, Sol. Energy 190 (2019) 561- 575. [6] H. Esmaeli, R. Roshandel, Optimal design for solar greenhouses based on climate conditions, Renewable Energy 145 (2020) 1255- 1265. [7] C. Baglivo, D. Mazzeo, S. Panico, S. Bonuso, N. Matera, P.M. Congedo, G. Oliveti, Complete greenhouse dynamic simulation tool to assess the crop thermal well- being and energy needs, Appl. Therm. Eng. 179 (2020). [8] R.W. Kim, J.G. Kim, I.B. Lee, U.H. Yeo, S.Y. Lee, C. Decano, Valentin, Development of three- dimensional visualisation technology of the aerodynamic environment in a greenhouse using CFD and VR technology, part 1: development of VR a database using CFD, Biosyst. Eng. 207 (2021) 33- 58. [9] D. Wei, Y. Zhang, S. Liu, Y. Lv, Simulation study of ventilation characteristics of solar greenhouse under natural ventilation, in, SPIE, 2022, pp. Academic Exchange Information Center (AEIC). [10] M. Dhiman, V.P. Sethi, B. Singh, A. Sharma, CFD analysis of greenhouse heating using flue gas and hot water heat sink pipe networks, Comput. Electron. Agric. 163 (2019). [11] D. Mazzeo, C. Baglivo, S. Panico, P.M. Congedo, Solar greenhouses: climates, glass selection, and plant well- being, Sol. Energy 230 (2021) 222- 241.

[12] S. Bonuso, S. Panico, C. Baglivo, D. Mazzeo, N. Matera, P.M. Congedo, G. Oliveti, Dynamic analysis of the natural and mechanical ventilation of a solar greenhouse by coupling controlled mechanical ventilation (CMV) with an earth- to- air heat exchanger (EAHX), Energies (2020).[13] M.S. Ahamed, H. Guo, K. Tanino, Modeling heating demands in a Chinese- style solar greenhouse using the transient building energy simulation model TRNSYS, J. Build. Eng. 29 (2020).[14] A. Rasheed, C.S. Kwak, W.H. Naj, J.W. Lee, H.T. Kim, H.W. Lee, Development of a building energy simulation model for control of multi- span greenhouse microclimate, Agronomy (2020).[15] A. Banakar, M. Montazeri, B. Gohabalian, H. Pasdarshahri, F. Kamrani, Energy analysis and assessing heating and cooling demands of closed greenhouse in Iran, Therm. Sci. Eng. Progress 25 (2021).[16] M. Taki, Y. Ajabshirchi, S.F. Rambar, A. Rohani, M. Matloobi, Heat transfer and MLP neural network models to predict inside environment variables and energy lost in a semi- solar greenhouse, Energy Build. 110 (2016) 314- 329. [17] H. Yu, Y. Chen, S.G. Hassan, D. Li, Prediction of the temperature in a Chinese solar greenhouse based on LSSVM optimized by improved PSO, Comput. Electron. Agric. 122 (2016) 94- 102. [18] W. Zou, F. Yao, B. Zhang, M. He, Z. Guan, Verification and predicting temperature and humidity in a solar greenhouse based on convex bidirectional extreme learning machine algorithm, Neurocomputing 249 (2017) 72- 85. [19] D.H. Jung, H.S. Kim, C. Jhin, H.J. Kim, S.H. Park, Time- serial analysis of deep neural network models for prediction of climatic conditions inside a greenhouse, Comput. Electron. Agric. 173 (2020).[20] T. Moon, J.W. Lee, J.E. Son, Accurate imputation of greenhouse environment data for data integrity utilizing two- dimensional convolutional neural networks, Sensors 21 (6) (2021) 2187. [21] C. Ma, J. Han, R. Li, Research and development of software for thermal environmental simulation and prediction in solar greenhouse, Northern Hortic. 222 (15) (2010) 69- 75. [22] L. Meng, Q. Yang, J. Wen, Y. Zhang, H. Fang, Hybrid programming with MATLAB and VB in building visual simulation model for thermal environment in Chinese solar greenhouse, Chin. Agric. Sci. Bull. 28 (06) (2012) 262- 268. [23] X. Zhang, H. Wang, Z. Zou, S. Yang, CFD and weighted entropy based simulation and optimisation of Chinese Solar Greenhouse temperature distribution, Biosyst. Eng. 142 (2016) 12- 26. [24] G. Zhang, Z. Fu, M. Yang, X. Liu, Y. Dong, X. Li, Nonlinear simulation for coupling modeling of air humidity and vent opening in Chinese solar greenhouse based on CFD, Comput. Electron. Agric. 162 (2019) 337- 347. [25] X. He, J. Wang, S. Guo, J. Zhang, B. Wei, J. Sun, S. Shu, Ventilation optimization of solar greenhouse with removable back walls based on CFD, Comput. Electron. Agric. 149 (2018) 16- 25. [26] C. Chen, N. Yu, F. Yang, K. Madakov, F. Han, Y. Li, H. Ling, Theoretical and experimental study on selection of physical dimensions of passive solar greenhouses for enhanced energy performance, Sol. Energy 191 (2019) 46- 56. [27] S. Mahdavi, F. Sarhaddi, M. Hedayatizadeh, Energy/exergy based- evaluation of heating/cooling potential of PV/T and earth- air heat exchanger integration into a solar greenhouse, Appl. Therm. Eng. 149 (2019) 996- 1007. [28] Q. Tan, Dimensional Analysis, China University of Science and Technology Press, AnHui, 2005. [29] H. Ling, C. Chen, Y. Guan, S. Wei, Z. Chen, N. Li, Active heat storage characteristics of active- passive triple wall with phase change material, Sol. Energy 110 (2014) 276- 285. [30] C. Chen, H. Ling, Z. Zhai, Y. Li, F. Yang, F. Han, S. Wei, Thermal performance of an active- passive ventilation wall with phase change material in solar greenhouses, Appl. Energy 216 (2018) 602- 612. [31] X. Zhang, J. Xie, J. Yu, J. Lu, Simulation analysis of thermal properties of air enclosure covered with aluminum foil in wall of solar greenhouse, Nongye Gongcheng Xuebao/Trans. Chin. Soc., Agric. Eng. 33 (2) (2017) 227- 233.

[32] J. Ren, Z. Zhao, J. Zhang, J. Wang, S. Guo, J. Sun, Study on the hygrothermal properties of a Chinese solar greenhouse with a straw block north wall, Energy Build. 193 (2019) 127- 138. [33] Y. Guan, T. Wang, M. Wei, T. Liu, W. Hu, S. Duan, Thermal performance experiment of heat storage wall with flat micro heat pipe array in solar greenhouse, Trans. Chin. Soc. Agric. Eng. 37 (3) (2021) 205- 212. [34] G. Zhang, Y. Shi, H. Liu, Z. Fei, X. Liu, M. Wei, F. Liu, S. Wang, Heat transfer performance of an assembled multilayer wall in a Chinese solar greenhouse considering humidity, J. Storage Mater. 3 (2021).[35] Y. Guan, J. Bai, X. Gao, W. Hu, C. Chen, W. Hu, Thickness Determination of a Three- layer Wall with Phase Change Material in a Chinese Solar Greenhouse, in, Elsevier Ltd, 2017, pp. 130- 136. [36] M. Li, P. Wang, W. Song, Feasibility of employing a heat insulation wall as the north wall of a Chinese solar greenhouse in a severely cold area of China, Appl. Eng. Agric. 35 (6) (2019) 903- 910. [37] M. Li, X. Wei, C. Zhou, H. Zheng, X. Li, Improving effect of heat insulation performance of brick wall thickened with foam cement in solar greenhouse, Trans. Chin. Soc. Agric. Eng. 30 (24) (2014) 187- 192. [38] M.A. Abdulhussein, A.L. Hashem, Experimental study of the thermal behavior of perforated bricks wall integrated with PCM, Int. J. Heat Technol. 39 (6) (2021) 1917- 1922. [39] F. Berroug, E.K. Lakhal, M. El Omari, M. Faraji, H. El Qarnia, Thermal performance of a greenhouse with a phase change material north wall, Energy Build. 43 (11) (2011) 3027- 3035. [40] Y. Zhang, Y. Xu, Y. Chen, K. Zhang, X. Ni, Heat storage and release performance of new phase change material and its application in greenhouse, Trans. Chin. Soc. Agric. Eng. 37 (7) (2021) 218- 226. [41] F. Han, C. Chen, Q. Hu, Y. He, S. Wei, C. Li, Modeling method of an activepassive ventilation wall with latent heat storage for evaluating its thermal properties in the solar greenhouse, Energy Build. 238 (2021).[42] J. Zhang, C. Li, Monitoring thermal properties of brick wall solar greenhouse, J. Agric. 9 (5) (2019) 62- 68. [43] J. Li, Q. Bai, Y. Zhang, Analysis on measurement of heat absorption and release of wall and ground in solar greenhouse, Trans. Chin. Soc. Agric. Eng. 26 (4) (2010) 231- 236. [44] X. Zhang, Study on the Light and Thermal Environment Building of Chinese Solar Greenhouses in the Hexi Corridor and Model Development, Gansu Agricultural University, 2020. [45] A. Saberian, S.M. Sajadiye, The effect of dynamic solar heat load on the greenhouse microclimate using CFD simulation, Renewable Energy 138 (2019) 722- 737. [46] J. Chen, P. Xu, D. Tan, Z. Shen, L. Zhang, Q. Ai, A control method for agricultural greenhouses heating based on computational fluid dynamics and energy prediction model, Appl. Energy 141 (2015) 106- 118. [47] V.P. Sethi, K. Sumathy, C. Lee, D.S. Pal, Thermal modeling aspects of solar greenhouse microclimate control: a review on heating technologies, Sol. Energy 96 (2013) 56- 82. [48] N. Choab, A. Allouhi, A. El Maakoul, T. Kousksou, S. Saadeddine, A. Jamil, Review on greenhouse microclimate and application: design parameters, thermal modeling and simulation, climate controlling technologies, Sol. Energy 191 (2019) 109- 137. [49] L. Meng, Q. Yang, G.P.A. Bot, N. Wang, Visual simulation model for thermal environment in Chinese solar greenhouse, Trans. Chin. Soc. Agric. Eng. 25 (1) (2009) 164- 170. [50] X. Wang, Study on the Indoor Thermal Environmental Simulation and Optimal Design of Livestock Uilding Based on CFD, Zhejiang University, 2014. [51] X. Li, X. Zhang, Y. Wang, K. Zhang, Y. Chen, Temperature Prediction Model for Solar Greenhouse Based on Improved BP Neural Network, IOP Publishing Ltd, 2020. [52] L. Ma, Y. Wu, J. Ji, C. He, The prediction model for soil water evaporation based on BP neural network, IEEE Comput. Soc. (2011) 276- 280.