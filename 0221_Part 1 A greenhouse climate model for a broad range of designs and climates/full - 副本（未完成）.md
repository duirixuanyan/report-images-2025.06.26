手稿的电子附录，标题为：基于模型的温室设计方法：第一部分，适用于广泛设计和气候的温室气候模型

B.H.E. Vanthoor1,2, C. Stanghellini1, E.J. van Henten1,2, P.H.B. de Visser1

1瓦赫宁根大学及研究中心温室园艺，邮箱 644，NL-6700 AP 瓦赫宁根，荷兰 2农业技术组，瓦赫宁根大学，邮箱 17，NL-6700 AA 瓦赫宁根，荷兰

# 温室气候模型描述

第1节介绍了温室气候模型所需的设计元素。第2节描述了温室气候模型的概述和状态，第3节描述了集总覆盖层模型。第4节描述了模型容量。第5节描述了热通量，第6节描述了蒸汽通量，第7节描述了 $\mathrm { C O } _ { 2 }$ 通量。第8节介绍了冠层蒸腾模型。第9节给出了已实现设计元素的模型方程，第10节描述了未知室外气候输入的计算。表格在第11节中呈现。

# 术语表

模型中使用的状态、通量密度、上标和下标

<html><body><table><tr><td></td><td>Name</td><td>Unit</td><td></td></tr><tr><td>States</td><td></td><td></td><td></td></tr><tr><td>CO2</td><td>Carbon dioxide concentration</td><td>mg m-³</td><td></td></tr><tr><td>T</td><td>Temperature</td><td>℃</td><td></td></tr><tr><td>VP</td><td>Vapour pressure</td><td>Pa</td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>Flux densities</td><td></td><td></td><td></td></tr><tr><td>H</td><td>Sensible heat flux density</td><td>W m-2</td><td></td></tr><tr><td>L</td><td>latent heat flux density</td><td>Wm²</td><td></td></tr><tr><td>MC</td><td>mass COz-flux density</td><td>mg m² s-1</td><td></td></tr><tr><td>MV</td><td>mass vapour flux density</td><td>kg m2 s-1</td><td></td></tr><tr><td>R</td><td>FIR flux density</td><td>W m²</td><td></td></tr><tr><td>RNIR</td><td>NIR flux density</td><td>W m²</td><td></td></tr></table></body></html>

<html><body><table><tr><td>RPAR</td><td>PAR flux density</td><td>Wm²</td></tr><tr><td>RGlob</td><td>Global radiation flux</td><td>W m²</td></tr><tr><td></td><td>density</td><td></td></tr><tr><td>Superscripts</td><td></td><td></td></tr><tr><td>Day</td><td>Day period</td><td>Mean Mean value</td></tr><tr><td>Night</td><td>Night period</td><td></td></tr><tr><td>Subscripts Air</td><td>Greenhouse air</td><td>Obj Different greenhouse</td></tr><tr><td></td><td>compartment below thermal screen</td><td>objects</td></tr><tr><td>b</td><td>Boundary</td><td>Out Outside air</td></tr><tr><td>Blow</td><td>Direct air heater.</td><td>PAR Photosynthetically</td></tr><tr><td>Boil</td><td>Boiler</td><td>Active Radiation Pad Pad and fan system</td></tr><tr><td>Can</td><td>Canopy</td><td>Pas Passive heat storage</td></tr><tr><td></td><td></td><td>facility</td></tr><tr><td>Clear Cloud</td><td>Clear sky conditions Pipe</td><td> Pipe heating system</td></tr><tr><td>Cov</td><td>Cloudy sky conditions Rf</td><td>Roof of the greenhouse</td></tr><tr><td>e</td><td>Cover Roof</td><td>Roof ventilation</td></tr><tr><td>Ext</td><td>External side s</td><td> Stomata</td></tr><tr><td></td><td>External CO source Side</td><td>Side ventilation</td></tr><tr><td>FIR</td><td>Far Infrared Radiation Sky</td><td>Sky</td></tr><tr><td>Flr</td><td>Floor So(i)</td><td>The ‘j'th the soil layer</td></tr><tr><td>Fog</td><td>Fogging system Soil</td><td>The soil</td></tr><tr><td>Geo</td><td>Geothermal heat Sun</td><td>The sun</td></tr><tr><td>Gh</td><td>Greenhouse ShScr</td><td>Shading screen</td></tr><tr><td>Glob in</td><td>Global radiation</td><td>ShScrPer Semi permanent screen</td></tr><tr><td></td><td>Internal side Top</td><td>Compartment above the thermal screen</td></tr><tr><td>Ind</td><td>Industrial source</td><td>ThScr Thermal screen</td></tr><tr><td>Leaf</td><td>Canopy leaf</td><td>Vent Natural ventilation</td></tr><tr><td>Leakage</td><td>Leak ventilation</td><td>Ventforced Forced ventilation</td></tr><tr><td></td><td>through cracks</td><td></td></tr><tr><td>Mech</td><td> Mechanical cooling</td><td>Wind Wind</td></tr></table></body></html>

<html><body><table><tr><td></td><td></td><td></td><td></td></tr><tr><td>NIR</td><td>NearInfrared Radiation</td><td></td><td></td></tr></table></body></html>

外部气候输入、其余输入和气候控制变量。

<html><body><table><tr><td>External Climate Inputs CO20ut</td><td>Outdoor CO2 concentration</td><td>mg m-3</td><td></td></tr><tr><td>IGlob</td><td>The outside global radiation</td><td>Wm²</td><td></td></tr><tr><td>Tout</td><td>Outdoor temperature</td><td>℃</td><td></td></tr><tr><td>Tsly</td><td> Sky temperature</td><td>℃</td><td></td></tr><tr><td>Tsoout</td><td>Soil temperature of outer soil layer</td><td>℃</td><td></td></tr><tr><td>VPout</td><td>Outdoor vapour pressure</td><td>Pa</td><td></td></tr><tr><td>Vwind</td><td>Outdoor wind speed</td><td>ms-1</td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>Remaining inputs</td><td></td><td></td><td></td></tr><tr><td>LAI</td><td>The leaf area index The net CO2 flux from</td><td>m²m² mg m3 s-1</td><td>Vanthoor et al</td></tr><tr><td>MCAirCan</td><td>the air to the canopy by taking into account the canopy photosynthesis rate and respiration processes</td><td></td><td>(Submitted)</td></tr><tr><td>TMechCool</td><td>The temperature of the cool surface of the mechanical cooling system</td><td>℃</td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>Climate control variables (-)</td><td></td><td></td><td></td></tr><tr><td>U Blow</td><td>Heat blower control</td><td>U Roof</td><td>Control of the roof</td></tr></table></body></html>

<html><body><table><tr><td></td><td></td><td></td><td>ventilators</td></tr><tr><td>U Boil</td><td>Boiler control</td><td>U side</td><td>Control of the side ventilators</td></tr><tr><td>U Heatind</td><td>Control of the heat input from industry</td><td>UventForced</td><td>Control of the forced ventilation</td></tr><tr><td>U HeatGeo</td><td>Control of the heat input from geothermal source</td><td>U ExtCO2</td><td>Control of the CO2- input from an external source</td></tr><tr><td>U pad</td><td>Pad and fan control</td><td>U shScr</td><td>Control of the external shading screen</td></tr><tr><td>U MechCool</td><td>Control of the mechanical cooling</td><td>U shSerPer</td><td>Control of the semi- permanent shading screen</td></tr><tr><td>U Fog</td><td>Control of fogging system</td><td>U ThSer</td><td>Control of the thermal screen</td></tr></table></body></html>

剩余模型符号及其单位概述。

<html><body><table><tr><td>Water vapour content</td><td>Vapour exchange coefficient</td><td>Speed Λ</td><td>Time switch</td><td>Value of the differentiable</td><td>transpiration</td><td>Resistance factor for Resistance 1</td><td>Length 1</td><td>Heat exchange coefficient</td><td>Thickness 4</td><td>View factor H</td><td>Flux</td><td>Fraction J</td><td>Damping gdepth a</td><td>Depth p</td><td>Capacity of t f theassociated state</td><td>Specific I Area ：heat capacity H</td><td>coefficient</td><td>Amplitude or absorption D</td><td>Transmission coefficient 1 I</td><td>Thermal heat conductivity</td><td>Density or 1 Conversion( r reflection coefficient coefficient 0</td><td>FIR emission coefficient 3</td><td>Diameter Time e shift of sine function P d</td><td>Remaining symbols</td></tr><tr><td>X</td><td>品</td><td></td><td>1</td><td>S</td><td></td><td>sm</td><td>m-2</td><td>HEC M</td><td>Ⅱ -</td><td></td><td>-</td><td>-</td><td></td><td>cap</td><td>Jkg1K1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>kg water kg1 air</td><td>Pa-1 s</td><td></td><td></td><td></td><td></td><td></td><td></td><td>K-1</td><td></td><td>ms11</td><td></td><td></td><td></td><td></td><td>I</td><td></td><td></td><td>Wm1 K</td><td>kg m3， 1</td><td></td><td></td><td></td></tr></table></body></html>

# 1 温室设计元素

温室设计模型所选的功能和设计元素如图1所示。温室设计的功能包括：加热、隔热、遮阳、冷却、$\mathrm { C O } _ { 2 }$ 施肥、加湿和除湿，这些功能由一个或多个设计元素实现。例如，加热功能可以由以下设计元素实现：直接空气加热器、锅炉、工业热源、地热源和被动缓冲器。考虑到保护性栽培系统的设计，所提出的设计元素被认为具有足够的通用性，适用于世界各地的广泛地点。本地特定的能源生产、能量转换或气候调节解决方案，如热电联产发电机、人工光、主动蓄热器、热泵和太阳能集热器，不在本研究的范围之内。

![](images/abc841e1fd6acc0371d288819d737fed034eda1c27be12c2f0957045907ae19a.jpg)

图1. 温室设计方法所需的选定功能（彩色框）和设计元素（相应功能下方的文本块和图片），用于管理温室气候（温室内的透明框）。彩色箭头代表各种能量和质量通量（图例在右下角）。

# 2 模型概述和状态方程

# 2.1 符号约定

所有的状态变量、通量、输入、上标和下标都列在术语表中。所有的模型参数和温室设计参数分别列在表1和表2中。对于温室气候模型的状态变量和通量的描述，使用了 De Zwart (1996) 的符号约定。模型的状态变量由大写字母后跟一个下标表示，即 $T _ { A i r }$ 。模型通量以大写字母开头，后跟两个下标。第一个下标表示通量的来源，第二个下标表示通量的目的地，即 $H _ { C a n A i r }$ 。辐射通量以大写字母 $R$ 开头，后跟辐射类型，然后是两个下标，表示特定辐射的源和汇，即 RPAR_SunCan。

# 2.2 模型概述和假设

温室模型的状态、能量和质量通量的概述如图1所示。该模型基于以下假设：

1. 温室空气被视为一个“完全搅拌的容器”，这意味着温度、蒸汽压和 $\mathbf { C O } _ { 2 } .$ 浓度不存在空间差异。因此，所有模型通量都以每平方米温室地面为单位进行描述。
2. 为了描述保温幕对室内气候的影响，温室空气被分为两个隔间：一个在保温幕下方，一个在保温幕上方。

![](images/61389d65d737da9c1e4d11f61041d21f9c1c766ad78cfe9a86c7388d5a72ca8e.jpg)

图2. 温室模型的状态变量（方块）、半状态变量（虚线方块）、外部气候输入（圆形）和通量（箭头）的概述。彩色箭头代表各种能量和质量通量（图例在右下角）。缩写及其含义在术语表中列出，其基本方程在第2.3节中介绍。

# 2.3 模型的状态

模型的状态都由微分方程描述。状态对时间的导数用状态符号上方的点表示。所有符号都在术语表中定义。

### 2.3.1 不同温室物体的温度

冠层温度 $T _ { C a n }$ 由以下公式描述：

$$
\begin{array} { r l r } { c a p _ { _ { C a n } } \dot { T } _ { _ { C a n } } = R _ { _ { P i R _ { - } } > s u r c a n } + R _ { _ { N I R _ { - } } < s u r c a n } + R _ { _ { P i p e C a n } } } & { } & \\ { - \textbf { \textit { H } } _ { _ { C a n a i r } } - L _ { _ { C a n a i r } } - R _ { _ { C a n c o v , i n } } - R _ { _ { C a n c r i r } } - R _ { _ { C a n s i y } } - R _ { _ { C a n a i r i s c r } } } & { } & { [ \mathrm { W } \mathrm { m } ^ { - 2 } ] } \end{array}
$$

其中 $c a p _ { C a n }$ 是冠层的热容量，$R _ { P A R \_ S u n C a n }$ 是冠层吸收的PAR，$R _ { N I R \_ S u n C a n }$ 是冠层吸收的NIR。FIR在冠层与周围元素之间交换，即加热管 $R _ { P i p e C a n }$、内覆盖层 $R _ { C a n C o v , i n } .$、地面 $R _ { C a n F l r }$、天空 $R _ { C a n S k y }$ 和保温幕 RCanThScr。$H _ { C a n A i r }$ 是冠层与温室空气之间的显热交换，$L _ { C a n A i r }$ 是由蒸腾引起的潜热通量。

温室空气温度 $T _ { A i r }$ 由以下公式描述：

$$
\begin{array} { r l } & { c a p _ { A r } \dot { T } _ { A i r } = H _ { c a n A i r } + H _ { p _ { a d A i r } } + H _ { M e c h a i r } + H _ { P i p e A i r } + H _ { p _ { a s A i r } } + H _ { B o w A i r } + R _ { G l a b _ { - } S u n A i r } } \\ & { \phantom { c a p p c } - H _ { A i r R i r } - H _ { A i r n S c r } - H _ { A i r o u t } - H _ { A i r n p } - H _ { A i r o u t _ { - } P a d } - L _ { A i r e g } } \end{array} [ \mathrm { W } \mathrm { m } ^ { - 2 } ]
$$

其中 $c a p _ { A i r }$ 是温室空气的热容量。显热在温室空气与周围元素之间交换，即冠层 $H _ { C a n A i r }$、湿帘出口空气 $H _ { P a d A i r }$、机械冷却系统 $H _ { M e c h A i r . }$、加热管 $H _ { P i p e A i r ; }$、被动能量缓冲器 $H _ { P a s A i r }$、直接空气加热器 $H _ { B l o w A i r }$、地面 $H _ { A i r F l r }$、保温幕 $H _ { A i r T h S c r . }$、室外空气 $H _ { A i r O u t }$、位于保温幕上方的顶部隔间空气 $H _ { A i r T o p }$，以及由湿帘风扇系统引起的空气交换导致的室外空气 $H _ { A i r O u t \_ P a d }$。$R _ { G l o b \_ S u n A i r }$ 是被建筑构件吸收并释放到空气中的全球辐射，$L _ { A i r F o g } $ 是蒸发由喷雾系统添加的水滴所需的潜热。

地面层是温室地下的第一层，其温度 $T _ { F l r }$ 由以下公式描述：

$$
\begin{array} { r l } & { c a p _ { _ { F l r } } \dot { T } _ { _ { F l r } } = H _ { _ { A i r F l r } } + R _ { _ { P A R _ { - } S u n F l r } } + R _ { _ { N I R _ { - } S u n F l r } } + R _ { _ { C a n F l r } } + R _ { _ { P i p e F l r } } } \\ & { ~ - ~ H _ { _ { F l r S o 1 } } - R _ { _ { F l r C o v , i n } } ~ - ~ R _ { _ { F l r S k y } } ~ - ~ R _ { _ { F l r T h S c r } } } \end{array}
$$

[W m-2]

其中 $c a p _ { F l r }$ 是地面的热容量；$R _ { P A R \_ S u n F l r }$ 是地面吸收的PAR；$R _ { N I R \_ S u n F l r }$ 是地面吸收的NIR；RPipeFlr、RFlrCov,in、$R _ { F l r S k y }$ 和 $R _ { F l r T h S c r }$ 分别是地面与加热管、内覆盖层、天空和保温幕之间的FIR通量；$H _ { F l r S o 1 }$ 是从地面到土壤第1层的显热通量。

由于土壤的热容量很高，土壤被分为五层，厚度随土壤深度的增加而增加。第 $\mathbf { \omega } ^ { \ast } j ^ { \prime }$ 层的土壤温度 $T _ { S o ( j ) }$ 由以下公式描述：
$c a p _ { _ { S o } ( j ) } T _ { _ { S o } ( j ) } = H _ { _ { S o } ( j - 1 ) S o } ( _ { j } ) \cdot \ H _ { _ { S o } ( j ) S o } ( _ { j + 1 } ) \qquad j = 1 , 2 . . . . . 5$ $\mathrm { [w _ { m } \mathrm { \cdot } 2 ] }$ (4)
其中 $c a p _ { S o ( j ) }$ 是每层土壤的热容量，$H _ { S o ( j - 1 ) S o ( j ) }$ 是从层 $$ - $\mathbf { \nabla } _ { 1 } \cdot \mathbf { \nabla } _ { 1 } \cdot \mathbf { \varepsilon } _ { 1 } \cdot \mathbf { \varepsilon } _ { \mathrm { ~ } }$ 到 $\mathbf { \omega } ^ { \prime } j ^ { \prime }$ 的传导热通量，$H _ { S o ( j ) S o ( j + 1 ) }$ 是从层 $\mathbf { \omega } _ { j } ,$ 到 $\cdot _ { j + 1 } ,$ 的传导热通量。对于第一层土壤，$H _ { S o } ( \mathfrak { \_ { j - 1 } } ) _ { S o } ( \mathfrak { \_ { j } } )$ 等效于 $H _ { \scriptscriptstyle F l r S o 1 }$，对于最后一层土壤，$H _ { S o } ( _ { j } ) _ { S o } ( _ { j + 1 } )$ 等效于从第 $5$ 层土壤到恒定外部土壤温度的传导热通量 $H _ { s o 5 S o O u t }$，该通量由公式 (77) 描述。

保温幕的温度 $T _ { T h S c r }$ 由以下公式描述：
$\begin{array} { r l r l r } { c a p _ { \mathit { m s c r } } \dot { T } _ { \mathit { m s c r } } = H _ { \mathit { A i r T h S c r } } + L _ { \mathit { A i r T h S c r } } + R _ { \mathit { C a n T h S c r } } + R _ { \mathit { F i r T h S c r } } + R _ { \mathit { P i p e T h S c r } } } & { } & & { } \\ { - \textbf { \delta } H _ { \mathit { m s c r T o p } } - \textbf { \delta } R _ { \mathit { T h S c r C o v , i n } } - \textbf { \delta } R _ { \mathit { T h S c r S t y } } } & { } & & { \mathrm { [ W ~ n ~ m ~ m ~ m ~ a ~ ] } } \end{array}$

-2]

其中 $c a p _ { T h S c r }$ 是保温幕的热容量；$L _ { A i r T h S c r }$ 是由保温幕上冷凝引起的潜热通量；RPipeThScr、RThScrCov,in 和 RThScrSky 分别是保温幕与加热管、内覆盖层和天空之间的FIR通量；$H _ { T h S c r T o p }$ 是保温幕与顶部隔间空气之间的热交换。

保温幕上方隔间的空气温度 $T _ { T o p ; }$，在本研究中表示为“顶部隔间”，由以下公式描述：

$$
c a p _ { _ { I o p } } \dot { T } _ { _ { I o p } } = H _ { _ { T h S c r T o p } } + H _ { _ { A i r T D p } } - H _ { _ { T o p C o v , i n } } - H _ { _ { T o p O u t } }
$$

其中 $c a p _ { T o p }$ 是顶部隔间空气的热容量，$H _ { T o p C o v , i n }$ 是顶部隔间空气与内覆盖层之间的热交换，$H _ { T o p O u t }$ 是顶部隔间与室外空气之间的热交换。

温室覆盖层的导热性是一个温室设计参数，它可以在覆盖层上引起显著的温度梯度。因此，内覆盖层温度和外覆盖层温度都进行了建模。假设内、外覆盖层的热容量各占总覆盖层结构热容量的 $10 \%$，并假设能量传导是内、外覆盖层之间能量传输的主要方式，则内覆盖层温度 $T _ { C o v , i n }$ 和外覆盖层温度 $T _ { C o v , e }$ 由以下公式描述：

$\begin{array} { r } { \cdot a p _ { _ { C o v , i n } } \dot { T } _ { C o v , i n } = H _ { \mathit { T o p C o v , i n } } + L _ { \mathit { R p C o v , i n } } + R _ { \mathit { C a n C o v , i n } } + R _ { \mathit { F i r f c o v , i n } } + R _ { \mathit { P l e r c o v , i n } } + R _ { \mathit { T i n s t , i n } } - H _ { \mathit { C o p e , i n } } - R _ { \mathit { T o p e c h , i n } } - R _ { \mathit { C o p e , i n } } + R _ { \mathit { T o p e c h , i n } } - \frac { \delta } { \delta } \Pi _ { \mathit { C o p e , i n } } } \end{array}$

$$
\begin{array} { r l r l } & { } & { \qquad = \hat { \Gamma } _ { G o v , e m , e } \hat { T } _ { C o v , e } = R _ { G i o b , - S u n C o v , e } + H _ { C o v , i n C o v , e } - \hat { H } _ { C o v , e O u t } - R _ { C o v , e S u p } \hat { \Gamma } _ { C o v , e S u p } \qquad } & { \qquad [ \mathrm { W ~ m ^ { - 2 } } ] } \end{array}
$$

其中 $c a p _ { C o v , i n }$ 和 $c a p _ { C o v , e }$ 分别是内覆盖层和外覆盖层的热容量，$L _ { T o p C o v , i n }$ 是由温室覆盖物上冷凝引起的潜热通量，$R _ { P i p e C o v , i n }$ 是加热管和内覆盖层之间的FIR交换，$H _ { C o v , i n C o v , e }$ 是内、外覆盖层之间的热通量，$R _ { G l o b \_ S u n C o v , e }$ 是覆盖层吸收的全球太阳辐射，$H _ { C o v , e O u t }$ 是从外覆盖层到室外空气的显热通量，以及 $R _ { C o v , e S k y }$ 是覆盖层与天空之间的FIR交换。

在该模型中，除了使用直接空气加热器外，还可以使用热水加热管（图2）向温室空气中添加热能。加热管系统的表面温度 $T _ { P i p e }$ 由以下公式描述：

$$
\begin{array} { r } { c a p _ { { P i p e } } \dot { T } _ { { P i p e } } = H _ { { B o i l p i p e } } + H _ { { I n d P i p e } } + H _ { { G e o p i p e } } } \\ { - \textbf { \textsc { R } } _ { { P i p e S k y } } - \textbf { \textsc { R } } _ { { P i p e C o v , i n } } - \textbf { \textsc { R } } _ { { P i p e C a n } } - \textbf { \textsc { R } } _ { { P i p e F l r } } - \textbf { \textsc { R } } _ { { P i p e T h S e r } } - \textbf { \textsc { H } } _ { { P i p e A r k } } } \end{array}
$$

[W m-2]

其中 $c a p _ { P i p e }$ 是加热管的热容量，$H _ { B o i l P i p e }$ 是锅炉到管道的热通量，
$H _ { I n d P i p e }$ 是工业到管道的热通量，$H _ { G e o P i p e }$ 是地热到管道的热通量，以及 $R _ { P i p e S k y }$ 是管道与天空之间的FIR交换。

### 2.3.2 温室空气和顶部隔间空气的水蒸气压力

温室空气的水蒸气压力 $V P _ { A i r }$ 由以下公式描述：

$$
\begin{array}{c} \begin{array} { r l } & { c a p _ { _ { V P _ { A i r } } } \dot { V } P _ { _ { A i r } } = M V _ { _ { C a n A i r } } + M V _ { _ { P a d A i r } } + M V _ { _ { F o g a i r } } + M V _ { _ { B l o w A i r } } } \\ { - \ M V _ { _ { A i r n S c r } } - \ M V _ { _ { A i r n p } } \cdot \ m V _ { _ { A i r o u t } } - \ M V _ { _ { A i r o u t } _ { - } p _ { a d } } - \ M V _ { _ { A i r M e c h } } } \end{array} \qquad [ \mathrm { k g } \ \mathrm { m ^ { 2 } ~ s ^ { - 1 } } ]  \end{array}
$$

其中 capVPAir 是空气储存水蒸气的能力。水蒸气在空气与周围元素之间交换，即冠层 $M V _ { C a n A i r ; }$、湿帘出口空气 $M V _ { P a d A i r }$、喷雾系统 $M V _ { F o g A i r }$、直接空气加热器 $M V _ { B l o w A i r ; }$、保温幕 $M V _ { A i r T h S c r ; }$、顶部隔间空气 $M V _ { A i r T o p ; }$、室外空气 $M V _ { A i r O u t }$、由湿帘和风扇系统引起的空气交换导致的室外空气 $M V _ { A i r O u t \_ P a d }$，以及机械冷却系统 $M V _ { A i r M e c h }$。

顶部隔间空气的水蒸气压力 $\displaystyle { V P _ { T o p } }$ 由以下公式描述：
$c a p _ { { } _ { V P _ { D p } } } \dot { V } P _ { { } _ { T o p } } = M V _ { A i r T o p } \ - \ M V _ { { } _ { T o p C o v , i n } } \ - \ M V _ { { T o p O u t } }$ $[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]$ (11)
其中 $c a p _ { { { \scriptscriptstyle V P _ { T o p } } } }$ 是顶部隔间储存水蒸气的能力，$M V _ { T o p C o v , i n }$ 是顶部隔间与内覆盖层之间的水蒸气交换，以及 $M V _ { \mathit { T o p O u t } }$ 是顶部隔间与室外空气之间的水蒸气交换。

### 2.3.3 温室空气和顶部隔间空气的CO2浓度

温室空气的 $\mathrm { C O _ { 2 } }$ 浓度 $C O _ { 2 A i r }$ 由以下公式描述：

$$
\begin{array} { r } { c a p } { _ { C O _ { 2 A i r } } \dot { C } O _ { 2 A i r } = M C _ { _ { B l o w A i r } } + M C _ { _ { E x t a i r } } + M C _ { _ { P a d A i r } } } \\ { - \ M C _ { A i r C a n } \ - \ M C _ { _ { A i r T o p } } \ - \ M C _ { _ { A i r O u t } } } \end{array}
$$

$$
[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]
$$

其中 $c a p _ { C O _ { 2 A i r } }$ 是空气储存 $\mathrm { C O } _ { 2 }$ 的能力。二氧化碳在温室空气与周围元素之间交换，即直接空气加热器 $M C _ { B l o w A i r }$、外部 $\mathrm { C O } _ { 2 }$ 源 $M C _ { E x t A i r }$、湿帘和风扇系统 $M C _ { P a d A i r }$、顶部隔间空气 $M C _ { A i r T o p }$ 和室外空气 $M C _ { A i r O u t }$。$M C _ { A i r C a n }$ 是温室空气与冠层之间的 $\mathrm { C O } _ { 2 }$ 通量，如 Vanthoor et al. (Submitted) 所述。

顶部隔间空气的 $\mathrm { C O } _ { 2 }$ 浓度 $C O _ { 2 T o p }$ 由以下公式描述：
$c a p _ { { } _ { C O _ { 2 T o p } } } \dot { C } O _ { 2 T o p } = M C _ { { } _ { A i r T o p } } \cdot M C _ { { } _ { T o p O u t } }$ $[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]$ (13)
其中 $c a p _ { c o _ { 2 T o p } }$ 是顶部隔间空气储存 $\mathrm { C O } _ { 2 }$ 的能力，$M C _ { T o p O u t }$ 是顶部隔间空气与室外空气之间的 $\mathrm { C O _ { 2 } }$ 交换。

# 3 集总覆盖层

该模型包含四个覆盖层，即可移动的室外遮阳网、半永久性遮阳网、温室屋顶和可移动的室内保温幕。这些覆盖层对覆盖物的整体光学特性（即透射、反射和吸收系数）有综合影响。为简化模型，将四个覆盖层的各自属性集总在一起。关于集总覆盖层的假设如下：

所有四个覆盖层都影响温室的PAR、NIR和FIR的透射、反射和吸收   
半永久性遮阳网是屋顶上的一层涂层，因此它影响覆盖层的导热系数和热容量   
可移动的室外遮阳网通常具有开放结构，因此遮阳网下方的温度等于室外温度。因此，可移动的室外遮阳网不影响集总覆盖层的导热系数和热容量。   
使用室外遮阳网会影响通风流量系数。覆盖层的对流热交换系数不受使用一个或多个幕的影响。

这些假设意味着所有四个覆盖层的PAR、NIR和FIR的光学特性必须集总在一起。此外，集总覆盖层的导热系数和热容量取决于屋顶和半永久性遮阳网的导热系数和热容量。

覆盖层的PAR和NIR透射率是四个覆盖层的组合透射率。总覆盖层的PAR和NIR透射率根据EN 410标准（Anonymous, 1998）计算，首先确定前2层和后2层的透射和反射系数。其次，对这两个组合层计算总覆盖层的透射率。

双层覆盖物的透射系数 $\tau _ { 1 2 } \left( - \right)$ 和反射系数 $\rho _ { { } _ { 1 2 } } ( - )$ 根据EN 410标准（Anonymous, 1998）确定：

$$
\begin{array} { l } { \displaystyle \tau _ { { 1 2 } } = \frac { \tau _ { 1 } \tau _ { 2 } } { 1 - \rho _ { 1 } \rho _ { 2 } } } \\ { \displaystyle } \\ { \displaystyle \rho _ { { 1 2 } } = \rho _ { 1 } + \frac { { \tau _ { 1 } } ^ { 2 } \rho _ { 2 } } { 1 - \rho _ { 1 } \rho _ { 2 } } } \end{array}
$$

其中 $\tau _ { 1 } ( - )$ 和 $\tau _ { 2 } \left( - \right)$ 分别是第一层和第二层的透射系数，$\rho _ { 1 }$ $( - )$ 和 $\rho _ { { } _ { 2 } } ( - )$ 分别是第一层和第二层的反射系数。

下面给出了集总覆盖层PAR光学特性的计算示例。NIR的光学特性以类似的方式计算。首先，计算前2个覆盖层的透射系数和反射系数，以确定整个温室覆盖层的PAR透射系数和PAR反射系数。

前两层是可控的，因此可移动遮阳网和半永久性遮阳网的透射系数 $\tau _ { S h S c r \_ S h S c r P e r }$ 和反射系数 $\rho _ { s h S c r \_ S h S c r P e r }$ 由以下公式确定：

$$
\begin{array} { r l } & { \tau _ { _ { S h S C r \_ S h S c r P e r P a R } } = \frac { \left( 1 - \mathrm { \it ~ U } _ { S h S c r } \left( 1 - \mathrm { \it ~ \tau } _ { { S h S c r P e r R a R } } \right) \right) \left( 1 - \mathrm { \it ~ U } _ { S h S c r P e r } \left( 1 - \mathrm { \it ~ \tau } _ { _ { S h S c r P e r P e r R a R } } \right) \right) } { 1 - \mathrm { \it ~ U } _ { S h S c r P , \mit \left( { S h S c r P e r } \right) \left( { S h S c r P e r P } \right) \left( { S h S c r P e r P a R } \right. \right. } } } \\ & { \left. \left. \rho _ { _ { S h S c r \_ S h S c r P e r P a R } } - \frac { \left( 1 - \mathrm { \it ~ U } _ { S h S c r P e r P a R } \right) } { 1 - \mathrm { \it ~ U } _ { S h S c r P e r A R } \left. \left( 1 - \mathrm { \it ~ U } _ { S h S c r P e r P a R } \right. \right. } \right) ^ { \mathrm { \it ~ \it ~ \left. ~ \right. } } U _ { S h S c r P e...(line too long; chars omitted)
$$

其中 $U _ { s h S c r } \left( - \right)$ 是可移动遮阳网的控制参数，$U _ { s h S c r P e r } \left( - \right)$ 是半永久性遮阳网的控制参数，$\tau _ { _ { S h S c r P A R } } \left( - \right)$ 是可移动遮阳网的PAR透射系数，$\tau _ { S h S c r P e r P A R } \left( - \right)$ 是半永久性遮阳网的PAR透射系数，$\rho _ { s h S c r P A R } \left( - \right)$ 是可移动遮阳网的反射系数，以及 $\rho _ { s h S c r P e r P A R } \left( - \right)$ 是半永久性遮阳网的反射系数。

其次，最后两层覆盖物（即温室屋顶和保温幕）的透射系数和反射系数的计算与公式（16）和（17）类似。第三，通过代入两个组合层的透射和反射系数，使用公式（14）和（15）确定集总覆盖层的透射系数 $\tau _ { { C o v P A R } }$ 和反射系数 $\rho _ { _ { C o v P A R } }$。集总覆盖层的吸收系数 $a _ { G h P A R }$ 为1减去透射系数和反射系数之和。

集总覆盖层的FIR光学特性取决于半永久性遮阳网、可移动遮阳网和屋顶的FIR光学特性，其计算方式与PAR的光学特性类似。集总覆盖层的FIR发射系数 $\varepsilon _ { C o v F I R }$ (-)，等于FIR吸收系数 $\boldsymbol { a } _ { \mathit { C o v F I R } }$ 。

集总覆盖层的热容量由以下公式描述： $c a p _ { \varsigma o v } = \cos ( \psi ) \mathsf { U } _ { \mathit { s h s c r P e r } } \mathsf { h } _ { \mathit { s h s c r P e r } } \rho _ { \mathit { s h s c r P e r } } \rho _ { \mathit { s h s c r P e r } } c _ { p , \mathit { s h s c r P e r } } + \mathsf { h } _ { \mathit { R f } } \rho _ { \mathit { R f } } c _ { p , \mathit { R f } } \mathsf { ) } \qquad [ \mathrm { J ~ K } ^ { \cdot 1 } \mathrm { m } ^ { \cdot 2 } ]$ (18) 
其中 $\psi$ 是温室覆盖层的平均坡度 $( ^ { \circ } ) , U _ { S h S c r P e r } ( - )$ 是半永久性遮阳网的控制参数，hShScrPer (m) 是厚度，$\rho _ { { S h S c r P e r } } ~ ( \mathrm { k g } ~ \mathrm { m } ^ { - 3 } )$ 是密度，以及 $C _ { p , S h S c r P e r }$ $( \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { k g } ^ { - 1 } )$ 是半永久性遮阳网的比热容，$h _ { R f } ( \mathbf { m } )$ 是厚度，$\rho _ { _ { R f } }$ $\mathrm { { k g } \ m ^ { \cdot } }$ 3) 是密度，以及 $C _ { p , R f }$ $( \mathrm { J } \ \mathrm { K } ^ { - 1 } \ \mathrm { k g } ^ { - 1 } )$ 是屋顶层的比热容。

通过集总覆盖层的传导热通量取决于半永久性遮阳网和屋顶的厚度及导热系数：

$$
H E C _ { c o v , i n C o v , e } = \frac { 1 } { \displaystyle \frac { h _ { _ { R f } } } { \lambda _ { _ { R f } } } + U _ { _ { S h S c r P e r } } \ \frac { h _ { _ { S h S c r P e r } } } { \lambda _ { _ { S h S c r P e r } } } }
$$

# 4 Capacities

The heat capacity of the canopy, $c a p _ { C a n } ,$ is described by:   
$c a p _ { \scriptscriptstyle { C a n } } = c a p _ { \scriptscriptstyle { L e a f } } \mathrm { ~ } \cdot L A I$ $[ \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { m } ^ { - 2 } ]$ (1 where $c a p _ { L e a f } ( \mathrm { J ~ K ^ { - 1 } ~ m ^ { - 2 } } \mathrm { l e a f } )$ is the heat capacity of a square meter of canopy and LAI is the leaf area index $( \mathrm { m ^ { - 2 } l e a f m ^ { - 2 } } )$ .

The heat capacity of the external and internal cover is assumed to be $10 \%$ of the total heat capacity of the lumped cover and is therefore described by: $c a p _ { _ { C o v , e } } = c a p _ { _ { C o v , i n } } = 0 . 1 c a p _ { _ { C o v } }$ $[ \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { m } ^ { - 2 } ]$ where capCov $( \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { m } ^ { - 2 } )$ is the heat capacity of the lumped cover.

The heat capacity of the heating pipes is an aggregated heat capacity combining the heat capacity of the steel pipe and of the water inside the pipe: $c a p _ { { p _ { i p e } } } = 0 . 2 5 \ : \pi { l _ { p _ { i p e } } } ( { \{ { \phi _ { p _ { i p e } , e } } ^ { 2 } - { \phi _ { p _ { i p e } , i } } ^ { 2 } } \} _ { { \rho _ { S t e e l } } } { c _ { p , S t e e l } } \ : + { \phi _ { p _ { i p e } , i } } ^ { 2 } \rho _ { { w a t e r } } { c _ { p , W a t e r } } ) _ { [ \mathrm { J \ : K ^ { 1 } \ : m ^ { 2 } } ] } \ :$ (21) where $l _ { P i p e } ( \mathrm { m } \mathrm { m } ^ { - 2 } )$ is the length of the heating pipe per square meter greenhouse, $\phi _ { { P i p e } , e } ( \mathrm { m } )$ is the external diameter of the heating pipe, $\phi _ { { P i p e } , i } ( \mathrm { m } )$ is the internal diameter of the heating pipe, $\rho _ { s t e e l }$ (kg $\mathfrak { m } ^ { \cdot 3 \cdot }$ ) is the density of steel, $C _ { p , S t e e l }$ $( \mathrm { J ~ K ^ { - 1 } ~ k g ^ { - 1 } } )$ is the specific heat capacity of steel, $\rho _ { w a t e r }$ is the density of water $( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ and $C _ { p , W a t e r } ( \mathrm { J ~ K ^ { - 1 } ~ k g ^ { - 1 } } )$ is the specific heat capacity of water.

The heat capacity of the remaining greenhouse objects is described by $c a p _ { o b j } = h _ { o b j } \rho _ { o b j } c _ { p , O b j }$ $[ \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { m } ^ { - 2 } ]$ (22) where $h _ { o b j } ( \mathbf { m } )$ is the mean height of the greenhouse object, $\rho _ { o b j }$ $( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the density of the greenhouse object and $c _ { p , O b j } ( \mathrm { J } \mathrm { K } ^ { - 1 } \mathrm { k g } ^ { - 1 } )$ is the specific heat capacity of the object. The capacity of the objects, $c a p _ { A i r }$ , $c a p _ { { } _ { F l r } }$ , $c a p _ { s o ( j ) }$ , $c a p _ { \scriptscriptstyle { T h S c r } }$ and $c a p _ { \scriptscriptstyle T o p }$ are described in an similar way as Eq. (22).

The density of the air is elevation dependent and by assuming a mean air temperature of $2 0 { } ^ { \circ } \mathrm { C }$ the density of the air is calculated by:

$$
\rho _ { _ { A i r } } = \rho _ { _ { A i r 0 } } \exp \left( \frac { g M _ { _ { A i r } } h _ { _ { E l e v a t i o n } } } { 2 9 3 . 1 5 R } \right)
$$

where $\rho _ { A i r 0 } ( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the air density at sea level, $g ( \mathbf { m } \mathbf { \Lambda } ^ { s ^ { - 2 } } )$ , is the acceleration of gravity, $M _ { A i r }$ (kg $\mathrm { k m o l ^ { - 1 } }$ is the molar mass of air, hElevation (m) is the altitude of the greenhouse above sea level and $R$ (J $\mathrm { k m o l ^ { - 1 } K ^ { - 1 } }$ is the molar gas constant.

The conversion factor from the water vapour pressure to the water vapour mass per square metre greenhouse of the air compartment below the thermal screen is described by a water vapour capacity of the air compartment:

$$
c a p _ { { _ { V P _ { A i r } } } } = \frac { M _ { { _ { W a t e r } } } h _ { _ { A i r } } } { R ( T _ { A i r } + 2 7 3 . 1 5 ) }
$$

$$
[ \mathrm { k g } \mathrm { m } ^ { 3 } \mathrm { J } ^ { - 1 } ]
$$

where $M _ { W a t e r } ( \mathrm { k g } \mathrm { k m o l ^ { - 1 } } )$ is the molar mass of water, $h _ { A i r } ( \mathbf { m } )$ is the height from the floor to the thermal screen, $R \ \mathrm { ( J \ k m o l ^ { - 1 } \ K ^ { - 1 } ) }$ is the molar gas constant. The water vapour capacity of the top compartment, $c a p _ { { { \scriptscriptstyle V P _ { T o p } } } }$ , is described with a similar equation as Eq. (24).

The conversion factor from the $\mathrm { C O _ { 2 } }$ concentration of the air compartment below the thermal screen to the $\mathrm { C O } _ { 2 }$ mass per square meter greenhouse, $c a p _ { C O _ { 2 A i r } }$ (m), equals the height from the floor to the thermal screen, $h _ { A i r }$ . The conversion factor from the $\mathrm { C O _ { 2 } }$ concentration of the top compartment to the $\mathrm { C O } _ { 2 }$ mass per square metre greenhouse, $c a p _ { C O _ { 2 T o p } }$ (m), equals the mean height of the greenhouse minus the height from the floor to the thermal screen.

5 Heat fluxes

# 5.1 Global, PAR and NIR heat fluxes

The PAR absorbed by the canopy $( R _ { P A R \_ S u n C a n } )$ is the sum of the PAR transmitted by the greenhouse cover that is directly absorbed by the canopy $( R _ { P A R \_ S u n C a n \downarrow } )$ , and the PAR that is first reflected by the greenhouse floor and then is absorbed by the canopy $( { { R } _ { P A R \_ F l r C a n \uparrow } }$ ): $R _ { \scriptscriptstyle P A R \_ S u n C a n } = R _ { \scriptscriptstyle P A R \_ S u n C a n \downarrow } + R _ { \scriptscriptstyle P A R \_ F l r C a n \uparrow }$ $[ \mathrm { W ~ m ^ { - 2 } } ]$

The PAR which is directly absorbed by the canopy is described by a negative exponential decay of light with LAI in a homogeneous crop (Ross, 1975): $R _ { \scriptscriptstyle { R A R \_ S u n C a n \downarrow } } = R _ { \scriptscriptstyle { R A R \_ G h } } \cdot \left( 1 - \rho _ { \scriptscriptstyle { C a n P A R } } \right) . \left\{ 1 - e ^ { - K _ { 1 \_ P A R } \cdot L A I } \right)$ $\mathrm { [ w _ { m } \mathrm { \overline { { \Omega } } ] } }$ where $R _ { p A R \_ G h } \ ( \mathrm { W \ m ^ { - 2 } } )$ is the PAR above the canopy, $\rho _ { C a n P A R } \left( - \right)$ is the reflection coefficient of the canopy for PAR and $K _ { 1 \_ P A R } \left( - \right)$ is the extinction coefficient of the canopy for PAR.

The PAR above the canopy is described by: $R _ { _ { P A R \_ G h } } = \left( \mathbb { 1 } - \eta _ { _ { G I o b \_ A i r } } \right) \cdot \tau _ { _ { C o v P A R } } \cdot \eta _ { _ { G I o b \_ P A R } } \cdot I _ { _ { G I o b } }$ $\mathrm { [ w _ { m } \mathrm { \cdot } 2 ] }$ (27) where $\eta _ { G l o b \_ A i r } ( - )$ is the ratio of the global radiation which is absorbed by the greenhouse construction elements, $\tau _ { { C o v P A R } } \left( - \right)$ is the PAR transmission coefficient of the greenhouse cover, $\eta _ { G l o b \_ P A R }$ is the ratio between PAR and the global radiation and $I _ { G l o b } ( \mathrm { W } \mathrm { m } ^ { - 2 } )$ is the outside global radiation. The PAR transmission of the cover depends on the PAR transmission of the following design elements: the roof, a semi-permanent cover additive, the movable shading screen and the movable thermal screen (Section 3).

The PAR that is absorbed by the canopy after reflection by the greenhouse floor is described by:

$$
R _ { _ { P A R \_ F i r C a n \ } } = R _ { _ { P A R \_ G h } } \cdot e ^ { \cdot K _ { _ 1 \_ R A R } \cdot A A I } \cdot \rho _ { _ { F l r P A R } } \cdot ( 1 - \rho _ { _ { C a n P A R } } ) . ( 1 - e ^ { - K _ { _ 2 \_ R A R } \cdot A A I } )
$$

[W m-2]

where $\rho _ { F l r P A R } ( - )$ is the reflection coefficient of the greenhouse floor for PAR and $K _ { 2 \_ P A R }$ (-) is the extinction coefficient for PAR that is reflected from the floor to the canopy.

The NIR reflection coefficient of the canopy is considerably higher than the PAR reflection coefficient. Consequently, a large amount of the NIR is either reflected by the canopy back to the greenhouse cover or is scattered through the canopy to the greenhouse floor. The greenhouse cover and greenhouse floor may reflect the NIR back into the greenhouse again leading to a considerable scattering of NIR in the greenhouse. Because the NIR reflection coefficient of both the cover and floor are greenhouse design parameters, the NIR fluxes in the greenhouses model account for all these reflections.

The NIR absorbed by the canopy and by the floor was determined by considering the lumped cover, the canopy and the floor as a multiple layer model. To assure that the NIR absorption coefficient determined by this multiple-layer model equals the overall NIR absorption coefficient of the canopy, virtual NIR transmission coefficients of the lumped cover and floor were used:

$$
\begin{array} { r } { \stackrel { \bigcup } { \tau } _ { C o v N I R } = 1 - \mathrm { ~ } \rho _ { C o v N I R } } \\ { \stackrel { \prod } { \tau } _ { F l r N I R } = 1 - \mathrm { ~ } \rho _ { F l r N I R } } \end{array}
$$

To solve the multiple-layer model, first the transmission and reflection coefficient for NIR of the canopy must be determined. Using the relationship between the LAI and the diffuse NIR absorption by the canopy of De Zwart  (1996), the NIR transmission coefficient of the canopy is described by:

$$
\frac { \mathsf { U } } { \tau _ { C a n N i r } } = e ^ { - K _ { N I R } \cdot L A I }
$$

where $\frac { \sqcup } { \tau _ { C a n N i r } }$ (-) is the NIR transmission coefficient of the canopy and $K _ { N I R }$ is the extinction coefficient of the canopy for NIR (-). The NIR reflection coefficient of the canopy depends on the LAI which is described by:

$$
\overset { \sqcup } { \rho } _ { C a n N I R } = \rho _ { C a n N I R } ( 1 - \overset { \sqcup } { \tau } _ { C a n N i r } )
$$

The NIR transmission, reflection and absorption coefficients of the multiple-layers are determined by implementing the NIR transmission and reflection coefficients of the individual layers in the multiple-layer model in a similar way as Eqs. (14)-(17). Subsequently, the calculated absorption coefficient of the multiple-layers equals the overall NIR absorption coefficient of the canopy aCanNIR and the calculated transmission coefficient of the multiple-layers equals the overall NIR absorption coefficient of the floor, $\boldsymbol { a } _ { F l r N I R }$ .

The NIR absorbed by the canopy and by the floor is described by: $\begin{array} { r l } { R _ { _ { N I R _ { - } S u n C a n } } = \rvert \rvert - \eta _ { _ { G l o b \_ A i r } } \rvert . _ { G _ { C a n N I R } } \cdot \eta _ { _ { G l o b \_ N I R } } \cdot I _ { _ { G l o b } } } \\ { R _ { _ { N I R _ { - } S u n F l r } } = \rvert \rvert - \eta _ { _ { G l o b \_ A i r } } \rvert . _ { G _ { F l r N I R } } \cdot \eta _ { _ { G l o b \_ N I R } } \cdot I _ { _ { G l o b } } } \end{array}$ $\mathrm { [ w _ { m ^ { - 2 } } ] }$ $[ \mathrm { W ~ m ^ { - 2 } } ]$

The PAR absorbed by the greenhouse floor is described by: $R _ { \scriptscriptstyle P A R \_ S u n F l r } = \bigr ( 1 - \rho _ { \scriptscriptstyle F l r P A R } \bigr ) \cdot e ^ { - K _ { \scriptscriptstyle 1 \_ P A R } \cdot L A I } \cdot R _ { \scriptscriptstyle P A R \_ G h }$ $\mathrm { [ w _ { m } \mathrm { \overline { { \Omega } } ] } }$

It was assumed that the global radiation which is absorbed by the greenhouse construction elements is directly released to the greenhouse air:

$$
R _ { G l o b \_ S u n A i r } = \eta _ { _ { G l o b \_ A i r } } I _ { G l o b } \{ \tau _ { C o v p A R } \eta _ { _ { G l o b \_ R i R } } + ( q _ { _ { C a n N I R } } + a _ { _ { F l r N I R } } ) \eta _ { _ { G l o b \_ N I R } } \}
$$

The global solar radiation that is absorbed by the cover, $R _ { G l o b \_ S u n C o v , e ; }$ is described by: $R _ { _ { G I o b \_ S u n C o v , e } } = ( a _ { _ { G h P A R } } \cdot \eta _ { _ { G I o b \_ P A R } } + a _ { _ { G h N I R } } \cdot \eta _ { _ { G I o b \_ N R } } ) I _ { _ { G I o b \_ R I o b } }$ $[ \mathrm { W ~ m ^ { - 2 } } ]$ (36) where $a _ { G h P A R } \left( - \right)$ is the PAR absorption coefficient of the greenhouse cover, $a _ { G h N I R } \ : ( - )$ is the NIR absorption coefficient of the greenhouse cover. Both absorption coefficients are determined in Section 3.

# 5.2 FIR heat fluxes

The net far infrared radiation fluxes from surface $\mathbf { \epsilon } _ { \mathcal { \hat { \imath } } } \mathbf { \epsilon } _ { \mathcal { \tilde { \imath } } } ,$ to $\mathbf { \omega } _ { j } ,$ , $F I R _ { i j }$ are described by:

$$
F I R _ { i j } = A _ { i } \varepsilon _ { i } \varepsilon _ { j } F _ { i j } \sigma  { \big ( } ( _ { T _ { i } } + 2 7 3 . 1 5 { \big ) } ^ { 4 } - ( _ { T _ { j } } + 2 7 3 . 1 5 { \big ) } ^ { 4 } { \big ) }
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

where $A _ { i } ( \mathbf { m } ^ { 2 } \mathbf { m } ^ { - 2 } )$ is the surface of object $\mathbf { \epsilon } _ { \mathcal { \hat { \imath } } } \mathbf { \epsilon } _ { \mathcal { \tilde { \imath } } } ,$ per square meter greenhouse soil, $\varepsilon _ { i } \left( - \right)$ and $\varepsilon _ { j } ( - )$ are the thermal infrared emission coefficients for object $\mathbf { \epsilon } _ { \mathcal { \hat { \mathbf { l } } } } \mathbf { \prime } _ { \mathbf { \lambda } }$ and $\mathbf { \omega } ^ { \ast } j ^ { \prime }$ respectively, $F _ { i j }$ (-)is the view factor from object $\mathbf { \epsilon } _ { \mathcal { \hat { \mathbf { l } } } } \mathbf { \prime } _ { \mathbf { \lambda } }$ to $\cdot j ^ { \prime } , \sigma \ ( \mathrm { W \ m ^ { - 2 } \ K ^ { - 4 } } )$ is the Stefan Boltzmann constant, $T _ { i } ( ^ { \circ } \mathrm { C } )$ and $T _ { j } ( ^ { \circ } \mathrm { C } )$ are the

temperatures of object $\mathbf { \epsilon } _ { \mathcal { \dot { l } } } \mathbf { \epsilon } _ { \mathcal { \dot { l } } } ,$ and $\mathbf { \omega } _ { j } ,$ respectively. Table 3 shows the equations of $A _ { i }$ and $F _ { i j }$ for all the FIR fluxes based upon De Zwart (1996). These FIR fluxes are only valid in a greenhouse where the heating pipes are located below the canopy.

The accompanying emission coefficients are shown in Table 1. Some cover materials are partly transparent for FIR. Therefore, the FIR fluxes from the greenhouse objects (canopy, heating pipe and floor) to the sky are described. To describe the effect of the thermal screen on the FIR fluxes, FIR transmission coefficient is used which depends on the control of the thermal screen and on the physical properties of the thermal screen:

$$
\tau _ { \scriptscriptstyle T h S c r T I R } ^ { \scriptscriptstyle U } = 1 - U _ { \scriptscriptstyle T h S c r T I R } )
$$

# 5.3 Convection and conduction

Convective and conductive heat fluxes are described by:

$$
H _ { _ { 1 2 } } = H E C _ { _ { 1 2 } } ( T _ { _ { 1 } } - T _ { _ { 2 } } )
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

where $H _ { 1 2 } ( \mathrm { { W } \thinspace { m } ^ { - 2 } ) }$ is the heat flow from object 1 to object 2, $H E C _ { 1 2 }$ ( $\mathrm { ~ W ~ m ^ { - 2 } ~ K ^ { - 1 } ) }$ is the heat exchange coefficient between object 1 and 2, $T _ { 1 }$ is the temperature of object 1 and $T _ { 2 }$ is the temperature of object 2. All the convective and conductive heat fluxes and their heat exchange coefficients are presented in Table 4.

The natural ventilation flows $f _ { v e n t S i d e }$ and $f _ { \scriptscriptstyle { V e n t R o o f } }$ presented in Table 4 are described in Section 9.7 and the forced ventilation flow $f _ { v e n t F o r c e d }$ , is described in Section 9.8. The air flux rate through the thermal screen $f _ { \scriptscriptstyle T h S c r }$ $( \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \boldsymbol { \mathrm { s } } ^ { - 1 } )$ is based on  (De Zwart, 1996) and is described by:

$$
f _ { m s c r } = U _ { m s c r } K _ { m s c r } \big | T _ { A i r } ~ - ~ T _ { o u t } \big | ^ { 0 . 6 6 } + \frac { 1 - ~ U _ { m s c r } } { \rho _ { A r } ^ { M e a n } } \big ( 0 . 5 \rho _ { A i r } ^ { M e a n } \big ( 1 - U _ { m s c r } \big ) g \big | \rho _ { A i r } ~ - ~ \rho _ { O u t } \big | \big ) ^ { 0 . 5 }
$$

[m3 m-2 s-1]

where $K _ { \mathit { T h S c r } } ( \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { K } ^ { - 0 . 6 6 } \mathbf { s } ^ { - 1 } )$ is the screen flux coefficient which determines the permeability of the screen, $g ( \mathfrak { m } s ^ { - 2 } )$ is the gravitational acceleration, $\rho _ { A i r } ( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the density of the greenhouse air,

$\rho _ { o u t } ( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the density of the outdoor air and $\rho _ { A i r } ^ { M e a n }$ $( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the mean density of the greenhouse and the outdoor air.

# 5.4 Latent heat fluxes

The latent heat flux is the energy which is exchanged when water becomes water vapour (canopy transpiration) or when water vapour becomes water (condensation). The latent heat flux is linearly related with its associated vapour flux:

$$
L _ { \scriptscriptstyle { 1 2 } } = \Delta H \cdot M V _ { \scriptscriptstyle { 1 2 } }
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

where $L _ { 1 2 } ( \mathsf { W } \thinspace \mathrm { m } ^ { - 2 } )$ is the latent heat flux from object 1 to object 2, $\Delta H \left( \mathbf { J } \mathbf { k g } ^ { - 1 } \right.$ water) is the heat of evaporation and $M V _ { \mathrm { 1 2 } }$ $( \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } )$ is the vapour flux from object 1 to object 2.

The latent heat fluxes, $L _ { c a n A i r }$ , $L _ { A i r T h S c r }$ and $L _ { { _ { T o p C o v , i n } } }$ are described analogously to Eq.  (41), their accompanying vapour fluxes are described in Section 6 and 8.

The vapour exchange coefficient between the air and an object is linearly related to the convective heat exchange coefficient between the air and the object. Therefore, the vapour flux from the air to an object by condensation is described by:

$$
M V _ { 1 2 } = \left\{ \begin{array} { l l } { { 0 } } & { { \qquad V P _ { 1 } < V P _ { 2 } } } \\ { { 6 . 4 \cdot 1 0 ^ { - 9 } H E C _ { 1 2 } ( V P _ { 1 } - V P _ { 2 } ) } } & { { \qquad V P _ { 1 } > V P _ { 2 } } } \end{array} \right.
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

where $M V _ { \scriptscriptstyle { 1 2 } }$ $( \mathrm { k g } \mathrm { m } ^ { - 2 } \mathsf { s } ^ { - 1 } )$ is the vapour flux from air of location 1 to object 2, $\cdot 1 0 ^ { - 9 }$ is the conversion factor relating the heat exchange coefficient $( \mathrm { W } \mathrm { m } ^ { - 2 } \mathrm { K } ^ { - 1 }$ ) to the vapour exchange coefficient $( \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } \ P a ^ { - 1 } } )$ , $H E C _ { 1 2 } ( \mathrm { W } \mathrm { m } ^ { - 2 } \mathrm { K } ^ { - 1 } )$ is the heat exchange coefficient between the air of location 1 to object 2 and $V P _ { \mathrm { 1 } } ( \mathrm { P a } )$ is the vapour pressure of the air of location 1 and $\boldsymbol { V P _ { 2 } }$ (Pa) is the saturated vapour pressure of object 2 at its temperature.

Because the model should consist of only differentiable equations, Eq. (42) was smoothed using a differentiable ‘switch function’ to yield:

$$
M V _ { 1 2 } = { \frac { 1 } { 1 + \exp ( \mathsf { \bar { c } } _ { _ { M V _ { 1 2 } } } ( V P _ { 1 } - V P _ { 2 } ) ) } } 6 . 4 \cdot 1 0 ^ { - 9 } H E C _ { 1 2 } ( V P _ { 1 } - V P _ { 2 } ) \qquad [ \mathrm { k g } \mathrm { m ^ { - 2 } s ^ { - 1 } } ]
$$

where ${ { S } _ { M } } _ { { { V } _ { 1 2 } } } \left( - \right)$ is the slope of the differentiable switch function for vapour pressure differences.

The vapour flux from the greenhouse air compartment to the thermal screen, $M V _ { A i r T h S c r }$ and the vapour flux from the top compartment to the internal cover layer, $M V _ { \mathit { T o p C o v , i n } }$ , are described analogously to Eq. (42). Their associated heat exchange coefficients are listed in Table 4.

The general form of a vapour flux accompanying an air flux is described by:

$$
M V _ { \scriptscriptstyle 1 2 } = \frac { M _ { w a t e r } } { R } f _ { \scriptscriptstyle 1 2 } \left( \frac { V P _ { \scriptscriptstyle 1 } } { T _ { \scriptscriptstyle 1 } + 2 7 3 . 1 5 } - \frac { V P _ { \scriptscriptstyle 2 } } { T _ { \scriptscriptstyle 2 } + 2 7 3 . 1 5 } \right)
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

where $M V _ { \mathrm { 1 2 } }$ is the vapour flux from location 1 to location 2, $f _ { 1 2 } ( \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { s } ^ { - 1 } )$ is the air flux from location 1 to location 2, $T _ { 1 }$ ${ } ^ { \mathrm { { \circ } } } \mathrm { { C } } )$ is the temperature at location 1 and $T _ { 2 }$ ${ } ^ { \circ } \mathrm { C } )$ is the temperature at location 2.

The vapour fluxes, $M V _ { A i r T o p }$ , $M V _ { A i r O u t }$ and $M V _ { \mathit { t o p o u t } }$ are described analogously to Eq. (44) whereby their accompanying air fluxes are $f _ { \scriptscriptstyle T h S c r }$ (the flux through the thermal screen), $f _ { v e n t S i d e } + f _ { v e n t F o r c e d }$ (the flux due to natural ventilation through the side windows or forced ventilation) and $f _ { v e n t R o o f }$ (flux due to roof ventilation) respectively.

# 7 $\mathrm { C O } _ { 2 }$ fluxes

The general form of a $\mathrm { C O } _ { 2 }$ flux accompanying an air flux is described by:

$$
M C _ { 1 2 } = f _ { 1 2 } ( { C O } _ { 2 , 1 } - { C O } _ { 2 , 2 } )
$$

$$
[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]
$$

where $M C _ { \scriptscriptstyle { 1 2 } }$ is the $\mathrm { C O } _ { 2 }$ flux from location 1 to location 2, $f _ { 1 2 } ( \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { s } ^ { - 1 } )$ is the air flux from location 1 to location 2, $C O _ { 2 , 1 } ( \mathrm { m g } \mathrm { m } ^ { - 3 } )$ is the $\mathrm { C O } _ { 2 }$ -concentration at location 1 and $C O _ { 2 , 2 } ( \mathrm { m g } \mathrm { m } ^ { - 3 } )$ is the $\mathrm { C O } _ { 2 } .$ - concentration at location 2. The $\mathrm { C O } _ { 2 }$ fluxes, $M C _ { A i r T o p }$ , $M C _ { A i r O u t }$ and $M C _ { \mathit { \mathrm { { r o p o u t } } } }$ are described analogously to Eq. (45) whereby their accompanying air fluxes are $f _ { \mathit { T h S c r } } , f _ { \mathit { V e n t S i d e } } + f _ { \mathit { V e n t F o r c e d } }$ and respectively.

The net $\mathrm { C O } _ { 2 }$ flux from the air to the canopy $M C _ { A i r C a n }$ depends on the canopy photosynthesis rate and respiration processes which were described by Vanthoor et al  (Submitted).

# 8 Canopy transpiration

The canopy transpiration is described by:

$$
M V _ { _ { C a n A i r } } = V E C _ { _ { C a n A i r } } ( V P _ { _ { C a n } } \cdot V P _ { _ { A i r } } )
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

where $V E C _ { C a n A i r } ( \mathrm { k g } \mathrm { P a } \mathrm { s } ^ { - 1 } )$ is the vapour exchange coefficient between the canopy and air, $V P _ { C a n }$ is the saturated vapour pressure at canopy temperature. According to Stanghellini (1987) the vapour transfer coefficient of the canopy transpiration can be calculated by:

$$
V E C _ { c a n A i r } = { \frac { 2 \rho _ { A i r } c _ { p , A i r } L A I } { \Delta H y ( r _ { b } + r _ { s } ) } }
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ P a ^ { - 1 } \mathsf { s } ^ { - 1 } } ]
$$

where $\rho _ { A i r } ( \mathrm { k g } \mathrm { m } ^ { - 3 } )$ is the density of the greenhouse air, $c _ { p A i r } ( \mathbf { J } \mathbf { K } ^ { - 1 } \mathbf { k g } ^ { - 1 } )$ is the specific heat capacity of the greenhouse air, $L A I ( \mathbf { m } ^ { 2 } \mathbf { m } ^ { - 2 } )$ is the leaf area index, $\Delta H ( \mathrm { J } \log ^ { - 1 } )$ is the latent heat of evaporation of water, $\gamma ( \mathrm { P a } \ K ^ { - 1 } )$ is the psychometric constant, $r _ { b } \left( \mathrm { s } \mathrm { m } ^ { - 1 } \right)$ is the boundary layer resistance of the canopy for vapour transport and $r _ { s } ( \mathsf { s m } ^ { - 1 } )$ is the stomatal resistance of the canopy for vapour transport.

The boundary layer resistance for vapour transport depends on the wind speed in the greenhouse and the temperature difference between the canopy and surrounding air (Stanghellini, 1987).  However, the wind speed in the greenhouse is not measured nor simulated and therefore a constant boundary layer resistance was used. The stomatal resistance of the canopy is described by a simplification of the stomatal resistance model of  Stanghellini (1987) :

$$
r _ { s } = r _ { s , \mathrm { m i n } } \cdot r f ( R _ { _ { C a n } } ) . . r f ( C O _ { _ { 2 A i r _ { - } p p m } } ) . . r f ( \psi P _ { _ { C a n } } - \psi P _ { _ { A i r } } )
$$

$$
\mathrm { [ s \ m ^ { - 1 } ] }
$$

where $r _ { s , \mathrm { m i n } } ( s \ \mathrm { m ^ { - 1 } } )$ is the minimum canopy resistance and $r f$ is the resistance factor for high radiation levels, high $\mathrm { C O } _ { 2 }$ levels and large vapour pressure differences.  The resistance factors are described according to Stanghellini (1987):

$$
\begin{array} { l } { { r f } { { \left( { { R } _ { _ { C a n } } } \right) } = \frac { { { R } _ { _ { C a n } } } \mathrm { ~ + ~ } { { c } _ { e v a p 1 } } } { { { R } _ { C a n } } \mathrm { ~ + ~ } { { c } _ { e v a p 2 } } } } } \\ { { \mathrm { } _ { r f } } { { \left( { { C O } _ { _ { 2 A i r } } } \right) } = 1 + { { c } _ { e v a p 3 } } { { \left( { { \eta } _ { _ { m g \_ p o m } } } \cdot { { C O } _ { _ { 2 A i r } } } \mathrm { ~ - ~ } 2 0 0 \right)}  } ^ { \mathrm { { z } } } } } \\ { { \mathrm { } _ { r f } } { { \left( { V { P } _ { _ { C a n } } } \cdot { { V P } _ { _ { A i r } } } \right) } = 1 + { { c } _ { e v a p 4 } } { { \left( { V { P } _ { _ { C a n } } } \cdot { { V P } _ { _ { A i r } } } \right) } ^ { \mathrm { { z } } } } } } \end{array}
$$

where $R _ { C a n } ( \mathrm { W ~ m ^ { - 2 } } )$ is the global radiation above the canopy, $c _ { e v a p 1 } ( \mathbf { W _ { \rho } } \mathbf { m } ^ { - 2 } ) , c _ { e v a p 2 } ( \mathbf { W _ { \rho } } \mathbf { m } ^ { - 2 } ) , c _ { e v a p 3 }$ $\mathrm { ( p p m ^ { - 2 } ) } \ c _ { e v a p 4 } \ : ( \mathrm { P a ^ { - 2 } ) }$ are empirically determined parameters and $\eta _ { m g \_ p p m } \left( \mathrm { p p m } \ : \mathrm { m g ^ { - 1 } } \ : \mathrm { m ^ { 3 } } \right)$ is the conversion factor from $\mathrm { \Omega \ n g \ m ^ { - 3 } C O _ { 2 } }$ to ppm. Stanghellini limited the resistance factor for high $\mathrm { C O } _ { 2 }$ levels to 1.5 and the resistance factor for large vapour pressure differences to 5.8 and determined the transpiration variables $C _ { e v a p 3 }$ and $C _ { e v a p 4 }$ for day time and night time. The values of the transpiration parameters and $C _ { e v a p 4 }$ differed between the night period and day period which means that the accompanying equations are not differentiable at sunrise and sunset. Therefore the parameters $C _ { e v a p 3 }$ and $C _ { e v a p 4 }$ were smoothed to make Eq. (49) differentiable using the differentiable switch function:

$$
S _ { r _ { s } } = \frac { 1 } { 1 + \exp ( { \zeta _ { r _ { s } } } ( R _ { C a n } - R _ { C a n \_ S P } ) ) }
$$

where $S _ { r _ { s } } ( - )$ is the value of the differentiable switch, $S _ { r _ { s } } ( \mathrm { m } \ W ^ { - 2 } )$ is the slope of the differentiable switch for the stomatal resistance model and $R _ { C a n \_ S P } ( \mathrm { W } \mathrm { m } ^ { - 2 } )$ is the radiation value above the canopy to define sunrise and sunset. Using the differential switch, the smoothed transpiration parameters were described by:

$$
c _ { e v a p 3 } = c _ { e v a p 3 } ^ { n i g h t } \left( 1 - \textit { S } _ { r _ { s } } \right) + c _ { e v a p 3 } ^ { d a y } { S } _ { r _ { s } }
$$

The parameter $C _ { e v a p 4 }$ was described analogously to parameter $C _ { e v a p 3 }$ .

# 9 Greenhouse design elements

The design elements presented in Fig. 1 are described in this section. All the control inputs, $U _ { : }$ , have a control range from zero to one.

# 9.1 Direct air heater

The heat flux from the direct air heater to the greenhouse air is described by:

$$
H _ { { } _ { B l o w A i r } } = U _ { { } _ { B l o w } } P _ { { } _ { B l o w } } / A _ { { } _ { F l r } }
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

where $U _ { B l o w }$ is the control valve of the direct air heater $( - ) , P _ { _ { B l o w } } ( \mathbf { W } )$ is the heat capacity of the direct air heaters and $A _ { F l r } ( \mathbf { m } ^ { 2 } )$ is the surface of the greenhouse floor.

The $\mathrm { C O } _ { 2 }$ flux from the heat blower to the greenhouse air is proportional to the heat flux: $M C _ { B l o w A i r } = \eta _ { H e a t C O _ { 2 } } H _ { B l o w A i r }$ $[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]$ (53) where $\eta _ { H e a t C O _ { 2 } } ( \mathrm { m g C O _ { 2 } J ^ { - 1 } } )$ is the amount of $\mathrm { C O } _ { 2 }$ which is released when 1 Joule of sensible energy is produced by the direct air heater.

The vapour flux from the heat blower to the greenhouse air is proportional to the heat flux: $M V _ { \substack { _ { B l o w A i r } } } = \eta _ { \substack { _ { H e a t V a p } } } H _ { \substack { _ { B l o w A i r } } }$ $[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]$ where $\eta _ { H e a t V a p } ( \mathrm { k g \ v a p o u r \ J ^ { - 1 } ) }$ is the amount of vapour which is released when 1 Joule of sensible energy is produced by the direct air heater..

9.2 Heat from a boiler and from industrial and/or geothermal sources

The heat flux from the boiler to the heating pipe is described by:

$$
H _ { { _ { B o i l P i p e } } } = U _ { { _ { B o i l } } } P _ { { _ { B o i l } } } \mathrm { ~ / ~ } A _ { { _ { F l r } } }
$$

where $U _ { B o i l }$ is the control valve of the heat boiler (-), $P _ { B o i l }$ (W) is the heat capacity of the boiler and $A _ { F l r }$ $( \mathrm { m } ^ { 2 } )$ is the surface of the greenhouse floor. The heat flux to the heating pipes from an industrial source $H _ { _ { I n d P i p e } }$ and the geothermal source $H _ { G e o P i p e }$ are described analogously to Eq. (55).

# 9.3 Passive heat storage

In this study, passive heat storage was considered to be a facility that could store durable heat coming  from  the  sun.  The  most  important  design  parameters  of  such  a  passive  heat  storage mechanisms are modelled by assuming that a soil layer represents the passive heat buffer. The heat flux from the buffer to the greenhouse air, $H _ { p a s A i r }$ , depends on the heat exchange coefficient of the passive heat storage facility and the temperature difference between the passive heat buffer and the greenhouse air:

$$
H _ { _ { P a s A i r } } = H E C _ { _ { P a s A i r } } ( T _ { _ { S o 3 } } - T _ { _ { A i r } } )
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

where $H E C _ { P a s A i r }$ is the convective heat exchange coefficient between soil layer three and the greenhouse air temperature, $T _ { S o 3 }$ is the temperature of the third soil layer and $T _ { A i r }$ is the greenhouse air temperature.  Soil layer three was selected as a passive heat buffer because the temperature of this layer has a time delay of about 12 hours with respect to the greenhouse air, due to temperature oscillations in the soil on a 24 hour base, which favours the efficiency of the passive heat storage.

# 9.4 Pad and fan cooling

The vapour flux from the pad and fan to the greenhouse air is described by:

$$
\begin{array} { r } { M V _ { \ P a d A i r } = \rho _ { \ A i r } \ f _ { _ { P a d } } \big ( \eta _ { P a d } \big ( \boldsymbol { \chi } _ { P _ { P a d } } - \boldsymbol { \chi } _ { O u t } \big ) + \boldsymbol { \chi } _ { O u t } \big ) } \end{array}
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

where $f _ { P a d } \ ( \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { s } ^ { - 1 } )$ is the ventilation flux due to the pad and fan system, $\eta _ { { \scriptscriptstyle P a d } } ( { \scriptscriptstyle - } )$ is the efficiency of the pad and fan system, $X _ { P a d }$ ( $\mathrm { k g }$ water ${ \bf k g } ^ { - 1 }$ air) is the water vapour content of the pad and $x _ { O u t }$ (kg water ${ \bf k g } ^ { - 1 }$ air) is the water vapour content of the outdoor air. The ventilation flux due to the pad and

fan system is described by:

$$
f _ { { P a d } } = U _ { { P a d } } \phi _ { P a d } / A _ { F l r }
$$

where $U _ { { P a d } } \left( - \right)$ is the control valve of the pad and fan system and $\phi _ { P a d } ( \mathbf { m } ^ { 3 } \thinspace \mathbf { s } ^ { - 1 } )$ is the capacity  of the air flux through the pad.

The latent energy added to the inlet air equals the sensible heat loss of the outdoor air. Consequently, the sensible heat flux from the pad to the greenhouse air is described by: $H _ { P a d A i r } = f _ { P a d } \cup _ { A i r } c _ { p , A i r } T _ { O u t } - \Delta H \rho _ { A i r } \space ( \eta _ { P a d } ( \chi _ { _ { P a d } } - \chi _ { _ { O u t } } ) ) )$ $[ \mathrm { W ~ m ^ { - 2 } } ]$

The sensible heat flux from the greenhouse air to the outside air $H _ { A i r O u t \_ P a d }$ , when using the pad and fan system is described by:

$$
H _ { _ { A i r O u t \_ P a d } } = f _ { _ { P a d } } ( \underset { \_ { A i r } C _ { p , A i r } } { \underbrace { \sum _ { A i r } C _ { p , A i r } T _ { _ { A i r } } } } )
$$

$$
[ \mathrm { W ~ m ^ { - 2 } } ]
$$

The vapour flux from the greenhouse air to the outside air $M V _ { A i r O u t \_ P a d }$ , when using the pad and fan system is described by:

$$
M V _ { A i r O u t \_ P a d } = f _ { P a d } \frac { M _ { w a t e r } } { R } \Bigg ( \frac { V P _ { A i r } } { T _ { A i r } + 2 7 3 . 1 5 } \Bigg )
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

The net $\mathrm { C O } _ { 2 }$ flux from the outside air to the greenhouse air $M C _ { P a d A i r . }$ , when using the pad and fan system is described analogously to the general form of the $\mathrm { C O } _ { 2 }$ flux caused by an air flux (Eq. (45)).

# 9.5 Mechanical cooling

A mechanical cooling system can be used to decrease both the sensible and latent heat in the greenhouse. It was assumed that the temperature of the surface of the mechanical cooling unit is an input of the system and that the total cooling capacity of the mechanical cooling installation (used for heat and vapour removal) depends on the coefficient of performance (COP) and the installed electrical capacity. Therefore, to determine the heat and vapour flux between the mechanical cooling unit and the greenhouse air, the heat exchange coefficient between the surface of the mechanical cooling unit

and the greenhouse air is determined by:

$$
H E C _ { _ { M e c h A i r } } = \frac { \left( U _ { _ { M e c h C o o l } } C O P _ { _ { M e c h C o o l } } P _ { _ { M e c h C o o l } } / A _ { _ { F i r } } \right) } { T _ { _ { A i r } } \cdot \textit { T } _ { _ { M e c h C o o l } } + 6 . 4 \cdot 1 0 ^ { - 9 } \Delta H \left( \sqrt { P _ { _ { A i r } } } \cdot \mathrm { V } P _ { _ { M e c h C o o l } } \right) } \qquad \mathrm { [ W \ m ^ { - 2 } K ^ { - 1 } ] }
$$

where $U _ { _ { M e c h C o o l } } \left( - \right)$ is the control valve of the mechanical cooling mechanism, $C O P _ { M e c h C o o l } \left( - \right)$ is the coefficient of performance of the mechanical cooling system and $P _ { _ { M e c h C o o l } } ( \mathrm { w } )$ is the electrical capacity of the mechanical cooling system, $T _ { _ { M e c h C o o l } }$ $( ^ { \circ } \mathrm { C } )$ is the temperature of the cooling surface which is an input of the model, and $V P _ { _ { M e c h C o o l } }$ (Pa) is the saturated vapour pressure of the mechanical cooling mechanism.

The heat flux from the mechanical cooling to the greenhouse air, $H _ { _ { M e c h A i r } }$ , is described analogously to the general form of convective heat flux (Eq. (39)). The vapour flux from the greenhouse air to the surface of mechanical cooling system, $M V _ { A i r M e c h }$ , is described analogously to the general form of the vapour flux (Eq. (42)).

# 9.6 Fogging

The latent heat flux from the greenhouse air depends on the vapour flux from the fogging system to the greenhouse air which is described by:

$$
M V _ { \mathit { F o g A i r } } ~ = U _ { \mathit { F o g } } \phi _ { \mathit { F o g } } ~ / ~ A _ { \mathit { F l r } }
$$

$$
[ \mathrm { k g \ m ^ { - 2 } \ s ^ { - 1 } } ]
$$

where $U _ { { \scriptscriptstyle F o g } } \left( - \right)$ is the control valve of the fogging system and $\phi _ { F o g }$ (kg water $\mathsf { s } ^ { - 1 }$ ) is the capacity of the fogging system.

The heat flux of the air needed to evaporate the fog $L _ { A i r F o g } ,$ is described in a similar way as Eq. (41).

# 9.7 Natural ventilation

Three natural ventilation mechanisms are implemented in this model: ventilation through roof

openings, ventilation through openings in the side walls and ventilation through both openings in the side walls and the roof. The natural ventilation rate due to roof ventilation is described by Boulard and Baille (1995):

$$
\begin{array} { r l } { f _ { \mathit { v e n t R o o f } } ^ { ' } } &  = \frac { U _ { \mathit { R o o f } } A _ { \mathit { R o o f } } C _ { d } } { 2 A _ { \mathit { F r } } } \sqrt { \frac { g h _ { \mathit { v e n t } } } { 2 } \frac { T _ { \mathit { A i r } } - T _ { \mathit { O u t } } } { \left( \overline { { T } } + 2 7 3 . 1 5 \right) } + C _ { \mathit { w } } v _ { \mathit { w i n d } } ^ { \phantom { - 1 } } } \end{array} \quad \quad \quad \quad \begin{array} { r l } { [ \mathrm { m } ^ { 3 } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ] } & { } \end{array}
$$

where $U _ { R o o f } \left( - \right)$ is the control of the aperture of the roof vents $A _ { R o o f } ( \mathrm { m } ^ { 2 } )$ is the maximum roof ventilation area, $A _ { F l r } ( \mathbf { m } ^ { 2 } )$ is the greenhouse floor area, $C _ { d } \left( - \right)$ is the discharge coefficient which depends on the greenhouse shape and on the use of an outdoor thermal screen, $g ( \mathbf { m } \mathbf { \Lambda } ^ { s ^ { - 2 } } )$ , is the acceleration of gravity, $h _ { V e n t }$ (m) is the vertical dimension of a single ventilation opening, ${ \overline { { T } } } ( ^ { \circ } \mathrm { C } )$ is the mean temperature of the greenhouse air and the outside air, $C _ { w } \left( - \right)$ is the global wind pressure coefficient which depends on the greenhouse shape and on the use of an outdoor thermal screen and $V _ { W i n d } \left( \mathrm { m } { \ s } ^ { - 1 } \right)$ is the wind speed.

The ventilation rate through both the roof and side vents is described by Kittas et al. (1997):

$$
f _ { \natural e n R o o p i d e } ^ { \circ } = \frac { C _ { d } } { A _ { F i r } } \sqrt { \left( \frac { A _ { R o o f } ^ { U } A _ { s i d e } ^ { U } } { \sqrt { A _ { R o o f } ^ { U } } ^ { 2 } + A _ { s i d e } ^ { U } } \right) ^ { 2 } } \left( 2 g h _ { S i d e B o f } \frac { T _ { A i r } - T _ { O u t } } { ( \overline { { T } } + 2 7 3 . 1 5 ) } \right) + \left( \frac { A _ { R o o f } ^ { U } + A _ { S i d e } ^ { U } } { 2 } \right) ^ { 2 } C _ { w } v _ { W i n d } ^ { \circ }
$$

$$
[ \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \boldsymbol { \mathrm { s } } ^ { - 1 } ]
$$

where $A _ { R o o f } ^ { U }$ $( \mathrm { m } ^ { 2 } )$ is the aperture of roof vents, $A _ { S i d e } ^ { U }$ $( \mathrm { m } ^ { 2 } )$ is the aperture of the side vents and hSideRoof $\mathrm { ( m ) }$ is the vertical distance between mid-points of side wall and roof ventilation openings.

The ventilation rate function for sidewall ventilation only, was determined using Eq. (65), because then the aperture of roof vents becomes zero which results in:

$$
f _ { _ { V e n t S i d e } } ^ { " } = \frac { C _ { d } A _ { S i d e } ^ { U } \nu _ { _ { W i n d } } } { 2 A _ { _ { F l r } } } \sqrt { C _ { _ { w } } }
$$

$$
[ \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \boldsymbol { \mathrm { s } } ^ { - 1 } ]
$$

The apertures of the roof and sidewall vents depend on the control of the aperture of both vents:

$$
\begin{array} { l } { { A _ { { h o o f } } ^ { U } \ = U _ { _ { R o o f } } A _ { { h o o f } } } } \\ { { \ } } \\ { { A _ { { S i d e } } ^ { U } \ = U _ { _ { S i d e } } A _ { { S i d e } } } } \end{array}
$$

where $U _ { _ { R o o f } }$ (-) is the control of the aperture of the roof vents and $A _ { R o o f } ( \mathbf { m } ^ { 2 } )$ is the maximum roof ventilation area, $U _ { s i d e } \left( - \right)$ is the control of the sidewall vents and $A _ { R o o f } ( \mathbf { m } ^ { 2 } )$ is the maximum sidewall ventilation area.

According to Perez Parra et al.(2004) insect screens reduce the potential ventilation rate by a factor:

$$
\eta _ { _ { I n s S c r } } = _ { \zeta _ { I n s S c r } } ( 2 - \varsigma _ { _ { I n s S c r } } )
$$

$$
[ \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { s } ^ { - 1 } ]
$$

where $\varsigma _ { I n s S c r } ( - )$ the screen porosity which is the area of holes per unit area of screen.

Furthermore the ventilation rate of the greenhouse is influenced by the greenhouse leakage rate which depends on wind speed and is described by:

$$
f _ { l e a k a g e } = \left\{ \begin{array} { l l } { 0 . 2 5 c _ { l e a k a g e } , } & { V _ { w i n d } < 0 . 2 5 } \\ { c _ { l e a k a g e } \cdot v _ { W i n d } , } & { V _ { w i n d } \geq 0 . 2 5 } \end{array} \right.
$$

$$
[ \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \ : \mathsf { s } ^ { - 1 } ]
$$

where cleakage $( - )$ is the leakage coefficient which depends on the greenhouse type.

To calculate the ventilation rate though both the roof and side vents, the roof ventilation rates and side ventilations rates of Eqs. (64) and (66) respectively may not be added because then the chimney effect as described by Eq. (65) is neglected. Additionally, this chimney effect is also influenced by using a thermal screen. A thermal screen will decrease the ventilation rate when roof and side vents are used because then the chimney effect disappears and then the total ventilation equals the sum of Eqs. (64) and (66).

The total ventilation rate of the top compartment and greenhouse air compartment depends thus on: the net roof and side ventilation rates, the chimney effect, the thermal screen, the insect screens and the leakage rate of the greenhouse. Taking into account these processes and assuming that above a certain ratio between roof vent area and total vent area, the chimney effect becomes negligible, the total ventilation rates for roof and side vents are calculated by:

$$
\begin{array} { r l } { f _ { u e n R o o f } } & { = \left\{ \eta _ { l n s c r } f _ { u e n R o o f } ^ { - } + 0 . 5 f _ { l e a s g e } \right. } & { i f \ \eta _ { R o o f } \geq \eta _ { R o o f } _ { - R n } } \\ { f _ { u e n R o o f } } & { = \left\{ \eta _ { l n s c r } \underline { { f } } _ { r h o r e } f _ { u e n R o o f } ^ { - } + ( \mathbb { I } - U _ { T n s c r } ) f _ { u e n R o o f \backslash i e l e } ^ { - } \eta _ { R o o f } \right. \left. \eta _ { R o o f } \right. \left. \eta _ { 1 } f _ { l e a s e } \right. } & { i f \ \eta _ { R o o f } < \eta _ { R o o f } _ { - R n } } \end{array}
$$

$$
[ \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \ : \mathsf { s } ^ { - 1 } ]
$$

$$
\begin{array} { r l } { f _ { u n s c e } } & { = \left\{ \begin{array} { l l } { \eta _ { n s c r } f _ { u n s t d e } ^ { * } + 0 . 5 f _ { i e a t o r e } } & { i f \ \eta _ { n o t } \geq \eta _ { n o t - n r } } \\ { \eta _ { n s c r } \eta _ { n s c r } f _ { u n s t d e } ^ { * } + ( 1 - U _ { n s c r } ) f _ { u n s o t ( x ( e ) s i e } ^ { * } \eta _ { s i e } ) _ { + 0 . 5 } f _ { i e a t o r e } } & { i f \ \eta _ { n o t } < \eta _ { n o t - n r } } \end{array} \right. } \end{array}
$$

$$
[ \boldsymbol { \mathrm { m } } ^ { 3 } \boldsymbol { \mathrm { m } } ^ { - 2 } \ : \mathsf { s } ^ { - 1 } ]
$$

where $\eta _ { _ { R o o f } }$ is the ratio between the roof vent area and total ventilation area, $\eta _ { s i d e }$ is the ratio between the side vents area and total ventilation area and $\eta _ { _ { R o o f \_ T h r } }$ is the threshold value above which no chimney effect is assumed to occur. Implicitly, it was assumed that the leak ventilation is equally distributed over the top compartment and greenhouse air compartment.

The discharge coefficients, $C _ { d }$ and $C _ { w }$ depend on the use of an external shading screen. A linear relationship between the use of an external shading screen and the ventilation discharge coefficients was assumed for a greenhouse without an external shading screen:

$\begin{array} { r c l } { { } } & { { } } & { { C _ { d \phantom { e } } ~ { = } C _ { d \phantom { e } } ^ { G h } \bigl ( 1 - \eta _ { _ { S h S c r C _ { d } } } U _ { _ { S h S c } } ^ { \phantom { } } \bigr ) } } \\ { { } } & { { } } & { { } } \\ { { } } & { { } } & { { C _ { w \phantom { e } } ^ { \phantom { } } ~ { = } C _ { w } ^ { G h } \bigl ( 1 - \eta _ { _ { S h S c r C _ { w } } } U _ { _ { S h S c } } ^ { \phantom { } } \bigr ) } } \end{array}$ [-] (73) [-] (74)

where $C _ { d } ^ { G h }$ is the discharge coefficient determined for a greenhouse without an external shading screen, $\eta _ { S h S c r C _ { d } }$ is a parameter that determines the effect of the shading screen on the discharge coefficient, $C _ { w } ^ { G h }$ is the global wind pressure coefficient for a greenhouse without an external shading screen and $\eta _ { _ { S h S c r C _ { w } } }$ is a parameter that determines the effect of the shading screen on the global wind pressure coefficient.

# 9.8 Forced ventilation

The forced ventilation is described by:

$f _ { { v e n t F o r c e d } } ^ { " } ~ { = } U _ { { v e n t F o r c e d } } \phi _ { { V e n t F o r c e d } } ~ / A _ { { F l r } }$ $[ \mathbf { m } ^ { 3 } \mathbf { m } ^ { - 2 } \mathbf { s } ^ { - 1 } ]$ (7 where $U _ { \it V e n t F o r c e d }$ $( - )$ is the control of the forced ventilation and $\phi _ { \it V e n t F o r c e d } ( \mathrm { m } ^ { 3 } \mathrm { s } ^ { - 1 } )$ is the air flow capacity of the forced ventilation system. The effect of the insect screens on the forced ventilation flow is determined using Eq. (69).

# 9.9 External $\mathrm { C O } _ { 2 }$ source

The $\mathrm { C O } _ { 2 }$ added to the green greenhouse by an external $\mathrm { C O _ { 2 } }$ -source is described by: $\scriptstyle M C _ { _ { E x t A i r } } = U _ { _ { E x t C O _ { 2 } } } \phi _ { _ { E x t C O _ { 2 } } } \mid A _ { _ { F l r } }$ $[ \mathrm { m g } \mathrm { m } ^ { - 2 } \mathrm { s } ^ { - 1 } ]$ (76) where $U _ { _ { E x t C O _ { 2 } } } ( - )$ is the control valve of the external $\mathrm { C O } _ { 2 }$ source, $\phi _ { E x t C O _ { 2 } } ( \mathrm { m g } \mathrm { s } ^ { - 1 } )$ is the capacity of the external $\mathrm { C O } _ { 2 }$ source.

# 10 Calculated climate inputs

Usually, measurements of the following outdoor climate conditions are not available: the sky temperature $T _ { S k y }$ , the soil temperature at a certain depth $T _ { S o O u t . }$ , and the $\mathrm { C O _ { 2 } }$ -concentration of the outside air $C O 2 _ { O u t }$ . An approach to calculate these climate inputs based on the available outside climate data is presented here.

The soil temperature at a certain depth is calculated using the yearly soil temperature variation determined by van Wijk (1963): $T _ { _ { S o \left( d , t \right) } } = \overline { { T } } _ { s o } + a _ { 0 } e ^ { - { d _ { s o i l } } / { D } } \sin \left( \omega t - { d _ { s o i l } } / { D } + \beta \right)$ [°C] (77) where ${ \overline { { T } } } _ { S o } ( ^ { \circ } \mathrm { C } )$ is the mean soil temperature, $a _ { 0 } \left( ^ { \circ } \mathrm { C } \right)$ is the amplitude of the temperature at surface level, $d _ { S o i l }$ (m) is the soil depth, $D \left( \mathrm { m } \right)$ is the damping depth, $t$ is the time (s), $\omega$ is the yearly frequency $( s ^ { - 1 } )$ and $\beta \left( - \right)$ is the time shift of the sine function. The mean soil temperature equals the yearly mean outdoor temperature; the amplitude of the temperature at surface level equals the yearly outdoor temperature amplitude. The parameters $\overline { { T } } _ { s o }$ , $a _ { 0 }$ and $\boldsymbol { { \mathit { 1 } } }$ are location dependent and determined using a sinus fitting function. The damping depth is described by: $D = \sqrt { \frac { 2 \lambda _ { S o i l } } { \rho _ { S o i l } C _ { p S o i l } } }$ where $\lambda _ { S o i l } \left( \mathrm { W \ m ^ { - 1 } \ K ^ { - 1 } } \right)$ is the thermal heat conductivity of the soil, $\rho _ { S o i l } \ : ( \mathrm { k g \ : m ^ { - 3 } } )$ is the density of the soil and $c _ { p S o i l } ~ ( \mathrm { J } ~ \mathrm { k g } ^ { - 1 } ~ \mathrm { K } ^ { - 1 } )$ is the specific heat capacity of the soil.

The sky temperature is calculated according Monteith (1973): $T _ { s _ { k y } } = \bigr ( \bar { 0 } _ { 1 } - \mathrm { ~ } f r _ { c l o u d } \bigr ) \varepsilon _ { s _ { k y , C l e a r } } ( T _ { o u t } + 2 7 3 . 1 5 ) ^ { 4 } + \mathrm { ~ } f r _ { c l o u d } \bigl ( ( T _ { o u t } + 2 7 3 . 1 5 ) ^ { 4 } - 9 / \sigma \bigr ) \bigr ) ^ { 2 . 5 } - 2 7 3 . 1 5$ [°C]

where $f r _ { c l o u d }$ is the fraction of clouds, $\varepsilon _ { S k y C l e a r }$ is the FIR emission coefficient of a clear sky, $T _ { O u t }$ is the outdoor temperature and $\sigma$ is the Stefan Boltzmann constant. The fraction clouds during day time is averaged for the day period and calculated by:

$$
f r _ { _ { C l o u d \_ D a y } \left( D O Y \right) } = \frac { \sum I _ { _ { G l o b } } } { \sum I _ { _ { S o l } } }
$$

where $I _ { S o l } ( \mathsf { W } \thinspace \mathrm { m } ^ { - 2 } )$ is the calculated solar radiation under clear sky conditions. During the night there is no solar radiation and therefore the fraction of clouds during the night is calculated by interpolating the fraction of clouds of the preceding day with the fraction of clouds of the next day.

The FIR emission coefficient of a clear sky is calculated by: $\varepsilon _ { s k y , c l e a r } = 0 . 5 3 + 6 \cdot 1 0 ^ { - 3 } V P _ { O u t } ^ { 0 . 5 }$

When not measured, the outdoor $\mathrm { C O } _ { 2 }$ concentration was assumed to have a constant value of 370 ppm throughout the day.

# 11 Tables

Table 1 List of model parameters and symbols   

<html><body><table><tr><td>Fixed model parameters</td><td>Symbol and value</td><td>Unit</td><td>Reference</td></tr><tr><td>Convective heat</td><td>αLeafAir= 5</td><td>W m² K-1</td><td>(De Zwart, 1996)</td></tr><tr><td>exchange coefficient</td><td></td><td></td><td></td></tr><tr><td>from the canopy leaf to</td><td></td><td></td><td></td></tr><tr><td>the greenhouse air</td><td></td><td></td><td></td></tr><tr><td>Latent heat of</td><td>△H=2.45·106</td><td>J kg-1 water</td><td></td></tr><tr><td>evaporation</td><td></td><td></td><td></td></tr><tr><td>Stefan Boltzmann</td><td>σ = 5.670·10-8</td><td>W m² K-4</td><td></td></tr><tr><td>constant</td><td></td><td></td><td></td></tr><tr><td>FIR emission</td><td>εcan=1</td><td></td><td>Leaves are considered as black bodies.</td></tr><tr><td>coefficient of the</td><td></td><td></td><td>(Stanghellini, 1987)</td></tr><tr><td>canopy</td><td></td><td></td><td>By definition</td></tr><tr><td>FIR emission coefficient of the sky</td><td>εsky =1</td><td></td><td></td></tr><tr><td>The ratio between NIR</td><td>NGlob_NIR= 0.5</td><td></td><td>UV is attributed to NIR</td></tr><tr><td>and the outside global</td><td></td><td></td><td>(Monteith, 1973)</td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>radiation</td><td>NGlob_PAR = 0.5</td><td></td><td>(Monteith, 1973)</td></tr><tr><td>The ratio between PAR</td><td></td><td></td><td></td></tr><tr><td>and the outside global</td><td></td><td></td><td></td></tr><tr><td>radiation</td><td>NHeatCo2 = 0.057</td><td>mg CO2 J-1</td><td></td></tr><tr><td>Amount of CO2 which</td><td></td><td></td><td></td></tr><tr><td>is released when 1</td><td></td><td></td><td></td></tr><tr><td>Joule of sensible</td><td></td><td></td><td></td></tr><tr><td>energy is produced by</td><td></td><td></td><td></td></tr><tr><td>the heat blower</td><td></td><td></td><td></td></tr><tr><td>Amount of vapour</td><td>N Heatvap = 4.43·10-8</td><td>kg vapour J-1</td><td></td></tr><tr><td>which is released when</td><td></td><td></td><td></td></tr><tr><td>1 Joule of sensible</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>energy is produced by</td><td></td><td></td><td></td></tr></table></body></html>

<html><body><table><tr><td>the heat blower</td><td></td><td></td><td></td></tr><tr><td>CO2 conversion factor</td><td>1/mg_ppm = 0.554</td><td>ppm mg-1 m³</td><td></td></tr><tr><td>from mg m³ to ppm. The ratio between the</td><td>1Roof_Thr = 0.9</td><td></td><td>Assumed</td></tr><tr><td>roof vent area and total</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>ventilation area above</td><td></td><td></td><td></td></tr><tr><td>no chimney effect was</td><td></td><td></td><td></td></tr><tr><td>assumed</td><td></td><td></td><td></td></tr><tr><td>Density of the air at sea level</td><td>PAiro =1.20</td><td>kg m³</td><td></td></tr><tr><td>The PAR reflection</td><td></td><td></td><td></td></tr><tr><td>coefficient</td><td>PCanPAR = 0.07</td><td></td><td>(Marcelis et al., 1998).</td></tr><tr><td>The NIR reflection</td><td>PCanNIR = 0.35</td><td></td><td>Based on absorption of</td></tr><tr><td>coefficient of the top of</td><td></td><td></td><td>diffuse NIR of (De</td></tr><tr><td>the canopy</td><td></td><td></td><td>Zwart, 1996)</td></tr><tr><td>Density of steel</td><td>Psteel = 7850</td><td>kg m-³</td><td></td></tr><tr><td>Density of water</td><td>Pwater =1·103</td><td>kg m-³</td><td></td></tr><tr><td>Psychrometric constant</td><td>y=65.8</td><td>Pa K-1</td><td></td></tr><tr><td>The yearly frequency</td><td>ω= 1.99·10-7</td><td>s-1</td><td></td></tr><tr><td>to calculate the soil</td><td></td><td></td><td></td></tr><tr><td>temperature</td><td></td><td></td><td></td></tr><tr><td>Heat capacity of a</td><td>capLeaf= 1.2·103</td><td>JK¹ m² leaf</td><td>(Stanghellini, 1987)</td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>square meter canopy</td><td></td><td></td><td></td></tr><tr><td>leaves Coefficient of the</td><td></td><td></td><td></td></tr><tr><td>stomatal resistance</td><td></td><td></td><td></td></tr><tr><td></td><td>Cevap1= 4.30</td><td>W m2</td><td>(Stanghellini, 1987)</td></tr><tr><td>model to account for</td><td></td><td></td><td></td></tr><tr><td>radiation effect Coefficient of the</td><td></td><td></td><td></td></tr><tr><td>stomatal resistance</td><td></td><td></td><td></td></tr><tr><td>model to account for</td><td>Cevap2 = 0.54</td><td>W m²</td><td>(Stanghellini, 1987)</td></tr><tr><td>radiation effect</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td>ppm-²</td><td></td></tr><tr><td>Coefficient of the stomatal resistance</td><td>ep3 = 6.1-10-7(day)</td><td></td><td>(Stanghellini, 1987)</td></tr></table></body></html>

<html><body><table><tr><td>model to account CO2 effect</td><td>Cevap3 =1.1·10-11 (night) Cenight</td><td></td><td></td></tr><tr><td>Coefficient of the stomatal resistance</td><td>dvap4 = 4.3·10-6 (day) cday</td><td></td><td></td></tr><tr><td>model to account for vapor pressure difference</td><td>cep4 = 5.2-10 (night)</td><td>Pa2</td><td>(Stanghellini, 1987)</td></tr><tr><td>Specific heat capacity of the air</td><td>Cp.Air =1·103</td><td>JK1 kg1</td><td></td></tr><tr><td>Specific heat capacity of steel</td><td>Cp,Steel =0.64·103</td><td>JK-1 kg1</td><td></td></tr><tr><td>Specific heat capacity of water</td><td>Cp.Water = 4.18·103</td><td>JK1kg1</td><td></td></tr><tr><td>The acceleration of gravity</td><td>g = 9.81</td><td>m s-</td><td></td></tr><tr><td>The thickness of the soil layers</td><td>hso,j = [0.04 0.08 0.16 0.32 0.64]</td><td>m</td><td>Based on (De Zwart, 1996)</td></tr><tr><td>The PAR extinction</td><td>j = 1,2...5</td><td></td><td></td></tr><tr><td>coefficient of the canopy</td><td>K1_PAR = 0.7</td><td></td><td>(Marcelis et al., 1998)</td></tr><tr><td>The PAR extinction</td><td></td><td></td><td></td></tr><tr><td>coefficient of the</td><td></td><td></td><td></td></tr><tr><td></td><td>K2_PAR = 0.7</td><td></td><td>Assumed, similar to Ki</td></tr><tr><td>canopy when PAR is</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>reflected from the floor</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>The extinction</td><td>KNIR = 0.27</td><td></td><td>Based on absorption of</td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the</td><td></td><td></td><td>diffuse NIR of (De</td></tr><tr><td></td><td></td><td></td><td>Zwart, 1996)</td></tr><tr><td>canopy for NIR</td><td></td><td></td><td></td></tr><tr><td>The extinction</td><td>KFIR= 0.94</td><td></td><td>Based on (De Zwart,</td></tr><tr><td>coefficient of the</td><td></td><td></td><td>1996)</td></tr><tr><td>canopy for FIR</td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>Molar mass of air</td><td>MAir = 28.96</td><td>kg kmol-1</td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td>Molar mass of water</td><td></td><td>kg kmol-1</td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td>Mwater= 18</td><td></td><td></td></tr></table></body></html>

<html><body><table><tr><td>Molar gas constant</td><td>R = 8.314·10³</td><td>Jkmol-1 K-1</td><td></td></tr><tr><td>The radiation value above the canopy when the night becomes day and vice versa.</td><td>Rcan_sp = 5</td><td>(W m-2)</td><td></td></tr><tr><td>Boundary layer resistance of the canopy for vapour transport</td><td>rb = 275</td><td>sm-1</td><td>Mean value based on (Stanghellini, 1987)</td></tr><tr><td>The minimum canopy resistance for transpiration</td><td>rs,min = 82.0</td><td>s m-1</td><td>(Stanghellini, 1987)</td></tr><tr><td>The slope of the differentiable switch for the stomatical resistance model</td><td>Sr =-1</td><td>m W-2</td><td></td></tr><tr><td>The slope of the differentiable switch function for vapour pressure differences</td><td>SMν12 =- 0.1</td><td>Pa-1</td><td></td></tr></table></body></html>

表2 四个不同温室设计（西西里岛、荷兰、德克萨斯州和亚利桑那州）的温室设计参数。验证实验中未使用的温室设计元素用"×"表示。

| 温室设计参数 | 单位 | 西西里岛 | 荷兰 | 德克萨斯州 | 亚利桑那州 |
|--------------|------|----------|------|------------|------------|
| 构造 - 温室结构元素吸收的全球辐射比例 NGlob_Air | - | 0.1 | 0.1 | 0.1 | 0.1 |
| 温室覆盖层平均坡度 | ° | 0 | 拱形 | 25 | 22 | 拱形 |
| 包括侧墙在内的覆盖层表面积 Acov | m² | 1.7×10⁴ | 1.8×10⁴ | 9.0×10⁴ | 730 |
| 温室地板表面积 AFlr | m² | 1.3×10⁴ | 1.4×10⁴ | 7.8×10⁴ | 278 |
| 覆盖层与室外空气之间的对流换热参数（取决于温室形状） CHECin | W/m²K | 2.21 | 1.86 | 1.86 | 2.21 |
| 覆盖层与室外空气之间的对流换热变量 CHECout_1 | W/m²K | 0.95 | 2.8 | 2.8 | 0.95 |
| 取决于温室形状的换热参数 CHECout_2 | J/m³K | 6.76 | 1.2 | 1.2 | 6.76 |
| 换热参数 CHECout_3 | - | 0.49 | 1 | 1 | 0.49 |
| 温室海拔高度 hElevation | m（海拔） | 104 | 0 | 1470 | 715 |

<tr><td>hElevation</td></tr><tr><td>Mean height of the greenhouse</td><td>hch</td><td>m</td><td>4.8</td><td>4.2</td><td>5.1</td><td>6.1</td></tr><tr><td>Ventilation</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>properties Parameter that determines the effect of the movable shading screen on the discharge</td><td>NshScrCd</td><td></td><td>X</td><td>X</td><td>X</td><td>X</td></tr><tr><td>coefficient Parameter that determines the effect of the movable shading screen on the global wind pressure</td><td>1shScrCw</td><td></td><td>X</td><td>X</td><td>X</td><td>X</td></tr><tr><td>coefficient The porosity of the insect screens</td><td>S InsSer</td><td>一</td><td>0.33</td><td>1</td><td>1</td><td>X</td></tr><tr><td>The specific roof ventilation area</td><td>ARoof / AFIr</td><td>m</td><td>0.20</td><td>0.10</td><td>0.18</td><td>X</td></tr><tr><td>The side ventilation area</td><td>Aside/AFIr</td><td>m</td><td>0</td><td>0</td><td>0</td><td>X</td></tr><tr><td>Ventilation discharge coefficient depends on greenhouse</td><td>Ch</td><td>1</td><td>0.75</td><td>0.75</td><td>0.65</td><td>X</td></tr></table></body></html>

<html><body><table><tr><td> shape</td><td></td><td></td><td></td><td></td><td colspan="2"></td></tr><tr><td>Greenhouse leakage coefficient</td><td>Cleakage</td><td></td><td>1·10-4</td><td>1·10-4</td><td>1·10-4</td><td>1·10-4</td></tr><tr><td>Ventilation global wind pressure coefficient depends on greenhouse shape</td><td>CG</td><td></td><td>0.12</td><td>0.09</td><td>0.09</td><td>X</td></tr><tr><td>The vertical distance between mid-points of side wall and roof ventilation openings</td><td>hsideRoof</td><td>m</td><td>X</td><td>X</td><td>X</td><td>X</td></tr><tr><td>The vertical dimension of a single ventilation opening</td><td>hvent</td><td>m</td><td>1.6</td><td>0.68</td><td>0.97</td><td>X</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Roof The FIR emission</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the roof</td><td>εRfFIR</td><td></td><td>0.9</td><td>0.85</td><td>0.85</td><td>0.9</td></tr><tr><td>Density of the roof layer</td><td>PRf</td><td>kg m</td><td>35</td><td>2.6·10³</td><td>2.6·10</td><td>35</td></tr><tr><td>The NIR reflection coefficient of the roof</td><td>PRINIR</td><td>一</td><td>0.21</td><td>0.13</td><td>0.13</td><td>0.20</td></tr><tr><td>The PAR reflection coefficient of the roof</td><td>PR[PAR</td><td></td><td>0.21</td><td>0.13</td><td>0.13</td><td>0.20</td></tr><tr><td>The FIR reflection coefficient of the roof</td><td>PRfFIR</td><td></td><td>0</td><td>0.15</td><td>0.15</td><td>0</td></tr><tr><td>The NIR</td><td>T RfNIR</td><td>1</td><td>0.77</td><td>0.85</td><td>0.85</td><td>0.78</td></tr></table></body></html>

<html><body><table><tr><td>transmission coefficient of the roof The PAR transmission coefficient of the</td><td>T RfPAR</td><td></td><td>0.77</td><td>0.85</td><td>0.85</td><td>0.78</td></tr><tr><td>FIR transmission coefficient of the</td><td>T RfFIR</td><td></td><td>0.1</td><td>0</td><td>0</td><td>0.1</td></tr><tr><td>Thermal heat conductivity of greenhouse roof</td><td>?Rf</td><td>W m1 K-1</td><td>0.018</td><td>1.05</td><td>1.05</td><td>0.018</td></tr><tr><td>The specific heat capacity of the roof layer</td><td>Cp.Rf</td><td>JK1 kg'1</td><td>2.5.10</td><td>0.84·10²</td><td>0.84·10</td><td>2.5·10</td></tr><tr><td>Thickness of the roof layer</td><td>hRf</td><td>m</td><td>0.01</td><td>4·10-3</td><td>4:10-3</td><td>0.01</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Whitewash The FIR emission</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the whitewash</td><td>EShScrPerFIR</td><td></td><td>0.9</td><td>X</td><td>0.9</td><td>X</td></tr><tr><td>Density of the semi permanent shading screen</td><td>PShScrPer</td><td>kg m</td><td>1·10</td><td>X</td><td>1·10</td><td>X</td></tr><tr><td>The NIR reflection coefficient of the whitewash</td><td>PShScrPerNIR</td><td></td><td>0.2</td><td>X</td><td>0.3</td><td>X</td></tr><tr><td>The PAR reflection coefficient of the whitewash</td><td>PShScrPerPAR</td><td></td><td>0.2</td><td>X</td><td>0.3</td><td>X</td></tr><tr><td>coefficient of the whitewash</td><td>PShScrPerFIR</td><td></td><td>0</td><td>X</td><td>0</td><td>X</td></tr></table></body></html>

<html><body><table><tr><td>The NIR transmission coefficient of the whitewash</td><td>T ShScrPerNIR</td><td></td><td>0.7</td><td>X</td><td>0.6</td><td>X</td></tr><tr><td>The PAR transmission coefficient of the whitewash</td><td>T ShScrPerPA R</td><td></td><td>0.7</td><td>X</td><td>0.6</td><td>X</td></tr><tr><td>FIR transmission coefficient of the whitewash</td><td>T ShScrPerFIR</td><td></td><td>0.1</td><td>X</td><td>0.1</td><td>X</td></tr><tr><td>Thermal heat conductivity of the whitewash</td><td>shserPer</td><td>W m1 K-1</td><td>8</td><td>X</td><td>00</td><td>X</td></tr><tr><td>Specific heat capacity of the whitewash</td><td>C p,ShSerPer</td><td>JK-1 kg1</td><td>4.18-103</td><td>X</td><td>4.18·103</td><td>X</td></tr><tr><td>Thickness of the whitewash</td><td>hshSerPer</td><td>m</td><td>0.2·10-3</td><td>X</td><td>0.2·10-3</td><td>X</td></tr><tr><td>Thermal screen</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>The FIR emission</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the thermal screen</td><td>£ThScrFIR</td><td></td><td>X</td><td>0.67</td><td>0.44</td><td>0.8</td></tr><tr><td>Density of the thermal screen The NIR reflection</td><td>PThScr</td><td>kg m</td><td>X</td><td>0.2·10</td><td>0.2·103</td><td>0.2-103</td></tr><tr><td>coefficient of the thermal screen The PAR reflection</td><td>PThSerNIR</td><td></td><td>X</td><td>0.35</td><td>0.7</td><td>0.5</td></tr><tr><td>coefficient of the thermal screen The FIR reflection</td><td>PThScrPAR</td><td></td><td>X</td><td>0.35</td><td>0.7</td><td>0.5</td></tr><tr><td>coefficient of the thermal screen</td><td>PThScrFIR</td><td></td><td>X</td><td>0.18</td><td>0.45</td><td>0</td></tr></table></body></html>

<html><body><table><tr><td>The NIR transmission coefficient of the thermal screen</td><td>TThScrNIR</td><td></td><td>X</td><td>0.6</td><td>0.25</td><td>0.4</td></tr><tr><td>The PAR transmission coefficient of the thermal screen</td><td>TThScrPAR</td><td></td><td>X</td><td>0.6</td><td>0.25</td><td>0.4</td></tr><tr><td>FIR transmission coefficient of the thermal screen</td><td>TThScrFIR</td><td></td><td>X</td><td>0.15</td><td>0.11</td><td>0.2</td></tr><tr><td>Specific heat capacity of the thermal screen</td><td>Cp,ThScr</td><td>Jkg1K1</td><td>X</td><td>1.8-103</td><td>1.8-103</td><td>1.8-103</td></tr><tr><td>Thickness of the thermal screen</td><td>hThSer</td><td>m</td><td>X</td><td>0.35-10-3</td><td>0.35-10-3</td><td>0.35-10-³</td></tr><tr><td>The thermal screen flux coefficient</td><td>KThSer</td><td>m m² K 0.6 5 1</td><td>X</td><td>0.05-10-3</td><td>0.25-10-3</td><td>1:10-3</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Floor FIR emission</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the greenhouse floor</td><td>EFlr</td><td></td><td>1</td><td>1</td><td>1</td><td>1</td></tr><tr><td>Density of the floor</td><td>PFIr</td><td>kg m-</td><td>2300</td><td>2300</td><td>2300</td><td>2300</td></tr><tr><td>NIR reflection coefficient of the floor</td><td>PFlr NIR</td><td></td><td>0.5</td><td>0.5</td><td>0.5</td><td>0.5</td></tr><tr><td>PAR reflection coefficient of the greenhouse floor</td><td>PFIrPAR</td><td></td><td>0.65</td><td>0.65</td><td>0.65</td><td>0.65</td></tr><tr><td>Thermal heat conductivity of the</td><td>~F1r</td><td>Wm1 K1</td><td>1.7</td><td>1.7</td><td>1.7</td><td>1.7</td></tr><tr><td>floor Specific heat</td><td>Cp.Flr</td><td>JK1 kg-1</td><td>0.88-10³</td><td>0.88·103</td><td>0.88-103</td><td>0.88-10³</td></tr></table></body></html>

<html><body><table><tr><td>capacity of the</td><td rowspan="2"></td><td rowspan="2"></td><td rowspan="2"></td><td rowspan="2"></td><td rowspan="2"></td><td rowspan="2"></td></tr><tr><td>floor</td></tr><tr><td>Thickness of the greenhouse floor</td><td>hplr</td><td>m</td><td>0.02</td><td>0.02</td><td>0.02</td><td>0.02</td></tr><tr><td>Soil properties</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>The volumetric</td><td>pCp.So</td><td>JmK-1</td><td>1.73-106</td><td>1.73-106</td><td>1.73-106</td><td>1.73·106</td></tr><tr><td>heat capacity of the soil Thermal heat</td><td>1so</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>conductivity of the</td><td></td><td>W m-1 K-1</td><td>0.85</td><td>0.85</td><td>0.85</td><td>0.85</td></tr><tr><td> soil layers.</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Heating system</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>FIR emission</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>coefficient of the</td><td>εPipe</td><td></td><td>0.88</td><td>0.88</td><td>0.88</td><td>X</td></tr><tr><td>heating pipes</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>External diameter</td><td>pipe.e</td><td>m</td><td>51·10-</td><td>51·10-</td><td>51·10-3</td><td>X</td></tr><tr><td>of the heating pipe</td><td>ppipe.i</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Internal diameter of the heating pipe</td><td></td><td>m</td><td>47-10-3</td><td>47-10-3</td><td>47-10-3</td><td>X</td></tr><tr><td>Length of the</td><td rowspan="3">lpipe</td><td rowspan="3">m m²</td><td rowspan="3">1.25</td><td rowspan="3">1.875</td><td rowspan="3">1.25</td><td rowspan="3">X</td></tr><tr><td>heating pipes per</td></tr><tr><td>square meter greenhouse</td></tr><tr><td>Active climate control</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>Efficiency of the pad and fan system</td><td>npad</td><td></td><td>X</td><td>X</td><td>X</td><td>Function of the air flux</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td>through the pad</td></tr><tr><td>Capacity of the fogging system</td><td>Fog</td><td>kg water s"</td><td>X</td><td>X</td><td>X</td><td>0</td></tr></table></body></html>

<html><body><table><tr><td>of the mechanical Electrical capacity source the industrial heat Heat capacity of PMechCool PInd</td><td>heat source the geothermal Heat capacity of PGeo</td><td>boiler capacity of the PBoil</td><td>Thermal heat the heat blowers Heat capacity of Pblow</td><td>temperature the greenhouse air storage facility and passive heat HECpasAir</td><td>between the coefficient heat exchange The convective system</td><td>Coefficient of COPMechCool</td><td>source external CO2 Capacity of the system PExiCO2</td><td>forced ventilation PventForced</td><td>capacity of the The air flow pad and fan system flux through the pad</td></tr><tr><td>W M</td><td>M</td><td>M</td><td>M</td><td>Wm²K1</td><td></td><td>mg s-1</td><td>ms1</td><td></td><td></td></tr><tr><td>X</td><td></td><td></td><td></td><td></td><td>X</td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td>input Tpipe was</td><td>X</td><td>X</td><td>X</td><td>7.2·104</td><td></td><td></td><td></td></tr><tr><td>×</td><td>X</td><td>input Tpipe was</td><td>X</td><td></td><td></td><td>4.3·105</td><td></td><td>×</td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td>X</td><td></td><td>0</td><td>16.7</td></tr></table></body></html>

<html><body><table><tr><td>cooling system</td><td></td><td></td><td></td><td></td><td></td><td></td></tr></table></body></html>

表3 用于计算FIR模型通量的$A_{i}$和$F_{ij}$方程

| FIRi | Ai | Fi |
|------|----|----|
| RcanCov.in | ACan =(1- e KPRLAI) | =TsecFrIR FcanCov.in |
| RcanSsky | ACan =(1- eKFIRLAI) | FconSky =TCovFIRTsFIR |
| RcanThSer | ACan =(1- eKFRLA1) | FcanThser =U Thscr |
| RcanFIr | Acan =(1- e*KFIRLA1) | FcanFlr =1- 0.49rd pipePpipe,e |
| RpipeCov.in | Apipe =t pipePpipe |  |
| Rpipesky | Apipe = pipePpipe | FPeSyIA |
| RpipeThScr | Apipe =d pipePpipe.e | FPipeThSer =UThScr0.49e KFIRLAI |
| RpipeFIr | Apipe =rdpipePpipe,e | FpipeFIr =0.49 |
| RpipeCan | Apipe =d pipePpipe,e | FPipeCan =0.49Q1- e KFIRLA1) |
| RFIrCov.in | AFr=1 | F |
| RFlrsky | Ap =1 | Fs= |
| RFlrThSer | AFIr =1 | FlrThSer=U-4pePpeA |
| RThSerCov.in | AThscr =1 | FThSerCovin =UTscr |
| RThSerSky | Arhscr =1 | Frh5crSky =TCovFRUThScr |
| Rcov,esky | Acov,e =1 | =1 Fcov.esky |

表4 对流和传导热通量及其热交换系数

| H (W/m²) | HEC (W/m²·K) | 来源 |
|----------|--------------|------|
| HcanAir | HEC CanAir = 2α LeafAirLAI | De Zwart (1996) |
| H AirFlr | [1.7(TFlr - TAir)^0.33 if TFIr > TAir [1.3(TAir - TFI)^0.25 if TFlr ≤ TAir HEC AirFir | De Zwart (1996) |
| H AirThSer | HECirThSer = 1.7Uscr(TAir - Trncr)^0.33 | De Zwart (1996) |
| H AirOut | HECAirOut = PAirCpAir(fventSide + fventForced) |  |
| H AirTop | HEC AirTop = PAirCp,Air fThScr | De Zwart (1996) |
| H ThScrTop | (Trhscr - TTop)^0.33 HECThScrTop = 1.7U ThSer | De Zwart (1996) |
| H TopCov.in | (TT p)^0.33 Acov(Top op - TCov,in) HEC TopCov,in = C HECin AFIr | Roy et al. (2002) |
| H TopOut | HECTopOut = PAirC p.Air fventRoof |  |
| H cov,eOut | Ac(CHECout_1 + CHECout_2:VindHECo_3) HEC cov,eOut AFr | (Roy et al., 2002) |
| H pipeAir | HEC PipeAir = 1.99π φpipe,e Pipe|TPipe - TAir|^0.32 | De Zwart (1996) |
| HFlrSo1 | 2 hFir / 2Fir + hso1/λso HEC FlrSo1 |  |
| H so(j-1)so(j) | 22so HEC so(j-1)so(j) = (Thso(j-1) + hso(j) |  |

# 12 参考文献

Anonymous (1998). 建筑玻璃 - 玻璃的光学和太阳能特性测定. 欧洲标准化委员会   
Boulard T and Baille A (1995). 带有连续屋顶通风口的温室空气交换率建模. 农业工程研究杂志, 61(1), 37-48   
De Zwart H F (1996) 使用模拟模型分析温室栽培中的节能选项. 博士论文, 瓦赫宁根大学, 236页.   
Kittas C; Boulard T; Papadakis G (1997). 带有屋脊和侧面开口的温室自然通风：对温度和风效应的敏感性. ASAE学报, 40(2), 415-425   
Marcelis L F M; Heuvelink E; Goudriaan J (1998). 园艺作物生物量生产和产量建模：综述. 园艺科学, 74(1-2), 83-111   
Monteith J L (1973). 环境物理学原理. 阿诺德出版社, 伦敦   
Perez Parra J; Baeza E; Montero J I; Bailey B J (2004). Parral温室的自然通风. 生物系统工程, 87(3), 355-366   
Ross J (1975). 植物群落中的辐射传输. 见：植被与大气（Monteith J L 编）, pp. 13-55. 学术出版社, 伦敦   
Roy J C; Boulard T; Kittas C; Wang S (2002). 温室中的对流和通风传递，第1部分：将温室视为完美搅拌槽. 生物系统工程, 83(1), 1-20   
Stanghellini C (1987) 温室作物的蒸腾作用：气候管理的辅助工具. 博士论文, IMAG, 150页.   
van Wijk W R (1963). 植物环境物理学. 北荷兰出版公司, 阿姆斯特丹   
Vanthoor B H E; De Visser P H B; Stanghellini C; Van Henten E J (已提交). 基于模型的温室设计方法：第2部分，番茄产量模型的描述和验证. 生物系统工程,

# 12 References

Anonymous (1998). Glass in building - Determination of luminous and solar characteristics of glazing. European committee for standardization   
Boulard T and Baille A (1995). Modelling of Air Exchange Rate in a Greenhouse Equipped with Continuous Roof Vents. Journal of Agricultural Engineering Research, 61(1), 37-48   
De Zwart H F (1996) Analyzing energy-saving options in greenhouse cultivation using a simulation model. PhD thesis, Wageningen University, 236pp.   
Kittas C; Boulard T; Papadakis G (1997). Natural ventilation of a greenhouse with ridge and side openings: sensitivity to temperature and wind effects. Transactions of the ASAE, 40(2), 415- 425   
Marcelis L F M; Heuvelink E; Goudriaan J (1998). Modelling biomass production and yield of horticultural crops: a review. Scientia Horticulturae, 74(1-2), 83-111   
Monteith J L (1973). Principles of environmental physics. Arnold, London   
Perez Parra J; Baeza E; Montero J I; Bailey B J (2004). Natural ventilation of parral greenhouses. Biosystems Engineering, 87(3), 355-366   
Ross J (1975). Radiative transfer in plant communities. In: Vegetation and Atmosphere (Monteith J L, ed), pp. 13-55. Academic Press, London   
Roy J C; Boulard T; Kittas C; Wang S (2002). Convective and ventilation transfers in greenhouses, part 1: The greenhouse considered as a perfectly stirred tank. Biosystems Engineering, 83(1), 1-20   
Stanghellini C (1987) Transpiration of greenhouse crops: an aid to climate management. PhD thesis, IMAG, 150pp.   
van Wijk W R (1963). Physics of plant environment. North-Holland publ.Co., Amsterdam   
Vanthoor B H E; De Visser P H B; Stanghellini C; Van Henten E J (Submitted). A methodology for model-based greenhouse design: Part 2, Description and validation of a tomato yield model. Biosystems Engineering,