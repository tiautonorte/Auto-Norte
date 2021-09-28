#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#include "msmgadd.ch"

#Define nPosEmis 15 //Posição da data no array, para conversão

User Function RFAT004()
	Local aCampos 	:= {}
	Local cTmpZZS 	:= GetNextAlias()
	Local cAlias1 	:= GetNextAlias()
	Local  cTMP 	:= ""
	Local oReport

	Private oTmp1
	Private cPerg 	:= "RFAT004"

	//Cria pergunta
	CriaSx1(cPerg)

	While Pergunte(cPerg, .T.)
	
		/*
		If !Pergunte(cPerg, .T.)
			Return
		EndIf
		*/

		//Cria temporária
		//fCriaTemp(cTmpZZS,@aCampos)

		//Carrega dados
		//FWMsgRun(, {|oSay| fLoadTemp(cTmpZZS,aCampos) }, "Processando", "Gerando Relatório...")

		//Nome da TMP no banco de dados
		//cTMP := oTmp1:GetRealName()

		//Executa relatorio
		
		oReport := ReportDef(cAlias1,cTMP,cPerg)
		oReport:PrintDialog()

		//oTmp1:Delete()
		If ( SELECT(cTmpZZS) ) > 0
			(cTmpZZS)->(dbCloseArea())
		EndIf

	Enddo

Return


Static Function ReportDef(cAlias1,cTMP,cPerg)
	Local oReport
	Local oSection1
	Local oSection2
	Local oBreak1
	Local cCabec := "Demonstrativo de Cálculo - DRE"
	Local nCount
	Local oTotOper
	Local oTotBrut
	Local oTotProd
	PUBLIC nPrzTot := 0.00
	PUBLIC nVlrTot := 0.00

	nPrzTot := 0.00
	nVlrTot := 0.00

	oReport := TReport():New("RFAT004",cCabec,cPerg,{|oReport| ReportPrint(oReport,cAlias1,cTMP,@nCount)},"",,,,,,,,,,,,,)
	oReport:SetColSpace(2,.T.)
	oReport:nFontBody := 8
	oReport:SetLineHeight(50)
	oReport:SetLandscape()

	oSection1 := TRSection():New(oReport,cCabec,,,,,,,,,,,,.T.)
	oSection1:Hide( ) //desabilita a seção
	TRCell():New(oSection1,"A"	,,""	,,1				,.F.)

	oSection2 := TRSection():New(oSection1,cCabec)
	If SUBSTR(mv_par04,1,2) == '01'
		TRCell():New(oSection2,"MARCA"	,,"Fornec."		,,TamSX3("B1_XMARCA")[1],.F.,,,,"CENTER")
	ElseIf SUBSTR(mv_par04,1,2) == '02'
		TRCell():New(oSection2,"VEND"	,,"Vend/Repres.",,30,.F.,{|| (cAlias1)->VEND+" - "+(cAlias1)->NOMVEND },,,"CENTER")
	ElseIf SUBSTR(mv_par04,1,2) == '03'
		TRCell():New(oSection2,"CLIENTE",,"Cliente"		,,30,.F.,{|| (cAlias1)->CLIENTE+" - "+(cAlias1)->NOMCLIE },,,"CENTER")
	ElseIf SUBSTR(mv_par04,1,2) == '04'
		TRCell():New(oSection2,"COND"	,,"Prazo"		,,TamSX3("B1_XMARCA")[1],.F.,{|| TotalizaPrz(cAlias1) },,,"CENTER")
	ElseIf SUBSTR(mv_par04,1,2) == '05'
		TRCell():New(oSection2,"UF"		,,"Estado"		,,TamSX3("F2_EST")[1],.F.,,,,"CENTER")
	ElseIf SUBSTR(mv_par04,1,2) == '06'
		TRCell():New(oSection2,"LETRA"	,,"Letra"		,,TamSX3("B1_XMARCA")[1],.F.,,,,"CENTER")
	EndIf

	TRCell():New(oSection2,"TOTPROD"	,,"Total Vendas"	,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"CUSTO"		,,"Custo Medio"		,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"ICMSPISCOF"	,,"Icms/Pis/Cof"	,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"TOT_BRUTO"	,,"Tot. 'Lucro' Bruto","@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"PERC_BRUTO"	,,"% Lucro Bruto"	,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"DESPESA"	,,"Desp. Aces."		,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"FRETE"		,,"Frete"			,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"VLRCOM"		,,"Comissão"		,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"TOT_OPER"	,,"Total Lucro Op."	,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")
	TRCell():New(oSection2,"PERC_OPER"	,,"% Lucro Op."		,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")

	//TRCell():New(oSection2,"PRZTOT"	,,"Prz% Lucro Op."		,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"CENTER")


	oBreak1 := TRBreak():New(oSection1,{ || oSection1:Cell('A'):uPrint },'Total Geral',.F.)

	TRFunction():New(oSection2:Cell("CUSTO")		,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell("ICMSPISCOF")	,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell("DESPESA")		,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell("FRETE")		,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell("VLRCOM")		,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)

	oTotProd := TRFunction():New(oSection2:Cell("TOTPROD")	,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	oTotBrut := TRFunction():New(oSection2:Cell("TOT_BRUTO"),,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)
	oTotOper := TRFunction():New(oSection2:Cell("TOT_OPER")	,,'SUM',oBreak1,,"@E 999,999,999,999.99",,.F.,.F.,.F., oSection2)

	TRFunction():New(oSection2:Cell("PERC_BRUTO")	,,'ONPRINT',oBreak1,,"@E 999,999,999,999.99",{|| CalcPerc(oTotBrut,oTotProd) },.F.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell("PERC_OPER")	,,'ONPRINT',oBreak1,,"@E 999,999,999,999.99",{|| CalcPerc(oTotOper,oTotProd) },.F.,.F.,.F., oSection2)

	If SUBSTR(mv_par04,1,2) == '04'
    	//TRFunction():New(oSection2:Cell("COND")	,,'ONPRINT',oBreak1,,"@E 999",{|| ROUND(nPrzTot / oTotProd:uLastValue,0)   },.F.,.F.,.F., oSection2)
		TRFunction():New(oSection2:Cell("COND")	,,'ONPRINT',oBreak1,,"@E 999",{|| ROUND(nPrzTot / IIF(nVlrTot<>0,nVlrTot,1),0)   },.F.,.F.,.F., oSection2)
	EndIf

Return oReport

Static Function CalcPerc(oParte,oTotal)
	Local nRet := 0

	nRet := (oParte:uLastValue / oTotal:uLastValue) * 100

Return nRet

Static Function TotalizaPrz(cAlias1)
    nPrzTot += (cAlias1)->PRZTOT
	nVlrTot += (cAlias1)->VLRTOT
Return (cAlias1)->COND

Static Function ReportPrint(oReport,cAlias1,cTMP,nCount)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local TabTMP	:= '% '+cTMP+' %'
	Local cOrdem
	Local cFilPar 	:= "% F2_FILIAL <> ' ' %"
	Local cVend 	:= "% %"
	Local cMarca 	:= "% B1_XMARCA <> ' ' %"
	Local cMarLin 	:= "% B1_XLINHA <> ' ' %"
	Local cCliente 	:= "% F2_CLIENTE <> ' ' %"
	Local cUF 		:= "% F2_EST <> ' ' %"
	Local cLetra	:= "% %"
	Local cOrder
	Local cGroup
	Local cSelect

	oReport:SetTitle(oReport:Title()+" Filial "+ALLTRIM(mv_par01)+" // Periodo "+dtoc(MV_PAR02)+" ate "+dtoc(MV_PAR03))

	MakeSqlExpr("RFAT004")

	If ! Empty(MV_PAR01)
		cFilPar := "%"+MV_PAR01+" %"
	EndIf

	If ! Empty(mv_par06)
		cVend := "% AND "+mv_par06+" %"
	EndIf

	If !Empty(mv_par07)
		cMarca := "%"+mv_par07+" %"
	EndIf

	If !Empty(mv_par08)
		cMarLin := "%"+mv_par08+" %"
	EndIf

	If ! Empty(mv_par09)
		cCliente := "%"+mv_par09+" %"
	EndIf

	If !Empty(mv_par10)
		cUF := "%"+mv_par10+" %"
	EndIf

	If !Empty(mv_par11)
		cLetra := "% AND "+mv_par11+" %"
	EndIf

	If SUBSTR(mv_par04,1,2) == '01'
		cSelect := "% B1_XMARCA MARCA %"
		cGroup  := "% B1_XMARCA %"
	ElseIf SUBSTR(mv_par04,1,2) == '02'
		cSelect := "% F2_VEND1 VEND,A3_NOME NOMVEND %"
		cGroup  := "% F2_VEND1, A3_NOME %"
	ElseIf SUBSTR(mv_par04,1,2) == '03'
		cSelect := "% A1_COD CLIENTE, A1_NOME NOMCLIE %"
		cGroup  := "% A1_COD, A1_NOME %"
	/*ElseIf SUBSTR(mv_par04,1,2) == '04'
		cSelect := "% F2_COND COND %"
		cGroup  := "% F2_COND %"
	*/
	ElseIf SUBSTR(mv_par04,1,2) == '04'
		cSelect := "% E4_INFER COND %"
		cGroup  := "% E4_INFER %"
	ElseIf SUBSTR(mv_par04,1,2) == '05'
		cSelect := "% F2_EST UF %"
		cGroup  := "% F2_EST %"
	ElseIf SUBSTR(mv_par04,1,2) == '06'
		cSelect := "% C6_XLETRA LETRA %"
		cGroup  := "% C6_XLETRA %"
	EndIf

	If SUBSTR(mv_par05,1,2) == '01'
		If SUBSTR(mv_par04,1,2) == '01'
			cOrder  := "% B1_XMARCA %"
		ElseIf SUBSTR(mv_par04,1,2) == '02'
			cOrder  := "% F2_VEND1 %"
		ElseIf SUBSTR(mv_par04,1,2) == '03'
			cOrder  := "% A1_COD %"
		/*ElseIf SUBSTR(mv_par04,1,2) == '04'
			cOrder  := "% F2_COND %"   */
		ElseIf SUBSTR(mv_par04,1,2) == '04'
			cOrder  := "% E4_INFER %"   
		ElseIf SUBSTR(mv_par04,1,2) == '05'
			cOrder  := "% F2_EST %"
		ElseIf SUBSTR(mv_par04,1,2) == '06'
			cOrder  := "% C6_XLETRA %"
		EndIf
	ElseIf SUBSTR(mv_par05,1,2) == '02'
		cOrder  := "% 2 %"//"% SUM(TOTPROD) %"
	ElseIf SUBSTR(mv_par05,1,2) == '03'
		cOrder  := "% 3 %"//SUM(CUSTO)
	ElseIf SUBSTR(mv_par05,1,2) == '04'
		cOrder  := "% 4 %" //SUM(ICMS + PIS + COFINS)
	ElseIf SUBSTR(mv_par05,1,2) == '05'
		cOrder  := "% 8 %" //SUM(FRETE)
	ElseIf SUBSTR(mv_par05,1,2) == '06'
		cOrder  := "% 9 %" //SUM(VLRCOM)
	ElseIf SUBSTR(mv_par05,1,2) == '07'
		cOrder  := "% 5 %" //SUM( TOTPROD - (CUSTO + ICMS + PIS + COFINS) )
	ElseIf SUBSTR(mv_par05,1,2) == '08'
		cOrder  := "% 6 %" //ROUND((SUM( TOTPROD - (CUSTO + ICMS + PIS + COFINS) ) / SUM(TOTPROD) ) * 100,2)
	ElseIf SUBSTR(mv_par05,1,2) == '09'
		cOrder  := "% 10 %" //SUM( (TOTPROD + DESPESA + FRETE) - (CUSTO + ICMS + PIS + COFINS + VLRCOM) )
	ElseIf SUBSTR(mv_par05,1,2) == '10'
		cOrder  := "% 11 %" //ROUND((SUM( (TOTPROD + DESPESA + FRETE) - (CUSTO + ICMS + PIS + COFINS + VLRCOM) ) / SUM(TOTPROD) ) * 100,2)
	EndIf


	oSection1:BeginQuery()

	IF SUBSTR(mv_par04,1,2) <> '02'

		/*  Query para opção de totalização diferente de vendedor*/

		BeginSQL Alias cAlias1

			SELECT
			" " A
			, SUM(D2_TOTAL) TOTPROD
			, SUM(D2_CUSTO1) CUSTO
			, SUM( (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END)) + SUM(D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )  ICMSPISCOF
			, SUM(D2_TOTAL - (D2_CUSTO1  + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )) TOT_BRUTO
			, ROUND((SUM(D2_TOTAL - (D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )) / SUM(D2_TOTAL)) * 100, 2) PERC_BRUTO
			, SUM(D2_DESPESA) DESPESA
			, SUM(D2_VALFRE) FRETE
			, ROUND(SUM(D2_TOTAL * (D2_XPRCOM1/100) + (D2_TOTAL * (D2_XPRCOM2/100))),2) AS VLRCOM
			, ROUND(SUM((D2_TOTAL + D2_DESPESA + D2_VALFRE) - (D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) + (D2_TOTAL * (D2_XPRCOM1/100) + (D2_TOTAL * (D2_XPRCOM2/100))))),2) TOT_OPER
			, ROUND((SUM((D2_TOTAL + D2_DESPESA + D2_VALFRE) - ( D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) + (D2_TOTAL * (D2_XPRCOM1/100) + (D2_TOTAL * (D2_XPRCOM2/100))))) / SUM(D2_TOTAL)) * 100, 2) PERC_OPER
	//		, SUM(D2_TOTAL * E4_INFER) PRZTOT
			, SUM(CASE WHEN D2_ITEM = '01' THEN (select SUM(E1.E1_VALOR * (TO_DATE(E1.E1_VENCREA, 'YYYYMMDD') - TO_DATE(E1.e1_EMISSAO, 'YYYYMMDD')) ) FROM SE1010 E1 WHERE e1.e1_filial=A.D2_FILIAL and e1.E1_NUM=A.D2_DOC and e1.e1_cliente=A.D2_CLIENTE and e1.e1_emissao=A.D2_EMISSAO) ELSE 0 END) PRZTOT
			, SUM(CASE WHEN D2_ITEM = '01' THEN (select SUM(E1.E1_VALOR) FROM SE1010 E1 WHERE e1.e1_filial=A.D2_FILIAL and e1.E1_NUM=A.D2_DOC and e1.e1_cliente=A.D2_CLIENTE and e1.e1_emissao=A.D2_EMISSAO) ELSE 0 END) VLRTOT
			, %Exp:cSelect%
			FROM %Table:SD2% A
			LEFT JOIN %Table:SF2% B ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND B.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SB1% C ON D2_COD = B1_COD AND C.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SC6% D ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_PRODUTO = D2_COD AND C6_ITEM = D2_ITEMPV AND D.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA3% E ON F2_VEND1 = A3_COD AND E.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA1% F ON F2_CLIENTE = A1_COD AND F.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SE4% N ON F2_COND = E4_CODIGO AND N.D_E_L_E_T_ = ' ' 
			WHERE %Exp:cFilPar% 
			AND F2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
			AND D2_XOPER = '01'
			%Exp:cVend%
			AND (%Exp:cMarca% OR %Exp:cMarLin%)
			%Exp:cLetra%
			AND %Exp:cCliente%
			AND %Exp:cUF%	
			GROUP BY %Exp:cGroup%
			ORDER BY %Exp:cOrder%

		EndSQL
	
	ELSE
		/*  
		  Query para opção de totalização por vendedor: Será executada para o vendedor 1, 
		  depois para o vendedor 2 com UNION e em seguida agrupar para totalizar tudo
		*/

		BeginSQL Alias cAlias1

		SELECT ' ' A, SUM(TOTPROD) TOTPROD,SUM(TOTPROD) TOTPROD,SUM(CUSTO) CUSTO, SUM(ICMSPISCOF) ICMSPISCOF, SUM(TOT_BRUTO) TOT_BRUTO, SUM(PERC_BRUTO) PERC_BRUTO
				, SUM(DESPESA) DESPESA, SUM(FRETE) FRETE, SUM(VLRCOM) VLRCOM, SUM(TOT_OPER) TOT_OPER, SUM(PERC_OPER) PERC_OPER, SUM(PRZTOT) PRZTOT, SUM(VLRTOT) VLRTOT
				, VEND, NOMVEND
		FROM (
			SELECT
			  SUM(D2_TOTAL) TOTPROD
			, SUM(D2_CUSTO1) CUSTO
			, SUM( (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END)) + SUM(D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )  ICMSPISCOF
			, SUM(D2_TOTAL - (D2_CUSTO1  + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )) TOT_BRUTO
			, ROUND((SUM(D2_TOTAL - (D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) )) / SUM(D2_TOTAL)) * 100, 2) PERC_BRUTO
			, SUM(D2_DESPESA) DESPESA
			, SUM(D2_VALFRE) FRETE
			, ROUND(SUM(D2_TOTAL * (D2_XPRCOM1/100) ),2) AS VLRCOM
			, ROUND(SUM((D2_TOTAL + D2_DESPESA + D2_VALFRE) - (D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) + (D2_TOTAL * (D2_XPRCOM1/100) + (D2_TOTAL * (D2_XPRCOM2/100))))),2) TOT_OPER
			, ROUND((SUM((D2_TOTAL + D2_DESPESA + D2_VALFRE) - ( D2_CUSTO1 + (CASE WHEN (D2_FILIAL = '020108' AND F.A1_GRPTRIB IN ('020','025') AND F.A1_EST = 'SE' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN ROUND(D2_BASEICM * 0.08,2) WHEN 
			(D2_FILIAL = '020108' AND C.B1_GRTRIB BETWEEN '005' AND '099') THEN 0 ELSE (CASE WHEN D2_FILIAL NOT IN ('020101','020105') AND SUBSTR(D2_CF,1,1) = '6' THEN 0 ELSE D2_VALICM END) END) + D2_VALIMP6 + D2_VALIMP5 + ROUND((D2_DESPESA + D2_VALFRE)*0.0925,2) + (D2_TOTAL * (D2_XPRCOM1/100) + (D2_TOTAL * (D2_XPRCOM2/100))))) / SUM(D2_TOTAL)) * 100, 2) PERC_OPER
			, SUM(CASE WHEN D2_ITEM = '01' THEN (select SUM(E1.E1_VALOR * (TO_DATE(E1.E1_VENCREA, 'YYYYMMDD') - TO_DATE(E1.e1_EMISSAO, 'YYYYMMDD')) ) FROM SE1010 E1 WHERE e1.e1_filial=A.D2_FILIAL and e1.E1_NUM=A.D2_DOC and e1.e1_cliente=A.D2_CLIENTE and e1.e1_emissao=A.D2_EMISSAO) ELSE 0 END) PRZTOT
			, SUM(CASE WHEN D2_ITEM = '01' THEN (select SUM(E1.E1_VALOR) FROM SE1010 E1 WHERE e1.e1_filial=A.D2_FILIAL and e1.E1_NUM=A.D2_DOC and e1.e1_cliente=A.D2_CLIENTE and e1.e1_emissao=A.D2_EMISSAO) ELSE 0 END) VLRTOT
			, %Exp:cSelect%
			FROM %Table:SD2% A
			LEFT JOIN %Table:SF2% B ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND B.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SB1% C ON D2_COD = B1_COD AND C.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SC6% D ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_PRODUTO = D2_COD AND C6_ITEM = D2_ITEMPV AND D.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA3% E ON F2_VEND1 = A3_COD AND E.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA1% F ON F2_CLIENTE = A1_COD AND F.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SE4% N ON F2_COND = E4_CODIGO AND N.D_E_L_E_T_ = ' ' 

			WHERE %Exp:cFilPar% 
			AND F2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
			AND D2_XOPER = '01'
			%Exp:cVend%
			AND (%Exp:cMarca% OR %Exp:cMarLin%)
			%Exp:cLetra%
			AND %Exp:cCliente%
			AND %Exp:cUF%	
			GROUP BY %Exp:cGroup%

			UNION

			SELECT
			  SUM(0) TOTPROD
			, SUM(0) CUSTO
			, SUM(0) ICMSPISCOF
			, SUM(0) TOT_BRUTO
			, SUM(0) PERC_BRUTO
			, SUM(0) DESPESA
			, SUM(0) FRETE
			, ROUND(SUM( (D2_TOTAL * (D2_XPRCOM2/100) ) ),2) AS VLRCOM
			, SUM(0) TOT_OPER
			, SUM(0) PERC_OPER
			, SUM(0) PRZTOT
			, SUM(0) VLRTOT
			, F2_VEND2 VEND,A3_NOME NOMVEND 
			FROM %Table:SD2% A
			LEFT JOIN %Table:SF2% B ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND B.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SB1% C ON D2_COD = B1_COD AND C.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SC6% D ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_PRODUTO = D2_COD AND C6_ITEM = D2_ITEMPV AND D.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA3% E ON F2_VEND2 = A3_COD AND E.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SA1% F ON F2_CLIENTE = A1_COD AND F.D_E_L_E_T_ = ' ' 
			LEFT JOIN %Table:SE4% N ON F2_COND = E4_CODIGO AND N.D_E_L_E_T_ = ' ' 
			WHERE %Exp:cFilPar% 
			AND F2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
			AND D2_XOPER = '01'
			AND D2_TOTAL * (D2_XPRCOM2/100) > 0
			%Exp:cVend%
			AND (%Exp:cMarca% OR %Exp:cMarLin%)
			%Exp:cLetra%
			AND %Exp:cCliente%
			AND %Exp:cUF%	
			GROUP BY F2_VEND2, A3_NOME
			
			)
			GROUP BY VEND, NOMVEND
			ORDER BY VEND

		EndSQL

	endif

	oSection1:EndQuery()
	//MemoWrite( "c:\temp\RFAT004.txt", oSection1:cQuery )

	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cAlias1)->(A) >= cParam .and. (cAlias1)->(A) <= cParam},{|| (cAlias1)->(A) })

	//oReport:SetMeter((cAlias1)->(RecCount()))

	Count To nCount

	If nCount > 0
		DbSelectArea(cAlias1)
		(cAlias1)->(DbGoTop())
	Endif

	//Imprime resultado da query
	oSection1:Print()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CriaSX1   ³ Autor ³ Marcelo Celi Marques  ³ Data ³ 02/10/08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza perguntas no SX1                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³CriaSX1() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³FINR501()     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSx1(cPerg)

	Local aArea 	:= GetArea()
	Local aHelpPor 	:= {}

	xPutSx1(cPerg,"01","Filiais"," "," ","mv_ch1",;
		"C",50,0,0,"R","","SM0","","S","mv_par01"," "," "," ","F2_FILIAL",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"02","Data De","","","mv_ch2",;
		"D",8,0,0,"G","","","","S","mv_par02"," "," "," "," ",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"03","Data De","","","mv_ch3",;
		"D",8,0,0,"G","","","","S","mv_par03"," "," "," "," ",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"04","Detalhamento"," "," ","mv_ch4",;
		"C",15,0,0,"G","NAOVAZIO() .AND. ExistCpo('SX5','Z8'+SUBSTR(MV_PAR04,1,2))","SX5Z8","","S","mv_par04"," "," "," ","",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"05","Ordenar por"," "," ","mv_ch5",;
		"C",25,0,0,"G","NAOVAZIO() .AND. ExistCpo('SX5','Z9'+SUBSTR(MV_PAR05,1,2))","SX5Z9","","S","mv_par05"," "," "," ","",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"06","Repr./Vend."," "," ","mv_ch6",;
		"C",50,0,0,"R","","SA3","","S","mv_par06"," "," "," ","F2_VEND1",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"07","Fornecedor"," "," ","mv_ch7",;
		"C",50,0,0,"R","","ZZ7","","S","mv_par07"," "," "," ","B1_XMARCA",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"08","Fornec./Linha"," "," ","mv_ch8",;
		"C",99,0,0,"R","","ZZNREL","","S","mv_par08"," "," "," ","B1_XMARCA||'/'||B1_XLINHA",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"09","Cliente"," "," ","mv_ch9",;
		"C",50,0,0,"R","","SA1","","S","mv_par09"," "," "," ","F2_CLIENTE",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"10","UF"," "," ","mv_cha",;
		"C",50,0,0,"R","","SX512","","S","mv_par10"," "," "," ","F2_EST",;
		" "," "," "," "," "," ", " "," "," "," "," "," ",;
		aHelpPor,,)

	xPutSx1(cPerg,"11","Letra"," "," ","mv_chb",;
		"C",50,0,0,"R","","ZZI","","S","mv_par11"," "," "," ","C6_XLETRA",;
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
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme	:= Iif( cPyme	== Nil, " ", cPyme	)
	cF3		:= Iif( cF3		== NIl, " ", cF3	)
	cGrpSxg := Iif( cGrpSxg	== Nil, " ", cGrpSxg)
	cCnt01	:= Iif( cCnt01	== Nil, "" , cCnt01	)
	cHelp	:= Iif( cHelp	== Nil, "" , cHelp	)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt 	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa 	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng 	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   	With cGrupo
		Replace X1_ORDEM   	With cOrdem
		Replace X1_PERGUNT 	With cPergunt
		Replace X1_PERSPA 	With cPerSpa
		Replace X1_PERENG 	With cPerEng
		Replace X1_VARIAVL 	With cVar
		Replace X1_TIPO    	With cTipo
		Replace X1_TAMANHO 	With nTamanho
		Replace X1_DECIMAL 	With nDecimal
		Replace X1_PRESEL	With nPresel
		Replace X1_GSC     	With cGSC
		Replace X1_VALID   	With cValid

		Replace X1_VAR01   	With cVar01

		Replace X1_F3      	With cF3
		Replace X1_GRPSXG 	With cGrpSxg

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
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort 	:= ! "?" $ X1_PERGUNT	.And. ! Empty(SX1->X1_PERGUNT)
		lSpa 	:= ! "?" $ X1_PERSPA 	.And. ! Empty(SX1->X1_PERSPA)
		lIngl 	:= ! "?" $ X1_PERENG 	.And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
