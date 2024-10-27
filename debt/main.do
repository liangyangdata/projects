
*===================
*- 数据处理
*===================

* 设置第一行为标签，第二行为变量
import excel "$Raw/CNBS（中国宏观杠杆率数据）.xlsx", sheet("Data") cellrange(A1:I127)  clear 
// labone,nrow(1 2) concat(/) // 第一二行作为标签
labone,nrow(1) concat(/) // 第一行作为标签
foreach var of varlist _all {
	replace `var' = trim(`var') if _n == 2  // 清除首尾空格
	replace `var' = subinstr(`var', "-", "_", .) if _n == 2 // 替换连字符"-"
    replace `var' = subinstr(`var', " ", "_", .) if _n == 2 // 替换中间空格
	replace `var' = subinstr(`var', "(", "", .) if _n == 2 // 替换括号
	replace `var' = subinstr(`var', ")", "", .) if _n == 2 // 替换括号
}
nrow 2 // 第二行作为变量名 

// 统一变量名大小写
// local varlist `:varlist'
foreach var of varlist _all {
    local newvar = lower("`var'")
    rename `var' `newvar'
}

// export excel using "Raw/CNBS.xlsx",  firstrow(variables) nolabel replace 
// import excel using "Raw/CNBS.xlsx", clear firstrow

destring *,replace // 转为数值
gen date  = date(period, "DMY") 
format date %td

tsset date
drop period 

save $Data/debt.dta, replace 

*===================
*- 图形
*===================

use "https://liangyangdata.github.io/data/debt.dta",clear
set scheme s1color
// set scheme economist  // 设置画图主题为经济学人
// 整体
tsline household non_financial_corporations general_government non_financial_sector financial_sectorliability_side, title("中国宏观杠杆率") xtitle("") /// 
		xlab(,angle(45)) saving(plot1.gph,replace)
// graph export using "$Figure/中国宏观杠杆率", replace
// 部门对比
tsline household general_government non_financial_sector, title("三部门杠杆对比") /// 
		xtitle("") xlab(,angle(45)) saving(plot2, replace)
		
// graph export using $Figure/三部门杠杆对比, replace 

// 央地对比
tsline *government, title("中央-地方杠杆率") xlab(,angle(45)) /// 
		xtitle("") saving(plot3, replace)
// graph export using $Figure/政府杠杆率, replace 
		
// 资产负债
tsline  financial_sectorasset_side financial_sectorliability_side, title("金融部门资产负债") /// 
		xtitle("") xlab(,angle(45)) saving(plot4, replace)
// graph export using	$Figure/金融部门资产负债, replace

graph combine plot1.gph plot2.gph plot3.gph plot4.gph, row(2)
		
		