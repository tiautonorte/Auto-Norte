//************************************************************************************************
// Função NatTit - Função para Ler a Natureza do Titulo a partir de uma nota fiscal de entrada ou saída, conforme passado por parâmetro.
// 23/08/2018
// Utilizado no LP's 620 e 660 para contabilizar compras e vendas.
//************************************************************************************************
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOPCONN.CH'

User Function NatTit(cTABNF,cFilNF,cCliFor,cLoja,cDoc,cSerie,cTipo)
Local cNatureza := "NAO ACHOU!"
Local aArea := GetArea()
Local aSFArea := (cTABNf)->(GetArea())
Local cQuery := ""
Local cAlias := GetNextAlias()


iF cTABNF = 'SF1'
  
  cQuery := "SELECT E2.E2_NATUREZ FROM " +RetSqlName('SF1') +" F1"
  cQuery +=" LEFT JOIN "+RetSqlName('SE2')+" E2 ON E2.E2_FILIAL = F1.F1_FILIAL AND E2.E2_FORNECE = F1.F1_FORNECE AND E2.E2_LOJA = F1.F1_LOJA AND"
  cQuery +=" E2.E2_PREFIXO = F1.F1_SERIE AND E2.E2_NUM =  F1.F1_DOC AND E2.E2_TIPO = '"+cTipo+"'
  cQuery +="WHERE F1.F1_FILIAL = '"+xFilial("SF1",cFilial)+"' AND F1.F1_FORNECE = '"+cCliFor+"' AND F1.F1_LOJA = '"+cLoja+"' AND F1.F1_DOC = '"+cDoc+"' AND F1.F1_SERIE = '"+cSerie+"'"
  cQuery +=" AND ROWNUM = 1"

  TCQUERY (cQuery) ALIAS (cAlias) NEW

  //DbSelectArea(cAlias)
  (cAlias)->(dbgotop())

  If !(cAlias)->(Eof()) 
    cNatureza := (cAlias)->E2_NATUREZ  
  endif

  DbCloseArea()
 
Endif

RestArea(aSFArea)
RestArea(aArea)


Return(cNatureza)
