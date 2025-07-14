# A knowledge-and-data-driven modeling approach for simulating plant growth: A case study on tomato growth

# 一种知识与数据双驱动的植物生长建模方法：以番茄生长为例

Xing- Rong Fan<sup>a</sup>, Meng- Zhen Kang<sup>b,*</sup>, Ep Heuvelink<sup>c</sup>, Philippe de Reffye<sup>d</sup>, Bao- Gang Hu<sup>a</sup>

a 中国科学院自动化研究所模式识别国家重点实验室，北京 100190  b 中国科学院自动化研究所复杂系统管理与控制国家重点实验室，北京 100190  c 瓦赫宁根大学园艺与产品生理学组，荷兰瓦赫宁根 6700 AP  d 法国国际农业研究中心，蒙彼利埃 34398

# 文章信息

# 摘要

收稿日期：2014年12月24日  修改日期：2015年6月1日  录用日期：2015年6月3日  在线发表日期：2015年6月25日

关键词：数据驱动模型  知识驱动模型  GreenLab  知识与数据双驱动模型  模型集成  植物生长建模

本文提出了一种新颖的知识与数据双驱动建模(KDDM)方法来模拟植物生长，该方法包含两个子模型。一个子模型源自所有可用的领域知识，包括基于物理或机理模型的所有已知关系；另一个子模型则完全基于数据构建，不使用任何领域知识。在本研究中，采用GreenLab模型作为知识驱动(KD)子模型，径向基函数网络(RBFN)作为数据驱动(DD)子模型。以番茄作物作为植物生长建模的案例研究，使用了五年间十二个温室实验的番茄生长数据集来校准和测试模型。与现有的知识驱动模型(KDM, BIC = 1215.67)和数据驱动模型(DDM, BIC = 1150.86)相比，提出的KDDM方法(BIC = 1144.36)在预测番茄产量方面展现出多项优势。特别是，KDDM方法能够对不同类型器官(包括叶、茎和果实)的产量做出准确预测，即使这些器官的观测数据不可用。案例研究证实KDDM方法继承了KDM和DDM两种方法的优势。文中还讨论了KDDM方法中叠加和组合两种耦合算子的应用情况。

$\mathfrak{E}$ 2015 Elsevier B.V. 版权所有

# 1. 引言

植物与其他生物系统一样，是高度复杂的动态系统。植物生长动态建模对所有相关领域的科学家来说都是一个巨大挑战，他们正在不断改进模型并为各种应用开发新模型。建模方法在多个方面存在差异(如关注尺度、描述层次、环境胁迫整合等)。就领域知识(如基础物理、化学和生物学原理)的运用程度而言，Todorovski和Dzeroski(2006)与Atanasova等(2008)提出了两种基本建模方法，即"知识驱动"和"数据驱动"建模。知识驱动建模方法主要依赖于给定的领域知识，而数据驱动建模方法则能够仅从给定数据中构建模型，无需使用任何领域知识。

一般而言，能够从数据中学习而不使用任何领域知识的模型称为数据驱动模型(DDM)，例如人工神经网络(Recknagel, 2001; Daniel等, 2008)、支持向量机(Pouteau等, 2012)、模糊方法(Gutiérrez-Estrada等, 2013)、广义线性模型和广义可加模型(Guisan等, 2002; Zhang等, 2005)。DDM还包括径向基函数网络(RBFN)，这是最流行的神经网络模型之一，广泛用于函数逼近、时间序列预测和非线性回归(Buhmann, 2003)。这些方法具有许多理想特性，如假设限制较少、能够逼近非线性函数、预测能力强，以及适应多变量系统输入的灵活性。然而，数据驱动模型(DDM)在保留物理系统的物理解释或结构知识方面存在困难，因为它们通常被视为黑箱模型，其参数通常不代表物理系统中的物理参数。因此，DDM也被称为"非参数模型"。

基于领域知识构建的模型称为知识驱动模型(KDM)，也称为基于物理的模型(Solomatine和Ostfeld, 2008)或机理模型(Todorovski和Zeroski, 2006)。对于植物而言，知识驱动模型(KDM)包括基于过程的模型(PBM)(Vos等, 2007; de Reffye等, 2009)。早期的植物生长PBM关注植物功能与环境条件的关系，特别是生物量生产及其分配。最近，新一代PBM(通常称为功能-结构植物模型(FSPM))出现，它整合了先前被忽视的方面，如植物结构(如器官的形状和方向)、器官功能(如叶片光合作用)与环境(如光照)之间的相互作用，以及生物量获取与其分配对植物发育和生长的反馈。迄今为止，FSPM被视为预测和模拟植物生长及结构发育的潜在工具(Renton, 2013)。

GreenLab模型是一个通用的机理性功能-结构植物模型(FSPM)，整合了植物结构和生理功能基础过程的知识。该模型的离散版本由de Reffye和Hu(2003)提出，并在番茄作物案例中由Dong等(2008)和Kang等(2011)进行了研究；与其他通常仅限于模拟的植物模型相比，其关键优势在于参数识别(Christophe等, 2008)。由于GreenLab模型的数学形式化，所有模型参数都可以通过反演方法从测量数据中识别(Zhan等, 2003; Guo等, 2006)。尽管KDM在建模中整合了领域知识并包含物理可解释参数，但它们通常预测能力较差，且难以处理变量增减或数据缺失的情况。例如，GreenLab模型无法有效应用于某些环境变量(如太阳辐射、温度)缺失的广泛环境条件，即使某些环境数据(如二氧化碳浓度、种植日期和种植时重量)可用，也不予考虑。

为了结合KDM和DDM方法的优势，已有研究尝试整合这两种建模方法(Dzeroski和Todorovski, 2003; Hu等, 2009; Qu和Hu, 2011; Czop等, 2011; Ran和Hu, 2014)。在生态科学领域，这种整合方法的成功应用尤其值得关注(Todorovski和Dzeroski, 2006; Atanasova等, 2008; Qu和Hu, 2009; Matsunaga等, 2013)。在这些方法中，通过领域特定知识构建的语法或规则被嵌入到DDM中，以选择最符合数据的候选模型。与上述方法不同，我们的主要兴趣是提出一种新颖的知识与数据双驱动建模(KDDM)方法来模拟植物生长，将知识驱动的理论建模方法与数据驱动建模相结合。以番茄作物作为植物生长建模的案例研究，采用GreenLab模型作为知识驱动子模型，径向基函数网络(RBFN)作为数据驱动子模型。通过双向耦合连接将两种子模型集成，随后开发了基于叠加和组合耦合算子的两种KDDM版本。最后，通过真实数据集验证了KDDM方法在模拟植物生长过程动态方面的有效性和实用性。

# 2. 材料与方法

# 2.1. 模型

# 2.1.1. 径向基函数网络(数据驱动模型)

径向基函数(RBF)网络通常包含三层：输入层、具有非线性RBF激活函数的隐藏层和线性输出层。输入可建模为实数向量$\pmb {x}\in \mathbb{R}^n$。网络输出是输入向量的标量函数$\pmb {f}_d$，由方程(1)给出：

$$
\hat{y} = \pmb {f}_d(\pmb {x},\pmb {\theta}_d) = \pmb {\Phi}(\pmb {x})\pmb {\theta}_d, \tag{1}
$$

其中$d$是与DDM(即RBFN)相关的下标，$\hat{y}$是RBFN的输出，$\pmb {\theta}_d = [W_1,\dots,W_h]^T$表示网络权重，$h$是隐藏层神经元数量，$\pmb {\Phi}(\pmb {x}) = [\phi_1(\pmb {x}),\phi_2(\pmb {x}),\dots,\phi_h(\pmb {x})]$。本工作采用多二次RBF函数$\phi_{j}(\pmb {x}) = \sqrt{1 + ||\pmb{x} - \pmb{c}_{j}||^{2} / \sigma_{j}^{2}}, j = 1,2,\dots,h,$作为RBF激活函数，其中$\pmb {c}_j\in \mathbb{R}^n$是RBF中心，$\sigma_{j}$控制RBF宽度。

# 2.1.2. GreenLab模型(知识驱动模型)

GreenLab模型是一个通用的功能-结构植物模型，模拟植物器官发生、生物量生产和分配的动态过程(Yan等, 2004; Guo等, 2006; Dong等, 2008; Kang等, 2011)。在每个称为生长周期(GC)的时间间隔内，植物生物量生产$Q(i)$的完整公式由方程(2)给出：

$$
\begin{array}{rl} & Q(i) = E(i)\cdot r\cdot S_p(1 - \exp (-\frac{1}{S_p\cdot slw}\sum_{j = 1}^{\min (i,t_a)}[N_{\mathsf{b}}(i - j + 1)\cdot \\ & \qquad \left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.[\\ & \qquad \left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.\left.[]\right
$$

其中$i$(GC)是以热时间表示的观察到的叶序周期；$E(i)$是生长周期$i$的平均潜在生物量生产，取决于植物生长期间的微气候条件(如温度、风速、相对湿度和太阳辐射等)；$r$是水分利用效率；$S_{p}$是与植物冠层投影相关的特征表面积，受自遮荫和与植物密度相关的邻株竞争效应调节；$slw$是比叶重，直接从数据评估；$t_{\mathrm{a}}$是叶片功能持续时间；$t_{\mathrm{x}}^{\mathrm{b}}$是叶片扩展持续时间；$N_{\mathrm{b}}(i)$是植物在生长周期$i$产生的叶片数量；$P_{\mathrm{b}}(k)$是年龄$k$叶片的库强；$D(i)$是生长周期$i$所有扩展器官的需求，是所有单个器官库强的总和，根据方程(2)计算：

$$
D(i) = \sum_{o}\sum_{j = 1}^{\min (i,t_{x}^{o})}N_{o}(i - j + 1)P_{o}(j), \tag{3}
$$

其中$o=$器官类型索引(叶片,b;叶柄,p;节间,i;果实,f)；$t_{x}^{o}$是器官类型$o$的扩展持续时间；$N_{o}(i)$是生长周期$i$器官类型$o$的数量；$P_{o}(i)$是年龄$i$器官类型$o$的库强，根据方程(4)计算：

$$
P_{o}(i) = P_{o}f_{o}(i), \tag{4}
$$

表1 GreenLab模型的库和源参数。

| 参数 | 定义 | 单位 |
|------|------|------|
| Pp, Pi, Pf | 器官库强 [参见方程(4)] | - |
| Sp | 植物投影面积 [参见方程(2)] | cm² |
| r | 水分利用效率 [参见方程(2)] | mg·cm⁻²·mm⁻¹ |

注：a表示叶柄；i表示节间；f表示果实。

其中$P_{o}$表示器官类型$o$的相对库强，反映了特定类型器官$o$从公共库中积累生物量的竞争能力；$f_{o}(j)$是年龄为$j$的器官类型$o$的库强变化函数，由离散beta函数描述(Kang等, 2011)。叶片库强$P_{\mathrm{b}} = 1$作为所有其他器官库强的归一化参考基准。

对于在广泛环境条件下生长的作物，潜在蒸散量(PET)是驱动GreenLab模型中生物量获取的平均潜在生物量生产量$(E)$(Ma等, 2007; Dong等, 2008; Kang等, 2011)。日PET值$(\mathrm{mmday}^{- 1})$通常采用FAO-24辐射法计算(Jensen等, 1990)，如方程(5)所示：

$$
\mathrm{PET} = a + b\left(\frac{\Delta}{\Delta + \gamma}\cdot R_s\right), \tag{5}
$$

其中生长周期的PET$(\mathrm{mmGC}^{- 1})$由日PET值累加得到，其持续时间随日温和每个生长周期的叶间隔期而变化；$\Delta$$(\mathrm{kPa}^{\circ}\mathrm{C}^{- 1})$是与日温相关的水汽压曲线斜率；$R_{s}$$(\mathrm{MJm}^{- 2}\mathrm{day}^{- 1})$为太阳辐射；$\gamma$$(\mathrm{kPa}^{\circ}\mathrm{C}^{- 1})$为湿度计常数，取值为2.45；$a$$(\mathrm{mmday}^{- 1})$为$-0.3$，$b$为调节因子，取值为1.065。由于风速和温室内相对湿度对PET影响较小，分别设为0和$100\%$。需注意PET是多个环境变量的函数，主要包括日温、太阳辐射、风速和相对湿度，但方程(5)并未全部显式给出。

GreenLab模型通过一组递推方程描述，能够快速计算不同环境胁迫条件下各生长周期器官的生物量积累。为简化表达，GreenLab模型可改写为方程(6):

$$
\hat{\pmb{y}} = \pmb {f}_k(\pmb {x},\pmb {\theta}_k), \tag{6}
$$

其中$\pmb{x}$表示与植物生长相关的环境变量，$\hat{\pmb{y}}$表示GreenLab模型的输出(如总干重和各器官类型干重)，$\pmb {f}_k$是与知识驱动模型(即GreenLab模型)相关的函数，$k$为知识驱动模型的下标，$\pmb{\theta}_{k}$是模型参数向量，包括器官库强$(P_{\mathrm{p}},P_{\mathrm{i}},P_{\mathrm{f}})$和方程(2)中控制植物生物量生产的两个源参数$(S_{p},r)$(表1)。

# 2.1.3. 知识与数据双驱动建模方法

本文提出的植物生长模拟KDDM方法主要由两个子模型构成，如图1示意。图1上部代表"知识驱动(KD)"子模型，源自所有可用领域知识，包括基于物理或机理模型的所有已知关系；下部代表"数据驱动(DD)"子模型，仅从数据构建而不使用任何领域知识。该模型可用以下数学公式表示：

$$
\hat{\pmb{y}} = \pmb {f}(\pmb {x},\pmb {\theta}) = \pmb {f}_k(\pmb {x},\pmb {\theta}_k)\oplus \pmb {f}_d(\pmb {x},\pmb {\theta}_d),\pmb {\theta} = (\pmb {\theta}_k,\pmb {\theta}_d), \tag{7}
$$

其中$\pmb {x}\in \mathbb{R}^{n}$和$\hat{\pmb{y}}\in \mathbb{R}^{m}$分别为输入和输出向量；$\pmb{f}$是$\pmb{x}$与$\hat{\pmb{y}}$间完整模型关系的函数；$\pmb {f}_k$和$\pmb {f}_d$分别对应KD和DD子模型的函数。$\theta \in \mathbb{R}^p$是函数$\pmb{f}$的参数向量，$\pmb {\theta}_k$和$\pmb {\theta}_d$分别为$\pmb {f}_k$和$\pmb {f}_d$的参数向量。$p = p_d + p_k$中，$p_d$和$p_k$分别是参数$\pmb {\theta}_k$和$\pmb {\theta}_d$的数量。符号$\Phi$表示两个子模型间的耦合运算。

![](images/2641171cabf13957352030b306c895a3f5b8bc750a031c942fd6332ec5db2c12.jpg)  
图1. 知识与数据双驱动模型(KDDM)示意图，包含"知识驱动(KD)"子模型和"数据驱动(DD)"子模型(Hu等, 2009; Ran和Hu, 2014)。

采用双向耦合连接两个子模型，如方程(7)所示，可灵活表示多种交互形式。通常耦合连接设计无通用方法，其实际配置高度依赖具体问题，可能相当复杂，因为这很大程度上取决于领域知识的呈现形式——可能以约束函数[Hu等(2009)表1]、语法(Todorovski和Dzeroski, 2006)、规则(Matsunaga等, 2013)或基于物理的模型(Czop等, 2011)等形式存在。鉴于KDDM方法中耦合连接的多样性，我们限定使用两种简单通用的耦合算子："叠加"和"组合"(Thompson和Kramer, 1994; Hu等, 2009)。其数学表达式如下：

$$
\begin{array}{r}\text{Supposition:}\pmb {f}(\pmb {x},\pmb {\theta}) = \pmb {f}_k(\pmb {x},\pmb {\theta}_k) + \pmb {f}_d(\pmb {x},\pmb {\theta}_d), \end{array} \tag{8}
$$

$$
\begin{array}{r}\text{Composition:}\pmb {f}(\pmb {x},\pmb {\theta}) = \pmb {f}_k(\pmb {x},\pmb {f}_d(\pmb {x},\pmb {\theta}_d),\pmb {\theta}_k). \end{array} \tag{9}
$$

基于叠加和组合耦合算子的KDDM示意图如图2所示。

采用叠加耦合算子的KDDM(简称KDDM_Sup)，结合方程(1)、(6)和(8)，可表示为：

$$
\hat{\pmb{y}} = \pmb {f}(\pmb {x},\pmb {\theta}) = \pmb {f}_k(\pmb {x},\pmb {\theta}_k) + \pmb {\Phi}(\pmb {x})\pmb {\theta}_d, \tag{10}
$$

其中$\pmb{x}$表示与植物生长相关的环境变量，$\hat{\pmb{y}}$为模型输出。在方程(10)中，KDDM_Sup使用RBFN(即DD子模型)来预测GreenLab模型(即KD子模型)未能解释的残差。

采用组合耦合算子的KDDM(简称KDDM_Com)，结合方程(1)、(6)和(9)，可表示为：

$$
\begin{array}{rl} & E = \Phi (\pmb {x})\pmb {\theta}_d,\\ & \hat{\pmb{y}} = \pmb {f}(\pmb {x},\pmb {\theta}) = \pmb {f}_k(E,\pmb {\theta}_k). \end{array} \tag{11}
$$

在方程(11)中，KDDM_Com采用RBFN(即DD子模型)来量化所有环境变量$(\pmb{x})$下的平均潜在生物量产量$(E)$。当模型参数$\pmb{\theta}$确定后，给定$\pmb{x}$时，RBFN的输出$(E)$将直接影响GreenLab模型的输出。

# 2.2. 植物材料与测量方法

数据来自12个无限生长型番茄(Lycopersicon esculentum 'Counter')的生长实验，这些实验在荷兰瓦赫宁根大学园艺系(Heuvelink, 1995)的温室中跨越不同季节进行了五年。每6-22天从3-8株番茄植株上破坏性采集叶片(包括叶柄)、茎和单个果穗的干重，并记录每穗的叶片、茎和果实数量。总干重(共151个数据点)由各组分重量计算得出。此外，在整个番茄生长周期中还记录了若干每日环境变量(表2)。

![](images/dde96d02922aa524dd84498c37ff983bab86cf81993a6ce1a9db31918861a397.jpg)  
图2. 知识与数据双驱动模型(KDDM)的两种耦合情况：(a)叠加耦合算子；(b)组合耦合算子

# 2.3. 参数估计

根据模型中包含的观测数据集，使用"A"和"P"来区分不同模型(表3)。"A"表示使用全部观测数据的模型，包括不同类型器官的干重和总干重(器官干重之和)；"P"表示仅使用部分观测数据(即仅总干重)的模型。对于每个模型，采用均方误差(MSE)优化准则来最小化观测值与预测值之间的差异，$J(\theta)$由方程(12)给出：

$$
J(\pmb {\theta}) = \frac{1}{2} (\pmb {y} - \hat{\pmb{y}})^T (\pmb {y} - \hat{\pmb{y}}), \tag{12}
$$

表2 变量描述

| 变量 | 定义 | 单位 |
|------|------|------|
| x1 | 种植日期 | 天 |
| x2 | 种植时的重量 | g m-2 |
| x3 | 日总辐射量 | MJ m-2 day-1 |
| x4 | 日温度 | °C |
| x5 | 日二氧化碳浓度(CO2) | μmol mol-1 |
| y | 总干重 | g m-2 |
| y0 | 不同类型器官的干重 | g m-2 |

表3 不同模型包含的观测数据程度

| 模型 | 自变量/因变量 | 包含的观测数据程度 |
|------|--------------|------------------|
| RBFN(A) | (x1, x2, x3, x4, x5)/y0 | y,y0 |
| RBFN(P) | (x1, x2, x3, x4, x5)/y | y |
| GreenLab(A) | (x3, x4)/y | y,y0 |
| KDDM_Sup(A) | (x1, x2, x3, x4, x5)/y | y |
| KDDM_Sup(P) | (x1, x2, x3, x4, x5)/y | y |
| KDDM_Com(A) | (x1, x2, x3, x4, x5)/y | y,y0 |
| KDDM_Com(P) | (x1, x2, x3, x4, x5)/y | y |

其中θ表示模型参数，y和ŷ分别表示观测值和预测值。

选择了一种两阶段学习算法来训练RBFN。在第一阶段，使用k-center方法和简单的启发式关系(Zhu和Zhang, 2000)确定多二次RBF的中心和宽度。在第二阶段，通过梯度下降法或最小二乘算法估计RBFN的权重。所有观测数据都用于通过广义最小二乘法(GLS)识别GreenLab模型中的源-汇参数，如Zhan等(2003)和Guo等(2006)所述。

由于两个子模型之间的耦合操作，KDDM方法可能存在一些不可识别参数(即无法唯一确定的参数)，即使每个子模型的参数分别可识别(Ran和Hu, 2014)。为解决参数识别问题，KDDM方法的参数估计分两个阶段进行：首先，当所有观测数据可用时，通过GLS方法识别GreenLab模型(即KD子模型)的参数；或当仅给出总干重时，从基因型特定作物的经验知识或已发表的实验数据中获取；然后估计RBFN(即DD子模型)的参数。这种方法合理，因为GreenLab模型能够基于一组相对稳定的基因型特定作物参数来表征植物生长和生物量分配；基因型特定作物的参数变异水平较低(Ma等, 2007; Kang等, 2011)。一旦确定了GreenLab模型的参数，KDDM方法的剩余任务就是确定RBFN参数的适当设置。在最小化方程(12)中的性能度量$J(\theta)$后，使用Levenberg-Marquardt算法(Moré, 1978)估计DD子模型的权重$\theta_d$。

# 2.4. 模型性能评估标准

贝叶斯信息准则(BIC)是用于评估不同模型性能的模型选择标准(Burnham和Anderson, 2002)。BIC值根据以下方程计算(Venables和Ripley, 2002):

$$
\mathsf{BIC} = N*\log \left(\frac{\sum_{l = 1}^{N}(\pmb{y}_l - \hat{\pmb{y}}_l)^2}{N}\right) + p*\log (N), \tag{13}
$$

其中$N$是数据点数量，$\mathbf{y}_l$表示观测值，$\hat{\mathbf{y}}_l$表示预测值，$p$是模型参数数量。

表4 RBFN(A)模型采用12折交叉验证策略进行番茄生长过程模型选择的结果

| 编号 | 参数数量 | BIC | 叶片干重训练RMSE | 叶片干重测试RMSE | 茎干重训练RMSE | 茎干重测试RMSE | 果实干重训练RMSE | 果实干重测试RMSE | 总干重训练RMSE | 总干重测试RMSE |
|------|----------|------|----------------|----------------|----------------|----------------|----------------|----------------|----------------|----------------|
| 1 | 2×3 | 1209.98 | 26.33 | 26.95 | 10.65 | 10.99 | 45.11 | 45.81 | 71.14 | 74.00 |
| 2 | 3×3 | 1202.13 | 21.38 | 22.26 | 8.84 | 9.33 | 41.29 | 41.35 | 65.56 | 68.74 |
| 3 | 4×3 | 1200.34 | 19.88 | 20.69 | 7.89 | 8.37 | 40.13 | 39.94 | 61.75 | 64.23 |
| 4 | 5×3 | 1199.37 | 19.14 | 20.25 | 7.26 | 8.04 | 38.14 | 39.31 | 58.34 | 62.47 |
| 5 | 6×3 | 1211.14 | 19.00 | 20.38 | 7.01 | 7.99 | 37.91 | 39.91 | 57.71 | 62.48 |
| 6 | 7×3 | 1225.25 | 18.95 | 20.44 | 6.59 | 8.02 | 37.95 | 40.44 | 57.78 | 63.17 |
| 7 | 8×3 | 1240.72 | 18.90 | 20.47 | 6.98 | 8.04 | 37.84 | 40.77 | 57.71 | 63.65 |
| 8 | 9×3 | 1255.56 | 18.83 | 20.43 | 6.95 | 8.04 | 37.85 | 41.22 | 57.72 | 64.17 |
| 9 | 10×3 | 1270.42 | 18.80 | 20.41 | 6.93 | 8.02 | 37.81 | 41.31 | 57.73 | 64.39 |
| 10 | 11×3 | 1285.46 | 18.80 | 20.44 | 6.93 | 8.02 | 37.87 | 41.39 | 57.78 | 64.43 |
| 11 | 12×3 | 1300.92 | 18.76 | 20.42 | 6.90 | 7.98 | 37.86 | 41.55 | 57.93 | 65.46 |

总干重的最低BIC和RMSE<sub>tr</sub>值已用粗体标出。

均方根误差(RMSE)是衡量预测值与观测值之间距离的标准指标，由方程(14)给出：

$$
\mathrm{RMSE} = \sqrt{\frac{1}{N}\sum_{l = 1}^{N}(\pmb{y}_l - \hat{\pmb{y}}_l)^2}. \tag{14}
$$

建模效率(EF)是一个无量纲量，用于衡量预测值与观测值之间的整体拟合优度，由以下公式给出(Baey等, 2013)：

$$
\mathrm{EF} = 1 - \frac{\sum_{l = 1}^{N}(\pmb{y}_l - \hat{\pmb{y}}_l)^2}{\sum_{l = 1}^{N}(\pmb{y}_l - \hat{\pmb{y}}_l)^2}, \tag{15}
$$

其中$\hat{\mathbf{y}}_l$表示观测值的平均值。

在模型选择过程中，每个模型都采用了12折交叉验证策略。将12个实验数据集循环划分为训练集和测试集。保留一个实验数据集作为测试集，其余11个数据集用作训练集。在学习过程中共获得12个训练均方根误差$\mathrm{(RMSE_{tr})}$、12个测试均方根误差$\mathrm{(RMSE_{te})}$和12个BIC值。然后将结果取平均得到用于性能比较的平均误差和BIC值。

# 3. 结果

使用RBFN、GreenLab模型和KDDM(包括KDDM.Sup和KDDM.Com)对番茄作物的动态生长过程进行建模。来自12个温室实验的番茄生长数据集被用于校准和测试这些模型。

# 3.1. 各独立模型的结果

# 3.1.1. RBFN的结果

对于RBFN(A)和RBFN(P)，给出了不同参数数量下的平均$\mathrm{RMSE_{tr}}$、$\mathrm{RMSE_{te}}$和BIC值(表4和表5)。RBFN(A)4和RBFN(P)4分别对总干重具有最低的BIC和$\mathrm{RMSE_{te}}$值。与RBFN(A)相比，RBFN(P)对总干重具有更低的BIC值(1150.86)和更低的$\mathrm{RMSE_{te}}$值$(62.34\mathrm{g}\mathrm{m}^{-2})$。在BIC准则下，RBFN(A)和RBFN(P)都获得了最佳泛化性能，它们的最佳隐藏节点数均为5。此外，RBFN(A)的参数总数是RBFN(P)的三倍，因为前者是一个三输出RBF网络，而后者是单输出RBF网络。需要注意的是，RBFN(A)的总干重是网络输出(即器官干重)的总和，其$\mathrm{RMSE_{tr}}$和$\mathrm{RMSE_{te}}$值见表4。

# 3.1.2. GreenLab模型的结果

对于GreenLab(A)，参数估计过程重复了12次，每次使用12个实验数据集中的一个作为测试集。训练误差、测试误差、估计参数值及其标准差(Std.)和变异系数(CV)见表6。GreenLab模型参数的CV值在1.95到3.05之间变化，表明这五个源-汇参数在基因型特异性番茄品种(L. esculentum 'Counter')中表现出很小的变异。尽管$\mathrm{RMSE_{tr}}$的CV值较低，但该模型中$\mathrm{RMSE_{te}}$的CV值非常高，表明GreenLab模型的性能可靠性较低。根据器官汇参数值，从叶片(包括叶柄)到茎再到果实的生物量分配平均比例为1.432:0.643:3.527或26:11:63。

# 3.2. KDDM方法的结果

# 3.2.1. KDDM的模型选择

对于KDDM_Sup(A)和KDDM_Com(A)，给出了不同参数数量下的平均$\mathrm{RMSE_{tr}}$、$\mathrm{RMSE_{te}}$和BIC值(表7)。KDDM_Sup(A)4和KDDM_Com(A)15分别具有最低的BIC和$\mathrm{RMSE_{te}}$值。在BIC准则下，KDDM_Sup(A)和KDDM_Com(A)都获得了最佳泛化性能，其中KDDM_Sup(A)和KDDM_Com(A)中RBFN(即DD子模型)的最佳隐藏节点数分别为5和16。

表5 RBFN(P)模型采用12折交叉验证策略进行番茄生长过程模型选择的结果

| 编号 | 参数数量 | BIC | 总干重训练均方根误差 | 总干重测试均方根误差 |
|------|----------|------|----------------|----------------|
| 1 | 2 | 1196.26 | 71.14 | 73.99 |
| 2 | 3 | 1177.54 | 65.56 | 68.75 |
| 3 | 4 | 1167.57 | 61.90 | 64.42 |
| 4 | 5 | 1156.86 | 58.51 | 62.34 |
| 5 | 6 | 1152.35 | 57.79 | 62.36 |
| 6 | 7 | 1157.50 | 57.83 | 62.84 |
| 7 | 8 | 1162.31 | 57.81 | 63.25 |
| 8 | 9 | 1167.28 | 57.81 | 63.63 |
| 9 | 10 | 1172.38 | 57.85 | 63.85 |
| 10 | 11 | 1177.55 | 57.90 | 63.95 |
| 11 | 12 | 1183.18 | 58.05 | 64.69 |

最低BIC和测试均方根误差值已加粗标出

表6 GreenLab(A)模型采用12折交叉验证策略进行番茄生长过程参数估计的结果

| 实验编号 | GreenLab模型参数 |  |  |  |  | 总干重 |  |
|----------|------------------|------|------|------------|----------------|--------|--------|
|  | Pp | Pi | Pf | Sp (cm²) | r (mg cm⁻² mm⁻¹) | RMSEtr | RMSEte |
| 1 | 0.425 | 0.633 | 3.469 | 1158.711 | 0.166 | 78.80 | 59.01 |
| 2 | 0.428 | 0.638 | 3.508 | 1157.971 | 0.166 | 76.70 | 75.21 |
| 3 | 0.423 | 0.631 | 3.547 | 1112.218 | 0.168 | 72.66 | 128.31 |
| 4 | 0.435 | 0.648 | 3.517 | 1112.214 | 0.168 | 73.12 | 80.33 |
| 5 | 0.435 | 0.648 | 3.511 | 1115.715 | 0.167 | 77.41 | 67.20 |
| 6 | 0.427 | 0.637 | 3.522 | 1183.148 | 0.164 | 76.01 | 71.41 |
| 7 | 0.424 | 0.630 | 3.567 | 1186.277 | 0.164 | 75.85 | 88.45 |
| 8 | 0.446 | 0.666 | 3.615 | 1194.565 | 0.170 | 64.51 | 141.80 |
| 9 | 0.436 | 0.650 | 3.473 | 1185.134 | 0.167 | 77.34 | 35.40 |
| 10 | 0.419 | 0.620 | 3.351 | 1110.649 | 0.171 | 78.46 | 31.28 |
| 11 | 0.449 | 0.669 | 3.598 | 1116.886 | 0.164 | 78.09 | 23.70 |
| 12 | 0.439 | 0.652 | 3.642 | 1264.283 | 0.158 | 71.62 | 104.31 |
| 平均值 | 0.432 | 0.643 | 3.527 | 1172.807 | 0.166 | 75.05 | 75.54 |
| 标准差 | 0.009 | 0.015 | 0.077 | 75.571 | 0.003 | 4.07 | 36.69 |
| 变异系数(%) | 2.083 | 2.333 | 2.183 | 3.033 | 1.947 | 5.42 | 48.57 |

注：Pb设为1作为参考，数据未列出

表7 KDDM方法采用12折交叉验证策略进行模型选择的结果(pk表示KD子模型参数数量，pd表示DD子模型参数数量)

| 编号 | 参数数量(pk+pd) | KDDM_Sup(A) |  |  | KDDM_Com(A) |  |
|------|----------------|-------------|--------|--------|-------------|--------|--------|
|  |  | BIC | RMSEtr | RMSEte | BIC | RMSEtr | RMSEte |
| 1 | 5+2 | 1179.43 | 68.48 | 66.80 | 1180.15 | 68.60 | 66.92 |
| 2 | 5+3 | 1179.69 | 67.33 | 66.70 | 1156.03 | 61.76 | 67.27 |
| 3 | 5+4 | 1180.59 | 66.36 | 65.90 | 1161.06 | 61.79 | 67.27 |
| 4 | 5+5 | 1172.99 | 63.42 | 65.72 | 1165.76 | 61.74 | 67.32 |
| 5 | 5+6 | 1174.09 | 62.55 | 66.44 | 1168.52 | 61.24 | 68.94 |
| 6 | 5+7 | 1179.05 | 62.55 | 66.75 | 1171.04 | 60.72 | 67.50 |
| 7 | 5+8 | 1183.93 | 62.54 | 67.11 | 1147.05 | 54.69 | 58.61 |
| 8 | 5+9 | 1188.81 | 62.53 | 67.49 | 1163.94 | 57.11 | 59.67 |
| 9 | 5+10 | 1193.79 | 62.54 | 67.71 | 1153.57 | 54.03 | 58.16 |
| 10 | 5+11 | 1198.91 | 62.59 | 67.81 | 1162.04 | 54.72 | 59.80 |
| 11 | 5+12 | 1203.57 | 62.53 | 68.46 | 1165.99 | 54.55 | 58.69 |
| 12 | 5+13 | 1208.76 | 62.59 | 68.26 | 1155.24 | 51.55 | 54.39 |
| 13 | 5+14 | 1212.73 | 62.39 | 67.96 | 1158.12 | 51.17 | 54.07 |
| 14 | 5+15 | 1217.40 | 62.31 | 68.08 | 1158.86 | 52.26 | 55.59 |
| 15 | 5+16 | 1220.31 | 61.85 | 68.12 | 1144.36 | 46.98 | 50.26 |
| 16 | 5+17 | 1224.60 | 61.71 | 67.94 | 1149.59 | 47.03 | 50.38 |
| 17 | 5+18 | 1229.37 | 61.67 | 68.08 | 1154.07 | 46.96 | 50.52 |

最低BIC和RMSEte值已加粗标出

与KDDM_Sup(A)相比，KDDM_Com(A)具有更低的BIC值(1144.36)和更低的测试均方根误差值$(50.26\mathrm{g}\mathrm{m}^{-2})$。图3展示了在BIC准则下，KDDM_Com(A)针对不同种植日期的151个数据点的回归曲线。

对于KDDM_Sup(P)和KDDM_Com(P)，GreenLab模型(KD子模型)的参数值取自Dong等(2008)的表4，设定为$P_{D} = 0.54$、$P_{\mathrm{t}} = 0.62$、$P_{\mathrm{r}} = 3.28$、$S_{p} = 1 / (11.1\times 0.77)\mathrm{m}^{2}$以及$r = 1 / 0.28\mathrm{g}\mathrm{m}^{-2}\mathrm{mm}^{-1}$。此处仅展示具有最低BIC值的KDDM_Sup(P)和KDDM_Com(P)的主要结果。KDDM_Sup(P)和KDDM_Com(P)分别具有最低的BIC值(1151.96和1140.90)和$\mathrm{RMSE}_{\mathrm{te}}$值($62.31\mathrm{g}\mathrm{m}^{-2}$和$51.29\mathrm{g}\mathrm{m}^{-2}$)。RBFN(DD子模型)的最佳隐藏节点数分别为5和16。结果表明，KDDM_Com(P)比KDDM_Sup(P)具有更低的BIC和$\mathrm{RMSE}_{\mathrm{te}}$值。

# 3.2.2. KDDM_Com的器官干重预测

除了总干重外，KDDM_Com还能预测不同类型器官的干重。表8展示了KDDM_Com(A)和KDDM.Com(P)在所有温室数据集上对不同器官干重的均方根误差(RMSE)和建模效率(EF)。与KDDM.Com(P)相比，KDDM.Com(A)在叶片和果实干重预测上具有最低的RMSE值，而在茎秆干重预测上两者RMSE值相近。图4展示了KDDM.Com(P)针对12个不同种植日期的温室实验中各器官干重的预测结果。

![](images/65b34b09a084cbe1dd9628c5a2d5f0a1476a017d94e9f4378dd17ce69e50970b.jpg)  
图3. KDDM_Com(A)对12个不同种植日期温室实验(1月1日设为第1天)总干重的回归曲线。12个实验的数据点取自Heuvelink(1995)。

![](images/ad90d86d18d174450706f0d16357c531719f4b3db3dc6b96e6ca384940ab56b1.jpg)  
图4. 同图3。

# 3.2.3. KDDM.Com的平均潜在生物量生产

除了GreenLab模型采用的FAO-24辐射法外，KDDM.Com还能通过RBFN子模型提供计算平均潜在生物量生产$(E)$的替代方法。图5展示了基于FAO-24辐射法和KDDM.Com(A)的$E$值。总体而言，两种方法的趋势一致，$E$值范围在0.1至$27.5\mathrm{mm}^{-2}\mathrm{GC}^{-1}$之间。两种方法的结果表明，晚秋和冬季(实验10、11和12)的$E$值远低于其他实验。与FAO-24辐射法相比，KDDM.Com在整个番茄生长周期中对实验11和12的$E$值预测更大。

# 3.2.4. KDDM.Com(A)四个变量的量化分析

表9量化了KDDM.Com模型中四个输入变量对输出的贡献。结果表明，完整模型$(x_{1},x_{2},x_{3},x_{4},x_{5})$在BIC准则下表现最佳，模型$(x_{1},x_{2},x_{4},x_{5})$与模型$(x_{2},x_{3},x_{4},x_{5})$性能相近，变量组合$(x_{1},x_{3},x_{4},x_{5})$与四变量组合模型$(x_{1},x_{2},x_{3},x_{5})$和$(x_{1},x_{2},x_{3},x_{4})$相当。

# 3.3. 模型性能评估结果

为比较单一模型(RBFN和GreenLab)与KDDM方法的性能，分别评估了它们最佳模型的平均$\mathrm{RMSE_{tr}}$、$\mathrm{RMSE_{te}}$和BIC值(表10)。对于单一模型，RBFN比GreenLab模型具有更低的BIC值，以及更低的$\mathrm{RMSE_{te}}$均值和标准差。与单一模型相比，具有更低BIC值的KDDM方法不仅降低了$\mathrm{RMSE_{te}}$的均值(表明精度提高)，还降低了标准差(表明泛化能力增强)。

表8 KDDM.Com(A)和KDDM.Com(P)对不同器官干重的RMSE和EF评估结果(A:使用全部观测数据；P:仅使用总干重数据)

| 模型 | 指标 | 叶片 | 茎秆 | 果实 |
|------|------|------|------|------|
| KDDM.Com(A) | RMSE | **25.71** | 10.30 | **31.43** |
|  | EF | **0.896** | 0.907 | **0.987** |
| KDDM.Com(P) | RMSE | 30.66 | **9.92** | 34.44 |
|  | EF | 0.852 | **0.914** | 0.960 |

注：加粗显示各器官类型的最低RMSE和最高EF值

表9 KDDM.Com(A)模型在不同输入变量组合下的RMSE和BIC评估结果

| 输入变量 | BIC | RMSEtr | RMSEte |
|----------|------|--------|--------|
| x1,x2,x3,x4,x5 | **1144.4** | **46.98** | **50.26** |
| x1,x2,x3,x5 | 1159.6 | 49.63 | 52.48 |
| x1,x2,x4,x5 | 1175.8 | 62.11 | 69.67 |
| x2,x3,x4,x5 | 1172.5 | 61.24 | 67.94 |
| x1,x3,x4,x5 | 1162.5 | 51.72 | 54.02 |
| x1,x2,x3,x4 | 1161.2 | 50.24 | 53.74 |

注：加粗显示最低的BIC、RMSEtr和RMSEte值

![](images/bd9bb79bcb990cff3bd7d536a2925c0e9dae5df390b48afc9db2d39ce08d6913.jpg)  
图5. 基于FAO-24辐射法和KDDM.Com(A)的平均潜在生物量产量$(E)$值。实心点表示FAO-24辐射法；实线表示KDDM.Com(A)。

# 4. 讨论

# 4.1. 单一模型的特点

就单一模型(即RBFN和GreenLab)而言，GreenLab模型整合了植物生长发育基础过程的知识，能够基于一组相对稳定的参数表征植物生长和生物量分配(表6)，这一发现与Dong等(2008)和Kang等(2011)的结果一致。GreenLab模型中的五个源-汇参数各有其物理意义。具体而言，番茄作物的平均投影面积$(S_{p})$为$0.1173\mathrm{m}^2$，低于种植密度的倒数$(1 / 2.1\mathrm{m}^2)$(Heuvelink, 1995)，这表明番茄作物无法形成封闭冠层。$r$估计值为$0.166\mathrm{mgcm}^{-2}\mathrm{mm}^{-1}$，揭示了番茄作物整个生长周期的平均水分利用效率。器官汇参数的结果表明，约$26\%$的总干重分配给叶片，$11\%$分配给茎秆，$63\%$分配给果实(见第3.1.2节)，这说明汇参数能够反映不同类型器官竞争生物量的能力。这一结论与Heuvelink(1995)的实验观察基本一致。除了模型参数的物理解释外，GreenLab模型的另一个关键特点是能够计算不同类型器官的干重。然而，GreenLab模型在预测总干重时通常精度较差，即使这些数据可用，也无法充分利用种植日期$(x_{1})$、种植时重量$(x_{2})$或每日二氧化碳浓度$(x_{3})$来提高模型性能(表10)：这一缺点源于模型对每日总辐射$(x_{3})$和每日温度$(x_{4})$的依赖(Dong等, 2008; Kang等, 2011)(见图6a)。

表10 基于BIC准则的RBFN、GreenLab、KDDM和GAFNs模型性能评估结果。A:使用所有观测数据；P:仅使用总干重。pk和pd同表7。

| 模型 | 参数数量 (pk + pd) | BIC | 总干重RMSEtr (均值/标准差) | 总干重RMSEte (均值/标准差) |
|------|-------------------|------|--------------------------|--------------------------|
| RBFN(A) | 0 + 15 | 1199.37 | 58.34/2.14 | 62.47/26.28 |
| RBFN(P) | 0 + 5 | 1150.86 | 58.51/2.15 | 62.34/25.93 |
| GreenLab(A) | 5 + 0 | 1215.67 | 75.05/4.07 | 75.54/36.69 |
| KDDM.Com(A) | 5 + 16 | 1144.36 | 46.98/2.01 | 50.26/22.76 |
| KDDM.Com(P) | 5 + 16 | 1140.90 | 46.40/2.02 | 51.29/21.82 |
| GAFNs(P) (Qu and Hu, 2009) | 0 + 13 | 1016.33 | 43.99/1.89 | 54.95/25.59 |

$\mathrm{RMSE}_{\mathrm{tr}}$ 和 $\mathrm{RMSE}_{\mathrm{te}}$ 的最低均值和标准差值已用加粗表示。

![](images/e532073dc802d03de88bec1fb30db4a2cfcab6270696d20c9758dd675287b14d.jpg)  
图6. 不同方法对植物生长过程建模的输入输出关系：(a) 知识驱动模型(KDM, GreenLab)，(b) 数据驱动模型(DDM, RBFN)，(c) 知识数据双驱动模型(KDDM, GreenLab $\oplus$ RBFN)

RBFN模型的主要特点是具有较高的预测精度，并能最大限度地灵活利用环境数据。总干重的实验结果表明，基于BIC准则的RBFN模型适用于本问题，因为它在所有考虑模型中表现出最佳泛化性能(表4和表5)，且通过降低$\mathrm{RMSE}_{\mathrm{te}}$的均值和标准差(表10)，其预测精度优于GreenLab模型。与GreenLab模型不同，当相关数据可用时，RBFN可以通过增减输入节点数量来利用种植日期$(x_{1})$、种植时重量$(x_{2})$和每日二氧化碳浓度$(x_{5})$以提高模型性能。然而，RBFN在物理系统理解和解释方面缺乏透明度，且当器官观测数据不可用时无法预测不同类型器官的干重(见图6b)。此外，当使用不同类型器官的干重作为输出时，其模型复杂度(如参数总数)会随输出节点数量急剧增加(表4)。

# 4.2. KDDM方法中组合算子相对于叠加算子的优势

本研究分别应用基于叠加和组合耦合算子的两种KDDM方法进行植物生长建模。值得关注的是，KDDM.Com在预测总干重方面比KDDM.Sup具有更高精度(见3.2.1节)，这表明对于番茄作物生长建模，KDDM方法中的组合耦合算子比叠加耦合算子更为合理。如图2所示，KDDM.Sup采用RBFN作为DD子模型来补偿KD子模型输出的非线性偏差，且仅考虑部分环境变量与植物生长的相互作用。相比之下，KDDM.Com中的DD子模型首先利用所有环境变量量化平均潜在生物量产量，然后直接影响KD子模型的输出。这种方式使DD子模型能有效补偿植物生长过程中因不确定性导致的KD子模型未知部分和误差。KDDM.Com充分考虑了所有环境变量与植物生长之间的相互作用。实验结果表明，环境对作物产量的影响取决于植物生长过程，其中环境变量起着重要作用。

# 4.3. KDDM与现有KDM和DDM的比较

表11 不同环境胁迫条件下平均潜在生物量产量(E)的计算方法

| 类型 | 计算方法 | 环境胁迫条件 | 参考文献 |
|------|----------|--------------|----------|
| I | E(i) = 常数 | 无任何环境胁迫 | Zhan等(2003) |
| II | E(i) × PAR(i)<sup>a</sup> | 单一环境变量(光限制) | de Reffye等(2009) |
| II | E(i) × Q<sub>w</sub>(i)<sup>b</sup> | 单一环境变量(水限制) | Wu等(2012) |
| III | E(i) = a + b[R<sub>s</sub>·Δ/(ΔA+γ)] | 多环境变量(温度、光照和湿度) | Ma等(2007) |
| III | E(i) = f<sub>A</sub>(温度,光照,CO<sub>2</sub>,...) | 多环境变量(温度,光照,CO<sub>2</sub>等) | 本研究 |

<sup>a</sup> PAR(i)表示生长周期i的光合有效辐射量  
<sup>b</sup> Q<sub>w</sub>(i)表示生长周期i的土壤含水量

与现有的知识驱动模型(KDM)和数据驱动模型(DDM)(即RBFN和GreenLab)相比，KDDM方法在总干重预测方面表现出更好的性能(表10)。KDDM的结构使其能够以最优方式利用领域知识(包括基于物理的模型)和环境变量来获得更好的性能(图6c)。一方面，在DDM的传统应用中，当缺乏器官干重的观测数据时，无法获得此类预测。原则上，DDM不具备这种能力。虽然KDM和KDDM都具备这种能力，但KDM在器官干重预测方面通常精度较差，而KDDM通过源-汇参数的经验知识提高了预测精度，KDDM.Com(P)对不同类型器官(特别是果实)干重的高预测能力证明了这一点(表8)。另一方面，与GreenLab模型相比，KDDM方法能够更准确地评估平均潜在生物量产量$(E)$，因为它可以利用更多环境变量(如种植日期、种植时重量和每日二氧化碳浓度)(图5)。相比之下，通常采用FAO-24辐射法的GreenLab模型无法准确评估E值，特别是在环境变量不足的情况下。

此外，我们量化了KDDM_Com模型中四个输入变量的贡献(表9)。与包含总辐射$(x_{3})$的模型相比，$(x_{1},x_{2},x_{4},x_{5})$模型的预测结果最差，这表明影响植物生长过程的总辐射$(x_{3})$是一个重要的环境变量。图3显示番茄作物在深秋和冬季(实验10、11和12)由于辐射减少而生长缓慢。完整模型$(x_{1},x_{2},x_{3},x_{4},x_{5})$比四变量组合模型$(x_{2},x_{3},x_{4},x_{5})$具有更好的预测精度，这表明种植日期$(x_{1})$考虑了季节效应，可视为作物的播种日期。事实上，图3显示3-6月种植的番茄(实验3、4和5)总干重最高，而9月中旬后种植的(实验11和12)最低。特别是当种植日期$(x_{1})$与总辐射$(x_{3})$结合时，其对作物生长的影响被显著放大；两个四变量组合模型$(x_{1},x_{2},x_{4},x_{5})$和$(x_{2},x_{3},x_{4},x_{5})$的表现明显差于完整模型和其他组合模型，证实了这一点。结果表明所有四变量组合模型的预测精度都远高于GreenLab模型(表9和10)。因此，除了最大限度利用领域知识和环境变量外，KDDM方法的另一个主要特点是即使缺少某个环境变量(如种植日期、总辐射)仍能有效应用。案例研究证实KDDM方法继承了KDM和DDM方法的优势。

此外，我们将本方法与广义关联函数网络(GAFNs)(Qu and Hu, 2009)进行了比较，从模型结构角度看GAFNs可视为KDDM的简化形式。两种方法的主要区别在于由于领域知识可用形式不同导致的耦合配置差异。实验结果表明，虽然根据BIC准则，KDDM的性能不如参数更多的GAFNs(表10)，但KDDM降低了$\mathrm{RMSE}_{\mathrm{te}}$的均值和标准差，表明其性能更可靠；甚至能够预测不同类型器官的干重。

# 4.4. 计算平均潜在生物量产量的新方法

植物生长建模面临的重要挑战之一是处理环境变量的模型灵活性。模型灵活性指模型适应变量变化的能力。这一特性在机理研究和实际应用中都很重要。在机理研究中，可能需要关注特定机理相关的环境变量；而在不同应用场景中，建模者需要根据测量条件给定的不同环境变量设计模型。GreenLab通过计算生长周期$i$的平均潜在生物量产量$E(i)$来提供模型灵活性。根据植物生长过程中的不同环境胁迫条件，GreenLab中计算$E$的方法分为三类(表11)：(I)无环境胁迫时$E(i)$设为常数；(II)其他环境变量最优时$E(i)$与非最优单环境变量成比例；(III)多环境胁迫条件下的潜在蒸散量(PET)。这些可视为基于机理的方法，关注特定机理相关的环境变量。本文中，KDDM.Com方法通过RBFN子模型提供了一种从给定环境变量计算$E$的新方法(见表11中的III)。该方法不仅能最大限度利用给定环境变量提高性能，还能在缺少某个环境变量(如光照、温度)时有效应用(见4.3节)。

# 5. 结论

本文提出了一种知识数据双驱动建模(KDDM)方法用于模拟植物生长。将KDDM应用于番茄生长的案例研究揭示了以下优势：(a)能保留具有物理解释性的参数(如源-汇参数)，在预测植物生长方面具有解释力；(b)即使缺乏器官观测数据，也能高精度预测叶(含叶柄)、茎和果实的干重，这一特性可大大提高数据收集效率(仅需测量总干重)；(c)DD子模型能有效补偿植物生长过程中KD子模型因不确定性产生的未知部分和误差；(d)不仅能最大限度利用领域知识和生态数据提高模型性能，还能有效处理变量或数据增减的情况。

此外，本研究为使用GreenLab模型进行植物生长建模提供了有前景的进展。新版本GreenLab_KDDM在保持基于物理模型为核心的同时，能充分利用数据驱动建模方法的优势。虽然番茄数据集的实验结果证实了GreenLab_KDDM的优越预测能力，但仍需对这一新模型进行更广泛研究。应进一步开发GreenLab_KDDM作为通用工具，用于其他作物的实际应用。

# 致谢

感谢国家863计划(#2012AA101906-2)和国家自然科学基金(#31170670, #61273196)的资助。特别感谢Qu Hanbing博士提供其论文中的计算机代码以及对本工作的宝贵意见和建议。感谢匿名审稿人和编辑对稿件的意见。

## 参考文献

1.  [Atanasova et al., 2008](#bbib0005)
N. Atanasova, L. Todorovski, S. Džeroski, B. Kompare
基于数据和专家知识的自动化模型发现在实际领域中的应用：以Glumsø湖为例
Ecol. Model., 212 (2008), pp. 92-98
2.  [Baey et al., 2013](#bbib0010)
C. Baey, A. Didier, S. Lemaire, F. Maupas, P.H. Courn‘ede
五种经典植物生长模型在甜菜上的参数化及其对根产量和总生物量预测能力的比较
Ecol. Model., 290 (2013), pp. 11-20
3.  [Buhmann, 2003](#bbib0015)
M.D. Buhmann
径向基函数：理论与实现
Cambridge University Press (2003), pp. 11-29
4.  [Burnham and Anderson, 2002](#bbib0020)
K.P. Burnham, D.R. Anderson
模型选择与多模型推断：一种实用的信息论方法
Springer (2002), pp. 284-288
5.  [Christophe et al., 2008](#bbib0025)
A. Christophe, V. Letort, I. Hummel, P.H. Cournède, P. de Reffye, J. Lecœur
基于模型的拟南芥全株水平碳平衡动态分析
Funct. Plant Biol., 35 (2008), pp. 1147-1162
6.  [Czop et al., 2011](#bbib0030)
P. Czop, G. Kost, D. Sławik, G. Wszołek
第一性原理数据驱动模型的构建与识别
J. Achiev. Mater. Manuf. Eng., 44 (2011), pp. 179-186
7.  [Daniel et al., 2008](#bbib0035)
J. Daniel, P.U. Andrés, S. Héctor, B. Miguel, T. Marco
农业生态学中基于人工神经网络的建模研究综述
B. Prasad (Ed.), Soft Computing Applications in Industry., Springer (2008), pp. 247-269
8.  [de Reffye et al., 2009](#bbib0040)
P. de Reffye, E. Heuvelink, Y. Guo, B.G. Hu, B.G. Zhang
耦合过程模型与植物结构模型：作物产量模拟的关键问题
W.X. Cao, J.W. White, E. Wang (Eds.), Crop Modeling and Decision Support, Springer (2009), pp. 130-147
9.  [de Reffye and Hu, 2003](#bbib0045)
P. de Reffye, B.G. Hu
构建高效动态植物生长模型的相关定性与定量选择：以GreenLab为例
B.G. Hu, M. Jaeger (Eds.), First International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA), Tsinghua University Press/Springer, Beijing, China (2003), pp. 87-107
10.  [Dong et al., 2008](#bbib0050)
Q.X. Dong, G. Louarn, Y.M. Wang, J.F. Barczi, P. de Reffye
结构-功能模型GreenLab能否处理由植株间距引起的作物表型可塑性？以番茄为例
Ann. Botany, 101 (2008), pp. 1195-1206
11.  [Džeroski and Todorovski, 2003](#bbib0055)
S. Džeroski, L. Todorovski
基于数据和领域知识学习种群动态模型
Ecol. Model., 170 (2003), pp. 129-140
12.  [Guisan et al., 2002](#bbib0060)
A. Guisan, T.C. Edwards, T. Hastie
物种分布研究中广义线性和广义可加模型的应用场景设定
Ecol. Model., 157 (2002), pp. 89-100
13.  [Guo et al., 2006](#bbib0065)
Y. Guo, Y.T. Ma, Z.G. Zhan, B.G. Li, M. Dingkuhn, D. Luquet, P. de Reffye
玉米功能结构模型GreenLab的参数优化与田间验证
Ann. Botany, 97 (2006), pp. 217-230
14.  [Gutiérrez-Estrada et al., 2013](#bbib0070)
J.C. Gutiérrez-Estrada, I. Pulido-Calvo, D.T. Bilton
生态背景下模糊规则的一致性研究
Ecol. Model., 251 (2013), pp. 187-198
15.  [Heuvelink, 1995](#bbib0075)
E. Heuvelink
温室番茄作物的生长、发育和产量：周期性破坏性测量
Sci. Hortic., 61 (1995), pp. 77-99
16.  [Hu et al., 2009](#bbib0080)
B.G. Hu, H.B. Qu, Y. Wang, S.H. Yang
广义约束神经网络模型：关联非线性回归中的部分已知关系
Inform. Sci., 179 (2009), pp. 1929-1943
17.  [Jensen et al., 1990](#bbib0085)
M.E. Jensen, R.D. Burman, R.G. Allen
蒸散发与灌溉需水量
American Society of Civil Engineers, New York, NY (1990), pp. 332-360
18.  [Kang et al., 2011](#bbib0090)
M.Z. Kang, L.L. Yang, B.G. Zhang, P. de Reffye
番茄动态坐果与源库比的相关性：不同种植密度和季节的通用关系？
Ann. Botany, 107 (2011), pp. 805-815
19.  [Ma et al., 2007](#bbib0095)
Y.T. Ma, B.G. Li, Z.G. Zhan, Y. Guo, D. Luquet, P. de Reffye, M. Dingkuhn
功能结构植物模型GreenLab参数稳定性受种群内变异、季节和生长阶段变化的影响
Ann. Botany, 99 (2007), pp. 61-73
20.  [Matsunaga et al., 2013](#bbib0100)
F.T. Matsunaga, M. Rakocevic, J.D. Brancher
雌雄异株马黛茶3D结构建模及其对环境节律性生长响应
Ecol. Model., 290 (2013), pp. 34-44
21.  [Moré, 1978](#bbib0105)
J.J. Moré
Levenberg-Marquardt算法：实现与理论
G.A. Watson (Ed.), Numerical Analysis, Springer (1978), pp. 105-116
22.  [Pouteau et al., 2012](#bbib0110)
R. Pouteau, J.Y. Meyer, R. Taputuarai, B. Stoll
支持向量机在太平洋岛屿森林中稀有濒危原生植物分布制图中的应用
Ecol. Inform., 9 (2012), pp. 37-46
23.  [Qu and Hu, 2009](#bbib0115)
H.B. Qu, B.G. Hu
广义关联函数网络在植物生长动态过程建模中的变分学习
Ecol. Inform., 4 (2009), pp. 163-176
24.  [Qu and Hu, 2011](#bbib0120)
Y.J. Qu, B.G. Hu
受线性先验约束的广义约束神经网络回归模型
IEEE Trans. Neural Netw., 22 (2011), pp. 2447-2459
25.  [Ran and Hu, 2014](#bbib0125)
Z.Y. Ran, B.G. Hu
参数学习机的结构可辨识性判定
Neurocomputing, 127 (2014), pp. 88-97
26.  [Recknagel, 2001](#bbib0130)
F. Recknagel
机器学习在生态建模中的应用
Ecol. Model., 146 (2001), pp. 303-310
27.  [Renton, 2013](#bbib0135)
M. Renton
亚里士多德与植物结构模型在变化环境中加入进化视角
Front. Plant Sci., 4 (2013), p. 284
28.  [Solomatine and Ostfeld, 2008](#bbib0140)
D.P. Solomatine, A. Ostfeld
数据驱动建模：过去经验与新方法
J. Hydroinform., 10 (2008), pp. 3-22
29.  [Thompson and Kramer, 1994](#bbib0145)
M.L. Thompson, M.A. Kramer
利用先验知识与神经网络建模化学过程
AIChE J., 40 (1994), pp. 1328-1340
30.  [Todorovski and Džeroski, 2006](#bbib0150)
L. Todorovski, S. Džeroski
知识驱动与数据驱动建模方法的整合
Ecol. Model., 194 (2006), pp. 3-13
31.  [Venables and Ripley, 2002](#bbib0155)
W.N. Venables, B.D. Ripley
现代应用统计学与S语言
(fourth ed.), Springer (2002), pp. 107-132
32.  [Vos et al., 2007](#bbib0160)
J. Vos, L.F.M. Marcelis, J.B. Evers
作物生产中的功能-结构植物建模：增加一个维度
Frontis, 22 (2007), pp. 1-12
33.  [Wu et al., 2012](#bbib0165)
L. Wu, F. Le Dimet, P. de Reffye, B.G. Hu, P.H. Cournède, M.Z. Kang
植物生长的最优控制方法-以向日葵供水问题为例
Math. Comput. Simul., 82 (2012), pp. 909-923
34.  [Yan et al., 2004](#bbib0170)
H.P. Yan, M.Z. Kang, P. de Reffye, M. Dingkuhn
模拟资源依赖性生长的动态架构植物模型
Ann. Botany, 93 (2004), pp. 591-602
35.  [Zhan et al., 2003](#bbib0175)
Z.G. Zhan, P. de Reffye, F. Houllier, B.G. Hu
用植物结构数据拟合功能-结构生长模型
B.G. Hu, M. Jaeger (Eds.), First International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA), Tsinghua University Press and Springer, Beijing, China (2003), pp. 108-117
36.  [Zhang et al., 2005](#bbib0180)
L.J. Zhang, J.H. Gove, L.S. Heath
六种建模技术的空间残差分析
Ecol. Model., 186 (2005), pp. 154-177
37.  [Zhu and Zhang, 2000](#bbib0185)
M.X. Zhu, D.L. Zhang
径向基函数中心选择算法研究
J. Anhui Univ. (Nat. Sci.), 24 (2000), pp. 72-78

## References

1.  [Atanasova et al., 2008](#bbib0005)
N. Atanasova, L. Todorovski, S. Džeroski, B. Kompare
Application of automated model discovery from data and expert knowledge to a real-world domain: lake Glumsø
Ecol. Model., 212 (2008), pp. 92-98
2.  [Baey et al., 2013](#bbib0010)
C. Baey, A. Didier, S. Lemaire, F. Maupas, P.H. Courn‘ede
Parametrization of five classical plant growth models applied to sugar beet and comparison of their predictive capacity on root yield and total biomass
Ecol. Model., 290 (2013), pp. 11-20
3.  [Buhmann, 2003](#bbib0015)
M.D. Buhmann
Radial Basis Functions: Theory and Implementations
Cambridge University Press (2003), pp. 11-29
4.  [Burnham and Anderson, 2002](#bbib0020)
K.P. Burnham, D.R. Anderson
Model Selection and Multi-model Inference: A Practical Information-Theoretic Approach
Springer (2002), pp. 284-288
5.  [Christophe et al., 2008](#bbib0025)
A. Christophe, V. Letort, I. Hummel, P.H. Cournède, P. de Reffye, J. Lecœur
A model-based analysis of the dynamics of carbon balance at the whole-plant level in _Arabidopsis thaliana_
Funct. Plant Biol., 35 (2008), pp. 1147-1162
6.  [Czop et al., 2011](#bbib0030)
P. Czop, G. Kost, D. Sławik, G. Wszołek
Formulation and identification of first-principle data-driven models
J. Achiev. Mater. Manuf. Eng., 44 (2011), pp. 179-186
7.  [Daniel et al., 2008](#bbib0035)
J. Daniel, P.U. Andrés, S. Héctor, B. Miguel, T. Marco
A survey of artificial neural network-based modeling in agroecology
B. Prasad (Ed.), Soft Computing Applications in Industry., Springer (2008), pp. 247-269
8.  [de Reffye et al., 2009](#bbib0040)
P. de Reffye, E. Heuvelink, Y. Guo, B.G. Hu, B.G. Zhang
Coupling process-based models and plant architectural models: a key issue for simulating crop production
W.X. Cao, J.W. White, E. Wang (Eds.), Crop Modeling and Decision Support, Springer (2009), pp. 130-147
9.  [de Reffye and Hu, 2003](#bbib0045)
P. de Reffye, B.G. Hu
Relevant qualitative and quantitative choices for building an efficient dynamic plant growth model: GreenLab case
B.G. Hu, M. Jaeger (Eds.), First International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA), Tsinghua University Press/Springer, Beijing, China (2003), pp. 87-107
10.  [Dong et al., 2008](#bbib0050)
Q.X. Dong, G. Louarn, Y.M. Wang, J.F. Barczi, P. de Reffye
Does the structure-function model GreenLab deal with crop phenotypic plasticity induced by plant spacing? A case study on tomato
Ann. Botany, 101 (2008), pp. 1195-1206
11.  [Džeroski and Todorovski, 2003](#bbib0055)
S. Džeroski, L. Todorovski
Learning population dynamics models from data and domain knowledge
Ecol. Model., 170 (2003), pp. 129-140
12.  [Guisan et al., 2002](#bbib0060)
A. Guisan, T.C. Edwards, T. Hastie
Generalized linear and generalized additive models in studies of species distributions: setting the scene
Ecol. Model., 157 (2002), pp. 89-100
13.  [Guo et al., 2006](#bbib0065)
Y. Guo, Y.T. Ma, Z.G. Zhan, B.G. Li, M. Dingkuhn, D. Luquet, P. de Reffye
Parameter optimization and field validation of the functional–structural model GreenLab for maize
Ann. Botany, 97 (2006), pp. 217-230
14.  [Gutiérrez-Estrada et al., 2013](#bbib0070)
J.C. Gutiérrez-Estrada, I. Pulido-Calvo, D.T. Bilton
Consistency of fuzzy rules in an ecological context
Ecol. Model., 251 (2013), pp. 187-198
15.  [Heuvelink, 1995](#bbib0075)
E. Heuvelink
Growth, development and yield of a tomato crop: periodic destructive measurements in a greenhouse
Sci. Hortic., 61 (1995), pp. 77-99
16.  [Hu et al., 2009](#bbib0080)
B.G. Hu, H.B. Qu, Y. Wang, S.H. Yang
A generalized-constraint neural network model: associating partially known relationships for nonlinear regressions
Inform. Sci., 179 (2009), pp. 1929-1943
17.  [Jensen et al., 1990](#bbib0085)
M.E. Jensen, R.D. Burman, R.G. Allen
Evapotranspiration and Irrigation Water Requirements
American Society of Civil Engineers, New York, NY (1990), pp. 332-360
18.  [Kang et al., 2011](#bbib0090)
M.Z. Kang, L.L. Yang, B.G. Zhang, P. de Reffye
Correlation between dynamic tomato fruit-set and source-sink ratio: a common relationship for different plant densities and seasons?
Ann. Botany, 107 (2011), pp. 805-815
19.  [Ma et al., 2007](#bbib0095)
Y.T. Ma, B.G. Li, Z.G. Zhan, Y. Guo, D. Luquet, P. de Reffye, M. Dingkuhn
Parameter stability of the functional–structural plant model GreenLab as affected by variation within populations, among seasons and among growth stages
Ann. Botany, 99 (2007), pp. 61-73
20.  [Matsunaga et al., 2013](#bbib0100)
F.T. Matsunaga, M. Rakocevic, J.D. Brancher
Modeling the 3d structure and rhythmic growth responses to environment in dioecious yerba-mate
Ecol. Model., 290 (2013), pp. 34-44
21.  [Moré, 1978](#bbib0105)
J.J. Moré
The Levenberg–Marquardt algorithm: implementation and theory
G.A. Watson (Ed.), Numerical Analysis, Springer (1978), pp. 105-116
22.  [Pouteau et al., 2012](#bbib0110)
R. Pouteau, J.Y. Meyer, R. Taputuarai, B. Stoll
Support vector machines to map rare and endangered native plants in Pacific islands forests
Ecol. Inform., 9 (2012), pp. 37-46
23.  [Qu and Hu, 2009](#bbib0115)
H.B. Qu, B.G. Hu
Variational learning for generalized associative functional networks in modeling dynamic process of plant growth
Ecol. Inform., 4 (2009), pp. 163-176
24.  [Qu and Hu, 2011](#bbib0120)
Y.J. Qu, B.G. Hu
Generalized constraint neural network regression model subject to linear priors
IEEE Trans. Neural Netw., 22 (2011), pp. 2447-2459
25.  [Ran and Hu, 2014](#bbib0125)
Z.Y. Ran, B.G. Hu
Determining structural identifiability of parameter learning machines
Neurocomputing, 127 (2014), pp. 88-97
26.  [Recknagel, 2001](#bbib0130)
F. Recknagel
Applications of machine learning to ecological modelling
Ecol. Model., 146 (2001), pp. 303-310
27.  [Renton, 2013](#bbib0135)
M. Renton
Aristotle and adding an evolutionary perspective to models of plant architecture in changing environments
Front. Plant Sci., 4 (2013), p. 284
28.  [Solomatine and Ostfeld, 2008](#bbib0140)
D.P. Solomatine, A. Ostfeld
Data-driven modelling: some past experiences and new approaches
J. Hydroinform., 10 (2008), pp. 3-22
29.  [Thompson and Kramer, 1994](#bbib0145)
M.L. Thompson, M.A. Kramer
Modeling chemical processes using prior knowledge and neural networks
AIChE J., 40 (1994), pp. 1328-1340
30.  [Todorovski and Džeroski, 2006](#bbib0150)
L. Todorovski, S. Džeroski
Integrating knowledge-driven and data-driven approaches to modeling
Ecol. Model., 194 (2006), pp. 3-13
31.  [Venables and Ripley, 2002](#bbib0155)
W.N. Venables, B.D. Ripley
Modern Applied Statistics with S
(fourth ed.), Springer (2002), pp. 107-132
32.  [Vos et al., 2007](#bbib0160)
J. Vos, L.F.M. Marcelis, J.B. Evers
Functional–structural plant modelling in crop production: adding a dimension
Frontis, 22 (2007), pp. 1-12
33.  [Wu et al., 2012](#bbib0165)
L. Wu, F. Le Dimet, P. de Reffye, B.G. Hu, P.H. Cournède, M.Z. Kang
An optimal control methodology for plant growth – case study of a water supply problem of sunflower
Math. Comput. Simul., 82 (2012), pp. 909-923
34.  [Yan et al., 2004](#bbib0170)
H.P. Yan, M.Z. Kang, P. de Reffye, M. Dingkuhn
A dynamic, architectural plant model simulating resource-dependent growth
Ann. Botany, 93 (2004), pp. 591-602
35.  [Zhan et al., 2003](#bbib0175)
Z.G. Zhan, P. de Reffye, F. Houllier, B.G. Hu
Fitting a functional–structural growth model with plant architectural data
B.G. Hu, M. Jaeger (Eds.), First International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA), Tsinghua University Press and Springer, Beijing, China (2003), pp. 108-117
36.  [Zhang et al., 2005](#bbib0180)
L.J. Zhang, J.H. Gove, L.S. Heath
Spatial residual analysis of six modeling techniques
Ecol. Model., 186 (2005), pp. 154-177
37.  [Zhu and Zhang, 2000](#bbib0185)
M.X. Zhu, D.L. Zhang
Study on the algorithms of selecting the radial basis function center
J. Anhui Univ. (Nat. Sci.), 24 (2000), pp. 72-78