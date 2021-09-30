#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#Include "TOPCONN.ch"
#INCLUDE "TOTVS.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ ImportaÁ„o de DOCUMENTO DE ENTRADA a partir de XML          ±±       
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ            
*/

User Function SCOMA001(_cTPXML)
	Local _cArea      := GetArea()
	//Local aRotina1    := {{"Efetivar Nota","U__COM01Run()",0,2},{"Visualizar Nota","U__COM01Vis()",0,2}}
	Local cPerg       := "SCOMA001X1"
	Private cCadastro := "ImportaÁ„o Documento de Entrada"
/*
	Private aRotina   := {{"Pesquisar","AxPesqui",0,1},;
		{"Importar XML","Processa( {|lEnd| U__COM01XML(_cTPXML)}, 'Aguarde','Importando dados...', .T. )",0,3},;
		{"Excluir","U__COM01Del()",0,5},;
		{"Amarrar Carga","U__COM01PC()",0,4},;
		{"Efetivar",aRotina1,0,4},;
		{"Estornar","MsAguarde({ || U__COM01Est() },'Aguarde','Estornando nota...',.F.)",0,4},;
		{"Validar Carga","U__COM01Clr()",0,4},;
		{"Carga vs XML ","U__COM01Div()",0,4},;
		{"Legenda","U__COM01Leg()" ,0,3}}
*/
	/*
	Private aCores := {{'PB1_STATUS=="1" .and. Empty(PB1_LIBNF)' ,'DISABLE'},; // migrado
	{'PB1_STATUS=="1" .and. PB1_LIBNF=="D"','BR_AZUL'},;
	{'PB1_STATUS=="1" .and. PB1_LIBNF=="S"','BR_AMARELO'},;
	{'PB1_STATUS=="2"','ENABLE'}} // validado
	*/
	// verifica se existem os indices especificos
	IF !_COM01IND()
		Return()
	ENDIF

	ValidPerg(cPerg)

	Pergunte(cPerg,.t.)

	SetKey(VK_F12,{|| Pergunte(cPerg,.t.) })

	dbSelectArea("PB0")
	mBrowse( 6,1,22,75,"PB0",,,,,,)
	//mBrowse( 6,1,22,75,"PB1",,,,,,aCores)

	RestArea(_cArea)
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01XML ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Importacao de XML                                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01XML(_cTPXML)
	Local _aArea 	:= GetArea()
	Local _aArq
	Local lOk		:= .F.
	Local aStruTrb 	:= {}
	Local aBrowse  	:= {}
	Local TY 		:= 1

	Private oXML
	Private oProcess 	:= NIL
	Private cAno 		:= cValToChar(YEAR(dDataBase))
	Private cMes 		:= MesExtenso(dDataBase)
	//Italo maciel 16/08/19
	Private cDirXML 	:= ALLTRIM(GETMV("EB_DIRXML"))

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Analisa a existencia do diretorio de Avaliacoes do CQ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If ":" $ cDirXML
		cDirXML:=IIF(Subs(cDirXML,Len(cDirXML),1)#'\',cDirXML+'\',cDirXML)
	Else
		cDirXML:=IIF(Subs(cDirXML,1,1)#'\','\'+cDirXML,cDirXML)
		cDirXML:=IIF(Subs(cDirXML,Len(cDirXML),1)#'\',cDirXML+'\',cDirXML)
	Endif

	If FwMakeDir( cDirXML )
		_aArq	:= Directory(Alltrim(cDirXML)+'*.XML')
	Else
		Alert("Nao foi possivel a criacao do Diretorio " + cDirXML)
		_aArq := {}
	Endif

	IF Len(_aArq) == 0
		Alert("Nao encontrado arquivos para importar.")
		Return()
	ENDIF

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Define arquivo de trabalho                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	aadd(aStruTrb,{"TRB_OK","C",2,0})
	aadd(aStruTrb,{"TRB_ARQ","C",80,0})
	aadd(aStruTrb,{"TRB_STATUS","C",20,0})

	aadd(aBrowse,{"TRB_OK",,""})
	aadd(aBrowse,{"TRB_ARQ",,"Arquivo"})

	//compatibilidade versao 25
	//cArquivo := CriaTrab(aStruTrb,.T.)
	//dbUseArea(.T.,__localDriver,cArquivo,"TRB",.F.,.F.)
	oTmpTRB := FWTemporaryTable():New("TRB")
	oTmpTRB:SetFields(aStruTrb)
	oTmpTRB:Create()

	dbSelectArea("TRB")
	For TY:=1 to Len(_aArq)
		RecLock("TRB",.t.)
		Replace TRB_ARQ with _aArq[TY,1]
		TRB->(MsUnLock())
	Next
	dbSelectArea("TRB")

	//bloqueio da rotina
	If !GlbNmLock("XML"+cFilAnt)
		MsgStop("Outro usu·rio est· realizando importaÁ„o.","A T E N « √ O - ImportaÁ„o em Uso")

		dbSelectArea("TRB")
		TRB->(dbCloseArea())
		oTmpTRB:Delete()

		Return
	EndIf

	If TRB->(!Eof()) .and. TRB->(!Bof())
		oMainWnd:ReadClientCoords()//So precisa declarar uma fez para o Programa todo
		DEFINE MSDIALOG oDlg TITLE "Arquivos XML" FROM 0,0 TO 400,900 OF oMainWnd PIXEL

		oTButton1 := TButton():New( 005, 002, " OK ",oDlg,{|| lOk := .T., oDlg:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		TRB->(dbGoTop())

		oMark := MSSELECT():New("TRB",,,aBrowse,.F.,'X',{30,1,(oDlg:nClientHeight-6)/2.3,(oDlg:nClientWidth-4)/2})

		Activate MsDialog oDlg /*On Init (EnchoiceBar(oDlg,{|| lOk := .T., oDlg:End() },{|| lOk := .F., oDlg:End() },,,,,,))*/ Centered
	Endif

	IF lOk
		RptStatus( {|lEnd| U_IMP_XML(cDirXML,.F.)}, "Aguarde...","Importando XML.", .T. )
	Endif

	dbSelectArea("TRB")
	TRB->(dbCloseArea())
	oTmpTRB:Delete()

	//Libera bloqueio da rotina
	GlbNmUnlock("XML"+cFilAnt)

	RestArea(_aArea)
Return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  05/31/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function IMP_XML(cDirXML,lJob)

	Local _aArea 	:= GetArea()
	Local _nBaseICM := 0
	Local _nVrICM   := 0
	Local _nBICMST	:= 0
	Local _nVICMST	:= 0
	Local _nAICMST	:= 0
	Local _nMVA		:= 0
	Local _nBaseIPI := 0
	Local _nVrIPI   := 0
	Local _nAliqIPI := 0
	Local _nAliqICM := 0
	Local _cOrigem	:= ""
	Local _nBasePIS := 0
	Local _nAliqPIS := 0
	Local _nVrPIS   := 0
	Local _nBaseCOF := 0
	Local _nAliqCOF := 0
	Local _nVrCOF   := 0
	Local nTBasST	:= 0
	Local nTValST	:= 0
	Local nTMerc	:= 0
	Local nFrete	:= 0
	Local nSeg		:= 0
	Local nTIpi		:= 0
	Local nOutro	:= 0
	Local nTNF		:= 0
	Local _cPed		:= ""
	Local _nItemPed := ""
	Local aProd		:= {}
	Local _cInfCom 	:= ""
	Local _cMens	:= ""
	Local _aItNF 	:= {}
	Local _aCabec 	:= {}
	Local _aNFORI	:= {}
	Local _aChavOri	:= {}
	Local _XMLROOT	:= "XMLNFE\"
	Local _cXMLNEW 	:= ALLTRIM(GETMV("EB_DIRXML"))
	Local _cXMLIMP 	:= ALLTRIM(GETMV("EB_XMLIMP"))
	Local _cXMLERR 	:= ALLTRIM(GETMV("EB_XMLERR"))
	Local _lDelFile := .T. //Italo Maciel 16/08/19
	Local _nImpor 	:= 0
	Local _cCodFor 	:= Substr(SuperGetMv("EB_CLIENTE",.F.,""),1,6)
	Local _cLjFor  	:= Substr(SuperGetMv("EB_CLIENTE",.F.,""),7,2)
	Local cXMLPFCT	:= SuperGetMV("MV_XMLPFCT",,"000072")
	Local lFornDep 	:= .f.
	Local _cNFORI 	:= CriaVar("D1_DOC",.F.)
	Local _cSerORI 	:= CriaVar("D1_SERIE",.F.)
	Local _cTpNF 	:= "N"
	Local _cCNPJTR 	:= ""
	Local _cEspecie := ""
	Local lEntrada	:= .F.
	Local lSaida	:= .F.
	Local aEmpSM0	:= FWLoadSM0()
	Local aEmpAtu	:= FWSM0Util():GetSM0Data("01",,{"M0_CGC"})
	Local nX
	Local nY
	Local cUFORITR   := CriaVar("F1_UFORITR",.F.)
	Local cUFDESTR   := CriaVar("F1_UFDESTR",.F.)
	Local cMUORITR   := CriaVar("F1_MUORITR",.F.)
	Local cMUDESTR   := CriaVar("F1_MUDESTR",.F.)
	Local aErrNCM_EX := {}

	Private _aERR 	:= {}

	Default lJob 	:= .F.

	MontaDir(_cXMLIMP)
	MontaDir(_cXMLERR)

	If !ExistDir(_XMLROOT)
		MakeDir(_XMLROOT)
		MakeDir(_cXMLNEW)//pasta new
		MakeDir(_cXMLIMP)//pasta old
		MakeDir(_cXMLERR)//pasta erro
	EndIf

	dbSelectArea("TRB")

	If !lJob
		SetRegua(TRB->(Reccount()))
	EndIf

	dbSelectArea("TRB")
	TRB->(dbGotop())
	While ! TRB->(Eof())
		_lContinua 	:= .T.
		_cNomeXML	:= TRB->TRB_ARQ
		cArqOri  	:= Alltrim(cDirXML)+_cNomeXML

		//Italo Maciel 16/01/2020
		//Reinicia variaveis
		_cCpoXML	:= ""
		_cEspecie	:= ""
		_cChave		:= ""
		_cTpNF		:= ""
		_cCNPJ		:= ""
		_cxNome		:= ""
		_cCNPJTR	:= ""
		nTBasST		:= 0
		nTValST		:= 0
		nTMerc		:= 0
		nFrete		:= 0
		nSeg		:= 0
		nTIpi		:= 0
		nOutro		:= 0
		nTNF		:= 0
		_cPed		:= ""
		_nItemPed	:= 0
		_nBaseICM	:= 0
		_nVrICM		:= 0
		_nAliqICM	:= 0
		_cOrigem	:= ""
		_nBICMST	:= 0
		_nVICMST	:= 0
		_nAICMST	:= 0
		_nMVA		:= 0
		_nBaseICM	:= 0
		_nVrICM		:= 0
		_nAliqICM	:= 0
		_nBaseIPI	:= 0
		_nAliqIPI	:= 0
		_nVrIPI		:= 0
		_nBasePIS	:= 0
		_nAliqPIS	:= 0
		_nVrPIS		:= 0
		_nBaseCOF	:= 0
		_nAliqCOF	:= 0
		_nVrCOF		:= 0

		__CopyFile(cArqOri,_XMLROOT+_cNomeXML)

		cArq     := Alltrim(_XMLROOT)+_cNomeXML

		If !lJob
			IncRegua("Lendo Arquivo: "+_cNomeXML)
		EndIf

		cError 		:= ""
		cWarning 	:= ""
		oXml 		:= XmlParserFile( cArq, "_", @cError, @cWarning )

		IF XMLError() <> 0 .or. !Empty(cError)
			If !Empty(cError)
				aadd(_aERR,{_cNomeXML,cError})
			Else
				aadd(_aERR,{_cNomeXML,"Problemas no arquivo "+ cArq + " XML"})
			Endif
			oXML := Nil
			FClose(cArq)
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		ENDIF
		_aCabec := {}
		_cCpoXML  := ""

		If Type("oXML:_NFEPROC") <> "U"
			_cCpoXML  := "_NFEPROC:_NFE:_INFNFE"
			_cEspecie := "SPED"
		ElseIf Type("oXML:_CTEPROC") <> "U"
			_cCpoXML  := "_CTEPROC:_CTE:_INFCTE"
			_cEspecie := "CTE"
		ElseIf Type("oXML:_CTE") <> "U"
			_cCpoXML  := "_CTE:_INFCTE"
			_cEspecie := "CTE"
		ElseIf Type("oXML:_PROCCANCNFE") <> "U"
			_cChave  := oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_CHNFE:TEXT
			dbSelectArea("PB0")
			PB0->(dbSetOrder(6))
			If PB0->(dbSeek(xFilial("PB0")+_cChave))
				If PB0->PB0_STATUS == "2"  // NF ja classificada
					aadd(_aERR,{_cNomeXML,"Cancelamento XML nao possivel - NF "+ PB0->PB0_DOC + "/" + PB0->PB0_SERIE + " Forn " + PB0->PB0_FORNEC })
				Else
					_cSeek := PB0->(Dtos(PB0_EMISSA)+PB0_DOC+PB0_SERIE+PB0_FORNEC+PB0_LOJA)
					RecLock("PB0",.F.)
					PB0->(dbDelete())
					PB0->(MsUnLock())

					dbSelectArea("PB1")
					PB1->(dbSetOrder(3))
					PB1->(dbSeek(xFilial("PB1")+_cSeek))
					While PB1->(!Eof()) .and. xFilial("PB1")+_cSeek == PB1->(PB1_FILIAL+_cSeek)
						dbSelectArea("PB1")
						RecLock("PB1",.F.)
						PB1->(dbDelete())
						PB1->(MsUnLock())
						PB1->(dbSkip())
					EndDo
				Endif
			Endif
			oXML := Nil
			FClose(cArq)
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		ElseIf Type("oXML:_NFE") <> "U"
			_cCpoXML := "_NFE:_INFNFE"
		Endif
		If Empty(_cCpoXML)
			aadd(_aERR,{_cNomeXML,"Tipo XML nao pode ser tratado"})
			oXML := Nil
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		ENDIF

		/*
		//SEFAZ
		NF-e normal 		= 1
		NF-e complementar 	= 2
		NF-e de ajuste 		= 3
		DevoluÁ„o de Merc. 	= 4

		//Protheus
		N = NF Normal          
		C = Compl. PreÁo
		D = DevoluÁ„o
		I = NF Compl. ICMS
		P = NF Compl. IPI
		B = NF Beneficiamento
		*/
		If Type("oXML:"+_cCpoXML+":_IDE:_FINNFE:TEXT") <> "U"
			_cTpNF := &("oXML:"+_cCpoXML+":_IDE:_FINNFE:TEXT")
			If _cTpNF == '1'
				_cTpNF := "N"
			ElseIf _cTpNF == '2'
				_cTpNF := "I"
			ElseIf _cTpNF == '3'
				_cTpNF := "C"
			ElseIf _cTpNF == '4'
				_cTpNF := "D"
			EndIf
		EndIf

		If Type("oXML:"+_cCpoXML+":_EMIT:_CRT:TEXT") <> "U"
			_cCRT := &("oXML:"+_cCpoXML+":_EMIT:_CRT:TEXT")
		EndIf

		If Type("oXML:"+_cCpoXML+":_EMIT:_CNPJ:TEXT") <> "U"
			_cCNPJ    := &("oXML:"+_cCpoXML+":_EMIT:_CNPJ:TEXT")
			_cxNome   := &("oXML:"+_cCpoXML+":_EMIT:_XNOME:TEXT")
		ElseIf Type("oXML:"+_cCpoXML+":_EMIT:_CPF:TEXT") <> "U"
			_cCNPJ    := &("oXML:"+_cCpoXML+":_EMIT:_CPF:TEXT")
			_cxNome   := &("oXML:"+_cCpoXML+":_EMIT:_XNOME:TEXT")
		Else
			aadd(_aERR,{_cNomeXML,"Nao encontrado CNPJ do emitente no XML"})
			dbSelectArea("TRB")
			oXML := Nil
			// DelClassIntf()()
			FClose(cArq)
			//		__CopyFile(cArq,_cXMLERR+_cNomeXML)
			//		IF _lDelFile
			//			Ferase(cArq)
			//		ENDIF
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		Endif
		If Alltrim(_cCNPJ) == Alltrim(aEmpAtu[1][2])
			aadd(_aERR,{_cNomeXML,"NF de venda da propria empresa"})
			FClose(cArq)
			__CopyFile(cArq,_cXMLERR+_cNomeXML)
			IF _lDelFile
				Ferase(cArq)
				Ferase(cArqOri)
			ENDIF
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		Endif
		_cUF      := &("oXML:"+_cCpoXML+":_EMIT:_ENDEREMIT:_UF:TEXT")
		_cCNPJDt  := " "
		_lTransf := .f.

		_cNFORI := CriaVar("D1_DOC",.F.)
		_cSerORI := CriaVar("D1_SERIE",.F.)

		If _cEspecie == "CTE"
			_cChavOri := " "

			If TYPE("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT") <> "U"
				_cCNPJTR  := &("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT")
			ElseIf TYPE("oXML:"+_cCpoXML+":_REM:_CPF:TEXT") <> "U"
				_cCNPJTR  := &("oXML:"+_cCpoXML+":_REM:_CPF:TEXT")
			Endif

			/*
			0-Remetente
			1-Expedidor
			2-Recebedor
			3-Destinat·rio
			*/
			cToma := ""
			If TYPE("oXML:"+_cCpoXML+":_IDE:_TOMA3:_TOMA") <> "U"
				cToma := &("oXML:"+_cCpoXML+":_IDE:_TOMA3:_TOMA:TEXT")
			EndIf
			If TYPE("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT")
			ElseIf TYPE("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT")
			Endif

			//Se o remetente tiver a raiz da Auto Norte
			If cToma == '3'
				If SubStr(_cCNPJDt,1,8) == SubStr(Alltrim(aEmpAtu[1][2]),1,8)
					_cTpNF := "C"
				EndIf
			ElseIf cToma == '0'
				If SubStr(_cCNPJTR,1,8) == SubStr(Alltrim(aEmpAtu[1][2]),1,8)
					_cTpNF := "N"
				EndIf
			EndIf

			If TYPE("oXML:"+_cCpoXML+":_REM:_INFNF:_NDOC:TEXT") <> "U"
				_cNFORI  := StrZero(Val(&("oXML:"+_cCpoXML+":_REM:_INFNF:_NDOC:TEXT")),TamSX3("F1_DOC")[1])
			Endif
			If TYPE("oXML:"+_cCpoXML+":_REM:_INFNF:_NDOC:TEXT") <> "U"
				_cSerORI  := &("oXML:"+_cCpoXML+":_REM:_INFNF:_SERIE:TEXT")
			Endif

			// NF com destinatario diferente da empresa do sistema
			If _cTpNF == "C"
				If (Alltrim(_cCNPJDt) <> Alltrim(aEmpAtu[1][2]))
					For nX := 1 to Len(aEmpSM0)
						If aEmpSM0[nX][18] == Alltrim(_cCNPJDt)
							cEmpAnt := aEmpSM0[nX][1]
							cFilAnt := aEmpSM0[nX][2]
							//Atualiza empresa logada
							OpenFile(cEmpAnt + cFilAnt)
							//Atualiza Array
							aEmpAtu	:= FWSM0Util():GetSM0Data("01",,{"M0_CGC"})
							Exit
						EndIf
					Next nX
				Endif
			ElseIf _cTpNF == "N"
				If (Alltrim(_cCNPJTR) <> Alltrim(aEmpAtu[1][2]))
					For nX := 1 to Len(aEmpSM0)
						If aEmpSM0[nX][18] == Alltrim(_cCNPJTR)
							cEmpAnt := aEmpSM0[nX][1]
							cFilAnt := aEmpSM0[nX][2]
							//Atualiza empresa logada
							OpenFile(cEmpAnt + cFilAnt)
							//Atualiza Array
							aEmpAtu	:= FWSM0Util():GetSM0Data("01",,{"M0_CGC"})
							Exit
						EndIf
					Next nX
				Endif
			EndIf

			_aChavOri 	:= {}
			_aNFORI 	:= {}
			_aChvFalta 	:= {}

			If TYPE("oXML:"+_cCpoXML+":_IDE:_NCT:TEXT") <> "U"  // CTE
				_cNota    := StrZero(Val(&("oXML:"+_cCpoXML+":_IDE:_NCT:TEXT")),TamSX3("F1_DOC")[1])

				//Incluido por Andre Minelli em 29/06/2021 Alterado por Gustavo 23/09/2021
				If TYPE("oXML:"+_cCpoXML+":_IDE:_UFINI:TEXT") <> "U" 
					cUFORITR  := &("oXML:"+_cCpoXML+":_IDE:_UFINI:TEXT")
				End If
				If TYPE("oXML:"+_cCpoXML+":_IDE:_UFFIM:TEXT") <> "U" 
					cUFDESTR  := &("oXML:"+_cCpoXML+":_IDE:_UFFIM:TEXT")
				End If
				If TYPE("oXML:"+_cCpoXML+":_IDE:_CMUNINI:TEXT") <> "U" 
					cMUORITR  := SubStr(&("oXML:"+_cCpoXML+":_IDE:_CMUNINI:TEXT"),3,5)
				End If
				If TYPE("oXML:"+_cCpoXML+":_IDE:_CMUNFIM:TEXT") <> "U" 
					cMUDESTR  := SubStr(&("oXML:"+_cCpoXML+":_IDE:_CMUNFIM:TEXT"),3,5)
				End If
			EndIf

			lEntrada := .F.
			lSaida := .F.
			If Type("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE") <> "U"
				_nLaco := IIF(Type("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE") == "A",Len(&("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE")),1)
				For nX := 1 to _nLaco
					If _nLaco == 1
						If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT") <> "U"
							AADD(_aChavOri,&("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT"))
							dbSelectArea("SF1")
							SF1->(dbSetOrder(8))
							If SF1->(dbSeek(xFilial("SF1")+_aChavOri[nX]))
								AADD(_aNFORI,{SF1->F1_FILIAL,PADR(SF1->F1_DOC,TAMSX3("F1_DOC")[1]),SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO})
								lEntrada := .T.
							Else
								dbSelectArea("SF2")
								SF2->(dbSetOrder(17))
								If SF2->(dbSeek(xFilial("SF2") + _aChavOri[nX]))
									AADD(_aNFORI,{SF2->F2_FILIAL,PADR(SF2->F2_DOC,TAMSX3("F2_DOC")[1]),SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO})
									lSaida := .T.
								Else
									AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT"))
								EndIf
							Endif
						Endif
					Else
						If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE["+cValToChar(nX)+"]:_CHAVE:TEXT") <> "U"
							AADD(_aChavOri,&("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE["+cValToChar(nX)+"]:_CHAVE:TEXT"))
							dbSelectArea("SF1")
							SF1->(dbSetOrder(8))
							If SF1->(dbSeek(xFilial("SF1")+_aChavOri[nX]))
								AADD(_aNFORI,{SF1->F1_FILIAL,PADR(SF1->F1_DOC,TAMSX3("F1_DOC")[1]),SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO})
								lEntrada := .T.
							Else
								dbSelectArea("SF2")
								SF2->(dbSetOrder(17))
								If SF2->(dbSeek(xFilial("SF2") + _aChavOri[nX]))
									AADD(_aNFORI,{SF2->F2_FILIAL,PADR(SF2->F2_DOC,TAMSX3("F2_DOC")[1]),SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO})
									lSaida := .T.
								Else
									AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNFE["+cValToChar(nX)+"]:_CHAVE:TEXT"))
								EndIf
							Endif
						Endif
					EndIf
				Next nX
			ElseIf Type("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF") <> "U"
				_nLaco := IIF(Type("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF") == "A",Len(&("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF")),1)
				For nX := 1 to _nLaco
					If _nLaco == 1
						If _cTpNF == "N" //CIF
							//Dados da Nota de origem
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT") <> "U"
								cNFOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT")
								cNFOriCte := StrZero(Val(cNFOriCte),9)
							EndIf
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT") <> "U"
								cSerOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT")
								cSerOriCte := PADR(Val(cSerOriCte),TAMSX3("F1_SERIE")[1])
							EndIf
							dbSelectArea("SF2")
							SF2->(dbSetOrder(1))
							If SF2->(dbSeek(xFilial("SF2") + cNFOriCte + cSerOriCte))
								AADD(_aNFORI,{SF2->F2_FILIAL,PADR(SF2->F2_DOC,TAMSX3("F2_DOC")[1]),SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO})
								lSaida := .T.
							Else
								AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + "NF SaÌda: "+cNFOriCte+" Serie: "+cSerOriCte)
							EndIf
						ElseIf _cTpNF == "C" //FOB
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT") <> "U"
								cNFOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT")
								cNFOriCte := StrZero(Val(cNFOriCte),9)
							EndIf
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT") <> "U"
								cSerOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT")
								cSerOriCte := PADR(Val(cSerOriCte),TAMSX3("F1_SERIE")[1])
							EndIf
							cForOriCte := POSICIONE("SA2",3,xFilial("SA2")+_cCnpjTr,"A2_COD")

							dbSelectArea("SF1")
							SF1->(dbSetOrder(1))
							If SF1->(dbSeek(xFilial("SF1") + cNFOriCte + cSerOriCte + cForOriCte))
								AADD(_aNFORI,{SF1->F1_FILIAL,PADR(SF1->F1_DOC,TAMSX3("F1_DOC")[1]),SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO})
								lEntrada := .T.
							Else
								AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + "NF Entrada: "+cNFOriCte+" Serie: "+cSerOriCte)
							EndIf
						EndIf
					Else
						If _cTpNF == "N" //CIF
							//Dados da Nota de origem
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_NDOC:TEXT") <> "U"
								cNFOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_NDOC:TEXT")
								cNFOriCte := StrZero(Val(cNFOriCte),9)
							EndIf
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_SERIE:TEXT") <> "U"
								cSerOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_SERIE:TEXT")
								cSerOriCte := PADR(Val(cSerOriCte),TAMSX3("F1_SERIE")[1])
							EndIf
							dbSelectArea("SF2")
							SF2->(dbSetOrder(1))
							If SF2->(dbSeek(xFilial("SF2") + cNFOriCte + cSerOriCte))
								AADD(_aNFORI,{SF2->F2_FILIAL,PADR(SF2->F2_DOC,TAMSX3("F2_DOC")[1]),SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO})
								lSaida := .T.
							Else
								AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + "NF SaÌda: "+cNFOriCte+" Serie: "+cSerOriCte)
							EndIf
						ElseIf _cTpNF == "C" //FOB
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_NDOC:TEXT") <> "U"
								cNFOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_NDOC:TEXT")
								cNFOriCte := StrZero(Val(cNFOriCte),9)
							EndIf
							If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_SERIE:TEXT") <> "U"
								cSerOriCte := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFDOC:_INFNF["+cValToChar(nX)+"]:_SERIE:TEXT")
								cSerOriCte := PADR(Val(cSerOriCte),TAMSX3("F1_SERIE")[1])
							EndIf
							cForOriCte := POSICIONE("SA2",3,xFilial("SA2")+_cCnpjTr,"A2_COD")

							dbSelectArea("SF1")
							SF1->(dbSetOrder(1))
							If SF1->(dbSeek(xFilial("SF1") + cNFOriCte + cSerOriCte + cForOriCte))
								AADD(_aNFORI,{SF1->F1_FILIAL,PADR(SF1->F1_DOC,TAMSX3("F1_DOC")[1]),SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO})
								lEntrada := .T.
							Else
								AADD(_aChvFalta,"Nota de Origem n„o encontrada no CTE "+_cNota+": " + "NF Entrada: "+cNFOriCte+" Serie: "+cSerOriCte)
							EndIf
						EndIf
					Endif
				Next nX
			EndIf

			lErroDup := .F.

			//Italo Maciel 19/01/21 - Validar se a NF j· amarrou em outro CTE
			For nX := 1 to Len(_aNFORI)
				PB2->(dbSetOrder(2))
				If PB2->(dbSeek(xFilial("PB2") + _aNFORI[nX][2] + _aNFORI[nX][3] + _aNFORI[nX][4] + _aNFORI[nX][5]))
					aadd(_aERR,{_cNomeXML,"Nota: "+_aNFORI[nX][2]+" do "+IIF(lSaida,"Cliente:","Fornecedor:")+" "+_aNFORI[nX][4]+" j· est· no CTE: "+PB2->PB2_NFDIFR })
					lErroDup := .T.
				EndIf
			Next nX
			If lErroDup
				oXML := Nil
				FClose(cArq)
				__CopyFile(cArq,_cXMLIMP+_cNomeXML)
				IF _lDelFile
					Ferase(cArq)
					Ferase(cArqOri)
				ENDIF
				dbSelectArea("TRB")
				TRB->(dbSkip())
				Loop
			EndIf

			//N„o encontrou a origem na entrada, nem saÌda OU Faltou alguma chave
			If !lSaida .and. !lEntrada .OR. !Empty(_aChvFalta)
				For nY := 1 to Len(_aChvFalta)
					aadd(_aERR,{_cNomeXML,_aChvFalta[nY]})
				Next nY
				oXML := Nil
				FClose(cArq)
				dbSelectArea("TRB")
				TRB->(dbSkip())
				Loop
			EndIf

			/*
			If Empty(_cNFORI) .and. _cTpNF == "C"
				aadd(_aERR,{_cNomeXML,"Nao achou NF Origem - Frete "+_cChavOri})
				oXML := Nil
				FClose(cArq)
				dbSelectArea("TRB")
				dbSkip()
				Loop
			Endif
			*/
			If TYPE("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT")
			ElseIf TYPE("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT")
			Endif

			//If Substr(_cCNPJDt,1,8) == Substr(_cCNPJTR,1,8) RAFA 01/13
			If(Alltrim(_cCNPJDt) == Alltrim(aEmpAtu[1][2]) .And. Substr(_cCNPJDt,1,8) == Substr(_cCNPJTR,1,8))
				_lTransf := .t.
			Endif

			If Substr(_cCNPJTR,1,8) == Substr(Alltrim(aEmpAtu[1][2]),1,8) .and. Substr(_cCNPJDt,1,8) <> Substr(Alltrim(aEmpAtu[1][2]),1,8)  // NF FRETE DE VENDA
				_cTpNF := "N"  // 2.b Conforme comentario acima
			Endif
			If (_lTransf == .f.)
				If(Alltrim(_cCNPJTR) == Alltrim(aEmpAtu[1][2]))
					If TYPE("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT") <> "U"
						_cCNPJDt  := &("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT")
					ElseIf TYPE("oXML:"+_cCpoXML+":_REM:_CPF:TEXT") <> "U"
						_cCNPJDt  := &("oXML:"+_cCpoXML+":_REM:_CPF:TEXT")
					Endif
					If TYPE("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT") <> "U"
						_cCNPJTR  := &("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT")
					ElseIf TYPE("oXML:"+_cCpoXML+":_REM:_CPF:TEXT") <> "U"
						_cCNPJTR  := &("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT")
					Endif
				Endif
			Endif
			// Ultima alteracao para consistir o CNPJ da transportadora.
			If TYPE("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_REM:_CNPJ:TEXT")
			ElseIf TYPE("oXML:"+_cCpoXML+":_REM:_CPF:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_REM:_CPF:TEXT")
			Endif
		Else
			If TYPE("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT")
			ElseIf TYPE("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT") <> "U"
				_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT")
			Endif
			//ITALO MACIEL 20/09/18
			//DevoluÁ„o
			If Empty(_cNFORI)
				If TYPE("oXML:"+_cCpoXML+":_IDE:_NFREF:_REFNFE:TEXT") <> "U"
					_cChavOri := &("oXML:"+_cCpoXML+":_IDE:_NFREF:_REFNFE:TEXT")
					dbSelectArea("SF2")
					SF2->(DbOrderNickName("CHVSF2"))
					If SF2->(dbSeek(xFilial("SF2")+_cChavOri))
						_cNFORI  := SF2->F2_DOC
						_cSerORI := SF2->F2_SERIE
					Endif
				Endif
			Endif
		Endif
		If Empty(_cCNPJDt)
			aadd(_aERR,{_cNomeXML,"Nao encontrado CNPJ do destinatario no XML"})
			oXML := Nil
			// DelClassIntf()()
			FClose(cArq)
			//		__CopyFile(cArq,_cXMLERR+_cNomeXML)
			//		IF _lDelFile
			//			Ferase(cArq)
			//		ENDIF
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		Endif
		_cMensCGC := ""
		If (Alltrim(_cCNPJDt) <> Alltrim(aEmpAtu[1][2]))
			If _cEspecie == "CTE"
				If TYPE("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT") <> "U"
					_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CNPJ:TEXT")
				ElseIf TYPE("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT") <> "U"
					_cCNPJDt  := &("oXML:"+_cCpoXML+":_DEST:_CPF:TEXT")
				Endif
			Endif
			If (Alltrim(_cCNPJDt) <> Alltrim(aEmpAtu[1][2]))
				For nX := 1 to Len(aEmpSM0)
					If aEmpSM0[nX][18] == Alltrim(_cCNPJDt)
						cEmpAnt := aEmpSM0[nX][1]
						cFilAnt := aEmpSM0[nX][2]
						//Atualiza empresa logada
						OpenFile(cEmpAnt + cFilAnt)
						//Atualiza Array
						aEmpAtu	:= FWSM0Util():GetSM0Data("01",,{"M0_CGC"})
						Exit
					EndIf
				Next nX
			Endif
		Endif

		If (Alltrim(_cCNPJDt) <> Alltrim(aEmpAtu[1][2]))
			aadd(_aERR,{_cNomeXML,"NFe/XML n„o È para Auto Norte. Verifique o destinat·rio da nota."})
			oXML := Nil
			FClose(cArq)
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		EndIf

		If TYPE("oXML:"+_cCpoXML+":_IDE:_NCT:TEXT") <> "U"  // CTE
			_dEmissao := Stod(StrTran(&("oXML:"+_cCpoXML+":_IDE:_DHEMI:TEXT"),"-",""))
			_cNota    := StrZero(Val(&("oXML:"+_cCpoXML+":_IDE:_NCT:TEXT")),TamSX3("F1_DOC")[1])

			//Incluido por Andre Minelli em 29/06/2021 Alterado por Gustavo 23/09/2021
			If TYPE("oXML:"+_cCpoXML+":_IDE:_UFINI:TEXT") <> "U" 
				cUFORITR  := &("oXML:"+_cCpoXML+":_IDE:_UFINI:TEXT")
			End If
			If TYPE("oXML:"+_cCpoXML+":_IDE:_UFFIM:TEXT") <> "U" 
				cUFDESTR  := &("oXML:"+_cCpoXML+":_IDE:_UFFIM:TEXT")
			End If
			If TYPE("oXML:"+_cCpoXML+":_IDE:_CMUNINI:TEXT") <> "U" 
				cMUORITR  := SubStr(&("oXML:"+_cCpoXML+":_IDE:_CMUNINI:TEXT"),3,5)
			End If
			If TYPE("oXML:"+_cCpoXML+":_IDE:_CMUNFIM:TEXT") <> "U" 
				cMUDESTR  := SubStr(&("oXML:"+_cCpoXML+":_IDE:_CMUNFIM:TEXT"),3,5)
			End If

			If Type("oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT") == "U"
				If Type("oXML:_CTE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT") == "U"
					aadd(_aERR,{_cNomeXML,"Nao encontrada a chave de autorizacao da NFe."})
					FClose(cArq)
					//				__CopyFile(cArq,_cXMLERR+_cNomeXML)
					//				IF _lDelFile
					//					Ferase(cArq)
					//				ENDIF
					dbSelectArea("TRB")
					dbSkip()
					Loop
				Else
					_cChavNF  := SUBSTR(oXML:_CTE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT,5)
					If TYPE("oXML:"+_cCpoXML+":_VERSAO:TEXT") == "U"
						_cVersao  := " "
					Else
						_cVersao  := &("oXML:"+_cCpoXML+":_VERSAO:TEXT")
					Endif
				Endif
			Else
				_cChavNF  := oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT
				_cVersao  := oXML:_CTEPROC:_VERSAO:TEXT
			Endif
		Else
			If TYPE("oXML:"+_cCpoXML+":_IDE:_DEMI:TEXT") == "U"
				_dEmissao := Stod(StrTran(SUBSTR(&("oXML:"+_cCpoXML+":_IDE:_DHEMI:TEXT"),1,10),"-",""))
			Else
				_dEmissao := Stod(StrTran(&("oXML:"+_cCpoXML+":_IDE:_DEMI:TEXT"),"-",""))
			Endif
			_cNota    := StrZero(Val(&("oXML:"+_cCpoXML+":_IDE:_NNF:TEXT")),TamSX3("F1_DOC")[1])
			If Type("oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT") == "U"
				If Type("oXML:"+_cCpoXML+":_ID:TEXT") == "U"
					aadd(_aERR,{_cNomeXML,"Nao encontrada a chave de autorizacao da NFe."})
					FClose(cArq)
					dbSelectArea("TRB")
					TRB->(dbSkip())
					Loop
				Else
					_cChavNF  := Substr(&("oXML:"+_cCpoXML+":_ID:TEXT"),4)
					_cVersao  := &("oXML:"+_cCpoXML+":_VERSAO:TEXT")
				Endif
			Else
				_cChavNF  := oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
				_cVersao  := oXML:_NFEPROC:_VERSAO:TEXT
			Endif
		Endif

		//Italo Maciel 03/05/21

		//Validar a data que o xml est· sendo importado
		If _dEmissao > dDataBase
			aadd(_aERR,{_cNomeXML,"XML n„o pode ser importado com data anterior ‡ sua Emiss„o. Emiss„o: "+DToC(_dEmissao)+" | Data do Sistema: "+DToC(dDataBase)})
			FClose(cArq)
			dbSelectArea("TRB")
			TRB->(dbSkip())
			Loop
		EndIf

		_cSerie   := PADR(&("oXML:"+_cCpoXML+":_IDE:_SERIE:TEXT"),3)

		IF Type("oXML:"+_cCpoXML+":_INFADIC:_INFCPL:TEXT") <> "U"
			_cMens := &("oXML:"+_cCpoXML+":_INFADIC:_INFCPL:TEXT")
			//italo maciel - 11/07/18 - grava informaÁıes complementares
			_cInfCom := _cMens
			_nPosNF := AT("NFS N.:",_cMens) + 8
			If _nPosNF > 10
				_nNFRet := SUBSTR(_cMens,_nPosNF)
			Endif
		Endif

		IF Type("oXML:"+_cCpoXML+":_INFADIC:_infAdFisco:TEXT") <> "U"
			If !Empty(_cInfCom)
				_cMens += Chr(13) + Chr(10) + &("oXML:"+_cCpoXML+":_INFADIC:_infAdFisco:TEXT")
			Else
				_cMens := &("oXML:"+_cCpoXML+":_INFADIC:_infAdFisco:TEXT")
			EndIf
			//italo maciel - 11/07/18 - grava informaÁıes complementares
			_cInfCom := _cMens
			_nPosNF := AT("NFS N.:",_cMens) + 8
			If _nPosNF > 10
				_nNFRet := SUBSTR(_cMens,_nPosNF)
			Endif
		Endif

		//base st
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VBCST:TEXT") <> "U"
			nTBasST := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VBCST:TEXT"))
		EndIf
		//valor st
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VST:TEXT") <> "U"
			nTValST := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VST:TEXT"))
		EndIf
		//valor mercadoria
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_vProd:TEXT") <> "U"
			nTMerc := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_vProd:TEXT"))
		EndIf
		//Frete
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VFRETE:TEXT") <> "U"
			nFrete := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VFRETE:TEXT"))
		EndIf
		//Seguro
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VSEG:TEXT") <> "U"
			nSeg := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VSEG:TEXT"))
		EndIf
		//valor IPI
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VIPI:TEXT") <> "U"
			nTIpi := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VIPI:TEXT"))
		EndIf
		//outros (despesa)
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VOUTRO:TEXT") <> "U"
			nOutro := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VOUTRO:TEXT"))
		EndIf
		//total NF
		If Type("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VNF:TEXT") <> "U"
			nTNF := Val(&("oXML:"+_cCpoXML+":_TOTAL:_ICMSTOT:_VNF:TEXT"))
		EndIf

		_cCliFor := ""
		_cLoja   := ""
		aadd(_aCabec,_cEspecie)	//1
		aadd(_aCabec,_cCNPJ)	//2
		aadd(_aCabec,_cCliFor)	//3
		aadd(_aCabec,_cLoja)	//4
		aadd(_aCabec,_dEmissao)	//5
		aadd(_aCabec,_cNota)	//6
		aadd(_aCabec,_cSerie)	//7
		aadd(_aCabec,_cChavNF)	//8
		aadd(_aCabec,_cNomeXML)	//9
		aadd(_aCabec,_cUF)		//10
		aadd(_aCabec,_cVersao)	//11
		aadd(_aCabec,_cTpNF)	//12
		aadd(_aCabec,_cInfCom)	//13
		//italo maciel 17/08/18
		aadd(_aCabec,nTBasST)	//14
		aadd(_aCabec,nTValST)	//15
		aadd(_aCabec,nTMerc)	//16
		aadd(_aCabec,nFrete)	//17
		aadd(_aCabec,nSeg)		//18
		aadd(_aCabec,nTIpi)		//19
		aadd(_aCabec,nOutro)	//20
		aadd(_aCabec,nTNF)		//21

		//Incluido Andre Minelli 29/06/2021
		aadd(_aCabec,cUFORITR)  //22
		aadd(_aCabec,cUFDESTR)  //23
		aadd(_aCabec,cMUORITR)  //24
		aadd(_aCabec,cMUDESTR)  //25

		_nLaco := IIF(Type("oXML:"+_cCpoXML+":_DET") == "A",Len(&("oXML:"+_cCpoXML+":_DET")),1)
		_aItNF := {}
		lFornDep := .f.
		aErrNCM_EX := {}
		For i := 1 to _nLaco
			_nOutItem := 0
			_nFreItem := 0
			_cExtIpiF := ""
			If i == 1
				If _cTpNF == "D"
					_cCNPJ := PADR(_cCNPJ,TAMSX3("A1_CGC")[1])
					SA1->(dbSetOrder(3))
					SA1->(dbSeek(XFilial("SA1")+_cCNPJ))
					While SA1->(!Eof()) .and. XFilial("SA1")+_cCNPJ == SA1->(A1_FILIAL+A1_CGC)
						If SA1->A1_MSBLQL == "1"
							SA1->(dbSkip())
							Loop
						Endif
						_cCliFor := SA1->A1_COD
						_cLoja   := SA1->A1_LOJA
						SA1->(dbSkip())
					EndDo
				Else
					_cCNPJ := PADR(_cCNPJ,TAMSX3("A2_CGC")[1])
					SA2->(dbSetOrder(3))
					SA2->(dbSeek(XFilial("SA2")+_cCNPJ))
					While SA2->(!Eof()) .and. XFilial("SA2")+_cCNPJ == SA2->(A2_FILIAL+A2_CGC)
						If SA2->A2_MSBLQL == "1"
							SA2->(dbSkip())
							Loop
						Endif
						_cCliFor := SA2->A2_COD
						_cLoja   := SA2->A2_LOJA
						SA2->(dbSkip())
					EndDo
				EndIf
				If _cCliFor == _cCodFor .and. _cLoja == _cLjFor
					lFornDep := .t.
				Endif
				If Empty(_cCliFor)
					aadd(_aERR,{_cNomeXML,"Fornecedor nao cadastrado no sistema, CNPJ: "+_cCNPJ+"-"+_cxNome})
					oXML := Nil
					// DelClassIntf()()
					FClose(cArq)
					//				__CopyFile(cArq,_cXMLERR+_cNomeXML)
					//				IF _lDelFile
					//					Ferase(cArq)
					//				ENDIF
					_lContinua := .F.
					Exit
				Endif
				_aCabec[3]  := _cCliFor
				_aCabec[4]  := _cLoja
				_aCabec[12] := _cTpNF
			Endif
			IF _nLaco == 1 // quando tem somente 1 item XML nao retorno array
				_cProd 		:= CriaVar("B1_COD",.F.)
				_cDesc 		:= CriaVar("B1_DESC",.F.)
				_cUM	 	:= CriaVar("B1_UM",.F.)
				_cLocal 	:= CriaVar("B1_LOCPAD",.F.)
				_cTpProd	:= CriaVar("B1_TIPO",.F.)
				_cProdFor 	:= CriaVar("PB1_PRDFOR",.F.)
				_cCodBar 	:= CriaVar("PB1_CODBAR",.F.)
				_cDescForn 	:= CriaVar("B1_DESC",.F.)
				_cNCMFor  	:= CriaVar("B1_POSIPI",.F.)
				_cExtIpiF  	:= CriaVar("B1_EX_NCM",.F.) //Incluido Andre Minelli 08/06/2021
				_cCFOForn  	:= CriaVar("D1_CF",.F.)
				_cUMForn   	:= CriaVar("B1_UM",.F.)
				If TYPE("oXML:"+_cCpoXML+":_IDE:_NCT:TEXT") <> "U" // CTE
					If TYPE("oXML:"+_cCpoXML+":_INFCTENORM:_INFCARGA:_PROPRED:TEXT") == "U"
						_cDescForn := " "
					Else
						_cDescForn := &("oXML:"+_cCpoXML+":_INFCTENORM:_INFCARGA:_PROPRED:TEXT")
					Endif
					//If !_lTransf
					_cProd := cXMLPFCT

					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))

					If SB1->(dbSeek(xFilial("SB1") + _cProd))
						_cDesc	 := SB1->B1_DESC //"complemento de frete
						_cUM	 := SB1->B1_UM //"un"
						_cLocal	 := SB1->B1_LOCPAD //"01"
						_cTpProd := SB1->B1_TIPO //"CF"
					EndIf
					//Endif
					_nQtde  := 1
					_nPreco := Val(&("oXML:"+_cCpoXML+":_VPREST:_VTPREST:TEXT"))
					_nTotal := _nPreco * _nQtde
				Else
					_cProdFor 	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_CPROD:TEXT")
					_cCodBar	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_CEAN:TEXT")
					_cDescForn 	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_XPROD:TEXT")
					_cNCMFor  	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_NCM:TEXT")
					
					//Incluido Andre Minelli 08/06/2021
					If Type("oXML:"+_cCpoXML+":_DET:_PROD:_EXTIPI:TEXT") <> "U"
						_cExtIpiF  := &("oXML:"+_cCpoXML+":_DET:_PROD:_EXTIPI:TEXT")
					End If

					_cCFOForn  	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_CFOP:TEXT")
					_cUMForn   	:= &("oXML:"+_cCpoXML+":_DET:_PROD:_uCom:TEXT")
					_nQtde  	:= Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_QCOM:TEXT"))
					_nPreco 	:= Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_VUNCOM:TEXT"))
					_nTotal 	:= Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_VPROD:TEXT"))
					//ITALO MACIEL 09/12/20 - Acrescenta frete e despesa no item da nota
					IF Type("oXML:"+_cCpoXML+":_DET:_PROD:_VFRETE:TEXT") <> "U"
						_nFreItem := Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_VFRETE:TEXT"))
					Else
						_nFreItem := 0
					EndIf
					IF Type("oXML:"+_cCpoXML+":_DET:_PROD:_VOUTRO:TEXT") <> "U"
						_nOutItem := Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_VOUTRO:TEXT"))
					Else
						_nOutItem := 0
					EndIf
				Endif
				/*
				IF Len(Alltrim(_cProdFor)) > TamSX3("B1_COD")[1]
				_cProdFor := Right(Alltrim(_cProdFor),TamSX3("B1_COD")[1])
				ENDIF
				*/
				If TYPE("oXML:"+_cCpoXML+":_DET:_PROD:_XPED:TEXT") <> "U"
					_cPed := StrZero(Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_XPED:TEXT")),6)
				EndIf

				If TYPE("oXML:"+_cCpoXML+":_DET:_PROD:_NITEMPED:TEXT") <> "U"
					_nItemPed := StrZero(Val(&("oXML:"+_cCpoXML+":_DET:_PROD:_NITEMPED:TEXT")),4)
				EndIf

				//ICMS
				IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS") <> "U"
					If _cCRT == '3' //Regime Nacional
						For x := 0 to 99
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)) == "U"
								Loop
							ENDIF
							//ICMS NORMAL
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT") <> "U"
								_nBaseICM 	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT"))
								_nVrICM   	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VICMS:TEXT"))
								_nAliqICM	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PICMS:TEXT"))
							ENDIF
							//Origem
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT") <> "U"
								_cOrigem := &("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT")
							EndIf
							//ICMS ST
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBCST:TEXT") <> "U"
								_nBICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBCST:TEXT"))
								_nVICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VICMSST:TEXT"))
								_nAICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PICMSST:TEXT"))
								IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PMVAST:TEXT") <> "U"
									_nMVA := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PMVAST:TEXT"))
								EndIf
							ELSE
								_nBICMST := 0
								_nVICMST := 0
								_nAICMST := 0
								_nMVA	 := 0
							ENDIF
							Exit
						Next
					Else //Simples Nacional
						For x := 0 to 999
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)) == "U"
								Loop
							ENDIF
							//ICMS NORMAL
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBC:TEXT") <> "U"
								_nBaseICM 	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBC:TEXT"))
								_nVrICM   	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VICMS:TEXT"))
								_nAliqICM	:= Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PICMS:TEXT"))
							ENDIF
							//Origem
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_ORIG:TEXT") <> "U"
								_cOrigem := &("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_ORIG:TEXT")
							EndIf
							//ICMS ST
							IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBCST:TEXT") <> "U"
								_nBICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBCST:TEXT"))
								_nVICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VICMSST:TEXT"))
								_nAICMST := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PICMSST:TEXT"))
								IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PMVAST:TEXT") <> "U"
									_nMVA := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PMVAST:TEXT"))
								EndIf
							ELSE
								_nBICMST := 0
								_nVICMST := 0
								_nAICMST := 0
								_nMVA	 := 0
							ENDIF
							Exit
						Next
					EndIf
				ENDIF
				IF Type("oXML:"+_cCpoXML+":_IMP:_ICMS") <> "U"
					For x := 0 to 99
						IF Type("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)) == "U"
							Loop
						ENDIF
						IF Type("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT") <> "U"
							_nBaseICM 	:= Val(&("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT"))
							_nVrICM   	:= Val(&("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_VICMS:TEXT"))
							_nAliqICM	:= Val(&("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_PICMS:TEXT"))
						ENDIF
						If Type("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT") <> "U"
							_cOrigem	:= &("oXML:"+_cCpoXML+":_IMP:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT")
						EndIf
						Exit
					Next
				ENDIF
				//IPI
				IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_VBC") <> "U"
						_nBaseIPI := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT"))
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_PIPI") <> "U"
						_nAliqIPI := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT"))
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_VIPI") <> "U"
						_nVrIPI   := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT"))
					Endif
				ENDIF

				//PIS
				IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT") <> "U"
						_nBasePIS := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT"))
					Else
						_nBasePIS := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT") <> "U"
						_nAliqPIS := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT"))
					Else
						_nAliqPIS := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT") <> "U"
						_nVrPIS   := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT"))
					Else
						_nVrPIS   := 0
					Endif
				ENDIF
				//COFINS
				IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT") <> "U"
						_nBaseCOF := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT"))
					Else
						_nBaseCOF := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT") <> "U"
						_nAliqCOF := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT"))
					Else
						_nAliqCOF := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT") <> "U"
						_nVrCOF   := Val(&("oXML:"+_cCpoXML+":_DET:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT"))
					Else
						_nVrCOF   := 0
					Endif
				ENDIF
				//Atualiza dados do produto
				aProd := U_BuscaSB1(_cProdFor,_cCliFor,_cLoja,_cCodBar,_cOrigem,_cTpNF,_cCNPJ)

				If !Empty(aProd[1]) .and. !Empty(aProd[2]) .and. !Empty(aProd[3]) .and. !Empty(aProd[4])
					_cProd		:= aProd[1]
					_cLocal		:= aProd[2]
					_cTpProd	:= aProd[3]
					_cUM		:= aProd[4]

					//Validacao NCM e EX NCM incluida por Andre Minelli em 03/06/2021//
					If SB1->(DbSetOrder(1),MsSeek(xFilial("SB1") + _cProd))
						
						IF SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd))
							IF SZH->ZH_STATUS == 'P'
								//MsgAlert("Aprovacao de XML pendente, favor solicitar liberacao ao Fiscal.")
								If alltrim(SZH->ZH_NCMXML) <> alltrim(SZH->ZH_NCMPROD)
									AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com NCM " + SZH->ZH_NCMPROD + " porem consta no XML como " + SZH->ZH_NCMXML + ". "})
								End If

								If alltrim(SZH->ZH_EXXML) <> alltrim(SZH->ZH_EXPROD)
									AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com EX NCM " + SZH->ZH_EXPROD + " porem consta no XML como " + SZH->ZH_EXXML + "."})
								End If

								_lContinua := .F.

							End If

						Else

							If alltrim(_cNCMFor) <> alltrim(SB1->B1_POSIPI)							
								AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com NCM " + SB1->B1_POSIPI + " porem consta no XML como " + _cNCMFor + ". "})

								IF !(SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd)))
									dbSelectArea("SZH")
									RecLock("SZH",.T.)
									Replace ZH_FILIAL  with xFilial("SZH")
									Replace ZH_DOC     with _cNota
									Replace ZH_FORNECE with _cCliFor
									Replace ZH_LOJA    with _cLoja
									Replace ZH_COD     with _cProd
									Replace ZH_NCMPROD with SB1->B1_POSIPI
									Replace ZH_NCMXML  with _cNCMFor
									Replace ZH_EXPROD  with SB1->B1_EX_NCM
									Replace ZH_EXXML   with _cExtIpiF
									Replace ZH_STATUS  with "P"
									MsUnLock()
								Else
									dbSelectArea("SZH")
									RecLock("SZH",.F.)
									Replace ZH_NCMPROD with SB1->B1_POSIPI
									Replace ZH_NCMXML  with _cNCMFor
									Replace ZH_EXPROD  with SB1->B1_EX_NCM
									Replace ZH_EXXML   with _cExtIpiF
									Replace ZH_STATUS  with "P"
									MsUnLock()
								End If

								_lContinua := .F.

							End If

							If alltrim(_cExtIpiF) <> alltrim(SB1->B1_EX_NCM)

								AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com EX NCM " + SB1->B1_EX_NCM + " porem consta no XML como " + _cExtIpiF + "."})

									IF !(SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd)))
										dbSelectArea("SZH")
										RecLock("SZH",.T.)
										Replace ZH_FILIAL  with xFilial("SZH")
										Replace ZH_DOC     with _cNota
										Replace ZH_FORNECE with _cCliFor
										Replace ZH_LOJA    with _cLoja
										Replace ZH_COD     with _cProd
										Replace ZH_NCMPROD with SB1->B1_POSIPI
										Replace ZH_NCMXML  with _cNCMFor
										Replace ZH_EXPROD  with SB1->B1_EX_NCM
										Replace ZH_EXXML   with _cExtIpiF
										Replace ZH_STATUS  with "P"
										MsUnLock()
									Else
										dbSelectArea("SZH")
										RecLock("SZH",.F.)
										Replace ZH_NCMPROD with SB1->B1_POSIPI
										Replace ZH_NCMXML  with _cNCMFor
										Replace ZH_EXPROD  with SB1->B1_EX_NCM
										Replace ZH_EXXML   with _cExtIpiF
										Replace ZH_STATUS  with "P"
										MsUnLock()
									End If

									_lContinua := .F.
								//End If

							End If
						End If

					End If
					//Fim validacao NCM//

				EndIf

			ELSE
				_cProdFor  	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_CPROD:TEXT")
				_cCodBar  	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_CEAN:TEXT")
				_cDescForn 	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_XPROD:TEXT")
				_cNCMFor   	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_NCM:TEXT")

				//Incluido Andre Minelli 08/06/2021
				If Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_EXTIPI:TEXT") <> "U"
					_cExtIpiF  := &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_EXTIPI:TEXT")
				End If

				_cCFOForn  	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_CFOP:TEXT")
				_cUMForn   	:= &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_uCom:TEXT")
				_cProd 		:= CriaVar("B1_COD",.F.)
				_cDesc 		:= CriaVar("B1_DESC",.F.)
				_cUM	 	:= CriaVar("B1_UM",.F.)
				_cLocal 	:= CriaVar("B1_LOCPAD",.F.)
				_cTpProd	:= CriaVar("B1_TIPO",.F.)

				If type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_XPED:TEXT") <> "U"
					_cPed := StrZero(Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_XPED:TEXT")),6)
				EndIf

				If type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_NITEMPED:TEXT") <> "U"
					_nItemPed := StrZero(Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_NITEMPED:TEXT")),4)
				EndIf
				/*
				IF Len(Alltrim(_cProdFor)) > TamSX3("B1_COD")[1]
				_cProdFor := Right(Alltrim(_cProdFor),TamSX3("B1_COD")[1])
				ENDIF
				*/
				_nQtde  := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_QCOM:TEXT"))
				_nPreco := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VUNCOM:TEXT"))
				_nTotal := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VPROD:TEXT"))
				//ITALO MACIEL 09/12/20 - Acrescenta frete e despesa no item da nota
				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VFRETE:TEXT") <> "U"
					_nFreItem := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VFRETE:TEXT"))
				Else
					_nFreItem := 0
				EndIf
				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VOUTRO:TEXT") <> "U"
					_nOutItem := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_PROD:_VOUTRO:TEXT"))
				Else
					_nOutItem := 0
				EndIf
				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS") <> "U"
					If _cCRT == '3' //REGINE NACIONAL
						For x := 0 to 99
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)) == "U"
								Loop
							ENDIF
							//ICMS NORMAL
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT") <> "U"
								_nBaseICM := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBC:TEXT"))
								_nVrICM   := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VICMS:TEXT"))
								_nAliqICM := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PICMS:TEXT"))
							ENDIF
							//ORIGEM
							If Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT") <> "U"
								_cOrigem  := &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_ORIG:TEXT")
							EndIf
							//ICMS ST
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBCST:TEXT") <> "U"
								_nBICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VBCST:TEXT"))
								_nVICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_VICMSST:TEXT"))
								_nAICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PICMSST:TEXT"))
								IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PMVAST:TEXT") <> "U"
									_nMVA := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMS"+StrZero(x,2)+":_PMVAST:TEXT"))
								EndIf
							ENDIF
							Exit
						Next
					Else //SIMPLES NACIONAL
						For x := 0 to 999
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)) == "U"
								Loop
							ENDIF
							//ICMS NORMAL
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBC:TEXT") <> "U"
								_nBaseICM := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBC:TEXT"))
								_nVrICM   := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VICMS:TEXT"))
								_nAliqICM := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PICMS:TEXT"))
							ENDIF
							//ORIGEM
							If Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_ORIG:TEXT") <> "U"
								_cOrigem  := &("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_ORIG:TEXT")
							EndIf
							//ICMS ST
							IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBCST:TEXT") <> "U"
								_nBICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VBCST:TEXT"))
								_nVICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_VICMSST:TEXT"))
								_nAICMST := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PICMSST:TEXT"))
								IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PMVAST:TEXT") <> "U"
									_nMVA := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_ICMS:_ICMSSN"+StrZero(x,3)+":_PMVAST:TEXT"))
								EndIf
							ENDIF
							Exit
						Next
					EndIf
				ENDIF

				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT") <> "U"
						_nBaseIPI := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT"))
					Else
						_nBaseIPI := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT") <> "U"
						_nAliqIPI := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT"))
					Else
						_nAliqIPI := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT") <> "U"
						_nVrIPI   := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT"))
					Else
						_nVrIPI   := 0
					Endif
				ENDIF
				//PIS
				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT") <> "U"
						_nBasePIS := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT"))
					Else
						_nBasePIS := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT") <> "U"
						_nAliqPIS := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT"))
					Else
						_nAliqPIS := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT") <> "U"
						_nVrPIS   := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT"))
					Else
						_nVrPIS   := 0
					Endif
				ENDIF
				//COFINS
				IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ") <> "U"
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT") <> "U"
						_nBaseCOF := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT"))
					Else
						_nBaseCOF := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT") <> "U"
						_nAliqCOF := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT"))
					Else
						_nAliqCOF := 0
					Endif
					IF Type("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT") <> "U"
						_nVrCOF   := Val(&("oXML:"+_cCpoXML+":_DET["+Alltrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT"))
					Else
						_nVrCOF   := 0
					Endif
				ENDIF

				//Atualiza dados do produto
				aProd := U_BuscaSB1(_cProdFor,_cCliFor,_cLoja,_cCodBar,_cOrigem,_cTpNF,_cCNPJ)

				If !Empty(aProd[1]) .and. !Empty(aProd[2]) .and. !Empty(aProd[3]) .and. !Empty(aProd[4])
					_cProd		:= aProd[1]
					_cLocal		:= aProd[2]
					_cTpProd	:= aProd[3]
					_cUM		:= aProd[4]

					//Validacao NCM e EX incluida por Andre Minelli em 28/05/2021//
					If SB1->(DbSetOrder(1),MsSeek(xFilial("SB1") + _cProd))
						
						IF SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd))
							IF SZH->ZH_STATUS == 'P'
								//MsgAlert("Aprovacao de XML pendente, favor solicitar liberacao ao Fiscal.")
								If alltrim(SZH->ZH_NCMXML) <> alltrim(SZH->ZH_NCMPROD)
									AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com NCM " + SZH->ZH_NCMPROD + " porem consta no XML como " + SZH->ZH_NCMXML + ". "})
								End If

								If alltrim(SZH->ZH_EXXML) <> alltrim(SZH->ZH_EXPROD)
									AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com EX NCM " + SZH->ZH_EXPROD + " porem consta no XML como " + SZH->ZH_EXXML + "."})
								End If

								_lContinua := .F.

							END IF
						else 
							
							If alltrim(_cNCMFor) <> alltrim(SB1->B1_POSIPI)
								AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com NCM " + SB1->B1_POSIPI + " porem consta no XML como " + _cNCMFor + "."})
								
								IF !(SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd)))
									dbSelectArea("SZH")
									RecLock("SZH",.T.)
									Replace ZH_FILIAL  with xFilial("SZH")
									Replace ZH_DOC     with _cNota
									Replace ZH_FORNECE with _cCliFor
									Replace ZH_LOJA    with _cLoja
									Replace ZH_COD     with _cProd
									Replace ZH_NCMPROD with SB1->B1_POSIPI
									Replace ZH_NCMXML  with _cNCMFor
									Replace ZH_EXPROD  with SB1->B1_EX_NCM
									Replace ZH_EXXML   with _cExtIpiF
									Replace ZH_STATUS  with "P"
									MsUnLock()
								Else
									dbSelectArea("SZH")
									RecLock("SZH",.F.)
									Replace ZH_NCMPROD with SB1->B1_POSIPI
									Replace ZH_NCMXML  with _cNCMFor
									Replace ZH_EXPROD  with SB1->B1_EX_NCM
									Replace ZH_EXXML   with _cExtIpiF
									Replace ZH_STATUS  with "P"
									MsUnLock()
								End If

								_lContinua := .F.

							End If

							If alltrim(_cExtIpiF) <> alltrim(SB1->B1_EX_NCM)

								AADD(aErrNCM_EX,{"Produto " + alltrim(_cProd) + " cadastrado com EX NCM " + SB1->B1_EX_NCM + " porem consta no XML como " + _cExtIpiF + "."})

									IF !(SZH->(DbSetOrder(1),MsSeek(xFilial("SZH") + _cNota + _cCliFor + _cLoja + _cProd)))
										dbSelectArea("SZH")
										RecLock("SZH",.T.)
										Replace ZH_FILIAL  with xFilial("SZH")
										Replace ZH_DOC     with _cNota
										Replace ZH_FORNECE with _cCliFor
										Replace ZH_LOJA    with _cLoja
										Replace ZH_COD     with _cProd
										Replace ZH_NCMPROD with SB1->B1_POSIPI
										Replace ZH_NCMXML  with _cNCMFor
										Replace ZH_EXPROD  with SB1->B1_EX_NCM
										Replace ZH_EXXML   with _cExtIpiF
										Replace ZH_STATUS  with "P"
										MsUnLock()
									Else
										dbSelectArea("SZH")
										RecLock("SZH",.F.)
										Replace ZH_NCMPROD with SB1->B1_POSIPI
										Replace ZH_NCMXML  with _cNCMFor
										Replace ZH_EXPROD  with SB1->B1_EX_NCM
										Replace ZH_EXXML   with _cExtIpiF
										Replace ZH_STATUS  with "P"
										MsUnLock()
									End If

									_lContinua := .F.
								//End If

							End If
						End If
					End If
					//Fim validacao NCM//

				EndIf
			ENDIF

			aadd(_aItNF,{Strzero(I,TamSX3("PB1_ITEM")[1]),;//1
			_cProdFor,;//2
			_cDescForn,;//3
			_cProd,;//4
			IIF(Alltrim(_aCabec[1])=="CTE" .and. Alltrim(_aCabec[12])=="N",0,_nQtde),;//5
			_nPreco,;//6
			_nTotal,;//7
			_cNCMFor,;//8
			_cCFOForn,;//9
			_cUMForn,;//10
			_cUM,;//11
			_cTpProd,;//12
			_cLocal,;//13
			_cNFORI,;//14
			_cSerORI,;//15
			_cCNPJTR,;//16
			_nBaseICM,;//17
			_nVrICM,;//18
			_nAliqICM,;//19
			_nBaseIPI,;//20
			_nVrIPI,;//21
			_nAliqIPI,;//22
			_nBasePIS,;//23
			_nVrPIS,;//24
			_nAliqPIS,;//25
			_nBaseCOF,;//26
			_nVrCOF,;//27
			_nAliqCOF,;//28
			_nBICMST,;//29
			_nVICMST,;//30
			_nAICMST,;//31
			_nMVA,;//32
			_cPed,;//33
			_nItemPed,;//34
			_cCodBar,;//35
			_cOrigem,;//36
			_nFreItem,;//37
			_nOutItem;//38
			})

			_nBaseIPI := 0
			_nVrIPI   := 0
			_nAliqIPI := 0
		Next

		If Len(aErrNCM_EX) > 0

			_lContinua := .F.
			DEFINE MSDIALOG oDlgNCM TITLE "OCORRENCIAS XML" FROM 10,10 TO 450,675 PIXEL OF oDlgNCM
			oBrw := TWBrowse():New( 2, 05, 327, 200,{|| {" "," "," "," "," "," "," "," "," "," "," "}},{"Observacao"},{110,60,60},oDlgNCM, , , , , , , , , , , , , , .T., , , , , )

			oBrw:SetArray( aErrNCM_EX )
			oBrw:bLine     := {|| {aErrNCM_EX[oBrw:nAt,1] }}

			//DEFINE SBUTTON FROM 155,250 TYPE 1 ACTION oDlgNCM:End()  ENABLE OF oDlgNCM
			DEFINE SBUTTON FROM 208,305 TYPE 1 ACTION oDlgNCM:End()  ENABLE OF oDlgNCM
			ACTIVATE MSDIALOG oDlgNCM CENTERED

		End If

		If _lContinua
			If Len(_aCabec) > 0 .and. Len(_aItNF) > 0
				Begin Transaction
					_lRetor := Grv_NFE(_aCabec,_aItNF,lFornDep,_aNFORI,lSaida,lEntrada)
					_nImpor++
				End Transaction
				FClose(cArq)
				__CopyFile(cArq,_cXMLIMP+_cNomeXML)
				IF _lDelFile
					Ferase(cArq)
					Ferase(cArqOri)
				ENDIF
			Else
				FClose(cArq)
				aadd(_aERR,{_cNomeXML,"Itens da NF com problemas"})
			Endif
		Endif
		dbSelectArea("TRB")
		TRB->(dbSkip())
	Enddo
	oXML := Nil
	// DelClassIntf()()

	//Libera bloqueio da rotina
	GlbNmUnlock("XML"+cFilAnt)

	If Len(_aERR) > 0
		Alert("Encontrado problemas durante a importacao, Confirme para gerar o relatorio de LOG")
		u_EbXML_ERR(_aERR)
	Endif

	RestArea(_aArea)
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  05/28/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Grv_NFE(_aCabec,_aItNF,lFornDep,_aNFORI,lSaida,lEntrada)

	Local _aArea 		:= GetArea()
	Local _aAreaSF1 	:= SF1->(GetArea())
	Local _lRet    		:= .t.
	Local _cFormul 		:= "N"
	Local _cCodPal 		:= SuperGetMv("EB_PALLET",.F.,"")
	Local _cDEVTES 		:= Alltrim(SuperGetMv("EB_TESDV",.F.,""))
	Local _cTESPal 		:= SuperGetMv("EB_TESPALE",.F.,"")
	Local cALMTRR 		:= SuperGetMV("EB_ALMTRR",.F.,"")
	Local _cFilTran
	Local _cLocPad
	Local _cTES
	Local _cFilSB1Tr
	Local _cFilOri 		:= cFilant
	Local lTransf  		:= .f.
	Local _lTESTrf 		:= .f.
	Local _lGeraPB1X 	:= .t.
	Local _nItem 		:= 1
	Local _cFilSB1 		:= xFilial("SB1")
	Local _lJaImp 		:= .f.
	Local cProdFret		:= SuperGetMV("MV_XMLPFCT")
	Local cOperFret		:= SuperGetMV("MV_XOPEFRE")
	Local nX

	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial()+_aCabec[6]+_aCabec[7]+_aCabec[3]+_aCabec[4])
		If _aCabec[5] == SF1->F1_EMISSAO
			aadd(_aERR,{_cNomeXML,"NF ja digitada no sistema "+_aCabec[6]+" "+_aCabec[7]})
			Return
		Endif
	Endif

	dbSelectArea("PB0")
	dbSetOrder(1)
	If dbSeek(xFilial("PB0")+_aCabec[6]+_aCabec[7]+_aCabec[3]+_aCabec[4])
		_lJaImp := .T.
	Else
		dbSelectArea("SF1")
		dbSetOrder(8)
		If dbSeek(xFilial("SF1")+_aCabec[8])
			aadd(_aERR,{_cNomeXML,"NF ja digitada no sistema "+_aCabec[6]+" "+_aCabec[7]})
			Return
		Endif
	Endif
	dbSelectArea("PB0")
	If !_lJaImp

		RecLock("PB0",.T.)
		Replace PB0_FILIAL 	with xFilial("PB0")
		Replace PB0_FORNEC 	with _aCabec[3]
		Replace PB0_LOJA 	with _aCabec[4]
		Replace PB0_CNPJ	with _aCabec[2]
		Replace PB0_DOC 	with _aCabec[6]
		Replace PB0_SERIE 	with _aCabec[7]
		Replace PB0_FORMUL 	with _cFormul
		Replace PB0_TIPO 	with _aCabec[12]
		Replace PB0_ESPECI 	with _aCabec[1]
		Replace PB0_EMISSA 	with _aCabec[5]
		Replace PB0_ARQUIV 	with _aCabec[9]
		Replace PB0_CHVNFE 	with _aCabec[8]
		Replace PB0_INFCOM 	with _aCabec[13]
		Replace PB0_USRIMP 	with Substr(cUsuario,7,15)
		Replace PB0_EST 	with _aCabec[10]
		Replace PB0_DTAIMP 	with dDataBase
		Replace PB0_TRANFI 	with "N"
		Replace PB0_VERSAO 	with _aCabec[11]
		//Italo Maciel 17/09/18
		Replace PB0_BRICMS	with _aCabec[14]
		Replace PB0_ICMSRE	with _aCabec[15]
		Replace PB0_VALMER	with _aCabec[16]
		Replace PB0_FRETE	with _aCabec[17]
		Replace PB0_SEGURO	with _aCabec[18]
		Replace PB0_VALIPI	with _aCabec[19]
		Replace PB0_DESPES	with _aCabec[20]
		Replace PB0_VALBRU	with _aCabec[21]
		//Gustavo Costa 23/09/21
		Replace PB0_UFORIT 	with _aCabec[22]
		Replace PB0_UFDEST	with _aCabec[23]
		Replace PB0_MUORIT	with _aCabec[24]
		Replace PB0_MUDEST	with _aCabec[25]
		MsUnLock()

		_nRecPB0 := PB0->(Recno())
		//Italo Maciel 15/01/2020
		//desativado para aguardar a entrada das demais filiais
		lTransf := .F.//NF_TRANSF(_aCabec, @_cFilTran)
		//Retirar ApÛs entrada das demais filiais
		_cFilTran := _cFilOri
		If lTransf .and. _cFilTran <> _cFilOri
			cFilAnt := _cFilTran
			_cFilSB1Tr := xFilial("SB1")
			If _cFilSB1Tr == _cFilSB1
				dbSelectArea("SA1")
				SA1->(dbSetOrder(3))
				If SA1->( dbSeek( xFilial("SA1") + Alltrim(aEmpAtu[1][2]) ))
					_cCliFil := SA1->A1_COD
					_cLjFil  := SA1->A1_LOJA
					dbSelectArea("SD2")
					SD2->(dbSetOrder(3))
					If SD2->(dbSeek(xFilial("SD2")+_aCabec[6]+_aCabec[7]+_cCliFil+_cLjFil))
						_lTESTrf := .T. // Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_TRANFIL") == "1" // Transferencia entre filiais
						If _lTESTrf
							_lGeraPB1X := .f.
							_nItem := 1
							While !Eof() .and. xFilial("SD2")+_aCabec[6]+_aCabec[7]+_cCliFil+_cLjFil == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
								cFilAnt		:= _cFilOri
								_cLocPad	:= cALMTRR
								_cTES 		:= EBTesInt(1,"34",_aCabec[3],_aCabec[4],If(SD2->D2_TIPO$"DB","C","F"),SD2->D2_COD,"PB1_TES")
								dbSelectArea("PB1")
								RecLock("PB1",.T.)
								Replace PB1_FILIAL	with xFilial("PB1")
								Replace PB1_ITEM 	with Strzero(_nItem,TamSX3("PB1_ITEM")[1])
								Replace PB1_COD 	with SD2->D2_COD
								Replace PB1_PRDFOR 	with SD2->D2_COD
								Replace PB1_DSCFOR 	with Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")
								Replace PB1_FORNEC 	with _aCabec[3]
								Replace PB1_LOJA 	with _aCabec[4]
								Replace PB1_DOC 	with SD2->D2_DOC
								Replace PB1_SERIE 	with SD2->D2_SERIE
								Replace PB1_TIPO 	with SD2->D2_TIPO
								Replace PB1_CNPJ 	with _aCabec[2]
								Replace PB1_QUANT 	with SD2->D2_QUANT
								Replace PB1_VUNIT 	with SD2->D2_PRCVEN
								Replace PB1_UMFORN 	with SD2->D2_UM
								Replace PB1_QTSEGU 	with SD2->D2_QUANT
								Replace PB1_TOTAL 	with SD2->D2_TOTAL
								Replace PB1_TES 	with _cTES
								Replace PB1_CF	 	with SD2->D2_CF
								Replace PB1_UM 		with SD2->D2_UM
								Replace PB1_TP 		with SD2->D2_TP
								Replace PB1_LOCAL 	with Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_LOCPAD")
								Replace PB1_LOTECTL with SD2->D2_LOTECTL
								Replace PB1_DTVALID with SD2->D2_DTVALID
								//italo maciel 05/11/18
								Replace PB1_EMISSA 	with _aCabec[5]
								MsUnLock()
								_nItem++
								cFilAnt := _cFilTran
								dbSelectArea("SD2")
								SD2->(dbSkip())
							End
						Endif
					Endif
				Endif
			Endif
			cFilAnt := _cFilOri
			dbSelectArea("PB0")
			dbGoto(_nRecPB0)
			RecLock("PB0",.F.)
			Replace PB0_TRANFI with "S"
			MsUnLock()
		Endif
		cFilAnt := _cFilOri
		If _lGeraPB1X
			For _nIT:=1 to Len(_aItNF)
				RecLock("PB1",.T.)
				Replace PB1_FILIAL 	with xFilial("PB1")
				Replace PB1_ITEM 	with _aItNF[_nIT,1]
				Replace PB1_COD 	with _aItNF[_nIT,4]
				Replace PB1_PRDFOR 	with _aItNF[_nIT,2]
				Replace PB1_DSCFOR 	with _aItNF[_nIT,3]
				Replace PB1_FORNEC 	with _aCabec[3]
				Replace PB1_LOJA 	with _aCabec[4]
				Replace PB1_DOC 	with _aCabec[6]
				Replace PB1_SERIE 	with _aCabec[7]
				Replace PB1_TIPO 	with _aCabec[12]
				Replace PB1_CNPJ 	with _aCabec[2]
				Replace PB1_QUANT 	with _aItNF[_nIT,5]
				Replace PB1_VUNIT 	with _aItNF[_nIT,6]
				Replace PB1_QTSEGU 	with _aItNF[_nIT,5]
				Replace PB1_VUNSEG 	with _aItNF[_nIT,6]
				Replace PB1_TOTAL 	with _aItNF[_nIT,7]
				Replace PB1_POSIPI 	with _aItNF[_nIT,8]
				Replace PB1_CF 		with _aItNF[_nIT,9]
				Replace PB1_UMFORN 	with _aItNF[_nIT,10]
				Replace PB1_UM 		with _aItNF[_nIT,11]
				Replace PB1_TP 		with _aItNF[_nIT,12]
				Replace PB1_LOCAL 	with _aItNF[_nIT,13]
				Replace PB1_NFORI 	with _aItNF[_nIT,14]
				Replace PB1_SERIOR 	with _aItNF[_nIT,15]
				Replace PB1_CNPJOR 	with _aItNF[_nIT,16]
				Replace PB1_BASEIC 	with _aItNF[_nIT,17]
				Replace PB1_VALICM 	with _aItNF[_nIT,18]
				Replace PB1_PICM 	with _aItNF[_nIT,19]
				Replace PB1_BASEIP 	with _aItNF[_nIT,20]
				Replace PB1_VALIPI 	with _aItNF[_nIT,21]
				Replace PB1_IPI 	with _aItNF[_nIT,22]
				Replace PB1_BASEPI 	with _aItNF[_nIT,23]
				Replace PB1_VALPIS 	with _aItNF[_nIT,24]
				Replace PB1_ALQPIS 	with _aItNF[_nIT,25]
				Replace PB1_BASECO 	with _aItNF[_nIT,26]
				Replace PB1_VALCOF 	with _aItNF[_nIT,27]
				Replace PB1_ALQCOF 	with _aItNF[_nIT,28]
				Replace PB1_BRICMS 	with _aItNF[_nIT,29]
				Replace PB1_ICMSRE 	with _aItNF[_nIT,30]
				Replace PB1_ALIQSO 	with _aItNF[_nIT,31]
				Replace PB1_MARGEM 	with _aItNF[_nIT,32]
				//Italo Maciel 05/11/18
				Replace PB1_EMISSA 	with _aCabec[5]
				//Replace PB1_PEDIDO 	with _aItNF[_nIT,33]
				//Replace PB1_ITEMPC 	with _aItNF[_nIT,34]
				Replace PB1_CODBAR 	with _aItNF[_nIT,35]
				Replace PB1_ORIPRD 	with _aItNF[_nIT,36]
				//Italo Maciel 09/12/2020
				Replace PB1_VALFRE 	with _aItNF[_nIT,37]//frete
				Replace PB1_DESPES 	with _aItNF[_nIT,38]//despesa

				If lFornDep
					Replace PB1_TES with IIF(_aItNF[_nIT,4] == _cCodPal, _cTESPal, _cDEVTES)
				Endif

				If Alltrim(PB0->PB0_ESPECI) == "CTE"
					//Variaveis obrigatorias para uso do MaTesInt
					aHeader := {}
					aCols := {}

					Replace PB1_COD with cProdFret
					Replace PB1_TES with MaTesInt(1,cOperFret,PB0->PB0_FORNEC,PB0->PB0_LOJA,"F",PB1->PB1_COD,"PB1_TES")
					//alterado Andre Minelli 12/07/2021
					If _aItNF[_nIT,18] == 0
						Replace PB1_TES with "124" //Tes CTE sem clauclo de ICMS
					End If
				EndIf
				MsUnLock()
			Next
		Endif

		//Grava amarraÁ„o na PB2
		If Alltrim(PB0->PB0_ESPECI) == "CTE" //.AND. PB0->PB0_TIPO == "C"
			dbSelectArea("PB2")

			If !lErroDup
				For nX := 1 to Len(_aNFORI)
					RecLock("PB2",.T.)
					Replace PB2_FILIAL	with xFilial("PB2")
					Replace PB2_NFDIFR	with PB0->PB0_DOC
					Replace PB2_SEDIFR	with PB0->PB0_SERIE
					Replace PB2_DTDIGI	with dDataBase
					Replace PB2_TRANSP	with PB0->PB0_FORNEC
					Replace PB2_LOJTRA	with PB0->PB0_LOJA
					Replace PB2_NFORIG	with _aNFORI[nX][2]
					Replace PB2_SERORI	with _aNFORI[nX][3]
					Replace PB2_FORNEC	with _aNFORI[nX][4]
					Replace PB2_LOJA  	with _aNFORI[nX][5]
					Replace PB2_TIPO  	with "F"//_aNFORI[nX][6]
					Replace PB2_TPMOV	with IIF(lSaida,"S",IIF(lEntrada,"E",""))
					PB2->(MsUnlock())
				Next nX
			EndIf
		EndIf

	Else
		aadd(_aERR,{_cNomeXML,"XML ja importado no sistema "+_aCabec[6]+" "+_aCabec[7]})
	Endif

	RestArea(_aAreaSF1)
	RestArea(_aArea)
Return(_lRet)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Run ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Dispara geracao das rotinas automaticas                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Run()
	Local _cArea := GetArea()
	Local Titulo := 'Documento de Entrada'
	Local _lRet := .t.
	Private aRegErr := {}
	/*
	IF PB1->PB1_STATUS == "2"
	Aviso("AtenÁ„o","Esta nota j· foi efetivada.",{"Abortar"},2)
	Return()
	ENDIF
	*/
	_nRet := AVISO("Nota "+PB1->PB1_DOC,"Rotina de geraÁ„o de Documento de Entrada", {"Executar","Sair"},2,"")

	IF _nRet == 1 // Gera dados
		_cQuery := " SELECT R_E_C_N_O_ RECNOPB1"
		_cQuery += " FROM " + RetSqlName("PB1") +" PB1 "
		_cQuery += " WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
		_cQuery += " AND PB1_LIBNF = 'S'"
		_cQuery += " AND PB1_STATUS = '1'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY R_E_C_N_O_"
		_cQuery := ChangeQuery(_cQuery)
		TCQUERY _cQuery NEW ALIAS "CG001"
		dbSelectArea("CG001")
		While !Eof()
			_nRecno := CG001->RECNOPB1
			dbSelectArea("PB1")
			dbGoto(_nRecno)
			IF PB1->PB1_STATUS == "2"
				dbSelectArea("CG001")
				dbSkip()
				Loop
			ENDIF
			Processa( { || _COM01SF1( @_lRet ) }, Titulo , 'Confirmando nota fiscal '+PB1->PB1_DOC+'. Aguarde...', .F. )
			If !_lRet
				Exit
			Endif
			dbSelectArea("CG001")
			dbSkip()
		End
		dbSelectArea("CG001")
		dbCloseArea()
		RestArea(_cArea)
	ELSE // sair
		Return()
	ENDIF

	// restaura SX1 da rotina de transf.
	Pergunte("SCOMA001X1",.f.)

	RestArea(_cArea)
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01SF1 ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Inclus„o dos documentos de entrada                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function _COM01SF1(_lRet)
	Local _cAreaPB1 := PB1->(GetArea())
	Local _aNFRem := {}
	Private lMsErroAuto := .f.

	IF PB1->PB1_TIPO == "N"
		SA2->(dbSetOrder(3))
		IF !SA2->(dbSeek(XFilial("SA2")+PB1->PB1_CNPJ))
			Aviso("AtenÁ„o","O CNPJ "+Alltrim(PB1->PB1_CNPJ)+" n„o est· cadastrada como fornecedor. Verifique!",{"Abortar"},2)
			Return()
		ENDIF
		_cCliFor := SA2->A2_COD
		_cLoja   := SA2->A2_LOJA
	ELSE
		SA1->(dbSetOrder(3))
		IF !SA1->(dbSeek(XFilial("SA1")+PB1->PB1_CNPJ))
			Aviso("AtenÁ„o","O CNPJ "+Alltrim(PB1->PB1_CNPJ)+" n„o est· cadastrada como cliente. Verifique!",{"Abortar"},2)
			Return()
		ENDIF
		_cCliFor := SA1->A1_COD
		_cLoja   := SA1->A1_LOJA
	ENDIF

	// flag de pre-nota
	_lPreNota := PB1->PB1_TPNOTA == "2"

	// Cabecalho da nota fiscal de entrada
	aCabec   := {}
	aadd(aCabec,{"F1_TIPO"   	,PB1->PB1_TIPO})
	aadd(aCabec,{"F1_FORMUL" 	,"N"})
	aadd(aCabec,{"F1_DOC"    	,PB1->PB1_DOC})
	aadd(aCabec,{"F1_SERIE"  	,PB1->PB1_SERIE})
	aadd(aCabec,{"F1_EMISSAO"	,PB1->PB1_EMISSAO})
	aadd(aCabec,{"F1_FORNECE"	,_cCliFor})
	aadd(aCabec,{"F1_LOJA"   	,_cLoja})
	aadd(aCabec,{"F1_ESPECIE"	,PB1->PB1_ESPECIE})
	aadd(aCabec,{"F1_COND"		,PB1->PB1_COND})

	aadd(aCabec,{"F1_UFORITR"	,cUFORITR})
	aadd(aCabec,{"F1_UFDESTR"	,cUFDESTR})
	aadd(aCabec,{"F1_MUORITR"	,cMUORITR})
	aadd(aCabec,{"F1_MUDESTR"	,cMUDESTR})

	// Itens da nota fiscal de entrada
	_cChave  := PB1->(PB1_FILIAL+PB1_CNPJ+PB1_DOC+PB1_SERIE)

	aItens := {}
	_nLoop := 1
	PB1->(dbSetOrder(1))
	PB1->(dbSeek(_cChave))

	While PB1->(!Eof()) .and. PB1->(PB1_FILIAL+PB1_CNPJ+PB1_DOC+PB1_SERIE) == _cChave

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFilial("SB1")+PB1->PB1_PRODUTO))

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+PB1->PB1_TES))

		aLinha  := {}
		_aNFRem := {}
		If SF4->F4_PODER3 == "D"
			_aNFRem := Bxa_NFPD3(_cCliFor, _cLoja, PB1->PB1_PRODUTO, PB1->PB1_QTDE)
			If Empty(_aNFRem)
				Aviso("N„o encontrado saldo do produto "+Rtrim(PB1->PB1_COD)+" do cliente "+Rtrim(_cCliFor)+" / "+_cLoja+" em Poder de Terceiros !",{"Abortar"},2)
			EndIf
			Incl_Acols(_aNFRem, @_nLoop)
		Else
			aadd(_aNFRem,{" ", " ", " ", PB1->PB1_QTDE, " "," "})
			Incl_Acols(_aNFRem, @_nLoop)
		Endif
		PB1->(dbSkip())
	Enddo
	RestArea(_cAreaPB1)
	// Caso tenha itens e cabecalho definidos
	If Len(aItens) > 0 .And. Len(aCabec) > 0
		// Reinicializa ambiente para o fiscal
		If MaFisFound()
			MaFisEnd()
		EndIf
		IF _lPreNota
			// Inclui pre-nota
			MATA140(aCabec,aItens,3)
		ELSE
			// Inclui nota de entrada
			MATA103(aCabec,aItens,3)
		ENDIF
		// Checa erro de rotina automatica
		IF lMsErroAuto
			lMostraErro	:=.T.
			MostraErro()
			DisarmTransaction()
			_lRet := .f.
		ELSE
			// atualiza tabela
			TCSqlExec("UPDATE "+RetSqlName("PB1")+" SET PB1_STATUS = '2' WHERE D_E_L_E_T_ = ' ' AND PB1_FILIAL = '"+XFilial("PB1")+"' AND PB1_DOC = '"+PB1->PB1_DOC+"' AND PB1_SERIE = '"+PB1->PB1_SERIE+"' AND PB1_CNPJ = '"+PB1->PB1_CNPJ+"'")
			TcSqlExec("COMMIT")
			AVISO("Nota "+PB1->PB1_DOC,"Processamento concluÌdo com sucesso", {"Sair"},2,"")
		ENDIF
	ENDIF

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Del ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Exclusao do registro posicionado                           ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Del()
	IF PB1->PB1_STATUS == "2"
		Aviso("Nota Validada","Esta nota j· foi validada n„o poder· ser excluÌda.",{"Abortar"},2)
		Return()
	ENDIF
	IF PB1->PB1_TIPO=="N"
		_cMens := " do fornecedor "+Posicione("SA2",3,XFilial("SA2")+PB1->PB1_CNPJ,"A2_NOME")
	ELSE
		_cMens := " do cliente "+Posicione("SA1",3,XFilial("SA1")+PB1->PB1_CNPJ,"A1_NOME")
	ENDIF
	IF Aviso("Exclus„o de Nota","Confirma exclus„o da nota "+Alltrim(PB1->PB1_DOC)+_cMens,{"Sim","N„o"},2) == 1
		TCSqlExec("UPDATE "+RetSqlName("PB1")+" SET D_E_L_E_T_ = '*' WHERE PB1_FILIAL = '"+XFilial("PB1")+"' AND PB1_CNPJ = '"+PB1->PB1_CNPJ+"' AND PB1_DOC = '"+PB1->PB1_DOC+"' AND PB1_SERIE = '"+PB1->PB1_SERIE+"'")
		TcSqlExec("COMMIT")
	ENDIF
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Clr ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Compara PB1 com as cargas faturadas                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Clr()

	Processa( {|lEnd| COM01Clr2()}, "Aguarde...","Comparando as cargas...", .T. )

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Clr ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Compara PB1 com as cargas faturadas                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function COM01Clr2()

	Local _cArea := GetArea()
	Local _aComp := {}
	Local _aCompF2 := {}
	Local _aXMLF2 := {}
	Local I:=1
	Local _lDiv := .f.

	_aComp := Ger_array(_aComp, Space(09),Replicate("Z",9),"1")

	For I:=1 to Len(_aComp)

		_cCarga := _aComp[I,1]

		Comp_XML(_cCarga, @_aCompF2,"1")

		_aXMLF2 := Comp_Amb(_cCarga,_aComp,_aCompF2, @_lDiv)

		If _lDiv
			_cQuery := "UPDATE " + RetSqlName("PB1") + " SET PB1_LIBNF = 'D' "
			_cQuery += "WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
			_cQuery += " AND PB1_DOC = '"+_aComp[I,2]+"'"
			_cQuery += " AND D_E_L_E_T_ = ' '"
			TCSQLEXEC(_cQuery)
		Else
			_cQuery := "UPDATE " + RetSqlName("PB1") + " SET PB1_LIBNF = 'S' "
			_cQuery += "WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
			_cQuery += " AND PB1_DOC = '"+_aComp[I,2]+"'"
			_cQuery += " AND D_E_L_E_T_ = ' '"
			TCSQLEXEC(_cQuery)
		Endif
		While I<= Len(_aComp) .and. _cCarga == _aComp[I,1]
			I++
		End
		I--
	Next
	RestArea(_cArea)
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Leg ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Legenda                                                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Leg()
	BrwLegenda("Interface XML","Legenda",{{"DISABLE","Migrado"},;
		{"BR_AZUL","XML Divergente"},;
		{"BR_AMARELO","XML Validado"},;
		{"ENABLE","NF Gerada"}})
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ValidPerg ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Criacao de Perguntas                                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function ValidPerg(cPerg)
	Local aRegs:={}

	AADD(aRegs,{"Diretorio XML"    ,"","","mv_ch1","C",30,0,0,"G","NaoVazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","42","","",""})
	AADD(aRegs,{"EspÈcie"          ,"","","mv_ch2","C",05,0,0,"G","NaoVazio() .and. ExistCpo('SX5','42'+MV_PAR02)","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","42","","",""})
	AADD(aRegs,{"CondiÁ„o Pagto"   ,"","","mv_ch3","C",03,0,0,"G","Vazio() .or. ExistCPO('SE4')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SE4","","",""})
	AADD(aRegs,{"Natureza"         ,"","","mv_ch4","C",09,0,0,"G","Vazio() .or. ExistCPO('SED')","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
	AADD(aRegs,{"TES p/Vasilhame"  ,"","","mv_ch5","C",03,0,0,"G","ExistCPO('SF4')","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SF4","","",""})
	AADD(aRegs,{"Tipo da Nota"     ,"","","mv_ch6","N",01,0,0,"C","","mv_par06","Normal","","","","","Beneficiamento","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{"Gerar Documento"  ,"","","mv_ch7","N",01,0,0,"C","","mv_par07","Classificado","","","","","A Classificar","","","","","","","","","","","","","","","","","","","","","",""})

	// faz o ajuste no sx1 dos arquivos
	AjustaSx1( cPerg , aRegs )

	SX1->(dbSetOrder(1))
	IF SX1->(MsSeek(cPerg))
		While SX1->(!EOF()) .and. SX1->X1_GRUPO == cPerg
			cKey := "P." + SX1->X1_GRUPO + SX1->X1_ORDEM + "."
			IF SX1->X1_ORDEM == "01"
				aHelp01 := {}
				Aadd(aHelp01,"Diretorio XML")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe o diretorio")
				Aadd(aHelp01,"onde se encontra o XML para importar")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "02"
				aHelp01 := {}
				Aadd(aHelp01,"ESP…CIE")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe a espÈcie")
				Aadd(aHelp01,"a ser utilizada na nota")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "03"
				aHelp01 := {}
				Aadd(aHelp01,"CONDI«√O PAGTO")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe a condiÁ„o de ")
				Aadd(aHelp01,"pagamento a ser utilizada")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "04"
				aHelp01 := {}
				Aadd(aHelp01,"NATUREZA")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe a natureza")
				Aadd(aHelp01,"a ser utilizada na nota")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "05"
				aHelp01 := {}
				Aadd(aHelp01,"TES")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe o TES ")
				Aadd(aHelp01,"a ser utilizada na nota")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "06"
				aHelp01 := {}
				Aadd(aHelp01,"TIPO DA NOTA")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe o tipo da nota")
				Aadd(aHelp01,"sendo:")
				Aadd(aHelp01,"1) Normal")
				Aadd(aHelp01,"2) Beneficiamento")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "07"
				aHelp01 := {}
				Aadd(aHelp01,"MODALIDADE")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Informe a modalidade da nota")
				Aadd(aHelp01,"sendo:")
				Aadd(aHelp01,"1) Classificado")
				Aadd(aHelp01,"2) A Classificar")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			Endif
			SX1->(dbSkip())
		EndDo
	ENDIF

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01PC  ∫Autor  ≥Microsiga           ∫ Data ≥  19/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Amarra nota fiscal com o pedido de compra                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01PC()

	Local _nOpca

	IF PB1->PB1_STATUS == "2"
		Aviso("AtenÁ„o","OpÁ„o disponÌvel somente para notas n„o efetivadas.",{"Abortar"},2)
		Return()
	ENDIF

	IF PB1->PB1_TIPO <> "N"
		Aviso("AtenÁ„o","OpÁ„o disponÌvel somente para notas fiscais normais (Tipo N)",{"Abortar"},2)
		Return()
	ENDIF

	_nOpca := AxAltera("PB1",PB1->(Recno()),4,,{"PB1_LOTECT","PB1_CARGA","PB1_SEQCAR"},,,,,,)
	If _nOpca == 1 // Confirmou
		Atu_PB1C()
	Endif

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Est  ∫Autor  ≥Microsiga          ∫ Data ≥  19/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Estorna nota fiscal                                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Est()
	Local _cArea := GetArea()
	Private lMsErroAuto := .f.

	IF PB1->PB1_STATUS == "1"
		Aviso("Nota Migrada","Esta nota ainda n„o foi processada.",{"Abortar"},2)
		Return()
	ENDIF

	IF !MsgYesNo("Confirma estorno da nota fiscal de entrada Nr. "+PB1->PB1_DOC+" ?")
		Return()
	ENDIF

	IF PB1->PB1_TIPO == "N"
		SA2->(dbSetOrder(3))
		IF !SA2->(dbSeek(XFilial("SA2")+PB1->PB1_CNPJ))
			Aviso("AtenÁ„o","O CNPJ "+Alltrim(PB1->PB1_CNPJ)+" n„o est· cadastrada como fornecedor. Verifique!",{"Abortar"},2)
			Return()
		ENDIF
		_cCliFor := SA2->A2_COD
		_cLoja   := SA2->A2_LOJA
	ELSE
		SA1->(dbSetOrder(3))
		IF !SA1->(dbSeek(XFilial("SA1")+PB1->PB1_CNPJ))
			Aviso("AtenÁ„o","O CNPJ "+Alltrim(PB1->PB1_CNPJ)+" n„o est· cadastrada como cliente. Verifique!",{"Abortar"},2)
			Return()
		ENDIF
		_cCliFor := SA1->A1_COD
		_cLoja   := SA1->A1_LOJA
	ENDIF

	SF1->(dbSetOrder(1))
	IF SF1->(dbSeek(XFilial("PB1")+PB1->(PB1_DOC+PB1_SERIE)+_cCliFor+_cLoja+PB1->PB1_TIPO))
		aCabec := {}
		aItens := {}
		aadd(aCabec,{"F1_TIPO"   ,SF1->F1_TIPO})
		aadd(aCabec,{"F1_FORMUL" ,SF1->F1_FORMUL})
		aadd(aCabec,{"F1_DOC"    ,SF1->F1_DOC})
		aadd(aCabec,{"F1_SERIE"  ,SF1->F1_SERIE})
		aadd(aCabec,{"F1_EMISSAO",SF1->F1_EMISSAO})
		aadd(aCabec,{"F1_FORNECE",SF1->F1_FORNECE})
		aadd(aCabec,{"F1_LOJA"   ,SF1->F1_LOJA})
		aadd(aCabec,{"F1_ESPECIE",SF1->F1_ESPECIE})

		aadd(aCabec,{"F1_UFORITR"	,cUFORITR})
		aadd(aCabec,{"F1_UFDESTR"	,cUFDESTR})
		aadd(aCabec,{"F1_MUORITR"	,cMUORITR})
		aadd(aCabec,{"F1_MUDESTR"	,cMUDESTR})

		SD1->(dbSetOrder(1))
		SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))

		While SD1->(!Eof()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			aLinha := {}
			AAdd( aLinha, { "D1_DOC"    	, SD1->D1_DOC 	    , Nil } )
			AAdd( aLinha, { "D1_SERIE"    	, SD1->D1_SERIE	    , Nil } )
			AAdd( aLinha, { "D1_FORNECE"   	, SD1->D1_FORNECE 	, Nil } )
			AAdd( aLinha, { "D1_LOJA"    	, SD1->D1_LOJA	    , Nil } )
			AAdd( aLinha, { "D1_COD"    	, SD1->D1_COD 	    , Nil } )
			AAdd( aLinha, { "D1_ITEM"    	, SD1->D1_ITEM 	    , Nil } )

			aadd(aItens,aLinha)
			SD1->(dbSkip())
		Enddo

		IF PB1->PB1_TPNOTA == "2" // estorno de pre-nota
			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 5)
		ELSE // documento de entrada
			aRecSE2 := {}
			IF !MaCanDelF1(SF1->(Recno()),Nil,@aRecSE2,Nil,.T.)
				Aviso("AtenÁ„o (NFE)","A nota fiscal n„o pode ser excluÌda. Consulte Administrador",{"Sair"},2)
				Return()
			ENDIF
			MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabec, aItens, 5)
		ENDIF

		IF lMsErroAuto
			lMostraErro	:=.T.
			MostraErro()
		ELSE
			// atualiza tabela
			TCSqlExec("UPDATE "+RetSqlName("PB1")+" SET PB1_STATUS = '1' WHERE D_E_L_E_T_ = ' ' AND PB1_FILIAL = '"+XFilial("PB1")+"' AND PB1_DOC = '"+PB1->PB1_DOC+"' AND PB1_SERIE = '"+PB1->PB1_SERIE+"' AND PB1_CNPJ = '"+PB1->PB1_CNPJ+"'")
			TcSqlExec("COMMIT")
			AVISO("Nota "+PB1->PB1_DOC,"Nota fiscal estornada com sucesso", {"Sair"},2,"")
		ENDIF
	ELSE
		Aviso("AtenÁ„o (NFE)","A nota fiscal n„o foi encontrada. Consulte Administrador",{"Sair"},2)
		Return()
	ENDIF

	// restaura SX1 da rotina de transf.
	Pergunte("SCOMA001X1",.f.)

	RestArea(_cArea)
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01IND ∫Autor  ≥Microsiga           ∫ Data ≥  20/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Verifica existencia de indices especificos                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function _COM01IND()
	Local _cAreaSIX := SIX->(GetArea())
	Local _cMens    := ""
	Local _lExiste  := .f.

	// produto x fornecedor
	SIX->(dbSeek("SA5"))
	While SIX->(!Eof()) .and. SIX->INDICE == "SA5"
		IF ALLTRIM(SIX->NICKNAME) == "EDIXML" .and. Alltrim(SIX->CHAVE) == "A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF"
			_lExiste := .t.
			Exit
		EndIf
		SIX->(dbSkip())
	EndDo
	IF !_lExiste
		_cMens += "Tabela SA5 - Chave A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF"+Chr(13)+Chr(10)+" NickName EDIXML"
	ENDIF

	// cliente x fornecedor
	_lExiste := .f.
	SIX->(dbSeek("SA7"))
	While SIX->(!Eof()) .and. SIX->INDICE == "SA7"
		IF ALLTRIM(SIX->NICKNAME) == "EDIXML" .and. Alltrim(SIX->CHAVE) == "A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_CODCLI"
			_lExiste := .t.
			Exit
		EndIf
		SIX->(dbSkip())
	EndDo

	IF !_lExiste
		_cMens += IIF(!Empty(_cMens),Chr(13)+Chr(10),"")+"Tabela SA7 - Chave A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_CODCLI"+Chr(13)+Chr(10)+" NickName EDIXML"
	ENDIF

	IF !Empty(_cMens)
		Aviso("Falta de Õndice",_cMens+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Consulte Administrador do Sistema!",{"Sair"},2)
		RestArea(_cAreaSIX)
		Return .f.
	ENDIF

	RestArea(_cAreaSIX)
Return .t.

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_COM01Vis  ∫Autor  ≥Microsiga          ∫ Data ≥  21/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Vis()
	Local _cArea := GetArea()

	IF PB1->PB1_STATUS <> "2"
		Aviso("AtenÁ„o","A nota fiscal ainda n„o foi gerada",{"Abortar"},2)
		Return()
	ENDIF

	IF PB1->PB1_TIPO == "N"
		SA2->(dbSetOrder(3))
		SA2->(dbSeek(XFilial("SA2")+PB1->PB1_CNPJ))
		_cCliFor := SA2->(A2_COD+A2_LOJA)
	ELSE
		SA1->(dbSetOrder(3))
		SA1->(dbSeek(XFilial("SA1")+PB1->PB1_CNPJ))
		_cCliFor := SA1->(A1_COD+A1_LOJA)
	ENDIF

	SF1->(dbSetOrder(1))
	IF SF1->(dbSeek(XFilial("PB1")+PB1->(PB1_DOC+PB1_SERIE)+_cCliFor+PB1->PB1_TIPO))
		MsgRun('Carregando documento. Aguarde...',,{|| A103NFiscal("SF1",SF1->(RecNo()),2)})
	ELSE
		Aviso("AtenÁ„o","A nota fiscal n„o foi localizada",{"Abortar"},2)
	ENDIF

	// restaura SX1 da rotina de transf.
	Pergunte("SCOMA001X1",.f.)

	RestArea(_cArea)
Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  08/30/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Bxa_NFPD3(_cCliFor, _cLoja, _cProd, _nQtde)

	Local _aNFs := {}
	Local _aArea := GetArea()
	_cQuery := " SELECT B6_DOC, B6_SERIE, D2_ITEM, B6_XLOTEFO, B6_SALDO, B6_IDENT, B6_XLOTEFO"
	_cQuery += " FROM " + RetSqlName("SB6") +" SB6, " + RetSqlName("SD2") +" SD2"
	_cQuery += " WHERE B6_FILIAL = '"+xFilial("SB6")+"'"
	_cQuery += " AND B6_CLIFOR = '"+_cCliFor+"'"
	_cQuery += " AND B6_LOJA = '"+_cLoja+"'"
	_cQuery += " AND B6_PRODUTO = '"+_cProd+"'"
	_cQuery += " AND SB6.D_E_L_E_T_ = ' '"
	_cQuery += " AND B6_SALDO > 0"
	_cQuery += " AND B6_TIPO = 'E'"
	_cQuery += " AND B6_TPCF = 'F'"
	_cQuery += " AND B6_PODER3 = 'R'"
	_cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"'"
	_cQuery += " AND D2_IDENTB6 = B6_IDENT"
	_cQuery += " AND D2_COD = B6_PRODUTO"
	_cQuery += " AND D2_CLIENTE = B6_CLIFOR"
	_cQuery += " AND D2_LOJA = B6_LOJA"
	_cQuery += " AND SD2.D_E_L_E_T_ = ' '"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "SLDTER"
	dbSelectArea("SLDTER")
	While !Eof()
		_nQtd3 := SLDTER->B6_SALDO
		_nSld := _nQtd3 - _nQtde
		If _nSld >= 0
			aadd(_aNFs,{SLDTER->B6_DOC, SLDTER->B6_SERIE, SLDTER->D2_ITEM, _nQtde, SLDTER->B6_IDENT, B6_XLOTEFO})
			Exit
		Else
			aadd(_aNFs,{SLDTER->B6_DOC, SLDTER->B6_SERIE, SLDTER->D2_ITEM, _nQtd3, SLDTER->B6_IDENT, B6_XLOTEFO})
			_nQtde := _nQtde - _nQtd3
		Endif
		dbSkip()
	End
	dbSelectArea("SLDTER")
	dbCloseArea()
	RestArea(_aArea)
Return(_aNFs)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  08/30/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Incl_Acols(_aNFRem, _nLoop)

	Local TR:=1
	Local _cDEVTES := Alltrim(SuperGetMv("EB_TESDV",.F.,""))

	For TR:=1 to Len(_aNFRem)
		aLinha  := {}
		aadd(aLinha,{"D1_ITEM"		,Strzero(_nLoop,TamSX3("D1_ITEM")[1]),Nil})
		aadd(aLinha,{"D1_COD"		,PB1->PB1_PRODUTO,Nil})
		aadd(aLinha,{"D1_LOCAL"		,SB1->B1_LOCPAD	,Nil})
		// amarraÁ„o com pedido de compras
		IF !Empty(PB1->PB1_NUMPC)
			SC7->(dbSetOrder(1))
			SC7->(dbSeek(XFilial("SC7")+PB1->(PB1_NUMPC+PB1_ITEMPC)))
			aadd(aLinha,{"D1_PEDIDO"	,PB1->PB1_NUMPC  ,Nil})
			aadd(aLinha,{"D1_ITEMPC"	,PB1->PB1_ITEMPC ,Nil})
		ENDIF
		aadd(aLinha,{"D1_QUANT"		,_aNFRem[TR,4]	,Nil})
		aadd(aLinha,{"D1_VUNIT"		,PB1->PB1_PRECO	,Nil})
		aadd(aLinha,{"D1_TOTAL"		,Round(_aNFRem[TR,4] * PB1->PB1_PRECO,2)	,Nil})
		aadd(aLinha,{"D1_BASEICM"	,PB1->PB1_BASEICM,Nil})
		aadd(aLinha,{"D1_VALICM"	,PB1->PB1_VALICM	,Nil})
		aadd(aLinha,{"D1_BASEIPI"	,PB1->PB1_BASEIPI,Nil})
		aadd(aLinha,{"D1_IPI"		,PB1->PB1_ALIQIPI,Nil})
		aadd(aLinha,{"D1_VALIPI"	,PB1->PB1_VALIPI	,Nil})
		aadd(aLinha,{"D1_NFORI"		,_aNFRem[TR,1]	,Nil})
		aadd(aLinha,{"D1_SERIORI"	,_aNFRem[TR,2]	,Nil})
		aadd(aLinha,{"D1_ITEMORI"	,_aNFRem[TR,3]	,Nil})
		aadd(aLinha,{"D1_IDENTB6"	,_aNFRem[TR,5]	,Nil})
		IF !_lPreNota
			aadd(aLinha,{"D1_TES"		,PB1->PB1_TES	,Nil})
			If Rastro(PB1->PB1_PRODUTO,"L") .and. SF4->F4_ESTOQUE == "S"
				aadd(aLinha,{"D1_LOTECTL",PB1->PB1_LOTECT,Nil})
				aadd(aLinha,{"D1_DTVALID",PB1->PB1_DTVALI,Nil})
			EndIf
		ENDIF
		If Empty(PB1->PB1_CARGA) .and. _cDEVTES == PB1->PB1_TES
			aadd(aLinha,{"D1_XLOTTRF",PB1->PB1_LOTECT,Nil})
		Endif
		_nLoop++
		aadd(aItens,aLinha)
	Next
	// Checa se utiliza rastreabilidade
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  08/31/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function VerCarga(_cCarga)

	Local _aArea := GetArea()
	Local _aAreaF2 := SF2->(GetArea())
	Local _lRet := .t.
	dbSelectArea("SF2")
	dbSetOrder(5)
	If !dbSeek(xFilial()+_cCarga)
		_lRet := .f.
		Alert("Carga nao encontrada")
	Endif
	RestArea(_aAreaF2)
	RestArea(_aArea)
Return(_lRet)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/01/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function _COM01Div()


	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Declaracao de Variaveis                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Comparativo entre XML e a Carga Faturada"
	Local titulo       	:= "Comparativo entre XML e a Carga Faturada"
	Local nLin         	:= 80

	Local Cabec1       	:= "                   Arquivo XML                            |                     Carga Faturada"
	Local Cabec2       	:= "Produto         Descricao                      Quantidade | Produto         Descricao                      Quantidade"
	Local aOrd 			:= {}
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "COM01Div" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "COM01Div" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg       := "COM01DIV"

	dbSelectArea("PB1")
	PB1->(dbSetOrder(1))

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Monta a interface padrao com o usuario...                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	VldPg(cPerg)
	Pergunte(cPerg,.F.)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Envia controle para a funcao SETPRINT                        ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	wnrel := SetPrint("PB1",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"PB1")

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  01/09/11   ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
	±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ Programa principal                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local I:=1
	Local _aComp := {}
	Local _aNFFat := {}
	Local _aCompF2 := {}
	Local _aXMLF2 := {}
	Local _lDiv := .f.
	_aComp := Ger_array(_aComp, mv_par01,mv_par02,"2")

	For I:=1 to Len(_aComp)

		_cCarga := _aComp[I,1]

		Comp_XML(_cCarga, @_aCompF2,"2")

		_cQuery := " SELECT F2_DOC, F2_SERIE"
		_cQuery += " FROM "+ RetSqlName("SF2") +" SF2 "
		_cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"'"
		_cQuery += " AND F2_CARGA = '"+_cCarga+"'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY F2_DOC, F2_SERIE"
		_cQuery := ChangeQuery(_cQuery)
		TCQUERY _cQuery NEW ALIAS "NF001"
		dbSelectArea("NF001")
		While !Eof()
			aadd(_aNFFat,{NF001->F2_DOC, NF001->F2_SERIE})
			dbSkip()
		End
		dbSelectArea("NF001")
		dbCloseArea()
		dbSelectArea("PB1")
		If nLin > 60 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//          1         2         3         4         5         6         7         8         9         0         1         2         3
		//NF Recebida: "xxxXXXxxx   Numero da Carga: XXXxxx
		//Notas Faturadas: xxxXXXxxx Xxx, xxxXXXxxx Xxx, xxxXXXxxx Xxx, xxxXXXxxx Xxx, xxxXXXxxx Xxx, xxxXXXxxx Xxx, xxxXXXxxx Xxx

		@ nLin,000 PSAY "NF Recebida: " + _aComp[I,2]
		@ nLin,026 PSAY "Numero da Carga: " + _aComp[I,1]
		nLin++
		@ nLin,000 PSAY "Notas Faturadas: "
		_nAjus := 0
		_nSalto := 7
		For UI:=1 to Len(_aNFFat)
			@ nLin,017+_nAjus PSAY _aNFFat[UI,1]
			@ nLin,027+_nAjus PSAY _aNFFat[UI,2]
			_nAjus := _nAjus + 15
			If UI == _nSalto
				nLin++
				_nAjus := 0
				_nSalto := _nSalto + 7
			Endif
		Next
		nLin++
		nLin++
		_aXMLF2 := Comp_Amb(_cCarga,_aComp,_aCompF2, @_lDiv)

		For YG:=1 to Len(_aXMLF2)

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 60 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
			Endif

			@nLin,00 PSAY _aXMLF2[YG,2]
			@nLin,16 PSAY Substr(Posicione("SB1",1,xFilial("SB1")+_aXMLF2[YG,2],"B1_DESC"),1,30)
			@nLin,47 PSAY _aXMLF2[YG,3] Picture "@E 999,999.99"

			@nLin,60 PSAY _aXMLF2[YG,4]
			@nLin,76 PSAY Substr(Posicione("SB1",1,xFilial("SB1")+_aXMLF2[YG,4],"B1_DESC"),1,30)
			@nLin,107 PSAY _aXMLF2[YG,5] Picture "@E 999,999.99"

			//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			//          1         2         3         4         5         6         7         8         9         0         1         2         3
			//                   Arquivo XML                            |                     Carga Faturada
			//Produto         Descricao                      Quantidade | Produto         Descricao                      Quantidade
			//xxxXXXxxxXXXxxx xxxXXXxxxXXXxxxxxxXXXxxxXXXxxx 999,999.99 | xxxXXXxxxXXXxxx xxxXXXxxxXXXxxxxxxXXXxxxXXXxxx 999,999.99

			//	aadd(_aComp,{CG001->PB1_CARGA, CG001->PB1_DOC, CG001->PB1_PRODUT, CG001->PB1_QTDE})

			nLin := nLin + 1 // Avanca a linha de impressao
		Next

		While I<= Len(_aComp) .and. _cCarga == _aComp[I,1]
			I++
		End

		I--
		nLin:= 80
	Next

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Finaliza a execucao do relatorio...                                 ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	SET DEVICE TO SCREEN

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/01/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Ger_array(_aComp, _cDe,_cAte, _cTpc)

	Local _cArea := GetArea()

	_cQuery := " SELECT PB1_CARGA, PB1_DOC, PB1_PRODUT, SUM(PB1_QTDE) PB1_QTDE"
	_cQuery += " FROM " + RetSqlName("PB1") +" PB1 "
	_cQuery += " WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
	If _cTpc == "1"
		_cQuery += " AND PB1_LIBNF <> 'S'"
	Endif
	_cQuery += " AND PB1_DOC >= '"+_cDe+"'"
	_cQuery += " AND PB1_DOC <= '"+_cAte+"'"
	_cQuery += " AND D_E_L_E_T_ = ' '"
	_cQuery += " AND PB1_CARGA <> ' '"
	_cQuery += " GROUP BY PB1_CARGA, PB1_DOC, PB1_PRODUT"
	_cQuery += " ORDER BY PB1_CARGA, PB1_DOC, PB1_PRODUT"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "CG001"
	dbSelectArea("CG001")
	While !Eof()
		aadd(_aComp,{CG001->PB1_CARGA, CG001->PB1_DOC, CG001->PB1_PRODUT, CG001->PB1_QTDE})
		dbSkip()
	End
	dbSelectArea("CG001")
	dbCloseArea()
	RestArea(_cArea)
Return(_aComp)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/01/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Comp_XML(_cCarga, _aCompF2,_cTpC)

	Local _aArea := GetArea()
	_aCompF2 := {}
	_cQuery := " SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_DTDIGIT"
	_cQuery += " INTO SF2CARGA"
	_cQuery += " FROM "+ RetSqlName("SF2") +" SF2 "
	_cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"'"
	_cQuery += " AND F2_CARGA = '"+_cCarga+"'"
	_cQuery += " AND D_E_L_E_T_ = ' '"
	_cQuery += " ORDER BY F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA"
	TCSQLEXEC(_cQuery)

	_cQuery := " SELECT D2_COD, SUM(D2_QUANT) D2_QUANT"
	_cQuery += " FROM SF2CARGA,"+ RetSqlName("SD2") + " SD2 "
	_cQuery += " WHERE F2_DOC = D2_DOC"
	_cQuery += " AND F2_SERIE = D2_SERIE"
	_cQuery += " AND F2_CLIENTE = D2_CLIENTE"
	_cQuery += " AND F2_LOJA = D2_LOJA"
	_cQuery += " AND D_E_L_E_T_ = ' '"
	_cQuery += " AND F2_DTDIGIT = D2_DTDIGIT"
	_cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"'"
	_cQuery += " GROUP BY D2_COD"
	_cQuery += " ORDER BY D2_COD"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "FA001"
	dbSelectArea("FA001")
	_lDiv := .f.
	While !Eof()
		aadd(_aCompF2,{_cCarga, FA001->D2_COD, FA001->D2_QUANT})
		dbSkip()
	End

	_cQuery2 := "DROP TABLE SF2CARGA"
	TCSQLEXEC(_cQuery2)
	dbSelectArea("FA001")
	dbCloseArea()
	RestArea(_aArea)
Return
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ValidPerg ∫Autor  ≥Microsiga           ∫ Data ≥  17/10/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Criacao de Perguntas                                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP 10.1 - SIGMA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function VldPg(cPerg)
	Local aRegs:={}

	AADD(aRegs,{"Da NF"    ,"","","mv_ch1","C",09,0,0,"G"," ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{"Ate NF"   ,"","","mv_ch2","C",09,0,0,"G"," ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	// faz o ajuste no sx1 dos arquivos
	AjustaSx1( cPerg , aRegs )

	SX1->(dbSetOrder(1))
	IF SX1->(MsSeek(cPerg))
		While SX1->(!EOF()) .and. SX1->X1_GRUPO == cPerg
			cKey := "P." + SX1->X1_GRUPO + SX1->X1_ORDEM + "."
			IF SX1->X1_ORDEM == "01"
				aHelp01 := {}
				Aadd(aHelp01,"Da NF")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Inicia da NF")
				Aadd(aHelp01,"Informe o numero inicial da NF")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			ELSEIF SX1->X1_ORDEM == "02"
				aHelp01 := {}
				Aadd(aHelp01,"Ate NF")
				Aadd(aHelp01,"")
				Aadd(aHelp01,"Ultima NF")
				Aadd(aHelp01,"Informe o numero final da NF")
				PutSX1Help(cKey,aHelp01,aHelp01,aHelp01)
			Endif
			SX1->(dbSkip())
		EndDo
	ENDIF

Return()



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/01/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Atu_PB1C()

	Local _cCodPal := PADR(GETMV("EB_PALLET",.F.,""),15)
	Local _aArea := GetArea()
	_cQuery := "UPDATE " + RetSqlName("PB1") + " SET PB1_CARGA = '"+PB1_CARGA+"', PB1_SEQCAR = '"+PB1_SEQCAR+"'"
	If Empty(PB1->PB1_LOTECT)
		_cQuery += ", PB1_LOTECT = SPACE(10)"
	Endif
	_cQuery += " WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
	_cQuery += " AND PB1_DOC = '"+PB1->PB1_DOC+"'"
	_cQuery += " AND PB1_SERIE = '"+PB1->PB1_SERIE+"'"
	_cQuery += " AND PB1_CNPJ = '"+PB1->PB1_CNPJ+"'"
	_cQuery += " AND PB1_PRODUT <> '"+_cCodPal+"'"
	_cQuery += " AND D_E_L_E_T_ = ' '"
	TCSQLEXEC(_cQuery)
	If Empty(PB1->PB1_LOTECT)
		_cQuery := "UPDATE " + RetSqlName("PB1") + " SET PB1_LIBNF ='"+PB1_LIBNF+"'"
		_cQuery += " WHERE PB1_FILIAL = '"+xFilial("PB1")+"'"
		_cQuery += " AND PB1_DOC = '"+PB1->PB1_DOC+"'"
		_cQuery += " AND PB1_SERIE = '"+PB1->PB1_SERIE+"'"
		_cQuery += " AND PB1_CNPJ = '"+PB1->PB1_CNPJ+"'"
		_cQuery += " AND PB1_LOTECT = '"+PB1->PB1_LOTECT+"'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		TCSQLEXEC(_cQuery)
	Endif
	RestArea(_aArea)
Return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/01/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Comp_Amb(_cCarga,_aComp,_aCompF2, _lDiv)

	//aadd(_aComp,{CG001->PB1_CARGA, CG001->PB1_DOC, CG001->PB1_PRODUT, CG001->PB1_QTDE})
	//aadd(_aCompF2,{_cCarga, FA001->D2_COD, FA001->D2_QUANT})
	Local nAchou := 0
	Local K:=1
	Local _aMisc := {}
	nAchou:=ASCAN(_aComp,{|x| x[1] == _cCarga})
	If nAchou > 0
		For K:= nAchou to Len(_aComp)
			If _aComp[K,1] == _cCarga
				_nPos:=ASCAN(_aCompF2,{|x| x[1]+x[2] == _aComp[K,1]+_aComp[K,3]})
				If _nPos > 0
					aadd(_aMisc,{_cCarga,_aComp[K,3],_aComp[K,4], _aCompF2[_nPos,2], _aCompF2[_nPos,3]})
					If QtdComp(_aCompF2[_nPos,3]) <> QtdComp(_aComp[K,4])
						_lDiv := .t.
					Endif
				Else
					aadd(_aMisc,{_cCarga,_aComp[K,3],_aComp[K,4], " ", 0})
					_lDiv := .t.
				Endif
			Else
				Exit
			Endif
		Next
	Endif
	For J:=1 to Len(_aCompF2)
		_nPos:=ASCAN(_aComp,{|x| x[1]+x[3] == _aCompF2[J,1]+_aCompF2[J,2]})
		If _nPos == 0
			aadd(_aMisc,{_cCarga," ",0, _aCompF2[J,2], _aCompF2[J,3]})
		Endif
	Next
Return(_aMisc)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  05/30/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
/*
Static Function Busca_sb1()
Local _aArea := GetArea()
Local aMarca := {}
Local nX	 := 0

//Define origem nacional/importada
	If _cOrigem $ "1#2#3#8"
_cOrigem := "2"
	ElseIf _cOrigem $ "0#4#5#6#7"
_cOrigem := "0"
	EndIf

dbSelectArea("ZZM")
ZZM->(dbSetOrder(1))
	If ZZM->(dbSeek(xFilial("ZZM") + _cCliFor + _cLoja))
		While !ZZM->(EOF()) .AND. ZZM->ZZM_FORNEC == _cCliFor .AND. ZZM->ZZM_LOJA == _cLoja
AADD(aMarca,ZZM->ZZM_CODMAR)
ZZM->(dbSkip())
		EndDo
	EndIf

//Ajustar espaÁos no final do codigo
_cProdFor := PadR(Alltrim(_cProdFor),30)
_cCodBar  := PadR(Alltrim(_cCodBar),15)

SB1->(DbOrderNickName("EDI"))

	For nX := 1 to Len(aMarca)
		If SB1->(dbSeek(xFilial("SB1") + _cProdFor + aMarca[nX]))
			If SB1->B1_MSBLQL <> '1'
_cProd := SB1->B1_COD
Exit //Se encontrar o produto, sai do laÁo
			EndIf
		Else
SB1->(DbOrderNickName("CODBAR"))

			If SB1->(dbSeek(xFilial("SB1") + _cCodBar + aMarca[nX]))
				If SB1->B1_MSBLQL <> '1'
_cProd := SB1->B1_COD
Exit //Se encontrar o produto, sai do laÁo
				EndIf
			Endif
		EndIf
	Next nX

	If !Empty(_cProd)
_cLocal		:= RetFldProd(_cProd,"B1_LOCPAD")
_cUM   		:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_UM")
_cTpProd 	:= RetFldProd(_cProd,"B1_TIPO")
	Endif

RestArea(_aArea)
Return
*/
/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ≥NOVO4     ∫ Autor ≥ AP6 IDE            ∫ Data ≥  01/06/12   ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Descricao ≥ Codigo gerado pelo AP6 IDE.                                ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ AP6 IDE                                                    ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function EbXML_ERR(_aERR)


	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Declaracao de Variaveis                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Arquivos XML nao Importados"
	Local titulo       := "Arquivos XML nao Importados"
	Local nLin         := 80

	Local Cabec1       := "Nome do Arquivo                                                       Motivo"
	Local Cabec2       := ""
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "SCOMA001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "SCOMA001" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "PB0"

	dbSelectArea("PB0")
	dbSetOrder(1)


	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Monta a interface padrao com o usuario...                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	RptStatus({|| RunRepor2(Cabec1,Cabec2,Titulo,nLin,_aERR) },Titulo)
Return

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  01/06/12   ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
	±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ Programa principal                                         ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunRepor2(Cabec1,Cabec2,Titulo,nLin, _aERR)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	SetRegua(Len(_aERR))

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Posicionamento do primeiro registro e loop principal. Pode-se criar ≥
	//≥ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ≥
	//≥ cessa enquanto a filial do registro for a filial corrente. Por exem ≥
	//≥ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ≥
	//≥                                                                     ≥
	//≥ dbSeek(xFilial())                                                   ≥
	//≥ While !EOF() .And. xFilial() == A1_FILIAL                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	For GG:=1 to Len(_aERR)
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,00 PSAY Alltrim(Substr(_aERR[GG,1],1,65))
		@nLin,70 PSAY _aERR[GG,2]

		nLin := nLin + 1 // Avanca a linha de impressao

	Next
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Finaliza a execucao do relatorio...                                 ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	SET DEVICE TO SCREEN

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥SCOMA001  ∫Autor  ≥Microsiga           ∫ Data ≥  09/25/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function NF_TRANSF(_aCabec, _cFilTran)

	Local _lRet 	:= .f.
	Local aEmpSM0	:= FWLoadSM0()

	For nX := 1 to Len(aEmpSM0)
		If cEmpAnt == aEmpSM0[nX][1]//Empresa
			If _aCabec[2] == aEmpSM0[nX][18]
				_lRet := .t.
				_cFiltran := aEmpSM0[nX][2]
				Exit
			Endif
		EndIf
	Next nX

Return(_lRet)

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒø±±
	±±≥Programa  ≥ MATA089  ≥ Autor ≥ Aline Correa do Vale  ≥ Data ≥ 09.08.2002 ≥±±
	±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
	±±≥Sintaxe   ≥ MaTesInt(ExpN1,ExcC1,ExpC2,ExpC3,ExpC4,ExpC5)                ≥±±
	±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
	±±≥DescriáÖo ≥ ExpN1 = Documento de 1-Entrada / 2-Saida                     ≥±±
	±±≥          ≥ ExpC1 = Tipo de Operacao Tabela "DF" do SX5                  ≥±±
	±±≥          ≥ ExpC2 = Codigo do Cliente ou Fornecedor                      ≥±±
	±±≥          ≥ ExpC3 = Codigo do gracao E-Entrada                           ≥±±
	±±≥          ≥ ExpC4 = Tipo de Operacao E-Entrada                           ≥±±
	±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
	±±≥ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ≥±±
	±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
	±±≥ PROGRAMADOR  ≥ DATA   ≥ BOPS ≥  MOTIVO DA ALTERACAO                     ≥±±
	±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
	±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function EBTesInt(nEntSai,cTpOper,cClieFor,cLoja,cTipoCF,cProduto,cCampo)

	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aTes 		:= {}
	Local cTesRet	:= "   "
	Local cGrupo	:= ""
	Local cGruProd	:= ""
	Local cQuery	:= ""
	Local cNCM      := ""
	Local cEstado   := ""
	Local cAliasSFM	:= "SFM"
	Local cTabela  	:= ""
	Local lQuery	:= .F.
	Local nFM_POSIPI := SFM->(FieldPos("FM_POSIPI"))
	Local nFM_EST    := SFM->(FieldPos("FM_EST"))
	Local nFM_MSBLQL := SFM->(FieldPos("FM_MSBLQL"))
	Local cAlias	 := ""		//Tabela a ser utiliza para informacoes do produto
	Local c_GRTRIB   := ""		//SBI->BI_GRTRIB	/ 	SB1->B1_GRTRIB
	Local c_POSIPI   := "" 		//SBI->BI_POSIPI	/	SB1->B1_POSIPI
	Local c_TS		:=	""
	Local c_TE		:=	""
	Local cSb1Sbz   := SuperGetMV("MV_ARQPROD",.F.,"SB1")
	Local lArqProp  := SuperGetMV("MV_ARQPROP",.F.,.F.)
	Local bCond		:=	{||.T.}
	Local bCondAux	:=	{||.T.}
	Local bSort		:=	{||}
	Local bAddTes	:=	{||.T.}
	Local bAtTes	:=	{||.T.}
	Local bIFWhile	:=	{||.T.}
	Local aRet		:=	{}
	Local lRet		:= .T.
	Local cTesSaiB1	:= ""
	Local cTesEntB1	:= ""
	Local lGrade    :=  MaGrade() .And. SFM->(FieldPos("FM_REFGRD")) > 0 .And. SFM->(FieldPos("FM_DESREF")) > 0

	DEFAULT cTpOper  := &(ReadVar())
	DEFAULT cClieFor := ""
	DEFAULT cProduto := ""
	DEFAULT nEntSai  := 0
	DEFAULT cTipoCF  := "C"
	DEFAULT cCampo	:= ""

	cTabela  := "PB1"

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Verifica o grupo de tributacao do cliente/fornecedor         ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
	dbSetOrder(1)
	MsSeek(xFilial()+cClieFor+cLoja)
	If cTipoCF == "C"
		cGrupo  := SA1->A1_GRPTRIB
		cEstado := SA1->A1_EST
	Else
		cGrupo  := SA2->A2_GRPTRIB
		cEstado := SA2->A2_EST
	EndIf

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Verifica se o codigo do produto informado eh de grade≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lGrade
		MatGrdPrrf(@cProduto)
	EndIf

	If nModulo == 23
		dbSelectArea("SBI")
		dbSetOrder(1)
		If dbSeek(xFilial("SBI") + cProduto)
			cGruProd := SBI->BI_GRTRIB
			If SBI->(FieldPos("BI_POSIPI")) > 0
				cNCM := SBI->BI_POSIPI
			Endif
		Endif
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + cProduto)

			cAlias 	  := "SB1"
			c_GRTRIB  := "SB1->B1_GRTRIB"
			c_POSIPI  := "SB1->B1_POSIPI"
			c_TS	  := "SB1->B1_TS"
			c_TE	  := "SB1->B1_TE"

			If cSb1Sbz == "SBZ"
				// Se existir registro no SBZ (Indicadores de Produtos) busca as informacoes desta tabela
				c_GRTRIB  := "SBZ->BZ_GRTRIB"
				dbSelectArea("SBZ")
				SBZ->(dbSetOrder(1)) 	//BZ_FILIAL+BZ_PRODUTO

				If DbSeek(xFilial("SBZ") + cProduto) .And. lArqProp .And.!Empty(SBZ->(FieldGet(FieldPos("BZ_GRTRIB"))))//O parametro eh true e o campo esta preenchido?
					// sim
					cGruProd := &(c_GRTRIB)

				ElseIf !lArqProp  // O parametro eh false busca o conteudo vazio da tabela SBZ
					cGruProd := &(c_GRTRIB)

				Else // Neste caso o parametro eh true e busca as informacoes na Tabela SB1
					c_GRTRIB  := "SB1->B1_GRTRIB"
					cGruProd := &(c_GRTRIB)

					If !Empty(c_POSIPI)
						cNCM     := &(c_POSIPI)
					EndIf
				EndIf

			Else // neste caso busca as informacoes na tabela SB1 apenas
				cGruProd := &(c_GRTRIB)
				cTesSaiB1:= &(c_TS)
				cTesEntB1:= &(c_TE)
				If !Empty(c_POSIPI)
					cNCM     := &(c_POSIPI)
				Endif
			EndIf

		EndIf
	EndIf

	If cTipoCF == "C"
		bCond		:=	{||Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+(cAliasSFM)->FM_POSIPI+(cAliasSFM)->FM_EST+(cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_REFGRD) .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			(Iif(lGrade,(cAliasSFM)->FM_REFGRD == cProduto .Or. Empty((cAliasSFM)->FM_REFGRD),.T.)) .And.;
			(Alltrim(cGruProd) == Alltrim((cAliasSFM)->FM_GRPROD) .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			(cClieFor+cLoja == (cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI .Or. Empty((cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI)) .And.;
			(AllTrim(cGrupo) == AllTrim((cAliasSFM)->FM_GRTRIB) .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
			(nFM_EST==0 .Or. cEstado == (cAliasSFM)->FM_EST .Or. Empty((cAliasSFM)->FM_EST)) .And.;
			(nFM_POSIPI==0 .Or. cNCM == (cAliasSFM)->FM_POSIPI .Or. Empty((cAliasSFM)->FM_POSIPI)))}

		bAddTes		:=	{||aadd(aTes, {(cAliasSFM)->FM_PRODUTO,;
			(cAliasSFM)->FM_GRPROD,;
			IIf(nFM_POSIPI>0,(cAliasSFM)->FM_POSIPI,""),;
			(cAliasSFM)->FM_CLIENTE,;
			(cAliasSFM)->FM_LOJACLI,;
			(cAliasSFM)->FM_GRTRIB,;
			IIf(nFM_EST>0,(cAliasSFM)->FM_EST,""),;
			(cAliasSFM)->FM_TE,;
			(cAliasSFM)->FM_TS,;
			Iif(lGrade,(cAliasSFM)->FM_REFGRD,"")})}

		bSort		:=	{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[10] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[7]+y[10]}
	Else
		bCond		:=	{|| Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+(cAliasSFM)->FM_POSIPI+(cAliasSFM)->FM_EST+(cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_REFGRD) .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			(Iif(lGrade,(cAliasSFM)->FM_REFGRD == cProduto .Or. Empty((cAliasSFM)->FM_REFGRD),.T.)) .And.;
			(Alltrim(cGruProd) == Alltrim((cAliasSFM)->FM_GRPROD) .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			(cClieFor+cLoja == (cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR .Or. Empty((cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR)) .And.;
			(AllTrim(cGrupo) == AllTrim((cAliasSFM)->FM_GRTRIB) .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
			(nFM_EST==0 .Or. cEstado == (cAliasSFM)->FM_EST .Or. Empty((cAliasSFM)->FM_EST)) .And.;
			(nFM_POSIPI==0 .Or. cNCM == (cAliasSFM)->FM_POSIPI .Or. Empty((cAliasSFM)->FM_POSIPI)))}

		bAddTes		:=	{|| aadd(aTes,{(cAliasSFM)->FM_PRODUTO,;
			(cAliasSFM)->FM_GRPROD,;
			IIf(nFM_POSIPI>0,(cAliasSFM)->FM_POSIPI,""),;
			(cAliasSFM)->FM_FORNECE,;
			(cAliasSFM)->FM_LOJAFOR,;
			(cAliasSFM)->FM_GRTRIB,;
			IIf(nFM_EST>0,(cAliasSFM)->FM_EST,""),;
			(cAliasSFM)->FM_TE,;
			(cAliasSFM)->FM_TS,;
			Iif(lGrade,(cAliasSFM)->FM_REFGRD,"")})}

		bSort		:=	{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[10] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[7]+y[10]}
	EndIf

	bIRWhile		:=	{||((cAliasSFM)->(!Empty(FM_GRTRIB) .And. !Empty(FM_GRPROD)) .And. AllTrim(cGrupo)+AllTrim(cGruProd)==(cAliasSFM)->(AllTrim(FM_GRTRIB)+AllTrim(FM_GRPROD))) .Or.;
		(cAliasSFM)->(Empty(FM_GRTRIB) .Or. Empty(FM_GRPROD))}

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Ponto de entrada que permite alterar a regra de selecao do TES,≥
	//≥alterar a ordem do array com os elementos encontrados pela     ≥
	//≥rotina e alterar o conteudo do array com os campos do SFM.     ≥
	//≥Todos os retornos tem que ser em forma de CodBlock.            ≥
	//≥Caso seja incluido campo novo para ser tratado na regra, se faz≥
	//≥necessario incluir no X2_UNICO do SFM.                         ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If ExistBlock("MT089CD")
		aRet		:=	execblock("MT089CD",.T.,.T.,{bCond,bSort,bIRWhile,bAddTes,cTabela})
		bCondAux	:= 	aRet[1]
		bSort 	:= 	aRet[2]
		bIFWhile	:= 	aRet[3]
		bAtTes	:=	aRet[4]
	EndIf

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Pesquisa por todas as regras validas para este caso          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	#IFDEF TOP

		If(lRet)
			lQuery := .T.
			cAliasSFM := GetNextAlias()
			cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "
			cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'"
			cQuery += "AND SFM.FM_TIPO = '" + cTpOper + "'"
			cQuery += "AND SFM.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
		EndIf
		cAliasSFM := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFM,.T.,.T.)

	#ELSE
		dbSelectArea("SFM")
		dbSetOrder(1)
		MsSeek(xFilial("SFM")+cTpOper)
	#ENDIF
	While !Eof() .And. (cAliasSFM)->FM_TIPO==cTpOper .And. (Iif(nFM_MSBLQL > 0 .And.(cAliasSFM)->FM_MSBLQL == '1',.F.,.T.))

		IF Eval(bCond) .And. Eval(bCondAux)
			If Eval(bIRWhile) .and. Eval(bIFWhile)
				Eval(bAddTes)//Adiciono o conteudo original da rotina
				Eval(bAtTes) //Caso o ponto de entrada MT089CD esteja ativo, adiciono o retorno dele
			EndIf
		EndIf

		dbSelectArea(cAliasSFM)
		dbSkip()
	EndDo
	If ( lQuery )
		dbSelectArea(cAliasSFM)
		dbCloseArea()
		dbSelectArea("SFM")
	EndIf
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Pesquisa por todas as regras validas para este caso          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	aSort(aTES,,,bSort) //Ordena o array conforme passado na regra do bSort, podendo ser alterardo pelo PE MT089CD
	If Len(aTes) <> 0
		For nI:=1 to Len(aTes)
			cTesRet := If(nEntSai==1,aTes[1][8],aTes[1][9])
			If !Empty(cTesRet)
				Exit
			Endif
		Next
	EndIf

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Restaura a integridade da rotina                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	RestArea(aAreaSA2)
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aArea)
Return(cTesRet)
