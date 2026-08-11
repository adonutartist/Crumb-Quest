# Crumb Quest

A small cozy idle AFK 2D pixel art insect colony management game.
You start small, gather food, grow your colony, recruit new insects, and survive the waves of enemies and maybe even defeat the boss :3

## Gameplay

* Start with one ant and grow into a massive insect colony in seconds.
* Food falls from the sky.
* Ants search for food and eat it to give u crumbs.
* Food has its own health/eating system and can be consumed by ants over time.
* The game switches between day and night.
* Fireflies appear during the night.
* The colony can recruit different insects as it grows.
* Each insect can be evolved into something better.
* Progression is built around evolving insects and fighting waves of enemies.

## Insects

The game currently includes:

* Ants
* Red ants
* Beetles
* Ladybugs

The insect system is built around separate creature scenes, animations, movement and targeting.

## Food System

Food is spawned dynamically throughout the world.

The food spawner:

* Uses a maximum food limit.
* Randomizes food positions.
* Avoids placing food too close together.
* Keeps food within the playable area.
* Uses an Area2D for food interaction.
* Can be targeted by ants.
* Has a visible health/eating bar.
* The bar decreases as ants eat the food.
* Each food also gets a shadow while falling which is synced with their distance from ground which means bigger shadow as it gets close to the ground.

Ants search for nearby food, move toward it, stop when close enough, and continuously damage/eat it.

## Cosmetics

* The game has a day/night system that is js cosmetic for now.
* You can see fireflies during the night but yeh js cosmetic.
* You can see shadows of clouds slowly passing by during the day.
* you can spot flying leaves from wind.
* the grass flows with the wind and can be interacted by insects.
* Lots of cool sfx and gud music :3 

## Recruiting/Buying

The game includes recruit cards for obtaining new insects.

Individual insects can also be evolved to gain progression.

## Leaderboard

Crumb Quest has an online leaderboard powered by Supabase.

The current leaderboard tracks the amount of Crumbs collected

Players can:

1. Open the leaderboard.
2. Enter a username.
3. Submit their current crumb score.
4. Have their score stored online.
5. See the top players sorted by crumbs.

If the same username submits another score, the existing player's score is updated instead of creating another entry.

The leaderboard also remembers the player's username locally, so they don't have to type it every time.

### Username validation

Usernames are limited to:

* 2–16 characters
* Letters
* Numbers
* Spaces
* `_`
* `-`

Invalid usernames are rejected before being submitted.

## Chat

The leaderboard panel also contains an online chat.

Players can:

* Enter a message.
* Send it using their saved username.
* See messages from other players.
* Automatically receive new messages every second.
* Scroll through older messages.
* Automatically scroll to the newest message when they send one.

The chat displays the usernamewith a different color from the message so usernames look distinct.

The chat also has a 100 character message limit.

### Chat safety

The chat uses server-side Supabase constraints as well as client side validation.

Messages containing HTML style tags are rejected by the database.

The username is also validated by the database rather than relying only on the game client.

Chat messages are stored with:

* Username
* Message
* Timestamp

## UI

The main interface includes:

* Insect/recruit controls
* Crumb counter
* Leaderboard
* Username input
* Score submission
* Online player list
* Chat
* Message input
* Send button
* Close button
* Audio toggle

The leaderboard and chat share the same panel.

## Visual Style

Crumb Quest uses a simple goofy pixel art style.

The insect sprites were created specifically for the game, with small animations and chunky shapes intended to keep the game feeling playful rather than overly serious.

## Tools used

* Godot 4.7.1
* GDScript
* Aseprite
* Supabase
* GitHub
* Vercel

## Try it out yourself

[![Play Crumb Quest](https://github.com/user-attachments/assets/a4952901-acfb-4d7f-9fe8-58ab3b83a827)](https://crumb-quest.vercel.app/)

Clicking the button will take you to the game page :]

## Screenshots

<table>
<tr>
<td><img src="https://github.com/user-attachments/assets/548c1592-f84c-4cab-9add-7a67559a9532" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/d141fda9-328b-408a-a8e7-5f27fdf40932" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/6a1785ee-892a-4df0-b6f2-2c75eb97d04d" width="500" alt="Crumb Quest screenshot"></td>
</tr>
<tr>
<td><img src="https://github.com/user-attachments/assets/0c0241f7-8a6d-41fa-94b8-ae1b48d4d90e" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/092796ea-3ea0-4d17-9064-66229fd025d6" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/aa3551a5-fee3-4843-8fee-9abcfceecdd0" width="500" alt="Crumb Quest screenshot"></td>
</tr>
<tr>
<td><img src="https://github.com/user-attachments/assets/b020c532-aae2-40b8-9b7e-92b935b5159a" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/c0fc0432-ffc3-4077-9411-aeadada4d164" width="500" alt="Crumb Quest screenshot"></td>
<td><img src="https://github.com/user-attachments/assets/ced2405d-8fcb-4878-b8ae-f88ef6d59b27" width="500" alt="Crumb Quest screenshot"></td>
</tr>
</table>

---

<p align="center">
  <img src="https://github.com/user-attachments/assets/92ab1a71-3318-4a6e-93ae-4182aca97139" width="150" alt="Nemo">
</p>
