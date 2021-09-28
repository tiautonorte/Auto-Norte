/*
Rotina...: ANLRIGPE.PRW                           
Autor....: Ricardo Campelo em 27/03/2017          
Descrição: Relatório de Indicadores de Custo DP/RH
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//#INCLUDE "FiveWin.ch"
#INCLUDE "PRCONST.CH"
#INCLUDE "VKEY.CH"    
//#INCLUDE "AP6.CH"

User Function ANLRIGPE()

	Processa({|| fPrint() }, "Aguarde. Imprimindo Indicadores de Custo DP/RH...")
Return (.T.)

Static Function fPrint()

	Local nQtdFil := 1
	Local nQtdMes := 1
	Local nQtdIndic := 1
	Local nQtdVer2 := 1
	Local nQtdVer := 1 
	Local nElefolha := 1
	Local nM := 1
	Local M := 1

	//PRIVATE aReturn  := {"Zebrado", _aRet_1_VIA, "Administracao", _aRet_NORMAL, _aRet_IMPRESSORA, _aRet_LPT1, "", 1}
	//PRIVATE nLastKey := 0
	Private cPerg := "ANLRIGPE  "
	Private nCont := 0
	Private Enter := CHR(13) + CHR(10)

	VerPerg()
	If Pergunte(cPerg,.T.) = .F.
		Return
	EndIf   

	aFiliais := {'0201  '}
	cCdFil   := StrZero(Val(Left(mv_par01,6)),6)
	nDifFl   := (Val(mv_par02) - Val(mv_par01)+1)

	For nQtdFil := 1 to nDifFl
		If !(cCdFil $ '020104/020109/020110')
			aAdd(aFiliais,cCdFil)
		EndIf   
		cCdFil := StrZero(Val(Left(cCdFil,6))+1,6)
	Next

	aFilIndic := {}
	
	aAdd(aFilIndic, {'020101','ANL PE'} )
	aAdd(aFilIndic, {'020102','ANL BA'} )
	aAdd(aFilIndic, {'020103','ANL CE'} )
	aAdd(aFilIndic, {'020105','ANL RN'} )
	aAdd(aFilIndic, {'020106','ANL PB'} )
	aAdd(aFilIndic, {'020107','ANL PI'} )
	aAdd(aFilIndic, {'020108','ANL SE'} )
	aAdd(aFilIndic, {'020111','ANL BH'} )

	aIndicador := {}
	aAdd(aIndicador, {'001Nº Colaboradores'})//1
	aAdd(aIndicador, {'010Estagiarios'} )//2
	aAdd(aIndicador, {'020Admitidos'} )//3
	aAdd(aIndicador, {'030Demitidos'} )//4
	aAdd(aIndicador, {'040TurnOver'} )//5
	aAdd(aIndicador, {'050Afastados Acumulado'} )//6
	aAdd(aIndicador, {'060Nº de PCDs'} )//7
	aAdd(aIndicador, {'070Treinamento'} )//8
	aAdd(aIndicador, {'080Despesas T & D'} )//9
	aAdd(aIndicador, {'090Promoções'} )//10
	aAdd(aIndicador, {'100Progressão'} )//11
	aAdd(aIndicador, {'110Bolsa de Estudos'} )//12
	aAdd(aIndicador, {'120Custo com Bolsa de Estudos'} )//13
	aAdd(aIndicador, {'130Custo com Demissão'} )//14
	aAdd(aIndicador, {'140Custo com Férias'} )//15
	aAdd(aIndicador, {'150Folha Bruta'} )//16
	aAdd(aIndicador, {'152Folha Líquida'} )//17
	aAdd(aIndicador, {'154Pro-Labore'} )//18
	aAdd(aIndicador, {'156Encargos FGTS'} )//19
	aAdd(aIndicador, {'157Encargos INSS'} )//20
	aAdd(aIndicador, {'158Folha TOTAL'} )//21                                                      
	aAdd(aIndicador, {'160Nº de Afastamentos por Acidentes Mensal'} )//22
	aAdd(aIndicador, {'170Nº de Afastamentos por Doença Mensal'} )//23
	aAdd(aIndicador, {'180Custo com Alimentação'} )//24
	aAdd(aIndicador, {'190Custo com Transporte'} )//25
	aAdd(aIndicador, {'200Custo com Adiantamento de 13º Salário'} )//26
	aAdd(aIndicador, {'300Custo com Plano de Saude'} )//27
	aAdd(aIndicador, {'301Custo com Plano Odontologico'} )//28
	aAdd(aIndicador, {'302Custo de Cesta Basica'} )//29
	aAdd(aIndicador, {'303Per Capita Benefício'} )//30

	aAdd(aIndicador, {'310Tempo Médio Empresa(anos)'} )//31

	aAdd(aIndicador, {'311Absenteismo(%)'} )//32
	aAdd(aIndicador, {'312Horas Realizadas X Compensadas(%)'} )//33

//O.S 10010
/*
jjs -27/04/2020
INCLUIR CUSTO COM: PLANO DE SAÚDE (VERBAS 799 E 778), ODONTOLÓGICO (780 E 781), CUSTO COM CESTA BÁSICA (734) ,
HORAS REALIZADAS X HORAS COMPENSADAS; ABSENTEÍSMO; TEMPO MÉDIO DE EMPRESA 
E CUSTO PER CAPITA DE BENEFÍCIO. APENAS CUSTO DA EMPRESA
*/

	aCodIndic := {}
	aAdd(aCodIndic, {'001'} )
	aAdd(aCodIndic, {'010'} )
	aAdd(aCodIndic, {'020'} )
	aAdd(aCodIndic, {'030'} )
	aAdd(aCodIndic, {'040'} )
	aAdd(aCodIndic, {'050'} )
	aAdd(aCodIndic, {'060'} )
	aAdd(aCodIndic, {'070'} )
	aAdd(aCodIndic, {'080'} )
	aAdd(aCodIndic, {'090'} )
	aAdd(aCodIndic, {'100'} )
	aAdd(aCodIndic, {'110'} )
	aAdd(aCodIndic, {'120'} )
	aAdd(aCodIndic, {'130'} )
	aAdd(aCodIndic, {'140'} )
	aAdd(aCodIndic, {'150'} )
	aAdd(aCodIndic, {'152'} )
	aAdd(aCodIndic, {'154'} )
	aAdd(aCodIndic, {'156'} )
	aAdd(aCodIndic, {'157'} )
	aAdd(aCodIndic, {'158'} )
	aAdd(aCodIndic, {'160'} )
	aAdd(aCodIndic, {'170'} )
	aAdd(aCodIndic, {'180'} )
	aAdd(aCodIndic, {'190'} )
	aAdd(aCodIndic, {'200'} )
	
	aAdd(aCodIndic, {'300'} )
	aAdd(aCodIndic, {'301'} )
	aAdd(aCodIndic, {'302'} )
	aAdd(aCodIndic, {'303'} )

	aAdd(aCodIndic, {'310'} )

	aAdd(aCodIndic, {'311'} )
	aAdd(aCodIndic, {'312'} )

	aTrnIndic := {}
	aAdd(aTrnIndic, {'INTERNO'} )
	aAdd(aTrnIndic, {'EXTERNO'} )

	aMeses  := {}
	cMesIni := SubStr(DToS(MV_PAR03),1,6)
	cMesfin := SubStr(DToS(MV_PAR04),1,6)
	dMesfin := MV_PAR04
	cMesAtu := SubStr(DToS(MV_PAR03),1,6)

	While cMesAtu <= cMesFin
		aAdd(aMeses,cMesAtu)
		If Val(Right(cMesAtu,2)) < 12
			cMesAtu := Left(cMesAtu,4) + StrZero( Val( Right(cMesAtu,2) ) +1 ,2)
		ELSE
			cMesAtu := StrZero( Val( left(cMesAtu,4) ) +1 ,4) + '01'
		EndIf   
	EndDo                      

	aTotIndica := {}
	For nQtdFil := 1 to Len(aFiliais)
		For nQtdIndic := 1 to Len(aIndicador)
			If SubStr(aIndicador[nQtdIndic,1],1,3) $ '040070080' .AND. nCont < 4
				aTemp := { '0201  ', SubStr(aIndicador[nQtdIndic,1],1,3) }
				For nQtdMes := 1 to Len(aMeses)                               
					aAdd(aTemp, 0)      
				Next 
				aAdd(aTotIndica, aTemp)
				nCont += 1
				/*/    ElseIf substr(aIndicador[nQtdIndic,1],1,3) $ '070' 
				For nQtTrn := 1 to Len(aTrnIndic)
				aTemp := { aTrnIndic[nQtTrn] }
				For nQtdMes := 1 to len(aMeses)                               
				aadd(aTemp, 0)      
				Next
				aadd(aTotIndica, aTemp)
				Next    */
			ElseIf !SubStr(aIndicador[nQtdIndic,1],1,3) $ '040070080' 
				aTemp := { aFiliais[nQtdFil] , SubStr(aIndicador[nQtdIndic,1],1,3) }
				For nQtdMes := 1 to Len(aMeses)                               
					aAdd(aTemp, 0)      
				Next
				aAdd(aTotIndica, aTemp)
			EndIf
		Next
	Next

	DbSelectArea("SRD")
	DbSetOrder(1)      

	DbSelectArea("SRA")
	DbSetOrder(1)      
	SRA->(DBGoTop())    	  

	While !SRA->(EoF())

		For nQtdMes := 1 to Len(aMeses)

			//Indicador de Colaboradores
			If SRA->RA_CATFUNC $ "M#C" .And. SubStr(DTOS(SRA->RA_ADMISSA),1,6) <= aMeses[nQtdMes] .And.;
			(SRA->RA_SITFOLH $ ' FA' .Or. (SRA->RA_SITFOLH = 'D' .And. SubStr(DTOS(SRA->RA_DEMISSA),1,6) > aMeses[nQtdMes] ))  // >= aMeses[nQtdMes] ))

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'001') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'001') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
				//------------
				//Tempo Medio de Empresa parte 1 ,soma dos dias
				//
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'310') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + (dMesfin-SRA->RA_ADMISSA)
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'310') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + (dMesfin-SRA->RA_ADMISSA)
				EndIf                      
			EndIf

			// Indicador de Estagiário
			If SRA->RA_CATFUNC = 'E' .And. SubStr(DTOS(SRA->RA_ADMISSA),1,6) <= aMeses[nQtdMes] .And.;
			(SRA->RA_SITFOLH $ ' FA' .Or. (SRA->RA_SITFOLH = 'D' .And. SubStr(DTOS(SRA->RA_DEMISSA),1,6) > aMeses[nQtdMes] ))   // >= aMeses[nQtdMes] ))

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'010') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'010') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf

			// Indicador de Admitidos
			If SRA->RA_CATFUNC $ 'M' .AND. SubStr(DTOS(SRA->RA_ADMISSA),1,6) == aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'020') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'020') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf

			// Indicador de Demitidos
			If SRA->RA_CATFUNC $ 'M' .And. SubStr(DTOS(SRA->RA_DEMISSA),1,6) == aMeses[nQtdMes] 

				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'030') })

				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'030') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf

			// Indicador de PCD´s
			If SRA->RA_CATFUNC $ 'M' .And. SRA->RA_DEFIFIS = '1' .And. SubStr(DTOS(SRA->RA_ADMISSA),1,6) <= aMeses[nQtdMes] .And.;
			(SRA->RA_SITFOLH $ ' FA' .Or. (SRA->RA_SITFOLH = 'D' .And. SubStr(DTOS(SRA->RA_DEMISSA),1,6) >= aMeses[nQtdMes] ))

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(RA_FILIAL+'060') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRA->(Left(RA_FILIAL,4)+'  '+'060') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf
		Next

		SRA->(DbSkip())

	EndDo                           

	// Indicadores Calculados com base dados SRA
	For nQtdMes   := 1 to Len(aMeses)
		// Indicador de TurnOver
		nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == '0201  '+'030' })

		If nEleTOver <> 0
			nTOvDem := aTotIndica[nEleTOver,nQtdMes+2]
		EndIf   

		nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == '0201  '+'020' })

		If nEleTOver <> 0
			nTOvAdm := aTotIndica[nEleTOver,nQtdMes+2]
		EndIf   

		nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == '0201  '+'001' })

		If nEleTOver <> 0
			nTOvFun := aTotIndica[nEleTOver,nQtdMes+2]
		EndIf                                              

		nVlTOver := (((nTOvDem + nTOvAdm)/2)/nTOvFun) * 100

		nEleTOver := Ascan(aTotIndica, { |X| X[1]+X[2] == '0201  '+'040' })

		If nEleTOver <> 0
			aTotIndica[nEleTOver, nQtdMes + 2] := nVlTOver
		EndIf                      
		//------------
		//Tempo Medio de Empresa parte 2 ,Calculo média
		//
		For nQtdFil:=1 to len(aFiliais)
			nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'001' })

			If nEleTOver <> 0
				nTOvFunF := aTotIndica[nEleTOver,nQtdMes+2]
			EndIf                                              

			nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'310' })

			If nEleInd <> 0
				aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFunF)/365,2)
			EndIf                      
		Next
		// Totalizando no geral do indicador
		/*nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] =='0201  '+'310' })

		If nEleInd <> 0
			aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFun)/365/len(aFiliais),2)
		EndIf*/
	Next                                 

	cVerbasSQL := ""
	cFilialSQL := ""
	aVerbas    := {}
	//aAdd(aVerbas,{'150',{'401','402','420','422','450','999'}})   //Folha Liquida
	//aAdd(aVerbas,{'152',{'004','010','020','021','022','027','028','029','030','031','032','038','039','040','041','043','045','047','049','058','064','065',;
	//                     '066','073','082','084','111','113','115','116','119','120','341','345','347','348'}})  //Folha Bruta
	aAdd(aVerbas,{'150',{'004','010','020','021','022','027','028','029','030','031','032','038','039','040','041','043','045','047','049','058','064','065',;
	'066','073','082','084','111','113','115','116','119','120','341','345','347','348'}})  // Folha Bruta
	aAdd(aVerbas,{'152',{'401','402','420','422','450','999'}})   // Folha Liquida                     
	aAdd(aVerbas,{'154',{'023'}})  // Pro-Labore
	aAdd(aVerbas,{'156',{'740','755','756'}})  //Encargos FGTS
	aAdd(aVerbas,{'157',{'815','816','817','818','819','820'}})  // INSS
	aAdd(aVerbas,{'158',{'004','010','020','021','022','027','028','029','030','031','032','038','039','040','041','043','045','047','049','058','064','065',;
	'066','073','082','084','111','113','115','116','119','120','341','345','347','348','740','755','756','815','816','817','818','819','820'}})   // Folha Total
	aAdd(aVerbas,{'ZZZ',{'020','069','290','291','714','720'}})

	//JJS 30/04/21 - O.S 10010
	aAdd(aVerbas,{'300',{'799','778'}})  // PLANO DE SAÚDE
	aAdd(aVerbas,{'301',{'780','781'}})  // PLANO ODONTOLÓGICO 
	aAdd(aVerbas,{'302',{'734'}})  // CUSTO COM CESTA BÁSICA
	aAdd(aVerbas,{'303',{'714','734','780','781','799','778'}})  //CUSTO PER CAPITA DE BENEFÍCIO (714	VALE ALIMENT EMPRESA)

	// Indicadores Calculados com base dados SRD
	For nQtdFil := 1 To Len(aFiliais)
		cFilialSQL += If( Empty(cFilialSQL) , " AND SRD.RD_FILIAL IN (" + "'" + aFiliais[nQtdFil] + "'", ",'" + aFiliais[nQtdFil] + "'" )
	Next

	If !Empty(cFilialSQL)
		cFilialSQL +=  ")"
	EndIf

	For nQtdVer := 1 To Len(aVerbas)
		aVerbasTmp := aVerbas[nQtdVer,2]                                
		For nQtdVer2 := 1 To Len(aVerbasTmp)
			cVerbasSQL += If( Empty(cVerbasSQL) , " AND SRD.RD_PD IN (" + "'" + aVerbasTmp[nQtdVer2] + "'", ",'" + aVerbasTmp[nQtdVer2] + "'" )
		Next
	Next

	If !Empty(cFilialSQL)
		cVerbasSQL +=  ")"
	EndIf

	cSql := "SELECT	* " + Enter
	cSql += "FROM	" + RetSqlName("SRD") + " SRD	" + Enter
	cSql += "INNER JOIN " + RetSqlName("SRA")+ " A ON A.D_E_L_E_T_ = ' ' AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT "
	cSql += "WHERE	" + Enter	
	//cSql += "RA_CATFUNC IN('M','H') AND " + Enter
	cSql += "		SRD.RD_DATARQ  >= '"+cMesIni+"' AND " + Enter //Emissão a partir de 05/05/2016
	cSql += "		SRD.RD_DATARQ  <= '"+cMesFin+"' 	" + Enter

	If !Empty(cFilialSQL)
		cSql += cFilialSQL + Enter
	EndIf

	If !Empty(cVerbasSQL)
		cSql += cVerbasSQL + Enter
	EndIf

	cSql += "AND	SRD.D_E_L_E_T_  != '*'						" + Enter

	TCQUERY cSql NEW ALIAS "SRDTRB"

	DBSelectArea("SRDTRB")
	SRDTRB->(DBGoTop())

	//oReport:SetMeter(SRDTRB->(RecCount()))

	ProcRegua(0)

	While !SRDTRB->(EoF())       

		//oReport:IncMeter()
		IncProc()

		For nQtdMes := 1 To Len(aMeses)

			//jjs -27/04/2020-O.S 10010 
			// PLANO DE SAÚDE
			If SRDTRB->RD_PD $ '799,778' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				// Custo PLANO DE SAÚDE
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'300') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'300') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf
			// PLANO ODONTOLÓGICO 
			If SRDTRB->RD_PD $ '780,781' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				// Custo PLANO ODONTOLÓGICO 
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'301') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'301') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf
			// CESTA BÁSICA
			If SRDTRB->RD_PD $ '734' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				// Custo PLANO ODONTOLÓGICO 
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'302') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'302') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf
			// CUSTO PER CAPITA DE BENEFÍCIO
			If SRDTRB->RD_PD $ '714,734,780,781,799,778' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'303') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'303') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf

			//jjs-Fim Bloco Codigo O.S 10010

			// Bolsa de Estudos
			If SRDTRB->RD_PD $ '069' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				// Qtde Bolsa de Estudos
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'110') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'110') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Custo com Bolsa de Estudos
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'120') })
				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'120') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf

			// Custo com Folha de Pagto
			If SRDTRB->RD_DATARQ = aMeses[nQtdMes]
				For nElefolha := 16 To 21                                             
					If nElefolha == 18 //pro-labore
						cCodInd := Left(aIndicador[nElefolha,1],3)

						nEleCodInd := Ascan(aVerbas, { |X| X[1] = cCodInd })

						aVerbasTmp := aVerbas[nEleCodInd,2]                                

						If AScan(aVerbasTmp, { |X| X == SRDTRB->RD_PD }) <> 0

							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+cCodInd) })
							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
							EndIf                      

							// Totalizando no geral do indicador
							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+cCodInd) })

							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
							EndIf                      
						EndIf
					ElseIf SRDTRB->RA_CATFUNC $ "M#H#C"
						cCodInd := Left(aIndicador[nElefolha,1],3)

						nEleCodInd := Ascan(aVerbas, { |X| X[1] = cCodInd })

						aVerbasTmp := aVerbas[nEleCodInd,2]                                

						If AScan(aVerbasTmp, { |X| X == SRDTRB->RD_PD }) <> 0

							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+cCodInd) })
							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
							EndIf                      

							// Totalizando no geral do indicador
							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+cCodInd) })

							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
							EndIf                      
						EndIf
					EndIf
				Next
			EndIf

			// Custo com Alimentação
			If SRDTRB->RD_PD = '714' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'180') })
				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'180') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf

			// Custo com Transporte
			If SRDTRB->RD_PD = '720' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes]

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'190') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'190') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      

			EndIf

			// Custo com Adiantamento de 13º Salário
			//If SRDTRB->RD_PD $ '290%291' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes] 
			If SRDTRB->RD_PD = '290' .And. SRDTRB->RD_DATARQ = aMeses[nQtdMes]

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'200') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'200') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
				EndIf                      
			EndIf
		Next

		SRDTRB->(DbSkip())

	EndDo
/*
	// Indicadores Calculados com base dados SRD
	For nQtdMes   := 1 to Len(aMeses)
		//------------
		//CUSTO PER CAPITA DE BENEFÍCIO
		//
		For nQtdFil:=1 to len(aFiliais)
			nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'001' })

			If nEleTOver <> 0
				nTOvFunF := aTotIndica[nEleTOver,nQtdMes+2]
			EndIf                                              

			nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'303' })

			If nEleInd <> 0
				aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFunF),2)
			EndIf                      
		Next
		// Totalizando no geral do indicador
		/*nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] =='0201  '+'303' })

		If nEleInd <> 0
			aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFun)/len(aFiliais),2)
		EndIf
		//
	Next                                 
*/
	//-----------------------------------------------------------
	// Indicadores Calculados com base dados SRC
	//-----------------------------------------------------------
	cFilialSQL := ""
	cVerbasSQL := ""

	For nQtdFil := 1 To Len(aFiliais)
		cFilialSQL += If( Empty(cFilialSQL) , " AND SRC.RC_FILIAL IN (" + "'" + aFiliais[nQtdFil] + "'", ",'" + aFiliais[nQtdFil] + "'" )
	Next

	If !Empty(cFilialSQL)
		cFilialSQL +=  ")"
	EndIf

	For nQtdVer := 1 To Len(aVerbas)
		aVerbasTmp := aVerbas[nQtdVer,2]                                
		For nQtdVer2 := 1 To Len(aVerbasTmp)
			cVerbasSQL += If( Empty(cVerbasSQL) , " AND SRC.RC_PD IN (" + "'" + aVerbasTmp[nQtdVer2] + "'", ",'" + aVerbasTmp[nQtdVer2] + "'" )
		Next
	Next

	If !Empty(cFilialSQL)
		cVerbasSQL +=  ")"
	EndIf

	cSql := "SELECT	* " + Enter
	cSql += "FROM	" + RetSqlName("SRC") + " SRC	" + Enter
	cSql += "INNER JOIN " + RetSqlName("SRA")+ " A ON A.D_E_L_E_T_ = ' ' AND RA_FILIAL = RC_FILIAL AND RA_MAT = RC_MAT "
	cSql += "WHERE	" + Enter	
	//cSql += "RA_CATFUNC IN('M','H') AND " + Enter
	cSql += "		SRC.RC_PERIODO  >= '"+cMesIni+"' AND " + Enter //Emissão a partir de 05/05/2016
	cSql += "		SRC.RC_PERIODO <= '"+cMesFin+"' 	" + Enter

	If !Empty(cFilialSQL)
		cSql += cFilialSQL + Enter
	EndIf

	If !Empty(cVerbasSQL)
		cSql += cVerbasSQL + Enter
	EndIf

	cSql += "AND	SRC.D_E_L_E_T_  != '*'						" + Enter

	TCQUERY cSql NEW ALIAS "SRCTRB"

	DBSelectArea("SRCTRB")
	SRCTRB->(DBGoTop())

	While !SRCTRB->(EoF())       

		//oReport:IncMeter()
		IncProc()

		For nQtdMes := 1 To Len(aMeses)

			//jjs -27/04/2020-O.S 10010 
			// PLANO DE SAÚDE
			If SRCTRB->RC_PD $ '799,778' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				// Custo PLANO DE SAÚDE
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'300') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'300') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf
			// PLANO ODONTOLÓGICO 
			If SRCTRB->RC_PD $ '780,781' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				// Custo PLANO ODONTOLÓGICO 
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'301') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'301') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf
			// CESTA BÁSICA
			If SRCTRB->RC_PD $ '734' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				// Custo PLANO ODONTOLÓGICO 
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'302') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'302') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf
			// CUSTO PER CAPITA DE BENEFÍCIO
			If SRCTRB->RC_PD $ '714,734,780,781,799,778' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'303') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'303') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf

			//jjs-Fim Bloco Codigo O.S 10010

			// Bolsa de Estudos
			If SRCTRB->RC_PD $ '069' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				// Qtde Bolsa de Estudos
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'110') })
				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'110') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Custo com Bolsa de Estudos
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'120') })
				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'120') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf

			// Custo com Folha de Pagto
			If SRCTRB->RC_PERIODO = aMeses[nQtdMes]
				For nElefolha := 16 To 21                                             
					If nElefolha == 18 //pro-labore
						cCodInd := Left(aIndicador[nElefolha,1],3)

						nEleCodInd := Ascan(aVerbas, { |X| X[1] = cCodInd })

						aVerbasTmp := aVerbas[nEleCodInd,2]                                

						If AScan(aVerbasTmp, { |X| X == SRCTRB->RC_PD }) <> 0

							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+cCodInd) })
							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
							EndIf                      

							// Totalizando no geral do indicador
							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+cCodInd) })

							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
							EndIf                      
						EndIf
					ElseIf SRCTRB->RA_CATFUNC $ "M#H#C"
						cCodInd := Left(aIndicador[nElefolha,1],3)

						nEleCodInd := Ascan(aVerbas, { |X| X[1] = cCodInd })

						aVerbasTmp := aVerbas[nEleCodInd,2]                                

						If AScan(aVerbasTmp, { |X| X == SRCTRB->RC_PD }) <> 0

							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+cCodInd) })
							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
							EndIf                      

							// Totalizando no geral do indicador
							nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+cCodInd) })

							If nEleInd <> 0
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
							EndIf                      
						EndIf
					EndIf
				Next
			EndIf

			// Custo com Alimentação
			If SRCTRB->RC_PD = '714' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'180') })
				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'180') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf

			// Custo com Transporte
			If SRCTRB->RC_PD = '720' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes]

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'190') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'190') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      

			EndIf

			// Custo com Adiantamento de 13º Salário
			//If SRDTRB->RC_PD $ '290%291' .And. SRDTRB->RC_PERIODO = aMeses[nQtdMes] 
			If SRCTRB->RC_PD = '290' .And. SRCTRB->RC_PERIODO = aMeses[nQtdMes]

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(RC_FILIAL+'200') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRCTRB->(Left(RC_FILIAL,4)+'  '+'200') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRCTRB->RC_VALOR 
				EndIf                      
			EndIf
		Next

		SRCTRB->(DbSkip())

	EndDo

	//---------------------------------------------------------
	// Indicadores Calculados com base dados SRD
	//---------------------------------------------------------
	For nQtdMes   := 1 to Len(aMeses)
		//------------
		//CUSTO PER CAPITA DE BENEFÍCIO
		//
		For nQtdFil:=1 to len(aFiliais)
			nEleTOver := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'001' })

			If nEleTOver <> 0
				nTOvFunF := aTotIndica[nEleTOver,nQtdMes+2]
			EndIf                                              

			nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'303' })

			If nEleInd <> 0
				aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFunF),2)
			EndIf                      
		Next
		// Totalizando no geral do indicador
		/*nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] =='0201  '+'303' })

		If nEleInd <> 0
			aTotIndica[nEleInd, nQtdMes + 2] := round((aTotIndica[nEleInd, nQtdMes + 2] /nTOvFun)/len(aFiliais),2)
		EndIf*/
	Next                                 

	//__________________________________________________
	// Indicadores Calculados com base dados SPC
	//__________________________________________________

	//------------
	//ABSENTEISMO
	//------------
	For nQtdMes   := 1 to Len(aMeses)

		For nQtdFil:=1 to len(aFiliais)

			nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'311' })

			If nEleInd <> 0
				aTotIndica[nEleInd, nQtdMes + 2] := fAbsent(aFiliais[nQtdFil], aMeses[nQtdMes])
			EndIf                      

			// Totalizando no geral do indicador
			nEleIndT := AScan(aTotIndica, { |X| X[1]+X[2] =='0201  '+'311' })               
			
			If nEleInd <> 0
				aTotIndica[nEleIndT, nQtdMes + 2] := aTotIndica[nEleIndT, nQtdMes + 2] + aTotIndica[nEleInd, nQtdMes + 2]
			EndIf

		Next

	Next                                 


	//--------------------------------------
	//HORAS REALIZADAS X HORAS COMPENSADAS
	//--------------------------------------
	For nQtdMes   := 1 to Len(aMeses)

		For nQtdFil:=1 to len(aFiliais)

			nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == aFiliais[nQtdFil]+'312' })

			If nEleInd <> 0
				aTotIndica[nEleInd, nQtdMes + 2] := fHRcompXrel(aFiliais[nQtdFil], aMeses[nQtdMes])
			EndIf       
	
			// Totalizando no geral do indicador
			nEleIndT := AScan(aTotIndica, { |X| X[1]+X[2] =='0201  '+'312' })               
			
			If nEleInd <> 0
				aTotIndica[nEleIndT, nQtdMes + 2] := aTotIndica[nEleIndT, nQtdMes + 2] + aTotIndica[nEleInd, nQtdMes + 2]
			EndIf
	
		Next

	Next                                 

	DbSelectArea("SR8")
	DbSetOrder(1)      
	SR8->(DBGoTop())    	  

	While !SR8->(EoF())

		For nQtdMes := 1 to Len(aMeses)

			// Indicador de Afastados
			If SR8->R8_TIPO $ 'BOPQRX' .And. (SubStr(DTOS(SR8->R8_DATAINI),1,6) <= aMeses[nQtdMes] .and.;
			(aMeses[nQtdMes] <= SubStr(DTOS(SR8->R8_DATAFIM),1,6) .or. DTOS(SR8->R8_DATAFIM) = '      ') )

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(R8_FILIAL+'050') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(Left(R8_FILIAL,4)+'  '+'050') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf

			// Nº de Afastados por Acidentes
			If SR8->R8_TIPO = 'O' .And. (SubStr(DTOS(SR8->R8_DATAINI),1,6) <= aMeses[nQtdMes] .And.;
			aMeses[nQtdMes] <= SubStr(DTOS(SR8->R8_DATAFIM),1,6) )

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(R8_FILIAL+'160') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(Left(R8_FILIAL,4)+'  '+'160') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

			EndIf

			// Nº de Afastados por Doença
			If SR8->R8_TIPO = 'P' .And. (SubStr(DTOS(SR8->R8_DATAINI),1,6) <= aMeses[nQtdMes] .And.;
			aMeses[nQtdMes] <= SubStr(DTOS(SR8->R8_DATAFIM),1,6) )

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(R8_FILIAL+'170') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR8->(Left(R8_FILIAL,4)+'  '+'170') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf
		Next

		SR8->(DBSkip())

	EndDo

	DbSelectArea("SR7")
	DbSetOrder(1)      
	SR7->(dbGoTop())   

	While !SR7->(EoF())

		For nQtdMes := 1 To Len(aMeses)

			// Indicador de Promoções
			If SR7->R7_TIPO = '004' .And. SubStr(DTOS(SR7->R7_DATA),1,6) = aMeses[nQtdMes] 

				nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SR7->(R7_FILIAL+'090') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR7->(Left(R7_FILIAL,4)+'  '+'090') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf

			// Indicador de Progressões
			If SR7->R7_TIPO = '006' .AND. SUBSTR(DTOS(SR7->R7_DATA),1,6) = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR7->(R7_FILIAL+'100') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SR7->(Left(R7_FILIAL,4)+'  '+'100') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + 1 
				EndIf                      
			EndIf
		Next

		SR7->(DBSkip())

	EndDo

	DbSelectArea("SRR")
	DbSetOrder(4)      
	SRR->(DBGoTop())

	While !SRR->(EoF())

		For nQtdMes := 1 To Len(aMeses)

			// Custo com Demissão
			If SRR->RR_PD $ '490%759%760%761%765' .And. SubStr(DTOS(SRR->RR_DATA),1,6) = aMeses[nQtdMes] 

				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRR->(RR_FILIAL+'130') })
				if nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRR->RR_VALOR 
				EndIf                      

				// Totalizando no geral do indicador
				nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRR->(Left(RR_FILIAL,4)+'  '+'130') })

				If nEleInd <> 0
					aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRR->RR_VALOR 
				EndIf                      
			EndIf

			// Custo com Férias                       
			If SRR->RR_PD $ '470%290%530%548%567%571' .And. SRR->RR_TIPO3 = 'F' .And. SubStr(DTOS(SRR->RR_DATA),1,6) = aMeses[nQtdMes]
				DbSelectArea("SRH")
				//		   If SRH->(DbSetOrder(3),MsSeek(SRR->(RR_FILIAL+RR_MAT+'FER'+dtos(SRR->RR_DATA))),Found())
				SRH->(DbSetOrder(2))
				//If SRH->(DbSeek(SRR->(RR_FILIAL+RR_MAT+'FER'+SubStr(DTOS(SRR->RR_DATA),1,6))))
				If SRH->(DbSeek(SRR->(RR_FILIAL+RR_MAT+SubStr(DTOS(SRR->RR_DATA),1,6))))
					IF SRH->RH_PERIODO = aMeses[nQtdMes]
						//           IF SUBSTR(DTOS(SRH->RH_DATAINI),1,6) = aMeses[nQtdMes]
						DbSelectArea("SRR")   
						nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRR->(RR_FILIAL+'140') })
						If nEleInd <> 0                                                    
							If SRR->RR_PD $ '470%530%548%567%571'
								//If SRR->RR_PD = '470'
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRR->RR_VALOR 
							ElseIf SRR->RR_PD $ '290'
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] - SRR->RR_VALOR 
							EndIf
						EndIf                      

						// Totalizando no geral do indicador
						nEleInd := AScan(aTotIndica, { |X| X[1]+X[2] == SRR->(Left(RR_FILIAL,4)+'  '+'140') })

						If nEleInd <> 0
							//If SRR->RR_PD $ '470%532%549%557%567%170'
							If SRR->RR_PD = '470'
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRR->RR_VALOR 
							ElseIf SRR->RR_PD $ '290'
								aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] - SRR->RR_VALOR 
							EndIf
						EndIf                      
					EndIf
				EndIf        
				DbSelectArea("SRR")
			EndIf
		Next

		SRR->(DBSkip())

	EndDo

	aSort( aTotIndica ,,, { |x,y| x[2]+x[1] < y[2]+y[1] } )

	aMatIndic := Array(Len(aTotIndica),Len(aTotIndica[1])-1)   
	aMFIndic  := {}
	For M := 1 to Len(aTotIndica)
		If Len(Trim(aTotIndica[M,1])) = 4
			nInd := AScan(aCodIndic, { |X| X[1] == aTotIndica[M,2] })

			If nInd <> 0
				aMatIndic[M][1] := SubStr(aIndicador[nInd][1],4,Len(aIndicador[nInd][1])-3 )
			EndIf                      
		Else
			nFlInd := AScan(aFilIndic, { |X| X[1] == aTotIndica[M,1] })

			If nFlInd <> 0
				aMatIndic[M][1] := aFilIndic[nFlInd][2]
			EndIf
		EndIf
		For nM := 1 to Len(aTotIndica[1])-2
			aMatIndic[M][nM+1] := aTotIndica[M][nM+2]
		Next
	Next    			   	   

	fImpMat(aMatIndic)

Return

Static Procedure VerPerg()

	LOCAL aRegs := {}        
	LOCAL nA 	:= 0

	DbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := "ANLRIGPE  "
	aAdd(aRegs,{cPerg,"01","Da Filial:","mv_ch1","C",6,0,1,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","A  Filial:","mv_ch2","C",6,0,1,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Da Data  :","mv_ch3","D",8,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","A  Data  :","mv_ch4","D",8,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For nA := 1 to Len(aRegs)

		If !(dbSeek(PADR(aRegs[nA,1],10)+aRegs[nA,2]))

			RecLock("SX1",.T.)
			Replace X1_GRUPO    With aRegs[nA][1]
			Replace X1_ORDEM    With aRegs[nA][2]
			Replace X1_PERGUNT  With aRegs[nA][3]
			Replace X1_PERSPA   With aRegs[nA][3]
			Replace X1_PERENG   With aRegs[nA][3]
			Replace X1_VARIAVL  With aRegs[nA][4]
			Replace X1_TIPO     With aRegs[nA][5]
			Replace X1_TAMANHO  With aRegs[nA][6]
			Replace X1_GSC      With aRegs[nA][9]
			Replace X1_DECIMAL  With aRegs[nA][7]
			Replace X1_PRESEL   With aRegs[nA][8]
			Replace X1_VAR01    With aRegs[nA][11]
			Replace X1_DEF01    With aRegs[nA][12]
			Replace X1_DEF02    With aRegs[nA][15]
			Replace X1_DEFSPA1  With aRegs[nA][12]
			Replace X1_DEFSPA2  With aRegs[nA][15]
			Replace X1_DEFENG1  With aRegs[nA][12]
			Replace X1_DEFENG2  With aRegs[nA][15]
			Replace X1_F3       With aRegs[nA][38]		
			MsUnlock()

		EndIf

	Next nA

Return

//-----------------------------------------------------------------------
// Rotina | fImpMat      | Autor | Ricardo Campelo    | Data | 26.10.2016
//-----------------------------------------------------------------------
// Descr. | Tratamento de impressão dos dados por meio de um Array.
//-----------------------------------------------------------------------
// Uso    | Módulo Financeiro     
//-----------------------------------------------------------------------
Static Function fImpMat(aMatFn)

	Local aCpo   := {}
	Local aCab   := {}
	Local aDados := {} 
	//Local aMesFm := {}
	Local nI  := 0
	//Local nIc := 0
	Local nJ  := 0  
	Local nM  := 0
	Local nC  := 0  
	Local oReport

	//Local cCpo := "Emissão;Filial;Qtde;Vlr Total"
	//      aCpo := _Str2Arr(cCpo, ";")
	/*                                                                                  
	For nM := 1 to Len(aMeses)
	AADD(aMesFm,{substr(aMeses[nM],3,2)+"/"+substr(aMeses[nM],1,2)})
	Next

	AADD(aCpo,{"Indicador/Filial"})
	//For nIc := 1 to Len(aMesFm)
	//    AADD(aCpo,aMesFm[nIc])
	*/    		 	 

	AAdd(aCpo,{"Indicador/Filial"})
	For nM := 1 to Len(aMeses)
		AAdd(aCpo,{".      "+SubStr(aMeses[nM],5,2)+"/"+SubStr(aMeses[nM],1,4)})
	Next

	For nI := 1 To Len(aCpo)
		AAdd( aCab, aCpo[nI] )
	Next nI

	aDados := Array(Len(aMatFn),Len(aCpo))
	For nJ := 1 To Len(aMatFn)
		aDados[nJ][1] := aMatFn[nJ,1]  
		For nC := 1 to Len(aCpo)-1
			aDados[nJ][nC+1] := aMatFn[nJ][nC+1]
		Next nC
	Next nJ

	/*	
	For nJ := 1 To Len(aMatFn)
	AAdd( aDados, {aMatFn[nJ,1],aMatFn[nJ,2],aMatFn[nJ,3],aMatFn[nJ,4]} )
	Next nJ
	*/

	If  Len( aDados ) > 0
		oReport := xDefArray( aDados, aCab )
		oReport:PrintDialog()
	Else
		MsgInfo('Não foi possível localizar os dados, verifique os parâmetros.','Titulos com mais de 3(três) parcelas')
	Endif

Return

//-----------------------------------------------------------------------
// Rotina | xDefArray    | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Definição de impressão dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xDefArray( aCOLS, aHeader )

	Local oReport
	Local oSection 
	Local nLen := Len(aHeader)
	Local nX := 0

	/*
	+-------------------------------------+
	| Método construtor da classe TReport |
	+-------------------------------------+
	New(cReport,cTitle,uParam,bAction,cDescription,lLandscape,uTotalText,lTotalInLine,cPageTText,lPageTInLine,lTPageBreak,nColSpace)

	cReport			- Nome do relatório. Exemplo: MATR010
	cTitle			- Título do relatório
	uParam			- Parâmetros do relatório cadastrado no Dicionário de Perguntas (SX1). Também pode ser utilizado bloco de código para parâmetros customizados.
	bAction			- Bloco de código que será executado quando o usuário confirmar a impressão do relatório
	cDescription	- Descrição do relatório
	lLandscape		- Aponta a orientação de página do relatório como paisagem
	uTotalText		- Texto do totalizador do relatório, podendo ser caracter ou bloco de código
	lTotalInLine	- Imprime as células em linha
	cPageTText		- Texto do totalizador da página
	lPageTInLine	- Imprime totalizador da página em linha
	lTPageBreak		- Quebra página após a impressão do totalizador
	nColSpace		- Espaçamento entre as colunas

	Retorno	Objeto
	*/                                                                       

	oReport := TReport():New( "ANLRIGPE", "Indicadores de Custo DP/RH", , {|oReport| xImprArray( oReport, aCOLS )},"Relatório TReport com Array ")

	DEFINE SECTION oSection OF oReport TITLE "Indicadores de Custo DP/RH" TOTAL IN COLUMN

	For nX := 1 To nLen
		DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE 30 TITLE aHeader[nX][1]
	Next nX

	/*
	+---------------------------------------+	
	| Define o espaçamento entre as colunas |
	+---------------------------------------+
	SetColSpace(nColSpace,lPixel)

	nColSpace	- Tamanho do espaçamento
	lPixel		- Aponta se o tamanho será calculado em pixel
	*/
	oSection:SetColSpace(0)

	// Quantidade de linhas a serem saltadas antes da impressão da seção
	oSection:nLinesBefore := 2

	/*
	+--------------------------------------------------------------------------------------------------------------+
	| Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página |
	+--------------------------------------------------------------------------------------------------------------+
	SetLineBreak(lLineBreak)

	lLineBreak - Se verdadeiro, imprime em uma ou mais linhas
	*/

	oSection:SetLineBreak(.F.)

Return( oReport )

//-----------------------------------------------------------------------
// Rotina | xImprArray   | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xImprArray( oReport, aCOLS )

	Local oSection := oReport:Section(1) // Retorna objeto da classe TRSection (seção). Tipo Caracter: Título da seção. Tipo Numérico: Índice da seção segundo a ordem de criação dos componentes TRSection.
	Local nX := 0
	Local nY := 0

	/*
	+-----------------------------------------------------+
	| Define o limite da régua de progressão do relatório |
	+-----------------------------------------------------+
	SetMeter(nTotal)

	nTotal - Limite da régua

	*/
	oReport:SetMeter( Len( aCOLS ) )	

	/*
	+---------------------------------------------------------------------+
	| Inicializa as configurações e define a primeira página do relatório |
	+---------------------------------------------------------------------+
	Init()

	Não é necessário executar o método Init se for utilizar o método Print, já que estes fazem o controle de inicialização e finalização da impressão.
	*/
	oSection:Init()

	For nX := 1 To Len( aCols )
		// Retorna se o usuário cancelou a impressão do relatório
		If oReport:Cancel()
			Exit
		EndIf

		For nY := 1 To Len(aCols[ nX ])
			If ValType( aCols[ nX, nY ] ) == 'D'
				// Cell() - Retorna o objeto da classe TRCell (célula) baseado. Tipo Caracter: Nome ou título do objeto. Tipo Numérico: Índice do objeto segundo a ordem de criação dos componentes TRCell.
				// SetBlock() - Define o bloco de código que retornará o conteúdo de impressão da célula. Definindo o bloco de código para a célula, esta não utilizara mais o nome mais o alias para retornar o conteúdo de impressão.
				oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + DToC(aCols[ nX, nY ]) + "'}") )
			Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
				oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + TransForm(aCols[ nX, nY ],'@E 999,999,999.99') + "'}") )
			Else
				oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + aCols[ nX, nY ] + "'}") )
			Endif
		Next

		// Incrementa a régua de progressão do relatório
		oReport:IncMeter()

		/*
		+------------------------------------------------+
		| Imprime a linha baseado nas células existentes |
		+------------------------------------------------+
		PrintLine(lEvalPosition,lParamPage,lExcel)

		lEvalPosition	- Força a atualização do conteúdo das células 
		lParamPage		- Aponta que é a impressão da página de parâmetros
		lExcel			- Aponta que é geração em planilha

		*/
		oSection:PrintLine()

	Next

	/*
	Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
	Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
	*/
	oSection:Finish()

Return

/*
If SRDTRB->RD_PD $ '999' .AND. SRDTRB->RD_DATARQ = aMeses[nQtdMes]
DbSelectArea("SRA")
If SRA->(DbSetOrder(1),MsSeek(SRD->(RD_FILIAL+RD_MAT)),Found())
IF SRA->RA_CATFUNC = 'P'
DbSelectArea("SRDTRB")   
nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'150') })
if nEleInd <> 0                                                    
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] - SRDTRB->RD_VALOR
EndIf

*- Totalizando no geral do indicador
nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'150') })

if nEleInd <> 0
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] - SRDTRB->RD_VALOR
Endif   
Else
DbSelectArea("SRDTRB")   
nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'150') })
if nEleInd <> 0                                                    
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR
EndIf

*- Totalizando no geral do indicador
nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'150') })

if nEleInd <> 0
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR
EndIf
EndIf                        
EndIf                      

ElseIf SRDTRB->RD_PD $ '411%450%740%755%815%816%817%818%819%820' .AND. SRDTRB->RD_DATARQ = aMeses[nQtdMes]

nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(RD_FILIAL+'150') })
if nEleInd <> 0
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
EndIf                      

*- Totalizando no geral do indicador
nEleInd := Ascan(aTotIndica, { |X| X[1]+X[2] == SRDTRB->(Left(RD_FILIAL,4)+'  '+'150') })

if nEleInd <> 0
aTotIndica[nEleInd, nQtdMes + 2] := aTotIndica[nEleInd, nQtdMes + 2] + SRDTRB->RD_VALOR 
EndIf                      

EndiF
*/


//-----------------------------------------------------------------------
// Rotina | fAbsent   | Autor | Gustavo Costa | Data | 10.08.2021
//-----------------------------------------------------------------------
// Descr. | Calcula o absenteismo da empresa em um período.
//-----------------------------------------------------------------------

Static Function fAbsent( cEmp, cAnoMes )

Local cSql := ""
Local nRet := 0

cSql := "SELECT " + Enter
cSql += "SUM( CASE WHEN PC_PD IN ('001','005','026') THEN PC_QUANTC ELSE 0 END) HORA_NORMAL," + Enter
cSql += "SUM( CASE WHEN PC_PD IN ('008','010','014','020') THEN PC_QUANTC ELSE 0 END) FALTA" + Enter
cSql += "FROM " + RetSqlName("SPC") + " PC	" + Enter
cSql += "INNER JOIN " + RetSqlName("SP9") + " P9 " + Enter
cSql += "ON PC_FILIAL = P9_FILIAL AND + PC_PD = P9_CODIGO " + Enter
cSql += "WHERE SUBSTR(PC_DATA,1,6) = '" + cAnoMes + "' " + Enter
cSql += "AND pC.d_e_l_e_t_ <> '*'" + Enter
cSql += "AND p9.d_e_l_e_t_ <> '*'" + Enter
cSql += "AND PC_FILIAL = '" + cEmp + "' " + Enter
cSql += "AND pC.pC_abono = '   ' "

TCQUERY cSql NEW ALIAS "TMP"

DBSelectArea("TMP")
TMP->(DBGoTop())

If !TMP->(EoF())       

	nRet := (TMP->FALTA / TMP->HORA_NORMAL) * 100

EndIf

TMP->(DBCLOSEAREA())

RETURN nRet


//-----------------------------------------------------------------------
// Rotina | fAbsent   | Autor | Gustavo Costa | Data | 10.08.2021
//-----------------------------------------------------------------------
// Descr. | Calcula o absenteismo da empresa em um período.
//-----------------------------------------------------------------------

Static Function fHRcompXrel( cEmp, cAnoMes )

Local cSql 		:= ""
Local nRet 		:= 0
Local nHRel		:= 0
Local nHEcomp	:= 0

//_____________________________________________
// HORA EXTRA QUE FOI COMPENSADA NO BH
//_____________________________________________

cSql := "SELECT SUM( PC_QUANTC ) VALOR " + Enter
cSql += "FROM " + RetSqlName("SPC") + " PC	" + Enter
cSql += "WHERE SUBSTR(PC_DATA,1,6) = '" + cAnoMes + "' " + Enter
cSql += "AND pC.d_e_l_e_t_ <> '*' " + Enter
cSql += "AND PC_FILIAL = '" + cEmp + "' " + Enter
cSql += "AND PC_PD IN ('043','044','045','047','048','049','050') " + Enter
cSql += "AND PC.PC_ABONO IN ( SELECT P6_CODIGO FROM DADOSANL.sp6010 P6 WHERE P6_CODIGO = '005' AND p6.d_e_l_e_t_ <> '*' ) " 

TCQUERY cSql NEW ALIAS "TMP"

DBSelectArea("TMP")
TMP->(DBGoTop())

If !TMP->(EoF())       

	nHEcomp := TMP->VALOR

EndIf

TMP->(DBCLOSEAREA())

//_____________________________________________
// HORAS NORMAIS TRABALHADAS
//_____________________________________________

cSql := "SELECT SUM( PC_QUANTC ) VALOR " + Enter
cSql += "FROM " + RetSqlName("SPC") + " PC	" + Enter
cSql += "WHERE SUBSTR(PC_DATA,1,6) = '" + cAnoMes + "' " + Enter
cSql += "AND pC.d_e_l_e_t_ <> '*' " + Enter
cSql += "AND PC_FILIAL = '" + cEmp + "' " + Enter
cSql += "AND PC_PD IN ('001','005','026') " + Enter

TCQUERY cSql NEW ALIAS "TMP"

DBSelectArea("TMP")
TMP->(DBGoTop())

If !TMP->(EoF())       

	nHRel := TMP->VALOR

EndIf

TMP->(DBCLOSEAREA())

IF nHEcomp > 0

	nRet	:= ( nHEcomp / nHRel ) * 100

ENDIF

RETURN nRet

