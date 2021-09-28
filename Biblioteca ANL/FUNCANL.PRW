#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "rwmake.ch"
#INCLUDE "RPTDEF.CH"
#Include "Directry.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
24/09/2021
Denisson Danilo
--Fun��o para verificar e criar diretorio de arquivos
Parametros da Fun��o:

cPath - Caminho do diretorio ser verificado e criado
lDrive - Flag para controlar a digita��o da unidade de drive.
lMSg - Flag para verificar se deve questionar sobre criar diret�rio

Returno da Fun��o:
Retorna .T. quando o diretorio for criado e .F. quando n�o conseguiu criar
*/
User Function CriaDirt( cPath, lDrive, lMSg )
    //Local aDir
    Local lDir
    Local lRet:=.T.
    Default lMSg := .T.
 
    If Empty(cPath)
        Return lRet
    EndIf
    
    lDrive := If(lDrive == Nil, .T., lDrive)
    
    cPath := Alltrim(cPath)
    If Subst(cPath,2,2) <> ":" .AND. lDrive
        MsgInfo("Unidade de drive n�o especificada") //Unidade de drive n?o especificada
        lRet:=.F.
    Else
        cPath := If(Right(cPath,1) == "", Left(cPath,Len(cPath)-1), cPath)
        //aDir  := Directory(cPath,"D")
        lDir := ExistDir(cPath)
        If !lDir
            If lMSg
                If MsgYesNo("Diretorio - "+cPath+" - nao encontrado, deseja cria-lo" ) //Diretorio  -  nao encontrado, deseja cria-lo
                    If MakeDir(cPath) <> 0
                        Help(" ",1,"NOMAKEDIR")
                        lRet := .F.
                    EndIf
                EndIf
            Else
                If MakeDir(cPath) <> 0
                    Help(" ",1,"NOMAKEDIR")
                    lRet := .F.
                EndIf
            EndIF
        EndIf
    EndIf
Return lRet


/*
24/09/2021
Denisson Danilo
--Fun��o para calcular o Digito verificador em Modulo 10
Parametros da Fun��o:
cData - String com os numeros que devera calcular o digito verificador em Modulo 10

Retorno da Fun��o:
Retorno o digito verificardo em Modulo 10
*/
User Function CalcMd10(cData)
    Local aNros         := {}
    Local _cProdutos := ''
    Local _nSoma        := 0
    LOCAL i
    
    For i := Len(cData) To 1 Step -1
        AADD(aNros,Subs(cData,i,1))
    Next
    For i := 1 To Len(aNros)
        If !( i%2 ) = 0
            /*[ Posicao Par na Sequencia ]*/
            _cProdutos := _cProdutos+Alltrim(Str(Val(aNros[i])*2    ))
        Else
            /*[ Posicao Impar na Sequencia ]*/
            _cProdutos := _cProdutos+Alltrim(Str(Val(aNros[i])*1))
        Endif
    Next
    For i:= 1 To Len(_cProdutos)
        _nSoma := _nSoma+Val(Subs(_cProdutos,i,1))
    Next
    _nDV  := 10 - Mod(_nSoma,10)
    _nDV  := IIF( _nDV==10, 0, _nDV )
    _cDv  :=    Alltrim(Str(_nDV))
    
Return(_cDV)
