################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Desktop/M51CN128RD SW/Sources/Services/FreeRTOS/Sources/portable/CodeWarrior/ColdFire_V1/port.c" \

C_SRCS += \
C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/CodeWarrior/ColdFire_V1/port.c \

OBJS += \
./Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.obj \
./Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm_S.obj \

OBJS_QUOTED += \
"./Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.obj" \
"./Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm_S.obj" \

C_DEPS += \
./Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.d \

OBJS_OS_FORMAT += \
./Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.obj \
./Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm_S.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/CodeWarrior/ColdFire_V1/port.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Services/FreeRTOS/Source/Arch-Dependent/port.args" -o "Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Services/FreeRTOS/Source/Arch-Dependent/port_c.d: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/CodeWarrior/ColdFire_V1/port.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm_S.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/Services/FreeRTOS/Sources/portable/CodeWarrior/ColdFire_V1/portasm.S
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Assembler'
	"$(CF_ToolsDirEnv)/mwasmmcf" @@"Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm.args" -o "Sources/Services/FreeRTOS/Source/Arch-Dependent/portasm_S.obj" "$<"
	@echo 'Finished building: $<'
	@echo ' '


