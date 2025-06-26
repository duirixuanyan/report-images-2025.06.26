[![The Crop Journal](https://ars.els-cdn.com/content/image/DKEAI.gif)](/journal/the-crop-journal "Go to The Crop Journal on ScienceDirect")

## [The Crop Journal](/journal/the-crop-journal "Go to The Crop Journal on ScienceDirect")

[Volume 13, Issue 2](/journal/the-crop-journal/vol/13/issue/2 "Go to table of contents for this volume/issue"), April 2025, Pages 607-618

[![The Crop Journal](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125X00039-cov150h.gif)](/journal/the-crop-journal/vol/13/issue/2)

# PlantGaussian: Exploring 3D Gaussian splatting for cross-time, cross-scene, and realistic 3D plant visualization and beyond

Author links open overlay panelPeng Shen a, Xueyao Jing b, Wenzhe Deng b, Hanyue Jia b, Tingting Wu b c

a

College of Information Engineering, Northwest A&F University, Yangling 712100, Shaanxi, China

b

College of Mechanical and Electronic Engineering, Northwest A&F University, Yangling 712100, Shaanxi, China

c

Shaanxi Key Laboratory of Agricultural Information Perception and Intelligent Service, Yangling 712100, Shaanxi, China

Received 14 October 2024, Revised 28 December 2024, Accepted 7 January 2025, Available online 15 February 2025, Version of Record 9 April 2025.

What do these dates mean?

![crossmark-logo](https://crossmark-cdn.crossref.org/widget/v2.0/logos/CROSSMARK_Color_horizontal.svg)

Show less

Outline

Add to Mendeley

Share

Cite

[https://doi.org/10.1016/j.cj.2025.01.011](https://doi.org/10.1016/j.cj.2025.01.011 "Persistent link using digital object identifier")[Get rights and content](https://s100.copyright.com/AppDispatchServlet?publisherName=ELS&contentID=S2214514125000261&orderBeanReset=true)

Under a Creative Commons [license](http://creativecommons.org/licenses/by-nc-nd/4.0/)

Open access

## Abstract

Observing plants across time and diverse scenes is critical in uncovering plant growth patterns. Classic methods often struggle to observe or measure plants against complex backgrounds and at different growth stages. This highlights the need for a universal approach capable of providing realistic plant visualizations across time and scene. Here, we introduce PlantGaussian, an approach for generating realistic three-dimensional (3D) visualization for plants across time and scenes. It marks one of the first applications of 3D Gaussian splatting techniques in plant science, achieving high-quality visualization across species and growth stages. By integrating the Segment Anything Model (SAM) and tracking algorithms, PlantGaussian overcomes the limitations of classic Gaussian reconstruction techniques in complex planting environments. A new mesh partitioning technique is employed to convert Gaussian rendering results into measurable plant meshes, offering a methodology for accurate 3D plant morphology phenotyping. To support this approach, PlantGaussian dataset is developed, which includes images of four crop species captured under multiple conditions and growth stages. Using only plant image sequences as input, it computes high-fidelity plant visualization models and 3D meshes for 3D plant morphological phenotyping. Visualization results indicate that most plant models achieve a Peak Signal-to-Noise Ratio (PSNR) exceeding 25, outperforming all models including the original 3D Gaussian Splatting and enhanced NeRF. The mesh results indicate an average relative error of 4% between the calculated values and the true measurements. As a generic 3D digital plant model, PlantGaussian will support expansion of plant phenotype databases, ecological research, and remote expert consultations.

*   [Previous article in issue](/science/article/pii/S2214514124002563)
*   [Next article in issue](/science/article/pii/S2214514125000224)

## Keywords

Plant 3D reconstruction

Plant phenotyping

3D Gaussians

Realistic plant visualization

## 1\. Introduction

Plants are one of the most diverse and widely distributed life forms on Earth, intricately and variably intertwined with human life. The observation and study of plants have long been a fundamental aspect of scientific inquiry [\[1\]](#b0005). Particularly in the study of plant phenotypes, the act of observing and measuring external forms of plants allows scientists to qualitatively and quantitatively analyze patterns of plant growth, responses to pests and diseases, and other adaptive mechanisms [\[2\]](#b0010), [\[3\]](#b0015), [\[4\]](#b0020). Such an observation is not merely a passive record; it is the beginning of a comprehensive analysis of plant life and an indispensable part of scientific research.

Observations and analyses under diverse environmental and temporal conditions have revealed key insights into plant growth and adaptability. Systematic analyses in different ecological settings demonstrate significant plasticity in plant growth under varying environmental factors [\[5\]](#b0025). The impact of light on the apical growth of poplar trees reveals a direct correlation between daylight duration and growth [\[6\]](#b0030). Investigations show that sunflowers maintain consistent yields even under extreme conditions such as drought [\[7\]](#b0035). However, most such measurements require on-site operations by professionals, and specific measurement techniques are needed for plant species. Additionally, some methods are destructive, complicating the continuous monitoring of plants through various growth stages. Therefore, there calls for a universal method that allows for non-destructive observations and analyses on a diverse range of plant types cross-time and cross-scene.

Advances in digital imaging technology has partially addressed the challenge of observing plants at any time. Image processing techniques are non-contact and non-destructive, typically using two-dimensional images to calculate morphological parameters such as width, length, and area [\[8\]](#b0040), [\[9\]](#b0045), [\[10\]](#b0050), [\[11\]](#b0055). While this kind of approach has somewhat mitigated the constraints imposed by time, it is insufficient to overcome challenges raised by scene. Methods for capturing images can vary across plant species, and a cluttered background can cause interference in various scenes. Extraction of sophisticated morphological traits often requires the reconstruction of exact 3D information of plants [\[12\]](#b0060). It remains a challenge to observe plants cross-scene.

3D reconstruction technology has rapidly compensated for the limitations of 2D imaging in plant visualization and allows for the creation of comprehensive multidimensional geometric models for various plant species through standardized data collection [\[12\]](#b0060). Much research has been conducted on 3D reconstruction methods for various plants, utilizing point clouds [\[13\]](#b0065), [\[14\]](#b0070), [\[15\]](#b0075), [\[16\]](#b0080), [\[17\]](#b0085), voxels [\[18\]](#b0090), [\[19\]](#b0095), [\[20\]](#b0100), [\[21\]](#b0105), and meshes [\[22\]](#b0110), [\[23\]](#b0115), [\[24\]](#b0120). However, these studies often focus on specific types of plants, and the extraction of plant point clouds predominantly relies on manual segmentation or extensive annotation. The development of a universal 3D reconstruction method is urgently needed in the field of plant science, being plant-agnostic and being robust to environmental conditions and growth stages. A fixed protocol is also required for capturing sufficient images around the plants to generate detailed 3D digital models.

In 2020s, some novel 3D reconstruction technologies have paved the way for the creation of universal digital plants [\[25\]](#b0125), [\[26\]](#b0130), [\[27\]](#b0135), [\[28\]](#b0140). Introduced in 2020, the application of Neural Radiance Fields (NeRF) [\[29\]](#b0145) has shown tremendous potential. Initially employed in the botanical field, this technique achieved significant results [\[30\]](#b0150), [\[31\]](#b0155). However, their studies primarily concentrated on simple plant forms, such as vegetables and fruits, and NeRF still faces considerable challenges in producing subtle 3D visualizations of plants throughout different growth stages. Recently, 3D Gaussian Splatting has marked a major breakthrough in 3D reconstruction [\[32\]](#b0160). After short training periods, 3D Gaussian Splatting can render complex scenes in real-time and at a large scale. This method has two advantages: i) Compared to various improved NeRF models, the original 3D Gaussian Splatting model achieves high-precision rendering, surpassing nearly all improved NeRF variants in refined 3D visualization [\[33\]](#b0165), [\[34\]](#b0170); ii) Unlike NeRF's implicit neural rendering, 3D Gaussian Splatting follows an explicit training recipe. The models generated by this method are savable, re-trainable, and editable, promising to replace classic point cloud and triangulation methods. However, since 3D Gaussian Splatting is designed for reconstructing complex large scenes, there are currently few methods for extracting and preserving only the object of interest from the reconstructed results. To our knowledge, there is no reported use of 3D Gaussian Splatting specifically for 3D plant reconstruction.

This study proposes an approach to establish 3D digital plants across time and scenes. The objectives were: 1) to develop a universal 3D reconstruction method capable of creating detailed digital models for a variety of plants; 2) to devise a plant foreground segmentation technique that addresses the challenges of reconstructing only plants in complex scenes; and 3) to explore methods for extracting measurable meshes from the 3D rendering results, advancing the application of 3D visualization technology in plant science.

## 2\. Materials and methods

### 2.1. Plant materials and image acquisition

The study involves image data acquisition of plants in three environments: indoor potted plants, outdoor potted plants, and outdoor fields. Different growth stages of the tobacco crop were collected. The acquisition process consists of two stages: an initial coarse acquisition of the plant surface and a detailed morphological acquisition of different plant parts (e.g., canopy, sides, and bottom). To ensure sensor diversity, images were captured with a variety of smartphone brands.

The plants collected include wheat at different growth stages, tobacco at different growth stages, corn, and some other plants. The performance of tobacco models under both potted and field conditions was evaluated to simulate temporal (“cross-time”) variation. Tobacco in the field was collected from June to July 2023, and analyses were conducted on four growth stages of individual plants. Potted tobacco was similarly captured and analyzed over the same stages from June to July 2024, with all samples collected at Yangling, Shaanxi. Wheat, corn, and soybean models were assessed for performance across diverse environments (“cross-scene”). From August 2023 to May 2024, samples were collected from indoor potted, outdoor potted, and field environments at four locations: Yangling, Shaanxi, China; Sanya, Hainan, China; Shanghai, China; and Adelaide, Australia. A detailed list of the crops collected is provided in [Table S1](#s0150).

To ensure the general applicability of the experiment, four brands of smartphone were used for image acquisition, including iPhone 12, Huawei Mate 60 Pro, Huawei Mate 30, and Redmi K50, with video resolutions below 1080p and frame rates of 30 or 60 Hz. After capturing the plant videos, preprocessing was performed, including video stitching, frame extraction, and removal of blurry images.

### 2.2. Overall experimental design

As shown in [Fig. 1](#f0005), the exploration of 3D digital visualization of plants cross-time and cross-scene is divided into four steps: i) plant image acquisition and background segmentation, ii) camera pose estimation with sparse point cloud reconstruction, iii) digital plant rendering, and iv) mesh extraction. To ensure the methodology is applicable to any plant across time and across scene, an improved Track Anything Model incorporating a multi-scale feature fusion method is employed. Plant image streams from several perspectives are input into the model as prompts to finely segment the full plant foreground. For the pre-segmentation results, structure from motion (a technique that reconstructs 3D structures from multiple 2D images and calculates camera positions) techniques are applied to perform sparse point cloud reconstruction and camera pose estimation, ensuring high accuracy in both the initial point cloud and camera poses. Next, the sparse point cloud, camera poses, and plant foreground images are input into the 3D Gaussian model. A tile-based rasterizer (a method that processes the image in small blocks or “tiles”) is then used to obtain highly realistic 3D digital plants. Finally, to make the generated 3D structures more suitable for precise measurements, an additional refinement process is applied to the 3D Gaussian points, resulting in measurable 3D mesh segments of the plants.

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1.jpg)

1.  [Download: Download high-res image (676KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1_lrg.jpg "Download high-res image (676KB)")
2.  [Download: Download full-size image](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr1.jpg "Download full-size image")

Fig. 1. The workflow of the PlantGaussian model. The model takes videos from various views as input and produces plant visualization and plant surface as output. Initially, sparse reconstruction is performed to obtain sparse points and camera poses. Subsequently, an enhanced Track Anything Model is used to extract the plant foreground. The plant foreground, together with the sparse points and camera poses, is then used to initialize 3D Gaussian points. Based on these initialized 3D Gaussian points, realistic plant visualization is rendered, and plant surface calculations are conducted.

### 2.3. Camera pose estimation and sparse point cloud generation

Camera pose estimation and sparse point cloud generation are crucial steps in 3D Gaussian reconstruction. These steps not only provide the foundation for subsequent dense reconstruction and fine rendering of plant models but also directly influence the quality and accuracy of the reconstructed models. To obtain precise camera parameters and a sparse point cloud of the target plants, the experiment is conducted in four steps: feature extraction, feature point matching, camera pose estimation, and sparse point cloud generation.

First, the Scale-Invariant Feature Transform (SIFT) [\[35\]](#b0175) is used to extract features from all image sequences. SIFT identifies key points across scale spaces, computes their orientations and descriptors, and establishes a robust foundation for subsequent feature point matching.

Next, the extracted feature points are matched using the FLANN (Fast Library for Approximate Nearest Neighbors) [\[36\]](#b0180) method to estimate the camera pose. To ensure accuracy and efficiency, feature point matching is performed pairwise within each of the three groups of image sequences, avoiding cross-group matching. The FLANN method minimizes the Euclidean distance between feature points, identifying the best match by computing distances for all feature point pairs and selecting the smallest one.

Based on the feature matching results, the PnP (Perspective-n-Point) algorithm is used to calculate the camera pose. Using the positions of matching points within a known world coordinate system, the corresponding camera positions for each point are computed accurately by Equation 1.(1)s\[uv1\]\=K\[R|t\]\[XYZ1\],<math><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">s</mi><mfenced open="\[" close="\]" is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">u</mi></mtd></mtr><mtr is="true"><mtd is="true"><mi is="true">v</mi></mtd></mtr><mtr is="true"><mtd is="true"><mn is="true">1</mn></mtd></mtr></mtable></mfenced><mo is="true">=</mo><mi is="true">K</mi><mfenced open="\[" close="\]" is="true"><mrow is="true"><mi is="true">R</mi><mo is="true">|</mo><mi is="true">t</mi></mrow></mfenced><mfenced open="\[" close="\]" is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">X</mi></mtd></mtr><mtr is="true"><mtd is="true"><mi is="true">Y</mi></mtd></mtr><mtr is="true"><mtd is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">Z</mi></mtd></mtr><mtr is="true"><mtd is="true"><mn is="true">1</mn></mtd></mtr></mtable></mtd></mtr></mtable></mfenced><mo is="true">,</mo><mspace is="true"></mspace><mspace is="true"></mspace><mspace is="true"></mspace></mtd></mtr></mtable></math>where (u,v)<math><mtext is="true">(</mtext><mi mathvariant="italic" is="true">u</mi><mo is="true">,</mo><mi mathvariant="italic" is="true">v</mi><mtext is="true">)</mtext></math> denotes a point in the image coordinates, and K<math><mi is="true">K</mi></math> is the camera’s intrinsic matrix. The camera’s orientation and position relative to the world coordinates are given by R<math><mi mathvariant="italic" is="true">R</mi></math> (rotation) and t<math><mi is="true">t</mi></math> (translation). (X,Y,Z)<math><mtext is="true">(</mtext><mi mathvariant="italic" is="true">X</mi><mo is="true">,</mo><mi mathvariant="italic" is="true">Y</mi><mo is="true">,</mo><mi mathvariant="italic" is="true">Z</mi><mtext is="true">)</mtext></math> are coordinates in the world system, and s<math><mi is="true">s</mi></math> is the scale factor. A sparse point cloud of the plant scene is created using triangulation on all matched feature points.

### 2.4. Precise foreground segmentation of plants based on track anything

The PlantGaussian model uses input multi-view plant images as ground truth for calculating the loss, making the extraction of plant foreground images crucial for subsequent training. In field environments, the complex background poses challenges to subsequent visualization rendering and point cloud processing. To address these challenges effectively, the study utilizes an improved Track Anything Model (TAM) [\[37\]](#b0185) combined with the pre-trained Segment Anything Model (SAM) [\[38\]](#b0190) and the XMem [\[39\]](#b0195) video tracking and segmentation algorithm. This approach permits accurate foreground segmentation of plants in continuous image sequences under different scenarios.

#### 2.4.1. Introduction of Track Anything model

The TAM represents an advanced video segmentation model that leverages the Segment Anything Model (SAM), a leading-edge model for image segmentation. This adaptation enhances SAM’s functionality for video applications, enabling interactive tracking and segmentation of objects even in highly complex scenarios. Our methodology involves using videos from three vertical segments of plants—top, middle, and bottom—as inputs. Minimal initial interaction, requiring just a few clicks, results in comprehensive and precise foreground segmentation from multiple angles. The step-by-step algorithmic procedure is depicted in [Fig. S1](#s0150).

Initially, a sequence of plant images extracted through frame sampling from various perspectives is input into the system. The user selects a plant image from a specific viewpoint and manually marks points on the foreground area of the image. These selected points, along with the plant images, are then fed into the Segment Anything Model for processing.

In the SAM model, the segmentation process has three stages: image encoding with Vision Transformer (ViT), prompt decoding, and mask decoding. During the ViT encoding stage, normalized image blocks undergo a multi-head attention mechanism, enabling parallel processing of plant images across diverse representational spaces. The self-attention takes the form(2)Attention(Q,K,V)\= softmax(QKTdk)V,<math><mtable is="true"><mtr is="true"><mtd is="true"><mtext is="true">Attention</mtext><mspace width="0.333333em" is="true"></mspace><mfenced is="true"><mrow is="true"><mi mathvariant="italic" is="true">Q</mi><mtext is="true">,</mtext><mi mathvariant="italic" is="true">K</mi><mtext is="true">,</mtext><mi mathvariant="italic" is="true">V</mi></mrow></mfenced><mspace width="0.333333em" is="true"></mspace><mtext is="true">= softmax</mtext><mfenced is="true"><mfrac is="true"><msup is="true"><mi mathvariant="italic" is="true">QK</mi><mi mathvariant="italic" is="true">T</mi></msup><msqrt is="true"><msub is="true"><mi mathvariant="italic" is="true">d</mi><mtext is="true">k</mtext></msub></msqrt></mfrac></mfenced><mi mathvariant="italic" is="true">V</mi><mo is="true">,</mo></mtd></mtr></mtable></math>where, Q<math><mi is="true">Q</mi></math>, K<math><mi is="true">K</mi></math>, and V<math><mi is="true">V</mi></math> represent the query, key, and value matrices, respectively. dk<math><msub is="true"><mi is="true">d</mi><mtext is="true">k</mtext></msub></math> denotes the dimension of the key vector.

After incorporating the multi-head attention mechanism, a residual connection and a second normalization are performed, followed by linking a multi-layer perceptron (MLP). The MLP consists of two fully connected layers and a ReLU activation function, given by(3)MLPx\=ReLU(W1x+b1)W2+b2,<math><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">MLP</mi><mi is="true">x</mi><mo is="true">=</mo><mtext is="true">Re</mtext><mi is="true">LU</mi><mfenced is="true"><mrow is="true"><msub is="true"><mi is="true">W</mi><mn is="true">1</mn></msub><mi is="true">x</mi><mo is="true">+</mo><msub is="true"><mi is="true">b</mi><mn is="true">1</mn></msub></mrow></mfenced><msub is="true"><mi is="true">W</mi><mn is="true">2</mn></msub><mo is="true">+</mo><msub is="true"><mi is="true">b</mi><mn is="true">2</mn></msub><mo is="true">,</mo></mtd></mtr></mtable></math>The output of the MLP is added to the input prior to the MLP, forming a residual connection to enhance the model’s learning capability across various scales of plant imagery. This procedure repeats to execute feature extraction to form image embeddings.

Following the ViT encoding stage, the prompt decoding stage processes user prompts, points selected by the user are introduced to positional encoding. This component facilitates the model’s comprehension of the spatial characteristics of foreground elements. The encoding leverages sinusoidal and cosinusoidal variations, which amounts to(4)PE(pos,2i)\=sin(pos10002idmodel),<math><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">PE</mi><mspace width="0.35em" is="true"></mspace><mfenced is="true"><mrow is="true"><mi is="true">pos</mi><mo is="true">,</mo><mspace width="0.35em" is="true"></mspace><mn is="true">2</mn><mi is="true">i</mi></mrow></mfenced><mo is="true">=</mo><mi is="true">sin</mi><mfenced is="true"><mfrac is="true"><mi is="true">pos</mi><msup is="true"><mn is="true">1000</mn><mfrac is="true"><mrow is="true"><mn is="true">2</mn><mi is="true">i</mi></mrow><msub is="true"><mi is="true">d</mi><mi is="true">model</mi></msub></mfrac></msup></mfrac></mfenced><mo is="true">,</mo><mspace is="true"></mspace></mtd></mtr></mtable></math>(5)PE(pos,2i+1)\=cos(pos10002idmodel),<math><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">PE</mi><mspace width="0.35em" is="true"></mspace><mfenced is="true"><mrow is="true"><mi is="true">pos</mi><mo is="true">,</mo><mspace width="0.35em" is="true"></mspace><mn is="true">2</mn><mi is="true">i</mi><mo is="true">+</mo><mn is="true">1</mn></mrow></mfenced><mo is="true">=</mo><mi is="true">cos</mi><mfenced is="true"><mfrac is="true"><mi is="true">pos</mi><msup is="true"><mn is="true">1000</mn><mfrac is="true"><mrow is="true"><mn is="true">2</mn><mi is="true">i</mi></mrow><msub is="true"><mi is="true">d</mi><mrow is="true"><mi is="true">mo</mi><mi is="true">d</mi><mi is="true">el</mi></mrow></msub></mfrac></msup></mfrac></mfenced><mo is="true">,</mo><mspace is="true"></mspace></mtd></mtr></mtable></math>where pos<math><mtext is="true">pos</mtext></math> is the position index, i<math><mi is="true">i</mi></math> is the dimension index, and dmodel<math><msub is="true"><mi is="true">d</mi><mtext is="true">model</mtext></msub></math> is the dimensionality of the encoding.

Finally, during the mask decoding stage, the model uses both self-attention and cross-attention mechanisms to manage the image embeddings and positional encoding outputs. Self-attention facilitates a deeper comprehension of intra-image relationships, whereas cross-attention amplifies the associations between image regions and the input points, refining the accuracy of the segmentation of the plant’s foreground.

#### 2.4.2. Omnidirectional foreground segmentation of plants in various scenes

To refine the PlantGaussian model, a multi-scale fusion method corrects images from various viewpoints in the Track Anything Model, as shown in [Fig. S2](#s0150). The method is structured into four stages: user initialization, target tracking, target correction, and plant foreground segmentation.

In the user initialization stage, an image containing a complete plant is first input. Subsequently, a point is clicked on the plant foreground within the image. The plant foreground is then precisely segmented based on the SAM model. In the target tracking stage, an image sequence along with the plant foreground segmented from one frame is input. Next, the SAM refines the edges based on semi-supervised visual object segmentation (VOS) as(6)Et\=SAM(VOS(It,S1)),fort\=2ton,<math><mtable is="true"><mtr is="true"><mtd is="true"><msub is="true"><mi is="true">E</mi><mi is="true">t</mi></msub><mo is="true">=</mo><mi is="true">SAM</mi><mfenced is="true"><mrow is="true"><mi is="true">VOS</mi><mfenced is="true"><mrow is="true"><msub is="true"><mi is="true">I</mi><mi is="true">t</mi></msub><mo is="true">,</mo><msub is="true"><mi is="true">S</mi><mn is="true">1</mn></msub></mrow></mfenced></mrow></mfenced><mo is="true">,</mo><mspace width="0.277778em" is="true"></mspace><mtext is="true">for</mtext><mspace width="0.277778em" is="true"></mspace><mi is="true">t</mi><mo is="true">=</mo><mn is="true">2</mn><mspace width="0.277778em" is="true"></mspace><mtext is="true">to</mtext><mspace width="0.277778em" is="true"></mspace><mi mathvariant="italic" is="true">n</mi><mo is="true">,</mo></mtd></mtr></mtable></math>where It<math><msub is="true"><mi is="true">I</mi><mi is="true">t</mi></msub></math> represents the input image sequence, and S1<math><msub is="true"><mi mathvariant="italic" is="true">S</mi><mn is="true">1</mn></msub></math> is the plant foreground obtained from the first frame I1<math><msub is="true"><mi mathvariant="italic" is="true">I</mi><mrow is="true"><mn is="true">1</mn><mspace width="0.35em" is="true"></mspace></mrow></msub></math>.

In the third phase, target adjustment, an image sequence of the plant from various perspectives is input. A frame from each perspective is selected for point indication. After segmentation by SAM, multi-scale features Fv<math><msub is="true"><mi is="true">F</mi><mi is="true">v</mi></msub></math> are extracted and aligned spatially using the ICP algorithm [\[40\]](#b0200). The aligned features A<math><mi is="true">A</mi></math> are then input into the tracking network, as(7)Av\=ICP(∪v\=1VSAM(Iv,pv)),<math><mtable is="true"><mtr is="true"><mtd is="true"><msub is="true"><mi is="true">A</mi><mi is="true">v</mi></msub><mo is="true">=</mo><mi is="true">ICP</mi><mfenced is="true"><mrow is="true"><munderover is="true"><mo largeop="true" is="true">∪</mo><mrow is="true"><mi is="true">v</mi><mo is="true">=</mo><mn is="true">1</mn></mrow><mi is="true">V</mi></munderover><mi is="true">SAM</mi><mfenced is="true"><mrow is="true"><msub is="true"><mi is="true">I</mi><mi is="true">v</mi></msub><mo is="true">,</mo><msub is="true"><mi is="true">p</mi><mi is="true">v</mi></msub></mrow></mfenced></mrow></mfenced><mo is="true">,</mo></mtd></mtr></mtable></math>where pv<math><msub is="true"><mi is="true">p</mi><mi is="true">v</mi></msub></math> denotes the extracted plant foreground.

In the final plant foreground segmentation stage, the segmentation of the fully corrected multi-perspective image sequence are input. The structural similarity of the sequence frames is estimated to eliminate incomplete results as(8)Sfinal\=∩v\=1VSSIM(Sv',Sv+1'),<math><mtable is="true"><mtr is="true"><mtd is="true"><msub is="true"><mi is="true">S</mi><mi is="true">final</mi></msub><mo is="true">=</mo><munderover is="true"><mo largeop="true" is="true">∩</mo><mrow is="true"><mi is="true">v</mi><mo is="true">=</mo><mn is="true">1</mn></mrow><mi is="true">V</mi></munderover><mi is="true">SSIM</mi><mfenced is="true"><mrow is="true"><msubsup is="true"><mi is="true">S</mi><mi is="true">v</mi><mo is="true">'</mo></msubsup><mo is="true">,</mo><msubsup is="true"><mi is="true">S</mi><mrow is="true"><mi is="true">v</mi><mo is="true">+</mo><mn is="true">1</mn></mrow><mo is="true">'</mo></msubsup></mrow></mfenced><mo is="true">,</mo></mtd></mtr></mtable></math>

Ultimately, a complete multi-perspective plant foreground segmentation result is obtained.

### 2.5. Realistic plant rendering with 3D Gaussian splatting

To obtain realistic 3D plant models, 3D Gaussian Splatting is employed for plant visualization rendering. This process is divided into two stages: Gaussian point initialization and plant visualization rendering.

#### 2.5.1. Initialization and optimization of 3D Gaussian points

First, 3D Gaussian points are initialized from a sparse point cloud input. As described in [Section 2.3](#s0025), this sparse point cloud and camera poses are obtained from scene images using feature matching and PnP calculations. From this sparse point cloud, initial Gaussian points are derived. Each Gaussian point is mathematically represented as(9)G(x;μ,Σ)\=1(2π)32|Σ|12e\-12(x\-μ)TΣ\-1(x\-μ),<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><mi is="true">G</mi><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mi is="true">x</mi><mo is="true">;</mo><mi is="true">μ</mi><mo is="true">,</mo><mi mathvariant="normal" is="true">Σ</mi></mrow></mrow></mfenced><mo is="true">=</mo><mfrac is="true"><mn is="true">1</mn><mrow is="true"><msup is="true"><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mn is="true">2</mn><mi is="true">π</mi></mrow></mrow></mfenced><mfrac is="true"><mn is="true">3</mn><mn is="true">2</mn></mfrac></msup><msup is="true"><mfenced open="|" close="|" is="true"><mrow is="true"><mi mathvariant="normal" is="true">Σ</mi></mrow></mfenced><mfrac is="true"><mn is="true">1</mn><mn is="true">2</mn></mfrac></msup></mrow></mfrac><msup is="true"><mi is="true">e</mi><mrow is="true"><mo is="true">-</mo><mfrac is="true"><mn is="true">1</mn><mn is="true">2</mn></mfrac><msup is="true"><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mi is="true">x</mi><mo is="true">-</mo><mi is="true">μ</mi></mrow></mrow></mfenced><mi is="true">T</mi></msup><msup is="true"><mi mathvariant="normal" is="true">Σ</mi><mrow is="true"><mo is="true">-</mo><mn is="true">1</mn></mrow></msup><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mi is="true">x</mi><mo is="true">-</mo><mi is="true">μ</mi></mrow></mrow></mfenced></mrow></msup><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where x<math><mi is="true">x</mi></math> is any point in space, μ<math><mi is="true">μ</mi></math> represents the mean of the Gaussian distribution, indicating the center position of each Gaussian point, and Σ<math><mi mathvariant="normal" is="true">Σ</mi></math> is the covariance matrix, which controls the shape and orientation of the Gaussian distribution.

To improve the efficiency of plant foreground rendering, Gaussian points’ means μ<math><mi is="true">μ</mi></math>’s are initialized using K-Means clustering based on the input point cloud. Assuming the input sparse point cloud is P\=p1,p2,...,pn<math><mrow is="true"><mi is="true">P</mi><mo linebreak="goodbreak" linebreakstyle="after" is="true">=</mo><msub is="true"><mi is="true">p</mi><mn is="true">1</mn></msub><mo is="true">,</mo><msub is="true"><mi is="true">p</mi><mn is="true">2</mn></msub><mo is="true">,</mo><mo is="true">.</mo><mo is="true">.</mo><mo is="true">.</mo><mo is="true">,</mo><msub is="true"><mi is="true">p</mi><mi is="true">n</mi></msub></mrow></math>, where pi<math><msub is="true"><mi is="true">p</mi><mi is="true">i</mi></msub></math> is a point in the cloud, and μj<math><msub is="true"><mi is="true">μ</mi><mi is="true">j</mi></msub></math> is the cluster center, each cluster center is updated as(11)μj\=1|Cj|∑pi∈Cjpi,<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><msub is="true"><mi is="true">μ</mi><mi is="true">j</mi></msub><mo is="true">=</mo><mfrac is="true"><mn is="true">1</mn><mfenced open="|" close="|" is="true"><mrow is="true"><msub is="true"><mi is="true">C</mi><mi is="true">j</mi></msub></mrow></mfenced></mfrac><msub is="true"><mo is="true">∑</mo><mrow is="true"><msub is="true"><mi is="true">p</mi><mi is="true">i</mi></msub><mo is="true">∈</mo><msub is="true"><mi is="true">C</mi><mi is="true">j</mi></msub></mrow></msub><msub is="true"><mi is="true">p</mi><mi is="true">i</mi></msub><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where Cj<math><msub is="true"><mi mathvariant="italic" is="true">C</mi><mi mathvariant="italic" is="true">j</mi></msub></math> represents the set of points in the j<math><mrow is="true"><mi is="true">j</mi></mrow></math>\-th cluster, |Cj|<math><mo is="true">|</mo><msub is="true"><mi mathvariant="italic" is="true">C</mi><mi mathvariant="italic" is="true">j</mi></msub><mo is="true">|</mo></math> is the number of points in Cj<math><msub is="true"><mi mathvariant="italic" is="true">C</mi><mi mathvariant="italic" is="true">j</mi></msub></math>, and ∑pi∈Cjpi<math><munder is="true"><mo mathvariant="italic" is="true">∑</mo><mrow is="true"><msub is="true"><mi mathvariant="italic" is="true">p</mi><mi mathvariant="italic" is="true">i</mi></msub><mo mathvariant="italic" is="true">∈</mo><msub is="true"><mi mathvariant="italic" is="true">C</mi><mi mathvariant="italic" is="true">j</mi></msub></mrow></munder><msub is="true"><mi mathvariant="italic" is="true">p</mi><mi mathvariant="italic" is="true">i</mi></msub></math> is the sum of position vectors of all points in Cj<math><msub is="true"><mi mathvariant="italic" is="true">C</mi><mi mathvariant="italic" is="true">j</mi></msub></math>.

In preparation for model learning, initialization of the covariance matrix Σ<math><mi mathvariant="normal" is="true">Σ</mi></math> involves defining matrices for scaling and rotational transformations, defined by(11)Σ\=R(q)S(s)S(s)TR(q)T,<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><mi mathvariant="normal" is="true">Σ</mi><mo is="true">=</mo><mi is="true">R</mi><mfenced open="(" close=")" is="true"><mrow is="true"><mi is="true">q</mi></mrow></mfenced><mi is="true">S</mi><mfenced open="(" close=")" is="true"><mrow is="true"><mi is="true">s</mi></mrow></mfenced><mi is="true">S</mi><msup is="true"><mfenced open="(" close=")" is="true"><mrow is="true"><mi is="true">s</mi></mrow></mfenced><mi is="true">T</mi></msup><mi is="true">R</mi><msup is="true"><mfenced open="(" close=")" is="true"><mrow is="true"><mi is="true">q</mi></mrow></mfenced><mi is="true">T</mi></msup><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where R(q)<math><mi mathvariant="italic" is="true">R</mi><mtext is="true">(</mtext><mi mathvariant="italic" is="true">q</mi><mtext is="true">)</mtext><mspace is="true"></mspace></math> denotes the rotation transformation matrix derived from the quaternion q<math><mi mathvariant="italic" is="true">q</mi></math>, and S(s)<math><mi mathvariant="italic" is="true">S</mi><mtext is="true">(</mtext><mi mathvariant="italic" is="true">s</mi><mtext is="true">)</mtext><mspace is="true"></mspace></math> indicates the scaling transformation, characterized by a 3D vector s<math><mspace is="true"></mspace><mi mathvariant="italic" is="true">s</mi></math>.

#### 2.5.2. Splatting and rendering in plant visualization

The entire Gaussian training and rendering process involves optimizing the distribution of 3D Gaussian points to better fit the plant model. During training, each initial point is splatted onto the input multi-view images for rendering, and the differences between the rendered results and the input images are evaluated. In Gaussian splatting, the method involves calculating the projected 2D covariance matrix as(12)Σ′\=JW∑WTJT,<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><msup is="true"><mi mathvariant="normal" is="true">Σ</mi><mo is="true">′</mo></msup><mo is="true">=</mo><mi is="true">J</mi><mi is="true">W</mi><mo is="true">∑</mo><mrow is="true"><msup is="true"><mi is="true">W</mi><mi is="true">T</mi></msup><msup is="true"><mi is="true">J</mi><mi is="true">T</mi></msup></mrow><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where J<math><mi mathvariant="italic" is="true">J</mi></math> is the Jacobian matrix, detailing the partial derivatives involved in the projection process, and W<math><mi is="true">W</mi></math> is the matrix for rotation and translation linked to the initial camera pose (R1,t1)<math><mtext is="true">(</mtext><msub is="true"><mi mathvariant="italic" is="true">R</mi><mtext is="true">1</mtext></msub><mtext is="true">,</mtext><msub is="true"><mi mathvariant="italic" is="true">t</mi><mtext is="true">1</mtext></msub><mtext is="true">)</mtext></math>.

Rendering is performed using a Tiled-based Rasterizer method. After projection transformation, which involves multiplying the 3D Gaussian points by the aforementioned covariance matrix, the opacity of each Gaussian point is calculated using Equation 13, which takes the form(13)α′\=1\-e\-αdet(Σ)12,<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><msup is="true"><mi is="true">α</mi><mo is="true">′</mo></msup><mo is="true">=</mo><mn is="true">1</mn><mo is="true">-</mo><msup is="true"><mi is="true">e</mi><mrow is="true"><mo is="true">-</mo><mfrac is="true"><mi is="true">α</mi><mrow is="true"><mi is="true">det</mi><msup is="true"><mfenced open="(" close=")" is="true"><mrow is="true"><mi mathvariant="normal" is="true">Σ</mi></mrow></mfenced><mfrac is="true"><mn is="true">1</mn><mn is="true">2</mn></mfrac></msup></mrow></mfrac></mrow></msup><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where α<math><mi is="true">α</mi></math> represents the opacity of the 3D Gaussian points, and α′<math><msup is="true"><mi is="true">α</mi><mo is="true">′</mo></msup></math> is the opacity of the projected 2D Gaussian points.

After projection, a loss function L(μ,Σ,C)<math><mrow is="true"><mi is="true">L</mi><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mi is="true">μ</mi><mo is="true">,</mo><mi mathvariant="normal" is="true">Σ</mi><mo is="true">,</mo><mi is="true">C</mi></mrow></mrow></mfenced></mrow></math> is defined to update and optimize parameters, and backpropagation is performed. Since the model uses only the plant foreground as input rather than the complete image, a weighting scheme is defined to accelerate the convergence of the loss function and reduce the appearance of artifacts. The loss function is defined by(14)L(μ,Σ,C)\=∑i\=1Nwi·||G(xi;μ,Σ)\-I(xi)||2,<math><mtable is="true"><mtr is="true"><mtd is="true"><mi is="true">L</mi><mfenced is="true"><mrow is="true"><mi is="true">μ</mi><mo is="true">,</mo><mi mathvariant="normal" is="true">Σ</mi><mo is="true">,</mo><mi is="true">C</mi></mrow></mfenced><mo is="true">=</mo><msubsup is="true"><mo is="true">∑</mo><mrow is="true"><mi is="true">i</mi><mo is="true">=</mo><mn is="true">1</mn></mrow><mi is="true">N</mi></msubsup><msub is="true"><mi is="true">w</mi><mi is="true">i</mi></msub><mo is="true">·</mo><msup is="true"><mfenced open="|" close="|" is="true"><mfenced open="|" close="|" is="true"><mrow is="true"><mi is="true">G</mi><mfenced is="true"><mrow is="true"><msub is="true"><mi is="true">x</mi><mi is="true">i</mi></msub><mo is="true">;</mo><mi is="true">μ</mi><mo is="true">,</mo><mi mathvariant="normal" is="true">Σ</mi></mrow></mfenced><mo is="true">-</mo><mi is="true">I</mi><mfenced is="true"><msub is="true"><mi is="true">x</mi><mi is="true">i</mi></msub></mfenced></mrow></mfenced></mfenced><mn is="true">2</mn></msup><mo is="true">,</mo></mtd></mtr></mtable></math>where wi<math><msub is="true"><mi mathvariant="italic" is="true">w</mi><mi mathvariant="italic" is="true">i</mi></msub></math> represents the weight assigned to each pixel. N<math><mrow is="true"><mi is="true">N</mi><mspace width="3.33333pt" is="true"></mspace></mrow></math> is the number of pixels in the target data. G(xi;μ,Σ)<math><mrow is="true"><mi is="true">G</mi><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><msub is="true"><mi is="true">x</mi><mi is="true">i</mi></msub><mo is="true">;</mo><mi is="true">μ</mi><mo is="true">,</mo><mi mathvariant="normal" is="true">Σ</mi></mrow></mrow></mfenced></mrow></math> is the image intensity rendered from the current Gaussian parameters, and I(xi)<math><mi mathvariant="italic" is="true">I</mi><mfenced is="true"><msub is="true"><mi mathvariant="italic" is="true">x</mi><mi mathvariant="italic" is="true">i</mi></msub></mfenced></math> is the actual image intensity at xi<math><msub is="true"><mi mathvariant="italic" is="true">x</mi><mi mathvariant="italic" is="true">i</mi></msub></math>.

The color C<math><mi is="true">C</mi></math> of the image is calculated using alpha compositing(15)C\=∑i∈Nciαi′∏j\=1i\-1(1\-αj′),<math><mrow is="true"><mtable is="true"><mtr is="true"><mtd is="true"><mrow is="true"><mi is="true">C</mi><mo is="true">=</mo><msub is="true"><mo is="true">∑</mo><mrow is="true"><mi is="true">i</mi><mo is="true">∈</mo><mi is="true">N</mi></mrow></msub><mrow is="true"><msub is="true"><mi is="true">c</mi><mi is="true">i</mi></msub><msubsup is="true"><mi is="true">α</mi><mi is="true">i</mi><mo is="true">′</mo></msubsup></mrow><munderover is="true"><mo is="true">∏</mo><mrow is="true"><mi is="true">j</mi><mo is="true">=</mo><mn is="true">1</mn></mrow><mrow is="true"><mi is="true">i</mi><mo is="true">-</mo><mn is="true">1</mn></mrow></munderover><mfenced open="(" close=")" is="true"><mrow is="true"><mrow is="true"><mn is="true">1</mn><mo is="true">-</mo><msubsup is="true"><mi is="true">α</mi><mi is="true">j</mi><mo is="true">′</mo></msubsup></mrow></mrow></mfenced><mo is="true">,</mo></mrow></mtd></mtr></mtable></mrow></math>where ci<math><msub is="true"><mi mathvariant="italic" is="true">c</mi><mi mathvariant="italic" is="true">i</mi></msub></math> is the color learned by the model, and αj'<math><msubsup is="true"><mi is="true">α</mi><mi mathvariant="italic" is="true">j</mi><mo is="true">'</mo></msubsup></math> is the opacity calculated by Equation (13).

Based on the calculated colors and opacities, Gaussian points are rendered onto image planes from various angles, thus synthesizing the final image. From any user-specified viewing angle (camera perspective), the corresponding projected image can be computed, enabling the acquisition of comprehensive 3D digital plant renderings.

### 2.6. From Gaussian rendering to mesh extraction

While 3D Gaussian rendering provides a new way of 3D visualization, standard 3D measurements still depend on mesh-based methods. In this work, we adopt the SuGaR (Surface-aligned Gaussian Splatting for Mesh Rendering) [\[41\]](#b0205) technique to quickly extract triangular meshes from 3D rendered plants, facilitating the creation of measurable meshes, as shown in [Fig. 2](#f0010).

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2.jpg)

1.  [Download: Download high-res image (872KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2_lrg.jpg "Download high-res image (872KB)")
2.  [Download: Download full-size image](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr2.jpg "Download full-size image")

Fig. 2. Diagram of mesh extraction method. First, the Gaussian point distribution is retrained to better conform to the surface. This stage includes three steps: calculating the signed distance function (SDF), optimizing the density function, and reducing the 3D Gaussian scaling factor, ultimately resulting in the flattening of Gaussian ellipsoids. In the second stage, an initial mesh is obtained through coarse point sampling, Poisson reconstruction, and meshing. In the third stage, the Gaussian points are bound to the triangular mesh, further refining the plant surface based on the mesh results.

The approach consists of three main components: introducing regularization terms, extracting meshes, and binding 3D Gaussians to the mesh surface, specifically tailored to address the challenges of accurately modeling the plant surface. The process begins by optimizing the loss function with regularization terms to refine Gaussian splatting, resulting in a 3D Gaussian distribution that fits tightly to the plant surface, which is often intricate and irregular. This optimization involves computing signed distance function (SDF) values to ensure that the Gaussians align closely with the plant surface. Additionally, Gaussian overlap is enhanced by optimizing their density based on depth mapping, followed by smoothing the 3D Gaussians through the reduction of their scaling factors. The introduction of these new regularization terms results in a dense and precisely aligned 3D Gaussian distribution that closely conforms to the plant structure. In the second stage, the density of Gaussian points is increased to generate a thick representation of the plant surface, after which an initial 3D mesh is generated through Poisson reconstruction. This mesh is subsequently refined with SDF techniques to capture finer details of the plant's surface geometry. Finally, in the third stage, the 3D Gaussians are re-bound to the refined mesh, enabling further refinement of specific sections of the plant surface and resulting in a more accurate and realistic model suited for agricultural analysis.

Finally, the model assessed the accuracy of the plant mesh, with the measurement procedure illustrated in [Fig. S3](#s0150). The evaluation focused on potted tobacco plants, measuring plant height and the maximum leaf length based on the mesh results and comparing them to ground truth measurements. To establish a scale factor for the reconstruction model, the inner diameter of the pot was used as a reference. Following segmentation of the tobacco plant, the plant height and maximum leaf length were measured. Plant height was determined using the height of the highest leaf at the center of the tobacco plant. For leaf length, the largest leaf was selected, measuring the distance from the base to the tip of the leaf.

### 2.7. Implementation platform and model evaluation methods

The experiments were conducted on the Ubuntu 22.04 operating system, using an Intel Xeon(R) Platinum 8251C CPU at 3.80 GHz × 24 and an Nvidia GeForce RTX 3090 graphics card. The deep learning framework employed was PyTorch 1.12.1, with PyCharm as the programming environment and Python version 3.7.13 as the programming language. All comparison algorithms were executed in this uniform setting. Data collection and image processing were conducted using C++ with OpenCV 4.7.0 for image manipulation, and the programs were debugged using Visual Studio 2022.

To evaluate the 3D Gaussian visualization results of the proposed PlantGaussian model, four metrics were used: PSNR (Peak Signal-to-Noise Ratio), MAE (Mean Absolute Error), SSIM (Structural Similarity Index), and LPIPS (Learned Perceptual Image Patch Similarity). These metrics were calculated by comparing the model-rendered images with the input multi-view ground truth images. PSNR measures the ratio between the maximum possible power of a signal and the power of noise affecting its representation. In this study, the images were rendered using the PlantGaussian model and then compared pixel-by-pixel with the ground truth images. PSNR was calculated by determining the mean squared error (MSE) between the two images and applying a logarithmic transformation. MAE quantifies the average pixel-wise difference between the rendered and ground truth images. It is calculated by computing the absolute difference for each corresponding pixel and then averaging the values. SSIM evaluates the similarity between two images in terms of brightness, contrast, and structure. For the PlantGaussian model, SSIM was computed by comparing the rendered and ground truth images within local windows. LPIPS uses a deep neural network to extract high-level features from images to assess perceptual differences. In this study, the VGG network was selected as the feature extractor. Rendered images and ground truth images were input into a pre-trained network, and the differences in their feature representations were calculated. For methods like Neurangle, Colmap, and MVS, which directly generate 3D meshes, SSIM and LPIPS could not be computed due to the lack of complete brightness and texture information. These methods focus on geometric reconstruction, so only PSNR and MAE were calculated for them.

## 3\. Results

### 3.1. Time efficiency of PlantGaussian

The total time for Realistic Plant Visualization ranged from 6 to 21 min Specifically: 1) The multi-view video recording around the plant required less than 90 s; 2) Camera pose estimation and sparse point cloud initialization, depending on the complexity of the multi-view image scene, took between 30 and 300 s; 3) Plant foreground extraction required no more than 60 s; 4) Gaussian initialization and rendering involved either 7000 training iterations (approximately 180 s) or 30,000 training iterations (around 15 min). After obtaining the 3D Gaussian visualization, the time required to extract the plant mesh, depending on the complexity of the plant surface, ranged from 2 to 6 h.

PlantGaussian is currently in the early stages of exploring mesh generation from Gaussian points. Compared to the visualization process, generating plant meshes is considerably more time-consuming. Even so, the time required is acceptable under conditions that ensure accurate mesh generation, particularly when compared to existing models capable of producing relatively complete meshes, such as Neurangle (over 8 h) and COLMAP (dense point cloud reconstruction and Poisson reconstruction, 3–6 h). Therefore, the time efficiency results of the PlantGaussian model across various stages align with expectations.

### 3.2. Accuracy analysis of camera pose estimation

As shown in [Fig. S4](#s0150), the visualization of the camera poses closely aligns with the actual movement paths of the smartphone used during image capture.

For the three randomly selected plants, the quantitative assessment of camera poses is presented in [Table S2](#s0150). At a video resolution of 1080p, with each image having a resolution of 1080 × 1920, the average reprojection error calculated based on the estimated camera poses was less than one pixel. The generated sparse point clouds for all plants contained more than 20,000 points, and each point was observed in an average of 5 images. The average reprojection error was calculated as 0.799. These results demonstrate that the camera pose estimation effectively generates high-quality sparse point clouds, which meets the precision requirements for subsequent model computations.

### 3.3. 3D Gaussian rendering of plants

The visualization outcomes of 3D digital plants have shown promising results across various stages of growth and various locations. This study presents distinct visualization results for corn, wheat, and tobacco, along with the computation of MAE, PSNR, SSIM and LPIPS values. Compared to the original 3D Gaussian splatting technique, PlantGaussian achieved notable improvements, demonstrating significant enhancements over other algorithms previously applied in plant visualization.

#### 3.3.1. Comparison between PlantGaussian and original 3D gaussians

The comparison of original 3D Gaussian Splatting and our PlantGaussian for maize, tobacco, and wheat is illustrated in [Fig. 3](#f0015). From the perspective of 3D visualization effects, our PlantGaussian offers three main advantages. First, the plant models are retained while all backgrounds are removed, allowing breeders to observe the plant objects without any background interference. This plant-only foreground in the 3D Gaussian model also facilitates subsequent patch extraction and plant phenotype calculation. Second, our method eliminates numerous artifacts around the Gaussian points near the plants, ensuring that plant observations are no longer hindered by randomly generated Gaussian points. Third, the detailed visualization of the target plants is further refined, enabling clearer observation of the plants’ growth conditions. Nevertheless, PlantGaussian still exhibits some limitations common to Gaussian-based models, which will be further discussed in subsequent sections.

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3.jpg)

1.  [Download: Download high-res image (507KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3_lrg.jpg "Download high-res image (507KB)")
2.  [Download: Download full-size image](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr3.jpg "Download full-size image")

Fig. 3. Comparation between original 3D gaussians and PlantGaussian for four plants. Four plant species were selected for comparison, categorized into In-pots and In-field conditions, resulting in eight groups of image data. In most cases, our PlantGaussian method significantly outperformed untreated 3D Gaussians, providing clearer rendering and better visualization of the plants.

To quantitatively analyze the improvements of our method compared to the original 3D Gaussian Splatting, we calculated the loss, MAE, and PSNR for the three plants after 7000 and 30,000 training iterations, as shown in [Table 1](#t0005), [Table 2](#t0010). In these tables, values indicating better performance are highlighted in darker shades, while lighter shades denote poorer performance. The results indicate that our PlantGaussian demonstrates excellent performance across various plants. However, the PSNR value for maize is slightly lower than that of the original Gaussian model, likely due to segmentation issues near the plant’s base during modeling, which led to minor omissions in the 3D model. For wheat, the PSNR value is slightly lower than the original Gaussian at 7000 iterations but surpasses the original 3D Gaussian at 30,000 iterations. The MAE values for all plants have improved compared to the original Gaussian, and all PSNR values exceed 25. These findings confirm that the PlantGaussian method outperforms the original 3D Gaussian Splatting technique in terms of overall performance across various plants.

Table 1. Results for 3 plants at iteration 7000 and iteration 30,000.

| Plant | Corn |     |     | Tobacco |     |     | Wheat |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Method \|Metric | Loss | MAE | PSNR | Loss | MAE | PSNR | Loss | MAE | PSNR |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 3D Gaussians-7000 iteration | 0.031 | 0.021 | 29.93 | 0.208 | 0.097 | 17.57 | 0.0382 | 0.0139 | 32.83 |
| PlantGaussian-7000 iteration | 0.018 | 0.009 | 28.44 | 0.043 | 0.021 | 26.47 | 0.0063 | 0.0034 | 31.49 |
| 3D Gaussians-30,000 iteration | 0.025 | 0.015 | 32.99 | 0.115 | 0.062 | 20.84 | 0.0325 | 0.0113 | 34.53 |
| PlantGaussian-30,000 iteration | 0.016 | 0.008 | 29.74 | 0.014 | 0.013 | 29.49 | 0.0078 | 0.0028 | 37.73 |

Table 2. Comparison between the model-calculated values and manual measurements for the four tobacco plants.

| Item | Tobacco 1 |     | Tobacco 2 |     | Tobacco 3 |     | Tobacco 4 |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Calculated value | Manual measured value | Calculated value | Manual measured value | Calculated value | Manual measured value | Calculated value | Manual measured value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Scale factor | 0.05 | /   | 0.05 | /   | 0.05 | /   | 0.07 | /   |
| Plant height | 8.89 | 8.49 | 6.15 | 5.77 | 7.05 | 7.38 | 6.78 | 7.38 |
| Maximum leaf length | 16.83 | 16.17 | 11.51 | 11.43 | 18.18 | 18.31 | 17.78 | 18.74 |

Note: The scale factor refers to the ratio between the point cloud scale and the actual scale, which is related to the camera focal length.

#### 3.3.2. Comparative visualization of plants in various scenes

To evaluate the performance of PlantGaussian model in various locations, we used the same environment and the original image sequences to model with our PlantGaussian, Instant-NGP, COLMAP, NeRF, and OpenMVS methods. Visualization results are presented in [Fig. 4](#f0020). The results indicate that the original NeRF model’s performance is significantly inferior to the Instant-NGP method, and the OpenMVS results are considerably worse than those of COLMAP. Consequently, the visualization results for NeRF and OpenMVS are omitted, and only their quantitative assessments are included. This section evaluates the performance of maize and wheat in 3 locations, taking into account the background environment, the plants’ positions, and the impact of outdoor wind. The modeling results for tobacco in various environments will be evaluated in the next section.

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4.jpg)

1.  [Download: Download high-res image (653KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4_lrg.jpg "Download high-res image (653KB)")
2.  [Download: Download full-size image](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr4.jpg "Download full-size image")

Fig. 4. 3D Modeling results of three plant species under three models at three scenes**.** From the comparison of 3 models, the visual clarity of our PlantGaussian method consistently outperformed all others. For all models, the visualization quality was notably poorer in field experiments compared to indoor or outdoor in-pots conditions.

For corn, three cultivation environments were assessed: outdoor potted, indoor potted, and outdoor field conditions. In outdoor potted scenarios, corn plants are prone to swaying due to the constraints of pot size and root depth, particularly under natural wind conditions. This movement results in significant blurring and missing data when using traditional photogrammetry methods like COLMAP, which relies heavily on feature point matching for point cloud estimation. Although Instant-NGP provides relatively complete modeling of the corn surface, the details remain blurry and nearly unobservable. Plant movement similarly affects our PlantGaussian method, introducing some artifacts and occlusions on the corn surface, yet overall plant morphology and detail are well-captured.

For indoor corn, planted in office areas, background human activity during image capture causes substantial data omissions in both Instant-NGP and COLMAP models. In contrast, the 3D PlantGaussian method effectively models the target plants. In the case of corn grown in field conditions over a growing period, all three methods successfully model the plants, but the visualization effects are best with our PlantGaussian approach. However, when field plants are densely sown, our method occasionally reconstructs adjacent plants. This does not interfere with observation and can be easily corrected during the meshing process.

For wheat, two cultivation environments were assessed: outdoor potted and indoor conditions. In outdoor potted settings, all three methods were capable of comprehensively modeling the plants. Both the PlantGaussian method and Instant-NGP provided good visualization of wheat, whereas COLMAP’s results were inferior. However, our PlantGaussian method did not reconstruct the lower dried branches, making Instant-NGP slightly superior in this aspect. Nonetheless, both modeling methods met the requirements for visualization observations. Indoor modeling of mature wheat, particularly the ear parts, proved to be extremely challenging. COLMAP was unable to model the wheat ears at all, and Instant-NGP struggled to visualize them clearly. In contrast, the PlantGaussian method effectively captured the wheat ears, offering a significant improvement over the other techniques.

A major advantage of the PlantGaussian method in visualizing various plants at different locations is its ability to eliminate cluttered backgrounds, allowing for clear display of the plants. This capability ensures that breeders can observe plant characteristics without background interference. Additionally, the method mitigates privacy concerns during post-modeling by excluding irrelevant background details from the visual output.

To quantitatively assess the performance of various models, losses, Mean Absolute Errors (MAE), and Peak Signal-to-Noise Ratios (PSNR) were calculated for five models of the plants, as shown [Table S3](#s0150). It is important to note that, due to the diverse methods used by the models to calculate losses, these results are not directly comparable and are provided for reference only. COLMAP and OpenMVS, which are not based on deep learning techniques, do not report loss values. The results demonstrate that our PlantGaussian method performs well across various environments, capable of delivering detailed 3D models in diverse settings.

#### 3.3.3. Comparative visualization of plant growth at four stages

Plants grown in pots and in the field were selected for visualization assessment under three models and quantitative evaluation under five models. The results of the visualization assessments are depicted in [Fig. 5](#f0025). Tobacco, characterized by its rapid growth cycle and typical leaf traits, was chosen as a representative plant for assessing 3D plant visualization across 4 growth stages.

![](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5.jpg)

1.  [Download: Download high-res image (811KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5_lrg.jpg "Download high-res image (811KB)")
2.  [Download: Download full-size image](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-gr5.jpg "Download full-size image")

Fig. 5. 3D modeling results of tobacco under 3 models at various times**.** The first four groups represent potted tobacco in outdoor scenes, while the last four groups depict tobacco in field scenes.

Potted plants were monitored over 4 d in 2024 to gather and analyze growth stages. Up to July 4, when tobacco growth was slow, 3D modeling methods were relatively straightforward, with all three approaches effectively visualizing the plants. However, the Colmap model showed blurring at the plant edges. By July 26, as the tobacco plants had grown taller and the branches had become more numerous, the Instant-NGP and Colmap methods failed to accurately represent the tobacco’s morphology. In contrast, the PlantGaussian method continued to precisely capture the three-dimensional structure of the plants.

Field-grown plants were monitored over four d in 2023 for collection and analysis, presenting challenges in modeling due to natural variations in lighting and wind conditions. During periods of rapid growth, the occlusion of leaves posed significant issues. As seen in [Fig. 5](#f0025), despite some blurring at the edges of the tobacco on June 17 and June 21 due to issues with the quality of the photographs, the PlantGaussian method clearly displayed the texture of the tobacco leaves. The Instant-NGP and Colmap methods, however, yielded poor modeling results on all dates except June 17. On July 4, when the tobacco was affected by pests, resulting in numerous holes on the leaf surfaces, the PlantGaussian method distinctly revealed each perforation, enabling better analysis of pest damage. In contrast, the Instant-NGP and Colmap methods struggled to differentiate the damaged areas.

Modeling the various growth stages of field crops—or achieving plant digitization “cross-time”—remains a lengthy and error-prone process. Various factors such as lighting conditions, quality of photography, occlusion by plants, and pest damage can all impact the modeling results. However, the results demonstrate that our PlantGaussian method significantly mitigates these disturbances, consistently providing reliable observational outcomes under various conditions. Moreover, photographers require no detailed agricultural expertise; simple training and a routine of circling the plant to capture photographs, which are then uploaded to a database, are sufficient. From these time-stamped photographs, digital models of each growth stage of the plant can be generated, facilitating targeted analysis by breeding experts.

Similarly, losses, Mean Absolute Errors (MAE), and Peak Signal-to-Noise Ratios (PSNR) were calculated for the species models of the aforementioned plants, as shown in [Table S4](#s0150). The results indicate that under both field and potted conditions, PlantGaussian achieved a PSNR greater than 20 and an MAE below 0.1 across all datasets. Consequently, our PlantGaussian method exhibits excellent performance over time, enabling the acquisition of detailed PlantGaussian models at various stages.

### 3.4. Plant foreground segmentation

Using the improved Track Anything model, precise foreground segmentation of most plants can be achieved in any environment. [Fig. S5](#s0150) illustrates the model’s precise segmentation of the target plant’s foreground in a complex indoor background with people moving around. To demonstrate the enhancements brought by multi-scale fusion to the Track Anything model, a comparison of results before and after the improvements is shown in [Fig. S6](#s0150). The results confirm that the enhanced model performs better in completely segmenting all parts of a plant, especially in cases where certain areas differ significantly in color and texture from others.

To compare the impact of the improved method on plant visualization using the PlantGaussian model, 3D Gaussian Splatting was performed for both the original input and the improved input. The results are shown in [Fig. S8](#s0150). For maize crops, characterized by diverse leaf distribution and orientation, the PlantGaussian method with multi-scale input achieved visualization results nearly identical to the original view. In contrast, when the unoptimized segmentation method was used as input, mismatches caused by incomplete segmentation of individual leaves resulted in artifacts around the plant and misalignment in certain leaf regions. These findings demonstrate that the improved plant foreground segmentation method significantly enhances the 3D visualization quality of plants with complex or overlapping structures.

### 3.5. Evaluation of measurable plant mesh surfaces

To evaluate the reliability of the PlantGaussian model in agricultural measurements, four tobacco plants were selected for surface meshing extraction, as shown in [Fig. S7](#s0150). Although the visual quality of the meshed results was not as refined as the rendered output, the surface morphology of the plants was adequately captured, with no surface holes observed. This confirms that the meshed results are suitable for plant morphology measurements. We further compared the manually measured values of two traits—plant height and leaf length—with those computed by the PlantGaussian model, as detailed in [Table 2](#t0010). The relative errors between the computed and measured plant heights for the four plants were 4%, 6%, 4%, and 8%, respectively. Similarly, the relative errors for leaf length were 4%, 1%, 1%, and 5%, respectively. The average relative error across all measurements was 4%. Since manual measurements of plant height are less variable and more closely represent the true values of the plant, the Pearson correlation coefficient between the manually measured plant height and the model-calculated values was calculated, resulting in a value of 0.86. This indicates a strong positive correlation between the calculated values and the manual measurements. These results demonstrate that the meshed surfaces derived from the visual output are sufficient to meet the required measurement accuracy.

## 4\. Discussion

### 4.1. One of the first 3D Gaussian Splatting on plants

The recent advances in 3D Gaussian splatting represent a significant breakthrough in the field of three-dimensional reconstruction and have seen considerable success in industrial applications. However, in the agricultural sector, even preceding techniques such as Neural Radiance Fields (NeRF) have seen limited research. Despite the promising potential of these methods, their application in agriculture remains largely unexplored, which suggests a critical area for further study.

The ability to visualize plants in three dimensions can revolutionize several aspects of agricultural science, particularly in providing comprehensive data for phenotypic research. One practical application is in facilitating remote expert consultations. By utilizing detailed 3D visualizations, experts can perform remote diagnoses and assessments of plant health, growth conditions, and disease manifestations without the need for physical presence. As shown in [Fig. S9](#s0150), the PlantGaussian method clearly captures the leaf color and surface perforations of soybeans, a level of detail that most models fail to achieve. This capability not only increases the accuracy of phenotyping but also expands the possibilities for preventive care and tailored treatment strategies.

While realistic visualization of plants can now be achieved, the issue of scale factors remains a persistent challenge. In this study, for potted plants, the largest diameter of the pot was used for calibration. For field crops, objects with fixed lengths, such as field ridges, were employed as calibration references. In wild scenarios, we recommend carrying a small calibration object (e.g., a checkerboard pattern) to serve as a reference during the initial camera pose estimation process.

### 4.2. Refined 3D plant modeling with foreground Retention

In 3D modeling, the segmentation of 3D plants has always been an unavoidable challenge. Many existing models are trained on specific plant point clouds for segmentation, relying on particular species. These methods, primarily based on 3D CNNs, often cater to simple measurement requirements and fail to segment detailed, visualizable 3D plant models accurately. Numerous studies have resorted to laborious manual segmentation, where each bounding line around the plant’s 3D form must be painstakingly drawn, a time-consuming process that struggles with background and plant adhesion issues. Directly reconstructing digital 3D plants by meticulously extracting plant contours from each input image offers a shortcut. However, manually segmenting each image entails a workload comparable to direct point cloud segmentation.

This study introduces a method based on the Track Anything model, incorporating the Segment Anything model and XMem, which requires only a few manual points to precisely segment each image’s contours. During the camera pose computation phase, images with backgrounds are used, while foregrounds are employed in the Gaussian initialization phase to filter out excess Gaussian points, thus retaining only the plant foreground for refined 3D modeling. By facilitating the foreground extraction into the 3D Gaussian Splatting’s initialization phase, this approach successfully addresses the segmentation challenges in the 3D modeling of target models, enabling the establishment of digital 3D plants cross-time and cross-scenes.

Despite this study’s efforts in 3D modeling of plants across various scenes and developmental stages, referred to as ‘cross-time’ and ‘cross-scene’, not all scenarios readily yield high-quality automated 3D visualization. As observed in the [Section 3](#s0070), the reconstruction quality of field crops was inferior to that of potted plants. More complex still, dense field crops with overlapping and obstructing foliage pose significant challenges in obtaining individual plant 3D visualizations. We encourage future researchers to explore more complex field scenarios from the perspectives of image processing or 3D Gaussian points for individual plant extraction.

### 4.3. Mesh extraction provides more Opportunities for quantitative measurements

While focus of this research is on realistic three-dimensional plant visualization rendering, it is acknowledged that mere 3D rendering has limited applicability in practical agricultural production. Therefore, we have dedicated efforts to develop methods for transforming 3D visualization results into measurable 3D points. Thanks to the work of Antonie and colleagues on SuGaR [\[41\]](#b0205), this concept has become a reality. They discovered that after optimization through 3D Gaussian splatting, Gaussian distributions are not orderly structured and do not correspond well with the actual surface of the scene. To overcome this limitation, they retrained the model and proposed a method for extracting precise mesh sections from 3D Gaussian results. Using the SuGaR approach, we have successfully extracted accurate plant meshes that researchers can directly measure for traits such as height and volume, or use to build new models for detailed point cloud processing like leaf segmentation and plant characteristic analysis. However, the current retraining method still faces the following challenges: 1) The time required to generate measurable meshes is excessively long compared to realistic visualization. 2) The reconstruction accuracy for plants with fine surface details, such as wheat ears, remains insufficient. 3) The generated meshes consist of too many segments, resulting in large file sizes and significant storage demands.

It is worth mentioning that, while measurable mesh sections have been extracted from plant rendering results to facilitate subsequent calculations through traditional point cloud processing, further exploration of the 3D Gaussian method is highly encouraged. We believe that the representation of 3D Gaussians, as an efficient new form of scene representation combined with traditional rendering methods, is especially significant for its explicit functional representation (as opposed to the implicit neural networks of NeRF), and is sufficient to spark a revolution in the field of three-dimensional phenotypic measurement. We have also made explorations, enabling the convenient importation of 3D Gaussian representations into commonly used software like Unity for further editing through corresponding plugins, as shown in [Fig. S10](#s0150). We anticipate the emergence of more 3D Gaussian representation methods suited to specific plant scenarios, gradually replacing traditional mesh extraction techniques.

## 5\. Conclusions

The study explores a 3D reconstruction approach for plants, termed PlantGaussian, which is based on 3D Gaussians across various scenes and time. The method could effectively render the surface morphology of all plants, with most plant models achieving a PSNR above 25. In terms of PSNR and MAE, the PlantGaussian model outperformed other approaches, including the original 3D Gaussian Splatting. The 3D surface mesh results indicated an average relative error of 4% between the computed values and manual measurements. These findings confirm that the PlantGaussian approach delivers high-quality 3D visualizations across diverse scenes and time points, marking a significant advancement towards the development of general-purpose 3D digital plant models. The method has potential applications in expanding plant phenotyping databases, ecological studies, and remote expert diagnosis of growth stages. Future research could focus on further quantifying phenotypic traits for individual plant visualizations, enhancing 3D surface mesh generation, and integrating these findings with genotyping studies to provide stronger support for agricultural breeding programs.

## CRediT authorship contribution statement

**Peng Shen:** Writing – review & editing, Writing – original draft, Methodology, Investigation, Data curation, Conceptualization. **Xueyao Jing:** Writing – original draft, Investigation, Data curation. **Wenzhe Deng:** Writing – review & editing, Investigation, Data curation. **Hanyue Jia:** Writing – review & editing, Investigation, Data curation. **Tingting Wu:** Writing – review & editing, Validation, Supervision, Resources, Project administration, Funding acquisition, Formal analysis, Conceptualization.

## Declaration of competing interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

## Acknowledgments

This research was supported by the Central Government’s Guidance Fund for Local Science and Technology Development ([2024ZY-CGZY-19](#gp005)). The authors appreciate the funding organization for its financial support. The authors would also like to express special thanks to Dr. Zhiguo Han from MetaPheno Laboratory, PhenoTrait Technology Co., Ltd. The development of the PlantGaussian dataset benefited from the company’s voluntary assistance under Dr. Han’s guidance.

## Appendix A. Supplementary data

Download all supplementary files included with this article

[What’s this?](https://service.elsevier.com/app/answers/detail/a_id/19286/supporthub/sciencedirect/ "What’s this? (Opens in new window)")

The following are the Supplementary data to this article:[Download: Download Word document (48KB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-mmc1.docx "Download Word document (48KB)")

Supplementary Data 1.

[Download: Download Word document (2MB)](https://ars.els-cdn.com/content/image/1-s2.0-S2214514125000261-mmc2.docx "Download Word document (2MB)")

Supplementary Data 2.

Recommended articles

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
    

## Cited by (0)

© 2025 Crop Science Society of China and Institute of Crop Science, CAAS. Production and hosting by Elsevier B.V. on behalf of KeAi Communications Co., Ltd.