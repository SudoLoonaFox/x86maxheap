global _start

section .data
	intArray dd 20
	arraySize dd 20

section .text
maxHeapify:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	; esi is left
	; edi is right
	; ebx is largest
	; param 1 is pointer to array at ebp + 8
	; param 2 is size of array at ebp + 12
	; param 3 is index at ebp + 16
	mov esi, [ebp + 16]; left
	imul esi, 2
	add esi, 1
	mov edi, [ebp + 16]; right
	imul edi, 2
	add edi, 2
	mov ebx, [ebp + 16]; largest
	mov eax, [ebp + 8]; pointer to the start of array
	; left if statments
	cmp esi, [ebp + 12]
	jg leftJump
	push esi
	mov esi, [eax, esi]
	cmp esi, [eax + ebx]; compares left to heap[largest]
	pop esi
	jl leftJump
	mov ebx, esi
	leftJump:
	; right if statments	
	cmp edi, [ebp + 12]
	jg rightJump
	push edi
	mov edi, [eax, edi]
	cmp edi, [eax + ebx]; compares left to heap[largest]
	pop edi
	jl rightJump
	mov ebx, edi
	rightJump:
	
	cmp ebx, [ebp + 16]; compare index and largest
	je endMaxHeapify
	mov esi, [ebp + 16]
	; swap(&heap[i], &heap[largest]);
	; eax is the array pointer
	; ebx is the largest
	; esi is [ebp + 16] is the index
	mov edi, [eax + ebx]; value of largest
	mov [eax + ebx], esi; replace value of largest in array with value at index
	mov [eax + esi], edi
	; call maxheapify
	
	; param 1 is pointer to array at ebp + 8
	; param 2 is size of array at ebp + 12
	; param 3 is index at ebp + 16
	mov eax, [ebp + 16]
	push eax
	mov eax, [ebp + 12]
	push eax
	mov eax, [ebp + 8]
	push eax
	call maxHeapify

	endMaxHeapify:

	pop esi
	pop edi
	pop ebx
	mov esp, ebp
	pop ebp
	ret

buildHeap:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	
	; esi is iter
	; param 1 is pointer to array at ebp + 8
	; param 2 is size of array at ebp + 12

	shr esi, 1; divide int by 2
	sub esi, 1
	buildFor:
		push eax
		push ecx
		push edx
		push esi; index
		push dword [ebp + 12]; size of array
		push dword [ebp + 8]; pointer to array
		call maxHeapify
		add esp, 12; reset stack
		pop esi
		pop edx
		pop ecx
		pop eax

		dec esi
		cmp esi, 0
		jge buildFor

	pop esi
	pop edi
	pop ebx
	mov esp, ebp
	pop ebp
	ret

_start:
	mov eax, 0

initArray:
	mov ebx, 0x30
	add ebx, eax
	mov dword[intArray + eax], ebx
	inc eax
	cmp eax, 20
	jl initArray

newline:
	mov dword[intArray + eax-1], 0xa
print:
	push eax
	mov eax, 4
	mov ebx, 1
	mov ecx, intArray
	mov edx, 20
	int 0x80
	pop eax
end:
	mov eax, 1
	xor ebx, ebx
	int 0x80


