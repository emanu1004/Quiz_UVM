class gen_item_seq extends uvm_sequence;

//Inclusión en la fábrica
`uvm_object_utils(gen_item_seq)

//Declaración explícita del constructor
  function new (string name = "gen_item_seq");
    super.new(name);
endfunction

rand int num; //Numero de items para ser enviados

  constraint c1 {soft num inside {[10:50]}; }//Restricción para el numero de items

virtual task body();
  for (int i=0; i<num; i++) begin
        //Instancia el objeto de transaccion a traves de la fabrica
        detector_item m_item = detector_item::type_id::create("m_item");
        start_item(m_item);

        //Randomiza el objeto e imprime su contenido 
        m_item.randomize();
    `uvm_info("SEQ", $sformatf("Se genero un nuevo item: ", m_item.convert2str()), UVM_HIGH)
        finish_item(m_item);
    end

    `uvm_info("SEQ", $sformatf("Se han generado %0d items", num), UVM_LOW)
    
endtask


endclass