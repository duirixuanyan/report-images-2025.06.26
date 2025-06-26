# Model-Based Design of Protected Cultivation Systems – First Results and Remaining Challenges

# 基于模型的保护地栽培系统设计 - 初步成果与未来挑战

E.J. van Henten1, 2, a, B. Vanthoor1,3, C. Stanghellini2, P.H.B. de Visser2 and S. Hemming2 1Farm Technology Group, Wageningen University, P.O. Box 317, 6700 AH Wageningen, The Netherlands   
2Wageningen UR Greenhouse Horticulture, P.O. Box 16, 6700 AA Wageningen, The Netherlands   
3HortMaX B.V., Pijnacker, The Netherlands

关键词: 敏感性分析, 优化

# 摘要

保护地栽培系统作为作物生产的强大工具在全球范围内得到广泛应用。它们保护作物免受不利的室外气候条件和病虫害的影响，并提供了调节室内气候的机会，以创造最优的作物生长和生产环境，无论是在质量还是数量方面。对当前使用的保护地栽培系统的快速扫描显示，世界各地存在多种多样的保护地栽培系统。从中国带有厚实储能墙的完全被动式"太阳能温室"到西欧的高科技"封闭式温室"，这种多样性源于当地条件，包括当地气候、水资源、能源、资本、劳动力和材料等资源的可获得性，以及当地立法和社会因素等。本文提出了一种基于模型的保护地栽培系统设计方法，将报告初步成果以及未来研究方向。

# 引言

保护地栽培系统作为作物生产的强大工具在全球范围内得到广泛应用。它们保护作物免受不利的室外气候条件和病虫害的影响，并提供了调节室内气候的机会，以创造最优的作物生长和生产环境，无论是在质量还是数量方面。

如图1所示，对全球使用的保护地栽培系统的快速扫描显示，已经发展出了广泛多样的保护地栽培系统。从低技术、低成本的塑料隧道到西欧和北美使用的高科技昂贵玻璃温室。温室在大小、形状和使用的材料上各不相同，从覆盖塑料的Quonset型单跨结构到带有玻璃覆盖的多跨温室。设备范围从无加热温室到具有计算机控制加热、自然通风、CO2供应和人工照明的生产系统。在荷兰、法国和美国正在进行半封闭温室的全规模实验。作物既在土壤中种植，也在使用滴灌提供水和养分的水培基质中种植。手工劳动在全球范围内普遍使用，但在高科技温室中，最近已经引入了第一批机器人来替代人类劳动。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/226291e0b50b7785a4aed068f006bdb9fb4eae8d8a35de6843673d5ea596d94b.jpg?raw=true)
  
图1. 中国(a)、荷兰(b)、西班牙(c)和沙特阿拉伯(d)的不同温室(Vanthoor, 2011)。

基于Hanan（1998）和Van Heurn与Van der Post（2004），Van Henten等人（2006）列出了决定特定保护地栽培系统选择的一系列因素：

1. 市场规模和区域基础设施，决定了产品销售机会以及运输相关成本。
2. 当地气候，决定了作物生产，从而决定了气候调节的需求以及设备和能源的相关成本，并决定了温室建设，例如取决于风力、雪和冰雹。
3. 用于温室运行和气候调节的燃料和电力的可获得性、类型和成本。
4. 水资源的可获得性和质量。
5. 土壤质量，包括排水性、地下水位、洪水风险和地形。
6. 土地的可获得性和成本，当前和未来的城市化，污染工业的存在和分区限制。
7. 资本的可获得性。
8. 劳动力的可获得性和成本，以及教育水平。
9. 材料、设备和服务的可获得性，决定了保护地栽培系统的结构和设备。
10. 食品安全、化学品残留、化学品对土壤、水和空气的使用和排放方面的立法。

图2直观地展示了当地气候对温室设计的潜在影响。该图显示了三个不同气候区（中国北京、荷兰De Bilt和西班牙Almeria）的月平均室外温度和全球辐射总量。在相对阴暗和寒冷的荷兰气候中，重点应放在高透光率覆盖物和人工光合照明上，加热系统可能是有利可图的。在西班牙相对阳光充足和炎热的气候中，适当的冷却技术可能是有益的。与荷兰相比，中国北京有充足的光照，但生产可能会受益于冬季的加热和夏季的冷却。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/b37fddb57b2f8e6c9417bb78abf23f0d826edd49a3187666770764427ff75320.jpg?raw=true)
  
图2. 三个不同气候区(中国北京、荷兰De Bilt和西班牙Almeria)的月平均室外温度(x轴)和全球辐射总量(y轴)。箭头表示特定气候调节技术可能有益的时间(Vanthoor, 2011)。

当考虑温室设计的现状时，大多数研究都集中在优化特定地点的设计，或者只考虑单一设计参数。然而，对于全球不同气候条件下最佳温室配置的战略决策，Baille（1999）建议，整合物理、生物和经济模型的系统方法是最有前途的。温室设计应作为一个多因素优化问题来处理，依赖于作物经济回报与温室设施建设、维护和运营成本之间的定量权衡（Van Henten等，2006；Vanthoor，2011）。这种方法有三个目标。首先，它为理解特定温室设计的本地发展提供了基础。其次，它可能作为一种识别温室设计新方向的方法。第三，它可以作为一个决策支持系统（DSS），为全球不同地区生成保护地栽培系统的概念设计和管理。

本文描述了基于模型的保护地栽培系统设计方法及其一些结果。它基于Vanthoor等人（2011a，b，c，2012a，b）的工作。到目前为止，使用这种方法已经获得了有希望和有趣的结果，但仍然存在一些有趣的挑战。这些将在本文的最后部分讨论。

显然，温室设计问题可以通过许多不同的方式来解决。本文的目的不是回顾所有这些不同的可能性。本文展示了一种方法，希望通过这样做，能够为温室设计这一广泛领域的其他研究路线提供灵感。

# 基于模型的设计方法

# 模型

图3展示了基于模型的温室设计方法中使用的元素(Vanthoor, 2011; Vanthoor等, 2011a, b, c, 2012a, b)。该方法重点关注了一组有限的设计参数。图中左侧列出的设计参数包括温室结构、覆盖类型、遮阳网、白涂料、保温幕、加热系统、冷却系统和CO2增施。温室气候模型将这些设计参数、室外气候和气候管理(即气候设定值)的影响转化为温室内气候，包括空气和冠层温度、CO2浓度、水蒸气浓度和辐射水平。这些值用于计算作物产量。在本研究中，番茄被用作模型作物。然后使用经济模型计算作物生产的净财务结果，包括该温室设计的投资成本和运营成本。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/2025-06-26_103126.png?raw=true)
  
图3. 基于模型的温室设计方法。左侧显示了可优化的设计参数。温室气候模型、番茄模型和经济模型允许对手工挑选的设计进行经济评估。优化模块允许使用基于群体的优化算法自动生成经济最优设计(经IAgrE许可，复制自Vanthoor et al. (2011a))。  

图4展示了温室气候模型的概况。图中显示了可用于加热、保温、遮阳、冷却、加湿、除湿和CO2增施的不同设计选项。该模型的核心可追溯到Bot(1987)和De Zwart(1996)，并扩展了更多设备和新的关系，例如描述温室自然侧通风的关系。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/12a06b44a0187e582df4816b59bdb77bba1739987f26aeffbd088f8b70b88f83.jpg?raw=true)
  
图4. 温室气候模型(经IAgrE许可，复制自Vanthoor et al. (2011a))。

图5展示了番茄生长模型的结构。光合作用是番茄生长的驱动力。产生的碳水化合物在茎、叶和果实之间分配。该模型主要基于Dayan等(1993)、Seginer等(1994)、Heuvelink(1996)、Marcelis等(1998)和Linker等(2004)的早期作物产量模型，并有一个重要扩展。由于预计新型温室设计可能会使过程进入不利的气候条件，如极低和极高温度，因此在当前模型中加入了基于温度的生长抑制函数。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/714683d7690235100ded6858467f0545b35b764c4ae80459160128af6ea11596.jpg?raw=true)
  
图5. 使用Forrester(1962)建模形式表示的番茄产量模型示意图。方框代表模型的状态变量，阀门是速率变量。虚线表示信息流，实线表示物质流。虚线框代表模型的半状态变量(经IAgrE许可，复制自Vanthoor et al. (2011b))。

由于设计过程完全依赖于数学模型，设计结果将受到模型在广泛条件下描述真实过程特征的能力的强烈影响。因此，模型验证受到了相当多的关注。温室模型使用荷兰温带海洋气候、意大利西西里地中海气候和美国德克萨斯州和亚利桑那州半干旱气候的数据进行了验证。番茄生长模型使用荷兰、西班牙的数据以及Adams在英国进行的次优温度生长实验的数据进行了验证。两个模型都能够在几乎不修改模型参数的情况下很好地描述过程(Vanthoor等, 2011a, b)。

# 设计方法

在当前研究中，使用了三种技术来(手动)分析现有或新颖设计并优化新设计：(1)敏感性分析，(2)情景研究，和(3)数值优化。

1. 敏感性分析。在敏感性分析中，可以研究参数变化对产量和资源使用的影响。评估单个参数的影响可以深入了解参数的相对重要性。如果敏感性高，所考虑的参数可能是设计修改的非常合适的候选者。进行多参数联合敏感性分析可以获得更多见解。一些参数表现出强相关性，它们的联合效应可能比它们对产量和资源使用的单独影响更强。值得注意的是，设计参数一词应从广义上理解。设计参数可以包括明显的参数，如覆盖物的透光率，但也可以包括气候管理中使用的设定值，甚至室外气候也可以被视为设计参数，因为地点的选择也可能是设计师的选择因素，从而对当地气候产生影响。正如Vanthoor(2011c)所展示的，值得研究敏感性函数的汇总值和时间过程。单一汇总值允许比较不同参数的影响。时间过程产生了特定时刻敏感性的有价值信息。这可能表明在作物生产期的特定时刻，设计参数比其他时刻有更大的影响。

2. 情景分析。情景分析旨在从作物产量、资源使用和经济回报的角度评估不同的预定义设计。Vanthoor(2012a)评估了西班牙阿尔梅里亚的一系列温室设计，从现有的低技术设计到具有加热、冷却和CO2增施的更复杂设计。

3. 优化。在这种情况下，图3中所示的优化模块开始工作，旨在在给定的当地环境下得出能产生最佳经济回报的设计参数组合和值。由于设计变量数量通常很大，在时间上枚举所有可能组合是不可行的，需要采用智能数值算法在合理时间内生成接近最优的解决方案。在本研究中，使用了基于群体的受控随机搜索算法(Price, 1977)。如图6所示，温室设计由设计因子表示，指示是否使用了特定设计因子，如果使用，则指示其值。Vanthoor等(2012b)使用50台PC并行解决了荷兰De Bilt和西班牙阿尔梅里亚气候条件下的优化问题。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/4106766da7906d27d6aa98c2f25c5ac0f5f1de28eb2e1165f4751e9a49f7d54f.jpg?raw=true)
  
图6. 将温室设计转换为用于优化的设计向量。(a)每个彩色框代表一个设计元素，可由浅蓝色框中显示的几种替代方案执行。彩色框的右上角显示了完成一个设计元素的替代方案数量。(b)一个整数温室向量的示例(经IAgrE许可，复制自Vanthoor et al. (2012b))。

# 结果

# 敏感性分析

在敏感性分析中，评估了设计参数在两个地点(西班牙阿尔梅里亚和美国德克萨斯州)的单独影响和联合影响(Vanthoor等, 2011c)。图7显示了收获率对PAR(光合有效辐射，400-700 nm)透射系数、NIR(近红外辐射，700-2500 nm)透射系数和FIR(远红外辐射，>2500 nm)发射系数的相对敏感性的时间过程。正值表示参数的正向变化会导致生长速率的增加，反之亦然。首先值得注意的是，敏感性在生长季节期间变化相当显著。其次，这些图表明PAR透射的影响比其他两个设计参数的影响更明显。第三，对于NIR透射和FIR发射，敏感性会改变符号，这意味着在生长期的某些阶段，参数会对收获率产生积极影响，而在其他阶段则会产生负面影响。最后，对于西班牙，PAR透射的敏感性函数在冬季有明显的下降。这与直觉相反，因为人们会认为即使在西班牙，光在那个时候也是一个限制因素。然而，这是由于二次效应。在那个时候，冠层温度是次优的，作物不会从PAR的增加中受益。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/d104fb1e81c56896495067933cc72da10b858149800e88e5ece3c5a32638dbc4.jpg?raw=true)
  
图7. 收获率对以下因素变化的相对敏感性：8月1日至7月1日期间，西班牙Almeria(a)和美国德克萨斯州(b)屋顶的PAR透射系数(实线)、NIR透射系数(虚线)和FIR发射系数(点划线)(经IAgrE许可，复制自Vanthoor et al. (2011c))。

图8显示了CO2增施设定值和通风设定值对作物产量的联合影响。还发现了其他联合效应，例如屋顶的PAR和FIR透射，以及屋顶的PAR透射和通风温度设定值。有趣的是，没有发现屋顶的PAR透射和温室内CO2浓度之间的联合效应。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/76cddbd4a22b9274b36c07fe1d69a12054da5dd230592c9b1b6ca8e47b66f126.jpg?raw=true)
  
图8. 通风温度设定点和CO2富集浓度设定点对美国德克萨斯州作物产量的综合影响(经IAgrE许可，复制自Vanthoor et al. (2011c))。

# 情景研究

在西班牙阿尔梅里亚的情景研究中，比较了标准parral温室与配备白涂料、CO₂增施、雾化、空气加热和热水管道加热组合的多隧道设计的经济回报和资源使用情况(Vanthoor等, 2012a)。研究发现，配备白涂料和雾化系统的多隧道温室最为盈利，紧随其后的是目前使用的parral温室。其他设计的经济回报较低。有趣的是，观察到番茄价格的相对小幅上涨就会使更先进的温室设计在经济上可行。还研究了价格变化和年际室外天气变化的影响。这表明，在高价格不确定性的情况下，低技术温室设计是最佳选择。具有高技术基础设施的温室更适合室外气候条件变化较大的情况。

# 优化

温室优化除了上述模型外，没有使用任何先验知识作为指导。有趣的是，优化产生的西班牙和荷兰的温室设计与这些地区常用的设计非常相似。这表明当地设计至少接近最优，正如人们所期望的那样。或者，这表明优化方法产生了现实的结果。由于优化使用了基于群体的进化方法，因此可以在优化终止时分析结果群体。图9显示了西班牙最终群体中各种设计参数的频率分布，考虑了与最优设计相比净财务结果最多减少0.25€/m²的温室设计。该图告诉我们，在0.25€/m²的范围内，一些设计参数非常明显，例如加热系统和室外遮阳网。对于室内遮阳网，结果更加分散。对于两个地点，结果表明具有更高透光率的结构显著提高了温室性能。在所有情况下，由于相对于1公顷温室面积的高投资，地热能和机械冷却被认为在经济上不可行。

![](https://github.com/duirixuanyan/report-images-2025.06.26/blob/main/0219_Van%20Henten%20et%20al_2012_MODEL-BASED%20DESIGN/images/ea34fed7cb4ae91cf2d94189582f15c11ff091d0d58b3ef2200d5950b7155a8e.jpg?raw=true)
  
图9. 与西班牙最佳温室相比，ΔNFR < 0.25 €·m-2·年-1的设计元素替代方案的频率分布(经IAgrE许可，复制自Vanthoor et al. (2012b))。

# 未来展望

到目前为止，使用这种方法已经获得了有希望的结果，但仍然存在一些有趣的挑战。

# 设计方面

基于Hanan(1998)和Van Heurn与Van der Post(2004)的温室设计选择因素列表清楚地表明，温室的选择和设计比Vanthoor等(2011a, b, c, 2012a, b)目前涵盖的方面更多。

此外，在温室内，设计主要关注温室地上部分的气候和作物关系。水和养分供应被认为是充足的。特别是在水资源稀缺且昂贵的情况下，应该明确考虑这项研究及其在温室内的所有相关方面。在西方社会，获得足够熟练劳动力的可用性正成为一个紧迫的问题。目前，基于模型的设计方法正在扩展到保护地栽培的劳动力方面(Van't Ooster等, 2012)。

尽管该设计工具已经考虑了广泛的设备，但当现有和新仪器出现在市场上时，仍有扩展的空间。例如，这种方法没有考虑含水层中的热量储存。

# 作物

为了建立该方法，番茄被用作模型作物。显然，只要有该作物的数学描述，就可以很容易地扩展到全球种植的许多其他作物，从盆栽植物到水果、蔬菜和花卉。可能不需要对所有作物进行单独建模，而是考虑在生产和环境响应方面具有相似特征的作物组或类别，从而进行设计。除了标准作物外，还值得将这种方法扩展到藻类和鱼类等新型作物。Slager等(2012)已经描述了在温室中联合生产藻类和番茄的初步方法。

# 经济标准

到目前为止，重点是净财务回报。但根据当地条件或利益相关者的兴趣，也可以实施其他绩效标准，包括最大化生产、最小化资源使用、最小化排放(如CO₂)、产品质量和优化土地利用。还可以包括生命周期分析来评估特定温室设计的性能。

# 优化

优化通过将离散值设计向量转换为连续值优化向量，使用受控随机搜索算法解决了问题。在考虑进一步研究时，一些问题是值得关注的。例如，Vanthoor等(2008)表明，同时优化保护地栽培系统的设计和气候控制具有潜在的好处。此外，敏感性分析表明，一些设计参数的敏感性在生长期内变化很大。西班牙PAR覆盖的透射系数就是一个例子。这表明，将设计变量视为连续变化的控制变量可能是值得考虑的。另一个例子是明确使用多目标优化的潜在好处，因为有时很难得出一个统一的绩效标准，特别是如果一个或多个术语难以用金钱明确表达。最后，本文描述的优化主要基于定量数学模型。由于很难在此类模型中捕捉到保护地栽培系统的所有知识，因此值得研究硬定量优化与更多定性启发式知识的混合。

# 不确定性、风险和稳健性

天气和市场价格会影响温室的设计。这是一个众所周知的事实。研究这些因素的变化或不确定性的影响，可能会对设计在这些变化的外部条件下的稳健性产生有价值的见解，并可能作为失败风险的评估。然后，种植者对风险的态度可能会影响温室设计的特定选择。除此之外，其他不确定性如种植者的知识和技能以及温室中的病虫害会影响作物表现，应该包括在整体分析中，这可能会导致不同的温室系统设计。

# 决策支持系统

这种方法的目标之一是在决策支持系统中使用设计方法。如上所述，扩展设计方面的范围，包括更多作物、替代绩效标准，需要注意合适的用户界面。此外，优化所需的计算时间必须大幅减少。在当前形式中，该软件包是用Matlab®编写的。它易于使用，但在执行大量迭代计算时速度明显较慢。将该软件包转换为C#等语言可能会解决这个问题。

# 致谢

本研究是"生态系统、景观、海洋和区域的可持续空间发展"和"可持续农业"战略研究计划的一部分，这两个计划均由荷兰经济、农业和创新部资助。

# 参考文献

Baille, A. 1999. 地中海地区温室气候控制概述. Cahiers Options Méditerranéennes 31:59-76.   
Bot, G.P.A. 1987. 温室气候：从物理过程到动态模型. 博士论文. 瓦赫宁根大学, 荷兰瓦赫宁根.   
Dayan, E., Van Keulen, H., Jones, J.W., Zipori, I., Shmuel, D. and Challa, H. 1993. 温室番茄生长模型的开发、校准和验证：I. 模型描述. Agricultural Systems 4:145-163.   
De Zwart, H.F. 1996. 使用模拟模型分析温室栽培中的节能选项. 博士论文. 瓦赫宁根大学, 荷兰瓦赫宁根.   
Forrester, J.W. 1962. 工业动力学. MIT出版社, 剑桥.   
Hanan, J.J. 1998. 温室：保护栽培的先进技术. CRC出版社, 美国博卡拉顿.   
Heuvelink, E. 1996. 番茄生长与产量：定量分析与综合. 博士论文. 瓦赫宁根大学, 荷兰瓦赫宁根.   
Linker, R., Seginer, I. and Buwalda, F. 2004. 在硝酸盐限制环境中生长的生菜动态模型的描述和校准. Mathematical and Computer Modelling 40:1009-1024.   
Marcelis, L.F.M., Heuvelink, E. and Goudriaan, J. 1998. 园艺作物生物量生产和产量的建模：综述. Scientia Horticulturae 74:83-111.   
Price, W.L. 1977. 一种用于全局优化的受控随机搜索程序. The Computer Journal 20:367-370.   
Seginer, I., Gary, C. and Tchamitchian, M. 1994. 具有碳水化合物库的温室作物的最佳温度制度：建模研究. Scientia Horticulturae 60:55-80.   
Slager, A.A., Sapounas, A.A., van Henten, E.J. and Hemming, S. 2012. 荷兰温室中藻类和番茄联合生产的可行性研究. 提交至ISHS第7届园艺系统光国际研讨会, 荷兰瓦赫宁根.   
Vanthoor, B.H.E. 2011. 基于模型的温室设计方法. 博士论文. 瓦赫宁根大学, 荷兰瓦赫宁根.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2008. 最佳温室设计应考虑最佳气候管理. Acta Hort. 802:97-104.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2011a. 基于模型的温室设计方法：第1部分. 广泛设计和气候条件下的温室气候模型描述和验证. Biosystems Engineering 110:363-377.   
Vanthoor, B.H.E., de Visser, P.H.B., Stanghellini, C. and van Henten, E.J. 2011b. 基于模型的温室设计方法：第2部分, 番茄产量模型的描述和验证. Biosystems Engineering 110:378-395.   
Vanthoor, B.H.E., van Henten, E.J., Stanghellini, C. and de Visser, P.H.B. 2011c. 基于模型的温室设计方法：第3部分, 温室气候-作物产量组合模型的敏感性分析. Biosystems Engineering 110:396- 412.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2012a. 基于模型的温室设计方法：第4部分, 不同温室设计的经济评估：西班牙案例. Biosystems Engineering 111:336-349.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2012b. 基于模型的温室设计方法：第5部分, 西班牙南部和荷兰条件下的温室设计优化. Biosystems Engineering 111:350-368.   
Van Henten, E.J., Bakker, J.C., Marcelis, L.F.M., Van’t Ooster, A., Dekker, E., Stanghellini, C., Vanthoor, B.H.E., Van Randeraat, B. and Westra, J. 2006. 适应性温室 - 开发保护栽培系统的综合系统方法. Acta Hort. 718:399-406.   
Van Heurn, E. and Van der Post, K. 2004. 保护栽培 - 不同气候下温室的建造、要求和使用. Agrodok系列第23号, Agromisa, 荷兰瓦赫宁根.   
Van’t Ooster, A., Bontsema, J., van Henten, E.J. and Hemming, S. 2012. GWorkS - 移动玫瑰栽培系统中作物处理过程的离散事件模拟模型. Biosystems Engineering 112:108-120. 

# Literature Cited

Baille, A. 1999. Overview of greenhouse climate control in the mediterranean regions. Cahiers Options Méditerranéennes 31:59-76.   
Bot, G.P.A. 1987. Greenhouse Climate: From Physical Processes to a Dynamic Model. PhD Thesis. Wageningen University, Wageningen, The Netherlands.   
Dayan, E., Van Keulen, H., Jones, J.W., Zipori, I., Shmuel, D. and Challa, H. 1993. Development, calibration and validation of a greenhouse tomato growth model: I. Description of the model. Agricultural Systems 4:145-163.   
De Zwart, H.F. 1996. Analyzing energy-saving options in greenhouse cultivation using a simulation model. PhD Thesis. Wageningen University, Wageningen, The Netherlands.   
Forrester, J.W. 1962. Industrial Dynamics. MIT Press, Cambridge.   
Hanan, J.J. 1998. Greenhouses: Advanced Technology for Protected Cultivation. CRC Press, Boca Raton, USA.   
Heuvelink, E. 1996. Tomato Growth and Yield: Quantitative Analysis and Synthesis. PhD Thesis. Wageningen University, Wageningen, The Netherlands.   
Linker, R., Seginer, I. and Buwalda, F. 2004. Description and calibration of a dynamic model for lettuce grown in a nitrate-limiting environment. Mathematical and Computer Modelling 40:1009-1024.   
Marcelis, L.F.M., Heuvelink, E. and Goudriaan, J. 1998. Modelling biomass production and yield of horticultural crops: a review. Scientia Horticulturae 74:83-111.   
Price, W.L. 1977. A controlled random search procedure for global optimisation. The Computer Journal 20:367-370.   
Seginer, I., Gary, C. and Tchamitchian, M. 1994. Optimal temperature regimes for a greenhouse crop with a carbohydrate pool: A modelling study. Scientia Horticulturae 60:55-80.   
Slager, A.A., Sapounas, A.A., van Henten, E.J. and Hemming, S. 2012. Feasibility study on combined production of algae and tomatoes in a Dutch greenhouse. Submitted to ISHS $7 ^ { \mathrm { t h } }$ International Symposium on Light in Horticultural Systems, Wageningen, The Netherlands.   
Vanthoor, B.H.E. 2011. A Model-based Greenhouse Design Method. PhD Thesis. Wageningen University, Wageningen, The Netherlands.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2008. Optimal greenhouse design should take into account optimal climate management. Acta Hort. 802:97-104.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2011a. A methodology for model-based greenhouse design: Part 1. Description and validation of a greenhouse climate model for a broad range of designs and climate conditions. Biosystems Engineering 110:363-377.   
Vanthoor, B.H.E., de Visser, P.H.B., Stanghellini, C. and van Henten, E.J. 2011b. A methodology for model-based greenhouse design: Part 2, description and validation of a tomato yield model. Biosystems Engineering 110:378-395.   
Vanthoor, B.H.E., van Henten, E.J., Stanghellini, C. and de Visser, P.H.B. 2011c. A methodology for model-based greenhouse design: Part 3, sensitivity analysis of a combined greenhouse climate-crop yield model. Biosystems Engineering 110:396- 412.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2012a. A methodology for model-based greenhouse design: Part 4, Economic evaluation of different greenhouse designs: a Spanish case. Biosystems Engineering 111:336-349.   
Vanthoor, B.H.E., Stanghellini, C., van Henten, E.J. and de Visser, P. 2012b. A methodology for model-based greenhouse design: Part 5, Greenhouse design optimisation for Southern-Spanish and Dutch conditions. Biosystems Engineering 111:350-368.   
Van Henten, E.J., Bakker, J.C., Marcelis, L.F.M., Van’t Ooster, A., Dekker, E., Stanghellini, C., Vanthoor, B.H.E., Van Randeraat, B. and Westra, J. 2006. The adaptive greenhouse - An integrated systems approach to developing protected cultivation systems. Acta Hort. 718:399-406.   
Van Heurn, E. and Van der Post, K. 2004. Protected cultivation - construction, requirements and use of greenhouses in various climates. Agrodok-series No. 23, Agromisa, Wageningen, The Netherlands.   
Van’t Ooster, A., Bontsema, J., van Henten, E.J. and Hemming, S. 2012. GWorkS - a discrete event simulation model on crop handling processes in a mobile rose cultivation system. Biosystems Engineering 112:108-120. 