#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RFATMGNF
    (long_description)
    @type  User Function
    @author Jubirajara Souza
    @since 01/02/2021
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

User Function RFATPM()

    Private oReport

    Private oSection1
    Private oSection2
    Private oSection3
    Private oSection4
    Private oSection5
    Private cPerg     := "RFATPM"

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

    //-------------------------------------------------------------------------
    //| Analise Prazo Medio                                               |
    //-------------------------------------------------------------------------
        cNomeRel := "Analise Prazo Medio"

        oReport := TReport():New("RFATPM",cNomeRel,cPerg,{|oReport| RptPrint(oReport,cAlias,cAlias1,cAlias2,cNomeRel)},"Analise Prazo Medio")        
        oReport:SetTotalInLine(.F.)
        oReport:SetLandScape()
        oReport:EndPage(.T.)
        //oReport:oPage:setPaperSize(9)
        //oReport:SetLineHeight(50)
        oReport:nFontBody := 10

        oSection1 := TRSection():New(oReport    ,cNomeRel ,cAlias) // ,,,,,,,,,,,.T.,,.F.)         
        oSection1:SetTotalInLine(.F.) 
        TRCell():New( oSection1, "VENDEDOR_COD",cAlias)
        TRCell():New( oSection1, "VENDEDOR_NOME",cAlias,,"@!",45)
        //TRCell():New( oSection1, "VENDEDOR_NOME",cAlias,"NOME VENDEDOR","@!",45)
        TRCell():New( oSection1, "FATURAMENTO",cAlias,,"@E 999,999,999.99",20)
        TRCell():New( oSection1, "PRAZO_MEDIO",cAlias,,"@E 999,999,999.99",10)
       //TRFunction():New(oSection1:Cell("FATURAMENTO"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,"@E 999,999,999.99"/*cPicture*/,/*uFormula*/,.T.           ,.F.           ,.F.        ,oSection1)

Return oReport


Static Function RptPrint(oReport,cAlias,cAlias1,cAlias2,CNOMEREL)

    Local cEmp      := ""
    Local cEmpEnt   := ""
    Local TempSM4   := getNextAlias()
    Private aSldAtu   := { 0,0,0 }

    //----------------------------------------
    //| Auditoria Margem Por NF              |
    //----------------------------------------
        //Funcao para pre-formatar a clausula "IN" da Query
        //MakeSqlExpr("RFATMGNF")

        // Tratamento das Empresas
        /*IF !Empty(mv_par01)
            cEmpEnt := "% D2_FILIAL " + mv_par01 + "%"
            cEmpEnt := alltrim(StrTran(cEmpEnt,"( IN","IN"))
            cEmpEnt := alltrim(StrTran(cEmpEnt,"))",")"))
        Endif
        */
        oReport:SetTitle(oReport:Title()+" - Filial de "+mv_par01+" ate "+mv_par02+" // Periodo "+dtoc(MV_PAR03)+" ate "+dtoc(MV_PAR04))
        IF !Empty(mv_par01)
            cEmpEnt := "% D2_FILIAL BETWEEN '" + mv_par01+"' And '"+mv_par02 + "' %"
        endif

        BeginSql Alias  cAlias
        SELECT F2_VEND1 VENDEDOR_COD,A3_NOME VENDEDOR_NOME, 
        SUM(F2_VALMERC* ( (select sum(TO_DATE(e1_vencrea, 'YYYYMMDD') -TO_DATE(e1_emissao, 'YYYYMMDD')) from se1010 e1 where e1.e1_filial=f2.F2_FILIAL and e1.E1_NUM=f2.F2_DOC and e1.e1_cliente=f2.F2_CLIENTE and e1.e1_emissao=f2.F2_EMISSAO)/
        (select count(*) from se1010 e1 where e1.e1_filial=f2.F2_FILIAL and e1.E1_NUM=f2.F2_DOC and e1.e1_cliente=f2.F2_CLIENTE and e1.e1_emissao=f2.F2_EMISSAO) ) ) PRAZO_MEDIO,
               
        SUM(F2_VALMERC) FATURAMENTO
        FROM 
            (SELECT F2_FILIAL ,F2_ESPECIE ,F2_EMISSAO ,
            F2_DOC ,F2_VEND1 ,A3_NOME , 
            F2_SERIE ,F2_CLIENTE ,F2_LOJA,A1_NOME ,A1_CGC ,A1_EST ,
            F2_VALMERC ,
            F2_VALBRUT,
            E4_DESCRI CONDICAO_PGTO,
            F2_CHVNFE CHAVE_NFE,
            A1_XGRPCOM
            FROM SF2010 F2
            LEFT JOIN SD2010 D2 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_EMISSAO=D2_EMISSAO AND D2.D_E_L_E_T_=' ' 
            LEFT JOIN SA1010 A1 ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' ' 
            LEFT JOIN SA3010 A3 ON A3_COD=F2_VEND1 AND A3.D_E_L_E_T_=' ' 
            LEFT JOIN SE4010 E4 ON E4_CODIGO=F2_COND AND E4.D_E_L_E_T_=' ' 
            WHERE
    //            %Exp:cWhere%
                %EXP:cEmpEnt% 
                AND F2.F2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
                and D2_XOPER='01'
                AND D2.D_E_L_E_T_ = ' ' 
            GROUP BY 
                 F2_FILIAL ,F2_ESPECIE ,F2_EMISSAO ,
                    F2_DOC ,F2_VEND1 ,A3_NOME , 
                    F2_SERIE ,F2_CLIENTE,F2_LOJA ,A1_NOME ,A1_CGC ,A1_EST ,
                    F2_VALMERC ,
                    F2_VALBRUT,
                    E4_DESCRI,F2_CHVNFE,A1_XGRPCOM) F2
            //where 
            //Intervalo Margem
            //case when custo>0 then ROUND(((F2_VALMERC-CUSTO)/CUSTO)*100,2) else 0 end BETWEEN %exp:mv_par04% and %exp:mv_par05%
            //and
            //Intervalo Desconto
            //ROUND((select sum(d21.D2_DESC*d21.D2_TOTAL) from dadosanl.sd2010 d21 where f2.F2_FILIAL=d21.D2_FILIAL AND f2.F2_DOC=d21.D2_DOC AND f2.F2_SERIE=d21.D2_SERIE AND f2.F2_CLIENTE=d21.D2_CLIENTE AND f2.F2_LOJA=d21.D2_LOJA AND f2.F2_EMISSAO=d21.D2_EMISSAO  and d21.d_e_l_e_t_=' ') /F2_VALMERC ,2) BETWEEN %exp:mv_par06% and %exp:mv_par07%
            GROUP BY 
                 F2_VEND1 ,A3_NOME
            ORDER BY  F2_VEND1 ,A3_NOME
        EndSql
        oSection1:EndQuery()
        ctmpquery := oSection1:GetQuery()
        //TCSetField( cAlias, 'EMISSAO', 'D', 8, 0 )
  

        Dbselectarea(cAlias)
        (cAlias)->(dbgotop())
        oReport:SetMeter((cAlias)->(RecCount()))
        //oSection1:Print()
        //oReport:Init()
        oSection1:Init()
		nVlAcum :=0
        nPrazMV :=0
        nPrazMG :=0
        oSection1:Cell("VENDEDOR_NOME"):SetSIZE(45)
        While !(cAlias)->(Eof()) .and.!oReport:Cancel() 
		    If oReport:Cancel()
            	Exit
		    EndIf
        	oReport:IncMeter()
            cCod :=	(cAlias)->VENDEDOR_COD
            cNome := (cAlias)->(VENDEDOR_NOME)
            //oSection1:Cell("VENDEDOR_COD"):SetValue((cAlias)->VENDEDOR_COD)
            //oSection1:Cell("VENDEDOR_NOME"):SetValue((cAlias)->(VENDEDOR_NOME))
            oSection1:Cell("VENDEDOR_COD"):SetValue(cCod)
            oSection1:Cell("VENDEDOR_NOME"):SetValue(cNome)
            oSection1:Cell("FATURAMENTO"):SetValue((cAlias)->(FATURAMENTO))
            nPrazMV := round( (cAlias)->(PRAZO_MEDIO)/iif((cAlias)->(FATURAMENTO)>0,(cAlias)->(FATURAMENTO),1) ,2)
            nPrazMG += (cAlias)->(PRAZO_MEDIO)
            nVlAcum += (cAlias)->(FATURAMENTO)
            oSection1:Cell("PRAZO_MEDIO"):SetValue(nPrazMV)
			oSection1:Printline() 
            DbSelectArea(cAlias)
            (cAlias)->(dbskip())
        Enddo
        // Finalizo a primeira seção
        oSection1:Cell("VENDEDOR_COD"):SetValue(" ==>>>>")
        oSection1:Cell("VENDEDOR_NOME"):SetValue("TOTAL GERAL: ")
        oSection1:Cell("FATURAMENTO"):SetValue(nVlAcum)
        oSection1:Cell("PRAZO_MEDIO"):SetValue(round(nPrazMG/iif(nVlAcum>0,nVlAcum,1),2) )
		oSection1:Printline() 
        oSection1:Finish()

        If Select(cAlias) != 0
            DbSelectArea(cAlias)
            (cAlias)->(DbCloseArea())
        EndIf

Return

