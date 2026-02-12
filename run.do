vlib work

vlog D_FF_mux.v
vlog multiplier.v
vlog mux21.v
vlog mux41.v
vlog post_adder_subtracter.v
vlog pre_adder_subtracter.v
vlog Spartan6.v
vlog Spartan6_tb.v

vsim -voptargs=+acc work.DSP48A1_tb

add wave *
run -all
#quit -sim

