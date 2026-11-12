# Call of Duty ADS Mechanics, Weapon Handling, Visual Clutter and Zoom-Transition Evidence (PC, mouse and keyboard)

Labels: **[DEV]** developer statement or official patch note, **[MEAS]** community measurement / data site, **[OPIN]** community opinion or guide, **[PR]** peer-reviewed, **[SNIPPET]** known only from a search summary (page not read in full), **[MATH]** derivation from geometry.

Research date: 2026-11-11. Access problems that limit confidence: mouse-sensitivity.com (HTTP 403 on every fetch), callofduty.com patch notes and blog (connection reset / timeout on every fetch; only search snippets available), insider-gaming and sportskeeda (403/405). No sym.gg, TrueGameData, XclusiveAce or JGOD page could be read directly. As a result almost all Call of Duty numbers below are either search-snippet quotes of official patch notes or one data site (CODMunity). Nothing here is confirmed from in-game tooltips. Note also that search results show a newer title, Modern Warfare 4 (PC release 23 Oct 2026 per an official blog snippet), which was not in the brief but shares the same settings family.

---

## 1. Sensitivity math on PC (yaw, FOV convention, ADS FOV, ADS sensitivity type, coefficient, transition timing)

### Takeaway
The hipfire yaw constant 0.0066 deg/count and the 16:9-horizontal FOV convention (60 to 120) are each supported by several independent community sources and by arithmetic checks, but by no developer document. The Relative ADS formula (monitor-distance match on vertical FOV, coefficient k) is a community-derived formula quoted consistently; the exact ADS FOV per optic, the Legacy behaviour, and what happens to sensitivity during the zoom animation are not verified and must be measured in game.

### Cited Findings
- [MEAS] Yaw: recent Call of Duty titles (MWIII, Warzone, Black Ops 6) use 0.0066 degrees per count at sensitivity 1, the same as Overwatch 2. Sources are converter sites; one claims the value was extracted from game code. No Activision documentation found. — [Recharge blog](https://www.recharge.com/blog/en-gb/mouse-sensitivity-converter-calculator-for-23-fps-games); [sensconverter.app COD page (c. Feb 2026)](https://sensconverter.app/cod-sensitivity-converter/); [csdb.gg converter](https://csdb.gg/sensitivity-converter/)
- [MEAS] Formula: cm/360 = (360 x 2.54) / (DPI x sensitivity x yaw). Worked examples published by two different sites agree with yaw 0.0066: sens 6 at 800 DPI = about 28.9 cm/360; sens 5 at 800 DPI = 34.6 cm/360. — [west-games calculator](https://west-games.com/cm-per-360-calculator/); [sensconverter.app](https://sensconverter.app/cod-sensitivity-converter/)
- [OPIN] FOV slider: Modern Warfare (2019)/Warzone use a horizontal field of view "based on the 16:9 aspect ratio"; range 60 to 120, PC default 80 (2020). Published table: 80 = 51 vertical, 90 = 59, 103 = 71, 110 = 78, 120 = 89 (16:9). — [esportstales, 12 Mar 2020](https://www.esportstales.com/call-of-duty/best-fov-field-of-view-modern-warfare-and-warzone)
- [OPIN] Black Ops 6 guides likewise define the slider as the horizontal angle of view; common recommendations 100 to 110 or 120. — [siege.gg BO6 FOV guide](https://siege.gg/news/best-fov-settings-for-black-ops-6); [Sportskeeda BO6 FOV](https://sportskeeda.com/call-of-duty-game/best-fov-settings-black-ops-6)
- [OPIN] Modern Warfare 4 (2026): one guide shows default FOV 95, another recommends 105; a PC-only "Enhanced FOV" option is described as expanding peripheral visibility "without changing the field of view at the center of the screen" (a lens effect). — [Dexerto MW4 FOV wiki, 2026](https://www.dexerto.com/wikis/modern-warfare-4/best-fov-settings/); [Gfinity, What is Enhanced FOV](https://www.gfinityesports.com/article/call-of-duty-mw4-what-is-enhanced-fov)
- [SNIPPET, OPIN] Ultrawide: a Reddit user reports that slider 107 on a 21:9 monitor is a "true" horizontal FOV of about 122. — [Reddit r/ModernWarfareII thread mirror](https://reddit.rtrace.io/r/ModernWarfareII/comments/z8u1td/the_difference_in_aspect_ratios_and_how_they/iydmbd2)
- [OPIN] ADS Field of View, "Affected": the ADS view scales with the FOV slider, keeping more peripheral view while aiming; targets look smaller. "Independent": ADS uses the game's default zoom regardless of the slider; Gfinity's example is that at slider 120 the ADS FOV "will revert to 65". Guides recommend Affected because the Independent jump from a high hip FOV is disorienting. — [Gfinity BO6 FOV](https://www.gfinityesports.com/article/best-fov-settings-for-black-ops-6); [CharlieIntel BO6 beta FOV](https://charlieintel.com/call-of-duty/best-fov-settings-for-black-ops-6-beta-336890); [Dexerto MW4](https://www.dexerto.com/wikis/modern-warfare-4/best-fov-settings/)
- [MEAS, SNIPPET] Relative ADS formula as given by community converters: ADS multiplier = atan(k x tan(ZoomFOV/2)) / atan(k x tan(HipFOV/2)), with k the Monitor Distance Coefficient; a forum post states that Battlefield and Call of Duty both use vertical FOV for this scaling. — [mouse-sensitivity.com forum thread 8559 (search summary only)](https://www.mouse-sensitivity.com/forums/topic/8559-in-games-that-dont-have-a-monitor-distance-coefficient-setting-should-we-assume-it-is-the-same-as-ahaving-a-0-coefficient/); [calculator page using the same formula](https://calculator.everycalculators.com/monitor-distance-coefficient-calculator/)
- [MEAS, SNIPPET] Meaning of coefficient values: a Black Ops 4 config comment says 1.33 = 75% and 0 = 0% for 16:9; forum posters describe default 1.33 as 133% vertical monitor distance (equal to 75% horizontal at 16:9). 0% is described as plain focal-length scaling; KovaaK's developers are quoted describing 0% as effectively focal-length scaling. — [mouse-sensitivity.com BO4 update thread (search summary)](https://www.mouse-sensitivity.com/updates/updates/call-of-duty-black-ops-4-r328/?&page=5); [mouse-sensitivity.com thread 8227](https://www.mouse-sensitivity.com/forums/topic/8227-yet-another-monitor-distance-formula-variant/)
- [OPIN] Selecting "Relative" shows the coefficient default 1.33; a Steam user recommends 1.78 on a 1920x1080 monitor with ADS multiplier 1.00. — [Steam discussion, 26 Oct 2024](https://steamcommunity.com/app/1938090/discussions/0/4693406471885520449/)
- [MEAS, SNIPPET] Legacy: forum posters say Legacy exists to keep the traditional Call of Duty ADS formula and that Relative + coefficient 0 + Gradual reproduces it ("the exact same setup"); one poster claims Legacy is "broken" and applies the coefficient as if Relative. Unverified and mutually inconsistent. — [mouse-sensitivity.com MW2019 thread p.8 and p.12 (search summary)](https://mouse-sensitivity.com/forums/topic/6164-call-of-duty-modern-warfare-2019/page/8); [Legacy to Relative conversion thread (403 on fetch)](https://mouse-sensitivity.com/forums/topic/7480-call-of-duty-modern-warfare-2019warzone-legacy-to-relative-ads-conversion)
- [OPIN, conflicting] sensconverter.app labels coefficient 0 as "Legacy/Default", 1.00 as "75% screen-distance match", 1.33 as "Relative, 1:1 at screen center" and 1.78 as "full screen-edge match". The 1.00 and 1.33 labels contradict the forum sources above (1.33 = 75% horizontal) and the geometry; treat this page as unreliable on that point. — [sensconverter.app](https://sensconverter.app/cod-sensitivity-converter/)
- [OPIN] ADS multiplier settings: two tiers, "Low Zoom" (irons, red dots, holos, low-magnification optics) and "High Zoom" (about 4x and above), each defaulting to 1.00; guides also show per-zoom custom multipliers (for example an "8x-9x Zoom" entry) and a separate "ADS Sens. Multiplier (Focus)". — [sensconverter.app](https://sensconverter.app/cod-sensitivity-converter/); [Beebom Warzone settings 2026](https://beebom.com/best-warzone-controller-settings); [siege.gg Warzone M&K settings](https://siege.gg/news/warzone-mouse-keyboard-settings)
- [OPIN] ADS Sensitivity Transition Timing: Instant applies the ADS multiplier immediately on pressing aim, Gradual ramps it over the zoom, After Zoom applies it when the ADS animation completes. No official description found. Steam M&K users report Instant feeling sluggish or "bugged" on scoped weapons and prefer After Zoom; a video summary recommends Gradual; controller guides mostly list Instant. — [hone.gg ADS explainer](https://hone.gg/blog/ads-in-call-of-duty/); [Steam discussion](https://steamcommunity.com/app/1938090/discussions/0/4757577647515373279); [video summary](https://gist.ly/youtube-summarizer/fix-your-ads-sensitivity-why-you-should-use-gradual)

### Inferences
- [MATH] Hipfire: cm/360 = 914.4 / (DPI x sens x 0.0066); deg per count = 0.0066 x sens. Examples: 800 DPI x 6.0 = 28.86 cm; 800 x 5.0 = 34.64 cm; 1600 x 2.60 = 33.30 cm; 800 x 7.5 = 23.09 cm. Hipfire cm/360 does not depend on FOV.
- [MATH] FOV convention check: V = 2 atan(tan(H/2) x 9/16) gives 120 -> 88.5, 110 -> 77.6, 103 -> 70.5, 90 -> 58.7, 80 -> 50.5, matching the esportstales table to rounding. So the slider is horizontal FOV at 16:9, i.e. the engine stores a vertical FOV of 2 atan(0.5625 tan(slider/2)).
- [MATH] Other aspect ratios: if the game is Hor+ (vertical fixed), H = 2 atan(tan(V/2) x aspect). Slider 107 -> V 74.5 -> at 21:9 (3440x1440, 2.389) H = 122.3, which reproduces the Reddit anecdote, so Hor+ is likely. Under Hor+, slider 120 gives H = 133.5 at 21:9 and 105.3 at 4:3. One anecdote is not verification.
- [MATH] Relative ADS, using vertical half-angles: m(k) = atan(k tan(Vads/2)) / atan(k tan(Vhip/2)). Limits: k -> 0 gives tan(Vads/2)/tan(Vhip/2) = 1/zoom (focal length); k = 1 gives Vads/Vhip (100% vertical); k = 1.333 is 133% vertical = 75% horizontal on 16:9; k = 1.778 is 100% horizontal on 16:9. Effective ADS cm/360 = hip cm/360 / (m(k) x ADS multiplier setting).
- [MATH] Worked example A (hip slider 120, V = 88.5; optic with 1.3x zoom relative to hip, V = 73.7): k = 0 -> 0.769; k = 1 -> 0.833; k = 1.33 -> 0.858; k = 1.78 -> 0.885. With hip 28.86 cm/360 and multiplier 1.00: ADS = 37.5, 34.6, 33.6, 32.6 cm/360.
- [MATH] Worked example B (same hip, 4x zoom relative to hip, V = 27.4): k = 0 -> 0.250; k = 1 -> 0.309; k = 1.33 -> 0.343; k = 1.78 -> 0.390. ADS = 115.4, 93.4, 84.1, 74.0 cm/360.
- The coefficient matters little at 1x optics (about 15% spread across the whole 0 to 1.78 range) and a lot at 4x and above (56% spread). For an AR/SMG profile the bigger uncertainty is the ADS FOV itself, not k.
- Affected vs Independent most plausibly means: Independent uses a fixed per-optic ADS FOV; Affected uses hip FOV divided by a per-optic zoom factor (in tangent space). Under Affected at high hip FOV the 1x "zoom" is small, so the view change and the sensitivity change on ADS are both modest. This is an inference from guide descriptions.
- Transition timing implies the trainer must model sensitivity as a function of ADS progress: step at t = 0 (Instant), interpolated with zoom progress (Gradual), or step at t = ADS time (After Zoom). During the transition the on-screen gain (pixels per mm) changes continuously either way because FOV is animating.

### Gaps
- No developer documentation or readable in-game tooltip text for any of these settings was retrieved. mouse-sensitivity.com, the best source for the formulas, could not be read (403).
- Base ADS FOV values per optic and title (the "65" in Gfinity's example is unexplained: unit, optic and title unknown) are unverified.
- Whether Legacy equals coefficient 0, whether Legacy/Relative behave identically across MWII, MWIII, BO6, BO7, MW4 and Warzone, and whether the Gradual ramp is linear in time or tied to the FOV curve, are unverified.
- Whether the FOV interpolation during ADS is linear in angle, linear in tangent, or eased is unknown; this determines the gain profile during the transition.
- Hor+ behaviour on ultrawide and 4:3/16:10 rests on one anecdote.

---

## 2. Zoom levels by optic and weapon class

### Takeaway
No reliable, title-specific table of ADS FOV or true magnification was found. The only figures are approximate community values: irons and 1x sights about 1.3x, then nominal 2x/3x/4x, snipers 6 to 10x.

### Cited Findings
- [OPIN, low authority] Zoom table from a converter site: iron sights about 1.3x, red dot/holo about 1.3x, 2x optic 2.0x, 3x optic 3.0x, 4x optic 4.0x, thermal 3.5x, sniper scopes 6 to 10x; the first four are "Low Zoom" tier and 4x and above "High Zoom" for the ADS multiplier settings. — [sensconverter.app](https://sensconverter.app/cod-sensitivity-converter/)
- [OPIN] Independent ADS FOV ignores the slider and uses a default zoom; example value 65 at slider 120. — [Gfinity](https://www.gfinityesports.com/article/best-fov-settings-for-black-ops-6)
- [MEAS, 2022] Higher zoom increases visual recoil and lower zoom reduces it; a higher FOV slider (PC) makes the same recoil look smaller. Attributed to TrueGameData videos. — [MeinMMO, 6 Feb 2022](https://mein-mmo.de/en/cod-warzone-what-is-visual-recoil-and-why-is-it-more-important-than-the-real-recoil,781192)

### Inferences
- [MATH] If the "1.3x" figure is relative to an 80 horizontal reference (the old default), the Independent 1x ADS FOV would be 2 atan(tan(40)/1.3) = 65.7 horizontal, which matches Gfinity's "65". This suggests Independent 1x ADS FOV is about 65 horizontal (16:9), and that zoom factors are defined relative to FOV 80. Plausible but unverified.
- [MATH] On that assumption, Independent at slider 120 gives a real magnification of tan(60)/tan(32.85) = 2.68x on ADS with a 1x sight, while Affected would give 1.3x (ADS FOV about 106). That large difference is why the trainer must expose ADS FOV mode per profile.
- The profile should store ADS FOV as an explicit angle per optic (plus a mode flag), not as a nominal "x" label, because nominal labels are not true magnifications.

### Gaps
- Actual ADS FOV for iron sights by weapon class (SMG vs AR vs LMG differ in older titles), for each optic, and for sniper scopes, per title. Needs screenshot measurement in game (known-size object at known distance, hip vs ADS, both modes).
- Whether weapon class changes base zoom in BO6/BO7/MW4.

---

## 3. Handling timings, hipfire, movement, sway and flinch

### Takeaway
Assault-rifle ADS times are 225 to 300 ms and sprint-to-fire 165 to 250 ms in BO6 and BO7 builds, the same order as the 200 to 335 ms kill window, so the hipfire-to-ADS transition is a large fraction of a close-range fight. Class-wide tables for SMG, LMG, sniper, slide/jump-to-fire and swap times were not retrievable.

### Cited Findings
- [MEAS] BO7 assault rifles (six listed builds, page last changed 15 Oct 2026): ADS 225 to 300 ms; sprint to fire 170 to 250 ms; TTK at 20 m (chest, 100 HP) 204 to 312 ms; fire rate 588 to 1034 RPM; bullet velocity 630 to 800 m/s; movement 4.4 to 5.0 m/s; ADS movement 2.8 to 3.3 m/s. — [CODMunity BO7 weapon stats](https://codmunity.gg/weapon-stats/bo7)
- [MEAS] BO7 base-weapon TTK examples: SMG close 224 to 226 ms, mid 244 to 383 ms; LMG 147 to 206 ms; marksman 165 to 195 ms; shotgun 205 ms close; pistols 164 to 267 ms close, 320 to 365 ms mid. — [CODMunity BO7](https://codmunity.gg/weapon-stats/bo7)
- [MEAS] BO6 assault rifles (listed builds, last changed 16 Oct 2025): ADS 230 to 300 ms; sprint to fire 165 to 210 ms; TTK at 20 m 200 to 335 ms; fire rate 561 to 938 RPM; movement 4.7 to 4.9 m/s; ADS movement 3.2 to 3.3 m/s; sprint 6.4 to 6.6 m/s; crouch 2.6 to 2.8 m/s; hipfire max spread 7 to 7.7 (units not stated, min not shown). Other classes close TTK: SMG 220 to 224 ms, LMG 225 to 240, marksman 180 to 230, pistol 255 to 300. — [CODMunity BO6 weapon stats](https://codmunity.gg/weapon-stats/bo6)
- [MEAS] TTK definition used: (shots to kill - 1) x time between shots, from first hit; range bands 0 to 10 m close, 10 to 40 m mid, over 40 m long. — [CODMunity BO6](https://codmunity.gg/weapon-stats/bo6)
- [DEV, SNIPPET] BO7 preseason patch notes (Nov 2025): a sprint-to-fire increase from 190 ms to 210 ms and tactical-sprint-to-fire from 300 ms to 320 ms (assault-rifle section; whether class-wide or one weapon is not clear from the snippet). — [Call of Duty BO7 preseason patch notes](https://www.callofduty.com/patchnotes/2025/11/call-of-duty-black-ops-7-preseason-patch-notes)
- [DEV, SNIPPET] BO7 Season 1 Reloaded (Jan 2026): attachment modifiers are percentages, for example a barrel's sprint-to-fire penalty or bonus moving between 8% and 13%, an SMG (Carbon 57) sprint-to-fire penalty from 9% to 17% and ADS penalty from 8% to 11%. Season 3 (Apr 2026): an ADS value changed from 245 ms to 240 ms. — [Warzone/BO7 Season 01 Reloaded notes](https://www.callofduty.com/patchnotes/2026/01/call-of-duty-bo7-warzone-season-01-reloaded-patch-notes); [Gfinity BO7 Season 3 notes](https://www.gfinityesports.com/article/black-ops-7-season-3-patch-notes)
- [DEV, SNIPPET] BO6 patch examples: Season 1 (Nov 2024) an ADS speed improved from 340 ms to 315 ms; Season 3 Reloaded Goblin Mk2 sprint to fire 190 -> 215 ms and ADS 270 -> 285 ms; Season 4 Reloaded (Jul 2025) an ADS speed slowed from 300 to 350 ms. — [Destructoid BO6 Season 1 balance](https://www.destructoid.com/all-weapon-balance-changes-in-black-ops-6-season-1/); [Insider Gaming S3 Reloaded](https://insider-gaming.com/all-weapon-buffs-nerfs-in-warzone-black-ops-6-season-3-reloaded/); [Warzone Season 04 Reloaded notes](https://www.callofduty.com/patchnotes/2025/07/call-of-duty-bo6-warzone-season-04-reloaded-patch-notes)
- [DEV, SNIPPET] Units used in official notes: ADS and sprint-to-fire in ms; hipfire spread in degrees (a Season 6 BO6 change reduced Goblin Mk2 hipfire spread by 0.25 degrees); ADS movement speed in m/s (a stock bonus raised by 0.14 m/s); "Idle Sway Delay" in ms (raised by 100 ms on several guns); "Flinch Received" as a percentage improvement (35% -> 40%). — [Gfinity Warzone/BO6 S4 Reloaded notes](https://www.gfinityesports.com/article/warzone-bo6-season-4-reloaded-patch-notes); [Deltia's Gaming S6 buffs/nerfs](https://deltiasgaming.com/?p=367915)
- [DEV, SNIPPET] Official BO6 stat groups: an accuracy group containing Hip Fire Accuracy, Flinch Resistance, Recoil and Centering Speed; a Handling group containing ADS time, Reload Quickness, Empty Reload Quickness and Sprint to Fire time. — [Call of Duty BO6 weapons and loadouts guide](https://www.callofduty.com/guides/blackops6/pre-game/call-of-duty-guides-black-ops-6-multiplayer-pre-game-weapons-and-loadouts)
- [DEV, SNIPPET] "Aiming Idle Sway Delay" scales idle sway when first entering ADS (quoted patch-note wording in a guide; Warzone 2 era). — [oneesports visual recoil guide](https://www.oneesports.gg/call-of-duty/reduce-visual-recoil-warzone-2/)
- [DEV, SNIPPET] BO6 pre-launch tuning cut weapon sway and recoil and made headshots more damaging. — [GamesRadar](https://gamesradar.com/games/call-of-duty/call-of-duty-black-ops-6-makes-headshots-deadlier-while-cutting-back-on-weapon-sway-and-recoil-we-will-be-keeping-a-close-eye-on-sniper-balance-after-this-change)

### Inferences
- For ARs, ADS time (225 to 300 ms) is roughly equal to the TTK (200 to 335 ms) and to the 190 to 315 ms close-range TTK noted in earlier project research. Add a human reaction time of about 150 to 250 ms and the sequence cue -> ADS -> first shot is about two TTKs long. Whoever starts ADS earlier (pre-aim) or skips it (hipfire at close range) gains a full kill window. This is the quantitative core of the user's "not a click trainer" point.
- From sprint, sprint-to-fire (165 to 250 ms) and ADS run concurrently in recent titles to the best of community understanding, so time-to-first-accurate-shot from sprint is about max(STF, ADS); from tactical sprint about 300 to 320 ms or more. Unverified whether they overlap fully.
- Attachment effects are percentage modifiers on base values (roughly 5 to 17% per attachment in the snippets), so a profile should store base time plus a modifier list or simply the resulting build values.
- Plausible class ordering (SMG fastest, then AR, LMG, snipers slowest; sniper values of 315 to 350 ms appear in BO6 patch snippets) is consistent with the snippets but class ranges other than AR are not sourced.
- ADS movement is about 65 to 68% of base walking speed for ARs (3.0 to 3.3 of 4.7 to 4.9 m/s), which sets both the player's own strafe and target strafe speeds for ADS scenarios.

### Gaps
- Per-class ranges for SMG, LMG, marksman, sniper, shotgun and pistol ADS and sprint-to-fire; slide-to-fire, dive/jump-to-fire and weapon-swap times; hipfire min/max spread values and bloom per shot; ADS strafe speeds by class; idle sway amplitude; flinch magnitude; aim-walking steadiness values. None retrieved. sym.gg and TrueGameData should have these but did not surface and could not be fetched.
- MWII/MWIII-specific timing tables (those titles were tuned slower; no numbers retrieved).
- Whether ADS progress is linear, and at what progress fraction hipfire spread collapses to ADS accuracy.

---

## 4. Recoil

### Takeaway
Community measurement distinguishes "actual" recoil (where bullets go, measured against a wall) from "visual" recoil (motion of the gun, sight and camera that the player sees), and holds that visual recoil dominates practical difficulty and grows with zoom. Developers have repeatedly reduced visual recoil (MWIII launch, MWIII April 2024, BO6 December 2024). Exact per-weapon magnitudes and the pattern/random split were not retrieved.

### Cited Findings
- [MEAS] Actual recoil is measured by firing a full magazine at a uniform wall; visual recoil is the kick seen through the sights and is partly independent of where shots land; it "matters more" because it determines how much correction the player must make. Higher zoom increases it, higher FOV slider reduces its apparent size, and few attachments other than optics change it. Based on TrueGameData videos. — [MeinMMO, 6 Feb 2022](https://mein-mmo.de/en/cod-warzone-what-is-visual-recoil-and-why-is-it-more-important-than-the-real-recoil,781192)
- [OPIN] Gun kick is described as the sharp upward or lateral movement of the weapon per shot; visual recoil as the on-screen movement of weapon, sights and camera during fire. — [games.gg MW4 visual recoil guide](https://games.gg/call-of-duty-modern-warfare-4/guides/how-to-reduce-visual-recoil/); [playnews.gg MW4 guide](https://www.playnews.gg/en/guides/call-of-duty-modern-warfare-4-visual-recoil-how-to-reduce-it-as-much-as-possible)
- [DEV, SNIPPET] Official notes tune "gun kick" and "view kick" separately per weapon (for example "gun kick reduction while focused" in BO6 Season 4; an LMG recoil and view-kick change in BO7 Jan 2026). — [Dexerto BO6/Warzone Season 4 buffs and nerfs](https://jamtest.dexerto.com/call-of-duty/all-buffs-and-nerfs-in-black-ops-6-warzone-season-4-3205910)
- [DEV, SNIPPET] MWIII 16 Apr 2024 update: MWII M16 visual recoil reduced 18% and gun kick reduced 20%. — [Comicbook.com](https://comicbook.com/gaming/news/call-of-duty-mw3-modern-warfare-update-patch-notes)
- [OPIN/MEAS] MWIII vs MWII: comparison of MWII weapons inside MWIII found weapon kick tuned down and "far less smoke"; carried-forward MWII weapons kept worse visual recoil until later passes. — [Prima Games](https://primagames.com/news/visual-recoil-is-supposedly-fixed-in-modern-warfare-3)
- [DEV, SNIPPET] Warzone Season 1 (BO6 integration, Nov 2024): "a visual recoil reduction pass has been applied to Modern Warfare II weapons". — [Gfinity Warzone BO6 Season 1 notes](https://www.gfinityesports.com/article/warzone-bo6-season-1-patch-notes)
- [DEV, SNIPPET] December 2024 Treyarch update reduced visual recoil on all weapons, especially full-auto; gun kick, turn sway and default idle sway were reduced as well; a content creator argued visual recoil was mainly a controller-player problem. — [Sportskeeda](https://www.sportskeeda.com/call-of-duty-game/only-controller-players-problem-cod-content-creator-opines-regarding-reduced-visual-recoil-black-ops-6-warzone)
- [OPIN] BO6 added a firing-range recoil wall; the PU-21 pattern is described as slightly left and up, then up while drifting right, i.e. a repeatable shape. — [Dexerto](https://dexerto.com/call-of-duty/black-ops-6-added-one-of-the-best-features-in-years-you-probably-missed-it-2962383)
- [OPIN, anecdotal] Warzone 2 players reported different patterns on repeated magazines with the same build ("inconsistent" recoil). — [repost of a Warzone 2 news story](https://uvoddupuz.pages.dev/posts/warzone-2-players-frustrated-as-expert-proves-guns-have-inconsistent-recoil-patterns)

### Inferences
- A faithful model needs at least three separable channels: (1) view kick, which moves the camera/aim point and must be countered with the mouse; (2) gun kick, which moves the weapon model and sight on screen and may or may not move the point of impact; (3) cosmetic shake (sight wobble, camera shake). Plus a deterministic mean pattern with per-shot random deviation, and a recentering (centering speed) term after firing stops.
- On mouse, recoil control is a low-frequency compensatory pull (mostly down, with a horizontal drift component) superimposed on target tracking, performed at ADS sensitivity. Because Relative scaling makes ADS sensitivity lower at higher zoom while visual recoil grows with zoom, the hand distance required per shot rises with zoom.
- In angle terms, FOV does not change the mouse movement needed to cancel a given recoil angle (hipfire sens is FOV-independent) but it changes the on-screen size of the error, so high FOV makes recoil look smaller and feedback coarser.

### Gaps
- No recoil magnitudes (degrees per shot, pattern coordinates, randomness cone, centering speed) were retrieved for any title. TrueGameData/sym.gg plots or own measurement from the BO6+ firing-range recoil wall are needed.
- Whether gun kick shifts the bullet origin/direction in BO6/BO7/MW4 (bullets follow sight vs follow screen centre) is not established here.
- No XclusiveAce or JGOD source was reachable.

---

## 5. Visual clutter while firing

### Takeaway
Muzzle smoke, flash and visual recoil obscuring targets is a long-running, well-documented complaint (worst in MWII and its weapons carried into MWIII/Warzone), and developers have made repeated, sometimes unannounced, reductions. Settings that reduce clutter are widely recommended, but no quantified measurement of screen coverage was found.

### Cited Findings
- [OPIN/MEAS] MWIII reduced smoke and kick relative to MWII; a later MWIII Season 3 update reportedly reduced smoke and sway further. — [Prima Games](https://primagames.com/news/visual-recoil-is-supposedly-fixed-in-modern-warfare-3)
- [DEV, SNIPPET] MWIII Season 2 (Feb 2024): Sledgehammer described ongoing work as improving the "precision and responsiveness of aiming". — [MWIII Season 2 patch notes](https://www.callofduty.com/patchnotes/2024/02/call-of-duty-modern-warfare-iii-season-2-patch-notes)
- [DEV, SNIPPET] BO6 Season 2 (Jan 2025): improved muzzle flash visibility on all SMGs when aiming down sights. — [BO6 Season 02 patch notes](https://callofduty.com/mx/es/patchnotes/2025/01/call-of-duty-black-ops-6-season-02-patch-notes)
- [OPIN] Warzone (Oct 2025): muzzle smoke was reduced without being listed in the patch notes; reports say close-range visibility improved markedly but smoke is still noticeable at distance; one weapon (DTIR) had smoke quietly reduced. — [OpenCritic news summary](https://opencritic.com/news/6642/call-of-duty-warzone-makes-major-change-to-smoke-but-fans-arent-happy); [Sportskeeda](https://sportskeeda.com/call-of-duty-game/news-warzone-finally-changed-one-biggest-problems-game-two-years)
- [OPIN] Flash hider attachments are recommended to reduce firing-effect obstruction. — [games.gg MW4 guide](https://games.gg/call-of-duty-modern-warfare-4/guides/how-to-reduce-visual-recoil/)
- [OPIN] Weapon Field of View: Narrow makes the weapon look bigger, Default is regular, Wide makes it smaller relative to the screen; competitive presets use Wide. Common preset: World Motion Blur off, Weapon Motion Blur off, 1st Person Camera Movement "Least (50%)" (default 100%), Inverted Flashbang as preference. — [oneesports Warzone/BO6 settings](https://www.oneesports.gg/call-of-duty/best-warzone-settings-bo6-guide/); [Sportskeeda BO6 FOV](https://sportskeeda.com/call-of-duty-game/best-fov-settings-black-ops-6); [GGRecon MW2 FOV](https://www.ggrecon.com/guides/mw2-how-to-change-fov-settings/)
- [OPIN] MW4: no dedicated muzzle-smoke setting; "Particle Resolution" and "Persistent Effects" are discussed as performance options. — [allthings.how MW4 beta settings](https://allthings.how/best-modern-warfare-4-beta-settings-for-max-fps-and-enemy-visibility/)
- [OPIN] A game-design article lists typical screen-shake values by weapon class and says a reduce-screen-shake option should always be offered (not Call of Duty specific, not evidence of effect). — [StraySpark FPS design article](https://www.strayspark.studio/blog/fps-game-design-fundamentals-ue5)

### Inferences
- The clutter sources a generic-asset simulation should parameterise independently: weapon model silhouette (hip and ADS, scaled by a weapon-FOV setting), optic housing/occluding ring and reticle, muzzle flash (per-shot sprite, brightness, duration), persistent smoke (accumulating with sustained fire, drifting, opacity), tracers, camera shake amplitude (with a 50 to 100% scale like the game's setting), hit markers and damage flinch.
- Because developers changed these values patch by patch and by weapon generation, a single "COD clutter" value is not meaningful; the profile needs levels (for example "MWII-like heavy", "BO6-like light") that the user can verify against their own game.
- The trainer can measure occlusion directly: fraction of frames in which the target centre (or a given fraction of the target's pixels) is covered by weapon/flash/smoke pixels during the kill window.

### Gaps
- No measurement of weapon-model or optic screen coverage (percent of screen, by weapon FOV setting) was found.
- No official tooltip text for Weapon Field of View, camera movement or Inverted Flashbang was retrieved; tracer and hit-marker specifics were not researched to a citable level.
- Official wording of the December 2024 and October 2025 changes could not be read directly (403/405 and connection resets).

---

## 6. Community and pro practice on mouse and keyboard (descriptive)

### Takeaway
Guides converge on Relative ADS with coefficient 1.33 (default) or 1.78, ADS multiplier 0.8 to 1.0, FOV 100 to 120 with Affected ADS FOV and Wide weapon FOV. No trustworthy dataset of M&K Call of Duty pro sensitivities exists in what was retrieved; the scene is controller-dominated.

### Cited Findings
- [OPIN] Guide presets: sens 2.60 at 1600 DPI with coefficient 1.33 and ADS multiplier 1.00; Relative with multiplier 0.8 and focus multiplier 1.0 (Warzone 2 era); sens 7.50 with coefficient 1.78 (a "Shroud-style" setting; the same page lists an ADS multiplier of 0.10, an outlier that is probably an error). — [oneesports MW3/WZ M&K settings](https://www.oneesports.gg/call-of-duty/mouse-and-keyboard-settings-mw3-wz/); [AFK Gaming WZ2 S6](https://afkgaming.com/esports/guide/best-mouse-and-keyboard-settings-for-call-of-duty-warzone-20-season-6); [siege.gg](https://siege.gg/news/warzone-mouse-keyboard-settings)
- [OPIN] Suggested starting ranges: 800 DPI with in-game 5.00 to 7.00, Relative, ADS multiplier 0.80 to 1.00; DPI claims conflict (one guide says 800 to 1600 with 1600 preferred, another says nearly all pros use 400 to 800). — [ar-pay Warzone sensitivity 2026](https://ar-pay.com/blog/en/articles/call-of-duty-warzone-sensitivity-settings/); [noping](https://noping.com/blog/best-mouse-sensitivity-for-warzone); [GGRecon](https://www.ggrecon.com/guides/best-warzone-sensitivity-settings-controller-mouse-keyboard/)
- [OPIN] Guides suggest raising the multiplier for higher-zoom optics to help recoil control at range. — [Sportskeeda Warzone controller/BO6 settings](https://www.sportskeeda.com/call-of-duty-game/best-controller-settings-warzone-black-ops-6-integration)
- [OPIN] A Steam reply to an M&K settings thread describes Call of Duty as a controller-focused FPS and advises switching from mouse (illustrates community sentiment, Oct 2024). — [Steam discussion](https://steamcommunity.com/app/1938090/discussions/0/4693406471885520449/)

### Inferences
- [MATH] The guide presets correspond to hipfire 33.3 cm/360 (1600 x 2.60), 23.1 cm (800 x 7.5), and 26.0 to 36.4 cm (800 x 5 to 7): faster than the CS2/Valorant pro medians (about 52 to 54 cm) in the earlier notes and near the fast half of the 20 to 80 cm plateau, consistent with a movement-heavy, close-range, tracking-dominated game. Descriptive only, small and unreliable sample.
- Coefficient choice barely matters for 1x sights (section 1), so community debate over 1.33 vs 1.78 mainly affects scoped weapons.

### Gaps
- No sourced material was retrieved on when M&K players pre-aim vs snap-then-ADS vs hipfire, or on centering conventions. These remain community lore without a citable source here.
- No prosettings-style dataset for M&K Call of Duty/Warzone players was reachable.

---

## 7. Human-performance research relevant to aiming through a zoom transition

### Takeaway
No peer-reviewed study was found on FPS aiming across an ADS/zoom transition, scoped vs unscoped aiming, or the effect of weapon occlusion, muzzle flash or screen shake on aiming. The only FPS sensitivity study explicitly excluded scoped modes. The nearest work is on magnification lenses in pointing and on visuomotor gain adaptation and context-dependent gain switching.

### Cited Findings
- [PR/preprint] Boudaoud, Spjut and Kim note that many games implement separate "scoped"/"zoomed" sensitivities, state that their study did not include this, and propose it as future work. — [arXiv 2203.12050](https://arxiv.org/pdf/2203.12050)
- [PR, SNIPPET] "Pointing Lenses" (Ramos, Cockburn, Balakrishnan, Beaudouin-Lafon; CHI 2007): a lens that magnifies the area under the cursor gives visually larger targets and also reduces the control-display ratio in motor space; a stated guideline is that lens activation should be a fluid, lightweight operation. PDF could not be parsed, so quantitative results are not reported here. — [paper PDF](https://www.dgp.toronto.edu/~bonzo/docs/p757-ramos.pdf)
- [PR, SNIPPET] Semantic pointing (Blanch, Guiard, Beaudouin-Lafon, CHI 2004) adapts CD ratio per target; lowering CD gain is equivalent to uniform motor-space magnification. — [CHI 2004 paper](https://hci.rwth-aachen.de/materials/conferences/CHI2004/1p519.pdf); [LRI report RR1508](https://pagoda.lri.fr/~bibli/Rapports-internes/2008/RR1508.pdf)
- [PR, SNIPPET] Pearson, Krakauer and Mazzoni (J Neurophysiol 2010): single-gain adaptation generalises broadly across directions; people can learn two different gains simultaneously, but more slowly than one. — [PMC2888232](https://pmc.ncbi.nlm.nih.gov/articles/PMC2888232)
- [PR, SNIPPET] Seidler, Bloomberg and Stelmach: contextual cues can be associated with multiple display gains (head-orientation cue effective, target-orientation partly, arm posture not); re-adaptation needs fewer trials after repeated exposure. — [NASA NTRS report](https://ntrs.nasa.gov/api/citations/20100033123/downloads/20100033123.pdf)
- [PR, SNIPPET] In dual adaptation, when a cue indicates which mapping is active, switching becomes practically instantaneous after prolonged training (prism-based study). — [PMC9217135](https://pmc.ncbi.nlm.nih.gov/articles/PMC9217135)
- [PR, SNIPPET] Česonis and Franklin (PLoS Comput Biol 2022): context can switch between independent visuomotor feedback controllers with different gains. — [paper PDF](https://www.hs.mh.tum.de/fileadmin/w00bbr/nd/pdf/Cesonis2022PLoSCompBiol.pdf)
- [PR, SNIPPET] The nearest FPS display research concerns HUD information displays (ammo, health, weapon, navigation), not occlusion of the target by the weapon or effects. — [Peacocke et al., Entertainment Computing 2018](https://www.yorku.ca/mack/ec2018.pdf)
- [PR, from earlier project notes] Hand sensorimotor delay is about 150 to 200 ms; flicks are largely open-loop, tracking closed-loop. — [Spjut et al. 2019](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)

### Inferences
- An ADS transition is a cued, self-initiated switch of both visual magnification and control-display gain lasting 200 to 300 ms, about one visuomotor feedback delay. Corrections during the transition are therefore made largely on stale visual information under a changing gain; the motor-learning literature suggests that with a reliable cue (the player's own button press) and extended practice, switching between two learned gains can become near-instant, which is an argument that the skill is trainable but must be practised with the real gains and timing. This is extrapolation from reaching studies, not FPS evidence.
- The three transition-timing options are in effect three different gain schedules during the movement; nothing in the literature says which is best, so the trainer should record aim error through the transition under the user's chosen option and avoid recommending one.
- Occlusion, flash and shake effects on tracking are untested in FPS; the trainer could generate the first data by A/B toggling clutter levels within a session.

### Gaps
- No FPS-specific peer-reviewed evidence on: ADS/zoom transitions, scoped vs unscoped aiming, gain change mid-movement, weapon/optic occlusion, muzzle flash, smoke or screen shake, or recoil control. Searches of general web and arXiv surfaced none; ACM DL was not searched directly.
- All motor-control items above are from search summaries, not full-text reads; effect sizes and trial counts were not retrieved.

---

## 8. How existing trainers handle ADS

### Takeaway
Existing trainers support zoom FOV and scoped sensitivity scaling, but the retrieved material shows no simulation of ADS time, sprint-to-fire, weapon-model occlusion or muzzle clutter, and Aimlabs' official Call of Duty content is flick/track/switch tasks. The user's "click trainer" characterisation is broadly supported, with the caveat that KovaaK's weapon editor was not examined first-hand.

### Cited Findings
- [OPIN, SNIPPET] KovaaK's: any weapon can be customised to any zoom level; most weapons allow setting zoom FOV and FOV type (some have the user-zoom-FOV option disabled); scope sensitivity is under Game Options > Weapons, where unticking auto sensitivity leaves a simple multiplier; there is no single universal scope sensitivity; a new sensitivity/FOV scale shipped Dec 2020; a Deadlock ADS calculation option was added Sept 2024. KovaaK's developers describe 0% monitor distance as focal-length scaling. — [mouse-sensitivity.com KovaaK's thread (search summary)](https://mouse-sensitivity.com/forums/topic/4848-kovaaks-fps-aim-trainer); [mouse-sensitivity.com thread 8227](https://www.mouse-sensitivity.com/forums/topic/8227-yet-another-monitor-distance-formula-variant/)
- [DEV (Aimlabs article, 29 Jan 2026)] Aimlabs' Black Ops 7 content: "Call of Duty Shooting Range" playlists of 15 tasks (Flicking, Tracking, Quicktrack, Switching, Mix at three difficulties) with free movement; an "Aim Basics Routine" (Speedswitch, Skyswitch, Strafeshot, Snipershot, Reflex Sniper and similar); a "Smoothness" playlist of community tasks including "rA 180 Regen Warzone". The article does not mention ADS, zoom, weapon models, recoil, hold-to-fire or FOV/sensitivity matching. — [Aimlabs article](https://aimlabs.com/articles/aimlabs/black-ops-7-aim-training-playlists-you-should-be-using/)
- [DEV] Aim Lab became the Call of Duty League's official training sponsor in a multi-year deal announced 14 Mar 2022. — [Business Wire release](https://www.businesswire.com/news/home/20220314005198/en)
- [DEV (Aiming.Pro, 16 Sept 2019)] Aiming.Pro added ADS: user-set zoom FOV, separate ADS sensitivity with a default-on "Relative Sensitivity", slower movement while ADS and a changed gun position (both described as aesthetic), right mouse button as ADS; limited to tracking games. No ADS time, recoil or weapon model fidelity mentioned. — [Aiming.Pro announcement](https://aiming.pro/ads-now-available)
- [SNIPPET] 3D Aim Trainer markets Call of Duty/Warzone-specific training pages; contents not examined. — [3D Aim Trainer COD guide](https://3daimtrainer.com/call-of-duty-aim-trainer-guide)

### Inferences
- What trainers do simulate: zoom FOV, scoped sensitivity scaling (monitor-distance or multiplier), sometimes hold-to-track and reduced ADS movement. What is not evidenced anywhere: ADS time as a gating delay with sensitivity transition options, sprint-to-fire, hipfire spread before ADS completes, weapon/optic occlusion, muzzle flash and smoke, Call of Duty-style view/gun kick. That gap is the product opportunity.
- Aimlabs has had a commercial relationship with the Call of Duty League since 2022 and still ships generic task types for it, which suggests the gap is not an oversight that is about to close, though this is speculation.

### Gaps
- KovaaK's weapon profile fields (whether it has an ADS time, recoil pattern or zoom-time parameter) were not verified from documentation or the app; kovaaks.com exposed only a site index. Check in the installed app.
- Aimlabs' in-app Call of Duty game profile (FOV/ADS conversion, weapon presets with recoil) was not verified.

---

## 9. Design implications for a data-driven weapon/ADS profile

### Takeaway
The profile should reproduce the game's settings math exactly (yaw, 16:9-horizontal FOV, Relative/Legacy scaling, transition timing) and treat every weapon-specific number as data to be verified against the live game, since values change by title, season and attachment.

### Cited Findings
- [MEAS] The parameters with sourced units: ADS time (ms), sprint to fire (ms), tactical sprint to fire (ms), fire rate (RPM), bullet velocity (m/s), movement and ADS movement speed (m/s), hipfire spread (degrees, min and max), idle sway delay (ms), flinch (percentage), attachment modifiers (percent). — [CODMunity BO7](https://codmunity.gg/weapon-stats/bo7); [Gfinity S4 Reloaded notes](https://www.gfinityesports.com/article/warzone-bo6-season-4-reloaded-patch-notes)
- [MEAS] AR reference values for defaults: ADS 225 to 300 ms, sprint to fire 165 to 250 ms, TTK 200 to 335 ms, 560 to 1030 RPM. — [CODMunity BO7](https://codmunity.gg/weapon-stats/bo7); [CODMunity BO6](https://codmunity.gg/weapon-stats/bo6)
- [PR/preprint] Scoped sensitivity is an open research question in FPS aiming. — [Boudaoud et al.](https://arxiv.org/pdf/2203.12050)

### Inferences
Profile schema (all inferred from sections 1 to 8):
- **Game settings block:** yaw (0.0066); sensitivity; FOV slider value and convention (horizontal at 16:9, Hor+); ADS FOV mode (Affected/Independent); ADS sensitivity type (Legacy/Relative); monitor distance coefficient k (0 to about 2, default 1.33); low-zoom and high-zoom multipliers plus optional per-zoom overrides; transition timing (Instant/Gradual/After Zoom); weapon FOV (Narrow/Default/Wide); camera movement scale (50 to 100%); motion blur flags.
- **Weapon block:** class; fire mode and RPM; ADS-in and ADS-out time; sprint-to-fire and tactical-sprint-to-fire; optional slide/jump/dive-to-fire and swap time; hipfire spread min/max, bloom per shot and recovery; ADS progress at which spread becomes ADS-accurate; ADS and hip movement speeds; idle sway amplitude, frequency and delay; flinch; recoil as view-kick pattern (per-shot yaw/pitch list) + random cone + gun-kick (model-only) + centering speed; magazine size; damage model or shots-to-kill for the kill window.
- **Optic block:** ADS FOV for Independent (angle) and zoom factor for Affected; zoom tier (low/high); FOV easing curve; housing occlusion mask (generic geometry); reticle.
- **Clutter block:** model silhouette scale for hip and ADS; muzzle flash size, brightness, duration; smoke emission per shot, opacity, lifetime; tracer visibility; shake per shot; hit-marker style; preset levels.

Metrics to record:
- Time from cue (target appears) to ADS press; ADS press relative to first mouse movement (pre-aim vs snap-then-ADS vs ADS-then-snap).
- Aim error (degrees and target-widths) at ADS start, sampled through the transition, and at ADS completion; error accumulated during the zoom; overshoot/undershoot sign immediately after the gain change.
- Time to first shot; whether the first shot was fired before ADS completed (and with what spread); first-bullet hit rate.
- Hit rate and damage over the kill window (for example the first N shots or first 300 ms of fire) under recoil; time to kill vs the weapon's theoretical TTK; vertical and horizontal recoil-compensation residual.
- Hipfire vs ADS choice by target range and outcome, to estimate the player's own crossover distance.
- Occlusion: fraction of the kill window with the target covered by weapon, flash or smoke; performance with clutter on vs off.

Must be verified side by side in the real game before shipping a preset:
1. Hipfire cm/360 at a given DPI and sensitivity (confirms yaw).
2. Horizontal and vertical FOV at several slider values on 16:9 and on the user's aspect ratio (confirms convention and Hor+).
3. ADS FOV per optic under Affected and Independent (screenshot measurement).
4. ADS cm/360 per optic under Legacy, Relative k = 0, 1.33, 1.78 (confirms formula and vertical-FOV basis).
5. Sensitivity during the transition for Instant, Gradual and After Zoom (scripted constant mouse motion, frame capture).
6. ADS time, sprint-to-fire and FOV easing curve from high-frame-rate capture; point at which hipfire spread ends.
7. Recoil pattern, randomness and centering from the firing-range recoil wall; whether bullets follow the sight under gun kick.
8. Weapon/optic screen coverage at each weapon FOV setting, and flash/smoke opacity over a sustained burst.

### Gaps
- Nothing in this schema has been validated against the game; every default must be labelled "unverified" until the tests above are run.
- Damage ranges, health values per mode (100 HP in BO6/BO7 multiplayer per CODMunity; Warzone differs with armour) and target movement models were outside this note's scope.
