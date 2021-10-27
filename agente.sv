class agent extends uvm_agent;

//Inclusion en la fabrica
`uvm_component_utils(agent)

//Declracion explicita del constructor
function new (string name="agent", uvm_component parent=null);
    super.new(name,parent);
endfunction


//Declaracion de los modulos del agente
driver d0;
monitor m0;
uvm_sequencer #(detector_item) s0;

//Fase de construccion
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //Instanciacion de los modulos del agente
    s0 = uvm_sequencer #(detector_item)::type_id::create("s0", this);
    d0 = driver::type_id::create("d0", this);
    m0 = monitor::type_id::create ("m0", this);
endfunction

//Fase de conexion
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //Conecta el secuenciador con el driver
    d0.seq_item_port.connect(s0.seq_item_export);
endfunction
endclass