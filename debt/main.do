
use "https://liangyangdata.github.io/data/debt.dta",clear

set scheme s1color
// set scheme economist  // 设置画图主题为经济学人

// 整体杠杆率
tsline non_financial_sector , title("中国宏观杠杆率") xtitle("") /// 
		xlab(,angle(45)) saving(plot1,replace)

// 分部门对比
tsline household general_government non_financial_cor, title("分部门对比") /// 
		xtitle("") xlab(,angle(45)) saving(plot2, replace)
		
// 央地对比
tsline *government, title("中央-地方对比") xlab(,angle(45)) /// 
		xtitle("") saving(plot3, replace)
		
// 金融部门资产负债
tsline  financial_sectorasset_side financial_sectorliability_side, title("金融部门(资产/负债)") /// 
		xtitle("") xlab(,angle(45)) saving(plot4, replace)

// 图形汇总
graph combine plot1.gph plot2.gph plot3.gph plot4.gph, row(2)