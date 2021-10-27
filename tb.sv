`include "item.sv"
`include "secuencia.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agente.sv"
`include "scoreboard.sv"
`include "ambiente.sv"
`include "test.sv"
`include "interface.sv"

//Testbench
module tb;

    //Definicion del clock
    reg clk;
    always #10 clk=~clk;

    //Declaracion de la interfaz
    detector_if _if (clk);

    //Instanciacion del DUT
    det_1011 dut0 (
        .clk(clk),
        .rstn(_if.rstn),
        .in(_if.in),
        .out(_if.out)
    );

    //Inicio del test
    initial begin
        clk <=0;
        
        //Incluye la interfaz dentro de la base de datos configuracion
      uvm_config_db#(virtual detector_if)::set(null, "uvm_test_top", "detector_vif", _if);

        //Corre el test
      run_test("test_spec");
    end
endmodule

