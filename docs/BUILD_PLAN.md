# Build plan

The order work gets done in, and why. Steps are sequenced by what depends on
what, with the riskiest unknowns first. The research behind the design is in
`reports/Call of Duty aim trainer design.md`.

Status marks: `[x]` done, `[~]` in progress, `[ ]` not started,
`[you]` needs something only the player can do.

## Already built

- [x] Sensitivity and FOV maths, matched against Modern Warfare 4 by hand
      (sensitivity 6.8 in game against the check scene, 2026-11-11)
- [x] Engagement drill: unpredictable cue, turn, aim down sights, fire under
      recoil, per-stage timing, stacked second target
- [x] Enemy time-to-kill that adapts to about a 70% win rate, kept per drill
- [x] Spawn zones measured in the player's own visual field
- [x] Stances: stand, crouch, prone, jump, drop shot
- [x] MP5 with iron sights and a removable red dot; sky lighting
- [x] Version control (local only; nothing pushed)

## 1. Foundations

Anything shaky here undermines everything timed or built on top of it.

- [x] `[you]` **Input check.** Done 2026-11-12 with `run_spike.bat`: 1000
      mouse events per second (every report from a 1000 Hz mouse arrives
      individually) and at most 2 events in one frame, so input is never
      held back by more than a frame. Not measured: the delay from a click
      to the screen changing, which needs a high-speed camera or a latency
      tool.
- [x] `[you]` **Spatial audio test.** Done 2026-11-12. Pre-rendered
      headphone footsteps were chosen, built and measured (see "Spatial
      audio options" below), then tried by the player with
      `run_audio_test.bat`: locating the source was "solid" with headphone
      rendering, and Godot's plain panning gave no usable direction. The
      placeholder footstep sound itself is poor and needs replacing with
      recordings (step 4).
- [x] **Split up the drill code.** Done 2026-11-12. In `game/scripts/`:
      `engagement.gd` (the drill's flow, input, aiming and firing),
      `placement.gd` (where targets appear), `weapon_view.gd` (the gun on
      screen), `hud.gd` (text and markers), `summary.gd` (results) and
      `run_log.gd` (files). Placement, summary and the log row format are
      covered by `game/tests/run_tests.gd`.
- [x] **Monitor size.** Detected 2026-11-12 from the size the monitor
      reports to Windows (34 in, 3440x1440, 21:9), once per screen
      resolution. `F1` / `F2` override it by hand and `F5` detects again.
      With more than one screen connected it cannot tell which is in use
      and keeps the current value. `[you]` Viewing distance cannot be
      detected: set it with `F3` / `F4` (currently 60 cm). A wrong size or
      distance shifts every target's real angle from the crosshair by
      about the same proportion.
- [ ] `[you]` **In-game baseline.** On hold (2026-11-12). Skill-based
      matchmaking confounds it: lobbies get harder as the player improves,
      so kill/death ratio and win rate tend to stay flat and cannot show
      progress on their own. The trainer's own fixed session check (step 2)
      is the primary measure. If this is picked up again, prefer measures
      matchmaking distorts less: the hidden skill value in Activision's
      personal data export (rising = improving), accuracy and headshot
      rate, and a by-hand tally of why deaths happened. There is no
      official stats API; the data export is the only clean source.

## 2. Measurement backbone

Built before more content so every later feature produces comparable data
from its first day.

- [x] Fixed start-of-session check: the same short test, cold, every session.
      This is the number that tracks real change; the adaptive drills are
      practice. Built 2026-11-12; not yet played through by a person.
      - The game opens on it. 16 targets, one at a time, listed in
        `game/drills/check.json`: the same kind of target in the same place
        relative to the crosshair every time. Nothing adapts and nothing
        shoots back; each target has a 4 second limit.
      - Score: typical (median) time to kill, with a target not killed
        counted as 4000 ms.
      - Sight, FOV, sensitivity and monitor settings are locked while it
        runs. `1` / `2` / `3` skip to practice; `C` repeats it, and repeats
        are saved as not cold and left out of comparisons.
      - Results go to `checks.csv` in the game's user data folder. The
        results screen lists earlier cold checks taken with the same sight
        and FOV only, since other settings are not comparable.
      - Changing `check.json` means raising its `version`, which starts a
        fresh comparison.
- [x] Run history, with results shown by sight and by FOV. Done
      2026-11-12 for the session check and for practice runs
      (`history_v3.csv`, which adds the sight; the results screen lists the
      level earlier runs of the same drill ended on, same sight and FOV
      only). Older `history_v2.csv` rows have no sight and are not shown.
- [x] Reaction time means the start of an unbroken mouse movement toward
      the target covering at least a tenth of the distance to it, ignoring
      the first 100 ms. The player scans constantly, so "any movement" read
      as an instant reaction. Still approximate: scanning that happens to
      head toward the target looks like a reaction.
- [ ] Improving / holding / stuck status from the session checks. Waiting
      on a week or so of real checks, to see how much the score varies
      from day to day before choosing a threshold.
- [ ] Python for analysis outside the game

## 3. The world

Scenery comes before the things that live in it.

Direction from the player, 2026-11-12: aim trainers are ugly and this one
should not be. It should have the look and feel of Call of Duty without
copying it, carry 4OGS branding, and be marked as a 4OGS "side quest"
(nothing to do with the race team). Nothing but what a game would show
appears during play: numbers during training are distracting noise.

- [~] **Shell and chrome.** Built 2026-11-12; screens checked from
      screenshots (`docs/screens/`), not yet clicked through by a person.
      - `game/scripts/app.gd` is the start scene: splash, main menu
        (start session, practice, settings, sound test, quit), practice
        list and settings, over the drill's world turning slowly behind.
      - `game/scripts/ui/style.gd` holds the look: near-black surfaces,
        off-white condensed type, and the brand gradient (`#a855f7` purple
        to `#06b6d4` cyan, from the logo in the `4ogs-radios` repo) kept
        for accents. Logo copied to `game/assets/brand/`.
      - During play the screen shows only the crosshair, hit marker,
        damage flash and off-screen cue. A briefing panel comes before a
        run and results after it. `Esc` pauses (the target in progress is
        discarded) and can return to the menu. The old on-screen status
        text and hotkeys are gone; settings live in the menu.
      - Open: the type is Bahnschrift (ships with Windows) as a stand-in.
        The team has brand standards for type that have not been found;
        swap the font in `style.gd` when they are.

- [~] Scenery and cover, replacing the empty plain and the grey pillars.
      Makes targets below the player possible. First pass 2026-11-12 in
      `game/scripts/world.gd`: a fenced tarmac yard built from Poly Haven
      models and textures (CC0, 49 MB, `game/assets/world/`), with
      chain-link fence at 46 m, clusters of barriers, crates, barrels,
      tyres and covered cars at about 40 m, and plain concrete blocks
      beyond as buildings. Still to do:
      - Done 2026-11-12: cover inside the yard. `game/scripts/cover.gd`
        lists fourteen pieces (concrete walls, crate stacks, barrier rows,
        covered cars) between 13 and 31 m and answers the geometry
        questions; `world.gd` draws them in the same places. Targets put
        in the open are placed where the player can see them and turn
        back before walking behind cover. Shots that meet cover first do
        not count as hits. Checked by tests and an unattended run; not yet
        played by a person.
      - Real buildings. The downloaded factory facade is a kit of wall and
        window parts that has to be assembled; the blocks are stand-ins.
      - Ground variety (markings, stains, patches) to break up the tarmac.
- [~] **Generated arenas.** First version built 2026-11-12 (cover layout
      only): `Cover.generate(seed)` makes a layout, every practice run
      gets a new one, the session check keeps the fixed layout (seed 0),
      and the seed is saved with each target and each run
      (`arena_seed`). Rules checked by tests over 300 arenas: six to
      eight tall pieces with one on every side, three to five low pieces,
      all 12 to 31 m out, none within 15 degrees of another as the player
      sees it. Two examples in `docs/screens/arena_a.jpg` and
      `arena_b.png`. Not yet played. Still to do: raised positions to
      replace the pedestals, a way to replay a seed from the menu, and
      themes. Raised by the player: variation
      helps. Practising in one fixed yard risks learning that yard (where
      the walls are, which corners enemies come from) instead of the
      skill; varied practice transfers better. Design as agreed so far:
      - Practice drills get a new layout each run, built from a seed:
        which pieces of cover, where, how many, and where the raised
        positions are. The seed is saved with the run so a layout can be
        replayed.
      - The session check always uses one fixed layout, or it stops being
        comparable from day to day.
      - A layout is generated from rules, not at random: open sight lines
        from the middle, cover at mixed distances, tall cover spread round
        the player so enemies can step out in any direction, and raised
        spots (rooftop edge, window, container top) to replace the
        pedestals.
      - `cover.gd` already describes cover as data that both the drawing
        and the geometry read, so a generator only has to produce that
        list.
      - Later: themes (yard, street, interior) once there is an
        environment kit to build them from.
- [~] **Environment kit.** 2026-11-12: the player downloaded Oleg
      Ushenok's free "Post Apocalypse Survivor Environment Kitbash set"
      from Fab (Standard License; files kept out of version control, see
      `game/assets/kit/README.txt`). The free sample is one scrap-built
      two-storey building of 330 numbered parts, about 1.1 million
      triangles, 2.4 times life size as imported.
      - `game/tests/kit_sheets.gd` renders every part as a numbered
        thumbnail; the sheets are in `downloads/fab_kit/catalogue/` and
        the sizes in `docs/kit_catalogue/parts.csv`.
      - `game/scripts/kit.gd` loads the building, builds its material,
        scales it to life size, and hands out single parts by number.
      - Cover is now made of kit parts: riveted steel plates, a tank and
        a shelving rack (tall); concrete barriers, a dumpster and tarped
        barrels (low). The whole building stands in each corner of the
        yard. Seen in screenshots; not yet played.
      - **Raised positions** (2026-11-12): a "tower" cover piece built
        from kit parts, with four I-beam legs, a railed walkway as a deck
        2.68 m up, a ladder, and a steel screen on the deck. An enemy
        waits behind the screen and steps out along the deck, then holds
        its position. This replaces the grey pedestals, which are gone:
        drills no longer place targets on them and the session check's
        two raised targets are now level. Towers appear in the fixed
        layout and in generated arenas. Checked by tests, an unattended
        run and a screenshot (`docs/screens/tower.jpg`); not yet played.
        Enemies below the player still need the player to stand on
        something.
      - Unused but worth having: stairs, railed walkway sections,
        gratings, ladder, mesh cage, window and door frames, corrugated
        roof sheets, gas cylinders, crates, solar panels. These are the
        makings of raised positions and of new structures.
      - Open: four copies of the building is over four million
        triangles, untested on a weaker PC. The concrete blocks beyond
        the wall and the plain tarmac are still stand-ins.
- [~] Enemy models in place of capsules. Started 2026-11-12 after the
      player said the capsules were "obviously rough" ("it's funny to
      watch a dummy fall over") but that crouching and drop shots are
      worth keeping because they are real. They downloaded Mixamo's Basic
      Shooter Pack and a Dying animation (files kept out of version
      control; see `game/assets/enemy/README.txt`).
      - `game/scripts/enemy_model.gd` joins one character and a set of
        animations into a figure with states: idle, strafe left and
        right, jump, die. Sideways travel is stripped from the animations
        because the drill moves the enemy itself.
      - The pack's character is Mixamo's mannequin, not the soldier, and
        the pack has no crouch or prone animations. So standing, strafing
        and jumping enemies are now an animated figure that falls when
        killed, while crouching and lying enemies are still the capsule.
      - Needed from the player to finish: the soldier character "With
        Skin" saved as `character.fbx`, and `crouch_idle.fbx`,
        `prone_idle.fbx`, `stand_to_prone.fbx`. Each one switches itself
        on when the file appears; no code change.
      - Not done: a rifle in its hands, and the hit shape still being a
        plain cylinder and sphere rather than following the figure.
      - Later the same day the player downloaded the soldier ("Swat")
        and a prone idle. The soldier is now the figure, with its own
        textures, and lying enemies are drawn too. `docs/screens/enemies.jpg`
        shows every stance side by side, including one mid-fall. Still
        missing: `crouch_idle.fbx` (crouching enemies are the last
        capsules) and `stand_to_prone.fbx` (a drop shot blends straight
        to lying). `game/tests/enemy_view.tscn` renders the line-up.
- [~] Targets that are already present or lean out, instead of popping in.
      Only meaningful once there is cover. This is where "I didn't see him"
      training starts. First version 2026-11-12: in practice drills a
      share of enemies (`cover_chance` in each drill file, 0.3 to 0.4)
      wait behind a wall or crate stack and step out sideways. Their clock
      starts when their edge first shows, and they never slide back behind
      the cover. The log has a `from_cover` column. The session check
      never uses them, so its results stay comparable. Still to do:
      - Enemies rising from behind low cover (barriers, cars).
      - Results split by "stepped out" against "appeared in the open".
      - With the player facing one way, few tall pieces are in view, so
        fewer enemies come from cover than the setting asks for.
      - Raised targets still stand on a plain grey pillar.

## 4. Sound

After the world, because footsteps should come from places an enemy could be.

- [~] **Gunfire and hit confirmation.** Built 2026-11-12, ahead of the
      rest of this step, because the player asked for it: bad sound is one
      of the things they dislike most in aim trainers, and gunfire matters
      because sound interrupts visual attention. Measured at the output;
      **not yet heard by a person**, so every level and the character of
      the hit sound are first guesses to tune by ear.
      - `game/scripts/gun_audio.gd` plays it all. Own gunfire is three
        single shots cut from a close recording of a 9 mm submachine gun
        (Carl Gustav M45, The Free Firearm Sound Library, CC0), with small
        changes of pitch and level per shot.
      - Hit, headshot and kill sounds are made in code: a dry knock that
        drops in pitch plus a burst of noise, with a bright ping added for
        headshots and kills. Deliberately not a real-world sound.
      - Enemies in practice drills shoot back in short bursts, starting a
        quarter of a second after they come into sight. The shots come
        from a mid-distance recording of the same gun rendered for every
        10 degrees round a dummy head, so they are heard from where the
        enemy is. The session check stays silent on the enemy side.
      - The hit marker is four strokes round the crosshair, white for a
        hit and larger and red for a kill.
      - `game/tests/tools_make_gunfire.gd` makes the sound files;
        `game/tests/gunfire_check.gd` checks they reach the output.
      - Second pass after the player listened (2026-11-12). The hit and
        kill sounds "beeped": they were built round a steady tone. They
        are now thwacks made only of noise bands, a click and a fast
        falling thump, with the kill a heavier double knock. The gun
        sounded thin and suppressed with no ambience, so each shot now
        also plays a low punch and the distant report as a tail, and all
        gunfire goes through a mixer channel with more low end, an echo
        timed to the yard wall and a short reverb.
      - Third pass the same day: the kill's double knock read as two
        shots, so it is now one heavy thud, with a separate headshot kill
        that adds a short high tink. Echo on the player's own shots was
        cut right back after a single shot sounded too echoing. The
        player then judged the set "good for now" and enemy fire "really
        good". Levels are still open to tuning.
      - `run_sound_preview.bat` plays each sound on a key press, for
        tuning by ear without playing a run.
      - Still to do: bolt and handling sounds, bullet impacts on cover,
        and more than three shot variants. If the made-up thwack still
        misses, switch to a recorded impact sound.
- [~] Footsteps as the cue for off-screen enemies. Built and played
      2026-11-12: the red edge bars are gone, enemies are heard walking
      (including behind cover before they step out), and an enemy that
      appears out of view makes a sound at that moment. The player liked
      being taught to turn toward sound, and in one practice run reacted
      faster to enemies that stepped out (201 ms against 284 ms). Two
      faults they raised, and what was done:
      - "You wouldn't hear them when they're really far away": footsteps
        are now a close sound, fading quickly past 9 m and silent past
        16 m. A distant enemy that appears out of view opens fire at once
        instead, so it is still heard. That applies in the session check
        too (its shots are only noise), which is why the check is now
        version 3.
      - "More like clicking": the footstep is still the synthesised
        placeholder. Real recordings are found (Fantozzi's Footsteps,
        CC0, OpenGameArt) but not yet downloaded.
- [ ] Older note on the same item:
      Enemy gunfire now also gives direction, so decide whether the red
      bars can go once both are heard.
- [ ] Front/back and left/right direction practice in short blocks with
      active turning

## 5. Weapon fidelity

- [ ] `[you]` Real Modern Warfare 4 values: aim-down-sights time, zoom, fire
      rate, damage, recoil. Needs side-by-side measurement in game. Can run
      alongside any other step.
- [ ] Arms and hands
- [ ] More weapons from the same pack

## 6. Adaptive features

These need the measurement backbone plus a few weeks of data.

- [ ] Sensitivity range finder
- [ ] FOV comparison: same test at different FOVs, reported per player
- [ ] Tunnel-vision test: a task at the crosshair while targets appear at
      the edges

## 7. Later

- [ ] Player movement, and enemies that shoot back
- [ ] Coaching notes written from the measured data
- [ ] Packaging for friends. Confirm the MP5 pack's licence on its store
      page first (see `CREDITS.md`). Done 2026-11-12: the author lists the pack as CC0.

## Spatial audio options (researched 2026-11-12)

Godot 4.7 has no built-in headphone (HRTF) rendering; its 3D audio only pans
level between left and right, which cannot tell front from back.

1. **Nexus Resonance v1.1.0** (github.com/undomick/godot-nexus-resonance,
   MIT, wraps Valve's Steam Audio). The only maintained add-on with ready
   builds, per-sound HRTF, and users reporting it running on Godot 4.7.2.
   Can load other HRTF sets. About 100 MB. Risks: an open crash-on-exit
   report on 4.7.2, a project under a year old with one maintainer, and it
   only accepts 44.1 or 48 kHz output. Not yet tried here.
2. **Pre-rendered footsteps.** Process each footstep sound offline for a
   grid of directions with a public HRTF set (SADIE II, Apache-2.0, or MIT
   KEMAR, free with citation) and play the nearest one. No add-on, no added
   delay, nothing to break on an engine update. Direction is fixed within
   each step, so turning only changes what the next step sounds like.
3. **godot-steam-audio** (the add-on usually recommended) was archived on
   2026-10-07, and its released version renders direction in a way that
   localises poorly. Forks with fixes exist but have to be compiled.
4. FMOD or Wwise would work but add a whole second toolchain for one
   feature. Doing the processing live in GDScript is too slow.

**Outcome, 2026-11-12: option 2 chosen.**

Option 1 was tried and dropped. Nexus Resonance v1.1.0 loaded on Godot
4.7.2, but this PC's sound device runs at 96 kHz and Godot follows the
device's rate on Windows. The add-on's built-in HRTF refused to start at
96 kHz; with a 96 kHz SADIE II file it started but its player still produced
no sound, while an ordinary Godot player in the same scene did. The cause
was not found. Anything that depends on each player's sound settings is a
poor fit for sharing with friends, so the add-on was removed.

Option 2 is built:

- `game/assets/hrtf/sadie_ku100_48k/`: 120 dummy-head impulse responses
  from SADIE II (Apache-2.0): every 5 degrees around at ear level, every
  15 degrees at 30 degrees above and below.
- `game/tests/tools_render_footsteps.gd`: offline tool that renders every
  footstep for every direction (25 seconds) into
  `game/assets/audio/footsteps_hrtf/` (360 stereo files, 11 MB).
- `game/scripts/spatial_steps.gd`: plays the footstep nearest to where the
  source is relative to the player's facing, with level by distance.
- `game/scripts/footstep_synth.gd`: the footsteps themselves, which are
  placeholder noise bursts, not recordings.
- `run_audio_test.bat`: listening test. Unseen footsteps play somewhere
  around you; turn to face them and click. `H` switches to Godot's plain
  panning for comparison.

Measured at the output on this PC (96 kHz): a source to one side is about
2.6 times louder in that ear, and the tone of a source behind differs from
one in front by 77% on a simple brightness measure (0% with plain panning).
That shows the cues are present. The player then ran the listening test
and reported that locating the source was solid with headphone rendering
and that plain panning gave nothing to go on (no figures recorded).

Limits to remember: direction is fixed within each 0.14 s step, the head is
a generic dummy head rather than the player's own, and there is no
occlusion or room sound.

## Known placeholders

- All weapon handling values in `game/weapons/mp5.json`
- Target health and strafe speeds in `game/profiles/call_of_duty.json`
- The aim-down-sights sensitivity coefficient (1.33) is the community figure,
  not measured in Modern Warfare 4
- The weapon's own field of view (50 degrees) was posed by eye

### Enemy figure, latest state (2026-11-12, evening)

The player then downloaded Mixamo's Pro Rifle Pack and some single
animations. Every stance is now the animated soldier; no capsules remain
in normal play.

- Standing: aiming idle. Moving: walk or run sideways, chosen by speed,
  with playback matched to ground speed.
- Crouching: crouched aiming idle and crouched sideways walk.
- Lying: prone idle. A drop shot blends to it; there is still no
  stand-to-prone animation (`stand_to_prone.fbx` would switch it on).
- Killed: one of three falls (from the front, headshot, or crouching).
  An enemy already lying is simply cleared.
- Not done: a rifle in the hands; a hit shape that follows the figure;
  a less conspicuous uniform than blue.
- Seen in `docs/screens/enemies.jpg`; not yet played.

More animations added the same evening (player downloads): a death for an
enemy that is lying, a second standing death, falls from a walk and from a
run, and crouch-to-prone, which is used as the drop shot. The fall is now
chosen by what the enemy was doing (lying, crouching, hit in the head,
running, walking, standing) with random variety where there is a choice.
The drop animation is 1.8 s long and is played in the 0.25 s a drop takes,
so it is very quick; not yet seen in motion. 18 animations in all, listed
in `game/scripts/enemy_model.gd`.

### Movement and hit regions (2026-11-12, evening)

Asked for by the player after playing with the soldier.

**Movement.** "They're often just going side to side... People crouch and
peek. Vary the movement to be more like game movement." In practice
drills an enemy in the open now gets one of six patterns
(`Target.PATTERNS`): strafe (as before), run across without turning, hold
still, move in stops and starts, bob between standing and crouching, or
push toward the player and stop at 8 m. Half the enemies that come from
cover now peek: out, back behind it, out again, sometimes coming back
crouched. They do not fire while hidden. The session check keeps plain
strafing so its results stay comparable. Tested; not yet played.

**Hit regions.** "Head, chest, arms, legs. Arms and legs should be
separate." `enemy_model.gd` lays rounded tubes along the figure's bones:
head, torso, each upper and lower arm, each thigh and shin. They follow
the animation, so a crouching or lying soldier is hit where he is drawn.
A shot meets whichever region is nearest along its path, so arms held in
front of the chest take the hit, as in the game. Damage: head uses the
weapon's headshot multiplier; arms 0.95 and legs 0.9 are placeholders in
`game/weapons/mp5.json`. `docs/screens/hitboxes.jpg` shows the regions
drawn over each stance (red head, yellow torso, green arms, blue legs).
Tested against the figure's resting pose; not yet played. The log does
not yet record which region each hit landed on.

### Eight-way movement (2026-11-12, late)

The player, after more play: "There's still a lot of back and forth
strafing. There should be straight running between cover, running away,
running towards you, closer", then: "We want the concept of 8 degrees of
movement, so all directions facing you, but also sometimes they are
static hiding, sometimes they're just standing there. We want to cover
all animation types."

- **Animations.** All 32 directional animations from the Pro Rifle Pack
  are installed: walk, run, sprint and crouch-walk, each in eight
  directions. The soldier always faces the player; which way he is really
  travelling relative to that picks the direction, and his speed picks
  the gait. The speed each animation was made for is measured from the
  file, so feet keep step with the ground.
- **Patterns for an enemy in the open** (`Target.PATTERNS`): strafe,
  stop-start, duck, hold still, roam (any of the eight directions at a
  walk, run or sprint, changing every second or so), and four straight
  runs planned by the drill: to a piece of cover (then hide and peek),
  across the yard, away from the player, toward the player.
- **Enemies at cover** now do one of four things once out: peek and duck
  back, stand at the edge holding the angle, break for another piece of
  cover, or walk out into the open.
- **Destinations are checked.** A run never ends somewhere the player
  cannot see, except behind the cover it was sent to.
- **The session check uses the new movement too** (version 4), with each
  target's pattern fixed by its seed. The player mostly plays the check,
  and it should feel like the game. Plain strafing is now one pattern in
  eight, not the rule.
- Tested, and unattended runs are clean. Not yet played, so whether the
  mix feels like real players is unknown, and the weights are a guess.

### Intro screens (2026-11-12, late)

- Splash: the logo image is nudged right by 5.5% of its width so the
  lettering, not the image, is centred (the flag on the top stroke runs
  out to the right). It now stays 8 seconds; any key skips.
- Logo wall, shown after the splash (`game/scripts/ui/logo_wall.gd`,
  `docs/screens/ui_logos.jpg`). The player wanted the slide of engine,
  studio and plugin logos every game shows, "but completely fake", with
  4OGS jokes sneaked in and logos that look real and all different.
  Fifteen made-up companies, each a joke taken from 4ogs.racing
  (Load-Bearing Engine, Thrown Rod Interactive, Probe/95 Physics,
  Redneckineering, Serpentine, Killswitch, Things 1-5, Pammy, Printed
  Twice, Thoughts & Prayers Capital, Jeffcal, 0.1% Studios, Bronze Cage,
  Accidental Discharge, DNF Engine). Each has its own typeface, layout and
  a mark drawn in code; white on black. Nothing copies a real company's
  name or mark. Stays 9 seconds; any key skips. To add or change one,
  edit the `LOGOS` list.

The player then asked for the logo wall to be annoying on purpose
(2026-11-12). As built:

- The title screen now waits for a key or a click, with no timer.
- The wall offers "SPACE or ESC  SKIP". Neither skips. Each press shows a
  roast (a list of 4OGS-flavoured lines) and adds 2.5 seconds, capped at
  double the page's 9 seconds. A click is mocked too.
- When the first page ends it shows "YOU THOUGHT WE WERE DONE." and then a
  second page of ten more made-up logos, with the offer moved to the top
  left and changed to "P  SKIP". P does not skip either, and the old keys
  get "Wrong key. It moved. Keep up."
- `4` skips instantly at any point and is never mentioned on screen.
- `game/tests/logo_wall_check.gd` checks all of this. Seen as stills
  (`docs/screens/ui_logos.jpg`, `ui_logos2.png`); not yet sat through.

### Music (2026-11-12, late)

The player wanted epic, grimdark-fantasy battle music: a big hit as the
title screen appears, then repeating cleanly for as long as anyone sits
on the menus.

- `game/assets/audio/music/menu_theme.mp3` was generated through
  Higgsfield (ElevenLabs Music v2.5, about 26 credits for two takes; only
  one take could be retrieved through the tool).
- `game/scripts/music.gd` starts it on the hit at the title screen, lets
  it carry through the logo wall into the menu, and repeats bars 5 to 36
  by bringing a second copy in one bar early, in step, and cross-fading.
  It fades out when a drill or the sound test starts and comes back in at
  the repeating part (no second hit) on return to the menu.
- Measured at the output: the opening is at full level in the first
  quarter second, and across the repeat the quietest tenth of a second is
  58% of the average, so there is no gap. Not yet heard by a person, so
  whether it is the right music is unknown.
