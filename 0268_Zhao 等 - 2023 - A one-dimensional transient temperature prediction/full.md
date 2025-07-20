Original papers

# A one-dimensional transient temperature prediction model for Chinese assembled solar greenhouses

Lei Zhao a, Liangchen Lu a,b,c,d, Hanlin Liu b,c,d, Yiming Li b,c,d,e, Zhouping Sun f, Xingan Liu b,c,d,f,\*, Tianlai Li b,c,d,f,\*

a College of Petroleum Engineering, Liaoning Petrochemical University, Fushun 113001, China  b Key Laboratory of Protected Horticulture, Shenyang Agricultural University, Ministry of Education, China  c National & Local Joint Engineering Research Center of Northern Horticultural Facilities Design & Application Technology (Liaoning), No. 120 Dongling Road, Shenhe District, Shenyang 110866, China  d College of Horticulture, Shenyang Agricultural University, No. 120 Dongling Road, Shenhe District, Shenyang 110866, China  e College of Engineering, Shenyang Agricultural University, No. 120 Dongling Road, Shenhe District, Shenyang 110866, China  f Shenyang Agricultural University Modern Facility Horticulture Engineering Technology Center, No. 120 Dongling Road, Shenhe District, Shenyang 110866, China

# ARTICLEINFO

Keywords:  Chinese assembled solar greenhouse  Transient model  Greenhouse climate  Water heat storage system

# ABSTRACT

The prediction of the thermal environment of greenhouses has always been an essential component of greenhouse development. In this paper, a one- dimensional transient temperature prediction model is constructed based on the principle of energy balance for Chinese assembled solar greenhouses (CASG). The daily temperature trends for each surface in the greenhouse were obtained by solving the model using MATLAB. The performance of the model was assessed by comparing the measured and predicted values. The mean absolute errors for the temperature of air, back roof, front roof, heat collector plate, north wall, ground and water storage tank were computed to be  $1.4^{\circ}\mathrm{C}$ ,  $1.89^{\circ}\mathrm{C}$ ,  $1.98^{\circ}\mathrm{C}$ ,  $2.07^{\circ}\mathrm{C}$ ,  $2.26^{\circ}\mathrm{C}$ ,  $1.44^{\circ}\mathrm{C}$ , and  $0.68^{\circ}\mathrm{C}$ , respectively. The results demonstrate a high level of concurrence between the simulated and measured values, indicating that the model is proficient in predicting the thermal environment of CASG. Based on this, predictions were made regarding the internal environment of CASG on both sunny and cloudy days, which contributes to a comprehensive understanding of the thermal environment. The research provides theoretical support for regulating environmental conditions of CASG.

# 1. Introduction

As a typical horticultural facility, the greenhouse has been widely used all over the world(Chen et al., 2016). The total area of solar greenhouses in China is reported to have reached 1.96 million hectares by 2021(Liu et al., 2021a). The greenhouse has become an indispensable component of agricultural production. With the growth of population and the advancement of society, the demand for agricultural products has shifted from pursuing high yields to seeking both yield and quality. The greenhouse heat storage and environmental control ability faced a significant challenge. The conventional solar greenhouse fails to meet the demands of both production and daily life. In recent years, the Chinese assembled solar greenhouse (CASG) (Fig. 1 (a)) has emerged as a new development trend due to its low construction cost, simple structure, and easy disassembly. This type of greenhouse features temperature- controlled windows on the roof for ventilation and heat dissipation. The windows were opened when the room temperature exceeds  $25^{\circ}C$  The north wall of a traditional solar greenhouse absorbs and releases heat to maintain the temperature. Walls play the role of heat storage and support. The primary role of CASG's walls is to maintain stability. The north wall of the greenhouse is mostly covered by heat collector plates and water storage tanks. Heat storage in the CASG is primarily accomplished by a combination of the heat collector plates on the north wall and water storage tanks. The heat collector plate absorbs solar radiation during the day, causing its temperature to rise rapidly. Cold water is circulated through the plate by a water pump, allowing for heat exchange. The microclimate within the greenhouse is achieved through a diverse array of control equipment. However, the application of a variety of equipment causes a complex microclimate environment inside the greenhouse. As is known to all, a greenhouse is a controlled environment that modifies the internal climate to create an optimal

<table><tr><td colspan="3">Nomenclature</td><td></td></tr><tr><td>A</td><td>area (m²)</td><td>ρ</td><td>density (kg·m−3)</td></tr><tr><td>A</td><td>area (m²)</td><td>ζ</td><td>the transmittance of the film of the front roof.</td></tr><tr><td>c</td><td>specific heat (J·kg−1·K−1)</td><td>δ</td><td>weather impact factor</td></tr><tr><td>f</td><td>thickness of the back roof sub-layer (m)</td><td>θsun</td><td>solar altitude angle (degree)</td></tr><tr><td>n</td><td>thickness of the ground sub-layer (m)</td><td>θi</td><td>solar incident angle (degree)</td></tr><tr><td>l</td><td>thickness of the heat collector plate sub-layer (m)</td><td>γ</td><td>angle between the desired surface and the horizontal surface (degree)</td></tr><tr><td>d</td><td>thickness of the north wall sub-layer (m)</td><td>β</td><td>surface azimuth angle (degree)</td></tr><tr><td>QHR</td><td>unit area radiation energy exchange from surface A to B (W·m−2)</td><td>γ</td><td>local latitude (degree)</td></tr><tr><td>QAB</td><td>unit area convective heat flux between surface A to B (W·m−2)</td><td>σ</td><td>thermal emission coefficient</td></tr><tr><td>QdB</td><td>unit area conduction heat transfer from surface A to B (W·m−2)</td><td>ε</td><td>Stefan-Boltzmann constant (5.68·10−8W·m−2·k−4)</td></tr><tr><td>QCD</td><td>unit area conduction heat transfer from surface A to B (W·m−2)</td><td>γ</td><td>absorb coefficient</td></tr><tr><td>hdl</td><td>heat transfer coefficient between A and B (W·m−2·K−1)</td><td>α</td><td>thermal efficiency of heat collector plate</td></tr><tr><td>GSun</td><td>extraterrestrial solar radiation (W·m−2)</td><td>δ</td><td>distance between heat-absorbing surface and cover glass</td></tr><tr><td>GTtotal</td><td>The horizontal solar radiation outside the greenhouse (W·m−2)</td><td>Subcripts</td><td></td></tr><tr><td>day1</td><td>the cumulative number of days since January 1 each year</td><td>z</td><td>beam radiation</td></tr><tr><td>th</td><td>standard time (h)</td><td>s</td><td>diffuse radiation</td></tr><tr><td>GA</td><td>incoming solar radiation of unit area (W·m−2)</td><td>airi</td><td>inside air</td></tr><tr><td>V</td><td>volume (m³)</td><td>airi</td><td>outside air</td></tr><tr><td>T</td><td>surface temperature(℃)</td><td>rf1</td><td>back roof sub-layer 1 at depth 2.5 cm</td></tr><tr><td>Re</td><td>Reynolds number</td><td>sky</td><td>back roof sub-layer 2 at depth 12 cm</td></tr><tr><td>Pr</td><td>Prandtl number</td><td>gd</td><td>ground</td></tr><tr><td>Nu</td><td>Nussle number</td><td>si</td><td>ground sub-layer 2 at depth 6 cm</td></tr><tr><td>Gr</td><td>Grashof number</td><td>si1</td><td>soil sub-layer 1 at depth 10 cm</td></tr><tr><td>L</td><td>Length (m)</td><td>si2</td><td>soil sub-layer 1 at depth 20 cm</td></tr><tr><td>Nair</td><td>the exchange rate of air inside and outside the greenhouse radius of the tube (m)</td><td>si3</td><td>soil sub-layer 1 at depth 50 cm</td></tr><tr><td>R</td><td>angular coefficient</td><td>ft</td><td>front roof</td></tr><tr><td>X</td><td>outdoor wind speed (m·s−1)</td><td>wl</td><td>north roof</td></tr><tr><td>Vairo</td><td>outdoor wind speed (m·s−1)</td><td>wl1</td><td>north wall sub-layer 1 at depth 6 cm</td></tr><tr><td>Vwt</td><td>flow rate of water inside the heat collector plate (m·s−1)</td><td>wl2</td><td>north wall sub-layer 1 at depth 20 cm</td></tr><tr><td>LH</td><td>local elevation (km)</td><td>wl3</td><td>north wall sub-layer 1 at depth 36 cm</td></tr><tr><td>H</td><td>height of the greenhouse wall (m)</td><td>gs</td><td>surface glass for heat collector plate</td></tr><tr><td>t</td><td>time (s)</td><td>sl</td><td>heat-absorbing surfaces for heat collector plates</td></tr><tr><td>Greek symbols</td><td></td><td>airsl</td><td>air temperature inside the heat collector plate</td></tr><tr><td>τ</td><td>radiation transmission rates</td><td>mix</td><td>average water temperature in heat exchanger tube</td></tr><tr><td>ω</td><td>hour angle</td><td>gsab</td><td>heat absorbed by the glass on the surface of the heat collector plate</td></tr><tr><td>ψ</td><td>local longitude (degree)</td><td>vt</td><td>cold air infiltration</td></tr><tr><td>δ</td><td>solar declination (degree)</td><td>wt</td><td>water</td></tr></table>

growing condition for plants. The greenhouse microclimate is composed of various environmental factors, including temperature, humidity, solar radiation, carbon dioxide and others.(Singh et al., 2006). It is the greenhouse microclimate that directly affects plant metabolic activities and therefore the crop yield(Singh et al., 2018). The effects of temperature and humidity on plant growth are particularly obvious (Choab et al., 2019). So it's important to build an accurate understanding of the thermal environment inside the greenhouse(Singh et al., 2017). However, the traditional measurement method can accurately obtain indoor parameters, it requires a significant investment of time and manpower. Conversely, mathematical models offer an effective solution to this issue.

Many models have been developed to predict the thermal environment of the greenhouse. Singh et al.(Singh et al., 2006) established equations for the greenhouse cover, indoor air, canopy surface, and bare soil surface, which ignored the condensation and evaporation on the ground. Vanthoor et al. (Vanthoor et al., 2011a; Vanthoor et al., 2011b) developed greenhouse models for a wide range of climatic and economic conditions. The model can predict indoor air temperature, water vapor pressure, and carbon dioxide concentration under different climate conditions. Berroug et al.(Berroug et al., 2011) developed a thermal model of a greenhouse with PCM walls, based on the greenhouse heat and mass balance. The effects of PCM on temperature and humidity inside the greenhouse have been investigated. Joudi and Farhan (Joudi and Farhan, 2015) developed a transient thermal model to predict indoor air temperatures and soil temperatures at different depths. The model incorporated the heat exchange mechanism between the soil surface and greenhouse air, and its accuracy was experimentally verified. Taki et al. (Taki et al., 2016) developed a dynamic mathematical model based on heat and mass transfer and crop transpiration. A modeling approach was developed to predict energy in the greenhouse with considering heat transfer processes and crop transpiration. Reyes- Rosas et al. (Reyes- Rosas et al., 2017) developed a semi- empirical dynamic model of energy balance for predicting air, plant, greenhouse mulch, and soil temperatures in a naturally ventilated greenhouse covered with polypropylene mulch in a Mediterranean climate. The

results showed that the model had good accuracy for estimating air, crop, plastic mulch, polypropylene mulch, and soil temperatures in greenhouses. As such, it can serve as a valuable tool for optimizing ventilation system characteristics and control settings. Mobtaker et al. (Mobtaker et al., 2019) developed a dynamic prediction model for air, soil surface. The study analyzed the temperatures on the north walls of six different greenhouse types and compared them. Zhang et al. (Zhang et al., 2020a) formulated differential equations for energy conservation in nine indoor air, seven soil layers, and greenhouse mulch layers by incorporating dynamic mulch absorption and transmittance. The MATLAB software solved the unsteady equation and obtained the trend of greenhouse temperature variation under different conditions. Liu et al. (Liu et al., 2021b) developed an environmental model for the greenhouse using an energy balance approach to estimate wall temperature. The results demonstrated its robustness across various operational scenarios, as well as its ability to forecast climatic conditions based on weather data. Ma et al. (Ma et al., 2022) develop a dynamic model of a Chinese solar greenhouse by using EnergyPlus. The model was used to evaluate the thermal performance of greenhouses under different weather conditions. The results show that the model predicted the performance of the greenhouse consistent with measured data. They fully assessed the thermal characteristics of solar greenhouse. The existing models for predicting greenhouse thermal environments cannot be applied to CASG due to its unique structure and the use of a water heat storage system on the north wall.

In this study, a temperature prediction model for CASG was constructed based on the energy balance principle. The model takes account of the interaction effects between the water heat storage equipment and other components of the greenhouse (Fig. 1 (b)). The model can also be used to predict the temperature in the greenhouse under different weather conditions. This study provides a theoretical basis for the regulation of the thermal environment within greenhouses.

# 2. Material and methods

# 2.1. Experimental environmental conditions

The experiment was conducted in an CASG at Shenyang Agricultural University (41.8oN, 123.4oE) in China as shown in Fig. 1 (a). The length, span and ridge height of the CASG are 25, 8.6 and  $5.4m$  respectively. The main building, with an area of 215 square meters, is constructed using expanded polystyrene modular (EPS) walls instead of traditional earth walls or bricks commonly found in greenhouses. It is characterized by its ease of installation and disassembly (Li et al., 2017). The soilless shelves are placed inside the greenhouse, with a water heat storage integrated onto the north wall and a transparent polyethylene membrane on the front roof. The back roof was made of  $0.1\text{m}$  planks and 0.05 mstyrene butadiene styrene block copolymer sheets (Chen et al., 2018). The basic physical properties of the materials in the greenhouse are shown in Table 1(Ma et al., 2022; Xia et al., 2022; Zhang et al., 2020b).

# 2.2. Experimental installation

The temperature and humidity sensors produced by Jiangsu Jing Chuang Company were used to measure the experimental data in Fig. 1 (a). The RC- 4HC is used to measure humidity. The device can handle up to 16,000 data sets simultaneously and is designed to operate within a temperature range of  $- 30^{\circ}\mathrm{C} + 60^{\circ}\mathrm{C}$ . Temperature measurement accuracy of  $\pm 0.5^{\circ}\mathrm{C}$ . The accuracy of humidity measurement is within  $\pm 3\%$  RH. The RC- 4 is used to measure temperature. The device can handle up to 16,000 data sets simultaneously and is designed to operate within a temperature range of  $- 30^{\circ}\mathrm{C} \sim +60^{\circ}\mathrm{C}$ , the temperature accuracy is  $\pm 0.5^{\circ}\mathrm{C}$  in the temperature range of  $- 20^{\circ}\mathrm{C} \sim +40^{\circ}\mathrm{C}$ . The accuracy is  $\pm 1^{\circ}\mathrm{C}$  for the rest of the range. The sensor is programmed to capture data at 10- minute intervals. The HD2102.2 high precision illuminance meter, produced by Delta OHM of Italy, is utilized to measure solar radiation on each surface with an error rate of less than  $5\%$ . To ensure the accuracy of the results, all the equipment was reset and adjusted. The layout of all sensors is shown in Fig. 2.

Table 1 Physical properties of surfaces used in the simulation.  

<table><tr><td>Material</td><td>Heat conductivity (w·m−1·K−1)</td><td>Density (kg·m−3)</td><td>Specific Heat (J·kg−1·K−1)</td></tr><tr><td>Polystyrene board</td><td>0.03</td><td>8.0</td><td>1340</td></tr><tr><td>Brick</td><td>0.5</td><td>2360</td><td>1510</td></tr><tr><td>Polyurethane</td><td>0.026</td><td>35</td><td>1380</td></tr><tr><td>Plastic film</td><td>0.19</td><td>970</td><td>960</td></tr><tr><td>wood</td><td>0.29</td><td>550</td><td>1380</td></tr><tr><td>EPS</td><td>0.041</td><td>1100</td><td>1500</td></tr><tr><td>Waterproof material</td><td>0.15</td><td>1.0</td><td>920</td></tr><tr><td>Soil</td><td>0.6</td><td>1500</td><td>1900</td></tr><tr><td>Air</td><td>0.02</td><td>1.29</td><td>1000</td></tr><tr><td>Heat collector plate</td><td>1.03</td><td>2500</td><td>966</td></tr></table>

![](images/1b0247597222f4035e77475bd7897f42bc1ff4cf53dcb17f28ba4ab61a398d48.jpg)  
Fig. 1. Appearance of the CASG used in the experiment (a), schematic diagram of greenhouse energy flow (b).

![](images/f18a0b4a208fd5136583e1a1894750d1cf2cf8929d43c7097cb93fd9dfd89d0c.jpg)

![](images/b04838e565b9f19068bc88692c573b53b38f69e7b84b6c015eb1a514b9be81ca.jpg)  
Fig. 2. Greenhouse section measuring point layout.

# 3. Solar radiation model

The earth's surface receives solar radiation that passes through the atmosphere. The radiation that passes through the front roof of the greenhouse upon reaching the ground is referred to as total greenhouse radiation. The intercepted solar radiation varies due to the different angles of each surface. To better understand solar radiation in the greenhouse, this paper uses Kreith and Kreider's (1981) theoretical model to calculate and compare the solar radiation of different surfaces with measured data.

Solar radiation outside the atmosphere:

$$
G_{sun} = 1367\left[1 + 0.033\mathrm{cos}\left(\frac{360\pi}{180}\cdot \frac{day_1}{365}\right)\right] \tag{1}
$$

where  $day_1$  is the cumulative number of days since January 1 each year.

The horizontal solar radiation outside the greenhouse can be expressed as:

$$
G_{total} = G_{sun}.\cos \theta_{sun}.\left(\tau_z + \tau_s\right) \tag{2}
$$

where:

$$
\begin{array}{rl} & {\cos \theta_{sun} = \sin \Gamma \sin \delta +\cos \Gamma .\cos \delta .\cos \omega}\\ & {\tau_z = a_0 + a_1e^{\frac{a_k}{\cos\theta_{sun}}}}\\ & {\tau_s = 0.271 - 0.293\tau_s}\\ & {\omega = (t_h - 12)\cdot 15 + (\psi -120)}\\ & {\delta = 23.45^\circ \sin \left[\frac{360\pi}{180}\cdot \frac{284 + day_1}{365}\right]} \end{array} \tag{3}
$$

where  $a_0$ ,  $a_1$  and  $\kappa$  are the physical constants of the standard clear sky atmosphere. When the altitude is below  $2.5 \text{km}$ , the calculation can be derived using the subsequent formula:

$$
\begin{array}{c}{a_0 = 0.4237 - 0.00821(6 - LH)^2}\\ {}\\ {a_1 = 0.5055 - 0.00595(6.5 - LH)^2}\\ {}\\ {\kappa = 0.2711 - 0.01858(2.5 - LH)^2} \end{array} \tag{10}
$$

The average altitude of the Shenyang area is  $0.11 \text{km}$ , which can be obtained:

$$
a_0 = 0.1388779,a_1 = 0.262549,K = 0.1649629
$$

Therefore, the solar radiation on each surface can be expressed as:

$$
G_{A} = G_{total}.\cos \theta_{i}.\zeta_{i}.\mathfrak{J} \tag{1}
$$

where  $\zeta$  is the transmittance of the film of the front roof. Due to the influence of dust and other factors on the experimental greenhouse film, the transmittance was measured at 0.73 by comparing data from inside and outside the greenhouse.  $\mathfrak{J}$  is the weather impact factor.  $\Im = 1$  for clear skies without clouds.

$$
\begin{array}{rl} & {\cos \theta_{i} = \sin \delta \sin \Upsilon \cos \gamma -\sin \delta \cos \Upsilon \sin \gamma \cos \beta +\cos \delta \cos \Upsilon \cos \gamma \cos \omega}\\ & {\qquad +\cos \delta \sin \Upsilon \sin \gamma \cos \beta \cos \omega +\cos \delta \sin \gamma \sin \beta \sin \omega} \end{array} \tag{12}
$$

where  $\gamma$  is the angle between the desired surface and the horizontal surface,  $0^{\circ} \leq \gamma \leq 180^{\circ}$ ,  $\gamma \geq 90^{\circ}$  means that the desired surface and the horizontal surface have a downward component.

# 4. Energy balance model

The thermal efficiency of a greenhouse is a crucial criterion for evaluating its performance. The harsh winter climate in northern China poses extremely high demands on the thermal environment of greenhouses, particularly. To better study the thermal performance of the CASG, we construct a set of temperature prediction models suitable for the CASG. The greenhouse vents remained closed throughout the experiment to minimize the impact of outdoor environmental factors on

the thermal environment. At the same time, the model disregarded the plants inside the greenhouse to reduce its thermal impact. The exclusion of plants is primarily due to the focus on thermal characterization of the greenhouse envelope. Secondly, the plant species in the greenhouse are not unique. Finally, plant transpiration and respiration in the greenhouse affect the air temperature inside the greenhouse. As a result, the impact of plants in the greenhouse is ignored. The following assumptions were made when constructing the greenhouse model.

(1) The air within the greenhouse is homogeneously mixed, resulting in uniform temperature distribution throughout. Ignoring the heat absorbed by the skeleton inside the greenhouse. 
(2) Neglecting the heat absorption of greenhouse soilless tube frames. 
(3) The effect of latent heat and humidity of water vapor in the greenhouse is ignored. 
(4) Assuming the absence of vegetation within the greenhouse. 
(5) All the heat from the heat-absorbing surface of the heat collector plate is absorbed by the heat exchanger tubes.

# 4.1. Thermal radiation exchange of each surface

As shown in Fig. 3, the four surfaces of the greenhouse constitute a closed system. The solar radiation that scatters inside the greenhouse is reflected in a diffuse manner, which allows for the use of the length coefficient method to determine angle coefficients. Additionally, instead of surface area, the length of each surface can be utilized. Then the thermal radiation formula between the two surfaces can be expressed as (Straten et al., 2010):

$$
Q_{A,B}^{HR} = \phi_{A}\cdot \phi_{B}.X_{A,B}.\sigma .(T_{A}^{4} - T_{B}^{4}) \tag{13}
$$

where  $\phi_{A}$  and  $\phi_{B}$  are the thermal emission coefficients of surface A and B.  $\sigma$  is the Stefan- Boltzmann constant, the value of it is  $5.68\cdot 10^{- 8}(W\cdot m^{- 2}\cdot k^{- 4})$ .  $X_{A,B}$  is the view factor(Tong et al., 2009) from surface  $A$  to surface  $B$  bate view factor from the front roof to the north wall can be expressed as  $X_{fl,wl}$ , the mathematical representation is shown in Fig. 3.

![](images/f4a3a6b35d63b3bda89383d5797437db957b441f5107fe4b73e40e72a71f1a58.jpg)  
Fig. 3. Shows a schematic diagram of greenhouse surface view factors, where  $ab$  represents the ground surface of the greenhouse,  $cb$  represents the inner surface of the north wall of the greenhouse,  $dc$  represents the inner surface of the back roof of the greenhouse, and  $da$  represents the inner surface of the front roof of the greenhouse.

$$
X_{fl,wl} = \frac{ac + db - dc - ab}{2da} \tag{14}
$$

$$
X_{fl,rf} = \frac{da + dc - ac}{2da} \tag{15}
$$

$$
X_{gd,wl} = \frac{ab + bc - ac}{2ab} \tag{16}
$$

$$
X_{fd,d} = \frac{da + ab - db}{2da} \tag{17}
$$

$$
X_{rf,wl} = \frac{dc + cb - db}{2dc} \tag{18}
$$

$$
X_{rf,gd} = \frac{db + ac - ad - cb}{2dc} \tag{19}
$$

where  $db = 5.8\mathrm{m}$ $ac = 8.8\mathrm{m}$ $da = 10\mathrm{m}$ $dc = 2.616\mathrm{m}$ $ab = 8.6\mathrm{m}$ $cb = 3.5$  m;

# 4.2. Energy balance of the back roof

Heat transfer from the back roof of the greenhouse occurs through convective and radiant heat exchange with the inside air and surfaces, as well as conductive heat transfer to the outside surface.

$$
G_{rf} - \rho_{rf}c_{rf}f_{0}\cdot \frac{dT_{rf}}{dt} = Q_{rf,airi}^{dl} + Q_{rf,rf1}^{cd} + Q_{rf,gd}^{HR} + Q_{rf,gd}^{HR} + Q_{rf,ft}^{HR} + Q_{rf,st}^{HR} + Q_{rf,wl}^{HR}
$$

where  $Q_{rf,airi}^{dl}$  is the convective heat transfer between the air inside the greenhouse and the back roof, which can be expressed by (Mobtaker et al., 2019):

$$
Q_{rf,airi}^{dl} = h_{rf,airi}^{dl}(T_{rf} - T_{airi}) \tag{21}
$$

The heat conduction from surface  $A$  to surface  $A_{1}$  of any thickness  $t$  can be expressed as(Joudi and Farhan, 2015):

$$
q_{A,A_1}^{cd} = \frac{k_A(T_A - T_{A_1})}{t} \tag{22}
$$

The greenhouse back roof is divided into three layers from the inside to the outside, and the energy balance equation from the back roof to the outside air can be written:

$$
\rho_{rf}c_{rf}f_{1}\cdot \frac{dT_{rf1}}{dt} = \frac{k_{rf}(T_{rf} - T_{rf1})}{f_{1}} -\frac{k_{rf1}(T_{rf1} - T_{rf2})}{f_{2}} \tag{23}
$$

$$
\rho_{rf}c_{rf2}f_{2}\cdot \frac{dT_{rf2}}{dt} = \frac{k_{rf1}(T_{rf1} - T_{rf2})}{f_{2}} -Q_{rf2,airo}^{dl} - Q_{rf2,airo}^{dl}, \tag{24}
$$

where  $Q_{rf2,airo}^{dl}$  is the convective heat transfer between the surface of the back roof of the greenhouse and the outside air, which can be expressed as (Mobtaker et al., 2019):

$$
Q_{rf2,airo}^{dl} = h_{rf2,airo}^{dl}(T_{rf2} - T_{airo}) \tag{25}
$$

$$
h_{rf2,airo}^{dl} = 1.42\left(\frac{T_{rf2} - T_{airo}}{t}\right)^{0.25} \tag{26}
$$

In equation (24),  $Q_{rf2,sky}^{HR}$  is the greenhouse back roof surface solar radiation heat exchange, which can be expressed as:

$$
Q_{rf2,sky}^{HR} = \sigma \phi_{rf2}T_{rf2}^{4} - \epsilon_{sky}\sigma \phi_{sky}T_{sky}^{4} \tag{27}
$$

$T_{sky}$  is the outdoor sky temperature, which can be expressed as (Swinbank, 1963):

$$
T_{sky} = 0.0552(T_{airo})^{1.5} \tag{28}
$$

# 4.3. Energy balance of ground

As CASG uses soilless cultivation, the greenhouse ground differs from that of a regular soil greenhouse. The ground of the experimental greenhouse is covered with a  $6cm$  thick layer of cement fired bricks. When calculating the energy balance of the ground, we considered the cement fired bricks and the soil separately.

$$
\rho_{gd} - \rho_{gd}c_{gd}n_0\cdot \frac{dT_{gd}}{dt} = Q_{gd,airi}^{dl} + Q_{gd,si}^{dl} - Q_{gd,wl}^{HR} + Q_{gd,rf}^{HR} + Q_{gd,ft}^{HR} + Q_{gd,gs}^{HR} + Q_{gd,st}^{HR}
$$

where  $Q_{gd,airi}^{dl}$  is the convective heat transfer between ground and inside air, which can be expressed as:

$$
Q_{gd,airi}^{dl} = h_{gd,airi}(T_{gd} - T_{airi}) \tag{30}
$$

The energy transferred from the greenhouse ground to the soil can be expressed as:

$$
\begin{array}{r}\rho_{si}c_{si}n_1\cdot \frac{dT_{si1}}{dt} = \frac{k_{si}(T_{si} - T_{si1})}{n_1} -\frac{k_{si1}(T_{si1} - T_{si2})}{n_2}\quad 1\leqslant n\leqslant 10cm\\ \rho_{si}c_{si2}n_2\cdot \frac{dT_{si2}}{dt} = \frac{k_{si1}(T_{si1} - T_{si2})}{n_2} -\frac{k_{si2}(T_{si2} - T_{si3})}{n_3}\quad 10\leqslant n\leqslant 20cm \end{array} \tag{32}
$$

# 4.4. Energy balance of the front roof

The front roof of the greenhouse is covered by a Po film. As the Po film is very thin, the temperature of the inner surface of the Po film is considered as the temperature of the whole film when calculating the energy balance. The energy balance of the front roof can be expressed as:

$$
\begin{array}{r}G_{fl} - \rho_{fl}c_{fl}d_{fl}\cdot \frac{dT_{fl}}{dt} = Q_{fl,airi}^{dl} + Q_{fl,airi}^{dl} + Q_{fl,gd}^{HR} + Q_{fl,rf}^{HR} + Q_{fl,gs}^{HR}\\ +Q_{fl,st}^{HR} + Q_{fl,wh}^{HR} + Q_{fl,sky}^{HR} \end{array} \tag{33}
$$

where  $Q_{fl,airi}^{dl}$  is the heat transfer between the inner surface of the greenhouse and the inner air, which can be expressed as (Mobtaker et al., 2019):

$$
Q_{fl,airi}^{dl} = h_{fl,airi}^{dl}(T_{fl} - T_{airi}) \tag{34}
$$

$$
h_{fl,airi}^{dl} = 1.95\big|T_{airi} - T_{fl}\big|^{0.3} \tag{35}
$$

In equation (33),  $Q_{fl,airi}^{dl}$  is the heat transfer between the external surface of the front roof and the outside air, which can be expressed as (Abdel- Ghany and Kozai, 2006):

$$
Q_{fl,airi}^{dl} = h_{fl,airi}^{dl}(T_{fl} - T_{airi}) \tag{36}
$$

$$
h_{fl,airi}^{dl} = 0.95 + 6.76\nu_{airi}^{0.49}\nu_{airi}< 6.3m / s \tag{37}
$$

The radiation heat lost from the front roof of the greenhouse to the outside can be expressed as:

$$
Q_{fl,sky}^{HR} = \sigma \phi_{fl}T_{fl}^4 -\epsilon_{sky}\sigma \phi_{sky}T_{sky}^4 \tag{38}
$$

# 4.5. Energy balance of the north wall

A set of water heat storage systems is integrated on the north wall of CASG. The heat collector plate and water tank of the water heat storage system shields the surface of the north wall of the greenhouse. Therefore, when calculating the energy balance of the north wall of the greenhouse, the effects of the water heat storage and the north wall on the thermal environment of the greenhouse need to be calculated separately. The energy balance of the north wall can be expressed as:

$$
G_{wl} - \rho_{wl}c_{wl}d_{0}\cdot \frac{dT_{wl}}{dt} = Q_{wl,airi}^{dl} + Q_{wl,wl1}^{cd} + Q_{wl,rf}^{HR} + Q_{wl,rf}^{HR} + Q_{wl,gd}^{HR} + Q_{wl,gs}^{HR} + Q_{wl,st}^{HR} \tag{39}
$$

The energy balance equations which derived from the wall can be written as:

$$
\rho_{wl}c_{wl}d_1\cdot \frac{dT_{wl}}{dt} = \frac{k_{wl}(T_{wl} - T_{wl1})}{d_1} -\frac{k_{wl}(T_{wl1} - T_{wl2})}{d_2} -\frac{k_{wl}(T_{wl2} - T_{wl3})}{d_3} \tag{40}
$$

$$
\rho_{wl}c_{wl}d_2\cdot \frac{dT_{wl2}}{dt} = \frac{k_{wl1}(T_{wl1} - T_{wl2})}{d_2} -\frac{k_{wl2}(T_{wl2} - T_{wl3})}{d_3} \tag{41}
$$

$$
\rho_{wl}c_{wl}d_3\cdot \frac{dT_{wl3}}{dt} = \frac{k_{wl2}(T_{wl2} - T_{wl3})}{d_3} -Q_{wl3,airi}^{dl} - Q_{wl3,sky}^{HR} \tag{42}
$$

# 4.6. Energy balance of water heat storage system

Water heat storage is composed of a heat collector plate and a water storage tank. During the day, sunlight shines on the collector concentrating heat on their absorbing surface. Cold water is circulated through the heat exchanger tubes of the collector plates by means of a pump. Cold water flows through the heat exchanger tubes to remove the heat from the heat- absorbing surfaces. Eventually, the hot water flows back to the storage tank for heat exchange. In this paper, to make a better study of the system, we divided the water heat storage system into two parts to study the heat balance respectively.

# 4.6.1. Energy balance of heat collector plates

The heat collector plate is composed of a glass cover plate, a heatabsorbing layer, and a set of heat exchange tubes. There is a  $2cm$  gap between the glass cover plate and the heat- absorbing layer. During the experiment, the average surface temperature of the glass cover plate  $T_{gs}$  and the average surface temperature of the heat- absorbing layer  $T_{sl}$  were measured. Then the qualitative temperature in the collector plate can be expressed as:

$$
T_{mx} = \frac{T_{gs} + T_{sl}}{2} \tag{43}
$$

where  $T_{mx}$  is the temperature of the air in the heat collector plate, and the thermal physical properties of dry air are shown in Table 2.

Natural convection heat transfer per unit area between the heatabsorbing surface and the inner surface of the glass cover can be expressed as:

$$
N_u = 0.212\cdot (Gr\cdot pr)^{\frac{1}{4}} \tag{35}
$$

$$
G\cdot pr = \frac{g\cdot a\cdot(T_{sl} - T_{gs})\cdot(\partial_{gs})^3\cdot pr}{\nu^2} \tag{36}
$$

$$
Q_{sl,airsl}^{dl} = \frac{Nu\cdot\lambda_{airsl}}{\partial_{gs}} (T_{sl} - T_{gs}) \tag{37}
$$

The radiant heat flux per unit area from the heat- absorbing surface inside the collector plate to the inner surface of the glass cover plate can

Table 2 Thermophysical properties of dry air.  

<table><tr><td>Tmx
(°C)</td><td>λ×10²
[W/(m·K)]</td><td>ν×10⁶
(m²/s)</td><td>pr</td></tr><tr><td>10</td><td>2.51</td><td>14.16</td><td>0.705</td></tr><tr><td>20</td><td>2.59</td><td>15.06</td><td>0.703</td></tr><tr><td>30</td><td>2.67</td><td>16.00</td><td>0.701</td></tr><tr><td>40</td><td>2.76</td><td>16.96</td><td>0.699</td></tr><tr><td>50</td><td>2.83</td><td>17.95</td><td>0.698</td></tr><tr><td>60</td><td>2.90</td><td>18.97</td><td>0.696</td></tr><tr><td>70</td><td>2.96</td><td>20.02</td><td>0.694</td></tr></table>

be expressed as:

$$
Q_{gs,sl}^{HR} = \frac{5.67\cdot\left[\left(\frac{T_{sl} + 273}{100}\right)^4 - \left(\frac{T_{gs} + 273}{100}\right)^4\right]}{\frac{1}{\phi_{sl}} + \frac{1}{\phi_{gs}} - 1} \tag{47}
$$

Therefore, the effective heat flux per unit area of the heat- absorbing surface inside the heat collector plate can be expressed as:

$$
Q_{sl} = \tau_{gs}\cdot G_{sl}\cdot \Gamma_{sl} - Q_{gs,airsl}^{HR} - Q_{gs,sl}^{HR} \tag{48}
$$

Therefore, the thermal efficiency of the heat collecting plate can be expressed as:

$$
n_{sl} = \frac{Q_{sl}}{G_{gs}} \tag{49}
$$

The internal heat- absorbing layer and the heat exchanger tube carry away the collected heat through forced exchange during the day. Cold water is turned into hot water by heat exchange and stored in the tank. At the same time, convective heat exchange takes place between the outside surface of the collector plates and the air inside the greenhouse. Therefore, to facilitate the calculation, we calculate the heat balance of the greenhouse heat collector plate, and the heat balance of the water tank analysis. The heat collector plate absorbs some of the solar radiation that is irradiated on its surface, while the rest is reflected out. The solar radiation absorbed by the surface of the heat collector plate can be expressed as:

$$
Q_{gsab} = (1 - \tau_{gs})\cdot G_{sl} \tag{50}
$$

For the outer surface of the glass cover plate, part of the heat is lost to the indoor air through convection with the air, and the other part is heat transfer with each surface through radiation. Then the convection heat transfer between the surface of the glass cover plate and the inside of the greenhouse can be expressed as:

$$
Q_{gs,airi}^{dl} = h_{gs,airi}^{dl}\cdot (T_{gs} - T_{airi}) \tag{51}
$$

Therefore, the heat balance of the greenhouse heat collector plate can be expressed as:

$$
\begin{array}{c}{G_{gs}(1 - \tau_{gs}) - \rho_{gs}c_{gs}l_0\cdot \frac{dT_{gs}}{dt} = Q_{gs,airi}^{dl} + Q_{gs,rf}^{HR} + Q_{gs,fl}^{HR} + Q_{gs,gd}^{HR} + Q_{gs,wl}^{HR}}\\ {+Q_{gs,sl}^{HR} - Q_{gs,sl}^{HR}} \end{array} \tag{52}
$$

# 4.6.2. Energy balance of water storage tank

$$
\begin{array}{c}{A_{gs}G_{gs}\eta_{sl} - \rho_{wt}c_{wt}V_{sl}\cdot \frac{dT_{st}}{dt} = L_{cu}\cdot Q_{sl,airsl}^{dl} + A_{st}Q_{st,airi}^{cd} + A_{st}Q_{st,rf}^{HR} + A_{st}Q_{st,fl}^{HR}}\\ {+A_{st}Q_{st,wl}^{HR} + A_{st}Q_{st,fd}^{HR} + A_{st}Q_{st,gx}^{HR}} \end{array}
$$

The heat transfer between the air inside the heat collector plate and the air inside the heat exchanger tube can be expressed as follows:

$$
Q_{sl,airsl}^{dl} = \frac{T_{mix} - T_{airsl}}{\frac{1}{2\pi R_1b_{sl}} + \frac{\ln(R_2 / R_1)}{2\pi k_{ex}} + \frac{1}{2\pi R_2h_{airsl}}} \tag{54}
$$

where  $Q_{sl,airsl}^{dl}$  is the convection heat transfer between the air inside the heat collector plate and the heat exchange tube inside the heat collector plate.  $T_{mix}$  is the average temperature of the water temperature at the inlet and the water temperature at the outlet of the heat collector plate, which can be expressed as(Kiyan et al., 2013):

$$
T_{mix} = \frac{1}{3} T_{in} + \frac{2}{3} T_{out} \tag{55}
$$

In equation (54),  $h_{sl}$  is the convective heat transfer coefficient of the flow water inside the heat exchange tube and the tube wall. For turbulent flow in smooth tubes, which can be calculated by the Dittus- Boelter formula, can be expressed as:

$$
h_{sl} = 0.023Re^{0.8}Pr^m\cdot \frac{\lambda_f}{2R_1} \tag{47}
$$

where  $m$  is 0.4 for heating and 0.3 for cooling of the flow through the tube,  $Re$  is the Reynolds number, and  $Pr$  is the Prandtl number (Winterton, 1998).

After the cold water passes through the heat exchange flow out of the heat collector plate, it passes through the return pipe for heat exchange. Then the heat exchange through the return pipe can be expressed as:

$$
Q_{st,airi}^{cd} = \frac{T_{in} - T_{airi}}{\frac{1}{h_{airi}} + \frac{\partial_u}{k_{st}} + \frac{\partial_{ul}}{k_{yl}}} \tag{48}
$$

# 4.7. Energy balance of infiltration ventilation

The wind infiltrates the greenhouse through its doors and windows during osmotic ventilation, which can be expressed as (Joudi and Farhan, 2015):

$$
Q_{vt} = c_{air}\rho_{air}N_{air}H\frac{(T_{airi} - T_{airo})}{3600} \tag{58}
$$

where  $N_{air}$  is the exchange rate of air inside and outside the greenhouse, which ranges from 0.6 to 1 for a general energy- saving solar greenhouse to 0.85 in this study.

# 4.8. Energy balance of the greenhouse air

For the energy balance of the inside air, which consists mainly of convective heat exchange between the surfaces in the greenhouse and the air inside.  $P_{air} = A_{wl}Q_{wl,air} + A_{fl}Q_{fl}^{dl} = A_{fl}Q_{fl,air}^{dl} + A_{gl}Q_{gl,air}^{dl} + A_{fl}Q_{fl,air}^{dl} + A_{gl}Q_{gl,air}^{dl}$  air inside.  $+A_{wl}Q_{wl,air}^{dl} + A_{st}Q_{st,airi}^{cd} - Q_{vt}$  (59).

# 4.9. Model solving process

To verify the accuracy of the model, the above equations were modelled and calculated in MATLAB 2018Ra. Radiant intensity and outdoor air temperature for each surface are entered into the model. The name of each surface physical property parameter was set and the base temperature of each surface was given. Finally, the fsolve ode solver is used to solve for the temperature. The physical properties of the layered structure of each surface and the average effective properties of each layer can be considered the same at the time of the input parameters. The measurements were taken on 14 February and 15 February 2022 from 9:00 am to 3:30 pm. Finally, the measured temperature is compared with the simulated data. The basic parameters of the water heat storage system used in the simulation are shown in Table 3.

To quantify the accuracy of the model developed, different statistical parameters were calculated.

Absolute error between predicted and measured values

$$
MAE = \frac{\sum_{i = 1}^{N}|X_i - Y_i|}{N} \tag{60}
$$

Coefficient of correlation among predicted and measured values

$$
R^2 = 1 - \frac{\sum_{i = 1}^{N}(X_i - Y_i)^2}{\sum_{i = 1}^{N}(X_i - \overline{X}_i)^2} \tag{55}
$$

$R^2$  is in the range 0- 1. The closer the value is to 1, it indicates that the predicted value is in good agreement with the measured value.

The root mean square error (RMSE) was calculated using following equation.

Table 3 Basic parameters of water heat storage used in the simulation.  

<table><tr><td>Description</td><td>Value</td><td>Unit</td></tr><tr><td>Single heat collector plate parameters</td><td></td><td></td></tr><tr><td>The length of the collector plate</td><td>2</td><td>m</td></tr><tr><td>The height of the collector plate</td><td>1</td><td>m</td></tr><tr><td>The width of the collector plate</td><td>0.08</td><td>m</td></tr><tr><td>Velocity of water in the heat exchange tube (vwt)</td><td>7</td><td>m/s</td></tr><tr><td>Heat exchanger tube inner diameter (Rz)</td><td>5</td><td>mm</td></tr><tr><td>Heat exchanger tube outer diameter (Rz)</td><td>7</td><td>mm</td></tr><tr><td>Tube length in a heat exchanger plate (L)</td><td>12.6</td><td>m</td></tr><tr><td>Coefficient of convective heat transfer inside the tube (hcl)</td><td>26914.44</td><td>w/m-2.k-1</td></tr><tr><td>Coefficient of convection heat transfer outside the tube (hairsl)</td><td>3.74</td><td>w/m-2.k-1</td></tr><tr><td>Individual tank parameter</td><td></td><td></td></tr><tr><td>Tank length</td><td>3</td><td>m</td></tr><tr><td>Tank width</td><td>0.5</td><td>m</td></tr><tr><td>Tank height</td><td>0.2</td><td>m</td></tr><tr><td>partial</td><td>1</td><td>cm</td></tr><tr><td>partial</td><td>8</td><td>w/m-1.k-1</td></tr><tr><td>partial</td><td>0.045</td><td>w/m-1.k-1</td></tr><tr><td>Outside convection coef (hst)</td><td>7.4</td><td>w/m-1.k-1</td></tr></table>

$w / m^2$  and  $264.12w / m^2$  respectively. The discrepancies between calculated and measured results may stem from errors in measuring instruments or the outdoor light transmission rate.

As shown in Fig. 5, the magnitude of the coefficient of determination for the solar radiation intensity in the horizontal direction outside the greenhouse is 0.975. The calculated and measured results are in good agreement. The validity of the radiation calculation model has been demonstrated, indicating its suitability for calculating solar radiation intensity.

As shown in the Fig. 6, the temperature of the air outside is directly affected by the intensity of outdoor radiation. The change in outdoor air temperature follows the same pattern as radiation intensity. Temperatures on February 15 were slightly lower than those on February 14. The highest temperatures on both days occurred at  $1:30\mathrm{pm}$  .Its values were  $1.8^{\circ}C$  and  $0.48^{\circ}C$  The average temperatures for the two days from 9 am. to  $24~\mathrm{pm}$  were  $- 4.4^{\circ}C$  and  $- 6.4^{\circ}C$  respectively.

$$
\begin{array}{c}{RMSE = \sqrt{\frac{1}{N}\sum\left(Y_i - X_i\right)^2}}\\ {}\\ {MRE = \frac{1}{N}\sum_{i = 1}^{N}\left(\frac{Y_i - X_i}{X_i}\right)\times 100\%} \end{array} \tag{63}
$$

Where  $X_{i}$  is the measured value.  $Y_{i}$  is the predicted value.  $\overline{X_i}$  is the average of measured value and  $N$  is the number of measurements of the value.

# 5.Results and discussion

# 5.1. Comparison of solar radiation data

As shown in Fig. 4, a comparison was made between the predicted and measured radiation intensities. The outdoor solar radiation intensity increases in the morning as the solar altitude angle rises. The peak solar radiation intensity occurs at solar noon. The solar radiation intensity diminishes during the afternoon hours as the solar altitude angle decreases. The average intensity of radiation for the two days was 324.43

Solar radiation is the primary heat source in a solar greenhouse, directly affecting the temperature of each surface within it. The temperature change pattern on each surface of the greenhouse was determined by calculating radiation levels. Fig. 7 shows the pattern of radiation change from 9:00 am. to  $3:30\mathrm{pm}$  on all surfaces in the greenhouse. The radiation intensity on the front roof of the greenhouse is significantly higher due to direct sunlight exposure compared to other surfaces. Radiation intensity at ground and back roof is lower than other surfaces due to heavy shading. The value of them is about one quarter of the intensity of the radiation on the surface of the north wall.

# 5.2. Comparison of surface temperatures in the greenhouse

As shown in Fig. 8, the air temperature in the greenhouse tends to rise when the thermal blanket is removed. The temperature peaks at  $1:30\mathrm{pm}$  and then gradually decreases. The highest values of temperature were  $40.3^{\circ}C$  and  $36.3^{\circ}C$  respectively. The average error between the predicted and measured values was  $1.4^{\circ}C$  during the experiment. The errors were most likely caused by instrument malfunctions and the presence of clouds outside the greenhouse. The  $R^2$  for the predicted and measured values for the two days of the experiment was 0.9789, respectively (Fig. 9), indicating good agreement between the measured and predicted results.

As shown in Fig. 10, Temperatures on the back roof of the greenhouse fluctuated considerably, with a difference of  $1.89^{\circ}C$  between predicted and measured values over two days. The experiment's error may have been caused by the calculated solar radiation values being

![](images/43b4bb8ab13dc638d6b58fdd5c45de9de32c9f41ff3f2946f1c6ffab10988cc5.jpg)  
Fig. 4. Comparison of outdoor horizontal ground radiation intensity.

![](images/baf801609657cf60c7776226d30f6b847f11d71e6a7fad30419212b6321339b5.jpg)  
Fig. 5. Analysis of the relationship between measured and predicted outdoor horizontal radiation values.

![](images/e3b893115264ff86c17b195231ff3098215b56e153911b0d0efebd0bc0297617.jpg)  
Fig. 6. Outdoor air temperature.

![](images/2895d49f198116f99ee9ec789f9f3e0ff94c1b88ecae594ddc95050b43697640.jpg)  
Fig. 7. Radiation intensity by surface in the greenhouse.

higher than the actual values on the back roof surface due to heavy shading from thermal blanket during the day. The predicted value was overestimated compared to the measured value. At night, the front roof of the greenhouse is covered by a thermal blanket, which transfers its own temperature to the greenhouse causing errors. The  $R^2$  for the greenhouse back roof temperature was 0.9163, indicating a good fit of the data and a good representation of the greenhouse back roof temperatures (Fig. 11).

As shown in Fig. 12, the temperature of the front roof of the greenhouse fluctuates considerably. The temperature of the front roof was affected greatly by the outside air because of the thin po film on the front roof. This resulted in an average temperature difference of  $1.98^{\circ}\mathrm{C}$  between the predicted and measured values, respectively. The temperature of the front roof suddenly increases from about  $3:30\mathrm{pm}$  to  $4:00\mathrm{pm}$  each day. The turning point occurs because the cotton blanket is closed at  $3:30\mathrm{pm}$ . The temperature of the thermal blanket is higher than the temperature of the front roof of the greenhouse, which leads to a rapid increase in the temperature of the front roof of the greenhouse. As shown in Fig. 13, the  $R^2$  for the front roof temperature was 0.9608 respectively.

![](images/dddc1dc562b86f4356cf0f27356e49a1aad1912e8f79c11b43377011660aaedb.jpg)  
Fig. 8. Air temperature comparison.

![](images/217e86ae48b55edcedbb907ddf36b536eae3660b37ca6d7688417be9e9d37869.jpg)  
Fig. 9. Analysis of air temperature relationships.

The results show a large error between the predicted and measured values. On the one hand, the front roof of the greenhouse may have been exposed to air for a long time, which could be the reason. The front roof of the greenhouse is covered with dust, which reduces the radiant transmission rate of the front roof. The actual radiation values were lower than the calculated values, resulting in a lower surface temperature than predicted. On the other hand, the temperature of the front roof of a greenhouse is calculated based on the inner surface temperature, which is a curved surface. The angle of incidence is different at each point, which leads to a large difference in temperature at each point.

Due to the complexity of heat transfer inside the heat collector plate and the difficulty of measuring the internal temperature. The temperature of the glass cover on the surface of the heat collector plate was used in the temperature comparison section of the heat collector plate. As shown in Fig. 14, the average error between the predicted and measured values over the two days of the experiment was  $2.07^{\circ}\mathrm{C}$  respectively. The experiment's error may have been caused by the calculated solar radiation values being higher than the actual values on the heat collector plate surface due to heavy shading from soilless shelves. This results in lower actual surface temperatures than predicted temperatures. The  $R^2$

![](images/f509930240c4ec571ae8edbb9d44769d3cc009c38c68fb504d0f1149cecbe27c.jpg)  
Fig. 10. Comparison of back roof temperatures.

![](images/02537139ee584c72517ae3f9a5e2745cac5f5c1187613e83a96886ca8abe7506.jpg)  
Fig. 11. Analysis of back roof temperature relationships.

for the collector surface temperatures for the two days was 0.9551 respectively (Fig. 15), which indicates that the temperature of the collector surface can be calculated well using this model.

When calculating the temperature of the north wall of the greenhouse, because the heat collector plate and the water tank are suspended on the inner surface of the north wall. This part of the north wall temperature comparison refers to the surface temperature of the north wall except for the water tank and the heat collector plate part. As can be seen from Fig. 16, the temperature on the north wall rises when the thermal blanket is removed, peaks at midday, and then decreases. The  $R^2$  for the predicted and measured values over the two days of the experiment is shown in Fig. 17. The coefficient of determination for north wall on both days exceeds around 0.9495. During the experiment. The average error between measured and predicted values for the north wall was  $2.26^{\circ}C$ . The north wall of the greenhouse is heavily shaded by the thermal blanket and indoor soilless shelves due to the increase of the solar altitude angle.

As shown in Fig. 18. During the day, solar radiation converges on the heat collector plate. The water pump brings the heat from the heat collector plates into the water storage tank by circulating the water.

![](images/f9290397b7cc1f74d86423ce3fcc9043a1fdea318a488f50b50a1b930bd418a4.jpg)  
Fig. 12. Comparison of front roof temperatures.

![](images/b0a7158bf9e8d222ada0c18c646316fdee679bb862d9b32804ed9af891b6b4a0.jpg)  
Fig. 13. Analysis of front roof temperature relationships.

Eventually the heat is stored in the tank. In this experiment, the water pump circulates from 9:00 am. to 3:30 pm during the daytime. The water pump circulates at night from 24:00 pm to 9:00 am. As shown in Fig. 18, the rate of decrease in water temperature from 24:00 pm. to 9:00 am. is slightly higher than that from 3:00 pm. to 24:00 pm. As shown in Fig. 19, the coefficients of determination for the predicted and measured water temperatures for both days is 0.9897 respectively, which indicates that the calculation method is a good way to calculate the water temperature for this type of tank.

As shown in Fig. 20, the greenhouse ground temperature reached its maximum at around 1:00 pm. The average error between the predicted and measured values over the two days was  $1.44^{\circ}C$  respectively. The  $R^2$  for ground temperature were calculated to be 0.8257 for the two days (Fig. 21). The cause of the experimental error is a combination of the plant cultivation shelves and the calculated radiation intensity. On the one hand, when direct radiation enters the greenhouse, a large amount of direct radiation is shaded by the plant cultivation shelves. On the other hand, the solar radiation used in the simulation is the calculated mean value of the radiation. As the solar altitude angle increases, the

![](images/ac4e9f3d23e8643b8b6c7f0b2037f5046861e1b071210097ab12297061050007.jpg)  
Fig. 14. Comparison of heat collector plates temperature.

![](images/5082b7ad7bd78fc45e9caddb39e27057414066a3b72b3abb4cf3e71dd7fc97c5.jpg)  
Fig. 15. Analysis of heat collector plates temperature relationships.

intensity of radiation between the plant cultivation shelves increases dramatically at midday. In the afternoon, the intensity of radiation between plant cultivation shelves decreases rapidly as the sun's altitude angle decreases. These lead to experimental errors.

# 5.3. Model performance

To better understand the reliability of the model. Mean relative error (MRE), absolute error (MAE), coefficient of correlation  $(R^2)$  and root mean square error (RMSE) were used to verify the accuracy of the model. As shown in Table 4, the absolute error (MAE) varied from  $0.68^{\circ}\mathrm{C}$  to  $2.26^{\circ}\mathrm{C}$ . Small temperature error due to less thermal interference with the water storage tank. Mean relative error (MRE) varied from  $1.9\%$  to  $10.4\%$ . The root mean square error varied from  $0.37^{\circ}\mathrm{C}$  to  $2.9^{\circ}\mathrm{C}$ . The coefficient of determination varies from 0.8257 to 0.9897. All the results are within the error tolerance, indicating that the model can be used for CASG with good stability in thermal performance modeling.

![](images/ea6dd46443e5acfd9c017d37095cf8c27e7ec0e3466969bf32c887024235556a.jpg)  
Fig. 16. Comparison of north wall temperature.

![](images/49d2be41a3016229f35b7b5ed98b2132da854ac3980883d83ebfa73f10ee6743.jpg)  
Fig. 17. Analysis of north wall temperature relationships.

# 5.4. Different weather simulations

The temperature inside the greenhouse is an important measure of the microenvironment inside the greenhouse. Particularly in northern China, the low outdoor temperatures in winter place high demands on the thermal insulation properties of greenhouses. In this section, we evaluate the insulation performance of solar greenhouses by predicting temperatures inside the greenhouse under different weather conditions for a typical sunny day in winter and a combination of sunny and cloudy days.

As shown in Fig. 22, The solar radiation intensity outside was calculated on a typical sunny winter day. The average daily solar radiation intensity was  $233.23w / m^2$ . The absolute error between the calculated and measured values is  $16.65w / m^2$ . The  $R^2$  for outdoor solar radiation was calculated to be 0.965 for the day Meanwhile, the outdoor air temperature was measured. The maximum outdoor temperature value was  $2.0^{\circ}\mathrm{C}$  and the minimum temperature was  $- 10.4^{\circ}\mathrm{C}$ . The average daily temperature is  $- 2.7^{\circ}\mathrm{C}$ .

As shown in Fig. 23, the CASG shows good thermal performance on

![](images/7f1d029cb19c526373c1c94d3302fe0fbfbac3a26ecec3cd52a481dd28b21150.jpg)  
Fig. 18. Comparison of water storage tank temperatures.

![](images/ca80e5bb4257e8d99d7c4b05e6a8665dee158c05dc895e6e075cae21e9f406c6.jpg)  
Fig. 19. Analysis of water tank temperature relationships.

![](images/22b9c7c6f65ec4711c1f7df30a05e1bc25050db4c783fe2f74ae9ab83e9d34ea.jpg)  
Fig. 20. Comparison of ground temperatures.

![](images/58cc39f899fa576f3e995600d90a13c8ecc5a172397ded033a7cb82a6c85c958.jpg)  
Fig. 21. Analysis of ground temperature relationships.

Table 4 Error analysis in modeling for internal temperatures of greenhouse.  

<table><tr><td>Structural surfaces</td><td>MAE</td><td>MRE</td><td>RMSE</td><td>R²</td></tr><tr><td>Font roof</td><td>1.98</td><td>10.4</td><td>2.61</td><td>0.9608</td></tr><tr><td>Back roof</td><td>1.89</td><td>3.3</td><td>2.47</td><td>0.9462</td></tr><tr><td>Ground</td><td>1.44</td><td>7.1</td><td>2.01</td><td>0.8257</td></tr><tr><td>Heat collector plate</td><td>2.07</td><td>8.46</td><td>2.41</td><td>0.9551</td></tr><tr><td>Air</td><td>1.4</td><td>6.2</td><td>1.61</td><td>0.9789</td></tr><tr><td>North wall</td><td>2.26</td><td>5.9</td><td>2.9</td><td>0.9495</td></tr><tr><td>Water storage tank</td><td>0.68</td><td>1.9</td><td>0.37</td><td>0.9897</td></tr></table>

![](images/489263a121b19a69c3cc61290b4e0c2a0bd4593f40676209253021db205b029a.jpg)  
Fig. 22. Outdoor solar radiation and temperature on a typical sunny day.

sunny days in winter, reaching an average temperature of around  $27^{\circ}C$  inside the greenhouse even minimum outdoor temperature around  $- 10^{\circ}\mathrm{C}$ . The north wall of the greenhouse surface reached a maximum temperature exceeding  $50^{\circ}\mathrm{C}$ . The assembled solar greenhouse separates insulation and heat storage from the traditional wall, so the north wall mainly acts as a support. The unique structure of the wall results in a very low heat transfer coefficient, concentrating all the heat on its surface. The maximum temperature on the heat collector plate surface is approximately  $40^{\circ}\mathrm{C}$ , compared to the wall surface. The heat collector plate transfers most of the heat to water through exchange tubes, while

![](images/005ac9fede14447424738a6b58ba93d9c23e5d10d7bd4b884e140d6669aed1cc.jpg)  
Fig. 23. Temperature of each surface on a sunny day.

convective and radiative heat exchange occurs between the plate, air, and surfaces in the greenhouse. As a result, the surface temperature of the collector plate is slightly lower than the surface temperature of the north wall. Thanks to the efficient heat exchange capacity of the panels, the temperature of the water tank rises slowly from the moment the thermal blanket is removed. A large amount of heat is concentrated in the water tank, which can reach a maximum temperature of around  $45^{\circ}\mathrm{C}$ . The temperature of the greenhouse ground rises more slowly compared to other surfaces inside. The reason for the low greenhouse ground temperature is that the ground is more heavily shaded by the soilless shelves in the greenhouse.

To fully understand the thermal performance of the CASG, We modeled the thermal environment of CASG in winter with a combination of sunny days and prolonged cloudy days. As shown in Fig. 24, outdoor solar radiation gradually increases as the sun's altitude angle increases between  $9\mathrm{am}$  and  $11\mathrm{pm}$ . The intensity of outdoor solar radiation decreases sharply from 11: pm to 12: pm due to cloud cover. The average outdoor radiation intensity for the whole day was calculated to be  $211.98\mathrm{w} / \mathrm{m}^2$ . The absolute error between the calculated and predicted radiation intensity was  $20.85\mathrm{w} / \mathrm{m}^2$ . The  $R^2$  for outdoor solar radiation was calculated to be 0.8185 for the day. The reason for the large error in the data is that the outdoor solar radiation was obscured by clouds at the time of data measurement. At the same time, outdoor air temperature was measured. The highest outdoor temperature occurred at  $12:10\mathrm{pm}$ . Outdoor air temperature and radiation intensity showed the same trend.

As shown in Fig. 25. The indoor air temperature was about  $10^{\circ}\mathrm{C}$  when the thermal blanket was taken off in the morning. At midday, the maximum air temperature in the greenhouse is  $28^{\circ}\mathrm{C}$ . The average indoor air temperature was around  $21^{\circ}\mathrm{C}$  throughout the day, which is caused by outdoor radiation and low temperatures. The temperature dropped between  $11:00\mathrm{am}$  and  $12:00\mathrm{pm}$  due to the clouds blocking the sun. The front roof of the greenhouse, directly exposed to outdoor air, had a minimum temperature of only  $7.4^{\circ}\mathrm{C}$  due to outdoor air temperature influence. The temperature change at ground level in the greenhouse is not easily noticeable due to constant shading. However, as the greenhouse walls were directly influenced by the amount of radiation on the surface, the maximum temperature on the surface of the walls was only  $40^{\circ}\mathrm{C}$ . The more gentle and slower rise in tank water temperature compared to sunny days suggests that outdoor radiation is an important factor affecting the amount of heat stored in the tanks. The interior of the greenhouse maintained a suitable temperature for plant growth, despite the low outdoor radiation.

![](images/fe83272613dc854bec30e22ea4d4caf3110e33041efc64f85193a44e2485770e.jpg)  
Fig. 24. Outdoor solar radiation and temperature on a typical sunny day.

![](images/6eee0dd45e165531dee608d682283c0a48b7d73c1d21950f3073c365faaffa7d.jpg)  
Fig. 25. Temperature of each surface on a cloudy day.

# 6. Conclusion

In this paper, a one- dimensional transient temperature prediction model is constructed for a CASG with a water storage device based on the energy balance principle. The model is calculated using MATLAB predicts surface temperatures within the permissible range for each surface in the CASG with high accuracy.

The statistics of the calculated and measured results show that the average temperature difference between the front roof, air, north wall, heat collector plate, water storage tank, ground, and back roof of the greenhouse are  $1.98^{\circ}\mathrm{C}$ ,  $1.4^{\circ}\mathrm{C}$ ,  $2.26^{\circ}\mathrm{C}$ ,  $2.07^{\circ}\mathrm{C}$ ,  $0.68^{\circ}\mathrm{C}$ ,  $1.44^{\circ}\mathrm{C}$ , and  $1.89^{\circ}\mathrm{C}$ , respectively. The  $R^2$  for all surfaces from 0.8257 to 0.9897. The model can be used for climate simulation at CASG.

Although we included a weather factor in the calculation of outdoor radiation intensity, outdoor radiation intensity is strongly influenced by factors such as clouds. In future studies, we will continue to optimize the outdoor solar radiation model. At the same time, we will also study the ventilation model of greenhouse and the indoor soilless plant model, so that the model has a wider range of application scenarios.

# CRediT authorship contribution statement

Lei Zhao: Conceptualization, Methodology, Software, Formal analysis, Writing - original draft. Jiangchen Lu: Data curation, Writing - original draft. Hanlin Liu: Investigation. Yiming Li: Resources, Supervision. Zhouping Sun: Xingan Liu: Conceptualization, Funding acquisition, Resources, Supervision, Writing - review & editing. Tianlai Li: Conceptualization, Funding acquisition, Resources, Supervision, Writing - review & editing.

# Declaration of Competing Interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

# Data availability

Data will be made available on request.

# Acknowledgments

The authors are grateful to Horticulture Facility Design & Environmental Control Research Institute for supporting the project.

This work was supported by China Agriculture Research System, Ministry of Agriculture, PR China. [CARS- 23]

# References

Aadel- Ghany, A.M., Kozai, T., 2006. Dynamic modeling of the environment in a naturally ventilated, fog- cooled greenhouse. Renew. Energy 31, 1521- 1539. https://doi.org/10.1016/j.renene.2005.07.013. Berroug, F., Lakhal, E.K., El Omari, M., Faraji, M., El Qarnia, H., 2011. Thermal performance of a greenhouse with a phase change material north wall. Energ. Buildings 43, 3027- 3035. https://doi.org/10.1016/j.enbuild.2011.07.020. Chen, C., Li, Y., Li, N., Wei, S., Yang, F.G., Ling, H.S., Yu, N., Han, F.T., 2018. A computational model to determine the optimal orientation for solar greenhouses located at different latitudes in China. Sol. Energy 165, 19- 26. https://doi.org/10.1016/j.solener.2018.02.022. Chen, J., Yang, J., Zhao, J., Xu, F., Shen, Z., Zhang, L., 2016. Energy demand forecasting of the greenhouses using nonlinear models based on model optimized prediction method. Neurocomputing 174, 1087- 1100. https://doi.org/10.1016/j.neucom.2015.09.105. Choab, N., Allouhi, A., El Maakoul, A., Kousksou, T., Saadeddine, S., Jamil, A., 2019. Review on greenhouse microclimate and application: Design parameters, thermal modeling and simulation, climate controlling technologies. Sol. Energy 191, 109- 137. https://doi.org/10.1016/j.solener.2019.08.042. Joudi, K.A., Farhan, A.A., 2015. A dynamic model and an experimental study for the internal air and soil temperatures in an innovative greenhouse. Energ. Conver. Manage. 91, 76- 82. https://doi.org/10.1016/j.enconman.2014.11.052. Kiyan, B., Bingol, E., Melikoglu, M., Albostan, A., 2013. Modelling and simulation of a hybrid solar heating system for greenhouse applications using Matlab/Simulink. Energ. Conver. Manage. 72, 147- 155. https://doi.org/10.1016/j.enconman.2012.09.036.

Li, J., Li, L., Wang, H., Ferentinos, K.P., Li, M., Sigrimis, N., 2017. Proactive energy management of solar greenhouses with risk assessment to enhance smart specialisation in China. Biosyst. Eng. 158, 10–22. https://doi.org/10.1016/j.biosystemseng.2017.03.007. Liu, H., Yin, C., Gao, Z., Hou, L., 2021a. Evaluation of cucumber yield, economic benefit and water productivity under different soil matrix potentials in solar greenhouses in North China. Agric Water Manag 243, 106442. https://doi.org/10.1016/j.agwat.2020.106442. Liu, R., Li, M., Guzman, J.L., Rodriguez, F., 2021b. A fast and practical one- dimensional transient model for greenhouse temperature and humidity. Comput. Electron. Agric. 186, 106186. https://doi.org/10.1016/j.compag.2021.106186. Ma, J., Du, X., Meng, S., Ding, J., Gu, X., Zhang, Y., Li, T., Wang, R., 2022. Simulation of Thermal Performance in a Typical Chinese Solar Greenhouse. Agronomy 12 (10), 2255. https://doi.org/10.3390/agronomy12102255. Mobtaker, H.G., Ajabshirchi, Y., Ranjbar, S.F., Matloobi, M., 2019. Simulation of thermal performance of solar greenhouse in a north- west of Iran: An experimental validation. Renew. Energy 135, 88–97. https://doi.org/10.1016/j.renene.2018.10.003. Reyes- Rosas, A., Molina- Aiz, F.D., Valera, D.L., Lopez, A., Khamkure, S., 2017. Development of a single energy balance model for prediction of temperatures inside a naturally ventilated greenhouse with polypropylene soil mulch. Comput. Electron. Agric. 142, 9–28. https://doi.org/10.1016/j.compag.2017.08.020. Singh, G., Singh, P.P., Lubana, P.P.S., Singh, K.G., 2006. Formulation and validation of a mathematical model of the microclimate of a greenhouse. Renew. Energy 31, 1541–1560. https://doi.org/10.1016/j.renene.2005.07.011. Singh, M.C., Singh, J.P., Pandey, S.K., Mahay, D., Shrivastva, V., 2017. Factors Affecting the Performance of Greenhouse Cucumber Cultivation- A Review. Int. J. Curr. Microbiol. App. Sci. 6, 2304–2323. https://doi.org/10.20546/jcmas.2017.610.273. Singh, M.C., Singh, K.G., Singh, J.P., 2018. Performance of soilless cucumbers under partially controlled greenhouse environment in relation to deficit fertigation. Indian J. Hortic. 75 (2), 259. https://doi.org/10.5958/0974- 0112.2018.00044.0. Straten, G.v., Willigenburg, G.v., Henten, E.v., Ooteghem, R.v., 2010. Optimal control of greenhouse cultivation. Boca Raton, 326. doi: 10.1201/b10321.

Swinbank, W.C., 1963. Long- wave radiation from clear skies 89 (381), 339–348. https://doi.org/10.1016/j.inpa.2016.06.002. Taki, M., Ajabshirchi, Y., Ranjbar, S.F., Rohani, A., Matloobi, M., 2016. Modeling and experimental validation of heat transfer and energy consumption in an innovative greenhouse structure. Information Processing in Agriculture 3, 157–174. https://doi.org/10.1016/j.inpa.2016.06.002. Tong, G., Christopher, D.M., Li, B., 2009. Numerical modelling of temperature variations in a Chinese solar greenhouse. Comput. Electron. Agric. 68, 129–139. https://doi.org/10.1016/j.compag.2009.05.004. Vanthoor, B.H.E., de Visser, P.H.B., Stanghellini, C., van Henten, E.J., 2011a. A methodology for model- based greenhouse design: Part 2, description and validation of a tomato yield model. Biosyst. Eng. 110, 378–395. https://doi.org/10.1016/j.biosystemseng.2011.08.005. Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J., de Visser, P.H.B., 2011b. A methodology for model- based greenhouse design: Part 1, a greenhouse climate model for a broad range of designs and climates. Biosyst. Eng. 110, 363–377. https://doi.org/10.1016/j.biosystemseng.2011.06.001. Winterton, R.H.S., 1998. Where did the Dittus and Boelter equation come from? Heat Mass Transf 41, 809–810. https://doi.org/10.1016/s0017- 9310(97)00177- 4. Xia, T., Li, Y., Wu, X., Fan, Z., Shi, W., Liu, X., Li, T., 2022. Performance of a new active solar heat storage- release system for Chinese assembled solar greenhouses used in high latitudes and cold regions. Energy Rep. 8, 784–797. https://doi.org/10.1016/j.egyr.2021.12.005. Zhang, G., Ding, X., Li, T., Pu, W., Lou, W., Hou, J., 2020a. Dynamic energy balance model of a glass greenhouse: An experimental validation and solar energy analysis. Energy 198, 117281. https://doi.org/10.1016/j.energy.2020.117281. Zhang, Y., Henke, M., Li, Y.M., Yue, X., Xu, D.M., Liu, X.G., Li, T.L., 2020b. High resolution 3D simulation of light climate and thermal performance of a solar greenhouse model under tomato canopy structure. Renew. Energy 160, 730–745. https://doi.org/10.1016/j.renene.2020.06.144.