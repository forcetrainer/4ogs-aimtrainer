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

- [ ] Scenery and cover, replacing the empty plain and the grey pillars.
      Makes targets below the player possible.
- [ ] Enemy models in place of capsules
- [ ] Targets that are already present or lean out, instead of popping in.
      Only meaningful once there is cover. This is where "I didn't see him"
      training starts.

## 4. Sound

After the world, because footsteps should come from places an enemy could be.

- [ ] Footsteps as the cue for off-screen enemies, replacing the red edge bars
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
      page first (see `game/assets/weapons/CREDITS.txt`).

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
