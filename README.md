# clickerUI

A user interace with various automation features to aid in playing the game Clicker Heroes.

Requires a little setup at the start of each anscension but is usually capable of running any anscension from start to finish without any human intervention (including FANT).


* [Setup and Operation](#setup-and-operation)
* [Interval Features](#interval-features)
* [Special Features](#special-features)


## Setup and Operation

**Step One**

Clicker UI requires the Steam install of Clicker Heroes.
After Clicker Heroes is installed, Steam does not need to be running to launch it.
Download and install Steam if you don't have it already and download and install Clicker Heroes.

**Step Two**

Download and install the latest version of [AutoHotkey][]

**Step Three**

Download the clickerUI.ahk to a location of your choice and run it. It should automatically run Clicker Heroes from the following location. If this location is incorrect, modify it in the ahk file.

'C:\Program Files (x86)\Steam\steamapps\common\Clicker Heroes\Clicker Heroes.exe'


## Interval Features

The following features can be set to 'on' or 'off' and a specific time interval can be set e.g. run every 40 seconds, or every half hour. Time interval is set in seconds.

**Level All Heroes**

Scrolls through the entire hero list levelling up every hero. Starts at the bottom. Change the increment with 't'.
Essential for the entirety of FANT, and the start of most anscensions.

**Get All Upgrades**

Clicks the 'Buy Available Upgrades' button. Will scroll to reach the button as necessary.

**Skills**

Apply skills (select as many as required). Most useful once reaching the point in the game where skill durations are greater than cooldown durations.

**Collect Gilds**

Collects hero gilds.

**Assign Gilds**

Assigns gilds to a specific hero. Can be assigned to a long time interval (such as 2 hours) to suit when a hero becomes available.

**Custom 1 and Custom 2**

Manually setup autoclicker. Coordinates can be set. Each one has two locations that are clicked. Useful in a variety of situations, particularly before Autoclickers are purchased. A suggested use could be near the end of an anscension, when only one hero needs to be levelled. Using this instead of 'Level All Heroes' is more efficient, and allows more use of 'Click Monsters'.


## Special Features

**Click Monsters**

Clicks the monster. The time interval is set in milliseconds e.g. if set to 25, it will run 40 times a second. Clicker Heroes will rarely register this quantity of clicks. This feature is temporarily paused whenever one of the interval features is running to avoid issues.

**Boss Push**

Detects when progression mode has changed to 'Farm' (with the red line). After 30 seonds of waiting it will toggle back to 'Progression' and move to the next zone.

After trying this twice, the third time it will activate one of the following sets of skills:

1) If Pluto is set to 'Yes' and Lucky Strikes and Golden Clicks are available: `Metal Detector`  `Lucky Strikes`  `Golden Clicks`

2) If Pluto is set to 'No' and Lucky Strikes and Super Clicks are available: `Lucky Strikes`  `Super Clicks`

3) Otherwise: `Clickstorm`  `Powersurge`  `Metal Detector`  `Lucky Strikes`  `Golden Clicks`  `Super Clicks`

It will then run `Energize` and `Reload` if they are both available.

<kbd>F8</kbd> can be used to 'skip' the wait and push immediately.
  
**Force Click**

With features running (particulary Click Monsters) Clicker Heroes struggles to register manual clicks. <kbd>F5</kbd> can be used to force through a click at the current location. Useful for clicking fishes without stopping the program.



  