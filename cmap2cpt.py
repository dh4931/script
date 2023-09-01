import matplotlib.pyplot as plt
cmap = plt.get_cmap('seismic')
cpt_file = r'D:/seismic.cpt'

# 打开 .cpt 文件以写入模式
with open(cpt_file, 'w') as f:
    f.write('# GMT Colormap\n')
    f.write('#\n')

    # 遍历 Colormap 中的颜色
    for i in range(cmap.N-1):
        # 获取颜色值 (r, g, b, a)
        color = cmap(i)
        color2 = cmap(i+1)
        
        # 将颜色值从 [0, 1] 映射到 [0, 255]
        r, g, b, a = [int(val * 255) for val in color]
        r2, g2, b2, a2 = [int(val * 255) for val in color2]
        # 写入颜色信息和相应的数据值范围
        f.write(f'{i} {r}/{g}/{b} {i+1} {r2}/{g2}/{b2}\n')
    r0, g0, b0, a0 = [int(val * 255) for val in cmap(0)]
    rn, gn, bn, an = [int(val * 255) for val in cmap(cmap.N)]
    f.write(f'B {r0}/{g0}/{b0}\n')
    f.write(f'F {rn}/{gn}/{bn}\n')
    f.write(f'N gray\n')
print(f'Colormap 已保存到 {cpt_file}')
