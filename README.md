# Hunting Cooldown System
Initiative that aims to suggest a replacement for the currently implemented hunting cooldown system present in Arcane Odyssey.

Written using a Rojo project structure for easier sharing.
If you're vetex, all you really have to do is copy-paste the scripts' contents into your own and you'll be able to start making use of it.
(Just be sure to also create the remotes in ReplicatedStorage)

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