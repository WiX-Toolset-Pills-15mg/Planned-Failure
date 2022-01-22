# Planned Failure

## Overview

Sometimes, there is a need to provoke a controlled failure in the installation process. For example, when we want to test the rollback custom actions, it would be useful to raise an error at the very end of the installation process.

One way to solve this problem is to create a deferred custom action that returns a failure as a response. Well, it would also be useful to have a public property that controls when the custom action should fail and when it should succeed.

The FireGiant team already created this custom action that we can use. It is called `WixFailWhenDeferred`:

- https://wixtoolset.org/documentation/manual/v3/customactions/wixfailwhendeferred.html

As the article describes, there are three steps. Let's try them.

## Implementation

### Step 0 - Create a simple installer

Create a simple installer that deploys a single dummy file. See the "My First Installer" tutorial for details on how to do this:

- https://github.com/WiX-Toolset-Pills-15mg/My-First-Installer

### Step 1 - Add a reference to the `WixUtilExtension` library

Right click on the project in Solution Explorer -> Add -> Reference -> Browse -> "c:\Program Files (x86)\WiX Toolset v3.11\bin\WixUtilExtension.dll" -> OK

![Add reference to the Util Extension library](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122191948831.png)

Check that the reference is present in the project:

![The reference to the Util Extension library](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122192437976.png)

### Step 2 - Reference the `WixFailWhenDeferred` custom action

Add, in the `<Product>` tag, a reference to the `WixFailWhenDeferred` custom action.

```xml
<Product
    Id="*"
    Name="Planned Failure"
    Language="1033"
    Version="1.0.0.0"
    Manufacturer="Dust in the Wind"
    UpgradeCode="01078873-6969-423a-badb-850df2e4da5a">

    ...

    <CustomActionRef Id="WixFailWhenDeferred" />

</Product>
```

The `WixFailWhenDeferred` custom action is added at the end of the `InstallExecuteSequence`, before the `InstallFinalize` custom action.

WiX Toolset will automatically include also the `WIXFAILWHENDEFERRED` public property:

- if `WIXFAILWHENDEFERRED` property = 1, then the `WixFailWhenDeferred` custom action raise a failure.
- if `WIXFAILWHENDEFERRED` property = anything else, then the `WixFailWhenDeferred` custom action will do nothing.

### Step 3 - Run the installer

In order to test the functionality, add the following .bat files.

#### Install with error

First, let's generate a failure during the installation process.

```
msiexec /i PlannedFailure.msi /l*vx install-with-error.log WIXFAILWHENDEFERRED=1
```

The installation will roll-back and nothing will be actually installed.

In the `install-with-error.log` file, close to the end there we can see that the installation failed:

![image-20220122200013180](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122200013180.png)

and, in the execution of the `InstallFinalize` custom action, where the deferred actions are actually executed, we can see that the `WixFailWhenDeferred` custom action actually returned an error.

![image-20220122195849737](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122195849737.png)

#### Install with success

Now, let's actually install the product so that we can test the repair and the uninstall scenarios, too.

```xml
msiexec /i PlannedFailure.msi /l*vx install.log
```

#### Repair with error

The usual repair command may look like this:

```
msiexec /fvecmus PlannedFailure.msi /l*vx repair.log
```

But, as we did previously with the install command, let's add the `WIXFAILWHENDEFERRED=1` argument to it:

```
msiexec /fvecmus PlannedFailure.msi /l*vx repair-with-error.log WIXFAILWHENDEFERRED=1
```

and run this last command.

It will fail in a similar way as the install command. A similar failure message can be found near the end of the log file:

![image-20220122200723546](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122200723546.png)

and the `WixFailWhenDeferred` custom action failed message can be found during the execution of the `InstallFinalize` custom action:

![image-20220122201006455](C:\Users\alexandru.iuga\AppData\Roaming\Typora\typora-user-images\image-20220122201006455.png)

#### Uninstall

In the end, let's make an uninstall with failure:

```
msiexec /x PlannedFailure.msi /l*vx uninstall-with-error.log WIXFAILWHENDEFERRED=1
```

Surprisingly for me, this command, succeeded, even if, the documentation say it should fail. I am not sure if this is a bug or I did something wrong here. If you find out what is the problem or if this problem is not reproducible on your machine, please send me a message. [Add an issue in GitHub.](https://github.com/WiX-Toolset-Pills-15mg/My-First-Installer/issues/new?assignees=&labels=&template=feature_request.md&title=)

And here there is the uninstall command that successfully uninstalls the product.

```
msiexec /x PlannedFailure.msi /l*vx uninstall.log
```

