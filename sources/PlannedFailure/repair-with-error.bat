:: ====================================================================================================
:: Step 3b: Use the WIXFAILWHENDEFERRED argument
:: ====================================================================================================
:: 
:: Set the WIXFAILWHENDEFERRED argument to value 1 in order to instruct the WixFailWhenDeferred custom
:: action to fail and provoke a rollback of the whole repairing process.
:: 
:: GOTO: uninstall-with-error.bat

msiexec /fvecmus PlannedFailure.msi /l*vx repair-with-error.log WIXFAILWHENDEFERRED=1