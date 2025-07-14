# Variation and simulation of tomato transpiration in a greenhouse under different ventilation modes

# 不同通风模式下温室番茄蒸腾变化与模拟

Jiankun Ge $^{a,b}$ , Sen Wang $^{a,b}$ , Xuewen Gong $^{a,b,*}$ , Yuhao Zhu $^{a,b}$ , Zihui Yu $^{a,b}$ , Yanbin Li $^{a,b}$

$^{a}$  华北水利水电大学水利学院，郑州 450045，中国   $^{b}$  河南省节水农业重点实验室，郑州 450045，中国

# 文章信息

责任编辑：Dr Z Xiying

关键词：通风调控 蒸腾作用 阻力参数 Penman-Monteith模型

# 摘要

温室通风是调节内部微气候、确保作物最佳生长和提高设施农业水分利用效率的关键因素。然而，温室的半封闭特性给准确模拟作物耗水带来了挑战，主要源于Penman-Monteith(P-M)等常用模型参数估算的不确定性。为解决这些问题，本研究通过整合针对温室对流条件定制的阻力参数改进了P-M模型。2020-2021年3-7月在中国农科院新乡综合试验基地开展田间试验，采用自然光照下滴灌番茄，设置两种通风处理：T1(仅开顶窗)和T2(顶窗和南窗全开)。通过分析温室内气象条件和耗水指标，优化了P-M模型的冠层阻力($r_c$)和空气动力学阻力($r_g$)参数。结果表明：通风显著影响各生育期耗水，果实膨大期耗水强度最高(3.39mm/d)；T2处理的$r_c$和$r_g$显著降低，两种处理均以强制对流为主。改进后的P-M模型预测精度高，T1处理低估蒸腾2.15%，T2处理高估6.26%。这些发现为优化温室通风策略提供了可靠框架，可实现作物耗水的精确模拟并提升设施农业资源利用效率。

表1 变量命名表

| 符号 | 定义 |
|------|------|
| cp | 空气定压比热容，1013(J kg−1K−1) |
| D | 深层渗漏(mm) |
| d | 叶片特征长度(m) |
| D | 天数(d) |
| Ep | 累积蒸发量(mm) |
| ET | 日耗水强度(mm d−1) |
| ETc | 实际日蒸腾量(mm) |
| g | 重力加速度，9.8(m s−2) |
| Gr | 格拉晓夫数 |
| gS | 气孔导度(mmol m−2s−1) |
| hS | 传热系数(W m−2K−2) |
| hP | 灌水量(mm) |
| k | 冠层消光系数 |
| kC | 空气导热系数0.0264(W m−1K−1) |
| kGE | Kling-Gupta效率系数 |
| Kw | 水面蒸发系数，0.9 |
| L | 叶片长度(cm) |
| l | 叶片长度(m) |
| LAI | 叶面积指数 |
| LAIe | 有效叶面积指数 |
| MAE | 平均绝对误差 |
| N | 样本量 |
| P | 降雨量(mm) |
| PBIAS | 百分比偏差 |
| Pi | 实际观测值 |
| P | 实际观测值平均值 |
| Qi | 模型预测值 |
| Q | 模型预测值平均值 |
| R² | 决定系数 |
| ra | 空气动力学阻力(s m−1) |
| rc | 冠层阻力(s m−1) |
| Re | 雷诺数 |
| RH | 相对湿度(%) |
| RMSE | 均方根误差 |
| Rm | 净太阳辐射(W m−1) |
| Rn | 冠层截获净辐射(W m−2) |
| rs | 气孔阻力(s m−1) |
| rs | 总太阳辐射(W m−2) |
| Rs | 行距(cm) |
| Sr | 株距(cm) |
| Ta | 气温(°C) |
| Tc | 冠层温度(°C) |
| Tr | 作物蒸腾速率(mm d−1) |
| Ts | 茎流速率(g h−1) |
| U | 地下水补给量(mm) |
| V | 风速(m s−1) |
| VPD | 水汽压亏缺(kPa) |
| W | 叶片宽度(m) |
| Wo | 0-100cm土层初始储水量(mm) |
| Wm | 叶片最大宽度(cm) |
| Wt | 0-100cm土层末期日储水量(mm) |
| β | 空气热膨胀系数，3.315×10−9(1 K−1) |
| γ | 干湿表常数，0.065(kPa K−1) |
| λ | 汽化潜热系数，2.45×106(J kg−1) |
| λET | 潜热通量(W m−2) |
| ρa | 空气密度，1.166(kg m−3) |
| ρb | 空气运动粘度，1.64×10−5(m2 s−1) |
| θf | 田间持水量(cm3cm−3) |
| θw | 萎蔫点(cm3cm−3) |
| Δ | 饱和水汽压-温度曲线斜率(kPa °C−1) |
| r | 预测值与观测值的皮尔逊相关系数 |
| β | 预测值均值与观测值均值之比 |
| γ | 预测值变异系数与观测值变异系数之比 |

# 1. 引言

温室栽培是现代设施农业的基石，在提高农业生产率、改善作物品质、节约资源和推动农业产业结构调整方面发挥着关键作用(Wang and Li, 2010; Chu等, 2004)。在中国，日光温室的推广应用持续扩大，凸显了其在现代农业实践中的重要性。然而，日光温室半封闭或全封闭的设计形成了复杂的内部微气候，其中气体交换对调节环境条件至关重要。温室内空气流通不足会负面影响作物生长，同时增加病虫害风险。因此，通风管理已成为优化温室微气候和促进作物健康生长的研究重点(Chu等, 2004; Liu等, 2018)。

通风在调控温室环境多方面起着关键作用。研究表明，温室内气流条件对植物蒸腾吸收的潜热扩散、作物表面温度和空气阻力分布具有不同程度的影响。由于温室内气流模式直接影响作物生长和蒸腾，理解不同通风策略对蒸腾的影响已成为温室研究的核心目标(Jing, 2024)。

在土壤水分充足的条件下，作物蒸腾主要受光照强度、相对湿度、气温和风速等气象因素影响(Chen et al., 2001)。例如，蒸腾速率与大气湿度呈负相关；较高的湿度会减小叶面与周围空气之间的水汽压差，从而降低蒸腾速率(Zhao et al., 1997; Li et al., 2003)。气温通过两种主要机制影响蒸腾：一是直接通过能量交换改变植物生理活动，二是间接影响大气水汽压亏缺。适度的温度升高通常通过增强气孔导度和植物内部与周围空气之间的水汽压梯度来促进蒸腾。然而，过高的温度会导致气孔关闭，抑制蒸腾(Li et al., 2003; Zhang et al., 2012)。风速在调节蒸腾方面也起着关键作用，它能降低冠层水汽扩散阻力、加速水汽消散，并改变作物表面附近的空气动力学和边界层阻力(Tomonori et al., 2015)。虽然适度的风速会增强蒸腾，但过高的风速可能会抑制气孔导度，从而限制蒸腾(Peng et al., 2009)。

准确评估作物需水量和建立可靠的蒸腾模型对于提高设施农业水分利用效率和作物生产力至关重要(Wu等, 2022a; Su, 2022; Hong等, 2022)。目前已开发出多种温室蒸腾估算方法，从先进的机器学习模型到传统的经验与理论方法。虽然机器学习模型具有较高的预测能力，但其"黑箱"特性往往限制了对其物理过程的理解。此外，这些模型对数据质量和数量高度敏感，可能限制其在多变环境条件下的适用性(Bhagat等, 2022)。相比之下，经验模型(Kool等, 2014; Gong等, 2021a)建立了蒸腾与环境因子间的回归关系，但可移植性较差，易受当地地理、气候和管理措施差异的影响。

理论模型如单源Penman-Monteith(PM)模型(Widmoser, 2009)、双源Shuttleworth-Wallace(S-W)模型(Shuttleworth和Wallace, 1985)、Priestley-Taylor模型(Priestley和Taylor, 1972)以及双作物系数模型(Anderson等, 2017)因其基于基本气象和能量平衡原理而被广泛应用。其中，FAO-56推荐的P-M模型被认为是估算作物蒸散最精确的工具之一(Li, 2021)。然而，P-M模型的精度高度依赖于阻力参数的准确估算，特别是冠层阻力$(r_c)$和空气动力学阻力$(r_a)$，这些参数在温室条件下难以确定。温室通风系统的变化会显著影响内部空气流动、温度场和对流模式，从而改变$r_c$和$r_a$。这些复杂性表明需要改进P-M模型以适应温室局部环境条件。

近期研究强调了P-M模型在温室应用中因参数估算不确定性带来的挑战。例如，Bailey等(1993)发现温室内水汽扩散受气流模式和对流状态影响，涡流在水汽扩散中起重要作用。他们建议引入受通风方式和局部气候条件决定的对流类型(自由、强迫或混合对流)影响的传热系数来估算$r_a$。Gong等(2017)进一步报道使用传热系数估算$r_a$提高了P-M模型蒸腾预测的准确性。风速成为影响温室内对流状态的关键因素，进而影响阻力参数$(r_c$和$r_a)$的估算。由于这些参数对温室环境条件和作物生理动态均敏感，必须根据不同通风策略调整P-M模型以提高预测精度。

本研究通过使用改进的P-M模型，采用针对温室条件优化的阻力参数来解决这些挑战。系统评估了不同通风策略对应的对流状态以及作物生理生态特征，以实现蒸腾的精确模拟。研究聚焦于中国北方覆膜滴灌的日光温室番茄。通过分析不同生育期通风策略对作物耗水和蒸腾的影响，为温室通风科学管理提供了可靠框架。

总之，本研究通过整合针对温室特定对流条件和生理生态指标调整的阻力参数，改进了P-M模型。旨在准确预测温室环境中的作物耗水模式，为优化日光温室通风控制措施及其他管理实践提供重要参考。

# 2. 材料与方法

# 2.1. 试验区概况

本试验于2020和2021年3-7月在位于中国农业科学院新乡综合试验基地$(35^{\circ}9^{\prime}\mathrm{N},113^{\circ}5^{\prime}\mathrm{E})$的日光温室内进行。试验区年均降雨量$573\mathrm{mm}$，年均气温$14.2^{\circ}C$，年均蒸发量$1908.7\mathrm{mm}$，年均日照时数2398.8小时，年均风速$2.3\mathrm{ms}^{-1}$。试验地土壤为粉砂壤土，黏粒$16.9\%$、粉粒$76.7\%$、砂粒$6.4\%$，土壤容重$1.49\mathrm{gcm}^{-3}$，田间持水量$(\theta_{\mathrm{f}})$为$0.32\mathrm{cm}^3\mathrm{cm}^{-3}$，萎蔫点$(\theta_{w})$为$0.09\mathrm{cm}^3\mathrm{cm}^{-3}$。地下水位超过$5\mathrm{m}$，海拔$81\mathrm{m}$，无霜期210天，属暖温带大陆性季风气候。

试验用日光温室呈东西走向，总面积$170\mathrm{m}^2(20\mathrm{m}\times8.5\mathrm{m})$，檐高$3.9\mathrm{m}$。墙体为砖结构，北、东、西三侧内嵌保温材料。屋顶采用钢架支撑，覆盖聚乙烯塑料薄膜，膜上铺设$5\mathrm{cm}$厚棉被以维持适宜室温。温室剖面图和仪器布局见图1。

# 2.2. 试验设计

移栽前使用尿素(氮肥)、硫酸钾(钾肥)和过磷酸钙(磷肥)作为基肥，施用量分别为$51.5\mathrm{kgN}\mathrm{ha}^{-1}$、$62.3\mathrm{kgK}\mathrm{ha}^{-1}$和$7.4\mathrm{kgP}\mathrm{ha}^{-1}$(Thompson, 2023)。随后使用旋耕机将土壤翻耕至$16\mathrm{cm}$深度。在果实膨大期(第1、2、3、4层果实发育阶段)，使用差压式施肥器进行追肥，每次施用$8.6\mathrm{kgN}\mathrm{ha}^{-1}$和$10.4\mathrm{kgK}\mathrm{ha}^{-1}$。整个生长季共进行4次追肥(表1和表2)。

试验所用番茄品种为"金鹏M6"。1月育苗，分别于2020年3月5日和2021年3月7日移栽。移栽后，在土壤表面铺设$0.03\mathrm{mm}$黑色塑料薄膜，并灌水$30\mathrm{mm}$以确保幼苗成活。试验田面积为$17.6\mathrm{m}^2$(长8.8m×宽$2\mathrm{m}$)。当幼苗长出三叶一心时，在温室内按宽窄行(宽行65cm，窄行45cm)定植，种植密度为5.7株$\mathrm{m}^{-2}$。地面覆盖黑色塑料薄膜。土壤被黑色塑料薄膜完全覆盖(覆盖率100%)，有效将土壤蒸发降至可忽略水平。前期研究(Jia等, 2021)表明塑料薄膜可减少高达90%的土壤蒸发，本研究假设土壤蒸发可忽略不计。定植前对$0-40\mathrm{cm}$土层充分灌水保持墒情。为防止阳光直射，在作物冠层高度达到地面$30\mathrm{cm}$前进行遮荫。此期间保持$0-20\mathrm{cm}$土层充分湿润。当作物冠层达到$40\mathrm{cm}$时，将主茎绑缚于吊绳上以支持垂直生长。开花后喷施吲哚乙酸促进坐果。当四层果实坐果后，通过打顶控制植株向上生长。进行人工除草，如发现病虫害则施用农药。番茄生育期划分为四个阶段，如表3所示。

# 2.3. 温室通风系统

试验所用温室设有两个通风口：顶部通风口$(20\mathrm{m}\times0.5\mathrm{m})$和南侧通风口$(20\mathrm{m}\times1.0\mathrm{m})$。设置两种通风处理模式：T1(仅使用顶部通风口)和T2(同时使用顶部和南侧通风口)。每种处理在独立温室内进行，通风管理时间标准化统一。

晴天当温室内温度在7:00-8:00达到约$30^{\circ}\mathrm{C}$时，完全打开通风口进行通风除湿。阴天则在9:30-10:00完全打开通风口进行相同操作。根据当日气温，下午在日落前1-2小时关闭通风口，以防止夜间温室内温度降至$15^{\circ}\mathrm{C}$以下，同时保持通风除湿效果(如夜间温度低于$15^{\circ}\mathrm{C}$则完全关闭通风口；否则部分关闭通风口以维持温度同时确保足够通风除湿)。图2a和b分别展示了温室南侧和顶部通风口。

![](images/984fb138ac53f9a1cd1cfee06964d9cb129d1aef05c1b7e02ab6ac5a9a36b83e.jpg)  
图1. 温室内仪器布局图

# 2.4. 测定项目与方法

# 2.4.1. 气象数据

室外气象数据由全自动气象监测系统(CR119x, Campbell Scientific, Inc, USA)测定，位于温室西侧顶部，观测高度$4.5\mathrm{m}$。温室中心地面$2\mathrm{m}$高度处。总太阳辐射$(R_s)$由日射强度计(LI200x, Campbell Scientific, Inc., USA)测定，净太阳辐射$(R_n)$由净辐射表(NRLITE2, Kipp&Zonen, 荷兰代尔夫特)测定，风速由风速传感器(Wind Sonic Gill, 英国)监测。所有数据每30分钟平均一次并记录于CR1000数据采集器(Campbell, USA)。气温$(T_a)$和相对湿度$(RH)$在地面$2\mathrm{m}$高度和作物冠层高度处使用温湿度记录仪(HOBO RS3-B和U23 Pro v2, Onset Computer Corporation, USA)测定。

# 2.4.2. 蒸腾与灌水量

使用茎流计(Flow32-1k, Dynamax, 美国休斯顿)监测植株茎流速率，每个处理随机选择6株代表性植株进行测定。探针安装在叶柄上方第3和第4节处，距地面约$30-40\mathrm{cm}$，以避免茎流监测时土壤温度的干扰。选定的植株节点用刀具小心切割后涂抹植物油或凡士林防止伤口增生或腐烂。为优化结果，探针用保鲜膜包裹后外加泡沫铝箔保温。实验所用探针型号为SGB9，数据每15分钟自动采集一次并存储于DT80数据采集器(Pata Taker, 澳大利亚)。

灌水频率和水量根据标准蒸发皿(直径$20~\mathrm{cm}$，深度$11~\mathrm{cm}$)的累积蒸发量$(E_{p})$确定(Li等, 2022b)。当$E_{p}$达到$20\pm2\mathrm{mm}$时统一灌水(Gong等, 2017)。试验地配备精度为$0.001\mathrm{m}^3$的水表以精确控制灌水量。每次灌水量$(I_r)$按下式计算：

$$
\mathrm{I_r} = \mathrm{E_p}\cdot \mathrm{K_w} \tag{1}
$$

式中 $I_{r}$ 表示灌水量(mm)，$E_{p}$ 为累计蒸发量(mm)，$K_{W}$ 为水面蒸发系数，取值为0.9以确保充分灌溉(Gong et al., 2017)。

番茄蒸腾量$(ET_c)$采用水量平衡法计算，该方法考虑了所有相关的水分输入和输出：

$$
ET_{c} = P + I_{r} + U - D + (W_{0} - W_{t}) \tag{2}
$$

其中，$ET_{c}$ 表示实际日蒸腾量$(\mathrm{mm})$；$P$ 为降雨量$(\mathrm{mm})$；$I_{r}$ 为灌水量$(\mathrm{mm})$；$U$ 表示地下水补给量$(\mathrm{mm})$；$D$ 为深层渗漏量$(\mathrm{mm})$；$W_{0}$ 和 $W_{t}$ 分别表示观测期初和期末$0 - 100\mathrm{cm}$土层的土壤储水量$(\mathrm{mm})$。

由于试验在温室内进行，降雨量$(P)$假设为零。试验场地地下水位较深(超过$5\mathrm{m}$)，作物无法吸收利用地下水，故$U = 0$。考虑到每次灌水量较小(最大$20~\mathrm{mm}$)且深层渗漏极少，假设$D = 0$。因此，公式可简化为：

$$
ET_{c} = I_{r} + (W_{0} - W_{t}) \tag{3}
$$

最终，日耗水强度$(ET)$通过下式计算：

$$
ET = ET_{c} / D \tag{4}
$$

式中$ET$为日耗水强度(mm/d)，$D$为总观测天数。

# 2.4.3. 土壤含水量

使用TRIME-IPH时域反射仪(Micromodultechnik GmbH, 德国)每7天左右测定$0 - 100\mathrm{cm}$土层土壤含水量，取平均值。为确保测量精度，在不同生育期采用烘干法对仪器进行定期校准。

# 2.4.4. 气孔导度

在果实膨大期晴朗天气下，使用气孔计(AP4, Delta-T Devices, 英国)测定气孔导度$(g_{s})$。每个处理随机选取6株长势均匀的植株，在每株生长点下方第4片叶的中部进行测量。每株重复3次，取平均值作为最终气孔导度值。

# 2.4.5. 叶面积与叶面积指数

叶面积每7-10天测量一次，使用直尺测定每片叶子的长度$(L)$和最大宽度$(W_{m})$。单叶面积通过长度乘以最大宽度，并应用缩减系数$0.64 \cdot L \cdot W_{m}$(Gong et al., 2017)来考虑叶形。叶面积指数(LAI)通过以下公式计算：

![](images/8a11dd2416913fb9ea485c6a388c7312307bb08b50b94e5ce4498c8eee6ed51e.jpg)  
图2. 温室通风口

$$
LAI = \frac{\sum 0.64\cdot L\cdot W_m}{S_I\cdot S_r} \tag{5}
$$

式中$L$表示叶长$(\mathtt{cm})$，$W_{m}$为叶片最大宽度$(\mathtt{cm})$，$S_{I}$为行距$(\mathtt{cm})$，$S_{r}$为株距$(\mathtt{cm})$

# 2.5. P-M模型及参数确定

# 2.5.1. P-M模型

采用Penman-Monteith(P-M)模型模拟温室作物蒸散量$(ET)$，模型表达式如下(Qiu, 2014):

$$
\lambda ET = \frac{\Delta R_n + \rho_a c_p VPD / ra}{\Delta + \gamma(1 + r_c / r_a)} \tag{6}
$$

其中，$\lambda ET$表示潜热通量$(\mathrm{Wm^{- 2}})$；$\lambda$为汽化潜热系数$(2.45\times 10^{6}\mathrm{Jkg}^{- 1})$；$\Delta$为饱和水汽压-温度曲线斜率$(\mathrm{kPa}^{\circ}\mathrm{C}^{- 1})$；$R_{n}^{\prime}$为作物冠层截获的净辐射$(\mathrm{Wm^{- 2}})$；$\rho_{a}$为空气密度$(1.166\mathrm{kg}\mathrm{m}^{- 3})$；$c_{p}$为空气定压比热$(1013\mathrm{J / (kg\cdot K)})$；VPD为水汽压亏缺$(\mathrm{kPa})$；$r_{a}$和$r_c$分别为空气动力学阻力和冠层阻力$(\mathrm{s}\mathrm{m}^{- 1})$；$\gamma$为干湿表常数$(0.065\mathrm{kPaK}^{- 1})$

$R_{n}^{\prime}$表示冠层上方净辐射与透过冠层到达土壤表面的净辐射之差，可由下式表示(Bailey et al., 1993):

$$
R_{n} = R_{n}\left[1 - \mathrm{xp}(-\mathrm{kLAI})\right] \tag{7}
$$

式中$R_{n}$为冠层上方净辐射$(\mathrm{Wm^{- 2}})$，$k$为冠层消光系数，LAI为叶面积指数。其他变量定义同前。该方程突出了冠层结构在决定蒸散可用能量中的关键作用，通过LAI量化。

# 2.5.2. 空气动力学阻力参数

空气动力学阻力$(r_{a})$受空气流体和风速等因素影响。由于空气与水汽之间的涡旋传递，$r_{a}$可用热传导系数$(h_{s})$表示如下(Gong et al., 2021b):

表2 温室内使用的仪器

| 测量数据 | 仪器名称 | 测量位置 |
|---------|---------|---------|
| 总太阳辐射(Rs) | 日射强度计(LADMX, Campbell Scientific公司, 美国) | 地面以上2米高度 |
| 净太阳辐射(Rn) | 净辐射计(NRLITE2, Kipp&Zonen公司, 荷兰代尔夫特) | 地面以上2米高度 |
| 空气温度(Ta)和相对湿度(RH) | 温湿度记录仪(HOBO RS3-B和U23 Pro v2, Onset Computer公司, 美国) | 地面以上2米和作物冠层高度 |
| 风速(V) | 风速传感器(Wind Sonic, Gill公司, 英国) | 地面以上2米高度 |
| 累计蒸发量(Ep) | 20厘米标准蒸发皿 | 作物冠层上方20厘米高度 |
| 气孔导度(gs) | 气孔计(AP4, Delta-T Devices公司, 英国) | 生长点下方第四片叶的中部 |
| 茎流速率(SF) | 包裹式茎流计(Flow32-1k系统, Dynamax公司, 美国休斯顿) | 子叶上方第三和第四节点处 |
| 土壤含水量 | TRIME-IPH时域反射仪(Micromoduletechnik公司, 德国) | 0-100厘米土层 |

表3 2020和2021年温室番茄生育期

| 生育阶段 | 时间 | 作物特征 |
|---------|------|---------|
| 苗期 | 2020-03-05至04-09<br>2021-03-07至04-10 | 从移栽日期到地面覆盖率10% |
| 开花结果期 | 2020-04-10至05-08<br>2021-04-11至05-09 | 从约10%地面覆盖到有效完全覆盖 |
| 果实膨大期 | 2020-05-09至06-05<br>2021-05-02至05-05 | 从有效完全覆盖到成熟开始 |
| 采收期 | 2020-06-06至07-05<br>2021-06-13至07-06 | 从有效完全覆盖到成熟开始 |

$$
\mathrm{r_a} = \frac{\rho_a c_p}{2h_s\mathrm{LAI}} \tag{8}
$$

其中，$r_{a}$为空气动力学阻力$(\mathrm{s}\mathrm{m}^{- 1})$，$h_s$为热传导系数$(\mathrm{W / m^2K})$，LAI为叶面积指数。参数$\rho_{a}$和$c_{p}$分别表示空气密度$(1.166\mathrm{kg}\mathrm{m}^{- 3})$和空气定压比热$(1013\mathrm{J / (kg\cdot K)})$。

热传导系数$(h_{s})$随对流类型变化，可分为自然对流、强制对流或混合对流，取决于Grashof数$(G_{r})$与Reynolds数$(R_{e})$的关系(Bailey et al., 1993; Qiu et al., 2013)。计算$h_{s}$的方程如下：

$$
h_{s} = \left\{ \begin{array}{c c}{0.37\left(\frac{k_{c}}{d}\right)G_{r}^{0.25}} & {G_{r} / R_{e}^{2}\geq 10}\\ {0.60\left(\frac{k_{c}}{d}\right)R_{e}^{0.25}} & {G_{r} / R_{e}^{2}\leq 0.1}\\ {0.1 < G_{r} / R_{e}^{2}< 10}\\ {0.37\left(\frac{k_{c}}{d}\right)\left(G_{r} + 6.92R_{e}^{2}\right)^{0.25}} & {} \end{array} \right\} \tag{9}
$$

当$Gr / Re^2\geq 10$时为自然对流，$Gr / Re^2\leq 0.1$时为强制对流，$0.1< Gr / Re^2 < 10$时则为自然对流和强制对流共存的混合对流。

式中，$k_{c}$为空气导热系数$(0.0264\mathrm{W / (m\cdot K)})$，$d$为叶片特征长度$(\mathbf{m})$。Grashof数$(G_{r})$表征自由对流气流，计算公式如下(Montero et al., 2001):

$$
G_{r} = \frac{\beta gd^{3}|T_{\mathrm{C}} - T_{\mathrm{a}}|}{\mathrm{v}^{2}} \tag{10}
$$

其中，$\beta$为空气热膨胀系数$(3.315\times 10^{- 3}$ $\mathbb{K}^{- 1})$，$g$为重力加速度$(9.8\mathrm{ms}^{- 2})$，$T_{c}$为冠层温度$(^{\circ}\mathbb{C})$，$T_{a}$为空气温度$(^{\circ}\mathbb{C})$，$\nu$为空气运动粘度$(1.64\times 10^{- 5}\mathrm{m}^{2}\mathrm{s}^{- 1})$。

Reynolds数$(R_{e})$表征强制对流，表达式为：

$$
\mathrm{R_e} = \frac{\mathrm{Vd}}{\mathrm{v}} \tag{11}
$$

式中，$V$为风速$(\mathrm{ms}^{- 1})$，$\nu$为空气运动粘度$(1.64\times 10^{- 5}\mathrm{m}^{2}\mathrm{s}^{- 1})$。叶片特征长度$(d)$计算公式如下(Montero et al., 2001):

$$
\mathsf{d} = \frac{2}{(1 / 1) + (1 / \mathsf{w})} \tag{12}
$$

其中，$l$和$w$分别表示叶片的长度和宽度$(\mathbf{m})$。

# 2.5.3. 冠层阻力参数

气孔阻力$(r_s)$常用于估算冠层阻力$(r_c)$，其关系如式(13)所示(Lovelli et al., 2008)。在Penman-Monteith模型中，$r_s$是计算$r_c$的关键参数，受作物叶片气孔开闭程度影响。在最优灌溉条件下，气孔开闭主要受气象因素调控，因此可通过$r_s$与温室气象变量的关系来估算$r_s$。

$$
r_c = \frac{r_s}{\mathrm{LAI}_e} \tag{13}
$$

式中，$r_c$表示冠层阻力$(\mathbf{s}\mathbf{m}^{- 1})$，$r_s$表示气孔阻力$(\mathbf{s}\mathbf{m}^{- 1})$，$LIA_{e}$为有效叶面积指数，用于调节叶面积对冠层阻力的影响。气孔阻力$(r_s)$反映作物叶片气孔开闭程度，是决定$r_c$的基础因素。

在充分灌溉条件下，气孔行为主要受气象因素调控，其中总太阳辐射$(R_s)$被确定为影响$r_s$的主导因素(Bailey et al., 1993)。该关系已在黄瓜(Yan et al., 2019)、辣椒(Qiu, 2014)和水稻(Inoue et al., 1984)等多种作物中得到验证。$r_s$与$R_s$的关系如下：

$$
r_{s} = 255.92\mathrm{exp}\left(-\frac{R_{S}}{99.27}\right) + 81.72 \tag{14}
$$

其中$r_s$为气孔阻力$(\mathbf{s}\mathbf{m}^{- 1})$，$R_s$为总太阳辐射$(\mathbf{W}\mathbf{m}^{- 2})$。图3所示的拟合结果证明了该关系的高精度，其$R^2$值为0.99，平均绝对误差(MAE)为$3.49\mathrm{s}\mathrm{m}^{- 1}$，均方根误差(RMSE)为$5.49\mathrm{sm}^{- 1}$。这些指标凸显了该模型基于太阳辐射预测$r_s$的稳健性。

有效叶面积指数$(LAI_{e})$是决定冠层阻力的另一关键因素。其取值依据特定条件确定：当LAI≤2时，$LAI_{e}$等于LAI；当2<LAI<4时，$LAI_{e}$设为2；当LAI≥4时，$LAI_{e}$按LAI/2计算(Jesus et al., 2003; Zhou et al., 2008)。这些条件考虑了随着冠层密度增加，额外叶面积对冠层阻力的影响逐渐减弱。

![](images/85583e197ad0beff9097e81e833969ef6aff0fac84d72870668b1fd0d89a167a.jpg)  
图3. 气孔阻力$(r_s)$实测值与计算值的拟合结果

综上所述，在P-M模型中，气孔阻力$(r_s)$是估算冠层阻力$(r_c)$的基础。$r_s$对总太阳辐射$(R_s)$的强依赖性凸显了在最优灌溉条件下气象因素调控气孔行为的关键作用。此外，有效叶面积指数$(LAI_e)$修正了冠层密度对阻力的影响，确保$r_c$的准确建模。这些关系共同增强了对植物-大气相互作用的理解，从而能更精确地预测蒸散发$(ET)$。

# 2.6. 评价方法与指标

数据分析采用IBM SPSS 26统计软件完成，图表绘制使用Microsoft Excel 2019和Origin 2020。模型精度通过以下指标评估：均方根误差(RMSE)、平均绝对误差(MAE)、决定系数$(R^2)$、Kling-Gupta效率系数(KGE)和百分比偏差(PBIAS)(Zheng等, 2021)。

MAE和RMSE值越小表明预测精度越高，而$R^2$反映预测值与实际观测值的拟合程度，越接近1表示拟合越好。KGE取值范围为负无穷至1，是模型整体性能的度量指标，值越高性能越好。具体而言：$0 \leq KGE \leq 0.5$表示性能较差；$0.50 \leq KGE \leq 0.75$表示性能可接受；$0.75 \leq KGE \leq 0.9$表示性能良好；$KGE \geq 0.9$表示性能优异。

KGE是综合相关性、偏差和变异性三组分的性能指标，其取值范围从性能较差到1(性能优异)。具体评价标准为：$0 \leq KGE < 0.5$表示性能较差；$0.5 \leq KGE < 0.7$表示性能可接受；$0.75 \leq KGE < 0.9$表示性能良好；$KGE \geq 0.9$表示性能优异。

PBIAS最优值为0，负值表示模型倾向于高估，正值表示低估。对于日尺度评估，PBIAS性能分级如下：$PBIAS \geq \pm 15\%$为不达标；$\pm 10\% \leq PBIAS \leq \pm 15\%$为可接受；$\pm 5\% \leq PBIAS \leq \pm 10\%$为良好；$PBIAS \leq \pm 5\%$为优秀(Yonaba等, 2021)。各指标计算公式如下：

$$
\mathrm{RMSE} = \left[\sum_{i = 1}^{N}\frac{(Q_i - P_i)}{N}\right]^{0.5} \tag{15}
$$

式中$Q_i$为模型预测值，$P_i$为实际观测值，$N$为分析样本量。

$$
\mathrm{MAE} = \frac{1}{N}\sum_{i = 1}^{N - N}Q_{i} - P_{i} \tag{16}
$$

MAE为预测值$(Q_i)$与观测值$(P_i)$绝对差值的平均值，$N$为总样本数。

$$
R^{2} = \left[\frac{\sum_{i = 1}^{N}(Q_{i} - \overline{Q})(P_{i} - \overline{P})}{\sqrt{\sum_{i = 1}^{N}(Q_{i} - \overline{Q})^{2}\sqrt{\sum_{i = 1}^{N}(P_{i} - \overline{P})^{2}}}}\right]^{2} \tag{17}
$$

$R^2$为决定系数，$\overline{Q}$为观测值均值，$\overline{P}$为预测值均值。

$$
KGE = 1 - \sqrt{(r - 1)^2 + (\beta - 1)^2 + (\gamma - 1)^2} \tag{18}
$$

KGE包含三个组分：$\gamma$为预测值与观测值的Pearson相关系数；$\beta$为预测值均值与观测值均值之比；$\gamma$为预测值变异系数与观测值变异系数之比。

$$
PBIAS(\%) = \frac{\sum_{i = 1}^{N}(P_i - Q_i)}{\sum_{i = 1}^{N}P_i}\cdot 100 \tag{19}
$$

PBIAS量化模型预测偏差百分比，0表示无偏差，偏离0表示存在高估或低估倾向。

这些指标共同构成了评估模型性能的完整框架。通过整合误差幅度、相关性、偏差和变异性等度量，该分析全面评估了模型的预测准确性，并明确了改进方向。

# 3. 结果与分析

# 3.1. 温室气象环境特征

通风在调控温室微气候中具有关键作用，直接影响内外环境间水汽和能量的交换。通过分析不同通风条件下气象参数的变化，可为优化温室环境控制策略提供重要依据(Ge等, 2019)。本节分析2020-2021年番茄生育期内两种通风处理(T1和T2)下的风速、温度和相对湿度动态。

# 3.1.1. 风速变化

图4展示了2020-2021年番茄全生育期内T1和T2通风条件下的最大最小风速变化。风速$(V)$在苗期和花期波动较小，而在果实膨大期和采收期波动较大。特别是最小风速常低于$0.2\mathrm{m/s}$。

2020年，T1和T2处理下记录的最大风速分别为$0.75 \mathrm{m} \mathrm{s}^{- 1}$和$1.55 \mathrm{m} \mathrm{s}^{- 1}$，分别出现在苗期和采收期。2021年，T1和T2处理的最大风速分别为$0.48 \mathrm{m} \mathrm{s}^{- 1}$和$1.38 \mathrm{m} \mathrm{s}^{- 1}$，峰值出现在开花坐果期和果实膨大期。两年间，T1处理下平均最大风速约为最小风速的9倍，而T2处理下最大风速是最小风速的11倍。此外，T2处理的平均最大风速是T1的2.5倍，平均最小风速是T1的2.1倍。

图5显示了每日8:00至20:00的平均风速变化。图6展示了生长后期晴天的逐时风速变化。基于选定的三天数据（2020年5月11日、16日、18日和2021年5月8日、9日、28日）平均计算表明，0:00-8:00和20:00-23:00时段的风速在两种处理间相似且波动较小。这验证了选择8:00-20:00计算日平均风速的合理性，因为温室通风通常在此时间段进行以维持作物适宜温度，下午关闭通风口后夜间风速普遍较低。

![](images/49f295796490d402e2bbe52ad945386246682f67d394dfcbc3d25a7e7b844d61.jpg)  
图4. 2020-2021年番茄全生育期T1和T2温室风速极值$(V)$变化

![](images/9fd4c5632423025040df841f4c68c953c44a089d27791b1962faa51aef3b5149.jpg)  
图5. 2020-2021年番茄全生育期T1和T2温室日平均风速(V)变化

![](images/289861c412e9e2e9d507f97b19f27ea9eef153547d4a54557f9897f98a49abf7.jpg)  
图6. 2020-2021年番茄果实膨大期晴天风速(V)日变化

图6显示T2处理的风速值在生长后期高于T1。同样，图6表明8:00-20:00时段T2的风速变化幅度也大于T1，且年际变化趋势相似。总体而言，2020-2021年间T2通风条件的气流组织和通风效果均优于T1。

# 3.1.2. 温湿度变化特征

图7展示了生长后期（5月11日至6月20日）T1和T2处理下气温$(Ta)$和相对湿度$(RH)$的变化。T1处理的$Ta$范围为$21.6 - 42.4^{\circ}C$，T2为18.9 - $38.1^{\circ}C_{i}$，平均值分别为$33.6^{\circ}C$和$31.5^{\circ}C_{i}$。T1处理的$RH$范围为$38.9 - 98.6\%$，T2为$34.8 - 96.0\%$，平均值分别为$65.5\%$和$57.9\%$。两年数据均显示生长后期T1的日均$Ta$和$RH$高于T2。

T1处理的日均$Ta$比T2高$2^{\circ}C$，日均$RH$高$8\%$。这些结果明确表明更高的通风率导致更低的$Ta$和$RH$。增强通风促进了温室内更好的空气循环，缓解了高湿高温环境，为植物生长创造了更有利的条件。

# 3.2. 不同通风条件对番茄气孔导度及茎流速率的影响

# 3.2.1. (1) 通风条件对气孔导度的影响

气孔导度$(g_{s})$能有效反映作物蒸腾的生理生态状况(Gong等, 2021c)。本研究中总太阳辐射$(R_{s})$不受通风显著影响，各处理间$R_{s}$值相近。基于2021年5月9日、20日、28日三天晴天的数据计算显示（图8），T1和T2处理的平均$g_{s}$分别为483.6和$575.4 \mathrm{mmol / (m^2\cdot s)}$，峰值$g_{s}$分别为768.3和$806.7 \mathrm{mmol / (m^2\cdot s)}$。

图8显示所有处理的$g_{s}$均呈单峰曲线，在12:00左右达到峰值。T2处理的平均和峰值$g_{s}$均高于T1。这归因于T2区更大的通风面积和更高风速，降低了气孔周围气体浓度梯度，促进气体交换和开度(Shapira等, 2024)。

![](images/d556774c50324227b98aa6247a4ea27558f9b6a53157972aaa1edc66f48fcbaa.jpg)  
图7. 2020-2021年生长后期温度(Ta)和湿度(RH)日均值变化(T1, T2)

![](images/f16869dab73a3b49747cfdfc84b18f83607887a9895641ab99087442dab29715.jpg)  
图8. 2021年晴天条件下(08:00-18:00)各处理叶片气孔导度(gs)与太阳辐射$(R_{s})$变化

# 3.2.2. (2) 不同通风条件对番茄茎流速率的影响

茎流(SF)反映作物蒸腾耗水。为研究通风影响，计算了果实膨大期五种典型天气（晴、阴、多云）下的平均SF值（图9）。晴天SF呈单峰曲线，阴天和多云天气因辐射不稳定呈双峰曲线。晴天T1和T2的平均SF分别为$102.74\mathrm{g}\mathrm{h}^{- 1}$$(0.58\mathrm{mmh^{- 1}})$和$167.44\mathrm{g}\mathrm{h}^{- 1}$$(0.94\mathrm{mmh^{- 1}})$；阴天T2日均SF$122.07\mathrm{g}\mathrm{h}^{- 1}$$(0.69\mathrm{mmh^{- 1}})$高于T1；多云天气T1和T2分别为$42.05\mathrm{g}\mathrm{h}^{- 1}$$(0.24\mathrm{mmh^{- 1}})$和$76.91\mathrm{g}\mathrm{h}^{- 1}$$(0.44\mathrm{mmh^{- 1}})$。

茎流速率总体表现为：晴天$\gimel$阴天$\gimel$多云。且所有天气条件下T2的SF均大于T1，表明改善通风条件能提升植物茎流速率从而促进蒸腾。通风条件对SF的影响$(P< 0.05)$具有统计显著性，证实T2通风改进有助于获得更好的生理表现。

图10展示了过去两年两种不同通风条件下番茄整个生育期的茎流(蒸腾)变化。总体趋势表现为：苗期蒸腾量较小，开花结果期显著增加，果实膨大期达到最大值，采收期略有下降，且整体呈现$\mathrm{T2 > T1}$的规律。

# 3.3. 不同通风条件对温室番茄耗水量的影响

2020-2021年试验期间共进行15次灌溉，其中苗期2次、开花结果期4次、果实膨大期6次、采收期3次，各处理灌溉量保持一致。

图11展示了不同通风条件下T1和T2处理在整个生育期的平均耗水量差异。值得注意的是，在苗期、开花结果期和果实膨大期，T2处理的平均耗水量分别比T1高$8.54\%$、$0.79\%$和$8.02\%$；而在采收期，T2处理的平均耗水量比T1低$9.77\%$。这些结果表明通风因素会影响耗水量，尤其在采收阶段表现更为明显。

2020-2021年温室番茄在不同处理下的日均耗水量从高到低排序为：果实膨大期$3.39\mathrm{mm}\mathrm{d}^{- 1}$、采收期$2.89\mathrm{mm}\mathrm{d}^{- 1}$、开花结果期$2.68\mathrm{mm}\mathrm{d}^{- 1}$、苗期$1.54\mathrm{mm}\mathrm{d}^{- 1}$。

![](images/1c9914bd2492ba35c1921ef14a5a68415c5eae279c381d2154d561c316b76142.jpg)  
图9. 2021年晴、阴、多云天气条件下茎流速率(SF)与太阳辐射$(R_{s})$的日变化

![](images/fd822789150cd6a005cd8d905fcdf8389a00a6a660faefb7e39660b2da4b9d39.jpg)  
图10. 全生育期作物茎流变化

![](images/282e0c3cb65ae2e418c835affb90ffcc2069a5a3e229e8cfa94332297fb111e2.jpg)  
图11. 2020-2021年番茄不同生育阶段各处理的灌溉量$(I_r)$与耗水量(ET)变化

# 3.4. P-M模型改进及不同通风条件下的模拟

# 3.4.1. 温室番茄冠层阻力变化规律

图12展示了2020-2021年温室滴灌番茄冠层阻力$(r_c)$与叶面积指数(LAI)的变化关系。苗期$r_c$随LAI增加快速下降，开花结果期和果实膨大期$r_c$随LAI增加下降趋缓。这一趋势归因于番茄生长过程中LAI逐渐增加，导致$r_c$降低。

当LAI<1.0时，两年间T1和T2处理的平均$r_c$分别为$604.58 \mathrm{~s} \mathrm{~m}^{- 1}$和$471.58 \mathrm{~s} \mathrm{~m}^{- 1}$；当LAI>1.0时，平均$r_c$分别为$95.18 \mathrm{~s} \mathrm{~m}^{- 1}$(T1)和$96.94 \mathrm{~s} \mathrm{~m}^{- 1}$(T2)。这些发现表明通风条件显著影响冠层阻力：LAI<1.0时T1的$r_c$比T2高$28.2\%$，整个生育期T1的平均$r_c$比T2高$19.9\%$。冠层阻力主要与气孔阻力和作物LAI相关，生育期内风速变化也会影响作物叶面积，导致不同通风条件下$r_c$值存在差异。

$r_c$的差异可归因于气孔阻力和LAI的变化，两者均受通风条件影响。不同通风设置下的风速变化直接影响作物叶面积，进而影响$r_c$。因此，准确估算$r_c$必须考虑整个生育期内通风条件的变化，以确保冠层阻力模型的精确性。

![](images/34a0604090156a7af141935c5f9d86512156d698b95d9d62bff44e0072c1b0ee.jpg)  
图12. 2020-2021年不同通风条件下温室番茄冠层阻力$(r_c)$与叶面积指数(LAI)的变化

# 3.4.2. 空气动力学阻力参数变化规律

# 1. 温室内对流条件分析

2020-2021年观测期间，温室内平均净辐射$(R_{n})$分别为$98.80\mathrm{Wm^{- 2}}$和$102.22\mathrm{Wm^{- 2}}$。T1和T2处理的平均风速分别为$0.09\mathrm{ms}^{- 1}$和$0.15\mathrm{ms}^{- 1}$。番茄特征叶长平均值分别为T1处理$7.4\mathrm{cm}$、T2处理$6.3\mathrm{cm}$。计算空气动力学阻力$(r_a)$需要确定传热系数$(h_s)$，这需要根据$G_{r} / R_{e}^{2}$比值对温室内对流类型进行分类。

传热系数$(h_s)$随对流类型而变化，可分为三类(Bailey等, 1993; Qiu等, 2013)：当$G_{r} / R_{e}^{2}$$\geq 10$时为自然对流，$G_{r} / R_{e}^{2}\leq 0.1$时为强制对流，$0.1< G_{r} / R_{e}^{2}< 10$时为混合对流。

图13展示了2020-2021年整个生育期T1和T2通风条件下温室内$G_{r} / R_{e}^{2}$的变化。T1条件下混合对流平均占$20.2\%$，T2条件下占$10.3\%$，其余时段均为纯强制对流，未观察到自然对流实例。这表明不同通风条件影响温室内的对流状况，混合对流主要发生在生长早中期。

# 2. 空气动力学阻力评估

在整个生育期内未观察到纯自由对流现象，因此计算$r_a$时排除了纯对流条件下的传热系数。根据每日观测到的对流条件，采用不同对流条件下的传热系数计算了整个生育期的综合$r_a$值。

图14展示了2020-2021年温室番茄空气动力学阻力$(r_a)$与风速在整个生育期的变化。两年间不同条件下$r_a$变化趋势相似，随着番茄生长逐渐降低，苗期$r_a$最大值达$212.9\mathrm{sm}^{-1}$，全生育期平均$r_a$为$93.2\mathrm{sm}^{-1}$。T2条件下苗期平均$r_a$为$164.2\mathrm{sm}^{-1}$，T1条件下全生育期平均$r_a$为$72.4\mathrm{sm}^{-1}$。苗期$r_a$值高于全生育期，T1条件下苗期$r_a$比T2高$29.7\%$，全生育期$r_a$比T2高$28.7\%$。这些结果表明$r_a$受风速和通风条件显著影响，T2条件下的$r_a$值小于T1条件。

T1与T2条件下$r_a$的差异可归因于风速变化对空气动力学阻力的直接影响。T2条件下持续较低的$r_a$值突显了改善通风对降低空气动力学阻力和增强温室内空气循环的作用。这些发现强调了优化通风策略以改善空气动力学条件的重要性，从而为番茄栽培创造更高效的温室微气候。

# 3.5. P-M模型在日光温室中的改进与适用性评价

在2020-2021年整个生育期内，T1和T2条件下均未出现日尺度的纯自然对流现象。通过将P-M模型与两种空气动力学阻力模型结合并与实测值拟合，估算了日蒸腾量$(T_{T})$，如图15和表4所示。

2020年T1条件下，P-M模型在果实膨大期模拟的$T_{r}$与实测值最为接近，仅高估$0.59\%$；苗期、开花结果期和采收期分别低估$22.42\%$、$11.41\%$和高估$8.81\%$。T2条件下，开花结果期模拟$T_{r}$与实测值最为接近，仅高估$2\%$；苗期、果实膨大期和采收期分别低估$11.97\%$、高估$4.99\%$和$11.43\%$。

2021年T1条件下，果实膨大期P-M模型与实测值最为接近，仅低估$0.08\%$；苗期、开花结果期和采收期分别低估$20.10\%$、$2.11\%$和高估$5.05\%$。T2条件下，开花结果期P-M模型与实测值最为接近，仅低估$0.58\%$；苗期、果实膨大期和采收期分别低估$11.96\%$、高估$9.69\%$和$21.82\%$。

整个生育期内，2020年T1条件下模型斜率接近1.0，低估$T_{r}$ $3.74\%$，$R^2=0.91$，MAE为$0.44\mathrm{mm}\mathrm{d}^{-1}$，$RMSE=0.55\mathrm{mm}\mathrm{d}^{-1}$，$KGE=0.89$；T2条件下斜率为1.03，略高估$4.05\%$，$R^2=0.94$，$MAE=0.39\mathrm{mm}\mathrm{d}^{-1}$，$RMSE=0.55\mathrm{mm}\mathrm{d}^{-1}$，$KGE=0.95$。2021年T1条件下斜率为0.96，低估$T_{r}$ $0.55\%$，$R^2=0.93$，$MAE=0.38\mathrm{mm}\mathrm{d}^{-1}$，$RMSE=0.55\mathrm{mm}\mathrm{d}^{-1}$，$KGE=0.96$；T2条件下斜率为1.11，高估$8.46\%$，$R^2=0.91$，$MAE=0.56\mathrm{mm}\mathrm{d}^{-1}$，$RMSE=0.84\mathrm{mm}\mathrm{d}^{-1}$，$KGE=0.89$。

综合两年全生育期数据，P-M模型在T1条件下平均低估实测值$2.15\%$，T2条件下平均高估$6.26\%$。尽管在不同条件下存在轻微高估或低估，P-M模型与实测蒸腾数据表现出强相关性，在T1和T2条件下均显示出良好的模拟精度。改进后的P-M模型结合空气动力学阻力参数，可有效估算不同通风条件下温室番茄的日蒸腾速率，体现了模型的稳健性和准确性。

# 4.讨论

环境因素包括太阳辐射、气温$(T_{a})$、相对湿度(RH)和通风率对温室作物生长具有重要影响(Lei等,2023;Zhang等,2021)。评估温室作物蒸腾时必须考虑这些气象因素的影响(Ge等,2022)。温室作物蒸腾理论模型的构建主要基于温室气象数据。本研究发现，与T2(高通风)条件相比，T1(低通风)条件下温室内$T_{a}$和RH更高；而T2条件下番茄SF、气孔导度$(g_{s})$和耗水量更高。这归因于改善通风增加了温室内气流，更大的通风面积降低了水汽扩散阻力，加速了叶片周围气体交换，使温湿度分布更均匀，从而促进叶片蒸腾、光合作用等生理过程，最终降低内部温湿度，同时提高SF、gs和耗水量。先前研究表明提高风速可改善作物SF、gs和蒸腾速率(Spinelli等,2018)。

![](images/1884efae0366ccfee4e00f7c4a02c0c4d0eb13c311c39df060f660264d2aa357.jpg)  
图13. 基于$\mathrm{Gr}/\mathrm{Re}$分类的2020-2021年温室内对流类型(虚线表示纯强制对流与混合对流分界线$\mathrm{Gr}/\mathrm{Re}=0.1$)

![](images/34f1c6897fb1afe8c0f732e6f3dbb25d8927daccb63783fbdc741b36eecfb265.jpg)  
图14. 2020-2021年不同通风条件下温室番茄空气动力学阻力$(r_{a})$与风速$(V)$

![](images/efb6dad58dc856bb437895e5e1585afca2cfb742996477959f16795bd1b56784.jpg)  
图15. 2020-2021年P-M模型结合不同阻力参数计算的蒸腾预测值与实际值拟合

表4 改进P-M模型计算的ET值与实测值拟合结果如下：

| 年份 | 处理 | 生育期 | R² | MAE | RMSE | KGE | PBIAS |
|------|------|--------|----|-----|------|-----|-------|
| 2020 | T1 | 苗期 | 0.94 | 0.42 | 0.51 | 0.72 | 22.3% |
| 2020 | T1 | 开花结果期 | 0.91 | 0.46 | 0.6 | 0.88 | 11.4% |
| 2020 | T1 | 果实膨大期 | 0.76 | 0.49 | 0.59 | 0.82 | -0.3% |
| 2020 | T1 | 收获期 | 0.94 | 0.4 | 0.48 | 0.91 | -8.8% |
| 2020 | T2 | 全生育期 | 0.91 | 0.44 | 0.55 | 0.89 | 3.8% |
| 2020 | T2 | 苗期 | 0.8 | 0.36 | 0.43 | 0.77 | 12% |
| 2020 | T2 | 开花结果期 | 0.81 | 0.35 | 0.56 | 0.9 | -2% |
| 2020 | T2 | 果实膨大期 | 0.89 | 0.29 | 0.46 | 0.93 | -5.1% |
| 2020 | T2 | 收获期 | 0.89 | 0.57 | 0.72 | 0.86 | -11.4% |
| 2020 | T2 | 全生育期 | 0.94 | 0.39 | 0.55 | 0.95 | -4.1% |
| 2021 | T1 | 苗期 | 0.65 | 0.27 | 0.42 | 0.69 | 19.9% |
| 2021 | T1 | 开花结果期 | 0.9 | 0.44 | 0.54 | 0.9 | 2.1% |
| 2021 | T1 | 果实膨大期 | 0.82 | 0.49 | 0.66 | 0.86 | -0.1% |
| 2021 | T1 | 收获期 | 0.97 | 0.29 | 0.39 | 0.94 | -5.1% |
| 2021 | T2 | 全生育期 | 0.93 | 0.38 | 0.55 | 0.76 | 0.5% |
| 2021 | T2 | 苗期 | 0.71 | 0.22 | 0.27 | 0.93 | 12% |
| 2021 | T2 | 开花结果期 | 0.92 | 0.35 | 0.48 | 0.95 | 0.6% |
| 2021 | T2 | 果实膨大期 | 0.81 | 0.76 | 1.06 | 0.88 | -8.5% |
| 2021 | T2 | 收获期 | 0.88 | 0.96 | 1.23 | 0.76 | -21.8% |
| 2021 | T2 | 全生育期 | 0.91 | 0.56 | 0.84 | 0.89 | -8.4% |

在无地下水补给的温室中，灌溉是土壤水分的唯一来源，这使得通风直接影响温室内部的湿热环境。蒸腾作用$(T_{r})$在田间动态水循环(Yan and Li, 2018)和能量平衡(Marras et al., 2016)研究中具有重要作用，是农业生产中的关键参数。理解作物$T_{r}$有助于制定高效灌溉策略(Jaafar et al., 2017)，从而最大化水资源利用效率。理论模型如P-M模型为解决这些挑战提供了有效途径，为估算不同环境条件下的$T_{r}$提供了框架。P-M模型已被广泛用于模拟$T_{r}$，其准确性高度依赖于冠层阻力$(r_{c})$和空气动力学阻力$(r_{a})$的精确估算(Shao et al., 2022; Wu et al., 2022b)。值得注意的是，温室环境中的$r_{a}$与大田条件不同，直接应用大田参数可能导致显著误差(Li et al., 2022a)。

本研究分析了P-M模型在不同通风条件下估算温室番茄日蒸腾量的适用性，并通过讨论冠层和空气动力学阻力参数对其进行了改进。结果表明阻力参数$(r_{c}$和$r_{a}$显著影响$T_{r}$，其中T2通风条件下的番茄阻力明显更低。本研究通风口数量多且风速测量仪器靠近通风口，使得强制对流成为大部分生育期的主导对流类型。T1和T2条件下的平均雷诺数$(r_{e})$分别为398和630，与Bailey等(1993)的观测结果(105-550)一致，但高于Qiu等(2013)的结果(106-114)。这种差异可归因于通风口数量、风速测量设置以及可能使用的温室类型不同。

本研究中格拉晓夫数$(G_{r})$范围为$0.5\times 10^{4}$至$2\times 10^{4}$，低于Qiu等(2013)的结果$(4\times 10^{4} - 4.1\times 10^{4})$，但与Bailey等(1993)的观测$(1\times 10^{4} - 5\times 10^{4})$相似。在塑料薄膜温室中，Bailey等(1993)发现较低的$G_{r}$值，范围为$3\times 10^{3} - 8\times 10^{3}$。这些差异可归因于通风系统、温室类型和作物品种的变化，这些因素都会影响位移高度$(d)$、风速$(V)$、冠层与空气温差$(\mathrm{T_c - T_a})$以及叶片特性等参数。

为提高$T_{r}$估算精度，本研究根据对流条件选择了适当的热传导系数用于$r_{a}$的日计算。2020和2021年的结果均显示，苗期$r_{a}$高于其他生育期。这是因为苗期通风口大多关闭导致风速较低。此外，由于风速对空气动力学阻力的直接影响，T1条件下的$r_{a}$通常高于T2条件。不同通风条件下$r_{a}$值的显著差异强化了估算作物蒸腾时考虑通风的重要性。然而，基于不同对流模式改进空气动力学阻力可能会引入$T_{r}$估算偏差。特别是当对流模式分类错误时，会导致温室番茄$T_{r}$的高估。这一潜在误差来源与Yan等(2019)在Venlo型温室黄瓜研究中的发现一致，他们也注意到不同通风条件导致空气动力学阻力变化，进而影响作物蒸腾速率。

综合本研究和前人研究结果可见，必须考虑通风条件对空气动力学阻力的影响才能确保蒸腾估算的准确性。改进后的P-M模型结合了混合和强制对流条件，基于斜率和精度指标的综合评估，在不同通风模式下表现出高模拟精度。该模型为估算温室作物日蒸腾量提供了更可靠的工具，特别是在采用不同通风策略时。

# 5.结论

本研究通过两年试验对温室番茄栽培中作物蒸腾量$(T_{r})$进行了全面量化，并分析了影响$T_{r}$的气象因子。研究结果强调了通风条件对温室内环境及作物生理参数(如茎流速率SF和气孔导度$g_{s}$)的显著影响。具体而言，与T1条件相比，T2通风条件下的温室表现出更低的温度和相对湿度，但具有更高的风速、SF和$g_{s}$。这些差异凸显了通风对温室内对流过程的影响，其中强制对流在T2条件下起主导作用。这种增强的强制对流降低了阻力参数，从而强调了其在塑造空气动力学阻力及蒸腾速率中的关键作用。此外，研究表明通风条件影响了番茄植株不同生育阶段的耗水模式，其中收获期变化最为显著。在两年试验期间，P-M模型在T1条件下平均低估实际$T_{r}$值$2.15\%$，而在T2条件下平均高估$6.26\%$。这些发现验证了改进的P-M模型作为准确模拟不同通风条件下$T_{r}$的有效工具。通过提供可靠的蒸腾预测，该模型为优化温室农业(特别是具有先进通风配置的系统)的水分管理策略提供了重要依据。

# 作者贡献声明

Yanbin Li: 文稿审阅与编辑。Zihui Yu: 文稿审阅与编辑。Sen Wang: 文稿审阅与编辑，初稿撰写。Yuhao Zhu: 文稿审阅与编辑。Xuewen Gong: 文稿审阅与编辑。Jiankun Ge: 资源支持。

# 利益冲突声明

作者声明不存在任何可能影响本研究的已知经济利益冲突或个人关系。

# 致谢

感谢国家自然科学基金(51709110, 51809094)、河南省科技攻关项目(242102111108)、河南省自然科学基金(242300420035)和河南省高校科技创新人才支持计划(24IRTSTHN012)的资助。

# 数据可用性声明

作者未获得数据共享授权。

## 参考文献

1.  [Anderson et al., 2017](#bbib1)
R.G. Anderson, J.G. Alfieri, R. Tirado-Corbalá, J. Gartung, L.G. McKee, J.H. Prueger, D. Wang, J.E. Ayars, W.P. Kustas
基于涡度协方差通量分割评估FAO-56双作物系数
Agric. Water Manag., 179 (2017), pp. 92-102
2.  [Bailey et al., 1993](#bbib2)
B.J. Bailey, J.I. Montero, C. Biel, D.J. Wilkinson, A. Anton, O. Jolliet
垂叶榕蒸腾作用：实测值与Penman-Monteith模型及其简化版本预测值的比较
Agric. For. Meteorol., 65 (1993), pp. 229-243
3.  [Bhagat et al., 2022](#bbib3)
S.K. Bhagat, T. Tiyasha, Z. Al-khafaji, P. Laux, A.A. Ewees, T.A. Rashid, S. Salih, R. Yonaba, U. Beyaztas, Z.M. Yaseen
建立动态演化神经模糊推理系统模型用于自然气温预测
Complexity, 17 (2022), p. 1047309
4.  [Chen et al., 2001](#bbib4)
J.Z. Chen, M.L. Chen, Y.Q. He
土壤水分状况和环境条件对水稻蒸腾的影响
Chin. J. Appl. Ecol., 12 (1) (2001), pp. 63-67
5.  [Chu, et al., 2004](#bbib5)
J. Chu, L.B. Xu, L.J. Jiang
设施农业发展分析
Trans. Chin. Soc. Agric. Mach., 35 (3) (2004), pp. 191-192
6.  [Ge et al., 2019](#bbib6)
J.K. Ge, Y.F. Liu, X.W. Gong, Z.J. Liu, Y.B. Li, C.D. Xu
温室作物生态生理、耗水量和产量对通风环境调控的响应
J. Inst. Eng. India Ser. A, 100 (2019), pp. 743-752
7.  [Ge et al., 2022](#bbib7)
J.K. Ge, L.F. Zhao, Z.H. Yu, H.H. Liu, L. Zhang, X.W. Gong, H.W. Sun
基于XGBoost机器学习模型的温室番茄作物蒸散量预测
Plants, 15 (2022), p. 1923
8.  [Gong, et al., 2021a](#bbib8)
L.Q. Gong, Q.C. Liu, Y.Y. Ma
气候变化下参考作物蒸散的演变特征及主控因素
J. North China Univ. Water Resour. Electr. Power, 42 (05) (2021), pp. 88-93
9.  [Gong et al., 2017](#bbib9)
X.W. Gong, H. Liu, J.S. Sun, Y. Gao, X.X. Zhang, S.K. Jha, H. Zhang, X.J. Ma, W.N. Wang
用于估算日光温室蒸散量的Penman-Monteith公式表面阻力模型
J. Arid Land, 9 (2017), pp. 530-546
10.  [Gong et al., 2021b](#bbib10)
X.W. Gong, R.J. Qiu, J.K. Ge, G.K. Bo, Y.L. Ping, Q.S. Xin, S.S. Wang
基于改进Priestley-Taylor模型的温室番茄蒸散分配
Agric. Water Manag., 247 (2021), Article 106709
11.  [Gong et al., 2021c](#bbib11)
X.W. Gong, R.J. Qiu, B.Z. Zhang, S.S. Wang, J.K. Ge, S.K. Gao, Z.Q. Yang
中国北方温室番茄植株的能量收支
Agric. Water Manag., 255 (2021), Article 107039
12.  [Hong et al., 2022](#bbib12)
M. Hong, Z.Y. Zhang, Q.P. Fu, Y.P. Liu
塔克拉玛干沙漠西南部覆膜滴灌日光温室番茄需水量
Water, 14 (2022), p. 3050
13.  [Inoue et al., 1984](#bbib13)
K. Inoue, T. Sakuratani, Z. Uchijima
辐射强度和空气湿度对水稻叶片气孔阻力的影响
J. Agric. Meteorol., 40 (1984), pp. 235-242
14.  [Jaafar et al., 2017](#bbib14)
H. Jaafar, Z. Khraizat, I. Bashour, M. Haidar
基于ET的滴灌系统确定圣经海索草的需水量
Agric. Water Manag., 180 (2017), pp. 107-117
15.  [Jesús et al., 2003](#bbib15)
M. Jesús, L.A. Gardiol, A.I. Serio, M. Della
不同种植密度下玉米蒸散量的模拟
J. Hydrol., 271 (2003), pp. 188-196
16.  [Jia et al., 2021](#bbib16)
Q. Jia, H.B. Shi, R.P. Li, Q.F. Miao, Y.Y. Feng, N. Wang, J.W. Li
辽河平原西部覆膜滴灌玉米蒸发的田间评估与模拟
Agric. Water Manag., 253 (2021)
0378-3774
17.  [Jing, 2024](#bbib17)
W.T. Jing
基于CFD的主动蓄热型日光温室通风模拟与优化
Northwest A & F University (2024)
18.  [Kool et al., 2014](#bbib18)
D. Kool, N. Agam, N. Lazarovitch, J.L. Heitman, T.J. Sauer, A. Ben-Jal
蒸散发分割方法综述
Agric. For. Meteorol., 184 (2014), pp. 56-70
19.  [Lei et al., 2023](#bbib19)
W.J. Lei, H.M. Lu, X.Y. Qi, C.M. Tai, X.J. Fan, L.H. Zhang
日光温室环境参数实测与被动通风应用分析
Sol. Energy, 263 (2023), Article 111851
20.  [Li, 2021](#bbib20)
C. Li
川中丘陵区不同Hargreaves改进模型的适应性评价
Water Sav. Irrig., 11 (2021), pp. 88-96
21.  [Li et al., 2022a](#bbib21)
Y.K. Li, W.Z. Guo, J.L. Wu, M.J. Duan, Y. Yang, S.Y. Liu
基于作物系数模型的温室茄子蒸散量估算
Water, 14 (2022), p. 2959
22.  [Li, et al., 2003](#bbib22)
X.H. Li, D.M. Jiang, Y.M. Luo
不同水分处理下樟子松幼苗叶片水分生理生态特性研究
Chin. J. Ecol., 22 (6) (2003), pp. 17-20
23.  [Li et al., 2022b](#bbib23)
Z.H. Li, X.F. Sang, S.Q. Zhang, Y. Zheng, Q.M. Lei
长江流域两种典型蒸发皿折算系数分析与蒸发数据集重建
Atmosphere, 13 (2022), p. 1322
24.  [Liu, et al., 2018](#bbib24)
N.H. Liu, X.P. Jiang, J.F. Chen
国外有机设施园艺现状及其对中国设施农业可持续发展的启示
Trans. Chin. Soc. Agric. Eng., 34 (15) (2018), pp. 1-9
25.  [Lovelli et al., 2008](#bbib25)
S. Lovelli, M. Perniola, M. Arcieri, A.R. Rivelli, T.D. Tommaso
Penman-Monteith"一步法"评估甜瓜水分利用
Agric. Water Manag., 95 (2008), pp. 1153-1160
26.  [Marras et al., 2016](#bbib26)
S. Marras, F. Achenza, R.L. Snyder, P. Duce, D. Spano, C. Sirca
利用能量平衡数据评估地中海葡萄园的蒸散发和作物系数
Irrig. Sci., 34 (2016), pp. 397-408
27.  [Montero et al., 2001](#bbib27)
J.I. Montero, A. Antón, P. Muñoz, P. Lorenzo
高温低湿条件下温室天竺葵的蒸腾作用
Agric. For. Meteorol., 107 (2001), pp. 323-332
28.  [Peng, et al., 2009](#bbib28)
S.Z. Peng, Z.L. Zhang, G.B. Pang
寒地控制灌溉条件下水稻茎秆抗倒伏力学评价与遗传分析
Trans. Chin. Soc. Agric. Eng., 25 (1) (2009), pp. 6-10
29.  [Priestley and Taylor, 1972](#bbib29)
C.H.B. Priestley, R.J. Taylor
利用大尺度参数评估地表热通量和蒸发
Mon. Weather Rev., 100 (1972), pp. 81-92
30.  [Qiu, 2014](#bbib30)
R.J. Qiu
温室环境土壤-植物系统水热动态与模拟
China Agricultural University (2014)
31.  [Qiu et al., 2013](#bbib31)
R.J. Qiu, S.Z. Kang, T.S. Du, L. Tong, X.M. Hao, R.Q. Chen, J.L. Chen, F.S. Li
对流对日光温室辣椒蒸腾Penman-Monteith模型估算的影响
Sci. Hortic., 160 (2013), pp. 163-171
32.  [Shao et al., 2022](#bbib32)
M.X. Shao, H.J. Liu, L. Yang
基于Penman-Monteith、Shuttleworth-Wallace和Priestley-Taylor模型的华北平原下沉式日光温室番茄蒸腾估算
Agron. -Basel, 12 (2022), p. 2382
33.  [Shapira et al., 2024](#bbib33)
O. Shapira, U. Hochberg, A. Joseph, S. McAdam, T. Azoulay-Shemer, C.R. Brodersen, N.M. Holbrook, Y. Zait
风速对气孔导度速率和动力学的影响
Plant J., 120 (2024), pp. 1552-1562
34.  [Shuttleworth, and Wallace, 1985](#bbib34)
W.J. Shuttleworth, J.S. Wallace
稀疏作物蒸发的能量组合理论
Q. J. R. Meteorol. Soc., 111 (469) (1985), pp. 839-855
35.  [Spinelli et al., 2018](#bbib35)
G.M. Spinelli, R.L. Snyder, B.L. Sanden, M. Gilbert, K.A. Shackel
灌溉杏仁园中低且多变的大气耦合表明气孔对果园蒸散的影响有限
Agric. Water Manag., 196 (2018), pp. 57-65
36.  [Su, 2022](#bbib36)
X.L. Su
农业水资源优化配置研究进展
J. Irrig. Drain., 41 (07) (2022)
1-7+ 34
37.  [Thompson, 2023](#bbib37)
R. Thompson
关于土壤分析术语、肥料养分含量和氮利用效率的编辑说明
Agric. Water Manag., 289 (2023), Article 108547
38.  [Tomonori et al., 2015](#bbib38)
K. Tomonori, L. Sophie, K. Hikaru
风速响应下的蒸腾作用：针叶树和阔叶树表观叶型差异能否作为实用指标
Trees, 29 (2) (2015), pp. 605-612
39.  [Wang, and Li, 2010](#bbib39)
X.K. Wang, H. Li
中国温室研究现状与发展趋势
J. Drain. Irrig. Mach. Eng., 28 (02) (2010), pp. 179-184
40.  [Widmoser, 2009](#bbib40)
P. Widmoser
关于Penman-Monteith方程的讨论与替代方案
Agric. Water Manag., 4 (2009), pp. 711-721
41.  [Wu et al., 2022a](#bbib41)
Y. Wu, S.C. Yan, J.L. Fan, F.C. Zhang, W.J. Zhao, J. Zheng, J.J. Guo, Y.Z. Xiang, L.F. Wu
灌溉水平和施肥方式对滴灌温室番茄产量、经济效益和水氮利用效率的综合影响
Agric. Water Manag., 262 (2022), Article 107401
42.  [Wu et al., 2022b](#bbib42)
Z.J. Wu, N.B. Cui, L. Zhao, L. Han, X.T. Hu, H.J. Cai, D.Z. Gong, L.W. Xing, X. Chen, B. Zhu, M. Lv, S.D. Zhu, Q.S. Liu
基于Penman-Monteith模型和分段优化Jarvis模型的华北半湿润区玉米蒸散发估算
J. Hydrol., 607 (2022), p. 127483
43.  [Yan and Li, 2018](#bbib43)
Z.H. Yan, M. Li
基于田间水分循环的农业灌溉水量随机优化模型
Water, 10 (2018), p. 1031
44.  [Yan et al., 2019](#bbib44)
H.F. Yan, B.S. Zhao, C. Zhang, S. Huang, H.W. Fu
Venlo型温室黄瓜植株蒸腾的Penman-Monteith模型模拟
Trans. Agric. Eng., 35 (2019), p. 9
45.  [Yonaba et al., 2021](#bbib45)
R. Yonaba, A.C. Biaou, M. Koïta, F. Tazen, L.A. Mounirou, C.O. Zouré, P. Queloz, H. Karambiri, H. Yacouba
动态土地利用/覆被输入有助于描绘萨赫勒悖论：评估萨赫勒流域地表径流变化的变异性和归因
Sci. Total Environ., 757 (2021), Article 143792
46.  [Zhang et al., 2021](#bbib46)
J.Y. Zhang, J.P. Ding, M. Ibrahim, X.C. Jiao, X.M. Song, P. Bai, J.M. Li
低温下蒸气压亏缺与钾互作对番茄幼苗光合系统的影响
Sci. Hortic., 283 (2021), Article 110089
47.  [Zhang, et al., 2012](#bbib47)
Y.P. Zhang, D.F. Zhu, X.Q. Lin
高温对水稻叶片生长和气孔导度的影响
J. Jiangxi Agric. Univ., 34 (1) (2012), pp. 1-4
48.  [Zhao, and Zeng, 1997](#bbib48)
P. Zhao, X.P. Zeng
华南人工马占相思林湿季灌木蒸腾与微气候的关系
Chin. J. Appl. Ecol., 8 (4) (1997), pp. 365-371
49.  [Zheng et al., 2021](#bbib49)
J. Zheng, J.L. Fan, F.C. Zhang, L.F. Wu, Y.F. Zou, Q.L. Zhuang
基于改进Jarvis-Stewart模型和鲸鱼算法优化混合支持向量机模型的雨养玉米不同覆盖方式下蒸腾估算
Agric. Water Manag., 249 (2021), Article 106799
50.  [Zhou et al., 2008](#bbib50)
M.C. Zhou, H. Ishidaira, K. Takeuchi
湄公河流域不同土地覆盖下潜在蒸散发与截留蒸发的比较研究
Hydrol. Process., 22 (2008), pp. 1290-1309

## References

1.  [Anderson et al., 2017](#bbib1)
R.G. Anderson, J.G. Alfieri, R. Tirado-Corbalá, J. Gartung, L.G. McKee, J.H. Prueger, D. Wang, J.E. Ayars, W.P. Kustas
Assessing FAO-56 dual crop coefficients using eddy covariance flux partitioning
Agric. Water Manag., 179 (2017), pp. 92-102
2.  [Bailey et al., 1993](#bbib2)
B.J. Bailey, J.I. Montero, C. Biel, D.J. Wilkinson, A. Anton, O. Jolliet
Transpiration of Ficus benjamina: comparison of measurements with predictions of the Penman-Monteith model and a simplified version
Agric. For. Meteorol., 65 (1993), pp. 229-243
3.  [Bhagat et al., 2022](#bbib3)
S.K. Bhagat, T. Tiyasha, Z. Al-khafaji, P. Laux, A.A. Ewees, T.A. Rashid, S. Salih, R. Yonaba, U. Beyaztas, Z.M. Yaseen
Establishment of dynamic evolving neural-fuzzy inference system model for natural air temperature prediction
Complexity, 17 (2022), p. 1047309
4.  [Chen et al., 2001](#bbib4)
J.Z. Chen, M.L. Chen, Y.Q. He
Effects of soil water status and environmental conditions on rice transpiration
Chin. J. Appl. Ecol., 12 (1) (2001), pp. 63-67
5.  [Chu, et al., 2004](#bbib5)
J. Chu, L.B. Xu, L.J. Jiang
Analysis on the development of facility agriculture
Trans. Chin. Soc. Agric. Mach., 35 (3) (2004), pp. 191-192
6.  [Ge et al., 2019](#bbib6)
J.K. Ge, Y.F. Liu, X.W. Gong, Z.J. Liu, Y.B. Li, C.D. Xu
Response of greenhouse crop ecophysiology, water consumption and yield to ventilation environment regulation
J. Inst. Eng. India Ser. A, 100 (2019), pp. 743-752
7.  [Ge et al., 2022](#bbib7)
J.K. Ge, L.F. Zhao, Z.H. Yu, H.H. Liu, L. Zhang, X.W. Gong, H.W. Sun
Prediction of greenhouse tomato crop evapotranspiration using XGBoost machine learning model
Plants, 15 (2022), p. 1923
8.  [Gong, et al., 2021a](#bbib8)
L.Q. Gong, Q.C. Liu, Y.Y. Ma
Evolution characteristics and main controlling factors of reference crop evapotranspiration under climate change
J. North China Univ. Water Resour. Electr. Power, 42 (05) (2021), pp. 88-93
9.  [Gong et al., 2017](#bbib9)
X.W. Gong, H. Liu, J.S. Sun, Y. Gao, X.X. Zhang, S.K. Jha, H. Zhang, X.J. Ma, W.N. Wang
A proposed surface resistance model for the Penman-Monteith formula to estimate evapotranspiration in a solar greenhouse
J. Arid Land, 9 (2017), pp. 530-546
10.  [Gong et al., 2021b](#bbib10)
X.W. Gong, R.J. Qiu, J.K. Ge, G.K. Bo, Y.L. Ping, Q.S. Xin, S.S. Wang
Evapotranspiration partitioning of greenhouse grown tomato using a modified Priestley–Taylor model
Agric. Water Manag., 247 (2021), Article 106709
11.  [Gong et al., 2021c](#bbib11)
X.W. Gong, R.J. Qiu, B.Z. Zhang, S.S. Wang, J.K. Ge, S.K. Gao, Z.Q. Yang
Energy budget for tomato plants grown in a greenhouse in northern China
Agric. Water Manag., 255 (2021), Article 107039
12.  [Hong et al., 2022](#bbib12)
M. Hong, Z.Y. Zhang, Q.P. Fu, Y.P. Liu
Water requirement of solar greenhouse tomatoes with drip irrigation under Mulch in the Southwest of the Taklimakan Desert
Water, 14 (2022), p. 3050
13.  [Inoue et al., 1984](#bbib13)
K. Inoue, T. Sakuratani, Z. Uchijima
Stomatal resistance of rice leaves as influenced by radiation intensity and air humidity
J. Agric. Meteorol., 40 (1984), pp. 235-242
14.  [Jaafar et al., 2017](#bbib14)
H. Jaafar, Z. Khraizat, I. Bashour, M. Haidar
Determining water requirements of biblical hyssop using an ET-based drip irrigation system
Agric. Water Manag., 180 (2017), pp. 107-117
15.  [Jesús et al., 2003](#bbib15)
M. Jesús, L.A. Gardiol, A.I. Serio, M. Della
Modelling evapotranspiration of corn (Zea mays) under different plant densities
J. Hydrol., 271 (2003), pp. 188-196
16.  [Jia et al., 2021](#bbib16)
Q. Jia, H.B. Shi, R.P. Li, Q.F. Miao, Y.Y. Feng, N. Wang, J.W. Li
Evaporation of maize crop under mulch film and soil covered drip irrigation: field assessment and modelling on West Liaohe Plain, China
Agric. Water Manag., 253 (2021)
0378-3774
17.  [Jing, 2024](#bbib17)
W.T. Jing
Ventilation Simulation and Optimization of Active Thermal Storage Solar Greenhouse Based on CFD
Northwest A & F University (2024)
18.  [Kool et al., 2014](#bbib18)
D. Kool, N. Agam, N. Lazarovitch, J.L. Heitman, T.J. Sauer, A. Ben-Jal
A review of approaches for evapotranspiration partitioning
Agric. For. Meteorol., 184 (2014), pp. 56-70
19.  [Lei et al., 2023](#bbib19)
W.J. Lei, H.M. Lu, X.Y. Qi, C.M. Tai, X.J. Fan, L.H. Zhang
Field measurement of environmental parameters in solar greenhouses and analysis of the application of passive ventilation
Sol. Energy, 263 (2023), Article 111851
20.  [Li, 2021](#bbib20)
C. Li
Adaptability evaluation of different Hargreaves improved models in hilly region of central Sichuan
Water Sav. Irrig., 11 (2021), pp. 88-96
21.  [Li et al., 2022a](#bbib21)
Y.K. Li, W.Z. Guo, J.L. Wu, M.J. Duan, Y. Yang, S.Y. Liu
Estimation of greenhouse-grown eggplant evapotranspiration based on a crop coefficient model
Water, 14 (2022), p. 2959
22.  [Li, et al., 2003](#bbib22)
X.H. Li, D.M. Jiang, Y.M. Luo
Study on water physiological and ecological characteristics of leaves of Pinus sylvestris seedlings under different water application treatments
Chin. J. Ecol., 22 (6) (2003), pp. 17-20
23.  [Li et al., 2022b](#bbib23)
Z.H. Li, X.F. Sang, S.Q. Zhang, Y. Zheng, Q.M. Lei
Conversion coefficient analysis and evaporation dataset reconstruction for two typical evaporation pan types—a study in the Yangtze River Basin, China
Atmosphere, 13 (2022), p. 1322
24.  [Liu, et al., 2018](#bbib24)
N.H. Liu, X.P. Jiang, J.F. Chen
Current situation of organic facility horticulture in foreign countries and its implications for sustainable development of facility agriculture in China
Trans. Chin. Soc. Agric. Eng., 34 (15) (2018), pp. 1-9
25.  [Lovelli et al., 2008](#bbib25)
S. Lovelli, M. Perniola, M. Arcieri, A.R. Rivelli, T.D. Tommaso
Water use assessment in muskmelon by the Penman–Monteith “one-step” approach
Agric. Water Manag., 95 (2008), pp. 1153-1160
26.  [Marras et al., 2016](#bbib26)
S. Marras, F. Achenza, R.L. Snyder, P. Duce, D. Spano, C. Sirca
Using energy balance data for assessing evapotranspiration and crop coefficients in a Mediterranean vineyard
Irrig. Sci., 34 (2016), pp. 397-408
27.  [Montero et al., 2001](#bbib27)
J.I. Montero, A. Antón, P. Muñoz, P. Lorenzo
Transpiration from geranium grown under high temperatures and low humidities in greenhouses
Agric. For. Meteorol., 107 (2001), pp. 323-332
28.  [Peng, et al., 2009](#bbib28)
S.Z. Peng, Z.L. Zhang, G.B. Pang
Mechanical evaluation and genetic analysis of Lodging resistance of rice stem in cold area under controlled irrigation
Trans. Chin. Soc. Agric. Eng., 25 (1) (2009), pp. 6-10
29.  [Priestley and Taylor, 1972](#bbib29)
C.H.B. Priestley, R.J. Taylor
On the assessment of surface heat flux and evaporation using large-scale parameters
Mon. Weather Rev., 100 (1972), pp. 81-92
30.  [Qiu, 2014](#bbib30)
R.J. Qiu
Hydrothermal dynamics and simulation of soil-plant system in greenhouse environment
China Agricultural University (2014)
31.  [Qiu et al., 2013](#bbib31)
R.J. Qiu, S.Z. Kang, T.S. Du, L. Tong, X.M. Hao, R.Q. Chen, J.L. Chen, F.S. Li
Effect of convection on the Penman–Monteith model estimates of transpiration of hot pepper grown in solar greenhouse
Sci. Hortic., 160 (2013), pp. 163-171
32.  [Shao et al., 2022](#bbib32)
M.X. Shao, H.J. Liu, L. Yang
Estimating Tomato Transpiration Cultivated in a Sunken Solar Greenhouse with the Penman-Monteith, Shuttleworth-Wallace and Priestley-Taylor Models in the North China Plain
Agron. -Basel, 12 (2022), p. 2382
33.  [Shapira et al., 2024](#bbib33)
O. Shapira, U. Hochberg, A. Joseph, S. McAdam, T. Azoulay-Shemer, C.R. Brodersen, N.M. Holbrook, Y. Zait
Wind speed affects the rate and kinetics of stomatal conductance
Plant J., 120 (2024), pp. 1552-1562
34.  [Shuttleworth, and Wallace, 1985](#bbib34)
W.J. Shuttleworth, J.S. Wallace
Evaporation from sparse crops-an energy combination theory
Q. J. R. Meteorol. Soc., 111 (469) (1985), pp. 839-855
35.  [Spinelli et al., 2018](#bbib35)
G.M. Spinelli, R.L. Snyder, B.L. Sanden, M. Gilbert, K.A. Shackel
Low and variable atmospheric coupling in irrigated Almond (Prunus dulcis) canopies indicates a limited influence of stomata on orchard evapotranspiration
Agric. Water Manag., 196 (2018), pp. 57-65
36.  [Su, 2022](#bbib36)
X.L. Su
Research progress on optimal allocation of agricultural water resources
J. Irrig. Drain., 41 (07) (2022)
1-7+ 34
37.  [Thompson, 2023](#bbib37)
R. Thompson
Editorial note on terms for soil analyses, nutrient content of fertilizers and Nitrogen Use Efficiency
Agric. Water Manag., 289 (2023), Article 108547
38.  [Tomonori et al., 2015](#bbib38)
K. Tomonori, L. Sophie, K. Hikaru
Transpiration in response to wind speed: can apparentleaf-type differences between conifer and broadleaf trees be a practical indicator
Trees, 29 (2) (2015), pp. 605-612
39.  [Wang, and Li, 2010](#bbib39)
X.K. Wang, H. Li
Research status and development trend of greenhouse in China
J. Drain. Irrig. Mach. Eng., 28 (02) (2010), pp. 179-184
40.  [Widmoser, 2009](#bbib40)
P. Widmoser
A discussion on and alternative to the Penman–Monteith equation
Agric. Water Manag., 4 (2009), pp. 711-721
41.  [Wu et al., 2022a](#bbib41)
Y. Wu, S.C. Yan, J.L. Fan, F.C. Zhang, W.J. Zhao, J. Zheng, J.J. Guo, Y.Z. Xiang, L.F. Wu
Combined effects of irrigation level and fertilization practice on yield, economic benefit and water-nitrogen use efficiency of drip-irrigated greenhouse tomato
Agric. Water Manag., 262 (2022), Article 107401
42.  [Wu et al., 2022b](#bbib42)
Z.J. Wu, N.B. Cui, L. Zhao, L. Han, X.T. Hu, H.J. Cai, D.Z. Gong, L.W. Xing, X. Chen, B. Zhu, M. Lv, S.D. Zhu, Q.S. Liu
Estimation of maize evapotranspiration in semi-humid regions of northern China using Penman-Monteith model and segmentally optimized Jarvis model
J. Hydrol., 607 (2022), p. 127483
43.  [Yan and Li, 2018](#bbib43)
Z.H. Yan, M. Li
A stochastic optimization model for agricultural irrigation water allocation based on the field water cycle
Water, 10 (2018), p. 1031
44.  [Yan et al., 2019](#bbib44)
H.F. Yan, B.S. Zhao, C. Zhang, S. Huang, H.W. Fu
Penman-Monteith model simulated transpiration of cucumber plants in Venlo greenhouse
Trans. Agric. Eng., 35 (2019), p. 9
45.  [Yonaba et al., 2021](#bbib45)
R. Yonaba, A.C. Biaou, M. Koïta, F. Tazen, L.A. Mounirou, C.O. Zouré, P. Queloz, H. Karambiri, H. Yacouba
A dynamic land use/land cover input helps in picturing the Sahelian paradox: assessing variability and attribution of changes in surface runoff in a Sahelian watershed
Sci. Total Environ., 757 (2021), Article 143792
46.  [Zhang et al., 2021](#bbib46)
J.Y. Zhang, J.P. Ding, M. Ibrahim, X.C. Jiao, X.M. Song, P. Bai, J.M. Li
Effects of the interaction between vapor-pressure deficit and potassium on the photosynthesis system of tomato seedlings under low temperature
Sci. Hortic., 283 (2021), Article 110089
47.  [Zhang, et al., 2012](#bbib47)
Y.P. Zhang, D.F. Zhu, X.Q. Lin
Effects of high temperature on leaf growth and stomatal conductance of rice
J. Jiangxi Agric. Univ., 34 (1) (2012), pp. 1-4
48.  [Zhao, and Zeng, 1997](#bbib48)
P. Zhao, X.P. Zeng
Relationship between shrub transpiration and microclimate during wet season in artificial Acacia manzanensis forest in South China
Chin. J. Appl. Ecol., 8 (4) (1997), pp. 365-371
49.  [Zheng et al., 2021](#bbib49)
J. Zheng, J.L. Fan, F.C. Zhang, L.F. Wu, Y.F. Zou, Q.L. Zhuang
Estimation of rainfed maize transpiration under various mulching methods using modified Jarvis-Stewart model and hybrid support vector machine model with whale optimization algorithm
Agric. Water Manag., 249 (2021), Article 106799
50.  [Zhou et al., 2008](#bbib50)
M.C. Zhou, H. Ishidaira, K. Takeuchi
Comparative study of potential evapotranspiration and interception evaporation by land cover over Mekong basin
Hydrol. Process., 22 (2008), pp. 1290-1309

