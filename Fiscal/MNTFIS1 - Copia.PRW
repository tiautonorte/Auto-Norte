#INCLUDE "Topconn.ch"
#include "protheus.ch"
#include "parmtype.ch"
/*
Financeiro
Autor: Jubirajara|Data: 05/10/2020
Manutenção TES e PIS e Cofins
*/
User Function MNTFIS1
    Local aPergs 	:= {}
    Local aRet 	    := {}
    Local aMvPar	:= {}
    Local nMv       := 0
    Local aCombo    := {"Corrigir","Validar"}
    Local aCombo2   := {"Nao","Sim"}
    Local aCombo3   := {"Entrada","Saida","Ambos"}

    aadd(aPergs, {1, "Filial De: "           , Space(6), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Filial Até: "          , Space(6), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Emissão/Dt Digit De: " , StoD(""), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Emissão/Dt Digit Até: ", StoD(""), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Grupo do Produto: "    , Space(60), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Ncm: "                 , Space(60), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Codigo Prod De: "      , Space(15), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {1, "Codigo Prod Ate: "     , Space(15), ""     , ".T.", '', '.T.', 60, .F.})
    aadd(aPergs, {2, "Opção: "               , 1       , aCombo , 90   , "", .T.})
    aadd(aPergs, {2, "Ajust.Tes NF: "        , 1       , aCombo2, 90   , "", .T.})
    aadd(aPergs, {2, "Tipo NF: "             , Space(15), aCombo3, 90   , "", .T.})

    //Guarda valor dos parametros MV's
    For nMv := 1 To Len(aPergs)
        aAdd(aMvPar, &("MV_PAR" + StrZero(nMv,2,0)))
    Next nMv

    
    If ParamBox(aPergs ,"Ajuste PIS/COFINS",aRet,,,,,,,,.F.,.F.)
        nOpc  := aScan(aCombo ,{|x| alltrim(x) == aRet[9]})
        nOpc2 := aScan(aCombo2 ,{|x| alltrim(x) == aRet[10]})
        nOpc3 := aScan(aCombo3 ,{|x| alltrim(x) == aRet[11]})

        IF aRet[11] == 'Ambos'

          FWMsgRun(, {|oSay| ExecutaE(oSay,aRet,nOpc==2,nOpc2==2,nOpc3) }, "Entradas*...", "Carregando Empresa de "+MV_PAR01+" ate "+MV_PAR02+"")

          FWMsgRun(, {|oSay| ExecutaS(oSay,aRet,nOpc==2,nOpc2==2,nOpc3) }, "Saidas*...", "Carregando Empresa de "+MV_PAR01+" ate "+MV_PAR02+" "  )

        ELSEIF  aRet[11] == 'Entrada'

          FWMsgRun(, {|oSay| ExecutaE(oSay,aRet,nOpc==2,nOpc2==2,nOpc3) }, "Entradas*...", "Carregando Empresa de "+MV_PAR01+" ate "+MV_PAR02+"")

        ELSE

          FWMsgRun(, {|oSay| ExecutaS(oSay,aRet,nOpc==2,nOpc2==2,nOpc3) }, "Saidas*...", "Carregando Empresa de "+MV_PAR01+" ate "+MV_PAR02+" "  )      

        ENDIF 

    EndIf

    //Restaura o conteudo dos parametros
    For nMv := 1 To Len( aMvPar )
        &("MV_PAR" + StrZero(nMv,2,0) ) := aMvPar[nMv]
    Next nMv

Return

Static Function ExecutaS(oSay,aRet,lValida,lAjusTes,lEntSai)

    //Local cCabLog := "MSGLOG;FILIAL;DOC;SERIE;CLIFOR;MOV;TIPO;TES ANT;TES NOVO;D2_ALQIMP6 ANT;D2_ALQIMP6 NOVO;D2_BASIMP6 ANT;D2_BASIMP6 NOVO;D2_VALIMP6 ANT;D2_VALIMP6 NOVO;D2_ALQIMP5 ANT;D2_ALQIMP5 NOVO;D2_BASIMP5 ANT;D2_BASIMP5 NOVO;D2_VALIMP5 ANT;D2_VALIMP5 NOVO"
    Local cCabLog  := "MSGLOG;FILIAL;DOC;SERIE;CLIFOR;ITEM;CODPRO;TESATUAL;TES"
    Local cArqLogS := "LogPisCof_Saida"
    Local nLin     := 0
    Local nQtd     := 0
    Local aLog     := {}
    Local nTotBrt  := 0
    Local cGrpProd := ""
    Local cNcm     := ""


    If !Empty(MV_PAR05)
		cGrpProd := "('"+StrTran(AllTrim(MV_PAR05),";","','")+"')"
	EndIf

	If !Empty(MV_PAR06)
		cNcm := "('"+StrTran(AllTrim(MV_PAR06),";","','")+"')"
	EndIf
 
     
     cQry := " SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO "
     cQry += " FROM " + RetSqlName("SF2") + " SF2 "
     cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND SD2.D_E_L_E_T_ = ' ' "
     cQry += " INNER JOIN " + RetSqlName("SB1") + " ON '" + xFilial("SB1") + "' = B1_FILIAL AND D2_COD = B1_COD  "
     cQry += " INNER JOIN " + RetSqlName("SA1") + " ON '" + xFilial("SA1") + "' = A1_FILIAL AND  D2_CLIENTE = A1_COD "
     cQry += " WHERE SF2.D_E_L_E_T_ = ' ' "
     cQry += " AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
     cQry += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
     IF !Empty(MV_PAR05)  
        cQry += " AND B1_GRTRIB IN "+cGrpProd
     ENDIF
     IF !Empty(MV_PAR06)  
        cQry += " AND B1_POSIPI IN "+cNcm
     ENDIF
     IF !Empty(MV_PAR07) .And. !Empty(MV_PAR08)
        cQry += " AND D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
    ELSEIF Empty(MV_PAR07) .And. !Empty(MV_PAR08)    
        cQry += " AND D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
    ENDIF
     cQry += " GROUP BY F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO "
     cQry += " ORDER BY F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO "
     
     //*    Query para Verificar as inconsistencias do calculo do PIS/COFINS
     //cQry := " SELECT D2_FILIAL AS F2_FILIAL, D2_DOC AS F2_DOC,D2_SERIE AS F2_SERIE,D2_CLIENTE AS F2_CLIENTE,D2_LOJA AS F2_LOJA,D2_TIPO AS F2_TIPO,D2_ITEM FROM SD2010 S "
     //cQry += " INNER JOIN SB1010 ON D2_COD = B1_COD "
     //cQry += " INNER JOIN SA1010 ON D2_CLIENTE = A1_COD "
     //cQry += " WHERE D2_EMISSAO BETWEEN '20210101' AND '20210131'AND B1_GRTRIB IN ('005','045','085','086','200','210','215','250','260','265') "  
     //cQry += " AND D2_XOPER IN ('01','D1','D6','D7','G1','G6','G7') AND D2_VALIMP6 > 0 AND S.d_e_l_e_t_ = ' ' "  
     //cQry += " GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_TIPO,D2_ITEM ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_TIPO,D2_ITEM "   
     

    if Select('QSF2') > 0
        QSF2->(DbCloseArea())
    endif

    MemoWrite("MNTFIS1_SF2.sql",cQry)

    cQuery := ChangeQuery(cQry)
    TCQUERY cQuery NEW ALIAS "QSF2"

    //Conta registros na temporária
    nQtd := U_ContReg("QSF2")

    //cQry := "SELECT d2_filial,d2_doc, d2_serie, d2_emissao, d2_cod d2_item,d2_xoper,R_E_C_N_O_"
    //cQry += "FROM sd2010 "
    //cQry += "where  "
    //cQry += "d2_emissao >='"+DTOS(MV_PAR03)+"'"
    //cQry += "and d2_emissao <='"+DTOS(MV_PAR04)+"'"
    //cQry += "and d2_Filial >='"+MV_PAR01+"'"
    //cQry += "and d2_filial <='"+MV_PAR02+"'"
    //cQry += "and sd2010.d_e_l_e_t_ = ' ' "
    //cQry += "order by d2_emissao,d2_doc, d2_serie,d2_item "

    While !QSF2->(Eof())
        nLin++
        oSay:cCaption := (cValToChar(MV_PAR01) + " a "+ cValToChar(MV_PAR02)+" "+" De "+ cValToChar(dtoc(MV_PAR03)) +" a "+cValToChar(dtoc(MV_PAR04))+" "+cValToChar(nLin) +" de "+ cValToChar(nQtd) +" - "+ cValToChar(Round((nLin/nQtd)*100,2)) +"%")
        ProcessMessage()

        nTotBrt := 0

        
        cQry := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM,D2_EMISSAO, "
        cQry += " D2_TES,D2_XOPER,D2_TOTAL,D2_DESPESA,D2_VALFRE,d2_valipi,B1_GRTRIB,SD2.R_E_C_N_O_ "
        cQry += " FROM " + RetSqlName("SD2") + " SD2 "
        cQry += " INNER JOIN " + RetSqlName("SB1") + " ON '" + xFilial("SB1") + "' = B1_FILIAL AND D2_COD = B1_COD "
        cQry += " where SD2.D_E_L_E_T_ = ' ' "
        cQry += " and D2_FILIAL  = '"+QSF2->F2_FILIAL+"' "
        cQry += " and D2_DOC     = '"+QSF2->F2_DOC+"' "
        cQry += " and D2_SERIE   = '"+QSF2->F2_SERIE+"' "
        cQry += " and D2_CLIENTE = '"+QSF2->F2_CLIENTE+"' "
        IF !Empty(MV_PAR05)  
            cQry += " AND B1_GRTRIB IN "+cGrpProd
        ENDIF
        IF !Empty(MV_PAR06)
            cQry += " AND B1_POSIPI IN "+cNcm
        ENDIF
        IF !Empty(MV_PAR07) .And. !Empty(MV_PAR08)
            cQry += " AND D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
        ELSEIF Empty(MV_PAR07) .And. !Empty(MV_PAR08)    
            cQry += " AND D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
        ENDIF
        

        if Select('TRB') > 0
            TRB->(DbCloseArea())
        endif

        MemoWrite("MNTFIS1_SD2.sql",cQry)

        cQuery := ChangeQuery(cQry)
        TCQUERY cQuery NEW ALIAS "TRB"
        //Clientes
        dbselectarea("SA1")
        dbSetOrder(1)
        TRB->(dbgotop())
        //TES
        dbSelectArea("SF4")
        SF4->(dbSetOrder(1))
        while ! TRB->(EOF())

            //logar na filial da nota
            If cFilAnt <> QSF2->F2_FILIAL
                dbSelectArea("SM0") //Abro a SM0
                SM0->(dbSetOrder(1))
                If SM0->(dbSeek("01" + QSF2->F2_FILIAL,.T.)) //Posiciona Empresa
                    //Seto as variaveis de ambiente
                    cEmpAnt := SM0->M0_CODIGO
                    cFilAnt := SM0->M0_CODFIL
                    OpenFile(cEmpAnt + cFilAnt)
                EndIf
            EndIf

            //Pula se estiver sem operação
            If Empty(TRB->D2_XOPER)
                TRB->(dbSkip())
                Loop
            EndIf

            dbselectarea("SA1")
            SA1->(dbSeek(xFilial("SA1")+QSF2->F2_CLIENTE + QSF2->F2_LOJA))
            cOper       := TRB->d2_xoper
            _cCliFor    := QSF2->F2_CLIENTE
            _cLojaFor   := QSF2->F2_LOJA
            cTipoForCli := iif(QSF2->F2_TIPO == 'D','F',"C")//SA1->A1_TIPO
            _cProduto   := TRB->d2_cod

            If lAjusTes
            //Busca tes
               cTes := MaTesInt( 2, cOper, _cCliFor, _cLojaFor, cTipoForCli, _cProduto, Nil)
            Else
               cTes := TRB->D2_TES
            EndIF


            If !Empty(cTes) 

                dbSelectArea("SF4")
                SF4->(DbSeek(xFilial("SF4")+cTes))

                nSD2Rec := TRB->R_E_C_N_O_
                SD2->(dbGoto(nSD2Rec)  )

                //Se posiciona da Tabela SFT para alterala juntamente com a SD2    
                dbselectarea("SFT")
                SFT->(dbSetOrder(1))

             If SFT->(dbSeek(xFilial("SFT")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD))
                
                
                If TRB->D2_EMISSAO <= '20201231'

                 //Monta Base do  PIS/COFINS
                    IF SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N' 

                        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE+SD2->D2_VALIPI

                    ElseIf SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'S' 

                        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE

                    ElseIf SF4->F4_DESPCOF == '2' .AND. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' 

                        nVlBase := SD2->D2_TOTAL+SD2->D2_VALIPI

                    Else

                        nVlBase := SD2->D2_TOTAL   

                    EndIF

                Else 

                    IF SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_CREDICM == 'S' .AND. SD2->D2_FILIAL <> '020108' .AND.  TRB->B1_GRTRIB <= '099'

                        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE-SD2->D2_VALICM

                    ElseIf SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'S' .AND. SF4->F4_CREDICM == 'S' .AND. SD2->D2_FILIAL <> '020108' .AND.  TRB->B1_GRTRIB <= '099'

                        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE+SD2->D2_VALIPI-SD2->D2_VALICM

                    ElseIf SF4->F4_DESPCOF == '2' .AND. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_CREDICM == 'S' .AND. SD2->D2_FILIAL <> '020108' .AND.  TRB->B1_GRTRIB <= '099'

                        nVlBase := SD2->D2_TOTAL+SD2->D2_VALIPI-SD2->D2_VALICM

                    ElseIf SF4->F4_DESPCOF == '2' .AND. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' 

                        nVlBase := SD2->D2_TOTAL+SD2->D2_VALIPI

                    Else

                        nVlBase := SD2->D2_TOTAL   

                    EndIF

                EndIf

                // Recompor o campo D2_VALBRUT dos itens de saida
                /*
                IF !lValida
                  IF SF4->F4_INCSOL == 'S' .AND. SF4->F4_MKPCMP == '2' 

                    nValBrut := SD2->D2_TOTAL + SD2->D2_DESPESA + SD2->D2_VALFRE + SD2->D2_ICMSRET + SD2->D2_VALIPI
                  ELSE   

                    nValBrut := SD2->D2_TOTAL + SD2->D2_DESPESA + SD2->D2_VALFRE + SD2->D2_VALIPI

                  ENDIF

                 nTotBrt += nValBrut
                ENDIF
                */
                
                IF lValida .AND. ALLTRIM(SD2->D2_TES) <> ALLTRIM(cTes)

                    IF SF4->F4_PISCRED $ "1%2" 
                        nAliqPis := 1.65
                        nValPis  := nVlBase*(1.65/100)
                        nAliqCof := 7.6
                        nValCof  := nVlBase*(7.6/100)
                    ELSE
                        nAliqPis := 0
                        nValPis  := 0
                        nAliqCof := 0
                        nValCof  := 0
                    ENDIF 

                ENDIF

                If !lValida
                    If SF4->F4_PISCRED $ "1%2" 

                        SD2->(Reclock("SD2", .F.))
                            SD2->D2_TES     := cTes
                            SD2->D2_ALQIMP6 := 1.65
                            SD2->D2_BASIMP6 := nVlBase
                            SD2->D2_VALIMP6 := nVlBase*(1.65/100)
                            SD2->D2_ALQIMP5 := 7.6
                            SD2->D2_BASIMP5 := nVlBase
                            SD2->D2_VALIMP5 := nVlBase*(7.6/100)
                          //SD2->D2_VALBRUT := nValBrut
                        SD2->(MsUnlock())

                        SFT->(Reclock("SFT",.F.))
                            SFT->FT_TES     := cTes
                            SFT->FT_CODBCC  := SF4->F4_CODBCC
                            SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                            SFT->FT_BASEPIS := nVlBase
                            SFT->FT_ALIQPIS := 1.65
                            SFT->FT_VALPIS  := nVlBase*(1.65/100)
                            SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                            SFT->FT_BASECOF := nVlBase
                            SFT->FT_ALIQCOF := 7.6
                            SFT->FT_VALCOF  := nVlBase*(7.6/100)
                        SFT->(MsUnlock())

                        dbselectarea("CD2")
                        CD2->(dbSetOrder(1))

                     If CD2->(dbSeek(xFilial("CD2")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD+"PS2   "))

                        CD2->(Reclock("CD2",.F.))
                            CD2->CD2_CST     := SF4->F4_CSTPIS
                            CD2->CD2_BC      := nVlBase
                            CD2->CD2_ALIQ    := 1.65
                            CD2->CD2_VLTRIB  := nVlBase*(1.65/100)
                        CD2->(MsUnlock()) 
                     Else

                       CD2->(Reclock("CD2",.T.))
                        CD2->CD2_FILIAL  := SD2->D2_FILIAL
                        CD2->CD2_TPMOV   := "S"
                        CD2->CD2_DOC     := SD2->D2_DOC
                        CD2->CD2_SERIE   := SD2->D2_SERIE
                        CD2->CD2_CODCLI  := SD2->D2_CLIENTE
                        CD2->CD2_LOJCLI  := SD2->D2_LOJA
                        CD2->CD2_ITEM    := SD2->D2_ITEM
                        CD2->CD2_CODPRO  := SD2->D2_COD
                        CD2->CD2_IMP     := "PS2"
                        CD2->CD2_ORIGEM  := "0"
                        CD2->CD2_CST     := SF4->F4_CSTPIS
                        CD2->CD2_BC      := nVlBase
                        CD2->CD2_ALIQ    := 1.65
                        CD2->CD2_VLTRIB  := nVlBase*(1.65/100)
                        CD2->CD2_QTRIB   := SD2->D2_QUANT
                        CD2->CD2_PARTIC  := "1"
                        CD2->CD2_SDOC    := SD2->D2_SERIE 
                       CD2->(MsUnlock()) 

                     EndIf

                     If CD2->(dbSeek(xFilial("CD2")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD+"CF2   "))

                        CD2->(Reclock("CD2",.F.))
                            CD2->CD2_CST     := SF4->F4_CSTPIS
                            CD2->CD2_BC      := nVlBase
                            CD2->CD2_ALIQ    := 7.6
                            CD2->CD2_VLTRIB  := nVlBase*(7.6/100)
                       CD2->(MsUnlock()) 

                     Else
                         
                       CD2->(Reclock("CD2",.T.))
                        CD2->CD2_FILIAL  := SD2->D2_FILIAL
                        CD2->CD2_TPMOV   := "S"
                        CD2->CD2_DOC     := SD2->D2_DOC
                        CD2->CD2_SERIE   := SD2->D2_SERIE
                        CD2->CD2_CODCLI  := SD2->D2_CLIENTE
                        CD2->CD2_LOJCLI  := SD2->D2_LOJA
                        CD2->CD2_ITEM    := SD2->D2_ITEM
                        CD2->CD2_CODPRO  := SD2->D2_COD
                        CD2->CD2_IMP     := "CF2"
                        CD2->CD2_ORIGEM  := "0"
                        CD2->CD2_CST     := SF4->F4_CSTPIS
                        CD2->CD2_BC      := nVlBase
                        CD2->CD2_ALIQ    := 7.6
                        CD2->CD2_VLTRIB  := nVlBase*(7.6/100)
                        CD2->CD2_QTRIB   := SD2->D2_QUANT
                        CD2->CD2_PARTIC  := "1"
                        CD2->CD2_SDOC    := SD2->D2_SERIE 
                       CD2->(MsUnlock()) 

                     EndIf  

                   ElseIf SF4->F4_PISCOF == '3' .AND. SF4->F4_PISCRED == '4'

                        SD2->(Reclock("SD2", .F.))
                            SD2->D2_TES     := cTes
                            SD2->D2_ALQIMP6 := 0
                            SD2->D2_BASIMP6 := nVlBase
                            SD2->D2_VALIMP6 := 0
                            SD2->D2_ALQIMP5 := 0
                            SD2->D2_BASIMP5 := nVlBase
                            SD2->D2_VALIMP5 := 0
                        SD2->(MsUnlock())

                        
                        SFT->(Reclock("SFT",.F.))
                            SFT->FT_TES     := cTes
                            SFT->FT_CODBCC  := ' '
                            SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                            SFT->FT_BASEPIS := nVlBase
                            SFT->FT_ALIQPIS := 0
                            SFT->FT_VALPIS  := 0
                            SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                            SFT->FT_BASECOF := nVlBase
                            SFT->FT_ALIQCOF := 0
                            SFT->FT_VALCOF  := 0
                        SFT->(MsUnlock())

                     dbselectarea("CD2")
                     CD2->(dbSetOrder(1))

                     IF CD2->(dbSeek(xFilial("CD2")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD+"PS2   "))

                       CD2->(Reclock("CD2",.F.))
                        CD2->CD2_CST    := SF4->F4_CSTPIS
                        CD2_BC          := nVlBase
                        CD2->CD2_ALIQ   := 0
                        CD2->CD2_VLTRIB := 0
                       CD2->(MsUnlock()) 

                     Else
                       CD2->(Reclock("CD2",.T.))
                        CD2->CD2_FILIAL  := SD2->D2_FILIAL
                        CD2->CD2_TPMOV   := "S"
                        CD2->CD2_DOC     := SD2->D2_DOC
                        CD2->CD2_SERIE   := SD2->D2_SERIE
                        CD2->CD2_CODCLI  := SD2->D2_CLIENTE
                        CD2->CD2_LOJCLI  := SD2->D2_LOJA
                        CD2->CD2_ITEM    := SD2->D2_ITEM
                        CD2->CD2_CODPRO  := SD2->D2_COD
                        CD2->CD2_IMP     := "PS2"
                        CD2->CD2_ORIGEM  := "0"
                        CD2->CD2_CST     := SF4->F4_CSTPIS
                        CD2->CD2_BC      := nVlBase
                        CD2->CD2_ALIQ    := 0
                        CD2->CD2_VLTRIB  := 0
                        CD2->CD2_QTRIB   := SD2->D2_QUANT
                        CD2->CD2_PARTIC  := "1"
                        CD2->CD2_SDOC    := SD2->D2_SERIE 
                       CD2->(MsUnlock()) 

                     EndIf

                     IF CD2->(dbSeek(xFilial("CD2")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD+"CF2   "))

                       CD2->(Reclock("CD2",.F.))
                        CD2->CD2_CST    := SF4->F4_CSTPIS
                        CD2_BC          := nVlBase
                        CD2->CD2_ALIQ   := 0
                        CD2->CD2_VLTRIB := 0
                       CD2->(MsUnlock()) 

                     Else
                       CD2->(Reclock("CD2",.T.))
                        CD2->CD2_FILIAL  := SD2->D2_FILIAL
                        CD2->CD2_TPMOV   := "S"
                        CD2->CD2_DOC     := SD2->D2_DOC
                        CD2->CD2_SERIE   := SD2->D2_SERIE
                        CD2->CD2_CODCLI  := SD2->D2_CLIENTE
                        CD2->CD2_LOJCLI  := SD2->D2_LOJA
                        CD2->CD2_ITEM    := SD2->D2_ITEM
                        CD2->CD2_CODPRO  := SD2->D2_COD
                        CD2->CD2_IMP     := "CF2"
                        CD2->CD2_ORIGEM  := "0"
                        CD2->CD2_CST     := SF4->F4_CSTPIS
                        CD2->CD2_BC      := nVlBase
                        CD2->CD2_ALIQ    := 0
                        CD2->CD2_VLTRIB  := 0
                        CD2->CD2_QTRIB   := SD2->D2_QUANT
                        CD2->CD2_PARTIC  := "1"
                        CD2->CD2_SDOC    := SD2->D2_SERIE 
                       CD2->(MsUnlock()) 

                     EndIf
                     
                    Else   

                        SD2->(Reclock("SD2", .F.))
                         SD2->D2_TES     := cTes
                         SD2->D2_ALQIMP6 := 0
                         SD2->D2_BASIMP6 := 0
                         SD2->D2_VALIMP6 := 0
                         SD2->D2_ALQIMP5 := 0
                         SD2->D2_BASIMP5 := 0
                         SD2->D2_VALIMP5 := 0                    
                        SD2->(MsUnlock())
                        
                        SFT->(Reclock("SFT",.F.))
                         SFT->FT_TES     := cTes
                         SFT->FT_CODBCC  := ' '
                         SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                         SFT->FT_BASEPIS := 0
                         SFT->FT_ALIQPIS := 0
                         SFT->FT_VALPIS  := 0
                         SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                         SFT->FT_BASECOF := 0
                         SFT->FT_ALIQCOF := 0
                         SFT->FT_VALCOF  := 0
                        SFT->(MsUnlock())

                    EndIf

                ElseIf ALLTRIM(SD2->D2_TES) <> ALLTRIM(cTes)
                    //FILIAL;DOC;SERIE;CLIFOR;MOV;TIPO;TES ANT;TES NOVO;D2_ALQIMP6 ANT;D2_ALQIMP6 NOVO;D2_BASIMP6 ANT;D2_BASIMP6 NOVO;D2_VALIMP6 ANT;D2_VALIMP6 NOVO;D2_ALQIMP5 ANT;D2_ALQIMP5 NOVO;D2_BASIMP5 ANT;D2_BASIMP5 NOVO;D2_VALIMP5 ANT;D2_VALIMP5 NOVO
                   // AADD(aLog,{QSF2->F2_FILIAL,QSF2->F2_DOC,QSF2->F2_SERIE,QSF2->F2_CLIENTE,"S",QSF2->F2_TIPO,SD2->D2_TES,cTes,SD2->D2_ALQIMP6,nAliqPis,SD2->D2_BASIMP6,nVlBase,SD2->D2_VALIMP6,nValPis,SD2->D2_ALQIMP5,nAliqCof,SD2->D2_BASIMP5,nVlBase,SD2->D2_VALIMP5,nValCof})
                   AADD(aLog,{"TES ENCONTRADO DIFERE DO TES ATUAL",QSF2->F2_FILIAL,QSF2->F2_DOC,QSF2->F2_SERIE,QSF2->F2_CLIENTE,TRB->D2_ITEM,TRB->D2_COD,TRB->D2_TES,cTes})
                EndIf
             Else
                // MsgAlert("Nota Não Encontrada na Tabela Fiscal SFT") 
                AADD(aLog,{"NOTA FISCAL NAO ENCONTRADA NA TABELA SFT",QSF2->F2_FILIAL,QSF2->F2_DOC,QSF2->F2_SERIE,QSF2->F2_CLIENTE,TRB->D2_ITEM,TRB->D2_COD,TRB->D2_TES,cTes})
             EndIf   

            ElseIf Empty(cTes)

                AADD(aLog,{"NAO FOI ENCONTRADO TES PARA O ITEM DA NOTA FISCAL",QSF2->F2_FILIAL,QSF2->F2_DOC,QSF2->F2_SERIE,QSF2->F2_CLIENTE,TRB->D2_ITEM,TRB->D2_COD,TRB->D2_TES,cTes})

            Else
                AADD(aLog,{"TES ENCONTRADO DIFERE DO TES ATUAL",QSF2->F2_FILIAL,QSF2->F2_DOC,QSF2->F2_SERIE,QSF2->F2_CLIENTE,TRB->D2_ITEM,TRB->D2_COD,TRB->D2_TES,cTes})
            EndIf

          dbselectarea("TRB")
          TRB->(dbSkip())
        EndDo
        //Altera o valor do F2_VALBRUT
        /*
        nSF2Rec := QSF2->R_E_C_N_O_
        SF2->(dbGoto(nSF2Rec)  )
        SF2->(Reclock("SF2", .F.))
        SF2->F2_VALBRUT := nTotBrt
        SF2->(MsUnlock())
        */

      TRB->(DbCloseArea())
      QSF2->(dbSkip())
EndDo

QSF2->(DbCloseArea())

Geralog(aLog,cCabLog,cArqLogS)

Return


Static Function ExecutaE(oSay,aRet,lValida,lAjusTes,lEntSai)

    //Local cCabLog := "FILIAL;DOC;SERIE;CLIFOR;MOV;TIPO;TES ANT;TES NOVO;D1_ALQIMP6 ANT;D1_ALQIMP6 NOVO;D1_BASIMP6 ANT;D1_BASIMP6 NOVO;D1_VALIMP6 ANT;D1_VALIMP6 NOVO;D1_ALQIMP5 ANT;D1_ALQIMP5 NOVO;D1_BASIMP5 ANT;D1_BASIMP5 NOVO;D1_VALIMP5 ANT;D1_VALIMP5 NOVO"
    Local cCabLog  := "MSGLOG;FILIAL;DOC;SERIE;CLIFOR;ITEM;CODPRO;TESATUAL;TES"
    Local cArqLogE := "LogPisCof_Entrada"
    Local nLin     := 0
    Local nQtd     := 0
    Local aLog     := {}
    Local cQry     := ""
    Local cGrpProd := ""
    Local cNcm     := ""


    If !Empty(MV_PAR05)
		cGrpProd := "('"+StrTran(AllTrim(MV_PAR05),";","','")+"')"
	EndIf

	If !Empty(MV_PAR06)
		cNcm := "('"+StrTran(AllTrim(MV_PAR06),";","','")+"')"
	EndIf


    cQry := " SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO "
    cQry += " FROM " + RetSqlName("SF1") + " SF1 "
    cQry += " INNER JOIN " + RetSqlName("SD1") + " SD1 ON F1_FILIAL = D1_FILIAL	AND F1_DOC = D1_DOC	AND F1_SERIE = D1_SERIE	AND F1_FORNECE = D1_FORNECE	AND SD1.D_E_L_E_T_ = ' ' "
    cQry += " INNER JOIN " + RetSqlName("SB1") + " ON '" + xFilial("SB1") + "' = B1_FILIAL AND D1_COD = B1_COD  "
    cQry += " INNER JOIN " + RetSqlName("SA1") + " ON '" + xFilial("SA1") + "' = A1_FILIAL AND  D1_FORNECE = A1_COD "
    cQry += " WHERE SF1.D_E_L_E_T_ = ' ' "
    cQry += " AND F1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
    cQry += " AND F1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
     IF !Empty(MV_PAR05)  
        cQry += " AND B1_GRTRIB IN "+cGrpProd
     ENDIF
     IF !Empty(MV_PAR06)  
        cQry += " AND B1_POSIPI IN "+cNcm
     ENDIF
     IF !Empty(MV_PAR07) .And. !Empty(MV_PAR08)
        cQry += " AND D1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
    ELSEIF Empty(MV_PAR07) .And. !Empty(MV_PAR08)    
        cQry += " AND D1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
    ENDIF
    cQry += " GROUP BY F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO "
    cQry += " ORDER BY F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO "
    
        
        //cQry := " SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO FROM SF1010 "
        //cQry += " WHERE D_E_L_E_T_ = ' ' "
        //cQry += " AND F1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
        //cQry += " AND F1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D_E_L_E_T_ = ' ' "
        
        //*    Query para Verificar as inconsistencias do calculo do PIS/COFINS
        //cQry := " SELECT D1_FILIAL AS F1_FILIAL, D1_DOC AS F1_DOC,D1_SERIE AS F1_SERIE,D1_FORNECE AS F1_FORNECE,D1_LOJA AS F1_LOJA,D1_TIPO AS F1_TIPO,D1_ITEM FROM SD1010 S "
        //cQry += " INNER JOIN SB1010 ON D1_COD = B1_COD "
        //cQry += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD "
        //cQry += " WHERE D1_DTDIGIT BETWEEN '20210101' AND '20210131'AND B1_GRTRIB IN ('005','045','085','086','200','210','215','250','260','265') "
        //cQry += " AND D1_XOPER IN ('01','D1','D6','D7','G1','G6','G7') AND D1_VALIMP6 > 0 AND S.d_e_l_e_t_ = ' ' "
        //cQry += " GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_TIPO,D1_ITEM ORDER BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_TIPO,D1_ITEM "
        


    if Select('QSF1') > 0
        QSF1->(DbCloseArea())
    endif

    MemoWrite("MNTFIS1_SF1.sql",cQry)

    cQuery := ChangeQuery(cQry)
    TCQUERY cQuery NEW ALIAS "QSF1"

    //Conta registros na temporária
    nQtd := U_ContReg("QSF1")

    While !QSF1->(Eof())
        nLin++
        //oSay:cCaption := (" Filial de "+ cValToChar(MV_PAR01) + " a "+ cValToChar(MV_PAR02)+" "+" Periodo de "+ cValToChar(dtoc(MV_PAR03)) +" a "+cValToChar(dtoc(MV_PAR04))+" "+cValToChar(nLin) +" de "+ cValToChar(nQtd) +" - "+ cValToChar(Round((nLin/nQtd)*100,2)) +"%")

        //oSay:cCaption := (" Filial "+ cValToChar(MV_PAR01) + " a "+ cValToChar(MV_PAR02)+" "+chr(13)+chr(10)+" Periodo de "+ cValToChar(dtoc(MV_PAR03)) +" a "+cValToChar(dtoc(MV_PAR04))+" "+chr(13)+chr(10)+cValToChar(nLin) +" de "+ cValToChar(nQtd) +" - "+ cValToChar(Round((nLin/nQtd)*100,2)) +"%")
        oSay:cCaption := (cValToChar(MV_PAR01) + " a "+ cValToChar(MV_PAR02)+" "+" De "+ cValToChar(dtoc(MV_PAR03)) +" a "+cValToChar(dtoc(MV_PAR04))+" "+cValToChar(nLin) +" de "+ cValToChar(nQtd) +" - "+ cValToChar(Round((nLin/nQtd)*100,2)) +"%")

        ProcessMessage()

        cQry := " SELECT D1_TES,d1_filial,d1_doc, d1_serie, d1_DTDIGIT, d1_cod, d1_item,d1_xoper,D1_TOTAL,D1_DESPESA,D1_VALFRE,D1_ICMSRET,D1_VALICM,SD1.R_E_C_N_O_ "
        cQry += " FROM SD1010 SD1 "
        cQry += " INNER JOIN " + RetSqlName("SB1") + " ON '" + xFilial("SB1") + "' = B1_FILIAL AND D1_COD = B1_COD "
        cQry += " where SD1.d_e_l_e_t_ = ' ' "
        cQry += " and d1_Filial  = '"+QSF1->F1_FILIAL+"' "
        cQry += " and D1_DOC     = '"+QSF1->F1_DOC+"' "
        cQry += " and D1_SERIE   = '"+QSF1->F1_SERIE+"' "
        cQry += " and D1_FORNECE = '"+QSF1->F1_FORNECE+"' "
         IF !Empty(MV_PAR05)  
            cQry += " AND B1_GRTRIB IN "+cGrpProd
        ENDIF
        IF !Empty(MV_PAR06)
            cQry += " AND B1_POSIPI IN "+cNcm
        ENDIF
        IF !Empty(MV_PAR07) .And. !Empty(MV_PAR08)
            cQry += " AND D1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
        ELSEIF Empty(MV_PAR07) .And. !Empty(MV_PAR08)    
            cQry += " AND D1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
        ENDIF
       

        if Select('TRB') > 0
            TRB->(DbCloseArea())
        endif

        MemoWrite("MNTFIS1_SD1.sql",cQry)

        cQuery := ChangeQuery(cQry)
        TCQUERY cQuery NEW ALIAS "TRB"
        //Clientes
        dbselectarea("SA2")
        dbSetOrder(1)
        TRB->(dbgotop())
        //TES
        dbSelectArea("SF4")
        SF4->(dbSetOrder(1))
        while ! TRB->(EOF())

            //logar na filial da nota
            If cFilAnt <> QSF1->F1_FILIAL
                dbSelectArea("SM0") //Abro a SM0
                SM0->(dbSetOrder(1))
                If SM0->(dbSeek("01" + QSF1->F1_FILIAL,.T.)) //Posiciona Empresa
                    //Seto as variaveis de ambiente
                    cEmpAnt := SM0->M0_CODIGO
                    cFilAnt := SM0->M0_CODFIL
                    OpenFile(cEmpAnt + cFilAnt)
                EndIf
            EndIf

            //Pula se estiver sem operação
            If Empty(TRB->D1_XOPER)
                TRB->(dbSkip())
                Loop
            EndIf

            dbselectarea("SA2")
            SA1->(dbSeek(xFilial("SA2")+QSF1->F1_FORNECE + QSF1->F1_LOJA))
            cOper       := TRB->d1_xoper
            _cCliFor    := QSF1->F1_FORNECE
            _cLojaFor   := QSF1->F1_LOJA
            cTipoForCli := iif(QSF1->F1_TIPO == 'D','C','F')//SA1->A1_TIPO
            _cProduto   := TRB->d1_cod

            If lAjusTes
            //Busca tes
                cTes := MaTesInt( 1, cOper, _cCliFor, _cLojaFor, cTipoForCli, _cProduto, Nil)
            Else
                cTes := TRB->D1_TES
            EndIf

            If !Empty(cTes)
                dbSelectArea("SF4")
                SF4->(DbSeek(xFilial("SF4")+cTes))

                nSD1Rec := TRB->R_E_C_N_O_
                SD1->(dbGoto(nSD1Rec)  )
                
                //Se posiciona da Tabela SFT para alterala juntamente com a SD1
                dbselectarea("SFT")
                SFT->(dbSetOrder(1))

              If SFT->(dbSeek(xFilial("SFT")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD))
                
                If TRB->D1_DTDIGIT <= '20201231'
                    //Monta Base do  PIS/COFINS
                    IF SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N'

                        nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_VALIPI

                    ElseIF SF4->F4_DESPCOF == '1' .OR. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'S'

                        nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE

                    ElseIF SF4->F4_DESPCOF == '2' .OR. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' 

                        nVlBase := SD1->D1_TOTAL+SD1->D1_VALIPI

                    Else

                        nVlBase := SD1->D1_TOTAL
                        
                    EndIf
                Else

                    //Monta a Base de calculo do PIS/COFINS no novo modelo incluindo o ICMS-ST e ICMS NORMAL
                    IF SF4->F4_MKPCMP = '2' .AND.  SF4->F4_PISCRED $ "1%2%4"  //SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_MKPCMP = '2'

                        nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_VALIPI+TRB->D1_ICMSRET

                    ElseIf SF4->F4_MKPCMP = '1' .AND. SF4->F4_CREDICM = 'S' .AND.  SF4->F4_PISCRED $ "1%2%4"  //SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_MKPCMP = '1' .AND. SF4->F4_CREDICM = 'S'

                        nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_VALIPI-TRB->D1_VALICM

                    ElseIF (SF4->F4_DESPCOF == '1' .OR. SF4->F4_DESPPIS == '1') .AND. SF4->F4_CREDIPI == 'S' .AND.  SF4->F4_PISCRED $ "1%2%4"

                        nVlBase := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE 

                    ElseIF (SF4->F4_DESPCOF == '2' .OR. SF4->F4_DESPPIS == '2') .AND. SF4->F4_CREDIPI == 'N' .AND.  SF4->F4_PISCRED $ "1%2%4"

                        nVlBase := SD1->D1_TOTAL+SD1->D1_VALIPI

                    ElseIf SF4->F4_PISCRED $ "1%2%4"

                        nVlBase := SD1->D1_TOTAL

                    Else

                        nVlBase := 0
                        
                    EndIf

                EndIf


                IF lValida .AND. ALLTRIM(SD1->D1_TES) <> ALLTRIM(cTes)

                    IF SF4->F4_PISCRED $ "1%2" 
                        nAliqPis := 1.65
                        nValPis  := nVlBase*(1.65/100)
                        nAliqCof := 7.6
                        nValCof  := nVlBase*(7.6/100)
                    ELSE
                        nAliqPis := 0
                        nValPis  := 0
                        nAliqCof := 0
                        nValCof  := 0
                    ENDIF 

                 ENDIF

                 If !lValida
                    If SF4->F4_PISCRED $ "1%2"
                        
                        SD1->(Reclock("SD1", .F.))
                            SD1->D1_TES     := cTes
                            SD1->D1_ALQIMP6 := 1.65
                            SD1->D1_BASIMP6 := nVlBase
                            SD1->D1_VALIMP6 := nVlBase*(1.65/100)
                            SD1->D1_ALQIMP5 := 7.6
                            SD1->D1_BASIMP5 := nVlBase
                            SD1->D1_VALIMP5 := nVlBase*(7.6/100)
                        SD1->(MsUnlock())
                    

                        SFT->(Reclock("SFT",.F.))
                            SFT->FT_TES     := cTes
                            SFT->FT_CODBCC  := SF4->F4_CODBCC
                            SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                            SFT->FT_BASEPIS := nVlBase
                            SFT->FT_ALIQPIS := 1.65
                            SFT->FT_VALPIS  := nVlBase*(1.65/100)
                            SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                            SFT->FT_BASECOF := nVlBase
                            SFT->FT_ALIQCOF := 7.6
                            SFT->FT_VALCOF  := nVlBase*(7.6/100)
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
                            SD1->D1_TES     := cTes
                            SD1->D1_ALQIMP6 := 0
                            SD1->D1_BASIMP6 := nVlBase
                            SD1->D1_VALIMP6 := 0
                            SD1->D1_ALQIMP5 := 0
                            SD1->D1_BASIMP5 := nVlBase
                            SD1->D1_VALIMP5 := 0
                        SD1->(MsUnlock())

                       
                       SFT->(Reclock("SFT",.F.))
                            SFT->FT_TES     := cTes
                            SFT->FT_CODBCC  := ' '
                            SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                            SFT->FT_BASEPIS := nVlBase
                            SFT->FT_ALIQPIS := 0
                            SFT->FT_VALPIS  := 0
                            SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                            SFT->FT_BASECOF := nVlBase
                            SFT->FT_ALIQCOF := 0
                            SFT->FT_VALCOF  := 0
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
                        SD1->D1_TES     := cTes
                        SD1->D1_ALQIMP6 := 0
                        SD1->D1_BASIMP6 := 0
                        SD1->D1_VALIMP6 := 0
                        SD1->D1_ALQIMP5 := 0
                        SD1->D1_BASIMP5 := 0
                        SD1->D1_VALIMP5 := 0                    
                        SD1->(MsUnlock())

                        SFT->(Reclock("SFT",.F.))
                         SFT->FT_TES     := cTes
                         SFT->FT_CODBCC  := ' '
                         SFT->FT_CSTPIS  := SF4->F4_CSTPIS
                         SFT->FT_BASEPIS := 0
                         SFT->FT_ALIQPIS := 0
                         SFT->FT_VALPIS  := 0
                         SFT->FT_CSTCOF  := SF4->F4_CSTCOF
                         SFT->FT_BASECOF := 0
                         SFT->FT_ALIQCOF := 0
                         SFT->FT_VALCOF  := 0
                        SFT->(MsUnlock())

                    Endif
                 ElseIf ALLTRIM(SD1->D1_TES) <> ALLTRIM(cTes)
                    //FILIAL;DOC;SERIE;CLIFOR;MOV;TIPO;TES ANT;TES NOVO;D1_ALQIMP6 ANT;D1_ALQIMP6 NOVO;D1_BASIMP6 ANT;D1_BASIMP6 NOVO;D1_VALIMP6 ANT;D1_VALIMP6 NOVO;D1_ALQIMP5 ANT;D1_ALQIMP5 NOVO;D1_BASIMP5 ANT;D1_BASIMP5 NOVO;D1_VALIMP5 ANT;D1_VALIMP5 NOVO
                    //AADD(aLog,{QSF1->F1_FILIAL,QSF1->F1_DOC,QSF1->F1_SERIE,QSF1->F1_FORNECE,"S",QSF1->F1_TIPO,SD1->D1_TES,cTes,SD1->D1_ALQIMP6,nAliqPis,SD1->D1_BASIMP6,nVlBase,SD1->D1_VALIMP6,nValPis,SD1->D1_ALQIMP5,nAliqCof,SD1->D1_BASIMP5,nVlBase,SD1->D1_VALIMP5,nValCof})
                    AADD(aLog,{"TES ENCONTRADO DIFERE DO TES ATUAL",QSF1->F1_FILIAL,QSF1->F1_DOC,QSF1->F1_SERIE,QSF1->F1_FORNECE,TRB->D1_ITEM,TRB->D1_COD,TRB->D1_TES,cTes})
                EndIf
             Else
                    AADD(aLog,{"NOTA FISCAL NAO ENCONTRADA NA TABELA SFT",QSF1->F1_FILIAL,QSF1->F1_DOC,QSF1->F1_SERIE,QSF1->F1_FORNECE,TRB->D1_ITEM,TRB->D1_COD,TRB->D1_TES,cTes})
             EndIf

            Else
              AADD(aLog,{"NAO FOI ENCONTRADO TES PARA O ITEM DA NOTA FISCAL",,QSF1->F1_FILIAL,QSF1->F1_DOC,QSF1->F1_SERIE,QSF1->F1_FORNECE,TRB->D1_ITEM,TRB->D1_COD,TRB->D1_TES,cTes})
            EndIf

        dbselectarea("TRB")
        TRB->(dbSkip())
        CD2->(MsUnlock())
        dbUnlockAll()
    EndDo

    TRB->(DbCloseArea())

    QSF1->(dbSkip())
EndDo

QSF1->(DbCloseArea())

Geralog(aLog,cCabLog,cArqLogE)


Return



Static Function GeraLog(aLog,cCabec,cArq)
    Local cTexto := cCabec + Chr(13) + Chr(10)
    Local nX := 0
    Local nY := 0

    If !Empty(aLog)

        For nX := 1 to Len(aLog)
            For nY := 1 to Len(aLog[1])
                cTexto += aLog[nX][nY]
                If Len(aLog[1]) == nY
                    cTexto += Chr(13) + Chr(10)
                Else
                    cTexto += ';'
                EndIf
            Next nY
        Next nX

        nHandle := FCREATE("C:\TEMP\"+ cArq + "_" + DToS(dDataBase) +'_'+ StrTran(Time(),':')+".csv")

        If nHandle = -1
            Return( Nil )
        Else
            FWrite(nHandle, cTexto)
            FClose(nHandle)

           // MsgAlert("Arquivo gerado em C:\Temp\") COMENTADO POIS ESTA TRAVANDO O PROXIMO PROCESSAMENTO
        Endif
    EndIf

Return
