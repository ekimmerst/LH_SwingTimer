# MiniSwingTimer

Minimaler Mainhand-Swingtimer fuer WoW Forever Beta (Interface 16001).

- Goldener Balken, 2 Bildschirmpixel hoch, ohne Text oder Rahmen.
- Fuellt sich nach einem Mainhand-Swing von links nach rechts und verschwindet am Ende.
- Verwendet das native Beta-Ereignis PLAYER_SWING, einschliesslich der vom Client gelieferten Swingdauer.
- Folgt immer der Blizzard-Spieler-Castbar, auch wenn Quartz aktiv ist. Bleibt auch bei ausgeblendeter Castbar sichtbar.
- Keine Bibliotheken, Einstellungen oder gespeicherten Variablen erforderlich.

Nach der Installation den Client neu starten und MiniSwingTimer in der Addonliste aktivieren. Falls Quartz ebenfalls seinen Swingtimer anzeigt, dort das Swing-Modul deaktivieren, um doppelte Balken zu vermeiden.
