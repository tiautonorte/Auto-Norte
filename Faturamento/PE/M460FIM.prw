#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} MATA460
  Função M460FIM
  @param Não há
  @return Não retorna nada
  @author Totvs Nordeste
  @owner Totvs S/A
  @version Protheus 11 e V12
  @since 12/11/2018 
  @sample
// MATA460 - User Function - Ponto de entrada no fim da gravação do Documento de Saída (NFe)
  U_M460FIM()
  Return
  @project 
  @history
  12/11/2018 - Desenvolvimento da Rotina.
/*/
User function M460FIM()

  Local aArea  := GetArea()
  Local cQuery := ""
  Local cSqlInd := ""
  Local cSql2 := ""
  Local nVlCom := 0
  //Local lZZP   := .F.
  //Local lTrans := .F.
  Local nPerInd := 0 // GETMV("AN_PERCIND") // Paramentro do Percentual da Comissao Indireta
  Local cDias := GETMV("AN_COMIND") // Paramentro para dias de ativacao da comissao indireta

  Local cMargem

  dbSelectArea("SE1")
  SE1->(dbSetOrder(1))

  If SE1->(dbSeek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DUPL))   //SF2->F2_DOC OU SF2->F2_DUPL
    While SE1->(!EOF()) .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DUPL
      If Alltrim(SE1->E1_TIPO) == "NF"
        RecLock("SE1",.F.)
        // --- Verifica se o cliente é "Pra Depois" e grava no
        // --- título para controle de impressão de boleto.
        // ---------------------------------------------------
        Replace SE1->E1_XGERFAT with IIf(SA1->A1_XDEPOIS == 'S','N','S')
        SE1->(MsUnlock())
      EndIf

      SE1->(dbSkip())
    EndDo
  EndIf
  //---------------------------------------------------------------------
  // --- Pegar os itens da nota-------------------------------------------
  // ---------------------------------------------------------------------
  // --- Calcular a comissão de acordo com a margem da letra de cada item
  // ---------------------------------------------------------------------



  cQuery := " SELECT DISTINCT(SD2.D2_DOC),SD2.D2_SERIE,SD2.D2_EMISSAO,SD2.D2_ITEMPV,D2_TES,SD2.D2_COD,SD2.D2_TOTAL,"
  cQuery += " CASE WHEN ZZI_MARREP IS NULL THEN 1 ELSE ZZI_MARREP END AS ZZI_MARREP,CASE WHEN ZZI_MARVEN IS NULL THEN 1 ELSE ZZI_MARVEN END AS ZZI_MARVEN,"
  cQuery += " SC5.C5_COMIS1,Z24_CONTA,B1_GRTRIB,SD2.R_E_C_N_O_ as RECNO "
  cQuery += "  From " + RetSqlName("SD2") + " SD2"
  cQuery += "   Inner Join " + RetSqlName("SC6") + " SC6"
  cQuery += "           On SC6.D_E_L_E_T_ = ' '"
  cQuery += "          and SC6.C6_FILIAL  = SD2.D2_FILIAL"
  cQuery += "          and SC6.C6_NUM     = SD2.D2_PEDIDO"
  cQuery += "          and SC6.C6_ITEM    = SD2.D2_ITEMPV"
  cQuery += "   LEFT Join " + RetSqlName("ZZI") + " ZZI"
  cQuery += "           On ZZI.D_E_L_E_T_ = ' '"
  cQuery += "          and ZZI.ZZI_LETRA  = SC6.C6_XLETRA"
  cQuery += "   Left Join " + RetSqlName("SC5") + " SC5"
  cQuery += "          on SC5.D_E_L_E_T_ = ' '"
  cQuery += "         and SC5.C5_FILIAL  = '" + xFilial("SC5") + "'"
  cQuery += "         and SC5.C5_NUM  = SD2.D2_PEDIDO"
  cQuery += "   INNER JOIN " + RetSqlName("SB1") + " SB1"
  cQuery += "         ON SB1.D_E_L_E_T_ = ' '"
  cQuery += "         AND  '" + xFilial("SB1") + "' = B1_FILIAL AND D2_COD = B1_COD "
  cQuery += "   LEFT JOIN " + RetSqlName("Z24") + " Z24"
  cQuery += "         ON Z24.D_E_L_E_T_ = ' '"
  cQuery += "        and '" + xFilial("Z24") + "' = Z24_FILIAL AND D2_XOPER = Z24_OPERA AND Z24_TPMOV = 'S' "
  cQuery += "  Where SD2.D_E_L_E_T_ = ' '"
  cQuery += "    and SD2.D2_FILIAL  = '" + SF2->F2_FILIAL + "'"
  cQuery += "    and SD2.D2_DOC     = '" + SF2->F2_DOC + "'"
  cQuery += "    and SD2.D2_SERIE   = '" + SF2->F2_SERIE + "'"
  cQuery += "    and SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "'"
  cQuery += "    and SD2.D2_LOJA    = '" + SF2->F2_LOJA + "'"
  cQuery += " ORDER BY RECNO "
  //cQuery := ChangeQuery(cQuery)

  //dbUseArea(.T.,"TopConn",TCGenQry(,,cQuery),"QITEM",.F.,.T.)

  TCQUERY (cQuery) NEW ALIAS "QITEM"

  QITEM->(DbGoTop())

  IF QITEM->RECNO > 0
    DbSelectArea("QITEM")
    QITEM->(DbGoTop())
  ENDIF

  // Query que Verifica se vai gerar comissao indireta
  cSqlInd := " SELECT F2_FILIAL,F2_CLIENTE,F2_DOC,F2_SERIE,F2_VEND1,A3_NOME,A3_TIPO,A1_VEND AS CLIVEN,F2_EMISSAO,TO_CHAR(TO_DATE(F2_EMISSAO,'YYYYMMDD')-"+Str(cDias)+",'YYYYMMDD') AS DTCOMIND "
  cSqlInd += " FROM " + RetSqlName("SF2") + " A "
  cSqlInd += " INNER JOIN " + RetSqlName("SA1") + " B ON F2_CLIENTE = A1_COD AND B.D_E_L_E_T_ = ' ' "
  cSqlInd += " INNER JOIN " + RetSqlName("SA3") + " C ON F2_VEND1 = A3_COD AND C.D_E_L_E_T_ = ' ' "
  cSqlInd += " WHERE A.D_E_L_E_T_ = ' ' AND F2_FILIAL = '" + SF2->F2_FILIAL + "' AND F2_DOC = '" + SF2->F2_DOC + "' AND  "
  cSqlInd += " F2_SERIE = '" + SF2->F2_SERIE + "' AND F2_CLIENTE = '" + SF2->F2_CLIENTE + "' "


  TCQUERY (cSqlInd) NEW ALIAS "TRBCOM"

  // Teste para qual margem vai ser usada para calcular a comissao direta
  IF TRBCOM->A3_TIPO == 'E'
    cMargem := " ZZI_MARREP"
  ELSE
    cMargem := " ZZI_MARVEN"
  ENDIF

  IF TRBCOM->F2_VEND1 <> TRBCOM->CLIVEN .AND. TRBCOM->A3_TIPO == 'I'

    cTpVencli := POSICIONE("SA3",1,XFILIAL("SA3")+TRBCOM->CLIVEN,"A3_TIPO")

    IF cTpVencli == 'E'
      //Verifico se existe notas
      cSql2 := " SELECT COUNT(*) AS QTDNF "
      cSql2 += " FROM " + RetSqlName("SF2") + " A "
      cSql2 += " INNER JOIN " + RetSqlName("SD2") + " B ON F2_FILIAL = D2_FILIAL AND "
      cSql2 += " F2_CLIENTE = D2_CLIENTE AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND D2_ITEM = '01' AND B.D_E_L_E_T_ = ' ' "
      cSql2 += " WHERE F2_FILIAL = '" + SF2->F2_FILIAL + "' AND F2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND F2_VEND1 = '"+TRBCOM->CLIVEN+"'  "
      cSql2 += " AND F2_EMISSAO BETWEEN '"+TRBCOM->DTCOMIND+"' AND '"+TRBCOM->F2_EMISSAO+"' "
      cSql2 += " AND D2_XOPER = '01' AND A.D_E_L_E_T_ = ' ' "

      TCQUERY (cSql2) NEW ALIAS "TRBIND"

      IF TRBIND->QTDNF > 0

        nPerInd := GETMV("AN_PERCIND") // Paramentro do Percentual da Comissao Indireta

      ENDIF

      TRBIND->(dbCloseArea())

    ENDIF

  ENDIF

  While ! QITEM->(Eof())
    // --- Gravar o percentual da comissão do item
    // -------------------------------------------
    dbSelectArea("SD2")
    SD2->(dbGoto(QITEM->RECNO))

    IF TRBCOM->A3_TIPO <> 'I'
        Reclock("SD2",.F.)
        Replace SD2->D2_XPRCOM1 with (SC5->C5_COMIS1 * QITEM->&(cMargem))
        Replace SD2->D2_XPRCOM2 with (nPerInd * QITEM->&(cMargem))
        SD2->(MsUnlock())
    ELSE
        Reclock("SD2",.F.)
        Replace SD2->D2_XPRCOM1 with SC5->C5_COMIS1
        Replace SD2->D2_XPRCOM2 with (nPerInd * QITEM->&(cMargem))
        SD2->(MsUnlock())

    ENDIF    
    // -------------------------------------------

    //nVlCom += (QITEM->D2_TOTAL * (SC5->C5_COMIS1 * QITEM->&(cMargem))) / 100
    
    //26/07/2021
    //JJS-Jubirajara - Acertos na base,no valor do pis/cofins e impacto no Custo de Saida- Sem Chamado
    UpdPis()
    QITEM->(dbSkip())
  EndDo

  Reclock("SF2",.F.)
  Replace SF2->F2_VEND2 with TRBCOM->CLIVEN
  SF2->(MsUnlock())


  If nVlCom > 0

    Reclock("SE3",.F.)
    Replace SE3->E3_COMIS with nVlCom
    SE3->(MsUnlock())

    // --- Atualizar Comissão
    // ----------------------
              /*
              dbSelectArea("ZZP")
              ZZP->(dbSetOrder(1))
              
    If ZZP->(dbSeek(xFilial("ZZP") + SA3->A3_COD + Substr(DToS(dDataBase),5,2) + Substr(DToS(dDataBase),1,4)))
                  lZZP := .F.
    else
                  lZZP := .T.  
    EndIf
              
              Reclock("ZZP",lZZP)
    If lZZP
                    Replace ZZP->ZZP_FILIAL with xFilial("ZZP")
                    Replace ZZP->ZZP_VEND   with SA3->A3_COD
                    Replace ZZP->ZZP_MMAAAA with Substr(DToS(dDataBase),5,2) + Substr(DToS(dDataBase),1,4)
                    Replace ZZP->ZZP_VLCOMD with nVlCom
    else
                    Replace ZZP->ZZP_VLCOMD with (ZZP->ZZP_VLCOMD + nVlCom)
    EndIf
              ZZP->(MsUnlock())
              // ----------------------
              */ 
  EndIf

  QITEM->(dbCloseArea())
  TRBCOM->(dbCloseArea())

  RestArea(aArea)
Return

/* JJS-27/07/21
Partindo da Solicitação de Tereza O.S 12130 (Email de 7 de jul. de 2021 16:29 ,Asunto: 	Re: PIS/COFINS - ajustes no relatório/cálculo)
esse ponto de entrada acerta base,valor pis e cofins e o custo após geração da NFe
Sendo assim, só deveremos subtrair o ICMS NORMAL da BC do PIS/COFINS quando 'CREDITA ICMS = SIM' +:
GRUPO TRIB PROD = 025,065,088,089,090,091 nas filiais = 020101 (MTZ) ou 020105 (RN)
GRUPO TRIB PROD = 150,180,315,365, 660,680,665,685 em qualquer filial.
*/
static function UpdPis()

local cTes :=SD2->D2_TES
local nVlBase := 0
//Conta contabil por Operação 
local cConta      := QITEM->Z24_CONTA
//
//posicionamentos
  dbSelectArea("SF4")
  SF4->(DbSeek(xFilial("SF4")+QITEM->D2_TES))

  //Se posiciona da Tabela SFT para altera-la juntamente com a SD2    
  dbselectarea("SFT")
  SFT->(dbSetOrder(1))

  If SFT->(dbSeek(xFilial("SFT")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+"  "+SD2->D2_COD))
    lSubICMNor := .F.
    if ALLTRIM(SD2->D2_FILIAL)$ "020101,020105" //Matriz ou RN
        if ALLTRIM(QITEM->B1_GRTRIB)$ "025,065,088,089,090,091"
            lSubICMNor :=.T.
        ENDIF
    ENDIF
    IF ALLTRIM(QITEM->B1_GRTRIB)$ "150,180,315,365,660,680,665,685" //<=Apesar da condição abaixo  QITEM->B1_GRTRIB <= '099' Estes Grupos já são atendidos pois não ab
            lSubICMNor :=.T.
    ENDIF            

    IF SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_CREDICM == 'S' //.AND. SD2->D2_FILIAL <> '020108' //.AND.  QITEM->B1_GRTRIB <= '099'

        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE-iif(lSubICMNor,SD2->D2_VALICM,0)

    ElseIf SF4->F4_DESPCOF == '1' .AND. SF4->F4_DESPPIS == '1' .AND. SF4->F4_CREDIPI == 'S' .AND. SF4->F4_CREDICM == 'S' //.AND. SD2->D2_FILIAL <> '020108' //.AND.  QITEM->B1_GRTRIB <= '099'

        nVlBase := SD2->D2_TOTAL+SD2->D2_DESPESA+SD2->D2_VALFRE+SD2->D2_VALIPI-iif(lSubICMNor,SD2->D2_VALICM,0)

    ElseIf SF4->F4_DESPCOF == '2' .AND. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' .AND. SF4->F4_CREDICM == 'S' //.AND. SD2->D2_FILIAL <> '020108' //.AND.  QITEM->B1_GRTRIB <= '099'

        nVlBase := SD2->D2_TOTAL+SD2->D2_VALIPI-iif(lSubICMNor,SD2->D2_VALICM,0)

    ElseIf SF4->F4_DESPCOF == '2' .AND. SF4->F4_DESPPIS == '2' .AND. SF4->F4_CREDIPI == 'N' 

        nVlBase := SD2->D2_TOTAL+SD2->D2_VALIPI

    Else

        nVlBase := SD2->D2_TOTAL   

    EndIF

  Endif
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
  If SF4->F4_PISCRED $ "1%2" 

      SD2->(Reclock("SD2", .F.))
          //Soma ao Custo o Pis/Cofins que o sistema tirou
          //SD2->D2_CUSTO1  := SD2->D2_CUSTO1 + ( SD2->D2_VALIMP5 + SD2->D2_VALIMP6 )
        //  SD2->D2_TES     := cTes
          SD2->D2_ALQIMP6 := 1.65
          SD2->D2_BASIMP6 := nVlBase
          SD2->D2_VALIMP6 := nVlBase*(1.65/100)
          SD2->D2_ALQIMP5 := 7.6
          SD2->D2_BASIMP5 := nVlBase
          SD2->D2_VALIMP5 := nVlBase*(7.6/100)
          SD2->D2_CONTA   := ALLTRIM(cConta)
          //Retira do Custo o novo Pis/Cofins calculado    
          //SD2->D2_CUSTO1  := SD2->D2_CUSTO1 - ROUND( ( (nVlBase*(1.65/100)) + (nVlBase*(7.6/100)) ) ,2)
        //SD2->D2_VALBRUT := nValBrut
      SD2->(MsUnlock())

      SFT->(Reclock("SFT",.F.))
         // SFT->FT_TES     := cTes
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
        //  SD2->D2_TES     := cTes
          SD2->D2_ALQIMP6 := 0
          SD2->D2_BASIMP6 := nVlBase
          SD2->D2_VALIMP6 := 0
          SD2->D2_ALQIMP5 := 0
          SD2->D2_BASIMP5 := nVlBase
          SD2->D2_VALIMP5 := 0
          SD2->D2_CONTA   := ALLTRIM(cConta)
      SD2->(MsUnlock())

      
      SFT->(Reclock("SFT",.F.))
        //  SFT->FT_TES     := cTes
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
      //  SD2->D2_TES     := cTes
        SD2->D2_ALQIMP6 := 0
        SD2->D2_BASIMP6 := 0
        SD2->D2_VALIMP6 := 0
        SD2->D2_ALQIMP5 := 0
        SD2->D2_BASIMP5 := 0
        SD2->D2_VALIMP5 := 0 
        SD2->D2_CONTA   := ALLTRIM(cConta)                   
      SD2->(MsUnlock())
      
      SFT->(Reclock("SFT",.F.))
       // SFT->FT_TES     := cTes
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

  EndIf

return
