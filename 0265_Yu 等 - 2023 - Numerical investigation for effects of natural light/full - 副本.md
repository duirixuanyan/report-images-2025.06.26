# Numerical investigation for effects of natural light and ventilation on 3D tomato body heat distribution in a Venlo greenhouse

# 自然光照和通风对Venlo型温室内3D番茄植株热分布影响的数值研究

Guanghui Yu a,b,c,d, Shanhong Zhang a,b,c,d, Shuai Li a,b,c,d, Minshu Zhang a,b,c,d, Hüseyin Benli e, Yang Wang a,b,c,d,*

a 中国农业大学国家数字渔业创新中心，北京 100083  b 农业农村部智慧养殖技术重点实验室，中国农业大学，北京 100083  c 中国农业大学农业物联网工程技术研究中心，北京 100083  d 中国农业大学信息与电气工程学院，北京 100083  e 土耳其菲拉特大学技术与职业教育系，埃拉泽 TR-23119

# 文章信息

# 摘要

文章历史：2021年7月8日收稿 2022年4月29日修回 2022年5月23日录用 在线发表xxxx

关键词：计算流体力学 3D番茄植株 热分布 温室环境 生长条件

维持番茄周围适宜的温度水平对高品质生产至关重要。然而在夏季，若不使用高精度热成像仪，通常难以明确番茄周围的温度分布。为解决此问题，本研究基于SolidWorks构建的3D番茄模型，采用计算流体力学(CFD)模拟方法研究了其热性能。为评估番茄周围温度分布的影响，首先通过现场实测数据验证了简化的3D番茄数值模型。将光照强度和室内通风视为Venlo温室主要环境因素，进一步研究了不同时段番茄周围的热分层现象。数值结果表明不同辐射强度下番茄植株周围存在差异化的温度分布。研究发现通风能显著调节番茄周围的温度梯度，尤其在夏季可有效缓解高温影响。适宜的通风可为番茄生长创造合适的热环境。本研究清晰展示了番茄周围3D温度分布特征，为精确检测番茄3D温度分布和优化热环境设计提供了参考依据。

© 2022 中国农业大学。由Elsevier B.V.旗下KeAi Communications Co. Ltd.出版。本文遵循CC BY-NC-ND 4.0许可协议(http://creativecommons.org/licenses/by-nc-nd/4.0/)。

# 1. 引言

随着全球粮食和环境问题日益突出，能够提高农业生产效率的温室农业技术备受关注。温室农业已被视为提高作物产量和品质的高效种植模式。近几十年来，研究人员持续研究通风系统设计和室内空气温度分布以优化温室建筑结构[1-4]。然而在既往研究中，多数研究者关注2D模型的通风效果和温度分布，而针对不同时段室内热量和气流分布的3D模拟分析较为罕见。

温室环境的适宜温度对植物生长具有重要作用。当环境温度超过植物生长的最适温度范围时，植物可能发生程序性细胞死亡(PCD)和细胞色素释放[5]。此外，植物繁殖阶段比其他生长阶段更易受高温影响[6]。温度升高会导致花粉管损伤和花粉发育不良，从而降低坐果率和作物产量[7]。高温还可能影响植物光合作用，改变膜流动性，破坏代谢机制的稳定性[8]。同样，低温会降低植物生物酶活性和膜流动性，抑制生理过程正常功能，导致代谢紊乱[9]。因此，在温度过高的环境中（如中国许多地区夏季正午温度可达$35^{\circ}C$），需要采用机械通风等措施维持植物的热舒适性[1]。

目前机械通风已广泛应用于维持植物热舒适性[10,11]。但室内通风速度控制不当会导致温度过高和果实重量下降[12]。温室内部推荐维持0.5至$0.7m/s$的气流速度[13]。当通风速度低于推荐值时，会影响室内空气循环和混合，导致$CO_2$浓度和太阳辐射热在植物周围过度积累，影响温室作物的光合速率和产量[14]。当通风速度高于推荐值时，通风系统将消耗更多能源，增加温室作物生产成本。针对温室通风问题，Zhang等设计了具有三排空气射流的穿孔风管，为作物冠层表面提供垂直气流并将风速控制在合理范围内[1]。

近年来，计算流体力学(CFD)已成为研究温室内气流和热分布的有力工具[15-17]。与现场风洞实验相比，CFD具有成本低、不受时空限制等优势[18-20]。Cheng等分别研究了多跨温室和玻璃温室的自然通风率和气流模式，可设计出气流与风速的良好平衡[21]。Benni等(2016)通过CFD模拟比较了屋顶通风口配置方案以优化Venlo温室通风[22]。同时，与现场实验中固定测量点相比，CFD可模拟温室内任意空间位置的气流和热分布。但由于CFD基于自然环境条件进行简化，在结果推广前需进行实验验证以确保模拟结果的客观性。

本研究以Venlo实验温室中的番茄为3D模型对象，采用K-ε湍流模型和离散坐标(DO)辐射模型分析温室内不同工况下的温度分布，获得3D番茄表面的热分布特征。此外还讨论了温室内不同高度的气流速度。结果表明适当通风可避免植株表面热量持续积累，并详细呈现番茄不同部位的热量分布。

本文的创新点在于：1) 结合现场实验和CFD模拟，研究考虑太阳辐射强度和环境温度变化时不同高度通风速度对番茄生长的影响；2) 所提模型为提高检测精度提供理论参考。后续章节将首先介绍番茄3D模型和Venlo温室结构，继而阐述番茄植株与周围空气的热交换过程，简要说明温室内气流和太阳辐射的数学模型，并通过现场实测验证相应的CFD程序。最后利用验证后的数值模拟程序模拟不同时段温室内的气流分布和热分布。3D温度分布结果有助于种植者制定更好的温室气候控制策略，理论上比热成像仪提供更精确的温度分布。

# 2. 材料与方法

# 2.1. 数学模型

实验温室用于为番茄植株提供光照和通风条件。同时，采用计算流体力学(CFD)技术模拟空气流动、热传递和温度分布。数值模型将通过系列实验数据进行验证。

# 2.1.1. 计算流体力学模型

计算流体力学模型及代码由一组微分方程表示，包括连续性方程、动量方程和能量方程，这些方程可在先前文献[23-25]中找到。这些守恒方程的通用形式可表示为：

$$
\frac{\partial}{\partial\tau} (\rho \phi) = \frac{\partial}{\partial x_j}\left(\Gamma_\rho \frac{\partial\phi}{\partial x_j} -\rho u_j\phi\right) + S_\phi \tag{1}
$$

式中$\Phi$为通用变量（连续性方程中为1）；$\mathbb{P}$为密度；$u_{j}$为动量方程；$x_{j}$为$\mathbf{x}$轴方向；$\tau$为能量方程；$k_{i}$$\epsilon$为湍流方程；$\Gamma_{\mathrm{p}}$为扩散系数；$\mathbf{S}_{\phi}$为源项[26]。

# 2.1.2. 太阳辐射模型

太阳辐射是影响温室内温湿度场分布的重要环境因子，模拟过程中需考虑热传递过程[27,28]。本研究采用离散坐标(DO)辐射模型模拟太阳辐射对温室的影响，并采用太阳光线追踪算法模拟太阳光线。标准k-ε湍流模型用于考虑湍流浮力效应和近壁湍流剪切转换。在固体壁面附近采用壁面对数定律，使用壁面函数建立沿壁面的完全湍流和粘性流动。DO辐射模型通过灰带模型计算，可进行灰体辐射计算和非灰体计算，因此该辐射模型用于求解Venlo温室的辐射传热。将DO辐射模型加入CFD模型，模拟通风温室屋顶和覆盖层的对流传递与辐射交换耦合，替代基于能量平衡的传统耦合方法。该模型用于计算通风温室屋顶和覆盖层的耦合辐射与对流交换。

对于具有吸收、发散和散射特性的介质，需求解以下辐射传递方程[29]，同时通过源项$S_{n}$将吸收的太阳辐照度加入能量方程：

$$
\begin{array}{l}\nabla \cdot \left(I\left(\underset {r}{\rightarrow},\underset {s}{\rightarrow}\right)\underset {s}{\rightarrow}\right) + (a + \sigma_{s})I\left(\underset {r}{\rightarrow},\underset {s}{\rightarrow}\right)\\ = a n^{2}\frac{\sigma\overline{T}^{4}}{\pi} +\frac{\sigma_{s}}{4\pi}\int_{0}^{4\pi}I\left(\underset {r}{\rightarrow},\underset {s}{\rightarrow}\right)\phi \left(\underset {s}{\rightarrow},\underset {s^{\prime}}{\rightarrow}\right)d\Omega^{\prime} \end{array} \tag{2}
$$

式(2)中，$\overrightarrow{r}$为位置矢量；$\overrightarrow{s}$为方向矢量；$\overrightarrow{s}$为散射方向矢量；s为行程长度$(\mathfrak{m})$；I为辐射强度$(W / m^2)$，取决于位置和方向；a和$n$分别为吸收系数和折射率；$\sigma$为斯特藩-玻尔兹曼常数$[5.67\mathrm{e}^{- 8}\mathrm{W}/(\mathbf{m}^2\cdot \mathbf{K}^4)]$；$\sigma_{s}$为散射系数；$\overline{T}$为平均温度$(^\circ \mathbb{C})$；$\Phi$为相位函数；$\Omega^{\prime}$为立体角。在本模型中，空气-水蒸气包层被视为非参与介质。

除太阳辐射对温室热负荷的贡献外，番茄植株还通过显热和潜热与空气交换能量，影响气流分布。叶片能量平衡可由下式表示：

$$
R_{net} = 2h_{c}\Delta (T_{Leaf} - T_{Air}) + Q_{lat} \tag{3}
$$

式中$R_{net}$为辐射净通量$(W / m^2)$；$2h_{c}\Delta (T_{Leaf} - T_{Air})$为叶片通过热对流传递给空气的显热通量$(W / m^2)$；$h_c$为对流换热系数$[\mathsf{W} / (\mathsf{m}^2\cdot \mathsf{k})]$，取值为$5[\mathsf{W} / (\mathsf{m}^2\cdot \mathsf{k})]$[30]；$T_{Leaf}$为番茄叶片温度；$T_{\mathrm{air}}$为叶片周围空气温度；$\Delta (T_{Leaf} - T_{Air})$为空气与叶片的温差(K)，后续田间实验测得0:00、4:00、8:00、12:00、16:00、20:00时分别为$4.1\mathrm{K}$、$4.3\mathrm{K}$、$-1.3\mathrm{K}$、$-3.5\mathrm{K}$、$-1.6\mathrm{K}$、$1.6\mathrm{K}$，由此可推断显热通量值。

$Q_{lat}$为通过蒸腾作用离开叶片的潜热通量$(W / m^2)$。在0:00、4:00、8:00、12:00、16:00和20:00时，$Q_{lat}$值分别为$-36.84\mathrm{W} / \mathrm{m}^2$、$-37.29\mathrm{W} / \mathrm{m}^2$、$15.05\mathrm{W} / \mathrm{m}^2$、$25.28W / m^2$、$2.42W / m^2$和$-15.42W / m^2$。通过式(3)可计算$R_{net}$值。

# 2.2. 温室环境下的3D番茄模型

由于番茄外形多样，仅按尺寸简化为统一3D模型。根据图1(b)中番茄实际形状，将茎、枝、叶简化为规则3D模型，温室中的3D番茄植株模型按1:1比例通过SolidWorks构建，如图1(b)所示。模型包含139片叶和16个分枝，每分枝最少8片、最多14片叶，高度$0.2\text{m}$，最小叶面积$0.12cm^2$，最大叶面积$0.8cm^2$，最大茎长$98.62~\mathrm{mm}$、直径$1.8~\mathrm{mm}$，最小茎长$25.80 \mathrm{mm}$、直径$0.7\mathrm{mm}$。茎距分布：按照番茄实际随机分布原则。

番茄植株置于提供光照和通风的小型实验温室中，测量温室位于中国北京，实验在夏季进行。温室体积为$1\mathrm{m}$(长)×$0.6\mathrm{m}$(宽)×$0.5\mathrm{m}$(高)，由亚克力板构建并内置培养槽，如图1(a)和(c)所示。培养槽共可容纳12株番茄，呈2行6列分布。为提高进气流均匀性并保持与Venlo温室相同的内部气候，在对称墙上开设三个外窗。温室屋顶由十个V形亚克力板组成。前后墙各设四个$0.08\mathrm{m}×0.06\mathrm{m}$的窗户作为新风入口。通风系统由机械通风和自然通风组成。

# 2.3. CFD模型细节与设置条件

采用SolidWorks建立温室的三维计算模型，尺寸为$1\mathrm{m}$(长)×$0.6\mathrm{m}$(宽)×$0.5\mathrm{m}$(高)。根据Venlo温室内番茄环境需求，设计了番茄植株、进风口和出风口，以提供与实际温室相同的气候条件。CFD模型共构建约20,274,710个网格单元，包含3,403,693个节点，平均梯度为0.84235，最小网格尺寸$0.00899\mathrm{mm}$。在番茄植株和通风口附近自动应用更精细的网格，计算前采用平均偏斜度$(0.2\pm 0.1)$检验网格质量，提高了数值计算的稳定性和精度。

表1展示了三维CFD模型的设置参数、边界条件和数值参数。采用速度入口(Velocity-Inlet)和压力出口(pressure-outlet)设置数值求解的边界条件，应用DO辐射模型和太阳光线追踪算法，设置地理经纬度$(39.9^{\circ}\mathrm{N}, 116.3^{\circ}\mathrm{E})$与实际温室位置一致。初始温度设置为$295.2\mathrm{K}$(0:00)、$293.757\mathrm{K}$(4:00)、$299.945\mathrm{K}$(8:00)、$308.695\mathrm{K}$(12:00)、$306.201\mathrm{K}$(16:00)、$300.636\mathrm{K}$(20:00)。表2汇总了空气、番茄作物、塑料外壳和土壤的热物理参数。由于植物光合作用和呼吸作用产生的热量受环境温度变化影响较小，因此忽略番茄光合作用和蒸腾作用的影响。

![](images/fb81a6ecf187f569d699d5ed649ae8c6b1f41494d1ec0cb5cf0a2dd7e877fdff.jpg)  
(a) 中国北京实验Venlo温室

![](images/71f0a5ea41a36c2e1503f9a27e243fc2e3189f6ed4bbc2b516923b0d45701212.jpg)  
(b) 简化番茄植株3D模型

![](images/06fe240bc3f0b01ff11ef02b04a7bb6df719360c228887545e16cc9791c2341b.jpg)  
(c) 含番茄的Venlo温室3D模型

图1 - 实验Venlo温室示意图(a)、番茄3D模型(b)和建模温室几何结构(c)，其中符号tomato 2.1表示植株种植在第2行第2列

采用稳态求解CFD模型，最小二乘法求解梯度项。压力项基于物体重量选择，能量项为二阶迎风型，其余为一阶迎风型。采用耦合算法提高计算精度。能量残差收敛因子设为$10e^{-6}$，其余设为$10e^{-3}$作为计算是否满足收敛标准的判断依据。

前期研究表明温室内气流呈高度湍流状态[31]。为简化温室壁面区域计算，湍流模型采用标准k-ε模型描述室内气体流动状态。Fluent可提供Rosseland、P1、Discrete Transfer、Surface to Surface和Discrete Ordinates等辐射模型。为模拟温室覆盖材料对室内太阳辐射分布的影响并求解半透明介质的辐射传递问题，采用DO辐射模型描述太阳辐射的热效应。考虑温室覆盖材料对太阳辐射的选择性，采用太阳光线追踪(Solar Ray Tracing)描述材料吸收特性。

# 2.4. 现场实测验证CFD模拟结果

在中国农业大学(北京，$39.9^{\circ}\mathrm{N}, 116.3^{\circ}\mathrm{E}$)的温室模型中进行风速和温度验证实验。在温室前墙四个窗口($0.06\mathrm{m}×0.08\mathrm{m}$)处放置同品牌风机作为送风源，后墙四个窗口($0.06\mathrm{m}×0.08\mathrm{m}$)作为出风口。气流从前墙通风口进入温室，从后墙通风口排出，满足植物光合作用等生理活动需求。

采用Testo 435-1风速传感器(图2(a))(叶轮风速探头直径$60\mathrm{mm}$，精度：$\pm(0.1\mathrm{m/s}+1.3\%$测量值)，量程：$0.25-20\mathrm{m/s}$，工作温度：$0-60^{\circ}\mathrm{C}$)测量并将前进风口风速调整为$1.2\mathrm{m/s}$。Testo 435-1光照探头传感器(图2(a)右)(量程：$0-100000\mathrm{Lux}$，精度：$\pm1.1\%$读数)用于测量温室内光照强度。

温室内番茄植株空间分布如图2(b)和(c)所示。为验证温室通风中风速规律性，测量了温室内不同位置的风速。共设置12个测点，测点选择如图2(d)和(e)所示。

采用Testo 435-1温度传感器(图2(a))(精度：±0.2°C，测量范围：-20至+70°C，探杆直径：12mm，探杆套管长度：140mm，电缆长度：1160mm)测量温室内不同高度温度。测点每4cm设置一个，共设6个测点。测点选择如图2(g)所示。

表1- 模拟条件设置

| 模型参数 | 设置 | 流体 | 固体 |
|---------|------|------|------|
| 能量 | 开启 | 空气 | 作物 |
| 粘性 | k-ε标准模型 | - | 玻璃 |
| 辐射 | DO模型 | - | 土壤 |
| 太阳载荷 | 太阳光线追踪 | - | - |

表2- 材料物理参数

| 材料 | 密度(kg/m³) | 比热容[J/(kg·K)] | 导热系数[W/(m·K)] | 折射率 | 吸收系数 |
|------|------------|-----------------|------------------|-------|---------|
| 空气 | 1.225 | 1006 | 0.02 | 1.00 | 0.15 |
| 植物 | 560 | 2100 | 0.19 | 2.77 | 0.35 |
| 塑料 | 2220 | 830 | 1.38 | 1.50 | 0.08 |
| 土壤 | 1700 | 1010 | 0.8 | 1.92 | 0.50 |

从图2(f)可以看出，番茄植株周围的风速与通风口的距离和角度高度相关，CFD模拟结果与温室内相同空间位置的测量结果一致。计算结果与实测数据的标准偏差在$0.055\mathrm{m/s}$以内。

同样，从图2(h)可以看出，CFD模拟数据与温室内相同高度的测量结果一致。计算结果与实测数据的标准偏差在$0.069\mathrm{K}$以内，这确保了计算程序的可靠性。

# 3. 结果与讨论

夏季适宜的机械通风可以缓解高温影响，为番茄生长创造适宜环境。同时还能保证番茄光合作用和呼吸作用所需的空气和温度供应。

首先基于3D模型，讨论了番茄表面温度随时间(0:00 4:00 8:00 12:00 16:00 20:00)的变化规律。然后揭示了水平距离$(\mathbf{x} = 2\mathbf{cm},\mathbf{x} = 4\mathbf{cm},\mathbf{x} = 6\mathbf{cm})$对周围环境热效应的影响。最后展示了通风条件下番茄周围的气流分布情况。

# 3.1. 太阳辐射对温室内3D番茄微气候的影响

在先前研究中，部分学者关注作物蒸腾速率和室内最高气温对温室微气候的影响。例如Illouz-Eliaz等发现番茄最大蒸腾速率出现在12:00[26]，同样我们温室内现场测量数据(图3)也在同一时刻达到最大值$35.545~^\circ \mathrm{C}$。从小窗口进入的新鲜空气流入温室，并维持在Nsupply(送风速度)$= 0.5\mathrm{m/s}$和Tsupply(送风温度)$= 35.545~^\circ \mathrm{C}$。随后应用该通风模式建立了稳定的温室热量分布模型。

如图4(a)所示，受热空气和太阳辐射影响的土壤附近和番茄冠层上方温度较高(约$35^{\circ}C)$，番茄周围平均温度接近$30^{\circ}C$。结果表明，白天12点的太阳辐射在番茄周围形成显著的垂直热分层，温室内的热量分布均匀。保持$\mathbb{N}_{\mathrm{supply}}$(送风速度)$= 0.5\mathrm{m/s}$并在0:00进行相同研究(如图4(b)所示)。此时室内外热交换主要依靠空气流动，番茄生理活动产生的热量通过气流传递，实现与外界环境的持续交换。温度介于$20^{\circ}C$和$22^{\circ}C$之间。

# 3.2. 番茄表面温度与微气候关系分析

太阳辐射会影响温室内外的热传递过程。除时间变化外，仍采用上述控制参数和边界条件，同时保持送风速度$N_{\mathrm{supply}}$为$0.5\mathrm{m/s}$

图5展示了3D番茄叶片的平均温度。随着太阳辐射和蒸腾速率的增加，番茄周围温度差异增大。3D番茄模拟结果表明：番茄自身温度会随周围温度升高而增加，同时图中曲线显示番茄表面温度变化与太阳辐射的周期性变化基本一致。番茄本体温度波动和叶面温度也会随辐射强度的变化产生更明显的影响。

![](images/3547076ced459d3f35ed0e463034667355e74fb86ac45ad82f1af4345ed718f1.jpg)  
(a) 温度(左)、风速(中)和示意图(右)传感器

![](images/1cb409e659d2b25d85bee54b2f1d51f3c5da35c161dc514f3dc486b1510c282e.jpg)

(b) Venlo温室前视图

(c) Venlo温室顶视图

![](images/84a97750b05625bb5af276efd3f8aad3004c5efa88fa394f844b522954c637ac.jpg)  
(d) 测点前视图

![](images/cd83235658913a0230ac772209bcad14d8c1e7c0295f43d74d8079af6efa74e1.jpg)  
(e) 测点顶视图

![](images/39cc2a15b2eee6305375fd2364276e078230fc6a2d9785cc3a926f342ecb6a4d.jpg) 
(f) CFD模拟结果与实测风速结果对比

图2. 温室内番茄植株空间分布及测点布置

同时，模拟结果显示番茄植株垂直方向温差较大，夏季尤为明显。特别是在12:00时(x=2cm处)，根冠最大温差约为4K。图6(a)、(b)和(c)显示，随着与番茄水平距离的增加(x=4cm, x=6cm)，番茄对周围环境的热影响减弱，中午12:00时(x=6cm处)番茄冠层与根系的温差减小50%(约2K)。图6(b)和(c)中也呈现相同规律。

同样地，夜间测点与番茄的水平距离也存在类似关系。我们选取三个点(x=2cm,4cm,6cm)作为研究对象，展示了夜间不同时刻番茄的热量分布情况。根据3D模拟结果，凌晨4:00(x=2cm处)根冠最大温差约为3.5K。随着与番茄水平距离的增加(x=4cm,x=6cm)，番茄对周围环境的热影响减弱。凌晨4:00(x=4cm处)番茄冠层与根系温差约为2.5K，凌晨4:00(x=6cm处)番茄冠层与根系温差约为2.5K。番茄昼夜周围热量分布规律表明，番茄对周围环境的热效应随水平距离增加而减弱(见图7)。

![](images/a54b903b94f8634320482811cd02b0cf456ad3aa49a89afb89d527efdeb99f76.jpg)  
图3 - 2020年7月20日温室内温度分布

![](images/9cf48bb3ebd6b9957231e058c60eaebcfa3d5e7e9c1a9691dd65e133e4ad7938.jpg)  
图4 - 温室内温度分布示意图

![](images/500fa00798ec5509e408128122e9312a672c209d30f2795f75f7aa418dd51a3d.jpg)  
图5 - 番茄叶片平均温度

# 3.3. 番茄植株周围温度分布与微气候分析

从图8可以看出，上午8:00由于太阳辐射强度较低，大部分辐射被番茄冠层吸收，在番茄周围形成明显的垂直温度分层。番茄冠层与根系温差为1.8K。正午时分，太阳辐射达到最大值(约17.34MJ/m²)，番茄蒸腾作用和热交换强烈。上述结果与前期研究一致，例如番茄蒸腾速率在正午达到最大，这与之前的研究[26]相符。夜间番茄的加热效应较为微弱。地面与空气之间形成对流，热量从地面向空气中耗散，形成明显的垂直温度分层。由于番茄自身呼吸作用，此时番茄温度高于环境温度，与白天情况相反(见图9)。

# 3.4. 通风条件下的3D番茄植株生长

气流在负浮力作用下向土壤下沉，而在正浮力作用下在冠层周围上升。因此，气流最密集点出现在番茄冠层略上方(H≈11cm)，平均风速值为0.28m/s，而番茄底部平均风速值仅为0.12m/s，容易导致病原微生物聚集。总之，由于番茄冠层的存在，温室内会形成不同的气流层，这些气流层相互作用形成复杂的温室气流循环。

从物理角度来看，气流受到多种流动力的影响，包括自然通风和热羽流力。送风气流会下沉，而冠层周围的气流则因正浮力作用上升。这些气流相互影响，形成复杂的流动循环（如图10所示）。番茄周围的空气微循环会阻碍温室污染物（如氮氧化物、磷氧化物和细菌[32]）的清除，容易导致空气质量下降并引发病害。因此，应扩大番茄植株间距以减少相互干扰，创造适宜的呼吸环境。

![](images/212601aa0fd61684edc6854990000ec3dc5b85a3a5ac83418afb674992a5ea0b.jpg)  
图6 - 白天番茄植株周围热量分布示意图  
图7 - 夜间番茄植株周围热量分布示意图

![](images/7b38900f040d203e879e33d7257f976013977af7b93ffe730f13441234c80ec6.jpg)  
图8 - 番茄本体温度(2:1)在8:00、12:00、16:00、20:00、0:00、4:00的变化

![](images/c277340c505cd657662097d67be0f25ca6f87713e77c5a127c735ac7e8633985.jpg)  
图9 - 番茄周围风速随高度的变化关系

# 3.5. 讨论

为研究夏季番茄表面及周围环境的温度分布，本研究采用SolidWorks构建番茄3D模型。与Zhang Yue等使用开源建模平台Groimp[29]建立的详细番茄模型相比，本模型假设番茄各部位具有相同的热力学特性和辐射特性。由于太阳辐射对茎叶的影响不同，该模型未能充分反映番茄茎叶热特性的差异。同时，本模型简化了番茄光合作用和呼吸作用的影响，通过建立潜热和显热数学模型，充分揭示了番茄的热特性，因此这些简化是可接受的。

温室内包括番茄冠层温度在内的微气候参数详细分布，对番茄适宜栽培和增产具有重要作用。本文番茄3D模型仅对部分枝叶进行了修改。与以往2D模型研究相比，空间精度得到了预期提升。结果表明该模型能反映番茄周围温度分布和冠层温度分布，为番茄温室的合理通风和节能降耗提供了参考依据。

![](images/783e90ac6399b6aae01f57c2de2e6b1a4ce7642b7867a94091ee8cbe924449f4.jpg)  
图10 - 温室内气流分布示意图

在以往研究中，温室作物通常被视为多孔介质进行模拟，模拟结果与实验数据吻合良好。而在本研究中，番茄被视为固体，未设置多孔介质相关参数，但在3D模型细化情况下仍能表现出良好的一致性，这将在未来研究部分进行讨论。

# 4. 结论

夏季适宜的机械通风可缓解高温影响，为番茄生长创造适宜环境。

本文通过数值模拟和实验研究了不同送风温度和辐射强度对Venlo试验温室通风及番茄热分层的影响，分析了温度分布和通风效果。CFD模型和数值结果通过现场实测数据验证，主要科学结论如下：

(1) 中午12:00番茄蒸腾速率达到最大值，导致冠层与土壤温差约$5\mathrm{K}$。此时太阳辐射会形成显著的垂直热分层，并在温室内建立均匀的热量分布。晚上8:00，温室内番茄植株蒸腾产生的热量通过外部气流被动传递，通风作用使温室热量耗散。此时空气温度介于$20^{\circ}C$和$22^{\circ}C$之间。结果表明夏季番茄周围热量分布呈现由太阳辐射引起的显著周期性变化。正午时分番茄植株表面温度过高，易发生高温病变，需提前进行机械通风。

(2) 番茄昼夜周围热量分布表明，番茄对周围环境的热效应随水平距离增加而显著减弱。因此，难以准确获取番茄周围的热量分布。本研究基于热力学理论获得了番茄外围温度，为提高检测精度提供了理论参考。

(3) 在通风条件下，番茄冠层两侧气流存在明显差异。病原微生物易在底部聚集引发病害。番茄周围的空气微循环会阻碍温室污染物的清除。因此，3D模型研究可为合理通风提供指导。

本研究可为提高热像仪检测精度提供理论指导，并有助于设计适宜番茄植株生长的热环境。

# 利益冲突声明

作者声明不存在任何可能影响本研究报告的已知竞争性经济利益或个人关系。

# 致谢

本研究得到以下项目的资助：2019年中马科技合作基金"循环水养殖系统早期鱼类实时精准监测系统研究与示范"(AquaDetector，项目编号2019YFE0103700)、海外高层次青年人才计划(中国农业大学，项目编号62339001)、中国农业大学优秀人才计划(项目编号31051015)、2019年山东省重点研发计划(项目编号2019JZY010103)、国家数字渔业创新中心和农业农村部农业物联网技术重点实验室。作者也感谢审稿人提出的建设性意见。

## 参考文献

1.  [\[1\]](#bb0005)
Y. Zhang, M. Kacira, L. An
基于CFD的室内植物工厂系统气流均匀性改善研究
Biosyst Eng, 147 (2016), pp. 193-205
2.  [\[2\]](#bb0010)
T. Boulard, J.-C. Roy, J.-B. Pouillard, H. Fatnassi, A. Grisey
基于计算流体动力学的封闭温室微气象、冠层蒸腾和光合作用建模
Biosyst Eng, 158 (2017), pp. 110-133
3.  [\[3\]](#bb0015)
A.M. Endalew, M. Hertog, M.G. Gebrehiwot, M. Baelmans, H. Ramon, B.M. Nicolaï, _et al._
采用综合方法模拟模型植物冠层内的气流
Comput Electron Agric, 66 (1) (2009), pp. 9-24
4.  [\[4\]](#bb0020)
A. Kichah, P.-E. Bournet, C. Migeon, T. Boulard
温室中凤仙花盆栽作物小气候特征及蒸腾作用的测量与CFD模拟
Biosyst Eng, 112 (1) (2012), pp. 22-34
5.  [\[5\]](#bb0025)
G.-Q. Qu, X. Liu, Y.-L. Zhang, D. Yao, Q.-M. Ma, M.-Y. Yang, _et al._
番茄果实热应激反应中程序性细胞死亡和特定类半胱天冬酶激活的证据
Planta, 229 (6) (2009), pp. 1269-1279
6.  [\[6\]](#bb0030)
Y.-L. Ruan, Y.e. Jin, Y.-J. Yang, G.-J. Li, J.S. Boyer
转化酶介导的糖输入、代谢和信号传导：在发育、产量潜力及干旱热应激响应中的作用
Mol Plant, 3 (6) (2010), pp. 942-955
7.  [\[7\]](#bb0035)
M.M. Raja, G. Vijayalakshmi, M.L. Naik, P.O. Basha, K. Sergeant, J.F. Hausman, _et al._
热胁迫下花粉发育与功能：从效应到响应
Acta Physiol Plant, 41 (4) (2019), [10.1007/s11738-019-2835-8](https://doi.org/10.1007/s11738-019-2835-8)
8.  [\[8\]](#bb0040)
J. Larkindale, J.D. Hall, M.R. Knight, E. Vierling
拟南芥突变体的热应激表型揭示获得耐热性的多重信号通路
Plant Physiol, 2138 (2005), pp. 882-897, [10.1104/pp.105.062257](https://doi.org/10.1104/pp.105.062257)
9.  [\[9\]](#bb0045)
W. Xu, R. Li, N. Zhang, F. Ma, Y. Jiao, Z. Wang
极端耐寒中国野生葡萄Vitis amurensis的转录组分析揭示与冷胁迫相关的候选基因和事件
Plant Mol Biol, 86 (4-5) (2014), pp. 527-541
10.  [\[10\]](#bb0050)
F. Han, C. Chen, Q. Hu, Y. He, S. Wei, C. Li
太阳能温室中具有潜热储存的主动-被动通风墙热性能评估建模方法
Energy Build, 238 (2021), p. 110840, [10.1016/j.enbuild.2021.110840](https://doi.org/10.1016/j.enbuild.2021.110840)
11.  [\[11\]](#bb0055)
G. Nikolaou, D. Neocleous, E. Kitta, N. Katsoulas
基于瞬时叶片温度测量的地中海温室空气动力学和冠层阻力估算
Agronomy, 1210 (2020), p. 1985, [10.3390/agronomy10121985](https://doi.org/10.3390/agronomy10121985)
12.  [\[12\]](#bb0060)
R. Sherzod, E.Y. Yang, M.C. Cho, S.Y. Chae, W.B. Chae
番茄(Solanum lycopersicum L.)中与高温耐受性相关的生理特性因果实类型和大小而异
Horticult, Environ, Biotechnol, 561 (2020), pp. 837-847, [10.1007/s13580-020-00280-4](https://doi.org/10.1007/s13580-020-00280-4)
13.  [\[13\]](#bb0065)
A. Pakari, S. Ghani
配备风塔的自然通风温室气流评估：数值模拟与风洞实验
Energy Build, 199 (2019), pp. 1-11, [10.1016/j.enbuild.2019.06.033](https://doi.org/10.1016/j.enbuild.2019.06.033)
14.  [\[14\]](#bb0070)
S.A. Ould Khaoua, P.E. Bournet, C. Migeon, T. Boulard, G. Chassériaux
基于计算流体力学的温室通风效率分析
Biosyst Eng, 195 (2006), pp. 83-98, [10.1016/j.biosystemseng.2006.05.004](https://doi.org/10.1016/j.biosystemseng.2006.05.004)
15.  [\[15\]](#bb0075)
M.R.O. Odhiambo, A. Abbas, X. Wang, E. Elahi
长江三角洲地区加热Venlo型温室的热环境评估
Sustain-Basel, 2412 (2020), p. 10412, [10.3390/su122410412](https://doi.org/10.3390/su122410412)
16.  [\[16\]](#bb0080)
C.E. Aguilar-Rodriguez, J. Flores-Velazquez, W. Ojeda-Bustamante, F. Rojano, M. Iñiguez-Covarrubias
使用数值模拟评估带电动加热器的温室能源性能
Processes, 58 (2020), p. 600, [10.3390/pr8050600](https://doi.org/10.3390/pr8050600)
17.  [\[17\]](#bb0085)
X. Liu, H. Li, Y. Li, X. Yue, S. Tian, T. Li
基于计算流体力学的北墙内表面结构对中国日光温室热微气候的影响
PLoS One, 415 (2020), p. e231316, [10.1371/journal.pone.0231316](https://doi.org/10.1371/journal.pone.0231316)
18.  [\[18\]](#bb0090)
S.J. Schymanski, D. Or
风对叶片蒸腾的影响挑战"潜在蒸发"概念
Proc Int Assoc Hydrol Sci, 371 (2015), pp. 99-107, [10.5194/piahs-371-99-2015](https://doi.org/10.5194/piahs-371-99-2015)
19.  [\[19\]](#bb0095)
F. Zhao, D. Liu, G. Tang
狭缝通风围护结构中的多重稳态流体流动
Int J Heat Fluid Fl, 529 (2008), pp. 1295-1308, [10.1016/j.ijheatfluidflow.2008.06.005](https://doi.org/10.1016/j.ijheatfluidflow.2008.06.005)
20.  [\[20\]](#bb0100)
D. Liu, F. Zhao, H. Wang, E. Rank
带有新型空调装置的住宅房间内空气污染物的湍流传输
Int J Refrig, 535 (2012), pp. 1455-1472, [10.1016/j.ijrefrig.2012.04.011](https://doi.org/10.1016/j.ijrefrig.2012.04.011)
21.  [\[21\]](#bb0105)
F. Zhao, D. Liu, G. Tang
流线、热线和质量线在共轭传热传质中的应用问题
Int J Heat Mass Trans, 1–250 (2007), pp. 320-334, [10.1016/j.ijheatmasstransfer.2006.06.026](https://doi.org/10.1016/j.ijheatmasstransfer.2006.06.026)
22.  [\[22\]](#bb0110)
M. Keshtkar, M. Eslami, K. Jafarpur
盆地太阳能蒸馏器瞬态CFD建模的新方法：组分方程与能量方程的耦合
Desalination, 481 (2020), p. 114350, [10.1016/j.desal.2020.114350](https://doi.org/10.1016/j.desal.2020.114350)
23.  [\[23\]](#bb0115)
H. Fang, K. Li, G. Wu, R. Cheng, Y. Zhang, Q. Yang
考虑作物阻力和LED散热的植物工厂生菜冠层气流分布改善CFD分析
Biosyst Eng, 200 (2020), pp. 1-12, [10.1016/j.biosystemseng.2020.08.017](https://doi.org/10.1016/j.biosystemseng.2020.08.017)
24.  [\[24\]](#bb0120)
L. Yanhua, Z. Zhixiong, G. Jiaming, L. Enli, M. Qinglin
CO2富集对温室流场影响的数值模拟与实验验证
Trans Chin Soc Agric Eng, 1231 (2015), pp. 194-199
25.  [\[25\]](#bb0125)
K. Kimura, _et al._
空气管道加热温室中循环风机对流作用下番茄冠层叶边界层导度
Environ Control Biol, 454 (2016), pp. 171-176, [10.2525/ecb.54.171](https://doi.org/10.2525/ecb.54.171)
26.  [\[26\]](#bb0130)
N. Illouz-Eliaz, I. Nissan, I. Nir, U. Ramon, H. Shohat, D. Weiss
番茄赤霉素受体突变抑制木质部增殖并减少水分亏缺条件下的水分流失
J Exp Bot, 1271 (2020), pp. 3603-3612, [10.1093/jxb/eraa137](https://doi.org/10.1093/jxb/eraa137)
27.  [\[27\]](#bb0135)
R. Nebbali, J.C. Roy, T. Boulard
种植温室内分布式辐射和对流气候的动态模拟
Renew Energy, 43 (2012), pp. 111-129, [10.1016/j.renene.2011.12.003](https://doi.org/10.1016/j.renene.2011.12.003)
28.  [\[28\]](#bb0140)
S. Benni, P. Tassinari, F. Bonora, A. Barbaresi, D. Torreggiani
温室自然通风效果评估：案例研究的环境监测与CFD模拟
Energ Build, 125 (2016), pp. 276-286, [10.1016/j.enbuild.2016.05.014](https://doi.org/10.1016/j.enbuild.2016.05.014)
29.  [\[29\]](#bb0145)
Y. Zhang, _et al._
番茄冠层结构下太阳能温室模型光气候与热性能的高分辨率3D模拟
Renew Energy, 160 (2020), pp. 730-745, [10.1016/j.renene.2020.06.144](https://doi.org/10.1016/j.renene.2020.06.144)
30.  [\[30\]](#bb0150)
G. Yin, _et al._
沼液灌溉下N2O和CO2排放及氮素利用效率：华北平原连续两季小麦-玉米轮作田间研究
Agric Water Manage, 212 (2019), pp. 232-240, [10.1016/j.agwat.2018.08.038](https://doi.org/10.1016/j.agwat.2018.08.038)
31.  [\[31\]](#bb0155)
M. Teitel, E. Wenger
单跨温室通过纵向侧开口一进一出的空气交换与通风效率
Biosyst Eng, 119 (2014), pp. 98-107, [10.1016/j.biosystemseng.2013.11.001](https://doi.org/10.1016/j.biosystemseng.2013.11.001)
32.  [\[32\]](#bb0160)
X. He, _et al._
基于CFD的可拆卸后墙太阳能温室通风优化
Comput Electron Agric, 149 (2018), pp. 16-25, [10.1016/j.compag.2017.10.001](https://doi.org/10.1016/j.compag.2017.10.001)

## References

1.  [\[1\]](#bb0005)
Y. Zhang, M. Kacira, L. An
A CFD study on improving air flow uniformity in indoor plant factory system
Biosyst Eng, 147 (2016), pp. 193-205
2.  [\[2\]](#bb0010)
T. Boulard, J.-C. Roy, J.-B. Pouillard, H. Fatnassi, A. Grisey
Modelling of micrometeorology, canopy transpiration and photosynthesis in a closed greenhouse using computational fluid dynamics
Biosyst Eng, 158 (2017), pp. 110-133
3.  [\[3\]](#bb0015)
A.M. Endalew, M. Hertog, M.G. Gebrehiwot, M. Baelmans, H. Ramon, B.M. Nicolaï, _et al._
Modelling airflow within model plant canopies using an integrated approach
Comput Electron Agric, 66 (1) (2009), pp. 9-24
4.  [\[4\]](#bb0020)
A. Kichah, P.-E. Bournet, C. Migeon, T. Boulard
Measurement and CFD simulation of microclimate characteristics and transpiration of an Impatiens pot plant crop in a greenhouse
Biosyst Eng, 112 (1) (2012), pp. 22-34
5.  [\[5\]](#bb0025)
G.-Q. Qu, X. Liu, Y.-L. Zhang, D. Yao, Q.-M. Ma, M.-Y. Yang, _et al._
Evidence for programmed cell death and activation of specific caspase-like enzymes in the tomato fruit heat stress response
Planta, 229 (6) (2009), pp. 1269-1279
6.  [\[6\]](#bb0030)
Y.-L. Ruan, Y.e. Jin, Y.-J. Yang, G.-J. Li, J.S. Boyer
Sugar Input, Metabolism, and Signaling Mediated by Invertase: Roles in Development, Yield Potential, and Response to Drought and Heat
Mol Plant, 3 (6) (2010), pp. 942-955
7.  [\[7\]](#bb0035)
M.M. Raja, G. Vijayalakshmi, M.L. Naik, P.O. Basha, K. Sergeant, J.F. Hausman, _et al._
Pollen development and function under heat stress: from effects to responses
Acta Physiol Plant, 41 (4) (2019), [10.1007/s11738-019-2835-8](https://doi.org/10.1007/s11738-019-2835-8)
8.  [\[8\]](#bb0040)
J. Larkindale, J.D. Hall, M.R. Knight, E. Vierling
Heat stress phenotypes of arabidopsis mutants implicate multiple signaling pathways in the acquisition of thermotolerance
Plant Physiol, 2138 (2005), pp. 882-897, [10.1104/pp.105.062257](https://doi.org/10.1104/pp.105.062257)
9.  [\[9\]](#bb0045)
W. Xu, R. Li, N. Zhang, F. Ma, Y. Jiao, Z. Wang
Transcriptome profiling of Vitis amurensis, an extremely cold-tolerant Chinese wild Vitis species, reveals candidate genes and events that potentially connected to cold stress
Plant Mol Biol, 86 (4-5) (2014), pp. 527-541
10.  [\[10\]](#bb0050)
F. Han, C. Chen, Q. Hu, Y. He, S. Wei, C. Li
Modeling method of an active–passive ventilation wall with latent heat storage for evaluating its thermal properties in the solar greenhouse
Energy Build, 238 (2021), p. 110840, [10.1016/j.enbuild.2021.110840](https://doi.org/10.1016/j.enbuild.2021.110840)
11.  [\[11\]](#bb0055)
G. Nikolaou, D. Neocleous, E. Kitta, N. Katsoulas
Estimation of Aerodynamic and Canopy Resistances in a Mediterranean Greenhouse Based on Instantaneous Leaf Temperature Measurements
Agronomy, 1210 (2020), p. 1985, [10.3390/agronomy10121985](https://doi.org/10.3390/agronomy10121985)
12.  [\[12\]](#bb0060)
R. Sherzod, E.Y. Yang, M.C. Cho, S.Y. Chae, W.B. Chae
Physiological traits associated with high temperature tolerance differ by fruit types and sizes in tomato (Solanum lycopersicum L.)
Horticult, Environ, Biotechnol, 561 (2020), pp. 837-847, [10.1007/s13580-020-00280-4](https://doi.org/10.1007/s13580-020-00280-4)
13.  [\[13\]](#bb0065)
A. Pakari, S. Ghani
Airflow assessment in a naturally ventilated greenhouse equipped with wind towers: numerical simulation and wind tunnel experiments
Energy Build, 199 (2019), pp. 1-11, [10.1016/j.enbuild.2019.06.033](https://doi.org/10.1016/j.enbuild.2019.06.033)
14.  [\[14\]](#bb0070)
S.A. Ould Khaoua, P.E. Bournet, C. Migeon, T. Boulard, G. Chassériaux
Analysis of Greenhouse Ventilation Efficiency based on Computational Fluid Dynamics
Biosyst Eng, 195 (2006), pp. 83-98, [10.1016/j.biosystemseng.2006.05.004](https://doi.org/10.1016/j.biosystemseng.2006.05.004)
15.  [\[15\]](#bb0075)
M.R.O. Odhiambo, A. Abbas, X. Wang, E. Elahi
Thermo-Environmental Assessment of a Heated Venlo-Type Greenhouse in the Yangtze River Delta Region
Sustain-Basel, 2412 (2020), p. 10412, [10.3390/su122410412](https://doi.org/10.3390/su122410412)
16.  [\[16\]](#bb0080)
C.E. Aguilar-Rodriguez, J. Flores-Velazquez, W. Ojeda-Bustamante, F. Rojano, M. Iñiguez-Covarrubias
Valuation of the Energy Performance of a Greenhouse with an Electric Heater Using Numerical Simulations
Processes, 58 (2020), p. 600, [10.3390/pr8050600](https://doi.org/10.3390/pr8050600)
17.  [\[17\]](#bb0085)
X. Liu, H. Li, Y. Li, X. Yue, S. Tian, T. Li
Effect of internal surface structure of the north wall on Chinese solar greenhouse thermal microclimate based on computational fluid dynamics
PLoS One, 415 (2020), p. e231316, [10.1371/journal.pone.0231316](https://doi.org/10.1371/journal.pone.0231316)
18.  [\[18\]](#bb0090)
S.J. Schymanski, D. Or
Wind effects on leaf transpiration challenge the concept of &quot;potential evaporation&quot
Proc Int Assoc Hydrol Sci, 371 (2015), pp. 99-107, [10.5194/piahs-371-99-2015](https://doi.org/10.5194/piahs-371-99-2015)
19.  [\[19\]](#bb0095)
F. Zhao, D. Liu, G. Tang
Multiple steady fluid flows in a slot-ventilated enclosure
Int J Heat Fluid Fl, 529 (2008), pp. 1295-1308, [10.1016/j.ijheatfluidflow.2008.06.005](https://doi.org/10.1016/j.ijheatfluidflow.2008.06.005)
20.  [\[20\]](#bb0100)
D. Liu, F. Zhao, H. Wang, E. Rank
Turbulent transport of airborne pollutants in a residential room with a novel air conditioning unit
Int J Refrig, 535 (2012), pp. 1455-1472, [10.1016/j.ijrefrig.2012.04.011](https://doi.org/10.1016/j.ijrefrig.2012.04.011)
21.  [\[21\]](#bb0105)
F. Zhao, D. Liu, G. Tang
Application issues of the streamline, heatline and massline for conjugate heat and mass transfer
Int J Heat Mass Trans, 1–250 (2007), pp. 320-334, [10.1016/j.ijheatmasstransfer.2006.06.026](https://doi.org/10.1016/j.ijheatmasstransfer.2006.06.026)
22.  [\[22\]](#bb0110)
M. Keshtkar, M. Eslami, K. Jafarpur
A novel procedure for transient CFD modeling of basin solar stills: Coupling of species and energy equations
Desalination, 481 (2020), p. 114350, [10.1016/j.desal.2020.114350](https://doi.org/10.1016/j.desal.2020.114350)
23.  [\[23\]](#bb0115)
H. Fang, K. Li, G. Wu, R. Cheng, Y. Zhang, Q. Yang
A CFD analysis on improving lettuce canopy airflow distribution in a plant factory considering the crop resistance and LEDs heat dissipation
Biosyst Eng, 200 (2020), pp. 1-12, [10.1016/j.biosystemseng.2020.08.017](https://doi.org/10.1016/j.biosystemseng.2020.08.017)
24.  [\[24\]](#bb0120)
L. Yanhua, Z. Zhixiong, G. Jiaming, L. Enli, M. Qinglin
Numerical simulation and experimental verification of effect of CO2 enrichment on flow field of greenhouse
Trans Chin Soc Agric Eng, 1231 (2015), pp. 194-199
25.  [\[25\]](#bb0125)
K. Kimura, _et al._
Leaf boundary layer conductance in a tomato canopy under the convective effect of circulating fans in a greenhouse heated by an air duct heater
Environ Control Biol, 454 (2016), pp. 171-176, [10.2525/ecb.54.171](https://doi.org/10.2525/ecb.54.171)
26.  [\[26\]](#bb0130)
N. Illouz-Eliaz, I. Nissan, I. Nir, U. Ramon, H. Shohat, D. Weiss
Mutations in the tomato gibberellin receptors suppress xylem proliferation and reduce water loss under water-deficit conditions
J Exp Bot, 1271 (2020), pp. 3603-3612, [10.1093/jxb/eraa137](https://doi.org/10.1093/jxb/eraa137)
27.  [\[27\]](#bb0135)
R. Nebbali, J.C. Roy, T. Boulard
Dynamic simulation of the distributed radiative and convective climate within a cropped greenhouse
Renew Energy, 43 (2012), pp. 111-129, [10.1016/j.renene.2011.12.003](https://doi.org/10.1016/j.renene.2011.12.003)
28.  [\[28\]](#bb0140)
S. Benni, P. Tassinari, F. Bonora, A. Barbaresi, D. Torreggiani
Efficacy of greenhouse natural ventilation: Environmental monitoring and CFD simulations of a study case
Energ Build, 125 (2016), pp. 276-286, [10.1016/j.enbuild.2016.05.014](https://doi.org/10.1016/j.enbuild.2016.05.014)
29.  [\[29\]](#bb0145)
Y. Zhang, _et al._
High resolution 3D simulation of light climate and thermal performance of a solar greenhouse model under tomato canopy structure
Renew Energy, 160 (2020), pp. 730-745, [10.1016/j.renene.2020.06.144](https://doi.org/10.1016/j.renene.2020.06.144)
30.  [\[30\]](#bb0150)
G. Yin, _et al._
N2O and CO2 emissions, nitrogen use efficiency under biogas slurry irrigation: A field study of two consecutive wheat-maize rotation cycles in the North China Plain
Agric Water Manage, 212 (2019), pp. 232-240, [10.1016/j.agwat.2018.08.038](https://doi.org/10.1016/j.agwat.2018.08.038)
31.  [\[31\]](#bb0155)
M. Teitel, E. Wenger
Air exchange and ventilation efficiencies of a monospan greenhouse with one inflow and one outflow through longitudinal side openings
Biosyst Eng, 119 (2014), pp. 98-107, [10.1016/j.biosystemseng.2013.11.001](https://doi.org/10.1016/j.biosystemseng.2013.11.001)
32.  [\[32\]](#bb0160)
X. He, _et al._
Ventilation optimization of solar greenhouse with removable back walls based on CFD
Comput Electron Agric, 149 (2018), pp. 16-25, [10.1016/j.compag.2017.10.001](https://doi.org/10.1016/j.compag.2017.10.001)