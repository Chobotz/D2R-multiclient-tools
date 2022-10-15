# D2R single and multi client launcher  
https://github.com/Chobotz/D2R-multiclient-tools  
https://forums.d2jsp.org/user.php?i=1208377  

![Single launcher and Multie launcher](https://i.imgur.com/dzgQOcN.png)

# What is it good for?
  * You play D2R on multiple accounts at once, one PC  
  * Dclone hunting farm
  * You need to quickly spawn multiple clients in specific regions
  * You want to eliminate clicking through slow and lousy Bnet launcher
  * Enough people on Internet clicked on something and got robbed, this solution is using only a powershell script which is less than 100 lines long and it's 100% clear what is it doing compared to compiled .exe D2R managers, the only binary used you download from the official Microsoft site
  * Many D2R managers implement complexities which then cause problems, this is simple, fast and straightforward solution

# 3 options:
1. Singleclient launcher - you have a desktop shortcut and control over each single client (client crashes, you play with only 3 accounts out of 8, across different regions etc)
2. Multiclient launcher - you have one desktop shortcut to spawn all clients, you put accounts credentials into accounts.txt and the multiclient launcher will spawn a client for each of them in one specified region
3. You combine both approaches together, having a desktop singleclient shortcut for each account (1.) for normal play and using the multiclient desktop shortcut (2.) to quickly spawn all clients to do dclone farm etc

# Important: 
```diff
- Direct client launch works only when Bnet authenticator (MFA) is disabled.
- https://account.battle.net/security#authenticator
```

# Singleclient launcher setup (Singleclient folder)
1. Copy D2R_launcher_1.ps1 into your D2R game folder
2. Open D2R_launcher_1.ps1 in text editor and modify the initial section bnet email, pswd, default region
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_1.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder
  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "**F:\Diablo II Resurrected\D2R_launcher_1.ps1**"
  * Start in: "**F:\Diablo II Resurrected**"
  * You can change the shortcut icon
5. Repeat the same for other clients, just change the name of the powershell script and your shortcut
  * D2R_launcher_1.ps1 -> D2R_launcher_2.ps1,D2R_launcher_3.ps1 etc
  * D2R_launcher_1.lnk -> D2R_launcher_2.lnk,D2R_launcher_3.lnk etc
6. Start a client of your choice by using the desktop shortcut you created and follow the instructions, select launch mode and region, then you can click on shortcut for other client etc


# Multiclient launcher setup (Multiclient folder)
1. Copy D2R_launcher_all.ps1 and accounts.txt into your D2R game folder
2. Open accounts.txt in text editor and put accounts you want to start in the following format, one account per line, password cannot contain ";" character: bnet_account@gmail.com;password123
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_all.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder

  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "**F:\Diablo II Resurrected\D2R_launcher_all.ps1**"  
  * Start in: "**F:\Diablo II Resurrected**"  
  * You can change the shortcut icon  

5. Start multiple clients by using D2R_launcher_all.lnk on your desktop, select region
6. Select first client, click intro and let the Bnet connection finish till you get into character selection screen, then repeat with second etc, if you click skip intro in multiple clients at once, it will inherit session and cause issues, two clients will try to use the same account, kick each other out etc


You can contact me on JSP - Chobot / https://forums.d2jsp.org/user.php?i=1208377 and send me a big fat FG tip.

# Additional suggested mods:
Introskip (we have seen it already) - https://www.nexusmods.com/diablo2resurrected/mods/194  
Blockhd (significant memory per client reduction) - https://www.nexusmods.com/diablo2resurrected/mods/238  

  * If you wish to run any mod with the launcher, you can replace this line:  
    & "$PSScriptRoot\D2R.exe" -username $bnet_email -password $bnet_password -address $region'.actual.battle.net'  
    ->  
    & "$PSScriptRoot\D2R.exe" -username $bnet_email -password $bnet_password -address $region'.actual.battle.net' **-mod introskip**  

# You are respecting EULA, usage of 3rd party tools is at your own risk

# Common/known issues: 
  * If you run into repeating captcha verification loops, purge content of C:\Users\User\AppData\Local\Battle.net\Cache\  
  * If you generate too many logins or you fail to log in, you may get a temporary account lockout, make sure your email and password is correct, and that you can log in that particular account via normal way (bnet launcher) - there could be captcha to be solved etc, you can wait 1 hour and try again to start clients directly  
  * Direct client launch gets stuck on battle net login -> Game client is outdated - update your client via Battle net launcher. Or you have bnet authenticator enabled.
  * Launchers run as administrator (which is required to close process handles), therefore the D2R.exe processes are also runing with elevated privileges which is not needed
  * ManageWindows can be embedded into Multilauncher - currently it's separated for simplicity, also it requires the user to adjust the position and window size etc
