//Test generalizado para cualquier patrón de 4 bits
class test extends uvm_test;

    //Inclusion en la fabrica
    `uvm_component_utils(test)
    
    //Declaracion explicita del constructor
    function new(string name="test", uvm_component parent=null);
        super.new(name,parent);
    endfunction
    
    //Instanciacion del ambiente
    env e0;
    
    //Patrón a detectar
    bit [3:0] patron= 4'b1011;
    
    
    //Declaracion de la secuencia
    gen_item_seq seq;
    
    //Interfaz virtual
    virtual detector_if vif;
    
    //Fase de construccion
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        //Instanciacion del ambiente a traves de la fabrica
        e0= env::type_id::create("e0", this);
    
        //Busca la interfaz virtual en la base de datos de configuracion
        if (!uvm_config_db#(virtual detector_if)::get(this, "", "detector_vif", vif))
            `uvm_fatal("TEST", "No se pudo encontrar la vif")
        
        uvm_config_db#(virtual detector_if)::set(this, "e0.a0.*", "detector_vif", vif);
    
        //Se incluye el patron a detectar en la base de datos de configuracion
          uvm_config_db#(bit [3:0])::set(this, "*", "referencia", patron);
    
        //Crea una secuencia y la randomiza
        seq = gen_item_seq::type_id::create("seq");
        seq.randomize();
    endfunction
    
    //Fase de corrida
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        apply_reset();
        seq.start(e0.a0.s0);
        #200;
        phase.drop_objection(this);
    endtask
    
    virtual task apply_reset();
        vif.rstn <= 0;
        vif.in <= 0;
        repeat(5) @(posedge vif.clk);
        vif.rstn <= 1;
        repeat (10) @(posedge vif.clk);
    endtask
    endclass
    
    //Test específico para el patron 1011
    class test_spec extends test;
        //Inclusion en la fabrica
      `uvm_component_utils(test_spec)
    
        //Declaracion explicita del constructor
        function new(string name="test_1011", uvm_component parent=null);
            super.new(name,parent);
        endfunction
    
        //Fase de construccion
        virtual function void build_phase(uvm_phase phase);
            patron= 4'b1011;
            super.build_phase(phase);
          seq.randomize() with {num inside {[300:500]}; };
        endfunction
    endclass 