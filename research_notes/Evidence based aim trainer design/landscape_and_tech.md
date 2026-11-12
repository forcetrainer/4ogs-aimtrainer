# Aim Trainer Landscape and Technical Considerations (as of Nov 2026)

Research notes. Scope: existing products, benchmark ecosystem, visual design/fidelity, technical fidelity requirements, platform options, game-style differences, v1 shape and risks. Source quality is flagged inline: **[P]** primary/official, **[C]** community/forum, **[S]** secondary blog/aggregator (lower confidence). Items I know from background knowledge but did not verify in this session are confined to "Inferences" or "Gaps" and labelled as unverified.

---

## 1. Landscape: what existing aim trainers offer, how they are gated, what changed 2024-2026

### Takeaway
The market is a paid sandbox (KovaaK's, $9.99 one-off, huge community scenario library) versus a free-to-play trainer with a subscription layer (Aimlabs; the paid tier is now branded "Aimlabs Pro" on Steam/Corsair and "Aimlabs+" on other storefronts, about $10/month), plus free browser trainers (3D Aim Trainer, Aiming.Pro) and a thin tail of small open-source projects. Nothing found offers realistic cluttered scenes with camouflaged targets; every mainstream product trains abstract target acquisition, and the most-requested analysis/adaptive features are what Aimlabs paywalls.

### Cited Findings

**KovaaK's**
- Price $9.99 base game on Steam; DLC: Anime Pack $3.99, Tracking Trainer $4.99; bundles from $11.88. 23,200 English reviews, 93% positive; recent 30 days 90% positive of 429. [P] — [Steam store page](https://store.steampowered.com/app/824270/KovaaKs/)
- Store page states "over 200,000 scenarios" in one place and "over 31,000 scenarios and 150,000 playlists" in the Sandbox section (inconsistent on the page itself); scenario and map editors; customizable weapons; benchmarks tailored to VALORANT, Apex Legends, Fortnite, Overwatch with leaderboards; Steam Workshop; Windows/Mac/Linux/Steam Deck. [P] — [Steam store page](https://store.steampowered.com/app/824270/KovaaKs/)
- "Adaptive Training" adjusts target speed and size in real time in Freeplay and Challenge modes; search results attribute its introduction to version 3.6.0 with a 3.6.4 follow-up patch (dates not confirmed). [P]/[S] — [Steam store page](https://store.steampowered.com/app/824270/KovaaKs/); [SteamDB app page](https://steamdb.info/app/824270)
- No evidence of a free-to-play conversion; still a paid title in 2026 listings. [S] — [SteamDB](https://steamdb.info/app/824270)
- KovaaK's has been used as a research instrument: NVIDIA ran latency experiments inside it with 15,000+ players (see section 4), and a peer-reviewed pilot (n=10) assessed it as a reliable metrics platform for shooting proficiency. [P] — [NVIDIA dev blog](https://developer.nvidia.com/blog/improving-player-performance-with-low-latency-as-evident-from-fps-aim-trainer-experiments/); [PMC pilot study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10925653/)

**Aimlabs (Statespace)**
- Free to play on Steam; 1.0 release June 16, 2023 (Early Access from Feb 7, 2018). "Thousands of scenarios", routines for "over 400 supported titles", sensitivity match, free Creator Studio, official ranked Benchmark "Season 2" with Entry/Intermediate/Elite tiers, Aimlabs 2.0 (multiplayer modes, UI overhaul). 66,996 English reviews 90% positive, but recent 30-day reviews only 79% positive of 781. [P] — [Steam store page](https://store.steampowered.com/app/714010/Aimlabs/)
- Paid tier on Steam is called "Aimlabs Pro": deeper insights, "Coach Review" (described as trained on esports athletes; tracks weaknesses and suggests training), Sensitivity Finder, Training Programs, Adaptive Difficulty, Masterclasses, 50% off shop. In-app purchases for cosmetics (weapon skins, avatars, target cosmetics); six DLC items $3.99-$9.99. [P] — [Steam store page](https://store.steampowered.com/app/714010/Aimlabs/); [Corsair Aimlabs Pro page](https://www.corsair.com/us/en/s/aimlabs-pro)
- Same/similar tier is sold as "Aimlabs+": Steam lists a 1-month auto-renewing subscription at $9.99; PlayStation Store 6-month at $44.99 / EUR 39.99; contents include Premium Battlepass tiers, Academy masterclasses, "Discovery - your AI coach", Universal Sensitivity Finder, VALORANT training center. [P] — [Steam Aimlabs+ sub](https://store.steampowered.com/app/2253310?l=polish); [PlayStation Store](https://store.playstation.com/en-pl/product/UP6344-PPSA05351_00-AIMLABSPLUSSUB6M); [Logitech G x Aimlabs](https://www.logitechg.com/sv-se/discover/partnerships/aimlabs)
- A 2025 statement attributed to the Aimlabs product team: subscription "sits at $10/month" with cheaper yearly deals, and "we have never paywalled a previously free feature". [C] — [r/aimlab thread, May 2025](https://redlib.ssps.io/r/aimlab/comments/1ke2mqo/is_aimlabs_worth_it)
- Contradicting user reports: Steam forum thread "They lock all the good features" - users say an update moved things behind a paywall, a reply states Task Tuning moved to the PRO member option, another says Adaptive Tasks are paywalled. The current Steam store page, however, says Task Tuning "is now free" - i.e. gating has moved back and forth. [C]/[P] — [Steam discussion](https://steamcommunity.com/app/714010/discussions/0/600774668354350447/); [Steam store page](https://store.steampowered.com/app/714010/Aimlabs/)
- Statespace acquired ProGuides in Nov 2021; raised $29M Series B in 2020. No 2026 shutdown/acquisition news found. [P]/[S] — [BusinessWire](https://www.businesswire.com/news/home/20211102005937/en/); [TechCrunch](https://techcrunch.com/2020/11/12/statespace-raises-29-million-series-b-tops-1-5-million-maus)

**Browser trainers**
- 3D Aim Trainer: free, browser (also Steam), "200+ drills"; owned by SteelSeries since 2022. An (older) ProSettings review calls its feedback limited (accuracy and average time-to-hit only). [S] — [Wikipedia: Aim trainer](https://en.wikipedia.org/wiki/Aim_trainer); [Aiming.Pro comparison (competitor, self-interested)](https://aiming.pro/3daimtrainer-alternative); [ProSettings](https://www.prosettings.com/best-fps-aim-trainers/)
- Aiming.Pro: free in browser with ads; free tier includes an 88-drill general progression, benchmarks, community drills, sensitivity calculator; paid "Plus" tiers from $8.99/month (e.g., Valorant training). [P, vendor's own page] — [Aiming.Pro](https://aiming.pro/best-aim-trainer)
- Aimbeast: paid, listed at $7.99 in Aiming.Pro's comparison data (Steam price not directly verified). [S] — [Aiming.Pro](https://aiming.pro/best-aim-trainer)

**Open-source trainers and research tools**
- NVIDIA FPSci (FirstPersonScience): open-source experiment platform for FPS aiming studies built on the G3D Innovation Engine; JSON-like `.Any` config files (experiment, user, weapon, system); per-experiment results in SQLite `.db` files; frame-wise logging of player state; reordered render loop to reduce latency; optional hardware click-to-photon monitor / LDAT-R logging; builds with Visual Studio 2022; 1,912 commits, 80 stars, 38 open issues. License CC BY-NC-SA 4.0 (non-commercial, share-alike). Presented as a SIGGRAPH 2022 Talk. [P] — [GitHub NVlabs/FPSci](https://github.com/NVlabs/FPSci); [NVIDIA Research page](https://research.nvidia.com/index.php/publication/2022-08_firstpersonscience-open-source-tool-studying-fps-esports-aiming)
- NVlabs/WebFpsci: a web-based first-person targeting task environment (browser counterpart). [P] — [GitHub NVlabs/WebFpsci](https://github.com/NVlabs/WebFpsci)
- LibreAim: GPLv3 FPS aim trainer in Godot 4; development moved to Codeberg. [P] — [GitHub Nokorpo/LibreAim](https://github.com/Nokorpo/LibreAim)
- juanakajuan/aim-trainer: native Rust + raylib/GLFW (Linux), raw mouse motion via GLFW; README explicitly says it does not measure physical input latency. [P] — [GitHub](https://github.com/juanakajuan/aim-trainer)
- RomanUserExpert/aim-trainer: no-build browser trainer, 15 scenarios, raw input in Chrome/Edge, game sensitivity presets, explicitly designed so "you add your own scenarios with an AI agent". [P] — [GitHub](https://github.com/RomanUserExpert/aim-trainer)
- ValTrainer: free open-source Windows trainer for VALORANT (imports sens/crosshair/keybinds, peek duels, "aim coach"). TrueTrack: open-source Windows mouse calibration/aim testing. Natewa101: MIT Unity 2022.3 2.5D trainer using raw input. [P] — [ValTrainer](https://github.com/idoraz1/ValTrainer); [TrueTrack](https://github.com/FLASHBiRDone/TrueTrack); [Natewa101](https://github.com/Natewa101/Aim-Trainer-project)

### Inferences
- The paywalled layer across products is consistently *analysis and adaptation* (AI coach/Coach Review, adaptive difficulty, sensitivity finder, structured programs), not raw scenarios. A private project with full telemetry + an LLM summary directly substitutes for the paid tier.
- None of the surveyed products advertise target-detection/visibility training in realistic scenes; that is an open niche relevant to COD/Battlefield players (see section 6).
- The open-source field is small hobby projects; none is an obviously strong base except FPSci (research-grade but old engine, non-commercial license).
- The existence of an "AI-agent-authored scenarios" browser trainer (RomanUserExpert) shows the data-driven-scenario + AI-assistant workflow is viable for one developer.

### Gaps
- Engines: I did not retrieve a primary source stating KovaaK's is Unreal-based or Aimlabs Unity-based (both are widely reported and consistent with my background knowledge; unverified here).
- Exact dates for KovaaK's 3.6.x and the precise timeline of Aimlabs "Pro" vs "Aimlabs+" naming; whether they are the same SKU everywhere.
- In-game options (CS2 Aim Botz and other workshop maps, Valorant Range, COD firing range) and osu!: no sources retrieved this session. Unverified background: these are free, use the real game's input/render path (perfect sensitivity/FOV fidelity) but have little telemetry or structured progression.
- AimBooster-style 2D trainers, Aimbeast feature set, and any 2024-2026 shutdowns: nothing reliable found.

---

## 2. Benchmarks and routines ecosystem; taxonomy of sub-skills; community complaints

### Takeaway
Voltaic's KovaaK's benchmarks are the de facto taxonomy: three skills (Clicking, Tracking, Target Switching), each with three subcategories, two scenarios per subcategory (18 total) at Novice/Intermediate/Advanced difficulty, with ranks earned from per-subcategory "energy" thresholds. I could not retrieve the Reddit threads documenting burnout/score-gaming complaints, so those remain weakly sourced.

### Cited Findings
- Voltaic Season 5 (KovaaK's, beta announced 25 Dec 2024): three difficulty levels (Novice, Intermediate, Advanced); 18 scenarios. Clicking: **Dynamic** (Pasu, Popcorn), **Static** (1wxts, ww5t), **Linear** (Frogtagon, Floating Heads). Tracking: **Precise** (PGT, Snake Track), **Reactive** (Aether, Ground), **Control** (Raw Control, Controlsphere). Target Switching: **Speed** (DotTS, EddieTS), **Evasive** (DriftTS, FlyTS), **Stability** (ControlTS, PentaBounce). S5 added a third "hybrid" subcategory to each skill (linear, control, stability). (Subcategory-to-scenario mapping partly inferred by the fetch tool from scenario descriptions.) [P, community org] — [Voltaic S5 announcement](https://app.voltaic.gg/blog/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/)
- Design rationale in S5: one clicking scenario per category scores with square-root accuracy, the other uses a modified reload system to reward higher average accuracy; target-switching scenarios are built for 103 horizontal FOV; invisible walls minimized; wall-repel mechanics; Pasu reworked to remove a mid-air jump bug and wall-interaction randomness "unsuitable for benchmarking"; score requirements "may be adjusted as we gather more data"; ranks reset with the new season. Voltaic notes benchmarks measure raw aim and are "one piece of the puzzle" for in-game performance. [P] — [Voltaic S5 announcement](https://app.voltaic.gg/blog/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/)
- Earlier seasons: ranks assigned by reaching energy thresholds across six subcategories (S4: Clicking Dynamic/Static, Tracking Precise/Reactive, Switching Speed/Evasive); higher scores within thresholds award more energy. S2 sheet: regular rank needs 1 score per subcategory, upgraded (II) 2, complete all 3. [C] — [Voltaic S5 beta sheet copy (Scribd)](https://www.scribd.com/document/965739384/Voltaic-x-KovaaKs-Benchmarks-Season-5-BETA-File-Make-a-Copy); [S2 community sheet](https://docs.google.com/spreadsheets/d/1XbXf8Q_WTW5ekxuZWhvO64-kvNBvusqX3bghhBaok4I/edit)
- A "Season 5.5" expansion was released (announcement on X, 16 Aug per search summary - year not confirmed, likely 2026) with new spreadsheet, changelog and playlist sharecodes for Novice/Intermediate/Advanced; Voltaic S5 benchmarks are tracked natively on kovaaks.com. [P] — [Voltaic on X](https://x.com/VoltaicAim/status/2089125052964827615); [KovaaK's benchmark tracker](https://kovaaks.com/kovaaks/benchmark-tracker?benchmark_id=431)
- Voltaic also publishes routines matched to benchmark level. [P] — [Voltaic "Getting started"](https://voltaic.medium.com/getting-started-with-voltaic-20fa06c65342)
- Aimlabs has its own official ranked Benchmark (Season 2; Entry/Intermediate/Elite). [P] — [Steam store page](https://store.steampowered.com/app/714010/Aimlabs/)
- Revosect benchmarks exist as a separate community benchmark set (guide document located; contents not retrieved). [C] — [Revosect Benchmarks Guide (Scribd)](https://www.scribd.com/document/713904968/Revosect-Benchmarks-Guide)
- Documented complaints (Aimlabs Steam forum): scenarios "bear little resemblance" to real FPS play and feel like high-score chasing; real targets are not spheres. Counter-view in the same thread: comparable to athletes' isolated drills / warm-up. [C] — [Steam discussion](https://steamcommunity.com/app/714010/discussions/0/3130541122090357021)
- Transfer evidence: no peer-reviewed randomized study showing aim-trainer practice improves in-game performance was found; the peer-reviewed KovaaK's paper is a reliability (measurement) study with n=10. A widely circulated "27% KDA improvement / Esports Performance Institute" claim appears to be unsupported marketing content. [P]/[S] — [PMC pilot study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10925653/); [secondary review noting absence of controlled transfer studies](https://humanbenchmark.now/aim-trainer-faq/do-aim-trainers-transfer-to-real-games)

### Inferences
- Useful sub-skill taxonomy for scenario/telemetry design (Voltaic S5): Clicking {static, dynamic, linear}; Tracking {precise, reactive, control}; Switching {speed, evasive, stability}. This taxonomy omits target *detection/visual search*, recoil control, movement-while-aiming, and ADS transitions - the things that differ most between game styles (section 6).
- Voltaic itself removes randomness and "bug-exploitable" behaviour between seasons and resets ranks, which is indirect evidence that scenario-specific score optimisation (gaming) and threshold recalibration are real issues.
- For a private trainer, per-skill metrics normalised against the user's own history avoid the threshold/rank-grind dynamic entirely.

### Gaps
- Could not retrieve r/FPSAimTrainer / r/Voltaic threads on burnout, steep thresholds, or scenario-gaming (two searches returned nothing relevant). These complaints are familiar from background knowledge but are **uncited** here.
- Viscose benchmarks: nothing retrieved. Revosect structure: not retrieved. Exact S5 rank names and energy thresholds: not retrieved.

---

## 3. Visual design of trainers; fidelity and transfer

### Takeaway
No stated design rationale from KovaaK's or Aimlabs for abstract visuals was found; FPSci's stated rationale is experimental control and logging, not visuals. The general simulation literature says physical (look-alike) fidelity predicts transfer poorly and functional/psychological fidelity matters more - but for fine motor skills the movement demands must be reproduced accurately, and no study tests this for aim training specifically.

### Cited Findings
- FPSci's stated purpose: "finer parametric control of the environment and frame-wise logging" compared to mods/one-off apps; configuration-driven experiments. [P] — [NVIDIA Research](https://research.nvidia.com/index.php/publication/2022-08_firstpersonscience-open-source-tool-studying-fps-esports-aiming)
- Voltaic's benchmark design choices are about measurement validity (reduce randomness, constrain target motion, standard 103 hFOV), not realism. [P] — [Voltaic S5 announcement](https://app.voltaic.gg/blog/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/)
- Simulation-fidelity literature: reviews report the relationship between physical fidelity and transfer is minimal (Norman et al.) and argue functional task alignment matters more. [P, academic] — [Reconsidering Fidelity in Simulation-Based Training](https://www.researchgate.net/publication/259846424_Reconsidering_Fidelity_in_Simulation-Based_Training)
- Psychological fidelity = degree to which the simulator evokes the same sensory and cognitive processes as the operational environment; argued to be essential regardless of physical fidelity. [P, academic] — [A Psychological Fidelity Approach to Simulation-Based Training](https://www.researchgate.net/publication/267562279_A_Psychological_Fidelity_Approach_to_Simulation-Based_Training_Theory_Research_and_Principles)
- Aviation training commentary: perfect physical/functional fidelity is not required for transfer; for fine motor skills the simulator should accurately reproduce the required movements. [S] — [Competent Aviators](https://competentaviators.com/2024/12/01/getting-the-right-amount-of-stimulation-from-your-simulation-what-role-does-fidelity-have-in-training-to-fly/); [Ontario Tech fidelity framework](https://ontariotechu.scholaris.ca/server/api/core/bitstreams/6d518567-9056-4a6b-9405-a73efd956b5a/content)
- User criticism that trainer targets (spheres) differ from real hitboxes/situations. [C] — [Steam discussion](https://steamcommunity.com/app/714010/discussions/0/3130541122090357021)

### Inferences
- Mapping to aim training: *functional* fidelity = identical sensitivity/yaw, FOV, target angular size/speed, latency, timing demands; *psychological* fidelity = the perceptual task (finding a low-contrast target in clutter, deciding, then aiming). Abstract bright-sphere trainers have high functional fidelity for the motor step but near-zero fidelity for detection/discrimination. If the hypothesis is that COD/Battlefield difficulty is partly perceptual (section 6), then *task-relevant* visual properties (contrast, clutter, camouflage, partial occlusion, humanoid silhouettes) matter - not photorealism per se.
- This implies the rendering requirement is "controllable visual difficulty" (parameterised contrast/clutter/occlusion) rather than AAA graphics, which lowers the engine bar.

### Gaps
- No primary statement from KovaaK's or Aimlabs developers on why visuals are flat-shaded/bright (plausibly clarity, performance, and measurement consistency - unverified).
- No empirical study found on visual fidelity vs transfer in aim training or FPS specifically.

---

## 4. Technical requirements for fidelity

### Takeaway
Latency demonstrably matters (NVIDIA: 25 ms vs 85 ms system latency gave ~24% higher scores on a clicking task and roughly 2x on a hard flick task), and on Windows the correct input path is Raw Input (WM_INPUT / buffered GetRawInputBuffer), with a known pitfall where 4-8 kHz mice flood the message queue with legacy messages. For presentation, a flip-model swap chain in true fullscreen (or MPO overlay) with waitable swap chain / max frame latency 1 or tearing-allowed VRR avoids the ~1 frame the compositor (DWM) otherwise adds.

### Cited Findings

**Why latency matters**
- NVIDIA + KovaaK's study (data Dec 2021-Apr 2022, 15,000+ players, latency fixed with Reflex at 25/55/85 ms): "Latency Frenzy" mean score 112.62 / 103.75 / 90.58 (25 ms about 24% above 85 ms); "Latency Flicking" mean 15.15 / 11.20 / 7.74 (about 2x); top 10% median 31 / 22 / 15; effect largest for the most skilled players; p << 0.001. [P] — [NVIDIA dev blog, Apr 2022](https://developer.nvidia.com/blog/improving-player-performance-with-low-latency-as-evident-from-fps-aim-trainer-experiments/)
- NVIDIA SIGGRAPH Asia 2019: latency matters more than refresh rate above 60 Hz for first-person targeting; 30 ms of added latency has a significant effect; frame rate x latency interaction not significant. [P] — [Paper PDF](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf); [Supplement](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/Supplement_FPS_Tasks_sa2019_AuthorVersion_0.pdf)
- 2021 case study: earlier work suggested diminishing returns below 40 ms, but the authors argue improvements below 20 ms still matter for esports aiming. [P] — [arXiv 2105.10498](https://arxiv.org/pdf/2105.10498)

**Raw mouse input on Windows**
- Microsoft guidance: WM_INPUT (raw input, relative `lLastX/lLastY`) is the best way to read high-definition mouse movement; WM_MOUSEMOVE loses sub-pixel precision and is subject to pointer ballistics. [P] — [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/dxtecharts/taking-advantage-of-high-dpi-mouse-movement)
- High-polling pitfall (Durante/PH3, Sep 2024): with an 8 kHz mouse, frame rate fell from ~360 FPS to ~133 FPS and became unstable even with batched raw input, because registering for raw input still generates legacy WM_MOUSEMOVE messages that flood the queue. `RIDEV_NOLEGACY` suppresses them but breaks window interactions (moving/resizing); you cannot toggle legacy on/off after registration; a separate message-only window/thread does not help because raw input registration is per-process. Workaround used: keep legacy, read game input via batched `GetRawInputBuffer`, cap message-queue processing to ~5 events per frame. [P] — [PH3 blog](https://ph3at.github.io/posts/Windows-Input/)
- SDL moved raw input to a dedicated thread using only `GetRawInputBuffer()` to get "mouse input at the lowest latency possible", and fixed dropped input caused by mixing GetRawInputBuffer and WM_INPUT handling. [P] — [SDL commit discussion](https://discourse.libsdl.org/t/sdl-fixed-dropping-raw-input-because-of-mixing-getrawinputbuffer-and-wm-input-handling/48116)
- Polling-rate arithmetic: at 125 Hz a report arrives every 8 ms (average 4 ms added delay); Godot's article defines "high polling rate" as 2 kHz+ and says the benefit is slightly lower latency and more consistent updates. [P] — [Godot article, 24 Aug 2026](https://godotengine.org/article/fixing-high-polling-rate-mice-on-windows/)

**Presentation path / frame pacing (Windows)**
- DWM composition adds about one full frame of latency to windowed apps. It is bypassed when (a) the window is fullscreen with nothing overlaid (exclusive fullscreen is no longer required for this), or (b) the window is promoted to a Multiplane Overlay (MPO; 2022: Intel and NVIDIA RTX 20+ only, disabled with rotation or 10-bit). Verify with PresentMon ("Hardware Composed: Independent Flip"). [P, practitioner blog, Jul 2022 - may be dated] — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)
- Use the DXGI frame-latency waitable object with `SetMaximumFrameLatency(1)`; `DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING` is required for VRR and allows uncapped presentation. Windowed DirectX 9 has ~3 frames of latency; windowed OpenGL on Windows cannot use MPO so always exceeds one frame even with VSync off. [P] — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)

**Sub-frame / sub-tick hit registration in real games**
- CS2 "sub-tick": servers still tick at a fixed rate but shots, movement starts and grenade throws carry timestamps between ticks; jump-landing timing reportedly added Jan 2026. [S, third-party guides; not verified against Valve] — [BoostPirate guide](https://boostpirate.com/guides/cs2-subtick-explained); [TradeUp Academy](https://tradeupacademy.org/articles/cs2-subtick-movement-peeking-explained-2026)
- Overwatch "High Precision Mouse Input": uses the mouse's native report timing instead of the fixed 62.5 Hz simulation tick, so a shot can be resolved at the aim direction between ticks/frames; small CPU cost. [C]/[S] — [Blizzard forum](https://us.forums.blizzard.com/en/overwatch/t/in-the-most-basic-language-you-can-use-what-does-high-precision-mouse-input-do/425905); [Xbit Labs](https://www.xbitlabs.com/?p=23380)

**Telemetry**
- FPSci precedent: frame-wise logging of player state to SQLite per session, with config-defined conditions - a proven schema pattern for later analysis. [P] — [NVIDIA Research](https://research.nvidia.com/index.php/publication/2022-08_firstpersonscience-open-source-tool-studying-fps-esports-aiming); [GitHub](https://github.com/NVlabs/FPSci)

### Inferences
- Concrete requirement set for a faithful trainer: (1) Raw Input deltas, never OS cursor positions; (2) timestamp each raw report (QueryPerformanceCounter at read time) and each button event; (3) resolve hits at the *click timestamp* by interpolating/accumulating view angle up to that instant (the CS2 sub-tick / OW high-precision model) rather than at frame boundaries; (4) rotation = counts x yaw constant x sensitivity, accumulated in double precision, with no smoothing/acceleration; (5) per-game FOV conversion (horizontal vs vertical basis, aspect handling) and ADS multiplier; (6) uncapped or VRR presentation in flip-model fullscreen with max frame latency 1; (7) log raw events + per-frame state to a file readable by Python/DuckDB.
- For a local single-player trainer there is no server, so "sub-tick" simply means: do not quantise the shot to the render frame. At 240 FPS a frame is 4.2 ms; a 300 deg/s flick moves 1.25 deg per frame, larger than a head at range - so frame-quantised hit tests measurably mis-score fast flicks.
- 8 kHz mice are an explicit risk for any engine whose message pump is naive; test with the developer's actual mouse early.

### Gaps
- No authoritative source retrieved for exact per-game yaw constants (e.g. Source 0.022 deg/count, Valorant 0.07) or ADS multiplier formulas; these are well known in the community and available from sensitivity-converter sites, but **uncited** here.
- No primary Valve documentation of sub-tick retrieved.
- No source retrieved on exclusive-fullscreen vs borderless measurements on Windows 11 24H2/25H2 specifically; Darpinian's post is from 2022.
- No measured data on the benefit of 4-8 kHz polling for aiming performance.

---

## 5. Platform options and trade-offs for this project

### Takeaway
Browser is the fastest to iterate and share but has no control over presentation queue depth and no published latency parity with native; Godot 4 is the best-evidenced middle path (MIT, text-based project files, raw input on Windows, and the 8 kHz mouse bug was fixed only in 4.7.2 / 4.8.dev3, Aug 2026). Unity/Unreal raise the visual ceiling at the cost of heavier, more binary-asset-centric workflows; custom native gives full control of input/present but the most work; FPSci is a good reference design but a poor base (G3D engine, non-commercial license).

### Cited Findings

**(1) Browser (Three.js / Babylon.js / WebGPU)**
- `requestPointerLock({ unadjustedMovement: true })` disables OS mouse acceleration (Chrome 88+; Chromium-only as of the article; supported on Windows, macOS 10.15.1+, ChromeOS; must handle `NotSupportedError`). Chrome 131+ (Oct 2024) requires a permission for pointer lock. [P] — [web.dev](https://web.dev/articles/disable-mouse-acceleration)
- W3C Pointer Lock spec text: with `unadjustedMovement` true, event coordinates must not be affected by platform behaviours such as acceleration. [P] — [W3C webapps list](https://lists.w3.org/Archives/Public/public-webapps-github/2024May/0188.html)
- Coalesced events: `pointerrawupdate` movement should equal the sum of its coalesced events; Firefox bugs in 2026 show coalesced entries reporting zero movement under pointer lock on macOS - cross-browser reliability is still uneven. [P] — [Mozilla bug 2055058](https://bugzilla.mozilla.org/show_bug.cgi?id=2055058); [Mozilla bug 2071024](https://bugzilla.mozilla.org/show_bug.cgi?id=2071024)
- Latency: a practitioner test on Windows found **no measurable benefit** in Chrome from `desynchronized: true`, `pointerrawupdate`, or OffscreenCanvas, and concluded that without explicit queue-depth control "input latency of WebGL and WebGPU content in browsers is going to remain poor". [P, 2022] — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)
- Chrome reported as having 1-2 frames of latency attributable mainly to the compositor path; `desynchronized` avoids at best one frame of canvas/DOM sync. HaxBall enabled desynchronized canvas and moved input handling into the input event, claiming "a few milliseconds" saved; notes it does not fix frame-rate-limit issues as of Chrome 113. [C]/[P] — [HN comment](https://news.ycombinator.com/item?id=28783719); [HaxBall blog, May 2023](https://blog.haxball.com/2023/05/01/input-lag-improvments.html); [three.js issue #16684](https://github.com/mrdoob/three.js/issues/16684)
- Existence proofs: NVIDIA's WebFpsci; several GitHub browser trainers using raw input in Chrome/Edge. [P] — [WebFpsci](https://github.com/NVlabs/WebFpsci); [RomanUserExpert/aim-trainer](https://github.com/RomanUserExpert/aim-trainer)

**(2) Godot 4**
- Godot uses raw input on Windows. Before the fix, an 8 kHz mouse in captured mode dropped a test project to <1 FPS (4.7.1); after: 1,703 FPS uncapped, 477 FPS at 480 Hz VSync. Visible-mouse 8 kHz: 173 -> 1,103 FPS. Fix (buffered raw reads in `process_raw_input()`, delayed WM_INPUT dispatch, legacy mouse motion limited to once per frame) shipped in **4.7.2** and **4.8.dev3**; 4.7.1 does not have it. Problem appears above roughly 1-2 kHz depending on single-core speed. [P] — [Godot blog, 24 Aug 2026](https://godotengine.org/article/fixing-high-polling-rate-mice-on-windows/)
- Input accumulation is on by default: `_input()` receives roughly one merged mouse-motion event per rendered frame; disabling it delivers every report (up to 8,000 calls/s at 8 kHz), so handlers must be light. [P] — [Godot blog](https://godotengine.org/article/fixing-high-polling-rate-mice-on-windows/)
- An open-source Godot 4 trainer (LibreAim, GPLv3) exists as reference code. [P] — [LibreAim](https://github.com/Nokorpo/LibreAim)

**(3) Unity 6**
- Unity Personal is free up to $200,000 revenue+funding (threshold raised with Unity 6, released 17 Oct 2024); splash screen optional in Unity 6; Pro/Enterprise +5% from 12 Jan 2026. [P] — [Unity pricing updates](https://unity.com/products/pricing-updates)
- Unity staff (older thread, about 2020-21): the Input System taps mouse through Raw Input and sends an update for each WM_INPUT; a developer reported deltas not arriving until a full pixel of movement. `Windows.Input.ForwardRawInput` API exists for custom raw-input handling. [C]/[P, dated] — [Unity Discussions](https://discussions.unity.com/t/new-input-system-get-raw-mouse-delta-from-wm_input/857382); [Unity scripting API](https://docs.unity3d.com/ScriptReference/Windows.Input.ForwardRawInput.html)
- Precedent: Aimlabs offers a free Creator Studio and thousands of tasks (engine not verified here). [P] — [Steam](https://store.steampowered.com/app/714010/Aimlabs/)

**(4) Unreal Engine 5** — no sources retrieved this session (see Gaps).

**(5) Custom native (C++/SDL3, raylib, Rust + wgpu/Bevy)**
- SDL's Windows backend reads raw input on a dedicated thread via `GetRawInputBuffer()` for lowest latency. [P] — [SDL commit discussion](https://discourse.libsdl.org/t/sdl-fixed-dropping-raw-input-because-of-mixing-getrawinputbuffer-and-wm-input-handling/48116)
- A Rust + raylib/GLFW trainer exists (Linux; GLFW raw mouse motion). [P] — [juanakajuan/aim-trainer](https://github.com/juanakajuan/aim-trainer)
- Native gives direct access to the swap-chain controls in section 4 (waitable swap chain, max frame latency 1, allow-tearing). [P] — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)

**(6) Building on FPSci**
- Pros: purpose-built for aim experiments; config-file-driven sessions; SQLite logging; latency-ordered render loop; hardware latency measurement hooks. Cons: G3D Innovation Engine dependency (specific revision), Visual Studio 2022 C++ build, no tagged releases, CC BY-NC-SA 4.0 (non-commercial + share-alike - acceptable for a private hobby project, restrictive otherwise). [P] — [GitHub NVlabs/FPSci](https://github.com/NVlabs/FPSci); [NVIDIA Research](https://research.nvidia.com/index.php/publication/2022-08_firstpersonscience-open-source-tool-studying-fps-esports-aiming)

### Inferences (comparison matrix; ratings are my judgement, grounded in the findings above plus unverified background knowledge where marked *)

| Option | Raw input / latency | Visual ceiling (cluttered, camouflaged scenes) | AI-assistant iteration | Share with friends | Cost/licence | Telemetry + Python/DuckDB + LLM |
|---|---|---|---|---|---|---|
| Browser (Three.js/WebGPU) | Raw deltas in Chromium only; no queue-depth control; expect roughly 1-2 extra frames vs tuned native (no rigorous published measurement) | Moderate (PBR, shadows OK; heavy scenes cost more) | Best: all text, hot reload, no editor | Best: URL | Free | Easy: JSON/NDJSON download or local server; LLM call via small backend |
| Godot 4.7.2+/4.8 | Raw input; 8 kHz fixed Aug 2026; disable input accumulation for per-report events; presentation tunables fewer than custom D3D* | Good (Forward+ renderer*) - enough for controllable clutter/contrast | Very good: .tscn/.tres/.gd are text*; MIT | Export .exe zip | Free, MIT* | Easy: write CSV/SQLite/NDJSON from GDScript/C#; HTTP client built in* |
| Unity 6 | Raw Input via Input System; sub-frame access needs low-level event handling | High (HDRP*) | Medium: C# is text, but scenes/prefabs are YAML with GUIDs, editor-centric | Build .exe | Free under $200k | Easy in C# |
| Unreal 5 | Not researched here | Highest* | Lowest: Blueprints/.uasset binary*, long compile times* | Large builds* | Free until royalty threshold* | Possible in C++ |
| Custom native (Rust/wgpu, C++/SDL3) | Best: own raw-input thread, timestamps, swap chain | Whatever you build - realistic scenes are a lot of work | Good (all text) but most code to write | .exe | Free | Full control |
| FPSci fork | Research-grade, latency-aware | Low/abstract; old engine | Poor: niche engine, little LLM training data* | Windows build | CC BY-NC-SA | Built-in SQLite logging |

- Given "hobby, one developer + AI assistant, a few friends, high-fidelity mouse aim", Godot 4.7.2+ or custom native (SDL3/Rust) fit best; the browser is a legitimate prototyping path if the latency penalty is measured and accepted. The key engine-agnostic design is: scenarios as data files (JSON/TOML), telemetry as append-only event logs, analysis outside the game process.
- Whatever platform is chosen, latency should be *measured* on the developer's machine (PresentMon; ideally a photodiode/LDAT-style click-to-photon test, as FPSci supports) rather than assumed.

### Gaps
- **No rigorous published measurement of browser vs native click-to-photon latency was found** (two searches). Available evidence is practitioner testing and estimates; one vendor blog's "40-60 ms on 60 Hz" figure is unverified and not cited as fact.
- Unreal Engine 5: raw input behaviour, licensing terms (royalty threshold), and iteration characteristics not sourced this session.
- Godot: no source retrieved on swap-chain/flip-model details, max-frame-latency controls, or physics-interpolation interplay; starred items in the table are background knowledge.
- Bevy/winit raw `DeviceEvent` behaviour and SDL3 event timestamp resolution: not sourced.
- Babylon.js-specific information: none retrieved.

---

## 6. Game-style differences: tactical shooters vs COD/Battlefield-style vs movement/hero shooters

### Takeaway
Tactical shooters (CS2, Valorant, Siege) are dominated by pre-aimed, first-shot/headshot precision against targets that must stop to shoot, with fixed or narrow FOV; COD/Battlefield have short but multi-bullet TTKs (about 150-320 ms in BO7 at 150 HP; about 200-300 ms close-range in BF6), fast sprint/slide/jump movement, wide adjustable FOV (pros/guides cluster at 100-120 in COD, 90-110 in BF6), ADS-centric gunplay, visual clutter and documented target-visibility problems; Apex/Overwatch/The Finals have long TTKs (150-350 HP pools) where sustained tracking dominates. Hard numbers for hitbox dimensions and several speeds could not be verified from primary sources.

### Cited Findings

**CS2**
- Max run speed 250 units/s with knife/pistol; AK-47 215 units/s [C/S]. 250 u/s is about 4.76 m/s at 0.01905 m/unit (forum conversion). — [ProTierLab](https://protierlab.com/counter-strafe-trainer/); [vlr.gg thread](https://vlr.gg/post/4240306)
- Must counter-strafe to regain accuracy; fixed, learnable spray patterns (e.g. AK-47). [S] — [ForgeGuides](https://forgeguides.com/guides/counter-strike-2-vs-valorant-tactical-shooter-comparison-2026/)
- CS2 head hitboxes reported about 4-20% larger than CS:GO depending on agent model (community analysis; no absolute dimensions). [S] — [Fragster](https://www.fragster.com/changes-in-the-counter-strike-2-hitbox/)
- Sub-tick shot timestamps (see section 4). [S] — [BoostPirate](https://boostpirate.com/guides/cs2-subtick-explained)

**Valorant**
- Horizontal FOV locked at 103 for all players. [S] — [NovusTools guide](https://novustools.pages.dev/gamer-sens/guides/valorant-vs-cs2/)
- Run speed: sources conflict - 6.75 m/s (knife; one source says for every agent) vs "6.0 m/s (5.4 m/s rifle)". [C/S] — [vlr.gg thread](https://vlr.gg/post/4240306); [aimfinder guide](https://aimfinder.pro/guides/valorant-movement-and-tracking)
- One-shot headshot kills give very low TTK; stopping is near-instant; spray becomes random spread/bloom rather than a fixed pattern. [S] — [ForgeGuides](https://forgeguides.com/guides/counter-strike-2-vs-valorant-tactical-shooter-comparison-2026/); [aimfinder guide](https://aimfinder.pro/guides/valorant-movement-and-tracking)
- Voltaic builds target-switching benchmarks around 103 hFOV (Valorant/Overwatch-style default). [P] — [Voltaic S5](https://app.voltaic.gg/blog/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/)

**Rainbow Six Siege**
- FOV slider 60-90 and it is **vertical** FOV (90 vertical is far wider than 90 horizontal: 105 horizontal equals 73 vertical at 16:9); optic modifier applies on top while ADS; most pros at the max 90; only 4 of ~300 surveyed pros on default 60; console locked at 60. [P]/[S] — [Ubisoft dev post](https://www.ubisoft.com/en-us/game/rainbow-six/siege/news-updates/6kY6b5JByBY3P6vQWWinla/fov-and-input-sensitivity); [Esports Tales](https://www.esportstales.com/rainbow-six-siege/the-best-fov-field-of-view)

**Apex Legends**
- Walk 5.07 m/s; sprint 7.59 m/s; crouch-walk 2.34 m/s; holding a weapon -13%; super-glide launch 10.3 m/s; ability boosts +30-40%; tap-strafing is M&K only. [C, wiki] — [Apex Legends Wiki: Movement](https://apexlegends.wiki.gg/wiki/Movement)
- Legends have visibly different hitbox sizes at equal health/speed (Wraith vs Mirage/Gibraltar comparison). [S] — [PC Gamer](https://pcgamer.com/apex-legends-hitboxes)
- Aim assist modifier reported as 0.6 on console and 0.4 for controller on PC (date of source unclear; later nerfs not confirmed). [S] — [SI Esports](https://www.si.com/esports/apex-legends/mouse-keyboard-vs-controller-in-apex-legends)

**Overwatch 2**
- Standard movement 5.5 m/s for most DPS/supports (4.5 m/s cited for most tanks); no universal sprint. [S] — [Overwatch2Hub](https://www.overwatch2hub.com/can-you-run-in-overwatch-2)
- Season 9 (2024): most 200 HP heroes raised to 250 HP (some 250 -> 300) and projectile/hit sizes enlarged - i.e. longer TTK, more forgiving hits, more sustained tracking. [S]/[C] — [Charlie INTEL](https://www.charlieintel.com/overwatch-2/overwatch-2-season-9-all-hero-changes-300458/); [Blizzard forum](https://us.forums.blizzard.com/en/overwatch/t/hp-and-hitbox-increase-criticisms/917780)

**The Finals**
- Health: Light 150, Medium 250, Heavy 350 (regen after 7/9/10 s); devs have said the Light-Heavy spread is "probably a little too wide". [C, wiki]/[P] — [The Finals Wiki: Light](https://thefinals.wiki/wiki/Light); [Embark patch notes "Respec Order"](https://www.reachthefinals.com/patchnotes/respec-order)

**Call of Duty (Black Ops 6/7, Warzone)**
- BO7 multiplayer baseline health 150 HP (best-supported figure). Close-range AR TTKs: FG42 193 ms, AK-27 264 ms, M15 Mod 0 312 ms (M15 holds ~315 ms to 46 m); rough guide ~300-400 ms for ARs; BO6 close-range SMG averages around 225 ms. Treyarch said BO7 TTK would be similar to BO6. Values shift with seasonal balance. [S, data sites] — [CODMunity BO7 TTK](https://codmunity.gg/ttk/bo7); [PC Gamer BO7 meta](https://www.pcgamer.com/games/call-of-duty/black-ops-7-meta-guns/); [WZStats BO6](https://wzstats.gg/bo6/meta/close-range-meta)
- BO7 movement: faster baseline sprint; wall jumps chainable up to three times; reviewers describe TTK that "often kills you before you see the shooter". [S] — [GamesBeat review](https://gamesbeat.com/call-of-duty-black-ops-7-vs-battlefield-6-gamesbeats-multiplayer-review/)
- FOV: slider up to 120; guides recommend 100-120 (commonly 105-110); "ADS Field of View: Affected" keeps the wide FOV while aiming, "Independent" zooms on ADS; console got the FOV slider with Warzone 2.0. Suggested mouse ADS multipliers 0.80-1.00. [S] — [setup.gg Warzone FOV 2026](https://www.setup.gg/game/warzone/best-fov/); [Sportskeeda](https://sportskeeda.com/call-of-duty-game/what-best-fov-settings-warzone-2-season-4-reloaded); [ONE Esports](https://www.oneesports.gg/call-of-duty/best-warzone-settings-bo6-guide/)
- Aim assist: Treyarch said BO6 controller vs M&K win rate was "damn near fifty-fifty"; BO7 beta data showed controller winning slightly more at close range and M&K slightly more at long range; at BO7 launch aim-assist strength was nerfed considerably (slight long-range buff), with Raven planning parity changes for Warzone. [P via press] — [GamesRadar](https://www.gamesradar.com/games/call-of-duty/treyarch-admits-black-ops-7-controller-players-are-winning-slightly-more-in-close-range-thanks-to-aim-assist-says-its-reworking-it-while-raven-eyes-similar-changes-for-warzone/); [Windows Central](https://www.windowscentral.com/gaming/call-of-duty-black-ops-7-and-warzone-just-made-some-big-aim-assist-nerfs-at-launch-here-are-the-changes-and-why-im-a-fan); [Express Tribune](https://tribune.com.pk/story/2569050/black-ops-7-devs-explain-why-aim-assist-feels-more-accurate-than-players-think)
- Visibility: Warzone's Roze "Rook" skin (all-black) was near-invisible in dark areas, widely called pay-to-win, and was adjusted twice by Raven (Season 3 and Season 4, 2021); players later reported the nerf seemingly undone and renewed problems on darker Rebirth Island lighting. The Gaia ("Groot") skin was temporarily removed from the game for visibility issues. [S] — [Kotaku](https://kotaku.com/call-of-duty-warzone-skin-had-to-be-nerfed-twice-1847148667); [Dexerto](https://www.dexerto.com/call-of-duty/warzone-players-baffled-as-roze-skin-nerf-apparently-undone-by-season-6-update-1688124/); [Charlie INTEL](https://charlieintel.com/warzones-frustrating-roze-skin-causing-major-visibility-problems-on-rebirth-reinforced/169139/); [Sportskeeda (Groot)](https://sportskeeda.com/call-of-duty-game/is-groot-skin-still-available-play-warzone-modern-warfare-3)

**Battlefield 6**
- EA's gunplay post: close-quarters TTK benchmark about 200-300 ms for automatic primaries; tuning levers include recoil, bullet deviation (spread), muzzle velocity (projectile ballistics) and body-part multipliers. [P] — [EA: Battlefield Combat - Gunplay](https://www.ea.com/games/battlefield/battlefield-6/news/bf-combat-gunplay)
- Movement speed was reduced after feedback, with penalties for jump spam; longer effective TTK than BO7 per reviewers ("a bit of time to challenge a shooter"). [S] — [GamesBeat](https://gamesbeat.com/call-of-duty-black-ops-7-vs-battlefield-6-gamesbeats-multiplayer-review/)
- FOV: guides suggest 90+ with competitive players at 90-110 on PC; higher FOV reduces visual recoil. [S] — [Boostroom](https://boostroom.com/blog/battlefield-6-best-settings-aim-fov-sensitivity-performance-pc-console); [fovcalculatorpro](https://fovcalculatorpro.com/games/battlefield-fov/)
- Beta recoil comparisons raised concern that controller players have an advantage. [S] — [Notebookcheck](https://www.notebookcheck.net/Recoil-comparison-in-Battlefield-6-beta-adds-to-concerns-that-controller-players-have-an-advantage.1089323.0.html)

### Inferences
- Skill-profile contrast (synthesis):
  - *Tactical (CS2/Valorant/Siege)*: crosshair placement, micro-flicks to head-sized targets, first-shot timing after counter-strafe, short-burst/spray control (pattern in CS2, bloom reset in Valorant), holding angles; target usually appears at a predictable location with high contrast. Voltaic "static/precise clicking" maps well.
  - *COD/Battlefield*: must first **detect** the target (clutter, lighting, skins, smoke, wide FOV shrinking targets), then ADS-snap and **track for roughly 200-400 ms** through 4-6+ bullets on a target that is sprinting/sliding/jumping, with recoil compensation; then re-centre for the next target. This is a detection + reactive-tracking + recoil task, plus projectile lead at Battlefield ranges. Standard benchmark taxonomies do not include detection.
  - *Apex/OW2/The Finals*: 1-2+ second engagements, long smooth and reactive tracking against strafing/airborne targets; target switching.
- Illustrative angular geometry (my arithmetic; assumed sizes, not sourced): a ~0.25 m-wide head subtends about 1.4 deg at 10 m, 0.72 deg at 20 m, 0.29 deg at 50 m; a ~0.5 m-wide torso about 2.9 deg, 1.4 deg, 0.57 deg. A target strafing at 5 m/s perpendicular moves about 28.6 deg/s at 10 m, 14.3 deg/s at 20 m, 5.7 deg/s at 50 m; a 7.6 m/s Apex sprint gives about 43 deg/s at 10 m. On-screen size also scales with FOV: at fixed resolution, going from 103 to 120 horizontal FOV shrinks central targets by roughly tan(51.5 deg)/tan(60 deg) = 0.73x. Scenario files should therefore specify targets in *world metres + distance + game FOV*, not in screen pixels.
- Aim assist relevance to M&K players: controller parity (about 50/50 in COD by the developer's own statement) means M&K players face opponents with strong close-range tracking; M&K's relative edge is at range. Training emphasis for M&K in COD: close-range reactive tracking and fast ADS acquisition.
- FOV must be handled per game: Siege is vertical-FOV, Valorant fixed 103 horizontal, COD configurable with ADS "Affected/Independent" - the trainer needs explicit FOV-basis conversion and ADS FOV + sensitivity-multiplier modelling.

### Gaps
- **Hitbox dimensions**: no absolute head/body sizes verified for any title.
- **Engagement-distance distributions** per game: none found.
- CS2 FOV (background: fixed 90 on a 4:3 basis, about 106 horizontal at 16:9), Apex FOV range (background: 70-110), Overwatch FOV max (background: 103), COD default FOV (background: 80), Valorant weapon speeds from a primary source, Siege operator speeds/one-shot-headshot rule: **unverified, uncited**.
- Warzone health/armor (background: 150 base + up to 150 armor) and Warzone-specific TTK: not retrieved.
- BO6/BO7 and BF6 visibility complaints specifically (smoke, muzzle flash, lighting): searches returned only the older Warzone skin controversies.
- Recoil model specifics (per-weapon pattern vs random components) for COD/BF6/Apex: only qualitative info.
- ADS sensitivity formulae (e.g. monitor-distance coefficient) per game: not sourced.
- Share of PC players on controller: no data found.

---

## 7. What a minimal, high-quality v1 looks like, and major risks

### Takeaway
A credible v1 is a small native-feeling Windows app whose value is in *correctness and data* rather than content volume: verified 1:1 sensitivity/FOV for 2-3 target games, raw timestamped input with click-time hit resolution, low-latency presentation, a handful of data-defined scenarios spanning the sub-skill taxonomy plus one detection-in-clutter scenario, and append-only telemetry analysed offline (Python/DuckDB) with an LLM-written session summary. The main risks are unmeasured latency/input bugs (especially high-polling mice), scope creep into realistic art, and the absence of evidence that any trainer design transfers to in-game results.

### Cited Findings (supporting facts; the v1 design itself is inference)
- Lower system latency materially changes aim scores, most for skilled players and hard tasks -> latency must be measured and kept comparable between sessions or telemetry trends are confounded. — [NVIDIA dev blog](https://developer.nvidia.com/blog/improving-player-performance-with-low-latency-as-evident-from-fps-aim-trainer-experiments/)
- High-polling-rate mice can collapse frame rate in engines/apps with naive Windows message handling (Godot <4.7.2; PH3's game). — [Godot blog](https://godotengine.org/article/fixing-high-polling-rate-mice-on-windows/); [PH3 blog](https://ph3at.github.io/posts/Windows-Input/)
- FPSci demonstrates the config-driven experiment + SQLite frame-wise log architecture and hardware click-to-photon validation. — [GitHub NVlabs/FPSci](https://github.com/NVlabs/FPSci)
- Browsers lack presentation queue-depth control; tested mitigation flags gave no measurable gain on Windows Chrome. — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)
- Windowed presentation costs about one frame unless fullscreen-unoccluded or MPO; use waitable swap chain / max frame latency 1; verify with PresentMon. — [James Darpinian](https://james.darpinian.com/blog/latency-platform-considerations/)
- Voltaic's 3x3 taxonomy and its measurement-validity practices (reduce randomness, fixed FOV, fixed durations). — [Voltaic S5](https://app.voltaic.gg/blog/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/)
- No controlled evidence of aim-trainer-to-game transfer found. — [PMC pilot study (reliability only)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10925653/)
- Commercial trainers gate adaptive difficulty, coaching and insight features behind about $10/month. — [Steam: Aimlabs](https://store.steampowered.com/app/714010/Aimlabs/)

### Inferences
**Suggested v1 scope**
1. *Input core*: Raw Input (buffered), per-report QPC timestamps, no accumulation/smoothing, double-precision yaw/pitch; sensitivity profiles expressed as "game + in-game sens + DPI" -> deg/count; unit test: N counts produce exactly the expected rotation (cm/360 check against the real game).
2. *View*: per-game FOV model (horizontal/vertical basis, aspect), hipfire + one ADS state (FOV + sens multiplier + ADS time).
3. *Presentation*: fullscreen flip-model, VRR/tearing allowed, frame cap option; log frame times; PresentMon check documented.
4. *Hit resolution*: ray cast at the click's timestamped view angle (sub-frame), hitscan first; projectile later.
5. *Scenarios as data* (JSON/TOML): target shape (sphere + capsule/humanoid), size in metres, distance, motion model (static, strafe with accel/direction-change distribution, jump/slide), spawn rule, health/TTK model (shots-to-kill + fire rate), optional recoil model, visual-difficulty parameters (target/background contrast, clutter density, occlusion). Start with about 6-8: static click, dynamic click, precise track, reactive track, speed switch, "COD-style" track-through-TTK on a strafing humanoid, "tactical" pre-aim/peek micro-flick, and one detection-in-clutter task.
6. *Telemetry*: append-only NDJSON/Parquet or SQLite: raw mouse events, per-frame view angles/target states, shots, hits, config snapshot (sens, FOV, refresh, frame time stats). Derived metrics offline: time-to-first-shot, flick overshoot/undershoot, time-on-target %, tracking error (deg), reaction to direction change, detection time.
7. *Coaching*: Python script aggregates the session in DuckDB and sends a compact summary (not raw data) to an LLM API for a narrative; keep API keys out of the game binary.
8. *Distribution*: zipped build + shared scenario folder; no accounts/backend.

**Major risks**
- *Fidelity bugs that silently invalidate training*: wrong yaw constant/FOV basis, hidden smoothing/accumulation, pointer acceleration leaking in, frame-quantised hits. Mitigation: automated rotation tests + side-by-side cm/360 checks in each target game.
- *Latency unknowns*: engine/compositor adds frames; differs across friends' PCs. Mitigation: measure; record environment in telemetry.
- *High-polling mice*: engine-version dependent (Godot needs 4.7.2+).
- *Scope creep into realism*: realistic cluttered maps and camouflaged characters are art-heavy; prefer procedurally parameterised clutter/contrast and a few free assets.
- *Validity*: no evidence that trainer gains transfer; benchmark-style score chasing can substitute for in-game improvement. Mitigation: track in-game outcomes alongside trainer metrics; rotate/parameter-randomise scenarios to limit scenario-specific learning.
- *Platform choice lock-in*: browser prototype is quick but may cap achievable latency; binary-heavy engines reduce AI-assistant leverage.
- *Licensing*: FPSci code is CC BY-NC-SA (copyleft, non-commercial) - fine as reference, constraining as a base; LibreAim is GPLv3.
- *Game drift*: TTK, movement, FOV limits and aim assist change every season (BO7 and BF6 values above are 2025-2026 snapshots) - keep game profiles as editable data.

### Gaps
- No source evaluates "how good an AI coding assistant is" per engine; the iteration-speed ratings are judgement.
- No retrieved data on what telemetry rate is sufficient (per-report vs per-frame) for the derived metrics; FPSci uses frame-wise logging.
- LLM API specifics (models, pricing) intentionally not researched here.
