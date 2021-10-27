class driver extends uvm_driver #(detector_item);

    //Inclusion del objeto en la fabrica
    `uvm_component_utils(driver)
  
    //Declaracion explicita del objeto
    function new (string name= "driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    //Declaración de la interfaz virtual de conexion con el DUT
    virtual detector_if vif;
  
    //Fase de construcción
    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
  
        //Busca la interfaz en la base de datos de configuracion
        if (!uvm_config_db#(virtual detector_if)::get(this, "", "detector_vif", vif))
            `uvm_fatal("DRV", "No se pudo encontrar la vif")
    endfunction
  
    //Fase de corrida
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            //Declaracion del handler del objeto de transaccion
            detector_item m_item;
  
            //Espera por una transaccion a traves del puerto TLM
            `uvm_info("DRV", $sformatf("Espera por un item del secuenciador"), UVM_LOW)
            seq_item_port.get_next_item(m_item);
            drive_item(m_item);
  
            //Notifica que recibio el item para completar el handshake
            seq_item_port.item_done();
        end
      endtask
      
    //Inicializa las señales de la interfaz para conectarla al DUT
    virtual task drive_item(detector_item m_item);
        @(vif.cb);
            vif.cb.in <= m_item.in;    
    endtask
  endclass