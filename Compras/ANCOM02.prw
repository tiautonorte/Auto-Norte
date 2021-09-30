#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWEditPanel.CH'

#DEFINE SM0_FILIAL	02

//-------------------------------------------------------------------
/*/{Protheus.doc} ANCOM02
Manutenção do Markup
@author felipe.caiado
@since 13/03/2019
/*/
//-------------------------------------------------------------------
User Function ANCOM02A()

	Local aButtons 		:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Fechar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
    Private aMarDig := {} //Ita - 30/04/2019 - Marcas Digitadas  
    Private aValMrk := {} //Ita - 30/04/2019 - Valores das Marcas Digitadas
    Private _Enter   := chr(13) + Chr(10) //Ita - 03/05/2019
	SetKEY( VK_F4, {|| 	AN007()} )
	SetKEY( VK_F5, {|| 	AN008()} )
	SetKEY( VK_F6, {|| 	FwMsgRun(Nil,{||AN011() },Nil,"Aguarde, Herdando dados...")} )//Ita - 03/05/2019 - Herdar
	SetKEY( VK_F7, {|| 	FwMsgRun(Nil,{||AN005(2) },Nil,"Aguarde, Atualizando Markup...")} )
	SetKEY( VK_F8, {|| 	FwMsgRun(Nil,{||AN006() },Nil,"Aguarde, Importando Arquivo...")} )
	SetKEY( VK_F9, {|| 	FwMsgRun(Nil,{||AN010() },Nil,"Aguarde, excluindo item...")} )
	SetKEY( VK_F10, {|| FwMsgRun(Nil,{||AN012() },Nil,"Aguarde, Aplicando Multiplicador...")} )

	FWExecView("Manutenção de MARKUP","ANCOM02",MODEL_OPERATION_UPDATE,,{|| .T.},,,aButtons	)

	SetKEY( VK_F4, NIL )
	SetKEY( VK_F5, NIL )
	SetKEY( VK_F7, NIL )
	SetKEY( VK_F8, NIL )
	SetKEY( VK_F9, NIL )
	SetKEY( VK_F10, NIL )

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Manutenção do Markup - Modelo de Dados
@author felipe.caiado
@since 13/03/2019
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZZ 	:= FWFormStruct( 1, 'ZZZ')
	Local oStruZZH 	:= FWFormStruct( 1, 'ZZH', {|cCampo| Alltrim(cCampo) $ 'ZZH_MARCA/ZZH_GRUPO/ZZH_NREDUZ'},/*lViewUsado*/ )
	Local oItemZZH 	:= FWFormStruct( 1, 'ZZH', {|cCampo| Alltrim(cCampo) $ 'ZZH_FILAN/ZZH_MKMNF/ZZH_MKNMNF/ZZH_INDICE'},/*lViewUsado*/ )
	Local oModel
	Local bLoadF	:= {|oFieldModel, lCopy| AN001(oFieldModel, lCopy)}
	Local bLoadG1 	:= {|oGridModel, lCopy| AN002(oGridModel, lCopy)}
	Local bLoadG2 	:= {|oGridModel, lCopy| AN003(oGridModel, lCopy)}

	//Estrutura do Filtro
	oStruZZZ:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Marca') , ; 		// [02] C ToolTip do campo
	'XX_USUARIO' , ;            // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	20 , ;  					// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo é virtual

	oStruZZZ:SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})
	oStruZZH:SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})
	oItemZZH:SetProperty("ZZH_FILAN",MODEL_FIELD_WHEN,{|| .F.})

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('ANCOM02M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZZZMASTER', /*cOwner*/, oStruZZZ, /*bPreValidacao*/, /*bPosValidacao*/, bLoadF)

	// Adiciona ao modelo uma estrutura de Grid
	oModel:AddGrid( 'ZZHDETAIL1', 'ZZZMASTER', oStruZZH, , /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, bLoadG1 )
	oModel:AddGrid( 'ZZHDETAIL2', 'ZZZMASTER', oItemZZH, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, bLoadG2 )

	//Chave Primaria
	oModel:SetPrimaryKey( { , })

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Manutenção do Markup' )

	oModel:GetModel( 'ZZZMASTER' ):SetOnlyView( .T. )
	oModel:GetModel( 'ZZZMASTER' ):SetOnlyQuery( .T. )

	//	oModel:GetModel( 'ZZHDETAIL1' ):SetOnlyView( .T. )
	//	oModel:GetModel( 'ZZHDETAIL1' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'ZZHDETAIL1' ):SetOptional( .T. )

	oModel:GetModel( 'ZZHDETAIL2' ):SetOnlyView( .T. )
	oModel:GetModel( 'ZZHDETAIL2' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'ZZHDETAIL2' ):SetOptional( .T. )

	oModel:GetModel( 'ZZHDETAIL1' ):SetMaxLine(99999)

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZZZMASTER' ):SetDescription( 'Manutenção do Markup' )
	oModel:GetModel( 'ZZHDETAIL1' ):SetDescription( 'Manutenção do Markup' )
	oModel:GetModel( 'ZZHDETAIL2' ):SetDescription( 'Manutenção do Markup' )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Manutenção do Markup - Interface com usuário
@author felipe.caiado
@since 13/03/2019
@version undefined

@type function
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   	:= FWLoadModel( 'ANCOM02' )
	// Cria a estrutura a ser usada na View
	Local oStruZZZ 	:= FWFormStruct( 2, 'ZZZ')
	Local oStruZZH 	:= FWFormStruct( 2, 'ZZH', {|cCampo| Alltrim(cCampo) $ 'ZZH_MARCA/ZZH_GRUPO/ZZH_NREDUZ'} )
	Local oItemZZH 	:= FWFormStruct( 2, 'ZZH', {|cCampo| Alltrim(cCampo) $ 'ZZH_FILAN/ZZH_MKMNF/ZZH_MKNMNF/ZZH_INDICE'} )
	Local oView
	Local cOrdem 	:= "00"

	cOrdem := Soma1( cOrdem )
	oStruZZZ:AddField( ;            	// Ord. Tipo Desc.
	'XX_USUARIO'					, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Usuário'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Usuário' )			, ; // [04]  C   Descricao do campo
	{ 'Usuário' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo é alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo é virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha após o campo

	oStruZZH:SetProperty("ZZH_MARCA", MVC_VIEW_TITULO , "Fornecedor")
	oStruZZH:SetProperty("ZZH_GRUPO", MVC_VIEW_TITULO , "Linha")
	oStruZZH:SetProperty("ZZH_NREDUZ", MVC_VIEW_TITULO , "Nome Fornec / Linha")

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZZ', oStruZZZ, 'ZZZMASTER' )

	//Adiciona no nosso View um controle do tipo Grid(antiga GetDados)
	oView:AddGrid( 'VIEW_ZZH1', oStruZZH, 'ZZHDETAIL1' )
	oView:AddGrid( 'VIEW_ZZH2', oItemZZH, 'ZZHDETAIL2' )

	oView:SetViewProperty('VIEW_ZZH1', "CHANGELINE", {{ |oView, cViewID| AN004() }} ) //Mudança de linha
	oView:SetViewProperty("VIEW_ZZH1", "GRIDDOUBLECLICK", {{|oFormulario,cFieldName,nLineGrid,nLineModel| AN005(1)}})//Duplo Clique
	oView:SetViewProperty("VIEW_ZZH1", "GRIDSEEK", {.T.}) //Habilita a pesquisa

	oView:AddUserButton( 'Incluir (F4)', 'CLIPS', { |oView| AN007() },, )
	oView:AddUserButton( 'Salvar (F5)', 'CLIPS', { |oView| AN008() },, )
	oView:AddUserButton( 'Herdar (F6)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN011() },Nil,"Aguarde, Herdando dados...") },, )//Ita - 03/05/2019 - Herdar
	oView:AddUserButton( 'Atualização (F7)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN005(2) },Nil,"Aguarde, Atualizando Markup...") },, )
	oView:AddUserButton( 'Importar Arquivo (F8)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN006() },Nil,"Aguarde, Importando Arquivo...") },, )
	oView:AddUserButton( 'Excluir (F9)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN010() },Nil,"Aguarde, excluindo item...") },, )
	oView:AddUserButton( 'Fator Mult.Markup (F10)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN012() },Nil,"Aguarde, Aplicando Fator...") },, )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 0 )
	oView:CreateHorizontalBox( 'INFERIOR' , 100 )
	oView:CreateVerticalBox( 'INFESQ' , 50,'INFERIOR'  )
	oView:CreateVerticalBox( 'INFDIR' ,50,'INFERIOR'  )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZZ', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZZH1', 'INFESQ' )
	oView:SetOwnerView( 'VIEW_ZZH2', 'INFDIR' )

	oView:SetOnlyView( "VIEW_ZZZ")
	//	oView:SetOnlyView( "VIEW_ZZH1")
	//	oView:SetOnlyView( "VIEW_ZZH2")

	//Indica se a janela deve ser fechada ao final da operação. Se ele retornar .T. (verdadeiro) fecha a janela
	oView:bCloseOnOK := {|| .T.}
	cpares:=""

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} AN001
Carga do Cabeçalho
@author felipe.caiado
@since 26/03/2019
@version 1.0
@param oFieldModel, object, Modelo
@param lCopy, logical, Copia?
@type function
/*/
//-------------------------------------------------------------------
Static Function AN001(oFieldModel, lCopy)

	Local aLoad as Array

	aLoad := {}

	//Carrega os dados
	aAdd(aLoad, {""}) //dados
	aAdd(aLoad, 1) //recno

Return(aLoad)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN002
Carga na grid de Fornecedor
@author felipe.caiado
@since 26/03/2019
@version 1.0
@param oGridModel, object, Modelo
@param lCopy, logical, Copia?
@type function
/*/
//-------------------------------------------------------------------
Static Function AN002(oGridModel, lCopy)

	Local aLoad 	as Array
	Local cAliasZZH	as character
	Local cNome		as character

	cAliasZZH 	:= GetNextAlias()
	cNome 		:= ""

	BeginSQL alias cAliasZZH
		SELECT
		ZZH_MARCA,
		ZZH_GRUPO
		FROM
		%table:ZZH% ZZH
		WHERE
		ZZH_FILIAL = %exp:xFilial("ZZH")%
		AND ZZH_MARCA <> '       '
		AND ZZH.%notDel%
		GROUP BY
		ZZH_MARCA,
		ZZH_GRUPO
		ORDER BY
		ZZH_MARCA,
		ZZH_GRUPO
	EndSql

	aLoad := {}

	While (cAliasZZH)->( !Eof() )

		//Nome do Fornecedor ou Linha
		If Empty((cAliasZZH)->ZZH_GRUPO)
			DbSelectArea("ZZM")
			ZZM->(DbSetOrder(2))//ZZM_FILIAL+ZZM_CODMAR
			If ZZM->(DbSeek(xFilial("ZZM")+(cAliasZZH)->ZZH_MARCA))

				DbSelectArea("SA2")
				SA2->(DbSetOrder(1))//A2_FILIAL+A2_FORNECE+A2_LOJA
				If SA2->(DbSeek(xFilial("SA2")+ZZM->ZZM_FORNEC+ZZM->ZZM_LOJA))
					cNome := SA2->A2_NOME
				Else
					cNome := ""
				EndIf

			Else

				cNome := ""

			EndIf
		Else

			DbSelectArea("ZZ8")
			ZZ8->(DbSetOrder(1))//ZZ8_FILIAL+ZZ8_LINHA
			If ZZ8->(DbSeek(xFilial("ZZ8")+(cAliasZZH)->ZZH_GRUPO))
				cNome := ZZ8->ZZ8_DESCRI
			Else
				cNome := ""
			EndIf

		EndIf
        /////////////////////////////
        /// Ita - 29/04/2019 
        ///     - Nome Fornece/Linha
        If Empty(cNome)
           cNome := Posicione("ZZH",1,xFilial("ZZH")+(cAliasZZH)->(ZZH_MARCA+ZZH_GRUPO),"ZZH_NREDUZ")
           If Empty(cNome)
              cNome := Posicione("ZZH",1,xFilial("ZZH")+(cAliasZZH)->ZZH_MARCA,"ZZH_NREDUZ")
           EndIf
        EndIf
        
		aAdd(aLoad,{0,{(cAliasZZH)->ZZH_MARCA, (cAliasZZH)->ZZH_GRUPO, cNome}})

		(cAliasZZH)->( DbSkip() )

	EndDo

	(cAliasZZH)->( DbCloseArea() )


Return(aLoad)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN003
Carga na grid de Valores
@author felipe.caiado
@since 26/03/2019
@version 1.0
@param oGridModel, object, Modelo
@param lCopy, logical, Copia?
@type function
/*/
//-------------------------------------------------------------------
Static Function AN003(oGridModel, lCopy)

	Local aLoad 	as Array
	Local cAliasZZH	as character

	cAliasZZH 	:= GetNextAlias()

	BeginSQL alias cAliasZZH
		SELECT
		ZZH_FILAN,
		ZZH_MKMNF,
		ZZH_MKNMNF,
		ZZH_INDICE
		FROM
		%table:ZZH% ZZH
		WHERE
		ZZH_FILIAL = %exp:xFilial("ZZH")%
		AND ZZH_MARCA = '3RHO ' //Ita - 08/05/2019 ????? - Marca fixa???
		AND ZZH_GRUPO = '     '
		AND ZZH.%notDel%
		ORDER BY
		ZZH_FILAN
	EndSql

	aLoad := {}

	While (cAliasZZH)->( !Eof() )

		aAdd(aLoad,{0,{(cAliasZZH)->ZZH_FILAN, (cAliasZZH)->ZZH_MKMNF, (cAliasZZH)->ZZH_MKNMNF, (cAliasZZH)->ZZH_INDICE}})

		(cAliasZZH)->( DbSkip() )

	EndDo

	(cAliasZZH)->( DbCloseArea() )

Return(aLoad)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN004
Atualiza registro de valores
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN004()

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local oZZH2Mod  	:= oModel:GetModel( 'ZZHDETAIL2' )
	Local cAliasZZH		:= GetNextAlias()
	Local cMarca		:= ""
	Local cLinha		:= ""
	Local nLinhaZZH  	:= 1

	cMarca := oZZH1Mod:GetValue("ZZH_MARCA")
	cLinha := oZZH1Mod:GetValue("ZZH_GRUPO")

	//Limpa o Grid
	oZZH2Mod:ClearData(.F.,.T.)
    lAchouZZH := .F. //Ita - 30/04/2019
	DbSelectArea("ZZH")
	ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
	If ZZH->(DbSeek(xFilial("ZZH")+cMarca+cLinha))

		//Alimenta o Grid de Valores
		While !ZZH->(Eof()) .And. xFilial("ZZH")+cMarca+cLinha == ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO

			oZZH2Mod:SetNoInsertLine(.F.)
            
			If nLinhaZZH > 1
				If oZZH2Mod:AddLine() <> nLinhaZZH
					Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
					Loop
				EndIf
			EndIf
            
			oZZH2Mod:SetNoInsertLine(.T.)

			lUpdCNF := oZZH2Mod:CanUpdateLine()

			If !lUpdCNF
				oZZH2Mod:SetNoUpdateLine(.F.)
			EndIf

			oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

			oZZH2Mod:SetValue( 'ZZH_FILAN',ZZH->ZZH_FILAN )
			oZZH2Mod:SetValue( 'ZZH_MKMNF',ZZH->ZZH_MKMNF )
			oZZH2Mod:SetValue( 'ZZH_MKNMNF',ZZH->ZZH_MKNMNF )
			oZZH2Mod:SetValue( 'ZZH_INDICE',ZZH->ZZH_INDICE )

			lAchouZZH := .T. //Ita - 30/04/2019
			 
			oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})

			oZZH2Mod:SetNoUpdateLine(!lUpdCNF)

			nLinhaZZH++

			ZZH->(DbSkip())

		Enddo

	EndIf
	
	/////////////////////////////////////////////////
	/// Ita - 30/04/2019
	///     - Carrega variáveis do array temporário.
	///     - aValMrk
	
	If !lAchouZZH

	   //Ita - 08/05/2019 - nPsLM := aScan(aValMrk,{ | x | x[2]+x[1] == cLinha+cMarca }) //Ordenado por Linha(Grupo) + Marca(Fornecedor)
	   nPsLM := aScan(aValMrk,{ | x | x[1]+x[2] == cMarca+cLinha }) //Ordenado por Marca(Fornecedor) + Linha(Grupo) + Filial AN
	    
	   //For nPrc := nPsLM To Len(aValMrk)
	   For nPrc := 1 To Len(aValMrk)
          
          //Ita - 08/05/2019 - If aValMrk[nPrc,2]+aValMrk[nPrc,1] == cLinha+cMarca
          If aValMrk[nPrc,1]+aValMrk[nPrc,2] == cMarca+cLinha
			
			 oZZH2Mod:SetNoInsertLine(.F.)
            
			 If nLinhaZZH > 1
				If oZZH2Mod:AddLine() <> nLinhaZZH
					Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
					Loop
				EndIf
			 EndIf
            
			 oZZH2Mod:SetNoInsertLine(.T.)

			 lUpdCNF := oZZH2Mod:CanUpdateLine()

			 If !lUpdCNF
				oZZH2Mod:SetNoUpdateLine(.F.)
			 EndIf

			 oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

            
             //               ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
             //                  1         2         3             4              5             6                7
             //aAdd(aValMrk, {MV_PAR01 ,MV_PAR02 ,MV_PAR03,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
	         //cMarca := oZZH1Mod:GetValue("ZZH_MARCA")
	         //cLinha := oZZH1Mod:GetValue("ZZH_GRUPO")
	         //If aValMrk[nPrc,1] == cMarca .And. aValMrk[nPrc,2] == cLinha
			    
			    oZZH2Mod:SetValue( 'ZZH_FILAN',aValMrk[nPrc,4] ) //ZZH->ZZH_FILAN )
			    oZZH2Mod:SetValue( 'ZZH_MKMNF',aValMrk[nPrc,5] ) //ZZH->ZZH_MKMNF )
			    oZZH2Mod:SetValue( 'ZZH_MKNMNF',aValMrk[nPrc,6] ) //ZZH->ZZH_MKNMNF )
			    oZZH2Mod:SetValue( 'ZZH_INDICE',aValMrk[nPrc,7] ) //ZZH->ZZH_INDICE )


             //EndIf
            
             oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})

             oZZH2Mod:SetNoUpdateLine(!lUpdCNF)
		  	   
			 nLinhaZZH++
	      
	      EndIf
	      		
       Next nPrc 
    EndIf

	oZZH2Mod:GoLine(1)

	oView:Refresh('VIEW_ZZH2')

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN012
Aplicar Fator Multiplicador Markup
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN012(nTipo)

	Local oModel     	:= FWModelActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local cMarca		:= ""
	Local cLinha		:= ""

	cMarca := oZZH1Mod:GetValue("ZZH_MARCA")
	cLinha := oZZH1Mod:GetValue("ZZH_GRUPO")

	aRet 	:= {}
	aPerg	:= {}

	aAdd( aPerg ,{1,Alltrim("Marca"),Iif(nTipo==1,oZZH1Mod:GetValue("ZZH_MARCA"),Space(05)),"@!",".T.","",Iif(nTipo==1,".F.",".T."),30,.F.})
	aAdd( aPerg ,{1,Alltrim("Linha"),Iif(nTipo==1,oZZH1Mod:GetValue("ZZH_GRUPO"),Space(05)),"@!",".T.","",Iif(nTipo==1,".F.",".T."),30,.F.})
	aAdd( aPerg ,{1,Alltrim("Filial"),Space(06),"@!",".T.","SM0","",30,.T.})
	aAdd( aPerg ,{1,Alltrim("Fator Mult. Markup Monofásico"),0.00,"@E 999.99",".T.","","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Fator Mult. Markup Não Monofásico"),0.00,"@E 999.99",".T.","","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Fator Mult. Indice"),0.00,"@E 999.99",".T.","","",30,.F.})

	//Mostra tela de Parâmetros
	If !ParamBox(aPerg ,"Fator Multiplicador do Markup",@aRet)
		Return()
	EndIf

	//Verifica se existe parâmetro vazio
	If Empty(MV_PAR03)
		ApMsgInfo("Favor preencher todos os parâmetros obrigatorios")
		Return()
	EndIf
	If ApMsgYesNo("Confirma atualização do Fator Multiplicador do Markup?")
		If !Empty(MV_PAR02)
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(xFilial("ZZH")+MV_PAR01+MV_PAR02+MV_PAR03))
				Reclock("ZZH",.F.)
				If MV_PAR04 > 0
					ZZH->ZZH_MKMNF	:= ((((ZZH->ZZH_MKMNF/100)+1) * mv_par04)-1) * 100
				EndIf
				If MV_PAR05 > 0
					ZZH->ZZH_MKNMNF	:= ((((ZZH->ZZH_MKNMNF/100)+1) * mv_par05)-1) * 100
				EndIf
				If MV_PAR06 > 0
					ZZH->ZZH_INDICE	:= ZZH->ZZH_INDICE * MV_PAR06
				EndIf
				ZZH->(MsUnlock())
			EndIf
		Else
			If !Empty(mv_par01)
				cSeek  := xFilial("ZZH")+MV_PAR01
				cWhile := 'ZZH_FILIAL+ZZH_MARCA'
			Else
				cSeek  := xFilial("ZZH")
				cWhile := 'ZZH_FILIAL'
			Endif
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))								//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(cSeek))
				While !ZZH->(Eof()) .And. cSeek == &(cWhile)
					If ZZH->ZZH_FILAN == MV_PAR03
						Reclock("ZZH",.F.)
						If MV_PAR04 > 0
							ZZH->ZZH_MKMNF	:= ((((ZZH->ZZH_MKMNF/100)+1) * mv_par04)-1) * 100
						EndIf
						If MV_PAR05 > 0
							ZZH->ZZH_MKNMNF	:= ((((ZZH->ZZH_MKNMNF/100)+1) * mv_par05)-1) * 100
						EndIf
						If MV_PAR06 > 0
							ZZH->ZZH_INDICE	:= ZZH->ZZH_INDICE * MV_PAR06
						EndIf
						ZZH->(MsUnlock())
					EndIf
					ZZH->(DbSkip())
				EndDo
			EndIf
		EndIf
	EndIf
	//Atualiza Grid
	AN004()
	Return
//-------------------------------------------------------------------
/*/{Protheus.doc} AN005
Alterar valores
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN005(nTipo)

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local cMarca		:= ""
	Local cLinha		:= ""

	cMarca := oZZH1Mod:GetValue("ZZH_MARCA")
	cLinha := oZZH1Mod:GetValue("ZZH_GRUPO")

	aRet 	:= {}
	aPerg	:= {}

	aAdd( aPerg ,{1,Alltrim("Marca"),Iif(nTipo==1,oZZH1Mod:GetValue("ZZH_MARCA"),Space(05)),"@!",".T.","",Iif(nTipo==1,".F.",".T."),30,.T.})
	aAdd( aPerg ,{1,Alltrim("Linha"),Iif(nTipo==1,oZZH1Mod:GetValue("ZZH_GRUPO"),Space(05)),"@!",".T.","",Iif(nTipo==1,".F.",".T."),30,.F.})
	aAdd( aPerg ,{1,Alltrim("Filial"),Space(06),"@!",".T.","SM0","",30,.T.})
	aAdd( aPerg ,{1,Alltrim("Markup Monofásico"),0.00,"@E 999.99",".T.","","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Markup Não Monofásico"),0.00,"@E 999.99",".T.","","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Fator"),0.00,"@E 999.9999",".T.","","",30,.F.})

	//Mostra tela de Parâmetros
	If !ParamBox(aPerg ,"Atualização de Markup",@aRet)
		Return()
	EndIf

	//Verifica se existe parâmetro vazio
	If Empty(MV_PAR01) .Or. Empty(MV_PAR03)
		ApMsgInfo("Favor preencher todos os parâmetros")
		Return()
	EndIf

	If ApMsgYesNo("Confirma atualização do Markup?")

		If !Empty(MV_PAR02)
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(xFilial("ZZH")+MV_PAR01+MV_PAR02+MV_PAR03))
				Reclock("ZZH",.F.)
				If MV_PAR04 > 0
					ZZH->ZZH_MKMNF	:= MV_PAR04
				EndIf
				If MV_PAR05 > 0
					ZZH->ZZH_MKNMNF	:= MV_PAR05
				EndIf
				If MV_PAR06 > 0
					ZZH->ZZH_INDICE	:= MV_PAR06
				EndIf
				ZZH->(MsUnlock())
			EndIf
		Else
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(xFilial("ZZH")+MV_PAR01))
				While !ZZH->(Eof()) .And. xFilial("ZZH")+MV_PAR01 == ZZH_FILIAL+ZZH_MARCA

					If ZZH->ZZH_FILAN == MV_PAR03

						Reclock("ZZH",.F.)
						If MV_PAR04 > 0
							ZZH->ZZH_MKMNF	:= MV_PAR04
						EndIf
						If MV_PAR05 > 0
							ZZH->ZZH_MKNMNF	:= MV_PAR05
						EndIf
						If MV_PAR06 > 0
							ZZH->ZZH_INDICE	:= MV_PAR06
						EndIf
						ZZH->(MsUnlock())

					EndIf

					ZZH->(DbSkip())

				EndDo
			EndIf
		EndIf

	EndIf

	//Atualiza Grid
	AN004()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN006
Importar Arquivo CSV
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN006()

	Local cArq			:= ""

	//Busca o arquivo a ser importado
	cArq := AllTrim( cGetFile( 'Arquivo csv| *.csv |Arquivo texto | *.txt', 'Selecione o arquivo', 0, "", .T.,  GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE  ) )

	If Empty(cArq)
		ApMsgInfo("Favor escolher o arquivo")
		Return()
	EndIf

	If !ApMsgYesNo("Deseja importar o arquivo selecionado?")
		Return()
	EndIf

	//Abre o arquivo para uso
	FT_FUSE(cArq)

	//Posiciona no inicio do arquivo
	FT_FGOTOP()

	While ( !FT_FEOF() )

		// Guarda o conteudo da Linha processada
		cLin := Alltrim( FT_FREADLN() )

		aSepLin := Separa(cLin, ";")

		aSepLin[4] := StrTran(aSepLin[4],",",".")
		aSepLin[5] := StrTran(aSepLin[5],",",".")
		aSepLin[6] := StrTran(aSepLin[6],",",".")

		If !Empty(aSepLin[2])
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(xFilial("ZZH")+PadR(aSepLin[1],5)+PadR(aSepLin[2],5)+aSepLin[3]))
				Reclock("ZZH",.F.)
				If Val(aSepLin[4]) > 0
					ZZH->ZZH_MKMNF	:= Val(aSepLin[4])
				EndIf
				If Val(aSepLin[5]) > 0
					ZZH->ZZH_MKNMNF	:= Val(aSepLin[5])
				EndIf
				If Val(aSepLin[6]) > 0
					ZZH->ZZH_INDICE	:= Val(aSepLin[6])
				EndIf
				ZZH->(MsUnlock())
			EndIf
		Else
			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(xFilial("ZZH")+PadR(aSepLin[1],5)))
				While !ZZH->(Eof()) .And. xFilial("ZZH")+PadR(aSepLin[1],5) == ZZH_FILIAL+ZZH_MARCA

					If ZZH->ZZH_FILAN == aSepLin[3]

						Reclock("ZZH",.F.)
						If Val(aSepLin[4]) > 0
							ZZH->ZZH_MKMNF	:= Val(aSepLin[4])
						EndIf
						If Val(aSepLin[5]) > 0
							ZZH->ZZH_MKNMNF	:= Val(aSepLin[5])
						EndIf
						If Val(aSepLin[6]) > 0
							ZZH->ZZH_INDICE	:= Val(aSepLin[6])
						EndIf
						ZZH->(MsUnlock())

					EndIf

					ZZH->(DbSkip())

				EndDo
			EndIf
		EndIf

		//Proxima linha
		FT_FSKIP()

	Enddo

	//Fechar Arquivo
	FT_FUSE()

	ApMsgInfo("Importado com sucesso")

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN007
Incluir Nova Linha e Marca
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------

Static Function AN007()

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local oZZH2Mod  	:= oModel:GetModel( 'ZZHDETAIL2' )
	Local nX			:= 0

	aPerg	:= {}
	aRet 	:= {}

	aAdd( aPerg ,{1,Alltrim("Marca"),Space(05),"@!",".T.","",".T.",30,.T.})
	aAdd( aPerg ,{1,Alltrim("Linha"),Space(05),"@!",".T.","",".T.",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Nome"),Space(40),"@!",".T.","",".T.",100,.F.})
	/* iTA - 09/05/2019
	aAdd( aPerg ,{1,Alltrim("Marca Herança"),Space(05),"@!",".T.","",".T.",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Linha Herança"),Space(05),"@!",".T.","",".T.",30,.F.})
    */
	aAdd( aPerg ,{1,Alltrim("Marca Herança") ,Space(05),"@!","u_VF4DsMarc()"  ,"ZZ7" ,".T.",5,.F.})  //5
	aAdd( aPerg ,{1,Alltrim("Linha Herança") ,Space(05),"@!","u_VF4DsLinh()"  ,"ZZ8" ,".T.",5,.F.})  //6
	
	//Mostra tela de Parâmetros
	If !ParamBox(aPerg ,"Atualização de Markup",@aRet)
		Return()
	EndIf
    If !Empty(MV_PAR04) .And. Empty(MV_PAR05)//Marca Herança
       Alert("Para herdar marca, deve-se informar uma linha especifica")
       Return()
    EndIf

    If Empty(MV_PAR04) .And. !Empty(MV_PAR05)//Linha Herança
       Alert("Para herdar linha, deve-se informar uma marca especifica")
       Return()
    EndIf
        
    ////////////////////////////////////////////////////////
    /// Ita - 02/05/2019 
    ///     - Validar duplicidade ainda em memória
    nPsM := aScan(aMarDig,{ | x | x[2]+x[1] == MV_PAR02+MV_PAR01 }) //Ordenado por Linha(Grupo) + Marca(Fornecedor)
    If nPsM > 0
		ApMsgInfo("Fornecedor e Linha já existente")
		Return()
    EndIf
			
	//Verifique se existe o codigo
	/* Ita - 08/05/2019 - Não deve checar existência no cadastro de marca
	DbSelectArea("ZZN")
	ZZN->(DbSetOrder(3))  //Ita - ZZN_FILIAL+ZZN_LINHA+ZZN_COD
	If ZZN->(DbSeek(xFilial("ZZN")+MV_PAR02+MV_PAR01))

		ApMsgInfo("Fornecedor e Linha já existente")
		Return()

	EndIf
    */
    
	//Insere linha no primeiro grid
	oZZH1Mod:SetNoInsertLine(.F.)

	oZZH1Mod:AddLine()

	oZZH1Mod:SetNoInsertLine(.T.)

	lUpdCNF := oZZH1Mod:CanUpdateLine()

	If !lUpdCNF
		oZZH1Mod:SetNoUpdateLine(.F.)
	EndIf

	oZZH1Mod:SetNoDeleteLine(.F.)

	oZZH1Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

	oZZH1Mod:GoLine(oZZH1Mod:GetLine())

	//Ita - 08/05/2019 - Evitar que a linha não seja deletada - oZZH1Mod:SetNoDeleteLine(.T.)

	oZZH1Mod:SetValue( 'ZZH_MARCA',MV_PAR01 )
	oZZH1Mod:SetValue( 'ZZH_GRUPO',MV_PAR02 )
	oZZH1Mod:SetValue( 'ZZH_NREDUZ',MV_PAR03 )
    
    aAdd(aMarDig, {MV_PAR01,MV_PAR02,MV_PAR03}) //Ita - 30/04/2019
	////////////////////////////////////////////////////////
	/// Ita - 02/05/2019 
	///     - Preparação do array para validar duplicidade
	aSort(aMarDig,,, { | x,y | x[2]+x[1] > y[2]+y[1] }) //Ordenado por Linha(Grupo) + Marca(Fornecedor)
		    
	oView:Refresh('VIEW_ZZH1')

	//Limpa o Grid
	oZZH2Mod:ClearData(.F.,.T.)

	//Dados do SM0
	aSM0 := FWLoadSM0(.T.)

	nLinhaZZH := 1

	If !Empty(MV_PAR04)
		DbSelectArea("ZZH")
		ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
		If ZZH->(DbSeek(xFilial("ZZH")+MV_PAR04+MV_PAR05))
			While !ZZH->(Eof()) .And. xFilial("ZZH")+MV_PAR04+MV_PAR05 == ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO

				oZZH2Mod:SetNoInsertLine(.F.)

				If nLinhaZZH > 1
					If oZZH2Mod:AddLine() <> nLinhaZZH
						Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
						Loop
					EndIf
				EndIf

				oZZH2Mod:SetNoInsertLine(.T.)

				lUpdCNF := oZZH2Mod:CanUpdateLine()

				If !lUpdCNF
					oZZH2Mod:SetNoUpdateLine(.F.)
				EndIf

				oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

				oZZH2Mod:SetValue( 'ZZH_FILAN',ZZH->ZZH_FILAN )
				oZZH2Mod:SetValue( 'ZZH_MKMNF',ZZH->ZZH_MKMNF )
				oZZH2Mod:SetValue( 'ZZH_MKNMNF',ZZH->ZZH_MKNMNF )
				oZZH2Mod:SetValue( 'ZZH_INDICE',ZZH->ZZH_INDICE )

				oZZH2Mod:GetStruct():SetProperty('ZZH_FILAN',MODEL_FIELD_WHEN,{||.F.})
				
                //               ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
                //                  1         2         3             4              5             6                7
                //aAdd(aValMrk, {MV_PAR01 ,MV_PAR02 ,MV_PAR03,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
				aAdd(aValMrk, {MV_PAR01,MV_PAR02,MV_PAR03,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
				 
				//oZZH2Mod:SetNoUpdateLine(!lUpdCNF)

				nLinhaZZH++

				ZZH->(DbSkip())

			EndDo
	        ////////////////////////////////////////////////////////
	        /// Ita - 02/05/2019 
	        ///     - Preparação do array para validar duplicidade
	        aSort(aValMrk,,, { | x,y | x[1]+x[2]+x[4] < y[1]+y[2]+y[4] }) //Ordenado por Marca(Fornecedor) + Linha(Grupo) + Filial AN
				
		EndIf
	    oView:Refresh('VIEW_ZZH1') //Ita - 29/04/2019
	    oView:Refresh('VIEW_ZZH2') //Ita - 30/04/2019
	Else

		For nX:= 1 To Len(aSM0)

			If Substr(aSM0[nX][SM0_FILIAL],1,2) <> "02"
				Loop
			EndIF

			oZZH2Mod:SetNoInsertLine(.F.)

			If nLinhaZZH > 1
				If oZZH2Mod:AddLine() <> nLinhaZZH
					Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
					Loop
				EndIf
			EndIf

			oZZH2Mod:SetNoInsertLine(.T.)

			lUpdCNF := oZZH2Mod:CanUpdateLine()

			If !lUpdCNF
				oZZH2Mod:SetNoUpdateLine(.F.)
			EndIf

			oZZH2Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

			oZZH2Mod:SetValue( 'ZZH_FILAN',aSM0[nX][SM0_FILIAL] )
			oZZH2Mod:SetValue( 'ZZH_MKMNF',0 )
			oZZH2Mod:SetValue( 'ZZH_MKNMNF',0 )
			oZZH2Mod:SetValue( 'ZZH_INDICE',0 )

			oZZH2Mod:GetStruct():SetProperty('ZZH_FILAN',MODEL_FIELD_WHEN,{||.F.})

            //               ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
            //                  1         2         3             4              5             6                7
            //aAdd(aValMrk, {MV_PAR01 ,MV_PAR02 ,MV_PAR03,ZZH->ZZH_FILAN, ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
			aAdd(aValMrk, {MV_PAR01,MV_PAR02,MV_PAR03,aSM0[nX][SM0_FILIAL],0            ,0              ,0              }) //Ita - 30/04/2019
				
			//oZZH2Mod:SetNoUpdateLine(!lUpdCNF)

			nLinhaZZH++

		Next nX
	    ////////////////////////////////////////////////////////
	    /// Ita - 02/05/2019 
	    ///     - Preparação do array para validar duplicidade
	    //Ita - 08/05/2019 - aSort(aValMrk,,, { | x,y | x[2]+x[1] > y[2]+y[1] }) //Ordenado por Linha(Grupo) + Marca(Fornecedor)
	    aSort(aValMrk,,, { | x,y | x[1]+x[2]+x[4] < y[1]+y[2]+y[4] }) //Ordenado por Marca(Fornecedor) + Linha(Grupo) + Filial AN
	        			
	Endif

	oZZH2Mod:GoLine(1)

	oView:Refresh('VIEW_ZZH2')

	oView:GetViewObj("VIEW_ZZH2")[3]:oBrowse:oBrowse:SetFocus()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN008
Salvar Dados
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------

Static Function AN008()

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local oZZH2Mod  	:= oModel:GetModel( 'ZZHDETAIL2' )
	Local nY			:= 0
	//MsgInfo("oZZH1Mod:Length(): "+Alltrim(Str(oZZH1Mod:Length()))+" oZZH2Mod:Length(): "+Alltrim(Str(oZZH2Mod:Length())))
	//               ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
	//aAdd(aMarDig, {MV_PAR01 ,MV_PAR02 ,MV_PAR03}) //Ita - 30/04/2019
	
	/////////////////////////////////////////////////////////
	/// Ita - 30/04/2019
	///     - Implementar laço para gravar todas as
	///     - marcas/linhas lançadas via tecla de função F4
	If Empty(aMarDig) //Ita - 08/05/2019 - Evitar F5 - inconsistente.
       
       oView:Refresh('VIEW_ZZH1') //Ita - 29/04/2019  
       oView:Refresh('VIEW_ZZH2') //Ita - 30/04/2019
	   oView:GetViewObj("VIEW_ZZH1")[3]:oBrowse:oBrowse:SetFocus()
	   FwMsgRun(Nil,{||AN009() },Nil,"Aguarde, Atualizando...")
	   pare:=""
	   Return
	   
	EndIf
	For nPrc := 1 To Len(aMarDig)
	
		Begin Transaction
	        cpare:="" 
	        ///////////////////////////
	        /// Ita - 07/05/2019
	        ///     - Para garantir a integridade de dados
	        ///     - será gravado antes a marca informada
			If !Empty(aMarDig[nPrc,1])//oZZH1Mod:GetValue("ZZH_MARCA"))
	            
				DbSelectArea("ZZ7")
				ZZ7->(DbSetOrder(1)) //ZZ7_FILIAL+ZZ7_MARCA
				If !ZZ7->(DbSeek(xFilial("ZZ7")+aMarDig[nPrc,1])) //oZZH1Mod:GetValue("ZZH_GRUPO")))
	
					Reclock("ZZ7",.T.)
					ZZ7->ZZ7_FILIAL	:= xFilial("ZZ7")
					ZZ7->ZZ7_MARCA	:= aMarDig[nPrc,1] //oZZH1Mod:GetValue("ZZH_GRUPO")
					ZZ7->ZZ7_DESCRI	:= aMarDig[nPrc,3] //oZZH1Mod:GetValue("ZZH_NREDUZ")
					SZ7->(MsUnlock())
	
	
				EndIf
	
			EndIf
	        
			If !Empty(aMarDig[nPrc,2])//oZZH1Mod:GetValue("ZZH_GRUPO"))
	            
				DbSelectArea("ZZ8")
				ZZ8->(DbSetOrder(1))
				If !ZZ8->(DbSeek(xFilial("ZZ8")+aMarDig[nPrc,2])) //oZZH1Mod:GetValue("ZZH_GRUPO")))
	
					Reclock("ZZ8",.T.)
					ZZ8->ZZ8_FILIAL	:= xFilial("ZZ8")
					ZZ8->ZZ8_LINHA	:= aMarDig[nPrc,2] //oZZH1Mod:GetValue("ZZH_GRUPO")
					ZZ8->ZZ8_DESCRI	:= aMarDig[nPrc,3] //oZZH1Mod:GetValue("ZZH_NREDUZ")
					SZ8->(MsUnlock())
	
	
				EndIf
	
			EndIf
	
			DbSelectArea("ZZN")
			ZZN->(DbSetOrder(1))//ZZN_FILIAL+ZZN_COD+ZZN_LINHA
			//Ita - 30/04/2019 - If !ZZN->(DbSeek(xFilial("ZZN")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH1Mod:GetValue("ZZH_MARCA")))
			If !ZZN->(DbSeek(xFilial("ZZN")+aMarDig[nPrc,1]+aMarDig[nPrc,2]))
	
				Reclock("ZZN",.T.)
				ZZN->ZZN_FILIAL := xFilial("ZZN")
				ZZN->ZZN_COD 	:= aMarDig[nPrc,1] //oZZH1Mod:GetValue("ZZH_MARCA")
				ZZN->ZZN_DESCRI := ""
				ZZN->ZZN_LINHA 	:= aMarDig[nPrc,2] //oZZH1Mod:GetValue("ZZH_GRUPO")
				ZZN->ZZN_DESLIN := aMarDig[nPrc,3] //oZZH1Mod:GetValue("ZZH_NREDUZ")
				ZZN->(MsUnlock())
	
	
			EndIf
	
            //               ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
            //                  1         2         3             4              5             6                7
            //aAdd(aValMrk, {MV_PAR01 ,MV_PAR02 ,MV_PAR03,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
	        aGrvVMrk := {}
	        For nTm := 1 To Len(aValMrk)
	           If aValMrk[nTm,1]+aValMrk[nTm,2] == aMarDig[nPrc,1]+aMarDig[nPrc,2]
	              aAdd(aGrvVMrk, { aValMrk[nTm,1],aValMrk[nTm,2],aValMrk[nTm,3],aValMrk[nTm,4],aValMrk[nTm,5],aValMrk[nTm,6],aValMrk[nTm,7] })
	           EndIf
	        Next nTm
	        aSort(aGrvVMrk,,, { | x,y | x[1]+x[2]+[4] < y[1]+y[2]+[3] }) //Ita - 08/05/2019 - Ordenado por Marca(Fornecedor) + Linha(Grupo) + Filial AN
	         
			For nY := 1 to Len(aGrvVMrk) //oZZH2Mod:Length()
	
				//oZZH2Mod:GoLine(nY)
	
				DbSelectArea("ZZH")
				ZZH->(DbSetOrder(1)) //Ita - ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
				//Ita - 30/04/2019 - If !ZZH->(DbSeek(xFilial("ZZH")+oZZH1Mod:GetValue("ZZH_MARCA")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH2Mod:GetValue("ZZH_FILAN")))
				If !ZZH->(DbSeek(xFilial("ZZH")+aGrvVMrk[nY,1]+aGrvVMrk[nY,2]+aGrvVMrk[nY,4]))
	
					Reclock("ZZH",.T.)
					ZZH->ZZH_FILIAL := xFilial("ZZH")
					ZZH->ZZH_MARCA 	:= aGrvVMrk[nY,1] //oZZH1Mod:GetValue("ZZH_MARCA")
					ZZH->ZZH_GRUPO 	:= aGrvVMrk[nY,2] //oZZH1Mod:GetValue("ZZH_GRUPO")
					ZZH->ZZH_NREDUZ := aGrvVMrk[nY,3] //oZZH1Mod:GetValue("ZZH_NREDUZ") 
					ZZH->ZZH_FILAN 	:= aGrvVMrk[nY,4]  //oZZH2Mod:GetValue("ZZH_FILAN")
					If !Empty(aMarDig[nPrc,2]) //Ita - 30/04/2019
					   ZZH->ZZH_MKMNF  := aGrvVMrk[nY,5] //oZZH2Mod:GetValue("ZZH_MKMNF")
					   ZZH->ZZH_MKNMNF := aGrvVMrk[nY,6] //oZZH2Mod:GetValue("ZZH_MKNMNF")
					   //MsgInfo("aGrvVMrk[nY,7]: "+Alltrim(Str(aGrvVMrk[nY,7]))+" NoRound( aGrvVMrk[nY,7], 4 ): "+Alltrim(Str(NoRound( aGrvVMrk[nY,7], 4 ))))
					   ZZH->ZZH_INDICE := NoRound( aGrvVMrk[nY,7], 4 ) //oZZH2Mod:GetValue("ZZH_INDICE")
					EndIf
					ZZH->(MsUnlock())
	
				Else
	                //If !Empty(aMarDig[nPrc,2]) //Ita - 30/04/2019 
					   Reclock("ZZH",.F.)
					   ZZH->ZZH_MKMNF  := aGrvVMrk[nY,5] //oZZH2Mod:GetValue("ZZH_MKMNF")
					   ZZH->ZZH_MKNMNF := aGrvVMrk[nY,6] //oZZH2Mod:GetValue("ZZH_MKNMNF")
					   ZZH->ZZH_INDICE := NoRound( aGrvVMrk[nY,7], 4 ) //oZZH2Mod:GetValue("ZZH_INDICE")
					   ZZH->(MsUnlock())
					//EndIf
	
	
				EndIf
	
			Next nY

		End Transaction
	
	Next nPrc
	aMarDig := {} //Ita - 08/05/2019 - Zera digitação em memória já salva
	aValMrk := {} //Ita - 08/05/2019 - Zera digitação em memória já salva
	aGrvVMrk:= {} //Ita - 08/05/2019 - Zera digitação em memória já salva
	    
    oView:Refresh('VIEW_ZZH1') //Ita - 29/04/2019  
    oView:Refresh('VIEW_ZZH2') //Ita - 30/04/2019
	oView:GetViewObj("VIEW_ZZH1")[3]:oBrowse:oBrowse:SetFocus()

	FwMsgRun(Nil,{||AN009() },Nil,"Aguarde, Atualizando...")

    
	ApMsgInfo("Salvo com sucesso")

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN009
Carga na grid de Fornecedor
@author felipe.caiado
@since 26/03/2019
@version 1.0
@param oGridModel, object, Modelo
@param lCopy, logical, Copia?
@type function
/*/
//-------------------------------------------------------------------
Static Function AN009()

	Local cAliasZZH	as character
	Local cNome		as character
	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local oZZH2Mod  	:= oModel:GetModel( 'ZZHDETAIL2' )
	Local nLinhaZZH		:= 1

	cAliasZZH 	:= GetNextAlias()
	cNome 		:= ""

	BeginSQL alias cAliasZZH
		SELECT
		ZZH_MARCA,
		ZZH_GRUPO
		FROM
		%table:ZZH% ZZH
		WHERE
		ZZH_FILIAL = %exp:xFilial("ZZH")%
		AND ZZH_MARCA <> '       '
		AND ZZH.%notDel%
		GROUP BY
		ZZH_MARCA,
		ZZH_GRUPO
		ORDER BY
		ZZH_MARCA,
		ZZH_GRUPO
	EndSql

	oZZH1Mod:ClearData(.F.,.T.)

	While !(cAliasZZH)->(Eof())

		oZZH1Mod:SetNoInsertLine(.F.)

		If nLinhaZZH > 1
			If oZZH1Mod:AddLine() <> nLinhaZZH
				Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
				Loop
			EndIf
		EndIf

		oZZH1Mod:SetNoInsertLine(.T.)

		lUpdCNF := oZZH1Mod:CanUpdateLine()

		If !lUpdCNF
			oZZH1Mod:SetNoUpdateLine(.F.)
		EndIf

		oZZH1Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

		//Nome do Fornecedor ou Linha
		If Empty((cAliasZZH)->ZZH_GRUPO)
			DbSelectArea("ZZM")
			ZZM->(DbSetOrder(2))//ZZM_FILIAL+ZZM_CODMAR
			If ZZM->(DbSeek(xFilial("ZZM")+(cAliasZZH)->ZZH_MARCA))

				DbSelectArea("SA2")
				SA2->(DbSetOrder(1))//A2_FILIAL+A2_FORNECE+A2_LOJA
				If SA2->(DbSeek(xFilial("SA2")+ZZM->ZZM_FORNEC+ZZM->ZZM_LOJA))
					cNome := SA2->A2_NOME
				Else
					cNome := ""
				EndIf

			Else

				cNome := ""

			EndIf
		Else

			DbSelectArea("ZZ8")
			ZZ8->(DbSetOrder(1))//ZZ8_FILIAL+ZZ8_LINHA
			If ZZ8->(DbSeek(xFilial("ZZ8")+(cAliasZZH)->ZZH_GRUPO))
				cNome := ZZ8->ZZ8_DESCRI
			Else
				cNome := ""
			EndIf

		EndIf
        
        /////////////////////////////
        /// Ita - 29/04/2019 
        ///     - Nome Fornece/Linha
        If Empty(cNome)
           cNome := Posicione("ZZH",1,xFilial("ZZH")+(cAliasZZH)->(ZZH_MARCA+ZZH_GRUPO),"ZZH_NREDUZ")
           If Empty(cNome)
              cNome := Posicione("ZZH",1,xFilial("ZZH")+(cAliasZZH)->ZZH_MARCA,"ZZH_NREDUZ")
           EndIf
        EndIf
        
		oZZH1Mod:SetValue( 'ZZH_MARCA',(cAliasZZH)->ZZH_MARCA )
		oZZH1Mod:SetValue( 'ZZH_GRUPO',(cAliasZZH)->ZZH_GRUPO )
		oZZH1Mod:SetValue( 'ZZH_NREDUZ',Substr(cNome,1,TamSx3("ZZH_NREDUZ")[1]) )

		oZZH1Mod:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})

		oZZH1Mod:SetNoUpdateLine(!lUpdCNF)

		nLinhaZZH++

		(cAliasZZH)->(DbSkip())

	EndDo

	(cAliasZZH)->( DbCloseArea() )

	oZZH1Mod:GoLine(1)

	oView:Refresh('VIEW_ZZH1')

Return()

/*/{Protheus.doc} AN010
Pre validação do modelo
@author felipe.caiado
@since 24/04/2019
@version 1.0
@param oModelGrid, object, descricao
@param nLinha, numeric, descricao
@param cAcao, characters, descricao
@param cCampo, characters, descricao
@type function
/*/
Static Function AN010( oModelGrid, nLinha, cAcao, cCampo )

	Local oModel     	:= FWModelActive()
	Local oZZH1Mod  	:= oModel:GetModel( 'ZZHDETAIL1' )
	Local oZZH2Mod  	:= oModel:GetModel( 'ZZHDETAIL2' )
	Local oView			:= FwViewActive()
	Local nY			:= 0
    aDelMrk := {}
    For nDl := 1 To oZZH1Mod:Length()
       oZZH1Mod:GoLine( nDl )
       If oZZH1Mod:IsDeleted()
          aAdd(aDelMrk, { oZZH1Mod:GetValue("ZZH_MARCA"), oZZH1Mod:GetValue("ZZH_GRUPO"), oZZH2Mod:GetValue("ZZH_FILAN") })
       EndIf
    Next nDl
	If ApMsgYesNo("Confirma a Exclusão de "+Alltrim(Str(Len(aDelMrk)))+" itens?")

		For nY := 1 to Len(aDelMrk) //oZZH1Mod:Length() //Ita - 02/05/2019 - Deletar todos os itens marcados para deleção
		
			
			Begin Transaction
	
				If !Empty(aDelMrk[nY,2]) //oZZH1Mod:GetValue("ZZH_GRUPO"))
	
					DbSelectArea("ZZ8")
					ZZ8->(DbSetOrder(1))
					If ZZ8->(DbSeek(xFilial("ZZ8")+aDelMrk[nY,2])) //oZZH1Mod:GetValue("ZZH_GRUPO")))
	
						Reclock("ZZ8",.F.)
						ZZ8->(DbDelete())
						SZ8->(MsUnlock())
	
	
					EndIf
	
				EndIf
	
				DbSelectArea("ZZN")
				ZZN->(DbSetOrder(1))//ZZN_FILIAL+ZZN_COD+ZZN_LINHA
				//aAdd(aDelMrk, { oZZH1Mod:GetValue("ZZH_MARCA"), oZZH1Mod:GetValue("ZZH_GRUPO"), oZZH2Mod:GetValue("ZZH_FILAN") })
				//If ZZN->(DbSeek(xFilial("ZZN")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH1Mod:GetValue("ZZH_MARCA")))
				If ZZN->(DbSeek(xFilial("ZZN")+aDelMrk[nY,1]+aDelMrk[nY,2]))
	
					Reclock("ZZN",.F.)
					ZZN->(DbDelete())
					ZZN->(MsUnlock())
	
	
				EndIf
	
				For nxY := 1 to oZZH2Mod:Length()
	
					oZZH2Mod:GoLine(nxY)
	
					DbSelectArea("ZZH")
					ZZH->(DbSetOrder(1))
					//aAdd(aDelMrk, { oZZH1Mod:GetValue("ZZH_MARCA"), oZZH1Mod:GetValue("ZZH_GRUPO"), oZZH2Mod:GetValue("ZZH_FILAN") })
					//If ZZH->(DbSeek(xFilial("ZZH")+oZZH1Mod:GetValue("ZZH_MARCA")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH2Mod:GetValue("ZZH_FILAN")))
					If ZZH->(DbSeek(xFilial("ZZH")+aDelMrk[nY,1]+aDelMrk[nY,2]+oZZH2Mod:GetValue("ZZH_FILAN")))
	
						Reclock("ZZH",.F.)
						ZZH->(DbDelete())
						ZZH->(MsUnlock())
	
	
					EndIf
	
				Next nxY
	
			End Transaction
            
        Next nY 
        
		oView:GetViewObj("VIEW_ZZH1")[3]:oBrowse:oBrowse:SetFocus()

		FwMsgRun(Nil,{||AN009() },Nil,"Aguarde, Atualizando...")

		ApMsgInfo("Excluido com sucesso")

	EndIf

Return()

///////////////////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Função AN011 - Herdar
///     - Consiste na transferência de dados de Marca e Linha
///       herança para destino.

Static Function AN011()
	aRet 	:= {}
	aPerg	:= {}
	If !Empty(aMarDig)
	   Alert("Antes de usar a função F6-Herdar, salve os dados que foram informados através da função F4")
	   Return
	EndIf 
	aMarDig := {} //Ita - 08/05/2019 - Zera Marcas Digitadas  para evitar F5 inconsistente
    /**************************************************
      1 - MsGet
     [2] : Descrição
     [3] : String contendo o inicializador do campo
     [4] : String contendo a Picture do campo
     [5] : String contendo a validação
     [6] : Consulta F3
     [7] : String contendo a validação When
     [8] : Tamanho do MsGet
     [9] : Flag .T./.F. Parâmetro Obrigatório ?
     *****************************************************/
	//            1                2              3       4        5           6      7   8  9
	aAdd( aPerg ,{1,Alltrim("Filial Herança"),Space(06),"@!","u_VldxFil(1)" ,"SM0" ,".T.",6,.F.})  //1
	aAdd( aPerg ,{1,Alltrim("Marca Herança") ,Space(05),"@!","u_VldMarc()"  ,"ZZ7" ,".T.",5,.T.})  //2
	aAdd( aPerg ,{1,Alltrim("Linha Herança") ,Space(05),"@!","u_VldLinh()"  ,"ZZ8" ,".T.",5,.T.})  //3
	aAdd( aPerg ,{1,Alltrim("Filial Destino"),Space(06),"@!","u_VldxFil(2)" ,"SM0" ,".T.",6,.F.})  //4
	//aAdd( aPerg ,{1,Alltrim("Marca Destino") ,Space(05),"@!",""  ,"" ,".T.",5,.T.})  //5
	//aAdd( aPerg ,{1,Alltrim("Linha Destino") ,Space(05),"@!",""  ,"" ,".T.",5,.F.})  //6
	aAdd( aPerg ,{1,Alltrim("Marca Destino") ,Space(05),"@!","u_VDsMarc()"  ,"ZZ7" ,".T.",5,.T.})  //5
	aAdd( aPerg ,{1,Alltrim("Linha Destino") ,Space(05),"@!","u_VDsLinh()"  ,"ZZ8" ,".T.",5,.F.})  //6

	//Mostra tela de Parâmetros
	If !ParamBox(aPerg ,"Parâmetros da Herança p/Destino",@aRet)
		Return()
	EndIf
	//Faz consistência dos parâmetros
	If Empty(MV_PAR02) .Or. Empty(MV_PAR03)
		ApMsgInfo("Os parâmetros de herança referentes a Marca e Linha devem está preenchidos.")
		Return()
	EndIf
	If Empty(MV_PAR05)
		ApMsgInfo("A marca destino deve ser informada.")
		Return()
	EndIf
	If Empty(MV_PAR01) .And. !Empty(MV_PAR04)//Filial Herança em banco, significa todas as filiais
	   ApMsgInfo("Todas as filiais de herança não poderão ir para uma única filial de destino. Favor corrigir os parâmetros referente a filial herança e destino!")
	   Return()
	EndIf
	If !Empty(MV_PAR01) .And. Empty(MV_PAR04)//Filial Herança em banco, significa todas as filiais
	   ApMsgInfo("Uma única filial de herança não poderá ir para todas as filiais de destino. Favor corrigir os parâmetros referente a filial herança e destino!")
	   Return()
	EndIf
	If MsgYesNo("Confirma processamento da Herança ?")
		
		aHeranca := {}
	
	    If !Empty(MV_PAR01)

			DbSelectArea("ZZH")
			ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
			If ZZH->(DbSeek(Left(MV_PAR01,4)+SPACE(2)+MV_PAR02+MV_PAR03+MV_PAR01))
				While !ZZH->(Eof()) .And. xFilial("ZZH")+MV_PAR02+MV_PAR03+MV_PAR01 == xFilial("ZZH")+ZZH->ZZH_MARCA+ZZH->ZZH_GRUPO+ZZH->ZZH_FILAN
	
	                //               ZZH_FILIAL , ZZH_MARCA,ZZH_GRUPO  ,ZZH_NREDUZ 
	                //                  1           2          3             4              5             6                7            8
					If aScan(aHeranca, {|x| x[1]+x[2]+x[3]+x[5] == MV_PAR04 + MV_PAR05 + MV_PAR06 + MV_PAR04 }) == 0
					   aAdd(aHeranca, {MV_PAR04    ,MV_PAR05  ,MV_PAR06   ,ZZH->ZZH_NREDUZ,MV_PAR04,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
					   //              Fil.Destino ,Marca Dest,Linha Dest.,
					EndIf
					ZZH->(DbSkip())
	
				EndDo
			    
			EndIf
		
		Else 
	    
	        //Dados do SM0
	        //aSM0 := FWLoadSM0(.T.)
	        
	        //For nX:= 1 To Len(aSM0) 
			
				DbSelectArea("ZZH")
				ZZH->(DbSetOrder(1))//ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
				If ZZH->(DbSeek(xFilial("ZZH")+MV_PAR02+MV_PAR03))
					While !ZZH->(Eof()) .And. xFilial("ZZH")+MV_PAR02+MV_PAR03 == xFilial("ZZH")+ZZH->ZZH_MARCA+ZZH->ZZH_GRUPO
		
		                //               ZZH_FILIAL         , ZZH_MARCA,ZZH_GRUPO,ZZH_NREDUZ 
		                //                  1                    2         3             4                  5             6                7          8
						If aScan(aHeranca, {|x| x[1]+x[2]+x[3]+x[5] == xFilial("ZZH") + MV_PAR05 + MV_PAR06 + ZZH->ZZH_FILAN }) == 0
						   aAdd(aHeranca, {xFilial("ZZH"),MV_PAR05  ,MV_PAR06 ,ZZH->ZZH_NREDUZ,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
						   //              Fil.Destino ,Marca Dest,Linha Dest.,
						EndIf
						ZZH->(DbSkip())
		
					EndDo
					
				EndIf
	    	
	    	//Next nX
	    		
		EndIf
	    
	    If Len(aHeranca) > 0
	       fGrvHera() //Grava Heranças
	    EndIf
	    
	EndIf
		
Return

////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Validação do Parâmetro Marca Herança
User Function VldMarc()
   xArea := GetArea() 
   If Empty(MV_PAR02)
      Alert("Por favor informe o código da Marca Herança")
      Return(.F.)
   EndIf
   DbSelectArea("ZZ7")
   DbSetOrder(1)//ZZ7_FILIAL+ZZ7_MARCA
   //MsgInfo("Len(xFilial('ZZ7')): "+Alltrim(Str(Len(Alltrim(xFilial("ZZ7"))))))
   If !DbSeek(If(Empty(MV_PAR01),xFilial("ZZ7"),Left(MV_PAR01,4)+SPACE(2))+MV_PAR02)
      Alert("A Marca herança digitada ["+MV_PAR02+"] não está cadastrada na filial "+Left(MV_PAR01,4)+SPACE(2)+", por favor informe um código de  marca válida")
      Return(.F.)
   EndIf
   
   DbSelectArea("ZZH")
   DbSetOrder(1) //ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
   If !DbSeek(If(Empty(MV_PAR01),xFilial("ZZH"),Left(MV_PAR01,4)+SPACE(2))+MV_PAR02)
      Alert("Não existem dados para herdar referente a Marca de herança digitada ["+MV_PAR02+"] na filial "+Left(MV_PAR01,4)+SPACE(2))
      Return(.F.)
   EndIf   
   RestArea(xArea)   
   
Return(.T.)

////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Validação do Parâmetro Linha Herança
User Function VldLinh()
   xArea := GetArea()
   If Empty(MV_PAR03)
      Alert("Por favor informe o código da Linha Herança")
      Return(.F.)
   EndIf
   DbSelectArea("ZZ8")
   DbSetOrder(1)//ZZ8_FILIAL+ZZ8_LINHA
   If !DbSeek(If(Empty(MV_PAR01),xFilial("ZZ8"),Left(MV_PAR01,4)+SPACE(2))+MV_PAR03)
      Alert("A Linha de herança digitada ["+MV_PAR03+"] não está cadastrada na filial "+Left(MV_PAR01,4)+SPACE(2)+", por favor informe um código de linha válida")
      Return(.F.)
   EndIf
   
   DbSelectArea("ZZH")
   DbSetOrder(1) //ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
   If !DbSeek(If(Empty(MV_PAR01),xFilial("ZZH"),Left(MV_PAR01,4)+SPACE(2))+MV_PAR02+MV_PAR03)
      Alert("Não existem dados para herdar referentes a Marca e Linha de heranças digitadas ["+MV_PAR02+"+"+MV_PAR03+"] na filial "+Left(MV_PAR01,4)+SPACE(2))
      Return(.F.)
   EndIf
   RestArea(xArea)   
Return(.T.)

////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Validação do Parâmetro Filial
///     - Herança ou Destino
User Function VldxFil(nCall)
   If nCall == 1
      _cFilPar := MV_PAR01
      _FilPrm  := "Herança"
   Else
      _cFilPar := MV_PAR04
      _FilPrm  := "Destino"
   EndIf
   If Empty(_cFilPar)
      Return(.T.)
   EndIf
   //Dados do SM0
   aSM0 := FWLoadSM0(.T.)
   For nX:= 1 To Len(aSM0)
      If Alltrim(aSM0[nX][SM0_FILIAL]) == Alltrim(_cFilPar)
         Return(.T.)
      EndIF	
   Next nX
   Alert("A Filial de "+_FilPrm+" informada ["+_cFilPar+"] é inválida!")
Return(.F.)

////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Validação do Parâmetro Marca Destino

User Function VDsMarc()
   xArea := GetArea() 
   If Empty(MV_PAR05)
      Alert("Por favor informe o código da Marca Herança")
      Return(.F.)
   EndIf
   DbSelectArea("ZZ7")
   DbSetOrder(1)//ZZ7_FILIAL+ZZ7_MARCA
   If !DbSeek(If(Empty(MV_PAR04),xFilial("ZZ7"),Left(MV_PAR04,4)+SPACE(2))+MV_PAR05)
      Alert("A Marca de destino digitada ["+MV_PAR05+"] não está cadastrada no sistema da filial "+Left(MV_PAR01,4)+SPACE(2)+", por favor informe um código de  marca válida")
      Return(.F.)
   EndIf
   /*
   DbSelectArea("ZZH")
   DbSetOrder(1) //ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
   If !DbSeek(If(Empty(MV_PAR04),xFilial("ZZH"),MV_PAR04)+MV_PAR05)
      Alert("Não existem dados de markup referente a Marca de destino digitada ["+MV_PAR05+"] da filial "+If(Empty(MV_PAR04),xFilial("ZZH"),MV_PAR04))
      Return(.F.)
   EndIf   
   */
   RestArea(xArea)   
Return(.T.)

////////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Validação do Parâmetro Linha Destino

User Function VDsLinh()
   xArea := GetArea()
   If Empty(MV_PAR06)
      Return(.T.)
   EndIf
   DbSelectArea("ZZ8")
   DbSetOrder(1)//ZZ8_FILIAL+ZZ8_LINHA
   If !DbSeek(If(Empty(MV_PAR04),xFilial("ZZ8"),Left(MV_PAR04,4)+SPACE(2))+MV_PAR06)
      Alert("A Linha de destino digitada ["+MV_PAR06+"] não está cadastrada na filial "+Left(MV_PAR04,4)+SPACE(2)+", por favor informe um código de linha válida")
      Return(.F.)
   EndIf
   /*
   DbSelectArea("ZZH")
   DbSetOrder(1) //ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
   If !DbSeek(If(Empty(MV_PAR04),xFilial("ZZH"),MV_PAR04)+MV_PAR05+MV_PAR06)
      Alert("Não existem dados de markup referentes a Marca e Linha de destino digitadas ["+MV_PAR05+"+"+MV_PAR06+"] na filial "+If(Empty(MV_PAR04),xFilial("ZZH"),MV_PAR04))
      Return(.F.)
   EndIf
   */
   RestArea(xArea)   
Return(.T.)

Static Function fGrvHera()

   //               ZZH_FILIAL , ZZH_MARCA,ZZH_GRUPO  ,ZZH_NREDUZ 
   //                  1           2          3             4              5             6                7
   //aAdd(aHeranca, {MV_PAR04    ,MV_PAR05  ,MV_PAR06   ,ZZH->ZZH_NREDUZ,MV_PAR04 ,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
					//              Fil.Destino ,Marca Dest,Linha Dest.
    If !Empty(MV_PAR04)//aHeranca[1,5]) //Se a Filial de Destino estiver preenchida
        lGrvSZ8 := .T.
        lGrvZZN := .T.	
		For nPrc := 1 To Len(aHeranca)
		
			Begin Transaction
		        cpare:="" 
			
				/* Ita - 08/05/2019 - Comentado pois para gravar a herança, a linha de destino já deve existir.
				If !Empty(aHeranca[nPrc,3]) .And. lGrvSZ8
		            
					DbSelectArea("ZZ8")  //Cadastro de Linha
					ZZ8->(DbSetOrder(1))
					If !ZZ8->(DbSeek(Left(aHeranca[nPrc,1],4)+SPACE(2)+aHeranca[nPrc,3])) //oZZH1Mod:GetValue("ZZH_GRUPO")))
		
						Reclock("ZZ8",.T.)
						ZZ8->ZZ8_FILIAL	:= Left(aHeranca[nPrc,1],4)+SPACE(2) //xFilial("ZZ8")
						ZZ8->ZZ8_LINHA	:= aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
						ZZ8->ZZ8_DESCRI	:= aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ")
						SZ8->(MsUnlock())
		                lGrvSZ8 := .F. 
		
					EndIf
		
				EndIf
		        */
				DbSelectArea("ZZN") //MARCA X LINHA
				ZZN->(DbSetOrder(1)) //ZZN_FILIAL+ZZN_COD+ZZN_LINHA
				//Ita - 30/04/2019 - If !ZZN->(DbSeek(xFilial("ZZN")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH1Mod:GetValue("ZZH_MARCA")))
				If !ZZN->(DbSeek(Left(aHeranca[nPrc,1],4)+SPACE(2)+aHeranca[nPrc,2]+aHeranca[nPrc,3])) .And. lGrvZZN
		
					Reclock("ZZN",.T.)
					ZZN->ZZN_FILIAL := Left(aHeranca[nPrc,1],4)+SPACE(2)
					ZZN->ZZN_COD 	:= aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
					ZZN->ZZN_DESCRI := ""
					ZZN->ZZN_LINHA 	:= aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
					ZZN->ZZN_DESLIN := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ")
					ZZN->(MsUnlock())
					lGrvZZN := .F.
		
		
				EndIf
		
			  
	            //               ZZH_FILIAL, ZZH_MARCA  ,ZZH_GRUPO,ZZH_NREDUZ 
	            //                  1           2          3             4              5             6                7                  8
	            //aAdd(aHeranca, {MV_PAR01   ,MV_PAR02  ,MV_PAR03 ,ZZH->ZZH_NREDUZ,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
	    				
				If !Empty(aHeranca[nPrc,3]) //Se a linha de destino estiver preenchida
				
					DbSelectArea("ZZH")
					ZZH->(DbSetOrder(1)) //Ita - ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
					If !ZZH->(DbSeek(Left(aHeranca[nPrc,1],4)+SPACE(2)+aHeranca[nPrc,2]+aHeranca[nPrc,3]+aHeranca[nPrc,5]))
		
						Reclock("ZZH",.T.)
						   ZZH->ZZH_FILIAL := Left(aHeranca[nPrc,1],4)+SPACE(2) //xFilial("ZZH")
						   ZZH->ZZH_MARCA  := aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
						   ZZH->ZZH_GRUPO  := aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
						   ZZH->ZZH_NREDUZ := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ") 
						   ZZH->ZZH_FILAN  := aHeranca[nPrc,5]  //oZZH2Mod:GetValue("ZZH_FILAN")
		
						   ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
						   ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
						   ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
						ZZH->(MsUnlock())
		
					Else
					   Reclock("ZZH",.F.)
					      ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
						  ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
						  ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
		               ZZH->(MsUnlock()) 
		
					EndIf
	            Else //Se a linha de destino não estiver preenchida, irá replicar as informações para todas as linha da Marca de destino
	               aLinhasMrc := {}
	               fPsqLinhas(Left(aHeranca[nPrc,1],4)+SPACE(2),aHeranca[nPrc,2],@aLinhasMrc)//Pesquisa todas as linhas da marca destino
	               For nLn := 1 To Len(aLinhasMrc)
	                        //                            1                   2                  3
                            //aAdd(aLinhasMrc, {XLINHAS->ZZN_DESCRI,XLINHAS->ZZN_LINHA,XLINHAS->ZZN_DESLIN})
						DbSelectArea("ZZH")
						ZZH->(DbSetOrder(1)) //Ita - ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
						If !ZZH->(DbSeek(Left(aHeranca[nPrc,1],4)+SPACE(2)+aHeranca[nPrc,2]+aLinhasMrc[nLn,2]+aHeranca[nPrc,5]))
			
							Reclock("ZZH",.T.)
							   ZZH->ZZH_FILIAL := Left(aHeranca[nPrc,1],4)+SPACE(2) //xFilial("ZZH")
							   ZZH->ZZH_MARCA  := aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
							   ZZH->ZZH_GRUPO  := aLinhasMrc[nLn,2] //oZZH1Mod:GetValue("ZZH_GRUPO")
							   ZZH->ZZH_NREDUZ := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ") 
							   ZZH->ZZH_FILAN  := aHeranca[nPrc,5]  //oZZH2Mod:GetValue("ZZH_FILAN")
			
							   ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
							   ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
							   ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
							ZZH->(MsUnlock())
			
						Else
						   Reclock("ZZH",.F.)
						      ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
							  ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
							  ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
			               ZZH->(MsUnlock()) 
			
						EndIf
	               Next nLn
	            EndIf
	            
			End Transaction
		
		Next nPrc
	Else //Se a filial destino não estiver preenchida, irá gerar herança para todas as filiais.
	   //Dados do SM0
	   aSM0 := FWLoadSM0(.T.)
	   For nX:= 1 To Len(aSM0)
		    lGrvSZ8 := .T.
		    lGrvZZN := .T.
			For nPrc := 1 To Len(aHeranca)
			
				Begin Transaction
			        cpare:="" 
				
					If !Empty(aHeranca[nPrc,3]) .And. lGrvSZ8
			            
						DbSelectArea("ZZ8")
						ZZ8->(DbSetOrder(1))
						If !ZZ8->(DbSeek(Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2)+aHeranca[nPrc,3])) //oZZH1Mod:GetValue("ZZH_GRUPO")))
			
							Reclock("ZZ8",.T.)
							ZZ8->ZZ8_FILIAL	:= Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2) //xFilial("ZZ8")
							ZZ8->ZZ8_LINHA	:= aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
							ZZ8->ZZ8_DESCRI	:= aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ")
							SZ8->(MsUnlock())
			                lGrvSZ8 := .F. 
			
						EndIf
			
					EndIf
			
					DbSelectArea("ZZN")
					ZZN->(DbSetOrder(1))//ZZN_FILIAL+ZZN_COD+ZZN_LINHA
					//Ita - 30/04/2019 - If !ZZN->(DbSeek(xFilial("ZZN")+oZZH1Mod:GetValue("ZZH_GRUPO")+oZZH1Mod:GetValue("ZZH_MARCA")))
					If !ZZN->(DbSeek(Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2)+aHeranca[nPrc,2]+aHeranca[nPrc,3])) .And. lGrvZZN
			
						Reclock("ZZN",.T.)
						ZZN->ZZN_FILIAL := Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2)
						ZZN->ZZN_COD 	:= aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
						ZZN->ZZN_DESCRI := ""
						ZZN->ZZN_LINHA 	:= aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
						ZZN->ZZN_DESLIN := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ")
						ZZN->(MsUnlock())
						lGrvZZN := .F.
			
			
					EndIf
			
				  
		            //               ZZH_FILIAL, ZZH_MARCA  ,ZZH_GRUPO,ZZH_NREDUZ 
		            //                  1           2          3             4              5             6                7                  8
		            //aAdd(aHeranca, {MV_PAR01   ,MV_PAR02  ,MV_PAR03 ,ZZH->ZZH_NREDUZ,ZZH->ZZH_FILAN,ZZH->ZZH_MKMNF,ZZH->ZZH_MKNMNF,ZZH->ZZH_INDICE}) //Ita - 30/04/2019
		    				
					If !Empty(aHeranca[nPrc,3]) //Se a linha de destino estiver preenchida
					
						DbSelectArea("ZZH")
						ZZH->(DbSetOrder(1)) //Ita - ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
						If !ZZH->(DbSeek(Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2)+aHeranca[nPrc,2]+aHeranca[nPrc,3]+aHeranca[nPrc,5]))
			
							Reclock("ZZH",.T.)
							   ZZH->ZZH_FILIAL := Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2) //xFilial("ZZH")
							   ZZH->ZZH_MARCA  := aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
							   ZZH->ZZH_GRUPO  := aHeranca[nPrc,3] //oZZH1Mod:GetValue("ZZH_GRUPO")
							   ZZH->ZZH_NREDUZ := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ") 
							   ZZH->ZZH_FILAN  := aHeranca[nPrc,5]  //oZZH2Mod:GetValue("ZZH_FILAN")
			
							   ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
							   ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
							   ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
							ZZH->(MsUnlock())
			
						Else
						   Reclock("ZZH",.F.)
						      ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
							  ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
							  ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
			               ZZH->(MsUnlock()) 
			
						EndIf
		            Else //Se a linha de destino não estiver preenchida, irá replicar as informações para todas as linha da Marca de destino
		               aLinhasMrc := {}
		               fPsqLinhas(Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2),aHeranca[nPrc,2],@aLinhasMrc)//Pesquisa todas as linhas da marca destino
		               For nLn := 1 To Len(aLinhasMrc)
		                        //                            1                   2                  3
	                            //aAdd(aLinhasMrc, {XLINHAS->ZZN_DESCRI,XLINHAS->ZZN_LINHA,XLINHAS->ZZN_DESLIN})
							DbSelectArea("ZZH")
							ZZH->(DbSetOrder(1)) //Ita - ZZH_FILIAL+ZZH_MARCA+ZZH_GRUPO+ZZH_FILAN
							If !ZZH->(DbSeek(Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2)+aHeranca[nPrc,2]+aLinhasMrc[nLn,2]+aHeranca[nPrc,5]))
				
								Reclock("ZZH",.T.)
								   ZZH->ZZH_FILIAL := Left(aSM0[nX][SM0_FILIAL],4)+SPACE(2) //xFilial("ZZH")
								   ZZH->ZZH_MARCA  := aHeranca[nPrc,2] //oZZH1Mod:GetValue("ZZH_MARCA")
								   ZZH->ZZH_GRUPO  := aLinhasMrc[nLn,2] //oZZH1Mod:GetValue("ZZH_GRUPO")
								   ZZH->ZZH_NREDUZ := aHeranca[nPrc,4] //oZZH1Mod:GetValue("ZZH_NREDUZ") 
								   ZZH->ZZH_FILAN  := aHeranca[nPrc,5]  //oZZH2Mod:GetValue("ZZH_FILAN")
				
								   ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
								   ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
								   ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
								ZZH->(MsUnlock())
				
							Else
							   Reclock("ZZH",.F.)
							      ZZH->ZZH_MKMNF  := aHeranca[nPrc,6] //oZZH2Mod:GetValue("ZZH_MKMNF")
								  ZZH->ZZH_MKNMNF := aHeranca[nPrc,7] //oZZH2Mod:GetValue("ZZH_MKNMNF")
								  ZZH->ZZH_INDICE := aHeranca[nPrc,8] //oZZH2Mod:GetValue("ZZH_INDICE")
				               ZZH->(MsUnlock()) 
				
							EndIf
		               Next nLn
		            EndIf
		            
				End Transaction
			
			Next nPrc
	   Next nX	
	EndIf
	MsgInfo("Processo de herança concluído!")
Return

///////////////////////////////////////////////
/// Ita - 03/05/2019
///     - Função fPsqLinhas
///     - Seleciona Todas as linhas da marca.

Static Function fPsqLinhas(xpFilial,xMarca,aLinhasMrc)
   
   //MARCA X LINHA                 
   
   cQryLin := " SELECT ZZN.ZZN_DESCRI,ZZN.ZZN_LINHA,ZZN_DESLIN " + _Enter
   cQryLin += "   FROM "+RetSQLName("ZZN")+" ZZN " + _Enter
   
   If Empty(xpFilial) 
      cQryLin += "  WHERE ZZN.ZZN_FILIAL = '"+xFilial("ZZN")+"'" + _Enter
   Else
      cQryLin += "  WHERE ZZN.ZZN_FILIAL = '"+xpFilial+"'" + _Enter
   EndIf
   
   cQryLin += "  AND ZZN.ZZN_COD = '"+xMarca+"'" + _Enter
   cQryLin += "  AND ZZN.ZZN_LINHA <> ' '" + _Enter
   cQryLin += "  AND ZZN.D_E_L_E_T_ <> '*'" + _Enter
   
   MemoWrite("C:\TEMP\fPsqLinhas.SQL",cQryLin)
   
   TCQuery cQryLin NEW ALIAS "XLINHAS"
   
   DbSelectArea("XLINHAS")
   While XLINHAS->(!Eof())
      //                            1                   2                  3
      nPL := aScan(aLinhasMrc, {|x| x[2] == XLINHAS->ZZN_LINHA })
      If nPL == 0
         aAdd(aLinhasMrc, {XLINHAS->ZZN_DESCRI,XLINHAS->ZZN_LINHA,XLINHAS->ZZN_DESLIN})
      EndIf
      DbSelectArea("XLINHAS")
      DbSkip()
   EndDo
   DbSelectArea("XLINHAS")
   DbCloseArea()
   
Return

//////////////////////////////////////////////////////
/// Ita - 09/05/2019
///     - Validação do Parâmetro Marca Destino no F4
           /*
	aAdd( aPerg ,{1,Alltrim("Marca"),Space(05),"@!",".T.","",".T.",30,.T.})
	aAdd( aPerg ,{1,Alltrim("Linha"),Space(05),"@!",".T.","",".T.",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Nome"),Space(40),"@!",".T.","",".T.",100,.F.})
	aAdd( aPerg ,{1,Alltrim("Marca Herança") ,Space(05),"@!","u_VF4DsMarc()"  ,"ZZ7" ,".T.",5,.T.})  //5
	aAdd( aPerg ,{1,Alltrim("Linha Herança") ,Space(05),"@!","u_VF4DsLinh()"  ,"ZZ8" ,".T.",5,.F.})  //6           
           */
User Function VF4DsMarc()
   xArea := GetArea() 
   If Empty(MV_PAR04)
      RestArea(xArea)   
      Return(.T.)
   EndIf
   DbSelectArea("ZZ7")
   DbSetOrder(1)//ZZ7_FILIAL+ZZ7_MARCA
   If !DbSeek(xFilial("ZZ7")+MV_PAR04)
      Alert("A Marca de herança digitada ["+MV_PAR04+"] não está cadastrada no sistema, por favor informe um código de  marca válida")
      Return(.F.)
   EndIf

   RestArea(xArea)   
Return(.T.)

/////////////////////////////////////////////////////
/// Ita - 09/05/2019
///     - Validação do Parâmetro Linha Destino NO F4

User Function VF4DsLinh()
   xArea := GetArea()
   If Empty(MV_PAR05)
      RestArea(xArea)   
      Return(.T.)
   EndIf
   DbSelectArea("ZZ8")
   DbSetOrder(1)//ZZ8_FILIAL+ZZ8_LINHA
   If !DbSeek(xFilial("ZZ8")+MV_PAR05)
      Alert("A Linha herança digitada ["+MV_PAR05+"] não está cadastrada no sistema, por favor informe um código de linha válida")
      Return(.F.)
   EndIf

   RestArea(xArea)   
Return(.T.)
