################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"C:/Users/jwhong/Desktop/M51CN128RD SW/Sources/APPLICATIONS/DHCP Client/dhcp_app.c" \

C_SRCS += \
C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/APPLICATIONS/DHCP\ Client/dhcp_app.c \

OBJS += \
./Sources/Applications/DHCP\ Client/dhcp_app_c.obj \

OBJS_QUOTED += \
"./Sources/Applications/DHCP Client/dhcp_app_c.obj" \

C_DEPS += \
./Sources/Applications/DHCP\ Client/dhcp_app_c.d \

OBJS_OS_FORMAT += \
./Sources/Applications/DHCP\ Client/dhcp_app_c.obj \

C_DEPS_QUOTED += \
"./Sources/Applications/DHCP Client/dhcp_app_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/Applications/DHCP\ Client/dhcp_app_c.obj: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/APPLICATIONS/DHCP\ Client/dhcp_app.c
	@echo 'Building file: $<'
	@echo 'Executing target #97 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Applications/DHCP Client/dhcp_app.args" -o "Sources/Applications/DHCP Client/dhcp_app_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Applications/DHCP\ Client/dhcp_app_c.d: C:/Users/jwhong/Desktop/M51CN128RD\ SW/Sources/APPLICATIONS/DHCP\ Client/dhcp_app.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


