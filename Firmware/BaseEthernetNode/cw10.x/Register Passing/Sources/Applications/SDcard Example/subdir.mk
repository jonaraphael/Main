################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/APPLICATIONS/SDcard/sdcard_main.c" \

C_SRCS += \
C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/APPLICATIONS/SDcard/sdcard_main.c \

OBJS += \
./Sources/Applications/SDcard\ Example/sdcard_main_c.obj \

OBJS_QUOTED += \
"./Sources/Applications/SDcard Example/sdcard_main_c.obj" \

C_DEPS += \
./Sources/Applications/SDcard\ Example/sdcard_main_c.d \

OBJS_OS_FORMAT += \
./Sources/Applications/SDcard\ Example/sdcard_main_c.obj \

C_DEPS_QUOTED += \
"./Sources/Applications/SDcard Example/sdcard_main_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/Applications/SDcard\ Example/sdcard_main_c.obj: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/APPLICATIONS/SDcard/sdcard_main.c
	@echo 'Building file: $<'
	@echo 'Executing target #94 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Applications/SDcard Example/sdcard_main.args" -o "Sources/Applications/SDcard Example/sdcard_main_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Applications/SDcard\ Example/sdcard_main_c.d: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/APPLICATIONS/SDcard/sdcard_main.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


