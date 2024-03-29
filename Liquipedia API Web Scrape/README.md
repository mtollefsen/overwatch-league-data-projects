# Liquipedia API Web Scrape
This is the Python code that gets information on the professional players that are in my [Overwatch League database](https://github.com/mtollefsen/overwatch-league-data-projects/tree/main/Data%20Cleanup) by sending requests to Liquipedia.net's API and parsing the HTML it gets back. The code gets the following data on each player: the player's real name, Romanized name (if applicable), birthday, and country. Here's an example of the information the code fetches for the first 10 players in our player list:

![Capture](https://user-images.githubusercontent.com/97869630/156715175-17c1670f-1668-4c88-b9f0-504af38a3278.PNG)


## Flow Chart (Simplified)

![player_info Flowchart](https://user-images.githubusercontent.com/97869630/156310982-ac286d7e-c443-4cd6-9d97-16446aa1357c.png) <br>
 
This flow chart maps the part of the code that makes API requests. A GET request is sent for every player's name, looking for a page that matches their name. Because pages are case sensitive the code will try multiple formats of a player's name until a page is found or they've run out of formats to try. For example, if the code were trying to find the Liquipedia.net page for a player that goes by "WiNner BIRD", it would try the following pages in this order:
 
   |    Format    |     Page    |
   |--------------|-------------|
   | Original     | WiNner BIRD |
   | Capital case | Winner bird |
   | Title case   | Winner Bird |
   | Upper case   | WINNER BIRD |
   | Lower case   | winner bird |

Note: Per [Liquipedia's API Terms of Use](https://liquipedia.net/api-terms-of-use) all requests are spaced out by 30 seconds, which is reflected in the flow chart.

## Performance

At the time of writing this (March 1, 2022) of the 373 players it searched for, the code found and successfully scraped the pages of 364 players, a ~98% success rate.

The code is not always able to find a player's Liquipedia page and in such cases it flags that player's name with the string "could not find page" and then starts searching for the next player on it's list. Frequently the code will reach a page that has a redirect link to the page of the player it is searching for. The code is smart enough to follow this link and get the information from there, however, some pages have multiple redirect links. This can happen when more than one player shares the same name, see the page for [Snow](https://liquipedia.net/overwatch/Snow) as an example. When the code encounters such a page it flags the player's name as "ambiguous" and moves on to the next player on it's list.

## Source & Copyright
Liquipedia content is licensed under CC-BY-SA 3.0, which requires that you attribute Liquipedia as the source of your data. See [Liquipedia:Copyrights](https://liquipedia.net/commons/Liquipedia:Copyrights) for more information.
