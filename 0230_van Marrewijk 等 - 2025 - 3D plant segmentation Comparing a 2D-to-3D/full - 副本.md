# 3D plant segmentation: Comparing a 2D-to-3D segmentation method with state-of-the-art 3D segmentation algorithms  

研究论文

# 3D植物分割：比较2D到3D分割方法与最先进的3D分割算法

Bart M. van Marrewijk ${ \mathfrak { a } } , { \mathfrak { s } } _ { \oplus }$ , Tim van Daalen $a _ { \textcircled { \left( p \right) } }$ , Bolai Xin b, Eldert J. van Henten ${ \mathfrak { a } } _ { \oplus }$ Gerrit Polder ${ \mathbf b } _ { \oplus }$ , Gert Kootstra a  

a 瓦赫宁根大学与研究中心，荷兰瓦赫宁根  
b 华南农业大学工程学院，中国广州  

# 文章信息  

# 摘要  

关键词：  
分割  
数字植物表型  
3D点云  
深度学习  
园艺  
番茄植物  

植物测量对于确定哪些植物在特定条件下生长最佳至关重要。这些测量可以手动完成，也可以使用相机自动完成，后者被称为基于图像的植物表型分析。这些图像可用于创建点云以在3D中测量植物特征。要提取植物特征，准确的分割至关重要。大多数点云分割方法依赖于3D分割算法。这些算法不如2D算法先进和成熟。此外，2D神经网络在大型多样化数据集上进行了预训练。因此，在我们的工作中，假设使用基于投影的方法进行点云分割可以获得比体素或基于点的算法更高的准确性。为了验证这一假设，开发了一种2D到3D重投影方法，并与三种最先进的3D分割算法进行了比较：Swin3D-s、Point Transformer v3和MinkUNet34C。2D到3D方法使用Mask2Former分割图像，将预测结果重投影到点云，并使用多数投票算法合并多个预测结果。所有算法都经过训练和测试，将3D点云分割为叶片、主茎、侧茎和支撑杆。2D到3D、Swin3D-s和Point Transformer v3算法之间没有显著差异，表明最先进的体素或基于点的方法与我们的基于投影的方法表现相似。然而，2D到3D方法通过包含虚拟相机具有更高的性能，并且具有更高的训练效率。仅使用五个标注植物，就获得了与训练Swin3D-s在25个植物上相似的表现，这表明所开发管道的附加价值。

# 术语表

| 符号 | 描述 |
|------|------|
| Cc | 相机c的位置 |
| Pi | 包含3D点i信息的像素qc.j集合 |
| pi | 点云中的3D点i |
| predi | 3D点i的类别预测 |
| Qc | 投影到像素qcj上的3D点pi集合 |
| Qc.j' | 距离相机最近的像素qc.j |
| qc.j | 相机c中的像素j |
| Vi | 3D点i的类别投票列表 |

| 缩写 | 描述 |
|------|------|
| 2D/3D | 2/3维 |
| 2D-to-3D | 2D分割到3D点 |
| IoU | 交并比 |
| Mask2Former | 掩码注意力Former |
| MinkUNet34C | 基于Minkowski网络和U-net架构的3D算法 |
| NPEC | 荷兰植物生态表型中心 |
| PTv3 | 点Transformer V3 |
| Swin3D-s | 使用小型骨干网络的3DSwin Transformer算法 |
| TP,FP,TN | 真阳性、假阳性、真阴性 |

# 1. 引言

自农业诞生以来，提高作物产量一直是人类活动的核心。通过优化灌溉、轮作、施肥、植物育种、作物选择和优良杂交种，产量得到了极大提高。这种粮食供应的改善导致了全球人口的显著增长（Erisman等，2008），从而进一步增加了粮食需求。为了养活不断增长的人口，增加产量是必要的。虽然一种方法是使用更多的土地和增加资源的使用，但持续的气候变化和土地可用性的减少使得用更少的资源生产更多的粮食变得越来越重要。因此，育种者正专注于开发更高效率的作物；减少肥料、杀虫剂和水的使用，而不会造成产量损失（Hawkesford & Riche, 2020; Ríos, 2015）。为了提高作物产量和效率，育种者必须了解遗传（G）、环境（E）和管理（M）的影响以及它们的相互作用（Hawkesford & Riche, 2020）。这些相互作用产生了被称为表型$( \mathbf { P } \ = \textbf { G x E x M } )$的性状。研究这种表达需要测量表型（P），这在育种行业仍然是一个挑战（Araus & Cairns, 2014; Araus等，2018），主要是因为目前主要依靠手工完成，因此成本高、耗时长（Akhtar等，2024; Li等，2014; Panguluri & Kumar, 2016），并且可能不一致和不准确。基于图像的植物表型分析有可能取代多种手动测量，而无需对植物进行物理干扰，因此被认为是弥合日益增长的基因型-表型差距的解决方案（Pound等，2017）。

基于图像的植物表型分析依赖于从数字图像中提取信息。过去，基于图像的植物表型分析依赖于手工制作的特征结合传统的机器学习算法。这些方法取得了很高的成功率，然而在实际应用中，这些算法并没有提供所需的准确性（Pound等，2017）。如今，数字表型分析严重依赖于深度神经网络。这些网络可以学习复杂的特征来识别植物器官，同时处理农业环境中存在的所有变化（Harandi等，2023; Kamilaris & Prenafeta-Boldú, 2018）。

在基于图像的表型分析中，一个流行的任务是检测水果，如番茄（Cardellicchio等，2023; Lawal, 2021）、柑橘（Apolo-Apolo等，2020）、橙子（Liu等，2018）和鳄梨（Vasconez等，2020）。其他基于图像的性状包括通过黄瓜节点检测估计节间长度（Boogaard等，2020），或计算拟南芥的叶片数量（Ubbens等，2018）。这些例子展示了自动化基于图像的表型分析在植物测量中的频繁使用。

这种自动化提高了一致性和准确性。Apolo-Apolo等（2020）的研究表明，基于图像的产量预测比作物专家的视觉估计具有更高的准确性，强调了基于图像的表型分析的附加价值。此外，基于图像的表型分析通过消除观察者之间的偏见和差异来提高一致性（Pound等，2017）。

迄今为止，基于图像的植物表型分析大多在2D中进行，即特征检测/提取仅限于一个平面（Schunck等，2021）。因此，专注于植物几何形状的测量依赖于可观察性状在一个方向上是平坦的假设，这是不正确的，因为植物是3维实体，也在三个维度（3D）上生长和发育（Akhtar等，2024）。在Boogaard等（2023）的论文中，通过估计2D图像和3D点云中的节间长度，对2D与3D表型分析进行了比较。3D方法显示出显著改进，表明了3D表型分析的附加价值（Akhtar等，2024; Boogaard等，2023; Harandi等，2023）。

对于3D表型分析，植物的准确重建至关重要。对于使用2D相机的3D物体重建，有多种算法可用，包括多视图立体（MVS）（Hartley & Zisserman, 2003）、体素雕刻（Kutulakos & Seitz, 2000）、神经辐射场（NeRF）（Mildenhall等，2021）和高斯泼溅（Kerbl等，2023）。非基于图像的方法依赖于LiDAR或飞行时间（ToF）传感器，通过测量传感器与物体之间的距离来创建点云。通过从不同姿势进行重复测量，可以将来自LiDAR的单个点云合并以创建物体的准确完整重建。对于3D表型分析，基于图像和非基于图像的重建方法都可以用于生成高质量的点云。

一旦获得植物的3D重建，下一步就是在3D中进行准确分割，以提取植物器官，评估其位置、大小、形状和其他特性，用于表型分析目的（Boogaard等，2023; Turgut, Dutagaci, Galopin, & Rousseau, 2022; Xin等，2024）。因此，准确的分割对于精确的植物测量至关重要（Harandi等，2023）。直接在3D点云上进行分割的算法确实存在，如PointNet$^{++}$（Qi等，2017）、PVCNN（Liu等，2019）、MinkoswkiNet（Choy等，2019）以及更近期的Swin3D（Yang等，2025）和点Transformer v3（PTv3）（Wu等，2024）。Saeed等（2023）使用PVCNN分割了3D棉花植物。从分割的点云中，估计了节间长度、分枝角度和茎直径等植物性状。植物表型分析社区中另一个常用的算法是PointNet$^{++}$。PointNet$^{++}$已被用于分割黄瓜植物（Boogaard等，2023）、玫瑰灌木（Turgut, Dutagaci, & Rousseau, 2022）和番茄植物（Xin等，2024）。Xin等（2024）使用分割的番茄点云通过拟合植物茎部分的圆柱体来提取节间长度、分枝和叶序角。Boogaard等（2023）分割了黄瓜点云以计算节间长度。然而，如果任何节点未被分割，则无法准确估计节间长度。根据Boogaard等（2023）的说法，需要提高分割准确性以获得更好的植物性状估计。虽然Swin3D和PTv3在ScanNet数据集（Dai等，2017）上确实优于PointNet$^{++}$，但它们尚未应用于植物表型分析。因此，通过在植物领域评估这些最先进的算法来了解其性能是很有趣的。

3D分割仍然具有挑战性，原因有三：1）与2D方法相比，3D分割算法的发展进展有限。已经取得了一些进展，然而，像MinkoswkiNet（Choy等，2019）这样的3D算法旨在识别3D模式，因此对于椅子、桌子等独特形状效果很好，但可能无法区分墙壁和绘画等（Kundu等，2020）。在植物表型分析中区分侧茎和主茎是一个类似的挑战性任务，因为两者都是绿色的、圆形的，因此难以区分。2）由于3D训练数据集的可用性有限，预训练网络的可用性有限（Akhtar等，2024; Harandi等，2023; Kundu等，2020）。对于2D图像，存在许多大型多样化数据集，如包含超过1400万张图像的ImageNet（Deng等，2009）或常见物体上下文（COCO）数据集（Lin等，2014）。而对于3D算法，最大的数据集之一是ScanNet（Dai等，2017），仅包含1513个场景。此外，该数据集仅限于室内场景，而ImageNet有超过22,000个类别。因此，使用ScanNet预训练的3D分割网络可能不会显著提高农业相关任务（如植物器官分割）的性能。3）与3D训练数据集相关的是获取和注释3D数据所需的时间和精力。在3D中进行注释非常耗时，导致数据集相对较小，这限制了3D分割算法的性能。

本研究旨在通过建立在2D分割方面的努力和进展，对3D分割的进步做出贡献，并在2D中分割图像。使用MVS、体素雕刻、NeRF或高斯泼溅生成的点云都依赖于使用许多2D图像。与其在具有上述缺点的点云上应用深度学习，问题在于是否可以在2D中分割图像，并通过将2D分割的像素投影到3D点（2D到3D）将预测的类别叠加到点云上。这种重投影方法受到Boulch等（2018）、Shi等（2019）和Kundu等（2020）工作的启发。基于重投影的方法有三个主要优点。1）2D中的错误对于不同的视角不是持久的。2D分割中的任何错误都可以通过3D中的投票机制部分补偿（Shi等，2019）。2）可以利用预先在COCO等多样化数据集上训练的先进2D架构。3）基于重投影的方法可以减少注释时间。在Kundu等（2020）的工作中，通过从点云渲染图像增加了训练数据集。这可以节省注释时间，因为可以渲染许多图像。此外，可能仅使用渲染的图像来分割点云。这对于缺少真实图像的非基于图像的点云数据集特别有趣。

在本文中，我们假设使用2D重投影进行点云分割可以获得比直接使用最先进的3D分割算法更高的分割精度。我们工作的新颖贡献包括：1）比较了最先进的3D分割算法与一种新开发的2D到3D重投影算法在3D番茄植物分割中的表现。2）比较了2D到3D重投影算法使用真实图像和渲染图像的分割性能，以便将该方法应用于非基于图像的重建方法。3）通过比较最先进的3D分割算法和2D到3D重投影算法在不同训练植物数量下的表现，评估了训练效率。4）通过渲染额外图像进行3D分割，提高了2D到3D重投影算法的分割性能。该数据集已公开，以促进3D植物表型分析的进一步研究和发展（Marrewijk等，2025）。相关代码可通过我们的GIT访问：https://github.com/WUR-ABE/2D-to-3D_segmentation。

# 2. 材料与方法

本节介绍了材料和方法，首先在第2.1节中描述了点云分割算法。第2.2节描述了数据集。第2.3节解释了分割算法的评估。最后，在第2.4节中更详细地描述了四个实验。

# 2.1 点云分割

在本研究中，我们比较了2D到3D重投影和三种最先进的3D分割方法。2D到3D和3D分割算法的示意图如图1所示。输入是点云，两种方法的输出都是每个点属于一个类别的分割点云。2D到3D重投影方法是一种基于投影的方法。如图1所示，2D分割算法的点被投影到点云上。该方法在第2.1.1节中解释。最先进的算法分为体素和基于点的算法。这些算法要么将点云预处理为体素，要么直接处理点云，更多细节见第2.1.2节。

# 2.1.1 2D到3D重投影

2D到3D重投影算法使用2D分割算法对一组相关的2D相机视图进行分割，然后将结果反投影到3D点云上。该方法包括四个主要步骤，如图1a所示，并在下面详细解释。

1. 获取相机图像
2. 使用2D分割算法分割图像
3. 将2D分割结果重投影到点云
4. 对重投影点进行多数投票

2.1.1.1 获取相机图像。有两种获取相机图像的方法。第一种方法是直接使用相机拍摄图像。第二种方法是从点云渲染图像，这在无法获得相应相机图像时特别有用，例如使用激光雷达扫描仪收集数据时。为了渲染图像，使用MeshLab中的球面旋转算法将点云转换为网格，使用默认设置（Cignoni等，2008）。随后使用已知的相机内参和位姿渲染图像。在本研究中，这些新生成的图像被称为"渲染图像"。

2.1.1.2 使用2D分割算法分割图像。在此步骤中，2D图像被分割为5个类别：$0 =$ 背景（黑色），$1 =$ 叶片（红色），$2 =$ 主茎（黄色），$3 =$ 支撑杆（绿色），$4 =$ 侧茎（蓝色）。使用Mask2Former（Cheng等，2022）算法分割图像。该算法由三部分组成：从图像中提取特征的骨干网络、生成高分辨率嵌入的像素解码器，以及处理像素解码器查询的transformer解码器。更多细节见Cheng等（2022）的论文。

在本研究中，Mask2Former使用Swin-tiny骨干网络（Liu等，2021）进行训练，因为试点研究表明，与ResNet50骨干网络（He等，2016）相比，性能有所提高。Swin-tiny骨干网络的优势在于可以在$1080 \times 1920$（宽×高）的原生分辨率上进行训练。这对于侧茎的分割至关重要，因为侧茎较小，在降低图像分辨率时往往会消失。训练和超参数细节在实验部分2.4.1中描述。

2.1.1.3 将预测结果重投影到点云。此步骤的目标是将3D点云中的点与所有2D相机图像中的像素关联起来，同时考虑遮挡。对于点云中的每个3D点$p_i$，确定相机图像中所有对应像素的集合$P_i$。开发的算法包含三个子步骤，如图2所示：

- 在第一个子步骤中，使用相机内参和外参将每个3D点投影到所有相机平面。对于相机c中的每个像素$q_{c,j}$，这会产生投影到该像素上的3D点索引集合$Q_{c,j} = \{p_{i_1}, ..., p_{i_n}\}$。注意$Q_{c,j}$可以是空集，在这种情况下，植物的任何部分都不会投影到相机c的像素j上。然而，子步骤1没有考虑遮挡。

- 第二个子步骤处理这个问题：当$Q_{c,j}$是一个包含多个成员的集合$(n > 1)$时，意味着多个3D点投影到同一个像素。在这种情况下，同一条投影线上有多个物体。例如，当一片叶子在茎干前面时，两个点（一个来自叶子，一个来自茎干）会投影到同一个像素，见图2。在这种情况下，只保留距离相机位置$c_c$最近的3D点，数学定义为：

$$
\begin{array} { r } { Q _ { c , j } ^ { ' } = \biggl \{ p _ { i } \biggl | p _ { i } = \underset { p _ { k } \in Q _ { c , j } } { \operatorname { a r g m i n } } \bigl | \bigl | p _ { k } - c _ { c } \bigr | \bigr | \biggr \} } \end{array}
$$

试点研究表明，如果相机图像的分辨率降低四倍，这种方法效果最好。分辨率过高时，由于点的投影可能会"滑过"，遮挡并不总是能被正确检测到（见图3）。

- 最后，在最后一个子步骤中，使用子步骤2的结果为每个3D点$p_i$创建一个集合$P_i = \left\{q_{c_1,j_1}, ..., q_{c_m,j_m}\right\}$，列出包含3D点信息的所有相机图像中的像素。注意$P_i$可能为空集，在这种情况下没有找到对应的像素。

2.1.1.4 对重投影点进行多数投票。使用3D-2D对应关系和2D分割，可以将每个3D点$p_i$的对应像素列表$P_i$更改为每个3D点的类别投票列表$V_i$。然后使用公式（2）对每个点$p_i$应用多数投票以获得单个类别预测：

$$
p r e d _ { i } = \underset { 0 \leq k \leq C } { \operatorname { a r g m a x } } ( \operatorname { c o u n t } ( k , V _ { i } ) )
$$  

![](images/f2bf2fbbe8fc66df5e8dafb5b308c6dbbfabf32f5e657aa9ba505ed8c0fa6059.jpg)  
图2. 2D到3D重投影方法可视化。蓝色表示相机$(c_{c})$，绿色表示像素$(q_{c,j})$及其对应的投影列表$(Q_{c,j})$。橙色表示3D中的点$(p_{i})$，黄色表示具有投影像素坐标的点列表$(P_{i})$。（关于图例中颜色的解释，请读者参考本文的网络版本。）

![](images/70989ac90c0dc9c58de7bfc526b1c661fbefa21a2c3e320478700e3c747a8825.jpg)  
图3. (a) 前景像素（橙色）和背景像素（红色）在示意图像平面（蓝色）上的重投影。两个点投影到不同的像素上。(b) 通过降低图像分辨率，两个点投影到同一个像素上，并通过距离过滤只保留橙色像素。（关于图例中颜色的解释，请读者参考本文的网络版本。）

如果有两个或更多类别出现次数相同，则选择最低的类别索引，遵循以下层次结构：$0=$背景，$1=$叶片，$2=$主茎，$3=$支撑杆，$4=$侧茎。由于并非所有点都能与图像匹配，点云中的一些点可能未被分配到类别。如果$P_{i}=\emptyset$，则无法为点$p_{i}$分配类别。为了防止信息丢失，使用八叉树将点云恢复到原始密度。八叉树初始化的最大深度为7，将3D空间细分为更小的节点，根据点云的不同，这导致节点大小约为$\pm5.2\mathrm{mm}$。对于每个节点，该节点中所有未分配类别的点都被归为该节点的多数类别。如果节点没有任何预测，则删除所有这些点。

# 2.1.2 3D分割

第二组植物器官分割方法涉及使用基于3D深度学习的分割算法。这些端到端神经网络需要输入点云XYZ，以及可选的RGB和法线值，以尽可能准确地分割植物。存在三种类型的3D分割算法：基于投影的、基于体素的和基于点的。基于投影的方法在前一节中已经解释，将与基于体素和基于点的方法进行比较。

基于体素的算法将点云转换为体素，以便于使用3D卷积（Maturana & Scherer, 2015; Wu等, 2024）。在本研究中，将测试两种基于体素的算法：MinkUNet34C（Choy等, 2019）和Swin3D-s（Yang等, 2025）。MinkUNet34C是一个相对较旧的算法，依赖于稀疏卷积，作为参考算法来表明最新最先进的3D分割算法的性能改进。第二种基于体素的方法是Swin3D-s。在撰写本文时，它是一个相对较新的基于transformer的算法，在ScanNet分割挑战中排名第四（Meta AI Research, 2024）。

最后，研究了一种基于点的方法。基于点的算法直接处理3D坐标，无需体素化。植物表型分析社区中常用的基于点架构是PointNet$^{++}$（Qi等, 2017）。在本研究中，Point transformer V3（PTv3）（Wu等, 2024）被纳入与2D到3D方法的比较中。它是一个基于transformer的算法，目前在ScanNet数据集上具有最高的mIoU，是最先进的算法（Meta AI Research, 2024）。PTv3是一个结合了点和序列化网络的算法。如Wu等（2024）所述，它通过使用空间填充曲线来构建点云。这些曲线是穿过高维空间中每个点的路径。这种范式使网络高效，能够专注于尺度并创建具有大感受野的网络，从而在ScanNet上实现最先进的性能。更多细节可以在Wu等（2024）的论文中找到。所描述模型的训练和超参数设置在实验部分2.4.1中解释。

# 2.2. 数据集

# 2.2.1. 点云数据集

在本研究中，使用了44个番茄(Solanum lycopersicum L.)植物的3D点云数据集(Marrewijk等，2025)(图4c)。这些点云由荷兰植物表型中心(NPEC)的MaxiMarvin系统生成。该系统使用形状从轮廓方法(Golbach等，2016)创建点云。该方法比多视角立体成像更快，可以重建细小分支，这通常是多视角方法的瓶颈。体素空间设置为$400 \times 400 \times 700 \mathrm{mm}$，体素大小为$1 \mathrm{mm}^3$。RGB图像由15个相机(Basler ace Classic, acA1920-25gc)拍摄，相机围绕植物放置在三个高度，每个高度5个相机，距离植物中心约$\pm1200 \mathrm{mm}$。每个相机的分辨率为$1080 \times 1920$像素(宽×高)。镜头焦距为$8 \mathrm{mm}$，水平和垂直视场角分别为16°和30°。设置如图4a所示。示例点云如图4b所示。使用KDTree为点云添加表面法线，半径为$10 \mathrm{mm}$，最大邻居数设置为30。

# 2.2.2. 数据集标注

数据集包含标注的点云和未标注的RGB图像。点云使用CloudCompare(Girardeau-Montaut，2024)手动标注为4类：叶片(红色)、主茎(黄色)、支撑杆(绿色)和侧茎(蓝色)，每个点云大约需要1小时。示例如图4c所示。

为了在图像上训练语义分割算法，需要2D标注。小而重叠的植物器官在2D中难以标注，尤其是顶部的叶片，以及靠近支撑杆和主茎的点。例如，类似于图5a的图像需要大约2到4小时来标注。为了避免耗时的标注$(44 \times 15 \times 1 \mathrm{小时})$，使用2.1.1节中介绍的渲染管道从标注的点云自动标注图像。示例如图5ab所示，其中(a)为原始RGB图像，(b)为从标注点云渲染的对应真实值图像。

这种方法的一个缺点是体素空间小于植物的实际大小。因此，3D中缺少一些点，导致RGB图像与渲染的真实值图像不匹配。为了解决这个问题，应用了RGB阈值，创建了一个将植物与背景分离的掩码$\mathrm{[0 < 红色 > 227, 0 < 绿色 > 242, 0 < 蓝色 > 122]}$。所有在渲染图像中为背景(黑色)但在原始RGB图像中未被生成的掩码分配为背景的像素都被着色为白色。这种调整如图5b所示，其中渲染图像中植物的顶部、底部和侧面被着色为白色。这些白色像素在训练时被忽略。

![](images/cff440f9121bff57ce3583f465410549ca0f111f2b8f365689657aef5f5a6dbe.jpg)  
图4. (a) 使用15个相机在三个高度创建点云的相机设置(仅显示5个)。(b) 番茄植物的输入点云，包含六个通道：RGB和表面法线(未可视化)。(c) 标注的点云，包含叶片(红色)、主茎(黄色)、支撑杆(绿色)和侧茎(蓝色)。(关于图例中颜色的解释，请读者参考本文的网络版本。)

![](images/b94fa88e778d4c83e11327f1d56dcc8dc1d3a2a2dbabb476b79490080a4d170f.jpg)  
图5. (a) 原始RGB图像。(b) 通过从标注点云渲染图像得到的标注图像。背景(黑色)、叶片(红色)、主茎(黄色)、支撑杆(绿色)、侧茎(蓝色)，白色像素表示出现在2D图像中但不在3D点云中的像素。(c) 渲染的RGB图像，用于增加数据集的大小。(关于图例中颜色的解释，请读者参考本文的网络版本。)

# 2.2.3. 训练、验证和测试集

数据集包含来自三个不同品种的44株植物：Brioso(19)、Merlice(17)和Gardener Delight(8)。这些植物处于发育阶段，相对较小$\left(<80 \mathrm{cm}\right)$，花朵仍在发育。植物在个体水平上随机分为训练集、验证集和测试集。这意味着与单株植物相关的所有数据，包括点云和RGB图像，都被分配到同一个划分中。数据集被划分为35株植物的训练集$(80\%)$，4株植物的验证集$(9\%)$，和5株植物的测试集$(11\%)$。完整的数据集总结在表1中。

# 2.3. 评估

为了评估3D分割性能，使用以下标准。

表1 数据集总结。


| 数据集划分 | 植物数量 | 点云数量 | RGB图像数量 |
|-----------|----------|----------|-------------|
| 训练集    | 35       | 35       | 525         |
| 验证集    | 4        | 4        | 60          |
| 测试集    | 5        | 5        | 75          |

- 每个类别的交并比 $\mathrm { ( I o U _ { c } ) }$。该指标使用以下公式计算每个类别的分割性能：

$$
I o U _ { c } = \frac { T P _ { c } } { T P _ { c } + F P _ { c } + F N _ { c } }
$$  

其中 $\mathrm { T P _ { c } }$ 是属于类别 c 的真阳性点数量，$\mathrm { F P _ { c } }$ 是错误预测为类别 c 的假阳性点数量，$\mathrm { F N _ { c } , }$ 是未预测为类别 c 的假阴性点数量。

- 宏观交并比 $( \mathrm { I o U } _ { \mathrm { m a c r o } } )$，表示每个类别 IoU 值的平均值，$C$ 为类别数量。所有类别在该指标中具有相同的权重，与该类别的点数无关。

$$
\ I o U _ { m a c r o } = { \frac { \sum _ { c = 1 } ^ { C } I o U _ { c } } { C } }
$$  

- 微观交并比 $\mathrm { ( I o U _ { m i c r o } ) }$，与 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 类似，但计算所有真阳性的性能，不考虑类别。$\mathbf { I o U } _ { \mathrm { m i c r o } }$ 对每个点赋予相同权重，主导类别会对该指标产生更大影响。

$$
I o U _ { m i c r o } = \frac { \displaystyle \sum _ { c = 1 } ^ { C } T P _ { c } } { \displaystyle \sum _ { c = 1 } ^ { C } \left( T P _ { c } + F P _ { c } + F N _ { c } \right) }
$$  

测试集样本量相对较小，仅包含五株植物。统计计算使用配对 t 检验对自举数据进行，子样本数设置为 1000。

# 2.4. 实验

本研究分为四个实验。第一个实验（2.4.1）旨在确定最佳 3D 分割模型，并将其与默认的 2D 到 3D 算法进行比较。第二个实验（2.4.2）测试了使用渲染图像对性能的影响。第三个实验（2.4.3）通过逐步增加训练数据量来评估 2D 到 3D 和 3D 分割算法的训练效率。最后，最后一个实验（2.4.4）评估了性能与相机数量的关系。

# 2.4.1. 实验 1：最先进分割算法之间的比较

在实验 1 中，目标是将开发的 2D 到 3D 重投影算法与三种最先进的 3D 分割算法的性能进行比较。

2.4.1.1. 2D 到 3D 重投影算法。2D 重投影算法依赖于在 Ade20k 上预训练的 Mask2Former（Zhou 等，2017）来分割 RGB 图像中的背景、叶片、支撑杆、主茎和侧茎。训练设置可以在我们的 GIT 上找到。这些设置基于 MMsegmentation 库的 Mask2Former 实现，因为这些已经过优化（MMSegmentation，2020）。为了与 3D 分割算法进行比较，Mask2Former 在表 1 中的所有 525 张训练图像上进行了训练。在结果部分，该模型被称为“2D 到 3D”模型。推理是在原始分辨率 1080x1920（宽 $\mathbf { x }$ 高）下进行的，没有任何增强。

2.4.1.2. 3D 分割算法。训练了三种 3D 分割算法：MinkUNet34C（Choy 等，2019）、Swin3D-s（Yang 等，2025）和 PTv3（Wu 等，2024）。根据 ScanNet 数据集（Dai 等，2017）的结果，可以预期 Swin3D-s 和 PTv3 将优于 Minkowskinet34；后者仍然依赖于传统的编码器-解码器 CNN 架构。训练设置基于 PTv3 的论文（Wu 等，2024），也可以在我们的 GIT 上找到。所有 3D 算法都具有相同的增强设置。

为了优化性能，进行了两个额外的子实验。对于 Swin3D-s 和 PTv3 算法，评估了使用预训练模型的影响。随后，确定了学习率的影响。如 Wu 等（2024）所示，学习率在数据集之间并不一致。因此，通过将学习率增加/减少十倍来优化学习，导致所有三种 3D 算法的学习率为 $6 . 0 ^ { * } 1 0 ^ { - 4 }$ 或 $6 . 0 { ^ { * } } 1 0 ^ { - 2 }$。将具有最高 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 的模型与 2D 到 3D 重投影算法进行比较，并用于其余实验。

# 2.4.2. 实验 2：渲染图像对性能的影响

在第二个实验中，通过用“渲染”图像替换十五张真实图像进行了比较。该实验旨在研究使用渲染图像而不是真实图像是否会改变性能，这对于非基于图像的数据集尤其有趣。为了创建渲染图像，重新使用了第 2.1.1 节“获取图像”中开发的管道。现在不是从标注的点云渲染真实值图像，而是从具有与真实 RGB 图像相似内在和外在的彩色点云渲染图像。新的训练数据集包含 525 张渲染图像，用于训练额外的 Mask2Former 模型。在结果部分，该模型被称为“渲染 2D 到 3D”。

# 2.4.3. 实验 3：训练效率作为标注植物数量的函数

第三个实验旨在量化哪种算法具有更高的训练效率，这一点很重要，因为更高的训练效率意味着需要更少的标注。该实验通过将模型作为训练集中标注植物数量的函数来评估 2D 到 3D 和 Swin3D-s 算法的性能。如果算法在相似数量的标注植物下获得更高的性能，则具有更高的训练效率，$N \in \{ 1 , 5 , 1 0 , 1 5 , 2 0 , 2 5 , 3 0 , 3 5 \}$。2D 到 3D 和 Swin3D-s 都在相同的植物集上进行了训练；然而，2D 到 3D 是在这些植物的相应 RGB 图像上训练的，而 Swin3D-s 是在相应的点云上训练的。一株植物对应十五张标注的 RGB 图像。

# 2.4.4. 实验 4：相机数量对性能的影响

在第四个实验中，目标是量化 2D 到 3D 重投影算法的性能作为相机数量的函数。通过逐步增加相机数量，预计性能会提高，因为植物的更多部分可见，并且多数投票是在更多点上计算的。此外，还研究了通过添加虚拟相机是否能够进一步提高性能。

实验总结在表 2 中。在该表中，相机数量从五台逐渐增加到二十五台。如第 2.2.1 节所述，设置包含三个环，每个环有五台相机：五台在植物底部，五台在中间，五台在顶部。实验从中间环的五台相机（5m）开始，以五台为增量增加，使用不同的组合。为了评估超过十五台相机的性能，通过添加十台虚拟相机扩展了设置；五台位于底部和中间行之间，五台位于中间和顶部行之间。这些新相机在图 6ab 中以灰色显示。渲染图像的示例如图 5c 所示。

表 2 实验 4 总结，逐步增加相机数量。


| 缩写 | 真实相机数量 | 虚拟相机数量 | 说明 |
|------|--------------|--------------|------|
| 5m   | 5            |              | 仅使用中间环的5个相机进行重投影 |
| 5m5t | 10           |              | 使用中间5个和顶部5个相机 |
| 5m5b | 10           |              | 使用中间5个和底部5个相机 |
| 15c  | 15           |              | 使用所有15个RGB相机 |
| 15c5rt | 15          | 5            | 使用所有15个RGB相机，并在中间和顶部之间添加5个渲染图像 |
| 15c5rb | 15          | 5            | 使用所有15个RGB相机，并在中间和底部之间添加5个渲染图像 |
| 15c5rt5rb | 15        | 10           | 使用所有15个RGB相机，并添加10个渲染图像 |

在本实验中，Mask2Former 在真实图像和渲染图像上进行训练，因为默认的“2D-to-3D”模型仅在真实图像上训练。新模型在 875 张图像上训练：525 张真实图像和 350 张渲染图像（35 株植物 $\mathbf { x } 1 0$ 个虚拟相机）。通过在训练管道中加入这些渲染图像，可以使用相同的 Mask2Former 模型执行表 2 中的所有测试。使用描述的指标评估性能。

# 3. 结果

# 3.1. 实验 1：最先进分割算法之间的比较

表 3 总结了多个 3D 分割模型和开发的 2D-to-3D 重投影算法的结果。结果按 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 指标排序。MinkUNet34C 在所有学习率下始终具有最低的 $\mathbf { I o U _ { \mathrm { m a c r o } } }$，表明其表现不佳。最佳 PTv3 和 Swin3D-s 算法之间的差异很小（0.77 vs $0 . 7 9 \ \mathrm { I o U _ { m a c r o } } )$。此外，当使用预训练网络和默认学习率 $( 6 . 0 ^ { * } 1 0 ^ { - 3 } )$ 时，PTv3 和 Swin3D-s 都具有更高的性能。特别是对于 PTv3，预训练在 $\lambda \ : =$ $6 . 0 ^ { * } 1 0 ^ { - 3 }$ 时带来了 0.06 的 IoUmacro 显著提升。对于每个训练模型，叶片的分割精度最高，导致 $\mathbf { I o U } _ { \mathrm { m i c r o } }$ 相对较高，与 IoUmacro 相比。

从表 3 可以看出，2D-to-3D 和 Swin3D-s 之间的差异很小，分别为 0.78 和 0.79。对自举数据进行的配对 t 检验显示没有显著差异，$\mathtt { p } = 0 . 0 6$。主茎和支柱的 IoU 也相当，IoU 差异小于 $\leq 0 . 0 1$。2D-to-3D 方法在识别叶片（0.97 vs 0.95）和侧枝（0.67 vs 0.70）方面的准确率略低。这部分是由于点被预测为背景，平均发生率为 $1 . 4 ~ \%$。比较 2D-to-3D 与 PTv3 的 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 也没有显著差异 ${ \bf \langle p = 0 . 9 0 \rangle }$。

在表 4 中，展示了使用最佳设置训练的每种架构对测试集中一株植物的分割结果。第一行显示预测类别，第二行显示错误预测的点 $( \mathrm { F P } + \mathrm { F N } )$，用红色表示。Swin3D-s、2D-to-3D 和 PTv3 之间没有明显差异。MinkUNet34C 无法正确识别侧枝。几乎所有侧点都显示为红色。2D-to-3D 方法有几个点显示为黑色，表明这些植物点被预测为背景。这些黑点在叶片上尤其明显，解释了表 3 中叶片类别的较低性能。所有方法在支柱和主茎之间的边界处都有相对较大的误差。这部分是由于标注这些点本身也容易出错。这将在第 4.1 节中详细讨论。

在剩余的实验中，2D-to-3D 方法的结果仅与 Swin3D-s 算法（使用默认学习率预训练）进行比较，因为该模型在 3D 方法中具有最高性能（表 3）。表 5 显示了两种模型在测试集中剩余四株植物上的结果。两种方法之间的性能相当，除了植物“Harvest_02_­ PotNr_166"。仔细观察发现，由于支柱的遮挡，植物的顶部在相应图像中几乎不可见。这导致 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 为 0.71，比 Swin3D-s 方法低 0.04。

# 3.2. 实验 2：渲染图像对性能的影响

表 6 展示了 2D-to-3D 方法在渲染图像上的性能指标。将这些结果与“默认”2D-to-3D 方法的性能进行比较，可以发现，在渲染图像上训练 Mask2Former（“渲染 2D-to-3D”）不会影响 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 和 $\mathrm { I o U } _ { \mathrm { m i c r o } }$。默认和渲染 2D-to-3D 方法都实现了相同的 $\mathrm { I o U } _ { \mathrm { m a c r o } }$ 0.78，表明使用渲染图像不会显著影响性能指标。

图 7 展示了默认和渲染 2D-to-3D 方法的输入图像、分割图像和分割点云。渲染图像 (d) 与真实图像 (a) 高度重叠。表明网格化算法是准确的，微小的侧面仍然可见，并且没有创建任何干扰渲染图像的孔洞。图 7b 显示支柱的顶部被错误地预测为叶片。然而，两种方法的性能相同（IoUmacro 0.78）。这是由于体素尺寸小于植物，因此并非所有真实 2D 图像的像素都出现在 3D 表示中（见第 2.2.2 节）。这也可以从图 7c 中的分割点云中看出，支柱的顶部缺失。因此，尽管图 7b 中有错误预测的像素，但使用真实图像和渲染图像的 2D-to-3D 方法的性能相似。因此，使用真实图像还是渲染图像来分割 3D 植物并不重要。

![](images/5f6f04ef677f4a3bdd87aefdcd290912e34facea5fe2e991f811589ecde7f356.jpg)  
图 6. 相机姿态的示意图，分别为 (a) 侧视图和 (b) 俯视图。彩色线条表示“真实”相机的姿态，蓝色表示相机的方向。渲染图像的新姿态以灰色显示。为了可读性，添加了黑色虚线圆圈。（有关图例中颜色参考的解释，读者可参考本文的网络版本。）

表 3 多个 3D 分割算法在测试集上的结果。使用或不使用预训练，并将学习率乘以或除以十。绿色值表示每列中较高的 IoU 值，粗体表示每列中的最高值。  
表 4 四种不同架构在植物“Harvest_02_PotNr_27”上的分割结果。第一行显示预测类别，红色 $\mathbf { \Sigma } = \mathbf { \Sigma }$ 表示叶片，黄色 $\mathbf { \Sigma } = \mathbf { \Sigma }$ 表示主茎，绿色 $\mathbf { \Sigma } = \mathbf { \Sigma }$ 表示支柱，浅蓝色 $\mathbf { \Sigma } = \mathbf { \Sigma }$ 表示侧枝，黑色表示被分配为背景的点。第二行以蓝色显示 TP，以红色显示 $\mathrm { F P } + \mathrm { F N }$。  


| 模型 | 预训练 | 学习率 | IoUmacro | IoUmicro | IoU叶片 | IoU主茎 | IoU支柱 | IoU侧枝 |
|------|--------|--------|----------|----------|---------|---------|---------|---------|
| Swin3D-s | √ | 6.0*10<sup>-3</sup> | 0.79 | 0.93 | 0.97 | 0.75 | 0.76 | 0.70 |
| Swin3D-s |  | 6.0*10<sup>-3</sup> | 0.78 | 0.92 | 0.96 | 0.75 | 0.76 | 0.66 |
| 2D-to-3D | √ | 1.0*10<sup>-4</sup> | 0.78 | 0.91 | 0.95 | 0.74 | 0.76 | 0.67 |
| PTv3 | √ | 6.0*10<sup>-3</sup> | 0.78 | 0.92 | 0.97 | 0.71 | 0.75 | 0.69 |
| PTv3 | √ | 6.0*10<sup>-4</sup> | 0.77 | 0.91 | 0.96 | 0.70 | 0.75 | 0.66 |
| Swin3D-s | √ | 6.0*10<sup>-4</sup> | 0.76 | 0.91 | 0.96 | 0.71 | 0.75 | 0.63 |
| PTv3 |  | 6.0*10<sup>-3</sup> | 0.72 | 0.89 | 0.95 | 0.70 | 0.74 | 0.49 |
| Swin3D-s | √ | 6.0*10<sup>-2</sup> | 0.70 | 0.89 | 0.95 | 0.70 | 0.73 | 0.42 |
| PTv3 | √ | 6.0*10<sup>-2</sup> | 0.64 | 0.86 | 0.94 | 0.55 | 0.59 | 0.48 |
| MinkUNet34C |  | 6.0*10<sup>-2</sup> | 0.61 | 0.85 | 0.93 | 0.57 | 0.61 | 0.31 |
| MinkUNet34C |  | 6.0*10<sup>-3</sup> 6.0*10<sup>-4</sup> | 0.58 | 0.85 | 0.93 | 0.57 | 0.55 | 0.25 |
| MinkUNet34C |  |  | 0.54 | 0.83 | 0.92 | 0.47 | 0.58 | 0.19 |

![](images/407dfc4e5da80b070722c3ec4a20e1f2571bf1d23ef4cd527f2b3fb8cb82ca0a.jpg)  

# 3.3. 实验3：训练效率与标注植物数量的关系

在图8中，展示了模型性能随训练所用植物数量的变化。使用配对自举t检验计算p值，因此尽管存在显著差异，置信区间仍可能重叠。与Swin3D-s相比，2D-to-3D方法在较少场景下表现更好，并且在相同训练样本数量下，对于训练集中1、5、10、15或20株植物都有显著差异。此外，2D-to-3D算法的性能在5到25个场景之间几乎保持恒定，这表明将训练集规模增加到超过5株植物只会带来边际改进。因此，仅使用5株植物进行训练的2D-to-3D方法与使用25株植物训练的Swin3D-s算法具有相当的性能。结合显著差异$( \mathtt { p } < 0 . 0 5 )$，可以得出结论：

![](images/094a02c6683b4e0401aa832c21d8b255f61640cf8654a7d461f936c6edba19ce.jpg)  

表5 测试集中剩余植物的结果。仅展示Swin3D-s和2D-to-3D重投影方法的结果。正确预测的点用蓝色表示，错误预测的点用红色表示，包括完整植物和典型错误的放大图。  
表6 渲染图像对性能影响的总结。  


| 实验名称 | IoUmacro | IoUmicro | 叶片 | 主茎 | 支柱 | 侧枝 |
|----------|----------|----------|------|------|------|------|
| Swin3D-s | 0.79 | 0.93 | 0.97 | 0.75 | 0.76 | 0.7 |
| Rendered 2D-to-3D | 0.78 | 0.91 | 0.95 | 0.75 | 0.77 | 0.67 |
| 2D-to-3D (默认) | 0.78 | 0.91 | 0.95 | 0.74 | 0.76 | 0.67 |

2D-to-3D 方法比 Swin3D-s 方法具有更高的训练效率。

# 3.4. 实验4：相机数量对性能的影响

图9展示了性能随使用相机数量的变化。对于10和20个相机，显示了两个$\mathrm{IoU_{macro}}$值，因为可以使用底部或顶部图像。使用底部相机比顶部相机显示出更大的性能提升。增加相机数量对性能有积极影响。使用25个相机的性能甚至高于Swin3D-s模型（虚线），这是出乎意料的，因为点云仅由15个相机制作。尽管使用25个相机时性能更高，但与Swin3D-s相比的结果并不显著$(\mathtt{p}=0.26)$。

![](images/f41c363b3752a359de7f1bbd30d4b82d77494425d5f566b8c2ee15e666fbf19a.jpg)  
图7. 真实和渲染的RGB输入图像(a)和(d)的可视化。对应的预测分割在b和e中。最后是默认(c)和渲染(f)2D-to-3D方法的分割点云。

![](images/5926379606366b8d0912d027a18ee52290306f429667c0a0f713556d8f2fc940.jpg)  
图8. $\mathrm{IoU_{macro}}$作为训练模型所用植物数量的函数，包括95%置信区间。配对自举t检验的结果用"*"表示，如果$\mathtt{p}<0.05$ $(^{*})$，$\mathfrak{p}<0.01$ $(^{**})$和$\begin{array}{r}{\mathbf{p}<0.001}\end{array}$ $(^{***})$。

![](images/cbe38f13bba7d1fa5af4f828cbc3c934d10adc9b6cf046f302abb6f6086798cb.jpg)  
图9. $\mathrm{IoU_{macro}}$作为使用相机数量的函数，包括95%置信区间。为了可读性，在10和20个相机处略微调整了相机数量$\pm0.1$。虚线表示Swin3D-s模型的性能。请注意，Swin3D-s是在点云上训练的，因此不受相机数量的影响。

# 4. 讨论

# 4.1. 2D-to-3D重投影与3D分割算法的比较

在本研究中，对最先进的3D分割算法和基于2D-to-3D重投影的分割进行了比较。结果表明，最好的3D分割算法Swin3D-s与我们开发的2D-to-3D算法之间没有显著的性能差异$(\mathbf{p_{\lambda}}=\lambda0.06)$。这与我们假设2D-to-3D算法会优于3D算法的预期相矛盾。主要原因是使用transformer的3D分割算法的快速发展。2023年，许多新的3D算法被发表（Swin3D-s和PTv3）。这些基于transformer的算法通过利用自注意力机制来改善点之间的全局连接，而基于卷积神经网络（CNN）的方法从低级信息开始，并在更深层逐步融入全局信息。这些基于CNN的方法表现不佳。MinkUNet34C的$\mathrm{IoU_{macro}}$比基于transformer的方法（Swin3D-s和PTv3）低0.18。3D分割算法的最新进展是导致Swin3D-s、PTv3和我们的2D-to-3D方法之间没有显著差异的原因之一。

表3中的结果是使用预训练网络和优化学习率获得的。其他超参数，如数据增强设置，没有进行优化。这可能引发关于算法之间的比较在技术上是否正确的疑问。当前的数据增强设置基于PTv3在ScanNet数据集上的结果，该数据集包含许多不同大小的客厅的点云。本研究中的点云都与从预定义大小的体素空间中捕获的植物相关。因此，一些数据增强设置（如缩放）可能会引入噪声。另一方面，在Swin3D的研究中（Yang等，2025），3D架构也使用了类似的数据增强设置进行比较。此外，在Xin等（2023）的工作中，将九种不同的数据增强设置与没有数据增强的默认模型进行了比较。所有九种数据增强设置都导致了更高的性能。可以假设本工作中使用的数据增强设置有助于提高性能。通过优化学习率并使用默认的数据增强设置，我们相信在本研究中，已经尝试最大化所提出模型的性能，并在所提出的方法之间进行公平比较。尽管努力最大化性能，但实验1的结果没有显著差异，表明基于实验1的结果，没有对投影、体素或基于点的算法的偏好。

在表4中，所有模型在支柱和主茎之间都显示出许多分类错误。这可能是由于地面实况标注中的错误，因为标注小实例很困难。Boogaard等（2021）使用$\mathrm{IoU_{macro}}$指标确定了两个标注者在植物器官标注任务中的观察者内部变异性，得出了0.77的值。这一结果表明，完美的标注数据集并不存在。此外，它表明将$\mathrm{IoU_{macro}}$与最高分1进行比较并不完全正确。因此，在未来的研究中，建议至少由独立的标注者对测试集进行两次标注。

2D分割网络的输出显示了错误分割的像素（图7b）。在该图中，例如，支柱的上部被预测为叶片。然而，这些错误预测对性能的影响很小，因为由于体素空间小于植物，这些点大多不在点云中。有限的体素空间导致标注的2D数据集中出现白色像素（图5），这些像素在Mask2Former的损失函数中被忽略。然而，因此，模型从未因将支柱的上部预测为叶片而受到惩罚。因此，当前的分割模型是次优的，因为标注的图像包含未知像素。如果点云是完整的，这将导致高质量的标注2D数据集，可能提高2D-to-3D方法的性能。然而，提高点云的完整性需要扩展体素空间，而目前受到相机水平视场的限制。此外，基于轮廓的形状重建方法对内存要求很高，因为每个体素都需要存储在内存中。目前，其他方法如3D Gaussian Splatting正在开发中，并在场景重建中显示出有希望的结果（Kerbl等，2023）。该技术可能在不久的将来成为基于轮廓形状重建方法的替代方案。

# 4.2. 训练效率

当两种模型都在训练集中的35株植物上进行训练时，2D和3D方法的性能没有显著差异。然而，2D-to-3D方法显示出显著更高的数据效率。图8显示，使用5株植物时，2D-to-3D算法的性能与在25个场景上训练的Swin3D-s算法相当。这一结果与Kundu等人（2020）的研究一致，他们在ScanNet数据集上将重投影方法与" SparseConv"（一种与MinkUNet34C相当的算法）进行了比较。在他们的研究中，2D方法在标注场景方面始终优于3D分割算法。通过加入实验4中的额外渲染图像，我们方法的数据效率可能会进一步提高。

在我们的实验中，2D-to-3D方法的标注数据是通过从标注点云渲染图像生成的。因此，创建标注数据集所需的时间对于2D-to-3D和3D分割方法是相似的。这是比较两种不同方法训练效率的一个重要方面，因为数据量直接与创建标注数据集所需的时间相关。如图5a所示，标注RGB图像需要2到4小时，而点云的标注只需要1小时。正如本研究所展示的，单个点云可用于生成至少15个标注的RGB图像，有效地将每个RGB图像的标注时间减少到4分钟。手动标注RGB图像会导致性能大幅下降。结果清楚地强调了3D标注的重要性，通过使用2D-to-3D重投影算法，标注效率提高，并且需要更少的标注植物就能达到与3D分割模型相当的性能。

# 4.3. 相机数量的影响

通过加入10个虚拟相机，将相机数量从5个增加到25个，以研究增加相机数量是否能改善结果。图9显示，当相机数量增加时，性能呈上升趋势。有趣的是，在15个真实相机图像的基础上添加虚拟相机图像后，性能也有所提高。这是出乎意料的，因为点云是从原始的15个相机图像创建的。一个可能的解释是，额外的图像创建了一个独特的视角，使得之前被遮挡的植物部分现在清晰可见。通过添加这些新的预测，之前仅被一两个相机看到的点，现在可能基于三个或更多（遮挡较少）图像的多数投票进行分类。因此，通过添加更多相机图像可以提高分割方法的性能。这与Shi等人（2019）的结果一致，其中2D分割中的任何错误都部分被3D中的投票机制所补偿。当然，增加更多相机的缺点是计算时间线性增加。在本研究中，分割点云的速度并不被视为重要因素，因为处理是离线进行的。在实际环境中，将推理时间纳入评估可能是有意义的。另一方面，如果准确分割至关重要，那么本工作清楚地表明，通过增加更多相机可以提高性能。

# 4.4. 未来建议

在本研究中，将2D-to-3D重投影方法与最先进的3D分割算法进行了比较。在比较中加入组合方法可能会很有趣。Hu等人（2021）提出了一种双向投影网络（BPnet）。双向架构使得2D和3D数据之间的特征交换成为可能，理论上可以提高性能。他们的网络依赖于Minkowski架构，在本研究中表现不佳（表3）。然而，研究Swin-transformer架构是否可以集成到双向结构中可能是值得的。另一个可能有趣的算法是Ponderv2（Zhu等人，2023）。Ponderv2旨在通过专注于预训练骨干网络来提高分割性能（Zhu等人，2023）。具体来说，在他们的范式中，将渲染图像与真实的2D图像进行比较。这些信息被用来监督3D骨干网络，从而提高了性能。

该方法在包含44株番茄的数据集上进行了评估，测试集仅包含5株植物。使用自举法计算了不同模型之间的p值，但建议在未来的实验中增加测试集或应用k折交叉验证。此外，在其他数据集上评估我们的方法可能会很有趣。在第二个实验中，使用真实或渲染图像时没有发现显著差异（表6），这表明所开发的方法也可以在没有真实RGB图像的数据集上工作。

除了提高分割精度外，后处理步骤同样重要。从分割的点云中，可以重建植物结构以确定高度、节间长度和分枝角度。这些特征可以使用骨架化方法计算，但这些方法对噪声敏感（Chebrolu等人，2021）。因此，准确分割至关重要。在本研究中，重点是尽可能准确地将植物分割成器官。虽然有可能提高分割精度，但后处理步骤所需的精度尚不清楚。因此，未来的研究应优先考虑重建植物结构（包括相关植物性状）所需的分割精度。

# 5. 结论

对于植物表型分析，准确分割对于将分割的点云转换为植物性状至关重要。在本研究中，将2D-to-3D重投影方法与三种基于点或体素的3D分割算法进行了比较。重投影方法通过对所有在2D中分割并重投影到点云的点进行多数投票算法来分割点云。结果表明，最先进的基于点或体素的3D分割方法与我们开发的2D-to-3D重投影方法之间没有明显的性能差异。当在训练集中的所有植物上进行训练时，Point Transformer V3（0.78）、Swin3D-s（0.79）和我们开发的2D-to-3D方法（0.78）的$\mathrm{IoU_{macro}}$几乎相同。然而，结果确实表明2D-to-3D方法具有更高的数据效率。仅通过标注5个场景，2D-to-3D重投影方法就获得了与在25个场景上训练的Swin3D-s算法相当的性能。此外，2D-to-3D方法也适用于没有（真实）RGB图像的数据集。我们的实验表明，使用真实或渲染的RGB图像运行模型时没有显著差异。最后，本研究表明，通过将相机数量从15个增加到25个，可以获得比最先进的3D分割算法更高的性能。

本研究为植物表型分析中最先进的投影、基于点和体素的分割方法的性能和训练效率提供了有用的见解。未来，建议将重点放在后处理步骤上，将分割的点云转换为植物性状。目前，尚不清楚需要什么样的分割性能才能以一定的精度估计植物性状。育种者和研究人员可以以合理的精度分割点云，如本研究所示。分割不必完美；只要能够以足够的精度确定植物性状以选择最有前途的基因型，小的误差是可以接受的。因此，未来的研究应专注于下一步，将分割的点云转换为植物性状。

# 作者贡献声明

Bart M. van Marrewijk：撰写-审阅和编辑，撰写-初稿，可视化，验证，软件，资源，项目管理，方法论，调查，资金获取，形式分析，数据管理，概念化。Tim van Daalen：软件。Bolai Xin：资源，数据管理。Eldert J. van Henten：撰写-审阅和编辑，监督。Gerrit Polder：撰写-审阅和编辑，监督。Gert Kootstra：撰写-审阅和编辑，监督。

# 资助

本工作得到了欧盟数字欧洲计划[101100622.t]和名为KB38-DDHTPhotonics for Phenotyping & Disease Detection的内部项目的支持。

# 利益冲突声明

作者声明，他们没有已知的可能影响本工作报告的竞争性财务利益或个人关系。

# 参考文献

Akhtar, M. S., Zafar, Z., Nawaz, R., & Fraz, M. M. (2024). 解锁植物秘密：3D成像在植物表型技术中的系统综述。Computers and Electronics in Agriculture, 222, Article 109033. https://doi.org/10.1016/j. compag.2024.109033   
Apolo-Apolo, O. E., Martínez-Guanter, J., Egea, G., Raja, P., & P´erez-Ruiz, M. (2020). 使用无人机和深度学习技术估算柑橘产量和大小。European Journal of Agronomy, 115, Article 126030. https://doi.org/10.1016/j. eja.2020.126030   
Araus, J. L., & Cairns, J. E. (2014). 田间高通量表型分析：作物育种的新前沿。Trends in Plant Science, 19(1), 52–61. https://doi.org/10.1016/j. tplants.2013.09.008   
Araus, J. L., Kefauver, S. C., Zaman-Allah, M., Olsen, M. S., & Cairns, J. E. (2018). 将高通量表型分析转化为遗传增益。Trends in Plant Science, 23(5), 451–466. https://doi.org/10.1016/j.tplants.2018.02.001   
Boogaard, F. P., Rongen, K. S., & Kootstra, G. W. (2020). 使用深度学习和多视角成像技术实现果蔬作物节点的稳健检测与跟踪。Biosystems Engineering, 192, 117–132. https://doi.org/10.1016/j. biosystemseng.2020.01.023   
Boogaard, F. P., van Henten, E. J., & Kootstra, G. (2021). 通过丰富不完整3D点云的光谱数据提升黄瓜植株部位分割。Biosystems Engineering, 211, 167–182. https://doi.org/10.1016/j. biosystemseng.2021.09.004   
Boogaard, F. P., van Henten, E. J., & Kootstra, G. (2023). 3D点云在数字植物表型中的附加价值——以黄瓜节间长度测量为例。Biosystems Engineering, 234, 1–12. https://doi.org/10.1016/j. biosystemseng.2023.08.010   
Boulch, A., Guerry, J., Le Saux, B., & Audebert, N. (2018). SnapNet：使用2D深度分割网络进行3D点云语义标注。Computers & Graphics, 71, 189–198. https://doi.org/10.1016/j.cag.2017.11.010   
Cardellicchio, A., Solimani, F., Dimauro, G., Petrozza, A., Summerer, S., Cellini, F., & Ren\`o, V. (2023). 使用基于YOLOv5的单阶段检测器检测番茄植株表型特征。Computers and Electronics in Agriculture, 207, Article 107757. https://doi.org/10.1016/j.compag.2023.107757   
Chebrolu, N., Magistri, F., L¨abe, T., & Stachniss, C. (2021). 植物表型的时空点云配准。PLoS One, 16(2), Article e0247243. https://doi.org/10.1371/journal.pone.0247243   
Cheng, B., Misra, I., Schwing, A. G., Kirillov, A., & Girdhar, R. (2022). 用于通用图像分割的掩码注意力变换器。In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition. https://doi.org/10.48550/ arXiv.2112.01527   
Choy, C., Gwak, J., & Savarese, S. (2019). 4D时空卷积网络：Minkowski卷积神经网络。In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition. https://doi.org/10.48550/arXiv.1904.08755   
Cignoni, P., Callieri, M., Corsini, M., Dellepiane, M., Ganovelli, F., & Ranzuglia, G. (2008). Meshlab：一个开源的网格处理工具。Sixth Eurographics Italian Chapter Conference, page 129-136.   
Dai, A., Chang, A. X., Savva, M., Halber, M., Funkhouser, T., & Nießner, M. (2017). Scannet：室内场景的丰富注释3D重建。In Proceedings of the IEEE conference on computer vision and pattern recognition. https://doi.org/10.48550/ arXiv.1702.04405   
Deng, J., Dong, W., Socher, R., Li, L.-J., Li, K., & Fei-Fei, L. (2009). Imagenet：一个大规模分层图像数据库。In 2009 IEEE conference on computer vision and pattern recognition.   
Erisman, J. W., Sutton, M. A., Galloway, J., Klimont, Z., & Winiwarter, W. (2008). 一个世纪的氨合成如何改变了世界。Nature Geoscience, 1(10), 636–639. https://doi.org/10.1109/CVPR.2009.5206848   
Girardeau-Montaut, D. (2024). CloudCompare。https://cloudcompare-org.danielgm.net/ release/.   
Golbach, F., Kootstra, G., Damjanovic, S., Otten, G., & van de Zedde, R. (2016). 使用适合高通量幼苗表型的3D重建方法验证植物部位测量。Machine Vision and Applications, 27, 663–680. https://doi.org/10.1007/s00138-015-0727-5   
Harandi, N., Vandenberghe, B., Vankerschaver, J., Depuydt, S., & Van Messem, A. (2023). 如何理解植物表型的3D表示：处理和分析技术汇编。Plant Methods, 19(1), 60. https://doi.org/10.1186/s13007-023-01031-z   
Hartley, R., & Zisserman, A. (2003). 计算机视觉中的多视图几何。Cambridge university press   
Hawkesford, M. J., & Riche, A. B. (2020). G x E x M对小麦氮利用效率的影响及未来展望。Frontiers in plant science, 11. https://doi.org/10.3389/ fpls.2020.01157 [Review].   
He, K., Zhang, X., Ren, S., & Sun, J. (2016). 用于图像识别的深度残差学习. In Proceedings of the IEEE conference on computer vision and pattern recognition.   
Hu, W., Zhao, H., Jiang, L., Jia, J., & Wong, T.-T. (2021). 用于跨维度场景理解的双向投影网络. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition.   
Kamilaris, A., & Prenafeta-Boldú, F. X. (2018). 农业中的深度学习：综述. Computers and Electronics in Agriculture, 147, 70–90. https://doi.org/10.1016/j. compag.2018.02.016   
Kerbl, B., Kopanas, G., Leimkühler, T., & Drettakis, G. (2023). 用于实时辐射场渲染的3D高斯泼溅. ACM Transactions on Graphics, 42(4), 1–14.   
Kundu, A., Yin, X., Fathi, A., Ross, D., Brewington, B., Funkhouser, T., & Pantofaru, C. (2020). 用于3D语义分割的虚拟多视图融合. In Computer vision–ECCV 2020: 16th European conference, glasgow, UK, august 23–28, 2020, proceedings. https://doi.org/10.1007/978-3-030-58586-0_31. Part XXIV 16.   
Kutulakos, K. N., & Seitz, S. M. (2000). 基于空间雕刻的形状理论. International Journal of Computer Vision, 38, 199–218. https://doi.org/10.1023/A: 1008191222954   
Lawal, M. O. (2021). 基于改进YOLOv3框架的番茄检测. Scientific Reports, 11(1), 1–11. https://doi.org/10.1038/s41598-021-81216-5   
Li, L., Zhang, Q., & Huang, D. (2014). 植物表型成像技术综述. Sensors, 14(11), 20078–20111. https://doi.org/10.3390/s141120078   
Lin, T.-Y., Maire, M., Belongie, S., Hays, J., Perona, P., Ramanan, D., Doll´ar, P., & Zitnick, C. L. (2014). Microsoft coco：上下文中的常见对象. In Computer vision–ECCV 2014: 13th European conference, Zurich, Switzerland, september 6-12, 2014, proceedings. https://doi.org/10.1007/978-3-319-10602-1_48. Part Vol. 13.   
Liu, X., Chen, S. W., Aditya, S., Sivakumar, N., Dcunha, S., Qu, C., Taylor, C. J., Das, J., & Kumar, V. (2018). 鲁棒的水果计数：结合深度学习、跟踪和运动结构. In 2018 IEEE/RSJ international Conference on intelligent robots and systems (IROS). https://doi.org/10.1109/IROS.2018.8594239   
Liu, Z., Lin, Y., Cao, Y., Hu, H., Wei, Y., Zhang, Z., Lin, S., & Guo, B. (2021). Swin transformer：使用移位窗口的分层视觉transformer. In Proceedings of the IEEE/CVF international conference on computer vision.   
Liu, Z., Tang, H., Lin, Y., & Han, S. (2019). 用于高效3D深度学习的点体素CNN. Advances in Neural Information Processing Systems, 32.   
Marrewijk, v., Bart, M., Xin, B., van Daalen, T., van Henten, E., Polder, G., & Kootstra, G. (2025). TomatoWUR：用于定量评估3D植物表型分割、骨架化和植物性状提取算法的3D番茄植物注释数据集. In 4TU.ResearchData. https://doi.org/10.4121/e2c59841-4653-45de-a75e-4994b2766a2f.v1   
Maturana, D., & Scherer, S. (2015). Voxnet：用于实时物体识别的3D卷积神经网络. In 2015 IEEE/RSJ international conference on intelligent robots systems (IROS). https://doi.org/10.1109/IROS.2015.7353481   
Meta AI Research. (2024). ScanNet上的语义分割. Retrieved 29-11-2024 from https://paperswithcode.com/sota/semantic-segmentation-on-scannet.   
Mildenhall, B., Srinivasan, P. P., Tancik, M., Barron, J. T., Ramamoorthi, R., & Ng, R. (2021). Nerf：将场景表示为神经辐射场以进行视图合成. Communications of the ACM, 65(1), 99–106. https://doi.org/10.1145/3503250   
Mmsegmentation, C. (2020). MMSegmentation：OpenMMLab语义分割工具箱和基准. https://github.com/open-mmlab/mmsegmentation.   
Panguluri, S. K., & Kumar, A. A. (2016). 植物育种中的表型分析. Springer.   
Pound, M. P., Atkinson, J. A., Townsend, A. J., Wilson, M. H., Griffiths, M., Jackson, A. S., Bulat, A., Tzimiropoulos, G., Wells, D. M., & Murchie, E. H. (2017). 深度学习在基于图像的植物表型分析中提供了最先进的性能. GigaScience, 6(10), gix083. https://doi.org/10.1093/gigascience/ giy042   
Qi, C. R., Yi, L., Su, H., & Guibas, L. J. (2017). Pointnet：度量空间中点集的深度层次特征学习. Advances in Neural Information Processing Systems, 30.   
Ríos, R. O. (2015). 组学时代的植物育种. Springer. https://doi.org/10.1007/ 978-3-319-20532-8   
Saeed, F., Sun, S., Rodriguez-Sanchez, J., Snider, J., Liu, T., & Li, C. (2023). 使用点体素卷积神经网络进行棉花植株部位3D分割和结构特征提取. Plant Methods, 19(1), 1–23. https://doi.org/ 10.1186/s13007-023-00996-1   
Schunck, D., Magistri, F., Rosu, R. A., Cornelißen, A., Chebrolu, N., Paulus, S., L´eon, J., Behnke, S., Stachniss, C., & Kuhlmann, H. (2021). Pheno4D：用于表型和高级植物分析的玉米和番茄植物点云时空数据集. PLoS One, 16(8), Article e0256340. https://doi.org/10.1371/journal. pone.0256340   
Shi, W., van de Zedde, R., Jiang, H., & Kootstra, G. (2019). 使用深度学习和多视角视觉进行植物部位分割. Biosystems Engineering, 187, 81–95. https://doi. org/10.1016/j.biosystemseng.2019.08.014   
Turgut, K., Dutagaci, H., Galopin, G., & Rousseau, D. (2022). 使用基于3D点的深度学习方法分割玫瑰植株的结构部位. Plant Methods, 18(1), 20. https://doi.org/10.1186/s13007-022-00857-3   
Ubbens, J., Cieslak, M., Prusinkiewicz, P., & Stavness, I. (2018). 植物模型在深度学习中的应用：以莲座植物叶片计数为例. Plant Methods, 14 (1), 6. https://doi.org/10.1186/s13007-018-0273-z   
Vasconez, J. P., Delpiano, J., Vougioukas, S., & Cheein, F. A. (2020). 卷积神经网络在水果检测和计数中的比较：综合评估. Computers and Electronics in Agriculture, 173, Article 105348. https://doi. org/10.1016/j.compag.2020.105348   
Wu, X., Jiang, L., Wang, P.-S., Liu, Z., Liu, X., Qiao, Y., Ouyang, W., He, T., & Zhao, H. (2024). Point transformer V3：更简单更快更强. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition.   
Xin, B., Smolenˇov´a, K., Bartholomeus, H., & Kootstra, G. (2024). 基于树结构定量建模算法的番茄植株茎节级3D表型自动分析流程. Computers and Electronics in Agriculture, 227, Article 109607. https://doi.org/10.1016/j.compag.2024.109607   
Xin, B., Sun, J., Bartholomeus, H., & Kootstra, G. (2023). 用于番茄植株部位语义分割的3D数据增强方法. Frontiers in plant science, 14, Article 1045545. https://doi.org/10.3389/fpls.2023.1045545   
Yang, Y. Q., Guo, Y. X., Xiong, J. Y., Liu, Y., Pan, H., Wang, P. S., … Guo, B. (2025). Swin3d：用于3D室内场景理解的预训练Transformer骨干网络. Computational Visual Media, 11(1), 83–101. https://doi.org/10.26599/ CVM.2025.9450383   
Zhou, B., Zhao, H., Puig, X., Fidler, S., Barriuso, A., & Torralba, A. (2017). 通过ADE20K数据集进行场景解析. In Proceedings of the IEEE conference on computer vision and pattern recognition.   
Zhu, H., Yang, H., Wu, X., Huang, D., Zhang, S., He, X., He, T., Zhao, H., Shen, C., & Qiao, Y. (2023). Ponderv2：为3D基础模型铺平道路的通用预训练范式. arXiv preprint arXiv:2310.08586. https://doi.org/10.48550/ arXiv.2310.08586  

# References  

Akhtar, M. S., Zafar, Z., Nawaz, R., & Fraz, M. M. (2024). Unlocking plant secrets: A systematic review of 3D imaging in plant phenotyping techniques. Computers and Electronics in Agriculture, 222, Article 109033. https://doi.org/10.1016/j. compag.2024.109033   
Apolo-Apolo, O. E., Martínez-Guanter, J., Egea, G., Raja, P., & P´erez-Ruiz, M. (2020). Deep learning techniques for estimation of the yield and size of citrus fruits using a UAV. European Journal of Agronomy, 115, Article 126030. https://doi.org/10.1016/j. eja.2020.126030   
Araus, J. L., & Cairns, J. E. (2014). Field high-throughput phenotyping: The new crop breeding frontier. Trends in Plant Science, 19(1), 52–61. https://doi.org/10.1016/j. tplants.2013.09.008   
Araus, J. L., Kefauver, S. C., Zaman-Allah, M., Olsen, M. S., & Cairns, J. E. (2018). Translating high-throughput phenotyping into genetic gain. Trends in Plant Science, 23(5), 451–466. https://doi.org/10.1016/j.tplants.2018.02.001   
Boogaard, F. P., Rongen, K. S., & Kootstra, G. W. (2020). Robust node detection and tracking in fruit-vegetable crops using deep learning and multi-view imaging. Biosystems Engineering, 192, 117–132. https://doi.org/10.1016/j. biosystemseng.2020.01.023   
Boogaard, F. P., van Henten, E. J., & Kootstra, G. (2021). Boosting plant-part segmentation of cucumber plants by enriching incomplete 3D point clouds with spectral data. Biosystems Engineering, 211, 167–182. https://doi.org/10.1016/j. biosystemseng.2021.09.004   
Boogaard, F. P., van Henten, E. J., & Kootstra, G. (2023). The added value of 3D point clouds for digital plant phenotyping–A case study on internode length measurements in cucumber. Biosystems Engineering, 234, 1–12. https://doi.org/10.1016/j. biosystemseng.2023.08.010   
Boulch, A., Guerry, J., Le Saux, B., & Audebert, N. (2018). SnapNet: 3D point cloud semantic labeling with 2D deep segmentation networks. Computers & Graphics, 71, 189–198. https://doi.org/10.1016/j.cag.2017.11.010   
Cardellicchio, A., Solimani, F., Dimauro, G., Petrozza, A., Summerer, S., Cellini, F., & Ren\`o, V. (2023). Detection of tomato plant phenotyping traits using YOLOv5-based single stage detectors. Computers and Electronics in Agriculture, 207, Article 107757. https://doi.org/10.1016/j.compag.2023.107757   
Chebrolu, N., Magistri, F., L¨abe, T., & Stachniss, C. (2021). Registration of spatiotemporal point clouds of plants for phenotyping. PLoS One, 16(2), Article e0247243. https://doi.org/10.1371/journal.pone.0247243   
Cheng, B., Misra, I., Schwing, A. G., Kirillov, A., & Girdhar, R. (2022). Masked-attention mask transformer for universal image segmentation. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition. https://doi.org/10.48550/ arXiv.2112.01527   
Choy, C., Gwak, J., & Savarese, S. (2019). 4d spatio-temporal convnets: Minkowski convolutional neural networks. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition. https://doi.org/10.48550/arXiv.1904.08755   
Cignoni, P., Callieri, M., Corsini, M., Dellepiane, M., Ganovelli, F., & Ranzuglia, G. (2008). Meshlab: An open-source mesh processing tool. Sixth Eurographics Italian Chapter Conference, page 129-136.   
Dai, A., Chang, A. X., Savva, M., Halber, M., Funkhouser, T., & Nießner, M. (2017). Scannet: Richly-annotated 3d reconstructions of indoor scenes. In Proceedings of the IEEE conference on computer vision and pattern recognition. https://doi.org/10.48550/ arXiv.1702.04405   
Deng, J., Dong, W., Socher, R., Li, L.-J., Li, K., & Fei-Fei, L. (2009). Imagenet: A largescale hierarchical image database. In 2009 IEEE conference on computer vision and pattern recognition.   
Erisman, J. W., Sutton, M. A., Galloway, J., Klimont, Z., & Winiwarter, W. (2008). How a century of ammonia synthesis changed the world. Nature Geoscience, 1(10), 636–639. https://doi.org/10.1109/CVPR.2009.5206848   
Girardeau-Montaut, D. (2024). CloudCompare. https://cloudcompare-org.danielgm.net/ release/.   
Golbach, F., Kootstra, G., Damjanovic, S., Otten, G., & van de Zedde, R. (2016). Validation of plant part measurements using a 3D reconstruction method suitable for high-throughput seedling phenotyping. Machine Vision and Applications, 27, 663–680. https://doi.org/10.1007/s00138-015-0727-5   
Harandi, N., Vandenberghe, B., Vankerschaver, J., Depuydt, S., & Van Messem, A. (2023). How to make sense of 3D representations for plant phenotyping: A compendium of processing and analysis techniques. Plant Methods, 19(1), 60. https://doi.org/10.1186/s13007-023-01031-z   
Hartley, R., & Zisserman, A. (2003). Multiple view geometry in computer vision. Cambridge university press   
Hawkesford, M. J., & Riche, A. B. (2020). Impacts of G x E x M on Nitrogen use efficiency in wheat and future prospects. Frontiers in plant science, 11. https://doi.org/10.3389/ fpls.2020.01157 [Review].   
He, K., Zhang, X., Ren, S., & Sun, J. (2016). Deep residual learning for image recognition. In Proceedings of the IEEE conference on computer vision and pattern recognition.   
Hu, W., Zhao, H., Jiang, L., Jia, J., & Wong, T.-T. (2021). Bidirectional projection network for cross dimension scene understanding. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition.   
Kamilaris, A., & Prenafeta-Boldú, F. X. (2018). Deep learning in agriculture: A survey. Computers and Electronics in Agriculture, 147, 70–90. https://doi.org/10.1016/j. compag.2018.02.016   
Kerbl, B., Kopanas, G., Leimkühler, T., & Drettakis, G. (2023). 3d Gaussian splatting for real-time radiance field rendering. ACM Transactions on Graphics, 42(4), 1–14.   
Kundu, A., Yin, X., Fathi, A., Ross, D., Brewington, B., Funkhouser, T., & Pantofaru, C. (2020). Virtual multi-view fusion for 3d semantic segmentation. In Computer vision–ECCV 2020: 16th European conference, glasgow, UK, august 23–28, 2020, proceedings. https://doi.org/10.1007/978-3-030-58586-0_31. Part XXIV 16.   
Kutulakos, K. N., & Seitz, S. M. (2000). A theory of shape by space carving. International Journal of Computer Vision, 38, 199–218. https://doi.org/10.1023/A: 1008191222954   
Lawal, M. O. (2021). Tomato detection based on modified YOLOv3 framework. Scientific Reports, 11(1), 1–11. https://doi.org/10.1038/s41598-021-81216-5   
Li, L., Zhang, Q., & Huang, D. (2014). A review of imaging techniques for plant phenotyping. Sensors, 14(11), 20078–20111. https://doi.org/10.3390/s141120078   
Lin, T.-Y., Maire, M., Belongie, S., Hays, J., Perona, P., Ramanan, D., Doll´ar, P., & Zitnick, C. L. (2014). Microsoft coco: Common objects in context. In Computer vision–ECCV 2014: 13th European conference, Zurich, Switzerland, september 6-12, 2014, proceedings. https://doi.org/10.1007/978-3-319-10602-1_48. Part Vol. 13.   
Liu, X., Chen, S. W., Aditya, S., Sivakumar, N., Dcunha, S., Qu, C., Taylor, C. J., Das, J., & Kumar, V. (2018). Robust fruit counting: Combining deep learning, tracking, and structure from motion. In 2018 IEEE/RSJ international Conference on intelligent robots and systems (IROS). https://doi.org/10.1109/IROS.2018.8594239   
Liu, Z., Lin, Y., Cao, Y., Hu, H., Wei, Y., Zhang, Z., Lin, S., & Guo, B. (2021). Swin transformer: Hierarchical vision transformer using shifted windows. In Proceedings of the IEEE/CVF international conference on computer vision.   
Liu, Z., Tang, H., Lin, Y., & Han, S. (2019). Point-voxel cnn for efficient 3d deep learning. Advances in Neural Information Processing Systems, 32.   
Marrewijk, v., Bart, M., Xin, B., van Daalen, T., van Henten, E., Polder, G., & Kootstra, G. (2025). TomatoWUR: An annotated dataset of 3D tomato plants to quantitatively evaluate segmentation, skeletonisation, and plant trait extraction algorithms for 3D plant phenotyping. In 4TU.ResearchData. https://doi.org/10.4121/e2c59841-4653-45de-a75e-4994b2766a2f.v1   
Maturana, D., & Scherer, S. (2015). Voxnet: A 3d convolutional neural network for realtime object recognition. In 2015 IEEE/RSJ international conference on intelligent robots and systems (IROS). https://doi.org/10.1109/IROS.2015.7353481   
Meta AI Research. (2024). Semantic segmentation on ScanNet. Retrieved 29-11-2024 from https://paperswithcode.com/sota/semantic-segmentation-on-scannet.   
Mildenhall, B., Srinivasan, P. P., Tancik, M., Barron, J. T., Ramamoorthi, R., & Ng, R. (2021). Nerf: Representing scenes as neural radiance fields for view synthesis. Communications of the ACM, 65(1), 99–106. https://doi.org/10.1145/3503250   
Mmsegmentation, C. (2020). MMSegmentation: OpenMMLab semantic segmentation toolbox and benchmark. https://github.com/open-mmlab/mmsegmentation.   
Panguluri, S. K., & Kumar, A. A. (2016). Phenotyping for plant breeding. Springer.   
Pound, M. P., Atkinson, J. A., Townsend, A. J., Wilson, M. H., Griffiths, M., Jackson, A. S., Bulat, A., Tzimiropoulos, G., Wells, D. M., & Murchie, E. H. (2017). Deep machine learning provides state-of-the-art performance in image-based plant phenotyping. GigaScience, 6(10), gix083. https://doi.org/10.1093/gigascience/ giy042   
Qi, C. R., Yi, L., Su, H., & Guibas, L. J. (2017). Pointnet : Deep hierarchical feature learning on point sets in a metric space. Advances in Neural Information Processing Systems, 30.   
Ríos, R. O. (2015). Plant breeding in the Omics era. Springer. https://doi.org/10.1007/ 978-3-319-20532-8   
Saeed, F., Sun, S., Rodriguez-Sanchez, J., Snider, J., Liu, T., & Li, C. (2023). Cotton plant part 3D segmentation and architectural trait extraction using point voxel convolutional neural networks. Plant Methods, 19(1), 1–23. https://doi.org/ 10.1186/s13007-023-00996-1   
Schunck, D., Magistri, F., Rosu, R. A., Cornelißen, A., Chebrolu, N., Paulus, S., L´eon, J., Behnke, S., Stachniss, C., & Kuhlmann, H. (2021). Pheno4D: A spatio-temporal dataset of maize and tomato plant point clouds for phenotyping and advanced plant analysis. PLoS One, 16(8), Article e0256340. https://doi.org/10.1371/journal. pone.0256340   
Shi, W., van de Zedde, R., Jiang, H., & Kootstra, G. (2019). Plant-part segmentation using deep learning and multi-view vision. Biosystems Engineering, 187, 81–95. https://doi. org/10.1016/j.biosystemseng.2019.08.014   
Turgut, K., Dutagaci, H., Galopin, G., & Rousseau, D. (2022). Segmentation of structural parts of rosebush plants with 3D point-based deep learning methods. Plant Methods, 18(1), 20. https://doi.org/10.1186/s13007-022-00857-3   
Ubbens, J., Cieslak, M., Prusinkiewicz, P., & Stavness, I. (2018). The use of plant models in deep learning: An application to leaf counting in rosette plants. Plant Methods, 14 (1), 6. https://doi.org/10.1186/s13007-018-0273-z   
Vasconez, J. P., Delpiano, J., Vougioukas, S., & Cheein, F. A. (2020). Comparison of convolutional neural networks in fruit detection and counting: A comprehensive evaluation. Computers and Electronics in Agriculture, 173, Article 105348. https://doi. org/10.1016/j.compag.2020.105348   
Wu, X., Jiang, L., Wang, P.-S., Liu, Z., Liu, X., Qiao, Y., Ouyang, W., He, T., & Zhao, H. (2024). Point transformer V3: Simpler faster stronger. In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition.   
Xin, B., Smolenˇov´a, K., Bartholomeus, H., & Kootstra, G. (2024). An automatic 3D tomato plant stemwork phenotyping pipeline at internode level based on tree quantitative structural modelling algorithm. Computers and Electronics in Agriculture, 227, Article 109607. https://doi.org/10.1016/j.compag.2024.109607   
Xin, B., Sun, J., Bartholomeus, H., & Kootstra, G. (2023). 3D data-augmentation methods for semantic segmentation of tomato plant parts. Frontiers in plant science, 14, Article 1045545. https://doi.org/10.3389/fpls.2023.1045545   
Yang, Y. Q., Guo, Y. X., Xiong, J. Y., Liu, Y., Pan, H., Wang, P. S., … Guo, B. (2025). Swin3d: A pretrained transformer backbone for 3d indoor scene understanding. Computational Visual Media, 11(1), 83–101. https://doi.org/10.26599/ CVM.2025.9450383   
Zhou, B., Zhao, H., Puig, X., Fidler, S., Barriuso, A., & Torralba, A. (2017). Scene parsing through ade20k dataset. In Proceedings of the IEEE conference on computer vision and pattern recognition.   
Zhu, H., Yang, H., Wu, X., Huang, D., Zhang, S., He, X., He, T., Zhao, H., Shen, C., & Qiao, Y. (2023). Ponderv2: Pave the way for 3d foundataion model with a universal pre-training paradigm. arXiv preprint arXiv:2310.08586. https://doi.org/10.48550/ arXiv.2310.08586  