#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.ch"
#include "msmgadd.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "SPEDNFE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

#DEFINE TAMMAXXML  GetNewPar("MV_XMLSIZE",400000)
#DEFINE VBOX       080
#DEFINE HMARGEM    030

Static oBrw1	:= Nil
Static oBrw2	:= Nil

User Function CADSC5()
	Local aList		:= {}

	Private aSelFil := {}
	Private cOpFil1	:= "01"
	Private cOpFil2	:= "05"

	PswOrder(1)
	If PswSeek(__cUserId, .T.)
		aList := PswRet(1) // Retorna vetor com informações do usuário
	EndIf

	If Len(aList[2][6]) > 1 .OR. aList[2][6][1] == "@@@@"
		aSelFil := AdmGetFil(.F.,.T.,"SC5")

		If Len(aSelFil) <= 0
			Return
		EndIf
	ElseIf Len(aList[2][6]) == 1 .AND. aList[2][6][1] <> "@@@@"
		AADD(aSelFil,SubStr(aList[2][6][1],3,6))
	EndIf

	FWMsgRun(,{ || TelaPed(aSelFil) }, "Aguarde", "Filtrando Pedidos" )

Return

Static Function TelaPed(aParamFil)
	Local cObs := ""
	Local aCoors
	Local oDlg, oPanelUp, oFWLayer, oPanelDown, oRelac, oObs
	Local oFont := TFont():New('Courier new',,-16,.T.)
	Local cTitulo
	Local nX

	Default aParamFil := {}

	aCoors := FWGetDialogSize( oMainWnd )

	Private cArqTrb
	Private cTmpSC5 	:= GetNextAlias()
	Private aRotina		:= MenuDef()
	Private aSeek 		:= {}
	Private aDados 		:= {}
	Private aValores 	:= {}
	Private aFieFilter 	:= {}
	Private aFilBrw		:= {"SC5",''}
	Private aSelFil		:= aParamFil

	//Cria tabela temporaria
	fCriaTemp(@cTmpSC5,@cArqTrb)

	//Popula tabela temporaria com Pedidos
	fLoadTemp(cTmpSC5,cOpFil1,cOpFil2)//iniciar o browse em '01'

	Define MsDialog oDlg Title ' ' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel STYLE nOR( WS_VISIBLE, WS_POPUP )

	//Atualiza grid
	SetKey( VK_F5, { || FWMsgRun(,{ || fCriaTemp(@cTmpSC5,@cArqTrb), fLoadTemp(cTmpSC5,cOpFil1,cOpFil2), RefreshBrw(1) }, "Aguarde", "Atualizando Pedidos" )})
	SetKey( VK_F6, { || FWMsgRun(,{ || FilSC5() } , "Aguarde", "Filtrando Pedidos" )} )
	SetKey( VK_F7, { || FWMsgRun(,{ || U_HISTPED(.T.) } , "Aguarde", "Buscando Hisórico..." )} )

	// Cria o conteiner onde serão colocados os browses
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlg, .F., .T. )

	// Define Painel Superior
	oFWLayer:AddLine( 'UP', 80, .F. )                       // Cria uma "linha" com 50% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse pedaço do container

	// Painel Inferior
	oFWLayer:AddLine( 'DOWN', 20, .F. )                     // Cria uma "linha" com 50% da tela
	oFWLayer:AddCollumn( 'ALL' ,  100, .T., 'DOWN' )        // Na "linha" criada eu crio uma coluna com 50% da tamanho dela
	oPanelDown := oFWLayer:GetColPanel( 'ALL' , 'DOWN' )  // Pego o objeto do pedaço esquerdo

	//Instaciamento
	oBrw1 := FWmBrowse():New()
	oBrw1:SetAlias( cTmpSC5 )
	oBrw1:SetOwner( oPanelUp )
	oBrw1:ForceQuitButton()
	//Executa duplo-clique
	oBrw1:SetExecuteDef(4)

	cTitulo := "Faturamento - Pedido de Venda - Filiais Selecionadas: "
	For nX := 1 to Len(aSelFil)
		cTitulo += aSelFil[nX]
		If nX < Len(aSelFil)
			cTitulo += " / "
		EndIf
	Next nX

	oBrw1:SetDescription( cTitulo )
	oBrw1:SetTemporary( .T. )
	oBrw1:SetProfileID( '1' )
	oBrw1:SetLocate()
	oBrw1:SetUseFilter( .F. )
	oBrw1:SetDBFFilter( .T. )
	oBrw1:SetFilterDefault( "" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
	oBrw1:SetFieldFilter(aFieFilter)
	oBrw1:DisableDetails()
	oBrw1:lOptionReport := .F.

	//Atualiza browse
	//oBrw1:SetTimer({|| fCriaTemp(@cTmpSC5,@cArqTrb), fLoadTemp(cTmpSC5), RefreshBrw(1) }, 3000)

	//Legenda da grade, é obrigatório carregar antes de montar as colunas
	oBrw1:AddLegend("STATUS == 'U'"										,"BR_AZUL"	,"Em Uso")
	oBrw1:AddLegend("ALLTRIM(CANC) == '' .AND. EMISSAO == ddatabase"	,"GREEN"	,"Do Dia")
	oBrw1:AddLegend("ALLTRIM(CANC) == '' .AND. EMISSAO == ddatabase-1"	,"YELLOW"	,"Dia Anterior")
	oBrw1:AddLegend("ALLTRIM(CANC) == '' .AND. EMISSAO <  ddatabase-1"	,"RED"  	,"Antigo")
	oBrw1:AddLegend("CANC == 'CANC'"									,"BR_CINZA"	,"Cancelados")


	//Detalhes das colunas que serão exibidas
	oBrw1:SetColumns(MontaCol("STATUS"	,""				,01,"@!",0,001,0,.T.))
	oBrw1:SetColumns(MontaCol("CANC"	,""				,04,"@!",0,004,0,.F.))
	oBrw1:SetColumns(MontaCol("FILIAL" 	,"Filial"		,02,"@!",0,006,0,.T.))
	oBrw1:SetColumns(MontaCol("DESCFIL" ,"Filial"		,02,"@!",0,010,0,.F.))
	oBrw1:SetColumns(MontaCol("OPER" 	,"Operação"		,03,"@!",0,015,0,.F.))
	oBrw1:SetColumns(MontaCol("NUMERO" 	,"Numero"		,04,"@!",1,006,0,.F.))
	oBrw1:SetColumns(MontaCol("EMISSAO"	,"Emissão"		,05,"@!",1,008,0,.F.))
	oBrw1:SetColumns(MontaCol("UF" 		,"UF"			,06,"@!",1,002,0,.F.))
	oBrw1:SetColumns(MontaCol("CLIENTE"	,"Cliente"		,07,"@!",1,020,0,.F.))
	oBrw1:SetColumns(MontaCol("VENDE"	,"Representante/Vendedor",08,""	,1,020,0,.F.))
	oBrw1:SetChange({|| fAtuObs(@oObs,@cObs) })
	oBrw1:Activate()

	oObs := tMultiget():New(00,00,{| u | if( pCount() > 0, cObs := u, cObs )},oPanelDown,/*aCoors[4]/2*/,/*92*/,oFont,,,,,.T.,,,,,,.T.,,,,,.T.)
	oObs:Align := CONTROL_ALIGN_ALLCLIENT

	Activate MsDialog oDlg Center

	If !Empty(cArqTrb)
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		cArqTrb := ""
		(cTmpSC5)->(DbCloseArea())
		delTabTmp(cTmpSC5)
		dbClearAll()
	Endif

	SetKey( VK_F5, Nil)
	SetKey( VK_F6, Nil)
	SetKey( VK_F7, Nil)
Return


Static Function fAtuObs(oObs,cTexto)

	If ValType(oObs) <> "U"

		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek((cTmpSC5)->(SUBSTR(FILIAL,1,6)+NUMERO)))
			cTexto := "HORA: " + SC5->C5_XHORA

			cTexto += SPACE(5)
			cTexto += "TRANSP: "

			dbSelectArea("SA4")
			SA4->(dbSetOrder(1))
			If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
				//cTexto += SPACE(5)
				//cTexto += "TRANSP: " + SA4->A4_NOME
				cTexto += SA4->A4_NOME
			EndIf

			cTexto += CHR(13) + CHR(10)
			cTexto += "OBSERVAÇÃO: "
			cTexto += CHR(13) + CHR(10)
			cTexto += SC5->C5_XOBS

		EndIf

		oObs:Refresh()
	EndIf

Return


Static Function RefreshBrw(nRefr)
	Local nPos := 0

	//Checa se status está marcado indevidamente
	/*(cTmpSC5)->(dbGoTop())
	While !(cTmpSC5)->(EOF())
		If (cTmpSC5)->STATUS == "U"
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek((cTmpSC5)->FILIAL + (cTmpSC5)->NUMERO))
				nReg := SC5->(Recno())
			EndIf

			If SC5->(DBRLock(nReg))
				Reclock("SC5",.F.)
				Replace C5_XSTATUS with ""
				SC5->(MsUnlock())

				Reclock(cTmpSC5,.F.)
				Replace (cTmpSC5)->STATUS with ""
				(cTmpSC5)->(MsUnlock())
			EndIf
		EndIf
		(cTmpSC5)->(dbSkip())
	EndDo*/

	If nRefr == 1
		oBrw1:Refresh(.T.)
	ElseIf nRefr == 2
		oBrw1:Refresh(.F.)
		oBrw1:GoBottom()
	ElseIf nRefr == 3
		nPos := oBrw1:At()
		oBrw1:Refresh(.F.)
		oBrw1:GoTo(nPos)
	EndIf

Return .T.


//Função do menu
Static Function MenuDef()
	Local aRotina	:= {}

	//AADD(aRotina, {"Faturar"			,"FWMsgRun(, {|| U_ALTSC5()				}	, 'Aguarde', 'Abrindo Pedido' )", 0, 4, 0, .T. })
	AADD(aRotina, {"Faturar"			,"U_ALTSC5()"																, 0, 4, 0, .T. })
	//AADD(aRotina, {"Faturar"			,"FWMsgRun(, {|| U_PrepDoc() 			}	, 'Aguarde','Faturando Pedido')", 0, 3, 0, .T. })
	//AADD(aRotina, {"Excluir"			,"FWMsgRun(, {|| U_EXCPED() 			}	, 'Aguarde','Excluindo Pedido')", 0, 5, 0, NIL })
	//AADD(aRotina, {"Reenvio NF-e"		,"FWMsgRun(, {|| U_TransmNF() 	}			, 'Aguarde','Processando a rotina...')"					, 0, 3, 0, .T. })
	AADD(aRotina, {"Reenvio NF-e"		,"U_TransmNF()"																, 0, 3, 0, .T. })
	AADD(aRotina, {"Status NF-e"		,"FWMsgRun(, {|| U_MonitNF()			}	, 'Aguarde', 'Monitorando' )"	, 0, 3, 0, .T. })
	AADD(aRotina, {"Cancelamento NF-e"	,"FWMsgRun(, {|| U_CancNF(1)			}	, 'Aguarde', 'Abrindo' )"		, 0, 3, 0, .T. })
	AADD(aRotina, {"Carta Correção"		,"FWMsgRun(, {|| U_CartCorr()			}	, 'Aguarde', 'Abrindo' )"		, 0, 3, 0, .T. })
	AADD(aRotina, {"DANFE"				,"u_ImpDanf()"																, 0, 3, 0, NIL })
	AADD(aRotina, {"Status Sefaz"		,"FWMsgRun(, {|| U_StsSefaz()			}	, 'Aguarde', 'Consultando' )"	, 0, 3, 0, .T. })
	//AADD(aRotina, {"Configurações"		,"FWMsgRun(, {|| U_ParamNF()			}	, 'Aguarde', 'Abrindo' )"		, 0, 3, 0, .T. })
	AADD(aRotina, {"Consulta NF-e"		,"FWMsgRun(, {|| U_ConsNF()				}	, 'Aguarde', 'Abrindo' )"		, 0, 3, 0, .T. })
	AADD(aRotina, {"Inutilização"		,"SpedNFeInut()"															, 0, 2, 0, NIL })
	AADD(aRotina, {"Rel. Cancelamento"	,"FWMsgRun(, {|| U_RFAT002()			}	, 'Aguarde', 'Abrindo' )"		, 0, 3, 0, .T. })

	If Type("aSelFil") <> "U"
		If !Empty(aScan(aSelFil,{|x| x $ "020101/020104"}))
			aadd(aRotina,{'Transf. de Saldo'  ,'U_PRODNEG()' , 0 , 3,0,NIL})
		EndIf
	EndIf

Return( aRotina )


User Function ConsNF()

	SetKey( K_CTRL_C, 	{ || CopytoClipboard( SF2->F2_CHVNFE ), IIF(!EMPTY(SF2->F2_CHVNFE),MsgInfo("Chave da Nota Fiscal Copiada!"),Alert("Nota Fiscal sem Chave!")) })
	SetKey( VK_F10,		{ || FWMsgRun(,{ || U_AtuComis() }, "Aguarde", "Carregando..." )})
	SetKey( VK_F6, 		{ || ConsSef() })
	SetKey( VK_F7, 		{ || InfoNF()  })

	//browse de consulta
	U_CONSSF2()

	SetKey( VK_F6, { || FWMsgRun(,{ || FilSC5() } , "Aguarde", "Filtrando Pedidos" )} )
	SetKey( VK_F7, { || FWMsgRun(,{ || U_HISTPED(.T.) } , "Aguarde", "Buscando Hisórico..." )} )
	SetKey( VK_F10, NIL )
	SetKey( K_CTRL_C, NIL )

Return

Static Function InfoNF()

	Local cGet1 	:= ""
	Local cGet2 	:= ""
	Local cGet3 	:= ""
	Local cGet4 	:= ""
	Local cMultiGe1 := ""
	Local cMultiGe2 := ""
	Local nComis 	:= 0
	Local cObsGer	:= ""
	Local cVend 	:= ""
	Local oGet1
	Local oGet2
	Local oGet3
	Local oGet4
	Local oMultiGe1
	Local oMultiGe2
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5

	Local oDlg

	SetKey( VK_F7, { || NIL })

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	If SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE))
		While !SD2->(EoF()) .AND. SF2->F2_FILIAL == SD2->D2_FILIAL .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE
			//posiciona no pedido
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO))
				nComis := SC5->C5_COMIS1
				cVend  := SC5->C5_VEND1
				cObsGer:= SC5->C5_MENNOTA
				//se encontrar o pedido da nota, sai do loop
				Exit
			EndIf
			SD2->(dbSkip())
		EndDo
	EndIf

	cGet1 := SF2->F2_VOLUME1
	cGet2 := nComis
	cGet3 := SF2->F2_TRANSP + " - " + POSICIONE("SA4",1,XFILIAL("SA4") + SF2->F2_TRANSP,"A4_NOME")
	cGet4 := Alltrim(cVend)+"-"+POSICIONE("SA3",1,xFilial("SA3")+cVend,"A3_NOME")

	cMultiGe1 := MensFis()
	cMultiGe2 := cObsGer

	oDlg := MSDialog():New(000,000,360,450,'Informações Nota Fiscal',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	@ 010, 010 SAY oSay1 PROMPT "Quant. Volumes" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 008, 075 MSGET oGet1 VAR cGet1 SIZE 020, 010 OF oDlg PICTURE PesqPict("SC5","C5_VOLUME1") COLORS 0, 16777215 PIXEL
	oGet1:Disable()
	@ 028, 010 SAY oSay2 PROMPT "Comissão Vendedor" SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 026, 075 MSGET oGet2 VAR cGet2 SIZE 020, 010 OF oDlg PICTURE PesqPict("SC5","C5_COMIS1") COLORS 0, 16777215 PIXEL
	@ 026, 111 MSGET oGet4 VAR cGet4 SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oGet2:Disable()
	oGet4:Disable()
	@ 045, 010 SAY oSay3 PROMPT "Transportadora" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 043, 075 MSGET oGet3 VAR cGet3 SIZE 137, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oGet3:Disable()
	@ 063, 010 SAY oSay4 PROMPT "Observação Fiscal" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 075 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 137, 044 COLORS 0, 16777215 HSCROLL PIXEL
	oMultiGe1:Disable()
	@ 118, 010 SAY oSay5 PROMPT "Observação Geral" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 116, 075 GET oMultiGe2 VAR cMultiGe2 OF oDlg MULTILINE SIZE 137, 044 COLORS 0, 16777215 HSCROLL PIXEL
	oMultiGe2:Disable()

	@ 165, 175 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

	oDlg:Activate(,,,.T.)

	SetKey( VK_F7, { || InfoNF() })
Return

Static Function MensFis()
	Local nX
	Local nY
	Local cTes		:= ""
	Local cRet 		:= ""
	Local cFormula	:= ""
	Local cMensagem	:= ""
	Local aFormula 	:= {}
	Local aTes		:= {}

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	If SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
		While !SD2->(EOF()) 				.AND.;
				SF2->F2_FILIAL 	== SD2->D2_FILIAL 	.AND.;
				SF2->F2_DOC 	== SD2->D2_DOC 		.AND.;
				SF2->F2_SERIE 	== SD2->D2_SERIE 	.AND.;
				SF2->F2_CLIENTE == SD2->D2_CLIENTE 	.AND.;
				SF2->F2_LOJA 	== SD2->D2_LOJA

				If aScan(aTes,{|x| x == SD2->D2_TES}) == 0
				AADD(aTes,SD2->D2_TES)
			EndIf

			SD2->(dbSkip())
		EndDo
	EndIf

	For nX := 1 to Len(aTes)
		IF cTes <> aTes[nX]
			cTes := aTes[nX]
			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4") + cTes))

			cFormula := SF4->F4_XFORMUL

			aFormula := StrTokArr(cFormula,";")

			For nY := 1 to Len(aFormula)
				If !Empty(aFormula[nY])
					cMensagem += Alltrim(Formula(aFormula[nY])) + ';  '
				Endif
			Next nY
		Endif
	Next nX

	cRet := cMensagem

Return cRet


Static Function ConsSef()
	Local oGet1
	Local cGet1
	Local oGet2
	Local cGet2
	Local oGet3
	Local cGet3
	Local oSay1
	Local oSay2
	Local oSay3
	Local oDlg

	SetKey( VK_F6, NIL)

	cGet1 := Space(TamSx3("F2_CHVNFE")[1])
	cGet2 := Space(TamSx3("F3_PROTOC")[1])
	cGet3 := Space(42)

	dbSelectArea("SF3")
	SF3->(dbSetOrder(4))
	If dbSeek(SF2->F2_FILIAL + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC + SF2->F2_SERIE)

		DEFINE MSDIALOG oDlg TITLE "Sefaz" FROM 000, 000  TO 150, 450 COLORS 0, 16777215 PIXEL

		@ 010, 010 SAY oSay1 PROMPT "Chave Nf-e" 	SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 028, 010 SAY oSay2 PROMPT "Protocolo" 	SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 045, 010 SAY oSay3 PROMPT "Situação"		SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

		@ 008, 075 MSGET oGet1 VAR cGet1 SIZE 138, 010 OF oDlg COLORS 0, 16777215 PIXEL
		oGet1:cText := SF3->F3_CHVNFE
		oGet1:Disable()

		@ 026, 075 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
		oGet2:cText := SF3->F3_PROTOC
		oGet2:Disable()

		@ 043, 075 MSGET oGet3 VAR cGet3 SIZE 138, 010 OF oDlg COLORS 0, 16777215 PIXEL
		oGet3:cText := SF3->F3_DESCRET
		oGet3:Disable()

		@ 060, 175 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

	EndIf

	SetKey( VK_F6, { || ConsSef() })

Return

//Atualizar vendedor das NF
User Function AtuComis()
	Local aRet 		:= {}
	Local aPergs 	:= {}
	Local aMvPar	:= {}
	Local lRet		:= .F.
	Local nMv
	Local cVendAtu  := POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")
	Local cVendNov	:= Space(TamSX3("A3_COD")[1])
	Local cNomeNov	:= Space(TamSX3("A3_NOME")[1])
	Local nComisAtu	:= GetComis()
	Local nComisNov := 0

	If VldUser()
		aAdd( aPergs ,{3,"Opções",1,{"Alteração Vendedor","Alteração Comissão"/*,"Zerar Comissão"*/},100,"",.T.})
		aAdd( aPergs ,{9,"Vendedor Atual: "+ALLTRIM(SF2->F2_VEND1)+" - "+cVendAtu,150,7,.T.})
		aAdd( aPergs ,{9,"Comissão Atual: "+cValToChar(nComisAtu)+"%",150,7,.T.})
		aAdd( aPergs ,{1,"Vendedor Novo" 	,cVendNov	,"@!","Vazio() .or. ExistCpo('SA3',MV_PAR04)","SA3",'.T.',30,.F.})
		aAdd( aPergs ,{1,"Nome Compl."		,cNomeNov	,"@!","","",'.F.',70,.F.})
		aAdd( aPergs ,{1,"Comissão Nova"	,nComisNov	,"@E 9,999.99","","",'.T.',50,.F.})

		For nMv := 1 To 40
			aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
		Next nMv

		While .T.
			If ParamBox(aPergs ,"Status Sefaz",aRet,,,,,,,,.F.,.F.)
				If aRet[1] == 1 /*Altera vendedor*/ .and. Empty(aRet[4]) /*Vendedor Novo*/
					MsgAlert("É obrigatório informar o Vendedor.","Atenção")
					//Restaura valor da comissão
				ElseIf aRet[1] == 1 .and. !Empty(aRet[4])
					If MsgYesNo("Deseja alterar o Vendedor da Nota Fiscal?","Atenção")
						lRet := .T.
						Exit
					EndIf
				EndIf
				If aRet[1] == 2 /*Altera comissao*/ .and. Empty(aRet[6]) /*Vendedor Novo*/
					MsgAlert("É obrigatório informar a Comissão.","Atenção")
					//Restaura valor da comissão
				ElseIf aRet[1] == 2 .and. !Empty(aRet[6])
					If MsgYesNo("Deseja alterar a Comissão do Vendedor para esta Nota Fiscal?","Atenção")
						lRet := .T.
						Exit
					EndIf
					/*ElseIf aRet[1] == 3
					If MsgYesNo("Deseja zerar a Comissão do Vendedor para esta Nota Fiscal?","Atenção")
					lRet := .T.
					Exit
					EndIf*/
				EndIf
			Else
				Exit
			EndIf
		EndDo

		If lRet
			If aRet[1] == 1 //Altera vendedor
				//posiciona no item
				dbSelectArea("SD2")
				SD2->(dbSetOrder(3))
				If SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE))
					While !SD2->(EoF()) .AND. SF2->F2_FILIAL == SD2->D2_FILIAL .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE
						//posiciona no pedido
						dbSelectArea("SC5")
						SC5->(dbSetOrder(1))
						If SC5->(dbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO))
							//verifica se o vendedor no pedido é o mesmo
							If SF2->F2_VEND1 == SC5->C5_VEND1
								Reclock("SC5",.F.)
								replace C5_VEND1 with aRet[4]
								SC5->(MsUnlock())
								//se encontrar o pedido da nota, sai do loop
								Exit
							EndIf
						EndIf
						SD2->(dbSkip())
					EndDo
				EndIf

				//Altera cabeçalho nota
				Reclock("SF2",.F.)
				replace F2_VEND1 with aRet[4]
				SF2->(MsUnlock())

			ElseIf aRet[1] == 2 //Altera comissao
				//posiciona no item
				dbSelectArea("SD2")
				SD2->(dbSetOrder(3))
				If SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE))
					While !SD2->(EoF()) .AND. SF2->F2_FILIAL == SD2->D2_FILIAL .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE
						
						Reclock("SD2",.F.)
						If Empty(SD2->D2_XANTCOM)
							replace D2_XANTCOM with SD2->D2_COMIS1
						EndIf
						replace D2_COMIS1  with aRet[6]
						SD2->(MsUnlock())
						
						//posiciona no pedido
						dbSelectArea("SC5")
						SC5->(dbSetOrder(1))
						If SC5->(dbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO)) .AND. C5_COMIS1 <> aRet[6]
							Reclock("SC5",.F.)
							replace C5_COMIS1 with aRet[6]
							SC5->(MsUnlock())
							//se encontrar o pedido da nota, sai do loop
							//Exit
						EndIf
						SD2->(dbSkip())
					EndDo
				EndIf
				//Atualiza comissao da nota		
				U_CalcCom(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE)
				
			EndIf
		EndIf

		//restaura o conteudo dos parametros
		For nMv := 1 To Len( aMvPar )
			&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
		Next nMv
	Else
		MsgAlert("Usuário sem acesso para Alterar Vendedor/Comissão.","Atenção")
	EndIf

Return

Static Function GetComis()
	Local nRet := 0

	cQuery := " SELECT DISTINCT D2_COMIS1 COMIS FROM " + RetSqlName("SD2") 
	cQuery += " WHERE D_E_L_E_T_ = ' '
	cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"'
	cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"' 
	cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'
	cQuery += " AND D2_PEDIDO <> ' '

	TCQUERY cQuery NEW ALIAS "QCOMIS"

	If !QCOMIS->(EOF())
		nRet := QCOMIS->COMIS
	EndIf

	QCOMIS->(dbCloseArea())

Return nRet

//Valida se usuario tem acesso a alteração de vendedor
Static Function VldUser()
	Local lRet := .F.
	Local cUsrs:= SuperGetMV("MV_USRALCO",.T.,"000000")

	If RetCodUsr() $ cUsrs
		lRet := .T.
	EndIf

Return lRet

//Consulta status da sefaz da filial escolhida
User Function StsSefaz()
	Local aPergs := {}
	Local aRet	 := {}
	Local aMvPar := {}
	Local nMv	 := 0
	Local nX	 := 0
	Local cFilDoc := ""

	Private cEmpSel := ""

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	aAdd( aPergs ,{1,"Filial",cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'.T.',30,.T.})   

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If Empty(cFilDoc)
		If ParamBox(aPergs ,"Status Sefaz",aRet,,,,,,,,.F.,.F.)
			//logar na filial correta
			dbSelectArea("SM0") //Abro a SM0
			SM0->(dbSetOrder(1))					
			If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
				//Seto as variaveis de ambiente
				cEmpAnt := SM0->M0_CODIGO
				cFilAnt := SM0->M0_CODFIL
				OpenFile(cEmpAnt + cFilAnt)
			EndIf

			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			SpedNFeStatus()
		EndIf
	Else
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))					
		If SM0->(dbSeek("01" + cFilDoc,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		SpedNFeStatus()
	EndIf

Return

/*
Impressão da DANFE
*/
User Function ImpDanf()
	Local aPergs := {}
	Local aRet	 := {}
	Local aMvPar := {}
	Local nMv	 := 0
	Local nX	 := 0
	Local cFilDoc := Space(TamSX3("F2_FILIAL")[1])

	Private cEmpSel := ""

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	aAdd( aPergs ,{1,"Filial",cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'.T.',30,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If Empty(cFilDoc)
		If ParamBox(aPergs ,"Impressão DANFE",aRet,,,,,,,,.F.,.F.)
			//logar na filial correta
			dbSelectArea("SM0") //Abro a SM0
			SM0->(dbSetOrder(1))
			If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
				//Seto as variaveis de ambiente
				cEmpAnt := SM0->M0_CODIGO
				cFilAnt := SM0->M0_CODFIL
				OpenFile(cEmpAnt + cFilAnt)
			EndIf

			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			SpedDanfe()
		EndIf
	Else
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + cFilDoc,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		SpedDanfe()
	EndIf

Return

User Function ParamNF
	Local aPergs := {}
	Local aRet	 := {}
	Local aMvPar := {}
	Local nMv	 := 0
	Local cFilDoc := Space(TamSX3("F2_FILIAL")[1])

	Private cEmpSel := ""

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	aAdd( aPergs ,{1,"Filial",cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'.T.',30,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If Empty(cFilDoc)
		If ParamBox(aPergs ,"Configurações",aRet,,,,,,,,.F.,.F.)
			//logar na filial correta
			dbSelectArea("SM0") //Abro a SM0
			SM0->(dbSetOrder(1))
			If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
				//Seto as variaveis de ambiente
				cEmpAnt := SM0->M0_CODIGO
				cFilAnt := SM0->M0_CODFIL
				OpenFile(cEmpAnt + cFilAnt)
			EndIf

			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			SpedNFePar()
		EndIf
	Else
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + cFilDoc,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		SpedNFePar()
	EndIf

Return


User Function CancNF(nTipo)
	Local aPergs 	:= {}
	Local aMvPar 	:= {}
	Local nMv	 	:= 0
	Local cDoc		:=  Space(TamSX3("F2_SERIE")[1]) + Space(TamSX3("F2_DOC")[1])

	Private cFilDoc
	Private cEmpSel := ""
	Private aRet	:= {}

	Default nTipo 	:= 1

	//exclui função das teclas de atalho
	SetKey( VK_F5, NIL )
	SetKey( VK_F6, NIL )
	SetKey( VK_F7, NIL )

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	If nTipo == 1 .and. Empty(cFilDoc)
		aAdd( aPergs ,{1,"Filial",cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'.T.',30,.T.})
	ElseIf nTipo == 2
		aAdd( aPergs ,{1,"Serie / Nota Fiscal"	,cDoc	,"@!","","",'.T.',40,.T.})
	EndIf

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If nTipo == 1 .and. !Empty(cFilDoc)
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + cFilDoc,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		MATA521A()
	ElseIf nTipo == 1 .and. Empty(cFilDoc)
		If ParamBox(aPergs ,"Cancelamento Nota Fiscal",aRet,,,,,,,,.F.,.F.)
			//logar na filial correta
			dbSelectArea("SM0") //Abro a SM0
			SM0->(dbSetOrder(1))
			If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
				//Seto as variaveis de ambiente
				cEmpAnt := SM0->M0_CODIGO
				cFilAnt := SM0->M0_CODFIL
				OpenFile(cEmpAnt + cFilAnt)
			EndIf

			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			MATA521A()
		EndIf
	ElseIf nTipo == 2
		If ParamBox(aPergs ,"Cancelamento Nota Fiscal",aRet,,,,,,,,.F.,.F.)
			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			MATA521A()
		EndIf
	EndIf

	SetKey( VK_F5, { || FWMsgRun(,{ || fCriaTemp(@cTmpSC5,@cArqTrb), fLoadTemp(cTmpSC5,cOpFil1,cOpFil2), RefreshBrw(1) }, "Aguarde", "Atualizando Pedidos" )})
	SetKey( VK_F6, { || FWMsgRun(,{ || FilSC5() } , "Aguarde", "Filtrando Pedidos" )} )
	SetKey( VK_F7, { || FWMsgRun(,{ || U_HISTPED(.T.) } , "Aguarde", "Buscando Hisórico..." )} )

Return

Static Function ConsSer(cFilSer)
	Local cRet	 := ""
	Local cQuery := ""

	cQuery := " SELECT X5_CHAVE FROM " + RetSqlName("SX5")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND X5_FILIAL = '"+ cFilSer +"' "
	cQuery += " AND X5_TABELA = 'WZ' "
	cQuery += " AND RTRIM(X5_DESCRI) LIKE '%01%' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSX5")

	If !QSX5->(EOF())
		cRet := PADR(Alltrim(QSX5->X5_CHAVE),3)
	EndIf

	QSX5->(dbCloseArea())

Return cRet

User Function CartCorr()
	Local cAlias := "SF2"
	Local nReg	 := 0
	Local nOpc	 := 3
	Local aPergs := {}
	Local aRet	 := {}
	Local aMvPar := {}
	Local nMv	 := 0
	Local nX
	Local cDoc	 := Space(TamSX3("F2_DOC")[1])
	Local SerSX5

	Private cEmpSel := ""
	Private cFilDoc := ""
	Private cSerie

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	SerSX5 := ConsSer(cFilDoc)
	cSerie := IIF(!Empty(SerSX5),SerSX5,Space(TamSX3("F2_SERIE")[1]))

	aAdd( aPergs ,{1,"Filial"	,cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'Empty(cFilDoc)',30,.T.})
	aAdd( aPergs ,{1,"Serie"	,cSerie	,"@!",".T.","",'Empty(cSerie)',30,.T.})
	aAdd( aPergs ,{1,"Nota"		,cDoc	,"@!",".T.","",'.T.',30,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If ParamBox(aPergs ,"Carta de Correção",aRet,,,,,,,,.F.,.F.)
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		//restaura o conteudo dos parametros
		For nMv := 1 To Len( aMvPar )
			&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
		Next nMv

		dbSelectArea("SF2")
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(xFilial("SF2") + aRet[3] + aRet[2]))
			nReg := SF2->(Recno())

			SpedCCeRemessa(cAlias,nReg,nOpc)

			SpedCCeMnt(cAlias,nReg,nOpc,.F.)
		Else
			MsgAlert("Nota não encontrada não filial informada.","Atenção")
		EndIf
	EndIf

Return


Static Function ChvNfe()
	Local oButton1
	Local aHeader 	:= {}
	Local aCols		:= {}
	Local aPergs	:= {}
	Local aMvPar	:= {}
	Local aRet		:= {}
	Local cNota		:= Space(TamSX3("F2_DOC")[1]) + Space(TamSX3("F2_SERIE")[1])
	Local nMv

	Private oGetD

	aAdd( aPergs ,{1,"Serie / Nota Fiscal"	,cNota	,"@!","","",'.T.',40,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If !ParamBox(aPergs ,"Copiar Chave Nota Fiscal",aRet,,,,,,,,.F.,.F.)
		Return
	EndIf

	dbSelectArea("SF3")
	dbSetOrder(6)
	If SF3->(dbSeek(xFilial("SF3") + SubStr(aRet[1],4,9) + SubStr(aRet[1],1,3) ))
		CopytoClipboard( SF3->F3_CHVNFE )
		If !Empty(SF3->F3_CHVNFE)
			MsgInfo("Chave Copiada.","Atenção")
		Else
			MsgAlert("Nota Fiscal sem Chave.","Atenção")
		EndIf
	EndIf

	For nMv := 1 To Len( aMvPar )
		&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
	Next nMv

Return


User Function MonitNF
	Local aPergs 	:= {}
	Local aRet	 	:= {}
	Local aMvPar 	:= {}
	Local nMv	 	:= 0
	Local dEmissao	:= dDataBase
	Local cDocDe	:= Space(TamSX3("F2_DOC")[1])
	Local cDocAte	:= Space(TamSX3("F2_DOC")[1])
	Local aNota
	Local SerSX5

	Private cEmpSel := ""
	Private cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	Private cSerMoni

	SetKey( VK_F10, { || FWMsgRun(,{ || CodBar() }, "Aguarde", "Carregando Produtos" )})
	SetKey( VK_F11, { || FWMsgRun(,{ || U_CancNF(2) }, "Aguarde", "Carregando Cancelamento" )})
	SetKey( VK_F9,  { || ChvNfe() })

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	SerSX5 := ConsSer(cFilDoc)
	cSerMoni := IIF(!Empty(SerSX5),SerSX5,Space(TamSX3("F2_SERIE")[1]))

	aAdd( aPergs ,{1,"Filial" 	,cFilDoc	,"@!","Vazio() .OR. MV_PAR01 $ cEmpSel","SM0FAT",'empty(cFilDoc)',30,.T.})
	aAdd( aPergs ,{1,"Serie"  	,cSerMoni	,"@!",".T.","",'Empty(cSerMoni)',30,.F.})
	aAdd( aPergs ,{1,"Nota De"  ,cDocDe		,"@!",".T.","",'.T.',30,.F.})
	aAdd( aPergs ,{1,"Nota Ate" ,cDocAte	,"@!",".T.","",'.T.',30,.F.})
	aAdd( aPergs ,{1,"Emissão"	,dEmissao	,"@D","","",'.T.',50,.F.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If ParamBox(aPergs ,"Status NF-e",aRet,,,,,,,,.F.,.F.,,,,,,,,.F.,.F.)
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		//restaura o conteudo dos parametros
		For nMv := 1 To Len( aMvPar )
			&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
		Next nMv

		If Empty(aRet[3]) .OR. Empty(aRet[4])
			aNota := GetNFEmi(aRet[5])

			If !Empty(aNota)
				SpedNFe6Mnt(aRet[2],aNota[1],aNota[2],,,,,,.T.)
			Else
				MsgAlert("Nenhuma nota encontrada na data informada.","Atenção")
				SpedNFe6Mnt()
			EndIf
		Else
			SpedNFe6Mnt(aRet[2],aRet[3],aRet[4],,,,,,.T.)
		EndIf
	EndIf

	SetKey( VK_F10, NIL )
	SetKey( VK_F11, NIL )
	SetKey( VK_F9,  NIL )

Return

Static Function GetNFEmi(dEmis)
	Local aRet := {}
	Local cAlias := GetNextAlias()
	Local cQry

	//Primeira nota do dia
	cQry := " SELECT MIN(F2_DOC) MIN FROM " + RETSQLNAME("SF2")
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND F2_FILIAL = '"+ xFilial("SF2") +"' "
	If !Empty(dEmis)
		cQry += " AND F2_EMISSAO = '"+ DToS(dEmis) +"' "
	EndIf

	cQry := ChangeQuery(cQry)

	If Select(cAlias) > 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), cAlias,.F.,.T.)

	If !Empty((cAlias)->MIN)
		AADD(aRet,(cAlias)->MIN)

		//Ultima nota do dia
		cQry := " SELECT MAX(F2_DOC) MAX FROM " + RETSQLNAME("SF2")
		cQry += " WHERE D_E_L_E_T_ = ' ' "
		cQry += " AND F2_FILIAL = '"+ xFilial("SF2") +"' "
		If !Empty(dEmis)
			cQry += " AND F2_EMISSAO = '"+ DToS(dEmis) +"' "
		EndIf

		cQry := ChangeQuery(cQry)

		If Select(cAlias) > 0
			DbSelectArea(cAlias)
			(cAlias)->(DbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), cAlias,.F.,.T.)

		If !Empty((cAlias)->MAX)
			AADD(aRet,(cAlias)->MAX)
		EndIf

	EndIf

Return aRet

//Exibe codigo de barras dos produtos
Static Function CodBar()
	Local oDlg
	Local oButton1
	Local aHeader 	:= {}
	Local aCols		:= {}
	Local aPergs	:= {}
	Local aMvPar	:= {}
	Local aRet		:= {}
	Local cNota		:= Space(TamSX3("F2_DOC")[1]) + Space(TamSX3("F2_SERIE")[1])
	Local nMv

	Private oGetD

	aAdd( aPergs ,{1,"Serie / Nota Fiscal"	,cNota	,"@!","","",'.T.',40,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If !ParamBox(aPergs ,"Código de Barras",aRet,,,,,,,,.F.,.F.)
		Return
	EndIf

	AADD(aHeader,{"Item"		,"ITEM"	,"",002, 0,,,"C","","R"})
	AADD(aHeader,{"Produto"		,"PROD"	,"",015, 0,,,"C","","R"})
	AADD(aHeader,{"Cód. Barras"	,"BAR"	,"",015, 0,,,"C","","R"})
	AADD(aHeader,{"GTIN"		,"GTIN"	,"",015, 0,,,"C","","R"})

	dbSelectArea("SD2")
	dbSetOrder(3)
	If SD2->(dbSeek(xFilial("SD2") + SubStr(aRet[1],4,9) + SubStr(aRet[1],1,3) ))
		While !SD2->(EOF());
				.AND. SD2->D2_FILIAL == xFilial("SD2");
				.AND. SD2->D2_DOC == SubStr(aRet[1],4,9);
				.AND. SD2->D2_SERIE == SubStr(aRet[1],1,3)

			AADD(aCols,Array(5))
			aCols[Len(aCols)][1] := SD2->D2_ITEM
			aCols[Len(aCols)][2] := SD2->D2_COD
			aCols[Len(aCols)][3] := POSICIONE("SB1",1,xFilial("SB1") + SD2->D2_COD,"B1_CODBAR")
			aCols[Len(aCols)][4] := POSICIONE("SB1",1,xFilial("SB1") + SD2->D2_COD,"B1_CODGTIN")
			aCols[Len(aCols)][5] := .F.

			SD2->(dbSkip())
		EndDo
	EndIf

	ASORT(aCols, , , { | x,y | x[1] < y[1] } )

	DEFINE MSDIALOG oDlg FROM 000,000 TO 350,550 TITLE "Códigos de Barras / GTIN" PIXEL

	oGetD := MsNewGetDados():New(005,005,150,270,,;
		"AllwaysTrue","AllwaysTrue",,{},,999,"AllwaysTrue", "AllwaysTrue",;
		"AllwaysTrue", oDlg, aHeader, aCols)

	oButton1 := TButton():New(155, 005," OK ",oDlg,{|| oDlg:End() }	,037,013,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDlg CENTERED

	For nMv := 1 To Len( aMvPar )
		&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
	Next nMv

Return

User Function TransmNF()
	Local cSerie	:= NIL
	Local cNotaIni	:= NIL
	Local cNotaFim	:= NIL
	Local lRetorno	:= .F.
	Local aPergs := {}
	Local aRet	 := {}
	Local aMvPar := {}
	Local nMv	 := 0
	Local cFilDoc := Space(TamSX3("F2_FILIAL")[1])

	Private bFiltraBrw := {|| }
	Private cEmpSel := ""

	For nX := 1 to Len(aSelFil)
		cEmpSel += aSelFil[nX]
		If nX < Len(aSelFil)
			cEmpSel += '#'
		EndIf
	Next nX

	If Len(Separa(cEmpSel,'#')) == 1
		cFilDoc	:= cEmpSel
	Else
		cFilDoc	:= Space(TamSX3("F2_FILIAL")[1])
	EndIf

	aAdd( aPergs ,{1,"Filial",cFilDoc,"@!","Vazio() .OR. ExistCpo('SM0','01'+MV_PAR01)","SM0FAT",'.T.',30,.T.})

	For nMv := 1 To 40
		aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
	Next nMv

	If Empty(cFilDoc)
		If ParamBox(aPergs ,"Transmissão",aRet,,,,,,,,.F.,.F.)
			//logar na filial correta
			dbSelectArea("SM0") //Abro a SM0
			SM0->(dbSetOrder(1))
			If SM0->(dbSeek("01" + aRet[1],.T.)) //Posiciona Empresa
				//Seto as variaveis de ambiente
				cEmpAnt := SM0->M0_CODIGO
				cFilAnt := SM0->M0_CODFIL
				OpenFile(cEmpAnt + cFilAnt)
			EndIf

			//restaura o conteudo dos parametros
			For nMv := 1 To Len( aMvPar )
				&("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
			Next nMv

			dbSelectArea("SF2")

			//Transmitir
			//oSay:cCaption := ("Transmitindo")
			//ProcessMessages()

			SpedNFeRe2(cSerie,cNotaIni,cNotaFim,,@lRetorno)

			If lRetorno
				//MONITOR
				//oSay:cCaption := ("Monitorando")
				//ProcessMessages()

				SetKey( VK_F10, { || FWMsgRun(,{ || CodBar() }, "Aguarde", "Carregando Produtos" )})
				SetKey( VK_F11, { || FWMsgRun(,{ || U_CancNF(2) }, "Aguarde", "Carregando Cancelamento" )})
				SetKey( VK_F9,  { || ChvNfe() })

				SpedNFe6Mnt(MV_PAR01,MV_PAR02,MV_PAR03,,,,,,.T.,,)

				If SF2->F2_FIMP == 'S' .AND. Empty(SF2->F2_XDTIMP) .AND. !Empty(Getmv("MV_XIMDAN1"))
					//Imprimir danfe e boleto automaticos
					U__ImpDanfe()
				EndIf
				If SF2->F2_FIMP == 'S'
					//Gerar entrada na filial de destino, no caso de tranferência
					GerEntDest()
				EndIf

				SetKey( VK_F10, NIL)
				SetKey( VK_F11, NIL)
				SetKey( VK_F9,  NIL)
			EndIf
		EndIf
	Else
		//logar na filial correta
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + cFilDoc,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf

		dbSelectArea("SF2")

		//Transmitir
		//oSay:cCaption := ("Transmitindo")
		//ProcessMessages()

		SpedNFeRe2(cSerie,cNotaIni,cNotaFim,,@lRetorno)

		If lRetorno
			//MONITOR
			//oSay:cCaption := ("Monitorando")
			//ProcessMessages()

			SetKey( VK_F10, { || FWMsgRun(,{ || CodBar() }, "Aguarde", "Carregando Produtos" )})
			SetKey( VK_F11, { || FWMsgRun(,{ || U_CancNF(2) }, "Aguarde", "Carregando Cancelamento" )})
			SetKey( VK_F9,  { || ChvNfe() })

			SpedNFe6Mnt(MV_PAR01,MV_PAR02,MV_PAR03,,,,,,.T.,,)

			If SF2->F2_FIMP == 'S' .AND. Empty(SF2->F2_XDTIMP) .AND. !Empty(Getmv("MV_XIMDAN1"))
				//Imprimir danfe e boleto automaticos
				U__ImpDanfe()
			Endif
			If SF2->F2_FIMP == 'S'
				//Gerar entrada na filial de destino, no caso de tranferência
				GerEntDest()
			EndIf

			SetKey( VK_F10, nil)
			SetKey( VK_F11, nil)
			SetKey( VK_F9,  nil)
		EndIf
	EndIf

Return

Static Function GerEntDest()
	Local cNota   	:= SF2->F2_DOC
	Local cSerie  	:= SF2->F2_SERIE
	Local _cCliente	:= SF2->F2_CLIENTE
	Local _cLoja	:= SF2->F2_LOJA
	Local _cTipoNF	:= SF2->F2_TIPO
	Local cChave    := SF2->F2_CHVNFE
	Local aCabec	:= {}
	Local _cCond
	Local aItens	:= {}
	Local aLinha	:= {}
	Local _cItem	:= Replicate("0",TAMSX3("D1_ITEM")[1])
	Local _cCGC		:= ""
	Local _cFilOri	:= cFilAnt
	Local aOper		:= {}
	Local cOper
	Local nX

	Private lMsErroAuto := .F.

	If _cTipoNF $ "N/D"
		dbSelectArea("SD2")
		SD2->(dbGoTop())
		SD2->(dbSetOrder(7))//D2_FILIAL, D2_PDV, D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA
		SD2->(dbSeek(xFilial("SD2")+Space(Tamsx3("D2_PDV")[1])+cSerie+cNota+_cCliente+_cLoja))
		While SD2->(!Eof()) .and. xFilial("SD2")+cNota+cSerie+_cCliente+_cLoja == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
			_cTes := SD2->D2_TES
			dbSelectArea("SF4")
			SF4->(dbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+_cTes)) .and. SF4->F4_ESTOQUE == "S" .and. SF4->F4_TRANFIL == "1"
				If Len(aCabec) == 0

					_cCGC := FWSM0Util():GetSM0Data(,cFilAnt,{"M0_CGC"})[1][2]

					_cCGCCli := Posicione("SA1", 1, xFilial("SA1")+_cCliente+_cLoja,"A1_CGC")
					cFilEntra:= U_RetFilCNPJ(_cCGCCli)

					_cForn   := Posicione("SA2", 3, xFilial("SA2")+_cCGC,"A2_COD")
					_cLjForn := Posicione("SA2", 3, xFilial("SA2")+_cCGC,"A2_LOJA")
					_cEst    := Posicione("SA2", 3, xFilial("SA2")+_cCGC,"A2_EST")
					_cCond	 := Posicione("SE4", 1, xFilial("SE4"),"E4_CODIGO")
					// Cabecalho da nota fiscal de entrada
					If !Empty(_cForn)
						aadd(aCabec,{"F1_TIPO"   	,_cTipoNF})
						aadd(aCabec,{"F1_FORMUL" 	,"N"})
						aadd(aCabec,{"F1_DOC"    	,cNota})
						aadd(aCabec,{"F1_SERIE"  	,cSerie})
						aadd(aCabec,{"F1_EMISSAO"	,SD2->D2_EMISSAO})
						aadd(aCabec,{"F1_FORNECE"	,_cForn})
						aadd(aCabec,{"F1_LOJA"   	,_cLjForn})
						aadd(aCabec,{"F1_ESPECIE"	,"SPED"})
						aadd(aCabec,{"F1_COND"		,_cCond})
						aadd(aCabec,{"F1_EST"		,_cEst})
						aadd(aCabec,{"F1_CHVNFE"    ,cChave})
					Endif
				Endif
				aLinha  := {}
				_cItem := Soma1(_cItem)
				aadd(aLinha,{"D1_ITEM"	,_cItem			,Nil})
				aadd(aLinha,{"D1_COD"	,SD2->D2_COD	,Nil})
				aadd(aLinha,{"D1_QUANT"	,SD2->D2_QUANT	,Nil})
				aadd(aLinha,{"D1_VUNIT"	,Round(SD2->D2_PRCVEN,TAMSX3("D2_PRCVEN")[2])	,Nil})
				aadd(aLinha,{"D1_TOTAL"	,SD2->D2_TOTAL	,Nil})
				//*********************************************************
				//Operação Saida x Entrada
				AADD(aOper,{"05","05"})
				AADD(aOper,{"T6","T5"})
				For nX := 1 to Len(aOper)
					If SD2->D2_XOPER == aOper[nX][1]
						cOper := aOper[nX][2]
						Exit
					EndIf
				Next nX
				aadd(aLinha,{"D1_OPER" 	,cOper			,Nil})
				aadd(aLinha,{"D1_LOCAL"	,SD2->D2_LOCAL	,Nil})
				//*********************************************************
				//Dados Origem
				If _cTipoNF == "D"
					aadd(aLinha,{"D1_NFORI"		,SD2->D2_NFORI	,Nil})
					aadd(aLinha,{"D1_SERIORI"	,SD2->D2_SERIORI,Nil})
					aadd(aLinha,{"D1_ITEMORI"	,ConvItem(SD2->D2_ITEMORI),Nil})//Converte o item de '0100' para '9A'
				EndIf
				aadd(aItens,aLinha)
			Else
				If _cTipoNF == "D"
					cCGCFil := POSICIONE("SA2",1,XFILIAL("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A2_CGC")
				Else
					cCGCFil := POSICIONE("SA1",1,XFILIAL("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_CGC")
				EndIf
				If SubStr(cCGCFil,1,8) == '11509676'
					If SF4->F4_ESTOQUE <> "S"
						MsgAlert("Nota/Série "+cNota+"/"+cSerie+" não processada na filial de destino. TES não configurado para atualizar estoque. Campo F4_ESTOQUE.","Atenção")
					ElseIf SF4->F4_TRANFIL <> "1"
						MsgAlert("Nota/Série "+cNota+"/"+cSerie+" não processada na filial de destino. TES não configurado para transferência. Campo F4_TRANFIL.","Atenção")
					EndIf
				EndIf
				
				aItens := {}
				Exit
			Endif
			dbSelectArea("SD2")
			SD2->(dbSkip())
		EndDo
	Endif

	dbSelectArea("SF1")
	SF1->(dbSetorder(1))//F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
	If Len(aCabec) > 0 .and. Len(aItens) > 0
		If !SF1->(dbSeek(cFilEntra + cNota + cSerie + _cForn + _cLjForn + _cTipoNF))
			If !Empty(cFilEntra)

				//Troca a filial para a empresa de destino
				cFilAnt := cFilEntra
				OpenFile(cEmpAnt + cFilAnt)

				If SF4->F4_XGERPNF == '1' //GERA NF CLASSIFICADA
					MATA103(aCabec,aItens,3,.F.)
				Else
					MATA140(aCabec,aItens,3)
				EndIf

				// Checa erro de rotina automatica
				If lMsErroAuto
					Mostraerro()
				Else
					//*********************************************************
					//Italo Maciel - 18/05/2021
					//Impostos
					If _cTipoNF == 'N'
						dbSelectArea("SD2")
						SD2->(dbSetOrder(3))
						SD2->(dbSeek(_cFilOri+cNota+cSerie+_cCliente+_cLoja))
						While SD2->(!Eof()) .and. _cFilOri+cNota+cSerie+_cCliente+_cLoja == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)

							dbSelectArea("SD1")
							SD1->(dbSetOrder(1))
							If SD1->(dbSeek(cFilEntra + cNota + cSerie + _cForn + _cLjForn + SD2->D2_COD))

								RecLock("SD1",.F.)
								SD1->D1_BASEICM := SD2->D2_BASEICM
								SD1->D1_PICM 	:= SD2->D2_PICM
								SD1->D1_VALICM 	:= SD2->D2_VALICM
								SD1->D1_BRICMS 	:= SD2->D2_BRICMS
								SD1->D1_ALIQSOL := SD2->D2_ALIQSOL
								SD1->D1_ICMSRET := SD2->D2_ICMSRET
								SD1->D1_MARGEM 	:= SD2->D2_MARGEM
								SD1->(MsUnlock())
							EndIf

							SD2->(dbSkip())
						EndDo

						dbSelectArea("SF1")
						SF1->(dbSetOrder(1))
						If SF1->(dbSeek(SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_TIPO)))
							RecLock("SF1",.F.)
							SF1->F1_BASEICM := SF2->F2_BASEICM
							SF1->F1_VALICM 	:= SF2->F2_VALICM
							SF1->F1_BRICMS 	:= SF2->F2_BRICMS
							SF1->F1_ICMSRET := SF2->F2_ICMSRET
							SF1->F1_VALBRUT := SF2->F2_VALBRUT
							SF1->(MsUnlock())
						EndIf
					EndIf
					//*********************************************************
					//Inicia JOB do Reprocessamento
					aParam := array(11)
					aParam[1]  := DToC(SF1->F1_DTDIGIT) //Data Inicial
					aParam[2]  := DToC(SF1->F1_DTDIGIT) //Data Final
					aParam[3]  := 1          			//1-Entrada 2-Saída 3-Ambos
					aParam[4]  := SF1->F1_DOC         	//Nota Fiscal Incial
					aParam[5]  := SF1->F1_DOC   		//Nota Fiscal Final
					aParam[6]  := SF1->F1_SERIE         //Série Incial
					aParam[7]  := SF1->F1_SERIE      	//Série Final
					aParam[8]  := SF1->F1_FORNECE       //Cli/For Inicial
					aParam[9]  := SF1->F1_FORNECE   	//Cli/For Final
					aParam[10] := SF1->F1_LOJA         	//Loja Incial
					aParam[11] := SF1->F1_LOJA       	//Loja Final
					StartJob( "U_XMATA930", getenvserver() , .T. , .T.,aParam,cEmpAnt,cFilAnt  )
					//*********************************************************

					If SF4->F4_XGERPNF == '1' //GERA NF CLASSIFICADA
						MsgInfo("Nota gerada na filial de destino.","NOTA FISCAL GERADA")
					Else
						MsgInfo("Pré-Nota gerada na filial de destino.","PRÉ-NOTA GERADA")
					EndIf
				EndIf

				// Atualiza para a filial origem
				cFilant := _cFilOri
				OpenFile(cEmpAnt + cFilAnt)
			Endif
		Else
			MsgAlert("Nota/Série "+cNota+"/"+cSerie+" já existe na filial de destino.","Atenção")
		Endif
	EndIf

Return

User Function XMATA930(lRotAut,aParam,cParam3,cParam4)

	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cParam3,cParam4)

	MATA930(lRotAut,aParam)

Return

Static Function ConvItem(cItemSD2)
	Local cRet := "00"
	Local nItemSD2 := Val(cItemSD2)
	Local nX

	For nX := 1 to nItemSD2
		cRet := Soma1(cRet)
	Next nX

Return cRet

Static Function FilSC5()
	Local aPergs := {}
	Local aRet	 := {}
	Local aList  := fList()

	nOp1 := aScan(aList,{|x| Substr(x,1,2) == Substr(cOpFil1,1,2) })
	nOp2 := aScan(aList,{|x| Substr(x,1,2) == Substr(cOpFil2,1,2) })

	aAdd( aPergs ,{2,"Operação 1",nOp1, aList, 100,".T.",.T.})
	aAdd( aPergs ,{2,"Operação 2",nOp2, aList, 100,".T.",.T.})

	If ParamBox(aPergs ,"Parametros ",aRet,,,,,,,,.F.,.F.)
		If Valtype(aRet[1]) == "N"
			aRet[1] := aList[aRet[1]]
		EndIf

		If Valtype(aRet[2]) == "N"
			aRet[2] := aList[aRet[2]]
		EndIf

		fCriaTemp(@cTmpSC5,@cArqTrb)
		fLoadTemp(cTmpSC5,aRet[1],aRet[2])
		cOpFil1 := aRet[1]
		cOpFil2 := aRet[2]
		RefreshBrw(1)
	EndIf

Return


Static Function fList()
	Local aRet := {}

	AADD(aRet,"")
	//AADD(aRet,"TODOS")

	dbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	If SX5->(dbSeek(xFilial("SX5")+"DJ"))
		While !SX5->(EOF()) .and. Alltrim(SX5->X5_TABELA) == "DJ"
			AADD(aRet,Alltrim(SX5->X5_CHAVE)+"-"+SX5->X5_DESCRI)
			SX5->(dbSkip())
		EndDo
	EndIf

Return aRet


Static Function fCriaTemp(cTmpSC5,cArqTrb)
	//Tamanho das colunas
	Local nTamNum	:= TamSx3("C5_NUM")[1]
	Local nTamEmi	:= TamSx3("C5_EMISSAO")[1]
	Local nTamUf	:= TamSx3("A1_EST")[1]
	//Local nTamCli	:= TamSx3("A1_NOME")[1]
	//Local nTamVnd	:= TamSx3("A3_NOME")[1]
	Local aCampos	:= {}

	//Array contendo os campos da tabela temporária
	AADD(aCampos,{"STATUS" 	, "C" , 01 		, 0})
	AADD(aCampos,{"CANC" 	, "C" , 04 		, 0})
	AADD(aCampos,{"FILIAL" 	, "C" , 6 		, 0})
	AADD(aCampos,{"DESCFIL"	, "C" , 10 		, 0})
	AADD(aCampos,{"OPER" 	, "C" , 15 		, 0})
	AADD(aCampos,{"NUMERO" 	, "C" , nTamNum	, 0})
	AADD(aCampos,{"EMISSAO"	, "D" , nTamEmi	, 0})
	AADD(aCampos,{"UF" 		, "C" , nTamUf	, 0})
	AADD(aCampos,{"CLIENTE" , "C" , 30		, 0})
	AADD(aCampos,{"VENDE"	, "C" , 30		, 0})

	//Antes de criar a tabela, verificar se a mesma já foi aberta
	If (Select(cTmpSC5) <> 0)
		dbSelectArea(cTmpSC5)
		(cTmpSC5)->(dbCloseArea ())
	Endif

	//Criar tabela temporária
	cArqTrb   := CriaTrab(aCampos,.T.)
	//Criar e abrir a tabela
	dbUseArea(.T.,,cArqTrb,cTmpSC5,Nil,.F.)

Return


Static Function MontaCol(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal,lInibe)
	Local aColumn
	Local bData 	:= {||}

	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0

	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	aColumn := {{cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},lInibe,.F.,{}}}

Return aColumn

User Function PrepDoc()
	Local cNumPed		:= " "
	Local aPvlNfs 		:= {}
	Local aTot			:= {}
	Local cSerie 		:= ""
	Local lUsaNewKey	:= TamSX3("F2_SERIE")[1] == 14
	Local cSerieId		:= IIf( lUsaNewKey , SerieNfId("SF2",4,"F2_SERIE",dDataBase,A460Especie(cSerie),cSerie) , cSerie )
	Local cSerDoc    	:= cSerie
	Local cDoc			:= ""
	Local lMostraCtb
	Local lAglutCtb
	Local lCtbOnLine
	Local lCtbCusto
	Local lReajuste
	Local nCalAcrs
	Local nArredPrcLis
	Local lAtuSA7
	Local lECF
	Local cTexto

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek((cTmpSC5)->(SUBSTR(FILIAL,1,6) + NUMERO)))
		If Empty(SC5->C5_NOTA)
			cNumPed := SC5->C5_NUM
		Else
			MsgAlert("Pedido já Faturado.","Atenção")
			//Refaz Browse
			fCriaTemp(@cTmpSC5,@cArqTrb)
			fLoadTemp(cTmpSC5,cOpFil1,cOpFil2)
			RefreshBrw(1)
			Return
		EndIf
	EndIf
	/*
	//Verifica se registro está em uso
	If RecLock("SC5",.F.)
	SC5->(MsUnlock())
	Else
	MsgAlert("Pedido em uso por outro usuário.","Atenção")
	//Refaz Browse
	fCriaTemp(@cTmpSC5,@cArqTrb)
	fLoadTemp(cTmpSC5)
	RefreshBrw(1)
	Return
	EndIf
	*/
	/*
	//Verifica se registro está em uso
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6") + cNumPed))
	While !SC6->(EOF()) .and. SC6->C6_NUM == cNumPed
		If Empty(SC6->C6_NOTA)
			If RecLock("SC6",.F.)
	SC6->(MsUnlock())
			Else
	MsgAlert("Pedido em uso por outro usuário.")
	Return
			EndIf
		Else
	MsgAlert("Pedido já Faturado.","Atenção")
	Return
		EndIf
	SC6->(dbSkip())
	EndDo
	*/
	//logar na filial correta
	dbSelectArea("SM0") //Abro a SM0
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek("01" + (cTmpSC5)->(SUBSTR(FILIAL,1,6)),.T.)) //Posiciona Empresa
		//Seto as variaveis de ambiente
		cEmpAnt := SM0->M0_CODIGO
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt)
	EndIf

	If SC5->(DBRLock(SC5->(Recno())))

		aTot := fConsTot(SC5->C5_NUM)
		If !Empty(aTot)
			cTexto := "O Valor do Pedido (R$ "+cValToChar(aTot[1][1])+"),"+ CHR(13) + CHR(10) +" é diferente do valor que será Faturado (R$ "+cValToChar(aTot[1][2])+") ." + CHR(13) + CHR(10)
			cTexto += "Deseja continuar?"
			If !MsgYesNo(cTexto,"Atenção")
				Return
			EndIf
		EndIf

		//libera pedido
		//fLibPed(cNumPed)

		If Sx5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS"),,,,@cSerieId,dDataBase )
			dbSelectArea("SC9")
			SC9->(DbSetOrder(1))

			dbSelectArea("SC5")
			SC5->(DbSetOrder(1))

			dbSelectArea("SC6")
			SC6->(DbSetOrder(1))

			dbSelectArea("SE4")
			SE4->(DbSetOrder(1))

			dbSelectArea("SB1")
			SB1->(DbSetOrder(1))

			dbSelectArea("SB2")
			SB2->(DbSetOrder(1))

			dbSelectArea("SF4")
			SF4->(DbSetOrder(1))

			SC5->(dbSeek(xFilial("SC5") + cNumPed))
			SC6->(dbSeek(xFilial("SC6") + cNumPed))

			aTeste := {}

			While SC6->(!Eof()) .And. SC6->C6_NUM == cNumPed
				If SC9->(DbSeek(xFilial("SC9")+cNumPed+SC6->C6_ITEM))          //FILIAL+NUMERO+ITEM
					SC5->(DbSeek(xFilial("SC5")+cNumPed))                       //FILIAL+NUMERO
					SC6->(DbSeek(xFilial("SC6")+cNumPed+SC6->C6_ITEM))          //FILIAL+NUMERO+ITEM
					SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))               //CONDICAO DE PGTO
					SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))               //FILIAL+PRODUTO
					SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)) //FILIAL+PRODUTO+LOCAL
					SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))                   //FILIAL+CODIGO

					aAdd(aPvlNfs,{  cNumPed,;              //Numero Pedido
					SC9->C9_ITEM/*SC6->C6_ITEM*/,;         //Item
					SC9->C9_SEQUEN/*SC6->C6_ITEM*/,;         //Sequencia
					SC9->C9_QTDLIB,;      //Qtd Liberada
					SC6->C6_PRCVEN,;       //preco de Venda
					SC6->C6_PRODUTO,.f.,;  //Produto
					SC9->(RecNo()),;
						SC5->(RecNo()),;
						SC6->(RecNo()),;
						SE4->(RecNo()),;
						SB1->(RecNo()),;
						SB2->(RecNo()),;
						SF4->(RecNo())})
				EndIf
				SC6->(DbSkip())
			EndDo

			cSerDoc    	:= cSerie
			lMostraCtb 	:= .f.
			lAglutCtb  	:= .f.
			lCtbOnLine 	:= .f.
			lCtbCusto  	:= .t.
			lReajuste  	:= .f.
			nCalAcrs   	:= 0
			nArredPrcLis:= 0
			lAtuSA7    	:= .f.
			lECF       	:= .f.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Prepara os parametros para emissao da nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MV_PAR01 := 2           // Mostra Lan‡.Contab ?  Sim/Nao
			MV_PAR02 := 2           // Aglut. Lan‡amentos ?  Sim/Nao
			MV_PAR03 := 2           // Lan‡.Contab.On-Line?  Sim/Nao
			MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
			MV_PAR05 := 2           // Reaj. na mesma N.F.?  Sim/Nao
			MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
			MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
			MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
			MV_PAR09 := Space(04)   // Agreg. liberac. de ?  Caracter
			MV_PAR10 := Space(04)   // Agreg. liberac. ate?  Caracter
			MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
			MV_PAR12 := 0           // Valor Minimo p/fatu?
			MV_PAR13 := Space(06)   // Transportadora de  ?
			MV_PAR14 := "ZZZZZZ"    // Transportadora ate ?
			MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
			MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal
			MV_PAR17 := 1
			MV_PAR18 := 2
			MV_PAR19 := 2		//GERA TITULO ICMS PROPRIO
			MV_PAR20 := 2
			MV_PAR21 := dDatabase
			MV_PAR22 := 2
			MV_PAR23 := 2
			MV_PAR24 := 1		//GERA PARA O DESTINO
			MV_PAR25 := 1		//GERA FECOEP

			lMostraCtb  := MV_PAR01 == 1
			lAglutCtb   := MV_PAR02 == 1
			lCtbOnLine  := MV_PAR03 == 1
			lCtbCusto   := MV_PAR04 == 1
			lReajuste   := MV_PAR05 == 1

			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek((cTmpSC5)->(SUBSTR(FILIAL,1,6) + NUMERO)))
				If Empty(SC5->C5_NOTA)
					cNumPed := SC5->C5_NUM
				Else
					MsgAlert("Pedido já Faturado.","Atenção")

					//Refaz Browse
					fCriaTemp(@cTmpSC5,@cArqTrb)
					fLoadTemp(cTmpSC5,cOpFil1,cOpFil2)
					RefreshBrw(1)

					Return
				EndIf
			EndIf

			//Fatura nota
			cDoc := MaPvlNfs(aPvlNfs,cSerDoc,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)

			SC5->(dbGoTop())

			If cDoc == SF2->F2_DOC .AND. cSerDoc == SF2->F2_SERIE
				//TRANSMISSAO
				AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

				//logar na filial correta
				dbSelectArea("SM0") //Abro a SM0
				SM0->(dbSetOrder(1))
				If SM0->(dbSeek("01" + SF2->F2_FILIAL,.T.)) //Posiciona Empresa
					//Seto as variaveis de ambiente
					cEmpAnt := SM0->M0_CODIGO
					cFilAnt := SM0->M0_CODFIL
					OpenFile(cEmpAnt + cFilAnt)
				EndIf

				//MONITOR
				SetKey( VK_F10, { || FWMsgRun(,{ || CodBar() }, "Aguarde", "Carregando Produtos" )})
				SetKey( VK_F11, { || FWMsgRun(,{ || U_CancNF(2) }, "Aguarde", "Carregando Cancelamento" )})
				SetKey( VK_F9,  { || ChvNfe() })

				SpedNFe6Mnt(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC,,,,,,.T.,,,) //Incluido mais um parametro no monitoramento da NFE

				If SF2->F2_FIMP == 'S' .AND. Empty(SF2->F2_XDTIMP) .AND. !Empty(Getmv("MV_XIMDAN1"))
					//Imprimir danfe e boleto automaticos
					U__ImpDanfe()
				EndIf
				If SF2->F2_FIMP == 'S'
					//Gerar entrada na filial de destino, no caso de tranferência
					GerEntDest()
				EndIf

				//Tratamento para saber se a NF foi emitida para gerar os aquivos integração das Transportadoras.
				IF ! Empty(SF2->F2_DAUTNFE) .AND. ! Empty(SF2->F2_HAUTNFE)
					u_IntTransp(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CHVNFE)
				ENDIF

				SetKey( VK_F10, NIL)
				SetKey( VK_F11, NIL)
				SetKey( VK_F9,  NIL)
				/*
				While .T.
					If Alltrim(SF2->F2_FIMP) $ "D#N"
						Exit //Caso seja denegado ou não autorizado, sai do loop
					ElseIf Alltrim(SF2->F2_FIMP) == "S"
						//Montagem e envio do XML
						U_XMLEnv()
						Exit
					EndIf
				EndDo
				*/
				//Refaz Browse
				//fCriaTemp(@cTmpSC5,@cArqTrb)
				//fLoadTemp(cTmpSC5,cOpFil1,cOpFil2)
				//RefreshBrw(1)
			EndIf

		EndIf
	Else
		MsgAlert("Pedido bloqueado por outro Usuário","Atenção")
	EndIf

Return

User Function _ImpDanfe()

	local cFilePrint := "DANFE_"+Dtos(MSDate())+StrTran(Time(),":","")
	local cCaminho := Getmv("MV_XIMDAN1")

	oDanfe := FwMsPrinter():New(cFilePrint,IMP_SPOOL,.F.,,.T.,,,cCaminho)
	oDanfe:SetPortrait() // DEFINE IMPRESSAO RETRATO
	//oDanfe:SetPaperSize(9)  // Papel A4
	oDanfe:SetResolution(78)
	oDanfe:SetPaperSize(DMPAPER_A4)
	oDanfe:cPrinter := cCaminho
	oDanfe:SetMargin(60,60,60,60)

	u_zGerDanfe(SF2->F2_DOC,SF2->F2_SERIE, '\spool\',Alltrim(cCaminho),SF2->F2_FILIAL,oDanfe,cFilePrint)

Return

Static Function fLoadTemp(cAlias,cOper1,cOper2)
	Local cQSC5 := GetNextAlias()
	Local cQry	:= ""
	Local cClie	:= ""
	Local cUF	:= ""
	Local cVend	:= ""
	Local cFil  := ""
	Local nX

	DEFAULT cOper1 := ""
	DEFAULT cOper2 := ""
	/*
	cQry := " SELECT C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_VEND1, C5_XSITUA, C5_XOPER" 
	cQry += " FROM " + RetSqlName("SC5")
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND C5_NOTA = ' ' "
	//FILTRA OPERAÇÕES LEVADAS PARA O BROWSE
	If !Empty(cOper1)// .and. cOper1 <> 'TODOS'
		cQry += " AND (C5_XOPER = '"+ SubStr(cOper1,1,2) +"' "
	EndIf
	If !Empty(cOper1) .AND. !Empty(cOper2)
		cQry += " OR "
	EndIf
	If !Empty(cOper2)// .and. cOper2 <> 'TODOS'
		cQry += " C5_XOPER = '"+ SubStr(cOper2,1,2) +"') "
	ElseIf !Empty(cOper1)
		cQry += ") "
	EndIf
	If !Empty(aSelFil)
		cQry += " AND C5_FILIAL IN ('" + aSelFil[1] + "'"
		For nX := 2 to Len(aSelFil)
			cQry += ",'" + aSelFil[nX] + "'"
		Next nX
		cQry += ")"
	EndIf
	cQry += " AND (SELECT COUNT(C6_NOTA) FROM " + RetSqlName("SC6") + " B WHERE B.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6_NOTA <> ' ') = 0 "
	cQry += " ORDER BY C5_EMISSAO DESC,C5_FILIAL "
	*/
	cQry := " SELECT C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_VEND1, C5_XSITUA, C5_XOPER, C5_XSTATUS
	cQry += " FROM " + RetSqlName("SC5") + " A "
	cQry += " INNER JOIN " + RetSqlName("SC9") + " B ON C5_FILIAL = C9_FILIAL AND C9_PEDIDO = C5_NUM AND B.D_E_L_E_T_ = ' '
	cQry += " WHERE A.D_E_L_E_T_ = ' '
	//FILTRA OPERAÇÕES LEVADAS PARA O BROWSE
	If !Empty(cOper1)// .and. cOper1 <> 'TODOS'
		cQry += " AND (C5_XOPER = '"+ SubStr(cOper1,1,2) +"' "
	EndIf
	If !Empty(cOper1) .AND. !Empty(cOper2)
		cQry += " OR "
	EndIf
	If !Empty(cOper2)// .and. cOper2 <> 'TODOS'
		cQry += " C5_XOPER = '"+ SubStr(cOper2,1,2) +"') "
	ElseIf !Empty(cOper1)
		cQry += ") "
	EndIf
	//FILTRA FILIAIS
	If !Empty(aSelFil)
		cQry += " AND C5_FILIAL IN ('" + aSelFil[1] + "'"
		For nX := 2 to Len(aSelFil)
			cQry += ",'" + aSelFil[nX] + "'"
		Next nX
		cQry += ")"
	EndIf
	cQry += " AND C5_NOTA = ' '
	cQry += " AND C5_VOLUME1 <> 0
	cQry += " AND C9_BLCRED = ' '
	cQry += " AND C9_BLEST = ' '
	cQry += " AND C9_NFISCAL = ' '
	cQry += " AND (CASE WHEN C5_XIMPORT IN ('PRODNEG','RETGARAN','RETDEVOL') OR C9_BLWMS = ' ' THEN '05' ELSE C9_BLWMS END) = '05'
	//cQry += " AND C9_BLWMS = '05'
	//cQry += " AND (SELECT COUNT(C6_NOTA) FROM " + RetSqlName("SC6") + " B WHERE B.D_E_L_E_T_ = ' ' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6_NOTA <> ' ') = 0
	cQry += " GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_VEND1, C5_XSITUA, C5_XOPER, C5_XSTATUS
	cQry += " ORDER BY C5_EMISSAO DESC,C5_FILIAL

	cQry := ChangeQuery(cQry)

	If Select(cQSC5) > 0
		DbSelectArea(cQSC5)
		(cQSC5)->(DbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), cQSC5,.F.,.T.)

	While !(cQSC5)->(EOF())
		cClie	:= ""
		cUF		:= ""
		cVend 	:= ""
		cFil  	:= ""

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+(cQSC5)->(C5_CLIENTE+C5_LOJACLI)))
			cClie 	:= SA1->A1_NOME
			cUF		:= SA1->A1_EST
		EndIf

		dbSelectArea("SA3")
		SA3->(dbSetOrder(1))
		If SA3->(dbSeek(xFilial("SA3")+(cQSC5)->(C5_VEND1)))
			cVend := SA3->A3_NOME
		EndIf

		dbSelectArea("SM0")
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + (cQSC5)->C5_FILIAL))
			cFil := SM0->M0_FILIAL
		EndIf

		RecLock(cAlias,.T.)
		Replace STATUS  With (cQSC5)->C5_XSTATUS
		Replace CANC	With IIF((cQSC5)->C5_XSITUA == 'C',"CANC"," ")
		Replace FILIAL	With (cQSC5)->C5_FILIAL
		Replace DESCFIL	With cFil
		Replace OPER	With fSX5((cQSC5)->C5_XOPER)
		Replace NUMERO	With (cQSC5)->C5_NUM
		Replace EMISSAO	With StoD((cQSC5)->C5_EMISSAO)
		Replace UF 		With cUF
		Replace CLIENTE	With cClie
		Replace VENDE	With Alltrim((cQSC5)->(C5_VEND1))+' - '+cVend
		(cAlias)->(MsUnlock())

		(cQSC5)->(DbSkip())
	EndDo

	(cQSC5)->(DbCloseArea())

Return

Static Function fSX5(cOper)
	Local aArea := GetArea()
	Local cRet 	:= ""

	If !Empty(cOper)
		dbSelectArea("SX5")
		SX5->(dbSetOrder(1))
		If SX5->(dbSeek(xFilial("SX5") + "DJ" + cOper))
			cRet := SX5->X5_DESCRI
		EndIf
	EndIf

	RestArea(aArea)
Return cRet


User Function VisPed()
	Private cAlias 	:= "SC5"
	Private nOpc 	:= 2
	Private nReg

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek((cTmpSC5)->(SUBSTR(FILIAL,1,6) + NUMERO)))
		nReg := SC5->(Recno())
		//Rotina de visualização padrão
		A410Visual(cAlias,nReg,nOpc)
	EndIf

Return

User Function EXCPED()
	Local lRet		:= .T.
	Local nReg
	Local cAlias	:= "SC5"
	Local nOpc		:= 5
	Local nVlrCred

	Private cCadastro	:= "Exclusão Pedido de Venda"
	Private c460Cond  	:= ""

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	If (cAlias)->(dbSeek((cTmpSC5)->(SUBSTR(FILIAL,1,6) + NUMERO)))
		nReg := (cAlias)->(Recno())
	EndIf

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	If SC9->(dbSeek(xFilial("SC9") + SC5->C5_NUM ))
		While ! SC9->(EOF()) .AND. SC9->C9_FILIAL == SC5->C5_FILIAL .AND. SC9->C9_PEDIDO == SC5->C5_NUM

			nVlrCred := 0

			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM + SC9->C9_ITEM + SC9->C9_PRODUTO))

			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC9->C9_PRODUTO))

			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			SB2->(MsSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL))

			//Executa estorno do item
			lRet := IIF(!A460Estorna(,,@nVlrCred),.F.,lRet)
			SC9->(dbSkip())
		EndDo
	EndIf

	//Deleta se estornou
	If lRet
		A410Deleta(cAlias,nReg,nOpc)
	EndIf

Return

Static Function VisuCli

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI))
		A030Visual("SA1",SA1->(Recno()),2)
	EndIf

Return


User Function ALTSC5()
	Local nReg
	Local nOpc		:= 4
	Local cAlias	:= "SC5"
	Local aMyEncho	:= {"C5_NUM","C5_CLIENTE","C5_TRANSP","C5_TPFRETE","C5_MENNOTA","C5_FRETE"}
	Local aAltEnch 	:= {"C5_TRANSP","C5_TPFRETE","C5_FRETE"}
	Local nOpca

	Private cCadastro := "Pedido de Venda"
	Private aRotina := {{},{"Visualiza"	,"AxVisual"	, 0, 2, 0, .T. },{},{"Alterar"	,"AxAltera"	, 0, 4, 0, .T. }}

	//SetKey( VK_F8, { || FWMsgRun(,{ || ConPad1(,,,"SA1",,,.F.,,,M->C5_CLIENTE) }, "Aguarde", "Consultando Clientes" )})
	SetKey( VK_F8, { || FWMsgRun(,{ || VisuCli() }, "Aguarde", "Consultando Clientes" )})
	SetKey( VK_F5, NIL )
	SetKey( VK_F6, NIL )

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	If (cAlias)->(dbSeek(SUBSTR((cTmpSC5)->FILIAL,1,6) + (cTmpSC5)->NUMERO))
		nReg := (cAlias)->(Recno())
	EndIf

	//logar na filial correta
	dbSelectArea("SM0") //Abro a SM0
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek("01" + SUBSTR((cTmpSC5)->FILIAL,1,6),.T.)) //Posiciona Empresa
		//Seto as variaveis de ambiente
		cEmpAnt := SM0->M0_CODIGO
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt)
	EndIf

	If SC5->(DBRLock(nReg))

		//Valida se cliente possui email
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek( xFilial("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
		If Empty(SA1->A1_EMAIL)
			Alert("O XML não será enviado, pois o cliente não possui email cadastrado.","Atenção")
		EndIf

		nOpca := U_ALTPED(cAlias,nReg,nOpc)

		lFaturou := .F.
		If nOpca == 1
			If MsgNoYes("Deseja faturar o Pedido atual?","Atenção")
				U_PrepDoc()
				lFaturou := .T.
			Else
				fCriaTemp(@cTmpSC5,@cArqTrb)
				fLoadTemp(cTmpSC5,cOpFil1,cOpFil2)
				RefreshBrw(1)
			EndIf
		EndIf
		RefreshBrw(1)

		// Desbloqueia o registro
		SC5->(DBRUnlock(nReg))
	Else
		MsgAlert("Pedido bloqueado por outro Usuário","Atenção")
	EndIf

	SetKey( VK_F8, Nil)
	SetKey( VK_F5, { || FWMsgRun(,{ || fCriaTemp(@cTmpSC5,@cArqTrb), fLoadTemp(cTmpSC5,cOpFil1,cOpFil2), RefreshBrw(1) }, "Aguarde", "Atualizando Pedidos" )})
	SetKey( VK_F6, { || FWMsgRun(,{ || FilSC5() }, "Aguarde", "Filtrando Pedidos" )})

Return


Static Function fLibPed(cNumPed)
	conout("Thread "+cValToChar(ThreadID())+" -- > "+"Liberacao do pedido " + cNumPed)

	//Exclui sujeira da SC9
	dbSelectArea("SC9")
	dbSetOrder(1)
	SC9->(dbSeek(xFilial("SC9")+cNumPed))

	While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cNumPed
		Reclock("SC9",.f.)
		SC9->(dbDelete())
		SC9->(MsUnlock())
		SC9->(dbSkip())

		conout("Thread "+cValToChar(ThreadID())+" -- > "+"Excluindo sujeira da SC9 - Pedido " + cNumPed)
	EndDo

	dbSelectArea("SC6")
	dbSetOrder(1)
	SC6->(dbSeek(xFilial("SC6")+cNumPed))

	While SC6->(!EOF()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cNumPed

		conout("Thread "+cValToChar(ThreadID())+" -- > "+"Liberando Pedido " + SC6->C6_NUM + " - Recno "+cValToChar(SC6->(RecNo())))

		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.F.,)

		//Força liberação de credito e estoque
		Reclock("SC9",.f.)
		Replace SC9->C9_BLEST  With space(2)
		Replace SC9->C9_BLCRED With space(2)
		SC9->(MsUnlock())

		SC6->(dbSkip())
	EndDo

	//***********************************************
	//Libera pedidos do bloqueio de credito e estoque
	//***********************************************
	cQuery:="UPDATE "+RetSqlName("SC9")+"  "
	cQuery+="SET C9_BLEST = '"+space(2)+"', C9_BLCRED = '"+space(2)+"' "
	cQuery+="WHERE C9_PEDIDO = '"+cNumPed+"' "

	TCSqlExec(cQuery)
	TCSqlExec("COMMIT")

	//***********************************************
	//Atualiza status do Pedido de Vendas
	//***********************************************
	dbSelectArea("SC5")
	dbSetOrder(1)
	If SC5->(dbSeek(xFilial("SC5")+cNumPed))
		RecLock("SC5",.F.)
		Replace SC5->C5_LIBEROK With "S"
		SC5->(MsUnlock())
	EndIf

Return

Static Function fConsTot(cPedido)
	Local aRet := {}
	Local cQry

	cQry := " SELECT "
	cQry += " SUM(C9_PRCVEN * C9_QTDLIB) TOTSC9,
	cQry += " SUM(C6_PRCVEN * C6_QTDVEN) TOTSC6
	cQry += " FROM "+RetSqlName("SC6")+" A
	cQry += " LEFT JOIN "+RetSqlName("SC9")+" B
	cQry += " 	ON B.D_E_L_E_T_ = ' ' AND C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9_ITEM = C6_ITEM AND C9_NFISCAL = ' '
	cQry += " WHERE A.D_E_L_E_T_ = ' '
	cQry += " AND C6_FILIAL = '"+ xFilial("SC6") +"'
	cQry += " AND C6_NUM = '"+ cPedido +"'

	cQry := ChangeQuery(cQry)

	If Select("QSC9") > 0
		DbSelectArea("QSC9")
		QSC9->(DbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry), "QSC9",.F.,.T.)

	If !QSC9->(EOF())
		If QSC9->TOTSC9 <> QSC9->TOTSC6
			AADD(aRet,{QSC9->TOTSC6,QSC9->TOTSC9})
		EndIf
	EndIf

Return aRet
