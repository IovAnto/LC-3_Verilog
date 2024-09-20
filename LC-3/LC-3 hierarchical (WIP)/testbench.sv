module final_Tb;
  
  reg clock;
  
  //DUT (Device Under Test)
  LC_3 dut (
    .clock(clock)
  );
  

  always #10 clock = ~clock;
  
  initial begin
    clock = 1'b0; // Start with clock low
  end
  
  initial begin
    #10000000;
    $finish;
  end

endmodule


//Da rifare la FSM, bisogna renderla gerarchica cioè un FSM che chiama un FSM
//
//
//	add: 
//		FSM fut(
//        	.ciao(ciao)   
//			.bello(bello)
//		);
//  not: 
//     FSM not (
//		 	.aluk(aluk)
//			.presi(presi)     //si dovrebbe fare cosi, studia FSM gerarchiche
//     );