all: view

view: front_panel.v
	iverilog nova_tb.v ../nova.v -o front.o
	vvp front.o
	gtkwave front.vcd panel.gtkw 

clean:
	rm *.o
	rm *.vcd

