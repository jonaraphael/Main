################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Desktop/M51CN128RD SW/Sources/Services/FreeRTOS/Sources/portable/MemMang/heap_3.c" \

C_SRCS += \
C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/MemMang/heap_3.c \

OBJS += \
./Sources/Services/FreeRTOS/Source/Memory/heap_3_c.obj \

OBJS_QUOTED += \
"./Sources/Services/FreeRTOS/Source/Memory/heap_3_c.obj" \

C_DEPS += \
./Sources/Services/FreeRTOS/Source/Memory/heap_3_c.d \

OBJS_OS_FORMAT += \
./Sources/Services/FreeRTOS/Source/Memory/heap_3_c.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/Services/FreeRTOS/Source/Memory/heap_3_c.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/MemMang/heap_3.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Services/FreeRTOS/Source/Memory/heap_3.args" -o "Sources/Services/FreeRTOS/Source/Memory/heap_3_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Services/FreeRTOS/Source/Memory/heap_3_c.d: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/MemMang/heap_3.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


