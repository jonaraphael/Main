################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Desktop/M51CN128RD SW/Sources/HAL/mcf51cn128/drivers/MCG/clock.c" \

C_SRCS += \
C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/MCG/clock.c \

OBJS += \
./Sources/HAL/MCG/clock_c.obj \

OBJS_QUOTED += \
"./Sources/HAL/MCG/clock_c.obj" \

C_DEPS += \
./Sources/HAL/MCG/clock_c.d \

OBJS_OS_FORMAT += \
./Sources/HAL/MCG/clock_c.obj \

C_DEPS_QUOTED += \
"./Sources/HAL/MCG/clock_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/HAL/MCG/clock_c.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/MCG/clock.c
	@echo 'Building file: $<'
	@echo 'Executing target #81 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/HAL/MCG/clock.args" -o "Sources/HAL/MCG/clock_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/HAL/MCG/clock_c.d: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/MCG/clock.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


