################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Desktop/M51CN128RD SW/Sources/HAL/mcf51cn128/drivers/PHY/mii.c" \

C_SRCS += \
C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/PHY/mii.c \

OBJS += \
./Sources/HAL/PHY/mii_c.obj \

OBJS_QUOTED += \
"./Sources/HAL/PHY/mii_c.obj" \

C_DEPS += \
./Sources/HAL/PHY/mii_c.d \

OBJS_OS_FORMAT += \
./Sources/HAL/PHY/mii_c.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/HAL/PHY/mii_c.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/PHY/mii.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/HAL/PHY/mii.args" -o "Sources/HAL/PHY/mii_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/HAL/PHY/mii_c.d: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/HAL/mcf51cn128/drivers/PHY/mii.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


