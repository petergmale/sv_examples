class abc_patt_seq extends uvm_sequence;

  rand int abs_dur_max;
  rand int max_dur;
  rand int min_dur;
  rand bit [abc_structs_pkg::IPR_patt_WIDTH-1:0] init_bus_val;
  rand bit [abc_structs_pkg::IPR_patt_WIDTH-1:0] bus_val;
  int unsigned max_bus_range;

  `uvm_object_utils(abc_patt_seq)
  //`uvm_declare_p_sequencer(abc_vsequencer)

  function new(string name="");
    super.new(name);

    // temp; replace with constraints
    abs_dur_max = 4000;
    max_dur = 200;
    min_dur = 20; 
    init_bus_val = '0; 
    max_bus_range = {abc_structs_pkg::IPR_patt_WIDTH{1'b1}};
  endfunction

  task body();
    int dur_cnt;

    abc_structs_pkg::ipr_patt_seq_t seq =
      abc_structs_pkg::ipr_patt_seq_t::type_id::create("seq");

    // Load up transactions
    //seq.async = 1;
    seq.add_transition_bits(init_bus_val, 0); 

    dur_cnt = 0;
    while(1) begin
      int dur;
      bit [abc_structs_pkg::IPR_patt_WIDTH-1:0] val;

      dur = $urandom_range(max_dur, min_dur);
      val = $urandom_range(max_bus_range, 0); 

      dur_cnt += dur;
      if(dur_cnt >= abs_dur_max)
        break;
      seq.add_transition_bits(val, dur);
    end 
    seq.start(m_sequencer);

  endtask : body

endclass : abc_patt_seq
