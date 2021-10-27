class monitor extends uvm_monitor;

//Inclusion en la fabrica
`uvm_component_utils(monitor)

//Declaracion explicita del constructor
function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);       
endfunction

//Declaracion del puerto de analisis para conexion con el scoreboard
uvm_analysis_port #(detector_item) mon_analysis_port;

//Declaracion de la interfaz virtual de conexion con el DUT
virtual detector_if vif;

//Fase de construccion
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //Busca la interfaz en la base de datos de configuracion
    if (!uvm_config_db#(virtual detector_if)::get(this, "", "detector_vif", vif))
        `uvm_fatal("MON", "No se pudo encontrar la vif")
    
    //Instancia el puerto de analysis
    mon_analysis_port = new ("mon_analysis_port", this);
endfunction

//Fase de corrida
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        @(vif.cb);
        if (vif.rstn) begin
            //Instanciacion del objeto de transaccion a traves de la fabrica
            detector_item item = detector_item::type_id::create("item");

            //Conecta el DUT con la interfaz
            item.in = vif.in;
            item.out = vif.cb.out;

            //Envia la transaccion al scoreboard a traves del puerto de analisis
            mon_analysis_port.write(item);

            //Imprime la transaccion a checkear
            `uvm_info("MON", $sformatf("La transaccion a revisar es %s", item.convert2str()), UVM_HIGH)
        end
    end
endtask
endclass 