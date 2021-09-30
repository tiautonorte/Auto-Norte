#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ RFIS001  ³ Autor ³ Italo Maciel    ³ Data ³ 12.03.18       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Geral NF Fiscal							      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RFIS001()

	Local oReport
	Local cAlias  := GetNextAlias()

	Private cPerg := "RFIS001"

	CriaSx1(cPerg)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()

Return

Static Function ReportDef(cAlias,cPerg)

	Local oReport  
	Local oSection1
	Local oBreak1

	oReport := TReport():New("RFIS001","Relatorio Geral NF Fiscal",cPerg,{|oReport| ReportPrt(oReport,@cAlias)},"")
	oReport:SetLandscape()
	oReport:lParamPage := .F.

	Pergunte(cPerg, .T.)

	oSection1 := TRSection():New(oReport,"Notas",,)

	If MV_PAR06 == 1    //Sintético

		TRCell():New(oSection1,"F3_FILIAL" 	,,"Filial"			,,TamSX3("F3_FILIAL")[1],.F.,)
		TRCell():New(oSection1,"F3_ENTRADA"	,,"Dt. Entrada"		,,10,.F.,)
		TRCell():New(oSection1,"F3_NFISCAL"	,,"Nota"			,,TamSX3("F3_NFISCAL")[1],.F.,)
		TRCell():New(oSection1,"F3_CHVNFE"	,,"Chave NF"		,,TamSX3("F3_CHVNFE")[1],.F.,)
		TRCell():New(oSection1,"F3_ESTADO"	,,"UF"				,,TamSX3("F3_ESTADO")[1],.F.,)
		TRCell():New(oSection1,"F3_TIPO"    ,,"Tipo"			,,TamSX3("F3_TIPO")[1],.F.,)
		TRCell():New(oSection1,"F3_VALCONT" ,,"Valor Contabil"	,,TamSX3("F3_VALCONT")[1],.F.,)
		TRCell():New(oSection1,"F3_CLIEFOR" ,,"Cli/For"			,,TamSX3("F3_CLIEFOR")[1],.F.,)
		TRCell():New(oSection1,"F3_LOJA"    ,,"Loja"			,,TamSX3("F3_LOJA")[1],.F.,)
		TRCell():New(oSection1,"F3_BASEICM" ,,"Base Icms"		,,TamSX3("F3_BASEICM")[1],.F.,)
		TRCell():New(oSection1,"F3_VALICM"  ,,"Valor Icms"		,,TamSX3("F3_VALICM")[1],.F.,)
		TRCell():New(oSection1,"F3_ISENICM" ,,"Isento Icms"		,,TamSX3("F3_ISENICM")[1],.F.,)
		TRCell():New(oSection1,"F3_OUTRICM" ,,"Outros Icms"		,,TamSX3("F3_OUTRICM")[1],.F.,)
		TRCell():New(oSection1,"F3_ALIQICM" ,,"Aliq Icms"		,,TamSX3("F3_ALIQICM")[1],.F.,)
		TRCell():New(oSection1,"F3_BASEIPI" ,,"Base Ipi"		,,TamSX3("F3_BASEIPI")[1],.F.,)
		TRCell():New(oSection1,"F3_VALIPI"  ,,"Valor Ipi"		,,TamSX3("F3_VALIPI")[1],.F.,)
		TRCell():New(oSection1,"F3_ISENIPI" ,,"Isento Ipi"		,,TamSX3("F3_ISENIPI")[1],.F.,)
		TRCell():New(oSection1,"F3_OUTRIPI" ,,"Outros Ipi"		,,TamSX3("F3_OUTRIPI")[1],.F.,)
		TRCell():New(oSection1,"F3_ALIQIPI" ,,"Aliq Ipi"		,,TamSX3("F3_ALIQIPI")[1],.F.,)
		TRCell():New(oSection1,"F3_BASERET" ,,"Base Ret."		,,TamSX3("F3_BASERET")[1],.F.,)
		TRCell():New(oSection1,"F3_ICMSRET" ,,"Icms Ret."		,,TamSX3("F3_ICMSRET")[1],.F.,)
		TRCell():New(oSection1,"F3_OBSERV"  ,,"Observação"		,,TamSX3("F3_OBSERV")[1],.F.,)
		TRCell():New(oSection1,"F3_DTCANC"  ,,"Data Canc."		,,10,.F.,)
		TRCell():New(oSection1,"GRUPO"		,,"Cli Grp Trib"	,,TamSX3("A1_GRPTRIB")[1],.F.,)
		TRCell():New(oSection1,"TIPO"		,,"Tipo Cli/For"	,,TamSX3("A1_TIPO")[1]	,.F.,)
		TRCell():New(oSection1,"CGC"		,,"CPF"				,,18					,.F.,)
		TRCell():New(oSection1,"F3_NRLIVRO" ,,"Nr. Livro"		,,TamSX3("F3_NRLIVRO")[1],.F.,)
		TRCell():New(oSection1,"F3_ESPECIE" ,,"Especie"			,,TamSX3("F3_ESPECIE")[1],.F.,)
		TRCell():New(oSection1,"F3_DESPESA" ,,"Despesa"			,,TamSX3("F3_DESPESA")[1],.F.,)
		TRCell():New(oSection1,"F3_CPPRODE" ,,"Crd. Prodepe"	,,TamSX3("F3_CPPRODE")[1],.F.,)
		TRCell():New(oSection1,"F3_TPPRODE" ,,"Tp. Prodepe"		,,TamSX3("F3_TPPRODE")[1],.F.,)
		TRCell():New(oSection1,"F3_ANTICMS" ,,"Antec. Icms"		,,TamSX3("F3_ANTICMS")[1],.F.,)
		TRCell():New(oSection1,"F3_CSTPIS"  ,,"Class PIS"		,,TamSX3("F3_CSTPIS")[1],.F.,)
		TRCell():New(oSection1,"F3_CSTCOF"  ,,"Class COFINS"	,,TamSX3("F3_CSTCOF")[1],.F.,)
		TRCell():New(oSection1,"F3_ICMSCOM" ,,"Icms Comp."		,,TamSX3("F3_ICMSCOM")[1],.F.,)
		TRCell():New(oSection1,"F3_ICMSDIF" ,,"Icms Dif."		,,TamSX3("F3_ICMSDIF")[1],.F.,)
		TRCell():New(oSection1,"F3_VALFECP" ,,"Val. Fecoep"		,,TamSX3("F3_VALFECP")[1],.F.,)
		TRCell():New(oSection1,"F3_DIFAL"   ,,"Difal"			,,TamSX3("F3_DIFAL")[1],.F.,)	

		oBreak1 := TRBreak():New(oSection1,{|| (cAlias)->(F3_FILIAL) },"Totais:",.F.)

		TRFunction():New(oSection1:Cell("F3_VALCONT")	, "TOT1", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_VALICM")	, "TOT2", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_VALIPI")	, "TOT3", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_ICMSRET")	, "TOT4", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_VALFECP")	, "TOT9", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_DIFAL")		, "TOT13", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("F3_CPPRODE")	, "TOT14", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)

	Else     // Analítico

		TRCell():New(oSection1,"FT_FILIAL" 	,,"Filial"					,,TamSX3("FT_FILIAL")[1],.F.,)
		TRCell():New(oSection1,"FT_EMISSAO"	,,"Dt.Emissao"				,,10,.F.,)		
		TRCell():New(oSection1,"FT_ENTRADA"	,,"Dt.Entrada"				,,10,.F.,)	
		TRCell():New(oSection1,"FT_ESPECIE"	,,"Especie"					,,TamSX3("FT_ESPECIE")[1],.F.,)
		TRCell():New(oSection1,"FT_TIPO" 	,,"Tipo"					,,TamSX3("FT_TIPO")[1],.F.,)
		TRCell():New(oSection1,"FT_CHVNFE"	,,"Chave NF"				,,TamSX3("FT_CHVNFE")[1],.F.,)
		TRCell():New(oSection1,"FT_NFISCAL"	,,"Nota"					,,TamSX3("FT_NFISCAL")[1],.F.,)	
		TRCell():New(oSection1,"FT_SERIE"	,,"Serie"					,,TamSX3("FT_SERIE")[1],.F.,)
		TRCell():New(oSection1,"FT_CLIEFOR"	,,"Cli/For"					,,TamSX3("FT_CLIEFOR")[1],.F.,)
		TRCell():New(oSection1,"FT_LOJA" 	,,"Loja"					,,TamSX3("FT_LOJA")[1],.F.,)
		TRCell():New(oSection1,"A1_NOME"	,,"Razao Social"			,,TamSX3("A1_NOME")[1],.F.,)
		TRCell():New(oSection1,"A1_TIPO"	,,"Tipo Cli/For"			,,TamSX3("A1_TIPO")[1],.F.,)
		TRCell():New(oSection1,"FT_ESTADO" 	,,"UF"						,,TamSX3("FT_ESTADO")[1],.F.,)		
		TRCell():New(oSection1,"A1_GRPTRIB"	,,"Cli Grp Trib"			,,TamSX3("A1_GRPTRIB")[1],.F.,)
		TRCell():New(oSection1,"TIPOPER"	,,"Oper"					,,TamSX3("D2_XOPER")[1]	,.F.,)
		TRCell():New(oSection1,"B1_GRTRIB"	,,"Prod Grp Trib"			,,TamSX3("B1_GRTRIB")[1],.F.,)
		TRCell():New(oSection1,"B1_GRPTI"	,,"Grupo - TI"				,,TamSX3("B1_GRPTI")[1],.F.,)
		TRCell():New(oSection1,"FT_TES"		,,"TES"						,,TamSX3("D2_TES")[1],.F.,)
		TRCell():New(oSection1,"FT_CFOP" 	,,"CFOP"					,,TamSX3("FT_CFOP")[1],.F.,)
		TRCell():New(oSection1,"FT_CLASFIS"	,,"Clas. Fis."				,,TamSX3("FT_CLASFIS")[1],.F.,)
		TRCell():New(oSection1,"FT_POSIPI"	,,"NCM"						,,TamSX3("FT_POSIPI")[1],.F.,)
		TRCell():New(oSection1,"B1_EX_NCM"	,,"EX da TIPI"				,,TamSX3("B1_EX_NCM")[1],.F.,)		
		TRCell():New(oSection1,"FT_PRODUTO"	,,"Produto"					,,TamSX3("FT_PRODUTO")[1],.F.,)
		TRCell():New(oSection1,"B1_DESC"	,,"Desc. Produto"			,,TamSX3("B1_DESC")[1],.F.,)
		TRCell():New(oSection1,"FT_QUANT" 	,,"Quantidade"				,,TamSX3("FT_QUANT")[1],.F.,)
		TRCell():New(oSection1,"FT_PRCUNIT"	,,"Prc Unit."				,,TamSX3("FT_PRCUNIT")[1],.F.,)
		TRCell():New(oSection1,"TOTLIQ"	    ,,"Total do Item" 			,,TamSX3("FT_TOTAL")[1],.F.,)
		TRCell():New(oSection1,"ICMSPAUT"   ,,"Icms Pauta"	 			,,TamSX3("B1_VLR_ICM")[1],.F.,)
		
		TRCell():New(oSection1,"D1BASEICM"  ,,"Base ICMS NF" 			,,TamSX3("D1_BASEICM")[1],.F.,)
		TRCell():New(oSection1,"D1PICM"	    ,,"Aliq ICMS NF" 			,,TamSX3("D1_PICM")[1],.F.,)
		TRCell():New(oSection1,"D1VALICM"   ,,"Valor ICMS NF" 			,,TamSX3("D1_VALICM")[1],.F.,)

		TRCell():New(oSection1,"FT_DESPESA"	,,"Desp Acess "      		,,TamSX3("FT_DESPESA")[1],.F.,)
		TRCell():New(oSection1,"FRETEXML"	,,"Vlr Frete (XML)"    		,,TamSX3("FT_FRETE")[1],.F.,)
		TRCell():New(oSection1,"VAL_IPI" 	,,"Valor IPI NF" 			,,TamSX3("FT_VALIPI")[1],.F.,) 
		TRCell():New(oSection1,"FT_MARGEM"	,,"MVA NF"					,,TamSX3("FT_MARGEM")[1],.F.,)
		TRCell():New(oSection1,"FT_BASERET"	,,"Base ST NF"				,,TamSX3("FT_BASERET")[1],.F.,)
		TRCell():New(oSection1,"FT_ALIQSOL"	,,"Aliq. ST NF"				,,TamSX3("D1_ALIQSOL")[1],.F.,)
		TRCell():New(oSection1,"F4_INCSOL"	,,"Agrega ST"   		  	,,TamSX3("F4_INCSOL")[1],.F.,)        
		TRCell():New(oSection1,"ICMS_ST_AGS",,"ST DANFE (AGREG SIM)"	,,TamSX3("FT_ICMSRET")[1],.F.,)
		TRCell():New(oSection1,"ICMS_ST_AGN",,"ST PG AN (AGREG NAO)"	,,TamSX3("FT_ICMSRET")[1],.F.,)

		TRCell():New(oSection1,"FT_ALFCPST"	,,"Aliq. FCP ST"			,,TamSX3("FT_ALFCPST")[1],.F.,)
		TRCell():New(oSection1,"FT_VFECPST"	,,"Valor FCP ST"			,,TamSX3("FT_VFECPST")[1],.F.,)
		TRCell():New(oSection1,"CTERATEIO"	,,"CTE Rateio"	    		,,TamSX3("FT_FRETE")[1],.F.,)
		TRCell():New(oSection1,"CTERATICM"	,,"CTE Rateio ICMS"    		,,TamSX3("FT_FRETE")[1],.F.,)
		TRCell():New(oSection1,"DIF_ST_CTE"	,,"DIF ST CTE-PG AUTO" 		,,TamSX3("FT_FRETE")[1],.F.,)
		TRCell():New(oSection1,"STREGRAG"	,,"ST Regra Geral MVA"		,,TamSX3("D1_MARGEM")[1],.F.,)
		TRCell():New(oSection1,"ICMS_ST_GER",,"ST Regra Geral Valor"	,,TamSX3("FT_ICMSRET")[1],.F.,)
		
		TRCell():New(oSection1,"BC_FEEF"	,,"BC FEEF"					,,TamSX3("FT_ICMSRET")[1],.F.,) //Verificar com Tereza
		TRCell():New(oSection1,"VL_FEEF"	,,"FEEF Valor"				,,TamSX3("FT_ICMSRET")[1],.F.,) //Verificar com Tereza

		TRCell():New(oSection1,"FT_OBSERV" 	,,"Observação"				,,TamSX3("FT_OBSERV")[1],.F.,)
		TRCell():New(oSection1,"MVA_CALC"	,,"MVA Calculado"			,,TamSX3("D1_MARGEM")[1],.F.,)
		TRCell():New(oSection1,"IMP_CALC"	,,"Imposto Calculado"		,,TamSX3("FT_ICMSRET")[1],.F.,)
		TRCell():New(oSection1,"FT_NRLIVRO"	,,"Nr. Livro"				,,TamSX3("FT_NRLIVRO")[1],.F.,)
		TRCell():New(oSection1,"FT_CFOP2" 	,,"CFOP"					,,TamSX3("FT_CFOP")[1],.F.,)
		TRCell():New(oSection1,"FT_VALCONT"	,,"Valor Contabil"			,,TamSX3("FT_VALCONT")[1],.F.,)
		TRCell():New(oSection1,"FT_BASEICM"	,,"Base ICMS"	  			,,TamSX3("FT_BASEICM")[1],.F.,)
		TRCell():New(oSection1,"FT_ALIQICM"	,,"Aliq ICMS"				,,TamSX3("FT_ALIQICM")[1],.F.,)	
		TRCell():New(oSection1,"FT_VALICM" 	,,"Valor ICMS"				,,TamSX3("FT_VALICM")[1],.F.,)	        
		TRCell():New(oSection1,"FT_ISENICM"	,,"Isento ICMS"				,,TamSX3("FT_ISENICM")[1],.F.,)	
		TRCell():New(oSection1,"FT_OUTRICM"	,,"Outros ICMS"				,,TamSX3("FT_OUTRICM")[1],.F.,)
		TRCell():New(oSection1,"FT_TPPRODE"	,,"Tp. Prodepe"				,,TamSX3("FT_TPPRODE")[1],.F.,)
		TRCell():New(oSection1,"FT_CPPRODE"	,,"Crd. Prodepe"			,,TamSX3("FT_CPPRODE")[1],.F.,)
		TRCell():New(oSection1,"FT_ALQFECP"	,,"Aliq. FECOEP"			,,TamSX3("FT_ALQFECP")[1],.F.,)	
		TRCell():New(oSection1,"FT_VALFECP"	,,"Valor FECOEP"			,,TamSX3("FT_VALFECP")[1],.F.,)
		TRCell():New(oSection1,"FT_DIFAL" 	,,"DIFAL"					,,TamSX3("FT_DIFAL")[1],.F.,)        
		TRCell():New(oSection1,"FT_ICMSCOM"	,,"ICMS Comp."				,,TamSX3("FT_ICMSCOM")[1],.F.,)	
		TRCell():New(oSection1,"FT_ICMSDIF"	,,"ICMS Dif."				,,TamSX3("FT_ICMSDIF")[1],.F.,)
		TRCell():New(oSection1,"FT_ANTICMS"	,,"Antec. ICMS"				,,TamSX3("FT_ANTICMS")[1],.F.,)

		TRCell():New(oSection1,"FT_CFOP3" 	,,"CFOP"					,,TamSX3("FT_CFOP")[1],.F.,)
		TRCell():New(oSection1,"FT_CSTPIS" 	,,"Cst PIS"					,,TamSX3("FT_CSTPIS")[1],.F.,)
		TRCell():New(oSection1,"FT_CSTCOF" 	,,"Cst COFINS"				,,TamSX3("FT_CSTCOF")[1],.F.,)
		TRCell():New(oSection1,"FT_BASEPIS"	,,"Base PIS"				,,TamSX3("FT_BASEPIS")[1],.F.,)         
		TRCell():New(oSection1,"FT_BASECOF"	,,"Base COFINS"				,,TamSX3("FT_BASECOF")[1],.F.,)	
		TRCell():New(oSection1,"FT_ALIQPIS"	,,"Aliq. PIS"				,,TamSX3("FT_ALIQPIS")[1],.F.,)
		TRCell():New(oSection1,"FT_VALPIS" 	,,"Valor PIS"				,,TamSX3("FT_VALPIS")[1],.F.,)	
		TRCell():New(oSection1,"FT_ALIQCOF"	,,"Aliq. COFINS"			,,TamSX3("FT_ALIQCOF")[1],.F.,)	
		TRCell():New(oSection1,"FT_VALCOF" 	,,"Valor COFINS"			,,TamSX3("FT_VALCOF")[1],.F.,)
		TRCell():New(oSection1,"CUSTO"	 	,,"Custo"					,,TamSX3("D1_CUSTO")[1],.F.,)

		TRCell():New(oSection1,"NATUREZ"	,,"Natureza"				,,TamSX3("E1_NATUREZ")[1],.F.,)
		TRCell():New(oSection1,"ED_DESCRIC"	,,"Descr Natureza"			,,TamSX3("ED_DESCRIC")[1],.F.,)
		TRCell():New(oSection1,"A1_CGC"		,,"CNPJ/CPF"				,,18					,.F.,)

		If ValType(MV_PAR04) == "N"
			If MV_PAR04 == 1
				MV_PAR04 := 'E'
			ElseIf MV_PAR04 == 2
				MV_PAR04 := 'S'
			ElseIf MV_PAR04 == 3
				MV_PAR04 := 'A'	
			EndIf
		EndIf

		If MV_PAR04 == 'S'
			TRCell():New(oSection1,"A1_INSCR",,"Inscr. Est."			,,TamSX3("A1_INSCR")[1],.F.,)
		Else
			TRCell():New(oSection1,"A2_INSCR",,"Inscr. Est."			,,TamSX3("A2_INSCR")[1],.F.,)
		EndIf
		TRCell():New(oSection1,"FT_NFORI" 	,,"NF Orig."				,,TamSX3("FT_NFORI")[1],.F.,)	
		TRCell():New(oSection1,"FT_SERORI" 	,,"Serie Orig."				,,TamSX3("FT_SERORI")[1],.F.,)
		TRCell():New(oSection1,"FT_BASEIPI"	,,"Base IPI"				,,TamSX3("FT_BASEIPI")[1],.F.,)	
		TRCell():New(oSection1,"FT_ALIQIPI"	,,"Aliq IPI"				,,TamSX3("FT_ALIQIPI")[1],.F.,)
		TRCell():New(oSection1,"FT_CTIPI" 	,,"CST IPI"					,,TamSX3("FT_CTIPI")[1],.F.,)

		TRCell():New(oSection1,"FT_DTCANC" 	,,"Dt. Canc."				,,10,.F.,)
		TRCell():New(oSection1,"TOTALXML"	,,"Valor Total (XML)"		,,TamSX3("FT_VALCONT")[1],.F.,)
		TRCell():New(oSection1,"VLICMXML"	,,"Vlr Icm (XML)"   		,,TamSX3("FT_VALICM")[1],.F.,)
		TRCell():New(oSection1,"MARGEMXML"	,,"MVA (XML)"    			,,TamSX3("FT_MARGEM")[1],.F.,)
		TRCell():New(oSection1,"BICMSTXML"	,,"Base ST (XML)"  			,,TamSX3("FT_BASERET")[1],.F.,)
		TRCell():New(oSection1,"VLICMSTXML"	,,"Vlr ST (XML)"   			,,TamSX3("FT_ICMSRET")[1],.F.,)
		//OK
		
		If ValType(MV_PAR04) == "N"
			If MV_PAR04 == 1
				MV_PAR04 := 'E'
			ElseIf MV_PAR04 == 2
				MV_PAR04 := 'S'
			ElseIf MV_PAR04 == 3
				MV_PAR04 := 'A'	
			EndIf
		EndIf

		oBreak1 := TRBreak():New(oSection1,{|| (cAlias)->(FT_FILIAL) },"Totais:",.F.)

		TRFunction():New(oSection1:Cell("FT_VALCONT")	, "TOT1", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_VALICM")	, "TOT2", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("VAL_IPI")		, "TOT3", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.) // 18/12/2018 Item NF
		TRFunction():New(oSection1:Cell("ICMS_ST_AGS")	, "TOT4", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("ICMS_ST_AGN")	, "TOT4", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_QUANT")		, "TOT6", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_VALFECP")	, "TOT9", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_VALPIS")	, "TOT11", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_VALCOF")	, "TOT12", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_DIFAL")		, "TOT13", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_CPPRODE")	, "TOT14", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)
		TRFunction():New(oSection1:Cell("FT_VFECPST")	, "TOT18", "SUM", oBreak1,,"@E 999,999,999,999,999.99",, .F., .T.)

	EndIf

Return oReport                                                                              

Static Function ReportPrt(oReport,cAlias)

	local oSection1 := oReport:Section(1)
	local cOrdem	:= ""
	Local cQry		:= ""
	Local cProd		:= ""
	Local cLivro	:= ""
	Local cCFOP		:= ""
	Local cNCM		:= ""
	Local cUF		:= ""
	Local cNotUF	:= ""
	Local cPis		:= ""
	Local cCOF		:= ""
	Local cCF		:= ""
	Local cGrpProd	:= ""
	Local cNGrProd	:= ""
	Local cGrpCli	:= ""
	Local cNaturez	:= ""
	Local cOper		:= ""
	Local aStatus	:= {}
	Local cChave
	Local cTexto	:= ""

	cProd := ''
	If ! Empty(MV_PAR03)
		cProd := "('"+StrTran(AllTrim(MV_PAR03),";","','")+"')"
	EndIf

	cLivro := ''
	If ! Empty(MV_PAR05)
		cLivro := "('"+StrTran(AllTrim(MV_PAR05),";","','")+"')"
	EndIf

	If ValType(MV_PAR04) == "N"
		If MV_PAR04 == 1
			MV_PAR04 := 'E'
		ElseIf MV_PAR04 == 2
			MV_PAR04 := 'S'
		ElseIf MV_PAR04 == 3
			MV_PAR04 := 'A'	
		EndIf
	EndIf

	If ValType(MV_PAR06) == "N"
		MV_PAR06 := cValToChar(MV_PAR06)
	EndIf

	cCFOP := ''
	If !Empty(MV_PAR07)
		cCFOP := "('"+StrTran(AllTrim(MV_PAR07),";","','")+"')"
	EndIf

	cNCM := ''
	If !Empty(MV_PAR08)
		cNCM := "('"+StrTran(AllTrim(MV_PAR08),";","','")+"')"
	EndIf

	cUF := ''
	If !Empty(MV_PAR11)
		cUF := "('"+StrTran(AllTrim(MV_PAR11),";","','")+"')"
	EndIf

	cNotUF := ''
	If !Empty(MV_PAR12)
		cNotUF := "('"+StrTran(AllTrim(MV_PAR12),";","','")+"')"
	EndIf

	If ValType(MV_PAR15) == "N"
		If MV_PAR15 == 1
			MV_PAR15 := 'F'
		ElseIf MV_PAR15 == 2
			MV_PAR15 := 'L'
		ElseIf MV_PAR15 == 3
			MV_PAR15 := 'R'
		ElseIf MV_PAR15 == 4
			MV_PAR15 := 'S'
		ElseIf MV_PAR15 == 5
			MV_PAR15 := 'T'
		EndIf
	EndIf

	cPis := ''
	If !Empty(MV_PAR16)
		cPis := "('"+StrTran(AllTrim(MV_PAR16),";","','")+"')"
	EndIf

	cCof := ''
	If !Empty(MV_PAR17)
		cCof := "('"+StrTran(AllTrim(MV_PAR17),";","','")+"')"
	EndIf

	cCF := ''
	If !Empty(MV_PAR18)
		cCF := "('"+StrTran(AllTrim(MV_PAR18),";","','")+"')"
	EndIf

	cGrpProd := ''
	If !Empty(MV_PAR19)
		cGrpProd := "('"+StrTran(AllTrim(MV_PAR19),";","','")+"')"
	EndIf

	cNGrProd := ''
	If !Empty(MV_PAR20)
		cNGrProd := "('"+StrTran(AllTrim(MV_PAR20),";","','")+"')"
	EndIf

	cGrpCli := ''
	If !Empty(MV_PAR24)
		cGrpCli := "('"+StrTran(AllTrim(MV_PAR24),";","','")+"')"
	EndIf

	cNaturez := ''
	If !Empty(MV_PAR23)
		cNaturez := "('"+StrTran(AllTrim(MV_PAR23),";","','")+"')"
	EndIf

	cOper := ''
	If !Empty(MV_PAR29)
		cOper := "('"+StrTran(AllTrim(MV_PAR29),";","','")+"')"
	EndIf

	cEspecie := ''
	If !Empty(MV_PAR30)
		cEspecie := "('"+StrTran(AllTrim(MV_PAR30),";","','")+"')"
	EndIf

	cTipoDoc := ''
	If !Empty(MV_PAR31)
		cTipoDoc := "('"+StrTran(AllTrim(MV_PAR31),";","','")+"')"
	EndIf

	cFinalid := ''
	If !Empty(MV_PAR32)
		cFinalid := "('"+StrTran(AllTrim(MV_PAR32),";","','")+"')"
	EndIf

	oSection1:BeginQuery()

	If MV_PAR06 == '1'    // Sintético

		cQry := " SELECT "
		cQry += " F3_FILIAL			,F3_ENTRADA			,F3_NFISCAL			,F3_ESTADO			,CASE WHEN F3_TIPO = ' ' THEN 'N' ELSE F3_TIPO END F3_TIPO	,F3_ALIQICM			,F3_VALCONT			,F3_CLIEFOR
		cQry += " ,F3_LOJA			,F3_BASEICM			,F3_VALICM			,F3_ISENICM			,F3_OUTRICM			,F3_BASEIPI			,F3_VALIPI			,F3_ISENIPI
		cQry += " ,F3_OUTRIPI		,F3_ALIQIPI			,F3_BASERET			,F3_ICMSRET			,F3_OBSERV			,F3_ICMSCOM			,F3_DTCANC			,F3_ICMSDIF
		cQry += " ,F3_NRLIVRO		,F3_ESPECIE			,F3_DESPESA			,F3_CPPRODE			,F3_TPPRODE			,F3_ANTICMS			,F3_CSTPIS			,F3_CSTCOF
		cQry += " ,F3_VALFECP		,F3_DIFAL			,F3_CHVNFE "			
		cQry += " ,CASE WHEN F3_CLIENT <> ' ' THEN A1_GRPTRIB 	ELSE A2_GRPTRIB END GRUPO
		cQry += " ,CASE WHEN F3_CLIENT <> ' ' THEN A1_TIPO 		ELSE A2_TIPO 	END TIPO
		cQry += " ,CASE WHEN F3_CLIENT <> ' ' THEN A1_CGC 		ELSE A2_CGC 	END CGC		
		cQry += " FROM "+ RetSqlName("SF3") +" A "
		//If MV_PAR04 == 'S'
		cQry += " INNER JOIN "+ RetSqlName("SA1") +" B ON F3_CLIEFOR = A1_COD AND F3_LOJA = A1_LOJA "
		//ElseIf MV_PAR04 == 'E'
		cQry += " INNER JOIN "+ RetSqlName("SA2") +" B ON F3_CLIEFOR = A2_COD AND F3_LOJA = A2_LOJA "
		//EndIf
		cQry += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' " 
		cQry += " AND F3_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
		If !Empty(cOper)
			If MV_PAR04 == 'E'
				cQry += " AND (SELECT COUNT(*) FROM SD1010 Z
				cQry += " WHERE Z.D_E_L_E_T_ = ' '
				cQry += " AND D1_FILIAL = F3_FILIAL
				cQry += " AND D1_DOC = F3_NFISCAL
				cQry += " AND D1_SERIE = F3_SERIE
				cQry += " AND D1_FORNECE = F3_CLIEFOR
				cQry += " AND D1_XOPER IN "+ cOper
				cQry += " ) >= 1
			ElseIf MV_PAR04 == 'S'
				cQry += " AND (SELECT COUNT(*) FROM SD2010 Z
				cQry += " WHERE Z.D_E_L_E_T_ = ' '
				cQry += " AND D2_FILIAL = F3_FILIAL
				cQry += " AND D2_DOC = F3_NFISCAL
				cQry += " AND D2_SERIE = F3_SERIE
				cQry += " AND D2_CLIENTE = F3_CLIEFOR
				cQry += " AND D2_XOPER IN "+ cOper
				cQry += " ) >= 1
			EndIf
		EndIf
		If ! Empty(MV_PAR25) .AND. ! Empty(MV_PAR26)
			cQry += " AND F3_ENTRADA BETWEEN '"+ DTOS(MV_PAR25) +"' AND '"+ DTOS(MV_PAR26) +"' "
		EndIf
		If ! Empty(MV_PAR27) .AND. ! Empty(MV_PAR28)
			cQry += " AND F3_EMISSAO BETWEEN '"+ DTOS(MV_PAR27) +"' AND '"+ DTOS(MV_PAR28) +"' "
		EndIf
		If !Empty(cLivro)
			cQry += " AND F3_NRLIVRO IN "+ cLivro
		EndIf 
		If MV_PAR04 == 'S'
			cQry += " AND F3_CLIENT <> ' ' "
		ElseIf MV_PAR04 == 'E'
			cQry += " AND F3_CLIENT = ' ' "
		EndIf
		//Grupo Cliente
		If !Empty(cGrpCli)
			cQry += " AND A1_GRPTRIB IN "+ cGrpCli
			cQry += " AND A2_GRPTRIB IN "+ cGrpCli
		EndIf
		If !Empty(cUF)
			cQry += " AND F3_ESTADO IN "+ cUF
		EndIf
		If !Empty(cNotUF)
			cQry += " AND F3_ESTADO NOT IN "+ cNotUF
		EndIf
		If !Empty(MV_PAR13)
			cQry += " AND F3_VALICM = "+ cValToChar(MV_PAR13)
		EndIf
		If !Empty(mv_par14)
			If MV_PAR04 == 'S'
				cQry += " AND A1_CGC LIKE '"+ Alltrim(MV_PAR14) +"%' "
			ElseIf MV_PAR04 == 'E'
				cQry += " AND A2_CGC LIKE '"+ Alltrim(MV_PAR14) +"%' "
			EndIf
		EndIf
		If MV_PAR04 == 'S' .AND. !Empty(AllTrim(MV_PAR15)) .AND. MV_PAR15 <> 'T'
			cQry += " AND A1_TIPO = '"+ AllTrim(MV_PAR15) +"'"
		EndIf
		If !Empty(MV_PAR16)
			cQry += " AND F3_CSTPIS IN "+ cPis
		EndIf
		If !Empty(MV_PAR17)
			cQry += " AND F3_CSTCOF IN "+ cCOF
		EndIf
		//Especie
		If !Empty(cEspecie)
			cQry += " AND F3_ESPECIE IN "+ cEspecie
		EndIf
		//Tipo Doc
		If !Empty(cTipoDoc)
			cQry += " AND F3_TIPO IN "+ cTipoDoc
		EndIf
		//Razao
		If !Empty(mv_par22)
			cQry += " AND A1_NOME LIKE '%"+AllTrim(mv_par22)+"%' "
		EndIf
		cQry += " ORDER BY F3_FILIAL "

	Else   // Analítico

		//ALteracao Andre Minelli 06/05/2021 para considerar o campo FT_OUTRRET na formação da coluna FT_OUTRICM (chamado 11222)
		cQry := " SELECT "
		cQry += " FT_FILIAL			,FT_EMISSAO         ,FT_ENTRADA			,FT_NFISCAL			,FT_ESTADO			,FT_CFOP			,CASE WHEN FT_TIPO = ' ' THEN 'N' ELSE FT_TIPO END FT_TIPO	,FT_ALIQICM			,FT_VALCONT			,FT_CLIEFOR "
		cQry += " ,FT_LOJA			,FT_BASEICM			,FT_VALICM			,FT_ISENICM			,(FT_OUTRICM+FT_OUTRRET) as FT_OUTRICM  ,FT_BASEIPI			,FT_VALIPI			,FT_ISENIPI			,FT_OUTRIPI			,FT_SERIE "
		cQry += " ,FT_ALIQIPI		,FT_BASERET			,FT_ICMSRET			,FT_FRETE			,FT_OBSERV			,FT_DTCANC			,FT_ICMSCOM			,FT_ICMSDIF			,FT_NRLIVRO 		,FT_ITEM "
		cQry += " ,FT_ESPECIE		,FT_PRODUTO			,FT_TIPOMOV			,FT_CLASFIS			,FT_CTIPI			,FT_DESPESA			,FT_QUANT			,FT_PRCUNIT			,FT_TOTAL   "
		cQry += " ,FT_NFORI			,FT_SERORI			,FT_CPPRODE			,FT_TPPRODE			,FT_ANTICMS			,FT_CSTPIS			,FT_CSTCOF			,FT_ALIQSOL			,FT_ALQFECP "
		cQry += " ,FT_VALFECP		,FT_MARGEM			,FT_BASEPIS			,FT_ALIQPIS			,FT_VALPIS			,FT_BASECOF			,FT_ALIQCOF			,FT_VALCOF			,FT_DIFAL   "
		cQry += " ,B1_GRTRIB		,B1_GRPTI			,B1_VLR_ICM			,FT_POSIPI			,FT_TES				"
		If mv_par04 == "E"
			cQry += " ,COALESCE((SELECT DISTINCT E2_NATUREZ FROM "+ RetSqlName("SE2") +" WHERE E2_NUM = FT_NFISCAL AND E2_PREFIXO = FT_SERIE AND E2_FILIAL = FT_FILIAL AND FT_CLIEFOR = E2_FORNECE AND FT_LOJA = E2_LOJA AND D_E_L_E_T_ = ' ' AND ROWNUM <= 1),'') NATUREZ
			cQry += " ,COALESCE((SELECT DISTINCT E2_VENCTO FROM "+ RetSqlName("SE2") +" WHERE  E2_NUM = FT_NFISCAL AND E2_PREFIXO = FT_SERIE AND E2_FILIAL = FT_FILIAL AND FT_CLIEFOR = E2_FORNECE AND FT_LOJA = E2_LOJA AND D_E_L_E_T_ = ' ' AND ROWNUM <= 1),'') VENCTO
		ElseIf mv_par04 == "S"
			cQry += " ,COALESCE((SELECT DISTINCT E1_NATUREZ FROM "+ RetSqlName("SE1") +" WHERE E1_NUM = FT_NFISCAL AND E1_PREFIXO = FT_SERIE AND E1_FILIAL = FT_FILIAL AND FT_CLIEFOR = E1_CLIENTE AND FT_LOJA = E1_LOJA AND D_E_L_E_T_ = ' ' AND ROWNUM <= 1),'') NATUREZ
			cQry += " ,COALESCE((SELECT DISTINCT E1_VENCTO FROM "+ RetSqlName("SE1") +" WHERE  E1_NUM = FT_NFISCAL AND E1_PREFIXO = FT_SERIE AND E1_FILIAL = FT_FILIAL AND FT_CLIEFOR = E1_CLIENTE AND FT_LOJA = E1_LOJA AND D_E_L_E_T_ = ' ' AND ROWNUM <= 1),'') VENCTO
		End If
		cQry += " ,FT_CHVNFE        ,FT_SEGURO          ,FT_DESPESA         ,FT_DESCONT         ,B1_EX_NCM          ,F4_INCSOL          ,F4_CPPRODE				,FT_IPIOBS			,B1_DESC                     "
		cQry += " ,FT_BSFCPST		,FT_ALFCPST			,FT_VFECPST			,A2_GRPTRIB
		cQry +=	" ,FT_BASEIRR,FT_ALIQIRR,FT_VALIRR,FT_BASEINS,FT_ALIQINS,FT_VALINS,FT_BRETPIS,FT_ARETPIS,FT_VRETPIS,FT_BRETCOF,FT_ARETCOF,FT_VRETCOF,FT_BRETCSL,FT_ARETCSL,FT_VRETCSL,(FT_VRETPIS+FT_VRETCOF+FT_VRETCSL) AS PCC "		

		If MV_PAR04 == 'S'
			cQry += " ,D2_CUSTO1 CUSTO, D2_XOPER TIPOPER, D2_XTPMOV TIPOMOV	,D2_VALIPI VAL_IPI	,'' F1_TPCTE, A1_INSCR
			cQry += " ,D2_BASEICM BASEICM, D2_PICM PICM	, D2_VALICM VALICM	,D2_BRICMS BASEST	,D2_MARGEM MARGEM		,D2_ALIQSOL ALIQST		,D2_ICMSRET VALST
			cQry += " ,D2_BASEICM AS BASICMXML,D2_PICM AS PERICMXML,D2_VALICM AS VLICMXML"
			cQry += " ,D2_TOTAL AS TOTALXML, D2_DESCON DESCXML, 0 AS SEGUROXML, 0 AS DESPXML "
			cQry += " ,D2_BRICMS AS BICMSTXML,D2_PICM AS ALQICMSTXML,D2_ICMSRET AS VLICMSTXML"
			cQry += " ,D2_MARGEM AS MARGEMXML,D2_BASEIPI AS BIPIXML,D2_IPI AS PERIPIXML"
			cQry += " ,D2_VALIPI AS VLIPIXML,D2_VALFRE AS FRETEXML "
			cQry += " ,A1_NOME NOME	,A1_TIPO TIPO, A1_CGC CGC, A1_GRPTRIB GRPTRIB, 0 as CTERATEIO, 0 AS CTERATICM, 0 AS QTDE_ORIG "
		Else
			cQry += " ,D1_CUSTO CUSTO, D1_XOPER TIPOPER	,D1_XTPMOV TIPOMOV	,D1_VALIPI VAL_IPI ,F1_TPCTE, A2_INSCR
			cQry += " ,D1_BASEICM BASEICM	,D1_PICM PICM, D1_VALICM VALICM	,D1_BRICMS BASEST ,D1_MARGEM MARGEM		,D1_ALIQSOL ALIQST		,D1_ICMSRET VALST
			cQry += ",CASE WHEN PB1_BASEIC IS NULL THEN 0 ELSE PB1_BASEIC END  AS BASICMXML "
			cQry += " ,CASE WHEN PB1_PICM IS NULL THEN 0 ELSE PB1_PICM END  AS PERICMXML "
			/*cQry += " ,CASE WHEN PB1_VALICM IS NULL THEN 0 ELSE PB1_VALICM  END AS VLICMXML"
			cQry += " ,CASE WHEN PB1_TOTAL IS NULL THEN 0 ELSE (PB1_TOTAL-PB1_VALDES+PB1_SEGURO+PB1_DESPES+PB1_VALIPI+PB1_ICMSRE) END  AS TOTALXML "
			cQry += " ,CASE WHEN PB1_VALDES IS NULL THEN 0 ELSE PB1_VALDES END  AS DESCXML "
			cQry += " ,CASE WHEN PB1_SEGURO IS NULL THEN 0 ELSE PB1_SEGURO END  AS SEGUROXML "
			cQry += " ,CASE WHEN PB1_DESPES IS NULL THEN 0 ELSE PB1_DESPES END  AS DESPXML "
			cQry += " ,CASE WHEN PB1_BRICMS IS NULL THEN 0 ELSE PB1_BRICMS  END AS BICMSTXML "*/
			cQry += " ,CASE WHEN PB1_ALIQSO IS NULL THEN 0 ELSE PB1_ALIQSO END  AS ALQICMSTXML "
			//cQry += ",CASE WHEN PB1_ICMSRE IS NULL THEN 0 ELSE PB1_ICMSRE END AS VLICMSTXML "
			cQry += " ,CASE WHEN PB1_MARGEM IS NULL THEN 0 ELSE PB1_MARGEM END AS MARGEMXML "
			cQry += " ,CASE WHEN PB1_BASEIP IS NULL THEN 0 ELSE PB1_BASEIP END AS BIPIXML "
			cQry += " ,CASE WHEN PB1_IPI IS NULL THEN 0 ELSE PB1_IPI END AS PERIPIXML "
			//cQry += " ,CASE WHEN PB1_VALIPI IS NULL THEN 0 ELSE PB1_VALIPI END AS VLIPIXML "
			cQry += " ,CASE WHEN PB1_VALFRE IS NULL THEN 0 ELSE PB1_VALFRE END AS FRETEXML "

			cQry += ",(SELECT SUM(PB1I.PB1_VALICM) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '' ) AS VLICMXML "
			cQry += ",(SELECT SUM(PB1I.PB1_TOTAL-PB1I.PB1_VALDES+PB1I.PB1_SEGURO+PB1I.PB1_DESPES+PB1I.PB1_VALIPI+PB1I.PB1_ICMSRE)  FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS TOTALXML "
			cQry += ",(SELECT SUM(PB1_VALDES) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS DESCXML "
			cQry += ",(SELECT SUM(PB1_SEGURO) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS SEGUROXML "
			cQry += ",(SELECT SUM(PB1_DESPES) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS DESPXML "
			cQry += ",(SELECT SUM(PB1_BRICMS) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS BICMSTXML "
			cQry += ",(SELECT MAX(PB1_ICMSRE) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS VLICMSTXML "
			cQry += ",(SELECT SUM(PB1_VALIPI) FROM " + RetSqlName("PB1") + " PB1I WHERE PB1I.D_E_L_E_T_ = ' ' AND PB1I.PB1_FILIAL = FT_FILIAL AND PB1I.PB1_DOC = FT_NFISCAL AND PB1I.PB1_SERIE = FT_SERIE AND PB1I.PB1_FORNEC = FT_CLIEFOR AND PB1I.PB1_LOJA = FT_LOJA AND FT_DTCANC = '') AS FRETEXML "

			cQry += " ,CASE WHEN FT_TIPO='D' THEN A1_NOME ELSE A2_NOME END NOME, CASE WHEN FT_TIPO='D' THEN A1_TIPO ELSE A2_TIPO END TIPO, CASE WHEN FT_TIPO='D' THEN A1_CGC ELSE A2_CGC END CGC, CASE WHEN FT_TIPO='D' THEN A1_GRPTRIB ELSE A2_GRPTRIB END GRPTRIB "
			cQry += " ,(SELECT SUM(D1F.D1_TOTAL) FROM "  + RetSqlName("SD1") + " D1F, " + RetSqlName("SF8") + " F8 WHERE F8_FILIAL = D1F.D1_FILIAL AND F8_NFDIFRE = D1F.D1_DOC AND F8_SEDIFRE = D1F.D1_SERIE AND F8_NFORIG = FT_NFISCAL AND F8_SERORIG = FT_SERIE AND D1F.D1_FILIAL = FT_FILIAL AND D1F.D1_COD = FT_PRODUTO AND D1F.D_E_L_E_T_ = '' AND F8.D_E_L_E_T_ = '') as CTERATEIO "
			cQry += " ,(SELECT SUM(D1F.D1_VALICM) FROM " + RetSqlName("SD1") + " D1F, " + RetSqlName("SF8") + " F8 WHERE F8_FILIAL = D1F.D1_FILIAL AND F8_NFDIFRE = D1F.D1_DOC AND F8_SEDIFRE = D1F.D1_SERIE AND F8_NFORIG = FT_NFISCAL AND F8_SERORIG = FT_SERIE AND D1F.D1_FILIAL = FT_FILIAL AND D1F.D1_COD = FT_PRODUTO AND D1F.D_E_L_E_T_ = '' AND F8.D_E_L_E_T_ = '') AS CTERATICM "
			cQry += " ,(SELECT SUM(FTO.FT_QUANT) FROM "  + RetSqlName("SFT") + " FTO WHERE FTO.FT_FILIAL = A.FT_FILIAL AND FTO.FT_NFISCAL = A.FT_NFISCAL AND FTO.FT_SERIE = A.FT_SERIE AND FTO.FT_CLIEFOR = A.FT_CLIEFOR AND FTO.FT_LOJA = A.FT_LOJA AND FTO.FT_PRODUTO = A.FT_PRODUTO AND FTO.D_E_L_E_T_ = '') AS QTDE_ORIG "
		EndIf

		cQry += " FROM "+ RetSqlName("SFT") +" A " 
		If MV_PAR04 == 'S'
			cQry += " INNER JOIN "+ RetSqlName("SD2") +" E ON E.D_E_L_E_T_ = ' ' AND D2_FILIAL = FT_FILIAL AND D2_DOC = FT_NFISCAL AND D2_SERIE = FT_SERIE AND D2_ITEM = FT_ITEM "
		Else
			cQry += " INNER JOIN "+ RetSqlName("SD1") +" F ON F.D_E_L_E_T_ = ' ' AND D1_FILIAL = FT_FILIAL AND D1_DOC = FT_NFISCAL AND D1_SERIE = FT_SERIE AND FT_CLIEFOR = D1_FORNECE AND FT_LOJA = D1_LOJA AND D1_ITEM = FT_ITEM "
			cQry += " INNER JOIN "+ RetSqlName("SF1") +" G ON G.D_E_L_E_T_ = ' ' AND F1_FILIAL = FT_FILIAL AND F1_DOC = FT_NFISCAL AND F1_SERIE = FT_SERIE AND FT_CLIEFOR = F1_FORNECE AND FT_LOJA = F1_LOJA "			
		EndIf
		//If MV_PAR04 == 'E'
			cQry += " LEFT JOIN "+ RetSqlName("PB1") +" I ON I.D_E_L_E_T_ = ' ' AND PB1_FILIAL = FT_FILIAL AND PB1_DOC = FT_NFISCAL AND PB1_SERIE = FT_SERIE AND PB1_FORNEC = FT_CLIEFOR AND PB1_LOJA = FT_LOJA AND PB1_ITEM = FT_ITEM  "
 		//EndIf
		//If MV_PAR04 == 'S'
		cQry += " LEFT JOIN "+ RetSqlName("SA1") +" B ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND B.D_E_L_E_T_ = ' ' "
		cQry += " LEFT JOIN "+ RetSqlName("SA2") +" H ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND H.D_E_L_E_T_ = ' ' "
		//EndIf
		cQry += " INNER JOIN "+ RetSqlName("SB1") +" C ON B1_COD = FT_PRODUTO AND C.D_E_L_E_T_ = ' ' "
		cQry += " LEFT JOIN "+ RetSqlName("SF4") +" E ON FT_FILIAL = F4_FILIAL AND FT_TES = F4_CODIGO  AND E.D_E_L_E_T_ = ' ' " 
		cQry += " LEFT JOIN  "+ RetSqlName("SX5") +" D ON X5_TABELA = '21' AND RTRIM(X5_CHAVE) = RTRIM(B1_GRTRIB) AND D.D_E_L_E_T_ = ' ' "
		//cQry += " LEFT JOIN  "+ RetSqlName("SE1") +" E ON SUBSTR(E1_NUM,1,6) = SUBSTR(FT_NFISCAL,4,6) AND E1_PREFIXO = FT_SERIE AND E1_FILIAL = FT_FILIAL AND FT_CLIEFOR = E1_CLIENTE AND FT_LOJA = E1_LOJA AND E.D_E_L_E_T_ = ' ' "
		cQry += " WHERE A.D_E_L_E_T_ = ' ' AND FT_ESPECIE <> 'NFS' " 
		cQry += " AND FT_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
		If !Empty(MV_PAR25) .And. !Empty(MV_PAR26)
			cQry += " AND FT_ENTRADA BETWEEN '"+ DTOS(MV_PAR25) +"' AND '"+ DTOS(MV_PAR26) +"' "
		EndIf
		If !Empty(MV_PAR27) .AND. !Empty(MV_PAR28)
			cQry += " AND FT_EMISSAO BETWEEN '"+ DTOS(MV_PAR27) +"' AND '"+ DTOS(MV_PAR28) +"' "
		EndIf
		If !Empty(AllTrim(cProd))
			cQry += " AND FT_PRODUTO IN "+ cProd
		EndIf
		If !Empty(AllTrim(MV_PAR04))
			If AllTrim(MV_PAR04) <> 'A'
				cQry += " AND FT_TIPOMOV = '"+ Alltrim(MV_PAR04) +"' "
			EndIf
		EndIf
		If !Empty(cLivro)
			cQry += " AND FT_NRLIVRO IN "+ cLivro
		EndIf
		If !Empty(cCFOP)
			cQry += " AND FT_CFOP IN "+ cCFOP
		EndIf
		If !Empty(cNCM)
			cQry += " AND FT_POSIPI IN "+ cNCM
		EndIf
		If !Empty(MV_PAR10)
			cQry += " AND FT_MARGEM BETWEEN "+ cValtoChar(MV_PAR09) +" AND "+ cValtoChar(MV_PAR10)
		EndIf
		If !Empty(cUF)
			cQry += " AND FT_ESTADO IN "+ cUF
		EndIf
		If !Empty(cNotUF)
			cQry += " AND FT_ESTADO NOT IN "+ cNotUF
		EndIf
		If !Empty(MV_PAR13)
			cQry += " AND FT_VALICM = "+ cValToChar(MV_PAR13)
		EndIf
		If !Empty(MV_PAR14)
			If MV_PAR04 == 'S'
				cQry += " AND A1_CGC LIKE '"+ Alltrim(MV_PAR14) +"%' "
			ElseIf MV_PAR04 == 'E'
				cQry += " AND A2_CGC LIKE '"+ Alltrim(MV_PAR14) +"%' "
			EndIf
		EndIf
		If MV_PAR04 == 'S' .And. !Empty(AllTrim(MV_PAR15)) .And. MV_PAR15 <> 'T'
			cQry += " AND A1_TIPO = '"+ AllTrim(MV_PAR15) +"' "
		EndIf
		If !Empty(MV_PAR16)
			cQry += " AND FT_CSTPIS IN "+ cPis
		EndIf
		If !Empty(MV_PAR17)
			cQry += " AND FT_CSTCOF IN "+ cCOF
		EndIf
		If !Empty(MV_PAR18)
			cQry += " AND FT_CLASFIS IN "+ cCF
		EndIf
		//Grupo Prod
		If !Empty(cGrpProd)
			cQry += " AND B1_GRTRIB IN "+ cGrpProd
		EndIf
		//Retira Grupo Prod
		If !Empty(cNGrProd)
			cQry += " AND B1_GRTRIB NOT IN "+ cNGrProd
		EndIf
		If !Empty(cOper)
			If MV_PAR04 == 'S'
				cQry += " AND D2_XOPER IN "+ cOper
			Else
				cQry += " AND D1_XOPER IN "+ cOper
			EndIf	
		EndIf
		//Grupo Cliente
		If !Empty(cGrpCli)
			If MV_PAR04 == 'S'
				cQry += " AND A1_GRPTRIB IN "+ cGrpCli
			Else
				cQry += " AND A2_GRPTRIB IN "+ cGrpCli
			EndIf
		EndIf
		//Desc Grupo
		If !Empty(mv_par21)
			cQry += " AND B1_GRTRIB LIKE '"+AllTrim(mv_par21)+"' "
		EndIf
		//Razao
		If !Empty(mv_par22)
			If MV_PAR04 == 'S'
				cQry += " AND A1_NOME LIKE '%"+AllTrim(mv_par22)+"%' "
			Else
				cQry += " AND A2_NOME LIKE '%"+AllTrim(mv_par22)+"%' "
			EndIf
		EndIf
		//Especie
		If !Empty(cEspecie)
			cQry += " AND FT_ESPECIE IN "+ cEspecie
		EndIf
		//Tipo Doc
		If !Empty(cTipoDoc)
			cQry += " AND FT_TIPO IN "+ cTipoDoc
		EndIf
		//Finalidade 
		If !Empty(cFinalid)
			cQry += " AND F1_TPCTE IN "+ cFinalid
		EndIf
		/*If !Empty(cNaturez)
		cQry += " AND E1_NATUREZ IN "+ cNaturez
		EndIf*/
		cQry += " ORDER BY FT_FILIAL, A1_NOME, A1_CGC, FT_NFISCAL, FT_SERIE, FT_ITEM "

	EndIf
	/*
	If Select("TRBSFT") > 0
	DbSelectArea("TRBSFT")
	TRBSFT->(DbCloseArea())
	EndIf
	*/
	If Select(cAlias) > 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), cAlias,.F.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	oReport:SetMeter((cAlias)->(RecCount()))

	If MV_PAR06 == '2'	//Analítico

		While ! (cALias)->(EoF())

			If oReport:Cancel()
				Exit
			EndIf

			//inicializo a primeira seção
			oSection1:Init()
			oReport:IncMeter()

			oSection1:Cell("FT_FILIAL"	):SetValue((cAlias)->FT_FILIAL			)		
			oSection1:Cell("FT_EMISSAO"	):SetValue(SToD((cAlias)->FT_EMISSAO)	)
			oSection1:Cell("FT_ENTRADA"	):SetValue(SToD((cAlias)->FT_ENTRADA)	)	
			oSection1:Cell("FT_ESPECIE"	):SetValue((cAlias)->FT_ESPECIE	)	
			oSection1:Cell("FT_TIPO"	):SetValue((cAlias)->FT_TIPO	)
			oSection1:Cell("FT_NFISCAL"	):SetValue((cAlias)->FT_NFISCAL	)	
			oSection1:Cell("FT_SERIE"	):SetValue((cAlias)->FT_SERIE	)
			oSection1:Cell("FT_CLIEFOR"	):SetValue((cAlias)->FT_CLIEFOR	)
			oSection1:Cell("FT_LOJA"	):SetValue((cAlias)->FT_LOJA	)
			oSection1:Cell("A1_NOME"	):SetValue((cAlias)->NOME		)
			oSection1:Cell("A1_TIPO"	):SetValue((cAlias)->TIPO		)			
			oSection1:Cell("FT_ESTADO"	):SetValue((cAlias)->FT_ESTADO	)	
			oSection1:Cell("A1_GRPTRIB"	):SetValue((cAlias)->GRPTRIB	)
			oSection1:Cell("TIPOPER"	):SetValue((cAlias)->TIPOPER	)
			oSection1:Cell("B1_GRTRIB"	):SetValue((cAlias)->B1_GRTRIB	)
			oSection1:Cell("B1_GRPTI"	):SetValue((cAlias)->B1_GRPTI	)
			oSection1:Cell("FT_TES"		):SetValue((cAlias)->FT_TES		)
			oSection1:Cell("FT_CFOP"	):SetValue((cAlias)->FT_CFOP	)
			oSection1:Cell("FT_CLASFIS"	):SetValue((cAlias)->FT_CLASFIS	)	
			oSection1:Cell("FT_POSIPI"	):SetValue((cAlias)->FT_POSIPI	)
			oSection1:Cell("B1_EX_NCM"	):SetValue((cAlias)->B1_EX_NCM	)
			oSection1:Cell("FT_PRODUTO"	):SetValue((cAlias)->FT_PRODUTO	)
			oSection1:Cell("B1_DESC"	):SetValue((cAlias)->B1_DESC	)
			oSection1:Cell("FT_QUANT"	):SetValue((cAlias)->FT_QUANT	)
			oSection1:Cell("FT_PRCUNIT"	):SetValue((cAlias)->FT_PRCUNIT	)	
			oSection1:Cell("TOTLIQ"	):SetValue((cAlias)->FT_QUANT * (cAlias)->FT_PRCUNIT )

			oSection1:Cell("D1BASEICM"	):SetValue((cAlias)->BASEICM )
			oSection1:Cell("D1PICM"	):SetValue((cAlias)->PICM )
			oSection1:Cell("D1VALICM"	):SetValue((cAlias)->VALICM )

			oSection1:Cell("FT_DESPESA"	):SetValue((cAlias)->FT_DESPESA	)	// DENISSON DANILO
			oSection1:Cell("FRETEXML"	):SetValue((cAlias)->FRETEXML	)
			oSection1:Cell("VAL_IPI"	):SetValue((cAlias)->VAL_IPI	)
			oSection1:Cell("FT_MARGEM"	):SetValue(IIF((cAlias)->FT_ICMSRET > 0, (cAlias)->FT_MARGEM,0)	)
			oSection1:Cell("FT_BASERET"	):SetValue((cAlias)->FT_BASERET	)	
			oSection1:Cell("FT_ALIQSOL"	):SetValue((cAlias)->FT_ALIQSOL	)	
			oSection1:Cell("F4_INCSOL"	):SetValue((cAlias)->F4_INCSOL	)
			If (cAlias)->F4_INCSOL == "S"
				oSection1:Cell("ICMS_ST_AGS"):SetValue((cAlias)->FT_ICMSRET	)
				oSection1:Cell("ICMS_ST_AGN"):SetValue(0	)
			Else
				oSection1:Cell("ICMS_ST_AGS"):SetValue(0	)
				oSection1:Cell("ICMS_ST_AGN"):SetValue((cAlias)->FT_ICMSRET	)
			End If
			oSection1:Cell("FT_ALFCPST"	):SetValue((cAlias)->FT_ALFCPST	)
			oSection1:Cell("FT_VFECPST"	):SetValue((cAlias)->FT_VFECPST	)

			oSection1:Cell("CTERATEIO"	):SetValue( Round(((cAlias)->CTERATEIO/(cAlias)->QTDE_ORIG)*(cAlias)->FT_QUANT,4)	)
			oSection1:Cell("CTERATICM"	):SetValue( Round(((cAlias)->CTERATICM/(cAlias)->QTDE_ORIG)*(cAlias)->FT_QUANT,4)	)

			oSection1:Cell("DIF_ST_CTE"	):SetValue("")

			nMVAF7 := 0

			cQryF7 := "SELECT F7_XMVA FROM " + RetSqlName("SF7") + " WHERE D_E_L_E_T_ = '' AND F7_FILIAL = '" + (cAlias)->FT_FILIAL + "' AND F7_GRTRIB = '" + (cAlias)->B1_GRTRIB + "' AND F7_EST = '" + (cAlias)->FT_ESTADO + "' AND F7_XMVA <> 0 AND ROWNUM <= 1"
			dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQryF7), "SQLSF7",.F.,.T.)

			If SQLSF7->(!EOF())
				nMVAF7 := SQLSF7->F7_XMVA
			End If

			SQLSF7->(DbCloseArea())

			oSection1:Cell("STREGRAG"	):SetValue(cValToChar(nMVAF7)	)
			oSection1:Cell("ICMS_ST_GER"):SetValue(""	)

			oSection1:Cell("BC_FEEF"	):SetValue(""	) //*Verificar Tereza
			oSection1:Cell("VL_FEEF"	):SetValue(""	) //*Verificar Tereza

			oSection1:Cell("FT_OBSERV"	):SetValue((cAlias)->FT_OBSERV	)	
			oSection1:Cell("MVA_CALC"	):SetValue(""	)	
			oSection1:Cell("IMP_CALC"	):SetValue(""	)
			oSection1:Cell("FT_CFOP2"	):SetValue((cAlias)->FT_CFOP	)
			oSection1:Cell("FT_NRLIVRO"	):SetValue((cAlias)->FT_NRLIVRO	)
			oSection1:Cell("FT_VALCONT"	):SetValue((cAlias)->FT_VALCONT	)
			oSection1:Cell("FT_BASEICM"	):SetValue((cAlias)->FT_BASEICM	)
			oSection1:Cell("FT_ALIQICM"	):SetValue((cAlias)->FT_ALIQICM	)	
			oSection1:Cell("FT_VALICM"	):SetValue((cAlias)->FT_VALICM	)			
			oSection1:Cell("FT_ISENICM"	):SetValue((cAlias)->FT_ISENICM	)	
			oSection1:Cell("FT_OUTRICM"	):SetValue((cAlias)->FT_OUTRICM	)

			oSection1:Cell("ICMSPAUT"	):SetValue((cAlias)->B1_VLR_ICM )
			//oSection1:Cell("FT_CPPRODE"	):SetValue((cAlias)->FT_CPPRODE	)	

			nPerprode := (cAlias)->F4_CPPRODE
			oSection1:Cell("FT_CPPRODE"	):SetValue(((cAlias)->FT_QUANT * (cAlias)->FT_PRCUNIT)*nPerprode/100 )	

			oSection1:Cell("FT_TPPRODE"	):SetValue((cAlias)->FT_TPPRODE	)	
			oSection1:Cell("FT_ALQFECP"	):SetValue((cAlias)->FT_ALQFECP	)
			oSection1:Cell("FT_VALFECP"	):SetValue((cAlias)->FT_VALFECP	)
			oSection1:Cell("FT_DIFAL"	):SetValue((cAlias)->FT_DIFAL	)
			oSection1:Cell("FT_ICMSCOM"	):SetValue((cAlias)->FT_ICMSCOM	)	
			oSection1:Cell("FT_ICMSDIF"	):SetValue((cAlias)->FT_ICMSDIF	)	
			oSection1:Cell("FT_ANTICMS"	):SetValue((cAlias)->FT_ANTICMS	)	
			oSection1:Cell("FT_CFOP3"	):SetValue((cAlias)->FT_CFOP	)
			oSection1:Cell("FT_CSTPIS"	):SetValue((cAlias)->FT_CSTPIS	)	
			oSection1:Cell("FT_CSTCOF"	):SetValue((cAlias)->FT_CSTCOF	)	
			oSection1:Cell("FT_BASEPIS"	):SetValue((cAlias)->FT_BASEPIS	)	
			oSection1:Cell("FT_BASECOF"	):SetValue((cAlias)->FT_BASECOF	)
			oSection1:Cell("FT_ALIQPIS"	):SetValue((cAlias)->FT_ALIQPIS	)	
			oSection1:Cell("FT_VALPIS"	):SetValue((cAlias)->FT_VALPIS	)	
			oSection1:Cell("FT_ALIQCOF"	):SetValue((cAlias)->FT_ALIQCOF	)	
			oSection1:Cell("FT_VALCOF"	):SetValue((cAlias)->FT_VALCOF	)
			oSection1:Cell("CUSTO"	):SetValue((cAlias)->CUSTO	)
			oSection1:Cell("NATUREZ"	):SetValue((cAlias)->NATUREZ	)
			If SED->(DbSetOrder(1),DbSeek(xFilial("SED") + (cAlias)->NATUREZ ))
				oSection1:Cell("ED_DESCRIC"	):SetValue(SED->ED_DESCRIC	)
			Else
				oSection1:Cell("ED_DESCRIC"	):SetValue(""	)
			End If
			oSection1:Cell("A1_CGC"		):SetValue((cAlias)->CGC		)
			If MV_PAR04 == 'S'
				oSection1:Cell("A1_INSCR" ):SetValue((cAlias)->A1_INSCR	)
			Else
				oSection1:Cell("A2_INSCR" ):SetValue((cAlias)->A2_INSCR	)
			EndIf
			oSection1:Cell("FT_NFORI"	):SetValue((cAlias)->FT_NFORI	)
			oSection1:Cell("FT_SERORI"	):SetValue((cAlias)->FT_SERORI	)	

			oSection1:Cell("FT_BASEIPI"	):SetValue((cAlias)->FT_BASEIPI	)
			oSection1:Cell("FT_ALIQIPI"	):SetValue((cAlias)->FT_ALIQIPI	)		
			oSection1:Cell("FT_CTIPI"	):SetValue((cAlias)->FT_CTIPI	)

			oSection1:Cell("FT_DTCANC"	):SetValue(SToD((cAlias)->FT_DTCANC) )	
			oSection1:Cell("FT_CHVNFE"	):SetValue((cAlias)->FT_CHVNFE	)
			oSection1:Cell("TOTALXML"	):SetValue((cAlias)->TOTALXML	)
			oSection1:Cell("VLICMXML"	):SetValue((cAlias)->VLICMXML	)
			oSection1:Cell("MARGEMXML"	):SetValue((cAlias)->MARGEMXML	)
			oSection1:Cell("BICMSTXML"	):SetValue((cAlias)->BICMSTXML	)
			oSection1:Cell("VLICMSTXML"	):SetValue((cAlias)->VLICMSTXML	)

			oSection1:Printline()

			(cAlias)->(dbSkip())
		EndDo

	Else    // Sintético

		While !(cAlias)->(EoF())

			If oReport:Cancel()
				Exit
			EndIf

			//inicializo a primeira seção
			oSection1:Init()
			oReport:IncMeter()

			//imprimo a primeira seção				

			oSection1:Cell("F3_FILIAL"	):SetValue((cAlias)->F3_FILIAL	)
			oSection1:Cell("F3_ENTRADA"	):SetValue(SToD((cAlias)->F3_ENTRADA)	)	
			oSection1:Cell("F3_NFISCAL"	):SetValue((cAlias)->F3_NFISCAL	)	
			oSection1:Cell("F3_ESTADO"	):SetValue((cAlias)->F3_ESTADO	)	
			oSection1:Cell("F3_TIPO"	):SetValue((cAlias)->F3_TIPO		)		
			oSection1:Cell("F3_ALIQICM"	):SetValue((cAlias)->F3_ALIQICM	)	
			oSection1:Cell("F3_VALCONT"	):SetValue((cAlias)->F3_VALCONT	)	
			oSection1:Cell("F3_CLIEFOR"	):SetValue((cAlias)->F3_CLIEFOR   )
			oSection1:Cell("F3_LOJA"	):SetValue((cAlias)->F3_LOJA		)	
			oSection1:Cell("F3_BASEICM"	):SetValue((cAlias)->F3_BASEICM	)	
			oSection1:Cell("F3_VALICM"	):SetValue((cAlias)->F3_VALICM	)	
			oSection1:Cell("F3_ISENICM"	):SetValue((cAlias)->F3_ISENICM	)	
			oSection1:Cell("F3_OUTRICM"	):SetValue((cAlias)->F3_OUTRICM	)	
			oSection1:Cell("F3_BASEIPI"	):SetValue((cAlias)->F3_BASEIPI	)	
			oSection1:Cell("F3_VALIPI"	):SetValue((cAlias)->F3_VALIPI	)	
			oSection1:Cell("F3_ISENIPI"	):SetValue((cAlias)->F3_ISENIPI	)
			oSection1:Cell("F3_OUTRIPI"	):SetValue((cAlias)->F3_OUTRIPI	)
			oSection1:Cell("F3_ALIQIPI"	):SetValue((cAlias)->F3_ALIQIPI	)	
			oSection1:Cell("F3_BASERET"	):SetValue((cAlias)->F3_BASERET	)	
			oSection1:Cell("F3_ICMSRET"	):SetValue((cAlias)->F3_ICMSRET	)	
			oSection1:Cell("F3_OBSERV"	):SetValue((cAlias)->F3_OBSERV	)	
			oSection1:Cell("F3_DTCANC"	):SetValue(SToD((cAlias)->F3_DTCANC)	)	
			oSection1:Cell("F3_ICMSCOM"	):SetValue((cAlias)->F3_ICMSCOM	)	
			oSection1:Cell("F3_ICMSDIF"	):SetValue((cAlias)->F3_ICMSDIF   )
			oSection1:Cell("F3_CHVNFE"	):SetValue((cAlias)->F3_CHVNFE	)	
			oSection1:Cell("GRUPO"		):SetValue((cAlias)->GRUPO  	 	)
			oSection1:Cell("TIPO"		):SetValue((cAlias)->TIPO   		)
			oSection1:Cell("CGC"		):SetValue((cAlias)->CGC   		)			
			oSection1:Cell("F3_NRLIVRO"	):SetValue((cAlias)->F3_NRLIVRO	)
			oSection1:Cell("F3_ESPECIE"	):SetValue((cAlias)->F3_ESPECIE	)	
			oSection1:Cell("F3_DESPESA"	):SetValue((cAlias)->F3_DESPESA	)	
			oSection1:Cell("F3_CPPRODE"	):SetValue((cAlias)->F3_CPPRODE	)	
			oSection1:Cell("F3_TPPRODE"	):SetValue((cAlias)->F3_TPPRODE	)	
			oSection1:Cell("F3_ANTICMS"	):SetValue((cAlias)->F3_ANTICMS	)	
			oSection1:Cell("F3_CSTPIS"	):SetValue((cAlias)->F3_CSTPIS	)	
			oSection1:Cell("F3_CSTCOF"	):SetValue((cAlias)->F3_CSTCOF    )
			oSection1:Cell("F3_VALFECP"	):SetValue((cAlias)->F3_VALFECP	)
			oSection1:Cell("F3_DIFAL"	):SetValue((cAlias)->F3_DIFAL     )

			oSection1:Printline()

			(cAlias)->(dbSkip())
		EndDo
	EndIf

	//finalizo a primeira seção
	oSection1:Finish()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡„o	 ³CriaSX1   ³ Autor ³ Marcelo Celi Marques  ³ Data ³ 02/10/08³ ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza perguntas no SX1                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³CriaSX1() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³FINR501()     											  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Filial De – Até
Grupos de Produtos (Separados por ponto e vírgula)
Entradas/Saídas ou Entradas e Saídas
Livros (Separados por ponto e vírgula)
Sintético (por CFOP) e Analítico por Item
Por CFOP (Separados por ponto e vírgula)
Dentro do Estado ou Fora do Estado
Por NCM (Separados por ponto e vírgula)
***Campos CST do ICMS
***Campos CST do PIS COFINS
MVA (De / Até)
UF (Separados por ponto e Vírgula)
***Tipo de Operação (Gravar na tabela para confrontar TP. Oper x CFOP
***Tipo do Cliente
Do cliente ou do fornecedor CNPJ contém a expressão (separados por ponto e vírgula)
Valor do ICMS (especificar valor)
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSx1(cPerg)
	Local aArea:=GetArea()
	Local aHelpPor:={}

	xPutSx1(cPerg,"01","Filial De"," "," ","mv_ch1",;
	"C",6,0,0,"G","","SM0","","S","mv_par01"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"02","Filial Ate"," "," ","mv_ch2",;
	"C",6,0,0,"G","","SM0","","S","mv_par02"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"03","Produto"," "," ","mv_ch3",;
	"C",30,0,0,"R","","SB1","","S","mv_par03"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"04","Tipo Mov."," "," ","mv_ch4",;
	"C",1,0,0,"C","","","","S","mv_par04","1=Entrada"," "," ","",;
	"2=Saida"," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"05","Livros"," "," ","mv_ch5",;
	"C",30,0,0,"R","","","","S","mv_par05"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"06","Tipo Rel."," "," ","mv_ch6",;
	"C",1,0,0,"C","","","","S","mv_par06","1=Sintetico"," "," ","",;
	"2=Analitico"," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"07","CFOP"," "," ","mv_ch7",;
	"C",30,0,0,"R","","13","","S","mv_par07"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"08","NCM"," "," ","mv_ch8",;
	"C",30,0,0,"R","","","","S","mv_par08"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"09","MVA De"," "," ","mv_ch9",;
	"N",14,2,0,"G","","","","S","mv_par09"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"10","MVA Ate"," "," ","mv_cha",;
	"N",14,2,0,"G","","","","S","mv_par10"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"11","Considera UF"," "," ","mv_chb",;
	"C",30,0,0,"R","","","","S","mv_par11"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"12","Desconsidera UF"," "," ","mv_chc",;
	"C",30,0,0,"R","","","","S","mv_par12"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"13","Valor ICMS"," "," ","mv_chd",;
	"N",14,2,0,"G","","","","S","mv_par13"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"14","CNPJ"," "," ","mv_che",;
	"C",14,0,0,"G","U_CARCESP()","","","S","mv_par14"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"15","Tipo Cliente"," "," ","mv_chf",;
	"C",1,0,0,"C","","","","S","mv_par15","F=Cons.Final"," "," ","",;
	"L=Produtor Rural"," "," ","R=Revendedor"," "," ","S=Solidario"," "," ","T=Todos"," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"16","CST PIS"," "," ","mv_chg",;
	"C",50,0,0,"R","","","","S","mv_par16"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"17","CST COFINS"," "," ","mv_chh",;
	"C",50,0,0,"R","","","","S","mv_par17"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)	

	xPutSx1(cPerg,"18","Class. Fiscal"," "," ","mv_chi",;
	"C",50,0,0,"R","","","","S","mv_par18"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)	

	xPutSx1(cPerg,"19","Considera Grupo Prod."," "," ","mv_chj",;
	"C",50,0,0,"R","","21","","S","mv_par19"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"20","Descons. Grupo Prod."," "," ","mv_chk",;
	"C",50,0,0,"R","","21","","S","mv_par20"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"21","Grupo Prod. Contém"," "," ","mv_chl",;
	"C",30,0,0,"G","","","","S","mv_par21"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"22","Razão Social Contém"," "," ","mv_chm",;
	"C",30,0,0,"G","","","","S","mv_par22"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"23","Natureza"," "," ","mv_chn",;
	"C",50,0,0,"R","","SED","","S","mv_par23"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)	

	xPutSx1(cPerg,"24","Grupo Cliente"," "," ","mv_cho",;
	"C",50,0,0,"R",""," ","","S","mv_par24"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"25","Data Entrada De"," "," ","mv_chp",;
	"D",8,0,0,"G","","","","S","mv_par25"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"26","Data Entrada Ate"," "," ","mv_chq",;
	"D",8,0,0,"G","","","","S","mv_par26"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"27","Data Emissao De"," "," ","mv_chr",;
	"D",8,0,0,"G","","","","S","mv_par27"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"28","Data Emissao Ate"," "," ","mv_chs",;
	"D",8,0,0,"G","","","","S","mv_par28"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"29","Tipo de Operação"," "," ","mv_cht",;
	"C",50,0,0,"R","","","","S","mv_par29"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"30","Especie"," "," ","mv_chu",;
	"C",30,0,0,"R","","","","S","mv_par30"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"31","Tipo Documento"," "," ","mv_chv",;
	"C",30,0,0,"R","","","","S","mv_par31"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"32","Finalidade"," "," ","mv_chw",;
	"C",30,0,0,"R","","","","S","mv_par32"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	RestArea(aArea)
Return                                       

//Gravar pergunta na SX1
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .F.
	Local lSpa  := .F.
	Local lIngl := .F.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme   := Iif( cPyme       == Nil, " ", cPyme          )
	cF3     := Iif( cF3         == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01  := Iif( cCnt01      == Nil, "" , cCnt01      )
	cHelp   := Iif( cHelp       == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt := If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa  := If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng  := If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		EndIf

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MSUnlock()

	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= AllTrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := AllTrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := AllTrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MSUnlock())
		EndIf
	Endif

	RestArea( aArea )

Return

Static Function fStatus(cFilEmp,cNF,cSer,cCliFor,cLoja,cProd,cItem)
	Local cRet := " "

	cQry := " SELECT FXG_STATUS, FXG_CMPCOM FROM "+ RETSQLNAME("FXG")
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND RTRIM(FXG_CHVSEC) = RTRIM('"+cFilEmp+"' || '"+cNF+"' || '"+cSer+"' || RTRIM('"+cCliFor+"') || '"+cLoja+"' || '"+cProd+"' || '"+cItem+"') "

	If Select("TRBFXG") > 0
		DbSelectArea("TRBFXG")
		TRBFXG->(DbCloseArea())
	EndIf

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), "TRBFXG",.F.,.T.)

	dbSelectArea("TRBFXG")
	TRBFXG->(dbGoTop())

	While ! TRBFXG->(EoF())
		cRet += TRBFXG->FXG_STATUS + "-" + Alltrim(TRBFXG->FXG_CMPCOM) + " / "
		TRBFXG->(dbSkip())
	EndDo

Return cRet
