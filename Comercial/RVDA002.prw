#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"
user function RVDA002()

	Local oReport
	Local cAlias := getNextAlias()

	Private cPerg := "RVDA002"

	CriaSx1(cPerg)

	oReport := RptDef(cAlias,cPerg)
	oReport:PrintDialog()

return

Static Function RptDef(cAlias,cPerg)

	Local oReport  
	Local oSection1
	Local oSection2
	Local oSection3
	Local oBreak1
	Local oBreak2
	Local oBreak3
	Local cNomeRel := "Venda Fornecedor/Linha"

	oReport := TReport():New("RVDA002",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias)},"")
	oReport:nFontBody := 12
	oReport:SetLineHeight(65)
	//oReport:SetLandScape() // Imprimir o Relatorio em Paisagemadmin	
	oReport:SetLandscape(.F.)
    oReport:EndPage(.T.)

	Pergunte(cPerg, .T.)


	oSection1 := TRSection():New(oReport  ,cNomeRel,,,,,,,,,,,,.T.)
	//TRCell():New(oSection1,"B1_XMARCA"	,,"Fornec"				,,TamSX3("B1_XMARCA")[1]		,.F.,)
	
	//oSection2 := TRSection():New(oSection1,"B",,,,,,,,,,,,.T.)
	//TRCell():New(oSection2,"B1_XLINHA"	,,"Linha"				,,TamSX3("B1_XLINHA")[1]		,.F.,)

	oSection2 := TRSection():New(oSection1,"Vendas_Forn_Linh",,,,,,,,,,,5,.F.)
	TRCell():New(oSection2,"B1_XMARCA"	,,"Fornec"	 				,,TamSX3("B1_XMARCA")[1]	,.F.,)
	TRCell():New(oSection2,"ZZ7_DESCRI"	,,"Razao"				,,20,.F.,)
	TRCell():New(oSection2,"B1_XLINHA"	,,"Linha"					,,TamSX3("B1_XLINHA")[1]	,.F.,)
	TRCell():New(oSection2,"ESTATU"	    ,,"Estq Atual"				,"@E 999,999,999.99",TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New(oSection2,"VLREST"	    ,,"Vlr. Estq Atual"			,"@E 999,999,999.99",TamSX3("B2_VATU1")[1]	,.F.,)
	TRCell():New(oSection2,"QTDITE"	    ,,"Qtd. Item"				,"@E 999,999,999.99",TamSX3("D2_QUANT")[1]	,.F.,)
	TRCell():New(oSection2,"TOTITE"	    ,,"Vlr.Tot Item"			,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,)
	
	
	oBreak1 := TRBreak():New(oSection2,{ || oSection2:Cell('B1_XMARCA'):uPrint },'Total Fornec',.F.)
	//oBreak2 := TRBreak():New(oSection2,{ || oSection2:Cell('B1_XLINHA'):uPrint  },'Total Linha',.F.)	

	TRFunction():New(oSection2:Cell('ESTATU'),,'SUM',oBreak1,,"@E 999,999,999.99",,.T.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell('VLREST'),,'SUM',oBreak1,,"@E 999,999,999.99",,.T.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell('QTDITE'),,'SUM',oBreak1,,"@E 999,999,999.99",,.T.,.F.,.F., oSection2)
	TRFunction():New(oSection2:Cell('TOTITE'),,'SUM',oBreak1,,"@E 999,999,999.99",,.T.,.F.,.F., oSection2)

	/*TRFunction():New(oSection2:Cell('ESTATU'),,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection2:Cell('VLREST'),,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection2:Cell('QTDITE'),,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection2:Cell('TOTITE'),,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection1)*/
	oSection2:SetTotalInLine(.F.)
	oSection1:SetTotalInLine(.F.)
	oReport:SetTotalInLine(.F.)
Return oReport

Static Function RptPrint(oReport,cAlias)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local cEmp
	Local cFornec
	Local cLinha
	Local cSubSel
	local nCont
	local teste
	//Local cEmpresa := alltrim(""+MV_PAR01+"")
	if !";"$MV_PAR01
		MV_PAR01:=alltrim(MV_PAR01)+";"
	endif
	cRepoFiliais := MV_PAR01
	if At("-", MV_PAR01 ) > 0
		cRepoFiliais :=""
		cFilDe := substr(MV_PAR01,1,At("-", MV_PAR01 )-1)
		cFilAte := substr(MV_PAR01,At("-", MV_PAR01 )+1,len(MV_PAR01)-1)
		nRegM0   := SM0->(Recno())
		SM0->(DBSeek(cEmpAnt, .T.))
		Do While !SM0->(Eof()) .And. SM0->M0_CODIGO == cEmpAnt
			If SM0->M0_CODFIL >= cFilDe .And. SM0->M0_CODFIL <= cFilAte
				//aAdd(aFiliais, SM0->M0_CODFIL)
				cRepoFiliais+="'"+alltrim(SM0->M0_CODFIL)+"';"
			EndIf
			SM0->(dbSkip())
		EndDo
		SM0->(dbGoto(nRegM0))
	endif

	MakeSqlExpr("RVDA002")

	cEmp := ''
	IF !EMPTY(MV_PAR01)
		cEmp := MV_PAR01
	ElSE
		cEmp := " D2_FILIAL LIKE '0201%' "
	ENDIF

	cFornec :=''
	IF !EMPTY(MV_PAR04)
		cFornec := MV_PAR04
	ElSE
		cFornec := " B1_XMARCA <> ' ' "
	ENDIF

	cLinha :=''
	IF !EMPTY(MV_PAR05)
		cLinha := MV_PAR05
	ElSE
		cLinha := " B1_XLINHA <> ' ' "
	ENDIF

cEmiIni :=MV_PAR02
cEmiFim :=MV_PAR03
cDTEstoq:=MV_PAR06

cQuery:="select B1_XMARCA,B1_XLINHA,
//cQuery+=" zz7_descri,
cQuery+="sum( (nvl(B9_QINI,0)+nvl(D1_SUMQTD,0)-nvl(D2_SUMQTD,0)+nvl(D3_SUMQTD,0)) ) ESTATU,
cQuery+="sum( nvl(B9_VINI1,0)+nvl(D1_SUMCUSTO,0)-nvl(D2_SUMCUSTO,0)+nvl(D3_SUMCUSTO,0) ) VLREST ,
cQuery+="sum( nvl(d2_fatqtd,0) ) QTDITE,
cQuery+="sum( nvl(d2_fatval,0) ) TOTITE from
cQuery+= "		(

crepofiliais:=strtran(alltrim(crepofiliais),",",";")
if right(crepofiliais,1)=";"
	crepofiliais:=left(alltrim(crepofiliais),len(alltrim(crepofiliais))-1)
endif
aRepoFiliais:=STRTOKARR(crepofiliais,';')

For nCont:= 1 to Len(aRepoFiliais) 
	cTmp:= "'"+strtran(alltrim(aRepoFiliais[nCont]),"'","")+"'"
	aRepoFiliais[nCont]:=cTmp
next

For nCont:= 1 to Len(aRepoFiliais) 
		if nCont>1
			cQuery +=" UNION "
		endif
		cSubSel:= "	(SELECT
		cSubSel+= "		MAX(b6_produto)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sb6010 sb6
		cSubSel+= "	WHERE
		cSubSel+= "		sb6.b6_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sb6.b6_atend <> 'S'
		cSubSel+= "		AND sb6.b6_produto = sb1.b1_cod
		cSubSel+= "		AND sb6.d_e_l_e_t_ = ' '
		cSubSel+= ") b6_produto,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		MAX(d1_cod)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd1010 sd1
		cSubSel+= "	WHERE
		cSubSel+= "		sd1.d1_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd1.d1_cod = sb2.b2_cod
		cSubSel+= "		AND sd1.d1_local = sb2.b2_local
		cSubSel+= "		and sd1.d1_dtdigit>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd1.d1_dtdigit <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd1.d_e_l_e_t_ = ' '
		cSubSel+= ") d1_cod,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d1_quant)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd1010   sd1,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd1.d1_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd1.d1_filial = f4_filial
		cSubSel+= "		AND sd1.d1_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd1.d1_cod = sb2.b2_cod
		cSubSel+= "		AND sd1.d1_local = sb2.b2_local
		cSubSel+= "		and sd1.d1_dtdigit>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd1.d1_dtdigit <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd1.d_e_l_e_t_ = ' '
		cSubSel+= ") d1_sumqtd,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d1_custo)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd1010   sd1,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd1.d1_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd1.d1_filial = f4_filial
		cSubSel+= "		AND sd1.d1_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd1.d1_cod = sb2.b2_cod
		cSubSel+= "		AND sd1.d1_local = sb2.b2_local
		cSubSel+= "		and sd1.d1_dtdigit>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd1.d1_dtdigit <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd1.d_e_l_e_t_ = ' '
		cSubSel+= ") d1_sumcusto,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		MAX(d2_cod)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd2010 sd2
		cSubSel+= "	WHERE
		cSubSel+= "		sd2.d2_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd2.d2_cod = sb2.b2_cod
		cSubSel+= "		AND sd2.d2_local = sb2.b2_local
		cSubSel+= "		and sd2.d2_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd2.d2_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd2.d_e_l_e_t_ = ' '
		cSubSel+= ") d2_cod,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d2_quant)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd2010   sd2,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd2.d2_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd2.d2_filial = f4_filial
		cSubSel+= "		AND sd2.d2_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd2.d2_cod = sb2.b2_cod
		cSubSel+= "		AND sd2.d2_local = sb2.b2_local
		cSubSel+= "		and sd2.d2_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd2.d2_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd2.d_e_l_e_t_ = ' '
		cSubSel+= ") d2_sumqtd,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d2_quant)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd2010   sd2,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd2.d2_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd2.d2_filial = f4_filial
		cSubSel+= "		AND sd2.d2_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd2.d2_cod = sb2.b2_cod
		cSubSel+= "		AND sd2.d2_local = sb2.b2_local
		cSubSel+= "		and sd2.d2_emissao>='"+dtos(cEmiIni)+"'
		cSubSel+= "		and sd2.d2_emissao <= '"+dtos(cEmiFim)+"'
		cSubSel+= "		and sd2.d2_xoper='01'
		cSubSel+= "		AND sd2.d_e_l_e_t_ = ' '
		cSubSel+= ") d2_fatqtd,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d2_total)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd2010   sd2,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd2.d2_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd2.d2_filial = f4_filial
		cSubSel+= "		AND sd2.d2_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd2.d2_cod = sb2.b2_cod
		cSubSel+= "		AND sd2.d2_local = sb2.b2_local
		cSubSel+= "		and sd2.d2_emissao>='"+dtos(cEmiIni)+"'
		cSubSel+= "		and sd2.d2_emissao <= '"+dtos(cEmiFim)+"'
		cSubSel+= "		and sd2.d2_xoper='01'
		cSubSel+= "		AND sd2.d_e_l_e_t_ = ' '
		cSubSel+= ") d2_fatval,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(d2_custo1)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd2010   sd2,
		cSubSel+= "		dadosanl.sf4010   sf4
		cSubSel+= "	WHERE
		cSubSel+= "		sd2.d2_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd2.d2_filial = f4_filial
		cSubSel+= "		AND sd2.d2_tes = sf4.f4_codigo
		cSubSel+= "		AND sf4.f4_estoque = 'S'
		cSubSel+= "		AND sd2.d2_cod = sb2.b2_cod
		cSubSel+= "		AND sd2.d2_local = sb2.b2_local
		cSubSel+= "		and sd2.d2_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd2.d2_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd2.d_e_l_e_t_ = ' '
		cSubSel+= ") d2_sumcusto,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		MAX(d3_cod)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd3010 sd3
		cSubSel+= "	WHERE
		cSubSel+= "		sd3.d3_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd3.d3_cod = sb2.b2_cod
		cSubSel+= "		AND sd3.d3_local = sb2.b2_local
		cSubSel+= "		and sd3.d3_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd3.d3_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd3.d_e_l_e_t_ = ' '
		cSubSel+= ") d3_cod,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(
		cSubSel+= "			CASE
		cSubSel+= "				WHEN sd3.d3_tm > '500' THEN
		cSubSel+= "					d3_quant * - 1
		cSubSel+= "				ELSE
		cSubSel+= "					d3_quant
		cSubSel+= "			END
		cSubSel+= "		)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd3010 sd3
		cSubSel+= "	WHERE
		cSubSel+= "		sd3.d3_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd3.d3_cod = sb2.b2_cod
		cSubSel+= "		AND sd3.d3_local = sb2.b2_local
		cSubSel+= "		and sd3.d3_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd3.d3_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd3.d_e_l_e_t_ = ' '
		cSubSel+= "		AND d3_estorno = ' '
		cSubSel+= ") d3_sumqtd,
		cSubSel+= "(
		cSubSel+= "	SELECT
		cSubSel+= "		SUM(
		cSubSel+= "			CASE
		cSubSel+= "				WHEN sd3.d3_tm > '500' THEN
		cSubSel+= "					d3_custo1 * - 1
		cSubSel+= "				ELSE
		cSubSel+= "					d3_custo1
		cSubSel+= "			END
		cSubSel+= "		)
		cSubSel+= "	FROM
		cSubSel+= "		dadosanl.sd3010 sd3
		cSubSel+= "	WHERE
		cSubSel+= "		sd3.d3_filial = "+aRepoFiliais[nCont]+" "
		cSubSel+= "		AND sd3.d3_cod = sb2.b2_cod
		cSubSel+= "		AND sd3.d3_local = sb2.b2_local
		cSubSel+= "		and sd3.d3_emissao>=nvl(to_char(sb9.b9_data+1),0)
		cSubSel+= "		and sd3.d3_emissao <= '"+dtos(cDTEstoq)+"'
		cSubSel+= "		AND sd3.d_e_l_e_t_ = ' '
		cSubSel+= "		AND d3_estorno = ' '
		cSubSel+= ") d3_sumcusto ,

		//cQuery+=" 
		cQuery+="	SELECT
		cQuery+=" B1_XMARCA,B1_XLINHA,
		cQuery+="	sb1.b1_cod,
		cQuery+="	sb2.b2_cod,
		cQuery+="	sb2.b2_filial,
		cQuery+="	sb2.b2_local,
		cQuery+="	sb2.b2_qatu,
		cQuery+="	sb2.r_e_c_n_o_ b2rec,
		cQuery+="	sb9.b9_cod,
		cQuery+="	sb9.b9_qini,
		cQuery+="	"+cSubSel
		cQuery+="	sb9.b9_vini1
		cQuery+=" FROM
		cQuery+="	dadosanl.sb1010 sb1
		cQuery+="	LEFT JOIN dadosanl.sb2010 sb2 ON sb2.b2_filial = "+aRepoFiliais[nCont]+" "
		cQuery+="							AND sb2.b2_cod = sb1.b1_cod
		cQuery+="							AND sb2.b2_local BETWEEN '01' AND '20'
		cQuery+="							AND sb2.d_e_l_e_t_ = ' '
		cQuery+="	LEFT OUTER JOIN (
		cQuery+="		SELECT
		cQuery+="			b9_cod,
		cQuery+="			b9_local,
		cQuery+="			case when b9_data=' ' then '00000000' else b9_data end b9_data,
		cQuery+="			b9_qini,
		cQuery+="			b9_vini1
		cQuery+="		FROM
		cQuery+="			dadosanl.sb9010 sb9a
		cQuery+="		WHERE
		cQuery+="			sb9a.b9_filial = "+aRepoFiliais[nCont]+" "
		cQuery+="			AND sb9a.b9_data = (
		cQuery+="				SELECT
		cQuery+="					MAX(sb9b.b9_data)
		cQuery+="				FROM
		cQuery+="					dadosanl.sb9010 sb9b
		cQuery+="				WHERE
		cQuery+="					sb9b.b9_filial = "+aRepoFiliais[nCont]+" "
		cQuery+="					AND sb9b.b9_cod = sb9a.b9_cod
		cQuery+="					AND sb9b.b9_local = sb9a.b9_local
		cQuery+="					AND sb9b.b9_data <= '"+dtos(cDTEstoq)+"'"
		cQuery+="					AND sb9b.d_e_l_e_t_ = ' '
		cQuery+="			)
		cQuery+="			AND sb9a.d_e_l_e_t_ = ' '
		cQuery+="	) sb9 ON sb9.b9_cod = sb2.b2_cod
		cQuery+="			AND sb9.b9_local = sb2.b2_local
		cQuery+=" WHERE
		cQuery+="	sb1.b1_filial = '0201  '
		cQuery+="	AND sb1.b1_cod <> '               '
		cQuery+="	AND sb1.b1_cod BETWEEN '           ' AND 'ZZZZZZZZZZZ'
		cQuery+="	AND sb1.b1_tipo = 'ME'
		cQuery+="	AND "+cFornec
		cQuery+="	AND "+cLinha
		cQuery+="	AND sb1.d_e_l_e_t_ = ' '
//		cQuery+=" ORDER BY
//		cQuery+="	sb1.b1_cod,
//		cQuery+="	sb2.b2_local
Next

cQuery+=") FATMARC
cQuery+=" group by B1_XMARCA,B1_XLINHA
cQuery+=" order by B1_XMARCA,B1_XLINHA

		

	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)},"Gerando Arquivo Trabalho...")
	TcSetField(cAlias,"B1_XMARCA"		,"C",10	,0)
	TcSetField(cAlias,"ZZ7_DESCRI"		,"C",40	,0)
	TcSetField(cAlias,"B1_XLINHA"		,"C",10	,0)
	TcSetField(cAlias,"ESTATU"		,"N",13	,2)
	TcSetField(cAlias,"VLREST"		,"N",13	,2)
	TcSetField(cAlias,"QTDITE"		,"N",13	,2)
	TcSetField(cAlias,"TOTITE"		,"N",13	,2)

	//ctmpquery := oSection1:GetQuery()
	//oSection1:EndQuery()


	//TcSetField(cAlias,"D3_EMISSAO","D",8,0)
	(cAlias)->(DbGoTop())
	//oSection1:Init()
	//if oreport:LEXCELWRXML
//		oSection1:Cell("B1_XMARCA"):hide()
	//endif
	//else
	//	oReport:Section(1):hide()
	//endif
	oSection2:Init()
	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cAlias)->(B1_XMARCA) >= cParam .and. (cAlias)->(B1_XMARCA) <= cParam},{|| (cAlias)->(B1_XMARCA)})
	oReport:SetMeter((cAlias)->(RecCount()))
	//oSection2:Print()
	
	While !(cAlias)->(Eof()) .and.!oReport:Cancel() 
		If oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()	
			

		cPForn:=(cAlias)->B1_XMARCA		

		//if !oreport:LEXCELWRXML
			//oSection1:Cell("B1_XMARCA"):SetValue((cAlias)->B1_XMARCA)
			//oSection1:Printline() 
		//else
			//oSection1:hide() 
			//oSection1:Cell("B1_XMARCA"):disable()
			//oSection1:init()
			//oSection1:SetHeaderSection
		//endif

		while !(cAlias)->(Eof()) .and. (cAlias)->B1_XMARCA=cPForn
			oSection2:Cell("B1_XMARCA"):SetValue((cAlias)->B1_XMARCA)
			cZZ7_DESCRIC := Posicione("ZZ7",1,xFilial("ZZ7")+(cAlias)->B1_XMARCA,"ZZ7_DESCRI")
			oSection2:Cell("ZZ7_DESCRI"):SetValue(cZZ7_DESCRIC)
			oSection2:Cell("B1_XLINHA"):SetValue((cAlias)->B1_XLINHA)
			oSection2:Cell("ESTATU"):SetValue((cAlias)->ESTATU)
			oSection2:Cell("VLREST"):SetValue((cAlias)->VLREST)
			oSection2:Cell("QTDITE"):SetValue((cAlias)->QTDITE)
			oSection2:Cell("TOTITE"):SetValue((cAlias)->TOTITE)
			oSection2:Printline() 
			DbSelectArea(cAlias)
			(cAlias)->(dbskip())		
		enddo
	Enddo
	// Finalizo a primeira seção
	oSection2:Finish()

	If Select(cAlias) != 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf
Return


Static Function CriaSx1(cPerg)

	Local aAreaRet:=GetArea()
	Local aHelpPor:={}


	xPutSx1(cPerg,"01","Empresas:"," "," ","mv_ch1",;
	"C",60,0,0,"R","","SM0","","S","mv_par01"," "," "," ","D2_FILIAL",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"02","Data De:"," "," ","mv_ch2",;
	"D",8,0,0,"G","","","","S","mv_par02"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"03","Data Ate:"," "," ","mv_ch3",;
	"D",8,0,0,"G","","","","S","mv_par03"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"04","Fornec:"," "," ","mv_ch4",;
	"C",20,0,0,"R","","ZZ7","","S","mv_par04"," "," "," ","B1_XMARCA",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)


	xPutSx1(cPerg,"05","Linha:"," "," ","mv_ch5",;
	"C",50,0,0,"R","","ZZ8","","S","mv_par05"," "," "," ","B1_XLINHA",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"06","Dt.Base Estoq:"," "," ","mv_ch6",;
	"D",8,0,0,"G","","","","S","mv_par06"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)


	RestArea(aAreaRet)
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
	aHelpPor,aHelpEng,aHelpSpa,cHelp,cPicture)

	LOCAL aAreaRet := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validaï¿½ï¿½o dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
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
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		Replace X1_PICTURE With cPicture //Inclusao do campo X1_PICTURE

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

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

	RestArea( aAreaRet )

Return
