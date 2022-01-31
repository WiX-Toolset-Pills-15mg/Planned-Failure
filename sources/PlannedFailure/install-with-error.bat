:: ====================================================================================================
:: Step 3a: Use the "WIXFAILWHENDEFERRED" argument
:: ====================================================================================================
:: 
:: Set the WIXFAILWHENDEFERRED argument to value 1 in order to instruct the WixFailWhenDeferred custom
:: action to fail and provoke a rollback of the whole installation process.
:: 
:: GOTO: repair-with-error.bat

msiexec /i PlannedFailure.msi /l*vx install-with-error.log WIXFAILWHENDEFERRED=1