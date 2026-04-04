# D2R single/multi client launcher, lobby controller, reduce mod      
https://github.com/Chobotz/D2R-multiclient-tools  
for 3.1.92198

Chobotz is back 2026 ROTW

# Contact - Discord  
chobot#4192  

![Single launcher and Multi launcher](https://i.imgur.com/dzgQOcN.png)
![Multi](https://i.imgur.com/uhK0HJa.png).
![D2R Lobby Controller](https://i.imgur.com/zDx7dYF.png).  

# What is it good for?
  * Multiple D2R clients - 1 PC   
  * Dclone hunting farm
  * PRO trading  
  * Eliminate starting D2R via slow lousy Bnet launcher  
  * All tools are less than 200 lines of script transparent code, you can see what it does  
  * Functionality is split to smaller tools which focus on that specific task, everyone can have different needs  

# 2 options:
1. Singleclient launcher - you have a desktop shortcut and control over each single client (client crashes, you play with only 3 accounts out of 8, across different regions etc)
2. Multiclient launcher - you have one desktop shortcut/script to spawn all clients, you put accounts credentials into accounts.txt and the multiclient launcher will spawn a client for each of them in one specified region

# Important:  
* D2R client command line start does not support MFA  
```diff
- Direct client launch works only when Bnet authenticator (MFA) is disabled.
- https://account.battle.net/security#authenticator
```

# Singleclient launcher setup (Singleclient folder)
1. Copy D2R_launcher_1.ps1 into your D2R game folder
2. Open D2R_launcher_1.ps1 in text editor and modify the initial section bnet email, pswd, default region
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_1.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder (what you need to change is in bold)  

  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "**F:\Diablo II Resurrected\D2R_launcher_1.ps1**"
  * Start in: "**F:\Diablo II Resurrected**"
  * You can change the shortcut icon
5. Repeat the same for other clients, just change the name of the powershell script and your shortcut
  * D2R_launcher_1.ps1 -> D2R_launcher_2.ps1,D2R_launcher_3.ps1 etc
  * D2R_launcher_1.lnk -> D2R_launcher_2.lnk,D2R_launcher_3.lnk etc
6. Start a client of your choice by using desktop shortcuts, select region  


# Multiclient launcher setup (Multiclient folder)
1. Copy D2R_launcher_all.ps1 and accounts.txt into your D2R game folder
2. Open accounts.txt in text editor and put accounts you want to start in the following format, one account per line (password cannot contain ";" character): bnet_account@gmail.com;password123
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_all.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder (what you need to change is in bold)  

  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "**F:\Diablo II Resurrected\D2R_launcher_all.ps1**"  
  * Start in: "**F:\Diablo II Resurrected**"  
  * You can change the shortcut icon  

5. Start multiple clients by using D2R_launcher_all.lnk on your desktop, select region  


# Additional suggested mods:
Introskip (we have seen it already) - https://www.nexusmods.com/diablo2resurrected/mods/194  
Tinymod - reduce vram/ram system consumption, it's broken but works - https://github.com/D2R-Gimli/TinyMod

  * If you wish to run any mod with the launcher, adjust the D2R arguments in launchers   

# Reduce mod (Reduce folder in repo)  
  * Nullified game files to reduce ram/vram per client consumption
  * Works with ROTW 3.1.92198 version  
  * Extract reduce.zip into D2R install folder X:\Diablo 2 Resurrected\mods\Reduce  
  * Adjust D2R.exe cmd arguments in other tools (D2R.exe -mod reduce)  

# D2R Game Lobby controller (LobbyController folder in repo)  
  * What it does? After you start all clients and enter game lobby (join tab). Now this tool starts to operate. Join game (goes window by window, in a predefined windows list), populate game name and password, joins game. Second functionality is to exit game, increase game name game150 -> game151 and join. Last button, exits game in all pre-defined windows.  
  * Client window size is considered 1280*720 (if it differs in your setup, you may need to adjust the script).  
  * You need to have D2R windows named D2R1, D2R2 or configure it in the script. The tool iterates window by window title, configured in the script D2R_lobby_controller.au3.  
  * Change the game name pattern and password before use, in the script :).  

![D2R Lobby Controller](https://i.imgur.com/zDx7dYF.png).  

Join current game in all windows, one click:  

https://github.com/user-attachments/assets/6385f632-1029-4feb-931a-738ae8986706


# You are respecting Blizz EULA, usage of 3rd party tools is at your own risk  

# Common/known issues: 
  * If you run into repeating captcha verification loops, purge content of C:\Users\User\AppData\Local\Battle.net\Cache\  
  * If you generate too many logins or you fail to log in, you may get a temporary account lockout, make sure your email and password is correct, and that you can log in that particular account via normal way (bnet launcher) - there could be captcha to be solved etc, you can wait 1 hour and try again to start clients directly  
  * Direct client launch gets stuck on battle net login -> Game client is outdated - update your client via Battle net launcher. Or you have bnet authenticator enabled.  
  * If you get a message "handle cannot be closed", get the latest Handle tool from Microsoft site mentioned above  

# Request and ideas, submit an issue  
