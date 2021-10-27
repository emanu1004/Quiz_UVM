class detector_item extends uvm_sequence_item;
    rand bit    in;
    bit         out;
    
    
    //Inclusión en la fábrica 
    `uvm_object_utils_begin(detector_item)
        `uvm_field_int(in, UVM_DEFAULT)
        `uvm_field_int(out, UVM_DEFAULT)
    `uvm_object_utils_end
    
    //Declaración explícita del constructor
    function new (string name = "detector_item");
        super.new(name);
    endfunction
    
    //Función para mostrar el contenido en formato string
    virtual function string convert2str();
        return $sformatf("in=0%d, out=0%d", in, out);
    endfunction 
      
      constraint c1 {in dist {0:/20, 1:/80};}
    
    endclass 
