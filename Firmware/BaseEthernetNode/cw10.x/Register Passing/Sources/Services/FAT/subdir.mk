################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/Services/FAT/Fat.c" \

C_SRCS += \
C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/Services/FAT/Fat.c \

OBJS += \
./Sources/Services/FAT/Fat_c.obj \

OBJS_QUOTED += \
"./Sources/Services/FAT/Fat_c.obj" \

C_DEPS += \
./Sources/Services/FAT/Fat_c.d \

OBJS_OS_FORMAT += \
./Sources/Services/FAT/Fat_c.obj \

C_DEPS_QUOTED += \
"./Sources/Services/FAT/Fat_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/Services/FAT/Fat_c.obj: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/Services/FAT/Fat.c
	@echo 'Building file: $<'
	@echo 'Executing target #9 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Services/FAT/Fat.args" -o "Sources/Services/FAT/Fat_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Services/FAT/Fat_c.d: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/Services/FAT/Fat.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


