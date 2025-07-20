# Optimum design of Chinese solar greenhouses for maximum energy availability

# 中国日光温室的最优设计以实现最大能量获取

Demin Xu a, Shuaipeng Fei a, Zhi Wang a, Jinyu Zhu b,**, Yuntao Ma a,*

a 中国农业大学土地科学与技术学院，中国北京  
b 中国农业科学院蔬菜花卉研究所，蔬菜生物育种国家重点实验室，北京 100081，中国

# 文章信息

# 摘要

关键词：日光温室 节能 园艺 能源经济 优化设计 可持续性

鉴于温室设施的老化，有必要研究现有温室的改造以最大化太阳能利用。本研究以北京地区的中国日光温室(CSG)作为优化原型。建立了数学模型来确定CSG顶点位置的范围，然后开发了3D动态仿真模型来优化温室结构，并确定能提供更好光温环境的采光屋面形状。使用有限元软件评估和设计了CSG钢骨架的结构安全性。优化后的温室显著改善了室内气候，特别是光环境。与原温室相比，优化后CSG的平均捕获太阳能增加了$5.4\mathrm{MJm}^{-2}$，平均温度提高了$3.1^{\circ}C$。不同采光屋面形状之间的太阳辐射和温度最大差异分别为$4.8\%$和$6.1\%$。此外，优化后的CSG钢骨架满足结构稳定性要求。CSG优化的投资回收期约为1.6年。这些方法和发现为老旧温室升级提供了有价值的设计策略，并可进一步应用于不同地区。

# 符号说明

| 符号 | 说明 | 符号 | 说明 |
|------|------|------|------|
| **顶点位置计算** |  | **辐射模型** |  |
| α | 采光屋面角度(°) | S | 入射总辐射(W) |
| θ | 屋面角度(°) | S0 | 太阳常数(W m−2) |
| θmax | 最大屋面角度(°) | τa | 大气透射率 |
| β | 太阳高度角(°) | λ | 纬度 |
| L | 跨度(m) | th | 太阳时 |
| L1 | 顶点到最南端水平距离(m) | td | 年积日 |
| L2 | 顶点到最北端植株水平距离(m) | δ | 太阳赤纬角(°) |
| L3 | 过道宽度(m) | Kt | 晴空指数 |
| L4 | 后屋面水平投影(m) | **热模型** |  |
| L5 | 保温被水平投影(m) | QRA | 内表面与室内空气对流换热(W m−2) |
| L6 | 有效种植跨度(m) | QR-0 | 内表面到室外空气传导能量(W m−2) |

| 符号 | 说明 | 符号 | 说明 |
|------|------|------|------|
| L7 | 首排作物到温室前端的水平距离(m) | Q2RA | 围护结构的辐射能量损失(W m-2) |
| θWmin | 冬至日最小屋面角度(°) | kAR | 空气与围护结构间的对流换热系数 |
| βW12 | 太阳高度角(冬至日12:00)(°) | TO | 室外空气 |
| βS12 | 太阳高度角(夏至日12:00)(°) | λR | 围护结构导热系数 |
| W | 墙体厚度(m) | LEg | 土壤潜热能耗(W m-2) |
| H0 | 保温被距地面垂直距离(m) | LEI | 冠层蒸腾能量(W m-2) |
| H | 脊高(m) | Qm | 冷风渗透 |
| H1 | 植株高度(m) | R | 围护结构 |
| H2 | 墙高(m) | dR | 土壤温度稳定层厚度(m) |
| H3 | 顶点到墙体的垂直距离(m) | L | 采光屋面 |

| 符号 | 说明 | 符号 | 说明 |
|------|------|------|------|
| H4 | 日光温室垂直距离 | TA | 室内空气 |
| H5 | 顶点到墙体的距离(m) | S | 土壤 |
| H6 | 肩高(m) | S | 发射率 |
| P | 最大位置 | ρ | 密度(kg m−3) |
| Hmax | 顶点脊高(m) | ρ | 植物与叶面蒸腾比例系数 |
| Hmin | 最小脊高(m) | ε | 植物与叶面蒸腾比例系数 |
| D | 温室间距(m) | σ | 斯特藩-玻尔兹曼常数(5.67×10−8 W m−2 K−4) |
| α10 | 采光屋面角(上午10点)(°) | c | 比热容(J kg−1 K−1) |
| β10 | 太阳高度角(上午10点)(°) | N | 温室内外空气交换率(N h−1) |
| γ10 | 太阳方位角(上午10点)(°) | V | 温室内部体积(m3) |
|  |  | A | 面积(m2) |
|  |  | V | 体积(m3) |
| 力学性能分析 |  | LAI | 叶面积指数(m2 m−2) |
| LC | 荷载组合(kN) |  | 冠层显热能耗 |
| G | 永久荷载(kN) | φP | 冠层显热交换阻力系数 |
| SL | 雪荷载(kN) | re | 冠层显热交换阻力系数 |
| Q | 保温被质量荷载(kN) | 缩写 |  |
| P | 作物荷载(kN) | CSG | 中国日光温室 |

# 1.引言

随着人口增长，全球粮食需求迅速增加。设施园艺为解决这一挑战同时提高居民收入提供了有前景的途径。过去几十年间，日光温室为实现全年果蔬供应目标取得了长足发展[1-3]。截至2018年，中国日光温室生产规模已达196.37万公顷，为农村社区创造了数百万就业机会[4]。其用不足3%的耕地生产了中国25.3%的农产品，经济效益超过大田作物20倍以上，是露地园艺作物的4-5倍。此外，日光温室有效利用了非耕地和冬闲田，将荒坡、沙漠和荒地转变为高产农田[5]。温室需要大量太阳能维持热环境，其设计与建造与各地气候密切相关。中国地域气候差异显著，因此针对不同地区选择合适的温室结构参数至关重要。

随着温室设施老化，许多日光温室因结构安全问题或无法满足作物基本生长需求而被废弃，自2015年起温室面积逐渐减少(图S1-S2)。2023年中央一号文件提出，集中连片推进老旧蔬菜设施改造提升是推进设施农业现代化的重要举措[6]。日光温室属于半永久性建筑，各结构参数间存在强相关性。用简单结构硬件重建节能且经济可行的农业温室面临重大挑战[7]。

过去20年温室优化研究快速增长[8-10]。虽然已通过实验研究了日光温室结构参数的影响，但仍缺乏为种植者选择合适参数的统一标准。该领域主流研究方法主要采用模拟技术[11-14]。计算流体力学(CFD)已成为探索热环境指标与温室结构关系的强大工具[15-17]。此外，众多研究者通过光路和光强模拟致力于优化温室内光环境[18,19]。鉴于太阳辐射因朝向、地理位置、季节和日照时长而异，必须建立科学方法选择温室结构参数，如采光屋面角、屋面角、形状等。表1概述了现有温室结构优化研究。

微气候量化是评估温室性能和设计温室结构的基础。日光温室结构参数优化旨在最大化采光和蓄热，重点关注形状。然而上述研究仅分析了太阳辐射或温度，未揭示这些优化对温室内冠层微气候的影响[21-23]。此外，微气候评估多在二维平面进行[24]。多数研究针对单个温室且未施加尺寸限制。虽然为建造日光温室提供了宝贵指导，但在老旧温室改造方面仍存在局限。作为集群建设项目，日光温室布局也与其结构参数密切相关。以往研究常忽略采光屋面形状优化时的结构安全性[25,29]。作为农业设施，日光温室不仅需要为蔬菜创造良好生长环境，还需承受结构上的各类荷载[30]。

基于对前人研究的综述，本文提出全面解决方案以优化温室群结构实现最大能量获取。建立了确定温室顶点最佳位置的数学模型，确保采光屋面角最大化光截获并最小化相邻温室遮阴。在此基础上，应用能定量计算光温微气候的3D模拟模型，在相同土地利用约束下系统优化采光结构。通过数值模拟评估优化后采光屋面形状的安全性。此外，评估了中国下沉式日光温室的应用效果。该方法可扩展应用于为不同地区温室结构设计和改进提供理论指导。

# 2.解决方案

# 2.1. 研究对象温室结构参数

参考日光温室位于中国北京市朝来农艺园(北纬39.49°，东经116.21°，海拔34m)。温室结构参数为：跨度7.5m，脊高3.6m，后墙高2.25m，后屋面水平投影1.6m，长度60m。采光屋面支撑结构为钢架拱形骨架，覆盖0.15mm透明PO薄膜(图1)。温室方位角为南偏西7°。试验期为2022年11月至2023年4月，期间保温被下午4:30前覆盖，上午8:30后卷起，平均每日光照时间约8小时。

# 2.2. 结构优化总体方案

本研究总体设计方案如图2所示，包含三个部分：(1)获取初始数据，基于透光原理确定最佳采光屋面角和屋面角；(2)建立3D温室模拟模型，计算和验证单叶尺度的光温环境；(3)通过光照、温度和安全性的综合分析获得最优采光屋面形状。

表1 主要文献贡献总结

| 参考文献 | 地点 | 结构参数 | 研究方法 | 评价标准 | 主要结果 |
|---------|------|---------|---------|---------|---------|
| Zhang等[20] | 沈阳,中国 | 形状 | GrolIMP | 温度/太阳辐射 | 最优CSG结构参数为：脊高5.2m、后屋面1.2m、墙高5m、跨度8m，夜间温度提高2℃ |
| Tong等[21] | 沈阳,中国 | 跨度 | CFD | 温度 | 相同采光面和北墙尺寸下，12m跨度温室气温最高，14m跨度最低 |
| Wu等[22] | 沈阳,中国 | 形状 | CFD | 温度 | 10m跨度CSG最优结构参数为：脊高6.2m、后屋面2.0m、墙高4.4m |
| Esmaeli等[23] | 德黑兰,伊朗 | 形状 | 数学模型 | 温度 | 开发了报告CSG最佳性能的优化算法 |
| Liu等[24] | 新疆,中国 | 采光屋面 | Matlab | 太阳辐射 | 双圆弧温室在所有季节都表现出良好性能 |
| Zhang等[25] | 北京、杨凌、宿迁、寿光,中国 | 形状 | Abaqus | 太阳辐射 | 开发了考虑冠层高度的CSG结构参数优化方法 |
| Zhang等[26] | 西安,中国 | 墙体 | 数学模型 | 温度 | 建立了热环境模型与建筑构件设计的直接关联 |
| Chen等[27] | 中国北方 | 形状 | EnergyPlus | 温度 | 通过EnergyPlus中的能量平衡方程可计算CSG主要结构参数 |
| Wu等[28] | 北京,中国 | 采光屋面 | 数学模型 | 太阳辐射 | 四种采光屋面形状比较表明，圆形抛物线形捕获太阳辐射最有效 |

![](images/830ac68de97b3700260228a02378d785458dde860163f8a520a03ac4a11c0e07.jpg)  
图1. 北京地区中国日光温室室外(A)和室内(B)场景

# 2.3. 温室顶点位置确定公式

# 2.3.1. 中国日光温室采光屋面角确定

中国日光温室采光屋面角计算公式如下[25]：

$$
\alpha = \arcsin \frac{\sin\alpha_{10}}{\cos\gamma_{10}} \tag{1}
$$

$$
\alpha_{10} = 90^{\circ} - \beta_{10} - 43^{\circ} \tag{2}
$$

式中，$\alpha$为合理采光屋面角，$\alpha_{10}$为上午10点最佳采光屋面角，$\beta_{10}$为北京地区上午10点太阳高度角$(20^{\circ})$，$\gamma_{10}$为上午10点太阳方位角$(148^{\circ})$。结合上述公式和温室跨度，可确定CSG顶点可能位置的线性方程$(y_{a})$如图3所示：

$$
y_{a} = \tan (\alpha)\bullet x \tag{3}
$$

# 2.3.2. 中国日光温室屋面角确定

屋面坡度角的确定遵循两个原则。首先，考虑墙体蓄热是维持CSG温度的保障，冬至日正午$(\beta_{W12})$阳光应照射到墙体上部。屋面角公式如下：

$$
\theta = \beta_{W12} + 5^{\circ} \tag{4}
$$

$$
\tan \theta = \frac{H_4}{L_4 - W} \tag{5}
$$

$$
H_{min1} = \tan \theta \bullet (L_4 - W) + H_2 \tag{6}
$$

其中$\theta$为屋面角，增加$5^{\circ}$是为避免冬季保温被造成的遮阴。$H_{4}$表示CSG顶点至墙体的垂直距离，$L_{4}$为后屋面水平投影，W代表墙体厚度$(0.24\mathrm{m})$，$H_{2}$为墙体高度$(2.25\mathrm{m})$。

其次，考虑温室内冠层的光截获需求，夏至日正午阳光应能照射到靠近墙体的作物冠层上部。设计公式如下：

$$
\tan \beta_{S12} = \frac{H_0 - H_1}{L_4 - L_3 - W + L_5} \tag{7}
$$

$$
H_0 = H - L_5\bullet \tan \alpha \tag{8}
$$

式中$\beta_{S12}$表示夏至日正午太阳高度角，确保满足植物全年光照需求。以CSG种植番茄等喜温作物为例(图3)，$H_{0}$为保温被距地面垂直距离，$H_{1}$为冠层高度$(2\mathrm{m})$，$L_{3}$表示温室过道宽度$(0.6\mathrm{m})$，$L_{5}$为夏至日保温被水平投影$(0.5\mathrm{m})$，$W$为墙体厚度$(0.24\mathrm{m})$。将这些值代入公式5可得：

![](images/1e1ecaca4deb6cac6aa41a3ad4ccdca589ba3bf22aacc5ba74a874936f22e44a.jpg)  
图2. 中国日光温室结构优化设计流程

![](images/4103ab906dd762fa69c56e7dd7a7ae8d2f3730292dc74853fb50fdd544283e89.jpg)  
图3. 中国日光温室结构参数及阳光投影示意图

$$
H_{min2} = tan\beta_{S12}\bullet (L_4 - 0.34) + 0.5\bullet tan\alpha +2 \tag{9}
$$

第三，可利用温室间水平距离确定CSG顶点位置，公式如下：

$$
H_{max} = tan\beta_{w12}\bullet (D + L_4) \tag{10}
$$

式中，$D$为南北方向温室间距。

# 2.4. 采光屋面形状优化概念描述

采光屋面形状对日光温室(CSG)截获的太阳辐射量以及与外界环境的热交换程度具有深远影响[31]。鉴于温室采光屋面存在多种可选形状，仅依靠实地测量数据难以确定最优形状。为解决这一问题，本研究引入线性插值方法构建多种温室形状方案。如图4所示，圆形和直线形是两种典型的极端温室形状。通过插值处理后，共生成121种采光屋面形状。此外，还建立了微气候与不同形状间的物理关系。通过对每种方案进行室内光照和热性能模拟，最终确定最优采光形状。

![](images/268e378f778ce32c5ed67b2b71997d60e38df05a834c7a92934c0a7652f6bf60.jpg)  
图4. 两种极端采光屋面形状示意图及集成传感器布局。蓝线代表近圆形温室采光屋面，红线为直线型温室采光屋面。(关于图例中对颜色的引用解释，读者可参考本文网络版)

# 2.5. 温室设计模型实现

# 2.5.1. 温室内太阳辐射建模

直接辐射源通过GroIMP平台[32]中声明辐射源模块定义为一个大球体(图5)。天空模型根据设定的时间和日期，在每个模拟步骤动态更新光照场景的内部光照环境。经偏心率校正后的入射总辐射(S)计算公式如下[18,33]：

$$
S = 1367\cdot \tau_{\alpha}\cdot sin\beta \bullet [1 + 0.033\cos (2\pi \bullet \frac{(t_d - 10)}{365})] \tag{11}
$$

式中$t_d$为1月1日后的天数，$\tau_{\alpha}$为大气透射率。太阳高度角的正弦值$(sin\beta)$昼夜变化计算公式为：

$$
\sin \beta = \sin \lambda \bullet \sin \delta +\cos \lambda \bullet \cos \delta \bullet \cos (2\pi \bullet (t_h - 12) / 24) \tag{12}
$$

$t_h$表示太阳时，$\lambda$为温室所在地纬度，$\delta$代表太阳相对于赤道的倾斜角。

为离散化表示散射辐射源，本实验采用72个定向散射光源组成的阵列。这些散射光源在天空半球上按从上到下的规则图案排列，形成6个同心圆环，每个环包含12个均匀分布的散射光源(图5)。

全球太阳辐射转换为光合有效辐射(PAR, $\mu \mathrm{mol} \mathrm{m}^{- 2} \mathrm{s}^{- 1}$)的公式如下[34]：

$$
PAR = -0.44928 + 0.02484\bullet S + 0.0126\bullet S\bullet \sin \beta -0.00864\bullet S\bullet K_t
$$

其中$K_t$为晴朗指数。

# 2.5.2. 温室内热环境计算

为模拟不同CSG的内部热性能，需确定各组件的能量平衡方程。随后开发MATLAB程序求解这些能量方程。能量平衡方程基于Xu等[35]提出的CSG-LS热模型进行改进。根据北京地区结构特征，采用改进的热模型计算实验温室内部温度分布。墙体和屋顶的能量平衡方程相似，这两个组件统称为围护结构，其方程如下：

$$
R_{R} = \rho_{R}c_{R}\nu_{R}*\frac{dT_{R}}{dt} +Q_{R}^{A} + Q_{R - O} + Q_{R - A}^{2} \tag{14}
$$

式中$\rho_{R}c_{R}\nu_{R}*\frac{dT_{R}}{dt}$表示围护结构因内表面温度$T_{R}$变化引起的能量差异。假设温室内空气均匀混合，则围护结构的辐射热损失$(Q_{R - A}^{A})$、内表面与室内空气的对流换热$(Q_{R}^{A})$以及内表面向室外空气的传导能量$(Q_{R - O})$可简化为：

$$
\begin{array}{l}{Q_{R - A}^{2} = A_{R}\bullet \sigma \bullet \epsilon \bullet 4(T_{R} - T_{A})\bullet T_{A}^{3}}\\ {}\\ {Q_{R}^{A} = A_{R}\bullet k_{A - R}\bullet (T_{R} - T_{A})} \end{array} \tag{16}
$$

![](images/96f9571d1c42af75bd655f11f3ec15abdb07885fef0e1e3705b1b32dd664dbd3.jpg)  
图5. 北京地区CSG太阳辐射模型可视化

$$
Q_{R - O} = A_R\bullet \frac{\lambda_R}{d_R}\bullet (T_R - T_A) \tag{17}
$$

单位面积土壤的能量平衡方程为[36]：

$$
R_{S} = \rho_{S}c_{S}\nu_{S}*\frac{dT_{S}}{dt} +Q_{S}^{A} + Q_{S - O} + LE_{S} + Q_{S - A}^{2} \tag{18}
$$

$$
LE_{S} = \epsilon \bullet LE \tag{19}
$$

式中$LE_{S}$表示土壤表面的潜热能耗。CSG采光屋面的能量平衡方程如下[37]：

$$
R_{L} = \rho_{L}c_{L}\nu_{L}*\frac{dT_{L}}{dt} +Q_{L}^{A} + Q_{L}^{O} + Q_{L - O} + Q_{L - A}^{2} + Q_{L - O}^{2} \tag{20}
$$

室内空气温度主要由空气与围护结构之间的对流传热决定。CSG空气温度的能量平衡方程如下[38]：

$$
\rho_{A}c_{A}\nu_{A}*\frac{dT_{A}}{dt} = Q_{L}^{A} + Q_{R}^{A} + Q_{S}^{A} + LE_{S} + Q_{Inf} \tag{21}
$$

$$
Q_{inf} = c_{p}\bullet \rho \bullet \frac{N\bullet V}{3600}\bullet (T_{in} - T_{out}) \tag{22}
$$

其中$Q_{inf}$表示冷风渗透量。CSG植物冠层的能量平衡方程如下：

$$
R_{P} = \rho_{P}c_{P}H_{1}LAI*\frac{dT_{P}}{dt} +\phi_{P} + LE + Q_{P - A}^{2} \tag{23}
$$

$$
\phi_{P} = 2\bullet LAI\bullet \frac{\rho_{P}c_{P}}{r_{e}} (T_{P} - T_{A}) \tag{24}
$$

式中$LE$为冠层蒸腾能量，$\phi_{P}$表示冠层的显热能耗。所有变量和边界条件见表S1和图S3，详细计算公式见方法S1。计算过程中，室外温度根据室外气象站实测数据设定。

# 2.5.3. 三维光环境模拟与温度求解过程

为了准确量化不同形状中国日光温室(CSG)的光环境，在GroIMP建模平台上进行了光学模拟。通过集成太阳辐射模型、三维温室模型和光学物理特性参数，实现了对采光屋面、墙体、屋顶、土壤和冠层的光照截获精确计算。利用MATLAB (R2018a, MathWorks, Inc.)建立了CSG内部各组件的能量平衡方程。将计算得到的辐射值、室外温度数据、室内初始温度和各种物理参数作为输入，实现了对CSG内部温度的连续求解。详细的边界条件和参数汇总于表2。模拟时间从冬至日8:30到次日8:30，时间步长为30分钟。根据北京温室实际运行情况，保温被的开启和关闭决定了光照时间为8:30至16:30。

# 2.5.4. CSG骨架力学性能分析

荷载组合是CSG结构设计的前提和基础[25]。为确保优化后的温室满足稳定性要求，必须分析作用在温室上的荷载特性及其组合效应[39]。本研究考虑了荷载组合的极端情况，其公式可表示为：

$$
LC = G_{1} + G_{2} + P + Q + SL \tag{25}
$$

表2 仿真使用的参数

| 位置环境 |  |  | 温室参数 |  |  |
|----------|--|--|----------|--|--|
| 纬度 |  | 39.8 | ° | CSG | 30, 7.2, 0.00015 |
| 直接辐射 |  | 750 | W | 后墙 | 50, 2.25, 0.48 |
| 散射辐射 |  | 150 | W | 屋顶 | 50, 2.0, 0.3 |
| 分层表面属性 |  |  |  | 土壤 | 50, 7.2, 0.5 |
| CA |  | 1005 | J kg⁻¹ K⁻¹ | 屋脊高度 | 3.6 |
| cL |  | 750 | J kg⁻¹ K⁻¹ | 温室间距 | 8 |
| cW |  | 1062 | J kg⁻¹ K⁻¹ | 采光面角度 | 32.24 |
| cR |  | 1380 | J kg⁻¹ K⁻¹ | 朝向 | 90 |
| cS |  | 1900 | J kg⁻¹ K⁻¹ | 采光面面积 | 300 |
| ρA |  | 1.29 | kg m⁻³ | 采光面光学属性 |  |
| ρL |  | 970 | kg m⁻³ | 雾度 | 5 |
| ρW |  | 1100 | kg m⁻³ | 透明度 | 94.4 |
| ρR |  | 800 | kg m⁻³ | 透光率 | 94 |
| ρS |  | 1500 | kg m⁻³ | 45度光泽度 | 74.8 |
| 荷载组合 |  |  |  | 钢结构截面参数 | 75*30*2 |
| 雪荷载 |  | 9.113 | KN | 骨架(椭圆管) |  |
| 保温被荷载 |  | 2.822 | KN | 拉杆 | 25*1.5 |
| 永久荷载 |  | 9.513 | KN | 支撑杆(圆管) | 25*1.5 |

其中$LC$表示荷载组合，$G_{1}$和$G_{2}$分别代表采光面和屋顶的质量荷载，统称为永久荷载(G)。$P$表示作物荷载，作用于采光面。$Q$为保温被质量荷载，$SL$表示雪荷载。通过有限元分析方法研究了结构变形量，详细参数见表2。

# 2.6. 模型验证

采用美国Decagon公司的QSO-S PAR（光合有效辐射）传感器监测光环境。该传感器以$\mu \mathrm{mol}~\mathrm{m}^{-2}~\mathrm{s}^{-1}$为单位，每$10~\mathrm{min}$记录一次冠层辐射变化。使用4.57的转换系数将$\mu \mathrm{mol}~\mathrm{m}^{-2}~\mathrm{s}^{-1}$转换为$\mathrm{W}~\mathrm{m}^{-2}$[34]。在建立的虚拟CSG模型中，按照实际位置布置虚拟传感器$(0.01\mathrm{m}\times0.01\mathrm{m})$以获取模型计算值。通过比较各层$(0.5\mathrm{m},1.0\mathrm{m},1.5\mathrm{m},2.0\mathrm{m})$（包括上层、中层、下层和底层）实测值与预测值的平均值验证模型精度。将整个墙面区域的平均预测太阳辐射强度与墙面附近传感器记录的平均数据进行比较。使用RC-4温度传感器（Elitech，中国，精度：$\pm0.1^{\circ}\mathrm{C}$，温度范围$-30^{\circ}\mathrm{C}$至$110^{\circ}\mathrm{C}$）测量CSG内部各部位温度，集成传感器的详细布置见图4。

图6显示预测值的日变化趋势与实测值一致。总体上温度预测值高于实测值，这种差异主要源于传热过程中的能量耗散。采用均方根误差(RMSE)和决定系数$(\mathbb{R}^2)$分析预测数据与实测数据的相关性。如表3所示，辐射的RMSE值在8.94至$10.83\mathrm{Wm}^{-2}$之间，分别约占墙面和温室中部平均太阳辐射强度的$3.8\%$和$5.0\%$。温度的RMSE值在$1.47^{\circ}\mathrm{C}$至$1.85^{\circ}\mathrm{C}$之间。决定系数范围为0.90-0.95，充分证明所提模型能准确模拟CSG内部的光热环境。

![](images/85190a0d350de5c1395bd44d56badb05f41ef62306f2b700aa265d2b0b39d214.jpg)  
图6. 冬至日中国日光温室的温度(A)和光照分布(B)

表3 预测值与实测值的RMSE和R²

| 参数       | 指标   | 上层    | 中部    | 下层    | 底部    | 后墙   |
|------------|--------|---------|---------|---------|---------|--------|
| 辐射       | RMSE   | 9.70    | 10.83   | 10.34   | 10.53   | 8.94   |
|            | R²     | 0.91    | 0.91    | 0.91    | 0.91    | 0.91   |
| 温度       | 指标   | 采光面  | 土壤    | 后墙    | 屋顶    | 空气   |
|            | RMSE   | 1.52    | 1.85    | 1.74    | 1.47    | 1.59   |
|            | R²     | 0.91    | 0.91    | 0.95    | 0.95    | 0.93   |

# 3. 案例研究

# 3.1. 确定CSG顶点位置

以位于北京的中国日光温室(CSG)作为研究原型。如图1B所示，原始温室结构已进行过两次优化，屋脊跨度比从0.4变为0.5。现有结构是否为最佳选择仍属未知。图3展示了确定温室顶点位置的过程。通过将太阳高度角和方位角输入方程(1)-(3)，可获得北京地区温室适宜的采光屋面角度。随后，通过确定合适的屋面角度可计算出CSG顶点位置。确定屋面角度时有三个限制因素：冬至日阳光能照射到后墙上部，夏至日能照射到靠近后墙的作物冠层顶部，同时冬至日相邻温室间的遮阴应尽可能少。使用上述CSG顶点位置确定公式，最终确定了三个特征点的坐标：P1(5.3, 3.3)、P2(6.4, 4.0)和P3(6.8, 4.3)。由三个限制因素确定的$L_{1}$适宜范围为$6.4 - 6.8 \mathrm{m}$。随后在冬至日，以$0.1 \mathrm{m}$为间隔，对$6.4 \mathrm{m}$至$6.8 \mathrm{m}$范围内五种不同采光屋面形状的顶点位置进行了插值模拟。针对不同结构和采光屋面形状开展了多种模拟研究。

# 3.2. 结构优化

如图7所示，五种类型温室的光照和温度性能较原始温室均有显著提升。冬至日光照时段为上午8:30至下午4:30。随着采光屋面面积增加，空气温度和光截获量均有所提高，光环境改善更为明显。其中，顶点位置最高(P5)的温室表现最佳。与原始CSG相比，P5采光屋面捕获的太阳辐射增加了$33.5\%$，室内平均气温上升约$3.1^{\circ}\mathrm{C}$，增幅达$20.6\%$。有趣的是，优化后不同顶点位置的CSG内部气温无显著差异。这表明增加采光屋面面积虽能改善光照性能，但同时也会增大散热面积。因此，在优化温室结构过程中，不仅需要关注光环境，还应兼顾光热平衡。

![](images/7e9791cf896b103d2ab2058876dd5735b14f051fcc64008e9ca781c21d0f2a4a.jpg)  
图7. 不同顶点位置中国日光温室的辐射和温度差异

为阐明不同采光屋面形状对温室内光温环境的影响，本研究综合分析了累积太阳辐射和日有效积温。累积太阳辐射包含来自后墙和地面的值，这是温室主要的热量储存和释放模块。作物可耐受的最低温度设为$10^{\circ}\mathrm{C}$[40,41]。日有效积温定义为每小时室内气温与$10^{\circ}\mathrm{C}$正差值的时间积分。图8展示了具有最高顶点位置的121种CSG采光屋面形状的光温性能。这些形状被分为11组，从近似圆形到直线形反复变化。不同温室形状间日总太阳辐射和有效积温的最大差异分别为$4.8\%$和$6.1\%$。结果还表明接近直线形的采光屋面能提升CSG性能。不同温室形状间的光截获量和温度最大差异分别为$4.8\%$和$6.1\%$。然而，采用直线形CSG会限制作物高度并减少有效种植面积，可能影响作物产量。因此，CSG的空间利用率也是决定采光形状的因素之一。

![](images/06fb34d056c9d6a00193815abd15c37251d7557a816426449b6a2dea93c149ae.jpg)  
图8. 不同采光屋面形状中国日光温室的总光截获量和日有效积温

根据上述结果，确定了五种性能最优的CSG（S09、S109、S110、S120、S121）。如图3所示，有效种植跨度设为$5.7\mathrm{m}$（$L_{6}$），首排作物与温室前沿的水平距离为$0.7\mathrm{m}$（$L_{7}$）。地面至采光屋面的垂直高度$0.9\mathrm{m}$（$H_{5}$）称为肩高。基于此标准，当采光屋面距地面垂直高度达$0.9\mathrm{m}$时，该位置与温室前沿的水平距离被视为无效种植区。以有效种植面积利用率为评价指标，另选五种满足种植面积要求且具有良好相对性能的温室进行比较。图9展示了十种CSG与原温室的性能对比。两类CSG在累积温度和辐射增加率上的平均差异分别为$4.7\%$和$2.9\%$，而有效种植面积利用率的平均差异达$11.9\%$。为满足温室种植面积需求，最终确定最优温室形状为S79、S89、S90、S100、S111。这五种CSG间温度和辐射的相对增加率差异仅分别为$0.45\%$和$0.55\%$。

![](images/c4dc85789e1a6bc2637f41b20df6746b9e46ac9bc4d0b9b2ac8412842e581fd9.jpg)  
图9. 原温室与优化温室性能差异对比

### 3.3. 结构稳定性分析

骨架结构稳定性是温室作物生产的前提条件。图10展示了CSG原始和优化的采光屋面形状及其对应方程。优化CSG形状后，骨架结构发生变化，由此引发的潜在结构安全问题不容忽视。因此，本研究采用有限元分析法计算不同骨架结构在相同荷载条件下的变形量。

钢骨架结构改变对变形量产生显著影响（图11）。与原温室相比，优化CSG结构（SK1-5）的平均变形量最小增加$3.7\mathrm{mm}$，最大增加$12.7\mathrm{mm$，这将导致安全性下降。为解决此问题，我们尝试用拉杆连接采光屋面骨架和屋顶骨架，从而增强CSG采光结构的稳定性。实施钢结构修改方案（M1-5）后，变形量可最小化至$1.0\mathrm{mm}$，对应M3形状（S90：$y_{3} = -0.0926x^{2} + 1.1593x + 0.2395$）。

综上所述，北京朝来农艺园的温室从采光、蓄热和安全性多角度进行了优化。相较原温室结构，各方面性能均得到显著提升。

### 3.4. 中国下沉式日光温室

增加温室有效种植面积的另一方法是下挖地面。这种被称为中国下沉式日光温室的设施在中国山东、河北等省份和西北地区广泛应用（图12）。当温室地面下沉至一定深度时，具有蓄热能力的墙体面积也随之增加，同时温室前排作物会受遮阴影响。这些效应在不改变结构参数的情况下显著影响温室内微气候[42]。上述CSG形状优化过程中提到的有效种植面积限制问题或可通过此方式解决。

以生产中常见的$0.5\mathrm{m}$下沉深度为例，基于本模型模拟了CSG的温度和光环境。评估对象包括原温室和五种满足下沉后种植面积要求的温室（S72、S93、S103、S104、S114）。图13A显示原温室地面下沉$0.5\mathrm{m}$后，累积积温增加$6.7\%$，而累积光截获量减少$1.1\%$。另五种温室的累积温度和辐射平均增加率分别为$45.7\%$和$23.8\%$，与五种高种植面积利用率CSG的结果基本一致。通过3D仿真模型量化了温室内作物冠层的平均光合有效辐射。基于田间测量的五株形态相似番茄植株各器官平均参数，建立了番茄冠层3D结构。原温室下沉处理后，冠层平均光截获量降低$5.6\%$。当CSG形状优化后，冠层平均光截获量较原温室提高$1.4\%$（图13B）。综合考虑温室下沉工程量和前排作物遮阴影响，改善CSG光温环境应重点优化采光结构。

![](images/b1f02a239399c525a5fda9b58222ab49eb95cf50b953fe735b20ca73f7ed41a1.jpg)  
图10. CSG优化采光结构截面及钢骨架受力分析

![](images/39ff88e32cbb779a588530024ca90845bfb880dd8cd8487172c7c6403b0ffdce.jpg)  
图11. 不同骨架结构与原结构的变形量对比

# 3.5. 经济与环境效益评估

经济效益是中国日光温室(CSG)结构优化过程中不可忽视的关键因素。以实验温室为例，优化后温室的效益如表4所示。优化CSG采光结构后，需要对钢骨架进行改造，材料成本为686美元，人工成本约447美元。此外，由于采光屋面面积增加了$30~\mathrm{m}^2$，保温被和塑料薄膜的成本相应增加了65美元。综上，整体改造费用为1198美元，折合单位面积成本约$5.55\mathrm{美元}\mathrm{m}^{-2}$。相较原始温室，优化温室性能显著提升：捕获能量增加$5.4\mathrm{MJ}\mathrm{m}^{-2}$（$1\mathrm{MJ}\mathrm{m}^{-2} = 10^{6}\bullet t\bullet 1\mathrm{W}\mathrm{m}^{-2}$），平均温度上升$3.1^{\circ}\mathrm{C}$。捕获的能量相当于每日减少$60.4\mathrm{kg}$燃煤消耗，相应减少$150.7\mathrm{kg}\mathrm{CO}_2$排放。考虑到CSG冬季每年60天的供暖期，优化温室潜在节能收益约606美元。此外，温度每升高$1^{\circ}\mathrm{C}$，番茄产量可提高约$2.5\% - 3.1\%$[43]。基于冬季番茄平均产量计算，优化温室番茄增产约$688~\mathrm{kg}$，增收579美元。投资回收期预计为1.6年，即CSG优化成本与潜在收益达到平衡的时间。这一发现有望鼓励温室经营者和运营者考虑采用所提出的设计策略。

![](images/f9c6e41f9324ba54cc3bb4896d1bf542f19b0636ed24da5d7eaac8f30c18d729.jpg)  
图12. 两种类型温室的室外与室内光分布

![](images/3ef58013e56f0c41d6f57da1f4f02e2e2a52579cb1912ff3f2a7809ede8c0311.jpg)  
图13. 原始温室与下沉式温室性能对比：(A)温度与辐射增长率，(B)冠层截获的平均光合有效辐射

表4 温室优化的经济评估

| 温室类型 | 参数 | 原始值 | 优化值 | 单价 | 金额 |
|---------|------|-------|-------|------|------|
| 增量预算 | - | - | - | - | 1198美元 |
| 结构成本 | 钢骨架(m) | 300 | 330 | 1.8美元/米 | 594美元 |
|  | 拉杆(m) | 40 | 158 | 0.6美元/米 | 92美元 |
|  | 保温被(m²) | 300 | 330 | 1.7美元/m² | 50美元 |
|  | 塑料薄膜(m²) | 300 | 330 | 0.5美元/m² | 15美元 |
|  | 人工成本(天) | - | 8 | 56.1美元/天 | 447美元 |
| 环境效益 | 捕获能量(MJ) | 5251.5 | 7022.9 | - | - |
|  | 平均温度(°C) | 15.4 | 18.5 | - | - |
| 潜在收益 | - | - | - | - | 751美元 |
| 节能收益 | 燃煤量(kg/天) | - | -60.4 | 168.3美元/吨 | 606美元 |
|  | CO₂排放(kg/天) | - | -150.7 | - | - |
| 作物收益 | 番茄产量(kg) | 4300 | 4644 | 0.8美元/kg | 145美元 |
| 投资回收期 | - | - | - | - | 1.6年 |

# 4. 讨论

# 4.1. 老旧温室设施升级的必要性

温室群组常面临土地利用和改造成本限制，使得单个温室结构参数的调整颇具挑战。因此，多数研究者主要聚焦于温室管理策略，以制定适应作物生长微气候的理想方案[44-46]，而针对老旧温室的结构优化研究相对匮乏。中国日光温室(CSG)的核心目标是实现全年作物生产，特别是在日照时间最短、太阳辐射最弱的寒冷冬季[47]。本研究在CSG设计中重点优化了采光屋面的阳光入射效率。温室结构参数设计本质上是一个多目标优化问题[48]。我们开发的集成模型综合考虑了光照、温度、作物冠层、空间效率和结构安全性的影响，以寻求最优设计方案。结果表明：顶点位置是影响温室性能的决定性因素，其次为采光屋面形状。在保留原有温室围护结构基础上，合理优化采光屋面可显著改善内部气候环境，同时保持较高结构安全性，并在短期内收回改造成本。本研究以广泛种植的番茄为作物原型，该模型同样适用于叶菜类作物生产的结构参数优化。总之，该方法为老旧温室改造和废弃温室再利用提供了新思路。

# 4.2. 所提模型的优势

CSG结构复杂性导致其内部微气候存在显著异质性[49]。现有研究多在二维平面评估或忽略三维尺度复杂作物冠层的影响[50,51]。因此需要更精确的温室微气候模拟方法，特别是在三维几何背景下考虑可变参数。我们引入三维光线追踪法，精确计算进入温室的光线吸收、反射和透射特性[3,4]。通过整合三维植物模型与各温室组件的光学属性，可定量计算作物与温室间的复杂光学交互作用[52,53]。结合CSG组件截获太阳辐射的光学模拟，建立能量平衡方程并计算各表面温度，最终系统量化不同CSG形状下的光热环境。该模型不仅适用于温室结构升级优化，还可用于种植密度、行向等种植策略优化[54]。

该集成模型还可扩展应用于能源设备的优化配置。典型案例是农业光伏系统[55]，其将农业与光伏发电结合于同一地块，展现出可持续生产的巨大潜力[56]。设计良好的农光系统可同步满足粮食与能源需求[57]。通过本模型可确定光伏板尺寸、朝向、最大载荷及倾角等参数，因地制宜制定安装策略[58]。还能量化三维尺度下作物与光伏板的交互影响，可视化呈现结构间的复杂阴影关系。这些功能为建筑规划提供显著优势[59]，尤其适用于需要整合太阳能强化供暖系统的设施农场[60]。

# 5. 结论

本研究提出了一套综合考虑太阳能利用与室内微气候的多因素优化方法，系统性地优化了CSG结构参数，重点提升了太阳能利用率、温度环境和结构安全性。主要结论如下：

(1) 以北京朝来农艺园典型CSG为原型，确定最优顶点位置为(6.8,4.3)，对应采光屋面曲线方程为$y = -0.0926x^2 + 1.1593x + 0.2395$。优化后微气候环境显著改善，平均光截获量和温度分别提升33.5%和20.6%。

(2) 不同采光屋面形状的光截获量最大差异达4.8%，温度差异6.1%。温室气候环境优化过程中需全面考虑结构安全性。

(3) 温室结构优化可减少不可再生能源消耗，投资回收期约1.6年。

本研究的方法和发现为可持续农业实践提供了重要参考，对温室产业发展具有显著意义。

# 作者贡献声明

Demin Xu: 初稿撰写，验证，调研，形式分析，数据整理。Shuaipeng Fei: 验证，软件，形式分析。Zhi Wang: 调研，形式分析。Jinyu Zhu: 审阅编辑，软件，方法论，形式分析。Yuntao Ma: 审阅编辑，监督，软件，方法论，资金获取，概念化。

# 利益冲突声明

作者声明不存在可能影响本研究的已知经济利益冲突或个人关系。

# 数据可用性

数据可根据需求提供。

# 致谢

本研究得到国家重点研发计划(2023YFD2000600)、国家自然科学基金(32372799)和北京市数字农业创新联合体(BAC10-2024)资助。

# 附录A. 补充材料

补充材料见在线版本：https://doi.org/10.1016/j.energy.2024.131980

# 参考文献

[1] Dong J, Gruda N, Li X, Cai Z, Zhang L, Dunn Z. 面向可持续食品生产和健康饮食的全球蔬菜供应. J Clean Prod 2022;369. https://doi.org/10.1016/j.jclepro.2022.133212.
[2] Iddio E, Wang L, Thomas Y, McMorrow G, Denzer A. 温室节能运行与建模研究综述. Renew Sustain Energy Rev 2020; 117. https://doi.org/10.1016/j.rser.2019.109480.
[3] Wang T, Wu G, Chen J, Cui P, Chen Z, Yan Y, et al. 太阳能技术在中国现代温室中的整合应用：现状、挑战与前景. Renew Sustain Energy Rev 2017;70:1178- 88. https://doi.org/10.1016/J. RSER.2016.12.020.
[4] Xie J, Yu J, Chen B, Feng Z, Li J, Zhao C, et al. "设施农业"栽培系统：面向全球的中国模式. Adv Agron 2017;145:1- 42. https://doi.org/10.1016/j.asgrop.2017.05.005. Academic Press Inc.
[5] Li T, Qi M, Meng S. 中国设施园艺60年发展历程：成就与展望. Acta Hortic Sin 2022;49(10):2119- 30. https://doi.org/10.16420/No.issn.0513- 353x.2022- 0700 [in Chinese].
[6] China issues No. 1. central document for 2023, Chinese rural vitalization tasks. https://english.www.gov.cn/policies/latestcreases/202302/13/content_WS63ea2efcc640a757729e6b4b.html.
[7] Zhang M, Yan T, Wang W, Jia X, Wang J, Klemes JJ. 现代可持续温室的节能设计与控制策略综述. Renew Sustain Energy Rev 2022;164. https://doi.org/10.1016/j.rser.2022.112602.
[8] Chen C, Li Y, Li N, Wei S, Yang F, Ling H, et al. 基于计算模型的中国不同纬度地区太阳能温室最佳朝向研究. Sol Energy 2018;165:19- 26. https://doi.org/10.1016/j.solener.2018.02.022.
[9] Choah N, Allouhi A, El Maakoul A, Kouksou T, Saadeddine S, Jamil A. 温室微气候及其应用研究综述：设计参数、热模型与模拟、气候控制技术. Sol Energy 2019;191:109- 37. https://doi.org/10.1016/j.solener.2019.08.042.
[10] Mellalou A, Riad W, Mouaky A, Bacaoui A, Outzourhit A. 摩洛哥地区恒定容积约束下季节性温室的优化设计与朝向研究. Sol Energy 2021;230:321- 326. https://doi.org/10.1016/j.solener.2021.10.050.
[11] Kim R woo, gu Kim J, Lee I bok, Yeo U hyeon, Lee S yeon, Decano- Valentin C. 基于CFD和VR技术的温室空气动力环境三维可视化技术开发(第一部分)：利用CFD构建VR数据库. Biosyst Eng 2021;207:33- 58. https://doi.org/10.1016/j.biosystemseng.2021.02.017.
[12] Zhang X, Wang H, Zou Z, Wang S. 基于CFD和加权熵的中国日光温室温度分布模拟与优化. Biosyst Eng 2016;142:12- 26. https://doi.org/10.1016/j.biosystemseng.2015.11.006.
[13] Mobtaker HG, Ajabshirchi Y, Ranjbar SF, Matloobi M. 伊朗西北部太阳能温室热性能模拟与实验验证. Renew Energy 2019;135:88- 97. https://doi.org/10.1016/j.renene.2018.10.003.
[14] Baglivo C, Mazzeo D, Panico S, Bonuso S, Matera N, Congedo PM, et al. 评估作物热舒适度和能源需求的完整温室动态模拟工具. Appl Therm Eng 2020;179:115698. https://doi.org/10.1016/j.applthermaleng.2010.115698.
[15] Bournet PE, Rojano F. 计算流体力学(CFD)在农业建筑建模中的应用进展：研究、应用与挑战. Comput Electron Agric 2022;201. https://doi.org/10.1016/j.compag.2022.107277.
[16] An CH, Ri HJ, Han TU, Kim S II, Ju US. 温带地区太阳能温室冬季果菜栽培可行性研究：实验与数值分析. Sol Energy 2022;233:18- 30. https://doi.org/10.1016/j.solener.2022.01.024.
[17] Liu R, Li M, Guzman JL, Rodriguez F. 温室温湿度的一维快速实用瞬态模型. Comput Electron Agric 2021;186. https://doi.org/10.1016/j.compag.2021.10.186.
[18] Bo Y, Zhang Y, Zheng K, Zhang J, Wang X, Sun J, et al. 基于温室光环境模拟软件的三连栋塑料温室光环境模拟. Energy 2023;271. https://doi.org/10.1016/j.energy.2023.126966.
[19] Bonachela S, Lopez JC, Hernandez J, Grandos MR, Magan JJ, Cabrera- Corral FJ, et al. 覆盖物与冠层结构如何相互作用以捕获地中海温室内的太阳辐射. Agric For Meteorol 2020;294. https://doi.org/10.1016/j.agrformet.2020.108132.
[20] Zhang Y, Henke M, Li Y, Xu D, Liu A, Liu K, et al. 节能型中国日光温室能源性能最大化研究：常见温室形状的系统分析. Sol Energy 2022;236:320- 34. https://doi.org/10.1016/j.solener.2022.03.013.
[21] Tong G, Christopher DM, Zhang G. 基于CFD分析的中国日光温室跨度选择新见解. Comput Electron Agric 2018;149:3- 15. https://doi.org/10.1016/j.compag.2017.09.031.
[22] Wu X, Li Y, Jiang L, Wang Y, Liu X, Li T. 基于热性能的中国日光温室多结构参数系统分析. Energy 2023;273:127193. https://doi.org/10.1016/j.energy.2023.127193.
[23] Esmaeli H, Roshandel R. 基于气候条件的太阳能温室优化设计. Renew Energy 2020;145:1255- 65. https://doi.org/10.1016/j.renene.2019.06.090.
[24] Liu K, Xu H, Li H, Wu X, Sang S, Gao J. 基于太阳辐射模型的不同屋面结构中国日光温室太阳辐射变化分析. Int J Agric Biol Eng 2022;15:221- 9. https://doi.org/10.25165/j.ijabe.20221502.6763.
[25] Zhang R, Liu Y, Zhu D, Zhang X, Ge M, Cai Y. 基于冠层高度的太阳能温室优化设计. J Build Eng 2022;53. https://doi.org/10.1016/j.jobe.2022.104473.
[26] Zhang Y, Xu L, Zhu X, He B, Chen Y. 基于温度-波相互作用理论的中国日光温室热环境模型构建. Energy Build 2023;279. https://doi.org/10.1016/j.enbuild.2022.112648.
[27] Chen C, Yu N, Yang F, Mahkamov K, Han F, Li Y, et al. 被动式太阳能温室物理尺寸选择以提高能源性能的理论与实验研究. Sol Energy 2019;191:46- 56. https://doi.org/10.1016/j.solener.2019.07.089.
[28] Wu G, Yang Q, Zhang Y, Fang H, Feng C, Zheng H. 中国日光温室中集成旋转线性曲面菲涅耳透镜的光伏热力系统能量与光学分析. Energy 2020;197. https://doi.org/10.1016/j.energy.2020.117215.
[29] Liu X, Li Z, Zhang L, Liu Y, Li Y, Li T. 单管截面对中国日光温室骨架结构安全性的影响. Sci Rep 2021;11. https://doi.org/10.1038/s41598- 021- 98779- x.
[30] Wang C, Jiang Y, Wang T, Xu Z, Bai Y. 落地组装式中国日光温室风致响应分析. Biosyst Eng 2022;220:214- 32. https://doi.org/10.1016/J.BIOSYS- TEMSENG.2022.06.003.
[31] Ahamed MS, Guo H, Tanino K. 降低传统温室加热成本的节能技术. Biosyst Eng 2019;178:9- 33. https://doi.org/10.1016/j.biosystemseng.2018.10.017.
[32] Henke M, Buck- Sorlin GH. 使用全光谱光线追踪器计算功能结构植物模型中的光微气候. Comput Inf 2017;36:1492- 522. https://doi.org/10.4149/cai 2017.6.1492.
[33] Zhou N, Yu Y, Yi J, Liu R. 具有太阳能储存和加热功能的塑料温室热计算方法研究. Sol Energy 2017;142:39- 48. https://doi.org/10.1016/j.solener.2016.12.016.
[34] Willockx B, Reher T, Lavaert C, Kerteleer B, Van de Poel B, Cappelle J. 梨园农业光伏系统的设计与评估. Appl Energy 2024;353. https://doi.org/10.1016/j.apenergy.2023.122166.
[35] Xu H, Zhang Y, Li T, Wang R. 中国日光温室内能量分布的简化数值模拟. Appl Eng Agric 2017;33:291- 304.
[36] Singh G, Singh PP, Lubana PPS, Singh KG. 温室微气候数学模型的建立与验证. Renew Energy 2006;31:1541- 60. https://doi.org/10.1016/j.renene.2005.07.011.
[37] Joudi KA, Farhan AA. 创新温室内空气和土壤温度的动态模型与实验研究. Energy Convers Manag 2015;91:76- 82. https://doi.org/10.1016/j.enconman.2014.11.052.
[38] Chen W, Liu W, Liu B. 单坡温室热湿传递的数值与实验分析. Energy Build 2006;38:99- 104. https://doi.org/10.1016/j.enbuild.2005.03.001.
[39] Wang C, Wu H, Jiang Y, Bai Y, Wang T. 雪荷载下带离散侧向支撑的落地组装式中国日光温室稳定性分析. Biosyst Eng 2023;233:168- 80. https://doi.org/10.1016/j.biosystemseng.2023.08.004.
[40] Barrero- Gil J, Huertas R, Rambla JL, Granell A, Salinas J. 番茄植株在冷驯化过程中通过全面转录和代谢调节提高低温耐受性. Plant Cell Environ 2016;39:2303- 18. https://doi.org/10.1111/pce.12799.
[41] Dong Z, Men Y, Liu Z, Li J, Ji J. 叶绿素荧光成像技术在番茄幼苗冷害分析与检测中的应用. Comput Electron Agric 2020;168:105109. https://doi.org/10.1016/j.compag.2019.105109.
[42] Cao K, Xu H, Zhang R, Xu D, Yan L, Sun Y, et al. 改善中国日光温室热环境的可再生与可持续策略. Energy Build 2019;202. https://doi.org/10.1016/j.enbuild.2019.109414.
[43] Golzar F, Heeren N, Hellweg S, Koshadel R. 评估温室能源需求与作物产量的新型综合框架. Renew Sustain Energy Rev 2018;96:487- 501. https://doi.org/10.1016/j.rser.2018.06.046.
[44] Farfan J, Lohrmann A, Breyer C. 温室农业与能源基础设施整合作为食物解决方案. Renew Sustain Energy Rev 2019;110:368- 77. https://doi.org/10.1016/j.rser.2019.04.084.
[45] Achour Y, Ouammi A, Zejli D. 现代可持续温室栽培技术进步：通往精准农业之路. Renew Sustain Energy Rev 2021;147:111251. https://doi.org/10.1016/j.rser.2021.111251.
[46] Cuce E, Harjunowibowo D, Cuce PM. 温室系统的可再生与可持续节能策略：全面综述. Renew Sustain Energy Rev 2016;64:34- 59. https://doi.org/10.1016/j.rser.2016.05.077.
[47] Guan Y, Meng Q, Ji T, Hu W, Li W, Liu T. 太阳能温室中微热管阵列(MHPA)与相变材料蓄热墙热特性的实验研究. Energy 2023;264. https://doi.org/10.1016/j.energy.2022.126183.
[48] He F, Si C, Ding X, Gao Z, Gong B, Qi F, et al. 基于EDFD模拟与熵权法的中国日光温室建筑参数优化. Int J Agric Biol Eng 2023;16:48- 55. https://doi.org/10.25165/j.ijabe.20231606.8331.
[49] Luo Q, Wang J, Zhao L, Zhao S, Wang P, Liang C, et al. 中国日光温室覆盖层在所有运行条件下的热损失评估. Sol Energy 2023;265. https://doi.org/10.1016/j.solener.2023.112137.
[50] Dong Q, Liu J, Qu M. 预测中国日光温室内小时气温的简单模型. Int J Agric Biol Eng 2023;16:56- 60. https://doi.org/10.25165/j.ijabe.20231605.6922.
[51] Wang XL, Sun GC, Zhang LH, Lei WJ, Zhang WK, Li HY, et al. 绿色能源在智能乡村被动供暖中的应用：以济南冬季室内温度自调节温室为例. Energy 2023;278. https://doi.org/10.1016/j.energy.2023.127770.
[52] Shin J, Hwang I, Kim D, Moon T, Kim J, Kang WH, et al. 基于光线追踪模拟评估温室番茄植物的光分布与碳同化：考虑薄膜漫射性与区域太阳辐射. Agric For Meteorol 2021;296. https://doi.org/10.1016/j.agrformet.2020.108219.
[53] Hwang I, Yoon S, Kim D, Kang JH, Kim JH, Son JE. 通过3D植物模型光线追踪模拟评估补光与茎数对温室甜椒生长和产量的影响. Biosyst Eng 2023;226:252- 65. https://doi.org/10.1016/j.biosystemseng.2023.01.010.
[54] Van Der Meer M, De Visser PHB, Heuvelink E, Marcelis LFM. 行向影响番茄篱笆作物的光吸收均匀性但几乎不影响作物光合作用. Silico Plants 2021;3:1- 10. https://doi.org/10.1093/insilicoplants/fvdb025.
[55] Fernandez EF, Villar- Fernández A, Montes- Romero J, Ruiz- Torres L, Rodrigo PM, Manzaneda AJ, et al. 光伏技术在温室农业中潜力的全球能源评估. Appl Energy 2022;309. https://doi.org/10.1016/j.apenergy.2021.11.8474.
[56] Barron- Gafford GA, Pavao- Zuckerman MA, Minor RL, Sutter LF, Barnett- Moreno I, Blackett DT, et al. 农业光伏在干旱地区食物-能源-水关系中提供互惠利益. Nat Sustain 2019;2:848- 55. https://doi.org/10.1038/s41893- 019- 0364- 5.
[57] Gorjian S, Bousi E, Ozdemir OE, Trommosdorff M, Kumar NM, Anand A, et al. 半透明光伏技术在农业光伏系统中作物生产与发电的进展与挑战. Renew Sustain Energy Rev 2022;158. https://doi.org/10.1016/j.rser.2022.112126.
[58] Campana PE, Stridh B, Amaducci S, Colauzzi M. 垂直安装农业光伏系统的优化. J Clean Prod 2021;325. https://doi.org/10.1016/j.jclepro.2021.129091.
[59] Song B, Bai L, Yang L. 太阳辐射对办公楼室内热舒适长期影响的分析. Energy 2022;247. https://doi.org/10.1016/j.energy.2022.123499.
[60] Li Y, Arulnathan V, Heidari MD, Pelletier N. 集约化家禽养殖净零能耗建筑的设计考虑：当前见解、知识差距与未来方向综述. Renew Sustain Energy Rev 2022;154. https://doi.org/10.1016/j.rser.2021.111874.

# References

[1] Dong J, Gruda N, Li X, Cai Z, Zhang L, Dunn Z. Global vegetable supply towards sustainable food production and a healthy diet. J Clean Prod 2022;369. https://doi.org/10.1016/j.jclepro.2022.133212.
[2] Iddio E, Wang L, Thomas Y, McMorrow G, Denzer A. Energy efficient operation and modeling for greenhouses: a literature review. Renew Sustain Energy Rev 2020; 117. https://doi.org/10.1016/j.rser.2019.109480.
[3] Wang T, Wu G, Chen J, Cui P, Chen Z, Yan Y, et al. Integration of solar technology to modern greenhouse in China: current status, challenges and prospect. Renew Sustain Energy Rev 2017;70:1178- 88. https://doi.org/10.1016/J. RSER.2016.12.020.
[4] Xie J, Yu J, Chen B, Feng Z, Li J, Zhao C, et al. Facility cultivation systems "facility agriculture": a Chinese model for the planet. Adv Agron 2017;145:1- 42. https://doi.org/10.1016/j.asgrop.2017.05.005. Academic Press Inc.
[5] Li T, Qi M, Meng S. Sixty years of facility horticulture development in China: achievements and prospects. Acta Hortic Sin 2022;49(10):2119- 30. https://doi.org/10.16420/No.issn.0513- 353x.2022- 0700 [in Chinese].
[6] China issues No. 1. central document for 2023, Chinese rural vitalization tasks. https://english.www.gov.cn/policies/latestcreases/202302/13/content_WS63ea2efcc640a757729e6b4b.html.
[7] Zhang M, Yan T, Wang W, Jia X, Wang J, Klemes JJ. Energy- saving design and control strategy towards modern sustainable greenhouse: a review. Renew Sustain Energy Rev 2022;164. https://doi.org/10.1016/j.rser.2022.112602.
[8] Chen C, Li Y, Li N, Wei S, Yang F, Ling H, et al. A computational model to determine the optimal orientation for solar greenhouses located at different latitudes in China. Sol Energy 2018;165:19- 26. https://doi.org/10.1016/j.solener.2018.02.022.
[9] Choah N, Allouhi A, El Maakoul A, Kouksou T, Saadeddine S, Jamil A. Review on greenhouse microclimate and application: design parameters, thermal modeling and simulation, climate controlling technologies. Sol Energy 2019;191:109- 37. https://doi.org/10.1016/j.solener.2019.08.042.
[10] Mellalou A, Riad W, Mouaky A, Bacaoui A, Outzourhit A. Optimum design and orientation of a greenhouse for seasonal interviewing in Morocco under constant volume constraint. Sol Energy 2021;230:321- 326. https://doi.org/10.1016/j.solener.2021.10.050.
[11] Kim R woo, gu Kim J, Lee I bok, Yeo U hyeon, Lee S yeon, Decano- Valentin C. Development of three- dimensional visualisation technology of the aerodynamic environment in a greenhouse using CFD and VR technology, part 1: development of VR a database using CFD. Biosyst Eng 2021;207:33- 58. https://doi.org/10.1016/j.biosystemseng.2021.02.017.
[12] Zhang X, Wang H, Zou Z, Wang S. CFD and weighted entropy based simulation and optimisation of Chinese Solar Greenhouse temperature distribution. Biosyst Eng 2016;142:12- 26. https://doi.org/10.1016/j.biosystemseng.2015.11.006.
[13] Mobtaker HG, Ajabshirchi Y, Ranjbar SF, Matloobi M. Simulation of thermal performance of solar greenhouse in north- west of Iran: an experimental validation. Renew Energy 2019;135:88- 97. https://doi.org/10.1016/j.renene.2018.10.003.
[14] Baglivo C, Mazzeo D, Panico S, Bonuso S, Matera N, Congedo PM, et al. Complete greenhouse dynamic simulation tool to assess the crop thermal well- being and energy needs. Appl Therm Eng 2020;179:115698. https://doi.org/10.1016/j.applthermaleng.2010.115698.
[15] Bournet PE, Rojano F. Advances of Computational Fluid Dynamics (CFD) applications in agricultural building modelling: research, applications and challenges. Comput Electron Agric 2022;201. https://doi.org/10.1016/j.compag.2022.107277.
[16] An CH, Ri HJ, Han TU, Kim S II, Ju US. Feasibility of winter cultivation of fruit vegetables in a solar greenhouse in temperate zone; experimental and numerical study. Sol Energy 2022;233:18- 30. https://doi.org/10.1016/j.solener.2022.01.024.
[17] Liu R, Li M, Guzman JL, Rodriguez F. A fast and practical one- dimensional transient model for greenhouse temperature and humidity. Comput Electron Agric 2021;186. https://doi.org/10.1016/j.compag.2021.10.186.
[18] Bo Y, Zhang Y, Zheng K, Zhang J, Wang X, Sun J, et al. Light environment simulation for a three- span plastic greenhouse based on greenhouse light environment simulation software. Energy 2023;271. https://doi.org/10.1016/j.energy.2023.126966.
[19] Bonachela S, Lopez JC, Hernandez J, Grandos MR, Magan JJ, Cabrera- Corral FJ, et al. How mulching and canopy architecture interact in trapping solar radiation inside a Mediterranean greenhouse. Agric For Meteorol 2020;294. https://doi.org/10.1016/j.agrformet.2020.108132.
[20] Zhang Y, Henke M, Li Y, Xu D, Liu A, Liu K, et al. Towards the maximization of energy performance of an energy- saving Chinese solar greenhouse: a systematic analysis of common greenhouse shapes. Sol Energy 2022;236:320- 34. https://doi.org/10.1016/j.solener.2022.03.013.
[21] Tong G, Christopher DM, Zhang G. New insights on span selection for Chinese solar greenhouses using CFD analyses. Comput Electron Agric 2018;149:3- 15. https://doi.org/10.1016/j.compag.2017.09.031.
[22] Wu X, Li Y, Jiang L, Wang Y, Liu X, Li T. A systematic analysis of multiple structural parameters of Chinese solar greenhouse based on the thermal performance. Energy 2023;273:127193. https://doi.org/10.1016/j.energy.2023.127193.
[23] Esmaeli H, Roshandel R. Optimal design for solar greenhouses based on climate conditions. Renew Energy 2020;145:1255- 65. https://doi.org/10.1016/j.renene.2019.06.090.
[24] Liu K, Xu H, Li H, Wu X, Sang S, Gao J. Analysis of solar radiation changes in Chinese solar greenhouses with different roof structures based on a solar radiation model. Int J Agric Biol Eng 2022;15:221- 9. https://doi.org/10.25165/j.ijabe.20221502.6763.
[25] Zhang R, Liu Y, Zhu D, Zhang X, Ge M, Cai Y. Optimal design for solar greenhouses based on canopy height. J Build Eng 2022;53. https://doi.org/10.1016/j.jobe.2022.104473.
[26] Zhang Y, Xu L, Zhu X, He B, Chen Y. Thermal environment model construction of Chinese solar greenhouse based on temperature- wave interaction theory. Energy Build 2023;279. https://doi.org/10.1016/j.enbuild.2022.112648.
[27] Chen C, Yu N, Yang F, Mahkamov K, Han F, Li Y, et al. Theoretical and experimental study on selection of physical dimensions of passive solar greenhouses for enhanced energy performance. Sol Energy 2019;191:46- 56. https://doi.org/10.1016/j.solener.2019.07.089.
[28] Wu G, Yang Q, Zhang Y, Fang H, Feng C, Zheng H. Energy and optical analysis of photovoltaic thermal integrated with rotary linear curved Fresnel lens inside a Chinese solar greenhouse. Energy 2020;197. https://doi.org/10.1016/j.energy.2020.117215.
[29] Liu X, Li Z, Zhang L, Liu Y, Li Y, Li T. Effect of single tube sections on the structural safety of Chinese solar greenhouse skeletons. Sci Rep 2021;11. https://doi.org/10.1038/s41598- 021- 98779- x.
[30] Wang C, Jiang Y, Wang T, Xu Z, Bai Y. Analysis of wind- induced responses of landing assembled Chinese solar greenhouses. Biosyst Eng 2022;220:214- 32. https://doi.org/10.1016/J.BIOSYS- TEMSENG.2022.06.003.
[31] Ahamed MS, Guo H, Tanino K. Energy saving techniques for reducing the heating cost of conventional greenhouses. Biosyst Eng 2019;178:9- 33. https://doi.org/10.1016/j.biosystemseng.2018.10.017.
[32] Henke M, Buck- Sorlin GH. Using a full spectral raytracer for calculating light microclimate in functional- structural plant modelling. Comput Inf 2017;36:1492- 522. https://doi.org/10.4149/cai 2017.6.1492.
[33] Zhou N, Yu Y, Yi J, Liu R. A study on thermal calculation method for a plastic greenhouse with solar energy storage and heating. Sol Energy 2017;142:39- 48. https://doi.org/10.1016/j.solener.2016.12.016.
[34] Willockx B, Reher T, Lavaert C, Kerteleer B, Van de Poel B, Cappelle J. Design and evaluation of an agrivoltaic system for a pear orchard. Appl Energy 2024;353. https://doi.org/10.1016/j.apenergy.2023.122166.
[35] Xu H, Zhang Y, Li T, Wang R. Simplified numerical modeling of energy distribution in a Chinese solar greenhouse. Appl Eng Agric 2017;33:291- 304.
[36] Singh G, Singh PP, Lubana PPS, Singh KG. Formulation and validation of a mathematical model of the microclimate of a greenhouse. Renew Energy 2006;31:1541- 60. https://doi.org/10.1016/j.renene.2005.07.011.
[37] Joudi KA, Farhan AA. A dynamic model and an experimental study for the internal air and soil temperatures in an innovative greenhouse. Energy Convers Manag 2015;91:76- 82. https://doi.org/10.1016/j.enconman.2014.11.052.
[38] Chen W, Liu W, Liu B. Numerical and experimental analysis of heat and moisture content transfer in a lean- to greenhouse. Energy Build 2006;38:99- 104. https://doi.org/10.1016/j.enbuild.2005.03.001.
[39] Wang C, Wu H, Jiang Y, Bai Y, Wang T. Stability analysis of landing assembled Chinese solar greenhouses with discrete lateral braces under snow loads. Biosyst Eng 2023;233:168- 80. https://doi.org/10.1016/j.biosystemseng.2023.08.004.
[40] Barrero- Gil J, Huertas R, Rambla JL, Granell A, Salinas J. Tomato plants increase their tolerance to low temperature in a chilling acclimation process entailing comprehensive transcriptional and metabolic adjustments. Plant Cell Environ 2016;39:2303- 18. https://doi.org/10.1111/pce.12799.
[41] Dong Z, Men Y, Liu Z, Li J, Ji J. Application of chlorophyll fluorescence imaging technique in analysis and detection of chilling injury of tomato seedlings. Comput Electron Agric 2020;168:105109. https://doi.org/10.1016/j.compag.2019.105109.
[42] Cao K, Xu H, Zhang R, Xu D, Yan L, Sun Y, et al. Renewable and sustainable strategies for improving the thermal environment of Chinese solar greenhouses. Energy Build 2019;202. https://doi.org/10.1016/j.enbuild.2019.109414.
[43] Golzar F, Heeren N, Hellweg S, Koshadel R. A novel integrated framework to evaluate greenhouse energy demand and crop yield production. Renew Sustain Energy Rev 2018;96:487- 501. https://doi.org/10.1016/j.rser.2018.06.046.
[44] Farfan J, Lohrmann A, Breyer C. Integration of greenhouse agriculture to the energy infrastructure as an alimentary solution. Renew Sustain Energy Rev 2019;110:368- 77. https://doi.org/10.1016/j.rser.2019.04.084.
[45] Achour Y, Ouammi A, Zejli D. Technological progresses in modern sustainable greenhouses cultivation as the path towards precision agriculture. Renew Sustain Energy Rev 2021;147:111251. https://doi.org/10.1016/j.rser.2021.111251.
[46] Cuce E, Harjunowibowo D, Cuce PM. Renewable and sustainable energy saving strategies for greenhouse systems: a comprehensive review. Renew Sustain Energy Rev 2016;64:34- 59. https://doi.org/10.1016/j.rser.2016.05.077.
[47] Guan Y, Meng Q, Ji T, Hu W, Li W, Liu T. Experimental study of the thermal characteristics of a heat storage wall with micro- heat pipe array (MHPA) and PCM in solar greenhouse. Energy 2023;264. https://doi.org/10.1016/j.energy.2022.126183.
[48] He F, Si C, Ding X, Gao Z, Gong B, Qi F, et al. Optimization of Chinese solar greenhouse building parameters based on edfd simulation and entropy weight method. Int J Agric Biol Eng 2023;16:48- 55. https://doi.org/10.25165/j.ijabe.20231606.8331.
[49] Luo Q, Wang J, Zhao L, Zhao S, Wang P, Liang C, et al. Evaluation of thermal loss of Chinese solar greenhouse cover under all operating conditions. Sol Energy 2023;265. https://doi.org/10.1016/j.solener.2023.112137.
[50] Dong Q, Liu J, Qu M. Simple model for predicting hourly air temperatures inside Chinese solar greenhouses. Int J Agric Biol Eng 2023;16:56- 60. https://doi.org/10.25165/j.ijabe.20231605.6922.
[51] Wang XL, Sun GC, Zhang LH, Lei WJ, Zhang WK, Li HY, et al. Application of green energy in smart rural passive heating: a case study of indoor temperature self- regulating greenhouse of winter in Jinan, China. Energy 2023;278. https://doi.org/10.1016/j.energy.2023.127770.
[52] Shin J, Hwang I, Kim D, Moon T, Kim J, Kang WH, et al. Evaluation of the light profile and carbon assimilation of tomato plants in greenhouses with respect to film diffuseness and regional solar radiation using ray- tracing simulation. Agric For Meteorol 2021;296. https://doi.org/10.1016/j.agrformet.2020.108219.
[53] Hwang I, Yoon S, Kim D, Kang JH, Kim JH, Son JE. Evaluation of the effects of supplemental lighting and stem number on greenhouse sweet pepper growth and yield via ray- tracing simulation with 3D plant models. Biosyst Eng 2023;226:252- 65. https://doi.org/10.1016/j.biosystemseng.2023.01.010.
[54] Van Der Meer M, De Visser PHB, Heuvelink E, Marcelis LFM. Row orientation affects the uniformity of light absorption, but hardly affects crop photosynthesis in hedgerow tomato crops. Silico Plants 2021;3:1- 10. https://doi.org/10.1093/insilicoplants/fvdb025.
[55] Fernandez EF, Villar- Fernandez A, Montes- Romero J, Ruiz- Torres L, Rodrigo PM, Manzaneda AJ, et al. Global energy assessment of the potential of photovoltaics for greenhouse farming. Appl Energy 2022;309. https://doi.org/10.1016/j.apenergy.2021.11.8474.
[56] Barron- Gafford GA, Pavao- Zuckerman MA, Minor RL, Sutter LF, Barnett- Moreno I, Blackett DT, et al. Agrivoltaics provide mutual benefits across the food- energy- water nexus in drylands. Nat Sustain 2019;2:848- 55. https://doi.org/10.1038/s41893- 019- 0364- 5.
[57] Gorjian S, Bousi E, Ozdemir OE, Trommosdorff M, Kumar NM, Anand A, et al. Progress and challenges of crop production and electricity generation in agrivoltaic systems using semi- transparent photovoltaic technology. Renew Sustain Energy Rev 2022;158. https://doi.org/10.1016/j.rser.2022.112126.
[58] Campana PE, Stridh B, Amaducci S, Colauzzi M. Optimisation of vertically mounted agrivoltaic systems. J Clean Prod 2021;325. https://doi.org/10.1016/j.jclepro.2021.129091.
[59] Song B, Bai L, Yang L. Analysis of the long- term effects of solar radiation on the indoor thermal comfort in office buildings. Energy 2022;247. https://doi.org/10.1016/j.energy.2022.123499.
[60] Li Y, Arulnathan V, Heidari MD, Pelletier N. Design considerations for net zero energy buildings for intensive, confined poultry production: a review of current insights, knowledge gaps, and future directions. Renew Sustain Energy Rev 2022;154. https://doi.org/10.1016/j.rser.2021.111874.

