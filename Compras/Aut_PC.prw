#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWBROWSE.CH"

#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOTVS.CH'

//#INCLUDE "COLOR.CH"
//#INCLUDE "COLORS.CH"

#define CLR_FUNDO		RGB(240,240,240)
#define CLR_FONTB		RGB(000,000,255)
#define CLR_FONTT		RGB(000,000,000)
#define CLR_FONTP		RGB(180,180,180)

#DEFINE SM0_FILIAL	02
#DEFINE SM0_CNPJ	18

/////////////////////////////////////////////////////
/// Ita - 15/04/2019
///       Faço tratamento de Cores na MarkBrowse
///       para evitar colunas de indicação de
///       flag.

#define CLR_PRDBLOK RGB(105, 105, 105)   //Cinza Escuro
#define CLR_PRDLIB  RGB(255, 255, 255)   //Branco
#define CLR_PRDJDI  RGB(255, 165, 0)     //Laranja
#define CLR_AZLPDR  RGB(176, 196, 222)   //Azul Padrão Protheus
#define CLR_VERPDR	RGB(255, 0, 0)       //Vermelho

/////////// Ita - 15/04/2019 /////////////////////////////////////

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE ENTER Chr(10)+Chr(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  Aut_PC     º Autor ³ Ricardo Rotta      º Data ³  31/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela de Pedido de compra para Revenda                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Aut_PC

Local oBrowse
Private aRotina := {}
PRIVATE cCadastro  := "Pedidos de Compra - Revenda"
Private _lFecha2   := .T.
Private _cArqISZ7  := ""//Ita - 01/03/2019
Private _Enter     := chr(13) + Chr(10) //Ita - 01/04/2019
Private _cArqFlag  := "" //Ita - 16/05/2019
Private cStartPath := GetSrvProfString("Startpath","") //Ita - 16/05/2019
Private _oValPC
Private _oItemSel
Private _cPrdPos   := SPACE(15) //Ita - 21/08/2019 - Preencher F9-Pesquisa do Produto com o último produto digitado, caso exista. Solicitação do Gustavo.
/*
Private oCheck  	:= LoadBitmap( GetResources(), "CHECKED" )   //Ita - 04/09/2019    // Legends : CHECKED  / LBOK  /LBTIK
Private oNoCheck	:= LoadBitmap( GetResources(), "UNCHECKED" ) //"         "         // Legends : UNCHECKED /LBNO  
Private oImgRet     := oNoCheck                                  //"         "
*/

////////////////////////////
/// Ita - 29/05/2019
///     - Criado variavel para armazenar o indice da
///     - tabela temporária
//MsgInfo("Ita - Versão Atu_PC: "+DTOC(Date())+" Execução as: "+Time())
Private _nOrdTrab := 2 //Ita 18/06/2019 - 2		// Alterado 20/06/19 Rotta
Private _xIncPC := CTOD("")//Ita - 18/06/2019	
Private aMsProc := {} //Ita - 19/06/2019 - Meses de Processamento
Private _cUserLog := RetCodUsr()
private _cNomUser := UsrRetName(_cUserLog)
//////////////////////////////////////////
/// Ita - 13/08/2019
///     - Compatibilizar para CodeAnalysis
///       Função para Abertura de Tabelas Metadados(Dicionários SXs)
///       dbSelectArea("SX3")
///       dbSetOrder(2)
///       ABERTURA DO DICIONÁRIO SX3
///       Substituído por:
///       OpenSXs(NIL, NIL, NIL, NIL, SM0->M0_CODIGO, "TDIC", "SX3", NIL, .F.) 
OpenSXs(NIL, NIL, NIL, NIL, SM0->M0_CODIGO, "TDIC", "SX3", NIL, .F.)
lOpen := Select("TDIC") > 0
If lOpen
   DbSelectArea("TDIC")
   TDIC->( DbSetOrder(2) )// //ORDENA POR CAMPOS
Else
   Alert("Não foi possível abrir o dicionário de dados - SX3")
   Return
EndIf

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'SZ7' )
oBrowse:SetDescription( "Pedidos de Revenda" )
oBrowse:AddLegend( "Z7_STATUS=='1'", "GREEN", "Em Aberto" )
oBrowse:AddLegend( "Z7_STATUS=='2'", "YELLOW", "Atendido Parcialmente" )
oBrowse:AddLegend( "Z7_STATUS=='3'", "RED", "Encerrado" )
//oBrowse:SetIniWindow({||fOrdSZ7()})//Ita - 01/03/2019
oBrowse:Activate()
FErase(_cArqISZ7+OrdBagExt())
Return NIL

Static Function MenuDef()

aRotina := {}
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "PesqBrw" 						OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar' ACTION "u_ANMATA120(2)" 				OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION "StaticCall(Aut_PC,Aut_PCV)" 	OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION "u_ANMATA120(4)" 				OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION "u_ANMATA120(5)" 				OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Exportar'   ACTION "u_ExpPedCom()" 				OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Exp. EDI'   ACTION "u_ExpRND()" 					OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'   ACTION "u_fcallimp(SZ7->Z7_NUM)" 	    OPERATION 7 ACCESS 0

Return aRotina

//-----------------------------------------------------------------------------------------------------------------------
//
User Function ANMATA120(_nParam)

Local _aArea	:= GetArea()
Local _cNumPC 	:= SZ7->Z7_NUM
PRIVATE aRatCTBPC  := {}
PRIVATE aAdtPC     := {}
PRIVATE aRatProj   := {}
PRIVATE nAutoAdt   := 0
PRIVATE nTipoPed   := 1
PRIVATE l120Auto   := .F.
PRIVATE lPedido    := .T.
PRIVATE lGatilha   := .T.                          // Para preencher aCols em funcoes chamadas da validacao (X3_VALID)
PRIVATE lVldHead   := GetNewPar( "MV_VLDHEAD",.T. )// O parametro MV_VLDHEAD e' usado para validar ou nao o aCols (uma linha ou todo), a partir das validacoes do aHeader -> VldHead()

Private aImpIB2	   := {}
Private aImpCCO	   := {}
Private aImpSFC	   := {}
Private aImpSFF	   := {}
Private aImpSFH	   := {}
Private aImpLivr   := {}
Private aTesMXF	   := {}
Private lPerg	   := .T.

dbSelectArea("SC7")
dbSetOrder(1)
//Ita - 30/05/2019 - If dbSeek(xFilial()+_cNumPC)
If dbSeek(cFilAnt+_cNumPC)
	A120Pedido("SC7",SC7->(recno()),_nParam)
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Aut_PCV

Local _aRotAnt	:= aRotina
Local aSize := MsAdvSize()
Local aObjects := {{100,100,.t.,.t.}}
Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj  := MsObjSize(aInfo,aObjects)
Local cAliasSZ1 := "QRYSZ1"
Local aStruct 	:= {}
Local cIndTmp
Local cChave	:= ''
Local _oFINC0245
Local aColumns		:= {}
Local bOk			:= {||}
Local bPergunte		:= {||}
//Ita - 16/05/2019 - Local cPerg		:= "PCREVENDA"
Local oFnt2S  		:= TFont():New("Arial",6 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
Private cAliasTMP   := GetNextAlias()		
Private _cRotina	:= "4"
Private _nOpcCont := 2 //Ita - 30/05/2019
Private cPerg		:= "PCREVENDA" //Ita - 16/05/2019
Private oBrowse  //Ita - 05/09/2019 - atualizar browse após destravar registro do pedido de revenda
aRotina := {}

aRotina	:= {	{"Continuar"	,"u_fContPC"	, 0, 2,0, nil},; //Ita - 01/04/2019 - Mudar nome da Função para evitar erro na call - {"Continuar"	,"u_Cont_PC_A"	, 0, 2,0, nil},;
				{"Novo Pedido"	,"u_fNovoPC"	, 0, 2,17,nil},; //                 - Mudar nome da Função para evitar erro na call - {"Novo Pedido"	,"u_Cont_PC_B"	, 0, 2,17,nil},;
				{"Destravar"    ,"u_fMonitPR((cAliasTMP)->TMP_FORNEC,(cAliasTMP)->TMP_DTINCL)", 0, 5,17,nil},; //Ita - 05/09/2019 -Destravar pedido que sofreu com queda do sistema e ficou com status de usado.
				{"Excluir"		,"u_Exc_SZ1"	, 0, 5,17,nil} }

//--- Cria alias temporario baseado na FIV

Aadd(aStruct, {"TMP_OK","C",1,0})
Aadd(aStruct, {"TMP_STATUS","C",1,0})
aAdd(aStruct, {"TMP_FORNEC"	,"C"	,TamSx3("ZZN_COD")[1]		,0, "Fornecedor"	, 100, " " })
aAdd(aStruct, {"TMP_DESC"	,"C"	,TamSx3("ZZN_DESCRI")[1]	,0, "Nome"			, 150, " " })
aAdd(aStruct, {"TMP_DTINCL"	,"D"	,TamSx3("C7_EMISSAO")[1]	,0, "Dt. Inclusão"	, 080,  " " })
aAdd(aStruct, {"TMP_COMPRA" ,"C"	,15							,0, "Comprador"		, 130, " " })
aAdd(aStruct, {"TMP_OBS"	,"C"	,30							,0, "Situação"		, 200, " " })
//-----------------------------------------

If(_oFINC0245 <> NIL)
	_oFINC0245:Delete()
	_oFINC0245 := NIL
EndIf

_oFINC0245 := FwTemporaryTable():New(cAliasTmp)
_oFINC0245:SetFields(aStruct)
//Ita - 27/05/2019 - Troca o índice por data de inclusão - _oFINC0245:AddIndex("1",{"TMP_FORNEC"})
//Ita - 03/06/2019 - _oFINC0245:AddIndex("1",{"TMP_DTINCL"})
_oFINC0245:Create()

dbSelectArea("SZ1")

//Ita - 03/06/2019 - Retirado distinct do comprador para evitar duplicidde _cQuery := "SELECT DISTINCT Z1_CODFORN, Z1_COMPRAD, Z1_DTINCL, Z1_STATUS " + _Enter
_cQuery := "SELECT DISTINCT Z1_CODFORN, Z1_DTINCL, Z1_STATUS " + _Enter
_cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
//Ita - 30/05/2019 - _cQuery += " WHERE Z1_FILIAL = '" + xFilial("SZ1") + "'" + _Enter
_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
_cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
_cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
//Ita - 21/08/2019 - _cQuery += "   AND Z1_QUANT > 0 " + _Enter //Ita - 05/06/2019
_cQuery += "   AND Z1_QUANT >= 0 " + _Enter //Ita - 21/08/2019 - Considerar registros com data zerada.
//Ita - 27/05/2019 - Troca o índice por data de inclusão - _cQuery += " ORDER BY Z1_CODFORN" + _Enter
_cQuery += " ORDER BY Z1_DTINCL DESC" + _Enter   //Ita - 03/06/2019 - Acrescentado cláusula DESC para ordenar por data de forma descrescente.
MemoWrite("C:\TEMP\Aut_PC_cAliasSZ1.SQL",_cQuery) //Ita - 02/04/2019
MemoWrite("\Data\Aut_PC_cAliasSZ1.SQL",_cQuery) //Ita - 02/04/2019
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ1,.T.,.T.)
TCSetField(cAliasSZ1,"Z1_DTINCL","D",08,00)
dbSelectArea(cAliasSZ1)
While !Eof()
	RecLock(cAliasTMP,.T.)
	(cAliasTMP)->TMP_FORNEC := (cAliasSZ1)->Z1_CODFORN
	//Ita - 30/05/2019 - (cAliasTMP)->TMP_DESC   := Posicione("ZZN",1,xFilial("ZZN")+(cAliasSZ1)->Z1_CODFORN, "ZZN_DESCRI")
	_cComprador := Posicione("SZ1",3,cFilAnt+PadR((cAliasSZ1)->Z1_CODFORN,6)+DTOS((cAliasSZ1)->Z1_DTINCL),"Z1_COMPRAD")//Ita - 03/06/2019 - Z1_FILIAL+Z1_CODFORN+Z1_DTINCL+Z1_PRODUTO
	(cAliasTMP)->TMP_DESC   := Posicione("ZZN",1,cFilAnt+(cAliasSZ1)->Z1_CODFORN, "ZZN_DESCRI")
	(cAliasTMP)->TMP_DTINCL := If(Empty((cAliasSZ1)->Z1_DTINCL),dDataBase,(cAliasSZ1)->Z1_DTINCL)
	(cAliasTMP)->TMP_COMPRA := _cComprador //(cAliasSZ1)->Z1_COMPRAD //Ita - 27/05/2019 - Evitar comparação errada entre RetCodUsr() e UsrRetName((cAliasSZ1)->Z1_COMPRAD)
	(cAliasTMP)->TMP_OBS    := IIF((cAliasSZ1)->Z1_STATUS == "1", "Arquivo em Uso", "Em Andamento")
	(cAliasTMP)->TMP_STATUS := (cAliasSZ1)->Z1_STATUS
	MsUnlock()
	_xIncPC  := (cAliasTMP)->TMP_DTINCL //Ita - 18/06/2019
	
	dbSelectArea(cAliasSZ1)
	(cAliasSZ1)->(dbSkip())
End
dbSelectArea(cAliasSZ1)
dbCloseArea()
dbSelectArea(cAliasTMP)
dbGotop()
If !Eof() .and. !Bof()
	//----------------MarkBrowse----------------------------------------------------
	For nX := 1 To Len(aStruct)
		If	!aStruct[nX][1] $ "TMP_OK/TMP_STATUS"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:lAutosize:=.f.
			aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
			aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][6])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetPicture(aStruct[nX][7])
			If aStruct[nX][2] $ "N/D"
				aColumns[Len(aColumns)]:nAlign := 3
			Endif
		EndIf 	
	Next nX 
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlgAB TITLE "Pedidos em Andamento/teste" From 300,0 to 800,1000 OF oMainWnd PIXEL

//	oDlgAB:lEscClose := .F.		// Desabilita a tecla ESC
//	oDlgAB:SetEscClose(.T.)		//permite fechar a tela com o ESC
	// Instanciamento da Classe de FWBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetOwner(oDlgAB)
	// Titulo da Browse
	oBrowse:SetDescription("Pedidos em Andamento")
	oBrowse:SetTemporary(.T.)
	oBrowse:SetAlias(cAliasTmp)
	oBrowse:SetColumns(aColumns)
	oBrowse:SetMenuDef(' ')
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetProfileID('SZ1')
	oBrowse:SetFontBrowse(oFnt2S)
	// Opcionalmente pode ser desligado a exibição dos detalhes
	oBrowse:DisableDetails()	
	// Ativação da Classe
	oBrowse:Activate()

	ACTIVATE MSDIALOg oDlgAB CENTERED
Endif

////////////////////////////////
///Ita - 21/05/2019 - Aut_PC_T()
///    - Passar código do fornecedor selecionado na opção continuar, se for o caso,
//       para tela de parâmetros.
If _nOpcCont == 2 
   _cVazCod := CriaVar("ZZN_COD",.F.)
   Aut_PC_T(_cVazCod)
Else
   Aut_PC_T((cAliasTMP)->TMP_FORNEC)
EndIf


(cAliasTMP)->(DbCloseArea())
MSErase(cAliasTMP+GetDbExtension())
MSErase(cAliasTMP+OrdBagExt())
dbSelectArea("SC7")
aRotina := _aRotAnt

Return
//------------------------------------------------------------------------------------------------------
//
User Function fContPC() //Cont_PC_A()

_nOpcCont := 1
oDlgAB:End()
Return

//------------------------------------------------------------------------------------------------------
//
User Function fNovoPC() //Ita - 01/04/2019 - Cont_PC_B()

_nOpcCont := 2
oDlgAB:End()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Exc_SZ1()

Local _aArea := GetArea()
Local _cForn := (cAliasTMP)->TMP_FORNECE
Local _cCompr := (cAliasTMP)->TMP_COMPRA
Local _dDtIncl := (cAliasTMP)->TMP_DTINCL
Local _cStatus := (cAliasTMP)->TMP_STATUS
Local lRet	:= .T.
Local cUser  := RetCodUsr()
Local _lContinua := .T.
If _cStatus == "1"
	//Ita - 27/03/2019 - If !(SZ1->Z1_COMPRAD == cUser)
		Help(" ",1,"PEDEXEC",,"O Pedido está sendo digitado nesse momento, portanto não poderá ser Excluido, apenas o comprador que está digitando é quem poderá excluir",4,,,,,,.F.)
		_lContinua := .F.
	//Endif
Endif
If _lContinua
	//Ita - 30/05/2019 - lRet := MsgYesNo("Confirma a Exclusão do Pedido de Compra","Atenção")
	//Ita - 30/05/2019 - If lRet
	If MsgYesNo("Confirma a Exclusão do Pedido de Compra") //Ita - 30/05/2019 - MsgYesNo("Confirma a Exclusão do Pedido de Compra","Atenção")
		dbSelectArea("SZ1")
		dbSetOrder(2)//Z1_FILIAL+Z1_STATUS+Z1_CODFORN+Z1_PRODUTO
		//Ita - 30/05/2019 - dbSeek(xFilial()+_cStatus+_cForn)
		//Ita - 30/05/2019 - While !Eof() .and. xFilial("SZ1")+_cStatus+_cForn == SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)
		If dbSeek(cFilAnt+_cStatus+PadR(_cForn,6))
			While !Eof() .and. cFilAnt+_cStatus+PadR(_cForn,6) == SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)
				//Ita - 27/05/2019 - Retirar validação de só poder excluir se for o mesmo comprador - If Alltrim(UsrRetName(SZ1->Z1_COMPRAD)) == Alltrim(_cCompr) .and. Dtos(SZ1->Z1_DTINCL) == Dtos(_dDtIncl)
				If Dtos(SZ1->Z1_DTINCL) == Dtos(_dDtIncl)
					RecLock("SZ1",.F.)
					dbDelete()
					MsUnLock()
				Endif
				dbSelectArea("SZ1")
				dbSkip()
			End
			dbSelectArea(cAliasTMP)
			RecLock(cAliasTMP,.F.)
			dbDelete()
			MsUnLock()
		EndIf
		dbSelectArea(cAliasTMP)
		dbGotop()
		/*Ita - 30/05/2019
		If Reccount() == 1
			oDlgAB:End()
		Endif
		*/
	Endif
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  05/31/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Aut_PC_T(_xFornece)

Local aSize := MsAdvSize()
Local aObjects := {{100,100,.t.,.t.}}
Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj  := MsObjSize(aInfo,aObjects)
Local _nLinha  := -35
Local _cSaida	:= "V"
Local _aSaida	:= {}
Local aButtons	:= {}
Local lRetorno	:= .F.
Local bOk    :={|| TclCtrA(_cRotina, cPerg)}
Local bCancel:={|| lRetorno:=.F.,oDlg:End()}
Local cPerg		:= "PCREVENDA"
Local _lRetorno := .t.
//Ita - 11/04/2019 Private _cEmpr01 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr01 := fGetFil(cFilAnt,1) //Ita - 11/04/2019
Private _cEmpr02 := If(_cEmpr01=="001","004",CriaVar("C7_FILIAL",.F.)) //Ita - 30/05/2019 - CriaVar("C7_FILIAL",.F.)
Private _cEmpr03 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr04 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr05 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr06 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr07 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr08 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr09 := CriaVar("C7_FILIAL",.F.)
Private _cEmpr10 := CriaVar("C7_FILIAL",.F.)
Private _cOrigTrf:= CriaVar("C7_FILIAL",.F.)
Private _cLinha1 := Space(06)
Private _cLinha2 := Space(06)
Private _cLinha3 := Space(06)
Private _cLinha4 := Space(06)
Private _cLinha5 := Space(06)
Private _cTped	:= Space(01)
Private _cCodMarc := CriaVar("ZZN_COD",.F.)
Private _cCodProd := CriaVar("B1_COD",.F.)
Private _cTpPrc	:= Space(01)
Private _cCurva1	:= Space(01)
Private _cCurva2	:= Space(01)
Private _cCurva3	:= Space(01)
Private _cCurva4	:= Space(01)
Private _aTped	:= {}
Private _cTped	:= "C - Compras"
Private _cEstZero	:= "A"
Private _aEstZero	:= {}
Private _cTabForn := Space(03)
Private _cPrecoF	:= "1"
Private _aPrecoF	:= {}
Private _nDiasEmp := 0
Private _cMesIni  := Space(04)
Private _cMesFim  := Space(04)
Private _cQtdVr	:= "V"
Private _aQtdVr	:= {}
Private _nCobDe	:= 0
Private _nCobAte	:= 0
Private _nSugest	:= 0
Private _cSitPro	:= "3"
Private _aSitPro	:= {}
Private _cGeraAut	:= "N"
Private _aGeraAut	:= {}
Private _cCobMed	:= "T"
Private _aCobMed	:= {}
Private _cMesCor	:= "N"
Private _aMesCor	:= {}
Private _cRotina	:= "1"
Private oCodProd //Ita - 01/03/2019
Private oDlgPar     
Private _lEdtPA     := If(Substr(_cTped,1,1)=="T",.F.,.T.) //Ita - 10/07/2019 - Edita campo para Gerar Pedido Automático
aadd(_aTped, "C - Compras")
aadd(_aTped, "T - Transferencia")
aadd(_aEstZero, "A - Ambos")
aadd(_aEstZero, "S - Sim")
aadd(_aEstZero, "N - Não")
aadd(_aPrecoF, "1 - Última Compra")
aadd(_aPrecoF, "2 - Tabela Fornecedor")
aadd(_aQtdVr, "V - Valor")
aadd(_aQtdVr, "Q - Quantidade")
aadd(_aSitPro, "1 - Ja Comprado")
aadd(_aSitPro, "2 - Não Comprado")
aadd(_aSitPro, "3 - Ambos")
aadd(_aGeraAut, "N - Não") //Ita - 19/06/2019 - voltou a ordem de incremento do _aGeraAut
aadd(_aGeraAut, "S - Sim")
aadd(_aCobMed, "T - Trimestral")
aadd(_aCobMed, "S - Semestral")
aadd(_aMesCor, "S - Sim")
aadd(_aMesCor, "N - Não")
aadd(_aSaida, "V - Video")
aadd(_aSaida, "I - Impressora")
aadd(_aSaida, "A - Arquivo")

//SetKey(K_CTRL_O, { || Aut_PCOK(oDlg) } )
SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019

AjustaSx1(cPerg)
Pergunte(cPerg,.F.)

_cEmpr01 := fGetFil(cFilAnt,1) //Ita - 30/05/2019 - mv_par01
_cEmpr02 := If(_cEmpr01=="001","004",CriaVar("C7_FILIAL",.F.)) //Ita - 30/05/2019 - mv_par02
_cEmpr03 := mv_par03
_cEmpr04 := mv_par04
_cEmpr05 := mv_par05
_cEmpr06 := mv_par06
_cEmpr07 := mv_par07
_cEmpr08 := mv_par08
_cEmpr09 := mv_par09
_cEmpr10 := mv_par10
_cOrigTrf:= SPACE(1) //Ita - 04/07/2019 - mv_par36 //Ita - 23/04/2019
_cTped	:= IIF(Empty(mv_par11) .or. mv_par11 == "C","C - Compras", "T - Transferencia")
_nDiasEmp := mv_par12
//Ita - 21/05/2019 - _cCodMarc := mv_par13
_cCodMarc := If((_nOpcCont == 2),mv_par13,_xFornece)
_cLinha1  := mv_par14
_cLinha2  := mv_par15
_cLinha3  := mv_par16
_cLinha4  := mv_par17
_cLinha5  := mv_par18
_cCodProd := mv_par19
If Empty(mv_par20) .or. mv_par20 == "A"
	_cEstZero := "A - Ambos"
ElseIf mv_par20 == "S"
	_cEstZero := "S - Sim"
Else
	_cEstZero := "N - Não"
Endif
If Empty(mv_par21) .or. mv_par21 == "1"
	_cPrecoF := "1 - Última Compra"
Else
	_cPrecoF := "2 - Tabela Fornecedor"
Endif
_cTabForn := mv_par22
_cCurva1  := mv_par23
_cCurva2  := mv_par24
_cCurva3  := mv_par25
_cCurva4  := mv_par26
_cMesIni  := mv_par27
_cMesFim  := mv_par28
If Empty(mv_par29) .or. mv_par29 == "V"
	_cQtdVr := "V - Valor"
Else
	_cQtdVr := "Q - Quantidade"
Endif
_nCobDe   := mv_par30
_nCobAte  := mv_par31
_nSugest  := mv_par32
If Empty(mv_par33) .or. mv_par33 == "3"
	_cSitPro := "3 - Ambos"
ElseIf mv_par33 == "1"
	_cSitPro := "1 - Ja Comprado"
Else
	_cSitPro := "2 - Não Comprado"
Endif
/* Ita - 10/07/2019
If Empty(mv_par34) .or. mv_par34 == "N"
	_cGeraAut := "N - Não"
Else
	_cGeraAut := "S - Sim"
Endif
*/
_cGeraAut := "N - Não" //Ita - 10/07/2019

If Empty(mv_par35) .or. mv_par35 == "T"
	_cCobMed := "T - Trimestral"
Else
	_cCobMed := "S - Semestral"
Endif

If Day(dDataBase) < 20
	_cMesCor := "N - Não"
Else
	_cMesCor := "S - Sim"
Endif

	oSize := FwDefSize():New(.T.)
	
	oSize:lLateral := .F.
	oSize:lProp	:= .T. // Proporcional

	oSize:AddObject( "GETDADOS" ,  100, 95, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "RODAPE"   ,  100, 05, .T., .T. ) // Totalmente dimensionavel

	oSize:lProp 	:= .T. // Proporcional
	oSize:aMargins 	:= { 0, 0, 0, 0 } // Espaco ao lado dos objetos 0, entre eles 3
	oSize:Process() 	   // Dispara os calculos
	
	_nLinha  := oSize:GetDimension("CABECALHO","LININI")
	_nColuna := oSize:GetDimension("CABECALHO","COLINI")

DEFINE FONT oFont NAME "MS Sans Serif" SIZE 10, 8 BOLD

DEFINE MSDIALOG oDlgPar TITLE ":::... Controle de Estoque ...:::" From oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME
//aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel

@ _nLinha,C(010) SAY "Empresas para Consumo" PIXEL OF oDlgPar FONT oFont
_nLinha+=10
@  _nLinha,C(010) GET oEmpr01 VAR _cEmpr01 Valid u_B_FilANL(_cEmpr01) OF oDlgPar PIXEL 
@  _nLinha,C(040) GET oEmpr02 VAR _cEmpr02 Valid u_B_FilANL(_cEmpr02)  When !Empty(_cEmpr01) OF oDlgPar PIXEL
@  _nLinha,C(070) GET oEmpr03 VAR _cEmpr03 Valid u_B_FilANL(_cEmpr03)  When !Empty(_cEmpr02) OF oDlgPar PIXEL
@  _nLinha,C(100) GET oEmpr04 VAR _cEmpr04 Valid u_B_FilANL(_cEmpr04)  When !Empty(_cEmpr03) OF oDlgPar PIXEL
@  _nLinha,C(130) GET oEmpr05 VAR _cEmpr05 Valid u_B_FilANL(_cEmpr05)  When !Empty(_cEmpr04) OF oDlgPar PIXEL
@  _nLinha,C(160) GET oEmpr06 VAR _cEmpr06 Valid u_B_FilANL(_cEmpr06)  When !Empty(_cEmpr05) OF oDlgPar PIXEL
@  _nLinha,C(190) GET oEmpr07 VAR _cEmpr07 Valid u_B_FilANL(_cEmpr07)  When !Empty(_cEmpr06) OF oDlgPar PIXEL
@  _nLinha,C(220) GET oEmpr08 VAR _cEmpr08 Valid u_B_FilANL(_cEmpr08)  When !Empty(_cEmpr07) OF oDlgPar PIXEL
@  _nLinha,C(250) GET oEmpr09 VAR _cEmpr09 Valid u_B_FilANL(_cEmpr09)  When !Empty(_cEmpr08) OF oDlgPar PIXEL
@  _nLinha,C(280) GET oEmpr10 VAR _cEmpr10 Valid u_B_FilANL(_cEmpr010) When !Empty(_cEmpr09) OF oDlgPar PIXEL
oEmpr01:cF3 := "99"
oEmpr02:cF3 := "99"
oEmpr03:cF3 := "99"
oEmpr04:cF3 := "99"
oEmpr05:cF3 := "99"
oEmpr06:cF3 := "99"
oEmpr07:cF3 := "99"
oEmpr08:cF3 := "99"
oEmpr09:cF3 := "99"
oEmpr10:cF3 := "99"
_nLinha+=25
@  _nLinha,C(010) SAY "Tipo Pedido" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(050) COMBOBOX oTped VAR _cTped ITEMS _aTped VALID(fVldTP(_cTped)) SIZE 60,15 OF oDlgPar PIXEL
If Substr(_cTped,1,1) == "C"
	oTped:nAT := 1
Else
	oTped:nAT := 2
Endif
@  _nLinha,C(100) SAY "C = Compras   T = Transferencia" PIXEL OF oDlgPar

/* Ita - 11/04/2019 - Comentado para realocar espaço do processo de transferência entre filiais.
@  _nLinha,C(170) SAY "(Preservar da empresa origem: Cobertura de" PIXEL OF oDlgPar FONT oFont
@  _nLinha,C(295) GET _oDiasEmp VAR _nDiasEmp Picture "@E 999" When Substr(_cTped,1,1) == "T" OF oDlgPar PIXEL
*/
@  _nLinha,C(170) SAY "Origem" PIXEL OF oDlgPar FONT oFont
@  _nLinha,C(195) GET oOrigTrf VAR _cOrigTrf Valid u_B_FilANL(_cOrigTrf) .And. fChkTrf() Picture "@E 999" When Substr(_cTped,1,1) == "T" OF oDlgPar PIXEL
oOrigTrf:cF3 := "99"

@  _nLinha,C(230) SAY "(Preservar da empresa origem: Cobertura de" PIXEL OF oDlgPar FONT oFont
@  _nLinha,C(360) GET _oDiasEmp VAR _nDiasEmp Picture "@E 999" When Substr(_cTped,1,1) == "T" OF oDlgPar PIXEL

_nLinha+=25
@  _nLinha,C(010) SAY "Fornecedor" PIXEL OF oDlgPar FONT oFont                                                                  //Ita - 30/05/2019 - Acrescentado when para evitar continuar e colocar outro fornecedor/marca
@  _nLinha-2,C(050) MSGET oCodMarc VAR _cCodMarc Picture "@!" Valid(IIF(!Empty(_cCodMarc),ExistCpo("ZZ7",_cCodMarc), fVldFor())) When(_nOpcCont == 2) OF oDlgPar PIXEL
oCodMarc:cF3 := "ZZ7"
@  _nLinha,C(115) SAY "Linha" PIXEL OF oDlgPar FONT oFont
//// Ita - 30/05/2019
//@  _nLinha-2,C(135) GET oLinha1 VAR _cLinha1 /*Valid(IIF(!Empty(_cLinha1),ExistCpo("ZZN2",_cLinha1), .T.))*/ OF oDlgPar PIXEL
//@  _nLinha-2,C(165) GET oLinha2 VAR _cLinha2 /*Valid(IIF(!Empty(_cLinha2),ExistCpo("ZZN2",_cLinha2), .T.))*/ When !Empty(_cLinha1) OF oDlgPar PIXEL
//@  _nLinha-2,C(195) GET oLinha3 VAR _cLinha3 /*Valid(IIF(!Empty(_cLinha3),ExistCpo("ZZN2",_cLinha3), .T.))*/ When !Empty(_cLinha2) OF oDlgPar PIXEL
//@  _nLinha-2,C(225) GET oLinha4 VAR _cLinha4 /*Valid(IIF(!Empty(_cLinha4),ExistCpo("ZZN2",_cLinha4), .T.))*/ When !Empty(_cLinha3) OF oDlgPar PIXEL
//@  _nLinha-2,C(255) GET oLinha5 VAR _cLinha5 /*Valid(IIF(!Empty(_cLinha5),ExistCpo("ZZN2",_cLinha5), .T.))*/ When !Empty(_cLinha4) OF oDlgPar PIXEL
@  _nLinha-2,C(135) GET oLinha1 VAR _cLinha1 Valid(fVlsZZN(_cLinha1)) OF oDlgPar PIXEL                       //Ita - 30/05/2019
@  _nLinha-2,C(165) GET oLinha2 VAR _cLinha2 Valid(fVlsZZN(_cLinha2)) When !Empty(_cLinha1) OF oDlgPar PIXEL //Ita - 30/05/2019 
@  _nLinha-2,C(195) GET oLinha3 VAR _cLinha3 Valid(fVlsZZN(_cLinha3)) When !Empty(_cLinha2) OF oDlgPar PIXEL //Ita - 30/05/2019 
@  _nLinha-2,C(225) GET oLinha4 VAR _cLinha4 Valid(fVlsZZN(_cLinha4)) When !Empty(_cLinha3) OF oDlgPar PIXEL //Ita - 30/05/2019 
@  _nLinha-2,C(255) GET oLinha5 VAR _cLinha5 Valid(fVlsZZN(_cLinha5)) When !Empty(_cLinha4) OF oDlgPar PIXEL //Ita - 30/05/2019 
oLinha1:cF3 := "ZZN2"
oLinha2:cF3 := "ZZN2"
oLinha3:cF3 := "ZZN2"
oLinha4:cF3 := "ZZN2"
oLinha5:cF3 := "ZZN2"
_nLinha+=25
@  _nLinha,C(010) SAY "Produto" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(040) GET oCodProd VAR _cCodProd VALID fVldPrd(_cCodProd) OF oDlgPar PIXEL
oCodProd:cF3 := "SB1MA"
@  _nLinha,C(120) SAY "Produtos com estoque zero" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(200) COMBOBOX oEstZero VAR _cEstZero ITEMS _aEstZero SIZE 60,15 OF oDlgPar PIXEL
If Empty(mv_par20) .or. mv_par20 == "A"
	oEstZero:nAT := 1
ElseIf mv_par20 == "S"
	oEstZero:nAT := 2
Else
	oEstZero:nAT := 3
Endif
_nLinha+=25
@  _nLinha,C(010) SAY "Preço do Fornecedor" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(075) COMBOBOX oPrecoF VAR _cPrecoF ITEMS _aPrecoF SIZE 75,15 OF oDlgPar PIXEL
If Empty(mv_par21) .or. mv_par21 == "1"
	oPrecoF:nAT := 1
Else
	oPrecoF:nAT := 2
Endif
@  _nLinha,C(140) SAY "(1 = Última Compra   2 = Tabela Fornecedor)" PIXEL OF oDlgPar
@  _nLinha-2,C(230) GET oTabForn VAR _cTabForn When (Substr(_cPrecoF,1,1) == "2") OF oDlgPar PIXEL
_nLinha+=25
@  _nLinha,C(010) SAY "Produtos da Curva" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(070) GET oCurva1 VAR _cCurva1 Picture "@!" Valid(fVldCrv(_cCurva1)) OF oDlgPar PIXEL
/* Ita - 15/05/2019 - Retirado validação de preenchimento dos parâmetros de curva - Solicitação Décio.
@  _nLinha-2,C(085) GET oCurva2 VAR _cCurva2 Picture "@!" Valid(IIF(!Empty(_cCurva2), _cCurva2 $ "A/B/C/D",.T.)) When !Empty(_cCurva1) OF oDlgPar PIXEL
@  _nLinha-2,C(100) GET oCurva3 VAR _cCurva3 Picture "@!" Valid(IIF(!Empty(_cCurva3), _cCurva3 $ "A/B/C/D",.T.)) When !Empty(_cCurva2) OF oDlgPar PIXEL
@  _nLinha-2,C(115) GET oCurva4 VAR _cCurva4 Picture "@!" Valid(IIF(!Empty(_cCurva4), _cCurva4 $ "A/B/C/D",.T.)) When !Empty(_cCurva3) OF oDlgPar PIXEL
*/
@  _nLinha-2,C(085) GET oCurva2 VAR _cCurva2 Picture "@!" Valid(fVldCrv(_cCurva2)) OF oDlgPar PIXEL
@  _nLinha-2,C(100) GET oCurva3 VAR _cCurva3 Picture "@!" Valid(fVldCrv(_cCurva3)) OF oDlgPar PIXEL
@  _nLinha-2,C(115) GET oCurva4 VAR _cCurva4 Picture "@!" Valid(fVldCrv(_cCurva4)) OF oDlgPar PIXEL

@  _nLinha,C(138) SAY "Meses para calculo" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(200) GET oMesIni VAR _cMesIni Picture "@R 99/99" VALID fVlMesAno(_cMesIni,1,_cMesFim) OF oDlgPar PIXEL
@  _nLinha,C(228) SAY "a" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(240) GET oMesFim VAR _cMesFim  Picture "@R 99/99" VALID fVlMesAno(_cMesIni,2,_cMesFim) OF oDlgPar PIXEL
@  _nLinha,C(270) SAY "Valor / Qtde" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(310) COMBOBOX oQtdVr VAR _cQtdVr ITEMS _aQtdVr SIZE 60,15 OF oDlgPar PIXEL
_nLinha+=25
@  _nLinha,C(010) SAY "Cobertura" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(040) GET oCobDe VAR _nCobDe Picture "@E 999" OF oDlgPar PIXEL
@  _nLinha,C(065) SAY "a" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(080) GET oCobAte VAR _nCobAte Picture "@E 999" OF oDlgPar PIXEL
@  _nLinha,C(100) SAY "dias" PIXEL OF oDlgPar FONT oFont
_nLinha+=25
@  _nLinha,C(010) SAY "Calcular Sugestão para" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(080) GET oSugest VAR _nSugest Picture "@E 999" OF oDlgPar PIXEL
@  _nLinha,C(100) SAY "dias" PIXEL OF oDlgPar FONT oFont
_nLinha+=25
@  _nLinha,C(010) SAY "Situação Produtos" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(070) COMBOBOX oSitPro VAR _cSitPro ITEMS _aSitPro SIZE 75,15 OF oDlgPar PIXEL
If Empty(mv_par33) .or. mv_par33 == "3"
	oSitPro:nAT := 3
ElseIf mv_par33 == "1"
	oSitPro:nAT := 1
Else
	oSitPro:nAT := 2
Endif
_aGeraAut := aSort(_aGeraAut,,, { | x,y | x > y }) //Ordenar array para sempre vim N=Não como primeira opção de Gera Pedido Automatico

@  _nLinha,C(138) SAY "Gera Pedido Automatico" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(210) COMBOBOX oGeraAut VAR _cGeraAut ITEMS _aGeraAut SIZE 50,15 OF oDlgPar PIXEL WHEN _lEdtPA .And. fContPA() 
/* Ita - 19/06/2019
If Empty(mv_par34) .or. mv_par34 == "N"
	oGeraAut:nAT := 1
Else
	oGeraAut:nAT := 2
Endif
*/
If Substr(_cGeraAut,1,1) == "S"   //Ita - 19/06/2019
	oGeraAut:nAT := 1
Else
	oGeraAut:nAT := 2
Endif
_nLinha+=25
@  _nLinha,C(010) SAY "Usar na cobertura média" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(090) COMBOBOX oCobMed VAR _cCobMed ITEMS _aCobMed SIZE 70,15 OF oDlgPar PIXEL
If Empty(mv_par35) .or. mv_par35 == "T"
	oCobMed:nAT := 1
Else
	oCobMed:nAT := 2
Endif
_nLinha+=25
@  _nLinha,C(010) SAY "Considera mês corrente para calculo da média" PIXEL OF oDlgPar FONT oFont
@  _nLinha-2,C(140) COMBOBOX oMesCor VAR _cMesCor ITEMS _aMesCor SIZE 50,15 OF oDlgPar PIXEL
If Day(dDataBase) < 20
	oMesCor:nAT := 2
Else
	oMesCor:nAT := 1
Endif
@  _nLinha,C(200) SAY "Saída" PIXEL OF oDlgPar FONT oFont
//Ita - 08/03/2019 - Evitar call indevida - @  _nLinha-2,C(230) COMBOBOX oSaida VAR _cSaida ITEMS _aSaida SIZE 60,15 Valid ProcCtrA(_cSaida, _cRotina, cPerg) OF oDlgPar PIXEL
@  _nLinha-2,C(230) COMBOBOX oSaida VAR _cSaida ITEMS _aSaida SIZE 60,15 On Change ProcCtrA(_cSaida, _cRotina, cPerg) OF oDlgPar PIXEL

_nLinha+=20

@  _nLinha,C(00) MSPANEL oPanel2 PROMPT " " COLOR CLR_FONTT,CLR_FUNDO SIZE 1000,aPosObj[1][4] OF oDlgPar
_nLinha+=5
@ _nLinha ,C(010)  BUTTON "F2 - Processa" SIZE 60 ,15 FONT oFont ACTION { || TclCtrA(_cRotina, cPerg), IIF(_lFecha2,oDlgPar:End(),NIL) } OF oDlgPar PIXEL  //
@ _nLinha ,C(080)  BUTTON "ESC - Sair" SIZE 60 ,15 FONT oFont ACTION fClsPar() OF oDlgPar PIXEL  //

Activate MsDialog oDlgPar VALID u_fVldEsc() //Ita - 15/05/2019 - Implementado validação para saída da tela
SetKey(VK_F2, NIL )
SetKey(VK_F9, NIL ) //Ita - 01/03/2019
Return
//-----------------------------------------------------------------------------------------------------------
//
Static Function ProcCtrA(_cSaida, _cRotina, cPerg)

Local _aArea := GetArea()
If Substr(_cSaida,1,1) == "V"
	TclCtrA(_cRotina, cPerg)
	oDlg:End()	
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TclCtrA(_cRotina, cPerg)

Local _lRet 		:= .t.
Local _lFecha		:= .t.
Local _cFilProth	:= " "
Local aRet          := {}
Private _cFilSel 	:= ""
Private _aItemPC	:= {}
Private aPCRev		:= Array(36) //Ita - 23/04/2019 - Array(35)
Private _cFilGrp 	:= ""
Private _cMesVend 	:= " "
Private _cMesVTri 	:= " "
Private _aDiasTS	:= {}
Private _aMes		:= {}
Private _cMes07
Private _cMes06
Private _cMes05
Private _cMes04
Private _cMes03
Private _cMes02
Private _cMes01
If !fChkTrf() //Ita - 23/04/2019 - Testa se é transferência para consistir dados necessários para esta operação.
   Return
EndIf

If !fVldPar() //Ita - 03/06/2019
   Return
EndIf

SetKey(VK_F2, NIL )
_lRet := Grv_SX1(cPerg)
If _lRet
	For _nI:=1 to 10	// Total de filiais que podem ser digitadas na tela
		If !Empty(aPCRev[_nI])
			_lRet := u_B_FilANL(aPCRev[_nI], @_cFilProth)
			If _lRet
				If Empty(_cFilSel)
					_cFilSel := "('"
				Else
					_cFilSel += "','"
				Endif
				_cFilSel += _cFilProth
			Endif
		Else
			Exit
		Endif
	Next
	If _lRet
		If !Empty(_cFilSel)
			_cFilSel += "')"
		Endif

		For _nI:=14 to 18	// Total de linhas que podem ser digitadas na tela
			If !Empty(aPCRev[_nI])
				If Empty(_cFilGrp)
					_cFilGrp := "('"
				Else
					_cFilGrp += "','"
				Endif
				_cFilGrp += aPCRev[_nI]
			Else
				Exit
			Endif
		Next
		If !Empty(_cFilGrp)
			_cFilGrp += "')"
		Endif
		aRet     := ProcMv()  //Ita - 15/05/2019 - Aqui dispara a execução do F2-Processar
		_lFecha  := aRet[1]
		_lFecha2 := aRet[2]
		_lFecha3 := aRet[3] //Ita - 15/05/2019 - Controle de mensagem a serem apresentadas
	Endif
Endif

If !_lFecha2 .And. _lFecha3
	If MsgYesNo("Não existem itens a serem apresentados pelo filtro informado! Deseja sair da tela?")
		//Ita - 15/05/2019 - oDlg:End()
		oDlgPar:End()
	Else
       SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
       SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019
	   Return //Ita - 03/06/2019 - Não sair da tela.
	Endif
Endif

Return(_lFecha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Grv_SX1(cPergunta)

Local _aArea 	:= GetArea()
Local _lRet  	:= .t.
Local aPerg		:= {}
Local _cQuery
If Empty(_cCodMarc) .and. Empty(_cCodProd)
	Help(" ",1,"VFORNPROD",,"Preencher o Fornecedor ou Produto",4,,,,,,.F.)
	Return(_lRet)
Endif

If Empty(_cEmpr01)
	Help(" ",1,"VEMPRES",,"Informar as filiais",4,,,,,,.F.)
	Return(_lRet)
Endif

If _lRet
	Pergunte(cPergunta,.f., , , , , @aPerg)
	mv_par01 := _cEmpr01
	mv_par02 := _cEmpr02
	mv_par03 := _cEmpr03
	mv_par04 := _cEmpr04
	mv_par05 := _cEmpr05
	mv_par06 := _cEmpr06
	mv_par07 := _cEmpr07
	mv_par08 := _cEmpr08
	mv_par09 := _cEmpr09
	mv_par10 := _cEmpr10
	mv_par11 := _cTped
	mv_par12 := _nDiasEmp
	mv_par13 := _cCodMarc
	mv_par14 := _cLinha1
	mv_par15 := _cLinha2
	mv_par16 := _cLinha3
	mv_par17 := _cLinha4
	mv_par18 := _cLinha5
	mv_par19 := _cCodProd
	mv_par20 := _cEstZero
	mv_par21 := _cPrecoF
	mv_par22 := _cTabForn
	mv_par23 := _cCurva1
	mv_par24 := _cCurva2
	mv_par25 := _cCurva3
	mv_par26 := _cCurva4
	mv_par27 := _cMesIni
	mv_par28 := _cMesFim
	mv_par29 := Substr(_cQtdVr,1,1)
	mv_par30 := _nCobDe
	mv_par31 := _nCobAte
	mv_par32 := _nSugest
	mv_par33 := Substr(_cSitPro,1,1)
	mv_par34 := _cGeraAut
	mv_par35 := _cCobMed
	mv_par36 := _cOrigTrf
	__SaveParam(cPergunta,aPerg)
	For ni := 1 to 36//35
		aPCRev[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcMv()

Local _aArea	:= GetArea()
Local _lRet 	:= .T.
Local _lRetTrab := .T.
//Ita - 02/07/2019 - Tornar a\stru private para usar em outras funções a partri desta - Local aStru		:= {} 
Local ni		:= 1
Local _aProdABC := {}
Local _cMarcABC := aPCRev[13]
Local _dDataIni := Ctod("01/" + Substr(aPCRev[27],1,2) + "/" + Substr(aPCRev[27],3,2))
Local _dDataFim := LastDay(Ctod("01/" + Substr(aPCRev[28],1,2) + "/" + Substr(aPCRev[28],3,2)))
Local _cVlQT    := Substr(aPCRev[29],1,1)
Private cArqTrab	:= GetNextAlias()
//Private aTRBdados   := {} //Ita - 10/06/2019 - Array para armazena dados temporáriamente e depois popular no carqTrab ordenando conforme definido em parâmetros.
Private _aPCAuto := {} //Ita - 29/03/2019 - Array para guardar os itens do PC Automático
Private aMrkTRB := {} //Ita - 24/05/2019 - Controle de Marcação dos Itens no Pedido de revenda
Private aStru		:= {} //Ita - 02/07/2019 - Tornar a\stru private para usar em outras funções a partri desta
SetKey(VK_F2, NIL ) //Ita - 09/07/2019 - Desabilita temporariamente o uso da função F2 para evitar memoriza buffer e causar erro de execução.
private  cUserLog := Strtran(UsrRetName(RetCodUsr()),".","")
//MsgInfo("Gera Pedido Automatico = "+_cGeraAut)//Ita - 18/06/2019
///////////////////////////////////////////////////
/// Ita - 15/05/2019
///     - Checa se já existe um PC do mesmo
///     - Fornecedor sendo digitado neste momento.
/*
If !fChkUsoPC(_cCodMarc,dDataBase)
   _lRet     := .F.
   _lRetTrab := .F.
   SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
   SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019
   Return({_lRet,_lRetTrab, .F.})
EndIf
*/
//cpare:=""
///////////////////////////////////////////////////////////////////////////
/// Ita - 16/05/2019
///     - Novo controle de Acesso da Tela de Compras para o mesmo
///     - Filial+Fornecedor/Marca e Data de Inclusão

If _nOpcCont == 2 //Se for um Novo Pedido
   _dDataChk := dDataBase //Ita - 20/05/2019 - Tratamento para novo pedido

	cStartPath 	:= GetSrvProfString("Startpath","")
	//Ita - 21/05/2019 - _cArqFlag := xFilial("SZ1")+Alltrim(_cCodMarc)+DtoS(_dDataChk)+".italog"
	_cArqFlag := cfilant+Alltrim(_cCodMarc)+".italog"
	If File(cStartPath+_cArqFlag)
	   _lRet     := .F.
	   _lRetTrab := .F.
	   cPerg		:= "PCREVENDA" 
	   _lRetorno    := .t.
	   _cRotina	    := "4"
	   SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
	   SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019
	   //Alert("Já existe um pedido sendo digitado para o fornecedor: "+Alltrim(_cCodMarc)+" nesta mesma data "+DTOC(_dDataChk)+" na filial "+xFilial("SZ1"))
	   Alert("Já existe um usuário digitando um pedido para este fornecedor: "+Alltrim(_cCodMarc)+" nesta mesma filial "+cfilant)
	   Return({_lRet,_lRetTrab, .F.})
	EndIf
	//cTxtArq := "Pedido de compras em uso - Filial "+xFilial("SZ1")+" Fornecedor/Marca: "+Alltrim(_cCodMarc)+" Data: "+DTOC(dDataBase)
	//MemoWrite(cStartPath+_cArqFlag,cTxtArq)
	If !fChkUsoPC(_cCodMarc,_dDataChk,_cEmpr01)
	   _lRet     := .F.
	   _lRetTrab := .F.
	   cPerg		:= "PCREVENDA" 
	   _lRetorno    := .t.
	   _cRotina	    := "4"
	   SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
	   SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019
	   Return({_lRet,_lRetTrab, .F.})
	EndIf

Else
   _dDataChk := (cAliasTMP)->TMP_DTINCL //Ita - 20/05/2019 - Tratamento para continuar
	cStartPath 	:= GetSrvProfString("Startpath","")
	//Ita - 21/05/2019 - _cArqFlag := xFilial("SZ1")+Alltrim(_cCodMarc)+DtoS(_dDataChk)+"_continuar.italog"
	//_cArqFlag := xFilial("SZ1")+Alltrim(_cCodMarc)+"_continuar.italog"
	_cArqFlag := cfilant+Alltrim(_cCodMarc)+".italog"
	If File(cStartPath+_cArqFlag)
	   _lRet     := .F.
	   _lRetTrab := .F.
	   cPerg		:= "PCREVENDA" 
	   _lRetorno    := .t.
	   _cRotina	    := "4"
	   SetKey(VK_F2, { || _lRetorno := TclCtrA(_cRotina, cPerg), IIF(_lRetorno,oDlgPar:End(),"") } )
	   SetKey( VK_F9 , { || fFocProd() } ) //Ita - 01/03/2019
	   Alert("Um pedido do fornecedor: "+Alltrim(_cCodMarc)+" de "+DTOC(_dDataChk)+" já está sendo digitado nesta filial "+cFilAnt)
	   //Alert("Um pedido do fornecedor "+Alltrim(_cCodMarc)+" já está sendo digitado nesta filial "+xFilial("SZ1"))
	   Return({_lRet,_lRetTrab, .F.})
	EndIf
EndIf   

/// Ita - 16/05/2019 - Fim do Controle de Acesso da Tela de Compras /////////////////////////////////////////////////////////////////////////////////////////
Processa( {|lEnd| _aProdABC := u_Calc_Curv(_cMarcABC, _dDataIni, _dDataFim, _cVlQT, _cFilSel )}, "Aguarde...","Processando Curva ABC...1/3", .T. )
Private _ObjTRB
If (aPCRev[33] == "1" .and. Len(_aProdABC) > 0) .or. aPCRev[33] <> "1"
	Processa( {|lEnd| Calc_Sug(cArqTrab, @aStru, _aProdABC,@_ObjTRB)}, "Aguarde...","Processando Demandas...2/3", .T. ) //Ita - 10/06/2019 - Criado variável _ObjTRB
    /////////////////////
    /// Ita - 27/03/2019
    ///     - fRPCAut()
    ///       Função para Gerar Pedido de Compras Automático
    ///       Se o parâmetro estivel habilitado e os itens estiverem
    ///       com sugestões disponíveis.
    _lTemPCA := .F. //Ita - 03/06/2019 - Controle do Pedido Automático para gerar atualização dos totais do PC
    If Len(_aPCAuto) > 0
       //_lTemPCA := .T. //Garante que tem Pedido Automático
    
       If Left(_cGeraAut,1) == "S"
          //MsgInfo("Sistema irá trazer itens com sugestão já marcados para geração do pedido de compras") //Ita - 18/06/2019
          Processa({||fRPCAut(_aPCAuto,_cMarcABC,@_lTemPCA)},"Gerando PC pela Sugestão Calculada, aguarde...")
       EndIf
    EndIf
	(cArqTrab)->(DbGoTop())
	If !(cArqTrab)->(Eof())
	    ///Ita - 01/04/2019
		Mov_ItBw(cArqTrab, aStru,_lTemPCA,_ObjTRB) //Ita - 10/06/2019 - Passando objeto _ObjTRB para tratar ordenação da tabela temporária
	Else
		_lRetTrab := .F.
	Endif
	dbSelectArea(cArqTrab)
	dbCloseArea()
Else
	_lRet := .F.
	Help(" ",1,"NCURVABC",,"Não encontrado NFs de Venda no período informado para classificação da Curva ABC",4,,,,,,.F.)
Endif

RestArea(_aArea)
//Ita - Acrescentado mais um parâmetro para controle de apresentação das mensagens - 15/05/2019 - Return({_lRet,_lRetTrab})
Return({_lRet,_lRetTrab,.T.})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function B_FilANL(_cFilANL, _cFilProth, _lMens)

Local _lRet := .t.
Default _cFilProth := " "
Default _lMens := .T.
If !Empty(_cFilANL)
	If _lMens
		_lRet := ExistCpo("SX5","99"+_cFilANL)
	Else
		SX5->(dbSetOrder(1))
		If !SX5->(dbSeek(xFilial("SX5")+"99"+_cFilANL))
			_lRet := .F.
		Endif
	Endif		
Endif
If _lRet
	_cFilProth := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cFilANL,"X5_DESCRI"),1,6)
	cfilant    := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cEmpr01,"X5_DESCRI"),1,6)  //Ita - 11/04/2019
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  05/31/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Aut_PCOK(cArqTrab)


Local nOperation 		:= MODEL_OPERATION_UPDATE
Local aEnableButtons 	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil} }//"Salvar Simulação" //"Fechar"

oModelLiq := FWLoadModel('MNTPC')//Carrega estrutura do model

oModelLiq:SetOperation( MODEL_OPERATION_UPDATE ) //Define operação de inclusao
oModelLiq:Activate()//Ativa o model

cTitulo      	:= OemToAnsi("Dados para Pedido")
cPrograma    	:= 'MNTPC'
__lUserButton  	:= .T.
bCancel      	:=  { |oModelLiq| F460NoAlt(oModelLiq)}

dbSelectArea("SC7")
FWExecView( cTitulo , cPrograma, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , 40 /*nPercReducao*/, aEnableButtons, bCancel , /*cOperatId*/, /*cToolBar*/,oModelLiq )
_lUserButton 	:= .F.
oModelLiq:Deactivate()
oModelLiq:Destroy
oModelLiq := NIL

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mov_ItBw(cArqTrab, aStru,_lAutoPC,_ObjTAB) //Ita - 03/06/2019 - Acrescentado _lAutoPC para tratar totais do pedido. Ita - 10/06/2019 - _ObjTAB - tratar ordenação da tabela temporária

Local _aArea		:= GetArea()
Local _aRotOri		:= aRotina
Local oBrowse		:= Nil
Local cFilter		:= ""
Local cQuery		:= ""
Local cChave		:= ""
Local nX			:= 0
Local bOk			:= {|| ANTela_G() }
Local cTitulo		:= "ESTOQUE"
Local oFnt2S  		:= TFont():New("Arial",6 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
Local oFnt12S  		:= TFont():New("Arial",08 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
Local aColumns		:= {}
Local _nLinha		:= 0
//Ita - 23/05/2019 - Local _aSZ1			:= {}
Local nTamRej		:= 800
Local _aCampo		:= {}
Local _cTipoc		:= ""
Local aFields		:= {}
Private _nValPC		:= 0
Private _nItemSel	:= 0
Private _nQtdVol    := 0 //Ita - 03/06/2019 - Quantidade de volumes do pedido
Private _oQtdVol         //
Private _nVlCIPI    := 0 //Ita - 03/06/2019 - Valor Sem IPI
Private _oVlCIPI
Private _nValIPI    := 0 //Ita - 05/06/2019 - Valor de IPI do Pedido
Private _oValIPI
//Private _oValPC
//Private _oItemSel
//Private _nRcNoTRB := 0 //Ita - 27/06/2019 - Guardar último recno selecionado da tabela temporária para posicioná-la na entrada da tela. 
Private oMrkBrowse	:= FWMarkBrowse():New()
Private oDlgPC
Private nOpcA	:= 0
Private _aSZ1			:= {}
Private bCrgPC  := {|| Sel_PCAnt(cArqTrab, @_aSZ1) } //Ita - 20/05/2019 - Refresh dos itens após alteração da data de faturamento
Private bAtuZ1  := {|| ATU_SZ1(cArqTrab, _aSZ1) }    //Ita - 23/05/2019
_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
Private bAtTots := {|| fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) } //Ita - 03/06/2019
Private xStru := aClone(aStru)  //Ita - 10/06/2019



aRotina := {}

//SetKey( K_ESC , { || Alert("esc") } )
SetKey( VK_F2  , { || ANTela_G() } )
SetKey( VK_F4  , { || RestKey("0"), ANItemPC((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
SetKey( VK_F5  , { || RestKey("0"), ANConKard((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
//Ita - 28/06/2019 - SetKey( VK_F6  , { || RestKey("0"), ANPrdSim((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
SetKey( VK_F6  , { || RestKey("0"), ANPrdSim((cArqTrab)->TRB_COD,aStru), RestKey("1", cArqTrab) } ) //Ita - passando array aStru para apresentação dos similares
SetKey( VK_F7  , { || RestKey("0"), ANPrdApl((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
SetKey( VK_F8  , { || RestKey("0"), ANCOnDem((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
SetKey( VK_F9  , { || RestKey("0"), ANPesqCod(oMrkBrowse, cArqTrab,_cPrdPos), RestKey("1", cArqTrab) } ) //Ita - Preencher Código do último Produto digitado  na Pesquisa - Solicitação Gustavo - SetKey( VK_F9  , { || RestKey("0"), ANPesqCod(oMrkBrowse, cArqTrab), RestKey("1", cArqTrab) } )

SetKey( VK_F10  , { || fPrtConsumos(cArqTrab) } ) //Ita - 16/04/2019 - Impressão da Tela de Consumos
SetKey( VK_F11 , { || RestKey("0"), ANItBlq(cArqTrab), RestKey("1", cArqTrab) } )

For nX := 1 To Len(aStru)
	//If	!aStru[nX][1] $ "TRB_BLQ/TRB_OK/TRB_PRECO/TRB_TOTAL/TRB_MES07/TRB_MES06/TRB_MES05" //Ita - 29/05/2019 - Colunas que não devem aparecer no browse
	If	!aStru[nX][1] $ "TRB_BLQ/TRB_OK/TRB_PRECO/TRB_TOTAL/TRB_MES07/TRB_MES06/TRB_MES05/TRB_COBPEN/TRB_PERC" //Ita - 10/06/2019 - /TRB_VALTRI/TRB_VALSEM/TRB_MTRING/TRB_MSEMNG" //Ita - 29/05/2019 - Colunas que não devem aparecer no browse 	// Alterado 20/06/19 Rotta
		AAdd(aColumns,FWBrwColumn():New())
		aColumns[Len(aColumns)]:lAutosize:=.f.
		aColumns[Len(aColumns)]:SetData( &("{||"+aStru[nX][1]+"}") )
		aColumns[Len(aColumns)]:SetTitle(aStru[nX][5])
		aColumns[Len(aColumns)]:SetType(aStru[nX][2])
		aColumns[Len(aColumns)]:SetSize(aStru[nX][6])
		aColumns[Len(aColumns)]:SetDecimal(aStru[nX][4])
		aColumns[Len(aColumns)]:SetPicture(aStru[nX][7])
		If aStru[nX][2] $ "N/D"
			aColumns[Len(aColumns)]:nAlign := 3
		Endif
	EndIf
	AAdd(aFields,{aStru[nX][1],aStru[nX][5],aStru[nX][2],aStru[nX][6],aStru[nX][4],aStru[nX][7]})
Next nX

aSeek	   := {}
aFieFilter := {}

Aadd(aSeek,{"Código"	, {{"","C",TAMSX3("B1_COD")[1],0, "TRB_COD",}} 		, 1, .T. } )
Aadd(aSeek,{"Curva"		, {{"","C",1,0, "TRB_CLASSE",""}}					, 2, .T. } )

//////////////////////////////////////////////////////////////////////
/// Ita - 21/05/2019
///     - Criado novas opções de ordenação da tela de itens do pedido

//Aadd(aSeek,{"Qtd + Trimestre", {{"","C",16,0, "TRB_MEDTRI",""}}			, 3, .T. } )
//Aadd(aSeek,{"Qtd + Semestre", {{"","C",16,0, "TRB_MEDSEM",""}}			, 4, .T. } )

//Aadd(aSeek,{"Valor + Trimestre", {{"","C",16,0, "TRB_MEDTRI * TRB_PRECO",""}}			, 5, .T. } )
//Aadd(aSeek,{"Valor + Semestre", {{"","C",16,0, "TRB_MEDSEM * TRB_PRECO",""}}			, 6, .T. } )


Aadd(aFieFilter,{'TRB_COD', "Código",'C', TAMSX3("B1_COD")[1], 0})

dbSelectArea(cArqTrab)
//Ita 18/06/2019 - dbSetOrder(2)//Ita - 14/06/2019
//Ita - 29/03/2019 - dbSetOrder(1)
dbSetOrder(_nOrdTrab) //Ita 18/06/2019 - //2 - Ordenar pelo segundo índice - _oFINA7711:AddIndex("2",{"TRB_CLASSE+TRB_COD"})
///////////////////////////////////////////////////////////////////////
/// Ita - 21/05/2019
///     - Classificação dos registros conforme seleção dos parâmetros

_nPerParam := (Val(Left(_cMesFim,2)) - Val(Left(_cMesIni,2))) + 1 //Encontra o período informado nos parâmetros
/*
_oFINA7711:AddIndex("3",{"TRB_MTRING"})
_oFINA7711:AddIndex("4",{"TRB_MSEMNG"})
_oFINA7711:AddIndex("5",{"TRB_VALTRI"})
_oFINA7711:AddIndex("6",{"TRB_VALSEM"})
*/
////////////////////////////
/// Ita - 29/05/2019
///     - Criado variavel para armazenar o indice da
///     - tabela temporária
///     - _nOrdTrab
//MsgInfo("Periodo dos Parametros(_nPerParam): "+Alltrim(Str(_nPerParam)))
/*
If Left(_cQtdVr,1) == "V"     // - Valor")
   If _nPerParam <= 3   //Se Período Trimestral
      _nOrdTrab := 5          //TRB_VALTRI
      //MsgInfo("Ordenar por Valor - Periodo Período Trimestral")
      //OrdDescend(5, "", .T.)  
   Else                 //Se Período Semestral
      _nOrdTrab := 6    //TRB_VALSEM
      //MsgInfo("Ordenar por Valor - Periodo Período Semestral")
      //OrdDescend(6, "", .T.)  
   EndIf
ElseIf Left(_cQtdVr,1) == "Q" // - Quantidade")
   If _nPerParam <= 3  //Se Período Trimestral
      _nOrdTrab := 3    //TRB_MTRING
      //MsgInfo("Ordenar por Quantidade - Periodo Período Trimestral")
      //OrdDescend(3, "", .T.)  
   Else                //Se Período Semestral
      _nOrdTrab := 4    //TRB_MSEMNG
      //MsgInfo("Ordenar por Quantidade - Periodo Período Semestral")
      //OrdDescend(4, "", .T.)  
   EndIf
EndIf
dbSelectArea(cArqTrab)
dbsetorder(_nOrdTrab)  
*/
dbSelectArea(cArqTrab)
//Ita - 18/06/2019 - dbsetorder(2)  //Ita - 14/06/2019 - Ordem por Curva e Código
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
///////////////////////////
///   Ita - 01/04/2019
///       - Implementado condição através da variável _nOpcCont
///         para checar se trata da continuação ou de um novo pedido
///         de compras
If _nOpcCont == 1 .Or. Left(_cGeraAut,1) == "S" //Continuar ou se Gera Pedido Automático
   Sel_PCAnt(cArqTrab, @_aSZ1)
EndIf

	oSize := FwDefSize():New(.T.)
	
	oSize:lLateral := .F.
	oSize:lProp	:= .T. // Proporcional

	oSize:AddObject( "CABECALHO",  100, 05, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "GETDADOS" ,  100, 90, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "RODAPE"   ,  100, 05, .T., .T. ) // Totalmente dimensionavel

	oSize:lProp 	:= .T. // Proporcional
//	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3
	oSize:aMargins 	:= { 0, 0, 0, 0 } // Espaco ao lado dos objetos 0, entre eles 3
	oSize:Process() 	   // Dispara os calculos
	
	_nLinha  := oSize:GetDimension("CABECALHO","LININI") - 20
	_nColuna := oSize:GetDimension("CABECALHO","COLINI")
	Private oDlgy
	DEFINE MSDIALOG oDlgy TITLE "Consumos" FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME //"Baixa em Lote"

//	oDlgy:lEscClose := .T.		// Desabilita a tecla ESC

	@ _nLinha ,_nColuna SAY "Marca: " Of oDlgy PIXEL SIZE 56 ,9 FONT oFont
	_nColuna+=25 //50
	@ _nLinha ,_nColuna GET _oFornV VAR _cCodMarc When .F. OF oDlgy PIXEL
	_nColuna+=35 //50
	@ _nLinha ,_nColuna SAY "Itens Selecionados: " Of oDlgy PIXEL SIZE 150 ,9 FONT oFont
	_nColuna+=75
	@ _nLinha ,_nColuna GET _oItemSel VAR _nItemSel Picture "@E 9,999" When .F. OF oDlgy PIXEL
	_nColuna+=30 //40
    @ _nLinha ,_nColuna SAY "Volumes:    " Of oDlgy PIXEL SIZE 65 ,9 FONT oFont                              //Ita - 03/06/2019 - Volume Total de Itens
    _nColuna+=40                                                                                             //    - Soma de todas as quantidades
    @ _nLinha ,_nColuna GET _oQtdVol VAR _nQtdVol  Picture "@E 9,999,999" When .F. OF oDlgy PIXEL         //    - selcionadas.
    _nColuna+=55
	@ _nLinha ,_nColuna SAY "Total (R$): " Of oDlgy PIXEL SIZE 65 ,9 FONT oFont
	_nColuna+=40
	@ _nLinha ,_nColuna GET _oValPC VAR _nValPC Picture "@E 9,999,999.99" When .F. OF oDlgy PIXEL
    _nColuna+=55
	@ _nLinha ,_nColuna SAY "Valor IPI (R$): " Of oDlgy PIXEL SIZE 65 ,9 FONT oFont
	_nColuna+=50
	@ _nLinha ,_nColuna GET _oValIPI VAR _nValIPI Picture "@E 9,999,999.99" When .F. OF oDlgy PIXEL
    _nColuna+=55
	@ _nLinha ,_nColuna SAY "Total C/IPI(R$): " Of oDlgy PIXEL SIZE 65 ,9 FONT oFont                         //Ita - 03/06/2019 - Valor Total Sem IPI
	_nColuna+=60                                                                                             //    - Soma total dos itens sem considerar
	@ _nLinha ,_nColuna GET _oVlCIPI VAR _nVlCIPI Picture "@E 9,999,999.99" When .F. OF oDlgy PIXEL          //    - a incidência de IPI.
	/////////////////////
	/// Ita - 08/04/2019
	///     - Implementado informações referente ao tipo do pedido
	_nColuna+=55 //70 //90
    @  _nLinha,_nColuna SAY "Tipo Pedido" PIXEL OF oDlgy FONT oFont
    _nColuna+=45
    @  _nLinha,_nColuna COMBOBOX oTped VAR _cTped ITEMS _aTped SIZE 60,11 OF oDlgy PIXEL WHEN .F.
	
	oPanel := TPanel():New(oSize:GetDimension("GETDADOS","LININI") - 20,oSize:GetDimension("GETDADOS","COLINI"),,oDlgy,,,,,,oSize:GetDimension("GETDADOS","XSIZE"),oSize:GetDimension("GETDADOS","YSIZE"),,)

	@ oSize:GetDimension("RODAPE","LININI") ,oSize:GetDimension("RODAPE","COLINI") SAY "F2 - Processar    F4 - Pedidos em Aberto     F5 - Kardex    F6 - Similares   F7 - Aplicação    F8 - Consumo por Empresa   F9 - Pesquisa   F10 - Imprimir Dados    F11 - Bloqueia/Desbloqueia Item para Compra    Enter - Selecionar Item"  Of oDlgy PIXEL SIZE 600 ,9

///////////////////////////////
/// Ita - 15/04/219
///       Tratamento da Cor da Linha para evitar usar coluna de legendas
///       e possibilitar mais espaços para colunas de informações de
///       compras.
///       oMrkBrowse:AddLegend({|| (cArqTrab)->TRB_BLQ == "S"}, 'DISABLE', "Produto Bloqueado para Compra")
///       oMrkBrowse:AddLegend({|| (cArqTrab)->TRB_BLQ <> "S"}, 'ENABLE', "Produto Liberado para Compra")
oMrkBrowse:oBrowse:SetBlkBackColor({|| GETDCLR(oMrkBrowse:oBrowse:nAt)})
oMrkBrowse:SetTemporary(.T.)
oMrkBrowse:SetAlias(cArqTrab)
oMrkBrowse:SetFontBrowse(oFnt12S)
//AddButton(< cTitle >, < xAction >, < uParam1 >, < nOption >, < nVerify >)
//oMrkBrowse:AddButton("Imprimir", "", , 8, 0)
//oMrkBrowse:oBrowse:Enable()
/////////////////////////
/// Ita - 16/04/2019
///       Filtro para apresentar itens da sugestão conforme critério estabelecido por consumos
///       definidos na tela de parâmnetros
//oMrkBrowse:SetFilter("TRB_COBPEN", Alltrim(Str(_nCobAte)), "0")//Filtra Registro por quantidade de dias de cobertura, caso a cobertura for maior que a definida em parâmetros, sistema não apresenta registros.
//Ita - 15/05/2019 - Se cobertura de/Até for informada
If _nCobDe + _nCobAte <> 0
   oMrkBrowse:SetFilterDefault("TRB_COBPEN < "+Alltrim(Str(_nCobAte)))
EndIf
//AddMarkColumns
oMrkBrowse:SetFieldMark("TRB_OK")
oMrkBrowse:SetOwner(oPanel)
//Ita - 27/03/2019 - Comentado para Implementar colunas dos meses de forma correta e não fixa, como estava anteriormente - oMrkBrowse:bMark     := {|| Tela_Dig(aStru, cArqTrab), SetKey( VK_F2  , { || ANTela_G() } )}
oMrkBrowse:bMark     := {|| Tela_Dig(aStru, cArqTrab,aColumns), SetKey( VK_F2  , { || ANTela_G() } )}
oMrkBrowse:bAllMark  := {|| fLimpAll()}
oMrkBrowse:SetDescription("")
oMrkBrowse:DisableReport()
oMrkBrowse:DisableLocate()
oMrkBrowse:DisableConfig()
oMrkBrowse:SetColumns(aColumns)
oMrkBrowse:SetMenuDef("")

//oMrkBrowse:SetOnlyFields({})
//oMrkBrowse:SetFieldFilter( aFields )
oMrkBrowse:SetUseFilter(.F.)
//Ita - 06/06/2019 - oMrkBrowse:Refresh(.F.)//Ita - 06/06/2019 - Não ir para o top da tela.
//lGoTop := .F. 
//oMrkBrowse:Refresh(lGoTop)
//Ita - 10/06/2019 - oMrkBrowse:SetAfterMark({||fAtuMrk()})

//oMrkBrowse:SetSeek(.T.,aSeek)
//oMrkBrowse:SetIgnoreArotina(.T.)
oMrkBrowse:Activate()
cpare:=""
If Len(_aSZ1) > 0
	ATU_SZ1(cArqTrab, _aSZ1)
    //Ita - 27/06/2019 - _psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) //Ita - 03/06/2019
    //Ita - 27/06/2019 Eval(bAtTots) //Ita - 03/06/2019
Endif
If _lAutoPC //Para atualizar totais do pedido
   //MsgInfo("Tem Pedido Automático - 18/06/2019")
   fMrkAll() //Ita - 14/06/2019
   //Ita - 27/06/2019 - _psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) //Ita - 03/06/2019
   //Ita - 27/06/2019 - Eval(bAtTots) //Ita - 03/06/2019
EndIf

//////////////////////////////////////////////////////////////////
///  Ita - 27/06/2019  
///      - Atualizará totias independente se for pedido automático
///      - ou continuação do pedido
///      - Foi implementado devido a necessidade de deixar os totais
///      - aparente, mesmo também se os itens digitados anteriormente
///      - não estejam sendo apresentados na tela atual(filtrada)
_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)  //Ita - 27/06/2019 
Eval(bAtTots)                                                       //Ita - 27/06/2019


//oMrkBrowse:SetFontBrowse(oFnt2S)
oMrkBrowse:SetLineHeight(50)
//Eval(bOrdTRB) //Ita - 10/06/2019
//cpare:=""
//oDlgy:OCTLFOCUS:BCURSORMOVE := {||}   
//oDlgy:BMOVED:=.F.
//oDlgy:BFOCUSCHANGE:=.F. //Ita - 06/06/2019
//ACTIVATE MSDIALOG oDlgy ON INIT EnchoiceBar(oDlgy,bOk ,{|| oDlgy:End()}) CENTERED VALID u_PressEsc(nOpcA) 
////////////////////////////////////////////////////////////
/// Ita - 16/05/2019 - Controle de Acesso a Tela de Compras
//Ita - 20/05/2019 - If _nOpcCont == 2 //Se for um Novo Pedido
   cTxtArq := "Pedido de compras em uso - Filial "+cFilAnt+" Fornecedor/Marca: "+Alltrim(_cCodMarc)+" Data: "+DTOC(dDataBase)+" Hora: "+Time()
   MemoWrite(cStartPath+_cArqFlag,cTxtArq)
//EndIf
//MsgInfo("Vou Posicionar no RecNo "+Alltrim(Str(_nRcNoTRB)))
If Len(_aSZ1) > 0
   _nRcNoTRB := 0
   fPosTRB(@_nRcNoTRB)//Ita - 28/06/2019 - Função para posicionar no último produto digitado.
   /***Ita - 21/08/2019 - Não posicionar no último produto digitado, ao invés,usar tecla F9(Pesquisa Produto) com o último produto digitado sendo sugerido na pesquisa
    oMrkBrowse:GoTo (_nRcNoTRB,.T.) //Ita - 27/06/2019 - Posiciona último recno selecionado na tabela temporária.
    *****/
EndIf
ACTIVATE MSDIALOg oDlgy CENTERED  VALID PressEsc(_aArea,_aRotOri) //u_PressEsc()
   
dbSelectArea("SZ1")
dbSetOrder(2) //Ita 15/05/2019 - Z1_FILIAL+Z1_STATUS+Z1_CODFORN+Z1_PRODUTO
dbSeek(xFilial()+"1"+PadR(aPCRev[13],6))
//Ita - 30/05/2019 - While !Eof() .and. xFilial("SZ1")+"1"+aPCRev[13] == SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)
While !Eof() .and. cFilAnt+"1"+aPCRev[13] == SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)
	RecLock("SZ1",.F.)
	Replace Z1_STATUS with "2"
	MsUnLock()
	dbSelectArea("SZ1")
	DbSkip()
EndDo
RestKey("0")
//Ita - 10/06/2019 - RestArea(_aArea)
aRotina := _aRotOri

Return

//-----------------------------------------------------------------------------
//
Static Function PressEsc(_xArea,_xRotOri)

Local lRet := .T.
lRet := MsgYesNo("Confirma saida da tela?","Atenção")
//cpare:=""
///////////////////////////////////////////////////////////////
/// Ita - 15/05/2019
///     - Ao pressionar ESC - retorna para tela de parâmetros.
If lRet
    //FErase(cStartPath+_cArqFlag) //Ita - 04/07/2019
    //MsgInfo("lRet é TRUE")
    /*
	dbSelectArea("SZ1")
	dbSetOrder(2) //Ita 15/05/2019 - Z1_FILIAL+Z1_STATUS+Z1_CODFORN+Z1_PRODUTO
	If dbSeek(xFilial("SZ1")+"1"+Padr(aPCRev[13],6))
	   //MsgInfo("Após DbSeek ["+xFilial("SZ1")+"1"+Padr(aPCRev[13],6)+"] - Reg.SZ1 ["+SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)+"]")
	   While !Eof() .and. xFilial("SZ1")+"1"+Padr(aPCRev[13],6) == SZ1->(Z1_FILIAL+Z1_STATUS+Z1_CODFORN)
		  //MsgInfo("Entrei no While")
		  RecLock("SZ1",.F.)
		  Replace Z1_STATUS with "2"
		  MsUnLock()
		  //MsgInfo("Atualize status para "+Z1_STATUS)
		  dbSelectArea("SZ1")
		  DbSkip()
	  EndDo
	//Else
	//   Alert("Não Localizou chave: "+xFilial("SZ1")+"1"+aPCRev[13])
	EndIf
	*/
	_IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)  
	cQryUPD := " UPDATE "+RetSQLName("SZ1")
	cQryUPD += "    SET Z1_STATUS = '2'"
	cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'"
	cQryUPD += "    AND Z1_CODFORN = '"+Padr(aPCRev[13],6)+"'"
	cQryUPD += "    AND Z1_STATUS = '1'"
	cQryUPD += "    AND Z1_DTINCL = '"+DTOS(_IncDt)+"'"
	cQryUPD += "    AND D_E_L_E_T_ <> '*'"
	
    If TCSqlExec( cQryUPD ) <> 0
       MsgAlert( " Erro ao tentar atualizar status do Pedido " + TCSqlError() )   
    EndIf
    
    ///////////////////////////////////////////////////////
    /// Ita - 16/05/2019
    ///     - Controle de Acesso para o Pedido de Compras
    If File(cStartPath+_cArqFlag)
	   FErase(cStartPath+_cArqFlag)
    EndIf
    	
	//RestKey("0")
	//RestArea(_aArea)
	RestArea(_xArea)
	aRotina := _xRotOri
	//_cVazCod := CriaVar("ZZN_COD",.F.)
    Aut_PC_T(_cCodMarc)
//Else
//   MsgInfo("lRet é false")
EndIf

Return lRet

//-------------------------------------------------------------------------------------------------------------------------------------------
//

Static Function Sel_PCAnt(cArqTrab, _aSZ1, cNumAE)

Local _aArea := GetArea()
Local cAliasSZ1	:= "QRYSZ1"
Local _nTotal	:= 0 
If SELECT(cAliasSZ1) > 0 //Ita - 28/05/2019
   dbSelectArea(cAliasSZ1)
   DbCloseArea()
EndIf

dbSelectArea("SZ1")
_cQuery := "SELECT Z1_PRODUTO, Z1_DTENTR, Z1_QUANT, Z1_PRUNIT, Z1_TOTAL, R_E_C_N_O_ RECNOZ1, Z1_CODFORN,Z1_DTINCL" + _Enter //Ita - 18/06/2019 - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
_cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
_cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
_cQuery += "   AND Z1_CODFORN = '" + _cCodMarc + "'" + _Enter
//Ita - 29/05/2019 - _cQuery += "   AND Z1_QUANT > 0 " + _Enter               //Ita - 07/03/2019
//_cQuery += " AND Z1_PEDIDO = '" + cNumAE+"'"  //Ita - 07/03/2019 
_cQuery += "   AND Z1_DTINCL = '"+DTOS((cAliasTMP)->TMP_DTINCL)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
_cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
MemoWrite("C:\TEMP\Aut_PC_cAliasSZ1_2.SQL",_cQuery)//Ita - 02/04/2019
MemoWrite("\Data\Aut_PC_cAliasSZ1_2.SQL",_cQuery)
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ1,.T.,.T.)
dbSelectArea(cAliasSZ1)
aDuplItens := {} //Ita - 07/03/2019 - Evitar duplicidades de itens
While !Eof()
	dbSelectArea(cArqTrab)
	dbSetOrder(1)
	If dbSeek((cAliasSZ1)->Z1_PRODUTO)
	    nPosIt := aScan(aDuplItens, (cAliasSZ1)->Z1_PRODUTO + cValToChar((cAliasSZ1)->Z1_DTENTR) + cValToChar((cAliasSZ1)->Z1_QUANT) + cValToChar((cAliasSZ1)->Z1_PRUNIT) + cValToChar((cAliasSZ1)->Z1_TOTAL) )//Ita - 07/03/2019
		If nPosIt == 0
		   aAdd(aDuplItens, (cAliasSZ1)->Z1_PRODUTO + cValToChar((cAliasSZ1)->Z1_DTENTR) + cValToChar((cAliasSZ1)->Z1_QUANT) + cValToChar((cAliasSZ1)->Z1_PRUNIT) + cValToChar((cAliasSZ1)->Z1_TOTAL) )
		   aadd(_aSZ1, (cAliasSZ1)->RECNOZ1)
		   
		   If aScan(aMrkTRB,{|x| x[1] == (cAliasSZ1)->Z1_PRODUTO }) == 0 //Ita - 24/05/2019
		      //Ita - 18/06/2019 - aAdd(aMrkTRB, {(cAliasSZ1)->Z1_PRODUTO,1}) 
		      aAdd(aMrkTRB, {(cAliasSZ1)->Z1_PRODUTO,1,(cAliasSZ1)->Z1_CODFORN,(cAliasSZ1)->Z1_DTINCL}) //Ita - 18/06/2019 -  - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
		      
		   EndIf
		   
		EndIf
	Endif
	dbSelectArea(cAliasSZ1)
	dbSkip()
End
(cAliasSZ1)->(dbCloseArea())
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
RestArea(_aArea)
Return

//----------------------------------------------------------------------------------------------------------
//

Static Function ATU_SZ1(cArqTrab, _aSZ1)

Local _aArea := GetArea()
Local _nTotal	:= 0
aDuplItPC := {} //Ita - 23/05/2019
aContItens:= {} //Ita - 29/05/2019 - Contagem de Itens e Valor do Pedido
dbSelectArea("SZ1")
dbSetOrder(1)
For nB:=1 to Len(_aSZ1)
	dbGoto(_aSZ1[nB])
	_cCodProd := SZ1->Z1_PRODUTO
	_dDtEnt	  := SZ1->Z1_DTENTR
	_nQtdPC	  := SZ1->Z1_QUANT
	_nPrcPC   := SZ1->Z1_PRUNIT
	_nTotPC	  := SZ1->Z1_TOTAL
	_nRecno	  := SZ1->(recno())
	//_lNaoBloq    := If(Posicione("SBZ",1,SZ1->Z1_FILIAL+SZ1->Z1_PRODUTO,"BZ_XBLQPC")<>"S",.T.,.F.) //Ita - 12/06/2019
	//Ita - 03/09/2019 - If _nQtdPC > 0 //.And. _lNaoBloq //Ita - 12/06/2019 - Quantidade maior que zero e não estiver bloqueado para compra.
	If _nQtdPC >= 0 //03/09/2019 Considerar datas com quantidades zeradas, pois podem ter sido geradas para marcar o pedido.And. _lNaoBloq //Ita - 12/06/2019 - Quantidade maior que zero e não estiver bloqueado para compra.
		dbSelectArea(cArqTrab)
		dbSetOrder(1)
		If dbSeek(_cCodProd)
		    /* Ita - 30/05/2019
		    If aScan(aContItens,_cCodProd) == 0
		       aAdd(aContItens,_cCodProd)
		       _nItemSel++
		    EndIf
		    */
			If aScan(aDuplItPC, _cCodProd+DTOS(_dDtEnt) ) == 0 //Ita - 23/05/2019
			   aAdd(aDuplItPC, _cCodProd+DTOS(_dDtEnt) )
				If _nQtdPC > 0 //Ita - 29/05/2019
				   RecLock(cArqTrab, .F.)
				   //Alert("Entrei aqui - 2)")
				   Replace TRB_OK with oMrkBrowse:Mark()
				   MsUnLock()
				   //MsgInfo("Último RecNo Anterior: "+Alltrim(Str(_nRcNoTRB)))
				   /*
				   If (cArqTrab)->(RecNo()) > _nRcNoTRB //Ita - 27/06/2019 - Guarda o último recno selecionada da tabela temporária para posicioná-lo na entrada da tela.
				      _nRcNoTRB := (cArqTrab)->(RecNo())
				      //MsgInfo("Último RecNo NOVO: "+Alltrim(Str(_nRcNoTRB)))
				   EndIf
				   */
				EndIf
				aadd(_aItemPC, { _cCodProd, _dDtEnt,  _nQtdPC,  _nPrcPC,  _nTotPC, "1"})
				//Ita - 29/05/2019 - deslocado acumulador para contar só item e não item+data - _nItemSel++
				_nTotal += _nTotPC
				//_nValPC += _nTotPC //Ita - 29/05/2019
				//Ita - 29/05/2019 - NÃO RETIRAR! - POIS, RETIRANDO DEU PROBLEMA NA SELEÇÃO DO PEDIDO ANTERIOR /* Ita - 28/05/2019 - Evitar alterar a data de inclusão do pedido
				dbSelectArea("SZ1")
				RecLock("SZ1",.F.)
				//Replace Z1_DTINCL with (cAliasTMP)->TMP_DTINCL //dDataBase    //Ita - 15/05/2019 - Isso está certo???
				Replace Z1_DTINCL with If((_nOpcCont == 2),dDataBase,If(Empty((cAliasTMP)->TMP_DTINCL),dDataBase,(cAliasTMP)->TMP_DTINCL)) //Ita - 20/05/2019
				MsUnLock()
				//  */
			EndIf
		Endif
	EndIf
Next
//_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
//fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) //Ita - 29/05/2019
RestArea(_aArea)
_oItemSel:Refresh()
_oValPC:Refresh()
//Ita - 07/06/2019 - oMrkBrowse:oBrowse:UpdateBrowse()
//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh(.t.)
//lGoTop := .F. 
//oMrkBrowse:Refresh(lGoTop)
oMrkBrowse:Refresh(.F.) //Ita - 12/06/2019
//_oMRKDown:Refresh(.t.)						// Fazendo o Refresh do Browse
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
Return

//-----------------------
//
Static Function RestKey(_cParam, cArqTrab)

If _cParam == "0"
	SetKey( VK_F2 , { || NIL } )
	SetKey( VK_F4 , { || NIL } )
	//MsgInfo("1. Desabilitei função F4") //Ita - 25/06/2019
	SetKey( VK_F5 , { || NIL } )
	SetKey( VK_F6 , { || NIL } )
	SetKey( VK_F7 , { || NIL } )
	SetKey( VK_F8 , { || NIL } )
	SetKey( VK_F9 , { || NIL } )
	SetKey( VK_F10 , { || NIL } )//Ita - 16/04/2019 - Impressãp da Tela de Consumo
	SetKey( VK_F11, { || NIL } )
Else
	SetKey( VK_F2  , { || ANTela_G() } )
	SetKey( VK_F4  , { || RestKey("0"), ANItemPC((cArqTrab)->TRB_COD), 	RestKey("1", cArqTrab) } )
	SetKey( VK_F5  , { || RestKey("0"), ANConKard((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } )
	//Ita - 28/06/2019 - SetKey( VK_F6  , { || RestKey("0"), ANPrdSim((cArqTrab)->TRB_COD), 	RestKey("1", cArqTrab) } )
	SetKey( VK_F6  , { || RestKey("0"), ANPrdSim((cArqTrab)->TRB_COD,aStru), 	RestKey("1", cArqTrab) } ) //Ita - 28/06/2019 - acrescentado aStru para facilitar apresentação dos similares
	SetKey( VK_F7  , { || RestKey("0"), ANPrdApl((cArqTrab)->TRB_COD), 	RestKey("1", cArqTrab) } )
	SetKey( VK_F8  , { || RestKey("0"), ANCOnDem((cArqTrab)->TRB_COD), 	RestKey("1", cArqTrab) } )
	SetKey( VK_F9  , { || RestKey("0"), ANPesqCod(oMrkBrowse, cArqTrab,_cPrdPos), RestKey("1", cArqTrab) } ) //Ita - Preencher Código do último Produto digitado  na Pesquisa - Solicitação Gustavo - SetKey( VK_F9  , { || RestKey("0"), ANPesqCod(oMrkBrowse, cArqTrab)		 , 	RestKey("1", cArqTrab) } )
	SetKey( VK_F10  , { || RestKey("0"), fPrtConsumos(cArqTrab), 	    RestKey("1", cArqTrab) } )//Ita - 16/04/2019 - Impressãp da Tela de Consumo	
	SetKey( VK_F11 , { || RestKey("0"), ANItBlq(cArqTrab), 				RestKey("1", cArqTrab) } )
	
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Calc_Curv(_cMarcABC, _dDataIni, _dDataFim, _cVlQT, cFilSelABC, _nCurvA, _nCurvB, _nCurvC, _nCurvD )

Local _aArea	:= GetArea()
Local _nTotReg	:= 0
Local _cQuery
Local _nTotABC  := 0
Local _nSomaCv := 0
Local cAliasSD2 := "QRYSD2"
Local _aProdABC	:= {}
Local _lCurvaA := .T.
Local _lCurvaB := .F.
Local _lCurvaC := .F.
Local _lCurvaD := .F.
Default _nCurvA   := SuperGetMv("AN_CURVAA",.F.,60)
Default _nCurvB   := SuperGetMv("AN_CURVAB",.F.,20) //Ita - 10/07/2019 - 25)
Default _nCurvC   := SuperGetMv("AN_CURVAC",.F.,15) //Ita - 10/07/2019 - 10)
Default _nCurvD   := SuperGetMv("AN_CURVAD",.F.,5)
Default _cVlQT := "V"
Default _cMarcABC := " "
Default _dDataIni := Ctod("  /  /  ")
Default _dDataFim := Ctod("  /  /  ")
//Ita - 30/05/2019 - Default cFilSelABC  := "('"+ xFilial("SD2") + "')"
Default cFilSelABC  := "('"+ cFilAnt + "')"
_Enter     := chr(13) + Chr(10) //Ita - 01/04/2019

//Default _dDataIni := Ctod("01/" + Substr(aPCRev[27],1,2) + "/" + Substr(aPCRev[27],3,2))
//Default _dDataFim := LastDay(Ctod("01/" + Substr(aPCRev[28],1,2) + "/" + Substr(aPCRev[28],3,2)))

If !Empty(_cMarcABC) .and. !Empty(_dDataIni) .and. !Empty(_dDataFim)
    //Ita - 09/04/2019 - Agrupamento de produtos pelo código mestre - B1_XALTIMP
    //MsgInfo("Meses para Curva Inicio "+DTOC(_dDataIni)+" Fim "+DTOC(_dDataFim))
	_cQuery := "SELECT B1_XALTIMP D2_COD, SUM(D2_QUANT) D2_QUANT" + _Enter
	_cQuery += "  FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 " + _Enter
	_cQuery += " WHERE D2_FILIAL IN " + cFilSelABC + ""  + _Enter
	_cQuery += "   AND D2_EMISSAO >= '" + Dtos(_dDataIni) + "'" + _Enter
	_cQuery += "   AND D2_EMISSAO <= '" + Dtos(_dDataFim) + "'" + _Enter
	_cQuery += "   AND D2_TIPO = 'N'" + _Enter
	_cQuery += "   AND D2_LOCAL = '01'" + _Enter
	_cQuery += "   AND SD2.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += "   AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	_cQuery += "   AND B1_XMARCA = '" + _cMarcABC + "'" + _Enter
	_cQuery += "   AND B1_MSBLQL <> '1'" + _Enter
	_cQuery += "   AND SB1.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += "   AND B1_COD = D2_COD" + _Enter
	_cQuery += "   AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
	//_cQuery += "   AND F4_FILIAL = '" + cFilAnt + "'" + _Enter
	_cQuery += "   AND D2_TES = F4_CODIGO" + _Enter
	_cQuery += "   AND F4_TRANFIL <> '1'" + _Enter
	_cQuery += "   AND F4_ESTOQUE = 'S'" + _Enter
	_cQuery += "   AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
	_cQuery += "   AND SF4.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " GROUP BY B1_XALTIMP"  + _Enter //D2_COD"
	_cQuery += " UNION" + _Enter
	_cQuery += " SELECT B1_XALTIMP D2_COD, SUM(0) D2_QUANT "  + _Enter//B1_COD D2_COD, 0 D2_QUANT "
	_cQuery += "   FROM " + RetSqlName("SB1") + " SB1 " + _Enter
	_cQuery += "  WHERE B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	_cQuery += "    AND B1_XMARCA = '" + _cMarcABC + "'" + _Enter
	_cQuery += "    AND B1_MSBLQL <> '1'" + _Enter
	_cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + _Enter
	_cQuery += "  GROUP BY B1_XALTIMP" + _Enter
	_cQuery += "  ORDER BY 1 " + _Enter
	Memowrite("C:\TEMP\ATU_PC_Calc_Curv.SQL",_cQuery)  //Ita - 02/04/2019 
	Memowrite("\Data\ATU_PC_Calc_Curv.SQL",_cQuery)  //Ita - 06/06/2019
	_cQuery := ChangeQuery(_cQuery)
	//		Memowrite("C:\walter\queryProd.txt",_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSD2,.T.,.T.)
	dbSelectArea(cAliasSD2)
	ProcRegua(_nTotReg)
	While !Eof()
		_cCodABC := (cAliasSD2)->D2_COD
		_nQtdABC := 0
		IncProc()
		While !Eof() .and. _cCodABC == (cAliasSD2)->D2_COD
			_nQtdABC += (cAliasSD2)->D2_QUANT
			dbSkip()
		End
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+_cCodABC)
		_nTotal := _nQtdABC * SB1->B1_UPRC
		If _cVlQT == "V"
			_nTotABC:= _nTotABC + _nTotal
		Else
			_nTotABC:= _nTotABC + _nQtdABC
		Endif
		aadd(_aProdABC, {_cCodABC, _nQtdABC, SB1->B1_UPRC, _nTotal, 0, " "})
		dbSelectArea(cAliasSD2)
	End
	dbSelectArea(cAliasSD2)
	dbCloseArea()
	RestArea(_aArea)
	For nT:=1 to Len(_aProdABC)
		IncProc()
		If _cVlQT == "V"
			_aProdABC[nT,5] := (_aProdABC[nT,4] / _nTotABC) * 100
		Else
			_aProdABC[nT,5] := (_aProdABC[nT,2] / _nTotABC) * 100
		Endif
	Next
	_aProdABC := ASort(_aProdABC,,, { | x,y | x[5] > y[5] })

	For nT:=1 to Len(_aProdABC)
		IncProc()
		_nSomaCv := _nSomaCv + _aProdABC[nT, 5]
		If _lCurvaA
			_aProdABC[nT,6] := "A"
			If _nSomaCv >= _nCurvA
				_lCurvaA := .F.
				_lCurvaB := .T.
				_nSomaCv := 0
			Endif
		ElseIf _lCurvaB
			_aProdABC[nT,6] := "B"
			If _nSomaCv >= _nCurvB
				_lCurvaB := .F.
				_lCurvaC := .T.
				_nSomaCv := 0
			Endif
		ElseIf _lCurvaC
			_aProdABC[nT,6] := "C"
			If _nSomaCv >= _nCurvC
				_lCurvaC := .F.
				_lCurvaD := .T.
				_nSomaCv := 0
			Endif
		Else
			_aProdABC[nT,6] := "D"
		Endif
	Next
/*
	For nT:=1 to Len(_aProdABC)
		IncProc()
		_nSomaCv := _aProdABC[nT, 5]
		If _nSomaCv >= _nCurvA
			_aProdABC[nT,6] := "A"
		ElseIf _nSomaCv >= _nCurvB
			_aProdABC[nT,6] := "B"
		ElseIf _nSomaCv >= _nCurvC
			_aProdABC[nT,6] := "C"
		Else
			_aProdABC[nT,6] := "D"
		Endif
	Next
*/
Endif
Return(_aProdABC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Calc_Sug(cArqTrab, aStru, _aProdABC,_ObjTRB) //Ita - 10/06/2019 - acrescentado variável _ObjTRB para tratar ordenação da tabela temporária.

Local _aArea	:= GetArea()
Local _oFINA7711
Local cAliasSB1 := "QRYSB1"
Local cAliasSD1 := "QRYSD1"
Local cAliasSC7 := "QRYSC7"
Local cAliasSD2 := "QRYSD2"

Local _nAnoFim  := Year(dDataBase)
Local _nMesFim  := Month(dDataBase)
Local _nMes01 	:= StrZero(Month(dDataBase),2)
Local _nAno01 	:= Year(dDataBase)
Local nPercRepr	:= 0
/*
Local _cIniDtpar := CTOD("01/"+Left(_cMesIni,2)+"/20"+Right(_cMesIni,2))
Local _cFimDtpar := CTOD("01/"+Left(_cMesFim,2)+"/20"+Right(_cMesFim,2))
Local _nAnoFim  := Year(_cIniDtpar)  //Year(dDataBase)
Local _nMesFim  := Month(_cFimDtpar)  //Month(dDataBase)
Local _nMes01 	:= StrZero(Month(_cIniDtpar),2)
Local _nAno01 	:= Year(_cIniDtpar)
*/
Local nH		:= 1
Local _nSldFil 	:= 0
Local _nSldPrc	:= 0
Local _dDiaIni  := dDataBase
Local _dDiaTri
Local _dDiaSem
Local _nI:=1
Local _cCurvaSel := ""
Local _nAcCva := 0
Local _cFilProth	:= " "

_aMes		:= {}
_cMesVend 	:= " "
_cMesVTri 	:= " "
_aDiasTS := {}
aadd(_aMes,{"01","JAN"})
aadd(_aMes,{"02","FEV"})
aadd(_aMes,{"03","MAR"})
aadd(_aMes,{"04","ABR"})
aadd(_aMes,{"05","MAI"})
aadd(_aMes,{"06","JUN"})
aadd(_aMes,{"07","JUL"})
aadd(_aMes,{"08","AGO"})
aadd(_aMes,{"09","SET"})
aadd(_aMes,{"10","OUT"})
aadd(_aMes,{"11","NOV"})
aadd(_aMes,{"12","DEZ"})

////////////////////////////////////////////////////
/// Ita - 18/04/2019 
///       Guardar meses inicial e final do período
///       para modificar conceito de seleção e 
///       melhorar performance da query.
///       _dTMesIni e _dTMesFim
///       _dSMesIni e _dSMesFim

//Ita - 05/06/2019 - _dTMesIni := StrZero(_nAno01,4) + _nMes01 //Ita - 02/05/2019
//Ita - 05/06/2019 - _dSMesIni := StrZero(_nAno01,4) + _nMes01 //Ita - 02/05/2019
_cMIpar := "20"+Right(_cMesIni,2)+Left(_cMesIni,2)
_dTMesIni := _cMIpar //Ita - 05/06/2019
_dSMesIni := _cMIpar //Ita - 05/06/2019
aMsProc := {} //Ita - 19/06/2019 - Meses de Processamento
_nAcho := aScan(_aMes,{|x| AllTrim(x[1])==_nMes01})
If _nAcho > 0
	If Substr(_cMesCor,1,1) == "S"
		_cMesVend := "('" + StrZero(_nAno01,4) + _nMes01
		_cMesVTri := "('" + StrZero(_nAno01,4) + _nMes01
		_dTMesIni := StrZero(_nAno01,4) + _nMes01 //Ita - 18/04/2019 - Se considerar o mês corrente, guarda como inicial do período trimestral
		_dSMesIni := StrZero(_nAno01,4) + _nMes01 //Ita - 18/04/2019 - Se considerar o mês corrente, guarda como inicial do período semestral 
		If aScan(aMsProc,StrZero(_nAno01,4) + _nMes01) == 0
		   aAdd(aMsProc,StrZero(_nAno01,4) + _nMes01) //Ita - 19/06/2019 - Meses de Processamento
		EndIF
	Endif
	_cMes01 := _aMes[_nAcho,2]
Endif

For nH:=2 to If(Substr(_cMesCor,1,1) == "S",6, 7) //Ita - 06/06/2019 - Evitar acumule de mais mês
	If _nMesFim > 1
		_nMesFim := _nMesFim - 1
		_nMes&(Strzero(nH,2)) := StrZero(_nMesFim,2)
		_nAno&(Strzero(nH,2)) := Strzero(_nAnoFim,4)
		_nAcho := aScan(_aMes,{|x| AllTrim(x[1])==StrZero(_nMesFim,2)})
		If _nAcho > 0
			If Empty(_cMesVend)
				_cMesVend := "('"
			Else
				_cMesVend += "','"
			Endif
			If nH <= If(Substr(_cMesCor,1,1) == "N",4, 3) //Ita - 06/06/2019 - Evitar acumule de mais mês - //4 
				If Empty(_cMesVTri)
					_cMesVTri := "('"
				Else
					_cMesVTri += "','"
				Endif
			    If nH == 2 .And. Empty(Substr(_dTMesIni,2,3)) //Ita - 18/04/2019 - Se for o primeiro mês
			       _dTMesIni := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Mês inicial do período trimestral
			    EndIf
				_cMesVTri += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))
				//_cMesVend += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 05/06/2019
				_dTMesFim := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Sempre guarda o mês como final do período trimestral
				If aScan(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) == 0
				   aAdd(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) //Ita - 19/06/2019 - Meses de Processamento
				EndIf
			Endif
		    If nH == 2 .And. Empty(Substr(_cMesVend,2,3)) //Ita - 18/04/2019 - Se for o primeiro mês
		       _dSMesIni := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Mês inicial do período semestral 			
		    EndIf
			_cMesVend += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))
			_cMes&(Strzero(nH,2)) := _aMes[_nAcho,2]
			_dSMesFim := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Sempre guarda o mês como final do período semestral
			If aScan(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) == 0
			   aAdd(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) //Ita - 19/06/2019 - Meses de Processamento
			EndIf
		Endif
	Else
		_nAnoFim--
		_nMesFim := 12
		_nMes&(Strzero(nH,2)) := StrZero(_nMesFim,2)
		_nAno&(Strzero(nH,2)) := Strzero(_nAnoFim,4)
		_nAcho := aScan(_aMes,{|x| AllTrim(x[1])==StrZero(_nMesFim,2)})
		If _nAcho > 0
			If Empty(_cMesVend)
				_cMesVend := "('"
			Else
				_cMesVend += "','"
			Endif
			If nH <= If(Substr(_cMesCor,1,1) == "N",4, 3) //Ita - 06/06/2019 - Evitar acumule de mais mês - //4 
				If Empty(_cMesVTri)
					_cMesVTri := "('"
				Else
					_cMesVTri += "','"
				Endif
			    If nH == 2 .And. Empty(Substr(_dTMesIni,2,3)) //Ita - 18/04/2019 - Se for o primeiro mês
			       _dTMesIni := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Mês inicial do período trimestral
			    EndIf
				_cMesVTri += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))
				//_cMesVend += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 05/06/2019
				_dTMesFim := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Sempre guarda o mês como final do período trimestral
				If aScan(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) == 0
				   aAdd(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) //Ita - 19/06/2019 - Meses de Processamento
				EndIf
			Endif
		    If nH == 2 .And. Empty(Substr(_cMesVend,2,3)) //Ita - 18/04/2019 - Se for o primeiro mês
		       _dSMesIni := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Mês inicial do período semestral 			
		    EndIf
			_cMesVend += _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))
			_cMes&(Strzero(nH,2)) := _aMes[_nAcho,2]
			_dSMesFim := _nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2)) //Ita - 18/04/2019 - Sempre guarda o mês como final do período semestral
			If aScan(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) == 0
			   aAdd(aMsProc,_nAno&(Strzero(nH,2)) + _nMes&(Strzero(nH,2))) //Ita - 19/06/2019 - Meses de Processamento
			EndIf
		Endif
	Endif
Next
If Substr(_cMesCor,1,1) == "N"
	_dDiaIni := Ctod("01/"+_nMes02+"/" + _nAno02)
	_dDiaTri := Ctod("01/"+_nMes04+"/" + _nAno04)
	_dDiaSem := Ctod("01/"+_nMes07+"/" + _nAno07)
Else
	_dDiaTri := Ctod("01/"+_nMes03+"/" + _nAno03)
	_dDiaSem := Ctod("01/"+_nMes06+"/" + _nAno06)
Endif

aadd(_aDiasTS,LastDay(_dDiaIni) - _dDiaTri )
aadd(_aDiasTS,LastDay(_dDiaIni) - _dDiaSem)

If !Empty(_cMesVend)
	_cMesVend += "')"
Endif
If !Empty(_cMesVTri)
	_cMesVTri += "')"
Endif

For _nI:=23 to 26	// Curva ABC que podem ser digitadas na tela
	If !Empty(aPCRev[_nI])
		If Empty(_cCurvaSel)
			_cCurvaSel := aPCRev[_nI]
		Else
			_cCurvaSel += "/"
			_cCurvaSel += aPCRev[_nI]
		Endif
	Else
		Exit
	Endif
Next

Aadd(aStru, {"TRB_OK"		,"C",2						,0					, "OK"			, 20, " "})
Aadd(aStru, {"TRB_BLQ"		,"C",1						,0					, "BLOQUEADO"	, 20, " "})
Aadd(aStru, {"TRB_PRECO"	,"N",TAMSX3("B1_UPRC")[1]	,TAMSX3("B1_UPRC")[2], "PRECO"		, 20, "@E 999,999"})
Aadd(aStru, {"TRB_TOTAL"	,"N",TAMSX3("D2_TOTAL")[1]	,TAMSX3("D2_TOTAL")[2], "TOTAL"		, 20, "@E 999,999"})
Aadd(aStru, {"TRB_COD"		,"C",TAMSX3("B1_COD")[1]	,0					, "CODIGO"		, 100, " "})
Aadd(aStru, {"TRB_PED"		,"N",6						,0					, "PEND"		, 50, "@E 999,999"})
//Ita - 08/04/2019 - Aumentar exibição do campo na tela - Aadd(aStru, {"TRB_COBERT"	,"C",7						,0					, "COB."		, 50, " "})
Aadd(aStru, {"TRB_COBERT"	,"C",10						,0					, "COB."		, 70, "@!"}) //Ita - 18/06/2019 - acrescentado @! na picture, antes estava em branco.
Aadd(aStru, {"TRB_SUG"		,"N",6						,0					, "SUG."		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_CLASSE"	,"C",1						,0					, "CL"			, 30, " "})
Aadd(aStru, {"TRB_DESC"		,"C",TAMSX3("B1_DESC")[1]	,0					, "DESCRICAO"	, 150, " "})
Aadd(aStru, {"TRB_SALD1"	,"N",6						,0					, "SALDO 1"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_SALD2"	,"N",6						,0					, "SALDO 2"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES07"	,"N",6						,0					, _cMes07		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES06"	,"N",6						,0					, _cMes06		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES05"	,"N",6						,0					, _cMes05		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES04"	,"N",6						,0					, _cMes04		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES03"	,"N",6						,0					, _cMes03		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES02"	,"N",6						,0					, _cMes02		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MES01"	,"N",6						,0					, _cMes01		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MEDTRI"	,"N",6						,0					, "TRIMES"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_MEDSEM"	,"N",6						,0					, "SEMES"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_DATA1"	,"D",8						,0					, "DATA 1"		, 80, " "})
Aadd(aStru, {"TRB_QTD1"		,"N",6						,0					, "QTDE 1"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_DATA2"	,"D",8						,0					, "DATA 2"		, 80, " "})
Aadd(aStru, {"TRB_QTD2"		,"N",6						,0					, "QTDE 2"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_DATA3"	,"D",8						,0					, "DATA 3"		, 80, " "})
Aadd(aStru, {"TRB_QTD3"		,"N",6						,0					, "QTDE 3"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_FATEMB"	,"N",10						,0					, "FATEMB"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_COBPEN"	,"N",10						,0					, "COBPEN"		, 50, "@E 999,999"})
Aadd(aStru, {"TRB_PERC"		,"C",9						,0					, "VALPERC"		, 50, "@E 999,999,999"}) 	// Alterado 20/06/19 Rotta

//Ita - 18/06/2019 -  */
If _oFINA7711 <> Nil
	_oFINA7711:Delete()
	_oFINA7711	:= Nil
EndIf

//Cria o Objeto do FwTemporaryTable
_oFINA7711 := FwTemporaryTable():New(cArqTrab)

//Cria a estrutura do alias temporario
_oFINA7711:SetFields(aStru)

//Adiciona o indicie na tabela temporaria
_oFINA7711:AddIndex("1",{"TRB_COD"})
_oFINA7711:AddIndex("2",{"TRB_CLASSE", "TRB_PERC"})	// Alterado 20/06/19 Rotta

//////////////////////////////////////////////////////////
/// Ita - 21/05/2019
///     - Novas opções de índices do arquivo de trabalho
//Ita - 18/06/2019
/*
_oFINA7711:AddIndex("3",{"TRB_MEDTRI"})
_oFINA7711:AddIndex("4",{"TRB_MEDSEM"})
_oFINA7711:AddIndex("5",{"TRB_VALTRI"})
_oFINA7711:AddIndex("6",{"TRB_VALSEM"})
*/
//Criando a Tabela Temporaria
_oFINA7711:Create()

//_cQuery := "SELECT COUNT(*) REG " + _Enter
_cQuery := "SELECT COUNT(*) REG FROM (" + _Enter
_cQuery += "SELECT B1_FILIAL,B1_XALTIMP " + _Enter
_cQuery += " FROM " + RetSqlName("SB1") + " SB1" + _Enter
_cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
If !Empty(aPCRev[19])
	_cQuery += " AND B1_XALTIMP = '" + aPCRev[19] + "'" + _Enter
Endif
If !Empty(aPCRev[13])
	_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
Endif	
_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
If aPCRev[33] == "1"	// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
	_cQuery += " AND B1_UCOM <> '        '" + _Enter
ElseIf aPCRev[33] == "2"
	_cQuery += " AND B1_UCOM = '        '" + _Enter
Endif
_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.

_cQuery += " AND D_E_L_E_T_ = ' '" + _Enter
_cQuery += " GROUP BY SB1.B1_FILIAL,SB1.B1_XALTIMP) TAB_B1" + _Enter //Ita - 09/04/2019 - Implementado tratamento para agrupar produtos pelo código mestre através do campo B1_XALTIMP.
MemoWrite("C:\TEMP\ATU_PC_cAliasSB1.SQL",_cQuery) //Ita - 02/04/2019
MemoWrite("\Data\ATU_PC_cAliasSB1.SQL",_cQuery) //Ita - 02/04/2019
_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSB1,.T.,.T.)
dbSelectArea(cAliasSB1)
_nTotReg := (cAliasSB1)->REG
dbSelectArea(cAliasSB1)
dbCloseArea()
If _nTotReg > 0
	ProcRegua(_nTotReg)
///       _dTMesIni e _dTMesFim
///       _dSMesIni e _dSMesFim

	//Ita - 18/04/2019 - MsgInfo("Meses - _cMesVTri: "+_cMesVTri+" _dTMesIni: "+_dTMesIni+" e _dTMesFim: "+_dTMesFim+" _cMesVend: "+_cMesVend+" _dSMesIni: "+_dSMesIni+" e _dSMesFim: "+_dSMesFim)
	/*
	If Substr(aPCRev[35],1,1) == "T"
		MsgInfo("Movimento TRIMESTRAL _cMesVTri: "+_cMesVTri)
	Else
		MsgInfo("Movimento SEMESTRAL _cMesVend: "+_cMesVend)
	Endif
	*/
	

	//Ita - 09/04/2019 - Agrupamento código mestre - B1_XALTIMP - _cQuery := "SELECT D2_COD, SUM(D2_QUANT) D2_QUANT" + _Enter

	/*
	If !fTemMov()
	   Alert("Não existe movimento no perído "+If(Substr(aPCRev[35],1,1) == "T","Trimestral","Semestral")+" informado: "+If(Substr(aPCRev[35],1,1) == "T",_cMesVTri,_cMesVend))
	   Return
	EndIf

	*/

	//Ita - 19/06/2019 - Trata meses para processamento para apresentar mês corrente mesmo que não tenha sido selecionado.
	_cMesAtual := Substr(DTOS(dDataBase),1,6)
	//MsgInfo("Substr(_cMesCor,1,1): "+Substr(_cMesCor,1,1))
	If Substr(_cMesCor,1,1) <> "S" //Se não considerar o Mês corrente
	    //MsgInfo("Não Considera Mês atual")
		If aScan(aMsProc,_cMesAtual) == 0
		   _cMsesPrc  := "('"+_cMesAtual+"',"
		   For nMs := 1 To Len(aMsProc) 
		      _cMsesPrc  += +"'"+aMsProc[nMs]+"'"+If(nMs<Len(aMsProc),",","")
		   Next nMs
		   _cMsesPrc  += ")"
			If Substr(aPCRev[35],1,1) == "T"
				_cMesVTri := _cMsesPrc
				//MsgInfo("CÁLCULO TRIMESTRAL - _cMesVTri: ["+_cMesVTri+"] _cMsesPrc : ["+_cMsesPrc+"]")
			Else
				_cMesVend := _cMsesPrc
				//MsgInfo("CÁLCULO SEMESTRAL - _cMesVTri: ["+_cMesVend+"] _cMsesPrc : ["+_cMsesPrc+"]")
			Endif
		EndIf
	EndIf
	
	_cQuery := "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
	_cQuery += "       SUM(D2_QUANT) D2_QUANT" + _Enter
	_cQuery += "  FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SF4") + " SF4 " + _Enter
	_cQuery += " WHERE D2_FILIAL IN " + _cFilSel + "" + _Enter
	If Substr(aPCRev[35],1,1) == "T"
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVTri + "" + _Enter //Ita - 06/06/2019
	Else
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVend + "" + _Enter
	Endif
	//_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVTri + "" + _Enter //Ita - 06/06/2019
	_cQuery += " AND SD2.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " AND D2_COD = B1_COD " + _Enter
	_cQuery += " AND D2_LOCAL = '01'" + _Enter
	_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
	//_cQuery += " AND F4_FILIAL = '" + cFilAnt + "'" + _Enter
	_cQuery += " AND D2_TES = F4_CODIGO " + _Enter
	_cQuery += " AND F4_TRANFIL <> '1' " + _Enter
	_cQuery += " AND F4_ESTOQUE = 'S' " + _Enter
	_cQuery += " AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "	 + _Enter
	_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	If !Empty(aPCRev[19])
		_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
	Endif
	If !Empty(aPCRev[13])
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
	Endif	
	_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
	If aPCRev[33] == "1"		// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
		_cQuery += " AND B1_UCOM <> '        '" + _Enter
	ElseIf aPCRev[33] == "2"
		_cQuery += " AND B1_UCOM = '        '" + _Enter
	Endif
	_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.
	If !Empty(_cFilGrp)
		//Ita - 02/04/2019 - _cQuery += " AND B1_GRUPO IN " + _cFilGrp + ""  + _Enter
		_cQuery += " AND B1_XLINHA IN " + _cFilGrp + ""  + _Enter
	Endif
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " GROUP BY B1_XALTIMP,B1_XMESTRE,B1_XLINHA" + _Enter	

/*
	_cQuery += " UNION " + _Enter	
	_cQuery += " SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter	
	_cQuery +=  "       SUM(0) D2_QUANT " + _Enter
	_cQuery += "   FROM " + RetSqlName("SB1") + " SB1 " + _Enter
	_cQuery += "  WHERE B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	If !Empty(aPCRev[19])
		_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
	Endif
	If !Empty(aPCRev[13])
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
	Endif	
	_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
	If aPCRev[33] == "1"		// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
		_cQuery += " AND B1_UCOM <> '        '" + _Enter
	ElseIf aPCRev[33] == "2"
		_cQuery += " AND B1_UCOM = '        '" + _Enter
	Endif
	_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.
	If !Empty(_cFilGrp)
		//Ita - 02/04/2019 - _cQuery += " AND B1_GRUPO IN " + _cFilGrp + "" + _Enter
		_cQuery += " AND B1_XLINHA IN " + _cFilGrp + ""  + _Enter
	Endif
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '"  + _Enter 
	
	//Ita - 09/04/2019 - Agrupamento código mestre - _cQuery += " ORDER BY 1 " + _Enter
	_cQuery += " GROUP BY B1_XALTIMP,B1_XMESTRE" + _Enter
	
	_cQuery += " ORDER BY D2_COD " + _Enter
*/

    //César: 30/04/2021 - Incluindo as devoluções para abater

	_cQuery += " UNION " + _Enter	
	_cQuery += "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
	_cQuery += "       SUM(D1_QUANT * -1) D2_QUANT" + _Enter
	_cQuery += "  FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SF4") + " SF4 " + _Enter
	_cQuery += " WHERE D1_FILIAL IN " + _cFilSel + "" + _Enter
	If Substr(aPCRev[35],1,1) == "T"
		_cQuery += " AND SUBSTR(D1_DTDIGIT,1,6) IN " + _cMesVTri + "" + _Enter //Ita - 06/06/2019
	Else
		_cQuery += " AND SUBSTR(D1_DTDIGIT,1,6) IN " + _cMesVend + "" + _Enter
	Endif
	//_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVTri + "" + _Enter //Ita - 06/06/2019
	_cQuery += " AND SD1.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " AND D1_COD = B1_COD " + _Enter
	_cQuery += " AND D1_LOCAL = '01'" + _Enter
	_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
	//_cQuery += " AND F4_FILIAL = '" + cFilAnt + "'" + _Enter
	_cQuery += " AND D1_TES = F4_CODIGO " + _Enter
	_cQuery += " AND F4_TRANFIL <> '1' " + _Enter
	_cQuery += " AND F4_ESTOQUE = 'S' " + _Enter
	_cQuery += " AND D1_XOPER IN ('D6','D7')" + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "	 + _Enter
	_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	If !Empty(aPCRev[19])
		_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
	Endif
	If !Empty(aPCRev[13])
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
	Endif	
	_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
	If aPCRev[33] == "1"		// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
		_cQuery += " AND B1_UCOM <> '        '" + _Enter
	ElseIf aPCRev[33] == "2"
		_cQuery += " AND B1_UCOM = '        '" + _Enter
	Endif
	_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.
	If !Empty(_cFilGrp)
		//Ita - 02/04/2019 - _cQuery += " AND B1_GRUPO IN " + _cFilGrp + ""  + _Enter
		_cQuery += " AND B1_XLINHA IN " + _cFilGrp + ""  + _Enter
	Endif
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " GROUP BY B1_XALTIMP,B1_XMESTRE,B1_XLINHA" + _Enter	

	_cQuery += " UNION " + _Enter		
	_cQuery += " SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter	
	_cQuery +=  "       SUM(0) D2_QUANT " + _Enter
	_cQuery += "   FROM " + RetSqlName("SB1") + " SB1 " + _Enter
	_cQuery += "  WHERE B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	If !Empty(aPCRev[19])
		_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
	Endif
	If !Empty(aPCRev[13])
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
	Endif	
	_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
	If aPCRev[33] == "1"		// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
		_cQuery += " AND B1_UCOM <> '        '" + _Enter
	ElseIf aPCRev[33] == "2"
		_cQuery += " AND B1_UCOM = '        '" + _Enter
	Endif
	_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.
	If !Empty(_cFilGrp)
		//Ita - 02/04/2019 - _cQuery += " AND B1_GRUPO IN " + _cFilGrp + "" + _Enter
		_cQuery += " AND B1_XLINHA IN " + _cFilGrp + ""  + _Enter
	Endif
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '"  + _Enter 
	
	//Ita - 09/04/2019 - Agrupamento código mestre - _cQuery += " ORDER BY 1 " + _Enter
	_cQuery += " GROUP BY B1_XALTIMP,B1_XMESTRE" + _Enter
	
	_cQuery += " ORDER BY D2_COD " + _Enter


	MemoWrite("C:\TEMP\ATU_PC_cAliasSD2.SQL",_cQuery) //Ita - 01/04/2019
	MemoWrite("\Data\ATU_PC_cAliasSD2.SQL",_cQuery) //Ita - 01/04/2019
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSD2,.T.,.T.)
	//aProdDup := {}
	//lChkLinha := If(!Empty(_cFilGrp),.T.,.F.) //Ita - 18/04/2019 - Melhorar Performance
 	dbSelectArea(cAliasSD2)
	While (cAliasSD2)->(!Eof())
		 
		_cCodProd := (cAliasSD2)->D2_COD
		///////////////////////////////////////////////////////
		/// Ita - 18/04/2019
		///       Códigos deslocados para melhorar performance
        /*
		If lChkLinha
			If !((cAliasSD2)->B1_XLINHA $  _cFilGrp)
			   dbSelectArea(cAliasSD2)
			   DbSkip()
			   Loop
			EndIf
		Endif
		*/
		///////////////////////////////////////////////////////
		/// Ita - 11/04/2019
		///       Evitar tratamento do mesmo código de produto
		/*
		If aScan(aProdDup,_cCodProd) <> 0
		   aAdd(aProdDup,_cCodProd)
		   dbSelectArea(cAliasSD2)
		   DbSkip()
		   Loop
		EndIf
		*/
		_nQuant   := 0
		nPercRepr := 0		// Alterado 20/06/19 Rotta
		_cCurvaPrd := "D"
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+_cCodProd)
		IncProc()
		While !Eof() .and. _cCodProd == (cAliasSD2)->D2_COD
			_nQuant += (cAliasSD2)->D2_QUANT
			dbSelectArea(cAliasSD2)
			dbSkip()
		End
		
		_nAcCva := aScan(_aProdABC,{|x| x[1] == _cCodProd })
		If _nAcCva > 0
			_cCurvaPrd := _aProdABC[_nAcCva,6]
			nPercRepr  := Round(_aProdABC[_nAcCva,5],4) * 10000		// Alterado 20/06/19 Rotta
		Endif
		cPercCurva := StrZero(999999999 - nPercRepr, 9)		// Alterado 20/06/19 Rotta
		If aPCRev[33] == "1"  // Ja comprado
			If !Empty(SB1->B1_UCOM)
				If !(_cCurvaPrd $ _cCurvaSel)
					dbSelectArea(cAliasSD2)
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		_dEnt1  := Ctod("  /  /  ")
		_dEnt2  := Ctod("  /  /  ")
		_dEnt3  := Ctod("  /  /  ")
		_nEnt1	:= 0
		_nEnt2	:= 0
		_nEnt3	:= 0
		_nSldPrc := 0
		_nQtdPC	:= 0
		_nConsDia:= 0
		
		////////////////////////////////////////////
		/// Ita - 09/04/2019
		///     - Cálcula saldo pelo código mestre
		/*
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek("020101"+SB1->B1_COD+SB1->B1_LOCPAD)
			_nSldPrc := SaldoSB2()										//	Saldo 1 sempre Matriz
		Endif
		*/
		lTemCdMstr := .F.
		If SB1->B1_XMESTRE == "S" //(cAliasSD2)->MESTRE == "S" //Melhorar Performance
			lTemCdMstr := .T.
			aProdMestre := fAgrupMest(SB1->B1_COD)
			If aPCRev[01] == "001"		// Se matriz
				For nPrMst := 1 To Len(aProdMestre) //Ita - 20/06/2019
					dbSelectArea("SB2")
					dbSetOrder(1)
					If dbSeek("020101"+aProdMestre[nPrMst,1]+SB1->B1_LOCPAD)
						//_xSlMst := SaldoSB2()										//	Saldo 1 sempre Matriz  + FILIAL PE
						_xSlMst := SB2->(B2_QATU - B2_RESERVA)
						_nSldPrc += _xSlMst 
					Endif
					If dbSeek("020104"+aProdMestre[nPrMst,1]+SB1->B1_LOCPAD)
						//_xSlMst := SaldoSB2()										//	Saldo 1 sempre Matriz  + FILIAL PE
						_xSlMst := SB2->(B2_QATU - B2_RESERVA)
						_nSldPrc += _xSlMst 
					Endif
				Next nPrMst
			Else
				For nPrMst := 1 To Len(aProdMestre) //Ita - 20/06/2019
					dbSelectArea("SB2")
					dbSetOrder(1)
					If dbSeek("020101"+aProdMestre[nPrMst,1]+SB1->B1_LOCPAD)
						//_xSlMst := SaldoSB2()										//	Saldo 1 sempre Matriz + FILIAL PE
						_xSlMst := SB2->(B2_QATU - B2_RESERVA) 
						_nSldPrc += _xSlMst 
					Endif
					If dbSeek("020104"+aProdMestre[nPrMst,1]+SB1->B1_LOCPAD)
						//_xSlMst := SaldoSB2()										//	Saldo 1 sempre Matriz + FILIAL PE
						_xSlMst := SB2->(B2_QATU - B2_RESERVA) 
						_nSldPrc += _xSlMst 
					Endif
				Next nPrMst
			EndIf
			
		Else
			dbSelectArea("SB2")
			dbSetOrder(1)
			If aPCRev[01] == "001"		// Ita - 20/06/2019 - Se matriz
				If dbSeek("020101"+SB1->B1_COD+SB1->B1_LOCPAD)
					//_nSldPrc := SaldoSB2()										//	Saldo 1 sempre Matriz + FILIAL PE
					_nSldPrc +=  SB2->(B2_QATU - B2_RESERVA)
				Endif
				If dbSeek("020104"+SB1->B1_COD+SB1->B1_LOCPAD)
					//_nSldPrc := SaldoSB2()										//	Saldo 1 sempre Matriz + FILIAL PE
					_nSldPrc +=  SB2->(B2_QATU - B2_RESERVA)
				Endif
			Else
				If dbSeek("020101"+SB1->B1_COD+SB1->B1_LOCPAD)
					//_nSldPrc := SaldoSB2()					
					_nSldPrc +=  SB2->(B2_QATU - B2_RESERVA)     					//	Saldo 1 sempre Matriz  + FILIAL PE
				Endif
				If dbSeek("020104"+SB1->B1_COD+SB1->B1_LOCPAD)
					//_nSldPrc := SaldoSB2()					
					_nSldPrc +=  SB2->(B2_QATU - B2_RESERVA)     					//	Saldo 1 sempre Matriz  + FILIAL PE
				Endif
			EndIf
		EndIf 
		If aPCRev[01] == "001"		// Se matriz o Saldo 2 deve ser igual ao Saldo 1
			_nSldFil := _nSldPrc
		Else
			_lRet := u_B_FilANL(aPCRev[01], @_cFilProth)
			If _lRet
			    If SB1->B1_XMESTRE == "S" //Ita - 20/06/2019 - If lTemCdMstr 
				    aProdMestre := fAgrupMest(SB1->B1_COD)
                   _nSldFil := 0 
				   For nMst := 1 To Len(aProdMestre)
				      //If dbSeek(_cFilProth+SB1->B1_COD+SB1->B1_LOCPAD)
		              dbSelectArea("SB2")
		              dbSetOrder(1)			
				      If dbSeek(PadR(_cFilProth,6)+aProdMestre[nMst,1]+SB1->B1_LOCPAD)//+aProdMestre[nMst,2])
				         //_nSldFil := SaldoSB2()
				         _xSldMest := SaldoSB2() 
					     _nSldFil += _xSldMest
				      Endif
				   Next nMst
				Else
		           dbSelectArea("SB2")
		           dbSetOrder(1)
			       If dbSeek(PadR(_cFilProth,6)+SB1->B1_COD+SB1->B1_LOCPAD)
			          _nSldFil := SaldoSB2()
			       Endif
				EndIf
			Endif
		Endif
		If _nQuant > 0
			If Substr(aPCRev[35],1,1) == "T"
				_nConsDia:= _nQuant / _aDiasTS[1]
			Else
				_nConsDia:= _nQuant / _aDiasTS[2]
			Endif
			_nCobMin := _nConsDia * aPCRev[30]
			_nCobMax := _nConsDia * aPCRev[31]
			If aPCRev[33] == "1"	// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
				If _nSldPrc < _nCobMin
					dbSelectArea(cAliasSD2)
					Loop
				Endif
				If _nSldPrc > _nCobMax
					dbSelectArea(cAliasSD2)
					Loop
				Endif
			Endif
		Else
			_nConsDia:= 0
			_nCobMin := 0
			_nCobMax := 0
		Endif		
		If (aPCRev[33] == "1" .and. !Empty(SB1->B1_UCOM)) .or. (aPCRev[33] <> "1")
			//Ita - 09/04/2019 - Agrupamento código mestre - _cQuery := "SELECT D1_COD, D1_DTDIGIT, SUM(D1_QUANT) D1_QUANT"
			If Empty(_dEnt1) .or. Empty(_dEnt2) .or. Empty(_dEnt3)  //Ita - 18/04/2019 - Melhorar Performance

				_cQuery := "SELECT B1_XALTIMP D1_COD, D1_DTDIGIT,SUM(D1_QUANT) D1_QUANT" + _Enter
				_cQuery += "  FROM " + RetSqlName("SD1") + " SD1, " + RetSQLname("SB1")+" SB1," + RetSqlName("SF4") + " SF4 " + _Enter
				//Ita - 30/05/2019 - _cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "'" + _Enter
				_cQuery += " WHERE D1_FILIAL = '" + cFilAnt + "'"  + _Enter
				//_cQuery += "   AND D1_COD = '" + SB1->B1_COD + "'" + _Enter
				_cQuery += "   AND D1_COD IN (SELECT B1_COD FROM SB1010  WHERE B1_XALTIMP = '"+ SB1->B1_COD +"' ) " + _Enter
				_cQuery += "   AND SUBSTR(D1_FILIAL,1,4) = SUBSTR(SB1.B1_FILIAL,1,4) " + _Enter
				_cQuery += "   AND D1_COD = SB1.B1_COD " + _Enter
				_cQuery += "   AND D1_LOCAL = '01' " + _Enter
				_cQuery += "   AND SD1.D_E_L_E_T_ = ' '" + _Enter
				_cQuery += "   AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
				//_cQuery += "   AND F4_FILIAL = '" + cFilAnt + "'" + _Enter
				_cQuery += "   AND D1_TES = F4_CODIGO" + _Enter
				_cQuery += "   AND F4_TRANFIL <> '1'" + _Enter
				_cQuery += "   AND F4_ESTOQUE = 'S'" + _Enter
				//_cQuery += "   AND D1_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
				// Cesar
				_cQuery += "   AND D1_XOPER IN ('01','05')" + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
				//_cQuery += "   AND D1_XOPER IN ('ZD','ZD')" + _Enter
				_cQuery += "   AND SF4.D_E_L_E_T_ = ' '" + _Enter
				_cQuery += "   AND SB1.D_E_L_E_T_ = ' '" + _Enter
				_cQuery += "   AND SD1.D_E_L_E_T_ = ' '" + _Enter
				//_cQuery += "   AND ROWNUM <= 3" + _Enter
				_cQuery += " GROUP BY B1_XALTIMP,D1_DTDIGIT" + _Enter
				_cQuery += " ORDER BY D1_DTDIGIT DESC" + _Enter

				MemoWrite("C:\TEMP\ATU_PC_cAliasSD1.SQL",_cQuery) //Ita - 02/04/2019
				MemoWrite("\Data\ATU_PC_cAliasSD1.SQL",_cQuery) //Ita - 05/06/2019
				_cQuery := ChangeQuery(_cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSD1,.T.,.T.)
				dbSelectArea(cAliasSD1)
				DbGoTop()
				While !Eof()
					//Ita - 18/04/2019 - Melhorar Performance - If Empty(_dEnt1) .or. Empty(_dEnt2) .or. Empty(_dEnt3)
						If Empty(_dEnt1)
							_dEnt1 := Stod((cAliasSD1)->D1_DTDIGIT)
							_nEnt1 := (cAliasSD1)->D1_QUANT
						ElseIf Empty(_dEnt2)
							_dEnt2 := Stod((cAliasSD1)->D1_DTDIGIT)
							_nEnt2 := (cAliasSD1)->D1_QUANT
						ElseiF Empty(_dEnt3)
							_dEnt3 := Stod((cAliasSD1)->D1_DTDIGIT)
							_nEnt3 := (cAliasSD1)->D1_QUANT
						//Endif
						Else
							Exit
						Endif
					dbSelectArea(cAliasSD1)
					dbSkip()
				End
				dbSelectArea(cAliasSD1)
				dbCloseArea()
				
			EndIf
			
		Endif
		//Ita - 09/04/2019 - Agrupamento de produtos pelo código mestre - B1_XALTIMP
		_cQuery := "SELECT SUM(C7_QUANT - C7_QUJE) SALDOPC" + _Enter
		_cQuery += "  FROM " + RetSqlName("SC7") + " SC7 " + _Enter
		//Ita - 30/05/2019 - _cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'" + _Enter
		_cQuery += " LEFT JOIN " + RetSQLName("SB1")+" SB1 ON SUBSTR(C7_FILIAL,1,4) = SUBSTR(SB1.B1_FILIAL,1,4) AND C7_PRODUTO = SB1.B1_COD "
		_cQuery += " WHERE C7_FILIAL = '" + cFilAnt + "'" + _Enter
		_cQuery += "   AND C7_PRODUTO = '" + SB1->B1_COD + "'" + _Enter
		_cQuery += "   AND C7_RESIDUO = ' '" + _Enter
		//_cQuery += "   AND C7_FORNECE = '"+PadR(_cCodMarc,6)+"'" + _Enter //Ita - 19/06/2019 - Trazer pendencias apenas do fornecedor selecionado.
		_cQuery += "   AND C7_QUJE < C7_QUANT" + _Enter
		_cQuery += "   AND SC7.D_E_L_E_T_ = ' ' " + _Enter
		_cQuery += "   AND SB1.D_E_L_E_T_ = ' ' " + _Enter
		_cQuery += " GROUP BY SB1.B1_XALTIMP" + _Enter
		
		MemoWrite("C:\TEMP\atu_pc_cAliasSC7.SQL",_cQuery)//Ita - 02/04/2019
		_cQuery := ChangeQuery(_cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSC7,.T.,.T.)
		dbSelectArea(cAliasSC7)
		If !Eof()
			_nQtdPC := (cAliasSC7)->SALDOPC
		Endif
		////////////////////////////////////////////////
		/// Ita - 27/05/2019
		///     - Trata bloqueio de compras por filial.
		_cBlqPC:="N"  //Ita - 10/06/2019 - _cBlqPC:=""
		
		// Se o bloqueio for no Produto, bloqueia para todas asa filiais...

		IF ALLTRIM(_cCodProd) = 'SBC452J-025'
		  _cBlqPC:="N"
		ENDIF


		dbSelectArea("SB1")
		dbSetOrder(1)				
		If dbSeek(xFilial("SB1",cFilAnt)+_cCodProd)
		   _cBlqPC := If(SB1->B1_XBLQPC='1',"S",'N') //Cesar  - 3/09,2021
		EndIf

		If _cBlqPC = 'N'
			dbSelectArea("SBZ")
			dbSetOrder(1)
			
			If dbSeek(cFilAnt+_cCodProd)
			_cBlqPC := If(Empty(SBZ->BZ_XBLQPC),"N",SBZ->BZ_XBLQPC) //Ita - 10/06/2019 - SBZ->BZ_XBLQPC
			EndIf
		ENDIF
		
		dbSelectArea(cAliasSC7)
		dbCloseArea()
		dbSelectArea(cArqTrab)
		/////////////////////////
		/// Ita - 16/04/2019
		///       Array para guardar itens da sugestão e possibilitar apresentação dos mesmoS conforme critério estabelecido por consumos
		///       definidos na tela de parâmnetros
		_CurvasPar := _cCurva1 + "|" + _cCurva2 + "|" + _cCurva3 + "|" + _cCurva4
		If _cCurvaPrd $ _CurvasPar //Ita - 27/05/2019 - Tratamento para apresentar curvas de acordo com o que foi definido nos parâmetros. 
			If Left(_cEstZero,1) == "A" //Quanto ao saldo em estoque - Considera A-Ambos(Com ou Sem Estoque)
				RecLock(cArqTrab,.T.)
				Replace TRB_COD		with SB1->B1_COD,;
						TRB_DESC	with SB1->B1_DESC,;
						TRB_PRECO   with SB1->B1_UPRC,;
						TRB_BLQ		with _cBlqPC,;    //Ita - 27/05/2019 - Trata bloqueio por filial - SB1->B1_XBLQPC,;
						TRB_CLASSE  with _cCurvaPrd,;
						TRB_SALD1	with _nSldPrc,;
						TRB_SALD2	with _nSldFil,;
						TRB_PED		with _nQtdPC,;
						TRB_DATA1   with _dEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA1   with _dEnt1,;
						TRB_QTD1    with _nEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD1    with _nEnt1,;
						TRB_DATA2   with _dEnt2,;
						TRB_QTD2    with _nEnt2,;
						TRB_DATA3   with _dEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA3   with _dEnt3,;
						TRB_QTD3    with _nEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD3    with _nEnt3,;
						TRB_FATEMB  with SB1->B1_XEMBFOR,; //Ita - 18/06/2019 - SB1->B1_QE,; //Ita - 21/05/2019 - Acrescentado fator de embalagem
						TRB_PERC	with cPercCurva,;		// Alterado 20/06/19 Rotta
		                TRB_COBERT  with "0 / 0"                       //Ita - 18/06/2019
				MsUnLock(cArqTrab)
			Else
			   If Left(_cEstZero,1) == "S"      //Só considera produto zerados
			      If (_nSldPrc + _nSldFil) == 0 
						RecLock(cArqTrab,.T.)
						Replace TRB_COD		with SB1->B1_COD,;
								TRB_DESC	with SB1->B1_DESC,;
								TRB_PRECO   with SB1->B1_UPRC,;
								TRB_BLQ		with _cBlqPC,;    //Ita - 27/05/2019 - Trata bloqueio por filial - SB1->B1_XBLQPC,;
								TRB_CLASSE  with _cCurvaPrd,;
								TRB_SALD1	with _nSldPrc,;
								TRB_SALD2	with _nSldFil,;
								TRB_PED		with _nQtdPC,;
								TRB_DATA1   with _dEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA1   with _dEnt1,;
								TRB_QTD1    with _nEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD1    with _nEnt1,;
								TRB_DATA2   with _dEnt2,;
								TRB_QTD2    with _nEnt2,;
								TRB_DATA3   with _dEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA3   with _dEnt3,;
								TRB_QTD3    with _nEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD3    with _nEnt3,;
								TRB_FATEMB  with SB1->B1_XEMBFOR,; //Ita - 18/06/2019 - SB1->B1_QE,; //Ita - 21/05/2019 - Acrescentado fator de embalagem
								TRB_PERC	with cPercCurva,;		// Alterado 20/06/19 Rotta
				                TRB_COBERT  with "0 / 0"                       //Ita - 18/06/2019
						MsUnLock(cArqTrab)
			      EndIf
			   Else                             //Só considera produto com saldo em estoque maior que zero
			      If (_nSldPrc + _nSldFil) > 0
						RecLock(cArqTrab,.T.)
						Replace TRB_COD		with SB1->B1_COD,;
								TRB_DESC	with SB1->B1_DESC,;
								TRB_PRECO   with SB1->B1_UPRC,;
								TRB_BLQ		with _cBlqPC,;    //Ita - 27/05/2019 - Trata bloqueio por filial - SB1->B1_XBLQPC,;
								TRB_CLASSE  with _cCurvaPrd,;
								TRB_SALD1	with _nSldPrc,;
								TRB_SALD2	with _nSldFil,;
								TRB_PED		with _nQtdPC,;
								TRB_DATA1   with _dEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA1   with _dEnt1,;
								TRB_QTD1    with _nEnt3,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD1    with _nEnt1,;
								TRB_DATA2   with _dEnt2,;
								TRB_QTD2    with _nEnt2,;
								TRB_DATA3   with _dEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_DATA3   with _dEnt3,;
								TRB_QTD3    with _nEnt1,;                                          //Ita - 27/05/2019 - Alterar ordem dos dados - TRB_QTD3    with _nEnt3,;
								TRB_FATEMB  with SB1->B1_XEMBFOR,; //Ita - 18/06/2019 - SB1->B1_QE,; //Ita - 21/05/2019 - Acrescentado fator de embalagem
								TRB_PERC	with cPercCurva,;		// Alterado 20/06/19 Rotta
				                TRB_COBERT  with "0 / 0"                       //Ita - 18/06/2019
						MsUnLock(cArqTrab)
			      EndIf
			   EndIf
			EndIf			
		EndIf		
		dbSelectArea(cAliasSD2)
	End
	//MsgInfo("Sai do Laco cAliasSD2 ")
	dbSelectArea(cAliasSD2)
	dbCloseArea()
	RestArea(_aArea)	
	dbSelectArea(cArqTrab)
	//Ita - 10/06/2019 - dbsetorder(_nOrdTrab) //Ita - 29/05/2019
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
	dbGotop()
	If !Eof()
		Processa( {|lEnd| Calc_Cons(cArqTrab, aStru, _cMesVend, _aMes, _aDiasTS)}, "Aguarde...","Calculando Consumo...3/3", .T. )
	Else
		Help(" ",1,"NVAZIOPC",,"Não encontrado registros",4,,,,,,.F.)
	Endif
Endif


RestArea(_aArea)
_ObjTRB := _oFINA7711 //Ita - 10/06/2019 - Retornando objeto de trabalhao para tratar ordenação da tabela temporária
Return() 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Calc_Cons(cArqTrab, aStru, _cMesVend, _aMes, _aDiasTS)

Local _aArea := GetArea()
Local _nI := 1
Local _lRet := .t.
Local cAliasSD2 := "QRYSD2"
Local _nTotReg := 0
Local _nVarQCb := 0.00
Local _cFilProth	:= " "
//Ita - 19/06/2019 - Trata meses para processamento para apresentar mês corrente mesmo que não tenha sido selecionado.
_cMesAtual := Substr(DTOS(dDataBase),1,6)
//MsgInfo("Substr(_cMesCor,1,1): "+Substr(_cMesCor,1,1))
If Substr(_cMesCor,1,1) <> "S" //Se não considerar o Mês corrente
    //MsgInfo("Não Considera Mês atual")
	If aScan(aMsProc,_cMesAtual) == 0
	   _cMsesPrc  := "('"+_cMesAtual+"',"
	   For nMs := 1 To Len(aMsProc) 
	      _cMsesPrc  += +"'"+aMsProc[nMs]+"'"+If(nMs<Len(aMsProc),",","")
	   Next nMs
	   _cMsesPrc  += ")"
 	   _cMesVend := _cMsesPrc
	EndIf
EndIf
//MsgInfo("Passei do tratamento dos meses")
	
If !Empty(_cFilSel)
	//Ita - 09/04/2019 - Agrupamento de produtos pelo código mestre - B1_XALTIMP 
	For nPr := 1 To 2  //Ita - 19/06/2019 - Implementar régua de processamento
		If nPr == 1
		   _cQuery := "SELECT COUNT(*) QTREGPRC FROM (" + _Enter
		   _cQuery += "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
		   _cQuery +=  "      SUBSTR(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter		   
		Else 
			If Trim(TcGetDb()) = 'ORACLE'
				_cQuery := "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
				_cQuery +=  "      SUBSTR(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter
			Else
				_cQuery += "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
				_cQuery +=  "      SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter
			Endif
		EndIf
		_cQuery += " FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 " + _Enter
		_cQuery += " WHERE D2_FILIAL IN " + _cFilSel + "" + _Enter
		If Trim(TcGetDb()) = 'ORACLE'
			_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVend + "" + _Enter
		Else
			_cQuery += " AND SUBSTRING(D2_EMISSAO,1,6) IN " + _cMesVend + ""  + _Enter
		Endif
		_cQuery += " AND SD2.D_E_L_E_T_ = ' '" + _Enter
		_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
		If !Empty(aPCRev[19])
			_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
		Endif
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
		_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
		_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
		_cQuery += " AND B1_COD = D2_COD" + _Enter
		_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
		//_cQuery += " AND F4_FILIAL = '" + cFilAnt + "'" + _Enter
		_cQuery += " AND D2_TES = F4_CODIGO" + _Enter
		_cQuery += " AND F4_TRANFIL <> '1'" + _Enter
		_cQuery += " AND F4_ESTOQUE = 'S'" + _Enter
		_cQuery += " AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
		_cQuery += " AND D2_LOCAL = '01'" + _Enter
		_cQuery += " AND SF4.D_E_L_E_T_ = ' '" + _Enter
		If Trim(TcGetDb()) = 'ORACLE'
			_cQuery += " GROUP BY B1_XALTIMP, B1_XMESTRE, SUBSTR(D2_EMISSAO,1,6)" + _Enter
			_cQuery += " ORDER BY B1_XALTIMP, B1_XMESTRE, SUBSTR(D2_EMISSAO,1,6)" + _Enter
		Else 
			_cQuery += " GROUP BY B1_XALTIMP, B1_XMESTRE, SUBSTRING(D2_EMISSAO,1,6)" + _Enter
			_cQuery += " ORDER BY B1_XALTIMP, B1_XMESTRE, SUBSTRING(D2_EMISSAO,1,6)" + _Enter
		Endif
		If nPr == 1
		   _cQuery += " ) TAB " + _Enter //Ita - 19/06/2019
		EndIf
		MemoWrite("C:\TEMP\ATU_PC_XYcAliasSD2.SQL",_cQuery)
		MemoWrite("\DATA\ATU_PC_XYcAliasSD2.SQL",_cQuery)
		_cQuery := ChangeQuery(_cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSD2,.T.,.T.)
		   If nPr == 1
		      dbSelectArea(cAliasSD2)
		      nPrcRg := (cAliasSD2)->QTREGPRC
		      DbCloseArea()
		   EndIf
	Next nPr
	ProcRegua(nPrcRg)
	dbSelectArea(cAliasSD2)
	nCnt := 1
	//Ita - 19/06/2019 - ProcRegua(_nTotReg)
	While !Eof()
		IncProc("Calculando Consumos ... "+Alltrim(Str(nCnt))+" / "+Alltrim(Str(nPrcRg)))
		_cCod    := (cAliasSD2)->D2_COD
		_cLocal  := Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_LOCPAD")
		_cMestre := (cAliasSD2)->MESTRE
		/*
		If Alltrim(_cCod) == "136"
			_c:=1
		Endif
		*/
		/////////////////////////
		/// Ita - 16/04/2019
		///       Array para guardar itens da sugestão e possibilitar apresentação dos mesmo conforme critério estabelecido por consumos
		///       definidos na tela de parâmnetros		
		/**/
		dbSelectArea(cArqTrab)
		dbSetOrder(1)
		If dbSeek(_cCod)
			dbSelectArea(cAliasSD2)
			While !Eof() .and. _cCod == (cAliasSD2)->D2_COD
				_cAnoMes := (cAliasSD2)->ANOMES
				_nQuant  := (cAliasSD2)->D2_QUANT
				_cMes    := Substr(_cAnoMes,5,2)
				_nAcho   := aScan(_aMes,{|x| AllTrim(x[1])==_cMes})
				If _nAcho > 0
					_cTitulo := _aMes[_nAcho,2]
					_nAcho   := aScan(aStru,{|x| AllTrim(x[5])==_cTitulo})
					If _nAcho > 0
						_cCampo := aStru[_nAcho,1]
						dbSelectArea(cArqTrab)
						RecLock(cArqTrab,.F.)
						Replace &(_cCampo) with _nQuant
						MsunLock()
					Endif
				Endif
				dbSelectArea(cAliasSD2)
				dbSkip()
				nCnt ++
			End
			If Substr(_cMesCor,1,1) == "S"
				/* Ita - 19/06/2019
				_nMedia3 := INT(((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03)/ 3)
				_nMedia6 := INT(((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06) / 6)
				*/
				
				_nMedia3 := Round((((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03)/ 3),0)
				_nMedia6 := Round((((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06) / 6),0)
				
			Else
			    /* Ita - 19/06/2019
				_nMedia3 := INT(((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04)/ 3)
				_nMedia6 := INT(((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06 + (cArqTrab)->TRB_MES07) / 6)
				*/
				
				_nMedia3 := Round((((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04)/ 3),0)
				_nMedia6 := Round((((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06 + (cArqTrab)->TRB_MES07) / 6),0)
				
			Endif
			If Substr(aPCRev[35],1,1) == "T"
				If Substr(_cMesCor,1,1) == "S"
					//_nConsDia:= ((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03) / _aDiasTS[1]
					// Cesar - 30/04/21 : Alterei para o calculo usar 90 dias para calcular do consumo diario
					_nConsDia:= ((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03) / 90
				Else
					//_nConsDia:= ((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04) / _aDiasTS[1]
					// Cesar - 30/04/21 : Alterei para o calculo usar 90 dias para calcular do consumo diario
					_nConsDia:= ((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04) / 90
				Endif
			Else
				If Substr(_cMesCor,1,1) == "S"
				    // Cesar - 30/04/21 : Alterei para o calculo usar 180 dias para calcular do consumo diario
					//_nConsDia:= ((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06) / _aDiasTS[2]					
					_nConsDia:= ((cArqTrab)->TRB_MES01 + (cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06) / 180
				Else
				    // Cesar - 30/04/21 : Alterei para o calculo usar 180 dias para calcular do consumo diario					
					//_nConsDia:= ((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06 + (cArqTrab)->TRB_MES07) / _aDiasTS[2]
					_nConsDia:= ((cArqTrab)->TRB_MES02 + (cArqTrab)->TRB_MES03 + (cArqTrab)->TRB_MES04 + (cArqTrab)->TRB_MES05 + (cArqTrab)->TRB_MES06 + (cArqTrab)->TRB_MES07) / 180

				Endif
			Endif
			////////////////////////////////////////////
			/// Ita - 09/04/2019
			///     - Cálcula saldo pelo código mestre
			/*
			If SB2->(dbSeek(xFilial("SB2")+_cCod+_cLocal))
				_nSaldo := SaldoSB2()
			Else
				_nSaldo := 0
			Endif			
			*/

		   If _cMestre = "S" //(cAliasSD2)->MESTRE == "S"
				_nSaldo := 0
				aProdMestre := fAgrupMest(_cCod)

				dbSelectArea("SB2")
			    dbSetOrder(1)			

				For nSld := 1 To Len(aProdMestre)
					//Ita - 30/05/2019 - If SB2->(dbSeek(xFilial("SB2")+aProdMestre[nSld,1]+_cLocal))
					/*
					If SB2->(dbSeek(cFilAnt+aProdMestre[nSld,1]+_cLocal))
						_xSalMst := SaldoSB2() 
						_nSaldo += _xSalMst
					Else
						//_nSaldo := 0
						_nSaldo += 0
					Endif
					*/

					If aPCRev[01] == "001"		// Ita - 20/06/2019 - Se matriz
						If dbSeek("020101"+aProdMestre[nSld,1]+_cLocal)
							//_nSldPrc := SaldoSB2()								
							_nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
						Endif
						If dbSeek("020104"+aProdMestre[nSld,1]+_cLocal)
							//_nSldPrc := SaldoSB2()								
							_nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
						Endif
					Else
						_lRet := u_B_FilANL(aPCRev[01], @_cFilProth)
						If _lRet
							If dbSeek(PadR(_cFilProth,6)+aProdMestre[nSld,1]+_cLocal)
							   _nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
							Endif
						Endif
					EndIf

				Next nSld 
			Else
				//Ita - 30/05/2019 - If SB2->(dbSeek(xFilial("SB2")+_cCod+_cLocal))
				/*
				If SB2->(dbSeek(cFilAnt+_cCod+_cLocal))
					_nSaldo := SaldoSB2()
				Else
					_nSaldo := 0
				Endif			
				*/
				_nSaldo := 0

				dbSelectArea("SB2")
			    SB2->(dbSetOrder(1))


				If aPCRev[01] == "001"		// Ita - 20/06/2019 - Se matriz
					If dbSeek("020101"+_cCod+_cLocal)
						//_nSldPrc := SaldoSB2()								
						_nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
					Endif
					If dbSeek("020104"+_cCod+_cLocal)
						//_nSldPrc := SaldoSB2()								
						_nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
					Endif
				Else
					_lRet := u_B_FilANL(aPCRev[01], @_cFilProth)
					If _lRet
						If dbSeek(PadR(_cFilProth,6)+_cCod+_cLocal)
							_nSaldo +=  SB2->(B2_QATU - B2_RESERVA)
						Endif
					Endif
				EndIf

			EndIf
			      //    sugestão para (n) dias *(multiplicado) pelo consumo diário.
			/*
			_nQtdCob := aPCRev[32] * _nConsDia //Ita - 17/07/2019 - Comentado, pois variável não está mais sendo utilizada.
			MsgInfo("aPCRev[32]: "+Alltrim(Str(aPCRev[32]))+" _nQtdCob: "+Alltrim(Str(_nQtdCob)))
			_nQtdINT := INT(_nQtdCob)         
			_nDif    := _nQtdCob - _nQtdINT
			If _nDif > 0
				_nQtdCob := _nQtdINT + 1
			Endif
            */
			//Ita - 09/04/2019 - _nSugestao := _nQtdCob - _nSaldo
			
			//Ita - 09/07/2019 - _nSugestao := _nQtdCob - (cArqTrab)->TRB_PED - _nSaldo  //Ita- 09/04/2019 (Acrescentado(cArqTrab)->TRB_PED no cálculo da sugestão conf. Solicitação de Décio/Christiane)

			/////////////////////////////////
			/// Ita - 09/07/2019
			//      - Alterado conceito da fórmula de cálculo da sugestão, para fazer exatamente com é feito no ANL.
			//_nVarQCb := INT(aPCRev[32] / 30)//Ita - 17/07/2019 - Implementado a função INT() para evitar queda de performance, quando a sugestão for superior a 30dd e a quantidade resultar em número inferior a zero. 
			
			_nVarQCb := Round(aPCRev[32] / 30,2)

			If Substr(aPCRev[35],1,1) == "T"
				_nSugestao := Round(_nMedia3 * _nVarQCb,0) - (cArqTrab)->TRB_PED - _nSaldo
			Else
			   _nSugestao := Round(_nMedia6 * _nVarQCb,0) - (cArqTrab)->TRB_PED - _nSaldo
			EndIf
			/*
			If Alltrim((cArqTrab)->TRB_COD) == "021.0559"
			   cpare:=""
			EndIf
			*/
			_nDiasCob  := INT(_nSaldo / _nConsDia)
			_nDiaCobPd := INT((_nSaldo + (cArqTrab)->TRB_PED) / _nConsDia)      //Ita - 08/04/2019
			//Ita - 19/06/2019 - _nDiasCob  := Round((_nSaldo / _nConsDia),0)
			//Ita - 19/06/2019 - _nDiaCobPd := Round(((_nSaldo + (cArqTrab)->TRB_PED) / _nConsDia),0)      //Ita - 08/04/2019
			_cCobert := Alltrim(Str(_nDiasCob)) + " / " + Alltrim(Str(_nDiaCobPd))
			//_cCobert := If(Empty(_cCobert) .Or. Substr(_cCobert,1,3)=="   " ,"0 / 0",_cCobert) //Ita - 18/06/2019
			
			//////////////////////
			/// Ita - 29/03/2019
			///     - Guarda itens com sugestão para possibilitar geração do
			///       Pedido de Compras Automático.
			If (_nSugestao > 0)  //Se existir sugestão
			 //aadd(_aItemPC, { _cCodProd, _dDtEnt  ,  _nQtdPC  ,  _nPrcPC,  _nTotPC, "1"})
			   nTotItPA := _nSugestao * (cArqTrab)->TRB_PRECO 
            Else
               nTotItPA := 1 * (cArqTrab)->TRB_PRECO 
            EndIf //Ita - 25/07/2019 - Gravar média para todos os itens e não apenas os que tem sugestão   
               If Substr(_cTped,1,1) == "C" //Se for Compras - Ita - 10/07/2019
	               //////////////////////////
	               /// Ita - 14/06/2019
	               ///     - Tratamento do fator de embalagem
	               ///     - Espero sistema calcular a sugestão, em seguida
	               ///     - testa se item tem fator de embalagem, testa a seguir
	               ///     - se a quantidade sugerida é multipla do fator de
	               ///     - embalagem, por último, se não for múltipla, altera
	               ///     - quantidade para o primeiro múltiplo superior a 
	               ///     - quntidade sugerida.
				   nFtEmbal := Posicione("SB1",1,xFilial("SB1")+(carqtrab)->TRB_COD,"B1_XEMBFOR")//Itacolomy - 18/06/2019 - "B1_QE") 
				   If nFtEmbal > 0
				      /* 
					  César: 03/05/2021 - Calculando diretamente a sugestão considerando o fator de embalagem.
					  */

					  _nSugestao := (int(Round(_nSugestao/nFtEmbal,0)) * nFtEmbal)					  

					  /*
					  Suspenso, pois está executando até encontrar a sugestão e demorando muito
				      _lEMultFE := If(Mod(_nSugestao,nFtEmbal)==0,.T.,.F.)
				      If !_lEMultFE
				         lRoda := .T.
				          _nQtdMult := _nSugestao
	                     
						 While lRoda
	                        _nQtdMult ++ 
	                        If Mod( _nQtdMult,nFtEmbal)==0
	                           _nSugestao := _nQtdMult 
	                           lRoda := .F.
	                        EndIf
	                     EndDo 

				      EndIf
					  */
				   EndIf
			   EndIf

			dbSelectArea(cArqTrab)
			RecLock(cArqTrab,.F.)
			Replace TRB_MEDTRI with _nMedia3,;
			TRB_MEDSEM with _nMedia6,;
			TRB_SUG	   with _nSugestao,;
			TRB_COBERT with _cCobert,;
			TRB_COBPEN With _nDiaCobPd //Ita - 16/04/2019 - Grava cobertura somado a pendência para evitar apresentação de registros fora da especificação definida nos parâmetros iniciais.
			MsUnLock()
			   
			   //////////////////////////
			   /// Ita - 16/04/2019
			   ///       Só fará Pedido Automático caso atenda os critérios de Cobertura
			   ///       definido na tela de parâmetros
              //Ita - 15/05/2019 - Se cobertura de/Até for informada
               If _nCobDe + _nCobAte <> 0			   
			      If _nDiaCobPd <= _nCobAte //Se os dias de cobertura seja menor ou igual ao definido no parâmetro Cobertura
			         If !((cArqTrab)->TRB_BLQ == "S") //Ita - 14/06/2019 - Checa se produto não está bloqueado para comprar
				         aAdd(_aPCAuto, { (cArqTrab)->TRB_COD    ,dDataBase ,_nSugestao , (cArqTrab)->TRB_PRECO, nTotItPA, "1"})
				         If aScan(aMrkTRB,{|x| x[1] == (cArqTrab)->TRB_COD }) == 0 //Ita - 24/05/2019
				            //Ita - 18/06/2019 - aAdd(aMrkTRB, {(cArqTrab)->TRB_COD,1}) 
				            aAdd(aMrkTRB, {(cArqTrab)->TRB_COD,1,aPCRev[13],_xIncPC}) //Ita - 18/06/2019 -  - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
				         EndIf
			         EndIf
			      EndIf
			   Else
			      If !((cArqTrab)->TRB_BLQ == "S") //Ita - 14/06/2019 - Checa se produto não está bloqueado para comprar
				      aAdd(_aPCAuto, { (cArqTrab)->TRB_COD    ,dDataBase ,_nSugestao , (cArqTrab)->TRB_PRECO, nTotItPA, "1"})
				      
				      If aScan(aMrkTRB,{|x| x[1] == (cArqTrab)->TRB_COD }) == 0 //Ita - 24/05/2019
				         aAdd(aMrkTRB, {(cArqTrab)->TRB_COD,1,aPCRev[13],_xIncPC}) //Ita - 18/06/2019 -  - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
				      EndIf
			      EndIf
			   EndIf
			//Ita - 25/07/2019 - EndIf
			
			dbSelectArea(cAliasSD2)
		Else
			dbSelectArea(cAliasSD2)
			dbSkip()
			nCnt ++
		Endif
	End
	dbSelectArea(cAliasSD2)
	dbCloseArea()	
Endif
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSx1 ºAutor  ³Microsiga           º Data ³  01/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSx1(cPerg)

Local _aArea := GetArea()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Filial 01   ?","","","mv_ch1","C",03,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial 02   ?","","","mv_ch2","C",03,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Filial 03   ?","","","mv_ch3","C",03,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Filial 04   ?","","","mv_ch4","C",03,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Filial 05   ?","","","mv_ch5","C",03,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Filial 06   ?","","","mv_ch6","C",03,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Filial 07   ?","","","mv_ch7","C",03,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Filial 08   ?","","","mv_ch8","C",03,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Filial 09   ?","","","mv_ch9","C",03,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Filial 10   ?","","","mv_cha","C",03,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Tipo Pedido ?","","","mv_chb","C",01,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Cob.Fil.Ori ?","","","mv_chc","N",03,00,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Fornecedor  ?","","","mv_chd","C",06,00,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Linha 01    ?","","","mv_che","C",04,00,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Linha 02    ?","","","mv_chf","C",04,00,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Linha 03    ?","","","mv_chg","C",04,00,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Linha 04    ?","","","mv_chh","C",04,00,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Linha 05    ?","","","mv_chi","C",04,00,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Produto     ?","","","mv_chj","C",15,00,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Est c/Zero  ?","","","mv_chk","C",01,00,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"21","Preco       ?","","","mv_chl","C",01,00,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"22","Tab. Preco  ?","","","mv_chm","C",03,00,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"23","Curva 01    ?","","","mv_chn","C",01,00,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"24","Curva 02    ?","","","mv_cho","C",01,00,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"25","Curva 03    ?","","","mv_chp","C",01,00,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"26","Curva 04    ?","","","mv_chq","C",01,00,0,"G","","mv_par26","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"27","Mes INI     ?","","","mv_chr","C",04,00,0,"G","","mv_par27","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"28","Mes FIM     ?","","","mv_chs","C",04,00,0,"G","","mv_par28","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"29","Valor/Qtde  ?","","","mv_cht","C",01,00,0,"G","","mv_par29","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"30","Cob. Dias Ini ?","","","mv_chu","N",3,00,0,"G","","mv_par30","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"31","Cob. Dias Fim ?","","","mv_chv","N",3,00,0,"G","","mv_par31","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"32","Sug para dias ?","","","mv_chw","N",3,00,0,"G","","mv_par32","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"33","Sit. Prod   ?","","","mv_chx","C",01,00,0,"G","","mv_par33","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"34","Gera PC Aut.?","","","mv_chy","C",01,00,0,"G","","mv_par34","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"35","Media Cob.  ?","","","mv_chz","C",01,00,0,"G","","mv_par35","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"36","Origem      ?","","","mv_chh","C",03,00,0,"G","","mv_par36","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Tela_Dig(aStru, cArqTrab,aColumns)

Local _aArea		:= GetArea()
Local nOpc			:= 3
Local   Inclui       := .T.
Local   Altera       := .F.
Local   Exclui       := (nOpc == 5)
Local   bCampo       := {|nCPO| Field(nCPO) }
Local   lCommitDados := .F.
Local   lAchou       := .F.
Local   nItem, nItPr
Local nUsado    := 0
Local _cCodProd := (cArqTrab)->TRB_COD
Local _cDescPrd := (cArqTrab)->TRB_DESC
Local _nSaldo1  := (cArqTrab)->TRB_SALD1
Local _nSaldo2  := (cArqTrab)->TRB_SALD2
Local _nMes07   := (cArqTrab)->TRB_MES07
Local _nMes06   := (cArqTrab)->TRB_MES06
Local _nMes05   := (cArqTrab)->TRB_MES05
Local _nMes04   := (cArqTrab)->TRB_MES04
Local _nMes03   := (cArqTrab)->TRB_MES03
Local _nMes02   := (cArqTrab)->TRB_MES02
Local _nMes01   := (cArqTrab)->TRB_MES01
Local _nMedTri  := (cArqTrab)->TRB_MEDTRI
Local _nMedSem  := (cArqTrab)->TRB_MEDSEM
Local _nPenden  := (cArqTrab)->TRB_PED
Local _cCurva   := (cArqTrab)->TRB_CLASSE
Local _nSugest  := (cArqTrab)->TRB_SUG
Local _cCobert  := (cArqTrab)->TRB_COBERT
Local _dData1   := (cArqTrab)->TRB_DATA3                       //Ita - 27/05/2019 - Alterar ordem dos campos - (cArqTrab)->TRB_DATA1
Local _nQtde1   := (cArqTrab)->TRB_QTD3                        //Ita - 27/05/2019 - Alterar ordem dos campos - (cArqTrab)->TRB_QTD1
Local _dData2   := (cArqTrab)->TRB_DATA2
Local _nQtde2   := (cArqTrab)->TRB_QTD2
Local _dData3   := (cArqTrab)->TRB_DATA1                       //Ita - 27/05/2019 - Alterar ordem dos campos - (cArqTrab)->TRB_DATA3
Local _nQtde3   := (cArqTrab)->TRB_QTD1                        //Ita - 27/05/2019 - Alterar ordem dos campos - (cArqTrab)->TRB_QTD3
//Ita - 30/05/2019 - Local _cBloqSB1 := Posicione("SBZ",1,xFilial("SBZ")+_cCodProd,"BZ_XBLQPC") //Ita - 27/05/2019 - Trata bloqueio por filial - Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XBLQPC")
Local _cBloqSB1 := 'N' //Posicione("SBZ",1,cFilAnt+_cCodProd,"BZ_XBLQPC") //Ita - 27/05/2019 - Trata bloqueio por filial - Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XBLQPC")
Local _nQE		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XEMBFOR")//Ita - 18/06/2019 - "B1_QE")
Local _nPrecTab := 0
Local _nLinha   := -35
Local aHeader := {}
Local aCols   := {}
LOCAL aPosObj :={}
Local aSize		:= MsAdvSize(, .F., 430 )
Local aInfo		:= {}
Local aObjects	:= {}
Local _nAcho	:= 0
Local cAliasSZ1	:= "QRYSZ1"
Local _lMark	:= .F.
Local _lIniAcols := .T.
Local _lSubtrai := .T.

Private bDelOk	:= {|| fVlDelOk(n,_cCodProd) } //Ita - 20/05/2019 - Permitir exclusão da linha e replicar exclusão para todas as linhas do acols de mesda data de entrega.
Private nOpcx	:= nopc
Private lWhen   := nOpcx = 3 .Or. nOpcx = 4 .Or. nOpcx = 6
PRIVATE _cCodTelDg := _cCodProd
Private bAtuPC  := {||Sel_PCAnt(cArqTrab, @_aSZ1) }  //Ita - 23/05/2019
Private bAtuZ1  := {|| ATU_SZ1(cArqTrab, _aSZ1) }    //Ita - 23/05/2019
Private bCnfPC  := {|| Conf_PC() }    //Ita - 03/06/2019
_nRecTrb := (cArqTrab)->(Recno())                    //Ita - 23/05/2019  

dbSelectArea("SB1")
dbSetOrder(1)				
If dbSeek(xFilial("SB1")+_cCodProd)
	_cBloqSB1 := If(SB1->B1_XBLQPC='1',"S",'N') //Cesar  - 3/09,2021
EndIf

If _cBloqSB1 = 'N'
	dbSelectArea("SBZ")
	dbSetOrder(1)	
	If dbSeek(cFilAnt+_cCodProd)
  	  _cBloqSB1 := If(Empty(SBZ->BZ_XBLQPC),"N",SBZ->BZ_XBLQPC) //Ita - 10/06/2019 - SBZ->BZ_XBLQPC
	EndIf
ENDIF

//////////////////////////
/// Ita - 16/04/2019
///       Só fará Pedido Automático caso atenda os critérios de Cobertura
///       definido na tela de parâmetros
  cPesq := "/"
  cText := (cArqTrab)->TRB_COBERT
  nPosIni := AT( cPesq, cText ) // Resultado
  _nQtCobert := Val(Substr((cArqTrab)->TRB_COBERT,(nPosIni+1),100))
 
/***********
Ita - 15/05/2019 - Retirado mensagem conforme solicitação de Gustavo
If _nQtCobert > _nCobAte //Se os dias de cobertura for maior que o definido no parâmetro Cobertura, apresenta alerta de inconsistência.
   Alert("O Produto "+Alltrim(_cCodProd) + " - " + Alltrim(_cDescPrd)+" não deverá ser comprado pois o mesmo encontra-se com uma cobertura de "+Alltrim(Str(_nQtCobert))+" dias, ou seja maior que o definido do parâmetro: "+Alltrim(Str(_nCobAte))+" dias")
EndIf
*********************************/

If _cBloqSB1 == "S" .And. (Substr(_cTped,1,1) == "C") //Ita - 17/07/2019 - Implementado critério para checar se pedido é de compra, pois se for transfeferência, não será criticado o bloqueio do item.
	RecLock(cArqTrab,.F.)
	//Alert("Entrei aqui - 6)")
	Replace TRB_OK with " "
	MsUnLock()
	//Ita - 29/05/2019 - Refresh itens selecionados
	//_nItemSel--
	//_nValPC -= SZ1->Z1_TOTAL
    _psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
    Eval(bAtTots)//Ita - 03/06/2019
	//_oItemSel:Refresh()
	//_oValPC:Refresh()
	Help(" ",1,"PRODBLQ",,"Produto Bloqueado para compra: " + Alltrim(_cCodProd) + " - " + Alltrim(_cDescPrd),4,,,,,,.F.)
	Return
Endif

_cRotina := "2"

SetKey(VK_F2, { || Conf_PC(), oDlgPC:End() } )
SetKey(VK_F4, { || fAltData(aHeader)} ) //Ita - 20/05/2019 - Alteração da Data do Pedido.

//MsgInfo("2. Alterei função F4") //Ita - 25/06/2019

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Array aHeader.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//////////////////////////////////////////
/// Ita - 07/08/2019
///     - Compatibilizar para CodeAnalysis
///       Função para Abertura de Tabelas Metadados(Dicionários SXs)
///       dbSelectArea("SX3")
///       dbSetOrder(2)
///       ABERTURA DO DICIONÁRIO SX3
///       Substituído por:
///       OpenSXs(NIL, NIL, NIL, NIL, SM0->M0_CODIGO, "TDIC", "SX3", NIL, .F.) 
/* Ita - 13/08/2019 - Movido para o inicio do programa para possibilitar o uso mais amplo da áres do SX3
OpenSXs(NIL, NIL, NIL, NIL, SM0->M0_CODIGO, "TDIC", "SX3", NIL, .F.)
lOpen := Select("TDIC") > 0
If lOpen
   DbSelectArea("TDIC")
   TDIC->( DbSetOrder(2) )// //ORDENA POR CAMPOS
Else
   Alert("Não foi possível abrir o dicionário de dados - SX3")
   Return
EndIf
*/

If Len(_aItemPC) > 0
	_aItemPC := ASort(_aItemPC,,, { | x,y | x[6] > y[6] })
	For nJ:=1 to Len(_aItemPC)
		If _aItemPC[nJ,6] == "1"
			_lIniAcols := .F.
			Exit
		Endif
	Next
	_aItemPC := ASort(_aItemPC,,, { | x,y | x[1]+x[6] > y[1]+y[6] })
Endif
If _lIniAcols
    //aSZ1Fields := FWSX3Util():GetAllFields( "SZ1" , .F. ) //Ita - 14/08/2019 - Compatibilidade CodeAnalysis
    //cPare:=""
    DbSelectArea("TDIC") 
	dbSeek("Z1_DTENTR")
	Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_DTENTR" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
			"Z1_DTENTR"                             ,;                //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
			PesqPict( "SZ1", "Z1_DTENTR" )          ,;                //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
			TamSX3("Z1_DTENTR")[1]                  ,;                //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
			TamSX3("Z1_DTENTR")[2]                  ,;                //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_VALID,;
			"€€€€€€€€€€€€€€ "                       ,;                //Ita - 14/08/2019 - TDIC->X3_USADO,;
			FWSX3Util():GetFieldType( "Z1_DTENTR" ) ,;                //Ita - 14/08/2019 - TDIC->X3_TIPO,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_F3,;
			"R"                                     ,;                //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_CBOX,;
			"u_fSumData(n)"                         ,;                //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
			"Empty(GdFieldGet('Z1_QUANT',n)) .And. !u_fChkDtPR(GdFieldGet('Z1_DTENTR',n),If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL))"       ,;                //Ita - 14/08/2019 - TDIC->X3_WHEN,;
			"A"                                     } )               //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
	nUsado++
	dbSeek("Z1_QUANT")
	Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_QUANT" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
			"Z1_QUANT"                              ,;                    //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
			PesqPict( "SZ1", "Z1_QUANT" )           ,;                    //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
			TamSX3("Z1_QUANT")[1]                   ,;                    //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
			TamSX3("Z1_QUANT")[2]                   ,;                    //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_VALID,;
			"€€€€€€€€€€€€€€ "                       ,;                    //Ita - 14/08/2019 - TDIC->X3_USADO,;
			FWSX3Util():GetFieldType( "Z1_QUANT" )  ,;                    //Ita - 14/08/2019 - TDIC->X3_TIPO,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_F3,;
			"R"                                     ,;                    //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_CBOX,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_WHEN,;
			"A"                                     })                    //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
	nUsado++

Else
    DbSelectArea("TDIC") 
	dbSeek("Z1_QUANT")
	Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_QUANT" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
			"Z1_QUANT"                              ,;                    //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
			PesqPict( "SZ1", "Z1_QUANT" )           ,;                    //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
			TamSX3("Z1_QUANT")[1]                   ,;                    //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
			TamSX3("Z1_QUANT")[2]                   ,;                    //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_VALID,;
			"€€€€€€€€€€€€€€ "                       ,;                    //Ita - 14/08/2019 - TDIC->X3_USADO,;
			FWSX3Util():GetFieldType( "Z1_QUANT" )  ,;                    //Ita - 14/08/2019 - TDIC->X3_TIPO,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_F3,;
			"R"                                     ,;                    //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_CBOX,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
			""                                      ,;                    //Ita - 14/08/2019 - TDIC->X3_WHEN,;
			"A"                                     })                    //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
	nUsado++
	dbSeek("Z1_DTENTR")
	Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_DTENTR" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
			"Z1_DTENTR"                             ,;                //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
			PesqPict( "SZ1", "Z1_DTENTR" )          ,;                //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
			TamSX3("Z1_DTENTR")[1]                  ,;                //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
			TamSX3("Z1_DTENTR")[2]                  ,;                //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_VALID,;
			"€€€€€€€€€€€€€€ "                       ,;                //Ita - 14/08/2019 - TDIC->X3_USADO,;
			FWSX3Util():GetFieldType( "Z1_DTENTR" ) ,;                //Ita - 14/08/2019 - TDIC->X3_TIPO,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_F3,;
			"R"                                     ,;                //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
			""                                      ,;                //Ita - 14/08/2019 - TDIC->X3_CBOX,;
			"u_fSumData(n)"                         ,;                //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
			"Empty(GdFieldGet('Z1_QUANT',n)) .And. !u_fChkDtPR(GdFieldGet('Z1_DTENTR',n),If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL))"       ,;                //Ita - 14/08/2019 - TDIC->X3_WHEN,;
			"A"                                     } )               //Ita - 14/08/2019 - TDIC->X3_VISUAL } )

Endif

dbSeek("Z1_PRUNIT")
Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_PRUNIT" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
		"Z1_PRUNIT"                                 ,;                 //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
		PesqPict( "SZ1", "Z1_PRUNIT" )              ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("Z1_PRUNIT")[1]                      ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("Z1_PRUNIT")[2]                      ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_VALID,;
		"€€€€€€€€€€€€€€ "                           ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "Z1_PRUNIT" )     ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;TDIC->X3_TIPO,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		"R"                                         ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		"U_ANPRCPC(_CCODTELDG,Substr(_cPrecoF,1,1),_cCodMarc)",;       //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                       ,;                 //Ita - 14/08/2019 - TDIC->X3_WHEN,;
		"A"                                         })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++
dbSeek("Z1_TOTAL")
Aadd(aHeader, {   AllTrim(FWSX3Util():GetDescription( "Z1_TOTAL" )),; //Ita - 07/08/2019 - Compatibilidade CodeAnalysis - Aadd(aHeader, {   AllTrim(X3Titulo()),;
		"Z1_TOTAL"                                  ,;                 //Ita - 14/08/2019 - TDIC->X3_CAMPO,;
		PesqPict( "SZ1", "Z1_TOTAL" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("Z1_TOTAL")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("Z1_TOTAL")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_VALID,;
		"€€€€€€€€€€€€€€ "                           ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "Z1_TOTAL" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;TDIC->X3_TIPO,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		"R"                                         ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                       ,;                 //Ita - 14/08/2019 - TDIC->X3_WHEN,;
		"A"                                         })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++

_nPosDt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_DTENTR"})
_nPosQt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_QUANT"})
_nPosPr := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_PRUNIT"})
_nPosTo := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_TOTAL"})

IF !EMPTY(aHeader)
	_nAcho := aScan(_aItemPC,{|x| x[1] == _cCodProd})
	_lIniAcols := .T.
	If _nAcho > 0
		For nJ:=_nAcho to Len(_aItemPC)
			If _aItemPC[nJ,1] == _cCodProd .and. _aItemPC[nJ,6] == "1"
				_lIniAcols := .F.
				Exit
			Endif
		Next
	Endif
	If _lIniAcols
		If Len(_aItemPC) == 0
			//Ita - 03/09/2019 - Aadd( aCols, Array( Len( aHeader ) + 1 ) )
			Aadd( aCols, Array( Len( aHeader ) + 2 ) ) //Ita - 03/09/2019
			nUsed :=0
			For nI := 1 To Len(aHeader)
				nUsed ++
				If Alltrim(aHeader[nI][2]) == "Z1_PRUNIT"
				    xOpcPrc := Substr(_cPrecoF,1,1) //Ita - 23/07/2019 - Acrescentado cOpcPrc para poder utilizar esta função, também na Solicitação de transferência.
					_nPrecTab := u_ANPrcPC(_cCodProd,xOpcPrc,_cCodMarc) //Ita - 18/07/2019 - Passar código do produto posicionado para a User Function - u_ANPrcPC()
					aCols[Len(aCols)][nUsed] := _nPrecTab
				ElseIf aHeader[nI][8] == "C"
					aCols[Len(aCols)][nUsed] := Space(aHeader[nI][4])
				ElseIf aHeader[nI][8] == "D"                                    
				   If Alltrim(aHeader[nI][2]) == "Z1_DTENTR"   //Ita - 30/05/2019 
				      aCols[Len(aCols)][nUsed] := dDataBase    //Ita - 30/05/2019
				   Else
					aCols[Len(aCols)][nUsed] := Ctod("  /  /  ")
				   EndIf
				ElseIf aHeader[nI][8] == "N"
			        aCols[Len(aCols)][nUsed] := 0
				Endif
			Next
			aCols[Len( aCols ),Len( aHeader ) + 1] :=.F.
		Else
			dbSelectArea("SZ1")
			_cQuery := "SELECT DISTINCT Z1_DTENTR " + _Enter
			_cQuery += "FROM " + RetSqlName("SZ1") + _Enter
			//Ita - 30/05/2019 - _cQuery += " WHERE Z1_FILIAL = '" + xFilial("SZ1") + "'" + _Enter
			_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
		    _cQuery += " AND Z1_STATUS IN ('1','2')" + _Enter
			_cQuery += " AND Z1_CODFORN = '" + aPCRev[13] + "'" + _Enter
			If _nOpcCont == 1 //Se opção for continuar pedido
			   _cQuery += "   AND Z1_DTINCL = '"+DTOS((cAliasTMP)->TMP_DTINCL)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
			Else //Se a opção for novo pedido
			   _cQuery += "   AND Z1_DTINCL = '"+DTOS(dDataBase)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
			EndIf
			//Ita - 29/05/2019 - _cQuery += " AND Z1_QUANT > 0 " + _Enter                //Ita - 23/05/2019 
			_cQuery += " AND D_E_L_E_T_ = ' '" + _Enter
			_cQuery += " ORDER BY Z1_DTENTR" + _Enter
			MemoWrite("C:\TEMP\ATU_PC_DatasDistintas.SQL",_cQuery)//Ita - 02/04/2019
			_cQuery := ChangeQuery(_cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ1,.T.,.T.)
			dbSelectArea(cAliasSZ1)
			While !Eof()
				Aadd( aCols, Array( Len( aHeader ) + 1 ) )
				nUsed :=0
				For nI := 1 To Len(aHeader)
					nUsed ++
					If Alltrim(aHeader[nI][2]) == "Z1_PRUNIT"
					     xOpcPrc := Substr(_cPrecoF,1,1)//Ita - 23/07/2019 - Acrescentado cOpcPrc para poder utilizar esta função, também na Solicitação de transferência.
						_nPrecTab := u_ANPrcPC(_cCodProd,xOpcPrc,_cCodMarc)//Ita - 18/07/2019 - Passar código do produto posicionado para a User Function - u_ANPrcPC()
						aCols[Len(aCols)][nUsed] := _nPrecTab
					ElseIf aHeader[nI][8] == "C"
						aCols[Len(aCols)][nUsed] := Space(aHeader[nI][4])
					ElseIf aHeader[nI][8] == "D"
						If Alltrim(aHeader[nI][2]) == "Z1_DTENTR"
							aCols[Len(aCols)][nUsed] := Stod((cAliasSZ1)->Z1_DTENTR)
						Else
							aCols[Len(aCols)][nUsed] := Ctod("  /  /  ")
						Endif
					ElseIf aHeader[nI][8] == "N"
					   aCols[Len(aCols)][nUsed] := 0
					Endif
				Next
				
			    aCols[Len( aCols ),Len( aHeader ) + 1] :=.F.
			    
				dbSelectArea(cAliasSZ1)
				dbSkip()
			End
			dbSelectArea(cAliasSZ1)
			dbCloseArea()
			RestArea(_aArea)
		Endif
	Else
		aCols := {}
		//Ita - 23/05/2019 - aDtValid := {}
	    For nJ:=_nAcho to Len(_aItemPC)
			If _aItemPC[nJ,1] == _cCodProd .and. _aItemPC[nJ,6] == "1"
				If aScan(aCols, {|x| DTOS(x[_nPosDt]) == DTOS(_aItemPC[nJ,2])}) == 0 //Ita - 23/05/2019 - Evitar duplicidade de datas
				   //Ita - 23/05/2019 - aAdd(aDtValid,_aItemPC[nJ,_nPosDt])
				   Aadd( aCols, Array( Len( aHeader ) + 1 ) )
				   aCols[Len(aCols)][_nPosDt] 	:= _aItemPC[nJ,2]
				   aCols[Len(aCols)][_nPosQt] 	:= _aItemPC[nJ,3]
				   aCols[Len(aCols)][_nPosPr]	:= _aItemPC[nJ,4]
				   aCols[Len(aCols)][_nPosTo]	:= Round(_aItemPC[nJ,3]*_aItemPC[nJ,4], TAMSX3("C7_TOTAL")[2])
				   aCols[Len(aCols)][5] 		:= .F.
				   //Ita - 23/05/2019 - Evitar duplicidade de datas - If aScan(aDtValid,DTOS(aCols[Len(aCols)][_nPosDt])) == 0
				   //aAdd(aDtValid,DTOS(aCols[Len(aCols)][_nPosDt]))
				EndIf
			Endif
		Next
		//Ita - 27/03/2019 - Permitir nova data para todos os itens(digitados ou não) - 
			dbSelectArea("SZ1")
			_cQuery := "SELECT DISTINCT Z1_DTENTR " + _Enter
			_cQuery += "FROM " + RetSqlName("SZ1") + _Enter
			//Ita - 30/05/2019 - _cQuery += " WHERE Z1_FILIAL = '" + xFilial("SZ1") + "'" + _Enter
			_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
		    _cQuery += " AND Z1_STATUS IN ('1','2')" + _Enter
			_cQuery += " AND Z1_CODFORN = '" + aPCRev[13] + "'" + _Enter
			If _nOpcCont == 1 //Se opção for continuar pedido
			   _cQuery += "   AND Z1_DTINCL = '"+DTOS((cAliasTMP)->TMP_DTINCL)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
			Else //Se a opção for novo pedidos
			   _cQuery += "   AND Z1_DTINCL = '"+DTOS(dDataBase)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
			EndIf
			//Ita - 29/05/2019 - _cQuery += " AND Z1_QUANT > 0 " + _Enter                //Ita - 23/05/2019
			//_cQuery += " AND Z1_PRODUTO <> '"+_cCodProd+"' " + _Enter //Ita - 23/05/2019 - Datas Digitadas para outros produtos.
			_cQuery += " AND D_E_L_E_T_ = ' '" + _Enter
			_cQuery += " ORDER BY Z1_DTENTR" + _Enter
			MemoWrite("C:\TEMP\ATU_PC_DatasDistintas_2.SQL",_cQuery)//Ita - 02/04/2019
			MemoWrite("\Data\ATU_PC_DatasDistintas_2.SQL",_cQuery)//Ita - 02/04/2019
			_cQuery := ChangeQuery(_cQuery)
			cpare:=""
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ1,.T.,.T.)
			TCSetField(cAliasSZ1,"Z1_DTENTR","D",08,00)
			dbSelectArea(cAliasSZ1)
			While !Eof()
				If aScan(aCols, {|x| DTOS(x[_nPosDt]) == DTOS((cAliasSZ1)->Z1_DTENTR)}) == 0 // .And. aScan(_aItemPC,{|x| DTOS(x[_nPosDt]) == DTOS((cAliasSZ1)->Z1_DTENTR)}) == 0
				    //aAdd(aDtValid, DTOS((cAliasSZ1)->Z1_DTENTR)) //Ita - 23/05/2019 - Evitar duplicidade de datas.
					Aadd( aCols, Array( Len( aHeader ) + 1 ) )
					nUsed :=0
					For nI := 1 To Len(aHeader)
						nUsed ++
						If Alltrim(aHeader[nI][2]) == "Z1_PRUNIT"
						     xOpcPrc := Substr(_cPrecoF,1,1)//Ita - 23/07/2019 - Acrescentado cOpcPrc para poder utilizar esta função, também na Solicitação de transferência.
							_nPrecTab := u_ANPrcPC(_cCodProd,xOpcPrc,_cCodMarc)//Ita - 18/07/2019 - Passar código do produto posicionado para a User Function - u_ANPrcPC()
							//Ita - 23/05/2019 - aCols[Len(aCols)][nUsed] := _nPrecTab
							aCols[Len(aCols)][_nPosPr] := _nPrecTab
						ElseIf aHeader[nI][8] == "C"
							aCols[Len(aCols)][nUsed] := Space(aHeader[nI][4])
						ElseIf aHeader[nI][8] == "D"
							If Alltrim(aHeader[nI][2]) == "Z1_DTENTR"
								aCols[Len(aCols)][nUsed] := (cAliasSZ1)->Z1_DTENTR//Stod((cAliasSZ1)->Z1_DTENTR)
							Else
								aCols[Len(aCols)][nUsed] := Ctod("  /  /  ")
							Endif
						ElseIf aHeader[nI][8] == "N"
						   aCols[Len(aCols)][nUsed] := 0
						Endif
					Next
					
			        aCols[Len( aCols ),Len( aHeader ) + 1] :=.F.
			    					
				EndIf
				dbSelectArea(cAliasSZ1)
				dbSkip()
			End
			dbSelectArea(cAliasSZ1)
			dbCloseArea()
			RestArea(_aArea)

	ENDIF
Endif

nOpcaoR := IIF(nOpcx==4,3,nOpcx)
_cSaldo := Alltrim(Str(_nSaldo1)) + " / " + Alltrim(Str(_nSaldo2))

Aadd(aObjects,{100,090,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
Aadd(aObjects,{100,200,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y
aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj:=MsObjSize(aInfo,aObjects,.T.)

///////////////////
/// Ita - 01/03/2019 
///     - Reclassificação do vetor aCols - Itens do Pedido de Compras
///     - Sequencia da mais antiga para mais recente
//////////////////////////////////////////////////////////////////////
If Len(aCols) > 0 //Ita - 27/06/2019
  _cDado := aCols[1,2] 
  If Type('_cDado') == "D"
     aSort(aCols,,, { | x,y | Dtos(x[2]) < Dtos(y[2]) })
  EndIf
EndIf

cpare:= ""
//////////////////////
/// Ita - 27/03/2019  
///     - Pega os Meses da Tela Anterior
/////////////////////////////////////////
_v1Mes:=""
_v2Mes:=""
_v3Mes:=""
_v4Mes:=""
For xCol := 9 To 12
   If xCol == 9
      _v1Mes:= aColumns[xCol]:CTITLE
   ElseIf xCol == 10
      _v2Mes:= aColumns[xCol]:CTITLE
   ElseIf xCol == 11
      _v3Mes:= aColumns[xCol]:CTITLE
   ElseIf xCol == 12
      _v4Mes:= aColumns[xCol]:CTITLE
   EndIf
Next xCol

DEFINE MSDIALOG oDlgPC TITLE OemToAnsi("Itens do Pedido de Compra") From 0,0 TO 500,800 OF oMainWnd PIXEL
//oDlgPC:SetEscClose(.T.)		//permite fechar a tela com o ESC

_nLinha += 05
@ aPosObj[1][1] + _nLinha,C(010) SAY "Codigo" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(070) SAY "Decrição" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(235) SAY "Saldo" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(275) SAY "Curva" PIXEL OF oDlgPC
_nLinha += 10
@ aPosObj[1][1] + _nLinha,C(010) GET oCodProd VAR _cCodProd SIZE 65,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(070) GET oDesProd VAR _cDescPrd SIZE 200,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(230) GET oSaldo VAR _cSaldo SIZE 40,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(270) GET oCurva VAR _cCurva SIZE 40,15 When .F. OF oDlgPC PIXEL
_nLinha += 30
@ aPosObj[1][1] + _nLinha,C(010) SAY "SUGESTÃO" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(040) SAY "COBERTURA" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(075) SAY "PEND" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(105) SAY _v1Mes PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(135) SAY _v2Mes PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(165) SAY _v3Mes PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(200) SAY _v4Mes PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(230) SAY "MEDIA TRI" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(270) SAY "MEDIA SEM" PIXEL OF oDlgPC
_nLinha += 10
@ aPosObj[1][1] + _nLinha,C(010) GET oSugest VAR _nSugest Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(040) GET oCobert VAR _cCobert SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(070) GET oPenden VAR _nPenden Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(100) GET oMes04 VAR _nMes04 Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(130) GET oMes03 VAR _nMes03 Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(160) GET oMes02 VAR _nMes02 Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(195) GET oMes01 VAR _nMes01 Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(230) GET oMedTri VAR _nMedTri Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(270) GET OMedSem VAR _nMedSem Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
_nLinha += 30
@ aPosObj[1][1] + _nLinha,C(010) SAY "DATA 1" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(050) SAY "QTDE 1" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(080) SAY "DATA 2" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(120) SAY "QTDE 2" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(150) SAY "DATA 3" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(190) SAY "QTDE 3" PIXEL OF oDlgPC
//Ita - 08/04/2019 - @ aPosObj[1][1] + _nLinha,C(245) SAY "FATOR DE EMBALAGEM" PIXEL OF oDlgPC
@ aPosObj[1][1] + _nLinha,C(215) SAY "FATOR EMBALAGEM" PIXEL OF oDlgPC

/////////////////////
/// Ita - 08/04/2019
///     - Implementado informações referente ao tipo do pedido
@ aPosObj[1][1] + _nLinha,C(260) SAY  "Tipo Pedido" PIXEL OF oDlgPC


_nLinha += 10
/* Ita - 03/06/2019 - Inversão das datas para apresentar ordem correta conforme necessidade ANL
@ aPosObj[1][1] + _nLinha,C(010) MSGET odData1 VAR _dData1 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(050) GET oQtde1  VAR _nQtde1 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(080) MSGET odData2 VAR _dData2 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(120) GET oQtde2  VAR _nQtde2 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(150) MSGET odData3 VAR _dData3 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(190) GET oQtde3  VAR _nQtde3 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
*/
@ aPosObj[1][1] + _nLinha,C(010) MSGET odData3 VAR _dData3 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(050) GET oQtde3  VAR _nQtde3 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(080) MSGET odData2 VAR _dData2 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(120) GET oQtde2  VAR _nQtde2 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(150) MSGET odData1 VAR _dData1 SIZE 45,15 OF oDlgPC READONLY PIXEL
@ aPosObj[1][1] + _nLinha,C(190) GET  oQtde1 VAR _nQtde1 Picture "@E 999,999" SIZE 25,15 When .F. OF oDlgPC PIXEL
//Ita - 08/04/2019 - @ aPosObj[1][1] + _nLinha,C(250) GET oQE     VAR _nQE    Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(215) GET oQE     VAR _nQE    Picture "@E 999,999" SIZE 30,15 When .F. OF oDlgPC PIXEL
@ aPosObj[1][1] + _nLinha,C(260) COMBOBOX oTped VAR _cTped ITEMS _aTped SIZE 65,15 When .F. OF oDlgPC PIXEL

_nLinha+=20

//oGetDados:= MSNewGetDados():New(aPosObj[2][1],aPosObj[2][2],200        ,400        ,GD_INSERT+GD_UPDATE+GD_DELETE,"Allwaystrue()" /*cLinhaOk*/,"Allwaystrue()" /*cTudoOk*/, /*cIniCpos*/ ,/*aAlter*/,/*nFreeze*/,999     ,"Allwaystrue()",''           ,'AllwaysTrue()',oDlgPC   , aHeader        , aCols )
//Ita       MsNewGetDados():New(   [ nTop]   , [ nLeft]    , [ nBottom], [ nRight ], [ nStyle]                   , [ cLinhaOk]                , [ cTudoOk]                 , [ cIniCpos]  , [ aAlter], [ nFreeze], [ nMax], [ cFieldOk]   , [ cSuperDel], [ cDelOk]     , [ oWnd] , [ aPartHeader], [ aParCols], [ uChange], [ cTela] ) --> Objeto
oGetDados:= MSNewGetDados():New(aPosObj[2][1],aPosObj[2][2],200        ,400        ,GD_INSERT+GD_UPDATE+GD_DELETE,"u_fVldLCons(n)" /*cLinhaOk*/,"Allwaystrue()" /*cTudoOk*/, /*cIniCpos*/ ,/*aAlter*/,/*nFreeze*/,999     ,"Allwaystrue()",''           ,'Eval(bDelOk)'       ,oDlgPC   , aHeader        , aCols)//,fGoDown() )
_nLinha:=190
@ aPosObj[1][1] + _nLinha,C(00) MSPANEL oPanel2 PROMPT " " COLOR CLR_FONTT,CLR_FUNDO SIZE 1000,aPosObj[2][4] OF oDlgPC
_nLinha+=5
//Ita - 02/07/2019 - @ aPosObj[1][1] + _nLinha ,C(010)  BUTTON "F2 - Confirmar / ESC - Sair" SIZE 100 ,15 FONT oFont ACTION { || Conf_PC(), oDlgPC:End() } OF oDlgPC PIXEL  //
@ aPosObj[1][1] + _nLinha ,C(010)  BUTTON "ESC - Sair" SIZE 100 ,15 FONT oFont ACTION { || Conf_PC(), oDlgPC:End() } OF oDlgPC PIXEL  //
@ aPosObj[1][1] + _nLinha ,C(125)  BUTTON "F4 - Alterar Data" SIZE 100 ,15 FONT oFont ACTION { || fAltData(aHeader), oDlgPC:End() } OF oDlgPC PIXEL  //

oGetDados:oBrowse:SetFocus()
//Ita - 10/06/2019 - oGetDados:oBrowse:Refresh()
oDlgPC:LESCCLOSE=.T. //Ita - 05/06/2019

//Ita - 27/06/2019 - ACTIVATE MSDIALOG oDlgPC CENTERED
ACTIVATE MSDIALOG oDlgPC CENTERED
nOpcA := 1 //Ita - 02/07/2019 - sempre salvar, independentemente se usar F2 ou ESC
If nOpcA == 1
	// /* Ita - 21/05/2019 - Já faço deleção em outra função.
	_nAcho := aScan(_aItemPC,{|x| x[1]+x[6] == _cCodProd+"1"})
	While _nAcho > 0 .and. _nAcho <= Len(_aItemPC) .and. _aItemPC[_nAcho, 1] == _cCodProd
		_aItemPC[_nAcho, 6] := "0"
		//Ita - 23/05/2019 - Grv_SZ1("0",_aItemPC[_nAcho])
		_nAcho++
	End
	// */
	_lSubtrai := .T.
	For nT:=1 to Len(oGetDados:aCols)
		If !oGetDados:aCols[nT,Len(aHeader)+1] //Se a linha não estiver deletada.
			If !Empty(oGetDados:aCols[nT,_nPosDt]) //Ita - 29/05/2019 - .And. oGetDados:aCols[nT,_nPosQt] > 0 //Ita - 07/03/2019  - Acrescentado validação da quantidade 
			    ///////////////////////////////////
			    /// Ita - 03/09/2019
			    ///       Controle para gravação de data de abertura do 
			    ///       pedido com quantidade zerada.
			    If oGetDados:aCols[nT,_nPosQt] <= 0 // Ita - 03/09/2019
			       _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
			       If !u_fChkDtPR(oGetDados:aCols[nT,_nPosDt],_IncDt)
			          If MsgYesNo("Deseja abrir pedido em "+DTOC(oGetDados:aCols[nT,_nPosDt])+" com quantidade zerada?")
				         aadd(_aItemPC, { _cCodProd, oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo], "1"})
				         Grv_SZ1("1",_aItemPC[Len(_aItemPC)],1) //Ita - 03/06/21019 - Implementado _xnRot para tratar variáveis de totais.			       
				      EndIf
			       Else
			          aadd(_aItemPC, { _cCodProd, oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo], "1"})
			          Grv_SZ1("1",_aItemPC[Len(_aItemPC)],1) //Ita - 03/06/21019 - Implementado _xnRot para tratar variáveis de totais.			       
			       EndIf
			    Else
				   aadd(_aItemPC, { _cCodProd, oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo], "1"})
				   Grv_SZ1("1",_aItemPC[Len(_aItemPC)],1) //Ita - 03/06/21019 - Implementado _xnRot para tratar variáveis de totais.			    
			    EndIf

				If oGetDados:aCols[nT,_nPosQt] > 0
					_lMark := .T.
			       RecLock(cArqTrab,.F.)
			       //Alert("Entrei aqui - 3)")
			       Replace TRB_OK with oMrkBrowse:Mark()
			       MsUnLock()
					//Ita - 30/05/2019 - _nItemSel++
					//_nValPC += oGetDados:aCols[nT,_nPosTo]
					//_oItemSel:Refresh()
					//_oValPC:Refresh()
			       //Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
			       //lGoTop := .F. 
				   //oMrkBrowse:Refresh(.F.)
								
				Else
					_lSubtrai := .F.
					_IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
			        //Ita - 05/09/2019 - If !fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
			        If !fChkQtdZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
				        RecLock(cArqTrab,.F.)
				        //Alert("Entrei aqui - 7)")
				           Replace TRB_OK with " "
				        MsUnLock()
				        //_nItemSel-- //Ita - 29/05/2019
				        //_nValPC -= oGetDados:aCols[nT,_nPosTo]
			            //_oItemSel:Refresh()
			            //_oValPC:Refresh()
		            EndIf
				Endif
			Endif
		Endif
	Next nT
	If _lMark
	    /* Ita - 29/05/2019
		If Empty((cArqTrab)->TRB_OK)
			RecLock(cArqTrab,.F.)                
			Alert("Entrei aqui - x)")
			Replace TRB_OK with oMrkBrowse:Mark()
			MsUnLock()
			oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
			cpare:=""
		
		Endif
		_nItemSel++
		_nValPC += oGetDados:aCols[oGetDados:nAt,_nPosTo]
		_oItemSel:Refresh()
		_oValPC:Refresh()
		*/
	Else
		If !Empty((cArqTrab)->TRB_OK)
		   ///////////////////////////////////////////////////////
		   /// Ita - 24/05/2019
		   ///     - Checa se o produto existe na SZ1 
		   ///     - com outras datas de faturamento/necessidade.
		   ///     - Se ainda existir não irá desmarcar.
		   _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
		   //Ita - 05/09/2019 - If !fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2)
		   If !fChkQtdZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2)
			  RecLock(cArqTrab,.F.)
			  //Alert("Entrei aqui - 8)")
			  Replace TRB_OK with " "
			  //_nItemSel-- //Ita - 29/05/2019
			  //_nValPC -= oGetDados:aCols[oGetDados:nAt,_nPosTo]
		      //_oItemSel:Refresh()
		      //_oValPC:Refresh()
			  MsUnLock()
			  //Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019		      
			  //lGoTop := .F. 
              //oMrkBrowse:Refresh(lGoTop)
              //oMrkBrowse:Refresh(.F.)
		   EndIf			

			/*
			nPosMrk := aScan(aMrkTRB,{|x| x[1] == (cArqTrab)->TRB_COD }) //Ita - 24/05/2019
			If nPosMrk > 0
			   aMrkTRB[nPosMrk,2] := 2
			EndIf
			*/
		Endif
		If _lSubtrai .and. _nItemSel > 0
			//_nItemSel--
		Endif
		//_oItemSel:Refresh()
		//_oValPC:Refresh()
	Endif

    //////////////////////////////
    /// Ita - 24/05/2019
    ///     - Atualiza oMrkBrowse 
   _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
   If !fChkTemZ1(aPCRev[13],_IncDt,"",1)
	  For nIt := 1 To Len(_aItemPC)
	     _aItemPC[nIt, 6] := "0"
	  Next nIt
      Eval(oMrkBrowse:bAllMark)
   EndIf
   
Else
    _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)  
	If Empty((cArqTrab)->TRB_OK)
		//Ita - 05/09/2019 - If fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
		If fChkQtdZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
		
			If oGetDados:aCols[oGetDados:nAt,_nPosQt] > 0 //Ita - 04/09/2019
			   RecLock(cArqTrab,.F.)
			   //Alert("Entrei aqui - 4)")
			      Replace TRB_OK with oMrkBrowse:Mark()
			   MsUnLock()
			EndIf
			//Ita - 29/05/2019 - Refresh itens selecionados
			//_nItemSel++
			//_nValPC += oGetDados:aCols[oGetDados:nAt,_nPosTo]
			//_oItemSel:Refresh()
			//_oValPC:Refresh()
			//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
			//lGoTop := .F. 
            //oMrkBrowse:Refresh(lGoTop)
            //oMrkBrowse:Refresh(.F.)
		EndIf
	Else
		//Ita - 05/09/2019 - If !fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2)  
		If fChkQtdZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2)  
			RecLock(cArqTrab,.F.)
			//Alert("Entrei aqui - 9)")
			Replace TRB_OK with " "
			MsUnLock()
			//Ita - 29/05/2019 - Refresh itens selecionados
			//_nItemSel--
			//_nValPC -= oGetDados:aCols[oGetDados:nAt,_nPosTo]
			//_oItemSel:Refresh()
			//_oValPC:Refresh()
			//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
			//lGoTop := .F. 
            //oMrkBrowse:Refresh(lGoTop)
            //oMrkBrowse:Refresh(.F.)
		EndIf
	Endif
Endif

//Eval(bAtuPC)                 //Ita - 23/05/2019 
//Eval(bAtuZ1)                  //Ita - 23/05/2019 
//oMrkBrowse:oBrowse:Refresh() //Ita - 23/05/2019

SetKey(VK_F2, NIL )
SetKey(VK_F4, NIL )
SetKey( VK_F4  , { || RestKey("0"), ANItemPC((cArqTrab)->TRB_COD), RestKey("1", cArqTrab) } ) //Ita - 27/06/2019
//MsgInfo("3. Desabilitei função F4") //Ita - 25/06/2019
_cRotina := "0"
_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
Eval(bAtTots)//Ita - 03/06/2019
    
dbSelectArea(cArqTrab) //Ita - 30/05/2019
//Ita - 10/06/2019 - dbSetOrder(_nOrdTrab)  //Ita - 30/05/2019
//Ita - 07/06/2019 - Evitar saída da posição da tela - oMrkBrowse:GoTo (_nRecTrb,.T.)
//RestArea(_aArea) //Ita - 07/06/2019
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros

RestArea(_aArea)               //Ita - 03/09/2019 - evitar sair da posição do item que foi digitado. 
//oMrkBrowse:GoTo (_nRecTrb,.T.) //Ita - 03/09/2019 - evitar sair da posição do item que foi digitado.

//Ita - 05/09/2019 - Novo teste para realizar a marcação do registro
/*
cpare:=""
If oGetDados:aCols[oGetDados:nAt,_nPosQt] > 0
   RecLock(cArqTrab,.F.)
      TRB_OK := oMrkBrowse:Mark()
   MsUnLock()
Else
   RecLock(cArqTrab,.F.)
      TRB_OK := SPACE(1)
   MsUnLock()
EndIf
*/
//MsgInfo((cArqTrab)->TRB_OK)
Return
//Return( oImgRet ) //Ita - 04/09/2019 - Retornar a imagem da marca/desmarca do produto.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Grv_SZ1(_pStatus, _vDadosPC, _xnRot)  //Ita - 03/06/2019 - Implementado _xnRot para tratar atualização de totais

Local _aArea := GetArea()
cUser  := RetCodUsr()
_vStatus := _pStatus
_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
Private b2AtTots := {|| fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) } //Ita - 03/06/2019

dbSelectArea("SZ1")
//Ita - 04/09/2019 dbSetOrder(1)//Z1_FILIAL+Z1_CODFORN+Z1_PRODUTO

_IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) //Ita - 04/09/2019
DbSetORder(3)//Z1_FILIAL+Z1_CODFORN+Z1_DTINCL+Z1_PRODUTO

If _vStatus == "0"
	//Ita - 30/05/2019 - dbSeek(xFilial()+aPCRev[13]+_vDadosPC[1])
	//Ita - 30/05/2019 - While !Eof() .and. xFilial("SZ1")+aPCRev[13]+_vDadosPC[1] == SZ1->(Z1_FILIAL+Z1_CODFORN+Z1_PRODUTO)
	//Ita - 04/09/2019 - dbSeek(cFilAnt+aPCRev[13]+_vDadosPC[1])
	dbSeek(cFilAnt+aPCRev[13]+DTOS(_IncDt)+_vDadosPC[1])
	While !Eof() .and. cFilAnt+aPCRev[13]+_vDadosPC[1] == SZ1->(Z1_FILIAL+Z1_CODFORN+Z1_PRODUTO)
		//_nValPC-= SZ1->Z1_TOTAL
		RecLock("SZ1",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
ElseIf _vStatus == "1"
    //Ita - 29/05/2019 - If _vDadosPC[3] > 0 //Ita - 07/03/2019
		_dDataPsq := If((_nOpcCont == 2),dDataBase,If(Empty((cAliasTMP)->TMP_DTINCL),dDataBase,(cAliasTMP)->TMP_DTINCL)) //Ita - 20/05/2019
		//DbSelectArea("SZ1")
		//DbSetOrder(3) //Ita - 16/05/2019 - Z1_FILIAL+Z1_CODFORN+Z1_DTINCL+Z1_PRODUTO - Check da existência do produto para evitar duplicidade.
		//Ita - 20/05/2019 - If DbSeek(xFilial("SZ1")+Padr(aPCRev[13],6)+DtoS(dDataBase)+_vDadosPC[1]) 
		//If DbSeek(xFilial("SZ1")+Padr(aPCRev[13],6)+DtoS(_dDataPsq)+_vDadosPC[1]) 
		//aadd(_aItemPC, { _cCodProd, oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo], "1"})
		If fChkDupZ1(aPCRev[13],_vDadosPC[2],_dDataPsq,_vDadosPC[1])
		   fUpdZ1(aPCRev[13],_vDadosPC[2],_dDataPsq,_vDadosPC[3],_vDadosPC[4],_vDadosPC[1])
		Else
			dbSelectArea("SZ1")
			RecLock("SZ1",.T.)
			//Ita - 30/05/2019 - Replace Z1_FILIAL with xFilial("SZ1"),;
			Replace Z1_FILIAL with cFilAnt,;
					Z1_CODFORN with aPCRev[13],;
					Z1_PRODUTO with _vDadosPC[1],;
					Z1_COMPRAD with cUser,;
					Z1_STATUS with _vStatus,;
					Z1_QUANT with _vDadosPC[3],;
					Z1_DTENTR with _vDadosPC[2],;
					Z1_PRUNIT with _vDadosPC[4],;
					Z1_TOTAL with ROUND(_vDadosPC[4] * _vDadosPC[3],TAMSX3("Z1_TOTAL")[2]),;
					Z1_DTINCL with  _dDataPsq //Ita - 20/05/2019 - Z1_DTINCL with dDataBase//,;
					//Z1_PEDIDO with + cNumAE   //Ita - 07/03/2019
            MsUnLock()
            If _vDadosPC[3] > 0 .And. _xnRot == 1 //Ita - 03/06/2019
               //Alert("Entrei aqui - 1)")
			   RecLock(cArqTrab,.F.)
			   Replace TRB_OK with oMrkBrowse:Mark()
			   MsUnLock()
			   //Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh()
			   //lGoTop := .F. 
               //oMrkBrowse:Refresh(lGoTop)
               //Ita - 10/06/2019 - oMrkBrowse:Refresh(.F.)
			EndIf
			       
            //_nValPC+= SZ1->Z1_TOTAL //Ita - 29/05/2019 
			If aScan(aMrkTRB,{|x| x[1] == _vDadosPC[1] }) == 0 //Ita - 24/05/2019
			   //Ita - 18/06/2019 - aAdd(aMrkTRB, {_vDadosPC[1],1}) 
			   aAdd(aMrkTRB, {_vDadosPC[1],1,aPCRev[13],_xIncPC}) //Ita - 18/06/2019 -  - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
			EndIf
		EndIf
		/*
		DbSelectArea("SZ1")
		dbSetOrder(1)//Z1_FILIAL+Z1_CODFORN+Z1_PRODUTO
		If dbSeek(xFilial("SZ1")+aPCRev[13]+_vDadosPC[1])
			While !Eof() .and. xFilial("SZ1")+aPCRev[13]+_vDadosPC[1] == SZ1->(Z1_FILIAL+Z1_CODFORN+Z1_PRODUTO)
			//aadd(_aItemPC, { _cCodProd, oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo], "1"})
				If SZ1->Z1_DTENTR == _vDadosPC[2]
					RecLock("SZ1",.F.) 
					   Z1_COMPRAD := cUser
					   Z1_STATUS  := _vStatus
					   Z1_QUANT   := _vDadosPC[3]				
					   Z1_PRUNIT  := _vDadosPC[4]
					   Z1_TOTAL   := ROUND(_vDadosPC[4] * _vDadosPC[3],TAMSX3("Z1_TOTAL")[2])
					MsUnLock()
				Else
					RecLock("SZ1",.T.)
					Replace Z1_FILIAL with xFilial("SZ1"),;
							Z1_CODFORN with aPCRev[13],;
							Z1_PRODUTO with _vDadosPC[1],;
							Z1_COMPRAD with cUser,;
							Z1_STATUS with _vStatus,;
							Z1_QUANT with _vDadosPC[3],;
							Z1_DTENTR with _vDadosPC[2],;
							Z1_PRUNIT with _vDadosPC[4],;
							Z1_TOTAL with ROUND(_vDadosPC[4] * _vDadosPC[3],TAMSX3("Z1_TOTAL")[2]),;
							Z1_DTINCL with  _dDataPsq //Ita - 20/05/2019 - Z1_DTINCL with dDataBase//,;
							//Z1_PEDIDO with + cNumAE   //Ita - 07/03/2019
					                
                EndIf
				DbSelectArea("SZ1") 
				dbSkip()
			EndDo
		Else
			RecLock("SZ1",.T.)
			Replace Z1_FILIAL with xFilial("SZ1"),;
					Z1_CODFORN with aPCRev[13],;
					Z1_PRODUTO with _vDadosPC[1],;
					Z1_COMPRAD with cUser,;
					Z1_STATUS with _vStatus,;
					Z1_QUANT with _vDadosPC[3],;
					Z1_DTENTR with _vDadosPC[2],;
					Z1_PRUNIT with _vDadosPC[4],;
					Z1_TOTAL with ROUND(_vDadosPC[4] * _vDadosPC[3],TAMSX3("Z1_TOTAL")[2]),;
					Z1_DTINCL with  _dDataPsq //Ita - 20/05/2019 - Z1_DTINCL with dDataBase//,;
					//Z1_PEDIDO with + cNumAE   //Ita - 07/03/2019
		EndIf 
		MsUnLock()
	_nValPC+= SZ1->Z1_TOTAL
	*/
	//Ita - 29/05/2019 - EndIf
Endif
//_oItemSel:Refresh() //Ita - 29/05/2019
//_oValPC:Refresh()   //Ita - 29/05/2019
If _xnRot == 1
  _psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
  Eval(b2AtTots)//Ita - 03/06/2019
EndIf
cpare:=""
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Conf_PC()//xCalGrv,aHeader,aCols)

If _cRotina == "2"
	nOpcA := 1
Else
	nOpcTL := 1
	oDlgTPC:End()
Endif
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ANTela_G()

SetKey( VK_F2 , { || NIL } )
SetKey( VK_F4 , { || NIL } )
//MsgInfo("4. Desabilitei função F4") //Ita - 25/06/2019
SetKey( VK_F5 , { || NIL } )
SetKey( VK_F6 , { || NIL } )
SetKey( VK_F7 , { || NIL } )
SetKey( VK_F8 , { || NIL } )
SetKey( VK_F9 , { || NIL } )
SetKey( VK_F11, { || NIL } )
Tela_GPC()
SetKey( VK_F2  , { || ANTela_G() } )
SetKey( VK_F4  , { || ANItemPC((cArqTrab)->TRB_COD) } )
SetKey( VK_F5  , { || ANConKard((cArqTrab)->TRB_COD) } )
//SetKey( VK_F6  , { || ANPrdSim((cArqTrab)->TRB_COD) } )
//Ita - 28/06/2019 - SetKey( VK_F6  , { || RestKey("0"), ANPrdSim((cArqTrab)->TRB_COD), 	RestKey("1", cArqTrab) } )
SetKey( VK_F6  , { || ANPrdSim((cArqTrab)->TRB_COD,aStru)} ) //Ita - 28/06/2019 - acrescentado aStru para facilitar apresentação dos similares
SetKey( VK_F7  , { || ANPrdApl((cArqTrab)->TRB_COD) } )
SetKey( VK_F8  , { || ANCOnDem((cArqTrab)->TRB_COD) } )
SetKey( VK_F9  , { || ANPesqCod(oMrkBrowse, cArqTrab,_cPrdPos) } ) //Ita - Preencher Código do último Produto digitado  na Pesquisa - Solicitação Gustavo - SetKey( VK_F9  , { || ANPesqCod(oMrkBrowse, cArqTrab) } )
SetKey( VK_F11 , { || ANItBlq(cArqTrab) } )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/13/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tela_GPC()

Local _aArea  	:= GetArea()
Local aHeadPC 	:= {}
Local aColsPC   := {}
//Ita - 27/03/2019 - Possibilitar replica da OBS - Local aHeadDT 	:= {}
//Ita - 27/03/2019 - Possibilitar replica da OBS - Local aColsDT   := {}
LOCAL aPosObj 	:={}
Local aSize		:= MsAdvSize()
Local aInfo		:= {}
Local aObjects	:= {}
Local _cOBS		:= CriaVar("Z7_OBS",.F.)
Local nUsado	:= 0
Local _nLinha	:= 0
Local lRet		:= .T.
//Ita - 05/11/2019 - Evitar erro do MsgRun - Local aItens	:= {}
Local aLinha	:= {}
Local _nItPC	:= 0
//Ita - 05/11/2019 - Evitar erro do MsgRun - Local aCabec	:= {}
Local _aCodForn	:= {}
Local _cRecSZ1  := ""
Local _aCodForn := {}
Local _cTpOper  := SuperGetMv('MV_XOPREV',.F.,"01")
Local _cTES     := CriaVar("F4_CODIGO",.F.)
Local _cCond
Local aAlterDT    := {"_cCondDT","_cOBSDT"}
Private nOpcTL	:= 0
Private lMsErroAuto := .F.
Private aHeadDT 	:= {}//Ita - 27/03/2019 - Possibilitar replica da OBS 
Private aColsDT   := {}//Ita - 27/03/2019 - Possibilitar replica da OBS
Private aItens	:= {}  //Ita - 05/11/2019 - Evitar erro do MsgRun
Private aCabec	:= {}
_cRotina := "3"

////////////////////////////////////////////////////////////////
/// Ita - 27/06/2019
///     - Seleciona todos os itens do pedido de compras
///     - independentemente se encontram-se ou não filtrados
///     - na tela atual, ou seja, pega os itens digitados na
///     - tela atual e todos os pedidos gravados anteriormente.
///     aadd(_aItemPC, { _cCodProd, _dDtEnt,  _nQtdPC,  _nPrcPC,  _nTotPC, "1"})
_aPCSel := {}
fCargaPC(@_aPCSel)
/*
If Empty(_aItemPC)
	Help(" ",1,"SEMITPC",,"Selecione os produtos para a geração do Pedido de Compra",4,,,,,,.F.)
	Return
Endif
*/
If Empty(_aPCSel)
	Help(" ",1,"SEMITPC",,"Selecione os produtos para a geração do Pedido de Compra de "+DTOC(dDataBase),4,,,,,,.F.)
	Return
Endif

Aadd(aObjects,{100,090,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
Aadd(aObjects,{100,200,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y
aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj:=MsObjSize(aInfo,aObjects,.T.)

/* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
dbSelectArea("SX3")
dbSetOrder(2)
*/
DbSelectArea("TDIC")
dbSeek("C7_DATPRF")
Aadd(aHeadDT, {   AllTrim(FWSX3Util():GetDescription( "C7_DATPRF" )),; //AllTrim(X3Titulo()),;
		"_dDtEntrDT"                                 ,;
		PesqPict( "SC7", "C7_DATPRF" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_DATPRF")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_DATPRF")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		".T."                                        ,;
		"€€€€€€€€€€€€€€ "                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_DATPRF" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		"dDataBase"                                  ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".T."                                        ,;
		""                                           })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )

dbSeek("C7_COND")
Aadd(aHeadDT, {   AllTrim(FWSX3Util():GetDescription( "C7_COND" )),; //AllTrim(X3Titulo()),;
		"_cCondDT",;
		PesqPict( "SC7", "C7_COND" )                 ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_COND")[1]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_COND")[2]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"u_VldCondPR()"                              ,;
		"€€€€€€€€€€€€€€€"                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_COND" )        ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		"SE4   "                                     ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".T."                                        ,;
		""                                           })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )

dbSeek("E4_DESCRI")
Aadd(aHeadDT, {   AllTrim(FWSX3Util():GetDescription( "C7_COND" )),; //AllTrim(X3Titulo()),;
		"_cDesCPDT"                                  ,;
		PesqPict( "SE4", "E4_DESCRI" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("E4_DESCRI")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("E4_DESCRI")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		".T."                                        ,;
		"€€€€€€€€€€€€€€ "                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "E4_DESCRI" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".T."                                        ,;
		""                                           })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
dbSeek("C7_TOTAL")
Aadd(aHeadDT, {   AllTrim(FWSX3Util():GetDescription( "C7_TOTAL" )),; //AllTrim(X3Titulo()),;
		"_nTotalDT"                                 ,;
		PesqPict( "SC7", "C7_TOTAL" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_TOTAL")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_TOTAL")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"A120Total(M->C7_TOTAL).And.MaFisRef('IT_VALMERC','MT120',M->C7_TOTAL)",;
		"€€€€€€€€€€€€€€ "                           ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_TOTAL" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                       ,;
		""                                          })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )		
dbSeek("C7_OBS")
Aadd(aHeadDT, {   AllTrim(FWSX3Util():GetDescription( "C7_OBS" )),; //AllTrim(X3Titulo()),;
		"_cOBSDT"                                   ,;
		PesqPict( "SC7", "C7_OBS" )                 ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_OBS")[1]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_OBS")[2]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"u_fReplOBS()"                              ,; //".T.",;
		"€€€€€€€€€€€€€€ "                           ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_OBS" )        ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".T."                                       ,;
		""                                          })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona os campos de Alias e Recno   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ADHeadRec("SC7",aHeadDT)

dbSeek("C7_DATPRF")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "C7_DATPRF" )),; //AllTrim(X3Titulo()),;
		"_dDtEntrC7",;
		PesqPict( "SC7", "C7_DATPRF" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_DATPRF")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_DATPRF")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		".T."                                        ,;
		"€€€€€€€€€€€€€€ "                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_DATPRF" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		"dDataBase"                                  ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".T."                                        ,;
		""                                           })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )

nUsado++
dbSeek("C7_PRODUTO")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "C7_PRODUTO" )),; //AllTrim(X3Titulo()),;
		"_cProdC7"                                   ,;
		PesqPict( "SC7", "C7_PRODUTO" )              ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_PRODUTO")[1]                      ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_PRODUTO")[2]                      ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		".T."                                        ,;
		"€€€€€€€€€€€€€€ "                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_PRODUTO" )     ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		"SB1   "                                     ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		"R"                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                        ,;
		"A"                                          })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++
dbSeek("B1_DESC")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "B1_DESC" )),; //AllTrim(X3Titulo()),;
		"_cDescC7"                                   ,;
		PesqPict( "SB1", "B1_DESC" )                 ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("B1_DESC")[1]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("B1_DESC")[2]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		".T."                                        ,;
		"€€€€€€€€€€€€€€ "                            ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "B1_DESC" )        ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		"R"                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                        ,;
		"A"                                          })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++
dbSeek("C7_QUANT")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "C7_QUANT" )),; //AllTrim(X3Titulo()),;
		"_nQuantC7"                                   ,;
		PesqPict( "SC7", "C7_QUANT" )                 ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_QUANT")[1]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_QUANT")[2]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"Positivo()"                                  ,;
		"€€€€€€€€€€€€€€ "                             ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_QUANT" )        ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		"R"                                           ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                         ,;
		"A"                                           })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++
dbSeek("C7_PRECO")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "C7_PRECO" )),; //AllTrim(X3Titulo()),;
        "_nPrecoC7"                                   ,;
		PesqPict( "SC7", "C7_PRECO" )                 ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_PRECO")[1]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_PRECO")[2]                         ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"Positivo().and.A120Preco(M->C7_PRECO) .And. MaFisRef('IT_PRCUNI','MT120',M->C7_PRECO) .AND. MTA121TROP(n)" ,;//Ita - 14/08/2019 - TDIC->X3_VALID,;
		"€€€€€€€€€€€€€€ "                             ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_PRECO" )        ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                            ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                         ,;
		""                                            })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )
nUsado++
dbSeek("C7_TOTAL")
Aadd(aHeadPC, {   AllTrim(FWSX3Util():GetDescription( "C7_TOTAL" )),; //AllTrim(X3Titulo()),;
		"_nTotalC7",;
		PesqPict( "SC7", "C7_TOTAL" )               ,;                 //Ita - 14/08/2019 - TDIC->X3_PICTURE,;
		TamSX3("C7_TOTAL")[1]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_TAMANHO,;
		TamSX3("C7_TOTAL")[2]                       ,;                 //Ita - 14/08/2019 - TDIC->X3_DECIMAL,;
		"A120Total(M->C7_TOTAL).And.MaFisRef('IT_VALMERC','MT120',M->C7_TOTAL)",;
		"€€€€€€€€€€€€€€ "                           ,;                 //Ita - 14/08/2019 - TDIC->X3_USADO,;
		FWSX3Util():GetFieldType( "C7_TOTAL" )      ,;                 //Ita - 14/08/2019 - TDIC->X3_TIPO,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_F3,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CONTEXT,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_CBOX,;
		""                                          ,;                 //Ita - 14/08/2019 - TDIC->X3_RELACAO,;
		".F."                                       ,;
		""                                          })                 //Ita - 14/08/2019 - TDIC->X3_VISUAL } )		
nUsado++

_aCodForn := u_MPosFor(_cCodMarc)

If Empty(_aCodForn)
	Alert('Não existe cadastro Fornecedor x Marca para a Marca '+_cCodMarc+'.')
	Return
EndIf
_cCond := Posicione("SA2",1,xFilial("SA2")+_aCodForn[1][1]+"01","A2_COND")
//_cCond    := SA2->A2_COND

/////////////////////
/// Ita - 01/03/2019
///     - Trata Condição de Pagamento
///////////////////////////////////////
If Empty(_cCond)
   _NmeFor := Posicione("SA2",1,xFilial("SA2")+SA2->(A2_COD+A2_LOJA),"A2_NOME")
   Alert("O Fornecedor/Loja - "+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME)+" encontra-se sem condição de pagamento cadastrada, favor verificar no cadastro deste fornecedor, não será possível continuar este processo!")
   Return
Else
   DbSelectArea("SE4")
   DbSetOrder(1)//E4_FILIAL+E4_CODIGO
   If !DbSeek(xFilial("SE4")+_cCond)
      Alert("A Condição "+_cCond+" informada no cadastro do fornecedor/loja "+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME)+" não foi localizada no cadastro de Condições de Pagamento, não será possível continuar este processo!")
      Return
   EndIf
EndIf


/* Ita - 27/06/2019 - Tratamento para pegar todos os itens do pedido  independentemente de filtro
_aItemPC := ASort(_aItemPC,,, { | x,y | x[6]+Dtos(x[2])+x[1] < y[6]+Dtos(y[2])+y[1] })
For nJ:=1 to Len(_aItemPC)
	If _aItemPC[nJ,6] == "1"
		If _aItemPC[nJ,3] > 0
			_dDtEntr := _aItemPC[nJ,2]
			_nTotal  := 0
			While nJ <= Len(_aItemPC) .and. _aItemPC[nJ,2] == _dDtEntr
				Aadd( aColsPC, Array( Len( aHeadPC ) + 1 ) )
				aColsPC[Len(aColsPC)][1] := _aItemPC[nJ,2]
				aColsPC[Len(aColsPC)][2] := _aItemPC[nJ,1]
				aColsPC[Len(aColsPC)][3] := Posicione("SB1",1,xFilial("SB1")+_aItemPC[nJ,1], "B1_DESC")
				aColsPC[Len(aColsPC)][4] := _aItemPC[nJ,3]
				aColsPC[Len(aColsPC)][5] := _aItemPC[nJ,4]
				aColsPC[Len(aColsPC)][6] := Round(_aItemPC[nJ,3]*_aItemPC[nJ,4], TAMSX3("C7_TOTAL")[2])
				aColsPC[Len(aColsPC)][7] := .F.
				_nTotal  += aColsPC[Len(aColsPC)][6]
				nJ++
			End
			Aadd( aColsDT, Array( Len( aHeadDT ) + 1 ) )
			aColsDT[Len(aColsDT)][1] := _dDtEntr
			aColsDT[Len(aColsDT)][2] := _cCond
			aColsDT[Len(aColsDT)][3] := Posicione("SE4",1,xFilial("SE4")+_cCond, "E4_DESCRI")
			aColsDT[Len(aColsDT)][4] := _nTotal
			aColsDT[Len(aColsDT)][5] := Space(TAMSX3("C7_OBS")[1])
			aColsDT[Len(aColsDT)][6] := "SC7"
			aColsDT[Len(aColsDT)][7] := 0
			aColsDT[Len(aColsDT)][8] := .F.
			nJ--
		Endif
	Endif
Next
*/
_aPCSel := ASort(_aPCSel,,, { | x,y | x[6]+Dtos(x[2])+x[1] < y[6]+Dtos(y[2])+y[1] })
For nJ:=1 to Len(_aPCSel)
	If _aPCSel[nJ,6] == "1"
		If _aPCSel[nJ,3] > 0
			_dDtEntr := _aPCSel[nJ,2]
			_nTotal  := 0
			While nJ <= Len(_aPCSel) .and. _aPCSel[nJ,2] == _dDtEntr
				Aadd( aColsPC, Array( Len( aHeadPC ) + 1 ) )
				aColsPC[Len(aColsPC)][1] := _aPCSel[nJ,2]
				aColsPC[Len(aColsPC)][2] := _aPCSel[nJ,1]
				aColsPC[Len(aColsPC)][3] := Posicione("SB1",1,xFilial("SB1")+_aPCSel[nJ,1], "B1_DESC")
				aColsPC[Len(aColsPC)][4] := _aPCSel[nJ,3]
				aColsPC[Len(aColsPC)][5] := _aPCSel[nJ,4]
				aColsPC[Len(aColsPC)][6] := Round(_aPCSel[nJ,3]*_aPCSel[nJ,4], TAMSX3("C7_TOTAL")[2])
				aColsPC[Len(aColsPC)][7] := .F.
				_nTotal  += aColsPC[Len(aColsPC)][6]
				nJ++
			End
			Aadd( aColsDT, Array( Len( aHeadDT ) + 1 ) )
			aColsDT[Len(aColsDT)][1] := _dDtEntr
			aColsDT[Len(aColsDT)][2] := _cCond
			aColsDT[Len(aColsDT)][3] := Posicione("SE4",1,xFilial("SE4")+_cCond, "E4_DESCRI")
			aColsDT[Len(aColsDT)][4] := _nTotal
			aColsDT[Len(aColsDT)][5] := Space(TAMSX3("C7_OBS")[1])
			aColsDT[Len(aColsDT)][6] := "SC7"
			aColsDT[Len(aColsDT)][7] := 0
			aColsDT[Len(aColsDT)][8] := .F.
			nJ--
		Endif
	Endif
Next
//Ita - 09/07/2019 - SetKey(VK_F2, { || Conf_PC() } ) 
DEFINE MSDIALOG oDlgTPC FROM aSize[7],00 To aSize[6],aSize[5] TITLE OemToAnsi("Geração do Pedido de Compra") Of oMainWnd PIXEL
//DEFINE MSDIALOG oDlgTPC TITLE OemToAnsi("Geração do Pedido de Compra") From 0,0 TO 500,1000 OF oMainWnd PIXEL

@ aPosObj[1][1],C(010) SAY "Fornecedor" PIXEL OF oDlgTPC
@ aPosObj[1][1],C(040) GET oCodForn VAR aPCRev[13] SIZE 65,15 When .F. OF oDlgTPC PIXEL

oGetTDT:= MSNewGetDados():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],2,"Allwaystrue()" /*cLinhaOk*/,"Allwaystrue()" /*cTudoOk*/, /*cIniCpos*/ ,aAlterDT,/*nFreeze*/,999,"Allwaystrue()",'','AllwaysTrue()',oDlgTPC,aHeadDT,aColsDT )
oGetTPC:= MSNewGetDados():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3],aPosObj[2][4],2,"Allwaystrue()" /*cLinhaOk*/,"Allwaystrue()" /*cTudoOk*/, /*cIniCpos*/ ,/*aAlter*/,/*nFreeze*/,999,"Allwaystrue()",'','AllwaysTrue()',oDlgTPC,aHeadPC,aColsPC )

bOk 	:= {||nOpcTL:=1,oDlgTPC:End()}
bCancel := {||nOpcTL:=0,oDlgTPC:End()}
EnchoiceBar(oDlgTPC, bOk, bCancel)
ACTIVATE MSDIALOG oDlgTPC CENTERED
SetKey(VK_F2, { || Conf_PC() } ) 
_cRotina := "0"
If nOpcTL == 1
    _lANCompras := .F. //Ita - 11/04/2019
	If Substr(_cTped,1,1) == "C" //Compras   - Itacolomy Mariano - 11/04/2019
	    _lANCompras := .T.
		lRet := MsgYesNo("Confirma o Encerramento do Pedido de Compra","Atenção")
	ElseIf Substr(_cTped,1,1) == "T"  //T - Transferência - Itacolomy Mariano - 11/04/2019
	    lRet := MsgYesNo("Confirma o Encerramento do Pedido de tranferência","Atenção")
	EndIf
		If lRet
			If _lANCompras 
			   _aCodForn := u_MPosFor(_cCodMarc)
			Else
	           aFornTrf := fPsqForF(_cOrigTrf) //Ita - 11/04/2019 - Pega o Fornecedor para realizar transfeência 
	           _aCodForn := aFornTrf[1]
			EndIf
			If !Empty(_aCodForn) //Ita - 11/04/2019 - Len(_aCodForn) > 0
				dbSelectArea("SZ1")
				cAliasSZ1 := "QRYSZ1"
				cQuery	  := "SELECT Z1_CODFORN, Z1_PRODUTO, Z1_QUANT, Z1_COMPRAD, Z1_DTINCL, Z1_DTENTR, Z1_PRUNIT, Z1_TOTAL, R_E_C_N_O_ RECNOZ1"
				cQuery += " FROM "+RetSqlName("SZ1") + " SZ1 "
				cQuery += " WHERE "
				//cQuery += "Z1_FILIAL = '"+xFilial("SZ1")+"' AND "
				cQuery += "Z1_FILIAL = '"+cFilAnt+"' AND "
				cQuery += "Z1_CODFORN = '"+aPCRev[13]+"' AND "
				cQuery += "Z1_STATUS IN ('1','2') AND "
				cQuery += "Z1_DTINCL = '"+If((_nOpcCont == 2),DTOS(dDataBase),DTOS((cAliasTMP)->TMP_DTINCL))+"' AND "
				cQuery += "Z1_QUANT > 0 AND " //Ita - 03/06/2019 - Evitar quantidade zerada 
				cQuery += " SZ1.D_E_L_E_T_ = ' ' "
				cQuery += " ORDER BY Z1_DTENTR, Z1_PRODUTO "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ1,.T.,.T.)
				
				TCSetField(cAliasSZ1,"Z1_QUANT","N",TamSX3("Z1_QUANT")[1],TamSX3("Z1_QUANT")[2])       //Ita - 03/07/2019
				//TCSetField(cAliasSZ1,"Z1_DTINCL","D",08,0)                                             // "        "
				//TCSetField(cAliasSZ1,"Z1_DTENTR","D",08,0)                                             // "        "
				TCSetField(cAliasSZ1,"Z1_PRUNIT","N",14,04)//TamSX3("Z1_PRUNIT")[1],TamSX3("Z1_PRUNIT")[2])    // "        "
				TCSetField(cAliasSZ1,"Z1_TOTAL","N",14,04)//TamSX3("Z1_TOTAL")[1],TamSX3("Z1_TOTAL")[2])       // "        "
				
				dbSelectArea(cAliasSZ1)
				While !Eof()
					_dEntr := (cAliasSZ1)->Z1_DTENTR
					_nPosDt := aScan(oGetTDT:aCols,{|x| Dtos(x[1]) = _dEntr})
					//Ita - 12/06/2019 - _cOBS := oGetTDT:aCols[_nPosDt,5]
					If _nPosDt > 0
						/*Ita - 27/03/2019 - `Comentado para possibilitar que a Observação de 
						                      um pedido seja replicada para todos os pedidos de outras datas 
						                      _cOBS := oGetTDT:aCols[_nPosDt,5]
						*************************************************************************************/
						_cOBS  := oGetTDT:aCols[_nPosDt,5]//Ita - 12/06/2019
						_cCond := oGetTDT:aCols[_nPosDt,2]
					Else
						//Ita - 27/03/2019 - _cOBS := " "
						_cCond := " "
					Endif
					_cRecSZ1 := ""
					aItens	:= {}
					aLinha	:= {}
					_nItPC	:= 0
					aCabec	:= {}
					aItPVend:={} //Ita - 11/04/2019
					aNecesAnt:= {} //Ita - 20/05/2019 - Produtos com data de necessidade anterior a data de emissão do Pedido de Compras
					While !Eof() .and. _dEntr == (cAliasSZ1)->Z1_DTENTR				
						If Empty(_cRecSZ1)
							_cRecSZ1 += "('"
						Else
							_cRecSZ1 += "','"
						Endif
						_cRecSZ1 += Alltrim(Str((cAliasSZ1)->RECNOZ1))
						_nItPC++
						_cTES := u_ANTesInt(/*nEntSai*/ 1,/*cTpOper*/ _cTpOper, SA2->A2_COD,SA2->A2_LOJA,"F",(cAliasSZ1)->Z1_PRODUTO)
						_nPrcuni := (cAliasSZ1)->Z1_PRUNIT
						If _nPrcuni == 0
							_nPrcuni := 0.01
							_nPrcTot := Round((cAliasSZ1)->Z1_QUANT * _nPrcuni,2)
						Else
							_nPrcTot := (cAliasSZ1)->Z1_TOTAL
						Endif
						/////////////////////
						/// Ita - 08/04/2019
						///     - Trata o Tipo do Pedido de Compras
						///       se C=Compras ou T=Transferência
						_cGrvTp := If(Substr(_cTped,1,1)=="C","S","T")
						
						If (cAliasSZ1)->Z1_QUANT > 0
							aLinha:={}
							Aadd(aLinha,{"C7_ITEM"		,StrZero(_nItPC,Len(SC7->C7_ITEM),0),NIL})
							aadd(aLinha,{"C7_PRODUTO"   ,(cAliasSZ1)->Z1_PRODUTO			,NIL})
							Aadd(aLinha,{"C7_QUANT"		,(cAliasSZ1)->Z1_QUANT				,NIL})
							Aadd(aLinha,{"C7_TOTAL"		,_nPrcTot							,NIL})
							Aadd(aLinha,{"C7_PRECO"		,_nPrcuni							,NIL})	
							Aadd(aLinha,{"C7_DATPRF"	,Stod((cAliasSZ1)->Z1_DTENTR)		,NIL})
							Aadd(aLinha,{"C7_OBS"		,OemToAnsi(_cOBS)					,NIL})
							aadd(aLinha,{"C7_TES" 	    ,_cTES								,NIL})
							aadd(aLinha,{"C7_XREVEND"   ,_cGrvTp							,NIL}) //"S"
							aadd(aItens,aLinha)
							aAdd(aItPVend,{(cAliasSZ1)->Z1_PRODUTO,(cAliasSZ1)->Z1_QUANT,_nPrcuni,_nPrcTot})//Ita - 11/04/2019
						Endif
						If (cAliasSZ1)->Z1_DTENTR < DTOS(dDataBase)
						   aAdd(aNecesAnt, {(cAliasSZ1)->Z1_PRODUTO,(cAliasSZ1)->Z1_QUANT,(cAliasSZ1)->Z1_DTENTR})
						EndIf
						dbSelectArea(cAliasSZ1)
						dbSkip()
					End
					_cRecSZ1 += "')"
					If Len(aItens) > 0
						dbSelectArea("SC7")
						// Descobre numero da SC
						cNumAE:=CriaVar("C7_NUM")
						If ( __lSX8 )
							ConfirmSX8()
						Endif
						If Len(aNecesAnt) > 0
						   MsgInfo("ATENÇÃO! - No Pedido "+cNumAE+" existem produtos com data de necessidade/faturamento anterior a "+DTOC(dDataBase))
						EndIf
						aCabec:={}                             //Criação do cabecalho e item para chamada da rot aut mata120 na criacao de uma AE
						aadd(aCabec,{"C7_NUM"     ,cNumAE			,NIL}) 
						aadd(aCabec,{"C7_EMISSAO" ,dDataBase		,NIL})
						aadd(aCabec,{"C7_FORNECE" ,SA2->A2_COD		,NIL})
						aadd(aCabec,{"C7_LOJA"    ,SA2->A2_LOJA		,NIL})
						aadd(aCabec,{"C7_COND"    ,_cCond			,NIL})
						aadd(aCabec,{"C7_CONTATO" ,""				,NIL})
						If Substr(_cTped,1,1) == "T"  //T - Transferência - Itacolomy Mariano - 11/04/2019 
						   //Ita - 05/11/2019 - MsgRun("Gerando Pedido de entrada da transferência...","Aguarde...",{|| MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,3)})
						   Processa({|| fExecGrv(1)},"Gerando Pedido de entrada da transferência...")
						Else
						   //Ita - 05/11/2019 - MsgRun("Gerando Pedido de Compra...","Aguarde...",{|| MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,3)})
						   Processa({|| fExecGrv(2)},"Gerando Pedido de Compra...")
						EndIf
						If lMsErroAuto
							lContinua := .F.
							MsgInfo( "Não foi possivel incluir o Pedido, verifique o problema na proxima tela" , "Pedido não Gerado" )
							MostraErro()
						Else
							_cQuery := "UPDATE " + RetSqlName("SZ1") + " SET Z1_STATUS = '3', Z1_PEDIDO = '" + cNumAE + "'"
							_cQuery += " WHERE R_E_C_N_O_ IN " + _cRecSZ1
							nErrQry := TCSqlExec( _cQuery )
							If Substr(_cTped,1,1) <> "T" //Ita - 03/07/2019
							   MsgInfo( "Pedido Gerado com sucesso - Pedido Numero: " +  cNumAE, "Pedido Finalizado" )
							EndIf
							If Substr(_cTped,1,1) == "T"  //T - Transferência - Itacolomy Mariano - 11/04/2019 
							   //MsgInfo("O Tipo do PEdido é: "+Substr(_cTped,1,1))  //Ita - 03/07/2019
							   _tArea := GetArea()
							   aRtTrf := {} 
							   //aRtTrf := u_fRunTrf(aItPVend) //Ita - 03/07/2019 - Executa o Pedido de Transferência
							   //STARTJOB('u_fRunTrf(aItPVend)',"Ita",.T.,,) 
							   MsgRun("Gerando Pedido de saída da transferência...","Aguarde...",{|| aRtTrf := fRunTrf(aItPVend)}) //Ita - 03/07/2019 - Executa o Pedido de Transferência
							   RestArea(_tArea)
							   
							   If aRtTrf[1]
							      MsgInfo("Erro na tentativa de incluir o pedido de saída de transferência: "+aRtTrf[3])
							   Else
							      MsgInfo("O Pedido de Transferência "+aRtTrf[2]+" foi finalizado com Sucesso!","Pedido Incluído")
							   EndIf
							   
							   //MsgRun("Gerando Pedido de saída da transferência...","Aguarde...",{|| fRunTrf(aItPVend)}) //Ita - 03/07/2019 - Executa o Pedido de Transferência
							   //Processa({|| fRunTrf(aItPVend),"Gerando Pedido de saída da transferência...","Aguarde..."}) //Ita - 03/07/2019 - Executa o Pedido de Transferência
							   //RestArea(_tArea)
							EndIf
							If MsgYesNo("Deseja Imprimir "+If(Substr(_cTped,1,1) == "T"," O pedido de entrada da transferência","o PC" )+cNumAE+" ?")
							    xNumPC := cNumAE
							    DbSelectArea("SC7")
							    DbSetOrder(1)
							    //Ita - 30/05/2019 - If DbSeek(xFilial("SC7")+xNumPC)
							    If DbSeek(cFilAnt+xNumPC)
									MV_PAR01 := Replicate(" ", Len(SA2->A2_COD)) 
									MV_PAR02 := Replicate("Z", Len(SA2->A2_COD))
									MV_PAR03 := xNumPC
									MV_PAR04 := xNumPC
									MV_PAR05 := CTOD("01/01/1900")
									MV_PAR06 := CTOD("31/12/2049") 
							        u_xMATR110( "SC7", SC7->(RecNO()), 2 )//MATR110A(xNumPC)//MATR110()
							        //Matr110a(xNumPC) 
							       //StaticCall(Mata120(1),MATR110)
							    Else
							       Alert("O Pedido de Compras "+xNumPC+" não foi localizado, favor verificar este pedido de revenda!")
							    EndIf
							EndIf
							cLocArq := Alltrim(GetMV("MV_XPCEXP")) //Local onde serão gravados os arquivos exportados. 
							
							//If MsgYesNo("Deseja Exportar o PC "+cNumAE+" em "+cLocArq+" ?") 
							   //xArea := GetArea()
							   //u_ExportPC(6) //Ita - 08/03/2019 - Exportar o PC 
							  // RestArea(xArea)
							//Else  ////////////// Ita - 04/04/2019 - Evitar erro de execução, caso não deseje exportar o arquivo.
							   
							   (cAliasSZ1)->(dbCloseArea())
			                   oDlgy:End()
			                   _cRotina	:= "1"
								SetKey(VK_F2, { || NIL } )
								RestArea(_aArea)

							   Return

							//EndIf
							
						Endif
					Endif
				End
				
				(cAliasSZ1)->(dbCloseArea())

			Else
				MsgInfo( "Fornecedor não cadastrado: " + aPCRev[13] , "Pedido Não Gerado" )
			Endif
			oDlgy:End()
			_cRotina	:= "1"
        
        EndIf
Endif
SetKey(VK_F2, { || NIL } )
RestArea(_aArea)
Return
//--------------------------------------------------------------------------------------------------------------
//
User Function VldCondPR

Local _aArea := GetArea()
Local _lRet  := .T.
Local _cCond := _cCondDT
Local _nLinha:= oGetTDT:nAT
If !Empty(_cCond)
	dbSelectArea("SE4")
	dbSetOrder(1)
	If dbSeek(xFilial("SE4")+_cCond)
		oGetTDT:aCols[_nLinha, 3] := SE4->E4_DESCRI
	Else
		Help(" ",1,"NCOND",,"Condição de pagamento não cadastrada",4,,,,,,.F.)
		_lRet := .F.
	Endif
Else
	Help(" ",1,"NVAZCOND",,"Condição de pagamento deve ser preenchida",4,,,,,,.F.)
	_lRet := .F.
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ItemPC³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tela de importacao de Pedidos de Compra por Item.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103ItemPC()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ANItemPC(cVar,lUsaFiscal,aPedido,oGetDAtu,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aGets, lTxNeg, nTaxaMoeda,aRetPed, aArrSldoAux)

Local cSeek			:= ""
Local nOpca			:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aAreaColab	:= {}
Local aRateio       := {0,0,0}
Local aNew			:= {}
Local aTamCab		:= {}
Local aSizePed		:= {30,20,280,580}
Local aSizeC7T		:= {}
Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons		:= {}
Local aEstruSC7		:= SC7->( dbStruct() )
Local nFreeQt		:= 0
Local cQuery		:= ""
Local cLine := ""
Local cAliasSC7		:= "SC7"
Local cQueryQPC     := ""
Local cCpoObri		:= ""
Local cComboFor		:= ''
Local nPed			:= 0
Local nX			:= 0
Local nAuxCNT		:= 0
Local lMt103Vpc		:= ExistBlock("MT103VPC")
Local lMt100C7D		:= ExistBlock("MT100C7D")
Local lMt100C7C		:= ExistBlock("MT100C7C")
Local lMt103C7T		:= ExistBlock("MT103C7T")
Local lMt103Sel		:= ExistBlock("MT103SEL")
Local nMT103Sel     := 0
Local nSelOk        := 1
Local lRet103Vpc	:= .T.
Local lMT103BPC 	:= ExistBlock("MT103BPC")
Local lRetBPC    	:= .F.
Local lContinua		:= .T.
Local lQuery		:= .F.
Local lTColab		:= .F.
Local lRestNfe		:= SuperGetMV("MV_RESTNFE") == "S"
Local lForPCNF		:= SuperGetMV("MV_FORPCNF",.F.,.F.)
Local lXmlxped		:= SuperGetMV("MV_XMLXPED",.F.,.F.)
Local lRetPed		:= (aRetPed == Nil)
Local oQual
Local oDlgPCN
Local oSize
Local oComboBox
Local aUsButtons  	:= {}
Local lPrjCni 		:= If(FindFunction("ValidaCNI"),ValidaCNI(),.F.)
Local lToler		:= .F.
Local nPosItPc		:= 0
Local n103TXPC		:= 0
Local nScan	    	:= 0
Local aMT103FRE	:= {}
Local nQtdItMark	:= 0
Local cTipo			:= "N"
Local cCadastro := OemtoAnsi("Pedidos em Andamento") //Ita - 10/07/2019
PRIVATE oOk        := LoadBitMap(GetResources(), "LBOK")
PRIVATE oNo        := LoadBitMap(GetResources(), "LBNO")
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

//MsgInfo("Estou na Função F4 - ANItemPC") //Ita - 25/06/2019
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacoes da importacao do Pedido de Compras por item  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua .And. lMT103BPC
	lRetBPC := ExecBlock("MT103BPC",.F.,.F.)
	If ValType(lRetBPC)=="L"   
		lContinua:= lRetBPC
	EndIf
EndIf

If lContinua
	DbSelectArea("SC7")
	lQuery    := .T.
	cAliasSC7 := "QRYSC7"
	cQuery	  := "SELECT " + _Enter
	For nAuxCNT := 1 To Len( aEstruSC7 )
		cQuery += aEstruSC7[ nAuxCNT, 1 ]
		cQuery += ", "
	Next
    cQuery += " C7_QUANT - C7_QUJE - C7_QTDACLA AS C7_XSALDO, "
	cQuery += " R_E_C_N_O_ RECSC7 "  + _Enter
	cQuery += " FROM "+RetSqlName("SC7") + " SC7 " + _Enter
	cQuery += " WHERE " + _Enter
	//Ita - 30/05/2019 - cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "
	cQuery += "C7_FILENT = '"+xFilEnt(cFilAnt)+"' AND " + _Enter
	cQuery += " C7_PRODUTO = '"+cVar+"' AND " + _Enter
	cQuery += "C7_TPOP <> 'P' AND " + _Enter
	If SuperGetMV("MV_RESTNFE") == "S" + _Enter
		cQuery += "(C7_CONAPRO = 'L' OR C7_CONAPRO = ' ') AND " + _Enter
	EndIf					
	If !lToler
		cQuery += " SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND " + _Enter
	EndIf
	cQuery += " SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND " + _Enter
	cQuery += " SC7.D_E_L_E_T_ = ' ' " + _Enter
	cQuery += " ORDER BY "+SqlOrder(SC7->(IndexKey()))	 + _Enter
	MemoWrite("\Data\ANItemPC.SQL",cQuery) //Ita - 25/06/2019
	cQuery := ChangeQuery(cQuery)
			
	If !lRetPed .And. (cAliasSC7)->(Alias()) == "QRYSC7"
		(cAliasSC7)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
			
	For nX := 1 To Len(aEstruSC7)
		If aEstruSC7[nX,2]<>"C"
			TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
		EndIf
	Next nX
    //MsgInfo("1. Cheguei Aqui")
	If (cAliasSC7)->(!Eof()) .Or. lForPCNF
		//MsgInfo("2. Não é fim de arquivo")
		/* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
		DbSelectArea("SX3")
		DbSetOrder(2)
		*/
		DbSelectArea("TDIC")
		MsSeek("C7_NUM")
		//Ita - 10/07/2018 - AAdd(aCab,x3Titulo())
		AAdd(aCab,"Numero PD") //Ita - 10/07/2018
		Aadd(aCampos,{"C7_NUM","C","R",PesqPict( "SC7", "C7_NUM" )})
		aadd(aTamCab,CalcFieldSize("C",TamSX3("C7_NUM")[1],TamSX3("C7_NUM")[2],PesqPict( "SC7", "C7_NUM" ),"Numero PD")) //X3Titulo()))
		MsSeek("C7_ITEM")
		//AAdd(aCab,x3Titulo())
        cTitField := AllTrim(FWSX3Util():GetDescription( "C7_ITEM" ))  //Ita - 13/08/2019 - Adequação do critério do CodeAnalysis
        Aadd(aCab,"Item"/*cTitField*/)
		Aadd(aCampos,{"C7_ITEM","C","R",PesqPict( "SC7", "C7_ITEM" )})
		aadd(aTamCab,CalcFieldSize("C",TamSX3("C7_ITEM")[1],TamSX3("C7_ITEM")[2],PesqPict( "SC7", "C7_ITEM" ),"Item"/*cTitField*/)) //X3Titulo()
		MsSeek("C7_EMISSAO")
		//AAdd(aCab,x3Titulo())
        cTitField := AllTrim(FWSX3Util():GetDescription( "C7_EMISSAO" ))  //Ita - 13/08/2019 - Adequação do critério do CodeAnalysis
        Aadd(aCab,cTitField)
		Aadd(aCampos,{"C7_EMISSAO","D","R",PesqPict( "SC7", "C7_EMISSAO" )})
		aadd(aTamCab,CalcFieldSize("D",TamSX3("C7_EMISSAO")[1],TamSX3("C7_EMISSAO")[2],PesqPict( "SC7", "C7_EMISSAO" ),cTitField)) //X3Titulo()
		MsSeek("C7_DATPRF")
		//AAdd(aCab,x3Titulo())
        cTitField := AllTrim(FWSX3Util():GetDescription( "C7_DATPRF" ))  //Ita - 13/08/2019 - Adequação do critério do CodeAnalysis
        Aadd(aCab,cTitField)
		Aadd(aCampos,{"C7_DATPRF","D","R",PesqPict( "SC7", "C7_DATPRF" )})
		aadd(aTamCab,CalcFieldSize("D",TamSX3("C7_DATPRF")[1],TamSX3("C7_DATPRF")[2],PesqPict( "SC7", "C7_DATPRF" ),cTitField))//X3Titulo()
		MsSeek("C7_QUANT")
		//AAdd(aCab,x3Titulo())
        cTitField := AllTrim(FWSX3Util():GetDescription( "C7_QUANT" ))  //Ita - 13/08/2019 - Adequação do critério do CodeAnalysis
        Aadd(aCab,"Qtd Ped")
		//Ita - 14/06/2019 - Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
		Aadd(aCampos,{"C7_QUANT","N","R","@E 999,999,999"})
		aadd(aTamCab,CalcFieldSize("N",TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2],"@E 999,999,999","Qtd Ped"))//X3Titulo()
		
		MsSeek("C7_QTDACLA")
		AAdd(aCab,"Qtd a Class.")
		Aadd(aCampos,{"C7_QTDACLA","N","R","@E 999,999,999"})
		aadd(aTamCab,CalcFieldSize("N",TamSX3("C7_QTDACLA")[1],TamSX3("C7_QTDACLA")[2],"@E 999,999,999","Qtd a Class."))

		MsSeek("C7_XSALDO")
		AAdd(aCab,"Sld Ped")
		Aadd(aCampos,{"C7_XSALDO","N","R","@E 999,999,999"})
		aadd(aTamCab,CalcFieldSize("N",TamSX3("C7_XSALDO")[1],TamSX3("C7_XSALDO")[2],"@E 999,999,999","Sld Ped"))

		DbSelectArea(cAliasSC7)
		//MsgInfo("3. Cheguei Aqui")
		Do While If(lQuery, ;
			(cAliasSC7)->(!Eof()), ;
			(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//MsgInfo("4. Entrei no Laço")
			If !lQuery
				If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO $ "BR") .Or. ;
					(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
					dbSkip()
					//MsgInfo("5. Registros ignorado")
					Loop
				EndIf
			Endif

			nFreeQT := 0
			nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})
			nFreeQT -= If(nPed>0,aPedido[nPed,2],0)

			lRet103Vpc := .T.

			If lMt103Vpc
			    //MsgInfo("Ponto de Entrada MT103VPC Ativo")
				If lQuery
					('SC7')->(MsGoto((cAliasSC7)->RECSC7))
				EndIf															
				lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
			Endif
			If lRet103Vpc
				nFreeQT := (cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE/*-(cAliasSC7)->C7_QTDACLA*/-nFreeQT //italo maciel - comentado quantidade a classificar
				//MsgInfo("lRet103Vpc É .T. nFreeQT: "+Alltrim(Str(nFreeQT)))
				If	lToler .And. nFreeQT < 0 
					nFreeQT := 0
				EndIf 
				If nFreeQT > 0 .Or. lToler
					Aadd(aArrayF4,Array(Len(aCampos)))							
					SB1->(DbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))							
					For nX := 1 to Len(aCampos)
                        //MsgInfo("Carregando arrary aArrayF4: "+Alltrim(Str(Len(aArrayF4))))
						If aCampos[nX][3] != "V"
							If aCampos[nX][2] == "N"
								If Alltrim(aCampos[nX][1]) == "C7_QUANT"
									//Ita - 14/06/2019 - aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
									aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,"@E 999,999,999")
								ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
									//Ita - 14/06/2019 - aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
									aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),"@E 999,999,999")
								ElseIf Alltrim(aCampos[nX][1]) == "C7_QTDACLA"
									aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),"@E 999,999,999")
								ElseIf Alltrim(aCampos[nX][1]) == "C7_XSALDO"
									aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),"@E 999,999,999")		
								Else
									aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
								Endif											
							ElseIf aCampos[nX][1] == "MARK"
								aArrayF4[Len(aArrayF4)][nX] := oNo
							Else
								aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
							Endif	
						Else
							aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
							If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
								aArrayF4[Len(aArrayF4)][nX] := SB1->B1_XLINHA //Ita - 02/04/2019 - SB1->B1_GRUPO                            									
							EndIf
							If Alltrim(aCampos[nX][1]) == "C7_CODITE"
								aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
							EndIf
						Endif
					Next

					aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

					If lMT100C7D
						//MsgInfo("Ponto de Entrada MT100C7D aTIVO")
						If lQuery
							('SC7')->(MsGoto((cAliasSC7)->RECSC7))
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
		    //MsgInfo("Ponto de ENtrada MT100C7L aTIVO")
			ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
		EndIf
        //MsgInfo("6. Cheguei aqui aArrayF4: "+Alltrim(Str(Len(aArrayF4)))) 
		If (!Empty(aArrayF4) .Or. lForPCNF) .And. lRetPed
            //MsgInfo("7. aArrayF4: "+Alltrim(Str(Len(aArrayF4)))) 
			// Ponto de entrada para redimensionar tela de selecao de pedidos por item
			If lMt103C7T
				aSizeC7T := ExecBlock("MT103C7T",.F.,.F.,{aSizePed})
				If ValType(aSizeC7T) == "A"
					aSizePed := aSizeC7T
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta dinamicamente o bline do CodeBlock                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			DEFINE MSDIALOG oDlgPCN FROM aSizePed[1],aSizePed[2] TO aSizePed[3],aSizePed[4] TITLE OemToAnsi("Pedidos Não Atendidos") Of oMainWnd PIXEL
			If lMT100C7C
				aNew := ExecBlock("MT100C7C", .f., .f., aCab)
				If ValType(aNew) == "A"
					aCab := aNew      
							    
		            /* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
		               DbSelectArea("SX3")
		               DbSetOrder(2)
		            */
		            DbSelectArea("TDIC")
					/* Ita - 14/08/2019 - Compatibilizar CodeAnalysis e também não há necessidade de tratar PE já que o código foi personalizado para ANL		
					For nX := 1 to Len(aCab)
				    	If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
    						 If TDIC->(MsSeek(aCab[nX]))
    						        
      						 		//Aadd(aCampos,{TDIC->X3_CAMPO,TDIC->X3_TIPO,TDIC->X3_CONTEXT,TDIC->X3_PICTURE})
      						 		Aadd(aCampos,{aCab[nX],FWSX3Util():GetFieldType( aCab[nX] ),TDIC->X3_CONTEXT,PesqPict( "SZ1", aCab[nX] )})
      						 		
       						 EndIf
						EndIf
					Next nX
					*/
				EndIf
			EndIf
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula dimensões                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSize := FwDefSize():New(.T.,,,oDlgPCN)
			oSize:AddObject( "CAB"		,  100, IIf(lForPCNF,35,20), .T., .T. ) // Totalmente dimensionavel
			oSize:AddObject( "LISTBOX" 	,  100, IIf(lForPCNF,65,80), .T., .T. ) // Totalmente dimensionavel
			oSize:lProp 	:= .T. // Proporcional             
			oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
				
			oSize:Process() 	   // Dispara os calculos
					
			oQual := TWBrowse():New(oSize:GetDimension("LISTBOX","LININI"),oSize:GetDimension("LISTBOX","COLINI"),;
				 				oSize:GetDimension("LISTBOX","XSIZE")-12,oSize:GetDimension("LISTBOX","YSIZE"),;
				 				,aCab,aTamCab,oDlgPCN,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayF4)
/*					
			If (!Empty(aArrayF4))				
				oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := iif(aArrayF4[oQual:nAt,1] == oNo, oOk, oNo) }
			EndIf
*/					
			If !Empty(aArrayF4)
				oQual:bLine := { || aArrayF4[oQual:nAT] }					
			Else
			    cLine := "{" +Replicate("'',",12) +"}"
			    bLine := &( "{ || " + cLine + " }" )					   
				oQual:bLine := bLine
			EndIf

			@ oSize:GetDimension("CAB","LININI")+2 ,oSize:GetDimension("CAB","COLINI")   SAY OemToAnsi("Produto") Of oDlgPCN PIXEL SIZE 47 ,9 //
			@ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI") +27 MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oDlgPCN PIXEL SIZE 100,9

			ACTIVATE MSDIALOG oDlgPCN CENTERED ON INIT EnchoiceBar(oDlgPCN,{|| nOpca:=1,oDlgPCN:End()},{||oDlgPCN:End()},,aButtons)
		Else
		   If Empty(aArrayF4)
		      MsgInfo( "Não encontrado pedidos em aberto" , "Item sem pedido em aberto" ) //Ita - 25/06/2019
		   EndIf
		Endif
	Else
		MsgInfo( "Não encontrado pedidos em aberto" , "Item sem pedido em aberto" )
//		Help(" ",1,"SEMPC",,"Não encontrado pedidos em aberto",4,,,,,,.F.)
	Endif
	dbSelectArea(cAliasSC7)
	dbCloseArea()
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ANItBlq(_cArqBlq)

Local _aArea := GetArea()
/* Ita - 10/06/2019
Local _cMsg1 := "Confirma o Bloqueio do Produto " + Alltrim((_cArqBlq)->TRB_COD) + " para não comprar"
Local _cMsg2 := "Confirma o Desbloqueio do Produto " + Alltrim((_cArqBlq)->TRB_COD) + " para habilitar a compra"
Local lRet := MsgYesNo(IIF((_cArqBlq)->TRB_BLQ == "S",_cMsg2, _cMsg1) ,"Bloqueio de Compra")
Local _cBlq := IIF((_cArqBlq)->TRB_BLQ == "S","N","S")
*/

LOCAL aPerg 	:= {}						// Array de parametros de acordo com a regra da ParamBox
LOCAL cTitulo	:= "Motivo" 		       // Titulo da janela de parametros
LOCAL aRet		:= {}						// Array que será passado por referencia e retornado com o conteudo de cada parametro
//LOCAL bOk		:= {|| }		            // Bloco de codigo para validacao do OK da tela de parametros
LOCAL aButtons	:= {}						// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
LOCAL lCentered	:= .T.						// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
LOCAL nPosx		    						// Posicao inicial -> linha (Linha final: nPosX+274)
LOCAL nPosy									// Posicao inicial -> coluna (Coluna final: nPosY+445)
LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
LOCAL lCanSave	:= .F.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .F.						// Se o usuário pode salvar sua propria configuracao
LOCAL nX		:= 0

_ldesbloq := .F.
If (_cArqBlq)->TRB_BLQ == "N"
   _cMsgBlq := "bloquear"
   _MsgDes  := ""
   _xMsg    := "Bloqueio"
Else
   _ldesbloq := .T.
   _cMsgBlq := "desbloquear"
   _MotBlq := Posicione("SBZ",1,cFilAnt+(_cArqBlq)->TRB_COD,"BZ_XMOTBL") //Ita - 12/06/2019 - alterado nome do campo BZ_MOTBLQ
   _DscBlq := Alltrim(Posicione("SX5",1,xFilial("SX5")+"9A"+_MotBlq,"X5_DESCRI"))
   _MsgDes := _MotBlq+" - " + _DscBlq
   _xMsg    := "Desbloqueio"
EndIf
_cMsg1 := "Confirma o Bloqueio do Produto " + Alltrim((_cArqBlq)->TRB_COD) + " para não comprar"
_cMsg2 := "Confirma o Desbloqueio do Produto " + Alltrim((_cArqBlq)->TRB_COD) + " para habilitar a compra "+_MsgDes
lRet := MsgYesNo(IIF((_cArqBlq)->TRB_BLQ == "S",_cMsg2, _cMsg1) ,_xMsg+" de Compra")
_cBlq := IIF((_cArqBlq)->TRB_BLQ == "S","N","S")
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array a ser passado para ParamBox quando tipo(6) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aPerg,{1,"Motivo: ","01"+SPACE(4),"@!","u_fVldMot()","9A" ,".T.",100,.T.}) //Ita - 17/07/2019 - O parâmetro sempre irá sugerir o bloqueio "01"-ITEM PARADO - Conforme solicitação de Gustavo.

If lRet
    /*
	RecLock(_cArqBlq,.F.)
	Replace TRB_BLQ with _cBlq
	MsUnLock()
	*/
	/* Ita - 27/05/2019 - Permitir bloqueio por filial
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial()+(_cArqBlq)->TRB_COD)
	*/
	//Ita - 30/05/2019 - If MsgYesNo("confirme esta ação apenas para a filial "+xFilial("SBZ")+" ou cancele para fazer em todas as filiais")

	//Ita - 10/07/2019 - If MsgYesNo("Tecle SIM para "+_cMsgBlq+" apenas a filial "+cFilAnt+" ou tecle NÃO para "+_cMsgBlq+" todas as filiais "+If(_ldesbloq,"Bloqueio Atual: "+_MsgDes,""))
	_nRetDesc := fDecsBlq()
	If _nRetDesc == 1
		dbSelectArea("SBZ")
		dbSetOrder(1)
		//Ita - 30/05/2019 - If dbSeek(xFilial("SBZ")+(_cArqBlq)->TRB_COD)
		If dbSeek(cFilAnt+(_cArqBlq)->TRB_COD)
			//RecLock("SB1",.F.)
			//Replace B1_XBLQPC with _cBlq
			If _ldesbloq
		            RecLock(_cArqBlq,.F.)
		            Replace TRB_BLQ with _cBlq
		            MsUnLock()
		            
					RecLock("SBZ",.F.)
					Replace BZ_XBLQPC with "",;//_cBlq,;
					        BZ_XMOTBL with ""//MV_PAR01  //Ita - 06/06/2019 - Ita - 12/06/2019 - BZ_MOTBLQ alterado nome do campo
					MsUnLock()
					//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
					//lGoTop := .F. 
                    //oMrkBrowse:Refresh(lGoTop)
                    oMrkBrowse:oBrowse:Refresh(.F.)
			Else
				If ParamBox(aPerg, cTitulo, aRet, , aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave) //Ita - 06/06/2019
		            RecLock(_cArqBlq,.F.)
		            Replace TRB_BLQ with _cBlq
		            MsUnLock()
		            
					RecLock("SBZ",.F.)
					Replace BZ_XBLQPC with _cBlq,;
					        BZ_XMOTBL with MV_PAR01  //Ita - 06/06/2019
					MsUnLock()
                    oMrkBrowse:oBrowse:Refresh(.F.)
				EndIf
			EndIf
		Endif
	ElseIf _nRetDesc == 2 //Ita - 10/07/2019 - Else
		If _ldesbloq
		        RecLock(_cArqBlq,.F.)
		        Replace TRB_BLQ with _cBlq
		        MsUnLock()
		        
				cUpdBZ := " UPDATE "+RetSQLName("SBZ") + _Enter
				cUpdBZ += "    SET BZ_XBLQPC = 'N'," + _Enter     //Ita - 27/06/2019 - Acrescentado espaços para evitar falha na intepretação do Oracle
				cUpdBZ += "        BZ_XMOTBL = '"+SPACE(6)+"'" + _Enter         //Ita - 06/06/2019
				cUpdBZ += "  WHERE BZ_COD = '"+(_cArqBlq)->TRB_COD+"'" + _Enter
				cUpdBZ += "    AND D_E_L_E_T_ <> '*'" + _Enter
		        
		        MemoWrite("C:\TEMP\cUpdSBZ.SQL",_cQuery) //Ita - 02/04/2019
		        MemoWrite("\Data\cUpdSBZ.SQL",_cQuery) //Ita - 02/04/2019
				
		        If TCSqlExec( cUpdBZ ) <> 0
		           MsgAlert( " Erro ao tentar atualizar status do Pedido " + TCSqlError() )   
		        EndIf		
				//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
				//lGoTop := .F. 
                //oMrkBrowse:Refresh(lGoTop)
                oMrkBrowse:oBrowse:Refresh(.F.)
		Else 
			If ParamBox(aPerg, cTitulo, aRet, , aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave) //Ita - 06/06/2019 
		        RecLock(_cArqBlq,.F.)
		        Replace TRB_BLQ with _cBlq
		        MsUnLock()
		        
				cUpdBZ := " UPDATE "+RetSQLName("SBZ") + _Enter
				cUpdBZ += "    SET BZ_XBLQPC = '"+_cBlq+"'," + _Enter
				cUpdBZ += "        BZ_XMOTBL = '"+MV_PAR01+"'" + _Enter         //Ita - 06/06/2019
				cUpdBZ += "  WHERE BZ_COD = '"+(_cArqBlq)->TRB_COD+"'" + _Enter
				cUpdBZ += "    AND D_E_L_E_T_ <> '*'" + _Enter
		        
		        MemoWrite("C:\TEMP\cUpdSBZ.SQL",_cQuery) //Ita - 02/04/2019
		        MemoWrite("\Data\cUpdSBZ.SQL",_cQuery) //Ita - 02/04/2019
				
		        If TCSqlExec( cUpdBZ ) <> 0
		           MsgAlert( " Erro ao tentar atualizar status do Pedido " + TCSqlError() )   
		        EndIf		
				//Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() //Ita - 15/04/2019
				//lGoTop := .F. 
                //oMrkBrowse:Refresh(lGoTop)
                oMrkBrowse:oBrowse:Refresh(.F.)
			EndIf
		EndIf
	EndIf
Endif
////////////////////
/// Ita - 01/03/2019
///     - Refresh da Legenda
/////////////////////////////
oDlgy:Refresh()
//oPanel:Refresh()
//Ita - 06/06/2019 - oMrkBrowse:Refresh:lGoTop := .F.
//lGoTop := .F. 
//oMrkBrowse:Refresh(lGoTop)
//Ita - 10/06/2019 - oMrkBrowse:Refresh(.F.)
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MC030Con ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que monta o arquivo de trabalho com as   ³±±
±±³          ³ movimentacoes e mostra-o na tela                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ANConKard(_cCodKard)

LOCAL aSalTel := {} ,nCusMed := 0 ,aSalIni := {}
LOCAL aArea:=GetArea()
Local cCadastro := OemtoAnsi("Consulta ao Kardex") //Ita - 10/07/2019
PRIVATE aGraph  := {}
PRIVATE aTrbP   := {}
PRIVATE aTrbTmp := {}
PRIVATE aTela   := {}
PRIVATE aSalAtu := { 0,0,0,0,0,0,0 }
PRIVATE cPictTotQT:=PesqPictQt("B2_QATU")
PRIVATE nTotSda := nTotEnt :=  nTotvSda := nTotvEnt  := 0
PRIVATE cTRBSD1 := CriaTrab(,.F.)
PRIVATE cTRBSD2 := Subs(cTRBSD1,1,7)+"A"
PRIVATE cTRBSD3 := Subs(cTRBSD1,1,7)+"B"
PRIVATE cPictQT := PesqPict("SB2","B2_QATU",18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lCusUnif := A330CusFil()
PRIVATE cFiltro := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta perguntas no SX1 a fim de preparar o relatorio p/     ³
//³ custo unificado por empresa                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusUnif
	MTC030CUnf()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera o desenho padrao de atualizacoes                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Ita - 10/07/2019 - Evitar uso da variável indevidamente em outras funções deste fonte - cCadastro := OemtoAnsi("Consulta ao Kardex")	//

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+_cCodKard)
If Pergunte("MTC030",.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava as movimentacoes no arquivo de trabalho                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Ita - 24/07/2019 - Processa({|| aSalTel := u_A_Mc030Con()},, "Kardex")
	Processa({|| aSalTel := u_A_Mc030Con(_cEmpr01)},, "Kardex")  //Ita - 24/07/2019 - Acrescentado passagem da variável _cEmpr01 para tratar filiais no prcessamento do kardesx
	/* Ita - 08/03/2019 - Este trecho já está sendo executado no fonte A_matc030.prx
	If Len(aTrbP) > 0
		
		If aSalTel[1] > 0 .AND. aSalTel[mv_par05+1] > 0
			nCusMed := aSalTel[mv_par05+1]/aSalTel[1]
		ElseIf aSalTel[1] == 0 .AND. aSalTel[mv_par05+1] == 0
			nCusMed := 0
		ElseIf aSalTel[1] < 0 .AND. aSalTel[mv_par05+1] < 0
			nCusMed := aSalTel[mv_par05+1]/aSalTel[1]
		Else
			nCusMed := aSalTel[mv_par05+1]
		Endif
		aAdd(aSalIni,Transf(aSaltel[1],PesqPict("SD1","D1_QUANT",18)))
		aAdd(aSalIni,Transf(nCusMed,PesqPict("SB2","B2_CM1")))
		aAdd(aSalIni,Transf(aSaltel[mv_par05+1],PesqPict("SB9","B9_VINI1")))
		MW030Brows(aSalIni)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga Arquivos Temporarios                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FERASE(cTrbSD1+GetDBExtension())
		FERASE(cTrbSD1+OrdbagExt())
		FERASE(cTrbSD2+GetDBExtension())
		FERASE(cTrbSD2+OrdbagExt())
		FERASE(cTrbSD3+GetDBExtension())
		FERASE(cTrbSD3+OrdbagExt())
	Else
		Help("",1,"MC030NOREC")
	EndIf
	*/
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Ordem Original do arquivo principal               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(1)
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ANPrdSim(_cProdPr,aStru)//Ita - 28/06/2019 - acrescentado aStru para facilitar apresentação dos similares (_cProdPr)

Local _aArea	:= GetArea()
Local aSizePed	:= {30,20,370,1350}
Local aCab	    := {}
Local aCampos	:= {}
Local aArrayF4  := {}
Local aButtons	:= {}
Local aTamCab	:= {}
cCadAnt := cCadastro
cCadastro := "Similares"
/* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
DbSelectArea("SX3")
DbSetOrder(2)
*/
DbSelectArea("TDIC")

MsSeek("GI_PRODALT")
cTitField := AllTrim(FWSX3Util():GetDescription( "GI_PRODALT" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(aCab,cTitField)//x3Titulo()
//_cContext := If( (CD2->(FieldPos("GI_PRODALT")) > 0) , "R","V") //Ita - 14/08/2019
Aadd(aCampos,{"GI_PRODALT",FWSX3Util():GetFieldType( "GI_PRODALT" ),"R",PesqPict( "SGI", "GI_PRODALT" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "GI_PRODALT" ),TamSX3("GI_PRODALT")[1],TamSX3("GI_PRODALT")[2],PesqPict( "SGI", "GI_PRODALT" ),cTitField))//X3Titulo()
MsSeek("B1_DESC")
cTitField := AllTrim(FWSX3Util():GetDescription( "B1_DESC" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(aCab,cTitField)//x3Titulo()
Aadd(aCampos,{"B1_DESC",FWSX3Util():GetFieldType( "B1_DESC" ),"R",PesqPict( "SB1", "B1_DESC" )})
//Ita - 20/06/2019 - aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
aadd(aTamCab,35)
MsSeek("ZZN_COD")
AAdd(aCab,"Fornecedor")
Aadd(aCampos,{"ZZN_COD",FWSX3Util():GetFieldType( "ZZN_COD" ),"R",PesqPict( "ZZN", "ZZN_COD" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "ZZN_COD" ),TamSX3("ZZN_COD")[1],TamSX3("ZZN_COD")[2],PesqPict( "ZZN", "ZZN_COD" ),"Fornecedor")) //X3Titulo()
MsSeek("B2_QATU")
cTitField := AllTrim(FWSX3Util():GetDescription( "B2_QATU" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(aCab,cTitField)//x3Titulo()
Aadd(aCampos,{"B2_QATU",FWSX3Util():GetFieldType( "B2_QATU" ),"R",PesqPict( "SB2", "B2_QATU" )})
//Ita - 20/06/2019 - aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B2_QATU" ),TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2],"@E 999,999,999.99",cTitField)) //X3Titulo()
MsSeek("C7_QUANT")
//Ita - 20/06/2019 - AAdd(aCab,x3Titulo())
AAdd(aCab,"Qtde.Ped") 
Aadd(aCampos,{"C7_QUANT",FWSX3Util():GetFieldType( "C7_QUANT" ),"R",PesqPict( "SC7", "C7_QUANT" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_QUANT" ),TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2],PesqPict( "SC7", "C7_QUANT" ),"Qtde.Ped"))//X3Titulo()
MsSeek("C6_PRCVEN")
//Ita - 20/06/2019 - AAdd(aCab,x3Titulo())
AAdd(aCab,"Prc Venda")
Aadd(aCampos,{"C6_PRCVEN",FWSX3Util():GetFieldType( "C6_PRCVEN" ),"R",PesqPict( "SC6", "C6_PRCVEN" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C6_PRCVEN" ),TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2],PesqPict( "SC6", "C6_PRCVEN" ),"Prc Venda"))//X3Titulo()
MsSeek("B2_CM1")
//Ita - 20/06/2019 - AAdd(aCab,x3Titulo())
AAdd(aCab,"Prc Custo")
Aadd(aCampos,{"B2_CM1",FWSX3Util():GetFieldType( "B2_CM1" ),"R",PesqPict( "SB2", "B2_CM1" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B2_CM1" ),TamSX3("B2_CM1")[1],TamSX3("B2_CM1")[2],PesqPict( "SB2", "B2_CM1" ),"Prc Custo"))//X3Titulo()


MsSeek("B3_Q01")
AAdd(aCab,_cMes04) //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_Q01",FWSX3Util():GetFieldType( "B3_Q01" ),"R",PesqPict( "SB3", "B3_Q01" )})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q01" ),TamSX3("B3_Q01")[1],TamSX3("B3_Q01")[2],PesqPict( "SB3", "B3_Q01" ),_cMes04)) //X3Titulo()
MsSeek("B3_Q02")
AAdd(aCab,_cMes03) //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_Q02",FWSX3Util():GetFieldType( "B3_Q02" ),"R",PesqPict( "SB3", "B3_Q02")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q02" ),TamSX3("B3_Q02")[1],TamSX3("B3_Q02")[2],PesqPict( "SB3", "B3_Q02"),_cMes03))//X3Titulo()
MsSeek("B3_Q03")
AAdd(aCab,_cMes02) //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_Q03",FWSX3Util():GetFieldType( "B3_Q03" ),"R",PesqPict( "SB3", "B3_Q03")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q03" ),TamSX3("B3_Q03")[1],TamSX3("B3_Q03")[2],PesqPict( "SB3", "B3_Q03"),_cMes02))//X3Titulo()
MsSeek("B3_Q04")
AAdd(aCab,_cMes01) //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_Q04",FWSX3Util():GetFieldType( "B3_Q04" ),"R",PesqPict( "SB3", "B3_Q04")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q04" ),TamSX3("B3_Q04")[1],TamSX3("B3_Q04")[2],PesqPict( "SB3", "B3_Q04"),_cMes01)) //X3Titulo()
MsSeek("B3_MEDIA")
AAdd(aCab,"TRIMES") //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_MEDIA",FWSX3Util():GetFieldType( "B3_MEDIA" ),"R",PesqPict( "SB3", "B3_MEDIA")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_MEDIA" ),TamSX3("B3_MEDIA")[1],TamSX3("B3_MEDIA")[2],PesqPict( "SB3", "B3_MEDIA"),"TRIMES")) //X3Titulo()

MsSeek("B3_MEDIA")
AAdd(aCab,"SEMES") //Ita - 28/06/2019 - x3Titulo())
Aadd(aCampos,{"B3_MEDIA",FWSX3Util():GetFieldType( "B3_MEDIA" ),"R",PesqPict( "SB3", "B3_MEDIA")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_MEDIA" ),TamSX3("B3_MEDIA")[1],TamSX3("B3_MEDIA")[2],PesqPict( "SB3", "B3_MEDIA"),"SEMES"))//X3Titulo()

MsSeek("DA1_XLETRA")
cTitField := AllTrim(FWSX3Util():GetDescription( "DA1_XLETRA" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(aCab,cTitField) //x3Titulo()
Aadd(aCampos,{"DA1_XLETRA",FWSX3Util():GetFieldType( "DA1_XLETRA" ),"R",PesqPict( "DA1", "DA1_XLETRA")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "DA1_XLETRA" ),TamSX3("DA1_XLETRA")[1],TamSX3("DA1_XLETRA")[2],PesqPict( "DA1", "DA1_XLETRA"),cTitField))//X3Titulo()

MsSeek("DA1_XDESCV")
cTitField := AllTrim(FWSX3Util():GetDescription( "DA1_XDESCV" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(aCab,cTitField) //x3Titulo()
Aadd(aCampos,{"DA1_XDESCV",FWSX3Util():GetFieldType( "DA1_XDESCV" ),"R",PesqPict( "DA1", "DA1_XDESCV")})
aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "DA1_XDESCV" ),TamSX3("DA1_XDESCV")[1],TamSX3("DA1_XDESCV")[2],PesqPict( "DA1", "DA1_XDESCV"),cTitField))//X3Titulo()

SB1->(DbSetOrder(1))
SB1->(MsSeek(xFilial("SB1")+_cProdPr))

//////////////////////////////
/// Ita - 20/06/2019
///     - Acrescentar o próprio item pesquisado no grid de similares.
Aadd(aArrayF4,Array(Len(aCampos)))
aArrayF4[Len(aArrayF4)][1] := _cProdPr
aArrayF4[Len(aArrayF4)][2] := Posicione("SB1",1,xFilial("SB1")+_cProdPr,"B1_DESC")
_cMrcPrd := Posicione("SB1",1,xFilial("SB1")+PadR(_cProdPr,15),"B1_XMARCA")              //Ita - 28/06/2019 - Tratamento para apresentar nome do Fornecedor
_cCdForn := Posicione("ZZM",2,xFilial("ZZM")+PadR(_cMrcPrd,5),"ZZM_FORNEC")            //Ita - 28/06/2019 -     "                      "
_cNmeFor := Substr(Posicione("SA2",1,xFilial("SA2")+PadR(_cCdForn,6),"A2_NOME"),1,30)  //Ita - 28/06/2019 -     "                      "

aArrayF4[Len(aArrayF4)][3] := _cNmeFor //Ita - 28/06/2019 - "TESTE"
aDadsTb := fPsqTbPr(cfilant,_cProdPr,dDataBase)
_cLocPad := Posicione("SB1",1,xFilial("SB1")+PadR(_cProdPr,15),"B1_LOCPAD")
_cLocPad := Posicione("SB1",1,xFilial("SB1")+PadR(_cProdPr,15),"B1_LOCPAD")
_cEMestre := Posicione("SB1",1,xFilial("SB1")+PadR(_cProdPr,15),"B1_XMESTRE")
aArrayF4[Len(aArrayF4)][4] := fRetSld(_cProdPr,_cLocPad,_cEMestre) //Ita - 28/06/2019 - Calcula Saldo do Produto - sendo mestre ou não
_xPC := fProdPC(_cProdPr,,,,,,,,, , ,, ,cfilant) //Ita - 14/06/2019 - Função adaptada para tratar quantidade do produto em pedidos de compras abertos. 
aConsProd := fConsProd(aStru, _aMes,_cProdPr)                 //Ita - 28/06/2019 - Calculo do Consumo do produto posicionado
aArrayF4[Len(aArrayF4)][05] := _xPC       //Ita - 28/06/2019
aArrayF4[Len(aArrayF4)][06] := aDadsTb[3] //Ita - 28/06/2019 - Preço de Vendas - 0
aArrayF4[Len(aArrayF4)][07] := aDadsTb[4] //Ita - 28/06/2019 - Preço de Reposição - 0
aArrayF4[Len(aArrayF4)][08] := 0
aArrayF4[Len(aArrayF4)][09] := 0
aArrayF4[Len(aArrayF4)][10] := 0
aArrayF4[Len(aArrayF4)][11] := 0
aArrayF4[Len(aArrayF4)][12] := aConsProd[2] //Ita - 28/06/2019 - Média Trimestral
aArrayF4[Len(aArrayF4)][13] := aConsProd[3] //Ita - 28/06/2019 - Média Semestral
aArrayF4[Len(aArrayF4)][14] := aDadsTb[1]
aArrayF4[Len(aArrayF4)][15] := aDadsTb[2]

aCsmMes := aClone( aConsProd[1] ) //Ita - 02/07/2019 - implementado aClone
aCsmMes := aSort(aCsmMes,,, { | x,y | x[1] > y[1] }) //Ordenar por Mês
For nCs := 1 To Len(aCsmMes)
   _nPsMes := aScan(aCab, aCsmMes[nCs,3])
   If _nPsMes > 0
      aArrayF4[Len(aArrayF4)][_nPsMes] := aCsmMes[nCs,2]
   EndIf
Next nCs
/// Ita - 20/06/2019 Fim da implementação para apresentar o próprio item no grid ///////////////////////
dbSelectArea("SGI")
dbSetOrder(1)
dbSeek(xFilial()+_cProdPr)
While !Eof() .and. xFilial("SGI")+_cProdPr == SGI->(GI_FILIAL+GI_PRODORI)
	Aadd(aArrayF4,Array(Len(aCampos)))
	aArrayF4[Len(aArrayF4)][1] := SGI->GI_PRODALT
	aArrayF4[Len(aArrayF4)][2] := Posicione("SB1",1,xFilial("SB1")+SGI->GI_PRODALT,"B1_DESC")
	_cMrcPrd := Posicione("SB1",1,xFilial("SB1")+SGI->GI_PRODALT,"B1_XMARCA")              //Ita - 28/06/2019 - Tratamento para apresentar nome do Fornecedor
	_cCdForn := Posicione("ZZM",2,xFilial("ZZM")+PadR(_cMrcPrd,5),"ZZM_FORNEC")            //Ita - 28/06/2019 -     "                      "
	_cNmeFor := Substr(Posicione("SA2",1,xFilial("SA2")+PadR(_cCdForn,6),"A2_NOME"),1,30)  //Ita - 28/06/2019 -     "                      "
	aArrayF4[Len(aArrayF4)][3] := _cNmeFor //Ita - 28/06/2019 - "TESTE"
	aDadsTb := fPsqTbPr(cfilant,SGI->GI_PRODALT,dDataBase)
	_cLocPad := Posicione("SB1",1,xFilial("SB1")+SGI->GI_PRODALT,"B1_LOCPAD")
	_cEMestre := Posicione("SB1",1,xFilial("SB1")+SGI->GI_PRODALT,"B1_XMESTRE")
	aArrayF4[Len(aArrayF4)][4] := fRetSld(SGI->GI_PRODALT,_cLocPad,_cEMestre) //Ita - 28/06/2019 - Calcula Saldo do Produto - sendo mestre ou não
	/* Ita - 28/06/2019 - Comentado para fazer calculo do produto considerando se produto tem código mestre ou não.
	dbSelectArea("SB2")
	dbSetOrder(1)
	//Ita - 30/05/2019 - If dbSeek(xFilial()+SGI->GI_PRODALT+_cLocPad)
	If dbSeek(cFilAnt+SGI->GI_PRODALT+_cLocPad)
		aArrayF4[Len(aArrayF4)][4] := SB2->B2_QATU
	Else
		aArrayF4[Len(aArrayF4)][4] := 0
	Endif
	*/
	_xPC := fProdPC(SGI->GI_PRODALT,,,,,,,,, , ,, ,cfilant) //Ita - 14/06/2019 - Função adaptada para tratar quantidade do produto em pedidos de compras abertos. 
	aConsProd := fConsProd(aStru, _aMes,SGI->GI_PRODALT)                 //Ita - 28/06/2019 - Calculo do Consumo do produto posicionado
	
	aArrayF4[Len(aArrayF4)][05] := _xPC //Ita - 28/06/2019 - 0
    aArrayF4[Len(aArrayF4)][06] := aDadsTb[3] //Ita - 28/06/2019 - Preço de Vendas - 0
    aArrayF4[Len(aArrayF4)][07] := aDadsTb[4] //Ita - 28/06/2019 - Preço de Reposição - 0
	aArrayF4[Len(aArrayF4)][08] := 0
	aArrayF4[Len(aArrayF4)][09] := 0
	aArrayF4[Len(aArrayF4)][10] := 0
	aArrayF4[Len(aArrayF4)][11] := 0
    aArrayF4[Len(aArrayF4)][12] := aConsProd[2] //Ita - 28/06/2019 - Média Trimestral
    aArrayF4[Len(aArrayF4)][13] := aConsProd[3] //Ita - 28/06/2019 - Média Semestral
    aArrayF4[Len(aArrayF4)][14] := aDadsTb[1]
    aArrayF4[Len(aArrayF4)][15] := aDadsTb[2]
	aCsmMes := aClone( aConsProd[1] ) //Ita - 02/07/2019 - implementado aClone
	aCsmMes := aSort(aCsmMes,,, { | x,y | x[1] > y[1] }) //Ordenar por Mês
	For nCs := 1 To Len(aCsmMes)
	   _nPsMes := aScan(aCab, aCsmMes[nCs,3])
	   If _nPsMes > 0
	      aArrayF4[Len(aArrayF4)][_nPsMes] := aCsmMes[nCs,2]
	   EndIf
	Next nCs
	dbSelectArea("SGI")
	dbSkip()
EndDo
If !Empty(aArrayF4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dinamicamente o bline do CodeBlock                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlgSIM FROM aSizePed[1],aSizePed[2] TO aSizePed[3],aSizePed[4] TITLE OemToAnsi("Produtos Similares/Substitutos") Of oMainWnd PIXEL
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New(.T.,,,oDlgSIM)
	oSize:AddObject( "CAB"		,  100, 20, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "LISTBOX" 	,  100, 80, .T., .T. ) // Totalmente dimensionavel
	oSize:lProp 	:= .T. // Proporcional             
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
				
	oSize:Process() 	   // Dispara os calculos
					
	oQual := TWBrowse():New(oSize:GetDimension("LISTBOX","LININI"),oSize:GetDimension("LISTBOX","COLINI"),;
		 				oSize:GetDimension("LISTBOX","XSIZE")-12,oSize:GetDimension("LISTBOX","YSIZE"),;
		 				,aCab,aTamCab,oDlgSIM,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oQual:SetArray(aArrayF4)

	If !Empty(aArrayF4)
		oQual:bLine := { || aArrayF4[oQual:nAT] }					
	Else
	    cLine := "{" +Replicate("'',",12) +"}"
	    bLine := &( "{ || " + cLine + " }" )					   
		oQual:bLine := bLine
	EndIf

	@ oSize:GetDimension("CAB","LININI")+2 ,oSize:GetDimension("CAB","COLINI")   SAY OemToAnsi("Produto") Of oDlgSIM PIXEL SIZE 47 ,9 //
	@ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI") +27 MSGET _cProdPr PICTURE PesqPict('SB1','B1_COD') When .F. Of oDlgSIM PIXEL SIZE 100,9

	ACTIVATE MSDIALOG oDlgSIM CENTERED ON INIT EnchoiceBar(oDlgSIM,{|| nOpca:=1,oDlgSIM:End()},{||oDlgSIM:End()},,aButtons)
Else
	Help(" ",1,"SIMILPROD",,"Não cadastrado produtos similares para o produto: " + Alltrim(_cProdPr),4,,,,,,.F.)
Endif
cCadastro := cCadAnt
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ANPrdApl(_cProdApl)

Local _aArea    := GetArea()
Local _cCodPlic := Posicione("SB1",1,xFilial("SB1")+_cProdApl,"B1_XCODAPL")
Local _cDscPlic := Posicione("SB1",1,xFilial("SB1")+_cProdApl,"B1_DESC")
Local _cAplic   := ""
If !Empty(_cCodPlic)
	_cAplic	:= MSMM( _cCodPlic, TAMSX3("YP_TEXTO")[1] )
	DEFINE MSDIALOG oDlg1 TITLE "Aplicação p/: " + Alltrim(_cProdApl) + " - " + Alltrim(_cDscPlic) From 3,0 to 340,717 PIXEL
	@ 5,5 GET oMemo  VAR _cAplic MEMO SIZE 350,145 OF oDlg1 PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
//		oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,115 TYPE 1 ACTION (_lRet:=.t.,oDlg1:End()) ENABLE OF oDlg1 PIXEL
	DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION oDlg1:End() ENABLE OF oDlg1 PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTER
Else
	Help(" ",1,"APLICPROD",,"Aplicação não cadastrada para o produto: " + Alltrim(_cProdApl) + " - " + Alltrim(_cDscPlic),4,,,,,,.F.)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUT_PC    ºAutor  ³Microsiga           º Data ³  08/16/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ANCOnDem(_cPrdDem)

Local _aArea := GetArea()
//Ita - 05/06/2019 - Local _cMesVend := " "
Local cAliasSD2 := "QRYSD2"
Local _aArea	:= GetArea()
//Ita - 13/06/2019 - Local aSizePed	:= {30,20,370,800}
Local aSizePed	:= {30,20,370,1000}
Local axCab	    := {}
Local axCampos	:= {}
Local axArrayF4  := {}
Local aButtons	:= {}
Local axTamCab	:= {}
Local _cAlmox	:= Posicione("SB1",1,xFilial("SB1")+_cPrdDem,"B1_LOCPAD")
Local _nSaldo 	:= 0
Local _nPC		:= 0
Local cCadAnt	:= cCadastro
Local _cEmpANL	:= Space(06)
cCadastro := "Consumo por Empresa"
////////////////////////////////////////////////
/// Ita - 07/06/2019
///     - Acrescentar filiais sem movimentação
///     - na consulta. Solicitação: Décio

aSM0 := FWLoadSM0(.T.)
_xFilSel := "("
For nX:=1 To Len(aSM0)
    If !Empty(fGetFil(Alltrim(aSM0[nX][SM0_FILIAL]),1))
       _xFilSel += "'"+Alltrim(aSM0[nX][SM0_FILIAL])+If(nX<Len(aSM0),"',","'")
    EndIf
Next nX
if substr(_xFilSel,len(_xFilSel))=","
	_xFilSel :=substr(_xFilSel,1,len(_xFilSel)-1)
endif
_xFilSel += ")"

/* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
DbSelectArea("SX3")
DbSetOrder(2)
*/
DbSelectArea("TDIC")
AAdd(axCab,"EMP") //01
Aadd(axCampos,{"_CEMP","C","R"," "})
aadd(axTamCab,4)

MsSeek("B2_QATU") //02
cTitField := AllTrim(FWSX3Util():GetDescription( "B2_QATU" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
AAdd(axCab,cTitField)//x3Titulo()
Aadd(axCampos,{"B2_QATU",FWSX3Util():GetFieldType( "B2_QATU" ),"R",PesqPict( "SB2", "B2_QATU")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B2_QATU" ),TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2],PesqPict( "SB2", "B2_QATU"),cTitField))//X3Titulo()

MsSeek("C7_QUANT") //03
//Ita - 14/06/2019 - AAdd(axCab,x3Titulo())
AAdd(axCab,"Qtde.Ped")
Aadd(axCampos,{"C7_QUANT",FWSX3Util():GetFieldType( "C7_QUANT" ),"R",PesqPict( "SC7", "C7_QUANT")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_QUANT" ),TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2],PesqPict( "SC7", "C7_QUANT"),"Qtde.Ped"))//X3Titulo()

////////////////////////////////////////////////////////////////////
/// Ita - 20/06/2019 - Localizar a descrição do mês que não aparece 
//_nAcho := aScan(_aMes,{|x| AllTrim(x[1])==StrZero(_nMesFim,2)})
_nAcho := aScan(_aMes,{|x| AllTrim(x[2])==_cMes06})
If Alltrim(_aMes[_nAcho,2]) == "JAN"
   _xDscMes := "DEZ"
Else
   _xDscMes := _aMes[_nAcho-1,2]
EndIf
MsSeek("B3_Q01")  //04 
_cMes07 := _xDscMes //Ita - 25/06/2019
AAdd(axCab,_xDscMes) //_cMes07)
Aadd(axCampos,{"B3_Q01",FWSX3Util():GetFieldType( "B3_Q01" ),"R",PesqPict( "SB3", "B3_Q01")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q01" ),TamSX3("B3_Q01")[1],TamSX3("B3_Q01")[2],PesqPict( "SB3", "B3_Q01"),_xDscMes)) //X3Titulo()

MsSeek("B3_Q02")  //05
AAdd(axCab,_cMes06)
Aadd(axCampos,{"B3_Q02",FWSX3Util():GetFieldType( "B3_Q02" ),"R",PesqPict( "SB3", "B3_Q02")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q02" ),TamSX3("B3_Q02")[1],TamSX3("B3_Q02")[2],PesqPict( "SB3", "B3_Q02"),_cMes06))//X3Titulo()

MsSeek("B3_Q03")  //06
AAdd(axCab,_cMes05)
Aadd(axCampos,{"B3_Q03",FWSX3Util():GetFieldType( "B3_Q03" ),"R",PesqPict( "SB3", "B3_Q03")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q03" ),TamSX3("B3_Q03")[1],TamSX3("B3_Q03")[2],PesqPict( "SB3", "B3_Q03"),_cMes05))//X3Titulo()

MsSeek("B3_Q04") //07 //Ita - 13/06/2019 - MsSeek("B3_Q01")
AAdd(axCab,_cMes04)
Aadd(axCampos,{"B3_Q04",FWSX3Util():GetFieldType( "B3_Q04" ),"R",PesqPict( "SB3", "B3_Q04")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q04" ),TamSX3("B3_Q04")[1],TamSX3("B3_Q04")[2],PesqPict( "SB3", "B3_Q04"),_cMes04))//X3Titulo()

MsSeek("B3_Q05") //08 //Ita - 13/06/2019 - MsSeek("B3_Q02")
AAdd(axCab,_cMes03)
Aadd(axCampos,{"B3_Q05",FWSX3Util():GetFieldType( "B3_Q05" ),"R",PesqPict( "SB3", "B3_Q05")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q05" ),TamSX3("B3_Q05")[1],TamSX3("B3_Q05")[2],PesqPict( "SB3", "B3_Q05"),_cMes03))//X3Titulo()

MsSeek("B3_Q06") //09 //Ita - 13/06/2019 - MsSeek("B3_Q03")
AAdd(axCab,_cMes02)
Aadd(axCampos,{"B3_Q06",FWSX3Util():GetFieldType( "B3_Q06" ),"R",PesqPict( "SB3", "B3_Q06")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q06" ),TamSX3("B3_Q06")[1],TamSX3("B3_Q06")[2],PesqPict( "SB3", "B3_Q06"),_cMes02)) //X3Titulo()

MsSeek("B3_Q07") //10 //Ita - 13/06/2019 - MsSeek("B3_Q04")
AAdd(axCab,_cMes01)
Aadd(axCampos,{"B3_Q07",FWSX3Util():GetFieldType( "B3_Q07" ),"R",PesqPict( "SB3", "B3_Q07")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_Q07" ),TamSX3("B3_Q07")[1],TamSX3("B3_Q07")[2],PesqPict( "SB3", "B3_Q07"),_cMes01))//X3Titulo()

MsSeek("B3_MEDIA") //11
AAdd(axCab,"TRIMS")
Aadd(axCampos,{"_CTRIMES",FWSX3Util():GetFieldType( "B3_MEDIA" ),"R",PesqPict( "SB3", "B3_MEDIA")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_MEDIA" ),TamSX3("B3_MEDIA")[1],TamSX3("B3_MEDIA")[2],PesqPict( "SB3", "B3_MEDIA"),"TRIMS"))//X3Titulo()

MsSeek("B3_MEDIA") //12
AAdd(axCab,"SEMES")
Aadd(axCampos,{"_CSEMES",FWSX3Util():GetFieldType( "B3_MEDIA" ),"R",PesqPict( "SB3", "B3_MEDIA")})
aadd(axTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "B3_MEDIA" ),TamSX3("B3_MEDIA")[1],TamSX3("B3_MEDIA")[2],PesqPict( "SB3", "B3_MEDIA"),"SEMES")) //X3Titulo()
//Ita - 05/06/2019 - MsgInfo("_cMesVTri: "+_cMesVTri+" _cMesVend: "+_cMesVend)
If Trim(TcGetDb()) = 'ORACLE'
	_cQuery := "SELECT D2_FILIAL, SUBSTR(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter
Else
	_cQuery := "SELECT D2_FILIAL, SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter
Endif
_cQuery += " FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 " + _Enter
//Ita - 03/06/2019 - Traz o consumo de todas as filiais - Solicit. Décio. _cQuery += " WHERE D2_FILIAL IN " + _cFilSel
_cQuery += " WHERE D2_FILIAL IN " + _xFilSel //Ita - 12/06/2019 - _cFilSel
//Ita - 05/06/2019 - _cQuery += " WHERE D2_FILIAL BETWEEN '      ' AND 'zzzzzz' " + _Enter
//_cQuery += " WHERE D2_FILIAL BETWEEN '      ' AND 'zzzzzz' " + _Enter
If Substr(aPCRev[35],1,1) == "T" + _Enter
	If Trim(TcGetDb()) = 'ORACLE'
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVTri  + " " + _Enter
	Else
		_cQuery += " AND SUBSTRING(D2_EMISSAO,1,6) IN " + _cMesVTri + " " + _Enter
	Endif
Else
	If Trim(TcGetDb()) = 'ORACLE'
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVend + " " + _Enter 
	Else
		_cQuery += " AND SUBSTRING(D2_EMISSAO,1,6) IN " + _cMesVend + " "  + _Enter
	Endif
Endif
_cQuery += " AND D2_COD = '" + _cPrdDem + "'" + _Enter
_cQuery += " AND SD2.D_E_L_E_T_ = ' '" + _Enter
_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
_cQuery += " AND B1_COD = D2_COD" + _Enter
_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
_cQuery += " AND D2_TES = F4_CODIGO" + _Enter
_cQuery += " AND F4_TRANFIL <> '1'" + _Enter
_cQuery += " AND F4_ESTOQUE = 'S'" + _Enter
_cQuery += " AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
_cQuery += " AND SF4.D_E_L_E_T_ = ' '" + _Enter
If Trim(TcGetDb()) = 'ORACLE'
	_cQuery += " GROUP BY D2_FILIAL, SUBSTR(D2_EMISSAO,1,6)" + _Enter
	_cQuery += " ORDER BY D2_FILIAL, SUBSTR(D2_EMISSAO,1,6)" + _Enter
Else
	_cQuery += " GROUP BY D2_FILIAL, SUBSTRING(D2_EMISSAO,1,6)" + _Enter
	_cQuery += " ORDER BY D2_FILIAL, SUBSTRING(D2_EMISSAO,1,6)" + _Enter
Endif
MemoWrite("C:\TEMP\Aut_PC_cAliasSD2_4.SQL",_cQuery)//Ita - 02/04/2019
MemoWrite("\Data\Aut_PC_cAliasSD2_4.SQL",_cQuery)//Ita - 02/04/2019
_cQuery := ChangeQuery(_cQuery)
//mEMOwRITE("C:\walter\Aut_PC.txt",_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSD2,.T.,.T.)
dbSelectArea(cAliasSD2)
While !Eof()
	_cFilia := Substr((cAliasSD2)->D2_FILIAL,1,6)
	_cEmpANL := fGetFil(_cFilia,1) //Ita - 07/06/2019 - u_AnFilAN(_cFilia)
	_nSaldo := 0
	
	////////////////////////////////////////////
	/// Ita - 09/04/2019
	///     - Cálcula saldo pelo código mestre
	/*
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(_cFilia+_cPrdDem+_cAlmox)
		_nSaldo := SB2->B2_QATU
	Endif
	*/
	aProdMestre := fAgrupMest(_cPrdDem)
	If Empty(aProdMestre)
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(_cFilia+PadR(_cPrdDem,15)+_cAlmox)
			_nSaldo := SB2->B2_QATU
		Endif
	Else	
		For nRn := 1 To Len(aProdMestre)
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(_cFilia+PadR(aProdMestre[nRn,1],15)+_cAlmox)
			    _xSlMst := SB2->B2_QATU 
				_nSaldo += _xSlMst
			Endif
		Next nRn
	EndIf
	dbSelectArea(cAliasSD2)
	Aadd(axArrayF4,Array(Len(axCampos)))
	axArrayF4[Len(axArrayF4)][04] := 0
	axArrayF4[Len(axArrayF4)][05] := 0
	axArrayF4[Len(axArrayF4)][06] := 0
	axArrayF4[Len(axArrayF4)][07] := 0
	axArrayF4[Len(axArrayF4)][08] := 0
	axArrayF4[Len(axArrayF4)][09] := 0
	axArrayF4[Len(axArrayF4)][10] := 0   //Ita - 13/06/2019
	axArrayF4[Len(axArrayF4)][11] := 0   //Ita - 14/06/2019
	axArrayF4[Len(axArrayF4)][12] := 0   //Ita - 14/06/2019
	While !Eof() .and. _cFilia == (cAliasSD2)->D2_FILIAL
		_cAnoMes := (cAliasSD2)->ANOMES
		_nQuant  := (cAliasSD2)->D2_QUANT
		_nPC := fProdPC(_cPrdDem,,,,,,,,, , ,, ,_cFilia) //Ita - 14/06/2019 - Função adaptada para tratar quantidade do produto em pedidos de compras abertos.
		axArrayF4[Len(axArrayF4)][01] := _cEmpANL
		axArrayF4[Len(axArrayF4)][02] := _nSaldo
		axArrayF4[Len(axArrayF4)][03] := _nPC
		_cMes    := Substr(_cAnoMes,5,2)
		_nAcho   := aScan(_aMes,{|x| AllTrim(x[1])==_cMes})
		_cTitulo := _aMes[_nAcho,2]
		//_PsMes := aScan(axCab,{|x| AllTrim(x[1])==_cTitulo})//Ita - 12/06/2019
		_PsMes := aScan(axCab,_cTitulo)//Ita - 12/06/2019
		If _PsMes > 0
		   //Ita - 12/06/2019 - axArrayF4[Len(v)][_nAcho-1] := _nQuant
		   axArrayF4[Len(axArrayF4)][_PsMes] := _nQuant //Ita - 12/06/2019
		EndIf
		//////////////////////////////
		/// Ita - 13/06/2019
		///     - Calculando média trimestral
		///     - e semestral
		//Ita - 14/06/2019 - delocado para dentro do while
		If Substr(_cMesCor,1,1) == "S"
			/* Ita - 19/06/2019
			_nMd3 := INT((axArrayF4[Len(axArrayF4)][10] + axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08])/ 3)
			_nMd6 := INT((axArrayF4[Len(axArrayF4)][10] + axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07] + axArrayF4[Len(axArrayF4)][06] + axArrayF4[Len(axArrayF4)][05]) / 6)
			*/
			_nMd3 := Round(((axArrayF4[Len(axArrayF4)][10] + axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08])/ 3),0)
			_nMd6 := Round(((axArrayF4[Len(axArrayF4)][10] + axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07] + axArrayF4[Len(axArrayF4)][06] + axArrayF4[Len(axArrayF4)][05]) / 6),0)
		Else
		    /* Ita - 19/06/2019
			_nMd3 := INT((axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07])/ 3)
			_nMd6 := INT((axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07] + axArrayF4[Len(axArrayF4)][06] + axArrayF4[Len(axArrayF4)][05] + axArrayF4[Len(axArrayF4)][04]) / 6)
			*/
			_nMd3 := Round(((axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07])/ 3),0)
			_nMd6 := Round(((axArrayF4[Len(axArrayF4)][09] + axArrayF4[Len(axArrayF4)][08] + axArrayF4[Len(axArrayF4)][07] + axArrayF4[Len(axArrayF4)][06] + axArrayF4[Len(axArrayF4)][05] + axArrayF4[Len(axArrayF4)][04]) / 6),0)			
		Endif
		axArrayF4[Len(axArrayF4)][11] := _nMd3   //Ita - 13/06/2019
		axArrayF4[Len(axArrayF4)][12] := _nMd6   //Ita - 13/06/2019
		dbSelectArea(cAliasSD2)
		dbSkip()
	End

End
dbSelectArea(cAliasSD2)
dbCloseArea()
////////////////////////////////////////////////
/// Ita - 07/06/2019
///     - Acrescentar filiais sem movimentação
///     - na consulta. Solicitação: Décio

aSM0 := FWLoadSM0(.T.)
aRunFil := {}
For nX:=1 To Len(aSM0)
    yFilPrt := Substr(aSM0[nX][02],1,6)
    //MsgInfo("Filiais: "+Alltrim(yFilPrt))
    _xANLFil := fGetFil(yFilPrt,1)
    //MsgInfo("Retorno ANL: "+_xANLFil)
    cpare:=""
    If !Empty(_xANLFil)
       aAdd(aRunFil,{_xANLFil,yFilPrt})
    EndIf
Next nX
For nwX:=1 To Len(aRunFil)  
        //MsgInfo("Percorrendo aRunFil - item: "+Alltrim(Str(nwX)))
		//For nV := 1 To Len(axArrayF4)
		//    MsgInfo("Pesquisando dentro do axArrayF4["+Alltrim(Str(nV))+"] - Filial: "+aRunFil[nwX])
		    cpare:=""
			//_nPosFil := aScan(axArrayF4[nV], {|x| x[1] == aRunFil[nwX]})
			_nPosFil := aScan(axArrayF4, {|x| x[1] == aRunFil[nwX,1]})
			//MsgInfo("Filial "+aRunFil[nwX,1]+" encontrada no array axArrayF4 - posição: "+Alltrim(Str(_nPosFil)))
			If _nPosFil == 0

				aProdMestre := fAgrupMest(_cPrdDem)
				_nSaldo 	:= 0
				If Empty(aProdMestre)
					dbSelectArea("SB2")
					dbSetOrder(1)
					If dbSeek(aRunFil[nwX,2]+PadR(_cPrdDem,15)+_cAlmox)
						_nSaldo := SB2->B2_QATU
					Endif
				Else	
					For nRn := 1 To Len(aProdMestre)
						dbSelectArea("SB2")
						dbSetOrder(1)
						If dbSeek(aRunFil[nwX,2]+PadR(aProdMestre[nRn,1],15)+_cAlmox)
						    _xSlMst := SB2->B2_QATU 
							_nSaldo += _xSlMst
						Endif
					Next nRn
				EndIf
				
				_nPC := fProdPC(_cPrdDem,,,,,,,,, , ,, ,aRunFil[nwX,2]) //Ita - 14/06/2019 - Função adaptada para tratar quantidade do produto em pedidos de compras abertos.
				
				Aadd(axArrayF4,Array(Len(axCampos)))
				axArrayF4[Len(axArrayF4)][01] := aRunFil[nwX,1] //_xANLFil
				axArrayF4[Len(axArrayF4)][02] := _nSaldo
				axArrayF4[Len(axArrayF4)][03] := _nPC
				axArrayF4[Len(axArrayF4)][04] := 0
				axArrayF4[Len(axArrayF4)][05] := 0
				axArrayF4[Len(axArrayF4)][06] := 0
				axArrayF4[Len(axArrayF4)][07] := 0
				axArrayF4[Len(axArrayF4)][08] := 0
				axArrayF4[Len(axArrayF4)][09] := 0
				axArrayF4[Len(axArrayF4)][10] := 0   //Ita - 14/06/2019
				axArrayF4[Len(axArrayF4)][11] := 0   //Ita - 14/06/2019 
				axArrayF4[Len(axArrayF4)][12] := 0   //Ita - 14/06/2019 
				nV := Len(axArrayF4) + 1 //Ita - 13/06/2019 - Força saída do array axArrayF4
				//Exit
		       //MsgInfo("Adicionei "+aRunFil[nwX,1]+" no "+axArrayF4)
			//Else
			   //MsgInfo("Filial "+aRunFil[nwX,1]+" já existe no array axArrayF4")
			EndIf
		//Next nV
Next nwX
aTmpArrF4 := {} //Retirar linhas em branco
For nLB := 1 To Len(axArrayF4)
   If !Empty(axArrayF4[nLB,1])
      aAdd(aTmpArrF4, {axArrayF4[nLB,1],axArrayF4[nLB,2],axArrayF4[nLB,3],axArrayF4[nLB,4],axArrayF4[nLB,5],axArrayF4[nLB,6],axArrayF4[nLB,7],axArrayF4[nLB,8],axArrayF4[nLB,9],axArrayF4[nLB,10],axArrayF4[nLB,11],axArrayF4[nLB,12]})//Ita - 14/0/2019 - Acrescentado os elementos 10,11,12 para também ser apresentado todas as colunas do grid.
   EndIf
Next nLB
axArrayF4 := {}
For nLB := 1 To Len(aTmpArrF4)
   aAdd(axArrayF4, {aTmpArrF4[nLB,1],aTmpArrF4[nLB,2],aTmpArrF4[nLB,3],aTmpArrF4[nLB,4],aTmpArrF4[nLB,5],aTmpArrF4[nLB,6],aTmpArrF4[nLB,7],aTmpArrF4[nLB,8],aTmpArrF4[nLB,9],aTmpArrF4[nLB,10],aTmpArrF4[nLB,11],aTmpArrF4[nLB,12]})//Ita - 14/0/2019 - Acrescentado os elementos 10,11,12 para também ser apresentado todas as colunas do grid.
Next nLB

axArrayF4 := ASort(axArrayF4,,, { | x,y | x[1] < y[1] }) //Ita - 07/06/2019 - Ordena por Filiais ascendente

If !Empty(axArrayF4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dinamicamente o bline do CodeBlock                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlgCs FROM aSizePed[1],aSizePed[2] TO aSizePed[3],aSizePed[4] TITLE OemToAnsi("Consumo por Empresa") Of oMainWnd PIXEL
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New(.T.,,,oDlgCs)
	oSize:AddObject( "CAB"		,  100, 20, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "LISTBOX" 	,  100, 80, .T., .T. ) // Totalmente dimensionavel
	oSize:lProp 	:= .T. // Proporcional             
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
				
	oSize:Process() 	   // Dispara os calculos
					
	oQual := TWBrowse():New(oSize:GetDimension("LISTBOX","LININI"),oSize:GetDimension("LISTBOX","COLINI"),;
		 				oSize:GetDimension("LISTBOX","XSIZE")-12,oSize:GetDimension("LISTBOX","YSIZE"),;
		 				,axCab,axTamCab,oDlgCs,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	oQual:SetArray(axArrayF4)
    
	If !Empty(axArrayF4)
		oQual:bLine := { || axArrayF4[oQual:nAT] }					
	Else
	    cLine := "{" +Replicate("'',",12) +"}"
	    bLine := &( "{ || " + cLine + " }" )					   
		oQual:bLine := bLine
	EndIf
    
	@ oSize:GetDimension("CAB","LININI")+2 ,oSize:GetDimension("CAB","COLINI")   SAY OemToAnsi("Produto") Of oDlgCs PIXEL SIZE 47 ,9 //
	@ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI") +27 MSGET _cPrdDem PICTURE PesqPict('SB1','B1_COD') When .F. Of oDlgCs PIXEL SIZE 100,9

	ACTIVATE MSDIALOG oDlgCs CENTERED ON INIT EnchoiceBar(oDlgCs,{|| nOpca:=1,oDlgCs:End()},{||oDlgCs:End()},,aButtons)
Else
	Help(" ",1,"CONSMED",,"Não encontrado NFs de venda nos últimos meses para esse produto",4,,,,,,.F.)
Endif
cCadastro := cCadAnt
RestArea(_aArea)
Return
//----------------------------------------------------------------------------------------
User Function ANPrcPC(_cVarCod,cOpcPrc,cCodMrc)//Ita - 23/07/2019 - Acrescentados cOpcPrc e cCodMrc para poder utilizar esta função, também na Solicitação de transferência. //Ita - 18/07/2019 - User Function ANPrcPC()

Local _nPrecTab := 0
Local _aArea	:= GetArea()
Local cAliasSZ3 := "QRYZ3"
//Ita - 18/07/2019 - Local _cCodDg	:= _cCodTelDg
//Local _cCodDg	:= _cVarCod
Local _aCodForn := u_MPosFor(cCodMrc)
Local nQtde		:= 0
If cOpcPrc == "1"   //Ita - 23/07/2019 - If Substr(_cPrecoF,1,1) == "1"   
    /* Ita - 18/07/2019
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+Padr(_cCodDg,15))//Ita - 18/07/2019 - If dbSeek(xFilial("SB1")+_cCodDg)
		_nPrecTab := SB1->B1_UPRC
	Endif
	*/
	_nPrecTab := fRetUPrc(_cVarCod)//Ita - 07/08/2019 - _cCodDg)
Else
	/* Ita - 18/07/2019
	If Len(_aCodForn) > 0
		dbSelectArea("AIA")
		dbSetOrder(1)
		//Ita - 30/05/2019 - If dbSeek(xFilial()+_aCodForn[1,1]+_aCodForn[1,2])
		If dbSeek(cFilAnt+_aCodForn[1,1]+_aCodForn[1,2])
			cIdTab := AIA->AIA_CODTAB
			If MaVldTabCom(_aCodForn[1,1],_aCodForn[1,2],cIdTab,,,dDataBase)
				_nPrecTab := MaTabPrCom(cIdTab,_cCodDg,nQtde,_aCodForn[1,1],_aCodForn[1,2],1,dDataBase)
			Endif
		Endif
	Endif
	*/
	aDdTb := fPsqTbPr(cfilant,_cVarCod,dDataBase) //Ita - 07/08/2019 - fPsqTbPr(cfilant,_cCodDg,dDataBase) //Ita - 18/07/2019
	_nPrecTab := aDdTb[4]  
Endif
RestArea(_aArea)
Return(_nPrecTab)
//-----------------------------------------------------------------------------
//
User Function AnForMc

Local cFiltro := "@A2_COD IN (SELECT DISTINCT ZZM_FORNEC FROM ZZM010)"
Return cFiltro

//-----------------------------------------------------------------------------
//
User Function AnFilAN(_cFilia)

Local _aArea := GetArea()
Local _cQuery
Local _cEmpANL := Space(03)
Local cAliasSX5 := "QRYSX5"

_cQuery := "SELECT X5_CHAVE XFILANL FROM " + RetSqlName("SX5")
_cQuery += " WHERE X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += " AND X5_TABELA = '99'"
_cQuery += " AND X5_DESCRI LIKE '" + _cFilia + "%'"
_cQuery += " AND D_E_L_E_T_ = ' '
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSX5,.T.,.T.)
dbSelectArea(cAliasSX5)
If !Eof()
	_cEmpANL := (cAliasSX5)->XFILANL
Endif
(cAliasSX5)->(dbCloseArea())
RestArea(_aArea)
Return(_cEmpANL)
//------------------------------------------------------------------------------------
//
Static Function ANPesqCod(oMrkBrowse, cArqTrab,_cPrdPos)

Local _aArea	:= GetArea()
LOCAL aPerg 	:= {}						// Array de parametros de acordo com a regra da ParamBox
LOCAL cTitulo	:= "Pesquisa Produto" 		// Titulo da janela de parametros
LOCAL aRet		:= {}						// Array que será passado por referencia e retornado com o conteudo de cada parametro
LOCAL bOk		:= {|| BuscProd(aRet, cArqTrab)}		// Bloco de codigo para validacao do OK da tela de parametros
LOCAL aButtons	:= {}						// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
LOCAL lCentered	:= .T.						// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
LOCAL nPosx		    						// Posicao inicial -> linha (Linha final: nPosX+274)
LOCAL nPosy									// Posicao inicial -> coluna (Coluna final: nPosY+445)
LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
LOCAL lCanSave	:= .F.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .F.						// Se o usuário pode salvar sua propria configuracao
LOCAL nX		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array a ser passado para ParamBox quando tipo(6) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Ita - 21/08/2019 - Preencher pesquisa do produto com último produto digitado, se existir. Solicitação de Gustavo.
If !Empty(_cPrdPos)
   cParProdu := _cPrdPos
Else
   cParProdu := SPACE(TAMSX3("B1_COD")[1]) 
EndIf
//Ita - 21/08/2019 - aAdd( aPerg,{1,"Codigo: ",SPACE(TAMSX3("B1_COD")[1]),"@!","AllwaysTrue()","" ,".T.",100,.T.})
aAdd( aPerg,{1,"Codigo: ",cParProdu,"@!","AllwaysTrue()","" ,".T.",100,.T.})

//If ParamBox(aPerg,cTitulo,@aRet)
If ParamBox(aPerg, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)
	If ValType(aRet) == "A" .AND. Len(aRet) == Len(aPerg) .and. !Empty(aRet[1])
		dbSelectArea(cArqTrab)
		DbSetOrder(1) //Ita - 29/03/2019 - Implementado para mudar indice inicial do browse que está setado para 2.
		If dbSeek(aRet[1])
			oMrkBrowse:GoTo ((cArqTrab)->(Recno()),.T.)
		Else
			Help(" ",1,"PRODNEXIS",,"Produto NÃO encontrado",4,,,,,,.F.)
			RestArea(_aArea)
		Endif
		//Ita - 18/06/2019 - DbSetOrder(2) //Ita - 29/03/2019 - Implementado para mudar indice inicial do browse que está setado para 2.
		dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
	Endif
Endif
dbSelectArea(cArqTrab) //Ita - 30/05/2019
//Ita - 10/06/2019 - dbSetOrder(_nOrdTrab)  //Ita - 30/05/2019
//Ita - 06/06/2019 - oMrkBrowse:Refresh:lGoTop := .F.
//lGoTop := .F. 
//oMrkBrowse:Refresh(lGoTop)
oMrkBrowse:Refresh(.F.)
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
Return
//-----------------------------------------------------------------------------------
//
Static Function BuscProd(aRet, cArqTrab)

Local _lRet := .T.
Local _aAreaTmp := (cArqTrab)->(GetArea())
If !Empty(aRet[1])
	dbSelectArea(cArqTrab)
	dbSetOrder(1)
	If !dbSeek(aRet[1])	
		Help(" ",1,"PRODNEXIS",,"Produto NÃO encontrado",4,,,,,,.F.)
		_lRet := .F.
	Endif
Endif
RestArea(_aAreaTmp)
Return(_lRet)
User Function fcallimp(xNumPC)
    xNumPC := SZ7->Z7_NUM
    DbSelectArea("SC7")
    DbSetOrder(1)
    //Ita - 30/05/2019 - If DbSeek(xFilial("SC7")+xNumPC)
    If DbSeek(cFilAnt+xNumPC)
		MV_PAR01 := Replicate(" ", Len(SA2->A2_COD)) 
		MV_PAR02 := Replicate("Z", Len(SA2->A2_COD))
		MV_PAR03 := xNumPC
		MV_PAR04 := xNumPC
		MV_PAR05 := CTOD("01/01/1900")
		MV_PAR06 := CTOD("31/12/2049") 
        u_xMATR110( "SC7", SC7->(RecNO()), 2 )//MATR110A(xNumPC)//MATR110()
        //Matr110a(xNumPC) 
       //StaticCall(Mata120(1),MATR110)
    Else
       Alert("O Pedido de Compras "+xNumPC+" não foi localizado, favor verificar este pedido de revenda!")
    EndIf
Return
////////////////////////
/// Ita - 01/03/2019
///     - Executar Código no ini do browse
/////////////////////////////////////////////////////////
Static Function fOrdSZ7()
Return()

////////////////////////
/// Ita - 01/03/2019
///     - Função F9 para posicionar no Código do Produto
/////////////////////////////////////////////////////////
Static Function fFocProd
   oCodProd:SetFocus() // Força o foco no objeto com o handle definido
Return
//////////////////////
/// Ita - 07/03/2019
///     - Validação da Linha no grid dos Itens de 
///       Consumos
///////////////////////////////////////////////////
User Function fVldLCons(n)
Return(.T.)

//////////////////////
/// Ita - 07/03/2019
///     - Validação da Linha no grid dos Itens de 
///       Consumos
///////////////////////////////////////////////////
User Function fVlTtLCons(n)
   If Empty(aCols) 
      Return(.T.)   
   EndIf
   If M->Z1_DTENTR < DDATABASE
      Alert("A Data digitada "+DTOC(M->Z1_DTENTR)+" não pode ser inferior a "+DTOC(DDATABASE))
      Return(.F.)
   EndIf
   nPrimLin := 0
   aItValidos := {}
   lUmaVez := .T.
   For nTmp := 1 To Len(aCols)
      If !GdDeleted(nTmp) //Se a linha não estiver deletada. 
         If lUmaVez
            lUmaVez := .F.
            nPrimLin := nTmp  
         EndIf
         aAdd(aItValidos,aCols[nTmp,_nPosDt])
      EndIf
   Next nTmp
   If n <= nPrimLin
      Return(.T.)
   EndIf
   If Len(aItValidos) > 1
	   
	   aDataDgt := {}
	   
	   For nI := 1 To Len(aCols)
	      If !GdDeleted(nI) //Se a linha não estiver deletada. 
	         If nI == n //Se é a linha que está sendo digitada, pega da memória, não o que já encontra-se no array, pois foi implementado no inicializador padrão.
	            GdFieldPut("Z1_DTENTR",M->Z1_DTENTR,nI)
	         EndIf
	         nPosDt := aScan(aDataDgt, { |x| x[1] == DTOS(GdFieldGet("Z1_DTENTR",nI)) })
	         If nPosDt == 0 .And. !Empty(DTOS(GdFieldGet("Z1_DTENTR",nI)))
	            aAdd(aDataDgt, {DTOS(GdFieldGet("Z1_DTENTR",nI)),nI}) 
	         Else 
	            If nI <> nPosDt // Len(aDataDgt)
		            Alert("A Data "+DTOC(GdFieldGet("Z1_DTENTR",nI))+" já foi informada na linha "+Alltrim(Str(nPosDt))+" não é permitido datas iguais")
		            nI := Len(aCols) + 1
		            Return(.F.)
	            EndIf
	         EndIf
	
	      EndIf
	   Next nI
	EndIF
Return(.T.)

/////////////////////////////////////////////////////////////
/// Ita - Função de validação do campo quantidade(Z1_QUANT)
///     - Implementada em X3_VLDUSER
User Function fChkQtdZ1()
	
   If M->Z1_QUANT <= 0
      _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
      _dExc  := GdFieldGet("Z1_DTENTR",oGetDados:nAT)
	  //Ita - 27/05/2019 - Criado tratamento para excluir item do SZ1 E da memória(_aItemPC) quando for zerado a quantidade de um item.
	  If !fExcZ1(aPCRev[13],_IncDt,_dExc,(cArqTrab)->TRB_COD,1) //!fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2)
	     fExcZ1(aPCRev[13],_IncDt,_dExc,(cArqTrab)->TRB_COD,2)
	     If Len(_aItemPC) > 0
	        _nAcho := aScan(_aItemPC,{|x| x[1]+x[6] == _cCodProd+"1"})
	        If _nAcho > 0
		      _aItemPC[_nAcho, 6] := "0"
		    EndIf
		 EndIf
         //Ita - 05/09/2019 - If !fChkTemZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
         If !fChkQtdZ1(aPCRev[13],_IncDt,(cArqTrab)->TRB_COD,2) 
		     DbSelectArea(cArqTrab)
		     RecLock(cArqTrab,.F.)
		     //Alert("Entrei aqui - 10)")
		     Replace TRB_OK with " "
		     MsUnLock()
			 //Ita - 29/05/2019 - Refresh itens selecionados
			 //_nItemSel--
			 //_nValPC -= SZ1->Z1_TOTAL //Ita - 29/05/2019
			 //_oItemSel:Refresh()
			 //_oValPC:Refresh()
		 EndIf
	  EndIf
      /* Ita - 27/05/2019 - Retirado validação da quantidade zerada conforme solicitação em planilha MIT006 - R02PT 
      Alert("Por favor informe uma quantidade para o pedido do item nesta data")
      Return(.F.)
      ***/
   EndIf
   
   If Substr(_cTped,1,1) == "C" //Se for Compras - Ita - 10/07/2019
	   ////////////////////////////////////////////////
	   /// Ita - 24/05/2019
	   ///     - Checar o Fator de Multiplicação 
	   cpare:=""
	   nFtEmbal := Posicione("SB1",1,xFilial("SB1")+(carqtrab)->TRB_COD,"B1_XEMBFOR")//Ita - 18/06/2019 - "B1_QE") 
	   If nFtEmbal > 0
	      _lEMultFE := If(Mod(M->Z1_QUANT,nFtEmbal)==0,.T.,.F.)
	      If !_lEMultFE
	         Alert("Por favor informe uma quantidade multipla de "+cValToChar(nFtEmbal)+" que é o fator de embalagem deste produto "+(carqtrab)->TRB_COD)
	         Return(.F.)
	      EndIf
	   EndIf
   EndIf
//_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
//fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) //Ita - 29/05/2019

Return(.T.)

//////////////////////////////////////
/// Ita - 06/06/2019
///     - Gatilho para posicionar na próxima linha
///     - do grid do aCols.
///     - Função fNextQtd
///     - Campo Z1_QUANT sequencia 002
///     - Regra: u_fNextQtd()
/*
User Function fNextQtd
    MsgInfo("Estou no gatilho Z1_QUANT - Função fNextQtd")
	//MsNewGetDados(): ChkObrigat ( [ nAt] ) --> lRet
	//MsNewGetDados(): AddLine ( [ lRepaint], [ lValid] ) --> lRet
	If oGetDados:ChkObrigat(oGetDados:nAt)
	   oGetDados:AddLine(.T.,.T.)
	   //oGetDados:GoBottom()            
	   //oGetDados:nAt := oGetDados:nAt + 1
	   oGetDados:Goto(oGetDados:nAt) 
	   //oGetDados:OBROWSE:BGOBOTTOM()
	   oGetDados:OBROWSE:COLPOS:=1
	   oGetDados:oBrowse:Refresh()
	EndIf
	MsgInfo("Estou na Linha "+Alltrim(Str(oGetDados:nAt))+" do aCols")
Return(M->Z1_QUANT)
*/
//////////////////////
/// Ita - 07/03/2019
///     - Inicializador do campo Z1_DTENTR para acrescentar Data + 7 dias
//////////////////////////////////////////////////////////////////////
User Function fSumData(n)
   If Len(aCols) == 1
      //Ita - 30/05/2019 - Return(CTOD("")) //Ita - 24/05/2019
      Return(dDataBase)
   EndIf
   nPrimLin := 0
   aItValidos := {}
   lUmaVez := .T.
   nRodarAt := (Len(aCols)-1)
   For nTmp := 1 To nRodarAt 

	      If !GdDeleted(nTmp) //Se a linha não estiver deletada. 
	         If lUmaVez
	            lUmaVez := .F.
	            nPrimLin := nTmp  
	         EndIf
	         aAdd(aItValidos,aCols[nTmp,_nPosDt])
	      EndIf
      //EndIf
   Next nTmp
   dNxtDate := dDataBase
   If (n+1) <= nPrimLin
      Return(dNxtDate)
   EndIf
   If Len(aItValidos) >= 1
      dNxtDate := aItValidos[Len(aItValidos)] + 7
   EndIf
   GdFieldPut("Z1_DTENTR",dNxtDate,n+1) 
Return(dNxtDate)

//////////////////////
/// Ita - 27/03/2019
///     - Função fReplOBS() - Replica a OBS digitada para
///       todas as linhas do aCols
////////////////////////////////////////////////////////////
User Function fReplOBS()
   For nMm := 1 To Len(aColsDT)
      GdFieldPut("_cOBSDT",_cOBSDT,nMm)
   Next nMm
   oGetTDT:Refresh()
   oDlgTPC:Refresh()
Return(.T.)

//////////////////////
/// Ita - 29/03/2019
///     - Função fRPCAut() - Gerar SZ1 com itens que contém
///       sugestão de comprar para possibilitar a geração
///       automática do pedido de compras.
////////////////////////////////////////////////////////////
Static Function fRPCAut(_aPCAuto)
   nSug := Len(_aPCAuto)
   ProcRegua(nSug)
   //_nValPC		:= 0
   //_nItemSel	:= 0
   For nPrc := 1 To Len(_aPCAuto)
      IncProc("Marcando itens com sugestão, aguarde... "+Alltrim(Str(nPrc))+" / "+Alltrim(Str(nSug)))
      Grv_SZ1("1", _aPCAuto[nPrc],2) //Ita - 03/06/2019 - Implementado 2=_xnRot para tratar variáveis de totais do pedido
      _lTemPCA := .T. //Ita - 18/06/2019
      //aAdd(_aPCAuto, { (cArqTrab)->TRB_COD    ,dDataBase ,_nSugestao , (cArqTrab)->TRB_PRECO, nTotItPA, "1"})
   //_nValPC += _aPCAuto[nPrc,5]
   //_nItemSel ++
   Next nPrc
   //_oValPC:Refresh()
   //_oItemSel:Refresh()
   //_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
   //fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) //Ita - 29/05/2019
Return

///////////////////////////////////////
///  Ita - 09/04/2019
///      - Seleciona todos os códigos
///        de produtos que possuem o
///        mesmo código mestre.

Static Function fAgrupMest(_xCodMestre)
   cAliasXB1 := "XSB1" 
   aProdMest := {}
   
   cQryMest := " SELECT SB1.B1_COD,B1_LOCPAD " + _Enter
   cQryMest += "   FROM "+RetSQLName("SB1")+" SB1 " + _Enter
   cQryMest += "  WHERE SB1.B1_XALTIMP = '"+_xCodMestre+"'" + _Enter
   cQryMest += "    AND SB1.B1_XMESTRE = 'S'" + _Enter
   cQryMest += "    AND SB1.D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fAgrupMest.SQL",cQryMest)
   
   //TCQuery cQryMest NEW ALIAS "XSB1"
   cQryMest := ChangeQuery(cQryMest)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryMest),cAliasXB1,.T.,.T.)
   cpare:=""
   DbSelectArea(cAliasXB1)
   While (cAliasXB1)->(!Eof())
      //If aScan(aProdMest, {|x| x[1] == XSB1->B1_COD }) == 0
         aAdd(aProdMest, {(cAliasXB1)->B1_COD,(cAliasXB1)->B1_LOCPAD})
      //EndIf
      DbSelectArea((cAliasXB1))
      DbSkip()
   EndDo
   DbSelectArea(cAliasXB1)
   (cAliasXB1)->(DbCloseArea())
   
Return(aProdMest)

///////////////////////////////////////////
/// Ita - 11/04/2019 
///       Consistências para realizar a 
///       transferência.

Static Function fChkTrf()
   //MsgInfo("Verificando Empresas para TransferÊncia Alltrim(_cOrigTrf): "+Alltrim(_cOrigTrf)+" Alltrim(_cEmpr01): "+Alltrim(_cEmpr01) )
   If Substr(_cTped,1,1) == "T"  //T - Transferência - Itacolomy Mariano - 11/04/2019
      If Empty(_cOrigTrf)
         Alert("Para Pedido Tipo Transferência a filial origem deve ser informada")
         Return(.F.)
      EndIf
      _cFilProth := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cEmpr01,"X5_DESCRI"),1,6)
      _cNmeSol   := Alltrim(Posicione("SX5",1,xFilial("SX5")+"99"+_cEmpr01,"X5_DESCRI"))
      If Alltrim(_cFilProth) <> Alltrim(cfilant) //Ita - 03/07/2019 - Alltrim(SM0->M0_CODFIL)
         Alert("Para realizar uma transferência, é necessário está logado na filial solicitante! ["+_cNmeSol+"]")
         Return(.F.)
      EndIf
   EndIf
   If Alltrim(_cOrigTrf) == Alltrim(_cEmpr01)
      _NmeOrg := Alltrim(Posicione("SX5",1,xFilial("SX5")+"99"+_cOrigTrf,"X5_DESCRI"))
      _NmeDst := Alltrim(Posicione("SX5",1,xFilial("SX5")+"99"+_cEmpr01,"X5_DESCRI"))
      Alert("Não poderá ocorrer uma transferência entre a mesma filial - Origem: "+_cOrigTrf+" - "+_NmeOrg+" Destino: "+_cEmpr01+" - "+_NmeDst)
      Return(.F.)
   EndIf
   
Return(.T.)
Static Function fPsqForF(_cOrigTrf)
   CPARE:=""
   //MsgInfo("_cOrigTrf: "+_cOrigTrf)
   _cFilProth := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cOrigTrf,"X5_DESCRI"),1,6)
   aSM0 := FWLoadSM0(.T.)
	//Pesquisa o CNPJ da filial de origem da transferência
	//MsgInfo("_cFilProth: "+_cFilProth)
	For nX:=1 To Len(aSM0)
		//Verifica se a filial é igual a da nota
		If Alltrim(aSM0[nX][SM0_FILIAL]) == Alltrim(_cFilProth)
			cCNPJOrig := Alltrim(aSM0[nX][SM0_CNPJ])
		EndIf
	Next nX

	DbSelectArea("SA2")
	SA2->(DbSetOrder(3))//A2_FILIAL+A2_CGC
	aRetFor := {}
	If SA2->(DbSeek(xFilial("SA2")+cCNPJOrig))
	   aAdd(aRetFor,SA2->A2_LOJA)   
	Else
		Help( ,, 'HELP',, 'Fornecedor não encontrado para inclusão do pedido de transferência', 1, 0)
	EndIf   
Return(aRetFor)
Static Function fPsqCliT() //Ita - 11/04/2019 - Pega o Cliente para realizar transfeência 
   _cFilProth := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cEmpr01,"X5_DESCRI"),1,6)
   aSM0 := FWLoadSM0(.T.)
	//Pesquisa o CNPJ da filial de origem da transferência
	For nX:=1 To Len(aSM0)
		//Verifica se a filial é igual a da nota
		If Alltrim(aSM0[nX][SM0_FILIAL]) == Alltrim(_cFilProth)
			cCNPJOrig := Alltrim(aSM0[nX][SM0_CNPJ])
		EndIf
	Next nX

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))//A1_FILIAL+A1_CGC
	aRetCli := {}
	If SA1->(DbSeek(xFilial("SA1")+cCNPJOrig))
	   aAdd(aRetCli, SA1->A1_COD,SA1->A1_LOJA)   
	Else
		Help( ,, 'HELP',, 'Cliente não encontrado para inclusão do pedido de transferência', 1, 0)
	EndIf   
Return(aRetCli)

///////////////////////////////
/// Ita - 15/04/219
///       Tratamento da Cor da Linha para evitar usar coluna de legendas
///       e possibilitar mais espaços para colunas de informações de
///       compras.

Static Function GETDCLR(nLinha)
xArea := GetArea() //Ita - 18/06/2019
nRet:=""
If (cArqTrab)->TRB_BLQ == "S" //Produto Bloqueado para Compra
     nRet := CLR_VERPDR //CLR_PRDBLOK //CINZA ESCURO
Endif
/*                                                            //12345678901234
If !Empty((cArqTrab)->TRB_OK) //Produto já informado quantidad e/ou data de necessidade
   nRet := CLR_PRDJDI //CLR_ORANGE
EndIf
*/
//////////////////////////
/// Ita - 16/04/2019
///       Só fará Pedido Automático caso atenda os critérios de Cobertura
///       definido na tela de parâmetros
/* Ita - 15/05/2019 
  cPesq := "/"
  cText := (cArqTrab)->TRB_COBERT
  nPosIni := AT( cPesq, cText ) // Resultado
  _nQtCobert := Val(Substr((cArqTrab)->TRB_COBERT,(nPosIni+1),100))

If _nQtCobert > _nCobAte //Se os dias de cobertura for maior que o definido no parâmetro Cobertura, irá apresentar a linha pintada
   nRet := CLR_PRDJDI //CLR_ORANGE
EndIf
*/
cpare:=""
RestArea(xArea)//Ita - 18/06/2019
Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPrtConsumoºAutor  ³Ita               º Data ³  16/04/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório TReport para apresentar tela de consumo de produtoº±±
±±º          ³s para envio a Fornecedor.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menu de Compras - Auto Norte                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fPrtConsumos(cArqTrab) //cArqTrab
   Local oReport
   Private _Enter    := chr(13) + Chr(10) 
   Private aOrdem    := {}	
   Private cAliasTop := cArqTrab //GetNextAlias()
   //Private aSM0 := FWLoadSM0()
   /*
   Private aEmpresas := {}
   DbSelectArea("SM0")
   nRecSM0 := RecNo()
   DbGoTop()
   While SM0->(!Eof())
      aAdd(aEmpresas,{Substr(SM0->M0_CODFIL,1,6),Alltrim(SM0->M0_FILIAL)})
      DbSelectArea("SM0")
      DbSkip()
   EndDo
   DbSelectArea("SM0")
   DbGoTo(nRecSM0)
   */   
   cpare:=""
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Interface de impressao                                                  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   oReport:= FSRptCons()
   oReport:PrintDialog()   

Return

Static Function FSRptCons()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Criacao do componente de impressao                                      ³
   //³                                                                        ³
   //³TReport():New                                                           ³
   //³ExpC1 : Nome do relatorio                                               ³
   //³ExpC2 : Titulo                                                          ³
   //³ExpC3 : Pergunte                                                        ³
   //³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
   //³ExpC5 : Descricao                                                       ³
   //³                                                                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cPerg     := ""
   _cTitulo  := "CONSUMOS"
   oReport:= TReport():New("fPrtConsumos",_cTitulo,cPerg, {|oReport| ReportPrint(oReport,aOrdem,cAliasTop)},_cTitulo)
   //oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
   //oReport:nFontBody	:= 12 // Define o tamanho da fonte.
   //oReport:nLineHeight	:= 50 // Define a altura da linha.
	cpare:=""//MsgInfo(oReport:NDEVICE)   
   oReport:SetLandscape() 
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Criacao da Sessao 1 - (Divergências)                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   //oConsumos:= TRSection():New(oReport,"PRODUTOS ALTERADOS NA MOVIMENTAÇÃO - CUSTO/REPOSIÇÃO ALTERADOS",{cAliasTop},aOrdem)
   oConsumos:= TRSection():New(oReport,"COMPARATIVO DE PREÇO",{cAliasTop} ,aOrdem)

   oConsumos:SetTotalInLine(.F.)

   ////////////////////////////////////////////////
   /// Ita - 25/06/2019
   ///     - Tratamento da descrição do sétimo mês
   If _cMes07 == nil
	   _nAcho := aScan(_aMes,{|x| AllTrim(x[2])==_cMes06})
	   If Alltrim(_aMes[_nAcho,2]) == "JAN"
	      _xDscMes := "DEZ"
	   Else
	      _xDscMes := _aMes[_nAcho-1,2]
	   EndIf
	   _cMes07 := _xDscMes //Ita - 25/06/2019
   EndIf
   
   TRCell():New(oConsumos,'OK'        ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'BLOQUEADO' ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'PRECO'     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'TOTAL'     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'CODIGO'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'PEND'      ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'COB.'      ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'SUG.'      ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'CL'        ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'DESCRICAO' ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'SALDO 1'   ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'SALDO 2'   ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes07     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes06     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes05     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes04     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes03     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes02     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,_cMes01     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'TRIMES'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'SEMES'     ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'DATA 1'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'QTDE 1'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oConsumos,'DATA 2'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'QTDE 2'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'DATA 3'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'QTDE 3'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   //TRCell():New(oConsumos,'COBPEN'  ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New(oConsumos,'FATEMB'    ,'',,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)  
      
Return(oReport)

Static Function ReportPrint(oReport,aOrdem,cAliasTop)

   Local oLinha 	:= oReport:Section(1):Section(1)
   Local oConsumos	:= oReport:Section(1)
   Local nOrdem   	:= oConsumos:GetOrder()
   Local cOrderBy  := ''
   Local cFilUser  := oReport:Section(1):GetAdvplExp()
   Local cIndexkey	:= ''
   Local cTipant   := ''
   Local cFiliant  := ''
   xArea := GetArea()
   Private cFilterUser
   //Private cFilSA2User := oConsumos:GetADVPLExp("SA2")
   Private cFilTRBUser := oConsumos:GetSqlExp(cAliasTop)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Adiciona a ordem escolhida ao titulo do relatorio          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   //oReport:SetTitle(oReport:Title() + " ("+AllTrim(aOrdem[nOrdem])+") ")

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Query de Seleção dos Registros                                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Transforma parametros Range em expressao SQL                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
   Pergunte(oReport:uParam,.F.)
   //MakeSqlExpr(oReport:uParam)
   MakeSqlExpr(oReport:GetParam())
  /////////////////////////////////
   /// Grupo de Perguntas - DIVPXNF 
   nOpcImp := oReport:NDEVICE

   //oReport:SetMeter(nRegs) //-> Indica quantos registros serao processados para a regua ³  
   DbSelectArea(cAliasTop)
   DbGoTop()

   oConsumos:Init(.F.)
   Do While !oReport:Cancel() .And. !(cAliasTop)->(Eof())

      //oReport:IncMeter()
		If !empty(cFilTRBUser)
		  	DbSelectArea(cAliasTop)
		  	DbSkip()
		  	Loop
		Endif   
	      cpare:=""
	      
	      oConsumos:Cell('OK'):SetValue((cAliasTop)->TRB_OK)
	      oConsumos:Cell('BLOQUEADO'):SetValue((cAliasTop)->TRB_BLQ)
	      oConsumos:Cell('PRECO'):SetValue((cAliasTop)->TRB_PRECO)
	      oConsumos:Cell('TOTAL'):SetValue((cAliasTop)->TRB_TOTAL)
	      oConsumos:Cell('CODIGO'):SetValue((cAliasTop)->TRB_COD)
	      oConsumos:Cell('PEND'):SetValue((cAliasTop)->TRB_PED)
	      oConsumos:Cell('COB.'):SetValue((cAliasTop)->TRB_COBERT)
	      oConsumos:Cell('SUG.'):SetValue((cAliasTop)->TRB_SUG)
	      oConsumos:Cell('CL'):SetValue((cAliasTop)->TRB_CLASSE)
	      oConsumos:Cell('DESCRICAO'):SetValue((cAliasTop)->TRB_DESC)
	      oConsumos:Cell('SALDO 1'):SetValue((cAliasTop)->TRB_SALD1)
	      oConsumos:Cell('SALDO 2'):SetValue((cAliasTop)->TRB_SALD2)
	      oConsumos:Cell(_cMes07):SetValue((cAliasTop)->TRB_MES07)
	      oConsumos:Cell(_cMes06):SetValue((cAliasTop)->TRB_MES06)
	      oConsumos:Cell(_cMes05):SetValue((cAliasTop)->TRB_MES05)
	      oConsumos:Cell(_cMes04):SetValue((cAliasTop)->TRB_MES04)
	      oConsumos:Cell(_cMes03):SetValue((cAliasTop)->TRB_MES03)
	      oConsumos:Cell(_cMes02):SetValue((cAliasTop)->TRB_MES02)
	      oConsumos:Cell(_cMes01):SetValue((cAliasTop)->TRB_MES01)
	      oConsumos:Cell('TRIMES'):SetValue((cAliasTop)->TRB_MEDTRI)
	      oConsumos:Cell('SEMES'):SetValue((cAliasTop)->TRB_MEDSEM)
	      oConsumos:Cell('DATA 1'):SetValue((cAliasTop)->TRB_DATA3)                                                  //Ita - 27/05/2019 - Alterar ordem dos dados - oConsumos:Cell('DATA 1'):SetValue((cAliasTop)->TRB_DATA1)
	      oConsumos:Cell('QTDE 1'):SetValue((cAliasTop)->TRB_QTD3)                                                   //Ita - 27/05/2019 - Alterar ordem dos dados - oConsumos:Cell('QTDE 1'):SetValue((cAliasTop)->TRB_QTD1) 
	      oConsumos:Cell('DATA 2'):SetValue((cAliasTop)->TRB_DATA2)
	      oConsumos:Cell('QTDE 2'):SetValue((cAliasTop)->TRB_QTD2)
	      oConsumos:Cell('DATA 3'):SetValue((cAliasTop)->TRB_DATA1)                                                  //Ita - 27/05/2019 - Alterar ordem dos dados - oConsumos:Cell('DATA 3'):SetValue((cAliasTop)->TRB_DATA3)
	      oConsumos:Cell('QTDE 3'):SetValue((cAliasTop)->TRB_QTD1)                                                   //Ita - 27/05/2019 - Alterar ordem dos dados - oConsumos:Cell('QTDE 3'):SetValue((cAliasTop)->TRB_QTD3) 
	      //oConsumos:Cell('COBPEN'):SetValue((cAliasTop)->TRB_COBPEN)
	      oConsumos:Cell('FATEMB'):SetValue((cAliasTop)->TRB_FATEMB)

	      oConsumos:PrintLine()
	      oReport:SkipLine() //-- Salta Linha
	      oReport:ThinLine() //-- Impressao de Linha Simples
	               
	      //Prepara Picture das Celulas para receber novos valores

	      oConsumos:Cell('OK'):SetPicture("@!")
	      oConsumos:Cell('BLOQUEADO'):SetPicture("@!")
	      oConsumos:Cell('PRECO'):SetPicture("@E 999,999.99")
	      oConsumos:Cell('TOTAL'):SetPicture("@E 999,999.99")
	      oConsumos:Cell('CODIGO'):SetPicture("@!")
	      oConsumos:Cell('PEND'):SetPicture("@E 999,999")
	      oConsumos:Cell('COB.'):SetPicture("@!")
	      oConsumos:Cell('SUG.'):SetPicture("@E 999,999")
	      oConsumos:Cell('CL'):SetPicture("@!")
	      oConsumos:Cell('DESCRICAO'):SetPicture("@!")
	      oConsumos:Cell('SALDO 1'):SetPicture("@E 999,999")
	      oConsumos:Cell('SALDO 2'):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes07):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes06):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes05):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes04):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes03):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes02):SetPicture("@E 999,999")
	      oConsumos:Cell(_cMes01):SetPicture("@E 999,999")
	      oConsumos:Cell('TRIMES'):SetPicture("@E 999,999")
	      oConsumos:Cell('SEMES'):SetPicture("@E 999,999")
	      oConsumos:Cell('DATA 1'):SetPicture("")
	      oConsumos:Cell('QTDE 1'):SetPicture("@E 999,999")
	      oConsumos:Cell('DATA 2'):SetPicture("")
	      oConsumos:Cell('QTDE 2'):SetPicture("@E 999,999")
	      oConsumos:Cell('DATA 3'):SetPicture("")
	      oConsumos:Cell('QTDE 3'):SetPicture("@E 999,999")
	      //oConsumos:Cell('COBPEN'):SetPicture("@E 999,999")
	      oConsumos:Cell('FATEMB'):SetPicture("@E 999,999")
	            
      (cAliasTop)->( DbSkip() )

   EndDo		
   DbSelectArea(cAliasTop)  
   //(cAliasTop)->(DbCloseArea())
   oConsumos:Finish()   
   RestArea(xArea) 
Return	
////////////////////////////////
/// Ita - 15/05/2019
///     - Nova validação de Esc 
User Function fVldEsc
_nUlTecla := LastKey() //VtInkey() 
If _nUlTecla == 27 //VtInkey(1) == 27  // correspondente a tela ESC
	If MsgYesNo("Deseja sair dos parâmetros?")
	   oDlgPar:End()
       SetKey(VK_F2, NIL )
       SetKey(VK_F9, NIL ) //Ita - 01/03/2019
	   Return StaticCall(Aut_PC,Aut_PCV)//Aut_PCV()
	Else
	   Return
	EndIf
EndIf 
Return

////////////////////////////////////
/// Ita - 15/05/2019
///     - Fechar Tela de Parâmetros
Static Function fClsPar()
   oDlgPar:End()
Return
///////////////////////////////////////////
/// Ita - 15/05/2019
///     - Checa uso do Pedido de Compras
///     - para um mesmo fornecedor na mesma
///     - data de inclusão. 
Static Function fChkUsoPC(xForn,xDtInc,_cEpANL)
   cAliasXZ1 := "CSZ1"  
   cFilAnt    := Substr(Posicione("SX5",1,xFilial("SX5")+"99"+_cEpANL,"X5_DESCRI"),1,6)
   _cQuery := "SELECT COUNT(*) NTEMPC " + _Enter
   _cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
   //Ita - 30/05/2019 - _cQuery += " WHERE Z1_FILIAL = '" + xFilial("SZ1") + "'" + _Enter
   _cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
   _cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
   _cQuery += "   AND Z1_CODFORN = '"+xForn+"'" + _Enter
   _cQuery += "   AND Z1_DTINCL = '"+DTOS(xDtInc)+"'" + _Enter
   _cQuery += "   AND Z1_QUANT > 0 " + _Enter //Ita - 05/06/2019
   //_cQuery += "   AND Z1_DTENTR = '"+DTOS(xDtEnt)+"'" + _Enter
   _cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
   //_cQuery += " ORDER BY Z1_CODFORN" + _Enter
   MemoWrite("C:\TEMP\fChkUsoPC.SQL",_cQuery)
   MemoWrite("\Data\fChkUsoPC.SQL",_cQuery)
   //TCQuery _cQuery NEW ALIAS "CSZ1"
   _cQuery := ChangeQuery(_cQuery)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasXZ1,.T.,.T.)

   DbSelectArea(cAliasXZ1)
   lTemPC := If((cAliasXZ1)->NTEMPC > 0,.T.,.F.)
   If lTemPC
      DbSelectArea(cAliasXZ1)
      DbCloseArea()
      //Alert("Já existe um pedido sendo digitado para o fornecedor: "+Alltrim(xForn)+" nesta mesma data base "+DTOC(xDtInc)+" retorne e use a opção continuar")
      Alert("Já existe um pedido sendo digitado para o fornecedor: "+Alltrim(xForn)+" nesta mesma filial "+cFilAnt+" retorne e use a opção continuar")
      Return(.F.)
   EndIf
   DbSelectArea(cAliasXZ1)
   DbCloseArea()
   
Return(.T.)
/////////////////////////////////////////////////////
/// Ita - 20/05/2019
///     - Função fVlDelOk(n)
///     - Validação da deleção de uma linha no grid
///     - Usada
Static Function fVlDelOk(_nLGrd,_pPrdDel)
   xArea := GetArea() 
   _nRecTrb := (cArqTrab)->(Recno())
   _dDataDel := GdFieldGet("Z1_DTENTR",_nLGrd)
   _nQtDel := GdFieldGet("Z1_QUANT",_nLGrd)
   /*
   If Empty(_nQtDel)
      Alert("Posicione no item com quantidade maior que zero para poder deletar!")
      oMrkBrowse:GoTo (_nRecTrb,.T.)
      RestArea(xArea)
      Return (.F.)
   EndIf
   */
   If MsgYesNo("Tem certeza que deseja deletar a data "+DTOC(_dDataDel)+" para todo pedido?")
   
	   _nPosDt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_DTENTR"})
	   _nPosQt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_QUANT"})
	   _nPosPr := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_PRUNIT"})
	   _nPosTo := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_TOTAL"})
	   aTmpCols := {}
	   lColsVazio := .T.
	   //If GdDeleted(_nLGrd) //Se a linha estiver deletada
	      //MsgInfo("A linha está deletada")
	      //MsgInfo("Momento 1 - Len(oGetDados:aCols): "+Alltrim(Str(Len(oGetDados:aCols))))
		  For nT:=1 to Len(oGetDados:aCols)
			If !oGetDados:aCols[nT,Len(aHeader)+1]
			   lColsVazio := .F.
			   If DTOS(oGetDados:aCols[nT,_nPosDt]) <> DTOS(_dDataDel)
			      aadd(aTmpCols, { oGetDados:aCols[nT,_nPosDt],  oGetDados:aCols[nT,_nPosQt],  oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo]})
			   EndIf
			Endif
		  Next nT
	   //EndIf
	   oGetDados:aCols := {}
	   For nTmp := 1 To Len(aTmpCols)
	      aAdd(oGetDados:aCols, {aTmpCols[nTmp,1],aTmpCols[nTmp,2],aTmpCols[nTmp,3],aTmpCols[nTmp,4],.F.} )
	   Next nTmp
       //MsgInfo("Momento 2 - Len(oGetDados:aCols): "+Alltrim(Str(Len(oGetDados:aCols))))	   
	   cQryUPD := " UPDATE "+RetSQLName("SZ1") + _Enter
	   cQryUPD += "    SET D_E_L_E_T_ = '*'" + _Enter
	   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
	   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
	   cQryUPD += "    AND Z1_CODFORN = '"+Padr(aPCRev[13],6)+"'" + _Enter
	   cQryUPD += "    AND Z1_DTINCL = '"+If((_nOpcCont == 2),DTOS(dDataBase),DTOS((cAliasTMP)->TMP_DTINCL))+"'" + _Enter
	   cQryUPD += "    AND Z1_DTENTR = '"+DTOS(_dDataDel)+"'" + _Enter
	   //cQryUPD += "    AND Z1_PRODUTO = '"+_pPrdDel+"'" + _Enter
	   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
	   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
	   
	   MemoWrite("C:\TEMP\fVlDelOk.SQL",cQryUPD)
	   MemoWrite("\Data\fVlDelOk.SQL",cQryUPD)
	
       If TCSqlExec( cQryUPD ) <> 0
          MsgAlert( " Erro ao tentar excluir datas do Pedido " + TCSqlError() )   
       EndIf
	   If Len(_aItemPC) > 0
	      _nAcho := aScan(_aItemPC,{|x| x[1]+x[6] == _cCodProd+"1"})
		  For nL := 1 To Len(_aItemPC)
		     //aadd(_aItemPC, { _cCodProd, _dDtEnt,  _nQtdPC,  _nPrcPC,  _nTotPC, "1"})
		     If DTOS(_aItemPC[nL,2]) == DTOS(_dDataDel)
		        _aItemPC[nL, 6] := "0"
		     EndIf
		  Next nL
	   EndIf
	   //_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
	   //fAtuTotais(cfilant,Padr(aPCRev[13],6),_psDtInc,3) //Ita - 29/05/2019
       /*
	   _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
	   If !fChkTemZ1(aPCRev[13],_IncDt)
           //MsgInfo("aCols VAZIO!")
           
           dbSelectArea(cArqTrab)
            RecLock(cArqTrab,.F.)
               Replace TRB_OK with " "
            MsUnLock()
           
           For nLimp := 1 To Len(aMrkTRB) //Ita - 24/05/2019 - Controle para não precisar percorrer todo cArqTrab para desmarcar itens
		      If aMrkTRB[nLimp,2] == 1
		         dbSelectArea(cArqTrab)
		         dbsetorder(1) //TRB_COD
		         If DbSeek(aMrkTRB[nLimp,1]) //DbGoTo(Val(aMrkTRB[nLimp,1]))
		            RecLock((cArqTrab),.F.)
		               (cArqTrab)->TRB_OK := " "
		            MsUnLock()
		            //MsgInfo("Alterei produto "+(cArqTrab)->TRB_COD)
		            oMrkBrowse:oBrowse:Refresh()
		         EndIf
		     EndIf
		   Next nLimp
		  oMrkBrowse:Refresh:lGoTop := .F. 
		  
	   EndIf
       */
	   akQrea := GetArea()
	   oGetDados:oBrowse:Refresh()
	   Eval(bCrgPC) //Ita - 20/05/2019 - Refresh dos itens do PC após atualização da data de faturamento.
	   //_aItemPC := {} //Ita - 28/05/2019
	   Eval(bAtuZ1) //Ita - Refresh do pedido
	   RestArea(akQrea)
	   oGetDados:oBrowse:SetFocus()
       SetKey(VK_F2, { || Conf_PC(), oDlgPC:End() } )
       SetKey(VK_F4, { || fAltData(aHeader)} ) //Ita - 20/05/2019 - Alteração da Data do Pedido.
       //MsgInfo("5. Alterei função F4") //Ita - 25/06/2019
	   _oItemSel:Refresh()
	   _oValPC:Refresh()
	   oGetDados:oBrowse:Refresh()
	   //Ita - 06/06/2019 - oMrkBrowse:oBrowse:oBrowse:Refresh(.t.)
	   //Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh(.t.)
	   //lGoTop := .F. 
       //oMrkBrowse:Refresh(lGoTop)
       oMrkBrowse:Refresh(.F.)
	   oPanel:Refresh()
	   oDlgy:Refresh()
	   //MsgInfo("Momento 3 - Len(oGetDados:aCols): "+Alltrim(Str(Len(oGetDados:aCols))))	   
   Else
      dbSelectArea(cArqTrab)
      //Ita - 10/06/2019 - dbsetorder(_nOrdTrab) //Ita - 29/05/2019 - dbsetorder(2)
      //Ita - 10/06/2019 - DbGoTop()
      //Ita - 10/06/2019 - RestArea(xArea)
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
      Return(.F.)
   EndIf
   dbSelectArea(cArqTrab)
   dbsetorder(_nOrdTrab) //Ita 18/06/2019 - //Ita - 29/05/2019 - dbsetorder(2)
   oPanel:Refresh()
   oDlgy:Refresh()
   //Ita - 10/06/2019 - oMrkBrowse:GoTo (_nRecTrb,.T.)
   //Ita - 10/06/2019 - RestArea(xArea)
Return (.T.)

//////////////////////////////////////////////////////////////
/// Ita - 20/05/2019
///     - Função fAltData()
///     - Alteração da Data de necessidade/faturamento do PC
///     - Esta alteração será aplicada para todos os itens.
Static Function fAltData(aHeader)
   xArea := GetArea()
   _nPosDt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_DTENTR"}) 
   _nRecTrb := (cArqTrab)->(Recno())
   aPerg		:= {}
   _dPar01 := oGetDados:aCols[oGetDados:nAT,_nPosDt]
   _dPar02 := CTOD(SPACE(8)) 
   MV_PAR01 := CTOD(SPACE(8)) 
   MV_PAR02 := CTOD(SPACE(8))  
   aAdd( aPerg,{1,"Data Atual: ",_dPar01                   ,"@!"  ,"AllwaysTrue()","" ,".F.",70,.T.})
   aAdd( aPerg,{1,"Nova Data : ",_dPar02                   ,"@!"  ,"AllwaysTrue()","" ,".T.",70,.T.})
 //aAdd( aPerg  ,{1,"Codigo: "    ,SPACE(TAMSX3("B1_COD")[1]),"@!","AllwaysTrue()","" ,".T.",100,.T.})
 //aAdd( aPerg ,{1,Alltrim("Fator"),0.00,"@E 999.9999",".T.","","",30,.F.})
   cTitulo := "Informe a nova data do pedido"
   aRet := {}
   //If ParamBox(aDtPerg,cTitulo,@aRet)

   bOk			:= {|| (.T.)}
   aButtons	:= {}
   lCentered	:= .T.
   nPosX		:= 0
   nPosY		:= 0
   cLoad     := ProcName(1)
   lCanSave	:= .T.
   lUserSave	:= .F.
   aButtons	:= {}

   //If ParamBox(aPerg, cTitulo,@aRet, bOk, aButtons, lCentered, nPosx, nPosy, oDlgPC , cLoad, lCanSave, lUserSave)
   If ParamBox(aPerg, cTitulo,@aRet, bOk, aButtons, lCentered,        ,      ,        , cLoad, lCanSave, lUserSave)
      _DtAtu := MV_PAR01
      _NwDat := MV_PAR02
	   If Empty(MV_PAR01) .Or. Empty(MV_PAR02)
	      Alert("Parâmetro em branco, impossibilita a continuação do processo")
	      Return
	   EndIf
	   If DTOS(MV_PAR01) == DTOS(MV_PAR02)
	      Alert("As datas são iguais, não há necessidade de alteração!")
	      Return
	   EndIf
	   If MV_PAR02 < DDATABASE
	      Alert("A Data digitada "+DTOC(MV_PAR02)+" não pode ser inferior a "+DTOC(DDATABASE))
	      Return(.F.)
	   EndIf
      lTemDt := .F.
      For nVld := 1 To Len(oGetDados:aCols)
         If DTOS(oGetDados:aCols[nVld,_nPosDt]) == DTOS(_DtAtu)
            lTemDt := .T.
         EndIf
      Next nVld
      If !lTemDt
         Alert("A Data atual "+DTOC(_DtAtu)+" não foi localizada entre os itens!")
         Return
      EndIf

      For nVld := 1 To Len(oGetDados:aCols)
         If DTOS(oGetDados:aCols[nVld,_nPosDt]) == DTOS(_NwDat)
            Alert("A Nova Data "+DTOC(_NwDat)+" já existe entre os itens, não poderá ocorrer duplicação de datas!")
            Return
         EndIf
      Next nVld

	  If MsgYesNo("Tem certeza que deseja alterar a data "+DTOC(_DtAtu)+" para "+DTOC(_NwDat)+" em todos os itens")
		   _nPosDt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_DTENTR"})
		   _nPosQt := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_QUANT"})
		   _nPosPr := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_PRUNIT"})
		   _nPosTo := aScan(aHeader,{|x| AllTrim(x[2])=="Z1_TOTAL"})
		   /*
		  For nT:=1 to Len(oGetDados:aCols)
			If !oGetDados:aCols[nT,Len(aHeader)+1]
			   If DTOS(oGetDados:aCols[nT,_nPosDt]) == DTOS(_DtAtu)
			      oGetDados:aCols[nT,_nPosDt] := _NwDat
			   EndIf
			Endif
		  Next nT
		  */
	      aTmpCols := {}
		  For nT:=1 to Len(oGetDados:aCols)
			If !oGetDados:aCols[nT,Len(aHeader)+1]
			   aadd(aTmpCols, { oGetDados:aCols[nT,_nPosQt],oGetDados:aCols[nT,_nPosDt], oGetDados:aCols[nT,_nPosPr],  oGetDados:aCols[nT,_nPosTo]})
			   If DTOS(oGetDados:aCols[nT,_nPosDt]) == DTOS(_DtAtu)
                  aTmpCols[nT,_nPosDt] := _NwDat
			   EndIf
			Endif
		  Next nT
	      oGetDados:aCols := {}
	      For nTmp := 1 To Len(aTmpCols)
	         aAdd(oGetDados:aCols, {aTmpCols[nTmp,_nPosQt],aTmpCols[nTmp,_nPosDt],aTmpCols[nTmp,_nPosPr],aTmpCols[nTmp,_nPosTo],.F.} )
	      Next nTmp		  
		   cQryUPD := " UPDATE "+RetSQLName("SZ1") + _Enter
		   cQryUPD += "    SET Z1_DTENTR = '"+DTOS(_NwDat)+"'" + _Enter
		   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
		   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
		   cQryUPD += "    AND Z1_CODFORN = '"+Padr(aPCRev[13],6)+"'" + _Enter
		   cQryUPD += "    AND Z1_DTINCL = '"+If((_nOpcCont == 2),DTOS(dDataBase),DTOS((cAliasTMP)->TMP_DTINCL))+"'" + _Enter
		   cQryUPD += "    AND Z1_DTENTR = '"+DTOS(_DtAtu)+"'" + _Enter
		   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
		   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
		   
		   MemoWrite("C:\TEMP\fAltData.SQL",cQryUPD)
		
	       If TCSqlExec( cQryUPD ) <> 0
	          MsgAlert( " Erro ao tentar alterar datas do Pedido " + TCSqlError() )   
	       EndIf
	       //Eval(bCrgPC) //Ita - 20/05/2019 - Refresh dos itens do PC após atualização da data de faturamento.
	       //Eval(bAtuZ1) //Ita - Refresh do pedido
	       //aadd(_aItemPC, { _cCodProd, _dDtEnt,  _nQtdPC,  _nPrcPC,  _nTotPC, "1"})
	       //MsgInfo("Atualizando Datas...")
	       For nIt := 1 To Len(_aItemPC)
	          //If _aItemPC[nIt,1] == _cCodProd .And. DTOS(_aItemPC[nIt,2]) == DTOS(_DtAtu)
	          If DTOS(_aItemPC[nIt,2]) == DTOS(_DtAtu)
	             _aItemPC[nIt,2] := _NwDat
	             //MsgInfo("Produto "+_aItemPC[nIt,1]+" Nova data "+DTOC(_aItemPC[nIt,2]))
	          EndIf
	       Next nIt
		   _oItemSel:Refresh()
		   _oValPC:Refresh()
		   oGetDados:oBrowse:Refresh()
	  EndIf
   EndIf
   Eval(bCnfPC) //Ita - 03/06/2019 - Já confirma as quantidades da data digitada/pedido.
   //Ita - 10/06/2019 - oMrkBrowse:GoTo (_nRecTrb,.T.)
   //Ita - 10/06/2019 - RestArea(xArea)
Return
/////////////////////////////////////////////
/// Ita - 23/05/2019
///     - Função fChkDupZ1
///     - Checa duplicidades no SZ1
Static Function fChkDupZ1(pFor,pDtEnt,pDtInc,pCdPrd)
   cAliZ1Duo := "YDZ1"
   
   cQryUPD := " SELECT COUNT(*) NQTDZ1 " + _Enter
   cQryUPD += "   FROM "+RetSQLName("SZ1") + _Enter
   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
   cQryUPD += "    AND Z1_CODFORN = '"+Padr(pFor,6)+"'" + _Enter
   cQryUPD += "    AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
   cQryUPD += "    AND Z1_DTENTR = '"+DTOS(pDtEnt)+"'" + _Enter
   cQryUPD += "    AND Z1_PRODUTO = '"+pCdPrd+"'" + _Enter
   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fChkDupZ1.SQL",cQryUPD)
   MemoWrite("\Data\fChkDupZ1.SQL",cQryUPD)
   cQryUPD := ChangeQuery(cQryUPD)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryUPD),cAliZ1Duo,.T.,.T.)
   dbSelectArea(cAliZ1Duo)
   lTemZ1 := If((cAliZ1Duo)->NQTDZ1 > 0,.T.,.F.)
   DbCloseArea()

Return(lTemZ1)

/////////////////////////////////////////////
/// Ita - 23/05/2019
///     - Função fChkDupZ1
///     - Checa duplicidades no SZ1
Static Function fUpdZ1(pFor,pDtEnt,pDtInc,pQtIte,pPrIte,pCdPrd)
   cAliZ1Duo := "YDZ1"
   
   cQryUPD := "  UPDATE "+RetSQLName("SZ1") + _Enter
   cQryUPD += "     SET Z1_COMPRAD = '"+cUser+"'," + _Enter
   cQryUPD += "         Z1_STATUS  = '"+_vStatus+"'," + _Enter
   cQryUPD += "         Z1_QUANT   = '"+cValToChar(pQtIte)+"'," + _Enter
   cQryUPD += "         Z1_PRUNIT  = '"+cValToChar(pPrIte)+"'," + _Enter
   cQryUPD += "         Z1_TOTAL   = '"+cValToChar(ROUND(pPrIte * pQtIte,TAMSX3("Z1_TOTAL")[2]))+"'" + _Enter
   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
   cQryUPD += "    AND Z1_CODFORN = '"+Padr(pFor,6)+"'" + _Enter
   cQryUPD += "    AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
   cQryUPD += "    AND Z1_DTENTR = '"+DTOS(pDtEnt)+"'" + _Enter
   cQryUPD += "    AND Z1_PRODUTO = '"+pCdPrd+"'" + _Enter
   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fUpdZ1.SQL",cQryUPD)
   MemoWrite("\Data\fUpdZ1.SQL",cQryUPD)
   If TCSqlExec( cQryUPD ) <> 0
      MsgAlert( " Erro ao tentar atualizar alterar do Pedido " + TCSqlError() )   
   EndIf
   //Ita - 30/05/2019 - fAtuTotais(xFilial("SZ1"),Padr(pFor,6),pDtInc,1) //Ita - 29/05/2019 - Atualiza totais do pedido
   //_psDtInc := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)
   //fAtuTotais(cFilAnt,Padr(pFor,6),pDtInc,1) //Ita - 29/05/2019 - Atualiza totais do pedido
   _IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL)   
   //Ita - 05/09/2019 - If !fChkTemZ1(aPCRev[13],_IncDt,pCdPrd,2) 
   If !fChkQtdZ1(aPCRev[13],_IncDt,pCdPrd,2) 
   
      DbSelectArea(cArqTrab)
      DbSetOrder(1) //Ordena por produto
      If DbSeek(pCdPrd)
         RecLock(cArqTrab,.F.)
         //Alert("Entrei aqui - 11)")
            Replace TRB_OK with " "
         MsUnLock()
      EndIf
   EndIf
Return

/////////////////////////////////////////////
/// Ita - 24/05/2019
///     - Função fChkDupZ1
///     - Checa duplicidades no SZ1
Static Function fChkTemZ1(pFor,pDtInc,pProd,nCall)
   cAliTemZ1 := "YTZ1"
   
   cQryUPD := " SELECT COUNT(*) NQTDZ1 " + _Enter
   cQryUPD += "   FROM "+RetSQLName("SZ1") + _Enter
   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
   cQryUPD += "    AND Z1_CODFORN = '"+Padr(pFor,6)+"'" + _Enter
   cQryUPD += "    AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
   If nCall == 2
      cQryUPD += "    AND Z1_PRODUTO = '"+pProd+"'" + _Enter
   EndIf
   //Ita - 05/09/2019 - cQryUPD += "    AND Z1_QUANT > 0 " + _Enter //Ita - 29/05/2019
   cQryUPD += "    AND Z1_QUANT >= 0 " + _Enter //Ita - 05/09/2019
   
   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fChkTemZ1.SQL",cQryUPD)
   MemoWrite("\Data\fChkTemZ1.SQL",cQryUPD)
   cQryUPD := ChangeQuery(cQryUPD)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryUPD),cAliTemZ1,.T.,.T.)
   dbSelectArea(cAliTemZ1)
   lTemZ1 := If((cAliTemZ1)->NQTDZ1 > 0,.T.,.F.)
   DbCloseArea()

Return(lTemZ1)
//////////////////////////
/// Ita - 24/05/2019
///     - Função para limpar todos os registros
///     - marcados no objeto oMrkBrowse
///     - sintaxe: oMrkBrowse:bAllMark  := {|| fLimpAll()}
Static Function fLimpAll()
   //_IncDt := If((_nOpcCont == 2),dDataBase,(cAliasTMP)->TMP_DTINCL) 
   //If !fChkTemZ1(aPCRev[13],_IncDt)
   //MsgInfo("aCols VAZIO!")
   For nLimp := 1 To Len(aMrkTRB) //Ita - 24/05/2019 - Controle para não precisar percorrer todo cArqTrab para desmarcar itens
      If aMrkTRB[nLimp,2] == 1
         dbSelectArea(cArqTrab)
         dbsetorder(1) //TRB_COD
         If DbSeek(aMrkTRB[nLimp,1]) //DbGoTo(Val(aMrkTRB[nLimp,1]))
            RecLock((cArqTrab),.F.)
            //Alert("Entrei aqui - 12)")
               (cArqTrab)->TRB_OK := " "
            MsUnLock()
            //MsgInfo("Desmarquei produto "+(cArqTrab)->TRB_COD)
         EndIf
     EndIf
   Next nLimp
   
   _nValPC		:= 0       //Ita - 29/05/2019
   _nItemSel	:= 0       // "        "
   _oItemSel:Refresh()     // "        "
   _oValPC:Refresh()       // "        "
   
  //Ita - 06/06/2019 - oMrkBrowse:oBrowse:Refresh() 
  //Ita - 06/06/2019 - oMrkBrowse:Refresh:lGoTop := .F.
  oPanel:Refresh()
	  
  //EndIf
Return

Static Function fExcZ1(pFor,pDtInc,_dDtExc,pProd,nCall)
   If nCall == 1
      cQryUPD := " SELECT COUNT(*) NQTDZ1 " + _Enter
      cQryUPD += "   FROM "+RetSQLName("SZ1") + _Enter
   Else
      cQryUPD := " UPDATE "+RetSQLName("SZ1") + _Enter
      cQryUPD += "    SET D_E_L_E_T_ = '*'" + _Enter
   EndIf
   //Ita - 30/05/2019 - cQryUPD += "  WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'" + _Enter
   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
   cQryUPD += "    AND Z1_CODFORN = '"+Padr(pFor,6)+"'" + _Enter
   cQryUPD += "    AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
   cQryUPD += "    AND Z1_DTENTR = '"+DTOS(_dDtExc)+"'" + _Enter
   cQryUPD += "    AND Z1_PRODUTO = '"+pProd+"'" + _Enter
   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fExcZ1_"+Alltrim(Str(nCall))+".SQL",cQryUPD)
   MemoWrite("\Data\fExcZ1_"+Alltrim(Str(nCall))+".SQL",cQryUPD)
   If nCall == 1
      cAQSZ1 := "CTMZ1"
      cQryUPD := ChangeQuery(cQryUPD)
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryUPD),cAQSZ1,.T.,.T.)
      TCSetField(cAQSZ1,"Z1_DTINCL","D",08,00)
      dbSelectArea(cAQSZ1)
      lRetCons := If((cAQSZ1)->NQTDZ1 > 0,.T.,.F.)
      DbCloseArea()
      Return(lRetCons)
   Else
      If TCSqlExec( cQryUPD ) <> 0
         MsgAlert( " Erro ao tentar excluir a quatidade do item do pedido " + TCSqlError() )   
      EndIf
   EndIf
Return
/////////////////////////
/// Ita - 29/05/2019
///     - Validação dos parâmetros _cMesIni e _cMesFim

Static Function fVlMesAno(_pMesAno,_nCall,_par1)
   If Len(Alltrim(_pMesAno)) < 4
      Alert("Informe o perido inicial ou final com 4 digitos, considerando dois para o mês e dois para o ano, se necessário coloque zero a esquerda")
      Return(.F.)
   EndIf
   If Val(Left(_pMesAno,2)) < 1 .Or. Val(Left(_pMesAno,2)) > 12
      Alert("Favor informar meses entre 01 e 12")
      Return(.F.)
   EndIf

	   If Val(Right(_pMesAno,2)) > Val(Right(_par1,2))
	      Alert("O Ano final "+Right(_par1,2)+" está menor que o Ano inicial "+Right(_pMesAno,2)+", favor corrigir o período")
	      Return(.F.)
	   EndIf

   If Right(_pMesAno,2) > Substr(DTOS(dDataBase),3,2)
      Alert("O Ano informado na "+If(_nCall==1,"data inicial","data final")+" é superior ao ano da data base "+Substr(DTOS(dDataBase),3,2))
      Return(.F.)
   EndIf
Return(.T.)


//////////////////////////////////////////////////
/// Ita - 29/05/2019
///     - Função fAtuTotais 
///     - Criado para atualizar totais do Pedido
///     - _xpCall = 1=Valor, 2=Qtd.Itens e 3=Valor e Quantidade de Itens

Static Function fAtuTotais(_xpFil,_xpFor,_xpDtInc,_xpCall)
   
   For nRun := 1 To 2		   
       
       If nRun == 1
          cQryToo := " SELECT COUNT(DISTINCT SZ1.Z1_FILIAL||SZ1.Z1_CODFORN||SZ1.Z1_PRODUTO) NQTDITENS " + _Enter
       Else
          cQryToo := " SELECT SUM(SZ1.Z1_QUANT) Z1_QUANT, SUM(SZ1.Z1_TOTAL) Z1_TOTAL, SUM((SZ1.Z1_PRUNIT / ((100 - SB1.B1_IPI)/100))* SZ1.Z1_QUANT) Z1_TOTCIPI " + _Enter
       EndIf
       cQryToo += " FROM "+RetSQLname("SZ1")+" SZ1,"+RetSQLName("SB1")+" SB1 " + _Enter
	   cQryToo += "  WHERE SZ1.Z1_FILIAL = '"+_xpFil+"'" + _Enter
	   cQryToo += "    AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'" + _Enter
	   cQryToo += "    AND SZ1.Z1_CODFORN = '"+_xpFor+"'" + _Enter
	   cQryToo += "    AND SZ1.Z1_DTINCL = '"+DTOS(_xpDtInc)+"'" + _Enter
	   //cQryToo += "    AND Z1_DTENTR = '"+DTOS(_dDtExc)+"'" + _Enter
	   //cQryToo += "    AND Z1_PRODUTO = '"+pProd+"'" + _Enter
	   cQryToo += "    AND Z1_PRODUTO = SB1.B1_COD" + _Enter
	   cQryToo += "    AND SZ1.Z1_QUANT > 0 " + _Enter
	   cQryToo += "    AND SZ1.Z1_STATUS IN ('1','2')" + _Enter
	   cQryToo += "    AND SZ1.D_E_L_E_T_ <> '*'" + _Enter      
	   cQryToo += "    AND SB1.D_E_L_E_T_ <> '*'" + _Enter      
       
       cATZ1 := "CATZ1"
       cQryToo := ChangeQuery(cQryToo)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryToo),cATZ1,.T.,.T.)
       
       If nRun == 1
           MemoWrite("C:\TEMP\fAtuTotais_"+Alltrim(Str(nRun))+".SQL",cQryToo)
           MemoWrite("\Data\fAtuTotais_"+Alltrim(Str(nRun))+".SQL",cQryToo)
	       dbSelectArea(cATZ1)
	       _nQtItens := cATZ1->NQTDITENS
	       DbCloseArea()
       Else
           TCSetField(cATZ1,"Z1_TOTAL","N",17,02)
           TCSetField(cATZ1,"Z1_QUANT","N",09,02)
           MemoWrite("C:\TEMP\fAtuTotais_"+Alltrim(Str(nRun))+".SQL",cQryToo)
           MemoWrite("\Data\fAtuTotais_"+Alltrim(Str(nRun))+".SQL",cQryToo)
	       dbSelectArea(cATZ1)
	       _nTtItens := cATZ1->Z1_TOTAL
	       _xQtdVol  := cATZ1->Z1_QUANT
	       _xTtCIPI  := cATZ1->Z1_TOTCIPI
	       DbCloseArea()
       EndIf
   
   Next nRun
   
   If _xpCall == 3
      _nValPC := 0
      _nValPC := _nTtItens
      _oValPC:Refresh()
      _nItemSel := 0
      _nItemSel := _nQtItens
      _oItemSel:Refresh()
      _nQtdVol := _xQtdVol 
      _oQtdVol:Refresh()
      _nVlCIPI:= _xTtCIPI
      _oVlCIPI:Refresh()
      _nValIPI:= (_xTtCIPI - _nTtItens) //Ita - 05/06/2019 - Valor de IPI do Pedido
      _oValIPI:Refresh()
   Else
	   If _xpCall == 1
	      _nValPC := 0
	      _nValPC := _nTtItens
	      _oValPC:Refresh()
          _nQtdVol := _xQtdVol 
          _oQtdVol:Refresh()
          _nVlCIPI:= _xTtCIPI
          _oVlCIPI:Refresh()
          _nValIPI:= (_xTtCIPI - _nTtItens) //Ita - 05/06/2019 - Valor de IPI do Pedido
          _oValIPI:Refresh()
	   Else
	      _nItemSel := 0
	      _nItemSel := _nQtItens
	      _oItemSel:Refresh()
	   EndIf            
   EndIf
Return
Static Function fGetFil(pFilPrth,nCall)
   
   cAliX5 := "XTMX5"
    
   cQry := " SELECT SUBSTR(X5_CHAVE,1,3) XFILANL, SUBSTR(X5_DESCRI,1,6) XFILPRT " + _Enter   
   cQry += "   FROM "+RetSQLName("SX5") + _Enter   
   cQry += "  WHERE X5_FILIAL = '"+xFilial("SX5")+"'" + _Enter   
   cQry += "    AND X5_TABELA = '99'" + _Enter   
   If nCall == 1
      cQry += "    AND SUBSTR(X5_DESCSPA,1,6) = '"+Left(pFilPrth,6)+"'" + _Enter   
   Else
      cQry += "    AND SUBSTR(X5_CHAVE,1,3) = '"+Left(pFilPrth,3)+"'" + _Enter   
   EndIf
   cQry += "    AND D_E_L_E_T_ <> '*'" + _Enter   
   
   MemoWrite("C:\TEMP\fGetFil.SQL",cQry) //Ita - 02/04/2019
   MemoWrite("\Data\fGetFil.SQL",cQry) //Ita - 02/04/2019
   cQry := ChangeQuery(cQry)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliX5,.T.,.T.)
   DbSelectArea(cAliX5)
   If nCall == 1
      _cFilANL :=  Substr((cAliX5)->XFILANL,1,3)
   Else
      _cFilANL :=  Substr((cAliX5)->XFILPRT,1,6)
   EndIf
   DbCloseArea() 
   
Return(_cFilANL)

//////////////////////////////////////////////
/// Ita - 30/05/2019
///     - Função fVldFor
///     - Validação do código do Fornecedor.
Static Function fVldFor()
   Alert("Favor informar um código de fornecedor")
Return(.F.)

//////////////////////////////////////////////
/// Ita - 30/05/2019
///     - Função fVldFor
///     - Validação do código da linha do produto.
Static Function fVlsZZN(xpLinha)
   If !Empty(xpLinha)
      //Alert("Favor informar um código de linha")
      //Return(.F.)
   
      DbSelectArea("ZZN")
      DbSetOrder(3)//ZZN_FILIAL+ZZN_LINHA+ZZN_COD
      If !DbSeek(xFilial("ZZN")+xpLinha)
         Alert("A linha digitada não está cadastrada")
         Return(.F.)
      EndIf
   EndIf
Return(.T.)
/////////////////////////////////////////
/// Ita - 03/06/2019
///     - Validção do Código do Produto
Static Function fVldPrd(_pCdProd)
   If !Empty(_pCdProd) 
	   DbSelectArea("SB1")
	   DbSetOrder(1)//B1_FILIAL+B1_COD
	   If !Dbseek(xFilial("SB1")+PadR(_pCdProd,15))
	      Alert("O Código do produto "+_pCdProd+" não foi localizado no cadastro")
	      Return(.F.)
	   EndIf
   EndIf

Return(.T.)
/////////////////////////////////////////
/// Ita - 03/06/2019
///     - Validção da Letra da Curva
Static Function fVldCrv(_pCurva)
   //MsgInfo("_pCurva: "+_pCurva)
   _cParCrv := Right(Alltrim(_pCurva),1)  
   If !Empty(_pCurva)
      If !(_pCurva $ "A/B/C/D")
         Alert("Para curvas, favor informar um valor entre A/B/C/D")
         Return(.F.)
      EndIF
   EndIf
Return(.T.)

//////////////////////////////////////////////
/// Ita - 03/06/2019
///     - Validar parâmetros quando teclar F2
Static Function fVldPar()
   ///Validação das letras das curvas digitadas. 
   For nCrv := 1 To 4
      If !fVldCrv(&("_cCurva"+Alltrim(Str(nCrv))))
         Return(.F.)
      EndIf
   Next nCrv
   If !Empty(_cCodProd)
      If !fVldPrd(_cCodProd)
         Return(.F.)
      EndIf
   EndIf
   For nVL := 1 To 5
     If !Empty(&("_cLinha"+Alltrim(Str(nVL))))
        If !fVlsZZN(&("_cLinha"+Alltrim(Str(nVL))))
           Return(.F.)
        EndIf
     EndIf
   Next nVL
   If Empty(_cCodMarc) 
      fVldFor() 
      Return(.F.)
   EndIf
   
   For nDt := 1 To 2
	   If !fVlMesAno(_cMesIni,nDt,_cMesFim)
	      Return(.F.)
	   EndIf
   Next nDt 
   
Return(.T.)

////////////////////////////////////
/// Ita - 05/06/2019
///     - Checa se existe movimento
Static Function fTemMov()
    cMovAlias := "QRYMOV"
	_cQuery := " SELECT COUNT(*) NQTMOV FROM ( " 
	_cQuery += "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
	_cQuery += "       SUM(D2_QUANT) D2_QUANT" + _Enter
	_cQuery += "  FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SF4") + " SF4 " + _Enter
	_cQuery += " WHERE D2_FILIAL IN " + _cFilSel + "" + _Enter
	If Substr(aPCRev[35],1,1) == "T"
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVTri + "" + _Enter //Ita - 06/06/2019
	Else
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMesVend + "" + _Enter
	Endif
	_cQuery += " AND SD2.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " AND D2_COD = B1_COD " + _Enter
	_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
	_cQuery += " AND D2_TES = F4_CODIGO " + _Enter
	_cQuery += " AND F4_TRANFIL <> '1' " + _Enter
	_cQuery += " AND F4_ESTOQUE = 'S' " + _Enter
	_cQuery += " AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "	 + _Enter
	_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
	If !Empty(aPCRev[19])
		_cQuery += " AND B1_COD = '" + aPCRev[19] + "'" + _Enter
	Endif
	If !Empty(aPCRev[13])
		_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
	Endif	
	_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
	If aPCRev[33] == "1"		// 1 - Ja comprado; 2 - Não Comprado; 3 - Ambos
		_cQuery += " AND B1_UCOM <> '        '" + _Enter
	ElseIf aPCRev[33] == "2"
		_cQuery += " AND B1_UCOM = '        '" + _Enter
	Endif
	_cQuery += " AND B1_TIPO = 'ME'" + _Enter   //Ita - 03/06/2019 - Evitar trazer itens de consumo.
	If !Empty(_cFilGrp)
		_cQuery += " AND B1_XLINHA IN " + _cFilGrp + ""  + _Enter
	Endif
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
	_cQuery += " GROUP BY B1_XALTIMP,B1_XMESTRE,B1_XLINHA" + _Enter
	_cQuery += " ) TABMOV "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cMovAlias,.T.,.T.)
	dbSelectArea(cMovAlias)	
	_TemMvs := If((cMovAlias)->NQTMOV > 0,.T.,.F.)
	DbCloseArea()
Return(_TemMvs)
/*
Static Function fGoDown()
   MsgInfo("Estou em fGoDown")
Return({||oGetDados:GoBottom()})
*/
/* Ita - 10/06/2019
Static Function fAtuMrk()
   MsgInfo("Vou Atualizar oMrkBrowse")
Return({||oMrkBrowse:Refresh(.F.)})
*/

///////////////////////////////////////////
/// Ita - 10/06/2019
///     - Validação do Motivo de Bloqueio
User Function fVldMot()
   _xArea := GetArea()
   If Empty(MV_PAR01)
      Alert("Por Favor informe um motivo para o bloqueio do produto")
      Return(.F.)
   EndIf
   DbSelectArea("SX5")
   DbSetOrder(1)
   If !DbSeek(xFilial("SX5")+"9A"+MV_PAR01)
      Alert("O Motivo "+Alltrim(MV_PAR01)+" ainda não está cadastrado, favor informar um motivo existente na tabela de motivos")
      Return(.F.)
   EndIf
   RestArea(_xArea)
Return(.T.)

///////////////////////////////////////////////
/// Ita - 14/06/2019
///     - Compatibilizado função ANItemPC
///     - para retornar quantidade em pedidos
///     - abertos do produto por filial
Static Function fProdPC(cVar,lUsaFiscal,aPedido,oGetDAtu,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aGets, lTxNeg, nTaxaMoeda,aRetPed, aArrSldoAux,xFilCall)

Local cSeek			:= ""
Local nOpca			:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aAreaColab	:= {}
Local aRateio       := {0,0,0}
Local aNew			:= {}
Local aTamCab		:= {}
Local aSizePed		:= {30,20,270,531}
Local aSizeC7T		:= {}
Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons		:= {}
Local aEstruSC7		:= SC7->( dbStruct() )
Local nFreeQt		:= 0
Local cQuery		:= ""
Local cLine := ""
Local cAliasSC7		:= "SC7"
Local cQueryQPC     := ""
Local cCpoObri		:= ""
Local cComboFor		:= ''
Local nPed			:= 0
Local nX			:= 0
Local nAuxCNT		:= 0
Local lMt103Vpc		:= ExistBlock("MT103VPC")
Local lMt100C7D		:= ExistBlock("MT100C7D")
Local lMt100C7C		:= ExistBlock("MT100C7C")
Local lMt103C7T		:= ExistBlock("MT103C7T")
Local lMt103Sel		:= ExistBlock("MT103SEL")
Local nMT103Sel     := 0
Local nSelOk        := 1
Local lRet103Vpc	:= .T.
Local lMT103BPC 	:= ExistBlock("MT103BPC")
Local lRetBPC    	:= .F.
Local lContinua		:= .T.
Local lQuery		:= .F.
Local lTColab		:= .F.
Local lRestNfe		:= SuperGetMV("MV_RESTNFE") == "S"
Local lForPCNF		:= SuperGetMV("MV_FORPCNF",.F.,.F.)
Local lXmlxped		:= SuperGetMV("MV_XMLXPED",.F.,.F.)
Local lRetPed		:= (aRetPed == Nil)
Local oQual
Local oDlgPCN
Local oSize
Local oComboBox
Local aUsButtons  	:= {}
Local lPrjCni 		:= If(FindFunction("ValidaCNI"),ValidaCNI(),.F.)
Local lToler		:= .F.
Local nPosItPc		:= 0
Local n103TXPC		:= 0
Local nScan	    	:= 0
Local aMT103FRE	:= {}
Local nQtdItMark	:= 0
Local cTipo			:= "N"
PRIVATE oOk        := LoadBitMap(GetResources(), "LBOK")
PRIVATE oNo        := LoadBitMap(GetResources(), "LBNO")
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacoes da importacao do Pedido de Compras por item  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua .And. lMT103BPC
	lRetBPC := ExecBlock("MT103BPC",.F.,.F.)
	If ValType(lRetBPC)=="L"   
		lContinua:= lRetBPC
	EndIf
EndIf

If lContinua
	DbSelectArea("SC7")
	lQuery    := .T.
	cAliasSC7 := "QRYSC7"
	cQuery	  := "SELECT "
	For nAuxCNT := 1 To Len( aEstruSC7 )
		cQuery += aEstruSC7[ nAuxCNT, 1 ]
		cQuery += ", "
	Next
	cQuery += " R_E_C_N_O_ RECSC7 " 
	cQuery += " FROM "+RetSqlName("SC7") + " SC7 "
	cQuery += " WHERE "
	//Ita - 30/05/2019 - cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "
	cQuery += "C7_FILENT = '"+xFilEnt(xFilCall)+"' AND "
	cQuery += " C7_PRODUTO = '"+cVar+"' AND "
	cQuery += "C7_TPOP <> 'P' AND "
	If SuperGetMV("MV_RESTNFE") == "S"
		cQuery += "(C7_CONAPRO = 'L' OR C7_CONAPRO = ' ') AND "
	EndIf					
	If !lToler
		cQuery += " SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "
	EndIf
	cQuery += " SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
	cQuery += " SC7.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY "+SqlOrder(SC7->(IndexKey()))	
	cQuery := ChangeQuery(cQuery)
			
	If !lRetPed .And. (cAliasSC7)->(Alias()) == "QRYSC7"
		(cAliasSC7)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
			
	For nX := 1 To Len(aEstruSC7)
		If aEstruSC7[nX,2]<>"C"
			TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
		EndIf
	Next nX

	If (cAliasSC7)->(!Eof()) .Or. lForPCNF
        /* Ita - 13/08/2019 - Compatibilizar código com critérios do CodeAnalysis
           DbSelectArea("SX3")
           DbSetOrder(2)
        */
        DbSelectArea("TDIC")
		MsSeek("C7_NUM")
		cTitField := AllTrim(FWSX3Util():GetDescription( "C7_NUM" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
		AAdd(aCab,cTitField) //x3Titulo()
		Aadd(aCampos,{"C7_NUM",FWSX3Util():GetFieldType( "C7_NUM" ),"R",PesqPict( "SC7", "C7_NUM")})
		aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_NUM" ),TamSX3("C7_NUM")[1],TamSX3("C7_NUM")[2],PesqPict( "SC7", "C7_NUM"),cTitField))//X3Titulo()
		MsSeek("C7_ITEM")
		cTitField := AllTrim(FWSX3Util():GetDescription( "C7_ITEM" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
		AAdd(aCab,cTitField) //x3Titulo()
		Aadd(aCampos,{"C7_ITEM",FWSX3Util():GetFieldType( "C7_ITEM" ),"R",PesqPict( "SC7", "C7_ITEM")})
		aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_ITEM" ),TamSX3("C7_ITEM")[1],TamSX3("C7_ITEM")[2],PesqPict( "SC7", "C7_ITEM"),cTitField))//X3Titulo()
		MsSeek("C7_EMISSAO")
		cTitField := AllTrim(FWSX3Util():GetDescription( "C7_EMISSAO" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
		AAdd(aCab,cTitField) //x3Titulo()
		Aadd(aCampos,{"C7_EMISSAO",FWSX3Util():GetFieldType( "C7_EMISSAO" ),"R",PesqPict( "SC7", "C7_EMISSAO")})
		aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_EMISSAO" ),TamSX3("C7_EMISSAO")[1],TamSX3("C7_EMISSAO")[2],PesqPict( "SC7", "C7_EMISSAO"),cTitField))//X3Titulo()
		MsSeek("C7_DATPRF")
		cTitField := AllTrim(FWSX3Util():GetDescription( "C7_DATPRF" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
		AAdd(aCab,cTitField) //x3Titulo()
		Aadd(aCampos,{"C7_DATPRF",FWSX3Util():GetFieldType( "C7_DATPRF" ),"R",PesqPict( "SC7", "C7_DATPRF")})
		aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_DATPRF" ),TamSX3("C7_DATPRF")[1],TamSX3("C7_DATPRF")[2],PesqPict( "SC7", "C7_DATPRF"),cTitField))//X3Titulo()
		MsSeek("C7_QUANT")
		cTitField := AllTrim(FWSX3Util():GetDescription( "C7_QUANT" )) //Ita - 13/08/2019 - Compatibilidade CodeAnalysis
		AAdd(aCab,cTitField) //x3Titulo()
		Aadd(aCampos,{"C7_QUANT",FWSX3Util():GetFieldType( "C7_QUANT" ),"R",PesqPict( "SC7", "C7_QUANT")})
		aadd(aTamCab,CalcFieldSize(FWSX3Util():GetFieldType( "C7_QUANT" ),TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2],PesqPict( "SC7", "C7_QUANT"),cTitField))//X3Titulo()
		DbSelectArea(cAliasSC7)
		Do While If(lQuery, ;
			(cAliasSC7)->(!Eof()), ;
			(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lQuery
				If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO $ "BR") .Or. ;
					(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
					dbSkip()
					Loop
				EndIf
			Endif

			nFreeQT := 0
			nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})
			nFreeQT -= If(nPed>0,aPedido[nPed,2],0)

			lRet103Vpc := .T.

			If lMt103Vpc
				If lQuery
					('SC7')->(MsGoto((cAliasSC7)->RECSC7))
				EndIf															
				lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
			Endif
			If lRet103Vpc
				nFreeQT := (cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT
				If	lToler .And. nFreeQT < 0 
					nFreeQT := 0
				EndIf 
				If nFreeQT > 0 .Or. lToler
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
							ElseIf aCampos[nX][1] == "MARK"
								aArrayF4[Len(aArrayF4)][nX] := oNo
							Else
								aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
							Endif	
						Else
							aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
							If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
								aArrayF4[Len(aArrayF4)][nX] := SB1->B1_XLINHA //Ita - 02/04/2019 - SB1->B1_GRUPO                            									
							EndIf
							If Alltrim(aCampos[nX][1]) == "C7_CODITE"
								aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
							EndIf
						Endif
					Next

					aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

					If lMT100C7D
						If lQuery
							('SC7')->(MsGoto((cAliasSC7)->RECSC7))
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

		/*	Ita - 14/06/2019 - Compatibilidade para usar na consulta F8-fProdPC consulta produto por filial
		If ExistBlock("MT100C7L")
			ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
		EndIf

		If (!Empty(aArrayF4) .Or. lForPCNF) .And. lRetPed

			// Ponto de entrada para redimensionar tela de selecao de pedidos por item
			If lMt103C7T
				aSizeC7T := ExecBlock("MT103C7T",.F.,.F.,{aSizePed})
				If ValType(aSizeC7T) == "A"
					aSizePed := aSizeC7T
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta dinamicamente o bline do CodeBlock                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			DEFINE MSDIALOG oDlgPCN FROM aSizePed[1],aSizePed[2] TO aSizePed[3],aSizePed[4] TITLE OemToAnsi("Pedidos Não Atendidos") Of oMainWnd PIXEL
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula dimensões                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSize := FwDefSize():New(.T.,,,oDlgPCN)
			oSize:AddObject( "CAB"		,  100, IIf(lForPCNF,35,20), .T., .T. ) // Totalmente dimensionavel
			oSize:AddObject( "LISTBOX" 	,  100, IIf(lForPCNF,65,80), .T., .T. ) // Totalmente dimensionavel
			oSize:lProp 	:= .T. // Proporcional             
			oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
				
			oSize:Process() 	   // Dispara os calculos
					
			oQual := TWBrowse():New(oSize:GetDimension("LISTBOX","LININI"),oSize:GetDimension("LISTBOX","COLINI"),;
				 				oSize:GetDimension("LISTBOX","XSIZE")-12,oSize:GetDimension("LISTBOX","YSIZE"),;
				 				,aCab,aTamCab,oDlgPCN,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayF4)

			//If (!Empty(aArrayF4))				
			//	oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := iif(aArrayF4[oQual:nAt,1] == oNo, oOk, oNo) }
			//EndIf

			If !Empty(aArrayF4)
				oQual:bLine := { || aArrayF4[oQual:nAT] }					
			Else
			    cLine := "{" +Replicate("'',",12) +"}"
			    bLine := &( "{ || " + cLine + " }" )					   
				oQual:bLine := bLine
			EndIf

			@ oSize:GetDimension("CAB","LININI")+2 ,oSize:GetDimension("CAB","COLINI")   SAY OemToAnsi("Produto") Of oDlgPCN PIXEL SIZE 47 ,9 //
			@ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI") +27 MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oDlgPCN PIXEL SIZE 100,9

			ACTIVATE MSDIALOG oDlgPCN CENTERED ON INIT EnchoiceBar(oDlgPCN,{|| nOpca:=1,oDlgPCN:End()},{||oDlgPCN:End()},,aButtons)
			
		Endif
		*/ //Ita - 14/06/2019 -  Compatibilidade para uso através da função F8-fProdPC
	Else
		//Ita - 14/06/2019 -  Compatibilidade para uso através da função F8-fProdPC - MsgInfo( "Não encontrado pedidos em aberto" , "Item sem pedido em aberto" )
//		Help(" ",1,"SEMPC",,"Não encontrado pedidos em aberto",4,,,,,,.F.)
	Endif
	dbSelectArea(cAliasSC7)
	dbCloseArea()
Endif
//////////////////////////////////////////////
/// Ita - 14/06/2019
///     - Trata o saldo de pedidos em aberto
_nSldPC := 0
If Len(aArrayF4) > 0
	For nSd := 1 To Len(aArrayF4)
	   _nSldPC += Val(aArrayF4[nSd,5])
	Next nSd
EndIf
RestArea(aArea)
Return(_nSldPC)

///////////////////////////////////////////////////////
/// Ita - 14/06/2019
///     - Marca todos os itens que foram selecionados
///     - através da sugestão de compras
///     - Pedido Automático.
Static Function fMrkAll()

   For nMr := 1 To Len(aMrkTRB)
      If aMrkTRB[nMr,2] == 1
		DbSelectArea("SZ1")
		DbSetOrder(3) //Z1_FILIAL+Z1_CODFORN+Z1_DTINCL+Z1_PRODUTO	   
		If DbSeek(cFilAnt+PadR(aMrkTRB[nMr,3],6)+DTOS(aMrkTRB[nMr,4])+aMrkTRB[nMr,1])
		   If SZ1->Z1_QUANT > 0
              dbSelectArea(cArqTrab)
              dbsetorder(1) //TRB_COD
              If DbSeek(aMrkTRB[nMr,1])
                 RecLock((cArqTrab),.F.)
                 //Alert("Entrei aqui - 5)")
                    (cArqTrab)->TRB_OK := oMrkBrowse:Mark()
                 MsUnLock()
              EndIf
           EndIf
        EndIf
     EndIf
   Next nMr
  oMrkBrowse:Refresh(.F.) 
  oPanel:Refresh()
dbSelectArea(cArqTrab)//Ita - 14/06/2019
//Ita - 18/06/2019 - dbSetOrder(2)         //Ita - 14/06/2019
dbsetorder(_nOrdTrab) //Ita - 18/06/2019 - Manter ordem selecionada na tela de parâmetros
Return
/////////////////////////////////
/// Ita - 20/06/2019
///     - Função para pegar letra e
///     - desconto da tabela de preço
///     - vigente.
Static Function fPsqTbPr(_cFilvar,_cPrdvar,_dVigvar)
   
   Local _cCodDA0 := SuperGetMv("AN_TABPRC",.F.,"100") 
   _Enter     := chr(13) + Chr(10) //Ita - 01/04/2019
   cAlSD1 := "_XDA1"
   
   cQTb := " SELECT DA1.DA1_XLETRA,DA1.DA1_XDESCV,DA1.DA1_PRCVEN,DA1.DA1_XPRCRE " + _Enter
   cQTb += "   FROM "+RetSQLname("DA1")+" DA1 " + _Enter
   cQTb += "  WHERE DA1.DA1_FILIAL = '"+_cFilvar+"'" + _Enter
   cQTb += "    AND DA1.DA1_CODPRO = '"+PadR(_cPrdvar,15)+"'" + _Enter
   cQTb += "    AND DA1.DA1_CODTAB = '"+_cCodDA0+"'"
   //Ita - 05/11/2019 - Solicitação de Christiane - cQTb += "    AND DA1.DA1_DATVIG <= '"+DTOS(dDataBase)+"'" + _Enter
   cQTb += "    AND DA1.D_E_L_E_T_ <> '*'" + _Enter
   cQTb += "  ORDER BY DA1.DA1_DATVIG DESC " + _Enter
	
	Memowrite("C:\TEMP\fPsqTbPr.SQL",cQTb)  //Ita - 02/04/2019 
	Memowrite("\Data\fPsqTbPr.SQL",cQTb)  //Ita - 06/06/2019
	
	cQTb := ChangeQuery(cQTb)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQTb),cAlSD1,.T.,.T.)
	TCSetField(cAlSD1,"DA1_PRCVEN","N",TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2])
	TCSetField(cAlSD1,"DA1_XPRCRE","N",TamSX3("DA1_XPRCRE")[1],TamSX3("DA1_XPRCRE")[2])
	
	dbSelectArea(cAlSD1)   
	_cLetra := (cAlSD1)->DA1_XLETRA
	_nDscTb := (cAlSD1)->DA1_XDESCV
	_nVdaPr := (cAlSD1)->DA1_PRCVEN
	_nPrRep := (cAlSD1)->DA1_XPRCRE
	DbCloseArea()
	
Return({_cLetra,_nDscTb,_nVdaPr,_nPrRep})

///////////////////////////////////////////
/// Ita - 27/06/2019
///     - Carrega todos os itens digitados
///     - para efetivar o pedido de compras.
Static Function fCargaPC(_aPCSel)//cArqTrab, _aSZ1, cNumAE)

Local _aArea := GetArea()
Local xMntPC	:= "QRYMPC"
Local _nTotal	:= 0 
If SELECT(xMntPC) > 0 //Ita - 28/05/2019
   dbSelectArea(xMntPC)
   DbCloseArea()
EndIf

dbSelectArea("SZ1")
_cQuery := "SELECT Z1_PRODUTO, Z1_DTENTR, Z1_QUANT, Z1_PRUNIT, Z1_TOTAL, R_E_C_N_O_ RECNOZ1, Z1_CODFORN,Z1_DTINCL" + _Enter //Ita - 18/06/2019 - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
_cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
_cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
_cQuery += "   AND Z1_CODFORN = '" + _cCodMarc + "'" + _Enter
_cQuery += "   AND Z1_QUANT > 0 " + _Enter               //Ita - 07/03/2019
//_cQuery += " AND Z1_PEDIDO = '" + cNumAE+"'"  //Ita - 07/03/2019 
If _nOpcCont == 1 //Se Continuar
   _cQuery += "   AND Z1_DTINCL = '"+DTOS((cAliasTMP)->TMP_DTINCL)+"'" + _Enter //Ita - 04/07/2019 - Se continuar, pegar itens da data do pedido selecionado
Else
   _cQuery += "   AND Z1_DTINCL = '"+DTOS(dDataBase)+"'" + _Enter //Ita - 04/07/2019 - Se novo, pegar itens já selecionados da data base 
EndIf
_cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
MemoWrite("C:\TEMP\fCargaPC.SQL",_cQuery)//Ita - 02/04/2019
MemoWrite("\Data\fCargaPC.SQL",_cQuery)
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xMntPC,.T.,.T.)
TCSetField(xMntPC,"Z1_DTENTR","D",08,00)
TCSetField(xMntPC,"Z1_QUANT","N",10,00)
TCSetField(xMntPC,"Z1_PRUNIT","N",TAMSX3("Z1_PRUNIT")[1],TAMSX3("Z1_PRUNIT")[2])
TCSetField(xMntPC,"Z1_TOTAL","N",TAMSX3("Z1_TOTAL")[1],TAMSX3("Z1_TOTAL")[2])
dbSelectArea(xMntPC)
aDuplItens := {} //Ita - 07/03/2019 - Evitar duplicidades de itens
While !Eof()
    nPosIt := aScan(aDuplItens, (xMntPC)->Z1_PRODUTO + cValToChar((xMntPC)->Z1_DTENTR) + cValToChar((xMntPC)->Z1_QUANT) + cValToChar((xMntPC)->Z1_PRUNIT) + cValToChar((xMntPC)->Z1_TOTAL) )//Ita - 07/03/2019
	If nPosIt == 0
	   aAdd(aDuplItens, (xMntPC)->Z1_PRODUTO + cValToChar((xMntPC)->Z1_DTENTR) + cValToChar((xMntPC)->Z1_QUANT) + cValToChar((xMntPC)->Z1_PRUNIT) + cValToChar((xMntPC)->Z1_TOTAL) )
	   aadd(_aPCSel, { (xMntPC)->Z1_PRODUTO, (xMntPC)->Z1_DTENTR, (xMntPC)->Z1_QUANT, (xMntPC)->Z1_PRUNIT,(xMntPC)->Z1_TOTAL, "1"})
	EndIf
	dbSelectArea(xMntPC)
	dbSkip()
EndDo
(xMntPC)->(dbCloseArea())
dbSelectArea(cArqTrab)
RestArea(_aArea)
Return
//////////////////////////////////
/// Ita - 27/06/2019
///     - Função fPosTRB posiciona
///     - cursor no último produto
///     - selecionado, no momento da
///     - entrada na tela de itens do
///     - filtro para compras.
Static Function fPosTRB(_nRcNoTRB)
    _zArea := GetArea()
	xPosProd := "XPOSPRD"
	_cQuery := "SELECT Z1_PRODUTO,R_E_C_N_O_ RCNOZ1" + _Enter //Ita - 18/06/2019 - Acrescentado Z1_CODFORN,Z1_DTINCL para fazer marcação correta do pedido automático.
	_cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
	_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
	_cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
	_cQuery += "   AND Z1_CODFORN = '" + _cCodMarc + "'" + _Enter
	//Ita - 21/08/2019 - Considerar data mesma que não tenha sido digitado quantidades - _cQuery += "   AND Z1_QUANT > 0 " + _Enter               //Ita - 07/03/2019
	_cQuery += "   AND Z1_QUANT > 0 " + _Enter //Ita - 04/09/2019 só posicionar no produto com quantidade maior que zero. - _cQuery += "   AND Z1_QUANT >= 0 " + _Enter  //Ita - 21/08/2019 - Considerar data mesma que não tenha sido digitado quantidades
	//_cQuery += " AND Z1_PEDIDO = '" + cNumAE+"'"  //Ita - 07/03/2019 
	_cQuery += "   AND Z1_DTINCL = '"+If(!Empty(DTOS((cAliasTMP)->TMP_DTINCL)),DTOS((cAliasTMP)->TMP_DTINCL),DTOS(dDataBase))+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
	_cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
	_cQuery += "  ORDER BY R_E_C_N_O_ DESC " + _Enter
	MemoWrite("C:\TEMP\fPosTRB.SQL",_cQuery)
	MemoWrite("\Data\fPosTRB.SQL",_cQuery)
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xPosProd,.T.,.T.)
	DbSelectArea(xPosProd)
   //	_nRcNoTRB := (xPosProd)->RCNOZ1
	_cPrdPos  := (xPosProd)->Z1_PRODUTO //Ita - 28/06/2019
	DbCloseArea()
	/****** Ita - 21/08/2019 - não posicionar no último produto digitado - Solicitação Gustavo, ao invés, usar função F9(Pesquisa Produto) que já deve apresentar o código deste último produto digitado.
   DbSelectArea(cArqTrab)//Ita - 28/06/2019
   DbSetOrder(1)
   DbSeek(_cPrdPos)
   _nRcNoTRB := (cArqTrab)->(RecNo())
   ************************************************ Ita - 21/08/2019 *************/
   //MsgInfo("Posicionei no Produto: "+(cArqTrab)->TRB_COD)
   DbSelectArea(cArqTrab)
   DbSetOrder(2)
   RestArea(_zArea)
Return
////////////////////////////////////
/// Ita - 28/06/2019
///     - Calculo Saldo do Produto 
Static Function fRetSld(xProdSld,xLocPrd,xEMestre)
     _zArea := GetArea()
    _nSldProd := 0
	If xEMestre == "S"                                                          //Se o produto possuir código mestre, calculará o saldo de todos associados ao dódigo mestre.
		lTemCdMstr := .T.
		aProdMestre := fAgrupMest(xProdSld)
		If aPCRev[01] == "001"		// Se matriz
			For nPrMst := 1 To Len(aProdMestre)
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek("020101"+aProdMestre[nPrMst,1]+xLocPrd)
					//_xSlMst := SaldoSB2()										//	Se for matriz, calcula saldo na matriz e soma com o salda da filial 04
					_xSlMst := SB2->(B2_QATU - B2_RESERVA)
					_nSldProd += _xSlMst 
				Endif
			Next nPrMst
			For nPrMst := 1 To Len(aProdMestre)
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek("020104"+aProdMestre[nPrMst,1]+xLocPrd)
					//_xSlMst := SaldoSB2()										//	Se for matriz, calcula saldo na matriz e soma com o salda da filial 04
					_xSlMst := SB2->(B2_QATU - B2_RESERVA)
					_nSldProd += _xSlMst 
				Endif
			Next nPrMst
		Else
			For nPrMst := 1 To Len(aProdMestre)
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(cfilant+aProdMestre[nPrMst,1]+xLocPrd)
					//_xSlMst := SaldoSB2()										//	Se não for matriz, soma saldo apenas da filial corrente
					_xSlMst := SB2->(B2_QATU - B2_RESERVA)
					_nSldProd += _xSlMst 
				Endif
			Next nPrMst
		EndIf
		
	Else
		dbSelectArea("SB2")
		dbSetOrder(1)
		If aPCRev[01] == "001"		// Ita - 20/06/2019 - Se matriz
			If dbSeek("020101"+xProdSld+xLocPrd)
				//_nSldProd += SaldoSB2()										//	Se for matriz, calcula saldo na matriz e soma com o salda da filial 04
				_nSldProd += SB2->(B2_QATU - B2_RESERVA)
			Endif
			If dbSeek("020104"+xProdSld+xLocPrd)
				//_nSldProd += SaldoSB2()										//	Se for matriz, calcula saldo na matriz e soma com o salda da filial 04
				_nSldProd += SB2->(B2_QATU - B2_RESERVA)
			Endif
		Else
			If dbSeek(cfilant+xProdSld+xLocPrd)
				//_nSldProd := SaldoSB2()										//	Se não for matriz, soma saldo apenas da filial corrente
				_nSldProd += SB2->(B2_QATU - B2_RESERVA)
			Endif
		EndIf
	EndIf 
	RestArea(_zArea)
Return(_nSldProd)

///////////////////////////////////////////////////
/// Ita - 28/06/2019
///     - Função para cálculo do consumo individual 
///     - do produto na apresentação dos similares
Static Function fConsProd(aStru, _aMes,_xProSim)

Local _aArea := GetArea()
Local _nI := 1
Local _lRet := .t.
Local xD2Alias := "TMSD2"
Local _nTotReg := 0
//Ita - 19/06/2019 - Trata meses para processamento para apresentar mês corrente mesmo que não tenha sido selecionado.
_cMsAtu := Substr(DTOS(dDataBase),1,6)
//MsgInfo("Substr(_cMesCor,1,1): "+Substr(_cMesCor,1,1))
_cMsVnd := ""
If Substr(_cMesCor,1,1) <> "S" //Se não considerar o Mês corrente
    //MsgInfo("Não Considera Mês atual")
	If aScan(aMsProc,_cMsAtu) == 0
	   _cMsesPrc  := "('"+_cMsAtu+"',"
	   For nMs := 1 To Len(aMsProc) 
	      _cMsesPrc  += +"'"+aMsProc[nMs]+"'"+If(nMs<Len(aMsProc),",","")
	   Next nMs
	   _cMsesPrc  += ")"
 	   _cMsVnd := _cMsesPrc
	EndIf
Else
   _cMsVnd := _cMesVend
EndIf
//MsgInfo("Passei do tratamento dos meses")
aMSimili := {}	 //Ita - 28/06/2019 - Guarda os meses e suas respectivas quantidades consumidas
Aadd(aMSimili, {"TRB_MES07"	,0, _cMes07})
Aadd(aMSimili, {"TRB_MES06"	,0, _cMes06})
Aadd(aMSimili, {"TRB_MES05"	,0, _cMes05})
Aadd(aMSimili, {"TRB_MES04"	,0, _cMes04})
Aadd(aMSimili, {"TRB_MES03"	,0, _cMes03})
Aadd(aMSimili, {"TRB_MES02"	,0, _cMes02})
Aadd(aMSimili, {"TRB_MES01"	,0, _cMes01})


_cSimiFil := ""
For _nI:=1 to 10	// Total de filiais que podem ser digitadas na tela
	If !Empty(aPCRev[_nI])
			If Empty(_cSimiFil)
				_cSimiFil := "('"
			Else
				_cSimiFil += "','"
			Endif
			_cSimiFil += fGetFil(aPCRev[_nI],2)
	Else
		Exit
	Endif
Next _nI
If !Empty(_cSimiFil)	
   _cSimiFil += "')"
EndIf
If !Empty(_cSimiFil)
		//Consulta itens do Consumo
		_cQuery := "SELECT B1_XALTIMP D2_COD, SB1.B1_XMESTRE MESTRE," + _Enter
		_cQuery +=  "      SUBSTR(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT) D2_QUANT" + _Enter

		_cQuery += " FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4, "+ RetSqlName("SBZ") +" SBZ " + _Enter
		_cQuery += " WHERE D2_FILIAL IN " + _cSimiFil + "" + _Enter
		_cQuery += " AND SUBSTR(D2_EMISSAO,1,6) IN " + _cMsVnd + "" + _Enter
		_cQuery += " AND SD2.D_E_L_E_T_ = ' '" + _Enter
		_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'" + _Enter
		_cQuery += " AND B1_COD = '" + PadR(_xProSim,15) + "'" + _Enter
		//_cQuery += " AND B1_XMARCA = '" + aPCRev[13] + "'" + _Enter
		_cQuery += " AND B1_MSBLQL <> '1'" + _Enter
		_cQuery += " AND SB1.D_E_L_E_T_ = ' '" + _Enter
		_cQuery += " AND B1_COD = D2_COD" + _Enter
		_cQuery += " AND B1_COD = BZ_COD  " + _Enter
		_cQuery += " AND BZ_FILIAL = '" + xFilial("SBZ") + "'" + _Enter
		_cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "'" + _Enter
		_cQuery += " AND D2_TES = F4_CODIGO" + _Enter
		_cQuery += " AND F4_TRANFIL <> '1'" + _Enter
		_cQuery += " AND F4_ESTOQUE = 'S'" + _Enter
		_cQuery += " AND D2_XOPER IN " + FormatIn(Alltrim(GetMV("MV_XCONSAI")),",") + _Enter //Ita - 09/04/2019 - Considerar Tipo de Operação para o cálculo do consumo
		_cQuery += " AND SF4.D_E_L_E_T_ = ' '" + _Enter
		_cQuery += " GROUP BY B1_XALTIMP, B1_XMESTRE, SUBSTR(D2_EMISSAO,1,6)" + _Enter
		_cQuery += " ORDER BY B1_XALTIMP, B1_XMESTRE, SUBSTR(D2_EMISSAO,1,6)" + _Enter

		MemoWrite("\DATA\fConsProd.SQL",_cQuery)
		_cQuery := ChangeQuery(_cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xD2Alias,.T.,.T.)
	dbSelectArea(xD2Alias)

		    _cCod    := (xD2Alias)->D2_COD
		    _cLocal  := Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_LOCPAD")
			dbSelectArea(xD2Alias)
			While !Eof() .and. _cCod == (xD2Alias)->D2_COD
			   //IncProc("Calculando Consumos ... "+Alltrim(Str(nCnt))+" / "+Alltrim(Str(nPrcRg)))
				_cAnoMes := (xD2Alias)->ANOMES
				_nQuant  := (xD2Alias)->D2_QUANT
				_cMes    := Substr(_cAnoMes,5,2)
				_nAcho   := aScan(_aMes,{|x| AllTrim(x[1])==_cMes})
				If _nAcho > 0
					_cTitulo := _aMes[_nAcho,2]
					_nAcho   := aScan(aStru,{|x| AllTrim(x[5])==_cTitulo})
					If _nAcho > 0
						_cCampo := aStru[_nAcho,1]
						_xPsM := aScan(aMSimili, {|x| Alltrim(x[1]) == Alltrim(_cCampo)})
						If _xPsM > 0
						   //aAdd(aMSimili, {&(_cCampo),_nQuant} )
						   //aAdd(aMSimili, {_cCampo,_nQuant} )
						   aMSimili[_xPsM,2] := _nQuant
						   //aMSimili[_xPsM,3] := Alltrim(_cTitulo)
						EndIf
					Endif
				Endif
				dbSelectArea(xD2Alias)
				dbSkip()
				//nCnt ++
			EndDo
	        dbSelectArea(xD2Alias)
	        dbCloseArea()	
			_n01Ms := 0
			_n02Ms := 0
			_n03Ms := 0
			_n04Ms := 0
			_n05Ms := 0
			_n06Ms := 0
			_n07Ms := 0
			aMSimili := aSort(aMSimili,,, { | x,y | x[1] > y[1] }) //Ordenar por Mês
			If Substr(_cMesCor,1,1) == "S"
				For nMs:= 1 To 7
				/*
				   _xCpo := "TRB_MES0"+Alltrim(Str(nMs))
				   _xPsM := aScan(aMSimili, {|x| x[1] == _xCpo})
				   If _xPsM > 0

				   EndIf
				   */
				   If nMs == 7
				      _n01Ms := aMSimili[nMs,2]
				   ElseIf nMs == 6
				      _n02Ms := aMSimili[nMs,2]
				   ElseIf nMs == 5
				      _n03Ms := aMSimili[nMs,2]
				   ElseIf nMs == 4
				      _n04Ms := aMSimili[nMs,2]
				   ElseIf nMs == 3
				      _n05Ms := aMSimili[nMs,2]
				   ElseIf nMs == 2
				      _n06Ms := aMSimili[nMs,2]
				   ElseIf nMs == 1
				      _n07Ms := aMSimili[nMs,2]
				   EndIf
				Next nMs
				_nSMd3 := Round(((_n01Ms + _n02Ms + _n03Ms)/ 3),0)
				_nSMd6 := Round(((_n01Ms + _n02Ms + _n03Ms + _n04Ms + _n05Ms + _n06Ms) / 6),0)
				cpare:=""
			Else
				aMSimili := aSort(aMSimili,,, { | x,y | x[1] > y[1] }) //Ordenar por Mês 
				For nMs:= 1 To 7
				   //_cCampo := "TRB_MES0"+Alltrim(Str(nMs))
				   //_xPsM := aScan(aMSimili, {|x| x[1] == _cCampo})
				   If nMs == 7
				      _n01Ms := aMSimili[nMs,2]
				   ElseIf nMs == 6
				      _n02Ms := aMSimili[nMs,2]
				   ElseIf nMs == 5
				      _n03Ms := aMSimili[nMs,2]
				   ElseIf nMs == 4
				      _n04Ms := aMSimili[nMs,2]
				   ElseIf nMs == 3
				      _n05Ms := aMSimili[nMs,2]
				   ElseIf nMs == 2
				      _n06Ms := aMSimili[nMs,2]
				   ElseIf nMs == 1
				      _n07Ms := aMSimili[nMs,2]
				   EndIf
				Next nMs
				_nSMd3 := Round(((_n02Ms + _n03Ms + _n04Ms)/ 3),0)
				_nSMd6 := Round(((_n02Ms + _n03Ms + _n04Ms + _n05Ms + _n06Ms + _n07Ms) / 6),0)
				cpare:=""
			Endif
Endif

Return({aMSimili,_nSMd3,_nSMd6}) 

////////////////////////////////////////////
/// Ita - 03/07/2019
///     - Criado função para realizar o
///     - Pedido de Transferência.
Static Function fRunTrf(aItPVend)
    aCab   :={}
    aItens := {}
	cEmpDest := "01"      //Ita - 04/07/2019
	cFilDes  := _cEmpr01  //Ita - 04/07/2019
	_cB1TMP := fGetFil(_cEmpr01,2)
	_cB1Fil := Substr(_cB1TMP,1,4)+SPACE(2)
	///////////////////////////////////////////////////////////////////////////
	/// Ita - Faz Call da função ANFAT02B(aCab, aItens, cEmpDest, cFilDes)
	///       Para gravar Pedido de Venda na Filial Destino da Transferência
	aCliTrf := fPsqCliT() //Ita - 11/04/2019 - Pega o Cliente para realizar transfeência 
 	//Cabeçalho do pedido de venda
  	//Ita - 30/05/2019 - aAdd(aCab, {"C5_FILIAL" , xFilial("SC5")   	, Nil})     // Filial do pedido
   	aAdd(aCab, {"C5_FILIAL" , cfilant   	    , Nil})     // Filial do pedido
   	aAdd(aCab, {"C5_TIPO"   , 'N'   			, Nil})     // Tipo do pedido
   	aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD    	, Nil})     // Cliente
   	//Ita - 03/07/2019 - aAdd(aCab, {"C5_LOJA"   , SA1->A1_LOJA   	, Nil})     // Loja
   	aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA   	, Nil})     // Loja
   	aAdd(aCab, {"C5_EMISSAO", dDataBase			, Nil})     // Data de Emissão
   	aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD    	, Nil})     // Código do cliente entrega
   	aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA   	, Nil})     // Loja do cliente entrega
   	aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND     	, Nil})     // Condição de Pagamento - a Vista
   	aAdd(aCab, {"C5_TIPLIB" , "1"            	, Nil})     // Permitir liberar o pedido parcialmente
   	aAdd(aCab, {"C5_NATUREZ", SA1->A1_NATUREZ	, Nil})     // Natureza do cliente

	cItem := "00" 
	//nPrR := Len(aItPVend) 
	//ProcRegua(nPrR)
	For nIt := 1 To Len(aItPVend)
		//IncProc("Gerando Itens de Transferencia ... "+Alltrim(Str(nIt))+" / "+Alltrim(Str(nPrR)))  
		aItem := {}
		cItem := Soma1(cItem)
		//Posiciona no produto
		DbSelectArea("SB1")
		DbSetOrder(1)//B1_FILIAL+B1_COD
		//If SB1->(DbSeek(xFilial("SB1")+PadR(aItPVend[nIt,1],15)))
		If DbSeek(xFilial("SB1")+aItPVend[nIt,1])

			//Posiciona nA SB2
			//DbSelectArea("SB2")
			//SB2->(DbSetOrder(1))//B2_FILIAL+B2_COD+B2_LOCAL
			//Ita - 30/05/2019 - If SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
			//If SB2->(DbSeek(cFilAnt+SB1->B1_COD+SB1->B1_LOCPAD))
			//	nPreco := SB2->B2_CM1
			//Else
			//	nPreco := 0
			//EndIf
	            
	            /* Ita - 01/04/2019
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Sintaxe   ³ MaTesInt(ExpN1,ExcC1,ExpC2,ExpC3,ExpC4,ExpC5)                ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Descri‡…o ³ ExpN1 = Documento de 1-Entrada / 2-Saida                     ³±±
			±±³          ³ ExpC1 = Tipo de Operacao Tabela "DF" do SX5                  ³±±
			±±³          ³ ExpC2 = Codigo do Cliente ou Fornecedor                      ³±±
			±±³          ³ ExpC3 = Codigo do gracao E-Entrada                           ³±±
			±±³          ³ ExpC4 = Tipo de Operacao E-Entrada                           ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	            */
	            //aAdd(aItPVend,{(cAliasSZ1)->Z1_PRODUTO,(cAliasSZ1)->Z1_QUANT,_nPrcuni,_nPrcTot})//Ita - 11/04/2019  
			//Ita - 01/04/2019 - cTES := MaTesInt(2,"01",SA1->A1_COD,SA1->A1_LOJA,"C",ZZV->ZZV_PRODUT,)
			cTES := MaTesInt(2,"05",SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD,)
	        nQtdTrf := aItPVend[nIt,2] 
	        nPreco  := aItPVend[nIt,3]

            If Substr(_cTped,1,1) == "C" //Se for Compras - Ita - 10/07/2019 
	            //////////////////////////
	            /// Ita - 04/07/2019
	            ///     - Tratamento do fator de embalagem
	            ///     - Testa se item tem fator de embalagem, testa a seguir
	            ///     - se a quantidade a ser transferida é multipla do fator de
	            ///     - embalagem, por último, se não for múltipla, altera
	            ///     - quantidade para o primeiro múltiplo superior a 
	            ///     - quntidade a ser transferida.
			   nFtEmbal := SB1->B1_XFATEMB
			   If nFtEmbal > 0	
				  /* 
				  César: 03/05/2021 - Calculando diretamente a sugestão considerando o fator de embalagem.
				  */
				  nQtdTrf := (int(Round(nQtdTrf/nFtEmbal,0)) * nFtEmbal)
				  /*
				  _lEMultFE := If(Mod(nQtdTrf,nFtEmbal)==0,.T.,.F.)
			      If !_lEMultFE
			         lRoda := .T.
			          _nQtdMult := nQtdTrf
	                     While lRoda
	                        _nQtdMult ++ 
	                        If Mod( _nQtdMult,nFtEmbal)==0
	                           nQtdTrf := _nQtdMult 
	                           lRoda := .F.
	                        EndIf
	                     EndDo 
			      EndIf
				  */
			   EndIf
            EndIf
	            //_nTtITrf := A410Arred(nPreco * nQtdTrf,"C6_VALOR") 
			//Ita - 30/05/2019 - aAdd(aItem,{"C6_FILIAL" , xFilial("SC6")   					, Nil})	   //Filial
			aAdd(aItem,{"C6_FILIAL" , cfilant   					   	, Nil})    // Item do pedido
			aAdd(aItem,{"C6_ITEM"   , cItem			   					, Nil})    // Item do pedido
			aAdd(aItem,{"C6_PRODUTO", SB1->B1_COD					    , Nil})    // Produto
			aAdd(aItem,{"C6_DESCRI" , SB1->B1_DESC	 					, Nil})    // Descricao
			aAdd(aItem,{"C6_UM"     , SB1->B1_UM     					, Nil})    // Unidade de medida do produto
			aAdd(aItem,{"C6_QTDVEN" , nQtdTrf 					        , Nil})    // Quantidade Vendida
			aAdd(aItem,{"C6_QTDLIB" , nQtdTrf 					        , Nil})    // Quantidade Liberada
			aAdd(aItem,{"C6_PRCVEN" , Round(nPreco,4)			        , Nil})    // Preço unitario
			aAdd(aItem,{"C6_VALOR"  , A410Arred(nPreco * nQtdTrf,"C6_VALOR") , Nil})    // Valor total
			aAdd(aItem,{"C6_VALDESC", 0                                 , Nil})    // Valor do desconto
			aAdd(aItem,{"C6_XOPER" 	, "05"			 					, Nil})    //Operação do TES Inteligente.
			aAdd(aItem,{"C6_TES" 	, cTES			 					, Nil})    // TES
			aAdd(aItem,{"C6_LOCAL"  , SB1->B1_LOCPAD  					, Nil})    // Local padrão do produto (Armazem)
			aAdd(aItem,{"C6_ENTREG" , dDataBase		 					, Nil})    // Data da Entrega
	
			aAdd(aItens,aItem)
        Else
           Alert("O Produto "+PadR(aItPVend[nIt,1],15)+" não foi localizado para compor o pedido de saída da transferência")
        EndIf        
  	Next nIt
	//Ita - 04/07/2019 - cEmpDest := "01"
	//Ita - 04/07/2019 - cFilDes  := _cEmpr01 
	//MsgInfo("Vou chamar a função de Transferência - ANFAT02B") //Ita - 03/07/2019
	/*
	aTrfOk := u_ANFAT02B(aCab, aItens, cEmpDest, cFilDes)
	If aTrfOk[1]
	   MsgInfo("O Pedido de Transferência "+aTrfOk[3]+" foi finalizado com Sucesso!","Pedido Incluído")
	Else
	   Alert("O Pedido de Transferência não foi finalizado corretamente! Solicitar TI para verificar logs desta ocorrência")
	EndIf
	*/

	//Conecta na filial de destino
	//Ita - 03/07/2019 - RpcSetEnv(cEmpDest, cFilDes)
	//Ita - 04/07/2019 - RpcSetEnv(cEmpDest, cFilDes,"totvs","totvsne","FAT",) //Ita - 03/07/2019 

	//Ita - 03/07/2019 - cFunName := Alltrim(FunName())

	SetFunName("MATA410")

	Conout("hhhhhhhhhhh")

	//Insere o pedido de venda
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,3)

	Conout("yyyyyyyyyyyyy")

	//Ita - 03/07/2019 - SetFunName(cFunName)
    _cNumPT := ""
    cRet    := ""
	If lMsErroAuto
	    //Alert("O Pedido de Transferência não foi finalizado corretamente! Solicitar TI para verificar logs desta ocorrência")
		cRet := MostraErro("\data\","MATA410.txt")//Ita - 03/07/2019
	Else
		//MsgInfo("O Pedido de Transferência "+SC5->C5_NUM+" foi finalizado com Sucesso!","Pedido Incluído")
		_cNumPT := SC5->C5_NUM
	EndIf


	//Desconecta da filial
	//Ita - 03/07/2019 - RpcClearEnv()

	
	/////////// Ita - Fim do Processo de Transferência entre filiais - 11/04/2019
	

Return({lMsErroAuto,_cNumPT,cRet})

//////////////////////////////////////
/// Ita - 04/07/2019
///     - Validação do Tipo de Pedido
Static Function fVldTP(_pTpPC)
   If Substr(_pTpPC,1,1) == "C"
      _cOrigTrf := SPACE(1)
      _lEdtPA     := .T.  //Ita - 10/07/2019
   Else
      _cOrigTrf:= CriaVar("C7_FILIAL",.F.)
      	_cGeraAut := "N - Não" //Ita - 10/07/2019 
      _lEdtPA     := .F.       // "        "
   EndIf
   oOrigTrf:Refresh()
   oGeraAut:Refresh()
Return                    

///////////////////////////////////////////
/// Ita - 10/07/2019
///     - Função fDecsBlq
///     - Para facilitar decisão de bloqueio

Static Function fDecsBlq() 
   _nRetDecs := 0
   _MsgTela  := If(_ldesbloq,"Bloqueio Atual: "+_MsgDes,"")
   _MsgTit   := If(_ldesbloq,"DESBLOQUEAR PRODUTO","BLOQUEAR PRODUTO")
   //DEFINE DIALOG oDlgDecs TITLE _MsgTit FROM 180,180 TO 550,700 PIXEL     
   DEFINE DIALOG oDlgDecs TITLE _MsgTit FROM 180,180 TO 400,500 PIXEL     
   
      //MsgYesNo("Tecle SIM para "+_cMsgBlq+" apenas a filial "+cFilAnt+" ou tecle NÃO para "+_cMsgBlq+" todas as filiais "+If(_ldesbloq,"Bloqueio Atual: "+_MsgDes,""))
      // Usando o New   
      @ 005,0015 SAY _MsgTela SIZE 150,15 PIXEL OF oDlgDecs FONT oFont
      //Ita - 17/07/2019 - Foi modificado a ordem dos botões para facilitar decisão do usuário no momento da operação de bloqueio.
      oTButton2 := TButton():New( 022, 015, "SIM para "+_cMsgBlq+" todas as filiais ",oDlgDecs,{||_nRetDecs := 2,oDlgDecs:End()}, 140,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
      oTButton1 := TButton():New( 047, 015, "NÃO para "+_cMsgBlq+" apenas a filial "+cFilAnt ,oDlgDecs,{||_nRetDecs := 1,oDlgDecs:End()}, 140,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
      oTButton3 := TButton():New( 072, 015, "Cancelar",oDlgDecs,{||oDlgDecs:End()}, 140,20,,,.F.,.T.,.F.,,.F.,,,.F. )
      // Usando o Create   
      //oTButton4 := TButton():Create( oDlgDecs,062,002,"Botão 04",{||alert("Botão 04")},; 40,10,,,,.T.,,,,,,)
   ACTIVATE DIALOG oDlgDecs CENTERED
Return(_nRetDecs)

/////////////////////////
/// Ita - 10/07/2019
///     - Função fContPA
///     - Valida Se o Pedido está sendo continuado
Static Function fContPA
   lRtPA := .T.
   If !(_nOpcCont == 2) //Se não for um pedido novo
      _cGeraAut := "N - Não" //Ita - 10/07/2019 
      oGeraAut:Refresh()
      Return(.F.)
   EndIf
Return(lRtPA)   	
/////////////////////////////////
/// Ita - 18/07/2019
///     - Função fRetUPrc
///     - Retorna Último Preço de Compra do
///       do produto posicionado.
Static Function fRetUPrc(_cVarCod)//Ita - 07/08/2019 - _cCdPrd)
   cAB1 := "TXB1"
   cQry := " SELECT B1_UPRC "
   cQry += "   FROM "+RetSQLName("SB1")
   cQry += "  WHERE B1_COD = '"+_cVarCod+"'"//Ita - 07/08/2019 - _cCdPrd+"'"
   cQry += "    AND D_E_L_E_T_ <> '*'"
   //TCQuery cQry NEW ALIAS "TXB1"
   cQry := ChangeQuery(cQry)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAB1,.T.,.T.)
   DbSelectArea(cAB1)
     _nRetPrc := (cAB1)->B1_UPRC
   DbCloseArea()
Return(_nRetPrc)

//////////////////////////////////
/// Ita - 03/09/2019
///       Check de data para validar
///       se deve abrir pedido com
///       quantidade zerada.
User Function fChkDtPR(dDtPR,pDtInc)
    _zArea := GetArea()
	xTbDtPR := "XDTPR"
	_cQuery := "SELECT COUNT(*) NQTDDT" + _Enter
	_cQuery += "  FROM " + RetSqlName("SZ1") + _Enter
	_cQuery += " WHERE Z1_FILIAL = '" + cFilAnt + "'" + _Enter
	_cQuery += "   AND Z1_STATUS IN ('1','2')" + _Enter
	_cQuery += "   AND Z1_CODFORN = '" + _cCodMarc + "'" + _Enter
	_cQuery += "   AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
	_cQuery += "   AND Z1_DTENTR = '"+DTOS(dDtPR)+"'" + _Enter //Ita - 15/05/2019 - Incluído campo (cAliasTMP)->TMP_DTINCL para pegar dados do pedido correto.
	_cQuery += "   AND D_E_L_E_T_ = ' '" + _Enter
	MemoWrite("C:\TEMP\fChkDtPR.SQL",_cQuery)
	MemoWrite("\Data\fChkDtPR.SQL",_cQuery)
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xTbDtPR,.T.,.T.)
	DbSelectArea(xTbDtPR)
	lRtDtZero  := If((xTbDtPR)->NQTDDT>0,.T.,.F.)
	DbCloseArea()
   RestArea(_zArea)
Return(lRtDtZero)

/////////////////////////////////////////////
/// Ita - 24/05/2019
///     - Função fChkQtdZ1
///     - Checa se registro do SZ1 tem quantidade
///     - maior que zero para marcar ou não registro
///     - do produto.
Static Function fChkQtdZ1(pFor,pDtInc,pProd,nCall)
   cAliTemZ1 := "YTZ1"
   
   cQryUPD := " SELECT COUNT(*) NQTDZ1 " + _Enter
   cQryUPD += "   FROM "+RetSQLName("SZ1") + _Enter
   cQryUPD += "  WHERE Z1_FILIAL = '"+cFilAnt+"'" + _Enter
   cQryUPD += "    AND Z1_CODFORN = '"+Padr(pFor,6)+"'" + _Enter
   cQryUPD += "    AND Z1_DTINCL = '"+DTOS(pDtInc)+"'" + _Enter
   If nCall == 2
      cQryUPD += "    AND Z1_PRODUTO = '"+pProd+"'" + _Enter
   EndIf
   cQryUPD += "    AND Z1_QUANT > 0 " + _Enter //Ita - 29/05/2019
   
   cQryUPD += "    AND Z1_STATUS IN ('1','2')" + _Enter
   cQryUPD += "    AND D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fChkQtdZ1.SQL",cQryUPD)
   MemoWrite("\Data\fChkQtdZ1.SQL",cQryUPD)
   cQryUPD := ChangeQuery(cQryUPD)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryUPD),cAliTemZ1,.T.,.T.)
   dbSelectArea(cAliTemZ1)
   lTemZ1 := If((cAliTemZ1)->NQTDZ1 > 0,.T.,.F.)
   DbCloseArea()

Return(lTemZ1)
Static Function fExecGrv(nCall) 
      MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,3)
Return
