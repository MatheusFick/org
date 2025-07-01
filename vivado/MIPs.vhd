library IEEE;
  use IEEE.STD_LOGIC_1164.all;
library work;
  use IEEE.NUMERIC_STD.all;

entity MIPs is
  port (
    clk   : in std_logic;
    rst_n : in std_logic
  );

end entity;

architecture rtl of MIPs is

  signal pc_enable_lg   : std_logic;
  signal mem_write_lg   : std_logic;
  signal mem_read_lg    : std_logic;
  signal branch_lg      : std_logic;
  signal addr_sel_lg    : std_logic;
  signal r_sel_lg       : std_logic;
  signal ir_enable_lg   : std_logic;
  signal op_ULA_lg      : std_logic_vector(1 downto 0);
  signal reg_write_lg   : std_logic;
  signal f_zero_lg      : std_logic;
  signal f_neg_lg       : std_logic;
  signal opcode_lg      : std_logic_vector(3 downto 0);
  signal data_in_lg     : std_logic_vector(15 downto 0);
  signal data_out_lg    : std_logic_vector(15 downto 0);
  signal addr_lg        : std_logic_vector(7 downto 0);
  signal data_out_instr : std_logic_vector(15 downto 0); -- Saída da memória de instruções
begin

  control_unit: entity work.control_unit
    port map (
      rst_n     => rst_n,
      clk       => clk,
      mem_write => mem_write_lg,
      mem_read  => mem_read_lg,
      branch    => branch_lg,
      addr_sel  => addr_sel_lg,
      r_sel     => r_sel_lg,
      pc_enable => pc_enable_lg,
      ir_enable => ir_enable_lg,
      op_ULA    => op_ULA_lg,
      reg_write => reg_write_lg,
      f_zero    => f_zero_lg,
      f_neg     => f_neg_lg,
      opcode    => opcode_lg
    );

  datapath: entity work.datapath
    port map (
      rst_n     => rst_n,
      clk       => clk,
      data_in   => data_in_lg,
      data_out  => data_out_lg,
      data_out_instr => data_out_instr,
      addr      => addr_lg,
      branch    => branch_lg,
      addr_sel  => addr_sel_lg,
      r_sel     => r_sel_lg,
      pc_enable => pc_enable_lg,
      ir_enable => ir_enable_lg,
      op_ULA    => op_ULA_lg,
      reg_write => reg_write_lg,
      flag_zero => f_zero_lg,
      flag_neg  => f_neg_lg,
      opcode    => opcode_lg
    );

  instr_mem: entity work.mem
    port map (
      clk     => clk,
      rst_n   => rst_n,
      out_mem => data_out_instr,  -- Sinal para saída da memória de instruções
      in_mem  => data_in_lg,
      read    => '1',             -- Sempre habilitada para leitura
      write   => mem_write_lg,             -- Nunca habilitada para escrita
      end_mem => addr_lg -- PC fornece o endereço para a memória de instruções
    );

  data_mem: entity work.mem
    port map (
      clk     => clk,
      rst_n   => rst_n,
      out_mem => data_out_lg, -- Saída da memória de dados
      in_mem  => data_in_lg,  -- Entrada da memória de dados
      read    => mem_read_lg,
      write   => mem_write_lg,
      end_mem => addr_lg -- Endereço fornecido pelo datapath
    );

end architecture;
