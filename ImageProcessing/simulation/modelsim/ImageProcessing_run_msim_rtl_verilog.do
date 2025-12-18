transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/CE213/LAB/CE213_LAB/ImageProcessing {D:/CE213/LAB/CE213_LAB/ImageProcessing/median_filter.v}

