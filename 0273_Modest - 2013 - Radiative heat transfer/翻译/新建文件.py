import os

# 定义要创建的Markdown文件列表
md_files = [
    "1-热辐射基础.md",
    "2-基于电磁波理论的辐射特性预测.md",
    "3-实际表面的辐射特性.md",
    "4-视角因子.md",
    "5-灰体漫射表面间的辐射交换.md",
    "6-部分镜面灰体表面间的辐射交换.md",
    "7-非理想表面间的辐射交换.md",
    "8-表面交换的蒙特卡洛方法.md",
    "9-传导和对流存在时的表面辐射交换.md",
    "10-参与介质中的辐射传递方程(RTE).md",
    "11-分子气体的辐射特性.md",
    "12-颗粒介质的辐射特性.md",
    "13-半透明介质的辐射特性.md",
    "14-一维灰体介质的精确解.md",
    "15-一维介质的近似求解方法.md",
    "16-球谐函数法(PN-近似).md",
    "17-离散坐标法(SN-近似).md",
    "18-区域法.md",
    "19-准直辐射与瞬态现象.md",
    "20-非灰消光系数的求解方法.md",
    "21-参与介质的蒙特卡洛方法.md",
    "22-辐射与传导和对流的耦合.md",
    "23-逆辐射传热.md",
    "24-纳米尺度辐射传热.md",
    "附录.md"
]

# 获取当前文件夹路径
current_dir = os.getcwd()

# 创建每个Markdown文件
for file_name in md_files:
    file_path = os.path.join(current_dir, file_name)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(f"# {file_name.split('.')[0]}\n\n<!-- 在这里添加内容 -->")
    print(f"已创建文件: {file_path}")

print("所有文件创建完成！")