#INCLUDE "Topconn.ch"
#include "protheus.ch"
#include "parmtype.ch"

/*
Autor: Denisson Danilo
Data: 08/02/19
Verifica se a NF foi autorizada, e gera o arquivo de integração com a empresa de entrega. (ex: moto29)
Esta Função substituiu o POnto de entrada SPDNFDANF
*/
User Function IntTransp(_cEmp,_cNota,_cSerie,_cChvnfe)
	Local cEmp   := _cEmp
	Local cNota  := _cNota
	Local cSerie := _cSerie
	Local cChave := _cChvnfe
	
	If SF2->F2_FIMP == 'S' .AND. SF2->F2_XINTEGR <> '1'
		dbSelectArea("SA4")
		SA4->(dbSetOrder(1))
		If SA4->(dbSeek(xFilial("SA4") + SF2->F2_TRANSP))
			If ! Empty(SA4->A4_XINTEGR)
				If MontArq(cChave)
					RecLock("SF2",.F.)
					Replace F2_XINTEGR with '1'
					SF2->(MsUnlock())
				EndIf
			EndIf
		Else
			MsgAlert("Transportadora "+SF2->F2_TRANSP+" não encontrada.")
		EndIf
	EndIf

Return

Static Function MontArq(cChave)
	Local cTexto 	:= ""
	Local aDadosPed	:= {}
	Local aEnd		:= {}
	Local cNumPed	:= ""	
	Local cEmisPed	:= ""
	Local cHoraPed	:= ""
	Local cLogra	:= ""
	Local cNumEnd	:= ""
	Local cTel		:= ""
	local lRet		:= .F.
	Local cNumNf    := ""

	//Trata dados do pedido
	aDadosPed	:= fPesqPed(cChave)
	cNumPed		:= aDadosPed[1]
	cEmisPed 	:= aDadosPed[2]
	cHoraPed 	:= aDadosPed[3]

	//Posiciona no cliente
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))

	//Trata endereço
	aEnd	:= fTratEnd()
	cLogra	:= aEnd[1]
	cNumEnd	:= aEnd[2]

	//Trata telefone
	cTel	:= Alltrim(SA1->A1_DDD) + Alltrim(SA1->A1_TEL)

	//Trata a Data da Nota Fiscal
	cNumNf := SubStr(DToS(SF2->F2_EMISSAO),1,4) + "-" + SubStr(DToS(SF2->F2_EMISSAO),5,2) + "-" + SubStr(DToS(SF2->F2_EMISSAO),7,2)

	cTexto += '"'+ cNumPed +'",'                                           //Código do pedido (pode ser o número da NF caso não exista)
	cTexto += '"'+ cEmisPed + ' ' + cHoraPed +'",'                         //Data hora da solicitação do cliente. Formato exemplo: 2016-10-19 08:45:30
	cTexto += '"'+ Alltrim(SF2->F2_DOC) +'/'+ Alltrim(SF2->F2_SERIE) +'",' //Número da NF
	cTexto += '"'+ cNumNf + ' ' + SF2->F2_HORA +'",'                       //Data hora do faturamento. Formato exemplo: 2016-10-19 08:45:30
	//cTexto += '"'+ DToC(SF2->F2_EMISSAO) + ' ' + SF2->F2_HORA +'",'        //Data hora do faturamento. Formato exemplo: 2016-10-19 08:45:30
	cTexto += '"'+ Alltrim(SF2->F2_CLIENTE) +'",'                                   //Código do cliente
	cTexto += '"'+ Alltrim(UPPER(cLogra)) +'",'                            //Logradouro
	cTexto += '"'+ Alltrim(UPPER(cNumEnd)) +'",'                           //Número
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_COMPLEM)) +'",'	               //Complemento
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_BAIRRO)) +'",'                    //Bairro
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_MUN)) +'",'                       //Cidade
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_EST)) +'",'                       //UF
	cTexto += '"",'                                                        //Observação do pedido
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_NOME)) +'",'                      //Nome do cliente
	cTexto += '"",'                                                        //Número telefone móvel do cliente
	cTexto += '"'+ cTel +'",'                                              //Número telefone fixo do cliente
	cTexto += '"'+ Alltrim(UPPER(SA1->A1_EMAIL)) +'",'                     //E-mail do cliente
	cTexto += '"2",'                                                       //Tipo venda (1 - Venda balcão, 2 - Tele-venda )
	cTexto += '"'+ Alltrim(UPPER(SA4->A4_XINTEGR)) +'",'                   //Nome transportadora (CARRO PRÓPRIO ou Nome da empresa terceirizada)
	cTexto += '"'+ Alltrim(UPPER(SA4->A4_XINTEGR)) +'",'                   //Código transportadora
	cTexto += '"'+ cValToChar(SF2->F2_VOLUME1) +'",'                       //Número de volumes da entrega
	cTexto += '"'+ cValToChar(SF2->F2_PBRUTO) +'",'                        //Peso total
	cTexto += '"0",'         //Urgência da entrega (0 - normal; 1-urgente)
	cTexto += '"",'          //Código do carregamento ou roteiro (deixar vazio se não for o caso)
	cTexto += '"",'          //Código do motorista ou entregador (deixar vazio se não for o caso)
	cTexto += '"",'          //Nome do motorista ou entregador (deixar vazio se não for o caso)
	cTexto += '"",'          //Sequência no carregamento (deixar vazio se não for o caso)

	If GeraArq(cTexto,cNumPed)
		lRet := .T.
	EndIf

Return lRet

Static Function fTratEnd()
	Local cEnd	:= SA1->A1_END
	Local cLogra:= ""
	Local cNum	:= ""
	
	Private aEnd:= {}
	
	aEnd := Separa(cEnd,",")
	
	If type("aEnd[1]") == "C"
		cLogra := Alltrim(aEnd[1])
	EndIf
	
	If type("aEnd[2]") == "C"
		cNum := Alltrim(aEnd[2])
	EndIf
	
Return {cLogra,cNum} 

Static Function fPesqPed(cChave)
	Local cQuery
	Local cNum	:= ""
	Local cHora := ""
	Local cData := ""
	
	cQuery := " SELECT C5_NUM, C5_EMISSAO, C5_XHORA FROM "+ RETSQLNAME("SF2") +" A "
	cQuery += "     INNER JOIN "+ RETSQLNAME("SD2") +" B " 
	cQuery += "         ON B.D_E_L_E_T_ = ' ' " 
	cQuery += "         AND F2_FILIAL = D2_FILIAL " 
	cQuery += "         AND F2_DOC = D2_DOC " 
	cQuery += "         AND F2_SERIE = D2_SERIE "
	cQuery += "     INNER JOIN "+ RETSQLNAME("SC5") +" C " 
	cQuery += "         ON C.D_E_L_E_T_ = ' ' " 
	cQuery += "         AND D2_FILIAL = C5_FILIAL "
	cQuery += "         AND D2_PEDIDO = C5_NUM "
	cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_CHVNFE = '"+ cChave +"' "
		
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSC5")
	
	If !QSC5->(EOF())
		cNum 	:= Alltrim(QSC5->C5_NUM)
		cHora 	:= QSC5->C5_XHORA
		cData 	:= substr(QSC5->C5_EMISSAO,1,4) + "-" + substr(QSC5->C5_EMISSAO,5,2) + "-" + substr(QSC5->C5_EMISSAO,7,2)
		//cData 	:= CTOD(QSC5->C5_EMISSAO)
	EndIf
	
	QSC5->(dbCloseArea())
	
Return {cNum,cData,cHora}

Static function GeraArq(cTexto,cNumPed)
	Local cArq 		:= "pedido_"+cFilAnt+"_"+cNumPed+".csv"
	Local cDirTemp	:= "C:\temp\"
	Local cDir		:= SuperGetMV("MV_XDIRFAT",.F.,"C:\ATIVROTA\")
	Local nHandle 	:= FCREATE(cDirTemp + cArq)
	Local lRet		:= .F.
    Local lCriaDir := .F.


    lCriaDir := U_CriaDirt(cDir,.T.,.F.) //Função para verificar e criar o diretorio para salvar os arquivos
	
	If nHandle = -1
		Alert("Erro ao criar o arquivo de integracao no caminho -> C:\temp\  " + Str(Ferror()))
	Else
		FWrite(nHandle, cTexto )
		FClose(nHandle)
		
		If !Empty(cDir)
			If ! __CopyFile(cDirTemp + cArq, cDir + cArq)
				//Alert("Erro ao copiar arquivo.")
			Else
				FErase(cDirTemp + cArq)
				lRet := .T.
			EndIf
		EndIf
		
	Endif

return lRet
