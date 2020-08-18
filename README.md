# Stata 新命令：tabstat2——"tabstat"命令结果的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 目录

- **一、引言**
- **二、命令的安装**
- **三、语法与选项**
- **四、实例**
- **五、输出效果展示**

## 一、引言

写了好多类似的命令，突然发现这个分组描述性统计的`tabstat`还没写，同时它也有着其他已写命令不具有的特点（有兴趣的读者可以自己感受一下），于是索性就写了，好形成一个整体，就这样。

`tabstat`在没有`by`选项时，可以输出和`sum`一样的效果，所以当`tabstat2`没有`by`选项时，可以输出和`wmtsum`一样的效果。当然，这就引出了之所以形成本文的原因——加上`by`选项，**`tabstat2`命令可以将分组描述性统计输出至 Stata 界面、Word 文件及 LaTeX 文件中**（当然，该命令依然保留了可以不使用`by`选项去形成与`wmtsum`一样的结果的功能）。有人会说，前面不是有`table2`命令了吗？不是的，差异是肯定有的——毕竟分区块与分组还是有区别的。有兴趣的读者可以运行一下帮助文件中的实例感受一下。

该命令，和已经推出的`wmtsum`、`wmttest`、`wmtcorr`、`wmtreg`、`wmtmat`、`table2`命令，都可以通过`append`选项成为一个整体，将输出结果集中输出至一个 Word 或 LaTeX 文件中。

> 以上可以通过`append`选项形成一个整体的系列命令，在导出 LaTeX 表格时，统一采用的是三线表形式（booktabs）。

更多阅读：

- [Stata 新命令：wmtsum——描述性统计表格的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483662&idx=1&sn=04eeafa47e3996e500207cde7416050e&chksm=e9772222de00ab3427c360d6bfb31c14bbd8ee8477840a2890f19d66f4dc44dc7a5cbf4bf4a2&token=1668456026&lang=zh_CN#rd)
- [Stata 新命令：wmttest——分组 T 均值检验表格的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483673&idx=1&sn=05092b981b1b44bba6c94fbc86cabafb&chksm=e9772235de00ab232af1d9a3790b18a6ed0cd2f6cd8af8bd3b36193d4fa089bf313bc38c90d8&token=1668456026&lang=zh_CN#rd)
- [Stata 新命令：wmtcorr——相关系数矩阵的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483678&idx=1&sn=6cc79f9de0caff35e9ee2ae5b057e3e2&chksm=e9772232de00ab241b6463368580a1e8a858878e2df3a6f444dce04f554aeeded2dcc873b101&token=1668456026&lang=zh_CN#rd)
- [Stata 新命令：wmtreg——回归结果的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483693&idx=1&sn=d70a570fd759ac93fe6bb476d807e9ef&chksm=e9772201de00ab17139e5362b17721ed85acf42de0191a7a1c89fc24f4c653e40f91be4a7c44&token=1668456026&lang=zh_CN#rd)
- [Stata 新命令：wmtmat——矩阵的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483704&idx=1&sn=0423c8752e807e38f4bd5809d2231d9e&chksm=e9772214de00ab02546bf402a3ef05326615d0c687bd280d4a2d501b6c6d17e31c48e623056f#rd)
- [Stata 新命令：table2——"table"命令结果的输出](https://mp.weixin.qq.com/s?__biz=MzI0MjgyNDc3MQ==&mid=2247483898&idx=1&sn=d3b46fff9d820225a69f800f6efa0d03&chksm=e97722d6de00abc0b17ea359a361ff8c56c4ad63a9b651e39eaf6b9c3dd89fb95af9eae11ef4&token=1033606962&lang=zh_CN#rd)

## 二、命令的安装

`tabstat2`及本人其他命令的代码都托管于 GitHub 上，读者可随时下载安装这些命令。

你可以通过系统自带的`net`命令进行安装：

```stata
net install tabstat2, from("https://raw.githubusercontent.com/Meiting-Wang/tabstat2/master")
```

也可以通过`github`外部命令进行安装（`github`命令本身可以通过`net install github, from("https://haghish.github.io/github/")`进行安装）：

```stata
github install Meiting-Wang/tabstat2
```

## 三、语法与选项

**命令语法**：

```stata
tabstat2 varlist [if] [in] [weight] [using filename] [, options]
```

> - `varlist`: 可输入一个或多个数值型变量
> - `weight`: 可以选择 aweight 或 fweight，默认为空。
> - `using`: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）

**选项（options）**：

- 一般选项
  - `by(varname)`: 可输入一个类别变量
  - `statistics(string)`：设定要报告的统计量，所以可以输入的统计量有：`count mean sd min max range variance sum p1 p5 p10 p25 p50 p75 p90 p95 p99 iqr cv semean skewness kurtosis`。当然，我们还可以设置统计量的数值格式和标签，如`mean(fmt(%9.3f) label(mean_label))`。
  - `listwise`：在计算统计量之前会先剔除所涉及变量中包含缺漏值的观测值
  - `nototal`：不报告总计部分
  - `title(string)`：设置表格标题
  - `replace`: 替换已存在的文件
  - `append`: 将输出内容附加在已存在的文件中
  - `eqlabels(strings)`: 自定义行方程名
  - `varlabels(matchlist)`: 自定义行变量名
  - `collabels(strings)`: 自定义列名
  - `varwidth(number)`: 自定义表格第一列的宽度
  - `modelwidth(numlist)`: 自定义表格第二列及之后列的宽度
  - `compress`: 压缩表格的行空白空间，以使表格更紧凑
- LaTeX 专有选项
  - `alignment(string)`：设置 LaTeX 表格的列对齐格式，可输入`math`或`dot`，`math`设置列格式为居中对齐的数学格式（自动添加宏包`booktabs`和`array`），`dot`表示小数点对齐的数学格式（自动添加宏包`booktabs`、`array`和`dcolumn`）。默认为`math`
  - `page(string)`：可添加用户额外需要的宏包
  - `width(string)`：设置 LaTeX 中表格的宽度，如`width(\textwidth)`表示设置表格宽度为版心宽度

> - 以上其中的一些选项可以缩写，详情可以在安装完命令后`help tabstat2`

## 四、实例

```stata
sysuse auto.dta, clear
*--共同部分
tabstat2 price weight mpg rep78 //默认报告count mean sd min max
tabstat2 price weight mpg rep78, listwise //在计算统计量时会先提出所涉及变量包含缺漏值的观测值
tabstat2 price weight mpg rep78, s(count mean min max) //设定特定的统计量
tabstat2 price weight mpg rep78, s(count(label(n)) mean(fmt(2)) min(fmt(2)) max(fmt(2))) //为统计量设置标签以及数值格式

tabstat2 price weight mpg rep78, by(foreign) //分组报告描述性统计
tabstat2 price weight mpg rep78, by(foreign) nototal //不报告Total部分
tabstat2 price weight mpg rep78, by(foreign) eql(domestic foreign Total) //设置行方程名
tabstat2 price weight mpg rep78, by(foreign) varl(price price_plus mpg mpg_plus) //为变量设置标签
tabstat2 price weight mpg rep78, by(foreign) coll(col1 col2 col3 col4 col5) //为表格自定义列名
tabstat2 price weight mpg rep78, by(foreign) compress //压缩表格横向空格以使得表格更紧凑
tabstat2 price weight mpg rep78, by(foreign) compress varw(20) //自定义表格第一列的宽度
tabstat2 price weight mpg rep78, by(foreign) compress modelw(12) //自定义表格第二列及之后列的宽度
tabstat2 price weight mpg rep78, by(foreign) ti(This is a title) //设置表格标题

*--Word部分
tabstat2 price weight mpg rep78 using Myfile.rtf, replace by(foreign) //将结果导出至Word

*--LaTeX部分
tabstat2 price weight mpg rep78 using Myfile.tex, replace by(foreign) ti(This is a title) //将结果导出至LaTeX
tabstat2 price weight mpg rep78 using Myfile.tex, replace by(foreign) ti(This is a title) a(dot) //设置LaTeX表格列为小数点对齐(默认为数学模式居中对齐)
tabstat2 price weight mpg rep78 using Myfile.tex, replace by(foreign) ti(This is a title) page(amsmath) //为LaTeX添加额外的宏包
tabstat2 price weight mpg rep78 using Myfile.tex, replace by(foreign) ti(This is a title) width(\textwidth) //将LaTeX的表格宽度设为版心宽度


*-该命令结果可以用系统自带的tabstat命令进行验证
tabstat price weight mpg rep78, c(s) s(count mean sd min max)
tabstat price weight mpg rep78, by(foreign) c(s) s(count mean sd min max) long
```

> 以上所有与`tabstat2`相关的实例都可以在`help tabstat2`中直接运行。  
> ![](https://img-blog.csdnimg.cn/20200818102100924.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhbmdtZWl0aW5nYWE=,size_16,color_FFFFFF,t_70#pic_center)

## 五、输出效果展示

- **Stata**

```stata
tabstat2 price weight mpg rep78, compress
```

```stata
------------------------------------------------------------
               count      mean        sd       min       max
------------------------------------------------------------
price             74  6165.257  2949.496      3291     15906
weight            74  3019.459  777.1936      1760      4840
mpg               74   21.2973  5.785503        12        41
rep78             69  3.405797  .9899323         1         5
------------------------------------------------------------
```

```stata
tabstat2 price weight mpg rep78, compress s(count(label(n)) mean(fmt(2)) min(fmt(2)) max(fmt(2)))
```

```stata
--------------------------------------------------
                   n      mean       min       max
--------------------------------------------------
price             74   6165.26   3291.00  15906.00
weight            74   3019.46   1760.00   4840.00
mpg               74     21.30     12.00     41.00
rep78             69      3.41      1.00      5.00
--------------------------------------------------
```

```stata
tabstat2 price weight mpg rep78, compress by(foreign) s(count(label(n)) mean(fmt(2)) min(fmt(2)) max(fmt(2)))
```

```stata
--------------------------------------------------
                   n      mean       min       max
--------------------------------------------------
0                                                 
price             52   6072.42   3291.00  15906.00
weight            52   3317.12   1800.00   4840.00
mpg               52     19.83     12.00     34.00
rep78             48      3.02      1.00      5.00
--------------------------------------------------
1                                                 
price             22   6384.68   3748.00  12990.00
weight            22   2315.91   1760.00   3420.00
mpg               22     24.77     14.00     41.00
rep78             21      4.29      3.00      5.00
--------------------------------------------------
Total                                             
price             74   6165.26   3291.00  15906.00
weight            74   3019.46   1760.00   4840.00
mpg               74     21.30     12.00     41.00
rep78             69      3.41      1.00      5.00
--------------------------------------------------
```

- **Word**

```stata
tabstat2 price weight mpg rep78 using Myfile.rtf, replace compress by(foreign) ti(This is a title)
```

![tabstat2-Word](https://img-blog.csdnimg.cn/20200818102614125.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhbmdtZWl0aW5nYWE=,size_16,color_FFFFFF,t_70#pic_center)

- **LaTeX**

```stata
tabstat2 price weight mpg rep78 using Myfile.tex, replace by(foreign) compress ti(This is a title) a(math)
```

```tex
% 18 Aug 2020 10:27:33
\documentclass{article}
\usepackage{array}
\usepackage{booktabs}
\begin{document}

\begin{table}[htbp]\centering
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
\caption{This is a title}
\begin{tabular}{l*{1}{*{5}{>{$}c<{$}}}}
\toprule
          &\multicolumn{1}{c}{count}&\multicolumn{1}{c}{mean}&\multicolumn{1}{c}{sd}&\multicolumn{1}{c}{min}&\multicolumn{1}{c}{max}\\
\midrule
0         &         &         &         &         &         \\
price     &       52& 6072.423& 3097.104&     3291&    15906\\
weight    &       52& 3317.115& 695.3637&     1800&     4840\\
mpg       &       52& 19.82692& 4.743297&       12&       34\\
rep78     &       48& 3.020833&  .837666&        1&        5\\
\midrule
1         &         &         &         &         &         \\
price     &       22& 6384.682& 2621.915&     3748&    12990\\
weight    &       22& 2315.909& 433.0035&     1760&     3420\\
mpg       &       22& 24.77273& 6.611187&       14&       41\\
rep78     &       21& 4.285714& .7171372&        3&        5\\
\midrule
Total     &         &         &         &         &         \\
price     &       74& 6165.257& 2949.496&     3291&    15906\\
weight    &       74& 3019.459& 777.1936&     1760&     4840\\
mpg       &       74&  21.2973& 5.785503&       12&       41\\
rep78     &       69& 3.405797& .9899323&        1&        5\\
\bottomrule
\end{tabular}
\end{table}

\end{document}
```

![tabstat2-LaTeX](https://img-blog.csdnimg.cn/2020081810294579.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhbmdtZWl0aW5nYWE=,size_16,color_FFFFFF,t_70#pic_center)

> 在将结果输出至 Word 或 LaTeX 时，Stata 界面上也会呈现对应的结果，以方便查看。
