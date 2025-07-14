# Interpretability of deep learning models for crop yield forecasting

# 深度学习模型在作物产量预测中的可解释性研究

Dilli Paudel a,*, Allard de Wit b, Hendrik Boogaard b, Diego Marcos c, Sjoukje Osinga a, Ioannis N. Athanasiadis d

a 瓦赫宁根大学与研究中心信息技术组，荷兰瓦赫宁根Hollandseweg 1，6706 KN  
b 瓦赫宁根大学与研究中心环境研究所，荷兰瓦赫宁根邮政信箱47，6700 AA  
c 法国蒙彼利埃大学Inria研究所  
d 瓦赫宁根大学与研究中心地理信息科学与遥感实验室及数据能力中心，荷兰瓦赫宁根Droevendaalsesteeg 3，6708 PB

# 文章信息

关键词：作物产量 深度学习 神经网络 可解释性 人类利益相关者

# 摘要

作物产量预测的机器学习模型通常依赖于专家设计的特征或预测因子。这些人工特征的有效性和可解释性取决于设计者的专业水平。神经网络能够直接从输入数据中学习特征，并同步完成特征学习和预测步骤。本文使用欧盟委员会联合研究中心的MARS作物产量预测系统数据，评估了神经网络模型在产量预测中的性能和可解释性。选用的神经网络可处理时序数据，包括长短期记忆(LSTM)循环神经网络和一维卷积神经网络(1DCNN)。性能对比包括线性趋势模型和使用人工特征训练的梯度提升决策树(GBDT)模型。通过特征归因方法计算输入变量的重要性评分，并由作物产量建模和农学专家进行分析。结果表明，在德国软小麦案例中，LSTM模型统计显著优于GBDT模型，在其他案例中表现相当。此外，LSTM模型能很好地捕捉产量趋势、静态特征(如海拔)、土壤持水能力和生物量特征的影响，但对极端温度和湿度条件的捕捉存在困难。本研究展示了深度学习自动学习特征并产生可靠产量预测的潜力，同时强调了人类利益相关者参与模型可解释性评估的重要性和挑战。

# 1. 引言

作物产量预测为农民、政策制定者和商品交易商等利益相关者提供重要信息，有助于制定与粮食安全和市场准入相关的战略决策(Basso and Liu, 2019; Chipanshi et al., 2015)。作物产量受作物特性、环境因素和管理措施之间复杂相互作用的综合影响。这种复杂性使得理解产量预测模型既具挑战性又至关重要。近年来，机器学习方法在作物产量预测中日益普及(Chlingaryan et al., 2018; van Klompenburg et al., 2020)。这些方法的可靠性取决于其预测结果能否以人类可理解的方式被解释。

可解释性被定义为人类能够理解决策原因的程度(Miller, 2019; Doshi-Velez and Kim, 2017)。可解释性与信任相关，而信任通常基于理解模型预测如何随输入变化而变化。准确性和效率是可解释性的另外两个要求(Ruping, 2006)。准确性意味着预测必须接近观测值；效率意味着人类必须在有限时间内理解模型行为。常见的可解释性解决方案是构建简单且本质可理解的模型，如线性模型、基于过程的模型或决策树(Molnar, 2022; Ribeiro et al., 2016)。由于简单和可解释的优势，结合作物模型输出、气象变量和遥感指标的线性回归被广泛用于产量预测(Lobell et al., 2015; van der Velde and Nisini, 2019; Statistics Canada, 2020)。但仅关注本质可解释的模型会限制可建模的关系类型，从而降低准确性和实用性(Ribeiro et al., 2016)。

机器学习和深度学习模型能够学习复杂关系，但由于缺乏对其预测机制的理解，常被视为"黑箱"(McGovern等，2019)。决策树及其集成方法等具有内在可解释性，而神经网络等其他方法则需依赖特征归因方法(Montavon等，2018；Ancona等，2018；Lundberg和Lee，2017)来弥补这一不足。这些方法将原始模型视为黑箱，通过分析模型预测结果来获得预测因子与作物产量之间的事后解释。可解释机器学习和可解释人工智能(XAI)正成为日益重要的研究领域(Samek等，2019；McGovern等，2019；Xu等，2019；Molnar，2022)。借助特征归因方法，深度学习模型变得更容易理解和解释。

深度学习还具有自动特征学习的优势。传统机器学习方法需要基于专家知识设计特征或预测因子。这种人工特征设计虽能产生有意义的特征，但也存在限制其大规模应用的缺陷：首先，除某些具有明确定义公式的特征(如植被指数)外，特征设计过程通常耗时且依赖人工(Bengio等，2013)；其次，人工特征的有效性取决于设计者的专业水平；第三，使用人工特征的方法通常将特征设计与预测步骤分离，这种分离阻碍了在模型训练过程中根据监督标签(如产量统计数据)更新特征设计。神经网络可直接从输入数据中提取特征或表示，自动特征学习不仅降低了对专家知识的依赖，还能利用训练标签的监督信号同时优化特征提取和预测步骤，这种联合学习提高了所学特征的判别能力(Wang和Yang，2018)。

许多研究已将深度学习应用于作物产量预测(Gavahi等，2021；Nevavuori等，2019；Oikonomidis等，2022；van Klompenburg等，2020)，部分研究还比较了与传统机器学习方法的性能并分析了特征影响(Khaki等，2020；Nayak等，2022；Shook等，2021；Wolanin等，2020)。但这些研究未能解决向人类利益相关者解释特征重要性或模型行为的挑战。解释预测产生的原因与预测本身同等重要。我们提出了一种方法，让人工专家既参与人工特征设计，也参与评估神经网络学到的特征和关系。通过这种方法，我们评估了深度学习模型在产量预测中的准确性和可解释性。具体而言，我们试图回答两个问题：(i)给定相同输入数据，深度学习模型相比使用专家设计特征的传统机器学习模型表现如何？(ii)根据专家判断，深度学习模型的预测是否基于预期或合理的关系？为回答第一个问题，我们将预测性能与梯度提升决策树(GBDT)模型进行比较；为回答第二个问题，我们采用定量与定性相结合的方法评估可解释性。通过事后分析深度学习模型获得特征重要性评分，并绘制图表显示对产量影响的大小和方向(正向或负向)。由同一批曾参与特征设计的作物产量建模和农学专家，分析观察到的特征关系及其相对重要性。我们的方法提供了比较传统机器学习和深度学习性能的框架，并将人类利益相关者反馈纳入可解释性评估。性能比较涵盖两种作物(软小麦和谷物玉米)和五个国家(德国、西班牙、法国、匈牙利和意大利)，可解释性分析则限于法国的软小麦和谷物玉米。本研究揭示了神经网络自动学习有意义特征并产生可靠产量预测的潜力，自动化特征提取降低了大范围产量预测对人工特征设计的依赖。

论文结构如下：第2节描述数据和方法；第3节展示结果；第4节讨论研究发现并指出未来方向；第5节总结结论。附录A提供了未包含在第2节(方法)、第3节(结果)和第4节(讨论)中的细节和佐证。

# 2. 方法

本研究旨在评估深度学习模型在作物产量预测中的准确性和可解释性。我们构建了三种模型来评估神经网络自动学习特征并产生准确产量预测的能力(图1)。首先，线性趋势模型作为预测能力的基准("零"模型)；其次，梯度提升决策树(GBDT)模型代表使用专家设计特征训练的标准机器学习方法。其他研究常与线性模型、支持向量机(Boser等，1992；Cortes和Vapnik，1995)和随机森林(Breiman，2001)进行性能比较。本研究选择GBDT是因其在欧洲区域作物产量预测中的优异表现(Paudel等，2021，2022)。第三，采用能够从季节性时间序列数据中提取特征的架构构建深度学习模型。为评估可解释性，使用特征归因方法分析深度学习模型的预测结果，提取表征特征重要性的定量指标，包括对作物产量影响的大小和方向(正向或负向)。基于专业知识和经验，人类专家对特征的相对重要性及其对产量的影响进行了定性分析和验证。

# 2.1. 数据

数据来源于欧盟委员会联合研究中心的MARS作物产量预测系统(MCYFS)(EC-JRC，2022；MARSWiki，2021)和欧盟统计局(Eurostat，2021)。季节性时间序列指标(每旬或约10天周期)包括WOFOST作物模型输出(De Wit等，2019；van Diepen等，1989；Supit等，1994)、气象变量和遥感指标，均聚合至NUTS3区域级别(表1)。NUTS是为统计和政策目的划分欧盟领土的体系(Eurostat，2016)。使用前五年的产量值学习产量趋势，以捕捉技术进步的影响。土壤持水能力、海拔、坡度、田块大小和灌溉面积等静态数据用于捕捉季节性数据未覆盖的区域空间差异(Paudel等，2022)。此外，添加农业环境分区作为分类变量以考虑其他农业气候差异。案例研究涵盖两种作物(软小麦和谷物玉米)和五个国家：德国(DE)、西班牙(ES)、法国(FR)、匈牙利(HU)和意大利(IT)(图A.1)。模型以NUTS3级别的产量统计数据作为真实值进行训练。遥感数据和产量数据决定了总数据量，范围从谷物玉米(HU)的300个标记实例到软小麦(DE)的1950个，大多数案例覆盖1999至2018年。测试集由最近30%的可用年份组成。模型超参数通过五折滑动验证方案进行优化(图A.5)。

# 2.2. 趋势模型和GBDT模型

趋势模型通过前五年的产量值拟合一条直线。GBDT代表需要基于专家知识设计特征的标准机器学习算法。GBDT是一种决策树集成方法，依赖boosting(Friedman, 2001)来生长决策树。对于GBDT模型，作物生长历期从WOFOST模拟的发育阶段推断而来，用于设计捕捉不同作物历期阶段各预测因子影响的特征(Paudel等，2021；图A.2)。我们邀请五位专家完成关于各阶段重要产量预测因子的调查：出苗前(p0)、出苗期(p1)、营养生长期(p2)、开花期(p3)、产量形成期(p4)和成熟期(p5)。第2.5.2节提供了专家背景的详细信息。针对每个阶段，专家们提供了影响作物生长发育和最终产量的季节性指标。调查结果和后续讨论被用于设计GBDT模型的特征。表2展示了用于特征设计的指标选择。除提取季节性特征的步骤外(图2)，GBDT和深度学习模型的输入数据及训练测试划分(图A.5)完全一致。

![](images/a48ead202c54d1411ecff8e202e4a724309b1340edbf6cb886faf1ddb9176514.jpg)  
图1. 评估深度学习模型性能和可解释性的框架。性能比较包括趋势模型和GBDT模型。GBDT的特征由专家设计，而深度学习模型自动提取特征。选择长短期记忆网络(LSTM)和一维卷积神经网络(1DCNN)从季节性指标时间序列中学习特征。静态特征(如海拔)和产量趋势特征在GBDT和深度学习中保持一致。通过对深度学习模型预测的事后分析获得特征重要性评分，作为可解释性的量化指标。这些评分表示特征影响的大小及其对产量的正向或负向作用。熟悉产量影响因素的专家分析并反馈了特征的相对重要性及其与产量的关系。

# 2.3. 深度学习模型

将专家认为重要的同一组季节性指标输入深度学习模型，但不进行特征设计。选择的架构包括长短期记忆(LSTM)循环神经网络和一维卷积神经网络(1DCNN)，它们能从序列数据中自动学习特征。LSTM逐步处理序列输入，通过记忆机制保留或遗忘先前时间步的信息。1DCNN使用滑动核或滤波器对输入数据进行局部特征提取。附录A.3提供了LSTM和1DCNN架构的补充信息。LSTM或1DCNN学到的特征与产量趋势数据及静态数据结合后传递至输出层(图2)。使用Adam优化器(Kingma和Ba，2014)优化模型参数或权重，批量大小为16。通过自定义5折验证(图A.5；Paudel等，2022)优化学习率和权重衰减(即L2惩罚项)λ等超参数。采用早停策略在验证集上评估最优超参数模型——当验证误差连续两个epoch增加时停止训练。最终使用优化后的超参数和早停epoch在测试集上评估模型。

# 2.4. 特征归因方法

我们考虑了三种事后特征归因方法：遮挡法(Occlusion, Zeiler和Fergus, 2014)、积分梯度(Integrated Gradients, Sundararajan等, 2017)和梯度SHAP(GradientShap, Lundberg和Lee, 2017)。遮挡法类似于敏感性分析，它用基线值(零或随机值)替换部分特征数据，并比较预测误差的差异。积分梯度通过近似模型输出对输入沿基线到输入路径上梯度(或偏导数)的积分来计算特征重要性。基线可以是零或随机值。Ancona等(2018)发现遮挡法能更好地识别少量重要特征，而积分梯度更擅长捕捉全局非线性效应和特征间交互作用。我们选择基于SHAP(Shapley加性解释，Lundberg和Lee(2017))的梯度SHAP方法，以包含合作博弈论中Shapley值的理想特性。Shapley值(Shapley, 1953)能在多重共线性存在时捕捉线性模型的特征重要性(Lipovetsky和Conklin, 2001)。梯度SHAP使用期望梯度来近似Shapley值。期望梯度可视为具有多个基线和输入与基线之间路径上一个点的积分梯度的近似。梯度SHAP和积分梯度产生的解释具有加性。对于梯度SHAP，各特征贡献的总和近似于原始模型的输出(Lundberg和Lee, 2017)。对于积分梯度，特征贡献的总和等于输入处输出与基线处输出之间的差异(Sundararajan等, 2017)。梯度SHAP假设输入特征相互独立。这一假设简化了特征贡献分析，但忽略了特征交互。本文所有方法均通过Captum(Kokhlikyan等, 2020)实现——这是一个为PyTorch(Paszke等, 2019)设计的模型可解释性框架。

表1 数据来源汇总。案例研究涵盖两种作物和五个国家：软小麦(德国、西班牙、法国、意大利)和谷物玉米(西班牙、法国、匈牙利、意大利)。

| 数据 | 数据类型 | 指标及来源 |
|------|---------|-----------|
| WOFOST作物模型输出 | 季节性时间序列(每旬) | 水分限制干物质生物量(WLIM_YB, kg ha-1)、水分限制储藏器官干重(WLIM_YS, kg ha-1)、水分限制叶面积指数(WLAI, m2m-2)、发育阶段(DVS, 0-200)、根区土壤湿度占持水能力百分比(RSM)。来源：MCYFS。参见Lecerf等(2019)。日最高气温(TMAX, °C)、日最低气温(TMIN, °C)、日平均气温(TAVG, °C)、日降水总量平均值(PREC, mm)、短植被日蒸散发总量(ET0, mm)(Penman-Monteith, Allen等, 1998)、气候水平衡(CWB = PREC - ET0, mm)。来源：MCYFS。参见Lecerf等(2019)。 |
| 遥感数据 | 季节性时间序列(每旬) | 光合有效辐射吸收比例(平滑处理)(FAPAR)。来源：MCYFS。参见哥白尼GLS(2020)。 |
| 全球农业环境分层 | 静态数据 | 农业环境分区标识符。来源：全球农业环境分层(Mücher等, 2016)。 |
| 灌溉面积 | 静态数据 | 总灌溉面积(IRRIG_AREA_ALL, ha)、谷物玉米灌溉面积(IRRIG_AREA2, ha)、作为软小麦代理的谷物灌溉面积(IRRIG_AREA90, ha)。来源：EC-JRC(2022)。 |
| 海拔、坡度 | 静态数据 | 平均海拔(AVG_ELEV, m)、海拔标准差(STD_ELEV, m)、平均坡度(AVG_SLOPE, 度)、坡度标准差(STD_SLOPE, 度)。来源：USGS-EROS(2021)。 |
| 土壤 | 静态数据 | 土壤持水能力(SM_WHC)。来源：MCYFS。参见Lecerf等(2019)。 |
| 田块大小 | 静态数据 | 平均田块大小(AVG_FIELD_SIZE, ha)、田块大小标准差(STD_FIELD_SIZE, ha)。来源：Lesiv等(2019)。 |
| 产量 | 年度数据 | NUTS3区域级别产量(t/ha)。来源：DE-RegionalStatistics(2020)、EC-JRC(2022)、Eurostat(2021)、FR-Agreste(2020)。 |

表2 GBDT模型特征设计表

| 生长阶段 | 最大值特征 | 平均值特征(*表示累计值平均) | Z分数(极端值特征) |
|---------|-----------|---------------------------|------------------|
| 出苗前(p0) | - | 气候水平衡(CWB) | - |
| 播种/出苗期(p1) | - | 平均气温(TAVG)、气候水平衡(CWB)* | 最低气温(TMIN)、降水(PREC) |
| 营养生长期(p2) | 水分限制生物量(WLIM_YB)、叶面积指数(WLAI) | 根区土壤湿度(RSM)、平均气温(TAVG)、气候水平衡(CWB)*、光合有效辐射吸收比例(FAPAR) | 根区土壤湿度(RSM) |
| 开花期(p3) | - | - | 根区土壤湿度(RSM)、降水(PREC)、最高气温(TMAX) |
| 产量形成期(p4) | 水分限制生物量(WLIM_YB)、叶面积指数(WLAI)、水分限制储藏器官(WLIM_YS) | 根区土壤湿度(RSM)、光合有效辐射吸收比例(FAPAR) | 根区土壤湿度(RSM) |
| 成熟/收获期(p5) | - | 降水(PREC) | 降水(PREC) |

注：本表根据Paudel等(2022)的特征设计表更新，结合专家调查和后续讨论确定。专家识别了作物不同生长发育阶段的重要指标。WOFOST指标包括：水分限制干物质生物量(WLIM_YB)、水分限制储藏器官干重(WLIM_YS)、水分限制叶面积指数(WLAI)、根区土壤湿度(RSM)。气象变量包括：日最高/最低/平均气温(TMAX/TMIN/TAVG)、日降水总量(PREC)、气候水平衡(CWB)。遥感指标为光合有效辐射吸收比例(FAPAR)。

# 2.5. 评估

我们通过三个步骤评估深度学习模型的性能和可解释性。首先，如第2.2和2.3节所述构建三种模型，将深度学习模型的预测结果与趋势模型和GBDT模型进行比较。其次，使用特征归因方法提取深度学习模型输入特征的重要性评分。第三，由人类专家分析特征与产量关系的可解释性以及特征的相对重要性。在深度学习场景中，"特征"泛指从季节性数据学习到的特征、趋势特征和静态数据。

# 2.5.1. 产量预测评估

采用归一化均方根误差(NRMSE)比较模型性能，定义为RMSE除以测试集平均产量。为生成季初预测，GBDT和深度学习模型均使用收获前60天的季节性数据。为消除随机种子或权重初始化的影响，收集10次模型运行的GBDT和深度学习预测结果。使用10次运行的平均NRMSE比较趋势模型、GBDT和深度学习(LSTM与1DCNN)的性能。同样地，用于箱线图和统计检验的预测残差也取10次运行的平均值。采用Mann-Whitney U检验(Mann和Whitney, 1947)评估性能显著性，这是独立样本t检验的非参数版本。通过预测残差(预测产量-报告产量)的箱线图分析方差和异常值。针对法国测试年份的产量和预测结果进行空间变异性定性分析。

# 2.5.2. 特征重要性与可解释性评估

我们选择五位专家提供作物产量关键预测因子的意见，其中四位参与特征重要性和可解释性评估。专家筛选标准是基于对法国软小麦和谷物玉米影响因素的熟悉程度。一位来自Wageningen植物生产系统，具有农学和产量差分析背景；两位是Wageningen环境研究所的高级研究员，具有作物建模经验；另两位来自欧盟委员会联合研究中心(Ispra)，作为MCYFS分析师从事国家级作物产量预测工作。所有专家均熟悉输入数据并具有产量预测模型构建经验，但未使用过深度学习方法，也未参与深度学习架构设计或特征归因方法选择。

![](images/f33ba89ed98d832d20d63aff4d06cc78644918b38ef232728cea36556f9b9652.jpg)  
图2. 深度学习框架(b)与GBDT设置(a)对比。GBDT的季节性特征由专家设计，而深度学习通过训练LSTM或1DCNN从季节性指标数据中自动学习特征。产量趋势特征和静态特征与季节性特征拼接后传递至输出层。框架设计尽可能保持与GBDT设置一致。

关于产量关键预测因子的调查在深度学习实验前进行，因此专家提供的是各特征影响产量的先验知识。调查采用五级量表：强负向影响(-1)、弱负向影响(-0.5)、无影响(0)、弱正向影响(0.5)、强正向影响(1)。专家对静态特征和作物生长季不同时期的季节性指标进行评分。水分限制叶面积指数(WLAI)和降水(PREC)因与其他生物量/水分指标存在相关性未纳入初始调查，后根据专家建议在后续讨论中补充。

评估深度学习模型可解释性时，我们结合特征归因方法的定量重要性评分和专家的定性一致性评分。针对每个特征，绘制重要性评分与特征值的关系图以显示其对产量的正向/负向影响：高特征值对应高重要性表示正向影响，低特征值对应高重要性表示负向影响。为消除权重初始化和随机基线的影响，我们对100次运行(10个模型×10次特征归因)的重要性评分求和。由于特征重要性评分具有可加性，可视为各特征对产量预测的(正向/负向)贡献。

特征重要性分析针对法国软小麦和谷物玉米进行。法国数据量充足且质量较高(Schauberger等, 2018)，产量时空变异性显著。产量变异通常分为三个组分：平均产量、产量趋势和趋势偏差(Dagnelie等, 1983)。深度学习模型输入包含：反映地形、管理和农业气候差异引起的区域平均产量变异的静态数据，表征技术进步的多年度产量趋势特征，以及从旬数据时间序列中学习捕获年度趋势偏差的季节性特征。重要性评分按五类特征汇总：静态数据、产量趋势特征、季节性生物量特征、季节性温度特征和季节性水分特征。季节性特征重要性按作物历期阶段(图A.2)划分：出苗前(p0)、出苗期(p1)、营养生长期(p2)、开花期(p3)、产量形成期(p4)和成熟期(p5)。

专家基于其对作物产量影响因素及相互作用的专业知识，评估了深度学习特征重要性的可解释性。具体而言，他们提供了两类评分：特征对产量影响方向（正向/负向）的认同度（Direction），以及特征影响相对强度的认同度（Magnitude）（图3）。产量指季末最终产量，相对强度指不同特征评分间的比较。专家还可选择"不理解特征重要性图展示的关系"选项。在讨论环节分析了多特征的交互效应。专家填写评分时需附简短说明，特别是对存在异议的情况。

![](images/50084d5881194f88d38686b9bb344a9d67faf004fe9c985b0d57e077e717a213.jpg)  
图3. 专家可解释性评估的认同-异议象限图

象限从两个维度表示专家与特征重要性评分的一致性：特征对产量影响的方向性（Direction），以及特征影响的相对强度（Magnitude）。

# 3. 结果

性能比较采用收获前60天的数据运行含LSTM和1DCNN层的深度学习模型。由于LSTM在验证集表现更优（图A.6），本文主要报告LSTM结果。可解释性分析针对LSTM和GradientShap方法。选择GradientShap因其重要性评分在多次运行中方差较小（表A.3）。基于Wasserstein距离度量，GradientShap与积分梯度(Integrated Gradients)评分相似：软小麦(FR)距离0.005，谷物玉米(FR)距离0.004；而GradientShap与遮挡法(Occlusion)评分距离分别为0.215和0.287。

# 3.1. 性能比较

软小麦LSTM模型在德国(DE)显著优于GBDT（p值0.001），其他国家与GBDT统计相当（p值0.373-0.71），且所有国家均显著优于趋势模型（表A.1）。各国平均NRMSE显示GBDT与LSTM差异小于1%（图4a），均低于趋势模型。谷物玉米表现稍逊：LSTM预测与GBDT统计相当（p值0.298-0.566）（表A.2），两者NRMSE均低于趋势模型（图4b），但Mann-Whitney U检验p值(0.396-0.996)表明GBDT和LSTM未显著优于趋势模型。两种作物中，LSTM在10次运行的变异度（标准差）均高于GBDT，说明权重初始化对深度学习的影响大于随机种子对GBDT的影响。

法国(FR)的预测残差箱线图和空间分布图显示类似模式。软小麦方面，GBDT和LSTM的残差范围和异常值均少于趋势模型（图4c）。德国(DE)的LSTM残差更接近零，其他国家LSTM与GBDT无显著差异。法国软小麦空间分布图（图A.6）显示除2016年北部严重减产外（参见Ben-Ari等(2018)），GBDT和LSTM预测均接近统计值。谷物玉米方面，GBDT和LSTM残差范围在西班牙(ES)、法国(FR)和匈牙利(HU)略小于趋势模型（图4d），意大利(IT)各模型箱线图相似。法国谷物玉米预测（图A.7）与统计值差异较大，不仅出现在2015年中欧减产年，2014、2016和2017年亦然。总体而言，谷物玉米预测精度低于软小麦。

# 3.2. 特征重要性可解释性

特征重要性评分显示趋势特征最重要（图A.10），静态特征次之，季节性特征重要性较低。多数专家认同此排序。趋势和静态特征能降低模型偏差并设定产量基准，故重要性高。年际趋势偏差通常较小，因此季节性特征重要性低。这在谷物玉米中尤为明显：趋势模型预测与GBDT和LSTM统计相当，多数季节性特征重要性接近零。

# 3.2.1. 静态特征

农业环境分区(AEZ)特征捕获了软小麦和谷物玉米的区域平均产量变异（图A.9）。软小麦方面，北部AEZ与产量呈正相关（对应高平均产量），南部AEZ呈负相关。谷物玉米模式相反：南部AEZ平均产量更高且重要性图显示正相关。

其他静态数据中，专家预期土壤持水能力(SM_WHC)、平均田块规模和灌溉面积有正向影响，海拔和坡度为负向影响（图5a(i),5b(i)）。软小麦重要性图显示除总灌溉面积外均符合预期（图5a(ii)）。经讨论，专家认同南部灌溉面积高但软小麦平均产量低导致负相关。部分专家对海拔的负向影响和田块规模的正向影响存疑（图5c(i)）。后续解释为海拔与SM_WHC负相关（后者对产量有正向影响），田块规模的正面效应与法国北部高产、南部低产相关。谷物玉米方面，灌溉面积的负相关和海拔的正相关较难理解（图5b(ii),5c(ii)）。

# 3.2.2. 季节性特征

LSTM网络从10个季节性指标(每个指标包含30个旬值)的矩阵中学习季节性特征。为增强可解释性，各指标的重要性评分按作物历期阶段汇总。重要性评分显示特征与软小麦产量间存在明确关系：生物量特征在生长季后期更重要，而温度和水分特征在生长季早期也有显著影响(图6a)。此外，温度和两个水分特征(降水PREC和气候水平衡CWB)的影响在营养生长期(p2)前后由负转正。对于谷物玉米，生物量特征的影响仍可理解，但温度和水分特征的作用较不明确(图6b)。本节将深度学习模型的重要性评分与专家评分进行比较，并汇总专家对各类季节性特征的可解释性评价。

![](images/562393d64f7dee11830dd1cdfd7db2ab3ec710d9d077a19964abb45da6f7bc15.jpg)  
图4. 收获前60天的性能比较。(a)(b): 深度学习模型与趋势模型、GBDT在各国的平均归一化均方根误差(NRMSE)。(c)(d): 预测残差(预测产量-统计产量)箱线图。预测残差和NRMSE使用所有测试年份国内所有区域的预测值计算，再对10个模型取平均。(a)(b)中的误差条表示10个模型NRMSE的标准差。

生物量特征：专家预期生物量特征从营养生长期(p2)开始对产量产生正向影响(图6a(i),6b(i))。软小麦方面，所有四个生物量特征(水分限制干物质生物量WLIM_YB、水分限制储藏器官干重WLIM_YS、水分限制叶面积指数WLAI、光合有效辐射吸收比例FAPAR)在开花期(p3)和产量形成期(p4)均与产量呈正相关(图6a(ii),7a(ii))。专家普遍认为这些关系可解释(图6c(i))。持异议的一位专家指出生物量特征不适合作为国家级产量的预测因子。谷物玉米方面，生物量特征的重要性评分较小(约为软小麦的1/10)，且WLIM_YB的影响直到产量形成期(p4)才显现。WLAI从营养生长期(p2)开始持续正向影响，WLIM_YS在产量形成期(p4)呈现预期正向影响(图6b(ii),7b)。多数专家认同WLAI的重要性，但对其他指标存疑(图6c(ii))。与专家预期相反，FAPAR未显示重要性。当WLAI超过特定阈值时FAPAR重要性降低(参见Gitelson等(2014))，这可能由于谷物玉米具有较高WLAI。

温度特征：软小麦方面，温度指标(最低温TMIN、最高温TMAX、日均温TAVG)在营养生长期(p2)前与产量负相关，在开花期(p3)及之后转为正相关(图6a(ii),8a(ii))，即生长季早期偏好低温，后期高温促进增产。谷物玉米方面，温度影响在整个生长季呈现混合且微弱的效果(图6b(ii),图A.11a(ii))。专家预期两种作物在出苗期(p1)和营养生长期(p2)的极端低温、开花期(p3)和产量形成期(p4)的极端高温均对产量有负向影响(图6a(i),6b(i))。部分专家认同特征重要性图，因法国温度可能处于作物最适区间(图6c)。无论如何，深度学习特征重要性未捕捉极端温度的影响(图6a,6b;图8a;图A.11a)。软小麦在开花期(p3)和产量形成期(p4)的高温具有高重要性评分。谷物玉米方面，开花期温度确实存在轻微负向影响，但重要性评分接近零(图6b(ii),图A.11a(ii))。

![](images/1fc9d0f1bb52dcc33912a6b9e32d3881d3c7e0f6c9b920a262ba255c798759af.jpg)

(a)软小麦：专家调查(i)与深度学习模型(ii)的特征重要性

![](images/6d395d30fdab402996894730c4f52e9b55b12c0d008fd7849aa943bb8bd14411.jpg)

(b)谷物玉米：专家调查(i)与深度学习模型(ii)的特征重要性

![](images/4ce58f38a6111c6a98b4e75c866e16acb5cb3e00ae1ce38d03f5ca872bccf3e9.jpg)  
(c)专家可解释性评分：(i)软小麦，(ii)谷物玉米。图5. 静态特征的重要性与可解释性

图5. 静态特征的重要性与可解释性

在(a)和(b)图中，专家调查使用的评分标准为：强负向影响(-1)、弱负向影响(-0.5)、无影响(0)、弱正向影响(0.5)、强正向影响(1)。柱状图内的分段表示不同专家的评分分布，例如在(b)图中专家对SM_WHC的评分分别为-0.5、1、1和0.5。深度学习模型的重要性评分展示了特征对产量影响的强度与方向（正向或负向）。特征值从左到右由低到高（蓝到红）表示正向影响，反之则为负向影响。(c)图的坐标轴分别表示对产量的影响方向（Direction）和特征影响的相对强度（Magnitude），括号内数字表示参与评分的专家数量。对于专家数量不足4个的特征，部分专家未投票或未理解其影响。静态特征包括：土壤持水能力(SM_WHC)、平均海拔(AVG_ELEV)、平均坡度(AVG_SLOPE)、平均田块规模(AVG_FIELD_SIZE)、总灌溉面积(IRRIG_AREA_ALL)、作为软小麦代理指标的谷物灌溉面积(IRRIG_AREA90)以及玉米灌溉面积(IRRIG_AREA2)。

水分特征：专家预期根区土壤湿度(RSM)和气候水平衡(CWB)在整个生长季具有相似的正向影响（图6a(i),6b(i)）。对于软小麦，深度学习模型显示不同结果：RSM在整个生长季保持微弱但持续的正向影响，而降水(PREC)和CWB在生长季早期呈负向影响，开花期(p3)后转为正向（图6a(ii),8b(ii)）。尽管与预期存在差异，专家仍认为这些关系可解释（图6c(i)），唯一分歧在于RSM的相对重要性较低——专家预期RSM在生长后期应与CWB同等重要（图8b）。对于谷物玉米，专家认为PREC的微弱影响和RSM的负向影响难以解释（图6c(ii)）。CWB虽主要呈现正向影响，但多数评分接近零值（图6b(ii),A.11b(ii)），因此专家认为这些关系不可理解（图6c(ii)）。

![](images/be9e44a5b9535704d571b2b9cf59c237a69997809836d66500d98a6ca85d54fb.jpg)  
(a) 软小麦：专家调查(i)与深度学习模型(ii)的特征重要性

![](images/f1a4391cae77b2cc94564a213733a9bacb0778138dc980130d0f6ccc73611f51.jpg)  
(b) 谷物玉米：专家调查(i)与深度学习模型(ii)的特征重要性。图6. 收获前60天的季节性特征重要性与可解释性。(a)(b)图中专家调查的评分标准为：强负向影响$(-1)$、弱负向影响$(-0.5)$、无影响$(0)$、弱正向影响$(0.5)$、强正向影响$(1)$，柱状图分段表示专家评分分布。深度学习重要性评分展示特征对产量影响的强度与方向，特征值从左到右由低到高（蓝到红）表示正向关系，反之为负向。(c)图坐标轴为对产量的影响方向（Direction）和特征影响的相对强度（Magnitude），括号内数字表示专家数量。对于专家不足4个的特征，部分专家未投票或未理解其影响。生物量特征：水分限制干物质生物量(WLIM_YB)、水分限制储藏器官干重(WLIM_YS)、水分限制叶面积指数(WLAI)、光合有效辐射吸收比例(FAPAR)。温度特征：日最低温、最高温、平均气温(TMAX,TMIN,TAVG)。水分特征：根区土壤湿度(RSM)、日降水总量(PREC)、气候水平衡(CWB)。

# 4. 讨论

先前研究发现深度学习模型可用于作物产量预测(Khaki and Wang, 2019; Nevavuori et al., 2019; Wolanin et al., 2020; You et al., 2017)。当数据量较大时(至少约10,000个样本)，深度学习可显著提升性能。美国部分研究采用更复杂架构，如CNN与LSTM结合或3D CNN与卷积LSTM结合(Gavahi et al., 2021; Khaki et al., 2020; You et al., 2017)，其结果优于岭回归(Hoerl and Kennard, 1970)、LASSO回归(Tibshirani, 1996)、决策树和随机森林等传统机器学习方法。本研究数据量较小(约300-1950个标记样本)，故选择更简单架构。即便如此，深度学习模型在数据量最大的德国(DE)软小麦预测中仍优于GBDT，其他案例中与GBDT统计相当。GBDT和深度学习模型在软小麦预测中优于线性趋势模型，但在谷物玉米中未体现优势。法国空间变异图同样显示，软小麦预测值(深度学习和GBDT)比谷物玉米更接近统计值。核心结论是：深度学习可自动提取与专家设计特征性能相当的特征，即人工特征设计并未显著提升模型性能，因此深度学习为大规模人工特征设计的局限性提供了解决方案。

![](images/96f4cbe28eba09025e2f7bce5f793301223129a76a066369b16c22107f974fc3.jpg)  
(c) 专家可解释性评分：(i) 软小麦，(ii) 谷物玉米

![](images/e07b33bdfcb382faa2b9b7aae338d5b6856ef12fed8ea92bbb000e11c4a5033f.jpg)  
图7. 收获前60天的生物量特征重要性。专家调查采用评分标准：强负向影响$(-1)$、弱负向影响$(-0.5)$、无影响$(0)$、弱正向影响$(0.5)$、强正向影响$(1)$。柱状图分段表示专家评分分布。深度学习重要性评分展示特征对产量影响的强度与方向（正向或负向），特征值从左到右由低到高（蓝到红）表示正向关系，反之为负向。

![](images/d999cddc1b6ea99ace199acc0205c506b725f6c514c84d669176926da5b6b66d.jpg)  
图8. 软小麦收获前60天的温度与水分特征重要性。专家调查采用评分标准：强负向影响(-1)、弱负向影响(-0.5)、无影响(0)、弱正向影响(0.5)、强正向影响(1)。柱状图分段表示专家评分分布。深度学习重要性评分展示特征对产量影响的强度与方向（正向或负向），特征值从左到右由低到高（蓝到红）表示正向关系，反之为负向。谷物玉米对应图表见图A.11。

结果表明，当预测精度较高时，可采用事后特征归因方法解释深度学习模型的产量预测。趋势特征(图A.10)、多数静态特征(图5)和生物量特征(图7)的归因结果具有可解释性。水分特征归因也正确捕捉了软小麦不同生长阶段的关系(图8b)。例外情况包括极端温度对两种作物的影响(图8a,图A.11a)以及灌溉和水分对谷物玉米的影响(图5b,图A.11b)。由于模型框架未考虑极端温度的相对罕见性，导致生长季早期的低温和后期高温均呈现正向而非预期负向重要性。水分影响受灌溉条件调节，而静态灌溉面积数据有时导致关系不明确。尽管如此，深度学习仍捕捉到部分专家未预期的关系：如专家未考虑生长季早期高温的影响，而特征重要性显示高温具有负效应(图8a)；专家预期RSM和CWB在整个生长季保持正向影响，但特征重要性显示CWB在软小麦生长早期呈负效应，开花期(p3)后转为正效应(图8b)——专家后期认可了这些关系。部分分歧源于对特征-产量关系的不同认知：如有些专家不认同海拔与软小麦产量的负相关(图5a)，但通过土壤持水能力的交互作用进行了解释；有些专家难以理解谷物玉米FAPAR的低重要性，而其他专家则用高WLAI进行解释(图6c(ii))。总体而言，软小麦的特征影响与专家知识更吻合。谷物玉米的线性趋势模型与GBDT/LSTM性能相当，季节性特征低重要性评分(图A.7,A.8)可能源于年际变异较小导致特征-产量关系不明确。另有专家指出，将灌溉与非灌溉系统混合建模可能是混杂因素——多数国家的区域产量统计未区分灌溉系统，建立独立模型可能产生更具解释性的关系。

影响模型可解释性以及与专家共识或分歧的因素有很多。首先，专家基于先验知识和经验对某些关系存在预期。本研究采用的区域作物产量预测深度学习框架与他们以往使用的设置不同。同时，数据中实际存在的关系可能很复杂且难以验证。其次，神经网络架构和模型的选择并非最优。神经网络具有大量参数，需要大量训练数据才能良好泛化(Kolmar, 2022)。我们选择较简单的架构以平衡模型能力与复杂度。第三，使用的特征归因方法也有其局限性。GradientShap产生的加性解释易于理解，但仅近似模型行为。目前可解释神经网络尚未普及。最后，向专家展示特征重要性或解释是一个社会过程(Miller, 2019)，会影响他们对模型行为的理解。我们展示了各特征对产量预测的正负贡献，这种方法忽略了特征间交互作用，尽管在与专家的互动环节中考虑了某些组合交互。

分析可解释性具有挑战性，因此我们依赖专家进行的定性分析。需要稳健的假设检验来确定深度学习模型的解释是否符合现有知识或提供新见解(McGovern等, 2019)。测试可要求受试者选择与给定输入输出对应的特征归因，或根据输入和特征归因建议输出(Doshi-Velez和Kim, 2017)。这类测试需要大量参与者且专家需投入大量时间(Narayanan等, 2018)。因此我们选择了更简单的专家调查结合互动评估的方法。可解释性评分显示专家在选择重要预测因子(图5-8和A.11)或评估特征重要性可解释性(图5-6)时并不总是一致。尽管存在差异，让人参与可解释性评估仍很重要。模型可通过多种方式实现可解释，专家对相同解释可能有不同看法。深度学习模型未发现某些特征重要，并不代表这些特征在物理上不重要(McGovern等, 2019)。总体而言，我们开发并测试了一种结合专家反馈的模型可解释性评估方法，超越了通常难以独立理解的特征重要性图表。

深度学习方法如今在农业应用中已很常见，包括作物产量预测(Kamilaris和Prenafeta-Boldu, 2018; van Klompenburg等, 2020)。随着深度学习的广泛应用，对模型可解释性的需求将持续增长。本文选择了熟悉输入数据及驱动作物生长发育农学原理的人类专家来评估可解释性。这种熟悉度使我们能简化向他们解释特征归因的过程。专家能够理解特征重要性图表并对其可解释性做出判断。因此我们能更专注于理解深度学习捕捉预期农学关系的程度，而非影响可解释性的社会和认知因素(Narayanan等, 2018)。然而，社会和认知因素很重要，可解释性分析不应局限于可视化特征重要性图表。使用产量预测进行决策的其他利益相关者可能需要不同的模型解释方法。通过迭代改进评估过程可以实现更准确的可解释性评估。深度学习模型可能产生准确的作物产量预测，但只有在其可信并用于实际应用时才有价值。可解释性将在弥合模型构建与决策制定之间的鸿沟中发挥重要作用。

# 5. 结论

我们评估了欧洲区域尺度软小麦和谷物玉米产量预测深度学习模型的性能与可解释性。性能与依赖专家设计特征的标准机器学习算法统计相当或(在一种情况下)更优。因此深度学习提供了自动特征学习的优势，可解决大规模人工特征设计的局限性。类似地，特征归因方法为模型预测提供了事后解释，这些解释通常可理解，尤其在预测精度较高时。此类解释说明了各特征对产量预测的贡献，但未体现它们的交互效应。深度学习模型的特征重要性评分正确捕捉了大多数静态特征、产量趋势和生物量特征对作物产量的影响。在某些情况下，还识别出专家未预期的关系(如气候水平衡对软小麦生长早期的负效应)。另一方面，深度学习模型难以捕捉极端温度对两种作物的影响，以及灌溉和水分对谷物玉米的效应。我们发现人类对可解释性的评估具有挑战性但仍很重要。数据、模型构建、特征归因提取和向利益相关者展示解释等方面存在局限。通过持续的利益相关者参与和评估过程的迭代改进，可以解决部分局限。模型可解释性对于建立信任并指导决策至关重要。

# CRediT作者贡献声明

Dilli Paudel: 概念化，方法论，软件，调查，验证，形式分析，初稿写作。Allard de Wit: 数据管理，方法论，验证，文稿审阅编辑。Hendrik Boogaard: 数据管理，方法论，验证，文稿审阅编辑。Diego Marcos: 方法论，软件，可视化，文稿审阅编辑。Sjoukje Osinga: 方法论，可视化，文稿审阅编辑。Ioannis N. Athanasiadis: 资金获取，方法论，可视化，文稿审阅编辑。

# 利益冲突声明

作者声明无已知可能影响本工作的竞争性经济利益或个人关系。

# 数据与软件可用性

本文使用数据格式与以下示例数据相似: https://doi.org/10.5281/zenodo.5561113。软件实现可访问: https://github.com/BigDataWUR/MLforCropYieldForecasting/tree/dlinterpret。

# 致谢

本工作部分由欧盟"地平线2020"研究与创新计划资助(资助协议号825355，CYBELE项目)。

感谢欧盟委员会联合研究中心(JRC)的S. Niemeyer允许使用MARS作物产量预测系统(MCYFS)数据。同时感谢JRC的M. van der Velde、L. Nisini和I. Cerrani准备并分享Eurostat区域产量统计数据和作物面积数据。

我们衷心感谢以下专家为作物产量重要预测因子提供意见并分析特征归因的可解释性：瓦赫宁根环境研究所的Allard de Wit和Hendrik Boogaard；瓦赫宁根大学及研究中心的植物生产组Majid Ali Magham；欧盟委员会联合研究中心(JRC)意大利伊斯普拉站的Wassim Ben Aoun和Martin Claverie。同时感谢瓦赫宁根环境研究所的Sander Janssen建议将人类专家纳入模型可解释性评估。

本文使用的特征重要性图表改编自SHAP（SHapley Additive exPlanations，Lundberg和Lee，2017）的蜂群图。

# 附录A. 补充材料

本文补充数据可在https://doi.org/10.1016/j.compag.2023.107663在线获取。

## 参考文献

1.  [Allen et al., 1998](#bb0005)
Allen, R.G., Pereira, L.S., Raes, D., Smith, M., et al., 1998. 作物蒸散量——作物需水量计算指南. In: Irrigation and Drainage, paper 56, FAO, Rome.
2.  [Ancona et al., 2018](#bb0010)
Ancona, M., Ceolini, E., Oztireli, C., Gross, M., 2018. 深入理解深度神经网络基于梯度的归因方法. In: 6th International Conference on Learning Representations, ICLR 2018. doi: 10.48550/arXiv.1711.06104.
3.  [Basso and Liu, 2019](#bb0015)
Basso, B., Liu, L., 2019. 季节性作物产量预测：方法、应用与准确性. In: Advances in Agronomy. Vol. 154. Elsevier. pp. 201–255. doi: 10.1016/bs.agron.2018.11.002.
4.  [Ben-Ari et al., 2018](#bb0020)
Ben-Ari, T., Boé, J., Ciais, P., Lecerf, R., van der Velde, M., Makowski, D., 2018. 法国粮仓地区2016年极端产量损失的意外原因与影响. Nat. Commun. 9, 1–10. doi: 10.1038/s41467-018-04087-x.
5.  [Bengio et al., 2013](#bb0025)
Y. Bengio, A. Courville, P. Vincent
表征学习：综述与新视角
IEEE Trans. Pattern Anal. Mach. Intell., 35 (2013), pp. 1798-1828, [10.1109/TPAMI.2013.50](https://doi.org/10.1109/TPAMI.2013.50)
6.  [Boser et al., 1992](#bb0030)
Boser, B.E., Guyon, I.M., Vapnik, V.N., 1992. 最优间隔分类器的训练算法. In: Proceedings of the Fifth Annual Workshop on Computational Learning Theory, ACM New York, NY, USA. pp. 144–152.
7.  [Breiman, 2001](#bb0035)
L. Breiman
随机森林
Mach. Learn., 45 (2001), pp. 5-32
8.  [Chipanshi et al., 2015](#bb0040)
A. Chipanshi, Y. Zhang, L. Kouadio, N. Newlands, A. Davidson, H. Hill, R. Warren, B. Qian, B. Daneshfar, F. Bedard, _et al._
加拿大农业景观中集成作物产量预测模型(ICCYF)的季节内作物产量预测评估
Agric. For. Meteorol., 206 (2015), pp. 137-150, [10.1016/j.agrformet.2015.03.007](https://doi.org/10.1016/j.agrformet.2015.03.007)
9.  [Copernicus, 2020](#bb0045)
Copernicus GLS, 2020. 光合有效辐射吸收比例. [https://land.copernicus.eu/global/products/fapar](https://land.copernicus.eu/global/products/fapar), Last accessed: Oct 19, 2020.
10.  [Chlingaryan et al., 2018](#bbib316)
A. Chlingaryan, S. Sukkarieh, B. Whelan
精准农业中作物产量预测和氮素状态评估的机器学习方法综述
Computers and Electronics in Agriculture, 151 (2018), pp. 61-69, [10.1016/j.compag.2018.05.012](https://doi.org/10.1016/j.compag.2018.05.012)
11.  [Cortes and Vapnik, 1995](#bb0050)
C. Cortes, V. Vapnik
支持向量网络
Mach. Learn., 20 (1995), pp. 273-297, [10.1007/BF00994018](https://doi.org/10.1007/BF00994018)
12.  [Dagnelie et al., 1983](#bb0055)
Dagnelie, P., Palm, R., Istasse, A., 1983. 欧洲经济共同体十国农业生产预测. Technical Report. Faculté des Sciences Agronomiques de l’Etat, Gembloux, Belgium.
13.  [De Wit et al., 2019](#bb0060)
A. De Wit, H. Boogaard, D. Fumagalli, S. Janssen, R. Knapen, D. van Kraalingen, I. Supit, R. van der Wijngaart, K. van Diepen
WOFOST作物系统模型25年发展历程
Agr. Syst., 168 (2019), pp. 154-167, [10.1016/j.agsy.2018.06.018](https://doi.org/10.1016/j.agsy.2018.06.018)
14.  [DE-RegionalStatistiks, 2020](#bb0065)
DE-RegionalStatistiks, 2020. 德国区域数据库. [https://www.regionalstatistik.de/genesis/online/data](https://www.regionalstatistik.de/genesis/online/data), Last accessed: May 11, 2020.
15.  [Doshi-Velez and Kim, 2017](#bb0075)
Doshi-Velez, F., Kim, B., 2017. 迈向可解释机器学习的严谨科学. URL: [https://arxiv.org/abs/1702.08608](https://arxiv.org/abs/1702.08608), doi: 10.48550/ARXIV.1702.08608.
16.  [Eurostat, 2016](#bbib321)
Eurostat, 2016. 统计地域单位命名法. [https://ec.europa.eu/eurostat/web/nuts/background](https://ec.europa.eu/eurostat/web/nuts/background), Last accessed: May 11, 2020.
17.  [EC-JRC, 2022](#bb0080)
EC-JRC, 2022. JRC Agri4Cast数据门户. [https://agri4cast.jrc.ec.europa.eu/DataPortal/Index.aspx](https://agri4cast.jrc.ec.europa.eu/DataPortal/Index.aspx), Last accessed: Feb 11, 2022.
18.  [EUROSTAT, 2021](#bb0085)
Eurostat, 2021. Eurostat - 农业生产 - 作物. [https://ec.europa.eu/eurostat/statistics-explained/index.php/Agricultural\_production\_-\_crops](https://ec.europa.eu/eurostat/statistics-explained/index.php/Agricultural_production_-_crops), Last accessed: May 11, 2021.
19.  [FR-Agreste, 2020](#bb0090)
FR-Agreste, 2020. Agreste网络数据门户. [https://agreste.agriculture.gouv.fr/agreste-web/](https://agreste.agriculture.gouv.fr/agreste-web/), Last accessed: May 11, 2020.
20.  [Friedman, 2001](#bb0095)
Friedman, J.H., 2001. 贪婪函数逼近：梯度提升机. Annals of Statistics, 1189–1232. [https://www.jstor.org/stable/2699986](https://www.jstor.org/stable/2699986), Last accessed: May 11, 2020.
21.  [Gavahi et al., 2021](#bb0100)
K. Gavahi, P. Abbaszadeh, H. Moradkhani
DeepYield：结合卷积神经网络和长短期记忆网络的作物产量预测方法
Expert Syst. Appl., 184 (2021), Article 115511, [10.1016/j.eswa.2021.115511](https://doi.org/10.1016/j.eswa.2021.115511)
22.  [Gitelson et al., 2014.](#bb0105)
Gitelson, A.A., Peng, Y., Huemmrich, K.F., 2014. 光合作用玉米和大豆冠层吸收辐射比例与近距离遥感和MODIS 250米分辨率数据NDVI的关系
Remote Sens. Environ. 147, 108–120. doi: 10.1016/j.rse.2014.02.014.
23.  [Hoerl and Kennard, 1970](#bb0115)
A.E. Hoerl, R.W. Kennard
岭回归：非正交问题的有偏估计
Technometrics, 12 (1970), pp. 55-67, [10.1080/00401706. 1970.10488634](https://doi.org/10.1080/00401706. 1970.10488634)
24.  [Kamilaris and Prenafeta-Boldú, 2018](#bb0120)
A. Kamilaris, F.X. Prenafeta-Boldú
农业中的深度学习：综述
Comput. Electron. Agric., 147 (2018), pp. 70-90, [10.1016/j.compag.2018.02.016](https://doi.org/10.1016/j.compag.2018.02.016)
25.  [Khaki and Wang, 2019](#bb0125)
S. Khaki, L. Wang
使用深度神经网络的作物产量预测
Front. Plant Sci., 10 (2019), p. 621, [10.3389/fpls.2019.00621](https://doi.org/10.3389/fpls.2019.00621)
26.  [Khaki et al., 2020](#bb0130)
S. Khaki, L. Wang, S.V. Archontoulis
用于作物产量预测的CNN-RNN框架
Front. Plant Sci., 10 (2020), p. 1750, [10.3389/fpls.2019.01750](https://doi.org/10.3389/fpls.2019.01750)
27.  [Kingma and Ba, 2014](#bb0135)
Kingma, D.P., Ba, J., 2014. Adam：一种随机优化方法
arXiv preprint arXiv:1412.6980.
28.  [Kokhlikyan et al., 2020](#bb0140)
Kokhlikyan, N., Miglani, V., Martin, M., Wang, E., Alsallakh, B., Reynolds, J., Melnikov, A., Kliushkina, N., Araya, C., Yan, S., Reblitz-Richardson, O., 2020. Captum：PyTorch的统一通用模型可解释性库
10.48550/ARXIV.2009.07896, arXiv:2009.07896.
29.  [Lecerf et al., 2019](#bb0145)
Lecerf, R., Ceglar, A., L ́opez-Lozano, R., Van Der Velde, M., Baruth, B., 2019. 评估作物模型和气象指标对欧洲作物产量预测的信息价值
Agric. Syst. 168, 191–202. doi: 10.1016/j.agsy.2018.03.002.
30.  [Lesiv et al., 2019](#bb0150)
M. Lesiv, J.C. Laso Bayas, L. See, M. Duerauer, D. Dahlia, N. Durando, R. Hazarika, P. Kumar Sahariah, M. Vakolyuk, V. Blyshchyk, _et al._
利用众包估算全球农田面积分布
Glob. Chang. Biol., 25 (2019), pp. 174-186, [10.1111/gcb.14492](https://doi.org/10.1111/gcb.14492)
31.  [Lipovetsky and Conklin, 2001](#bb0155)
S. Lipovetsky, M. Conklin
博弈论方法中的回归分析
Appl. Stoch. Model. Bus. Ind., 17 (2001), pp. 319-330, [10.1002/asmb.446](https://doi.org/10.1002/asmb.446)
32.  [Lundberg and Lee, 2017](#bb0160)
Lundberg, S.M., Lee, S.I., 2017. 解释模型预测的统一方法, In: Advances in Neural Information Processing Systems 30. Curran Associates, Inc., pp. 4765–4774. [http://papers.nips.cc/paper/7062-a-unified-approach-to-interpreting-model-predictions.pdf](http://papers.nips.cc/paper/7062-a-unified-approach-to-interpreting-model-predictions.pdf), Last accessed: June 29, 2022.
33.  [Lobell et al., 2015](#bbib317)
D.B. Lobell, D. Thau, C. Seifert, E. Engle, B. Little
**可扩展的基于卫星的作物产量制图方法**
Remote Sensing of Environment, 164 (2015), pp. 324-333, [10.1016/j.rse.2015.04.021](https://doi.org/10.1016/j.rse.2015.04.021)
34.  [Mann and Whitney, 1947](#bb0165)
H.B. Mann, D.R. Whitney
关于两个随机变量中一个是否随机大于另一个的检验
Ann. Math. Stat. (1947), pp. 50-60, [10.1214/aoms/1177730491](https://doi.org/10.1214/aoms/1177730491)
35.  [MARSWiki, 2021](#bb0170)
MARSWiki, 2021. MARS作物产量预测系统. [https://marswiki.jrc.ec.europa.eu/agri4castwiki/index.php/Welcome\_to\_WikiMCYFS](https://marswiki.jrc.ec.europa.eu/agri4castwiki/index.php/Welcome_to_WikiMCYFS), Last accessed: May 11, 2021.
36.  [McGovern et al., 2019](#bb0175)
A. McGovern, R. Lagerquist, D.J. Gagne, G.E. Jergensen, K.L. Elmore, C.R. Homeyer, T. Smith
使黑箱更加透明：理解机器学习的物理意义
Bull. Am. Meteorol. Soc., 100 (2019), pp. 2175-2199, [10.1175/BAMS-D-18-0195.1](https://doi.org/10.1175/BAMS-D-18-0195.1)
37.  [Miller, 2019](#bb0180)
T. Miller
人工智能中的解释：来自社会科学的见解
Artif. Intell., 267 (2019), pp. 1-38, [10.1016/j.artint.2018.07.007](https://doi.org/10.1016/j.artint.2018.07.007)
38.  [Molnar, 2022](#bb0185)
Molnar, C., 2022. 可解释机器学习(第二版). URL: [https://christophm.github.io/interpretable-ml-book](https://christophm.github.io/interpretable-ml-book).
39.  [Mücher et al., 2016](#bbib323)
Mücher, S., De Simone, L., Kramer, H., de Wit, A., Roupioz, L., Hazeu, G., Boogaard, H., Schuiling, R., Fritz, S., Latham, J., et al., 2016. 新的全球农业环境分层(GAES). Technical Report. Wageningen Environmental Research. [https://edepot.wur.nl/400815](https://edepot.wur.nl/400815), Last accessed: June 14, 2021.
40.  [Montavon et al., 2018](#bb0190)
G. Montavon, W. Samek, K.R. Müller
解释和理解深度神经网络的方法
Digital Signal Process., 73 (2018), pp. 1-15, [10.1016/j.dsp.2017.10.011](https://doi.org/10.1016/j.dsp.2017.10.011)
41.  [Narayanan et al., 2018](#bb0195)
Narayanan, M., Chen, E., He, J., Kim, B., Gershman, S., Doshi-Velez, F., 2018. 人类如何理解机器学习系统的解释？对解释的人类可解释性评估. doi: 10.48550/ARXIV.1802.00682.
42.  [Nayak et al., 2022](#bbib320)
H.S. Nayak, J.V. Silva, C.M. Parihar, T.J. Krupnik, D.R. Sena, S.K. Kakraliya, H.S. Jat, H.S. Sidhu, P.C. Sharma, M.L. Jat, T.B. Sapkota
可解释机器学习方法解释印度西北部高生产力小麦的田间产量变异
Field Crops Research, 287 (2022), p. 108640, [10.1016/j.fcr.2022.108640](https://doi.org/10.1016/j.fcr.2022.108640)
43.  [Nevavuori et al., 2019](#bb0200)
P. Nevavuori, N. Narra, T. Lipping
使用深度卷积神经网络预测作物产量
Comput. Electron. Agric., 163 (2019), Article 104859, [10.1016/j.compag.2019.104859](https://doi.org/10.1016/j.compag.2019.104859)
44.  [Oikonomidis et al., 2022](#bb0205)
A. Oikonomidis, C. Catal, A. Kassahun
深度学习在作物产量预测中的应用：系统性文献综述
N. Z. J. Crop Hortic. Sci., 1–26 (2022), [10.1080/01140671.2022.2032213](https://doi.org/10.1080/01140671.2022.2032213)
45.  [Paszke et al., 2019](#bb0210)
A. Paszke, S. Gross, F. Massa, A. Lerer, J. Bradbury, G. Chanan, T. Killeen, Z. Lin, N. Gimelshein, L. Antiga, A. Desmaison, A. Kopf, E. Yang, Z. DeVito, M. Raison, A. Tejani, S. Chilamkurthy, B. Steiner, L. Fang, J. Bai, S. Chintala
PyTorch：一种命令式风格的高性能深度学习库
Advances in Neural Information Processing Systems 32, Curran Associates Inc (2019), pp. 8024-8035
46.  [Paudel et al., 2021](#bb0215)
D. Paudel, H. Boogaard, A. de Wit, S. Janssen, S. Osinga, C. Pylianidis, I.N. Athanasiadis
机器学习在大规模作物产量预测中的应用
Agr. Syst., 187 (2021), Article 103016, [10.1016/j.agsy.2020.103016](https://doi.org/10.1016/j.agsy.2020.103016)
47.  [Paudel et al., 2022](#bb0220)
D. Paudel, H. Boogaard, A. de Wit, M. van der Velde, M. Claverie, L. Nisini, S. Janssen, S. Osinga, I.N. Athanasiadis
机器学习在欧洲区域作物产量预测中的应用
Field Crop Res, 276 (2022), Article 108377, [10.1016/j.fcr.2021.108377](https://doi.org/10.1016/j.fcr.2021.108377)
48.  [Ribeiro et al., 2016](#bb0230)
Ribeiro, M.T., Singh, S., Guestrin, C., 2016. 机器学习模型无关的可解释性. URL: [https://arxiv.org/abs/1606.05386](https://arxiv.org/abs/1606.05386), doi: 10.48550/ARXIV.1606.05386.
49.  [Rüping, 2006](#bb0235)
Rüping, S., 2006. 学习可解释模型. [https://eldorado.tu-dortmund.de/bitstream/2003/23008/1/dissertation\_rueping.pdf](https://eldorado.tu-dortmund.de/bitstream/2003/23008/1/dissertation_rueping.pdf), Last accessed: June 29, 2022.
50.  [Samek et al., 2019](#bb0240)
Samek, W., Montavon, G., Vedaldi, A., Hansen, L.K., M ̈uller, K.R., 2019. 可解释AI：解释、说明和可视化深度学习. Volume 11700. Springer Nature. doi: 10.1007/978-3-030-28954-6.
51.  [Shapley, 1953](#bb0250)
Shapley, L., 1953. n人博弈的配额解. In: Contributions to the Theory of Games (AM-28), Volume II, Princeton University Press. pp. 307–317. doi: 10.1515/9781400881970.
52.  [Statistics Canada, 2020](#bb0255)
Statistics Canada, 2020. 使用遥感、农业气候数据和作物保险数据的综合作物产量模型. [https://www.statcan.gc.ca/eng/statistical-programs/document/3401\_D2\_V1](https://www.statcan.gc.ca/eng/statistical-programs/document/3401_D2_V1), Last accessed: July 25, 2022.
53.  [Sundararajan et al., 2017](#bb0260)
Sundararajan, M., Taly, A., Yan, Q., 2017. 深度网络的公理归因. In: Proceedings of the 34th International Conference on Machine Learning, PMLR. pp. 3319–3328. URL: [https://proceedings.mlr.press/v70/sundararajan17a.html](https://proceedings.mlr.press/v70/sundararajan17a.html).
54.  [Supit et al., 1994](#bb0265)
Supit, I., Hooijer, A., Van Diepen, C., 1994. CGMS中实现的WOFOST 6.0作物模拟系统描述. Vol. 1. Theory and algorithms. In: EUR Publication No. 15959 EN, Office for Official Publications of the European Communities, Luxembourg. p. 146.
55.  [Tibshirani, 1996](#bb0270)
Tibshirani, R., 1996. 通过lasso进行回归收缩和选择. J. R. Stat. Soc.: Ser. B (Methodol.) 58, 267–288. doi: 10.1111/j.2517-6161.1996.tb02080.x.
56.  [USGS-EROS, 2021](#bb0275)
USGS-EROS, 2021. USGS EROS档案-数字高程-全球30弧秒高程(GTOPO30). [https://www.usgs.gov/centers/eros/data](https://www.usgs.gov/centers/eros/data), Last accessed: May 11, 2021.
57.  [Schauberger et al., 2018](#bbib322)
B. Schauberger, T. Ben-Ari, D. Makowski, T. Kato, H. Kato, P. Ciais
法国主要作物一个多世纪以来的产量趋势、变异性和停滞分析
Scientific Reports, 8 (2018), p. 16865, [10.1038/s41598-018-35351-1](https://doi.org/10.1038/s41598-018-35351-1)
58.  [Shook et al., 2021](#bbib319)
J. Shook, T. Gangopadhyay, L. Wu, B. Ganapathysubramanian, S. Sarkar, A.K. Singh
整合基因型和天气变量的深度学习作物产量预测
Plos one, 16 (6) (2021), Article 0252402, [10.1371/journal.pone.0252402](https://doi.org/10.1371/journal.pone.0252402)
59.  [van der Velde and Nisini, 2019](#bb0280)
M. van der Velde, L. Nisini
欧盟MARS作物产量预测系统的性能评估：1993-2015年准确性和季节性改进
Agr. Syst., 168 (2019), pp. 203-212, [10.1016/j.agsy.2018.06.009](https://doi.org/10.1016/j.agsy.2018.06.009)
60.  [van Diepen et al., 1989](#bb0285)
C. van Diepen, J. Wolf, H. Van Keulen, C. Rappoldt
WOFOST：作物生产模拟模型
Soil Use Manag., 5 (1989), pp. 16-24, [10.1111/j.1475-2743.1989.tb00755.x](https://doi.org/10.1111/j.1475-2743.1989.tb00755.x)
61.  [van Klompenburg et al., 2020](#bb0290)
T. van Klompenburg, A. Kassahun, C. Catal
使用机器学习进行作物产量预测：系统性文献综述
Comput. Electron. Agric., 177 (2020), Article 105709, [10.1016/j.compag.2020.105709](https://doi.org/10.1016/j.compag.2020.105709)
62.  [Wang and Yang, 2018](#bb0295)
Wang, Z., Yang, J., 2018. 通过深度卷积网络进行糖尿病视网膜病变检测以实现判别定位和可视化解释. In: Workshops at the thirty-second AAAI conference on artificial intelligence. [https://www.aaai.org/ocs/index.php/WS/AAAIW18/paper/view/16668/0](https://www.aaai.org/ocs/index.php/WS/AAAIW18/paper/view/16668/0), Last accessed: June 29, 2022.
63.  [Wolanin et al., 2020](#bb0300)
A. Wolanin, G. Mateo-García, G. Camps-Valls, L. Gómez-Chova, M. Meroni, G. Duveiller, Y. Liangzhi, L. Guanter
印度小麦带使用可解释深度学习的作物产量估计与理解
Environmental research letters, 15 (2) (2020), Article 024019, [10.1088/1748-9326/ab68ac](https://doi.org/10.1088/1748-9326/ab68ac)
64.  [Xu et al., 2019](#bb0305)
Xu, F., Uszkoreit, H., Du, Y., Fan, W., Zhao, D., Zhu, J., 2019. 可解释AI：历史、研究领域、方法和挑战的简要综述. In: CCF international conference on natural language processing and Chinese computing, Springer. pp. 563–574. doi: 10.1007/978-3-030-32236-6\_51.
65.  [You et al., 2017](#bb0310)
You, J., Li, X., Low, M., Lobell, D., Ermon, S., 2017. 基于遥感数据的深度高斯过程作物产量预测. In: Thirty-First AAAI Conference on Artificial Intelligence. [https://www-cs.stanford.edu/∼ermon/papers/cropyield\_AAAI17.pdf](https://www-cs.stanford.edu/%7eermon/papers/cropyield_AAAI17.pdf), Last accessed: July 25, 2022.
66.  [Zeiler and Fergus, 2014](#bb0315)
Zeiler, M.D., Fergus, R., 2014. 卷积网络的可视化与理解. In: European conference on computer vision, Springer. pp. 818–833. doi: 10.1007/978-3-319-10590-1\_53.

## References

1.  [Allen et al., 1998](#bb0005)
Allen, R.G., Pereira, L.S., Raes, D., Smith, M., et al., 1998. Crop evapotranspiration – guidelines for computing crop water requirements. In: Irrigation and Drainage, paper 56, FAO, Rome.
2.  [Ancona et al., 2018](#bb0010)
Ancona, M., Ceolini, E., Oztireli, C., Gross, M., 2018. Towards better understanding of gradient-based attribution methods for deep neural networks. In: 6th International Conference on Learning Representations, ICLR 2018. doi: 10.48550/arXiv.1711.06104.
3.  [Basso and Liu, 2019](#bb0015)
Basso, B., Liu, L., 2019. Seasonal crop yield forecast: Methods, applications, and accuracies. In: Advances in Agronomy. Vol. 154. Elsevier. pp. 201–255. doi: 10.1016/bs.agron.2018.11.002.
4.  [Ben-Ari et al., 2018](#bb0020)
Ben-Ari, T., Boé, J., Ciais, P., Lecerf, R., van der Velde, M., Makowski, D., 2018. Causes and implications of the unforeseen 2016 extreme yield loss in the breadbasket of France. Nat. Commun. 9, 1–10. doi: 10.1038/s41467-018-04087-x.
5.  [Bengio et al., 2013](#bb0025)
Y. Bengio, A. Courville, P. Vincent
Representation learning: A review and new perspectives
IEEE Trans. Pattern Anal. Mach. Intell., 35 (2013), pp. 1798-1828, [10.1109/TPAMI.2013.50](https://doi.org/10.1109/TPAMI.2013.50)
6.  [Boser et al., 1992](#bb0030)
Boser, B.E., Guyon, I.M., Vapnik, V.N., 1992. A training algorithm for optimal margin classifiers. In: Proceedings of the Fifth Annual Workshop on Computational Learning Theory, ACM New York, NY, USA. pp. 144–152.
7.  [Breiman, 2001](#bb0035)
L. Breiman
Random forests
Mach. Learn., 45 (2001), pp. 5-32
8.  [Chipanshi et al., 2015](#bb0040)
A. Chipanshi, Y. Zhang, L. Kouadio, N. Newlands, A. Davidson, H. Hill, R. Warren, B. Qian, B. Daneshfar, F. Bedard, _et al._
Evaluation of the Integrated Canadian Crop Yield Forecaster (ICCYF) model for in-season prediction of crop yield across the canadian agricultural landscape
Agric. For. Meteorol., 206 (2015), pp. 137-150, [10.1016/j.agrformet.2015.03.007](https://doi.org/10.1016/j.agrformet.2015.03.007)
9.  [Copernicus, 2020](#bb0045)
Copernicus GLS, 2020. Fraction of Absorbed Photosynthetically Active Radiation. [https://land.copernicus.eu/global/products/fapar](https://land.copernicus.eu/global/products/fapar), Last accessed: Oct 19, 2020.
10.  [Chlingaryan et al., 2018](#bbib316)
A. Chlingaryan, S. Sukkarieh, B. Whelan
Machine learning approaches for crop yield prediction and nitrogen status estimation in precision agri- culture: A review
Computers and Electronics in Agriculture, 151 (2018), pp. 61-69, [10.1016/j.compag.2018.05.012](https://doi.org/10.1016/j.compag.2018.05.012)
11.  [Cortes and Vapnik, 1995](#bb0050)
C. Cortes, V. Vapnik
Support-vector networks
Mach. Learn., 20 (1995), pp. 273-297, [10.1007/BF00994018](https://doi.org/10.1007/BF00994018)
12.  [Dagnelie et al., 1983](#bb0055)
Dagnelie, P., Palm, R., Istasse, A., 1983. Prévision de productions agricoles dans les dix pays de la Communauté Économique Européenne. Technical Report. Faculté des Sciences Agronomiques de l’Etat, Gembloux, Belgium.
13.  [De Wit et al., 2019](#bb0060)
A. De Wit, H. Boogaard, D. Fumagalli, S. Janssen, R. Knapen, D. van Kraalingen, I. Supit, R. van der Wijngaart, K. van Diepen
25 years of the WOFOST cropping systems model
Agr. Syst., 168 (2019), pp. 154-167, [10.1016/j.agsy.2018.06.018](https://doi.org/10.1016/j.agsy.2018.06.018)
14.  [DE-RegionalStatistiks, 2020](#bb0065)
DE-RegionalStatistiks, 2020. Regionaldatenbank deutschland. [https://www.regionalstatistik.de/genesis/online/data](https://www.regionalstatistik.de/genesis/online/data), Last accessed: May 11, 2020.
15.  [Doshi-Velez and Kim, 2017](#bb0075)
Doshi-Velez, F., Kim, B., 2017. Towards A Rigorous Science of Interpretable Machine Learning. URL: [https://arxiv.org/abs/1702.08608](https://arxiv.org/abs/1702.08608), doi: 10.48550/ARXIV.1702.08608.
16.  [Eurostat, 2016](#bbib321)
Eurostat, 2016. Nomenclature of territorial units for statistics. [https://ec.europa.eu/eurostat/web/nuts/background](https://ec.europa.eu/eurostat/web/nuts/background), Last accessed: May 11, 2020.
17.  [EC-JRC, 2022](#bb0080)
EC-JRC, 2022. JRC Agri4Cast Data Portal. [https://agri4cast.jrc.ec.europa.eu/DataPortal/Index.aspx](https://agri4cast.jrc.ec.europa.eu/DataPortal/Index.aspx), Last accessed: Feb 11, 2022.
18.  [EUROSTAT, 2021](#bb0085)
Eurostat, 2021. Eurostat - Agricultural Production - crops. [https://ec.europa.eu/eurostat/statistics-explained/index.php/Agricultural\_production\_-\_crops](https://ec.europa.eu/eurostat/statistics-explained/index.php/Agricultural_production_-_crops), Last accessed: May 11, 2021.
19.  [FR-Agreste, 2020](#bb0090)
FR-Agreste, 2020. Agreste Web Data Portal. [https://agreste.agriculture.gouv.fr/agreste-web/](https://agreste.agriculture.gouv.fr/agreste-web/), Last accessed: May 11, 2020.
20.  [Friedman, 2001](#bb0095)
Friedman, J.H., 2001. Greedy function approximation: a gradient boosting machine. Annals of Statistics, 1189–1232. [https://www.jstor.org/stable/2699986](https://www.jstor.org/stable/2699986), Last accessed: May 11, 2020.
21.  [Gavahi et al., 2021](#bb0100)
K. Gavahi, P. Abbaszadeh, H. Moradkhani
DeepYield: A combined convolutional neural network with long short-term memory for crop yield forecasting
Expert Syst. Appl., 184 (2021), Article 115511, [10.1016/j.eswa.2021.115511](https://doi.org/10.1016/j.eswa.2021.115511)
22.  [Gitelson et al., 2014.](#bb0105)
Gitelson, A.A., Peng, Y., Huemmrich, K.F., 2014. Relationship between fraction of radiation absorbed by photosynthesizing maize and soybean canopies and ndvi from remotely sensed data taken at close range and from modis 250 m resolution data. Remote Sens. Environ. 147, 108–120. doi: 10.1016/j.rse.2014.02.014.
23.  [Hoerl and Kennard, 1970](#bb0115)
A.E. Hoerl, R.W. Kennard
Ridge regression: Biased estimation for nonorthogonal problems
Technometrics, 12 (1970), pp. 55-67, [10.1080/00401706. 1970.10488634](https://doi.org/10.1080/00401706. 1970.10488634)
24.  [Kamilaris and Prenafeta-Boldú, 2018](#bb0120)
A. Kamilaris, F.X. Prenafeta-Boldú
Deep learning in agriculture: a survey
Comput. Electron. Agric., 147 (2018), pp. 70-90, [10.1016/j.compag.2018.02.016](https://doi.org/10.1016/j.compag.2018.02.016)
25.  [Khaki and Wang, 2019](#bb0125)
S. Khaki, L. Wang
Crop yield prediction using deep neural networks
Front. Plant Sci., 10 (2019), p. 621, [10.3389/fpls.2019.00621](https://doi.org/10.3389/fpls.2019.00621)
26.  [Khaki et al., 2020](#bb0130)
S. Khaki, L. Wang, S.V. Archontoulis
A CNN-RNN framework for crop yield prediction
Front. Plant Sci., 10 (2020), p. 1750, [10.3389/fpls.2019.01750](https://doi.org/10.3389/fpls.2019.01750)
27.  [Kingma and Ba, 2014](#bb0135)
Kingma, D.P., Ba, J., 2014. Adam: A method for stochastic optimization. arXiv preprint arXiv:1412.6980.
28.  [Kokhlikyan et al., 2020](#bb0140)
Kokhlikyan, N., Miglani, V., Martin, M., Wang, E., Alsallakh, B., Reynolds, J., Melnikov, A., Kliushkina, N., Araya, C., Yan, S., Reblitz-Richardson, O., 2020. Captum: A unified and generic model interpretability library for pytorch. 10.48550/ARXIV.2009.07896, arXiv:2009.07896.
29.  [Lecerf et al., 2019](#bb0145)
Lecerf, R., Ceglar, A., L ́opez-Lozano, R., Van Der Velde, M., Baruth, B., 2019. Assessing the information in crop model and meteorological indicators to forecast crop yield over Europe. Agric. Syst. 168, 191–202. doi: 10.1016/j.agsy.2018.03.002.
30.  [Lesiv et al., 2019](#bb0150)
M. Lesiv, J.C. Laso Bayas, L. See, M. Duerauer, D. Dahlia, N. Durando, R. Hazarika, P. Kumar Sahariah, M. Vakolyuk, V. Blyshchyk, _et al._
Estimating the global distribution of field size using crowdsourcing
Glob. Chang. Biol., 25 (2019), pp. 174-186, [10.1111/gcb.14492](https://doi.org/10.1111/gcb.14492)
31.  [Lipovetsky and Conklin, 2001](#bb0155)
S. Lipovetsky, M. Conklin
Analysis of regression in game theory approach
Appl. Stoch. Model. Bus. Ind., 17 (2001), pp. 319-330, [10.1002/asmb.446](https://doi.org/10.1002/asmb.446)
32.  [Lundberg and Lee, 2017](#bb0160)
Lundberg, S.M., Lee, S.I., 2017. A unified approach to interpreting model predictions, In: Advances in Neural Information Processing Systems 30. Curran Associates, Inc., pp. 4765–4774. [http://papers.nips.cc/paper/7062-a-unified-approach-to-interpreting-model-predictions.pdf](http://papers.nips.cc/paper/7062-a-unified-approach-to-interpreting-model-predictions.pdf), Last accessed: June 29, 2022.
33.  [Lobell et al., 2015](#bbib317)
D.B. Lobell, D. Thau, C. Seifert, E. Engle, B. Little
**A scalable satellite-based crop yield mapper**
Remote Sensing of Environment, 164 (2015), pp. 324-333, [10.1016/j.rse.2015.04.021](https://doi.org/10.1016/j.rse.2015.04.021)
34.  [Mann and Whitney, 1947](#bb0165)
H.B. Mann, D.R. Whitney
On a test of whether one of two random variables is stochastically larger than the other
Ann. Math. Stat. (1947), pp. 50-60, [10.1214/aoms/1177730491](https://doi.org/10.1214/aoms/1177730491)
35.  [MARSWiki, 2021](#bb0170)
MARSWiki, 2021. MARS Crop Yield Forecasting System. [https://marswiki.jrc.ec.europa.eu/agri4castwiki/index.php/Welcome\_to\_WikiMCYFS](https://marswiki.jrc.ec.europa.eu/agri4castwiki/index.php/Welcome_to_WikiMCYFS), Last accessed: May 11, 2021.
36.  [McGovern et al., 2019](#bb0175)
A. McGovern, R. Lagerquist, D.J. Gagne, G.E. Jergensen, K.L. Elmore, C.R. Homeyer, T. Smith
Making the black box more transparent: understanding the physical implications of machine learning
Bull. Am. Meteorol. Soc., 100 (2019), pp. 2175-2199, [10.1175/BAMS-D-18-0195.1](https://doi.org/10.1175/BAMS-D-18-0195.1)
37.  [Miller, 2019](#bb0180)
T. Miller
Explanation in artificial intelligence: Insights from the social sciences
Artif. Intell., 267 (2019), pp. 1-38, [10.1016/j.artint.2018.07.007](https://doi.org/10.1016/j.artint.2018.07.007)
38.  [Molnar, 2022](#bb0185)
Molnar, C., 2022. Interpretable Machine Learning, second edition. URL: [https://christophm.github.io/interpretable-ml-book](https://christophm.github.io/interpretable-ml-book).
39.  [Mücher et al., 2016](#bbib323)
Mücher, S., De Simone, L., Kramer, H., de Wit, A., Roupioz, L., Hazeu, G., Boogaard, H., Schuiling, R., Fritz, S., Latham, J., et al., 2016. A new global agro-environmental stratification (GAES). Technical Report. Wageningen Environmental Research. [https://edepot.wur.nl/400815](https://edepot.wur.nl/400815), Last accessed: June 14, 2021.
40.  [Montavon et al., 2018](#bb0190)
G. Montavon, W. Samek, K.R. Müller
Methods for interpreting and understanding deep neural networks
Digital Signal Process., 73 (2018), pp. 1-15, [10.1016/j.dsp.2017.10.011](https://doi.org/10.1016/j.dsp.2017.10.011)
41.  [Narayanan et al., 2018](#bb0195)
Narayanan, M., Chen, E., He, J., Kim, B., Gershman, S., Doshi-Velez, F., 2018. How do humans understand explanations from machine learning systems? An evaluation of the human-interpretability of explanation. doi: 10.48550/ARXIV.1802.00682.
42.  [Nayak et al., 2022](#bbib320)
H.S. Nayak, J.V. Silva, C.M. Parihar, T.J. Krupnik, D.R. Sena, S.K. Kakraliya, H.S. Jat, H.S. Sidhu, P.C. Sharma, M.L. Jat, T.B. Sapkota
Interpretable machine learning methods to explain on-farm yield variability of high productivity wheat in Northwest India
Field Crops Research, 287 (2022), p. 108640, [10.1016/j.fcr.2022.108640](https://doi.org/10.1016/j.fcr.2022.108640)
43.  [Nevavuori et al., 2019](#bb0200)
P. Nevavuori, N. Narra, T. Lipping
Crop yield prediction with deep convolutional neural networks
Comput. Electron. Agric., 163 (2019), Article 104859, [10.1016/j.compag.2019.104859](https://doi.org/10.1016/j.compag.2019.104859)
44.  [Oikonomidis et al., 2022](#bb0205)
A. Oikonomidis, C. Catal, A. Kassahun
Deep learning for crop yield prediction: a systematic literature review
N. Z. J. Crop Hortic. Sci., 1–26 (2022), [10.1080/01140671.2022.2032213](https://doi.org/10.1080/01140671.2022.2032213)
45.  [Paszke et al., 2019](#bb0210)
A. Paszke, S. Gross, F. Massa, A. Lerer, J. Bradbury, G. Chanan, T. Killeen, Z. Lin, N. Gimelshein, L. Antiga, A. Desmaison, A. Kopf, E. Yang, Z. DeVito, M. Raison, A. Tejani, S. Chilamkurthy, B. Steiner, L. Fang, J. Bai, S. Chintala
Pytorch: An imperative style, high-performance deep learning library
Advances in Neural Information Processing Systems 32, Curran Associates Inc (2019), pp. 8024-8035
46.  [Paudel et al., 2021](#bb0215)
D. Paudel, H. Boogaard, A. de Wit, S. Janssen, S. Osinga, C. Pylianidis, I.N. Athanasiadis
Machine learning for large-scale crop yield forecasting
Agr. Syst., 187 (2021), Article 103016, [10.1016/j.agsy.2020.103016](https://doi.org/10.1016/j.agsy.2020.103016)
47.  [Paudel et al., 2022](#bb0220)
D. Paudel, H. Boogaard, A. de Wit, M. van der Velde, M. Claverie, L. Nisini, S. Janssen, S. Osinga, I.N. Athanasiadis
Machine learning for regional crop yield forecasting in Europe
Field Crop Res, 276 (2022), Article 108377, [10.1016/j.fcr.2021.108377](https://doi.org/10.1016/j.fcr.2021.108377)
48.  [Ribeiro et al., 2016](#bb0230)
Ribeiro, M.T., Singh, S., Guestrin, C., 2016. Model-agnostic interpretability of machine learning. URL: [https://arxiv.org/abs/1606.05386](https://arxiv.org/abs/1606.05386), doi: 10.48550/ARXIV.1606.05386.
49.  [Rüping, 2006](#bb0235)
Rüping, S., 2006. Learning interpretable models. [https://eldorado.tu-dortmund.de/bitstream/2003/23008/1/dissertation\_rueping.pdf](https://eldorado.tu-dortmund.de/bitstream/2003/23008/1/dissertation_rueping.pdf), Last accessed: June 29, 2022.
50.  [Samek et al., 2019](#bb0240)
Samek, W., Montavon, G., Vedaldi, A., Hansen, L.K., M ̈uller, K.R., 2019. Explainable AI: interpreting, explaining and visualizing deep learning. Volume 11700. Springer Nature. doi: 10.1007/978-3-030-28954-6.
51.  [Shapley, 1953](#bb0250)
Shapley, L., 1953. Quota solutions of n-person games. In: Contributions to the Theory of Games (AM-28), Volume II, Princeton University Press. pp. 307–317. doi: 10.1515/9781400881970.
52.  [Statistics Canada, 2020](#bb0255)
Statistics Canada, 2020. An Integrated Crop Yield Model Using Remote Sensing, Agroclimatic Data and Crop Insurance Data. [https://www.statcan.gc.ca/eng/statistical-programs/document/3401\_D2\_V1](https://www.statcan.gc.ca/eng/statistical-programs/document/3401_D2_V1), Last accessed: July 25, 2022.
53.  [Sundararajan et al., 2017](#bb0260)
Sundararajan, M., Taly, A., Yan, Q., 2017. Axiomatic attribution for deep networks. In: Proceedings of the 34th International Conference on Machine Learning, PMLR. pp. 3319–3328. URL: [https://proceedings.mlr.press/v70/sundararajan17a.html](https://proceedings.mlr.press/v70/sundararajan17a.html).
54.  [Supit et al., 1994](#bb0265)
Supit, I., Hooijer, A., Van Diepen, C., 1994. System description of the WOFOST 6.0 crop simulation model implemented in CGMS. Vol. 1. Theory and algorithms. In: EUR Publication No. 15959 EN, Office for Official Publications of the European Communities, Luxembourg. p. 146.
55.  [Tibshirani, 1996](#bb0270)
Tibshirani, R., 1996. Regression shrinkage and selection via the lasso. J. R. Stat. Soc.: Ser. B (Methodol.) 58, 267–288. doi: 10.1111/j.2517-6161.1996.tb02080.x.
56.  [USGS-EROS, 2021](#bb0275)
USGS-EROS, 2021. USGS EROS Archive - Digital Elevation - Global 30 Arc-Second Elevation (GTOPO30). [https://www.usgs.gov/centers/eros/data](https://www.usgs.gov/centers/eros/data), Last accessed: May 11, 2021.
57.  [Schauberger et al., 2018](#bbib322)
B. Schauberger, T. Ben-Ari, D. Makowski, T. Kato, H. Kato, P. Ciais
Yield trends, variability and stagnation analysis of major crops in France over more than a century
Scientific Reports, 8 (2018), p. 16865, [10.1038/s41598-018-35351-1](https://doi.org/10.1038/s41598-018-35351-1)
58.  [Shook et al., 2021](#bbib319)
J. Shook, T. Gangopadhyay, L. Wu, B. Ganapathysubramanian, S. Sarkar, A.K. Singh
Crop yield prediction integrating geno-type and weather variables using deep learning
Plos one, 16 (6) (2021), Article 0252402, [10.1371/journal.pone.0252402](https://doi.org/10.1371/journal.pone.0252402)
59.  [van der Velde and Nisini, 2019](#bb0280)
M. van der Velde, L. Nisini
Performance of the MARS-crop yield forecasting system for the European Union: Assessing accuracy, in-season, and year-to-year improvements from 1993 to 2015
Agr. Syst., 168 (2019), pp. 203-212, [10.1016/j.agsy.2018.06.009](https://doi.org/10.1016/j.agsy.2018.06.009)
60.  [van Diepen et al., 1989](#bb0285)
C. van Diepen, J. Wolf, H. Van Keulen, C. Rappoldt
WOFOST: a simulation model of crop production
Soil Use Manag., 5 (1989), pp. 16-24, [10.1111/j.1475-2743.1989.tb00755.x](https://doi.org/10.1111/j.1475-2743.1989.tb00755.x)
61.  [van Klompenburg et al., 2020](#bb0290)
T. van Klompenburg, A. Kassahun, C. Catal
Crop yield prediction using machine learning: A systematic literature review
Comput. Electron. Agric., 177 (2020), Article 105709, [10.1016/j.compag.2020.105709](https://doi.org/10.1016/j.compag.2020.105709)
62.  [Wang and Yang, 2018](#bb0295)
Wang, Z., Yang, J., 2018. Diabetic retinopathy detection via deep convolutional networks for discriminative localization and visual explanation. In: Workshops at the thirty-second AAAI conference on artificial intelligence. [https://www.aaai.org/ocs/index.php/WS/AAAIW18/paper/view/16668/0](https://www.aaai.org/ocs/index.php/WS/AAAIW18/paper/view/16668/0), Last accessed: June 29, 2022.
63.  [Wolanin et al., 2020](#bb0300)
A. Wolanin, G. Mateo-García, G. Camps-Valls, L. Gómez-Chova, M. Meroni, G. Duveiller, Y. Liangzhi, L. Guanter
Estimating and understanding crop yields with explainable deep learning in the Indian Wheat Belt
Environmental research letters, 15 (2) (2020), Article 024019, [10.1088/1748-9326/ab68ac](https://doi.org/10.1088/1748-9326/ab68ac)
64.  [Xu et al., 2019](#bb0305)
Xu, F., Uszkoreit, H., Du, Y., Fan, W., Zhao, D., Zhu, J., 2019. Explainable AI: A brief survey on history, research areas, approaches and challenges. In: CCF international conference on natural language processing and Chinese computing, Springer. pp. 563–574. doi: 10.1007/978-3-030-32236-6\_51.
65.  [You et al., 2017](#bb0310)
You, J., Li, X., Low, M., Lobell, D., Ermon, S., 2017. Deep Gaussian process for crop yield prediction based on remote sensing data. In: Thirty-First AAAI Conference on Artificial Intelligence. [https://www-cs.stanford.edu/∼ermon/papers/cropyield\_AAAI17.pdf](https://www-cs.stanford.edu/%7eermon/papers/cropyield_AAAI17.pdf), Last accessed: July 25, 2022.
66.  [Zeiler and Fergus, 2014](#bb0315)
Zeiler, M.D., Fergus, R., 2014. Visualizing and understanding convolutional networks. In: European conference on computer vision, Springer. pp. 818–833. doi: 10.1007/978-3-319-10590-1\_53.

