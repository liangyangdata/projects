* Set global path
global Path `c(pwd)'
global Data $Path/Data 
global Raw $Path/Raw

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

