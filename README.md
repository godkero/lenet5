# lenet_restart


top_wrapper.v -|----control.v
 	             |
  	           |---- calculate_wrapper.v -|----- calculate_2d.v --- mult_cell.v
	             |                          |
	             |			                    |----- relu_function.v
	             |
	             |
  	           |---- front_layer_wrapper.v --- front_layer_address_gen.v
	             |			                      |
	             |			                      |-- pooling_2d.v
	             |
	             |----middle_layer_wrapper.v-- stage2_add.v
	             |			                    |-pooling_layer3.v

		..... 추후 추가 예정
