<p >
    <img src="https://img.shields.io/badge/LEGACYCORE-Creator%20%20ENT510-%23FF6F00" alt="Welcome Badge" />
</p>

# Legacy Core Installation

## Installing Legacy Core

To install Legacy Core and set up the VS Code snippets, you can follow these steps:

1. **Open Command Prompt or Visual Code Cmd**

   Open Command Prompt (cmd) in the directory where you want to clone the repository.

2. **Clone the Repository**

   Run the following command to clone the Legacy Core repository from GitHub:

```sh
git clone https://github.com/Legacy-Framework/LEGACYCORE.git
```

## Donwload Legacy Core and Move Snippets Visual Code to the Correctly Path

If you want to use the snippets for quick commands with all the parameters, just follow the procedure below:

![image](https://github.com/user-attachments/assets/2dee74a8-d143-44a9-9960-af7fa55c09e5)


- Run this Command

```sh
git clone https://github.com/Legacy-Framework/LEGACYCORE.git && move LEGACYCORE\LegacyCore.code-snippets C:\Users\user\AppData\Roaming\Code\User\snippets\
```
This command will clone the repository and immediately move the snippets file to the appropriate directory for VS Code.

Notes
Ensure that the paths match your operating system and user profile.
If you encounter any issues, verify that you have the correct permissions and that the paths are correct.

-

This project leverages the `ox_lib` resource to load and manage various modules dynamically. Below, you will find details on how to utilize the `LEGACYCORE` export to access core data and functions from both the client and server sides.

## Loading Core Data

To access the core data, you need to use the `GetCoreData` function provided by the `LEGACYCORE` export. This will load the available modules and their respective functions.

```lua
local Legacy = exports['LEGACYCORE']:GetCoreData()
```
