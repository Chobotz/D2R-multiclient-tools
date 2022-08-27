# D2R single and multi client launcher by Chobot  
https://github.com/Chobotz/D2R-multiclient-tools  
https://forums.d2jsp.org/user.php?i=1208377  

# What is it good for?
  * You play D2R on multiple accounts at once, one PC  
  * Dclone hunting farm
  * You need to quickly spawn multiple clients in specific regions
  * You want to eliminate clicking through slow and lousy Bnet launcher
  * Enough people on Internet clicked on something and got robbed, this solution is using only a powershell script which is less than 100 lines long and it's 100% clear what is it going compared to compiled .exe D2R managers, the only binary used you download from the official Microsoft site
  * Many D2R managers implement complexities which then cause problems, this is simple, fast and straightforward solution

# 2 options:
1. Singleclient launcher - you have control over each single client (client crashes, you play with only 3 accounts out of 8, across different regions etc)
2. Multiclient launcher - you put accounts credentials into accounts.txt and the launcher will spawn a client for each of them in one specified region

# Important: Direct client launch works only when Bnet authenticator (MFA) is not enabled.

# Singleclient setup (Singleclient folder)
1. Copy D2R_launcher_1.ps1 into your D2R game folder
2. Open D2R_launcher_1.ps1 in text editor and modify the initial section bnet email, pswd, default region
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_1.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder
  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "F:\Diablo II Resurrected\D2R_launcher_1.ps1"
  * Start in: "F:\Diablo II Resurrected"
  * You can change the shortcut icon
5. Repeat the same for other clients, just change the name of the powershell script and your shortcut
  * D2R_launcher_1.ps1 -> D2R_launcher_2.ps1,D2R_launcher_3.ps1 etc
  * D2R_launcher_1.lnk -> D2R_launcher_2.lnk,D2R_launcher_3.lnk etc
6. Start a client of your choice by using the desktop shortcut you created and follow the instructions, select launch mode and region, then you can click on shortcut for other client etc


# Multiclient setup (Multiclient folder)
1. Copy D2R_launcher_all.ps1 and accounts.txt into your D2R game folder
2. Open accounts.txt in text editor and put accounts you want to start in the following format, one account per line, password cannot contain ";" character: bnet_account@gmail.com;password123
3. Download handle64.exe and place it in your D2R game folder too. Official Microsoft site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle
4. Copy D2R_launcher_all.lnk to your desktop, right click - Properties and change "Target" and "Start in" to your D2R folder

  * Target: C:\Windows\System32\cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "F:\Diablo II Resurrected\D2R_launcher_all.ps1"  
  * Start in: "F:\Diablo II Resurrected"  
  * You can change the shortcut icon  

5. Start multiple clients by using D2R_launcher_all.lnk on your desktop, select region
6. Select first client, click intro and let the Bnet connection finish till you get into character selection screen, then repeat with second etc, if you click skip intro in multiple clients at once, it will inherit session and cause issues, two clients will try to use the same account, kick each other out etc


You can contact me on JSP - Chobot / https://forums.d2jsp.org/user.php?i=1208377 and send me a big fat FG tip.

