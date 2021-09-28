#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RFIS015
    (long_description)
    @type  User Function
    @author Rubens Lima
    @since 29/09/2020
    @version version
    @param 
            mv_par01, Caracter, Filial Específica
            mv_par02, Data    , Data Inicial
            mv_par03, Data    , Data Final
            mv_par04, Numérico, Tipo de Apuração
                                1 - Memória de Cálculo
                                2 - Resumo Filiais
                                3 - Resumo Entradas
                                4 - Resumo Saídas
            mv_par04, Numérico, Tipo de Relatório
                                1 - Consolidado
                                2 - Analítico
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function RFIS015()

    Private oReport

    Private oSection1
    Private oSection2
    Private oSection3
    Private oSection4
    Private oSection5
    Private oSection6
    Private cPerg     := "RFIS015"

    Pergunte(cPerg, .T.)
    
    oReport:=RptDef(cPerg)
    oReport:PrintDialog()

return

Static Function RptDef(cPerg)
    Local cAlias    := GetNextAlias()
    Local cAlias1   := GetNextAlias()
    Local cAlias2   := GetNextAlias()
    Local cNomeRel  := ""

    //Private oReport  
    Private oBreak1

    /*/
    -------------------------------------------------------------------------
    | Memória de Cálculo Consolidado                                        |
    -------------------------------------------------------------------------
    /*/
    If (mv_par04=1 .and. mv_par05=1)

        cNomeRel := "Relatorio Apuração PIS/COFINS - Memória de Cálculo Consolidado"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetPortrait()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10
        DefMemCalC(cAlias,oReport,cNomeRel,oSection1,oSection2,oSection3,oSection4,oSection5,oSection6)
            
    /*/
    -------------------------------------------------------------------------
    | Memória de Cálculo Analítico                                          |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=1 .and. mv_par05=2)

        cNomeRel := "Relatorio Apuração PIS/COFINS - Memória de Cálculo Por Filial"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetPortrait()
      	oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,"FILIAL",cAlias1,,,,,,.T.,,,,,.T.)
	        
        TRCell():New(oSection1,"FILIAL"	        ,cAlias1 ,"FILIAL"		,                   ,20                     ,.F.,,,,       ,,,,,,.F.)
            
        oSection2 := TRSection():New(oSection1    ,"APURAÇÕES",cAlias1,,,,"Receita Tributária Fiscal",.F.,.T.,.F.,,,,.F.,,,,0)

        TRCell():New(oSection2,"RECEITA"	    ,cAlias1 ,"CONSOLIDADO" ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection2,"RECEITA_TRIB"   ,cAlias1 ,"BASE CÁLCULO","@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"PIS_TRIB"       ,cAlias1 ,"PIS"	        ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"COFINS_TRIB"    ,cAlias1 ,"COFINS"	    ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
            
        oBreak1 := TRBreak():New(oSection1,{ || oSection1:Cell('FILIAL'):uPrint },'RECEITA TRIB FISCAL',.F.,,.T.)

        TRFunction():New(oSection2:Cell('RECEITA_TRIB') ,cAlias1,'SUM',oBreak1,,"@E 999,999,999.99",,.F.,.F.,.F., oSection2)
        TRFunction():New(oSection2:Cell('PIS_TRIB')     ,cAlias1,'SUM',oBreak1,,"@E 999,999,999.99",,.F.,.F.,.F., oSection2)
        TRFunction():New(oSection2:Cell('COFINS_TRIB')  ,cAlias1,'SUM',oBreak1,,"@E 999,999,999.99",,.F.,.F.,.F., oSection2)
            
        oSection3 := TRSection():New(oReport    ,"TOTAL GERAL",cAlias2,,,,"Receita Tributária Fiscal",.F.,.F.,.F.,.F.,,,.F.,,,,0)
        oSection3:SetTotalText("RECEITA TRIB FISCAL")
            
        TRCell():New(oSection3,"RECEITA"	    ,cAlias2 ,"",                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection3,"RECEITA_TRIB"   ,cAlias2 ,"","@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"PIS_TRIB"       ,cAlias2 ,"","@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"COFINS_TRIB"    ,cAlias2 ,"","@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
            
        TRFunction():New(oSection3:Cell('RECEITA_TRIB') ,cAlias2,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('PIS_TRIB')     ,cAlias2,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('COFINS_TRIB')  ,cAlias2,'SUM',,,"@E 999,999,999.99",,.T.,.F.,.F., oSection3)

    /*/
    -------------------------------------------------------------------------
    | Resumo Filiais Consolidado                                            |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=2 .and. mv_par05=1)

        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Filiais Consolidado"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetLandScape()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 8

        oSection1 := TRSection():New(oReport,cNomeRel,,,,,,.F.,,,,,,.F.,,.F.)
        oSection1:SetAutoSize(.T.)
        oSection1:SetTotalText("RECEITA TRIB FISCAL")

        TRCell():New(oSection1,"RECEITA",cAlias,"CONSOLIDADO ",                     ,35,.F.,)
        TRCell():New(oSection1,"MZ"     ,cAlias,"MATRIZ"      ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"BA"     ,cAlias,"BAHIA"       ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"CE"     ,cAlias,"CEARÁ"       ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)      
        TRCell():New(oSection1,"PE"     ,cAlias,"PERNAMBUCO"  ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                        
        TRCell():New(oSection1,"RN"     ,cAlias,"RIO G NORTE" ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                                    
        TRCell():New(oSection1,"PB"     ,cAlias,"PARAÍBA"     ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                                    
        TRCell():New(oSection1,"PI"     ,cAlias,"PIAUÍ"       ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                                                
        TRCell():New(oSection1,"SE"     ,cAlias,"SERGIPE"     ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                                    
        TRCell():New(oSection1,"TOTAL"  ,cAlias,"TOTAL"       ,"@E 999,999,999.99",18,.F.,,"RIGHT",,"RIGHT",,,,,,.F.)                                                

        TRFunction():New(oSection1:Cell('MZ')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('BA')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('CE')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('PE')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('RN')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('PB')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('PI')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)
        TRFunction():New(oSection1:Cell('SE')   ,cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)            
        TRFunction():New(oSection1:Cell('TOTAL'),cAlias,'SUM',,,"@E 999,999,999.99",,.F.,.T.,.F., oSection1)

    /*/
    -------------------------------------------------------------------------
    | Resumo Filiais Analítico                                              |
    -------------------------------------------------------------------------
    /*/        
    ElseIf (mv_par04=2 .and. mv_par05=2)
        
        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Filiais Analítico"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetPortrait()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10

    /*/
    -------------------------------------------------------------------------
    | Resumo Entradas Consolidado                                           |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=3 .and. mv_par05=1)
        
        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Entradas Consolidado"        
        
        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetLandScape()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,"TIPO"     ,cAlias,,,,,,,,,,,.T.,,.F.)
        TRCell():New(oSection1,"TIPO"	        ,cAlias     ,""             ,                   ,20                     ,.F.,,       ,   ,       ,,,,,,.T.)

        oSection2 := TRSection():New(oSection1  ,"RECEITA"  ,cAlias,,,,,,,,,,,.T.,,.F.)
        TRCell():New(oSection2,"RECEITA"	    ,cAlias     ,""		        ,                   ,20                     ,.F.,,       ,   ,       ,,,,,,.T.)

        oSection3 := TRSection():New(oSection2  ,"CFOP"     ,cAlias,,,,,,,,,,,.F.,,.F.)
            
        TRCell():New(oSection3,"CFOP"           ,cAlias,"           CFOP"   ,                   ,6		                ,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_CONTABIL"   ,cAlias,"   VLR CONTABIL"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_PRODUTOS"   ,cAlias,"   VLR PRODUTOS"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_DESPESA"    ,cAlias,"   VLR DESPESAS"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_FRETE"      ,cAlias,"      VLR FRETE"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_ICM"        ,cAlias," VLR ICMS LIVRO"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"ICMS_AJU"       ,cAlias,"VLR ICMS AJUSTE"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_ICMRET"     ,cAlias,"    VLR ICMS ST"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_IPI"        ,cAlias,"        VLR IPI"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"BASE_CALC"      ,cAlias,"   BASE CALCULO"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)

        oBreak1 := TRBreak():New(oSection1,oSection1:Cell('TIPO'),,.F.,,.F.)
        oBreak2 := TRBreak():New(oSection2,{ || oSection2:Cell('RECEITA'):uPrint },'TOTAL',.F.,,.F.)

        TRFunction():New(oSection3:Cell('VLR_CONTABIL') ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_PRODUTOS') ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_DESPESA')  ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_FRETE')    ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_ICM')      ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('ICMS_AJU')     ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_ICMRET')   ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_IPI')      ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('BASE_CALC')    ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
           
    /*/
    -------------------------------------------------------------------------
    | Resumo Entradas Analítico                                             |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=3 .and. mv_par05=2)
         
        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Entradas Analítico"
         
        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetLandScape()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,cNomeRel ,cAlias,,,,,,,,,,,.T.,,.F.)         

        TRCell():New( oSection1, "EMPRESA",cAlias)
        //MODELONF
        TRCell():New( oSection1, "ESPECIE",cAlias)
        TRCell():New( oSection1, "EMISSAO",cAlias,,"@D")
        TRCell():New( oSection1, "RECEBIMENTO",cAlias,,"@D")
        //DTCANCELA
        TRCell():New( oSection1, "DOCUMENTO",cAlias)
        TRCell():New( oSection1, "SERIE",cAlias)
        TRCell():New( oSection1, "VL_TOTAL_NF",cAlias)

        TRCell():New( oSection1, "FORN_COD",cAlias) //CODFORNECE
        TRCell():New( oSection1, "FORN_NOME",cAlias) //RAZSOCIAL       
        TRCell():New( oSection1, "FORN_CNPJ",cAlias) //CNPJ
        TRCell():New( oSection1, "FORN_UF",cAlias) //UF

        TRCell():New( oSection1, "PROD_ITEM",cAlias)  //NUMITEM
        TRCell():New( oSection1, "PROD_COD",cAlias)
        TRCell():New( oSection1, "PROD_DESCRICAO",cAlias)        
        TRCell():New( oSection1, "PROD_NCM",cAlias)     //NCM
        TRCell():New( oSection1, "EX_NCM",cAlias)     //EXNCM
        TRCell():New( oSection1, "SEGUIMENTO",cAlias)
        TRCell():New( oSection1, "TP_OPER",cAlias)     //XOPER

        TRCell():New( oSection1, "TIPO_ENTRADA",cAlias)
        TRCell():New( oSection1, "COD_FISCAL",cAlias)
        TRCell():New( oSection1, "GRUPO_TRIB",cAlias)
        TRCell():New( oSection1, "GR_TRIB_DESCRICAO",cAlias)
        TRCell():New( oSection1, "GRP_TRIB_TI",cAlias)


        TRCell():New( oSection1, "PROD_MONO",cAlias)        
        TRCell():New( oSection1, "CST_PIS",cAlias)
        TRCell():New( oSection1, "CST_COFINS",cAlias)
        TRCell():New( oSection1, "TES_CRED_PISCOF",cAlias)
        TRCell():New( oSection1, "TES_GERA_PISCOF",cAlias)

        TRCell():New( oSection1, "QUANT",cAlias,,"@999,999.99")
        TRCell():New( oSection1, "VLR_UNITARIO",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "VALOR_TOTAL",cAlias,,"@E 999,999,999.99",20) //VLTOTALNF
        TRCell():New( oSection1, "VLR_CONTABIL",cAlias,,"@E 999,999,999.99",20) //VLTOTALNF
        //CSTIPI
        TRCell():New( oSection1, "VALOR_IPI",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "TOTAL_C_IPI",cAlias,,"@E 999,999,999.99",20)


        TRCell():New( oSection1, "ALIQ_ICMS",cAlias,,"@E 999.99",20) //PICM
        TRCell():New( oSection1, "VALOR_ICMS",cAlias,,"@E 999,999,999.99",20) //VLICMSNF
        TRCell():New( oSection1, "ICMS_AJU",cAlias,,"@E 999,999,999.99",20) //ICMS_AJU

        TRCell():New( oSection1, "VAL_ICMS_ST",cAlias,,"@E 999,999,999.99",20) //VLRST_NF
        TRCell():New( oSection1, "VAL_TOTAL_C_ST",cAlias,,"@E 999,999,999.99",20)


        TRCell():New( oSection1, "BASE_PIS",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "ALIQ_PIS",cAlias)
        TRCell():New( oSection1, "VALOR_PIS",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "BASE_COF",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "ALIQ_COF",cAlias)
        TRCell():New( oSection1, "VALOR_COF",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "VLR_NF_FRETE",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "VLR_NF_DESPESAS",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "TES_AGREGA_SOL",cAlias)
        //CSTCOFINS
        TRCell():New( oSection1, "CHAVE_NFE",cAlias)

        //TRCell():New( oSection1, "CUSTO",cAlias,,"@E 999,999,999.99",20)
        //MUNICIPIO




        //oBreak1 := TRBreak():New(oSection1,oSection1:Cell('FILIAL'),,.F.,,.F.)
        //oBreak2 := TRBreak():New(oSection2,oSection2:Cell('TIPO'),,.F.,,.F.)
        //oBreak3 := TRBreak():New(oSection3,{ || oSection3:Cell('RECEITA'):uPrint },'TOTAL',.F.,,.F.)

/*        TRFunction():New(oSection4:Cell('VLR_CONTABIL') ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_PRODUTOS') ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_DESPESA')  ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_FRETE')    ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_ICM')      ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_ICMRET')   ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('VLR_IPI')      ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
        TRFunction():New(oSection4:Cell('BASE_CALC')    ,,'SUM',oBreak3,,"@E 999,999,999.99",,.F.,.F.,.F., oSection4)
  */          
    /*/
    -------------------------------------------------------------------------
    | Resumo Saídas Consolidado                                             |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=4 .and. mv_par05=1)

        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Saídas Consolidado"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")
        oReport:SetLandScape()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,"TIPO"     ,cAlias,,,,,,,,,,,.T.,,.F.)
        TRCell():New(oSection1,"TIPO"	        ,cAlias     ,""         ,                   ,20                     ,.F.,,       ,   ,       ,,,,,,.T.)

        oSection2 := TRSection():New(oSection1  ,"RECEITA"  ,cAlias,,,,,,,,,,,.T.,,.F.)
        TRCell():New(oSection2,"RECEITA"	    ,cAlias     ,""      ,                   ,20                     ,.F.,,       ,   ,       ,,,,,,.T.)

        oSection3 := TRSection():New(oSection2  ,"CFOP"     ,cAlias,,,,,,,,,,,.F.,,.F.)
            
        TRCell():New(oSection3,"CFOP"           ,cAlias,"           CFOP"   ,                   ,6		                ,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_CONTABIL"   ,cAlias,"   VLR CONTABIL"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_PRODUTOS"   ,cAlias,"   VLR PRODUTOS"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_DESPESA"    ,cAlias,"   VLR DESPESAS"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_FRETE"      ,cAlias,"      VLR FRETE"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_ICM"        ,cAlias,"       VLR ICMS"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"ICMS_AJU"       ,cAlias,"    ICMS AJUSTE"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_ICMRET"     ,cAlias,"    VLR ICMS ST"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"VLR_IPI"        ,cAlias,"        VLR IPI"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"BASE_CALC"      ,cAlias,"   BASE CALCULO"   ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,"RIGHT",.F.,"RIGHT",,,,,,.F.)

        oBreak1 := TRBreak():New(oSection1,oSection1:Cell('TIPO'),,.F.,,.F.)
        oBreak2 := TRBreak():New(oSection2,{ || oSection2:Cell('RECEITA'):uPrint },'TOTAL',.F.,,.F.)

        TRFunction():New(oSection3:Cell('VLR_CONTABIL') ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_PRODUTOS') ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_DESPESA')  ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_FRETE')    ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_ICM')      ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('ICMS_AJU')     ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_ICMRET')   ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('VLR_IPI')      ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)
        TRFunction():New(oSection3:Cell('BASE_CALC')    ,,'SUM',oBreak2,,"@E 999,999,999.99",,.F.,.F.,.F., oSection3)

    /*/
    -------------------------------------------------------------------------
    | Resumo Saídas Analitico                                               |
    -------------------------------------------------------------------------
    /*/
    ElseIf (mv_par04=4 .and. mv_par05=2) 

        cNomeRel := "Relatorio Apuração PIS/COFINS - Resumo Saídas Analítico"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetLandScape()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,cNomeRel ,cAlias,,,,,,,,,,,.T.,,.F.)         

        TRCell():New( oSection1, "EMPRESA",cAlias)
        //MODELONF
        TRCell():New( oSection1, "ESPECIE",cAlias)
        TRCell():New( oSection1, "EMISSAO",cAlias,,"@D")
        TRCell():New( oSection1, "RECEBIMENTO",cAlias,,"@D")
        //DTCANCELA
        TRCell():New( oSection1, "DOCUMENTO",cAlias)
        TRCell():New( oSection1, "SERIE",cAlias)
        TRCell():New( oSection1, "VL_TOTAL_NF",cAlias)

        TRCell():New( oSection1, "CLIEN_COD",cAlias) //CODFORNECE
        TRCell():New( oSection1, "CLIEN_NOME",cAlias) //RAZSOCIAL
        TRCell():New( oSection1, "CLIEN_CNPJ",cAlias) //CNPJ
        TRCell():New( oSection1, "CLIEN_UF",cAlias) //UF

        TRCell():New( oSection1, "PROD_ITEM",cAlias)  //NUMITEM
        TRCell():New( oSection1, "PROD_COD",cAlias)
        TRCell():New( oSection1, "PROD_DESCRICAO",cAlias)        
        TRCell():New( oSection1, "PROD_NCM",cAlias)     //NCM
        TRCell():New( oSection1, "EX_NCM",cAlias)     //NCM
        TRCell():New( oSection1, "SEGUIMENTO",cAlias)     //NCM
        TRCell():New( oSection1, "TP_OPER",cAlias)     //XOPER

        TRCell():New( oSection1, "TIPO_ENTRADA",cAlias)
        TRCell():New( oSection1, "COD_FISCAL",cAlias)
        TRCell():New( oSection1, "GRUPO_TRIB",cAlias)
        TRCell():New( oSection1, "GR_TRIB_DESCRICAO",cAlias)
        TRCell():New( oSection1, "GRP_TRIB_TI",cAlias)
        TRCell():New( oSection1, "PROD_MONO",cAlias)        
        TRCell():New( oSection1, "CST_PIS",cAlias)
        TRCell():New( oSection1, "CST_COFINS",cAlias)
        TRCell():New( oSection1, "TES_CRED_PISCOF",cAlias)
        TRCell():New( oSection1, "TES_GERA_PISCOF",cAlias)

        TRCell():New( oSection1, "QUANT",cAlias,,"@999,999.99")
        TRCell():New( oSection1, "VLR_UNITARIO",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "VALOR_TOTAL",cAlias,,"@E 999,999,999.99",20) //VLTOTALNF
        TRCell():New( oSection1, "VLR_CONTABIL",cAlias,,"@E 999,999,999.99",20) //VLTOTALNF

        //CSTIPI
        TRCell():New( oSection1, "VALOR_IPI",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "TOTAL_C_IPI",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "ALIQ_ICMS",cAlias,,"@E 999.99",20) //PICM
        TRCell():New( oSection1, "VALOR_ICMS",cAlias,,"@E 999,999,999.99",20) //VLICMSNF
        TRCell():New( oSection1, "ICMS_AJU",cAlias,,"@E 999,999,999.99",20) //ICMS_AJU

        TRCell():New( oSection1, "VAL_ICMS_ST",cAlias,,"@E 999,999,999.99",20) //VLRST_NF
        TRCell():New( oSection1, "VAL_TOTAL_C_ST",cAlias,,"@E 999,999,999.99",20)


        TRCell():New( oSection1, "BASE_PIS",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "ALIQ_PIS",cAlias)
        TRCell():New( oSection1, "VALOR_PIS",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "BASE_COF",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "ALIQ_COF",cAlias)
        TRCell():New( oSection1, "VALOR_COF",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "VLR_NF_FRETE",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "VLR_NF_DESPESAS",cAlias,,"@E 999,999,999.99",20)

        TRCell():New( oSection1, "TES_AGREGA_SOL",cAlias)
        //CSTCOFINS
        TRCell():New( oSection1, "CHAVE_NFE",cAlias)
            
    Endif

    oReport:oPage:setPaperSize(9)
    oReport:SetTotalInLine(.F.)

Return oReport


Static Function RptPrint(oReport,cAlias,cAlias1,cAlias2,CNOMEREL)

    Local cEmp      := ""
    Local cEmpEnt   := ""
    Local TempSM4   := getNextAlias()
    Private aSldAtu   := { 0,0,0 }

    BeginSql alias TempSM4
        SELECT 
               M4_CODIGO, M4_DESCR, M4_FORMULA 
          FROM %table:SM4% SM4 
         WHERE M4_DESCR LIKE '%CFOP%' 
           AND SM4.%NotDel% 
    EndSql

    DbSelectArea(TempSM4)
    while !(TempSM4)->(Eof())
        if m4_codigo = 'VND'
            cVnd := FormatIn(alltrim(m4_formula),'/')
            cVnd := StrTran(cVnd,'"','')
            cVndS:= "% SD2.D2_CF IN " + cVnd + "%"
            cVndE:= "% SD1.D1_CF IN " + cVnd + "%"
        elseif m4_codigo = 'DEV'
            cDev := FormatIn(alltrim(m4_formula),'/')
            cDev := StrTran(cDev,'"','')
            cDevS:= "% SD2.D2_CF IN " + cDev + "%"
            cDevE:= "% SD1.D1_CF IN " + cDev + "%"
        elseif m4_codigo = 'CMP'
            cCmp := FormatIn(alltrim(m4_formula),'/')
            cCmp := StrTran(cCmp,'"','')
            cCmpS:= "% SD2.D2_CF IN " + cCmp + "%"
            cCmpE:= "% SD1.D1_CF IN " + cCmp + "%"
        elseif m4_codigo = 'DEC'
            cDec := FormatIn(alltrim(m4_formula),'/')
            cDec := StrTran(cDec,'"','')
            cDecS:= "% SD2.D2_CF IN " + cDec + "%"
            cDecE:= "% SD1.D1_CF IN " + cDec + "%"
        elseif m4_codigo = 'CTE'
            cCte := FormatIn(alltrim(m4_formula),'/')
            cCte := StrTran(cCte,'"','')
            cCteS:= "% SD2.D2_CF IN " + cCte + "%"
            cCteE:= "% SD1.D1_CF IN " + cCte + "%"
        elseif m4_codigo = 'ANF'
            cAnf := FormatIn(alltrim(m4_formula),'/')
            cAnf := StrTran(cAnf,'"','')
            cAnfS:= "% SD2.D2_CF IN " + cAnf + "%"
            cAnfE:= "% SD1.D1_CF IN " + cAnf + "%"
        elseif m4_codigo = 'PRD'
            cPrd := FormatIn(alltrim(m4_formula),'/')
            cPrd := StrTran(cPrd,'"','')
            cPrdS:= "% SD2.D2_CF IN " + cPrd + "%"
            cPrdE:= "% SD1.D1_CF IN " + cPrd + "%"
        elseif m4_codigo = 'ENE'
            cEne := FormatIn(alltrim(m4_formula),'/')
            cEne := StrTran(cEne,'"','')
            cEneS:= "% SD2.D2_CF IN " + cEne + "%"
            cEneE:= "% SD1.D1_CF IN " + cEne + "%"
        elseif m4_codigo = 'BNE'
            cBne := FormatIn(alltrim(m4_formula),'/')
            cBne := StrTran(cBne,'"','')
            cBneS:= "% SD2.D2_CF IN " + cBne + "%"
            cBneE:= "% SD1.D1_CF IN " + cBne + "%"
        ///O.S 12209 //jjs - Incluir os CFOPs de transferência    
        elseif m4_codigo = 'TRE'
            cTrE := FormatIn(alltrim(m4_formula),'/')
            cTrE := StrTran(cTrE,'"','')
            cTraE:= "% SD1.D1_CF IN " + cTrE + "%"
        elseif m4_codigo = 'TRS'
            cTrS := FormatIn(alltrim(m4_formula),'/')
            cTrS := StrTran(cTrS,'"','')
            cTraS  := "% SD2.D2_CF IN " + cTrS + "%"
        endif
        (TempSM4)->(DbSkip())
    end    
    IF !Empty(mv_par01)
         oReport:SetTitle(oReport:Title()+" - Filiais : "+mv_par01+" // Periodo de "+dtoc(MV_PAR02)+" ate "+dtoc(MV_PAR03))
    else
         oReport:SetTitle(oReport:Title()+" - Filial de "+mv_par08+" ate "+mv_par09+" // Periodo "+dtoc(MV_PAR02)+" ate "+dtoc(MV_PAR03))
    endif
    /*/
    -------------------------------------------------------------------------
    | Memória de Cálculo Consolidado                                        |
    -------------------------------------------------------------------------
    /*/
    if (mv_par04=1 .and. mv_par05=1)
        oSection1 := oReport:Section(1)
        oSection2 := oReport:Section(2)
        oSection3 := oReport:Section(3)
        oSection4 := oReport:Section(4)
        oSection5 := oReport:Section(5)
        oSection6 := oReport:Section(6)
        RptMemCalC(oReport,cAlias,cAlias1,cAlias2,cNomeRel)
    /*/
    -------------------------------------------------------------------------
    | Memória de Cálculo Analítico                                          |
    -------------------------------------------------------------------------
    /*/
    elseIf (mv_par04=1 .and. mv_par05=2)

        oSection1 := oReport:Section(1)
        oSection2 := oReport:Section(1):Section(1)
        oSection3 := oReport:Section(2)

        // Funcao para pre-formatar a clausula "IN" da Consulta
        MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmp    := "% D2_FILIAL " + mv_par01 + "%"
            cEmp    := alltrim(StrTran(cEmp,"( IN","IN"))
            cEmp    := alltrim(StrTran(cEmp,"))",")"))
            cEmpEnt := "% D1_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmp    := "% D2_FILIAL = '" + xFilial("SD2") + "' %"
                cEmpEnt := "% D1_FILIAL = '" + xFilial("SD1") + "' %"
            Else
                cEmp    := "% D2_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
                cEmpEnt := "% D1_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        oSection1:BeginQuery()
            
        BeginSql Alias cAlias1

            SELECT * FROM 
            (
                SELECT
                       'A'                              AS ORDEM,
                       D2_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(+) Receita Tributável '        AS RECEITA,
                       SUM(D2_BASIMP5)                  AS RECEITA_TRIB,
                       SUM(D2_VALIMP6)                  AS PIS_TRIB,
                       SUM(D2_VALIMP5)                  AS COFINS_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON D2_FILIAL = M0_CODFIL
                 WHERE 
                       %EXP:cEmp% 
                       AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                       //AND D2_XOPER = '01' 
                       AND %EXP:cVndS%
                       AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0) 
                       AND SD2.D_E_L_E_T_ = ' '
                 GROUP BY D2_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'B'                              AS ORDEM,
                       F1_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(-) Devoluções de Vendas '      AS RECEITA, 
                       SUM(D1_BASIMP5) * -1   AS DEV_VENDA,
                       SUM(D1_VALIMP6) * -1             AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1             AS COFINS_TRIB
                  FROM SF1010 SF1
                 INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
                 INNER JOIN SYS_COMPANY ON D1_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER IN ('D6','D7')
                   AND %EXP:cDevE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
              GROUP BY F1_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'C'                              AS ORDEM,
                       F1_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(-) Compras com Crédito '       AS RECEITA, 
                       SUM(D1_BASIMP5) * -1   AS CMP_CREDITO,
                       SUM(D1_VALIMP6) * -1             AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1             AS COFINS_TRIB
                  FROM SF1010 SF1
                 INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE  
                 INNER JOIN SYS_COMPANY ON D1_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = '01'
                   AND %EXP:cCmpE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
              GROUP BY F1_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'D'                              AS ORDEM,
                       D2_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(+) Devoluções de Compras '     AS RECEITA,
                       SUM(D2_BASIMP5)                    AS DEV_COMPRA,
                       SUM(D2_VALIMP6)                  AS PIS_TRIB,
                       SUM(D2_VALIMP5)                  AS COFINS_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON D2_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('D1')
                   AND %EXP:cDecS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0) 
                   AND SD2.D_E_L_E_T_ = ' '
              GROUP BY D2_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'E'                                  AS ORDEM,
                       D2_FILIAL || ' - ' || M0_FILIAL      AS FILIAL,
                       '(+) Receita de Fretes e Despesas '  AS RECEITA,
                      (SUM(D2_DESPESA)+ SUM(D2_VALFRE))     AS REC_FRE_DSP,
                       SUM(D2_VALIMP6)                      AS PIS_TRIB,
                       SUM(D2_VALIMP5)                      AS COFINS_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON D2_FILIAL = M0_CODFIL
                 WHERE
                   %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND SD2.D_E_L_E_T_ = ' '
              GROUP BY D2_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'F'                              AS ORDEM,
                       F1_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(-) Créditos com CTEs '         AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1             AS CRE_CTE,
                       SUM(D1_VALIMP6) * -1             AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1             AS COFINS_TRIB
                  FROM SF1010 SF1
                 INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE   
                 INNER JOIN SYS_COMPANY ON D1_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'FR'
                   AND %EXP:cCteE%
                   AND F1_STATUS = 'A' 
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
              GROUP BY F1_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'G'                              AS ORDEM,
                       D2_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(+) Anulação de Frete '         AS RECEITA,
                       //SUM(D2_BASIMP5)                    AS ANL_FRETE,
                       SUM(D2_TOTAL)           AS ANL_FRETE,
                       ROUND(SUM(D2_TOTAL) * 0.0165,2)  AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL) * 0.076,2)  AS COFINS_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON D2_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND D2_XOPER IN ('FA')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '
              GROUP BY D2_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'H'                              AS ORDEM,
                       F1_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(-) Despesas com Energia '      AS RECEITA,
                       SUM(D1_BASIMP5)   * -1             AS DSP_ENERGIA,
                       SUM(D1_VALIMP6) * -1             AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1             AS COFINS_TRIB
                  FROM SF1010 SF1
                 INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE    
                 INNER JOIN SYS_COMPANY ON D1_FILIAL = M0_CODFIL
                 WHERE
                       %EXP:cEmpEnt%
                   AND D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'CE'
                   AND %EXP:cEneE%
                   AND F1_STATUS = 'A' 
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '
              GROUP BY F1_FILIAL,M0_FILIAL

                UNION

                SELECT
                       'I'                              AS ORDEM,
                       D2_FILIAL || ' - ' || M0_FILIAL  AS FILIAL,
                       '(+) Perda/Roubo/Deterioração '  AS RECEITA,
                       SUM(D2_TOTAL)                    AS PERDA_ROUBO,
                       ROUND(SUM(D2_TOTAL)*0.0165,2)    AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL)*0.076,2)     AS COFINS_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON D2_FILIAL = M0_CODFIL
                 INNER JOIN SB1010 ON  '0201' = B1_FILIAL AND D2_COD = B1_COD
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('93')
                   AND %EXP:cPrdS%
                   AND B1_GRTRIB IN ('025','065','088','089','090','091','100','130','150','180','315','365','665','660','680','685')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '
              GROUP BY D2_FILIAL,M0_FILIAL

            )
            ORDER BY FILIAL, ORDEM
        EndSql

        oSection1:EndQuery()

        nTotReg := (cAlias1)->(LastRec())
	    oReport:SetMeter(nTotReg)

	    (cAlias1)->(DbGotop())

        oSection1:Init()

	    While !oReport:Cancel() .and. (cAlias1)->(!Eof())

       	    oReport:IncMeter()

            cRecFilial := (cAlias1)->filial

            oSection1:Cell("FILIAL"		):SetValue((cAlias1)->Filial)
            oSection1:PrintLine()
                
            oSection2:Init()
            while (cAlias1)->filial=cRecFilial .and. (cAlias1)->(!Eof())

                oSection2:Cell("RECEITA"        ):SetValue((cAlias1)->receita)
                oSection2:Cell("RECEITA_TRIB"	):SetValue((cAlias1)->receita_trib)
                oSection2:Cell("PIS_TRIB"		):SetValue((cAlias1)->pis_trib)
                oSection2:Cell("COFINS_TRIB"	):SetValue((cAlias1)->cofins_trib)
                
                oSection2:PrintLine()

                DbSelectArea(cAlias1)
                (cAlias1)->(DbSkip())
            EndDo
        EndDo

	    oSection1:Finish()
	    oSection2:Finish()

        If Select(cAlias1) != 0
            DbSelectArea(cAlias1)
            (cAlias1)->(DbCloseArea())
        EndIf

        oSection3:BeginQuery()

        BeginSql Alias cAlias2

            SELECT * FROM 
            (
                SELECT
                       'A'                       AS ORDEM,
                       '(+) Receita Tributável ' AS RECEITA,
                       SUM(D2_BASIMP5)             AS RECEITA_TRIB,
                       SUM(D2_VALIMP6)           AS PIS_TRIB,
                       SUM(D2_VALIMP5)           AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE 
                       %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER = '01' 
                   AND %EXP:cVndS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'B'                          AS ORDEM,
                       '(-) Devoluções de Vendas '  AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1         AS DEV_VENDA,
                       SUM(D1_VALIMP6) * -1         AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1         AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE    
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER IN ('D6','D7')
                   AND %EXP:cDevE%
                   AND F1_STATUS = 'A' 
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '
                
                UNION

                SELECT
                       'C'                          AS ORDEM,
                       '(-) Compras com Crédito '   AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1         AS CMP_CREDITO,
                       SUM(D1_VALIMP6) * -1         AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1         AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE    
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = '01'
                   AND %EXP:cCmpE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'D'                          AS ORDEM,
                       '(+) Devoluções de Compras ' AS RECEITA,
                       SUM(D2_BASIMP5)                AS DEV_COMPRA,
                       SUM(D2_VALIMP6)              AS PIS_TRIB,
                       SUM(D2_VALIMP5)              AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('D1')
                   AND %EXP:cDecS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'E'                                  AS ORDEM,
                       '(+) Receita de Fretes e Despesas '  AS RECEITA,
                      (SUM(D2_DESPESA)+ SUM(D2_VALFRE))     AS REC_FRE_DSP,
                       SUM(D2_VALIMP6)                      AS PIS_TRIB,
                       SUM(D2_VALIMP5)                      AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%                        
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'F'                      AS ORDEM,
                       '(-) Créditos com CTEs ' AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1     AS CRE_CTE,
                       SUM(D1_VALIMP6) * -1     AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1     AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'FR'
                   AND %EXP:cCteE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                                 
                   AND SF1.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'G'                      AS ORDEM,
                       '(+) Anulação de Frete ' AS RECEITA,
                       SUM(D2_TOTAL)            AS ANL_FRETE,
                       ROUND(SUM(D2_TOTAL) * 0.0165,2) AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL) * 0.076,2) AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND D2_XOPER IN ('FA')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)          // ALTERACAO SOLICITADA POR TEREZA PARA TRAZER TODAS AS ANULACOES DE FRETE                                        
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'H'                          AS ORDEM,
                       '(-) Despesas com Energia '  AS RECEITA ,
                       SUM(D1_BASIMP5)   * -1         AS DEV_VENDA,
                       SUM(D1_VALIMP6) * -1         AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1         AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'CE'
                   AND %EXP:cEneE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)
                   AND SF1.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'I'                              AS ORDEM,
                       '(+) Perda/Roubo/Deterioração '  AS RECEITA,
                       SUM(D2_TOTAL)                    AS RECEITA_DSP_FRE,
                       ROUND(SUM(D2_TOTAL)*0.0165,2)    AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL)*0.076,2)     AS COFINS_TRIB
                  FROM SD2010 SD2
                  INNER JOIN SB1010 ON  '0201' = B1_FILIAL AND D2_COD = B1_COD
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('93')
                   AND %EXP:cPrdS%
                   AND B1_GRTRIB IN ('025','065','088','089','090','091','100','130','150','180','315','365','665','660','680','685')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)
                   AND SD2.D_E_L_E_T_ = ' '
            )
            ORDER BY ORDEM
        EndSql

        oSection3:EndQuery()

        oReport:SetMeter((cAlias2)->(RecCount()))
        oSection3:Print()
            
        oSection3:Finish()

        If Select(cAlias1) != 0
            DbSelectArea(cAlias1)
            (cAlias1)->(DbCloseArea())
        EndIf

        If Select(cAlias2) != 0
            DbSelectArea(cAlias2)
            (cAlias2)->(DbCloseArea())
        EndIf
    /*/
    -------------------------------------------------------------------------
    | Resumo Filiais Consolidado                                            |
    -------------------------------------------------------------------------
    /*/
    elseif (mv_par04=2 .and. mv_par05=1)

        oSection1 := oReport:Section(1)

        // Funcao para pre-formatar a clausula "IN" da Consulta
	    MakeSqlExpr("RFIS015")

        //Tratamento das Empresas
        cEmp := "% D2_FILIAL LIKE '0201%' %"
        cEmpEnt := "% D1_FILIAL LIKE '0201%' %"

        oSection1:BeginQuery()
            
        BeginSql Alias cAlias

            SELECT * FROM 
            (
                SELECT
                       'A'                         AS ORDEM,
                       M0_FILIAL                   AS FILIAL,
                       '(+) Receita Tributável '   AS RECEITA,
                       D2_BASIMP5                  AS RECEITA_TRIB
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D2_FILIAL
                 WHERE 
                       %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER = '01' 
                   AND %EXP:cVndS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0) 
                   AND SD2.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(RECEITA_TRIB)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION

            SELECT * FROM 
            (
                SELECT
                       'B'                          AS ORDEM,
                       M0_FILIAL                    AS FILIAL,
                        '(-) Devoluções de Vendas ' AS RECEITA, 
                       D1_BASIMP5 * -1                AS DEV_VENDA
                  FROM SF1010 SF1
                 INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D1_FILIAL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER IN ('D6','D7')
                   AND %EXP:cDevE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(DEV_VENDA)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION

            SELECT * FROM 
            (
                SELECT
                       'C'                         AS ORDEM,
                       M0_FILIAL                   AS FILIAL,
                       '(-) Compras com Crédito '  AS RECEITA, 
                       (D1_BASIMP5) * -1               AS CMP_CREDITO
                  FROM SF1010 SF1
                 INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D1_FILIAL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = '01'
                   AND %EXP:cCmpE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(CMP_CREDITO)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION

            SELECT * FROM 
            (
                SELECT
                       'D'                             AS ORDEM,
                       M0_FILIAL                       AS FILIAL,
                       '(+) Devoluções de Compras '    AS RECEITA,
                       D2_BASIMP5                        AS CMP_DEVOL
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D2_FILIAL
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('D1')
                   AND %EXP:cDecS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0) 
                   AND SD2.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(CMP_DEVOL)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION

            SELECT * FROM 
            (
                SELECT
                       'E'                                AS ORDEM,
                       M0_FILIAL                          AS FILIAL,
                       '(+) Receita Fretes e Despesas '   AS RECEITA,
                      (D2_DESPESA + D2_VALFRE)            AS REC_FRE_DSP
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D2_FILIAL
                 WHERE
                       %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND SD2.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(REC_FRE_DSP)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION 

            SELECT * FROM 
            (
                SELECT
                       'F'                         AS ORDEM,
                       M0_FILIAL                   AS FILIAL,
                       '(-) Créditos com CTEs '    AS RECEITA, 
                       D1_BASIMP5 * -1               AS CRE_CTE
                  FROM SF1010 SF1
                 INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D1_FILIAL
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'FR'
                   AND %EXP:cCteE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0) 
                   AND SF1.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(CRE_CTE)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION
                
            SELECT * FROM 
            (
                SELECT
                       'G'                         AS ORDEM,
                       M0_FILIAL                   AS FILIAL,
                       '(+) Anulação de Frete '    AS RECEITA,
                       D2_TOTAL                    AS ANULA_FRETE
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D2_FILIAL
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND D2_XOPER IN ('FA')
                  // AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)    // ALTERACAO SOLICITADA POR TEREZA PARA TRAZER TODAS AS ANULACOES DE FRETE             
                   AND SD2.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(ANULA_FRETE)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION 

            SELECT * FROM 
            (
                SELECT
                       'H'                         AS ORDEM,
                       M0_FILIAL                   AS FILIAL,
                       '(-) Despesas com Energia ' AS RECEITA,
                       D1_BASIMP5 * -1               AS DSP_ENERGIA
                  FROM SF1010 SF1
                 INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D1_FILIAL                    
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'CE'
                   AND %EXP:cEneE%
                   AND F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(DSP_ENERGIA)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE

            UNION                

            SELECT * FROM 
            (
                SELECT
                       'I'                          AS ORDEM,
                       M0_FILIAL                    AS FILIAL,
                       '(+) Perda/Roubo/Deteriora ' AS RECEITA,
                       D2_TOTAL                     AS PERDAS
                  FROM SD2010 SD2
                 INNER JOIN SYS_COMPANY ON M0_CODFIL = D2_FILIAL 
                 INNER JOIN SB1010 ON  '0201' = B1_FILIAL AND D2_COD = B1_COD                   
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('93')
                   AND %EXP:cPrdS%
                   AND B1_GRTRIB IN ('025','065','088','089','090','091','100','130','150','180','315','365','665','660','680','685')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '
            )
                DATATABLE 
                PIVOT
            (
                SUM(PERDAS)
                FOR FILIAL IN ('ANL MATRIZ' AS MZ, 'ANL BA' AS BA, 'ANL CE' AS CE, 'ANL PE' AS PE, 'ANL RN' AS RN, 'ANL PB' AS PB, 'ANL PI' AS PI, 'ANL SE' AS SE) 
            )
            PIVOTTABLE
        EndSql

        oSection1:EndQuery()

        DbSelectArea(cAlias)
        (cAlias)->(DbGoTop())
        oReport:SetMeter((cAlias)->(RecCount()))
        (cAlias)->(DbGoTop())
            
        oSection1:Init()
				
        While !oReport:Cancel() .And. !(cAlias)->(Eof())
		    oReport:IncMeter()
            oSection1:Cell("MZ"):SetValue((cAlias)->MZ)			
            oSection1:Cell("BA"):SetValue((cAlias)->BA)						
            oSection1:Cell("CE"):SetValue((cAlias)->CE)						
            oSection1:Cell("PE"):SetValue((cAlias)->PE)						
            oSection1:Cell("RN"):SetValue((cAlias)->RN)						
            oSection1:Cell("PB"):SetValue((cAlias)->PB)						
            oSection1:Cell("PI"):SetValue((cAlias)->PI)						
            oSection1:Cell("SE"):SetValue((cAlias)->SE)						
            oSection1:Cell("TOTAL"):SetValue((cAlias)->MZ+(cAlias)->BA+(cAlias)->CE+(cAlias)->PE+(cAlias)->RN+(cAlias)->PB+(cAlias)->PI+(cAlias)->SE)
            oSection1:PrintLine()
            dbSkip()
        EndDo
        oSection1:Finish()
        oReport:PrintTotal()
        //oReport:=DefMemCalC(cAlias,oReport,cNomeRel,oSection1,oSection2,oSection3,oSection4,oSection5)       
        //
        /*cNomeRel := "Relatorio Apuração PIS/COFINS - Memória de Cálculo Consolidado"

        oReport := TReport():New("RFIS015",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Relatório de Apuração PIS/Cofins")        
        oReport:SetPortrait()
        oReport:SetLineHeight(50)
        oReport:nFontBody := 10 
        oReport:init()*/
        oSection1 := TRSection():New(oReport,cNomeRel,cAlias,,,,"Receita Tributária Fiscal",,,,,,,,,)

        TRCell():New(oSection1,"RECEITA"	    ,cAlias ,"CONSOLIDAÇÃO" ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection1,"RECEITA_TRIB"   ,cAlias ,"BASE CÁLCULO" ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"PIS_TRIB"       ,cAlias ,"PIS"	        ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"COFINS_TRIB"    ,cAlias ,"COFINS"	    ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
         
        oSection2 := TRSection():New(oReport,cNomeRel,,,,,"Receita Tributária Fiscal",,,,,,,,,,,0)

        TRCell():New(oSection2,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection2,"APURA_TRIB"     ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"APURA_PIS"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"APURA_COF"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         
            
        oSection3 := TRSection():New(oReport,cNomeRel,,,,,"Receita Financeira",,,,,,,,,,,0)

        TRCell():New(oSection3,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection4 := TRSection():New(oReport,cNomeRel,,,,,"Despesa Aluguel",,,,,,,,,,,0)

        TRCell():New(oSection4,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection6 := TRSection():New(oReport,cNomeRel,,,,,"ST Transferencias",,,,,,,,,,,0)

        TRCell():New(oSection6,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection5 := TRSection():New(oReport,cNomeRel,,,,,"Total Consolidado",,,,,,,,,)

        TRCell():New(oSection5,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection5,"TCONS_TRIB"     ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection5,"TCONS_PIS"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection5,"TCONS_COF"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        //
        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf
        RptMemCalC(oReport,cAlias,cAlias1,cAlias2,CNOMEREL)

        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf

    /*/
    -------------------------------------------------------------------------
    | Resumo Filiais Analitico                                              |
    -------------------------------------------------------------------------
    /*/
    elseif mv_par04=2 .and. mv_par05=2
    /*/
    -------------------------------------------------------------------------
    | Resumo Entradas Consolidado                                           |
    -------------------------------------------------------------------------
    /*/
    elseif mv_par04=3 .and. mv_par05=1

        oSection1 := oReport:Section(1)
        oSection2 := oReport:Section(1):Section(1)
        oSection3 := oReport:Section(1):Section(1):Section(1)

        //Funcao para pre-formatar a clausula "IN" da Query
        MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmpEnt := "% D1_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmpEnt := "% D1_FILIAL = '" + xFilial("SD1") + "' %"
            Else
                cEmpEnt := "% D1_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        oSection1:BeginQuery()

        BeginSql Alias cAlias

            SELECT  
                   'A'                 AS ORDEM, 
                   'COMPRAS'           AS TIPO, 
                   'TOTAL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_TOTAL + SD1.D1_VALIPI) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_= ' '
               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
              //  AND SD1.D1_XOPER = '01' 
               AND %EXP:cCmpE%
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
            GROUP BY SD1.D1_CF
   
            UNION

            SELECT  
                   'B'                 AS ORDEM, 
                    'COMPRAS'           AS TIPO, 
                   'TRIBUTAVEL'        AS RECEITA, 
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_BASIMP5) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES                        
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
             //  AND SD1.D1_XOPER = '01'
               AND %EXP:cCmpE%
               AND SF1.F1_STATUS = 'A'
               AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION

            SELECT 
                   'C'                 AS ORDEM, 
                   'DEVOLUCAO VENDA'   AS TIPO,
                   'TOTAL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_TOTAL + SD1.D1_VALIPI) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
               //AND SD1.D1_XOPER IN ('D6','D7')
               AND %EXP:cDevE%
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF

            UNION

            SELECT  
                   'D'                 AS ORDEM, 
                   'DEVOLUCAO VENDA'   AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_BASIMP5) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
             //  AND SD1.D1_XOPER IN ('D6','D7')
               AND %EXP:cDevE%
               AND SF1.F1_STATUS = 'A'
               AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION

            SELECT 
                   'E'                 AS ORDEM, 
                   'BONIFICAÇÃO'       AS TIPO,
                   'TOTAL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_TOTAL + SD1.D1_VALIPI) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
             //  AND SD1.D1_XOPER IN ('O6','10')
               AND %EXP:cBneE% 
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION 

            SELECT 
                   'F'                 AS ORDEM, 
                   'BONIFICAÇÃO'       AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   0  AS VLR_CONTABIL, 
                   0  AS VLR_PRODUTOS, 
                   0  AS VLR_DESPESA, 
                   0  AS VLR_FRETE, 
                   0  AS VLR_ICM, 
                   0  AS ICMS_AJU, 
                   0  AS VLR_ICMRET, 
                   0  AS VLR_IPI, 
                   0  AS BASE_CALC 
              FROM SD1010 SD1 
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER IN ('O6','10')
               AND %EXP:cBneE% 
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' ' 
          GROUP BY SD1.D1_CF
                
            UNION 

            SELECT 
                   'G'                 AS ORDEM, 
                   'CTE'               AS TIPO,
                   'TOTAL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_TOTAL + SD1.D1_VALIPI) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'FR'
               AND %EXP:cCteE% 
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 
                

            UNION 

            SELECT 
                   'H'                 AS ORDEM, 
                   'CTE'               AS TIPO,
                   'TRIBUTAVEL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_BASIMP5) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'FR'
               AND %EXP:cCteE% 
               AND SF1.F1_STATUS = 'A'
               AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION

            SELECT 
                   'I'                 AS ORDEM, 
                   'ENERGIA ELETRICA'  AS TIPO,
                   'TOTAL'             AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_TOTAL + SD1.D1_VALIPI) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '
               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               AND %EXP:cEneE% 
               AND SF1.F1_STATUS = 'A'
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION

            SELECT 
                   'J'                 AS ORDEM, 
                   'ENERGIA ELETRICA'  AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_BASIMP5) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '
               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               AND %EXP:cEneE% 
               AND SF1.F1_STATUS = 'A'
               AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            UNION

            SELECT 
                   'K'                 AS ORDEM, 
                   'Transferencias'  AS TIPO,
                   'TOTAL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_ICMSRET) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt%
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               AND %EXP:cTraE% 
               AND SF1.F1_STATUS = 'A'
               and not D1_CF in ('2209','1209')
               //AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 
            UNION
            SELECT 
                   'L'                 AS ORDEM, 
                   'Transferencias'  AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_ICMSRET) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,Z20010 Z20,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt%
               AND SB1.B1_GRTRIB=Z20.Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' and Z20_PISCOF='N'    
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               AND %EXP:cTraE% 
               AND SF1.F1_STATUS = 'A'
               and not D1_CF in ('2209','1209')
               //AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 
            UNION

            SELECT 
                   'M'                 AS ORDEM, 
                   'Transf/Devol'  AS TIPO,
                   'TOTAL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_ICMSRET) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt%
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               //AND %EXP:cTraE% 
               AND SF1.F1_STATUS = 'A'
               and D1_CF in ('2209','1209')
               //AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 
            UNION
            SELECT 
                   'N'                 AS ORDEM, 
                   'Transf/Devol'  AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD1.D1_CF           AS CFOP, 
                   //SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_DESPESA + SD1.D1_VALFRE + CASE WHEN F4_MKPSOL='1' OR F4_INCSOL='N' THEN 0 ELSE SD1.D1_ICMSRET END ) AS VLR_CONTABIL, 
                   SUM(FT_VALCONT) AS VLR_CONTABIL, 
                   SUM(SD1.D1_TOTAL)   AS VLR_PRODUTOS, 
                   SUM(SD1.D1_DESPESA) AS VLR_DESPESA, 
                   SUM(SD1.D1_VALFRE)  AS VLR_FRETE, 
                   SUM(SD1.D1_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SD1.D1_ICMSRET=0 AND SF4.F4_CREDICM='S'  THEN SD1.D1_VALICM
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD1.D1_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD1.D1_VALIPI)  AS VLR_IPI, 
                   SUM(SD1.D1_ICMSRET) AS BASE_CALC 
              FROM SD1010 SD1,SB1010 SB1,SF4010 SF4,Z20010 Z20,SFT010 FT
              INNER JOIN SF1010 SF1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
             WHERE 
                   %EXP:cEmpEnt%
               AND SB1.B1_GRTRIB=Z20.Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' and Z20_PISCOF='N'    
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD1.D1_COD
               and ft_filial=d1_filial and  ft_nfiscal=d1_doc and ft_serie=d1_serie and d1_fornece=ft_cliefor and ft_loja=d1_loja 
               and ft_produto=d1_cod and ft_item=d1_item
               and ft.d_e_l_e_t_=' '

               and SF4.F4_FILIAL=SD1.D1_FILIAL
               AND SF4.F4_CODIGO=SD1.D1_TES       
               AND SD1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            //   AND SD1.D1_XOPER = 'CE'
               //AND %EXP:cTraE% 
               AND SF1.F1_STATUS = 'A'
               and D1_CF in ('2209','1209')
               //AND (SD1.D1_VALIMP5 > 0 AND SD1.D1_VALIMP6 > 0) 
               AND SD1.D_E_L_E_T_ = ' ' 
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD1.D1_CF 

            ORDER BY ORDEM,TIPO,RECEITA,CFOP
    
        EndSql

        oSection1:EndQuery()

        dbSelectArea(cAlias)
	    (cAlias)->(dbGoTop())
	
        oReport:SetMeter((cAlias)->(RecCount()))
        

        While !Eof()
		
		    If oReport:Cancel()
            	Exit
		    EndIf
        	oReport:IncMeter()	

	        // Inicializo a primeira seção
            oSection1:Init()

            cTipo := (cAlias)->tipo
        	IncProc("Imprimindo Tipo "+alltrim((cAlias)->tipo))

        	// Imprimo a primeira seção				
		    oSection1:Cell("TIPO"):SetValue((cAlias)->tipo)
		    oSection1:Printline()

            // Inicializo a segunda seção
            oSection2:Init()
		    cRec := (cAlias)->receita
        	IncProc("Imprimindo Receita "+alltrim((cAlias)->receita))
                
             // Imprimo a primeira seção				
		    oSection2:Cell("RECEITA"):SetValue((cAlias)->receita)
		    oSection2:Printline()

            oReport:ThinLine()

            oSection3:Init()

      		//Verifico se o codigo do Tipo e Receita é o mesmo, se sim, imprimo os CFops
            While (cAlias)->receita == cRec
                       
                oReport:IncMeter()		
            
                IncProc("Imprimindo CFOP "+alltrim((cAlias)->cfop))

                oSection3:Cell("VLR_CONTABIL"):SetValue((cAlias)->VLR_CONTABIL)
                oSection3:Cell("VLR_PRODUTOS"):SetValue((cAlias)->VLR_PRODUTOS)
                oSection3:Cell("VLR_DESPESA"):SetValue((cAlias)->VLR_DESPESA)			
                oSection3:Cell("VLR_FRETE"):SetValue((cAlias)->VLR_FRETE)			
                oSection3:Cell("VLR_ICM"):SetValue((cAlias)->VLR_ICM)			
                oSection3:Cell("VLR_ICMRET"):SetValue((cAlias)->VLR_ICMRET)			
                oSection3:Cell("VLR_IPI"):SetValue((cAlias)->VLR_IPI)			
                oSection3:Cell("BASE_CALC"):SetValue((cAlias)->BASE_CALC)			
                oSection3:Printline()
        
                (cAlias)->(dbSkip())

                cTpAtual := (cAlias)->tipo
            EndDo		

 		    //finalizo a segunda seção para que seja reiniciada para o proximo registro
 	        oSection3:Finish()
 		        
 	        // Finalizo a segunda seção
	        oSection2:Finish()
            oReport:ThinLine()
            if cTipo <> cTpAtual
                oReport:EndPage()
            endif
   	        // Finalizo a primeira seção
	        oSection1:Finish()
	    Enddo

        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf

    /*/
    -------------------------------------------------------------------------
    | Resumo Entradas Analítico                                             |
    -------------------------------------------------------------------------
    /*/
    elseif mv_par04=3 .and. mv_par05=2

        oSection1 := oReport:Section(1)
/*        oSection2 := oReport:Section(1):Section(1)
        oSection3 := oReport:Section(1):Section(1):Section(1)
        oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
*/
        //Funcao para pre-formatar a clausula "IN" da Query
        MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmpEnt := "% D1_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmpEnt := "% D1_FILIAL = '" + xFilial("SD1") + "' %"
            Else
                cEmpEnt := "% D1_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        BeginSql Alias  cAlias
        SELECT D1_FILIAL EMPRESA,F1_ESPECIE ESPECIE,D1_EMISSAO EMISSAO,D1_DTDIGIT RECEBIMENTO,D1_TES TIPO_ENTRADA,
        D1_CF COD_FISCAL, D1_DOC DOCUMENTO,
        D1_SERIE SERIE,D1_FORNECE FORN_COD,A2_NOME FORN_NOME,A2_CGC FORN_CNPJ,A2_EST FORN_UF,
        B1_GRTRIB GRUPO_TRIB,X5_DESCRI GR_TRIB_DESCRICAO,B1_GRPTI GRP_TRIB_TI,Z20_PISCOF PROD_MONO,F4_CSTPIS CST_PIS,F4_CSTCOF CST_COFINS,
        D1_ITEM PROD_ITEM,B1_POSIPI PROD_NCM,B1_EX_NCM EX_NCM,D1_COD PROD_COD, B1_DESC PROD_DESCRICAO,B1_XSEG SEGUIMENTO,D1_XOPER TP_OPER,
        D1_QUANT QUANT, D1_VUNIT VLR_UNITARIO, D1_TOTAL VALOR_TOTAL,
        D1_TOTAL + D1_VALIPI + D1_DESPESA + D1_VALFRE + D1_ICMSRET VLR_CONTABIL,
        D1_VALIPI VALOR_IPI, D1_TOTAL+D1_VALIPI TOTAL_C_IPI,
        D1_VALICM VALOR_ICMS,D1_PICM ALIQ_ICMS,
        (CASE 
            WHEN D1_ICMSRET=0 AND F4_CREDICM='S'  THEN D1_VALICM
            else 0 end
            ) AS ICMS_AJU,
        F4_INCSOL TES_AGREGA_SOL , D1_ICMSRET VAL_ICMS_ST,
        D1_TOTAL+D1_VALIPI+D1_ICMSRET VAL_TOTAL_C_ST,
        (CASE TRIM(F4_PISCOF) WHEN '1' THEN 'PIS' WHEN '2' THEN 'COFINS' WHEN '3' THEN 'Ambos' WHEN '4' THEN 'Nao Considera' ELSE 'NA' END) TES_GERA_PISCOF,
        (CASE TRIM(F4_PISCRED) WHEN '1' THEN 'Credita' WHEN '2' THEN 'Debita' WHEN '3' THEN 'Nao Calcula' WHEN '4' THEN 'Calcula' WHEN '5' THEN 'Exclusão de Base' ELSE 'NA' END) TES_CRED_PISCOF,
        D1_ALQIMP6 ALIQ_PIS, D1_BASIMP6 BASE_PIS, D1_VALIMP6 VALOR_PIS, D1_BASIMP5 BASE_COF ,D1_ALQIMP5 ALIQ_COF, D1_VALIMP5 VALOR_COF,
        D1_DESPESA VLR_NF_DESPESAS, D1_VALFRE VLR_NF_FRETE,
        (SELECT F8_TRANSP||'/'||F8_LOJTRAN
            FROM SF8010 F8
            //NOTA DE FRETE
            LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

            //NOTA ORIGINAL
            WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
                AND F8_TIPO='F'
                AND D1F.D1_COD=D1.D1_COD 
                AND F8.D_E_L_E_T_=' '
                AND ROWNUM = 1
            ) FRETE_FORN_LOJA,
        (SELECT F8_NFDIFRE
            FROM SF8010 F8
            //NOTA DE FRETE
            LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

            //NOTA ORIGINAL
            WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
                AND F8_TIPO='F'
                AND D1F.D1_COD=D1.D1_COD 
                AND F8.D_E_L_E_T_=' '
                AND ROWNUM = 1
            ) FRETE_CONHECIMENTO,
        (SELECT F8_SEDIFRE
            FROM SF8010 F8
            //NOTA DE FRETE
            LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

            //NOTA ORIGINAL
            WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
                AND F8_TIPO='F'
                AND D1F.D1_COD=D1.D1_COD 
                AND F8.D_E_L_E_T_=' '
                AND ROWNUM = 1
            ) FRETE_SERIE,
        ((SELECT COALESCE(D1F.D1_TOTAL,0)
            FROM SF8010 F8
            //NOTA DE FRETE
            LEFT JOIN SD1010 D1F ON D1F.D1_FILIAL=F8.F8_FILIAL AND D1F.D1_DOC=F8.F8_NFDIFRE AND D1F.D1_SERIE=F8.F8_SEDIFRE AND D1F.D1_FORNECE=F8.F8_TRANSP AND D1F.D1_LOJA=F8.F8_LOJTRAN AND D1F.D_E_L_E_T_=' '

            //NOTA ORIGINAL
            WHERE D1.D1_FILIAL=F8.F8_FILIAL AND D1.D1_DOC=F8.F8_NFORIG AND D1.D1_SERIE=F8.F8_SERORIG AND D1.D1_FORNECE=F8.F8_FORNECE AND D1.D1_LOJA=F8.F8_LOJA AND D1.D_E_L_E_T_=' '
                AND F8_TIPO='F'
                AND D1F.D1_COD=D1.D1_COD 
                AND F8.D_E_L_E_T_=' '
                AND ROWNUM = 1
            )/(Select sum(D1_QUANT) from SD1010 D1C WHERE  D1C.D1_FILIAL=D1.D1_FILIAL AND D1C.D1_DOC=D1.D1_DOC AND D1C.D1_SERIE=D1.D1_SERIE AND D1C.D1_FORNECE=D1.D1_FORNECE AND D1C.D1_LOJA=D1.D1_LOJA AND D1C.D1_COD=D1.D1_COD AND D1C.D_E_L_E_T_=' '))*D1_QUANT VLR_FRETE_FOB,
        D1_CUSTO CUSTO,
        F1_CHVNFE CHAVE_NFE,F1_VALBRUT VL_TOTAL_NF
        FROM SD1010 D1
        LEFT JOIN SF1010 F1 ON F1_FILIAL=D1_FILIAL AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1_DTDIGIT=D1_DTDIGIT AND F1.D_E_L_E_T_=' ' 
        LEFT JOIN SB1010 B1 ON B1_COD=D1_COD AND B1.D_E_L_E_T_=' ' 
        LEFT JOIN SX5010 X5 ON X5_TABELA='21' AND X5_CHAVE=B1_GRTRIB AND X5.D_E_L_E_T_=' ' 
        LEFT JOIN SA2010 A2 ON A2_COD=D1_FORNECE AND A2_LOJA=D1_LOJA AND A2.D_E_L_E_T_=' ' 
        LEFT JOIN SF4010 F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' 
        LEFT JOIN Z20010 Z20 ON B1_GRTRIB=Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' 

        WHERE
//            %Exp:cWhere%
            %EXP:cEmpEnt% 
            AND D1.D1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            AND F1.F1_STATUS = 'A'
            AND D1.D_E_L_E_T_ = ' ' 

        ORDER BY D1_DTDIGIT ,A2_NOME,D1_DOC,D1_COD

        EndSql
        oSection1:EndQuery()
        ctmpquery := oSection1:GetQuery()
        TCSetField( cAlias, 'EMISSAO', 'D', 8, 0 )
        TCSetField( cAlias, 'RECEBIMENTO', 'D', 8, 0 )

        Dbselectarea(cAlias)
        (cAlias)->(dbgotop())
        oReport:SetMeter((cAlias)->(RecCount()))
        oSection1:Print()


        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf
    /*/
    -------------------------------------------------------------------------
    | Resumo Saídas Consolidado                                             |
    -------------------------------------------------------------------------
    /*/
    elseIf mv_par04=4 .and. mv_par05=1

        oSection1 := oReport:Section(1)
        oSection2 := oReport:Section(1):Section(1)
        oSection3 := oReport:Section(1):Section(1):Section(1)
            
        //Funcao para pre-formatar a clausula "IN" da Query
        MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmp    := "% D2_FILIAL " + mv_par01 + "%"
            cEmp    := alltrim(StrTran(cEmp,"( IN","IN"))
            cEmp    := alltrim(StrTran(cEmp,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmp    := "% D2_FILIAL = '" + xFilial("SD2") + "' %"
            Else
                cEmp    := "% D2_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        oSection1:BeginQuery()

        BeginSql Alias cAlias

            SELECT  
                   'A'                 AS ORDEM, 
                   'VENDAS'            AS TIPO, 
                   'TOTAL'             AS RECEITA,
                   SD2.D2_CF           AS CFOP, 
                   SUM(SD2.D2_VALBRUT)   AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL) AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA) AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)  AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)  AS VLR_IPI, 
                   SUM(SD2.D2_TOTAL+SD2.D2_VALIPI) AS BASE_CALC 
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE 
                   %EXP:cEmp%
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER = '01' 
               AND %EXP:cVndS%
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF
    
            UNION

            SELECT  
                   'B'                 AS ORDEM, 
                   'VENDAS'            AS TIPO, 
                   'TRIBUTAVEL'        AS RECEITA, 
                   SD2.D2_CF           AS CFOP, 
                   SUM(SD2.D2_VALBRUT)   AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL) AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA) AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)  AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)  AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5) AS BASE_CALC 
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE 
                   %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER = '01' 
               AND %EXP:cVndS%
               AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0) 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF

            UNION

            SELECT  
                   'C'                 AS ORDEM, 
                   'DEVOLUCAO COMPRA'  AS TIPO,
                   'TOTAL'             AS RECEITA,
                   SD2.D2_CF           AS CFOP, 
                   SUM(SD2.D2_VALBRUT)  AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL) AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA) AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)  AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)  AS VLR_IPI, 
                   SUM(SD2.D2_TOTAL+SD2.D2_VALIPI) AS BASE_CALC 
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE 
                   %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER = 'D1' 
               AND %EXP:cDecS%
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
             GROUP BY SD2.D2_CF

            UNION

            SELECT  
                   'D'                 AS ORDEM, 
                   'DEVOLUCAO COMPRA'  AS TIPO,
                   'TRIBUTAVEL'        AS RECEITA,
                   SD2.D2_CF           AS CFOP, 
                   SUM(SD2.D2_VALBRUT)   AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL) AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA) AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)  AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)  AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET) AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)  AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5) AS BASE_CALC 
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE 
                   %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER = 'D1' 
               AND %EXP:cDecS%
               AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0) 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF

            UNION

            SELECT
                   'E'                     AS ORDEM, 
                   'PERDA/ROUBO/DETERIORA' AS TIPO,
                   'TOTAL'                 AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)       AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_TOTAL+SD2.D2_VALIPI) AS BASE_CALC 
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE
                   %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               AND %EXP:cPrdS% 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF

            UNION 

            SELECT
                   'F'                     AS ORDEM, 
                   'PERDA/ROUBO/DETERIORA' AS TIPO,
                   'TRIBUTAVEL'            AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)     AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5)     AS BASE_CALC
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               AND %EXP:cPrdS% 
               AND B1_GRTRIB IN ('025','065','088','089','090','091','100','130','150','180','315','365','665','660','680','685')
               //AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0)                 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF

            UNION 

            SELECT
                   'G'                     AS ORDEM, 
                   'Transferencias' AS TIPO,
                   'TOTAL'            AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)     AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5)     AS BASE_CALC
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               AND %EXP:cTraS% 
               and NOT D2_CF IN ('5209','6209')
               //AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0)                 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF
            UNION
            SELECT
                   'H'                     AS ORDEM, 
                   'Transferencias' AS TIPO,
                   'TRIBUTAVEL'            AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)     AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5)     AS BASE_CALC
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4,Z20010 Z20
             WHERE %EXP:cEmp% 
               AND SB1.B1_GRTRIB=Z20.Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' and Z20_PISCOF='N'
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               AND %EXP:cTraS% 
               and NOT D2_CF IN ('5209','6209')
               //AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0)                 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF
            UNION 

            SELECT
                   'I'                     AS ORDEM, 
                   'Transf/Devol' AS TIPO,
                   'TOTAL'            AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)     AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5)     AS BASE_CALC
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4
             WHERE %EXP:cEmp% 
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               //AND %EXP:cTraS% 
               and D2_CF IN ('5209','6209')
               //AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0)                 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF
            UNION
            SELECT
                   'J'                     AS ORDEM, 
                   'Transf/Devol' AS TIPO,
                   'TRIBUTAVEL'            AS RECEITA,
                   SD2.D2_CF               AS CFOP, 
                   SUM(SD2.D2_VALBRUT) AS VLR_CONTABIL, 
                   SUM(SD2.D2_TOTAL)     AS VLR_PRODUTOS, 
                   SUM(SD2.D2_DESPESA)     AS VLR_DESPESA, 
                   SUM(SD2.D2_VALFRE)      AS VLR_FRETE, 
                   SUM(SD2.D2_VALICM)      AS VLR_ICM, 
                   SUM(CASE 
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB IN('025','065','088','089','090','091') AND SD2.D2_FILIAL IN('020101','020105') THEN SD2.D2_VALICM
                    WHEN SF4.F4_CREDICM='S' AND SB1.B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN SD2.D2_VALICM                   
                    else 0 end
                   ) AS ICMS_AJU,
                   SUM(SD2.D2_ICMSRET)     AS VLR_ICMRET, 
                   SUM(SD2.D2_VALIPI)      AS VLR_IPI, 
                   SUM(SD2.D2_BASIMP5)     AS BASE_CALC
              FROM SD2010 SD2,SB1010 SB1,SF4010 SF4,Z20010 Z20
             WHERE %EXP:cEmp% 
               AND SB1.B1_GRTRIB=Z20.Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' and Z20_PISCOF='N'
               AND SB1.B1_FILIAL= '0201'
               AND SB1.B1_COD= SD2.D2_COD
               and SF4.F4_FILIAL=SD2.D2_FILIAL
               AND SF4.F4_CODIGO=SD2.D2_TES               
               AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
            //   AND SD2.D2_XOPER IN ('93')
               //AND %EXP:cTraS% 
               and D2_CF IN ('5209','6209')

               //AND (SD2.D2_VALIMP5 > 0 AND SD2.D2_VALIMP6 > 0)                 
               AND SD2.D_E_L_E_T_ = ' '
               AND SB1.D_E_L_E_T_ = ' '
               AND SF4.D_E_L_E_T_ = ' '
          GROUP BY SD2.D2_CF

            ORDER BY ORDEM,TIPO,RECEITA,CFOP
    
        EndSql

        oSection1:EndQuery()

        dbSelectArea(cAlias)
	    (cAlias)->(dbGoTop())
	
        oReport:SetMeter((cAlias)->(RecCount()))

        While !Eof()
		
		    If oReport:Cancel()
            	Exit
		    EndIf
        	oReport:IncMeter()	

	        // Inicializo a primeira seção
            oSection1:Init()
            cTipo := (cAlias)->tipo
      		IncProc("Imprimindo Tipo "+alltrim((cAlias)->tipo))

      		// Imprimo a primeira seção				
	        oSection1:Cell("TIPO"):SetValue((cAlias)->tipo)
	        oSection1:Printline()

            // Inicializo a segunda seção
            oSection2:Init()
	        cRec := (cAlias)->receita
       		IncProc("Imprimindo Receita "+alltrim((cAlias)->receita))
                
            // Imprimo a primeira seção				
	        oSection2:Cell("RECEITA"):SetValue((cAlias)->receita)
	        oSection2:Printline()

            oReport:ThinLine()

            oSection3:Init()

      		//Verifico se o codigo do Tipo e Receita é o mesmo, se sim, imprimo os CFops
            While (cAlias)->tipo == cTipo .and. (cAlias)->receita == cRec
                        
                oReport:IncMeter()		
            
                IncProc("Imprimindo CFOP "+alltrim((cAlias)->cfop))

                oSection3:Cell("VLR_CONTABIL"):SetValue((cAlias)->VLR_CONTABIL)
                oSection3:Cell("VLR_PRODUTOS"):SetValue((cAlias)->VLR_PRODUTOS)
                oSection3:Cell("VLR_DESPESA"):SetValue((cAlias)->VLR_DESPESA)			
                oSection3:Cell("VLR_FRETE"):SetValue((cAlias)->VLR_FRETE)			
                oSection3:Cell("VLR_ICM"):SetValue((cAlias)->VLR_ICM)			
                oSection3:Cell("VLR_ICMRET"):SetValue((cAlias)->VLR_ICMRET)			
                oSection3:Cell("VLR_IPI"):SetValue((cAlias)->VLR_IPI)			
                oSection3:Cell("BASE_CALC"):SetValue((cAlias)->BASE_CALC)			
                oSection3:Printline()
        
                (cAlias)->(dbSkip())
                
                cTpAtual := (cAlias)->tipo
            EndDo		
            
	        //finalizo a segunda seção para que seja reiniciada para o proximo registro
	        oSection3:Finish()
 		       
 		    // Finalizo a segunda seção
            oSection2:Finish()
            oReport:ThinLine()

            if cTipo <> cTpAtual
                oReport:EndPage()
            endif

   		    // Finalizo a primeira seção
		    oSection1:Finish()
	    Enddo

            If Select(cAlias) != 0
                DbSelectArea(cAlias)
                (cAlias)->(DbCloseArea())
            EndIf
    /*/
    ----------------------------------------
    | Resumo Saídas Analitico (Por Filial) |
    ----------------------------------------
    /*/
    elseIf mv_par04=4 .and. mv_par05=2
        oSection1 := oReport:Section(1)
/*        oSection2 := oReport:Section(1):Section(1)
        oSection3 := oReport:Section(1):Section(1):Section(1)
        oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
*/
        //Funcao para pre-formatar a clausula "IN" da Query
        MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmpEnt := "% D2_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmpEnt := "% D2_FILIAL = '" + xFilial("SD2") + "' %"
            Else
                cEmpEnt := "% D2_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        BeginSql Alias  cAlias
        SELECT D2_FILIAL EMPRESA,F2_ESPECIE ESPECIE,D2_EMISSAO EMISSAO,D2_EMISSAO RECEBIMENTO,D2_TES TIPO_ENTRADA,
        D2_CF COD_FISCAL, D2_DOC DOCUMENTO,
        D2_SERIE SERIE,D2_CLIENTE CLIEN_COD,A1_NOME CLIEN_NOME,A1_CGC CLIEN_CNPJ,A1_EST CLIEN_UF,
        B1_GRTRIB GRUPO_TRIB,X5_DESCRI GR_TRIB_DESCRICAO,B1_GRPTI GRP_TRIB_TI,Z20_PISCOF PROD_MONO,F4_CSTPIS CST_PIS,F4_CSTCOF CST_COFINS,
        D2_ITEM PROD_ITEM,B1_POSIPI PROD_NCM,B1_EX_NCM EX_NCM,D2_COD PROD_COD, B1_DESC PROD_DESCRICAO,B1_XSEG SEGUIMENTO,D2_XOPER TP_OPER, B1_POSIPI PROD_NCM,D2_ITEM PROD_ITEM,
        D2_QUANT QUANT, D2_PRCVEN VLR_UNITARIO, D2_TOTAL VALOR_TOTAL,
        D2_VALBRUT VLR_CONTABIL,
        D2_VALIPI VALOR_IPI, D2_TOTAL+D2_VALIPI TOTAL_C_IPI,
        D2_PICM ALIQ_ICMS,D2_VALICM VALOR_ICMS,
		(CASE 
            WHEN F4_CREDICM='S' AND B1_GRTRIB IN('025','065','088','089','090','091') AND D2_FILIAL IN('020101','020105') THEN D2_VALICM
            WHEN F4_CREDICM='S' AND B1_GRTRIB in ('150','180','315','365','660','680','665','685')   THEN D2_VALICM                   
            else 0 end
        ) AS ICMS_AJU,        
        F4_INCSOL TES_AGREGA_SOL , D2_ICMSRET VAL_ICMS_ST,
        D2_TOTAL+D2_VALIPI+D2_ICMSRET VAL_TOTAL_C_ST,
        (CASE TRIM(F4_PISCOF) WHEN '1' THEN 'PIS' WHEN '2' THEN 'COFINS' WHEN '3' THEN 'Ambos' WHEN '4' THEN 'Nao Considera' ELSE 'NA' END) TES_GERA_PISCOF,
        (CASE TRIM(F4_PISCRED) WHEN '1' THEN 'Credita' WHEN '2' THEN 'Debita' WHEN '3' THEN 'Nao Calcula' WHEN '4' THEN 'Calcula' WHEN '5' THEN 'Exclusão de Base' ELSE 'NA' END) TES_CRED_PISCOF,
        D2_ALQIMP6 ALIQ_PIS, D2_BASIMP6 BASE_PIS, D2_VALIMP6 VALOR_PIS, D2_BASIMP5 BASE_COF ,D2_ALQIMP5 ALIQ_COF, D2_VALIMP5 VALOR_COF,
        D2_DESPESA VLR_NF_DESPESAS, D2_VALFRE VLR_NF_FRETE,
        F2_CHVNFE CHAVE_NFE,F2_VALBRUT VL_TOTAL_NF
        FROM SD2010 D2
        LEFT JOIN SF2010 F1 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_EMISSAO=D2_EMISSAO AND F1.D_E_L_E_T_=' ' 
        LEFT JOIN SB1010 B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=' ' 
        LEFT JOIN SX5010 X5 ON X5_TABELA='21' AND X5_CHAVE=B1_GRTRIB AND X5.D_E_L_E_T_=' ' 
        LEFT JOIN SA1010 A2 ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A2.D_E_L_E_T_=' ' 
        LEFT JOIN SF4010 F4 ON D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' 
        LEFT JOIN Z20010 Z20 ON B1_GRTRIB=Z20_GRTRIB AND Z20.D_E_L_E_T_=' ' 
        WHERE
//            %Exp:cWhere%
            %EXP:cEmpEnt% 
            AND D2.D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
            AND D2.D_E_L_E_T_ = ' ' 

        ORDER BY D2_EMISSAO ,A1_NOME,D2_DOC,D2_COD

        EndSql
        oSection1:EndQuery()
        ctmpquery := oSection1:GetQuery()
        TCSetField( cAlias, 'EMISSAO', 'D', 8, 0 )
        TCSetField( cAlias, 'RECEBIMENTO', 'D', 8, 0 )

        Dbselectarea(cAlias)
        (cAlias)->(dbgotop())
        oReport:SetMeter((cAlias)->(RecCount()))
        oSection1:Print()


        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf

    Endif

Return

static Function DefMemCalC(cAlias,oReport,cNomeRel,oSection1,oSection2,oSection3,oSection4,oSection5,oSection6) //Definicao Memoria de Calculo Consolidado
        oSection1 := TRSection():New(oReport,cNomeRel,cAlias,,,,"Receita Tributária Fiscal",,,,,,,,,)

        TRCell():New(oSection1,"RECEITA"	    ,cAlias ,"CONSOLIDAÇÃO" ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection1,"RECEITA_TRIB"   ,cAlias ,"BASE CÁLCULO" ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"PIS_TRIB"       ,cAlias ,"PIS"	        ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection1,"COFINS_TRIB"    ,cAlias ,"COFINS"	    ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
         
        oSection2 := TRSection():New(oReport,cNomeRel,,,,,"Receita Tributária Fiscal",,,,,,,,,,,0)

        TRCell():New(oSection2,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection2,"APURA_TRIB"     ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"APURA_PIS"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection2,"APURA_COF"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         
            
        oSection3 := TRSection():New(oReport,cNomeRel,,,,,"Receita Financeira",,,,,,,,,,,0)

        TRCell():New(oSection3,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection3,"RECFIN_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection4 := TRSection():New(oReport,cNomeRel,,,,,"Despesa Aluguel",,,,,,,,,,,0)

        TRCell():New(oSection4,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection4,"DSPALG_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection6 := TRSection():New(oReport,cNomeRel,,,,,"ST Transferencias",,,,,,,,,,,0)

        TRCell():New(oSection6,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_TRIB"    ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_PIS"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection6,"DSPALG_COF"     ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         

        oSection5 := TRSection():New(oReport,cNomeRel,,,,,"Total Consolidado",,,,,,,,,)

        TRCell():New(oSection5,"RECEITA"	    ,       ,""             ,                   ,35                     ,.F.,,,,"LEFT" ,,,,,,.F.)
        TRCell():New(oSection5,"TCONS_TRIB"     ,       ,""             ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection5,"TCONS_PIS"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)
        TRCell():New(oSection5,"TCONS_COF"      ,       ,""	            ,"@E 999,999,999.99",TamSX3("D2_TOTAL")[1]	,.F.,,,,"RIGHT",,,,,,.F.)         
return oReport

static function RptMemCalC(oReport,cAlias,cAlias1,cAlias2,cNomeRel)
      /*  oSection1 := oReport:Section(1)
        oSection2 := oReport:Section(2)
        oSection3 := oReport:Section(3)
        oSection4 := oReport:Section(4)
        oSection5 := oReport:Section(5)
*/
        // Funcao para pre-formatar a clausula "IN" da Consulta
	    MakeSqlExpr("RFIS015")

        // Tratamento das Empresas
        IF !Empty(mv_par01)
            cEmp    := "% D2_FILIAL " + mv_par01 + "%"
            cEmp    := alltrim(StrTran(cEmp,"( IN","IN"))
            cEmp    := alltrim(StrTran(cEmp,"))",")"))
            cEmpEnt := "% D1_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Else
            If Empty(mv_par01) .and. Empty(mv_par08) .and. Empty(mv_par09)
                cEmp    := "% D2_FILIAL = '" + xFilial("SD2") + "' %"
                cEmpEnt := "% D1_FILIAL = '" + xFilial("SD1") + "' %"
            Else
                cEmp    := "% D2_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
                cEmpEnt := "% D1_FILIAL BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' %"
            Endif
        Endif

        oSection1:BeginQuery()
            
        BeginSql Alias cAlias

            SELECT * FROM 
            (
                SELECT
                       'A'                       AS ORDEM,
                       '(+) Receita Tributável ' AS RECEITA,
                       SUM(D2_BASIMP5)             AS RECEITA_TRIB,
                       SUM(D2_VALIMP6)           AS PIS_TRIB,
                       SUM(D2_VALIMP5)           AS COFINS_TRIB
                FROM SD2010 SD2
                WHERE 
                      %EXP:cEmp% 
                  AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%    
                  //AND D2_XOPER = '01' 
                  AND %EXP:cVndS%
                  AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                  AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'B'                         AS ORDEM,
                       '(-) Devoluções de Vendas ' AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1        AS DEV_VENDA,
                       SUM(D1_VALIMP6) * -1        AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1        AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE 
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER IN ('D6','D7')
                   AND %EXP:cDevE%
                   AND SF1.F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '
                
                UNION

                SELECT
                       'C'                        AS ORDEM,
                       '(-) Compras com Crédito ' AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1       AS CMP_CREDITO,
                       SUM(D1_VALIMP6) * -1       AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1       AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = '01'
                   AND %EXP:cCmpE%
                   AND SF1.F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                 
                   AND SF1.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'D'                          AS ORDEM,
                       '(+) Devoluções de Compras ' AS RECEITA,
                       SUM(D2_BASIMP5)                AS DEV_COMPRA,
                       SUM(D2_VALIMP6)              AS PIS_TRIB,
                       SUM(D2_VALIMP5)              AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('D1')
                   AND %EXP:cDecS%
                   AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                 
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'E'                                        AS ORDEM,
                       '(+) Receita de Fretes e Despesas '        AS RECEITA,
                      (SUM(D2_DESPESA) + SUM(D2_VALFRE))          AS REC_FRE_DSP,
                      ROUND((SUM(D2_DESPESA) + SUM(D2_VALFRE)) * 0.0165,2) AS PIS_TRIB,
                      ROUND((SUM(D2_DESPESA) + SUM(D2_VALFRE)) * 0.0760,2) AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp% 
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)                                 
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'F'                      AS ORDEM,
                       '(-) Créditos com CTEs ' AS RECEITA, 
                       SUM(D1_BASIMP5)   * -1     AS DEV_VENDA,
                       SUM(D1_VALIMP6) * -1     AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1     AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'FR'
                   AND %EXP:cCteE%
                   AND SF1.F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)                                 
                   AND SF1.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'G'                      AS ORDEM,
                       '(+) Anulação de Frete ' AS RECEITA,
                       SUM(D2_TOTAL)            AS ANL_FRETE,
                       ROUND(SUM(D2_TOTAL) * 0.0165,2)  AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL) * 0.076,2) AS COFINS_TRIB
                  FROM SD2010 SD2
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   AND D2_XOPER IN ('FA')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)          // ALTERACAO SOLICITADA POR TEREZA PARA TRAZER TODAS AS ANULACOES DE FRETE                                        
                   AND SD2.D_E_L_E_T_ = ' '

                UNION

                SELECT
                       'H'                              AS ORDEM,
                       '(+) Perda/Roubo/Deterioração '  AS RECEITA,
                       SUM(D2_TOTAL)                    AS PERDA_ROUBO,
                       ROUND(SUM(D2_TOTAL)*0.0165,2)    AS PIS_TRIB,
                       ROUND(SUM(D2_TOTAL)*0.076,2)     AS COFINS_TRIB
                  FROM SD2010 SD2
                  INNER JOIN SB1010 ON  '0201' = B1_FILIAL AND D2_COD = B1_COD
                 WHERE
                       %EXP:cEmp%
                   AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D2_XOPER IN ('93')
                   AND %EXP:cPrdS%
                   AND B1_GRTRIB IN ('025','065','088','089','090','091','100','130','150','180','315','365','665','660','680','685')
                   //AND (D2_VALIMP5 > 0 AND D2_VALIMP6 > 0)
                   AND SD2.D_E_L_E_T_ = ' '

                UNION
                
                SELECT
                       'I'                          AS ORDEM,
                       '(-) Despesas com Energia '  AS RECEITA,
                       SUM(D1_BASIMP5)   * -1         AS DSP_ENERG,
                       SUM(D1_VALIMP6) * -1         AS PIS_TRIB,
                       SUM(D1_VALIMP5) * -1         AS COFINS_TRIB
                  FROM SF1010 SF1
                  INNER JOIN SD1010 SD1 ON D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
                 WHERE
                       %EXP:cEmpEnt%
                   AND F1_DTDIGIT BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
                   //AND D1_XOPER = 'CE'
                   AND %EXP:cEneE%
                   AND SF1.F1_STATUS = 'A'
                   AND (D1_VALIMP5 > 0 AND D1_VALIMP6 > 0)
                   AND SF1.D_E_L_E_T_ = ' '
            )
            ORDER BY ORDEM

        EndSql

        oSection1:EndQuery()

        DbSelectArea(cAlias)
        (cAlias)->(DbGoTop())
        oReport:SetMeter((cAlias)->(RecCount()))
        (cAlias)->(DbGoTop())
            
        oSection1:Init()
				
        While !oReport:Cancel() .And. !(cAlias)->(Eof())
		    
            oReport:IncMeter()
            
            oSection1:Cell("RECEITA"):SetValue((cAlias)->RECEITA)						
            oSection1:Cell("RECEITA_TRIB"):SetValue((cAlias)->RECEITA_TRIB)						
            oSection1:Cell("PIS_TRIB"):SetValue((cAlias)->PIS_TRIB)						
            oSection1:Cell("COFINS_TRIB"):SetValue((cAlias)->COFINS_TRIB)						
            oSection1:PrintLine()

            aSldAtu[1] += (cAlias)->RECEITA_TRIB
            aSldAtu[2] += (cAlias)->PIS_TRIB
            aSldAtu[3] += (cAlias)->COFINS_TRIB

            dbSkip()
        EndDo
        oReport:ThinLine()
        oSection1:Finish()

        oSection2:Init(.F.)
        oSection2:Cell("RECEITA"):SetValue("(=)   Receita Tributária Fiscal")
    	oSection2:Cell("APURA_TRIB"):SetValue(aSldAtu[1])
        oSection2:Cell("APURA_PIS"):SetValue(aSldAtu[2])
        oSection2:Cell("APURA_COF"):SetValue(aSldAtu[3])
        oSection2:PrintLine()

        oSection2:Finish()

        oSection3:Init(.F.)
        oSection3:Cell("RECEITA"):SetValue("(+)   Receita Financeira")
    	oSection3:Cell("RECFIN_TRIB"):SetValue(mv_par06)
        oSection3:Cell("RECFIN_PIS"):SetValue(mv_par06 * 0.0065)
        oSection3:Cell("RECFIN_COF"):SetValue(mv_par06 *0.04)
        oSection3:PrintLine()
        oSection3:Finish()
            
        oSection4:Init(.F.)
        oSection4:Cell("RECEITA"):SetValue("(-)   Despesa Aluguel")
 		oSection4:Cell("DSPALG_TRIB"):SetValue(mv_par07 * (-1))
        oSection4:Cell("DSPALG_PIS"):SetValue((mv_par07 * 0.0165)*(-1))
        oSection4:Cell("DSPALG_COF"):SetValue((mv_par07 * 0.0760)*(-1))
        oSection4:PrintLine()
        oSection4:Finish()

        oSection6:Init(.F.)
        oSection6:Cell("RECEITA"):SetValue("(-)   ST Transferencias")
 		oSection6:Cell("DSPALG_TRIB"):SetValue(mv_par10* (-1))
        oSection6:Cell("DSPALG_PIS"):SetValue((mv_par10* 0.0165)*(-1))
        oSection6:Cell("DSPALG_COF"):SetValue((mv_par10* 0.0760)*(-1))
        oSection6:PrintLine()
        oSection6:Finish()

        VlPisF := mv_par06 * 0.0065
        VlCofF := mv_par06 *0.04

        VlPisD := (mv_par07 * 0.0165)
        VlCofD := (mv_par07 * 0.0760)
        
        VlPisT := (mv_par10 * 0.0165)
        VlCofT := (mv_par10 * 0.0760)

        nTotApura := ((aSldAtu[1]+mv_par06)-(mv_par07)-(mv_par10))
        nTotPIS   := ((aSldAtu[2] + VlPisF) -VlPisD-VlPisT)
        nTotCof   := ((aSldAtu[3]+VlCofF) - VlCofD-VlCofT)

        oSection5:Init()
        oSection5:Cell("RECEITA"):SetValue("Total Consolidado")
  		oSection5:Cell("TCONS_TRIB"):SetValue(nTotApura)
        //oSection5:Cell("TCONS_PIS"):SetValue(nTotApura * 0.0165)
        oSection5:Cell("TCONS_PIS"):SetValue(nTotPIS)
        //oSection5:Cell("TCONS_COF"):SetValue(nTotApura * 0.0760)
        oSection5:Cell("TCONS_COF"):SetValue(nTotCof)
        oSection5:PrintLine()
           
        oReport:ThinLine( )
            
        oSection5:Finish()

        (cAlias)->(DbCloseArea())
return
