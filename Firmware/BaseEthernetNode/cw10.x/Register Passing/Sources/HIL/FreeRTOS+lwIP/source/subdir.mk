################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/HIL/lwIP+FreeRTOS/source/sys_arch.c" \

C_SRCS += \
C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/HIL/lwIP+FreeRTOS/source/sys_arch.c \

OBJS += \
./Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.obj \

OBJS_QUOTED += \
"./Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.obj" \

C_DEPS += \
./Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.d \

OBJS_OS_FORMAT += \
./Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.obj \

C_DEPS_QUOTED += \
"./Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.obj: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/HIL/lwIP+FreeRTOS/source/sys_arch.c
	@echo 'Building file: $<'
	@echo 'Executing target #77 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/HIL/FreeRTOS+lwIP/source/sys_arch.args" -o "Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/HIL/FreeRTOS+lwIP/source/sys_arch_c.d: C:/Users/jwhong/Documents/Project-Hexapod/Firmware/BaseEthernetNode/Sources/HIL/lwIP+FreeRTOS/source/sys_arch.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


