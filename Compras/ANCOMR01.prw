#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ A M Paulo Tecnologia ME                                    													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ANCOMR01	 ³ Autor ³ Andre Minelli        ³ Data 24/04/2021  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime relatorio de Pedido de Compras                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Auto Norte                                           															  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ANCOMR01

Private oPedido
Private nLin        := 10
Private aCol	  	:= {10,100,150,300,580}
Private nPag        := 0
Private aRet        := {Space(6),Space(6),CTOD(""),CTOD(""),CTOD(""),CTOD(""),{"1-Em aberto Parcial","2-Em aberto Total","3-Atendido/Encerrado Total","4-Todos"},Space(6)}
Private cEmpresas   := ""
Private cEmprCab    := ""
Private aEmpresas   := {""}
Private cFonte   	:= "Arial"

nRet := CpyT2S( "C:\TEMP\LOGOAUTO.BMP", "\SYSTEM" )

If !ParamBox({	{1,"Filial De"      	    ,aRet[1],"","","","",40,.F.},;
                {1,"Filial Ate"     	    ,aRet[2],"","","","",40,.F.},;
                {1,"Emissao Ped Inici"	    ,aRet[3],"","","","",60,.F.},;
                {1,"Emissao Ped Final"      ,aRet[4],"","","","",60,.F.},;
                {1,"Dt Faturamento Inici"   ,aRet[5],"","","","",60,.F.},;
				{1,"Dt Faturamento Final"   ,aRet[6],"","","","",60,.F.},;
				{2,"Situacao Pedido"        ,aRet[7],{"1-Em Aberto Parcial","2-Em Aberto Total","3-Atendido/Encerrado Total","4-Todos"},90,"",.T.},;
                {1,"Fornecedor"             ,aRet[8],"","","SA2","",60,.F.}},"Relatorio Pedido de Compras", @aRet,,,,,,,,.T.,.T. )
	Return
End If

FWMsgRun(, {|oSay| U_ANCOMR02() }, "Imprimindo", "Gerando Relatório...")

Return

User Function ANCOMR02()

Local cDirGer 		:= GetTempPath()
Local nLimite       := 770
Local cFornAnt      := ""
Local cMarcaAnt     := ""
Local nTotPed       := 0
Local nTotFat       := 0
Local nTotAbe       := 0
Local nTotPedG      := 0
Local nTotFatG      := 0
Local nTotAbeG      := 0
Local cMarca        := ""

cEmprCab  := aRet[1] + " - " + aRet[2]

oPedido:=FWMSPrinter():New("Pedido_Compras",6,.F.,,.T.,,,,,,,.F.)
oPedido:SetPortrait()

oPedido:cPathPDF := cDirGer

ImpCab()

nLin += 12
cQuery := "SELECT MARCA,FORNECE,LOJA,PEDIDO,FILIAL,EMISSAO,MAX(NUM_NF) NUM_NF,MAX(DATA_FAT) DATA_FAT,"
cQuery += "SUM(TOTAL_PED) TOTAL_PED,SUM(TOTAL_FAT) TOTAL_FAT,SUM(QUANT_PED) QUANT_PED,"
cQuery += "SUM(QUANT_ENT) QUANT_ENT, SUM(TOT_ABE) TOT_ABE FROM (
cQuery += "(
cQuery += "select "
cQuery += "B1_XMARCA as MARCA, "
cQuery += "C7_FORNECE as FORNECE, "
cQuery += "C7_LOJA as LOJA, "
cQuery += "C7_NUM as PEDIDO, "
cQuery += "C7_FILIAL as FILIAL, "
cQuery += "C7_PRODUTO as PRODUTO, "
cQuery += "C7_ITEM as ITEM, "
cQuery += "C7_EMISSAO as EMISSAO, "
cQuery += "Isnull(MAX(D1_DOC),'') as NUM_NF, "
cQuery += "Isnull(MAX(D1_EMISSAO),'') as DATA_FAT, "
cQuery += "(SELECT SUM(C7T.C7_TOTAL) FROM " + RetSqlName("SC7") + " C7T WHERE C7T.D_E_L_E_T_ = '' AND C7T.C7_FILIAL = C7.C7_FILIAL AND C7T.C7_NUM = C7.C7_NUM AND C7T.C7_ITEM = C7.C7_ITEM) as TOTAL_PED, "
cQuery += "Isnull(SUM(D1_TOTAL),0) as TOTAL_FAT, "
cQuery += "(SELECT SUM(C7T.C7_QUANT) FROM " + RetSqlName("SC7") + " C7T WHERE C7T.D_E_L_E_T_ = '' AND C7T.C7_FILIAL = C7.C7_FILIAL AND C7T.C7_NUM = C7.C7_NUM AND C7T.C7_ITEM = C7.C7_ITEM) as QUANT_PED, " 
cQuery += "(SELECT SUM(C7T.C7_QUJE) FROM " + RetSqlName("SC7") + " C7T WHERE C7T.D_E_L_E_T_ = '' AND C7T.C7_FILIAL = C7.C7_FILIAL AND C7T.C7_NUM = C7.C7_NUM AND C7T.C7_ITEM = C7.C7_ITEM) as QUANT_ENT, "
cQuery += "(SELECT SUM((C7T.C7_QUANT-C7T.C7_QUJE)*C7T.C7_PRECO) FROM " + RetSqlName("SC7") + " C7T WHERE C7T.D_E_L_E_T_ = '' AND C7T.C7_FILIAL = C7.C7_FILIAL AND C7T.C7_NUM = C7.C7_NUM AND C7T.C7_ITEM = C7.C7_ITEM) as TOT_ABE "
cQuery += "FROM " + RetSqlName("SC7") + " C7 "
cQuery += "LEFT JOIN " + RetSqlName("ZZS") + " ZZS ON "
cQuery += "ZZS.D_E_L_E_T_ = '' and ZZS_FILIAL = C7_FILIAL and ZZS_PEDIDO = C7_NUM and ZZS_ITEPED = C7_ITEM and ZZS_FORPED = C7_FORNECE and ZZS_LOJAPC = C7_LOJA "
cQuery += "LEFT JOIN " + RetSqlName("SD1") + " D1 ON "
cQuery += "D1.D_E_L_E_T_ = '' and D1_FILIAL = ZZS_FILIAL and D1_DOC = ZZS_DOC and D1_SERIE = ZZS_SERIE and D1_FORNECE = ZZS_FORNEC and D1_LOJA = ZZS_LOJANF AND D1_ITEM = ZZS_ITEMNF "
cQuery += "JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = C7_PRODUTO AND B1.D_E_L_E_T_ = '' "

cQuery += "WHERE C7_FILIAL between '" + aRet[1] + "' AND '" + aRet[2] + "' "

If !Empty(aRet[3]) .Or. !Empty(aRet[4])
    cQuery += " AND C7_EMISSAO between '" + DTOS(aRet[3]) + "' AND '" + DTOS(aRet[4]) + "' "
End If

If !Empty(aRet[8])
    cQuery += "AND C7_FORNECE = '" + aRet[8] + "' "
End If
If Left(aRet[7],1) == "1" //Em aberto Parcial
    cQuery += "AND C7_QUJE < C7_QUANT AND C7_QUJE > 0 AND D1_DOC IS NOT NULL "
ElseIf Left(aRet[7],1) == "2" //Em aberto Total
    cQuery += "AND C7_QUJE = 0 AND D1_DOC IS NULL "
ElseIf Left(aRet[7],1) == "3" //Atendido/Encerrado Total
    cQuery += "AND C7_QUJE = C7_QUANT AND D1_DOC IS NOT NULL "
End If
cQuery += "AND C7_RESIDUO = '' AND C7.D_E_L_E_T_ = '' "

If !Empty(aRet[5]) .Or. !Empty(aRet[6])
    cQuery += " AND D1_EMISSAO between '" + DTOS(aRet[5]) + "' and '" + DTOS(aRet[6]) + "' AND D1_DOC IS NOT NULL "
End If

cQuery += "GROUP BY B1_XMARCA,C7_FORNECE, C7_LOJA, C7_NUM, C7_FILIAL, C7_EMISSAO,C7_PRODUTO, C7_ITEM )) TAB01 "
cQuery += "GROUP BY MARCA,FORNECE,LOJA,PEDIDO,FILIAL,EMISSAO ORDER BY MARCA "

cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SQLSC7",.T.,.T.)

While SQLSC7->(!EOF())

    If SA2->(DbSetOrder(1),DbSeek(xFilial("SA2") + SQLSC7->(FORNECE + LOJA) ))

        If cMarcaAnt <> SQLSC7->MARCA .And. Empty(cMarcaAnt)

            oPedido:SetFontEX(12,cFonte,.F.,.T.,.T.)
            oPedido:Say(nLin+10,aCol[1]+5       ,alltrim(SQLSC7->MARCA))

        End If

        If cMarcaAnt <> SQLSC7->MARCA .And. !Empty(cMarcaAnt)

            nLin += 12
            oPedido:SetFontEX(12,cFonte,.F.,.T.,.T.)
            oPedido:Line(nLin,aCol[1]+5,nLin,aCol[5]-5)
            nLin += 5
            oPedido:Say(nLin+10,aCol[1]+5       ,"Total por Fornecedor:")
            oPedido:SetFontEX(12,cFonte,.F.,.T.,.F.)

            oPedido:SayAlign( nLin,aCol[4]+32  ,alltrim(Transform(nTotPed,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
            oPedido:SayAlign( nLin,aCol[4]+105 ,alltrim(Transform(nTotFat,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
            oPedido:SayAlign( nLin,aCol[5]-70  ,alltrim(Transform(nTotAbe,"@E 999,999,999.99")),,60, 12, , 1, 2 ) 

            nTotPed := 0
            nTotFat := 0
            nTotAbe := 0

            nLin += 18
            oPedido:SetFontEX(12,cFonte,.F.,.T.,.T.)
                       
            oPedido:Say(nLin+10,aCol[1]+5     ,alltrim(SQLSC7->MARCA))

        End If

        oPedido:SetFontEX(12,cFonte,.F.,.F.,.F.)

        nLin += 13

        oPedido:Say(nLin+10,aCol[1]+20      ,SQLSC7->PEDIDO)
        oPedido:Say(nLin+10,aCol[2]         ,STRZERO(VAL(Substr(SQLSC7->FILIAL,5,2)),3) )
        oPedido:Say(nLin+10,aCol[3]-10      ,DTOC(STOD(SQLSC7->EMISSAO)) )
        oPedido:Say(nLin+10,aCol[3]+75      ,"C")
        oPedido:Say(nLin+10,aCol[3]+110     ,DTOC(STOD(SQLSC7->DATA_FAT)) )

        oPedido:SayAlign( nLin,aCol[4]+32  ,alltrim(Transform(SQLSC7->TOTAL_PED,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
        oPedido:SayAlign( nLin,aCol[4]+105 ,alltrim(Transform(SQLSC7->TOTAL_FAT,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
        oPedido:SayAlign( nLin,aCol[5]-70  ,alltrim(Transform(SQLSC7->TOT_ABE,  "@E 999,999,999.99")),,60, 12, , 1, 2 ) 

        nTotPed += SQLSC7->TOTAL_PED
        nTotFat += SQLSC7->TOTAL_FAT
        nTotAbe += SQLSC7->TOT_ABE

        nTotPedG += SQLSC7->TOTAL_PED
        nTotFatG += SQLSC7->TOTAL_FAT
        nTotAbeG += SQLSC7->TOT_ABE
    
    End If

    cFornAnt  := SQLSC7->(FORNECE + LOJA)
    cMarcaAnt := SQLSC7->MARCA

    SQLSC7->(DbSkip())

    If nLin >= nLimite
        nLin := 10
        oPedido:EndPage()
        ImpCab()
    End If

End

SQLSC7->(DbCloseArea())

If !Empty(cFornAnt)
    nLin += 12
    oPedido:SetFontEX(12,cFonte,.F.,.T.,.T.)
    oPedido:Line(nLin,aCol[1]+5,nLin,aCol[5]-5)
    nLin += 12
    oPedido:Say(nLin+10,aCol[1]+5       ,"Total por Fornecedor:")
    oPedido:SetFontEX(12,cFonte,.F.,.T.,.F.)

    oPedido:SayAlign( nLin,aCol[4]+32  ,alltrim(Transform(nTotPed,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
    oPedido:SayAlign( nLin,aCol[4]+105 ,alltrim(Transform(nTotFat,"@E 999,999,999.99")),,60, 10, , 1, 2 ) 
    oPedido:SayAlign( nLin,aCol[5]-70  ,alltrim(Transform(nTotAbe,"@E 999,999,999.99")),,60, 12, , 1, 2 ) 

    nLin += 15

    oPedido:SetFontEX(12,cFonte,.F.,.T.,.T.)
    oPedido:Say(nLin+10,aCol[1]+5       ,"Total Geral:")
    oPedido:SetFontEX(12,cFonte,.F.,.T.,.F.)

    oPedido:SayAlign( nLin,aCol[4]+12  ,alltrim(Transform(nTotPedG,"@E 999,999,999.99")),,80, 10, , 1, 2 ) 
    oPedido:SayAlign( nLin,aCol[4]+85  ,alltrim(Transform(nTotFatG,"@E 999,999,999.99")),,80, 10, , 1, 2 ) 
    oPedido:SayAlign( nLin,aCol[5]-90  ,alltrim(Transform(nTotAbeG,"@E 999,999,999.99")),,80, 12, , 1, 2 ) 

End If

oPedido:EndPage()

oPedido:Print()
ShellExecute("open",cDirGer+"Pedido_Compras.pdf","","",5)

Return

//Imprime Cabeçalho
Static Function ImpCab()

Local cSituacao := Substr(aRet[7],3,25)

oPedido:StartPage()

nPag++

oPedido:Box(nLin,aCol[1],nLin + 820, aCol[5],"-2")

oPedido:SetFontEX(14,cFonte,.F.,.T.,.F.)

oPedido:SayBitmap(nLin+2,aCol[1]+5,"logoauto.bmp",185,50)

oPedido:Say(nLin+15,aCol[4]-35  ,"Relatório Pedidos ao")
oPedido:Say(nLin+30,aCol[4]-15	,"Fornecedor - ")
oPedido:Say(nLin+45,aCol[4]-35  ,"Fornecedor e Número")

oPedido:SetFontEX(10,cFonte,.F.,.F.,.F.)

oPedido:SayAlign( nLin+3,aCol[5]-36  ,"Pag " + alltrim(cValToChar(nPag)),,30, 12, , 1, 2 ) 
oPedido:Say(nLin+20,aCol[5]-98  ,"Data Emissão: " + DTOC(dDatabase))

nLin := 65

oPedido:SetFontEX(10,cFonte,.F.,.T.,.F.)
If !Empty(aRet[3]) .Or. !Empty(aRet[4])
    oPedido:Say(nLin+10,aCol[1]+5    ,"Período Emissão: " + DTOC(aRet[3]) + " - " + DTOC(aRet[4]))
Else
    oPedido:Say(nLin+10,aCol[1]+5    ,"Período Emissão: Não Utilizado!")
End If
nLin += 13
If !Empty(aRet[5]) .Or. !Empty(aRet[6])
    oPedido:Say(nLin+10,aCol[1]+5    ,"Período Faturamento: " + DTOC(aRet[5]) + " - " + DTOC(aRet[6]))
Else
    oPedido:Say(nLin+10,aCol[1]+5    ,"Período Faturamento: Não Utilizado!")
End If
nLin += 13
oPedido:Say(nLin+10,aCol[1]+5    ,"Empresas: " + cEmprCab)
nLin += 13
oPedido:Say(nLin+10,aCol[1]+5    ,"Situacao do Pedido: " + cSituacao)

nLin += 15
oPedido:Line(nLin,aCol[1]+5,nLin,aCol[5]-5)

nLin += 10
oPedido:SetFontEX(13,cFonte,.F.,.T.,.T.)
oPedido:Say(nLin+10,aCol[1]+5       ,"Fornec: ")

nLin += 15
oPedido:Say(nLin+10,aCol[1]+20      ,"Numero")
oPedido:Say(nLin+10,aCol[2]         ,"Emp")
oPedido:Say(nLin+10,aCol[3]-10      ,"Data do Pedido")
oPedido:Say(nLin+10,aCol[3]+75      ,"TP")
oPedido:Say(nLin+10,aCol[3]+110     ,"Data de Fat")
oPedido:Say(nLin+10,aCol[4]+40      ,"Valor Total")
oPedido:Say(nLin+10,aCol[4]+120     ,"Valor Fat.")
oPedido:Say(nLin+10,aCol[5]-70      ,"Valor Aberto")

nLin += 15
oPedido:Line(nLin,aCol[1],nLin,aCol[5])

Return
