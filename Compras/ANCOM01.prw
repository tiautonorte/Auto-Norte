#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "FWEDITPANEL.CH"

#DEFINE SM0_FILIAL	02

//-------------------------------------------------------------------
/*/{Protheus.doc} ANCOM01
Manutenção de Tabela de Preço
@author felipe.caiado
@since 13/03/2019
/*/
//-------------------------------------------------------------------

User Function ANCOM01A()

	Local aButtons 		:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Fechar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	Private aColsBkp	:= {}
	Private oCodigo
	Private cCodigo 	:= ""
	Private oDescri
	Private cDescri 	:= Space(40)
	Private oMarca
	Private cCxmarc 	:= Space(TAMSX3("B1_XMARCA")[1])
	Private lAltLetra	:= .F.
	Private lAltDesc	:= .F.
	Private	lCopPRep	:= .F.
	Private	lTeclF7		:= .F.
	Private aFilOri		:= {}
	Private aFilCopy	:= {}
	Private lVIEW_SB1 := .F.
	Private lVIEW_DA1 := .F.
	Private lVIEW_ALT := .F.

	SetKEY( VK_F12, {|| lTeclF7 := .F., FwMsgRun(Nil,{||AN002(oCodigo, oDescri, oMarca) },Nil,"Aguarde, Executando Filtro...")} )
	SetKEY( VK_F6,  {|| FwMsgRun(Nil,{||AN007(lAltLetra, lAltDesc) },Nil,"Aguarde, Atualizando Preço...")} )
	SetKEY( VK_F4,  {|| lTeclF7 := .F., lAltLetra := .F., lAltDesc := .F., AN004(lAltLetra, lAltDesc, "Atualização de Preço")} )
	SetKEY( VK_F7,  {|| lTeclF7 := .T., AN009()} )
	SetKEY( VK_F10, {|| lTeclF7 := .F., lAltLetra := .F., lAltDesc := .F., FwMsgRun(Nil,{||AN014() },Nil,"Aguarde, Executando Filtro...")} )
	SetKEY( K_CTRL_L, {|| lTeclF7 := .T., lAltLetra := .T., lAltDesc := .F., AN004(lAltLetra, lAltDesc, "Atualização de Letra")} )
	SetKEY( K_CTRL_D, {|| lTeclF7 := .T., lAltLetra := .F., lAltDesc := .T., AN004(lAltLetra, lAltDesc, "Atualização de Desconto")} )
	SetKEY( K_CTRL_P, {|| lTeclF7 := .F., AN010()} )
	SetKEY( K_CTRL_R, {|| lTeclF7 := .F., FwMsgRun(Nil,{||AN011() },Nil,"Aguarde, Recalculando Tabela...")} )

	FWExecView("Manutenção de Tabela de Preço","ANCOM01",MODEL_OPERATION_INSERT,,{|| .T.},,,aButtons	)

	SetKEY( VK_F6, nil )
	SetKEY( VK_F4, nil )
	SetKEY( K_CTRL_L, NIL )
	SetKEY( K_CTRL_D, NIL )
	SetKEY( K_CTRL_P, NIL )
	SetKEY( K_CTRL_R, NIL )
	SetKEY( VK_F12, nil )
	SetKEY( VK_F7, NIL )
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Manutenção de Tabela de Preço - Modelo de Dados
@author felipe.caiado
@since 13/03/2019
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruFIL 	:= FWFormStruct( 1, 'ZZZ')
	Local oStruSB1 	:= FWFormStruct( 1, 'SB1', {|cCampo| Alltrim(cCampo) $ 'B1_COD/B1_DESC/B1_XLINHA/B1_XALTIMP'},/*lViewUsado*/ )
	Local oStruDA1	:= FWFormStruct( 1, 'DA1', {|cCampo| Alltrim(cCampo) $ 'DA1_XTABSQ/DA1_DATVIG/DA1_XPRCBR/DA1_XDESCV/DA1_XPRCLI/DA1_XLETRA/DA1_XPRCRE'},/*lViewUsado*/ )
	Local oStruALT	:= FWFormStruct( 1, 'ZZZ')
	Local oModel

	//Estrutura do Filtro
	oStruFIL:AddField( ;
		AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Marca') , ; 		// [02] C ToolTip do campo
	'XX_MARCA' , ;              // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	TamSX3("B1_XMARCA")[1] , ;  // [05] N Tamanho do campo
	TamSX3("B1_XMARCA")[2] , ;  // [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruFIL:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Produto') , ; 		// [02] C ToolTip do campo
	'XX_PRODUT' , ;             // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	TamSX3("B1_COD")[1] , ;     // [05] N Tamanho do campo
	TamSX3("B1_COD")[2] , ;		// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruFIL:AddField( ;
		AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Linha') , ; 		// [02] C ToolTip do campo
	'XX_LINHA' , ;             	// [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	TamSX3("B1_XLINHA")[1] , ;  // [05] N Tamanho do campo
	TamSX3("B1_XLINHA")[2] , ;	// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruFIL:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Curva') , ; 		// [02] C ToolTip do campo
	'XX_CURVA' , ;             	// [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	10 , ;  						// [05] N Tamanho do campo
	0 , ;						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruSB1:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Cv') , ; 			// [02] C ToolTip do campo
	'B1_CURVA' , ;             	// [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	1 , ;  						// [05] N Tamanho do campo
	0 , ;						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruDA1:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Filial') , ; 		// [02] C ToolTip do campo
	'DA1_FILIAL' , ;            // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	06 , ;  					// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruDA1:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Cst Aquis') , ; 	// [02] C ToolTip do campo
	'DA1_XCSTAQ' , ;            // [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	12 , ;  					// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruDA1:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Documento') , ; 	// [02] C ToolTip do campo
	'DA1_XDOC' , ;            	// [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	9 , ;  						// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Filial') , ; 		// [02] C ToolTip do campo
	'XX_FILIAL' , ;             // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	06 , ;  					// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Data') , ; 		// [02] C ToolTip do campo
	'XX_DATA' , ;            	// [03] C identificador (ID) do Field
	'D' , ;                     // [04] C Tipo do campo
	08 , ;  					// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                		// [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Custo Aquis') , ; 	// [02] C ToolTip do campo
	'XX_CSTAQU' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	12 , ;  						// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Preço Rep') , ; 	// [02] C ToolTip do campo
	'XX_PRCREP' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	10, ;  						// [05] N Tamanho do campo // Ita - 19/08/2020 - Aumentar tamanho da máscara -  6 , ;  						// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                		// [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Letra') , ; 		// [02] C ToolTip do campo
	'XX_LETRA' , ;            	// [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	01 , ;  					// [05] N Tamanho do campo
	0 , ;  						// [06] N Decimal do campo
	{|| VldExLt()} ,;   		// [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Margem') , ; 		// [02] C ToolTip do campo
	'XX_MARGEM' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	8 , ;  						// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Fator') , ; 		// [02] C ToolTip do campo
	'XX_FTPRC' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	5 , ;  						// [05] N Tamanho do campo
	3 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Preço Bruto') , ; 	// [02] C ToolTip do campo
	'XX_PRCBRT' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	9 , ;  					// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	{|| VldAltPrd()} , ;        // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Desconto') , ; 	// [02] C ToolTip do campo
	'XX_DESCONT' , ;            // [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	06 , ;  					// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruALT:AddField( ;
	AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('Preço Liq') , ; 	// [02] C ToolTip do campo
	'XX_PRCLIQ' , ;            	// [03] C identificador (ID) do Field
	'N' , ;                     // [04] C Tipo do campo
	10, ;  						// [05] N Tamanho do campo //Ita - 19/08/2020 - Aumentar máscara de edição - 8 , ;  						// [05] N Tamanho do campo
	2 , ;  						// [06] N Decimal do campo
	{|| VldAltPrd()} , ;        // [07] B Code-block de validação do campo
	{|| .F.} , ;                // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatçrio
	NIL , ;						// [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo ç virtual

	oStruFIL:SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})
	oStruSB1:SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})
	oStruDA1:SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})

	oStruSB1:SetProperty("*",MODEL_FIELD_VALID,{|| .T.})
	oStruDA1:SetProperty("*",MODEL_FIELD_VALID,{|| .T.})
	oStruSB1:SetProperty("B1_DESC",MODEL_FIELD_TAMANHO ,18)

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('ANCOM01M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulçrio de edição por campo
	oModel:AddFields( 'FILMASTER', /*cOwner*/, oStruFIL, /*bPreValidacao*/, /*bPosValidacao*/, )

	// Adiciona ao modelo uma estrutura de Grid
	oModel:AddGrid( 'SB1DETAIL', 'FILMASTER', oStruSB1, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/,  )
	oModel:AddGrid( 'DA1DETAIL', 'FILMASTER', oStruDA1, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/,  )
	oModel:AddGrid( 'ALTDETAIL', 'FILMASTER', oStruALT, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/,  )

	//Chave Primaria
	oModel:SetPrimaryKey( { , })

	//Gatilho para a data

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_CSTAQU",	;
		{ || .T. },	;
		{ || AN005(FwFldGet("XX_FILIAL"), cCodigo,"1", 1)})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_PRCREP",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XPRCRE")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_LETRA",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XLETRA")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_MARGEM",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XMARGE")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_FTPRC",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XFATOR")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_PRCBRT",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XPRCBR")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_DESCONT",	;
		{ || .T.},	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XDESCV")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_PRCLIQ",	;
		{ || .T. },	;
		{ || AN006(FwFldGet("XX_FILIAL"), cCodigo, "DA1_XPRCLI")})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_LETRA",	;
		{ || lAltLetra },	;
		{ || AN012(FwFldGet("XX_LETRA"), FwFldGet("XX_FILIAL"))})

	oStruALT:AddTrigger( ;
		"XX_DATA",	;
		"XX_DESCONT",	;
		{ || lAltDesc },	;
		{ || AN013(FwFldGet("XX_DESCONT"), FwFldGet("XX_FILIAL"))})

	oStruALT:AddTrigger( ;
		"XX_DESCONT",	;
		"XX_PRCLIQ",	;
		{ || .T. },	;
		{ || AN008("1")})

	oStruALT:AddTrigger( ;
		"XX_PRCREP",	;
		"XX_PRCLIQ",	;
		{ || .T. },	;
		{ || AN008("1")})

	oStruALT:AddTrigger( ;
		"XX_LETRA",	;
		"XX_PRCLIQ",	;
		{ || .T. },	;
		{ || AN008("1")})

	oStruALT:AddTrigger( ;
		"XX_LETRA",	;
		"XX_MARGEM",	;
		{ || .T. },	;
		{ || u_CalcPrcV(Upper(Alltrim(FwFldGet("XX_LETRA"))), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), FwFldGet("XX_FILIAL"), FwFldGet("XX_PRCREP"))[5]})

	oStruALT:AddTrigger( ;
		"XX_LETRA",	;
		"XX_FTPRC",	;
		{ || .T. },	;
		{ || u_CalcPrcV(FwFldGet("XX_LETRA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), FwFldGet("XX_FILIAL"), FwFldGet("XX_PRCREP"))[3]})

	oStruALT:AddTrigger( ;
		"XX_PRCREP",	;
		"XX_PRCBRT",	;
		{ || .T. },	;
		{ || AN008("2")})

	oStruALT:AddTrigger( ;
		"XX_LETRA",	;
		"XX_PRCBRT",	;
		{ || .T. },	;
		{ || AN008("2")})


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Manutenção de Tabela de Preço' )

	oModel:GetModel( 'FILMASTER' ):SetOnlyView( .T. )
	oModel:GetModel( 'FILMASTER' ):SetOnlyQuery( .T. )

	oModel:GetModel( 'SB1DETAIL' ):SetOnlyView( .T. )
	oModel:GetModel( 'SB1DETAIL' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'SB1DETAIL' ):SetOptional( .T. )

	oModel:GetModel( 'DA1DETAIL' ):SetOnlyView( .T. )
	oModel:GetModel( 'DA1DETAIL' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'DA1DETAIL' ):SetOptional( .T. )

	oModel:GetModel( 'ALTDETAIL' ):SetOnlyView( .T. )
	oModel:GetModel( 'ALTDETAIL' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'ALTDETAIL' ):SetOptional( .T. )

	oModel:GetModel( 'SB1DETAIL' ):SetMaxLine(99999)

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'FILMASTER' ):SetDescription( 'Manutenção de Tabela de Preço' )
	oModel:GetModel( 'ALTDETAIL' ):SetDescription( 'Manutenção de Tabela de Preço' )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Manutenção de Tabela de Preço - Interface com usuçrio
@author felipe.caiado
@since 13/03/2019
@version undefined

@type function
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   	:= FWLoadModel( 'ANCOM01' )
	// Cria a estrutura a ser usada na View
	Local oStruFIL 	:= FWFormStruct( 2, 'ZZZ')
	Local oStruSB1 	:= FWFormStruct( 2, 'SB1', {|cCampo| Alltrim(cCampo) $ 'B1_COD/B1_DESC/B1_XLINHA/B1_XALTIMP'},/*lViewUsado*/ )
	Local oStruDA1 	:= FWFormStruct( 2, 'DA1', {|cCampo| Alltrim(cCampo) $ 'DA1_XTABSQ/DA1_DATVIG/DA1_XPRCBR/DA1_XDESCV/DA1_XPRCLI/DA1_XLETRA/DA1_XPRCRE'},/*lViewUsado*/ )
	Local oStruALT 	:= FWFormStruct( 2, 'ZZZ')
	Local oView
	Local cOrdem 	:= "00"

	cOrdem := Soma1( cOrdem )
	oStruFIL:AddField( ;            	// Ord. Tipo Desc.
	'XX_MARCA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Marca'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Marca' )				, ; // [04]  C   Descricao do campo
	{ 'Marca' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruFIL:AddField( ;            	// Ord. Tipo Desc.
	'XX_PRODUT'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Produto'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Produto' )			, ; // [04]  C   Descricao do campo
	{ 'Produto' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruFIL:AddField( ;            	// Ord. Tipo Desc.
	'XX_LINHA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Linha'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Linha' )				, ; // [04]  C   Descricao do campo
	{ 'Linha' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruFIL:AddField( ;            	// Ord. Tipo Desc.
	'XX_CURVA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Curva'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Curva' )				, ; // [04]  C   Descricao do campo
	{ 'Curva' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := '99'
	oStruSB1:AddField( ;            	// Ord. Tipo Desc.
	'B1_CURVA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Cv'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Cv' )				, ; // [04]  C   Descricao do campo
	{ 'Crv' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo


	cOrdem := "00"
	oStruDA1:AddField( ;            	// Ord. Tipo Desc.
	'DA1_FILIAL'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Filial'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Filial' )				, ; // [04]  C   Descricao do campo
	{ 'Filial' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := "90"
	oStruDA1:AddField( ;            	// Ord. Tipo Desc.
	'DA1_XCSTAQ'					, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Cst Aquis'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Cst Aquis' )			, ; // [04]  C   Descricao do campo
	{ 'Cst Aquis' } 				, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999,999,999.99'            	, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := "91"
	oStruDA1:AddField( ;            	// Ord. Tipo Desc.
	'DA1_XDOC'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Documento'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Documento' )			, ; // [04]  C   Descricao do campo
	{ 'Documento' } 				, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := "00"
	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_FILIAL'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Filial'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Filial' )				, ; // [04]  C   Descricao do campo
	{ 'Filial' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_DATA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Data'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Data' )				, ; // [04]  C   Descricao do campo
	{ 'Data' } 						, ; // [05]  A   Array com Help
	'D'                           	, ; // [06]  C   Tipo do campo
	''                				, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_CSTAQU'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Custo Aquis'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Custo Aquis' )		, ; // [04]  C   Descricao do campo
	{ 'Custo Aquis' } 				, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999,999,999.99'        		, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_PRCREP'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Preço Rep'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Preço Rep' )			, ; // [04]  C   Descricao do campo
	{ 'Preço Rep' } 				, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999,999.99'	                	, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_LETRA'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Letra'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Letra' )				, ; // [04]  C   Descricao do campo
	{ 'Letra' } 					, ; // [05]  A   Array com Help
	'C'                           	, ; // [06]  C   Tipo do campo
	'@!'                			, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_MARGEM'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Margem'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Margem' )				, ; // [04]  C   Descricao do campo
	{ 'Margem' } 					, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 9,999.99'                		, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_FTPRC'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Fator'    )			, ; // [03]  C   Titulo do campo
	AllTrim( 'Fator' )				, ; // [04]  C   Descricao do campo
	{ 'Fator' } 					, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 9.999'                		, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_PRCBRT'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Preço Bruto'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Preço Bruto' )		, ; // [04]  C   Descricao do campo
	{ 'Preço Bruto' } 				, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999,999.99'                	, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_DESCONT'					, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Desconto'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Desconto' )			, ; // [04]  C   Descricao do campo
	{ 'Desconto' } 					, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999.99'                		, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	cOrdem := Soma1( cOrdem )
	oStruALT:AddField( ;            	// Ord. Tipo Desc.
	'XX_PRCLIQ'						, ; // [01]  C   Nome do Campo
	cOrdem							, ; // [02]  C   Ordem
	AllTrim( 'Preço Liq'    )		, ; // [03]  C   Titulo do campo
	AllTrim( 'Preço Liq' )			, ; // [04]  C   Descricao do campo
	{ 'Preço Liq' } 				, ; // [05]  A   Array com Help
	'N'                           	, ; // [06]  C   Tipo do campo
	'@E 999,999.99'                	, ; // [07]  C   Picture
	NIL                             , ; // [08]  B   Bloco de Picture Var
	''                              , ; // [09]  C   Consulta F3
	.T.                             , ; // [10]  L   Indica se o campo ç alteravel
	NIL                             , ; // [11]  C   Pasta do campo
	NIL                             , ; // [12]  C   Agrupamento do campo
	NIL				               	, ; // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ; // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ; // [15]  C   Inicializador de Browse
	.T.                             , ; // [16]  L   Indica se o campo ç virtual
	NIL                             , ; // [17]  C   Picture Variavel
	NIL                             )   // [18]  L   Indica pulo de linha apçs o campo

	//Alterar ordens da DA1 na View
	oStruDA1:SetProperty("DA1_XTABSQ", MVC_VIEW_ORDEM , "02")
	oStruDA1:SetProperty("DA1_XLETRA", MVC_VIEW_ORDEM , "03")
	oStruDA1:SetProperty("DA1_DATVIG", MVC_VIEW_ORDEM , "04")
	oStruDA1:SetProperty("DA1_XPRCBR", MVC_VIEW_ORDEM , "05")
	oStruDA1:SetProperty("DA1_XDESCV", MVC_VIEW_ORDEM , "06")
	oStruDA1:SetProperty("DA1_XPRCLI", MVC_VIEW_ORDEM , "07")
	oStruDA1:SetProperty("DA1_XPRCRE", MVC_VIEW_ORDEM , "08")

	oStruSB1:SetProperty("B1_XLINHA", MVC_VIEW_TITULO , "Linha")
	oStruDA1:SetProperty("DA1_XTABSQ", MVC_VIEW_TITULO , "Seq")

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serç utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_FIL', oStruFIL, 'FILMASTER' )

	//Adiciona no nosso View um controle do tipo Grid(antiga GetDados)
	oView:AddGrid( 'VIEW_SB1', oStruSB1, 'SB1DETAIL' ,,{|| lVIEW_SB1 := .T., lVIEW_DA1 := .F., lVIEW_ALT := .F.})
	oView:AddGrid( 'VIEW_DA1', oStruDA1, 'DA1DETAIL' ,,{|| lVIEW_SB1 := .F., lVIEW_DA1 := .T., lVIEW_ALT := .F.})
	oView:AddGrid( 'VIEW_ALT', oStruALT, 'ALTDETAIL' ,,{|| lVIEW_SB1 := .F., lVIEW_DA1 := .F., lVIEW_ALT := .T.})

	oView:SetViewProperty( 'VIEW_SB1', "CHANGELINE", {{ |oView, cViewID| AN003(oCodigo, oDescri, oMarca) }} )
	oView:SetViewProperty( "VIEW_FIL", "SETLAYOUT", { FF_LAYOUT_HORZ_DESCR_TOP  , 5 } )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'DADOS' , 16 )
	oView:CreateVerticalBox( 'SUPESQ' , 45,'DADOS'  )
	oView:CreateVerticalBox( 'SUPDIR' , 55,'DADOS'  )
	oView:CreateHorizontalBox( 'INFERIOR' , 79 )
	oView:CreateHorizontalBox( 'RODAPE' , 05 )
	oView:CreateVerticalBox( 'INFESQ' , 30.5,'INFERIOR'  )
	oView:CreateVerticalBox( 'INFDIR' ,69.5,'INFERIOR'  )
	oView:CreateHorizontalBox( 'INFDIR01' , 50,'INFDIR' )
	oView:CreateHorizontalBox( 'INFDIR02' , 50,'INFDIR' )

	oView:AddOtherObject('VIEW_DPROD', {|oPanel| AN001(@oPanel, @oCodigo, @cCodigo, @oDescri, @cDescri, @oMarca, @cCxmarc)})

	oView:AddOtherObject('VIEW_RODAPE', {|oPanel| AN001(@oPanel, @oCodigo, @cCodigo, @oDescri, @cDescri, @oMarca, @cCxmarc)})

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_FIL', 'SUPESQ' )
	oView:SetOwnerView( 'VIEW_DPROD', 'SUPDIR' )
	oView:SetOwnerView( 'VIEW_SB1', 'INFESQ' )
	oView:SetOwnerView( 'VIEW_DA1', 'INFDIR01' )
	oView:SetOwnerView( 'VIEW_ALT', 'INFDIR02' )
	oView:SetOwnerView( 'VIEW_RODAPE', 'RODAPE' )

	oView:AddUserButton( 'Filtro (F12)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN002(oCodigo, oDescri, oMarca) },Nil,"Aguarde, Executando Filtro...") },, )
	oView:AddUserButton( 'Salvar (F6)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN007(lAltLetra,lAltDesc) },Nil,"Aguarde, Atualizando Preço...")},, )
	oView:AddUserButton( 'Alterar Preço (F4)', 'CLIPS', { |oView| lAltLetra := .F., lAltDesc := .F., AN004(lAltLetra, lAltDesc, "Atualização de Preço")},, )

	oView:AddUserButton( 'Importar Planilha (F10)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN014() },Nil,"Aguarde, Executando Filtro...") },, )

	oView:AddUserButton( 'Altera Letra (CTRL+L)', 'CLIPS', { |oView| lAltLetra := .T., , lAltDesc := .F., AN004(lAltLetra, lAltDesc, "Atualização de Letra")},, )
	oView:AddUserButton( 'Altera Desconto (CTRL+D)', 'CLIPS', { |oView| lAltLetra := .F., lAltDesc := .T., AN004(lAltLetra, lAltDesc, "Atualização de Desconto")},, )

	////////////////////////////////////////
	/// Ita - 29/04/2019
	///     - Implementado opççes de menu

	oView:AddUserButton( 'Replicar para filiais (F7)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN009() },Nil,"Replicando para filiais...") },, )
	oView:AddUserButton( 'Recalculo da tabela (CTRL+R)', 'CLIPS', { |oView| FwMsgRun(Nil,{||AN011() },Nil,"Recalculando tabela...") },, )

	// Liga a identificacao do componente
	oView:EnableTitleView('VIEW_FIL','Dados do Filtro')
	oView:EnableTitleView('VIEW_DPROD','Dados do Produto')
	oView:EnableTitleView('VIEW_SB1','Produto')
	oView:EnableTitleView('VIEW_ALT','Atualização')
	oView:EnableTitleView('VIEW_DA1','Tabela de Preço')

	oView:SetOnlyView( "VIEW_FIL")
	oView:SetOnlyView( "VIEW_SB1")
	oView:SetOnlyView( "VIEW_DA1")

	//Indica se a janela deve ser fechada ao final da operação. Se ele retornar .T. (verdadeiro) fecha a janela
	oView:bCloseOnOK := {|| .T.}

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} AN001
Cria Objetos
@author felipe.caiado
@since 31/08/2017
@version undefined
@param oPanel, object, Objeto do Painel
@type function
/*/
//-------------------------------------------------------------------
Static Function AN001(oPanel, oCodigo, cCodigo, oDescri, cDescri, oMarca, cCxmarc)

	@ 015,003 Say "Marca" 	Size 020,008 COLOR CLR_BLACK PIXEL OF oPanel
	@ 015,060 Say "Produto" Size 020,008 COLOR CLR_BLACK PIXEL OF oPanel
	@ 024,003 MSGET oMarca VAR cCxmarc WHEN .F. SIZE 050, 015 OF oPanel PIXEL
	@ 024,060 MSGET oCodigo VAR cCodigo WHEN .F. SIZE 070, 015 OF oPanel PIXEL
	@ 024,135 MSGET oDescri VAR cDescri WHEN .F. SIZE 200, 015 OF oPanel PIXEL

Return()

//-------------------------------------------------------------------
//
Static Function VldAltPrd()

	Local _lRet 	:= .T.
	Local _cCampo 	:= Readvar()
	Local oModel    := FWModelActive()
	Local oModelALT := oModel:GetModel( 'ALTDETAIL' )
	Local _nPrcBrt	:= oModelALT:GetValue("XX_PRCBRT")
	Local _nPrcVen	:= oModelALT:GetValue("XX_PRCLIQ")
	Local nDesconto := oModelALT:GetValue("XX_DESCONT")

	If Alltrim(_cCampo) $ "M->XX_PRCBRT/M->XX_PRCLIQ"
		_nPrcLiq := Round(_nPrcBrt - (_nPrcBrt * nDesconto/100),2)
		If QtdComp(_nPrcLiq) <> QtdComp(_nPrcVen)
			If !ApMsgYesNo("Confirma a a alteração do Preço desconsiderando os calculos ?")
				_lRet := .F.
			Else
				lAltPrc	:= .T.
			Endif
		Endif
	Endif
Return(_lRet)
//-------------------------------------------------------------------------------------------------------------
Static Function AN014

Local aArea := GetArea()
Local cArq   := ".CSV"
Local cLinha := ""
Local aCabec := {}
Local aDados := {}
Local cTipo  := "Database (*.CSV) | *.CSV | "
Local nH     := 1
Local nPosEmp := 0
Local nPosMar := 0
Local nPosLin := 0
Local nPosCod := 0
Local nPosDat := 0
Local nPosLet := 0
Local nPosDes := 0
Local cCodDA0 := Alltrim(SuperGetMv("AN_TABPRC",.F.,"100"))
Local cWhere  := ""
Local cAliasSB1		:= GetNextAlias()
Local aSelFil := {}
Local cEmpresa   := ""
Local cMarca     := ""
Local cProduto   := ""
Local dData      := dDataBase
Local cLetra     := ""
Local nDesconto  := 0
Local cCodMestre := ""
Local nNewPrcRep := 0
Local nNewPrcBrt := 0
Local nFator     := 0
Local nMargem    := 0
Local nNewPrcVen := 0
Local nX		 :=1
Local lCopLetra  := .T.
Local lCopDesco  := .F.
cArq := cGetFile(cTipo,"Arquivo para Importação",,'H:\LAP-SIS\_Letras_desc_Protheus\',,GETF_LOCALHARD + GETF_NETWORKDRIVE)

If !Empty(cArq)
	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será cancelada!","ATENCAO")
		Return
	EndIf
	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	aDados := {}
	While !FT_FEOF()
		IncProc("Lendo arquivo, aguarde...")
		cLinha := FT_FREADLN()
		If Empty(aCabec)
			aCabec := aClone(Separa(cLinha,";",.T.))
		Else
			aAdd(aDados, Separa(cLinha,";",.T.))
		Endif
		FT_FSKIP()
	EndDo
	FT_FUSE()
Endif
If Len(aCabec) > 0 .and. Len(aDados) > 0
	If Len(aCabec) == 7
		For nH:=1 to Len(aCabec)
			If "EMPRESA" $ UPPER(Alltrim(aCabec[nH]))
				nPosEmp := nH
			Endif
			If "MARCA" $ UPPER(Alltrim(aCabec[nH]))
				nPosMar := nH
			Endif
			If "LINHA" $ UPPER(Alltrim(aCabec[nH]))
				nPosLin := nH
			Endif
			If "PRODUTO" $ UPPER(Alltrim(aCabec[nH]))
				nPosCod := nH
			Endif
			If "DATA" $ UPPER(Alltrim(aCabec[nH]))
				nPosDat := nH
			Endif
			If "LETRA" $ UPPER(Alltrim(aCabec[nH]))
				nPosLet := nH
			Endif
			If "DESCONTO" $ UPPER(Alltrim(aCabec[nH]))
				nPosDes := nH
			Endif
		Next
		If nPosEmp > 0 .and. nPosMar > 0 .and. nPosLin > 0 .and. nPosCod > 0 .and. nPosDat > 0 .and. nPosLet > 0 .and. nPosDes > 0
			For nH:=1 to Len(aDados)
				cWhere  := ""
				cEmpresa  := aDados[nH, nPosEmp]
				cMarca    := aDados[nH, nPosMar]
				cLinha    := aDados[nH, nPosLin]
				cProduto  := aDados[nH, nPosCod]
				dData     := Ctod(aDados[nH, nPosDat])
				If !Empty(aDados[nH, nPosLet])
					cLetra := aDados[nH, nPosLet]
					lCopLetra := .T.
				Else
					cLetra := " "
					lCopLetra := .F.
				Endif
				If Empty(aDados[nH, nPosDes])
					nDesconto := 0
					lCopDesco := .F.
				Else
					nDesconto := Val(StrTran(aDados[nH, nPosDes],",","."))
					lCopDesco := .T.
				Endif
				If lCopLetra .or. lCopDesco
					If !Empty(cMarca)
						cWhere += " AND B1_XMARCA = '" + cMarca + "'"
					Else
						cWhere += " AND B1_XMARCA <> ' '"
					EndIf
					If !Empty(cProduto)
						cWhere += " AND B1_COD = '" + ALLTRIM(cProduto) + "'"
					EndIf
					If !Empty(cLinha)
						cWhere += " AND B1_XLINHA = '" + cLinha + "'"
					EndIf
					cQuery := "SELECT B1_XMARCA, B1_COD, B1_DESC, B1_XLINHA, B1_XALTIMP"
					cQuery += " FROM "+RETSQLNAME("SB1")+" WHERE D_E_L_E_T_ = ' ' "
					cQuery += " AND B1_FILIAL='"+XFILIAL("SB1")+"'"
					cQuery += " AND B1_MSBLQL <> '1'
					cQuery += " AND B1_TIPO = 'ME'
					cQuery +=  cWhere
					cQuery +=  " ORDER BY B1_XMARCA, B1_XLINHA, B1_COD"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSB1,.F.,.T.)
					dbSelectArea(cAliasSB1)
					While !Eof()
						cEmpresa   := Alltrim(aDados[nH, nPosEmp])
						aSelFil	   := {}
						If cEmpresa == "GERAL"
							aSelFil := AdmAbreSM0()
						Else
							aadd(aSelFil, {cEmpAnt, cEmpresa})
						Endif
						For nX:=1 to Len(aSelFil)
							If Substr(aSelFil[nX,2],1,2) == "02"
								cEmpProc   := aSelFil[nX,2]
								cMarca     := (cAliasSB1)->B1_XMARCA
								cLinha     := (cAliasSB1)->B1_XLINHA
								cProduto   := (cAliasSB1)->B1_COD
								If !lCopLetra
									cLetra 	   := AN006(cEmpProc, cProduto, "DA1_XLETRA","1", .F., cLinha, cMarca, dData, cLetra)
								Endif
								If !lCopDesco
									nDesconto  := AN006(cEmpProc, cProduto, "DA1_XDESCV","1", .F., cLinha, cMarca, dData, cLetra)
								Endif
								cCodMestre := (cAliasSB1)->B1_XALTIMP
								nNewPrcRep := AN006(cEmpProc, cProduto, "DA1_XPRCRE","1", .F., cLinha, cMarca, dData, cLetra)
								nNewPrcBrt := AN006(cEmpProc, cProduto, "DA1_XPRCBR","1", .F., cLinha, cMarca, dData, cLetra)
								nFator     := AN006(cEmpProc, cProduto, "DA1_XFATOR","1", .F., cLinha, cMarca, dData, cLetra)
								nMargem    := AN006(cEmpProc, cProduto, "DA1_XMARGE","1", .F., cLinha, cMarca, dData, cLetra)
								nNewPrcVen := 0
								ProcAlt("1",cEmpProc, cCodDA0, cProduto, cMarca, cLetra, dData, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cCodMestre )
							Endif
						Next
						dbSelectArea(cAliasSB1)
						dbSkip()
					End
					dbSelectArea(cAliasSB1)
					DbCloseArea()
				Endif
			Next
		Endif
	Endif
Endif
RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} AN002
Load dos produtos
@author felipe.caiado
@since 13/03/2019
@version 1.0
@param oModelGrid, object, descricao
@param lCopy, logical, descricao
@type function
/*/
//-------------------------------------------------------------------
Static Function AN002(oCodigo, oDescri, oMarca)

	Local aLoad 		:= {}
	Local aRet as array
	Local aPerg as array
	Local oModel     	:= FWModelActive()
	Local oModelSB1  	:= oModel:GetModel( 'SB1DETAIL' )
	Local oModelALT  	:= oModel:GetModel( 'ALTDETAIL' )
	Local nLinhaSB1  	:= 1
	Local cAliasSB1		:= GetNextAlias()
	Local cWhere		:= ""
	Local oView			:= FwViewActive()
	Local aCurva		:= {}
	Local aMarca		:= {}
	Local nH			:= 1
	Local lMostraCM		:= .T.
	Local aCodMestr		:= {}
	Local cABCVQ		:= "Q"
	Local cPer
	Local dIniABC		:= Ctod("  /  /  ")
	Local dFimABC		:= dDataBase
	Local aSM0			:= {}
	Local cFilSelABC	:= ""

	aRet 	:= {}
	aPerg	:= {}

	lCopPRep := .F.

	aAdd( aPerg ,{1,Alltrim("Marca")	,Space(TAMSX3("ZZM_CODMAR")[1])	,"@!",".T.","ZZM","",40,.F.})
	aAdd( aPerg ,{1,Alltrim("Produto")	,Space(TAMSX3("B1_COD")[1])		,"@!",".T.","SB1","",65,.F.})
	aAdd( aPerg ,{1,Alltrim("Linha")	,Space(TAMSX3("B1_XLINHA")[1])	,"@!",".T.","","",20,.F.})
	aAdd( aPerg ,{1,Alltrim("Curva")	,Space(1)						,"@!",".T.","","",10,.F.})
	aAdd( aPerg ,{2,"Periodo Curva" 	,3		,{"1-Anual","2-Semestral","3-Trimestral"},60,'',.T.})
	aAdd( aPerg ,{2,"Curva por" 		,1		,{"1-Valor","2-Quantidade"},60,'',.T.})
	aAdd( aPerg ,{2,"Cod.Mestre Iguais" ,2		,{"1-Mostrar","2-Nao Mostrar"},60,'',.T.})

	If !ParamBox(aPerg ,"Filtros",@aRet,/*bok*/,/*aButtons*/,/*lCentered*/, /*nPosX*/, /*nPosY*/, /*oDlgWizard*/, /*cLoad*/, /*lCanSave*/.F.,/*lUserSave*/.F.)
		Return()
	EndIf

	If Empty(MV_PAR01) .And. Empty(MV_PAR02) .And. Empty(MV_PAR04) .and. !Empty(MV_PAR03)
		ApMsgInfo("Filtro apenas por Linha não permitido")
		Return()
	EndIf
	aSM0 := FWLoadSM0(.T.)
	For nH:=1 To Len(aSM0)
		If Substr(aSM0[nH][SM0_FILIAL],1,2) == "02"
			If !Empty(cFilSelABC)
				cFilSelABC += ","
			Endif
			cFilSelABC += aSM0[nH][SM0_FILIAL]
		EndIF
	Next
	//////////////////////////////////////////////////////////////////
	/// Ita - 29/04/2019
	///     - Para evitar erro de execução, caso a marca não seja
	///       informada, sistema irç pegar do cadastro do produto.
	xMrkChk := MV_PAR01

	If Type("mv_par05") == "N"
		cPer := Alltrim(Str(mv_par05))
	Else
		cPer := Substr(mv_par05,1,1)
	Endif

	If cPer == "1"	//Anual
		dIniABC := dFimABC - 365
	ElseIf cPer == "2"	//Semestral
		dIniABC := dFimABC - 180
	Else
		dIniABC := dFimABC - 90
	Endif

	If (Type("mv_par06") == "N" .and. mv_par06 == 1) .or. (Type("mv_par06") == "C" .and. Substr(mv_par06,1,1) == "1")
		cABCVQ := "V"
	Endif

	If (Type("mv_par07") == "N" .and. mv_par07 == 2) .or. (Type("mv_par07") == "C" .and. Substr(mv_par07,1,1) == "2")
		lMostraCM := .F.
	Endif
	If !Empty(MV_PAR02)
		cProdChk := Posicione("SB1",1,xFilial("SB1")+MV_PAR02,"B1_COD")
		If Empty(cProdChk)
			Alert("O código "+MV_PAR02+" não foi localizado no cadastro de produtos, favor informar um cçdigo existente neste cadastro")
			Return
		EndIf
		xMrkChk := Posicione("SB1",1,xFilial("SB1")+cProdChk,"B1_XMARCA")
		If Empty(xMrkChk)
			Alert("O produto "+cProdChk+" não possui marca em seu cadastro, favor informar uma marca para continuar este procedimento ")
			Return
		EndIf
		//MV_PAR01 := xMrkChk
	EndIf
	If !Empty(xMrkChk)
		//Ita - 08/09/2020 - Possibilitar filtro apenas da marca digitada no parâmetro - aMarca := u_RetMarc(xMrkChk)
		aMarca := {xMrkChk}
		If Empty(aMarca)
			Help( ,, 'HELP',, 'Marca informada não cadastrada', 1, 0)
			Return
		Endif
	Endif
	//Limpa o Grid
	oModelSB1:ClearData(.F.,.T.)
	oModelALT:ClearData(.F.,.T.)
	oModel:GetModel("FILMASTER"):GetStruct():SetProperty("*",MODEL_FIELD_WHEN,{|| .T.})
	oModel:GetModel("FILMASTER"):SetValue("XX_MARCA",Alltrim(xMrkChk))//Ita - 29/04/2019 Alltrim(MV_PAR01))
	oModel:GetModel("FILMASTER"):SetValue("XX_PRODUT",Alltrim(MV_PAR02))
	oModel:GetModel("FILMASTER"):SetValue("XX_LINHA",Alltrim(MV_PAR03))
	oModel:GetModel("FILMASTER"):SetValue("XX_CURVA",Alltrim(MV_PAR04))
	oModel:GetModel("FILMASTER"):GetStruct():SetProperty("*",MODEL_FIELD_WHEN,{|| .F.})
	If !Empty(MV_PAR01)
		//Ita - 29/04/2019 - cWhere += " AND B1_XMARCA = '" + MV_PAR01 + "'"
		If Len(aMarca) == 1
			cWhere += " AND B1_XMARCA = '" + xMrkChk + "'"
		ElseIf Len(aMarca) > 1
			For nH:=1 to Len(aMarca)
				If nH == 1
					cWhere += " AND (B1_XMARCA = '" + aMarca[nH] + "'"
				else
					cWhere += " OR B1_XMARCA = '" + aMarca[nH] + "'"
				Endif
			Next
			cWhere += ")"
		Endif
	Else
		cWhere += " AND B1_XMARCA <> ' '"
	EndIf
	If !Empty(MV_PAR02)
		cWhere += " AND B1_COD >= '" + ALLTRIM(MV_PAR02) + "'"
		cWhere += " AND B1_COD <= '" + ALLTRIM(MV_PAR02) + "ZZZZZ'"
	EndIf
	If !Empty(MV_PAR03)
		cWhere += " AND B1_XLINHA = '" + MV_PAR03 + "'"
	EndIf

	cQuery := "SELECT B1_XMARCA, B1_COD, B1_DESC, B1_XLINHA, B1_XALTIMP"
	cQuery += " FROM "+RETSQLNAME("SB1")+" WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND B1_FILIAL='"+XFILIAL("SB1")+"'"
	cQuery += " AND B1_MSBLQL <> '1'
	cQuery += " AND B1_TIPO = 'ME'
	cQuery +=  cWhere
	cQuery +=  " ORDER BY B1_XMARCA, B1_XLINHA, B1_COD"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSB1,.F.,.T.)
	oModelSB1:SetNoInsertLine(.F.)
	oModelSB1:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:SetNoInsertLine(.F.)
	oModelALT:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:GetStruct():SetProperty('XX_FILIAL',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:GetStruct():SetProperty('XX_DATA',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:GetStruct():SetProperty('XX_CSTAQU',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:GetStruct():SetProperty('XX_MARGEM',MODEL_FIELD_WHEN,{||.T.})
	oModelALT:GetStruct():SetProperty('XX_FTPRC',MODEL_FIELD_WHEN,{||.T.})

	While (cAliasSB1)->( !Eof() )
		xMrkChk := (cAliasSB1)->B1_XMARCA
		aCurva := U_Calc_Curv(Alltrim(xMrkChk), dIniABC, dFimABC, cABCVQ, FormatIn(Alltrim(cFilSelABC),",") )
		While (cAliasSB1)->( !Eof() ) .and. xMrkChk == (cAliasSB1)->B1_XMARCA
			If !Empty((cAliasSB1)->B1_XALTIMP)
				nPos := aScan(aCodMestr,{|x| x[2] == (cAliasSB1)->B1_XALTIMP})
				If nPos == 0
					aadd(aCodMestr, {(cAliasSB1)->B1_COD, (cAliasSB1)->B1_XALTIMP})
				Else
					If !lMostraCM
						(cAliasSB1)->(DbSkip())
						Loop
					Endif
				Endif
			Endif
			nPos := aScan(aCurva,{|x| Alltrim(x[1]) == Alltrim((cAliasSB1)->B1_COD)})
			If !Empty(MV_PAR04)
				If nPos > 0
					If !Alltrim(aCurva[nPos][6]) $ Alltrim(MV_PAR04)
						(cAliasSB1)->(DbSkip())
						Loop
					EndIf
				EndIf
			EndIf
			If nLinhaSB1 > 1
				If oModelSB1:AddLine() <> nLinhaSB1
//					Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
					(cAliasSB1)->(DbSkip())
					Loop
				Endif
			EndIf
			oModelSB1:SetValue( 'B1_COD',(cAliasSB1)->B1_COD )
			oModelSB1:SetValue( 'B1_DESC',Substr((cAliasSB1)->B1_DESC,1,18) )
			oModelSB1:SetValue( 'B1_XLINHA',(cAliasSB1)->B1_XLINHA )
			oModelSB1:SetValue( 'B1_XALTIMP',(cAliasSB1)->B1_XALTIMP )
			If nPos > 0
				oModelSB1:SetValue( 'B1_CURVA',Alltrim(aCurva[nPos][6]) )
			Else
				oModelSB1:SetValue( 'B1_CURVA'," " )
			Endif
			nLinhaSB1++
			(cAliasSB1)->(DbSkip())
		Enddo
	Enddo
	(cAliasSB1)->(DbCloseArea())
	oModelSB1:GoLine(1)
	oView:Refresh('VIEW_SB1')
	oView:Refresh('VIEW_ALT')
	AN003(oCodigo, oDescri, oMarca)
	oModelSB1:SetNoInsertLine(.T.)
	lUpdCNF := oModelSB1:CanUpdateLine()
	oModelSB1:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
	oModelSB1:SetNoUpdateLine(!lUpdCNF)
	oModelALT:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
Return(aLoad)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN003
Atualiza registro do produto
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN003(oCodigo, oDescri, oMarca)

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oModelSB1  	:= oModel:GetModel( 'SB1DETAIL' )
	Local oModelDA1  	:= oModel:GetModel( 'DA1DETAIL' )
	Local nLinhaDA1  	:= 1
	Local cAliasDA1		:= GetNextAlias()
	cCodigo := oModelSB1:GetValue("B1_COD")
	cDescri := Substr(Posicione("SB1",1,xFilial("SB1")+oModelSB1:GetValue("B1_COD"),"B1_DESC"),1,18)
	cCxmarc := Posicione("SB1",1,xFilial("SB1")+oModelSB1:GetValue("B1_COD"),"B1_XMARCA")
	oCodigo:Refresh()
	oDescri:Refresh()
	oMarca:Refresh()
	oView:Refresh('VIEW_DPROD')
	cQuery := "SELECT DA1_FILIAL, DA1_XTABSQ, DA1_DATVIG, DA1_XPRCBR, DA1_XDESCV, DA1_PRCVEN, DA1_XLETRA, DA1_XPRCRE, DA1_CODPRO"
	cQuery += " FROM "+RETSQLNAME("DA1")+" WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND DA1_CODPRO = '" + cCodigo + "' "
	cQuery +=  " ORDER BY DA1_XTABSQ, DA1_FILIAL"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasDA1,.F.,.T.)
	//Limpa o Grid
	oModelDA1:ClearData(.F.,.T.)
	oModelDA1:SetNoInsertLine(.F.)
	oModelDA1:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
	While (cAliasDA1)->( !Eof() )
		If nLinhaDA1 > 1
			If oModelDA1:AddLine() <> nLinhaDA1
//				Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
				(cAliasDA1)->(DbSkip())
				Loop
			EndIf
		EndIf
		oModelDA1:SetValue( 'DA1_FILIAL',(cAliasDA1)->DA1_FILIAL )
		oModelDA1:SetValue( 'DA1_DATVIG',StoD((cAliasDA1)->DA1_DATVIG) )
		oModelDA1:SetValue( 'DA1_XTABSQ',(cAliasDA1)->DA1_XTABSQ )
		oModelDA1:SetValue( 'DA1_XPRCBR',(cAliasDA1)->DA1_XPRCBR )
		oModelDA1:SetValue( 'DA1_XDESCV',(cAliasDA1)->DA1_XDESCV )
		oModelDA1:SetValue( 'DA1_XPRCRE',(cAliasDA1)->DA1_XPRCRE )
		oModelDA1:SetValue( 'DA1_XLETRA',(cAliasDA1)->DA1_XLETRA )
		oModelDA1:SetValue( 'DA1_XPRCLI',(cAliasDA1)->DA1_PRCVEN )
		oModelDA1:SetValue( 'DA1_XCSTAQ',AN005((cAliasDA1)->DA1_FILIAL,(cAliasDA1)->DA1_CODPRO, (cAliasDA1)->DA1_XTABSQ, 1) )
		oModelDA1:SetValue( 'DA1_XDOC'  ,AN005((cAliasDA1)->DA1_FILIAL,(cAliasDA1)->DA1_CODPRO, (cAliasDA1)->DA1_XTABSQ, 2) )
		nLinhaDA1++
		(cAliasDA1)->(DbSkip())
	Enddo
	oModelDA1:SetNoInsertLine(.T.)
	lUpdCNF := oModelDA1:CanUpdateLine()
	oModelDA1:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
	oModelDA1:SetNoUpdateLine(!lUpdCNF)
	(cAliasDA1)->(DbCloseArea())
	oModelDA1:GoLine(1)
	oView:Refresh('VIEW_DA1')
	oView:Refresh('VIEW_FIL')
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN004
Atualiza o grid de Alteração
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN004(lAltLetra, lAltDesc, cDescri)

	Local oModel     	:= FWModelActive()
	Local oView			:= FwViewActive()
	Local oModelALT  	:= oModel:GetModel( 'ALTDETAIL' )
	Local nLinhaALT  	:= 1
	Local nH			:= 0

	aFilOri	:= {}
	aFilCopy:= {}
	lCopPRep:= .F.
	aColsBkp:= {}

	//Limpa o Grid
	oModelALT:ClearData(.F.,.T.)

	//Dados do SM0
	aSM0 := FWLoadSM0(.T.)

	For nH:=1 To Len(aSM0)

		If Substr(aSM0[nH][SM0_FILIAL],1,2) <> "02"
			Loop
		EndIF

		oModelALT:SetNoInsertLine(.F.)

		If nLinhaALT > 1
			If oModelALT:AddLine() <> nLinhaALT
//				Help( ,, 'HELP',, 'Nao incluiu linha SB1' + CRLF + oModel:getErrorMessage()[6], 1, 0)
				Loop
			EndIf
		EndIf

		oModelALT:SetNoInsertLine(.T.)

		lUpdCNF := oModelALT:CanUpdateLine()

		If !lUpdCNF
			oModelALT:SetNoUpdateLine(.F.)
		EndIf

		oModelALT:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

		oModelALT:SetValue( 'XX_FILIAL'		, aSM0[nH][SM0_FILIAL])
		oModelALT:SetValue( 'XX_DATA'		,CtoD('  /  /  ') )
		oModelALT:SetValue( 'XX_CSTAQU'		,0)
		oModelALT:SetValue( 'XX_PRCREP'		,0 )
		oModelALT:SetValue( 'XX_LETRA'		," " )
		oModelALT:SetValue( 'XX_MARGEM'		,0 )
		oModelALT:SetValue( 'XX_FTPRC'		,0 )
		oModelALT:SetValue( 'XX_PRCBRT'		,0 )
		oModelALT:SetValue( 'XX_DESCONT'	,0 )
		oModelALT:SetValue( 'XX_PRCLIQ'		,0 )
		If lAltLetra
			oModelALT:GetStruct():SetProperty('XX_FILIAL',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_CSTAQU',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_MARGEM',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_FTPRC',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCBRT',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCLIQ',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_DESCONT',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCREP',MODEL_FIELD_WHEN,{||.F.})
		ElseIf lAltDesc
			oModelALT:GetStruct():SetProperty('XX_FILIAL',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_CSTAQU',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_MARGEM',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_FTPRC',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCBRT',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCLIQ',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_LETRA',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_PRCREP',MODEL_FIELD_WHEN,{||.F.})
		Else
			oModelALT:GetStruct():SetProperty('XX_FILIAL',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_CSTAQU',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_MARGEM',MODEL_FIELD_WHEN,{||.F.})
			oModelALT:GetStruct():SetProperty('XX_FTPRC',MODEL_FIELD_WHEN,{||.F.})
		EndIf
//		oModelALT:SetNoUpdateLine(!lUpdCNF)
		nLinhaALT++
		aadd(aColsBkp, {oModelALT:GetValue("XX_FILIAL"), oModelALT:GetValue("XX_DATA"), oModelALT:GetValue("XX_PRCREP"), oModelALT:GetValue("XX_LETRA"), oModelALT:GetValue("XX_DESCONT")})
	Next
	//Atualiza titulo da view
	oView:EnableTitleView( "VIEW_ALT", cDescri )
	oView:aViews[4,3]:cTitle := cDescri
	oView:Refresh('VIEW_RODAPE')
	oModelALT:GoLine(1)
	oView:EnableTitleView('VIEW_ALT','FELIPE')
	oView:Refresh('VIEW_ALT')
	oView:GetViewObj("VIEW_ALT")[3]:oBrowse:oBrowse:SetFocus()

//	oView:GetViewObj("VIEW_ALT")[3]:getFWEditCtrl("XX_DATA"):oCtrl:SetFocus()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN005
Busca o çltimo Custo de Compra
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN005(cFilNF, cProduto, cSeqTab, nTipo)

	Local cAliasSD1	:= GetNextAlias()
	Local xRet
	Local nPos	:= 0
	Local nI	:=1
	Local lContinua := .T.
	Local cWhere

	cWhere := "%D1_COD = '" + cProduto + "' AND D1_QUANT > 0 AND D1_TES <> ' ' AND D1_TIPO = 'N'"
	If cFilNf == "020104"
		cWhere += " AND D1_XOPER IN ('01','05')"
	Else
		cWhere += " AND D1_XOPER = '01' AND D1_FORNECE NOT LIKE 'AUT%'"
	Endif
	cWhere += "%"

	BeginSQL alias cAliasSD1
		SELECT
			ROUND(D1_CUSTO / D1_QUANT,2) CUSINI ,
			D1_DOC
		FROM
			%table:SD1% SD1
		WHERE
			D1_FILIAL = %exp:cFilNf%
			AND %Exp:cWhere%
			AND SD1.%notDel%
		ORDER BY D1_FILIAL, D1_DTDIGIT DESC
	EndSql
	If (cAliasSD1)->(Eof())
		If nTipo == 1
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+cProduto))
				xRet := SB1->B1_UPRC
			EndIf
		Else
			xRet := ""
		EndIf
	Else
		If Val(cSeqTab) > 1
			For nI:=2 to Val(cSeqTab)
				(cAliasSD1)->(dbSkip())
				If Eof()
					If nTipo == 1
						DbSelectArea("SB1")
						SB1->(DbSetOrder(1))
						If SB1->(DbSeek(xFilial("SB1")+cProduto))
							xRet := SB1->B1_UPRC
						EndIf
					Else
						xRet := ""
					EndIf
					lContinua := .F.
					Exit
				Endif
			Next
		Endif
		If lContinua
			If nTipo == 1
				xRet := (cAliasSD1)->CUSINI
			Else
				xRet := (cAliasSD1)->D1_DOC
			EndIf
		Endif
	EndIf
	(cAliasSD1)->(DbCloseArea())
	If Readvar() == "M->XX_DATA"
		nPos := aScan( aColsBkp, { |x| x[1] ==  cFilNF } )
		If nPos > 0
			aColsBkp[nPos, 2] := M->XX_DATA
		Endif
	Endif
Return(xRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN006
Posiciona na Tabela de Preço
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN006(cFilNF, cProduto, cCampo, cSeqTab, lParam, _cLinhaSB1, _cCodMarc, dData, _cLetra)

	Local nRet			:= If(Alltrim(cCampo) == "DA1_XLETRA",Alltrim(GetMV("AN_LTRIMP")),0)
	Local _cMonoFas
	Local cFilOri      := cFilAnt
	Local cCodDA0      := Alltrim(SuperGetMv("AN_TABPRC",.F.,"100"))
	Local _aRetMark    := {}
	Local _nMarKup     := 0
	Local _nMargem     := 0
	Local oModel       := FWModelActive()
	Local oModelMst    := oModel:GetModel( 'FILMASTER' )
	Local oModelSB1    := oModel:GetModel( 'SB1DETAIL' )
	Local oModelALT    := oModel:GetModel( 'ALTDETAIL' )
	Local nPos         := aScan( aColsBkp, { |x| x[1] == cFilNF } )
	Local nK           := 1
	Local nSeqtabLer   := 1 /*Indica a tabela que está lendo para encontrar os dados. Inicia lendo a 1, depois vai para 2 e 3 e se não encontrar o campo que produra, sai sem o retorno*/
	Local nPModelALT   := 0
	Default lParam	   := .T.
	Default cSeqTab    := " "
	Default _cLinhaSB1 := oModelSB1:GetValue("B1_XLINHA")
	Default _cCodMarc  := oModelMst:GetValue("XX_MARCA")
	Default dData      := oModelALT:GetValue("XX_DATA")
	Default _cLetra    := oModelALT:GetValue("XX_LETRA")
	cFilAnt            := cFilNF
	lAltPrc            := .F.
	lEncontrou         := .F.
	If lParam
		For nK:=1 to oModelALT:Length()
			oModelALT:GoLine(nK)
			If oModelALT:GetValue("XX_FILIAL") == cFilAnt
				dData := oModelALT:GetValue("XX_DATA")
				_cLetra	:= oModelALT:GetValue("XX_LETRA")
				nPModelALT := nK
				Exit
			Endif
		Next
	Endif
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO
	For nSeqtabLer := 1 to 3
		If DA1->(DbSeek(cFilNF+cCodDA0+cProduto))
			While !DA1->(Eof()) .And. cFilNF+cCodDA0+cProduto == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
				If alltrim(DA1->DA1_XTABSQ) == alltrim(str(nSeqtabLer))
					If cCampo == "DA1_XMARGE"
						_cMonoFas   := IIF(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_XMONO")=="S","S","N")
						_aRetMark 	:= u_RetMarkup(_cMonoFas, _cCodMarc, _cLinhaSB1, cFilAnt)
						_nMarKup  	:= _aRetMark[1]
						_nLetra 	:= u_RetLetra(cFilAnt, _cLetra)
						_nMargem 	:= (1 + (_nMarKup/100)) * _nLetra
						_nMargem 	:= Round((_nMargem - 1) * 100,2)
						If _nMargem < 0
							_nMargem := 0
						Endif
						nRet := _nMargem
						lEncontrou := .T.
					ElseIf cCampo == "DA1_XFATOR"
						_cMonoFas   := IIF(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_XMONO")=="S","S","N")
						_aRetMark 	:= u_RetMarkup(_cMonoFas, _cCodMarc, _cLinhaSB1, cFilAnt)
						_nFator  	:= _aRetMark[2]
						nRet 		:= _nFator
						lEncontrou := .T.
					ElseIf cCampo == "DA1_XLETRA"
						nRet := u_BuscTabVig(cProduto, , dData)[1]
						If nPos > 0
							aColsBkp[nPos, 4] := nRet
						Endif
						lEncontrou := .T.
					ElseIf cCampo == "DA1_XPRCBR"
						_cMonoFas   := IIF(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_XMONO")=="S","S","N")
						_aRetPrc 	:= u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, DA1->DA1_FILIAL, DA1->DA1_XPRCRE, DA1->DA1_XDESCV)
						nRet 		:= _aRetPrc[6]
						lEncontrou := .T.
					ElseIf cCampo == "DA1_XPRCLI"
						_cMonoFas   := IIF(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_XMONO")=="S","S","N")
						_aRetPrc 	:= u_CalcPrcV(_cLetra, _cMonoFas, _cCodMarc,_cLinhaSB1, DA1->DA1_FILIAL, DA1->DA1_XPRCRE, DA1->DA1_XDESCV)
						nRet 		:= _aRetPrc[4]
						lEncontrou := .T.
					Else
						nRet := DA1->&(cCampo)
						lEncontrou := .T.
						If nPos > 0
							If cCampo == "DA1_XPRCRE"
								aColsBkp[nPos, 3] := nRet
							ElseIf cCampo == "DA1_XDESCV"
								aColsBkp[nPos, 5] := nRet
							Endif
						Endif
					Endif
					Exit
				EndIf
				If !Empty(cSeqTab)
					If alltrim(DA1->DA1_XTABSQ) == cSeqTab
						Exit
					Endif
				Endif
				DA1->(DbSkip())
			EndDo
		Else
			nRet := 0
			//Ita - 29/09/2020 - If cCampo == "DA1_XLETRA"
			If Alltrim(cCampo) == "DA1_XLETRA"
				nRet := Alltrim(GetMV("AN_LTRIMP"))
				Exit
/*
				If Empty(_cLetra)
					nRet := Alltrim(GetMV("AN_LTRIMP"))
				Else
					nRet := _cLetra
				Endif
*/
			Endif

		EndIf
		iF lEncontrou
			Exit
		Endif
	Next
	//Ita - 29/09/2020 - trata o retorno quando for DA1_XLETRA
	//Help( ,, 'HELP',, 'cCampo: ['+cCampo+'] nRet: ['+cValToChar(nRet)+']', 1, 0)
	/*
	If Alltrim(cCampo) == "DA1_XLETRA" .And. nRet == 0
		nRet := " "
	Endif
	*/
	cFilAnt := cFilOri
	If lParam
		If nPModelALT > 0
			oModelALT:GoLine(nPModelALT)
		Else
			oModelALT:GoLine(1)
		Endif
	Endif
Return(nRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN007
Salva os dados
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN007(lAltLetra,lAltDesc)

	Local _aArea       := GetArea()
	Local oModel       := FWModelActive()
	Local oView        := FwViewActive()
	Local oModelSB1    := oModel:GetModel( 'SB1DETAIL' )
	Local oModelALT    := oModel:GetModel( 'ALTDETAIL' )
	Local oModelFIL    := oModel:GetModel( 'FILMASTER' )
	Local nH           := 0
	Local nY           := 0
	Local cCodDA0      := Alltrim(SuperGetMv("AN_TABPRC",.F.,"100"))
	Local cCodxx       := oModelSB1:GetValue("B1_COD")
	Local cCodMestre   := oModelSB1:GetValue("B1_XALTIMP")
	Local cMarca       := oModelFIL:GetValue("XX_MARCA")
	Local cFilOri      := cFilAnt
	Local cFil
	Local aArqTmp      :={}, aSeeks := {}, aIndex := {}, aColumns := {}, aArqTab := {}, aFields := {}, aColsSX3 := {}
	Local oTabTmp      := Nil
	Local oFnt2S       := TFont():New("Arial ", 7, 15, .F., .F., , , , , .F.) //NEGRITO SUBLINHADO
	Local cAliasTmp    := GetNextAlias()
	Local nPos
	Local aFilCopy     := {}
	Local lCopLetra    := .F.
	Local lCopPrcRp    := .F.
	Local lCopDesco    := .F.
	Local cFilOrigem   := IIf(Len(aFilOri)>0, aFilOri[1,2], " ")
	Local aCodMestre   := {}
	Private lProd      := .F.
	Private _lContinua := .T.

	Aadd(aSeeks,{"Filial"	 , {{"","C",TAMSX3("Z3_FILIAL")[1],0, "TMP_FILIAL",""}}, 1, .T. } )
	Aadd( aIndex, "TMP_FILIAL" )

	AAdd(aArqTmp,{"TMP_FILIAL",BuscarSX3("Z3_FILIAL"  , ,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 080})
	BuscarSX3("Z2_DATA"	  , ,aColsSX3)
	AAdd(aArqTmp,{"TMP_DATA"  ,"Data"								,"D",aColsSX3[3],aColsSX3[4],aColsSX3[2], 100})
	BuscarSX3("D1_CUSTO"   , ,aColsSX3)
	AAdd(aArqTmp,{"TMP_PRCREP",BuscarSX3("Z3_PRCREP"  , ,aColsSX3)	,"C",aColsSX3[3]+2,0," ", 100})
	AAdd(aArqTmp,{"TMP_LETRA" ,BuscarSX3("Z3_LETRA"   , ,aColsSX3)	,"C",aColsSX3[3],aColsSX3[4],aColsSX3[2], 050})
	AAdd(aArqTmp,{"TMP_DESCON",BuscarSX3("Z3_DESCONT" , ,aColsSX3)	,"C",5,0," ", 100})

	For nH := 1 To Len(aArqTmp)
		AAdd(aColumns,FWBrwColumn():New())
		aColumns[Len(aColumns)]:lAutosize:=.f.
		aColumns[Len(aColumns)]:SetData( &("{||"+aArqTmp[nH][1]+"}") )
		aColumns[Len(aColumns)]:SetTitle(aArqTmp[nH][2])
		aColumns[Len(aColumns)]:SetType(aArqTmp[nH][3])
		aColumns[Len(aColumns)]:SetSize(aArqTmp[nH][7])
		aColumns[Len(aColumns)]:SetDecimal(aArqTmp[nH][5])
		aColumns[Len(aColumns)]:SetPicture(aArqTmp[nH][6])
		If aArqTmp[nH][3] $ "N/D"
			aColumns[Len(aColumns)]:nAlign := 3
		Endif
		AAdd(aArqTab,{aArqTmp[nH][1],aArqTmp[nH][3],aArqTmp[nH][4],aArqTmp[nH][5]})
		AAdd(aFields,{aArqTmp[nH][1],aArqTmp[nH][2],aArqTmp[nH][3],aArqTmp[nH][4],aArqTmp[nH][5],aArqTmp[nH][6]})
	Next nH
	CriaTabTmp(aArqTab,aIndex,cAliasTmp,@oTabTmp)
	//MsgInfo("Estou no F6 - Vou Iniciar a gravação - oModelALT:Length(): "+cValToChar(oModelALT:Length()))
	For nY := 1 to oModelALT:Length()
		oModelALT:GoLine(nY)
		If !Empty(oModelALT:GetValue("XX_DATA"))
			If oModelALT:GetValue("XX_PRCREP") <= 0
				_lContinua := .F.
				Help( NIL, NIL, "PRCZERO", NIL, "Preço de reposição zerado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique a nova tabela, não poderá ser criada com preço de reposição igual a zero"})
				Exit
			Endif
		Endif
	Next
	If _lContinua
		_lContinua	:= .F.
		For nY := 1 to oModelALT:Length()
			oModelALT:GoLine(nY)
			//MsgInfo("F6 - Checando XX_DATA da linha "+cValToChar(nY)+" oModelALT:GetValue('XX_DATA'): "+DTOC(oModelALT:GetValue("XX_DATA")))
			If !Empty(oModelALT:GetValue("XX_DATA"))
				//MsgInfo("F6 - Entrei no If da Data")
				cFil   	:= oModelALT:GetValue("XX_FILIAL")
				nPos 	:= aScan( aColsBkp, { |x| x[1] ==  cFil } )
				If nPos > 0
					//MsgInfo('F6  Entre no if do nPos')
					cLetra 	  := Upper(oModelALT:GetValue("XX_LETRA"))
					nPrcRep   := oModelALT:GetValue("XX_PRCREP")
					nDesconto := oModelALT:GetValue("XX_DESCONT")
					dbSelectArea(cAliasTmp)
					RecLock(cAliasTmp,.T.)
					Replace TMP_FILIAL 	with cFil
					Replace TMP_DATA	with oModelALT:GetValue("XX_DATA")
					If cLetra <> aColsBkp[nPos, 4]
						lCopLetra := .T.
						Replace TMP_LETRA	with cLetra
					Endif
					If QtdComp(nPrcRep) <> QtdComp(aColsBkp[nPos, 3])
						lCopPrcRp := .T.
						Replace TMP_PRCREP	with Alltrim(Transform(nPrcRep,PesqPict("SZ3","Z3_PRCREP")))
					Endif
					If QtdComp(nDesconto) <> QtdComp(aColsBkp[nPos, 5])
						lCopDesco := .T.
						Replace TMP_DESCON	with Alltrim(Transform(nDesconto,PesqPict("SZ3","Z3_DESCONT")))
					Endif
					MsUnLock()
				Endif
			Endif
		Next
	Endif
	dbSelectArea(cAliasTmp)
	dbGotop()
	If !Eof() .and. !Bof()
		DEFINE MSDIALOG oDlgAB TITLE "Alterações Realizadas" From 300,0 to 800,1000 OF oMainWnd PIXEL
		oBrowse := FWMBrowse():New()
		oBrowse:SetOwner(oDlgAB)
		// Titulo da Browse
		oBrowse:SetDescription("")
		oBrowse:SetTemporary(.T.)
		// Definição da legenda
		oBrowse:SetAlias(cAliasTmp)
		oBrowse:SetQueryIndex(aIndex)
		oBrowse:SetColumns(aColumns)
		oBrowse:SetMenuDef('ANCOM01')
//		oBrowse:SetSeek(.T.,aSeeks)
		oBrowse:SetWalkThru(.F.)
		oBrowse:SetAmbiente(.F.)
		oBrowse:SetProfileID('TMP')
		// Opcionalmente pode ser desligado a exibição dos detalhes
		oBrowse:DisableDetails()
		// Ativação da Classe
		oBrowse:Activate()
		oBrowse:SetFontBrowse(oFnt2S)
		ACTIVATE MSDIALOg oDlgAB CENTERED
	Endif
	DelTabTmp(cAliasTmp,oTabTmp)
	RestArea(_aArea)
	SetKEY( VK_F12, {|| lTeclF7 := .F., FwMsgRun(Nil,{||AN002(oCodigo, oDescri, oMarca) },Nil,"Aguarde, Executando Filtro...")} )  // Restaura novamente a tecla F12, pois o FWMarkBrowse desativou
	If !_lContinua
		Return
	Endif
	//MsgInfo("F6 - oModelSB1:Length(): "+cValToChar(oModelSB1:Length()))
	oModelALT:GoLine(1)
	For nY := 1 to oModelALT:Length()
		oModelALT:GoLine(nY)
		If !Empty(oModelALT:GetValue("XX_DATA"))
			cFilAnt 	:= oModelALT:GetValue("XX_FILIAL")
			cLetra 	  	:= Upper(oModelALT:GetValue("XX_LETRA"))
			dDataxx		:= oModelALT:GetValue("XX_DATA")
			nDesconto 	:= oModelALT:GetValue("XX_DESCONT")
			nNewPrcBrt 	:= oModelALT:GetValue("XX_PRCBRT")
			nNewPrcRep	:= oModelALT:GetValue("XX_PRCREP")
			nNewPrcVen	:= oModelALT:GetValue("XX_PRCLIQ")
			nFator		:= oModelALT:GetValue("XX_FTPRC")
			nMargem		:= oModelALT:GetValue("XX_MARGEM")
			If !Empty(cCodMestre)
				nPos := aScan(aCodMestre,{|x| x[1]+x[2] == cFilAnt + cCodMestre})
				If nPos == 0
					aadd(aCodMestre, {cFilAnt, cCodMestre})
				Endif
			Else
				nPos := 0
			Endif
			If nPos == 0
				ProcAlt("0",cFilAnt, cCodDA0, cCodxx, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cCodMestre )
				aadd(aFilCopy, {cFilAnt, dDataxx})
			Endif
		EndIf
	Next nY
	If !lProd .and. !Empty(cFilOrigem)	// Copiar para outros produtos
		nPos := aScan(aFilCopy,{|x| Alltrim(x[1]) == cFilOrigem})
		If nPos > 0
			dDataxx := aFilCopy[nPos, 2]
			For nH := 1 to oModelSB1:Length()
				oModelSB1:GoLine(nH)
				cCodCopy := oModelSB1:GetValue("B1_COD")
				If Alltrim(cCodxx) <> Alltrim(cCodCopy)
					cCodMestre := oModelSB1:GetValue("B1_XALTIMP")
					For nY:=1 to Len(aFilCopy)
						If !lAltLetra
							If lCopLetra
								cLetra 	:= AN006(cFilOrigem, cCodCopy, "DA1_XLETRA","1")
							Else
								cLetra 	:= AN006(aFilCopy[nY,1], cCodCopy, "DA1_XLETRA","1")
							Endif
						Endif
						If !lAltDesc
							If lCopDesco
								nDesconto := AN006(cFilOrigem, cCodCopy, "DA1_XDESCV","1")
							Else
								nDesconto := AN006(aFilCopy[nY,1], cCodCopy, "DA1_XDESCV","1")
							Endif
						Endif
						If lCopPrcRp
							nNewPrcRep	:= AN006(cFilOrigem, cCodCopy, "DA1_XPRCRE","1")
						Else
							nNewPrcRep	:= AN006(aFilCopy[nY,1], cCodCopy, "DA1_XPRCRE","1")
						Endif
						nNewPrcBrt 	:= AN006(aFilCopy[nY,1], cCodCopy, "DA1_XPRCBR","1")
						nFator		:= AN006(aFilCopy[nY,1], cCodCopy, "DA1_XFATOR","1")
						nMargem		:= AN006(aFilCopy[nY,1], cCodCopy, "DA1_XMARGE","1")
						nNewPrcVen	:= 0
						If !Empty(cCodMestre)
							nPos := aScan(aCodMestre,{|x| x[1]+x[2] == aFilCopy[nY,1] + cCodMestre})
							If nPos == 0
								aadd(aCodMestre, {aFilCopy[nY,1], cCodMestre})
							Endif
						Else
							nPos := 0
						Endif
						If nPos == 0
							ProcAlt("1",aFilCopy[nY,1], cCodDA0, cCodCopy, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cCodMestre, lCopLetra, lCopPrcRp, lCopDesco)
						Endif
					Next
				Endif
			Next
		EndIf
	Endif
	cFilAnt := cFilOri
	oModelALT:GoLine(1)

	AN003(oCodigo, oDescri, oMarca)

	oView:Refresh('VIEW_ALT')
	ApMsgInfo("Atualização efetuada com sucesso")
	oModelALT:ClearData(.F.,.T.)
	lCopPRep := .F.
	oView:GetViewObj("VIEW_SB1")[3]:oBrowse:oBrowse:SetFocus()
	oView:Refresh('VIEW_ALT')
	aFilOri		:= {}
	aFilCopy	:= {}
Return()
//--------------------------------------------------------------------------------------------------------------------------------
Static Function ProcAlt(cParamxx, cFilxx, cCodDA0, cCodxx, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cCodMestre, lCopLetra, lCopPrcRp, lCopDesco)

Local aArea 	:= GetArea()
Local lCriaReg 	:= .T.
Local cTabProc 	:= ""
Local lAtualiz	:= .F.
Local _aRetPrc  := {}
Local cSeqTab   := CriaVar("DA1_XTABSQ",.F.)
Default lCopLetra := .F.
Default lCopPrcRp := .F.
Default lCopDesco := .F.

DbSelectArea("DA1")
//MsgInfo('Vou pesquisar item no DA1')
DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
If DA1->(DbSeek(cFilxx+cCodDA0+cCodxx))
	While !DA1->(Eof()) .And. cFilxx+cCodDA0+cCodxx == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
		lCriaReg := .T.
		cTabProc := ""
		lAtualiz := .F.
		cSeqTab   := CriaVar("DA1_XTABSQ",.F.)
		_aRetPrc := {}
		//Verifica se ç menor que a tabela 1LER
		If Empty(cLetra)
			cLetra 	  := u_BuscTabVig( cCodxx , cCodDA0, dDataxx )[1] //Ita - 02/09/2020
			If Empty(cLetra)
				cLetra := "C"
			Endif
		EndIf
		_cMonoFas := IIF(Posicione("SB1",1,xFilial("SB1")+cCodxx,"B1_XMONO")=="S","S","N")
		_cLinhaSB1:= Posicione("SB1",1,xFilial("SB1")+cCodxx,"B1_XLINHA")
		If cParamxx == "1"
			_aRetPrc 	:= u_CalcPrcV(cLetra, _cMonoFas, cMarca,_cLinhaSB1, DA1->DA1_FILIAL, nNewPrcRep, nDesconto)
			nNewPrcBrt 	:= _aRetPrc[6]
			nNewPrcVen	:= _aRetPrc[4]
			nFator		:= _aRetPrc[3]
			nMargem		:= _aRetPrc[5]
		Endif
		If DA1->DA1_DATVIG > dDataxx
			cSeqTab := DA1->DA1_XTABSQ
			DA1->(DbSkip())
			Loop
		ElseIf DA1->DA1_DATVIG == dDataxx
			Reclock("DA1",.F.)
			DA1->DA1_XLETRA := cLetra
			DA1->DA1_XDESCV := nDesconto
			DA1->DA1_XFATOR := nFator
			DA1->DA1_XMARGE := nMargem
			DA1->DA1_PRCVEN := nNewPrcVen
			DA1->DA1_XPRCBR := nNewPrcBrt
			DA1->DA1_XPRCRE := nNewPrcRep
			DA1->(MsUnlock())
		Else
			cTabProc := DA1->DA1_XTABSQ
			ReplicDA1(cFilxx, cCodDA0, cCodxx, cTabProc, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem)
		Endif
		Exit
	End
	If !Empty(cSeqTab) .and. cSeqTab < "3"
		cSeqTab := Soma1(cSeqTab)
		GerTabNew(cParamxx, cFilxx, cCodDA0, cCodxx, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cSeqTab)
	Endif
Else
	//MsgInfo("Não foi localizado item na DA1 - Chave: ["+oModelALT:GetValue("XX_FILIAL")+cCodDA0+oModelSB1:GetValue("B1_COD")+"] VOU INCLUIR!") //Ita - 11/08/2020
	//Estrutura da DA1
	GerTabNew(cParamxx, cFilxx, cCodDA0, cCodxx, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, "1")
EndIf
If !Empty(cCodMestre)
	u_TabPrcMest(cFilxx, cCodDA0, cCodMestre, cCodxx)
Endif
RestArea(aArea)
Return
//--------------------------------------------------------------------------------------------------------------------------------------------
Static Function GerTabNew(cParamxx, cFilxx, cCodDA0, cCodxx, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem, cSeqTab)

Local aStruct   := DA1->(DbStruct())
Local aReg      := {}
Local nA        := 1
Local nB        := 1
Local cFilOri   := cFilAnt
cFilAnt := cFilxx
Default cSeqTab := "1"
For nA:=1 To Len(aStruct)
	aAdd(aReg, { aStruct[nA][1], DA1->&( aStruct[nA][1] ) } )
Next na
xnHtIt := fRetUItem(cFilxx,cCodDA0, cCodxx)
//Ita - 02/09/2020 - cLetra := If(!Empty(Upper(oModelALT:GetValue("XX_LETRA"))),Upper(oModelALT:GetValue("XX_LETRA")),"C")
//MsgInfo("Não tem tabela do Produto: "+cCodPlan+" - vou criar na Filial: "+xFilTst)
_cLinhaSB1:= Posicione("SB1",1,xFilial("SB1")+cCodxx,"B1_XLINHA")
_cMonoFas := IIF(Posicione("SB1",1,xFilial("SB1")+cCodxx,"B1_XMONO")=="S","S","N")
If Empty(cLetra)
	cLetra 	  := u_BuscTabVig( cCodxx , cCodDA0, dDataxx )[1] //Ita - 02/09/2020
	If Empty(cLetra)
		cLetra := "C"
	Endif
EndIf
_aRetPrc  := u_CalcPrcV(cLetra, _cMonoFas, cMarca,_cLinhaSB1, cFilxx, nNewPrcRep, nDesconto)
nFator		:= _aRetPrc[3]
nNewPrcVen	:= _aRetPrc[4]
nMargem		:= _aRetPrc[5]
nNewPrcBrt 	:= _aRetPrc[6]
If nNewPrcRep > 0.00
	Reclock("DA1",.T.)
	DA1->DA1_FILIAL := cFilxx
	DA1->DA1_ITEM   := xnHtIt
	DA1->DA1_CODTAB := cCodDA0
	DA1->DA1_CODPRO := cCodxx
	DA1->DA1_XLETRA := cLetra
	DA1->DA1_XDESCV := nDesconto
	//Ita - 15/09/2020 - DA1->DA1_XPRCRE := oModelALT:GetValue("XX_PRCREP")
	DA1->DA1_XPRCRE := nNewPrcRep //Ita - 24/09/2020 - nNewPrcRep//Ita - 15/09/2020
	DA1->DA1_XFATOR := nFator
	DA1->DA1_XMARGE := nMargem    //oModelALT:GetValue("XX_MARGEM")
	DA1->DA1_PRCVEN := nNewPrcVen //oModelALT:GetValue("XX_PRCLIQ")
	DA1->DA1_XPRCBR := nNewPrcBrt
	DA1->DA1_XTABSQ := cSeqTab
	DA1->DA1_XMARCA := cMarca
	DA1->DA1_DATVIG := dDataxx
	For nB:=1 To Len(aReg)
		If Alltrim(aReg[nB][1]) $ "DA1_FILIAL|DA1_ITEM|DA1_CODTAB|DA1_CODPRO|DA1_XLETRA|DA1_XDESCV|DA1_XPRCRE|DA1_XFATOR|DA1_XMARGE|DA1_PRCVEN|DA1_XPRCBR|DA1_XTABSQ|DA1_XTABSQ|DA1_XMARCA|DA1_DATVIG"
			Loop
		EndIf
		DA1->&( aReg[nB][1] ) := aReg[nB][2]
	Next nB
	DA1->(MsUnlock())
Endif
cFilAnt := cFilOri
Return
//---------------------------------------------------------------------------------------------------------------------------------------------------
User Function TabPrcMest(cFilxx, cCodDA0, cCodMestre, cCodxx)

Local aArea := GetArea()
Local cAliasQry := GetNextAlias()
Local cCodSim
Local nCampos := 1
Local bCampo := {|nCPO| Field(nCPO) }
cQuery := "SELECT B1_COD, B1_XALTIMP"		// Nessa query não pesquiso por produto, pois podem ter outros produtos com o mesmo Lote
cQuery += " FROM "+RETSQLNAME("SB1")+" WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND B1_FILIAL = '"+Substr(cFilxx,1,4)+"'"
cQuery += " AND B1_XALTIMP = '" + cCodMestre + "'"
cQuery += " AND B1_COD <> '" + cCodxx + "'"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
dbSelectArea(cAliasQry)
If !Eof()
	cCodSim := (cAliasQry)->B1_COD
	dbSelectArea("DA1")
	DbOrderNickName("DA1SEQ")
	DA1->(DbSeek(cFilxx+cCodDA0+cCodxx))
	While !Eof() .and. cFilxx+cCodDA0+cCodxx == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO)
		cSeqTab := DA1->DA1_XTABSQ
		FOR nCampos := 1 TO FCount()
			M->&(EVAL(bCampo,nCampos)) := FieldGet(nCampos)
		NEXT nCampos
		aAliasDa1 := GetArea()
		M->DA1_CODPRO := cCodSim
		xnHtIt := fRetUItem(cFilxx,cCodDA0, cCodSim)
		M->DA1_ITEM   := xnHtIt
		dbSelectArea("DA1")
		DbOrderNickName("DA1SEQ")
		If DA1->(DbSeek(cFilxx+cCodDA0+cCodSim+cSeqTab))
			RecLock("DA1",.F.)
		Else
			RecLock("DA1",.T.)
		Endif
		For nCampos := 1 TO FCount()
			FieldPut( nCampos, M->&(EVAL(bCampo,nCampos)) )
		Next
		MsUnlock()
		RestArea(aAliasDa1)
		dbSkip()
	End
Endif
dbSelectArea(cAliasQry)
DbCloseArea()
Restarea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------
Static Function ReplicDA1(cFilxx, cCodDA0, cCodxx, cTabProc, cMarca, cLetra, dDataxx, nDesconto, nNewPrcBrt, nNewPrcRep, nNewPrcVen, nFator, nMargem)

Local aArea := GetArea()
Local cItem := fRetUItem(cFilxx,cCodDA0, cCodxx)
Local aStruct := DA1->(DbStruct())
Local aReg := {}
Local nA:=1
Local nB:=1
Local cAliasDA1 := "QRYDA1"
If cTabProc == "3"
	dbSelectArea("DA1")
	DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
	dbSeek(cFilxx+cCodDA0+cCodxx+cTabProc)
	While !Eof() .and. cFilxx+cCodDA0+cCodxx+cTabProc == DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ)
		RecLock("DA1",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	End
Else
	cQuery := "SELECT DA1_FILIAL, DA1_CODPRO, DA1_DATVIG, DA1_XTABSQ, R_E_C_N_O_ RECDA1"
	cQuery += " FROM " + RetSqlName("DA1")
	cQuery += " WHERE DA1_FILIAL = '" + cFilxx + "'"
	cQuery += " AND DA1_CODTAB = '" + cCodDA0 + "'"
	cQuery += " AND DA1_CODPRO = '" + cCodxx + "'"
	cQuery += " AND  DA1_XTABSQ >= '" + cTabProc + "'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasDA1,.F.,.T.)
	dbSelectArea(cAliasDA1)
	While !Eof()
		dDataDA1 := Stod((cAliasDA1)->DA1_DATVIG)
		If (cAliasDA1)->DA1_XTABSQ == "3"
			dbSelectArea("DA1")
			dbGoto((cAliasDA1)->RECDA1)
			RecLock("DA1",.F.)
			dbDelete()
			MsUnLock()
		Else
			cSeqTab := Soma1((cAliasDA1)->DA1_XTABSQ)
			cUpt := "UPDATE " + RetSqlName("DA1") + " SET DA1_XTABSQ = '" + cSeqTab + "'"
			cUpt += " WHERE DA1_FILIAL = '" + cFilxx + "'"
			cUpt += " AND R_E_C_N_O_ = '" + Alltrim(Str((cAliasDA1)->RECDA1)) + "'"
			nErrQry := TCSqlExec( cUpt )
			If nErrQry < 0
				Final("Erro atualização da Tabela ", TCSQLError() + cUpt)
			Endif
		Endif
		dbSelectArea(cAliasDA1)
		dbSkip()
	End
	dbSelectArea(cAliasDA1)
	DbCloseArea()
End
RestArea(aArea)
For nA:=1 To Len(aStruct)
	aAdd(aReg, { aStruct[nA][1], DA1->&( aStruct[nA][1] ) } )
Next na
nB := 0
Reclock("DA1",.T.)
For nB:=1 To Len(aReg)
	If Alltrim(aReg[nB][1]) == "DA1_XTABSQ"
		DA1->DA1_XTABSQ := cTabProc
		Loop
	EndIf
	If Alltrim(aReg[nB][1]) == "DA1_XMARCA"
		DA1->DA1_XMARCA := cMarca
		Loop
	EndIf
	If Alltrim(aReg[nB][1]) == "DA1_DATVIG"
		DA1->DA1_DATVIG := dDataxx
		Loop
	EndIf
	If Alltrim(aReg[nB][1]) == "DA1_ITEM"
		DA1->DA1_ITEM := Soma1(cItem)
		Loop
	EndIf
	DA1->&( aReg[nB][1] ) := aReg[nB][2]
Next nB
DA1->(MsUnlock())
Reclock("DA1",.F.)
DA1->DA1_XLETRA := cLetra
DA1->DA1_XDESCV := nDesconto
DA1->DA1_XFATOR := nFator
DA1->DA1_XMARGE := nMargem
DA1->DA1_PRCVEN := nNewPrcVen
DA1->DA1_XPRCBR := nNewPrcBrt
DA1->DA1_XPRCRE := nNewPrcRep
DA1->(MsUnlock())
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} AN008
Altera preço liquido
@author felipe.caiado
@since 15/03/2019
@version 1.0

@type function
/*/
//-------------------------------------------------------------------
Static Function AN008(cParam)

	Local nRet as numeric
	Local nDesconto as numeric
	Local nPrcVen as numeric
	lAltPrc	:= .F.
	nRet := 0
	nDesconto := 0
	//Preço de Venda
	nPrcVen := u_CalcPrcV(Upper(Alltrim(FwFldGet("XX_LETRA"))), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), FwFldGet("XX_FILIAL"), FwFldGet("XX_PRCREP"), FwFldGet("XX_DESCONT"))
	If cParam == "1"
		nRet := nPrcVen[4]
	Else
		nRet := nPrcVen[6]
	Endif
Return(nRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN009
Replica os dados
@author felipe.caiado
@since 15/03/2019
@version 1.0

@type function
/*/
//-------------------------------------------------------------------
Static Function AN009()

	Local oModel    := FWModelActive()
	Local oView		:= FwViewActive()
	Local oModelALT := oModel:GetModel( 'ALTDETAIL' )
	Local nY		:= 0
	Local nJ		:=1
	Local nH		:=1
	Local aStruct	:= {}
	Local _oCopTab
	Local cAliasTMP  := GetNextAlias()
	Local aColumns	:= {}
	Local nRet 		:= 0
	Local bOk 		:= {||((nRet := 1, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local bCancel	:= {||((nRet := 0, oMrkBrowse:Deactivate(), oDlgAB:End()))}
	Local nCol		:= oView:GetViewObj("VIEW_ALT")[3]:obrowse:obrowse:ColPos()
	Local aViewCp	:= aclone(oView:GetViewStruct('VIEW_ALT'):Getfields())
	Local nPData	:= aScan( aViewCp, { |x| AllTrim( x[ MVC_VIEW_IDFIELD ] ) ==  AllTrim( 'XX_DATA' ) } )
	Local nLinha	:= oModelALT:GetLine() // oModelALT:nline
	Local cFilPos	:= oModelALT:GetValue("XX_FILIAL")
	Local lPergApag := .F.
	Local _lApag 	:= .T.
	Local aFilSel	:= {}
	If !Empty(cFilPos) .and. lVIEW_ALT .and. nCol == nPData
		For nY := 1 to oModelALT:Length()
			oModelALT:GoLine(nY)
			If !Empty(oModelALT:GetValue("XX_DATA"))
				If cFilPos <> oModelALT:GetValue("XX_FILIAL")
					aadd(aFilSel, oModelALT:GetValue("XX_FILIAL"))
				Endif
			Endif
		Next
		Aadd(aStruct, {"TMP_OK","C",1,0})
		Aadd(aStruct, {"TMP_FILIAL"	,"C"	,TamSx3("Z2_FILIAL")[1]		,0, "Filial"})
		aAdd(aStruct, {"TMP_NOMFIL"	,"C"	,30							,0, "Nome"			, 150, " " })
		If(_oCopTab <> NIL)
			_oCopTab:Delete()
			_oCopTab := NIL
		EndIf
		_oCopTab := FwTemporaryTable():New(cAliasTmp)
		_oCopTab:SetFields(aStruct)
		_oCopTab:AddIndex("1",{"TMP_FILIAL"})
		_oCopTab:Create()

		For nY := 1 to oModelALT:Length()
			oModelALT:GoLine(nY)
			If cFilPos <> oModelALT:GetValue("XX_FILIAL")
				RecLock(cAliasTMP,.T.)
				(cAliasTMP)->TMP_FILIAL := oModelALT:GetValue("XX_FILIAL")
				(cAliasTMP)->TMP_NOMFIL := Posicione("SM0",1,cEmpAnt+oModelALT:GetValue("XX_FILIAL"),"M0_FILIAL")
				MsUnlock()
			Endif
		Next
		dbSelectArea(cAliasTMP)
		dbGotop()
		If !Eof() .and. !Bof()
			For nH := 1 To Len(aStruct)
				If	!aStruct[nH][1] $ "TMP_OK"
					AAdd(aColumns,FWBrwColumn():New())
					aColumns[Len(aColumns)]:lAutosize:=.T.
					aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nH][1]+"}") )
					aColumns[Len(aColumns)]:SetTitle(aStruct[nH][5])
					aColumns[Len(aColumns)]:SetDecimal(aStruct[nH][4])
					If aStruct[nH][2] $ "N/D"
						aColumns[Len(aColumns)]:nAlign := 3
					Endif
				EndIf
			Next nH
			aSize := MsAdvSize(,.F.,400)
			DEFINE MSDIALOG oDlgAB TITLE "Selecione Tabela Destino" From 300,0 to 800,500 OF oMainWnd PIXEL
			oMrkBrowse:= FWMarkBrowse():New()
			oMrkBrowse:SetFieldMark("TMP_OK")
			oMrkBrowse:SetOwner(oDlgAB)
			oMrkBrowse:SetAlias(cAliasTMP)
			oMrkBrowse:AddButton("Confirmar", bOk,,,, .F., 7 ) //Confirmar
			oMrkBrowse:AddButton("Cancelar" ,bCancel,,,, .F., 7 ) //Parçmetros
			oMrkBrowse:bAllMark  := {||COPMark(oMrkBrowse,cAliasTMP)}
			oMrkBrowse:SetDescription("Marque as Filiais")
			oMrkBrowse:SetColumns(aColumns)
			oMrkBrowse:SetMenuDef("")
			oMrkBrowse:Activate()
			ACTIVATE MSDIALOg oDlgAB CENTERED
			If nRet == 1
				aFilOri := {}
				aFilCopy := {}
				aadd(aFilOri,{nLinha, cFilPos})
				dbSelectArea(cAliasTMP)
				dbGotop()
				While !Eof()
					If (cAliasTMP)->TMP_OK == oMrkBrowse:Mark()
						aadd(aFilCopy, TMP_FILIAL)
					Endif
					dbSkip()
				End
			Endif
		Endif
	Endif
	If Len(aFilSel) > 0
		For nJ:=1 to Len(aFilSel)
			nPos := Ascan(aFilCopy, aFilSel[nJ])
			If nPos == 0
				lPergApag := .T.
				Exit
			Endif
		Next
	Endif
	If lPergApag
		If ApMsgYesNo("Mantem as filiais não selecionadas ?")
			_lApag := .F.
		Endif
	Endif
	If nRet == 1 .or. (Len(aFilCopy) > 0)
		oModelALT:GoLine(aFilOri[1,1])
		dData 		:= oModelALT:GetValue("XX_DATA")
		cLetra 		:= oModelALT:GetValue("XX_LETRA")
		nDescon 	:= oModelALT:GetValue("XX_DESCONT")
		nReposic 	:= oModelALT:GetValue("XX_PRCREP")
		nPData 		:= aScan( aViewCp, { |x| AllTrim( x[ MVC_VIEW_IDFIELD ] ) ==  AllTrim( 'XX_DATA' ) } )
		nPDescon 	:= aScan( aViewCp, { |x| AllTrim( x[ MVC_VIEW_IDFIELD ] ) ==  AllTrim( 'XX_DESCONT' ) } )
		nPLetra 	:= aScan( aViewCp, { |x| AllTrim( x[ MVC_VIEW_IDFIELD ] ) ==  AllTrim( 'XX_LETRA' ) } )
		nPRepos 	:= aScan( aViewCp, { |x| AllTrim( x[ MVC_VIEW_IDFIELD ] ) ==  AllTrim( 'XX_PRCREP' ) } )
		nCol		:= oView:GetViewObj("VIEW_ALT")[3]:obrowse:obrowse:ColPos()						//Coluna no Momento do click  do F4, Qdo no Grid
		oModelALT:SetNoInsertLine(.F.)
		oModelALT:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
		If Len(aFilCopy) > 0 .and. Len(aFilOri) > 0
			For nY := 1 to oModelALT:Length()
				oModelALT:GoLine(nY)
				cFil 		:= oModelALT:GetValue("XX_FILIAL")
				nPos 		:= Ascan(aFilCopy, cFil)
				If nPos > 0
					If nCol == nPData//Data
						oModelALT:SetValue("XX_DATA", dData)
					ElseIf nCol == nPLetra//Letra
						oModelALT:SetValue("XX_LETRA", cLetra)
					ElseIf nCol == nPDescon//Desconto
						oModelALT:SetValue("XX_DESCONT", nDescon)
					ElseIf nCol == nPRepos//Preço Reposição
						oModelALT:SetValue("XX_PRCREP", nReposic)
						lCopPRep := .T.
					EndIf
				Else
				/* Ita - 18/08/2020 - Comentado para evitar que os dados do registro origem sejam limpos. Solicitação: Eduardo Guerra
					oModelALT:SetValue("XX_DATA", Ctod("  /  /  "))
					oModelALT:SetValue("XX_LETRA", " ")
					oModelALT:SetValue("XX_CSTAQU", 0)
					oModelALT:SetValue("XX_MARGEM", 0)
					oModelALT:SetValue("XX_PRCBRT", 0)
					oModelALT:SetValue("XX_DESCONT", 0)
					oModelALT:SetValue("XX_PRCREP", 0)
					oModelALT:SetValue("XX_PRCLIQ", 0)
					*/
				EndIf
			Next nY
		Else

			For nY := 1 to oModelALT:Length()
				oModelALT:GoLine(nY)
				If nY <> nLinha .and. _lApag
					oModelALT:SetValue("XX_DATA", Ctod("  /  /  "))
					oModelALT:SetValue("XX_LETRA", " ")
					oModelALT:SetValue("XX_CSTAQU", 0)
					oModelALT:SetValue("XX_MARGEM", 0)
					oModelALT:SetValue("XX_PRCBRT", 0)
					oModelALT:SetValue("XX_DESCONT", 0)
					oModelALT:SetValue("XX_PRCREP", 0)
					oModelALT:SetValue("XX_PRCLIQ", 0)
				EndIf
			Next nY
		Endif
		oModelALT:SetNoInsertLine(.T.)
		oModelALT:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
		oModelALT:GetStruct():SetProperty('XX_DATA',MODEL_FIELD_WHEN,{||.T.})
		oModelALT:GetStruct():SetProperty('XX_PRCREP',MODEL_FIELD_WHEN,{||.T.})
		oModelALT:GetStruct():SetProperty('XX_LETRA',MODEL_FIELD_WHEN,{||.T.})
		oModelALT:GetStruct():SetProperty('XX_PRCBRT',MODEL_FIELD_WHEN,{||.T.})
		oModelALT:GetStruct():SetProperty('XX_DESCONT',MODEL_FIELD_WHEN,{||.T.})
		oModelALT:GetStruct():SetProperty('XX_PRCLIQ',MODEL_FIELD_WHEN,{||.T.})
	Endif
	oModelALT:GoLine(1)
	oView:EnableTitleView('VIEW_ALT','Atualização1')
	oView:Refresh('VIEW_ALT')
	oView:GetViewObj("VIEW_ALT")[3]:oBrowse:oBrowse:SetFocus()
	SetKEY( VK_F12, {|| FwMsgRun(Nil,{||AN002(oCodigo, oDescri, oMarca) },Nil,"Aguarde, Executando Filtro...")} )  // Restaura novamente a tecla F12, pois o FWMarkBrowse desativou

Return()

//-------------------------------------------------------------------
// Valida a Letra digitada

Static Function VldExLt(cParam, cParam2)

	Local _lRet		:= .T.
	Local _aArea	:= GetArea()
	Local oModel    := FWModelActive()
	Local oModelALT := oModel:GetModel( 'ALTDETAIL' )
	Local cLetra
	Local cFilOri
	Default cParam  := "1"
	If cParam <> "1"
		cLetra := cParam
		cFilOri := cParam2
	Else
		cLetra	:= Upper(oModelALT:GetValue("XX_LETRA"))
		cFilOri	:= oModelALT:GetValue("XX_FILIAL")
	Endif
	dbSelectArea("ZZI")
	dbSetOrder(1)
	If !Empty(cLetra) .and. !dbSeek(cFilOri+cLetra)
		Help( ,, 'HELP',, 'Letra não cadastrada', 1, 0)
		_lRet := .F.
	Endif
	RestArea(_aArea)
Return(_lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} AN010
Copia de Tabela de Preço entra filiais
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN010()

	Local oModel     	:= FWModelActive()
	Local oModelSB1  	:= oModel:GetModel( 'SB1DETAIL' )
	Local oModelFIL  	:= oModel:GetModel( 'FILMASTER' )
	Local nT			:= 0
	Local nH			:= 0
	Local nA			:= 0
	Local nB			:= 0
	Local cAliasDA1		:= GetNextAlias()
	Local cAliasITE		:= GetNextAlias()
	Local cCodDA0		:= Alltrim(SuperGetMv("AN_TABPRC",.F.,"100"))
	Local cMsg			:= ""
	Local lProd			:= .F.
	Local lAtuLetra		:= .F.
	Local lAtuDesc		:= .F.
	Local lAtuPRep		:= .F.
	Local aRet as array
	Local aPerg as array
	aRet 	:= {}
	aPerg	:= {}
	aFilOri	:= {}
	aFilCopy:= {}
	aAdd( aPerg ,{1,Alltrim("Filial Origem"),Space(06),"@!",".T.","SM0","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Filial Destino"),Space(06),"@!",".T.","SM0","",30,.F.})
	aAdd( aPerg ,{1,Alltrim("Tabela"),Space(1),"@!",".T.","","",10,.F.})
	aAdd( aPerg ,{2,Alltrim("Copia preço de reposição"),"S",{"S=Sim","N=Não"},40,"",.F.})
/*
	aAdd( aPerg ,{2,Alltrim("Manter letra da tabela de destino"),"S",{"S=Sim","N=Não"},40,"",.F.})
	aAdd( aPerg ,{2,Alltrim("Manter desconto da tabela de destino"),"S",{"S=Sim","N=Não"},40,"",.F.})
*/
	If !ParamBox(aPerg ,"Cçpia de Tabela",@aRet)
		Return()
	EndIf

	//Verifica se estç vazio os parçmetros
	If Empty(MV_PAR01) .Or. Empty(MV_PAR02) .Or. Empty(MV_PAR03)
		ApMsgInfo("Favor preencher todos os parçmetros")
		Return()
	EndIf

	lAtuLetra		:= Alltrim(MV_PAR05) == "N"
	lAtuDesc		:= Alltrim(MV_PAR06) == "N"
	lAtuPRep		:= Alltrim(MV_PAR04) == "S"

	cMsg := "Confirma a Cçpia da Filial " + MV_PAR01 + " para a Filial " + MV_PAR02 + "?" + CRLF

	cMsg += CRLF
	cMsg += "---------------------------------" + CRLF
	cMsg += "FILTRO UTILIZADO:" + CRLF
	cMsg += "---------------------------------" + CRLF
	cMsg += CRLF
	cMsg += "MARCA: " + oModelFIL:GetValue("XX_MARCA") + CRLF
	cMsg += "PRODUTO: " + oModelFIL:GetValue("XX_PRODUT") + CRLF
	cMsg += "LINHA: " + oModelFIL:GetValue("XX_LINHA") + CRLF
	cMsg += "CURVA: " + oModelFIL:GetValue("XX_CURVA")

	If !ApMsgNoYes(cMsg) //Se for não a resposta pergunta se quer fazer por produto
		lProd := ApMsgNoYes("Deseja fazer a cçpia do produto " + Alltrim(cCodigo) + "-" + Alltrim(cDescri))
		If !lProd
			Return()
		EndIf
	EndIf
	For nH := 1 to oModelSB1:Length()
		oModelSB1:GoLine(nH)
		If lProd
			If Alltrim(cCodigo) <> Alltrim(oModelSB1:GetValue("B1_COD"))
				Loop
			EndIf
		EndIf
		lCriaReg := .T.
		cTabProc 	:= ""
		aTabSeq		:= {}
		aTabDel		:= {}
		lAtualiz	:= .F.
		dData 		:= AN006(MV_PAR01, oModelSB1:GetValue("B1_COD"), "DA1_DATVIG", MV_PAR03)
		cLetra 		:= AN006(MV_PAR01, oModelSB1:GetValue("B1_COD"), "DA1_XLETRA", MV_PAR03)
		nDescont 	:= AN006(MV_PAR01, oModelSB1:GetValue("B1_COD"), "DA1_XDESCV", MV_PAR03)
		nPreRep 	:= AN006(MV_PAR01, oModelSB1:GetValue("B1_COD"), "DA1_XPRCRE", MV_PAR03)
		DbSelectArea("DA1")
		DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
		If DA1->(DbSeek(Alltrim(MV_PAR02)+cCodDA0+oModelSB1:GetValue("B1_COD")))
			While !DA1->(Eof()) .And. Alltrim(MV_PAR02)+cCodDA0+oModelSB1:GetValue("B1_COD") == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
				//Verifica se ç menor que a tabela 1
				If DA1->DA1_DATVIG > dData
					DA1->(DbSkip())
					Loop
				ElseIf DA1->DA1_DATVIG == dData
					lCriaReg := .F.
					Reclock("DA1",.F.)
					If lAtuLetra
						DA1->DA1_XLETRA := Upper(cLetra)
						DA1->DA1_XFATOR := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE)[3]
						DA1->DA1_XMARGE := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE)[1]
					EndIf
					If lAtuDesc
						DA1->DA1_XDESCV := nDescont
					EndIf
					If lAtuPRep
						DA1->DA1_XPRCRE := nPreRep
					EndIf
					nPrcVen := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE, DA1_XDESCV)
					DA1->DA1_PRCVEN := nPrcVen[4]
					DA1->DA1_XPRCBR := nPrcVen[6]
					DA1->(MsUnlock())
					DA1->(DbSkip())
					Loop
				Else
					If lCriaReg
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
					EndIf
				EndIf
				DA1->(DbSkip())
			EndDo
			If lCriaReg .And. lAtualiz
				//Atualiza as proximas sequencias
				For nT:=1 To Len(aTabSeq)
					DA1->(DbGoTo(aTabSeq[nT][1]))
					Reclock("DA1",.F.)
					DA1->DA1_XTABSQ := aTabSeq[nT][2]
					DA1->(MsUnlock())
				Next nT
				cTabProx := Soma1(cTabProc)
				//Localiza a vigencia da tabela 1
				BeginSQL alias cAliasDA1
					SELECT
						R_E_C_N_O_ RECNUM
					FROM
						%table:DA1% DA1
					WHERE
						DA1_FILIAL = %exp:MV_PAR02%
						AND DA1_CODPRO = %exp:oModelSB1:GetValue("B1_COD")%
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
							DA1_FILIAL = %exp:MV_PAR02%
							AND DA1_CODTAB = %exp:cCodDA0%
							AND DA1_CODPRO = %exp:oModelSB1:GetValue("B1_COD")%
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
					Next na
					nB := 0
					Reclock("DA1",.T.)
					For nB:=1 To Len(aReg)
						If Alltrim(aReg[nB][1]) == "DA1_XTABSQ"
							DA1->DA1_XTABSQ := cTabProc
							Loop
						EndIf
						If Alltrim(aReg[nB][1]) == "DA1_XMARCA"
							DA1->DA1_XMARCA := oModelFIL:GetValue("XX_MARCA")
							Loop
						EndIf
						If Alltrim(aReg[nB][1]) == "DA1_DATVIG"
							DA1->DA1_DATVIG := dData
							Loop
						EndIf
						If Alltrim(aReg[nB][1]) == "DA1_ITEM"
							DA1->DA1_ITEM := Soma1(cItem)
							Loop
						EndIf
						DA1->&( aReg[nB][1] ) := aReg[nB][2]
					Next nB
					DA1->(MsUnlock())

					Reclock("DA1",.F.)
					If lAtuLetra
						DA1->DA1_XLETRA := Upper(cLetra)
						DA1->DA1_XFATOR := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE)[3]
						DA1->DA1_XMARGE := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE)[1]
					EndIf

					If lAtuDesc
						DA1->DA1_XDESCV := nDescont
					EndIf

					If lAtuPRep
						DA1->DA1_XPRCRE := nPreRep
					EndIf
					nPrcVen := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE, DA1->DA1_XDESCV)
					DA1->DA1_PRCVEN := nPrcVen[4]
					DA1->DA1_XPRCBR := nPrcVen[6]
					DA1->(MsUnlock())
					//Deleta Os registros
					nT := 0
					For nT:=1 To Len(aTabDel)
						DA1->(DbGoTo(aTabDel[nT]))
						Reclock("DA1",.F.)
						DA1->(DbDelete())
						DA1->(MsUnlock())
					Next nT
					(cAliasDA1)->(DbSkip())
				EndDo
				(cAliasDA1)->(DbCloseArea())
			EndIf
		EndIf
	Next nH
	ApMsgInfo("Cçpia efetuada com sucesso")
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AN011
Atualização de Tabela de Preço
@author felipe.caiado
@since 13/03/2019
@version undefined
@type function
/*/
//-------------------------------------------------------------------
Static Function AN011()

	Local oModel     	:= FWModelActive()
	Local oModelSB1  	:= oModel:GetModel( 'SB1DETAIL' )
	Local oModelFIL  	:= oModel:GetModel( 'FILMASTER' )
	Local nT			:= 0
	Local nH			:= 0
	Local nA			:= 0
	Local nB			:= 0
	Local cAliasDA1		:= GetNextAlias()
	Local cAliasITE		:= GetNextAlias()
	Local cCodDA0		:= Alltrim(SuperGetMv("AN_TABPRC",.F.,"100"))
	Local cMsg			:= ""
	Local lProd			:= .F.
	Local aRet as array
	Local aPerg as array
	Local _dData, _cTabCopy, _cFil
	aFilOri	:= {}
	aFilCopy:= {}
	aRet 	:= {}
	aPerg	:= {}
	aAdd( aPerg ,{1,Alltrim("Data"),CtoD("  /  /  "),"",".T.","","",50,.F.})
	aAdd( aPerg ,{1,Alltrim("Tabela"),Space(1),"@!",".T.","","",10,.F.})
	aAdd( aPerg ,{1,Alltrim("Filial"),Space(06),"@!",".T.","SM0","",30,.F.})
	If !ParamBox(aPerg ,"Cçpia de Tabela",@aRet)
		Return()
	EndIf
//Verifica se estç vazio os parçmetros
	If Empty(MV_PAR01) .Or. Empty(MV_PAR02) .Or. Empty(MV_PAR03)
		ApMsgInfo("Favor preencher todos os parçmetros")
		Return()
	EndIf
	_dData 		:= mv_par01
	_cTabCopy 	:= mv_par02
	_cFil		:= mv_par03
	cMsg := "Confirma a Atualização da tabela de preço?" + CRLF
	cMsg += CRLF
	cMsg += "---------------------------------" + CRLF
	cMsg += "FILTRO UTILIZADO:" + CRLF
	cMsg += "---------------------------------" + CRLF
	cMsg += CRLF
	cMsg += "MARCA: " + oModelFIL:GetValue("XX_MARCA") + CRLF
	cMsg += "PRODUTO: " + oModelFIL:GetValue("XX_PRODUT") + CRLF
	cMsg += "LINHA: " + oModelFIL:GetValue("XX_LINHA") + CRLF
	cMsg += "CURVA: " + oModelFIL:GetValue("XX_CURVA")
	If !ApMsgNoYes(cMsg) //Se for não a resposta pergunta se quer fazer por produto
		lProd := MsgYesNo("Deseja fazer a cçpia do produto " + Alltrim(cCodigo) + "-" + Alltrim(cDescri))
		If !lProd
			Return()
		EndIf
	EndIf
	For nH := 1 to oModelSB1:Length()
		oModelSB1:GoLine(nH)
		If lProd
			If Alltrim(cCodigo) <> Alltrim(oModelSB1:GetValue("B1_COD"))
				Loop
			EndIf
		EndIf
		lCriaReg := .T.
		cTabProc 	:= ""
		aTabSeq		:= {}
		aTabDel		:= {}
		lAtualiz	:= .F.
		DbSelectArea("DA1")
		DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
		If DA1->(DbSeek(Alltrim(MV_PAR03)+cCodDA0+oModelSB1:GetValue("B1_COD")+_cTabCopy))
			cLetra  := DA1->DA1_XLETRA
			nPrcRep := DA1->DA1_XPRCRE
			nDescVen:= DA1->DA1_XDESCV
			aPreco  := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+oModelSB1:GetValue("B1_COD"), "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+oModelSB1:GetValue("B1_COD"), "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+oModelSB1:GetValue("B1_COD"), "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE, nDescVen)
			nFator  := aPreco[3]
			nMargem := aPreco[1]
			DbSelectArea("DA1")
			DA1->(DbOrderNickName("DA1SEQ"))//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_XTABSQ
			If DA1->(DbSeek(Alltrim(MV_PAR03)+cCodDA0+oModelSB1:GetValue("B1_COD")))
				While !DA1->(Eof()) .And. Alltrim(MV_PAR03)+cCodDA0+oModelSB1:GetValue("B1_COD") == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
					//Verifica se ç menor que a tabela 1
					If DA1->DA1_DATVIG > MV_PAR01
						DA1->(DbSkip())
						Loop
					ElseIf DA1->DA1_DATVIG == MV_PAR01
						lCriaReg := .F.
						Reclock("DA1",.F.)
						DA1->DA1_XFATOR := nFator
						DA1->DA1_XMARGE := nMargem
						DA1->DA1_PRCVEN := aPreco[4]
						DA1->DA1_XPRCBR := aPreco[6]
						DA1->DA1_XDESCV := nDescVen
						DA1->DA1_XLETRA := cLetra
						DA1->(MsUnlock())
						DA1->(DbSkip())
						Loop
					Else
						If lCriaReg
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
						EndIf
					EndIf
					DA1->(DbSkip())
				EndDo
				If lCriaReg .And. lAtualiz
					//Atualiza as proximas sequencias
					For nT:=1 To Len(aTabSeq)
						DA1->(DbGoTo(aTabSeq[nT][1]))
						Reclock("DA1",.F.)
						DA1->DA1_XTABSQ := aTabSeq[nT][2]
						DA1->(MsUnlock())
					Next nT
					cTabProx := Soma1(cTabProc)
					//Localiza a vigencia da tabela 1
					BeginSQL alias cAliasDA1
						SELECT
							R_E_C_N_O_ RECNUM
						FROM
							%table:DA1% DA1
						WHERE
							DA1_FILIAL = %exp:MV_PAR03%
							AND DA1_CODPRO = %exp:oModelSB1:GetValue("B1_COD")%
							AND DA1_CODTAB = %exp:cCodDA0%
							AND DA1_XTABSQ = %exp:cTabProx%
							AND DA1.%notDel%
					EndSql
					//Estrutura da DA1
					aStruct := DA1->(DbStruct())
					aReg := {}
					nA := 0
					//Localiza o ultimo item da tabela
					BeginSQL alias cAliasITE
							SELECT
								MAX(DA1_ITEM) DA1_ITEM
							FROM
								%table:DA1% DA1
							WHERE
								DA1_FILIAL = %exp:MV_PAR03%
								AND DA1_CODTAB = %exp:cCodDA0%
								AND DA1_CODPRO = %exp:oModelSB1:GetValue("B1_COD")%
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
						Next na
						nB := 0
						Reclock("DA1",.T.)
						For nB:=1 To Len(aReg)
							If Alltrim(aReg[nB][1]) == "DA1_XTABSQ"
								DA1->DA1_XTABSQ := cTabProc
								Loop
							EndIf
							If Alltrim(aReg[nB][1]) == "DA1_XMARCA"
								DA1->DA1_XMARCA := oModelFIL:GetValue("XX_MARCA")
								Loop
							EndIf
							If Alltrim(aReg[nB][1]) == "DA1_DATVIG"
								DA1->DA1_DATVIG := MV_PAR01
								Loop
							EndIf
							If Alltrim(aReg[nB][1]) == "DA1_ITEM"
								DA1->DA1_ITEM := Soma1(cItem)
								Loop
							EndIf
							DA1->&( aReg[nB][1] ) := aReg[nB][2]
						Next nB
						DA1->(MsUnlock())
						Reclock("DA1",.F.)
						DA1->DA1_XFATOR := nFator
						DA1->DA1_XMARGE := nMargem
						nPrcVen := u_CalcPrcV(Upper(Alltrim(DA1->DA1_XLETRA)), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMONO"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XMARCA"), Posicione("SB1",1,xFilial("SB1")+cCodigo, "B1_XLINHA"), DA1->DA1_FILIAL, DA1->DA1_XPRCRE, DA1->DA1_XDESCV)
						DA1->DA1_PRCVEN := nPrcVen[4]
						DA1->DA1_XPRCBR := nPrcVen[6]
						DA1->(MsUnlock())
						//Deleta Os registros
						nT := 0
						For nT:=1 To Len(aTabDel)
							DA1->(DbGoTo(aTabDel[nT]))
							Reclock("DA1",.F.)
							DA1->(DbDelete())
							DA1->(MsUnlock())
						Next nT
						(cAliasDA1)->(DbSkip())
					EndDo
					(cAliasDA1)->(DbCloseArea())
				EndIf
			EndIf
		Endif
	Next nH
	ApMsgInfo("Recalculo efetuada com sucesso")
Return()

//
//---------------------------------------------------------------------------------------------------------
Static Function AN012(cLetra, cFil)
//lAltLetra / lAltDesc
	Local cVar
	Local nOpca	:= 0
	If lAltLetra
		cVar	:= cLetra
		DEFINE MSDIALOG oDlgVar FROM  10,1 TO 200,250 TITLE "Informar Letra" PIXEL
		@ 007,005 SAY "Letra" OF oDlgVar PIXEL
		@ 006,030 GET oVar VAR cVar Picture "@!" Valid VldExLt(cVar, cFil) SIZE 15, 08 OF oDlgVar PIXEL
		@ 031,005 SAY "Filial" OF oDlgVar PIXEL
		@ 030,030 GET oFil VAR cFil When .F. SIZE 15, 08 OF oDlgVar PIXEL
		DEFINE SBUTTON FROM 55,010 TYPE 1 ENABLE OF oDlgVar ACTION (nOpca := 1,oDlgVar:End())
		DEFINE SBUTTON FROM 55,060 TYPE 2 ENABLE OF oDlgVar ACTION (oDlgVar:End(),nOpca := 0)
		oVar:SetFocus()
		ACTIVATE MSDIALOG oDlgVar CENTERED
		If nOpca == 1
			cLetra := cVar
		Endif
	Endif
Return(cLetra)
//
//---------------------------------------------------------------------------------------------------------
Static Function AN013(nDescOri, cFil)
//lAltLetra / lAltDesc
	Local nDesconto		:= nDescOri
	Local nOpca			:= 0
	If lAltDesc
		DEFINE MSDIALOG oDlgVar FROM  10,1 TO 200,250 TITLE "Informar Desconto" PIXEL
		@ 007,005 SAY "Desconto" OF oDlgVar PIXEL
		@ 006,030 GET oDesc VAR nDesconto Picture "@E 999.99" SIZE 30, 15 OF oDlgVar PIXEL
		@ 031,005 SAY "Filial" OF oDlgVar PIXEL
		@ 030,030 GET oFil VAR cFil When .F. SIZE 15, 08 OF oDlgVar PIXEL
		DEFINE SBUTTON FROM 55,010 TYPE 1 ENABLE OF oDlgVar ACTION (nOpca := 1,oDlgVar:End())
		DEFINE SBUTTON FROM 55,060 TYPE 2 ENABLE OF oDlgVar ACTION (oDlgVar:End(),nOpca := 0)
		oDesc:SetFocus()
		ACTIVATE MSDIALOG oDlgVar CENTERED
		If nOpca == 1
			nDescOri := nDesconto
		Endif
	Endif
Return(nDescOri)
//-------------------------------------------------------------------------------------
//
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
//---------------------------------------------------------------------------------------
//
Static Function MenuDef()
	aRotina := {}
	//Adicionando opççes
	ADD OPTION aRotina TITLE 'Cancelar' 					ACTION "u_CONFSEL('C')"	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Somente o produto'    		ACTION "u_CONFSEL('S')"	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Todos os produtos da tabela'  ACTION "u_CONFSEL('T')"	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Todos prod Letra/Desc p/prd'  ACTION "u_CONFSEL('P')"	OPERATION 5 ACCESS 0
Return aRotina

//---------------------------------------------------------------------------------------
//
User Function CONFSEL(cParam)

	If cParam == "C"
		_lContinua := .F.
	Else
		_lContinua := .T.
		If cParam == "S"
			lProd := .T.
		Else
			If !ApMsgYesNo("Será realizada a alteração de TODOS os produtos da tabela, considerando a Filial " + TMP_FILIAL + " de Origem, Confirma ?")
				_lContinua := .F.
			Endif
			lProd := .F.
		Endif
	Endif
	oDlgAB:End()
Return

/////////////////////////
/// Ita - 11/08/2020
///     - fRetUItem
///     - Função p/ Retornar último item da tabela
///////////////////////////////////////////////////
Static Function fRetUItem(xPFil,xPTb, xCodProd)
	Local aArea := GetArea()
	Local cAliasPIT	:= GetNextAlias()
	Local cRtItem   := StrZero(1, TAMSX3("DA1_ITEM")[1])
	BeginSQL alias cAliasPIT
		SELECT
			MAX(DA1_ITEM) DA1_ITEM
		FROM
			%table:DA1% DA1
		WHERE
			DA1_FILIAL = %exp:xPFil%
			AND DA1_CODTAB = %exp:xPTb%
			AND DA1_CODPRO = %exp:xCodProd%
			AND DA1.%notDel%
	EndSql
	xItem := (cAliasPIT)->DA1_ITEM
	(cAliasPIT)->(DbCloseArea())
	cRtItem := Soma1(xItem)
	RestArea(aArea)
Return(cRtItem)
