class scoreboard extends uvm_scoreboard;

  //Inclusion en la fabrica
  `uvm_component_utils(scoreboard)
  
  //Declaracion explicita del constructor
  function new (string name="scoreboard", uvm_component parent=null);
      super.new(name,parent);
  endfunction
  
  //Variables para la revision
  bit[3:0] referencia;      	//Entrada de referencia
  bit[3:0] actual;          	//Entrada actual
  bit esperado;   			//Salida esperada
  
  
  //Declaracion del puerto de analisis para conexion con el monitor
    uvm_analysis_imp #(detector_item, scoreboard) mon_analysis_imp;
  
  //Fase de construccion 
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
  
      //Instanciacion del puerto de analisis
      mon_analysis_imp = new("mon_analysis_imp", this);
  
      //Busca la entrada de referencia en la base de datos de configuracion
    if (!uvm_config_db#(bit[3:0])::get(this, "*", "referencia", referencia))
          `uvm_fatal("SCB", "No se pudo encontrar la entrada de referencia")
  endfunction
  
  //Funcion de write que checkea si el resultado obtenido fue el esperado o no
  virtual function write (detector_item item);
      actual = actual << 1 | item.in;
  
  
      //Imprime el los resultados que se van a verificar
      `uvm_info("SCBD", $sformatf("in=0%d out=0%d ref=0b%0b act=0b%0b", item.in, item.out, referencia, actual),UVM_LOW)
  
      //Si la salida no coincide con la salida esperada, se imprime un error
      if (item.out != esperado) begin
        `uvm_error("SCBD", $sformatf("ERROR salida=%0d esperado=%0d", item.out, esperado))
  
      //Si la salida concide, se imprime un pass
      end else begin
        `uvm_info("SCBD", $sformatf("PASS salida=%0d esperado=%0d", item.out, esperado), UVM_HIGH)
      end
  
  
      //Este ciclo se encarga de verificar si el patron se encontró o no y configurar la salida esperada con base en eso
      if (!(referencia ^ actual)) begin //Si ambos coinciden, el XOR debe ser 0
        `uvm_info("SCBD", $sformatf("El patrón coincide, la salida esperada es 1"), UVM_LOW)
          esperado=1;
      end else begin
          esperado=0;
      end
  endfunction
  
  endclass
  