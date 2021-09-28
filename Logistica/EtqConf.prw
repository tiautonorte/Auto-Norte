#Include "Protheus.ch"
#Include "TopConn.Ch"
#Include "Font.Ch"
#Include "Colors.Ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} EtqConf
//TODO Impressão de etiquetas de conferencia de separação volume Item 3 da MIT044.
@author Helton Silva
@since 28/11/2018
@version undefined 
@return return, null
/*/


User Function EtqConf()		
	Local aArea := getArea()
	Local cPerg := "ETQCONF"

	Gera_SX1(cPerg)

	If Pergunte(cPerg,.T.)
		Processa( { || u_PrtEtiq(MV_PAR01,MV_PAR02,MV_PAR03) }, "Imprimindo etiquetas..." )
	EndIf
	
	//aDados := {"A09453","HELTON SILVA" ,1 }  //TESTE TESTE RETIRAR 
	//Processa( { || PrtEtiq(aDados) }, "Imprimindo etiquetas..." )
	RestArea(aArea)
Return nil
//-------------------------------------------------------------------------------------------------------------------------------------------------
User Function PrtEtiq(cPedido, cCodExp, nVolume, cConferente)
	Local nX
	Local cVolume := ""
	//Local _cRetName := AllTrim(UsrFullName(cConferente) )
	Local _cRetName := ""
	Local nErr := 0

	//Alteracao Andre Minelli 10/06/2021
	Local oFont1 	:= TFont():New( "Arial",,12,,.T.,,,,,.F. )
	Local oFont2 	:= TFont():New( "Arial",,60,,.T.,,,,,.F. )
	Local oPrn
	Local nLin		:= 20
	Local nCol		:= 30
	Local aRet		:= {999,999,999}

	oPrn := TMSPrinter():New("ETIQ_CONF")
    
	oPrn:SetPortrait()
	oPrn:Setup()

	If !Empty(cConferente)
		_cRetName := SubStr(UPPER(FWSFALLUSERS({cConferente})[1][3]),1,10)
	EndIf

	DbSelectArea("SC5")
	DbsetOrder(1)
	DbSeek(xFilial("SC5") + cPedido)

	cCliente := SC5->C5_CLIENTE +"-"+ SC5->C5_LOJACLI +" "+ Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
	cUf      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
	cMun     := SubStr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN"),1,15)
	cTransp	 := Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
	cVend	 := POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NREDUZ")

	/*MSCBPRINTER("ARGOX","LPT1",,,.F.,,,,,,,)
	MSCBCHKSTATUS(.F.)
	For nX := 1 to nVolume
		cVolume := StrZero(nX,3) +" / "+StrZero(nVolume,3) 
		MSCBBEGIN(1,6)
		MSCBSAY(03,27,cPedido ,"N","6","1.9,1.9") //Pedido
		MSCBSAY(70,27,"VOL: " + cVolume ,"N","9","1.5,2") //Volume		
		MSCBSAY(03,20,'CLIENTE: ' + cCliente  ,"N","9","1.5,2") //Cliente
		MSCBSAY(03,15,"TRANSP: " + cTransp  ,"N","9","1.5,2")
		MSCBSAY(03,10,"UF: "+cUf+"  MUN: " + FwNoAccent(cMun) + "  FILIAL: " + xFilial("SC5") ,"N","9","1.5,2") 
		MSCBSAY(03,05,'CONF.: ' + _cRetName + " - VEND: "+cVend ,"N","9","1.5,2")
		MSCBEND()	
		Sleep(500)//AGUARDA 0.5 SEGUNDOS
	Next nX
	MSCBCLOSEPRINTER()*/

	For nX := 1 to nVolume

		nLin := 10

		oPrn:StartPage()

		cVolume := StrZero(nX,3) +" / "+StrZero(nVolume,3)
		
		oPrn:Say( nLin-20, nCol, cPedido ,oFont2,, )
		oPrn:Say( nLin+80, nCol+850, "VOL: " + cVolume ,oFont1,, )
		nLin += 230
		oPrn:Say( nLin, nCol, "CLIENTE: " + cCliente ,oFont1,, )
		nLin += 75
		oPrn:Say( nLin, nCol, "TRANSP: " + cTransp ,oFont1,, )
		nLin += 75
		oPrn:Say( nLin, nCol, "UF: "+cUf+"  MUN: " + FwNoAccent(cMun) + "  FILIAL: " + xFilial("SC5") ,oFont1,, )
		nLin += 75
		oPrn:Say( nLin, nCol, 'CONF.: ' + _cRetName + " - VEND: "+cVend ,oFont1,, )

		oPrn:EndPage()

	Next nX

	MS_FLUSH()
	oPrn:Print()

	oPrn:End()

Return nil
//-------------------------------------------------------------------------------------------------------------------------------------------------
Static Function Gera_SX1(cPerg)

	Local i := 0
	Local j := 0
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs:={}
	AADD(aRegs,{cPerg,"01","Pedido"    		,"","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"02","Volume" 	    ,"","","mv_ch2","N",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Conferente"     ,"","","mv_ch3","C",60,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
Return
