<h1 style="color: #d9a94b;">LH SwingTimer</h1>

<p>Track main-hand melee and automatic ranged swing timing with small bars beneath the Blizzard player cast bar.</p>

<p>A small golden timer beneath Blizzard's player cast bar for the next weapon swing. It keeps timing information close to a frame you already use.</p>

<h2 style="color: #73c9c4;">What it tracks</h2>

<ul>
  <li>Main-hand melee swings, with off-hand attacks ignored.</li>
  <li>Automatic ranged attacks, including an orange cue during the final half-second.</li>
  <li>Separate switches for melee and ranged tracking.</li>
</ul>

<h2 style="color: #c78be6;">Settings</h2>

<p>Open <strong>Options → AddOns → LH Tweaks → LH SwingTimer</strong> to enable the timer and choose which attacks to track. Your choices are saved per character.</p>

<p><strong>Retail 12.1.5:</strong> The native <code>PLAYER_SWING</code> event and <code>C_SwingTimer</code> source used by this timer are specific to WoW Forever. The addon loads on Retail and keeps the timer hidden because it cannot obtain reliable swing start times there.</p>

<h2 style="color: #73c9c4;">More LH addons</h2>

<p>Choose only the pieces you want. Most companion addons require LH Tweaks; LH NameplateQuestInfo also works without it.</p>

<ul>
  <li><strong>LH AuraBars:</strong> Compact bars for buffs, debuffs and spell cooldowns.</li>
  <li><strong>LH CooldownPulse:</strong> Flashes an ability icon when its cooldown finishes.</li>
  <li><strong>LH ExpBar:</strong> A minimal experience bar with rested XP.</li>
  <li><strong>LH HideMe:</strong> Hides selected parts of the default UI, individually or all at once.</li>
  <li><strong>LH JobsDone:</strong> Plays the Warcraft peasant voice when a quest is ready to turn in.</li>
  <li><strong>LH MailBags:</strong> Opens your bags at the mailbox, with optional closing.</li>
  <li><strong>LH MP5:</strong> Shows an estimated five-second timer on the player mana bar.</li>
  <li><strong>LH NameplateQuestInfo:</strong> Adds quest markers and objective progress to nameplates.</li>
  <li><strong>LH NameplateThreatColors:</strong> Colors Blizzard nameplates by threat and role.</li>
  <li><strong>LH PetStats:</strong> Shows hunter pet loyalty beside the pet portrait.</li>
  <li><strong>LH Range:</strong> Shows melee range, configurable spell-range zones for every class, and a live non-Mana resource bar in melee range.</li>
  <li><strong>LH BuffReminders:</strong> Reminds you when selected class buffs are missing.</li>
  <li><strong>LH Skills:</strong> Shows profession ranks in a movable compact bar.</li>
  <li><strong>LH Stats:</strong> Shows money, free bag slots and remaining ammo below the minimap.</li>
  <li><strong>LH TinyDPS:</strong> Shows built-in damage meter data in a compact separate window.</li>
  <li><strong>LH Tweaks:</strong> Provides the shared settings hub plus chat, positioning, merchant and fishing tweaks.</li>
</ul>

<h2 style="color: #d9a94b;">Installation and feedback</h2>

<p><strong>LH Tweaks is required</strong> and must be installed alongside LH SwingTimer. I made this for my own combat UI, and I'm glad if it helps yours. If you notice a swing type or ability that changes the timing unexpectedly, please tell me in the CurseForge comments.</p>

<h2 style="color: #73c9c4;">Changelog</h2>

<p><strong>1.1.0 - Forever</strong></p>

<ul>
  <li>No gameplay changes in this Forever branch; the timer continues to use Forever's native swing events.</li>
</ul>

<hr>
<p><sup>*</sup> Implemented with the help of Codex and GPT-6-SOL. Some class or race combinations may still need work; please report anything you notice.</p>
