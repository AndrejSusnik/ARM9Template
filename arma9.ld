MEMORY {
	ram0 (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00001000 
}

SECTIONS {
	.text ORIGIN(ram0):
	{
		*(.startup)
		. = ALIGN(4);
		*(.text)
		*(.text.*)
		. = ALIGN(4);
	}
	
	.data ADDR (.text) + SIZEOF (.text):
	{
		*(.data)
		*(.data.*)
		. = ALIGN(4);
	}
}

__StackTop = ORIGIN(ram0) + LENGTH(ram0);
__text_size = SIZEOF (.text);
