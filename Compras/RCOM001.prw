#INCLUDE "Topconn.ch"
#include "protheus.ch"
#include "parmtype.ch"
/*
Financeiro
Autor: Jubirajara|Data: 16/11/2020
Relatorio conferência de Custo
*/
User Function RCOM001
    Private oReport :=Nil
    Private oSecCab :=Nil
    Private cPerg   := Padr("RCOM001",len(SX1->X1_GRUPO))
//Tabela no banco onde as posições são Armazenadas
//Parametros
//Definir
//Data referencia Dt Ref

    ReportDef()

    oReport:PrintDialog()

return
/*
Funcao: ReportDef|Autor: Jubirajara|Data: 16/11/2020
*/
Static Function ReportDef
    cRelNome :="Informações Produtos ANL"
    oReport := TReport():New("RCOM001_"+cRelNome,cRelNome,cPerg,{|oReport| PrintReport(oReport)},"Impressao Planilha Informações Produtos ANL.")
    oReport:SetLandscape(.F.)
    oReport:EndPage(.T.)

    oSecCab := TRSection():New( oReport , cRelNome, {"QRY"} )
    //oSecCab:SetTotalInLine(.F.) 	//O totalizador da secao sera impresso em coluna
    TRCell():New( oSecCab, "DATA_INC","QRY",,"@D",08)
    TRCell():New( oSecCab, "CODIGO","QRY")
    TRCell():New( oSecCab, "DESCRICAO","QRY")
    TRCell():New( oSecCab, "ORIGEM","QRY")
    TRCell():New( oSecCab, "UNIDADE","QRY")
    TRCell():New( oSecCab, "TIPO","QRY")
    TRCell():New( oSecCab, "Armazem_Pad","QRY")
    TRCell():New( oSecCab, "PosIPI_NCM","QRY")
    TRCell():New( oSecCab, "Forn_Produto","QRY")
    TRCell():New( oSecCab, "Linha_Prod","QRY")
    TRCell():New( oSecCab, "Ref_Fornec","QRY")
    TRCell():New( oSecCab, "Cod_EDI","QRY")
    TRCell():New( oSecCab, "Cod_Prod_Int","QRY")
    TRCell():New( oSecCab, "Cod_Barras","QRY")
    TRCell():New( oSecCab, "Cod_GTIN","QRY")
    TRCell():New( oSecCab, "Ftor_Emb_For","QRY")
    TRCell():New( oSecCab, "Cod_Mestre","QRY")        
    TRCell():New( oSecCab, "Ftor_Emb_Fat","QRY")
    TRCell():New( oSecCab, "Aplicacao","QRY")
    TRCell():New( oSecCab, "Segmento","QRY")
    TRCell():New( oSecCab, "Alternativo","QRY")
    TRCell():New( oSecCab, "Ref_Auxiliar","QRY")

//Totalizadores

    TRFunction():New(oSecCab:Cell("CODIGO"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)

Return Nil

/*
Funcao: PrintReport|Autor: Jubirajara|Data: 07/06/2020
*/

Static Function PrintReport(oReport)

    local cAlias     := "QRY"
    Local cFornec
	Local cLinha
    Pergunte(cPerg,.F.)
    cwhere := " 1=1 "
    MV_PAR01:=strtran(alltrim(MV_PAR01),",",";")
	if !";"$MV_PAR01 .and. !empty(MV_PAR01)
		MV_PAR01:=alltrim(MV_PAR01)+";"
	endif
    MV_PAR02:=strtran(alltrim(MV_PAR02),",",";")
	if !";"$MV_PAR02 .and. !empty(MV_PAR02)
		MV_PAR02:=alltrim(MV_PAR02)+";"
	endif
    MakeSqlExpr(cPerg)
    
	cFornec :=""
	IF !EMPTY(MV_PAR01)
		cFornec := " AND "+MV_PAR01
	//ElSE
	//	cFornec := " B1_XMARCA <> ' ' "
	ENDIF
	cLinha :=""
	IF !EMPTY(MV_PAR02)
		cLinha := " AND "+MV_PAR02
	//ElSE
	//	cLinha := " B1_XLINHA <> ' ' "
	ENDIF
    cDTCons:=""
    if MV_PAR03<>999
        dDTCons:= dDataBase-MV_PAR03
        cDTCons:= dtos(dDTCons)
        cDTCons:= " AND ( TO_CHAR(TO_DATE('19960101','YYYYMMDD')+((ASCII(SUBSTR(B1_USERLGI,12,1))-50)*100+(ASCII(SUBSTR(B1_USERLGI,16,1))-50)),'YYYYMMDD')>='"+cDTCons+"' )"
    endif


    if !empty(cWhere)
        cWhere :="% "+cWhere+cFornec+' '+cLinha+cDTCons+"%"
    EndIf
    
    If Select("QRY") > 0
        Dbselectarea("QRY")
        QRY->(DbClosearea())
    EndIf

//Gera relatorio com dados ja existentes
BeginSql Alias cAlias
SELECT 
TO_CHAR(TO_DATE('19960101','YYYYMMDD')+((ASCII(SUBSTR(B1_USERLGI,12,1))-50)*100+(ASCII(SUBSTR(B1_USERLGI,16,1))-50)),'YYYYMMDD') as DATA_INC,
B1_COD CODIGO,B1_DESC DESCRICAO,B1_ORIGEM ORIGEM,B1_UM Unidade,B1_TIPO Tipo,B1_LOCPAD Armazem_Pad,
B1_POSIPI PosIPI_NCM, B1_XMARCA Forn_Produto,B1_XLINHA Linha_Prod,B1_XREFFOR Ref_Fornec,B1_XEDI Cod_EDI,B1_XREFER Cod_Prod_Int,
B1_CODBAR Cod_Barras ,
B1_CODGTIN Cod_GTIN , B1_XEMBFOR Ftor_Emb_For,B1_XALTIMP Cod_Mestre, B1_XFATEMB Ftor_Emb_Fat , 
B1_XSEG Segmento,
(SELECT    coalesce(
    LISTAGG(TRIM(YP_TEXTO), ' ') WITHIN GROUP(
        ORDER BY
            SYP.r_e_c_n_o_
    ), ' ') 
FROM DADOSANL.SYP010 SYP WHERE YP_CHAVE=b1_xcodapl AND D_E_L_E_T_=' ' AND YP_CAMPO = 'B1_XCODAPL') Aplicacao,
coalesce(LISTAGG(trim(GI_PRODALT), '; ')
         WITHIN GROUP (ORDER BY gi.r_e_c_n_o_),' ') Alternativo,
coalesce(LISTAGG(trim(GI_XREFAUX), '; ')
         WITHIN GROUP (ORDER BY gi.r_e_c_n_o_),' ') Ref_Auxiliar
FROM SB1010 B1
LEFT JOIN DADOSANL.SGI010 GI ON GI_FILIAL=B1_FILIAL AND GI_PRODORI=B1_COD  AND GI.D_E_L_E_T_=' '
WHERE
    %Exp:cWhere%
group by B1_COD ,B1_DESC ,B1_ORIGEM ,B1_UM ,B1_TIPO ,B1_LOCPAD ,
B1_POSIPI , B1_XMARCA ,B1_XLINHA ,B1_XREFFOR ,B1_XEDI ,B1_XREFER ,
B1_CODBAR  ,
B1_CODGTIN  , B1_XEMBFOR ,B1_XALTIMP , B1_XFATEMB  , b1_xcodapl ,
B1_XSEG ,
TO_CHAR(TO_DATE('19960101','YYYYMMDD')+((ASCII(SUBSTR(B1_USERLGI,12,1))-50)*100+(ASCII(SUBSTR(B1_USERLGI,16,1))-50)),'YYYYMMDD')
ORDER BY 1,B1_COD ,B1_DESC ,B1_ORIGEM ,B1_UM ,B1_TIPO ,B1_LOCPAD

EndSql
oSecCab:EndQuery()
ctmpquery := oSecCab:GetQuery()
TCSetField( 'QRY', 'DATA_INC', 'D', 8, 0 )
//TCSetField( 'QRY', 'RECEBIMENTO', 'D', 8, 0 )

Dbselectarea("QRY")
QRY->(dbgotop())
//oReport:SetMeter(QRY->(RecCount()))
oSecCab:Print()

Return Nil
