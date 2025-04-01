transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/SE9_16.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/SE6_16.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/register_file.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/reg.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/pad_lli.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_register.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_or.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_inverter.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_imply.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_and.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/mux16bit8to1.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/mux16bit4to1.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/mux16bit2to1.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/mux8x1.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/mux3bit4to1.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/memory.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/LHI.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/instruction_register.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/full_adder.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/demux1x8.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/ConditionCodeRegister.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_full_adder.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/n_bit_adder_subtractor.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/four_bit_multiplier.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/alu.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/datapath.vhd}
vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/fsm.vhd}

vcom -93 -work work {C:/Users/kusha/OneDrive/Desktop/final_cpu/CPU/CPU/fsm_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  fsm_tb

add wave *
view structure
view signals
run -all
