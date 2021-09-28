#include "Protheus.CH"
#include "FWMVCDef.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER Chr(10)+Chr(13)

User Function IMPJOB()

	Local aLstSobP := {}
// Seta job para nao consumir licensas
	RpcSetType(3)
// Seta job para empresa filial desejadas
	RpcSetEnv("01","020101",,,"EST",,{"AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"})

	Conout("Início da execução do JOBM330")
//-- Adiciona filial a ser processada

	u_ImpFileTXT(.T.,"01","020101","   ", "Filial Corrente", "c:\microsiga\clientes\autonorte\lista de preços\mahle.csv", "Sim", "MAHLE", aLstSobP, "RR")

Return
//--------------------------------------------------------------------------------------------------------------------------------------------
//
User Function ImpFileTXT(_lJob, _cEmpresa, _cFil,_cTabOri, aSelFil, _cFileTab, cFilPrd, _cCodMarc, aLstSobP, _cDescTab, _aTabID, _aCodForn)

	Local aDados       := {}
	Local cLinha       := ""
	Local lErro	       := .F.
	Local lHlpDark
	Local _aCabec		:= {}
	Local cSet       := Set(_SET_DATEFORMAT)
	LOCAL cStartPath := GetSrvProfString("Startpath","")
	Local nB		 := 1
	Local nJ		 := 1
	Local nX		 := 1
	Local nContL	 := 0
	Local cCodTab
	/*****
	Ita - 16/09/2020
	Declaração privadas de variáveis
	para utilizar na função fImpNotLoc()
	*********************************/
	Private _nPosCod := 0
	Private _nPosPRC := 0
	Private _nPosIPI := 0
	Private _nPosICM := 0
	Private _nPosGRP := 0
	Private _nPosSGP := 0
	Private _nPosUNP := 0
	Private _nPosRep := 0
	
	If _lJob
		// Seta job para nao consumir licensas
		RpcSetType(3)
		// Seta job para empresa filial desejada
		RpcSetEnv( _cEmpresa, _cFil,,,'COM',,{"SB1","SB2","SM2","SZ3","SA2","ZZM","ZZR", "SBZ", "DA1", "SZ2", "ACB", "AC9"})
		//Atualiza o DATEFORMAT conforme usuário logado
		Set(_SET_DATEFORMAT,cSet)
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o semaforo para controle do JOB                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cJobFile:=	cStartPath + "list"+_cEmpresa+_cFil+".job"
	If File(cJobFile)
		fErase("list"+_cEmpresa+_cFil+time()+".job")
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza dados do semaforo                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHdl	:=	MSFCreate(cJobFile)
	fWrite(nHdl,_cFil)                 		// Filial          02
	fWrite(nHdl,"inicio"+ENTER)
	cCodDA0	:= SuperGetMv("AN_TABPRC",.F.,"100")
	lHlpDark := HelpInDark(.T.)
	
	If FOpen(Alltrim(_cFileTab)) > 0

		fWrite(nHdl,"Abertura do arquivo "+ _cFileTab + ENTER)

		//Lê o arquivo completo
		FT_FUSE(_cFileTab)
		ProcRegua(FT_FLASTREC())
		nContT := FT_FLASTREC()
		FT_FGOTOP()
		
		While !FT_FEOF()
		    nContL++
			IncProc("Lendo dados do arquivo. Linha " + StrZero(nContL,6) + " de " + StrZero(nContT,6))
			cLinha := FT_FREADLN()
			
			If Len(_aCabec) == 0
			   
				_aCabec := aClone(Separa(cLinha,";",.T.))
				_nMaior := 0
				For nX:= 1 to Len(_aCabec)

					If "COD" $ UPPER(Alltrim(_aCabec[nX]))
						_nPosCod := nx
						_nMaior  := nx
					Endif
					If "PRC" $ UPPER(Alltrim(_aCabec[nX]))
						_nPosPRC := nx
						_nMaior  := nx
					Endif
					If "IPI" $ UPPER(Alltrim(_aCabec[nX]))
						_nPosIPI := nx
						_nMaior  := nx
					Endif
					If "ICM" $ UPPER(Alltrim(_aCabec[nX]))
						_nPosICM := nx
						_nMaior  := nx
					Endif
					If "GRUPO" == UPPER(Alltrim((_aCabec[nX])))
						_nPosGRP := nx
						_nMaior  := nx
					Endif
					If "SUBGRUPO" == UPPER(Alltrim((_aCabec[nX])))
						_nPosSGP := nx
						_nMaior  := nx
					Endif
					If "UNP" == UPPER(Alltrim((_aCabec[nX])))
						_nPosUNP := nx
						_nMaior  := nx
					Endif
					If "REP" $ UPPER(Alltrim((_aCabec[nX])))
						_nPosREP := nx
						_nMaior  := nx
					Endif
				Next nX

				If _nPosCod == 0 .or. _nPosPRC == 0
					fWrite(nHdl,"Verifique o arquivo pois não foram encontrados os campos referente ao Produto e ao Preço"+ENTER)
					Help(" ",1,"HELP","NFPROD","Verifique o arquivo pois não foram encontrados os campos referente ao Produto e ao Preço",3,1)
					lErro := .T.
					Return(lErro)
				Endif
			Else
				aAdd(aDados,Separa(cLinha,";",.T.))
				//validação das informações
				If _nPosCod > 0
					If Empty(aDados[Len(aDados),_nPosCod])
						FT_FSKIP()
						LOOP
					Endif
				Endif
				If _nPosPRC > 0
					If Empty(aDados[Len(aDados),_nPosPRC]) .OR. Len(Separa(aDados[Len(aDados),_nPosPRC],",")) > 2
						aDados[Len(aDados),_nPosPRC] := "0,01"
						MsgAlert("Verifique o arquivo pois não foram encontrados os Preços na posição"+cValToChar(Len(aDados)+1))
					Endif
				Endif
				If _nPosIPI > 0
					If Empty(aDados[Len(aDados),_nPosIPI]) .OR. Len(Separa(aDados[Len(aDados),_nPosIPI],",")) > 2
						aDados[Len(aDados),_nPosIPI] := "0,01"
						MsgAlert("Verifique o arquivo pois não foram encontrados os IPI na posição"+cValToChar(Len(aDados)))
					Endif
				Endif
/*
				If _nPosICM > 0
					If Empty(aDados[Len(aDados),_nPosICM]) .OR. Len(Separa(aDados[Len(aDados),_nPosICM],",")) > 2
						aDados[Len(aDados),_nPosICM] := "0,01"
						MsgAlert("Verifique o arquivo pois não foram encontrados os ICMS na posição"+cValToChar(Len(aDados)))
					Endif
				Endif
*/
				//Fim das validações
			Endif
			FT_FSKIP()
		EndDo
		FT_FUSE()
		If Len(aDados) > 0 .and. Len(_aCabec) > 0
			For nB:=1 to Len(_aTabID)
				cFilAnt := _aTabID[nB,1]
				cCodTab := _aTabID[nB,2]
				ProcRegua(Len(aDados))
				For nJ:=1 to Len(aDados)
					IncProc("Processando Filial " + cFilAnt + " Linha " + StrZero(nJ,6) + " de " + StrZero(Len(aDados),6))
					If Len(aDados[nJ]) < _nMaior
						Loop
					Endif
					u_ProcGerSZ3("0", cFilPrd, cCodTab, _cCodMarc, _aCodForn, aDados, nJ)
				Next
				dbSelectArea("SZ2")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ2")+cCodTab) .and. SZ2->Z2_STATUS == "4"
					dbSelectArea("SZ3")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ3")+cCodTab)
						RecLock("SZ2",.F.)
						Replace Z2_STATUS with '3'
						SZ2->(MsUnLock())
					Else
						If SZ2->Z2_STATUS <> '4' //Ita - 16/09/2020
						RecLock("SZ2",.F.)
						dbDelete()
						MsUnLock()
						EndIf
					Endif
				Endif
			Next
		Endif
	Else
		fWrite(nHdl," Nao foi possivel abrir o arquivo " + Alltrim(_cFileTab) + ENTER)
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza dados do semaforo e fecha semaforo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fWrite(nHdl," Final do job de importacao da lista de preco ")
// Fecha arquivo de controle do MATA330
	fClose(nHdl)

	ConOut(dtoc(Date())+" "+Time()+" Final do job de importacao da lista de preco "+cJobFile) //

	If _lJob
		//Desconecta da filial
		RpcClearEnv()
	Endif

Return
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function ProcGerSZ3(cParam, cFilPrd, cCodTab, _cCodMarc, _aCodForn, aDados, nJ)

Local _cCodInt   := " "
Local _cDescri   := " "
Local _cRefFor   := " "
Local _cGrpTrib  := " "
Local _nPisCOF   := 0
Local _nICMRET   := 0
Local _nCusto    := 0
Local cTES       := " "
Local _cMonoFas  := " "
Local _nMargem   := 0
Local _nDescVen  := 0
Local _nLetra    := 0
Local _nFator    := 0
Local _nMarKup   := 0
Local nAliqICMS  := 0
Local _cLetra    := " "
Local lLocaliza  := .F.
Local _cLinhaSB1 := " "
Local nX 		 := 1
Local _cTpOper   := SuperGetMv( 'MV_XOPREV' ,.F.,"01")
Local lImpPrdN   := Iif(Substr(cFilPrd,1,1) == "S",.T.,.F.)
Local nPrvBrt    := IIF(cParam == "0", Val(StrTran(aDados[nJ,_nPosPRC],",",".")), aDados[nJ,_nPosPRC])
Local _nAliqIPI  := IIF(cParam == "0", Val(StrTran(aDados[nJ,_nPosIPI],",",".")), aDados[nJ,_nPosIPI])
//Italo Maciel 20/07/2020 - Guarda produtos com mesmo XCODIMP
aProd := {}
If nPrvBrt > 0
	nIcms 	 := 0
	_cCodCsv := PADR(Alltrim(aDados[nJ,_nPosCod]), TAMSX3("B1_XCODIMP")[1])
	_cCodNew := PADR(u_RetCodSE(_cCodCsv), TAMSX3("B1_XCODIMP")[1])
	lLocaliza := u_LOCSB1IMP(_cCodNew,_cCodMarc,nIcms)
	lPrdBloq := .F.
	If !lLocaliza
		If !lImpPrdN
			Return
		Else
			fImpNotLoc(cParam, cCodTab,aDados, nJ)
		Endif
		Return
	Endif
	//Italo Maciel 20/07/2020 - Varre produtos encontrados com mesmo XCODIMP para gravar SZ3
	//MsgInfo("Array do Relacionamento - Len(aProd): "+cValToChar(Len(aProd)))
	For nX := 1 to Len(aProd)
		SB1->(dbGoTo(aProd[nX][1]))
		_cCodInt := SB1->B1_COD
		If lLocaliza .AND. nX == 1// .And. SB1->B1_MSBLQL <> "1"
			//Italo Maciel 21/07/2020 - codigo utilizado para função do tes inteligente
			cCodPrin := SB1->B1_COD
			lPrdBloq := SB1->B1_MSBLQL == "1"	
			_cDescPr := Alltrim(SB1->B1_DESC)
			_cDescri := PADR(RET_ACENT(_cDescPr), TAMSX3("Z3_DESCRI")[1])	// Retira caracter especiais
			_cRefFor := Substr(SB1->B1_XREFFOR,1, TAMSX3("Z3_REFFOR")[1])
			_cGrpTrib := SB1->B1_GRTRIB
			_cMonoFas := IIF(SB1->B1_XMONO=="S","S","N")
			_cLinhaSB1  := SB1->B1_XLINHA
			_nMargem  := 0
			dbSelectArea("SBZ")
			dbSetOrder(1)
			_cLetra 	:= u_BuscTabVig(_cCodInt)[1]
			_nDescVen   := u_BuscTabVig(_cCodInt)[4] //Ita - 10/08/2020 
			_aRetMark 	:= u_RetMarkup(_cMonoFas, _cCodMarc, _cLinhaSB1, cFilAnt)
			_nMarKup  	:= _aRetMark[1]
			_nLetra 	:= u_RetLetra(cFilAnt, _cLetra)
			_nMargem 	:= (1 + (_nMarKup/100)) * _nLetra
			_nMargem 	:= Round((_nMargem - 1) * 100,2)
			If _nMargem < 0
				_nMargem := 0
			Endif
			//Converte valores para a primeira unidade de medida - Walter - 14/02/2019
			If _nPosUNP > 0
				If Alltrim(aDados[nJ,_nPosUNP]) == Alltrim(Posicione("SB1",1,xFilial("SB1")+_cCodInt,"B1_SEGUM"))
					nConv := ConvUM(_cCodInt,0,1,1)
					If nConv <> 0
						nValCX := nPrvBrt
						aDados[nJ,_nPosPRC] := Round(nValCX/nConv,2)
					Endif
				Endif
			Endif
			//Fim da conversão
			If !Empty(cCodPrin)
				cTES := u_ANTesInt(/*nEntSai*/ 1,/*cTpOper*/ _cTpOper, _aCodForn[1,1],_aCodForn[1,2],"F",cCodPrin)
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+cTES)
					cCF := SF4->F4_CF
					If !Empty(SF4->F4_VENPRES) .And. SF4->F4_VENPRES <> "1" //Tes configurado para venda presencial nao altera CFOP
						If SA2->A2_EST == SuperGetMV("MV_ESTADO") .AND. SA2->A2_TIPO # "X"
							cCF := "1" + Subs(cCF,2,3)
						ElseIf SA2->A2_TIPO # "X"
							cCF := "2" + Subs(cCF,2,3)
						Else
							cCF := "3" + Subs(cCF,2,3)
						Endif
					EndIf
					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1") + cCodPrin))
						MaFisIni(_aCodForn[1,1],_aCodForn[1,2],"F","N",NIL,,,.F.,"SB1")
						MaFisIniLoad(1,{	SB1->B1_COD,;		//IT_PRODUTO
						cTES,; 			//IT_TES
						"",; 				//IT_CODISS
						1,;					//IT_QUANT
						" ",;			 	//IT_NFORI
						" ",; 				//IT_SERIORI
						SB1->(RecNo()),;	//IT_RECNOSB1
						SF4->(RecNo()),;	//IT_RECNOSF4
						0 ,;	 			//IT_RECORI
						" ",;				//IT_LOTECTL
						" " })				//IT_NUMLOTE
						MaFisTes(cTES,SF4->(RecNo()),1)
						MaFisRecal("",1)
						nAliqICMS 	:= MaFisRet(1,"IT_ALIQICM")
						MaFisEnd()
					Endif
				Endif
			Endif
		Endif
		dbSelectArea("SZ3")
		RecLock("SZ3",.T.)
		Replace Z3_FILIAL	with xFilial("SZ3")
		Replace Z3_COD 		with _cCodInt
		Replace Z3_CODPRIN	with cCodPrin //código principal para regra tes inteligente
		Replace Z3_DESCRI	with _cDescri
		Replace Z3_REFFOR	with _cRefFor
		Replace Z3_TPOPER	with "01"
		Replace Z3_GRTRIB	with _cGrpTrib
		Replace Z3_PISCOF	with _nPisCOF
		Replace Z3_TES		with cTES
		Replace Z3_PRCREP	with _nCusto
    	If _nPosREP > 0
        	Replace Z3_PRCREP	with aDados[nJ,_nPosREP]
	    Endif
		Replace Z3_ICMSRET	with _nICMRET
		Replace Z3_CODTAB	with cCodTab
		Replace Z3_MONOFAS	with _cMonoFas
		Replace Z3_CODREF	with _cCodNew
		Replace Z3_PRCBRT	with nPrvBrt
		Replace Z3_PRCLIQ	with nPrvBrt
		Replace Z3_LETRA	with _cLetra
		Replace Z3_MARGEM	with _nMargem
		Replace Z3_DESCVEN	with _nDescVen
		Replace Z3_FATOR	with _nFator
		Replace Z3_LINHA	with _cLinhaSB1
		Replace Z3_MARKUP	with _nMarKup
		If _nPosIPI > 0
			Replace Z3_IPI	with _nAliqIPI
		Endif
		If nAliqICMS > 0
			Replace Z3_ICMS	with nAliqICMS
			Replace Z3_NACIMP with IIF(nAliqICMS == 4,"I","N")
		Else
			Replace Z3_NACIMP with "N"
		Endif
		If _nPosGRP > 0
			Replace Z3_GRUPO	with aDados[nJ,_nPosGRP]
		Endif
		If _nPosSGP > 0
			Replace Z3_SUBGRP	with aDados[nJ,_nPosSGP]
		Endif
		MsUnLock()
	Next nX
Endif
Return

//------------------------------------------------------------------------------------------------------------
Static Function RET_ACENT(cExp)

	cExp := StrTran(cExp,"."," ")
	cExp := StrTran(cExp,"'"," ")
	cExp := StrTran(cExp,"ã","a")
	cExp := StrTran(cExp,CHR(10) ," ")
	cExp := StrTran(cExp,CHR(13) ," ")
	cExp := StrTran(cExp,CHR(151)," ")
Return(cExp)
//----------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//
User Function RetCodSE(_cCodRef)

	Local _cCodNew := ""
	Local _cLetra := ""
	If !Empty(_cCodRef)
		For nH:=1 to Len(_cCodRef)
			_cLetra := Substr(_cCodRef,nH,1)
			If (Asc(_cLetra) >= 48 .and. Asc(_cLetra) <= 57) .OR. (Asc(_cLetra) >= 65 .and. Asc(_cLetra) <= 90)
				_cCodNew+=_cLetra
			Endif
		Next
	Endif
Return(_cCodNew)
//---------------------------------------------------------------------------------------------------------------

User Function BuscTabVig(_cCodProd, _cTabCod, _dDtVig)

	Local _aArea	:= GetArea()
	Local _aAreaZ3	:= SZ3->(GetArea())
	Local cCodDA0	:= SuperGetMv("AN_TABPRC",.F.,"100")
	Local _cLetra   := "C" //Ita - 11/08/2020 - Trocar Letra Default - Solicitação César - Local _cLetra   := "N"
	Local _nPrcRep	:= 0
	Local _nPrcAtu	:= 0
	Local _nDesPrc  := 0 //Ita - 10/08/2020 - Recupera desconto do produto
	Default _dDtVig := dDataBase
	Default _cTabCod:= CriaVar("Z2_CODTAB",.F.) 
	DbSelectArea("DA1")
	DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ

	If DA1->(DbSeek(xFilial("SZ3")+cCodDA0+_cCodProd))

		nItc := 1
		While !DA1->(Eof()) .And. xFilial("SZ3")+cCodDA0+_cCodProd == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO

			If DA1->DA1_DATVIG <= _dDtVig
				_cLetra := DA1->DA1_XLETRA
				_nPrcRep:= DA1->DA1_XPRCRE
				_nPrcAtu:= DA1->DA1_PRCVEN
				_nDesPrc:= DA1->DA1_XDESCV //Ita - 10/08/2020 - Recupera desconto do produto
				Exit
			Endif
			DA1->(dbSkip())
		End

	EndIf
	If Empty(_cLetra) .and. !Empty(_cTabCod)

		dbSelectArea("SZ3")
		dbSetOrder(3)
		If dbSeek(xFilial()+_cTabCod+_cCodProd) .and. !Empty(SZ3->Z3_LETRA)
			_cLetra := SZ3->Z3_LETRA
		Endif
	Endif
	RestArea(_aAreaZ3) //Ita - 13/08/2020 - Restaura área especificamente da SZ3
	RestArea(_aArea)
Return({_cLetra, _nPrcRep, _nPrcAtu, _nDesPrc}) //Ita - 10/08/2020 - Acrescentado _nDesPrc
//--------------------------------------------------------------------------------------------------------------

User Function LOCSB1IMP(_cCodNew,_cCodMarc,nIcms)

	Local lLocaliza := .F.
	Local aMarca	:= u_RetMarc(PadR(_cCodMarc,5))//Ita - 17/09/2020 - u_RetMarc(_cCodMarc)
	Local nH		:= 1
	If Len(aMarca) > 0
		dbSelectArea("SB1")
		SB1->(dbOrderNickName("B1CODMARC"))
		For nH:=1 to Len(aMarca)
			dbSeek(xFilial("SB1")+_cCodNew+aMarca[nH])
			While !Eof() .and. xFilial("SB1")+_cCodNew+aMarca[nH] == SB1->(B1_FILIAL+B1_XCODIMP+B1_XMARCA)
				If SB1->B1_MSBLQL <> "1" // Bloqueado
					lLocaliza := .T.
					cOrigem := Iif(nIcms == 4,'2','0')
					AADD(aProd,{SB1->(RECNO()),iif(cOrigem==SB1->B1_ORIGEM,'*','')})
				Endif
				SB1->(dbSkip())
			End
			If lLocaliza
				Exit
			Endif
		NEXT
		If !Empty(aProd)
			ASORT(aProd,,,{|x,y| x[2] > y[2]})
		EndIf
	Endif
Return(lLocaliza)

//-------------------------------------------------------------------------------------------------------------------------
//

User Function RetMarc(cMarcaSel)

	Local aArea := GetArea()
	Local aCodFor := {}
	Local nJ:=1
	Local aMarca := {}
	dbSelectArea("ZZM")
	dbSetOrder(2)
	dbSeek(xFilial("ZZM")+cMarcaSel)
	While !Eof() .and. xFilial("ZZM")+cMarcaSel == ZZM->(ZZM_FILIAL+ZZM_CODMAR)
		If ascan(aCodFor, ZZM->ZZM_FORNEC) == 0
			aadd(aCodFor, ZZM->ZZM_FORNEC)
		Endif
		dbSkip()
	END
	If Len(aCodFor) > 0
		For nJ:=1 to Len(aCodFor)
			dbSelectArea("ZZM")
			dbSetOrder(1)
			dbSeek(xFilial("ZZM")+aCodFor[nJ])
			While !Eof() .and. xFilial("ZZM")+aCodFor[nJ] == ZZM->(ZZM_FILIAL+ZZM_FORNEC)
				If ascan(aMarca, ZZM->ZZM_CODMAR) == 0
					aadd(aMarca, ZZM->ZZM_CODMAR)
				Endif
				dbSkip()
			END
		NEXT
	ENDIF
	RestArea(aArea)
Return(aMarca)
//////////////////////
/// Ita - fImpNotLoc()
///       16/09/2020
///       Função para importar produtos
///       não localizados no cadastro SB1
///       pela chave: B1_FILIAL+B1_XCODIMP +B1_XMARCA
//////////////////////////////////////////////////////
Static Function fImpNotLoc(cParam, cCodTab,aDados, nJ)
	
Local nL         := 1
Local _cCodInt   := " "
Local _cDescri   := " "
Local _cGrpTrib  := " "
Local _nPisCOF   := 0
Local _nICMRET   := 0
Local _nCusto    := 0
Local cTES       := " "
Local _cMonoFas  := " "
Local _nMargem   := 0
Local _nDescVen  := 0
Local _nFator    := 0
Local _nMarKup   := 0
Local _cLetra    := " "
Local _cLinhaSB1 := " "
Local cCodPrin   := ""
Local _cCodNew   := ""
Local nPrvBrt    := IIF(cParam == "0", Val(StrTran(aDados[nJ,_nPosPRC],",",".")), aDados[nJ,_nPosPRC])
Local _nAliqIPI  := IIF(cParam == "0", Val(StrTran(aDados[nJ,_nPosIPI],",",".")), aDados[nJ,_nPosIPI])

_cCodCsv := PADR(Alltrim(aDados[nJ,_nPosCod]), TAMSX3("B1_XCODIMP")[1])
_cCodNew := PADR(u_RetCodSE(_cCodCsv), TAMSX3("B1_XCODIMP")[1])

If nJ > 0
	dbSelectArea("SZ3")
	RecLock("SZ3",.T.)
	Replace Z3_FILIAL	with xFilial("SZ3")
	Replace Z3_COD 		with _cCodInt
	Replace Z3_CODPRIN	with cCodPrin //código principal para regra tes inteligente
	Replace Z3_DESCRI	with _cDescri
	Replace Z3_REFFOR	with _cCodNew //_cRefFor
	Replace Z3_TPOPER	with "01"
	Replace Z3_GRTRIB	with _cGrpTrib
	Replace Z3_PISCOF	with _nPisCOF
	Replace Z3_TES		with cTES
	Replace Z3_PRCREP	with _nCusto
   	If _nPosREP > 0
       	Replace Z3_PRCREP	with Val(aDados[nJ,_nPosREP])
    Endif
	Replace Z3_ICMSRET	with _nICMRET
	Replace Z3_CODTAB	with cCodTab
	Replace Z3_MONOFAS	with _cMonoFas
	Replace Z3_CODREF	with _cCodNew
	Replace Z3_PRCBRT	with nPrvBrt
	Replace Z3_PRCLIQ	with nPrvBrt
	Replace Z3_LETRA	with _cLetra
	Replace Z3_MARGEM	with _nMargem
	Replace Z3_DESCVEN	with _nDescVen
	Replace Z3_FATOR	with _nFator
	Replace Z3_LINHA	with _cLinhaSB1
	Replace Z3_MARKUP	with _nMarKup
	If _nPosIPI > 0
		Replace Z3_IPI	with _nAliqIPI
	Endif
	Replace Z3_ICMS	with 0
	Replace Z3_NACIMP with "N"
	If _nPosGRP > 0
		Replace Z3_GRUPO	with aDados[nJ,_nPosGRP]
	Endif
	If _nPosSGP > 0
		Replace Z3_SUBGRP	with aDados[nJ,_nPosSGP]
	Endif
	If _nPosREP > 0
     	Replace Z3_PRCREP	with aDados[nJ,_nPosREP]
	Endif

	MsUnLock()
EndIf
Return
