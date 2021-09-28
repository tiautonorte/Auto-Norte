#INCLUDE "Topconn.ch"
#include "protheus.ch"
#include "parmtype.ch"
/*
Financeiro
Autor: Jubirajara|Data: 16/11/2020
Relatorio conferência de Custo
*/
User Function REST001
    Private oReport :=Nil
    Private oSecCab :=Nil
    Private cPerg   := Padr("REST001",len(SX1->X1_GRUPO))
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
    cRelNome :="Conferencia de Custo de Entrada"
    oReport := TReport():New("REST001_"+cRelNome,cRelNome,cPerg,{|oReport| PrintReport(oReport)},"Impressao Planilha Conferencia Custo.")
    oReport:SetLandscape(.F.)
    oReport:EndPage(.T.)

    oSecCab := TRSection():New( oReport , cRelNome, {"QRY"} )
    oSecCab:SetTotalInLine(.F.) 	//O totalizador da secao sera impresso em coluna

        TRCell():New( oSecCab, "EMPRESA","QRY")
        TRCell():New( oSecCab, "EMISSAO","QRY",,"@D")
        TRCell():New( oSecCab, "RECEBIMENTO","QRY",,"@D")
        TRCell():New( oSecCab, "TIPO_ENTRADA","QRY")
        TRCell():New( oSecCab, "DESCRICAO_TIPO_ENTRADA","QRY")
        TRCell():New( oSecCab, "FINALIDADE_TIPO_ENTRADA","QRY")
        TRCell():New( oSecCab, "COD_FISCAL","QRY")
        TRCell():New( oSecCab, "DOCUMENTO","QRY")
        TRCell():New( oSecCab, "SERIE","QRY")
        TRCell():New( oSecCab, "FORN_COD","QRY")
        TRCell():New( oSecCab, "FORN_NOME","QRY")
        TRCell():New( oSecCab, "GRUPO_TRIB","QRY")
        TRCell():New( oSecCab, "GR_TRIB_DESCRICAO","QRY")
        TRCell():New( oSecCab, "MARCA","QRY")
        TRCell():New( oSecCab, "LINHA","QRY")
        TRCell():New( oSecCab, "PROD_COD","QRY")
        TRCell():New( oSecCab, "PROD_DESCRICAO","QRY")        
        TRCell():New( oSecCab, "QUANT","QRY",,"@999,999.99")
        TRCell():New( oSecCab, "VLR_UNITARIO","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "VALOR_TOTAL","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "TES_CALC_IPI","QRY")
        TRCell():New( oSecCab, "TES_CRED_IPI","QRY")
        TRCell():New( oSecCab, "VLR_BASE_IPI","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "ALIQ_IPI","QRY")
        TRCell():New( oSecCab, "VALOR_IPI","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "TOTAL_C_IPI","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "TES_CALC_ICM","QRY")
        TRCell():New( oSecCab, "TES_CRED_ICM","QRY")
        TRCell():New( oSecCab, "BASE_ICMS","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "ALIQ_ICMS","QRY")
        TRCell():New( oSecCab, "VALOR_ICMS","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "TES_CALC_ST","QRY")
        TRCell():New( oSecCab, "TES_AGREGA_SOL","QRY")
        TRCell():New( oSecCab, "MVA_ICMS_ST","QRY")
        TRCell():New( oSecCab, "B_ICMS_ST","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "ALIQ_SOL","QRY")
        TRCell():New( oSecCab, "VAL_ICMS_ST","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "VAL_TOTAL_C_ST","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "TES_GERA_PISCOF","QRY")
        TRCell():New( oSecCab, "TES_CRED_PISCOF","QRY")
        TRCell():New( oSecCab, "ALIQ_PIS","QRY")
        TRCell():New( oSecCab, "VALOR_PIS","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "ALIQ_COF","QRY")
        TRCell():New( oSecCab, "VALOR_COF","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "VLR_NF_FRETE","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "VLR_NF_DESPESAS","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "FRETE_FORN_LOJA","QRY")
        TRCell():New( oSecCab, "FRETE_CONHECIMENTO","QRY")
        TRCell():New( oSecCab, "FRETE_SERIE","QRY")
        TRCell():New( oSecCab, "VLR_FRETE_FOB","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "CUSTO","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "CUSTO_UNIT","QRY",,"@E 999,999,999.99",20)
        TRCell():New( oSecCab, "CHAVE_NFE","QRY")

//Totalizadores

    TRFunction():New(oSecCab:Cell("VALOR_TOTAL"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VALOR_IPI"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("TOTAL_C_IPI"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VALOR_ICMS"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VAL_ICMS_ST"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VAL_TOTAL_C_ST"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VALOR_PIS"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VALOR_COF"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VLR_FRETE_FOB"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("CUSTO"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)

    TRFunction():New(oSecCab:Cell("VLR_NF_FRETE"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)
    TRFunction():New(oSecCab:Cell("VLR_NF_DESPESAS"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSecCab)

Return Nil

/*
Funcao: PrintReport|Autor: Jubirajara|Data: 16/11/2020
*/

Static Function PrintReport(oReport)

    local cAlias     := "QRY"
    Pergunte(cPerg,.F.)
    cwhere := " D1_XOPER='01' "

    If !EMPTY(MV_PAR01)
        cwhere += IIF(!EMPTY(cwhere)," AND ","")+" D1_FILIAL>='"+MV_PAR01+"'  AND D1_FILIAL<='"+MV_PAR02+"' "
    EndIf
    If !EMPTY(MV_PAR03)
        cwhere += IIF(!EMPTY(cwhere)," AND ","")+" D1_DTDIGIT>='"+dtos(MV_PAR03)+"'  AND D1_DTDIGIT<='"+dtos(MV_PAR04)+"' "
    EndIf 
    If !EMPTY(MV_PAR05)
        cwhere += IIF(!EMPTY(cwhere)," AND ","")+" D1_FORNECE='"+MV_PAR05+"' "
    EndIf
    If !EMPTY(MV_PAR06)
        cwhere += IIF(!EMPTY(cwhere)," AND ","")+" D1_DOC='"+MV_PAR06+"' "
    EndIf
    If !EMPTY(MV_PAR07)
        cwhere += IIF(!EMPTY(cwhere)," AND ","")+" D1_EMISSAO>='"+dtos(MV_PAR07)+"'  AND D1_EMISSAO<='"+dtos(MV_PAR08)+"' "
    EndIf 

    if cWhere<>""
        cWhere :="%"+cWhere+"%"
    EndIf
    
    If Select("QRY") > 0
        Dbselectarea("QRY")
        QRY->(DbClosearea())
    EndIf
//Ordem
cOrderBy := Iif(!empty(MV_PAR07)," D1_EMISSAO","D1_DTDIGIT")
cOrderBy += " ,A2_NOME,D1_DOC,D1_COD "

//Gera relatorio com dados ja existentes
BeginSql Alias cAlias
SELECT D1_FILIAL EMPRESA,D1_EMISSAO EMISSAO,D1_DTDIGIT RECEBIMENTO,D1_TES TIPO_ENTRADA,F4_TEXTO DESCRICAO_TIPO_ENTRADA,F4_FINALID FINALIDADE_TIPO_ENTRADA,
D1_CF COD_FISCAL, D1_DOC DOCUMENTO,
D1_SERIE SERIE,D1_FORNECE FORN_COD,A2_NOME FORN_NOME,B1_GRTRIB GRUPO_TRIB,
X5_DESCRI GR_TRIB_DESCRICAO, B1_XMARCA MARCA, B1_XLINHA LINHA, 
D1_COD PROD_COD, B1_DESC PROD_DESCRICAO,D1_QUANT QUANT, D1_VUNIT VLR_UNITARIO, D1_TOTAL VALOR_TOTAL,
F4_IPI TES_CALC_IPI,F4_CREDIPI TES_CRED_IPI, D1_BASEIPI VLR_BASE_IPI, D1_IPI ALIQ_IPI, D1_VALIPI VALOR_IPI, D1_TOTAL+D1_VALIPI TOTAL_C_IPI,
F4_ICM TES_CALC_ICM,F4_CREDICM TES_CRED_ICM, D1_BASEICM BASE_ICMS, D1_PICM ALIQ_ICMS, D1_VALICM VALOR_ICMS,
(CASE TRIM(F4_MKPCMP) WHEN '1' THEN 'NAO CALC' WHEN '2' THEN 'CALCULA' END) TES_CALC_ST,
F4_INCSOL TES_AGREGA_SOL ,D1_MARGEM MVA_ICMS_ST, D1_BRICMS B_ICMS_ST, D1_ALIQSOL ALIQ_SOL, D1_ICMSRET VAL_ICMS_ST,
D1_TOTAL+D1_VALIPI+D1_ICMSRET VAL_TOTAL_C_ST,
(CASE TRIM(F4_PISCOF) WHEN '1' THEN 'PIS' WHEN '2' THEN 'COFINS' WHEN '3' THEN 'Ambos' WHEN '4' THEN 'Nao Considera' ELSE 'NA' END) TES_GERA_PISCOF,
(CASE TRIM(F4_PISCRED) WHEN '1' THEN 'Credita' WHEN '2' THEN 'Debita' WHEN '3' THEN 'Nao Calcula' WHEN '4' THEN 'Calcula' WHEN '5' THEN 'Exclusão de Base' ELSE 'NA' END) TES_CRED_PISCOF,
D1_ALQPIS ALIQ_PIS, D1_VALIMP6 VALOR_PIS ,D1_ALQCOF ALIQ_COF, D1_VALIMP5 VALOR_COF,
D1_DESPESA VLR_NF_DESPESAS, D1_VALFRE VLR_NF_FRETE,
 (SELECT F8_TRANSP||'/'||F8_LOJTRAN
    FROM SF8010 F8
    LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

    WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
        AND F8_TIPO='F'
        AND D1F.D1_COD=D1.D1_COD 
        AND F8.D_E_L_E_T_=' ' and rownum<2
     ) FRETE_FORN_LOJA,
 (SELECT F8_NFDIFRE
    FROM SF8010 F8
    LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

    WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
        AND F8_TIPO='F'
        AND D1F.D1_COD=D1.D1_COD 
        AND F8.D_E_L_E_T_=' ' and rownum<2
     ) FRETE_CONHECIMENTO,
 (SELECT F8_SEDIFRE
    FROM SF8010 F8
    LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

    WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
        AND F8_TIPO='F'
        AND D1F.D1_COD=D1.D1_COD 
        AND F8.D_E_L_E_T_=' ' and rownum<2
     ) FRETE_SERIE,
((SELECT COALESCE(sum(D1F.D1_TOTAL),0)
    FROM SF8010 F8
    LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

    WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
        AND F8_TIPO='F'
        AND D1F.D1_COD=D1.D1_COD 
        AND F8.D_E_L_E_T_=' '
     )/(Select sum(D1_QUANT) from SD1010 D1C WHERE  D1C.D1_FILIAL=D1.D1_FILIAL AND D1C.D1_DOC=D1.D1_DOC AND D1C.D1_SERIE=D1.D1_SERIE AND D1C.D1_FORNECE=D1.D1_FORNECE AND D1C.D1_LOJA=D1.D1_LOJA AND D1C.D1_COD=D1.D1_COD AND D1C.D_E_L_E_T_=' '))*D1_QUANT VLR_FRETE_FOB, 
  D1_CUSTO CUSTO,
  D1_CUSTO/(case when D1_QUANT>0 then D1_QUANT else 0 end) CUSTO_UNIT,
  F1_CHVNFE CHAVE_NFE
FROM SD1010 D1
LEFT JOIN SF1010 F1 ON F1_FILIAL=D1_FILIAL AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1_DTDIGIT=D1_DTDIGIT AND F1.D_E_L_E_T_=' ' 
LEFT JOIN SB1010 B1 ON B1_COD=D1_COD AND B1.D_E_L_E_T_=' ' 
LEFT JOIN SX5010 X5 ON X5_TABELA='21' AND X5_CHAVE=B1_GRTRIB AND X5.D_E_L_E_T_=' ' 
LEFT JOIN SA2010 A2 ON A2_COD=D1_FORNECE AND A2_LOJA=D1_LOJA AND A2.D_E_L_E_T_=' ' 
LEFT JOIN SF4010 F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' 
WHERE
    %Exp:cWhere%
ORDER BY D1_DTDIGIT ,A2_NOME,D1_DOC,D1_COD

EndSql
oSecCab:EndQuery()
ctmpquery := oSecCab:GetQuery()
TCSetField( 'QRY', 'EMISSAO', 'D', 8, 0 )
TCSetField( 'QRY', 'RECEBIMENTO', 'D', 8, 0 )

Dbselectarea("QRY")
QRY->(dbgotop())
oReport:SetMeter(QRY->(RecCount()))
oSecCab:Print()

Return Nil
