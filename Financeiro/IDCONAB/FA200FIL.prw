#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include 'fileio.ch'
#INCLUDE "TOPCONN.CH"

User Function FA200FIL()
    Local aMsgSch   := {}
    Local aRecIgual := {}
    Local aTabela 	:= {}
    Local nRec      := 0
    Local nPos      := 0
    Local lUmHelp 	:= .F.
    Local lHelp     := .F.
    Local lAchouTit	:= .F.
    Local nTamPre	:= TamSX3("E1_PREFIXO")[1]
    Local nTamNum	:= TamSX3("E1_NUM")[1]
    Local nTamPar	:= TamSX3("E1_PARCELA")[1]
    Local nTamTit	:= nTamPre+nTamNum+nTamPar
    Local cTabela   := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )
    Local aArq      := Separa(MV_PAR04,"\")
    Local cNomeArq  := AllTrim(StrTran(aArq[Len(aArq)],".RET"))
    Local cArqLog   := "M:\DEPTOS\Contas a Receber\Contas a Receber\Arquivos CNAB Cobranca\Retorno\LOGs\"+cNomeArq+"_log.csv"
    Local nCount    := 0
    Local aAreaSE1  := SE1->(GetArea())


    dbSelectArea( "SX5" )
    If SX5->( dbSeek( cFilial + cTabela ) )
        While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
            AADD(aTabela,{Alltrim(X5Descri()),AllTrim(SX5->X5_CHAVE)})
            SX5->(dbSkip())
        Enddo
    EndIf

    If mv_par13 == 2
        //Busca por IdCnab (sem filial)
        SE1->(dbSetOrder(19)) // IdCnab
        If SE1->(MsSeek(Substr(cNumTit,1,10)))
            While !SE1->(EOF()) .AND. Alltrim(Substr(cNumTit,1,10)) == AllTrim(SE1->E1_IDCNAB)
                lAchouTit := .T.
                cFilAnt	:= SE1->E1_FILIAL
                mv_par11 := 2  //Desligo contabilizacao on-line
                //Idcnab duplicado
                AADD( aRecIgual, {SE1->(Recno()),;
                    'ID_CNAB',;
                    SE1->E1_IDCNAB,;
                    SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                    IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )

                SE1->(dbskip())
            Enddo
        Endif
    Else
        //Busca por IdCnab
        SE1->(dbSetOrder(16)) // Filial+IdCnab
        If SE1->(MsSeek(xFilial("SE1")+Substr(cNumTit,1,10)))
            lAchouTit := .T.
            While !SE1->(EOF()) .AND. xFilial("SE1")+Substr(cNumTit,1,10) == Alltrim(SE1->E1_FILIAL+SE1->E1_IDCNAB)
                cFilAnt	:= SE1->E1_FILIAL
                mv_par11 := 2  //Desligo contabilizacao on-line
                //Idcnab duplicado
                AADD( aRecIgual, {SE1->(Recno()),;
                    'FILIAL + ID_CNAB',;
                    SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                    SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                    IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )

                SE1->(dbskip())
            Enddo
        EndIf
    Endif

    //Se nao achou, utiliza metodo antigo (titulo)
    If !lAchouTit//SE1->(!Found())
        SE1->(dbSetOrder(1))
        // Busca por chave antiga como retornado pelo banco
        If dbSeek(xFilial("SE1")+PadR(cNumTit,nTamTit)+cEspecie)
            lAchouTit := .T.
            nPos   := 1
            AADD( aRecIgual, {SE1->(Recno()),;
                'FILIAL + PREF + NUM TIT + PARCELA + ESPECIE',;
                SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )
        Endif

        While !lAchouTit
            // Busca por chave antiga
            dbSetOrder(1)
            If !dbSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
                nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
                If nPos != 0
                    cEspecie := aTabela[nPos][2]
                Else
                    Exit
                Endif
            Else
                lAchouTit := .T.
                AADD( aRecIgual, {SE1->(Recno()),;
                    'FILIAL + PREF + NUM TIT + PARCELA + ESPECIE',;
                    SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                    SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                    IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )
            Endif
        Enddo

        If !lAchouTit
            // Busca por chave antiga adaptada para o tamanho de 9 posicoes para numero de NF
            // Isto ocorre quando titulo foi enviado com 6 posicoes para numero de NF e retornou com o
            // campo ja atualizado para 9 posicoes
            cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumtit,4,6),nTamNum)+SubStr(cNumTit,10,nTamPar)
            If !Empty(cNumTit) .And. dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit))
                cEspecie := SE1->E1_TIPO
                lAchouTit := .T.
                nPos   := 1
                AADD( aRecIgual, {SE1->(Recno()),;
                    'FILIAL + PREF + NUM TIT + PARCELA',;
                    SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                    SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                    IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB)) } )
            Endif


            While !lAchouTit
                // Busca por chave antiga
                dbSetOrder(1)
                If !dbSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
                    nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
                    If nPos != 0
                        cEspecie := aTabela[nPos][2]
                    Else
                        Exit
                    Endif
                Else
                    lAchouTit := .T.
                    AADD( aRecIgual, {SE1->(Recno()),;
                        'FILIAL + PREF + NUM TIT + PARCELA + ESPECIE',;
                        SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                        SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                        IIF(Alltrim(cOcorr) == '02',.T.,Alltrim(SE1->E1_NUMBCO) == cNsNum .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB)) } )
                Endif
            Enddo
        Endif
    Else
        nPos := 1
    Endif

    //Busca por nosso numero
    //29/01/2020
    If !lAchouTit
        cQuery := " SELECT R_E_C_N_O_ RECNO FROM " + Retsqlname("SE1")
        cQuery += " WHERE D_E_L_E_T_ = ' ' "
        If cBanco == "422"
            cQuery += " AND SUBSTR(E1_NUMBCO,1,9) = '"+cNsNum+"' "
        elseif cBanco = "341" // Tratamento do Banco Itau
		    cQuery += " AND SUBSTR(E1_NUMBCO,1,8) = '"+SubStr(cNsNum,1,8)+"' "
        Else
            cQuery += " AND E1_NUMBCO = '"+cNsNum+"' "
        EndIf

        cQuery := ChangeQuery(cQuery)

        TCQUERY cQuery NEW ALIAS "QSE1"

        While !QSE1->(EOF())
            dbSelectArea("SE1")

            //posiciona no recno encontrado
            SE1->(dbGoTo(QSE1->RECNO))
            lAchouTit := .T.
     
            AADD( aRecIgual, {SE1->(Recno()),;
                'FILIAL + PREF + NUM TIT + PARCELA + ESPECIE',;
                SE1->E1_FILIAL+SE1->E1_IDCNAB ,;
                SE1->(E1_FILIAL+'  '+E1_PREFIXO+'  '+E1_NUM+'  '+E1_PARCELA+'  '+E1_TIPO),;
                IIF(Alltrim(cOcorr) == '02',.T.,IIF(cBanco == "422",SubStr(SE1->E1_NUMBCO,1,9) == cNsNum,IIF(cBanco == "341",ALLTRIM(SubStr(SE1->E1_NUMBCO,1,8)) == ALLTRIM(SubStr(cNsNum,1,8)),Alltrim(SE1->E1_NUMBCO) == cNsNum)) .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )
                //IIF(Alltrim(cOcorr) == '02',.T.,IIF(cBanco == "422",SubStr(SE1->E1_NUMBCO,1,9) == cNsNum,Alltrim(SE1->E1_NUMBCO) == cNsNum) .OR. Substr(cNumTit,1,10) == AllTrim(SE1->E1_IDCNAB) ) } )

            QSE1->(dbSkip())
        EndDo

        QSE1->(dbCloseArea())

    Endif

    nQtdRec := 0

    For nX:=1 to len(aRecIgual)
        If aRecIgual[nX,5]
            nQtdRec ++
        Endif
    Next nX

    If Len(aRecIgual) > 1
        If FILE(cArqLog)
            cMens := ""
            nHandle := fopen(cArqLog, FO_READWRITE + FO_SHARED )
        Else
            nHandle := FCREATE(cArqLog)
            cMens := "RECNO" + ';' + "CHAVE CONSULTADA" + ';' + "FILIAL + IDCNAB" + ';' + "CHAVE TITULO" + ';' + "NOSSO NUMERO IGUAL?" + Chr(13) + Chr(10)
        EndIf

        For nX := 1 to Len(aRecIgual)
            cMens += cValToChar(aRecIgual[nX][1]) + ';' + aRecIgual[nX][2] + ';' + aRecIgual[nX][3] + ';' + aRecIgual[nX][4] + ';' + IIF(aRecIgual[nX][5],"SIM","NÃO") + Chr(13) + Chr(10)
        Next nX

        If !Empty(cMens)
            FWrite(nHandle, cMens)
            FClose(nHandle)
        EndIf
    EndIf

    nPos := 0

    If nQtdRec == 1
        nRec := aRecIgual[aScan(aRecIgual,{|x| x[5] == .T. })][1]
        dbSelectArea("SE1")
        SE1->(dbGoTo(nRec))

        nPos := 1
    Else
        SE1->(dbGoBottom())
        SE1->(dbSkip())
    EndIf

    If nPos == 0
        lHelp := .T.
    EndIF
    If !lUmHelp .And. lHelp
        Help(" ",1,"NOESPECIE",,cNumTit+" "+cEspecie,5,1)
        lUmHelp := .T.

        // Retorno Automatico via Job
        if lExecJob
            Aadd(aMsgSch, "Especie "+cEspecie+" nao localizada para o titulo "+cNumTit)
        Endif
    Endif
    //Se achar o título e o vencimento estiver diferente do último ajustado, corrige o vencimento
    If lAchouTit
        If SE1->E1_XULTVEN <> SE1->E1_VENCTO .and. !Empty(SE1->E1_XULTVEN)
            dVencto := SE1->E1_XULTVEN

            Reclock("SE1",.F.)
            SE1->E1_VENCTO  := dVencto
            SE1->E1_VENCREA := DataValida(dVencto, .T.)
            SE1->(MsUnlock())
        EndIf
    Else
        RestArea(aAreaSE1)
    EndIf
    
Return
