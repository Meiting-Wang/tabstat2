* Description: output grouped descriptive statistics(the result of tabstat) to Stata interface, Word and LaTeX
* Author: Meiting Wang, doctor, Institute for Economic and Social Research, Jinan University
* Email: wangmeiting92@gmail.com
* Created on Aug 17, 2020


program define tabstat2
version 16

syntax varlist(numeric) [if] [in] [aw fw/] [using] [, replace append by(passthru) Statistics(string asis) LISTwise NOTotal EQLabels(passthru) VARLabels(passthru) COLLabels(passthru) VARWidth(passthru) MODELWidth(passthru) COMPRESS TItle(passthru) Alignment(string) PAGE(string) WIDTH(passthru)]
/*
*-实例
*--共同部分
sysuse auto.dta, clear
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


*-编程思想或注意事项
1. 使用estpost tabstat和esttab进行编程
*/

*处理weight语句——以兼容本程序
if "`weight'" != "" {
	local weight "[`weight'=`exp']"
}

*设置默认值
if "`statistics'" == "" {
	local statistics "count mean sd min max"
}

if "`alignment'" == "" {
	local alignment "math"
}

*程序报错信息
if ("`alignment'"!="math") & ("`alignment'"!="dot") {
	dis "{error:wrong alignment setting}"
	exit
}

*提取“纯洁”的统计量
tokenize `statistics', p("()")
local i = 1
local count = 0
local stat_pure ""
while "``i''" != "" {
	if "``i''" == "(" {
		local count = `count' + 1
	}
	else if "``i''" == ")" {
		local count = `count' - 1
	}
	if (`count'==0) & ("``i''"!=")") {
		local stat_pure "`stat_pure'``i'' "
	}
	local i = `i' + 1
}

*-------------------主程序---------------------
qui estpost tabstat `varlist' `if' `in' `weight', c(s) statistics(`stat_pure') elabels `by' `listwise' `nototal'
esttab ., cells("`statistics'") noobs nonum nomti `compress' `title' `eqlabels' `varlabels' `collabels' `varwidth' `modelwidth'

if ustrregexm(`"`using'"',"\.rtf") {
	esttab . `using', cells("`statistics'") noobs nonum nomti `replace' `append' `compress' `title' `eqlabels' `varlabels' `collabels' `varwidth' `modelwidth'
}
else if ustrregexm(`"`using'"',"\.tex") {
	*LaTeX collabels专属设置
	if `"`collabels'"' == "" {
		tokenize `stat_pure'
		local i = 1
		while "``i''" != "" {
			local collabels `"`collabels'\multicolumn{1}{c}{``i''} "'
			local `i' "" //置空`i'
			local i = `i' + 1
		}
		local collabels `"collabels(`collabels')"'
	}
	else {
		local collabels = ustrregexra(`"`collabels'"',"collabels\(\s*|\s*\)","")
		tokenize `"`collabels'"'
		local i = 1
		local collabels ""
		while "``i''" != "" {
			local collabels `"`collabels'"\multicolumn{1}{c}{``i''}" "'
			local `i' "" //置空`i'
			local i = `i' + 1
		}
		local collabels `"collabels(`collabels')"'
	}
	
	*LaTeX alignment page设置
	local stat_num: word count `stat_pure'
	if "`alignment'" == "math" {
		local alignment "*{`stat_num'}{>{$}c<{$}}"
		if "`page'" == "" {
			local page "page(array)"
		}
		else {
			local page "page(`page',array)"
		}
	}
	else if "`alignment'" == "dot" {
		local alignment "*{`stat_num'}{D{.}{.}{-1}}"
		if "`page'" == "" {
			local page "page(array,dcolumn)"
		}
		else {
			local page "page(`page',array,dcolumn)"
		}
	}
	local alignment "alignment(`alignment')"
	
	esttab . `using', cells("`statistics'") noobs nonum nomti `replace' `append' `compress' `title' `eqlabels' `varlabels' `collabels' `varwidth' `modelwidth' `alignment' `page' `width' booktabs
}
end
