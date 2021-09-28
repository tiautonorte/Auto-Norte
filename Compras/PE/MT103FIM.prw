#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"

User Function MT103FIM()
	Local nOpcao 	:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
	Local cQuery 	:= ""
	Local nRecTit   := 0

	//Rotta
	Local _aArea 	:= GetArea()
	Local aAreaD12  := D12->(GetArea())
	Local _nRot	 	:= ParamIxb[1]
	Local _nOpc	 	:= ParamIxb[2]
	Local _cChave 	:= SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

	//Se for inclusão e confirmar
	If (nOpcao == 3 .OR. nOpcao == 4) .and. nConfirma == 1
		AtuPisCof()
		//Garantia cliente
		U_RemGarCli()

		//Cartão Corporativo
		If !Empty(SF1->F1_XCARDCO)
			//Baixa titulo original da NF - FINA080
			Begin Transaction
				FWMsgRun(, {|| BaixaTit() }, "Aguarde", "Baixando Título original" )
			End Transaction

			//Inclui novo titulo para a operadora do cartão - FINA050
			Begin Transaction
				FWMsgRun(, {|| IncTit(@nRecTit) }, "Aguarde", "Incluindo Título do Cartão" )
			End Transaction

			If nRecTit > 0
				RecLock("SF1",.F.)
				Replace F1_XRECTIT with nRecTit
				SF1->(MsUnlock())
			EndIf
		EndIf

		//Italo Maciel 20/02/19
		//Baixa pedido de compra amarrado na ZZS
		cQuery := " SELECT ZZS_PEDIDO,ZZS_FORPED,ZZS_LOJAPC,ZZS_ITEPED,ZZS_QATE FROM "+ RETSQLNAME("ZZS")
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
		cQuery += " AND ZZS_DOC    = '"+ SF1->F1_DOC +"' "
		cQuery += " AND ZZS_SERIE  = '"+ SF1->F1_SERIE +"' "
		cQuery += " AND ZZS_FORNEC = '"+ SF1->F1_FORNECE +"' "
		cQuery += " AND ZZS_LOJANF = '"+ SF1->F1_LOJA +"' "

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY")

		While !QRY->(Eof())
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial("SC7") + QRY->ZZS_PEDIDO + QRY->ZZS_ITEPED))
				Reclock("SC7",.F.)
				Replace C7_QTDACLA 	with SC7->C7_QTDACLA - QRY->ZZS_QATE
				Replace C7_QUJE 	with SC7->C7_QUJE + QRY->ZZS_QATE
				SC7->(MsUnlock())
			EndIf

			QRY->(dbSkip())
		EndDo

		QRY->(dbCloseArea())

	EndIf

	//Rotta
	If _nOpc == 1
		If _nRot >= 3 .and. _nRot <= 4
			If Atu_Conf(_cChave,_nRot)						// Atualiza conferencia cega
				Atu_SB2(_cChave,"1")					// Atualiza SB2
			EndIf
		ElseIf _nRot == 5		// Estornar Classificacao
			If Atu_Conf(_cChave,_nRot)
				Atu_SB2(_cChave,"2")					// Atualiza SB2
			EndIf
		Endif
	Endif

	RestArea(aAreaD12)
	RestArea(_aArea)
Return


/*
Baixa titulo original da NF - FINA080
*/
Static Function BaixaTit()
	Local cParc	:= Space(TamSX3("E2_PARCELA")[1])
	Local nOpc	:= 3 // 3=BAIXA | 5=CANCELAMENTO
	Local aTitBx:= {}

	Private lMsErroAuto := .F.

	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	If SE2->(dbSeek(SF1->F1_FILIAL + SF1->F1_SERIE + SF1->F1_DOC + cParc + "NF " + SF1->F1_FORNECE + SF1->F1_LOJA))

		Aadd(aTitBx, {"E2_PREFIXO",	SE2->E2_PREFIXO,NIL})
		Aadd(aTitBx, {"E2_NUM",		SE2->E2_NUM,	NIL})
		Aadd(aTitBx, {"E2_PARCELA",	SE2->E2_PARCELA,NIL})
		Aadd(aTitBx, {"E2_TIPO",	SE2->E2_TIPO,	NIL})
		Aadd(aTitBx, {"E2_FORNECE",	SE2->E2_FORNECE,NIL})
		Aadd(aTitBx, {"E2_LOJA",	SE2->E2_LOJA,	NIL})
		Aadd(aTitBx, {"AUTMOTBX",	SuperGetMv("MV_XMOTCCC", .T., "CCC"),NIL})
		Aadd(aTitBx, {"AUTDTBAIXA",	dDataBase,		NIL})
		Aadd(aTitBx, {"AUTHIST",	"Bx. Auto. Cartão Corporativo",NIL})

		MsExecAuto({|x, y| FINA080(x, y)}, aTitBx, nOpc)

		If lMsErroAuto
			MostraErro()
		EndIf

	EndIf

Return

/*
Inclui novo titulo para a operadora do cartão - FINA050
*/
Static Function IncTit(nRecTit)
	Local aArray 	:= {}
	Local dVenc 	:= SF1->F1_XVENCAR
	Local dVencRea 	:= DataValida(SF1->F1_XVENCAR)
	Local cHist 	:= SF1->F1_XJUSTCC
	Local cNum

	Private lMsErroAuto := .F.

	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	If ZZ6->(dbSeek(SF1->F1_XCARDCO))

		cNum := fUltTit(ZZ6->ZZ6_FORNEC,ZZ6->ZZ6_LOJA)

		aArray := {;
			{ "E2_PREFIXO"  , SE2->E2_PREFIXO	, NIL },;
			{ "E2_NUM"		, cNum				, NIL },;
			{ "E2_TIPO"     , SuperGetMv("MV_XTIPCCC", .T., "CCC")/*SE2->E2_TIPO*/		, NIL },;
			{ "E2_NATUREZ"  , SuperGetMv("MV_XNATCCC", .T., "2901090")/*SE2->E2_NATUREZ*/	, NIL },;
			{ "E2_FORNECE"  , ZZ6->ZZ6_FORNEC	, NIL },;
			{ "E2_LOJA"  	, ZZ6->ZZ6_LOJA		, NIL },;
			{ "E2_EMISSAO"  , SF1->F1_EMISSAO	, NIL },;
			{ "E2_VENCTO"   , dVenc				, NIL },;
			{ "E2_VENCREA"  , dVencRea			, NIL },;
			{ "E2_VALOR"    , SE2->E2_VALOR		, NIL },;
			{ "E2_HIST"     , cHist				, NIL },;
			{ "E2_XRECNF"   , SF1->(Recno())	, NIL };
			}

		MsExecAuto( { |x,y,z| FINA050(x,y,z)},aArray,,3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		If lMsErroAuto
			MostraErro()
		Else
			nRecTit := SE2->(Recno())
		Endif

	EndIf

Return

Static Function fUltTit(cForn,cLoja)
	Local cNum 		:= '000000001'
	Local cQuery 	:= ' '

	cQuery := " SELECT MAX(E2_NUM) ULTIMO FROM " + RETSQLNAME("SE2")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND E2_FORNECE = '"+ cForn +"' "
	cQuery += " AND E2_LOJA = '"+ cLoja +"' "
	cQuery += " AND LENGTH(RTRIM(E2_NUM)) = 9 "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSE2",.T.,.T.)

	If !QSE2->(EOF())
		cNum := Soma1(QSE2->ULTIMO)
	EndIf

	QSE2->(dbCloseArea())
Return cNum

//Rotta
Static Function Atu_SB2(_cChave, _cParam)

	Local _aArea 	:= GetArea()
	Local _aAreaD1 	:= SD1->(GetArea())
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+_cChave)
	While !Eof() .and. xFilial("SD1")+_cChave == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		_cCod   := SD1->D1_COD
		_cLocal := SD1->D1_LOCAL
		_nQuant := SD1->D1_QUANT
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial()+_cCod+_cLocal)
			If _cParam == "1"
				_nB2QTDPRE := SB2->B2_XQTDPRE - _nQuant
			Else
				_nB2QTDPRE := SB2->B2_XQTDPRE + _nQuant
			Endif
			RecLock("SB2",.F.)
			Replace B2_XQTDPRE with _nB2QTDPRE
			MsUnLock()
		Endif

		dbSelectArea("SD1")
		dbSkip()
	End
	RestArea(_aAreaD1)
	RestArea(_aArea)
Return

//-------------------------------------------------------------------------------------------------
//
//Rotta
Static Function Atu_Conf(_cChave,_nRot)
	Local lAchou := .F.
	Local _aArea := GetArea()
	//Local _cCodServ := SuperGetMv('MV_XSRVEND',.F.,"003")
	//Local cMapa := ""
	Local _lFinaliza := .T.
	//Local _lServExec := .T.
	dbSelectArea("DCX")
	dbSetOrder(2)
	If dbSeek(xFilial()+_cChave)
		lAchou := .T.
		If _nRot >= 3 .and. _nRot <= 4 //manter regra definida por rotta
			_cEmbarq := DCX->DCX_EMBARQ
			RecLock("DCX",.F.)
			Replace DCX_XSTATU with "2"
			MsUnLock()
			dbSelectArea("DCX")
			dbSetOrder(1)
			dbSeek(xFilial()+_cEmbarq)
			While !Eof() .and. xFilial("DCX")+_cEmbarq == DCX->(DCX_FILIAL+DCX_EMBARQ)
				If DCX->DCX_XSTATU <> "2"
					_lFinaliza := .F.
					Exit
				Endif
				dbSkip()
			End
			If _lFinaliza
				dbSelectArea("DCW")
				dbSetOrder(1)
				If dbSeek(xFilial()+_cEmbarq)
					RecLock("DCW",.F.)
					Replace DCW_XSTATU with "2"
					MsUnLock()
				Endif
			Endif
		EndIf
	Endif
	RestArea(_aArea)
Return lAchou


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 26/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function AtuPisCof(_cChave)


	Local nVlBase := 0
	Local cConta    := ""
	//Local cTes      := ""
	Local cQry      := ""
	Local lSoltrib  := .F.


	cQry := " SELECT D1_TES,d1_filial,d1_doc, d1_serie, d1_DTDIGIT, d1_cod, d1_item,d1_xoper,D1_TOTAL,D1_DESPESA,D1_VALFRE,D1_ICMSRET,D1_VALICM,Z24_CONTA,SD1.R_E_C_N_O_ "
    cQry += " FROM SD1010 SD1 "
    cQry += " INNER JOIN " + RetSqlName("SB1") + " ON '" + xFilial("SB1") + "' = B1_FILIAL AND D1_COD = B1_COD "
    cQry += " LEFT JOIN " + RetSqlName("Z24") + " ON '" + xFilial("Z24") + "' = Z24_FILIAL AND D1_XOPER = Z24_OPERA AND Z24_TPMOV = 'E' "
    cQry += " where SD1.d_e_l_e_t_ = ' ' "
    cQry += " and d1_Filial  = '"+SF1->F1_FILIAL+"' "
    cQry += " and D1_DOC     = '"+SF1->F1_DOC+"' "
    cQry += " and D1_SERIE   = '"+SF1->F1_SERIE+"' "
    cQry += " and D1_FORNECE = '"+SF1->F1_FORNECE+"' "

	If Select('PISCOF') > 0
        PISCOF->(DbCloseArea())
    endif

    cQuery := ChangeQuery(cQry)
    TCQUERY cQuery NEW ALIAS "PISCOF"

    PISCOF->(dbgotop())
        //TES

	WHILE ! PISCOF->(EOF())

		 cConta  := PISCOF->Z24_CONTA
		 //cTes    := PISCOF->D1_TES

		 dbSelectArea("SF4")
         SF4->(dbSetOrder(1))
         SF4->(DbSeek(PISCOF->D1_FILIAL+PISCOF->D1_TES))
			
		  dbSelectArea("SD1")
		  nSD1Rec := PISCOF->R_E_C_N_O_
          SD1->(dbGoto(nSD1Rec)  )

		If SFT->(dbSeek(xFilial("SFT")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD))  

		  //Monta a Base de calculo do PIS/COFINS no novo modelo incluindo o ICMS-ST e ICMS NORMAL
         IF SF4->F4_MKPCMP = '2' .AND.  SF4->F4_PISCRED $ "1%2%4"  

            nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_VALIPI+SD1->D1_ICMSRET

         ElseIf SD1->D1_ICMSRET=0 .AND. SF4->F4_CREDICM = 'S' .AND.  SF4->F4_PISCRED $ "1%2%4"  
        
		    nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_VALIPI-SD1->D1_VALICM

         ElseIF (SF4->F4_DESPCOF == '1' .OR. SF4->F4_DESPPIS == '1') .AND. SF4->F4_CREDIPI == 'S' .AND.  SF4->F4_PISCRED $ "1%2%4"

            nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE 

         ElseIF (SF4->F4_DESPCOF == '2' .OR. SF4->F4_DESPPIS == '2') .AND. SF4->F4_CREDIPI == 'N' .AND.  SF4->F4_PISCRED $ "1%2%4"

            nVlBase := SD1->D1_TOTAL+SD1->D1_VALIPI

         ElseIf SF4->F4_PISCRED $ "1%2%4"

            nVlBase := SD1->D1_TOTAL

         Else

            nVlBase := 0
                        
         EndIf

		 IF SF4->F4_MKPCMP == '2' .AND. SF4->F4_INCSOL = 'N' .AND. SF4->F4_CREDST = '2'
			lSoltrib :=.T.				 
		 ENDIF

			

			If SF4->F4_PISCRED $ "1%2"
						
				SD1->(Reclock("SD1", .F.))
					//Soma ao Custo o Pis/Cofins que o sistema tirou
					nPisCofOld		:= ( SD1->D1_VALIMP5 + SD1->D1_VALIMP6 )
					SD1->D1_CUSTO	:= SD1->D1_CUSTO + ( SD1->D1_VALIMP5 + SD1->D1_VALIMP6 )
					//SD1->D1_TES     := cTes
					SD1->D1_ALQIMP6 := 1.65
					SD1->D1_BASIMP6 := nVlBase
					SD1->D1_VALIMP6 := nVlBase*(1.65/100)
					SD1->D1_ALQIMP5 := 7.6
					SD1->D1_BASIMP5 := nVlBase
					SD1->D1_VALIMP5 := nVlBase*(7.6/100)
					SD1->D1_CONTA   := ALLTRIM(cConta)
					//Retira do Custo o novo Pis/Cofins calculado    
					SD1->D1_CUSTO   := SD1->D1_CUSTO - ROUND(( (nVlBase*(1.65/100)) + (nVlBase*(7.6/100)) ),2)
				SD1->(MsUnlock())
				//Acerto SB2 Custo Médio e Valor Atual
				dbSelectArea("SB2")
			    SB2->(dbSetOrder(1))
				If dbSeek(SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_LOCAL)
					nB2QAtu	:=SB2->B2_QATU
					IF nB2QAtu>0
						SB2->(Reclock("SB2", .F.))
						nB2VAtu :=SB2->B2_VATU1
						nB2VAtu :=nB2VAtu+nPisCofOld
						nB2VAtu :=nB2VAtu-ROUND(( (nVlBase*(1.65/100)) + (nVlBase*(7.6/100)) ),2)
						SB2->B2_CM1 := ROUND(nB2VAtu/nB2QAtu,2)
						SB2->B2_VATU1 := nB2VAtu
						SB2->(MsUnlock())
					ENDIF
				endif
				//MONTAR AQUI O TRECHO DA SF3
				SF3->(dbSetOrder(1))
				IF lSoltrib  .AND. SF3->(dbSeek(SD1->D1_FILIAL+DTOS(SD1->D1_DTDIGIT)+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_CF+iif(SFT->FT_VALICM=0,STR(0,5,2),STR(SD1->D1_PICM,5,2)) )) //MELHORAR CHAVE 
					WHILE  !SF3->(EOF()) .AND. SF3->(F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2))==SD1->D1_FILIAL+DTOS(SD1->D1_DTDIGIT)+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+iif(SFT->FT_VALICM=0,STR(0,5,2),STR(SD1->D1_PICM,5,2))
						IF SF3->F3_NRLIVRO==SF4->F4_NRLIVRO
							SF3->(Reclock("SF3",.F.))
								SF3->F3_SOLTRIB += SD1->D1_ICMSRET
							SF3->(MsUnlock())
						ENDIF
						SF3->(dbSkip())
					ENDDO
				ENDIF
				

				SFT->(Reclock("SFT",.F.))
					//SFT->FT_TES     := cTes
					SFT->FT_CODBCC  := SF4->F4_CODBCC
					SFT->FT_CSTPIS  := SF4->F4_CSTPIS
					SFT->FT_BASEPIS := nVlBase
					SFT->FT_ALIQPIS := 1.65
					SFT->FT_VALPIS  := nVlBase*(1.65/100)
					SFT->FT_CSTCOF  := SF4->F4_CSTCOF
					SFT->FT_BASECOF := nVlBase
					SFT->FT_ALIQCOF := 7.6
					SFT->FT_VALCOF  := nVlBase*(7.6/100)
					SFT->FT_CONTA   := ALLTRIM(cConta)
					IF lSoltrib
						SFT->FT_SOLTRIB := SD1->D1_ICMSRET
					ENDIF
				SFT->(MsUnlock())

					dbselectarea("CD2")
					CD2->(dbSetOrder(2))

				If CD2->(dbSeek(xFilial("CD2")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD+"PS2   "))

					CD2->(Reclock("CD2",.F.))
					CD2->CD2_CST     := SF4->F4_CSTPIS
					CD2->CD2_BC      := nVlBase
					CD2->CD2_ALIQ    := 1.65
					CD2->CD2_VLTRIB  := nVlBase*(1.65/100)
					CD2->(MsUnlock()) 
				Else
					CD2->(Reclock("CD2",.T.))
						CD2->CD2_FILIAL  := SD1->D1_FILIAL
						CD2->CD2_TPMOV   := "E"
						CD2->CD2_DOC     := SD1->D1_DOC
						CD2->CD2_SERIE   := SD1->D1_SERIE
						CD2->CD2_CODFOR  := SD1->D1_FORNECE
						CD2->CD2_LOJFOR  := SD1->D1_LOJA
						CD2->CD2_ITEM    := SD1->D1_ITEM
						CD2->CD2_CODPRO  := SD1->D1_COD
						CD2->CD2_IMP     := "PS2"
						CD2->CD2_ORIGEM  := "0"
						CD2->CD2_CST     := SF4->F4_CSTPIS
						CD2->CD2_BC      := nVlBase
						CD2->CD2_ALIQ    := 1.65
						CD2->CD2_VLTRIB  := nVlBase*(1.65/100)
						CD2->CD2_QTRIB   := SD1->D1_QUANT
						CD2->CD2_PARTIC  := "1"
						CD2->CD2_SDOC    := SD1->D1_SERIE 
					CD2->(MsUnlock())                         

				EndIf   
				If CD2->(dbSeek(xFilial("CD2")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD+"CF2   "))

				CD2->(Reclock("CD2",.F.))
					CD2->CD2_CST     := SF4->F4_CSTPIS
					CD2->CD2_BC      := nVlBase
					CD2->CD2_ALIQ    := 7.6
					CD2->CD2_VLTRIB  := nVlBase*(7.6/100)
				CD2->(MsUnlock()) 
				Else

				CD2->(Reclock("CD2",.T.))
				CD2->CD2_FILIAL  := SD1->D1_FILIAL
				CD2->CD2_TPMOV   := "E"
				CD2->CD2_DOC     := SD1->D1_DOC
				CD2->CD2_SERIE   := SD1->D1_SERIE
				CD2->CD2_CODFOR  := SD1->D1_FORNECE
				CD2->CD2_LOJFOR  := SD1->D1_LOJA
				CD2->CD2_ITEM    := SD1->D1_ITEM
				CD2->CD2_CODPRO  := SD1->D1_COD
				CD2->CD2_IMP     := "CF2"
				CD2->CD2_ORIGEM  := "0"
				CD2->CD2_CST     := SF4->F4_CSTPIS
				CD2->CD2_BC      := nVlBase
				CD2->CD2_ALIQ    := 7.6
				CD2->CD2_VLTRIB  := nVlBase*(7.6/100)
				CD2->CD2_QTRIB   := SD1->D1_QUANT
				CD2->CD2_PARTIC  := "1"
				CD2->CD2_SDOC    := SD1->D1_SERIE 
				CD2->(MsUnlock())                        

				EndIf

			ElseIf SF4->F4_PISCOF == '3' .AND. SF4->F4_PISCRED == '4'

				SD1->(Reclock("SD1", .F.))
					//SD1->D1_TES     := cTes
					SD1->D1_ALQIMP6 := 0
					SD1->D1_BASIMP6 := nVlBase
					SD1->D1_VALIMP6 := 0
					SD1->D1_ALQIMP5 := 0
					SD1->D1_BASIMP5 := nVlBase
					SD1->D1_VALIMP5 := 0
					SD1->D1_CONTA   := ALLTRIM(cConta)
				SD1->(MsUnlock())

				
				SFT->(Reclock("SFT",.F.))
					//SFT->FT_TES     := cTes
					SFT->FT_CODBCC  := ' '
					SFT->FT_CSTPIS  := SF4->F4_CSTPIS
					SFT->FT_BASEPIS := nVlBase
					SFT->FT_ALIQPIS := 0
					SFT->FT_VALPIS  := 0
					SFT->FT_CSTCOF  := SF4->F4_CSTCOF
					SFT->FT_BASECOF := nVlBase
					SFT->FT_ALIQCOF := 0
					SFT->FT_VALCOF  := 0
					SFT->FT_CONTA   := ALLTRIM(cConta)
				SFT->(MsUnlock())

				dbselectarea("CD2")
				CD2->(dbSetOrder(2))

				IF CD2->(dbSeek(xFilial("CD2")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD+"PS2   "))

				CD2->(Reclock("CD2",.F.))
					CD2->CD2_CST     := SF4->F4_CSTPIS
					CD2->CD2_BC      := nVlBase
					CD2->CD2_ALIQ    := 0
					CD2->CD2_VLTRIB  := 0
				CD2->(MsUnlock()) 

				Else
				CD2->(Reclock("CD2",.T.))
				CD2->CD2_FILIAL  := SD1->D1_FILIAL
				CD2->CD2_TPMOV   := "E"
				CD2->CD2_DOC     := SD1->D1_DOC
				CD2->CD2_SERIE   := SD1->D1_SERIE
				CD2->CD2_CODFOR  := SD1->D1_FORNECE
				CD2->CD2_LOJFOR  := SD1->D1_LOJA
				CD2->CD2_ITEM    := SD1->D1_ITEM
				CD2->CD2_CODPRO  := SD1->D1_COD
				CD2->CD2_IMP     := "PS2"
				CD2->CD2_ORIGEM  := "0"
				CD2->CD2_CST     := SF4->F4_CSTPIS
				CD2->CD2_BC      := nVlBase
				CD2->CD2_ALIQ    := 0
				CD2->CD2_VLTRIB  := 0
				CD2->CD2_QTRIB   := SD1->D1_QUANT
				CD2->CD2_PARTIC  := "1"
				CD2->CD2_SDOC    := SD1->D1_SERIE 
				CD2->(MsUnlock()) 

				EndIf

				IF CD2->(dbSeek(xFilial("CD2")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD+"CF2   "))

				CD2->(Reclock("CD2",.F.))
					CD2->CD2_CST     := SF4->F4_CSTPIS
					CD2->CD2_BC      := nVlBase
					CD2->CD2_ALIQ    := 0
					CD2->CD2_VLTRIB  := 0
				CD2->(MsUnlock()) 

				Else
				CD2->(Reclock("CD2",.T.))
				CD2->CD2_FILIAL  := SD1->D1_FILIAL
				CD2->CD2_TPMOV   := "E"
				CD2->CD2_DOC     := SD1->D1_DOC
				CD2->CD2_SERIE   := SD1->D1_SERIE
				CD2->CD2_CODFOR  := SD1->D1_FORNECE
				CD2->CD2_LOJFOR  := SD1->D1_LOJA
				CD2->CD2_ITEM    := SD1->D1_ITEM
				CD2->CD2_CODPRO  := SD1->D1_COD
				CD2->CD2_IMP     := "CF2"
				CD2->CD2_ORIGEM  := "0"
				CD2->CD2_CST     := SF4->F4_CSTPIS
				CD2->CD2_BC      := nVlBase
				CD2->CD2_ALIQ    := 0
				CD2->CD2_VLTRIB  := 0
				CD2->CD2_QTRIB   := SD1->D1_QUANT
				CD2->CD2_PARTIC  := "1"
				CD2->CD2_SDOC    := SD1->D1_SERIE 
				CD2->(MsUnlock()) 

				EndIf

			Else     
				SD1->(Reclock("SD1", .F.))
				//SD1->D1_TES     := cTes
				SD1->D1_ALQIMP6 := 0
				SD1->D1_BASIMP6 := 0
				SD1->D1_VALIMP6 := 0
				SD1->D1_ALQIMP5 := 0
				SD1->D1_BASIMP5 := 0
				SD1->D1_VALIMP5 := 0    
				SD1->D1_CONTA   := ALLTRIM(cConta)                
				SD1->(MsUnlock())

				SFT->(Reclock("SFT",.F.))
					//SFT->FT_TES     := cTes
					SFT->FT_CODBCC  := ' '
					SFT->FT_CSTPIS  := SF4->F4_CSTPIS
					SFT->FT_BASEPIS := 0
					SFT->FT_ALIQPIS := 0
					SFT->FT_VALPIS  := 0
					SFT->FT_CSTCOF  := SF4->F4_CSTCOF
					SFT->FT_BASECOF := 0
					SFT->FT_ALIQCOF := 0
					SFT->FT_VALCOF  := 0
					SFT->FT_CONTA   := ALLTRIM(cConta) 
				SFT->(MsUnlock())

			Endif
		EndIF	
    	PISCOF->(dbSkip())
	EndDo 
	PISCOF->(DbCloseArea())
Return 
