# Machine learning applied to retrieval of temperature and concentration distributions from infrared emission measurements

# 机器学习应用于红外辐射测量中的温度和浓度分布反演

Tao Rena,b,\*, Michael F. Modest, Alexander Fateev, Gavin Suttond, Weijie Zhaoa, Florin Rusu

a 工程学院，加州大学默塞德分校，美国加利福尼亚州 b 中英低碳学院，上海交通大学，中国上海 c 化学与生物化学工程系，丹麦技术大学，丹麦灵比市 d 国家物理实验室(NPL)，英国特丁顿

# 亮点

基于机器学习方法开发了辐射反演模型。能够准确反演 $\mathrm{CO_2}$、$\mathrm{H_2O}$ 和 $\mathrm{CO}$ 混合物的标量分布。进行了全面的测试和实验测量。

# 文章信息

关键词: 辐射反演 温度 浓度 机器学习 神经网络

# 摘要

从辐射测量数据反演温度和组分浓度分布需要解决非线性、不适定和高维问题。机器学习方法为解决这类高度非线性问题提供了新途径，能够以良好的灵活性处理复杂动态系统。本研究提出了一种基于机器学习的方法，用于从燃烧系统的红外辐射光谱测量中反演温度和组分浓度。机器学习模型的训练光谱是通过HITEMP 2010数据库对$\mathrm{CO_2}$、$\mathrm{H_2O}$和$\mathrm{CO}$混合气体进行计算合成的。该方法针对不同的视线温度/浓度分布、不同气体路径长度和不同光谱区间进行了测试。实验验证通过使用傅里叶变换红外光谱仪测量Hendken平焰燃烧器的辐射光谱（不同光谱分辨率下）完成。对于当量比$\phi = 1$、$\phi = 0.8$和$\phi = 1.4$的燃烧工况，反演得到的燃烧器上方温度场与瑞利散射测温结果表现出极好的一致性。

| 符号 | 说明 |
|------|------|
| $b$ | 人工神经网络的偏置 |
| $F$ | 代价函数 |
| $I_{\eta}$ | 光谱强度，单位：$\mathrm{Wm}^{-2}(\mathrm{src}\mathrm{cm}^{-1})^{-1}$ |
| $L$ | 气体柱长度，单位：cm |
| $s$ | 沿路径长度，单位：cm |
| $S$ | 激活函数 |
| $T$ | 温度，单位：K |
| $w$ | 人工神经网络的权重 |
| $x_{i}$ | 物种$i$的体积分数浓度，人工神经网络输入 |
| $X$ | 测量的强度数据，单位：$\mathrm{Wm}^{-2}(\mathrm{src}\mathrm{cm}^{-1})^{-1}$ |
| $y$ | 人工神经网络输出 |
| $\beta$ | 生成标量分布的基函数 |
| $\eta$ | 波数，单位：$\mathrm{cm^{-1}}$ |
| $\kappa_{\eta}$ | 吸收系数，单位：$\mathrm{cm^{-1}}$ |
| $\phi$ | 当量比 |

# 缩略词表

| 缩略词 | 全称 |
|--------|------|
| 2-D | 二维 |
| 3-D | 三维 |
| FTIR | 傅里叶变换红外光谱 |
| HAB | 燃烧器上方高度 |
| ILS | 仪器线型函数 |
| LBL | 逐线计算 |
| LIF | 激光诱导荧光 |
| MLP | 多层感知器 |
| NPL | 英国国家物理实验室 |
| ReLU | 修正线性单元 |
| RRMSE | 相对均方根误差 |

# 1. 引言

火焰中气相分子的温度和浓度分布是理解火焰结构和燃烧化学的重要特征。先进的光学诊断和多尺度模拟工具将在开发新一代清洁高效燃烧系统中发挥核心作用。高保真实验诊断对于理解燃烧现象、验证化学动力学模型以及检验先进数值模拟至关重要。尽管燃烧诊断技术已达到高度精细化水平，但在实际燃烧环境中进行温度和组分浓度的定量精确非侵入式测量仍然具有挑战性。理想情况下，这些测量应具备高时空分辨率、高精度和准确度，并且避免测量过程中的任何干扰，因为使用侵入式技术（如热电偶测温和气相色谱测浓度）必然会改变流场和传热场。过去几十年间，多种基于光学的燃烧诊断技术被开发并成为燃烧诊断的首选方法。例如：双色高温计用于温度测量[1,2]；瑞利和拉曼散射作为实验室火焰的强大诊断工具[3,4]；激光诱导荧光(LIF)用于测定特定气体组分的浓度和/或温度[5-7]；激光吸收光谱(LAS)用于测定气体和烟灰体积分数[8,9]等。在众多燃烧诊断工具中，红外发射和透射光谱技术尤为突出，原因在于：(1)燃烧组分在红外区域具有强烈的转动和振动跃迁；(2)不同组分具有可分离的特定跃迁带；(3)发射和透射测量简便[10,11]。通过视线发射或透射光谱可以记录火焰或燃烧室的光谱，并沿视线反演温度和组分浓度。结合适当的层析成像技术，可以重建整个燃烧场[12,13]。

然而，从红外发射和透射光谱测量中推断燃烧场的温度和组分浓度是具有挑战性的任务，需要解决非线性、不适定且可能高维的反问题。传统上通常采用基于梯度的非线性回归方法[14]来解决辐射反演问题。Griffith等人[15,16]最早认识到通过测量气体旋转谱线的透射率或发射率可以揭示其温度。为了提取温度，他们采用非线性最小二乘法拟合积分透射率极小值。Best等人[17,18]结合层析成像和傅里叶变换红外(FTIR)光谱仪的透射与发射光谱，提取了温度、浓度和烟灰体积分数场。通过测量$\mathrm{CO_2}$ $4.3\mu \mathrm{m}$波段的谱强度，研究者以多种方式反演了温度剖面[19,20]。但由于缺乏精确的辐射预测模型和稳健的反演算法，当时这些结果的精度有限。Song等人[21,22]开发了基于辐射强度测量的$\mathrm{CO_2}$温度剖面重建技术，采用精确的窄带辐射模型并测试了多种牛顿型回归方法。由于问题的非线性和不适定性，需要对反问题进行正则化以强制解具有一定平滑性。但正则化参数的选择往往困难，通常采用经验值。Ren和Modest[23]应用带Tikhonov正则化的Levenberg-Marquardt优化方法，从合成的视线光谱强度数据重建$\mathrm{CO_2}$温度剖面和平均浓度。针对不同气体路径长度和$\mathrm{CO_2}$光谱波段测试了两种温度剖面，提出结合L曲线准则和差异原理的新正则化选择方法，在不同温度剖面反演中表现出良好通用性。但反演温度的精度高度依赖于初始猜测和"测量"噪声水平。

上述光学诊断均针对单视线测量。研究者尝试放宽这一限制，聚焦于轴对称火焰[24,25]，在均匀间隔的平行视线收集光学数据，这些数据与未知的径向分布相关。燃烧文献中最常用的轴对称火焰反卷积方法是Abel三点反演[26]，该方法通过在轴向平滑数据但不直接处理Abel方程固有的不适定性，限制了解的精度和稳定性。Liu等人[27]报道了采用Tikhonov正则化和假设共流火焰轴对称的高分辨率吸收光谱，对层流共流烟灰火焰进行温度和$\mathrm{CO_2}$浓度剖面的二维测量。通过多线测量重建了二维温度和组分浓度场。非轴对称火焰的视线数据反卷积需要更复杂的层析算法，如基于傅里叶变换或代数重建的方法[28]。最近，高光谱成像设备[29]被应用于燃烧诊断[30,31]。高光谱成像是一项前景广阔的技术，其包含二维像素阵列，每个像素沿多条视线在大量连续波数处测量辐射，提供空间和光谱分辨的辐射图像。但由于缺乏先进的三维层析算法，这些研究[12,30]仅重建了具有路径平均标量场的二维燃烧场。广泛使用的三维测量(重建)方法是计算机断层扫描(CT)[28]，通过低维传感器同时从不同角度和方向测量目标，利用反演算法重建高维流场[32]。这种CT方法需要多个探测器安装在不同角度和位置。新开发的光场相机技术[33]是实现三维火焰测量的另一种方式，通过在传感器前添加微透镜阵列，可同时捕获发射光的强度和方向。与CT相比，光场相机方法降低了测量系统复杂度并消除了多探测器的使用，但仍需重建算法获取三维温度和浓度场。

机器学习方法是一种有前景的新解决方案。机器学习是计算机科学的一个领域，使计算机系统能够发现输入与输出之间的关系，即使这些关系无法用显式算法表示[34]。机器学习算法使计算机能够从经验中学习，而无需实际建模支配系统的物理和化学定律[35]。机器学习主要通过计算和统计方法自动从数据中提取信息，当因变量与自变量关系不明确时，可为非线性反问题提供全局解模型[35]。凭借其预测能力，机器学习已在能源系统中得到广泛应用，如热负荷预测[36]、建筑能耗估算[37]、太阳辐射预报[38]、电力需求预测[39]以及燃煤锅炉燃烧系统优化[40]等。最早尝试应用机器学习技术从热辐射中反演温度和组分浓度的研究出现在气象学(大气辐射)领域[41-48]。Hadji-Lazaro等人[41]应用人工神经网络技术(机器学习算法的一类)从CO $4.7\mu \mathrm{m}$波段的高分辨率天底辐射反演大气CO总柱量。Aires等人[42]开发了基于人工神经网络的快速大气和表面温度反演算法，用于高分辨率红外大气探测干涉仪。这些研究发现，机器学习是处理大气连续观测产生海量数据的准确高效方法。在燃烧诊断方面，García-Cuesta等人[44-46]尝试用人工神经网络方法从$\mathrm{CO_2}$和$\mathrm{H_2O}$的红外光谱反演高温气体温度剖面。模拟采用非常粗糙的空间分辨率(5个均匀气体单元)、平滑温度剖面和小温差(60K)[45]。结果表明，与传统基于梯度优化的方法相比，机器学习方法具有速度更快、对初始条件不敏感和适应性强等优势。但其研究存在不足：未模拟光谱中的实验噪声，且$\mathrm{CO_2}$和$\mathrm{H_2O}$的浓度剖面在整个训练数据集中保持不变。基于主成分分析[47]从逐线(LBL)光谱降低数据维度，并选取较少光谱数据用于研究[45]。在后续研究[46]中，从$2110-2410\mathrm{cm}^{-1}$光谱区间选择17个波数子集，用于反演微型喷气发动机排气羽流的温度。机器学习反演的温度剖面与热电偶测量结果差异高达$20\%$。Cieszczyk[48]从2350至$2400\mathrm{cm}^{-1}$的高分辨率$\mathrm{CO_2}$模拟光谱反演温度剖面，该方法基于几条谱线强度比与温度的依赖关系。考虑的最高温度仅$800\mathrm{K}$且未考虑光谱中的"实验"噪声。由于实际燃烧温度可能远高于$800\mathrm{K}$且谱线强度受理论不确定性和实验噪声影响，该方法应用于实际燃烧测量时可能存在问题。

人工神经网络表达复杂数据的能力及其广泛应用促使我们重新审视其在解决辐射反问题中的应用。对于使用人工神经网络的机器学习，需要常规获取大量训练数据[49,50]，这些数据可来自实验测量、数值模拟或两者结合。对于红外光谱燃烧诊断，通过实验收集大量训练数据较为困难。然而，现有多个气体属性数据库(如HITRAN[51,52]、HITEMP[53]和CDSD[54,55])可用于精确光谱预测，生成人工神经网络的训练数据。这些数据库包含多种气体组分的LBL信息。HITEMP 2010[53]仅包含5种组分($\mathrm{CO_2}$、$\mathrm{H_2O}$、CO、NO和OH)，但包含高温下活跃的"热线"数据。该数据库已针对相关燃烧条件下$\mathrm{CO_2}$[56-58]、$\mathrm{H_2O}$[59,60]和CO[61]的中高分辨率FTIR测量光谱进行广泛验证，可用于本项研究。

本研究基于多层感知器(MLP)神经网络方法[62,63]开发了一种逆向辐射模型，用于从燃烧气体的红外发射测量中反演温度和组分浓度。首先提出了前向计算模型，该模型用于从HITEMP 2010数据库生成人工神经网络模型的训练光谱。随后使用合成的辐射发射"测量"数据(添加了人工实验噪声)对不同温度和组分浓度分布(基于典型实验室火焰)的人工神经网络逆向辐射模型进行测试。测试案例的温度范围为300K至3000K，针对非均匀的CO₂、H₂O和CO混合气体。通过使用FTIR光谱仪测量实验室层流火焰的热辐射光谱来反演温度和组分浓度，进行了实验验证。结果表明，人工神经网络逆向辐射模型为从红外发射测量中准确反演气体温度和浓度提供了有力工具。虽然当前工作处理的是单视线光谱测量，但所提出的神经网络逆向辐射模型可以轻松适配到使用先进光谱测量设备(如红外高光谱傅里叶变换红外光谱仪)的3D火焰诊断。

# 2. 前向辐射计算

![](images/d1af58481608508fa59f09dd7aa0547796143f043d0aa7f9cd0003d123781c60.jpg)  
图1. 燃烧系统辐射发射光谱测量示意图。外部辐射I₀η在s=0处进入气体柱0≤s≤L，与燃烧气体相互作用后产生沿视线的光谱强度，在s=L处的探测器可观测到I(η)。

在本研究中，前向辐射计算模型模拟了在已知压力、温度、组分浓度和气体路径长度的情况下，如何测量燃烧产物沿视线的光谱强度。图1展示了一个非等温燃烧气体柱。假设系统处于局部热平衡状态，且可以忽略介质中的散射效应。探测器在s=L处观测到的介质内沿视线的光谱强度由下式给出[64]：

$$
I(\eta) = I_{0\eta}e^{-\int_0^L\kappa_{\eta}ds} + \int_0^L\kappa_{\eta}I_{b\eta}e^{-\int_s^L\kappa_{\eta}ds'}ds \tag{1}
$$

其中κη是在光谱位置η处评估的光谱吸收系数。假设沿气体柱压力恒定，κη的值取决于气体温度和组分浓度。Ibη是介质的局部黑体强度，I₀η是在s=0处进入气体柱0≤s≤L的外部辐射。本研究中假设没有外部辐射，仅考虑气体介质的发射。计算时将整个气体柱划分为n个均匀的子柱，每个子柱内的温度和组分浓度假设为常数。为数值精确计算式(1)给出的强度，气体柱出射的辐射强度递归计算为：

$$
I_{i}(\eta) = I_{i - 1}(\eta)e^{-\Delta si\kappa_{\eta}i} + I_{b i}(1 - e^{-\Delta si\kappa_{\eta}i}) \tag{2}
$$

其中Ii(η)是第i个子柱出射的光谱强度，κηi是第i个子柱对应温度和气体浓度的吸收系数。因此，探测器观测到的发射光谱是最后一个子柱的出射辐射：

$$
I(\eta) = I_{n}(\eta) \tag{3}
$$

燃烧产物通常是多种气体的混合物。本研究考虑包含三种主要燃烧产物(CO₂、H₂O和CO)的混合气体。这三种组分的吸收系数从HITEMP 2010 LBL光谱数据库计算获得。式(1)计算的光谱强度包含每个单独跃迁线的信息。然而，从HITEMP 2010获得的LBL数据基于量子力学计算和实验测量，存在一定程度的理论不确定性(线强度、形状和宽度)，而强度测量极易受实验噪声影响，同时需要更长的计算/采集时间。为模拟光谱仪不同的有限光谱分辨率，将式(3)的LBL光谱强度与理想仪器线型(ILS)函数进行卷积。这里使用三角切趾创建理想ILS Γ(η)：

$$
\Gamma (\eta) = \frac{0.5}{Res}\mathrm{sinc}^2\left(\frac{0.5\pi}{Res}\eta\right) \tag{4}
$$

其中Res是ILS函数的标称分辨率。将强度光谱与ILF Γ(η)卷积后得到：

$$
I_{c}(\eta) = \int_{0}^{\infty}I(\eta^{\prime})\Gamma (\eta -\eta^{\prime})d\eta^{\prime} \tag{5}
$$

如果以特定光谱分辨率测量强度，获得m个离散波数值，则形成非线性方程组：

$$
\mathbf{I} = f(\mathbf{T},\mathbf{x}_{\mathrm{CO}_2},\mathbf{x}_{\mathrm{H}_2\mathrm{O}},\mathbf{x}_{\mathrm{CO}}) \tag{6}
$$

其中f是所有子柱温度和浓度的非线性函数。式(6)显示了计算的中低分辨率光谱强度与沿视线的温度和浓度分布之间的关系，其中：

$$
\begin{array}{r l} & {\mathbf{I} = [I_{k}];\qquad k = 1,\dots,n}\\ & {\mathbf{T} = [T_{l}],\mathbf{x}_{\mathrm{CO}_{2}} = [x_{1,i}],\mathbf{x}_{\mathrm{H}_{2}\mathrm{O}} = [x_{2,i}],\mathbf{x}_{\mathrm{CO}} = [x_{3,i}];\qquad i = 1,\dots,n} \end{array} \tag{1}
$$

m是光谱强度的光谱维度，n是沿气体混合柱的温度和组分浓度的空间维度。

作为前向计算示例，图2比较了LBL强度谱与不同光谱分辨率的强度谱。相同条件下的黑体辐射也作为参考给出。LBL光谱展示了每个跃迁线的精确线形，但需要大量数据点来解析精细结构。卷积到中低分辨率光谱后，获得了更平滑的平均发射光谱形状，数据点更少，如图2所示的分辨率为1cm⁻¹、4cm⁻¹和32cm⁻¹的卷积光谱。

三种燃烧气体的光谱主要包含"光谱窗口"，因为只存在少数转动振动带。为了从光谱测量中高效准确地反演温度和组分浓度，选择合适的谱带进行计算非常重要。图2所示光谱中，1800-2500cm⁻¹和3000-4200cm⁻¹两个光谱区间在整个光谱范围内表现出相对较强的发射，且这两个区间在大多数红外仪器的测量能力范围内。1800-2500cm⁻¹区间包含CO₂ 4.3μm带、CO 4.7μm带和部分H₂O 0.3μm带；而3000-4200cm⁻¹区间包含CO₂ 2.7μm带、H₂O 2.7μm带和部分CO 2.35μm带。所有三种组分在这两个光谱区间都有重叠的谱线。因此，选择这些谱段可以同时反演所有标量。本研究选择这两个光谱区间来反演温度和组分浓度。

图3展示了在$1800 - 2500\mathrm{cm}^{-1}$和$3000 - 4200\mathrm{cm}^{-1}$光谱区间计算的辐射强度情况。计算针对一个$10\mathrm{cm}$长的非均匀温度气体柱(如图所示)进行，气体浓度为均匀的$10\% \mathrm{CO_2} + 10\% \mathrm{H_2O} + 10\% \mathrm{CO}$与$\mathrm{N}_2$的混合气体。光谱具有$8\mathrm{cm}^{-1}$的中等光谱分辨率。$10\mathrm{cm}$气体柱被划分为不同数量的均匀子柱。如图所示，21个子柱足以实现两个光谱区间的空间网格独立性，本研究采用此划分方式。

![](images/72135dbb016e90299a2895da030d0a654ac58f47dae74ee1a3cfd9fb9d48bcfa.jpg)  
图2. 计算得到的$10\mathrm{cm}$长均匀混合气体柱的LBL辐射强度($T = 1500\mathrm{K}$, $x_{\mathrm{CO_2}} = x_{\mathrm{H_2O}} = x_{\mathrm{CO}} = 0.1$)，与黑体辐射以及标称分辨率分别为$1\mathrm{cm}^{-1}$、$4\mathrm{cm}^{-1}$和$32\mathrm{cm}^{-1}$的卷积光谱进行对比。

![](images/ff3e1bb5c7bf9996fe24e6753c86657df9190563564c45924f443576c742f11f.jpg)  
图3. 计算得到的中等分辨率$(8\mathrm{cm}^{-1})$辐射强度，针对$1800 - 2500\mathrm{cm}^{-1}$和$3000 - 4200\mathrm{cm}^{-1}$光谱区间，$10\mathrm{cm}$长混合气体柱采用不同数量子柱划分的情况。

# 3. 用于逆向辐射计算的机器学习

基于辐射测量的光学诊断技术可以重建吸收和发射燃烧气体内部的温度、组分浓度等参数的空间分布。这种基于辐射测量的反演技术被称为逆向辐射传热计算[64]。从方程(6)反演温度和组分浓度需要求解非线性、不适定问题。传统上，逆向问题的解通常通过优化方法获得，即通过适当"猜测"温度和组分浓度来最小化代价函数，直到测量光谱与预测光谱达到最佳匹配。假设$Y_{i}$为测量的光谱强度，$L$为正向计算预测的光谱强度，需要最小化的代价函数为：

$$
F(\mathbf{Z}) = \sum_{k = 1}^{m}(I_k - Y_k)^2 \tag{8}
$$

这里我们将所有气体子柱的温度和组分浓度放入参数向量$\mathbf{Z}$中，即：

$$
\mathbf{Z} = [\mathbf{T},\mathbf{x}_{\mathrm{CO}_2},\mathbf{x}_{\mathrm{H}_2\mathrm{O}},\mathbf{x}_{\mathrm{CO}}] \tag{9}
$$

传统的基于梯度[14]的优化方法通过迭代逐步最小化方程(8)。问题的不适定性可能导致收敛缓慢，且解可能依赖于参数向量$\mathbf{Z}$的初始猜测。每次迭代都需要进行正向计算以提供预测的光谱数据集$[I_k]$。此外，对于不同的测量光谱数据集$[Y_k]$，优化过程必须从头开始。这使得传统的基于梯度的方法在应用于高维断层扫描问题时效率非常低下。

另一方面，当气体光谱辐射与其温度和浓度之间缺乏明确的逆向关系时，机器学习方法可为非线性逆问题提供全局解决方案模型。受生物神经网络信息处理机制启发，人工神经网络是一组通过人工神经元模拟数据处理的机器学习算法[65]。通过在数据集上进行训练，并给定输入输出对，可以生成能够根据同类输入特征预测新样本的模型。多层感知器(MLP)神经网络是机器学习中最常用的人工神经网络类型[66,67]。MLP由输入层、一个或多个隐藏层和输出层组成，每层包含若干称为神经元的节点。各层神经元通过权重与下一层直接连接。假设网络有n个输入$\{x_{i}|x_{1},\ldots ,x_{n}\}$，单个神经元的输出$y$是其输入的加权和经激活函数$S$变换后的结果，可表示为[68]：

$$
y = S\left(\sum_{i = 1}^{n}w_{i}x_{i} + b\right) \tag{9}
$$

其中$\{w_{i}|w_{1},\ldots ,w_{n}\}$为权重，$b$为偏置。该过程可通过图4的人工神经网络示意图理解。非线性激活函数通常选择S形函数（如sigmoid或双曲正切函数）。近年深度神经网络多采用修正线性单元(ReLU)[69]，当输入小于0时输出0，否则输出原始值，即$S(x) = \max (0,x)$。本研究采用ReLU激活函数开发用于温度和组分浓度反演的深度神经网络。

![](images/2b640ffbc005f907f8b6bdd904a7366c5dfc8bbab585c1f9c2465aa4f7ae4593.jpg)  
图4. 单个神经元内部数据处理示意图[70]。假设网络有n个输入$\{x_{i}|x_{1},\dots,x_{n}\}$，神经元的输出$y$是输入加权和经激活函数变换的结果，其中$\{w_{i}|w_{1},\dots,w_{n}\}$为权重，$b$为偏置。

图5展示了用于红外光谱发射测量反演温度和组分浓度的典型MLP神经网络架构。最左侧的输入层由代表输入特征（红外光谱强度）的神经元组成。隐藏层中的每个神经元通过加权线性求和与非线性激活函数对前一层值进行变换。输出层接收最后一个隐藏层的值并将其转换为输出值（温度/浓度）。输入层和输出层的神经元数量分别由输入和输出维度决定。对于不同问题，确定隐藏层数量及其神经元数没有特定方法，通常通过试错法选择[34]。

神经网络建模的重要环节是所谓的网络训练（学习）。通过调整神经元间的权重来最小化代价函数误差，使网络输出值与实际对应值相匹配。学习是迭代过程，需要使用大量覆盖系统全范围的样本，以获得足够低的代价函数误差。训练后，模型可直接通过新输入预测输出。本研究基于scikit-learn Python库[71]实现模型，采用Kingma和Ba提出的基于随机梯度的优化器进行MLP训练[72]。训练输入的光谱发射强度通过HITEMP 2010数据库的正向计算模型合成，针对$\mathrm{CO_2}$、$\mathrm{H_2O}$和$\mathrm{CO}$与惰性气体$\mathrm{N_2}$的混合气体，涵盖多种温度和组分浓度分布。

# 4. 结果与讨论

本节首先从合成光谱发射强度反演不同气体路径长度和光谱区间的温度与组分浓度分布，随后通过实验测量的Hencken平焰燃烧器在不同当量比燃烧下的发射光谱反演温度和气体浓度。

# 4.1. 基于合成发射测量的温度与浓度分布反演

本节测试了三种对称的温度和组分浓度分布曲线。类型1在中部较平坦而边缘梯度较大；类型2具有单峰；类型3具有双峰一谷。从HITEMP 2010数据库生成$1800 - 2500\mathrm{cm}^{-1}$和$3000 - 4200\mathrm{cm}^{-1}$光谱区间、分辨率$8\mathrm{cm}^{-1}$的10000组合成强度光谱（基于式(5)），每种分布类型各对应10000组。所有强度光谱添加3%高斯随机噪声以模拟实验不可避免的随机误差。每组分布的10000个数据集分为两类：9900组用于训练MLP神经网络，剩余100组用于测试训练后网络对未见光谱"测量"数据的预测能力。用于生成光谱的温度和浓度分布通过式(11)-(14)计算，其中基函数$\beta (s)$如图6所示。

$$
\begin{array}{rl} & T(s) = \Delta T\times \beta (s) + T_0;T_0 = (2700\times Rn_1 + 300)\mathrm{K},\\ & \Delta T = (3000 - T_0)\times Rn_2\mathrm{K} \end{array} \tag{11}
$$

![](images/2e71ecb278df5e6f9c3be99175e91ad7450952ebaacd57933056fe4038e93c87.jpg)  
图5. 用于燃烧气体红外光谱发射测量反演温度和组分浓度的典型MLP神经网络架构示意图

![](images/e77d0a06deb25884cc3df0e18f947e6329c5ea455d35e5f4c6cd57c27422886c.jpg)  
图6. 用于生成不同类型温度和组分浓度分布的$\beta$函数

$$
\begin{array}{rl} & {x_{\mathrm{CO_2}}(s) = \Delta x_1\times \beta (s) + x_{1,0};x_{1,0} = 0.05,\Delta x_1 = 0.10\times Rn_3}\\ & {x_{\mathrm{H_2O}}(s) = \Delta x_2\times \beta (s) + x_{2,0};x_{2,0} = 0.05,\Delta x_2 = 0.10\times Rn_4}\\ & {x_{\mathrm{CO}}(s) = \Delta x_3\times \beta (s) + x_{3,0};x_{3,0} = 0.01,\Delta x_3 = 0.05\times Rn_5} \end{array} \tag{12}
$$

式(11)-(14)中，$Rn_{1} - Rn_{5}$为0到1均匀分布的随机数；$T_{0}, x_{1,0}, x_{2,0}, x_{3,0}$分别为温度和浓度的最低值；$\Delta T, \Delta x_{1}, \Delta x_{2}, \Delta x_{3}$为温度与浓度分布中最大值与最小值的差值。通过这些公式可随机生成$300 \mathrm{~K}$至$3000 \mathrm{~K}$的温度分布、$5\%$至$15\%$的$\mathrm{CO}_{2}$浓度分布、$5\%$至$15\%$的$\mathrm{H}_{2} \mathrm{O}$浓度分布，以及$1\%$至$6\%$的$\mathrm{CO}$浓度分布。为展示模型对不同光学厚度的适应性，生成了$10 \mathrm{~cm}$、$1 \mathrm{~m}$和$10 \mathrm{~m}$三种气体柱的发射光谱。生成光谱数据时忽略了温度与气体浓度间的物理相关性，这使得逆问题求解更具挑战性，但本研究实现了温度与组分浓度的同步反演。

生成合成强度光谱后，这些光谱数据及对应的温度和浓度被用作输入输出训练MLP神经网络。对于MLP神经网络，隐藏层数量、隐藏层神经元数和正则化参数等最优参数因问题而异，通过试错法选择[34]。针对每种分布类型、不同光谱区间和不同气体路径长度分别训练了MLP神经网络。当模型完成"训练"且其泛化能力得到验证后，即可用于根据新的辐射强度光谱"测量"预测温度和浓度。使用预留的100组合成发射光谱测试训练模型的性能，将这些光谱输入训练模型预测温度浓度（预测值），并与生成光谱所用的已知温度组分浓度分布（观测值）进行对比。采用相对均方根误差(RRMSE)定性评估训练模型性能：

$$
RRMSE = 100\times \frac{\sqrt{\frac{1}{N}\sum_{1}^{N}(P_{i} - O_{i})^{2}}}{\frac{1}{N}\sum_{1}^{N}(O_{i})} \tag{15}
$$

式中$P_{i}$和$O_{i}$分别为预测值和观测值。本研究同步反演温度和组分浓度，但由于温度和不同组分浓度对光谱响应特性不同，需分别评估其RRMSE。

表1展示了不同情况下100组测试样本反演温度浓度的平均RRMSE。如前所述，测试针对三种气体路径长度和两个光谱区间进行。预测I和II分别对应$1800-2500\mathrm{~cm}^{-1}$和$3000-4200\mathrm{~cm}^{-1}$光谱区间结果。如表所示，$1800-2500\mathrm{~cm}^{-1}$区间对所有气体路径长度和各类型温度浓度分布都能较准确反演温度剖面。当气体路径长度从$10\mathrm{~cm}$增至$100\mathrm{~cm}$时，$3000-4200\mathrm{~cm}^{-1}$区间表现更优。两种光谱区间下，$\mathrm{CO}_{2}$浓度反演精度均随路径长度从$100\mathrm{~cm}$增至$1000\mathrm{~cm}$而降低，这与我们先前采用Levenberg-Marquardt优化方法反演温度剖面的研究结论一致[23]。理想的反演光谱区间应满足：气体柱每个区段的辐射贡献在光谱上可区分。较短路径和较小吸收系数导致光薄路径，此时探测强度与局部发射近似线性相关，难以区分不同位置。当光学厚度增加时，气体柱内吸收增强使不同位置发射的光谱特征产生差异。在$1800-2500\mathrm{cm}^{-1}$区间，三种组分吸收带强烈重叠；而在$3000-4200\mathrm{cm}^{-1}$区间其吸收带相对较弱且重叠较少。这解释了为何$1800-2500\mathrm{cm}^{-1}$区间在$10\mathrm{cm}$和$100\mathrm{cm}$路径表现良好，而$3000-4200\mathrm{cm}^{-1}$区间在路径增至$100\mathrm{cm}$时更优。对于$1000\mathrm{cm}$长路径，高$\mathrm{CO_2}$浓度下其$4.3\mu \mathrm{m}$和$2.7\mu \mathrm{m}$强辐射带可能饱和接近黑体辐射，掩盖部分光谱信息导致$\mathrm{CO_2}$浓度反演精度下降。$3000-4200\mathrm{cm}^{-1}$区间内的$\mathrm{CO}2.35\mu \mathrm{m}$是弱吸收带，受$\mathrm{CO_2}$和$\mathrm{H_2O}$主导，因此如表1所示，该区间反演CO浓度误差较大。而包含CO$4.7\mu \mathrm{m}$强吸收带的$1800-2500\mathrm{cm}^{-1}$区间可获得较准确CO浓度。值得注意的是，MLP神经网络训练后获得的是"全局"逆辐射模型，能高效处理具有相似特征的新数据。对于每组100个测试样本，同步反演所有温度浓度仅需不到1秒CPU时间，即单视线反演仅需约$10\mathrm{ms}$。

表1 100组测试样本的平均相对均方根误差(RRMSE)

| 气体路径长度 | 分布类型 | 预测I(1800-2500 cm⁻¹) | | | | 预测II(3000-4200 cm⁻¹) | | | |
|--------------|----------|----------------|---------|---------|---------|----------------|---------|---------|---------|
|              |          | 温度(T) | CO₂(xCO₂) | H₂O(xH₂O) | CO(xCO) | 温度(T) | CO₂(xCO₂) | H₂O(xH₂O) | CO(xCO) |
| 10 cm        | 类型1    | 4.11%   | 2.72%     | 2.87%    | 4.60%   | 8.14%   | 5.00%    | 4.33%    | 16.0%   |
|              | 类型2    | 2.44%   | 3.19%     | 1.82%    | 4.18%   | 3.63%   | 3.43%    | 3.64%    | 21.0%   |
|              | 类型3    | 2.97%   | 3.77%     | 3.42%    | 6.48%   | 5.55%   | 5.44%    | 4.92%    | 21.6%   |
| 100 cm       | 类型1    | 1.43%   | 2.90%     | 2.04%    | 3.51%   | 4.59%   | 4.24%    | 3.80%    | 11.4%   |
|              | 类型2    | 1.55%   | 4.28%     | 2.07%    | 4.63%   | 3.70%   | 4.36%    | 3.55%    | 23.7%   |
|              | 类型3    | 1.73%   | 3.50%     | 2.33%    | 4.17%   | 4.64%   | 4.72%    | 3.83%    | 12.2%   |
| 1000 cm      | 类型1    | 2.13%   | 4.98%     | 2.48%    | 11.6%   | 2.14%   | 9.51%    | 3.55%    | 18.7%   |
|              | 类型2    | 1.28%   | 5.89%     | 3.00%    | 11.2%   | 2.81%   | 6.38%    | 4.04%    | 12.5%   |
|              | 类型3    | 2.10%   | 4.78%     | 2.70%    | 10.3%   | 2.28%   | 6.81%    | 3.55%    | 11.7%   |

![](images/01ffec8c093b78f161e9c7f94d02d62abb2f332733c29695a17f90f193c27119.jpg)  
图7. 三种分布类型在$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)和$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)、分辨率$8\mathrm{cm}^{-1}$、气体路径长度$10\mathrm{cm}$条件下的预测温度与组分浓度分布。

图7-9分别展示了$10\mathrm{cm}$、$100\mathrm{cm}$和$1000\mathrm{cm}$气体柱三种分布类型的温度与组分浓度反演结果示例。各图中均标明了反演温度与浓度的相对均方根误差(RRMSE)。考虑到光谱中存在$3\%$的随机噪声，使用$1800-2500\mathrm{cm}^{-1}$光谱区间时，所有分布类型和各组分的反演结果均与真实分布吻合良好。$3000-4200\mathrm{cm}^{-1}$光谱区间的反演精度较低，特别是CO浓度的反演结果。总体而言，对于所有三种温度分布类型和不同气体路径长度，两个光谱区间都能较准确地反演温度分布。$\mathrm{CO_2}$和$\mathrm{H}_2\mathrm{O}$浓度的反演精度取决于不同热力学条件和光谱区间，但所有测试案例的RRMSE均小于$10\%$。当使用$1800-2500\mathrm{cm}^{-1}$光谱区间时，CO浓度仅在较小气体路径长度下能获得相对准确的反演结果。这些基于人工合成数据的测试表明，MLP神经网络机器学习方法能够以可接受的精度同时从红外发射测量中反演温度、$\mathrm{CO_2}$、$\mathrm{H_2O}$和$\mathrm{CO}$浓度。

![](images/5b1f274cd8c5ab7df12ffcf7078fb4b78b1b9b722bc15d3e886b32c129bf8cd8.jpg)  
图8. 三种分布类型在$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)和$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)、分辨率$8\mathrm{cm}^{-1}$、气体路径长度$100\mathrm{cm}$条件下的预测温度与组分浓度分布。

![](images/cc07e900aafc099c943eccb12ea4b95d8076f1bf63f9304f42b983a6593d57de.jpg)  
图9. 三种分布类型在$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)和$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)、分辨率$8\mathrm{cm}^{-1}$、气体路径长度$1000\mathrm{cm}$条件下的预测温度与组分浓度分布

# 4.2. NPL标准火焰的温度与浓度分布反演

为实验验证模型，我们测量了NPL标准火焰[73,74]的光谱辐射强度，并利用测量光谱反演火焰温度与组分浓度。该火焰系统基于Hencken平焰燃烧器，使用干燥实验室空气和工业级(标称纯度95%)丙烷在开放大气条件下燃烧。NPL标准火焰经过充分表征，可提供具有已知温度和组分的高温气体可重复区域[75,73]，是验证光学测温技术的理想选择。

# 4.2.1. 实验测量

使用FTIR光谱仪对NPL标准火焰进行红外发射测量。实验装置如图10所示。火焰由$40\mathrm{mm}\times 40\mathrm{mm}$方形燃烧器产生。所有光学部件(从A1到A4及FTIR本身)在测量过程中均用$\mathrm{N}_2$(99.999%)吹扫。吹扫流量经过调节以避免对火焰边缘产生冷却效应。沿火焰高度设置的银反射屏用于减少火焰辐射对FTIR热稳定性的影响。FTIR光谱仪(Agilent 660型)配备液氮冷却窄带高灵敏度线性化汞镉碲(MCT)探测器和KBr分束器，可在$650-8000\mathrm{cm}^{-1}$光谱范围内进行测量，最高标称光谱分辨率为$0.09\mathrm{cm}^{-1}$。该光谱仪升级了额外的双A/D卡，可实现中低分辨率的快速采集测量，从而消除火焰闪烁对测量光谱的影响。测量过程中获取原始干涉图。由于光谱仪动镜移动范围有限，原始干涉图不能无限延伸，实际上相当于干涉图乘以了一个切趾函数。因此，强度光谱是通过对干涉图进行傅里叶变换并乘以三角形切趾函数计算得到的。三角形切趾函数的傅里叶变换即为式(4)的ILS函数。光谱仪使用$796.1^{\circ}\mathrm{C}$便携式黑体以$\mathrm{Wm}^{-2}\mathrm{sr}^{-1}(\mathrm{cm}^{-1})^{-1}$为单位进行校准，并在每次测量序列后重新校准。同时还进行了背景测量(无黑体和标准火焰)，从相应的火焰/黑体测量中扣除以消除背景辐射影响。

光谱测量分别在燃烧器中心上方10mm和20mm高度(HAB)处进行，针对当量比φ=1、φ=0.8和φ=1.4的燃烧工况，光谱分辨率分别为4cm⁻¹和8cm⁻¹。NPL标准火焰具有高度稳定性和良好的长期重现性。图11展示了在φ=1、HAB=20mm条件下测得的两组8cm⁻¹分辨率光谱，两次测量间隔70分钟，同时展示了二者的差异。典型情况下，在φ=1、HAB=20mm条件下，2200-2400cm⁻¹和3200-3700cm⁻¹光谱范围内的测量重现性分别优于2%和5%（时间跨度从分钟到天）。实验中温度场非常稳定，主要波动来源于CO₂/H₂O浓度变化。NPL标准火焰在HAB=10mm和20mm、当量比φ=0.8至φ=1.4条件下的温度场已通过Rayleigh散射测温法[76]测量并发表于文献[73]，报道的火焰温度不确定度为0.45%，长期重现性优于0.20%。NPL标准火焰为平焰，温度分布在中心区域平坦，仅在燃烧器边缘衰减。火焰后区的组分分布相当均匀，已使用GASEQ[77]化学平衡计算程序计算了φ=0.8至φ=1.4条件下的组分浓度并发表于文献[73]。因此，本研究将MLP神经网络从光谱发射测量中反演的温度和组分浓度与文献[73]报道结果进行对比。需注意光谱测量时燃烧可能未在所有位置达到化学平衡，但由于缺乏NPL标准火焰组分浓度的其他实验测量数据，预测浓度只能与这些平衡计算结果进行对比。

![](images/c2e7853de94a376e27a613cfb8458c6e5082a4f34f3eb3e6d9b9207c5c64cd5c.jpg)  
图10. NPL标准火焰辐射发射强度测量实验装置示意图（未按比例绘制）

![](images/330dec6f57f85e8bfd012f99baad3434fed61c418449dba10b91797d4b266ac1.jpg)  
图11. φ=1、HAB=20mm条件下间隔70分钟测量的两组NPL标准火焰光谱（1800-2500cm⁻¹和3000-4200cm⁻¹光谱区间），展示了良好的测量重现性

# 4.2.2. 训练数据生成

为实现基于神经网络的准确预测，需要大量数据集来训练MLP神经网络。如前所述，这些数据包括两类：温度与组分浓度，以及光谱发射强度。温度与组分浓度应在系统整个范围内均匀分布并覆盖所有可能的分布形态。用于训练模型的光谱强度应与实测数据具有相同的维度和分辨率。光谱测量分别在4cm⁻¹和8cm⁻¹分辨率下进行，因此生成了两组对应分辨率的光谱训练数据，每组包含来自10,000种温度分布的10,000个样本。温度剖面根据NPL标准火焰的基本特征创建，即中心区域平坦、燃烧器边缘梯度较大（类似于前文的类型1分布），但NPL标准火焰的温度分布可能并非严格对称。因此采用式(16)生成非对称温度分布：

$$
T(s) = \left\{ \begin{array}{ll}\Delta T_1\times \beta (s) + T_{0,1} & s\leqslant L / 2\\ \Delta T_2\times \beta (s) + T_{0,2} & s > L / 2 \end{array} \right. \tag{16}
$$

其中L为燃烧器宽度（40mm），β(s)为图6中的类型1基函数。燃烧器两侧边缘的最低温度T₀,₁和T₀,₂，以及中心与两侧的温度差ΔT₁和ΔT₂定义为：

$$
T_{0,1} = (2000\times Rn_1 + 500)\mathrm{K} \tag{17}
$$

$$
\Delta T_{1} = (3000\mathrm{K} - T_{0,1})\times Rn_{2} \tag{18}
$$

$$
T_{0,2} = (T_{0,1} + \Delta T_{1} - 500\mathrm{K})\times Rn_{3} \tag{19}
$$

$$
\Delta T_{2} = \Delta T_{1} + T_{0,1} - T_{0,2} \tag{20}
$$

随机数$Rn_{1}-Rn_{3}$均匀分布在0到1之间，可以生成$500\mathrm{K}$到$3000\mathrm{K}$的温度范围，足以覆盖火焰温度区间。图12展示了使用式(16)创建的温度分布示例，分别标注了$T_{0,1}$、$T_{0,2}$、$\Delta T_{1}$和$\Delta T_{2}$。由于火焰组分分布的均匀性，$\mathrm{CO_2}$、$\mathrm{H_2O}$和$\mathrm{CO}$的浓度在0到$20\%$之间随机生成。这些浓度数据与式(16)的温度分布共同用于生成训练光谱强度。所有生成的光谱强度都添加了$3\%$的高斯随机噪声。神经网络训练完成后，模型被用于根据实测光谱强度预测温度和组分浓度。

![](images/7260b8f05ac1a77c4dc18db06b09ce6f309462dd3d1ddc03b462ce6e3d4ece7f.jpg)  
图12. 用于生成训练数据集的温度分布示例

# 4.2.3. 温度与浓度反演结果

图13展示了在$\mathrm{HAB}=10\mathrm{mm}$处，当量比$\phi=1$、$\phi=0.8$和$\phi=1.4$条件下反演得到的温度分布与浓度结果，所用光谱分辨率为$4\mathrm{cm}^{-1}$。其中"预测I"来自$1800-2500\mathrm{cm}^{-1}$光谱区间，"预测II"来自$3000-4200\mathrm{cm}^{-1}$光谱区间。作为对比，图中同时展示了实测温度分布和化学平衡计算得到的组分浓度。实测温度分布带有测量标准偏差，这些标准偏差不代表温度测量不确定度，但可作为火焰稳定性的指标[73]。如图所示，NPL标准火焰在燃烧器中心$\pm10\mathrm{mm}$范围内呈"平坦"稳定状态，超出此范围后温度开始下降，边缘区域存在一定不稳定性。反演温度分布能很好地跟踪这一趋势，并能捕捉到轻微的非对称特征。沿视线方向大部分区域的温度反演结果非常准确。使用$1800-2500\mathrm{cm}^{-1}$光谱区间时，燃烧器中心$10\mathrm{mm}$范围内的平均温度预测值与实测值的差异分别为$-1.37\%$、$0.19\%$和$2.08\%$（对应$\phi=1$、$\phi=0.8$和$\phi=1.4$）；使用$3000-4200\mathrm{cm}^{-1}$光谱区间时，相应差异分别为$-2.45\%$、$0.63\%$和$1.43\%$。$\mathrm{CO_2}$和$\mathrm{H_2O}$浓度的反演结果与化学平衡计算值在定性上吻合良好。由于$\mathrm{HAB}=10\mathrm{mm}$处燃烧可能未达到化学平衡，所有工况下反演的$\mathrm{CO_2}$和$\mathrm{H_2O}$浓度接近或高于平衡计算值。CO浓度的反演精度较低，特别是在贫燃和化学计量燃烧条件下$(\phi\leqslant1)$。

标准NPL火焰的光谱发射测量还在$\mathrm{HAB}=20\mathrm{mm}$处进行，分辨率较低($8\mathrm{cm}^{-1}$)，对应$\phi=1$、$\phi=0.8$和$\phi=1.4$工况。图14展示了基于这些光谱反演的温度分布和浓度结果。从$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)反演的温度与所有当量比下的实测温度吻合良好：燃烧器中心$10\mathrm{mm}$范围内的平均温度预测差异分别为$0.23\%$、$-0.21\%$和$1.88\%$（对应$\phi=1$、$\phi=0.8$和$\phi=1.4$）。在燃烧器两侧边缘附近，反演温度与实测值差异较大。但文献[73]指出，由于空气混合和瑞利测温模型的固有假设，中心$15\mathrm{mm}$以外的温度测量可能存在误差。图14同时展示了$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)的反演结果：$\phi=1$和$\phi=0.8$工况下中心$10\mathrm{mm$范围内的平均温度差异仅为$1.31\%$和$-0.10\%$，但$\phi=1.4$工况下中心区域温度高估约$4\%$，边缘区域则被低估。由于光谱测量时的实际组分浓度可能与化学平衡计算值不同，不同光谱区间的反演结果可互为验证。所有当量比下，两个光谱区间反演的$\mathrm{CO_2}$浓度非常接近，且与化学平衡值相近。所有预测的$\mathrm{H_2O}$浓度都高于平衡值，但不同光谱波段的预测结果彼此接近。同样，当火焰中CO含量极少时，其浓度反演精度较低。

# 5. 结论

基于多层感知器(MLP)神经网络方法开发了逆向辐射模型，用于从燃烧气体混合物的红外光谱发射测量中反演温度和组分浓度分布。该方法展现了出色的非线性逆问题求解能力，提供了高效、全局的逆向辐射模型，能够同时反演$\mathrm{CO_2}$、$\mathrm{H}_2\mathrm{O}$和CO混合气体的温度和组分浓度。通过不同温度与浓度分布的合成光谱"测量"数据对方法进行了测试，并研究了MLP神经网络方法在不同光谱区间和不同光学厚度(通过不同气体路径长度表示)下的标量反演性能。神经网络逆向辐射模型在精度和效率方面均表现出良好性能。通过预测National Physical Laboratory标准火焰的温度和浓度进行了实验验证，并将结果与瑞利散射测温法和化学平衡计算结果进行对比，发现预测值与测量值吻合良好。温度和组分浓度的反演效率极高(每条视线约$10\mathrm{ms}$量级)，因此可用于燃烧过程的监测与控制。

![](images/05778660fd274e594bcd267ed0d0579087ed1ba29733ece23909f5443d5bc67b.jpg)  
图13. 在$\mathrm{HAB}=10\mathrm{mm}$处，当量比$\phi=1$、$\phi=0.8$和$\phi=1.4$条件下，基于$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)和$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)反演的NPL标准火焰温度与组分浓度(分辨率$4\mathrm{cm}^{-1}$)

![](images/48c72678a6c55d9432ff86a60b7ebf38e512f982ace75aba1d81f619b4f8c0a4.jpg)  
图14. 在$\mathrm{HAB}=20\mathrm{mm}$处，当量比$\phi=1$、$\phi=0.8$和$\phi=1.4$条件下，基于$1800-2500\mathrm{cm}^{-1}$光谱区间(预测I)和$3000-4200\mathrm{cm}^{-1}$光谱区间(预测II)反演的NPL标准火焰温度与组分浓度(分辨率$8\mathrm{cm}^{-1}$)

尽管当前工作仅处理单视线光谱测量，但所提出的神经网络逆向辐射模型可轻松适配先进光谱测量设备(如红外高光谱傅里叶变换光谱仪)实现三维火焰诊断。需注意的是，本研究对三种不同分布类型分别进行了测试，但若将所有数据同时用于训练神经网络，该方法也能识别不同分布类型。当前模型可从两个相对较宽的光谱区间同时反演三种气体组分的温度和浓度。不同光谱区间对不同组分的预测精度存在差异，通过研究针对不同组分的最佳光谱波段可进一步提升神经网络逆向辐射模型的性能。

# 致谢

第三和第四作者衷心感谢European Metrology Programme for Innovation and Research (EMPIR)和European Union's Horizon 2020 Research and Innovation Program的支持。

# 参考文献

[1] Draper TS, Zeltner D, Tree DR, Xue Y, Tsilova R. 粉状氧煤火焰的二维温度与发射率测量. Appl Energy 2012;95:38-44.
[2] Lukovic M, Vicic M, Popovic Z, Zekovic L, Kasalica B, Belca I. 基于双色高温计的煤电厂温度分布与衰减系数测量方法. Combust Sci Technol 2018;190(11):2018-29.
[3] Fuest F, Barlow RS, Magnotti G, Dreizler A, Ekoto IW, Sutton JA. 使用一维拉曼/瑞利散射对层流和湍流火焰中乙炔的定量测量. Combust Flame 2015;162(5):2248-55.
[4] Hartl S, Van Winkle R, Geyer D, Dreizler A, Magnotti G, Hasse C, et al. 评估湍流抬升火焰拉曼/瑞利线测量中各火焰区域的相对重要性. Proc Combust Inst 2019;37(2):2297-305.
[5] Li B, He Y, Li Z, Konnov AA. 使用饱和激光诱导荧光和探针采样测量NH3掺杂CH4+空气火焰中的NO浓度. Combust Flame 2013;160(1):40-6.
[6] Bejaoui S, Mercier X, Desgroux P, Therssen E. 使用紫外和可见激发波长对大气碳烟火焰中芳香族产物的激光诱导荧光光谱研究. Combust Flame 2014;161(10):2479-91.
[7] Skiba AW, Carter CD, Hammack SD, Miller JD, Gord JR, Driscoll JF. 大涡对湍流预混火焰结构的影响：20kHz立体PIV和多组分PLIF表征. Proc Combust Inst 2019;37(2):2477-84.
[8] Sepman A, Ogren Y, Gullberg M, Wiinikka H. 用于中试气化炉反应器核心CO、H2O和碳烟浓度诊断的TDLAS传感器开发. Appl Phys B 2016;122(2):29.
[9] Wu Q, Wang F, Li M, Yan J, Cen K. 使用可调谐二极管激光吸收光谱同时原位测量乙烯/空气预混火焰中的碳烟体积分数、H2O浓度和温度. Combust Sci Technol 2017;189(9):1571-90.
[10] Kranendonk LA, Caswell AW, Sanders ST. 从宽带光谱计算温度、压力和吸收体摩尔分数的稳健方法. Appl Opt 2007;46(19):4117-24.
[11] Ellis DJ, Solovjov VP, Tree DR. 利用H2O红外光谱带发射进行温度测量. J Energy Resur Technol 2016;138(4):042001.
[12] Rhoby MR, Blunck DL, Gross KC. 用于二维标量值的层流火焰中红外高光谱成像. Opt Exp 2014;22(18):21600-17.
[13] Harley JL, Rankin BA, Blunck DL, Gore JP. Gross KC. 湍流非预混喷射火焰的成像傅里叶变换光谱仪测量. Opt Lett 2014;39(8):2350-3.
[14] Charette A, Boulanger J, Kim HK. 光学断层成像中辐射传输算法最新进展概述. J Quant Spectrosc Radiat Transf 2008;109(17-18):2743-66.
[15] Anderson RJ, Griffiths PR. 从中等分辨率吸收光谱测定双原子分子的转动温度. J Quant Spectrosc Radiat Transf 1977;17:393-401.
[16] Gross LA, Griffiths PR. 通过中分辨率红外吸收光谱法估算二氧化碳温度. J Quant Spectrosc Radiat Transf 1988;39(2):131-8.
[17] Solomon PR, Best PE, Carangelo RM, Markham JR, Chien P-L, Santoro RJ, et al. 用于原位燃烧诊断的FT-IR发射/透射光谱. Proc Comb Inst 1987;21:1763-71.
[18] Best PE, Chien PL, Carangelo RM, Solomon PR, Danchak M, Ilovici I. 碳烟层流扩散火焰中FT-IR发射和透射光谱的断层重建：组分浓度和温度. Combust Flame 1991;85:309-14.
[19] Hommert PJ, Viskanta R, Mellor AM. 通过光谱遥感进行火焰温度测量. Combust Flame 1977;30:295-308.
[20] Buchele DR. 基于红外发射吸收光谱的气体温度剖面计算程序. NASA-TM-73848.
[21] Kim HK, Song T-H. 采用SRS技术快速高效反演方案确定大型炉内气体温度剖面. J Quant Spectrosc Radiat Transf 2005;93:369-81.
[22] Song T-H. 炉膛与火焰的光谱遥感技术. Heat Transfer Eng 2008;29(4):417-28.
[23] Ren T, Modest MF. 基于Tikhonov正则化的二氧化碳光谱强度温度剖面反演. J Thermoph Heat Transfer 2016;30:211-8.
[24] Zhang G, Wang G, Huang Y, Wang Y, Liu X. 基于TDLAS的轴对称火焰温度与CO2浓度场重建与模拟. Optik 2018;170:166-77.
[25] Liu G, Liu D. 纳米流体燃料碳烟火焰中温度与碳烟/金属氧化物纳米颗粒体积分数的同步辐射重建. Int J Heat Mass Transfer 2018;118:1080-9.
[26] Dash CJ. 一维层析成像：Abel、洋葱剥离与滤波反投影方法比较. Appl Opt 1992;31:1146-52.
[27] Liu X, Zhang Y, Huang G, Wang Y, Qi F. 通过4.2μm中红外直接吸收光谱测量大气层流扩散火焰的二维温度与二氧化碳浓度分布. Appl Phys B 2018;124(4):61.
[28] Cai W, Kaminski CF. 用于气体动力学与反应流研究的层析吸收光谱技术. Prog Energy Combust Sci 2017;59:1-31.
[29] Vollmer M, Klaus-Peter M. 红外热成像：原理、研究与应用. John Wiley & Sons, 2017.
[30] Liu H, Zheng S, Zhou H. 采用高光谱层析技术测量轴对称乙烯层流火焰碳烟温度与体积分数. IEEE Trans Instrum Meas 2017;66(2):315-24.
[31] Hsu PS, Lauriola D, Jiang N, Miller JD, Gord JR, Roy S. 用于燃烧诊断的紫外-短波红外光纤耦合高光谱成像传感器. Appl Opt 2017;56(21):6029-34.
[32] Grauer SJ, Unterberger A, Rittler A, Daun KJ, Kempf AM, Mohri K. 基于背景纹影层析的瞬态三维火焰成像. Combust Flame 2018;196:284-99.
[33] Sun J, Hossain MM, Xu C, Zhang B. 通过光场相机研究火焰辐射采样与温度测量. Int J Heat Mass Transfer 2018;121:1281-96.
[34] Scafati FT, Lavorgna M, Mancaruso E, Vaglieco BM. 内燃机非线性现象建模与控制的人工智能方法. Nonlinear systems and circuits in internal combustion engines. Springer; 2018. p. 1-19.
[35] Alpaydin E. 机器学习：新人工智能. MIT Press; 2016.
[36] Rahman A, Smith AD. 采用深度学习算法预测供热需求与分层蓄热罐尺寸. Appl Energy 2018;228:108-21.
[37] Robinson C, Dilkina B, Hubbs J, Zhang W, Guhathakurta S, Brown MA, Pendyala RM. 商业建筑能耗评估的机器学习方法. Appl Energy 2017;208:889-904.
[38] Lou S, Li DH, Lam JC, Chan WW. 基于机器学习与多元回归的散射太阳辐照度预测. Appl Energy 2016;181:367-74.
[39] Rodrigues E, Pinheiro VHA, Liatsis P, Conci A. 机器学习在心脏心外膜与纵隔脂肪体积预测中的应用. Comput Biol Med 2017;89:520-9.
[40] Rahat AA, Wang C, Everson RM, Fieldsend JE. 燃煤锅炉燃烧系统的数据驱动多目标优化. Appl Energy 2018;229:446-58.
[41] Hadji- Lazaro J, Clerbaux C, Thirta S. 基于神经网络的高分辨率天底辐射反演大气CO总柱浓度算法. J Geophys Res: Atmosph 1999;104(7):19):23841- 54. 
[42] Aires F, Chedin A, Scott NA, Rosso W. 使用IASI仪器反演大气和地表温度的规范化神经网络方法. J Appl Meteorol 2002;41(2):144- 59. 
[43] Blackwell WJ. 从高光谱分辨率探测数据反演大气温湿度剖面的神经网络技术. IEEE Trans Geosci Erm Sens 2005;43(11):2535- 46. 
[44] Garcia- Cuesta E, de la Torre F, de Castro AJ. 辐射传输方程反演中监督学习技术的比较研究. Proceedings of the world congress on engineering and computer science. 2007. p. 24- 6. 
[45] Garcia- Cuesta E, Galvan IM, de Castro AJ. 多层感知器在地基遥感温度反演问题中的逆向模型应用. Eng Appl Artif Intell 2008;21(1):26- 34.
[46] Garcia- Cuesta E, de Castro AJ, Galvan IM, Lopez F. 利用多层感知器建模和红外CO2发射带光谱特征选择的轴对称燃烧羽流温度剖面反演. Appl Spectrosc 2014;68(8):900- 8. 
[47] Huang HL, Antonelli P. 主成分分析在高分辨率红外测量压缩与反演中的应用. J Appl Meteorol 2001;40(3):365- 88. 
[48] Cieszcyk S. 基于多条CO2谱线辐射强度比的羽流温度分布测定. Optical sensors 2015, vol. 9506. 2015. p. 950623. 
[49] Nutkiewicz A, Yang Z, Jain RK. 数据驱动的城市能源模拟(DUE-S)：多尺度城市能源建模工作流中集成工程模拟与机器学习方法的框架. Appl Energy 2018;225:1176- 89. 
[50] Ma R, Yang T, Breaz E, Li Z, Briois P, Gao F. 通过深度学习方法数据驱动预测质子交换膜燃料电池退化. Appl Energy 2018;231:102- 15. 
[51] Rothman L, Gordon I, Babikov Y, Barbe A, Benner DC, Bernath P, et al. HITRAN2012分子光谱数据库. J Quant Spectrosc Radiat Transf 2013;130:4- 50. 
[52] Gordon I, Rothman L, Hill C, Kochanov R, Tan Y, Bernath P, et al. HITRAN2016分子光谱数据库. J Quant Spectrosc Radiat Transf 2017;203:3- 69. 
[53] Rothman LS, Gordon IE, Barber RJ, Dothe H, Gamache RR, Goldman A, et al. 高温分子光谱数据库HITEMP. J Quant Spectrosc Radiat Transf 2010;111(1):2139- 50. 
[54] Tashkun SA, Prevalov VI, Teffo J- L, Bykoy AD, Lavrentieva NN. 高温二氧化碳光谱数据库CDSD-1000. J Quant Spectrosc Radiat Transf 2003;82(1-4):165- 96 available from ftp://ftp.iao.ru/pub/CDSD- 1000. 
[55] Tashkun SA, Prevalov VI. 高分辨率高温二氧化碳光谱数据库CDSD-4000. J Quant Spectrosc Radiat Transf 2011;112(9):1403- 10 available from ftp://ftp.iao.ru/pub/CDSD- 4000. 
[56] Modest MF, Bharadwaj SP. 二氧化碳-氮气混合物的高分辨率高温透射率测量与关联. J Quant Spectrosc Radiat Transf 2002;73(2-5):329- 38. 
[57] Bharadwaj SP, Modest MF. 高温下CO2中分辨率透射测量更新. J Quant Spectrosc Radiat Transf 2007;103:146- 55. 
[58] Evseev V, Fateev A, Clausen S. 工业应用的高温CO2高分辨率透射测量. J Quant Spectrosc Radiat Transf 2012;113:2222- 33. 
[59] Bharadwaj SP, Modest MF, Riazi RJ. 高温水蒸气中分辨率透射测量. ASME J Heat Transfer 2006;128:374- 81. 
[60] Fateev A, Clausen S. 在线非接触式气体分析. In: Markens Tekniske Universitet, Riso@Nationallaboratoriet for Beredvigtg Energi; 2008. 
[61] Christiansen C, Stolberg- Rohr T, Fateev A, Clausen S. 用于定量光谱测量的高温高压气体池. J Quant Spectrosc Radiat Transf 2016;169:96- 103. 
[62] Piliougine M, Elizondo D, Mora- Lopez L, Sidrach- de Cardona M. 多层感知器在太阳光谱分布对薄膜光伏组件影响评估中的应用. Appl Energy 2013;112:610- 7. 
[63] Rahman A, Srikumar V, Smith AD. 使用深度循环神经网络预测商业和住宅建筑电力消耗. Appl Energy 2018;212:372- 85. 
[64] Modest MF. 辐射传热. 3rd ed. New York: Academic Press; 2013. 
[65] Gurney K. 神经网络导论. CRC Press; 2014. 
[66] Johns JM, Burkes D. 用于U-Mo-X合金等温时间温度转变预测的多层感知器网络开发. J Nucl Mater 2017;490:155- 66. 
[67] Deo RC, Ghorbani MA, Samadianfard S, Maraseni T, Bilgili M, Biazar M. 结合萤火虫优化算法的多层感知器混合模型用于基于有限邻近参考站数据的目标站点风速预测. Renew Energy 2018;116:309- 23. 
[68] Bento P, Pombo J, Calado M, Mariano S. 基于引导优化的神经网络和小波变换的短期价格预测方法. Appl Energy 2018;210:88- 97. 
[69] Wang S, Chen H. 一种使用深度卷积神经网络进行电能质量扰动分类的新型深度学习方法. Appl Energy 2019;235:1126- 40. 
[70] Zendehboudi A, Tatar A, Li X. 液体除湿器的智能模型比较研究与预测. Renew Energy 2017;114:1023- 35. 
[71] Pedregosa F, Varoquaux G, Gramfort A, Michel V, Thirion B, Grisel O, et al. Scikit-learn: Python中的机器学习. J Mach Learn Res 2011;12(Oct):2825- 30. 
[72] Kingma DP, Ba J. Adam: 一种随机优化的Python方法. arXiv preprint arXiv:1412.6980. 
[73] http://www.npl.co.uk/temperature- humidity/products- services/portable- standard- flame. 
[74] Pearce J, Edler F, Elliott C, Rosso L, Sutton G, Zante R, et al. 通过改进温度测量提高工艺效率的欧洲项目：EMPRESS. In: 17th international congress of metrology, EDP sciences; 2015. p. 08001. http://www.npl.co.uk/content/ConPublication/7281. 
[75] Sutton G, Greenen A, Stanger L, de Podesta M. NPL便携式标准火焰：使用精密瑞利散射测温法对燃烧器上方温度场的表征. NPL Report. ENG 69; 2018. 
[76] Morley C. < http://www.gaseq.co.uk/>

# References

[1] Draper TS, Zeltner D, Tree DR, Xue Y, Tsilova R. Two- dimensional flame temperature and emissivity measurements of pulverized oxy- coal flames. Appl Energy 2012;95:38- 44. 
[2] Lukovic M, Vicic M, Popovic Z, Zekovic L, Kasalica B, Belca I. Two- color pyrometer- based method for measuring temperature profiles and attenuation coefficients in a coal power plant. Combust Sci Technol 2018;190(11):2018- 29. 
[3] Fuest F, Barlow RS, Magnotti G, Dreizler A, Ekoto IW, Sutton JA. Quantitative acetylene measurements in laminar and turbulent flames using 1D Raman/Rayleigh scattering. Combust Flame 2015;162(5):2248- 55. 
[4] Hartl S, Van Winkle R, Geyer D, Dreizler A, Magnotti G, Hasse C, et al. Assessing the relative importance of flame regimes in Raman/Rayleigh line measurements of turbulent lifted flames. Proc Combust Inst 2019;37(2):2297- 305. 
[5] Li B, He Y, Li Z, Konnov AA. Measurements of NO concentration in NH 3- doped CH 4+ air flames using saturated laser- induced fluorescence and probe sampling. Combust Flame 2013;160(1):40- 6. 
[6] Bejaoui S, Mercier X, Desgroux P, Therssen E. Laser induced fluorescence spectroscopy of aromatic species produced in atmospheric sooting flames using UV and visible excitation wavelengths. Combust Flame 2014;161(10):2479- 91. 
[7] Skiba AW, Carter CD, Hammack SD, Miller JD, Gord JR, Driscoll JF. The influence of large eddies on the structure of turbulent premixed flames characterized with stereo- PIV and multi- species PLIF at 20 kHz. Proc Combust Inst 2019;37(2):2477- 84. 
[8] Sepman A, Ogren Y, Gullberg M, Wiinikka H. Development of TDLAS sensor for diagnostics of CO, H2O and soot concentrations in reactor core of pilot- scale gasifier. Appl Phys B 2016;122(2):29. 
[9] Wu Q, Wang F, Li M, Yan J, Cen K. Simultaneous in- situ measurement of soot volume fraction, H2O concentration, and temperature in an ethylene/air premixed flame using tunable diode laser absorption spectroscopy. Combust Sci Technol 2017;189(9):1571- 90. 
[10] Kranendonk LA, Caswell AW, Sanders ST. Robust method for calculating temperature, pressure, and absorber mole fraction from broadband spectra. Appl Opt 2007;46(19):4117- 24. 
[11] Ellis DJ, Solovjov VP, Tree DR. Temperature measurement using infrared spectral band emissions from H2O. J Energy Resur Technol 2016;138(4):042001. 
[12] Rhoby MR, Blunck DL, Gross KC. Mid- IR hyperspectral imaging of laminar flames for 2- D scalar values. Opt Exp 2014;22(18):21600- 17. 
[13] Harley JL, Rankin BA, Blunck DL, Gore JP. Gross KC. Imaging fourier- transform spectrometer measurements of a turbulent nonpremixed jet flame. Opt Lett 2014;39(8):2350- 3. 
[14] Charette A, Boulanger J, Kim HK. An overview on recent radiation transport algorithm development for optical tomography imaging. J Quant Spectrosc Radiat Transf 2008;109(17- 18):2743- 66. 
[15] Anderson RJ, Griffiths PR. Determination of rotational temperatures of diatomic molecules from absorption spectra measured at moderate resolution. J Quant Spectrosc Radiat Transf 1977;17:393- 401. 
[16] Gross LA, Griffiths PR. Temperature estimation of carbon dioxide by infrared absorption spectrometry at medium resolution. J Quant Spectrosc Radiat Transf 1988;39(2):131- 8. 
[17] Solomon PR, Best PE, Carangelo RM, Markham JR, Chien P- L, Santoro RJ, et al. Ft- ir emission/ transmission spectroscopy for in situ combustion diagnostics. Proc Comb Inst 1987;21:1763- 71. 
[18] Best PE, Chien PL, Carangelo RM, Solomon PR, Danchak M, Ilovici I. Tomographic reconstruction of ft- ir emission and transmission spectra in a sooting laminar diffusion flame: species concentrations and temperatures. Combust Flame 1991;85:309- 14. 
[19] Hommert PJ, Viskanta R, Mellor AM. Flame temperature measurements by spectral remote sensing. Combust Flame 1977;30:295- 308. 
[20] Buchele DR. Computer program for calculation of a gas temperature profile by infrared emission: absorption spectroscopy. NASA- TM- 73848. 
[21] Kim HK, Song T- H. Determination of the gas temperature profile in a large- scale furnace using a fast/efficient inversion scheme for the SRS technique. J Quant Spectrosc Radiat Transf 2005;93:369- 81. 
[22] Song T- H. Spectral remote sensing for furnaces and flames. Heat Transfer Eng 2008;29(4):417- 28. 
[23] Ren T, Modest MF. Temperature profile inversion from carbon- dioxide spectral intensities through Tikhonov regularization. J Thermoph Heat Transfer 2016;30:211- 8. 
[24] Zhang G, Wang G, Huang Y, Wang Y, Liu X. Reconstruction and simulation of temperature and  $\mathrm{CO_2}$  concentration in an axisymmetric flame based on TDLAS. Optik 2018;170:166- 77. 
[25] Liu G, Liu D. Volume radiation analysis for simultaneous reconstruction of temperature and inverse fraction fields of soot and metal- oxide nanoparticles in a nanofluid fuel sooting flame. Int J Heat Mass Transfer 2018;118:1080- 9. 
[26] Dash CJ. One- dimensional tomography: a comparison of abel, onion- peeling, and filtered backprojection methods. Appl Opt 1992;31:1146- 52. 
[27] Liu X, Zhang Y, Huang G, Wang Y, Qi F. Two- dimensional temperature and carbon dioxide concentration profiles in atmospheric laminar diffusion flames measured by mid- infrared direct absorption spectroscopy at  $4.2\mu \mathrm{m}$ . Appl Phys B 2018;124(4):61. 
[28] Cai W, Kaminski CF. Tomographic absorption spectroscopy for the study of gas dynamics and reactive flows. Prog Energy Combust Sci 2017;59:1- 31. 
[29] Vollmer M, Klaus- Peter M. Infrared thermal imaging: fundamentals, research and applications. John Wiley & Sons, 2017. 
[30] Liu H, Zheng S, Zhou H. Measurement of soot temperature and volume fraction of axisymmetric ethylene laminar flames using hyperspectral tomography. IEEE Trans Instrum Meas 2017;66(2):315- 24. 
[31] Hsu PS, Lauriola D, Jiang N, Miller JD, Gord JR, Roy S. Fiber- coupled, uv- swir hyperspectral imaging sensor for combustion diagnostics. Appl Opt 2017;56(21):6029- 34. 
[32] Grauer SJ, Unterberger A, Rittler A, Daun KJ, Kempf AM, Mohri K. Instantaneous 3d flame imaging by background- oriented schlieren tomography. Combust Flame 2018;196:284- 99. 
[33] Sun J, Hossain MM, Xu C, Zhang B. Investigation of flame radiation sampling and temperature measurement through light field camera. Int J Heat Mass Transfer 2018;121:1281- 96. 
[34] Scafati FT, Lavorgna M, Mancaruso E, Vaglieco BM. Artificial intelligence for modeling and control of nonlinear phenomena in internal combustion engines. Nonlinear systems and circuits in internal combustion engines. Springer; 2018. p. 1- 19. 
[35] Alpaydin E. Machine learning: the new AI. MIT Press; 2016. 
[36] Rahman A, Smith AD. Predicting heating demand and sizing a stratified thermal storage tank using deep learning algorithms. Appl Energy 2018;228:108- 21. 
[37] Robinson C, Dilkina B, Hubbs J, Zhang W, Guhathakurta S, Brown MA, Pendyala RM. Machine learning approaches for estimating commercial building energy consumption. Appl Energy 2017;208:889- 904. 
[38] Lou S, Li DH, Lam JC, Chan WW. Prediction of diffuse solar irradiance using machine learning and multivariable regression. Appl Energy 2016;181:367- 74. 
[39] Rodrigues E, Pinheiro VHA, Liatsis P, Conci A. Machine learning in the prediction of cardiac epicardial and mediastinal fat volumes. Comput Biol Med 2017;89:520- 9. 
[40] Rahat AA, Wang C, Everson RM, Fieldsend JE. Data- driven multi- objective optimisation of coal- fired boiler combustion systems. Appl Energy 2018;229:446- 58. 
[41] Hadji- Lazaro J, Clerbaux C, Thirta S. An inversion algorithm using neural networks to retrieve atmospheric co total columns from high- resolution nadir radiances. J Geophys Res: Atmosph 1999;104(7):19):23841- 54. 
[42] Aires F, Chedin A, Scott NA, Rosso W. A regularized neural net approach for retrieval of atmospheric and surface temperatures with the iasi instrument. J Appl Meteorol 2002;41(2):144- 59. 
[43] Blackwell WJ. A neural- network technique for the retrieval of atmospheric temperature and moisture profiles from high spectral resolution sounding data. IEEE Trans Geosci Erm Sens 2005;43(11):2535- 46. 
[44] Garcia- Cuesta E, de la Torre F, de Castro AJ. A comparative study of supervised learning techniques for the radiative transfer equation inversion. Proceedings of the world congress on engineering and computer science. 2007. p. 24- 6. 
[45] Garcia- Cuesta E, Galvan IM, de Castro AJ. Multilayer perceptron as inverse model in a ground- based remote sensing temperature retrieval problem. Eng Appl Artif Intell 2008;21(1):26- 34.


[46] Garcia- Cuesta E, de Castro AJ, Galvan IM, Lopez F. Temperature profile retrieval in axisymmetric combustion plumes using multilayer perceptron modeling and spectral feature selection in the infrared CO2 emission band. Appl Spectrosc 2014;68(8):900- 8. 
[47] Huang HL, Antonelli P. Application of principal component analysis to high- resolution infrared measurement compression and retrieval. J Appl Meteorol 2001;40(3):365- 88. 
[48] Cieszcyk S. Determination of plume temperature distribution based on the ratios of the radiation intensities of multiple CO2 lines. Optical sensors 2015, vol. 9506. 2015. p. 950623. 
[49] Nutkiewicz A, Yang Z, Jain RK. Data- driven urban energy simulation (due- s): a framework for integrating engineering simulations and machine learning methods in a multi- scale urban energy modeling workflow. Appl Energy 2018;225:1176- 89. 
[50] Ma R, Yang T, Breaz E, Li Z, Briois P, Gao F. Data- driven proton exchange membrane fuel cell degradation predication through deep learning method. Appl Energy 2018;231:102- 15. 
[51] Rothman L, Gordon I, Babikov Y, Barbe A, Benner DC, Bernath P, et al. The HITRAN2012 molecular spectroscopic database. J Quant Spectrosc Radiat Transf 2013;130:4- 50. 
[52] Gordon I, Rothman L, Hill C, Kochanov R, Tan Y, Bernath P, et al. The HITRAN2016 molecular spectroscopic database. J Quant Spectrosc Radiat Transf 2017;203:3- 69. 
[53] Rothman LS, Gordon IE, Barber RJ, Dothe H, Gamache RR, Goldman A, et al. HITEMP, the high- temperature molecular spectroscopic database. J Quant Spectrosc Radiat Transf 2010;111(1):2139- 50. 
[54] Tashkun SA, Prevalov VI, Teffo J- L, Bykoy AD, Lavrentieva NN. CDSD- 1000, the high- temperature carbon dioxide spectroscopic databank. J Quant Spectrosc Radiat Transf 2003;82(1- 4):165- 96 available from ftp://ftp.iao.ru/pub/CDSD- 1000. 
[55] Tashkun SA, Prevalov VI. CDSD- ,4000: High- resolution, high- temperature carbon dioxide spectroscopic databank. J Quant Spectrosc Radiat Transf 2011;112(9):1403- 10 available from ftp://ftp.iao.ru/pub/CDSD- 4000. 
[56] Modest MF, Bharadwaj SP. High- resolution, high- temperature transmissivity measurements and correlations for carbon dioxide- nitrogen mixtures. J Quant Spectrosc Radiat Transf 2002;73(2- 5):329- 38. 
[57] Bharadwaj SP, Modest MF. Medium resolution transmission measurements of CO2 at high temperature - an update. J Quant Spectrosc Radiat Transf 2007;103:146- 55. 
[58] Evseev V, Fateev A, Clausen S. High- resolution transmission measurements of CO2 at high temperatures for industrial applications. J Quant Spectrosc Radiat Transf 2012;113:2222- 33. 
[59] Bharadwaj SP, Modest MF, Riazi RJ. Medium resolution transmission measurements of water vapor at high temperature. ASME J Heat Transfer 2006;128:374- 81. 
[60] Fateev A, Clausen S. On- line non- contact gas analysis. In: Markens Tekniske Universitet, Riso@Nationallaboratoriet for Beredvigtg Energi; 2008. 
[61] Christiansen C, Stolberg- Rohr T, Fateev A, Clausen S. High temperature and high pressure gas cell for quantitative spectroscopic measurements. J Quant Spectrosc Radiat Transf 2016;169:96- 103. 
[62] Piliougine M, Elizondo D, Mora- Lopez L, Sidrach- de Cardona M. Multilayer perceptron applied to the estimation of the influence of the solar spectral distribution on thin- film photovoltaic modules. Appl Energy 2013;112:610- 7. 
[63] Rahman A, Srikumar V, Smith AD. Predicting electricity consumption for commercial and residential buildings using deep recurrent neural networks. Appl Energy 2018;212:372- 85. 
[64] Modest MF. Radiative heat transfer. 3rd ed. New York: Academic Press; 2013. 
[65] Gurney K. An introduction to neural networks. CRC Press; 2014. 
[66] Johns JM, Burkes D. Development of multilayer perceptron networks for isothermal time temperature transformation prediction of u- mo- x alloys. J Nucl Mater 2017;490:155- 66. 
[67] Deo RC, Ghorbani MA, Samadianfard S, Maraseni T, Bilgili M, Biazar M. Multi- layer perceptron hybrid model integrated with the firefly optimizer algorithm for windspeed prediction of target site using a limited set of neighboring reference station data. Renew Energy 2018;116:309- 23. 
[68] Bento P, Pombo J, Calado M, Mariano S. A boot- optimized neural network and wavelet transform approach for short- term price forecasting. Appl Energy 2018;210:88- 97. 
[69] Wang S, Chen H. A novel deep learning method for the classification of power quality disturbances using deep convolutional neural network. Appl Energy 2019;235:1126- 40. 
[70] Zendehboudi A, Tatar A, Li X. A comparative study and prediction of the liquid desiccant dehumidifiers using intelligent models. Renew Energy 2017;114:1023- 35. 
[71] Pedregosa F, Varoquaux G, Gramfort A, Michel V, Thirion B, Grisel O, et al. Scikit- learn: Machine learning in Python. J Mach Learn Res 2011;12(Oct):2825- 30. 
[72] Kingma DP, Ba J. Adam: a Python for stochastic optimization. arXiv preprint arXiv:1412.6980. 
[73] http://www.npl.co.uk/temperature- humidity/products- services/portable- standard- flame. 
[74] Pearce J, Edler F, Elliott C, Rosso L, Sutton G, Zante R, et al. A european project to enhance process efficiency through improved temperature measurement: empress. In: 17th international congress of metrology, EDP sciences; 2015. p. 08001. http://www.npl.co.uk/content/ConPublication/7281. 
[75] Sutton G, Greenen A, Stanger L, de Podesta M. The NPL portable standard flame: characterisation of the temperature field above the burner using precision Rayleigh scattering thermometry. NPL Report. ENG 69; 2018. 
[76] Morley C. < http://www.gaseq.co.uk/>

