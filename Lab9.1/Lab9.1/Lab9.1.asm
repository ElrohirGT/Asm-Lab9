; Universidad del Valle de Guatemala
; Organización de Computadoras y Assembler
; Daniel Rayo 22933
; Flavio Galán 22386
; Description: Un evaluador de régimen de SAT y obligaciones fiscales.

includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib

.386
.model flat, C

printf proto c : vararg
scanf proto c : vararg
;extrn scanf:near

.data

	DC2022 byte "2022",0
	
	; MESES
	enero byte "Enero",0
	febrero byte "Febrero",0
	marzo byte "Marzo",0
	abril byte "Abril",0
	mayo byte "Mayo",0
	junio byte "Junio",0 
	julio byte "Julio",0
	agosto byte "Agosto",0
	septiembre byte "Septiembre",0
	octubre byte "Octubre",0
	noviembre byte "Noviembre",0
	diciembre byte "Diciembre",0
	
	; CLIENTES
	marta byte "Marta", 0
	daniel byte "Daniel", 0
	marco byte "Marco", 0

	; NITS
	nits dword 9488634, 2802904, 9731927, 9488634, 2802904, 9731927, 9488634, 2802904, 9731927, 9488634, 2802904, 9731927
	
	; MONTOS
	montos dword 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	askMontoFormat byte "Monto factura %d: ",0
	montoScannFormat byte "%d",0
	
	; IVAs
	ivas dword 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
	montoAnual dword 0
	limiteISR dword 150000
	i dword 0

	; TABLE
	tHeader byte "|    ANO     |    MES     |   NOMBRE   |    NIT     |    MONTO   |    IVA     |",0Ah,0
	tDivider byte "-------------------------------------------------------------------------------",0Ah,0
	trfStrings byte "| %-10s | %-10s | %-10s |",0
	tNumberFormat byte " %10d |",0
	tcellValue dword 0
	
	newLine byte 0Ah,0

	montoMessageFormat byte "El IVA asciende a: %d.",0Ah, 0
	invalidRegimenMessage byte "Regimen invalido, por favor cambiarse a IVA general",0Ah,0
	validRegimenMessage byte "Regimen valido, puede continuar como pequeno contribuyente",0Ah,0
	endMessage byte "Feliz dia",0

.code
	main proc

	loopIsr:
		mov esi, offset montos; esi = montos
		mov edi, offset ivas; edi = isrs
		inc i
		invoke printf, addr askMontoFormat, i 
		dec i

		mov ebx, i
		imul ebx, 4; 4x8 is the size of dword
		invoke scanf, addr montoScannFormat, addr [esi + ebx]
		mov eax, [esi + ebx]; eax = ith element in montos

		; eax * 5% for ISR
		mov ecx, 5
		mul ecx
		mov ecx, 100
		div ecx

		; add eax to montoAnual
		add montoAnual, eax

		mov [edi + ebx], eax; Save eax on isrs

		; Loop logic, stop when i = 12
		inc i
		cmp i, 12
		jl loopIsr

		;Print table title
		invoke printf, addr tHeader
		invoke printf, addr tDivider

		; Reset the counter
		mov i, 0	
	printCellStart:
		mov ebx, i
		imul ebx, 4; 32 is the size of dword

		cmp i,0
		je factura1

		cmp i,1
		je factura2

		cmp i,2
		je factura3

		cmp i,3
		je factura4

		cmp i,4
		je factura5

		cmp i,5
		je factura6

		cmp i,6
		je factura7

		cmp i,7
		je factura8

		cmp i,8
		je factura9

		cmp i,9
		je factura10

		cmp i,10
		je factura11

		cmp i,11
		je factura12

		printNumberValues:
			mov eax, offset nits
			mov eax, [eax + ebx]
			mov tcellValue, eax
			call printInnerCell

			mov eax, offset montos
			mov eax, [eax + ebx]
			mov tcellValue, eax
			call printInnerCell

			mov eax, offset ivas
			mov eax, [eax + ebx]
			mov tcellValue, eax
			call printInnerCell
			
		invoke printf, addr newLine

		inc i
		cmp i, 12
		jl printCellStart

		invoke printf, addr montoMessageFormat, montoAnual

		mov eax, montoAnual
		cmp  eax, limiteISR
		jg regimenInvalido
		jl regimenValido

		regimenInvalido:
			invoke printf, addr invalidRegimenMessage
			jmp printEnd
		regimenValido:
			invoke printf, addr validRegimenMessage

		printEnd:
			invoke printf, addr endMessage
			RET


	;|   ANO    |   MES    |  NOMBRE  |   NIT    |   MONTO  |   ISR    |
	factura1:
		invoke printf, addr trfStrings, addr DC2022, addr junio, addr marta
		jmp printNumberValues

	factura2:
		invoke printf, addr trfStrings, addr DC2022, addr julio, addr daniel
		jmp printNumberValues

	factura3:
		invoke printf, addr trfStrings, addr DC2022, addr agosto, addr marco
		jmp printNumberValues

	factura4:
		invoke printf, addr trfStrings, addr DC2022, addr septiembre, addr marta
		jmp printNumberValues

	factura5:
		invoke printf, addr trfStrings, addr DC2022, addr octubre, addr daniel
		jmp printNumberValues
	
	factura6:
		invoke printf, addr trfStrings, addr DC2022, addr noviembre, addr marco
		jmp printNumberValues
	
	factura7:
		invoke printf, addr trfStrings, addr DC2022, addr diciembre, addr marta
		jmp printNumberValues
	
	factura8:
		invoke printf, addr trfStrings, addr DC2022, addr enero, addr daniel
		jmp printNumberValues
	
	factura9:
		invoke printf, addr trfStrings, addr DC2022, addr febrero, addr marco
		jmp printNumberValues
	
	factura10:
		invoke printf, addr trfStrings, addr DC2022, addr marzo, addr marta
		jmp printNumberValues
	
	factura11:
		invoke printf, addr trfStrings, addr DC2022, addr abril, addr daniel
		jmp printNumberValues
	
	factura12:
		invoke printf, addr trfStrings, addr DC2022, addr mayo, addr marco
		jmp printNumberValues	
	
	printInnerCell:
		invoke printf, addr tNumberFormat, tcellValue
		RET

	main ENDP
END