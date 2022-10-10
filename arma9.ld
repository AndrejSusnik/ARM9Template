MEMORY {
	ram0 (rwx)  : ORIGIN = 0x00000000, LENGTH = 0x00001000 
	ram1 (rwx) : ORIGIN = 0x00300000, LENGTH = 0x00001000 
}

SECTIONS {
	.text ORIGIN(ram0):
	{
		__text_start__ = .;
		*(.text)
		*(.text.*)
		. = ALIGN(4);
	}

	.data ADDR(.text) + SIZEOF(.text):
	{
		__data_start__ = .;
		*(.data*)      /* Read-write initialized data */
		. = ALIGN(4);
		__data_end__ = .;
	}

	.bss ADDR (.data) + SIZEOF (.data):
	{
		__bss_start__ = .;
		. = ALIGN(4);
		*(.bss*)       /* Read-write zero initialized data */
		*(COMMON)
		. = ALIGN(4);
		__bss_end__ = .;
	}

}

__StackTop = ORIGIN(ram0) + LENGTH(ram0);
__text_size = SIZEOF (.text);
__data_size = SIZEOF (.data);
__bss_size  = SIZEOF (.bss);
