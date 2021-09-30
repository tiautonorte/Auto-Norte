#INCLUDE "EB_M140.CH"
#include 'protheus.ch'
#Include "RWMAKE.CH"
#Include "TBICONN.CH"
#Include "TOPCONN.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"

#DEFINE VALMERC			01	// Valor total do mercadoria
#DEFINE VALDESC			02	// Valor total do desconto
#DEFINE TOTPED	    	03	// Total do Pedido
#DEFINE FRETE    	 	04 // Valor total do Frete
#DEFINE VALDESP   		05	// Valor total da despesa
#DEFINE SEGURO	    	07	// Valor total do seguro
#DEFINE TOTVS_COLAB_ONDEMAND 3100 // TOTVS Colaboracao


Static aPedC := {}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA140  ³ Autor ³ Edson Maricate        ³ Data ³ 24.01.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitacao das Notas Fiscais de Entrada sem os dados Fiscais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa     MATA140.PRW  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³ Marcos V. Ferreira       ³ 11/04/2006 - Bops: 00000096840    ³±±
±±³      02  ³ Marcos V. Ferreira       ³ 19/12/2005					    ³±±
±±³      03  ³ Marcos V. Ferreira       ³ 11/04/2006 - Bops: 00000096840    ³±±
±±³      04  ³ Flavio Luiz Vicco        ³ 04/01/2006                        ³±±
±±³      05  ³ Nereu Humberto Junior    ³ 16/03/2006                        ³±±
±±³      06  ³ Nereu Humberto Junior    ³ 16/03/2006                        ³±±
±±³      07  ³ Flavio Luiz Vicco        ³ 04/01/2006                        ³±±
±±³      08  ³ Ricardo Berti            ³ 07/02/2006                        ³±±
±±³      09  ³ Ricardo Berti            ³ 07/02/2006                        ³±±
±±³      10  ³ Marcos V. Ferreira       ³ 19/12/2005					    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EB_M140(xAutoCab,xAutoItens,nOpcAuto,lSimulaca,nTelaAuto,_cTPXML)

	Local aRotADic  := {}

	Local aCores    := {	{ 'Empty(PB0_STATUS)','BR_AMARELO' 	},;// NF Nao Classificada
	{ 'PB0_STATUS=="1"'	 ,'BR_LARANJA'	},;// Preparada p/ Pre Nota
	{ 'PB0_STATUS=="2"'	 ,'DISABLE'		},;	// Gerada Pre Nota
	{ 'PB0_STATUS=="3"'	 ,'BR_VIOLETA'	}}	// Pre Nota Manual

	Local cFiltraPB0    := ""
	Local nX,nAutoPC	:= 0
	Local aCoresUsr

	PRIVATE aRotina 	:= MenuDef(_cTPXML)
	PRIVATE cCadastro	:= OemToAnsi("Importação XML")
	PRIVATE l140Auto	:= ( ValType(xAutoCab) == "A"  .And. ValType(xAutoItens) == "A" )
	PRIVATE aAutoCab	:= xAutoCab
	PRIVATE aAutoItens	:= xAutoItens
	PRIVATE aHeadPB1    := {}
	PRIVATE l103Auto	:= l140Auto
	PRIVATE lOnUpdate	:= .T.
	PRIVATE nMostraTela := 0 // 0 - Nao mostra tela 1 - Mostra tela e valida tudo 2 - Mostra tela e valida so cabecalho
//PRIVATE a140Total := {0,0,0}
	PRIVATE a140Total	:= {0,0,0,0,0,0,0,0,0}
	PRIVATE a140Desp    := {0,0,0,0,0,0,0,0,0}

	DEFAULT nOpcAuto	:= 3
	DEFAULT lSimulaca	:= .F.
	DEFAULT nTelaAuto   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta Help para criar novo help da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaHelp()

	If l140Auto
		For nX:= 1 To Len(xAutoItens)
			If (nAutoPC := Ascan(xAutoItens[nx],{|x| x[1]== "PB1_PEDIDO"})) > 0
				If Empty(xAutoItens[nX][nAutoPC][3])
					xAutoItens[nX][nAutoPC][3]:= "vazio().or. A103PC()"
				EndIf
			EndIf
		Next
	EndIf

	SetKey( VK_F5, { || u_AtuXML(.F.) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AMIIn(2,4,11,12,14,17,39,41,42,97,17,44,67,69,72)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F12 para ativar parametros de lancamentos contab.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l140Auto
			lOnUpdate  := !lSimulaca
			nMostraTela:= nTelaAuto
			aAutoCab   := xAutoCab
			aAutoItens := xAutoItens

			If nOpcAuto == 7
				aRotBack 	  := aClone(aRotina)
				aRotina[5][2] := aRotBack[7][2]
				nOpcAuto	  := 5
			EndIf
			MBrowseAuto( nOpcAuto, AClone( aAutoCab ), "PB0" )
			xAutoCab   := aAutoCab
			xAutoItens := aAutoItens
		Else
			mBrowse(6,1,22,75,"PB0",,,,,,aCores,,,,,,,,)
		EndIf
	EndIf

	SetKey( VK_F5,{ || Nil } )
	SetKey( VK_F6,{ || Nil } )
	SetKey( VK_F7,{ || Nil } )
	SetKey( VK_F8,{ || Nil } )
Return


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³A140NFisca³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Interface do pre-documento de entrada                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpL1: Alias do arquivo                                      ³±±
	±±³          ³ExpN2: Numero do Registro                                    ³±±
	±±³          ³ExpN3: Opcao selecionada no arotina                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo controlar a interface de um    ³±±
	±±³          ³pre-documento de entrada                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function E140NFISCAL(cAlias,nReg,nOpcX)
	Local nAcho     := 0
	Local aRecPB1   := {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosGet	:= {}
	Local aPosObj	:= {}
	Local aStruPB1  := {}
	Local aListBox  := {}
	Local aCamposPE := {}
	Local aNoFields := {}
	Local aRecOrdPB1:= {}
	Local aTitles   := {OemToAnsi(STR0038), STR0008, STR0034} //"Fornecedor/Cliente" ### "Descontos/Frete/Despesas" //"Totais"
	Local aFldCBAtu := Array(Len(aTitles))
	Local aInfForn	:= {"","",CTOD("  /  /  "),CTOD("  /  /  "),"","","",""}
	Local aInfXML	:= {"",CTOD("  /  /  "),"","",""}
	Local aInfCar	:= {"",""}
	Local aSizeAut  := {}
	Local aButtons	:= {}
	Local aListCpo 	:= {	"PB1_COD"	,;
		"PB1_UM"	,;
		"PB1_PRDFOR",;
		"PB1_DSCFOR",;
		"PB1_QUANT"	,;
		"PB1_VUNIT"	,;
		"PB1_TOTAL"	,;
		"PB1_LOCAL"	,;
		"PB1_SEGUM"	,;
		"PB1_QTSEGU",;
		"PB1_CC"	,;
		"PB1_CONTA"	,;
		"PB1_ITEMCT",;
		"PB1_CLVL"	,;
		"PB1_ITEM"	,;
		"PB1_LOTECT",;
		"PB1_NUMLOT",;
		"PB1_DTVALI",;
		"PB1_LOTEFO",;
		"PB1_DESC"	,;
		"PB1_VALDES",;
		"PB1_OP"	,;
		"PB1_CODGRP",;
		"PB1_CODITE",;
		"PB1_VALIPI",;
		"PB1_VALICM",;
		"PB1_TES"	,;
		"PB1_CF"	,;
		"PB1_IPI"	,;
		"PB1_PICM"	,;
		"PB1_TP"	,;
		"PB1_BASEIC",;
		"PB1_BASEIP",;
		"PB1_TEC"	,;
		"PB1_CONHEC",;
		"PB1_TIPO_N",;
		"PB1_NFORI"	,;
		"PB1_SERIOR",;
		"PB1_ITEMOR",;
		"PB1_VLIMP1",;
		"PB1_VLIMP2",;
		"PB1_VLIMP3",;
		"PB1_VLIMP4",;
		"PB1_VLIMP5",;
		"PB1_VLIMP6",;
		"PB1_BSIMP1",;
		"PB1_BSIMP2",;
		"PB1_BSIMP3",;
		"PB1_BSIMP4",;
		"PB1_BSIMP5",;
		"PB1_BSIMP6",;
		"PB1_ALQIP1",;
		"PB1_ALQIP2",;
		"PB1_ALQIP3",;
		"PB1_ALQIP4",;
		"PB1_ALQIP5",;
		"PB1_ALQIP6",;
		"PB1_VALFRE",;
		"PB1_SEGURO",;
		"PB1_DESPES",;
		"PB1_FORMUL",;
		"PB1_CLASFI",;
		"PB1_II"	,;
		"PB1_ICMSDI"}
//"PB1_PEDIDO",;
//"PB1_ITEMPC",;

	Local l140Inclui := .F.
	Local l140Altera := .F.
	Local l140Exclui := .F.
	Local l140Visual := .F.
	Local lContinua  := .T.
	Local lQuery     := .F.
	Local lItPB1Ord  := .F.
	Local lConsMedic := .F.
	Local lExistMemo := .F.
	Local lIntACD	 := SuperGetMV("MV_INTACD",.F.,"0") == "1"

	Local oSize 	:= nil

	Local cAliasPB1  := "PB1"
	Local nX         := 0
	Local nY         := 0
	Local nPosPC	 := 0
	Local nPosGetLoja:= IIF(TamSX3("A2_COD")[1]< 10,(2.5*TamSX3("A2_COD")[1])+(110),(2.8*TamSX3("A2_COD")[1])+(100))
	Local nOpcA		 := 0
	Local nQtdConf   := 0
	Local bWhilePB1  := {||.T.}
	Local bCabOk     := {||.T.}
	Local oDlg
	Local oFolder
	Local oEnable    := LoadBitmap( GetResources(), "ENABLE" )
	Local oDisable   := LoadBitmap( GetResources(), "DISABLE" )
	Local oStatCon
	Local oConf
	Local oTimer
	Local aPosDel    := {}
	Local dDataFec   := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
	Local aDados	 := {}

// Para Ativar a Aba: Informações Danfe, é necessário executar: UPDCOM05 e UPDCOM07 //
	Local lNfeDanfe     := PB0->(FieldPos("PB0_ESPEC1") > 0)   .And.;
		PB0->(FieldPos("PB0_ESPEC2") > 0)   .And.;
		PB0->(FieldPos("PB0_ESPEC3") > 0)   .And.;
		PB0->(FieldPos("PB0_ESPEC4") > 0)   .And.;
		PB0->(FieldPos("PB0_VOLUM1") > 0)   .And.;
		PB0->(FieldPos("PB0_VOLUM2") > 0)   .And.;
		PB0->(FieldPos("PB0_VOLUM3") > 0)   .And.;
		PB0->(FieldPos("PB0_VOLUM4") > 0)   .And.;
		PB0->(FieldPos("PB0_PLIQUI")  > 0)   .And.;
		PB0->(FieldPos("PB0_PBRUTO")  > 0)   .And.;
		PB0->(FieldPos("PB0_TRANSP")  > 0)   .And.;
		PB0->(FieldPos("PB0_PLACA")   > 0)   .And.;
		PB0->(FieldPos("PB0_CHVNFE")  > 0)   .And.;
		FindFunction("NfeFld_D")

	Private oGetDados
	Private bGDRefresh	:= {|| IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.) }		// Efetua o Refresh da GetDados
	Private	bRefresh    := {|nX,nY,nTotal,nValDesc| Ma140Total(a140Total,a140Desp,nTotal,nValDesc),NfeFldChg(,,oFolder,aFldCBAtu),IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.)}
	Private l103Visual  := .T. //-- Nao permite alterar os campos de despesas/frete.
	Private lNfMedic    := .F.
	Private cTpOrig	  := PB0->PB0_TIPO

	Private cArqTrb
	Private cTmpZZS := GetNextAlias()
	Private oTmp1 //tabela de pedidos x notas

//Cria tabela temporaria de pedidos x notas
	U_fCriaTemp(cTmpZZS)

//Carrega dados
	aDados := {PB0->PB0_FILIAL,PB0->PB0_DOC,PB0->PB0_SERIE,PB0->PB0_FORNEC,PB0->PB0_LOJA}
	U_fLoadTemp(cTmpZZS,aDados,"N")

	DEFAULT aPedC	:= {}

	l140Auto := !(Type("l140Auto")=="U" .Or. !l140Auto)

// Zera os totais para que a chamada de inclusao apos uma gravacao nao traga os valores preenchidos
	a140Total := {0,0,0,0,0,0,0,0,0}
	a140Desp  := {0,0,0,0,0,0,0,0}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os campos referentes ao WMS na Pre-Nota               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IntDL()
		aAdd(aListCpo, 'PB1_SERVIC')
		aAdd(aListCpo, 'PB1_STSERV')
		aAdd(aListCpo, 'PB1_TPESTR')
		aAdd(aListCpo, 'PB1_DESEST')
		aAdd(aListCpo, 'PB1_REGWMS')
		aAdd(aListCpo, 'PB1_ENDER' )
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os campos referentes ao EIC na Pre-Nota               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l140Auto .And. SuperGetMV("MV_EASY",,"N") == "S"
		aAdd(aListCpo, 'PB1_DATORI' )
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do ponto de entrada MT140DCP 					   ³                                                |
//| Para não exibir os campos customizados no Acols, é necessário incluir o mesmo no aListBox e posteriormente  |
//| carregar o mesmo no array aNolFields para ser descconsiderado na FillGetDados 								|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aNoFields:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a operacao a ser realizada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case aRotina[nOpcX][4] == 2
		l140Visual := .T.
	Case aRotina[nOpcX][4] == 3
		l140Inclui	:= .T.
	Case aRotina[nOpcX][4] == 4
		l140Altera	:= .T.
	Case aRotina[nOpcX][4] == 5
		l140Exclui	:= .T.
		l140Visual	:= .T.
	EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa data de fechamento somente quando o parametro MV_DATAHOM  |
//| estiver configurado com o conteudo igual a "2"                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l140Inclui .And. SuperGetMv("MV_DATAHOM",.F.,"1")=="2"
		If dDataFec >= dDataBase
			Help( " ", 1, "FECHTO" )
			lContinua := .F.
		EndIf
	EndIf

	If (l140Altera .OR. l140Exclui) .and. lContinua
		If PB0->PB0_STATUS == "2"
			Alert("Pre-Nota já Gerada. Alteração/Exclusão não Permitida")
			lContinua := .F.
		Endif
	Endif
	
// Evita reacumulo do saldo em aPedc (ao cancelar alt./realterar/F6) BOPS 90013 07/02/06
	If !l140Visual
		aPedC	:= {}
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis da Modelo 2                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private bPMSDlgNF	:= {||PmsDlgNF(nOpcX,cNFiscal,cSerie,cA100For,cLoja,cTipo)} // Chamada da Dialog de Gerenc. Projetos
	Private aRatAFN     := {}
	Private	cTipo		:= If(l140Inclui,CriaVar("PB0_TIPO")	,PB0->PB0_TIPO)
	Private cFormul		:= If(l140Inclui,CriaVar("PB0_FORMUL")	,PB0->PB0_FORMUL)
	Private cNFiscal 	:= If(l140Inclui,CriaVar("PB0_DOC")		,PB0->PB0_DOC)
	Private cSerie		:= If(l140Inclui,CriaVar("PB0_SERIE")	,PB0->PB0_SERIE)
	Private dDEmissao	:= If(l140Inclui,CriaVar("PB0_EMISSA")	,PB0->PB0_EMISSA)
	Private cA100For	:= If(l140Inclui,CriaVar("PB0_FORNEC")	,PB0->PB0_FORNEC)
	Private cLoja		:= If(l140Inclui,CriaVar("PB0_LOJA")	,PB0->PB0_LOJA)
	Private cEspecie	:= If(l140Inclui,CriaVar("PB0_ESPECI")	,PB0->PB0_ESPECI)
	Private cUfOrigP	:= If(l140Inclui,CriaVar("PB0_EST")		,PB0->PB0_EST)
	Private cCondicao  :=  If(l140Inclui,CriaVar("PB0_COND")	,PB0->PB0_COND)
	Private dVencto		:= If(l140Inclui,CriaVar("PB0_VENCTO")	,PB0->PB0_VENCTO)
	Private n           := 1
	Private aCols		:= {}
	Private aHeader 	:= {}
	Private lReajuste   := .F.
	Private lConsLoja   := .T.
	Private cForAntNFE  := ""
	Private lMudouNum   := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita as HotKeys e botoes da barra de ferramentas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .and. (!l140Auto .Or. (nMostraTela <> 0)) .And. (l140Inclui .Or. l140Altera)
		If !l140Altera
			aButtons	:= {;
				{'PEDIDO'	,{|| fConsPed() },STR0009,"Consultar Pedido <F8>"},; //"Pedidos de Compras"
			{'PEDIDO',{||A103ForF4(.F.,a140Desp, lNfMedic, lConsMedic),Eval(bRefresh)},STR0009,STR0010},; //"Pedidos de Compras"
			{'SDUPROP',{||A103ItEBPC(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp ),Eval(bRefresh)},STR0011,STR0031}; //"PEDIDO"###"Pedidos de Compras(por item)"
			}

			SetKey( VK_F5, { || A103ForF4(.F.,a140Desp, lNfMedic, lConsMedic ),Eval(bRefresh) } )
		Else
			aButtons	:= {;
				{'PEDIDO'	,{|| fInfPed()  },STR0009,"Informar Pedido <F7>"},; //"Pedidos de Compras"
				{'PEDIDO'	,{|| fConsPed() },STR0009,"Consultar Pedido <F8>"},; //"Pedidos de Compras"
				{'PEDIDO' 	,{|| IIF(u_EB140Tudok("1"),(Processa({|lEnd| EB140Grava( l140Exclui, aRecPB1, a140Desp,.T. )},"Gerando Pre-Nota") ,oDlg:End()) ,.T.),Eval(bRefresh)},"Gera Pre-Nota","Pre-Nota"},;
				{'S4WB006N'	,{|| u_Conf_Div(),Eval(bRefresh)},"Divide Item Conforme PC","Divide Item"};
				}

//italo maciel 20/09/18
			SetKey( VK_F6, { || IIF(cTipo == "D",AtuItemDev(), IIF(MsgYesNo("Nota é de Garantia?","Atenção"),AtuItemDev(),) ),Eval(bRefresh) } )

			SetKey( VK_F7, { || fInfPed() } )
			SetKey( VK_F8, { || fConsPed() } )
		EndIf
	EndIf

	If lContinua .and. (!l140Auto .Or. (nMostraTela <> 0)) .And. IntePms()
		aadd(aButtons, {'PROJETPMS',bPmsDlgNF,STR0012,STR0032}) //"Gerenciamento de Projetos"
		SetKey( VK_F10, { || Eval(bPmsDlgNF)} )
	EndIf

	aadd(aTitles,"Dados Recebimento XML")

	If lContinua .and. !l140Inclui

		If lNfeDanfe
			aNFEDanfe := {CriaVar("PB0_TRANSP"),CriaVar("PB0_PLIQUI"),CriaVar("PB0_PBRUTO"),CriaVar("PB0_ESPEC1"),CriaVar("PB0_VOLUM1"),CriaVar("PB0_ESPEC2"),CriaVar("PB0_VOLUM2"),CriaVar("PB0_ESPEC3"),CriaVar("PB0_VOLUM3"),CriaVar("PB0_ESPEC4"),CriaVar("PB0_VOLUM4"),Iif(PB0->(FieldPos("PB0_PLACA")) > 0,CriaVar("PB0_PLACA"),Nil),CriaVar("PB0_CHVNFE")}
		EndIf

//Danfe
		If lNfeDanfe
			If ProcH("PB0_TRANSP") > 0
				aVldBlock[17] := {|| ExistCpo("SA4",aDanfe[01],1,NIL,.T.)}
				Aadd(aValidGet,{"aDanfe[01]",aAutoCab[ProcH("PB0_TRANSP"),2],"Eval(aVldBlock[17])",.F.})
				aNfeDanfe[01] := aAutoCab[ProcH("PB0_TRANSP"),2]
			Endif

			If ProcH("PB0_PLIQUI") > 0
				aVldBlock[18] := {||CheckSX3('PB0_PLIQUI',aDanfe[02])}
				Aadd(aValidGet,{"aDanfe[02]",aAutoCab[ProcH("PB0_PLIQUI"),2],"Eval(aVldBlock[18])",.F.})
				aNfeDanfe[02] := aAutoCab[ProcH("PB0_PLIQUI"),2]
			Endif

			If ProcH("PB0_PBRUTO") > 0
				aVldBlock[19] := {||CheckSX3('PB0_PBRUTO',aDanfe[03])}
				Aadd(aValidGet,{"aDanfe[03]",aAutoCab[ProcH("PB0_PBRUTO"),2],"Eval(aVldBlock[19])",.F.})
				aNfeDanfe[03] := aAutoCab[ProcH("PB0_PBRUTO"),2]
			Endif

			If ProcH("PB0_ESPECI") > 0
				aVldBlock[20] := {||CheckSX3('PB0_ESPEC1',aDanfe[04])}
				Aadd(aValidGet,{"aDanfe[04]",aAutoCab[ProcH("PB0_ESPEC1"),2],"Eval(aVldBlock[20])",.F.})
				aNfeDanfe[04] := aAutoCab[ProcH("PB0_ESPEC1"),2]
			Endif

			If ProcH("PB0_VOLUM1") > 0
				aVldBlock[21] := {||CheckSX3('PB0_VOLUM1',aDanfe[05])}
				Aadd(aValidGet,{"aDanfe[05]",aAutoCab[ProcH("PB0_VOLUM1"),2],"Eval(aVldBlock[21])",.F.})
				aNfeDanfe[05] := aAutoCab[ProcH("PB0_VOLUM1"),2]
			Endif

			If ProcH("PB0_ESPEC2") > 0
				aVldBlock[22] := {||CheckSX3('PB0_ESPEC2',aDanfe[06])}
				Aadd(aValidGet,{"aDanfe[06]",aAutoCab[ProcH("PB0_ESPEC2"),2],"Eval(aVldBlock[22])",.F.})
				aNfeDanfe[06] := aAutoCab[ProcH("PB0_ESPEC2"),2]
			Endif

			If ProcH("PB0_VOLUM2") > 0
				aVldBlock[23] := {||CheckSX3('PB0_VOLUM2',aDanfe[07])}
				Aadd(aValidGet,{"aDanfe[07]",aAutoCab[ProcH("PB0_VOLUM2"),2],"Eval(aVldBlock[23])",.F.})
				aNfeDanfe[07] := aAutoCab[ProcH("PB0_VOLUM2"),2]
			Endif

			If ProcH("PB0_ESPEC3") > 0
				aVldBlock[24] := {||CheckSX3('PB0_ESPEC3',aDanfe[08])}
				Aadd(aValidGet,{"aDanfe[08]",aAutoCab[ProcH("PB0_ESPEC3"),2],"Eval(aVldBlock[24])",.F.})
				aNfeDanfe[08] := aAutoCab[ProcH("PB0_ESPEC3"),2]
			Endif

			If ProcH("PB0_VOLUM3") > 0
				aVldBlock[25] := {||CheckSX3('PB0_VOLUM3',aDanfe[09])}
				Aadd(aValidGet,{"aDanfe[09]",aAutoCab[ProcH("PB0_VOLUM3"),2],"Eval(aVldBlock[25])",.F.})
				aNfeDanfe[09] := aAutoCab[ProcH("PB0_VOLUM3"),2]
			Endif

			If ProcH("PB0_ESPEC4") > 0
				aVldBlock[26] := {||CheckSX3('PB0_ESPEC4',aDanfe[10])}
				Aadd(aValidGet,{"aDanfe[10]",aAutoCab[ProcH("PB0_ESPEC4"),2],"Eval(aVldBlock[26])",.F.})
				aNfeDanfe[10] := aAutoCab[ProcH("PB0_ESPEC4"),2]
			Endif

			If ProcH("PB0_VOLUM4") > 0
				aVldBlock[27] :=  {||CheckSX3('PB0_VOLUM4',aDanfe[11])}
				Aadd(aValidGet,{"aDanfe[11]",aAutoCab[ProcH("PB0_VOLUM4"),2],"Eval(aVldBlock[27])",.F.})
				aNfeDanfe[11] := aAutoCab[ProcH("PB0_VOLUM4"),2]
			Endif

			If ProcH("PB0_PLACA") > 0
				aVldBlock[28] := {||CheckSX3('PB0_PLACA',aDanfe[12])}
				Aadd(aValidGet,{"aDanfe[12]",aAutoCab[ProcH("PB0_PLACA"),2],"Eval(aVldBlock[28])",.F.})
				aNfeDanfe[12] := aAutoCab[ProcH("PB0_PLACA"),2]
			Endif

			If ProcH("PB0_CHVNFE") > 0
				aVldBlock[29] := {||CheckSX3('PB0_CHVNFE',aDanfe[13])}
				Aadd(aValidGet,{"aDanfe[13]",aAutoCab[ProcH("PB0_CHVNFE"),2],"Eval(aVldBlock[29])",.F.})
				aNfeDanfe[13] := aAutoCab[ProcH("PB0_CHVNFE"),2]
			Endif
		EndIf

//-- Atualiza dados do folder de despesas
		a140Desp[VALDESP]:= PB0->PB0_DESPES
		a140Desp[FRETE]  := PB0->PB0_FRETE
		a140Desp[SEGURO] := PB0->PB0_SEGURO
		aInfXML[1] := PB0->PB0_USRIMP
		aInfXML[2] := PB0->PB0_DTAIMP
		aInfXML[3] := PB0->PB0_ARQUIV
		aInfXML[4] := PB0->PB0_CHVNFE
		aInfXML[5] := PB0->PB0_INFCOM
		aInfCar[1] := PB0->PB0_CARGA
		aInfCar[2] := PB0->PB0_SEQCAR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !l140Visual
			If !SoftLock("PB0")
				lContinua := .F.
			EndIf
		EndIf

		If lContinua
			dbSelectArea("PB1")
			dbSetOrder(1)
			#IFDEF TOP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de campo MEMO no PB1 para nao executar a Query.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SX3->(dbSetOrder(1))
				SX3->(MsSeek("PB1"))
//While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "PB1"
				aCmpPB1 := FWSX3Util():GetAllFields("PB1")
				For nX := 1 to Len(aCmpPB1)
					If (IIf((!l140Auto .Or. (nMostraTela <> 0)),X3USO(SX3->X3_USADO),.T.) .And.;
							AScan(aListCpo,Trim(SX3->X3_CAMPO)) != 0 .And. cNivel >= SX3->X3_NIVEL) .Or.;
							(SX3->X3_PROPRI == "U" .And. cNivel >= SX3->X3_NIVEL)
						If SX3->X3_TIPO == "M"
							lExistMemo := .T.
							Exit
						EndIf
					EndIf
					SX3->(dbSkip())
				Next nX
//EndDo

				If !InTransact() .And. !lExistMemo
					aStruPB1 := PB1->(dbStruct())
					lQuery   := .T.

					cQuery := "SELECT PB1.R_E_C_N_O_ PB1RECNO,PB1.* "
					cQuery += "FROM "+RetSqlName("PB1")+" PB1 "
					cQuery += "WHERE PB1.PB1_FILIAL='"+xFilial("PB1")+"' AND "
					cQuery += "PB1.PB1_DOC = '"+PB0->PB0_DOC+"' AND "
					cQuery += "PB1.PB1_SERIE = '"+PB0->PB0_SERIE+"' AND "
					cQuery += "PB1.PB1_FORNEC = '"+PB0->PB0_FORNEC+"' AND "
					cQuery += "PB1.PB1_LOJA = '"+PB0->PB0_LOJA+"' AND "
					cQuery += "PB1.D_E_L_E_T_=' ' "
					cQuery += "ORDER BY "+SqlOrder( "PB1_FILIAL+PB1_DOC+PB1_SERIE+PB1_FORNEC+PB1_LOJA+PB1_ITEM+PB1_COD" )
					cQuery := ChangeQuery(cQuery)

					PB1->(dbCloseArea())

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PB1")
					For nX := 1 To Len(aStruPB1)
						If aStruPB1[nX][2]<>"C"
							TcSetField("PB1",aStruPB1[nX][1],aStruPB1[nX][2],aStruPB1[nX][3],aStruPB1[nX][4])
						EndIf
					Next nX
				Else
				#ENDIF
				MsSeek(xFilial("PB1")+cNFiscal+PB0->PB0_SERIE+PB0->PB0_FORNEC+PB0->PB0_LOJA)
				#IFDEF TOP
				EndIf
			#ENDIF

			bWhilePB1 := { || ( !Eof().And. lContinua .And. ;
				(cAliasPB1)->PB1_FILIAL== xFilial("PB1") .And. ;
				(cAliasPB1)->PB1_DOC == cNFiscal .And. ;
				(cAliasPB1)->PB1_SERIE == PB0->PB0_SERIE .And. ;
				(cAliasPB1)->PB1_FORNEC == PB0->PB0_FORNEC .And. ;
				(cAliasPB1)->PB1_LOJA == PB0->PB0_LOJA ) }
		EndIf
	EndIf

	If lContinua

// Sintaxe da FillGetDados(nOpcx,cAlias,nOrder,cSeekKey,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry,bCriaVar,lUserFields)

		FillGetDados(nOpcX,"PB1",1,/*cSeek*/,/*{|| &cWhile }*/,{||.T.},aNoFields,aListCpo,/*lOnlyYes*/,/*cQuery*/,{|| MaCols140 (cAliasPB1,bWhilePB1,aRecOrdPB1,@aRecPB1,@aPedC,lItPB1Ord,lQuery,l140Inclui,l140Visual,@lContinua,l140Exclui) },l140Inclui,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bbeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,.T.,IIF(!l140Auto .Or. nMostraTela <> 0,{},aListCpo))

		If lQuery
			dbSelectArea("PB1")
			dbCloseArea()
			ChkFile("PB1")
		EndIf

		If lContinua
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do total do pre-documento de entrada                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Ma140Total(a140Total,a140Desp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rotina automatica                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l140Auto
				nOpcA := 1
				If !l140Exclui
					aValidGet := {}
					If l140Inclui
						PRIVATE aBlock := {	{|| NfeTipo(cTipo,@cA100For,@cLoja)},;
							{|| NfeFormul(cFormul,@cNFiscal,@cSerie)},;
							{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3("PB0_DOC")},;
							{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3("PB0_SERIE")},;
							{|| CheckSX3("PB0_EMISSA") .And. NfeEmissao(dDEmissao)},;
							{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3('PB0_FORNEC',cA100For)},;
							{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3('PB0_LOJA',cLoja)},;
							{|| CheckSX3("PB0_ESPECI",cEspecie)},;
							{|| CheckSX3("PB0_EST",cUfOrigP) .And. CheckSX3("PB0_EST",cUfOrigP)}}
						If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_TIPO"}))<>0
							aadd(aValidGet,{"cTipo",aAutoCab[(nX),2],"Eval(aBlock[1])",.T.})
						Else
							cTipo := "N"
						EndIf
						If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_FORMUL"}))<>0
							aadd(aValidGet,{"cFormul",aAutoCab[(nX),2],"Eval(aBlock[2])",.T.})
						Else
							cFormul := "N"
						EndIf
						nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_DOC"})
						aadd(aValidGet,{"cNFiscal" ,aAutoCab[(nX),2],"Eval(aBlock[3])",.T.})
						nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_SERIE"})
						aadd(aValidGet,{"cSerie",aAutoCab[(nX),2],"Eval(aBlock[4])",.T.})
						nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_EMISSA"})
						aadd(aValidGet,{"dDEmissao",aAutoCab[(nX),2],"Eval(aBlock[5])",.T.})
						nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_FORNEC"})
						aadd(aValidGet,{"cA100For",aAutoCab[(nX),2],"Eval(aBlock[6])",.T.})
						nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_LOJA"})
						aadd(aValidGet,{"cLoja",aAutoCab[(nX),2],"Eval(aBlock[7])",.T.})
						If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_ESPECI"}))<>0
							aadd(aValidGet,{"cEspecie",aAutoCab[(nX),2],"Eval(aBlock[8])",.T.})
						Else
							cEspecie := ""
						EndIf
						If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="PB0_EST"}))<>0
							aadd(aValidGet,{"cUfOrigP",aAutoCab[(nX),2],"Eval(aBlock[9])",.T.})
						Else
							cUfOrigP := ""
						EndIf
						If ! PB0->(MsVldGAuto(aValidGet))
							nOpcA := 0
						EndIf
					EndIf
					If nOpcA <> 0
						If !NfeCabOk(l140Visual,Nil,Nil,Nil,Nil,Nil,.F.)
							nOpcA := 0
						Else
							If nMostraTela <> 2
								If !PB1->(MsGetDAuto(aAutoItens,"u_EB140LinOk('1')",{|| u_EB140Tudok("2")},aAutoCab,aRotina[nOpcX][4]))
									nOpcA := 0
								EndIf
							EndIf
						EndIf
					EndIf
					If nMostraTela <> 0 .And. nOpca <> 0
						l140Auto := .F.
						nOpca    := 0
						HelpInDark(.F.)
					EndIf
				EndIf
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Interface com o Usuario                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !l140Auto
				aSizeAut := MsAdvSize(,.F.,400)
				aObjects := {}
				aadd( aObjects, { 0,   40, .T., .F. } )
				aadd( aObjects, { 100, 10, .T., .T. } )
				aadd( aObjects, { 100, 90, .T., .F. } )
				aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
				aPosObj := MsObjSize( aInfo, aObjects )

				aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
					{{8,35,78,100,140,160,200,230,250,270},;
					If( l103Visual .Or. !lConsMedic,{8,35,75,100,nPosGetLoja,194,220,260,280},{8,35,75,108,135,160,190,220,244,265} ) ,;
						{5,70,160,205,295},;
						{6,34,200,215},;
						{6,34,75,103,148,164,230,253},;
						{6,34,200,218,280},;
						{11,50,150,190},;
						{273,130,190,293,205},;
						{005,025,065,085,125,145,185,205,250,275},;
						{11,35,80,110,165,190},;
						{3,35,95,150,205,255,170,230,265,;
						55,115,155,217,185,245,280,167,222,272},;
						{3, 4}}) // 12 - Folder Informações Adicionais

					DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro Of oMainWnd PIXEL

					NfeCabXML(oDlg,{aPosGet[1],aPosGet[2],aPosObj[1]},@bCabOk,l140Visual .Or. l140Altera,.F.,@cUfOrigP,,.T.,nil,nil,nil,nil,@lNfMedic)

//Ajusta coluna do grid
					aHeader[aScan(aHeader,{|x|alltrim(x[2])=="PB1_DSCFOR"})][4] := 50

					oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"u_EB140LinOk('1')","u_EB140Tudok('2')",,!l140Visual,,,,Len(aCols),,,,"u_EB140DelIt")
					oGetDados:oBrowse:bGotFocus	:= bCabOk

					oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"HEADER"},oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder dos Totalizadores                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oFolder:aDialogs[1]:oFont := oDlg:oFont
					NfeFldTot(oFolder:aDialogs[1],a140Total,aPosGet[3],@aFldCBAtu[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder dos Fornecedores                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oFolder:aDialogs[2]:oFont := oDlg:oFont
					oFolder:bSetOption := {|nDst| NfeFldChg(nDst,oFolder:nOption,oFolder,aFldCBAtu)}
					NfeFldFor(oFolder:aDialogs[2],aInfForn,{aPosGet[4],aPosGet[5],aPosGet[6]},@aFldCBAtu[2])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder das Despesas acessorias e descontos                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oFolder:aDialogs[3]:oFont := oDlg:oFont
					NfeFldDsp(oFolder:aDialogs[3],a140Desp,{aPosGet[7],aPosGet[8]},@aFldCBAtu[3])

					oFolder:aDialogs[4]:oFont := oDlg:oFont
					NfeFldXML(oFolder:aDialogs[4],aInfXML,{aPosGet[4],aPosGet[5],aPosGet[6]},@aFldCBAtu[1])

					ACTIVATE MSDIALOG oDlg ON INIT Ma140Bar(oDlg,{||If(oGetDados:TudoOk().And.NfeNextDoc(@cNFiscal,@cSerie,l140Inclui),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||oDlg:End()},aButtons)
				EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao do pre-documento de entrada                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nOpcA == 1 .AND. ( l140Inclui .OR. l140Altera .OR. l140Exclui ) .AND. ( Type( "lOnUpDate" ) == "U" .OR. lOnUpdate )
					EB140Grava( l140Exclui, aRecPB1, a140Desp,.F. )
					//Excluir tabelas relacionads ao XML
					If l140Exclui
						//PB3 - INCONSISTENCIAS
						dbSelectArea("PB3")
						PB3->(dbSetOrder(1))
						While PB3->(dbSeek(xFilial("PB3") + PB0->PB0_DOC + PB0->PB0_SERIE + PB0->PB0_FORNEC))
							//lock e delete
							Reclock("PB3",.F.)
							PB3->(dbDelete())
							PB3->(MsUnlock())

							PB3->(dbSkip())
						EndDo
						//ZZS - PEDIDO X NOTAS
						dbSelectArea("ZZS")
						ZZS->(dbSetOrder(1))
						While ZZS->(dbSeek(xFilial("ZZS") + PB0->PB0_DOC + PB0->PB0_SERIE + PB0->PB0_FORNEC + PB0->PB0_LOJA))
							//lock e delete
							Reclock("ZZS",.F.)
							ZZS->(dbDelete())
							ZZS->(MsUnlock())

							ZZS->(dbSkip())
						EndDo

						//PB2 - FRETE X NOTAS
						dbSelectArea("PB2")
						PB2->(dbSetOrder(3))
						While PB2->(dbSeek(xFilial("PB2") + PB0->PB0_DOC + PB0->PB0_SERIE + PB0->PB0_FORNEC + PB0->PB0_LOJA))//PB2_FILIAL, PB2_NFDIFR, PB2_SEDIFR, PB2_FORNEC, PB2_LOJA
							//lock e delete
							Reclock("PB2",.F.)
							PB2->(dbDelete())
							PB2->(MsUnlock())

							PB2->(dbSkip())
						EndDo
					EndIf
				ElseIf l140Auto
					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_FILIAL" } ) ) > 0
						aAutoCab[nPos][2] := xFilial( "PB0" )
					Else
						AAdd( aAutoCab, { "PB0_FILIAL", xFilial( "PB0" ), NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_DOC" } ) ) > 0
						aAutoCab[nPos][2] := cNFiscal
					Else
						AAdd( aAutoCab, { "PB0_DOC", cNFiscal, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_SERIE" } ) ) > 0
						aAutoCab[nPos][2] := cSerie
					Else
						AAdd( aAutoCab, { "PB0_SERIE", cSerie, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_FORNEC" } ) ) > 0
						aAutoCab[nPos][2] := cA100For
					Else
						AAdd( aAutoCab, { "PB0_FORNEC", cA100For, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_LOJA" } ) ) > 0
						aAutoCab[nPos][2] := cLoja
					Else
						AAdd( aAutoCab, { "PB0_LOJA", cLoja, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_EMISSA" } ) ) > 0
						aAutoCab[nPos][2] := dDEmissao
					Else
						AAdd( aAutoCab, { "PB0_EMISSA", dDEmissao, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_EST" } ) ) > 0
						aAutoCab[nPos][2] := IIF( cTipo $ "DB", SA1->A1_EST, SA2->A2_EST )
					Else
						AAdd( aAutoCab, { "PB0_EST", IIF( cTipo $ "DB", SA1->A1_EST, SA2->A2_EST ), NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_TIPO" } ) ) > 0
						aAutoCab[nPos][2] := cTipo
					Else
						AAdd( aAutoCab, { "PB0_TIPO", cTipo, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_DTDIGIT" } ) ) > 0
						aAutoCab[nPos][2] := dDataBase
					Else
						AAdd( aAutoCab, { "PB0_DTDIGIT", dDataBase, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_RECBMTO" } ) ) > 0
						aAutoCab[nPos][2] := PB0->PB0_DTDIGIT
					Else
						AAdd( aAutoCab, { "PB0_RECBMTO", PB0->PB0_DTDIGIT	, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_FORMUL" } ) ) > 0
						aAutoCab[nPos][2] := IIF( cFormul == "S", "S", " " )
					Else
						AAdd( aAutoCab, { "PB0_FORMUL", IIF( cFormul == "S", "S", " " ), NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_ESPECI" } ) ) > 0
						aAutoCab[nPos][2] := cEspecie
					Else
						AAdd( aAutoCab, { "PB0_ESPECI", cEspecie, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_DESPES" } ) ) > 0
						aAutoCab[nPos][2] := a140Desp[VALDESP]
					Else
						AAdd( aAutoCab, { "PB0_DESPES", a140Desp[VALDESP], NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_FRETE" } ) ) > 0
						aAutoCab[nPos][2] := a140Desp[FRETE]
					Else
						AAdd( aAutoCab, { "PB0_FRETE", a140Desp[FRETE], NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_SEGURO" } ) ) > 0
						aAutoCab[nPos][2] := a140Desp[SEGURO]
					Else
						AAdd( aAutoCab, { "PB0_SEGURO", a140Desp[SEGURO]	, NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_VALMERC" } ) ) > 0
						aAutoCab[nPos][2] := a140Total[VALMERC]
					Else
						AAdd( aAutoCab, { "PB0_VALMERC", a140Total[VALMERC], NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_DESCONT" } ) ) > 0
						aAutoCab[nPos][2] := a140Total[VALDESC]
					Else
						AAdd( aAutoCab, { "PB0_DESCONT", a140Total[VALDESC], NIL } )
					Endif

					If ( nPos := AScan( aAutoCab, { |x| x[1] == "PB0_VALBRUT" } ) ) > 0
						aAutoCab[nPos][2] := a140Total[TOTPED]
					Else
						AAdd( aAutoCab, { "PB0_VALBRUT", a140Total[TOTPED], NIL } )
					Endif

					aAutoItens := MsAuto2Gd( aHeader, aCols )
				EndIf
			EndIf
		EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destrava os registros na alteracao e exclusao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsUnlockAll()
		If !l140Auto
			SetKey( VK_F5, { || u_AtuXML(.F.) } )
			SetKey( VK_F10, Nil )
		Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O ponto de entrada e disparado apos o RestArea pois pode ser utilizado para posicionar o Browse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "MT140SAI" )
			ExecBlock( "MT140SAI", .F., .F., { aRotina[ nOpcx, 4 ], cNFiscal, cSerie, cA100For, cLoja, cTipo, nOpcA } )
		EndIf

//Checa inconsistencias e atualiza os status
		If Altera .AND. nOpcA == 1
//Atualiza a tabela pedidos x notas
			fAtuZZS()

			U_AtuXML(.F.)
		EndIf

		oTmp1:Delete()

		SetKey( VK_F6,{ || Nil } )
		SetKey( VK_F7,{ || Nil } )
		SetKey( VK_F8,{ || Nil } )

		Return(.T.)
/*/
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡„o    ³EB140LinOk³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³          ³Validacao da Getdados - LinhaOk                              ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpO1: Objeto da getdados                                    ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorno   ³ExpL1: Indica se a linha digitada eh valida                  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡„o ³Esta rotina tem como objetivo validar um item do pre-documen-³±±
		±±³          ³to de entrada                                                ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Uso       ³ Materiais                                                   ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EB140LinOk(_nParam,cMens)

	Local aArea			:= GetArea()
	Local lRetorno		:= .T.
	Local nPosCod		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_COD"})
	Local nPosLocal		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_LOCAL"})
	Local nPosQuant		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_QUANT"})
	Local nPosST		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_CLASFI"})
	Local nPosVUnit		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_VUNIT"})
	Local nPosTotal		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_TOTAL"})
	Local nPosPC		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_PEDIDO"})
	Local nPosItemPC	:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_ITEMPC"})
	Local nPosUMPC		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_UMFORN"})
	Local nPosUM		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_UM"})
	Local nPosFat		:= aScan(aHeader,{|x|Alltrim(x[2])=="PB1_FATOR"})

	Local lPCNFE		:= GetNewPar( "MV_PCNFE", .F. ) //-- Nota Fiscal tem que ser amarrada a um Pedido de Compra ?
	Local nPosServic	:= aScan(aHeader, {|x|Upper(Alltrim(x[2]))=='PB1_SERVIC'})
	Local lMT140PC
	Local nPosOp     	:= aScan(aHeader,{|x| AllTrim(x[2])=="PB1_OP"})

	Local dDTULMES := CTOD("") //Data do Ultimo Fechamento do Estoque

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos da linha do acols      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CheckCols(n,aCols)
		If !aCols[n][Len(aCols[n])]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando Informado Armazem em branco considerar o B1_LOCPAD   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aCols[n][nPosLocal])
				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+aCols[n][nPosCod]))
					aCols[n][nPosLocal] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
/*
					If Type("l140Auto") <> "U" .And. !l140Auto
Aviso(OemToAnsi(STR0035),OemToAnsi(STR0053),{"Ok"}) //Atencao##O Armazem informado e Invalido, o campo sera ajustando com o armazem padrão do cadastro de produtos
					EndIf
*/
				EndIf
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto est  sendo inventariado.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do Case
			Case Empty(aCols[n][nPosCod]) .Or. ;
					(Empty(aCols[n][nPosQuant]).And.cTipo$"NDB").Or. ;
					Empty(aCols[n][nPosVUnit]) .Or. ;
					Empty(aCols[n][nPosTotal])
				If _nParam == '2'
//Italo Maciel 30/07/18 - comentado
//Help("  ",1,"A140VZ")
//lRetorno := .F.
				Endif
			Case nPosPC > 0 .And. !Empty(aCols[n][nPosPc]) .And. Empty(aCols[n][nPosItemPC])
				If _nParam == '2'
//Italo Maciel 30/07/18 - comentado
//Help("  ",1,"A140PC")
//lRetorno := .F.
				Endif
/*Case cPaisLoc <> "BRA".AND.cTipo <> "C" .And.;
Round(aCols[n][nPosVUnit]*aCols[n][nPosQuant],SuperGetMV("MV_RNDLOC",.F.,2)) <> Round(aCols[n][nPosTotal],SuperGetMV("MV_RNDLOC",.F.,2))
				If _nParam == '2'
HELP(" ",1,"A100Valor")
lRetorno := .F.
				Endif*/
/*Case cTipo$'NDB' .And. (aCols[n][nPosTotal]>(aCols[n][nPosVUnit]*aCols[n][nPosQuant]+0.49);
.Or. aCols[n][nPosTotal]<(aCols[n][nPosVUnit]*aCols[n][nPosQuant]-0.49))
				If _nParam == '2'
Help("  ",1,'TOTAL')
lRetorno := .F.
				Endif*/
			Case cTipo <> 'C' .and. (!Empty(Acols[n][nPosCod]) .AND. !A103Alert(Acols[n][nPosCod],aCols[n][nPosLocal],l140Auto))
				If _nParam == '2'
//Italo Maciel 30/07/18 - comentado
//lRetorno := .F.
				Endif
			Case cTipo = 'N' .And. lPCNFE	 .And. Empty(aCols[n,nPosPC])
				If l140Auto .And. IsInCallStack("MATA310")    // Quando for Rotina Automatica e Transf.Filiais, ignora parametro pedido de compras
//Italo Maciel 30/07/18 - comentado
//lRetorno := .T.
				else
					If _nParam == '2'
//Italo Maciel 30/07/18 - comentado
//Aviso(OemToAnsi(STR0035),OemToAnsi(STR0036),{OemToAnsi(STR0037)}, 2 ) //-- "Atencao"###"Informe o No. do Pedido de Compras ou verifique o conteudo do parametro MV_PCNFE"###"Ok"
//lRetorno := .F.
					Endif
				EndIf
			Case cTipo <> 'C' .and. aCols[n,nPosUMPC] <> aCols[n,nPosUM] .and. Empty(aCols[n,nPosFat])
				If _nParam == '2'
//Alert("Unidades de medidas diferentes entre o PC e o XML, utilizar fator de conversao")
//Italo Maciel 30/07/18 - comentado
//cMens += "Item "+ cValToChar(n) +" - Unidade de medida diferente entre o PC e o XML, utilizar fator de conversao"+ Chr(13) + Chr(10)
//lRetorno := .F.
				Endif
			OtherWise
lRetorno := .T.
			EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Produto x Fornecedor foi Bloquedo pela Qualidade.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRetorno
lRetorno := QieSitFornec(cA100For,cLoja,aCols[n][nPosCod],.T.)
			EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Ordem de Produção está encerrada   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRetorno
				If !Empty(aCols[n][nPosOp]) .And. (!SC2->(dbSeek(xFilial("SC2")+aCols[n][nPosOp])) .Or. !Empty(SC2->C2_DATRF))
lRetorno := .F.
				EndIf

				If !lRetorno
					If _nParam == '2'
//Italo Maciel 30/07/18 - comentado
//Help(" ",1,"A100OPEND")
					Endif
				EndIf
			EndIf

		Else
lRetorno := .T.
		EndIf
	Else
lRetorno := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Refresh do rodape do pre-documento de entrada            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Eval(bRefresh)
	If _nParam == '1'
lRetorno := .T.  // Nao travar na digitacao da linha
	Endif

RestArea(aArea)
Return lRetorno
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EB140Tudok³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da Getdados - TudoOk                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da getdados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se todos os itens sao validos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo validar todos os itens do pre- ³±±
±±³          ³-documento de entrada                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EB140Tudok(_cPergL)

Local lRetorno		:= .T.
Local lTudoDel		:= .T.
Local nX			:= 0
Local nPosMed		:= GDFieldPos( "PB1_ITEMMED" )
Local nPosCod		:= GDFieldPos( "PB1_COD" )
Local nPosTES		:= GDFieldPos( "PB1_TES" )
Local nPosUM		:= GDFieldPos( "PB1_UM" )
Local nPosPrc		:= GDFieldPos( "PB1_VUNIT" )
Local nPosNCM		:= GDFieldPos( "PB1_POSIPI" )
Local nPosOrig		:= GDFieldPos( "PB1_CLASFI" )
Local nPosUMFor		:= GDFieldPos( "PB1_UMFORN" )
//Local nPosPC		:= GDFieldPos( "PB1_PEDIDO" )
//Local nPosITPC		:= GDFieldPos( "PB1_ITEMPC" )
//Local nPosVUPC		:= GDFieldPos( "PB1_VUNIPC")
Local lMT140GCT 		:= ExistBlock("MT140GCT")
Local lItensMed    	:= .F.
Local lItensNaoMed 	:= .F.
Local _lCodSD1		:= .T.
Local _lCodTES 		:= .T.
Local aMT140GCT    	:= {}
Local cMens			:= ""

// Obtendo o Valor Limite da Tolerância
Local nValTol := 0 // GetMV( "MV_PBLQNFE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos do cabecalho           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(ca100For) .Or. Empty(dDEmissao) .Or. Empty(cTipo) .Or. (Empty(cNFiscal).And.cFormul!="S")
Help(" ",1,"A100FALTA")
lRetorno := .F.
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem itens a serem gravados               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX :=1 to Len(aCols)
		If !aCols[nX][Len(aCols[nX])]
lTudoDel := .F.

// Richardson 20/06/2014
//If !Empty(aCols[nX, nPosPC]) .and. Round(QtdComp(aCols[nX, nPosVUPC]),7) < Round(QtdComp(aCols[nX, nPosPrc]),7)
/*
			If !Empty(aCols[nX, nPosPC]) .and. Round(QtdComp(aCols[nX, nPosVUPC]) + nValTol, 7) < Round(QtdComp(aCols[nX, nPosPrc]), 7)
Alert("Valor unitario do XML maior que o valor unitario do Pedido de Compra")
lRetorno := .F.
			Endif
*/
			If lRetorno .and. _lCodSD1 .and. Empty(aCols[nX, nPosCod])
				_lCodSD1 := .F.
			Endif

			If lRetorno .and. cTipo == "C" .and. Empty(aCols[nX, nPosTES])
				_lCodTES := .F.
			Endif

			If lRetorno .and. !Empty( nPosMed )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de itens de medicao junto com itens sem medicao               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lItensMed    := lItensMed .Or. aCols[ nX, nPosMed ] == "1"
				lItensNaoMed := lItensNaoMed .Or. aCols[ nX, nPosMed ] $ " |2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada permite incluir itens não-pertinentes ao gct ou não.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMT140GCT
					aMT140GCT := ExecBlock("MT140GCT",.F.,.F.,{aCols,nX,nPosMed})

					If ValType(aMT140GCT) == "A"
						If Len(aMT140GCT) >= 1 .And. ValType(aMT140GCT[1]) == "L"
							lItensMed    := aMT140GCT[1]
						EndIf
						If Len(aMT140GCT) >= 2 .And. ValType(aMT140GCT[2]) == "L"
							lItensNaoMed := aMT140GCT[2]
						EndIf
					EndIf
				EndIf

				If lItensMed .And. lItensNaoMed
					Help( " ", 1, "A103MEDIC" )
					lRetorno := .F.
					Exit
				EndIf
			EndIf
			If Substr(cEspecie,1,2) <> "CT"  // NF de frete
				n:= nx
				u_EB140LinOk("2",@cMens)
			Endif
		Endif
	Next nX

	If !Empty(cMens)
		MsgAlert(cMens,"ATENÇÃO")
	EndIf

	If lTudoDel
		Help(" ",1,"A140TUDDEL")
		lRetorno := .F.
	EndIf

	If lRetorno .and. _cPergL == "1"  // IF para tratar geracao da pre-nota
		If !_lCodSD1
			Alert("Informar o codigo do produto")
			lRetorno := .f.
		Endif
		If cTipo == "C"
			//ALterado Andre Minelli 12/07/2021
			cCondicao := "01"

			If Empty(cCondicao)
				Alert("Informar a condicao de pagamento")
				lRetorno := .f.
			Endif
			If !_lCodTES
				Alert("Por se tratar de uma NF de complemento de frete, favor informar a TES")
				lRetorno := .f.
			Endif
		Endif
		If lRetorno .and. !MsgYesNo("Confirma a geracao da Pre-Nota?")
			lRetorno := .f.
		Endif
	Endif

Return lRetorno

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³Ma140Bar  ³ Prog. ³ Sergio Silveira       ³Data  ³ 23/02/2001³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³ Construcao da EnchoiceBar do pre-documento de entrada       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpO1 = Objeto dialog                                       ³±±
	±±³          ³ ExpB2 = Code block de confirma                              ³±±
	±±³          ³ ExpB3 = Code block de cancela                               ³±±
	±±³          ³ ExpA4 = Array com botoes ja incluidos.                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Devolve o retorno da enchoicebar                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo criar a barra de botoes denomi-³±±
	±±³          ³nada EnchoiceBar                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma140Bar(oDlg,bOk,bCancel,aButtonsAtu)

	Local aUsButtons := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock( "MA140BUT" )
		If ValType( aUsButtons := ExecBlock( "MA140BUT", .F., .F. ) ) == "A"
			AEval( aUsButtons, { |x| aadd( aButtonsAtu, x ) } )
		EndIf
	EndIf

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtonsAtu))

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³Ma140Total³ Prog. ³ Sergio Silveira       ³Data  ³ 23/02/2001³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³ Calculo do total do pre-documento de entrada                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpA1: Array com os totais do pre-documento de entrada      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo calcular os totais do pre-docum³±±
	±±³          ³ento de entrada                                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma140Total(aTotal,aDespesa, nTotal, nValDesc)

	Local nUsado   := Len(aHeader)
	Local nMaxFor  := Len(aCols)
	Local lDeleted := .F.
	Local nPTotal  := aScan(aHeader,{|x| AllTrim(x[2])=="PB1_TOTAL"})
	Local nPValDesc:= aScan(aHeader,{|x| AllTrim(x[2])=="PB1_VALDES"})
	Local nX       := 0

	Default nTotal 		:= 0
	Default nValDesc 	:= 0

	If Len(aCols)> 0
		For nX := 1 To Len(aCols)
			If aCols[nX][Len(aCols[1])]
				lDeleted := .T.
				Exit
			EndIf
		Next nX
	EndIf

	aTotal := aFill(aTotal,0)
	aDespesa[VALDESC] := 0
	For nX := 1 To nMaxFor
		If !lDeleted .Or. !aCols[nX][nUsado+1]
			If (n==nX)
				aTotal[VALMERC] 	+= 	Iif (nTotal<>0, nTotal, aCols[nX][nPTotal])
				aTotal[VALDESC] 	+= 	Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])
				aTotal[TOTPED ] 	+= 	Iif (nTotal<>0, nTotal, aCols[nX][nPTotal]) - Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])
				aDespesa[VALDESC]	+=	Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])

			ElseIf ((nTotal==0) .Or. (n<>nX))
				aTotal[VALMERC] 	+= 	aCols[nX][nPTotal]
				aTotal[VALDESC] 	+= 	aCols[nX][nPValDesc]
				aTotal[TOTPED ] 	+= 	aCols[nX][nPTotal] - aCols[nX][nPValDesc]
				aDespesa[VALDESC]	+=	aCols[nX][nPValDesc]
			EndIf
		EndIf
	Next nX
	aTotal[TOTPED ] += aDespesa[FRETE] + aDespesa[VALDESP] + aDespesa[SEGURO]
Return(.T.)
/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³EB140Grava³ Autor ³ Eduardo Riera         ³ Data ³03.10.2002 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Rotina de atualizacao do pre-documento de entrada            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpL1: Indica se a operacao eh de exclusao                   ³±±
	±±³          ³ExpA1: Array com os recnos do PB1                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpL1: Indica se houve atualizacao                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo atualizar um pre-documento de  ³±±
	±±³          ³entrada e seus anexos                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EB140Grava(lExclui,aRecPB1,aDespesa,_lGeraPre)

	Local aArea     	:= GetArea("PB0")
	Local aPCMail   	:= {}
	Local nX        	:= 0
	Local nY        	:= 0
	Local nMaxFor   	:= Len(aCols)
	Local nUsado    	:= Len(aHeader)
	Local nSaveSX8  	:= GetSX8Len()
	Local lTravou   	:= .F.
	Local lGrava    	:= .F.
	Local cItem     	:= StrZero(0,TamSX3("PB1_ITEM")[1])
	Local cDtHom		:= GetMv("MV_DATAHOM",NIL,"1")
	Local cGrupo    	:= SuperGetMv("MV_NFAPROV")
	Local lGeraBlq  	:= .F.
	Local nI        	:= 0
	Local nJ        	:= 0
	Local nPosServic	:= aScan(aHeader, {|x|Upper(Alltrim(x[2]))=='PB1_SERVIC'})
	Local nDecimalPC	:= TamSX3("C7_PRECO")[2]
	Local aAreaPB1      := {}
	Local aAreaSDE      := {}

	//-- Variaveis utilizadas pela funcao wmsexedcf
	Local nPosDCF		:= 0
	Local cTipoNf   	:= SuperGetMv("MV_TPNRNFS")

	Private aLibSDB		:= {}
	Private aWmsAviso	:= {}
	//--
	If !lExclui
		If ! A103ConsNfeSef(PB0->PB0_CHVNFE)
			Return .F.
		EndIf
	EndIf

	//Valida Inconsistencias
	If !U_fVldXml(.T.) .AND. _lGeraPre
		MsgStop("Existem inconsistências não tratadas. Impossível gerar Pré-Nota.","Atenção")
		Return .F.
	EndIf

	l140Auto := !(Type("l140Auto")=="U" .Or. !l140Auto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a operacao e de exclusao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExclui
		aEval(aCols,{|x| x[nUsado+1] := .T.})
	Else
		aEval(aCols,{|x| lGrava := !x[nUsado+1] .Or. lGrava })
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o arquivo de Cliente/Fornecedor                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipo$"DB"
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+cA100For+cLoja)
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+cA100For+cLoja)
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao do pre-documento de entrada                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To nMaxFor
		lTravou := .F.
		Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao do cabecalho do pre-documento de entrada         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nX == 1 .And. lGrava
				dbSelectArea("PB0")
				RecLock("PB0",.F.)
				PB0->PB0_FILIAL := xFilial("PB0")
				PB0->PB0_DOC    := cNFiscal
				PB0->PB0_SERIE  := cSerie
				PB0->PB0_FORNEC := cA100For
				PB0->PB0_LOJA   := cLoja
				PB0->PB0_EMISSA := dDEmissao
				PB0->PB0_EST    := IIF(!Empty(cUfOrigP),cUfOrigP,IIf(cTipo$"DB",SA1->A1_EST,SA2->A2_EST))
				PB0->PB0_TIPO   := cTipo
				PB0->PB0_DTDIGIT:= IIf(cDtHom == "1".Or.Empty(PB0->PB0_RECBMTO),dDataBase,PB0->PB0_RECBMTO)
				PB0->PB0_RECBMTO:= PB0->PB0_DTDIGIT
				PB0->PB0_FORMUL := IIf(cFormul=="S","S","N")
				PB0->PB0_ESPECI := cEspecie
				PB0->PB0_DESPES := aDespesa[VALDESP]
				PB0->PB0_FRETE  := aDespesa[FRETE]
				PB0->PB0_SEGURO := aDespesa[SEGURO]
				PB0->PB0_COND   := cCondicao
				PB0->PB0_VENCTO := dVencto
				If l140Auto
					For nI := 1 To Len(aAutoCab)
						PB0->(FieldPut(FieldPos(aAutoCab[nI][1]),aAutoCab[nI][2]))
					Next nI
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento da gravacao do PB0 na Integridade Referencial            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PB0->(FkCommit())
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao dos itens do pre-documento de entrada            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nX <= Len(aRecPB1)
				dbSelectArea("PB1")
				MsGoto(aRecPB1[nX])
				RecLock("PB1")
				lTravou := .T.
			Else
				If !aCols[nX][nUsado+1]
					RecLock("PB1",.T.)
					lTravou := .T.
				EndIf
			EndIf
			If lTravou

				If aCols[nX][nUsado+1]
					//Apaga a PB1
					PB1->(dbDelete())
				Else
					cItem := Soma1(cItem,Len(cItem))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza os dados do acols                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nY := 1 To nUsado
						If aHeader[nY][10] <> "V"
							PB1->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
						EndIf
					Next nY
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona registros                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial("SB1")+PB1->PB1_COD)

					dbSelectArea("PB1")
					PB1->PB1_FILIAL	:= xFilial("PB1")
					PB1->PB1_FORNEC	:= cA100For
					PB1->PB1_LOJA  	:= cLoja
					PB1->PB1_DOC   	:= cNFiscal
					PB1->PB1_SERIE	:= cSerie
					PB1->PB1_EMISSA	:= dDEmissao
					PB1->PB1_DTDIGI	:= dDataBase
					PB1->PB1_GRUPO  := SB1->B1_GRUPO
					PB1->PB1_TIPO	:= cTipo
					PB1->PB1_TP		:= SB1->B1_TIPO
					PB1->PB1_FORMUL	:= IIf(cFormul=="S","S","N")
					If Empty(PB1->PB1_ITEM)
						PB1->PB1_ITEM    := cItem
					EndIf
					PB1->PB1_TIPODOC := PB0->PB0_TIPODOC
			EndIf
			If lGeraBlq .And. nX == nMaxFor
				dbSelectArea("PB0")
				Reclock("PB0",.F.)
				PB0->PB0_STATUS := "B"
				PB0->PB0_APROV  := cGrupo
				MsUnlock()
			EndIf
		EndIf

		If nX == nMaxFor .And. !lGrava
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento da gravacao do PB1 na Integridade Referencial            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PB1->(FkCommit())

			dbSelectArea("PB0")
			dbSetOrder(1)
			If MsSeek(xFilial("PB0")+cNFiscal+cSerie+cA100For+cLoja+cTipo)
				If AllTrim(PB0->PB0_ESPECI) == "SPED" .And. AliasIndic("PB0")
					PB1->(DbSetOrder(2))
					PB1->(DbSeek(xFilial("PB1")+cA100For+cLoja+cNFiscal+cSerie))
					While PB1->(!EOF()) .And. PB1->(PB1_FILIAL+PB1_FORNEC+PB1_LOJA+PB1_DOC+PB1_SERIE) == xFilial("PB1")+cA100For+cLoja+cNFiscal+cSerie
						PB1->(RecLock("PB1",.F.))
						If PB1->(FieldPos("PB1_NFORI")) > 0
							Replace PB1->PB1_NFORI With CriaVar("PB1_NFORI")
							Replace PB1->PB1_SERIOR With CriaVar("PB1_SERIOR")
							Replace PB1->PB1_ITEMORI With CriaVar("PB1_ITEMORI")
						EndIf
						PB1->(MsUnlock())
						PB1->(dbSkip())
					EndDo
				EndIf
				MsDocument("PB0", PB0->( RecNo()),2,,3) // Exclui o Banco de Conhecimentos vinculados a Pre-NF
				RecLock("PB0",.F.)
				PB0->(dbDelete())
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa os gatilhos e a confirmacao do semaforo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX == nMaxFor
			EvalTrigger()
			While ( GetSX8Len() > nSaveSX8 )
				ConfirmSx8()
			EndDo
		EndIf
	End Transaction
Next nX

If !lExclui .And. lGrava

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de e-mails para o evento 005       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MEnviaMail("005",{PB0->PB0_DOC,PB0->PB0_SERIE,PB0->PB0_FORNEC,PB0->PB0_LOJA,If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME),aPCMail})

EndIf

If _lGeraPre
	_COM01PB0()
Endif

dbSelectArea("SC7")
dbSetOrder(1)

RestArea(aArea)
Return(lGrava)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A140Impri ³ Autor ³Alexandre Inacio Lemes³ Data ³22/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a chamada do relatorio padrao ou do usuario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpX1 := A140Impri( ExpC1, ExpN1, ExpN2 )                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
±±³          ³ ExpN1 -> Recno do registro                                 ³±±
±±³          ³ ExpN2 -> Opcao do Menu                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpX1 -> Retorno do relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A140Impri( cAlias, nRecno, nOpc )

	Local xRet := a103Impri( cAlias, nRecno, nOpc )

	Pergunte("MTA140",.F.)

Return( xRet )
//*----------------------------------------------------------------------
Static Function ProcH(cCampo)
Return aScan(aAutoCab,{|x|Trim(x[1])== cCampo })


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³a140Desc   ³ Autor ³Gustavo G. Rueda      ³ Data ³30/03/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Funcao para atualizar o valor do DESCONTO no rodapeh quando ³±±
	±±³          ³ digitamos o campo PB1_DESC ou PB1_VALDESC.                   ³±±
	±±³          ³Para atualizar de acordo com o campo:                       ³±±
	±±³          ³ - PB1_DESC eh necessario criar o seguinte gatilho junto com ³±±
	±±³          ³   padroes do sistema.                                      ³±±
	±±³          ³   X7_CAMPO = PB1_DESC                                       ³±±
	±±³          ³   X7_REGRA = M->PB1_VALDESC := IIF(A140DESC(M->PB1_VALDESC), ³±±
	±±³          ³              M->PB1_VALDESC, M-PB1_VALDESC)				  ³±±
	±±³          ³   X7_CDOMIN = PB1_VALDESC                                   ³±±
	±±³          ³ - PB1_VALDESC eh necessario inserir a seguinte validacao no ³±±
	±±³          ³   SX3: A140DESC(M->PB1_VALDESC)                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ A140DESC(nValDesc)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³nValDesc -> Valor do desconto do item                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T.                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATA140                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function a140Desc (nValDesc)
	Eval (bRefresh,,,,nValDesc)
Return (.T.)
/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³Ma140DelIt ³ Autor ³Gustavo G. Rueda      ³ Data ³30/03/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Funcao para atualizar o valor do DESCONTO e do TOTAL no     ³±±
	±±³          ³ rodapeh quando marcamos como deletado determinado item.    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Ma140DelIt ()                                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T.                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATA140                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EB140DelIt ()
//	Local	aTotal		:=	{0,0,0}
//	Local	aDespesa	:=	{0,0,0,0,0,0,0,0}
//
//	Ma140Total(aTotal,aDespesa)
//	Eval (bRefresh)
Return (.F.)


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³01/11/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
	±±³          ³                                                            ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Parametros do array a Rotina:                               ³±±
	±±³          ³1. Nome a aparecer no cabecalho                             ³±±
	±±³          ³2. Nome da Rotina associada                                 ³±±
	±±³          ³3. Reservado                                                ³±±
	±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
	±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
	±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
	±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
	±±³          ³    4 - Altera o registro corrente                          ³±±
	±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
	±±³          ³5. Nivel de acesso                                          ³±±
	±±³          ³6. Habilita Menu Funcional                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef(_cTPXML)

	PRIVATE aRotina	:= {{ STR0000			,"AxPesqui"		, 0 , 1, 0, .F.},; //"Pesquisar"
	{ STR0001			,"u_E140NFISCAL"	, 0 , 2, 0, nil},; //"Visualizar"
	{ "Importar XML"	,"U__COM01XML('1')"	, 0 , 3, 0, nil},; //"Incluir"
	{ STR0003			,"u_E140NFISCAL"	, 0 , 4, 0, nil},; //"Alterar"
	{ STR0004			,"u_E140NFISCAL"	, 0 , 5, 0, nil},; //"Excluir"
	{"Inconsistências" 	,"u_E140INCONS"		, 0 , 2, 0, .F.},; //"Tela Inconsistências"
	{"Atualizar <F5>" 	,"u_AtuXML(.F.)"	, 0 , 2, 0, .F.},; //"Refresh dos produtos"
	{"Marcas" 			,"u_CADZZN"			, 0 , 2, 0, .F.},; //"Cadastro de Marcas"
	{"Fornec. X Marca"	,"u_CADZZM"			, 0 , 2, 0, .F.},; //"Cadastro de Fornecedor x Marca"
	{"Manifestar"		,"u_ManiAuto"		, 0 , 2, 0, .F.},; //"Manifestar"
	{"gerar Pre nota"	,"u_ANPRENOT"		, 0 , 2, 0, .F.},; //"Gerar Pre Nota"
	{ STR0006			,"u_AEBLegM140"		, 0 , 2, 0, .F.}}  //"Legenda"

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MaCols140 ³ Autor ³ Liber De Esteban      ³ Data ³ 10/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Montagem do aCols para GetDados.                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MaCols140()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|-cAliasPB1 ->Alias do PB1.                                  ³±±
±±³          ³-aRecPB1 -> Array com registros do PB1.                     ³±±
±±³          ³-bWhilePB1 -> Bloco com condicao para While.                ³±±
±±³          ³-nCounterPB1 -> Contador de registros do PB1, para o caso de³±±
±±³          ³nao estar usando query.                                     ³±±
±±³          ³-lQuery -> Flag de identificacao se esta usando query.      ³±±
±±³          ³-l140Inclui -> Flag que identifica se operacao e inclusao.  ³±±
±±³          ³-l140Visual -> Flag que identifica se operacao e inclusao.  ³±±
±±³          ³-lContinua -> Flag que identifica se deve continuar proc.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MaCols140(cAliasPB1,bWhilePB1,aRecOrdPB1,aRecPB1,aPedC,lItPB1Ord,lQuery,l140Inclui,l140Visual,lContinua,l140Exclui)
	Local nPos		:= 0
	Local nPosPc	:= 0
	Local nX		:= 0
	Local nY 		:= 0
	Local nCountPB1	:= 1

	If !Empty(aHeadPB1)
		aHeader := aClone(aHeadPB1)
	EndIf

	If l140Inclui
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem de uma linha em branco no aCols.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCols,Array(Len(aHeader)+1))
		For nY := 1 To Len(aHeader)
			If Trim(aHeader[nY][2]) == "PB1_ITEM"
				aCols[1][nY] 	:= StrZero(1,Len((cAliasPB1)->PB1_ITEM))
			Else
				If AllTrim(aHeader[nY,2]) == "PB1_ALI_WT"
					aCOLS[Len(aCols)][nY] := "PB1"
				ElseIf AllTrim(aHeader[nY,2]) == "PB1_REC_WT"
					aCOLS[Len(aCols)][nY] := 0
				Else
					aCols[1][nY] := CriaVar(aHeader[nY][2])
				EndIf
			EndIf
			aCols[1][Len(aHeader)+1] := .F.
		Next nY
	Else

		While Eval( bWhilePB1 )

			If !lQuery .And. (lItPB1Ord .Or. ALTERA)

				If nCountPB1 == 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Este procedimento eh necessario para fazer a montagem        ³
//³ do acols na ordem ITEM + COD quando classificacao em CDX     ³
//³ e o parametro MV_PAR03 estiver para ITEM                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aRecOrdPB1 := {}
					While ( !Eof().And. lContinua .And. ;
							(cAliasPB1)->PB1_FILIAL== xFilial("PB1") .And. ;
							(cAliasPB1)->PB1_DOC == cNFiscal .And. ;
							(cAliasPB1)->PB1_SERIE == PB0->PB0_SERIE .And. ;
							(cAliasPB1)->PB1_FORNEC == PB0->PB0_FORNEC .And. ;
							(cAliasPB1)->PB1_LOJA == PB0->PB0_LOJA )

						AAdd( aRecOrdPB1, { ( cAliasPB1 )->PB1_ITEM + ( cAliasPB1 )->PB1_COD, ( cAliasPB1 )->( Recno() ) } )

						( cAliasPB1 )->( dbSkip() )

					EndDo

					ASort( aRecOrdPB1, , , { |x,y| y[1] > x[1] } )

					bWhilePB1 := { || nCountPB1 <= Len( aRecOrdPB1 ) .And. lContinua  }
				EndIf

				If !lQuery .And. (lItPB1Ord .Or. ALTERA)
					PB1->( dbGoto( aRecOrdPB1[ nCountPB1, 2 ] ) )
				EndIf

			EndIf

			If (cAliasPB1)->PB1_TIPO == PB0->PB0_TIPO
//-- Impede a alteracao/exclusao da PreNota com Servico de WMS jah executado
				If	IntDL() .And. (l140Exclui .Or. !l140Visual) .And. FindFunction("WmsChkDCF")
					If	WmsChkDCF("PB1",,,PB1->PB1_SERVIC,'3',,PB1->PB1_DOC,PB1->PB1_SERIE,PB1->PB1_FORNEC,PB1->PB1_LOJA,PB1->PB1_LOCAL,PB1->PB1_COD,PB1->PB1_LOTECTL,PB1->PB1_NUMLOTE,PB1->PB1_NUMSEQ,PB1->PB1_ITEM)
						Aviso("SIGAWMS",STR0058,{'Ok'}) //"Documento nao pode ser alterado/excluido porque possui servicos de WMS pendentes. Antes estorne estes servicos."
						lContinua := .F.
						Loop
					EndIf
				EndIf
				If lQuery
					aadd(aRecPB1,(cAliasPB1)->PB1RECNO)
				Else
					aadd(aRecPB1,RecNo())
				EndIf

				If !l140Visual
/*If !Empty((cAliasPB1)->PB1_PEDIDO)
nPosPC := aScan(aPedC,{|y| y[1] == (cAliasPB1)->PB1_PEDIDO+(cAliasPB1)->PB1_ITEMPC})
					If nPosPc > 0
aPedC[nPosPc,2] += (cAliasPB1)->PB1_QUANT
					Else
aadd(aPedC,{(cAliasPB1)->PB1_PEDIDO+(cAliasPB1)->PB1_ITEMPC,(cAliasPB1)->PB1_QUANT})
					EndIf
				EndIf*/
			EndIf
aadd(aCols,Array(Len(aHeader)+1))
			For nY := 1 to Len(aHeader)
				If ( aHeader[nY][10] != "V")
aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
				Else
					If AllTrim(aHeader[nY,2]) == "PB1_ALI_WT"
aCOLS[Len(aCols)][nY] := "PB1"
					ElseIf AllTrim(aHeader[nY,2]) == "PB1_REC_WT"
aCOLS[Len(aCols)][nY] := If(lQuery,(cAliasPB1)->PB1RECNO,(cAliasPB1)->(RecNo()))
					Else
aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
					EndIf
				EndIf
aCols[Len(aCols)][Len(aHeader)+1] := .F.
			Next nY
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua skip na area PB1 ( regra geral ) ou incrementa o contador ³
//³ quando ordem por ITEM + CODIGO DE PRODUTO                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lQuery .And. (lItPB1Ord .Or. ALTERA)
nCountPB1++
		Else
dbSelectArea(cAliasPB1)
dbSkip()
		EndIf
	EndDo
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjustaHelp    ³ Autor ³Turibio Miranda       ³ Data ³23.02.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ajusta os helps                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AjustaHelp()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AjustaHelp()
	Local aArea 	:= GetArea()
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}

	aHelpPor :=	{"Não é possível realizar o estorno de","classificação para esta nota."}
	aHelpSpa :=	{"No es posible realizar la reversion de","clasificacion para esta factura."}
	aHelpEng :=	{"Classification reversal is not","possible for this invoice."}
	PutHelp("PA140ESTORN",aHelpPor,aHelpEng,aHelpSpa,.F.)

	aHelpPor :=	{"O estorno é possível somente para","notas fiscais já classificadas."}
	aHelpSpa :=	{"Solo es posible la reversion para","facturas ya clasificadas."}
	aHelpEng :=	{"Classification reversal is possible","only for already classified invoices."}
	PutHelp("SA140ESTORN",aHelpPor,aHelpEng,aHelpSpa,.F.)

	Restarea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ItEBPC³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tela de importacao de Pedidos de Compra por Item.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103ItEBPC()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A103ItEBPC(lUsaFiscal,aPedido,oGetDAtu,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aGets)

	Local cSeek			:= ""
	Local nOpca			:= 0
	Local aArea			:= GetArea()
	Local aAreaSA2		:= SA2->(GetArea())
	Local aAreaSC7		:= SC7->(GetArea())
	Local aAreaSB1		:= SB1->(GetArea())
	Local aRateio       := {0,0,0}
	Local aNew			:= {}
	Local aTamCab		:= {}
	Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
	Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},OemToAnsi("Visualiza Pedido"),OemToAnsi("Visualiza Pedido")},; //"Visualiza Pedido"
	{'pesquisa',{||a103PeEBP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi("Pesquisar")} } //"Pesquisar"
	Local aEstruSC7		:= SC7->( dbStruct() )
	Local bSavSetKey	:= SetKey(VK_F4,Nil)
	Local bSavKeyF5		:= SetKey(VK_F5,Nil)
	Local bSavKeyF6		:= SetKey(VK_F6,Nil)
	Local bSavKeyF7		:= SetKey(VK_F7,Nil)
	Local bSavKeyF8		:= SetKey(VK_F8,Nil)
	Local bSavKeyF9		:= SetKey(VK_F9,Nil)
	Local bSavKeyF10	:= SetKey(VK_F10,Nil)
	Local bSavKeyF11	:= SetKey(VK_F11,Nil)
	Local nFreeQt		:= 0
	Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_COD" })
	Local nPosPDD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_PEDIDO" })
	Local nPosITM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_ITEMPC" })
	Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT" })
	Local nPosTes       := aScan(aHeader,{|x| AllTrim(x[2])=="PB1_TES"})
	Local nLinACols     := N
	Local cVar			:= aCols[n][nPosPrd]
	Local cQuery		:= ""
	Local cAliasSC7		:= "SC7"
	Local cQueryQPC     := ""
	Local cCpoObri		:= ""
	Local nSavQual
	Local nPed			:= 0
	Local nX			:= 0
	Local nAuxCNT		:= 0
	Local lMt103Vpc		:= ExistBlock("MT103VPC")
	Local lMt100C7D		:= ExistBlock("MT100C7D")
	Local lMt100C7C		:= ExistBlock("MT100C7C")
	Local lMt103Sel		:= ExistBlock("MT103SEL")
	Local cRestNFE		:= SuperGetMV("MV_RESTNFE")
	Local nMT103Sel     := 0
	Local nSelOk        := 1
	Local lRet103Vpc	:= .T.
	Local lContinua		:= .T.
	Local lQuery		:= .F.
	Local oQual
	Local oDlg
	Local oPanel
	Local aUsButtons  := {}

	PRIVATE aCab	   := {}
	PRIVATE aCampos	   := {}
	PRIVATE aArrSldo   := {}
	PRIVATE aArrayF4   := {}

	DEFAULT lUsaFiscal := .T.
	DEFAULT aPedido	   := {}
	DEFAULT lNfMedic   := .F.
	DEFAULT lConsMedic := .F.
	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}
	DEFAULT aGets      := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("InConPad") == "L"
		lContinua := !InConPad
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock( "MTIPCBUT" )
		If ValType( aUsButtons := ExecBlock( "MTIPCBUT", .F., .F. ) ) == "A"
			AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
		EndIf
	EndIf

	If lContinua

		If MaFisFound('NF') .Or. !lUsaFiscal
			If cTipo == 'N'
				#IFDEF TOP
					DbSelectArea("SC7")
					If TcSrvType() <> "AS/400"

						If Empty(cVar)
							DbSetOrder(9)
						Else
							DbSetOrder(6)
						EndIf

						lQuery    := .T.
						cAliasSC7 := "QRYSC7"

						cQuery	  := "SELECT "
						For nAuxCNT := 1 To Len( aEstruSC7 )
							If nAuxCNT > 1
								cQuery += ", "
							EndIf
							cQuery += aEstruSC7[ nAuxCNT, 1 ]
						Next
						cQuery += ", R_E_C_N_O_ RECSC7 FROM "
						cQuery += RetSqlName("SC7") + " SC7 "
						cQuery += "WHERE "
						cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

						If HasTemplate( "DRO" ) .AND. FunName() == "MATA103" .AND. MV_PAR15 == 1
							cQuery += "C7_FORNECE IN ( " + T_DrogForn( cA100For ) + " ) AND "
						Else
							If Empty(cVar)
								If lConsLoja
									cQuery += "C7_FORNECE = '"+cA100For+"' AND "
									cQuery += "C7_LOJA = '"+cLoja+"' AND "
								Else
									cQuery += "C7_FORNECE = '"+cA100For+"' AND "
								Endif
							Else
								If lConsLoja
									cQuery += "C7_FORNECE = '"+cA100For+"' AND "
									cQuery += "C7_LOJA = '"+cLoja+"' AND "
									cQuery += "C7_PRODUTO = '"+cVar+"' AND "
								Else
									cQuery += "C7_FORNECE = '"+cA100For+"' AND "
									cQuery += "C7_PRODUTO = '"+cVar+"' AND "
								Endif
							Endif
						EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra os pedidos de compras de acordo com os contratos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lConsMedic
							If lNfMedic
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Traz apenas os pedidos oriundos de medicoes                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
								cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "
							Else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Traz apenas os pedidos que nao possuem medicoes                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
								cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "
							EndIf
						EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra os Pedidos Bloqueados e Previstos.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cQuery += "C7_TPOP <> 'P' AND "
						If cRestNFE == "S"
							cQuery += "C7_CONAPRO <> 'B' AND "
						EndIf
						cQuery += "SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "
						cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "

						cQuery += "SC7.D_E_L_E_T_ = ' '"
						cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))

						cQuery := ChangeQuery(cQuery)

//---------------------------//
//Ponto de Entrada: MT103QPC //
//---------------------------//
						If ExistBlock("MT103QPC")
							cQueryQPC := ExecBlock("MT103QPC",.F.,.F.,{cQuery,2})
							If (ValType(cQueryQPC) == 'C' )
								cQuery := cQueryQPC
								cQuery := ChangeQuery(cQuery)
							EndIf
						EndIf

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

						For nX := 1 To Len(aEstruSC7)
							If aEstruSC7[nX,2]<>"C"
								TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
							EndIf
						Next nX
					Else
					#ENDIF
					If Empty(cVar)
						DbSelectArea("SC7")
						DbSetOrder(9)
						If lConsLoja
							cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
							cSeek := cA100For+cLoja
							MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
						Else
							cCond := "C7_FILENT+C7_FORNECE"
							cSeek := cA100For
							MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
						EndIf
					Else
						DbSelectArea("SC7")
						DbSetOrder(6)
						If lConsLoja
							cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
							cSeek := cVar+cA100For+cLoja
							MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
						Else
							cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
							cSeek := cVar+cA100For
							MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
						EndIf
					EndIf
					#IFDEF TOP
					EndIf
				#ENDIF

				If Empty(cVar)
					cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_TIPO|C7_LOCAL|C7_OBS"
				Else
					cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
				Endif

				If (cAliasSC7)->(!Eof())

					DbSelectArea("SX3")
					DbSetOrder(2)

					If lNfMedic .And. lConsMedic

						MsSeek("C7_MEDICAO")

						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

						MsSeek("C7_CONTRA")

						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

						MsSeek("C7_PLANILH")

						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					EndIf

					MsSeek("C7_NUM")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_DESCRI")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					DbSelectArea("SX3")
					DbSetOrder(1)
					MsSeek("SC7")
					While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
						IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_NUM" .And. AllTrim(SX3->X3_CAMPO)<>"C7_DESCRI" .And.;
								If( lConsMedic .And. lNfMedic, AllTrim(SX3->X3_CAMPO)<>"C7_MEDICAO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_CONTRA" .And. AllTrim(SX3->X3_CAMPO)<>"C7_PLANILH", .T. )).Or.;
									(AllTrim(SX3->X3_CAMPO) $ cCpoObri)
								AAdd(aCab,x3Titulo())
								Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
								aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
							EndIf
							dbSkip()
						Enddo

						DbSelectArea(cAliasSC7)
						Do While If(lQuery, ;
								(cAliasSC7)->(!Eof()), ;
								(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !lQuery
								If (cRestNFE == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;
										(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
									dbSkip()
									Loop
								EndIf
							Endif

							nFreeQT := 0
							nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})
							nFreeQT += If(nPed>0,aPedido[nPed,2],0)

							For nAuxCNT := 1 To Len( aCols )
								If (nAuxCNT # n) .And. ;
										(aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
										(aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM)     .And. ;
										(aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM)    .And. ;
										!ATail( aCols[ nAuxCNT ] )
									nFreeQT += aCols[ nAuxCNT,nPosQTD ]
								EndIf
							Next

							lRet103Vpc := .T.

							If lMt103Vpc
								If lQuery
									('SC7')->(dbGoto((cAliasSC7)->RECSC7))
								EndIf
								lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
							Endif

							If lRet103Vpc
								If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
									Aadd(aArrayF4,Array(Len(aCampos)))

									SB1->(DbSetOrder(1))
									SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))
									For nX := 1 to Len(aCampos)

										If aCampos[nX][3] != "V"
											If aCampos[nX][2] == "N"
												If Alltrim(aCampos[nX][1]) == "C7_QUANT"
													aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
												ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
													aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
												Else
													aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
												Endif
											Else
												aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))
											Endif
										Else
											aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
											If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
												aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO
											EndIf
											If Alltrim(aCampos[nX][1]) == "C7_CODITE"
												aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
											EndIf
										Endif

									Next

									aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

									If lMT100C7D
										If lQuery
											('SC7')->(dbGoto((cAliasSC7)->RECSC7))
										EndIf
										aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
										If ValType(aNew) = "A"
											aArrayF4[Len(aArrayF4)] := aNew
										EndIf
									EndIf
								EndIf
							Endif
							(cAliasSC7)->(dbSkip())
						EndDo

						If ExistBlock("MT100C7L")
							ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
						EndIf

						If !Empty(aArrayF4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta dinamicamente o bline do CodeBlock                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DEFINE MSDIALOG oDlg FROM 30,20  TO 265,621 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item )") Of oMainWnd PIXEL //"Selecionar Pedido de Compra ( por item )"

							If lMT100C7C
								aNew := ExecBlock("MT100C7C", .f., .f., aCab)
								If ValType(aNew) == "A"
									aCab := aNew

									DbSelectArea("SX3")
									DbSetOrder(2)

									For nX := 1 to Len(aCab)
										If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
											If SX3->(MsSeek(aCab[nX]))
												Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
											EndIf
										EndIf
									Next nX
								EndIf
							EndIf

							@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
							oPanel:Align := CONTROL_ALIGN_TOP

							oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
							oQual:SetArray(aArrayF4)
							oQual:bLine := { || aArrayF4[oQual:nAT] }
							OQual:nFreeze := 2

							oQual:Align := CONTROL_ALIGN_ALLCLIENT

							If !Empty(cVar)
								@ 6  ,4   SAY OemToAnsi("Produto") Of oPanel PIXEL SIZE 47 ,9 //"Produto"
								@ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9
							Else
								@ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra") Of oPanel PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
							EndIf

							ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)

							If lMt103Sel .And. !Empty(nSavQual)
								nOpca := If(ValType(nMT103Sel:=ExecBlock("MT103SEL",.F.,.F.,{aArrSldo[nSavQual][2]}))=='N',nMT103Sel,nOpca)
							Endif
							If nOpca == 1
								DbSelectArea("SC7")
								MsGoto(aArrSldo[nSavQual][2])

// Verifica se o Produto existe Cadastrado na Filial de Entrada
								DbSelectArea("SB1")
								DbSetOrder(1)
								MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)
								If !Eof()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Qdo digitado o produto no aCols para buscar o PC via F6 e carregado uma TES vinda do  ³
//³ SB1 se esta for igual a TES digitada no PC o recalculo dos impostos nao e acionado    ³
//³ na matxfis,para forcar o recalculo o TES do aCols e limpa neste ponto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If lUsaFiscal
										aCols[nLinACols][nPosTes] := CriaVar(aHeader[nPosTes][2])
										MaFisAlt("IT_TES",aCols[nLinACols][nPosTes],nLinACols)
									EndIf

									If	!ATail( aCols[ n ] )
										NFePB0Acol(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)
									Else
										NFePB0Acol(aArrSldo[nSavQual][2],n+1,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)
									EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If ValType( oGetDAtu ) == "O"
										oGetDAtu:lNewLine := .F.
									Else
										If Type( "oGetDados" ) == "O"
											oGetDados:lNewLine:=.F.
										EndIf
									EndIf
								Else
									Aviso("A103ItEBPC","Ok",{"Ok"})
								EndIf
							EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rateio do valores de Frete/Seguro/Despesa do PC            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lUsaFiscal
								Eval(bRefresh)
							Else
								aGets[SEGURO] += aRateio[1]
								aGets[VALDESP]+= aRateio[2]
								aGets[FRETE]  += aRateio[3]
							EndIf
						Else
							Help(" ",1,"A103F4")
						EndIf
					Else
						Help(" ",1,"A103F4")
					EndIf
				Else
					Help('   ',1,'A103TIPON')
				EndIf
			Else
				Help('   ',1,'A103CAB')
			EndIf

		Endif

		If lQuery
			DbSelectArea(cAliasSC7)
			dbCloseArea()
			DbSelectArea("SC7")
		Endif

		RestArea(aAreaSA2)
		RestArea(aAreaSC7)
		RestArea(aAreaSB1)
		RestArea(aArea)
/*/
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡„o    ³a103PeEBP ³ Autor ³ Henry Fila            ³ Data ³17.07.2002 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³          ³Seek no browse de itens de pedidos de compra                 ³±±
		±±³          ³                                                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpA1 : Array das descricoes dos cabecalhos                  ³±±
		±±³          ³ExpA2 : Array com os campos                                  ³±±
		±±³          ³ExpA3 : Array com os conteudos                               ³±±
		±±³          ³ExpO4 : Objeto do listbox                                    ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorno   ³Nenhum                                                       ³±±
		±±³          ³                                                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡„o ³Esta rotina tem como objetivo abrir uma janela de pesquisa   ³±±
		±±³          ³em browses de getdados poisicionando na llinha caso encontre ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Uso       ³ Generico                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function a103PeEBP(aCab,aCampos,aArrayF4,oQual)

	Local aCpoBusca	:= {}
	Local aCpoPict	:= {}
	Local aComboBox	:= { AllTrim( "Exata" ) , AllTrim( "Parcial" ) , AllTrim( "Contem" ) } //"Exata"###"Parcial"###"Contem"

	Local bAscan	:= { || .F. }

	Local cPesq		:= Space(30)
	Local cBusca	:= ""
	Local cTitulo	:= OemtoAnsi("Pesquisar")  //"Pesquisar"
	Local cOpcAsc	:= aComboBox[1]	//"Exata"
	Local cAscan	:= ""

	Local nOpca		:= 0
	Local nPos		:= 0
	Local nx		:= 0
	Local nTipo		:= 1
	Local nBusca	:= Iif(oQual:nAt == Len(aArrayF4) .Or. oQual:nAt == 1, oQual:nAt, oQual:nAt+1 )

	Local oDlg
	Local oBusca
	Local oPesq1
	Local oPesq2
	Local oPesq3
	Local oPesq4
	Local oComboBox

	For nX := 1 to Len(aCampos)
		AAdd(aCpoBusca,aCab[nX])
		AAdd(aCpoPict,aCampos[nX][4])
	Next

	If Len(aCampos) > 0 .And. Len(aArrayF4) > 0

		DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo)  FROM 00,0 TO 100,490 OF oMainWnd PIXEL

		@ 05,05 MSCOMBOBOX oBusca VAR cBusca ITEMS aCpoBusca SIZE 206, 36 OF oDlg PIXEL ON CHANGE (nTipo := oBusca:nAt,A103ChgPic(nTipo,aCampos,@cPesq,@oPesq1,@oPesq2,@oPesq3,@oPesq4))

		@ 022,005 MSGET oPesq1 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		@ 022,005 MSGET oPesq2 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		@ 022,005 MSGET oPesq3 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
		@ 022,005 MSGET oPesq4 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Hide()
		oPesq4:Hide()

		Do Case
		Case aCampos[1][2] == "C"
			DbSelectArea("SX3")
			DbSetOrder(2)
			If MsSeek(aCampos[1][1])
				If !Empty(SX3->X3_F3)
					oPesq2:cF3 := SX3->X3_F3
					oPesq1:Hide()
					oPesq2:Show()
					oPesq3:Hide()
					oPesq4:Hide()
				Else
					oPesq1:Show()
					oPesq2:Hide()
					oPesq3:Hide()
					oPesq4:Hide()
				Endif
			Endif

		Case aCampos[1][2] == "D"
			oPesq1:Hide()
			oPesq2:Hide()
			oPesq3:Show()
			oPesq4:Hide()

		Case aCampos[1][2] == "N"
			oPesq1:Hide()
			oPesq2:Hide()
			oPesq3:Hide()
			oPesq4:Show()
		EndCase

		cPesq := CriaVar(aCampos[1][1],.F.)
		cPict := aCampos[1][4]

		DEFINE SBUTTON oBut1 FROM 05, 215 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg
		DEFINE SBUTTON oBut1 FROM 20, 215 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg

		@ 037,005 SAY OemtoAnsi("Tipo") SIZE 050,10 OF oDlg PIXEL //Tipo
		@ 037,030 MSCOMBOBOX oComboBox VAR cOpcAsc ITEMS aComboBox SIZE 050,10 OF oDlg PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 1
			Do Case
			Case aCampos[nTipo][2] == "C"
				IF ( cOpcAsc == aComboBox[1] )	//Exata
					cAscan := Padr( Upper( cPesq ) , TamSx3(aCampos[nTipo][1])[1] )
					bAscan := { |x| cAscan == Upper( x[ nTipo ] ) }
				ElseIF ( cOpcAsc == aComboBox[2] )	//Parcial
					cAscan := Upper( AllTrim( cPesq ) )
					bAscan := { |x| cAscan == Upper( SubStr( Alltrim( x[nTipo] ) , 1 , Len( cAscan ) ) ) }
				ElseIF ( cOpcAsc == aComboBox[3] )	//Contem
					cAscan := Upper( AllTrim( cPesq ) )
					bAscan := { |x| cAscan $ Upper( Alltrim( x[nTipo] ) ) }
				EndIF
				nPos := Ascan( aArrayF4 , bAscan )

			Case aCampos[nTipo][2] == "N"
				nPos := Ascan(aArrayF4,{|x| Transform(cPesq,PesqPict("SC7",aCampos[nTipo][1])) == x[nTipo]},nBusca)

			Case aCampos[nTipo][2] == "D"
				nPos := Ascan(aArrayF4,{|x| Dtos(cPesq) == Dtos(x[nTipo])},nBusca)
			EndCase

			If nPos > 0
				oQual:bLine := { || aArrayF4[oQual:nAT] }
				oQual:nFreeze := 1
				oQual:nAt := nPos
				oQual:Refresh()
				oQual:SetFocus()
			Else
				Help(" ",1,"REGNOIS")
			Endif
		EndIf
	Endif

Return
/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³A103Legenda³ Autor ³ Edson Maricate       ³ Data ³ 01.02.99 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATA103                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AEBLegM140()

	Local aLegenda := {}

	aAdd(aLegenda, {"BR_AMARELO","Docto. com Inconsistências"})
	aAdd(aLegenda, {"BR_LARANJA","Docto. preparado p/geracao da Pre-Nota"})
	aAdd(aLegenda, {"DISABLE"   ,"Pre-Nota Gerada"})
	aAdd(aLegenda, {"BR_VIOLETA","Pre-Nota Manual"})

	BrwLegenda(cCadastro,"Legenda" ,aLegenda) //"Legenda"

Return .T.

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³NFePB0Acol³ Autor ³ Edson Maricate        ³ Data ³27.01.2000 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Esta rotina atualiza o acols com base no item do pedido de   ³±±
	±±³          ³compra                                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpN1 : Numero do registro do SC7                            ³±±
	±±³          ³ExpN2 : Item da NF                                           ³±±
	±±³          ³ExpN3 : Saldo do Pedido                                      ³±±
	±±³          ³ExpC4 : Item a ser carregado no aCols ( D1_ITEM )            ³±±
	±±³          ³ExpL5 : Indica se os dados da Pre-Nota devem ser preservados ³±±
	±±³          ³ExpA6 : Valores das despesas acessorias do pedido de compras ³±±
	±±³          ³ExpN4 : Preco unitário na Pré-Nota						   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpL1: Sempre .T.                                            ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta rotina tem como objetivo atualizar a funcao fiscal com  ³±±
	±±³          ³base no item do pedido de compra.                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NFePB0Acol(nRecSC7,nItem,nSalPed,cItem,lPreNota,aRateio,aHeadSDE,aColsSDE,nPrUPreNf)

	Local aArea		  := GetArea()
	Local aAreaSC7	  := SC7->(GetArea())
	Local aAreaSF4	  := SF4->(GetArea())
	Local aAreaSB1	  := SB1->(GetArea())
	Local aRefSC7     := MaFisSXRef("SC7")
	Local nX          := 0
	Local nCntFor     := 0
	Local nPosQtd     := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_QUANT"})
	Local nPosQtd2    := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_QTSEGU"})
	Local nPosTes     := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_TES"})
	Local lRateioPC   := SuperGetMv("MV_NFEDAPC")
	Local lAllPC      := .T.
	Local lAltImpPreNf:= .F.

	Local nPosTot     := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_TOTAL"})

	DEFAULT aHeadSDE  := {}
	DEFAULT aColsSDE  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Final(OemToAnsi(STR0051)+" SIGACUS.PRW !!!")
	Endif
	IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Final(OemToAnsi(STR0051)+" SIGACUSA.PRX !!!")
	Endif
	IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Final(OemToAnsi(STR0051)+" SIGACUSB.PRX !!!")
	Endif

	DEFAULT lPreNota := .F.
	DEFAULT aRateio  := {0,0,0}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do item do acols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nItem == Nil .Or. nItem > Len(aCols)
		aadd(aCols,Array(Len(aHeader)+1))
		For nX := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nX][2])
				aCols[Len(aCols)][nX] := 0
			ElseIf IsHeadAlias(aHeader[nX][2])
				aCols[Len(aCols)][nX] := "SD1"
			ElseIf Trim(aHeader[nX][2]) == "PB1_ITEM"
				aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(PB1->PB1_ITEM)))
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2], (aHeader[nX][10] <> "V") )
			EndIf
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		Next nX
		nItem := Len(aCols)
	EndIf

	If Empty(aHeadSDE)
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SDE")
		While !EOF() .And. (SX3->X3_ARQUIVO == "SDE")
			IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"DE_CUSTO"$SX3->X3_CAMPO
				AADD(aHeadSDE,{ TRIM(x3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ADHeadRec("SDE",aHeadSDE)
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	MsGoto(nRecSC7)
	lAllPC := SC7->C7_QUANT==nSalPed .And. Empty(SC7->C7_REAJUST)

	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega os impostos do pedido de compra para o Doc.Entrada   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MaFisFound()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem a condicao de pagamento do pedido de compra        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Empty(cCondicao) .And. l103Class) .Or. !l103Class
			cCondicao := SC7->C7_COND
		EndIf

		MaFisIniLoad(nItem)
		For nX := 1 To Len(aRefSc7)
			Do Case
			Case aRefSC7[nX][2] == "IT_QUANT"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nSalPed,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_PRCUNI"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],NfePcReaj(SC7->C7_REAJUST,lReajuste),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALMERC"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],IIF(lAllPC,xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,,M->dDEmissao,,SC7->C7_TXMOEDA,),NoRound(nSalPed*NfePcReaj(SC7->C7_REAJUST,lReajuste),TamSX3('PB1_TOTAL')[2])),nItem)
				Endif
			Case aRefSc7[nX][2] == "IT_DESCONTO"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],xMoeda(((SC7->C7_VLDESC/SC7->C7_QUANT)* nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALEMB"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALEMB,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
			Case aRefSc7[nX][2] == "IT_SEGURO"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_SEGURO,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[1] += xMoeda(SC7->C7_SEGURO,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_DESPESA"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[2] += xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_FRETE"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALFRE,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[3] += xMoeda(SC7->C7_VALFRE,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_TES"
				If !Empty(SC7->C7_TES)
					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(xFilial("SF4")+SC7->C7_TES)
					MaFisLoad("IT_CF",MaFisCFO(nItem,SF4->F4_CF),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEICM"
				If !lPreNota .Or. Empty(PB1->PB1_BASEICM) .Or. PB1->PB1_BASEICM == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQICM"
				If !lPreNota .Or. Empty(PB1->PB1_PICM) .Or. PB1->PB1_PICM == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_VALICM"
				If !lPreNota .Or. Empty(PB1->PB1_VALICM) .Or. PB1->PB1_VALICM == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEIPI"
				If !lPreNota .Or. Empty(PB1->PB1_BASEIPI) .Or. PB1->PB1_BASEIPI == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQIPI"
				If !lPreNota .Or. Empty(PB1->PB1_IPI) .Or. PB1->PB1_IPI == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf

			Case aRefSc7[nX][2] == "IT_VALIPI"
				If !lPreNota .Or. Empty(PB1->PB1_VALIPI) .Or. PB1->PB1_VALIPI == SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
					If SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))) <> 0
						MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			OtherWise
				MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
			EndCase
		Next nX
		MaFisEndLoad(nItem)
	Else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem a condicao de pagamento do pedido de compra        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCondicao := SC7->C7_COND
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o acols com base no pedido de compras               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lPreNota
		For nCntFor := 1 To Len(aHeader)
			Do Case
			Case Trim(aHeader[nCntFor,2]) == "PB1_COD"
				aCols[nItem,nCntFor] := SC7->C7_PRODUTO
//Case Trim(aHeader[nCntFor,2]) == "PB1_PEDIDO"
//aCols[nItem,nCntFor] := SC7->C7_NUM
//Case Trim(aHeader[nCntFor,2]) == "PB1_ITEMPC"
//aCols[nItem,nCntFor] := SC7->C7_ITEM
			Case Trim(aHeader[nCntFor,2]) == "PB1_LOCAL"
				aCols[nItem,nCntFor] := SC7->C7_LOCAL
//Case Trim(aHeader[nCntFor,2]) == "PB1_VUNIPC"
//aCols[nItem,nCntFor] := SC7->C7_PRECO
			Case Trim(aHeader[nCntFor,2]) == "PB1_CC"
				aCols[nItem,nCntFor] := SC7->C7_CC
			Case Trim(aHeader[nCntFor,2]) == "PB1_ITEMCTA"			// Item Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_ITEMCTA), SB1->B1_ITEMCC, SC7->C7_ITEMCTA )
			Case Trim(aHeader[nCntFor,2]) == "PB1_CONTA"				// Conta Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CONTA), SB1->B1_CONTA, SC7->C7_CONTA )
			Case Trim(aHeader[nCntFor,2]) == "PB1_UM"
				aCols[nItem,nCntFor] := SC7->C7_UM
			Case Trim(aHeader[nCntFor,2]) == "PB1_QUANT"
				aCols[nItem,nCntFor] := ( SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA )
			Case Trim(aHeader[nCntFor,2]) == "PB1_DESCRI"
				aCols[nItem,nCntFor] := SC7->C7_DESCRI
			Case Trim(aHeader[nCntFor,2]) == "PB1_VALDESC"
				aCols[nItem,nCntFor] := xMoeda(((SC7->C7_VLDESC/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			Case Trim(aHeader[nCntFor,2]) == "PB1_RATEIO" .And. !Empty( SC7->( FieldPos( "C7_RATEIO" ) ) )
				aCols[nItem,nCntFor] := SC7->C7_RATEIO
			Case Trim(aHeader[nCntFor,2]) == "PB1_CODGRP"
				aCols[nItem,nCntFor] := SB1->B1_GRUPO
			Case Trim(aHeader[nCntFor,2]) == "PB1_CODITE"
				aCols[nItem,nCntFor] := SB1->B1_CODITE
			Case Trim(aHeader[nCntFor,2]) == "PB1_CLASFI"
				aCols[nItem,nCntFor] := SubStr(SB1->B1_ORIGEM,1,1)
			Case Trim(aHeader[nCntFor,2]) == "PB1_IPI"
				If !Empty(SC7->C7_IPI)
					aCols[nItem,nCntFor] := SC7->C7_IPI
				Else
					aCols[nItem,nCntFor] := SB1->B1_IPI
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "PB1_PICM"
				If !Empty(SC7->C7_PICM)
					aCols[nItem,nCntFor] := SB1->B1_PICM
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "PB1_ITEMMED"
				aCols[nItem,nCntFor] := If( !Empty( SC7->C7_CONTRA ) .And. !Empty( SC7->C7_MEDICAO ), "1", "2" )
			Case Trim(aHeader[nCntFor,2]) == "PB1_DTVALID"
				If Rastro(SC7->C7_PRODUTO)
					aCols[nItem,nCntFor] := dDataBase + SB1->B1_PRVALID
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "PB1_TPCONV"
				aCols[nItem,nCntFor] := " "
			Case Trim(aHeader[nCntFor,2]) == "PB1_FATOR"
				aCols[nItem,nCntFor] := 0
			EndCase

		Next nCntFor

		If !MaFisFound()
			aRateio[1] += xMoeda(SC7->C7_SEGURO ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[2] += xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[3] += xMoeda(SC7->C7_VALFRE ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
		EndIf

//Complementa o rateio da nota fiscal de saida com o rateio do pedido de compras
		If AliasInDic("SCH")
			cItemRat := IIF(cItem<>Nil,cItem,StrZero(nItem,Len(PB1->PB1_ITEM)))
			RatPed2NF(aHeadSDE,@aColsSDE,cItemRat,nRecSC7)
		EndIf

// 1 - utilização a associação automática com o PMS
// 2 - não utiliza a associação automática com o PMS
// default: não utilizar a associação automática
		If GetMV("MV_INTPMS",,"N") == "S" .And. GetNewPar("MV_PMSIPC",  2) == 1
			PMS103IPC(nItem)
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua a chamada dos pontos de entrada                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistTemplate( "MT103IPC",,.T. )
			ExecTemplate( "MT103IPC", .F., .F.,{nItem})
		EndIf

		If ExistBlock( "MT103IPC",,.T. )
			ExecBlock( "MT103IPC", .F., .F.,{nItem})
		EndIf

		If ExistBlock( "MT103RCC",,.T. )
			aColsSDE := ExecBlock( "MT103RCC", .F., .F.,{aHeadSDE,aColsSDE})
		EndIf
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando ha TES no pedido de compra, deve-se recalcular os     ³
//³ impostos carregados para verificar se nao ha novos impostos  ³
//³ que devem ser calculados!                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MaFisFound()
		Do Case
		Case cA100For+cLoja <> SC7->C7_FORNECE+SC7->C7_LOJA
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_ALIQICM",0,nItem)
			MaFisAlt("IT_ALIQIPI",0,nItem)
			If Empty(SC7->C7_TES)
				MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
			Else
				MaFisAlt("IT_TES",SC7->C7_TES,nItem)
			EndIf
		Case Empty(SC7->C7_TES) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_TE"))
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
		Case Empty(SC7->C7_TES) .And. Empty(RetFldProd(SB1->B1_COD,"B1_TE")) .And. nPosTes > 0
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",IF( aCols[nItem,nPosTes] == Nil,CriaVar("PB1_TES"),aCols[nItem,nPosTes] ),nItem)
		Case !Empty(SC7->C7_TES)
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",SC7->C7_TES,nItem)
			If lAllPC .And. !lAltImpPreNf
// Quando for Relacionar o Pedido a Nf ou preço unitário da Pré-Nf for igual ao Pedido, entra na Rotina
// Caso Preço Unitário da Pré-Nf for divergente do pedido, prevalece o preço da Pré-Nf mesmo que a quantidade do pedido seja igual.
				If nPrUPreNf ==Nil .Or. (nPrUPreNf-SC7->C7_PRECO)=0
					For nX := 1 To Len(aRefSc7)
						Do Case
						Case !("IT_BAS"$aRefSc7[nX][2] .Or. "IT_VAL"$aRefSc7[nX][2] .Or. "IT_ALIQ"$aRefSc7[nX][2])
//Não fazer nada
						Case aRefSc7[nX][2] == "IT_VALIPI"
							MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->C7_VALIPI,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
						Case aRefSc7[nX][2] == "IT_VALICM"
							MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->C7_VALICM,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
						Case aRefSc7[nX][2] == "IT_VALMERC"
							MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
						Case aRefSc7[nX][2] == "IT_BASEICM"
							MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->C7_BASEICM,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
						Case aRefSc7[nX][2] == "IT_BASEIPI"
							MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->C7_BASEIPI,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
						OtherWise
							If !Empty(SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))))
								MaFisAlt(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
							EndIf
						EndCase
					Next nX
				EndIf
			EndIf
		EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para tratamentos diversos após o recalculo de ³
//³ impostos carregados a partir da TES correspondente.	     	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "MT103IP2",,.T. )
			ExecBlock( "MT103IP2", .F., .F.,{nItem})
		EndIf
		MaFisToCols(aHeader,aCols,,"MT100")
	EndIf
	RestArea(aAreaSB1)
	RestArea(aAreaSF4)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  05/31/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_COM01PB0 ºAutor  ³Microsiga           º Data ³  17/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusão dos documentos de entrada                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 10.1 - SIGMA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _COM01PB0(_lRet,lMenu)

	Local _aArea	:= GetArea()
	Local _aAreaPB0 := GetArea()
	Local _aNFRem	:= {}
	Local _lCompl	:= IIF(PB0->PB0_TIPO == "C" .and. Substr(PB0->PB0_ESPECI,1,2) == "CT",.T.,.F.)
	Local _lPreNota	:= IIF(PB0->PB0_TIPO == "N" .and. Substr(PB0->PB0_ESPECI,1,2) == "CT",.F.,.T.)
	Local lSaida	:= .T.
	Local _cDocOri
	Local _cSerOri
	Local _nDocOri
	Local _nTamDoc
	Local _cChOri
	Local _cMens
	Local _nT
	Local _cCliFor
	Local _cLoja
	Local aCabec
	Local nPosTES
	Local cCondicao := ""

	Local aTesPed := {}

	Private lMsErroAuto := .f.
	Private _cFornOri

	Default lMenu := .F.

	_cCliFor := PB0->PB0_FORNEC
	_cLoja   := PB0->PB0_LOJA

// flag de pre-nota
/*
	If PB0->PB0_TRANFI == "S"
_lPreNota := .F.
	Else
_lPreNota := .T.
	Endif
*/

//Verifica se NF já foi digitada
/*
dbSelectArea("SF1")
dbSetOrder(8)
	If dbSeek(xFilial()+PB0->PB0_CHVNFE)
Alert("NF ja incluida")
// atualiza tabela
TCSqlExec("UPDATE "+RetSqlName("PB0")+" SET PB0_STATUS = '2' WHERE D_E_L_E_T_ = ' ' AND PB0_FILIAL = '"+XFilial("PB0")+"' AND PB0_DOC = '"+PB0->PB0_DOC+"' AND PB0_SERIE = '"+PB0->PB0_SERIE+"' AND PB0_CNPJ = '"+PB0->PB0_CNPJ+"'")
TcSqlExec("COMMIT")
RestArea(_aAreaF1)
RestArea(_aArea)
Return()
	Endif
*/
	RestArea(_aArea)
// Cabecalho da nota fiscal de entrada
	aCabec   := {}
	If !_lCompl
		aadd(aCabec,{"F1_FILIAL"   	,PB0->PB0_FILIAL})
		aadd(aCabec,{"F1_TIPO"   	,PB0->PB0_TIPO})
		aadd(aCabec,{"F1_FORMUL" 	,PB0->PB0_FORMUL})
		aadd(aCabec,{"F1_DOC"    	,PB0->PB0_DOC})
		aadd(aCabec,{"F1_SERIE"  	,PB0->PB0_SERIE})
		aadd(aCabec,{"F1_EMISSAO"	,PB0->PB0_EMISSA})
		aadd(aCabec,{"F1_FORNECE"	,_cCliFor})
		aadd(aCabec,{"F1_LOJA"   	,_cLoja})
		aadd(aCabec,{"F1_ESPECIE"	,PB0->PB0_ESPECI})
		If Substr(PB0->PB0_ESPECI,1,2) == "CT"
			aadd(aCabec,{"F1_COND"		,"01"})
		Else
			aadd(aCabec,{"F1_COND"		,PB0->PB0_COND})
		End If
		aadd(aCabec,{"F1_CHVNFE"	,PB0->PB0_CHVNFE})
		aadd(aCabec,{"F1_DESPESA"	,PB0->PB0_DESPES})
		aadd(aCabec,{"F1_FRETE"		,PB0->PB0_FRETE})
		aadd(aCabec,{"F1_SEGURO"	,PB0->PB0_SEGURO})
		If Substr(PB0->PB0_ESPECI,1,2) == "CT"
			aadd(aCabec,{"E2_NATUREZ"	,"2101002"})
		End If
		// incluido por Gustavo Costa 23/09/2021
		aadd(aCabec,{"F1_UFORITR"	,PB0->PB0_UFORIT})
		aadd(aCabec,{"F1_UFDESTR"	,PB0->PB0_UFDEST})
		aadd(aCabec,{"F1_MUORITR"	,PB0->PB0_MUORIT})
		aadd(aCabec,{"F1_MUDESTR"	,PB0->PB0_MUDEST})

	Endif

// Itens da nota fiscal de entrada
	_cChave  := PB0->(PB0_FILIAL+PB0_DOC+PB0_SERIE+PB0_FORNEC+PB0_LOJA)
	_dEmiss  := PB0->PB0_EMISSA
	aItens := {}
	_nLoop := 1
	PB1->(dbSetOrder(13))
	PB1->(dbSeek(_cChave))

	While PB1->(!Eof()) .and. PB1->(PB1_FILIAL+PB1_DOC+PB1_SERIE+PB1_FORNEC+PB1_LOJA) == _cChave
		If _dEmiss == PB1->PB1_EMISSA
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFilial("SB1")+PB1->PB1_COD))

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+PB1->PB1_TES))

			aLinha  := {}
			_aNFRem := {}
			If SF4->F4_PODER3 == "D"

				_aNFRem := Bxa_NFPD4(_cCliFor, _cLoja, PB1->PB1_COD, PB1->PB1_QUANT)
				If Empty(_aNFRem)
					Alert("Não encontrado saldo do produto "+Rtrim(PB1->PB1_COD)+" do cliente "+Rtrim(_cCliFor)+" / "+_cLoja+" em Poder de Terceiros !")
				EndIf
				Incl_Acols(_aNFRem, @_nLoop, _lPreNota)

			ElseIf _lCompl

				dbSelectArea("PB2")
				PB2->(dbSetOrder(3))
				If PB2->(dbSeek(PB1->(PB1_FILIAL + PB1_DOC + PB1_SERIE + PB1_FORNEC + PB1_LOJA)))
					If PB2->PB2_TPMOV == "E"
						lSaida := .F.
						While !PB2->(EOF()) .AND. PB1->(PB1_FILIAL + PB1_DOC + PB1_SERIE + PB1_FORNEC + PB1_LOJA) == PB2->(PB2_FILIAL + PB2_NFDIFR + PB2_SEDIFR + PB2_TRANSP + PB2_LOJTRA)

							_cFornOri := PB2->PB2_FORNEC
							_cLojOri  := PB2->PB2_LOJA
							_cDocOri  := PB2->PB2_NFORIG
							_cSerOri  := PB2->PB2_SERORI

							_cChOri	  := PADR(_cDocOri,TAMSX3("D1_DOC")[1]) + _cSerOri + _cFornOri + _cLojOri

							dbSelectArea("SF1")
							SF1->(dbSetOrder(1))
							If SF1->(dbSeek(PB0->PB0_FILIAL + _cDocOri + _cSerOri + _cFornOri + _cLojOri))
								_cChOri := _cDocOri + _cSerOri + _cFornOri + _cLojOri
							Endif

							//aadd(aItens,{{"PRIMARYKEY",_cChOri}})
							aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),7))}})

							PB2->(dbSkip())
						EndDo

						If SF1->(dbSeek(PB0->PB0_FILIAL + _cChOri))
							aadd(aCabec,{""				,SF1->F1_DTDIGIT})  //Data Inicial
							aadd(aCabec,{""				,SF1->F1_DTDIGIT})  //Data Final
							aadd(aCabec,{""				,2})                //2-Inclusao;1=Exclusao
							aadd(aCabec,{""				,_cFornOri})    	//Fornecedor do documento de Origem
							aadd(aCabec,{""				,_cLojOri})       	//Loja de origem
							aadd(aCabec,{""				,IIF(SF1->F1_TIPO == "D",2,1)})                //Tipo da nota de origem: 1=Normal;2=Devol/Benef
							aadd(aCabec,{""				,1})                //1=Aglutina;2=Nao aglutina
							aadd(aCabec,{"F1_EST"		,SF1->F1_EST})
							aadd(aCabec,{""				,PB1->PB1_TOTAL})   //Valor do conhecimento
							aadd(aCabec,{"F1_FORMUL"	,1})
							aadd(aCabec,{"F1_DOC"		,PB0->PB0_DOC})
							aadd(aCabec,{"F1_SERIE"		,PB0->PB0_SERIE})
							aadd(aCabec,{"F1_FORNECE"	,PB0->PB0_FORNECE})
							aadd(aCabec,{"F1_LOJA"		,PB0->PB0_LOJA})
							aadd(aCabec,{""				,PB1->PB1_TES})     //TES
							aadd(aCabec,{"F1_BASERET"	,0})
							aadd(aCabec,{"F1_ICMRET"	,0})
							If Substr(PB0->PB0_ESPECI,1,2) == "CT"
								aadd(aCabec,{"F1_COND"	,"01"})    // 18
							Else
								aadd(aCabec,{"F1_COND"	,PB0->PB0_COND})    // 18
							End If							
							aadd(aCabec,{"F1_EMISSAO"	,PB0->PB0_EMISSA})  // Data da Emissao - 19
							aadd(aCabec,{"F1_ESPECIE"	,PB0->PB0_ESPECI})  // Especie - 20
							aadd(aCabec,{"F1_CHVNFE"    ,PB0->PB0_CHVNFE}) //ITALO MACIEL - CHAVE CTE
							aadd(aCabec,{"F1_TPCTE"     ,"N"}) //ITALO MACIEL - TIPO CTE
							aadd(aCabec,{"E2_NATUREZ"	,"2101002"})
						Else
							Alert("Nao encontrado NF de Origem: NF/Serie " + PB1->PB1_NFORI + " / " + PB1->PB1_SERIOR + " Fornecedor " + _cFornOri+" / " + _cLojOri)
						Endif
					EndIf
				EndIf
			Else
				aadd(_aNFRem,{" ", " ", " ", PB1->PB1_QUANT, " "," "})
				//Preenche itens para gerar pré-nota
				Incl_Acols(_aNFRem, @_nLoop, _lPreNota, @aTesPed)
			Endif
		Endif
		PB1->(dbSkip())
	Enddo

	// Caso tenha itens e cabecalho definidos
	If Len(aItens) > 0 .And. Len(aCabec) > 0
		// Reinicializa ambiente para o fiscal
		If MaFisFound()
			MaFisEnd()
		EndIf
		IF _lPreNota
			// Inclui pre-nota
			If _lCompl
				//MATA116(aCabec,aItens)
				MsExecAuto({|x,y| MATA116(x,y)},aCabec,aItens)
			Else
				MATA140(aCabec,aItens,3)
				If !lMsErroAuto

					dbSelectArea("SD1")
					SD1->(dbSetOrder(1))
					If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
						While !SD1->(EOF());
								.AND. SF1->F1_DOC == SD1->D1_DOC;
								.AND. SF1->F1_SERIE == SD1->D1_SERIE;
								.AND. SF1->F1_FORNECE == SD1->D1_FORNECE;
								.AND. SF1->F1_LOJA == SD1->D1_LOJA

							nPosTes := aScan(aTesPed,{|x| alltrim(x[1])==SD1->D1_ITEM })
							If !Empty(nPosTes)
								RecLock("SD1",.F.)
								Replace D1_TESACLA with aTesPed[nPosTes][2]
								SD1->(MsUnlock())
							EndIf
							SD1->(dbSkip())
						EndDo
					EndIf
				EndIf
			Endif
		ELSE
			// Inclui nota de entrada
			If _lCompl
				MATA116(aCabec,aItens)
			Else
				If lSaida
					MATA103(aCabec,aItens,3)
				Else
					MATA116(aCabec,aItens)
				EndIf
			Endif
		ENDIF
		// Checa erro de rotina automatica
		IF lMsErroAuto
			lMostraErro	:= .T.
			MostraErro()
			DisarmTransaction()
			_lRet := .F.
		ELSE
			dbSelectArea("PB0")
			RestArea(_aAreaPB0)
			If Substr(PB0->PB0_ESPECI,1,2) == "CT"
				If _lCompl
					dbSelectArea("SF1")
					dbSetOrder(1)
					If dbSeek(_cChave)
						If Empty(F1_CHVNFE)
							RecLock("SF1",.F.)
							Replace F1_CHVNFE with PB0->PB0_CHVNFE
							MsUnLock()
						Endif
					Endif

				Endif

			Endif
            /*If PB0->PB0_TIPO == "D"
                _cQuery := "UPDATE "+RetSqlName("SD1")+" SET D1_NFORI = ' ', D1_SERIORI = '  '"
                _cQuery += " WHERE D_E_L_E_T_ = ' ' AND D1_FILIAL = '"+XFilial("PB0")+"' "
                _cQuery += " AND D1_DOC = '"+PB0->PB0_DOC+"' AND D1_SERIE = '"+PB0->PB0_SERIE+"'"
                _cQuery += " AND D1_FORNECE = '"+PB0->PB0_FORNEC+"'"
                _cQuery += " AND D1_LOJA = '"+PB0->PB0_LOJA+"'"
                _cQuery += " AND D1_EMISSAO = '"+Dtos(PB0->PB0_EMISSA)+"'"
                TCSqlExec(_cQuery)
                TcSqlExec("COMMIT")
		Endif*/

            // atualiza tabela
            TCSqlExec("UPDATE "+RetSqlName("PB0")+" SET PB0_STATUS = '2' WHERE D_E_L_E_T_ = ' ' AND PB0_FILIAL = '"+PB0->PB0_FILIAL+"' AND PB0_DOC = '"+PB0->PB0_DOC+"' AND PB0_SERIE = '"+PB0->PB0_SERIE+"' AND PB0_CNPJ = '"+PB0->PB0_CNPJ+"'")
            TcSqlExec("COMMIT")

            // Atualiza NCM do produto do fornecedor no produto EBBA - DIMITRIUS 11/07/2012
            dbSelectArea("PB1")
            PB1->(MsSeek(PB0->PB0_FILIAL+PB0->PB0_DOC+PB0->PB0_SERIE+PB0->PB0_FORNEC+PB0->PB0_LOJA))
		Do While !Eof()  .And.  PB1_FILIAL+PB1_DOC+PB1_SERIE+PB1_FORNEC+PB1_LOJA = PB0->PB0_FILIAL+PB0->PB0_DOC+PB0->PB0_SERIE+PB0->PB0_FORNEC+PB0->PB0_LOJA
			If !Empty(PB1->PB1_COD)
				If !Empty(PB1->PB1_POSIPI)
                        dbSelectArea("SB1")
					If SB1->(MsSeek(xFilial("SB1")+PB1->PB1_COD)) .And. Empty(SB1->B1_POSIPI)
                            Reclock("SB1",.F.)
                            SB1->B1_POSIPI := PB1->PB1_POSIPI
                            MsUnlock()
					Endif
				Endif
                    dbSelectArea("SA5")
                    dbSetOrder(1)
				If dbSeek(xFilial("SA5")+PB0->PB0_FORNEC+PB0->PB0_LOJA+PB1->PB1_COD)
                        RecLock("SA5",.F.)
                        Replace A5_CODPRF with PB1->PB1_PRDFOR
                        Replace A5_NOMPROD with PB1->PB1_DSCFOR
                        MsUnLock()
				Else
                        RecLock("SA5",.T.)
                        Replace A5_FILIAL 	with xFilial("SA5")
                        Replace A5_FORNECE 	with PB0->PB0_FORNEC
                        Replace A5_LOJA 	with PB0->PB0_LOJA
                        Replace A5_PRODUTO 	with PB1->PB1_COD
                        Replace A5_CODPRF 	with PB1->PB1_PRDFOR
                        Replace A5_NOMPROD 	with PB1->PB1_DSCFOR
                        Replace A5_NOMEFOR 	with Posicione("SA2",1,xFilial("SA2")+PB0->PB0_FORNEC+PB0->PB0_LOJA,"A2_NOME")
                        MsUnLock()
				Endif
			Endif
                dbSelectArea("PB1")
                dbSkip()
		EndDo

            //Baixa PC
            fReservPC()

            _cMens:= "Processamento concluído com sucesso"
            dbSelectArea("PB0")
			If !lMenu
            	AVISO("Nota "+PB0->PB0_DOC,_cMens, {"Sair"},2,"")
			End If
	ENDIF
ENDIF
    RestArea(_aArea)
Return()

//Valida e baixa pedidos de compra
Static Function fReservPC()
    Local cQuery := ""

    cQuery := " SELECT ZZS_PRODUT,ZZS_DESCPR,ZZS_PEDIDO,ZZS_FORPED,ZZS_LOJAPC,ZZS_ITEPED,ZZS_QATE FROM "+ RETSQLNAME("ZZS")
    cQuery += " WHERE D_E_L_E_T_ = ' ' "
    cQuery += " AND ZZS_FILIAL = '"+ PB0->PB0_FILIAL +"' "
    cQuery += " AND ZZS_DOC    = '"+ PB0->PB0_DOC +"' "
    cQuery += " AND ZZS_SERIE  = '"+ PB0->PB0_SERIE +"' "
    cQuery += " AND ZZS_FORNEC = '"+ PB0->PB0_FORNEC +"' "
    cQuery += " AND ZZS_LOJANF = '"+ PB0->PB0_LOJA +"' "

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY")

	While !QRY->(Eof())
        dbSelectArea("SC7")
        SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial("SC7") + QRY->ZZS_PEDIDO + QRY->ZZS_ITEPED))
            Reclock("SC7",.F.)
            Replace C7_QTDACLA with SC7->C7_QTDACLA + QRY->ZZS_QATE
            SC7->(MsUnlock())
		EndIf

        QRY->(dbSkip())
	EndDo

    QRY->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  05/31/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Incl_Acols(_aNFRem, _nLoop, _lPreNota, aTesPed)
	Local aEmp := FWLOADSM0()
	Local TR:=1
	Local nPos
//Local _cDEVTES := Alltrim(SuperGetMv("EB_TESDV",.F.,""))

	Default aTesPed := {}

	For TR:=1 to Len(_aNFRem)
		aLinha  := {}
		aadd(aLinha,{"D1_ITEM"		,Strzero(_nLoop,TamSX3("D1_ITEM")[1]),Nil})
		aadd(aLinha,{"D1_COD"		,PB1->PB1_COD	,Nil})
		aadd(aLinha,{"D1_TIPO"		,PB1->PB1_TIPO	,Nil})
		aadd(aLinha,{"D1_LOCAL"		,PB1->PB1_LOCAL	,Nil})
		aadd(aLinha,{"D1_ENDER"		,"DOCAENT"		,Nil})
		aadd(aLinha,{"D1_QUANT"		,_aNFRem[TR,4]		,Nil})
		aadd(aLinha,{"D1_VUNIT"		,PB1->PB1_VUNIT		,Nil})
		aadd(aLinha,{"D1_TOTAL"		,PB1->PB1_TOTAL		,Nil})
		aadd(aLinha,{"D1_CLASFIS"	,PB1->PB1_CLASFI	,Nil})
		//Italo Maciel 10/12/20
		aadd(aLinha,{"D1_VALFRE"	,PB1->PB1_VALFRE	,Nil})
		aadd(aLinha,{"D1_DESPESA"	,PB1->PB1_DESPES	,Nil})
		If PB1->PB1_BASEIC > 0 .and. PB1->PB1_VALICM > 0
			aadd(aLinha,{"D1_BASEICM",PB1->PB1_BASEIC	,Nil})
			aadd(aLinha,{"D1_VALICM",PB1->PB1_VALICM	,Nil})
			aadd(aLinha,{"D1_PICM"	,PB1->PB1_PICM		,Nil})
		Endif
		If PB1->PB1_ICMSRE > 0 .and. PB1->PB1_BRICMS > 0 .and. PB1->PB1_ALIQSO > 0
			aadd(aLinha,{"D1_ICMSRET"	,PB1->PB1_ICMSRE,Nil})
			aadd(aLinha,{"D1_BRICMS"	,PB1->PB1_BRICMS,Nil})
			aadd(aLinha,{"D1_ALIQSOL"	,PB1->PB1_ALIQSO,Nil})
		EndIf
		If PB1->PB1_BASEIP > 0 .and. PB1->PB1_IPI > 0 .and. PB1->PB1_VALIPI > 0
			aadd(aLinha,{"D1_BASEIPI"	,PB1->PB1_BASEIP	,Nil})
			aadd(aLinha,{"D1_IPI"		,PB1->PB1_IPI		,Nil})
			aadd(aLinha,{"D1_VALIPI"	,PB1->PB1_VALIPI	,Nil})
		Endif
		If PB1->PB1_TIPO == "D"
			aadd(aLinha,{"D1_NFORI"		,PB1->PB1_NFORI	,Nil})
			aadd(aLinha,{"D1_SERIORI"	,PB1->PB1_SERIOR,Nil})
			aadd(aLinha,{"D1_ITEMORI"	,PB1->PB1_ITEMOR,Nil})
		Else
			aadd(aLinha,{"D1_NFORI"		,_aNFRem[TR,1]	,Nil})
			aadd(aLinha,{"D1_SERIORI"	,_aNFRem[TR,2]	,Nil})
			aadd(aLinha,{"D1_ITEMORI"	,_aNFRem[TR,3]	,Nil})
		Endif
		aadd(aLinha,{"D1_IDENTB6"	,_aNFRem[TR,5]	,Nil})
		IF ! _lPreNota
			aadd(aLinha,{"D1_TES"		,PB1->PB1_TES	,Nil})
			If Rastro(PB1->PB1_COD,"L") .and. SF4->F4_ESTOQUE == "S"
				aadd(aLinha,{"D1_LOTECTL",PB1->PB1_LOTECT,Nil})
				aadd(aLinha,{"D1_DTVALID",PB1->PB1_DTVALI,Nil})
			EndIf
		Else
			AADD(aTesPed,{Strzero(_nLoop,TamSX3("D1_ITEM")[1]),fTESPed()})
//aadd(aLinha,{"D1_TESACLA"	,cTesPed 	,Nil})
		ENDIF
//	If Empty(PB1->PB1_CARGA) .and. _cDEVTES == PB1->PB1_TES
//		aadd(aLinha,{"D1_XLOTTRF",PB1->PB1_LOTECT,Nil})
//	Endif
		_nLoop++
		aadd(aItens,aLinha)
	Next
// Checa se utiliza rastreabilidade
Return

Static Function fTESPed()
	Local cQuery 	:= ""
	Local cRet 	:= ""

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + PB1->PB1_COD ))

	cQuery := " SELECT C7_TES FROM "+RetSqlName("ZZS")+" A "
	cQuery += " INNER JOIN "+RetSqlName("SC7")+" B ON C7_FILIAL = ZZS_FILIAL AND C7_NUM = ZZS_PEDIDO AND C7_ITEM = ZZS_ITEPED AND B.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
	cQuery += " AND ZZS_FILIAL 	= '"+ xFilial("ZZS") +"' "
	cQuery += " AND ZZS_DOC 		= '"+ PB0->PB0_DOC +"' "
	cQuery += " AND ZZS_SERIE 	= '"+ PB0->PB0_SERIE +"' "
	cQuery += " AND (ZZS_PRODUT = '"+ PB1->PB1_COD +"' OR ZZS_PRODUT = '"+ SB1->B1_XALTIMP +"') "

	TcQuery cQuery New Alias "QZZS"

	cRet := QZZS->C7_TES

	QZZS->(dbCloseArea())

Return cRet

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³NfeFldTot ³Autor  ³ Eduardo Riera         ³ Data ³12.09.2002 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Rotina de atualizacao do folder de totais                    ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NfeFldXML(oDlg,aGets,aPosGet,bRefresh)

	Local aObjetos := Array(Len(aGets))
	Local oTMultiget1
	Local oTGet1

	@ 06,aPosGet[1,1] SAY RetTitle("PB0_USRIMP") Of oDlg PIXEL SIZE 55 ,9 //"Usuario"
	@ 05,aPosGet[1,2] MSGET aObjetos[1] VAR aGets[1] PICTURE PesqPict('PB0','PB0_USRIMP') OF oDlg PIXEL When .F. SIZE 80,09

	@ 06,aPosGet[1,3] SAY RetTitle("PB0_DTAIMP") Of oDlg PIXEL SIZE 49 ,9 //"Data Importação"
	@ 05,aPosGet[1,4] MSGET aObjetos[2] VAR aGets[2]  PICTURE PesqPict('PB0','PB0_DTAIMP') OF oDlg PIXEL When .F. SIZE 80,09

//italo maciel 12/07/18 - multiget das informações complementares
	@ 26,aPosGet[1,3] SAY RetTitle("PB0_INFCOM") Of oDlg PIXEL SIZE 49 ,9 //"Inf. Compl."
	oTMultiget1 := tMultiget():new( 25, aPosGet[1,4], {| u | if( pCount() > 0, aGets[5] := u , aGets[5] ) }, oDlg, 220, 40, , , , , , .T.,,,,,,.T. )

	@ 26,aPosGet[1,1] SAY RetTitle("PB0_ARQUIV") Of oDlg PIXEL SIZE 49 ,9 //"Arquivo XML"
	@ 25,aPosGet[1,2] MSGET aObjetos[3] VAR aGets[3]  PICTURE PesqPict('PB0','PB0_ARQUIV') OF oDlg PIXEL When .F. SIZE 180,09

	@ 46,aPosGet[1,1] SAY RetTitle("PB0_CHVNFE") Of oDlg PIXEL SIZE 58 ,9 //"Chave NF-e"
//@ 44,aPosGet[1,2] MSGET aObjetos[4] VAR aGets[4]  PICTURE PesqPict('PB0','PB0_CHVNFE') OF oDlg PIXEL When .F. SIZE 180,09
	oTGet1 := TGet():New( 44,aPosGet[1,2],{|| aGets[4] },oDlg,180,09,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,aGets[4],,,, )

//@ 43,3 TO 46,aPosGet[5] LABEL '' OF oDlg PIXEL

//bRefresh := {|| NfeRFldXML(aGets,aObjetos)}

Return(.T.)

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³CarFldTot ³Autor  ³ Eduardo Riera         ³ Data ³12.09.2002 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Rotina de atualizacao do folder de totais                    ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CarFldXML(oDlg,aGets,aPosGet,bRefresh, l140Altera)

	Local aObjetos := Array(Len(aGets))

	@ 06,aPosGet[1,1] SAY RetTitle("PB0_CARGA") Of oDlg PIXEL SIZE 55 ,9
	@ 05,aPosGet[1,2] MSGET aObjetos[1] VAR aGets[1] PICTURE PesqPict('PB0','PB0_CARGA') OF oDlg PIXEL When l140Altera SIZE 80,09

	@ 06,aPosGet[1,3] SAY RetTitle("PB0_SEQCAR") Of oDlg PIXEL SIZE 49 ,9 //"Descontos"
	@ 05,aPosGet[1,4] MSGET aObjetos[2] VAR aGets[2]  PICTURE PesqPict('PB0','PB0_SEQCAR') OF oDlg PIXEL When l140Altera SIZE 80,09


//@ 43,3 TO 46,aPosGet[5] LABEL '' OF oDlg PIXEL

//bRefresh := {|| NfeRFldXML(aGets,aObjetos)}

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NfeCabXML(oDlg,aPosGet,bRefresh,lVisual,lFiscal,cUfOrig,lClassif,lPreNota,nCombo,oCombo,cCodRet,oCodRet,lNfMedic,aCodR,cRecIss,cNatureza)

	Local aObjetos   := Array(10)
	Local aCombo1    := {	"Normal",;	//"Normal"
	"Devolucao",;	//"Devolucao"
	"Beneficiamento",;	//"Beneficiamento"
	"Compl.  ICMS",;	//"Compl.  ICMS"
	"Compl.  IPI",;	//"Compl.  IPI"
	"Compl. Preco/Frete"} 	//"Compl. Preco/Frete"

	Local aCombo2    := {"Nao","Sim"} //"Nao"###"Sim"
	Local aCombo2Lan := {"Nao","Sim","Sim"} // Nao retirar, abrange language=English
	Local aAuxCombo1 := {"N","D","B","I","P","C"}
	Local aAuxCombo2 := {"N","S","Y"}

	Local c103SayForn:= IIf(cTipo$"DB",RetTitle("F2_CLIENTE"),RetTitle("PB0_FORNEC"))
	Local c103Tipo	 := ""
	Local c103Form	 := cFormul
	Local cCar       := CHR(34)+CHR(39)        // Caracteres que não serão permitidos na digitação do campo: Nota e Série
	Local nAux       := aScan(aAuxCombo1,cTipo)
	Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
	Local nTamGetFor := 45
	Local lUfOrig := ( ValType( cUfOrig ) == "C" )
	Local oNfMedic   := .F.
	lClassif:= If( ValType( lClassif ) == "L" , lClassif, .F.)

	cFormul := If( ValType( cFormul ) <> "C" .Or. Empty(cFormul) , "N", cFormul )

	DEFAULT lPreNota 	:= .F.
	Default aCodR	 	:= {}
	Default cRecIss	 	:= "1"
	Default cNatureza	:= ""

//aCombo1    := IIF(lPreNota,{"Normal","Devolucao","Beneficiamento"},{"Normal","Devolucao","Beneficiamento","Compl.  ICMS","Compl.  IPI","Compl. Preco/Frete"}) //STR0001>"Normal" STR0002>"Devolucao" STR0003>"Beneficiamento" STR0004>"Compl.  ICMS" STR0005>"Compl.  IPI" STR0006>"Compl. Preco/Frete"
//aAuxCombo1 := IIF(lPreNota,{"N","D","B"},{"N","D","B","I","P","C"})
//aCombo1    := {"Normal"} //Manutenção ROTTA - 17/03/14
//aAuxCombo1 := {"N"}      //
	nAux       := aScan(aAuxCombo1,cTipo)

	If !Empty(cTipo) .And. nAux <> 0
		c103Tipo := aCombo1[nAux]
	EndIf
	nAux := aScan(aAuxCombo2,cFormul)
	If !Empty(cFormul) .And. nAux <> 0
		c103Form := aCombo2Lan[nAux]
	EndIf

	If !lNfMedic
		If TamSX3("A2_COD")[1]< 9
			nTamGetFor:=(6*TamSX3("A2_COD")[1])
		ElseIf TamSX3("A2_COD")[1]< 15
			nTamGetFor:=(4.8*TamSX3("A2_COD")[1])
		Else
			nTamGetFor:=(4*TamSX3("A2_COD")[1])
		EndIf
	EndIf
	@ aPosGet[3,1],aPosGet[3,2] TO aPosGet[3,3],aPosGet[3,4] LABEL "" OF oDlg PIXEL

	@ 41,aPosGet[1,1] SAY RetTitle("PB0_TIPO") OF oDlg PIXEL SIZE 35,09
	@ 40,aPosGet[1,2] MSCOMBOBOX aObjetos[1] VAR c103Tipo ITEMS aCombo1 SIZE 50,90;
		WHEN !lVisual;
		VALID Troc_TP(c103Tipo,@cTipo,@cA100For,@cLoja,aObjetos[6],aObjetos[7],aObjetos[8]) OF oDlg PIXEL
//;
//	WHEN !lVisual .And. !IsInCallStack("MATA116") .And. !IsInCallStack("MATA119") .And. A103ChWhen("PB0_TIPO",c103Tipo,lClassif) ;
//	VALID NfeCombo(@cTipo,aCombo1,c103Tipo,aAuxCombo1).And.NfeTipo(cTipo,@cA100For,@cLoja,aObjetos[6],aObjetos[7],aObjetos[8]);

	If cTipo == "C"
		cCondicao := "01"
	End If

	If !lGspInUseM
		@ 41,aPosGet[1,3] SAY RetTitle("PB0_FORMUL") Of oDlg PIXEL SIZE 52,09
		@ 40,aPosGet[1,4] MSCOMBOBOX aObjetos[2] VAR c103Form ITEMS aCombo2 SIZE 25,50 ;
			WHEN !lVisual .And. A103ChWhen("PB0_FORMUL",c103Form,lClassif) ;
			VALID NfeCombo(@cFormul,aCombo2Lan,c103Form,aAuxCombo2).And.NfeFormul(cFormul,@cNFiscal,@cSerie,aObjetos[3],@aObjetos[4]) ;
			OF oDlg PIXEL
	EndIf

	@ 41,aPosGet[1,4]+33 SAY RetTitle("PB0_COND") Of oDlg PIXEL SIZE 52,09
	@ 40,aPosGet[1,4]+65 MSGET oCond VAR cCondicao PICTURE PesqPict("PB0","PB0_COND") F3 "SE4" VALID (Vazio() .or. (ExistCpo("SE4",cCondicao) /*.and. Ver_venct(cCondicao,@dVencto)*/)) OF oDlg PIXEL SIZE 34,09
	//@ 41,aPosGet[1,4]+102 SAY RetTitle("PB0_VENCTO") Of oDlg PIXEL SIZE 70,09
	//@ 40,aPosGet[1,4]+140 MSGET oVencto VAR dVencto  OF oDlg PIXEL SIZE 45,09
	@ 41,aPosGet[2,6] SAY RetTitle("PB0_DOC") Of oDlg PIXEL SIZE 45,09
	@ 40,aPosGet[2,7] MSGET aObjetos[3] VAR cNFiscal PICTURE PesqPict("PB0","PB0_DOC") ;
		WHEN !lVisual.And.VisualSX3("PB0_DOC") .And.cFormul<>"S" .And. A103ChWhen("PB0_DOC",cNFiscal,lClassif) ;
		VALID NfeFornece(cTipo,@cA100For,@cLoja,,@nCombo,@oCombo,@cCodRet,@oCodRet,@aCodR,@cRecIss,@cNatureza).And.CheckSX3("PB0_DOC") .And. !A103VldCpo(cNfiscal,cCar);
		OF oDlg PIXEL SIZE 34,09

	@ 41,aPosGet[2,8] SAY RetTitle("PB0_SERIE") Of oDlg PIXEL SIZE 23,09
	@ 40,aPosGet[2,9] MSGET aObjetos[4] VAR cSerie  PICTURE PesqPict("PB0","PB0_SERIE") ;
		WHEN !lVisual.And.VisualSX3('PB0_SERIE').And.cFormul<>"S" .And. A103ChWhen("PB0_SERIE",cSerie,lClassif);
		VALID NfeFornece(cTipo,@cA100For,@cLoja,,@nCombo,@oCombo,@cCodRet,@oCodRet,@aCodR,@cRecIss,@cNatureza).And.CheckSX3("PB0_SERIE") .And. !A103VldCpo(cSerie,cCar);
		OF oDlg PIXEL SIZE 18,09

	If cPaisLoc == "PTG"
		@ 31,aPosGet[1,9] SAY RetTitle("PB0_DIACTB") Of oDlg PIXEL SIZE 30,09
		@ 30,aPosGet[1,10] MSGET aObjetos[10] VAR cCodDiario PICTURE PesqPict("PB0","PB0_DIACTB") WHEN !lVisual .And. VisualSX3("PB0_DIACTB") F3 CpoRetF3("PB0_DIACTB") ;
			VALID CheckSX3("PB0_DIACTB") OF oDlg PIXEL SIZE 30,09 HASBUTTON
	EndIf
	@ 59,aPosGet[2,1] SAY RetTitle("PB0_EMISSA") OF oDlg PIXEL SIZE 35,09
	@ 58,aPosGet[2,2] MSGET aObjetos[5] VAR dDEmissao PICTURE PesqPict("PB0","PB0_EMISSA") ;
		WHEN (!lVisual .or. lClassif).And.VisualSX3("PB0_EMISSA").And. A103ChWhen("PB0_EMISSA",dDEmissao,lClassif) Valid CheckSX3("PB0_EMISSA") .And. NfeEmissao(dDEmissao) ;
		OF oDlg PIXEL SIZE 45 ,9 HASBUTTON
	@ 59,aPosGet[1,3] SAY aObjetos[6] VAR c103SayForn Of oDlg PIXEL SIZE 43,09
	@ 58,aPosGet[2,4] MSGET aObjetos[7] VAR cA100For PICTURE PesqPict("PB0","PB0_FORNEC") F3 CpoRetF3("PB0_FORNEC");
		WHEN !lVisual.And.VisualSX3("PB0_FORNEC").And. A103ChWhen("PB0_FORNEC",cA100For,lClassif) ;
		VALID NfeFornece(cTipo,@cA100For,@cLoja,@cUfOrig,@nCombo,@oCombo,@cCodRet,@oCodRet,@aCodR,@cRecIss,@cNatureza).And.CheckSX3("PB0_FORNEC",cA100For).And.NfeVldRef("NF_CODCLIFOR",cA100For) ;
		OF oDlg PIXEL SIZE nTamGetFor,09 HASBUTTON
	@ 58,aPosGet[2,5] MSGET aObjetos[8] VAR cLoja PICTURE PesqPict("PB0","PB0_LOJA") F3 CpoRetF3("PB0_LOJA") ;
		WHEN !lVisual.And.VisualSX3("PB0_LOJA") .And. A103ChWhen("PB0_LOJA",cLoja,lClassif);
		VALID NfeFornece(cTipo,@cA100For,@cLoja,@cUfOrig,@nCombo,@oCombo,@cCodRet,@oCodRet,@aCodR,@cRecIss,@cNatureza).And.CheckSX3("PB0_LOJA",cLoja).And.NfeVldRef("NF_LOJA",cLoja) ;
		OF oDlg PIXEL SIZE 15,09 HASBUTTON

	If !lGspInUseM

		@ 59,aPosGet[2,6] SAY RetTitle("PB0_ESPECI") Of oDlg PIXEL SIZE 63,09
		@ 58,aPosGet[2,7] MSGET aObjetos[9] VAR cEspecie PICTURE PesqPict("PB0","PB0_ESPECI") ;
			F3 CpoRetF3("PB0_ESPECI") WHEN !lVisual VALID CheckSX3("PB0_ESPECI",cEspecie) Of oDlg Pixel Size 30,09 HASBUTTON
//		WHEN (lClassif.Or.!lVisual).And.VisualSX3("PB0_ESPECI").And. A103ChWhen("PB0_ESPECI",cEspecie,lClassif);

		If lUfOrig
			@ 59,aPosGet[2,8] SAY OemToAnsi("UF Origem") Of oDlg PIXEL SIZE 63 ,9
			@ 58,aPosGet[2,9] MSGET cUfOrig PICTURE "@!" F3 "12" ;
				When !lVisual.And.VisualSX3('PB0_EST').And. A103ChWhen("PB0_EST",cUfOrig,lClassif) Valid CheckSX3('PB0_EST',cUfOrig) .And. ;
				MaFisAlt( "NF_UFORIGEM", cUfOrig ) .And. Eval( bGdRefresh ) OF oDlg PIXEL SIZE 20,9 HASBUTTON
		EndIf

	Endif

	bRefresh := {|| NfeCabOk(lVisual,aObjetos[1],aObjetos[3],aObjetos[5],aObjetos[7],aObjetos[8],lFiscal,cUfOrig)}
	aObjetos[1]:SetFocus()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  04/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ver_venct(cCondicao,dVencto)

	Local _lRet := .t.
	Local aDupl := Condicao(100,cCondicao,,dDataBase)
	If Len(aDupl) == 1
		dVencto := aDupl[1,1]
	Else
		Alert("Condicao de pagamento nao pode ter mais do que 1 parcela")
		_lRet := .f.
	Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  03/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Troc_TP(c103Tipo,cTipo,cFornece,cLoja,oSay,oFornece,oLoja)

	Local _aArea := GetArea()
	Local _cCGC := PB0->PB0_CNPJ
	Local _lRet := .t.
	If Substr(c103Tipo,1,1) <> cTipo
		If Substr(c103Tipo,1,1) $ "N/C"
			dbSelectArea("SA2")
			dbSetOrder(3)
			If dbSeek(xFilial()+_cCGC) .and. !Empty(_cCGC)
				cFornece := SA2->A2_COD
				cLoja    := SA2->A2_LOJA
				cTipo := Substr(c103Tipo,1,1)
			Else
				Alert("Nao encontrado Fornecedor com o CNPJ: "+ _cCGC)
				_lRet := .f.
			Endif
			If _lRet .and. oSay<>Nil
				cTitulo := oSay:cCaption
				oSay:SetText(RetTitle("F1_FORNECE"))
			EndIf
		Else
			dbSelectArea("SA1")
			dbSetOrder(3)
			If dbSeek(xFilial()+_cCGC) .and. !Empty(_cCGC)
				cFornece := SA1->A1_COD
				cLoja    := SA1->A1_LOJA
				cTipo := Substr(c103Tipo,1,1)
			Else
				Alert("Nao encontrado cliente com o CNPJ: "+ _cCGC)
				_lRet := .f.
			Endif
			If _lRet .and. oSay<>Nil
				cTitulo := oSay:cCaption
				oSay:SetText(RetTitle("F2_CLIENTE"))
			EndIf
		Endif
	Endif
	RestArea(_aArea)
Return _lRet


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³NfeFlddIV ³Autor  ³ Microsiga S/A         ³ Data ³09/09/2008 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Rotina de tratamento do folder para informacoes diversas     ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto da Janela que sera disponibilizado os Get      ³±±
	±±³          ³ExpA1: Array com as posicoes dos gets da NF-e                ³±±
	±±³          ³ExpB1: Codeblock para atualizaco dos dados do Folder         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                       ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NfeFld_D(oDlg,aPosGet, ofolder)

	Local aObjetos	:= IIf(Type("aNFEDanfe") == "A",Array(Len(aNFEDanfe)),)
	Local nrFolder  := Len(ofolder:adialogs)

	If Type("aNFEDanfe") == "A"
		@ 05,aPosGet[1,1] SAY "Cod. Transp" Of oDlg PIXEL SIZE 32,08    // Cod. Transp
		@ 04,aPosGet[1,2] MSGET aObjetos[01] VAR aNFEDanfe[01] ;
			PICTURE X3Picture("PB0_TRANSP") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_TRANSP");
			VALID IIF(Len(Trim(aNFEDanfe[01]))>0,CheckSX3("PB0_TRANSP",aNFEDanfe[01]),.T.);
			F3 "SA4";
			SIZE 50,08 HASBUTTON
		aObjetos[01]:cSX1Hlp    := "PB0_TRANSP"
		aObjetos[01]:bLostFocus := { || If(IIF(Len(Trim(aNFEDanfe[01]))>0,CheckSX3("PB0_TRANSP",aNFEDanfe[01]),.T.),{oFolder:nOption := nrFolder},"")}

		If PB0->(FieldPos("PB0_PLACA")) >0
			@ 05,aPosGet[1,3] SAY "Placa" Of oDlg PIXEL SIZE 30,08   // Placa
			@ 04,aPosGet[1,4] MSGET aObjetos[12] VAR aNFEDanfe[12] ;
				PICTURE X3Picture("PB0_PLACA") ;
				OF oDlg PIXEL ;
				WHEN !l103Visual .And. VisualSX3("PB0_PLACA");
				VALID CheckSX3("PB0_PLACA",aNFEDanfe[12]);
				SIZE 50,08 HASBUTTON
			aObjetos[12]:cSX1Hlp := "PB0_PLACA"
		EndIf

		@ 05,aPosGet[1,5] SAY "Peso Liquido" Of oDlg PIXEL SIZE 32,08    // Peso Liquido
		@ 04,aPosGet[1,6] MSGET aObjetos[02] VAR aNFEDanfe[02] ;
			PICTURE X3Picture("PB0_PLIQUI") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_PLIQUI");
			VALID CheckSX3("PB0_PLIQUI",aNFEDanfe[02]);
			SIZE 50,08 HASBUTTON
		aObjetos[02]:cSX1Hlp := "PB0_PLIQUI"

		@ 05,aPosGet[1,7] SAY "Peso Bruto" Of oDlg PIXEL SIZE 32,08  // Peso Bruto
		@ 04,aPosGet[1,8] MSGET aObjetos[03] VAR aNFEDanfe[03] ;
			PICTURE X3Picture("PB0_PBRUTO") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_PBRUTO");
			VALID CheckSX3("PB0_PBRUTO",aNFEDanfe[03]);
			SIZE 50,08 HASBUTTON
		aObjetos[03]:cSX1Hlp := "PB0_PBRUTO"

		@ 17,aPosGet[1,1] SAY "Especie 1" Of oDlg PIXEL SIZE 32,08  //
		@ 16,aPosGet[1,2] MSGET aObjetos[04] VAR aNFEDanfe[04] ;
			PICTURE X3Picture("PB0_ESPEC1") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC1");
			VALID CheckSX3("PB0_ESPEC1",aNFEDanfe[04]);
			SIZE 50,08	HASBUTTON
		aObjetos[04]:cSX1Hlp := "PB0_ESPEC1"

		@ 17,aPosGet[1,3] SAY "Volume 1" Of oDlg PIXEL SIZE 32,08   // Volume 1
		@ 16,aPosGet[1,4] MSGET aObjetos[05] VAR aNFEDanfe[05] ;
			PICTURE X3Picture("PB0_VOLUM1") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM1");
			VALID CheckSX3("PB0_VOLUM1",aNFEDanfe[05]);
			SIZE 50,08 HASBUTTON
		aObjetos[05]:cSX1Hlp := "PB0_VOLUM1"

		@ 17,aPosGet[1,5] SAY "Chave NFE" Of oDlg PIXEL SIZE 32,08  // Chave NFE
		@ 16,aPosGet[1,6] MSGET aObjetos[13] VAR aNFEDanfe[13] ;
			PICTURE X3Picture("PB0_CHVNFE") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual.And. VisualSX3("PB0_CHVNFE");
			VALID CheckSX3("PB0_CHVNFE",aNFEDanfe[13]);
			SIZE 180,08 HASBUTTON
		aObjetos[13]:cSX1Hlp := "PB0_CHVNFE"

		@ 29,aPosGet[1,1] SAY "Especie 2" Of oDlg PIXEL SIZE 32,08  // Especie 2
		@ 28,aPosGet[1,2] MSGET aObjetos[06] VAR aNFEDanfe[06] ;
			PICTURE X3Picture("PB0_ESPEC2") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC2");
			VALID CheckSX3("PB0_ESPEC2",aNFEDanfe[06]);
			SIZE 50,08 HASBUTTON
		aObjetos[06]:cSX1Hlp := "PB0_ESPEC2"

		@ 29,aPosGet[1,3] SAY "Volume 2" Of oDlg PIXEL SIZE 32,08  // Volume 2
		@ 28,aPosGet[1,4] MSGET aObjetos[07] VAR aNFEDanfe[07] ;
			PICTURE X3Picture("PB0_VOLUM2") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM2");
			VALID CheckSX3("PB0_VOLUM2",aNFEDanfe[07]);
			SIZE 50,08 HASBUTTON
		aObjetos[07]:cSX1Hlp := "PB0_VOLUM2"

		@ 29,aPosGet[1,5] SAY "Valor Pedagio" Of oDlg PIXEL SIZE 50,08  // Especie 2
		@ 28,aPosGet[1,6] MSGET aObjetos[06] VAR aNFEDanfe[06] ;
			PICTURE X3Picture("PB0_ESPEC2") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC2");
			VALID CheckSX3("PB0_ESPEC2",aNFEDanfe[06]);
			SIZE 50,08 HASBUTTON
		aObjetos[06]:cSX1Hlp := "PB0_ESPEC2"

		@ 29,aPosGet[1,7] SAY "Tipo Frete" Of oDlg PIXEL SIZE 32,08  // Volume 2
		@ 28,aPosGet[1,8] MSGET aObjetos[07] VAR aNFEDanfe[07] ;
			PICTURE X3Picture("PB0_VOLUM2") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM2");
			VALID CheckSX3("PB0_VOLUM2",aNFEDanfe[07]);
			SIZE 50,08 HASBUTTON
		aObjetos[07]:cSX1Hlp := "PB0_VOLUM2"

		@ 39,aPosGet[1,1] SAY "Especie 3" Of oDlg PIXEL SIZE 32,08  // Especie 3
		@ 38,aPosGet[1,2] MSGET aObjetos[08] VAR aNFEDanfe[08] ;
			PICTURE X3Picture("PB0_ESPEC3") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC3");
			VALID CheckSX3("PB0_ESPEC3",aNFEDanfe[08]);
			SIZE 50,08 HASBUTTON
		aObjetos[08]:cSX1Hlp := "PB0_ESPEC3"

		@ 39,aPosGet[1,3] SAY "Volume 3" Of oDlg PIXEL SIZE 32,08  // Volume 3
		@ 38,aPosGet[1,4] MSGET aObjetos[09] VAR aNFEDanfe[09] ;
			PICTURE X3Picture("PB0_VOLUM3") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM3");
			VALID CheckSX3("PB0_VOLUM3",aNFEDanfe[09]);
			SIZE 50,08 HASBUTTON
		aObjetos[09]:cSX1Hlp := "PB0_VOLUM3"

		@ 41,aPosGet[1,5] SAY "Fornec. Retirada" Of oDlg PIXEL SIZE 40,08  // Especie 3
		@ 40,aPosGet[1,6] MSGET aObjetos[08] VAR aNFEDanfe[08] ;
			PICTURE X3Picture("PB0_ESPEC3") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC3");
			VALID CheckSX3("PB0_ESPEC3",aNFEDanfe[08]);
			SIZE 25,08 HASBUTTON
		aObjetos[08]:cSX1Hlp := "PB0_ESPEC3"

		@ 41,aPosGet[1,7] SAY "Tipo CT-e" Of oDlg PIXEL SIZE 32,08  // Volume 3
		@ 40,aPosGet[1,8] MSGET aObjetos[09] VAR aNFEDanfe[09] ;
			PICTURE X3Picture("PB0_VOLUM3") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM3");
			VALID CheckSX3("PB0_VOLUM3",aNFEDanfe[09]);
			SIZE 50,08 HASBUTTON
		aObjetos[09]:cSX1Hlp := "PB0_VOLUM3"

		@ 51,aPosGet[1,1] SAY "Especie 4" Of oDlg PIXEL SIZE 32,08   // Especie 4
		@ 50,aPosGet[1,2] MSGET aObjetos[10] VAR aNFEDanfe[10] ;
			PICTURE X3Picture("PB0_ESPEC4") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_ESPEC4");
			VALID CheckSX3("PB0_ESPEC4",aNFEDanfe[10]);
			SIZE 50,08 HASBUTTON
		aObjetos[10]:cSX1Hlp := "PB0_ESPEC4"

		@ 51,aPosGet[1,3] SAY "Volume 4" Of oDlg PIXEL SIZE 32,08  // Volume 4
		@ 50,aPosGet[1,4] MSGET aObjetos[11] VAR aNFEDanfe[11] ;
			PICTURE X3Picture("PB0_VOLUM4") ;
			OF oDlg PIXEL ;
			WHEN !l103Visual .And. VisualSX3("PB0_VOLUM4");
			VALID CheckSX3("PB0_VOLUM4",aNFEDanfe[11]);
			SIZE 50,08 HASBUTTON
		aObjetos[11]:cSX1Hlp := "PB0_VOLUM4"

	EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Conv_Unid(_cCampo,_cRetor)

	Local nPosQtd     := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_QUANT"})
	Local nPosQtd2    := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_QTSEGU"})
	Local nPosTP	  := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_TPCONV"})
	Local nPosFt	  := aScan(aHeader,{|x| AllTrim(x[2]) == "PB1_FATOR"})
	Local nPosVUnit	  := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_VUNIT"})
	Local nPosV2Uni	  := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_VUNSEG"})
	Local nDecTax	  := TamSX3("PB1_QUANT")[2]
	Local nDecVun	  := TamSX3("PB1_VUNIT")[2]
	Local nDecTot	  := TamSX3("PB1_TOTAL")[2]
	Local _nQuant	  := aCols[n,nPosQtd]
	Local _nVunit	  := aCols[n,nPosVUnit]
	If _cCampo == "1" // Tipo Conversao
		_cTpConv := M->PB1_TPCONV
		If !Empty(aCols[n,nPosFt])
			If _cTpConv == "M"
				If _cRetorn == "1"
					_nQuant := Round(aCols[n,nPosQtd2] * aCols[n,nPosFt],nDecTax)
				Else
					_nVunit := Round(aCols[n,nPosV2Uni] / aCols[n,nPosFt],nDecVun)
				Endif
			Else
				If _cRetor == "1"
					_nQuant := Round(aCols[n,nPosQtd2] / aCols[n,nPosFt],nDecTax)
				Else
					_nVunit := Round(aCols[n,nPosV2Uni] * aCols[n,nPosFt],nDecVun)
				Endif
			Endif
		Endif
	Else // Fator de Conversao
		_nFator := M->PB1_FATOR
		If !Empty(aCols[n,nPosTP])
			If aCols[n,nPosTP] == "M"
				If _cRetor == "1"
					_nQuant := Round(aCols[n,nPosQtd2] * _nFator,nDecTax)
				Else
					_nVunit := Round(aCols[n,nPosV2Uni] / _nFator,nDecVun)
				Endif
			Else
				If _cRetorn == "1"
					_nQuant := Round(aCols[n,nPosQtd2] / _nFator,nDecTax)
				Else
					_nVunit := Round(aCols[n,nPosV2Uni] * _nFator,nDecVun)
				Endif
			Endif
		Endif
	Endif
	If _cRetor == "1"
		_nRet := _nQuant
	ElseIf _cRetor == "2"
		_nRet := _nVunit
	Else
		_nRet := Round(_nQuant * _nVunit,nDecTot)
	Endif
Return(_nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Conf_Div

	Local nX	          := 0
	Local aAlter       := {"PB1_QUANT","PB1_VUNIT"}
	Local nSuperior    := 090
	Local nEsquerda    := 003
	Local nInferior    := 240
	Local nDireita     := 621

	Local cLinhaOk     := "AllwaysTrue"
	Local cTudoOk      := "AllwaysTrue"
	Local cCampoOk     := "AllwaysTrue"
	Local cApagaOk     := "AllwaysTrue"
	Local cIniCpos     := ""
	Local cSuperApagar := ""
	Local nFreeze      := nil
	Local nMax         := 999999
	Local nCont
	Local n_x
	Local nOpca       := 0
	Local _cChave
	Local _nModo:=GD_UPDATE+GD_INSERT  //+GD_DELETE
	Local cAlias:="PB1"
	Local _nPosCpo
	Local _nPosCp
	Local aListCpo 	:= {	"PB1_ITEM",;
		"PB1_COD"	,;
		"PB1_UM"		,;
		"PB1_QUANT"	,;
		"PB1_VUNIT"	,;
		"PB1_TOTAL"	,;
		"PB1_DESCRI"}

	Local aColsOri  := AClone(aCols)
	Local aHead     := {}
	Local aCol      := {}
	Local _nPosCod 	:= ASCAN(aHeader,{|x| Alltrim(x[2]) == "PB1_COD"})
	Local _nPosQtd 	:= ASCAN(aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT"})
	Local _nPosVun 	:= ASCAN(aHeader,{|x| Alltrim(x[2]) == "PB1_VUNIT"})
	Local _nPosTot 	:= ASCAN(aHeader,{|x| Alltrim(x[2]) == "PB1_TOTAL"})
	Local _nPosUMPC	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_UMFORN"})
	Local _nPosUM	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_UM"})
	Local _nPosFat	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_FATOR"})

	Private aSize     := MsAdvSize(,.F.,430)
	Private aObjects  := {}
	Private aPosObj   := {}
	Private aSizeAut := MsAdvSize()
	Private aCpoGDa      := {}
	Private aTela[0][0]
	Private aGets[0]

	If Empty(aColsOri[n,_nPosCod])
		Alert("Favor informar o codigo interno do produto")
		Return
	Endif
	If Empty(aColsOri[n,_nPosQtd])
		Alert("Favor informar a quantidade")
		Return
	Endif
	If Empty(aColsOri[n,_nPosVun])
		Alert("Favor informar o preco unitario")
		Return
	Endif
	If Empty(aColsOri[n,_nPosTot])
		Alert("Favor informar o Valor Total")
		Return
	Endif
	If aColsOri[n,_nPosUMPC] <> aColsOri[n,_nPosUM] .and. Empty(aColsOri[n,_nPosFat])
		Alert("Unidades de medidas diferentes entre o PC e o XML, utilizar fator de conversao")
		Return
	Endif
	Aadd(aObjects, { 100,  70, .T., .F. } )
	Aadd(aObjects, { 100, 100, .T., .T. } )

	aInfo   := { aSizeAut[1], aSizeAut[2]+5, aSizeAut[3], aSizeAut[4], 3, 3 }
	aPosObj := MsObjSize(aInfo, aObjects)

	For nY:=1 to Len(aListCpo)
		SX3->(dbSetOrder(2))
		SX3->(dbSeek(aListCpo[nY]))
		If (X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)
			_cFuncIni := "u_RelinM('"+Alltrim(SX3->X3_CAMPO)+"')"
			_cValid	  := "u_ValDivD()"
			_cValUser := "u_ValDivU()"
			aAdd(aHead, { AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				_cValid,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				IIF(!(Alltrim(SX3->X3_CAMPO) $ "PB1_ITEM/PB1_QUANT/PB1_VUNIT/PB1_TOTAL"),_cFuncIni, SX3->X3_RELACAO),;
				SX3->X3_WHEN,;
				IIF(Alltrim(SX3->X3_CAMPO) $ "PB1_QUANT/PB1_VUNIT/PB1_TOTAL","A",SX3->X3_VISUAL),;
				_cValUser,;
				SX3->X3_PICTVAR,;
				SX3->X3_OBRIGAT})
		EndIf
	Next

	Aadd(aCol,Array(Len(aHead)+1))
	For nx:=1 to Len(aListCpo)
		_nPosCpo := ASCAN(aHeader,{|x| Alltrim(x[2]) == Alltrim(aListCpo[nx])})
		_nPosCp := ASCAN(aHead,{|x| Alltrim(x[2]) == Alltrim(aListCpo[nx])})
		aCol[Len(aCol),_nPosCp] := aCols[n,_nPosCpo]
	Next
	aCol[Len(aCol),Len(aHead)+1] := .F.

	Aadd(aCol,Array(Len(aHead)+1))
	For nx:=1 to Len(aListCpo)
		If aHead[nX,8] == "N"
			aCol[Len(aCol),nx] := 0
		Else
			aCol[Len(aCol),nx] := "---"
		Endif
	Next
	aCol[Len(aCol),Len(aHead)+1] := .T.

	Aadd(aCol,Array(Len(aHead)+1))
	For nx:=1 to Len(aListCpo)
		_nPosCpo := ASCAN(aHeader,{|x| Alltrim(x[2]) == Alltrim(aListCpo[nX])})
		_nPosCp := ASCAN(aHead,{|x| Alltrim(x[2]) == Alltrim(aListCpo[nx])})
		If Alltrim(aListCpo[nx]) $ "PB1_QUANT/PB1_VUNIT/PB1_TOTAL"
			aCol[Len(aCol),_nPosCp] := 0
		ElseIf Alltrim(aListCpo[nx]) $ "PB1_ITEM"
			aCol[Len(aCol),_nPosCp] := Soma1(aCols[Len(aCols),_nPosCpo])
		Else
			aCol[Len(aCol),_nPosCp] := aCols[n,_nPosCpo]
		Endif
	Next
	aCol[Len(aCol),Len(aHead)+1] := .F.

	DEFINE MSDIALOG oDlg TITLE "Dividir Item do XML" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	oGtd1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,_nModo,cLinhaOk:="u_GerLinM()",cTudoOk,'+PB1_ITEM',;
		aAlter,nFreeze,nMax,cCampoOk,cSuperApagar:=.F.,cApagaOk:=.F.,,aHead,aCol)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .and. VlddM140(),(nOpca:=1,oDlg:End()), .F. )},{||oDlg:End()})

	If nOpca == 1
		aColsOri[n,Len(aHeader)+1] := .t.
		_nAte := Len(aColsOri) + Len(oGtd1:aCols)-3
		_nIni := Len(aColsOri)
		For nH:=_nIni to _nAte
			Aadd(aColsOri,Array(Len(aHeader)+1))
			For nx:=1 to Len(aHeader)
				If Alltrim(aHeader[nX,2]) $ "PB1_ITEM/PB1_QUANT/PB1_VUNIT/PB1_TOTAL"
					_nPosCpo:= ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == Alltrim(aHeader[nX,2])})
					aColsOri[Len(aColsOri),nX] := oGtd1:aCols[nH-_nIni+3,_nPosCpo]
				Else
					aColsOri[Len(aColsOri),nX] := aColsOri[n,nX]
				Endif
			Next
			aColsOri[Len(aColsOri),Len(aHeader)+1] := .F.
		Next
		aCols:=aClone(aColsOri)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VlddM140

	Local _nPosQtd := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT"})
	Local _nPosVun := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_VUNIT"})
	Local _nPosTot := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_TOTAL"})
	Local I
	Local _nQtde := 0
	Local _nVlr  := 0
	Local _lRet := .t.
	_nQtdVl := oGtd1:aCols[1,_nPosQtd]
	_nVunVl := oGtd1:aCols[1,_nPosVun]
	_nTot   := oGtd1:aCols[1,_nPosTot]

	For I:=3 to Len(oGtd1:aCols)
		_nQtde+=oGtd1:aCols[I,_nPosQtd]
		_nVlr+=oGtd1:aCols[I,_nPosTot]
	Next

	If QtdComp(_nQtdVl) <> QtdComp(_nQtde)
		Alert("A somatoria da Quantidade dos itens esta diferente da quantidade do item desmembrado!")
		_lRet := .f.
	Endif

//If _lRet .and. QtdComp( _nTot) <> QtdComp(_nVlr)
	If _lRet .and. QtdComp( Round( _nTot, 2 ) ) <> QtdComp( Round( _nVlr, 2 ) )
		Alert("A somatoria do Valor Total dos itens esta diferente do Valor Total do item desmembrado!")
		_lRet := .f.
	Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GerLinM

	Local _lRet := .t.
	Local _aArea := GetArea()
	Local _nPosQtd := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT"})
	Local _nPosVun := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_VUNIT"})
	Local _nPosTot := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == "PB1_TOTAL"})

	If !oGtd1:aCols[n,Len(oGtd1:aHeader)+1]
		If Empty(oGtd1:aCols[n,_nPosQtd])
			_lRet := .f.
			Alert("Informar a quantidade")
		Endif
		If _lRet .and. Empty(oGtd1:aCols[n,_nPosVun])
			_lRet := .f.
			Alert("Informar o Valor Unitario")
		Endif
		If _lRet .and. Empty(oGtd1:aCols[n,_nPosTot])
			_lRet := .f.
			Alert("Informar o Valor Total")
		Endif
	Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelinM(_cCampo)

	Local _aArea := GetArea()
	Local _nPosCpo := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == Alltrim(_cCampo)})
	Local _cRet := oGtd1:aCols[1,_nPosCpo]
Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValDivU(aHeader,aCols)
	Local _lRet 	:= .T.

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  09/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValDivD

	Local _lRet := .t.
	Local _cVariavel := Substr(ReadVar(),4)
	Local _nPosCpo := ASCAN(oGtd1:aHeader,{|x| Alltrim(x[2]) == Alltrim(_cVariavel)})

	If n <= 2
		_lRet := .f.
		Alert("Item nao pode ser alterado")
	Endif

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SCOMA001  ºAutor  ³Microsiga           º Data ³  08/30/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Bxa_NFPD4(_cCliFor, _cLoja, _cProd, _nQtde)

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
	memowrite("c:/temp/Bxa_NFPD4.sql",_cQuery)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EB_M140   ºAutor  ³Microsiga           º Data ³  02/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function InclNFFr()

	MATA116(aCabec,aItens,3)
Return


/*
=======================================================
Italo Maciel - 05/07/18
=======================================================
Grava validações na tabela temporaria para exibição
=======================================================
Parâmetros:
cAliasTMP = Tabela temporaria dos erros
lGrv	  = Se apenas consulta (.T.) ou grava (.F.)
=======================================================
*/
User Function fVldXml(lConsul)
	Local nSaldo 	:= 0
	Local lRet 		:= .T.
	Local cQuery 	:= ""
	Local cPed		:= ""
	Local cCod		:= ""
	Local cEdi		:= ""
	Local cMarca	:= ""
	Local nCod		:= 0
	Local aCod		:= {}
	Local cCFGar    := SuperGetMV("MV_XCFGAR",.F.,'202/411/915/949')

	//logar na filial correta
	If cFilAnt <> PB0->PB0_FILIAL
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		If SM0->(dbSeek("01" + PB0->PB0_FILIAL,.T.)) //Posiciona Empresa
			//Seto as variaveis de ambiente
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := SM0->M0_CODFIL
			OpenFile(cEmpAnt + cFilAnt)
		EndIf
	EndIf

	/////////////////////////////////////////////
	//Validação cabeçalho
	////////////////////////////////////////////
	//condição de pagamento
	If Empty(PB0->PB0_COND)
		If !lConsul
			fGrvErro(,"","","Condição de pagamento não preenchida","001","",.T.)
		Else
			lRet := .F.
		EndIf
	Else
		fGrvErro(,,,,"001",,.F.)
	EndIf

	//Fornecedor
	If Empty(PB0->PB0_FORNEC)
		If !lConsul
			fGrvErro(,"","","Fornecedor não preenchido","002","",.T.)
		Else
			lRet := .F.
		EndIf
	Else
		fGrvErro(,,,,"002",,.F.)
	EndIf
	//Emissao
	If Empty(PB0->PB0_EMISSA)
		If !lConsul
			fGrvErro(,"","","Data de emissão não preenchida","003","",.T.)
		Else
			lRet := .F.
		EndIf
	Else
		fGrvErro(,,,,"003",,.F.)
	EndIf
	//Tipo
	If Empty(PB0->PB0_TIPO)
		If !lConsul
			fGrvErro(,"","","Tipo da nota não preenchido","004","",.T.)
		Else
			lRet := .F.
		EndIf
	Else
		fGrvErro(,,,,"004",,.F.)
	EndIf
	//Nota Fiscal
	If (Empty(PB0->PB0_DOC) .And. PB0->PB0_FORMUL != "S")
		If !lConsul
			fGrvErro(,"","","Número da Nota não preenchido","005","",.T.)
		Else
			lRet := .F.
		EndIf
	Else
		fGrvErro(,,,,"005",,.F.)
	EndIf

	/////////////////////////////////////////////
	//Validação dos itens
	////////////////////////////////////////////
	dbSelectArea("PB1")
	PB1->(dbSetOrder(1))
	PB1->(dbSeek(PB0->PB0_FILIAL + PB0->PB0_DOC + PB0->PB0_SERIE + PB0->PB0_FORNEC + PB0->PB0_LOJA))

	While PB1->(!EOF()) .AND. PB0->PB0_FILIAL == PB1->PB1_FILIAL .AND. PB0->PB0_DOC == PB1->PB1_DOC .AND.;
			PB0->PB0_SERIE == PB1->PB1_SERIE .AND. PB0->PB0_FORNEC == PB1->PB1_FORNEC .AND. PB0->PB0_LOJA == PB1->PB1_LOJA

		If !Empty(PB1->PB1_COD)

			If SB1->(MsSeek(xFilial("SB1") + PB1->PB1_COD))		

				If SUBSTR(PB1->PB1_CF,2,3) <> "910"

					//Retira inconsistência "Produto não encontrado"
					fGrvErro(,PB1->PB1_ITEM,,,"007",,.F.)

					//Retira inconsistência "Nacionalidade diferente"
					fGrvErro(,PB1->PB1_ITEM,,,"016",,.F.)

					//Retira inconsistência "Fornecedor não relacionado a Marca"
					fGrvErro(,PB1->PB1_ITEM,,,"019",,.F.)

				End If

				//TESTA PRODUTOS COM MESMO EDI
				cQuery := " SELECT B1_COD,B1_XBLQPC,B1_XEDI,B1_XMARCA FROM " + RETSQLNAME("SB1") + " A "
				cQuery += " WHERE D_E_L_E_T_ = ' ' "
				cQuery += " AND B1_XMARCA IN (SELECT ZZM_CODMAR FROM " + RETSQLNAME("ZZM") + " A WHERE  A.D_E_L_E_T_ = ' ' AND ZZM_FORNEC = '" + PB0->PB0_FORNEC + "')
				If !Empty(PB1->PB1_COD)
					//cQuery += " AND B1_XEDI || B1_ORIGEM = '"+ SB1->B1_XEDI + SB1->B1_ORIGEM +"' "
					cQuery += " AND B1_XEDI = '"+SB1->B1_XEDI+"' AND B1_ORIGEM = '"+ SB1->B1_ORIGEM +"' "
				Else
					cQuery += " AND B1_XEDI = '"+PB1->PB1_PRDFOR+"' AND B1_ORIGEM = '"+ PB1->PB1_ORIPRD +"' "
				EndIf

				cQuery := ChangeQuery(cQuery)

				TCQUERY cQuery NEW ALIAS "QCOD"

				cCod := ""
				aCod := {}
				nCod := 0

				If !Empty(QCOD->B1_COD)
					If QCOD->B1_XBLQPC <> '1'
						cCod += Alltrim(QCOD->B1_COD)+"(Ativo)"
					Else
						cCod += Alltrim(QCOD->B1_COD)+"(Canc.)"
					EndIf
					AADD(aCod,QCOD->B1_COD)
				EndIf

				While !QCOD->(EOF())
					cEdi 	:= QCOD->B1_XEDI
					cMarca 	:= QCOD->B1_XMARCA
					//Contador da quantidade
					nCod++

					If Empty(aScan(aCod,{|x| Alltrim(x) == alltrim(QCOD->B1_COD) }))
						cCod += ", "

						If QCOD->B1_XBLQPC <> '1'
							cCod += Alltrim(QCOD->B1_COD)+"(Ativo)"
						Else
							cCod += Alltrim(QCOD->B1_COD)+"(Canc.)"
						EndIf
						AADD(aCod,QCOD->B1_COD)
					EndIf

					QCOD->(dbSkip())
				EndDo

				QCOD->(dbCloseArea())

				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					If !Empty(cCod) .AND. nCod > 1
						fGrvErro(,PB1->PB1_ITEM,cEdi/*SB1->B1_COD*/,"Para o mesmo código de EDI ("+Alltrim(cEdi)+") e Fornecedor ("+Alltrim(cMarca)+"), existem os Produtos: " + cCod,"014","",.T.)
					Else
						fGrvErro(,PB1->PB1_ITEM,,,"014",,.F.)
					EndIf
				End If

				//Valida quantidade de produtos com o mesmo codbar
				cQuery := " SELECT COUNT(*) TOT "
				cQuery += " FROM " + RETSQLNAME("SB1")
				cQuery += " WHERE D_E_L_E_T_ = ' ' "
				cQuery += " AND B1_MSBLQL <> '1' "
				cQuery += " AND B1_ORIGEM = '"+ SB1->B1_ORIGEM +"' "
				cQuery += " AND B1_CODBAR = '"+ SB1->B1_CODBAR +"' "

				cQuery := ChangeQuery(cQuery)

				TCQUERY cQuery NEW ALIAS "QBARRAS"

				If QBARRAS->TOT > 1 .AND. Val(SB1->B1_CODBAR) > 0
					If !lConsul
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Existem produtos com o Código de Barras repetido: " + SB1->B1_CODBAR,"018","",.T.)
						End If
					Else
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							lRet := .F.
						End If
					EndIf
				Else
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"018",,.F.)
					End If
				EndIf

				QBARRAS->(dbCloseArea())

				//Endereço
				dbSelectArea("SZ8")
				SZ8->(dbSetOrder(1))
				If SZ8->(dbSeek(xFilial("SZ8") + PB1->PB1_COD))
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"017",,.F.)
					End If
				EndIf

				//Armazem
				If Empty(SB1->B1_LOCPAD)
					If !lConsul
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							fGrvErro(,PB1->PB1_ITEM,SB1->B1_COD,"Produto cadastrado sem armazém","006","",.T.)
						End If
					Else
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							lRet := .F.
						End If
					EndIf
				Else
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"006",,.F.)
					End If
				EndIf
			EndIf
		Else
			If !lConsul
				aMarca := {}
				//Busca Marcas
				dbSelectArea("ZZM")
				ZZM->(dbSetOrder(1))
				If ZZM->(dbSeek(xFilial("ZZM") + PB1->PB1_FORNEC + PB1->PB1_LOJA))
					While !ZZM->(EOF()) .AND. ZZM->ZZM_FORNEC == PB1->PB1_FORNEC .AND. ZZM->ZZM_LOJA == PB1->PB1_LOJA
						AADD(aMarca,ZZM->ZZM_CODMAR)
						ZZM->(dbSkip())
					EndDo
				EndIf

				If Empty(aMarca) .AND. Alltrim(SubStr(PB1->PB1_CNPJ,1,8)) != '11509676'
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,;
							PB1->PB1_PRDFOR,;
							"Fornecedor "+Alltrim(PB1->PB1_FORNEC)+" não está relacionado a nenhuma Marca (ZZM)"  ,;
							"019",;
							"",;
							.T.)
					End If
				Else
					//Retira inconsistência "Fornecedor não relacionado a Marca"
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"019",,.F.)
					End If
				EndIf

				lAchouPrd := .F.

				For nX := 1 to Len(aMarca)
					SB1->(DbOrderNickName("EDI"))

					If SB1->(dbSeek(xFilial("SB1")+ PadR(PB1->PB1_PRDFOR,TamSX3("B1_XEDI")[1]) + aMarca[nX]))
						lAchouPrd := .T.

						//Define origem nacional/importada
						If SB1->B1_ORIGEM $ "1#2#3#8"
							cOriCad := "Importado"
						ElseIf SB1->B1_ORIGEM $ "0#4#5#6#7"
							cOriCad := "Nacional"
						EndIf

						//Define origem nacional/importada
						If PB1->PB1_ORIPRD $ "1#2#3#8"
							cOriNF := "Importado"
						ElseIf PB1->PB1_ORIPRD $ "0#4#5#6#7"
							cOriNF := "Nacional"
						EndIf

						If cOriNF <> cOriCad//PB1->PB1_ORIPRD <> SB1->B1_ORIGEM
							If SB1->B1_MSBLQL <> '1'
								//Retira inconsistência "Produto bloqueado"
								If SUBSTR(PB1->PB1_CF,2,3) <> "910"
									fGrvErro(,PB1->PB1_ITEM,,,"020",,.F.)						

									fGrvErro(,PB1->PB1_ITEM,;
										PB1->PB1_PRDFOR,;
										"Produto "+Alltrim(SB1->B1_COD)+" está com origem diferente entre o cadastro e a NF. Origem no cadastro: "+SB1->B1_ORIGEM + "-"+cOriCad+" e Origem NF: "+ PB1->PB1_ORIPRD + "-"+cOriNF  ,;
										"016",;
										"",;
										.T.)
								End If
							Else

								fGrvErro(,PB1->PB1_ITEM,;
									PB1->PB1_PRDFOR,;
									"Produto "+Alltrim(SB1->B1_COD)+" encontrado no cadastro está bloqueado",;
									"020",;
									"",;
									.T.)

							EndIf
						Else
							//Retira inconsistência "Origem diferente"
							If SUBSTR(PB1->PB1_CF,2,3) <> "910"
								fGrvErro(,PB1->PB1_ITEM,,,"016",,.F.)
							End If

							If SB1->B1_MSBLQL == '1'

								fGrvErro(,PB1->PB1_ITEM,;
									PB1->PB1_PRDFOR,;
									"Produto "+Alltrim(SB1->B1_COD)+" encontrado no cadastro está bloqueado",;
									"020",;
									"",;
									.T.)

							EndIf
						EndIf
					Else
						SB1->(DbOrderNickName("CODBAR"))

						If SB1->(dbSeek(xFilial("SB1") + PB1->PB1_CODBAR + aMarca[nX]))
							lAchouPrd := .T.

							//Define origem nacional/importada
							If SB1->B1_ORIGEM $ "1#2#3#8"
								cOriCad := "Importado"
							ElseIf SB1->B1_ORIGEM $ "0#4#5#6#7"
								cOriCad := "Nacional"
							EndIf

							//Define origem nacional/importada
							If PB1->PB1_ORIPRD $ "1#2#3#8"
								cOriNF := "Importado"
							ElseIf PB1->PB1_ORIPRD $ "0#4#5#6#7"
								cOriNF := "Nacional"
							EndIf

							If cOriNF <> cOriCad//PB1->PB1_ORIPRD <> SB1->B1_ORIGEM
								//Retira inconsistência "Produto bloqueado"
								If SUBSTR(PB1->PB1_CF,2,3) <> "910"
									fGrvErro(,PB1->PB1_ITEM,,,"020",,.F.)
								End If

								If SB1->B1_MSBLQL <> '1'
									If SUBSTR(PB1->PB1_CF,2,3) <> "910"
										fGrvErro(,PB1->PB1_ITEM,;
											PB1->PB1_PRDFOR,;
											"Produto "+Alltrim(SB1->B1_COD)+" está com origem diferente entre o cadastro e a NF. Origem no cadastro: "+SB1->B1_ORIGEM + "-"+cOriCad+" e Origem NF: "+ PB1->PB1_ORIPRD + "-"+cOriNF ,;
											"016",;
											"",;
											.T.)
									End If
								Else

									fGrvErro(,PB1->PB1_ITEM,;
										PB1->PB1_PRDFOR,;
										"Produto "+Alltrim(SB1->B1_COD)+" encontrado no cadastro está bloqueado",;
										"020",;
										"",;
										.T.)

								EndIf
							Else
								//Retira inconsistência "Origem diferente"
								If SUBSTR(PB1->PB1_CF,2,3) <> "910"
									fGrvErro(,PB1->PB1_ITEM,,,"016",,.F.)
								End If

								If SB1->B1_MSBLQL == '1'

									fGrvErro(,PB1->PB1_ITEM,;
										PB1->PB1_PRDFOR,;
										"Produto "+Alltrim(SB1->B1_COD)+" encontrado no cadastro está bloqueado",;
										"020",;
										"",;
										.T.)

								EndIf
							EndIf
						Endif
					EndIf
				Next nX

				If !lAchouPrd .AND. Alltrim(SubStr(PB1->PB1_CNPJ,1,8)) != '11509676'
					
					fGrvErro(,PB1->PB1_ITEM,;
						PB1->PB1_PRDFOR,;
						"Produto não encontrado no cadastro, para o EDI ("+Alltrim(PB1->PB1_PRDFOR)+")",;
						"007",;
						"",;
						.T.)
					
				EndIf

			Else
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					lRet := .F.
				End If
			EndIf
		EndIf
		//Quantidade
		If Empty(PB1->PB1_QUANT) .AND. PB0->PB0_TIPO $ "NDB" .AND. Alltrim(PB0->PB0_ESPECI) <> "CTE"
			If !lConsul
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					If !Empty(PB1->PB1_COD)
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Quantidade zerada","008","",.T.)
					Else
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_PRDFOR,"Quantidade zerada","008","",.T.)
					EndIf
				End If
			Else
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					lRet := .F.
				End If
			EndIf
		Else
			If SUBSTR(PB1->PB1_CF,2,3) <> "910"
				fGrvErro(,PB1->PB1_ITEM,,,"008",,.F.)
			End If
		EndIf
		//Valor Unitario
		If Empty(PB1->PB1_VUNIT)
			If !lConsul
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					If !Empty(PB1->PB1_COD)
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Valor unitário zerado","009","",.T.)
					Else
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_PRDFOR,"Valor unitário zerado","009","",.T.)
					EndIf
				End If
			Else
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					lRet := .F.
				End If
			EndIf
		Else
			If SUBSTR(PB1->PB1_CF,2,3) <> "910"
				fGrvErro(,PB1->PB1_ITEM,,,"009",,.F.)
			End If
		EndIf
		//Total do Item
		If Empty(PB1->PB1_TOTAL)
			If !lConsul
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					If !Empty(PB1->PB1_COD)
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Valor total zerado","010","",.T.)
					Else
						fGrvErro(,PB1->PB1_ITEM,PB1->PB1_PRDFOR,"Valor total zerado","010","",.T.)
					EndIf
				End If
			Else
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					lRet := .F.
				End If
			EndIf
		Else
			If SUBSTR(PB1->PB1_CF,2,3) <> "910"
				fGrvErro(,PB1->PB1_ITEM,,,"010",,.F.)
			End If
		EndIf
		//Pedido ou item não preenchido
		dbSelectArea("ZZS")
		ZZS->(dbSetOrder(1))
		If ZZS->(dbSeek(xFilial("ZZS") + PB1->PB1_DOC + PB1->PB1_SERIE + PB1->PB1_FORNEC + PB1->PB1_LOJA + PB1->PB1_ITEM))

			If SUBSTR(PB1->PB1_CF,2,3) <> "910"
				fGrvErro(,PB1->PB1_ITEM,,,"013",,.F.)
				fGrvErro(,PB1->PB1_ITEM,,,"015",,.F.)
			End If

			nSaldo := fQtdAten()
			If PB1->PB1_QUANT > nSaldo
				dbSelectArea("PB3")
				PB3->(dbSetOrder(2))
				PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + "012"))
				If Empty(PB3->PB3_USER)
					If !lConsul
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Quantidade da NF ( "+cValToChar(PB1->PB1_QUANT)+" ) maior que saldo do(s) Pedido(s) ( "+cValtoChar(nSaldo)+" )","012",ZZS->ZZS_PEDIDO,.T.)
						End If
					Else
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							lRet := .F.
						End If
					EndIf
				Else
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"012",,.F.)
					End If
				EndIf
			Else
				If SUBSTR(PB1->PB1_CF,2,3) <> "910"
					fGrvErro(,PB1->PB1_ITEM,,,"012",,.F.)
				End If
			EndIf
		Else
			If PB0->PB0_TIPO == 'N' .AND. PB0->PB0_ESPECI <> 'CTE' .AND. !(SubStr(ALLTRIM(PB1->PB1_CF),2,3) $ cCFGar) //.AND. Alltrim(SubStr(PB1->PB1_CNPJ,1,8)) != '11509676' //LIBERAR TRANSFERENCIA SEM INFORMAR PEDIDO
				dbSelectArea("PB3")
				PB3->(dbSetOrder(2))
				PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + "013"))
				If Empty(PB3->PB3_USER)
					If !lConsul
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							If !Empty(PB1->PB1_COD)
								fGrvErro(,PB1->PB1_ITEM,PB1->PB1_COD,"Item sem Pedido, para o EDI ("+Alltrim(PB1->PB1_PRDFOR)+") - Quantidade da NF ( "+cValToChar(PB1->PB1_QUANT)+" )","013","",.T.)
							Else
								fGrvErro(,PB1->PB1_ITEM,PB1->PB1_PRDFOR,"Item sem Pedido, para o EDI ("+Alltrim(PB1->PB1_PRDFOR)+") - Quantidade da NF ( "+cValToChar(PB1->PB1_QUANT)+" )","013","",.T.)
							EndIf
						End If

						//Valida quantidade de produtos com o mesmo EDI
						cQuery := " SELECT C7_FILIAL,B1_COD,B1_XEDI,C7_QUJE,C7_NUM,B1_XMARCA FROM " + RETSQLNAME("SC7") + " A "
						cQuery += " INNER JOIN "+ RETSQLNAME("SB1") + " B ON B.D_E_L_E_T_ = ' ' AND B1_COD = C7_PRODUTO "
						cQuery += " WHERE  A.D_E_L_E_T_ = ' '
						If !Empty(PB1->PB1_COD)
							//cQuery += " AND B1_XEDI || B1_ORIGEM = '"+ SB1->B1_XEDI + SB1->B1_ORIGEM +"' "
							cQuery += " AND B1_XEDI = '"+ SB1->B1_XEDI +"' AND B1_ORIGEM = '"+ SB1->B1_ORIGEM +"' "
						Else
							//cQuery += " AND B1_XEDI || B1_ORIGEM = '"+ PB1->PB1_PRDFOR + PB1->PB1_ORIPRD +"' "
							cQuery += " AND B1_XEDI = '"+ PB1->PB1_PRDFOR+"' AND B1_ORIGEM = '" + PB1->PB1_ORIPRD +"' "
						EndIf
						cQuery += " AND C7_FILIAL = '" + PB0->PB0_FILIAL + "' "
						cQuery += " AND B1_XMARCA IN (SELECT ZZM_CODMAR FROM " + RETSQLNAME("ZZM") + " A WHERE  A.D_E_L_E_T_ = ' ' AND ZZM_FORNEC = '" + PB0->PB0_FORNEC + "')
						cQuery += " AND C7_QUANT - C7_QUJE - C7_QTDACLA >= "+ cValToChar(PB1->PB1_QUANT)

						cQuery := ChangeQuery(cQuery)

						TCQUERY cQuery NEW ALIAS "QEDI"

						cPed := ""

						If !Empty(QEDI->C7_NUM)
							cPed += Alltrim(QEDI->C7_NUM)+"("+Alltrim(QEDI->B1_COD)+")"
						EndIf

						While !QEDI->(EOF())
							If !QEDI->C7_NUM $ cPed
								cPed += ", "
								cPed += Alltrim(QEDI->C7_NUM)+"("+Alltrim(QEDI->B1_COD)+")"
							EndIf

							QEDI->(dbSkip())
						EndDo

						cQuery := " SELECT B1_COD,B1_XBLQPC,B1_XEDI,B1_XMARCA FROM " + RETSQLNAME("SB1") + " A "
						cQuery += " WHERE D_E_L_E_T_ = ' ' "
						cQuery += " AND B1_XMARCA IN (SELECT ZZM_CODMAR FROM " + RETSQLNAME("ZZM") + " A WHERE  A.D_E_L_E_T_ = ' ' AND ZZM_FORNEC = '" + PB0->PB0_FORNEC + "')
						If !Empty(PB1->PB1_COD)
							cQuery += " AND B1_XEDI || B1_ORIGEM = '"+ SB1->B1_XEDI + SB1->B1_ORIGEM +"' "
						Else
							cQuery += " AND B1_XEDI || B1_ORIGEM = '"+ PB1->PB1_PRDFOR + PB1->PB1_ORIPRD +"' "
						EndIf

						cQuery := ChangeQuery(cQuery)

						TCQUERY cQuery NEW ALIAS "QCOD"

						cCod := ""
						aCod := {}
						nCod := 0

						If !Empty(QCOD->B1_COD)
							If QCOD->B1_XBLQPC <> '1'
								cCod += Alltrim(QCOD->B1_COD)+"(Ativo)"
							Else
								cCod += Alltrim(QCOD->B1_COD)+"(Canc.)"
							EndIf
							AADD(aCod,QCOD->B1_COD)
						EndIf

						While !QCOD->(EOF())
							cEdi 	:= QCOD->B1_XEDI
							cMarca 	:= QCOD->B1_XMARCA
							//Contador da quantidade
							nCod++

							If Empty(aScan(aCod,{|x| Alltrim(x) == alltrim(QCOD->B1_COD) }))
								cCod += ", "

								If QCOD->B1_XBLQPC <> '1'
									cCod += Alltrim(QCOD->B1_COD)+"(Ativo)"
								Else
									cCod += Alltrim(QCOD->B1_COD)+"(Canc.)"
								EndIf
								AADD(aCod,QCOD->B1_COD)
							EndIf

							QCOD->(dbSkip())
						EndDo

						If SUBSTR(PB1->PB1_CF,2,3) <> "910"

							If !Empty(cCod) .AND. nCod > 1
								fGrvErro(,PB1->PB1_ITEM,cEdi/*SB1->B1_COD*/,"Para o mesmo código de EDI ("+Alltrim(cEdi)+") e Fornecedor ("+Alltrim(cMarca)+"), existem os Produtos: " + cCod,"014","",.T.)
							Else
								fGrvErro(,PB1->PB1_ITEM,,,"014",,.F.)
							EndIf

							If !Empty(cPed)
								//fGrvErro(,PB1->PB1_ITEM,cEdi/*SB1->B1_COD*/,"Para o mesmo código de EDI ("+Alltrim(cEdi)+") e Fornecedor ("+Alltrim(cMarca)+"), existem os Pedidos: " + cPed,"015","",.T.)
							EndIf

						End If

						QEDI->(dbCloseArea())
						QCOD->(dbCloseArea())

					Else
						If SUBSTR(PB1->PB1_CF,2,3) <> "910"
							lRet := .F.
						End If
					EndIf
				Else
					If SUBSTR(PB1->PB1_CF,2,3) <> "910"
						fGrvErro(,PB1->PB1_ITEM,,,"013",,.F.)
						//fGrvErro(,PB1->PB1_ITEM,,,"014",,.F.)
						fGrvErro(,PB1->PB1_ITEM,,,"015",,.F.)
					End If
				EndIf
			EndIf
		EndIf

		PB1->(dbSkip())
	EndDo

Return lRet

/*
Italo Maciel
05/07/18
Grava erros na tabela
*/
Static Function fGrvErro(cAlias,cItem,cProd,cErro,cCodErro,cPedido,lGrv)

	If lGrv
		dbSelectArea("PB3")
		If !Empty(cItem)
			PB3->(dbSetOrder(1))
			If !PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + cItem + cCodErro))
				RecLock("PB3",.T.)
				Replace PB3_FILIAL with PB0->PB0_FILIAL
				Replace PB3_DOC    with PB0->PB0_DOC
				Replace PB3_SERIE  with PB0->PB0_SERIE
				Replace PB3_PEDIDO with cPedido
				Replace PB3_FORNEC with PB0->PB0_FORNEC
				Replace PB3_ITEM   with cItem
				Replace PB3_PROD   with cProd
				Replace PB3_CODERR with cCodErro
				Replace PB3_ERRO   with cErro
				Replace PB3_STATUS with '1'
				PB3->(MsUnlock())
			Else
				RecLock("PB3",.F.)
				Replace PB3_STATUS with '1'
				PB3->(MsUnlock())
			EndIf
		ELse
			PB3->(dbSetOrder(2))
			If !PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + cCodErro))
				RecLock("PB3",.T.)
				Replace PB3_FILIAL with PB0->PB0_FILIAL
				Replace PB3_DOC    with PB0->PB0_DOC
				Replace PB3_SERIE  with PB0->PB0_SERIE
				Replace PB3_PEDIDO with cPedido
				Replace PB3_FORNEC with PB0->PB0_FORNEC
				Replace PB3_PROD   with cProd
				Replace PB3_CODERR with cCodErro
				Replace PB3_ERRO   with cErro
				Replace PB3_STATUS with '1'
				PB3->(MsUnlock())
			Else
				RecLock("PB3",.F.)
				Replace PB3_STATUS with '1'
				PB3->(MsUnlock())
			EndIf
		EndIf
	Else
		dbSelectArea("PB3")
		If !Empty(cItem)
			PB3->(dbSetOrder(1))
			If PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + cItem + cCodErro))
				RecLock("PB3",.F.)
				Replace PB3_STATUS with '2'
				PB3->(MsUnlock())
			EndIf
		Else
			PB3->(dbSetOrder(2))
			If PB3->(dbSeek(PB0->(PB0_FILIAL + PB0_DOC + PB0_SERIE + PB0_FORNEC) + cCodErro))
				RecLock("PB3",.F.)
				Replace PB3_STATUS with '2'
				PB3->(MsUnlock())
			EndIf
		EndIf
	EndIf

Return


/*
Italo Maciel
10/07/18
Amarra os itens aos pedidos de compra
*/
Static Function fInfPed()
	Local oDlg
	Local oTGet1
	Local oSay1
	Local cTGet1 	:= Space(150)
	Local lOk 		:= .T.

	SetKey( VK_F7, { || NIL } )
	SetKey( VK_F8, { || NIL } )

	DEFINE MSDIALOG oDlg FROM 000,000 TO 090,320 TITLE "Pedidos de Compra" PIXEL

	oTGet1 := TGet():New(10,02,{ | u | If( PCount() == 0, cTGet1, cTGet1 := Alltrim(u) ) },oDlg,0130,009,"@!",{|| !Empty(cTGet1) },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,,)
	SButton():New(010,133,01,{|| lOk := .T. , oDlg:End() },oDlg,.T.,,)
	oSay1 := TSay():New(22,002,{|| "Incluir os números dos pedidos separados por ponto e vírgula(;). Exemplo: 000001;0000002;000003" },oDlg,,/*oFont*/,,,,.T.,CLR_RED,CLR_WHITE,160,20)

	ACTIVATE MSDIALOG oDlg CENTERED

	If lOk
//Preenche número dos pedidos nos itens da nota
		If !Empty(cTGet1)
			FWMsgRun(,{ || fNumPed(cTGet1) }, "Aguarde", "Procurando Pedidos" )

			If !Empty((cTmpZZS)->(LastRec()))
				fConsPed()
			EndIf
		EndIf
	EndIf

	SetKey( VK_F7, { || fInfPed() } )
	SetKey( VK_F8, { || fConsPed() } )

Return


/*
Italo Maciel
10/07/18
Preencher o código dos pedidos nos itens da nota
*/
Static Function fNumPed(cPed)
	Local aPed		:= Separa(cPed,';')
	Local cTxt1 	:= 'Pedidos não encontrados: ' + Chr(13) + Chr(10)
	Local cErro 	:= ''
	Local cTxt2		:= Chr(13) + Chr(10) + 'Nenhum item será atualizado.'
	Local nPosProd 	:= 0
	Local nPosPed  	:= 0
	Local nPosItem 	:= 0
	Local nPosUnit 	:= 0
	Local nPosQtd	:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local nZ		:= 0
	Local nSaldo	:= 0
	Local lAtuPB0	:= .F.
	Local lAchou	:= .F.
	Local lSobre	:= .F.
	Local cQry		:= " "
	Local aListCond	:= {}
	Local aCond		:= {}
	Local aZZS		:= {}

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	For nX := 1 to Len(aPed)
		If !SC7->(dbSeek(xFilial("SC7") + aPed[nX]))
			cErro += aPed[nX]
			If nX < Len(aPed)
				cErro += " / "
			EndIf
		EndIf
	Next nX

	If !Empty(cErro)
		MsgAlert(cTxt1 + cErro + cTxt2)
		Return
	EndIf

	SC7->(dbSetOrder(2))

	//Consulta se existem pedidos amarrados à NF
	lAchou := fExistPed()

	If lAchou .and. MsgNoYes("Deseja sobrepor os Pedidos preenchidos?","Atenção")
		//Limpa tabela
		cQry := " DELETE FROM "+ oTmp1:GetRealName()
		cQry += " WHERE D_E_L_E_T_ = ' ' "
		cQry += " AND ZZS_FILIAL = '"+ PB0->PB0_FILIAL +"' "
		cQry += " AND ZZS_DOC 	 = '"+ PB0->PB0_DOC +"' "
		cQry += " AND ZZS_SERIE  = '"+ PB0->PB0_SERIE +"' "
		cQry += " AND ZZS_FORNEC = '"+ PB0->PB0_FORNEC +"' "
		cQry += " AND ZZS_LOJANF = '"+ PB0->PB0_LOJA +"' "

		//Executa comando
		TCSqlExec(cQry)
	ElseIf lAchou//Se achou mas não quer sobrescrever
		Return
	EndIf

	fVldSld(aCols,aPed,@aZZS)//valida o saldo dos pedidos

	If !Empty(aZZS)
		dbSelectArea(cTmpZZS)
		For nY := 1 to Len(aZZS)
			Reclock(cTmpZZS,.T.)
			For nX := 1 to (cTmpZZS)->(fCount())
				Replace (cTmpZZS)->(FieldName(nX)) with FieldPut(nX,aZZS[nY][nX])
			Next nX

			//Definir a condição de pagamento
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial("SC7") + aZZS[nY][9]))
				AADD(aListCond,{SC7->C7_COND})
			EndIf

			(cTmpZZS)->(MsUnlock())
		Next nY
	Else
		MsgAlert("Nenhum pedido encontrado ou com inconsistências.","Atenção")
	EndIf

	//Definir a condição de pagamento
	For nX := 1 to Len(aListCond)
		AADD(aCond,Condicao(PB1->PB1_TOTAL,aListCond[nX][1],,dDEmissao))
	Next nX

	nCont := 0
	For nX := 1 to Len(aCond)
		If Len(aCond[nX]) > nCont
			nCont := Len(aCond[nX])
			cCondicao := aListCond[nX][1]
		EndIf
	Next nX

Return

//Valida saldo dos pedidos
Static Function fVldSld(aCols,aPed,aZZS)
	Local cQry
	Local nZ
	Local nX
	Local aSaldo 	:= {}
	Local nQtdAte	:= 0
	Local nSaldo	:= 0
	Local nQtdXml	:= 0
	Local lLoop		:= .T.

	Local nPos
	Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_COD"	})
	Local nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_ITEM"})
	Local nPosQtd  := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT"})

	cQry := " SELECT C7_PRODUTO,(C7_QUANT-C7_QUJE-C7_QTDACLA) SALDO,C7_FORNECE,C7_LOJA,C7_NUM,C7_ITEM,C7_PRECO,C7_COND  "
	cQry += " FROM "+ RETSQLNAME("SC7") +" A "
	cQry += " INNER JOIN "+ RETSQLNAME("SB1") +" B ON B.D_E_L_E_T_ = ' ' AND B1_COD = C7_PRODUTO "
	cQry += " WHERE A.D_E_L_E_T_ = ' ' "
	cQry += " AND C7_FILIAL = '" + xFilial("SC7") + "' "
	cQry += " AND C7_FORNECE IN (SELECT ZZM_FORNEC FROM "+ RETSQLNAME("ZZM") +" WHERE D_E_L_E_T_ = ' ' AND ZZM_CODMAR = B1_XMARCA) "
	cQry += " AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "
	cQry += " AND C7_NUM IN ( "
	For nZ := 1 to Len(aPed)
		cQry += "'" + aPed[nZ] + "'"
		If nZ < Len(aPed)
			cQry += ","
		EndIf
	Next nZ
	cQry += ")"
	cQry += " ORDER BY C7_PRODUTO,C7_EMISSAO "

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QSC7")

	While !QSC7->(EOF())
		AADD(aSaldo,{QSC7->C7_NUM,QSC7->C7_FORNECE,QSC7->C7_LOJA,QSC7->C7_ITEM,QSC7->SALDO,QSC7->C7_PRODUTO})
		QSC7->(dbSkip())
	EndDo

	For nX := 1 to Len(aCols)
		lLoop := .T.
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + aCols[nX][nPosProd]))

		//Quantidade do item no XML
		nQtdXml := aCols[nX][nPosQtd]

		While lLoop
			//Posição no array que contem o item com saldo suficiente
			nPos := aScan(aSaldo,{|x| (Alltrim(x[6]) == Alltrim(SB1->B1_COD) .OR. Alltrim(x[6]) == Alltrim(SB1->B1_XALTIMP)) .AND. x[5] >= nQtdXml })
			If nPos > 0
				aSaldo[nPos][5] := aSaldo[nPos][5] - nQtdXml
				nQtdAte := nQtdXml
				nQtdXml := 0

				//ZZS_FILIAL     ZZS_DOC      ZZS_SERIE      ZZS_FORNEC      ZZS_LOJANF    ZZS_ITEMNF          ZZS_PRODUT  ZZS_DESC     ZZS_PEDIDO      ZZS_FORPED      ZZS_LOJAPC      ZZS_ITEPED      ZZS_QATE
				AADD(aZZS,{xFilial("SC7"),PB0->PB0_DOC,PB0->PB0_SERIE,PB0->PB0_FORNEC,PB0->PB0_LOJA,aCols[nX][nPosItem],SB1->B1_COD,SB1->B1_DESC,aSaldo[nPos][1],aSaldo[nPos][2],aSaldo[nPos][3],aSaldo[nPos][4],nQtdAte})
			Else
				nPos := aScan(aSaldo,{|x| (Alltrim(x[6]) == Alltrim(SB1->B1_COD) .OR. Alltrim(x[6]) == Alltrim(SB1->B1_XALTIMP)) .AND. x[5] > 0 })
				If nPos > 0
					nQtdXml := nQtdXml - aSaldo[nPos][5]
					nQtdAte := aSaldo[nPos][5]
					aSaldo[nPos][5] := 0

					//ZZS_FILIAL     ZZS_DOC      ZZS_SERIE      ZZS_FORNEC      ZZS_LOJANF    ZZS_ITEMNF          ZZS_PRODUT  ZZS_DESC     ZZS_PEDIDO      ZZS_FORPED      ZZS_LOJAPC      ZZS_ITEPED      ZZS_QATE
					AADD(aZZS,{xFilial("SC7"),PB0->PB0_DOC,PB0->PB0_SERIE,PB0->PB0_FORNEC,PB0->PB0_LOJA,aCols[nX][nPosItem],SB1->B1_COD,SB1->B1_DESC,aSaldo[nPos][1],aSaldo[nPos][2],aSaldo[nPos][3],aSaldo[nPos][4],nQtdAte})
				EndIf
			EndIf
			If Empty(nQtdXml) .OR. Empty(nPos)
				lLoop := .F.
			EndIf
		EndDo

	Next nZ

	cQry := " SELECT C7_FORNECE, C7_NUM, B1_XMARCA "
	cQry += " FROM "+ RETSQLNAME("SC7") +" A "
	cQry += " INNER JOIN "+ RETSQLNAME("SB1") +" B ON B.D_E_L_E_T_ = ' ' AND B1_COD = C7_PRODUTO "
	cQry += " WHERE A.D_E_L_E_T_ = ' ' "
	cQry += " AND C7_FILIAL = '" + xFilial("SC7") + "' "
	cQry += " AND C7_FORNECE NOT IN (SELECT ZZM_FORNEC FROM "+ RETSQLNAME("ZZM") +" WHERE D_E_L_E_T_ = ' ' AND ZZM_CODMAR = B1_XMARCA) "
	cQry += " AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "
	cQry += " AND C7_NUM IN ( "
	For nZ := 1 to Len(aPed)
		cQry += "'" + aPed[nZ] + "'"
		If nZ < Len(aPed)
			cQry += ","
		EndIf
	Next nZ
	cQry += ")"
	cQry += " GROUP BY C7_FORNECE, C7_NUM, B1_XMARCA "

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QFORN")

	cTexto := ""
	nItMen := 0
	While ! QFORN->(EOF())
		nItMen++
		cNomForn := POSICIONE("SA2",1,XFILIAL("SA2") + QFORN->C7_FORNECE,"A2_NOME")
		cTexto += cValToChar(nItMen)+"-Fornecedor "+QFORN->C7_FORNECE+"-"+cNomForn+" do Pedido "+QFORN->C7_NUM+" não está relacionado a marca "+QFORN->B1_XMARCA + CHR(13) + CHR(10)
		QFORN->(dbSkip())
	EndDo

	If !Empty(cTexto)
		MsgAlert(cTexto,"Marca não relacionada ao Fornecedor. Informe ao Setor de Compras.")
	EndIf

	QFORN->(dbCloseArea())
	QSC7->(dbCloseArea())

Return

//Valida se já existem pedidos amarrados a este XML
Static Function fExistPed()
	Local lRet 	:= .F.
	Local cQry	:= ""

	cQry := " SELECT COUNT(*) TOT FROM "+ oTmp1:GetRealName()
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND ZZS_FILIAL = '"+ PB0->PB0_FILIAL +"' "
	cQry += " AND ZZS_DOC 	 = '"+ PB0->PB0_DOC +"' "
	cQry += " AND ZZS_SERIE  = '"+ PB0->PB0_SERIE +"' "
	cQry += " AND ZZS_FORNEC = '"+ PB0->PB0_FORNEC +"' "
	cQry += " AND ZZS_LOJANF = '"+ PB0->PB0_LOJA +"' "

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QZZS")

	If QZZS->TOT > 0
		lRet := .T.
	EndIf

	QZZS->(dbCloseArea())

Return lRet

User Function fLoadTemp(cTmpZZS,aArray,cTipo)
	Local cQuery

	cQuery := " SELECT * FROM "+ RETSQLNAME("ZZS")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND ZZS_FILIAL = '"+ aArray[1] +"' "
	If cTipo == "N"
		cQuery += " AND ZZS_DOC    = '"+ aArray[2] +"' "
		cQuery += " AND ZZS_SERIE  = '"+ aArray[3] +"' "
		cQuery += " AND ZZS_FORNEC = '"+ aArray[4] +"' "
		cQuery += " AND ZZS_LOJANF = '"+ aArray[5] +"' "
	ElseIf cTipo == "P"
		cQuery += " AND ZZS_PEDIDO = '"+ aArray[2] +"' "
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY")

	While ! QRY->(EOF())
		RecLock(cTmpZZS,.T.)
		Replace ZZS_FILIAL  with QRY->ZZS_FILIAL
		Replace ZZS_DOC     with QRY->ZZS_DOC
		Replace ZZS_SERIE   with QRY->ZZS_SERIE
		Replace ZZS_FORNEC  with QRY->ZZS_FORNEC
		Replace ZZS_LOJANF  with QRY->ZZS_LOJANF
		Replace ZZS_ITEMNF  with QRY->ZZS_ITEMNF
		Replace ZZS_PRODUT	with QRY->ZZS_PRODUT
		Replace ZZS_DESCPR	with QRY->ZZS_DESCPR
		Replace ZZS_PEDIDO  with QRY->ZZS_PEDIDO
		Replace ZZS_FORPED  with QRY->ZZS_FORPED
		Replace ZZS_LOJAPC  with QRY->ZZS_LOJAPC
		Replace ZZS_ITEPED  with QRY->ZZS_ITEPED
		Replace ZZS_QATE	with QRY->ZZS_QATE
		(cTmpZZS)->(MsUnlock())

		QRY->(dbSkip())
	EndDo

	QRY->(dbCloseArea())

Return

User Function fCriaTemp(cTmpZZS)
	Local aCampos	:= {}

//Array contendo os campos da tabela temporária
	AADD(aCampos,{"ZZS_FILIAL", "C", TamSx3("ZZS_FILIAL")[1], 	0})
	AADD(aCampos,{"ZZS_DOC", 	"C", TamSx3("ZZS_DOC")[1], 		0})
	AADD(aCampos,{"ZZS_SERIE ", "C", TamSx3("ZZS_SERIE")[1],	0})
	AADD(aCampos,{"ZZS_FORNEC", "C", TamSx3("ZZS_FORNEC")[1], 	0})
	AADD(aCampos,{"ZZS_LOJANF", "C", TamSx3("ZZS_LOJANF")[1], 	0})
	AADD(aCampos,{"ZZS_ITEMNF", "C", TamSx3("ZZS_ITEMNF")[1], 	0})
	AADD(aCampos,{"ZZS_PRODUT", "C", TamSx3("ZZS_PRODUT")[1], 	0})
	AADD(aCampos,{"ZZS_DESCPR", "C", TamSx3("ZZS_DESCPR")[1], 	0})
	AADD(aCampos,{"ZZS_PEDIDO", "C", TamSx3("ZZS_PEDIDO")[1], 	0})
	AADD(aCampos,{"ZZS_FORPED", "C", TamSx3("ZZS_FORPED")[1], 	0})
	AADD(aCampos,{"ZZS_LOJAPC", "C", TamSx3("ZZS_LOJAPC")[1], 	0})
	AADD(aCampos,{"ZZS_ITEPED", "C", TamSx3("ZZS_ITEPED")[1], 	0})
	AADD(aCampos,{"ZZS_QATE", 	"N", TamSx3("ZZS_QATE")[1], 	TamSx3("ZZS_QATE")[2]})

//-------------------
//Criação do objeto
//-------------------
	oTmp1 := FWTemporaryTable():New(cTmpZZS)

//--------------------------
//Monta os campos da tabela
//--------------------------
	oTmp1:SetFields(aCampos)

//------------------
//Criação da tabela
//------------------
	oTmp1:Create()

Return

/*
ITALO MACIEL
08/10/18
Rotina para retornar o item da nota de origem
*/
Static Function AtuItemDev()
	Local cAlias 	:= GetNextAlias()

	Local nPosProd 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_COD" 	})
	Local nPosDesc 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_DESCRI"	})
	Local nPosItOri := aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_ITEMOR" })
	Local nPosNfOri	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_NFORI" 	})
	Local nPosSrOri	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_SERIOR" })
	Local nPosUM	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_UM" 	})
	Local nPosTipo	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_TP" 	})
	Local nPosLoc	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_LOCAL" 	})
	Local cNota		:= aCols[N][nPosNfOri]
	Local cSerie	:= aCols[N][nPosSrOri]
	Local cQuery 	:= ""
	Local lOk 		:= .F.
	Local _stru		:= {}
	Local aCpoBro 	:= {}
	Local oDlg
	Local aCores 	:= {}
	Local oTmpTTRB

	Private lInverte:= .F.
	Private cMark   := GetMark()
	Private oMark

	cQuery += " SELECT D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_PRCVEN,D2_QTDEDEV FROM " + RETSQLNAME("SD2") + " A "
	cQuery += " INNER JOIN "+ RETSQLNAME("SB1") +" B ON B.D_E_L_E_T_ = ' ' AND D2_COD = B1_COD "
	cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
	cQuery += " AND D2_FILIAL 	= '"+ xFilial("SF2") +"' "
	cQuery += " AND D2_DOC 		= '"+ cNota +"' "
	cQuery += " AND D2_SERIE 	= '"+ cSerie +"' "
	cQuery += " ORDER BY D2_ITEM "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias)

    //Cria um arquivo de Apoio
	AADD(_stru,{"OK"	,"C",2	,0	})
	AADD(_stru,{"ITEM"	,"C",TamSX3("D2_ITEM")[1]	,0	})
	AADD(_stru,{"PROD"	,"C",TamSX3("D2_COD")[1]	,0	})
	AADD(_stru,{"DESCR"	,"C",20	,0	})
	AADD(_stru,{"VALOR"	,"N",TamSX3("D2_PRCVEN")[1]	,TamSX3("D2_PRCVEN")[2]	})
	AADD(_stru,{"QUANT"	,"N",TamSX3("D2_QUANT")[1]	,TamSX3("D2_QUANT")[2]	})
	AADD(_stru,{"QTDDEV","N",TamSX3("D2_QTDEDEV")[1],TamSX3("D2_QTDEDEV")[2]	})

	oTmpTTRB := FWTemporaryTable():New("TTRB")
	oTmpTTRB:SetFields(_stru)
	oTmpTTRB:Create()

	While ! (cAlias)->(Eof())
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		TTRB->ITEM		:=  (cAlias)->D2_ITEM
		TTRB->PROD		:=  (cAlias)->D2_COD
		TTRB->DESCR		:=  (cAlias)->B1_DESC
		TTRB->QUANT		:=  (cAlias)->D2_QUANT
		TTRB->VALOR		:=  (cAlias)->D2_PRCVEN
		TTRB->QTDDEV	:=  (cAlias)->D2_QTDEDEV
		TTRB->(MsunLock())

		(cAlias)->(DbSkip())
	Enddo

	(cAlias)->(dbCloseArea())

    //Define as cores dos itens de legenda.
	aCores := {}
	aAdd(aCores,{"TTRB->QTDDEV == TTRB->QUANT","BR_VERMELHO"})
	aAdd(aCores,{"TTRB->QTDDEV < TTRB->QUANT .AND. TTRB->QTDDEV > 0","BR_AMARELO"})
	aAdd(aCores,{"TTRB->QTDDEV == 0","BR_VERDE"})

    //Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro	:= {;
		{ "OK"		,, ""			,"@!"						},;
		{ "ITEM"	,, "Item"		,PesqPict("SD2","D2_ITEM")	},;
		{ "PROD"	,, "Produto"	,PesqPict("SD2","D2_COD")	},;
		{ "DESCR"	,, "Descrição"	,PesqPict("SB1","B1_DESC")	},;
		{ "QUANT"	,, "Quantidade"	,PesqPict("SD2","D2_QUANT")	},;
		{ "VALOR"	,, "Valor"	    ,PesqPict("SD2","D2_PRCVEN")},;
		{ "QTDDEV"	,, "Qtd. Devol.",PesqPict("SD2","D2_QTDEDEV")}}

    //Cria uma Dialog
	DEFINE MSDIALOG oDlg TITLE "Nota Fiscal de Origem" From 0,0 To 300,800 PIXEL

	DbSelectArea("TTRB")
	TTRB->(DbGotop())

    //Cria a MsSelect
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{35,0,150,400},,,,,aCores)
	oMark:bMark := {| | Disp()}

    //Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk := .T.,oDlg:End()},{|| oDlg:End()})

	If lOk
		dbSelectArea("TTRB")
		TTRB->(dbGoTop())
		While ! TTRB->(EOF())
			If !Empty(TTRB->OK)
				If Empty(aCols[N][nPosProd])
					aCols[N][nPosProd] 	:= TTRB->PROD
					aCols[N][nPosDesc] 	:= TTRB->DESCR
					aCols[N][nPosUM]	:= Posicione("SB1",1,xFilial("SB1")+TTRB->PROD,"B1_UM")
					aCols[N][nPosLoc]	:= RetFldProd(TTRB->PROD,"B1_LOCPAD")
				Else
					If aCols[N][nPosProd] <> TTRB->PROD .and. MsgNoYes("Código do produto já preenchido. Deseja sobrescrever?","Atenção")
						aCols[N][nPosProd] 	:= TTRB->PROD
						aCols[N][nPosDesc] 	:= TTRB->DESCR
						aCols[N][nPosUM]	:= Posicione("SB1",1,xFilial("SB1")+TTRB->PROD,"B1_UM")
						aCols[N][nPosLoc]	:= RetFldProd(TTRB->PROD,"B1_LOCPAD")
					EndIf
				EndIf
				aCols[N][nPosItOri] := TTRB->ITEM
			EndIf
			TTRB->(dbSkip())
		EndDo
	EndIf

    //Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())

	oTmpTTRB:Delete()
Return

//Funcao executada ao Marcar/Desmarcar um registro.
Static Function Disp()
	Local nPosItem 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "PB1_QUANT" })
	Local cItem 	:= TTRB->ITEM

	dbSelectArea("TTRB")
	TTRB->(dbGoTop())

	While ! TTRB->(EOF())
		RecLock("TTRB",.F.)
		If cItem == TTRB->ITEM
			If (TTRB->QUANT - TTRB->QTDDEV) >= aCols[N][nPosItem]
				TTRB->OK := cMark
			Else
				TTRB->OK := ""
				MsgInfo("Saldo do item insuficiente.","Atenção")
			EndIf
		Else
			TTRB->OK := ""
		EndIf
		TTRB->(MSUNLOCK())

		TTRB->(dbSkip())
	EndDo

	TTRB->(dbGoTop())

	oMark:oBrowse:Refresh()

Return()

//Consultar pedidos amarrados
Static Function fConsPed()
	Local oMarkF
	Local aBrowse := {}
	Local aSize		:= MsAdvSize(.F.)
	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aPosObj	:= {}

	SetKey( VK_F7, { || NIL } )
	SetKey( VK_F8, { || NIL } )

	aadd( aObjects, { 100, 030, .T., .F. } )
	aadd( aObjects, { 100, 090, .T., .T. } )
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj  := MsObjSize( aInfo, aObjects, .T. )

	aadd(aBrowse,{"ZZS_FILIAL"	,,"Filial"})
//aadd(aBrowse,{"ZZS_DOC"  	,,"Nota Fiscal"})
//aadd(aBrowse,{"ZZS_SERIE"  	,,"Serie"})
//aadd(aBrowse,{"ZZS_FORNEC"  ,,"Fornecedor"})
//aadd(aBrowse,{"ZZS_LOJANF"  ,,"Loja"})
	aadd(aBrowse,{"ZZS_ITEMNF"  ,,"Item NF"})
	aadd(aBrowse,{"ZZS_PRODUT"  ,,"Produto"})
	aadd(aBrowse,{"ZZS_DESCPR"  ,,"Descricao"})
	aadd(aBrowse,{"ZZS_PEDIDO"  ,,"Pedido"})
	aadd(aBrowse,{"ZZS_FORPED"  ,,"Forn. Pedido"})
	aadd(aBrowse,{"ZZS_LOJAPC"  ,,"Loja"})
	aadd(aBrowse,{"ZZS_ITEPED"  ,,"Item Pedido"})
	aadd(aBrowse,{"ZZS_QATE"	,,"Qtd. Atend."})

	(cTmpZZS)->(dbGoTop())

	DEFINE MSDIALOG oDlg FROM 000, 000 TO 500, 950 TITLE "Nota Fiscal X Pedidos de Compra" PIXEL

	oMarkF := MsSelect():New(cTmpZZS,,Nil,aBrowse,.F.,Nil,{5,5,245,470},,,,,)

	ACTIVATE MSDIALOG oDlg CENTERED

	SetKey( VK_F7, { || fInfPed() } )
	SetKey( VK_F8, { || fConsPed() } )

Return

//atualizar tabela ZZS com dados da temporaria
Static Function fAtuZZS()
	Local cQry
	Local nX

//Limpa tabela
	cQry := " DELETE FROM "+ RetSqlName("ZZS")
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND ZZS_FILIAL = '"+ PB0->PB0_FILIAL +"' "
	cQry += " AND ZZS_DOC 	 = '"+ PB0->PB0_DOC +"' "
	cQry += " AND ZZS_SERIE  = '"+ PB0->PB0_SERIE +"' "
	cQry += " AND ZZS_FORNEC = '"+ PB0->PB0_FORNEC +"' "
	cQry += " AND ZZS_LOJANF = '"+ PB0->PB0_LOJA +"' "

//Executa comando
	TCSqlExec(cQry)

	dbSelectArea(cTmpZZS)
	(cTmpZZS)->(dbGoTop())

	While ! (cTmpZZS)->(Eof())
		RecLock("ZZS",.T.)
		Replace ZZS_FILIAL with (cTmpZZS)->ZZS_FILIAL
		Replace ZZS_DOC    with (cTmpZZS)->ZZS_DOC
		Replace ZZS_SERIE  with (cTmpZZS)->ZZS_SERIE
		Replace ZZS_FORNEC with (cTmpZZS)->ZZS_FORNEC
		Replace ZZS_LOJANF with (cTmpZZS)->ZZS_LOJANF
		Replace ZZS_ITEMNF with (cTmpZZS)->ZZS_ITEMNF
		Replace ZZS_PRODUT with (cTmpZZS)->ZZS_PRODUT
		Replace ZZS_DESCPR with (cTmpZZS)->ZZS_DESCPR
		Replace ZZS_PEDIDO with (cTmpZZS)->ZZS_PEDIDO
		Replace ZZS_FORPED with (cTmpZZS)->ZZS_FORPED
		Replace ZZS_LOJAPC with (cTmpZZS)->ZZS_LOJAPC
		Replace ZZS_ITEPED with (cTmpZZS)->ZZS_ITEPED
		Replace ZZS_QATE   with (cTmpZZS)->ZZS_QATE
		ZZS->(MsUnlock())

		(cTmpZZS)->(DbSkip())
	EndDo

Return

//Consulta o saldo consumido nos pedidos X a quantidade da NF
Static Function fQtdAten()
	Local nRet := 0
	Local cQry := ""

	cQry := " SELECT SUM(ZZS_QATE) QTD FROM "+ RetSqlName("ZZS")
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += " AND ZZS_FILIAL = '"+ PB0->PB0_FILIAL +"' "
	cQry += " AND ZZS_DOC 	 = '"+ PB0->PB0_DOC +"' "
	cQry += " AND ZZS_SERIE  = '"+ PB0->PB0_SERIE +"' "
	cQry += " AND ZZS_FORNEC = '"+ PB0->PB0_FORNEC +"' "
	cQry += " AND ZZS_LOJANF = '"+ PB0->PB0_LOJA +"' "
	cQry += " AND ZZS_PRODUT = '"+ PB1->PB1_COD +"' "

	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QZZS")

	nRet := QZZS->QTD

	QZZS->(dbCloseArea())

Return nRet

//Andre Minelli 16/07/2021 - Faz a geracao da pre nota automaticamente para todos os documentos selecionados
User Function ANPRENOT()

Local oOk	    := LoadBitmap( GetResources(), "LBOK" )
Local oNo	    := LoadBitmap( GetResources(), "LBNO" )
Local lGrv    	:= .F.
Local aDados  	:= {}
Local aRet	  	:= {Space(6),Space(2),Space(6),Space(2),Space(9),Space(9),CTOD(""),CTOD(""),Space(6),Space(6),"CTE"}
Local aRecPB1 	:= {}
Local a140Desp  := {0,0,0,0,0,0,0,0,0}
Local cFilBkp   := ""
Local cUpd      := ""
Local nUpd      := 0

Private oDialog, oLbx, oChk
Private lTodos  := .F.
Private nTotal  := 0
Private oSay3
Private cSay3   := "Itens Selec.: "

If !ParamBox({	{1,"Fornecedor Inic",aRet[1],"@!","","SA2","",60,.F.},;
	 	        {1,"Loja Inic"      ,aRet[2],"@!","","","",40,.F.},;
				{1,"Fornecedor Fim"	,aRet[3],"@!","","SA2","",60,.T.},;
	 	        {1,"Loja Fim"       ,aRet[4],"@!","","","",40,.T.},;
    	        {1,"Num NF Inic"    ,aRet[5],"@!","","","",60,.F.},;
				{1,"Num NF Fim"     ,aRet[6],"@!","","","",60,.T.},;
                {1,"Dt Emissao Inic",aRet[7],"","","","",60,.F.},;
				{1,"Dt Emissao Fim" ,aRet[8],"","","","",60,.T.},;
				{1,"Filial Inic"	,aRet[9],"","","","",60,.F.},;
				{1,"Filial Fim"     ,aRet[10],"","","","",60,.T.},;
				{1,"Especie NF"     ,aRet[11],"","","42",".F.",40,.F.}},"Geracao Pre Nota", @aRet,,,,,,,,.T.,.T.)
	Return
End If

//Atualiza condicao para 01 para todos os CTEs
cUpd := "UPDATE " + RetSqlName("PB0") + " SET PB0_STATUS = '1', PB0_COND = '01' WHERE PB0_STATUS = ' ' AND PB0_COND = ' ' AND D_E_L_E_T_ = ' ' AND PB0_ESPECI = 'CTE' "
nRet := TcSqlExec(cUpd)

cQry := "SELECT * FROM " + RetSqlname("PB0") + " WHERE "
cQry += "PB0_FORNEC BETWEEN '" + aRet[1] + "' AND '" + aRet[3] + "' AND PB0_LOJA BETWEEN '" + aRet[2] + "' AND '" + aRet[4] + "' AND "
cQry += "PB0_DOC BETWEEN '" + aRet[5] + "' AND '" + aRet[6] + "' AND PB0_EMISSA BETWEEN '" + DTOS(aRet[7]) + "' AND '" + DTOS(aRet[8]) + "' AND "
cQry += "PB0_FILIAL BETWEEN '" + aRet[9] + "' AND '" + aRet[10] + "' AND PB0_STATUS = '1' AND D_E_L_E_T_ = '' "
If !Empty(aRet[11])
	cQry += " AND PB0_ESPECI = '" + aRet[11] + "' "
End If
cQry += "ORDER BY PB0_DOC "
cQry := ChangeQuery(cQry)
DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),"SQLPB0",.F.,.T.)

While SQLPB0->(!EOF())
	AADD(aDados,{.F.,SQLPB0->PB0_FILIAL,SQLPB0->PB0_DOC,SQLPB0->PB0_SERIE, SQLPB0->PB0_FORNECE,SQLPB0->PB0_LOJA,;
	STOD(SQLPB0->PB0_DTDIGI), SQLPB0->PB0_DESPES, SQLPB0->PB0_FRETE, SQLPB0->PB0_SEGURO, SQLPB0->R_E_C_N_O_, SQLPB0->PB0_ESPECI })

	SQLPB0->(DbSkip())
End

SQLPB0->(DbCloseArea())

If Len(aDados) == 0
	AADD(aDados,{.F.,"","","", "","",CTOD(""), 0, 0, 0, 0, "" })
End If

//Inicia tela de seleção
Define MsDialog oDialog Title "Selecao de Docs" Of oMainWnd Pixel From 0,0 To 330,650
@ 31,1 	ListBox oLbx Fields Header " ","FILIAL","DOC","SERIE", "FORNECEDOR","LOJA", "DIGITACAO", "ESPECIE" ;
		Size 325,120 Of oDialog Pixel On dBlClick ( aDados[oLbx:nAt,1]:=!aDados[oLbx:nAt,1], oLbx:Refresh() )
		
oLbx:SetArray(aDados)
oLbx:bLine := { || {If(aDados[oLbx:nAt,1],oOk,oNo), aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], aDados[oLbx:nAt,4], aDados[oLbx:nAt,5], aDados[oLbx:nAt,6], aDados[oLbx:nAt,7], aDados[oLbx:nAt,12] }}

@ 155,10 CheckBox oChk Var lTodos Prompt " Marca/Desmarca Todos" Of oDialog Pixel Size 140,12 Color CLR_RED On Click ( AEval(aDados , {|z| z[1] := lTodos }), AtuTot(aDados), oLbx:Refresh() )
@ 155,120 Say oSay3 Prompt cSay3 Of oDialog Pixel 
Activate MsDialog oDialog Center On Init EnchoiceBar(oDialog,{||lGrv:=.T.,oDialog:End()},{||oDialog:End()})

If lGrv

	For nX := 1 To Len(aDados)

		If aDados[nX][1] .And. !Empty(aDados[nX][2]) .And. !Empty(aDados[nX][3])

			aRecPB1 := {}

			cQry := "SELECT R_E_C_N_O_ PB1RECNO FROM " + RetSqlname("PB1") + " WHERE PB1_FILIAL = '" + aDados[nX][2] + "' AND PB1_DOC = '" + aDados[nX][3] + "' AND "
			cQry += "PB1_SERIE = '" + aDados[nX][4] + "' AND PB1_FORNEC = '" + aDados[nX][5] + "' AND PB1_LOJA = '" + aDados[nX][6] + "' AND D_E_L_E_T_ = '' "
			cQry := ChangeQuery(cQry)
			DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),"SQLPB1",.F.,.T.)

			While SQLPB1->(!EOF())
				aadd(aRecPB1,SQLPB1->PB1RECNO)
				SQLPB1->(DbSkip())
			End

			SQLPB1->(DbCloseArea())

			a140Desp[5]	:= aDados[nX][8]
			a140Desp[4] := aDados[nX][9]
			a140Desp[7] := aDados[nX][10]
			
			PB0->(DbGoTo(aDados[nX][11]))
			cFilBkp := cFilAnt
			cFilAnt := PB0->PB0_FILIAL
			If PB0->PB0_TIPO$"DB"
				SA1->(DbSetOrder(1),DbSeek(xfilial("SA1") + PB0->PB0_FORNEC + PB0->PB0_LOJA ))
			Else
				SA2->(DbSetOrder(1),DbSeek(xfilial("SA2") + PB0->PB0_FORNEC + PB0->PB0_LOJA ))
			End If
			If alltrim(aRet[11]) <> "CTE"
				MEnviaMail("005",{PB0->PB0_DOC,PB0->PB0_SERIE,PB0->PB0_FORNEC,PB0->PB0_LOJA,If(PB0->PB0_TIPO$"DB",SA1->A1_NOME,SA2->A2_NOME),{} })
			End If
			FWMsgRun(, {|oSay| _COM01PB0(.F.,.T.) }, "Pre Nota", "Gerando Dados...") //Geracao Execauto PRE NOTA
			cFilAnt := cFilBkp

		End If

	Next nX

	MsgInfo("Processo Concluído")

End If

Return

Static Function AtuTot(aDados)

nTotal := 0

For nX :=  1 To Len(aDados)
    If aDados[nX,1] 
        nTotal++
    End If
Next nX

cSay3 := alltrim("Itens Selec.: " + Transform(nTotal,"@E 999,999"))
oSay3:SetText(cSay3)

If nTotal == 0
	lTodos := .F.
Else
	lTodos := .T.
End If

oLbx:Refresh()

Return .T.
