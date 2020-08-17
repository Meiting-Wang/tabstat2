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

`tabstat`在没有`by`选项时，可以输出和`sum`一样的效果，所以当`tabstat2`没有`by`选项时，可以输出和`wmtsum`一样的效果。当然，这就引出了之所以形成本文的原因——加上`by`选项，**`tabstat2`命令可以将分组描述性统计输出至Stata界面、Word文件及LaTeX文件中**（当然，该命令依然保留了可以不使用`by`选项去形成与`wmtsum`一样的结果的功能）。有人会说，前面不是有`table2`命令了吗？不是的，差异是肯定有的——毕竟分区块与分组还是有区别的。有兴趣的读者可以运行一下帮助文件中的实例感受一下。

该命令，和已经推出的`wmtsum`、`wmttest`、`wmtcorr`、`wmtreg`、`wmtmat`、`table2`命令，都可以通过`append`选项成为一个整体，将输出结果集中输出至一个 Word 或 LaTeX 文件中。

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

> - `varlist`: 可输入一个或两个类别变量
> - `weight`: 可以选择 fweight 或 aweight，默认为空。
> - `using`: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）

**选项（options）**：

- 一般选项
  - `contents(string)`：填写类似`n mean(price) sd(price) mean(mpg)`的语句，括号内为变量，括号外为统计量。所有可以输入的统计量有：`n mean sd min max range variance sum p1 p5 p10 p25 p50 p75 p90 p95 p99 cv skewness kurtosis`。这些统计量的含义可以在`help tabstat`中查看。
  - `format(fmtlist)`：设定`contents`中对应统计量的数值格式
  - `row`：额外报告行总计
  - `column`：额外报告列总计
  - `listwise`：在计算统计量之前会先剔除所涉及变量中包含缺漏值的观测值
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
*共同部分
sysuse auto.dta, clear
tabstat2 foreign, c(n) //分组计数
tabstat2 foreign, c(n mean(price) sd(price) mean(trunk) sd(trunk)) //分组计算统计量
tabstat2 foreign, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row //额外报告行方向总体上计算的统计量
tabstat2 foreign, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row list //计算统计量时不会考虑包含缺漏值的观测值

tabstat2 foreign rep78, c(n) //分组计数
tabstat2 foreign rep78, c(n mean(price) sd(price) mean(trunk) sd(trunk)) //分组计算统计量
tabstat2 foreign rep78, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row //额外报告行方向总体上计算的统计量
tabstat2 foreign rep78, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col //额外报告列方向总体上计算的统计量
tabstat2 foreign rep78, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col list //计算统计量时不会考虑包含缺漏值的观测值

tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col //设置数值格式
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col eql(domestic foreign Total) //自定义报告的行方程名
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col varl(mean(price) price_m sd(price) price_sd mean(trunk) trunk_m sd(trunk) trunk_sd) //自定义行名
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col coll("very bad" bad general good "very good" Total) //自定义列名
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col compress //将表格压缩展示
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col varw(11) //自定义第一列的宽度(空格数)
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col compress varw(12) modelw(10) //将第二列及之后列的宽度设定为10个空格
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col compress varw(12) modelw(10 15 20 20 20 20) //为第二列及之后列分别自定义宽度
tabstat2 foreign rep78 , c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col ti(This is a title) //自定义表格标题

*Word部分
tabstat2 foreign rep78 using Myfile.rtf, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title)  //将结果输出至Word

*LaTeX部分
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) //将结果输出至LaTeX
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) a(math) //设置列格式为数学格式(也为默认列格式)
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) a(dot) //设置列格式为小数点对齐
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) page(amsmath) //引入额外的宏包(无论怎么样都会引入array和booktabs宏包)
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) width(\textwidth) //设置表格宽度为版心宽度

*该命令结果可以用系统自带的 table 命令进行验证
table foreign, c(freq)
table foreign, c(freq mean price sd price mean trunk sd trunk)
table foreign, c(freq mean price sd price mean trunk sd trunk) row

table foreign rep78, c(freq)
table foreign rep78, c(freq mean price sd price mean trunk sd trunk)
table foreign rep78, c(freq mean price sd price mean trunk sd trunk) row
table foreign rep78, c(freq mean price sd price mean trunk sd trunk) row col
```

> 以上所有与`tabstat2`相关的实例都可以在`help tabstat2`中直接运行。  
> ![image](https://user-images.githubusercontent.com/42256486/90336243-03baec80-e00d-11ea-8d9a-d36b5a507916.png)

## 五、输出效果展示

- **Stata**

```stata
tabstat2 foreign, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row
```

```stata
-----------------------------------------------------------------------------
                        n  mean(price)    sd(price)  mean(trunk)    sd(trunk)
-----------------------------------------------------------------------------
0                      52     6072.423     3097.104        14.75     4.306288
1                      22     6384.682     2621.915     11.40909     3.216906
Total                  74     6165.257     2949.496     13.75676     4.277404
-----------------------------------------------------------------------------
```

```stata
tabstat2 foreign rep78, c(n mean(price) sd(price) mean(trunk) sd(trunk)) row col
```

```stata
------------------------------------------------------------------------------------------
                        1            2            3            4            5        Total
------------------------------------------------------------------------------------------
0                                                                                         
n                       2            8           27            9            2           48
mean(price)        4564.5     5967.625     6607.074     5881.556       4204.5      6179.25
sd(price)        522.5519     3579.357     3661.267     1592.019     311.8341     3188.969
mean(trunk)           8.5       14.625     15.59259     16.66667          9.5     15.08333
sd(trunk)         2.12132     4.983903     3.532914      4.66369      2.12132     4.281744
------------------------------------------------------------------------------------------
1                                                                                         
n                       0            0            3            9            9           21
mean(price)             .            .     4828.667     6261.444     6292.667     6070.143
sd(price)               .            .     1285.613     1896.092     2765.629     2220.984
mean(trunk)             .            .     12.33333     10.33333     11.88889     11.28571
sd(trunk)               .            .      3.21455     3.840573     2.666667     3.242574
------------------------------------------------------------------------------------------
Total                                                                                     
n                       2            8           30           18           11           69
mean(price)        4564.5     5967.625     6429.233       6071.5         5913     6146.043
sd(price)        522.5519     3579.357      3525.14     1709.608     2615.763      2912.44
mean(trunk)           8.5       14.625     15.26667         13.5     11.45455     13.92754
sd(trunk)         2.12132     4.983903     3.590537     5.272013      2.65946     4.343077
------------------------------------------------------------------------------------------
```

- **Word**

```stata
tabstat2 foreign rep78 using Myfile.rtf, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title)
```

![tabstat2-Word](https://user-images.githubusercontent.com/42256486/90336348-d6bb0980-e00d-11ea-8801-a89428a10bb1.png)

- **LaTeX**

```stata
tabstat2 foreign rep78 using Myfile.tex, replace c(n mean(price) sd(price) mean(trunk) sd(trunk)) f(0 2 2 2 2) row col ti(This is a title) a(math)
```

```stata
% 16 Aug 2020 22:17:09
\documentclass{article}
\usepackage{array}
\usepackage{booktabs}
\begin{document}

\begin{table}[htbp]\centering
\caption{This is a title}
\begin{tabular}{l*{6}{>{$}c<{$}}}
\toprule
            &\multicolumn{1}{c}{1}&\multicolumn{1}{c}{2}&\multicolumn{1}{c}{3}&\multicolumn{1}{c}{4}&\multicolumn{1}{c}{5}&\multicolumn{1}{c}{Total}\\
\midrule
0           &            &            &            &            &            &            \\
n           &           2&           8&          27&           9&           2&          48\\
mean(price) &     4564.50&     5967.63&     6607.07&     5881.56&     4204.50&     6179.25\\
sd(price)   &      522.55&     3579.36&     3661.27&     1592.02&      311.83&     3188.97\\
mean(trunk) &        8.50&       14.63&       15.59&       16.67&        9.50&       15.08\\
sd(trunk)   &        2.12&        4.98&        3.53&        4.66&        2.12&        4.28\\
\midrule
1           &            &            &            &            &            &            \\
n           &           0&           0&           3&           9&           9&          21\\
mean(price) &           .&           .&     4828.67&     6261.44&     6292.67&     6070.14\\
sd(price)   &           .&           .&     1285.61&     1896.09&     2765.63&     2220.98\\
mean(trunk) &           .&           .&       12.33&       10.33&       11.89&       11.29\\
sd(trunk)   &           .&           .&        3.21&        3.84&        2.67&        3.24\\
\midrule
Total       &            &            &            &            &            &            \\
n           &           2&           8&          30&          18&          11&          69\\
mean(price) &     4564.50&     5967.63&     6429.23&     6071.50&     5913.00&     6146.04\\
sd(price)   &      522.55&     3579.36&     3525.14&     1709.61&     2615.76&     2912.44\\
mean(trunk) &        8.50&       14.63&       15.27&       13.50&       11.45&       13.93\\
sd(trunk)   &        2.12&        4.98&        3.59&        5.27&        2.66&        4.34\\
\bottomrule
\end{tabular}
\end{table}

\end{document}
```

![tabstat2-LaTeX](https://user-images.githubusercontent.com/42256486/90336461-a1fb8200-e00e-11ea-8cf5-498467892d81.png)

> 在将结果输出至 Word 或 LaTeX 时，Stata 界面上也会呈现对应的结果，以方便查看。
