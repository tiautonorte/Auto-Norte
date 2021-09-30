#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#include "FILEIO.CH"
#include "TopConn.ch" 

#DEFINE ITEMSZ4 "Z4_CODTAB/Z4_GRUPO/Z4_SUBGRP/Z4_DESC01/Z4_DESC02/Z4_DESC03/Z4_DESC04/Z4_DESC05/Z4_DESC06/Z4_DESC07/Z4_DESC08/Z4_DESC09/Z4_DESC10/Z4_TPDESC/Z4_TOTDESC/Z4_NACIMP/"
#DEFINE ITEMSZ5 "Z5_CODTAB/Z5_CODREF/Z5_DESC01/Z5_DESC02/Z5_DESC03/Z5_DESC04/Z5_DESC05/Z5_DESC06/Z5_DESC07/Z5_DESC08/Z5_DESC09/Z5_DESC10/Z5_TPDESC/Z5_TOTDESC/"
#DEFINE ITEMSZ6 "Z6_CODTAB/Z6_DESC01/Z6_DESC02/Z6_DESC03/Z6_DESC04/Z6_DESC05/Z6_DESC06/Z6_DESC07/Z6_DESC08/Z6_DESC09/Z6_DESC10/Z6_TOTDESC/Z6_NACIMP/Z6_DESCRI/"

#DEFINE ENTER Chr(10)+Chr(13)

Static _lConfirmar    := .T.
Static __lBTNConfirma := .F.
STATIC _aColsForn := {}
Static lMarkAll := .T. //Indicador de marca/desmarca todos

/*{Protheus.doc}AN_LISTPRC
@author Ricardo Rotta
@since 27/08/2018
@version P12
Lista de Preço
*/
//-------------------------------------------------------------------

User Function AN_LISTPRC(xRotAuto,nOpcAuto)

	Local oBrowse := NIL
	Private aLstSobP := {}
	Private xFilPos  := cFilAnt //Ita - 13/08/2020
	Private xEmpAnt  := cEmpAnt //Ita - 13/08/2020
	If xRotAuto == Nil
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("SZ2")
		dbSetOrder(6)
		oBrowse:SetDescription(OemToAnsi("Politica Comercial"))
		oBrowse:AddLegend( "Z2_STATUS == '1'" , "GREEN" , "Tabela Não Vigente"	)
		oBrowse:AddLegend( "Z2_STATUS == '2'" , "RED"	, "Tabela Vigente"	)
		oBrowse:AddLegend( "Z2_STATUS == '3'" , "YELLOW", "Politica Comercial Não Aplicada"	)
		oBrowse:AddLegend( "Z2_STATUS == '4'" , "PINK", "Importação em andamento"	)
		oBrowse:Activate()
	Else
		aRotina := MenuDef()
		FWMVCRotAuto(ModelDef(),"SZ2",nOpcAuto,{{"Z2MASTER",xRotAuto},{"Z3DETAIL",aSZ3}})
	Endif
Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina Title 'Alterar Planilha'			Action "StaticCall(AN_LISTPRC,AN_VIEWTAB)" 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Importar' 				Action "StaticCall(AN_LISTPRC,AN_IMPPRC)"  	OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' 					Action 'VIEWDEF.AN_LISTPRC' 				OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' 					Action "StaticCall(AN_LISTPRC,AN_EXCPRV)"	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Sobrepor'					ACTION "StaticCall(AN_LISTPRC,SOBREPOR)"	OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Copiar Politica Desconto'	Action "StaticCall(AN_LISTPRC,AN_COPPOL)"  	OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Aplicar Política'			Action "U_AN_CALCPRV(1)" 					OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Efetivar Tabela'			Action "U_AN_CALCPRV(2)" 					OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Simulação Tabela Preço'	ACTION 'StaticCall(AN_LISTPRC,SIMUPRV)'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Relatorio Variação Preço'	ACTION 'u_RSIMTAB("1")'						OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Consulta Preços Vigentes'	ACTION "StaticCall(AN_LISTPRC,AN_VIEWPRC)"	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Reprocessa Importação'	ACTION "U_AN_CALCPRV(3)"					OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Banco Conhecimento'		ACTION "StaticCall(AN_LISTPRC,LISTPRCDOC)"	OPERATION 2 ACCESS 0

Return aRotina
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oStPai   := FWFormStruct( 1, 'SZ2')
	Local oStSZ4   := FWFormStruct( 1, 'SZ4', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ4 } ,/*lViewUsado*/ )
	Local oStSZ5   := FWFormStruct( 1, 'SZ5', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ5 } ,/*lViewUsado*/ )
	Local oStSZ6   := FWFormStruct( 1, 'SZ6', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ6 } ,/*lViewUsado*/ )
	Local oModel

	oModel := MPFormModel():New('AN_LISTM' , , { |oModel| PRCFORPOS( oModel )}, { |oModel| AN_LTMGRV( oModel ) } )

	nOperation := oModel:GetOperation()

	oModel:AddFields('Z2MASTER',/*cOwner*/,oStPai)

	oModel:AddGrid('Z4DETAIL','Z2MASTER',oStSZ4,/*bLinePre*/ , { |oMdlG| PRCFRNSZ4( oMdlG ) },/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation( "Z4DETAIL", { { "Z4_FILIAL", "xFilial('SZ4')" }, { "Z4_CODTAB", "Z2_CODTAB" } }, SZ4->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey({})
	oModel:GetModel( 'Z4DETAIL' ):SetOptional( .T. )
	oModel:GetModel('Z4DETAIL'):SetUniqueLine( {"Z4_GRUPO","Z4_SUBGRP","Z4_NACIMP"} )

	oModel:AddGrid('Z5DETAIL','Z2MASTER',oStSZ5,/*bLinePre*/ , { |oMdlG| PRCFRNSZ5( oMdlG ) },/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation( "Z5DETAIL", { { "Z5_FILIAL", "xFilial('SZ5')" }, { "Z5_CODTAB", "Z2_CODTAB" } }, SZ5->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey({})
	oModel:GetModel( 'Z5DETAIL' ):SetOptional( .T. )
	oModel:GetModel('Z5DETAIL'):SetUniqueLine( {"Z5_CODREF"} )

	oModel:AddGrid('Z6DETAIL','Z2MASTER',oStSZ6,/*bLinePre*/ , { |oMdlG| PRCFRNSZ6( oMdlG ) },/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation( "Z6DETAIL", { { "Z6_FILIAL", "xFilial('SZ6')" }, { "Z6_CODTAB", "Z2_CODTAB" } }, SZ6->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey({})
	oModel:GetModel( 'Z6DETAIL' ):SetOptional( .T. )
	oModel:GetModel("Z6DETAIL"):SetMaxLine( 2 )
	oModel:GetModel('Z6DETAIL'):SetUniqueLine( {"Z6_NACIMP"} )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( "Lista de Preços" )
	oStPai:SetProperty( 'Z2_CODTAB'	, MODEL_FIELD_WHEN	, { || .F. } )
	oStPai:SetProperty( 'Z2_MARCA' 	, MODEL_FIELD_WHEN	, { || .F. } )
	oStPai:SetProperty( 'Z2_CODFORN', MODEL_FIELD_WHEN	, { || .F. } )
	oStPai:SetProperty( 'Z2_LOJA' 	, MODEL_FIELD_WHEN	, { || .F. } )

//	oStSZ4:SetProperty( 'Z4_NACIMP' , MODEL_FIELD_TAMANHO, 4)
//	oStSZ6:SetProperty( 'Z6_DESCRI' , MODEL_FIELD_TAMANHO, 25)
	
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()

	Local oView     := Nil
	Local oModel    := FWLoadModel('AN_LISTPRC')
	Local oStPai 	:= FWFormStruct( 2, 'SZ2')
	Local oStSZ4    := FWFormStruct( 2, 'SZ4', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ4 } ,/*lViewUsado*/ )
	Local oStSZ5    := FWFormStruct( 2, 'SZ5', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ5 } ,/*lViewUsado*/ )
	Local oStSZ6    := FWFormStruct( 2, 'SZ6', { |cCampo|  AllTrim( cCampo ) + '/' $ ITEMSZ6 } ,/*lViewUsado*/ )
	Local nOperation := oModel:GetOperation()
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oStSZ4:RemoveField('Z4_CODTAB')
	oStSZ5:RemoveField('Z5_CODTAB')
	oStSZ6:RemoveField('Z6_CODTAB')

	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_SZ2',oStPai,'Z2MASTER')
	oView:AddGrid('VIEW_SZ4',oStSZ4,'Z4DETAIL')
	oView:AddGrid('VIEW_SZ5',oStSZ5,'Z5DETAIL')
	oView:AddGrid('VIEW_SZ6',oStSZ6,'Z6DETAIL')

	/*
	oView:CreateFolder( 'PASTAS')
	// Cria pastas nas folders
	oView:AddSheet( 'PASTAS', 'ABA1', 'Lista de Preços' )
	oView:AddSheet( 'PASTAS', 'ABA2', 'Politica Comercial', {|| AtuDscG()} )
	*/

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox( 'CABEC', 20)
	oView:CreateHorizontalBox( 'GRID3', 25)
	oView:CreateHorizontalBox( 'GRID1', 30)
	oView:CreateHorizontalBox( 'GRID2', 25)

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SZ2','CABEC')
	oView:SetOwnerView('VIEW_SZ6','GRID3')
	oView:SetOwnerView('VIEW_SZ4','GRID1')
	oView:SetOwnerView('VIEW_SZ5','GRID2')

	//Habilitando título
	oView:EnableTitleView('VIEW_SZ2','Tabela de Preço')
	oView:EnableTitleView('VIEW_SZ4','Desconto por Grupo/SubGrupo')
	oView:EnableTitleView('VIEW_SZ5','Desconto por Produto')
	oView:EnableTitleView('VIEW_SZ6','Desconto Geral')

Return oView
//-------------------------------------------------------------------
Static Function AN_LTMGRV( oModel )

	Local _aArea	 := GetArea()
	Local nOperation := oModel:GetOperation()
	Local cFilTab    := SZ2->Z2_FILIAL
	Local _cCodTab	 := SZ2->Z2_CODTAB
	Local aTab       := {}
	Private lEnd 	 := .F.
	FWFormCommit( oModel )

	If nOperation == 5  // Exclusão
		_cUpd := "DELETE " + RetSqlName("SZ3")
		_cUpd += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cUpd += " AND Z3_CODTAB = '" + _cCodTab + "'"
		nErrQry := TCSqlExec( _cUpd )
	Endif

	If nOperation == 4 //Alteração
		If SZ2->Z2_STATUS <> "4"
			AADD(aTab,{cFilTab,_cCodTab})
			If ApMsgYesNo("Deseja aplicar a política?")
				Processa( {|lEnd| APLICPOL(aTab, @lEnd)}, "Aguarde...","Aplicando Politica Comercial", .T. )
			EndIf
		Endif
	Endif

	RestArea(_aArea)
Return .T.

//-------------------------------------------------------------------

Static Function AN_IMPPRC

	Local nLargura := 400
	Local nAltura  := 350
	Local _cFilSel := "Todas Filiais"
	Local cFilPrd  := "Sim"
	Local cFilArq  := "Nao"
	Local _aSelFil := {}
	Local aSelPrd  := {}
	Local aSelArq  := {}
	Local _cTabOri := CriaVar("Z2_CODTAB",.F.)
	Local _cDscOri := CriaVar("Z2_DESCTAB",.F.)
	aadd(_aSelFil, "Filial Corrente")
	aadd(_aSelFil, "Seleciona Filiais")

	aadd(aSelPrd, "Sim")
	aadd(aSelPrd, "Não")

	aadd(aSelArq, "Nao")
	aadd(aSelArq, "Sim")

	Private _cNReduz := CriaVar("A2_NREDUZ",.F.)
	Private _cCodMarc := CriaVar("ZZ7_MARCA",.F.)
	Private _cDescTab := CriaVar("Z2_DESCTAB",.F.)
	Private cFile  := Space(99999)
	Private oDlgWOF
	DEFINE DIALOG oDlgWOF TITLE "Seleção Importação" FROM 0, 0 TO 22, 90 SIZE nLargura, nAltura PIXEL //

	//Painel Origem
	oPanelOrigem   := TPanel():New( 005, 005, ,oDlgWOF, , , , , , nLargura-10, nAltura-19, .F.,.T. )
	@ 00,000 SAY oSay  VAR "Informe os Dados da Tabela para importacao" OF oPanelOrigem FONT (TFont():New('Arial',0,-13,.T.,.T.)) PIXEL //"Origem"

	@ 18,005 SAY oDescTab VAR "Descrição Tabela:" OF oPanelOrigem PIXEL
	@ 16,055 MSGET _cDescTab SIZE 120,010 OF oPanelOrigem WHEN .T. PIXEL

	@ 37,005 SAY oCodM VAR "Marca" OF oPanelOrigem PIXEL
	@ 35,030 MSGET oCODMAR  VAR _cCodMarc SIZE 030, 010 OF oPanelOrigem PIXEL VALID(BuscForn())
	oCODMAR:cF3 := "ZZ7"
	@ 35,065 MSGET oNReduz  VAR _cNReduz SIZE 080, 010 OF oPanelOrigem PIXEL WHEN .F.

	@ 57,005 SAY oCopPo VAR "Copiar Politica Comercial da Tabela:" OF oPanelOrigem PIXEL
	@ 55,100 MSGET oTabOri  VAR _cTabOri SIZE 030, 010 OF oPanelOrigem PIXEL Valid(VldCopTab(_cTabOri, @_cDscOri, "zz"))
	@ 67,005 MSGET oDscOri  VAR _cDscOri SIZE 080, 010 OF oPanelOrigem PIXEL WHEN .F.

	@ 87,005 SAY oAcao VAR "Arquivo" OF oPanelOrigem PIXEL //"Arquivo:"
	@ 97,005 MSGET cFile SIZE 140,010 OF oPanelOrigem WHEN .T. PIXEL
	@ 97,150 BUTTON oBtnAvanca PROMPT "Abrir" SIZE 15,12 ACTION (SelectFile()) OF oPanelOrigem PIXEL //"Abrir"

	@ 118,005 SAY oEmp VAR "Carrega Filiais " OF oPanelOrigem PIXEL //"Arquivo:"
	@ 115,050 COMBOBOX oSelFil VAR _cFilSel ITEMS _aSelFil SIZE 75,15 OF oPanelOrigem PIXEL

//	@ 118,130 SAY oArq VAR "Arquivos Diferentes " OF oPanelOrigem PIXEL //"Arquivo:"
//	@ 115,150 COMBOBOX oSelArq VAR cFilArq ITEMS aSelArq SIZE 75,15 OF oPanelOrigem PIXEL

	@ 138,005 SAY oPrdN VAR "Importa produtos não localizados? " OF oPanelOrigem PIXEL
	@ 135,090 COMBOBOX oSelPrd VAR cFilPrd ITEMS aSelPrd SIZE 75,15 OF oPanelOrigem PIXEL

	//Painel com botões
	oPanelBtn := TPanel():New( (nAltura/2)-14, 0, ,oDlgWOF, , , , , , (nLargura/2), 14, .F.,.T. )
	@ 000,((nLargura/2)-122) BUTTON oBtnAvanca PROMPT "Confirmar"  SIZE 60,12 ACTION (VldSele(_cTabOri, _cFilSel, cFilPrd, .F.)) OF oPanelBtn PIXEL
	@ 000,((nLargura/2)-60)  BUTTON oBtnAvanca PROMPT "Cancelar"   SIZE 60,12 ACTION (oDlgWOF:End()) OF oPanelBtn PIXEL //"Cancelar"
	ACTIVATE MSDIALOG oDlgWOF CENTER
Return

//-------------------------------------------------------------------
//Valida Fornecedor
//-------------------------------------------------------------------
Static Function BuscForn()
	Local _lRet := .t.
	Local _aCodForn := u_MPosFor(_cCodMarc)
	If Len(_aCodForn) > 0
		If !Empty(_cCodMarc)
			dbSelectArea("ZZ7")
			dbSetOrder(1)
			If dbSeek(xFilial()+_cCodMarc)
				_cNReduz := ZZ7->ZZ7_DESCRI
			Else
				Help(" ",1,"HELP","EXCADFORN","Codigo da Marca não encontrado",3,1)
				_lRet := .f.
			Endif
			oNReduz:Refresh()
		Endif
	Else
		Help(" ",1,"HELP","NCADFORN","Fornecedor não cadastrado",3,1)
		_lRet := .f.
	Endif
Return(_lRet)
//-------------------------------------------------------------------
//Select File - Seleciona Arquivo
//-------------------------------------------------------------------
Static Function SelectFile()

	cFile := cGetFile("Arquivo de Texto" + "|*.csv|" + "Todos Arquivos" + "|*.*","Selecione o arquivo para importação",0,GetMV("MV_XPATHPF",,"C:\"),.T.,nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ) ,.F.)//"Arquivo de Texto","Todos Arquivos","Selecione o arquivo para importação"

Return Nil
//-----------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AN_REIMPZ3(_aFilCop, lEnd)

Local aArea    := GetArea()
Local nX       := 1
Local nJ       := 1
Local cFilOri  := cFilAnt
Local aDados   := {}
Local aLstSobP := {}
Local _aCodForn := {}
Local _cFileTab := ""
Local nK		:= 1
Local nB		:= 1
LOCAL _cTabID
LOCAL _aTabID   := {}
Local aTabExc   := {}
Private _nPosCod := 1
Private _nPosPRC := 2
Private _nPosIPI := 3
Private _nPosGRP := 4
Private _nPosSGP := 5
Private _nPosICM := 0
Private _nPosUNP := 0

For nX:=1 to Len(_aFilCop)
	cFilAnt   := _aFilCop[nX,1]
	cCodTab   := _aFilCop[nX,2]
	aDados    := {}
	aLstSobP  := {}
	_aCodForn := {}
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodTab)
		_cFileTab := SZ2->Z2_ARQUIVO
		_cTabID   := SZ2->Z2_TABID
		aadd(aLstSobP, {cFilAnt, cCodTab, SZ2->Z2_DESCTAB, SZ2->Z2_MARCA, SZ2->Z2_FRETE, SZ2->Z2_ICMFRT, SZ2->Z2_DESPFIN})
		aadd(_aCodForn, {SZ2->Z2_CODFORN, SZ2->Z2_LOJA})
		dbSelectArea("SZ3")
		dbSetOrder(1)
		dbSeek(xFilial()+cCodTab)
		While !Eof() .and. xFilial("SZ3")+cCodTab == SZ3->(Z3_FILIAL+Z3_CODTAB)
			cCodRef := SZ3->Z3_CODREF
			nPreco  := SZ3->Z3_PRCBRT
			nIPI    := SZ3->Z3_IPI
			cGrupo  := SZ3->Z3_GRUPO
			cSbGrp	:= SZ3->Z3_SUBGRP
			aadd(aDados, {cCodRef, nPreco, nIPI, cGrupo, cSbGrp})
			dbSkip()
		End
		If Len(aDados) > 0
			aTabExc := {}
			_aTabID := {}
			aadd(aTabExc, {cFilAnt, cCodTab})
			Processa( {|lEnd| EXCLPOL(aTabExc)}, "Aguarde...","Excluindo Lista de Preço", .T. )
			cFilAnt := aLstSobP[1,1]
			cIdTab	:= aLstSobP[1,2]
			_cDescTab := aLstSobP[1,3]
			_cCodMarc := aLstSobP[1,4]
			_nVlfrete := aLstSobP[1,5]
			_nICMfrete := aLstSobP[1,6]
			_nDespFin := aLstSobP[1,7]
			dbSelectArea("SZ2")
			RecLock("SZ2",.T.)
			Replace Z2_FILIAL with xFilial("SZ2"),;
					Z2_CODTAB with cIdTab,;
					Z2_MARCA with _cCodMarc,;
					Z2_DATA with dDataBase,;
					Z2_DESCTAB with _cDescTab,;
					Z2_USUARIO with CUSERNAME,;
					Z2_CODFORN with _aCodForn[1,1],;
					Z2_LOJA with _aCodForn[1,2],;
					Z2_STATUS with '4',;
					Z2_ARQUIVO with _cFileTab,;
					Z2_TABID with _cTabID,;
					Z2_FRETE with _nVlfrete,;
					Z2_ICMFRT with _nICMfrete,;
					Z2_DESPFIN with _nDespFin
			SZ2->(MsUnLock())
			GrvArqImp(.T., _cFileTab, cIdTab, _cTabID)
			ProcRegua(Len(aDados))
			For nJ:=1 to Len(aDados)
				IncProc("Processando Filial " + cFilAnt + " Linha " + StrZero(nJ,6) + " de " + StrZero(Len(aDados),6))
				u_ProcGerSZ3("1", "S", cIdTab, _cCodMarc, _aCodForn, aDados, nJ)
			Next
			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+cIdTab) .and. SZ2->Z2_STATUS == "4"
				dbSelectArea("SZ3")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ3")+cIdTab)
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
		Endif
	Endif
Next
cFilAnt := cFilOri
RestArea(aArea)
Return

//-------------------------------------------------------------------
//Valida Campos Digitados
//-------------------------------------------------------------------
Static Function VldSele(_cTabOri, _cFilSel, cFilPrd, lSobrepor )

Local _lRet := .t.
Local _aArea := GetArea()
Local _cFileTab := Alltrim(cFile)
Local _lExclusiva := .T.
Default lSobrepor := .F.
If _lExclusiva
	If !Empty(_cCodMarc)
		dbSelectArea("ZZ7")
		dbSetOrder(1)
		If !dbSeek(xFilial()+_cCodMarc)
			Help(" ",1,"HELP","EXISTFORN","Codigo do Fornecedor não encontrado",3,1)
			_lRet := .f.
		Endif
	Else
		Help(" ",1,"HELP","VAZIOFORN","Favor preencher o Codigo e a Loja do Fornecedor",3,1)
		_lRet := .f.
	Endif
	If _lRet
		If Empty(_cDescTab)
			Help(" ",1,"HELP","VAZIODESC","Favor preencher a descrição da tabela",3,1)
			_lRet := .f.
		Endif
	Endif
	If _lRet
		If !Empty(_cFileTab)
			If FOpen(Alltrim(_cFileTab)) > 0
				_lRet := Processa( {|lEnd| ValidFile(_cTabOri, _cFilSel, _cFileTab, cFilPrd, _cCodMarc, lSobrepor)}, "Aguarde...","Importando tabela de preço", .T. )
				oDlgWOF:End()
			Else
				Help(" ",1,"HELP","NARQUI","Arquivo informado não encontrado",3,1)
			Endif
		Else
			Help(" ",1,"HELP","ARQUINF","Favor informar o caminho do arquivo para importar",3,1)
		Endif
	Endif
Else
	Help(" ",1,"HELP","EXCLUSIV","Processo de importação de Tabela está sendo utilizada, aguarde finalizar",3,1)
Endif
RestArea(_aArea)
Return(_lRet)

//-------------------------------------------------------------------
//Valid File - Valida o arquivo
//-------------------------------------------------------------------
Static Function ValidFile(_cTabOri, _cFilSel, _cFileTab, cFilPrd, _cCodMarc, lSobrepor)

Local _aArea      := GetArea()
Local cDirDocs
LOCAL cStartPath  := GetSrvProfString("Startpath","")
LOCAL lCopied     := .F.
Local cArquivo    := CriaTrab(,.F.)
Local _cTabID
//Ita - 19/08/2020 - Local _aCodForn := u_MPosFor(_cCodMarc)
Local aSelFil     := {}
Local _aTabID     := {}
Local cFilOri     := cFilAnt
Local nSaveSx8Len := GetSx8Len()
Local nK          := 1
Local aRetFil	  := {}
Local aJaGrv	  := {}
Local nJ		  :=1
Local aFilGer	  := {}
Default lSobrepor := .F.
_aCodForn         := u_MPosFor(_cCodMarc)
If File(_cFileTab)
	cArquivo += ".CSV"
	If MsMultDir()
		cDirDocs := MsRetPath( _cFileTab )
	Else
		cDirDocs := MsDocPath()	
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira a ultima barra invertida ( se houver )                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsDocRmvBar( @cDirDocs )
	cPathFile := cDirDocs + "\" + cArquivo
	If lSobrepor
		aadd(aSelFil, {cFilAnt, _cFileTab, cPathFile})
	Else
		If Substr(_cFilSel,1,1) == "S"
			aRetFil := SelGetFil(_cFileTab)
			If Len(aRetFil) > 0
				For nJ:=1 to Len(aRetFil)
					If File(aRetFil[nJ,2])
						nPos := aScan(aJaGrv,{|x| x[1] == aRetFil[nJ,2]})
						If nPos == 0
							cArquivo  := CriaTrab(,.F.)
							cArquivo += ".CSV"
							If MsMultDir()
								cDirDocs := MsRetPath( _cFileTab )
							Else
								cDirDocs := MsDocPath()	
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Retira a ultima barra invertida ( se houver )                          ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							MsDocRmvBar( @cDirDocs )
							cPathFile := cDirDocs + "\" + cArquivo
							aadd(aJaGrv, {aRetFil[nJ,2], cPathFile})
							aadd(aSelFil, {aRetFil[nJ, 1], aRetFil[nJ, 2], cPathFile})
						Else
							cPathFile := aJaGrv[nPos,2]
							aadd(aSelFil, {aRetFil[nJ, 1], aRetFil[nJ, 2], cPathFile})
						Endif
					Endif
				Next
			Endif
		Else
			aadd(aSelFil, {cFilAnt, _cFileTab, cPathFile})
		Endif
	Endif
	If Len( aSelFil ) <= 0
		Return
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Copia o arquivo do servidor para o diretorio temporario do terminal    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ASORT(aSelFil, , , { | x,y | x[3]+x[1] < y[3]+y[1] } )
	For nJ:=1 to Len(aSelFil)
		_cFileTab := aSelFil[nJ,2]
		cPathFile := aSelFil[nJ,3]
		Processa( { || lCopied := __CopyFile( _cFileTab, cPathFile ) }, "Transferindo objeto", "Aguarde...", .F. )
		_cTabID := NextIDTab("MV_XTABID", "Z2_TABID")
		_aTabID := {}
		While lCopied .and. nJ <= Len(aSelFil) .and. cPathFile == aSelFil[nJ,3]
			If lSobrepor
				EXCLPOL(aLstSobP,.F.)
				For nK:=1 to Len(aLstSobP)
					//aadd(aLstSobP, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB, (cAliasTMP)->TMP_DESCTAB, (cAliasTMP)->TMP_FORNEC, SZ2->Z2_FRETE, SZ2->Z2_ICMFRT, SZ2->Z2_DESPFIN})
					cFilAnt    := aLstSobP[nK,1]
					cIdTab     := aLstSobP[nK,2]
					_cDescTab  := aLstSobP[nK,3]
					_cCodMarc  := aLstSobP[nK,4]
					_nVlfrete  := aLstSobP[nK,5]
					_nICMfrete := aLstSobP[nK,6]
					_nDespFin  := aLstSobP[nK,7]
					dbSelectArea("SZ2")
					RecLock("SZ2",.T.)
					Replace Z2_FILIAL with xFilial("SZ2"),;
							Z2_CODTAB with cIdTab,;
							Z2_MARCA with _cCodMarc,;
							Z2_DATA with dDataBase,;
							Z2_DESCTAB with _cDescTab,;
							Z2_USUARIO with CUSERNAME,;
							Z2_CODFORN with _aCodForn[1,1],;
							Z2_LOJA with _aCodForn[1,2],;
							Z2_STATUS with '4',;
							Z2_ARQUIVO with _cFileTab,;
							Z2_TABID with _cTabID,;
							Z2_FRETE with _nVlfrete,;
							Z2_ICMFRT with _nICMfrete,;
							Z2_DESPFIN with _nDespFin
					SZ2->(MsUnLock())
					GrvArqImp(.T., _cFileTab, cIdTab, _cTabID)
					aadd(_aTabID, {aLstSobP[nK,1], aLstSobP[nK,2]})
				Next
			Else
				cFilAnt := aSelFil[nJ,1]
				cIdTab	:= GetSXENum("SZ2","Z2_CODTAB")
				dbSelectArea("SZ2")
				RecLock("SZ2",.T.)
				Replace Z2_FILIAL with xFilial("SZ2"),;
						Z2_CODTAB with cIdTab,;
						Z2_MARCA with _cCodMarc,;
						Z2_DATA with dDataBase,;
						Z2_DESCTAB with _cDescTab,;
						Z2_USUARIO with CUSERNAME,;
						Z2_CODFORN with _aCodForn[1,1],;
						Z2_LOJA with _aCodForn[1,2],;
						Z2_STATUS with '4',;
						Z2_ARQUIVO with _cFileTab,;
						Z2_TABID with _cTabID
				SZ2->(MsUnLock())
				While (GetSx8Len() > nSaveSx8Len)
					ConfirmSX8()
				EndDo
				GrvArqImp(.T., _cFileTab, cIdTab, _cTabID)
				If !Empty(_cTabOri)
					ExecApag(cFilAnt, cIdTab)
					ExecCop(cFilAnt,_cTabOri, cFilAnt, cIdTab)
				Endif
				aadd(_aTabID, {xFilial("SZ2"), cIdTab})
			Endif
			aadd(aFilGer, aSelFil[nJ,1])
			nJ++
		End
		u_ImpFileTXT(.F., cEmpAnt, cFilAnt,_cTabOri, aFilGer, cPathFile, cFilPrd, _cCodMarc, aLstSobP, _cDescTab, _aTabID, _aCodForn)
		nJ--
	Next
Endif
cFilAnt := cFilOri
RestArea(_aArea)
Return

//---------------------------------------------------------------------------------------------------------------

Static Function GrvArqImp(_lGrvACB, cFile, cIdTab, _cTabID)

	Local _aArea     := GetArea()
	Local _aAreaZ2   := SZ2->(GetArea())
	Local cArqDest   := ""
	Local cExt       := ""
	Local nSaveSx8   := GetSx8Len()
	Local _cChaveAC9 := PADR(xFilial("SZ2")+cIdTab, TAMSX3("AC9_CODENT")[1])
	Local _cCodObj
	Local _lContinua := .T.
	Local cAliasSZ2  := "QRYCHN"
	Local nLoop      := 1
	If _lGrvACB
		dbSelectArea("ACB")
		RegToMemory( "ACB", .F.,,,)
		cObjeto := cFile
		SplitPath( cObjeto,,, @cArqDest, @cExt )
		dbSelectArea("ACB")
		dbSetOrder(3)
		If FT340CpyObj(cFile)
			dbSelectArea( "ACB" )
			dbSetOrder(1)
			_cCodObj := GetSxeNum("ACB","ACB_CODOBJ")
			If !dbSeek(xFilial()+_cCodObj)
				While !Eof()
					_cCodObj := GetSxeNum("ACB","ACB_CODOBJ")
					dbSeek(xFilial()+_cCodObj)
				End
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os demais campos inclusive especificos ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			M->ACB_DESCRI := cObjeto
			RecLock( "ACB", .T. )
			ACB->ACB_FILIAL  := xFilial( "ACB" )
			ACB->ACB_CODOBJ  := _cCodObj
			If FindFunction( "MsMultDir" ) .And. MsMultDir()
				ACB->ACB_PATH	:= MsRetPath( M->ACB_OBJETO )
			Endif
			For nLoop := 1 To FCount()
				cCampo := FieldName( nLoop )
				If !( cCampo $ "ACB_FILIAL/ACB_CODOBJ/ACB_PATH" ) .And. Type("M->"+cCampo)<>"U"
					FieldPut( nLoop, M->&cCampo )
				EndIf
			Next nLoop
			ACB->( MsUnlock() )
			While (GetSx8Len() > nSaveSx8)
				ConfirmSX8()
			EndDo
			EvalTrigger()
		Else
			_lContinua := .f.
		Endif
	Else
		_cQuery := "SELECT DISTINCT AC9_CODOBJ"
		_cQuery += " FROM " + RetSqlName("AC9") + " AC9 "
		_cQuery += " WHERE AC9_FILIAL = '" + xFilial("AC9") + "'"
		//Ita - 15/09/2020 - _cQuery += " AND Z2_TABID = '" + _cTabID + "'"
		_cQuery += " AND AC9_FILENT = '" + xFilial("SZ2") + "'"
		_cQuery += " AND AC9_ENTIDA = 'SZ2'"
		_cQuery += " AND AC9_CODENT = '" + _cChaveAC9 + "'"
		_cQuery += " AND AC9.D_E_L_E_T_ = ' '"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ2,.T.,.T.)
		dbSelectArea(cAliasSZ2)
		If !Eof()
			_cCodObj := (cAliasSZ2)->AC9_CODOBJ
		Else
			_lContinua := .F.
		Endif
		(cAliasSZ2)->(dbCloseArea())
	Endif
	If _lContinua
		dbSelectArea("AC9")
		dbSetOrder(1)
		If !dbSeek(xFilial()+_cCodObj+"SZ2"+xFilial("SZ2")+_cChaveAC9)
			RecLock("AC9",.T.)
			Replace AC9_FILIAL with xFilial("AC9"),;
					AC9_FILENT with xFilial("SZ2"),;
					AC9_CODENT with _cChaveAC9,;
					AC9_ENTIDA with "SZ2",;
					AC9_CODOBJ with _cCodObj
			MsUnLock()
		Endif
	Endif
	RestArea(_aAreaZ2)
	RestArea(_aArea)
Return

//--------------------------------------------------------------------------------------------------------
//
Static Function AN_VIEWTAB

	Local _cFilial := SZ2->Z2_FILIAL
	Local _cCodTab := SZ2->Z2_CODTAB
	Local _cDescTab:= SZ2->Z2_DESCTAB
	Local _cMarca  := SZ2->Z2_MARCA
	Local bOk			:= {||}
	oBrowse := FWmBrowse():New()
	oBrowse:SetDataTable(.T.)	//Indica que o Browse utiliza tabela do banco de dados
	oBrowse:SetAlias( 'SZ3' )
	oBrowse:SetDescription("Tabela: " + _cCodTab + " - " + Alltrim(_cDescTab) + Space(10) + "Fornecedor: " + _cMarca)
	oBrowse:AddFilter( "Tabela", "Z3_FILIAL == '" + _cFilial + "' .AND. Z3_CODTAB == '" + _cCodTab + "'", .T., .T.)
	//oBrowse:AddButton("Pedido Encerrar", bOk,,,, .F., 7 )
	oBrowse:SetMenuDef("CADSZ3")
	oBrowse:Activate()
Return

//--------------------------------------------------------------------------------------------------------
//
Static Function AN_VIEWPRC

oBrowse := FWmBrowse():New()
oBrowse:SetDataTable(.T.)	//Indica que o Browse utiliza tabela do banco de dados
oBrowse:SetAlias( 'DA1' )
oBrowse:SetDescription("Itens da Tabela de Preço")
oBrowse:SetMenuDef("")
oBrowse:Activate()
Return

//--------------------------------------------------------------------------------------------------------
//
Static Function SIMUPRV

	Local _cFilial := SZ2->Z2_FILIAL
	Local _cCodTab := SZ2->Z2_CODTAB
	Local _aArea   := GetArea()
	Local cAliasSZ3 := "QRYSZ3"
	Local _aRetPrc	:= {}
	Local aColumns	:= {}
	Local cAliasTMP := GetNextAlias()
	Local aFields     := {}
	Local aArqTab     := {}
	Local aIndex	:= {}
	Local aArqTmp	:= {}
	Local aColsSX3    := {}
	Local oTabTmp	:= Nil
    Local cPerg		:= "SIMUL01"
    Local _aFilCop	:= {}
	Local _nMinVar	:= 0
	Local _nMaxVar	:= 0
	Local nX 		:= 1
	Gera_SX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	_dDtSimul := MV_PAR01 //Ita - 08/09/2020 - Pega Data da Simulação 
	aadd(_aFilCop, {_cFilial, _cCodTab})
	_dDtSimul := IIF(!Empty(mv_par01), mv_par01, dDataBase)
	AAdd(aArqTmp, {"TMP_OK"		,"OK"								, "C" ,1					,0, " "		, 30})
	AAdd(aArqTmp, {"TMP_MARCA" 	,BuscarSX3("Z2_MARCA",,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	AAdd(aArqTmp, {"TMP_CODREF"	,BuscarSX3("Z3_CODREF",,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	AAdd(aArqTmp, {"TMP_PROD" 	,BuscarSX3("Z3_COD",,aColsSX3)		,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	Aadd(aArqTmp, {"TMP_DESCRI"	,BuscarSX3("B1_DESC",,aColsSX3)		,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 200})
	BuscarSX3("Z3_PRCVEN",,aColsSX3)
	aAdd(aArqTmp, {"TMP_PRCANT"	,"Preço Vd Anterior"				,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_PRCREP"	,"Preço Reposição"					,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_LETRA"	,BuscarSX3("Z3_LETRA",,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 50})
	aAdd(aArqTmp, {"TMP_MARGEM"	,BuscarSX3("Z3_MARGEM",,aColsSX3)	,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_FATOR"	,BuscarSX3("Z3_FATOR",,aColsSX3)	,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	BuscarSX3("Z3_PRCVEN",,aColsSX3)
	aAdd(aArqTmp, {"TMP_PRCBRT" ,"Preço Vd Bruto"					,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_DESC"	,BuscarSX3("Z3_DESCONT",,aColsSX3)	,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_PRCVEN"	,BuscarSX3("Z3_PRCVEN",,aColsSX3)	,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	BuscarSX3("Z3_MARGEM",,aColsSX3)
	aAdd(aArqTmp, {"TMP_VARIAC"	,"Variação (%)"						,"N",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_CVARIA"	,"Variação"							,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	aAdd(aArqTmp, {"TMP_CODTAB"	,BuscarSX3("Z3_CODTAB",,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})

	Aadd( aIndex, "TMP_CVARIA")
	Aadd( aIndex, "TMP_PROD")
//	Aadd(aSeeks,{"Variação"	 , {{""/*SX3->X3_F3*/,"N",TAMSX3("Z3_MARGEM")[1],0, "TMP_VARIAC",""/*X3Picture*/}} , 1, .T. } )
//	Aadd(aSeeks,{"Produto"	 , {{"","C",TAMSX3("B1_COD")[1],0, "TMP_PROD",""}}								, 2, .T. } )
	For nX := 1 To Len(aArqTmp)
		If	!aArqTmp[nX][1] $ "TMP_MARCA/TMP_CODTAB/TMP_OK/TMP_CVARIA/TMP_CODREF"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:lAutosize:=.f.
			aColumns[Len(aColumns)]:SetData( &("{||"+aArqTmp[nX][1]+"}") )
			aColumns[Len(aColumns)]:SetTitle(aArqTmp[nX][2])
			aColumns[Len(aColumns)]:SetType(aArqTmp[nX][3])
			aColumns[Len(aColumns)]:SetSize(aArqTmp[nX][7])
			aColumns[Len(aColumns)]:SetDecimal(aArqTmp[nX][5])
			aColumns[Len(aColumns)]:SetPicture(aArqTmp[nX][6])
		Endif
		AAdd(aArqTab,{aArqTmp[nX][1],aArqTmp[nX][3],aArqTmp[nX][4],aArqTmp[nX][5]})
		AAdd(aFields,{aArqTmp[nX][1],aArqTmp[nX][2],aArqTmp[nX][3],aArqTmp[nX][4],aArqTmp[nX][5],aArqTmp[nX][6]})
	Next nX

	CriaTabTmp(aArqTab,aIndex,cAliasTmp,@oTabTmp)

	cFilAnt := _cFilial
	dbSelectArea("SZ3")
	_cQuery := "SELECT COUNT(*) COUNT "
	_cQuery += "FROM " + RetSqlName("SZ3") + " SZ3, " + RetSqlName("SB1") + " SB1 "
	_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
	_cQuery += " AND Z3_CODTAB = '" + _cCodTab + "'"
	_cQuery += " AND Z3_COD <> ' '"
	_cQuery += " AND SZ3.D_E_L_E_T_ = ' '"
	_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND Z3_COD = B1_COD"
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ3,.T.,.T.)
	dbSelectArea(cAliasSZ3)
	nTotalRec := (cAliasSZ3)->COUNT
	dbCloseArea()
	If nTotalRec > 0
		ProcRegua( nTotalRec )
		_cQuery := "SELECT Z3_FILIAL TMP_FILIAL, Z2_MARCA TMP_MARCA, Z3_CODREF TMP_CODREF, Z3_COD TMP_PROD, B1_DESC TMP_DESCRI"
		_cQuery += " , Z3_PRCREP TMP_PRCREP, Z3_LETRA TMP_LETRA, Z3_DESCVEN TMP_DESC, Z3_MARGEM TMP_MARGEM,Z3_PRCVEN TMP_PRCBRT, Z3_PRCVEN TMP_PRCVEN, ZZH_INDICE TMP_FATOR, Z3_CODTAB TMP_CODTAB "
		_cQuery += " FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SZ3") + " SZ3 "
		_cQuery += " INNER JOIN " + RetSqlName("SZ2") + " SZ2 ON Z2_FILIAL = '" + xFilial("SZ2") + "' AND Z2_CODTAB = '" + _cCodTab + "' AND SZ2.D_E_L_E_T_ = ' '"
		_cQuery += " LEFT JOIN " + RetSqlName("ZZH") + " ZZH ON ZZH_FILAN = '" + xFilial("SZ3") + "' AND ZZH_GRUPO = Z3_LINHA AND ZZH_MARCA = Z2_MARCA AND ZZH.D_E_L_E_T_ = ' '"
		_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cQuery += " AND Z3_CODTAB = '" + _cCodTab + "' AND Z3_COD <> ' ' AND SZ3.D_E_L_E_T_ = ' ' AND Z3_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_MSBLQL <> '1'"
		_cQuery += " ORDER BY Z3_COD "
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ3,.T.,.T.)
		//	Memowrite("C:\TOTVS\Query.txt",_cQuery)
		Memowrite("C:\TEMP\SelItemTab.SQL",_cQuery) //Ita - 26/08/2020
		dbSelectArea(cAliasSZ3)
		While ! (cAliasSZ3)->(Eof())
			IncProc("Calculando Variação de Preço....")
			_cCodRef	:= (cAliasSZ3)->TMP_CODREF
			_cCod 		:= (cAliasSZ3)->TMP_PROD
			_nCusto 	:= (cAliasSZ3)->TMP_PRCREP
			_cCodMarc 	:= Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_XMARCA")
			_nPrcRep	:= (cAliasSZ3)->TMP_PRCREP
			//Ita - 10/08/2020 - _nDescVen	:= (cAliasSZ3)->TMP_DESC
			_aRetTab	:= u_BuscTabVig(_cCod, _cCodTab, _dDtSimul)
			_cLetra 	:= _aRetTab[1]
			_nTabRep 	:= _aRetTab[2]
			_nPrcAtu 	:= _aRetTab[3]
			_nDescVen	:= _aRetTab[4] //Ita - 10/08/2020
			_nVariac	:= 0
			_cMonoFas 	:= IIF(Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_XMONO")=="S","S","N")
			_cLinhaSB1  := Posicione("SB1",1,xFilial("SB1")+_cCod,"B1_XLINHA")
			_aRetPrc	:= u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nCusto, _nDescVen)
			_nMarKup	:= _aRetPrc[1]
			_nLetra		:= _aRetPrc[2]
			_nFator		:= _aRetPrc[3]
			_nPrcVen	:= _aRetPrc[4]
			_nMargem 	:= _aRetPrc[5]
			_nPrcBrt	:= _aRetPrc[6]
			If _nPrcAtu > 0
				_nVariac := Round(((_nPrcVen - _nPrcAtu) / _nPrcAtu)*100,2)
			Endif
			dbSelectArea(cAliasTmp)
			RecLock(cAliasTmp,.T.)
			Replace TMP_MARCA	with _cCodMarc,;
					TMP_PROD	with _cCod,;
					TMP_CODREF	with _cCodRef,;
					TMP_DESCRI	with (cAliasSZ3)->TMP_DESCRI,;
					TMP_PRCANT	with _nPrcAtu,;
					TMP_PRCREP	with _nPrcRep,;
					TMP_LETRA	with _cLetra,;
					TMP_MARGEM	with _nMargem,;
					TMP_FATOR	with _nFator,;
					TMP_PRCBRT	with _nPrcBrt,; //Ita - 01/09/2020 - Antes estava gravando preço de venda na coluna de preço bruto - _nPrcVen,;
					TMP_DESC	with _nDescVen,;
					TMP_PRCVEN	with _nPrcVen,;
					TMP_VARIAC	with _nVariac,;
					TMP_CVARIA	with StrZero(_nVariac*100,6),;
					TMP_CODTAB	with (cAliasSZ3)->TMP_CODTAB
			MsUnLock()
			dbSelectArea(cAliasSZ3)
			While !Eof() .and. _cCod == (cAliasSZ3)->TMP_PROD
				(cAliasSZ3)->(DbSkip())
			End
		End
		dbSelectArea(cAliasSZ3)
		dbCloseArea()
	Endif
	dbSelectArea(cAliasTMP)
	dbGotop()
	aOrderMB := {} //Ita - 26/08/2020
	//Aadd(aOrderMB,{"Produto"	 , {{"","C",TAMSX3("B1_COD")[1],0, "TMP_PROD",""}}, 1, .T. } )
	Aadd(aOrderMB,{"Produto"	 , {{"","C",TAMSX3("B1_COD")[1],0, "TMP_PROD",""}}, 2, .T. } )
	If !Eof() .and. !Bof()
//		_oBrwClass:SetSeek(.T.,aSeeks)
		//Ita - 08/09/2020 - Controle da Data de Simulação - _oBrwClass:AddButton("Efetivar Tabela" /* Ok */,{|| EFETTAB(cAliasTMP) })
		_oBrwClass:= FWMarkBrowse():New()
		_oBrwClass:SetFieldMark("TMP_OK")
		_oBrwClass:SetAlias(cAliasTMP)
		_oBrwClass:SetColumns(aColumns)
		_oBrwClass:AddButton("Efetivar Tabela" /* Ok */,{|| EFETTAB(cAliasTMP,_dDtSimul) })
		_oBrwClass:AddButton("Alterar preço  " /* Ok */,{|| U_AltPrc(cAliasTMP) })
		_oBrwClass:AddButton("Imprimir Selecionados" /* Ok */,{|| u_RSIMTAB("2", cAliasTMP, _aFilCop, _nMinVar, _nMaxVar, _dDtSimul, _oBrwClass) })
		_oBrwClass:SetParam({|| SelMark(cAliasTMP, @_nMinVar, @_nMaxVar) })
		_oBrwClass:SetAllMark( { || FMarkAll( _oBrwClass ) } )
		_oBrwClass:DisableFilter()
		_oBrwClass:DisableConfig()
		_oBrwClass:SetMenuDef("")
		_oBrwClass:SetSeek(.T., aOrderMB ) //Ita - 26/08/2020
		_oBrwClass:Activate()
	Else
		MsgAlert("Não existe produto cadastrado para essa tabela","Produtos")
	Endif
	DelTabTmp(cAliasTmp,oTabTmp)
	RestArea(_aArea)
Return

//-------------------------------------------------------------------//
//--------------------Seleção do filtro tecla F12--------------------//
//-------------------------------------------------------------------//
Static Function SelMark(cAliasTMP, _nMinVar, _nMaxVar)

Local cPerg		:= "SIMUL02"
Local cMrkSel	:= _oBrwClass:Mark()
Gera_SX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif
_nMinVar := mv_par01
_nMaxVar := mv_par02
dbSelectArea(cAliasTMP)
dbGotop()
While !Eof()
	RecLock(cAliasTMP,.F.)
	If (cAliasTMP)->TMP_VARIAC >= _nMinVar .and. (cAliasTMP)->TMP_VARIAC <= _nMaxVar
		Replace TMP_OK with cMrkSel
	Else
		Replace TMP_OK with " "
	Endif
	MsUnLock()
	dbSkip()
End
dbSelectArea(cAliasTMP)
dbGotop()
_oBrwClass:oBrowse:Refresh(.T.)
Return
//-------------------------------------------------------------------------------------------------------------------------------------------
Static Function FMarkAll( oBrowse )
    Local cAlias	as character
    Local cMark	as character
    Local nRecno	as numeric
    cAlias	:=	oBrowse:Alias()
    cMark	:=	oBrowse:Mark()
    nRecno	:=	( cAlias )->( Recno() )
    lMarkAll	:= .T.
    ( cAlias )->( DBGoTop() )
    While ( cAlias )->( !Eof() )
        If RecLock( cAlias, .F. )
            ( cAlias )->TMP_OK := Iif( ( cAlias )->TMP_OK == cMark, "  ", cMark )
            ( cAlias )->( MsUnlock() )
        EndIf
        ( cAlias )->( DBSkip() )
    EndDo
    ( cAlias )->( DBGoTo( nRecno ) )
    oBrowse:Refresh()
Return()

//-------------------------------------------------------------------
Static Function PRCFRNSZ4(oModelGrid)

	Local lRet       := .T.
	Local nLineCYL   := oModelGrid:GetLine()
	Local _cTpDesc   := FwFldGet('Z4_TPDESC')
	Local _cGrupo    := FwFldGet('Z4_GRUPO')
	Local _cSbGrp    := FwFldGet('Z4_SUBGRP')
	Local _cNacImp   := FwFldGet('Z4_NACIMP')
	Local nI         := 0
	Local _cCampo	 := ""
	Local _lValida	 := .F.
	For nI:=1 to 10
		_cCampo := "Z4_DESC" + StrZero(nI,2)
		_nDesconto := FwFldGet(_cCampo)
		If _nDesconto > 0
			_lValida := .T.
			Exit
		Endif
	Next
	If _lValida
		If Empty(_cTpDesc) .or. Empty(_cGrupo) .or. Empty(_cNacImp)
			Help(" ",1,"HELP","CPVAZIO","Favor preencher os campos Nac/Imp., Grupo e Tipo do Desconto no Grid de Desconto por Grupo/SubGrupo ",3,1)
			lRet := .F.
		Endif
	Endif
Return(lRet)

//-------------------------------------------------------------------
Static Function PRCFRNSZ5(oModelGrid)

	Local lRet       := .T.
	Local _cTpDesc   := FwFldGet('Z5_TPDESC')
	Local _cCodRef   := FwFldGet('Z5_CODREF')
	Local nI         := 0
	Local _cCampo	 := ""
	Local _lValida	 := .F.
	For nI:=1 to 10
		_cCampo := "Z5_DESC" + StrZero(nI,2)
		_nDesconto := FwFldGet(_cCampo)
		If _nDesconto > 0
			_lValida := .T.
			Exit
		Endif
	Next
	If _lValida
		If Empty(_cTpDesc) .or. Empty(_cCodRef)
			Help(" ",1,"HELP","CPVAZIO","Favor preencher os campos << Referencia >> e << Tipo >> do Desconto no Grid de Desconto por Produto ",3,1)
			lRet := .F.
		Endif
	Endif
Return(lRet)

//-------------------------------------------------------------------
Static Function PRCFRNSZ6(oModelGrid)

	Local lRet       := .T.
	Local _cNacImp   := FwFldGet('Z6_NACIMP')
	Local nI         := 0
	Local _cCampo	 := ""
	Local _lValida	 := .F.
	For nI:=1 to 10
		_cCampo := "Z6_DESC" + StrZero(nI,2)
		_nDesconto := FwFldGet(_cCampo)
		If _nDesconto > 0
			_lValida := .T.
			Exit
		Endif
	Next
	If _lValida
		If Empty(_cNacImp)
			Help(" ",1,"HELP","CPVAZION","Favor preencher o campo Nac/Imp. ",3,1)
			lRet := .F.
		Endif
	Endif
Return(lRet)
//--------------------------------------------------------------------
//
Static Function PRCFORPOS(oModel)

	Local _lRet := .t.

Return(_lRet)
//------------------------------------------------------------------
//
/*{Protheus.doc}CalcDesc
@author Ricardo Rotta
@since 31/08/2018
@version P12
Gatilho para calculo dos descontos em cascata
*/
//-------------------------------------------------------------------

User Function CTotDesc(cTabDig, cParam)

	Local oModel     := FwModelActive()
	Local oModelDET
	Local _nRet		 := 0
	Local _nDesc	 := 0
	Local _nBase	 := 100
	Local aDesconto  := {0,0,0,0,0,0,0,0,0,0}
	Local nMoeda	 := 1
	Local nY		 := 1
	Local _cCampo
	Default cParam 	 := 1
	If cTabDig == "SZ4"
		If cParam == "1"
			oModelDET := oModel:GetModel( 'Z4DETAIL' )
		Endif
		For nY:=1 to 10
			_cCampo := "Z4_DESC" + StrZero(nY,2)
			If cParam == "1"
				aDesconto[nY] := oModelDET:GetValue( _cCampo )
			Else
				aDesconto[nY] := SZ4->(&_cCampo)
			Endif
		Next
	ElseIf cTabDig == "SZ5"
		If cParam == "1"
			oModelDET := oModel:GetModel( 'Z5DETAIL' )
		Endif
		For nY:=1 to 10
			_cCampo := "Z5_DESC" + StrZero(nY,2)
			If cParam == "1"
				aDesconto[nY] := oModelDET:GetValue( _cCampo )
			Else
				aDesconto[nY] := SZ5->(&_cCampo)
			Endif
		Next
	ElseIf cTabDig == "SZ6"
		If cParam == "1"
			oModelDET := oModel:GetModel( 'Z6DETAIL' )
		Endif
		For nY:=1 to 10
			_cCampo := "Z6_DESC" + StrZero(nY,2)
			If cParam == "1"
				aDesconto[nY] := oModelDET:GetValue( _cCampo )
			Else
				aDesconto[nY] := SZ6->(&_cCampo)
			Endif
		Next
	Endif
	If Len(aDesconto) > 0
		_nDesc := Round(FtDescCab(_nBase,aDesconto,nMoeda),2)
        _nRet := _nBase - _nDesc
	Endif
Return(_nRet)
/*
Atualiza os campos de desconto Z4, Z5 e Z6
*/
//-----------------------------------------------------------
User Function AtuDscG4(_cTabela)

	Local _aArea := GetArea()
	Local oModel     := FwModelActive()
	//Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	//Local oModelZ3 	 := oModel:GetModel( 'Z3DETAIL' )
	//Local aSaveLine := FWSaveRows()
	Local nOperation := oModel:GetOperation()
	Local _nRet := CDescZ4(.t.,,nOperation)
	RestArea(_aArea)
Return(_nRet)
/*
Atualiza os campos de desconto Z4, Z5 e Z6
*/
//-----------------------------------------------------------
User Function AtuDscG5(_cTabela)

	Local _aArea := GetArea()
	Local oModel     := FwModelActive()
	//Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	//Local oModelZ3 	 := oModel:GetModel( 'Z3DETAIL' )
	//Local aSaveLine := FWSaveRows()
	Local nOperation := oModel:GetOperation()
	Local _nRet := CDescZ5(.t.,,nOperation)
	RestArea(_aArea)
Return(_nRet)
/*
Atualiza os campos de desconto Z4, Z5 e Z6
*/
//-----------------------------------------------------------
User Function AtuDscG6(_cTabela)

	Local _aArea := GetArea()
	Local oModel     := FwModelActive()
	//Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	//Local oModelZ3 	 := oModel:GetModel( 'Z3DETAIL' )
	//Local aSaveLine := FWSaveRows()
	Local nOperation := oModel:GetOperation()
	Local _nRet := CDescZ6(.t.,,nOperation)
	RestArea(_aArea)
Return(_nRet)

//-----------------------------------------------------------
//
Static Function CDescZ4(_lAtuTot, _lAtuSZ4, nOperation)

	Local oModel     := FwModelActive()
	Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	Local _nRet		 := 0
	Local _nDesc	 := 0
	Local _nBase	 := 100
	Local aDesconto  := {0,0,0,0,0,0,0,0,0,0}
	Local nMoeda	 := 1
	Local _cTipoZ4
	Local _cGrpZ4
	Local _cSubGrpZ4
	Local _cNacImp
	Default _lAtuSZ4 := .F.

	If nOperation >= 3 .and. nOperation <= 4 // .and. oModelZ4:GetQtdLine() > 0
		/*
		For nI := 1 to oModelZ4:GetQtdLine()
		oModelZ4:GoLine( nI )
		If !oModelZ4:IsDeleted()
		_nRet := 0
		_cTipoZ4 	:= oModelZ4:GetValue( "Z4_TPDESC" )
		_cGrpZ4  	:= oModelZ4:GetValue( "Z4_GRUPO" )
		_cSubGrpZ4 	:= oModelZ4:GetValue( "Z4_SUBGRP" )
		_cNacImp 	:= oModelZ4:GetValue( "Z4_NACIMP" )
		If !Empty(_cTipoZ4) .and. !Empty(_cGrpZ4)
		For nY:=1 to 10
		_cCZ4 	:= "Z4_DESC" + StrZero(nY,2)
		aDesconto[nY] := oModelZ4:GetValue( _cCZ4 )
		Next
		If Len(aDesconto) > 0
		_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
		_nRet := _nBase - _nDesc
		Endif
		Endif
		If _nRet > 0
		aadd(_aDescZ4, {_cGrpZ4, _cSubGrpZ4, _cNacImp, _cTipoZ4, _nRet})
		Endif
		oModelZ4:SetValue( 'Z4_TOTDESC', _nRet )
		Endif
		Next
		oModelZ4:GoLine( 1 )
		*/

		_nRet := 0
		_cTipoZ4 	:= SZ4->Z4_TPDESC
		_cGrpZ4  	:= SZ4->Z4_GRUPO
		_cSubGrpZ4 	:= SZ4->Z4_SUBGRP
		_cNacImp 	:= SZ4->Z4_NACIMP
		If !Empty(_cTipoZ4) .and. !Empty(_cGrpZ4)
			For nY:=1 to 10
				_cCZ4 	:= "SZ4->Z4_DESC" + StrZero(nY,2)
				aDesconto[nY] := &_cCZ4
			Next
			If Len(aDesconto) > 0
				_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
                _nRet := _nBase - _nDesc
			Endif
		Endif
	Endif
Return(_nRet)


// Calculo do Desconto da SZ5 por produto
Static Function CDescZ5(_lAtuTot, _lAtuSZ5, nOperation)

	Local oModel     := FwModelActive()
	Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	Local _nRet		 := 0
	Local _nDesc	 := 0
	Local _nBase	 := 100
	Local aDesconto  := {0,0,0,0,0,0,0,0,0,0}
	Local nMoeda	 := 1
	Local nY		 :=1
	Default _lAtuSZ5 := .F.
	If nOperation >= 3 .and. nOperation <= 4
		_nRet := 0
		_cTipoZ5 := SZ5->Z5_TPDESC
		_cCodRef := SZ5->Z5_CODREF
		If !Empty(_cTipoZ5) .and. !Empty(_cCodRef)
			For nY:=1 to 10
				_cCZ5	:= "SZ5->Z5_DESC" + StrZero(nY,2)
				aDesconto[nY] := &_cCZ5
			Next
			If Len(aDesconto) > 0
				_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
                _nRet := _nBase - _nDesc
			Endif
		Endif
	Endif
Return(_nRet)

// Calculo do Desconto da SZ6 GERAL
Static Function CDescZ6(_lAtuTot, _lAtuSZ6, nOperation)

	Local oModel     := FwModelActive()
	Local oModelMast :=	oModel:GetModel( 'Z2MASTER' )
	Local _nRet		 := 0
	Local _nDesc	 := 0
	Local _nBase	 := 100
	Local aDesconto  := {0,0,0,0,0,0,0,0,0,0}
	Local nMoeda	 := 1
	Local nY		 :=1
	Default _lAtuSZ6 := .F.
	If nOperation >= 3 .and. nOperation <= 4
		_cNacImp	:= SZ6->Z6_NACIMP
		For nY:=1 to 10
			_cCZ6	:= "SZ6->Z6_DESC" + StrZero(nY,2)
			aDesconto[nY] := &_cCZ6
		Next
		If Len(aDesconto) > 0
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
            _nRet := _nBase - _nDesc
		Endif
	Endif
Return(_nRet)
//----------------------------------------------------------------------------------------
User Function VlDescPl(_cParam)

	Local _lRet:= .t.
	Local oModel   := FwModelActive()
	Local oModelZ  := IIF(_cParam == "1",oModel:GetModel( 'Z4DETAIL' ), oModel:GetModel( 'Z5DETAIL' ))
	Local _nValor := &(ReadVar())
	Local _cTipoZ  := IIF(_cParam == "1",oModelZ:GetValue( "Z4_TPDESC" ), oModelZ:GetValue( "Z5_TPDESC" ))
	If _nValor > 0
		If Empty(_cTipoZ)
			Help(" ",1,"HELP","TPVAZIO","Favor preencher o campo  Tipo  do Desconto",3,1)
			_lRet := .f.
		Endif
	Endif
Return(_lRet)

//----------------------------------------------------------------------------------------
User Function VldGrpZ4

	Local _lRet:= .t.
	Local _aArea   := GetArea()
	Local oModel   := FwModelActive()
	Local oModelZ4 := oModel:GetModel( 'Z4DETAIL' )
	Local oModelZ2 := oModel:GetModel( 'Z2MASTER' )
	Local _cGrupo  := M->Z4_GRUPO
	Local _cCodTab := oModelZ2:GetValue( "Z2_CODTAB" )
	if !oModelZ4:IsDeleted()
		If !Empty(_cGrupo)
			dbSelectArea("SZ3")
			dbSetOrder(2)
			If !dbSeek(xFilial()+_cCodTab+_cGrupo)
				Help(" ",1,"HELP","GRPNEXIST","Grupo não encontrado na Lista de Preços",3,1)
				_lRet := .f.
			Endif
		Endif
	Endif
	RestArea(_aArea)
Return(_lRet)
//----------------------------------------------------------------------------------------
User Function VldSGpZ4

	Local _lRet:= .t.
	Local _aArea   := GetArea()
	Local oModel   := FwModelActive()
	Local oModelZ4 := oModel:GetModel( 'Z4DETAIL' )
	Local _cSubGrp := M->Z4_SUBGRP
	Local _cGrupo  := FwFldGet('Z4_GRUPO')
	Local _cCodTab := FwFldGet('Z4_CODTAB')
	if !oModelZ4:IsDeleted()
		If !Empty(_cSubGrp)
			dbSelectArea("SZ3")
			dbSetOrder(2)
			If !dbSeek(xFilial()+_cCodTab+_cGrupo+_cSubGrp)
				Help(" ",1,"HELP","SGRPNEXIST","SubGrupo não encontrado na Lista de Preços",3,1)
				_lRet := .f.
			Endif
		Endif
	Endif
	RestArea(_aArea)
Return(_lRet)
//----------------------------------------------------------------------------------------
User Function VldRefZ5

	Local _lRet:= .t.
	Local _aArea   := GetArea()
	Local oModel   := FwModelActive()
	Local oModelZ5 := oModel:GetModel( 'Z5DETAIL' )
	Local _cCodRef := M->Z5_CODREF
	Local _cCodTab := FwFldGet('Z5_CODTAB')
	if !oModelZ5:IsDeleted()
		If !Empty(_cCodRef)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			If !dbSeek(xFilial()+_cCodTab+_cCodRef)
				Help(" ",1,"HELP","CREFNEXIST","Referencia não encontrada na Lista de Preços",3,1)
				_lRet := .f.
			Endif
		Endif
	Endif
	RestArea(_aArea)
Return(_lRet)
//-----------------------------------------------------------------
// Inicializador Padrão Z4_CODTAB
User Function CODTABINI

	Local _cCodTab := CriaVar("Z4_CODTAB",.F.)
	Local oModel   := FwModelActive()
	Local oModelZ2 := oModel:GetModel( 'Z2MASTER' )
	_cCodTab := oModelZ2:GetValue( "Z2_CODTAB" )
Return(_cCodTab)
//-------------------------------------------------

Static Function VldCopTab(_cTabOri, _cDscOri, _cTabDes)

	Local _lRet := .t.
	Local _aArea := GetArea()
	If !Empty(_cTabOri)
		If _cTabOri == _cTabDes
			Help(" ",1,"HELP","NCODTABD","Codigo da tabela de Origem deve ser diferente da tabela de Destino",3,1)
			_lRet := .f.
		Endif
		If _lRet
			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial()+_cTabOri)
				_cDscOri := SZ2->Z2_DESCTAB
			Else
				Help(" ",1,"HELP","NCODTABF","Codigo da tabela não encontrado",3,1)
				_lRet := .f.
			Endif
		Endif
	Else
		_cDscOri := CriaVar("Z2_DESCTAB",.F.)
	Endif
	RestArea(_aArea)
Return(_lRet)

//-------------------------------------------------------------------------
Static Function IniCopPol(_cTabOri, _cTabDes)

	Local _aArea := GetArea()
	If !Empty(_cTabOri) .and. !Empty(_cTabDes)
		ExecApag(cFilAnt,_cTabDes)
		ExecCop(cFilAnt, _cTabOri, cFilAnt, _cTabDes)
	Endif
	oDlgCOP:End()
	RestArea(_aArea)
Return
//-----------------------------------------------------
Static Function ExecCop(cFilOri,_cTabOri, cFilDes, _cTabDes)

	Local _aArea := GetArea()
	Local _aSZ4	 := {}
	Local _aSZ5	 := {}
	Local _aSZ6	 := {}
	Local cFilSav := cFilAnt
	Local _lCop	 := .F.
	Local nZ2Frete := 0
	Local nZ2Icmfr := 0
	Local nZ2despf := 0
	Local j		   :=1
	cFilAnt := cFilOri
	//Adicionado por Walter para copiar as informações da SZ2
	dbSelectArea("SZ2")
	dbSetOrder(1)
	dbSeek(xFilial("SZ2")+_cTabOri)
	nZ2Frete := SZ2->Z2_FRETE
	nZ2Icmfr := SZ2->Z2_ICMFRT
	nZ2despf := SZ2->Z2_DESPFIN
	//Fim
	dbSelectArea("SZ4")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabOri)
	While !Eof() .and. xFilial("SZ4")+_cTabOri == SZ4->(Z4_FILIAL+Z4_CODTAB)
		aadd(_aSZ4,Array(FCount()))
		For j:=1 to FCount()
			If Alltrim(FieldName(j)) == "Z4_CODTAB"
				_aSZ4[Len(_aSZ4),j] := _cTabDes
			ElseIf Alltrim(FieldName(j)) == "Z4_FILIAL"
				_aSZ4[Len(_aSZ4),j] := cFilDes
			Else
				_aSZ4[Len(_aSZ4),j] := SZ4->&(FieldName(j))
			Endif
		Next
		dbSkip()
	End
	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabOri)
	While !Eof() .and. xFilial("SZ5")+_cTabOri == SZ5->(Z5_FILIAL+Z5_CODTAB)
		aadd(_aSZ5,Array(FCount()))
		For j:=1 to FCount()
			If Alltrim(FieldName(j)) == "Z5_CODTAB"
				_aSZ5[Len(_aSZ5),j] := _cTabDes
			ElseIf Alltrim(FieldName(j)) == "Z5_FILIAL"
				_aSZ5[Len(_aSZ5),j] := cFilDes
			Else
				_aSZ5[Len(_aSZ5),j] := SZ5->&(FieldName(j))
			Endif
		Next
		dbSkip()
	End
	dbSelectArea("SZ6")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabOri)
	While !Eof() .and. xFilial("SZ6")+_cTabOri == SZ6->(Z6_FILIAL+Z6_CODTAB)
		aadd(_aSZ6,Array(FCount()))
		For j:=1 to FCount()
			If Alltrim(FieldName(j)) == "Z6_CODTAB"
				_aSZ6[Len(_aSZ6),j] := _cTabDes
			ElseIf Alltrim(FieldName(j)) == "Z6_FILIAL"
				_aSZ6[Len(_aSZ6),j] := cFilDes
			Else
				_aSZ6[Len(_aSZ6),j] := SZ6->&(FieldName(j))
			Endif
		Next
		dbSkip()
	End

	cFilAnt := cFilDes

	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+_cTabDes)
		_lCop := .T.
		RecLock("SZ2",.F.)
		SZ2->Z2_FRETE   := nZ2Frete
		SZ2->Z2_ICMFRT  := nZ2Icmfr
		SZ2->Z2_DESPFIN := nZ2despf
		MsUnlock()
	Endif

	cFilAnt := cFilOri

	If Len(_aSZ4) > 0
		For nT:=1 to Len(_aSZ4)
			RecLock("SZ4",.T.)
			For j:=1 to FCount()
				FieldPut(j,_aSZ4[nT,j])
			Next
			MsUnLock()
		Next
		_lCop := .T.
	Endif
	If Len(_aSZ5) > 0
		For nT:=1 to Len(_aSZ5)
			RecLock("SZ5",.T.)
			For j:=1 to FCount()
				FieldPut(j,_aSZ5[nT,j])
			Next
			MsUnLock()
		Next
		_lCop := .T.
	Endif
	If Len(_aSZ6) > 0
		For nT:=1 to Len(_aSZ6)
			RecLock("SZ6",.T.)
			For j:=1 to FCount()
				FieldPut(j,_aSZ6[nT,j])
			Next
			MsUnLock()
		Next
		_lCop := .T.
	Endif
	cFilAnt := cFilSav
	RestArea(_aArea)
Return(_lCop)
//-------------------------------------------------------------------------------
Static Function ExecApag(_cFilDes, _cTabDes)

	Local _aArea := GetArea()
	Local _cFilSav := cFilAnt
	cFilAnt := _cFilDes
	dbSelectArea("SZ4")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabDes)
	While !Eof() .and. xFilial("SZ4")+_cTabDes == SZ4->(Z4_FILIAL+Z4_CODTAB)
		RecLock("SZ4",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabDes)
	While !Eof() .and. xFilial("SZ5")+_cTabDes == SZ5->(Z5_FILIAL+Z5_CODTAB)
		RecLock("SZ5",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	dbSelectArea("SZ6")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabDes)
	While !Eof() .and. xFilial("SZ6")+_cTabDes == SZ6->(Z6_FILIAL+Z6_CODTAB)
		RecLock("SZ6",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	cFilAnt := _cFilSav
	RestArea(_aArea)
Return
//-------------------------------------------------------------------------------------------------------------------------------------
Static Function SelGetFil(_cFileTab)

Local cEmpresa 	:= cEmpAnt
Local cTitulo	:= ""
Local MvParDef	:= ""
Local nI 		:= 0
Local aArea 	:= GetArea() 					 // Salva Alias Anterior
Local aSit		:= {}
Local aSit_Ant	:= {}
Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local aFilAtu	:= {}
Local lPESetFil := ExistBlock("CTSETFIL")
Local lGestao	:= AdmGetGest()
Local lFWCompany := FindFunction( "FWCompany" )
Local cEmpFil 	:= " "
Local cUnFil	:= " "
Local nTamEmp	:= 0
Local nTamUn	:= 0
Local lOk		:= .T.
Local aColsBrw  := {}
Local aColsSX3 := {}
Local nT	   := 1
Local cOpcaoSel  := "0"
Local bOk 		:= {||((cOpcaoSel := "1", oBrowse:Deactivate(), oDlgAB:End()))}
Local bCancel	:= {||((cOpcaoSel := "0", oBrowse:Deactivate(), oDlgAB:End()))}
Local cAliasBrw  := GetNextAlias()
Local cMarcaBrw  := "X"
Local oBrowse

Default lTodasFil 	:= .F.
Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
Default lHlp		:= .T.
Default cAlias		:= ""
Default lExibTela	:= .T.


/*
Defines do SM0
SM0_GRPEMP  // Código do grupo de empresas
SM0_CODFIL  // Código da filial contendo todos os níveis (Emp/UN/Fil)
SM0_EMPRESA // Código da empresa
SM0_UNIDNEG // Código da unidade de negócio
SM0_FILIAL  // Código da filial
SM0_NOME    // Nome da filial
SM0_NOMRED  // Nome reduzido da filial
SM0_SIZEFIL // Tamanho do campo filial
SM0_LEIAUTE // Leiaute do grupo de empresas
SM0_EMPOK   // Empresa autorizada
SM0_GRPEMP  // Código do grupo de empresas
SM0_USEROK  // Usuário tem permissão para usar a empresa/filial
SM0_RECNO   // Recno da filial no SIGAMAT
SM0_LEIAEMP // Leiaute da empresa (EE)
SM0_LEIAUN  // Leiaute da unidade de negócio (UU)
SM0_LEIAFIL // Leiaute da filial (FFFF)
SM0_STATUS  // Status da filial (0=Liberada para manutenção,1=Bloqueada para manutenção)
SM0_NOMECOM // Nome Comercial
SM0_CGC     // CGC
SM0_DESCEMP // Descricao da Empresa
SM0_DESCUN  // Descricao da Unidade
SM0_DESCGRP // Descricao do Grupo
*/

//Caso o Alias não seja passado, traz as filiais que o usuario tem acesso (modo padrao)
lSohFilEmp := IF(Empty(cAlias),.F.,lSohFilEmp)
lSohFilUN  := IF(Empty(cAlias),.F.,lSohFilUn) .And. lSohFilEmp

//Caso use gestão corporativa , busca o codigo da empresa dentro do M0_CODFIL
//Em caso contrario, , traz as filiais que o usuario tem acesso (modo padrao)
cEmpFil := IIF(lGestao .and. lFwCompany, FWCompany(cAlias)," ")
cUnFil  := IIF(lGestao .and. lFwCompany, FWUnitBusiness(cAlias)," ")

//Tamanho do codigo da filial
nTamEmp := Len(cEmpFil)
nTamUn  := Len(cUnFil)

If lDefTop
	If !IsBlind()
		PswOrder(1)
		If PswSeek( __cUserID, .T. )

			aSit		:= {}
			aFilNome	:= {}
			aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )
			If Len( aFilAtu ) > 0
				cTxtAux := IIF(lGestao,"Empresa/Unidade/Filial de ","Filiais de ")
				cTitulo := cTxtAux + AllTrim( aFilAtu[6] )
			EndIf

			// Adiciona as filiais que o usuario tem permissão
			For nInc := 1 To Len( aSM0 )
				//DEFINES da SMO encontra-se no arquivo FWCommand.CH
				//Na função FWLoadSM0(), ela retorna na posicao [SM0_USEROK] se esta filial é válida para o user
				If (aSM0[nInc][SM0_GRPEMP] == cEmpAnt .And. ((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )

					//Verificacao se as filiais a serem apresentadas serao
					//Apenas as filiais da empresa conrrente (M0_CODFIL)
					If lGestao .and. lFwCompany .and. lSohFilEmp
						//Se for exclusivo para empresa
						If !Empty(cEmpFil)
							lOk := IIf(cEmpFil == Substr(aSM0[nInc][2],1,nTamEmp),.T.,.F.)
							/*
							Verifica se as filiais devem pertencer a mesma unidade de negocio da filial corrente*/
							If lOk .And. lSohFilUn
								//Se for exclusivo para unidade de negocio
								If !Empty(cUnFil)
									lOk := IIf(cUnFil == Substr(aSM0[nInc][2],nTamEmp + 1,nTamUn),.T.,.F.)
								Endif
							Endif
						Else
							//Se for tudo compartilhado, traz apenas a filial corrente
							lOk := IIf(cFilAnt == aSM0[nInc][SM0_CODFIL],.T.,.F.)
						Endif
					Endif

					If lOk
						AAdd(aSit, {aSM0[nInc][SM0_CODFIL],aSM0[nInc][SM0_NOMRED],Transform(aSM0[nInc][SM0_CGC],PesqPict("SA1","A1_CGC"))})
						MvParDef += aSM0[nInc][SM0_CODFIL]
						nI++
					Endif

					//ponto de entrada para usuario poder manipular as filiais selecionada
					//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
					If lPESetFil
						aSit_Ant := aClone(aSit)
						aSit := ExecBlock("CTSETFIL",.F.,.F.,{aSit,nI})

						If aSit == NIL .Or. Empty(aSit) .Or. !Valtype( "aSit" ) <> "A"
							aSit := aClone(aSit_Ant)
						EndIf
						nI := Len(aSit)
					EndIf

				Endif

			Next
			If Len( aSit ) <= 0
				// Se não tem permissão ou ocorreu erro nos dados do usuario, pego a filial corrente.
				Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
				MvParDef := aFilAtu[2]
				nI++
			EndIf
		EndIf
	Endif
Else
	Help("  ",1,"ADMFILTOP",,"Função disponível apenas para ambientes TopConnect",1,0) //"Função disponível apenas para ambientes TopConnect"
EndIf
If Len(aSit) > 0
	/*Coluna de marcação*/             AAdd(aColsBrw,{"TP_MARK"   	,"C",          1,          0})
	BuscarSX3("B1_FILIAL",,aColsSX3);  AAdd(aColsBrw,{"TP_FILIAL"	,"C",aColsSX3[3],aColsSX3[4]})
	/*Coluna de marcação*/             AAdd(aColsBrw,{"TP_NOMEF"   	,"C",TAMSX3("Z2_DESCTAB")[1],          0})
	/*Coluna de marcação*/             AAdd(aColsBrw,{"TP_ARQ"   	,"C",TAMSX3("Z2_ARQUIVO")[1],          0})

	criaTabTmp(aColsBrw,{'TP_FILIAL','TP_NOMEF'},cAliasBrw)

	For nT:=1 to Len(aSit)
		RecLock(cAliasBrw,.T.)
		(cAliasBrw)->TP_FILIAL	:= aSit[nT,1]
		(cAliasBrw)->TP_NOMEF	:= aSit[nT,2]
		(cAliasBrw)->TP_ARQ		:= _cFileTab
		MsUnlock(cAliasBrw)
	Next
	(cAliasBrw)->(DbGoTop())
	aColsBrw := {}
	AAdd(aColsBrw,{BuscarSX3('B1_FILIAL' ,,aColsSX3), "TP_FILIAL" ,'C',aColsSX3[3],aColsSX3[4],aColsSX3[2],1,,.F.,,,,,,,,1})
	AAdd(aColsBrw,{"Nome Filial"				    , "TP_NOMEF"  ,'C',15		  ,0		  ," "	      ,1,,.F.,,,,,,,,1})
	AAdd(aColsBrw,{"Arquivo"				        , "TP_ARQ"    ,'C',60		  ,0		  ," "	      ,1,,.F.,,,,,,,,1})

	aSit := {}
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlgAB TITLE "Selecione Filial" From 300,0 to 800,1000 OF oMainWnd PIXEL
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Selecione Filial")
	oBrowse:SetFields(aColsBrw)
	oBrowse:SetOwner(oDlgAB)
	oBrowse:SetMenuDef("")
	oBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
	oBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parâmetros
	oBrowse:SetTemporary(.T.)
	oBrowse:SetAlias(cAliasBrw)
	oBrowse:SetFieldMark("TP_MARK")
	oBrowse:SetMark(cMarcaBrw,cAliasBrw,"TP_MARK")
	oBrowse:SetAllMark({||BrwAllMark(oBrowse, cMarcaBrw, cAliasBrw)})
	oBrowse:SetAfterMark({||Iif(oBrowse:IsMark(),InFoFile(cAliasBrw),"")})
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:Activate()
	ACTIVATE MSDIALOg oDlgAB CENTERED
	If cOpcaoSel == "1"
		dbSelectArea(cAliasBrw)
		dbGotop()
		While !Eof()
			If (cAliasBrw)->TP_MARK == "X"
				aadd(aSit, {(cAliasBrw)->TP_FILIAL, (cAliasBrw)->TP_ARQ})
			Endif
			dbSkip()
		End
	Endif
	delTabTmp(cAliasBrw)
Endif
RestArea(aArea)
Return(aSit)
//----------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function InFoFile(cAliasBrw)

Local cPosBarra := RAT("\", Alltrim((cAliasBrw)->TP_ARQ))
Local cArq  := Substr((cAliasBrw)->TP_ARQ,1,cPosBarra)
Local cFile := cGetFile("Arquivo de Texto" + "|*.csv|" + "Todos Arquivos" + "|*.*","Selecione o arquivo para importação",0,cArq,.T.,nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ) ,.F.)//"Arquivo de Texto","Todos Arquivos","Selecione o arquivo para importação"
If !Empty(cFile)
	RecLock(cAliasBrw,.F.)
	Replace TP_ARQ with cFile
	MsUnLock()
Endif
Return
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} BrwAllMark
Função para marcar ou desmarcar a seleção no bowse
@type function
@version 1.12.27
@author ricardo rotta
@since 13/06/2020
@return return_type, return_description
/*/
Static Function BrwAllMark(oBrowse, cMarcaBrw, cAliasBrw)
Local aAreaAnt  := GetArea()
lMarkAll := !lMarkAll
(cAliasBrw)->(DbGoTop())
While (cAliasBrw)->(!Eof())
	RecLock(cAliasBrw,.F.)
	(cAliasBrw)->TP_MARK := Iif(lMarkAll,cMarcaBrw," ")
	MsUnlock()
	(cAliasBrw)->(DbSkip())
EndDo
(cAliasBrw)->(DbGoTop())
RestArea(aAreaAnt)
oBrowse:Refresh()
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADMGETFIL ºAutor  ³Rafael Gama         º Data ³  05/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adm_Opcoes de pesquisa por filiais existente no cadastro deº±±
±±º          ³ empresa                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Retorno   ³ aSelFil(Contem todas as filiais da empresa selecionada)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ SIGACTB, SIGAATF, SIGAFIN                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PRCGETFIL(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp, lExibTela)

	Local cEmpresa 	:= cEmpAnt
	Local cTitulo	:= ""
	Local MvPar		:= ""
	Local MvParDef	:= ""
	Local nI 		:= 0
	Local aArea 	:= GetArea() 					 // Salva Alias Anterior
	Local nReg	    := 0
	Local nSit		:= 0
	Local aSit		:= {}
	Local aSit_Ant	:= {}
	Local aFil 		:= {}
	Local nTamFil	:= Len(xFilial("CT2"))
	Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
	Local nInc		:= 0
	Local aSM0		:= AdmAbreSM0()
	Local aFilAtu	:= {}
	Local lPEGetFil := ExistBlock("CTGETFIL")
	Local lPESetFil := ExistBlock("CTSETFIL")
	Local aFil_Ant
	Local lGestao	:= AdmGetGest()
	Local lFWCompany := FindFunction( "FWCompany" )
	Local cEmpFil 	:= " "
	Local cUnFil	:= " "
	Local nTamEmp	:= 0
	Local nTamUn	:= 0
	Local lOk		:= .T.

	Default lTodasFil 	:= .F.
	Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
	Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
	Default lHlp		:= .T.
	Default cAlias		:= ""
	Default lExibTela	:= .T.

	/*
	Defines do SM0
	SM0_GRPEMP  // Código do grupo de empresas
	SM0_CODFIL  // Código da filial contendo todos os níveis (Emp/UN/Fil)
	SM0_EMPRESA // Código da empresa
	SM0_UNIDNEG // Código da unidade de negócio
	SM0_FILIAL  // Código da filial
	SM0_NOME    // Nome da filial
	SM0_NOMRED  // Nome reduzido da filial
	SM0_SIZEFIL // Tamanho do campo filial
	SM0_LEIAUTE // Leiaute do grupo de empresas
	SM0_EMPOK   // Empresa autorizada
	SM0_GRPEMP  // Código do grupo de empresas
	SM0_USEROK  // Usuário tem permissão para usar a empresa/filial
	SM0_RECNO   // Recno da filial no SIGAMAT
	SM0_LEIAEMP // Leiaute da empresa (EE)
	SM0_LEIAUN  // Leiaute da unidade de negócio (UU)
	SM0_LEIAFIL // Leiaute da filial (FFFF)
	SM0_STATUS  // Status da filial (0=Liberada para manutenção,1=Bloqueada para manutenção)
	SM0_NOMECOM // Nome Comercial
	SM0_CGC     // CGC
	SM0_DESCEMP // Descricao da Empresa
	SM0_DESCUN  // Descricao da Unidade
	SM0_DESCGRP // Descricao do Grupo
	*/

	//Caso o Alias não seja passado, traz as filiais que o usuario tem acesso (modo padrao)
	lSohFilEmp := IF(Empty(cAlias),.F.,lSohFilEmp)
	lSohFilUN  := IF(Empty(cAlias),.F.,lSohFilUn) .And. lSohFilEmp

	//Caso use gestão corporativa , busca o codigo da empresa dentro do M0_CODFIL
	//Em caso contrario, , traz as filiais que o usuario tem acesso (modo padrao)
	cEmpFil := IIF(lGestao .and. lFwCompany, FWCompany(cAlias)," ")
	cUnFil  := IIF(lGestao .and. lFwCompany, FWUnitBusiness(cAlias)," ")

	//Tamanho do codigo da filial
	nTamEmp := Len(cEmpFil)
	nTamUn  := Len(cUnFil)

	If lDefTop
		If !IsBlind()
			PswOrder(1)
			If PswSeek( __cUserID, .T. )

				aSit		:= {}
				aFilNome	:= {}
				aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )
				If Len( aFilAtu ) > 0
					cTxtAux := IIF(lGestao,"Empresa/Unidade/Filial de ","Filiais de ")
					cTitulo := cTxtAux + AllTrim( aFilAtu[6] )
				EndIf

				// Adiciona as filiais que o usuario tem permissão
				For nInc := 1 To Len( aSM0 )
					//DEFINES da SMO encontra-se no arquivo FWCommand.CH
					//Na função FWLoadSM0(), ela retorna na posicao [SM0_USEROK] se esta filial é válida para o user
					If (aSM0[nInc][SM0_GRPEMP] == cEmpAnt .And. ((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )

						//Verificacao se as filiais a serem apresentadas serao
						//Apenas as filiais da empresa conrrente (M0_CODFIL)
						If lGestao .and. lFwCompany .and. lSohFilEmp
							//Se for exclusivo para empresa
							If !Empty(cEmpFil)
								lOk := IIf(cEmpFil == Substr(aSM0[nInc][2],1,nTamEmp),.T.,.F.)
								/*
								Verifica se as filiais devem pertencer a mesma unidade de negocio da filial corrente*/
								If lOk .And. lSohFilUn
									//Se for exclusivo para unidade de negocio
									If !Empty(cUnFil)
										lOk := IIf(cUnFil == Substr(aSM0[nInc][2],nTamEmp + 1,nTamUn),.T.,.F.)
									Endif
								Endif
							Else
								//Se for tudo compartilhado, traz apenas a filial corrente
								lOk := IIf(cFilAnt == aSM0[nInc][SM0_CODFIL],.T.,.F.)
							Endif
						Endif

						If lOk
							AAdd(aSit, {aSM0[nInc][SM0_CODFIL],aSM0[nInc][SM0_NOMRED],Transform(aSM0[nInc][SM0_CGC],PesqPict("SA1","A1_CGC"))})
							MvParDef += aSM0[nInc][SM0_CODFIL]
							nI++
						Endif

						//ponto de entrada para usuario poder manipular as filiais selecionada
						//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
						If lPESetFil
							aSit_Ant := aClone(aSit)
							aSit := ExecBlock("CTSETFIL",.F.,.F.,{aSit,nI})

							If aSit == NIL .Or. Empty(aSit) .Or. !Valtype( "aSit" ) <> "A"
								aSit := aClone(aSit_Ant)
							EndIf
							nI := Len(aSit)
						EndIf

					Endif

				Next
				If Len( aSit ) <= 0
					// Se não tem permissão ou ocorreu erro nos dados do usuario, pego a filial corrente.
					Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
					MvParDef := aFilAtu[2]
					nI++
				EndIf
			EndIf
			If lExibTela
				aFil := {}
				If ExistBlock("ADMSELFIL")	// PE para substituir a AdmOpcoes
					aFil := ExecBlock("ADMSELFIL",.F.,.F.,{cTitulo,aSit,MvParDef,nTamFil})
				ElseIf AdmOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)  // Chama funcao Adm_Opcoes
					nSit := 1
					For nReg := 1 To len(mvpar) Step nTamFil  // Acumula as filiais num vetor
						If SubSTR(mvpar, nReg, nTamFil) <> Replicate("*",nTamFil)
							AADD(aFil, SubSTR(mvpar, nReg, nTamFil) )
						endif
						nSit++
					next
					If Empty(aFil) .And. lHlp
						Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma filial",1,0)		//"Por favor selecionar pelo menos uma filial"
					EndIF

					If Len(aFil) == Len(aSit)
						lTodasFil := .T.
					EndIf
				Endif
			Else
				aFil := aClone(aSit)
			EndIf
		Else
			aFil := {cFilAnt}
		EndIf

		//ponto de entrada para usuario poder manipular as filiais selecionada
		//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
		If lExibTela .and. lPEGetFil
			aFil_Ant := aClone(aFil)
			aFil := ExecBlock("CTGETFIL",.F.,.F.,{aFil})
			If aFil == NIL .Or. Empty(aFil)
				aFil := aClone(aFil_Ant)
			EndIf
		EndIf

	Else
		Help("  ",1,"ADMFILTOP",,"Função disponível apenas para ambientes TopConnect",1,0) //"Função disponível apenas para ambientes TopConnect"
	EndIf

	RestArea(aArea)

Return(aFil)
//------------------------------------------------------------------------------
//
User Function MPosFor(_cMarca)

	Local _aArea	:= GetArea()
	Local _aCodForn := {}
	dbSelectArea("ZZM")
	dbSetOrder(2)
	//Ita - 19/08/2020 - Evitar erro de execução ao não encontraar marca na tabela ZZM - If dbSeek(xFilial("ZZM")+_cMarca)
	If dbSeek(xFilial("ZZM")+PadR(_cMarca,5))
		_cCodForn := ZZM->ZZM_FORNEC
		_cLoja    := ZZM->ZZM_LOJA
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+_cCodForn+_cLoja)
			aadd(_aCodForn, {SA2->A2_COD, SA2->A2_LOJA})
		Endif
	Endif
	RestArea(_aArea)
Return(_aCodForn)

//-------------------------------------------------------------------
//Ita - 08/09/2020 - Controle da Data de Simulação - Static Function EFETTAB(cAliasTMP)
Static Function EFETTAB(cAliasTMP,_dDtSimul)

	//MBrChgLoop(.F.) //Desabilita a chamada da tela de inclusão novamente.
	Local _aArea := GetArea()
	If MsgYesNo("Confirma a Efetivação da Tabela ?","Atencao")
		//Ita - 08/09/2020 - Controle da Data de Simulação - MsgRun( "Processando Tabela de Preço..." ,, {||	lRet := AGERATAB(cAliasTMP) } ) //"Processando revisão do Projeto..."
		MsgRun( "Processando Tabela de Preço..." ,, {||	lRet := AGERATAB(cAliasTMP,_dDtSimul) } ) //"Processando revisão do Projeto..."
		dbSelectArea("SZ2")
		RecLock("SZ2",.F.)
		Replace Z2_STATUS with '2'
		Replace Z2_DTEFETI with If(!Empty(_dDtSimul),_dDtSimul,dDataBase) //Ita - 08/09/2020 - Controle da Data da Simulação - Replace Z2_DTEFETI with dDataBase
		Replace Z2_USUEFET with __cUserID
		MsUnLock()
	EndIf
	RestArea(_aArea)
Return

//---------------------------------------------------------------------
//Ita - 08/09/2020 - Controle da Data de Simulação - Static Function AGERATAB(cAliasTMP)
Static Function AGERATAB(cAliasTMP,_dDtSimul)

	Local _aArea := GetArea()
	Local _cCodTab  := SZ2->Z2_CODTAB
	Local _cMarca 	:= SZ2->Z2_MARCA
	Local _cCodDA0	:= SuperGetMv("AN_TABPRC",.F.,"100")
	Local _lGrava := .T.
	Local _lNewDa1 := .F.
	//MsgInfo("AGERATAB - 26/08/2020")
	//Walter - 17/01/19
	DbSelectArea(cAliasTMP)
	DbSetOrder(1)
	DbGoTop()
	While (cAliasTMP)->(!Eof())
		//Ita - 26/08/2020 - If (cAliasTMP)->TMP_OK == "X" .and. (cAliasTMP)->TMP_PRCVEN > 0
		If (cAliasTMP)->TMP_OK == _oBrwClass:Mark() //.and. (cAliasTMP)->TMP_PRCVEN > 0
			//MsgInfo("Entrei no If aki") 
			dbSelectArea("DA0")
			dbSetOrder(1)
			If !dbSeek(xFilial()+_cCodDA0)
				RecLock("DA0",.T.)
				Replace DA0_FILIAL with xFilial("DA0"),;
				DA0_CODTAB with _cCodDA0,;
				DA0_DESCRI with "Tabela Generica",;
				DA0_DATDE  with If(!Empty(_dDtSimul),_dDtSimul,dDataBase),; //Ita - 08/09/2020 - Controle da Data de Simulação - DA0_DATDE  with dDataBase,;
				DA0_HORADE with Time(),;
				DA0_HORATE with "23:59",;
				DA0_TPHORA with "1",;
				DA0_ATIVO with "1"
				MsUnLock()
			Endif
			_lGrava := .T.
			dbSelectArea("DA1")
			dbOrderNickName("DA1VG")
			//MsgInfo("Função AGERATAB - Irei pesquisar no SD1 - Chave: ["+xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD+"]")
			//Ita - 26/08/2020 - If dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_COD)
			If dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD)
			
			    //MsgInfo("Função AGERATAB - Localizei item no DA1")
				aDtVig := {}
				_lNewDa1 := .F.
				_dUltVig := Ctod("  /  /  ")
				_cCt:=1
				//Ita - 26/08/2020 - While !Eof() .and. xFilial("DA1")+_cCodDA0+(cAliasTMP)->TMP_COD == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO)
				While !Eof() .and. xFilial("DA1")+_cCodDA0+(cAliasTMP)->TMP_PROD == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO)
				    //MsgInfo("Função AGERATAB - Dentro do While ... "+cValToChar(_cCt))
					aadd(aDtVig, DA1->DA1_DATVIG)
					_dUltVig := DA1->DA1_DATVIG
					_dDtcompara := If(!Empty(_dDtSimul),_dDtSimul,dDataBase)//Ita - 08/09/2020 - Controle da Data de Simulação
					////Ita - 08/09/2020 - Controle da Data de Simulação - If dDataBase > DA1->DA1_DATVIG
					If _dDtcompara > DA1->DA1_DATVIG
						_lNewDa1 := .T.
						//MsgInfo("Função AGERATAB - dDataBase: "+DTOC(dDataBase)+" É MAIOR QUE A VIGENCIA DA TABELA: "+DTOC(DA1->DA1_DATVIG)+",VOU CRIAR UMA NOVA")
					Endif
					dbSkip()
					_cCt ++
				End
				If _lNewDa1
					dbSelectArea("DA1")
					dbOrderNickName("DA1VG")
					//MsgInfo("Função AGERATAB - Vou pesquisar na DA1 - Chave: ["+xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD+"]")
					//Ita - 26/08/2020 - dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_COD)
					dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD)
					_xCt := 1
					//While !Eof() .and. xFilial("DA1")+_cCodDA0+(cAliasTMP)->TMP_COD == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO)
					While !Eof() .and. xFilial("DA1")+_cCodDA0+(cAliasTMP)->TMP_PROD == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO)
                        //MsgInfo("Função AGERATAB - Dentro do While 2 - "+cValToChar(_xCt))
						If DA1->DA1_XTABSQ <= "2"
							RecLock("DA1", .F.)
							Replace DA1_XTABSQ with Soma1(DA1_XTABSQ)
							MsUnLock()
							//MsgInfo("Função AGERATAB - DA1->DA1_XTABSQ <= 2 Agora DA1->DA1_XTABSQ = "+DA1->DA1_XTABSQ)
						Else
							RecLock("DA1", .F.)
							dbDelete()
							MsUnLock()
							//MsgInfo("Função AGERATAB - DA1->DA1_XTABSQ > 2 - Vou excluir tabela")
						Endif
						dbSkip()
						_xCt ++
					End
				Else
				    //MsgInfo("Função AGERATAB - _lNewDa1 é false - Vou pesquisaar com nova chave: ["+xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD+Dtos(_dUltVig)+"]")
					//Ita - 26/08/2020 - If dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_COD+Dtos(_dUltVig))
					If dbSeek(xFilial()+_cCodDA0+(cAliasTMP)->TMP_PROD+Dtos(_dUltVig))
						_lGrava := .F.
						RecLock("DA1",.F.)
						Replace DA1_PRCVEN with (cAliasTMP)->TMP_PRCVEN
						Replace DA1_XPRCBR with (cAliasTMP)->TMP_PRCBRT
						Replace DA1_XPRCLI with (cAliasTMP)->TMP_PRCVEN
						Replace DA1_XPRCRE with (cAliasTMP)->TMP_PRCREP
						Replace DA1_XDESCV with (cAliasTMP)->TMP_DESC
						Replace DA1_XMARGEM with (cAliasTMP)->TMP_MARGEM
						Replace DA1_XFATOR with (cAliasTMP)->TMP_FATOR
						MsUnLock()
						//MsgInfo("Função AGERATAB - Encontrei DA1 - Alterei DA1_XPRCRE para: "+cValToChar(DA1->DA1_XPRCRE))
					Endif
				Endif
			//Else
			   //MsgInfo("Não achei item na DA1")
			Endif
			If _lGrava
				RecLock("DA1",.T.)
				Replace DA1_FILIAL with xFilial("DA1")
				Replace DA1_ITEM with Soma1(ProxItem(_cCodDA0, (cAliasTMP)->TMP_PROD))
				Replace DA1_CODTAB with _cCodDA0
				Replace DA1_CODPRO with (cAliasTMP)->TMP_PROD //Ita - 26/08/2020 - (cAliasTMP)->TMP_COD
				Replace DA1_PRCVEN with (cAliasTMP)->TMP_PRCVEN
				Replace DA1_ATIVO  with "1"
				Replace DA1_TPOPER with "4"
				Replace DA1_QTDLOT with 999999.99
				Replace DA1_INDLOT with "000000000999999.99"
				Replace DA1_MOEDA with 1
				Replace DA1_DATVIG with If(!Empty(_dDtSimul),_dDtSimul,dDataBase)
				Replace DA1_XLETRA with (cAliasTMP)->TMP_LETRA 
				Replace DA1_XCDTAB with _cCodTab
				Replace DA1_XTABSQ with "1"
				Replace DA1_XPRCBR with (cAliasTMP)->TMP_PRCBRT //Ita - 01/09/2020 akita
				Replace DA1_XPRCLI with (cAliasTMP)->TMP_PRCVEN
				Replace DA1_XPRCRE with (cAliasTMP)->TMP_PRCREP
				Replace DA1_XDESCV with (cAliasTMP)->TMP_DESC
				Replace DA1_XMARGEM with (cAliasTMP)->TMP_MARGEM
				Replace DA1_XFATOR with (cAliasTMP)->TMP_FATOR
				Replace DA1_XMARCA with _cMarca
				MsUnLock()
				//MsgInfo("_lGrava é TRUE - INCLUIU DA1")
			Endif
		Endif
		(cAliasTMP)->(DbSkip())
	EndDo
	//Ita - 10/08/2020 - oDlgNJK:End()
	RestArea(_aArea)
	MsgInfo("Atualização realizada com sucesso!")//Ita - 26/08/2020
	_oBrwClass:DeActivate() //Ita - 26/08/2020

Return
//-------------------------------------------------------------------
Static Function AN_COPPOL

	Local cPerg	:= "AN_COPPOL"
	Local aSelFil 	:= {}
	//Local _aRotAnt	:= aRotina
	Local aSize := MsAdvSize()
	Local aObjects := {{100,100,.t.,.t.}}
	Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local aPosObj  := MsObjSize(aInfo,aObjects)
	Local cAliasSZ2 := "QRYSZ2"
	Local _cTabOri  := SZ2->Z2_CODTAB
	Local _cFilOri  := SZ2->Z2_FILIAL
	Local aStruct 	:= {}
	Local cIndTmp
	Local cChave	:= ''
	Local _oCopTab
	Local aColumns	:= {}
	Local nRet 		:= 0
	Local bOk 		:= {||((nRet := 1, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local bCancel	:= {||((nRet := 0, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local oFnt2S  	:= TFont():New("Arial",6 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
	Local cAliasTMP  := GetNextAlias()
	Local _lCop		:= .F.
	Local _aFilCop  := {}
	Local _lContinua := ApMsgYesNo("Deseja aplicar a política?")//.T.//.F.
	Private lEnd := .F.
	/*
	dbSelectArea("SZ4")
	dbSetOrder(1)
	If dbSeek(_cFilOri+_cTabOri)
	_lContinua := .T.
	Endif
	If !_lContinua
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If dbSeek(_cFilOri+_cTabOri)
	_lContinua := .T.
	Endif
	Endif
	If !_lContinua
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(_cFilOri+_cTabOri)
	_lContinua := .T.
	Endif
	Endif
	*/
	If _lContinua
		Gera_SX1(cPerg)
		If Pergunte(cPerg,.T.)
			_cMarca := mv_par01
			_dDtImp	:= mv_par02

			Aadd(aStruct, {"TMP_OK","C",1,0})
			Aadd(aStruct, {"TMP_FILIAL"	,"C"	,TamSx3("Z2_FILIAL")[1]		,0, "Filial"})
			aAdd(aStruct, {"TMP_NOMFIL"	,"C"	,30							,0, "Nome"			, 150, " " })
			Aadd(aStruct, {"TMP_CODTAB"	,"C"	,TamSx3("Z2_CODTAB")[1]		,0, "Tabela"})
			aAdd(aStruct, {"TMP_DESCTA" ,"C"	,TamSx3("Z2_DESCTAB")[1]	,0, "Descrição"		, 150, " " })
			aAdd(aStruct, {"TMP_FORNEC"	,"C"	,TamSx3("Z2_MARCA")[1]		,0, "Fornecedor"	, 100, " " })
			aAdd(aStruct, {"TMP_DTINCL"	,"D"	,TamSx3("Z2_DATA")[1]		,0, "Dt. Inclusão"	, 080,  " " })

			If(_oCopTab <> NIL)
				_oCopTab:Delete()
				_oCopTab := NIL
			EndIf

			_oCopTab := FwTemporaryTable():New(cAliasTmp)
			_oCopTab:SetFields(aStruct)
			_oCopTab:AddIndex("1",{"TMP_FILIAL","TMP_CODTAB"})
			_oCopTab:Create()

			dbSelectArea("SZ2")
			_cQuery := "SELECT * "
			_cQuery += "FROM " + RetSqlName("SZ2")
			_cQuery += " WHERE Z2_MARCA = '" + _cMarca + "'"
			_cQuery += " AND Z2_DATA = '" + Dtos(_dDtImp) + "'"
			_cQuery += " AND D_E_L_E_T_ = ' '"
			_cQuery += " ORDER BY Z2_FILIAL, Z2_CODTAB"
			_cQuery := ChangeQuery(_cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ2,.T.,.T.)
			dbSelectArea(cAliasSZ2)
			While !Eof()
//				If (cAliasSZ2)->Z2_FILIAL <> _cFilOri
					RecLock(cAliasTMP,.T.)
					(cAliasTMP)->TMP_FILIAL := (cAliasSZ2)->Z2_FILIAL
					(cAliasTMP)->TMP_NOMFIL := Posicione("SM0",1,cEmpAnt+(cAliasSZ2)->Z2_FILIAL,"M0_FILIAL")
					(cAliasTMP)->TMP_CODTAB := (cAliasSZ2)->Z2_CODTAB
					(cAliasTMP)->TMP_DESCTAB:= (cAliasSZ2)->Z2_DESCTAB
					(cAliasTMP)->TMP_FORNEC := (cAliasSZ2)->Z2_MARCA
					(cAliasTMP)->TMP_DTINCL := Stod((cAliasSZ2)->Z2_DATA)
					MsUnlock()
//				Endif
				dbSelectArea(cAliasSZ2)
				(cAliasSZ2)->(dbSkip())
			End
			dbSelectArea(cAliasSZ2)
			dbCloseArea()
			dbSelectArea(cAliasTMP)
			dbGotop()
			If !Eof() .and. !Bof()
				//----------------MarkBrowse----------------------------------------------------
				For nX := 1 To Len(aStruct)
					If	!aStruct[nX][1] $ "TMP_OK"
						AAdd(aColumns,FWBrwColumn():New())
						aColumns[Len(aColumns)]:lAutosize:=.T.
						aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
						aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
						//			aColumns[Len(aColumns)]:SetSize(aStruct[nX][6])
						aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
						//			aColumns[Len(aColumns)]:SetPicture(aStruct[nX][7])
						If aStruct[nX][2] $ "N/D"
							aColumns[Len(aColumns)]:nAlign := 3
						Endif
					EndIf
				Next nX
				aSize := MsAdvSize(,.F.,400)
				DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela Destino" From 300,0 to 800,1000 OF oMainWnd PIXEL
				oMrkBrowse:= FWMarkBrowse():New()
				oMrkBrowse:SetFieldMark("TMP_OK")
				oMrkBrowse:SetOwner(oDlgAB)
				oMrkBrowse:SetAlias(cAliasTMP)
				oMrkBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
				oMrkBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parâmetros
				//			oMrkBrowse:bMark     := {||}
				oMrkBrowse:bMark     := {||ItmMark(oMrkBrowse,cAliasTMP)}
				oMrkBrowse:bAllMark  := {||COPMark(oMrkBrowse,cAliasTMP)}
				oMrkBrowse:SetDescription("Marque as tabelas que receberão a Politica Comercial selecionada")
				oMrkBrowse:SetColumns(aColumns)
				oMrkBrowse:SetMenuDef("")
				oMrkBrowse:Activate()
				ACTIVATE MSDIALOg oDlgAB CENTERED
			End
			If nRet == 1
				dbSelectArea(cAliasTMP)
				dbGotop()
				While !Eof()
					If (cAliasTMP)->TMP_OK == oMrkBrowse:Mark()
						ExecApag((cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB)
						_lCop := ExecCop(_cFilOri,_cTabOri, (cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB)
						If _lCop
							aadd(_aFilCop, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB})
						Endif
					Endif
					dbSelectArea(cAliasTMP)
					dbSkip()
				End
				If Len(_aFilCop) > 0
					_lRet := MsgYesNo("Politica Comercial copiada, deseja Aplicar a Politica agora ?","Atencao")
					If _lRet
						Processa( {|lEnd| APLICPOL(_aFilCop, @lEnd)}, "Aguarde...","Aplicando Politica Comercial", .T. )
					Endif
				Endif
			Endif
			(cAliasTMP)->(DbCloseArea())
			MSErase(cAliasTMP+GetDbExtension())
			MSErase(cAliasTMP+OrdBagExt())
		Endif
	Else
		Help(" ",1,"HELP","SEMPOLIT","Não encontrado Politica Comercial para a Lista de Preço: " + SZ2->Z2_FILIAL + " / " + SZ2->Z2_CODTAB,3,1)
	Endif
Return
// Função para aplicar a politica comercial
//-----------------------------------------------------------------------------------------------------------------------------------

Static Function APLICPOL(_aFilPol, lEnd, _cCodEsp)

	Local _aArea     := GetArea()
	Local _cFilSav   := cFilAnt
	Local nH         := 1
	Local cTabPrc
	Local cAliasSZ3  := "QRYSZ3"
	Local _aCodForn  := {}
	Local _aRetCus   := {}
	Local cCodDA0    := SuperGetMv("AN_TABPRC",.F.,"100")
	Local _nValFret  := 0
	Local _nVlrFin   := 0
	Local _nICMF     := 0
	Local aCodMestre := {}
	Local cCodMestre := " "
	Local nValIPI    := 0
	Local nValICM    := 0
	Local nValICMRET := 0
	Local nBaseSol   := 0
	Local nTotcSOL   := 0
	Default _cCodEsp := CriaVar("B1_COD",.F.)
	ProcRegua(Len(_aFilPol))
	For nH:=1 to Len(_aFilPol)
		If lEnd
			Exit
		Endif
		IncProc("Calculando Descontos informados....Filial: " + cFilAnt)
		ProcessMessage() // Minimiza o efeito de 'congelamento' da aplicação
		cFilAnt	:= _aFilPol[nH,1]
		u_RetDescTot(_aFilPol[nH,2])
	Next
	For nH:=1 to Len(_aFilPol)
		If lEnd
			Exit
		Endif
		cFilAnt		:= _aFilPol[nH,1]
		cTabPrc		:= _aFilPol[nH,2]
		aCodMestre  := {}
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial()+cTabPrc)
			_cCodMarc := SZ2->Z2_MARCA
			_nFrete	  := SZ2->Z2_FRETE
			_nIcmFret := SZ2->Z2_ICMFRT
			_nDespFin := SZ2->Z2_DESPFIN
			_aCodForn := {}
			aadd(_aCodForn, {SZ2->Z2_CODFORN, SZ2->Z2_LOJA})
			dbSelectArea("SZ3")
			_cQuery := "SELECT COUNT(*) REGIST "
			_cQuery += "FROM " + RetSqlName("SZ3")
			_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
			_cQuery += " AND Z3_CODTAB = '" + cTabPrc + "'"
			_cQuery += " AND Z3_COD <> ' '"
			If !Empty(_cCodEsp)
				_cQuery += " AND Z3_COD = '" + _cCodEsp + "'"
			Endif
			_cQuery += " AND D_E_L_E_T_ = ' '"
			_cQuery := ChangeQuery(_cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ3,.T.,.T.)
			dbSelectArea(cAliasSZ3)
			_nCount := (cAliasSZ3)->REGIST
			dbSelectArea(cAliasSZ3)
			dbCloseArea()
			_cQuery := "SELECT R_E_C_N_O_ RECSZ3 "
			_cQuery += "FROM " + RetSqlName("SZ3")
			_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
			_cQuery += " AND Z3_CODTAB = '" + cTabPrc + "'"
			_cQuery += " AND Z3_COD <> ' '"
			If !Empty(_cCodEsp)
				_cQuery += " AND Z3_COD = '" + _cCodEsp + "'"
			Endif
			_cQuery += " AND D_E_L_E_T_ = ' '"
			_cQuery := ChangeQuery(_cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ3,.T.,.T.)
			dbSelectArea(cAliasSZ3)
			ProcRegua(_nCount)
			While !Eof() .And. !lEnd
				IncProc("Aplicando politica comercial....Filial: " + cFilAnt)
				ProcessMessage() // Minimiza o efeito de 'congelamento' da aplicação
				_nRecnoZ3	:= (cAliasSZ3)->RECSZ3
				dbSelectArea("SZ3")
				dbGoto(_nRecnoZ3)
				cProduto   := SZ3->Z3_CODPRIN //SZ3->Z3_COD//Italo Maciel 21/07/2020 - alterado para considerar o código principal
				_nPrcTot   := SZ3->Z3_PRCLIQ
				_cTES      := SZ3->Z3_TES
				_nAliqIPI  := SZ3->Z3_IPI
				_nAliqICMS := SZ3->Z3_ICMS
				_cLetra    := u_BuscTabVig(cProduto)[1]
				_nMarKup   := SZ3->Z3_MARKUP
				_nDescVen  := SZ3->Z3_DESCVEN
				_nPrcVen   := SZ3->Z3_PRCVEN
				nValIPI    := SZ3->Z3_VLRIPI
				nValICM    := SZ3->Z3_VLRICM
				nValICMRET := SZ3->Z3_VLRST
				nBaseSol   := SZ3->Z3_BASEST
				nMargMK	   := SZ3->Z3_MARGEM
				nTotcSOL   := SZ3->Z3_VLRTOT
				nMargem	   := SZ3->Z3_MVAST
				_nMarKup   := 0
				_nFator    := 1
				nPos       := 0
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial()+cProduto)
					cCodMestre := SB1->B1_XALTIMP
					If !Empty(cCodMestre)
						nPos := aScan(aCodMestre,{|x| x[1]+x[2] == cFilAnt + cCodMestre})
						If nPos == 0
							aadd(aCodMestre, {cFilAnt, cCodMestre})
						Endif
					Endif
					If nPos == 0
						//{_cTES, _nCusto, nValPS2, nValCF2, _nICMRET, _nValFret, _nVlrFin, _nICMF, _nValIPI, _nValICM, _nICMRET, nBaseSol, nMargem}
						_aRetCus := u_AN320CalcT(cProduto, _aCodForn, _nPrcTot, @_cTES, _nAliqIPI, _nAliqICMS, _nFrete, _nIcmFret, _nDespFin)
						_cTES    := _aRetCus[1]
						If !Empty(_cTES)
							_nCusto  := _aRetCus[2]
							_nPisCOF := _aRetCus[3] + _aRetCus[4]
							_nICMRET := _aRetCus[5]
						Else
							_nCusto  := 0
							_nPisCOF := 0
							_nICMRET := 0
						Endif
						_cMonoFas  := IIF(SB1->B1_XMONO=="S","S","N")
						_cLinhaSB1 := SB1->B1_XLINHA
						_nMargem   := 0
						_nDescVen  := 0
						_nValFret  := _aRetCus[6]
						_nVlrFin   := _aRetCus[7]
						_nICMF     := _aRetCus[8]
						nValIPI    := _aRetCus[9]
						nValICM    := _aRetCus[10]
						nValICMRET := _aRetCus[11]
						nBaseSol   := _aRetCus[12]
						nMargem    := _aRetCus[13]
						nTotcSOL   := _nPrcTot + nValIPI + nValICMRET
						//{ _nMarKup, _nLetra, _nFator, _nPrcVen, _nMargem}
						_aRetPrc   := u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nCusto)
						_nMarKup   := _aRetPrc[1]
						_nLetra    := _aRetPrc[2]
						_nFator    := _aRetPrc[3]
						_nPrcVen   := _aRetPrc[4]
						_nMargKup  := _aRetPrc[5]

						_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_TES = '" + _cTES + "', Z3_PISCOF = " + Alltrim(Str(_nPisCOF)) + ", Z3_PRCREP = " + Alltrim(Str(_nCusto))
						_cQuery += ", Z3_ICMSRET = " + Alltrim(Str(_nICMRET))
						_cQuery += ", Z3_GRTRIB = '" + SB1->B1_GRTRIB + "'"
						_cQuery += ", Z3_LETRA = '" + _cLetra + "'"
						_cQuery += ", Z3_MARGEM = " + Alltrim(Str(_nMargKup))
						_cQuery += ", Z3_DESCVEN = " + Alltrim(Str(_nDescVen))
						_cQuery += ", Z3_FATOR = " + Alltrim(Str(_nLetra))
						_cQuery += ", Z3_INDMARK = " + Alltrim(Str(_nFator))
						_cQuery += ", Z3_PRCVEN = " + Alltrim(Str(_nPrcVen))
						_cQuery += ", Z3_VALFRET = " + Alltrim(Str(_nValFret))
						_cQuery += ", Z3_VALDFIN = " + Alltrim(Str(_nVlrFin))
						_cQuery += ", Z3_FRICMS = " + Alltrim(Str(_nICMF))
						_cQuery += ", Z3_VLRIPI = " + Alltrim(Str(nValIPI))
						_cQuery += ", Z3_VLRICM = " + Alltrim(Str(nValICM))
						_cQuery += ", Z3_VLRST = " + Alltrim(Str(nValICMRET))
						_cQuery += ", Z3_BASEST = " + Alltrim(Str(nBaseSol))
						_cQuery += ", Z3_MARKUP = " + Alltrim(Str(_nMargKup))
						_cQuery += ", Z3_VLRTOT = " + Alltrim(Str(nTotcSOL))
						_cQuery += ", Z3_MVAST = " + Alltrim(Str(nMargem))
						_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
						If Empty(cCodMestre)
							_cQuery += " AND R_E_C_N_O_ = " + Alltrim(Str(_nRecnoZ3))
						Else
							_cQuery += " AND Z3_CODTAB = '" + cTabPrc + "'"
							_cQuery += " AND D_E_L_E_T_ = ' '"
							_cQuery += " AND Z3_CODPRIN IN (SELECT B1_COD FROM " + RetSqlName("SB1") + " SB1 "
							_cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'"
							_cQuery += " AND B1_XALTIMP = '" + cCodMestre + "'"
							_cQuery += " AND SB1.D_E_L_E_T_ = ' ')"
						Endif
						nErrQry := TCSqlExec( _cQuery )
						If nErrQry < 0
							Final("Erro na aplicação da política ", TCSQLError() + _cQuery)
						Endif
					EndIF
				Endif
				dbSelectArea(cAliasSZ3)
				dbSkip()
			End
			dbSelectArea(cAliasSZ3)
			dbCloseArea()
			dbSelectArea("SZ2")
			RecLock("SZ2",.F.)
			Replace Z2_STATUS with "1"
			MsUnLock()
		Endif
	Next
	cFilAnt := _cFilSav
	RestArea(_aArea)
Return
//------------------------------------------------------------------------------------------------------------------------------------
// Retorna Desconto informado nas tabelas SZ4, SZ5 e SZ6

User Function RetDescTot(cCodTab, lGravaZ3)

Local _aArea     := GetArea()
Local aDesconto  := {}
Local _nBase     := 100
Local nMoeda     := 1
Local _lZerDesc  := .T.
Local _aDescZ6   := PolDescZ6(cCodTab)
Local _aDescZ4   := PolDescZ4(cCodTab)
Local _aDescZ5   := PolDescZ5(cCodTab,_aDescZ4)
Local aDesconto  := {}
Local _lZerDesc  := .T.
Local nI         := 1
Default lGravaZ3 := .T.
////////////////
/// Ita - 25/04/2019 - Considerar desconto 0(zero)
For nI:= 1 to Len(_aDescZ4)
	If lEnd
		Exit
	Endif
	aadd(aDesconto, _aDescZ4[nI,5])
	//aadd(_aDescZ6, {_cNacImp, _nRet})
	//aadd(_aDescZ4, {_cGrupo, _cSubGrp, _cNacImp, _cTpDesc, _nRet})
	/*
	If Alltrim(_aDescZ4[nI,1]) == "FILTR"
	cpare:=""
	EndIf
	*/
	If _aDescZ4[nI,4] == "A" .and. Len(_aDescZ6) >= 0
		_cNacImp := _aDescZ4[nI,3]
		_nPosSZ6 := aScan(_aDescZ6,{|x| x[1] == "A"})
		If _nPosSZ6 == 0
			_nPosSZ6 := aScan(_aDescZ6,{|x| x[1] == _cNacImp})
		Endif
		If _nPosSZ6 > 0
			aadd(aDesconto, _aDescZ6[_nPosSZ6,2])
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
			_nRet := _nBase - _nDesc
			//Ita - 27/04/2019 - _aDescZ4[nI,5] := _nRet
			_aDescZ4[nI,5] := _nRet
			//_aDescZ4[nI,5] := ( _aDescZ4[nI,5] + _aDescZ6[_nPosSZ6,2] ) //Ita - 27/04/2019
			//_aDescZ4[nI,5] := ( _aDescZ4[nI,5] + _nRet ) //Ita - 30/04/2019 - Considerar Cascata também no desconto acumulado.
		Endif
	Endif
	aDesconto	:= {}
Next
aDesconto	:= {}
For nI:= 1 to Len(_aDescZ5)
	If lEnd
		Exit
	Endif
	aadd(aDesconto, _aDescZ5[nI,3])
	If _aDescZ5[nI,2] == "A" .and. (Len(_aDescZ6) > 0 .or. Len(_aDescZ5) >= 0) //Len(_aDescZ5) > 0)
		_cCodRef := _aDescZ5[nI,1]
		dbSelectArea("SZ3")
		dbSetOrder(1)
		If dbSeek(xFilial()+cCodTab+_cCodRef)
			_cNacImp := SZ3->Z3_NACIMP
			_cGrupo  := SZ3->Z3_GRUPO
			_cSubGrp := SZ3->Z3_SUBGRP
			_nPosSZ6 := aScan(_aDescZ6,{|x| x[1] == "A"})
			_nPosSZ4 := aScan(_aDescZ4,{|x| x[1]+x[2]+x[3] == _cGrupo+_cSubGrp+"A"})
			If _nPosSZ6 == 0
				_nPosSZ6 := aScan(_aDescZ6,{|x| x[1] == _cNacImp})
			Endif
			If _nPosSZ4 == 0
				_nPosSZ4 := aScan(_aDescZ4,{|x| x[1]+x[2]+x[3] == _cGrupo+_cSubGrp+_cNacImp})
			Endif
			If _nPosSZ4 > 0
				aadd(aDesconto, _aDescZ4[_nPosSZ4,5])  // Já foi aplicado o desconto Geral sobre o valor original
			Else
				If _nPosSZ6 > 0
					aadd(aDesconto, _aDescZ6[_nPosSZ6,2])
				Endif
			Endif
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
			_nRet := _nBase - _nDesc
			_aDescZ5[nI,3] := _nRet
		Endif
	EndIf
	aDesconto	:= {}
Next nI
// Grava os descontos calculados na base
If lGravaZ3
	For nI:= 1 to Len(_aDescZ6)
		If lEnd
			Exit
		Endif
		_cNacImp := _aDescZ6[nI,1]
		_nDesc	 := _aDescZ6[nI,2]
		If _lZerDesc .and. _nDesc > 0
			_lZerDesc := .F.
		Endif
		_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_DESCONT = " + Alltrim(Str(_nDesc))
		_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cQuery += " AND Z3_CODTAB = '" + cCodTab + "'"
		If _cNacImp <> "A"
			_cQuery += " AND Z3_NACIMP = '" + _cNacImp + "'"
		Endif
		_cQuery += " AND D_E_L_E_T_ = ' '"
		nErrQry := TCSqlExec( _cQuery )
	Next
	For nI:= 1 to Len(_aDescZ4)
		If lEnd
			Exit
		Endif
		_cGrupo  := _aDescZ4[nI,1]
		_cSubGrp := _aDescZ4[nI,2]
		_cNacImp := _aDescZ4[nI,3]
		_nDesc	 := _aDescZ4[nI,5]
		If _lZerDesc .and. _nDesc > 0
			_lZerDesc := .F.
		Endif
		_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_DESCONT = " + Alltrim(Str(_nDesc))
		_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cQuery += " AND Z3_CODTAB = '" + cCodTab + "'"
		If _cNacImp <> "A"
			_cQuery += " AND Z3_NACIMP = '" + _cNacImp + "'"
		Endif
		_cQuery += " AND Z3_GRUPO = '" + _cGrupo + "'"
		_cQuery += " AND Z3_SUBGRP = '" + _cSubGrp + "'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		nErrQry := TCSqlExec( _cQuery )
	Next
	For nI:= 1 to Len(_aDescZ5)
		If lEnd
			Exit
		Endif
		_cCodRef := _aDescZ5[nI,1]
		_nDesc	 := _aDescZ5[nI,3]
		If _lZerDesc .and. _nDesc > 0
			_lZerDesc := .F.
		Endif
		_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_DESCONT = " + Alltrim(Str(_nDesc))
		_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cQuery += " AND Z3_CODTAB = '" + cCodTab + "'"
		_cQuery += " AND Z3_CODREF = '" + _cCodRef + "'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		nErrQry := TCSqlExec( _cQuery )
	Next
	If _lZerDesc	// Zera descontos anteriores
		_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_DESCONT = 0"
		_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
		_cQuery += " AND Z3_CODTAB = '" + cCodTab + "'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		nErrQry := TCSqlExec( _cQuery )
	Endif
	_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET Z3_PRCLIQ = ROUND(Z3_PRCBRT - (Z3_PRCBRT * Z3_DESCONT/100), 2) "
	_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
	_cQuery += " AND Z3_CODTAB = '" + cCodTab + "'"
	_cQuery += " AND D_E_L_E_T_ = ' '"
	nErrQry := TCSqlExec( _cQuery )
Endif
Return({_aDescZ5, _aDescZ4, _aDescZ6})

//-----------------------------------------------------------------------------------------------------------------------------------
// Função calcular desconto na SZ6 das politicas gravadas
Static Function PolDescZ6(_cTabela)

	Local _aArea := GetArea()
	Local _nRet  := 0
	Local _nBase := 100
	Local nMoeda   := 1
	Local aDesconto := {}
	Local _aDescZ6 := {}
	dbSelectArea("SZ6")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabela)
	While !Eof() .and. xFilial("SZ6")+_cTabela == SZ6->(Z6_FILIAL+Z6_CODTAB)
		_cNacImp := SZ6->Z6_NACIMP
		_nRet  := 0
		aDesconto := {}
		For nY:=1 to 10
			_cCZ6	:= "Z6_DESC" + StrZero(nY,2)
			If SZ6->&(_cCZ6) >= 0
				aadd(aDesconto, SZ6->&(_cCZ6))
			Endif
		Next
		If Len(aDesconto) >= 0
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
			_nRet := _nBase - _nDesc
		Endif
		If _nRet >= 0
			aadd(_aDescZ6, {_cNacImp, _nRet})
		Endif
		dbSelectArea("SZ6")
		dbSkip()
	End
	RestArea(_aArea)
Return(_aDescZ6)
// Função calcular desconto na SZ6 das politicas gravadas
//-----------------------------------------------------------------------------------------------------------------------------------

Static Function PolDescZ4(_cTabela)

	Local _aArea    := GetArea()
	Local _nRet     := 0
	Local _nBase    := 100
	Local nMoeda    := 1
	Local aDesconto := {}
	Local _aDescZ4  := {}
	Local nY        := 1
	////////////////
	/// Ita - 25/04/2019 - Considerar desconto 0(zero)
	dbSelectArea("SZ4")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabela)
	While !Eof() .and. xFilial("SZ4")+_cTabela == SZ4->(Z4_FILIAL+Z4_CODTAB)
		_cNacImp := SZ4->Z4_NACIMP
		_cGrupo  := SZ4->Z4_GRUPO
		_cSubGrp := SZ4->Z4_SUBGRP
		_cTpDesc := SZ4->Z4_TPDESC
		_nRet  := 0
		aDesconto := {}
		For nY:=1 to 10
			_cCZ4	:= "Z4_DESC" + StrZero(nY,2)
			If SZ4->&(_cCZ4) >= 0 //Ita - 25/04/2019 - SZ4->&(_cCZ4) > 0
				aadd(aDesconto, SZ4->&(_cCZ4))
			Endif
		Next
		If Len(aDesconto) >= 0 //Ita - 25/04/2019 - Len(aDesconto) > 0
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
			 _nRet := _nBase - _nDesc
		Endif
		If _nRet >= 0 //Ita - 25/04/2019 - _nRet > 0
			aadd(_aDescZ4, {_cGrupo, _cSubGrp, _cNacImp, _cTpDesc, _nRet})
		Endif
		dbSelectArea("SZ4")
		dbSkip()
	End
	RestArea(_aArea)
Return(_aDescZ4)

// Função calcular desconto na SZ6 das politicas gravadas
//-----------------------------------------------------------------------------------------------------------------------------------

Static Function PolDescZ5(_cTabela,_aDescZ4)

	Local _aArea := GetArea()
	Local _nRet  := 0
	Local _nBase := 100
	Local nMoeda   := 1
	Local aDesconto := {}
	Local _aDescZ5 := {}
	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbSeek(xFilial()+_cTabela)
	While !Eof() .and. xFilial("SZ5")+_cTabela == SZ5->(Z5_FILIAL+Z5_CODTAB)
		_cTpDesc := SZ5->Z5_TPDESC
		_cCodRef := SZ5->Z5_CODREF
		_nRet  := 0
		aDesconto := {}
		////////////////
		/// Ita - 25/04/2019 - Considerar desconto 0(zero)
		For nY:=1 to 10
			_cCZ5	:= "Z5_DESC" + StrZero(nY,2)
			If SZ5->&(_cCZ5) >= 0 //SZ5->&(_cCZ5) > 0
				aadd(aDesconto, SZ5->&(_cCZ5))
			Endif
		Next
		If Len(aDesconto) >= 0
			_nDesc := FtDescCab(_nBase,aDesconto,nMoeda)
			_nRet := _nBase - _nDesc
		Endif
/*********************************************************/
		/////////////////////////////////////////////////////////////////////////////////
		/// Ita - 25/04/2019 - considerar desconto 0(zero)
		///                    e desconto substitutivo do Grupo, 
		///                    caso o tipo de desconto do produto não seja substitutivo.
		//_cCodRef := _aDescZ5[nI,1]
		/*
		If Alltrim(_cCodRef) == "098645070235N"
		   cpare:=""
		EndIf
		//xArea:= GetArea()
	    cFilTab  := SZ2->Z2_FILIAL
	    _cCodTab := SZ2->Z2_CODTAB
	    DbSelectArea("SZ3")
	    DbSetOrder(1)
	    If MsSeek(cFilTab+_cCodTab+_cCodRef)		
	       //_cGrupo  := Posicione("SZ3",1,cFilTab+_cCodTab+_cCodRef,"Z3_GRUPO")
	       //_cSubGrp := Posicione("SZ3",1,cFilTab+_cCodTab+_cCodRef,"Z3_SUBGRP")
	       _cGrupo  := SZ3->Z3_GRUPO
	       _cSubGrp := SZ3->Z3_SUBGRP
	    EndIf
		//RestArea(xArea)

		If Empty(_cSubGrp)
		   _Z4GrpPs := aScan(_aDescZ4,{|x| x[1] == _cGrupo})
		Else
		   _Z4GrpPs := aScan(_aDescZ4,{|x| x[1]+x[2] == _cGrupo+_cSubGrp})
		EndIf

		If _Z4GrpPs > 0
		   //aadd(_aDescZ5, {_cCodRef, _cTpDesc, _nRet})
		   //aadd(_aDescZ4, {_cGrupo, _cSubGrp, _cNacImp, _cTpDesc, _nRet})
		   If Alltrim(_aDescZ4[_Z4GrpPs,4]) == "S" .And. Alltrim(_cTpDesc) <> "S"
		      //_aDescZ5[nI,3] := _aDescZ4[_Z4GrpPs,5]   //Substituir
		      _nPcPrd := _nRet
		      _nPcGrp := _aDescZ4[_Z4GrpPs,5] 
		      _nRet := (_nPcPrd + _nPcGrp)  //Acumular com o desconto já cadastrado por grupo
		   EndIf
		EndIf						
		*/
/**********************************************************/
		If _nRet >= 0
			aadd(_aDescZ5, {_cCodRef, _cTpDesc, _nRet})
		Endif
		dbSelectArea("SZ5")
		dbSkip()
	End
	RestArea(_aArea)
Return(_aDescZ5)

/*/{Protheus.doc} SIAFMark
Função para marcar todos os itens da markbrowse.
@author William Matos Gundim Junior
@since 26/11/2014
@version 1.0
/*/
Static Function COPMark(oMrkBrowse,cArqTrab)

	(cArqTrab)->(dbGoTop())
	While !(cArqTrab)->(Eof())
		RecLock(cArqTrab, .F.)
		If (cArqTrab)->TMP_OK == oMrkBrowse:Mark()
			(cArqTrab)->TMP_OK := ' '
		Else
			(cArqTrab)->TMP_OK := oMrkBrowse:Mark()
		EndIf
		MsUnlock()
		(cArqTrab)->(DbSkip())
	End

	oMrkBrowse:oBrowse:Refresh(.T.)
Return .T.
// Função para marcar no browse
//----------------------------------------------------------------------------------------------
Static Function ItmMark(oMrkBrowse,cArqTrab)

	Local nLinha	:= oMrkBrowse:At()
	/*
	RecLock(cArqTrab, .F.)

	If (cArqTrab)->TMP_OK == oMrkBrowse:Mark()
	(cArqTrab)->TMP_OK := oMrkBrowse:Mark()
	Else
	(cArqTrab)->TMP_OK := ' '
	EndIf
	MsUnlock()
	*/
	//oMrkBrowse:Goto(nLinha,.T.)
	//oMrkBrowse:oBrowse:Refresh(.T.)
Return .T.

//-------------------------------------------------------------------
Static Function Gera_SX1(_cPerg)

	Local _aArea := GetArea()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	_cPerg := PADR(_cPerg,10)

	If Alltrim(_cPerg) == "SIMUL01"
		aAdd(aRegs,{_cPerg,"01","Data Simulacao ?","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	ElseIf Alltrim(_cPerg) == "SIMUL02"
		aAdd(aRegs,{_cPerg,"01","Variacao de ?"	  ,"","","mv_ch1","N",08,02,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{_cPerg,"02","Variacao Ate ?"  ,"","","mv_ch2","N",08,02,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Else
		aAdd(aRegs,{_cPerg,"01","Da Marca           ?","","","mv_ch1","C",05,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{_cPerg,"02","Data Importacao de ?","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{_cPerg,"03","Data Importacao Ate?","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
		If Alltrim(_cPerg) == "ANCALCPR2"
			aAdd(aRegs,{_cPerg,"04","Data Efetivacao ?","","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Endif
	Endif

	For i:=1 to Len(aRegs)
		If !dbSeek(_cPerg+aRegs[i,2])
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

//---------------------------------------------------------------------------------------------------
Static Function AN_EXCPRV()

	Local _aArea := GetArea()
	Local _cCodTab := SZ2->Z2_CODTAB
	Local _cMarca  := SZ2->Z2_MARCA
	Local _aCodForn := Array(1,2)
	Local _aFilCop  := {}
	Local aSelFil 	:= {}
	Local aSize := MsAdvSize()
	Local aObjects := {{100,100,.t.,.t.}}
	Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local aPosObj  := MsObjSize(aInfo,aObjects)
	Local cAliasSZ2 := "QRYSZ2"
	Local aStruct 	:= {}
	Local cIndTmp
	Local cChave	:= ''
	Local _oCopTab
	Local aColumns	:= {}
	Local nRet 		:= 0
	Local bOk 		:= {||((nRet := 1, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local bCancel	:= {||((nRet := 0, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local oFnt2S  	:= TFont():New("Arial",6 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
	Local cAliasTMP  := GetNextAlias()
	Local _lCop		:= .F.
	Local _lContinua := .F.
	Local cPerg := "AN_CALCPR"
	Local _cMarca
	Local _dDtImp
	Local _dDtAte
	Local _cMarcaSel := ""

	Gera_SX1(cPerg)
	If Pergunte(cPerg,.T.)

		_cMarca := Alltrim(mv_par01)
		_dDtImp	:= mv_par02
		_dDtAte	:= mv_par03

		If !Empty(_cMarca)
			While !Empty(_cMarca)
				nPos := AT(";",_cMarca)
				If Empty(_cMarcaSel)
					_cMarcaSel := "('"
				Else
					_cMarcaSel += ",'"
				Endif
				If nPos > 0
					_cMarcaSel += Alltrim(Substr(_cMarca,1,nPos-1)) + "'"
					_cMarca := Substr(_cMarca,nPos+1)
				Else
					_cMarcaSel += Alltrim(_cMarca) + "'"
					Exit
				Endif
			End
			_cMarcaSel += ")"
		Endif

		Aadd(aStruct, {"TMP_OK","C",1,0})
		Aadd(aStruct, {"TMP_FILIAL"	,"C"	,TamSx3("Z2_FILIAL")[1]		,0, "Filial"})
		aAdd(aStruct, {"TMP_NOMFIL"	,"C"	,30							,0, "Nome"			, 150, " " })
		Aadd(aStruct, {"TMP_CODTAB"	,"C"	,TamSx3("Z2_CODTAB")[1]		,0, "Tabela"})
		aAdd(aStruct, {"TMP_DESCTA" ,"C"	,TamSx3("Z2_DESCTAB")[1]	,0, "Descrição"		, 150, " " })
		aAdd(aStruct, {"TMP_FORNEC"	,"C"	,TamSx3("Z2_MARCA")[1]		,0, "Fornecedor"	, 100, " " })
		aAdd(aStruct, {"TMP_DTINCL"	,"D"	,TamSx3("Z2_DATA")[1]		,0, "Dt. Inclusão"	, 080,  " " })

		If(_oCopTab <> NIL)
			_oCopTab:Delete()
			_oCopTab := NIL
		EndIf

		_oCopTab := FwTemporaryTable():New(cAliasTmp)
		_oCopTab:SetFields(aStruct)
		//_oCopTab:AddIndex("1",{"TMP_FILIAL"}, {"TMP_CODTAB"})
		_oCopTab:AddIndex("1",{"TMP_FORNEC", "TMP_DTINCL", "TMP_FILIAL"}) //Alterado por solicitação de Eduardo, 28/02/2019 - Walter
		_oCopTab:Create()

		dbSelectArea("SZ2")
		_cQuery := "SELECT * "
		_cQuery += "FROM " + RetSqlName("SZ2")
		_cQuery += " WHERE Z2_DATA >= '" + Dtos(_dDtImp) + "'"
		_cQuery += " AND Z2_DATA   <= '" + Dtos(_dDtAte) + "'"
		If !Empty(_cMarcaSel)
			_cQuery += " AND Z2_MARCA IN " + _cMarcaSel
		Endif
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY Z2_FILIAL, Z2_CODTAB"
		_cQuery := ChangeQuery(_cQuery)
		MemoWrite("D:\Protheus\querys\exclist.txt",_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ2,.T.,.T.)
		dbSelectArea(cAliasSZ2)
		While !Eof()
			RecLock(cAliasTMP,.T.)
			(cAliasTMP)->TMP_FILIAL := (cAliasSZ2)->Z2_FILIAL
			(cAliasTMP)->TMP_NOMFIL := Posicione("SM0",1,cEmpAnt+(cAliasSZ2)->Z2_FILIAL,"M0_FILIAL")
			(cAliasTMP)->TMP_CODTAB := (cAliasSZ2)->Z2_CODTAB
			(cAliasTMP)->TMP_DESCTAB:= (cAliasSZ2)->Z2_DESCTAB
			(cAliasTMP)->TMP_FORNEC := (cAliasSZ2)->Z2_MARCA
			(cAliasTMP)->TMP_DTINCL := Stod((cAliasSZ2)->Z2_DATA)
			MsUnlock()
			dbSelectArea(cAliasSZ2)
			(cAliasSZ2)->(dbSkip())
		End
		dbSelectArea(cAliasSZ2)
		dbCloseArea()
		dbSelectArea(cAliasTMP)
		dbGotop()
		If !Eof() .and. !Bof()
			//----------------MarkBrowse----------------------------------------------------
			For nX := 1 To Len(aStruct)
				If	!aStruct[nX][1] $ "TMP_OK"
					AAdd(aColumns,FWBrwColumn():New())
					aColumns[Len(aColumns)]:lAutosize:=.T.
					aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
					aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
					//			aColumns[Len(aColumns)]:SetSize(aStruct[nX][6])
					aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
					//			aColumns[Len(aColumns)]:SetPicture(aStruct[nX][7])
					If aStruct[nX][2] $ "N/D"
						aColumns[Len(aColumns)]:nAlign := 3
					Endif
				EndIf
			Next nX
			aSize := MsAdvSize(,.F.,400)
			DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela para Excluir" From 300,0 to 800,1000 OF oMainWnd PIXEL
			oMrkBrowse:= FWMarkBrowse():New()
			oMrkBrowse:SetFieldMark("TMP_OK")
			oMrkBrowse:SetOwner(oDlgAB)
			oMrkBrowse:SetAlias(cAliasTMP)
			oMrkBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
			oMrkBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parâmetros
			oMrkBrowse:bMark     := {||ItmMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:bAllMark  := {||COPMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:SetDescription("          E X C L U S Ã O   D A   L I S T A   D E   P R E Ç O  - Selecione para Excluir.")
			oMrkBrowse:SetColumns(aColumns)
			oMrkBrowse:SetMenuDef("")
			oMrkBrowse:Activate()
			ACTIVATE MSDIALOg oDlgAB CENTERED
			If nRet == 1
				dbSelectArea(cAliasTMP)
				dbGotop()
				While !Eof()
					If (cAliasTMP)->TMP_OK == oMrkBrowse:Mark()
						aadd(_aFilCop, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB})
					Endif
					dbSkip()
				End
				If Len(_aFilCop) > 0
					If MsgYesNo("Confirma Exclusão ?","Atencao")
						Processa( {|lEnd| EXCLPOL(_aFilCop)}, "Aguarde...","Excluindo Lista de Preço", .T. )
					Endif
				Endif
			Endif
		Endif
	Endif
Return
//----------------------------------------------------------------------
Static Function EXCLPOL(_aFilCop,lExcluiPol)

	Local _aArea := GetArea()
	Local _cFilAtu := cFilAnt
	Local nH, _cCodTab
	Default lExcluiPol  := .T.

	For nH:=1 to Len(_aFilCop)
		_cCodTab	:= _aFilCop[nH,2]
		cFilAnt		:= _aFilCop[nH,1]
//		If fStatTab(_cCodTab) //Ita - 15/09/2020

			_cQuery := "UPDATE " + RetSqlName("SZ2") + " SET  D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
			_cQuery += " WHERE Z2_FILIAL = '" + xFilial("SZ2") + "'"
			_cQuery += " AND Z2_CODTAB = '" + _cCodTab + "'"
//			_cQuery += " AND Z2_STATUS <> '4'" //Ita - 15/09/2020
			_cQuery += " AND D_E_L_E_T_ = ' '"
			nErrQry := TCSqlExec( _cQuery )

			_cQuery := "UPDATE " + RetSqlName("SZ3") + " SET  D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
			_cQuery += " WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'"
			_cQuery += " AND Z3_CODTAB = '" + _cCodTab + "'"
			_cQuery += " AND D_E_L_E_T_ = ' '"
			nErrQry := TCSqlExec( _cQuery )

			dbSelectArea("AC9")
			dbSetOrder(2)
			If dbSeek(xFilial()+"SZ2"+cFilAnt+_cCodTab)
//			    If SZ2->Z2_STATUS <> '4' //Ita - 15/09/2020
					RecLock("SZ2",.F.)
					dbDelete()
					MsUnLock()
//				EndIf
			Endif

			If lExcluiPol
				_cQuery := "UPDATE " + RetSqlName("SZ4") + " SET  D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
				_cQuery += " WHERE Z4_FILIAL = '" + xFilial("SZ4") + "'"
				_cQuery += " AND Z4_CODTAB = '" + _cCodTab + "'"
				_cQuery += " AND D_E_L_E_T_ = ' '"
				nErrQry := TCSqlExec( _cQuery )

				_cQuery := "UPDATE " + RetSqlName("SZ5") + " SET  D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
				_cQuery += " WHERE Z5_FILIAL = '" + xFilial("SZ5") + "'"
				_cQuery += " AND Z5_CODTAB = '" + _cCodTab + "'"
				_cQuery += " AND D_E_L_E_T_ = ' '"
				nErrQry := TCSqlExec( _cQuery )

				_cQuery := "UPDATE " + RetSqlName("SZ6") + " SET  D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
				_cQuery += " WHERE Z6_FILIAL = '" + xFilial("SZ6") + "'"
				_cQuery += " AND Z6_CODTAB = '" + _cCodTab + "'"
				_cQuery += " AND D_E_L_E_T_ = ' '"
				nErrQry := TCSqlExec( _cQuery )
			Endif
//		EndIf
	Next
	cFilAnt := _cFilAtu
	RestArea(_aArea) //Ita - 17/09/2020
Return
//----------------------------------------------------------------------
User Function AN_CALCPRV(nTipo)

	Local _cMarca    := SZ2->Z2_MARCA
	Local _aFilCop   := {}
	Local aSize      := MsAdvSize()
	Local cAliasSZ2  := "QRYSZ2"
	Local aStruct    := {}
	Local _oCopTab
	Local aColumns   := {}
	Local nRet       := 0
	Local bOk        :={||((nRet := 1, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local bCancel    :={||((nRet := 0, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local cAliasTMP  := GetNextAlias()
	Local cPerg
	Local _dDtImp
	Local _dDtAte
	Local _cMarcaSel := ""
	Local nX         := 1
	Local lAplicPol  := .F.
	Private lEnd     := .F.
	//MsgInfo("AN_CALCPRV - Versão 25/08/2020")
	If nTipo == 1 .or. nTipo == 3
		cPerg := "AN_CALCPR"
	ElseIf nTipo == 2
		cPerg := "ANCALCPR2"
	Endif
	Gera_SX1(cPerg)
	///////////////////
	///Ita - 13/08/2020
	///      Força manutenção na empresa/filial que encontra-se antes da chamada
	///      da função de efetivação.
	///      Anteriormente o sistema estava assumindo a filial da matriz
	/////////////////////////////////////////////////////////////////////
	If cEmpAnt <> xEmpAnt
	   cEmpAnt := xEmpAnt
	EndIf
	If cFilAnt <> xFilPos
	   cFilAnt := xFilPos
	EndIf
	//////////////////////
	If Pergunte(cPerg,.T.)
		_cMarca := Alltrim(mv_par01)
		_dDtImp	:= mv_par02
		_dDtAte	:= mv_par03
		If nTipo == 1 .or. nTipo == 3
			_dEfeti := " "
		ElseIf nTipo == 2
			_dEfeti := mv_par04
		Endif
		If !Empty(_cMarca)
			While !Empty(_cMarca)
				nPos := AT(";",_cMarca)
				If Empty(_cMarcaSel)
					_cMarcaSel := "('"
				Else
					_cMarcaSel += ",'"
				Endif
				If nPos > 0
					_cMarcaSel += Alltrim(Substr(_cMarca,1,nPos-1)) + "'"
					_cMarca := Substr(_cMarca,nPos+1)
				Else
					_cMarcaSel += Alltrim(_cMarca) + "'"
					Exit
				Endif
			End
			_cMarcaSel += ")"
		Endif

		Aadd(aStruct, {"TMP_OK","C",1,0})
		Aadd(aStruct, {"TMP_FILIAL"	,"C"	,TamSx3("Z2_FILIAL")[1]		,0, "Filial"})
		aAdd(aStruct, {"TMP_NOMFIL"	,"C"	,30							,0, "Nome"			, 150, " " })
		Aadd(aStruct, {"TMP_CODTAB"	,"C"	,TamSx3("Z2_CODTAB")[1]		,0, "Tabela"})
		aAdd(aStruct, {"TMP_DESCTA" ,"C"	,TamSx3("Z2_DESCTAB")[1]	,0, "Descrição"		, 150, " " })
		aAdd(aStruct, {"TMP_FORNEC"	,"C"	,TamSx3("Z2_MARCA")[1]		,0, "Fornecedor"	, 100, " " })
		aAdd(aStruct, {"TMP_DTINCL"	,"D"	,TamSx3("Z2_DATA")[1]		,0, "Dt. Inclusão"	, 080,  " " })

		If(_oCopTab <> NIL)
			_oCopTab:Delete()
			_oCopTab := NIL
		EndIf

		_oCopTab := FwTemporaryTable():New(cAliasTmp)
		_oCopTab:SetFields(aStruct)
		_oCopTab:AddIndex("1",{"TMP_FILIAL","TMP_CODTAB"})
		_oCopTab:Create()

		dbSelectArea("SZ2")
		_cQuery := "SELECT * "
		_cQuery += "FROM " + RetSqlName("SZ2")
		_cQuery += " WHERE Z2_DATA >= '" + Dtos(_dDtImp) + "'"
		_cQuery += " AND Z2_DATA   <= '" + Dtos(_dDtAte) + "'"
		If !Empty(_cMarcaSel)
			_cQuery += " AND Z2_MARCA IN " + _cMarcaSel
		Endif
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY Z2_FILIAL, Z2_CODTAB"
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ2,.T.,.T.)
		dbSelectArea(cAliasSZ2)
		While !Eof()
			RecLock(cAliasTMP,.T.)
			(cAliasTMP)->TMP_FILIAL := (cAliasSZ2)->Z2_FILIAL
			(cAliasTMP)->TMP_NOMFIL := Posicione("SM0",1,cEmpAnt+(cAliasSZ2)->Z2_FILIAL,"M0_FILIAL")
			(cAliasTMP)->TMP_CODTAB := (cAliasSZ2)->Z2_CODTAB
			(cAliasTMP)->TMP_DESCTAB:= (cAliasSZ2)->Z2_DESCTAB
			(cAliasTMP)->TMP_FORNEC := (cAliasSZ2)->Z2_MARCA
			(cAliasTMP)->TMP_DTINCL := Stod((cAliasSZ2)->Z2_DATA)
			MsUnlock()
			dbSelectArea(cAliasSZ2)
			(cAliasSZ2)->(dbSkip())
		End
		dbSelectArea(cAliasSZ2)
		dbCloseArea()
		dbSelectArea(cAliasTMP)
		dbGotop()
		If !Eof() .and. !Bof()
			//----------------MarkBrowse----------------------------------------------------
			For nX := 1 To Len(aStruct)
				If	!aStruct[nX][1] $ "TMP_OK"
					AAdd(aColumns,FWBrwColumn():New())
					aColumns[Len(aColumns)]:lAutosize:=.T.
					aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
					aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
					//			aColumns[Len(aColumns)]:SetSize(aStruct[nX][6])
					aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
					//			aColumns[Len(aColumns)]:SetPicture(aStruct[nX][7])
					If aStruct[nX][2] $ "N/D"
						aColumns[Len(aColumns)]:nAlign := 3
					Endif
				EndIf
			Next nX
			aSize := MsAdvSize(,.F.,400)
			If nTipo == 1
				DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela para aplicar a Politica Comercial" From 300,0 to 800,1000 OF oMainWnd PIXEL
			ElseIf nTipo == 2
				DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela para ser efetivada" From 300,0 to 800,1000 OF oMainWnd PIXEL
			Else
				DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela para Reprocessar Importação" From 300,0 to 800,1000 OF oMainWnd PIXEL
			EndIf
			oMrkBrowse:= FWMarkBrowse():New()
			oMrkBrowse:SetFieldMark("TMP_OK")
			oMrkBrowse:SetOwner(oDlgAB)
			oMrkBrowse:SetAlias(cAliasTMP)
			oMrkBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
			oMrkBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parâmetros
			oMrkBrowse:bMark     := {||ItmMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:bAllMark  := {||COPMark(oMrkBrowse,cAliasTMP)}
			If nTipo == 1
				oMrkBrowse:SetDescription("Marque as tabelas para aplicar a Politica Comercial")
			ElseIf nTipo == 2
				oMrkBrowse:SetDescription("Selecione Tabela para ser efetivada")
			Else
				oMrkBrowse:SetDescription("Selecione Tabela para reprocessar")
			EndIf
			oMrkBrowse:SetColumns(aColumns)
			oMrkBrowse:SetMenuDef("")
			oMrkBrowse:Activate()
			ACTIVATE MSDIALOg oDlgAB CENTERED
			If nRet == 1
				dbSelectArea(cAliasTMP)
				dbGotop()
				While !Eof()
					If (cAliasTMP)->TMP_OK == oMrkBrowse:Mark()
						aadd(_aFilCop, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB})
					Endif
					dbSkip()
				End
				If Len(_aFilCop) > 0
					If nTipo == 1
						Processa( {|lEnd| APLICPOL(_aFilCop, @lEnd)}, "Aguarde...","Aplicando Politica Comercial", .T. )
					ElseIf nTipo == 2
						FwMsgRun(Nil,{||AN001(_aFilCop, _dEfeti, @lEnd) },Nil,"Aguarde, Efetivando a tabela de preço...")
					Else
						FwMsgRun(Nil,{||AN_REIMPZ3(_aFilCop, @lEnd) }	,Nil	,"Aguarde, Reprocessando a tabela de preço...")
						Processa( {|lEnd| APLICPOL(_aFilCop, @lEnd)}	, "Aguarde...","Aplicando Politica Comercial", .T. )
					EndIF
				Endif
			Endif
		Endif
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA320CalcT³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 30/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o custo de acordo com o calculo dos impostos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA320                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AN320CalcT(cProduto, _aCodForn, _nPrcTot, _cTES, _nAliqIPI, _nAliqICMS, _nFrete, _nIcmFret, _nDespFin)

	Static lValICMS  := NIL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Subtrai valores referentes aos Impostos (ICMS/IPI)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _aArea     := GetArea()
	Local nIcm       := 0,nIpi := 0, nValImp := 0
	Local cClieFor   := _aCodForn[1,1]
	Local cLoja      := _aCodForn[1,2]
	Local aRefImp    := {}
	Local nItem      := 1
	Local _nCusto    := 0
	Local _aCusto    := {}
	Local nValPS2    := 0
	Local nValCF2    := 0
	Local _nICMRET   := 0
	Local _aAreaSB1  := SB1->(GetArea())
	Local _nValFret  := 0
	Local _cTpOper   := SuperGetMv( 'MV_XOPREV' ,.F.,"01")
	Local _nVlrFin   := 0
	Local _nICMF     := 0
	Local _nValIPI   := 0
	Local _nValICM   := 0
	Local nBaseSol   := 0
	Local nMargem	 := 0
	Local _cFilOri   := cFilAnt
	Default _nPrcTot := 100
	Default _cTES    := CriaVar("F4_CODIGO",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a quais impostos devem ser gravados.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cFilAnt == "020104"
		cFilAnt := "020101"
	Endif

	aRefImp := MaFisRelImp('MT100',{"SD1"})
	If Empty(_cTES)
		//	_cTES := MaTesInt(1,_cTpOper,cClieFor,cLoja,"F",cProduto,"C7_TES")
		_cTES := u_ANTesInt(/*nEntSai*/ 1,/*cTpOper*/ _cTpOper, cClieFor,cLoja,"F",cProduto)
	Endif
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+cClieFor+cLoja)
	If !Empty(_cTES)
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial("SF4")+_cTES)
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
			If SB1->(dbSeek(xFilial("SB1") + cProduto))
				MaFisIni(_aCodForn[1,1],_aCodForn[1,2],"F","N",NIL,,,.F.,"SB1")
				MaFisIniLoad(nItem,{	SB1->B1_COD,;		//IT_PRODUTO
				_cTES,; 			//IT_TES
				"",; 				//IT_CODISS
				1,;					//IT_QUANT
				" ",;			 	//IT_NFORI
				" ",; 				//IT_SERIORI
				SB1->(RecNo()),;	//IT_RECNOSB1
				SF4->(RecNo()),;	//IT_RECNOSF4
				0 ,;	 			//IT_RECORI
				" ",;				//IT_LOTECTL
				" " })				//IT_NUMLOTE

				//Trecho adicionado por Walter - 11/02/2019 - Solicitado para desconsiderar a aliquota informada no produto
				If _nAliqIPI == 0
					_nAliqIPI := 0.00001 //Forçando o mais proximo de zero, para não pegar do cadastro de produto
				Endif
				If _nAliqICMS == 0
					_nAliqICMS := 0.00001 //Forçando o mais proximo de zero, para não pegar do cadastro de produto
				Endif
				//Fim

				MaFisLoad("IT_ALIQICM",_nAliqICMS,nItem)
				MaFisLoad("IT_ALIQIPI",_nAliqIPI,nItem)
				MaFisTes(_cTES,SF4->(RecNo()),nItem)
				MaFisLoad("IT_VALMERC",_nPrcTot,nItem)
				MaFisLoad("IT_PRCUNI",_nPrcTot,nItem)
				If _nFrete > 0
					_nTotIPI := Round(_nPrcTot * (1 + (_nAliqIPI/100)),2)
					_nValFret:= Round(_nTotIPI * _nFrete/100,2)
				Endif
				If _nDespFin > 0
					_nTotIPI := Round(_nPrcTot * (1 + (_nAliqIPI/100)),2)
					_nVlrFin := Round(_nTotIPI * _nDespFin/100,2)
				Endif
				MaFisRecal("",nItem)
				_nICM    := MaFisRet(1,"IT_ALIQICM")
				_nIPI    := MaFisRet(1,"IT_ALIQIPI")
				_nValIPI := MaFisRet(1,"IT_VALIPI")
				_nValICM := MaFisRet(1,"IT_VALICM")
				_nICMRET := MaFisRet(1,"IT_VALSOL")
				nMargem  := MaFisRet(1,"IT_MARGEM")
				nBaseSol := MaFisRet(1,"IT_BASESOL")
				nValPS2  := MaFisRet(nItem,"IT_VALPS2")
				nValCF2  := MaFisRet(nItem,"IT_VALCF2")
				If nValPS2 > 0 .and. _nFrete > 0
					_nAliqPS2 := MaFisRet(1,"IT_ALIQPS2")
					_nAliqCF2 := MaFisRet(1,"IT_ALIQCF2")
					nValPS2   := Round((_nTotIPI+_nValFret) * _nAliqPS2/100,2)
					nValCF2   := Round((_nTotIPI+_nValFret) * _nAliqCF2/100,2)
				Endif
				MaFisEndLoad(1)
				_aCusto := AN103Custo(_nPrcTot, cProduto, SB1->B1_LOCPAD, 1, _nAliqIPI, _nAliqICMS, nValPS2, nValCF2, _nValIPI, _nDespFin)
				_nCusto := _aCusto[1]
				If _nValFret > 0
					_nICMF := _nValFret * _nIcmFret/100
					_nCusto:= _nCusto + _nValFret - _nICMF
				Endif
				MaFisEnd()
			EndIf
		EndIf
	Endif
	If _cFilOri <> cFilAnt
		cFilAnt := _cFilOri
	Endif
	RestArea(_aAreaSB1)
	RestArea(_aArea)
Return{_cTES, _nCusto, nValPS2, nValCF2, _nICMRET, _nValFret, _nVlrFin, _nICMF, _nValIPI, _nValICM, _nICMRET, nBaseSol, nMargem}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AN103Custo(_nValor, cProduto, _cLocal, _nQuant, _nAliqIPI, _nAliqICMS, nValPS2, nValCF2, _nValIPI, _nDespFin)
	Local aCusto	:= {}
	Local aRet		:= {}
	Local nX		:= 0
	Local nFatorPS2	:= 1
	Local nFatorCF2	:= 1
	Local nValNCalc	:= 0
	Local lDEDICMA	:= SuperGetMV("MV_DEDICMA", .F., .F.)	// Efetua deducao do ICMS anterior nao calculado pelo sistema
	Local lDedIcmAnt:= .F.
	Local lValCMaj	:= !Empty(MaFisScan("IT_VALCMAJ",.F.))	// Verifica se a MATXFIS possui a referentcia IT_VALCMAJ
	Local lValPMaj	:= !Empty(MaFisScan("IT_VALPMAJ",.F.))	// Verifica se a MATXFIS possui a referentcia IT_VALCMAJ
	Local nItem		:= 1
	Local aDupl     := {}
	Local cTipo		:= "N"
	Local _nValIPI	:= IIF(SF4->F4_IPI == "S", Round(_nValor * _nAliqIPI/100, 2), 0)
	Local _nValICM	:= IIF(SF4->F4_ICM == "S", Round(_nValor * _nAliqICMS/100, 2), 0)
	Local _nAliqICM := AliqIcms("N","E")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o percentual para credito do PIS / COFINS   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( SF4->F4_BCRDPIS )
		nFatorPS2 := SF4->F4_BCRDPIS / 100
	EndIf

	If !Empty( SF4->F4_BCRDCOF )
		nFatorCF2 := SF4->F4_BCRDCOF / 100
	EndIf

	nValPS2 := nValPS2 * nFatorPS2
	nValCF2 := nValCF2 * nFatorCF2

	If SF4->(FieldPos("F4_CRDICMA")) > 0 .And. !Empty(SF4->F4_CRDICMA)
		lDedIcmAnt := SF4->F4_CRDICMA == '1'
	Else
		lDedIcmAnt := lDEDICMA
	EndIf
	If lDedIcmAnt
		nValNCalc := MaFisRet(nItem,"IT_ICMNDES")
	EndIf

	aADD(aCusto,{_nValor,;
	_nValIPI,;
	_nValICM,;
	SF4->F4_CREDIPI,;
	SF4->F4_CREDICM,;
	" ",;
	" ",;
	cProduto,;
	_cLocal,;
	_nQuant,;
	If(SF4->F4_IPI=="R",_nValIPI,0),;
	SF4->F4_CREDST,;
	MaFisRet(nItem,"IT_VALSOL"),;
	MaRetIncIV(nItem,"1"),;
	SF4->F4_PISCOF,;
	SF4->F4_PISCRED,;
	nValPS2 - (IIf(lValPMaj,MaFisRet(nItem,"IT_VALPMAJ"),0)),;
	nValCF2 - (IIf(lValCMaj,MaFisRet(nItem,"IT_VALCMAJ"),0)),;
	IIf(SF4->F4_ESTCRED > 0,MaFisRet(nItem,"IT_ESTCRED"),0) ,;
	MaFisRet(nItem,"IT_CRPRSIM"),;
	Iif(SF4->F4_CREDST != '2' .And. SF4->F4_ANTICMS == '1',MaFisRet(nItem,"IT_VALANTI"),0),;
	"";
	})

	// *** Parametros do array aCusto ***
	// 1§ Elemento -> Valor Total do Item, j  com rateio do frete
	// 2§ Elemento -> Valor IPI  do Item.
	// 3§ Elemento -> Valor ICMS do Item.
	// 4§ Elemento -> Informacao do TES de Credita ou n„o do IPI.
	// 5§ Elemento -> Informacao do TES de Credita ou n„o do ICMS.
	// 11.Elemento -> IPI atacadista
	//--> Tratamento para Credito do ICMS Solid. ( Incluido 11/05/2000)
	// 12§ Elemento -> Informacao do TES se Credita ou nao o ICMS Solid.(Default:Nao)
	// 13§ Elemento -> Valor do ICMS Solidario
	// 14§ Elemento -> Utilizado por impostos variaveis
	// 15§ Elemento -> Calcula PIS/Cofins
	// 16§ Elemento -> Credita PIS/Cofins
	// 17§ Elemento -> Valor do PIS/Pasep
	// 18§ Elemento -> Valor do Cofins
	// 19§ Elemento -> Valor do Estorno de ICMS (F4_ESTCRED)
	// 20§ Elemento -> Valor do Credito presumido do simples nacional - Estado SC
	// 21§ Elemento -> Valor da antecipacao de ICMS.

	aRet := RetCusEnt(aDupl,aCusto,cTipo)
	If SF4->F4_AGREG == "N"
		For nX := 1 to Len(aRet[1])
			aRet[1][nX] := If(aRet[1][nX]>0,aRet[1][nX],0)
		Next nX
	EndIf

	If _nDespFin > 0
		_nVlrFin := Round((_nValor + _nValIPI) * _nDespFin/100,2)
		aRet[1][1] := aRet[1][1] + _nVlrFin
	Endif
Return aRet[1]
//----------------------------------------------------------------------------------------------

Static Function NextIDTab(cParametro, cField)

	Local cCodAnt := ""
	Local nC      := 0
	While !LockByName("TABPROXSEQ", .T., .F.)
		Sleep(50)
		nC++
		If nC == 60
			nC := 0
		EndIf
	EndDo
	cCodAnt := PadR(GetMv(cParametro), TamSx3(cField)[1])
	If Empty(cCodAnt)
		cCodAnt := Replicate('0',TamSX3(cField)[1])
	EndIf
	cCodAnt := Soma1(cCodAnt,TamSX3(cField)[1])
	PutMv(cParametro,cCodAnt)
	UnLockByName("TABPROXSEQ", .T., .F.)
Return cCodAnt
//--------------------------------------------------------------------------------------------
Static Function LISTPRCDOC()

	Private aRotina	:= MenuDef()
	Private cCadastro	:= OemtoAnsi("Lista de Preços")
	//MsgInfo("RecNo Posicionado: "+cValToChar(SZ2->(Recno())))
	MsDocument('SZ2',SZ2->(Recno()),4)

Return
//-----------------------------------------------------------------------
// Calcula o preco de reposição considerando os dados digitados na tela
User Function FCalcVen()

	Local _cRotina   := Funname()
	Local _lRet		 := .T.
	Local _aArea	 := GetArea()
	If _cRotina == "MNTTABPRC"
		If Alltrim(ReadVar()) == "M->Z3_LETRA"
			FClcVen_B()
		ElseIf Alltrim(ReadVar()) == "M->Z3_DESCVEN"
			FClcVen_C()
		ElseIf Alltrim(ReadVar()) == "M->Z3_PRCREP"
			FClcVen_D()
		Endif
	Else
		FClcVen_A()
	Endif
Return(_lRet)

//-----------------------------------------------------------------------
// Calcula o preco de reposição considerando os dados digitados na tela

Static Function FClcVen_A

	Local _lRet		 := .T.
	Local _aArea	 := GetArea()
	Local oModel 	 := FWModelActive()
	Local oModelZ3	 := IIF(oModel:csource == "CADSZ3", oModel:GetModel( 'SZ3MASTER' ), oModel:GetModel('Z3DETAIL'))
	Local _cCod	 	 := oModelZ3:GetValue( "Z3_COD" )
	Local _nPrcRep	 := oModelZ3:GetValue( "Z3_PRCREP" )
	Local _cLetra 	 := oModelZ3:GetValue( "Z3_LETRA" )
	Local _nMargem 	 := oModelZ3:GetValue( "Z3_MARGEM" )
	Local _nFator 	 := oModelZ3:GetValue( "Z3_FATOR" )
	Local _nDescVen	 := oModelZ3:GetValue( "Z3_DESCVEN" )
	Local _nPrcVen	 := 0
	Local _cMonoFas  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMONO")
	Local _cCodMarc  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMARCA")
	Local _cLinhaSB1 := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XLINHA")

	If _nPrcRep > 0
		_nPrcVen := u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nPrcRep)[4]
		oModelZ3:SetValue( 'Z3_PRCVEN', _nPrcVen )
	Endif
	RestArea(_aArea)
Return(_lRet)
//-----------------------------------------------------------------------
// Calcula o preco de reposição considerando os dados digitados na tela

Static Function FClcVen_B

	Local _lRet		 := .T.
	Local _aArea	 := GetArea()
	Local _nPrcVen	 := 0
	Local _cLetra	 := M->Z3_LETRA
	Local _nLinPr 	 := oGtd0:nAT
	Local _nPosCod   := aScan(aHeadB1,{|x| AllTrim(x[2]) == "B1_COD"})
	Local _cCod		 := oGtd0:aCols[_nLinPr,_nPosCod]
	Local _nLinha 	 := oGtd2:nAT
	Local _nPrcRep	 := oGtd2:aCols[_nLinha,_nPosRep2]
	Local _cMonoFas  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMONO")
	Local _cCodMarc  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMARCA")
	Local _cLinhaSB1 := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XLINHA")
	If _nPrcRep > 0
		_nPrcVen := u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nPrcRep)[4]
		oGtd2:aCols[_nLinha,_nPosLiq2] := _nPrcVen - (_nPrcVen*oGtd2:aCols[_nLinha,_nPosDes2]/100)
		oGtd2:oBrowse:Refresh()
	Endif
	RestArea(_aArea)
Return(_lRet)
//-----------------------------------------------------------------------
// Calcula o preco de reposição considerando os dados digitados na tela

Static Function FClcVen_C

	Local _lRet		 := .T.
	Local _aArea	 := GetArea()
	Local _nDesc	 := M->Z3_DESCVEN
	Local _nLinPr 	 := oGtd0:nAT
	Local _nPosCod   := aScan(aHeadB1,{|x| AllTrim(x[2]) == "B1_COD"})
	Local _cCod		 := oGtd0:aCols[_nLinPr,_nPosCod]
	Local _nPrcVen	 := 0
	Local _nLinha 	 := oGtd2:nAT
	Local _nPrcRep	 := oGtd2:aCols[_nLinha,_nPosRep2]
	Local _cMonoFas  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMONO")
	Local _cCodMarc  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMARCA")
	Local _cLinhaSB1 := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XLINHA")
	
	If _nPrcRep > 0
		_nPrcVen := u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nPrcRep)[4]
		oGtd2:aCols[_nLinha,_nPosLiq2] := _nPrcVen - (_nPrcVen*_nDesc/100)
		oGtd2:oBrowse:Refresh()
	Endif
	RestArea(_aArea)
Return(_lRet)
//-----------------------------------------------------------------------
// Calcula o preco de reposição considerando os dados digitados na tela

Static Function FClcVen_D

	Local _lRet		 := .T.
	Local _aArea	 := GetArea()
	Local _nPrcVen	 := 0
	Local _nLinPr 	 := oGtd0:nAT
	Local _nPosCod   := aScan(aHeadB1,{|x| AllTrim(x[2]) == "B1_COD"})
	Local _cCod		 := oGtd0:aCols[_nLinPr,_nPosCod]
	Local _nLinha 	 := oGtd2:nAT
	Local _nPrcRep	 := M->Z3_PRCREP
	Local _cMonoFas  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMONO")
	Local _cCodMarc  := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XMARCA")
	Local _cLinhaSB1 := Posicione("SB1",1,xFilial("SB1")+_cCod, "B1_XLINHA")
	If _nPrcRep > 0
		_nPrcVen := u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilAnt, _nPrcRep)[4]
		oGtd2:aCols[_nLinha,_nPosLiq2] := _nPrcVen - (_nPrcVen*oGtd2:aCols[_nLinha,_nPosDes2]/100)
		oGtd2:oBrowse:Refresh()
	Endif
	RestArea(_aArea)
Return(_lRet)
//-----------------------------------------------------------------------------
//
User Function RetLetra(cFilParam, _cLetra)

	Local _aArea:= GetArea()
	Local _nRet := 0
	If !Empty(_cLetra)
		_nRet := Posicione("ZZI",1, cFilParam+_cLetra, "ZZI->ZZI_MARGEM")
	Endif
	If _nRet == 0
		_nRet := GetMv("MV_XPDLETR",,0)//1
	Endif
	RestArea(_aArea)
Return(_nRet)
//-----------------------------------------------------------------------------
//
User Function RetMarkup(_cMonoFas, _cCodMarc, _cLinhaSB1, cFilAnt)

	Local _aArea 	:= GetArea()
	Local _nMarKup 	:= 0
	Local _nFator 	:= 0
	Local nH		:= 1
	dbSelectArea("ZZH")
	dbSetOrder(1)
	IF dbSeek(xFilial()+_cCodMarc+_cLinhaSB1+cFilAnt)
		If _cMonoFas == "S"
			_nMarKup  := ZZH->ZZH_MKMNF
		Else
			_nMarKup  := ZZH->ZZH_MKNMNF
		Endif
		_nFator := ZZH->ZZH_INDICE
	Endif
	RestArea(_aArea)
	Return({_nMarKup, _nFator})
//-----------------------------------------------------------------------------
//
User Function CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, cFilParam, _nCusto, _nDescVen)

	Local _aArea 	:= GetArea()
	Local _nMargem  := 0
	Local _nPrcVen 	:= 0
	Local _aRetMark := {}
	Local _nMarKup  := 0
	Local _nFator 	:= 0
	Local _nPrcBrt 	:= 0
	Local _nLetra	:= 0
	Default _nDescVen := 0
	If !Empty(_cMonoFas) .and. !Empty(_cCodMarc) .and. !Empty(_cLinhaSB1)
		_aRetMark := u_RetMarkup(_cMonoFas, _cCodMarc, _cLinhaSB1, cFilParam)
		_nMarKup  	:= _aRetMark[1]
		_nFator 	:= _aRetMark[2]
		_nLetra 	:= u_RetLetra(cFilParam, _cLetra)
		_nMargem 	:= (1 + (_nMarKup/100)) * _nLetra
		_nPrcBrt 	:= Round(_nCusto * _nMargem * _nFator, 2)
		_nPrcVen 	:= Round(_nPrcBrt - (_nPrcBrt * _nDescVen/100),2)
		If _nMargem > 0
			_nMargem := Round((_nMargem - 1) * 100,2)
		Else
			_nMargem := 0
		Endif
	Endif
	RestArea(_aArea)
Return({ _nMarKup, _nLetra, _nFator, _nPrcVen, _nMargem, _nPrcBrt})

//------------------------------------------------------------------------------------------------------------
//
Static Function ProxItem(_cCodDA0, cProdTab)

	Local _aArea	 := GetArea()
	Local nTentativa := 0
	Local _lExclusiva := .T.
	Local cAliasDA1 := "QRYDA1"
	Local _nUltItem := StrZero(1, TAMSX3("DA1_ITEM")[1])
	While !LockByName("PRXTABIT",.T.,.T.)
		nTentativa ++
		If nTentativa > 99000
			_lExclusiva := .F.
			Exit
		EndIf
	End
	If _lExclusiva
		_cQuery := " SELECT MAX(DA1_ITEM) DA1_ITEM"
		_cQuery += " FROM " + RetSqlName("DA1") + " DA1 "
		_cQuery += " WHERE DA1_FILIAL = '" + xFilial("DA1") + "'"
		_cQuery += " AND DA1_CODTAB = '" + _cCodDA0 + "'"
		_cQuery += " AND DA1_CODPRO = '" + cProdTab + "'"
		_cQuery += " AND DA1.D_E_L_E_T_ = ' '"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasDA1,.T.,.T.)
		dbSelectArea(cAliasDA1)
		If !Eof()
			_nUltItem := (cAliasDA1)->DA1_ITEM
		Endif
		UnLockByName("PRXTABIT",.T.,.T.)
		dbSelectArea(cAliasDA1)
		dbCloseArea()
	Endif
	RestArea(_aArea)
Return(_nUltItem)
//------------------------------------------------------------------------------------------------------------
Static Function RET_ACENT(cExp)

	cExp := StrTran(cExp,"."," ")
	cExp := StrTran(cExp,"'"," ")
	cExp := StrTran(cExp,"ã","a")
	cExp := StrTran(cExp,CHR(10) ," ")
	cExp := StrTran(cExp,CHR(13) ," ")
	cExp := StrTran(cExp,CHR(151)," ")
Return(cExp)
//------------------------------------------------------------------------------------------------------------
Static Function SOBREPOR
	Local _lRet
	Local nLargura := 400
	Local nAltura  := 350
	Local _cFilSel := "Todas Filiais"
	Local _aSelFil := {}
	Local _cTabOri := SZ2->Z2_CODTAB
	Local _cDscOri := SZ2->Z2_DESCTAB

	Local _aArea := GetArea()
	Local _cCodTab := SZ2->Z2_CODTAB
	Local _cMarca  := SZ2->Z2_MARCA
	Local _aCodForn := Array(1,2)
	Local _aFilCop  := {}
	Local aSelFil 	:= {}
	Local aSize := MsAdvSize()
	Local aObjects := {{100,100,.t.,.t.}}
	Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local aPosObj  := MsObjSize(aInfo,aObjects)
	Local cAliasSZ2 := "QRYSZ2"
	Local aStruct 	:= {}
	Local cIndTmp
	Local cChave	:= ''
	Local _oCopTab
	Local aColumns	:= {}
	Local nRet 		:= 0
	Local bOk 		:= {||((nRet := 1, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local bCancel	:= {||((nRet := 0, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local oFnt2S  	:= TFont():New("Arial",6 ,15,.T.,.T.,,,,,.F.) 	  //NEGRITO
	Local cAliasTMP  := GetNextAlias()
	Local _lCop		:= .F.
	Local _lContinua := .F.
	Local cPerg := "AN_CALCPR"
	Local _cMarca
	Local _dDtImp
	Local _dDtAte
	Local _cMarcaSel := ""
	Local aSelPrd := {}
	Local cFilPrd  := "Sim"

	aadd(aSelPrd, "Sim")
	aadd(aSelPrd, "Não")

	Private _cCodMarc := SZ2->Z2_MARCA
	Private _cNReduz := POSICIONE("ZZ7",1,XFILIAL("ZZ7")+_cCodMarc,"ZZ7_DESCRI")
	Private _cDescTab := SZ2->Z2_DESCTAB
	Private cFile  := Space(99999)
	Private oDlgWOF

	Gera_SX1(cPerg)
	If Pergunte(cPerg,.T.)

		_cMarca := Alltrim(mv_par01)
		_dDtImp	:= mv_par02
		_dDtAte	:= mv_par03

		If !Empty(_cMarca)
			While !Empty(_cMarca)
				nPos := AT(";",_cMarca)
				If Empty(_cMarcaSel)
					_cMarcaSel := "('"
				Else
					_cMarcaSel += ",'"
				Endif
				If nPos > 0
					_cMarcaSel += Alltrim(Substr(_cMarca,1,nPos-1)) + "'"
					_cMarca := Substr(_cMarca,nPos+1)
				Else
					_cMarcaSel += Alltrim(_cMarca) + "'"
					Exit
				Endif
			End
			_cMarcaSel += ")"
		Endif

		Aadd(aStruct, {"TMP_OK","C",1,0})
		Aadd(aStruct, {"TMP_FILIAL"	,"C"	,TamSx3("Z2_FILIAL")[1]		,0, "Filial"})
		aAdd(aStruct, {"TMP_NOMFIL"	,"C"	,30							,0, "Nome"			, 150, " " })
		Aadd(aStruct, {"TMP_CODTAB"	,"C"	,TamSx3("Z2_CODTAB")[1]		,0, "Tabela"})
		aAdd(aStruct, {"TMP_DESCTA" ,"C"	,TamSx3("Z2_DESCTAB")[1]	,0, "Descrição"		, 150, " " })
		aAdd(aStruct, {"TMP_FORNEC"	,"C"	,TamSx3("Z2_MARCA")[1]		,0, "Fornecedor"	, 100, " " })
		aAdd(aStruct, {"TMP_DTINCL"	,"D"	,TamSx3("Z2_DATA")[1]		,0, "Dt. Inclusão"	, 080,  " " })

		If(_oCopTab <> NIL)
			_oCopTab:Delete()
			_oCopTab := NIL
		EndIf

		_oCopTab := FwTemporaryTable():New(cAliasTmp)
		_oCopTab:SetFields(aStruct)
		_oCopTab:AddIndex("1",{"TMP_FILIAL", "TMP_CODTAB"})
		_oCopTab:Create()

		dbSelectArea("SZ2")
		_cQuery := "SELECT * "
		_cQuery += "FROM " + RetSqlName("SZ2")
		_cQuery += " WHERE Z2_DATA >= '" + Dtos(_dDtImp) + "'"
		_cQuery += " AND Z2_DATA   <= '" + Dtos(_dDtAte) + "'"
		_cQuery += " AND Z2_STATUS <> '4'"
		If !Empty(_cMarcaSel)
			_cQuery += " AND Z2_MARCA IN " + _cMarcaSel
		Endif
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " ORDER BY Z2_FILIAL, Z2_CODTAB"
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasSZ2,.T.,.T.)
		dbSelectArea(cAliasSZ2)
		While !Eof()
			RecLock(cAliasTMP,.T.)
			(cAliasTMP)->TMP_FILIAL := (cAliasSZ2)->Z2_FILIAL
			(cAliasTMP)->TMP_NOMFIL := Posicione("SM0",1,cEmpAnt+(cAliasSZ2)->Z2_FILIAL,"M0_FILIAL")
			(cAliasTMP)->TMP_CODTAB := (cAliasSZ2)->Z2_CODTAB
			(cAliasTMP)->TMP_DESCTAB:= (cAliasSZ2)->Z2_DESCTAB
			(cAliasTMP)->TMP_FORNEC := (cAliasSZ2)->Z2_MARCA
			(cAliasTMP)->TMP_DTINCL := Stod((cAliasSZ2)->Z2_DATA)
			MsUnlock()
			dbSelectArea(cAliasSZ2)
			(cAliasSZ2)->(dbSkip())
		End
		dbSelectArea(cAliasSZ2)
		dbCloseArea()
		dbSelectArea(cAliasTMP)
		dbGotop()
		If !Eof() .and. !Bof()
			//----------------MarkBrowse----------------------------------------------------
			For nX := 1 To Len(aStruct)
				If	!aStruct[nX][1] $ "TMP_OK"
					AAdd(aColumns,FWBrwColumn():New())
					aColumns[Len(aColumns)]:lAutosize:=.T.
					aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
					aColumns[Len(aColumns)]:SetTitle(aStruct[nX][5])
					//			aColumns[Len(aColumns)]:SetSize(aStruct[nX][6])
					aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
					//			aColumns[Len(aColumns)]:SetPicture(aStruct[nX][7])
					If aStruct[nX][2] $ "N/D"
						aColumns[Len(aColumns)]:nAlign := 3
					Endif
				EndIf
			Next nX
			aSize := MsAdvSize(,.F.,400)
			DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela para Sobrerpor" From 300,0 to 800,1000 OF oMainWnd PIXEL
			oMrkBrowse:= FWMarkBrowse():New()
			oMrkBrowse:SetFieldMark("TMP_OK")
			oMrkBrowse:SetOwner(oDlgAB)
			oMrkBrowse:SetAlias(cAliasTMP)
			oMrkBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
			oMrkBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parâmetros
			oMrkBrowse:bMark     := {||ItmMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:bAllMark  := {||COPMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:SetDescription("          S O B R E P O R    L I S T A   D E   P R E Ç O  - Selecione para Sobrepor.")
			oMrkBrowse:SetColumns(aColumns)
			oMrkBrowse:SetMenuDef("")
			oMrkBrowse:Activate()
			ACTIVATE MSDIALOg oDlgAB CENTERED
			If nRet == 1
				dbSelectArea(cAliasTMP)
				dbGotop()
				While !Eof()
					If (cAliasTMP)->TMP_OK == oMrkBrowse:Mark()
						dbSelectArea("SZ2")
						dbSetOrder(1)
						dbSeek((cAliasTMP)->TMP_FILIAL+(cAliasTMP)->TMP_CODTAB)
						aadd(_aFilCop, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB})
						aadd(aLstSobP, {(cAliasTMP)->TMP_FILIAL, (cAliasTMP)->TMP_CODTAB, (cAliasTMP)->TMP_DESCTAB, (cAliasTMP)->TMP_FORNEC, SZ2->Z2_FRETE, SZ2->Z2_ICMFRT, SZ2->Z2_DESPFIN})
					Endif
					dbSelectArea(cAliasTMP)
					dbSkip()
				End
				If Len(_aFilCop) > 0
					//Tela para importação
					DEFINE DIALOG oDlgWOF TITLE "Seleção Importação" FROM 0, 0 TO 22, 90 SIZE nLargura, nAltura PIXEL //
					//Painel Origem
					oPanelOrigem   := TPanel():New( 005, 005, ,oDlgWOF, , , , , , nLargura-10, nAltura-19, .F.,.T. )
					@ 00,000 SAY oSay  VAR "Informe os Dados da Tabela para sobrepor" OF oPanelOrigem FONT (TFont():New('Arial',0,-13,.T.,.T.)) PIXEL //"Origem"
					@ 10,005 SAY oAcao VAR "Arquivo" OF oPanelOrigem PIXEL //"Arquivo:"
					@ 20,005 MSGET cFile SIZE 140,010 OF oPanelOrigem WHEN .T. PIXEL
					@ 20,150 BUTTON oBtnAvanca PROMPT "Abrir" SIZE 15,12 ACTION (SelectFile()) OF oPanelOrigem PIXEL //"Abrir"
					@ 45,005 SAY oEmp VAR "Importa produtos não localizados? " OF oPanelOrigem PIXEL
					@ 43,090 COMBOBOX oSelPrd VAR cFilPrd ITEMS aSelPrd SIZE 50,10 OF oPanelOrigem PIXEL
					oPanelBtn := TPanel():New( (nAltura/2)-14, 0, ,oDlgWOF, , , , , , (nLargura/2), 14, .F.,.T. )
					@ 000,((nLargura/2)-122) BUTTON oBtnAvanca PROMPT "Confirmar"  SIZE 60,12 ACTION (VldSele(_cTabOri, _cFilSel, cFilPrd, .T.)) OF oPanelBtn PIXEL
					@ 000,((nLargura/2)-60)  BUTTON oBtnAvanca PROMPT "Cancelar"   SIZE 60,12 ACTION (oDlgWOF:End()) OF oPanelBtn PIXEL //"Cancelar"
					ACTIVATE MSDIALOG oDlgWOF CENTER
				Endif
				aLstSobP := {}
			Endif
		Endif
	Endif
Return
//---------------------------------------------

User Function AltPrc(cAliasTMP)

	Local oValor
	Local nValor := (cAliasTMP)->TMP_PRCVEN
	Local oTitulo
	Local oSOK
	Local oSCANCEL
	Local lOK   := .F.
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Atualizar Preço" FROM 000, 000  TO 100, 200 COLORS 0, 16777215 PIXEL

	@ 015, 021 MSGET oValor VAR nValor SIZE 056, 010 OF oDlg PICTURE "@E 999,999,999.99" COLORS 0, 16777215 PIXEL
	@ 004, 022 SAY oTitulo PROMPT "Preço Liquido" SIZE 048, 008 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSOK 	FROM 035, 011 TYPE 01 ACTION (lOk := .T., oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oSCANCEL FROM 035, 059 TYPE 02 ACTION (oDlg:End()) OF oDlg ENABLE

	ACTIVATE MSDIALOG oDlg CENTERED

	If lOK
		If RecLock(cAliasTMP,.F.)
			(cAliasTMP)->TMP_PRCVEN := nValor
			MsUnlock()
		Endif
		_oBrwClass:Refresh(.F.)
	Endif

Return

//--------------------------------------
/*/{Protheus.doc} AN001
Efetiva para varias tabelas e filiais
@author felipe.caiado
@since 29/03/2019
@version 1.0

@type function
/*/
//--------------------------------------
Static Function AN001(aFilCop, _dEfeti)

	Local nA         := 0
	Local nB         := 0
	Local nY         := 0
	Local nT         := 0
	Local cCodDA0    := SuperGetMv("AN_TABPRC",.F.,"100")
	Local cAliasDA1  := GetNextAlias()
	Local cAliasITE  := GetNextAlias()
	Local _cMonoFas  := CriaVar("B1_XMONO",.F.)
	Local _cLinhaSB1 := CriaVar("B1_XLINHA",.F.)
	Local aCodMestre := {}
	Local cFilOri    := cFilAnt
	//MsgInfo("AN001 - 25/08/2020")
	For nT:=1 To Len(aFilCop)
		cFilAnt := aFilCop[nT][1]
		dbSelectArea("DA0")
		DA0->(dbSetOrder(1))
		//MsgInfo("Pesquisando tabela na DA0 - Chave ["+aFilCop[nT][1]+cCodDA0+"]")
		If !DA0->(DbSeek(xFilial("DA0")+cCodDA0))
			RecLock("DA0",.T.)
			DA0->DA0_FILIAL := xFilial("DA0")
			DA0->DA0_CODTAB := cCodDA0
			DA0->DA0_DESCRI := "Tabela Generica"
			DA0->DA0_DATDE  := _dEfeti
			DA0->DA0_HORADE := Time()
			DA0->DA0_HORATE := "23:59"
			DA0->DA0_TPHORA := "1"
			DA0->DA0_ATIVO 	:= "1"
			MsUnLock()
		//Else
		   //MsgInfo("ENCONTREI Chave ["+aFilCop[nT][1]+cCodDA0+"] na DA0")
		Endif

		DbSelectArea("SZ2")
		SZ2->(DbSetOrder(1))
		//MsgInfo("Pesquisando na SZ2 - chave ["+aFilCop[nT][1]+aFilCop[nT][2]+"]")
		If SZ2->(DbSeek(xFilial("SZ2")+aFilCop[nT][2]))

			DbSelectArea("SZ3")
			SZ3->(DbSetOrder(1))
			//MsgInfo("Pesquisando na SZ3 - chave: ["+aFilCop[nT][1]+aFilCop[nT][2]+"]")
			If SZ3->(DbSeek(xFilial("SZ3")+aFilCop[nT][2]))
			   //MsgInfo("ENCONTREI NA SZ3 CHAVE: ["+SZ3->Z3_FILIAL+SZ3->Z3_CODTAB+"]")
				_nSZ3 := 1
				While !SZ3->(Eof()) .And. xFilial("SZ3")+aFilCop[nT][2] == SZ3->Z3_FILIAL+SZ3->Z3_CODTAB
					//MsgInfo("Percorrendo SZ3 ... "+cValToChar(_nSZ3))
					If Empty(SZ3->Z3_COD)
					    //MsgInfo("Ignorou 1")
						SZ3->(DbSkip())
						Loop
					EndIf
					_nCusto		:= SZ3->Z3_PRCREP
					If _nCusto <= 0
					    //MsgInfo("Ignorou 2")
						SZ3->(DbSkip())
						Loop
					EndIf
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+SZ3->Z3_COD))
					cCodMestre := SB1->B1_XALTIMP
					_cLetra		:= u_BuscTabVig(SZ3->Z3_COD, SB1->B1_XMARCA, _dEfeti)[1]
					//Ita - 10/08/2020 - _nDescVen	:= SZ3->Z3_DESCVEN
					_nDescVen	:= u_BuscTabVig(SZ3->Z3_COD, SB1->B1_XMARCA, _dEfeti)[4]
					_cMonoFas 	:= IIF(SZ3->Z3_MONOFAS=="S","S","N")
					_cLinhaSB1  := SZ3->Z3_LINHA
//Return({ _nMarKup, _nLetra, _nFator, _nPrcVen, _nMargem, _nPrcBrt})
					_aRetPrc	:= u_CalcPrcV(_cLetra, _cMonoFas, SB1->B1_XMARCA,_cLinhaSB1, cFilAnt, _nCusto, _nDescVen)
					_nMarKup	:= _aRetPrc[1]
					_nLetra		:= _aRetPrc[2]
					_nFator		:= _aRetPrc[3]
					_nPrcVen	:= _aRetPrc[4]
					_nMargem 	:= _aRetPrc[5]
					_nPrcBrt	:= _aRetPrc[6]
					// Cesar, 12/08/2020: Teste para resolver problema de lock em eof.
					/*
					if !sz3->(eof())
					   ApMsgInfo("nao é o fim do arquivo: "+SZ3->Z3_COD)
					else
					   ApMsgInfo("É o fim do arquivo: "+SZ3->Z3_COD)						
					Endif
					*/
					RecLock("SZ3",.F.)
					Replace Z3_LETRA 	with _cLetra,;
							Z3_DESCVEN  with _nDescVen,;
							Z3_MARGEM	with _nMargem,;
							Z3_FATOR	with _nLetra,;
							Z3_INDMARK	with _nFator,;
							Z3_PRCVEN	with _nPrcVen
					MsUnLock()
					If !Empty(cCodMestre)
						nPos := aScan(aCodMestre,{|x| x[1]+x[2] == aFilCop[nT,1] + cCodMestre})
						If nPos == 0
							aadd(aCodMestre, {aFilCop[nT,1], cCodMestre})
						Else
							DbSelectArea("SZ3")
							dbSkip()
							Loop
						Endif
					Endif
					lCriaReg := .T.
					cTabProc 	:= ""
					aTabSeq		:= {}
					aTabDel		:= {}
					lAtualiz	:= .F.
					//Posiciona ZZH
					DbSelectArea("ZZH")
					ZZH->(DbSetOrder(1))
					ZZH->(DbSeek(xFilial("ZZH")+SB1->B1_XMARCA+SB1->B1_XLINHA+aFilCop[nT][1]))
					DbSelectArea("DA1")
					DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
					//MsgInfo("Pesquisando na DA1 - chave: ["+aFilCop[nT][1]+cCodDA0+SZ3->Z3_COD+"]")
					If DA1->(DbSeek(xFilial("DA1")+cCodDA0+SZ3->Z3_COD))
					   //MsgInfo("ACHEI na DA1... Registro ["+DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO+"]")
						nrda1 := 1
						While !DA1->(Eof()) .And. xFilial("DA1")+cCodDA0+SZ3->Z3_COD == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
							//MsgInfo("Percorrendo Registros da DA1... "+cValToChar(nrda1)+" DA1->DA1_DATVIG: "+DTOC(DA1->DA1_DATVIG)+" _dEfeti: "+DTOC(_dEfeti))
							//Verifica se é menor que a tabela 1
							If DA1->DA1_DATVIG > _dEfeti
								//MsgInfo("Vigencia é maior que efeitação...saltando registro")
								DA1->(DbSkip())
								Loop

							ElseIf DA1->DA1_DATVIG == _dEfeti
								//MsgInfo("Vigencia é igual a efetivação... alterando registro")
								lCriaReg := .F.

								Reclock("DA1",.F.)

								DA1->DA1_XLETRA 	:= SZ3->Z3_LETRA
								DA1->DA1_XCDTAB 	:= SZ3->Z3_CODTAB
								DA1->DA1_XPRCBR 	:= SZ3->Z3_PRCVEN
								DA1->DA1_XPRCLI 	:= SZ3->Z3_PRCVEN
								DA1->DA1_XPRCRE 	:= SZ3->Z3_PRCREP
								DA1->DA1_XDESCV 	:= SZ3->Z3_DESCVEN
								DA1->DA1_XMARGEM 	:= SZ3->Z3_MARGEM
								DA1->DA1_XFATOR 	:= ZZH->ZZH_INDICE
								DA1->DA1_PRCVEN 	:= SZ3->Z3_PRCVEN

								DA1->(MsUnlock())

								DA1->(DbSkip())
								Loop

							Else
								//MsgInfo("Vigencia é menor que efetivação")
								If lCriaReg
									//MsgInfo("lCriaReg é TRUE vou incluir registro")
									lAtualiz := .T.

									If Empty(cTabProc)
										cTabProc := DA1->DA1_XTABSQ
									EndIf

									//Se menor que 2 aumenta um nivel
									If DA1->DA1_XTABSQ <= "2"

										//Adiciona no array para não atrapalhar o while
										aAdd(aTabSeq,{DA1->(Recno()),Soma1(DA1->DA1_XTABSQ)})

									Else// Se 3 deleta

										aAdd(aTabSeq,{DA1->(Recno()),Soma1(DA1->DA1_XTABSQ)})
										aAdd(aTabDel,DA1->(Recno()))
									EndIf

								//Else
								   //MsgInfo("lCriaReg é FALSE")
								EndIf

							EndIf

							DA1->(DbSkip())
							//nrda1 ++ //Ita - MsgInfo

						EndDo

						If lCriaReg .And. lAtualiz
						    //MsgInfo("lCriaReg .And. lAtualiz")
							//Atualiza as proximas sequencias
							For nY:=1 To Len(aTabSeq)
								DA1->(DbGoTo(aTabSeq[nY][1]))
								Reclock("DA1",.F.)
									DA1->DA1_XTABSQ := aTabSeq[nY][2]
								DA1->(MsUnlock())
							Next nY

							cTabProx := Soma1(cTabProc)

							//Localiza a vigencia da tabela 1
							BeginSQL alias cAliasDA1
							SELECT
								R_E_C_N_O_ RECNUM
							FROM
								%table:DA1% DA1
							WHERE
								DA1_FILIAL = %exp:aFilCop[nT][1]%
								AND DA1_CODPRO = %exp:SZ3->Z3_COD%
								AND DA1_CODTAB = %exp:cCodDA0%
								AND DA1_XTABSQ = %exp:cTabProx%
								AND DA1.%notDel%
							EndSql

							//Estrutura da DA1
							aStruct := DA1->(DbStruct())

							aReg := {}

							nA := 0

							////Localiza o ultimo item da tabela
							BeginSQL alias cAliasITE
							SELECT
								MAX(DA1_ITEM) DA1_ITEM
							FROM
								%table:DA1% DA1
							WHERE
								DA1_FILIAL = %exp:aFilCop[nT][1]%
								AND DA1_CODTAB = %exp:cCodDA0%
								AND DA1_CODPRO = %exp:SZ3->Z3_COD%
								AND DA1.%notDel%
							EndSql

							cItem := (cAliasITE)->DA1_ITEM

							(cAliasITE)->(DbCloseArea())

							//Geração do proximo registro
							While !(cAliasDA1)->(Eof())

								DA1->(DbgoTo((cAliasDA1)->RECNUM))

								aReg := {}

								For nA:=1 To Len(aStruct)

									aAdd(aReg, { aStruct[nA][1], DA1->&( aStruct[nA][1] ) } )

								Next nA

								nB := 0

								Reclock("DA1",.T.)

								For nB:=1 To Len(aReg)

									If Alltrim(aReg[nB][1]) == "DA1_XTABSQ"
										DA1->DA1_XTABSQ := cTabProc
										Loop
									EndIf

									If Alltrim(aReg[nB][1]) == "DA1_DATVIG"
										DA1->DA1_DATVIG := _dEfeti
										Loop
									EndIf

									If Alltrim(aReg[nB][1]) == "DA1_ITEM"
										DA1->DA1_ITEM := Soma1(cItem)
										Loop
									EndIf

									DA1->&( aReg[nB][1] ) := aReg[nB][2]

								Next nB

								DA1->(MsUnlock())
								//MsgInfo("Alterando aqui a tabela DA1")

								Reclock("DA1",.F.)
									DA1->DA1_XLETRA 	:= SZ3->Z3_LETRA
									DA1->DA1_XCDTAB 	:= SZ3->Z3_CODTAB
									DA1->DA1_XPRCBR 	:= SZ3->Z3_PRCVEN
									DA1->DA1_XPRCLI 	:= SZ3->Z3_PRCVEN
									DA1->DA1_XPRCRE 	:= SZ3->Z3_PRCREP
									DA1->DA1_XDESCV 	:= SZ3->Z3_DESCVEN
									DA1->DA1_XMARGEM 	:= SZ3->Z3_MARGEM
									DA1->DA1_XFATOR 	:= ZZH->ZZH_INDICE
									DA1->DA1_PRCVEN 	:= SZ3->Z3_PRCVEN
									DA1->DA1_XMARCA		:= SZ2->Z2_MARCA
								DA1->(MsUnlock())

								//Deleta Os registros
								nY := 0
								For nY:=1 To Len(aTabDel)
									DA1->(DbGoTo(aTabDel[nY]))
									Reclock("DA1",.F.)
										DA1->(DbDelete())
									DA1->(MsUnlock())
								Next nY

								(cAliasDA1)->(DbSkip())
							EndDo

							(cAliasDA1)->(DbCloseArea())

						//Else
						   //MsgInfo("lCriaReg .And. lAtualiz É FALSE")
						EndIf

					Else
						//MsgInfo("CRIANDO DA1...XXX")

						RecLock("DA1",.T.)

						DA1->DA1_FILIAL 	:= aFilCop[nT][1]
						DA1->DA1_ITEM 		:= Soma1(ProxItem(cCodDA0, SZ3->Z3_COD))
						DA1->DA1_CODTAB 	:= cCodDA0
						DA1->DA1_CODPRO 	:= SZ3->Z3_COD
						DA1->DA1_PRCVEN 	:= SZ3->Z3_PRCVEN
						DA1->DA1_ATIVO  	:= "1" 
						DA1->DA1_TPOPER 	:= "4"
						DA1->DA1_QTDLOT 	:= 999999.99
						DA1->DA1_INDLOT 	:= "000000000999999.99"
						DA1->DA1_MOEDA		:= 1
						DA1->DA1_DATVIG 	:= _dEfeti
						DA1->DA1_XLETRA 	:= Alltrim(GetMV("AN_LTRIMP")) //Ita - 26/08/2020 - Akita SZ3->Z3_LETRA
						DA1->DA1_XCDTAB 	:= SZ3->Z3_CODTAB
						DA1->DA1_XTABSQ 	:= "1"
						DA1->DA1_XPRCBR 	:= SZ3->Z3_PRCVEN
						DA1->DA1_XPRCLI 	:= SZ3->Z3_PRCVEN
						DA1->DA1_XPRCRE 	:= SZ3->Z3_PRCREP
						DA1->DA1_XDESCV 	:= SZ3->Z3_DESCVEN
						DA1->DA1_XMARGEM 	:= SZ3->Z3_MARGEM
						DA1->DA1_XFATOR 	:= ZZH->ZZH_INDICE
						DA1->DA1_XMARCA		:= SZ2->Z2_MARCA
						DA1->(MsUnLock())
					EndIf
					If !Empty(cCodMestre)
						u_TabPrcMest(aFilCop[nT][1], cCodDA0, cCodMestre, SZ3->Z3_COD)
					Endif
					SZ3->(DbSkip())
					_nSZ3 ++
				EndDo
			//Else
			   //MsgInfo("Não encontrei na SZ3")
			EndIf
			RecLock("SZ2",.F.)
			Replace Z2_STATUS with '2'
			Replace Z2_DTEFETI with _dEfeti
			Replace Z2_USUEFET with __cUserID
			SZ2->(MsUnLock())
		//Else
		   //MsgInfo("Não encontrei na SZ2")
		EndIf
	Next nT
	cFilAnt := cFilOri
Return()
//---------------------------------------------------------------------------------------------------------------------------
//
Static Function fFtDscCb(nPrcLista,aDesconto,nMoeda)//FtDescCab(nPrcLista,aDesconto,nMoeda)

Local nPrcVen := nPrcLista
Local nX      := 0
Local nRet    := 0

For nX := 1 To Len(aDesconto)
	If aDesconto[nX] <> 0
		nPrcVen := nPrcVen * ( 1 - ( aDesconto[nX]/100 ) )
	EndIf
Next nX
nPrcVen := A410Arred(nPrcVen,"D2_PRCVEN",nMoeda)
Return(nPrcVen)
///////////////////////////////////
/// Ita - Função fStatTab()
///     - Checa se a tabela está com
///        importação em andamento, para
///        evitar exclusão durante este
///        processo.
Static Function fStatTab(_cCodTab)
    //_lContDel := .T.
	//_cQuery := " SELECT SZ2.Z2_CODTAB,SZ2.Z2_STATUS "
	_cQuery := " SELECT COUNT(*) NTTTAB"
	_cQuery += "        FROM "+RetSQLName("SZ2")+" SZ2 "
	_cQuery += "       WHERE SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"'"
	_cQuery += "         AND SZ2.Z2_CODTAB = '"+_cCodTab+"'"
	_cQuery += "         AND SZ2.Z2_STATUS = '4'"
	_cQuery += "         AND SZ2.D_E_L_E_T_ <> '*'"
	MemoWrite("C:\TEMP\fStatTab.SQL",_cQuery)
	TCQuery _cQuery NEW ALIAS "XSZ2"
	DbSelectArea("XSZ2") 
	_lContDel := If(XSZ2->NTTTAB>0,.F.,.T.)
	DbCloseArea()
	If _lContDel
	   _cTexto := " A Tabela "+_cCodTab+" tem status diferente de 4, SERÁ DELETADA"
	   MemoWrite("C:\TEMP\fStatTab.log",_cTexto)
	Else
	   _cTexto := " A Tabela "+_cCodTab+" tem status igual 4(Importação em Andamento), NÃO SERÁ DELETADA"
	   MemoWrite("C:\TEMP\fStatTab.log",_cTexto)	
	EndIf
	/*
	While XSZ2->(!Eof())
	   If XSZ2->Z2_STATUS == "4"
	      _lContDel := .F.
		  Exit
	   EndIf
	   DbSelectAra("XSZ2") 
	   DbSkip()
	EndDo
	DbSelectAra("XSZ2") 
	DbCloseArea()
	*/

Return(_lContDel)
