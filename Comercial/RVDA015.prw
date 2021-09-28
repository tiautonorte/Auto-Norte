#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE _ENTER chr(10)+chr(13)
//-----------------------------------------------------------------------
// Rotina | RVDA015   | Autor | Gustavo Costa | Data | 13.09.2021
//-----------------------------------------------------------------------
// Descr. | Gera relatório dCURVA A B C de cliente por unidade x cliente OS.: 12995
//-----------------------------------------------------------------------

user function RVDA015()

	Local oReport
	Local cAlias 	:= "TMP"//getNextAlias() //"TMP"

	Private cPerg 	:= "RVDA015"

	CriaSx1(cPerg)

	oReport := RptDef(cAlias,cPerg)
	oReport:PrintDialog()

return

Static Function RptDef(cAlias,cPerg)

	Local oReport  
	Local oSection1
	Local oSection2
	Local oBreak1
	Local cNomeRel := "CURVA A B C de cliente por unidade"

	oReport := TReport():New("RVDA015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias)},"")
	//oReport:nFontBody := 12
	//oReport:SetLineHeight(65)
	oReport:SetLandScape(.T.) // Imprimir o Relatorio em Paisagemadmin	
	//oReport:SetLandscape(.F.)
    //oReport:EndPage(.T.)

	Pergunte(cPerg, .T.)


	oSection1 := TRSection():New(oReport  ,cNomeRel,,,,,,,,,,,,.T.)

	oSection2 := TRSection():New(oSection1,"CurvaABC",,,,,,,,,,,6,.F.)
	TRCell():New(oSection2,"AGR"		,,""	 					,,01	,.F.,)
	TRCell():New(oSection2,"D2_FILIAL"	,,"Empresa"	 				,,20	,.F.,)

	TRCell():New(oSection2,"CLIENTE"	,,"Cliente"					,,10,.F.,)
	TRCell():New(oSection2,"LOJA"		,,"Loja"					,,02,.F.,)
	TRCell():New(oSection2,"NOME"		,,"Nome"					,,40,.F.,)

	TRCell():New(oSection2,"VAL_TOTAL"  ,,"VAL. TOTAL" 				,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,)
	TRCell():New(oSection2,"CLASSE"		,,"Classe"					,,01,.F.,)

	oBreak1 := TRBreak():New(oSection2,{ || oSection2:Cell('AGR'):uPrint },'Total',.F.)

	TRFunction():New(oSection2:Cell("VAL_TOTAL"),,'SUM',oBreak1,,"@E 999,999,999.99",,.T.,.F.,.F., oSection2)


	oSection1:SetTotalInLine(.F.)
	oSection2:SetTotalInLine(.F.)
	oReport:SetTotalInLine(.F.)
Return oReport

Static Function RptPrint(oReport,cAlias)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local cCfop		:= " ('" + StrTran(Formula("VND"),"/","','") + "') "
	Local cClasse	:= ""
	Local nTotalG	:= 0
	Local nTotalAC	:= 0
	//Local cDataFim	:= DtoS(LastDay(Stod(MV_PAR03 + "01")))

	If mv_par05 + mv_par06 + mv_par07 <> 100
		MsgAlert("A soma das faixas de classe tem que ser = 100 !", "Erro")
		RETURN
	EndIf

cQuery:="SELECT D2_FILIAL, F2_CLIENTE, F2_LOJA, A1_NOME, " + _ENTER
cQuery+= "SUM (D2_QUANT)  AS QTD_TOTAL, " + _ENTER
cQuery+= "SUM (D2_QUANT * D2_PRCVEN) AS VALOR " + _ENTER
cQuery+= "FROM " + RetSqlName("SD2") + " D2 " + _ENTER
cQuery+= "INNER JOIN " + RetSqlName("SF2") + " F2 " + _ENTER
cQuery+= "ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE " + _ENTER
cQuery+= "INNER JOIN " + RetSqlName("SA1") + " A1 " + _ENTER
cQuery+= "ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA " + _ENTER
cQuery+= "WHERE D2.d_e_l_e_t_ <> '*' " + _ENTER
cQuery+= "AND A1.d_e_l_e_t_ <> '*' " + _ENTER
cQuery+= "AND D2_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' " + _ENTER
cQuery+= "AND D2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + _ENTER
//cQuery+= "AND D2_CF IN " + cCfop + _ENTER
cQuery+= "AND D2_XOPER = '01' " + _ENTER
cQuery+= "GROUP BY D2_FILIAL, F2_CLIENTE, F2_LOJA, A1_NOME " + _ENTER
cQuery+= "ORDER BY 6 DESC " + _ENTER

cQuery := ChangeQuery(cQuery)

//MemoWrite( "c:\temp\RVDA015.txt", cQuery )

	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	EndIf

	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)},"Gerando Arquivo Trabalho...")
	
	//TCQUERY cQuery NEW ALIAS cAlias

	TcSetField(cAlias,"D2_FILIAL"	,"C",06	,0)
	TcSetField(cAlias,"CLIENTE"		,"C",60	,0)
	TcSetField(cAlias,"LOJA"		,"C",02	,0)
	TcSetField(cAlias,"NOME"		,"C",30	,0)
	//TcSetField(cAlias,"QTD_VAZIO"	,"N",13	,2)
	TcSetField(cAlias,"VAL_TOTAL"	,"N",13	,2)
	TcSetField(cAlias,"CLASSE"		,"C",01	,0)

	DBSelectArea("TMP")
	TMP->(DBGoTop())

	While !(cAlias)->(Eof()) 
		nTotalG 	:= nTotalG + (cAlias)->VALOR
		(cAlias)->(dbskip())		
	Enddo

	TMP->(DBGoTop())
	oSection1:Init()
	oSection2:Init()
	oSection2:SetParentQuery()
	//oSection1:SetParentFilter({|cParam| (cAlias)->(B1_XMARCA) >= cParam .and. (cAlias)->(B1_XMARCA) <= cParam},{|| (cAlias)->(B1_XMARCA)})
	oReport:SetMeter((cAlias)->(RecCount()))
	//oSection1:Print()
	
	While !(cAlias)->(Eof()) .and.!oReport:Cancel() 
		If oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()	

		while !(cAlias)->(Eof()) 

			oSection2:Cell("AGR"):SetValue("") 
			oSection2:Cell("D2_FILIAL"):SetValue(FWFilName ( "01", (cAlias)->D2_FILIAL )) 
			oSection2:Cell("CLIENTE"):SetValue((cAlias)->F2_CLIENTE) 
			oSection2:Cell("LOJA"):SetValue((cAlias)->F2_LOJA) 
			oSection2:Cell("NOME"):SetValue((cAlias)->A1_NOME) 
			oSection2:Cell("VAL_TOTAL"):SetValue((cAlias)->VALOR)

			nTotalAC := nTotalAC + (cAlias)->VALOR
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula classificacao ABC dos produtos.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotalAC <= nTotalG * (mv_par05 / 100)
				cClasse := "A"
			ElseIf nTotalAC <= nTotalG * ( (mv_par05 + mv_par06) / 100)
				cClasse := "B"
			Else
				cClasse := "C"
			Endif
			oSection2:Cell("CLASSE"):SetValue(cClasse) 

			oSection2:Printline() 
			DbSelectArea(cAlias)
			(cAlias)->(dbskip())		
		enddo
	Enddo
	// Finalizo a primeira seção
	oSection1:Finish()
	oSection2:Finish()

	If Select(cAlias) != 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf
Return

Static Function CriaSx1(cPerg)

	Local aAreaRet:=GetArea()
	Local aHelpPor:={}


	xPutSx1(cPerg,"01","Da Filial"," "," ","mv_ch1",;
	"C",06,0,0,"G","","SM0","","S","mv_par01"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"02","Ate Filial"," "," ","mv_ch2",;
	"C",06,0,0,"G","","SM0","","S","mv_par02"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"03","Periodo"," "," ","mv_ch3",;
	"D",8,0,0,"G","","","","S","mv_par03"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"04","Periodo"," "," ","mv_ch4",;
	"D",8,0,0,"G","","","","S","mv_par04"," "," "," ","",;
	" "," "," "," "," "," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"05","% da classe A ?"," "," ","mv_ch5",;
	"N",3,0,0,"G","","","","S","mv_par05",""," "," ","",;
	""," "," "," ",""," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"06","% da classe B ?"," "," ","mv_ch6",;
	"N",3,0,0,"G","","","","S","mv_par06",""," "," ","",;
	""," "," "," ",""," ", " "," "," "," "," "," ",;
	aHelpPor,,)

	xPutSx1(cPerg,"07","% da classe C ?"," "," ","mv_ch7",;
	"N",3,0,0,"G","","","","S","mv_par07",""," "," ","",;
	""," "," "," ",""," ", " "," "," "," "," "," ",;
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
