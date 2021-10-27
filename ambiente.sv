class env extends uvm_env;
//Inclusion en la fabrica
`uvm_component_utils(env)

//Declaracion explicita del constructor
function new (string name="env", uvm_component parent=null);
    super.new(name,parent);
endfunction

//Declaracion de los módulos del ambiente
agent a0;
scoreboard s0;

//Fase de construccion
virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
    
	//Instaciacion de los modulos del ambiente a traves de al fabrica
    a0 = agent::type_id::create("a0", this);
    s0= scoreboard::type_id::create("s0", this);
endfunction

//Fase de conexion, se conecta el monitor del agente al scoreboard del ambiente a traves del puerto de analisis
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_analysis_port.connect(s0.mon_analysis_imp);
endfunction
endclass