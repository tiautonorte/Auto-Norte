#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
Italo Maciel    Data: 21/02/2020
Encontrar titulos no relatorio do retorno pelo nosso numero
*/
User Function FR650FIL()
	Local lAchouTit := .F.
	Local cQuery

	//If SE1->(EOF())

	cQuery := " SELECT R_E_C_N_O_ RECNO FROM " + Retsqlname("SE1")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	If MV_PAR03 = '422'//Banco
		cQuery += " AND SUBSTR(E1_NUMBCO,1,9) = '"+cNossoNum+"' "
	elseif MV_PAR03 = '341' // Tratamento do Banco Itau
		cQuery += " AND SUBSTR(E1_NUMBCO,1,8) = '"+SubStr(cNossoNum,1,8)+"' "
	Else	
		cQuery += " AND E1_NUMBCO = '"+cNossoNum+"' "
	EndIf

	cQuery := ChangeQuery(cQuery)

	TCQUERY cQuery NEW ALIAS "QSE1"

	If !QSE1->(EOF())
		dbSelectArea("SE1")

		//posiciona no recno encontrado
		SE1->(dbGoTo(QSE1->RECNO))
		lAchouTit := .T.

		QSE1->(dbSkip())
	EndIf

	QSE1->(dbCloseArea())

	//Else
	//    lAchouTit := .T.
	//EndIf

Return lAchouTit
