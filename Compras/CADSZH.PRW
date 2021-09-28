#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CADSZH-Aprovacao Import XML AM Paulo Suporte  Data 07/09/21   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO SZH                                                ±±       
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AUTO NORTE                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß            
*/

USER FUNCTION CADSZH()

LOCAL cAlias  := "SZH"
Local cFiltro := ""

PRIVATE cCadastro := "XMLS BLOQUEADOS"
PRIVATE aRotina   := {}
Private aCores	  := {}

AADD(aRotina,{"Liberar XML","U_ANSZH(1)" , 0, 7, 0, Nil })
AADD(aRotina,{"Pesquisar"  ,"AxPesqui"   , 0, 1 })
AADD(aRotina,{"Visualizar" ,"AxVisual"   , 0, 2 })
AADD(aRotina,{"Legenda"     ,"U_LEGSZH()",0,5})

aCores := {{'ZH_STATUS=="P"','BR_VERMELHO'},;
	       {'ZH_STATUS=="A"','BR_VERDE'}}

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(6, 1, 22, 75, cAlias,,,,,,aCores,,,,,,,,cFiltro)

RETURN 

// Chamada Legenda
User Function LEGSZH()

Local aLegenda	:= {}

aLegenda := {{"BR_VERMELHO","XML Pendente" },;
             {"BR_VERDE"   ,"XML Aprovado" }}
                 
BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return

// Chamada para InclusÃ£o
User Function ANSZH(nRot)

Local cUsuLib := GETMV("AN_USLIXML")

IF !(RetCodUsr() $ cUsuLib)
    MSGSTOP("Usuario sem permissao de Liberacao")
END IF

IF RetCodUsr() $ cUsuLib
    If MsgYesNo("Confirma a Liberacao do XML")

        Reclock("SZH",.F.)
        SZH->ZH_STATUS := "A"
        SZH->ZH_USRAPR := RetCodUsr()
        Msunlock()
        MSGINFO("XML Liberado")

    End If
END IF

Return
