# Model selection for accurate daily global solar radiation prediction in China

# 中国精确预测每日太阳总辐射的模型选择

Shaban G. Gouda a,b, Zakia Hussein a,b, Shuai Luo a,c, Qiaoxia Yuan a,d,*

a 华中农业大学工程学院，中国武汉市洪山区狮子山街，430070  
b 农业与生物系统工程系，Benha大学农学院，埃及 Benha，13736  
c 山东省农业机械科学研究院，中国济南，250100  
d 农业农村部长江中下游农业装备重点实验室，中国武汉，430070

# 文章信息

文章历史：2018年10月28日收稿 2019年2月7日修回 2019年2月19日录用 2019年2月26日在线发布

关键词：中国 年积日 通用模型 太阳总辐射 太阳气候分区 统计评估

# 摘要

太阳能可以在解决中国环境污染和能源危机方面发挥重要作用。对于大多数太阳能应用而言，准确获取水平面接收的太阳辐射量信息是首要步骤。本研究使用中国84个站点的长期数据，校准和评估了9种基于年积日的模型来估算水平面上的每日太阳总辐射(DGSR)。将中国划分为五个太阳气候区后，为每个分区选择性能最佳的模型作为通用年积日模型，并在各太阳分区进行校准和评估。基于统计指标：均方根误差(RMSE)、平均绝对偏差误差(MABE)、决定系数$(\mathbb{R}^2)$、相关系数(r)、95%置信水平的不确定度$(\mathrm{U}_{95})$以及泰勒图，结果表明模型在接收高太阳辐射量的区域表现最佳，性能随日太阳辐射量的减少而降低。混合正弦和余弦波的年积日模型表现最优，D7模型在I区表现最好，D8模型在II和IV区表现最佳。对于II和V区，高斯形式模型(D3模型)和四阶多项式模型(D4模型)分别表现出较高性能。而双高斯形式模型在所有区域表现最差。本研究开发的各分区通用年积日模型可以高精度地用于估算中国全境无数据或数据缺失地区的水平面DGSR。

$^{\mathrm{\textregistered}}$ 2019 Elsevier Ltd. 版权所有

# 1. 引言

可再生能源是解决能源危机和环境污染问题的最佳方案。根据中国国家统计局数据(http://www.stats.gov.cn/tjsj/ndsj/2010/indexch.htm)，2010年中国能源消费总量达32.5亿吨标准煤，其中煤炭生产和消费占比达67%，这凸显了中国面临严重的环境污染问题。太阳能作为清洁、安全且环境友好的能源，在解决这些问题中可以发挥重要作用。然而，使用太阳能的主要挑战是其间歇性问题。因此，太阳能系统需要与目前正在开发的储能技术相结合(Dizaji和Hosseini，2018)。

中国有数千个城镇和数百个城市，不同城市因其纬度不同而具有不同的日辐照参数和理想倾角。中国90%以上的国土年太阳辐照量超过4500MJ/m²，表明中国拥有丰富的太阳能资源(Liu等，2010；Xie等，2012)。需要准确的太阳辐射信息来辅助不同地形气候条件下的系统设计和模拟(Gouda等，2018)。这些信息对农业工作者、建筑师、城市规划者、制造商和其他领域工程师也很有价值(Cao等，2017；Lemos等，2017；Yao等，2017)。尽管中国政府投入了大量资金并给予优先考虑，但在2000多个气象站中只有122个测量太阳辐射(Chen和Li，2013)。因此，必须找到一种准确的方法来估算水平面上的每日太阳总辐射(DGSR)，特别是在没有任何测量工具的地区。

为此，研究者开发了多种经验模型来估算DGSR，这些模型依赖于目标站点的气象和地理数据，如日照时数(Angstrom，1924；Bahel等，1987；Jemaa等，2013；Ogelman等，1984；Prescott，1940；Rietveld，1978)、气温(Allen，1997；Chen和Li，2013；Chen等，2004；Li等，2010b，2014)、降水量(Li等，2010b)、相对湿度、云量、纬度经度、海拔高度(Chen等，2006；Li等，2010b；Liu等，2009；Zhao等，2013；Zou等，2016；Gouda等，2018)。所有这些模型都需要依赖特定气象数据，因此估算DGSR需要具备需要工具测量的气象数据，这在中国某些地区既困难又昂贵。

基于年积日的独立模型可以解决这个问题，因为它们不依赖任何特定的输入气象数据，也不需要任何预先计算分析(Mohammadi等，2015)。然而，文献中已开发的用于估算水平面DGSR的年积日模型相对较少。Al-Salaymeh(2006)提出了四种不同形式的模型来预测约旦安曼市的DGSR，其中正弦波形式表现最佳。Bulut和Buyukalaca(2007)开发了第一个基于年积日的三角函数模型(正弦波形式)，结果显示该模型在土耳其伊斯坦布尔市估算DGSR具有良好精度。Kaplanis和Kaplani(2007)研究了第二个模型(余弦波函数)，在希腊六个气候区评估显示其性能优异。Li等(2010a)使用中国79个站点的长期数据评估了三个现有年积日模型，并提出了新的混合正弦和余弦波模型，结果表明新模型性能优于其他模型。

此外，Zang等(2012)检验了两个现有模型，并提出了与Li等(2010a)模型类似但形式不同的新模型。他们使用中国35个站点的数据评估了新模型和另外两个现有模型。新模型在中国所有区域表现良好，因此需要更大规模应用。Khorasanizadeh和Mohammadi(2013)在伊朗四个城市(Bandarabass、Isfahan、Kerman和Tabass)检验了六个年积日模型，确定了各城市及相似气候区域的最佳模型。Kaplanis等(2016)开发了基于年积日的通用DGSR估算模型，该模型采用两个余弦波函数，适用于南、北半球大多数位于0°至71°纬度范围内的地区。

最近，Hassan等(2016)在埃及十个城市检验评估了七个现有年积日模型，结果显示混合正弦余弦波和四阶多项式模型表现最佳，因此开发了全国通用模型。Quej等(2017)提出了基于两个高斯函数的新年积日模型，用于墨西哥尤卡坦半岛六个城市的预测，并与四个现有模型比较，结果显示新模型在所有季节都具有更高精度。Aoun和Bouchouicha(2017)使用阿尔及利亚21个城市21年的DGSR数据，检验了六个现有年积日模型并开发了全国通用模型，结果显示混合正弦余弦波模型在全国表现最佳。

中国已开发的水平面DGSR预测通用模型都是依赖模型，需要观测气象数据且大多未覆盖全国。例如Li等(2013b)收集了中国83个站点的太阳辐射、日照时数、相对湿度和温度数据，基于纬度、经度和海拔开发了各太阳辐射分区的通用模型和站点特定模型，发现基于日照时数、温度、相对湿度和地理信息的通用模型具有良好精度。Li等(2013a)基于最高和最低温度的两个模型估算了中国西南地区水平面DGSR，结果显示这两个模型表现最佳。

文献表明，模型性能因地点和数学形式而异。同时，现有年积日模型研究多集中于少数站点，且中国尚未开发基于太阳气候分区的独立通用模型。因此，本研究旨在使用中国84个站点的数据检验评估现有年积日模型，采用最佳太阳气候分区方法将中国划分为不同区域，选择各太阳分区性能最佳的模型，并确定和评估适用于不同太阳气候分区的通用DGSR估算模型。

# 2. 材料与方法

# 2.1. 数据来源与研究区域

每日太阳辐射数据取自DAM数据库(http://dam.itpcas.ac.cn/data/daily_solar_radiation_dataset_over_China.zip)。

该数据集包含中国气象局(CMA)716个站点1961-2010年共50年的观测数据。数据由两部分组成：第一部分是Yang等(2001,2006)开发的混合日太阳辐射模型在716个站点的估算结果；第二部分是基于人工神经网络模型在96个辐射站点的更高精度估算结果。这些数据已被多项研究使用，如Tang等(2013,2010)和Zou等(2016)的研究。

中国国土面积约960万平方公里(Lam等,2005)，北接欧亚大陆，东临太平洋。地形总体呈西高东低特征，导致气候条件差异显著：降水量从东南沿海向西北内陆递减，太阳辐射分布不均(Ouyang等,2017)。根据不同气候变量和指标，可采用多种方法进行气候分区，具体取决于分类目的(Domrös和Gongbing,1988)。

太阳辐射分区是评估全球太阳辐射模型的前提。自1930年代以来已有大量气候分类研究(Lam等,2005)，如Lau等(2007)和Cao等(2017)的工作。本研究采用Liu等(2017)基于660个气象站数据、以月平均日太阳辐射为分区指标，通过k均值聚类和支持向量机-遗传算法将中国划分为五个太阳辐射区的分类方案(Gouda和Yuan,2018a,b,c; Liu等,2018)。图1展示了中国84个站点在五个太阳气候区的分布情况，表1列出了这些站点的地理信息和数据记录。

# 2.2. 使用模型

本研究评估了文献中9种仅基于年积日、不依赖其他参数的水平面DGSR估算模型，简要介绍如下：

# D1: Al-Salaymeh模型1

Al-Salaymeh(2006)提出了四种不同形式的约旦安曼市水平面DGSR估算模型。第一种为正弦波相关模型：

利用正弦和余弦波函数，基于中国79个气象站的实测日太阳辐射数据估算DGSR：

$$
R_{g} = a_{1} + a_{2}\sin \left(\frac{2\pi N}{365} a_{3} + a_{4}\right) + a_{5}\cos \left(\frac{2\pi N}{365} a_{6} + a_{7}\right) \tag{7}
$$

其中$a_{1}-a_{7}$为经验系数。

# D8: Zang模型

Zang等(2012)开发了结合正弦和余弦波相关的新模型，基于35个站点至少10年的长期实测数据：

$$
R_{g} = a_{1} + a_{2}\sin \left(\frac{2\pi N}{365} +a_{3}\right) + a_{4}\cos \left(\frac{2\pi N}{365} +a_{5}\right) \tag{8}
$$

# D9: Quej模型

$$
R_{g} = a_{1} + a_{2}\sin \left(\frac{2\pi N}{a_{3}} +a_{4}\right) \tag{1}
$$

其中$R_{g}$为水平面DGSR(单位：MJ/m²·天)，$N$为年积日，$a_{1},a_{2},a_{3},a_{4}$分别为振幅、相位偏移、波长和截距等经验系数。

# D2: Al-Salaymeh模型2

第二种为Lorentzin相关模型(Al-Salaymeh,2006)：

Quej等(2017)提出基于两个高斯函数之和的新模型，用于墨西哥尤卡坦半岛水平面DGSR估算：

$$
R_{g} = a_{1} + a_{2}\exp \left[-0.5\times \left(\frac{N - a_{3}}{a_{4}}\right)^{2}\right] + a_{5}\exp \left[-0.5\times \left(\frac{N - a_{6}}{a_{7}}\right)^{2}\right]
$$

使用CurveExpert软件(http://www.curveexpert.net)获取模型经验系数，除式(4)采用多项式回归外，其余方程均采用非线性回归方法。

$$
R_{g} = \frac{a_{1}}{1 + \left(\frac{N - a_{2}}{a_{3}}\right)^{2}} \tag{2}
$$

其中$a_{1},a_{2},a_{3}$分别为振幅、中心和宽度参数。

# D3: Al-Salaymeh模型3

第三种为高斯形式模型(Al-Salaymeh,2006)：

# 2.3. 模型性能评估

在本研究中，基于常见的统计指标评估了模型的准确性和适用性，这些指标包括均方根误差(RMSE)、平均绝对偏差误差(MABE)、决定系数$(\mathbb{R}^2)$和相关系数(r)。这些指标定义如下：

$$
RMSE = \sqrt{\frac{1}{j}\sum_{i = 1}^{j}\left(\overline{R}_{i,m} - \overline{R}_{i,c}\right)^2} \tag{10}
$$

$$
MABE = \frac{1}{j}\sum_{i = 1}^{j}\left|\left(\overline{R}_{i,m} - \overline{R}_{i,c}\right)\right| \tag{11}
$$

$$
R^{2} = 1 - \frac{\sum_{i = 1}^{j}\left(\overline{R}_{i,m} - \overline{R}_{i,c}\right)^{2}}{\sum_{i = 1}^{j}\left(\overline{R}_{i,m} - \overline{R}_{m,avg}\right)^{2}} \tag{12}
$$

$$
r = \frac{\sum_{i = 1}^{j}\left(\overline{R}_{i,c} - \overline{R}_{c,avg}\right)\left(\overline{R}_{i,m} - \overline{R}_{m,avg}\right)}{\left(\sum_{i = 1}^{j}\left(\overline{R}_{i,c} - \overline{R}_{c,avg}\right)^{2}\sum_{i = 1}^{j}\left(\overline{R}_{i,m} - \overline{R}_{m,avg}\right)^{2}\right)^{0.5}} \tag{13}
$$

$$
R_{g} = a_{1}\exp \left[-0.5\times \left(\frac{N - a_{2}}{a_{3}}\right)^{2}\right] \tag{3}
$$

其中$a_{1}, a_{2}$和$a_{3}$分别表示振幅、中心和宽度参数。

# D4: Al-Salaymeh模型4

Al-Salaymeh(2006)最终提出了一个四阶多项式模型：

其中$j$为数据量，下标$i$表示太阳辐射的第$i$个值；$c$和$m$分别表示计算值和实测值；$\overline{R}_{c,avg}$和$\overline{R}_{m,avg}$分别表示计算和实测太阳辐射的平均值；$\mathbb{R}^2$的取值范围为0到1(越接近1表示性能越好)。该统计量反映了模型对实测数据的拟合程度。当RMSE越接近零时，模型性能越好。此外，$r$的取值范围为$-\infty$到1，性能良好的模型$r$值接近1。MABE给出了平均偏差误差的绝对值，提供了关于

$$
R_{g} = a_{1} + a_{2}N + a_{3}N^{2} + a_{4}N^{3} + a_{5}N^{4} \tag{4}
$$

其中$a_{1}-a_{4}$为经验系数。

# D5: Bulut and Büyükalaca模型

Bulut and Büyükalaca(2007)提出了一个仅依赖于年积日的简单正弦波模型来预测水平面DGSR：

其中$j$为数据量，下标$i$表示太阳辐射的第$i$个值；$c$和$m$分别表示计算值和实测值；$\overline{R}_{c,avg}$和$\overline{R}_{m,avg}$分别表示计算和实测太阳辐射的平均值；$\mathbb{R}^2$的取值范围为0到1(越接近1表示性能越好)。该统计量反映了模型对实测数据的拟合程度。当RMSE越接近零时，模型性能越好。此外，$r$的取值范围为$-\infty$到1，性能良好的模型$r$值接近1。MABE给出了平均偏差误差的绝对值，提供了关于

$$
R_{g} = a_{1} + a_{2}\bigg|\sin \bigg(\frac{\pi(N + 5)}{365}\bigg)\bigg|^{1.5} \tag{5}
$$

# D6: Kaplanis and Kaplan模型

Kaplanis and Kaplan(2007)提出了基于年积日的余弦波模型来预测DGSR：

$$
r = \frac{\sum_{i = 1}^{j}\left(\overline{R}_{i,c} - \overline{R}_{c,avg}\right)\left(\overline{R}_{i,m} - \overline{R}_{m,avg}\right)}{\left(\sum_{i = 1}^{j}\left(\overline{R}_{i,c} - \overline{R}_{C,avg}\right)^{2}\sum_{i = 1}^{j}\left(\overline{R}_{i,m} - \overline{R}_{m,avg}\right)^{2}\right)^{0.5}} \tag{13}
$$

![](images/f2583ca65c095438fe068805e8abf7c5a5fbb9e93590c5d490bc634a5e2865b2.jpg)  
图1. 中国太阳能区域划分及对应站点分布图

模型性能的信息，MABE值越接近零表示性能越好。

此外，基于95%置信水平的不确定度$(\mathrm{U}_{95})$用于提供更多关于模型偏差的信息(Gueymard,2014)：

$$
U_{95} = 1.96\left(SD^{2} + RMSE^{2}\right)^{0.5} \tag{14}
$$

其中1.96是对应95%置信水平的覆盖因子，$SD$是计算值与实测值之差的标准偏差。

# 3. 结果与讨论

本研究基于年积日构建了9个模型，在将中国划分为5个太阳能区域后，评估了这些模型在全国84个站点预测日总太阳辐射(DGSR)的准确性。

中国84个站点的DGSR实测数据被分为两个数据集。第一个数据集用于通过多元线性和非线性回归方法获取各模型的经验系数。决定系数$(\mathbb{R}^2)$指标用于评估回归线与实际数据点的拟合程度。第二个数据集用于验证模型性能。表S1(补充数据)展示了9个模型在中国5个太阳能区域84个站点的回归系数及统计指标。测试模型的表现因站点和区域而异，最佳模型已用粗体标出。

在以下小节中，我们将基于统计指标和泰勒图评估各模型性能，并与观测数据进行比较(表2提供了各区域气候特征的简要说明)。我们将选择最佳模型，并选取代表性站点来展示不同模型之间的差异以及各站点最佳模型的性能表现。

# 3.1. 区域I

在区域I中，模型D7在9个模型中表现最佳，且在所有站点都保持稳定性能。该模型的r值范围为0.755-0.986，RMSE、MABE、$\mathrm{U}_{95}$和$\mathbb{R}^2$值范围分别为0.933-$1.646\mathrm{MJ}/\mathfrak{m}^2$天、$0.751-1.308\mathrm{MJ}/\mathrm{m}^2$天、2.575-4.550和0.799-0.983。此外，模型D4在整个区域I也表现出良好且稳定的性能，但略逊于D7模型，其r、RMSE、MABE、U95和$\mathbb{R}^2$范围分别为$0.668-0.985$、$0.953-1.861\mathrm{MJ}/\mathrm{m}^2$天、$0.755-1.456\mathrm{MJ}/\mathrm{m}^2$天、2.637-5.157和0.667-0.970(表S1)。

模型D8表现最佳，而模型D2和D3表现稍逊。模型D1表现最差，其次是D9模型，它们的r值最低(分别为0.328和0)。由于D7模型表现最优，我们采用18个站点的日均数据拟合该模型作为本区域的最佳模型。表3结果显示，区域I的通用模型表现良好，其r、RMSE、MABE、$\mathrm{U}_{95}$和$\mathbb{R}^2$值分别为$0.984$、$0.780\mathrm{MJ}/\mathrm{m}^2$天、$0.586\mathrm{MJ}/\mathrm{m}^2$天、2.062和0.976。

表1 中国各太阳能气候区选定站点的地理位置和数据记录

| 区域 | 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 | 区域 | 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 |
|------|------|---------|---------|--------|-------|-------|------|------|---------|---------|--------|-------|-------|
| I | Gangcha | 100.13 | 37.33 | 3301.5 | 1961-1995 | 1996-2006 | III | Lanzhou | 103.88 | 36.05 | 1517.2 | 1961-1993 | 1994-2004 |
| I | Gecemu | 94.9 | 36.42 | 2897.6 | 1991-1995 | 1996-2006 | III | Taiyuan | 112.55 | 37.78 | 773.3 | 1961-1995 | 1996-2006 |
| I | Geer | 80.08 | 32.5 | 4278 | 1961-1995 | 1996-2006 | III | Yanan | 109.5 | 36.6 | 958.5 | 1961-1995 | 1996-2006 |
| I | Naqu | 92.07 | 31.48 | 4507 | 1961-1995 | 1996-2006 | III | Anyang | 114.37 | 36.12 | 75.5 | 1961-1995 | 1996-2006 |
| I | Lasa | 91.13 | 29.67 | 3648.7 | 1969-1995 | 1996-2006 | III | Tongliao | 122.27 | 43.6 | 178.5 | 1961-1995 | 1996-2006 |
| I | Yushu | 97.02 | 33.02 | 3681.2 | 1961-1995 | 1996-2006 | III | Changchun | 125.22 | 43.9 | 236.8 | 1961-1995 | 1996-2006 |
| I | Guoluo | 100.25 | 34.47 | 3719 | 1991-2000 | 2001-2006 | III | Tianjin | 117.07 | 39.08 | 2.5 | 1961-1995 | 1996-2006 |
| I | Changdu | 97.17 | 31.15 | 3306 | 1961-1995 | 1996-2006 | III | Dalian | 121.63 | 38.9 | 91.5 | 1961-1995 | 1996-2006 |
| I | Ganzi | 100 | 31.62 | 3393.5 | 1961-1995 | 1996-2006 | III | Jinan | 116.98 | 36.68 | 51.6 | 1961-1995 | 1996-2006 |
| I | Lijiang | 100.22 | 25.87 | 2392.4 | 1961-1995 | 1996-2006 | III | Juxian | 118.83 | 35.58 | 107.4 | 1961-1989 | 1990-1997 |
| I | Panzhihua | 101.72 | 26.58 | 1190.1 | 1988-2001 | 2002-2006 | III | Xi'an | 108.93 | 34.3 | 397.5 | 1961-1995 | 1996-2006 |
| I | Tengchong | 98.5 | 25.02 | 1654.6 | 1961-1995 | 1996-2006 | III | Zhengzhou | 113.65 | 34.72 | 110.4 | 1961-1995 | 1996-2006 |
| I | Kunming | 102.68 | 25.02 | 1892.4 | 1969-1995 | 1996-2006 | IV | Nanyang | 112.58 | 33.03 | 120.2 | 1961-1995 | 1996-2006 |
| I | Mengzi | 103.38 | 23.38 | 1300.7 | 1961-1995 | 1996-2006 | IV | Wuhan | 114.13 | 30.62 | 23.1 | 1961-1995 | 1996-2006 |
| I | Sanya | 109.52 | 18.23 | 5.9 | 1961-1995 | 1996-2006 | IV | Ganzhou | 114.95 | 25.85 | 123.8 | 1961-1995 | 1996-2006 |
| I | Yining | 81.33 | 43.95 | 662.5 | 1961-1995 | 1996-2006 | IV | Qingjiang | 119.03 | 33.6 | 17.5 | 1961-1991 | 1992-2001 |
| I | Urumqi | 87.62 | 43.78 | 917.9 | 1961-1995 | 1996-2006 | IV | Gushi | 115.67 | 32.17 | 57.1 | 1961-1995 | 1996-2006 |
| I | Turpan | 89.2 | 42.93 | 34.5 | 1961-1995 | 1996-2006 |

| 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 | 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 |
|------|---------|---------|--------|-------|-------|------|---------|---------|--------|-------|-------|
| 南京 | 118.8 | 32 | 8.9 | 1961-1995 | 1996-2006 | 阿克苏 | 80.23 | 41.17 | 1103.8 | 1961-1995 | 1996-2006 |
| 阿拉提 | 88.08 | 47.73 | 735.3 | 1961-1995 | 1996-2006 | 合肥 | 117.23 | 31.87 | 27.9 | 1961-1995 | 1996-2006 |
| 塔城 | 83 | 46.73 | 534.9 | 1961-1995 | 1996-2006 | 上海 | 121.48 | 31.4 | 6 | 1991-2001 | 2002-2006 |
| 喀什 | 75.98 | 39.47 | 1288.7 | 1968-1995 | 1996-2006 | 杭州 | 120.17 | 30.23 | 41.7 | 1961-1995 | 1996-2006 |
| 若羌 | 88.17 | 39.03 | 888.3 | 1961-1995 | 1996-2006 | 庐山 | 115.98 | 29.58 | 116.5 | 1961-1995 | 1996-2006 |
| 和田 | 79.93 | 37.13 | 1374.5 | 1961-1995 | 1996-2006 | 屯溪 | 118.28 | 29.72 | 142.7 | 1961-1995 | 1996-2006 |
| 哈密 | 93.52 | 42.82 | 737.2 | 1968-1995 | 1996-2006 | 南昌 | 115.92 | 28.6 | 46.7 | 1961-1995 | 1996-2006 |
| 额济纳旗 | 101.07 | 41.95 | 940.5 | 1961-1995 | 1996-2006 | 洪家 | 121.42 | 28.62 | 1.3 | 1969-1995 | 1996-2006 |
| 敦煌 | 94.68 | 40.15 | 1139 | 1969-1995 | 1996-2006 | 福州 | 119.28 | 26.08 | 84 | 1961-1995 | 1996-2006 |
| 酒泉 | 98.48 | 39.77 | 1477.2 | 1961-1995 | 1996-2006 | 汕头 | 116.68 | 23.4 | 1.1 | 1961-1995 | 1996-2006 |
| 民勤 | 103.08 | 38.63 | 1367 | 1961-1995 | 1996-2006 | 南宁 | 108.35 | 22.82 | 73.1 | 1961-1995 | 1996-2006 |
| 二连浩特 | 111.97 | 43.65 | 964.7 | 1961-1995 | 1996-2006 | 海口 | 110.35 | 20.03 | 13.9 | 1961-1995 | 1996-2006 |
| 海流图 | 108.52 | 41.57 | 1288 | 1962-1995 | 1996-2006 | 绵阳 | 104.68 | 31.47 | 470.8 | 1963-1995 | 1996-2006 |
| 大同 | 113.33 | 40.1 | 1067.2 | 1961-1995 | 1996-2006 | 成都 | 104.02 | 30.67 | 506.1 | 1961-1993 | 1994-2003 |
| 东胜 | 109.98 | 39.85 | 1460.4 | 1961-1995 | 1996-2006 | 峨眉山 | 103.33 | 29.52 | 3047.4 | 1961-1995 | 1996-2006 |
| 银川 | 106.22 | 38.48 | 1111.4 | 1961-1995 | 1996-2006 | 安康 | 109.03 | 32.72 | 290.8 | 1961-1995 | 1996-2006 |
| 固原 | 106.27 | 36 | 1753 | 1961-1995 | 1996-2006 |

| 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 | 站点 | 经度(°E) | 纬度(°N) | 海拔(m) | 校准期 | 验证期 |
|------|---------|---------|--------|-------|-------|------|---------|---------|--------|-------|-------|
| 宜昌 | 111.3 | 30.7 | 138.1 | 1961-1995 | 1996-2006 | 重庆 | 106.47 | 29.58 | 259.1 | 1961-1995 | 1996-2006 |
| 锡林浩特 | 116.07 | 43.95 | 989.5 | 1961-1995 | 1996-2006 | 泸州 | 105.43 | 28.88 | 334.8 | 1961-1995 | 1996-2006 |
| 黑河 | 127.45 | 50.25 | 166.4 | 1961-1995 | 1996-2006 | 吉首 | 109.73 | 28.32 | 208.4 | 1961-1994 | 1995-2005 |
| 海拉尔 | 119.75 | 49.22 | 610.2 | 1961-1995 | 1996-2006 | 长沙 | 112.92 | 28.22 | 68 | 1987-2000 | 2001-2006 |
| 富裕 | 124.48 | 47.8 | 162.7 | 1961-1995 | 1996-2006 | 贵阳 | 106.72 | 26.58 | 1074.3 | 1961-1995 | 1996-2006 |
| 索伦 | 121.22 | 45.6 | 499.7 | 1961-1995 | 1996-2006 | 常宁 | 112.4 | 26.42 | 115.6 | 1987-2000 | 2001-2005 |
| 佳木斯 | 130.28 | 45.82 | 81.2 | 1961-1995 | 1996-2006 | 桂林 | 110.3 | 25.32 | 161.4 | 1969-1995 | 1996-2006 |
| 哈尔滨 | 126.77 | 45.75 | 142.3 | 1961-1995 | 1996-2006 |

选择Naque站作为I区的代表站，图2比较了不同模型和该区域最佳模型(GM)的DGSR数据与预测数据。

使用泰勒图比较模型性能。泰勒图展示模型性能的主要优势在于可以根据性能对模型进行聚类。与表S1结果一致，模型D9和D1的代表点距离参考点(实测值)最远，表明这些模型性能较差。而模型D1、D2、D3、D4、D5、D6和D8最接近参考点(实测值)，它们的代表点彼此靠近，表明其性能相似。此外，模型D7是距离实测点最近的点，因此其性能最佳，I区的通用模型(GM)表现出可接受的性能，其代表点接近实测点(见图3)。

# 3.2. II区

对于II区，模型D8表现最佳，其r值范围为0.935-0.989，RMSE值为1.071-1.688 MJ/m²天，MABE值为0.820-1.336 MJ/m²天，U95范围为2.968-4.666，R²范围为0.948-0.991。模型D6性能略低于D8，其r、RMSE、MABE、U95和R²值范围分别为0.934-0.989、1.087-1.811 MJ/m²天、0.835-1.455 MJ/m²天、3.014-4.959和0.948-0.991。这表明在模型(D8)中同时使用正弦和余弦函数可以提高性能(Zang等，2012)。模型D2表现良好，其次是D3、D5、D4和D1。性能最差的是D9，其次是D7，它们的r和R²值范围分别为0-0.983和0.238-0.989；0-0.983和0.59-0.992。这些结果表明D7和D9模型不适合估算II区的DGSR，而模型D8表现出最优性能(表S1)。因此，使用II区21个站点的平均数据获得最佳模型(D8)的经验系数，II区通用模型(GM)的经验系数和统计指标列于表3，其r、RMSE、MABE、U95和R²值分别为0.991、0.783 MJ/m²天、0.622 MJ/m²天、2.160和0.992。

选择银川站作为II区的代表站。图4展示了观测数据与不同模型及最佳模型(GM)预测数据的比较。从泰勒图(图5)可以看出，模型D9、D7和D1性能较差，其代表点距离参考点最远。而模型D3、D3、D4、D5、D6和D8最接近参考点且彼此靠近，表明其性能相似。模型D8是距离实测点最近的点，因此性能最佳。II区的通用模型(GM)表现出可接受的性能，其代表点距离实测点不远。

# 3.3. III区

对于III区，模型D3表现最佳且最稳定，其r值范围为0.885-0.975，RMSE值为1.648-2.304 MJ/m²天，MABE值为1.233-1.764 MJ/m²天，U95范围为4.305-6.125，R²范围为0.917-0.983。模型D2、D6、D5和D1表现良好，而模型D4和D8在所有站点表现良好，除了延安站(D4)和佳木斯站(D8)，它们的RMSE、MABE和U95值最高(分别为7.806和10.248 MJ/m²天、7.638和10.098 MJ/m²天、15.623和20.376)。性能最差的是模型D9和D7，它们的r和R²值最低；D9和D7的r值分别为0和0.17，R²值分别为0和0.027。从表S1可以看出，在III区东北部(中国东北)的海拉尔和黑河站，模型性能较好，而在南部(莒县和郑州)的站点性能下降。

使用18个站点的平均数据获得III区最佳模型D3的经验系数，其R²、RMSE、MABE、U95和r值分别为0.980、1.042 MJ/m²天、0.835 MJ/m²天、2.743和0.983(表3)。

选择海拉尔站作为II区的代表站，图6展示了该站实测数据与各模型及GM模型计算数据的比较。此外，泰勒图与表3结果一致(图7)。模型D9和D1性能较差，其代表点距离参考点最远。而模型D2、D3、D4、D5、D6、D7和D8最接近参考点，表明其性能最佳。通用模型(GM)表现最好，其代表点接近实测点。

# 3.4. Zone IV

For zone IV, D8 model performed best followed by model D4. For these two models, the values of r, RMSE, MABE,  $\mathrm{U}_{95}$  and  $\mathbb{R}^2$  range between 0.789- 0.916 and 0.790- 0.914, 2.015- 2.651 and 2.035- 2.644 MJ/m2 day, 1.615- 2.069 and  $1.639 - 2.061\mathrm{MJ / m^2}$  day, 5.115- 7.348 and 5.163- 7.330, and 0.740- 0.924 and 0.739- 0.921, respectively. Models D3, D2, D6, and D5 exhibit acceptable and approximately similar performance. On other hands, model D9 followed by models D1 and D7 give the worst performance among others, where the values of r are between 0 and 0.907, 0.158- 0.904 and 0.299- 0.909, respectively.  $\mathbb{R}^2$  values range between 0 and 0.931, 0.119- 0.938 and 0.024- 0.927, respectively (Table S1). It is noticeable that the model D8 is the superior performance among others in zone IV. Therefore, the averaged data of 18 station are employed to fit this model and the empirical coefficients and statistical indicators are presented in Table 3. For general model,  $\mathbb{R}^2$  RMSE, MABE,  $\mathrm{U}_{95}$  and r values are  $0.950, 1.241 \mathrm{MJ} / \mathrm{m}^2$  day,  $1.0 \mathrm{MJ} / \mathrm{m}^2$  day, 3.366 and 0.947, respectively.

表2 中国五个太阳能区域的气候特征

| 区域 | 主要位置 | 最热月份 | 月平均日气温(°C) | 年平均日相对湿度(%) | 年平均日照时数(h) | 年平均日总太阳辐射(MJ/m²天) |
|------|----------|----------|------------------|---------------------|-------------------|-----------------------------|
| I    | 西藏、青海、宁夏、云南和海南 | 7月 | 16.1 | 59.5 | 6.8 | 17.0 |
| II   | 新疆、内蒙古和甘肃 | 8月 | 22.8 | 51.2 | 8.0 | 15.9 |
| III  | 华东和华中地区 | 8月 | 23.4 | 64.3 | 6.7 | 13.9 |
| IV   | 中国东部和南部沿海地区 | 7月 | 27.4 | 77.5 | 4.9 | 12.8 |
| V    | 四川和贵阳 | 7月 | 26.2 | 78.6 | 3.6 | 10.4 |

表3 中国各太阳能区域通用模型的经验系数和统计指标

| 区域 | 通用模型(GM) | a1 | a2 | a3 | a4 | a5 | a6 | a7 | R² | RMSE | MABE | U95 | r |
|------|-------------|----|----|----|----|----|----|----|----|------|------|-----|----|
| I | D7 | 17.743 | 4.551 | -0.976 | -14.597 | -0.982 | 1.952 | -0.17 | 0.984 | 0.780 | 0.586 | 2.062 | 0.976 |
| II | D8 | 16.841 | -49.939 | 0.004 | -8.271 | 1.032 | - | - | 0.991 | 0.783 | 0.622 | 2.160 | 0.992 |
| III | D3 | 20.538 | 168.631 | 109.313 | - | - | - | - | 0.980 | 1.042 | 0.835 | 2.743 | 0.983 |
| IV | D8 | 13.009 | -0.523 | 1.269 | -4.779 | 0.977 | - | - | 0.950 | 1.241 | 1.0 | 3.366 | 0.947 |
| V | D4 | 6.791 | -0.065 | 1.999×10⁻³ | -9.850×10⁻⁶ | 1.330×10⁻⁸ | - | - | 0.912 | 1.309 | 1.030 | 3.557 | 0.944 |

![](images/60be56f88976e32e20fc931221a3cc761e9d7f6fa748c9656129b239e9c8fdbe.jpg)  
图2. 纳曲站(I区)观测数据与所用模型及最佳模型(GM)预测数据的比较

![](images/25063e52e4001d646553b9806bdd53aabcd069bbf2f1c21254d74e8bd5a0979f.jpg)  
图3. 纳曲站(I区)所用模型及通用模型(GM)的DGSR泰勒图

![](images/fd2de0ae8f3b08668509940c94b605a3ba4a726241aa1b3a84c70156c018ddc5.jpg)  
图4. 银川站(II区)观测数据与所用模型及最佳模型(GM)预测数据的比较



以IV区代表站吕四站的实测日太阳辐射数据，展示了不同模型与该区通用模型(GM)预测数据的差异(图8)。此外，通过泰勒图(图9)展示了不同模型与通用模型的性能表现，D9、D8和D1模型的代表点距离参考点最远，

![](images/313c941d41478ce674ff5853a353797a8585fd4d74567eacbbfb490dca3dae3d.jpg)  
图5. 银川站(II区)所用模型及通用模型(GM)的DGSR泰勒图

![](images/25cb2582614337ae03731e32577a4ce081539eb8d00dd9b0dcd999f5a59364d3.jpg)  
图6. 海拉尔站(III区)观测数据与所用模型及最佳模型(GM)预测数据的比较

这表明这些模型性能较差，与表S1结果一致。而D2、D3、D4、D5、D6和GM模型的代表点最接近参考点，意味着这些模型表现出良好且相似的性能。

# 3.5. V区

对于V区，通过该区域12个站点的数据分析，模型D4表现最为准确稳定。该模型的r值范围为0.692-0.934，RMSE值为1.850-2.116 MJ/m²天，MABE值为1.455-1.708 MJ/m²天，U95范围为5.089-5.865，R²范围为0.646-0.907。模型D6、D8、D2表现出良好且相似的性能，其次是D5模型。而D9和D1模型表现最差，其r和R²值范围分别为0-0.933和0.010-0.911(D9)，0.384-0.926和0.165-0.903(D1)。虽然D7模型在多数站点表现最佳，但在泸州站性能显著下降(r=0.392，R²=0.241)。因此选择D4作为该区DGSR估算的最佳模型。为此，使用12个站点的平均数据拟合D4模型，其系数列于表3。可见通用模型表现最佳，其R²=0.912，RMSE=1.309 MJ/m²天，MABE=1.030 MJ/m²天，U95=3.557，r=0.944。

为展示实测与预测数据的差异，选择泸州站进行分析(图10)。泰勒图证实D9、D7和D1模型的代表点距离实测点最远，表明这些模型(特别是D9)不可靠。而D3、D4、D5、D6和D8模型表现出相似且良好的性能，其代表点位置相近且接近实测点(见图11)。

# 4. 结论

本研究利用中国84个区域的DGSR数据，将中国划分为五个太阳气候区，评估了文献中八种基于年积日模型的性能，并为每个太阳气候区开发了通用模型。采用多项式和非线性回归方法生成模型的经验系数。通过回归系数(R²)、相关系数(r)、均方根误差(RMSE)、平均绝对偏差误差(MABE)、95%置信水平的不确定性(U95)和泰勒图等统计指标评估性能。结果表明：I区最佳为三角混合正余弦波模型(D7)，可作为该区通用模型；II区和IV区最佳为混合正余弦波模型(D8)；III区因高斯模型(D3)在18个站点表现稳定而选为通用模型；V区最佳为四次多项式模型(D4)，可作为该区通用模型。

所有使用模型的性能在接收高值DGSR的区域(I区)表现更好，而在接收较低太阳辐射量的区域(II区)表现较差。本研究开发和评估的基于年积日的通用模型可以用于准确估算中国每日全球太阳辐射，且不需要任何气象数据。这类模型尚未考虑从各站点模型获得的每日太阳辐射数据变化，这需要在未来进行研究。因此，结合地理参数和/或目标站点水平面上的每日地外太阳辐射可能会提高模型性能，并使其能够随站点和年份变化。

![](images/6d1453abcb5b22429efe754839eab63559b1cc3932769cf0d8ed029b58b7859c.jpg)  
图7. 海拉尔站(II区)所用模型及通用模型(GM)的DGSR泰勒图

![](images/7f4f8cba2d679a41f6d5aef9ec544797e2d3bcbeffd08814574d5ebcb74361ea.jpg)  
图8. 吕四站(IV区)观测数据与所用模型及最佳模型(GM)预测数据的比较

![](images/26200fc93f13d26a5faab75c0a629fc8841e5c17ce7e8eec39a199edcdd8029a.jpg)  
图9. 吕四站(IV区)所用模型及通用模型(GM)的DGSR泰勒图

![](images/b9d8d0592310a35cc090f0575a1d97846a2af392f0bd90de099aeb29f77e363b.jpg)  
图10. 泸州站(V区)观测数据与所用模型及最佳模型(GM)预测数据的比较

![](images/5a7e72066d58713f4318edc43da9266fed20511a5dc99f62a5cf26db7ca532a4.jpg)  
图11. 泸州站(V区)所用模型及通用模型(GM)的DGSR泰勒图



# 致谢

国家重点研发计划项目(编号：2017YFD080080804-01)和中国国家留学基金委(编号：2016818T54)为本研究提供了资金支持。

# 附录A. 补充数据

本文的补充数据可在https://doi.org/10.1016/j.jclepro.2019.02.211在线获取。

# 参考文献

1.  [Al-Salaymeh, 2006](#bbib1)
A. Al-Salaymeh
安曼市水平面全球日太阳辐射建模
Emir. J. Eng. Res., 11 (2006), pp. 49-56

2.  [Allen, 1997](#bbib2)
R.G. Allen
基于气温自校准的太阳辐射估算方法
J. Hydrol. Eng., 2 (1997), pp. 56-67

3.  [Angstrom, 1924](#bbib3)
A. Angstrom
太阳与地球辐射：关于太阳和大气辐射光化研究的国际太阳能研究委员会报告
Q. J. R. Meteorol. Soc., 50 (1924), pp. 121-126

4.  [Aoun and Bouchouicha, 2017](#bbib4)
N. Aoun, K. Bouchouicha
基于年积日的阿尔及利亚全球日太阳辐射估算
Eur. Phys. J. Plus, 132 (2017)

5.  [Bahel et al., 1987](#bbib5)
V. Bahel, H. Bakhsh, R. Srinivasan
全球太阳辐射估算的相关性研究
Energy, 12 (1987), pp. 131-135

6.  [Bulut and Büyükalaca, 2007](#bbib6)
H. Bulut, O. Büyükalaca
土耳其日全球太阳辐射数据的简单生成模型
Appl. Energy, 84 (2007), pp. 477-491

7.  [Cao et al., 2017](#bbib7)
F. Cao, H. Li, T. Yang, Y. Li, T. Zhu, L. Zhao
中国北方散射太阳辐射模型评估：新模型建立与辐射源比较
Renew. Energy, 103 (2017), pp. 708-720

8.  [Chen and Li, 2013](#bbib8)
J.-L. Chen, G.-S. Li
基于中国长江流域实测气象数据的月平均日太阳辐射估算
Int. J. Climatol., 33 (2013), pp. 487-498

9.  [Chen et al., 2004](#bbib9)
R. Chen, K. Ersi, J. Yang, S. Lu, W. Zhao
中国实测日数据验证五种全球辐射模型
Energy Convers. Manag., 45 (2004), pp. 1759-1769

10.  [Chen et al., 2006](#bbib10)
R. Chen, E. Kang, S. Lu, J. Yang, X. Ji, Z. Zhang, J. Zhang
基于中国气象数据的全球辐射估算新方法
Energy Convers. Manag., 47 (2006), pp. 2991-2998
11.  [Dizaji and Hosseini, 2018](#bbib11)
H.B. Dizaji, H. Hosseini
聚光太阳能发电应用中纯金属和混合金属氧化物热化学储能系统的材料筛选综述
Renew. Sustain. Energy Rev., 98 (2018), pp. 9-26
12.  [Domrös and Gongbing, 1988](#bbib12)
M. Domrös, P. Gongbing
中国气候区划
M. Domrös, P. Gongbing (Eds.), 中国气候, Springer Berlin Heidelberg, Berlin, Heidelberg (1988), pp. 258-280
13.  [Gouda et al., 2018](#bbib13)
S.G. Gouda, Z. Hussein, S. Luo, P. Wang, H. Cao, Q. Yuan
中国武汉市全球太阳辐射估算的经验模型
Eur. Phys. J. Plus, 133 (2018), p. 517
14.  [Gouda and Yuan, 2018a](#bbib14)
S.G. Gouda, Q. Yuan
对Liu等人"中国水平面日全球太阳辐射分区及通用估算模型"的评论
\[Energy Conversion and Management, 2017.10.043.\]. Energy Conversion and Management 168 (2018), pp. 651-652
15.  [Gouda and Yuan, 2018b](#bbib15)
S.G. Gouda, Q. Yuan
对"评论Liu等人中国水平面日全球太阳辐射分区及通用估算模型"的更正
\[Energy Convers. Manage. (2017) 10.043.\]' \[Energy Convers. Manage. (In press)\]. Energy Conversion and Management (2018)
16.  [Gouda and Yuan, 2018c](#bbib16)
S.G. Gouda, Q. Yuan
对"Liu等人对评论的回复"的回复
\[Energy Convers. Manage. (2017) 10.043\] \[Energy Convers. Manage. (2018) 05.051\], by Liu et al.". Energy Conversion and Management (2018)
17.  [Gueymard, 2014](#bbib17)
C.A. Gueymard
太阳辐射模型数据验证方法和统计性能指标综述：提升太阳能项目可融资性
Renew. Sustain. Energy Rev., 39 (2014), pp. 1024-1034
18.  [Hassan et al., 2016](#bbib18)
G.E. Hassan, M.E. Youssef, M.A. Ali, Z.E. Mohamed, A.I. Shehata
基于年积日的全球太阳辐射估算模型性能评估-以埃及为例
J. Atmos. Sol. Terr. Phys., 149 (2016), pp. 69-80
19.  [Jemaa et al., 2013](#bbib19)
A.B.E.N. Jemaa, S. Rafa, N. Essounbouli, A. Hamzaoui, F. Hnaien, F. Yalaoui
三种简单方法估算全球太阳辐射
Energy Procedia, 42 (2013), pp. 406-415
20.  [Kaplanis and Kaplani, 2007](#bbib20)
S. Kaplanis, E. Kaplani
期望均值和随机小时全球太阳辐射I(h;nj)值的预测模型
Renew. Energy, 32 (2007), pp. 1414-1425
21.  [Kaplanis et al., 2016](#bbib21)
S. Kaplanis, J. Kumar, E. Kaplani
日总太阳辐射预测的通用模型研究
Renew. Energy, 91 (2016), pp. 178-188
22.  [Khorasanizadeh and Mohammadi, 2013.](#bbib50)
H Khorasanizadeh, K Mohammadi
伊朗阳光充足地区四个城市基于年积日的日总太阳辐射预测
Energy Convers. Manag., 76 (2013), pp. 385-392
23.  [Lam et al., 2005](#bbib22)
J.C. Lam, C.L. Tsang, L. Yang, D.H.W. Li
中国不同气候区气象数据分析及设计启示
Build. Environ., 40 (2005), pp. 277-296
24.  [Lau et al., 2007](#bbib23)
C.C.S. Lau, J.C. Lam, L. Yang
中国气候区划及被动式太阳能设计启示
Energy Convers. Manag., 48 (2007), pp. 2006-2015
25.  [Lemos et al., 2017](#bbib24)
L.F.L. Lemos, A.R. Starke, J. Boland, J.M. Cardemil, R.D. Machado, S. Colle
基于BRL模型的巴西太阳辐射分量评估
Renew. Energy, 108 (2017), pp. 569-580
26.  [Li et al., 2014](#bbib25)
H. Li, F. Cao, X. Wang, W. Ma
基于温度的中国月平均日总太阳辐射估算模型
Sci. World J., 2014 (2014), p. 128754
27.  [Li et al., 2010a](#bbib26)
H. Li, W. Ma, Y. Lian, X. Wang
中国基于年积日的日总太阳辐射估算
Appl. Energy, 87 (2010), pp. 3011-3017
28.  [Li et al., 2013a](#bbib27)
M.-F. Li, L. Fan, H.-B. Liu, P.-T. Guo, W. Wu
基于气温和地理参数的西南地区日总太阳辐射通用估算模型
J. Atmos. Sol. Terr. Phys., 92 (2013), pp. 145-150
29.  [Li et al., 2010b](#bbib28)
M.-F. Li, H.-B. Liu, P.-T. Guo, W. Wu
基于常规气象数据的重庆日太阳辐射估算
Energy Convers. Manag., 51 (2010), pp. 2575-2579
30.  [Li et al., 2013b](#bbib29)
M.-F. Li, X.-P. Tang, W. Wu, H.-B. Liu
中国大陆不同太阳辐射区日总太阳辐射通用估算模型
Energy Convers. Manag., 70 (2013), pp. 139-148
31.  [Liu et al., 2010](#bbib30)
L.-q. Liu, Z.-x. Wang, H.-q. Zhang, Y.-c. Xue
中国太阳能发展综述
Renew. Sustain. Energy Rev., 14 (2010), pp. 301-311
32.  [Liu et al., 2009](#bbib31)
X. Liu, X. Mei, Y. Li, Q. Wang, Y. Zhang, J.R. Porter
Ångström-Prescott系数引起的参考作物蒸散量变化：本地校准与FAO推荐值的比较
Agric. Water Manag., 96 (2009), pp. 1137-1145
33.  [Liu et al., 2017](#bbib32)
Y. Liu, Y. Zhou, D. Wang, Y. Wang, Y. Li, Y. Zhu
中国水平面日总太阳辐射分区及通用估算模型
Energy Convers. Manag., 154 (2017), pp. 168-179
34.  [Liu et al., 2018](#bbib33)
Y. Liu, Y. Zhou, D. Wang, Y. Wang, Y. Li, Y. Zhu
对"中国水平面日总太阳辐射分区及通用估算模型"[Energy Convers. Manage. 154 (2017) 168-179]评论的回复
Energy Conversion and Management 168, 653-654 (2018)
35.  [Mohammadi et al., 2015](#bbib34)
K. Mohammadi, S. Shamshirband, C.W. Tong, K.A. Alam, D. Petković
基于年积日的自适应神经模糊系统在日总太阳辐射预测中的应用潜力
Energy Convers. Manag., 93 (2015), pp. 406-413
36.  [National Bureau of Statistics of People's Republic of China,](#bbib35)
National Bureau of Statistics of People's Republic of China. 能源消费总量及其构成, <[http://www.stats.gov.cn/tjsj/ndsj/2010/indexch.htm](http://www.stats.gov.cn/tjsj/ndsj/2010/indexch.htm)\> (访问于2019年1月21日).
37.  [Ögelman et al., 1984](#bbib36)
H. Ögelman, A. Ecevit, E. Tasdemiroǧlu
基于日照时数估算太阳辐射的新方法
Sol. Energy, 33 (1984), pp. 619-625
38.  [Ouyang et al., 2017](#bbib37)
L. Ouyang, L. Sun, Y. Yuan, X. Cao, B. Xiang
中国不同辐射区光伏热收集器的最佳连接模式
Appl. Therm. Eng., 122 (2017), pp. 661-672
39.  [Prescott, 1940](#bbib38)
J. Prescott
水面蒸发与太阳辐射的关系研究
Trans. Roy. Soc. S. Aust., 64 (1940), pp. 114-118
40.  [Quej et al., 2017](#bbib39)
V.H. Quej, J. Almorox, M. Ibrakhimov, L. Saito
基于年积日的墨西哥尤卡坦半岛六城市日总太阳辐射估算
J. Clean. Prod., 141 (2017), pp. 75-82
41.  [Rietveld, 1978](#bbib40)
M. Rietveld
一种估算太阳辐射与日照时间关系公式中回归系数的新方法
Agric. Meteorol., 19 (1978), pp. 243-252
42.  [Tang et al., 2013](#bbib41)
W. Tang, J. Qin, K. Yang, X. Niu, X. Zhang, Y. Yu, X. Zhu
中国地区日光合有效辐射重建及其变化趋势
J. Geophys. Res.: Atmosphere, 118 (13) (2013)
292-213,302
43.  [Tang et al., 2010](#bbib42)
W. Tang, K. Yang, J. He, J. Qin
中国全球太阳辐射数据质量控制与估算
Sol. Energy, 84 (2010), pp. 466-475
44.  [Xie et al., 2012](#bbib43)
H. Xie, C. Zhang, B. Hao, S. Liu, K. Zou
中国太阳能义务政策综述
Renew. Sustain. Energy Rev., 16 (2012), pp. 113-122
45.  [Yang et al., 2001](#bbib44)
K. Yang, G.W. Huang, N. Tamai
全球太阳辐射估算的混合模型
Sol. Energy, 70 (2001), pp. 13-22
46.  [Yang et al., 2006](#bbib45)
K. Yang, T. Koike, B. Ye
通过引入全球数据集改进小时、日和月尺度太阳辐射估算
Agric. For. Meteorol., 137 (2006), pp. 43-55
47.  [Yao et al., 2017](#bbib46)
W. Yao, C. Zhang, X. Wang, J. Sheng, Y. Zhu, S. Zhang
基于空气质量指数(AQI)修正的雾霾严重地区日散射太阳辐射新模型研究
Energy Convers. Manag., 139 (2017), pp. 140-150
48.  [Zang et al., 2012](#bbib47)
H. Zang, Q. Xu, H. Bian
中国不同气候区典型太阳辐射数据生成
Energy, 38 (2012), pp. 236-248
49.  [Zhao et al., 2013](#bbib48)
N. Zhao, X. Zeng, S. Han
利用日照时数和空气污染指数估算中国太阳辐射
Energy Convers. Manag., 76 (2013), pp. 846-851
50.  [Zou et al., 2016](#bbib49)
L. Zou, L. Wang, A. Lin, H. Zhu, Y. Peng, Z. Zhao
基于插值技术和人工神经网络的华东地区全球太阳辐射估算
J. Atmos. Sol. Terr. Phys., 146 (2016), pp. 110-122

# References

1.  [Al-Salaymeh, 2006](#bbib1)
A. Al-Salaymeh
Modelling of global daily solar radiation on horizontal surfaces for Amman city
Emir. J. Eng. Res., 11 (2006), pp. 49-56
2.  [Allen, 1997](#bbib2)
R.G. Allen
Self-calibrating method for estimating solar radiation from air temperature
J. Hydrol. Eng., 2 (1997), pp. 56-67
3.  [Angstrom, 1924](#bbib3)
A. Angstrom
Solar and terrestrial radiation. Report to the international commission for solar research on actinometric investigations of solar and atmospheric radiation
Q. J. R. Meteorol. Soc., 50 (1924), pp. 121-126
4.  [Aoun and Bouchouicha, 2017](#bbib4)
N. Aoun, K. Bouchouicha
Estimating daily global solar radiation by day of the year in Algeria
Eur. Phys. J. Plus, 132 (2017)
5.  [Bahel et al., 1987](#bbib5)
V. Bahel, H. Bakhsh, R. Srinivasan
A correlation for estimation of global solar radiation
Energy, 12 (1987), pp. 131-135
6.  [Bulut and Büyükalaca, 2007](#bbib6)
H. Bulut, O. Büyükalaca
Simple model for the generation of daily global solar-radiation data in Turkey
Appl. Energy, 84 (2007), pp. 477-491
7.  [Cao et al., 2017](#bbib7)
F. Cao, H. Li, T. Yang, Y. Li, T. Zhu, L. Zhao
Evaluation of diffuse solar radiation models in Northern China: new model establishment and radiation sources comparison
Renew. Energy, 103 (2017), pp. 708-720
8.  [Chen and Li, 2013](#bbib8)
J.-L. Chen, G.-S. Li
Estimation of monthly average daily solar radiation from measured meteorological data in Yangtze River Basin in China
Int. J. Climatol., 33 (2013), pp. 487-498
9.  [Chen et al., 2004](#bbib9)
R. Chen, K. Ersi, J. Yang, S. Lu, W. Zhao
Validation of five global radiation models with measured daily data in China
Energy Convers. Manag., 45 (2004), pp. 1759-1769
10.  [Chen et al., 2006](#bbib10)
R. Chen, E. Kang, S. Lu, J. Yang, X. Ji, Z. Zhang, J. Zhang
New methods to estimate global radiation based on meteorological data in China
Energy Convers. Manag., 47 (2006), pp. 2991-2998
11.  [Dizaji and Hosseini, 2018](#bbib11)
H.B. Dizaji, H. Hosseini
A review of material screening in pure and mixed-metal oxide thermochemical energy storage (TCES) systems for concentrated solar power (CSP) applications
Renew. Sustain. Energy Rev., 98 (2018), pp. 9-26
12.  [Domrös and Gongbing, 1988](#bbib12)
M. Domrös, P. Gongbing
Climate zones of China
M. Domrös, P. Gongbing (Eds.), The Climate of China, Springer Berlin Heidelberg, Berlin, Heidelberg (1988), pp. 258-280
13.  [Gouda et al., 2018](#bbib13)
S.G. Gouda, Z. Hussein, S. Luo, P. Wang, H. Cao, Q. Yuan
Empirical models for estimating global solar radiation in Wuhan City, China
Eur. Phys. J. Plus, 133 (2018), p. 517
14.  [Gouda and Yuan, 2018a](#bbib14)
S.G. Gouda, Q. Yuan
Comments on “Classification of solar radiation zones and general models for estimating the daily global solar radiation on horizontal surfaces in China’’, by Liu et al.
\[Energy Conversion and Management, 2017.10.043.\]. Energy Conversion and Management 168 (2018), pp. 651-652
15.  [Gouda and Yuan, 2018b](#bbib15)
S.G. Gouda, Q. Yuan
Corrigendum to ‘Comments on “Classification of solar radiation zones and general models for estimating the daily global solar radiation on horizontal surfaces in China”, by Liu et al.
\[Energy Convers. Manage. (2017) 10.043.\]’ \[Energy Convers. Manage. (In press)\]. Energy Conversion and Management (2018)
16.  [Gouda and Yuan, 2018c](#bbib16)
S.G. Gouda, Q. Yuan
Reply to “Reply to \[Comments on “Classification of solar radiation zones and general models for estimating the daily global solar radiation on horizontal surfaces in China”
\[Energy Convers. Manage. (2017) 10.043\] \[Energy Convers. Manage. (2018) 05.051\], by Liu et al.”. Energy Conversion and Management (2018)
17.  [Gueymard, 2014](#bbib17)
C.A. Gueymard
A review of validation methodologies and statistical performance indicators for modeled solar radiation data: towards a better bankability of solar projects
Renew. Sustain. Energy Rev., 39 (2014), pp. 1024-1034
18.  [Hassan et al., 2016](#bbib18)
G.E. Hassan, M.E. Youssef, M.A. Ali, Z.E. Mohamed, A.I. Shehata
Performance assessment of different day-of-the-year-based models for estimating global solar radiation - case study: Egypt
J. Atmos. Sol. Terr. Phys., 149 (2016), pp. 69-80
19.  [Jemaa et al., 2013](#bbib19)
A.B.E.N. Jemaa, S. Rafa, N. Essounbouli, A. Hamzaoui, F. Hnaien, F. Yalaoui
Estimation of global solar radiation using three simple methods
Energy Procedia, 42 (2013), pp. 406-415
20.  [Kaplanis and Kaplani, 2007](#bbib20)
S. Kaplanis, E. Kaplani
A model to predict expected mean and stochastic hourly global solar radiation I(h;nj) values
Renew. Energy, 32 (2007), pp. 1414-1425
21.  [Kaplanis et al., 2016](#bbib21)
S. Kaplanis, J. Kumar, E. Kaplani
On a universal model for the prediction of the daily global solar radiation
Renew. Energy, 91 (2016), pp. 178-188
22.  [Khorasanizadeh and Mohammadi, 2013.](#bbib50)
H Khorasanizadeh, K Mohammadi
Prediction of daily global solar radiation by day of the year in four cities located in the sunny regions of Iran
Energy Convers. Manag., 76 (2013), pp. 385-392
23.  [Lam et al., 2005](#bbib22)
J.C. Lam, C.L. Tsang, L. Yang, D.H.W. Li
Weather data analysis and design implications for different climatic zones in China
Build. Environ., 40 (2005), pp. 277-296
24.  [Lau et al., 2007](#bbib23)
C.C.S. Lau, J.C. Lam, L. Yang
Climate classification and passive solar design implications in China
Energy Convers. Manag., 48 (2007), pp. 2006-2015
25.  [Lemos et al., 2017](#bbib24)
L.F.L. Lemos, A.R. Starke, J. Boland, J.M. Cardemil, R.D. Machado, S. Colle
Assessment of solar radiation components in Brazil using the BRL model
Renew. Energy, 108 (2017), pp. 569-580
26.  [Li et al., 2014](#bbib25)
H. Li, F. Cao, X. Wang, W. Ma
A temperature-based model for estimating monthly average daily global solar radiation in China
Sci. World J., 2014 (2014), p. 128754
27.  [Li et al., 2010a](#bbib26)
H. Li, W. Ma, Y. Lian, X. Wang
Estimating daily global solar radiation by day of year in China
Appl. Energy, 87 (2010), pp. 3011-3017
28.  [Li et al., 2013a](#bbib27)
M.-F. Li, L. Fan, H.-B. Liu, P.-T. Guo, W. Wu
A general model for estimation of daily global solar radiation using air temperatures and site geographic parameters in Southwest China
J. Atmos. Sol. Terr. Phys., 92 (2013), pp. 145-150
29.  [Li et al., 2010b](#bbib28)
M.-F. Li, H.-B. Liu, P.-T. Guo, W. Wu
Estimation of daily solar radiation from routinely observed meteorological data in Chongqing, China
Energy Convers. Manag., 51 (2010), pp. 2575-2579
30.  [Li et al., 2013b](#bbib29)
M.-F. Li, X.-P. Tang, W. Wu, H.-B. Liu
General models for estimating daily global solar radiation for different solar radiation zones in mainland China
Energy Convers. Manag., 70 (2013), pp. 139-148
31.  [Liu et al., 2010](#bbib30)
L.-q. Liu, Z.-x. Wang, H.-q. Zhang, Y.-c. Xue
Solar energy development in China—a review
Renew. Sustain. Energy Rev., 14 (2010), pp. 301-311
32.  [Liu et al., 2009](#bbib31)
X. Liu, X. Mei, Y. Li, Q. Wang, Y. Zhang, J.R. Porter
Variation in reference crop evapotranspiration caused by the Ångström–Prescott coefficient: locally calibrated versus the FAO recommended
Agric. Water Manag., 96 (2009), pp. 1137-1145
33.  [Liu et al., 2017](#bbib32)
Y. Liu, Y. Zhou, D. Wang, Y. Wang, Y. Li, Y. Zhu
Classification of solar radiation zones and general models for estimating the daily global solar radiation on horizontal surfaces in China
Energy Convers. Manag., 154 (2017), pp. 168-179
34.  [Liu et al., 2018](#bbib33)
Y. Liu, Y. Zhou, D. Wang, Y. Wang, Y. Li, Y. Zhu
Reply to “Comments on \[“Classification of solar radiation zones and general models for estimating the daily global solar radiation on horizontal surfaces in China”
\[Energy Convers. Manage. 154 (2017) 168–179\] by Liu et al.\]”. Energy Conversion and Management 168, 653-654 (2018)
35.  [Mohammadi et al., 2015](#bbib34)
K. Mohammadi, S. Shamshirband, C.W. Tong, K.A. Alam, D. Petković
Potential of adaptive neuro-fuzzy system for prediction of daily global solar radiation by day of the year
Energy Convers. Manag., 93 (2015), pp. 406-413
36.  [National Bureau of Statistics of People's Republic of China,](#bbib35)
National Bureau of Statistics of People's Republic of China. Total consumption of energy and its composition, <[http://www.stats.gov.cn/tjsj/ndsj/2010/indexch.htm](http://www.stats.gov.cn/tjsj/ndsj/2010/indexch.htm)\> (Accessed 21 January 2019).
37.  [Ögelman et al., 1984](#bbib36)
H. Ögelman, A. Ecevit, E. Tasdemiroǧlu
A new method for estimating solar radiation from bright sunshine data
Sol. Energy, 33 (1984), pp. 619-625
38.  [Ouyang et al., 2017](#bbib37)
L. Ouyang, L. Sun, Y. Yuan, X. Cao, B. Xiang
Optimum connection modes for photovoltaic thermal collectors in different radiation zones of China
Appl. Therm. Eng., 122 (2017), pp. 661-672
39.  [Prescott, 1940](#bbib38)
J. Prescott
Evaporation from a water surface in relation to solar radiation
Trans. Roy. Soc. S. Aust., 64 (1940), pp. 114-118
40.  [Quej et al., 2017](#bbib39)
V.H. Quej, J. Almorox, M. Ibrakhimov, L. Saito
Estimating daily global solar radiation by day of the year in six cities located in the Yucatán Peninsula, Mexico
J. Clean. Prod., 141 (2017), pp. 75-82
41.  [Rietveld, 1978](#bbib40)
M. Rietveld
A new method for estimating the regression coefficients in the formula relating solar radiation to sunshine
Agric. Meteorol., 19 (1978), pp. 243-252
42.  [Tang et al., 2013](#bbib41)
W. Tang, J. Qin, K. Yang, X. Niu, X. Zhang, Y. Yu, X. Zhu
Reconstruction of daily photosynthetically active radiation and its trends over China
J. Geophys. Res.: Atmosphere, 118 (13) (2013)
292-213,302
43.  [Tang et al., 2010](#bbib42)
W. Tang, K. Yang, J. He, J. Qin
Quality control and estimation of global solar radiation in China
Sol. Energy, 84 (2010), pp. 466-475
44.  [Xie et al., 2012](#bbib43)
H. Xie, C. Zhang, B. Hao, S. Liu, K. Zou
Review of solar obligations in China
Renew. Sustain. Energy Rev., 16 (2012), pp. 113-122
45.  [Yang et al., 2001](#bbib44)
K. Yang, G.W. Huang, N. Tamai
A hybrid model for estimating global solar radiation
Sol. Energy, 70 (2001), pp. 13-22
46.  [Yang et al., 2006](#bbib45)
K. Yang, T. Koike, B. Ye
Improving estimation of hourly, daily, and monthly solar radiation by importing global data sets
Agric. For. Meteorol., 137 (2006), pp. 43-55
47.  [Yao et al., 2017](#bbib46)
W. Yao, C. Zhang, X. Wang, J. Sheng, Y. Zhu, S. Zhang
The research of new daily diffuse solar radiation models modified by air quality index (AQI) in the region with heavy fog and haze
Energy Convers. Manag., 139 (2017), pp. 140-150
48.  [Zang et al., 2012](#bbib47)
H. Zang, Q. Xu, H. Bian
Generation of typical solar radiation data for different climates of China
Energy, 38 (2012), pp. 236-248
49.  [Zhao et al., 2013](#bbib48)
N. Zhao, X. Zeng, S. Han
Solar radiation estimation using sunshine hour and air pollution index in China
Energy Convers. Manag., 76 (2013), pp. 846-851
50.  [Zou et al., 2016](#bbib49)
L. Zou, L. Wang, A. Lin, H. Zhu, Y. Peng, Z. Zhao
Estimation of global solar radiation using an artificial neural network based on an interpolation technique in southeast China
J. Atmos. Sol. Terr. Phys., 146 (2016), pp. 110-122

