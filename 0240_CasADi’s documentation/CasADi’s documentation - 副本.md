# Welcome to CasADi’s documentation![¶](#welcome-to-casadi-s-documentation "Permalink to this heading")

https://web.casadi.org/docs/

# 欢迎来到CasADi文档![¶](#welcome-to-casadi-s-documentation "Permalink to this heading")

另请参阅:

*   [PDF版本](https://github.com/casadi/casadi/releases/download/3.7.0/casadi-users_guide-v3.7.0.pdf)
*   [C++ API](../api/html/)
*   [Python API](../python-api)
*   [示例包](https://github.com/casadi/casadi/releases/download/3.7.0/casadi-example_pack-v3.7.0.zip)

目录:

*   [1. 简介](#document-intro)
    *   [1.1. CasADi是什么与不是什么](#what-casadi-is-and-what-it-is-not)
    *   [1.2. 帮助与支持](#help-and-support)
    *   [1.3. 引用CasADi](#citing-casadi)
    *   [1.4. 阅读本文档](#reading-this-document)
*   [2. 获取与安装](#document-install)
*   [3. 符号框架](#document-symbolic)
    *   [3.1. `SX`符号系统](#the-sx-symbolics)
    *   [3.2. `DM`](#dm)
    *   [3.3. `MX`符号系统](#the-mx-symbolics)
    *   [3.4. 混合`SX`和`MX`](#mixing-sx-and-mx)
    *   [3.5. `Sparsity`类](#the-sparsity-class)
    *   [3.6. 算术运算](#arithmetic-operations)
    *   [3.7. 查询属性](#querying-properties)
    *   [3.8. 线性代数](#linear-algebra)
    *   [3.9. 微积分 - 算法微分](#calculus-algorithmic-differentiation)
*   [4. 函数对象](#document-function)
    *   [4.1. 调用函数对象](#calling-function-objects)
    *   [4.2. 将`MX`转换为`SX`](#converting-mx-to-sx)
    *   [4.3. 非线性求根问题](#nonlinear-root-finding-problems)
    *   [4.4. 初值问题与灵敏度分析](#initial-value-problems-and-sensitivity-analysis)
    *   [4.5. 非线性规划](#nonlinear-programming)
    *   [4.6. 二次规划](#quadratic-programming)
    *   [4.7. For循环等价实现](#for-loop-equivalents)
*   [5. 生成C代码](#document-ccode)
    *   [5.1. 生成代码的语法](#syntax-for-generating-code)
    *   [5.2. 使用生成的代码](#using-the-generated-code)
    *   [5.3. 生成代码的API](#api-of-the-generated-code)
*   [6. 用户自定义函数对象](#document-custom)
    *   [6.1. 继承`FunctionInternal`](#subclassing-functioninternal)
    *   [6.2. 继承`Callback`](#subclassing-callback)
    *   [6.3. 使用`external`导入函数](#importing-a-function-with-external)
    *   [6.4. 即时编译C语言字符串](#just-in-time-compile-a-c-language-string)
    *   [6.5. 使用查找表](#using-lookup-tables)
    *   [6.6. 使用有限差分计算导数](#derivative-calculation-using-finite-differences)
*   [7. `DaeBuilder`类](#document-daebuilder)
    *   [7.1. `DaeBuilder`模型变量及其分类](#daebuilder-model-variables-and-their-categorization)
    *   [7.2. `DaeBuilder`模型方程](#daebuilder-model-equations)
    *   [7.3. 符号化构建`DaeBuilder`实例](#constructing-a-daebuilder-instance-symbolically)
    *   [7.4. 从Modelica符号化创建`DaeBuilder`实例](#creating-a-daebuilder-instance-from-modelica-symbolically)
    *   [7.5. 从FMU构建`DaeBuilder`实例](#constructing-a-daebuilder-instance-from-an-fmu)
    *   [7.6. 使用`DaeBuilder`进行混合建模](#hybrid-modeling-with-daebuilder)
    *   [7.7. 模型重构](#reformulating-a-model)
    *   [7.8. 评估模型方程，函数工厂](#evaluating-model-equations-function-factory)
*   [8. 使用CasADi进行最优控制](#document-ocp)
    *   [8.1. 一个简单的测试问题](#a-simple-test-problem)
*   [9. Opti堆栈](#document-opti)
    *   [9.1. 问题规范](#problem-specification)
    *   [9.2. 问题求解与结果获取](#problem-solving-and-retrieving)
    *   [9.3. 额外功能](#extras)
*   [10. 不同语言使用差异](#document-usage)
    *   [10.1. 通用用法](#general-usage)
    *   [10.2. 操作列表](#list-of-operations)

## 1. 简介[¶](#introduction "Permalink to this heading")

CasADi是一个开源的数值优化软件工具，特别适用于最优控制(即涉及微分方程的优化问题)。该项目由Joel Andersson和Joris Gillis在KU Leuven的工程优化中心(OPTEC)攻读博士学位期间，在Moritz Diehl的指导下发起。

本文档旨在提供CasADi的简明介绍。阅读后，您应该能够：在CasADi的符号框架中构建和操作表达式；使用算法微分高效生成导数信息；为常微分方程(ODE)或微分代数方程(DAE)系统建立、求解并执行前向和伴随灵敏度分析；以及构建和求解非线性规划(NLP)问题与最优控制问题(OCP)。

CasADi支持C++、Python和MATLAB/Octave，性能差异很小。通常，Python API文档最完善，比MATLAB API更稳定。C++ API虽然稳定，但由于文档有限且缺乏MATLAB和Python等解释型语言的交互性，不太适合CasADi入门。MATLAB模块已在Octave(4.0.2或更高版本)上成功测试。

### 1.1. CasADi是什么与不是什么[¶](#what-casadi-is-and-what-it-is-not "Permalink to this heading")

CasADi最初是一个算法微分(AD)工具，其语法借鉴了计算机代数系统(CAS)，这也是其名称的由来。虽然AD仍是其核心功能之一，但该工具的范围已大大扩展，增加了对ODE/DAE积分和灵敏度分析、非线性编程以及与其他数值工具接口的支持。目前，它是一个基于梯度的通用数值优化工具——特别关注最优控制——而CasADi只是一个没有特殊含义的名称。

需要明确指出的是，CasADi不是传统的AD工具，不能直接用于从现有用户代码中计算导数信息而几乎无需修改。如果您有用C++、Python或MATLAB/Octave编写的现有模型，需要准备使用CasADi语法重新实现该模型。

其次，CasADi不是计算机代数系统。虽然其符号核心确实包含越来越多用于操作符号表达式的工具，但这些功能与专业的CAS工具相比非常有限。

最后，CasADi不是"最优控制问题求解器"，不能直接输入OCP就返回解。相反，它试图为用户提供一组"构建块"，可以用适度的编程工作高效实现通用或特定用途的OCP求解器。

### 1.2. 帮助与支持[¶](#help-and-support "Permalink to this heading")

如果您发现简单的错误或缺少某些您认为我们相对容易添加的功能，最简单的方法是在论坛[http://forum.casadi.org/](http://forum.casadi.org/)发帖。我们会定期查看论坛并尽快回复。对于此类支持，我们唯一期望的是当您在科学工作中使用CasADi时引用我们，参见[1.3节](#sec-citing)。

如果您需要更多帮助，我们始终开放学术或工业合作。学术合作通常采取共同发表同行评审论文的形式，工业合作则涉及协商咨询合同。如有兴趣，请直接联系我们。

### 1.3. 引用CasADi[¶](#citing-casadi "Permalink to this heading")

如果您在发表的科学工作中使用CasADi，请引用以下文献：

@Article{Andersson2018,
  Author = {Joel A E Andersson and Joris Gillis and Greg Horn
            and James B Rawlings and Moritz Diehl},
  Title = {{CasADi} -- {A} software framework for nonlinear optimization
           and optimal control},
  Journal = {Mathematical Programming Computation},
  Year = {2018},
}

### 1.4. 阅读本文档[¶](#reading-this-document "Permalink to this heading")

本文档的目标是让读者熟悉CasADi的语法，并提供易于使用的构建块来开发数值优化和动态优化软件。我们的解释主要以程序代码驱动，很少提供数学背景知识。我们假设读者已经具备优化理论、微分方程初值问题求解以及相关编程语言(C++、Python或MATLAB/Octave)的扎实基础。

本指南将并列展示Python和MATLAB/Octave语法，请注意Python接口更稳定且文档更完善。除非特别说明，MATLAB/Octave语法同样适用于Octave。我们会指出语法存在差异的情况。为方便在不同编程语言间切换，我们在[第10章](#sec-syntax-differences)列出了主要差异。

## 2. 获取与安装[¶](#obtaining-and-installing "Permalink to this heading")

CasADi是一个开源工具，采用LGPL许可协议，这是一个宽松的许可证，允许该工具在商业闭源应用中免版税使用。LGPL的主要限制是：如果您决定修改CasADi的源代码(而不仅仅是使用该工具)，这些修改(CasADi的"衍生作品")也必须以LGPL协议发布。

源代码托管在GitHub上，其核心是用自包含的C++代码编写的，仅依赖C++标准库。通过[SWIG](http://www.swig.org/)工具自动生成的Python和MATLAB/Octave前端功能完整，不太可能导致明显的效率损失。CasADi可在Linux、OS X和Windows上使用。

最新安装说明请访问CasADi的安装页面：[http://install.casadi.org/](http://install.casadi.org/)

## 3. 符号框架[¶](#symbolic-framework "Permalink to this heading")

CasADi的核心是一个自包含的符号框架，允许用户使用受MATLAB启发的"万物皆矩阵"语法构建符号表达式，即向量被视为n×1矩阵，标量被视为1×1矩阵。所有矩阵都是稀疏的，并使用通用稀疏格式——压缩列存储(CCS)来存储矩阵。下面我们将介绍该框架中最基础的类。

### 3.1. `SX`符号系统[¶](#the-sx-symbolics "Permalink to this heading")

`SX`数据类型用于表示由一系列一元和二元操作组成的符号表达式构成的矩阵。要了解其实际工作原理，可以启动一个交互式Python shell(例如在Linux终端输入`ipython`或在Spyder等集成开发环境中)或启动MATLAB/Octave的图形用户界面。假设CasADi已正确安装，您可以通过以下方式将符号导入工作区：

from casadi import \*

import casadi.\*

现在使用以下语法创建一个变量`x`：

x \= MX.sym("x")

x

x \= MX.sym('x')

x =

x

这将创建一个1×1矩阵，即包含名为`x`的符号基元的标量。这只是显示名称，不是标识符。多个变量可以有相同的名称，但仍然不同。返回值才是标识符。您还可以通过向`SX.sym`提供额外参数来创建向量或矩阵值符号变量：

y \= SX.sym('y',5)
Z \= SX.sym('Z',4,2)

\[y\_0, y\_1, y\_2, y\_3, y\_4\] 
\[\[Z\_0, Z\_4\], 
 \[Z\_1, Z\_5\], 
 \[Z\_2, Z\_6\], 
 \[Z\_3, Z\_7\]\]

y \= SX.sym('y',5)
Z \= SX.sym('Z',4,2)

y =

\[y\_0, y\_1, y\_2, y\_3, y\_4\]

Z =


\[\[Z\_0, Z\_4\], 
 \[Z\_1, Z\_5\], 
 \[Z\_2, Z\_6\], 
 \[Z\_3, Z\_7\]\]

这将分别创建一个5×1矩阵(即向量)和一个4×2的符号基元矩阵。

`SX.sym`是一个(静态)函数，返回一个`SX`实例。声明变量后，现在可以直观地形成表达式：

f \= x\*\*2 + 10
f \= sqrt(f)
print(f)

sqrt((10+sq(x)))

f \= x^2 + 10;
f \= sqrt(f);
display(f)

f =

sqrt((10+sq(x)))

您还可以创建不含任何符号基元的常量`SX`实例：

*   `B1 = SX.zeros(4,5)`: 全零的密集4×5空矩阵
    
*   `B2 = SX(4,5)`: 全零的稀疏4×5空矩阵
    
*   `B4 = SX.eye(4)`: 对角线为1，其余为结构零的稀疏4×4矩阵
    

B1: @1=0, 
\[\[@1, @1, @1, @1, @1\], 
 \[@1, @1, @1, @1, @1\], 
 \[@1, @1, @1, @1, @1\], 
 \[@1, @1, @1, @1, @1\]\]
B2: 
\[\[00, 00, 00, 00, 00\], 
 \[00, 00, 00, 00, 00\], 
 \[00, 00, 00, 00, 00\], 
 \[00, 00, 00, 00, 00\]\]
B4: @1=1, 
\[\[@1, 00, 00, 00\], 
 \[00, @1, 00, 00\], 
 \[00, 00, @1, 00\], 
 \[00, 00, 00, @1\]\]

注意稀疏矩阵中的_结构性零_和密集矩阵中的_实际零_之间的区别。当打印含有结构性零的表达式时，这些零会显示为`00`以区别于实际零`0`。

以下列表总结了创建新`SX`表达式最常用的方法：

*   `SX.sym(name,n,m)`: 创建一个n行m列的符号基元
    
*   `SX.zeros(n,m)`: 创建一个全零的n行m列密集矩阵
    
*   `SX(n,m)`: 创建一个全为_结构性零_的n行m列稀疏矩阵
    
*   `SX.ones(n,m)`: 创建一个全1的n行m列密集矩阵
    
*   `SX.eye(n)`: 创建一个n行n列的对角矩阵，对角线为1，其余为结构性零
    
*   `SX(scalar_type)`: 创建一个标量(1×1矩阵)，其值由参数给出。可以显式使用，如`SX(9)`，或隐式使用，如`9 * SX.ones(2,2)`
    
*   `SX(matrix_type)`: 根据给定的数值矩阵创建矩阵，可以是Python中的NumPy或SciPy矩阵，或MATLAB/Octave中的密集/稀疏矩阵。例如在MATLAB/Octave中，`SX([1,2,3,4])`创建行向量，`SX([1;2;3;4])`创建列向量，`SX([1,2;3,4])`创建2×2矩阵。可以显式或隐式使用
    
*   `repmat(v,n,m)`: 将表达式v垂直重复n次，水平重复m次。`repmat(SX(3),2,1)`将创建一个所有元素为3的2×1矩阵
    
*   (仅Python) `SX(list)`: 用列表中的元素创建一个列向量(n×1矩阵)，例如`SX([1,2,3,4])`(注意Python列表和MATLAB/Octave水平连接的区别，两者都使用方括号语法)
    
*   (仅Python) `SX(list of list)`: 用列表中的元素创建一个密集矩阵，例如`SX([[1,2],[3,4]])`，或使用`SX([[1,2,3,4]])`创建行向量(1×n矩阵)
    

#### 3.1.1. 关于命名空间的说明[¶](#note-on-namespaces "Permalink to this heading")

在MATLAB中，如果省略了`import casadi.*`命令，仍然可以通过在所有符号前加上包名来使用CasADi，例如使用`casadi.SX`而不是`SX`，前提是`casadi`包在路径中。出于排版原因，我们在后续内容中不会这样做，但请注意在用户代码中通常更推荐使用完整包名。在Python中，这相当于使用`import casadi`而不是`from casadi import *`。

遗憾的是，Octave(版本4.0.3)没有实现MATLAB的`import`命令。为了解决这个问题，我们提供了一个简单的`import.m`函数，可以将其放在Octave的路径中，从而启用本指南中使用的简洁语法。

#### 3.1.2. C++用户注意事项[¶](#note-for-c-users "Permalink to this heading")

在C++中，所有公共符号都定义在`casadi`命名空间中，并且需要包含`casadi/casadi.hpp`头文件。上述命令等价于：

#include <casadi/casadi.hpp>
using namespace casadi;
int main() {
  SX x \= SX::sym("x");
  SX y \= SX::sym("y",5);
  SX Z \= SX::sym("Z",4,2)
  SX f \= pow(x,2) + 10;
  f \= sqrt(f);
  std::cout << "f: " << f << std::endl;
  return 0;
}

### 3.2. `DM`[¶](#dm "Permalink to this heading")

`DM`与`SX`非常相似，不同之处在于其非零元素是数值而非符号表达式。语法也相同，只是没有`SX.sym`等函数的对应方法。

`DM`主要用于在CasADi中存储矩阵以及作为函数的输入和输出。它_不_适用于计算密集型任务。为此，应使用MATLAB内置的密集或稀疏数据类型、Python中的NumPy或SciPy矩阵，或C++中基于表达式模板的库如`eigen`、`ublas`或`MTL`。类型之间的转换通常很简单：

C \= DM(2,3)

C\_dense \= C.full()
from numpy import array
C\_dense \= array(C) \# equivalent

C\_sparse \= C.sparse()
from scipy.sparse import csc\_matrix
C\_sparse \= csc\_matrix(C) \# equivalent

C \= DM(2,3);
C\_dense \= full(C);
C\_sparse \= sparse(C);

更多关于`SX`的使用示例可以在示例包中找到，地址是 [http://install.casadi.org/](http://install.casadi.org/)。要查看该类(及其他类)特定函数的文档，请在 [http://docs.casadi.org/](http://docs.casadi.org/) 上找到"C++ API"并搜索关于`casadi::Matrix`的信息。

### 3.3. `MX`符号系统[¶](#the-mx-symbolics "Permalink to this heading")

让我们使用上面的`SX`来执行一个简单操作:

x \= SX.sym('x',2,2)
y \= SX.sym('y')
f \= 3\*x + y
print(f)
print(f.shape)

@1=3, 
\[\[((@1\*x\_0)+y), ((@1\*x\_2)+y)\], 
 \[((@1\*x\_1)+y), ((@1\*x\_3)+y)\]\]
(2, 2)

x \= SX.sym('x',2,2);
y \= SX.sym('y');
f \= 3\*x + y;
disp(f)
disp(size(f))

@1=3, 
\[\[((@1\*x\_0)+y), ((@1\*x\_2)+y)\], 
 \[((@1\*x\_1)+y), ((@1\*x\_3)+y)\]\]
   2   2

如你所见，这个操作的输出是一个2×2的矩阵。请注意乘法和加法是按元素执行的，并且为结果矩阵的每个条目都创建了新的表达式(类型为`SX`)。

现在我们将介绍第二种更通用的_矩阵表达式_类型`MX`。`MX`类型与`SX`类似，允许构建由一系列基本操作组成的表达式。但与`SX`不同的是，这些基本操作不仅限于标量一元或二元操作(R→RR→R\\mathbb{R} \\rightarrow \\mathbb{R} 或 R×R→RR×R→R\\mathbb{R} \\times \\mathbb{R} \\rightarrow \\mathbb{R})。相反，用于构成`MX`表达式的基本操作可以是通用的_多稀疏矩阵值_输入、_多稀疏矩阵值_输出函数：Rn1×m1×…×RnN×mN→Rp1×q1×…×RpM×qMRn1×m1×…×RnN×mN→Rp1×q1×…×RpM×qM\\mathbb{R}^{n\_1 \\times m\_1} \\times \\ldots \\times \\mathbb{R}^{n\_N \\times m\_N} \\rightarrow \\mathbb{R}^{p\_1 \\times q\_1} \\times \\ldots \\times \\mathbb{R}^{p\_M \\times q\_M}。

`MX`的语法与`SX`类似：

x \= MX.sym('x',2,2)
y \= MX.sym('y')
f \= 3\*x + y
print(f)
print(f.shape)

((3\*x)+y)
(2, 2)

x \= MX.sym('x',2,2);
y \= MX.sym('y');
f \= 3\*x + y;
disp(f)
disp(size(f))

((3\*x)+y)
   2   2

注意使用`MX`符号系统时结果只包含两个操作(一个乘法和一个加法)，而等效的`SX`实现则需要八个操作(结果矩阵中每个元素两个操作)。因此，在处理自然具有向量或矩阵值且元素较多的操作时，`MX`可以更加高效。正如我们将在[第4章](#sec-function)中看到的，`MX`也更加通用，因为它允许调用无法用基本操作展开的任意函数。

`MX`支持使用与`SX`相同的语法来获取和设置元素，但其实现方式却大不相同。例如，尝试打印一个2×2符号变量左上角的元素：

x \= MX.sym('x',2,2)
print(x\[0,0\])

x\[0\]

x \= MX.sym('x',2,2);
x(1,1)

ans =

x\[0\]

这里的输出应该被理解为一个表达式，它等于`x`的第一个(即C++中索引为0)结构非零元素，这与上面`SX`情况下的`x_0`不同，后者是矩阵第一个(索引0)位置的符号基元名称。

当尝试设置元素时，也可以预期类似的结果：

x \= MX.sym('x',2)
A \= MX(2,2)
A\[0,0\] \= x\[0\]
A\[1,1\] \= x\[0\]+x\[1\]
print('A:', A)

A: (project((zeros(2x2,1nz)\[0\] = x\[0\]))\[1\] = (x\[0\]+x\[1\]))

x \= MX.sym('x',2);
A \= MX(2,2);
A(1,1) \= x(1);
A(2,2) \= x(1)+x(2);
display(A)

A =

(project((zeros(2x2,1nz)\[0\] = x\[0\]))\[1\] = (x\[0\]+x\[1\]))

(虽然输出有些晦涩难懂)其含义是从一个全零稀疏矩阵开始，首先给`x_0`赋值，然后投影到具有不同稀疏模式的矩阵，再给`x_0+x_1`赋值。

您刚才看到的元素访问和赋值操作，是可用于构建表达式的操作示例。其他操作示例包括矩阵乘法、转置、连接、调整大小、重塑和函数调用等。

### 3.4. 混合使用`SX`和`MX`[¶](#mixing-sx-and-mx "Permalink to this heading")

您不能将`SX`对象与`MX`对象相乘，也不能执行任何其他操作将两者混合在同一个表达式图中。但是，您可以在`MX`图中包含由`SX`表达式定义的`Function`调用。这将在[第4章](#sec-function)中演示。混合使用`SX`和`MX`通常是个好主意，因为由`SX`表达式定义的函数每个操作的开销要低得多，对于自然写成一系列标量操作的情况会快得多。因此，`SX`表达式适用于低级操作(例如[4.4节](#sec-integrator)中的DAE右侧)，而`MX`表达式充当粘合剂，能够表述例如NLP的约束函数(可能包含对ODE/DAE积分器的调用，或者可能太大而无法展开为一个大的表达式)。

### 3.5. `Sparsity`类[¶](#the-sparsity-class "Permalink to this heading")

如前所述，CasADi中的矩阵使用压缩列存储(CCS)格式存储。这是稀疏矩阵的标准格式，可以高效执行逐元素操作、矩阵乘法和转置等线性代数运算。在CCS格式中，稀疏模式通过维度(行数和列数)和两个向量解码。第一个向量包含每列第一个结构非零元素的索引，第二个向量包含每个非零元素的行索引。有关CCS格式的更多细节，请参见Netlib上的[线性系统求解模板](http://netlib.org/linalg/html_templates/node92.html)。请注意，CasADi对稀疏矩阵和稠密矩阵都使用CCS格式。

CasADi中的稀疏模式存储为`Sparsity`类的实例，该类采用引用计数机制，意味着多个矩阵可以共享相同的稀疏模式，包括`MX`表达式图以及`SX`和`DM`的实例。`Sparsity`类还进行了缓存，意味着总是会避免创建相同稀疏模式的多个实例。

以下列表总结了构造新稀疏模式最常用的方法：

*   `Sparsity.dense(n,m)`: 创建稠密的n×m稀疏模式
    
*   `Sparsity(n,m)`: 创建稀疏的n×m稀疏模式
    
*   `Sparsity.diag(n)`: 创建对角的n×n稀疏模式
    
*   `Sparsity.upper(n)`: 创建上三角的n×n稀疏模式
    
*   `Sparsity.lower(n)`: 创建下三角的n×n稀疏模式

`Sparsity`类可用于创建非标准矩阵，例如

print(SX.sym('x',Sparsity.lower(3)))

\[\[x\_0, 00, 00\], 
 \[x\_1, x\_3, 00\], 
 \[x\_2, x\_4, x\_5\]\]

disp(SX.sym('x',Sparsity.lower(3)))

\[\[x\_0, 00, 00\], 
 \[x\_1, x\_3, 00\], 
 \[x\_2, x\_4, x\_5\]\]

#### 3.5.1. 矩阵元素的获取和设置[¶](#getting-and-setting-elements-in-matrices "Permalink to this heading")

要在CasADi的矩阵类型(`SX`、`MX`和`DM`)中获取或设置一个或多个元素，在Python中使用方括号，在C++和MATLAB中使用圆括号。按照这些语言的惯例，索引在C++和Python中从0开始，而在MATLAB中从1开始。在Python和C++中，允许使用负索引表示从末尾开始计数。在MATLAB中，使用`end`关键字来实现从末尾索引。

索引可以使用一个或两个索引完成。使用两个索引时，可以引用特定的行(或多行)和特定的列(或多列)。使用一个索引时，从矩阵左上角开始按列优先顺序引用元素(或多个元素)直到右下角。所有元素都会被计数，无论它们是否是结构零。

M \= SX(\[\[3,7\],\[4,5\]\])
print(M\[0,:\])
M\[0,:\] \= 1
print(M)

\[\[3, 7\]\]
@1=1, 
\[\[@1, @1\], 
 \[4, 5\]\]

M \= SX(\[3,7;4,5\]);
disp(M(1,:))
M(1,:) \= 1;
disp(M)

\[\[3, 7\]\]
@1=1, 
\[\[@1, @1\], 
 \[4, 5\]\]

与Python的NumPy不同，CasADi的切片操作不是对左侧数据的视图引用，而是会复制数据。因此，在下面的例子中矩阵mmm完全不会被改变：

M \= SX(\[\[3,7\],\[4,5\]\])
M\[0,:\]\[0,0\] \= 1
print(M)

\[\[3, 7\], 
 \[4, 5\]\]

获取和设置矩阵元素的操作将在下文详细说明。这些讨论适用于CasADi的所有矩阵类型。

**单个元素访问** 是指通过提供行列对或其扁平化索引(从矩阵左上角开始按列优先顺序)来获取或设置元素：

M \= diag(SX(\[3,4,5,6\]))
print(M)

\[\[3, 00, 00, 00\], 
 \[00, 4, 00, 00\], 
 \[00, 00, 5, 00\], 
 \[00, 00, 00, 6\]\]

M \= diag(SX(\[3,4,5,6\]));
disp(M)

\[\[3, 00, 00, 00\], 
 \[00, 4, 00, 00\], 
 \[00, 00, 5, 00\], 
 \[00, 00, 00, 6\]\]

print(M\[0,0\])
print(M\[1,0\])
print(M\[\-1,\-1\])

3
00
6

disp(M(1,1))
disp(M(2,1))
disp(M(end,end))

3
00
6

**切片访问**意味着一次性设置多个元素。这种方式比逐个设置元素要高效得多。通过提供(_起始_, _结束_, _步长_)三元组来获取或设置切片。在Python和MATLAB中，CasADi使用标准语法：

print(M\[:,1\])
print(M\[1:,1:4:2\])

\[00, 4, 00, 00\]

\[\[4, 00\], 
 \[00, 00\], 
 \[00, 6\]\]

disp(M(:,2))
disp(M(2:end,2:2:4))

\[00, 4, 00, 00\]

\[\[4, 00\], 
 \[00, 00\], 
 \[00, 6\]\]

在C++中，可以使用CasADi的`Slice`辅助类。对于上面的例子，这意味着使用`M(Slice(),1)`和`M(Slice(1,-1),Slice(1,4,2))`。

**列表访问**与切片访问类似（但可能效率较低）：

M \= SX(\[\[3,7,8,9\],\[4,5,6,1\]\])
print(M)
print(M\[0,\[0,3\]\], M\[\[5,\-6\]\])

\[\[3, 7, 8, 9\], 
 \[4, 5, 6, 1\]\]
\[\[3, 9\]\] \[6, 7\]

M \= SX(\[3 7 8 9; 4 5 6 1\]);
disp(M)
disp(M(1,\[1,4\]))
disp(M(\[6,numel(M)\-5\]))

\[\[3, 7, 8, 9\], 
 \[4, 5, 6, 1\]\]
\[\[3, 9\]\]
\[\[6, 7\]\]

### 3.6. 算术运算[¶](#arithmetic-operations "固定链接到此标题")

CasADi支持大多数标准算术运算，如加法、乘法、幂运算、三角函数等：

x \= SX.sym('x')
y \= SX.sym('y',2,2)
print(sin(y)\-x)

\[\[(sin(y\_0)-x), (sin(y\_2)-x)\], 
 \[(sin(y\_1)-x), (sin(y\_3)-x)\]\]

x \= SX.sym('x');
y \= SX.sym('y',2,2);
disp(sin(y)\-x)

\[\[(sin(y\_0)-x), (sin(y\_2)-x)\], 
 \[(sin(y\_1)-x), (sin(y\_3)-x)\]\]

在C++和Python中(但不包括MATLAB)，标准乘法运算(使用`*`)保留用于逐元素乘法(在MATLAB中是`.*`)。要进行**矩阵乘法**，请使用`A @ B`或(Python 3.4+中的`mtimes(A,B)`):

print(y\*y, y@y)

\[\[sq(y\_0), sq(y\_2)\], 
 \[sq(y\_1), sq(y\_3)\]\] 
\[\[(sq(y\_0)+(y\_2\*y\_1)), ((y\_0\*y\_2)+(y\_2\*y\_3))\], 
 \[((y\_1\*y\_0)+(y\_3\*y\_1)), ((y\_1\*y\_2)+sq(y\_3))\]\]

disp(y.\*y)
disp(y\*y)

\[\[sq(y\_0), sq(y\_2)\], 
 \[sq(y\_1), sq(y\_3)\]\]

\[\[(sq(y\_0)+(y\_2\*y\_1)), ((y\_0\*y\_2)+(y\_2\*y\_3))\], 
 \[((y\_1\*y\_0)+(y\_3\*y\_1)), ((y\_1\*y\_2)+sq(y\_3))\]\]

按照MATLAB的惯例，当任一参数是标量时，使用`*`和`.*`进行乘法运算是等价的。

**转置操作**在不同语言中的语法如下：
- Python中使用`A.T`
- C++中使用`A.T()`
- MATLAB中使用`A'`或`A.'`

print(y)
print(y.T)

\[\[y\_0, y\_2\], 
 \[y\_1, y\_3\]\]

\[\[y\_0, y\_1\], 
 \[y\_2, y\_3\]\]

disp(y)
disp(y')

\[\[y\_0, y\_2\], 
 \[y\_1, y\_3\]\]

\[\[y\_0, y\_1\], 
 \[y\_2, y\_3\]\]

**重塑(Reshaping)** 指的是改变矩阵的行数和列数，但保持元素数量和非零元素的相对位置不变。这是一个计算成本非常低的操作，可以使用以下语法执行：

x \= SX.eye(4)
print(reshape(x,2,8))

@1=1, 
\[\[@1, 00, 00, 00, 00, @1, 00, 00\], 
 \[00, 00, @1, 00, 00, 00, 00, @1\]\]

x \= SX.eye(4);
reshape(x,2,8)

ans =

@1=1, 
\[\[@1, 00, 00, 00, 00, @1, 00, 00\], 
 \[00, 00, @1, 00, 00, 00, 00, @1\]\]

**矩阵拼接(Concatenation)** 指的是将矩阵水平或垂直堆叠。由于CasADi采用列优先方式存储元素，水平堆叠矩阵效率最高。对于实际上是列向量(即只有单列)的矩阵，垂直堆叠也能高效完成。在不同语言中实现垂直和水平拼接的方式如下：
- Python和C++中使用`vertcat`和`horzcat`函数(可接受可变数量参数)
- MATLAB中使用方括号语法

x \= SX.sym('x',5)
y \= SX.sym('y',5)
print(vertcat(x,y))

\[x\_0, x\_1, x\_2, x\_3, x\_4, y\_0, y\_1, y\_2, y\_3, y\_4\]

x \= SX.sym('x',5);
y \= SX.sym('y',5);
disp(\[x;y\])

\[x\_0, x\_1, x\_2, x\_3, x\_4, y\_0, y\_1, y\_2, y\_3, y\_4\]

print(horzcat(x,y))

\[\[x\_0, y\_0\], 
 \[x\_1, y\_1\], 
 \[x\_2, y\_2\], 
 \[x\_3, y\_3\], 
 \[x\_4, y\_4\]\]

disp(\[x,y\])

\[\[x\_0, y\_0\], 
 \[x\_1, y\_1\], 
 \[x\_2, y\_2\], 
 \[x\_3, y\_3\], 
 \[x\_4, y\_4\]\]

这些函数还有接受列表(Python中)或元胞数组(Matlab中)作为输入的变体:

L \= \[x,y\]
print(hcat(L))

\[\[x\_0, y\_0\], 
 \[x\_1, y\_1\], 
 \[x\_2, y\_2\], 
 \[x\_3, y\_3\], 
 \[x\_4, y\_4\]\]

L \= {x,y};
disp(\[L{:}\])

\[\[x\_0, y\_0\], 
 \[x\_1, y\_1\], 
 \[x\_2, y\_2\], 
 \[x\_3, y\_3\], 
 \[x\_4, y\_4\]\]

**水平分割和垂直分割**是上述水平连接和垂直连接的逆操作。要将一个表达式水平分割成n个较小的表达式，除了要分割的表达式外，还需要提供一个长度为n+1的_offset_向量。_offset_向量的第一个元素必须为0，最后一个元素必须等于列数。其余元素必须按非递减顺序排列。分割操作的输出iii将包含满足offset[i]≤c<offset[i+1]的列ccc。以下演示了语法:

x \= SX.sym('x',5,2)
w \= horzsplit(x,\[0,1,2\])
print(w\[0\], w\[1\])

\[x\_0, x\_1, x\_2, x\_3, x\_4\] \[x\_5, x\_6, x\_7, x\_8, x\_9\]

x \= SX.sym('x',5,2);
w \= horzsplit(x,\[0,1,2\]);
disp(w{1}), disp(w{2})

\[x\_0, x\_1, x\_2, x\_3, x\_4\]
\[x\_5, x\_6, x\_7, x\_8, x\_9\]

vertsplit操作的工作原理类似，但_offset_向量指向的是行：

w \= vertsplit(x,\[0,3,5\])
print(w\[0\], w\[1\])

\[\[x\_0, x\_5\], 
 \[x\_1, x\_6\], 
 \[x\_2, x\_7\]\] 
\[\[x\_3, x\_8\], 
 \[x\_4, x\_9\]\]

w \= vertsplit(x,\[0,3,5\]);
disp(w{1}), disp(w{2})

\[\[x\_0, x\_5\], 
 \[x\_1, x\_6\], 
 \[x\_2, x\_7\]\]

\[\[x\_3, x\_8\], 
 \[x\_4, x\_9\]\]

需要注意的是，对于上述垂直分割操作，我们总是可以使用切片元素访问来代替水平和垂直分割：

w \= \[x\[0:3,:\], x\[3:5,:\]\]
print(w\[0\], w\[1\])

\[\[x\_0, x\_5\], 
 \[x\_1, x\_6\], 
 \[x\_2, x\_7\]\] 
\[\[x\_3, x\_8\], 
 \[x\_4, x\_9\]\]

w \= {x(1:3,:), x(4:5,:)};
disp(w{1}), disp(w{2})

\[\[x\_0, x\_5\], 
 \[x\_1, x\_6\], 
 \[x\_2, x\_7\]\]

\[\[x\_3, x\_8\], 
 \[x\_4, x\_9\]\]

对于`SX`图而言，这种替代方法是完全等效的，但对于`MX`图来说，当需要所有分割表达式时，使用`horzsplit`/`vertsplit`会_显著更高效_。

**内积**，定义为 <A,B\>:\=tr(AB)\=∑i,jAi,jBi,j<A,B\>:=tr(AB)\=∑i,jAi,jBi,j<A,B> := \\text{tr}(A \\, B) = \\sum\_{i,j} \\, A\_{i,j} \\, B\_{i,j} 的创建方式如下：

x \= SX.sym('x',2,2)
print(dot(x,x))

(((sq(x\_0)+sq(x\_1))+sq(x\_2))+sq(x\_3))

x \= SX.sym('x',2,2);
disp(dot(x,x))

(((sq(x\_0)+sq(x\_1))+sq(x\_2))+sq(x\_3))

上述许多操作同样适用于 `Sparsity` 类([第3.5节](#sec-sparsity-class))，例如 `vertcat`(垂直拼接)、`horzsplit`(水平分割)、转置、加法(返回两个稀疏模式的_并集_)以及乘法(返回两个稀疏模式的_交集_)。

### 3.7. 属性查询[¶](#querying-properties "Permalink to this heading")

您可以通过调用相应的成员函数来检查矩阵或稀疏模式是否具有特定属性。例如：

y \= SX.sym('y',10,1)
print(y.shape)

(10, 1)

y \= SX.sym('y',10,1);
size(y)

ans =

   10    1

需要注意的是，在MATLAB中，`obj.myfcn(arg)`和`myfcn(obj, arg)`都是调用成员函数`myfcn`的有效方式。从代码风格角度来看，后者可能更可取。

矩阵`A`的一些常用属性包括：

> *   `A.size1()` 行数
>     
> *   `A.size2()` 列数
>     
> *   `A.shape` (在MATLAB中为"size") 形状，即(_nrow_,\*ncol\*)对
>     
> *   `A.numel()` 元素数量，即nrow∗ncolnrow∗ncol\\textit{nrow} \* \\textit{ncol}
>     
> *   `A.nnz()` 结构非零元素数量，如果矩阵是_dense_的则等于`A.numel()`
>     
> *   `A.sparsity()` 获取稀疏模式的引用
>     
> *   `A.is_dense()` 矩阵是否是dense的，即没有结构零
>     
> *   `A.is_scalar()` 矩阵是否是标量，即1×1维
>     
> *   `A.is_column()` 矩阵是否是向量，即n×1维
>     
> *   `A.is_square()` 矩阵是否是方阵
>     
> *   `A.is_triu()` 矩阵是否是上三角
>     
> *   `A.is_constant()` 矩阵元素是否都是常量
>     
> *   `A.is_integer()` 矩阵元素是否都是整数值
>     

最后的几个查询是允许_假阴性_返回的示例。对于`A.is_constant()`返回_true_的矩阵可以保证是常量，但如果返回_false_则不能保证一定是非常量。我们建议您在首次使用特定函数前查阅API文档。

### 3.8. 线性代数[¶](#linear-algebra "Permalink to this heading")

CasADi支持有限数量的线性代数运算，例如用于求解线性方程组：

A \= MX.sym('A',3,3)
b \= MX.sym('b',3)
print(solve(A,b))

(A\\b)

A \= MX.sym('A',3,3);
b \= MX.sym('b',3);
disp(A\\b)

(A\\b)

### 3.9. 微积分 - 算法微分[¶](#calculus-algorithmic-differentiation "Permalink to this heading")

CasADi最核心的功能是_算法微分_(AD)。对于一个函数 f:RN→RMf:RN→RMf: \\mathbb{R}^N \\rightarrow \\mathbb{R}^M:

y\=f(x),y\=f(x),y = f(x),

_前向模式_方向导数可用于计算雅可比矩阵与向量的乘积:

^y\=∂f∂x^x.y^\=∂f∂xx^.\\hat{y} = \\frac{\\partial f}{\\partial x} \\, \\hat{x}.

类似地,_反向模式_方向导数可用于计算雅可比矩阵转置与向量的乘积:

¯x\=(∂f∂x)T¯y.x¯\=(∂f∂x)Ty¯.\\bar{x} = \\left(\\frac{\\partial f}{\\partial x}\\right)^{\\text{T}} \\, \\bar{y}.

无论x的维度如何,前向和反向模式方向导数的计算成本都与计算f(x)f(x)f(x)成正比。

CasADi还能高效地生成完整的_稀疏_雅可比矩阵。该算法非常复杂,但主要包括以下步骤:

*   自动检测雅可比矩阵的稀疏模式
    
*   使用图着色技术找到构建完整雅可比矩阵所需的少量前向和/或方向导数
    
*   数值或符号计算方向导数
    
*   组装完整的雅可比矩阵
    
    
Hessian矩阵的计算方法是先计算梯度,然后利用对称性,按照上述相同步骤计算梯度的雅可比矩阵。

#### 3.9.1. 语法[¶](#syntax "Permalink to this heading")

获取雅可比矩阵表达式的语法如下：

A \= SX.sym('A',3,2)
x \= SX.sym('x',2)
print(jacobian(A@x,x))

\[\[A\_0, A\_3\], 
 \[A\_1, A\_4\], 
 \[A\_2, A\_5\]\]

A \= SX.sym('A',3,2);
x \= SX.sym('x',2);
jacobian(A\*x,x)

ans =


\[\[A\_0, A\_3\], 
 \[A\_1, A\_4\], 
 \[A\_2, A\_5\]\]

当被微分的表达式是标量时，你也可以以矩阵形式计算梯度：

print(gradient(dot(A,A),A))

\[\[(A\_0+A\_0), (A\_3+A\_3)\], 
 \[(A\_1+A\_1), (A\_4+A\_4)\], 
 \[(A\_2+A\_2), (A\_5+A\_5)\]\]

gradient(dot(A,A),A)

ans =


\[\[(A\_0+A\_0), (A\_3+A\_3)\], 
 \[(A\_1+A\_1), (A\_4+A\_4)\], 
 \[(A\_2+A\_2), (A\_5+A\_5)\]\]

需要注意的是，与 `jacobian` 不同，`gradient` 总是返回一个稠密向量。

Hessian矩阵(以及作为副产物的梯度)可以通过以下方式获得：

\[H,g\] \= hessian(dot(x,x),x)
print('H:', H)

H: @1=2, 
\[\[@1, 00\], 
 \[00, @1\]\]

\[H,g\] \= hessian(dot(x,x),x);
display(H)

H =

@1=2, 
\[\[@1, 00\], 
 \[00, @1\]\]

要计算雅可比矩阵与向量的乘积，使用`jtimes`函数（执行前向模式自动微分）通常比创建完整的雅可比矩阵再进行矩阵-向量乘法更高效：

A \= DM(\[\[1,3\],\[4,7\],\[2,8\]\])
x \= SX.sym('x',2)
v \= SX.sym('v',2)
f \= mtimes(A,x)
print(jtimes(f,x,v))

\[(v\_0+(3\*v\_1)), ((4\*v\_0)+(7\*v\_1)), ((2\*v\_0)+(8\*v\_1))\]

A \= \[1 3;4 7;2 8\];
x \= SX.sym('x',2);
v \= SX.sym('v',2);
f \= A\*x;
jtimes(f,x,v)

ans =

\[(v\_0+(3\*v\_1)), ((4\*v\_0)+(7\*v\_1)), ((2\*v\_0)+(8\*v\_1))\]

`jtimes` 函数可以选择性地计算转置雅可比矩阵与向量的乘积，即反向模式自动微分(reverse mode AD):

w \= SX.sym('w',3)
f \= mtimes(A,x)
print(jtimes(f,x,w,True))

\[(((2\*w\_2)+(4\*w\_1))+w\_0), (((8\*w\_2)+(7\*w\_1))+(3\*w\_0))\]

w \= SX.sym('w',3);
f \= A\*x;
jtimes(f,x,w,true)

ans =

\[(((2\*w\_2)+(4\*w\_1))+w\_0), (((8\*w\_2)+(7\*w\_1))+(3\*w\_0))\]

## 4\. 函数对象[¶](#function-objects "Permalink to this heading")

CasADi 允许用户创建函数对象，在 C++ 术语中通常称为 _functors_。这包括由符号表达式定义的函数、ODE/DAE 积分器、QP 求解器、NLP 求解器等。

函数对象通常使用以下语法创建：

f = functionname(name, arguments, ..., \[options\])

其中 name 主要是一个显示名称，会出现在错误消息或生成的 C 代码注释中。后面跟着一组参数，这些参数取决于具体类。最后，用户可以传递一个 options 结构来自定义类的行为。在 Python 中 options 是字典类型，在 MATLAB 中是 struct 类型，在 C++ 中是 CasADi 的 `Dict` 类型。

可以通过传递输入表达式列表和输出表达式列表来构造 `Function`：

x \= SX.sym('x',2)
y \= SX.sym('y')
f \= Function('f',\[x,y\],\\
           \[x,sin(y)\*x\])
print(f)

f:(i0\[2\],i1)->(o0\[2\],o1\[2\]) SXFunction

x \= SX.sym('x',2);
y \= SX.sym('y');
f \= Function('f',{x,y},...
           {x,sin(y)\*x});
disp(f)

f:(i0\[2\],i1)->(o0\[2\],o1\[2\]) SXFunction

这里定义了一个函数 f:R2×R→R2×R2,(x,y)↦(x,sin(y)x)f:R2×R→R2×R2,(x,y)↦(x,sin⁡(y)x)f : \\mathbb{R}^{2} \\times \\mathbb{R} \\rightarrow \\mathbb{R}^{2} \\times \\mathbb{R}^{2}, \\quad (x,y) \\mapsto (x,\\sin(y) x)。需要注意的是，CasADi中的所有函数对象（包括上述示例）都支持多矩阵值输入和多矩阵值输出。

`MX` 表达式图的工作方式相同：

x \= MX.sym('x',2)
y \= MX.sym('y')
f \= Function('f',\[x,y\],\\
           \[x,sin(y)\*x\])
print(f)

f:(i0\[2\],i1)->(o0\[2\],o1\[2\]) MXFunction

x \= MX.sym('x',2);
y \= MX.sym('y');
f \= Function('f',{x,y},...
           {x,sin(y)\*x});
disp(f)

f:(i0\[2\],i1)->(o0\[2\],o1\[2\]) MXFunction

当从表达式创建 `Function` 时，建议始终按如下方式为输入和输出_命名_：

f \= Function('f',\[x,y\],\\
      \[x,sin(y)\*x\],\\
      \['x','y'\],\['r','q'\])
print(f)

f:(x\[2\],y)->(r\[2\],q\[2\]) MXFunction

f \= Function('f',{x,y},...
      {x,sin(y)\*x},...
      {'x','y'},{'r','q'});
disp(f)

f:(x\[2\],y)->(r\[2\],q\[2\]) MXFunction

为输入和输出命名是推荐的做法，原因如下：

*   无需记住参数的数量或顺序
    
*   可以省略未使用的输入或输出
    
*   语法更易读且更不容易出错

对于那些不是直接从表达式创建的`Function`实例（后面会遇到），输入和输出会被自动命名。

### 4.1. 调用函数对象[¶](#calling-function-objects "Permalink to this heading")

`MX`表达式可以包含对`Function`派生函数的调用。调用函数对象既可以用于数值计算，也可以通过传递符号参数将函数对象的调用嵌入到表达式图中（另见[第4.4节](#sec-integrator)）。

要调用函数对象，可以按正确顺序传递参数：

r0, q0 \= f(1.1,3.3)
print('r0:',r0)
print('q0:',q0)

r0: \[1.1, 1.1\]
q0: \[-0.17352, -0.17352\]

\[r0, q0\] \= f(1.1,3.3);
disp(r0)
disp(q0)

\[1.1, 1.1\]
\[-0.17352, -0.17352\]

或者可以按以下方式传递参数及其名称，这将生成一个字典（Python中是`dict`，MATLAB中是`struct`，C++中是`std::map<std::string, MatrixType>`）：

res \= f(x\=1.1, y\=3.3)
print('res:', res)

res: {'q': DM(\[-0.17352, -0.17352\]), 'r': DM(\[1.1, 1.1\])}

res \= f('x',1.1,'y',3.3);
disp(res)

  scalar structure containing the fields:

    q =

      casadi.DM object with properties:


    r =

      casadi.DM object with properties:

调用函数对象时，评估参数的维度(但不一定是稀疏模式)必须与函数输入匹配，但有两点例外：

*   可以传递行向量代替列向量，反之亦然
    
*   无论输入维度如何，总是可以传递标量参数。这表示将输入矩阵的所有元素设置为该值

当函数对象的输入数量较多或变化时，可以使用_call_函数作为替代语法，它接受Python列表/MATLAB单元数组，或者Python字典/MATLAB结构体。返回值将具有相同类型：

arg \= \[1.1,3.3\]
res \= f.call(arg)
print('res:', res)
arg \= {'x':1.1,'y':3.3}
res \= f.call(arg)
print('res:', res)

res: \[DM(\[1.1, 1.1\]), DM(\[-0.17352, -0.17352\])\]
res: {'q': DM(\[-0.17352, -0.17352\]), 'r': DM(\[1.1, 1.1\])}

arg \= {1.1,3.3};
res \= f.call(arg);
disp(res)
arg \= struct('x',1.1,'y',3.3);
res \= f.call(arg);
disp(res)

{
  \[1,1\] =

    casadi.DM object with properties:


  \[1,2\] =

    casadi.DM object with properties:


}
  scalar structure containing the fields:

    q =

      casadi.DM object with properties:


    r =

      casadi.DM object with properties:

### 4.2. 将 `MX` 转换为 `SX`[¶](#converting-mx-to-sx "Permalink to this heading")

一个由 `MX` 图定义的函数对象，如果仅包含内置操作（例如加法、平方根等元素级运算，矩阵乘法以及调用 `SX` 函数），可以通过以下语法转换为纯 `SX` 图定义的函数：

sx\_function \= mx\_function.expand()

这可能会显著加快计算速度，但也可能导致额外的内存开销。

### 4.3. 非线性求根问题[¶](#nonlinear-root-finding-problems "Permalink to this heading")

考虑以下方程组：

g0(z,x1,x2,…,xn)\=0g1(z,x1,x2,…,xn)\=y1g2(z,x1,x2,…,xn)\=y2⋮gm(z,x1,x2,…,xn)\=ym,g0(z,x1,x2,…,xn)\=0g1(z,x1,x2,…,xn)\=y1g2(z,x1,x2,…,xn)\=y2⋮gm(z,x1,x2,…,xn)\=ym,\\begin{split}\\begin{aligned} &g\_0(z, x\_1, x\_2, \\ldots, x\_n) &&= 0 \\\\ &g\_1(z, x\_1, x\_2, \\ldots, x\_n) &&= y\_1 \\\\ &g\_2(z, x\_1, x\_2, \\ldots, x\_n) &&= y\_2 \\\\ &\\qquad \\vdots \\qquad &&\\qquad \\\\ &g\_m(z, x\_1, x\_2, \\ldots, x\_n) &&= y\_m, \\end{aligned}\\end{split}

其中第一个方程通过隐函数定理唯一地定义了 z 作为 x1, ..., xn 的函数，其余方程定义了辅助输出 y1, ..., ym。

给定一个用于计算 g0, ..., gm 的函数 g，我们可以使用 CasADi 自动构造一个函数 G:{zguess,x1,x2,…,xn}→{z,y1,y2,…,ym}G:{zguess,x1,x2,…,xn}→{z,y1,y2,…,ym}G: \\{z\_{\\text{guess}}, x\_1, x\_2, \\ldots, x\_n\\} \\rightarrow \\{z, y\_1, y\_2, \\ldots, y\_m\\}。该函数包含对 z 的初始猜测以处理解不唯一的情况。假设 n=m=1 时的语法如下：

z \= SX.sym('x',nz)
x \= SX.sym('x',nx)
g0 \= sin(x+z)
g1 \= cos(x\-z)
g \= Function('g',\[z,x\],\[g0,g1\])
G \= rootfinder('G','newton',g)
print(G)

G:(i00,i1)->(i0,o1) Newton

z \= SX.sym('x',nz);
x \= SX.sym('x',nx);
g0 \= sin(x+z);
g1 \= cos(x\-z);
g \= Function('g',{z,x},{g0,g1});
G \= rootfinder('G','newton',g);
disp(G)

G:(i00,i1)->(i0,o1) Newton

其中`rootfinder`函数需要一个显示名称、求解器插件名称(这里是一个简单的全步长牛顿法)和残差函数。

CasADi中的求根对象是微分对象，可以精确计算任意阶导数。

另请参阅

[求根器API](http://casadi.org/python-api/#rootfinding)

### 4.4. 初值问题与灵敏度分析[¶](#initial-value-problems-and-sensitivity-analysis "Permalink to this heading")

CasADi可用于求解ODE或DAE的初值问题。使用的问题表述是具有正交条件的半显式DAE形式：

˙x\=fode(t,x,z,p,u),x(0)\=x00\=falg(t,x,z,p,u)˙q\=fquad(t,x,z,p,u),q(0)\=0x˙\=fode(t,x,z,p,u),x(0)\=x00\=falg(t,x,z,p,u)q˙\=fquad(t,x,z,p,u),q(0)\=0\\begin{split}\\begin{aligned} \\dot{x} &= f\_{\\text{ode}}(t,x,z,p,u), \\qquad x(0) = x\_0 \\\\ 0 &= f\_{\\text{alg}}(t,x,z,p,u) \\\\ \\dot{q} &= f\_{\\text{quad}}(t,x,z,p,u), \\qquad q(0) = 0 \\end{aligned}\\end{split}

对于_常_微分方程求解器，第二个方程和代数变量zzz必须不存在。

CasADi中的积分器是一个函数，它接收初始时间`x0`的状态、一组参数`p`和控制`u`，以及代数变量的初始猜测(仅对DAEs)`z0`，并返回在多个输出时间点的状态向量`xf`、代数变量`zf`和正交状态`qf`。控制向量`u`被假定为分段常数，并且与输出网格具有相同的离散化。

免费提供的[SUNDIALS套件](https://computation.llnl.gov/casc/sundials/description/description.html)(随CasADi一起分发)包含两个流行的积分器CVodes和IDAS，分别用于ODE和DAE。这些积分器支持前向和伴随灵敏度分析，当通过CasADi的Sundials接口使用时，CasADi会自动生成CVodes和IDAS使用的后向差分公式(BDF)所需的雅可比信息。前向和伴随灵敏度方程也将自动生成。

#### 4.4.1. 创建积分器[¶](#creating-integrators "Permalink to this heading")

积分器是使用 CasADi 的 `integrator` 函数创建的。不同的积分器方案和接口以_插件_的形式实现，本质上是运行时加载的共享库。

例如考虑以下 DAE 方程：

˙x\=z+p,0\=zcos(z)−xx˙\=z+p,0\=zcos⁡(z)−x\\begin{split}\\begin{aligned} \\dot{x} &= z+p, \\\\ 0 &= z \\, \\cos(z)-x \\end{aligned}\\end{split}

使用 "idas" 插件创建积分器的语法如下：

x \= SX.sym('x'); z \= SX.sym('z'); p \= SX.sym('p')
dae \= {'x':x, 'z':z, 'p':p, 'ode':z+p, 'alg':z\*cos(z)\-x}
F \= integrator('F', 'idas', dae)
print(F)

F:(x0,z0,p,u\[0\],adj\_xf\[\],adj\_zf\[\],adj\_qf\[\])->(xf,zf,qf\[0\],adj\_x0\[\],adj\_z0\[\],adj\_p\[\],adj\_u\[\]) IdasInterface

x \= SX.sym('x'); z \= SX.sym('z'); p \= SX.sym('p');
dae \= struct('x',x,'z',z,'p',p,'ode',z+p,'alg',z\*cos(z)\-x);
F \= integrator('F', 'idas', dae);
disp(F)

F:(x0,z0,p,u\[0\],adj\_xf\[\],adj\_zf\[\],adj\_qf\[\])->(xf,zf,qf\[0\],adj\_x0\[\],adj\_z0\[\],adj\_p\[\],adj\_u\[\]) IdasInterface

这将产生从 t0\=0t0\=0t\_0=0 到 tf\=1tf\=1t\_f=1 的积分结果，即单个输出时间。我们可以使用初始条件 x(0)\=0x(0)\=0x(0)=0、参数 p\=0.1p\=0.1p=0.1 和初始时刻代数变量的猜测值 z(0)\=0z(0)\=0z(0)=0 来评估这个函数对象：

r \= F(x0\=0, z0\=0, p\=0.1)
print(r\['xf'\])

0.1724

r \= F('x0',0,'z0',0,'p',0.1);
disp(r.xf)

0.1724

注意时间范围总是固定的。可以通过在 DAE 之后向构造函数添加两个额外参数来更改其默认值 t0\=0t0\=0t\_0=0 和 tf\=1tf\=1t\_f=1。tftft\_f 可以是单个值或值向量，也可以包含初始时间。

#### 4.4.2. 灵敏度分析[¶](#sensitivity-analysis "Permalink to this heading")

从使用角度来看，积分器的行为与本章前面从表达式创建的函数对象非常相似。您可以使用Function类中的成员函数来生成对应于方向导数（前向或反向模式）或完整雅可比矩阵的新函数对象。然后对这些函数对象进行数值评估以获得灵敏度信息。文档中的示例"sensitivity_analysis"（在CasADi的Python、MATLAB和C++示例集合中提供）展示了如何使用CasADi计算简单DAE的一阶和二阶导数信息（前向-前向、前向-伴随、伴随-伴随）。

### 4.5. 非线性规划[¶](#nonlinear-programming "Permalink to this heading")

注意

本节假设您熟悉前面的大部分内容。在[第9章](#sec-opti)中还有一个更高级的接口，该接口可以独立学习。

CasADi分发或接口的NLP求解器可解决以下形式的参数化NLP问题：

(4.5.1)[¶](#equation-nlp "Permalink to this equation")minimize:xf(x,p)subject to:xlb≤x≤xubglb≤g(x,p)≤gubminimize:xf(x,p)subject to:xlb≤x≤xubglb≤g(x,p)≤gub\\begin{split}\\begin{array}{cc} \\begin{array}{c} \\text{minimize:} \\\\ x \\end{array} & f(x,p) \\\\ \\begin{array}{c} \\text{subject to:} \\end{array} & \\begin{array}{rcl} x\_{\\textrm{lb}} \\le & x & \\le x\_{\\textrm{ub}} \\\\ g\_{\\textrm{lb}} \\le &g(x,p)& \\le g\_{\\textrm{ub}} \\end{array} \\end{array}\\end{split}

其中x∈Rnxx∈Rnxx \\in \\mathbb{R}^{nx}是决策变量，p∈Rnpp∈Rnpp \\in \\mathbb{R}^{np}是已知参数向量。

CasADi中的NLP求解器是一个函数，它接收参数值(`p`)、边界(`lbx`, `ubx`, `lbg`, `ubg`)和对原始-对偶解的初始猜测(`x0`, `lam_x0`, `lam_g0`)，并返回最优解。与积分器对象不同，NLP求解器函数目前在CasADi中不是可微函数。

CasADi接口了多个NLP求解器。最流行的是IPOPT，这是一个开源的原始-对偶内点法，包含在CasADi安装中。其他需要安装第三方软件的求解器包括SNOPT、WORHP和KNITRO。无论使用哪种NLP求解器，接口都会自动生成求解NLP所需的信息，这可能因求解器和选项而异。通常，NLP求解器需要一个提供约束函数雅可比矩阵和拉格朗日函数(L(x,λ)\=f(x)+λTg(x))L(x,λ)\=f(x)+λTg(x))L(x,\\lambda) = f(x) + \\lambda^{\\text{T}} \\, g(x))关于xxx的Hessian矩阵的函数。

#### 4.5.1. 创建NLP求解器[¶](#creating-nlp-solvers "Permalink to this heading")

NLP求解器是使用CasADi的`nlpsol`函数创建的。不同的求解器和接口以_插件_形式实现。考虑以下形式的Rosenbrock问题：

minimize:x,y,zx2+100z2subject to:z+(1−x)2−y\=0minimize:x,y,zx2+100z2subject to:z+(1−x)2−y\=0\\begin{split}\\begin{array}{cc} \\begin{array}{c} \\text{minimize:} \\\\ x,y,z \\end{array} & x^2 + 100 \\, z^2 \\\\ \\begin{array}{c} \\text{subject to:} \\end{array} & z+(1-x)^2-y = 0 \\end{array}\\end{split}

使用"ipopt"插件创建该问题求解器的语法如下：

x \= SX.sym('x'); y \= SX.sym('y'); z \= SX.sym('z')
nlp \= {'x':vertcat(x,y,z), 'f':x\*\*2+100\*z\*\*2, 'g':z+(1\-x)\*\*2\-y}
S \= nlpsol('S', 'ipopt', nlp)
print(S)

S:(x0\[3\],p\[\],lbx\[3\],ubx\[3\],lbg,ubg,lam\_x0\[3\],lam\_g0)->(x\[3\],f,g,lam\_x\[3\],lam\_g,lam\_p\[\]) IpoptInterface

x \= SX.sym('x'); y \= SX.sym('y'); z \= SX.sym('z');
nlp \= struct('x',\[x;y;z\], 'f',x^2+100\*z^2, 'g',z+(1\-x)^2\-y);
S \= nlpsol('S', 'ipopt', nlp);
disp(S)

S:(x0\[3\],p\[\],lbx\[3\],ubx\[3\],lbg,ubg,lam\_x0\[3\],lam\_g0)->(x\[3\],f,g,lam\_x\[3\],lam\_g,lam\_p\[\]) IpoptInterface

创建求解器后，我们可以使用`[2.5,3.0,0.75]`作为初始猜测，通过调用函数`S`来求解NLP：

r \= S(x0\=\[2.5,3.0,0.75\],\\
      lbg\=0, ubg\=0)
x\_opt \= r\['x'\]
print('x\_opt: ', x\_opt)

这是Ipopt版本3.14.11，使用线性求解器MUMPS 5.4.1运行。

等式约束雅可比矩阵中的非零元素数量...:        3
不等式约束雅可比矩阵中的非零元素数量.:        0
拉格朗日Hessian矩阵中的非零元素数量.............:        2

变量总数............................:        3
                     仅有下界的变量:        0
                同时有上下界的变量:        0
                     仅有上界的变量:        0
等式约束总数.................:        1
不等式约束总数...............:        0
        仅有下界的不等式约束:        0
   同时有上下界的不等式约束:        0
        仅有上界的不等式约束:        0

iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
   0  6.2500000e+01 0.00e+00 9.00e+01  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1  1.8457621e+01 1.48e-02 4.10e+01  -1.0 4.10e-01   2.0 1.00e+00 1.00e+00f  1
   2  7.8031530e+00 3.84e-03 8.76e+00  -1.0 2.63e-01   1.5 1.00e+00 1.00e+00f  1
   3  7.1678278e+00 9.42e-05 1.04e+00  -1.0 9.32e-02   1.0 1.00e+00 1.00e+00f  1
   4  6.7419924e+00 6.18e-03 9.95e-01  -1.0 2.69e-01   0.6 1.00e+00 1.00e+00f  1
   5  5.4363330e+00 7.03e-02 1.04e+00  -1.7 8.40e-01   0.1 1.00e+00 1.00e+00f  1
   6  1.2144815e+00 1.52e+00 1.32e+00  -1.7 3.21e+00  -0.4 1.00e+00 1.00e+00f  1
   7  1.0214718e+00 2.51e-01 1.17e+01  -1.7 1.33e+00   0.9 1.00e+00 1.00e+00h  1
   8  3.1864085e-01 1.04e-03 7.53e-01  -1.7 3.58e-01    -  1.00e+00 1.00e+00f  1
   9  3.7092062e-66 3.19e-01 2.57e-32  -1.7 5.64e-01    -  1.00e+00 1.00e+00f  1
iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
  10  0.0000000e+00 0.00e+00 0.00e+00  -1.7 3.19e-01    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 10

                                   (scaled)                 (unscaled)
Objective...............:   0.0000000000000000e+00    0.0000000000000000e+00
Dual infeasibility......:   0.0000000000000000e+00    0.0000000000000000e+00
Constraint violation....:   0.0000000000000000e+00    0.0000000000000000e+00
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   0.0000000000000000e+00    0.0000000000000000e+00
Overall NLP error.......:   0.0000000000000000e+00    0.0000000000000000e+00


Number of objective function evaluations             = 11
Number of objective gradient evaluations             = 11
Number of equality constraint evaluations            = 11
Number of inequality constraint evaluations          = 0
Number of equality constraint Jacobian evaluations   = 11
Number of inequality constraint Jacobian evaluations = 0
Number of Lagrangian Hessian evaluations             = 10
Total seconds in IPOPT                               = 0.008

EXIT: Optimal Solution Found.
           S  :   t\_proc      (avg)   t\_wall      (avg)    n\_eval
       nlp\_f  |  66.00us (  6.00us)  15.24us (  1.39us)        11
       nlp\_g  | 151.00us ( 13.73us)  35.12us (  3.19us)        11
  nlp\_grad\_f  |  91.00us (  7.58us)  22.62us (  1.89us)        12
  nlp\_hess\_l  |  64.00us (  6.40us)  16.03us (  1.60us)        10
   nlp\_jac\_g  |  68.00us (  5.67us)  17.40us (  1.45us)        12
       total  |  33.49ms ( 33.49ms)   8.38ms (  8.38ms)         1
x\_opt:  \[0, 1, 0\]

r \= S('x0',\[2.5,3.0,0.75\],...
      'lbg',0,'ubg',0);
x\_opt \= r.x;
disp(x\_opt)

这是 Ipopt 版本 3.14.11，使用线性求解器 MUMPS 5.4.1 运行。

Number of nonzeros in equality constraint Jacobian...:        3
Number of nonzeros in inequality constraint Jacobian.:        0
Number of nonzeros in Lagrangian Hessian.............:        2

Total number of variables............................:        3
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:        1
Total number of inequality constraints...............:        0
        inequality constraints with only lower bounds:        0
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        0

iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
   0  6.2500000e+01 0.00e+00 9.00e+01  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1  1.8457621e+01 1.48e-02 4.10e+01  -1.0 4.10e-01   2.0 1.00e+00 1.00e+00f  1
   2  7.8031530e+00 3.84e-03 8.76e+00  -1.0 2.63e-01   1.5 1.00e+00 1.00e+00f  1
   3  7.1678278e+00 9.42e-05 1.04e+00  -1.0 9.32e-02   1.0 1.00e+00 1.00e+00f  1
   4  6.7419924e+00 6.18e-03 9.95e-01  -1.0 2.69e-01   0.6 1.00e+00 1.00e+00f  1
   5  5.4363330e+00 7.03e-02 1.04e+00  -1.7 8.40e-01   0.1 1.00e+00 1.00e+00f  1
   6  1.2144815e+00 1.52e+00 1.32e+00  -1.7 3.21e+00  -0.4 1.00e+00 1.00e+00f  1
   7  1.0214718e+00 2.51e-01 1.17e+01  -1.7 1.33e+00   0.9 1.00e+00 1.00e+00h  1
   8  3.1864085e-01 1.04e-03 7.53e-01  -1.7 3.58e-01    -  1.00e+00 1.00e+00f  1
   9  3.7092062e-66 3.19e-01 2.57e-32  -1.7 5.64e-01    -  1.00e+00 1.00e+00f  1
iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
  10  0.0000000e+00 0.00e+00 0.00e+00  -1.7 3.19e-01    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 10

                                   (scaled)                 (unscaled)
Objective...............:   0.0000000000000000e+00    0.0000000000000000e+00
Dual infeasibility......:   0.0000000000000000e+00    0.0000000000000000e+00
Constraint violation....:   0.0000000000000000e+00    0.0000000000000000e+00
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   0.0000000000000000e+00    0.0000000000000000e+00
Overall NLP error.......:   0.0000000000000000e+00    0.0000000000000000e+00


Number of objective function evaluations             = 11
Number of objective gradient evaluations             = 11
Number of equality constraint evaluations            = 11
Number of inequality constraint evaluations          = 0
Number of equality constraint Jacobian evaluations   = 11
Number of inequality constraint Jacobian evaluations = 0
Number of Lagrangian Hessian evaluations             = 10
Total seconds in IPOPT                               = 0.008

EXIT: Optimal Solution Found.
           S  :   t\_proc      (avg)   t\_wall      (avg)    n\_eval
       nlp\_f  |  67.00us (  6.09us)  16.00us (  1.45us)        11
       nlp\_g  | 217.00us ( 19.73us)  35.21us (  3.20us)        11
  nlp\_grad\_f  | 100.00us (  8.33us)  23.50us (  1.96us)        12
  nlp\_hess\_l  |  72.00us (  7.20us)  17.46us (  1.75us)        10
   nlp\_jac\_g  |  76.00us (  6.33us)  18.65us (  1.55us)        12
       total  |  36.49ms ( 36.49ms)   9.19ms (  9.19ms)         1
\[0, 1, 0\]

### 4.6. 二次规划[¶](#quadratic-programming "Permalink to this heading")

CasADi 提供了求解二次规划(QP)问题的接口。支持的求解器包括开源求解器 qpOASES(随 CasADi 分发)、OOQP、OSQP 和 PROXQP，以及商业求解器 CPLEX 和 GUROBI。

在 CasADi 中有两种不同的方法来求解 QP 问题：使用高级接口和低级接口。下面将分别介绍这两种方法。

#### 4.6.1. 高级接口[¶](#high-level-interface "Permalink to this heading")

二次规划的高级接口与非线性规划类似，即期望问题的形式为 [(4.5.1)](#equation-nlp)，但限制条件为目标函数 f(x,p) 必须是关于 x 的凸二次函数，约束函数 g(x,p) 必须是关于 x 的线性函数。如果函数不满足二次或线性条件，求解将在当前线性化点(由 x 的"初始猜测"给出)进行求解。

如果目标函数不是凸函数，求解器可能会无法找到解，或者解可能不唯一。

为了说明语法，我们考虑以下凸 QP 问题：

(4.6.1)[¶](#equation-simple-qp "Permalink to this equation")minimize:x,yx2+y2subject to:x+y−10≥0minimize:x,yx2+y2subject to:x+y−10≥0\\begin{split} \\begin{array}{cc} \\begin{array}{c} \\text{minimize:} \\\\ x,y \\end{array} & x^2 + y^2 \\\\ \\begin{array}{c} \\text{subject to:} \\end{array} & x+y-10 \\ge 0 \\end{array}\\end{split}

要使用高级接口解决这个问题，我们只需将 `nlpsol` 替换为 `qpsol`，并使用 QP 求解器插件，例如 CasADi 自带的 qpOASES：

x \= SX.sym('x'); y \= SX.sym('y')
qp \= {'x':vertcat(x,y), 'f':x\*\*2+y\*\*2, 'g':x+y\-10}
S \= qpsol('S', 'qpoases', qp)
print(S)

S:(x0\[2\],p\[\],lbx\[2\],ubx\[2\],lbg,ubg,lam\_x0\[2\],lam\_g0)->(x\[2\],f,g,lam\_x\[2\],lam\_g,lam\_p\[\]) MXFunction

x \= SX.sym('x'); y \= SX.sym('y');
qp \= struct('x',\[x;y\], 'f',x^2+y^2, 'g',x+y\-10);
S \= qpsol('S', 'qpoases', qp);
disp(S)

S:(x0\[2\],p\[\],lbx\[2\],ubx\[2\],lbg,ubg,lam\_x0\[2\],lam\_g0)->(x\[2\],f,g,lam\_x\[2\],lam\_g,lam\_p\[\]) MXFunction

创建的求解器对象 `S` 将具有与 `nlpsol` 创建的求解器对象相同的输入和输出签名。由于解是唯一的，因此提供初始猜测不太重要：

r \= S(lbg\=0)
x\_opt \= r\['x'\]
print('x\_opt: ', x\_opt)

####################   qpOASES  --  QP NO.   1   #####################

    Iter   |    StepLength    |       Info       |   nFX   |   nAC    
 ----------+------------------+------------------+---------+--------- 
       0   |   1.866661e-07   |   ADD CON    0   |     1   |     1   
       1   |   8.333622e-10   |   REM BND    1   |     0   |     1   
       2   |   1.000000e+00   |    QP SOLVED     |     0   |     1   
x\_opt:  \[5, 5\]

r \= S('lbg',0);
x\_opt \= r.x;
disp(x\_opt)

####################   qpOASES  --  QP NO.   1   #####################

    Iter   |    StepLength    |       Info       |   nFX   |   nAC    
 ----------+------------------+------------------+---------+--------- 
       0   |   1.866661e-07   |   ADD CON    0   |     1   |     1   
       1   |   8.333622e-10   |   REM BND    1   |     0   |     1   
       2   |   1.000000e+00   |    QP SOLVED     |     0   |     1   
\[5, 5\]

#### 4.6.2. 底层接口[¶](#low-level-interface "Permalink to this heading")

另一方面，底层接口解决的是以下形式的QP问题：

(4.6.2)[¶](#equation-qp "Permalink to this equation")minimize:x12xTHx+gTxsubject to:xlb≤x≤xubalb≤Ax≤aubminimize:x12xTHx+gTxsubject to:xlb≤x≤xubalb≤Ax≤aub\\begin{split} \\begin{array}{cc} \\begin{array}{c} \\text{minimize:} \\\\ x \\end{array} & \\frac{1}{2} x^T \\, H \\, x + g^T \\, x \\\\ \\begin{array}{c} \\text{subject to:} \\end{array} & \\begin{array}{rcl} x\_{\\textrm{lb}} \\le & x & \\le x\_{\\textrm{ub}} \\\\ a\_{\\textrm{lb}} \\le & A \\, x& \\le a\_{\\textrm{ub}} \\end{array} \\end{array}\\end{split}

将问题[(4.6.1)](#equation-simple-qp)编码为这种形式，省略无限边界的情况，非常简单：

H \= 2\*DM.eye(2)
A \= DM.ones(1,2)
g \= DM.zeros(2)
lba \= 10.

H \= 2\*DM.eye(2);
A \= DM.ones(1,2);
g \= DM.zeros(2);
lba \= 10;

要创建求解器实例，我们现在传递矩阵 HHH 和 AAA 的稀疏模式，而不是传递 QP 的符号表达式。由于我们上面使用了 CasADi 的 `DM` 类型，我们可以直接查询稀疏模式：

qp \= {}
qp\['h'\] \= H.sparsity()
qp\['a'\] \= A.sparsity()
S \= conic('S','qpoases',qp)
print(S)

S:(h\[2x2,2nz\],g\[2\],a\[1x2\],lba,uba,lbx\[2\],ubx\[2\],x0\[2\],lam\_x0\[2\],lam\_a0,q\[\],p\[\])->(x\[2\],cost,lam\_a,lam\_x\[2\]) QpoasesInterface

qp \= struct;
qp.h \= H.sparsity();
qp.a \= A.sparsity();
S \= conic('S','qpoases',qp);
disp(S)

S:(h\[2x2,2nz\],g\[2\],a\[1x2\],lba,uba,lbx\[2\],ubx\[2\],x0\[2\],lam\_x0\[2\],lam\_a0,q\[\],p\[\])->(x\[2\],cost,lam\_a,lam\_x\[2\]) QpoasesInterface

返回的 `Function` 实例将具有与高级接口 _不同_ 的输入/输出签名，其中包含矩阵 HHH 和 AAA：

r \= S(h\=H, g\=g, \\
      a\=A, lba\=lba)
x\_opt \= r\['x'\]
print('x\_opt: ', x\_opt)

####################   qpOASES  --  QP NO.   1   #####################

    Iter   |    StepLength    |       Info       |   nFX   |   nAC    
 ----------+------------------+------------------+---------+--------- 
       0   |   1.866661e-07   |   ADD CON    0   |     1   |     1   
       1   |   8.333622e-10   |   REM BND    1   |     0   |     1   
       2   |   1.000000e+00   |    QP SOLVED     |     0   |     1   
x\_opt:  \[5, 5\]

r \= S('h', H, 'g', g,...
      'a', A, 'lba', lba);
x\_opt \= r.x;
disp(x\_opt)

####################   qpOASES  --  QP NO.   1   #####################

    Iter   |    StepLength    |       Info       |   nFX   |   nAC    
 ----------+------------------+------------------+---------+--------- 
       0   |   1.866661e-07   |   ADD CON    0   |     1   |     1   
       1   |   8.333622e-10   |   REM BND    1   |     0   |     1   
       2   |   1.000000e+00   |    QP SOLVED     |     0   |     1   
\[5, 5\]

### 4.7. For循环等价操作[¶](#for-loop-equivalents "Permalink to this heading")

在CasADi中使用表达式图建模时，使用宿主语言(C++/Python/Matlab)的for循环结构是一种常见模式。

表达式图的大小会随着循环次数nnn线性增长，构建表达式图的时间以及使用该表达式的函数初始化时间也会相应增加。

我们提供了一些特殊结构来改善这种复杂度问题。

#### 4.7.1. Map映射操作[¶](#map "Permalink to this heading")

假设您需要重复计算函数f:Rn→Rmf:Rn→Rmf : \mathbb{R}^{n} \rightarrow \mathbb{R}^{m}在矩阵X∈Rn×NX∈Rn×NX \in \mathbb{R}^{n \times N}的所有列上，并将所有结果聚合到结果矩阵Y∈Rm×NY∈Rm×NY \in \mathbb{R}^{m \times N}中：

N \= 4
X \= MX.sym("X",1,N)

print(f)

ys \= \[\]
for i in range(N):
  ys.append(f(X\[:,i\]))

Y \= hcat(ys)
F \= Function('F',\[X\],\[Y\])
print(F)

f:(i0)->(o0) SXFunction
F:(i0\[1x4\])->(o0\[1x4\]) MXFunction

N \= 4;
X \= MX.sym('X',1,N);

disp(f)

ys \= {};
for i\=1:N
  ys{end+1} \= f(X(:,i));
end
Y \= \[ys{:}\];
F \= Function('F',{X},{Y});
disp(F)

f:(i0)->(o0) SXFunction
F:(i0\[1x4\])->(o0\[1x4\]) MXFunction

聚合函数 F:Rn×N→Rm×NF:Rn×N→Rm×NF : \\mathbb{R}^{n \\times N} \\rightarrow \\mathbb{R}^{m \\times N} 可以通过 `map` 结构获得：

F \= f.map(N)
print(F)

map4\_f:(i0\[1x4\])->(o0\[1x4\]) Map

F \= f.map(N);
disp(F)

map4\_f:(i0\[1x4\])->(o0\[1x4\]) Map

CasADi 可以配置为在计算 FFF 时进行并行处理。在下面的示例中，我们为 `map` 任务分配了 2 个线程。

F \= f.map(N,"thread",2)
print(F)

threadmap2\_map2\_f:(i0\[1x4\])->(o0\[1x4\]) ThreadMap

F \= f.map(N,'thread',2);
disp(F)

threadmap2\_map2\_f:(i0\[1x4\])->(o0\[1x4\]) ThreadMap

`map` 操作支持具有多个输入/输出的原始函数 fff，这些输入/输出也可以是矩阵。聚合总是水平进行的。

`map` 操作具有恒定的图大小和初始化时间。

#### 4.7.2. Fold[¶](#fold "Permalink to this heading")

当每次 for 循环迭代都依赖于前一次迭代的结果时，可以使用 `fold` 结构。在下面的例子中，`x` 变量作为累加器，由 x0∈Rnx0∈Rnx\_0 \\in \\mathbb{R}^{n} 初始化：

x \= x0
for i in range(N):
  x \= f(x)

F \= Function('F',\[x0\],\[x\])
print(F)

F:(i0)->(o0) MXFunction

x \= x0;
for i\=1:N
  x \= f(x);
end

F \= Function('F',{x0},{x});
disp(F)

F:(i0)->(o0) MXFunction

对于给定的函数 f:Rn→Rnf:Rn→Rnf : \\mathbb{R}^{n} \\rightarrow \\mathbb{R}^{n}，可以通过 `fold` 结构获得结果函数 F:Rn→RnF:Rn→RnF : \\mathbb{R}^{n} \\rightarrow \\mathbb{R}^{n}：

F \= f.fold(N)
print(F)

fold\_f:(i0)->(o0) MXFunction

F \= f.fold(N);
disp(F)

fold\_f:(i0)->(o0) MXFunction

如果需要将中间累加器值作为输出 (Rn→Rn×NRn→Rn×N\\mathbb{R}^{n} \rightarrow \mathbb{R}^{n \times N})，请使用 `mapaccum` 而不是 `fold`。

`fold`/`mapaccum` 操作支持具有多个输入/输出的原始函数 fff，这些输入/输出也可以是矩阵。第一个输入和输出用于累加，而其余输入在迭代过程中按列读取。

`map`/`mapaccum` 操作的图大小和初始化时间随 nnn 呈对数增长。

#### 4.7.3. 条件求值[¶](#conditional-evaluation "Permalink to this heading")

可以通过构建 `conditional` 函数实例在 CasADi 表达式图中包含条件求值。该函数接受多个现有的 `Function` 实例 f1f1f\_1, f2f2f\_2, fnfnf\_n 以及一个"默认"函数 fdeffdeff\_{def}。所有这些函数必须具有相同的输入和输出签名，即相同数量的输入和输出且维度相同：

x \= SX.sym("x")
f0 \= Function("f0",\[x\],\[sin(x)\])
f1 \= Function("f1",\[x\],\[cos(x)\])
f2 \= Function("f2",\[x\],\[tan(x)\])
f\_cond \= Function.conditional('f\_cond', \[f0, f1\], f2)
print(f\_cond)

f\_cond:(i0,i1)->(o0) Switch

x \= SX.sym('x');
f0 \= Function('f0',{x},{sin(x)});
f1 \= Function('f1',{x},{cos(x)});
f2 \= Function('f2',{x},{tan(x)});
f\_cond \= Function.conditional('f\_cond', {f0, f1}, f2);
disp(f\_cond);

f\_cond:(i0,i1)->(o0) Switch

结果是一个具有相同输入/输出签名的新函数实例，但增加了一个对应索引的额外输入。其求值过程对应于：

fcond(c,x1,x2,…,xm)\=⎧⎪⎨⎪⎩f0(x1,x2,…,xm)if c\=0,f1(x1,x2,…,xm)if c\=1,f2(x1,x2,…,xm)otherwisefcond(c,x1,x2,…,xm)\={f0(x1,x2,…,xm)if c\=0,f1(x1,x2,…,xm)if c\=1,f2(x1,x2,…,xm)otherwise\\begin{split}f\_{\\text{cond}}(c, x\_1, x\_2, \\ldots, x\_m) = \\left\\{ \\begin{array}{ll} f\_0(x\_1, x\_2, \\ldots, x\_m) & \\text{if $c = 0$,} \\\\ f\_1(x\_1, x\_2, \\ldots, x\_m) & \\text{if $c = 1$,} \\\\ f\_2(x\_1, x\_2, \\ldots, x\_m) & \\text{otherwise} \\end{array} \\right.\\end{split}

上述函数可能缺失（即是一个空指针 `Function()`），这种情况下所有输出将被求值为 NaN。注意求值是"短路"的，即只会评估相关函数。这也适用于任何导数计算。

一个常见的特殊情况是除了默认情况外只有一个条件分支。这相当于 if-then-else 语句，可以使用简写形式表示：

x \= SX.sym("x")
f\_true \= Function("f\_true",\[x\],\[cos(x)\])
f\_false \= Function("f\_false",\[x\],\[sin(x)\])
f\_cond \= Function.if\_else('f\_cond', f\_true, f\_false)
print(f\_cond)

f\_cond:(i0,i1)->(o0) Switch

x \= SX.sym('x');
f\_true \= Function('f\_true',{x},{cos(x)});
f\_false \= Function('f\_false',{x},{sin(x)});
f\_cond \= Function.if\_else('f\_cond', f\_true, f\_false);
disp(f\_cond);

f\_cond:(i0,i1)->(o0) Switch

需要注意的是，此类条件表达式可能导致非光滑表达式，如果在基于梯度的优化算法中使用，可能无法收敛。

脚注

\[1\]

对于自由结束时间的问题，您总是可以通过引入一个额外参数来缩放时间，并将 ttt 替换为从 0 到 1 的无量纲时间变量

## 5. 生成 C 代码[¶](#generating-c-code "Permalink to this heading")

CasADi 中函数对象的数值计算通常在_虚拟机_中进行，这是 CasADi 符号框架的一部分。但 CasADi 也支持为大部分函数对象生成独立的 C 代码。

生成 C 代码有以下几个重要意义：

*   加速计算时间。根据经验，使用代码优化标志编译的自动生成代码，其数值计算速度通常比在 CasADi 虚拟机中执行相同代码快 4 到 10 倍。
    
*   允许在没有安装 CasADi 的系统上编译代码，例如嵌入式系统。编译生成的代码只需要一个 C 编译器。
    
*   调试和分析函数。生成的代码本质上是虚拟机中评估过程的镜像，如果某个特定操作很慢，在使用 `gprof` 等分析工具分析生成的代码时很可能会显现出来。通过查看代码，还可以发现潜在的非最优实现方式。如果代码非常长且编译时间很长，这表明某些函数需要拆分为更小但嵌套的函数。
    

### 5.1. 生成代码的语法[¶](#syntax-for-generating-code "Permalink to this heading")

生成 C 代码可以像调用 `Function` 实例的 `generate` 成员函数那样简单。

x \= MX.sym('x',2)
y \= MX.sym('y')
f \= Function('f',\[x,y\],\\
      \[x,sin(y)\*x\],\\
      \['x','y'\],\['r','q'\])
f.generate('gen.c')
print(open('gen.c','r').read())

/\* 此文件由 CasADi 3.7.0 自动生成。
 \* 包含以下内容：
 \*   1) CasADi 运行时生成的内容：无版权
 \*   2) 从 CasADi 源代码复制的模板代码：宽松许可(MIT-0)
 \*   3) 用户代码：归用户所有
 \*
 \*/
#ifdef \_\_cplusplus
extern "C" {
#endif

/\* 如何为内部符号添加前缀 \*/
#ifdef CASADI\_CODEGEN\_PREFIX
  #define CASADI\_NAMESPACE\_CONCAT(NS, ID) \_CASADI\_NAMESPACE\_CONCAT(NS, ID)
  #define \_CASADI\_NAMESPACE\_CONCAT(NS, ID) NS ## ID
  #define CASADI\_PREFIX(ID) CASADI\_NAMESPACE\_CONCAT(CODEGEN\_PREFIX, ID)
#else
  #define CASADI\_PREFIX(ID) gen\_ ## ID
#endif

#include <math.h>

#ifndef casadi\_real
#define casadi\_real double
#endif

#ifndef casadi\_int
#define casadi\_int long long int
#endif

/\* Add prefix to internal symbols \*/
#define casadi\_copy CASADI\_PREFIX(copy)
#define casadi\_f0 CASADI\_PREFIX(f0)
#define casadi\_s0 CASADI\_PREFIX(s0)
#define casadi\_s1 CASADI\_PREFIX(s1)

/\* Symbol visibility in DLLs \*/
#ifndef CASADI\_SYMBOL\_EXPORT
  #if defined(\_WIN32) || defined(\_\_WIN32\_\_) || defined(\_\_CYGWIN\_\_)
    #if defined(STATIC\_LINKED)
      #define CASADI\_SYMBOL\_EXPORT
    #else
      #define CASADI\_SYMBOL\_EXPORT \_\_declspec(dllexport)
    #endif
  #elif defined(\_\_GNUC\_\_) && defined(GCC\_HASCLASSVISIBILITY)
    #define CASADI\_SYMBOL\_EXPORT \_\_attribute\_\_ ((visibility ("default")))
  #else
    #define CASADI\_SYMBOL\_EXPORT
  #endif
#endif

void casadi\_copy(const casadi\_real\* x, casadi\_int n, casadi\_real\* y) {
  casadi\_int i;
  if (y) {
    if (x) {
      for (i=0; i<n; ++i) \*y++ = \*x++;
    } else {
      for (i=0; i<n; ++i) \*y++ = 0.;
    }
  }
}

static const casadi\_int casadi\_s0\[3\] = {2, 1, 1};
static const casadi\_int casadi\_s1\[3\] = {1, 1, 1};

/\* f:(x\[2\],y)->(r\[2\],q\[2\]) \*/
static int casadi\_f0(const casadi\_real\*\* arg, casadi\_real\*\* res, casadi\_int\* iw, casadi\_real\* w, int mem) {
  casadi\_int i;
  casadi\_real \*rr, \*w0=w+0, w1;
  const casadi\_real \*cs;
  /\* #0: @0 = input\[0\]\[0\] \*/
  casadi\_copy(arg\[0\], 2, w0);
  /\* #1: output\[0\]\[0\] = @0 \*/
  casadi\_copy(w0, 2, res\[0\]);
  /\* #2: @1 = input\[1\]\[0\] \*/
  w1 = arg\[1\] ? arg\[1\]\[0\] : 0;
  /\* #3: @1 = sin(@1) \*/
  w1 = sin( w1 );
  /\* #4: @0 = (@1\*@0) \*/
  for (i=0, rr=w0, cs=w0; i<2; ++i) (\*rr++)  = (w1\*(\*cs++));
  /\* #5: output\[1\]\[0\] = @0 \*/
  casadi\_copy(w0, 2, res\[1\]);
  return 0;
}

CASADI\_SYMBOL\_EXPORT int f(const casadi\_real\*\* arg, casadi\_real\*\* res, casadi\_int\* iw, casadi\_real\* w, int mem){
  return casadi\_f0(arg, res, iw, w, mem);
}

CASADI\_SYMBOL\_EXPORT int f\_alloc\_mem(void) {
  return 0;
}

CASADI\_SYMBOL\_EXPORT int f\_init\_mem(int mem) {
  return 0;
}

CASADI\_SYMBOL\_EXPORT void f\_free\_mem(int mem) {
}

CASADI\_SYMBOL\_EXPORT int f\_checkout(void) {
  return 0;
}

CASADI\_SYMBOL\_EXPORT void f\_release(int mem) {
}

CASADI\_SYMBOL\_EXPORT void f\_incref(void) {
}

CASADI\_SYMBOL\_EXPORT void f\_decref(void) {
}

CASADI\_SYMBOL\_EXPORT casadi\_int f\_n\_in(void) { return 2;}

CASADI\_SYMBOL\_EXPORT casadi\_int f\_n\_out(void) { return 2;}

CASADI\_SYMBOL\_EXPORT casadi\_real f\_default\_in(casadi\_int i) {
  switch (i) {
    default: return 0;
  }
}

CASADI\_SYMBOL\_EXPORT const char\* f\_name\_in(casadi\_int i) {
  switch (i) {
    case 0: return "x";
    case 1: return "y";
    default: return 0;
  }
}

CASADI\_SYMBOL\_EXPORT const char\* f\_name\_out(casadi\_int i) {
  switch (i) {
    case 0: return "r";
    case 1: return "q";
    default: return 0;
  }
}

CASADI\_SYMBOL\_EXPORT const casadi\_int\* f\_sparsity\_in(casadi\_int i) {
  switch (i) {
    case 0: return casadi\_s0;
    case 1: return casadi\_s1;
    default: return 0;
  }
}

CASADI\_SYMBOL\_EXPORT const casadi\_int\* f\_sparsity\_out(casadi\_int i) {
  switch (i) {
    case 0: return casadi\_s0;
    case 1: return casadi\_s0;
    default: return 0;
  }
}

CASADI\_SYMBOL\_EXPORT int f\_work(casadi\_int \*sz\_arg, casadi\_int\* sz\_res, casadi\_int \*sz\_iw, casadi\_int \*sz\_w) {
  if (sz\_arg) \*sz\_arg = 4;
  if (sz\_res) \*sz\_res = 3;
  if (sz\_iw) \*sz\_iw = 0;
  if (sz\_w) \*sz\_w = 3;
  return 0;
}

CASADI\_SYMBOL\_EXPORT int f\_work\_bytes(casadi\_int \*sz\_arg, casadi\_int\* sz\_res, casadi\_int \*sz\_iw, casadi\_int \*sz\_w) {
  if (sz\_arg) \*sz\_arg = 4\*sizeof(const casadi\_real\*);
  if (sz\_res) \*sz\_res = 3\*sizeof(casadi\_real\*);
  if (sz\_iw) \*sz\_iw = 0\*sizeof(casadi\_int);
  if (sz\_w) \*sz\_w = 3\*sizeof(casadi\_real);
  return 0;
}


#ifdef \_\_cplusplus
} /\* extern "C" \*/
#endif

x \= MX.sym('x',2);
y \= MX.sym('y');
f \= Function('f',{x,y},...
      {x,sin(y)\*x},...
      {'x','y'},{'r','q'});
f.generate('gen.c');

这将创建一个C文件`gen.c`，其中包含函数`f`及其所有依赖项和所需的辅助函数。我们将在[5.1节](#sec-codegen-syntax)中讨论如何使用该文件，生成的代码结构将在[5.3节](#sec-c-api)中描述。

您可以通过使用CasADi的`CodeGenerator`类来生成包含多个CasADi函数的C文件：

f \= Function('f',\[x\],\[sin(x)\])
g \= Function('g',\[x\],\[cos(x)\])
C \= CodeGenerator('gen.c')
C.add(f)
C.add(g)
C.generate()

f \= Function('f',{x},{sin(x)});
g \= Function('g',{x},{cos(x)});
C \= CodeGenerator('gen.c');
C.add(f);
C.add(g);
C.generate();

`generate`函数和`CodeGenerator`构造函数都接受一个可选的options字典参数，用于自定义代码生成。其中两个实用的选项是`main`(生成_main入口点)和`mex`(生成_mexFunction入口点):

f \= Function('f',\[x\],\[sin(x)\])
opts \= dict(main\=True, \\
            mex\=True)
f.generate('gen.c',opts)

f \= Function('f',{x},{sin(x)});
opts \= struct('main', true,...
              'mex', true);
f.generate('gen.c',opts);

这样就可以分别从命令行和MATLAB执行该函数，具体将在[5.2节](#sec-using-codegen)中描述。

如果计划在C/C++应用程序中直接链接生成的代码，一个有用的选项是`with_header`，它控制是否生成包含外部链接函数声明的头文件，即生成代码的API接口，详见[5.3节](#sec-c-api)描述。

以下是`CodeGenerator`类可用的选项列表：

| 选项 | 默认值 | 描述 |
| --- | --- | --- |
| `verbose` | true | 在生成代码中包含注释 |
| `mex` | false | 生成MATLAB/Octave的MEX入口点 |
| `cpp` | false | 生成C++代码而非C代码 |
| `main` | false | 生成命令行接口 |
| `casadi_real` | `double` | 浮点数类型 |
| `casadi_int` | `long long int` | 整数类型 |
| `with_header` | false | 生成头文件 |
| `with_mem` | false | 生成简化的C API |
| `indent` | 2   | 每级缩进的空格数 |

### 5.2. 使用生成的代码[¶](#using-the-generated-code "Permalink to this heading")

生成的C代码可以通过多种方式使用：

* 可以将代码编译成动态链接库(DLL)，然后使用CasADi的`external`函数创建`Function`实例。用户也可以选择依赖CasADi进行即时编译(_just-in-time_)
    
* 生成的代码可以编译成MEX函数并在MATLAB中执行
    
* 可以从命令行执行生成的代码
    
* 用户可以静态或动态地将生成的代码链接到其C/C++应用程序，访问生成代码的C API
    
* 代码可以编译成动态链接库，然后用户可以在Linux/OS X上使用`dlopen`或在Windows上使用`LoadLibrary`手动访问C API

下文将详细展开说明。

#### 5.2.1. CasADi的`external`函数[¶](#casadi-s-external-function "Permalink to this heading")

`external`命令允许用户从动态链接库创建`Function`实例，该库的入口点由[5.3节](#sec-c-api)描述的C API定义。由于自动生成的文件是自包含的[\[1\]](#f2)，在Linux/OSX系统上编译可以简单地在命令行执行：

gcc -fPIC -shared gen.c -o gen.so

或者等价地使用MATLAB的`system`命令或Python的`os.system`命令。假设`gen.c`已按前文所述创建，我们可以如下创建`Function` `f`：

f \= external('f', './gen.so')
print(f(3.14))

0.00159265

f \= external('f', './gen.so');
disp(f(3.14))

0.00159265

我们也可以依赖CasADi使用`Importer`类进行_即时编译_。这是一个插件类，在编写本文时支持两个插件：`'clang'`(调用CasADi自带的_LLVM/Clang_编译器框架)和`'shell'`(通过命令行调用系统编译器)：

C \= Importer('gen.c','shell')
f \= external('f',C)
print(f(3.14))

0.00159265

C \= Importer('gen.c','shell');
f \= external('f',C);
disp(f(3.14))

0.00159265
CasADi - 2025-03-29 19:11:39 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellL00eOj.so") \[.../casadi/solvers/shell\_compiler.cpp:66\]
CasADi - 2025-03-29 19:11:39 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellL00eOj.o") \[.../casadi/solvers/shell\_compiler.cpp:67\]

我们将在[6.3节](#sec-external)再次讨论`external`函数。

#### 5.2.2. 从MATLAB调用生成的代码[¶](#calling-generated-code-from-matlab "Permalink to this heading")

另一种执行生成代码的方式是将代码编译成MATLAB MEX函数并在MATLAB中调用。这需要确保在代码生成时`mex`选项设为"true"，参见[5.1节](#sec-codegen-syntax)。生成的MEX函数以函数名作为第一个参数，后跟函数输入：

%mex gen.c -largeArrayDims  % Matlab
mex gen.c \-DMATLAB\_MEX\_FILE % Octave

disp(gen('f', 3.14))

1.5927e-03

注意默认情况下执行结果总是MATLAB稀疏矩阵。可以通过设置编译器标志`-DCASASI_MEX_ALWAYS_DENSE`和`-DCASASI_MEX_ALLOW_DENSE`来改变此行为。

#### 5.2.3. 从命令行调用生成的代码[¶](#calling-generated-code-from-the-command-line "Permalink to this heading")

另一种选择是从Linux/OSX命令行执行生成的代码。这需要代码生成时`main`选项设为"true"，参见[5.1节](#sec-codegen-syntax)。当您想使用如`gprof`等工具对生成代码进行分析时，这种方式很有用。

执行生成代码时，函数名作为命令行参数传入。所有输入的非零元素需要通过标准输入传入，函数将通过标准输出返回所有输出的非零元素：

\# Command line
echo 3.14 3.14 > gen\_in.txt
gcc gen.c -o gen
./gen f < gen\_in.txt > gen\_out.txt
cat gen\_out.txt # returns 0.00159265 0.00159265

#### 5.2.4. 从C/C++应用程序链接生成的代码[¶](#linking-against-generated-code-from-a-c-c-application "Permalink to this heading")

生成的代码可以直接从C/C++应用程序链接使用。如果在代码生成时将`with_header`选项设为"true"，则会生成一个包含文件所有公开入口点声明的头文件。使用此头文件需要理解CasADi的codegen API，如[5.3节](#sec-c-api)所述。未公开的符号会加上文件特定的前缀，这样应用程序可以链接多个生成的函数而不会产生符号冲突。

#### 5.2.5. 从C/C++应用程序动态加载生成的代码[¶](#dynamically-loading-generated-code-from-a-c-c-application "Permalink to this heading")

另一种方式是将生成的代码编译成共享库，但直接访问公开的符号而不是依赖CasADi的`external`函数。这也需要理解生成代码的结构。

在CasADi的示例集合中，`codegen_usage.cpp`演示了如何实现这一点。

### 5.3. 生成代码的API[¶](#api-of-the-generated-code "Permalink to this heading")

生成代码的API由一系列具有外部链接的函数组成。除了实际执行外，还包括内存管理函数以及关于输入输出的元信息函数。下面将描述这些函数。假设我们要访问的函数名为`fname`。要查看这些函数在代码中的实际样子以及它们何时被调用，请参考`codegen_usage.cpp`示例。

#### 5.3.1. 引用计数[¶](#reference-counting "Permalink to this heading")

void fname\_incref(void);
void fname\_decref(void);

生成的函数可能需要在首次调用前读取数据或初始化数据结构。对于从CasADi表达式生成的函数通常不需要，但当生成的代码包含对外部函数的调用时可能需要。同样，使用后可能需要释放内存。

为了跟踪所有权，生成的代码包含两个用于增加和减少引用计数的函数。它们分别命名为`fname_incref`和`fname_decref`。这些函数没有输入参数且返回void。

通常，第一次调用`fname_incref`时会进行一些初始化，后续调用只会增加内部计数器。而`fname_decref`会减少内部计数器，当计数器归零时，如果有的话，会进行释放操作。

#### 5.3.2. 输入输出数量[¶](#number-of-inputs-and-outputs "Permalink to this heading")

casadi\_int fname\_n\_in(void);
casadi\_int fname\_n\_out(void);

可以通过调用`fname_n_in`和`fname_n_out`函数分别获取函数的输入和输出数量。这些函数不需要输入参数，返回输入或输出的数量(`casadi_int`是`long long int`的别名)。

#### 5.3.3. 输入输出名称[¶](#names-of-inputs-and-outputs "Permalink to this heading")

const char\* fname\_name\_in(casadi\_int ind);
const char\* fname\_name\_out(casadi\_int ind);

函数`fname_name_in`和`fname_name_out`返回特定输入或输出的名称。它们接收输入或输出的索引(从0开始)，并返回一个以null结尾的C字符串(`const char*`)。如果调用失败，这些函数会返回空指针。

#### 5.3.4. 输入输出的稀疏模式[¶](#sparsity-patterns-of-inputs-and-outputs "Permalink to this heading")

const casadi\_int\* fname\_sparsity\_in(casadi\_int ind);
const casadi\_int\* fname\_sparsity\_out(casadi\_int ind);

通过调用`fname_sparsity_in`和`fname_sparsity_out`可以获取给定输入或输出的稀疏模式。这些函数接收输入或输出的索引，并返回一个指向常量整数数组的指针(`const casadi_int*`)。这是CasADi使用的_压缩列存储_(CCS)格式的紧凑表示，参见[3.5节](#sec-sparsity-class)。所指向的整数数组结构如下：

*   前两个元素分别是行数和列数，下文称为`nrow`和`ncol`。
    
*   如果第三个元素是`1`，则表示模式是密集的，其余元素将被忽略。
    
*   如果第三个元素是`0`，则该元素加上后续`ncol`个元素构成每列的非零偏移量，下文称为`colind`。例如，第iii列的非零索引范围是从`colind[i]`到`colind[i+1]`。最后一个元素`colind[ncol]`等于非零元素的数量`nnz`。
    
*   最后，_如果_稀疏模式_不是密集的_，即`nnz` ≠≠\\ne `nrow` \* `ncol`，则最后`nnz`个元素将包含行索引。
    

如果调用失败，这些函数会返回空指针。

#### 5.3.5. 内存对象[¶](#memory-objects "Permalink to this heading")

函数可能包含一些可变内存，例如用于缓存最新因子分解或跟踪评估统计信息。当多个函数需要调用同一个函数而不冲突时，它们每个都需要使用不同的内存对象。这对于在共享内存架构上并行评估尤为重要，此时每个线程都应访问不同的内存对象。

void\* fname\_alloc\_mem(void);

分配一个内存对象，该对象将被传递给数值计算。

int fname\_init\_mem(void\* mem);

(重新)初始化一个内存对象。成功时返回0；

int fname\_free\_mem(void\* mem);

释放一个内存对象。成功时返回0；

#### 5.3.6. 工作向量[¶](#work-vectors "Permalink to this heading")

int fname\_work(casadi\_int\* sz\_arg, casadi\_int\* sz\_res, casadi\_int\* sz\_iw, casadi\_int\* sz\_w);

为了以较小的内存占用高效执行计算，用户需要传递四个工作数组。函数`fname_work`返回这些数组的长度，这些数组的条目类型分别为`const double*`、`double*`、`casadi_int`和`double`。

函数执行失败时返回非零值。

#### 5.3.7. 数值计算[¶](#numerical-evaluation "Permalink to this heading")

int fname(const double\*\* arg, double\*\* res,
          casadi\_int\* iw, double\* w, void\* mem);

最后，函数`fname`执行实际计算。它接收四个工作向量和通过`fname_alloc_mem`创建的内存对象(如果不存在则为NULL)作为输入参数。工作向量的长度必须至少为`fname_work`命令提供的长度，且内存对象的索引必须严格小于`fname_n_mem`返回的值。

函数输入的非零元素由`arg`工作向量的第一个条目指向，并且在计算过程中保持不变。类似地，输出的非零元素由`res`工作向量的第一个条目指向，同样保持不变(即指针不变，实际值会变)。

函数执行失败时返回非零值。

脚注

\[[1](#id1)\]

例外情况是为一个函数生成代码时，该函数又包含对外部函数的调用。

## 6. 用户自定义函数对象[¶](#user-defined-function-objects "Permalink to this heading")

在某些情况下，使用CasADi符号重写用户函数可能不可行或不切实际。为解决这个问题，CasADi提供了多种方法来嵌入对"黑盒"函数的调用，这些函数可以用CasADi正在使用的语言(C++、MATLAB或Python)或C语言定义。尽管如此，我们仍然建议尽可能避免这种情况，即使这意味着需要花费大量时间重新实现现有代码。使用CasADi符号定义的函数几乎总是更高效，特别是在涉及导数计算时，因为通常可以充分利用更多结构。

根据具体情况，用户可以通过以下几种不同方式实现自定义`Function`对象，以下各节将详细说明：

*   继承`FunctionInternal`类: [6.1节](#sec-function-internal)
    
*   继承`Callback`类: [6.2节](#sec-callback)
    
*   使用`external`导入函数: [6.3节](#sec-external)
    
*   即时编译C语言字符串: [6.4节](#sec-jit-function)
    
*   用查找表替换函数调用: [6.5节](#sec-lookup)
    

### 6.1. 继承 `FunctionInternal`[¶](#subclassing-functioninternal "Permalink to this heading")

[第4章](#sec-function)中介绍的所有函数对象在CasADi中都是通过继承`FunctionInternal`抽象基类的C++类实现的。原则上，熟悉C++编程的用户可以实现一个继承自`FunctionInternal`的类，重载该类的虚方法。最好的参考文档是C++ API文档，选择"switch to internal"来查看内部API。

由于`FunctionInternal`不被视为稳定公共API的一部分，我们通常不建议这样做，除非计划为CasADi源代码做贡献。

### 6.2. 继承 `Callback`[¶](#subclassing-callback "Permalink to this heading")

`Callback`类为`FunctionInternal`提供了一个公共API，继承这个类与直接继承`FunctionInternal`具有相同的效果。得益于_跨语言多态性_，可以从Python、MATLAB/Octave或C++实现`Callback`的公开方法。

派生类包含以下部分：

*   构造函数或替代构造函数的静态函数
    
*   多个可选的_virtual_函数，可以重载以获得所需行为。包括使用`get_n_in`和`get_n_out`获取输入输出数量，使用`get_name_in`和`get_name_out`获取它们的名称，以及使用`get_sparsity_in`和`get_sparsity_out`获取它们的稀疏模式。
    
*   在对象构造期间调用的可选`init`函数
    
*   用于数值计算的函数
    
*   用于导数的可选函数。可以选择使用有限差分(`enable_fd`)、提供完整雅可比矩阵(`has_jacobian`, `get_jacobian`)，或者选择提供前向/反向灵敏度(`has_forward`, `get_forward`, `has_reverse`, `get_reverse`)。

要查看完整函数列表，请参阅`Callback`的C++ API文档。另请参阅`callback.py`示例。

不同语言的使用方法将在下面描述。

#### 6.2.1. Python[¶](#python "Permalink to this heading")

class MyCallback(Callback):
  def \_\_init\_\_(self, name, d, opts\={}):
    Callback.\_\_init\_\_(self)
    self.d \= d
    self.construct(name, opts)

  \# Number of inputs and outputs
  def get\_n\_in(self): return 1
  def get\_n\_out(self): return 1

  \# Initialize the object
  def init(self):
     print('initializing object')

  \# Evaluate numerically
  def eval(self, arg):
    x \= arg\[0\]
    f \= sin(self.d\*x)
    return \[f\]

实现中应包含一个构造函数，该函数应以调用基类构造函数`Callback.__init__(self)`开始，并以调用`self.construct(name, opts)`初始化对象构造结束。

此函数可以像任何内置CasADi函数一样使用，但需要注意重要的一点：当嵌入到计算图中时，类的所有权_不会_在所有引用之间共享。因此用户必须确保在计算仍需要该Python类时，不要让它超出作用域。

\# Use the function
f \= MyCallback('f', 0.5)
print(f(2))

x \= MX.sym("x")
print(f(x))

initializing object
0.841471
f(x){0}

#### 6.2.2. MATLAB[¶](#matlab "Permalink to this heading")

在MATLAB中，自定义函数类可以按以下方式定义，保存在文件`MyCallback.m`中：

classdef MyCallback < casadi.Callback
  properties
    d
  end
  methods
    function self \= MyCallback(name, d)
      self@casadi.Callback();
      self.d \= d;
      construct(self, name);
    end

    % Number of inputs and outputs
    function v\=get\_n\_in(self)
      v\=1;
    end
    function v\=get\_n\_out(self)
      v\=1;
    end

    % Initialize the object
    function init(self)
      disp('initializing object')
    end

    % Evaluate numerically
    function arg \= eval(self, arg)
      x \= arg{1};
      f \= sin(self.d \* x);
      arg \= {f};
    end
  end
end

此函数可以像任何内置CasADi函数一样使用，但和Python中一样，类的所有权_不会_在所有引用之间共享。因此用户必须确保在使用类实例时不要让它被删除，例如可以通过将其设为`persistent`来实现。

% Use the function
f \= MyCallback('f', 0.5);
res \= f(2);
disp(res)

x \= MX.sym('x');
disp(f(x))

#### 6.2.3. C++[¶](#c "Permalink to this heading")

在C++中，语法如下：

#include "casadi/casadi.hpp"
using namespace casadi;
class MyCallback : public Callback {
  // Data members
  double d;
public:
  // Constructor
  MyCallback(const std::string& name, double d,
             const Dict& opts\=Dict()) : d(d) {
    construct(name, opts);
  }

  // Destructor
  ~MyCallback() override {}

  // Number of inputs and outputs
  casadi\_int get\_n\_in() override { return 1;}
  casadi\_int get\_n\_out() override { return 1;}

  // Initialize the object
  void init() override() {
    std::cout << "initializing object" << std::endl;
  }

  // Evaluate numerically
  std::vector<DM\> eval(const std::vector<DM\>& arg) const override {
    DM x \= arg.at(0);
    DM f \= sin(d\*x);
    return {f};
  }
};

以这种方式创建的类可以像其他`Function`实例一样使用，但重要区别在于用户需要负责管理该类的内存。

int main() {
  MyCallback f("f", 0.5);
  std::vector<DM\> arg \= {2};
  std::vector<DM\> res \= f(arg);
  std::cout << res << std::endl;
  return 0;
}

### 6.3. 使用 `external` 导入函数[¶](#importing-a-function-with-external "Permalink to this heading")

CasADi的`external`函数的基本用法已在[5.2节](#sec-using-codegen)中结合自动生成代码的上下文进行了演示。该函数同样可用于导入用户自定义函数，只要该函数也使用[5.3节](#sec-c-api)描述的C API。

以下章节将对此进行扩展说明。

#### 6.3.1. 默认函数[¶](#default-functions "Permalink to this heading")

通常_不需要_定义[5.3节](#sec-c-api)中列出的所有函数。如果缺少`fname_incref`和`fname_decref`，则假定不需要内存管理。如果未提供输入输出名称，系统会自动分配默认名称。默认情况下，稀疏模式通常假定为标量，除非该函数对应于另一个函数的导数（见下文），此时会假定其为密集矩阵并具有正确维度。

此外，如果未实现`fname_work`，则假定不需要工作向量。

#### 6.3.2. 作为注释的元信息[¶](#meta-information-as-comments "Permalink to this heading")

如果依赖CasADi的即时编译器，您可以在C代码中以注释形式提供元信息，而无需实现实际回调函数。

此类元信息的结构应如下所示：

/\*CASADIMETA
:fname\_N\_IN 1
:fname\_N\_OUT 2
:fname\_NAME\_IN\[0\] x
:fname\_NAME\_OUT\[0\] r
:fname\_NAME\_OUT\[1\] s
:fname\_SPARSITY\_IN\[0\] 2 1 0 2
\*/

#### 6.3.3. 导数计算[¶](#derivatives "Permalink to this heading")

通过提供导数计算函数，可以使外部函数可微分。在进行导数计算时，CasADi会按照特定的_命名约定_在同一文件/共享库中查找符号。例如，要为名为`fname`的函数指定所有输出对所有输入的雅可比矩阵，可以实现名为`jac_fname`的函数。类似地，可以通过提供名为`fwd1_fname`的函数来指定计算一个前向导数的函数，其中1可以替换为2、4、8、16、32或64以同时计算多个前向导数。对于反向模式方向导数，将`fwd`替换为`adj`。

这是一个实验性功能。

### 6.4. 即时编译C语言字符串[¶](#just-in-time-compile-a-c-language-string "Permalink to this heading")

在前一节中，我们展示了如何指定包含数值计算函数和元信息的C文件。如所示，该文件可以通过CasADi与Clang的接口进行即时编译。这种方法有一个简写形式，用户只需将源代码指定为C语言字符串即可。

body \=\\
'r\[0\] = x\[0\];'+\\
'while (r\[0\]<s\[0\]) {'+\\
' r\[0\] \*= r\[0\];'+\\
'}'

f \= Function.jit('f',body,\\
      \['x','s'\],\['r'\],\\
      {"compiler":"shell"})
print(f)

f:(x,s)->(r) JitFunction

body \=\[...
'r\[0\] = x\[0\];',...
'while (r\[0\]<s\[0\]) {',...
' r\[0\] \*= r\[0\];',...
'}'\];

f \= Function.jit('f',body,...
      {'x','s'},{'r'},...
      struct('compiler','shell'));
disp(f)

f:(x,s)->(r) JitFunction
CasADi - 2025-03-29 19:11:41 WARNING("Failed to remove jit\_tmpMsqCn7.c") \[.../casadi/core/function\_internal.cpp:133\]
CasADi - 2025-03-29 19:11:41 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellqC1Af1.so") \[.../casadi/solvers/shell\_compiler.cpp:66\]
CasADi - 2025-03-29 19:11:41 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellqC1Af1.o") \[.../casadi/solvers/shell\_compiler.cpp:67\]

`Function.jit` 的这四个参数是必需的：函数名称、作为字符串的C源代码、输入和输出的名称。在C源代码中，输入/输出名称对应于类型为 `casadi_real_t` 的数组，这些数组包含函数输入和输出的非零元素。默认情况下，所有输入和输出都是标量（即1×1且密集）。要指定不同的稀疏模式，需要提供两个额外的函数参数，包含稀疏模式的向量/列表：

sp \= Sparsity.scalar()
f \= Function.jit('f',body,\\
     \['x','s'\], \['r'\],\\
     \[sp,sp\], \[sp\],\\
     {"compiler":"shell"})
print(f)

f:(x,s)->(r) JitFunction

sp \= Sparsity.scalar();
f \= Function.jit('f',body,...
     {'x','s'}, {'r'},...
     {sp,sp}, {sp},...
     struct('compiler','shell'));
disp(f)

f:(x,s)->(r) JitFunction
CasADi - 2025-03-29 19:11:30 WARNING("Failed to remove jit\_tmp5RVeRY.c") \[.../casadi/core/function\_internal.cpp:133\]
CasADi - 2025-03-29 19:11:30 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellNuAeFJ.so") \[.../casadi/solvers/shell\_compiler.cpp:66\]
CasADi - 2025-03-29 19:11:30 WARNING("Failed to remove ./tmp\_casadi\_compiler\_shellNuAeFJ.o") \[.../casadi/solvers/shell\_compiler.cpp:67\]

两种变体都接受可选的第5个(或第7个)参数，形式为选项字典。

### 6.5. 使用查找表[¶](#using-lookup-tables "Permalink to this heading")

可以使用CasADi的`interpolant`函数创建查找表。不同的插值方案作为_插件_实现，类似于`nlpsol`或`integrator`对象。除了标识符名称和插件外，`interpolant`函数还需要一组网格点及其对应的数值。

`interpolant`调用的结果是一个可微分的CasADi Function对象，可以通过使用MX参数调用嵌入到CasADi计算图中。此外，完全支持对此类图进行C代码生成。

目前`interpolant`有两个插件：`'linear'`和`'bspline'`。它们的行为旨在类似于MATLAB/Octave的`interpn`，方法设置为`'linear'`或`'spline'`——分别对应多线性插值和(默认三次)样条插值(具有非节点边界条件)。

对于`bspline`，将在构造时寻找适合提供数据的系数。或者，您也可以使用更低级别的`Function.bspline`自行提供系数。bspline的默认度数在每个维度上都是3。您可以通过传递`degree`选项来偏离此默认值。

我们将逐步介绍`interpolant`在1D和2D版本中的语法，但实际上该语法可推广到任意数量的维度。

#### 6.5.1. 一维查找表[¶](#d-lookup-tables "Permalink to this heading")

在CasADi/Python中可以如下进行1D样条拟合，并与SciPy中的相应方法进行比较：

import casadi as ca
import numpy as np
xgrid \= np.linspace(1,6,6)
V \= \[\-1,\-1,\-2,\-3,0,2\]
lut \= ca.interpolant('LUT','bspline',\[xgrid\],V)
print(lut(2.5))
\# Using SciPy
import scipy.interpolate as ip
interp \= ip.InterpolatedUnivariateSpline(xgrid, V)
print(interp(2.5))

\-1.35
-1.3500000000000005

在MATLAB/Octave中，对应的代码如下：

xgrid \= 1:6;
V \= \[\-1 \-1 \-2 \-3 0 2\];
lut \= casadi.interpolant('LUT','bspline',{xgrid},V);
lut(2.5)
% Using MATLAB/Octave builtin
interp1(xgrid,V,2.5,'spline')

ans =

-1.35

ans = -1.3500

需要特别注意，`interpolant`函数的`grid`和`values`参数必须是数值类型的。

#### 6.5.2. 二维查找表[¶](#id1 "Permalink to this heading")

在二维情况下，我们得到以下Python代码，并与SciPy进行对比参考：

xgrid \= np.linspace(\-5,5,11)
ygrid \= np.linspace(\-4,4,9)
X,Y \= np.meshgrid(xgrid,ygrid,indexing\='ij')
R \= np.sqrt(5\*X\*\*2 + Y\*\*2)+ 1
data \= np.sin(R)/R
data\_flat \= data.ravel(order\='F')
lut \= ca.interpolant('name','bspline',\[xgrid,ygrid\],data\_flat)
print(lut(\[0.5,1\]))
\# Using Scipy

interp \= ip.RectBivariateSpline(xgrid, ygrid, data)
print(interp.ev(0.5,1))

0.245507
0.24550661674668917

或者在MATLAB/Octave中与内置函数进行比较：

xgrid \= \-5:1:5;
ygrid \= \-4:1:4;
\[X,Y\] \= ndgrid(xgrid, ygrid);
R \= sqrt(5\*X.^2 + Y.^2)+ 1;
V \= sin(R)./R;
lut \= interpolant('LUT','bspline',{xgrid, ygrid},V(:));
lut(\[0.5 1\])
% Using Matlab builtin
interpn(X,Y,V,0.5,1,'spline')

ans =

0.245507

ans = 0.2455

需要特别注意，`values`参数必须被展平为一维数组。

### 6.6. 使用有限差分法计算导数[¶](#derivative-calculation-using-finite-differences "Permalink to this heading")

CasADi 3.3 引入了对所有函数对象的有限差分计算支持，特别包括在[6.2节](#sec-callback)、[6.3节](#sec-external)或[6.4节](#sec-jit-function)中定义的外部函数（对于查找表，[6.5节](#sec-lookup)提供了解析导数）。

默认情况下有限差分导数是被禁用的，除了`Function.jit`，要启用它，您必须将选项`'enable_fd'`设置为`True`/`true`:

f \= external('f', './gen.so',\\
   dict(enable\_fd\=True))

e \= jacobian(f(x),x)
D \= Function('d',\[x\],\[e\])
print(D(0))

1

f \= external('f', './gen.so',...
    struct('enable\_fd',true));

e \= jacobian(f(x),x);
D \= Function('d',{x},{e});
disp(D(0))

1

参见[第5.1节](#sec-codegen-syntax)。

`'enable_fd'`选项允许CasADi在解析导数不可用时使用有限差分法。要强制CasADi使用有限差分法，可以将`'enable_forward'`、`'enable_reverse'`和`'enable_jacobian'`设置为`False`/`false`，这些选项对应CasADi处理的三种解析导数类型。

默认方法是中心差分法，其步长由函数的舍入误差和截断误差估计确定。可以通过设置`'fd_method'`选项来更改方法：
- `'forward'`：对应一阶前向差分
- `'backward'`：对应一阶后向差分  
- `'smoothing'`：二阶精确不连续避免方案，适用于需要在域边界计算导数的情况

通过设置`'fd_options'`选项还可以获得有限差分法的其他算法选项。

## 7. `DaeBuilder`类[¶](#the-daebuilder-class "Permalink to this heading")

CasADi中的`DaeBuilder`类是一个辅助类，旨在促进复杂动态系统的建模以及导入导出。与Modelica等物理建模语言相比(参见[第7.4节](#sec-modelica))，该类的抽象级别较低，但仍比直接使用CasADi符号表达式更高。特别是，它可以用于导入或导出使用功能模型接口(FMI)格式定义的物理模型，也可以作为构建领域特定建模环境的基础模块。

自最初创建以来，该类的语法和范围已发生重大变化。下面我们将概述CasADi 3.7中引入的语法。

### 7.1. `DaeBuilder`模型变量及其分类[¶](#daebuilder-model-variables-and-their-categorization "Permalink to this heading")

每个`DaeBuilder`实例都维护一个模型变量列表。变量必须具有唯一名称，并包含变量的元信息，如类型(例如浮点、整数或字符串值)、最小最大值、标称值、维度、描述、单位等。模型变量的格式高度模仿FMI标准3.0版，要高效使用`DaeBuilder`类，您应该对该格式有所了解。与FMI一样，变量根据其_因果关系_和_可变性_进行分类(如果不熟悉这些术语，请参阅FMI规范[\[3\]](#fmi3))。它们还被赋予CasADi特有的分类，分为以下几类：

ttt

独立变量，通常是时间

ccc

常量，使用公式 c = f_{\text{cdef}}(c) 显式计算得出，其中对 ccc 的依赖始终是非循环的

ppp

独立参数

ddd

依赖参数，使用公式 d = f_{\text{ddef}}(p, d; c) 显式计算得出，其中对 ddd 的依赖始终是非循环的

uuu

输入变量

www

依赖变量，使用公式 w = f_{\text{wdef}}(t, p, d, u, w, x, z; c) 显式计算得出，其中对 www 的依赖始终是非循环的

xxx

微分状态，每个都由常微分方程(ODE)定义，公式为 \dot{x} = f_{\text{ode}}(t, p, d, u, w, x, z; c)

qqq

积分状态，即不出现在右侧的微分状态，公式为 \dot{q} = f_{\text{quad}}(t, p, d, u, w, x, z; c)

zzz

代数变量，通过代数方程隐式定义，公式为 0 = f_{\text{alg}}(t, p, d, u, w, x, z; c)

还存在一类_计算_模型变量，它们表示可以使用上述变量计算但不能用作函数输入的不同量。计算模型变量包括输出变量 yyy，通过输出方程 y = f_{\text{y}}(t, p, d, u, w, x, z; c) 显式计算得出。这些量通过相应的模型方程引用，参见下面的[7.2节](#sec-model-equations)。请注意，在上述函数中，对 ccc 的依赖始终是函数定义的参数，即如果 ccc 的值发生变化，则需要定义一个新函数。

变量的类别是根据其因果关系和可变性自动确定的，如下表所示，其中行对应因果关系，列对应可变性(参见FMI规范3.0.2版中的表18)

[\[3\]](#fmi3)):

|     | 参数 | 计算参数<br><br>(calculated parameter) | 输入 | 输出<br><br>(也包含在yyy中) | 局部变量 | 独立变量 |
| --- | --- | --- | --- | --- | --- | --- |
| 常量 | n/a | n/a | n/a | ccc | ccc | n/a |
| 固定值 | ccc | ddd | n/a | n/a | ddd | n/a |
| 可调参数 | ppp | ddd | n/a | n/a | ddd | n/a |
| 离散变量 | n/a | n/a | uuu | xxx 或 qqq | xxx 或 qqq | n/a |
| 连续变量 | n/a | n/a | uuu | xxx, qqq, zzz 或 www | xxx, qqq, zzz 或 www | ttt |

并非所有因果关系和可变性的组合都是允许的，如FMI规范[\[3\]](#fmi3)所述。这些不允许的组合在表中标记为"n/a"。也可能存在多个组合映射到同一变量类别的情况。

连续可变性变量的类别取决于其定义方程，我们将在下面的[7.2节](#sec-model-equations)中讨论。如果定义方程是ODE，变量通常被赋予xxx类别，但如果启用了积分状态检测且该变量未出现在任何其他模型方程的右侧，则也可能属于qqq类别。如果变量本身有定义方程(即出现在方程的左侧)且之前未出现在任何方程中，则成为www的一部分。如果以上都不适用，则变量被赋予zzz类别，并假设由残差方程隐式定义。具有离散可变性的变量(包括整型/布尔型变量)被视为具有平凡ODE定义的连续变量，即˙x\=0x˙\=0\\dot{x} = 0或˙q\=0q˙\=0\\dot{q} = 0。当用户按照[7.8节](#sec-daebuilder-factory)所述生成计算ODE右侧的函数后，可以轻松检测到这种结构(例如通过查找雅可比矩阵中只有结构零的行)。

具有输出因果关系的变量集合也定义了计算模型输出yyy及其关联的输出方程。

变量的类别可能在符号构造过程中发生变化(参见[7.3节](#sec-daebuilder-symbolic))，特别是在添加方程时。当允许此类操作时，也可以通过显式更改变量的可变性或因果关系来改变类别。当连续模型变量在模型方程中以微分形式出现时，其类别也会从zzz变为xxx。

### 7.2. `DaeBuilder`模型方程[¶](#daebuilder-model-equations "Permalink to this heading")

在撰写本文时，`DaeBuilder`实例支持以下类型的方程(为简化起见省略了ccc、ddd和www):

> *   常微分方程(ODE)，例如: ˙x\=fode(t,x,z,u,p)x˙\=fode(t,x,z,u,p)\\dot{x} = f\_{\\text{ode}}(t,x,z,u,p)
>     
> *   输出方程，例如: y\=fy(t,x,z,u,p)y\=fy(t,x,z,u,p)y = f\_{\\text{y}}(t,x,z,u,p)
>     
> *   代数方程，例如: 0\=falg(t,x,z,u,p)0\=falg(t,x,z,u,p)0 = f\_{\\text{alg}}(t,x,z,u,p)
>     
> *   积分方程，例如: ˙q\=fquad(t,x,z,u,p)q˙\=fquad(t,x,z,u,p)\\dot{q} = f\_{\\text{quad}}(t,x,z,u,p)
>     
> *   事件方程(when equation)，例如: when fzero(t,x,z,u,p)<0fzero(t,x,z,u,p)<0f\_\\text{zero}(t,x,z,u,p) < 0 then x:\=ftransition(t,x,z,u,p)x:=ftransition(t,x,z,u,p)x := f\_\\text{transition}(t,x,z,u,p)
>     

未来版本的`DaeBuilder`可能会支持更多类型的方程，特别是与正确处理初始方程和其他类型事件相关的方程，这些将遵循Modelica标准[\[4\]](#modelica36)。

上述列表中的函数除了与[7.1节](#sec-model-variables)列出的类别相关联外，还与额外的内部变量类别相关联。例如，常微分方程和积分方程与导数变量相关联，代数方程与残差变量相关联。事件方程与过零条件和一组赋值操作相关联。我们将在[7.6节](#sec-hybrid)中进一步讨论事件方程。

模型方程可以作为符号表达式给出(如[7.3节](#sec-daebuilder-symbolic)所述)，也可以从Modelica源代码(如[7.4节](#sec-modelica)所述)或通过标准功能模型单元(FMU)共享库(如[7.5节](#sec-fmi)所述)给出。

### 7.3. 符号化构建`DaeBuilder`实例[¶](#constructing-a-daebuilder-instance-symbolically "Permalink to this heading")

我们可以使用CasADi符号表达式来创建`DaeBuilder`实例。当前的目标是支持一种非因果模型方法，该方法结合了功能模型接口(FMI)标准和拟议的Base Modelica标准[\[5\]](#basemodelica)的元素。具体来说，模型变量(参见[7.1节](#sec-model-variables))使用FMI 3.0版标准定义的约定，而模型方程(参见[7.2节](#sec-model-equations))则尝试遵循Base Modelica标准，这与标准FMI依赖黑盒C API的做法不同。我们将在[7.4节](#sec-modelica)讨论如何利用这一支持来实现对实际Modelica公式化模型的符号化导入。

为了说明用法，考虑以下简单的微分代数方程(DAE)，描述了一个受控火箭在二次空气摩擦力和重力作用下的运动，该火箭会随着燃料消耗而损失质量：

˙h\=v,h(0)\=0˙v\=(u−av2)/m−g,v(0)\=0˙m\=−bu2,m(0)\=1h˙\=v,h(0)\=0v˙\=(u−av2)/m−g,v(0)\=0m˙\=−bu2,m(0)\=1\\begin{split}\\begin{aligned} \\dot{h} &= v, \\qquad &h(0) = 0 \\\\ \\dot{v} &= (u - a \\, v^2)/m - g, \\qquad &v(0) = 0 \\\\ \\dot{m} &= -b \\, u^2, \\qquad &m(0) = 1 \\end{aligned}\\end{split}

其中三个状态变量分别对应高度、速度和质量。uuu表示火箭推力，(a,b)(a,b)(a,b)是参数。

要为这个问题构建DAE公式，可以从一个空的`DaeBuilder`实例开始，然后逐步添加模型变量(包括任何元信息)和模型方程，具体步骤如下。

dae \= DaeBuilder('rocket')
\# Add model variables
a \= dae.add('a', 'parameter', 'tunable')
b \= dae.add('b', 'parameter', 'tunable')
u \= dae.add('u', 'input')
h \= dae.add('h', dict(start\=0))
v \= dae.add('v', dict(start\=0))
m \= dae.add('m', dict(start\=1))
\# Change some meta information
dae.set\_unit('h', 'm')
dae.set\_unit('v', 'm/s')
dae.set\_unit('m', 'kg')
\# Add model equations
dae.eq(dae.der(h), v)
dae.eq(dae.der(v), (u\-a\*v\*\*2)/m\-9.81)
dae.eq(dae.der(m), \-b\*u\*\*2)

dae \= DaeBuilder('rocket')
% Add model variables
a \= dae.add('a', 'parameter', 'tunable');
b \= dae.add('b', 'parameter', 'tunable');
u \= dae.add('u', 'input');
h \= dae.add('h', struct('start', 0));
v \= dae.add('v', struct('start', 0));
m \= dae.add('m', struct('start', 1));
% Change some meta information
dae.set\_unit('h','m');
dae.set\_unit('v','m/s');
dae.set\_unit('m','kg');
% Add model equations
dae.eq(dae.der(h), v);
dae.eq(dae.der(v), (u\-a\*v^2)/m\-9.81);
dae.eq(dae.der(m), \-b\*u^2);

dae =

nx = 0, nz = 0, nq = 0, ny = 0, np = 0, nc = 0, nd = 0, nw = 0, nu = 0

其他输入和输出表达式可以类似的方式添加。完整函数列表请参阅`DaeBuilder`的C++ API文档。

在下面的[7.8节](#sec-daebuilder-factory)中，我们将展示如何评估模型方程，这与通过其他方式(例如从FMU)创建方程时的评估方式是相同的，参见[7.5节](#sec-fmi)。

### 7.4. 从Modelica符号化创建`DaeBuilder`实例[¶](#creating-a-daebuilder-instance-from-modelica-symbolically "Permalink to this heading")

`DaeBuilder`类的原始目标是支持从Modelica公式化模型进行符号化导入。这是通过支持"FMUX"格式的导入模型实现的，FMUX是从FMI 1.0派生的XML格式。在此格式中，模型变量(参见[7.1节](#sec-model-variables))使用标准FMI 1.0 XML语法定义，而模型方程(参见[7.2节](#sec-model-equations))则在同一XML中提供，而不是标准定义的C API。CasADi中对FMUX导入的支持从未达到成熟状态，部分原因是使用现有Modelica工具生成FMUX文件的方法从未成熟。虽然最初由JModelica.org工具支持，但后来被放弃，转而采用更紧密的基于SWIG的CasADi接口。FMUX导出也已在OpenModelica编译器中实现。

`DaeBuilder`类中仍然保留了对FMUX导入的遗留支持，但由于它没有被积极维护且非常不完整，对于非平凡模型可能需要深入研究C++源代码才能使其工作。

我们还注意到JModelica.org的闭源后继代码OCT确实保留了CasADi互操作性。关于如何使用OCT生成CasADi表达式的细节最好参考OCT的用户指南。截至本文撰写时，此支持并未使用CasADi中的DaeBuilder类，尽管可以使用[7.3节](#sec-daebuilder-symbolic)中描述的标准符号API从OCT生成的CasADi表达式创建DaeBuilder实例。

在CasADi的未来版本中，我们希望基于新兴的Base Modelica标准提供更成熟的Modelica模型符号化导入支持。Base Modelica

[\[5\]](#basemodelica)旨在成为完整Modelica语言的子集，可以从任何Modelica模型生成，但去除了许多与面向对象物理建模相关的高级特性。

与之前的符号化导入尝试不同，此支持还将包括对混合(事件驱动)建模的支持，同时仍保留基于梯度优化算法所需的可微性。具体来说，我们试图确保用于触发事件的过零函数是可微的，其次状态转换也作为可微函数提供。CasADi的Base Modelica工作目前不包含Modelica解析器，而是与开源的Rumoca

[\[6\]](#rumoca)转换器合作，该转换器可用于将Base Modelica源代码转换为Python脚本，从而符号化地构建DaeBuilder实例。

### 7.5. 从FMU构建`DaeBuilder`实例[¶](#constructing-a-daebuilder-instance-from-an-fmu "Permalink to this heading")

DaeBuilder类可用于导入符合FMI 2.0或3.0版标准的FMU

[\[2\]](#casadi-fmi)。这是CasADi专用的原生外部函数接口(FFI)，直接与FMI C API通信。评估在[7.8节](#sec-daebuilder-factory)描述的函数工厂创建的CasADi函数对象中进行。重要的是，二进制FMI接口能够使用混合符号-数值方法高效计算模型方程的一阶和二阶导数，其中一阶导数依赖解析导数，二阶导数使用高效的有限差分实现。只要可能，也会利用稀疏性和并行化。

并非所有模型交换FMU都适合导入CasADi，尽管我们希望逐步支持越来越多的标准部分。通常，对于导数计算，FMU应支持解析导数。虽然CasADi确实支持使用有限差分计算一阶导数，但这主要应被视为调试和诊断功能。

事件驱动动力学(参见[7.6节](#sec-hybrid))尚未在标准FMU中演示，可能需要一些手动重构，例如将过零函数和事件转换明确定义为额外输出。在[7.8节](#sec-daebuilder-factory)中，我们将讨论如何数值评估模型方程。

### 7.6. 使用`DaeBuilder`进行混合建模[¶](#hybrid-modeling-with-daebuilder "Permalink to this heading")

CasADi 3.7 版本首次引入了对混合建模和敏感性分析的初步支持。在`DaeBuilder`中，状态事件可以通过when方程来表述，这与(Base) Modelica中的语法保持一致[\[4\]](#modelica36)。每当添加一个when方程时，系统会自动创建一个微分过零条件，其形式与CasADi积分器类的扩展兼容，从而实现对混合系统的自动敏感性分析。虽然事件支持仍处于早期阶段，但它已成功用于建模简单的混合系统，例如下面这个弹跳球的例子：

dae \= DaeBuilder('bouncing\_ball')
\# Add model variables
h \= dae.add('h', dict(start\=5))
v \= dae.add('v', dict(start\=0))
\# Add model equations
dae.eq(dae.der(h), v)
dae.eq(dae.der(v), \-9.81)
dae.when(h < 0, \\
  \[dae.reinit('v', \-0.8\*dae.pre(v))\])

CasADi - 2025-03-29 19:11:19 WARNING("DaeBuilder::pre has not been implemented: Returning identity mapping") \[.../casadi/core/dae\_builder.cpp:769\]

dae \= DaeBuilder('bouncing\_ball')
% Add model variables
h \= dae.add('h', struct('start', 5));
v \= dae.add('v', struct('start', 0));
% Add model equations
dae.eq(dae.der(h), v);
dae.eq(dae.der(v), \-9.81);
dae.when(h < 0, ...
  {dae.reinit('v', \-0.8\*dae.pre(v))});

dae =

nx = 0, nz = 0, nq = 0, ny = 0, np = 0, nc = 0, nd = 0, nw = 0, nu = 0

CasADi - 2025-03-29 19:11:36 WARNING("DaeBuilder::pre has not been implemented: Returning identity mapping") \[.../casadi/core/dae\_builder.cpp:769\]

有关CasADi中混合支持的更多信息，我们参考实现论文：

[\[1\]](#casadi-hybrid).

### 7.7. 模型重构[¶](#reformulating-a-model "Permalink to this heading")

`DaeBuilder`类的实例是可变的，在创建后可以有限制地改变其公式化表达。特别是可以改变变量的因果关系(causality)或可变性(variability)，只要这种改变在当前模型方程集合下是可能的。具体来说，可以通过将输出变量yyy的因果关系改为local来移除它。输入变量uuu可以通过将其可变性分别改为tunable或fixed来视为参数ppp或常量ccc（在这种情况下因果关系将自动更新为"parameter"）。此外，始终可以任意方式重新排列类别中的变量——默认情况下类别内的排序将与模型变量的排序匹配。

如果`DaeBuilder`实例是符号化创建的（而不是从标准FMU创建的），则可以进行额外的操作，如消除依赖变量、BLT重排序、索引约简等。其中一些功能尚未积极维护或持续测试，但可能通过有限的C++源代码工作重新启用。

### 7.8. 模型方程评估，函数工厂[¶](#evaluating-model-equations-function-factory "Permalink to this heading")

`DaeBuilder`实例中模型方程的评估遵循与FMPy或PyFMI等其他能评估FMU的工具略有不同的范式。通常，我们只使用setter(`DaeBuilder.set`)来设置常量(ccc)或其他变量的_初始_/_默认_值。对于评估，`DaeBuilder`依赖于_function factory_，用户通过提供函数名称以及输入列表和输出列表来创建可微的CasADi函数对象。以下示例展示如何创建一个名为`f`的函数，具有三个(向量值)输入xxx、uuu和ppp，以及一个(向量值)输出fodefodef\_{\\text{ode}}:

f \= dae.create('f',\['x','u','p'\],\['ode'\])

f \= dae.create('f',{'x','u','p'},{'ode'});

类似地，我们可以创建一个名为`h`的输出函数如下：

h \= dae.create('h',\['x','u','p'\],\['y'\])

h \= dae.create('h',{'x','u','p'},{'y'});

输入和输出的名称分别对应[7.1节](#sec-model-variables)和[7.2节](#sec-model-equations)中概述的类别。如前所述，常量(ccc)永远不允许作为输入或输出。依赖参数(ddd)和依赖变量(www)可以_选择_作为输入或输出（但不能同时作为两者）。如果它们不在输入中（无论是否定义为输出），在函数构建过程中它们将被从表达式中替换掉。输出变量(yyy)和其他纯依赖变量只能作为输出。在创建过程中，函数工厂会保存(mutable)`DaeBuilder`实例的当前状态，创建的函数不会受到后续对`DaeBuilder`实例的任何修改甚至删除的影响。因此创建的函数是不可变的（极少数例外情况），与CasADi中所有其他函数类似。

我们还可以使用CasADi的导数函数命名约定，在函数输出中包含例如雅可比矩阵块。以下示例创建了一个名为`J`的函数，具有三个（向量值）输入xxx、uuu和ppp，以及一个（矩阵值）输出，对应于fodefodef\_{\\text{ode}}关于xxx的雅可比矩阵：

J \= dae.create('J',\\
     \['x','u','p'\], \['jac\_ode\_x'\])

J \= dae.create('J',...
     {'x','u','p'} {'jac\_ode\_x'});

我们参考fmu\_demo.ipynb笔记本获取更多关于如何使用函数工厂的示例，包括如何在评估过程中定义和获取（不可微的）辅助输出。

脚注

\[[1](#id10)\]

Joel Andersson, James Goppert, [CasADi中用于Modelica和FMI的仿真和灵敏度分析的事件支持](https://doi.org/10.3384/ecp20799) , 美国Modelica会议论文集 2024, 斯托尔斯, 康涅狄格州, 美国, 2024年10月14-16日

\[[2](#id8)\]

Joel Andersson, [CasADi中功能模型单元的导入与导出](https://doi.org/10.3384/ecp204321) , 第15届国际Modelica会议论文集 2023, 亚琛, 2023年10月9-11日

\[3\] ([1](#id1),[2](#id2),[3](#id3))

Modelica协会, [功能模型接口规范, 3.0.2版](https://fmi-standard.org/docs/3.0.2/)

\[4\] ([1](#id4),[2](#id9))

Modelica协会, [Modelica(R) - 系统建模的统一面向对象语言规范, 3.6版](https://specification.modelica.org/maint/3.6/)

\[5\] ([1](#id5),[2](#id6))

Peter Harman, Werther Kai, Gerd Kurzbach, Oliver Lenord, Hans Olsson, Michael Schellenberger, Martin Sjölund, Henrik Tidefelt, [Modelica变更提案 MCP-0031 基础Modelica和MLS模块化](https://github.com/modelica/ModelicaSpecification/tree/MCP/0031/RationaleMCP/0031)

\[[6](#id7)\]

[https://github.com/CogniPilot/rumoca\_parser](https://github.com/CogniPilot/rumoca_parser)

\[[1](#id10)\]

Joel Andersson, James Goppert, [Event Support for Simulation and Sensitivity Analysis in CasADi for use with Modelica and FMI](https://doi.org/10.3384/ecp20799) , Proceedings of the American Modelica Conference 2024, Storrs, Connecticut, USA, October 14-16, 2024

\[[2](#id8)\]

Joel Andersson, [Import and Export of Functional Mockup Units in CasADi](https://doi.org/10.3384/ecp204321) , Proceedings of the 15th International Modelica Conference 2023, Aachen, October 9-11

\[3\] ([1](#id1),[2](#id2),[3](#id3))

Modelica Association, [Functional Mock-up Interface Specification, version 3.0.2](https://fmi-standard.org/docs/3.0.2/)

\[4\] ([1](#id4),[2](#id9))

Modelica Association, [Modelica(R) - A Unified Object-Oriented Language for Systems Modeling Language Specification, Version 3.6](https://specification.modelica.org/maint/3.6/)

\[5\] ([1](#id5),[2](#id6))

Peter Harman, Werther Kai, Gerd Kurzbach, Oliver Lenord, Hans Olsson, Michael Schellenberger, Martin Sjölund, Henrik Tidefelt, [Modelica Change Proposal MCP-0031 Base Modelica and MLS modularization](https://github.com/modelica/ModelicaSpecification/tree/MCP/0031/RationaleMCP/0031)

\[[6](#id7)\]

[https://github.com/CogniPilot/rumoca\_parser](https://github.com/CogniPilot/rumoca_parser)

## 8\. Optimal control with CasADi[¶](#optimal-control-with-casadi "Permalink to this heading")

CasADi can be used to solve _optimal control problems_ (OCP) using a variety of methods, including direct (a.k.a. _discretize-then-optimize_) and indirect (a.k.a. _optimize-then-discretize_) methods, all-at-once (e.g. collocation) methods and shooting-methods requiring embedded solvers of initial value problems in ODE or DAE. As a user, you are in general expected to _write your own OCP solver_ and CasADi aims as making this as easy as possible by providing powerful high-level building blocks. Since you are writing the solver yourself (rather than calling an existing “black-box” solver), a basic understanding of how to solve OCPs is indispensable. Good, self-contained introductions to numerical optimal control can be found in the recent textbooks by Biegler

[\[1\]](#f4) or Betts

[\[2\]](#f5) or Moritz Diehl’s [lecture notes on numerical optimal control](https://www.syscop.de/files/2015ws/numopt/numopt_0.pdf).

### 8.1. A simple test problem[¶](#a-simple-test-problem "Permalink to this heading")

To illustrate some of the methods, we will consider the following test problem, namely driving a _Van der Pol_ oscillator to the origin, while trying to minimize a quadratic cost:

(8.1.1)[¶](#equation-vdp "Permalink to this equation")minimize:x(⋅)∈R2,u(⋅)∈R∫Tt\=0(x20+x21+u2)dtsubject to:⎧⎪⎨⎪⎩˙x0\=(1−x21)x0−x1+u˙x1\=x0−1.0≤u≤1.0,x1≥−0.25for0≤t≤Tx0(0)\=0,x1(0)\=1,minimize:x(⋅)∈R2,u(⋅)∈R∫t\=0T(x02+x12+u2)dtsubject to:{x˙0\=(1−x12)x0−x1+ux˙1\=x0−1.0≤u≤1.0,x1≥−0.25for0≤t≤Tx0(0)\=0,x1(0)\=1,\\begin{split}\\begin{array}{lc} \\begin{array}{l} \\text{minimize:} \\\\ x(\\cdot) \\in \\mathbb{R}^2, \\, u(\\cdot) \\in \\mathbb{R} \\end{array} \\quad \\displaystyle \\int\_{t=0}^{T}{(x\_0^2 + x\_1^2 + u^2) \\, dt} \\\\ \\\\ \\text{subject to:} \\\\ \\\\ \\begin{array}{ll} \\left\\{ \\begin{array}{l} \\dot{x}\_0 = (1-x\_1^2) \\, x\_0 - x\_1 + u \\\\ \\dot{x}\_1 = x\_0 \\\\ -1.0 \\le u \\le 1.0, \\quad x\_1 \\ge -0.25 \\end{array} \\right. & \\text{for} \\, 0 \\le t \\le T \\\\ x\_0(0)=0, \\quad x\_1(0)=1, \\end{array} \\end{array}\\end{split}

with T\=10T\=10T=10.

In CasADi’s examples collection

[\[3\]](#f6), you find codes for solving optimal control problems using a variety of different methods.

In the following, we will discuss three of the most important methods, namely _direct single shooting_, _direct multiple shooting_ and _direct collocation_.

#### 8.1.1. Direct single-shooting[¶](#direct-single-shooting "Permalink to this heading")

In the direct single shooting method, the control trajectory is parameterized using some piecewise smooth approximation, typically piecewise constant.

Using an explicit expression for the controls, we can then eliminate the whole state trajectory from the optimization problem, ending up with an NLP in only the discretized controls.

In CasADi’s examples collection, you will find the codes `direct_single_shooting.py` and `direct_single_shooting.m` for Python and MATLAB/Octave, respectively. These codes implement the direct single shooting method and solves it with IPOPT, relying on CasADi to calculate derivatives. To obtain the discrete time dynamics from the continuous time dynamics, a simple fixed-step Runge-Kutta 4 (RK4) integrator is implemented using CasADi symbolics. Simple integrator codes like these are often useful in the context of optimal control, but care must be taken so that they accurately solve the initial-value problem.

The code also shows how the RK4 scheme can be replaced by a more advanced integrator, namely the CVODES integrator from the SUNDIALS suite, which implements a variable stepsize, variable order backward differentiation formula (BDF) scheme. An advanced integrator like this is useful for larger systems, systems with stiff dynamics, for DAEs and for checking a simpler scheme for consistency.

#### 8.1.2. Direct multiple-shooting[¶](#direct-multiple-shooting "Permalink to this heading")

The `direct_multiple_shooting.py` and `direct_multiple_shooting.m` codes, also in CasADi’s examples collection, implement the direct multiple shooting method. This is very similar to the direct single shooting method, but includes the state at certain _shooting nodes_ as decision variables in the NLP and includes equality constraints to ensure continuity of the trajectory.

The direct multiple shooting method is often superior to the direct single shooting method, since “lifting” the problem to a higher dimension is known to often improve convergence. The user is also able to initialize with a known guess for the state trajectory.

The drawback is that the NLP solved gets much larger, although this is often compensated by the fact that it is also much sparser.

#### 8.1.3. Direct collocation[¶](#direct-collocation "Permalink to this heading")

Finally, the `direct_collocation.py` and `direct_collocation.m` codes implement the direct collocation method. In this case, a parameterization of the entire state trajectory, as piecewise low-order polynomials, are included as decision variables in the NLP. This removes the need for the formulation of the discrete time dynamics completely.

The NLP in direct collocation is even larger than that in direct multiple shooting, but is also even sparser.

Footnotes

\[[1](#id1)\]

Lorenz T. Biegler, [Nonlinear Programming: Concepts, Algorithms, and Applications to Chemical Processes](http://books.google.es/books/about/Nonlinear_Programming.html?id=VdB1wJQu0sgC&redir_esc=y) , SIAM 2010

\[[2](#id2)\]

John T. Betts, [Practical Methods for Optimal Control Using Nonlinear Programming](http://books.google.es/books/about/Practical_Methods_for_Optimal_Control_Us.html?id=Yn53JcYAeaoC&redir_esc=y) , SIAM 2001

\[[3](#id3)\]

You can obtain this collection as an archive named `examples_pack.zip` in CasADi’s [download area](http://files.casadi.org)

## 9\. Opti stack[¶](#opti-stack "Permalink to this heading")

The Opti stack is a collection of CasADi helper classes that provides a close correspondence between mathematical NLP notation, e.g.

(9.1)[¶](#equation-simple-nlp "Permalink to this equation")minimizex,y(y−x2)2subject tox2+y2\=1x+y≥1,minimizex,y(y−x2)2subject tox2+y2\=1x+y≥1,\\begin{split} \\begin{array}{cc} \\begin{array}{c} \\text{minimize} \\\\ x,y \\end{array} & (y-x^2)^2 \\\\ \\begin{array}{c} \\text{subject to} \\end{array} & x^2+y^2=1 \\\\ & x+y \\ge 1, \\end{array}\\end{split}

and computer code:

opti \= casadi.Opti()

x \= opti.variable()
y \= opti.variable()

opti.minimize(  (y\-x\*\*2)\*\*2   )
opti.subject\_to( x\*\*2+y\*\*2\==1 )
opti.subject\_to(       x+y\>=1 )

opti.solver('ipopt')

sol \= opti.solve()

print(sol.value(x))
print(sol.value(y))

0.7861513776531158
0.6180339888825889

opti \= casadi.Opti();

x \= opti.variable();
y \= opti.variable();

opti.minimize(  (y\-x^2)^2   );
opti.subject\_to( x^2+y^2\==1 );
opti.subject\_to(     x+y\>\=1 );

opti.solver('ipopt');

sol \= opti.solve();

sol.value(x)
sol.value(y)

ans = 0.7862
ans = 0.6180

The main characteristics of the Opti stack are:

*   Allows _natural_ syntax for constraints.
    
*   Indexing/bookkeeping of decision variables is hidden.
    
*   Closer mapping of numerical data-type to the host language: no encounter with `DM`.
    

By default, Opti will assume a nonlinear program. To solve quadratic programs, supply the string ‘conic’ as argument to the Opti constructor.

Note that Opti is designed to be user-friendly and there is quite some overhead with respect to using[](#id1)

[|nlpsol|](#id1). However, there is a[

|to\_function|](#id3) method (documented below) that eliminates the bulk of that overhead.

### 9.1. Problem specification[¶](#problem-specification "Permalink to this heading")

**Variables**: Declare any amount of decision variables:

*   `x = opti.variable()`: scalar
    
*   `x = opti.variable(5)`: column vector
    
*   `x = opti.variable(5,3)`: matrix
    
*   `x = opti.variable(5,5,'symmetric')`: symmetric matrix
    

The order in which you declare the variables is respected by the solver. Note that the variables are in fact plain MX symbols. You may perform any CasADi MX operations on them, e.g. embedding integrator calls.

**Parameters**: Declare any amount of parameters. You must fix them to a specific numerical value before solving, and you may overwrite this value at any time.

p \= opti.parameter()
opti.set\_value(p, 3)

p \= opti.parameter();
opti.set\_value(p, 3)

**Objective**: Declare an objective using an expression that may involve all variables or parameters. Calling the command again discards the old objective.

opti.minimize(   sin(x\*(y\-p))   )

opti.minimize(   sin(x\*(y\-p))   )

**Constraints**: Declare any amount of equality/inequality constraints:

*   `opti.subject_to( sqrt(x+y) >= 1)`: inequality
    
*   `opti.subject_to( sqrt(x+y) > 1)`: same as above
    
*   `opti.subject_to( 1<= sqrt(x+y) )`: same as above
    
*   `opti.subject_to( 5*x+y==1 )`: equality
    

You may also throw in several constraints at once:

opti.subject\_to(\[x\*y\>=1,x\==3\])

opti.subject\_to({x\*y\>\=1,x\==3});

You may declare double inequalities:

opti.subject\_to( opti.bounded(0,x,1) )

opti.subject\_to( 0<\=x<\=1 );

When the bounds of the double inequalities are free of variables, the constraint will be passed on efficiently to solvers that support them (notably IPOPT).

You may make element-wise (in)equalities with vectors:

x \= opti.variable(5,1)

opti.subject\_to( x\*p<=3 )

x \= opti.variable(5,1);

opti.subject\_to( x\*p<\=3 )

Elementwise (in)equalities for matrices are not supported with a natural syntax, since there is an ambiguity with semi-definiteness constraints. The workaround is to vectorize first:

A \= opti.variable(5,5)
opti.subject\_to( vec(A)<=3 )

A \= opti.variable(5,5);
opti.subject\_to( A(:)<\=3 );

Each `subject_to` command adds to the set of constraints in the problem specification. Use `subject_to()` to empty this set and start over.

**Solver**: You must always declare the `solver` (numerical back-end). An optional dictionary of CasADi plugin options can be given as second argument. An optional dictionary of `solver` options can be given as third argument.

p\_opts \= {"expand":True}
s\_opts \= {"max\_iter": 100}
opti.solver("ipopt",p\_opts,
                    s\_opts)

p\_opts \= struct('expand',true);
s\_opts \= struct('max\_iter',100);
opti.solver('ipopt',p\_opts,
                    s\_opts);

**Initial guess**: You may provide initial guesses for decision variables (or simple mappings of decision variables). When no initial guess is provided, numerical zero is assumed.

opti.set\_initial(x, 2)
opti.set\_initial(10\*x\[0\], 2)

opti.set\_initial(x, 2);
opti.set\_initial(10\*x(1), 2)

### 9.2. Problem solving and retrieving[¶](#problem-solving-and-retrieving "Permalink to this heading")

#### 9.2.1. Solving[¶](#solving "Permalink to this heading")

After setting up the problem, you may call the solve method, which constructs a CasADi `nlpsol` and calls it.

sol \= opti.solve()

This is Ipopt version 3.14.11, running with linear solver MUMPS 5.4.1.

Number of nonzeros in equality constraint Jacobian...:        2
Number of nonzeros in inequality constraint Jacobian.:        2
Number of nonzeros in Lagrangian Hessian.............:        3

Total number of variables............................:        2
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:        1
Total number of inequality constraints...............:        1
        inequality constraints with only lower bounds:        1
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        0

iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
   0  0.0000000e+00 1.00e+00 1.00e+00  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1  1.5180703e+00 2.32e-01 3.95e+08  -1.0 1.11e+00    -  9.90e-01 1.00e+00h  1
   2  9.1720733e-01 1.38e-02 8.65e+08  -1.0 1.05e-01  10.0 1.00e+00 1.00e+00f  1
   3  8.9187743e-01 4.67e-05 9.29e+06  -1.0 7.19e-03    -  1.00e+00 1.00e+00h  1
   4  8.9179090e-01 5.46e-10 2.17e+02  -1.0 2.42e-05    -  1.00e+00 1.00e+00h  1
   5  8.5961118e-01 2.43e-04 3.39e+00  -1.0 1.56e-02    -  1.00e+00 1.00e+00f  1
   6  5.0768568e-01 3.58e-02 2.18e+00  -1.0 1.89e-01    -  3.86e-01 1.00e+00f  1
   7  4.4751644e-01 4.12e-04 6.30e+07  -1.0 1.96e-02   9.5 1.00e+00 1.00e+00h  1
   8  4.4707538e-01 4.25e-08 2.27e+04  -1.0 2.53e-04    -  1.00e+00 1.00e+00h  1
   9  4.4688522e-01 9.34e-09 2.20e+00  -1.0 9.32e-05    -  1.00e+00 1.00e+00h  1
iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
  10  2.9995484e-02 3.46e-01 1.19e+00  -1.0 5.68e-01    -  5.45e-01 1.00e+00f  1
  11  3.9964883e-04 3.56e-02 5.81e-02  -1.0 2.09e-01    -  1.00e+00 1.00e+00h  1
  12  3.7581923e-06 5.63e-04 5.70e-03  -2.5 2.69e-02    -  1.00e+00 1.00e+00h  1
  13  7.6573980e-10 1.48e-06 3.13e-05  -3.8 1.11e-03    -  1.00e+00 1.00e+00h  1
  14  4.8778322e-14 2.53e-10 7.52e-09  -5.7 1.29e-05    -  1.00e+00 1.00e+00h  1
  15  8.8029044e-20 1.60e-14 6.47e-13  -8.6 9.88e-08    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 15

                                   (scaled)                 (unscaled)
Objective...............:   8.8029044107981477e-20    8.8029044107981477e-20
Dual infeasibility......:   6.4749359014643689e-13    6.4749359014643689e-13
Constraint violation....:   1.5987211554602254e-14    1.5987211554602254e-14
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   2.5060006300485104e-09    2.5060006300485104e-09
Overall NLP error.......:   2.5060006300485104e-09    2.5060006300485104e-09


Number of objective function evaluations             = 16
Number of objective gradient evaluations             = 16
Number of equality constraint evaluations            = 16
Number of inequality constraint evaluations          = 16
Number of equality constraint Jacobian evaluations   = 16
Number of inequality constraint Jacobian evaluations = 16
Number of Lagrangian Hessian evaluations             = 15
Total seconds in IPOPT                               = 0.010

EXIT: Optimal Solution Found.
      solver  :   t\_proc      (avg)   t\_wall      (avg)    n\_eval
       nlp\_f  | 131.00us (  8.19us)  31.66us (  1.98us)        16
       nlp\_g  | 279.00us ( 17.44us)  65.42us (  4.09us)        16
  nlp\_grad\_f  | 184.00us ( 10.82us)  43.27us (  2.55us)        17
  nlp\_hess\_l  | 245.00us ( 16.33us)  60.65us (  4.04us)        15
   nlp\_jac\_g  | 231.00us ( 13.59us)  56.08us (  3.30us)        17
       total  |  41.88ms ( 41.88ms)  10.50ms ( 10.50ms)         1

sol \= opti.solve();

This is Ipopt version 3.14.11, running with linear solver MUMPS 5.4.1.

Number of nonzeros in equality constraint Jacobian...:        2
Number of nonzeros in inequality constraint Jacobian.:        2
Number of nonzeros in Lagrangian Hessian.............:        3

Total number of variables............................:        2
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:        1
Total number of inequality constraints...............:        1
        inequality constraints with only lower bounds:        1
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        0

iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
   0  0.0000000e+00 1.00e+00 1.00e+00  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1  1.5180703e+00 2.32e-01 3.95e+08  -1.0 1.11e+00    -  9.90e-01 1.00e+00h  1
   2  9.1720733e-01 1.38e-02 8.65e+08  -1.0 1.05e-01  10.0 1.00e+00 1.00e+00f  1
   3  8.9187743e-01 4.67e-05 9.29e+06  -1.0 7.19e-03    -  1.00e+00 1.00e+00h  1
   4  8.9179090e-01 5.46e-10 2.17e+02  -1.0 2.42e-05    -  1.00e+00 1.00e+00h  1
   5  8.5961118e-01 2.43e-04 3.39e+00  -1.0 1.56e-02    -  1.00e+00 1.00e+00f  1
   6  5.0768568e-01 3.58e-02 2.18e+00  -1.0 1.89e-01    -  3.86e-01 1.00e+00f  1
   7  4.4751644e-01 4.12e-04 6.30e+07  -1.0 1.96e-02   9.5 1.00e+00 1.00e+00h  1
   8  4.4707538e-01 4.25e-08 2.27e+04  -1.0 2.53e-04    -  1.00e+00 1.00e+00h  1
   9  4.4688522e-01 9.34e-09 2.20e+00  -1.0 9.32e-05    -  1.00e+00 1.00e+00h  1
iter    objective    inf\_pr   inf\_du lg(mu)  ||d||  lg(rg) alpha\_du alpha\_pr  ls
  10  2.9995484e-02 3.46e-01 1.19e+00  -1.0 5.68e-01    -  5.45e-01 1.00e+00f  1
  11  3.9964883e-04 3.56e-02 5.81e-02  -1.0 2.09e-01    -  1.00e+00 1.00e+00h  1
  12  3.7581923e-06 5.63e-04 5.70e-03  -2.5 2.69e-02    -  1.00e+00 1.00e+00h  1
  13  7.6573980e-10 1.48e-06 3.13e-05  -3.8 1.11e-03    -  1.00e+00 1.00e+00h  1
  14  4.8778322e-14 2.53e-10 7.52e-09  -5.7 1.29e-05    -  1.00e+00 1.00e+00h  1
  15  8.8029044e-20 1.60e-14 6.47e-13  -8.6 9.88e-08    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 15

                                   (scaled)                 (unscaled)
Objective...............:   8.8029044107981477e-20    8.8029044107981477e-20
Dual infeasibility......:   6.4749359014643689e-13    6.4749359014643689e-13
Constraint violation....:   1.5987211554602254e-14    1.5987211554602254e-14
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   2.5060006300485104e-09    2.5060006300485104e-09
Overall NLP error.......:   2.5060006300485104e-09    2.5060006300485104e-09


Number of objective function evaluations             = 16
Number of objective gradient evaluations             = 16
Number of equality constraint evaluations            = 16
Number of inequality constraint evaluations          = 16
Number of equality constraint Jacobian evaluations   = 16
Number of inequality constraint Jacobian evaluations = 16
Number of Lagrangian Hessian evaluations             = 15
Total seconds in IPOPT                               = 0.011

EXIT: Optimal Solution Found.
      solver  :   t\_proc      (avg)   t\_wall      (avg)    n\_eval
       nlp\_f  | 132.00us (  8.25us)  32.90us (  2.06us)        16
       nlp\_g  | 350.00us ( 21.88us)  84.42us (  5.28us)        16
  nlp\_grad\_f  | 189.00us ( 11.12us)  45.44us (  2.67us)        17
  nlp\_hess\_l  | 286.00us ( 19.07us)  71.64us (  4.78us)        15
   nlp\_jac\_g  | 247.00us ( 14.53us)  60.74us (  3.57us)        17
       total  |  45.26ms ( 45.26ms)  11.42ms ( 11.42ms)         1

The call will fail with an error if the solver fails to convergence. You may still inspect the non-converged solution (see [Section 9.3](#sec-opti-extra)).

You may call `solve` any number of times. You will always get an immutable copy of the problem specification and its solution. Consecutively calling `solve` will not help the convergence of the problem.

To warm start a solver, you need to explicitly transfer the solution of one problem to the initial value of the next.

sol1 \= opti.solve()
print(sol1.stats()\["iter\_count"\])

\# Solving again makes no difference
sol1 \= opti.solve()
print(sol1.stats()\["iter\_count"\])

\# Passing initial makes a difference
opti.set\_initial(sol1.value\_variables())
sol2 \= opti.solve()
print(sol2.stats()\["iter\_count"\])

15
15
4

sol1 \= opti.solve();
sol1.stats.iter\_count

% Solving again makes no difference
sol1 \= opti.solve();
sol1.stats.iter\_count

% Passing initial makes a difference
opti.set\_initial(sol1.value\_variables());
sol2 \= opti.solve();
sol2.stats.iter\_count

ans = 15
ans = 15
ans = 4

In order to initialize the dual variables, e.g. when solving a set of similar optimization problems, you can use the following syntax:

sol \= opti.solve()
lam\_g0 \= sol.value(opti.lam\_g)
opti.set\_initial(opti.lam\_g, lam\_g0)

sol \= opti.solve();
lam\_g0 \= sol.value(opti.lam\_g);
opti.set\_initial(opti.lam\_g, lam\_g0);

#### 9.2.2. Numerical value at the solution[¶](#numerical-value-at-the-solution "Permalink to this heading")

Afterwards, you may retrieve the numerical values of variables (or expressions of those variables) at the solution:

*   `sol.value(x)`: value of a decision variable
    
*   `sol.value(p)`: value of a parameter
    
*   `sol.value(sin(x+p))`: value of an expression
    
*   `sol.value(jacobian(opti.g,opti.x))`: value of constraint jacobian
    

Note that the return type of `value` is sparse when applicable.

#### 9.2.3. Numerical value at other points[¶](#numerical-value-at-other-points "Permalink to this heading")

You may pass a list of overruling assignment expressions to `value`. In the following code, we are asking for the value of the objective, using all optimal values at the solution, except for `y`, which we set equal to 2. Note that such statement does not modify the actual optimal value of `y` in a permanent way.

obj \= (y\-x\*\*2)\*\*2

opti.minimize(obj)

print(sol.value(obj,\[y\==2\]))

1.909830056703819

obj \= (y\-x^2)^2;

opti.minimize(obj);

sol.value(obj,{y\==2})

ans = 1.9098

A related usage pattern is to evaluate an expression at the initial guess:

print(sol.value(x\*\*2+y,opti.initial()))

0.0

sol.value(x\*\*2+y,opti.initial())

ans = 0

#### 9.2.4. Dual variables[¶](#dual-variables "Permalink to this heading")

In order to obtain dual variables (Lagrange multipliers) of constraints, make sure you save the constraint expression first:

con \= sin(x+y)\>=1
opti.subject\_to(con)
sol \= opti.solve()

print(sol.value(opti.dual(con)))

0.258679501736367

con \= sin(x+y)\>\=1;
opti.subject\_to(con);
sol \= opti.solve();

sol.value(opti.dual(con))

ans = 0.2587

### 9.3. Extras[¶](#extras "Permalink to this heading")

It may well happen that the solver does not find an optimal solution. In such cases, you may still access the non-converged solution through debug mode:

opti.debug.value(x)

Related, you may inspect the value of an expression, at the initial guess that you supplied to the solver:

opti.debug.value(x,opti.initial())

In case the solver stops due to problem infeasibility, you may identify the problematic constraints with:

opti.debug.show\_infeasibilities()

In case the solver reports NaN/Inf at a certain location, you may find out which constraint or variable is to blame by looking at its description:

opti.debug.x\_describe(index)
opti.debug.g\_describe(index)

You may specify a callback function; it will be called at each iteration of the solver, with the current iteration number as argument. To plot the progress of the solver, you may access the non-converged solution through debug mode:

opti.callback(lambda i: plot(opti.debug.value(x)))

opti.callback(@(i) plot(opti.debug.value(x)))

The callback may be cleared from the Opti stack by calling the `Callback` function without arguments.

You may construct a regular CasADi Function out of an Opti object, by calling the `to_function` function. The supplied list of input arguments may contain parameters, decision variables and dual variables. Inputs corresponding to variables are taken as initial guesses. If you desire this Function to throw a runtime error when the solver fails, you may pass the `error_on_fail` as solver option. Using the resulting CasADi `Function` will be quite a bit faster than `opti.set_initial` + `opti.solve` + `sol.value`.

f \= opti.to\_function("f",\[x,y\],\[x\*\*2+y\])
print(f(0, 0))

1.23607

f \= opti.to\_function('f',{x,y},{x^2+y});
disp(f(0, 0))

1.23607

## 10\. Difference in usage from different languages[¶](#difference-in-usage-from-different-languages "Permalink to this heading")

### 10.1. General usage[¶](#general-usage "Permalink to this heading")

Example:

|     |     |     |     |
| --- | --- | --- | --- |Table 10.1.1 General usage[¶](#id1 "Permalink to this table")
| Task | Python | C++ | MATLAB/Octave |
| --- | --- | --- | --- |
| Starting CasADi | from casadi import \* | #include <casadi/casadi.hpp><br>using namespace casadi; | import casadi.\* |
| Printing object | print(A) | std::cout << A; | disp(A) |
| Printing with type information | `A <ENTER>` (interactive), `print(repr(A))` | std::cout << repr(A); | `A <ENTER>` (interactive), `disp(repr(A))` |
| Get (extended) representation, `more=false` by default | `A.str(more)` | `str(A, more)` | `str(A, more)` |
| Calling a class function | SX.zeros(3,4) | SX::zeros(3,4) | SX.zeros(3,4) |
| Creating a dictionary (e.g. for options) | d \= dict(opt1\=opt1)<br>#or<br>d \= {'opt1':opt1}<br>#or<br>d \= {}; a\['opt1'\] \= opt1 | Dict a;<br>a\["opt1"\] \= opt1; | a \= struct;<br>a.opt1 \= opt1;<br><br>#or<br>a \= struct('opt1',opt1); |
| Creating a symbol | MX.sym("x",2,2) | MX::sym("x",2,2) | MX.sym('x',2,2) |
| Creating a function | Function("f",\[x,y\],\[x+y\]) | Function("f",{x,y},{x+y}) | Function('f',{x,y},{x+y}) |
| Calling a function (form 1) | z\=f(x,y) | z \= f({x,y}) | z\=f(x,y) |
| Calling a function (form 2) | res \= f(x\=x,y\=y)<br>res\["z"\] | auto res \=\\<br>f({{"x",x},{"y",y}});<br>res\["z"\] | res\=f('x',x,'y',y)<br>res.z |
| Create an NLP solver | nlp \= {"x":x,"f":f}<br>nlpsol("S","ipopt",nlp) | MXDict nlp \=\\<br>{{"x",x},{"f",f}};<br>nlpsol("S","ipopt",nlp); | nlp\=struct('x',x,'f',f);<br>nlpsol('S','ipopt',nlp); |

### 10.2. List of operations[¶](#list-of-operations "Permalink to this heading")

The following is a list of the most important operations. Operations that differ between the different languages are marked with a star (\*). This list is neither complete, nor does it show all the variants of each operation. Further information is available in the API documentation.

|     |     |     |     |
| --- | --- | --- | --- |Table 10.2.1 General usage[¶](#id2 "Permalink to this table")
| Task | Python | C++ | MATLAB/Octave |
| --- | --- | --- | --- |
| Addition, subtraction | x+y, x\-y, \-x | x+y, x\-y, \-x | x+y, x\-y, \-x |
| Elementwise multiplication, division | x\*y, x/y | x\*y, x/y | x.\*y, x./y |
| Matrix multiplication | x @ y<br>\# or before Py3.4:<br>mtimes(x,y) | mtimes(x,y) | x\*y |
| Linear system solve | solve(A,b) | solve(A,b) | A\\b |
| Natural exponential function and logarithm | exp(x), log(x) | exp(x), log(x) | exp(x), log(x) |
| Exponentiation | x\*\*y | pow(x,y) | x^y, x.^y |
| Square root | sqrt(x) | sqrt(x) | sqrt(x) |
| Trigonometric functions | sin(x), cos(x), tan(x) | sin(x), cos(x), tan(x) | sin(x), cos(x), tan(x) |
| Inverse trigonometric | asin(x), acos(x) | asin(x), acos(x) | asin(x), acos(x) |
| Two argument arctangent | atan2(y, x) | atan2(y, x) | atan2(y, x) |
| Hyperbolic functions | sinh(x), cosh(x), tanh(x) | sinh(x), cosh(x), tanh(x) | sinh(x), cosh(x), tanh(x) |
| Inverse hyperbolic | asinh(x), acosh(x) | asinh(x), acosh(x) | asinh(x), acosh(x) |
| Inequalities | a<b, a<=b, a\>b, a\>=b | a<b, a<=b, a\>b, a\>=b | a<b, a<\=b, a\>b, a\>\=b |
| (_Not_) equal to | a\==b, a!=b | a\==b, a!=b | a\==b, a~=b |
| Logical and | logic\_and(a, b) | a && b | a & b |
| Logical or | logic\_or(a, b) | a \| b | a \| b |
| Logical not | logic\_not(a) | !a  | ~a  |
| Round to integer | floor(x), ceil(x) | floor(x), ceil(x) | floor(x), ceil(x) |
| Modulus after division | fmod(x, y), remainder(x,y) | fmod(x, y), remainder(x,y) | rem(x, y), remainder(x,y) |
| Absolute value | fabs(x) | fabs(x) | abs(x) |
| Norm | norm\_1(x) | norm\_1(x) | norm(x,1) |
| Sign function | sign(x) | sign(x) | sign(x) |
| (Inverse) error function | erf(x), erfinv(x) | erf(x), erfinv(x) | erf(x), erfinv(x) |
| Elementwise min and max | fmin(x, y), fmax(x, y) | fmin(x, y), fmax(x, y) | min(x, y), max(x, y) |
| Global min and max | mmin(x), mmax(x) | mmin(x), mmax(x) | mmin(x), mmax(x) |
| Index of first nonzero | find(x) | find(x) | find(x) |
| If-then-else | if\_else(c, x, y) | if\_else(c, x, y) | if\_else(c, x, y) |
| Transpose | A.T | A.T() | A',A.' |
| Inner product | dot(x, y) | dot(x, y) | dot(x, y) |
| Horizontal/vertical concatenation | horzcat(x, y)<br>vertcat(x, y)<br>hcat(\[x, y\])<br>vcat(\[x, y\]) | horzcat(x, y)<br>vertcat(x, y)<br>MX::horzcat({x,y})<br>MX::vertcat({x,y}) | \[x,y\]<br>\[x; y\]<br>c \= {x,y};<br>\[c{:}\]<br>vertcat(c{:}) |
| Horizontal/vertical split (inverse of concatenation) | vertsplit(x)<br>horzsplit(x) | vertsplit(x)<br>horzsplit(x) | vertsplit(x)<br>horzsplit(x) |
| Element access | \# 0-based<br>A\[i,j\]<br>A\[i\] | // 0-based<br>A(i,j)<br>A(i) | %  1-based<br>A(i,j)<br>A(i) |
| Element assignment | \# 0-based<br>A\[i,j\] \= b<br>A\[i\] \= b | // 0-based<br>A(i,j) \= b<br>A(i) \= b | %  1-based<br>A(i,j) \= b<br>A(i) \= b |
| Nonzero access | \# 0-based<br>A.nz\[k\] | // 0-based<br>A.nz(k) | (currently unsupported) |
| Nonzero assignment | \# 0-based<br>A.nz\[k\] \= b | // 0-based<br>A.nz(k) \= b | (currently unsupported) |
| Project to a different sparsity | project(x, s) | project(x, s) | project(x, s) |