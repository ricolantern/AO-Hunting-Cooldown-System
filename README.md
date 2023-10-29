# Hunting Cooldown System
Initiative that aims to suggest a replacement for the currently implemented hunting cooldown system present in Arcane Odyssey.

Written using a Rojo project structure for easier sharing.
If you're vetex, all you really have to do is copy-paste the scripts' contents into your own and you'll be able to start making use of it.
(Just be sure to also create the remotes in ReplicatedStorage)

**Table of contents**
1. [In a nutshell](#in-a-nutshell)
1. [Previewing in studio](#previewing-in-studio)
1. [Save data adjustments](#save-data-adjustments)

## In a nutshell
- Allows for cooldowns to be applied per-player basis, allowing for the game to start encouraging hunting in variety in a controlled manner.
- Makes it impossible for cooldown removals to be exploitable through the client, since the server handles it.

## Previewing in studio
1. Go to https://github.com/ricolantern/AO-Hunting-Cooldown-System/releases
2. Select the latest release.
3. Under "Assets" download the .rbxl file.
4. Open the downloaded file.
5. Once loaded into studio, in the top bar navigate to "Test". Here, you should see a section "Clients and Servers".
6. Configure this section as follows:
    1. Set the top dropdown to "Local Server".
    2. Set the bottom dropdown to "2".
7. Hit "Start". This will open up 3 windows:
    1. The server.
    2. A client for player 1.
    3. A client for player 2.
8. Observe the output.
    1. (If you don't see the output window, head to "View" and select "Output")

Try disconnecting one of the clients (closing the window) while it still has cooldowns on the server!

## Save data adjustments
Below lists the required save data changes, providing an old->new example.
### Old data structure
```
{ // Player save.
    ...,
    LastHuntAt: 1697563692,
    ...
}
```
### New data structure
```
{ // Player save.
    ...,
    HuntCooldowns: {
        // -v----------------- Target user id.
        66545433: 1697563692,
        4745343: 1697563692,
        34546223: 1697563692,
        223534456: 1697563692
        // ------------^------ Timestamp in seconds since unix epoch.
    },
    ...
}
```
