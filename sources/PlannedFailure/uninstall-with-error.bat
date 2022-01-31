:: ====================================================================================================
:: Step 3c: Use the WIXFAILWHENDEFERRED argument
:: ====================================================================================================
:: 
:: Set the WIXFAILWHENDEFERRED argument to value 1 in order to instruct the WixFailWhenDeferred custom
:: action to fail and provoke a rollback of the whole uninstallation process.
:: 
:: Note: This command doesn't seem to be working properly. On my machine, this command, even if it 
::       should have failed, it successfully uninstalled the product.
:: 
:: END

msiexec /x PlannedFailure.msi /l*vx uninstall-with-error.log WIXFAILWHENDEFERRED=1