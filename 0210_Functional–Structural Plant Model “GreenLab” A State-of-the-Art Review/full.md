[Home](/ "Home") [Plant Phenomics](/journal/plantphenomics  "Plant Phenomics") [Table Of Contents](/index/plantphenomics  "Table Of Contents") Functional–Structural Plant Model “GreenLab”: A State-of-the-Art Review

[Back To Table Of Contents](/index/plantphenomics "Back To Table Of Contents")

Open access

Review Article

Share on

*   
*   
*   
*   

# Functional–Structural Plant Model “GreenLab”: A State-of-the-Art Review

[Xiujuan Wang](#con1) [https://orcid.org/0000-0001-8327-1735](https://orcid.org/0000-0001-8327-1735), [Jing Hua](#con2), \[...\] , [Mengzhen Kang](#con3) [https://orcid.org/0000-0002-5016-1772](https://orcid.org/0000-0002-5016-1772), [Haoyu Wang](#con4), and [Philippe de Reffye](#con5)+2 authors fewer[Authors Info & Affiliations](#tab-contributors)

Plant Phenomics

7 Feb 2024

Vol 6

Article ID: 0118

[DOI: 10.34133/plantphenomics.0118](https://doi.org/10.34133/plantphenomics.0118)

[

2,41011](# "Metrics")

### Metrics

#### Total Downloads2,410

*   Last 6 Months709
*   Last 12 Months1,523

#### Total Citations11

*   Last 6 Months4
*   Last 12 Months11

[View all metrics](?doi=10.34133/plantphenomics.0118#core-collateral-metrics "Go to metrics page")

[](#tab-citations "CITE")

[](/doi/reader/10.34133/plantphenomics.0118 "PDF")

## Abstract

It is crucial to assess the impact of climate change on crop productivity and sustainability for the development of effective adaptation measures. Crop models are essential for quantifying this impact on crop yields. To better express crops’ intrinsic growth and development patterns and their plasticity under different environmental conditions, the functional–structural plant model (FSPM) “GreenLab” has been developed. GreenLab is an organ-level model that can describe the intrinsic growth and development patterns of plants based on mathematical expressions without considering the influence of environmental factors, and then simulate the growth and development of plants in expressing plant plasticity under different environmental conditions. Moreover, the distinctive feature of GreenLab lies in its ability to compute model source–sink parameters affecting biomass production and allocation based on measured plant data. Over the past two decades, the GreenLab model has undergone continuous development, incorporating novel modeling methods and techniques, including the dual-scale automaton, substructure methods, the inverse of source–sink parameters, crown analysis, organic series, potential structure, and parameter optimization techniques. This paper reviews the development history, the basic concepts, main theories, characteristics, and applications of the GreenLab model. Additionally, we introduce the software tools that implement the GreenLab model. Last, we discuss the perspectives and directions for the GreenLab model’s future development.

## Introduction

Food security is increasingly challenged worldwide due to climate change and the rapidly growing populations \[[1](#core-collateral-B1)\]. According to the World Population Prospects 2022 report released by the United Nations \[[2](#core-collateral-B2)\], the global population is expected to reach 9.7 billion by 2050, making it crucial to assess the impact of climate change on crop yields and explore effective strategies for future agricultural sustainability \[[3](#core-collateral-B3)\].

To tackle the challenges of climate change, two main strategies are generally taken. The first involves genetic improvements aiming at developing new crop varieties that are better adapted to changing climate conditions and more efficient in the use of resources. The second strategy involves adjustments to crop management practices. However, it is crucial to quantify and assess the impacts of both genetic improvement and management adjustments on crop production \[[3](#core-collateral-B3)\]. Furthermore, to develop effective adaptation measures, it is essential to estimate how climate change will affect crop productivity and sustainability \[[4](#core-collateral-B4)\].

The growth of crops is influenced by a combination of genetic factors (G), environment (E), and management measures (M) \[[5](#core-collateral-B5)\]. Crop models are specifically designed to simulate G × E × M interactions, which can assess the impact of climate change on crop production and identify appropriate adjustment measures to counteract any negative effects of climate change on yield \[[6](#core-collateral-B6)\]. As a result, crop models are considered a crucial tool for quantifying the impact of climate change on crop yields \[[5](#core-collateral-B5)\].

Crop models can be categorized into two types: (a) statistical models (SMs), also known as data-based models, and (b) process-based models (PBMs), also known as knowledge-based models. The former directly establishes the relationship between environmental inputs and yield outputs without concerning the inherent growth processes of the crops \[[7](#core-collateral-B7),[8](#core-collateral-B8)\]. The latter, on the other hand, focuses on describing the essential physiological and physical processes that influence yield formation \[[9](#core-collateral-B9)–[11](#core-collateral-B11)\].

SMs primarily include empirical regression methods, machine learning (ML) algorithms, and deep learning (DL) algorithms \[[12](#core-collateral-B12)\]. Compared to PBMs, SMs demonstrate relatively higher predictive capability when sufficient training data are available. However, this also means that they heavily rely on the data \[[13](#core-collateral-B13)\]. Due to the highly complex nonlinear relationships between crop yield and input variables, issues like overfitting, prolonged training, and relatively fewer hidden layers restrict their ability to address nonlinear problems and predict crop yields over large areas \[[14](#core-collateral-B14),[15](#core-collateral-B15)\]. PBMs simulate various processes in crops, such as photosynthesis and assimilate allocation. They primarily use the leaf area index (LAI) to predict biomass yield per unit of land area and consider the influence of environmental factors like light radiation, temperature, and management practices (irrigation, fertilization, etc.). Common PBMs include DSSAT (Decision Support System for Agrotechnology Transfer) \[[16](#core-collateral-B16)\], TomSim \[[17](#core-collateral-B17)\], STICS (Simulateur mulTIdisciplinaire pour les Cultures Standard) \[[18](#core-collateral-B18)\], and APSIM (Agricultural Production Systems sIMulator) \[[19](#core-collateral-B19)\].

PBMs often consider different types of organs, focusing on the total fruit weight, leaf weight, etc., making it difficult to describe the influence of changes in crop structure on yield. During their growth, plants undergo various adaptive responses in terms of intrinsic physiology and external morphology by regulating their characteristics, such as size, number, and growth volume, to minimize adverse effects of the environment. Therefore, to accurately predict crop yield, crop models need to consider the environmental effects on plant structure. To better express the intrinsic growth and development patterns of crops and their plasticity under different environmental conditions, functional–structural plant models (FSPMs) have been developed. This led to the development of organ-level FSPMs, which simulate crop morphological structure, biomass production and allocation, and the inherent relationships between them \[[20](#core-collateral-B20),[21](#core-collateral-B21)\]. These models operate at a finer scale, providing more detailed simulations of crop growth. Representative models in this category include ALMIS \[[22](#core-collateral-B22)\], LIGNUM \[[23](#core-collateral-B23)\], L-Peach \[[24](#core-collateral-B24)\], and GreenLab \[[25](#core-collateral-B25)\]. FSPMs simulate the two basic processes of plant growth and development by combining physiological functions to represent three-dimensional (3D) plant structure \[[20](#core-collateral-B20)\], and link the joint effect of internal growth and external environment with plant architecture \[[26](#core-collateral-B26)\].

The GreenLab model is one of the FSPMs, taking into account the characteristics of the sequential production of similar organs and adopting the concept of a common pool and source–sink relationship. It models plant growth at the leaf element (organ) scale while maintaining compatibility with PBMs (at the population level). To build the GreenLab model, an architectural model was coupled with a growth model with source–sink functions of individual organs \[[27](#core-collateral-B27)\]. This framework formalized the organogenesis, photosynthesis, and morphogenesis processes of plants. Unlike PBMs, which model the sink and source processes at the whole plant level, GreenLab models these processes at the level of individual organs, each having its age according to its position within the plant structure \[[28](#core-collateral-B28)\]. This allows a more detailed and accurate simulation of plant growth and development.

Based on the plant automaton, in the GreenLab model, a recursive algorithm is used to calculate the number of organs produced at each time step, and the biomass saved in the common pool is distributed to different categories of organs based on their age, the relative sink strength, and organ numbers. This process is described by mathematical formulas, eliminating the need to simulate the biomass allocation of each organ individually, making it faster and requiring less time, which is one of the advantages of the GreenLab model. The distinctive feature of GreenLab lies in its ability to compute model source–sink parameters affecting biomass production and allocation based on measured plant data such as the weight of each plant organ. Additionally, the model’s effectiveness can be determined through simulation, which reduces the need for extensive data collection \[[29](#core-collateral-B29)\]. Based on generic botanical and eco-physiological knowledge, the model has been applied to study over a dozen crops, such as corn, wheat, rapeseed, cucumber, and tomato \[[30](#core-collateral-B30)\]. However, the GreenLab model simplifies the effects of environmental factors into a single environmental factor “_E_,” which cannot effectively simulate the effects of climate, soil, and management practices on crop yield.

This paper reviews the development course, the basic concepts, the main theories and characteristics, the applications of the GreenLab model, and the software tools. The “The Developmental History of the GreenLab Model” section presents the developmental history of the GreenLab model. The “The GreenLab Model” section introduces the concepts and assumptions used in the GreenLab model. The “Applications of the GreenLab Model” section presents the applications in crops and trees. The “Software” section presents the software tools implemented based on the GreenLab model. The “Perspectives” section gives the perspectives and future directions of the GreenLab model. The “Conclusions” section gives conclusions.

## The Developmental History of the GreenLab Model

The GreenLab model originated from the AMAP (botAny and Modelling of Plant Architecture and vegetation) modeling approach, inheriting botanical concepts from AMAPsim \[[31](#core-collateral-B31),[32](#core-collateral-B32)\] such as physiological age (PA) and reiteration growth, as well as the source–sink concept from AMAPHydro \[[33](#core-collateral-B33)\]. The AMAP plant library is based on the architectural models proposed by Hallé et al. \[[34](#core-collateral-B34)\], which ensures that the simulation of plant development is faithful to botanical principles \[[35](#core-collateral-B35)\]. This feature laid the foundation for the application of the model in agronomy.

To meet the need for growth process models, the simulations of biomass production and distribution were introduced into the AMAP models, and AMAPHydro was proposed, which uses water as the growth driver \[[33](#core-collateral-B33)\]. Since 1998, based on the Sino-French Joint Laboratory (LIAMA), the cooperation between the Institute of Automation, Chinese Academy of Sciences (CASIA) in China and the International Cooperation of Agronomy Research and Development Centre (CIRAD) in France was established, leading to the development of the organ-scale FSPM “GreenLab” (Chinese name Qingyuan), which inherits key concepts of the AMAP model series. Over the past 20 years, several institutes and universities have contributed to its development, including China Agricultural University (CAU), Chinese Academy of Forest (CAF) in China, and French National Research Institute for Digital Science and Technology (INRIA), Ecole Centrale Paris (ECP) in France, as shown in Fig. [1](#).

OPEN IN VIEWER

![](/cms/10.34133/plantphenomics.0118/asset/04e95cda-2e63-4bb3-9498-d8d6e8b06b1b/assets/graphic/plantphenomics.0118.fig.001.jpg)

Fig. 1. Developmental history of the GreenLab model. The GreenLab model originated from the AMAP modeling approach, inheriting botanical concepts from AMAPsim and AMAPHydro, which was developed within the collaborative efforts of the Sino-French Joint Laboratory (LIAMA) in 1998. The GreenLab model progressed through various iterations, including GL1 (deterministic model), GL2 (stochastic model), GL3 (deterministic model with feedback mechanisms), and eventually GL4 and GL5 (stochastic model with feedback mechanisms). Notably, GL5 represents a fine time-scale model for trees, which can simulate the growth and development of trees within a year.

The architectural model in GreenLab is based on the concepts of AMAPSim \[[31](#core-collateral-B31)\] and can simulate the 23 botanical architectural models \[[34](#core-collateral-B34),[36](#core-collateral-B36)\]. It is designed to simulate complex plant structures, including trees, by organizing the model according to PA and using only a limited number of parameters. This makes it easy for users to construct even very intricate plant structures. The functional model shares the hypothesis and concepts of PBMs, such as the common pool, the sink strength, and the sink variation. Therefore, the loop of plant growth is compatible with other PBMs.

GreenLab is a plant growth and development model that has been developed and refined over several levels of complexity. The initial model, GL1, is deterministic and relies on predefined rules for plant development \[[27](#core-collateral-B27)\]. The structure of plants is fixed and unable to adapt to internal or external factors \[[27](#core-collateral-B27),[37](#core-collateral-B37)\], which limits its applicability to single-stemmed species, such as maize and sunflower. The GL2 model incorporates stochastic development and probabilistic bud outbreak to simulate the variation in plant structures \[[26](#core-collateral-B26),[28](#core-collateral-B28),[38](#core-collateral-B38)\], making it useful for assessing and comparing different cultivars or breeding programs aiming at developing plants with stable and reproducible behavior (low variation among individuals). This modeling strategy permits considering intra- and inter-individual variation and describing the statistical outputs of a population like mean and standard deviation rather than the results of individual plants. The GL3 model is deterministic, but the development is controlled by a state variable known as the supply-to-demand ratio \[[39](#core-collateral-B39)\], which creates a feedback loop between development and functioning that makes the model dynamics self-regulating. The GL4 model incorporates the feedback mechanism of supply-to-demand ratio as a determinant of the stochastic plant development processes, resulting in a decrease in the root mean squared error \[[40](#core-collateral-B40)\]. A more systematic parameterization methodology of GL4 has been described by Letort et al. \[[29](#core-collateral-B29)\]. The GL5 model is a stochastic model with interaction between the development and growth of trees at a finer temporal scale, which can simulate multiple growth flushes of trees within a single growing season \[[25](#core-collateral-B25)\], making it useful for simulating the growth and development of perennial plants that undergo multiple growth cycles. Overall, the GreenLab model is a valuable tool for simulating plant growth and development, and its different versions offer a range of options for researchers to choose depending on their specific needs and research questions.

## The GreenLab Model

### Concepts and assumptions

The GreenLab model is a dynamic model that uses discrete simulation to model the production and allocation of biomass at the level of individual plant organs. It combines both functional and structural descriptions of physiological processes, including phytomer-level structures, making it possible to study the model at both organ and stand levels.

The GreenLab model uses some important notions \[[25](#core-collateral-B25),[26](#core-collateral-B26)\]: (a) temporal scale. Three distinct ages are used to characterize a meristem: chronological age (CA), which denotes the duration of organ/plant functioning since its creation; PA, which indicates its level of differentiation in the aging process; and ontogenic age (OA), which corresponds to the time of its creation within the plant structure. Chronological and ontogenic ages are measured in development cycles (DCs), which serve as the fundamental unit of duration that governs plant development. During each DC, a meristem can produce either a phytomer or a pause. The cycle is measured in thermal time rather than calendar time, as it regulates the overall development process. (b) Spatial scale. Three kinds of concepts are defined to describe the structure of plants: organic series, which is the dimension or weight of organs produced sequentially along an axis of development; cohorts are a set of organs of the same nature, created at the same time by the parallel functioning of meristems; and plant crowns (the combination of primary bearing axes and secondary ramified axes).

The model incorporates eco-physiological concepts from crop models such as thermal time, light use efficiency (LUE), water use efficiency (WUE), and a common pool, among others, as described by de Reffye et al. \[[25](#core-collateral-B25)\]. To combine plant organogenesis and plant photosynthesis, the GreenLab model uses plant architectural models defined by Hallé \[[34](#core-collateral-B34)\], duel-scale automaton theory \[[41](#core-collateral-B41)\], and substructure-based algorithm \[[42](#core-collateral-B42)\]. GreenLab uses a dual-scale automation approach to generate stochastic structures of plants, which integrates botanical knowledge, such as phytomers and growth units (GUs), to construct topological and morphological structures of plants through a graph-based interface \[[43](#core-collateral-B43),[44](#core-collateral-B44)\]. For more complex applications involving trees or plantations, the GreenLab model employs a strategy of substructures \[[45](#core-collateral-B45)\] for efficient construction of plants and yields calculation based on organ production. Using the same temporal scale for development and growth, the model simulates plant growth behavior recurrently and can be applied to a range of plant types, from herbaceous plants to trees. While the basic structure of the model is generic, corresponding submodules can be introduced for different plant species.

The GreenLab model employs compact mathematical equations with integrated parameters for plant growth simulation, allowing easy parameterization. Organs of the same features share the same function, without requiring a complex plant structure description that can be laborious. In the model, plants start from a seed, which provides the initial source, allocate biomass to existing organs based on the source–sink relationship, make photosynthesis according to functioning leaf area, and determine the number and size of organs at different stages. The model iteratively simulates plant growth cycle by cycle until it ceases (Fig. [2](#)), providing a comprehensive understanding of biomass production and partitioning. At the end of the simulation, the plant’s architecture can be displayed in 2D or 3D format \[[29](#core-collateral-B29),[46](#core-collateral-B46)\].

OPEN IN VIEWER

![](/cms/10.34133/plantphenomics.0118/asset/9bb85074-cf5b-491c-bffa-aa7d703eecaa/assets/graphic/plantphenomics.0118.fig.002.jpg)

Fig. 2. A diagram depicting the simulation process of the GreenLab model. The green rectangles represent the development, and the blue circles represent the growth. The model outputs and the computed model parameters are given. Biomass production can be computed through photosynthesis (in orange).

### Modeling plant development and growth

Plant morphogenesis arises from two main phenomena: development and growth. Development is facilitated by the functioning of meristems, which give rise to a plant structure comprising branched axes composed of phytomers in a series. On the other hand, growth is the process of biomass accumulation in the plant system through photosynthesis. This growth is regulated by source–sink relationships, where organs perform their functional roles. It ensures the increase in biomass of the organs formed during development.

In this review, we will not give detailed descriptions of modeling plant development and growth, which can be found in \[[25](#core-collateral-B25),[30](#core-collateral-B30)\]. Instead, we will provide a concise overview of the important concepts used in the GreenLab model and highlight their roles.

#### A botanical automaton to simulate the development

A phytomer is a fundamental unit in plant structure, consisting of an internode that terminates in a node where organs like leaves, fruits, and axillary meristems are attached. Depending on whether the flowering occurs at the axis or the tip, it can be axial or terminal. To simulate the growth and development of plant structures, it is sufficient to describe the rules that govern the PA of newly produced phytomers. To accomplish this, a dual-scale automaton approach using graph-based notations \[[36](#core-collateral-B36)\] was developed. Structures can be simple or compound, depending on whether meristems function continuously or rhythmically. In the latter case, mainly in trees, the automaton is on a double scale, with two temporal scales being considered and meristems setting up the GUs. The micro-temporal cycle corresponds to the creation of a phytomer, while the macrocycle represents the construction of a GU. Structural factorization is highly efficient in designing, understanding, or simulating plant architecture models \[[45](#core-collateral-B46)\]. Over recent years, there has been significant progress in extending the formalism to encompass stochastic cases. This has been achieved by introducing probabilities to represent the likelihood of transition occurrences. Furthermore, this extended formalism has undergone validation across numerous plant species \[[25](#core-collateral-B25),[26](#core-collateral-B26),[29](#core-collateral-B29)\].

#### Modeling biomass production and partitioning

The GreenLab model, similar to other crop models, uses the concept of a common pool that stores synthesized biomass and distributes it to organ compartments \[[25](#core-collateral-B25)\]. The model uses a discretized beta law function to define the sink function \[[47](#core-collateral-B47)\], and the plant demand at a given age is calculated as the sum of the active sink organs. The number of phytomers produced by the botanical automaton determines the number of leaves, internodes, and fruits produced in each cycle.

To compute biomass production and partitioning, first the biomass supply is required. Like other crop models, it uses Beer–Lambert’s law to calculate biomass production per unit of cultivated area and per unit of time. Then, plant demand is calculated in each DC, and the biomass growth of an organ depends on the value of its sink and the ratio of the biomass supplied in the previous cycle to the current demand.

### Model parameter estimation

As the GreenLab model consists of two modules, one for organogenesis (development) and the other for organ growth, its key parameters can be categorized into two parts as well. The first set of parameters for plant development, which includes branching rate, growth rate, and mortality rate, is computed using the measured number of phytomers along the stem from the top to the bottom, a method known as plant crown analysis \[[48](#core-collateral-B48)\]. On the other hand, the second set of parameters for organ growth, which includes the source parameters, such as seed biomass (_Q_0), projected surface (_Sp_), and resistance coefficient (_r_, related to LUE or WUE), and the sink parameters, such as sink strengths (_Po_, _o_ represents leaf, internode, fruit, etc.) and the variations of sink strengths (_Bo_), are identified by fitting the measured organic series and controlling the functional model. As explained before, the description of each organic series contains all the necessary information for development and growth. Through adapted sampling within the organic series, effective targets for calibration of the source–sink parameters can be defined using experimental data. Organic series are constructed by sampling within the plant architecture, and measurements can be taken at multiple growth stages. Besides, some empirical parameters are needed, such as the expansion time and functioning time of organs, and leaf thickness, which can be obtained according to the observed data during the growth of plants.

The process of identifying parameters in the GreenLab model involves three steps: (1) measuring the architecture of the plant, including the number of leaves, internodes, fruits, and the number of phytomers within the stem and branches, thus to know the topological structure of the entire plant (to know the development parameters) and also the times of expansion and functioning of each type of organs; (2) constructing target data (organic series and/or compartment data) by measuring dry or fresh weights of each organ (leaves, internodes, fruits, etc.); (3) fitting the target data and estimating functional source–sink hidden parameters. The developmental parameters, such as growth and branching rates, are determined using the crown analysis method as mentioned above. Model calibration can be done by single fitting, where only one stage of data is used to fit the organs, or multi-fitting, which involves using data from multiple growth stages to fit the organic series \[[47](#core-collateral-B47)\].

As such, the GreenLab model can simulate the dynamic progression of plant growth and development while relying on a stationary plant architecture (Fig. [3](#)). By analyzing plant architecture data, GreenLab can compute the size and weight of organs at different stages, and then estimate source and sink parameters using the weighted least square method (WLSM) with measured data. Calibration of the model on real plants is a crucial step for its application, but it is a time-consuming and tedious process. Therefore, GreenLab defines a uniform data sampling scheme to simplify the measurements \[[25](#core-collateral-B25),[26](#core-collateral-B26)\].

OPEN IN VIEWER

![](/cms/10.34133/plantphenomics.0118/asset/838450a1-017f-4150-b3b8-656885e914c5/assets/graphic/plantphenomics.0118.fig.003.jpg)

Fig. 3. Parameter estimation framework for the GreenLab model. The GreenLab model can perform dynamic plant growth and development based on static plant architecture. By analyzing plant architecture data, GreenLab can compute the size and weight of organs at various stages. Subsequently, it estimates source and sink parameters from the measured data using the WLSM. This process enables GreenLab to describe the story of biomass production and partitioning within the plant. Finally, the model can display the plant in 2D or 3D.

## Applications of the GreenLab Model

Plant structures can be categorized into various architectural models based on different modes of meristem functioning (continuous/rhythmic/polycyclic, definite/indefinite), branching patterns (monopodial/sympodial), and flowering types (apical/lateral). These architectural models proposed by Hallé et al. \[[34](#core-collateral-B34)\] constitute a comprehensive set that covers all types of plants. By utilizing specific sampling strategies and appropriate parameter estimation methods (WLSM), plant system parameters can be identified. This approach enables the effective modeling of many herbaceous and woody plants, as they can be accommodated within these architectural models.

The GreenLab model has been successfully applied to both temperate and tropical species, covering continuous growth and rhythmic growth, and accounting for the stochastic effects of phytomer development, branching, and viability. The development and growth parameters of the model have been satisfactorily estimated using crown and organic series analysis \[[25](#core-collateral-B25)\] for over 20 plant species; the description and the characteristics of development and growth for the main species are listed in Table [1](#). Figure [4](#) shows the 3D visualization of plants for various species.

OPEN IN VIEWER

| Plants pecies | Plant description | Developmental and growth patterns | References |
| --- | --- | --- | --- |
| Field crops |     |     |     |
| Maize | A single-stemmed plant, deterministic and continuous development. After an initial rosette stage, the stem lengthens and the development stops after about 20 phytomers (depending on varieties) following terminal flowering with the formation of a male flower. | Basic phytomer: an internode, a leaf made of a blade, and a sheath.Mask file: to note the position of the cob within the plant.Simple organic series: the blades, sheaths, internodes, and ears on the stem. | \[[47](#core-collateral-B47),[49](#core-collateral-B49),[50](#core-collateral-B50)\] |
| Sunflower | A single-stemmed plant, deterministic and continuous development.After an initial rosette stage, the stem lengthens and the development stops following terminal flowering (Capitulum). | Basic phytomer: an internode, a blade, and a petiole.Mask file: to note the position of the capitulum.Simple organic series: the blades, petioles, internodes, and caps on the stem. | \[[27](#core-collateral-B27),[79](#core-collateral-B79),[98](#core-collateral-B98)\] |
| Beetroot | A single-stemmed plant, deterministic and continuous development. | Basic phytomer: a leaf.Simple organic series: the rosette of leaves and the tape root on the stem. | \[[91](#core-collateral-B91)\] |
| Wheat | A branched plant, stochastic and continuous development, characterized by an initial rosette-like stage, followed by an elongation of the stem which ends in an ear. A variable number of secondary stems, called tillers, are issued at the same time as the main stem at the rosette stage. Remobilization of leaves needs to be considered. | Basic phytomer: an internode, a leaf, and a sheath.Crown analysis: the probabilities of growth, branching, and mortality were computed.Simple organic series: leaf, sheath, internode, ear on the main stem;Compound organic series: compartments of each type of organ for tillers. | \[[99](#core-collateral-B99)\] |
| Rice | A branched plant, stochastic and continuous development characterized by an initial rosette-like stage, followed by an elongation of the stalk ending in a spike. Tillers are issued at the same time as the main stem at the rosette stage. Remobilization of leaves needs to be considered. | Basic phytomer: an internode, a leaf, and a sheath.Mask file: to note the positions of the tillers and fruits within the plant.Simple organic series: blade, sheath, internode, and terminal spike for the stem and tillers. | \[[100](#core-collateral-B100),[101](#core-collateral-B101)\] |
| Cotton | A branched plant, and the stems and vegetative branches of the plant have deterministic and continuous development. They have monopodial branching and bear fruiting branches with a sympodial structure. | Basic phytomer: an internode, a blade, and a petiole.Three PAs: the stem, its vegetative branches, and the fruiting branches.Mask file: to note the positions of the tillers and fruits within the plant.Simple organic series: blades, petioles, and internodes for the stem and branches. | \[[102](#core-collateral-B102)–[104](#core-collateral-B104)\] |
| Horticultural crops |     |     |     |
| Tomato | A branched plant with a sympodial modular structure, but one of the branches is pruned, leaving a stem with a continuous development at the beginning and after a rhythmic development. The expansion of fruits has a delay. | Basic phytomer: an internode, a blade, a petiole, and a fruit.One PA: the stem, a single-stemmed plant was analyzed.Mask file: to note the position of the fruits.Simple organic series: blades, petioles, internodes, and fruits on the main stem. | \[[51](#core-collateral-B51),[52](#core-collateral-B52),[105](#core-collateral-B105),[106](#core-collateral-B106)\] |
| Cucumber | A single-stemmed plant whose stem, in the shape of a vine, has continuous development and growth. The expansion of fruits has a delay. | Basic phytomer: an internode, a blade, a petiole, and a fruit.One PA: the stem, a single-stemmed plant was analyzed.Mask file: to note the position of the fruits.Simple organic series: blades, petioles, internodes, and fruits on the main stem. | \[[53](#core-collateral-B53),[85](#core-collateral-B85),[107](#core-collateral-B107)\] |
| Sweet pepper | A branched plant with stochastic and continuous development. After germination, the unbranched stem stops its development early because of an apical flowering that produces the first fruit. Two sympodial branches of equal vigor are born immediately under the last two phytomers of the stem. Their continuous development is limited to a few phytomers, after which branching becomes sympodial. | Basic phytomer: an internode, a blade, a petiole, and a fruit. Three PAs: main stem, branches, and twigs. Mask file: to note the position of the branches and fruits. Simple organic series: blades, petioles, internodes, and fruits on the main stem, branches, and twigs (12 organic series). The topological structure of a plant is simplified to facilitate measurements and target preparation. | \[[55](#core-collateral-B54),[108](#core-collateral-B108),[109](#core-collateral-B109)\] |
| Herbaceous plants with inflorescences |     |     |     |
| Arabidopsis | A single-stemmed plant at the vegetative stage with deterministic and continuous development. The beginning of the growth for the _Arabidopsis_ is in a rosette form. At the generative stage, branching inflorescence appears. | Basic phytomer: a leaf. One PA: the stem Simple organic series: leaves. | \[[58](#core-collateral-B57),[59](#core-collateral-B58),[93](#core-collateral-B93)\] |
| Canola | A branched plant with stochastic and continuous development. The beginning of the growth is in a rosette form. Following the emergence of the leaves, internodes of the main stem begin to elongate. At the growth end, the apical meristem of the stems transforms into an inflorescence. Flower emergence starts on the main inflorescence and develops basipetally to the lateral inflorescences, while the flowers within the inflorescence have an acropetal flowering sequence. Remobilization needs to be considered. | Basic phytomer: an internode, a leaf, and potentially a ramification. Two PAs: main stem and ramifications. Crown analysis: the development parameters rhythm ratio, branching rate, and growth rate are computed. Simple organic series: leaves, internodes, and fruits on the main stem;Compound organic series: the organs of the same type (leaves, internodes, fruits) are weighed separately for ramifications. Delay function: to simulate the basipetal pattern of raceme development. | \[[60](#core-collateral-B59)–[63](#core-collateral-B62)\] |
| Chrysanthemum | Chrysanthemum is a short-day plant with stochastic and continuous development, having a basipetal flowering sequence. | Basic phytomer: an internode, a leaf, and potentially a flowering branch.Three PAs: main stem and ramifications.Simple organic series: leaves, internodes, and fruits on the main stem and ramifications.Delay function: to simulate the basipetal pattern of raceme development. | \[[56](#core-collateral-B55),[57](#core-collateral-B56),[64](#core-collateral-B63)\] |
| Spilanthes | A branched plant with a stochastic and continuous development. The stem is short and the shoots spread. All axes end with a terminal flower. After a minimal rosette stage, the stem elongates and places a small number of phytomers, then the apical flowering stops development, and the preformed lateral branches begin to expand with acropetal development. If conditions allow, the preformed third-order branches begin their expansion with a basipetal development. | Basic phytomer: an internode, two leaves, and potentially two twigs.Three PAs: main stem, branches, and twigs.Crown analysis: the development parameters rhythm ratio, branching rate, and growth rate are computed.Simple organic series: leaves, internodes, and fruits on the main stem;Compound organic series: the organs of the same type of ramification are weighed separately by compartments (leaves, internodes, fruits) for ramifications.Delay function: to simulate the basipetal pattern of raceme development. | \[[40](#core-collateral-B40)\] |
| Trees |     |     |     |
| Coffee | Coffee is a woody shrub plant with a stochastic and continuous development. The stem is orthotropic, and each phytomer has 2 leaves with potentially 2 plagiotropic branches. At the young stage, there is no mortality or flowering. | Basic phytomer: an internode and two leaves.Three PAs: main stem, branches, and twigs. Crown analysis: the development parameters rhythm ratio, branching rate, and growth rate are computed.Simple organic series: leaves, internodes on the main stem.Compound organic series: leaves, internodes, and fruits on the branches. | \[[29](#core-collateral-B29),[110](#core-collateral-B110),[111](#core-collateral-B111)\] |
| Pine | The pine tree is a conifer species with a stochastic and rhythmic development. Each year, the terminal meristems produce a new GU. The stochastic aspect only exists in the distribution of the number of branches per whorl. | Basic phytomer: an internode, a needle, and rings. The needles are considered as a single-leaf organ.Two PAs: main stem and branches. The growth cycle is the year.Crown analysis: the development parameters branching rate was computed.Simple organic series: the leaves and internodes of the stem and branches. | \[[38](#core-collateral-B38),[65](#core-collateral-B64),[66](#core-collateral-B65),[112](#core-collateral-B112),[113](#core-collateral-B113)\] |
| Teak | The teak is a tropical tree with stochastic and polycyclic development. It has polycyclic growth and branching. Its axes consist of a succession of GUs. Its flowering is terminal and generally occurs during the 5th year of growth. At the same time, the development of the axes, initially monopodial, becomes sympodial. | Basic phytomer: an internode, a leaf, and rings.GU: grouped according to their PA and CA and their ranks in the annual shoot.Four PAs: main stem and three orders of branches.Crown analysis: the development parameters branching rate was computed.Compound organic series: only the weights of the leaf and internode compartments per GU were measured. | \[[46](#core-collateral-B46)\] |

Expand for more

Table 1. Plant species studied with the GreenLab model and the descriptions of the corresponding models

OPEN IN VIEWER

![](/cms/10.34133/plantphenomics.0118/asset/2d861ddd-552e-43e2-a857-0345aedf0ccb/assets/graphic/plantphenomics.0118.fig.004.jpg)

Fig. 4. Plant species studied with the GreenLab model. The GreenLab model has demonstrated its versatility by successfully studying a wide range of plant species, including both temperate and tropical species with continuous growth and rhythmic growth. The development and growth parameters of the model have been effectively estimated for more than 20 plant species, including field crops, horticultural crops, herbaceous plants, and trees.

To calibrate the model for each species, the process involves a few steps. First, the PA, CA, leaf thickness, expansion time, and functioning time of organs are collected based on observations during growth. Second, the development patterns of plants are analyzed and set. If a plant’s development follows a stochastic pattern, the developmental parameters are determined through two methods: a “mask” file is used to specify the positions of branches and fruits, essentially treating them as having deterministic development; alternatively, probabilities of growth, branching, and mortality are calculated using crown analysis method if the development is considered stochastic. Last, the source–sink parameters are estimated according to the measured weights of organs at different developmental stages, using either single or multi-stage fitting techniques.

### Modeling of field crops

For single-stemmed field crops, like maize, sunflower, and beetroot, their development patterns are treated as deterministic and continuous. The GreenLab model can directly compute model parameters using measured organ weights. However, for plants with branching like cotton, rice, and wheat, their developments are stochastic and continuous. To address this, a “mask” file has been used to document branch and fruit positions, transforming their stochastic growth into a deterministic form for cotton and rice. In the case of wheat, considered as a stochastic plant, initial developmental parameters such as branching rate, growth rate, and mortality are determined from observed data. Subsequently, the model parameters are fine-tuned by matching them with the measured organ weights. In the case of maize, it has been confirmed that the sink parameters remain consistent across different planting densities and growing seasons \[[49](#core-collateral-B49),[50](#core-collateral-B50)\]. This stability in sink parameters holds significance for breeding efforts, as it allows for the identification of traits that remain unchanged despite fluctuations in the environment.

### Modeling of horticultural crops

For horticultural crops, such as tomato \[[51](#core-collateral-B51),[52](#core-collateral-B52)\] and cucumber \[[53](#core-collateral-B53)\], their development follows deterministic and continuous patterns. The GreenLab model has been used to calibrate model parameters specifically for single-stemmed plants. In the case of branched plants like pepper \[[54](#core-collateral-B70)\], a mask file has been used to document fruit positions, effectively converting their stochastic growth into a more deterministic trajectory. These species’ yield formation is primarily influenced by the quantity and size of their fruits, underscoring the importance of accurately simulating fruit sets within these crop models. The GreenLab model has established a relationship between the internal source-to-reservoir ratio and fruit set through parameter inversion \[[51](#core-collateral-B51),[55](#core-collateral-B54)\]. However, it is important to note that additional experiments are required to validate these predictions. In addition, studies have delved into understanding the variation in yield formation between different cucumber cultivars \[[53](#core-collateral-B53)\] and integration lines for tomatoes \[[52](#core-collateral-B52)\] using optimization algorithms. Nonetheless, the accuracy of these predictions needs validation through an extensive array of experiments.

### Modeling of herbaceous plants with inflorescences

The GreenLab model has specific adaptations for the growth and development of herbaceous plants with inflorescences \[[56](#core-collateral-B55)\]. In these plants, phytomers are created as a result of meristem activity, and organ expansion occurs following biomass accumulation. Herbaceous plants with inflorescences show great architectural variability and undergo two primary developmental stages: vegetative and reproductive. During the initial vegetative phase, phytomers are established according to the rules of botanical automaton, but their expansion does not occur immediately after creation. Instead, branches remain preformed until flowering initiation, with a delay influenced by creation time, branch type, and position within the topological structure generated by the development schedule. To model this delay in branch development, a delay function has been introduced \[[56](#core-collateral-B55),[57](#core-collateral-B56)\]. The GreenLab model has been successfully applied to model herbaceous plants such as Arabidopsis \[[58](#core-collateral-B57),[59](#core-collateral-B58)\], canola \[[60](#core-collateral-B59)–[63](#core-collateral-B62)\], chrysanthemum \[[56](#core-collateral-B55),[57](#core-collateral-B56),[64](#core-collateral-B63)\], and spilanthes \[[40](#core-collateral-B40)\].

### Modeling of trees

The GreenLab model can simulate growth rings and estimate their parameters through inverse estimation. This feature is unique to the model and distinguishes it from other functional structure models for trees, which have been extensively calibrated. Growth rings are first considered as an organ that competes with others, and the biomass allocated to them is then distributed to different internodes according to two different rules (e.g., Pressler law).

Apart from GreenLab, there are few FSPMs for trees that have been calibrated, meaning that the model parameters are determined based on tree measurement data to ensure that the calculated number of organs and biomass are consistent with the measured data. Representative model applications include a deterministic model for _Pinus tabulaeformis_ \[[65](#core-collateral-B64)\], a stochastic model for _Pinus sylvestris_ \[[38](#core-collateral-B38),[66](#core-collateral-B65)\] (which can reflect the differences in individual structures and their impact on biomass), and a feedback model for _Fagus sylvatica_ \[[67](#core-collateral-B66)\] (which establishes a relationship between the number of branches and the source–sink ratio).

The temporal scale of GreenLab for trees is generally annual, but more recently, a fine time-scale model has been developed for multiple pruning of trees \[[68](#core-collateral-B67)\], which is adapted to more complex cases where tree architectural development and biomass production occur simultaneously during long periods, where polycyclism, anticipated growth, or neoformation occurs. Periods of extension and rest can occur successively between GUs but also within GUs \[[68](#core-collateral-B67)\]. Indeed, GreenLab has been applied to several tree species, such as the simple structures like coffee and pine trees, and the complex structures like maple, teck \[[46](#core-collateral-B46)\], and khaya trees. Although we have not delved into the specifics here, it is worth mentioning that details regarding the results of maple and khaya trees are pending publication.

## Analyses of Model Behaviors

In addition to being calibrated for various species, the GreenLab model has also been applied to the optimization of maize yield \[[69](#core-collateral-B68)\] and tree wood production \[[70](#core-collateral-B69)\], irrigation \[[54](#core-collateral-B70)\], and plasticity of trees under different light conditions \[[71](#core-collateral-B71)\] and wind effect \[[72](#core-collateral-B72)\]. Furthermore, sensitivity analysis of model parameters has also been performed with the GreenLab model \[[73](#core-collateral-B73)–[75](#core-collateral-B75)\].

The GreenLab model can be integrated with other models or methods, such as the simulation study by Letort et al. \[[76](#core-collateral-B76)\], which incorporated genetics into the GreenLab model. This approach provides access to more fundamental traits for detecting quantitative trait loci (QTLs), offering potential tools for optimizing yield.

The GreenLab model can be integrated with ML methods to predict crop yield, like the study of Fan et al. \[[77](#core-collateral-B77)\]. They proposed a knowledge data-driven method (KDDM) by combining GreenLab and neural networks to predict tomato yield under different greenhouse environmental conditions. This KDDM has also been utilized for predicting crop yield under a controlled ecological life support system (CELSS) by computing the interaction between carbon, plants, and gases \[[78](#core-collateral-B78)\].

## Software

Since 2003, the software implementations of the GreenLab model have been made by different research teams that are available in different environments and have varying specifications. These implementations can support deterministic or stochastic simulations, and/or fitting based on the measured data, and feedback between growth and development.

GreenLab formalism is deployed in various programming languages and environments, including stand-alone simulation and calibration tools like Visualplant, Cornerfit, GreenScilab, Qingyuan, Gloups, StemGL, and XPlantGL. Table [2](#) provides a summary of these implementations and their specifications.

The initial software development focused on the generic simulation of plant architecture development using botanical automaton (Visualplant software). The second software, Cornerfit, focused on the growth simulation of single-stemmed plants, such as corn, sunflower, tomato, wheat, and beetroot using the WLSM \[[79](#core-collateral-B79)\]. The subsequent software, including GreenScilab, Digiplante, QingYuan, Gloups, and StemGL, synthesized the features of the first two software.

GreenScilab, the first complete open-source GreenLab software, offers a user manual, an interface for parameter input, a source–sink solver for organic series, and 3D output simulations. GreenScilab implements structural stochastic development, continuous and rhythmic growth, and source–sink production simulation. It takes advantage of substructure factorization for production and simulation and is particularly effective for plants with simple structures. The tool offers calibrated datasets on plants of agronomic interest based on field measurements \[[80](#core-collateral-B80),[81](#core-collateral-B81)\].

OPEN IN VIEWER

| Software | Language | Main developer | Plant species | Features |
| --- | --- | --- | --- | --- |
| Visualplant | C++ | LIAMA, CASIA | Crops and trees | Deterministic, pure development;Simulation; |
| Cornerfit | C++ | LIAMA, CASIA | Single-stemmed crops | Deterministic, single-stemmed;Simulation and fitting; |
| GreenScilab | Scilab | CASIA | Crops | Deterministic without feedback between growth and development; Simulation and fitting; |
| DigiPlante | C++ | ECP | Crops and trees | Deterministic with feedback; Simulation and fitting; |
| dgpSDK libraries | C++ | ECP | Crops and trees | Deterministic with feedback; Simulation and fitting; |
| QingYuan | C++ | CASIA | Crops and trees | Deterministic with feedback;Simulation; |
| StemGL | Matlab or Octave | AMAP & Bioagressor, CIRAD | Single-stemmed crops | Deterministic without feedback;Simulation and fitting; |
| Gloups | Matlab | AMAP, CIRAD | Crops and trees | Stochastic and feedback; Simulation and fitting; |
| XPlantGL | Matlab | CASIA | Crops | Stochastic without feedback;Simulation and fitting; |

Expand for more

Table 2. Software tools and their specifications are developed based on the GreenLab model

StemGL is another open-source tool that focuses on single-stemmed plants and operates in both Matlab and Octave environments \[[82](#core-collateral-B82)\]. Gloups is the most advanced implementation, which enables the applications of both deterministic and stochastic models, but access to the tool requires a shared research project with specific terms of use \[[83](#core-collateral-B83)\]. For convenient applications, XPlantGL is developed only for crops; it can do simulation and fitting, including branching and stochastic plants. These implementations include a set of tools for parameterization, simulation, calibration, and optimization.

However, the specificity of scientific programming environments like Matlab or Scilab can limit scalability in terms of memory space and execution speed, prohibiting simulations of large numbers of phytomers that adult trees may present. To address this, versions designed in general-purpose languages like C, C++, and Java have been developed, such as Digiplante and QingYuan \[[84](#core-collateral-B84)\]. The Digiplante tool, piloted by the Digiplante team at École centrale Supélec, gives birth to the dgpSDK development environment that enables the simulation and visualization of 3D scenes from the GreenLab model. The QingYuan simulator, piloted by CASIA \[[84](#core-collateral-B84),[85](#core-collateral-B85)\], is developing a cloud-based interface to facilitate model-based training and competition.

## Perspectives

### Combing with plant phenotyping for crop breeding

Plant breeding involves a repetitive cycle of assessing multiple generations before introducing an improved cultivar. The challenges posed by a growing global population and changing climate demand sustainable food production solutions. This process of developing unique and advanced cultivars with desirable traits for crop plants is time intensive and can span many years \[[86](#core-collateral-B86)\]. Traditional breeding methods typically take around 10 to 15 years, involving about 3 to 7 years for the development of initial lines, followed by 4 to 5 years of field testing, and then an additional 1 to 3 years for the official release of new cultivars. By shortening the generation cycle, it becomes feasible to significantly reduce this lengthy timeline \[[87](#core-collateral-B87)\].

Speed breeding \[[88](#core-collateral-B88)\] is an emerging technology aiming at shortening the breeding cycle, thus accelerating crop research programs through rapid generation advancement techniques. However, it is important to note that speed breeding is indeed one of the more expensive techniques. It requires specialized infrastructure to maintain controlled environments and specific equipment for precise trait selection, both of which come with substantial expenses \[[87](#core-collateral-B87)\]. One approach to overcome this challenge is to concentrate efforts on plant varieties that are particularly relevant to breeding goals and to integrate speed breeding with existing breeding techniques. Another avenue involves the use of crop models to support plant breeding efforts.

Crop models enable yield prediction and offer insights into the interplay between environmental factors and plant physiological processes, influencing crop growth and development \[[3](#core-collateral-B3)\]. Integrating diverse crop models offers a way to enhance our understanding of crop behavior and fully unlock the potential of these models. The GreenLab model considers the effects of plant structure, allowing it to leverage phenotype data such as crop height, leaf area, grain number, and physiological and photosynthetic attributes for calibrating model parameters. With the rapid advancement of equipment and technologies for acquiring crop phenotype information, a wide array of traits can now be comprehensively gathered at various scales, ranging from individual organs to entire plants \[[89](#core-collateral-B89)\]. This accelerated data collection simplifies the process of obtaining plant growth information compared to conventional methods. However, the challenge emerges in effectively analyzing the substantial volume of acquired phenotype data \[[90](#core-collateral-B90)\]. By merging environmental data with phenotyping information, the GreenLab model can simulate plant plasticity under varying environmental and management practices.

The GreenLab model is highly compatible with PBMs. For instance, Lemaire et al. \[[91](#core-collateral-B91)\] used the GreenLab model to calculate the projection area based on the weights of various plant organs, and the results were consistent with experimental findings. Feng \[[92](#core-collateral-B92)\] combined the GreenLab model with a differential statistical method to explore the transition of yield from individual corn plants to populations. Notably, the calculated results were in concordance with population-level measurements. These studies indicate that the GreenLab model can simulate the growth and development of various plant organs using organ-scale data. The model effectively bridges the gap between agronomic crop models and plant configuration models, contributing to a more comprehensive understanding of plant dynamics.

Furthermore, based on environmental and phenotyping data, the GreenLab model can construct simulation models for different crop varieties and lines. Its generic nature and stability across diverse environments enable it to simulate the growth and development of various varieties under different environmental conditions. Consequently, the model serves as a valuable tool for breeders, facilitating the selection of suitable varieties while reducing the need for extensive field experiments and associated costs.

### Combing with multi-level models for evaluating crop adaptation and yield prediction

The adaptation of crops to extreme climate conditions based on crop models needs to intuitively express the effects of fertilization, irrigation, and other cultivation measures on the individual growth of crops. Based on the research from the population scale to the individual scale, it is possible to quickly simulate changes in crop morphology under different management measures based on models without the need to adjust the size of each organ individually. Individual-scale plant models often include organ-scale submodels, which can be further combined with genetic models at the micro-scale. As studied by Letort et al. \[[76](#core-collateral-B76)\], the GreenLab model was used to link growth model parameters to QTL. Virtual genes and virtual chromosomes were defined to build a simple genetic model that drove the settings of the species-specific parameters of the model. A genetic algorithm was implemented to define the ideotype for yield maximization based on the model parameters and the associated allelic combination. Combining the GreenLab model with micro-scale (genetic and cellular scales) models can simulate crop growth and development processes under different genetic combinations and predict yields. Chew \[[93](#core-collateral-B93)\] developed a multiscale model for _Arabidopsis_ rosette growth by integrating four existing models. This integration enabled the connection of genetic regulation and biochemical dynamics with processes occurring at the organ and whole-plant levels. This approach proved to be invaluable in understanding how the interplay between internal genetic factors and external environmental influences impacts the growth of _Arabidopsis_. Furthermore, the GreenLab model can also be combined with PBMs on a population scale, such as DSSAT or APSIM \[[94](#core-collateral-B94)\]. Individual-scale models can serve as a bridge, linking research efforts conducted across different scales. This cross-scale integration significantly facilitates more extensive model-driven research.

The integration of models operating at different spatial scales allows a comprehensive simulation of the intricate interplay between crop genetic traits, management practices, and environmental conditions, as well as the dynamic process of growth and development across various plant organs within an individual, facilitated by a profound comprehension of plant processes. Furthermore, this integration allows for a detailed description of yield composition and permits a 3D visualization of crops, which can then be compared with phenotype information. This fusion of different scale models not only offers valuable insights into plant breeding and phenotype characterization but also serves as a resource for optimizing crop systems.

### Combing with AI methods to produce simulated data

With the increasing adoption of sensor and communication technologies in agriculture, ML has emerged as a valuable tool for predicting yield and phenotyping. The GreenLab model stands to benefit from integration with artificial intelligence (AI) algorithms, such as the previously mentioned KDDM \[[77](#core-collateral-B77),[78](#core-collateral-B78)\]. By leveraging sensor data, the KDDM simplifies model parameterization and improves yield prediction accuracy.

ML algorithms need abundant and high-quality data to enhance their performance. However, it is crucial to recognize that the quality and relevance of the data are as important as the quantity itself. The data used must accurately reflect the problem that needs to be addressed. Careful consideration of data collection, preprocessing, and augmentation techniques can maximize the use of available data, even when collecting a substantial amount of data is difficult. Simulation models based on mechanical principles can play an important role in generating additional data for refining training models, especially in situations where obtaining a significant volume of real-world data proves difficult.

Furthermore, the integration of AI algorithms with the GreenLab model or other crop models holds the promise of extending these models to broader scales, ranging from farm level to regional and even global level. An illustration of this potential is found in the work of Jeong et al. \[[95](#core-collateral-B95)\], who introduced a method for predicting rice yield at the pixel level by combining crop models with DL models like long short-term memory (LSTM) and 1D convolutional neural networks (1D-CNNs). Feng et al. \[[96](#core-collateral-B96)\] integrated the APSIM with regression models such as random forest or multivariate linear regression to dynamically predict wheat yield in southeastern Australia. Chen and Tao \[[97](#core-collateral-B97)\] combined remote sensing-derived leaf area index (LAI), weather predictions, and physiological crop models to forecast winter wheat yield over several years in the North China Plain. This convergence of AI algorithms with crop models bears tremendous potential to expand the boundaries of crop modeling, enabling simulations across various scales and domains.

## Conclusions

Over the past two decades, the GreenLab model has undergone continuous development, incorporating novel modeling methods and techniques, including the dual-scale automaton \[[41](#core-collateral-B41)\], substructure methods \[[42](#core-collateral-B42)\], the inverse of source–sink parameters \[[79](#core-collateral-B79)\], crown analysis \[[48](#core-collateral-B48)\], organic series and potential structure \[[26](#core-collateral-B26),[29](#core-collateral-B29)\], and parameter optimization techniques \[[52](#core-collateral-B52),[69](#core-collateral-B68),[72](#core-collateral-B72)\]. Moreover, studies have explored the quantitative relationships between model parameters and genetic factors \[[76](#core-collateral-B76)\], the integration with the ML method \[[77](#core-collateral-B77)\], and the link with APSIM \[[94](#core-collateral-B94)\].

Functioning at the organ scale, the GreenLab model excels in simulating the growth and development of individual plant organs. It boasts the advantage of accounting for the feedback effects of structure on crop growth while also allowing parameter calibration using measured data. This flexibility makes it compatible with micro-scale genetic models \[[76](#core-collateral-B76)\] and photosynthesis models \[[71](#core-collateral-B71)\], leading to a more profound understanding of how genetic and physiological processes interact to influence plant growth and development \[[93](#core-collateral-B93)\].

Additionally, the GreenLab model can be combined with population-scale process models, allowing for a more comprehensive analysis of plant populations within different environmental conditions \[[94](#core-collateral-B94)\]. By bridging the gap between different scales of modeling, the GreenLab model enables researchers to investigate the impact of environmental factors and management practices on the productivity and sustainability of plant populations at various levels. In the era of phenomics, where substantial crop growth data can be acquired, the calibration of the GreenLab model for various species and environments becomes even more viable. This adaptability positions the GreenLab model as a crucial bridge connecting genetic and physiological aspects, thereby providing a wider range of research possibilities.

## Acknowledgments

**Funding:** This work is supported by the Major S&T Project (Innovation 2030) of China (2021ZD0113701), the International Partnership Program of the Chinese Academy of Sciences (grant no. 159231KYSB20200010), and the National Natural Science Foundation of China (62076239).

**Author contributions:** W.X., K.M., and D.R.P. wrote and revised the manuscript. H.J. and W.H. performed the literature research and revised the manuscript.

**Competing interests:** The authors declare that they have no competing interests.

## Data Availability

There are no data used in this manuscript.

## References

1

Huang M, Wang J, Wang B, Liu DL, Yu Q, He D, Wang N, Pan X. Optimizing sowing window and cultivar choice can boost China’s maize yield under 1.5 °C and 2 °C global warming. _Environ Res Lett_. 2020;**15**(2): Article 024015.

[GO TO REFERENCE](#core-B1-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Optimizing+sowing+window+and+cultivar+choice+can+boost+China%E2%80%99s+maize+yield+under+1.5+%C2%B0C+and+2+%C2%B0C+global+warming&author=M+Huang&author=J+Wang&author=B+Wang&author=DL+Liu&author=Q+Yu&author=D+He&author=N+Wang&author=X+Pan&publication_year=2020&journal=Environ+Res+Lett)

2

United Nations Department of Economic and Social Affairs PD, World Population Prospects 2022: Summary of Results, 2022, vol. UN DESA/POP/2022/TR/NO. 3.

[GO TO REFERENCE](#core-B2-1)

[Google Scholar](https://scholar.google.com/scholar?q=United+Nations+Department+of+Economic+and+Social+Affairs+PD%2C+World+Population+Prospects+2022%3A+Summary+of+Results%2C+2022%2C+vol.+UN+DESA%2FPOP%2F2022%2FTR%2FNO.+3.)

3

Peng B, Guan K, Tang J, Ainsworth EA, Asseng S, Bernacchi CJ, Cooper M, Delucia EH, Elliott JW, Ewert F, et al. Towards a multiscale crop modelling framework for climate change adaptation assessment. _Nat Plants_. 2020;**6**(4):338–348.

[Crossref](https://doi.org/10.1038/s41477-020-0625-3)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Towards+a+multiscale+crop+modelling+framework+for+climate+change+adaptation+assessment&author=B+Peng&author=K+Guan&author=J+Tang&author=EA+Ainsworth&author=S+Asseng&author=CJ+Bernacchi&author=M+Cooper&author=EH+Delucia&author=JW+Elliott&author=F+Ewert&publication_year=2020&journal=Nat+Plants&pages=338-348&doi=10.1038%2Fs41477-020-0625-3)

*   [a \[...\] for future agricultural sustainability](#core-B3-1)
*   [b \[...\] management adjustments on crop production](#core-B3-2)
*   [c \[...\] influencing crop growth and development](#core-B3-3)

4

Porter JR, Xie L, Challinor AJ, Cochrane K, Howden SM, Iqbal MM, Lobell DB, Travasso MI. Chapter 7: Food security and food production systems, in _Food security and food production systems. In: Climate Change 2014: Impacts, Adaptation, and Vulnerability. Part A: Global and Sectoral Aspects. Contribution of Working Group II to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change_. Cambridge (UK): Cambridge University Press; 2014. p. 485–533.

[GO TO REFERENCE](#core-B4-1)

[Google Scholar](https://scholar.google.com/scholar?q=Porter+JR%2C+Xie+L%2C+Challinor+AJ%2C+Cochrane+K%2C+Howden+SM%2C+Iqbal+MM%2C+Lobell+DB%2C+Travasso+MI.+Chapter%C2%A07%3A+Food+security+and+food+production+systems%2C+in+Food+security+and+food+production+systems.+In%3A+Climate+Change+2014%3A+Impacts%2C+Adaptation%2C+and+Vulnerability.+Part+A%3A+Global+and+Sectoral+Aspects.+Contribution+of+Working+Group+II+to+the+Fifth+Assessment+Report+of+the+Intergovernmental+Panel+on+Climate+Change.+Cambridge+%28UK%29%3A+Cambridge+University+Press%3B+2014.+p.+485%E2%80%93533.)

5

Chenu K, Porter JR, Martre P, Basso B, Chapman SC, Ewert F, Bindi M, Asseng S. Contribution of crop models to adaptation in wheat. _Trends Plant Sci_. 2017;**22**(6):472–490.

[Crossref](https://doi.org/10.1016/j.tplants.2017.02.003)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Contribution+of+crop+models+to+adaptation+in+wheat&author=K+Chenu&author=JR+Porter&author=P+Martre&author=B+Basso&author=SC+Chapman&author=F+Ewert&author=M+Bindi&author=S+Asseng&publication_year=2017&journal=Trends+Plant+Sci&pages=472-490&doi=10.1016%2Fj.tplants.2017.02.003)

*   [a \[...\] (E), and management measures (M)](#core-B5-1)
*   [b \[...\] the impact of climate change on crop yields](#core-B5-2)

6

Martín MM-S, Olesen JE, Porter JR. A genotype, environment and management (GxExM) analysis of adaptation in winter wheat to climate change in Denmark. _Agric For Meteorol_. 2014;**187**:1–13.

[GO TO REFERENCE](#core-B6-1)

[Crossref](https://doi.org/10.1016/j.agrformet.2013.11.009)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+genotype%2C+environment+and+management+%28GxExM%29+analysis+of+adaptation+in+winter+wheat+to+climate+change+in+Denmark&author=MM-S+Mart%C3%ADn&author=JE+Olesen&author=JR+Porter&publication_year=2014&journal=Agric+For+Meteorol&pages=1-13&doi=10.1016%2Fj.agrformet.2013.11.009)

7

Gornott C, Wechsung F. Statistical regression models for assessing climate impacts on crop yields: A validation study for winter wheat and silage maize in Germany. _Agric For Meteorol_. 2016;**217**:89–100.

[GO TO REFERENCE](#core-B7-1)

[Crossref](https://doi.org/10.1016/j.agrformet.2015.10.005)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Statistical+regression+models+for+assessing+climate+impacts+on+crop+yields%3A+A+validation+study+for+winter+wheat+and+silage+maize+in+Germany&author=C+Gornott&author=F+Wechsung&publication_year=2016&journal=Agric+For+Meteorol&pages=89-100&doi=10.1016%2Fj.agrformet.2015.10.005)

8

Kern A, Barcza Z, Marjanović H, Árendás T, Fodor N, Bónis P, Bognár P, Lichtenberger J. Statistical modelling of crop yield in Central Europe using climate data and remote sensing vegetation indices. _Agric For Meteorol_. 2018;**260-261**:300–320.

[GO TO REFERENCE](#core-B8-1)

[Crossref](https://doi.org/10.1016/j.agrformet.2018.06.009)

[Web of Science](https://gateway.webofknowledge.com/gateway/Gateway.cgi?GWVersion=2&DestApp=WOS_CPL&UsrCustomerID=5e3815c904498985e796fc91436abd9a&SrcAuth=atyponcel&SrcApp=literatum&DestLinkType=FullRecord&KeyUT=WOS%3A000445306700028)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Statistical+modelling+of+crop+yield+in+Central+Europe+using+climate+data+and+remote+sensing+vegetation+indices&author=A+Kern&author=Z+Barcza&author=H+Marjanovi%C4%87&author=T+%C3%81rend%C3%A1s&author=N+Fodor&author=P+B%C3%B3nis&author=P+Bogn%C3%A1r&author=J+Lichtenberger&publication_year=2018&journal=Agric+For+Meteorol&pages=300-320&doi=10.1016%2Fj.agrformet.2018.06.009)

9

Rosenzweig C, Elliott J, Deryng D, Ruane AC, Müller C, Arneth A, Boote KJ, Folberth C, Glotter M, Khabarov N, et al. Assessing agricultural risks of climate change in the 21st century in a global gridded crop model intercomparison. _Proc Natl Acad Sci_. 2014;**111**(9):3268–3273.

[GO TO REFERENCE](#core-B9-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Assessing+agricultural+risks+of+climate+change+in+the+21st+century+in+a+global+gridded+crop+model+intercomparison&author=C+Rosenzweig&author=J+Elliott&author=D+Deryng&author=AC+Ruane&author=C+M%C3%BCller&author=A+Arneth&author=KJ+Boote&author=C+Folberth&author=M+Glotter&author=N+Khabarov&publication_year=2014&journal=Proc+Natl+Acad+Sci&pages=3268-3273)

10

Peng B, Guan K, Chen M, Lawrence DM, Pokhrel Y, Suyker A, Arkebauer T, Lu Y. Improving maize growth processes in the community land model: Implementation and evaluation. _Agric For Meteorol_. 2018;**250-251**:64–89.

[Crossref](https://doi.org/10.1016/j.agrformet.2017.11.012)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Improving+maize+growth+processes+in+the+community+land+model%3A+Implementation+and+evaluation&author=B+Peng&author=K+Guan&author=M+Chen&author=DM+Lawrence&author=Y+Pokhrel&author=A+Suyker&author=T+Arkebauer&author=Y+Lu&publication_year=2018&journal=Agric+For+Meteorol&pages=64-89&doi=10.1016%2Fj.agrformet.2017.11.012)

11

Antle JM, Basso B, Conant RT, Godfray HCJ, Jones JW, Herrero M, Howitt RE, Keating BA, Munoz-Carpena R, Rosenzweig C, et al. Towards a new generation of agricultural system data, models and knowledge products: Design and improvement. _Agric Syst_. 2017;**155**:255–268.

[GO TO REFERENCE](#core-B11-1)

[Crossref](https://doi.org/10.1016/j.agsy.2016.10.002)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Towards+a+new+generation+of+agricultural+system+data%2C+models+and+knowledge+products%3A+Design+and+improvement&author=JM+Antle&author=B+Basso&author=RT+Conant&author=HCJ+Godfray&author=JW+Jones&author=M+Herrero&author=RE+Howitt&author=BA+Keating&author=R+Munoz-Carpena&author=C+Rosenzweig&publication_year=2017&journal=Agric+Syst&pages=255-268&doi=10.1016%2Fj.agsy.2016.10.002)

12

Kim N, Na SI, Park CW, Huh M, Oh J, Ha KJ, Cho J, Lee YW. An artificial intelligence approach to prediction of corn yields under extreme weather conditions using satellite and meteorological data. _Appl Sci_. 2020;**10**(11):3785.

[GO TO REFERENCE](#core-B12-1)

[Crossref](https://doi.org/10.3390/app10113785)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=An+artificial+intelligence+approach+to+prediction+of+corn+yields+under+extreme+weather+conditions+using+satellite+and+meteorological+data&author=N+Kim&author=SI+Na&author=CW+Park&author=M+Huh&author=J+Oh&author=KJ+Ha&author=J+Cho&author=YW+Lee&publication_year=2020&journal=Appl+Sci&pages=3785&doi=10.3390%2Fapp10113785)

13

Shi W, Tao F, Zhang Z. A review on statistical models for identifying climate contributions to crop yields. _J Geogr Sci_. 2013;**23**(3):567–576.

[GO TO REFERENCE](#core-B13-1)

[Crossref](https://doi.org/10.1007/s11442-013-1029-3)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+review+on+statistical+models+for+identifying+climate+contributions+to+crop+yields&author=W+Shi&author=F+Tao&author=Z+Zhang&publication_year=2013&journal=J+Geogr+Sci&pages=567-576&doi=10.1007%2Fs11442-013-1029-3)

14

Khaki S, Wang L. Crop yield prediction using deep neural networks. _Front Plant Sci_. 2019;**10**:621.

[GO TO REFERENCE](#core-B14-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Crop+yield+prediction+using+deep+neural+networks&author=S+Khaki&author=L+Wang&publication_year=2019&journal=Front+Plant+Sci&pages=621)

15

Sun J, Di L, Sun Z, Shen Y, Lai Z. County-level soybean yield prediction using deep CNN-LSTM model. _Sensors_. 2019;**19**(20):4363.

[GO TO REFERENCE](#core-B15-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=County-level+soybean+yield+prediction+using+deep+CNN-LSTM+model&author=J+Sun&author=L+Di&author=Z+Sun&author=Y+Shen&author=Z+Lai&publication_year=2019&journal=Sensors&pages=4363)

16

Si Z, Zain M, Li S, Liu J, Liang Y, Gao Y, Duan A. Optimizing nitrogen application for drip-irrigated winter wheat using the DSSAT-CERES-wheat model. _Agric Water Manag_. 2021;**244**:106592.

[GO TO REFERENCE](#core-B16-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Optimizing+nitrogen+application+for+drip-irrigated+winter+wheat+using+the+DSSAT-CERES-wheat+model&author=Z+Si&author=M+Zain&author=S+Li&author=J+Liu&author=Y+Liang&author=Y+Gao&author=A+Duan&publication_year=2021&journal=Agric+Water+Manag&pages=106592)

17

Kuijpers WJP, van de Molengraft MJG, van Mourik S, van’t Ooster A, Hemming S, van Henten EJ. Model selection with a common structure: Tomato crop growth models. _Biosyst Eng_. 2019;**187**:247–257.

[GO TO REFERENCE](#core-B17-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Model+selection+with+a+common+structure%3A+Tomato+crop+growth+models&author=WJP+Kuijpers&author=MJG+van+de+Molengraft&author=S+van+Mourik&author=A+van%E2%80%99t+Ooster&author=S+Hemming&author=EJ+van+Henten&publication_year=2019&journal=Biosyst+Eng&pages=247-257)

18

Kherif O, Seghouani M, Justes E, Plaza-Bonilla D, Bouhenache A, Zemmouri B, Dokukin P, Latati M. The first calibration and evaluation of the STICS soil-crop model on chickpea-based intercropping system under Mediterranean conditions. _Eur J Agron_. 2022;**133**:126449.

[GO TO REFERENCE](#core-B18-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=The+first+calibration+and+evaluation+of+the+STICS+soil-crop+model+on+chickpea-based+intercropping+system+under+Mediterranean+conditions&author=O+Kherif&author=M+Seghouani&author=E+Justes&author=D+Plaza-Bonilla&author=A+Bouhenache&author=B+Zemmouri&author=P+Dokukin&author=M+Latati&publication_year=2022&journal=Eur+J+Agron&pages=126449)

19

Holzworth D, Huth NI, Fainges J, Brown H, Zurcher E, Cichota R, Verrall S, Herrmann NI, Zheng B, Snow V. APSIM next generation: Overcoming challenges in modernising a farming systems model. _Environ Model Softw_. 2018;**103**:43–51.

[GO TO REFERENCE](#core-B19-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=APSIM+next+generation%3A+Overcoming+challenges+in+modernising+a+farming+systems+model&author=D+Holzworth&author=NI+Huth&author=J+Fainges&author=H+Brown&author=E+Zurcher&author=R+Cichota&author=S+Verrall&author=NI+Herrmann&author=B+Zheng&author=V+Snow&publication_year=2018&journal=Environ+Model+Softw&pages=43-51)

20

Vos J, Evers JB, Buck-Sorlin GH, Andrieu B, Chelle M, de Visser PHB. Functional–structural plant modelling: A new versatile tool in crop science. _J Exp Bot_. 2009;**61**(8):2101–2115.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Functional%E2%80%93structural+plant+modelling%3A+A+new+versatile+tool+in+crop+science&author=J+Vos&author=JB+Evers&author=GH+Buck-Sorlin&author=B+Andrieu&author=M+Chelle&author=PHB+de+Visser&publication_year=2009&journal=J+Exp+Bot&pages=2101-2115)

*   [a \[...\] and the inherent relationships between them](#core-B20-1)
*   [b \[...\] three-dimensional (3D) plant structure](#core-B20-2)

21

Soualiou S, Wang Z, Sun W, de Reffye P, Collins B, Louarn G, Song Y. Functional–structural plant models mission in advancing crop science: Opportunities and prospects. _Front Plant Sci_. 2021;**12**:747142.

[GO TO REFERENCE](#core-B21-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Functional%E2%80%93structural+plant+models+mission+in+advancing+crop+science%3A+Opportunities+and+prospects&author=S+Soualiou&author=Z+Wang&author=W+Sun&author=P+de+Reffye&author=B+Collins&author=G+Louarn&author=Y+Song&publication_year=2021&journal=Front+Plant+Sci&pages=747142)

22

Eschenbach C. Emergent properties modelled with the functional structural tree growth model ALMIS: Computer experiments on resource gain and use. _Ecol Model_. 2005;**186**(4):470–488.

[GO TO REFERENCE](#core-B22-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Emergent+properties+modelled+with+the+functional+structural+tree+growth+model+ALMIS%3A+Computer+experiments+on+resource+gain+and+use&author=C+Eschenbach&publication_year=2005&journal=Ecol+Model&pages=470-488)

23

Perttunen J, Sievänen R. Incorporating Lindenmayer systems for architectural development in a functional-structural tree model. _Ecol Model_. 2005;**181**(4):479–491.

[GO TO REFERENCE](#core-B23-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Incorporating+Lindenmayer+systems+for+architectural+development+in+a+functional-structural+tree+model&author=J+Perttunen&author=R+Siev%C3%A4nen&publication_year=2005&journal=Ecol+Model&pages=479-491)

24

Allen MT, Prusinkiewicz P, Dejong TM. Using L-systems for modeling source-sink interactions, architecture and physiology of growing trees: The L-PEACH model. _New Phytol_. 2005;**166**(3):869–880.

[GO TO REFERENCE](#core-B24-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Using+L-systems+for+modeling+source-sink+interactions%2C+architecture+and+physiology+of+growing+trees%3A+The+L-PEACH+model&author=MT+Allen&author=P+Prusinkiewicz&author=TM+Dejong&publication_year=2005&journal=New+Phytol&pages=869-880)

25

de Reffye P, Hu B-G, Kang M, Letort V, Jaeger M. Two decades of research with the GreenLab model in agronomy. _Ann Bot_. 2021;**127**(3):281–295.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Two+decades+of+research+with+the+GreenLab+model+in+agronomy&author=P+Reffye&author=B-G+Hu&author=M+Kang&author=V+Letort&author=M+Jaeger&publication_year=2021&journal=Ann+Bot&pages=281-295)

*   [a \[...\] \], and GreenLab](#core-B25-1)
*   [b \[...\] of trees within a single growing season](#core-B25-2)
*   [c \[...\] GreenLab model uses some important notions](#core-B25-3)
*   [d \[...\] others, as described by de Reffye et al.](#core-B25-4)
*   [e \[...\] and growth, which can be found in](#core-B25-5)
*   [f \[...\] validation across numerous plant species](#core-B25-6)
*   [g \[...\] and distributes it to organ compartments](#core-B25-7)
*   [h \[...\] scheme to simplify the measurements](#core-B25-8)
*   [i \[...\] using crown and organic series analysis](#core-B25-9)

26

Kang M, Hua J, Wang X, de Reffye P, Jaeger M, Akaffou S. Estimating sink parameters of stochastic functional-structural plant models using organic series-continuous and rhythmic development. _Front Plant Sci_. 2018;**9**:1688.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Estimating+sink+parameters+of+stochastic+functional-structural+plant+models+using+organic+series-continuous+and+rhythmic+development&author=M+Kang&author=J+Hua&author=X+Wang&author=P+de+Reffye&author=M+Jaeger&author=S+Akaffou&publication_year=2018&journal=Front+Plant+Sci&pages=1688)

*   [a \[...\] environment with plant architecture](#core-B26-1)
*   [b \[...\] simulate the variation in plant structures](#core-B26-2)
*   [c \[...\] GreenLab model uses some important notions](#core-B26-3)
*   [d \[...\] validation across numerous plant species](#core-B26-4)
*   [e \[...\] scheme to simplify the measurements](#core-B26-5)
*   [f \[...\] \], organic series and potential structure](#core-B26-6)

27

Yan H, Kang M, de Reffye P, Dingkuhn M. A dynamic, architectural plant model simulating resource-dependent growth. _Ann Bot_. 2004;**93**(5):591–602.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+dynamic%2C+architectural+plant+model+simulating+resource-dependent+growth&author=H+Yan&author=M+Kang&author=P+de+Reffye&author=M+Dingkuhn&publication_year=2004&journal=Ann+Bot&pages=591-602)

*   [a \[...\] source–sink functions of individual organs](#core-B27-1)
*   [b \[...\] on predefined rules for plant development](#core-B27-2)
*   [c \[...\] to adapt to internal or external factors](#core-B27-3)
*   [d \[...\] petioles, internodes, and caps on the stem.](#core-B27-4)

28

Kang M, Cournède P-H, de Reffye P, Auclair D, Hu B-G. Analytical study of a stochastic plant growth model: Application to the GreenLab model. _Math Comput Simul_. 2008;**78**(1):57–75.

[Crossref](https://doi.org/10.1016/j.matcom.2007.06.003)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Analytical+study+of+a+stochastic+plant+growth+model%3A+Application+to+the+GreenLab+model&author=M+Kang&author=P-H+Courn%C3%A8de&author=P+de+Reffye&author=D+Auclair&author=B-G+Hu&publication_year=2008&journal=Math+Comput+Simul&pages=57-75&doi=10.1016%2Fj.matcom.2007.06.003)

*   [a \[...\] to its position within the plant structure](#core-B28-1)
*   [b \[...\] simulate the variation in plant structures](#core-B28-2)

29

Letort V, Sabatier S, Okoma MP, Jaeger M, de Reffye P. Internal trophic pressure, a regulator of plant development? Insights from a stochastic functional–structural plant growth model applied to Coffea trees. _Ann Bot_. 2020;**126**(4):687–699.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Internal+trophic+pressure%2C+a+regulator+of+plant+development%3F+Insights+from+a+stochastic+functional%E2%80%93structural+plant+growth+model+applied+to+Coffea+trees&author=V+Letort&author=S+Sabatier&author=MP+Okoma&author=M+Jaeger&author=P+de+Reffye&publication_year=2020&journal=Ann+Bot&pages=687-699)

*   [a \[...\] the need for extensive data collection](#core-B29-1)
*   [b \[...\] of GL4 has been described by Letort et al.](#core-B29-2)
*   [c \[...\] can be displayed in 2D or 3D format](#core-B29-3)
*   [d \[...\] validation across numerous plant species](#core-B29-4)
*   [e \[...\] internodes, and fruits on the branches.](#core-B29-5)
*   [f \[...\] \], organic series and potential structure](#core-B29-6)

30

Kang M, Wang X, Hua J, Hu B-G, Wang F-Y, de Reffye P. Over two decades of research with Greenlab model. _J Agric Big Data_. 2021;**3**(3):3–12.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Over+two+decades+of+research+with+Greenlab+model&author=M+Kang&author=X+Wang&author=J+Hua&author=B-G+Hu&author=F-Y+Wang&author=P+de+Reffye&publication_year=2021&journal=J+Agric+Big+Data&pages=3-12)

*   [a \[...\] corn, wheat, rapeseed, cucumber, and tomato](#core-B30-1)
*   [b \[...\] and growth, which can be found in](#core-B30-2)

31

Barczi J-F, Rey H, Caraglio Y, de Reffye P, Barthélémy D, Dong QX, Fourcaud T. AmapSim: A structural whole-plant simulator based on botanical knowledge and designed to host external functional models. _Ann Bot_. 2008;**101**(8):1125–1138.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=AmapSim%3A+A+structural+whole-plant+simulator+based+on+botanical+knowledge+and+designed+to+host+external+functional+models&author=J-F+Barczi&author=H+Rey&author=Y+Caraglio&author=P+de+Reffye&author=D+Barth%C3%A9l%C3%A9my&author=QX+Dong&author=T+Fourcaud&publication_year=2008&journal=Ann+Bot&pages=1125-1138)

*   [a \[...\] inheriting botanical concepts from AMAPsim](#core-B31-1)
*   [b \[...\] is based on the concepts of AMAPSim](#core-B31-2)

32

Barczi J-F, de Reffye P, Caraglio Y. Essai sur l’identification et la mise en œuvre des paramètres nécessaires a la simulation d’une architecture végétale: Le logiciel AmapSim. In: Bouchon J, de Reffye, Barthélémy D, editors. _Modélisation et simulation de l’architecture des végétaux_. Paris: INRA Editions; 1997. p. 205–254.

[GO TO REFERENCE](#core-B32-1)

[Google Scholar](https://scholar.google.com/scholar?q=Barczi+J-F%2C+de+Reffye+P%2C+Caraglio+Y.+Essai+sur+l%E2%80%99identification+et+la+mise+en+%C5%93uvre+des+param%C3%A8tres+n%C3%A9cessaires+a+la+simulation+d%E2%80%99une+architecture+v%C3%A9g%C3%A9tale%3A+Le+logiciel+AmapSim.+In%3A+Bouchon+J%2C+de+Reffye%2C+Barth%C3%A9l%C3%A9my+D%2C+editors.+Mod%C3%A9lisation+et+simulation+de+l%E2%80%99architecture+des+v%C3%A9g%C3%A9taux.+Paris%3A+INRA+Editions%3B+1997.+p.+205%E2%80%93254.)

33

de Reffye P, Barthélémy D, Blaise F, Fourcaud T, Houllier F. A functional model of tree growth and tree architecture. _Silva Fenica_. 1997;**31**(3):297–311.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+functional+model+of+tree+growth+and+tree+architecture&author=P+Reffye&author=D+Barth%C3%A9l%C3%A9my&author=F+Blaise&author=T+Fourcaud&author=F+Houllier&publication_year=1997&journal=Silva+Fenica&pages=297-311)

*   [a \[...\] as the source–sink concept from AMAPHydro](#core-B33-1)
*   [b \[...\] which uses water as the growth driver](#core-B33-2)

34

Hallé F, Oldeman RAA, Tomlinson PB. _Tropical trees and forests: An architectural analysis_. Berlin, Heidelberg: Springer Berlin Heidelberg, 1978; p. XVIII, 444.

[Google Scholar](https://scholar.google.com/scholar?q=Hall%C3%A9+F%2C+Oldeman+RAA%2C+Tomlinson+PB.+Tropical+trees+and+forests%3A+An+architectural+analysis.+Berlin%2C+Heidelberg%3A+Springer+Berlin+Heidelberg%2C+1978%3B+p.+XVIII%2C+444.)

*   [a \[...\] models proposed by Hallé et al.](#core-B34-1)
*   [b \[...\] the 23 botanical architectural models](#core-B34-2)
*   [c \[...\] plant architectural models defined by Hallé](#core-B34-3)
*   [d \[...\] models proposed by Hallé et al.](#core-B34-4)

35

de Reffye P, Edelin C, Françon J, Jaeger M, Puech C. Plant models faithful to botanical structure and development. In: _Proceedings of the 15th Annual Conference on Computer Graphics and Interactive Techniques_. Atlanta: ACM Press; 1988.

[GO TO REFERENCE](#core-B35-1)

[Google Scholar](https://scholar.google.com/scholar?q=de+Reffye+P%2C+Edelin+C%2C+Fran%C3%A7on+J%2C+Jaeger+M%2C+Puech+C.+Plant+models+faithful+to+botanical+structure+and+development.+In%3A+Proceedings+of+the+15th+Annual+Conference+on+Computer+Graphics+and+Interactive+Techniques.+Atlanta%3A+ACM+Press%3B+1988.)

36

Zhao X, de Reffye P, Barthelemy D, Hu B-G. Interactive simulation of plant architecture based on a dual-scale automaton model. In: _Proceedings of the Plant Growth Modeling and Applications_. Beijing: Tsinghua University Press, Springer; 2003.

[Google Scholar](https://scholar.google.com/scholar?q=Zhao+X%2C+de+Reffye+P%2C+Barthelemy+D%2C+Hu+B-G.+Interactive+simulation+of+plant+architecture+based+on+a+dual-scale+automaton+model.+In%3A+Proceedings+of+the+Plant+Growth+Modeling+and+Applications.+Beijing%3A+Tsinghua+University+Press%2C+Springer%3B+2003.)

*   [a \[...\] the 23 botanical architectural models](#core-B36-1)
*   [b \[...\] approach using graph-based notations](#core-B36-2)

37

Ma Y, Chen Y, Zhu J, Meng L, Guo Y, Li B, Hoogenboom G. Coupling individual kernel-filling processes with source-sink interactions into GREENLAB-Maize. _Ann Bot_. 2018;**121**(5):961–973.

[GO TO REFERENCE](#core-B37-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Coupling+individual+kernel-filling+processes+with+source-sink+interactions+into+GREENLAB-Maize&author=Y+Ma&author=Y+Chen&author=J+Zhu&author=L+Meng&author=Y+Guo&author=B+Li&author=G+Hoogenboom&publication_year=2018&journal=Ann+Bot&pages=961-973)

38

Wang F, Kang M, Lu Q, Letort V, Han H, Guo Y, de Reffye P, Li B. A stochastic model of tree architecture and biomass partitioning: Application to Mongolian Scots pines. _Ann Bot_. 2011;**107**(5):781–792.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+stochastic+model+of+tree+architecture+and+biomass+partitioning%3A+Application+to+Mongolian+Scots+pines&author=F+Wang&author=M+Kang&author=Q+Lu&author=V+Letort&author=H+Han&author=Y+Guo&author=P+de+Reffye&author=B+Li&publication_year=2011&journal=Ann+Bot&pages=781-792)

*   [a \[...\] simulate the variation in plant structures](#core-B38-1)
*   [b \[...\] and internodes of the stem and branches.](#core-B38-2)
*   [c \[...\] Pinus sylvestris](#core-B38-3)

39

Mathieu A, Cournède P-H, Letort V, Barthélémy D, de Reffye P. A dynamic model of plant growth with interactions between development and functional mechanisms to study plant structural plasticity related to trophic competition. _Ann Bot_. 2009;**103**(8):1173–1186.

[GO TO REFERENCE](#core-B39-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+dynamic+model+of+plant+growth+with+interactions+between+development+and+functional+mechanisms+to+study+plant+structural+plasticity+related+to+trophic+competition&author=A+Mathieu&author=P-H+Courn%C3%A8de&author=V+Letort&author=D+Barth%C3%A9l%C3%A9my&author=P+de+Reffye&publication_year=2009&journal=Ann+Bot&pages=1173-1186)

40

Vavitsara ME, Sabatier S, Kang M, Ranarijaona HLT, de Reffye P. Yield analysis as a function of stochastic plant architecture: Case of Spilanthes acmella in the wet and dry season. _Comput Electron Agric_. 2017;**138**:105–116.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Yield+analysis+as+a+function+of+stochastic+plant+architecture%3A+Case+of+Spilanthes+acmella+in+the+wet+and+dry+season&author=ME+Vavitsara&author=S+Sabatier&author=M+Kang&author=HLT+Ranarijaona&author=P+de+Reffye&publication_year=2017&journal=Comput+Electron+Agric&pages=105-116)

*   [a \[...\] a decrease in the root mean squared error](#core-B40-1)
*   [b \[...\] basipetal pattern of raceme development.](#core-B40-2)
*   [c \[...\] \], and spilanthes](#core-B40-3)

41

Zhao X, de Reffye P, Xiong F-L, Hu B-G, Zhan Z-G. Dual-scale automaton model for virtual plant development. _Chin J Comput_. 2001;**24**(6):608–608.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Dual-scale+automaton+model+for+virtual+plant+development&author=X+Zhao&author=P+de+Reffye&author=F-L+Xiong&author=B-G+Hu&author=Z-G+Zhan&publication_year=2001&journal=Chin+J+Comput&pages=608-608)

*   [a \[...\] \], duel-scale automaton theory](#core-B41-1)
*   [b \[...\] including the dual-scale automaton](#core-B41-2)

42

Yan H, de Reffye P, Pan CH, Hu B-G. Fast construction of plant architectural models based on substructure decomposition. _J Comput Sci Technol_. 2003;**18**(6):780–787.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Fast+construction+of+plant+architectural+models+based+on+substructure+decomposition&author=H+Yan&author=P+Reffye&author=CH+Pan&author=B-G+Hu&publication_year=2003&journal=J+Comput+Sci+Technol&pages=780-787)

*   [a \[...\] \], and substructure-based algorithm](#core-B42-1)
*   [b \[...\] \], substructure methods](#core-B42-2)

43

de Reffye P, Hu B-G. Invited talk. Relevant qualitative and quantitative choices for building an efficient dynamic plant growth model: GreenLab case. In: _Proceedings of Plant Growth Modeling and Applications_. Beijing, China: Tsinghua University Press, Springer; 2003. p. 87–107.

[GO TO REFERENCE](#core-B43-1)

[Google Scholar](https://scholar.google.com/scholar?q=de+Reffye+P%2C+Hu+B-G.+Invited+talk.+Relevant+qualitative+and+quantitative+choices+for+building+an+efficient+dynamic+plant+growth+model%3A+GreenLab+case.+In%3A+Proceedings+of+Plant+Growth+Modeling+and+Applications.+Beijing%2C+China%3A+Tsinghua+University+Press%2C+Springer%3B+2003.+p.+87%E2%80%93107.)

44

Hu B-G, de Reffye P, Zhao X, Yan H, Kang M. _GreenLab: A new methodology towards plant functional-structural model—Structural aspect._ In: _Proceedings of Plant Growth Modeling and Applications_. Beijing, China: Tsinghua University Press, Springer; 2003. p. 21–35.

[GO TO REFERENCE](#core-B44-1)

[Google Scholar](https://scholar.google.com/scholar?q=Hu+B-G%2C+de+Reffye+P%2C+Zhao+X%2C+Yan+H%2C+Kang+M.+GreenLab%3A+A+new+methodology+towards+plant+functional-structural+model%E2%80%94Structural+aspect.+In%3A+Proceedings+of+Plant+Growth+Modeling+and+Applications.+Beijing%2C+China%3A+Tsinghua+University+Press%2C+Springer%3B+2003.+p.+21%E2%80%9335.)

45

Yan H, Barczi JF, de Reffye P, Hu B-G. Fast algorithms of plant computation based on substructure instances. Paper presented at: International Conferences in Central Europe on Computer Graphics, Visualization and Computer Vision (Wscg‘2002); 2003 February 3 to 7; Plzen - Bory, Czech Republic.

[GO TO REFERENCE](#core-B45-1)

[Google Scholar](https://scholar.google.com/scholar?q=Yan+H%2C+Barczi+JF%2C+de+Reffye+P%2C+Hu+B-G.+Fast+algorithms+of+plant+computation+based+on+substructure+instances.+Paper+presented+at%3A+International+Conferences+in+Central+Europe+on+Computer+Graphics%2C+Visualization+and+Computer+Vision+%28Wscg%E2%80%982002%29%3B+2003+February+3+to+7%3B+Plzen+-+Bory%2C+Czech+Republic.)

46

Tondjo K, Brancheriau L, Sabatier S, Kokutse AD, Kokou K, Jaeger M, de Reffye P, Fourcaud T. Stochastic modelling of tree architecture and biomass allocation: Application to teak (Tectona grandis L. f.), a tree species with polycyclic growth and leaf neoformation. _Ann Bot_. 2018;**121**(7):1397–1410.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Stochastic+modelling+of+tree+architecture+and+biomass+allocation%3A+Application+to+teak+%28Tectona+grandis+L.+f.%29%2C+a+tree+species+with+polycyclic+growth+and+leaf+neoformation&author=K+Tondjo&author=L+Brancheriau&author=S+Sabatier&author=AD+Kokutse&author=K+Kokou&author=M+Jaeger&author=P+de+Reffye&author=T+Fourcaud&publication_year=2018&journal=Ann+Bot&pages=1397-1410)

*   [a \[...\] can be displayed in 2D or 3D format](#core-B46-1)
*   [b \[...\] or simulating plant architecture models](#core-B46-2)
*   [c \[...\] compartments per GU were measured.](#core-B46-3)
*   [d \[...\] and the complex structures like maple, teck](#core-B46-4)

47

Guo Y, Ma Y, Zhan Z, Li B, Dingkuhn M, Luquet D, de Reffye P. Parameter optimization and field validation of the functional-structural model GREENLAB for maize. _Ann Bot_. 2006;**97**(2):217–230.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Parameter+optimization+and+field+validation+of+the+functional-structural+model+GREENLAB+for+maize&author=Y+Guo&author=Y+Ma&author=Z+Zhan&author=B+Li&author=M+Dingkuhn&author=D+Luquet&author=P+de+Reffye&publication_year=2006&journal=Ann+Bot&pages=217-230)

*   [a \[...\] law function to define the sink function](#core-B47-1)
*   [b \[...\] growth stages to fit the organic series](#core-B47-2)
*   [c \[...\] sheaths, internodes, and ears on the stem.](#core-B47-3)

48

Diao J, de Reffye P, Lei X, Guo H, Letort V. Simulation of the topological development of young eucalyptus using a stochastic model and sampling measurement strategy. _Comput Electron Agric_. 2012;**80**:105–114.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Simulation+of+the+topological+development+of+young+eucalyptus+using+a+stochastic+model+and+sampling+measurement+strategy&author=J+Diao&author=P+de+Reffye&author=X+Lei&author=H+Guo&author=V+Letort&publication_year=2012&journal=Comput+Electron+Agric&pages=105-114)

*   [a \[...\] a method known as plant crown analysis](#core-B48-1)
*   [b \[...\] \], crown analysis](#core-B48-2)

49

Ma Y, Li B, Zhan Z, Guo Y, Luquet D, de Reffye P, Dingkuhn M. Parameter stability of the functional-structural plant model GREENLAB as affected by variation within populations, among seasons and among growth stages. _Ann Bot_. 2007;**99**(1):61–73.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Parameter+stability+of+the+functional-structural+plant+model+GREENLAB+as+affected+by+variation+within+populations%2C+among+seasons+and+among+growth+stages&author=Y+Ma&author=B+Li&author=Z+Zhan&author=Y+Guo&author=D+Luquet&author=P+de+Reffye&author=M+Dingkuhn&publication_year=2007&journal=Ann+Bot&pages=61-73)

*   [a \[...\] sheaths, internodes, and ears on the stem.](#core-B49-1)
*   [b \[...\] planting densities and growing seasons](#core-B49-2)

50

Ma Y, Wen M, Guo Y, Li B, Cournède PH, de Reffye P. Parameter optimization and field validation of the functional-structural model GREENLAB for maize at different population densities. _Ann Bot_. 2008;**101**(8):1185–1194.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Parameter+optimization+and+field+validation+of+the+functional-structural+model+GREENLAB+for+maize+at+different+population+densities&author=Y+Ma&author=M+Wen&author=Y+Guo&author=B+Li&author=PH+Courn%C3%A8de&author=P+de+Reffye&publication_year=2008&journal=Ann+Bot&pages=1185-1194)

*   [a \[...\] sheaths, internodes, and ears on the stem.](#core-B50-1)
*   [b \[...\] planting densities and growing seasons](#core-B50-2)

51

Kang M, Yang L, Zhang B, de Reffye P. Correlation between dynamic tomato fruit-set and source-sink ratio: A common relationship for different plant densities and seasons? _Ann Bot_. 2011;**107**(5):805–815.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Correlation+between+dynamic+tomato+fruit-set+and+source-sink+ratio%3A+A+common+relationship+for+different+plant+densities+and+seasons%3F&author=M+Kang&author=L+Yang&author=B+Zhang&author=P+Reffye&publication_year=2011&journal=Ann+Bot&pages=805-815)

*   [a \[...\] internodes, and fruits on the main stem.](#core-B51-1)
*   [b \[...\] For horticultural crops, such as tomato](#core-B51-2)
*   [c \[...\] and fruit set through parameter inversion](#core-B51-3)

52

Kang M, Wang X, Qi R, Jia ZQ, de Reffye P, Huang SW. Analyzing and optimizing yield formation of tomato introgression lines using plant model. _Euphytica_. 2021;**217**(6):100.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Analyzing+and+optimizing+yield+formation+of+tomato+introgression+lines+using+plant+model&author=M+Kang&author=X+Wang&author=R+Qi&author=ZQ+Jia&author=P+de+Reffye&author=SW+Huang&publication_year=2021&journal=Euphytica&pages=100)

*   [a \[...\] internodes, and fruits on the main stem.](#core-B52-1)
*   [b \[...\] For horticultural crops, such as tomato](#core-B52-2)
*   [c \[...\] \] and integration lines for tomatoes](#core-B52-3)
*   [d \[...\] \], and parameter optimization techniques](#core-B52-4)

53

Wang X, Kang M, Fan X-R, Yang L, Zhang B, Huang SW, de Reffye P, Wang F-Y. What are the differences in yield formation among two cucumber (Cucumis sativus L.) cultivars and their F1 hybrid? _J. Integr. Agric._ 2020;**19**(7):1789–1801.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=What+are+the+differences+in+yield+formation+among+two+cucumber+%28Cucumis+sativus+L.%29+cultivars+and+their+F1+hybrid%3F&author=X+Wang&author=M+Kang&author=X-R+Fan&author=L+Yang&author=B+Zhang&author=SW+Huang&author=P+de+Reffye&author=F-Y+Wang&publication_year=2020&journal=J.+Integr.+Agric.&pages=1789-1801)

*   [a \[...\] internodes, and fruits on the main stem.](#core-B53-1)
*   [b \[...\] \] and cucumber](#core-B53-2)
*   [c \[...\] between different cucumber cultivars](#core-B53-3)

54

Wu L, le Dimet FX, de Reffye P, Hu B-G, Cournède P-H, Kang M. An optimal control methodology for plant growth-case study of a water supply problem of sunflower. _Math Comput Simul_. 2012;**82**(5):909–923.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=An+optimal+control+methodology+for+plant+growth-case+study+of+a+water+supply+problem+of+sunflower&author=L+Wu&author=FX+le+Dimet&author=P+de+Reffye&author=B-G+Hu&author=P-H+Courn%C3%A8de&author=M+Kang&publication_year=2012&journal=Math+Comput+Simul&pages=909-923)

*   [a \[...\] In the case of branched plants like pepper](#core-B70-1)
*   [b \[...\] \], irrigation](#core-B70-2)

55

Ma Y, Wubs AM, Mathieu A, Heuvelink E, Zhu JY, Hu B-G, Cournède P-H, de Reffye P. Simulation of fruit-set and trophic competition and optimization of yield advantages in six capsicum cultivars using functional-structural plant modelling. _Ann Bot_. 2011;**107**(5):793–803.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Simulation+of+fruit-set+and+trophic+competition+and+optimization+of+yield+advantages+in+six+capsicum+cultivars+using+functional-structural+plant+modelling&author=Y+Ma&author=AM+Wubs&author=A+Mathieu&author=E+Heuvelink&author=JY+Zhu&author=B-G+Hu&author=P-H+Courn%C3%A8de&author=P+de+Reffye&publication_year=2011&journal=Ann+Bot&pages=793-803)

*   [a \[...\] measurements and target preparation.](#core-B54-1)
*   [b \[...\] and fruit set through parameter inversion](#core-B54-2)

56

Kang M, de Reffye P, Heuvelink E. Modeling the growth of inflorescence. In: _Proceedings of_ _2009 Third International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications_. Beijing, China: IEEE; 2009 Nov. 9–13. p. 303–310.

[Google Scholar](https://scholar.google.com/scholar?q=Kang+M%2C+de+Reffye+P%2C+Heuvelink+E.+Modeling+the+growth+of+inflorescence.+In%3A+Proceedings+of+2009+Third+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Beijing%2C+China%3A+IEEE%3B+2009+Nov.+9%E2%80%9313.+p.+303%E2%80%93310.)

*   [a \[...\] basipetal pattern of raceme development.](#core-B55-1)
*   [b \[...\] of herbaceous plants with inflorescences](#core-B55-2)
*   [c \[...\] a delay function has been introduced](#core-B55-3)
*   [d \[...\] \], chrysanthemum](#core-B55-4)

57

Kang M, Heuvelink E, Carvalho SMP, de Reffye P. A virtual plant that responds to the environment like a real one: The case for chrysanthemum. _New Phytol_. 2012;**195**(2):384–395.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+virtual+plant+that+responds+to+the+environment+like+a+real+one%3A+The+case+for+chrysanthemum&author=M+Kang&author=E+Heuvelink&author=SMP+Carvalho&author=P+Reffye&publication_year=2012&journal=New+Phytol&pages=384-395)

*   [a \[...\] basipetal pattern of raceme development.](#core-B56-1)
*   [b \[...\] a delay function has been introduced](#core-B56-2)
*   [c \[...\] \], chrysanthemum](#core-B56-3)

58

Christophe A, Letort V, Hummel I, Cournède P-H, de Reffye P, Lecœur J. A model-based analysis of the dynamics of carbon balance at the whole-plant level in Arabidopsis thaliana. _Funct Plant Biol_. 2008;**35**(11):1147–1162.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+model-based+analysis+of+the+dynamics+of+carbon+balance+at+the+whole-plant+level+in+Arabidopsis+thaliana&author=A+Christophe&author=V+Letort&author=I+Hummel&author=P-H+Courn%C3%A8de&author=P+de+Reffye&author=J+Lec%C5%93ur&publication_year=2008&journal=Funct+Plant+Biol&pages=1147-1162)

*   [a \[...\] PA: the stem Simple organic series: leaves.](#core-B57-1)
*   [b \[...\] model herbaceous plants such as Arabidopsis](#core-B57-2)

59

Letort V, Cournède P-H, Lecoeur J, Hummel I, de Reffye P, Chiustophe A. Effect of topological and phenological changes on biomass partitioning in Arabidopsis thaliana inflorescence: A preliminary model-based study. In: Fourcaud T, Zhang XP, editors. _Proceedings of the PMA 2006: Second International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications_. Beijing, China: IEEE; 2006, p. 65–69.

[Google Scholar](https://scholar.google.com/scholar?q=Letort+V%2C+Courn%C3%A8de+P-H%2C+Lecoeur+J%2C+Hummel+I%2C+de+Reffye+P%2C+Chiustophe+A.+Effect+of+topological+and+phenological+changes+on+biomass+partitioning+in+Arabidopsis+thaliana+inflorescence%3A+A+preliminary+model-based+study.+In%3A+Fourcaud+T%2C+Zhang+XP%2C+editors.+Proceedings+of+the+PMA+2006%3A+Second+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Beijing%2C+China%3A+IEEE%3B+2006%2C+p.+65%E2%80%9369.)

*   [a \[...\] PA: the stem Simple organic series: leaves.](#core-B58-1)
*   [b \[...\] model herbaceous plants such as Arabidopsis](#core-B58-2)

60

Jullien A, Mathieu A, Allirand JM, Pinet A, de Reffye P, Cournède P-H, Ney B. Characterization of the interactions between architecture and source-sink relationships in winter oilseed rape (Brassica napus) using the GreenLab model. _Ann Bot_. 2011;**107**(5):765–779.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Characterization+of+the+interactions+between+architecture+and+source-sink+relationships+in+winter+oilseed+rape+%28Brassica+napus%29+using+the+GreenLab+model&author=A+Jullien&author=A+Mathieu&author=JM+Allirand&author=A+Pinet&author=P+de+Reffye&author=P-H+Courn%C3%A8de&author=B+Ney&publication_year=2011&journal=Ann+Bot&pages=765-779)

*   [a \[...\] basipetal pattern of raceme development.](#core-B59-1)
*   [b \[...\] \], canola](#core-B59-2)

61

Jullien A, Mathieu A, Allirand JM, Pinet A, de Reffye P, Ney B, Cournède P-H. Modelling of branch and flower expansion in GreenLab model to account for the whole crop cycle of winter oilseed rape (Brassica napus L.). In: _Plant Growth Modeling, Simulation, Visualization, & Applications_. Beijing, China: IEEE; 2009. p. 167–174.

[Google Scholar](https://scholar.google.com/scholar?q=Jullien+A%2C+Mathieu+A%2C+Allirand+JM%2C+Pinet+A%2C+de+Reffye+P%2C+Ney+B%2C+Courn%C3%A8de+P-H.+Modelling+of+branch+and+flower+expansion+in+GreenLab+model+to+account+for+the+whole+crop+cycle+of+winter+oilseed+rape+%28Brassica+napus+L.%29.+In%3A+Plant+Growth+Modeling%2C+Simulation%2C+Visualization%2C+%26+Applications.+Beijing%2C+China%3A+IEEE%3B+2009.+p.+167%E2%80%93174.)

62

Jullien A, Mathieu A, Ney B, Qi R, Allirand J-M, Richard-Molard C. Use of a structure-function plant model to assess the morphogenetic plasticity. In: Kang M, Dumont Y, Guo Y, editors. _2012 IEEE Fourth International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications_. Shanghai; 2012. p. 180–187.

[Google Scholar](https://scholar.google.com/scholar?q=Jullien+A%2C+Mathieu+A%2C+Ney+B%2C+Qi+R%2C+Allirand+J-M%2C+Richard-Molard+C.+Use+of+a+structure-function+plant+model+to+assess+the+morphogenetic+plasticity.+In%3A+Kang+M%2C+Dumont+Y%2C+Guo+Y%2C+editors.+2012+IEEE+Fourth+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Shanghai%3B+2012.+p.+180%E2%80%93187.)

63

Wang X, Li D, Lin B, Hua J, Kang M, Zhang D, de Reffye P, Wang F-Y. Stochastic simulation of branch morphological structure in oilseed rape (in Chinese). _Sci Sinica Vitae_. 2019;**49**(1):67–76.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Stochastic+simulation+of+branch+morphological+structure+in+oilseed+rape+%28in+Chinese%29&author=X+Wang&author=D+Li&author=B+Lin&author=J+Hua&author=M+Kang&author=D+Zhang&author=P+de+Reffye&author=F-Y+Wang&publication_year=2019&journal=Sci+Sinica+Vitae&pages=67-76)

*   [a \[...\] basipetal pattern of raceme development.](#core-B62-1)
*   [b \[...\] \], canola](#core-B62-2)

64

Kang M, Heuvelink E, de Reffye P. Building virtual chrysanthemum based on sink-source relationships: Preliminary results. In: Marcelis LFM, VanStraten G, Stanghellini C, Heuvelink E, editors. _Proceedings of the Iiird International Symposium on Models for Plant Growth, Environmental Control and Farm Management in Protected Cultivation, (Acta Horticulturae, no. 718)_. Wageningen: ISHS; 2006. p. 129.

[Google Scholar](https://scholar.google.com/scholar?q=Kang+M%2C+Heuvelink+E%2C+de+Reffye+P.+Building+virtual+chrysanthemum+based+on+sink-source+relationships%3A+Preliminary+results.+In%3A+Marcelis+LFM%2C+VanStraten+G%2C+Stanghellini+C%2C+Heuvelink+E%2C+editors.+Proceedings+of+the+Iiird+International+Symposium+on+Models+for+Plant+Growth%2C+Environmental+Control+and+Farm+Management+in+Protected+Cultivation%2C+%28Acta+Horticulturae%2C+no.+718%29.+Wageningen%3A+ISHS%3B+2006.+p.+129.)

*   [a \[...\] basipetal pattern of raceme development.](#core-B63-1)
*   [b \[...\] \], chrysanthemum](#core-B63-2)

65

Guo H, Letort V, Hong L, Fourcaud T, Cournède P-H, Lu Y, de Reffye P. Adaptation of the GreenLab model for analyzing sink-source relationships in Chinese Pine saplings. In: Fourcaud T, Zhang XP, editors. _Proceedings of the PMA 2006: Second International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications._ Beijing, China: IEEE; 2006. p. 236.

[Google Scholar](https://scholar.google.com/scholar?q=Guo+H%2C+Letort+V%2C+Hong+L%2C+Fourcaud+T%2C+Courn%C3%A8de+P-H%2C+Lu+Y%2C+de+Reffye+P.+Adaptation+of+the+GreenLab+model+for+analyzing+sink-source+relationships+in+Chinese+Pine+saplings.+In%3A+Fourcaud+T%2C+Zhang+XP%2C+editors.+Proceedings+of+the+PMA+2006%3A+Second+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Beijing%2C+China%3A+IEEE%3B+2006.+p.+236.)

*   [a \[...\] and internodes of the stem and branches.](#core-B64-1)
*   [b \[...\] Pinus tabulaeformis](#core-B64-2)

66

Wang F, Letort V, Lu Q, Bai X, Guo Y, de Reffye P, and Li B. A functional and structural Mongolian Scots pine (Pinus sylvestris var. mongolica) model integrating architecture, biomass and effects of precipitation. _PLOS ONE_. 2012;**7**(8):e43531.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+functional+and+structural+Mongolian+Scots+pine+%28Pinus+sylvestris+var.+mongolica%29+model+integrating+architecture%2C+biomass+and+effects+of+precipitation&author=F+Wang&author=V+Letort&author=Q+Lu&author=X+Bai&author=Y+Guo&author=P+de+Reffye&author=B+Li&publication_year=2012&journal=PLOS+ONE&pages=e43531)

*   [a \[...\] and internodes of the stem and branches.](#core-B65-1)
*   [b \[...\] Pinus sylvestris](#core-B65-2)

67

Letort V, Cournède P-H, Mathieu A, de Reffye P, Constant T. Parametric identification of a functional-structural tree growth model and application to beech trees (Fagus sylvatica). _Funct Plant Biol_. 2008;**35**(9-10):951–963.

[GO TO REFERENCE](#core-B66-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Parametric+identification+of+a+functional-structural+tree+growth+model+and+application+to+beech+trees+%28Fagus+sylvatica%29&author=V+Letort&author=P-H+Courn%C3%A8de&author=A+Mathieu&author=P+de+Reffye&author=T+Constant&publication_year=2008&journal=Funct+Plant+Biol&pages=951-963)

68

de Reffye P, Kang M, Hua J, Auclair D. Stochastic modelling of tree annual shoot dynamics. _Ann For Sci_. 2012;**69**(2):153–165.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Stochastic+modelling+of+tree+annual+shoot+dynamics&author=P+Reffye&author=M+Kang&author=J+Hua&author=D+Auclair&publication_year=2012&journal=Ann+For+Sci&pages=153-165)

*   [a \[...\] developed for multiple pruning of trees](#core-B67-1)
*   [b \[...\] between GUs but also within GUs](#core-B67-2)

69

Qi R, Ma Y, Hu B, de Reffye P, Cournède P-H. Optimization of source-sink dynamics in plant growth for ideotype breeding: A case study on maize. _Comput Electron Agric_. 2010;**71**(1):96–105.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Optimization+of+source-sink+dynamics+in+plant+growth+for+ideotype+breeding%3A+A+case+study+on+maize&author=R+Qi&author=Y+Ma&author=B+Hu&author=P+de+Reffye&author=P-H+Courn%C3%A8de&publication_year=2010&journal=Comput+Electron+Agric&pages=96-105)

*   [a \[...\] applied to the optimization of maize yield](#core-B68-1)
*   [b \[...\] \], and parameter optimization techniques](#core-B68-2)

70

Qi R, Letort V, Kang M, Cournède P-H, de Reffye P, Fourcaud T. Application of the GreenLab model to simulate and optimize wood production and tree stability: A theoretical study. _Silva Fennica_. 2009;**43**(3):465–487.

[GO TO REFERENCE](#core-B69-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Application+of+the+GreenLab+model+to+simulate+and+optimize+wood+production+and+tree+stability%3A+A+theoretical+study&author=R+Qi&author=V+Letort&author=M+Kang&author=P-H+Courn%C3%A8de&author=P+de+Reffye&author=T+Fourcaud&publication_year=2009&journal=Silva+Fennica&pages=465-487)

71

Wang H, Kang M, Hua J. Simulating plant plasticity under light environment: A source-sink approach. In: _2012 IEEE Fourth International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications_. Shanghai, China: IEEE; 2012, p. 431–438.

[Google Scholar](https://scholar.google.com/scholar?q=Wang+H%2C+Kang+M%2C+Hua+J.+Simulating+plant+plasticity+under+light+environment%3A+A+source-sink+approach.+In%3A+2012+IEEE+Fourth+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Shanghai%2C+China%3A+IEEE%3B+2012%2C+p.+431%E2%80%93438.)

*   [a \[...\] of trees under different light conditions](#core-B71-1)
*   [b \[...\] \] and photosynthesis models](#core-B71-2)

72

Wang H, Hua J, Kang M, Wang X, Fan X-R, Fourcaud T, de Reffye P. Stronger wind, smaller tree: Testing tree growth plasticity through a modeling approach. _Front Plant Sci_. 2022;**13**:971690.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Stronger+wind%2C+smaller+tree%3A+Testing+tree+growth+plasticity+through+a+modeling+approach&author=H+Wang&author=J+Hua&author=M+Kang&author=X+Wang&author=X-R+Fan&author=T+Fourcaud&author=P+de+Reffye&publication_year=2022&journal=Front+Plant+Sci&pages=971690)

*   [a \[...\] \] and wind effect](#core-B72-1)
*   [b \[...\] \], and parameter optimization techniques](#core-B72-2)

73

Wu Q-L, Cournède P-H, Mathieu A. An efficient computational method for global sensitivity analysis and its application to tree growth modelling. _Reliabil Eng Syst Safety_. 2012;**107**:35–43.

[GO TO REFERENCE](#core-B73-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=An+efficient+computational+method+for+global+sensitivity+analysis+and+its+application+to+tree+growth+modelling&author=Q-L+Wu&author=P-H+Courn%C3%A8de&author=A+Mathieu&publication_year=2012&journal=Reliabil+Eng+Syst+Safety&pages=35-43)

74

Lin Y, Kang M, Hua J. Fitting a functional structural plant model based on global sensitivity analysis. Paper presented at: 2012 IEEE International Conference on Automation Science and Engineering (CASE); Seoul, South Korea; 2012 Aug. 20–24. p. 790–795.

[Google Scholar](https://scholar.google.com/scholar?q=Lin+Y%2C+Kang+M%2C+Hua+J.+Fitting+a+functional+structural+plant+model+based+on+global+sensitivity+analysis.+Paper+presented+at%3A+2012+IEEE+International+Conference+on+Automation+Science+and+Engineering+%28CASE%29%3B+Seoul%2C+South+Korea%3B+2012+Aug.+20%E2%80%9324.+p.+790%E2%80%93795.)

75

Mathieu A, Vidal T, Jullien A, Wu Q-L, Chambon C, Bayol B, Cournède P-H. A new methodology based on sensitivity analysis to simplify the recalibration of functional-structural plant models in new conditions. _Ann Bot_. 2018;**122**(3):397–408.

[GO TO REFERENCE](#core-B75-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+new+methodology+based+on+sensitivity+analysis+to+simplify+the+recalibration+of+functional-structural+plant+models+in+new+conditions&author=A+Mathieu&author=T+Vidal&author=A+Jullien&author=Q-L+Wu&author=C+Chambon&author=B+Bayol&author=P-H+Courn%C3%A8de&publication_year=2018&journal=Ann+Bot&pages=397-408)

76

Letort V, Mahe P, Cournède P-H, de Reffye P, Courtois B. Quantitative genetics and functional-structural plant growth models: Simulation of quantitative trait loci detection for model parameters and application to potential yield optimization. _Ann Bot_. 2008;**101**(8):1243–1254.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Quantitative+genetics+and+functional-structural+plant+growth+models%3A+Simulation+of+quantitative+trait+loci+detection+for+model+parameters+and+application+to+potential+yield+optimization&author=V+Letort&author=P+Mahe&author=P-H+Courn%C3%A8de&author=P+de+Reffye&author=B+Courtois&publication_year=2008&journal=Ann+Bot&pages=1243-1254)

*   [a \[...\] as the simulation study by Letort et al.](#core-B76-1)
*   [b \[...\] micro-scale. As studied by Letort et al.](#core-B76-2)
*   [c \[...\] model parameters and genetic factors](#core-B76-3)
*   [d \[...\] compatible with micro-scale genetic models](#core-B76-4)

77

Fan X-R, Kang M, Heuvelink E, de Reffye P, Hu B-G. A knowledge-and-data-driven modeling approach for simulating plant growth: A case study on tomato growth. _Ecol Model_. 2015;**312**:363–373.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+knowledge-and-data-driven+modeling+approach+for+simulating+plant+growth%3A+A+case+study+on+tomato+growth&author=X-R+Fan&author=M+Kang&author=E+Heuvelink&author=P+de+Reffye&author=B-G+Hu&publication_year=2015&journal=Ecol+Model&pages=363-373)

*   [a \[...\] crop yield, like the study of Fan et al.](#core-B77-1)
*   [b \[...\] such as the previously mentioned KDDM](#core-B77-2)
*   [c \[...\] \], the integration with the ML method](#core-B77-3)

78

Fan X-R, Wang X, Kang M, Hua J, Guo S, de Reffye P, Hu B-G. A knowledge-and-data-driven modeling approach for simulating plant growth and the dynamics of CO2/O-2 concentrations in a closed system of plants and humans by integrating mechanistic and empirical models. _Comput Electron Agric_. 2018;**148**:280–290.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+knowledge-and-data-driven+modeling+approach+for+simulating+plant+growth+and+the+dynamics+of+CO2%2FO-2+concentrations+in+a+closed+system+of+plants+and+humans+by+integrating+mechanistic+and+empirical+models&author=X-R+Fan&author=X+Wang&author=M+Kang&author=J+Hua&author=S+Guo&author=P+de+Reffye&author=B-G+Hu&publication_year=2018&journal=Comput+Electron+Agric&pages=280-290)

*   [a \[...\] between carbon, plants, and gases](#core-B78-1)
*   [b \[...\] such as the previously mentioned KDDM](#core-B78-2)

79

Zhan Z, de Reffye P, Houllier F, Hu B-G. Fitting a functional-structural growth model with plant architectural data. In: Hu B-G, Jaeger M, editors. _Proceedings of the Plant Growth Modeling and Applications_. Beijing, China: Tsinghua University Press, Springer; 2003. p. 236–249.

[Google Scholar](https://scholar.google.com/scholar?q=Zhan+Z%2C+de+Reffye+P%2C+Houllier+F%2C+Hu+B-G.+Fitting+a+functional-structural+growth+model+with+plant+architectural+data.+In%3A+Hu+B-G%2C+Jaeger+M%2C+editors.+Proceedings+of+the+Plant+Growth+Modeling+and+Applications.+Beijing%2C+China%3A+Tsinghua+University+Press%2C+Springer%3B+2003.+p.+236%E2%80%93249.)

*   [a \[...\] petioles, internodes, and caps on the stem.](#core-B79-1)
*   [b \[...\] tomato, wheat, and beetroot using the WLSM](#core-B79-2)
*   [c \[...\] \], the inverse of source–sink parameters](#core-B79-3)

80

Kang M, Qi R, de Reffye P, Hu B-G. GreenScilab: A toolbox simulating plant growth in the Scilab environment. Paper presented at: Mesm ‘2006: 8th Middle East Simulation Multiconference. 2006; Alexandria, Egypt. p. 174.

[GO TO REFERENCE](#core-B80-1)

[Google Scholar](https://scholar.google.com/scholar?q=Kang+M%2C+Qi+R%2C+de+Reffye+P%2C+Hu+B-G.+GreenScilab%3A+A+toolbox+simulating+plant+growth+in+the+Scilab+environment.+Paper+presented+at%3A+Mesm+%E2%80%982006%3A+8th+Middle+East+Simulation+Multiconference.+2006%3B+Alexandria%2C+Egypt.+p.+174.)

81

Kang M, Wang X, Qi R, de Reffye P. GreenScilab-Crop, An open source software for plant simulation and parameter estimation. In: Hu B-G, Xie XY, Saguez C, Gomez C, editors. _Proceedings of the 2009 IEEE International Workshop on Open-Source Software for Scientific Computation_. Guiyang, China: IEEE; 2009. p. 91.

[GO TO REFERENCE](#core-B81-1)

[Google Scholar](https://scholar.google.com/scholar?q=Kang+M%2C+Wang+X%2C+Qi+R%2C+de+Reffye+P.+GreenScilab-Crop%2C+An+open+source+software+for+plant+simulation+and+parameter+estimation.+In%3A+Hu+B-G%2C+Xie+XY%2C+Saguez+C%2C+Gomez+C%2C+editors.+Proceedings+of+the+2009+IEEE+International+Workshop+on+Open-Source+Software+for+Scientific+Computation.+Guiyang%2C+China%3A+IEEE%3B+2009.+p.+91.)

82

Ribeyre F, Jaeger M, Ribeyre A, de Reffye P. StemGL, a FSPM tool dedicated to crop plants model calibration in the single stem case. Paper presented at: 2018 6th International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA); 2018 Nov. 4 to 8; Hefei, China.

[GO TO REFERENCE](#core-B82-1)

[Google Scholar](https://scholar.google.com/scholar?q=Ribeyre+F%2C+Jaeger+M%2C+Ribeyre+A%2C+de+Reffye+P.+StemGL%2C+a+FSPM+tool+dedicated+to+crop+plants+model+calibration+in+the+single+stem+case.+Paper+presented+at%3A+2018+6th+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications+%28PMA%29%3B+2018+Nov.+4+to+8%3B+Hefei%2C+China.)

83

de Reffye P, Jaeger M, Sabatier S, Letort V. Modelling the interaction between functioning and organogenesis in a stochastic plant growth model: Methodology for parameter estimation and illustration. Paper presented at: 2018 6th International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications (PMA); 2018 Nov. 4 to 8; Hefei, China.

[GO TO REFERENCE](#core-B83-1)

[Google Scholar](https://scholar.google.com/scholar?q=de+Reffye+P%2C+Jaeger+M%2C+Sabatier+S%2C+Letort+V.+Modelling+the+interaction+between+functioning+and+organogenesis+in+a+stochastic+plant+growth+model%3A+Methodology+for+parameter+estimation+and+illustration.+Paper+presented+at%3A+2018+6th+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications+%28PMA%29%3B+2018+Nov.+4+to+8%3B+Hefei%2C+China.)

84

Hua J, Kang M. Functional tree models reacting to the environment. In: _International Conference on Computer Graphics & Interactive Techniques_. Vancouver, British Columbia, Canada: ACM; 2011.

[Google Scholar](https://scholar.google.com/scholar?q=Hua+J%2C+Kang+M.+Functional+tree+models+reacting+to+the+environment.+In%3A+International+Conference+on+Computer+Graphics+%26+Interactive+Techniques.+Vancouver%2C+British+Columbia%2C+Canada%3A+ACM%3B+2011.)

*   [a \[...\] developed, such as Digiplante and QingYuan](#core-B84-1)
*   [b \[...\] The QingYuan simulator, piloted by CASIA](#core-B84-2)

85

Hua J, Kang M. Management of crop pruning assisted by computational experiment. Paper presented at: Advances in Biomedical Engineering; 2011; Hongkong.

[Google Scholar](https://scholar.google.com/scholar?q=Hua+J%2C+Kang+M.+Management+of+crop+pruning+assisted+by+computational+experiment.+Paper+presented+at%3A+Advances+in+Biomedical+Engineering%3B+2011%3B+Hongkong.)

*   [a \[...\] internodes, and fruits on the main stem.](#core-B85-1)
*   [b \[...\] The QingYuan simulator, piloted by CASIA](#core-B85-2)

86

Watson A, Ghosh S, Williams MJ, Cuddy WS, Simmonds J, Rey MD, Asyraf Md Hatta M, Hinchliffe A, Steed A, Reynolds D, et al. Speed breeding is a powerful tool to accelerate crop research and breeding. _Nat Plants_. 2018;**4**(1):23–29.

[GO TO REFERENCE](#core-B86-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Speed+breeding+is+a+powerful+tool+to+accelerate+crop+research+and+breeding&author=A+Watson&author=S+Ghosh&author=MJ+Williams&author=WS+Cuddy&author=J+Simmonds&author=MD+Rey&author=M+Asyraf+Md+Hatta&author=A+Hinchliffe&author=A+Steed&author=D+Reynolds&publication_year=2018&journal=Nat+Plants&pages=23-29)

87

Swami P, Deswal K, Rana V, Yadav D, Munjal R. Chapter 3: Speed breeding—A powerful tool to breed more crops in less time accelerating crop research. In: Khan MK, Pandey A, Hamurcu M, Gupta OP, Gezgin S, editors. _Abiotic stresses in wheat_. Academic Press; 2023. p. 33–49.

[Google Scholar](https://scholar.google.com/scholar?q=Swami+P%2C+Deswal+K%2C+Rana+V%2C+Yadav+D%2C+Munjal+R.+Chapter%C2%A03%3A+Speed+breeding%E2%80%94A+powerful+tool+to+breed+more+crops+in+less+time+accelerating+crop+research.+In%3A+Khan+MK%2C+Pandey+A%2C+Hamurcu+M%2C+Gupta+OP%2C+Gezgin+S%2C+editors.+Abiotic+stresses+in+wheat.+Academic+Press%3B+2023.+p.+33%E2%80%9349.)

*   [a \[...\] significantly reduce this lengthy timeline](#core-B87-1)
*   [b \[...\] of which come with substantial expenses](#core-B87-2)

88

Ghosh S, Watson A, Gonzalez-Navarro OE, Ramirez-Gonzalez RH, Yanes L, Mendoza-Suárez M, Simmonds J, Wells R, Rayner T, Green P, et al. Speed breeding in growth chambers and glasshouses for crop breeding and model plant research. _Nat Protoc_. 2018;**13**(12):2944–2963.

[GO TO REFERENCE](#core-B88-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Speed+breeding+in+growth+chambers+and+glasshouses+for+crop+breeding+and+model+plant+research&author=S+Ghosh&author=A+Watson&author=OE+Gonzalez-Navarro&author=RH+Ramirez-Gonzalez&author=L+Yanes&author=M+Mendoza-Su%C3%A1rez&author=J+Simmonds&author=R+Wells&author=T+Rayner&author=P+Green&publication_year=2018&journal=Nat+Protoc&pages=2944-2963)

89

Hu Y, Schmidhalter U. Opportunity and challenges of phenotyping plant salt tolerance. _Trends Plant Sci_. 2023;**28**(5):552–566.

[GO TO REFERENCE](#core-B89-1)

[Crossref](https://doi.org/10.1016/j.tplants.2022.12.010)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Opportunity+and+challenges+of+phenotyping+plant+salt+tolerance&author=Y+Hu&author=U+Schmidhalter&publication_year=2023&journal=Trends+Plant+Sci&pages=552-566&doi=10.1016%2Fj.tplants.2022.12.010)

90

Yang W, Feng H, Zhang X, Zhang J, Doonan JH, Batchelor WD, Xiong L, Yan J. Crop Phenomics and high-throughput phenotyping: Past decades, current challenges, and future perspectives. _Mol Plant_. 2020;**13**(2):187–214.

[GO TO REFERENCE](#core-B90-1)

[Crossref](https://doi.org/10.1016/j.molp.2020.01.008)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Crop+Phenomics+and+high-throughput+phenotyping%3A+Past+decades%2C+current+challenges%2C+and+future+perspectives&author=W+Yang&author=H+Feng&author=X+Zhang&author=J+Zhang&author=JH+Doonan&author=WD+Batchelor&author=L+Xiong&author=J+Yan&publication_year=2020&journal=Mol+Plant&pages=187-214&doi=10.1016%2Fj.molp.2020.01.008)

91

Lemaire S, Maupas F, Cournède P-H, de Reffye P. A morphogenetic crop model for sugar-beet (Beta vulgaris L.). In: Cao W, White JW, Wang E, editors. _Crop modeling and decision support_. Berlin, Heidelberg: Springer Berlin Heidelberg; 2009. p. 116–129.

[Google Scholar](https://scholar.google.com/scholar?q=Lemaire+S%2C+Maupas+F%2C+Courn%C3%A8de+P-H%2C+de+Reffye+P.+A+morphogenetic+crop+model+for+sugar-beet+%28Beta+vulgaris+L.%29.+In%3A+Cao+W%2C+White+JW%2C+Wang+E%2C+editors.+Crop+modeling+and+decision+support.+Berlin%2C+Heidelberg%3A+Springer+Berlin+Heidelberg%3B+2009.+p.+116%E2%80%93129.)

*   [a \[...\] of leaves and the tape root on the stem.](#core-B91-1)
*   [b \[...\] with PBMs. For instance, Lemaire et al.](#core-B91-2)

92

Feng L, Mailhol JC, Rey H, Griffon S, Auclair D, de Reffye P. Comparing an empirical crop model with a functional structural plant model to account for individual variability. _Eur J Agron_. 2014;**53**:16–27.

[GO TO REFERENCE](#core-B92-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Comparing+an+empirical+crop+model+with+a+functional+structural+plant+model+to+account+for+individual+variability&author=L+Feng&author=JC+Mailhol&author=H+Rey&author=S+Griffon&author=D+Auclair&author=P+de+Reffye&publication_year=2014&journal=Eur+J+Agron&pages=16-27)

93

Chew YH, Wenden B, Flis A, Mengin V, Taylor J, Davey CL, Tindal C, Thomas H, Ougham HJ, de Reffye P. Multiscale digital Arabidopsis predicts individual organ and whole-organism growth. _Proc Natl Acad Sci USA_. 2014;**111**(39):E4127.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Multiscale+digital+Arabidopsis+predicts+individual+organ+and+whole-organism+growth&author=YH+Chew&author=B+Wenden&author=A+Flis&author=V+Mengin&author=J+Taylor&author=CL+Davey&author=C+Tindal&author=H+Thomas&author=HJ+Ougham&author=P+de+Reffye&publication_year=2014&journal=Proc+Natl+Acad+Sci+USA&pages=E4127)

*   [a \[...\] PA: the stem Simple organic series: leaves.](#core-B93-1)
*   [b \[...\] combinations and predict yields. Chew](#core-B93-2)
*   [c \[...\] to influence plant growth and development](#core-B93-3)

94

Wang X, Kang M, Hua J, de Reffye P. From stand to organ level—A trial of connecting DSSAT and GreenLab crop model through data. _Smart Agric_. 2021;**3**(2):77–87.

[Google Scholar](https://scholar.google.com/scholar_lookup?title=From+stand+to+organ+level%E2%80%94A+trial+of+connecting+DSSAT+and+GreenLab+crop+model+through+data&author=X+Wang&author=M+Kang&author=J+Hua&author=P+Reffye&publication_year=2021&journal=Smart+Agric&pages=77-87)

*   [a \[...\] a population scale, such as DSSAT or APSIM](#core-B94-1)
*   [b \[...\] \], and the link with APSIM](#core-B94-2)
*   [c \[...\] within different environmental conditions](#core-B94-3)

95

Jeong S, Ko J, Yeom J-M. Predicting rice yield at pixel scale through synthetic use of crop and deep learning models with satellite data in South and North Korea. _Sci Total Environ_. 2022;**802**:149726.

[GO TO REFERENCE](#core-B95-1)

[Crossref](https://doi.org/10.1016/j.scitotenv.2021.149726)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Predicting+rice+yield+at+pixel+scale+through+synthetic+use+of+crop+and+deep+learning+models+with+satellite+data+in+South+and+North+Korea&author=S+Jeong&author=J+Ko&author=J-M&publication_year=2022&journal=Sci+Total+Environ&pages=149726&doi=10.1016%2Fj.scitotenv.2021.149726)

96

Feng P, Wang B, Liu DL, Waters C, Xiao D, Shi L, Yu Q. Dynamic wheat yield forecasts are improved by a hybrid approach using a biophysical model and machine learning technique. _Agric For Meteorol_. 2020;**285-286**:107922.

[GO TO REFERENCE](#core-B96-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Dynamic+wheat+yield+forecasts+are+improved+by+a+hybrid+approach+using+a+biophysical+model+and+machine+learning+technique&author=P+Feng&author=B+Wang&author=DL+Liu&author=C+Waters&author=D+Xiao&author=L+Shi&author=Q+Yu&publication_year=2020&journal=Agric+For+Meteorol&pages=107922)

97

Chen Y, Tao F. Potential of remote sensing data-crop model assimilation and seasonal weather forecasts for early-season crop yield forecasting over a large area. _Field Crop Res_. 2022;**276**:108398.

[GO TO REFERENCE](#core-B97-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Potential+of+remote+sensing+data-crop+model+assimilation+and+seasonal+weather+forecasts+for+early-season+crop+yield+forecasting+over+a+large+area&author=Y+Chen&author=F+Tao&publication_year=2022&journal=Field+Crop+Res&pages=108398)

98

Kang F, Cournéde P-H, Lecoeur J, Letort V. SUNLAB: A functional-structural model for genotypic and phenotypic characterization of the sunflower crop. _Ecol Model_. 2014;**290**:21–33.

[GO TO REFERENCE](#core-B98-1)

[Crossref](https://doi.org/10.1016/j.ecolmodel.2014.02.006)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=SUNLAB%3A+A+functional-structural+model+for+genotypic+and+phenotypic+characterization+of+the+sunflower+crop&author=F+Kang&author=P-H+Courn%C3%A9de&author=J+Lecoeur&author=V+Letort&publication_year=2014&journal=Ecol+Model&pages=21-33&doi=10.1016%2Fj.ecolmodel.2014.02.006)

99

Kang M, Evers JB, Vos J, de Reffye P. The derivation of sink functions of wheat organs using the GREENLAB model. _Ann Bot_. 2008;**101**(8):1099–1108.

[GO TO REFERENCE](#core-B99-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=The+derivation+of+sink+functions+of+wheat+organs+using+the+GREENLAB+model&author=M+Kang&author=JB+Evers&author=J+Vos&author=P+de+Reffye&publication_year=2008&journal=Ann+Bot&pages=1099-1108)

100

Song Y, Luquet D, Mathieu A, de Reffye P, Dingkuhn M. Using greenlab model to assist to analyse rice morphogenesis: Case of Phyllo mutant and its wild type ‘Nippon Bare’. In: _Proceedings of the PMA 2006: Second International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications._ Beijing, China: IEEE; 2006. p. 169.

[GO TO REFERENCE](#core-B100-1)

[Google Scholar](https://scholar.google.com/scholar?q=Song+Y%2C+Luquet+D%2C+Mathieu+A%2C+de+Reffye+P%2C+Dingkuhn+M.+Using+greenlab+model+to+assist+to+analyse+rice+morphogenesis%3A+Case+of+Phyllo+mutant+and+its+wild+type+%E2%80%98Nippon+Bare%E2%80%99.+In%3A+Proceedings+of+the+PMA+2006%3A+Second+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Beijing%2C+China%3A+IEEE%3B+2006.+p.+169.)

101

Zheng B, Ma Y, Li B, Guo Y, Deng Q. Assessment of the effects of leaf angle combinations on potential photosynthesis capacity of rice with 3-D models using high performance computing. Paper presented at: 2009 Third International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; 2009 Nov. 9 to 13; Beijing, China.

[GO TO REFERENCE](#core-B101-1)

[Google Scholar](https://scholar.google.com/scholar?q=Zheng+B%2C+Ma+Y%2C+Li+B%2C+Guo+Y%2C+Deng+Q.+Assessment+of+the+effects+of+leaf+angle+combinations+on+potential+photosynthesis+capacity+of+rice+with+3-D+models+using+high+performance+computing.+Paper+presented+at%3A+2009+Third+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+2009+Nov.+9+to+13%3B+Beijing%2C+China.)

102

de Reffye P, Blaise F, Chemouny S, Jaffuel S, Fourcaud T, Houllier F. Calibration of a hydraulic architecture-based growth model of cotton plants. _Agronomie_, 1999;**19**(3-4):265-280.

[GO TO REFERENCE](#core-B102-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Calibration+of+a+hydraulic+architecture-based+growth+model+of+cotton+plants&author=P+Reffye&author=F+Blaise&author=S+Chemouny&author=S+Jaffuel&author=T+Fourcaud&author=F+Houllier&publication_year=1999&journal=Agronomie&pages=265-280)

103

Zhan Z, Rey H, Li D, Guo Y, Cournède P-H, de Reffye P. Study on the effects of defoliation on the growth of cotton plant using the functional structural model GREENLAB. In: Fourcaud T, Zhang XP, editors. _Proceedings of the PMA 2006: Second International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications._ Beijing, China: IEEE; 2006. p. 194.

[Google Scholar](https://scholar.google.com/scholar?q=Zhan+Z%2C+Rey+H%2C+Li+D%2C+Guo+Y%2C+Courn%C3%A8de+P-H%2C+de+Reffye+P.+Study+on+the+effects+of+defoliation+on+the+growth+of+cotton+plant+using+the+functional+structural+model+GREENLAB.+In%3A+Fourcaud+T%2C+Zhang+XP%2C+editors.+Proceedings+of+the+PMA+2006%3A+Second+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications.+Beijing%2C+China%3A+IEEE%3B+2006.+p.+194.)

104

Li D, Letort V, Guo Y, de Reffye P, Zhan Z. Modeling branching effects on source-sink relationships of the cotton plant. Paper presented at: International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; 2009; Beijing, China.

[GO TO REFERENCE](#core-B104-1)

[Google Scholar](https://scholar.google.com/scholar?q=Li+D%2C+Letort+V%2C+Guo+Y%2C+de+Reffye+P%2C+Zhan+Z.+Modeling+branching+effects+on+source-sink+relationships+of+the+cotton+plant.+Paper+presented+at%3A+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+2009%3B+Beijing%2C+China.)

105

Dong Q, Louarn G, Wang Y, Barczi JF, de Reffye P. Does the structure-function model GREENLAB deal with crop phenotypic plasticity induced by plant spacing? A case study on tomato. _Ann Bot_. 2008;**101**(8):1195–1206.

[GO TO REFERENCE](#core-B105-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Does+the+structure-function+model+GREENLAB+deal+with+crop+phenotypic+plasticity+induced+by+plant+spacing%3F+A+case+study+on+tomato&author=Q+Dong&author=G+Louarn&author=Y+Wang&author=JF+Barczi&author=P+de+Reffye&publication_year=2008&journal=Ann+Bot&pages=1195-1206)

106

Zhang B, Kang M, Letort V, Wang X, de Reffye P. Comparison between empirical or functional sinks of organs—Application on tomato plant. Paper presented at: 2009 Third International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; Beijing; 2009 Nov. 9–13. p. 191–197.

[GO TO REFERENCE](#core-B106-1)

[Google Scholar](https://scholar.google.com/scholar?q=Zhang+B%2C+Kang+M%2C+Letort+V%2C+Wang+X%2C+de+Reffye+P.+Comparison+between+empirical+or+functional+sinks+of+organs%E2%80%94Application+on+tomato+plant.+Paper+presented+at%3A+2009+Third+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+Beijing%3B+2009+Nov.+9%E2%80%9313.+p.+191%E2%80%93197.)

107

Mathieu A, Letort V, Cournède P-H, Zhang BG, Heuret P, de Reffye P. Oscillations in functional structural plant growth models. _Math Model Natur Phenom_. 2012;**7**(6):47–66.

[GO TO REFERENCE](#core-B107-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Oscillations+in+functional+structural+plant+growth+models&author=A+Mathieu&author=V+Letort&author=P-H+Courn%C3%A8de&author=BG+Zhang&author=P+Heuret&author=P+de+Reffye&publication_year=2012&journal=Math+Model+Natur+Phenom&pages=47-66)

108

Ma Y, Zhu J, Hu B-G, Heuvelink E, de Reffye P. Simulation of spatial and temporal variation of fruit set patterns on pepper plant based on ‘source-sink’ theory. _Acta Ecologica Sinica_. 2010;**30**(24):7072–7078.

[GO TO REFERENCE](#core-B108-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Simulation+of+spatial+and+temporal+variation+of+fruit+set+patterns+on+pepper+plant+based+on+%E2%80%98source-sink%E2%80%99+theory&author=Y+Ma&author=J+Zhu&author=B-G+Hu&author=E+Heuvelink&author=P+de+Reffye&publication_year=2010&journal=Acta+Ecologica+Sinica&pages=7072-7078)

109

Ma Y, Mathieu A, Wubs AM, Heuvelink E, Zhu J, Hu B-G, Cournède PH, de Reffye P. Parameter estimation and growth variation analysis in six capsicum cultivars with the functional-structural model GreenLab. Paper presented at: 2009 Third International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; 2009 Nov. 9 to 13; Beijing, China.

[GO TO REFERENCE](#core-B109-1)

[Google Scholar](https://scholar.google.com/scholar?q=Ma+Y%2C+Mathieu+A%2C+Wubs+AM%2C+Heuvelink+E%2C+Zhu+J%2C+Hu+B-G%2C+Courn%C3%A8de+PH%2C+de+Reffye+P.+Parameter+estimation+and+growth+variation+analysis+in+six+capsicum+cultivars+with+the+functional-structural+model+GreenLab.+Paper+presented+at%3A+2009+Third+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+2009+Nov.+9+to+13%3B+Beijing%2C+China.)

110

Letort V, Sabatier S, Akaffou S, Hamon S, Hamon P, de Reffye P. Interspecific variability of biomass production of young coffea: No influence of branch pruning. Experimental evidence and theoretical analysis. Paper presented at: 2012 IEEE Fourth International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; 2012; Shanghai, China.

[GO TO REFERENCE](#core-B110-1)

[Google Scholar](https://scholar.google.com/scholar?q=Letort+V%2C+Sabatier+S%2C+Akaffou+S%2C+Hamon+S%2C+Hamon+P%2C+de+Reffye+P.+Interspecific+variability+of+biomass+production+of+young+coffea%3A+No+influence+of+branch+pruning.+Experimental+evidence+and+theoretical+analysis.+Paper+presented+at%3A+2012+IEEE+Fourth+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+2012%3B+Shanghai%2C+China.)

111

Okoma P, Akaffou S, de Reffye P, Hamon P, Hamon S, Konan O, Kouassi KH, Legnate H, Letort V, Sabatier S. Estimation of stem and leaf dry biomass using a non-destructive method applied to African Coffea species. _Agrofor Syst_. 2016;**92**(3):667–675.

[GO TO REFERENCE](#core-B111-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=Estimation+of+stem+and+leaf+dry+biomass+using+a+non-destructive+method+applied+to+African+Coffea+species&author=P+Okoma&author=S+Akaffou&author=P+de+Reffye&author=P+Hamon&author=S+Hamon&author=O+Konan&author=KH+Kouassi&author=H+Legnate&author=V+Letort&author=S+Sabatier&publication_year=2016&journal=Agrofor+Syst&pages=667-675)

112

Guo H, Lei X-D, Letort V, Lu Y-C, de Reffye P. A Functional-Structural Model GreenLab for Pinus Tabulaeformis. _Acta Phytoecologica Sinica_. 2009;**33**(5):950–957.

[GO TO REFERENCE](#core-B112-1)

[Google Scholar](https://scholar.google.com/scholar_lookup?title=A+Functional-Structural+Model+GreenLab+for+Pinus+Tabulaeformis&author=H+Guo&author=X-D+Lei&author=V+Letort&author=Y-C+Lu&author=P+Reffye&publication_year=2009&journal=Acta+Phytoecologica+Sinica&pages=950-957)

113

Guo H, Lu Y, Diao J, Letort V, de Reffye P. _Source-sink relationships vary with age in Chinese pine (Pinus tabulaeformis Carr.): Analysis using the GreenLab model_. Paper presented at: 2012 IEEE Fourth International Symposium on Plant Growth Modeling, Simulation, Visualization and Applications; 2012; Shanghai, China.

[GO TO REFERENCE](#core-B113-1)

[Google Scholar](https://scholar.google.com/scholar?q=Guo+H%2C+Lu+Y%2C+Diao+J%2C+Letort+V%2C+de+Reffye+P.+Source-sink+relationships+vary+with+age+in+Chinese+pine+%28Pinus+tabulaeformis+Carr.%29%3A+Analysis+using+the+GreenLab+model.+Paper+presented+at%3A+2012+IEEE+Fourth+International+Symposium+on+Plant+Growth+Modeling%2C+Simulation%2C+Visualization+and+Applications%3B+2012%3B+Shanghai%2C+China.)
