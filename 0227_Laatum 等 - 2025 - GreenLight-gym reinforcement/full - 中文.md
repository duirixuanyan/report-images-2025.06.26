# GreenLight-Gym：温室生产系统控制的强化学习基准环境

Bart van Laatum ∗ Eldert J. van Henten ∗ Sjoerd Boersma ∗∗ ∗ Agricultural Biosystems Engineering, Wageningen University (e-mail: bart.vanlaatum@wur.nl) ∗∗ Biometris, Wageningen University & Research

摘要：本研究介绍了GreenLight-Gym ∗，这是一个用于开发温室作物生产控制强化学习（RL）方法的新、快速、开源的基准环境。基于最先进的GreenLight模型构建，它具有利用CasADi框架进行高效数值积分的可微分C++实现。GreenLight-Gym比原始GreenLight实现提高了17倍的仿真速度。模块化Python环境包装器能够灵活配置控制任务和基于RL的控制器。通过使用两种著名的RL算法在参数不确定性下学习控制器来展示这种灵活性。GreenLight-Gym为推进RL方法和在多样化条件下评估温室控制解决方案提供了标准化基准。鼓励温室控制社区使用和扩展这个基准，以加速温室作物生产的创新。

∗ https://github.com/BartvLaatum/GreenLight-Gym

关键词：温室控制，强化学习，温室建模，参数不确定性

# 1. 引言

温室生产系统通过提供抵御室外天气事件的韧性，实现全年粮食生产，这在气候变化导致极端天气事件增加的情况下非常必要（Fu等，2023）。与露天农业相比，温室生产系统提供了更多控制作物环境的方面，以维持作物生长和质量的理想气候（Stanghellini等，2019）。在实践中，有经验的种植者依靠他们的专业知识和作物的视觉观察来手动管理温室气候。然而，该行业难以找到能够高效手动控制温室气候的熟练种植者（Sparks，2018）。此外，设施扩建阻碍了手动气候管理。

鉴于这些挑战，需要先进的控制方法来支持甚至自动化种植者的决策制定，以更高效和最少劳动力控制更大规模的温室系统。模型预测控制（MPC）等先进控制方法通过重复解决有限时域最优控制问题来优化温室操作（Van Henten，1994；Van Straten等，2010）。然而，MPC方法需要高计算努力，这对于高保真模型和长期时域变得更加紧迫。特别是在由于传感器不准确和建模错误导致的系统不确定性下（Boersma等，2022；Kuijpers等，2022）。

最近，强化学习（RL）已成为开发温室生产系统控制策略（即控制器）的有前景框架（Zhang等，2021；Morcego等，2023）。与MPC相比，RL通过与仿真模型的多次交互离线学习（近）最优控制策略。这使其能够在训练期间使用随机仿真学习不确定性如何影响控制性能，而无需实时优化。

然而，没有标准化的仿真环境来基准化温室生产控制中基于RL的控制方法。没有标准化基准，很难评估基于RL的温室控制方法的进展并确定它们应该发展的方向。早期研究将RL应用于简化的基于过程的温室模型（Morcego等，2023），但这些模型与当今高科技温室的动态不匹配。其他研究使用高保真温室仿真器KASPRO来识别温室模型并使用基于模型的强化学习学习控制器（Zhang等，2021；Cao等，2022）。尽管KASPRO准确建模了真实世界的温室动态（De Zwart，1996），但其闭源性质使其不适合作为标准化RL基准环境。

几个高保真仿真模型提高了开源温室模型的准确性（Altes-Buch等，2019；Katzin等，2020；Qiu，2024）。然而，这种更高的保真度以仿真速度为代价，这阻碍了训练数据密集型RL控制器。此外，这些开源仿真模型缺乏多样化训练数据的灵活性，这是防止RL过拟合所必需的（Kirk等，2023）。训练数据多样性可以通过添加参数不确定性来实现，导致随机化模型动态。或者通过呈现来自广泛气候范围的天气轨迹。同样重要的是，现有温室仿真器在计算速度、开源和灵活性方面面临挑战，尽管这些是RL基准训练环境的基本要素。

本工作通过引入GreenLight-Gym来解决这些挑战，这是一个用于基准化温室作物生产系统基于RL的控制方法的新开源仿真环境。GreenLight-Gym使用CasADi框架（Andersson等，2019）在Python和C++中重新实现了最先进的温室模型GreenLight（Katzin等，2020）。CasADi显著加快了GreenLight的仿真速度，促进了基于RL的控制器的快速开发。GreenLight-Gym配备了模块化Python环境包装器，可以为用户提供定义训练环境的灵活性。例如，通过随机化GreenLight的模型参数或天气轨迹。这种特性有利于开发展示对未见温室环境泛化能力的基于RL的控制器。

本文介绍了GreenLight-Gym作为温室生产的开源RL基准，将其计算效率与现有GreenLight实现进行比较。然后我们通过在参数不确定性下训练两个著名的RL控制器来演示其使用。第2节描述了GreenLight-Gym的实现和模块化组件，第3节使用GreenLight-Gym形式化RL框架，第4.2节概述了仿真实验，第5节呈现了结果。在此初始发布之后，计划进一步扩展GreenLight-Gym。本文通过概述开发路线图来结束。

# 2. GREENLIGHT-GYM

GreenLight-Gym的设计考虑了以下独特特性：(1) 高仿真速度，以便在高保真温室模型上快速开发基于RL的控制器，以及(2) 模块化，使用户能够完全控制温室仿真设置，促进可重现和可比较的仿真研究。图1概述了GreenLight-Gym的架构，说明了控制器如何与仿真模型交互。本节的其余部分详细介绍了GreenLight模型、环境包装器和控制器的实现。

# 2.1 GreenLight模型

GreenLight-Gym基于GreenLight构建，这是一个用于高科技温室设施生产仿真的最先进的基于过程的温室模型(Katzin等，2020)。该模型通过扩展Vanthoor等(2011b)气候模型并采用Vanthoor等(2011a)番茄产量模型的简化版本，整合了补充照明以捕捉其对温室气候和作物的影响。由于GreenLight没有建模现实的能源管理系统——通常包括热电联产机组、锅炉和热缓冲器——本工作假设能源和CO₂等资源直接从市场购买。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0227_Laatum%20%E7%AD%89%20-%202025%20-%20GreenLight-gym%20reinforcement/images/a5a15538ab3e5b98f85609a9e31890b3565b6f195ec2c3626e8ea2f59af31537.jpg?raw=true)
  
图1. GreenLight-Gym的架构。控制器生成动作$a$，该动作被应用到GreenLight-Gym仿真环境。下一个状态$x$使用基于CasADi的实现计算，该实现仿真温室动态，整合可控输入和外部干扰。结果状态用于计算奖励函数并更新控制器。

非线性模型已被离散化并以标准化状态空间形式编写：

$$
x _ { k + 1 } = f ( x _ { k } , u _ { k } , d _ { k } , p ) ,
$$

其中$k \in \mathbb { Z } ^ { \geq 0 }$表示离散时间步，$x \in \mathbb { R } ^ { 2 8 }$是温室模型的状态，由室内气候和作物变量组成，$u ~ \in ~ \mathbb { R } ^ { 8 }$是影响室内气候的可控输入，$d \in \mathbb { R } ^ { 1 0 }$是不可控输入，即天气干扰，$p \in \mathbb { R } ^ { 2 0 8 }$表示模型参数。有关详细模型描述，请参考(Katzin等，2020)。

GreenLight模型已使用CasADi(Andersson等，2019)的符号框架在C++中实现。CasADi支持隐式数值积分方法和自动微分来近似连续模型动态。因此，编译后，CasADi可以通过简单的函数评估而不是密集的近似方法来计算雅可比矩阵的值。此外，GreenLight-Gym环境使用CasADi的即时(JIT)编译功能。JIT编译将离散时间模型(1)转换为高效的C代码，在计算性能方面提供显著提升。GreenLight-Gym提供接口从Python调用JIT编译的模型函数，输入(非)可控输入和模型参数，然后返回下一个时间步的状态。

# 2.2 环境

GreenLight-Gym环境被组织成不同的模块，以保持灵活和模块化的软件。这使用户能够完全控制仿真特性，允许他们多样化训练环境并重现和比较基于RL的控制方法。

天气 天气模块设计用于整合来自不同年份和地理位置的天气数据。此功能能够生成固定的基准环境，以在可比较的天气条件下断言控制性能。此外，它促进研究以研究RL控制器跨地理位置的泛化能力。

参数 GreenLight-Gym包括用户可配置的模型参数，能够指定各种温室结构和番茄作物品种。这允许温室控制社区在多样化温室和番茄物种中基准化性能。此外，在训练期间跨不同作物参数多样化模型参数可以减轻不确定性并增强向真实世界温室的转移(Kirk等，2023)。

观测模型 GreenLight-Gym提供观测模型的模块化配置。几种观测类型包括室内气候和作物状态、控制输入、时间、室外气候和天气预报。观测的这种模块化设计允许用户定义温室控制问题，其中RL控制器输入匹配真实世界温室传感器和测量。此外，该模块使用户能够将额外信息编码在观测空间中，作为模型状态$x$、控制输入$u$、干扰输入$d$和模型参数$p$的函数。

奖励 此模块允许用户在实值奖励函数中编码期望目标，平衡控制成本与作物生长效益，同时惩罚不利状态。温室生产控制中模型与真实世界系统之间的不匹配可能在纯粹关注盈利能力时在不利状态下产生高奖励。例如，当忽略极端湿度浓度对作物产量和质量的负面影响时。GreenLight-Gym的奖励模块促进奖励函数设计，通过组合一个或多个奖励组件来编码期望的控制器行为，这些组件为特定状态下的动作分配即时值。

# 2.3 控制器

GreenLight-Gym内的控制器模块设计用于支持基于RL和基于规则的控制器。此设计允许用户实现和评估不同类型的控制器，为测试和比较提供标准化框架。

基于RL的控制器使用Stable Baselines3库(Raffin等，2021)实现。GreenLight-Gym包含两种著名的RL算法：近端策略优化(PPO)和软演员评论家(SAC)，但用户也可以使用Stable Baselines3自定义RL算法。所有算法的超参数都可以在YAML配置文件中指定。此外，使用Weights and Biases平台支持超参数扫描¹

此外，实现基于规则的控制器允许用户编码一般种植者控制策略。这些基于规则的控制器可以作为基于RL控制器的基线。以下关键点，源自(Katzin等，2021)，描述了实现的基于规则的控制器：灯($u _ { \mathrm { l a m p } }$)在00:00-18:00之间开启，除非室外辐射超过$4 0 0 ~ \mathrm { ~ W ~ } ~ \mathrm { m } ^ { - 2 }$，或预测的室外全球太阳辐射日总和超过10 MJ $\mathrm { ~ J ~ m ~ } ^ { - 2 } \mathrm { ~ d ~ } ^ { - 1 }$。CO₂($\boldsymbol { \left\lfloor u _ { \mathrm { C O _ { 2 } } } \right. }$)在光照期间每当浓度降至800 ppm以下时注入(P控制)。加热($\boldsymbol { \mathit { u } } _ { \mathrm { b o i l . } }$)在室内温度降至目标设定点以下时应用，光照期间为$1 9 . 5 ^ { \circ } \mathrm { C }$或黑暗期间为$1 6 . 5 ^ { \circ } \mathrm { C }$(P控制)。屋顶通风窗($u _ { \mathrm { v e n t } }$)在室内温度比目标设定点高$5 \mathrm { ^ \circ C }$或室内相对湿度超过$8 5 \%$时打开。如果室内温度比目标设定点低1 $^ { \circ } \mathrm { C }$，则通风口关闭(两者都是P控制)。热屏($\left( u _ { \mathrm { t h S c r } } \right)$)在白天室外温度低于$5 ^ { \circ }$C和夜间低于$1 0 ^ { \circ } \mathrm { C }$时关闭。如果室内温度比目标设定点高4°C或室内相对湿度超过$8 5 \%$，则屏幕打开。遮光屏($u _ { \mathrm { b l S c r } }$)在黑暗期间灯亮时关闭。如果需要，这些控制规则可以在可配置的YAML文件中更改。

后续部分使用后一节介绍的组件形式化温室控制问题的RL框架。

# 3. 温室生产控制的强化学习

# 3.1 RL 公式化

我们采用基于RL的控制器通过操纵气候执行器来优化温室生产。控制器架构由参数化深度神经网络$(\pi_{\boldsymbol{\theta}})$表示，它将观测值$y_k$映射到动作$a_k$。GreenLight-Gym执行器模块将此动作映射到控制输入$u_k$并查询GreenLight模型来计算系统的下一个状态$x_k$。最后，状态用于计算以下观测值和奖励$r_k$，两者都被RL用来优化其参数化控制器$\pi_{\theta}$。

以下方程估计系统的下一个状态和观测值：

$$
\begin{array}{r}
{\hat{x}_{k+1} = f(\hat{x}_k, u_k, d_k, \hat{p}_k)} \\
{\hat{y}_k = g(\hat{x}_k, u_k, d_k, \hat{p}_k),}
\end{array}
$$

其中非线性$f(\cdot)$函数及其输入参数与(1)中类似定义。$g(\cdot)$表示用户定义的观测模型，参见第2.2小节。ˆ操作符表示该变量是真实变量的估计值。

本研究使用$\hat{p}_k$来表示随机参数变量并将其定义为：

$$
\hat{p}_k = \mu_p(1 + \epsilon), \qquad \epsilon \sim \mathcal{U}(-\delta, \delta),
$$

其中$\mu_p$表示标称参数值，$\epsilon$遵循给定的均匀分布，其中$\delta \in [0,1)$表示不确定性范围。使得$\hat{p} \in [\mu_p(1-\delta), \mu_p(1+\delta)]$，且$\mathbb{E}[\hat{p}] = \mu_p$确保参数值为正。

此外，控制器接收自定义奖励$r_k$。此奖励是一个数值反馈信号，指示先前观测状态下动作在期望结果方面的表现如何。RL的目标是找到一个（接近）最优的控制器，使期望累积奖励随时间最大化：

$$
\pi_{\theta}^* = \arg \operatorname*{max}_{\theta} J(\theta) = \mathbb{E}_{\tau \sim \rho(\tau|\pi_{\theta}, \hat{p})} \left[\sum_{k=0}^{\infty} \gamma^k r_k(y_k, u_k)\right],
$$

其中$\pi_{\theta}^*$表示最优控制器，$\gamma \in [0,1]$对未来奖励进行折扣。轨迹$\tau$表示状态和控制的可行序列：$(x_0, u_0, \ldots, x_N, u_N)$。$\tau \sim \rho(\tau|\pi_{\boldsymbol{\theta}}, \hat{p})$表示给定控制器$\pi_{\pmb{\theta}}$和采样参数$\hat{p}$的轨迹$\tau$的分布。

# 3.2 奖励函数

温室作物生产控制的目标是在满足系统约束的同时最大化温室的运营回报，即经济性能指标(EPI)。由于强化学习本身不处理状态约束，这些约束被编码在奖励函数中。因此，该函数由两个组件组成：编码EPI和惩罚约束违反。

EPI由番茄果实生长驱动的收入减去资源消耗来定义，资源消耗来自锅炉激活、CO₂注入和开灯。EPI奖励函数表示为：

$$
\begin{array} { r l } & { r _ { k } ^ { \mathrm { E P I } } ( y _ { k } , u _ { k } ) = } \\ & { c _ { \mathrm { f r t } } \Delta y _ { k , \mathrm { f r t } } - r ( c _ { \mathrm { C O _ { 2 } } } u _ { k , \mathrm { C O _ { 2 } } } + c _ { \mathrm { b o i l } } u _ { k , \mathrm { b o i l } } + c _ { \mathrm { l a m p } } u _ { k , \mathrm { l a m p } } ) , } \end{array}
$$

其中$\Delta y _ { k , \mathrm { f r t } }$表示上一个时间步的增量果实生长，$u _ { k , i }$表示执行器$i$的资源消耗。成本系数$c _ { i }$为CO₂注入、锅炉激活和照明定义。管理$u _ { \mathrm { t h S c r } }$、$u _ { \mathrm { v e n t } }$、$u _ { \mathrm { b l S c r } }$的电力成本可以忽略不计，因此在EPI奖励函数中故意省略。

状态约束通过线性惩罚函数编码。线性惩罚函数定义如下：

$$
r _ { k } ^ { \mathrm { p e n } } ( y _ { k } ) = \sum _ { i } ^ { N _ { c s } } P _ { k , i } ( y _ { k , i } ) ,
$$

其中$P _ { k , i }$表示时间步$k$时状态变量$i$的惩罚值，$N _ { c s }$表示状态约束的数量。惩罚值正式表示为：

$$
\begin{array} { r } { P _ { k , i } ( y _ { k , i } ) = \left\{ \begin{array} { l l } { y _ { k , i } - y _ { \operatorname* { m a x } , i } } & { \mathrm { i f ~ } y _ { k , i } > y _ { \operatorname* { m a x } , i } , } \\ { y _ { \operatorname* { m i n } , i } - y _ { k , i } } & { \mathrm { i f ~ } y _ { k , i } < y _ { \operatorname* { m i n } , i } , } \\ { 0 } & { \mathrm { o t h e r w i s e } . } \end{array} \right. } \end{array}
$$

最终奖励将EPI奖励和线性惩罚函数组合如下：

$$
r _ { k } ( y _ { k } , u _ { k } ) = r _ { k } ^ { \mathrm { E P I } } ( y _ { k } , u _ { k } ) - r _ { k } ^ { \mathrm { p e n } } ( y _ { k } ) .
$$

EPI奖励在$[ 0 , 1 ]$之间缩放以稳定学习过程。最小值定义为无收获和最大资源消耗。在不使用资源的情况下获得最大可能收获定义了最大值。此外，为了防止惩罚值在(4)中主导累积奖励估计，每个惩罚值$P _ { k , i }$在$[ 0 , 1 ]$之间进行最小-最大缩放。每个$P _ { k , i }$的最小值和最大值是手动确定的。

# 4. 仿真方法

本研究进行了两个仿真实验，展示了GreenLight-Gym在加速仿真、基准测试强化学习控制器和处理参数不确定性方面的能力。首先，将GreenLight-Gym的仿真速度与GreenLight的两种实现进行比较。其次，使用两种著名的强化学习算法PPO和SAC在参数不确定性下训练控制器。这些控制器与GreenLight-Gym中实现的基于规则的基线进行基准测试。

# 4.1 仿真速度

由于加速仿真速度是强化学习训练的关键特性，将GreenLight-Gym的执行时间与GreenLight的原始实现（GL-Matlab）和Python中的最新GreenLight实现（GL-Python）进行了比较（Katzin等，2020；Qiu，2024）。使用配备12核Intel(R) Xeon(R) W-2133 CPU（最高3.60GHz）的台式机评估仿真速度。所有三种实现都使用了来自先前验证实验的相同天气扰动$d$和控制输入$u$（Katzin等，2020）。每次仿真跨越10个生长日，从2009年10月开始。(1)中的时间离散模型的步长为$\Delta t = 300(\mathrm{s})$。对于每次仿真运行，计算每秒步数。

# 4.2 参数不确定性下的温室生产控制强化学习

GreenLight-Gym提供了一种用户友好的方法，使用两种现成的强化学习算法PPO和SAC在具有挑战性的温室控制问题上训练控制器。本仿真实验测试了作物模型参数变化引起的不确定性对基于强化学习的控制器性能的影响。基于强化学习的控制器使用Stable Baselines3进行训练。为了比较目的，仿真了基于规则的基线控制器。控制器的目标是在60个连续天内最大化EPI同时最小化状态约束违反。

基于强化学习的控制器尝试用随机作物参数值解决(4)中制定的优化问题。在训练期间，通过从(3)中定义的分布采样$\epsilon$，使用(3)在每个时间步随机化28个作物参数。其他模型参数值等于$\mu_p$。分析了七个不确定性值$(\delta)$，范围从标称作物参数值的$0\%$到$30\%$。奖励函数$r_k$按(7)定义。使用以下价格参数：$c_{\mathrm{frt}} = 1.6 \in \mathrm{kg/m}^2$，$c_{\mathrm{CO_2}} = 0.3 \in \mathrm{kg/m}^2$，$c_{\mathrm{boil}} = 0.09 \notin \mathrm{W/m^2}$，$c_{\mathrm{lamp}} = 0.3 \in \mathrm{W/m^2}$。三个室内气候变量（温度；$\mathrm{CO_2}$浓度；相对湿度）的约束定义为：

$$
y_{\operatorname*{min}} = {(15 \quad 300 \quad 50)}^{\mathrm{T}}, y_{\operatorname*{max}} = {(34 \quad 1600 \quad 85)}^{\mathrm{T}}
$$

控制器被训练控制六个操纵室内气候的输入：$u_{\mathrm{boil}}$、$u_{\mathrm{CO_2}}$、$u_{\mathrm{thScr}}$、$u_{\mathrm{vent}}$、$u_{\mathrm{lamp}}$和$u_{\mathrm{blScr}}$，使用以下边界：

$$
u_{\operatorname*{min}} = \left(0 \quad 0 \quad 0 \quad 0 \quad 0 \quad 0\right)^{\mathrm{T}}, u_{\operatorname*{max}} = \left(130 \quad 5.0 \quad 1 \quad 1 \quad 116 \quad 1\right)^{\mathrm{T}}
$$

表1列出了控制器输入。

使用的天气轨迹$d$跨越2010年3月1日至4月30日，记录于史基浦机场。天气在训练和测试期间保持固定。虽然这种天气场景不能反映现实世界的变异性，但它展示了GreenLight-Gym在开发各种基于强化学习的控制器方面的能力。未来工作应该解决对新天气轨迹的泛化问题。PPO和SAC使用独立的神经网络训练actor和critic，每个网络由具有三个隐藏层的多层感知器（MLP）组成。Actor网络使用256个节点，而critic有512个。算法的超参数通过随机搜索确定。表2总结了超参数值。未报告的超参数使用Stable Baselines3的默认值。

表1. 控制器的观测输入。

| 符号 | 描述 | 单位 |
|------|------|------|
| yT | 空气温度 | ℃ |
| ycO2 | CO2浓度 | ppm |
| yRH | 相对湿度 | % |
| YtPipe | 管道温度 | ℃ |
| YCFrt | 果实干重 | kg/m² |
| Yt24Crop | 日平均冠层温度 | ℃ |
| YtCanSum | 冠层温度总和 | ℃ |
| yHoursin,cos | 一天中编码的小时数 | - |
| YDaysin,cos | 一年中编码的天数 | - |
| Uboil | 锅炉激活 | W/m² |
| uCO2 | CO2注入 | mg/m |
| UthScr | 热屏关闭 | - |
| Uvent | 屋顶通风开口 | - |
| ulamp | 灯具电输入 | W/m² |
| UblScr | 遮光屏关闭 | - |
| diGlob | 全球辐射 | W/m² |
| dT | 室外温度 | ℃ |
| dRH | 室外相对湿度 | % |
| dco2 | 室外CO2浓度 | ppm |
| dwind | 风速 | m/s |

累积奖励 $\textstyle \sum _ { k = 0 } ^ { N } r _ { k } ( y _ { k } , u _ { k } )$、累积EPI $\begin{array} { r } { \sum _ { k = 0 } ^ { N } r _ { k } ^ { \mathrm { E P I } } ( y _ { k } , u _ { k } ) } \end{array}$和累积惩罚 $\begin{array} { r } { \sum _ { k = 0 } ^ { N } r _ { \perp } ^ { \mathrm { p e n } } ( y _ { k } , u _ { k } ) } \end{array}$通过30次仿真运行的平均值进行评估，以考虑参数不确定性导致的结果变异性。

# 5. 仿真结果与讨论

# 5.1 仿真速度

GreenLight-Gym在仿真速度方面相比GreenLight的其他实现显示出显著改进。GreenLight-Gym在单个CPU核心上每秒可仿真超过1800步，相比基于Matlab和基于Python的GreenLight实现分别提供约24倍和17倍的加速。这使得在十分钟内收集超过一百万个数据点成为可能。GreenLight-Gym的实现已针对原始Matlab代码进行了验证，可根据要求提供。

表2. PPO和SAC的超参数。缩写：fn = 函数，Ent coef = 熵系数，VF = 价值函数。

| 超参数 | PPO | SAC |
|--------|-----|-----|
| 总时间步数 | 2M | 2M |
| 学习率(α) | 128 | 7×10-4 |
| 批次大小 | 0.9631 | 128 |
| 折扣因子 | SiLU | 0.9631 |
| 激活函数 | 2×10-5 | SiLU |
| nepochs | 2048 | 1 |
| GAEX | 8 | 1 |
| 裁剪范围 | 0.9167 | - |
| 熵系数 | 0.2 | - |
| VF系数 | 0.05434 | - |
| nsteps | 0.8225 | - |
| 缓冲区大小 | - | 576.1K |
| 学习开始 | - | 57.6K |
| Polyak系数(τ) | - | 0.0135 |
| 训练频率 | - | 50 |
| 梯度步数 | - | 10 |

# 5.2 温室生产控制的强化学习

图2.a展示了在参数化作物模型不确定性下控制器的性能表现。基于强化学习的控制器在整个不确定性值范围内都优于基于规则的基线控制器。引入高达10%的不确定性改善了所有三个控制器的性能，这可能是由于有益的参数变化导致作物生长增加。在这些低不确定性水平下，增加的EPI反映了这一发现。这种效应在进一步增加不确定性后下降，性能趋势也随之降低。

尽管在图2.b中观察到EPI下降，但在更高的噪声水平下，PPO和SAC在整个不确定性范围内都保持在零以上。相比之下，基于规则的基线从约-5€/m²开始，并逐渐变得更差。这些结果表明，学习到的控制器能够在参数不确定性增加的情况下更好地维持积极的经济性能，而固定的基于规则策略则遭受性能下降。EPI方面的表现不佳可能是由于电力成本高昂。强化学习控制器有效地学习到补充照明的高电力成本超过了其收入效益，因此最小化了其使用。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0227_Laatum%20%E7%AD%89%20-%202025%20-%20GreenLight-gym%20reinforcement/images/f6469413af37cbf11cded61ffaf072251fce9adc5b63605378fc92359855473c.jpg?raw=true)
  
图2. 参数不确定性下的控制器性能。PPO、SAC和基于规则(RB)控制器在不同参数不确定性水平下的平均性能指标，基于30次仿真运行的平均值。

随机化作物模型参数对两种基于强化学习的控制器的状态约束违反惩罚影响较小。PPO和SAC的累积惩罚在整个不确定性范围内几乎没有波动。作物参数对气候动态的有限影响可以解释这些结果。基于规则的基线报告了显著更高的状态约束违反惩罚。这可能是由于打开屋顶通风对湿度的延迟效应造成的。相反，强化学习控制器可以处理这些延迟响应。调整第2.3小节的控制规则将产生更具竞争力的基线。

报告的控制器性能应被解释为上限，因为假设了准确的输入测量和天气轨迹的完整知识。此外，模型的简化动态可能无法完全捕捉现实世界温室系统的复杂性。然而，使用GreenLight-Gym在其他复杂温室控制任务中研究先进控制方法可以支持将这些发现转移到这些系统中。总体而言，两种基于强化学习的控制器都优于基于规则的方法，突出了它们在各种不确定性程度下保持性能的鲁棒性。

# 6. 结论与未来工作

本工作提出了GreenLight-Gym作为开发温室生产系统基于强化学习控制器的基准环境。该环境将仿真速度比原始GreenLight实现提高了17倍。此外，环境的模块化实现便于定制温室仿真和强化学习控制器设置。通过评估参数不确定性下的强化学习控制器性能并将其与基于规则的基线进行比较，证明了其作为基准环境的灵活性。GreenLight-Gym的开源实现旨在刺激温室系统创新强化学习控制方法的发展。

未来工作可以朝两个方向发展：扩展环境或开发更先进的温室控制方法。潜在的GreenLight-Gym扩展包括但不限于：添加不同的作物模型物种以开发可转移到不同作物的通用强化学习控制器；集成更现实的能源管理系统以更好地反映现实世界的温室操作；包括温室作物的照片级真实感图像生成模型以为基于强化学习的控制器添加形态学信息。

未来研究可以包括MPC公式化以作为强化学习的更先进基线，或研究强化学习和MPC的集成。此外，进一步的仿真研究可以断言强化学习对来自未见天气轨迹、传感器不准确性或建模误差的不确定性的鲁棒性。

# 参考文献

Altes-Buch, Q., Quoilin, S., and Lemort, V. (2019). 温室：用于温室气候和能源系统仿真的Modelica库。在第13届国际Modelica会议上，德国雷根斯堡，2019年3月4-6日，533-542页。   
Andersson, J., Gillis, J., Horn, G., Rawlings, J.B., and Diehl, M. (2019). CasADi：非线性优化和最优控制的软件框架。数学规划计算，11(1)，1-36。   
Boersma, S., Sun, C., and Van Mourik, S. (2022). 具有参数不确定性的温室系统鲁棒基于样本的模型预测控制。IFAC论文集在线，55(32)，177-182。   
Cao, X., Yao, Y., Li, L., Zhang, W., An, Z., Zhang, Z., Xiao, L., Guo, S., Cao, X., Wu, M., and Luo, D. (2022). IGrow：自主温室控制的智能农业解决方案。   
De Zwart, H. (1996). 使用仿真模型分析温室栽培中的节能选项。博士论文，农业大学。   
Fu, J., Jian, Y., Wang, X., Li, L., Ciais, P., Zscheischler, J., Wang, Y., Tang, Y., Müller, C., Webber, H., Yang, B., Wu, Y., Wang, Q., Cui, X., Huang, W., Liu, Y., Zhao, P., Piao, S., and Zhou, F. (2023). 极端降雨在过去二十年中减少了中国水稻产量的十二分之一。自然食品，4(5)，416-426。   
Katzin, D., Marcelis, L.F.M., and Van Mourik, S. (2021). 通过从高压钠灯转向LED照明实现温室节能。应用能源，281，116019。   
Katzin, D., Van Mourik, S., Kempkes, F., and Van Henten, E.J. (2020). GreenLight – 具有补充照明的温室开源模型：LED和HPS灯下热需求评估。生物系统工程，194，61-81。   
Kirk, R., Zhang, A., Grefenstette, E., and Rocktäschel, T. (2023). 深度强化学习中零样本泛化的调查。人工智能研究杂志，76，201-264。   
Kuijpers, W.J., Antunes, D.J., Van Mourik, S., Van Henten, E.J., and Van De Molengraft, M.J. (2022). 天气预报误差建模和自动温室气候控制性能分析。生物系统工程，214，207-229。   
Morcego, B., Yin, W., Boersma, S., Van Henten, E., Puig, V., and Sun, C. (2023). 温室气候控制中的强化学习与模型预测控制。计算机与农业电子，215，108372。   
Qiu, D. (2024). GreenLightPlus。网址 https://github.com/greenpeer/GreenLightPlus/tree/main。   
Raffin, A., Hill, A., Gleave, A., Kanervisto, A., Ernestus, M., and Dormann, N. (2021). Stable-baselines3：可靠的强化学习实现。机器学习研究杂志，22(268)，1-8。   
Sparks, D, B. (2018). 温室行业的劳动力现状如何？   
Stanghellini, C., Van 'T Ooster, B., and Heuvelink, E. (2019). 温室园艺：最佳作物生产技术。瓦赫宁根学术出版社，荷兰。doi:10.3920/978-90-8686-879-7。   
Van Henten, E. (1994). 温室气候管理：最优控制方法。博士论文，农业大学。   
Van Straten, G., Van Willigenburg, G., Van Henten, E., and Van Ooteghem, R. (2010). 温室栽培的最优控制。CRC出版社，第0版。   
Vanthoor, B., De Visser, P., Stanghellini, C., and Van Henten, E. (2011a). 基于模型的温室设计方法：第2部分，番茄产量模型的描述和验证。生物系统工程，110(4)，378-395。   
Vanthoor, B., Stanghellini, C., Van Henten, E., and De Visser, P. (2011b). 基于模型的温室设计方法：第1部分，番茄产量模型的描述和验证。生物系统工程，110(4)，378-395。
Zhang, W., Cao, X., Yao, Y., An, Z., Xiao, X., and Luo, D. (2021). 自主温室控制的鲁棒基于模型的强化学习。

# REFERENCES

Altes-Buch, Q., Quoilin, S., and Lemort, V. (2019). Greenhouses: A Modelica library for the simulation of greenhouse climate and energy systems. In The 13th International Modelica Conference, Regensburg, Germany, March 4–6, 2019, 533–542.   
Andersson, J., Gillis, J., Horn, G., Rawlings, J.B., and Diehl, M. (2019). CasADi: A software framework for nonlinear optimization and optimal control. Mathematical Programming Computation, 11(1), 1–36.   
Boersma, S., Sun, C., and Van Mourik, S. (2022). Robust sample-based model predictive control of a greenhouse system with parametric uncertainty. IFACPapersOnLine, 55(32), 177–182.   
Cao, X., Yao, Y., Li, L., Zhang, W., An, Z., Zhang, Z., Xiao, L., Guo, S., Cao, X., Wu, M., and Luo, D. (2022). IGrow: A smart agriculture solution to autonomous greenhouse control.   
De Zwart, H. (1996). Analyzing Energy-Saving Options in Greenhouse Cultivation Using a Simulation Model. Ph.D. thesis, Agricultural University.   
Fu, J., Jian, Y., Wang, X., Li, L., Ciais, P., Zscheischler, J., Wang, Y., Tang, Y., Mu¨ller, C., Webber, H., Yang, B., Wu, Y., Wang, Q., Cui, X., Huang, W., Liu, Y., Zhao, P., Piao, S., and Zhou, F. (2023). Extreme rainfall reduces one-twelfth of China’s rice yield over the last two decades. Nature Food, 4(5), 416–426.   
Katzin, D., Marcelis, L.F.M., and Van Mourik, S. (2021). Energy savings in greenhouses by transition from highpressure sodium to LED lighting. Applied Energy, 281, 116019.   
Katzin, D., Van Mourik, S., Kempkes, F., and Van Henten, E.J. (2020). GreenLight – An open source model for greenhouses with supplemental lighting: Evaluation of heat requirements under LED and HPS lamps. Biosystems Engineering, 194, 61–81.   
Kirk, R., Zhang, A., Grefenstette, E., and Rockt¨aschel, T. (2023). A survey of zero-shot generalisation in deep reinforcement learning. Journal of Artificial Intelligence Research, 76, 201–264.   
Kuijpers, W.J., Antunes, D.J., Van Mourik, S., Van Henten, E.J., and Van De Molengraft, M.J. (2022). Weather forecast error modelling and performance analysis of automatic greenhouse climate control. Biosystems Engineering, 214, 207–229.   
Morcego, B., Yin, W., Boersma, S., Van Henten, E., Puig, V., and Sun, C. (2023). Reinforcement learning versus model predictive control on greenhouse climate control. Computers and Electronics in Agriculture, 215, 108372.   
Qiu, D. (2024). GreenLightPlus. URL https://github. com/greenpeer/GreenLightPlus/tree/main.   
Raffin, A., Hill, A., Gleave, A., Kanervisto, A., Ernestus, M., and Dormann, N. (2021). Stable-baselines3: Reliable reinforcement learning implementations. Journal of Machine Learning Research, 22(268), 1–8.   
Sparks, D, B. (2018). What is the current state of labor in the greenhouse Industry?   
Stanghellini, C., Van ’T Ooster, B., and Heuvelink, E. (2019). Greenhouse horticulture: Technology for optimal crop production. Wageningen Academic Publishers, The Netherlands. doi:10.3920/978-90-8686-879-7.   
Van Henten, E. (1994). Greenhouse climate management : an optimal control approach. Ph.D. thesis, Agricultural University.   
Van Straten, G., Van Willigenburg, G., Van Henten, E., and Van Ooteghem, R. (2010). Optimal control of greenhouse cultivation. CRC Press, 0 edition.   
Vanthoor, B., De Visser, P., Stanghellini, C., and Van Henten, E. (2011a). A methodology for model-based greenhouse design: Part 2, description and validation of a tomato yield model. Biosystems Engineering, 110(4), 378–395.   
Vanthoor, B., Stanghellini, C., Van Henten, E., and De Visser, P. (2011b). A methodology for model-based greenhouse design: Part 1, description and validation of a tomato yield model. Biosystems Engineering, 110(4), 378–395.
Zhang, W., Cao, X., Yao, Y., An, Z., Xiao, X., and Luo, D. (2021). Robust model-based reinforcement learning for autonomous greenhouse control.



