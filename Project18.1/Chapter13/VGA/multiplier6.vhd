-- megafunction wizard: %LPM_MULT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: lpm_mult 

-- ============================================================
-- File Name: multiplier6.vhd
-- Megafunction Name(s):
-- 			lpm_mult
--
-- Simulation Library Files(s):
-- 			lpm
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 18.1.0 Build 625 09/12/2018 SJ Lite Edition
-- ************************************************************


--Copyright (C) 2018  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.all;

ENTITY multiplier6 IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END multiplier6;


ARCHITECTURE SYN OF multiplier6 IS

	SIGNAL sub_wire0_bv	: BIT_VECTOR (2 DOWNTO 0);
	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (9 DOWNTO 0);



	COMPONENT lpm_mult
	GENERIC (
		lpm_hint		: STRING;
		lpm_representation		: STRING;
		lpm_type		: STRING;
		lpm_widtha		: NATURAL;
		lpm_widthb		: NATURAL;
		lpm_widthp		: NATURAL
	);
	PORT (
			dataa	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			datab	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			result	: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	sub_wire0_bv(2 DOWNTO 0) <= "110";
	sub_wire0    <= To_stdlogicvector(sub_wire0_bv);
	result    <= sub_wire1(9 DOWNTO 0);

	lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 7,
		lpm_widthb => 3,
		lpm_widthp => 10
	)
	PORT MAP (
		dataa => dataa,
		datab => sub_wire0,
		result => sub_wire1
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: AutoSizeResult NUMERIC "1"
-- Retrieval info: PRIVATE: B_isConstant NUMERIC "1"
-- Retrieval info: PRIVATE: ConstantB NUMERIC "6"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
-- Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "0"
-- Retrieval info: PRIVATE: Latency NUMERIC "0"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: SignedMult NUMERIC "0"
-- Retrieval info: PRIVATE: USE_MULT NUMERIC "1"
-- Retrieval info: PRIVATE: ValidConstant NUMERIC "1"
-- Retrieval info: PRIVATE: WidthA NUMERIC "7"
-- Retrieval info: PRIVATE: WidthB NUMERIC "3"
-- Retrieval info: PRIVATE: WidthP NUMERIC "10"
-- Retrieval info: PRIVATE: aclr NUMERIC "0"
-- Retrieval info: PRIVATE: clken NUMERIC "0"
-- Retrieval info: PRIVATE: new_diagram STRING "1"
-- Retrieval info: PRIVATE: optimize NUMERIC "0"
-- Retrieval info: LIBRARY: lpm lpm.lpm_components.all
-- Retrieval info: CONSTANT: LPM_HINT STRING "INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"
-- Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "UNSIGNED"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
-- Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "7"
-- Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "3"
-- Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "10"
-- Retrieval info: USED_PORT: dataa 0 0 7 0 INPUT NODEFVAL "dataa[6..0]"
-- Retrieval info: USED_PORT: result 0 0 10 0 OUTPUT NODEFVAL "result[9..0]"
-- Retrieval info: CONNECT: @dataa 0 0 7 0 dataa 0 0 7 0
-- Retrieval info: CONNECT: @datab 0 0 3 0 6 0 0 3 0
-- Retrieval info: CONNECT: result 0 0 10 0 @result 0 0 10 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL multiplier6.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL multiplier6.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL multiplier6.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL multiplier6.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL multiplier6_inst.vhd FALSE
-- Retrieval info: LIB_FILE: lpm
