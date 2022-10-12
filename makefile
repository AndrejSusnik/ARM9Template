ifdef OS
TARGET = .\out\main
SRCS = .\src\main.s
else
TARGET = ./out/main
SRCS = ./src/main.s ./src/crt0.s
endif

OBJS =  $(addsuffix .o, $(basename $(SRCS)))
INCLUDES = -I.

LINKER_SCRIPT = arma9.ld
CFLAGS += -mcpu=cortex-a9 # processor setup
CFLAGS += -O0 # optimization is off
CFLAGS += -g3 # generate debug info
CFLAGS += -gdwarf
CFLAGS += -fno-common
CFLAGS += -Wall # turn on warnings
CFLAGS += -pedantic # more warnings
CFLAGS += -Wsign-compare
CFLAGS += -Wcast-align
CFLAGS += -Wconversion # neg int const implicitly converted to uint
CFLAGS += -fsingle-precision-constant
CFLAGS += -fomit-frame-pointer # do not use fp if not needed
CFLAGS += -ffunction-sections -fdata-sections

# Chooses the relevant FPU option
CFLAGS += -mfloat-abi=soft # No FP
#CFLAGS += -mfloat-abi=softfp -mfpu=fpv4-sp-d16 # Soft FP
#CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 # Hard FP

#LDFLAGS += -mfloat-abi=softfp -mfpu=fpv4-sp-d16 # Soft FP
#LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 # Hard FP

LDFLAGS += -march=armv7e-m # processor setup
LDFLAGS += -nostartfiles # no start files are used
LDFLAGS += --specs=nosys.specs
LDFLAGS += -Wl,-Map=$(TARGET).map #generate map file
LDFLAGS += -T$(LINKER_SCRIPT)

CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJDUMP = $(CROSS_COMPILE)objdump
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE = $(CROSS_COMPILE)size
DBG = $(CROSS_COMPILE)gdb

ifdef OS
	RM_CMD = del /F
else
	RM_CMD = rm -f
endif

all: clean $(SRCS) build size
	@echo $(OBJS)
	@echo "Successfully finished..."

build: $(TARGET).elf $(TARGET).hex $(TARGET).bin $(TARGET).lst

$(TARGET).elf: $(OBJS)
	@$(CC) $(LDFLAGS) ./out/main.o ./out/crt0.o -o $@

%.o: %.s
	@echo "Building" $<
	@$(CC) $(CFLAGS) -c $< -o out/$(notdir $@)

%.hex: %.elf
	@$(OBJCOPY) -O ihex $< $@

%.bin: %.elf
	@$(OBJCOPY) -O binary $< $@

%.lst: %.elf
	@$(OBJDUMP) -x -S $(TARGET).elf > $@

size: $(TARGET).elf
	@$(SIZE) $(TARGET).elf

disass: $(TARGET).elf
	@$(OBJDUMP) -d $(TARGET).elf

disass-all: $(TARGET).elf
	@$(OBJDUMP) -D $(TARGET).elf

debug:
	@$(DBG) --eval-command="target extended-remote :4242" \
	 $(TARGET).elf

ocd:
	@$(DBG) --eval-command="target extended-remote :3333" \
	--eval-command="monitor tpiu config internal swo.log uart off 16000000 1600000" \
	 $(TARGET).elf

burn:
	@st-flash write $(TARGET).bin 0x8000000

clean:
	@echo "Cleaning..."
	@$(RM_CMD) $(TARGET).elf
	@$(RM_CMD) $(TARGET).bin
	@$(RM_CMD) $(TARGET).map
	@$(RM_CMD) $(TARGET).hex
	@$(RM_CMD) $(TARGET).lst
	@$(RM_CMD) ./out/*.o

.PHONY: all build size disass disass-all debug ocd burn clean
