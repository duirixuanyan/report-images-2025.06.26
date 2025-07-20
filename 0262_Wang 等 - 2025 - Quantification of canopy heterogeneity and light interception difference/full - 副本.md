# Quantification of canopy heterogeneity and light interception difference within greenhouse cucumbers based on terrestrial laser scanning

# 基于地面激光扫描的温室黄瓜冠层异质性及光截获差异量化研究

Zhi Wang $^{a,b}$ , Demin Xu $^{a}$ , Tiangang Lu $^{c}$ , Lingling Cao $^{d}$ , Fang Ji $^{a}$ , Jinyu Zhu $^{b,*}$ , Yuntao Ma $^{a,*}$

$^{a}$  中国农业大学土地科学与技术学院，北京，中国   $^{b}$  中国农业科学院蔬菜花卉研究所，蔬菜生物育种国家重点实验室，北京 100081   $^{c}$  北京市数字农业促进中心，北京 100021   $^{d}$  北京市农业技术推广站，北京 100029

# 文章信息

关键词: 三维建模 点云分割 虚拟植物模型 植物结构 辐射传输分析

# 摘要

重建黄瓜群体三维结构用于多尺度表型分析是温室作物研究中的重大挑战。黄瓜冠层结构直接影响光截获和植株生长状况。本研究采用地面激光扫描(TLS)获取不同生长阶段黄瓜植株的三维点云，称为真实植物冠层(RPC)。开发了一种结合快速欧式聚类和区域生长算法的新方法CP-FEC-RG，用于在植株和叶片尺度上分割黄瓜植株并提取表型性状。基于TLS采集数据构建了代表高、中、低生长潜力的虚拟植物冠层(VPCs)，即VPC-H、VPC-M和VPC-L。采用辐射传输模型比较RPC和VPCs的辐射截获能力。叶片分割的平均召回率达到$92.2\%$。分割后的单株和叶片间表现出生长差异，表型性状变异系数在单株水平为0.13-0.48，在叶片水平为0.21-0.54。在日累积光截获方面，VPC-L较RPC降低了$17.1\%$，而VPC-M和VPC-H分别增加了$18.2\%$和$30.1\%$。这些发现强调了使用RPC进行光截获精确计算的重要性，并为TLS在日光温室作物三维表型分析中的应用奠定了坚实基础。

# 1. 引言

黄瓜(Cucumis sativus L.)是中国温室栽培最广泛的蔬菜作物之一，年均播种面积和总产量均居世界首位(Zhao等，2019)。培育优质黄瓜品种对提高产量和保障供应至关重要(Zhang等，2021；Hu等，2022)。作为主要光合器官，叶片的尺寸和方位(包括叶倾角和方位角)是决定黄瓜光截获的关键因素(Cho等，2007；Kahlen等，2008)。每株黄瓜的结构显著影响其光合效率(Chen等，2014；Deans等，2020；Dechant等，2020)。因此，准确获取黄瓜叶片表型性状和植株结构对优化冠层光分布和培育理想株型至关重要。

植物表型技术的快速发展为黄瓜植株结构识别奠定了基础(Liu等，2021)。然而，由于缺乏非侵入式且高效的黄瓜植株结构获取方法，仍面临重大挑战。传统测量方法耗时耗力(Zareef等，2021；Tu等，2023)。因此，亟需高通量获取植物表型(Boogaard等，2021；Mitsanis等，2024)。多视角立体视觉(He等，2017；Lai等，2020)和三维数字化扫描技术(Maphosa等，2016；Wang等，2018)已被证明能有效获取植物三维结构并推导多种表型性状。但这些方法主要针对单株植物的表型分析，使得群体尺度三维结构数据的高通量获取成为挑战(Kochi等，2021；Boogaard等，2023)。

激光雷达(LiDAR)是一种新型主动遥感技术，通过发射和接收激光脉冲实现植物的精确三维表征(Raj等，2020；Wang和Fang，2020；Bi等，2022)。与传统摄影测量相比，LiDAR对环境光表现出显著不敏感性，确保在不同光照条件下性能稳定(Sun等，2021；Huang等，2022)。近年来，LiDAR已被证明是获取植物三维结构和群体尺度表型性状(如叶面积指数和冠层覆盖率)的有效工具。然而，由于缺乏从植物群体中提取作物器官的有效方法以及田间环境的复杂性，器官尺度的表型分析仍然有限(Jin等，2018；Miao等，2023；Liu等，2024)。此外，日光温室中非植物元素的存在限制了LiDAR的应用，这些元素增加了此类环境中数据处理和分析的复杂性。

传统的光截获计算方法主要依赖于光合有效辐射(PAR)传感器或半球摄影等仪器。这些方法通常复杂且耗时，涉及人工数据采集和大量后处理工作，降低了高通量研究的效率(Hanan and Begue, 1995; Caya et al., 2018)。功能-结构植物模型(FSPMs)的进展通过将3D植物结构与辐射模型相结合，实现了器官尺度光截获的量化(Li et al., 2021; Knowling et al., 2021; Wang et al., 2023)。早期的FSPMs研究通常将植物群体建模为VPCs，将冠层内所有植物视为统一个体(Kim et al., 2020; Souapvliou et al., 2021)。然而，黄瓜群体由众多形状、大小和方向各异的植株组成(Qian et al., 2014)。日光温室中独特的光环境和微气候变化导致黄瓜植株生长和冠层异质性的差异(Qian et al., 2019; Zhang et al., 2022)。先前研究已证实冠层结构对光截获的影响(Chen et al., 1994; Niinemets, 2010)。RPC与VPCs在光截获计算上的差异仍不明确。

![](images/d8daf9d18bc90c558c930ed7ad3157a3f32da8d8744cde3ca29f3153ec4d769c.jpg)  
图1. 本研究流程图，包含五个主要部分：(a)通过地面激光扫描(TLS)获取黄瓜冠层3D点云的过程。(b)点云预处理方法。(c)单株黄瓜植株分割及相应表型性状提取。(d)黄瓜叶片分割及相应表型性状提取。(e)黄瓜冠层内光截获量化方法。

本研究旨在利用TLS获取黄瓜植株3D结构，并量化日光温室中冠层异质性和光截获。具体目标为：(1)提出一种从群体中分割单株黄瓜及其器官点云的新方法；(2)通过不同尺度的表型分析增强对冠层异质性的理解；(3)量化VPCs与RPC的光截获差异。

# 2. 材料与方法

# 2.1. 系统框架总体设计

本研究包含五个主要部分：数据采集、预处理、单株黄瓜和叶片的3D点云分割与表型性状提取、冠层光截获模拟与量化。数据采集阶段使用地面激光扫描仪(TLS, FARO Focus, Lake Mary, Florida, USA)获取日光温室内不同生长阶段黄瓜冠层的3D点云。采用多种点云预处理方法，包括降采样(Li et al., 2023)和统计滤波(Li et al., 2022)，去除与黄瓜植株无关的噪声。在3D点云分割过程中，采用快速欧式聚类(Cao et al., 2022)和区域生长算法(Jin et al., 2018)分割单株黄瓜和叶片，提取相关表型性状。最后，利用辐射传输模型模拟计算日光温室内的日间光截获(Bailey, 2019)。系统框架示意图如图1所示。

# 2.2. 试验地点与植物材料

温室试验在中国北京朝来农艺园$(116^{\circ}29^{\prime}\mathrm{E},40^{\circ}07^{\prime}\mathrm{N})$和白坊种植园$(116^{\circ}45^{\prime}\mathrm{E},40^{\circ}03^{\prime}\mathrm{N})$的两个日光温室中进行。日光温室采用自然光照，无人工补光。两个试验点采用相同的黄瓜栽培方案，使用宽垄双行种植模式，每行13-15株黄瓜。株距$30~\mathrm{cm}$，行距$40~\mathrm{cm}$，垄距$90~\mathrm{cm}$。黄瓜植株栽培于土壤中，遵循标准水肥管理措施。整个试验期间采用一致的病虫害管理策略。温室生产管理时间为上午7:00至下午$5:00\mathrm{pm}$。使用QSO-S PAR传感器(Decagon, US)和RC-4温度传感器(Elitech, China)持续监测试验区北部、中部和南部的微气候。三个区域全天温度波动范围分别为$13.3 - 37.1^{\circ}\mathrm{C}$、$12.3 - 37.4^{\circ}\mathrm{C}$和$11.8 - 38.9^{\circ}\mathrm{C}$。生产期间PAR范围为$59 - 851\mathrm{W} / \mathrm{m}^2$、$78 - 924\mathrm{W} / \mathrm{m}^2$和$67 - 982\mathrm{W} / \mathrm{m}^2$。

采用TLS获取黄瓜冠层3D点云。每次扫描前，在宽垄间放置标靶球，在相邻扫描站视角下定义唯一的3D空间。数据采集采用六站式扫描策略，扫描仪位于采集区域四个角点和长边中点。每次扫描持续$10\mathrm{min}$。图2展示了黄瓜栽培和TLS设置。在两个品种('中农$16^{\prime}$'和'荷兰黄瓜')的三个不同生长阶段采集黄瓜冠层点云。每个阶段选择两条宽垄的黄瓜植株作为研究对象。

# 2.3. 数据采集与预处理

TLS数据处理的第一步是使用SCENE 2019软件(FARO, Lake Mary, Florida, USA)对多站3D点云进行配准和整合。然后应用Cloud Compare软件(https://www.cloudcompare.org/)去除温室设施等无关元素。通过定义水平面为xy平面并相应调整植株生长方向进行坐标校准。3D点云虽能直观显示黄瓜植株，但仍包含地面和支撑绳等无关元素。需通过四个阶段的预处理步骤提取黄瓜群体的3D点云：(1)降采样：采用体素降采样算法简化原始点云，在保持几何特征和属性的同时降低复杂度，提高处理效率。(2)地面去除：使用CSF算法在特定距离下处理简化后的点云，将植物点云与地面明显分离(Zhang et al., 2016)。(3)绿色点云提取：通过调整分割阈值，利用超绿指数分离指示黄瓜植株的绿色点云。(4)去噪：采用统计滤波算法去除离群点和噪声，进一步精炼点云。

# 2.4. 单株植物和叶片的分割

预处理后的黄瓜群体点云采用快速欧式聚类算法进行分割。首先确定每个聚类点云沿x轴和y轴的尺寸。然后根据指定阈值将聚类结果分为两类：单株黄瓜植株和多株黄瓜植株。对于包含多株黄瓜的点云，采用Mean shift算法(Wu and Yang, 2007)进行二次聚类。重复此过程进一步优化结果，直到满足单株黄瓜植株的阈值条件。通常需要1-2次递归分析迭代，确保所有分割结果均为单株黄瓜植株。表1展示了使用快速欧式聚类分割单株黄瓜植株的伪代码。

采用区域生长聚类算法将单株黄瓜植株分割为不同器官。通过比较聚类后3D点云中的点数来区分叶片和非叶片点云。然后应用主成分分析(PCA)(Xiao等，2021)将叶片点云分为两类：单叶片和多叶片。对于多叶片点云，使用K-Means++算法(Wu等，2020)进行精细聚类，确保最终结果中的每个聚类代表单个叶片。展示了使用区域生长聚类方法进行叶片分割的伪代码。

![](images/40eb11b8e4b73b3099c834174d929dea0faa4e82d3077b5d912b8859eab92053.jpg)  
图2. 黄瓜栽培及地面激光扫描(TLS)数据采集示意图

表1 方法1的快速欧式聚类分割伪代码

| 行号 | 描述 |
|------|------|
| 1: | 读取原始点云数据 |
| 2: | 设置快速欧式聚类参数 |
| 3: | 设置均值漂移聚类参数 |
| 4: | 算法 SegmentPointCloud (原始点云) |
| 5-6: | 运行快速欧式聚类算法生成初始分割结果S，对S中的每个点云Si执行 |
| 7: | 递归分割(Si) |
| 8: | 结束循环 |
| 9: | 算法 RecursiveSplit (点云) |
| 10: | 计算点云X轴长度Spanx |
| 11: | 计算点云Y轴长度Spany |
| 12: | 初始化距离阈值a和b |
| 13: | 如果(Spanx ≤ a 且 Spany ≤ b)则 |
| 14: | 将点云标记为单株黄瓜并保存否则 |
| 15-17: | 运行均值漂移算法生成新聚类C结束判断 |
| 18: | 对C中的每个聚类Ci执行 |
| 19: | 递归分割(Ci) |
| 20: | 结束循环 |

表2 方法2的区域生长聚类分割伪代码

| 行号 | 描述 |
|------|------|
| 1: | 读取原始点云数据 |
| 2: | 设置区域生长聚类参数 |
| 3: | 设置K-Means++聚类参数 |
| 4: | 算法 LeafSegment (原始点云) |
| 5: | 运行区域生长聚类算法生成初始分割结果S |
| 6: | 初始化点数阈值a和PCA阈值b |
| 7: | 对S中的每个点云Si执行 |
| 8: | 计算Si的点数N |
| 9: | 如果N > a则 |
| 10: | 运行PCA算法计算Si的阈值Ti |
| 11: | 如果Ti > b则 |
| 12: | 将点云标记为单张黄瓜叶片 |
| 13: | 保存单张黄瓜叶片 |
| 14: | 否则 |
| 15: | 运行K-Means++算法生成新聚类C |
| 16: | 将C中每个元素保存为单张黄瓜叶片 |
| 17: | 结束判断 |
| 18: | 结束判断 |
| 19: | 结束循环 |

# 2.5. 表型性状提取

上述方法实现了黄瓜群体中单株及其对应叶片点云的分割。分割结果通过逆向工程软件(Geomagic Wrap 2021, 3D Systems)进行孔洞填充和缺失部分修复，确保3D点云的完整性。针对TLS重建导致的点云数据显著缺失问题，采用补偿方法通过邻近区域的叶片或单株替代缺失区域，恢复黄瓜冠层结构信息。随后提取单叶片的五个关键表型性状：叶长、叶宽、叶面积、叶倾角和叶方位角。从分割后的叶片点云中识别关键点，包括叶尖、叶基和两个叶缘点用于计算叶宽。采用Dijkstra算法计算叶尖与叶基之间的最短距离作为叶长，两个叶缘点之间的距离作为叶宽。使用Geomagic Wrap 2021软件对叶片点云进行三角网格化，采用海伦公式计算每个三角形面积并累加得到叶面积。通过随机抽样一致(RANSAC)算法(Chum and Matas, 2008)拟合叶片点云的平面方程，计算平面法向量与z轴正方向的夹角作为叶倾角。以y轴正方向为真北基准，计算叶片平面法向量在x-y平面投影与Y轴正方向的夹角作为叶方位角。

从单株黄瓜分割点云中提取五个关键表型性状：株高、冠层投影面积、冠层凸包体积、总叶面积和冠层占据体积。应用RANSAC算法拟合地面点云平面方程，将黄瓜植株z轴最高点到该地面的垂直距离作为株高。计算植株在x-y平面的投影面积代表冠层投影面积。采用QuickHull算法(Barber et al., 1996)构建黄瓜植株凸包，形成表征冠层的最小凸多面体，其体积即为冠层凸包体积。将单株黄瓜点云体素化为$1\mathrm{cm}^3$的体素单元，统计包含黄瓜植株网格的体素总数得到冠层占据体积(Liu et al., 2021)。所有计算均通过Python 3.8实现(http://www.python.org)。

# 2.6. Helios辐射传输模型与VPCs构建

采用Helios 3D建模框架(Bailey, 2019)计算黄瓜冠层光截获，该框架整合了温室与黄瓜冠层的3D结构以及Bailey辐射传输模型(Bailey, 2018)。根据纬度、经度、年积日和时刻确定太阳位置，采用反向光线追踪法模拟冠层内每个三角网格的PAR。为降低模型复杂度，所有植物器官的反射率和透射率统一设为0.3，温室采光面反射率和透射率分别设为0.05和0.9，后墙反射率和透射率设为0.1和0。冠层光分布模拟时间为每日7:00至$5:00\mathrm{pm}$，时间间隔1小时，散射迭代次数设为8，设置周期性边界条件消除域边缘效应。Helios框架集成REST-2模型(Gueymard, 2008)计算考虑大气衰减的地表直射和散射太阳通量。在Helios 3D框架中，计算每个三角面单位面积光截获量$(W/m^2)$，进而估算黄瓜群体日累积光截获量(W-h，式1)，并量化光合光子通量密度(PPFD)处于$70\mathrm{-}1000\mu\mathrm{mol}/\mathrm{m}^2/\mathrm{s}$范围(对应光响应曲线线性部分)的叶面积。

$$
DLI = \int_{t = 7}^{17}\left(\sum_{i = 1}^{m}s_i^* LF_i\right)dt \tag{1}
$$

$LF_{i}$表示每个面单位面积截获的太阳辐射，$s_i$为单个面的面积，$m$为面总数。

$$
S_{la} = \sum_{i = 1}^{m}s_{i}(ifLF_{i}\in PPFD_{range}) \tag{2}
$$

$S_{la}$表示PPFD处于$70\mathrm{-}1000\mu\mathrm{mol}/\mathrm{m}^2/$s范围内的叶面积，对应光响应曲线线性部分。

选取第三生长阶段分割的单株黄瓜作为基准，评估RPC与VPCs间光截获差异。选择与日累积光截获密切相关的三个表型性状(株高、总叶面积和冠层占据体积)作为聚类指标，通过K-Means算法将黄瓜植株按生长势分为高、中、低三组，每组随机选取3株作为VPCs构建基础单元。VPCs按照真实群体的垄距、株距和行距配置构建以保持模型一致性。在VPCs构建中，每个基础单元复制19次，每次复制前绕z轴随机旋转$0^{\circ}$至$360^{\circ}$以模拟植株自然朝向变异，最终生成分别代表高、中、低生长势的三种虚拟群体VPC-H、VPC-M和VPC-L。

# 2.7. 评价指标

采用精确率、召回率和F1值作为CP-FEC-RG方法分割单株和器官的主要评价指标。点云中分割叶片与原始叶片的匹配需满足：(1)分割叶片应与原位原始叶片对齐；(2)分割需包含原始叶片至少$60\%$的点。准确识别和分割的叶片记为真阳性(TP)，原始数据中存在但未成功分割的叶片记为假阴性(FN)，误识别为非叶成分的记为假阳性(FP)。相关指标计算公式如下：

$$
Recall = TP / (TP + FN) \tag{3}
$$

$$
Precision = TP / (TP + FP) \tag{4}
$$

$$
F1 - score = 2^{*}(Precision^{*}Recall) / (Recall + Precision) \tag{5}
$$

为分析单株黄瓜表型性状与日累积光截获量的相关性，采用Pearson相关系数进行分析：

$$
r = \frac{\sum_{i = 1}^{n}(X_{i} - \overline{X})(Y_{i} - \overline{Y})}{\sqrt{\sum_{i = 1}^{n}((X_{i} - \overline{X}))^{2}}\sqrt{\sum_{i = 1}^{n}((Y_{i} - \overline{Y}))^{2}}} \tag{6}
$$

其中$X$表示特定表型性状数据集，$Y$表示日累积光截获量(W-h)数据集。

# 3. 结果

# 3.1. CP-FEC-RG方法评价

在三个生长阶段(图3)，黄瓜群体的三维点云被分割为离散的单株和叶片实体，不同颜色代表不同植株及其叶片。第一生长阶段的黄瓜植株相对较小，平均每株3-4片叶，叶片分割的召回率达到$92.2\%$。第二生长阶段分割后的黄瓜群体平均每株4-8片叶，叶片分割召回率为$91.9\%$。第三生长阶段植株平均8-12片叶，分割方法实现$92.4\%$的叶片分割召回率。

与单独使用区域生长算法相比，CP-FEC-RG方法显著提高了黄瓜叶片分割的召回率、精确率和F1值(图4a-c)。平均召回率从$87.6\%$提升至$92.2\%$，精确率从$98.2\%$提升至$98.3\%$，F1值从$92.6\%$提升至$95.2\%$。在区域生长算法后进一步应用PCA算法，通过识别叶簇的主要朝向和形状特征来区分单叶和连体叶，随后采用K-Means++算法进行细化分割。

# 3.2. 黄瓜表型性状提取

基于原始点云对误识别和遗漏的黄瓜叶片进行校正，确保表型提取和分析的可靠性。如图5所示，黄瓜叶片宽度普遍大于长度。第一生长阶段叶长和叶宽变异较小，范围在5-$15\mathrm{cm}$之间；第二、三生长阶段叶长(5-$25\mathrm{cm}$)和叶宽(10-$30\mathrm{cm}$)变异增大。$59.5\%$的叶倾角分布在$25^{\circ}-50^{\circ}$，$53.6\%$的叶方位角集中在$160^{\circ}-240^{\circ}$，表明黄瓜叶片呈南向排列。三个生长阶段的平均叶面积分别为$73.15\mathrm{cm}^2\pm30.27\mathrm{cm}^2$、$218.51\mathrm{cm}^2\pm117.99\mathrm{cm}^2$和$287.2\mathrm{cm}^2\pm123.50\mathrm{cm}^2$。各生长阶段表型性状均存在显著变异(CV=0.21-0.49)，其中叶倾角、方位角和叶面积的CV均大于0.32。

![](images/93da7d3c0b402c45d271e003296fea85937f63460f4983e9838ee6a166fd892b.jpg)  
图3. CP-FEC-RG方法在三个生长阶段对黄瓜群体三维点云的分割过程。(a-c)不同生长阶段未处理的黄瓜群体三维点云；(d-f)不同颜色标记的相邻植株；(g-i)不同颜色标记的相邻叶片。

![](images/e002ced88adfa8e6cefed77a347e75da21f6b7ae08ed371c3669c4658b0ef57d.jpg)  
图4. 区域生长算法与CP-FEC-RG在黄瓜单株分割中的性能比较：(a)召回率，(b)精确率，(c)F1值。(d-e)黑色虚线显示两种方法在叶片分割中的差异，相同颜色代表同一叶片。

![](images/20f0f3f0c2d1bd6cbc56f267e2f8576a7846afb527c196a09a4617db09cff73f.jpg)  
图5. 三个生长阶段叶片表型性状直方图分布：(a)第一生长阶段，(b)第二生长阶段，(c)第三生长阶段。每行对应一个生长阶段，展示叶长、叶宽、叶倾角、方位角和叶面积五个性状。"Mean"表示平均值；"CV"为变异系数；曲线表示核密度估计。

单株黄瓜表型性状在不同生长阶段也呈现显著变异(CV=0.13-0.48)(图6)。株高变异最小，三个生长阶段平均高度分别为$0.3\mathrm{m}$、$0.5\mathrm{m}$和$1.5\mathrm{m}$。冠层投影面积(CV=0.22-0.34)和凸包体积(CV=0.25-0.48)变异较大，反映黄瓜冠层结构的异质性。单株总叶面积分别为$244.87\mathrm{cm}^2\pm66.11\mathrm{cm}^2$、$1313.87\mathrm{cm}^2\pm389.85\mathrm{cm}^2$和$2792.16\mathrm{cm}^2\pm725.96\mathrm{cm}^2$。冠层占据体积的变异(CV=0.23-0.35)小于凸包体积。

![](images/2b03dffcabfb14e45a2094d0f82114c659dd480c9ca463a0865642f99fdd97a3.jpg)  
图6. 三个生长阶段单株表型性状直方图分布：(a)第一生长阶段，(b)第二生长阶段，(c)第三生长阶段。每行对应一个生长阶段，展示株高、冠层投影面积、冠层凸包体积、总叶面积和冠层占据体积五个性状。"Mean"表示平均值；"CV"为变异系数；曲线表示核密度估计。

# 3.3. 黄瓜三维冠层光截获定量分析

Helios模型中的模拟时间设置为2023年10月29日7:00至$5:00\mathrm{pm}$，与数据采集时段对应。实测与模拟的光合有效辐射(PAR)表现出高度一致性(图7)，决定系数$\mathbb{R}^2$为0.88，均方根误差为$47~\mathrm{W / m^2}$。通过生成黄瓜生长参数空间分布图量化温室内的生长异质性(图S1)。在温室北部、中部和南部区域各选取三列(图S1a蓝框标记)，计算各区域内表型性状平均值(图8)。结果表明，中南部区域的叶长、叶宽、株高、单株总叶面积、冠层体积和日累积光截获量均高于北部区域。图S2中t检验的$\mathbb{P}$值进一步证实了除株高外所有表型性状的显著性差异$(P< 0.05)$。南部、中部和北部区域的叶倾角分别为$39.1^{\circ}$、$38.0^{\circ}$和$34.4^{\circ}$，呈现向南递增的趋势；叶方位角分别为$181.4^{\circ}$、$178.2^{\circ}$和$171.8^{\circ}$，表明温室南部区域叶片更倾向于南向排列。

采用Pearson相关系数分析日累积光截获量与株高、总叶面积和占据体积的关系(图9)。所有表型性状均与日累积光截获量呈强相关性($\mathrm{R} > 0.5$, $P< 0.01$)，其中冠层占据体积的相关性最高(0.83)。这表明冠层占据体积作为综合表型性状，能反映叶面积、结构和朝向对光截获的协同影响。

图10展示了$12:00\mathrm{pm}$时刻真实植物冠层(RPC)和虚拟植物冠层(VPCs)的光分布情况。中南部区域的光截获量显著高于中部和北部区域。冠层上部叶片对下部形成遮荫，显著降低了下部光截获。在VPCs中，VPC-L由小型稀疏植株组成，遮荫效应最小，冠层下部辐射获取增强；而VPC-M和VPC-H由大型植株构成，冠层密集导致底部光截获减少。

图11显示三个时段内RPC和VPCs的光截获量随冠层高度先增后减。冠层顶部$(150 - 165\mathrm{cm})$因幼叶较小导致光截获较低，峰值出现在$30\mathrm{- }90\mathrm{cm}$高度区间。VPC-L在冠层底部$(0 - 30\mathrm{cm})$的光截获量最高。$12:00\mathrm{pm}$时，VPC-M和VPC-H在中上部冠层$(90 - 150\mathrm{cm})$的光截获量分别比RPC高$6.6\%$和$7.0\%$，而VPC-L则低$61.2\%$(图11b)。8:00 am和$4:00\mathrm{pm}$时，VPC-M中上部冠层的光截获量分别比RPC低$5.8\%$和$22.3\%$(图11a和11c)。

为进一步分析真实植物冠层(RPC)与虚拟植物冠层(VPCs)的光强分布差异，对各表面的光合光子通量密度(PPFD)进行了统计分析。将截获PPFD处于光响应曲线线性部分(70-1000 μmol/m²/s)(图12a)的叶面积计算为$S_{la}$(式2)。结果表明，$S_{la}$呈现先上升后下降、再上升再下降的日变化波动模式。$S_{la}$在下午2:00达到峰值，至5:00降至最低值。四种冠层类型的$S_{la}$总体趋势为：$\mathrm{VPC-L < RPC < VPC-M < VPC-H}$。具体而言，RPC的$S_{la}$比VPC-L高29.3%，但比VPC-M和VPC-H分别低19.8%和26.9%。显著性分析(图12b)显示四种冠层类型间$S_{la}$差异均具有统计学意义($P<0.05$)，其中VPC-L与RPC之间的差异更为显著($P<0.01$)。

![](images/bb585e913f8ff5a6634aa814c716f42456d367680ba8d3d7f922abe984813a92.jpg)  
图7. 7:00 am至5:00 pm三个不同空间位置实测与计算光合有效辐射(PAR)的比较

![](images/76f11cee3b026d6dcae52afe59ad0f8825cc304e33b3d7ed759979be80619246.jpg)  
图8. 日光温室内不同区域黄瓜生长参数平均值比较：(a)平均叶长，(b)平均叶宽，(c)株高，(d)单株总叶面积，(e)冠层占据体积，(f)日累积光截获量，(g)平均叶倾角，(h)冠层单株平均叶方位角

![](images/c83d1bd182ca072fefa608f042830b7d311eb7c21dffb5c7b2c21419fe3ef2b7.jpg)  
图9. 单株日累积光截获量与叶长(a)、叶宽(b)、株高(c)、单株总叶面积(d)和冠层占据体积(e)的相关性分析

RPC和VPCs的光截获日变化模式一致，均呈现先逐渐增加至峰值后下降的趋势(图13)。VPC-L的每小时光截获量比RPC低11.3%至86.0%。除7:00 am和5:00 pm时段外，VPC-M和VPC-H的每小时光截获量分别比RPC高6.2%至25.8%和11.7%至38.8%，而在上述两个时段则分别降低15.2%至83.9%和5.5%至82.2%。VPC-L的日累积光截获量比RPC低17.1%，而VPC-M和VPC-H则分别比RPC高18.2%和30.1%。

# 4. 讨论

# 4.1. LiDAR驱动的温室作物表型研究进展

LiDAR已成为快速获取田间植物三维结构数据的有效手段，可实现作物表型的精细分析(Liu等, 2023; Miao等, 2023)。然而在温室环境中，其应用受到封闭空间特性和多种干扰因素的限制，影响植物表型性状的提取(Xiao等, 2023)。温室表型采集主要依赖人工测量或局限于单株水平，缺乏高通量表型获取技术(Grimstad等, 2018)。本研究采用TLS获取温室内黄瓜群体三维点云，实现群体、单株和叶片尺度的分割，进而提取相关表型性状。与传统表型技术相比，基于LiDAR的方法可快速获取黄瓜群体大范围三维点云并精确勾勒实际叶片形态，得到更准确可靠的表型性状，如叶面积和冠层覆盖度(Itakura和Hosoi, 2018; Patil等, 2018)。

光截获能力是植物生产力的重要指标。大量研究证实冠层结构与光截获能力密切相关(Liu等, 2021)。本研究利用TLS精确获取黄瓜器官和单株表型性状，通过相关性分析确定了株高、总叶面积等与日光截获显著相关的关键表型性状。传统研究常难以根据植株构型直观筛选优质作物品种(Korir等, 2013)。本研究基于光截获能力将作物分为高、中、低三组进行聚类分析，为快速、准确、客观地优化冠层结构提供了新思路。

![](images/6b5e2c412ad52036f0597d5a70d3e0f6e47684b191bd1782399aec5f9c16c90d.jpg)  
图10. 中午12:00真实与虚拟植物冠层光分布可视化。(a)基于地面激光扫描(TLS)数据构建的真实植物冠层模型；(b-d)分别选取低、中、高生长势植株构建的虚拟冠层模型。

![](images/8e61da46fab63e849b489def15a49e357d4ca2ca6869c352ae281c01967b8985.jpg)  
图11. 三个时段真实与虚拟冠层不同高度的光截获量：(a)上午8:00，(b)中午12:00，(c)下午4:00。冠层高度按30cm间隔划分。

# 4.2. 日光温室黄瓜冠层异质性分析

日光温室主要利用太阳能供暖，其独特结构设计旨在优化采光和保温效率(Jiao等, 2024; Li等, 2024)。然而温室微环境异质性会影响作物生长发育(Qian等, 2019; Zhang等, 2022)。本研究采用TLS获取黄瓜群体三维结构，实现单株和叶片尺度表型性状提取。结果表明，叶片长宽、株高、单株总叶面积、占据体积和日累积光截获量均呈现一致的空间分布趋势，中南部区域植株表现出更强的生长势和光截获能力。叶倾角逐渐直立，方位角更趋近南方，体现了黄瓜植株向光性以最大化光合作用。

冠层异质性与温室南北走向的微环境变化密切相关。日光温室特有的三面围护结构和采光面设计导致南北区域光照条件差异显著(La Notte等, 2020)。北墙阴影影响冠层生长。测量表明这种异质性主要源于南北区域光辐射差异。Tao等(2016)发现日光温室北区番茄生物量显著低于中南部，归因于光分布不均。本研究中，中南部区域日均PAR显著较高(图S3a)，证实良好光照促进黄瓜光合作用和生物量积累，尽管供暖系统使北区温度更高。对北区(图S1h黑框)和中部(图S1h红框)植株的观测显示，虽然北区植株在总叶面积等生长参数上占优，但其日累积光截获量显著低于中部植株。这些现象主要源于温室内光环境差异，为可控农业环境中优化光照策略和作物管理提供了重要依据。

![](images/8ff65669182f8cdd974698b1ca5835717a7f46ac1417615975ef3e9f74cc6929.jpg)  
图12. $S_{la}$日变化趋势。$S_{la}$定义为截获PPFD处于光合响应曲线线性区间(70-1000μmol/m²/s)的叶面积(a)及真实与虚拟冠层间p值显著性矩阵(b)。

![](images/1a1720675575267e3af116bc98380702c698e59d170d3d9f817235949d12bf98.jpg)  
图13. 真实与虚拟冠层7:00至17:00光截获量变化。

# 4.3. 采用RPC计算光截获的重要性

精确的冠层结构对光截获量化至关重要(Qian等, 2019; Zhang等, 2022)。既往研究常采用均匀虚拟冠层(VPC)简化计算(Li等, 2023; Song等, 2023)。然而本研究的表型分析显示，不同生长阶段叶片和单株间存在显著变异，表明使用VPC可能导致较大误差。已有研究量化证实大田玉米RPC与VPC的光截获差异(Kim等, 2020; Xiao等, 2023)，但温室作物相关研究仍属空白。本研究计算了三个时段RPC与VPCs不同冠层高度的光截获(图11)。冠层覆盖度增加可能降低下层光截获，合理密植可优化空间利用促进整体生长。VPC-L日累积光截获比RPC低17.1%，而VPC-M和VPC-H分别高18.2%和30.1%(图13)。计算了全天PPFD处于光合响应曲线线性区间(70-1000μmol/m²/s)的叶面积变化($S_{la}$，图12)，RPC的$S_{la}$比VPC-L高29.3%，但比VPC-M和VPC-H分别低19.8%和26.9%。处于光合曲线线性区间的PPFD对黄瓜生物量积累至关重要，RPC与VPCs的光截获差异进一步证实了精确冠层结构的重要性。

# 4.4. 局限性与未来工作

尽管本研究中使用TLS技术捕获了超过$90\%$的黄瓜叶片，但后续数据处理仍面临重大挑战。目前针对不完整叶片或植株的解决方案主要依赖人工经验驱动的补全或修复技术，效率低下且劳动密集。最新研究探索了利用不完整与完整点云之间的对抗训练策略，实现叶片3D点云的快速精确修复(Sun等, 2023; Chen等, 2023)。尽管TLS在获取温室作物3D结构数据方面优势显著，但设备的高昂成本不仅限制了其广泛应用，还给农业生产带来经济压力(Cabo等, 2018; Medjkane等, 2018)。因此，开发快速、经济的温室作物3D结构采集技术仍是未来研究的重要目标。

# 5. 结论

本研究利用TLS技术获取了三个生长阶段的黄瓜群体3D点云数据，通过多尺度表型分析和辐射模拟量化了黄瓜冠层的异质性及光截获特征。主要贡献与发现如下：

(1) 提出新型CP-FRC-RG方法，实现精确叶片分割$(\mathrm{召回率}=92.2\%)$及相关表型性状提取。

(2) 识别出5个关键表型性状，单株变异系数0.13-0.48，单叶0.21-0.54，揭示了黄瓜植株的显著变异性。多组表型指标与日累积光截获数据表明，中南部区域植株生长优于北部区域。在作物生长模拟中考虑冠层异质性至关重要。

(3) 量化了虚拟植株(VPC)与真实植株(RPC)的光截获差异：VPC-L日累积光截获比RPC低$17.1\%$，而VPC-M和VPC-H分别高出$18.2\%$和$30.1\%$。在光合响应曲线线性区间$(70-1000\mu mol/m^2/s)$内，RPC的叶面积$S_{la}$比VPC-L高$29.3\%$，但比VPC-M和VPC-H分别低$19.8\%$和$26.9\%$。

(4) 本研究为日光温室黄瓜表型分析和光截获计算提供了创新解决方案，强调了使用真实植株进行光截获计算的重要性，对推进温室作物育种和精准管理具有重要意义。

# 作者贡献声明

Zhi Wang: 论文撰写与修改、可视化、验证、监督、软件、资源、方法论、调查、形式分析、数据管理、概念化。Demin Xu: 论文修改、可视化、方法论、调查、形式分析、数据管理。Tiangang Lu: 可视化、资源、方法论、形式分析、数据管理。Lingling Cao: 可视化、验证、软件、形式分析、数据管理。Fang Ji: 可视化、软件、资源、调查、数据管理。Jinyu Zhu: 论文修改、可视化、监督、方法论、资金获取、数据管理、概念化。Yuntao Ma: 论文修改、验证、项目管理、方法论、调查、资金获取、形式分析、数据管理、概念化。

# 基金资助

本研究受北京市数字农业研究系统创新联盟(BAC-10-2024-E07)、国家重点研发计划(2023YFD2000600)和国家自然科学基金(32372799)资助。

# 利益冲突声明

作者声明不存在可能影响本研究的财务利益或个人关系。

# 附录A. 补充材料

本文补充材料可通过 https://doi.org/10.1016/j.compag.2024.109879 在线获取。

# 数据可用性声明

本研究数据公开可用。需要数据者请联系通讯作者Yuntao Ma，工作单位：中国农业大学土地科学与技术学院，北京100193（电子邮箱：yuntao.ma@cau.edu.cn）。

## 参考文献

1.  [Bailey, 2018](#bb0005)
B.N. Bailey
用于叶片解析植物冠层模拟中净辐射通量建模的反向光线追踪方法
Ecol. Modell., 368 (2018), pp. 233-245, [10.1016/j.ecolmodel.2017.11.022](https://doi.org/10.1016/j.ecolmodel.2017.11.022)
2.  [Bailey, 2019](#bb0010)
B.N. Bailey
Helios: 可扩展的3D植物与环境生物物理建模框架
Front. Plant Sci., 10 (2019), pp. 1-17, [10.3389/fpls.2019.01185](https://doi.org/10.3389/fpls.2019.01185)
3.  [Barber et al., 1996](#bb0015)
C.B. Barber, D.P. Dobkin, H. Huhdanpaa
凸包的快速凸包算法
ACM Trans. Math. Softw., 22 (1996), pp. 469-483, [10.1145/235815.235821](https://doi.org/10.1145/235815.235821)
4.  [Bi et al., 2022](#bb0020)
K. Bi, S. Gao, S. Xiao, C. Zhang, J. Bai, N. Huang, G. Sun, Z. Niu
基于器官水平生物量和氮浓度的超光谱激光雷达氮分布表征
Comput. Electron. Agric., 199 (2022), Article 107165, [10.1016/j.compag.2022.107165](https://doi.org/10.1016/j.compag.2022.107165)
5.  [Boogaard et al., 2021](#bb0025)
F.P. Boogaard, E.J. van Henten, G. Kootstra
通过光谱数据增强不完整3D点云提升黄瓜植株器官分割
Biosyst. Eng., 211 (2021), pp. 167-182, [10.1016/j.biosystemseng.2021.09.004](https://doi.org/10.1016/j.biosystemseng.2021.09.004)
6.  [Boogaard et al., 2023](#bb0030)
F.P. Boogaard, E.J. van Henten, G. Kootstra
3D点云在数字植物表型分析中的附加价值——以黄瓜节间长度测量为例
Biosyst. Eng., 234 (2023), pp. 1-12, [10.1016/j.biosystemseng.2023.08.010](https://doi.org/10.1016/j.biosystemseng.2023.08.010)
7.  [Cabo et al., 2018](#bb0035)
C. Cabo, S. Del Pozo, P. Rodríguez-Gonzálvez, C. Ordóñez, D. González-Aguilera
地面激光扫描(TLS)与可穿戴激光扫描(WLS)在单株树木建模中的比较
Remote Sens., 10 (2018), [10.3390/rs10040540](https://doi.org/10.3390/rs10040540)
8.  [Cao et al., 2022](#bb0040)
Y. Cao, Y. Wang, Y. Xue, H. Zhang, Y. Lao
FEC: 点云分割的快速欧几里得聚类方法
Drones, 6 (2022), pp. 1-18, [10.3390/drones6110325](https://doi.org/10.3390/drones6110325)
9.  [Caya et al., 2018](#bb0045)
M.V.C. Caya, J.T. Alcantara, J.S. Carlos, S.S.B. Cereno
用于农业应用的光合有效辐射(PAR)传感器集成光传感器阵列与数据记录
Conf. Comput. Commun. Syst. ICCCS, 2018 (2018), pp. 431-435, [10.1109/CCOMS.2018.8463321](https://doi.org/10.1109/CCOMS.2018.8463321)
10.  [Chen et al., 2014](#bb0050)
T.W. Chen, M. Henke, P.H.B. De Visser, G. Buck-Sorlin, D. Wiechers, K. Kahlen, H. Stützel
温室黄瓜冠层不同层次光合作用的主要限制因素是什么?
Ann. Bot., 114 (2014), pp. 677-688, [10.1093/aob/mcu100](https://doi.org/10.1093/aob/mcu100)
11.  [Chen et al., 2023](#bb0055)
H. Chen, S. Liu, C. Wang, C. Wang, K. Gong, Y. Li, Y. Lan
基于深度学习的遮挡条件下植物叶片点云补全
Plant Phenomics, 5 (2023), pp. 1-12, [10.34133/plantphenomics.0117](https://doi.org/10.34133/plantphenomics.0117)
12.  [Chen et al., 1994](#bb0060)
S.G. Chen, B.Y. Shao, I. Impens, R. Ceulemans
植物冠层结构对光截获和光合作用的影响
J. Quant. Spectrosc. Radiat. Transf., 52 (1994), pp. 115-123, [10.1016/0022-4073(94)90144-9](https://doi.org/10.1016/0022-4073(94)90144-9)
13.  [Cho et al., 2007](#bb0065)
Y.Y. Cho, S. Oh, M.M. Oh, J.E. Son
利用叶长、叶宽和SPAD值估算水培黄瓜单叶面积、鲜重和干重
Sci. Hortic. (amsterdam), 111 (2007), pp. 330-334, [10.1016/j.scienta.2006.12.028](https://doi.org/10.1016/j.scienta.2006.12.028)
14.  [Chum and Matas, 2008](#bb0070)
O. Chum, J. Matas
最优随机RANSAC算法
IEEE Trans. Pattern Anal. Mach. Intell., 30 (2008), pp. 1472-1482, [10.1109/TPAMI.2007.70787](https://doi.org/10.1109/TPAMI.2007.70787)
15.  [Deans et al., 2020](#bb0075)
R.M. Deans, T.J. Brodribb, F.A. Busch, G.D. Farquhar
优化可作为叶片光合作用、气体交换和水分关系之间的基础联系
Nat. Plants, 6 (2020), pp. 1116-1125, [10.1038/s41477-020-00760-6](https://doi.org/10.1038/s41477-020-00760-6)
16.  [Dechant et al., 2020](#bb0080)
B. Dechant, Y. Ryu, G. Badgley, Y. Zeng, J.A. Berry, Y. Zhang, Y. Goulas, Z. Li, Q. Zhang, M. Kang, J. Li, I. Moya
冠层结构解释作物光合作用与太阳诱导叶绿素荧光之间的关系
Remote Sens. Environ., 241 (2020), [10.1016/j.rse.2020.111733](https://doi.org/10.1016/j.rse.2020.111733)
17.  [Grimstad et al., 2018](#bb0090)
L. Grimstad, R. Zakaria, T. Dung Le, P.J. From
一种用于温室应用的新型自主机器人
IEEE Int. Conf. Intell. Robot. Syst., 8270–8277 (2018), [10.1109/IROS.2018.8594233](https://doi.org/10.1109/IROS.2018.8594233)
18.  [Gueymard, 2008](#bb0095)
C.A. Gueymard
REST2:基于基准数据集验证的高性能晴空辐射、照度和光合有效辐射模型
Sol. Energy, 82 (2008), pp. 272-285, [10.1016/j.solener.2007.04.008](https://doi.org/10.1016/j.solener.2007.04.008)
19.  [Hanan and Bégué, 1995](#bb0100)
N.P. Hanan, A. Bégué
使用半球形传感器估算瞬时和每日截获的光合有效辐射的方法
Agric. for. Meteorol., 74 (1995), pp. 155-168, [10.1016/0168-1923(94)02196-Q](https://doi.org/10.1016/0168-1923(94)02196-Q)
20.  [He et al., 2017](#bb0105)
J.Q. He, R.J. Harrison, B. Li
一种用于草莓表型分析的新型3D成像系统
Plant Methods, 13 (2017), pp. 1-8, [10.1186/s13007-017-0243-x](https://doi.org/10.1186/s13007-017-0243-x)
21.  [Hu et al., 2022](#bb0115)
W. Hu, Y. Su, J. Zhou, H. Zhu, J. Guo, H. Huo, H. Gong
叶面喷施硅和硒改善田间条件下黄瓜的生长、产量和品质特性
Sci. Hortic., Amsterdam). 294 (2022), Article 110776, [10.1016/j.scienta.2021.110776](https://doi.org/10.1016/j.scienta.2021.110776)
22.  [Huang et al., 2022](#bb0120)
R. Huang, W. Yao, Z. Xu, L. Cao, X. Shen
基于无人机数字相机和激光雷达协同系统的高原山地森林生物量估算信息融合方法
Comput. Electron. Agric., 202 (2022), Article 107420, [10.1016/j.compag.2022.107420](https://doi.org/10.1016/j.compag.2022.107420)
23.  [Itakura and Hosoi, 2018](#bb0125)
K. Itakura, F. Hosoi
3D植物图像中自动叶片分割用于估算叶面积和叶片倾角
Sensors (switzerland), 18 (2018), [10.3390/s18103576](https://doi.org/10.3390/s18103576)
24.  [Jiao et al., 2024](#bb0130)
Y. Jiao, C. Chen, G. Li, H. Fu, X. Mi
日光温室土壤温度变化规律及预测模型研究
Sol. Energy, 270 (2024), Article 112267, [10.1016/j.solener.2023.112267](https://doi.org/10.1016/j.solener.2023.112267)
25.  [Jin et al., 2018](#bb0135)
S. Jin, Y. Su, S. Gao, F. Wu, T. Hu, J. Liu, W. Li, D. Wang, S. Chen, Y. Jiang, S. Pang, Q. Guo
深度学习：使用Faster R-CNN和区域生长算法从地面激光雷达数据中分割单个玉米植株
Front. Plant Sci., 9 (2018), pp. 1-10, [10.3389/fpls.2018.00866](https://doi.org/10.3389/fpls.2018.00866)
26.  [Kahlen et al., 2008](#bb0145)
K. Kahlen, D. Wiechers, H. Stützel
黄瓜冠层叶片向光性建模
Funct. Plant Biol., 35 (2008), p. 876, [10.1071/FP08034](https://doi.org/10.1071/FP08034)
27.  [Kim et al., 2020](#bb0150)
D. Kim, W.H. Kang, I. Hwang, J. Kim, J.H. Kim, K.S. Park, J.E. Son
使用结构精确的3D植物模型估算甜椒(Capsicum annuum)的光截获和光合作用
Comput. Electron. Agric., 177 (2020), Article 105689, [10.1016/j.compag.2020.105689](https://doi.org/10.1016/j.compag.2020.105689)
28.  [Knowling et al., 2021](#bb0155)
M.J. Knowling, B. Bennett, B. Ostendorf, S. Westra, R.R. Walker, A. Pellegrino, E.J. Edwards, C. Collins, V. Pagay, D. Grigg
连接数据与决策的桥梁：葡萄栽培过程模型综述
Agric. Syst., 193 (2021), Article 103209, [10.1016/j.agsy.2021.103209](https://doi.org/10.1016/j.agsy.2021.103209)
29.  [Kochi et al., 2021](#bb0160)
N. Kochi, S. Isobe, A. Hayashi, K. Kodama, T. Tanabata
植物研究全方位3D建模方法介绍
Int. J. Autom. Technol., 15 (2021), pp. 301-312, [10.20965/ijat.2021.p0301](https://doi.org/10.20965/ijat.2021.p0301)
30.  [Korir et al., 2013](#bb0165)
N.K. Korir, J. Han, L. Shangguan, C. Wang, E. Kayesh, Y. Zhang, J. Fang
植物品种和栽培品种鉴定：进展与展望
Crit. Rev. Biotechnol., 33 (2013), pp. 111-125, [10.3109/07388551.2012.675314](https://doi.org/10.3109/07388551.2012.675314)
31.  [La Notte et al., 2020](#bb0170)
L. La Notte, L. Giordano, E. Calabrò, R. Bedini, G. Colla, G. Puglisi, A. Reale
混合和有机光伏在温室中的应用
Appl. Energy, 278 (2020), [10.1016/j.apenergy.2020.115582](https://doi.org/10.1016/j.apenergy.2020.115582)
32.  [Lai et al., 2020](#bb0175)
Lai, Y., Qian, T., Li, G., Lu, S., 2020. &lt;i&gt;基于多视角立体重建和分析黄瓜结构特征&lt;/i&gt;, in: 2020 ASABE Annual International Virtual Meeting, July 13-15, 2020. American Society of Agricultural and Biological Engineers, St. Joseph, MI. Doi: 10.13031/aim.202001365.
33.  [Li et al., 2023a](#bb0180)
M. Li, P. Hu, D. He, B. Zheng, Y. Guo, Y. Wu, T. Duan
使用无人机量化玉米-大豆间作系统的累积遮荫能力
Plant Phenomics, 5 (2023), pp. 1-16, [10.34133/plantphenomics.0095](https://doi.org/10.34133/plantphenomics.0095)
34.  [Li et al., 2023b](#bb0185)
Z. Li, G. Li, T.H. Li, S. Liu, W. Gao
语义点云上采样
IEEE Trans. Multimed., 25 (2023), pp. 3432-3442, [10.1109/TMM.2022.3160604](https://doi.org/10.1109/TMM.2022.3160604)
35.  [Li et al., 2021](#bb0190)
S. Li, W. Van Der Werf, J. Zhu, Y. Guo, B. Li, Y. Ma, J.B. Evers
估算植物性状对玉米/大豆间作系统中光分配的贡献
J. Exp. Bot., 72 (2021), pp. 3630-3646, [10.1093/jxb/erab077](https://doi.org/10.1093/jxb/erab077)
36.  [Li et al., 2022](#bb0195)
Y. Li, W. Wen, T. Miao, S. Wu, Z. Yu, X. Wang, X. Guo, C. Zhao
通过整合高通量数据采集和深度学习实现玉米植株器官级点云自动分割
Comput. Electron. Agric., 193 (2022), Article 106702, [10.1016/j.compag.2022.106702](https://doi.org/10.1016/j.compag.2022.106702)
37.  [Li et al., 2024](#bb0200)
Y. Li, M. Henke, D. Zhang, C. Wang, M. Wei
中国日光温室番茄生产优化：东西走向和宽行距的影响
Agronomy, 14 (2024), p. 314, [10.3390/agronomy14020314](https://doi.org/10.3390/agronomy14020314)
38.  [Liu et al., 2021b](#bb0205)
X. Liu, J. Chen, X. Zhang
黄瓜茎枝结构的遗传调控
Hortic. Res., 8 (2021), [10.1038/s41438-021-00577-0](https://doi.org/10.1038/s41438-021-00577-0)
39.  [Liu et al., 2023](#bb0210)
Z. Liu, S. Jin, X. Liu, Q. Yang, Q. Li, J. Zang, Z. Li, T. Hu, Z. Guo, J. Wu, D. Jiang, Y. Su
从田间采集的激光雷达数据中提取小麦穗表型及其与产量的关系探索
IEEE Trans. Geosci. Remote Sens., 61 (2023), p. 1, [10.1109/TGRS.2023.3333344](https://doi.org/10.1109/TGRS.2023.3333344)
40.  [Liu et al., 2021a](#bb0215)
F. Liu, Q. Song, J. Zhao, L. Mao, H. Bu, Y. Hu, X. Zhu
冠层占据体积作为冠层光合能力的指标
New Phytol., 232 (2021), pp. 941-956, [10.1111/nph.17611](https://doi.org/10.1111/nph.17611)
41.  [Liu et al., 2024](#bb0220)
T. Liu, S. Zhu, T. Yang, W. Zhang, Y. Xu, K. Zhou, W. Wu, Y. Zhao, Z. Yao, G. Yang, Y. Wang, C. Sun, J. Sun
结合无人机倾斜摄影和激光雷达冠层动态特征的玉米高度估算
Comput. Electron. Agric., 218 (2024), Article 108685, [10.1016/j.compag.2024.108685](https://doi.org/10.1016/j.compag.2024.108685)
42.  [Maphosa et al., 2016](#bb0225)
L. Maphosa, E. Thoday-Kennedy, J. Vakani, A. Phelan, P. Badenhorst, A. Slater, G. Spangenberg, S. Kant
使用3D激光扫描仪在盐胁迫条件下对小麦进行表型分析
Isr. J. Plant Sci., 1–8 (2016), [10.1080/07929978.2016.1243405](https://doi.org/10.1080/07929978.2016.1243405)
43.  [Medjkane et al., 2018](#bb0230)
M. Medjkane, O. Maquaire, S. Costa, T. Roulland, P. Letortu, C. Fauchard, R. Antoine, R. Davidson
复杂海岸形态变化的高分辨率监测：SfM和TLS调查的交叉效率（法国诺曼底Vaches-Noires悬崖）
Landslides, 15 (2018), pp. 1097-1108, [10.1007/s10346-017-0942-4](https://doi.org/10.1007/s10346-017-0942-4)
44.  [Miao et al., 2023](#bb0235)
Y. Miao, S. Li, L. Wang, H. Li, R. Qiu, M. Zhang
基于欧式聚类和K-means聚类的玉米单株点云分割方法
Comput. Electron. Agric., 210 (2023), Article 107951, [10.1016/j.compag.2023.107951](https://doi.org/10.1016/j.compag.2023.107951)
45.  [Mitsanis et al., 2024](#bb0240)
C. Mitsanis, W. Hurst, B. Tekinerdogan
农业数字孪生的3D功能植物建模框架
Comput. Electron. Agric., 218 (2024), Article 108733, [10.1016/j.compag.2024.108733](https://doi.org/10.1016/j.compag.2024.108733)
46.  [Niinemets, 2010](#bb0245)
Ü. Niinemets
从叶片到冠层的光截获综述：不同植物功能类型和耐荫性物种的比较
Ecol. Res., 25 (2010), pp. 693-714, [10.1007/s11284-010-0712-4](https://doi.org/10.1007/s11284-010-0712-4)
47.  [Patil et al., 2018](#bb0250)
P. Patil, P. Biradar, U. Bhagawathi, A., S. Hejjegar, I.
园艺作物叶面积指数及其重要性的综述
Int. J. Curr. Microbiol. Appl. Sci., 7 (2018), pp. 505-513, [10.20546/ijcmas.2018.704.059](https://doi.org/10.20546/ijcmas.2018.704.059)
48.  [Qian et al., 2014](#bb0255)
Qian, T. ting, Lu, S. lian, Zhao, C. jiang, Guo, X. yu, Wen, W. liang, Du, jian jun, 2014. 日光温室黄瓜冠层异质性分析. J. Integr. Agric. 13, 2645–2655. Doi: 10.1016/S2095-3119(14)60776-0.
49.  [Qian et al., 2019](#bb0260)
T. Qian, X. Zheng, X. Guo, W. Wen, J. Yang, S. Lu
温度和光照梯度对黄瓜冠层叶片排列和几何形状的影响：结构表型分析与建模
Inf. Process. Agric., 6 (2019), pp. 224-232, [10.1016/j.inpa.2018.11.002](https://doi.org/10.1016/j.inpa.2018.11.002)
50.  [Raj et al., 2020](#bb0265)
T. Raj, F.H. Hashim, A.B. Huddin, M.F. Ibrahim, A. Hussain
激光雷达扫描机制综述
Electron., 9 (2020), [10.3390/electronics9050741](https://doi.org/10.3390/electronics9050741)
51.  [Song et al., 2023](#bb0270)
Q. Song, F. Liu, H. Bu, X.G. Zhu
量化两个玉米品种冠层光合作用中不同因素的贡献：一种新型3D冠层建模流程的开发
Plant Phenomics, 5 (2023), pp. 1-16, [10.34133/plantphenomics.0075](https://doi.org/10.34133/plantphenomics.0075)
52.  [Soualiou et al., 2021](#bb0275)
S. Soualiou, Z. Wang, W. Sun, P. de Reffye, B. Collins, G. Louarn, Y. Song
功能-结构植物模型在作物科学进步中的使命：机遇与前景
Front. Plant Sci., 12 (2021), [10.3389/fpls.2021.747142](https://doi.org/10.3389/fpls.2021.747142)
53.  [Sun et al., 2021](#bb0280)
S. Sun, C. Li, P.W. Chee, A.H. Paterson, C. Meng, J. Zhang, P. Ma, J.S. Robertson, J. Adhikari
高分辨率3D地面激光雷达用于棉花主茎和节位检测
Comput. Electron. Agric., 187 (2021), Article 106276, [10.1016/j.compag.2021.106276](https://doi.org/10.1016/j.compag.2021.106276)
54.  [Sun et al., 2023](#bb0285)
C. Sun, L.X. Miao, M.Y. Wang, J. Shi, J.J. Ding
反射区域点云孔洞填补与3D重建研究
Sci. Rep., 13 (2023), pp. 1-18, [10.1038/s41598-023-45648-5](https://doi.org/10.1038/s41598-023-45648-5)
55.  [Tao et al., 2016](#bb0300)
L. Tao, Z. Yu-Qi, Z. Yi, R.-F. Cheng, Y. Qi-Chang
中国日光温室内光分布及其对植物生长的影响
Int. J. Hortic. Sci. Technol., 3 (2016), pp. 99-111, [10.22059/ijhst.2017.61273](https://doi.org/10.22059/ijhst.2017.61273)
56.  [Tu et al., 2023](#bb0305)
K. Tu, W. Wu, Y. Cheng, H. Zhang, Y. Xu, X. Dong, M. Wang, Q. Sun
AIseed：用于高通量表型和单粒种子质量无损检测的自动化图像分析软件
Comput. Electron. Agric., 207 (2023), Article 107740, [10.1016/j.compag.2023.107740](https://doi.org/10.1016/j.compag.2023.107740)
57.  [Wang and Fang, 2020](#bb0310)
Y. Wang, H. Fang
基于激光雷达技术的叶面积指数估算研究综述
Remote Sens., 12 (2020), pp. 1-28, [10.3390/rs12203457](https://doi.org/10.3390/rs12203457)
58.  [Wang et al., 2023](#bb0315)
X. Wang, J. Hua, M. Kang, H. Wang, P. de Reffye
功能-结构植物模型"GreenLab"研究进展综述
Plant Phenomics (2023), [10.34133/plantphenomics.0118](https://doi.org/10.34133/plantphenomics.0118)
59.  [Wang et al., 2018](#bb0320)
Y. Wang, W. Wen, S. Wu, C. Wang, Z. Yu, X. Guo, C. Zhao
玉米植株表型分析：3D激光扫描、多视角立体重建和3D数字化估算的比较
Remote Sens., 11 (2018), p. 63, [10.3390/rs11010063](https://doi.org/10.3390/rs11010063)
60.  [Wu and Yang, 2007](#bb0330)
K.L. Wu, M.S. Yang
基于均值漂移的聚类方法
Pattern Recognit., 40 (2007), pp. 3035-3052, [10.1016/j.patcog.2007.02.006](https://doi.org/10.1016/j.patcog.2007.02.006)
61.  [Wu et al., 2020](#bb0335)
W. Wu, K. Zhang, H. Zhu
基于3D点云和快速k-means++与快速轮廓算法的岩体不连续面方向快速自动提取方法
IOP Conf. Ser. Earth Environ. Sci., 570 (2020), [10.1088/1755-1315/570/5/052075](https://doi.org/10.1088/1755-1315/570/5/052075)
62.  [Xiao et al., 2021](#bb0340)
S. Xiao, H. Chai, Q. Wang, K. Shao, L. Meng, R. Wang, B. Li, Y. Ma
基于三维计算机视觉的甜菜经济效益评估：以中国内蒙古为例
Eur. J. Agronomy, 130 (2021), [10.1016/j.eja.2021.126378](https://doi.org/10.1016/j.eja.2021.126378)
63.  [Xiao et al., 2023a](#bb0345)
S. Xiao, S. Fei, Q. Li, B. Zhang, H. Chen, D. Xu, Z. Cai, K. Bi, Y. Guo, B. Li, Z. Chen, Y. Ma
使用真实3D冠层模型计算田间光截获的重要性
Plant Phenomics, 5 (2023), [10.34133/plantphenomics.0082](https://doi.org/10.34133/plantphenomics.0082)
64.  [Xiao et al., 2023b](#bb0350)
S. Xiao, Y. Ye, S. Fei, H. Chen, zhang, B., li, Q., Cai, Z., Che, Y., Wang, Q., Ghafoor, A.Z., Bi, K., Shao, K., Wang, R., Guo, Y., Li, B., Zhang, R., Chen, Z., Ma, Y.
基于无人机RGB相机先进交叉环绕航线和重建精确3D冠层结构的器官尺度性状高通量计算方法
ISPRS J. Photogrammetry and Remote Sens., 201 (2023), pp. 104-122, [10.1016/j.isprsjprs.2023.05.016](https://doi.org/10.1016/j.isprsjprs.2023.05.016)
65.  [Zareef et al., 2021](#bb0360)
M. Zareef, M. Arslan, M.M. Hassan, W. Ahmad, S. Ali, H. Li, Q. Ouyang, X. Wu, M.M. Hashim, Q. Chen
利用无损技术评估谷物质量和数量特征的最新进展：综述
Trends Food Sci. Technol., 116 (2021), pp. 815-828, [10.1016/j.tifs.2021.08.012](https://doi.org/10.1016/j.tifs.2021.08.012)
66.  [Zhang et al., 2021](#bb0365)
J. Zhang, S. Feng, J. Yuan, C. Wang, T. Lu, H. Wang, C. Yu
黄瓜(Cucumis sativus L.)果实品质形成研究
Front. Plant Sci., 12 (2021), pp. 1-10, [10.3389/fpls.2021.729448](https://doi.org/10.3389/fpls.2021.729448)
67.  [Zhang et al., 2016](#bb0370)
W. Zhang, J. Qi, P. Wan, H. Wang, D. Xie, X. Wang, G. Yan
基于布料模拟的机载LiDAR数据简易滤波方法
Remote Sens., 8 (2016), pp. 1-22, [10.3390/rs8060501](https://doi.org/10.3390/rs8060501)
68.  [Zhang et al., 2022](#bb0375)
Y. Zhang, J. Yang, M. Van Haaften, L. Li, S. Lu, W. Wen, X. Zheng, J. Pan, T. Qian
漫射光与黄瓜(Cucumis sativus L.)冠层结构的相互作用：虚拟冠层中的光截获模拟
Agronomy, 12 (2022), [10.3390/agronomy12030602](https://doi.org/10.3390/agronomy12030602)
69.  [Zhao et al., 2019](#bb0380)
H. Zhao, X. Zhai, L. Guo, Y. Yang, J. Li, C. Ren, K. Wang, X. Liu, R. Zhan, K. Wang
基于能值分析的中国设施黄瓜与露地黄瓜生产系统比较
J. Clean. Prod., 236 (2019), Article 117648, [10.1016/j.jclepro.2019.117648](https://doi.org/10.1016/j.jclepro.2019.117648)

## References

1.  [Bailey, 2018](#bb0005)
B.N. Bailey
A reverse ray-tracing method for modelling the net radiative flux in leaf-resolving plant canopy simulations
Ecol. Modell., 368 (2018), pp. 233-245, [10.1016/j.ecolmodel.2017.11.022](https://doi.org/10.1016/j.ecolmodel.2017.11.022)
2.  [Bailey, 2019](#bb0010)
B.N. Bailey
Helios: A scalable 3D plant and environmental biophysical modeling framework
Front. Plant Sci., 10 (2019), pp. 1-17, [10.3389/fpls.2019.01185](https://doi.org/10.3389/fpls.2019.01185)
3.  [Barber et al., 1996](#bb0015)
C.B. Barber, D.P. Dobkin, H. Huhdanpaa
The quickhull algorithm for convex hulls
ACM Trans. Math. Softw., 22 (1996), pp. 469-483, [10.1145/235815.235821](https://doi.org/10.1145/235815.235821)
4.  [Bi et al., 2022](#bb0020)
K. Bi, S. Gao, S. Xiao, C. Zhang, J. Bai, N. Huang, G. Sun, Z. Niu
N distribution characterization based on organ-level biomass and N concentration using a hyperspectral lidar
Comput. Electron. Agric., 199 (2022), Article 107165, [10.1016/j.compag.2022.107165](https://doi.org/10.1016/j.compag.2022.107165)
5.  [Boogaard et al., 2021](#bb0025)
F.P. Boogaard, E.J. van Henten, G. Kootstra
Boosting plant-part segmentation of cucumber plants by enriching incomplete 3D point clouds with spectral data
Biosyst. Eng., 211 (2021), pp. 167-182, [10.1016/j.biosystemseng.2021.09.004](https://doi.org/10.1016/j.biosystemseng.2021.09.004)
6.  [Boogaard et al., 2023](#bb0030)
F.P. Boogaard, E.J. van Henten, G. Kootstra
The added value of 3D point clouds for digital plant phenotyping – A case study on internode length measurements in cucumber
Biosyst. Eng., 234 (2023), pp. 1-12, [10.1016/j.biosystemseng.2023.08.010](https://doi.org/10.1016/j.biosystemseng.2023.08.010)
7.  [Cabo et al., 2018](#bb0035)
C. Cabo, S. Del Pozo, P. Rodríguez-Gonzálvez, C. Ordóñez, D. González-Aguilera
Comparing terrestrial laser scanning (TLS) and wearable laser scanning (WLS) for individual tree modeling at plot level
Remote Sens., 10 (2018), [10.3390/rs10040540](https://doi.org/10.3390/rs10040540)
8.  [Cao et al., 2022](#bb0040)
Y. Cao, Y. Wang, Y. Xue, H. Zhang, Y. Lao
FEC: fast euclidean clustering for point cloud segmentation
Drones, 6 (2022), pp. 1-18, [10.3390/drones6110325](https://doi.org/10.3390/drones6110325)
9.  [Caya et al., 2018](#bb0045)
M.V.C. Caya, J.T. Alcantara, J.S. Carlos, S.S.B. Cereno
Photosynthetically Active Radiation (PAR) Sensor Using an Array of Light Sensors with the Integration of Data Logging for Agricultural Application. 2018 3rd Int
Conf. Comput. Commun. Syst. ICCCS, 2018 (2018), pp. 431-435, [10.1109/CCOMS.2018.8463321](https://doi.org/10.1109/CCOMS.2018.8463321)
10.  [Chen et al., 2014](#bb0050)
T.W. Chen, M. Henke, P.H.B. De Visser, G. Buck-Sorlin, D. Wiechers, K. Kahlen, H. Stützel
What is the most prominent factor limiting photosynthesis in different layers of a greenhouse cucumber canopy?
Ann. Bot., 114 (2014), pp. 677-688, [10.1093/aob/mcu100](https://doi.org/10.1093/aob/mcu100)
11.  [Chen et al., 2023](#bb0055)
H. Chen, S. Liu, C. Wang, C. Wang, K. Gong, Y. Li, Y. Lan
Point cloud completion of plant leaves under occlusion conditions based on deep learning
Plant Phenomics, 5 (2023), pp. 1-12, [10.34133/plantphenomics.0117](https://doi.org/10.34133/plantphenomics.0117)
12.  [Chen et al., 1994](#bb0060)
S.G. Chen, B.Y. Shao, I. Impens, R. Ceulemans
Effects of plant canopy structure on light interception and photosynthesis
J. Quant. Spectrosc. Radiat. Transf., 52 (1994), pp. 115-123, [10.1016/0022-4073(94)90144-9](https://doi.org/10.1016/0022-4073(94)90144-9)
13.  [Cho et al., 2007](#bb0065)
Y.Y. Cho, S. Oh, M.M. Oh, J.E. Son
Estimation of individual leaf area, fresh weight, and dry weight of hydroponically grown cucumbers (Cucumis sativus L.) using leaf length, width, and SPAD value
Sci. Hortic. (amsterdam), 111 (2007), pp. 330-334, [10.1016/j.scienta.2006.12.028](https://doi.org/10.1016/j.scienta.2006.12.028)
14.  [Chum and Matas, 2008](#bb0070)
O. Chum, J. Matas
Optimal randomized RANSAC
IEEE Trans. Pattern Anal. Mach. Intell., 30 (2008), pp. 1472-1482, [10.1109/TPAMI.2007.70787](https://doi.org/10.1109/TPAMI.2007.70787)
15.  [Deans et al., 2020](#bb0075)
R.M. Deans, T.J. Brodribb, F.A. Busch, G.D. Farquhar
Optimization can provide the fundamental link between leaf photosynthesis, gas exchange and water relations
Nat. Plants, 6 (2020), pp. 1116-1125, [10.1038/s41477-020-00760-6](https://doi.org/10.1038/s41477-020-00760-6)
16.  [Dechant et al., 2020](#bb0080)
B. Dechant, Y. Ryu, G. Badgley, Y. Zeng, J.A. Berry, Y. Zhang, Y. Goulas, Z. Li, Q. Zhang, M. Kang, J. Li, I. Moya
Canopy structure explains the relationship between photosynthesis and sun-induced chlorophyll fluorescence in crops
Remote Sens. Environ., 241 (2020), [10.1016/j.rse.2020.111733](https://doi.org/10.1016/j.rse.2020.111733)
17.  [Grimstad et al., 2018](#bb0090)
L. Grimstad, R. Zakaria, T. Dung Le, P.J. From
A novel autonomous robot for greenhouse applications
IEEE Int. Conf. Intell. Robot. Syst., 8270–8277 (2018), [10.1109/IROS.2018.8594233](https://doi.org/10.1109/IROS.2018.8594233)
18.  [Gueymard, 2008](#bb0095)
C.A. Gueymard
REST2: High-performance solar radiation model for cloudless-sky irradiance, illuminance, and photosynthetically active radiation - Validation with a benchmark dataset
Sol. Energy, 82 (2008), pp. 272-285, [10.1016/j.solener.2007.04.008](https://doi.org/10.1016/j.solener.2007.04.008)
19.  [Hanan and Bégué, 1995](#bb0100)
N.P. Hanan, A. Bégué
A method to estimate instantaneous and daily intercepted photosynthetically active radiation using a hemispherical sensor
Agric. for. Meteorol., 74 (1995), pp. 155-168, [10.1016/0168-1923(94)02196-Q](https://doi.org/10.1016/0168-1923(94)02196-Q)
20.  [He et al., 2017](#bb0105)
J.Q. He, R.J. Harrison, B. Li
A novel 3D imaging system for strawberry phenotyping
Plant Methods, 13 (2017), pp. 1-8, [10.1186/s13007-017-0243-x](https://doi.org/10.1186/s13007-017-0243-x)
21.  [Hu et al., 2022](#bb0115)
W. Hu, Y. Su, J. Zhou, H. Zhu, J. Guo, H. Huo, H. Gong
Foliar application of silicon and selenium improves the growth, yield and quality characteristics of cucumber in field conditions
Sci. Hortic., Amsterdam). 294 (2022), Article 110776, [10.1016/j.scienta.2021.110776](https://doi.org/10.1016/j.scienta.2021.110776)
22.  [Huang et al., 2022](#bb0120)
R. Huang, W. Yao, Z. Xu, L. Cao, X. Shen
Information fusion approach for biomass estimation in a plateau mountainous forest using a synergistic system comprising UAS-based digital camera and LiDAR
Comput. Electron. Agric., 202 (2022), Article 107420, [10.1016/j.compag.2022.107420](https://doi.org/10.1016/j.compag.2022.107420)
23.  [Itakura and Hosoi, 2018](#bb0125)
K. Itakura, F. Hosoi
Automatic leaf segmentation for estimating leaf area and leaf inclination angle in 3D plant images
Sensors (switzerland), 18 (2018), [10.3390/s18103576](https://doi.org/10.3390/s18103576)
24.  [Jiao et al., 2024](#bb0130)
Y. Jiao, C. Chen, G. Li, H. Fu, X. Mi
Research on the variation patterns and predictive models of soil temperature in a solar greenhouse
Sol. Energy, 270 (2024), Article 112267, [10.1016/j.solener.2023.112267](https://doi.org/10.1016/j.solener.2023.112267)
25.  [Jin et al., 2018](#bb0135)
S. Jin, Y. Su, S. Gao, F. Wu, T. Hu, J. Liu, W. Li, D. Wang, S. Chen, Y. Jiang, S. Pang, Q. Guo
Deep learning: Individual maize segmentation from terrestrial lidar data using faster R-CNN and regional growth algorithms
Front. Plant Sci., 9 (2018), pp. 1-10, [10.3389/fpls.2018.00866](https://doi.org/10.3389/fpls.2018.00866)
26.  [Kahlen et al., 2008](#bb0145)
K. Kahlen, D. Wiechers, H. Stützel
Modelling leaf phototropism in a cucumber canopy
Funct. Plant Biol., 35 (2008), p. 876, [10.1071/FP08034](https://doi.org/10.1071/FP08034)
27.  [Kim et al., 2020](#bb0150)
D. Kim, W.H. Kang, I. Hwang, J. Kim, J.H. Kim, K.S. Park, J.E. Son
Use of structurally-accurate 3D plant models for estimating light interception and photosynthesis of sweet pepper (Capsicum annuum) plants
Comput. Electron. Agric., 177 (2020), Article 105689, [10.1016/j.compag.2020.105689](https://doi.org/10.1016/j.compag.2020.105689)
28.  [Knowling et al., 2021](#bb0155)
M.J. Knowling, B. Bennett, B. Ostendorf, S. Westra, R.R. Walker, A. Pellegrino, E.J. Edwards, C. Collins, V. Pagay, D. Grigg
Bridging the gap between data and decisions: A review of process-based models for viticulture
Agric. Syst., 193 (2021), Article 103209, [10.1016/j.agsy.2021.103209](https://doi.org/10.1016/j.agsy.2021.103209)
29.  [Kochi et al., 2021](#bb0160)
N. Kochi, S. Isobe, A. Hayashi, K. Kodama, T. Tanabata
Introduction of all-around 3d modeling methods for investigation of plants
Int. J. Autom. Technol., 15 (2021), pp. 301-312, [10.20965/ijat.2021.p0301](https://doi.org/10.20965/ijat.2021.p0301)
30.  [Korir et al., 2013](#bb0165)
N.K. Korir, J. Han, L. Shangguan, C. Wang, E. Kayesh, Y. Zhang, J. Fang
Plant variety and cultivar identification: advances and prospects
Crit. Rev. Biotechnol., 33 (2013), pp. 111-125, [10.3109/07388551.2012.675314](https://doi.org/10.3109/07388551.2012.675314)
31.  [La Notte et al., 2020](#bb0170)
L. La Notte, L. Giordano, E. Calabrò, R. Bedini, G. Colla, G. Puglisi, A. Reale
Hybrid and organic photovoltaics for greenhouse applications
Appl. Energy, 278 (2020), [10.1016/j.apenergy.2020.115582](https://doi.org/10.1016/j.apenergy.2020.115582)
32.  [Lai et al., 2020](#bb0175)
Lai, Y., Qian, T., Li, G., Lu, S., 2020. &lt;i&gt;Reconstruction and analysis of cucumber structural traits with Multi-View Stereo&lt;/i&gt;, in: 2020 ASABE Annual International Virtual Meeting, July 13-15, 2020. American Society of Agricultural and Biological Engineers, St. Joseph, MI. Doi: 10.13031/aim.202001365.
33.  [Li et al., 2023a](#bb0180)
M. Li, P. Hu, D. He, B. Zheng, Y. Guo, Y. Wu, T. Duan
Quantification of the cumulative shading capacity in a maize–soybean intercropping system using an unmanned aerial vehicle
Plant Phenomics, 5 (2023), pp. 1-16, [10.34133/plantphenomics.0095](https://doi.org/10.34133/plantphenomics.0095)
34.  [Li et al., 2023b](#bb0185)
Z. Li, G. Li, T.H. Li, S. Liu, W. Gao
Semantic point cloud upsampling
IEEE Trans. Multimed., 25 (2023), pp. 3432-3442, [10.1109/TMM.2022.3160604](https://doi.org/10.1109/TMM.2022.3160604)
35.  [Li et al., 2021](#bb0190)
S. Li, W. Van Der Werf, J. Zhu, Y. Guo, B. Li, Y. Ma, J.B. Evers
Estimating the contribution of plant traits to light partitioning in simultaneous maize/soybean intercropping
J. Exp. Bot., 72 (2021), pp. 3630-3646, [10.1093/jxb/erab077](https://doi.org/10.1093/jxb/erab077)
36.  [Li et al., 2022](#bb0195)
Y. Li, W. Wen, T. Miao, S. Wu, Z. Yu, X. Wang, X. Guo, C. Zhao
Automatic organ-level point cloud segmentation of maize shoots by integrating high-throughput data acquisition and deep learning
Comput. Electron. Agric., 193 (2022), Article 106702, [10.1016/j.compag.2022.106702](https://doi.org/10.1016/j.compag.2022.106702)
37.  [Li et al., 2024](#bb0200)
Y. Li, M. Henke, D. Zhang, C. Wang, M. Wei
Optimized tomato production in Chinese solar greenhouses: the impact of an east–west orientation and wide row spacing
Agronomy, 14 (2024), p. 314, [10.3390/agronomy14020314](https://doi.org/10.3390/agronomy14020314)
38.  [Liu et al., 2021b](#bb0205)
X. Liu, J. Chen, X. Zhang
Genetic regulation of shoot architecture in cucumber
Hortic. Res., 8 (2021), [10.1038/s41438-021-00577-0](https://doi.org/10.1038/s41438-021-00577-0)
39.  [Liu et al., 2023](#bb0210)
Z. Liu, S. Jin, X. Liu, Q. Yang, Q. Li, J. Zang, Z. Li, T. Hu, Z. Guo, J. Wu, D. Jiang, Y. Su
Extraction of wheat spike phenotypes from field-collected lidar data and exploration of their relationships with wheat yield
IEEE Trans. Geosci. Remote Sens., 61 (2023), p. 1, [10.1109/TGRS.2023.3333344](https://doi.org/10.1109/TGRS.2023.3333344)
40.  [Liu et al., 2021a](#bb0215)
F. Liu, Q. Song, J. Zhao, L. Mao, H. Bu, Y. Hu, X. Zhu
Canopy occupation volume as an indicator of canopy photosynthetic capacity
New Phytol., 232 (2021), pp. 941-956, [10.1111/nph.17611](https://doi.org/10.1111/nph.17611)
41.  [Liu et al., 2024](#bb0220)
T. Liu, S. Zhu, T. Yang, W. Zhang, Y. Xu, K. Zhou, W. Wu, Y. Zhao, Z. Yao, G. Yang, Y. Wang, C. Sun, J. Sun
Maize height estimation using combined unmanned aerial vehicle oblique photography and LIDAR canopy dynamic characteristics
Comput. Electron. Agric., 218 (2024), Article 108685, [10.1016/j.compag.2024.108685](https://doi.org/10.1016/j.compag.2024.108685)
42.  [Maphosa et al., 2016](#bb0225)
L. Maphosa, E. Thoday-Kennedy, J. Vakani, A. Phelan, P. Badenhorst, A. Slater, G. Spangenberg, S. Kant
Phenotyping wheat under salt stress conditions using a 3D laser scanner
Isr. J. Plant Sci., 1–8 (2016), [10.1080/07929978.2016.1243405](https://doi.org/10.1080/07929978.2016.1243405)
43.  [Medjkane et al., 2018](#bb0230)
M. Medjkane, O. Maquaire, S. Costa, T. Roulland, P. Letortu, C. Fauchard, R. Antoine, R. Davidson
High-resolution monitoring of complex coastal morphology changes: cross-efficiency of SfM and TLS-based survey (Vaches-Noires cliffs, Normandy, France)
Landslides, 15 (2018), pp. 1097-1108, [10.1007/s10346-017-0942-4](https://doi.org/10.1007/s10346-017-0942-4)
44.  [Miao et al., 2023](#bb0235)
Y. Miao, S. Li, L. Wang, H. Li, R. Qiu, M. Zhang
A single plant segmentation method of maize point cloud based on Euclidean clustering and K-means clustering
Comput. Electron. Agric., 210 (2023), Article 107951, [10.1016/j.compag.2023.107951](https://doi.org/10.1016/j.compag.2023.107951)
45.  [Mitsanis et al., 2024](#bb0240)
C. Mitsanis, W. Hurst, B. Tekinerdogan
A 3D functional plant modelling framework for agricultural digital twins
Comput. Electron. Agric., 218 (2024), Article 108733, [10.1016/j.compag.2024.108733](https://doi.org/10.1016/j.compag.2024.108733)
46.  [Niinemets, 2010](#bb0245)
Ü. Niinemets
A review of light interception in plant stands from leaf to canopy in different plant functional types and in species with varying shade tolerance
Ecol. Res., 25 (2010), pp. 693-714, [10.1007/s11284-010-0712-4](https://doi.org/10.1007/s11284-010-0712-4)
47.  [Patil et al., 2018](#bb0250)
P. Patil, P. Biradar, U. Bhagawathi, A., S. Hejjegar, I.
A review on leaf area index of horticulture crops and its importance
Int. J. Curr. Microbiol. Appl. Sci., 7 (2018), pp. 505-513, [10.20546/ijcmas.2018.704.059](https://doi.org/10.20546/ijcmas.2018.704.059)
48.  [Qian et al., 2014](#bb0255)
Qian, T. ting, Lu, S. lian, Zhao, C. jiang, Guo, X. yu, Wen, W. liang, Du, jian jun, 2014. Heterogeneity Analysis of Cucumber Canopy in the Solar Greenhouse. J. Integr. Agric. 13, 2645–2655. Doi: 10.1016/S2095-3119(14)60776-0.
49.  [Qian et al., 2019](#bb0260)
T. Qian, X. Zheng, X. Guo, W. Wen, J. Yang, S. Lu
Influence of temperature and light gradient on leaf arrangement and geometry in cucumber canopies: Structural phenotyping analysis and modelling
Inf. Process. Agric., 6 (2019), pp. 224-232, [10.1016/j.inpa.2018.11.002](https://doi.org/10.1016/j.inpa.2018.11.002)
50.  [Raj et al., 2020](#bb0265)
T. Raj, F.H. Hashim, A.B. Huddin, M.F. Ibrahim, A. Hussain
A survey on LiDAR scanning mechanisms
Electron., 9 (2020), [10.3390/electronics9050741](https://doi.org/10.3390/electronics9050741)
51.  [Song et al., 2023](#bb0270)
Q. Song, F. Liu, H. Bu, X.G. Zhu
Quantifying contributions of different factors to canopy photosynthesis in 2 maize varieties: development of a novel 3D canopy modeling pipeline
Plant Phenomics, 5 (2023), pp. 1-16, [10.34133/plantphenomics.0075](https://doi.org/10.34133/plantphenomics.0075)
52.  [Soualiou et al., 2021](#bb0275)
S. Soualiou, Z. Wang, W. Sun, P. de Reffye, B. Collins, G. Louarn, Y. Song
Functional–structural plant models mission in advancing crop science: opportunities and prospects
Front. Plant Sci., 12 (2021), [10.3389/fpls.2021.747142](https://doi.org/10.3389/fpls.2021.747142)
53.  [Sun et al., 2021](#bb0280)
S. Sun, C. Li, P.W. Chee, A.H. Paterson, C. Meng, J. Zhang, P. Ma, J.S. Robertson, J. Adhikari
High resolution 3D terrestrial LiDAR for cotton plant main stalk and node detection
Comput. Electron. Agric., 187 (2021), Article 106276, [10.1016/j.compag.2021.106276](https://doi.org/10.1016/j.compag.2021.106276)
54.  [Sun et al., 2023](#bb0285)
C. Sun, L.X. Miao, M.Y. Wang, J. Shi, J.J. Ding
Research on point cloud hole filling and 3D reconstruction in reflective area
Sci. Rep., 13 (2023), pp. 1-18, [10.1038/s41598-023-45648-5](https://doi.org/10.1038/s41598-023-45648-5)
55.  [Tao et al., 2016](#bb0300)
L. Tao, Z. Yu-Qi, Z. Yi, R.-F. Cheng, Y. Qi-Chang
Light distribution in Chinese solar greenhouse and its effect on plant growth
Int. J. Hortic. Sci. Technol., 3 (2016), pp. 99-111, [10.22059/ijhst.2017.61273](https://doi.org/10.22059/ijhst.2017.61273)
56.  [Tu et al., 2023](#bb0305)
K. Tu, W. Wu, Y. Cheng, H. Zhang, Y. Xu, X. Dong, M. Wang, Q. Sun
AIseed: An automated image analysis software for high-throughput phenotyping and quality non-destructive testing of individual plant seeds
Comput. Electron. Agric., 207 (2023), Article 107740, [10.1016/j.compag.2023.107740](https://doi.org/10.1016/j.compag.2023.107740)
57.  [Wang and Fang, 2020](#bb0310)
Y. Wang, H. Fang
Estimation of LAI with the LiDAR technology: A review
Remote Sens., 12 (2020), pp. 1-28, [10.3390/rs12203457](https://doi.org/10.3390/rs12203457)
58.  [Wang et al., 2023](#bb0315)
X. Wang, J. Hua, M. Kang, H. Wang, P. de Reffye
Functional-structural plant model “GreenLab”: A state-of-the-art review
Plant Phenomics (2023), [10.34133/plantphenomics.0118](https://doi.org/10.34133/plantphenomics.0118)
59.  [Wang et al., 2018](#bb0320)
Y. Wang, W. Wen, S. Wu, C. Wang, Z. Yu, X. Guo, C. Zhao
Maize plant phenotyping: comparing 3D laser scanning, multi-view stereo reconstruction, and 3D digitizing estimates
Remote Sens., 11 (2018), p. 63, [10.3390/rs11010063](https://doi.org/10.3390/rs11010063)
60.  [Wu and Yang, 2007](#bb0330)
K.L. Wu, M.S. Yang
Mean shift-based clustering
Pattern Recognit., 40 (2007), pp. 3035-3052, [10.1016/j.patcog.2007.02.006](https://doi.org/10.1016/j.patcog.2007.02.006)
61.  [Wu et al., 2020](#bb0335)
W. Wu, K. Zhang, H. Zhu
A fast automatic extraction method for rock mass discontinuity orientation using fast k-means++ and fast silhouette based on 3D point cloud
IOP Conf. Ser. Earth Environ. Sci., 570 (2020), [10.1088/1755-1315/570/5/052075](https://doi.org/10.1088/1755-1315/570/5/052075)
62.  [Xiao et al., 2021](#bb0340)
S. Xiao, H. Chai, Q. Wang, K. Shao, L. Meng, R. Wang, B. Li, Y. Ma
Estimating economic benefit of sugar beet based on three-dimensional computer vision: a case study in Inner Mongolia, China
Eur. J. Agronomy, 130 (2021), [10.1016/j.eja.2021.126378](https://doi.org/10.1016/j.eja.2021.126378)
63.  [Xiao et al., 2023a](#bb0345)
S. Xiao, S. Fei, Q. Li, B. Zhang, H. Chen, D. Xu, Z. Cai, K. Bi, Y. Guo, B. Li, Z. Chen, Y. Ma
The importance of using realistic 3D canopy models to calculate light interception in the field
Plant Phenomics, 5 (2023), [10.34133/plantphenomics.0082](https://doi.org/10.34133/plantphenomics.0082)
64.  [Xiao et al., 2023b](#bb0350)
S. Xiao, Y. Ye, S. Fei, H. Chen, zhang, B., li, Q., Cai, Z., Che, Y., Wang, Q., Ghafoor, A.Z., Bi, K., Shao, K., Wang, R., Guo, Y., Li, B., Zhang, R., Chen, Z., Ma, Y.
High-throughput calculation of organ-scale traits with reconstructed accurate 3D canopy structures using a UAV RGB camera with an advanced cross-circling oblique route
ISPRS J. Photogrammetry and Remote Sens., 201 (2023), pp. 104-122, [10.1016/j.isprsjprs.2023.05.016](https://doi.org/10.1016/j.isprsjprs.2023.05.016)
65.  [Zareef et al., 2021](#bb0360)
M. Zareef, M. Arslan, M.M. Hassan, W. Ahmad, S. Ali, H. Li, Q. Ouyang, X. Wu, M.M. Hashim, Q. Chen
Recent advances in assessing qualitative and quantitative aspects of cereals using nondestructive techniques: A review
Trends Food Sci. Technol., 116 (2021), pp. 815-828, [10.1016/j.tifs.2021.08.012](https://doi.org/10.1016/j.tifs.2021.08.012)
66.  [Zhang et al., 2021](#bb0365)
J. Zhang, S. Feng, J. Yuan, C. Wang, T. Lu, H. Wang, C. Yu
The formation of fruit quality in Cucumis sativus L
Front. Plant Sci., 12 (2021), pp. 1-10, [10.3389/fpls.2021.729448](https://doi.org/10.3389/fpls.2021.729448)
67.  [Zhang et al., 2016](#bb0370)
W. Zhang, J. Qi, P. Wan, H. Wang, D. Xie, X. Wang, G. Yan
An easy-to-use airborne LiDAR data filtering method based on cloth simulation
Remote Sens., 8 (2016), pp. 1-22, [10.3390/rs8060501](https://doi.org/10.3390/rs8060501)
68.  [Zhang et al., 2022](#bb0375)
Y. Zhang, J. Yang, M. Van Haaften, L. Li, S. Lu, W. Wen, X. Zheng, J. Pan, T. Qian
Interactions between diffuse light and cucumber (Cucumis sativus L.) Canopy structure, simulations of light interception in virtual canopies
Agronomy, 12 (2022), [10.3390/agronomy12030602](https://doi.org/10.3390/agronomy12030602)
69.  [Zhao et al., 2019](#bb0380)
H. Zhao, X. Zhai, L. Guo, Y. Yang, J. Li, C. Ren, K. Wang, X. Liu, R. Zhan, K. Wang
Comparing protected cucumber and field cucumber production systems in China based on emergy analysis
J. Clean. Prod., 236 (2019), Article 117648, [10.1016/j.jclepro.2019.117648](https://doi.org/10.1016/j.jclepro.2019.117648)