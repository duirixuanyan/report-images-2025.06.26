# PlantGaussian: Exploring 3D Gaussian splatting for cross-time, cross-scene, and realistic 3D plant visualization and beyond

[![作物学报](https://ars.els-cdn.com/content/image/DKEAI.gif)](/journal/the-crop-journal "前往ScienceDirect上的作物学报")

## [作物学报](/journal/the-crop-journal "前往ScienceDirect上的作物学报")

[第13卷, 第2期](/journal/the-crop-journal/vol/13/issue/2 "前往本卷/期的目录"), 2025年4月, 第607-618页

[![作物学报](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125X00039-cov150h.gif)](/journal/the-crop-journal/vol/13/issue/2)

# PlantGaussian：探索3D高斯泼溅技术用于跨时间、跨场景的逼真3D植物可视化及其他应用

Author links open overlay panelPeng Shen a, Xueyao Jing b, Wenzhe Deng b, Hanyue Jia b, Tingting Wu b c

a

信息工程学院，西北农林科技大学，陕西杨凌 712100

b

机械与电子工程学院，西北农林科技大学，陕西杨凌 712100

c

陕西省农业信息感知与智能服务重点实验室，陕西杨凌 712100

显示更多

大纲

添加到Mendeley

分享

引用

[https://doi.org/10.1016/j.cj.2025.01.011](https://doi.org/10.1016/j.cj.2025.01.011 "使用数字对象标识符的永久链接")[获取权限和内容](https://s100.copyright.com/AppDispatchServlet?publisherName=ELS&contentID=S2214514125000261&orderBeanReset=true)

根据知识共享[许可协议](http://creativecommons.org/licenses/by-nc-nd/4.0/)

开放获取

## 摘要

跨时间和不同场景观察植物对于揭示植物生长模式至关重要。传统方法往往难以在复杂背景下和不同生长阶段观察或测量植物。这凸显了需要一种能够在不同时间和场景下提供逼真植物可视化的通用方法。在此，我们介绍了PlantGaussian，一种用于生成跨时间和场景的逼真三维（3D）植物可视化的方法。它标志着3D高斯泼溅技术在植物科学中的首次应用之一，实现了跨物种和生长阶段的高质量可视化。通过整合Segment Anything Model（SAM）和跟踪算法，PlantGaussian克服了传统高斯重建技术在复杂种植环境中的局限性。采用了一种新的网格分割技术，将高斯渲染结果转换为可测量的植物网格，为精确的3D植物形态表型分析提供了方法。为了支持这种方法，开发了PlantGaussian数据集，其中包括在多种条件和生长阶段下捕获的四种作物物种的图像。仅使用植物图像序列作为输入，它就能计算高保真度的植物可视化模型和3D网格，用于3D植物形态表型分析。可视化结果表明，大多数植物模型的峰值信噪比（PSNR）超过25，优于包括原始3D高斯泼溅和增强NeRF在内的所有模型。网格结果表明，计算值与真实测量值之间的平均相对误差为4%。作为一种通用的3D数字植物模型，PlantGaussian将支持植物表型数据库的扩展、生态研究和远程专家咨询。

*   [上一篇文章](/science/article/pii/S2214514124002563)
*   [下一篇文章](/science/article/pii/S2214514125000224)

## 关键词

植物3D重建

植物表型分析

3D高斯

逼真植物可视化

## 1. 引言

植物是地球上最多样化和分布最广泛的生命形式之一，与人类生活错综复杂且多变地交织在一起。对植物的观察和研究长期以来一直是科学探究的基本方面[\[1\]](#b0005)。特别是在植物表型研究中，观察和测量植物外部形态使科学家能够定性和定量地分析植物生长模式、对病虫害的反应以及其他适应机制[\[2\]](#b0010), [\[3\]](#b0015), [\[4\]](#b0020)。这种观察不仅仅是被动的记录；它是全面分析植物生命的开始，也是科学研究不可或缺的一部分。

在不同环境和时间条件下的观察和分析揭示了植物生长和适应性的关键见解。不同生态环境下的系统分析表明，植物生长在不同环境因素下具有显著的可塑性[\[5\]](#b0025)。光对杨树顶端生长的影响揭示了日照时间与生长之间的直接相关性[\[6\]](#b0030)。研究表明，即使在干旱等极端条件下，向日葵仍能保持稳定的产量[\[7\]](#b0035)。然而，大多数此类测量需要专业人员现场操作，并且需要针对植物物种的特定测量技术。此外，一些方法具有破坏性，使得通过不同生长阶段连续监测植物变得复杂。因此，需要一种通用方法，允许对多种植物类型进行跨时间和跨场景的非破坏性观察和分析。

数字成像技术的进步部分解决了随时观察植物的挑战。图像处理技术是非接触式和非破坏性的，通常使用二维图像来计算形态参数，如宽度、长度和面积[\[8\]](#b0040), [\[9\]](#b0045), [\[10\]](#b0050), [\[11\]](#b0055)。虽然这种方法在一定程度上缓解了时间带来的限制，但不足以克服场景带来的挑战。捕捉图像的方法可能因植物物种而异，杂乱的背景会在各种场景中造成干扰。提取复杂的形态特征通常需要重建植物的精确3D信息[\[12\]](#b0060)。跨场景观察植物仍然是一个挑战。

3D重建技术迅速弥补了2D成像在植物可视化中的局限性，并通过标准化数据收集为各种植物物种创建了全面的多维几何模型[\[12\]](#b0060)。许多研究已经针对各种植物的3D重建方法进行了研究，利用点云[\[13\]](#b0065), [\[14\]](#b0070), [\[15\]](#b0075), [\[16\]](#b0080), [\[17\]](#b0085)、体素[\[18\]](#b0090), [\[19\]](#b0095), [\[20\]](#b0100), [\[21\]](#b0105)和网格[\[22\]](#b0110), [\[23\]](#b0115), [\[24\]](#b0120)。然而，这些研究通常集中在特定类型的植物上，植物点云的提取主要依赖于手动分割或大量注释。植物科学领域迫切需要一种通用的3D重建方法，能够适应不同植物，并对环境条件和生长阶段具有鲁棒性。还需要一个固定的协议来围绕植物捕获足够的图像，以生成详细的3D数字模型。

在2020年代，一些新颖的3D重建技术为创建通用数字植物铺平了道路[\[25\]](#b0125), [\[26\]](#b0130), [\[27\]](#b0135), [\[28\]](#b0140)。2020年引入的Neural Radiance Fields（NeRF）[\[29\]](#b0145）应用显示出巨大的潜力。最初在植物学领域应用，该技术取得了显著成果[\[30\]](#b0150), [\[31\]](#b0155）。然而，他们的研究主要集中在简单的植物形态上，如蔬菜和水果，NeRF在不同生长阶段生成精细的植物3D可视化方面仍然面临相当大的挑战。最近，3D高斯泼溅标志着3D重建的重大突破[\[32\]](#b0160）。经过短时间的训练，3D高斯泼溅可以实时大规模渲染复杂场景。该方法有两个优点：i）与各种改进的NeRF模型相比，原始3D高斯泼溅模型实现了高精度渲染，在精细3D可视化方面几乎超越了所有改进的NeRF变体[\[33\]](#b0165), [\[34\]](#b0170）；ii）与NeRF的隐式神经渲染不同，3D高斯泼溅遵循明确的训练方法。该方法生成的模型可保存、可重新训练和可编辑，有望取代经典的点云和三角测量方法。然而，由于3D高斯泼溅是为重建复杂大场景而设计的，目前很少有方法可以从重建结果中提取和保存仅感兴趣的对象。据我们所知，目前还没有专门用于3D植物重建的3D高斯泼溅应用的报道。

本研究提出了一种建立跨时间和场景的3D数字植物的方法。目标是：1）开发一种通用的3D重建方法，能够为各种植物创建详细的数字模型；2）设计一种植物前景分割技术，解决在复杂场景中仅重建植物的挑战；3）探索从3D渲染结果中提取可测量网格的方法，推进3D可视化技术在植物科学中的应用。

## 2. 材料与方法

### 2.1 植物材料与图像采集

本研究涉及三种环境下的植物图像数据采集：室内盆栽、室外盆栽和室外大田。采集了烟草作物不同生长阶段的图像。采集过程分为两个阶段：首先是植物表面的粗略采集，然后是不同植物部位（如冠层、侧面和底部）的详细形态采集。为确保传感器多样性，使用了多种品牌的智能手机进行图像采集。

采集的植物包括不同生长阶段的小麦、烟草、玉米以及其他一些植物。评估了烟草在盆栽和大田条件下的模型表现，以模拟时间（"跨时间"）变化。大田烟草于2023年6月至7月采集，并对单株植物的四个生长阶段进行了分析。盆栽烟草同样在2024年6月至7月期间采集并分析了相同阶段，所有样本均采集于陕西杨凌。评估了小麦、玉米和大豆模型在不同环境（"跨场景"）下的表现。从2023年8月至2024年5月，在四个地点采集了室内盆栽、室外盆栽和大田环境的样本：中国陕西杨凌、中国海南三亚、中国上海和澳大利亚阿德莱德。采集作物的详细列表见[表S1](#s0150)。

为确保实验的普适性，使用了四个品牌的智能手机进行图像采集，包括iPhone 12、华为Mate 60 Pro、华为Mate 30和红米K50，视频分辨率低于1080p，帧率为30或60Hz。采集植物视频后，进行了预处理，包括视频拼接、帧提取和模糊图像去除。

### 2.2 整体实验设计

如[图1](#f0005)所示，跨时间和跨场景的植物3D数字可视化探索分为四个步骤：i)植物图像采集和背景分割，ii)相机姿态估计与稀疏点云重建，iii)数字植物渲染，以及iv)网格提取。为确保该方法适用于任何植物跨时间和跨场景，采用了改进的Track Anything模型，结合了多尺度特征融合方法。将多个视角的植物图像流作为提示输入模型，以精细分割完整的植物前景。对于预分割结果，应用运动恢复结构（一种从多张2D图像重建3D结构并计算相机位置的技术）技术进行稀疏点云重建和相机姿态估计，确保初始点云和相机姿态的高精度。接下来，将稀疏点云、相机姿态和植物前景图像输入3D高斯模型。然后使用基于瓦片的栅格化器（一种以小块或"瓦片"处理图像的方法）获得高度逼真的3D数字植物。最后，为了使生成的3D结构更适合精确测量，对3D高斯点进行了额外的细化处理，生成了可测量的植物3D网格片段。

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1.jpg)

1.  [下载：下载高分辨率图像 (676KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1_lrg.jpg "下载高分辨率图像 (676KB)")
2.  [下载：下载全尺寸图像](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1.jpg "下载全尺寸图像")

图1. PlantGaussian模型的工作流程。该模型以多视角视频作为输入，输出植物可视化和植物表面。首先进行稀疏重建以获得稀疏点和相机姿态。随后使用增强的Track Anything模型提取植物前景。将植物前景与稀疏点和相机姿态一起用于初始化3D高斯点。基于这些初始化的3D高斯点，渲染出逼真的植物可视化，并进行植物表面计算。

### 2.3 相机姿态估计与稀疏点云生成

相机姿态估计和稀疏点云生成是3D高斯重建的关键步骤。这些步骤不仅为后续的密集重建和植物模型精细渲染提供了基础，还直接影响重建模型的质量和精度。为获得精确的相机参数和目标植物的稀疏点云，实验分为四个步骤：特征提取、特征点匹配、相机姿态估计和稀疏点云生成。

首先，使用尺度不变特征变换（SIFT）[\[35\]](#b0175)从所有图像序列中提取特征。SIFT在尺度空间中识别关键点，计算其方向和描述符，为后续特征点匹配奠定了坚实基础。

接下来，使用FLANN（快速近似最近邻库）[\[36\]](#b0180)方法对提取的特征点进行匹配，以估计相机姿态。为确保准确性和效率，特征点匹配在三个图像序列组内成对进行，避免跨组匹配。FLANN方法通过计算所有特征点对之间的距离并选择最小距离，最小化特征点之间的欧氏距离，从而找到最佳匹配。

基于特征匹配结果，使用PnP（Perspective-n-Point）算法计算相机姿态。利用已知世界坐标系中匹配点的位置，通过公式1准确计算每个点对应的相机位置。

$$s\begin{bmatrix}u\\v\\1\end{bmatrix}=K[R|t]\begin{bmatrix}X\\Y\\Z\\1\end{bmatrix}$$

其中$(u,v)$表示图像坐标系中的点，$K$是相机的内参矩阵。相机相对于世界坐标系的方位和位置由$R$（旋转）和$t$（平移）给出。$(X,Y,Z)$是世界坐标系中的坐标，$s$是比例因子。通过对所有匹配的特征点进行三角测量，创建植物场景的稀疏点云。

### 2.4. 基于Track Anything的植物前景精确分割

PlantGaussian模型使用多视角植物图像作为计算损失的真实值，因此植物前景图像的提取对后续训练至关重要。在田间环境中，复杂的背景给后续的可视化渲染和点云处理带来了挑战。为了有效应对这些挑战，本研究采用了改进的Track Anything模型（TAM）[\[37\]](#b0185)，结合预训练的Segment Anything模型（SAM）[\[38\]](#b0190)和XMem[\[39\]](#b0195)视频跟踪与分割算法。该方法能够在不同场景下对连续图像序列中的植物进行精确的前景分割。

#### 2.4.1. Track Anything模型介绍

TAM是一种先进的视频分割模型，它利用了Segment Anything模型（SAM），这是一个领先的图像分割模型。这种改进增强了SAM在视频应用中的功能，即使在高度复杂的场景中也能实现对象的交互式跟踪和分割。我们的方法包括使用植物三个垂直部分（顶部、中部和底部）的视频作为输入。只需最少的初始交互（点击几下），即可从多个角度获得全面而精确的前景分割。该算法的逐步过程如[图S1](#s0150)所示。

首先，将从不同视角通过帧采样提取的植物图像序列输入系统。用户从特定视角选择一张植物图像，并在图像的前景区域手动标记点。这些选定的点与植物图像一起被输入Segment Anything模型进行处理。

在SAM模型中，分割过程分为三个阶段：使用Vision Transformer（ViT）进行图像编码、提示解码和掩码解码。在ViT编码阶段，归一化的图像块经过多头注意力机制，使得植物图像能够在不同的表示空间中进行并行处理。自注意力机制的形式为：

$$Attention(Q,K,V)= softmax(\frac{QK^T}{\sqrt{d_k}})V$$

其中，$Q$、$K$和$V$分别代表查询矩阵、键矩阵和值矩阵。$d_k$表示键向量的维度。

在引入多头注意力机制后，进行残差连接和第二次归一化，随后连接一个多层感知器（MLP）。MLP由两个全连接层和一个ReLU激活函数组成，表示为：

$$MLPx=ReLU(W_1x+b_1)W_2+b_2$$

MLP的输出与输入相加，形成残差连接，以增强模型在不同尺度植物图像上的学习能力。这个过程重复执行以进行特征提取，形成图像嵌入。

在ViT编码阶段之后，提示解码阶段处理用户提示，用户选择的点被引入位置编码。这个组件有助于模型理解前景元素的空间特征。编码利用正弦和余弦变化，表示为：

$$PE(pos,2i)=sin(\frac{pos}{1000^{\frac{2i}{d_{model}}}})$$

$$PE(pos,2i+1)=cos(\frac{pos}{1000^{\frac{2i}{d_{model}}}})$$

其中，$pos$是位置索引，$i$是维度索引，$d_{model}$是编码的维度。

最后，在掩码解码阶段，模型使用自注意力和交叉注意力机制来处理图像嵌入和位置编码输出。自注意力有助于更深入地理解图像内部关系，而交叉注意力则增强了图像区域与输入点之间的关联，提高了植物前景分割的准确性。

#### 2.4.2. 多场景植物全方位前景分割

为了优化PlantGaussian模型，在Track Anything模型中采用多尺度融合方法校正来自不同视角的图像，如[图S2](#s0150)所示。该方法分为四个阶段：用户初始化、目标跟踪、目标校正和植物前景分割。

在用户初始化阶段，首先输入包含完整植物的图像。随后在图像中的植物前景区域点击一个点。然后基于SAM模型精确分割植物前景。在目标跟踪阶段，输入图像序列以及从一帧中分割出的植物前景。接着，SAM基于半监督视觉对象分割(VOS)细化边缘，如公式(6)所示：

$$E_t = SAM(VOS(I_t, S_1)), \quad for\ t = 2\ to\ n$$

其中$I_t$表示输入图像序列，$S_1$是从第一帧$I_1$中获得的植物前景。

在第三阶段目标校正中，输入来自不同视角的植物图像序列。从每个视角中选择一帧进行点标注。经过SAM分割后，提取多尺度特征$F_v$，并使用ICP算法[\[40\]](#b0200)进行空间对齐。将对齐后的特征$A$输入跟踪网络，如公式(7)所示：

$$A_v = ICP(\cup_{v=1}^V SAM(I_v, p_v))$$

其中$p_v$表示提取的植物前景。

在最终的植物前景分割阶段，输入完全校正后的多视角图像序列分割结果。通过估计序列帧的结构相似性来消除不完整结果，如公式(8)所示：

$$S_{final} = \cap_{v=1}^V SSIM(S_v', S_{v+1}')$$

最终获得完整的多视角植物前景分割结果。

### 2.5. 基于3D高斯泼溅的真实植物渲染

为了获得逼真的3D植物模型，采用3D高斯泼溅技术进行植物可视化渲染。该过程分为两个阶段：高斯点初始化和植物可视化渲染。

#### 2.5.1. 3D高斯点的初始化与优化

首先，从输入的稀疏点云中初始化3D高斯点。如[2.3节](#s0025)所述，该稀疏点云和相机姿态是通过场景图像的特征匹配和PnP计算获得的。从该稀疏点云中导出初始高斯点。每个高斯点的数学表示为公式(9)：

$$G(x;μ,Σ) = \frac{1}{(2π)^{\frac{3}{2}}|Σ|^{\frac{1}{2}}}e^{-\frac{1}{2}(x-μ)^TΣ^{-1}(x-μ)}$$

其中$x$是空间中的任意点，$μ$表示高斯分布的均值，表示每个高斯点的中心位置，$Σ$是协方差矩阵，控制高斯分布的形状和方向。

为了提高植物前景渲染的效率，高斯点的均值μ使用K-Means聚类基于输入点云进行初始化。假设输入的稀疏点云为P={p₁,p₂,...,pₙ}，其中pᵢ是点云中的一个点，μⱼ是聚类中心，每个聚类中心更新为(11):

μⱼ = 1/|Cⱼ| * ∑_{pᵢ∈Cⱼ} pᵢ

其中Cⱼ表示第j个聚类中的点集，|Cⱼ|是Cⱼ中的点数，∑_{pᵢ∈Cⱼ} pᵢ是Cⱼ中所有点的位置向量之和。

在模型学习准备阶段，协方差矩阵Σ的初始化涉及定义缩放和旋转变换矩阵，定义为(11):

Σ = R(q)S(s)S(s)ᵀR(q)ᵀ

其中R(q)表示由四元数q导出的旋转变换矩阵，S(s)表示由三维向量s表征的缩放变换。

#### 2.5.2. 植物可视化中的Splatting和渲染

整个高斯训练和渲染过程涉及优化3D高斯点的分布以更好地拟合植物模型。在训练过程中，每个初始点被splat到输入的多视角图像上进行渲染，并评估渲染结果与输入图像之间的差异。在高斯splatting中，该方法涉及计算投影的2D协方差矩阵(12):

Σ′ = JWΣWᵀJᵀ

其中J是雅可比矩阵，详细说明了投影过程中涉及的偏导数，W是与初始相机姿态(R₁,t₁)相关的旋转和平移矩阵。

渲染使用基于Tile的Rasterizer方法进行。在投影变换后，通过将3D高斯点与上述协方差矩阵相乘，使用公式(13)计算每个高斯点的不透明度:

α′ = 1 - e^{-α/det(Σ)^{1/2}}

其中α表示3D高斯点的不透明度，α′表示投影后2D高斯点的不透明度。

投影后，定义损失函数L(μ,Σ,C)来更新和优化参数，并执行反向传播。由于模型仅使用植物前景作为输入而不是完整图像，因此定义了加权方案以加速损失函数的收敛并减少伪影的出现。损失函数定义为(14):

L(μ,Σ,C) = ∑_{i=1}^N wᵢ * ||G(xᵢ;μ,Σ) - I(xᵢ)||²

其中wᵢ表示分配给每个像素的权重，N是目标数据中的像素数。G(xᵢ;μ,Σ)是从当前高斯参数渲染的图像强度，I(xᵢ)是xᵢ处的实际图像强度。

图像颜色C使用alpha合成计算(15):

C = ∑_{i∈N} cᵢαᵢ′ ∏_{j=1}^{i-1} (1-αⱼ′)

其中cᵢ是模型学习的颜色，αⱼ′是由公式(13)计算的不透明度。

基于计算的颜色和不透明度，高斯点从不同角度渲染到图像平面上，从而合成最终图像。从任何用户指定的视角（相机视角），都可以计算相应的投影图像，从而获得全面的3D数字植物渲染。

### 2.6. 从高斯渲染到网格提取

虽然3D高斯渲染提供了一种新的3D可视化方式，但标准的3D测量仍然依赖于基于网格的方法。在本工作中，我们采用SuGaR（面向网格渲染的表面对齐高斯泼溅）[\[41\]](#b0205)技术，从3D渲染的植物中快速提取三角网格，便于创建可测量的网格，如[图2](#f0010)所示。

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2.jpg)

1.  [下载：下载高分辨率图像 (872KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2_lrg.jpg "下载高分辨率图像 (872KB)")
2.  [下载：下载全尺寸图像](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2.jpg "下载全尺寸图像")

图2. 网格提取方法示意图。首先，重新训练高斯点分布以更好地贴合表面。该阶段包括三个步骤：计算符号距离函数（SDF）、优化密度函数和减少3D高斯缩放因子，最终实现高斯椭球体的扁平化。在第二阶段，通过粗点采样、泊松重建和网格化获得初始网格。在第三阶段，将高斯点绑定到三角网格上，基于网格结果进一步细化植物表面。

该方法由三个主要部分组成：引入正则化项、提取网格以及将3D高斯绑定到网格表面，专门用于解决准确建模植物表面的挑战。该过程首先通过优化带有正则化项的损失函数来改进高斯泼溅，从而产生紧密贴合植物表面的3D高斯分布，植物表面通常复杂且不规则。此优化涉及计算符号距离函数（SDF）值，以确保高斯与植物表面紧密对齐。此外，通过基于深度映射优化其密度来增强高斯重叠，然后通过减少其缩放因子来平滑3D高斯。这些新正则化项的引入产生了密集且精确对齐的3D高斯分布，紧密贴合植物结构。在第二阶段，增加高斯点的密度以生成植物表面的厚表示，然后通过泊松重建生成初始3D网格。随后使用SDF技术细化该网格，以捕捉植物表面几何的细节。最后，在第三阶段，将3D高斯重新绑定到细化后的网格上，从而能够进一步细化植物表面的特定部分，生成更适合农业分析的更准确和逼真的模型。

最后，模型评估了植物网格的准确性，测量过程如[图S3](#s0150)所示。评估重点放在盆栽烟草植物上，基于网格结果测量植物高度和最大叶长，并与真实测量值进行比较。为了建立重建模型的比例因子，使用花盆的内径作为参考。在分割烟草植物后，测量植物高度和最大叶长。植物高度通过烟草植物中心最高叶的高度确定。对于叶长，选择最大的叶子，测量从叶基部到叶尖的距离。

### 2.7. 实现平台和模型评估方法

实验在Ubuntu 22.04操作系统上进行，使用Intel Xeon(R) Platinum 8251C CPU（3.80 GHz × 24）和Nvidia GeForce RTX 3090显卡。深度学习框架采用PyTorch 1.12.1，编程环境为PyCharm，编程语言为Python 3.7.13。所有对比算法都在此统一设置下执行。数据收集和图像处理使用C++和OpenCV 4.7.0进行图像操作，程序调试使用Visual Studio 2022。

为了评估所提出的PlantGaussian模型的3D高斯可视化结果，使用了四个指标：PSNR（峰值信噪比）、MAE（平均绝对误差）、SSIM（结构相似性指数）和LPIPS（学习感知图像块相似性）。这些指标通过将模型渲染的图像与输入的多视角真实图像进行比较来计算。PSNR测量信号的最大可能功率与影响其表示的噪声功率之比。在本研究中，使用PlantGaussian模型渲染图像，然后与真实图像进行逐像素比较。PSNR通过确定两幅图像之间的均方误差（MSE）并应用对数变换来计算。MAE量化渲染图像与真实图像之间的平均像素差异。它通过计算每个对应像素的绝对差然后取平均值来计算。SSIM从亮度、对比度和结构方面评估两幅图像的相似性。对于PlantGaussian模型，SSIM通过在局部窗口内比较渲染图像和真实图像来计算。LPIPS使用深度神经网络从图像中提取高级特征以评估感知差异。在本研究中，选择VGG网络作为特征提取器。将渲染图像和真实图像输入预训练网络，并计算其特征表示的差异。对于像Neurangle、Colmap和MVS这样直接生成3D网格的方法，由于缺乏完整的亮度和纹理信息，无法计算SSIM和LPIPS。这些方法专注于几何重建，因此仅计算了它们的PSNR和MAE。

## 3\. 结果

### 3.1. PlantGaussian的时间效率

真实植物可视化的总时间在6到21分钟之间。具体而言：1) 围绕植物的多视角视频录制需要不到90秒；2) 相机姿态估计和稀疏点云初始化，取决于多视角图像场景的复杂性，需要30到300秒；3) 植物前景提取不超过60秒；4) 高斯初始化和渲染涉及7000次训练迭代（约180秒）或30,000次训练迭代（约15分钟）。在获得3D高斯可视化后，提取植物网格所需的时间，取决于植物表面的复杂性，在2到6小时之间。

PlantGaussian目前正处于从高斯点生成网格的探索初期。与可视化过程相比，生成植物网格要耗时得多。即便如此，在确保准确生成网格的条件下，所需时间是可以接受的，特别是与能够生成相对完整网格的现有模型（如Neurangle（超过8小时）和COLMAP（密集点云重建和泊松重建，3-6小时））相比。因此，PlantGaussian模型在各个阶段的时间效率结果符合预期。

### 3.2. 相机姿态估计的准确性分析

如[图S4](#s0150)所示，相机姿态的可视化与图像捕获过程中智能手机的实际移动路径非常吻合。

对于随机选择的三株植物，相机姿态的定量评估见[表S2](#s0150)。在1080p的视频分辨率下，每张图像的分辨率为1080×1920，基于估计的相机姿态计算的平均重投影误差小于一个像素。所有植物生成的稀疏点云包含超过20,000个点，每个点平均在5张图像中被观察到。平均重投影误差计算为0.799。这些结果表明，相机姿态估计有效地生成了高质量的稀疏点云，满足后续模型计算的精度要求。

### 3.3. 植物的3D高斯渲染

3D数字植物的可视化结果在生长的各个阶段和不同地点都显示出良好的效果。本研究展示了玉米、小麦和烟草的独特可视化结果，并计算了MAE、PSNR、SSIM和LPIPS值。与原始的3D高斯泼溅技术相比，PlantGaussian取得了显著改进，展示了比之前应用于植物可视化的其他算法的显著提升。

#### 3.3.1. PlantGaussian与原始3D高斯的比较

原始3D高斯泼溅与我们的PlantGaussian在玉米、烟草和小麦上的比较见[图3](#f0015)。从3D可视化效果的角度来看，我们的PlantGaussian具有三个主要优势。首先，保留了植物模型，同时去除了所有背景，使育种者能够不受任何背景干扰地观察植物对象。3D高斯模型中仅包含植物前景也便于后续的斑块提取和植物表型计算。其次，我们的方法消除了植物附近高斯点周围的许多伪影，确保植物观察不再受到随机生成的高斯点的干扰。第三，目标植物的细节可视化得到了进一步细化，能够更清晰地观察植物的生长状况。然而，PlantGaussian仍然表现出一些基于高斯的模型常见的局限性，这将在后续部分进一步讨论。

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3.jpg)

1.  [下载：下载高分辨率图像 (507KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3_lrg.jpg "下载高分辨率图像 (507KB)")
2.  [下载：下载全尺寸图像](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3.jpg "下载全尺寸图像")

图3. 原始3D高斯与PlantGaussian在四种植物上的比较。选择了四种植物进行比较，分为盆栽和田间条件，共产生八组图像数据。在大多数情况下，我们的PlantGaussian方法显著优于未经处理的3D高斯，提供了更清晰的渲染和更好的植物可视化。

为了定量分析我们的方法相比原始3D高斯泼溅的改进，我们计算了三种植物在7000次和30,000次训练迭代后的损失、MAE和PSNR，如[表1](#t0005)、[表2](#t0010)所示。在这些表格中，表示更好性能的值用较深的阴影突出显示，而较浅的阴影表示较差性能。结果表明，我们的PlantGaussian在各种植物上表现出色。然而，玉米的PSNR值略低于原始高斯模型，这可能是由于建模过程中植物基部附近的分割问题，导致3D模型中的轻微遗漏。对于小麦，在7000次迭代时PSNR值略低于原始高斯，但在30,000次迭代时超过了原始3D高斯。所有植物的MAE值都比原始高斯有所改善，所有PSNR值都超过25。这些发现证实，PlantGaussian方法在各种植物的整体性能上优于原始的3D高斯泼溅技术。

表1. 三种植物在7000次和30,000次迭代时的结果

| 植物 | 玉米 |     |     | 烟草 |     |     | 小麦 |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 方法 \| 指标 | 损失 | MAE | PSNR | 损失 | MAE | PSNR | 损失 | MAE | PSNR |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 3D高斯-7000次迭代 | 0.031 | 0.021 | 29.93 | 0.208 | 0.097 | 17.57 | 0.0382 | 0.0139 | 32.83 |
| PlantGaussian-7000次迭代 | 0.018 | 0.009 | 28.44 | 0.043 | 0.021 | 26.47 | 0.0063 | 0.0034 | 31.49 |
| 3D高斯-30,000次迭代 | 0.025 | 0.015 | 32.99 | 0.115 | 0.062 | 20.84 | 0.0325 | 0.0113 | 34.53 |
| PlantGaussian-30,000次迭代 | 0.016 | 0.008 | 29.74 | 0.014 | 0.013 | 29.49 | 0.0078 | 0.0028 | 37.73 |

表2. 四株烟草植物的模型计算值与人工测量值对比

| 项目 | 烟草1 |     | 烟草2 |     | 烟草3 |     | 烟草4 |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 计算值 | 人工测量值 | 计算值 | 人工测量值 | 计算值 | 人工测量值 | 计算值 | 人工测量值 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 比例因子 | 0.05 | /   | 0.05 | /   | 0.05 | /   | 0.07 | /   |
| 株高 | 8.89 | 8.49 | 6.15 | 5.77 | 7.05 | 7.38 | 6.78 | 7.38 |
| 最大叶长 | 16.83 | 16.17 | 11.51 | 11.43 | 18.18 | 18.31 | 17.78 | 18.74 |

注：比例因子指点云尺度与实际尺度的比值，与相机焦距相关。

#### 3.3.2. 不同场景下植物的对比可视化

为了评估PlantGaussian模型在不同地点的性能，我们使用相同的环境和原始图像序列，分别用PlantGaussian、Instant-NGP、COLMAP、NeRF和OpenMVS方法进行建模。可视化结果见[图4](#f0020)。结果表明，原始NeRF模型的性能明显不如Instant-NGP方法，而OpenMVS的结果也远不如COLMAP。因此，我们省略了NeRF和OpenMVS的可视化结果，仅包含它们的定量评估。本节评估了玉米和小麦在3个地点的表现，考虑了背景环境、植物位置和室外风的影响。烟草在不同环境中的建模结果将在下一节中评估。

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4.jpg)

1.  [下载：下载高分辨率图像 (653KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4_lrg.jpg "下载高分辨率图像 (653KB)")
2.  [下载：下载全尺寸图像](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4.jpg "下载全尺寸图像")

图4. 三种植物在三个场景下使用三种模型的3D建模结果。从三种模型的比较来看，我们的PlantGaussian方法在视觉清晰度上始终优于其他方法。对于所有模型，田间实验的可视化质量明显低于室内或室外盆栽条件。

对于玉米，我们评估了三种栽培环境：室外盆栽、室内盆栽和室外田间条件。在室外盆栽场景中，由于盆栽大小和根系深度的限制，玉米植株在自然风条件下容易摇摆。这种运动导致使用传统摄影测量方法（如COLMAP）时出现明显的模糊和数据缺失，因为COLMAP严重依赖特征点匹配进行点云估计。虽然Instant-NGP提供了相对完整的玉米表面建模，但细节仍然模糊且几乎无法观察。植物运动同样影响了我们的PlantGaussian方法，在玉米表面引入了一些伪影和遮挡，但整体植物形态和细节仍然得到了很好的捕捉。

对于室内玉米，种植在办公区域，图像采集过程中背景的人类活动导致Instant-NGP和COLMAP模型出现大量数据缺失。相比之下，3D PlantGaussian方法有效地建模了目标植物。对于在田间条件下生长的玉米，所有三种方法都成功建模了植物，但我们的PlantGaussian方法的可视化效果最佳。然而，当田间植物密集种植时，我们的方法偶尔会重建相邻的植物。这不会干扰观察，并且可以在网格化过程中轻松纠正。

对于小麦，我们评估了两种栽培环境：室外盆栽和室内条件。在室外盆栽环境中，所有三种方法都能够全面建模植物。PlantGaussian方法和Instant-NGP都提供了良好的小麦可视化效果，而COLMAP的结果较差。然而，我们的PlantGaussian方法没有重建下部的干枯分支，这使得Instant-NGP在这方面略胜一筹。尽管如此，两种建模方法都满足可视化观察的要求。室内成熟小麦的建模，特别是穗部，极具挑战性。COLMAP完全无法建模小麦穗，而Instant-NGP也难以清晰地可视化它们。相比之下，PlantGaussian方法有效地捕捉了小麦穗，相比其他技术有了显著改进。

PlantGaussian方法在不同地点可视化各种植物的一个主要优势是能够消除杂乱的背景，使植物能够清晰地显示。这种能力确保了育种者可以在没有背景干扰的情况下观察植物特征。此外，该方法通过在建模后排除不相关的背景细节，缓解了隐私问题。

为了定量评估各种模型的性能，我们计算了五种植物模型的损失、平均绝对误差（MAE）和峰值信噪比（PSNR），如[表S3](#s0150)所示。需要注意的是，由于模型计算损失的方法不同，这些结果不能直接比较，仅供参考。COLMAP和OpenMVS不是基于深度学习技术，因此不报告损失值。结果表明，我们的PlantGaussian方法在各种环境中表现良好，能够在不同环境中提供详细的3D模型。

#### 3.3.3. 植物四个生长阶段的对比可视化

选择了盆栽和田间生长的植物，在三种模型下进行可视化评估，并在五种模型下进行定量评估。可视化评估的结果见[图5](#f0025)。烟草因其快速生长周期和典型的叶片特征，被选为代表植物，用于评估4个生长阶段的3D植物可视化。

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5.jpg)

1.  [下载：下载高分辨率图像 (811KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5_lrg.jpg "下载高分辨率图像 (811KB)")
2.  [下载：下载全尺寸图像](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5.jpg "下载全尺寸图像")

图5. 烟草在三个模型下不同时间的3D建模结果。前四组代表室外场景中的盆栽烟草，后四组描绘田间场景中的烟草。

盆栽植物在2024年监测了4天以收集和分析生长阶段。截至7月4日，当烟草生长缓慢时，3D建模方法相对简单，所有三种方法都能有效地可视化植物。然而，Colmap模型在植物边缘显示出模糊。到7月26日，随着烟草植株长高和分枝增多，Instant-NGP和Colmap方法未能准确表示烟草的形态。相比之下，PlantGaussian方法继续精确捕捉植物的三维结构。

田间生长的植物在2023年监测了四天以进行收集和分析，由于光照和风条件的自然变化，建模面临挑战。在快速生长期，叶片的遮挡带来了显著问题。如[图5](#f0025)所示，尽管由于照片质量问题，6月17日和6月21日的烟草边缘有些模糊，但PlantGaussian方法清晰地显示了烟草叶片的纹理。然而，Instant-NGP和Colmap方法在除6月17日外的所有日期都产生了较差的建模结果。7月4日，当烟草受到害虫侵害，导致叶片表面出现许多孔洞时，PlantGaussian方法清晰地揭示了每个穿孔，使得害虫损害分析更加容易。相比之下，Instant-NGP和Colmap方法难以区分受损区域。

对田间作物各个生长阶段的建模——或实现植物数字化的"跨时间"——仍然是一个漫长且容易出错的过程。光照条件、摄影质量、植物遮挡和害虫损害等各种因素都会影响建模结果。然而，结果表明，我们的PlantGaussian方法显著减轻了这些干扰，在各种条件下始终提供可靠的观察结果。此外，摄影师不需要详细的农业专业知识；只需简单的培训和围绕植物拍摄照片的常规操作，然后将照片上传到数据库即可。从这些带有时间戳的照片中，可以生成植物每个生长阶段的数字模型，便于育种专家进行针对性分析。

同样，我们计算了上述植物物种模型的损失、平均绝对误差（MAE）和峰值信噪比（PSNR），如[表S4](#s0150)所示。结果表明，在田间和盆栽条件下，PlantGaussian在所有数据集上的PSNR均大于20，MAE均低于0.1。因此，我们的PlantGaussian方法在时间上表现出色，能够在各个阶段获取详细的PlantGaussian模型。

### 3.4. 植物前景分割

使用改进的Track Anything模型，可以在任何环境中实现大多数植物的精确前景分割。[图S5](#s0150)展示了该模型在复杂室内背景（有人走动）下对目标植物前景的精确分割。为了展示多尺度融合对Track Anything模型的改进效果，[图S6](#s0150)展示了改进前后的结果对比。结果证实，增强后的模型在完整分割植物所有部分方面表现更好，特别是在某些区域颜色和纹理与其他部分差异显著的情况下。

为了比较改进方法对PlantGaussian模型植物可视化的影响，对原始输入和改进输入都进行了3D高斯泼溅处理。结果如[图S8](#s0150)所示。对于具有多样化叶片分布和方向的玉米作物，采用多尺度输入的PlantGaussian方法获得了与原始视图几乎相同的可视化结果。相比之下，当使用未优化的分割方法作为输入时，由于单个叶片分割不完整导致的错配，在植物周围产生了伪影，并在某些叶片区域出现了错位。这些发现表明，改进的植物前景分割方法显著提高了具有复杂或重叠结构植物的3D可视化质量。

### 3.5. 可测量植物网格表面评估

为了评估PlantGaussian模型在农业测量中的可靠性，选择了四株烟草植物进行表面网格提取，如[图S7](#s0150)所示。尽管网格结果的视觉质量不如渲染输出精细，但充分捕捉了植物的表面形态，没有观察到表面孔洞。这证实了网格结果适合用于植物形态测量。我们进一步将人工测量的两个性状（株高和叶长）与PlantGaussian模型计算的值进行了比较，详见[表2](#t0010)。四株植物的计算株高与测量株高的相对误差分别为4%、6%、4%和8%。同样，叶长的相对误差分别为4%、1%、1%和5%。所有测量的平均相对误差为4%。由于人工测量株高的变异性较小，更能代表植物的真实值，因此计算了人工测量株高与模型计算值之间的Pearson相关系数，结果为0.86。这表明计算值与人工测量值之间存在强正相关关系。这些结果证明，从视觉输出中导出的网格表面足以满足所需的测量精度。

## 4. 讨论

### 4.1. 首批应用于植物的3D高斯泼溅技术之一

3D高斯泼溅技术的最新进展代表了三维重建领域的重大突破，并在工业应用中取得了显著成功。然而，在农业领域，即使是先前的技术如神经辐射场（NeRF）也仅有有限的研究。尽管这些方法具有广阔的应用前景，但它们在农业中的应用仍未被充分探索，这表明这是一个需要进一步研究的关键领域。

三维可视化植物的能力可以革新农业科学的多个方面，特别是在为表型研究提供全面数据方面。一个实际应用是促进远程专家咨询。通过利用详细的3D可视化，专家可以在不需要亲自到场的情况下，对植物健康状况、生长条件和疾病表现进行远程诊断和评估。如[图S9](#s0150)所示，PlantGaussian方法清晰地捕捉到了大豆叶片颜色和表面穿孔，这是大多数模型无法达到的细节水平。这种能力不仅提高了表型分析的准确性，还扩展了预防性护理和定制治疗策略的可能性。

虽然现在可以实现植物的逼真可视化，但比例因子问题仍然是一个持续的挑战。在本研究中，对于盆栽植物，使用花盆的最大直径进行校准。对于大田作物，使用具有固定长度的物体（如田埂）作为校准参考。在野外场景中，我们建议携带一个小型校准物体（例如棋盘图案），在初始相机姿态估计过程中作为参考。

### 4.2. 基于前景保留的精细化3D植物建模

在3D建模中，3D植物的分割一直是一个不可避免的挑战。许多现有模型都基于特定植物的点云数据进行训练，依赖于特定物种。这些主要基于3D CNN的方法通常只能满足简单的测量需求，无法准确分割出可详细可视化的3D植物模型。许多研究不得不采用费时的手动分割方法，需要仔细绘制植物3D形态的每一条边界线，这一耗时过程还面临着背景与植物粘连的问题。通过从每张输入图像中精确提取植物轮廓来直接重建数字3D植物提供了一种捷径。然而，手动分割每张图像的工作量与直接进行点云分割相当。

本研究引入了一种基于Track Anything模型的方法，结合了Segment Anything模型和XMem，仅需少量手动点即可精确分割每张图像的轮廓。在相机姿态计算阶段使用带背景的图像，而在高斯初始化阶段则使用前景图像来过滤多余的高斯点，从而仅保留植物前景进行精细化3D建模。通过将前景提取融入3D高斯泼溅的初始化阶段，该方法成功解决了目标模型3D建模中的分割难题，实现了跨时间、跨场景的数字3D植物建立。

尽管本研究在跨场景、跨发育阶段的植物3D建模（称为"跨时间"和"跨场景"）方面做出了努力，但并非所有场景都能轻易获得高质量的自动化3D可视化。如[第3节](#s0070)所示，大田作物的重建质量低于盆栽植物。更复杂的是，叶片重叠和遮挡的密集大田作物在获取单个植物3D可视化方面面临重大挑战。我们鼓励未来研究者从图像处理或3D高斯点的角度探索更复杂的大田场景，以实现单个植物的提取。

### 4.3. 网格提取为定量测量提供更多机会

虽然本研究的重点是实现逼真的三维植物可视化渲染，但我们认识到单纯的3D渲染在实际农业生产中的应用有限。因此，我们致力于开发将3D可视化结果转化为可测量3D点的方法。得益于Antonie及其同事在SuGaR[\[41\]](#b0205)方面的工作，这一概念已成为现实。他们发现，通过3D高斯泼溅优化后，高斯分布并不有序，也无法很好地对应场景的实际表面。为了克服这一限制，他们重新训练了模型，并提出了一种从3D高斯结果中提取精确网格部分的方法。使用SuGaR方法，我们成功提取了精确的植物网格，研究人员可以直接测量株高和体积等性状，或用于构建新模型以进行叶片分割和植物特征分析等详细的点云处理。然而，当前的重新训练方法仍面临以下挑战：1) 生成可测量网格所需的时间与逼真可视化相比过长；2) 对于小麦穗等具有精细表面细节的植物，重建精度仍然不足；3) 生成的网格包含过多片段，导致文件体积庞大，存储需求显著。

值得一提的是，虽然已经从植物渲染结果中提取了可测量的网格部分，以通过传统点云处理促进后续计算，但我们强烈鼓励进一步探索3D高斯方法。我们认为，3D高斯的表示作为一种结合传统渲染方法的高效新场景表示形式，其显式功能表示（与NeRF的隐式神经网络相对）尤为重要，足以引发三维表型测量领域的革命。我们还进行了探索，使3D高斯表示能够方便地导入Unity等常用软件中，通过相应插件进行进一步编辑，如[图S10](#s0150)所示。我们期待出现更多适合特定植物场景的3D高斯表示方法，逐步取代传统的网格提取技术。

## 5. 结论

本研究探索了一种基于3D高斯的跨场景、跨时间的植物3D重建方法，称为PlantGaussian。该方法能够有效渲染所有植物的表面形态，大多数植物模型的PSNR超过25。在PSNR和MAE方面，PlantGaussian模型优于其他方法，包括原始的3D高斯泼溅。3D表面网格结果表明，计算值与人工测量值之间的平均相对误差为4%。这些发现证实，PlantGaussian方法能够在不同场景和时间点提供高质量的3D可视化，标志着通用3D数字植物模型开发的重要进展。该方法在扩展植物表型数据库、生态研究和生长阶段远程专家诊断方面具有潜在应用价值。未来的研究可以侧重于进一步量化单个植物可视化的表型特征、增强3D表面网格生成，并将这些发现与基因分型研究相结合，为农业育种计划提供更强有力的支持。

## 作者贡献声明

**沈鹏:** 撰写-审阅和编辑，撰写-初稿，方法论，调查，数据整理，概念化。**景雪瑶:** 撰写-初稿，调查，数据整理。**邓文哲:** 撰写-审阅和编辑，调查，数据整理。**贾涵月:** 撰写-审阅和编辑，调查，数据整理。**吴婷婷:** 撰写-审阅和编辑，验证，监督，资源，项目管理，资金获取，形式分析，概念化。

## 利益冲突声明

作者声明，他们没有已知的可能影响本报告工作的竞争性财务利益或个人关系。

## 致谢

本研究得到中央引导地方科技发展专项资金（[2024ZY-CGZY-19](#gp005)）的支持。作者感谢资助机构提供的财政支持。作者还要特别感谢MetaPheno实验室、PhenoTrait科技有限公司的韩志国博士。在韩博士的指导下，公司自愿提供的帮助对PlantGaussian数据集的开发起到了重要作用。

## 附录 A. 补充数据

下载本文包含的所有补充文件

[这是什么？](https://service.elsevier.com/app/answers/detail/a_id/19286/supporthub/sciencedirect/ "这是什么？(在新窗口打开)")

以下是本文的补充数据：[下载：下载Word文档(48KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-mmc1.docx "下载Word文档(48KB)")

补充数据 1.

[下载：下载Word文档(2MB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-mmc2.docx "下载Word文档(2MB)")

补充数据 2.

推荐文章

## References

1.  [\[1\]](#bb0005)
    
    L.M. Bian, H.C. Zhang, Y.F. Ge, J. Cepl, J. Stejskal, Y.A. El-Kassaby
    
    表型与基因型之间的差距：林业中先进图像表型技术综述
    
    Ann. For. Sci., 79 (2022), p. 22
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85129735612&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Closing%20the%20gap%20between%20phenotyping%20and%20genotyping%3A%20review%20of%20advanced%2C%20image-based%20phenotyping%20technologies%20in%20forestry&publication_year=2022&author=L.M.%20Bian&author=H.C.%20Zhang&author=Y.F.%20Ge&author=J.%20Cepl&author=J.%20Stejskal&author=Y.A.%20El-Kassaby)
    
2.  [\[2\]](#bb0010)
    
    H.M. Schneider
    
    表型可塑性的特征、成本、线索和未来展望
    
    Ann. Bot., 130 (2022), pp. 131-148
    
    [View at publisher](https://ct.prod.getft.io/c2NpZW5jZWRpcmVjdF9jb250ZW50aG9zdGluZyxvdXAsaHR0cHM6Ly9hY2FkZW1pYy5vdXAuY29tL0dldEZ0ckNvbnRlbnQvR2V0UGRmQnlEb2k_ZG9pPTEwLjEwOTMlMmZhb2IlMmZtY2FjMDg3JnJlc291cmNldHlwZT00JnBhcmVudFJlc291cmNlVHlwZUlkPTM.MOuNBF8RTdy4WBSQ6jxGJ_q4XniR2PMvb5biXiSOUTw)
    
    [Crossref](https://doi.org/10.1093/aob/mcac087)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85137160665&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Characterization%2C%20costs%2C%20cues%20and%20future%20perspectives%20of%20phenotypic%20plasticity&publication_year=2022&author=H.M.%20Schneider)
    
3.  [\[3\]](#bb0015)
    
    W.W. Adams III, J.J. Stewart, S.K. Polutchko, C.M. Cohu, O. Muller, B. Demmig-Adams
    
    叶片表型可塑性反映对环境变化的适应
    
    Plants-Basel, 12 (2023), p. 2041
    
    [View at publisher](https://doi.org/10.3390/plants12102041)[Crossref](https://doi.org/10.3390/plants12102041)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85160670359&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Foliar%20phenotypic%20plasticity%20reflects%20adaptation%20to%20environmental%20variability&publication_year=2023&author=W.W.%20Adams%20III&author=J.J.%20Stewart&author=S.K.%20Polutchko&author=C.M.%20Cohu&author=O.%20Muller&author=B.%20Demmig-Adams)
    
4.  [\[4\]](#bb0020)
    
    D. Marion, M. Marianne, H. Andreas, O. Mathias
    
    农艺和表型植物性状作为转基因植物环境风险的指标
    
    Environ. Sci. Eur., 36 (2024), p. 3
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85181402902&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Agronomic%20and%20phenotypic%20plant%20traits%20as%20indicators%20for%20environmental%20risks%20of%20genetically%20modified%20plants&publication_year=2024&author=D.%20Marion&author=M.%20Marianne&author=H.%20Andreas&author=O.%20Mathias)
    
5.  [\[5\]](#bb0025)
    
    S.E. Sultan
    
    植物表型可塑性：生态发育的案例研究
    
    Evol. Dev., 5 (2003), pp. 25-33
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-0037270456&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Phenotypic%20plasticity%20in%20plants%3A%20a%20case%20study%20in%20ecological%20development&publication_year=2003&author=S.E.%20Sultan)
    
6.  [\[6\]](#bb0030)
    
    P.M. Triozzi, J.M. Ramos-Sánchez, T. Hernández-Verdeja, A. Moreno-Cortés, I. Allona, M. Perales
    
    光周期对杨树茎尖生长的调控
    
    Front. Plant Sci., 9 (2018), p. 1030
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85050825910&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Photoperiodic%20regulation%20of%20shoot%20apical%20growth%20in%20poplar&publication_year=2018&author=P.M.%20Triozzi&author=J.M.%20Ramos-S%C3%A1nchez&author=T.%20Hern%C3%A1ndez-Verdeja&author=A.%20Moreno-Cort%C3%A9s&author=I.%20Allona&author=M.%20Perales)
    
7.  [\[7\]](#bb0035)
    
    H. Badouin, J. Gouzy, C.J. Grassa, F. Murat, S.E. Staton, L. Cottret, C. Lelandais-Briere, G.L. Owens, S. Carrère, B. Mayjonade, L. Legrand, N. Gill, N.C. Kane, J.E. Bowers, S. Hubner, A. Bellec, A. Bérard, H. Bergès, N. Blanchet, M.C. Boniface, D. Brunel, O. Catrice, N. Chaidir, C. Claudel, C. Donnadieu, T. Faraut, G. Fievet, N. Helmstetter, M. King, S.J. Knapp, Z. Lai, M.C. Le Paslier, Y. Lippi, L. Lorenzon, J.R. Mandel, G. Marage, G. Marchand, E. Marquand, E. Bret-Mestries, E. Morien, S. Nambeesan, T. Nguyen, P. Pegot-Espagnet, N. Pouilly, F. Raftis, E. Sallet, T. Schiex, J. Thomas, C. Vandecasteele, D. Varès, F. Vear, S. Vautrin, M. Crespi, B. Mangin, J.M. Burke, J. Salse, S. Muños, P. Vincourt, L.H. Rieseberg, N.B. Langlade
    
    向日葵基因组为油代谢、开花和菊类植物进化提供新见解
    
    Nature, 546 (2017), p. 148
    
    [Crossref](https://doi.org/10.1038/nature22380)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85020219786&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=The%20sunflower%20genome%20provides%20insights%20into%20oil%20metabolism%2C%20flowering%20and%20Asterid%20evolution&publication_year=2017&author=H.%20Badouin&author=J.%20Gouzy&author=C.J.%20Grassa&author=F.%20Murat&author=S.E.%20Staton&author=L.%20Cottret&author=C.%20Lelandais-Briere&author=G.L.%20Owens&author=S.%20Carr%C3%A8re&author=B.%20Mayjonade&author=L.%20Legrand&author=N.%20Gill&author=N.C.%20Kane&author=J.E.%20Bowers&author=S.%20Hubner&author=A.%20Bellec&author=A.%20B%C3%A9rard&author=H.%20Berg%C3%A8s&author=N.%20Blanchet&author=M.C.%20Boniface&author=D.%20Brunel&author=O.%20Catrice&author=N.%20Chaidir&author=C.%20Claudel&author=C.%20Donnadieu&author=T.%20Faraut&author=G.%20Fievet&author=N.%20Helmstetter&author=M.%20King&author=S.J.%20Knapp&author=Z.%20Lai&author=M.C.%20Le%20Paslier&author=Y.%20Lippi&author=L.%20Lorenzon&author=J.R.%20Mandel&author=G.%20Marage&author=G.%20Marchand&author=E.%20Marquand&author=E.%20Bret-Mestries&author=E.%20Morien&author=S.%20Nambeesan&author=T.%20Nguyen&author=P.%20Pegot-Espagnet&author=N.%20Pouilly&author=F.%20Raftis&author=E.%20Sallet&author=T.%20Schiex&author=J.%20Thomas&author=C.%20Vandecasteele&author=D.%20Var%C3%A8s&author=F.%20Vear&author=S.%20Vautrin&author=M.%20Crespi&author=B.%20Mangin&author=J.M.%20Burke&author=J.%20Salse&author=S.%20Mu%C3%B1os&author=P.%20Vincourt&author=L.H.%20Rieseberg&author=N.B.%20Langlade)
    
8.  [\[8\]](#bb0040)
    
    L.F. Duan, W.N. Yang, C.L. Huang, Q. Liu
    
    一种基于机器视觉的水稻产量相关性状自动评估新方法
    
    Plant Methods, 7 (2011), p. 44
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-83155191053&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20novel%20machine-vision-based%20facility%20for%20the%20automatic%20evaluation%20of%20yield-related%20traits%20in%20rice&publication_year=2011&author=L.F.%20Duan&author=W.N.%20Yang&author=C.L.%20Huang&author=Q.%20Liu)
    
9.  [\[9\]](#bb0045)
    
    C.L. Huang, W.N. Yang, L.F. Duan, N. Jiang, G.X. Chen, L.Z. Xiong, Q. Liu
    
    基于双摄像头成像的水稻穗长测量系统
    
    Comput. Electron. Agric., 98 (2013), pp. 158-165
    
    [View PDF](/science/article/pii/S0168169913001841/pdfft?md5=1bda3b168902114677cc34d1e40c9adf&pid=1-s2.0-S0168169913001841-main.pdf)[View article](/science/article/pii/S0168169913001841)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84883543453&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Rice%20panicle%20length%20measuring%20system%20based%20on%20dual-camera%20imaging&publication_year=2013&author=C.L.%20Huang&author=W.N.%20Yang&author=L.F.%20Duan&author=N.%20Jiang&author=G.X.%20Chen&author=L.Z.%20Xiong&author=Q.%20Liu)
    
10.  [\[10\]](#bb0050)
    
    C. Igathinathane, L.O. Pordesimo, E.P. Columbus, W.D. Batchelor, S.R. Methuku
    
    使用ImageJ从基本形状参数进行形状识别和颗粒尺寸分布
    
    Comput. Electron. Agric., 63 (2008), pp. 168-182
    
    [View PDF](/science/article/pii/S0168169908000793/pdfft?md5=f20ef9f81970125a540e8c9c7f9efc62&pid=1-s2.0-S0168169908000793-main.pdf)[View article](/science/article/pii/S0168169908000793)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-46849117554&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Shape%20identification%20and%20particles%20size%20distribution%20from%20basic%20shape%20parameters%20using%20ImageJ&publication_year=2008&author=C.%20Igathinathane&author=L.O.%20Pordesimo&author=E.P.%20Columbus&author=W.D.%20Batchelor&author=S.R.%20Methuku)
    
11.  [\[11\]](#bb0055)
    
    T. Tanabata, T. Shibaya, K. Hori, K. Ebana, M. Yano
    
    SmartGrain：通过图像分析测量种子形状的高通量表型软件
    
    Plant Physiol., 160 (2012), pp. 1871-1880
    
    [Crossref](https://doi.org/10.1104/pp.112.205120)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84870835894&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=SmartGrain%3A%20high-throughput%20phenotyping%20software%20for%20measuring%20seed%20shape%20through%20image%20analysis&publication_year=2012&author=T.%20Tanabata&author=T.%20Shibaya&author=K.%20Hori&author=K.%20Ebana&author=M.%20Yano)
    
12.  [\[12\]](#bb0060)
    
    M.S. Akhtar, Z. Zafar, R. Nawaz, M.M. Fraz
    
    解锁植物秘密：植物表型技术中3D成像的系统综述
    
    Comput. Electron. Agric., 222 (2024), Article 109033
    
    [View PDF](/science/article/pii/S0168169924004241/pdfft?md5=6c6aee6181d86e584ffa3de314b1f517&pid=1-s2.0-S0168169924004241-main.pdf)[View article](/science/article/pii/S0168169924004241)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85193431544&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Unlocking%20plant%20secrets%3A%20A%20systematic%20review%20of%203D%20imaging%20in%20plant%20phenotyping%20techniques&publication_year=2024&author=M.S.%20Akhtar&author=Z.%20Zafar&author=R.%20Nawaz&author=M.M.%20Fraz)
    
13.  [\[13\]](#bb0065)
    
    R. Qiu, M. Zhang, Y. He
    
    使用RGB-D相机在拔节期进行玉米株高的田间估算
    
    Crop J., 10 (2022), pp. 1274-1283
    
    [View PDF](/science/article/pii/S2214514122001805/pdfft?md5=91eb20ea7dc97bd8237b41f58d0093a3&pid=1-s2.0-S2214514122001805-main.pdf)[View article](/science/article/pii/S2214514122001805)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85137123762&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Field%20estimation%20of%20maize%20plant%20height%20at%20jointing%20stage%20using%20an%20RGB-D%20camera&publication_year=2022&author=R.%20Qiu&author=M.%20Zhang&author=Y.%20He)
    
14.  [\[14\]](#bb0070)
    
    J.N. Wu, L.R. Xiang, H. You, L. Tang, J.Y. Gai
    
    Plant-Denoising-Net (PDN)：基于密度梯度场学习的植物点云去噪网络
    
    ISPRS J. Photogramm. Remote Sens., 210 (2024), pp. 282-299
    
    [View PDF](/science/article/pii/S0924271624000820/pdfft?md5=ee5aec326eed2e987458ee1695d756c0&pid=1-s2.0-S0924271624000820-main.pdf)[View article](/science/article/pii/S0924271624000820)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Plant-Denoising-Net%20%3A%20A%20plant%20point%20cloud%20denoising%20network%20based%20on%20density%20gradient%20field%20learning&publication_year=2024&author=J.N.%20Wu&author=L.R.%20Xiang&author=H.%20You&author=L.%20Tang&author=J.Y.%20Gai)
    
15.  [\[15\]](#bb0075)
    
    G.X. Sun, X.C. Wang
    
    基于Kinect传感器自标定的温室植物三维点云重建与形态测量方法
    
    Agronomy-Basel, 9 (2019), p. 596
    
    [Crossref](https://doi.org/10.3390/agronomy9100596)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85072811100&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Three-dimensional%20point%20cloud%20reconstruction%20and%20morphology%20measurement%20method%20for%20greenhouse%20plants%20based%20on%20the%20kinect%20sensor%20self-calibration&publication_year=2019&author=G.X.%20Sun&author=X.C.%20Wang)
    
16.  [\[16\]](#bb0080)
    
    D.B. Wang, Z. Song, T. Miao, C. Zhu, X. Yang, T. Yang, Y.C. Zhou, H.B. Den, T.Y. Xu
    
    DFSP：一种基于距离场的玉米茎叶点云快速自动分割管道
    
    Front. Plant Sci., 14 (2023), Article 1109314
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85148363987&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=DFSP%3A%20A%20fast%20and%20automatic%20distance%20field-based%20stem-leaf%20segmentation%20pipeline%20for%20point%20cloud%20of%20maize%20shoot&publication_year=2023&author=D.B.%20Wang&author=Z.%20Song&author=T.%20Miao&author=C.%20Zhu&author=X.%20Yang&author=T.%20Yang&author=Y.C.%20Zhou&author=H.B.%20Den&author=T.Y.%20Xu)
    
17.  [\[17\]](#bb0085)
    
    D.W. Li, Z.Y. Zhou, Y.C. Wei
    
    基于无监督形状感知SOM的植物点云下采样方法
    
    ISPRS J. Photogramm. Remote Sens., 211 (2024), pp. 172-207
    
    [View PDF](/science/article/pii/S0924271624000960/pdfft?md5=cbab6774161414440ef90056e10e133e&pid=1-s2.0-S0924271624000960-main.pdf)[View article](/science/article/pii/S0924271624000960)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85189940738&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Unsupervised%20shape-aware%20SOM%20down-sampling%20for%20plant%20point%20clouds&publication_year=2024&author=D.W.%20Li&author=Z.Y.%20Zhou&author=Y.C.%20Wei)
    
18.  [\[18\]](#bb0090)
    
    D. Wu, L. Yu, J. Ye, R. Zhai, L. Duan, L. Liu, N. Wu, Z. Geng, J. Fu, C. Huang, S. Chen, Q. Liu, W. Yang
    
    Panicle-3D：基于深度学习、轮廓形状和超体素聚类的低成本水稻穗三维建模方法
    
    Crop J., 10 (2022), pp. 1386-1398
    
    [View PDF](/science/article/pii/S2214514122000599/pdfft?md5=98ecbc1a8fb659d69f2390dc4371b768&pid=1-s2.0-S2214514122000599-main.pdf)[View article](/science/article/pii/S2214514122000599)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85127619445&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Panicle-3D%3A%20A%20low-cost%203D-modeling%20method%20for%20rice%20panicles%20based%20on%20deep%20learning%2C%20shape%20from%20silhouette%2C%20and%20supervoxel%20clustering&publication_year=2022&author=D.%20Wu&author=L.%20Yu&author=J.%20Ye&author=R.%20Zhai&author=L.%20Duan&author=L.%20Liu&author=N.%20Wu&author=Z.%20Geng&author=J.%20Fu&author=C.%20Huang&author=S.%20Chen&author=Q.%20Liu&author=W.%20Yang)
    
19.  [\[19\]](#bb0095)
    
    J.L. Feng, M. Saadat, T. Jubery, A. Jignasu, A. Balu, Y.W. Li, L. Attigala, P.S. Schnable, S. Sarka, B. Ganapathysubramanian, A. Krishnamurthy
    
    基于概率体素雕刻的植物三维重建
    
    Comput. Electron. Agric., 213 (2023), Article 108248
    
    [View PDF](/science/article/pii/S0168169923006361/pdfft?md5=f346ee9e148ffcec592610a606dfa0c9&pid=1-s2.0-S0168169923006361-main.pdf)[View article](/science/article/pii/S0168169923006361)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85172703879&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20reconstruction%20of%20plants%20using%20probabilistic%20voxel%20carving&publication_year=2023&author=J.L.%20Feng&author=M.%20Saadat&author=T.%20Jubery&author=A.%20Jignasu&author=A.%20Balu&author=Y.W.%20Li&author=L.%20Attigala&author=P.S.%20Schnable&author=S.%20Sarka&author=B.%20Ganapathysubramanian&author=A.%20Krishnamurthy)
    
20.  [\[20\]](#bb0100)
    
    F. Saeed, S.P. Sun, J. Rodriguez-Sanchez, J. Snider, T.M. Liu, C.Y. Li
    
    基于点体素卷积神经网络的棉花植株部件三维分割与结构特征提取
    
    Plant Methods, 19 (2023), p. 33
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85153064642&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Cotton%20plant%20part%203D%20segmentation%20and%20architectural%20trait%20extraction%20using%20point%20voxel%20convolutional%20neural%20networks&publication_year=2023&author=F.%20Saeed&author=S.P.%20Sun&author=J.%20Rodriguez-Sanchez&author=J.%20Snider&author=T.M.%20Liu&author=C.Y.%20Li)
    
21.  [\[21\]](#bb0105)
    
    D.H. Xie, X.Y. Wang, J.B. Qi, Y.M. Chen, X.H. Mu, W.M. Zhang, G.J. Yan
    
    基于地面LiDAR点云数据的单株树木带叶重建
    
    Remote Sens., 10 (2018), p. 686
    
    [Crossref](https://doi.org/10.3390/rs10050686)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85047524533&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Reconstruction%20of%20single%20tree%20with%20leaves%20based%20on%20terrestrial%20LiDAR%20point%20cloud%20data&publication_year=2018&author=D.H.%20Xie&author=X.Y.%20Wang&author=J.B.%20Qi&author=Y.M.%20Chen&author=X.H.%20Mu&author=W.M.%20Zhang&author=G.J.%20Yan)
    
22.  [\[22\]](#bb0110)
    
    C.X. Zheng, W.L. Wen, X.J. Lu, W.S. Chang, B. Chen, Q. Wu, Z.W. Xiang, X.Y. Guo, C.J. Zhao
    
    基于叶片形态特征和网格变形的三维小麦建模
    
    Agronomy-Basel, 12 (2022), p. 414
    
    [Crossref](https://doi.org/10.3390/agronomy12020414)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85124558652&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Three-dimensional%20wheat%20modelling%20based%20on%20leaf%20morphological%20features%20and%20mesh%20deformation&publication_year=2022&author=C.X.%20Zheng&author=W.L.%20Wen&author=X.J.%20Lu&author=W.S.%20Chang&author=B.%20Chen&author=Q.%20Wu&author=Z.W.%20Xiang&author=X.Y.%20Guo&author=C.J.%20Zhao)
    
23.  [\[23\]](#bb0115)
    
    A. Paproki, X. Sirault, S. Berry, R. Furbank, J. Fripp
    
    基于网格处理的新型植物三维分析技术
    
    BMC Plant Biol., 12 (2012), p. 63
    
    [Crossref](https://doi.org/10.1186/1471-2229-12-63)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84860363173&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20novel%20mesh%20processing%20based%20technique%20for%203D%20plant%20analysis&publication_year=2012&author=A.%20Paproki&author=X.%20Sirault&author=S.%20Berry&author=R.%20Furbank&author=J.%20Fripp)
    
24.  [\[24\]](#bb0120)
    
    Z.H. Ma, D.W. Sun, H.X. Xu, Y.M. Zhu, Y. He, H.Y. Cen
    
    基于飞行时间相机的油菜植株三维点云优化
    
    Sensors, 21 (2021), p. 664
    
    [Crossref](https://doi.org/10.3390/s21020664)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Optimization%20of%203D%20point%20clouds%20of%20oilseed%20rape%20plants%20based%20on%20time-of-flight%20cameras&publication_year=2021&author=Z.H.%20Ma&author=D.W.%20Sun&author=H.X.%20Xu&author=Y.M.%20Zhu&author=Y.%20He&author=H.Y.%20Cen)
    
25.  [\[25\]](#bb0125)
    
    F. Remondino, A. Karami, Z.Y. Yan, G. Mazzacca, S. Rigon, R.J. Qin
    
    基于NeRF的三维重建技术批判性分析
    
    Remote Sens., 15 (2023), p. 3585
    
    [Crossref](https://doi.org/10.3390/rs15143585)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85164707939&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20critical%20analysis%20of%20NeRF-based%203D%20reconstruction&publication_year=2023&author=F.%20Remondino&author=A.%20Karami&author=Z.Y.%20Yan&author=G.%20Mazzacca&author=S.%20Rigon&author=R.J.%20Qin)
    
26.  [\[26\]](#bb0130)
    
    L.L. Zhou, G.X. Wu, Y.B. Zuo, X.Y. Chen, H.L. Hu
    
    基于视觉的三维重建方法综述
    
    Sensors, 24 (2024), p. 2314
    
    [Crossref](https://doi.org/10.3390/s24072314)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85190246292&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20comprehensive%20review%20of%20vision-based%203D%20reconstruction%20methods&publication_year=2024&author=L.L.%20Zhou&author=G.X.%20Wu&author=Y.B.%20Zuo&author=X.Y.%20Chen&author=H.L.%20Hu)
    
27.  [\[27\]](#bb0135)
    
    R.C. Gao, Y. Qi
    
    可微分渲染技术综述：最新进展与挑战
    
    Electronics, 13 (2024), p. 3546
    
    [Crossref](https://doi.org/10.3390/electronics13173546)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85203650826&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20brief%20review%20on%20differentiable%20rendering%3A%20recent%20advances%20and%20challenges&publication_year=2024&author=R.C.%20Gao&author=Y.%20Qi)
    
28.  [\[28\]](#bb0140)
    
    Y.D. Niu, L.M. Liu, F.Y. Huang, S.Y. Huang, S.Y. Chen
    
    基于图像的三维重建技术概述
    
    J. Eur. Opt. Soc.-Rapid Publ., 20 (2024), p. 18
    
    [Crossref](https://doi.org/10.1051/jeos/2024018)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Overview%20of%20image-based%203D%20reconstruction%20technology&publication_year=2024&author=Y.D.%20Niu&author=L.M.%20Liu&author=F.Y.%20Huang&author=S.Y.%20Huang&author=S.Y.%20Chen)
    
29.  [\[29\]](#bb0145)
    
    B. Mildenhall, P.P. Srinivasan, M. Tancik, J.T. Barron, R. Ramamoorthi, R. Ng
    
    NeRF：将场景表示为神经辐射场用于视图合成
    
    Commun. ACM, 65 (2020), pp. 99-106
    
    [Google Scholar](https://scholar.google.com/scholar_lookup?title=NeRF%3A%20representing%20scenes%20as%20Neural%20Radiance%20Fields%20for%20view%20synthesis&publication_year=2020&author=B.%20Mildenhall&author=P.P.%20Srinivasan&author=M.%20Tancik&author=J.T.%20Barron&author=R.%20Ramamoorthi&author=R.%20Ng)
    
30.  [\[30\]](#bb0150)
    
    T. Huang, Y.L. Bian, Z. Niu, M.F. Taha, Y. He, Z.J. Qiu
    
    基于神经距离场的快速三维重建方法用于多视角图像中核桃壳几何参数提取
    
    Comput. Electron. Agric., 224 (2024), Article 109189
    
    [View PDF](/science/article/pii/S0168169924005805/pdfft?md5=6dc229935df95fe61c67416710388351&pid=1-s2.0-S0168169924005805-main.pdf)[View article](/science/article/pii/S0168169924005805)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85197449911&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Fast%20neural%20distance%20field-based%20three-dimensional%20reconstruction%20method%20for%20geometrical%20parameter%20extraction%20of%20walnut%20shell%20from%20multiview%20images&publication_year=2024&author=T.%20Huang&author=Y.L.%20Bian&author=Z.%20Niu&author=M.F.%20Taha&author=Y.%20He&author=Z.J.%20Qiu)
    
31.  [\[31\]](#bb0155)
    
    W. Ying, Y. Pan, Z. Yi, C. Chen, K. Hu, H. Kang, 通过神经辐射场探索温室中的精确3D表型分析, arXiv (2024) arXiv:2403.15981.
    
    [Google Scholar](https://scholar.google.com/scholar?q=W.%20Ying%2C%20Y.%20Pan%2C%20Z.%20Yi%2C%20C.%20Chen%2C%20K.%20Hu%2C%20H.%20Kang%2C%20Exploring%20accurate%203D%20phenotyping%20in%20greenhouse%20through%20neural%20radiance%20fields%2C%20arXiv%20(2024)%20arXiv%3A2403.15981.)
    
32.  [\[32\]](#bb0160)
    
    B. Kerbl, G. Kopanas, T. Leimkühler, G. Drettakis
    
    用于实时辐射场渲染的3D高斯泼溅
    
    ACM Trans. Graphics, 42 (2023), pp. 1-139
    
    [Crossref](https://doi.org/10.1145/3592433)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20Gaussian%20splatting%20for%20real-time%20radiance%20field%20rendering&publication_year=2023&author=B.%20Kerbl&author=G.%20Kopanas&author=T.%20Leimk%C3%BChler&author=G.%20Drettakis)
    
33.  [\[33\]](#bb0165)
    
    B. Fei, J. Xu, R. Zhang, Q. Zhou, W. Yang, Y. He
    
    3D高斯泼溅作为新时代：综述
    
    IEEE Trans. Visual Comput. Graphics, 2024 (2024), pp. 1-20
    
    [Crossref](https://doi.org/10.1109/tvcg.2024.3397828)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85192787520&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20Gaussian%20splatting%20as%20new%20era%3A%20a%20survey&publication_year=2024&author=B.%20Fei&author=J.%20Xu&author=R.%20Zhang&author=Q.%20Zhou&author=W.%20Yang&author=Y.%20He)
    
34.  [\[34\]](#bb0170)
    
    T. Wu, Y.J. Yuan, L.X. Zhang, J. Yang, Y.P. Cao, L.Q. Yan, L. Gao
    
    3D高斯泼溅的最新进展
    
    Comput. Visual Media, 10 (2024), pp. 613-642
    
    [Crossref](https://doi.org/10.1007/s41095-024-0436-y)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85197698005&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Recent%20advances%20in%203D%20Gaussian%20splatting&publication_year=2024&author=T.%20Wu&author=Y.J.%20Yuan&author=L.X.%20Zhang&author=J.%20Yang&author=Y.P.%20Cao&author=L.Q.%20Yan&author=L.%20Gao)
    
35.  [\[35\]](#bb0175)
    
    D.G. Lowe
    
    基于尺度不变关键点的显著图像特征
    
    Int. J. Comput. Vision, 60 (2004), pp. 91-110
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-3042535216&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Distinctive%20image%20features%20from%20scale-invariant%20keypoints&publication_year=2004&author=D.G.%20Lowe)
    
36.  [\[36\]](#bb0180)
    
    M. Muja, D.G. Lowe, 具有自动算法配置的快速近似最近邻搜索, in: Proceedings of the 4th International Conference on Computer Vision Theory and Applications (VISAPP 2009), Vol. 2, INSTICC Press, Lisbon, Portugal, 2009, pp. 331–340.
    
    [Google Scholar](https://scholar.google.com/scholar?q=M.%20Muja%2C%20D.G.%20Lowe%2C%20Fast%20approximate%20nearest%20neighbors%20with%20automatic%20algorithm%20configuration%2C%20in%3A%20Proceedings%20of%20the%204th%20International%20Conference%20on%20Computer%20Vision%20Theory%20and%20Applications%20(VISAPP%202009)%2C%20Vol.%202%2C%20INSTICC%20Press%2C%20Lisbon%2C%20Portugal%2C%202009%2C%20pp.%20331%E2%80%93340.)
    
37.  [\[37\]](#bb0185)
    
    J. Yang, M. Gao, Z. Li, S. Gao, F. Wang, F. Zheng, 追踪万物：Segment Anything 与视频结合, arXiv (2023) arXiv:2304.11968.
    
    [Google Scholar](https://scholar.google.com/scholar?q=J.%20Yang%2C%20M.%20Gao%2C%20Z.%20Li%2C%20S.%20Gao%2C%20F.%20Wang%2C%20F.%20Zheng%2C%20Track%20anything%3A%20segment%20anything%20meets%20videos%2C%20arXiv%20(2023)%20arXiv%3A2304.11968.)
    
38.  [\[38\]](#bb0190)
    
    A. Kirillov, E. Mintun, N. Ravi, H. Mao, C. Rolland, L. Gustafson, T. Xiao, S. Whitehead, A.C. Berg, W.Y. Lo, 分割万物, in: D. Damen, I. Patras, N. Sebe (Eds.), Proceedings of the IEEE/CVF International Conference on Computer Vision (ICCV 2023), IEEE, Paris, France, 2023, pp. 4015–4026.
    
    [Google Scholar](https://scholar.google.com/scholar?q=A.%20Kirillov%2C%20E.%20Mintun%2C%20N.%20Ravi%2C%20H.%20Mao%2C%20C.%20Rolland%2C%20L.%20Gustafson%2C%20T.%20Xiao%2C%20S.%20Whitehead%2C%20A.C.%20Berg%2C%20W.Y.%20Lo%2C%20Segment%20anything%2C%20in%3A%20D.%20Damen%2C%20I.%20Patras%2C%20N.%20Sebe%20(Eds.)%2C%20Proceedings%20of%20the%20IEEE%2FCVF%20International%20Conference%20on%20Computer%20Vision%20(ICCV%202023)%2C%20IEEE%2C%20Paris%2C%20France%2C%202023%2C%20pp.%204015%E2%80%934026.)
    
39.  [\[39\]](#bb0195)
    
    H.K. Cheng, A.G. Schwing, Xmem：基于Atkinson-Shiffrin记忆模型的长期视频目标分割, in: S. Avidan, G. Brostow, M. Cissé, G.M. Farinella, T. Hassner (Eds.), Proceedings of the 17th European Conference on Computer Vision (ECCV 2022), Lecture Notes in Computer Science, Vol. 13688, Springer, Cham, Switzerland, 2022, pp. 640–658.
    
    [Google Scholar](https://scholar.google.com/scholar?q=H.K.%20Cheng%2C%20A.G.%20Schwing%2C%20Xmem%3A%20Long-term%20video%20object%20segmentation%20with%20an%20atkinson-shiffrin%20memory%20model%2C%20in%3A%20S.%20Avidan%2C%20G.%20Brostow%2C%20M.%20Ciss%C3%A9%2C%20G.M.%20Farinella%2C%20T.%20Hassner%20(Eds.)%2C%20Proceedings%20of%20the%2017th%20European%20Conference%20on%20Computer%20Vision%20(ECCV%202022)%2C%20Lecture%20Notes%20in%20Computer%20Science%2C%20Vol.%2013688%2C%20Springer%2C%20Cham%2C%20Switzerland%2C%202022%2C%20pp.%20640%E2%80%93658.)
    
40.  [\[40\]](#bb0200)
    
    P.J. Besl, N.D. McKay, 3D形状配准方法, in: Proceedings of SPIE Conference on Sensor Fusion IV: Control Paradigms and Data Structures, Vol. 1611, SPIE, Boston, MA, USA, 1992, pp. 586–606.
    
    [Google Scholar](https://scholar.google.com/scholar?q=P.J.%20Besl%2C%20N.D.%20McKay%2C%20Method%20for%20registration%20of%203-D%20shapes%2C%20in%3A%20Proceedings%20of%20SPIE%20Conference%20on%20Sensor%20Fusion%20IV%3A%20Control%20Paradigms%20and%20Data%20Structures%2C%20Vol.%201611%2C%20SPIE%2C%20Boston%2C%20MA%2C%20USA%2C%201992%2C%20pp.%20586%E2%80%93606.)
    
41.  [\[41\]](#bb0205)
    
    A. Guédon, V. Lepetit, SuGaR：面向高效3D网格重建和高质量网格渲染的表面对齐高斯泼溅, in: Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR 2024), Seattle, WA, USA, 2024, pp. 5354–5363.
    
    [Google Scholar](https://scholar.google.com/scholar?q=A.%20Gu%C3%A9don%2C%20V.%20Lepetit%2C%20SuGaR%3A%20Surface-aligned%20Gaussian%20Splatting%20for%20efficient%203D%20mesh%20reconstruction%20and%20high-quality%20mesh%20rendering%2C%20in%3A%20Proceedings%20of%20the%20IEEE%2FCVF%20Conference%20on%20Computer%20Vision%20and%20Pattern%20Recognition%20(CVPR%202024)%2C%20Seattle%2C%20WA%2C%20USA%2C%202024%2C%20pp.%205354%E2%80%935363.)
    

## References

1.  [\[1\]](#bb0005)
    
    L.M. Bian, H.C. Zhang, Y.F. Ge, J. Cepl, J. Stejskal, Y.A. El-Kassaby
    
    Closing the gap between phenotyping and genotyping: review of advanced, image-based phenotyping technologies in forestry
    
    Ann. For. Sci., 79 (2022), p. 22
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85129735612&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Closing%20the%20gap%20between%20phenotyping%20and%20genotyping%3A%20review%20of%20advanced%2C%20image-based%20phenotyping%20technologies%20in%20forestry&publication_year=2022&author=L.M.%20Bian&author=H.C.%20Zhang&author=Y.F.%20Ge&author=J.%20Cepl&author=J.%20Stejskal&author=Y.A.%20El-Kassaby)
    
2.  [\[2\]](#bb0010)
    
    H.M. Schneider
    
    Characterization, costs, cues and future perspectives of phenotypic plasticity
    
    Ann. Bot., 130 (2022), pp. 131-148
    
    [View at publisher](https://ct.prod.getft.io/c2NpZW5jZWRpcmVjdF9jb250ZW50aG9zdGluZyxvdXAsaHR0cHM6Ly9hY2FkZW1pYy5vdXAuY29tL0dldEZ0ckNvbnRlbnQvR2V0UGRmQnlEb2k_ZG9pPTEwLjEwOTMlMmZhb2IlMmZtY2FjMDg3JnJlc291cmNldHlwZT00JnBhcmVudFJlc291cmNlVHlwZUlkPTM.MOuNBF8RTdy4WBSQ6jxGJ_q4XniR2PMvb5biXiSOUTw)
    
    [Crossref](https://doi.org/10.1093/aob/mcac087)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85137160665&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Characterization%2C%20costs%2C%20cues%20and%20future%20perspectives%20of%20phenotypic%20plasticity&publication_year=2022&author=H.M.%20Schneider)
    
3.  [\[3\]](#bb0015)
    
    W.W. Adams III, J.J. Stewart, S.K. Polutchko, C.M. Cohu, O. Muller, B. Demmig-Adams
    
    Foliar phenotypic plasticity reflects adaptation to environmental variability
    
    Plants-Basel, 12 (2023), p. 2041
    
    [View at publisher](https://doi.org/10.3390/plants12102041)[Crossref](https://doi.org/10.3390/plants12102041)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85160670359&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Foliar%20phenotypic%20plasticity%20reflects%20adaptation%20to%20environmental%20variability&publication_year=2023&author=W.W.%20Adams%20III&author=J.J.%20Stewart&author=S.K.%20Polutchko&author=C.M.%20Cohu&author=O.%20Muller&author=B.%20Demmig-Adams)
    
4.  [\[4\]](#bb0020)
    
    D. Marion, M. Marianne, H. Andreas, O. Mathias
    
    Agronomic and phenotypic plant traits as indicators for environmental risks of genetically modified plants
    
    Environ. Sci. Eur., 36 (2024), p. 3
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85181402902&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Agronomic%20and%20phenotypic%20plant%20traits%20as%20indicators%20for%20environmental%20risks%20of%20genetically%20modified%20plants&publication_year=2024&author=D.%20Marion&author=M.%20Marianne&author=H.%20Andreas&author=O.%20Mathias)
    
5.  [\[5\]](#bb0025)
    
    S.E. Sultan
    
    Phenotypic plasticity in plants: a case study in ecological development
    
    Evol. Dev., 5 (2003), pp. 25-33
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-0037270456&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Phenotypic%20plasticity%20in%20plants%3A%20a%20case%20study%20in%20ecological%20development&publication_year=2003&author=S.E.%20Sultan)
    
6.  [\[6\]](#bb0030)
    
    P.M. Triozzi, J.M. Ramos-Sánchez, T. Hernández-Verdeja, A. Moreno-Cortés, I. Allona, M. Perales
    
    Photoperiodic regulation of shoot apical growth in poplar
    
    Front. Plant Sci., 9 (2018), p. 1030
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85050825910&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Photoperiodic%20regulation%20of%20shoot%20apical%20growth%20in%20poplar&publication_year=2018&author=P.M.%20Triozzi&author=J.M.%20Ramos-S%C3%A1nchez&author=T.%20Hern%C3%A1ndez-Verdeja&author=A.%20Moreno-Cort%C3%A9s&author=I.%20Allona&author=M.%20Perales)
    
7.  [\[7\]](#bb0035)
    
    H. Badouin, J. Gouzy, C.J. Grassa, F. Murat, S.E. Staton, L. Cottret, C. Lelandais-Briere, G.L. Owens, S. Carrère, B. Mayjonade, L. Legrand, N. Gill, N.C. Kane, J.E. Bowers, S. Hubner, A. Bellec, A. Bérard, H. Bergès, N. Blanchet, M.C. Boniface, D. Brunel, O. Catrice, N. Chaidir, C. Claudel, C. Donnadieu, T. Faraut, G. Fievet, N. Helmstetter, M. King, S.J. Knapp, Z. Lai, M.C. Le Paslier, Y. Lippi, L. Lorenzon, J.R. Mandel, G. Marage, G. Marchand, E. Marquand, E. Bret-Mestries, E. Morien, S. Nambeesan, T. Nguyen, P. Pegot-Espagnet, N. Pouilly, F. Raftis, E. Sallet, T. Schiex, J. Thomas, C. Vandecasteele, D. Varès, F. Vear, S. Vautrin, M. Crespi, B. Mangin, J.M. Burke, J. Salse, S. Muños, P. Vincourt, L.H. Rieseberg, N.B. Langlade
    
    The sunflower genome provides insights into oil metabolism, flowering and Asterid evolution
    
    Nature, 546 (2017), p. 148
    
    [Crossref](https://doi.org/10.1038/nature22380)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85020219786&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=The%20sunflower%20genome%20provides%20insights%20into%20oil%20metabolism%2C%20flowering%20and%20Asterid%20evolution&publication_year=2017&author=H.%20Badouin&author=J.%20Gouzy&author=C.J.%20Grassa&author=F.%20Murat&author=S.E.%20Staton&author=L.%20Cottret&author=C.%20Lelandais-Briere&author=G.L.%20Owens&author=S.%20Carr%C3%A8re&author=B.%20Mayjonade&author=L.%20Legrand&author=N.%20Gill&author=N.C.%20Kane&author=J.E.%20Bowers&author=S.%20Hubner&author=A.%20Bellec&author=A.%20B%C3%A9rard&author=H.%20Berg%C3%A8s&author=N.%20Blanchet&author=M.C.%20Boniface&author=D.%20Brunel&author=O.%20Catrice&author=N.%20Chaidir&author=C.%20Claudel&author=C.%20Donnadieu&author=T.%20Faraut&author=G.%20Fievet&author=N.%20Helmstetter&author=M.%20King&author=S.J.%20Knapp&author=Z.%20Lai&author=M.C.%20Le%20Paslier&author=Y.%20Lippi&author=L.%20Lorenzon&author=J.R.%20Mandel&author=G.%20Marage&author=G.%20Marchand&author=E.%20Marquand&author=E.%20Bret-Mestries&author=E.%20Morien&author=S.%20Nambeesan&author=T.%20Nguyen&author=P.%20Pegot-Espagnet&author=N.%20Pouilly&author=F.%20Raftis&author=E.%20Sallet&author=T.%20Schiex&author=J.%20Thomas&author=C.%20Vandecasteele&author=D.%20Var%C3%A8s&author=F.%20Vear&author=S.%20Vautrin&author=M.%20Crespi&author=B.%20Mangin&author=J.M.%20Burke&author=J.%20Salse&author=S.%20Mu%C3%B1os&author=P.%20Vincourt&author=L.H.%20Rieseberg&author=N.B.%20Langlade)
    
8.  [\[8\]](#bb0040)
    
    L.F. Duan, W.N. Yang, C.L. Huang, Q. Liu
    
    A novel machine-vision-based facility for the automatic evaluation of yield-related traits in rice
    
    Plant Methods, 7 (2011), p. 44
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-83155191053&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20novel%20machine-vision-based%20facility%20for%20the%20automatic%20evaluation%20of%20yield-related%20traits%20in%20rice&publication_year=2011&author=L.F.%20Duan&author=W.N.%20Yang&author=C.L.%20Huang&author=Q.%20Liu)
    
9.  [\[9\]](#bb0045)
    
    C.L. Huang, W.N. Yang, L.F. Duan, N. Jiang, G.X. Chen, L.Z. Xiong, Q. Liu
    
    Rice panicle length measuring system based on dual-camera imaging
    
    Comput. Electron. Agric., 98 (2013), pp. 158-165
    
    [View PDF](/science/article/pii/S0168169913001841/pdfft?md5=1bda3b168902114677cc34d1e40c9adf&pid=1-s2.0-S0168169913001841-main.pdf)[View article](/science/article/pii/S0168169913001841)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84883543453&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Rice%20panicle%20length%20measuring%20system%20based%20on%20dual-camera%20imaging&publication_year=2013&author=C.L.%20Huang&author=W.N.%20Yang&author=L.F.%20Duan&author=N.%20Jiang&author=G.X.%20Chen&author=L.Z.%20Xiong&author=Q.%20Liu)
    
10.  [\[10\]](#bb0050)
    
    C. Igathinathane, L.O. Pordesimo, E.P. Columbus, W.D. Batchelor, S.R. Methuku
    
    Shape identification and particles size distribution from basic shape parameters using ImageJ
    
    Comput. Electron. Agric., 63 (2008), pp. 168-182
    
    [View PDF](/science/article/pii/S0168169908000793/pdfft?md5=f20ef9f81970125a540e8c9c7f9efc62&pid=1-s2.0-S0168169908000793-main.pdf)[View article](/science/article/pii/S0168169908000793)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-46849117554&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Shape%20identification%20and%20particles%20size%20distribution%20from%20basic%20shape%20parameters%20using%20ImageJ&publication_year=2008&author=C.%20Igathinathane&author=L.O.%20Pordesimo&author=E.P.%20Columbus&author=W.D.%20Batchelor&author=S.R.%20Methuku)
    
11.  [\[11\]](#bb0055)
    
    T. Tanabata, T. Shibaya, K. Hori, K. Ebana, M. Yano
    
    SmartGrain: high-throughput phenotyping software for measuring seed shape through image analysis
    
    Plant Physiol., 160 (2012), pp. 1871-1880
    
    [Crossref](https://doi.org/10.1104/pp.112.205120)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84870835894&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=SmartGrain%3A%20high-throughput%20phenotyping%20software%20for%20measuring%20seed%20shape%20through%20image%20analysis&publication_year=2012&author=T.%20Tanabata&author=T.%20Shibaya&author=K.%20Hori&author=K.%20Ebana&author=M.%20Yano)
    
12.  [\[12\]](#bb0060)
    
    M.S. Akhtar, Z. Zafar, R. Nawaz, M.M. Fraz
    
    Unlocking plant secrets: A systematic review of 3D imaging in plant phenotyping techniques
    
    Comput. Electron. Agric., 222 (2024), Article 109033
    
    [View PDF](/science/article/pii/S0168169924004241/pdfft?md5=6c6aee6181d86e584ffa3de314b1f517&pid=1-s2.0-S0168169924004241-main.pdf)[View article](/science/article/pii/S0168169924004241)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85193431544&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Unlocking%20plant%20secrets%3A%20A%20systematic%20review%20of%203D%20imaging%20in%20plant%20phenotyping%20techniques&publication_year=2024&author=M.S.%20Akhtar&author=Z.%20Zafar&author=R.%20Nawaz&author=M.M.%20Fraz)
    
13.  [\[13\]](#bb0065)
    
    R. Qiu, M. Zhang, Y. He
    
    Field estimation of maize plant height at jointing stage using an RGB-D camera
    
    Crop J., 10 (2022), pp. 1274-1283
    
    [View PDF](/science/article/pii/S2214514122001805/pdfft?md5=91eb20ea7dc97bd8237b41f58d0093a3&pid=1-s2.0-S2214514122001805-main.pdf)[View article](/science/article/pii/S2214514122001805)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85137123762&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Field%20estimation%20of%20maize%20plant%20height%20at%20jointing%20stage%20using%20an%20RGB-D%20camera&publication_year=2022&author=R.%20Qiu&author=M.%20Zhang&author=Y.%20He)
    
14.  [\[14\]](#bb0070)
    
    J.N. Wu, L.R. Xiang, H. You, L. Tang, J.Y. Gai
    
    Plant-Denoising-Net (PDN): A plant point cloud denoising network based on density gradient field learning
    
    ISPRS J. Photogramm. Remote Sens., 210 (2024), pp. 282-299
    
    [View PDF](/science/article/pii/S0924271624000820/pdfft?md5=ee5aec326eed2e987458ee1695d756c0&pid=1-s2.0-S0924271624000820-main.pdf)[View article](/science/article/pii/S0924271624000820)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Plant-Denoising-Net%20%3A%20A%20plant%20point%20cloud%20denoising%20network%20based%20on%20density%20gradient%20field%20learning&publication_year=2024&author=J.N.%20Wu&author=L.R.%20Xiang&author=H.%20You&author=L.%20Tang&author=J.Y.%20Gai)
    
15.  [\[15\]](#bb0075)
    
    G.X. Sun, X.C. Wang
    
    Three-dimensional point cloud reconstruction and morphology measurement method for greenhouse plants based on the kinect sensor self-calibration
    
    Agronomy-Basel, 9 (2019), p. 596
    
    [Crossref](https://doi.org/10.3390/agronomy9100596)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85072811100&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Three-dimensional%20point%20cloud%20reconstruction%20and%20morphology%20measurement%20method%20for%20greenhouse%20plants%20based%20on%20the%20kinect%20sensor%20self-calibration&publication_year=2019&author=G.X.%20Sun&author=X.C.%20Wang)
    
16.  [\[16\]](#bb0080)
    
    D.B. Wang, Z. Song, T. Miao, C. Zhu, X. Yang, T. Yang, Y.C. Zhou, H.B. Den, T.Y. Xu
    
    DFSP: A fast and automatic distance field-based stem-leaf segmentation pipeline for point cloud of maize shoot
    
    Front. Plant Sci., 14 (2023), Article 1109314
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85148363987&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=DFSP%3A%20A%20fast%20and%20automatic%20distance%20field-based%20stem-leaf%20segmentation%20pipeline%20for%20point%20cloud%20of%20maize%20shoot&publication_year=2023&author=D.B.%20Wang&author=Z.%20Song&author=T.%20Miao&author=C.%20Zhu&author=X.%20Yang&author=T.%20Yang&author=Y.C.%20Zhou&author=H.B.%20Den&author=T.Y.%20Xu)
    
17.  [\[17\]](#bb0085)
    
    D.W. Li, Z.Y. Zhou, Y.C. Wei
    
    Unsupervised shape-aware SOM down-sampling for plant point clouds
    
    ISPRS J. Photogramm. Remote Sens., 211 (2024), pp. 172-207
    
    [View PDF](/science/article/pii/S0924271624000960/pdfft?md5=cbab6774161414440ef90056e10e133e&pid=1-s2.0-S0924271624000960-main.pdf)[View article](/science/article/pii/S0924271624000960)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85189940738&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Unsupervised%20shape-aware%20SOM%20down-sampling%20for%20plant%20point%20clouds&publication_year=2024&author=D.W.%20Li&author=Z.Y.%20Zhou&author=Y.C.%20Wei)
    
18.  [\[18\]](#bb0090)
    
    D. Wu, L. Yu, J. Ye, R. Zhai, L. Duan, L. Liu, N. Wu, Z. Geng, J. Fu, C. Huang, S. Chen, Q. Liu, W. Yang
    
    Panicle-3D: A low-cost 3D-modeling method for rice panicles based on deep learning, shape from silhouette, and supervoxel clustering
    
    Crop J., 10 (2022), pp. 1386-1398
    
    [View PDF](/science/article/pii/S2214514122000599/pdfft?md5=98ecbc1a8fb659d69f2390dc4371b768&pid=1-s2.0-S2214514122000599-main.pdf)[View article](/science/article/pii/S2214514122000599)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85127619445&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Panicle-3D%3A%20A%20low-cost%203D-modeling%20method%20for%20rice%20panicles%20based%20on%20deep%20learning%2C%20shape%20from%20silhouette%2C%20and%20supervoxel%20clustering&publication_year=2022&author=D.%20Wu&author=L.%20Yu&author=J.%20Ye&author=R.%20Zhai&author=L.%20Duan&author=L.%20Liu&author=N.%20Wu&author=Z.%20Geng&author=J.%20Fu&author=C.%20Huang&author=S.%20Chen&author=Q.%20Liu&author=W.%20Yang)
    
19.  [\[19\]](#bb0095)
    
    J.L. Feng, M. Saadat, T. Jubery, A. Jignasu, A. Balu, Y.W. Li, L. Attigala, P.S. Schnable, S. Sarka, B. Ganapathysubramanian, A. Krishnamurthy
    
    3D reconstruction of plants using probabilistic voxel carving
    
    Comput. Electron. Agric., 213 (2023), Article 108248
    
    [View PDF](/science/article/pii/S0168169923006361/pdfft?md5=f346ee9e148ffcec592610a606dfa0c9&pid=1-s2.0-S0168169923006361-main.pdf)[View article](/science/article/pii/S0168169923006361)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85172703879&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20reconstruction%20of%20plants%20using%20probabilistic%20voxel%20carving&publication_year=2023&author=J.L.%20Feng&author=M.%20Saadat&author=T.%20Jubery&author=A.%20Jignasu&author=A.%20Balu&author=Y.W.%20Li&author=L.%20Attigala&author=P.S.%20Schnable&author=S.%20Sarka&author=B.%20Ganapathysubramanian&author=A.%20Krishnamurthy)
    
20.  [\[20\]](#bb0100)
    
    F. Saeed, S.P. Sun, J. Rodriguez-Sanchez, J. Snider, T.M. Liu, C.Y. Li
    
    Cotton plant part 3D segmentation and architectural trait extraction using point voxel convolutional neural networks
    
    Plant Methods, 19 (2023), p. 33
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85153064642&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Cotton%20plant%20part%203D%20segmentation%20and%20architectural%20trait%20extraction%20using%20point%20voxel%20convolutional%20neural%20networks&publication_year=2023&author=F.%20Saeed&author=S.P.%20Sun&author=J.%20Rodriguez-Sanchez&author=J.%20Snider&author=T.M.%20Liu&author=C.Y.%20Li)
    
21.  [\[21\]](#bb0105)
    
    D.H. Xie, X.Y. Wang, J.B. Qi, Y.M. Chen, X.H. Mu, W.M. Zhang, G.J. Yan
    
    Reconstruction of single tree with leaves based on terrestrial LiDAR point cloud data
    
    Remote Sens., 10 (2018), p. 686
    
    [Crossref](https://doi.org/10.3390/rs10050686)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85047524533&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Reconstruction%20of%20single%20tree%20with%20leaves%20based%20on%20terrestrial%20LiDAR%20point%20cloud%20data&publication_year=2018&author=D.H.%20Xie&author=X.Y.%20Wang&author=J.B.%20Qi&author=Y.M.%20Chen&author=X.H.%20Mu&author=W.M.%20Zhang&author=G.J.%20Yan)
    
22.  [\[22\]](#bb0110)
    
    C.X. Zheng, W.L. Wen, X.J. Lu, W.S. Chang, B. Chen, Q. Wu, Z.W. Xiang, X.Y. Guo, C.J. Zhao
    
    Three-dimensional wheat modelling based on leaf morphological features and mesh deformation
    
    Agronomy-Basel, 12 (2022), p. 414
    
    [Crossref](https://doi.org/10.3390/agronomy12020414)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85124558652&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Three-dimensional%20wheat%20modelling%20based%20on%20leaf%20morphological%20features%20and%20mesh%20deformation&publication_year=2022&author=C.X.%20Zheng&author=W.L.%20Wen&author=X.J.%20Lu&author=W.S.%20Chang&author=B.%20Chen&author=Q.%20Wu&author=Z.W.%20Xiang&author=X.Y.%20Guo&author=C.J.%20Zhao)
    
23.  [\[23\]](#bb0115)
    
    A. Paproki, X. Sirault, S. Berry, R. Furbank, J. Fripp
    
    A novel mesh processing based technique for 3D plant analysis
    
    BMC Plant Biol., 12 (2012), p. 63
    
    [Crossref](https://doi.org/10.1186/1471-2229-12-63)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-84860363173&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20novel%20mesh%20processing%20based%20technique%20for%203D%20plant%20analysis&publication_year=2012&author=A.%20Paproki&author=X.%20Sirault&author=S.%20Berry&author=R.%20Furbank&author=J.%20Fripp)
    
24.  [\[24\]](#bb0120)
    
    Z.H. Ma, D.W. Sun, H.X. Xu, Y.M. Zhu, Y. He, H.Y. Cen
    
    Optimization of 3D point clouds of oilseed rape plants based on time-of-flight cameras
    
    Sensors, 21 (2021), p. 664
    
    [Crossref](https://doi.org/10.3390/s21020664)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Optimization%20of%203D%20point%20clouds%20of%20oilseed%20rape%20plants%20based%20on%20time-of-flight%20cameras&publication_year=2021&author=Z.H.%20Ma&author=D.W.%20Sun&author=H.X.%20Xu&author=Y.M.%20Zhu&author=Y.%20He&author=H.Y.%20Cen)
    
25.  [\[25\]](#bb0125)
    
    F. Remondino, A. Karami, Z.Y. Yan, G. Mazzacca, S. Rigon, R.J. Qin
    
    A critical analysis of NeRF-based 3D reconstruction
    
    Remote Sens., 15 (2023), p. 3585
    
    [Crossref](https://doi.org/10.3390/rs15143585)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85164707939&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20critical%20analysis%20of%20NeRF-based%203D%20reconstruction&publication_year=2023&author=F.%20Remondino&author=A.%20Karami&author=Z.Y.%20Yan&author=G.%20Mazzacca&author=S.%20Rigon&author=R.J.%20Qin)
    
26.  [\[26\]](#bb0130)
    
    L.L. Zhou, G.X. Wu, Y.B. Zuo, X.Y. Chen, H.L. Hu
    
    A comprehensive review of vision-based 3D reconstruction methods
    
    Sensors, 24 (2024), p. 2314
    
    [Crossref](https://doi.org/10.3390/s24072314)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85190246292&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20comprehensive%20review%20of%20vision-based%203D%20reconstruction%20methods&publication_year=2024&author=L.L.%20Zhou&author=G.X.%20Wu&author=Y.B.%20Zuo&author=X.Y.%20Chen&author=H.L.%20Hu)
    
27.  [\[27\]](#bb0135)
    
    R.C. Gao, Y. Qi
    
    A brief review on differentiable rendering: recent advances and challenges
    
    Electronics, 13 (2024), p. 3546
    
    [Crossref](https://doi.org/10.3390/electronics13173546)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85203650826&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=A%20brief%20review%20on%20differentiable%20rendering%3A%20recent%20advances%20and%20challenges&publication_year=2024&author=R.C.%20Gao&author=Y.%20Qi)
    
28.  [\[28\]](#bb0140)
    
    Y.D. Niu, L.M. Liu, F.Y. Huang, S.Y. Huang, S.Y. Chen
    
    Overview of image-based 3D reconstruction technology
    
    J. Eur. Opt. Soc.-Rapid Publ., 20 (2024), p. 18
    
    [Crossref](https://doi.org/10.1051/jeos/2024018)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Overview%20of%20image-based%203D%20reconstruction%20technology&publication_year=2024&author=Y.D.%20Niu&author=L.M.%20Liu&author=F.Y.%20Huang&author=S.Y.%20Huang&author=S.Y.%20Chen)
    
29.  [\[29\]](#bb0145)
    
    B. Mildenhall, P.P. Srinivasan, M. Tancik, J.T. Barron, R. Ramamoorthi, R. Ng
    
    NeRF: representing scenes as Neural Radiance Fields for view synthesis
    
    Commun. ACM, 65 (2020), pp. 99-106
    
    [Google Scholar](https://scholar.google.com/scholar_lookup?title=NeRF%3A%20representing%20scenes%20as%20Neural%20Radiance%20Fields%20for%20view%20synthesis&publication_year=2020&author=B.%20Mildenhall&author=P.P.%20Srinivasan&author=M.%20Tancik&author=J.T.%20Barron&author=R.%20Ramamoorthi&author=R.%20Ng)
    
30.  [\[30\]](#bb0150)
    
    T. Huang, Y.L. Bian, Z. Niu, M.F. Taha, Y. He, Z.J. Qiu
    
    Fast neural distance field-based three-dimensional reconstruction method for geometrical parameter extraction of walnut shell from multiview images
    
    Comput. Electron. Agric., 224 (2024), Article 109189
    
    [View PDF](/science/article/pii/S0168169924005805/pdfft?md5=6dc229935df95fe61c67416710388351&pid=1-s2.0-S0168169924005805-main.pdf)[View article](/science/article/pii/S0168169924005805)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85197449911&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Fast%20neural%20distance%20field-based%20three-dimensional%20reconstruction%20method%20for%20geometrical%20parameter%20extraction%20of%20walnut%20shell%20from%20multiview%20images&publication_year=2024&author=T.%20Huang&author=Y.L.%20Bian&author=Z.%20Niu&author=M.F.%20Taha&author=Y.%20He&author=Z.J.%20Qiu)
    
31.  [\[31\]](#bb0155)
    
    W. Ying, Y. Pan, Z. Yi, C. Chen, K. Hu, H. Kang, Exploring accurate 3D phenotyping in greenhouse through neural radiance fields, arXiv (2024) arXiv:2403.15981.
    
    [Google Scholar](https://scholar.google.com/scholar?q=W.%20Ying%2C%20Y.%20Pan%2C%20Z.%20Yi%2C%20C.%20Chen%2C%20K.%20Hu%2C%20H.%20Kang%2C%20Exploring%20accurate%203D%20phenotyping%20in%20greenhouse%20through%20neural%20radiance%20fields%2C%20arXiv%20(2024)%20arXiv%3A2403.15981.)
    
32.  [\[32\]](#bb0160)
    
    B. Kerbl, G. Kopanas, T. Leimkühler, G. Drettakis
    
    3D Gaussian splatting for real-time radiance field rendering
    
    ACM Trans. Graphics, 42 (2023), pp. 1-139
    
    [Crossref](https://doi.org/10.1145/3592433)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20Gaussian%20splatting%20for%20real-time%20radiance%20field%20rendering&publication_year=2023&author=B.%20Kerbl&author=G.%20Kopanas&author=T.%20Leimk%C3%BChler&author=G.%20Drettakis)
    
33.  [\[33\]](#bb0165)
    
    B. Fei, J. Xu, R. Zhang, Q. Zhou, W. Yang, Y. He
    
    3D Gaussian splatting as new era: a survey
    
    IEEE Trans. Visual Comput. Graphics, 2024 (2024), pp. 1-20
    
    [Crossref](https://doi.org/10.1109/tvcg.2024.3397828)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85192787520&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=3D%20Gaussian%20splatting%20as%20new%20era%3A%20a%20survey&publication_year=2024&author=B.%20Fei&author=J.%20Xu&author=R.%20Zhang&author=Q.%20Zhou&author=W.%20Yang&author=Y.%20He)
    
34.  [\[34\]](#bb0170)
    
    T. Wu, Y.J. Yuan, L.X. Zhang, J. Yang, Y.P. Cao, L.Q. Yan, L. Gao
    
    Recent advances in 3D Gaussian splatting
    
    Comput. Visual Media, 10 (2024), pp. 613-642
    
    [Crossref](https://doi.org/10.1007/s41095-024-0436-y)[View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-85197698005&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Recent%20advances%20in%203D%20Gaussian%20splatting&publication_year=2024&author=T.%20Wu&author=Y.J.%20Yuan&author=L.X.%20Zhang&author=J.%20Yang&author=Y.P.%20Cao&author=L.Q.%20Yan&author=L.%20Gao)
    
35.  [\[35\]](#bb0175)
    
    D.G. Lowe
    
    Distinctive image features from scale-invariant keypoints
    
    Int. J. Comput. Vision, 60 (2004), pp. 91-110
    
    [View in Scopus](https://www.scopus.com/inward/record.url?eid=2-s2.0-3042535216&partnerID=10&rel=R3.0.0)[Google Scholar](https://scholar.google.com/scholar_lookup?title=Distinctive%20image%20features%20from%20scale-invariant%20keypoints&publication_year=2004&author=D.G.%20Lowe)
    
36.  [\[36\]](#bb0180)
    
    M. Muja, D.G. Lowe, Fast approximate nearest neighbors with automatic algorithm configuration, in: Proceedings of the 4th International Conference on Computer Vision Theory and Applications (VISAPP 2009), Vol. 2, INSTICC Press, Lisbon, Portugal, 2009, pp. 331–340.
    
    [Google Scholar](https://scholar.google.com/scholar?q=M.%20Muja%2C%20D.G.%20Lowe%2C%20Fast%20approximate%20nearest%20neighbors%20with%20automatic%20algorithm%20configuration%2C%20in%3A%20Proceedings%20of%20the%204th%20International%20Conference%20on%20Computer%20Vision%20Theory%20and%20Applications%20(VISAPP%202009)%2C%20Vol.%202%2C%20INSTICC%20Press%2C%20Lisbon%2C%20Portugal%2C%202009%2C%20pp.%20331%E2%80%93340.)
    
37.  [\[37\]](#bb0185)
    
    J. Yang, M. Gao, Z. Li, S. Gao, F. Wang, F. Zheng, Track anything: segment anything meets videos, arXiv (2023) arXiv:2304.11968.
    
    [Google Scholar](https://scholar.google.com/scholar?q=J.%20Yang%2C%20M.%20Gao%2C%20Z.%20Li%2C%20S.%20Gao%2C%20F.%20Wang%2C%20F.%20Zheng%2C%20Track%20anything%3A%20segment%20anything%20meets%20videos%2C%20arXiv%20(2023)%20arXiv%3A2304.11968.)
    
38.  [\[38\]](#bb0190)
    
    A. Kirillov, E. Mintun, N. Ravi, H. Mao, C. Rolland, L. Gustafson, T. Xiao, S. Whitehead, A.C. Berg, W.Y. Lo, Segment anything, in: D. Damen, I. Patras, N. Sebe (Eds.), Proceedings of the IEEE/CVF International Conference on Computer Vision (ICCV 2023), IEEE, Paris, France, 2023, pp. 4015–4026.
    
    [Google Scholar](https://scholar.google.com/scholar?q=A.%20Kirillov%2C%20E.%20Mintun%2C%20N.%20Ravi%2C%20H.%20Mao%2C%20C.%20Rolland%2C%20L.%20Gustafson%2C%20T.%20Xiao%2C%20S.%20Whitehead%2C%20A.C.%20Berg%2C%20W.Y.%20Lo%2C%20Segment%20anything%2C%20in%3A%20D.%20Damen%2C%20I.%20Patras%2C%20N.%20Sebe%20(Eds.)%2C%20Proceedings%20of%20the%20IEEE%2FCVF%20International%20Conference%20on%20Computer%20Vision%20(ICCV%202023)%2C%20IEEE%2C%20Paris%2C%20France%2C%202023%2C%20pp.%204015%E2%80%934026.)
    
39.  [\[39\]](#bb0195)
    
    H.K. Cheng, A.G. Schwing, Xmem: Long-term video object segmentation with an atkinson-shiffrin memory model, in: S. Avidan, G. Brostow, M. Cissé, G.M. Farinella, T. Hassner (Eds.), Proceedings of the 17th European Conference on Computer Vision (ECCV 2022), Lecture Notes in Computer Science, Vol. 13688, Springer, Cham, Switzerland, 2022, pp. 640–658.
    
    [Google Scholar](https://scholar.google.com/scholar?q=H.K.%20Cheng%2C%20A.G.%20Schwing%2C%20Xmem%3A%20Long-term%20video%20object%20segmentation%20with%20an%20atkinson-shiffrin%20memory%20model%2C%20in%3A%20S.%20Avidan%2C%20G.%20Brostow%2C%20M.%20Ciss%C3%A9%2C%20G.M.%20Farinella%2C%20T.%20Hassner%20(Eds.)%2C%20Proceedings%20of%20the%2017th%20European%20Conference%20on%20Computer%20Vision%20(ECCV%202022)%2C%20Lecture%20Notes%20in%20Computer%20Science%2C%20Vol.%2013688%2C%20Springer%2C%20Cham%2C%20Switzerland%2C%202022%2C%20pp.%20640%E2%80%93658.)
    
40.  [\[40\]](#bb0200)
    
    P.J. Besl, N.D. McKay, Method for registration of 3-D shapes, in: Proceedings of SPIE Conference on Sensor Fusion IV: Control Paradigms and Data Structures, Vol. 1611, SPIE, Boston, MA, USA, 1992, pp. 586–606.
    
    [Google Scholar](https://scholar.google.com/scholar?q=P.J.%20Besl%2C%20N.D.%20McKay%2C%20Method%20for%20registration%20of%203-D%20shapes%2C%20in%3A%20Proceedings%20of%20SPIE%20Conference%20on%20Sensor%20Fusion%20IV%3A%20Control%20Paradigms%20and%20Data%20Structures%2C%20Vol.%201611%2C%20SPIE%2C%20Boston%2C%20MA%2C%20USA%2C%201992%2C%20pp.%20586%E2%80%93606.)
    
41.  [\[41\]](#bb0205)
    
    A. Guédon, V. Lepetit, SuGaR: Surface-aligned Gaussian Splatting for efficient 3D mesh reconstruction and high-quality mesh rendering, in: Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR 2024), Seattle, WA, USA, 2024, pp. 5354–5363.
    
    [Google Scholar](https://scholar.google.com/scholar?q=A.%20Gu%C3%A9don%2C%20V.%20Lepetit%2C%20SuGaR%3A%20Surface-aligned%20Gaussian%20Splatting%20for%20efficient%203D%20mesh%20reconstruction%20and%20high-quality%20mesh%20rendering%2C%20in%3A%20Proceedings%20of%20the%20IEEE%2FCVF%20Conference%20on%20Computer%20Vision%20and%20Pattern%20Recognition%20(CVPR%202024)%2C%20Seattle%2C%20WA%2C%20USA%2C%202024%2C%20pp.%205354%E2%80%935363.) 
