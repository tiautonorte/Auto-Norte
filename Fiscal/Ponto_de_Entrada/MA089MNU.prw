#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Empresa  � A M Paulo Tecnologia ME                                     ��
�������������������������������������������������������������������������Ĵ��
��� Funcao   � MA089MNU	 � Autor � Andre Minelli        � Data 08/06/2021  ��
�������������������������������������������������������������������������Ĵ��
���Descricao � Grava campo de CFOP para TES de entrada e Saida na SFM      ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � Auto Norte                                           	   ��
����������������������������������������������������������������������������*/

User Function MA089MNU

Local cSql := ""
Local aArea := GetArea()

//Atualiza TES Entrada
cSql := "select FM.FM_FILIAL,F4.F4_FILIAL,FM.FM_TE,F4.F4_CODIGO,FM.FM_XCFTE,F4.F4_CF FROM " + RetSqlName("SFM") + " FM JOIN " + RetSqlName("SF4") + " F4 ON "
cSql += "F4.F4_FILIAL = FM.FM_FILIAL and F4.F4_CODIGO = FM.FM_TE and F4.D_E_L_E_T_ = '' and FM.D_E_L_E_T_ = '' and "
cSql += "FM_XCFTE <> F4_CF "
cSql := ChangeQuery(cSql)
DBUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"SQLSF4",.T.,.T.)

While SQLSF4->(!EOF())

    cSql := "UPDATE " + RetSqlName("SFM") + " SET FM_XCFTE = '" + SQLSF4->F4_CF + "' WHERE FM_FILIAL = '" + SQLSF4->F4_FILIAL + "' AND FM_TE = '" + SQLSF4->F4_CODIGO + "' "
    nRet := TcSqlExec(cSql)

    SQLSF4->(DbSkip())

End

SQLSF4->(DbCloseArea())


//Atualiza TES Saida
cSql := "select FM.FM_FILIAL,F4.F4_FILIAL,FM.FM_TS,F4.F4_CODIGO,FM.FM_XCFTS,F4.F4_CF FROM " + RetSqlName("SFM") + " FM JOIN " + RetSqlName("SF4") + " F4 ON "
cSql += "F4.F4_FILIAL = FM.FM_FILIAL and F4.F4_CODIGO = FM.FM_TS and F4.D_E_L_E_T_ = '' and FM.D_E_L_E_T_ = '' and "
cSql += "FM_XCFTS <> F4_CF "
cSql := ChangeQuery(cSql)
DBUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"SQLSF4",.T.,.T.)

While SQLSF4->(!EOF())

    cSql := "UPDATE " + RetSqlName("SFM") + " SET FM_XCFTS = '" + SQLSF4->F4_CF + "' WHERE FM_FILIAL = '" + SQLSF4->F4_FILIAL + "' AND FM_TS = '" + SQLSF4->F4_CODIGO + "' "
    nRet := TcSqlExec(cSql)

    SQLSF4->(DbSkip())

End

SQLSF4->(DbCloseArea())

RestArea(aArea)

Return
