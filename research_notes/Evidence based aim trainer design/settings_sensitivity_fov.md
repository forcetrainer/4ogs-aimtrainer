# Sensitivity, DPI, FOV, Acceleration and Latency: Evidence for Per-Player Settings Discovery

Labels used throughout: **[PR]** peer-reviewed or archival academic paper (read in full text unless noted), **[PP]** preprint / workshop paper, **[COMM]** community heuristic, tool site or forum, **[DESC]** descriptive pro-settings data (not causal), **[MATH]** derivation from geometry (no empirical claim), **[SNIPPET]** known only from a search summary or abstract, full text not read.

Research date: 2026-11-11. Several primary pages (mouse-sensitivity.com FAQ, Liquipedia, prosettings.net) returned HTTP 403 or were unreachable, so some community facts rest on secondary sources; this is flagged where it applies.

---

## 1. HCI research on control-display gain: plateau or sharp optimum?

### Takeaway
The best pointing study (Casiez et al. 2008) found an L-shaped curve, not a sharp optimum: low gain hurts a lot (limb-speed limit, then clutching), while high gain costs almost nothing until targets become too small for the hand's roughly 0.2 mm precision. The usable range is bounded below by reach (largest distance / about 30 cm of pad travel) and above by hand precision and device quantization.

### Cited Findings
- [PR] Low CD gain had a "pronounced negative effect" on both a desktop and a very large display; high gain mainly increased overshooting. Movement time improved 11% from constant-gain level 1 to level 2, and no other constant-gain or pointer-acceleration levels differed significantly from each other (a plateau). — [Casiez, Vogel, Balakrishnan, Cockburn 2008, HCI 23(3)](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] Cause of the low-gain penalty: a maximum limb speed of about 1.5 m/s (97th percentile 1536 mm/s, max logged 2441 mm/s) raised mean times 10 to 14% at very low gain; on the large display clutching dominated, with movement time up to 124% longer at 24% clutching time. Movements that included clutching did not follow Fitts' law. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] Participants preferred to enlarge their mouse operating range rather than clutch; the largest operating range observed was 36 to 37 cm, and the authors recommend assuming no more than 30 cm. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] A 3-person pilot with gains 8 to 50 gave an "almost an L-shape" profile: time stayed constant above gain 16, with only a slight increase for very small targets. Authors' summary: gain has little effect "until human limits of speed and accuracy are approached." — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] Usable-range formulas: CDmin = Dmax / ORmax (largest target distance over maximum operating range). CDmax = min(CDq_max, CDl_max) where CDq_max = mouse DPI / screen DPI (quantization) and CDl_max = Wmin / hand resolution, with hand resolution about 0.2 mm (accuracy problems seen with 2 mm targets at gain 12 on a 1600 DPI mouse). Worked example: 400 DPI mouse, 100 DPI display, Dmax 360 mm, Wmin 2 mm, 250 mm range gives CDmin 1.4, CDmax 4. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] Pointer acceleration vs constant gain on a desktop display: 3.3% faster overall (1.16 s vs 1.20 s, marginal, p = .065), 5.6% faster for 2 mm targets, 3.5% faster at 360 mm distances; but acceleration increased overshooting and kept about 1% clutching where high constant gain had none. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PP] AutoGain (Lee, Nancel, Kim, Oulasvirta) individualizes a gain function by minimizing per-submovement undershoot/overshoot; from scratch it reached performance comparable to commercial functions in under half an hour of active use, and a one-month study showed improvement over participants' defaults. Listed only as an arXiv preprint (2016, revised 2020); tested on desktop pointing, not FPS. — [arXiv 1611.08154](https://arxiv.org/abs/1611.08154v2)
- [PR] FPS view-rotation sensitivity (degrees per mm) is not directly convertible to pointer CD gain, so pointer results cannot be imported numerically. — [Boudaoud, Spjut, Kim, IEEE Trans. Games 2023 (abstract)](https://research.nvidia.com/index.php/publication/2023-07_mouse-sensitivity-first-person-targeting-tasks)

### Inferences
- The FPS analogue of Casiez's bounds: the low-sensitivity bound is set by pad space and arm speed (largest turn you must make in one swipe divided by about 30 cm of travel), and the high-sensitivity bound by hand precision. With 0.2 mm hand resolution, 30 cm/360 (1.2 deg/mm) gives about 0.24 degrees of smallest reliable step; 10 cm/360 gives about 0.72 degrees. A trainer can compute both bounds per player from pad width and the smallest target angular size they need to hit.
- "Wrist vs arm" follows from the same bounds: high sensitivity confines motion to small-amplitude joints (precision-limited), low sensitivity forces large-amplitude arm motion (speed and clutch limited). Casiez could not complete its limb-use analysis in the clutch-heavy experiment, so this is an inference, not a measured result.

### Gaps
- No pointing study was found that measures optimal gain as a function of the limb used (wrist vs forearm) with modern low-friction pads.
- Clutching cost in FPS (lift-and-reset during a fight) has not been measured; Boudaoud et al. explicitly kept travel to about 100 mm to avoid it.

---

## 2. FPS-specific sensitivity research and pro distributions

### Takeaway
The only controlled FPS study (Boudaoud et al., NVIDIA) found a broad plateau of 20 to 80 cm/360 with clear degradation outside it, driven by a speed-precision trade-off. Pro medians in tactical shooters sit inside that plateau at roughly 50 to 55 cm/360; pros in faster games use higher sensitivity.

### Cited Findings
- [PR/PP] Design: 13 analyzed experienced FPS players (10 to 20+ h/week), static targets 0.57 to 9.15 degrees wide at 7 to 25 degrees eccentricity (ID 0.83 to 5.5 bits), FOV 103, 240 Hz, six sensitivities: 160, 80, 40, 20, 10, 5 cm/360 (0.225 to 7.2 deg/mm), plus each player's preferred setting first and last; 500 trials per session, first half discarded as adaptation. — [Boudaoud, Spjut, Kim, arXiv 2203.12050 / IEEE CoG 2022](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Result: completion time differed across sensitivities (F(5,19955) = 111.72, p < .0001), but adjacent levels inside 0.45 to 1.8 deg/mm (20 to 80 cm/360) did not differ; variance of completion time was also lowest there. Hit rate differed only at 5 cm/360 (worst). No effect sizes or percentage differences are reported in the text. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Mechanism from submovement analysis (7 Hz low-pass, start 8 deg/s, end 4 deg/s, minimum 80 ms): low sensitivity slowed the first (ballistic) submovement; high sensitivity increased the number of corrective submovements. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Most subjects performed better at one of the preset sensitivities than at their own preferred setting, although preferences mostly fell inside the plateau; the two players who preferred settings above it were among the weakest performers. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Authors' advice: lower sensitivity for small or distant (high-ID) targets, higher for large or near ones; set it high enough that physical motion does not limit turning, low enough to avoid frequent over/undershoot. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [DESC] Pro sensitivity varies up to 8x within one title and up to 12x across titles (prosettings data, Sept 2020). — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [DESC] CS2, 816 active pros (data as of 9 Nov 2026): eDPI median 800, mean 855, P25 704, P75 960, range 276 to 4500; 55% at or below 800, 6% above 1200. By role: riflers median 800 (n = 525), AWPers median 859 (n = 144). DPI: 47% use 400, 46% use 800, 5% use 1600. Source is published configs, not observed play. — [csdb.gg pro sensitivity data](https://csdb.gg/data/pro-sensitivity/)
- [DESC] Valorant: third-party sites citing a prosettings April 2026 snapshot of 623 pros give average eDPI 267, median 240; another 668-player page gives mean 248, median 231. These are low-authority SEO pages and should be treated as approximate. — [setup.gg Valorant sens](https://www.setup.gg/game/valorant/best-sens/); [valorantbpc meta page](https://valorantbpc.pages.dev/pro-players/meta/)
- [DESC, weak] Apex Legends: one unverified aggregator lists 24 pros with median eDPI 1200 and median 34.6 cm/360. — [toolmate pro-settings stats](https://toolmate-9bo.pages.dev/pro-settings/stats)
- [DESC, weak, undated] Overwatch: a forum post claims average pro eDPI of roughly 5000. — [Blizzard forum thread](https://us.forums.blizzard.com/en/overwatch/t/sensitivity-settings-of-overwatch-pros/355820)
- [PR, SNIPPET] "Secrets of Gosu" (Park, Lee, Ham, Choi, Kim, Lee; CHI 2021) tests community conjectures about pro FPS players' physical skills against measurement. — [DGIST record](https://dgist.elsevierpure.com/en/publications/secrets-of-gosu-understanding-physical-combat-skills-of-professio/)

### Inferences
- [MATH] Converting the above with cm/360 = 914.4 / (eDPI x yaw): CS2 median 800 eDPI = 52.0 cm/360 (interquartile 43.3 to 59.0 cm; full range 9.2 to 150.6 cm). Valorant median 240 eDPI = 54.4 cm/360 (mean 267 = 48.9 cm). Apex 1200 eDPI = 34.6 cm/360. Overwatch 5000 eDPI = 27.7 cm/360.
- Tactical-shooter pros cluster in the middle of the Boudaoud plateau; Apex and Overwatch pros sit nearer its fast end. A plausible reason, consistent with Boudaoud's ID argument but not tested, is task mix: tactical shooters reward small pre-aimed corrections on small head targets (high ID, low sensitivity), while movement shooters require large rapid turns and tracking of fast, close targets (low ID, large amplitude).
- AWPers running slightly higher sensitivity than riflers is descriptive; it is consistent with larger flick amplitudes, but role selection effects are uncontrolled.
- A trainer should present "20 to 80 cm/360" as a search space, not a recommendation, and show the player's game-specific pro interquartile range only as context.

### Gaps
- prosettings.net itself could not be fetched; no reliable 2026 medians were found for Apex, Overwatch 2, COD/Warzone or Battlefield. The Apex and Overwatch figures above are weak.
- The 2023 IEEE Transactions on Games extension of Boudaoud et al. (updated recommendations) was not read in full.
- Aim Lab's sensitivity finder: no documentation of its algorithm was found.
- "Secrets of Gosu" full text (PDF over 10 MB) could not be fetched, so its specific findings on sensitivity and grip are not reported here.
- No FPS sensitivity study covers moving targets/tracking, 180 degree turns, scoped aiming, or recoil control.

---

## 3. Adaptation to changed sensitivity; "muscle memory" and PSA-style finders

### Takeaway
Evidence does not support "never change your sens": in the one FPS study, players tested at six sensitivities over about 80 minutes showed no significant loss at their preferred setting afterward, and most performed better at a preset than at their habitual setting. Motor-learning research indicates gain changes are learned quickly and generalize broadly, but there is no FPS study of long-term switching or mixed-sensitivity practice.

### Cited Findings
- [PR/PP] After cycling through six sensitivities spanning 32x, no significant degradation appeared between the first and last sessions at the preferred sensitivity (about half got slower, nearly as many faster; changes under 15% of mean time). The authors conclude muscle-memory effects "were not strongly detected" and encourage experimentation. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Within a session at a new sensitivity there was a visible learning effect; the authors discarded the first 250 of 500 trials (about 5 minutes) as adaptation. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR] For latency (not sensitivity) conditions, skilled players reported that one adaptation session of 6 to 15 minutes (220 trials) was sufficient to adapt and form a strategy before data collection. — [Spjut et al. 2019, SIGGRAPH Asia Technical Briefs](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- [PR, SNIPPET] Adaptation to a single visuomotor gain in reaching generalizes broadly across movement directions, unlike rotation adaptation. — [J Neurophysiol 2010 (PMC2888232)](https://pmc.ncbi.nlm.nih.gov/articles/PMC2888232)
- [PP, SNIPPET] A 2025 bioRxiv reaching study uses mouse-gain change as its motivating example, applying 1.3x and 0.7x gains in a 432-trial, 25-minute design. — [bioRxiv 2025.06.10.658797](https://www.biorxiv.org/content/10.1101/2025.06.10.658797.full.pdf)
- [PR/PP, SNIPPET] Contextual interference in adaptation: random (interleaved) schedules slow adaptation but improve retention relative to blocked schedules in visuomotor rotation; interleaving lets people hold opposing perturbations that blocked practice cannot. These are rotation and force-field studies, not gain studies. — [PMC9928522](https://pmc.ncbi.nlm.nih.gov/articles/PMC9928522); [Osu et al. 2024 preprint](https://bicr.atr.jp/~kawato/Ppdf/2024.07.15.603502v1.full.pdf)
- [COMM] PSA ("Perfect Sensitivity Approximation") is described as an iterative narrowing: each round try a lower and a higher value, keep the one that "feels" more controllable. Users report different results on repeated runs, and that warm-up state shifts the outcome; a critique notes it ranks by comfort and is open to bias. — [PSA calculator description](https://www.hunted.space/dashboard/psa-calculator-2); [mouse-sensitivity.com forum](https://mouse-sensitivity.com/forums/topic/6013-need-a-sensitivity-finding-method-that-isnt-psa); [anima.nz critique](https://anima.nz/peripheral-review-problem/)

### Inferences
- A sensitivity change inside the plateau costs minutes, not weeks, of measurable performance in a simple flick task. The first few hundred trials at a new setting are contaminated by adaptation and must be excluded or modelled.
- PSA-style methods fail on three counts a trainer can fix: they use feel instead of measured outcomes, they compare each candidate while the player is still adapting, and bisection on a flat, noisy plateau cannot converge reproducibly.
- Because the plateau is flat, the honest output of any finder is a range with uncertainty, plus the direction of the player's bias (see section 8), rather than a single value to two decimals.

### Gaps
- No study of long-term retention or of deliberate sensitivity randomization for FPS aiming was found. Whether variable-sensitivity practice helps is untested for this task; the contextual-interference evidence is from rotations and force fields.
- No peer-reviewed evaluation of PSA or of any commercial sensitivity finder was found.
- The motor-adaptation items above come from search summaries, not full-text reads; exact trial counts to asymptote for gain changes were not retrieved.

---

## 4. Mouse acceleration

### Takeaway
There is no controlled FPS evidence that acceleration helps or hurts. Pointing research shows a small speed benefit (about 3 to 6%) for acceleration with small or distant targets, alongside more overshoot. Community practice has shifted from "always off" to "Windows acceleration off, optional custom curve via Raw Accel."

### Cited Findings
- [PR] Pointer acceleration 3.3% faster than constant gain overall on a desktop display (marginal), 5.6% faster for small targets, with more overshoot. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR/PP] Nonlinear sensitivity was explicitly not tested in the NVIDIA FPS study; the authors note competitive players generally avoid it. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [DESC] Pro CS2 config datasets do not model acceleration or Windows pointer speed and assume defaults. — [csdb.gg](https://csdb.gg/data/pro-sensitivity/)
- [COMM] The acceleration the community advises disabling is specifically Windows "Enhance pointer precision." — [xbitlabs guide](https://www.xbitlabs.com/what-is-mouse-acceleration/)
- [COMM] Raw Accel's own FAQ says it does not make you better, it makes you more comfortable, and that not everyone improves with it. Guides describe opinion as split. — [Raw Accel FAQ](https://happygolucky.notion.site/Raw-Accel-FAQ-e84cb5ffdce44d5e8d1c8a5132ec8172); [ggrecon guide](https://ggrecon.com/guides/valorant-raw-accel/)
- [PP] AutoGain shows velocity-dependent gain functions can be individually optimized from submovement error in desktop pointing. — [arXiv 1611.08154](https://arxiv.org/abs/1611.08154v2)

### Inferences
- A velocity-dependent curve is a principled way to widen the usable range: low gain at low speed for precision, high gain at high speed for large turns. This is exactly the two bounds in section 1. The cost is that distance travelled no longer maps one-to-one to angle, which may penalize open-loop flicks; that trade-off is untested in FPS.
- A trainer should measure and store the player's curve (or assume linear) and should not recommend acceleration by default. Offering it as an experiment for players whose data show both an undershoot problem on large turns and an overshoot problem on small targets is defensible.

### Gaps
- No peer-reviewed or controlled study of custom acceleration curves in FPS aiming was found. Claims that named pros use Raw Accel were not verifiable.

---

## 5. FOV: perception, performance, and the conversion math

### Takeaway
FOV changes the on-screen size and on-screen speed of everything by the focal-length ratio tan(FOV/2); the geometry is exact, but empirical research on FOV and mouse-aiming performance is essentially absent. Sensitivity matching across FOVs is a choice between methods that each preserve one thing, and community practice favors focal-length (0% monitor distance) scaling for precision aiming.

### Cited Findings
- [COMM, formulas standard] cm/360 = (360 x 2.54) / (DPI x in-game sensitivity x yaw). Example: 800 DPI, Valorant 0.5 gives 32.66 cm. Cross-game: sens_B = sens_A x yaw_A / yaw_B. — [west-games cm/360 calculator](https://west-games.com/cm-per-360-calculator/); [csdb.gg converter](https://csdb.gg/sensitivity-converter/)
- [PR/PP] deg/mm = 36 / (cm/360). — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- Yaw constants (degrees per count at sensitivity 1):

| Game | Yaw | Verification |
|---|---|---|
| CS2 / CS:GO / Source | 0.022 | [csdb.gg](https://csdb.gg/sensitivity-converter/); reproduces Boudaoud Table 1 (20.78 cm at 800 DPI, sens 2.5) |
| Apex Legends | 0.022 | [csdb.gg](https://csdb.gg/sensitivity-converter/); reproduces Boudaoud Table 1 (10.39 cm at 800 DPI, sens 5) |
| Valorant | 0.07 | [csdb.gg](https://csdb.gg/sensitivity-converter/); [west-games](https://west-games.com/cm-per-360-calculator/); reproduces Boudaoud Table 1 (16.34 cm at 800 DPI, sens 1) |
| Overwatch 2 | 0.0066 | [csdb.gg](https://csdb.gg/sensitivity-converter/overwatch-2-to-cs2/); reproduces Boudaoud Table 1 (11.54 cm at 800 DPI, sens 15). One calculator page lists 0.022, which is inconsistent with that check. |
| Call of Duty (MW/Warzone) | 0.0066 | [csdb.gg](https://csdb.gg/sensitivity-converter/); [Recharge blog](https://www.recharge.com/blog/en-gb/mouse-sensitivity-converter-calculator-for-23-fps-games) |
| Fortnite | 0.005555 | [csdb.gg](https://csdb.gg/sensitivity-converter/); conflicting value 0.005715 on [west-games](https://west-games.com/cm-per-360-calculator/) |
| Rainbow Six Siege | 0.00572957795 | [csdb.gg](https://csdb.gg/sensitivity-converter/) only; conflicting 0.02 on west-games. Single-source. |

- FOV conversion: aspect = tan(H/2) / tan(V/2); H = 2 atan(tan(V/2) x w/h); V = 2 atan(tan(H/2) x h/w). Hor+ keeps vertical FOV fixed and widens horizontal with aspect ratio; it is the most common modern method. — [Wikipedia, Field of view in video games](https://en.wikipedia.org/wiki/Field_of_view_in_video_games)
- [COMM] 0% monitor distance match equals scaling sensitivity by the ratio of virtual focal lengths (zoom ratio); commonly used higher percentages (100%, 133%, 178% vertical) feel too fast at low zoom levels, while focal-length scaling can feel slow at high zoom. Forum contributors describe monitor-distance percentages as arbitrary. 100% vertical equals 56.25% horizontal on 16:9. — [mouse-sensitivity.com forum thread 8227](https://mouse-sensitivity.com/forums/topic/8227-yet-another-monitor-distance-formula-variant); [mouse-sensitivity.com FAQ (snippet)](https://www.mouse-sensitivity.com/forums/topic/4704-conversion-method-guide-and-other-faqs/)
- [COMM] CS zoom: the game's default scoped scaling is the FOV ratio (40/90 for AWP first zoom). The popular zoom_sensitivity_ratio 0.818933027 is the focal-length multiplier 0.36397 divided by 40/90. — [Reddit analysis, "How zoomed sensitivity works"](https://redlib.ssps.io/r/GlobalOffensive/comments/3vxkav/how_zoomed_sensitivity_works); [GosuGamers analysis](https://www.gosugamers.net/counterstrike/news/51346-analysis-is-0-81893-really-the-best-zoom-sensitivity)
- [COMM] PC games typically use 90 to 100 degrees horizontal, consoles about 60; widening FOV increases perceived movement speed; narrow FOV on a near monitor can cause nausea. No formal studies cited. — [Wikipedia](https://en.wikipedia.org/wiki/Field_of_view_in_video_games)
- [PR, SNIPPET, adjacent] A VR visual-search study comparing about 65 and 32.5 degree FOV found target movement mattered more than FOV. — [Carleton VR22 FOV paper](https://www.csit.carleton.ca/~rteather/pdfs/VR22_FOV.pdf)
- [PR/PP] The NVIDIA sensitivity study ran at a single FOV (103) and did not vary it. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)

### Inferences
[MATH] The following derive from rectilinear projection and are exact for it:
- Pixels per radian at screen center = (W/2) / tan(H/2). A target's on-screen size and on-screen speed both scale with 1 / tan(FOV/2). Going from 90 to 110 horizontal shrinks center targets to tan(45)/tan(55) = 70% of their size; 103 to 120 gives 73%.
- Angle to a point at fraction p of the half-screen: a(p, FOV) = atan(p x tan(FOV/2)).
- Monitor distance match at fraction p between FOV1 (reference) and FOV2: sensitivity multiplier m(p) = atan(p tan(FOV2/2)) / atan(p tan(FOV1/2)), and cm/360_2 = cm/360_1 / m. Limits: p to 0 gives m = tan(FOV2/2) / tan(FOV1/2) (focal length, "0%"); p = 1 gives m = FOV2 / FOV1 (100% along that axis). Check: tan(20)/tan(45) = 0.36397 for 40 vs 90, matching the CS figure above.
- 360-distance matching sets m = 1 (same cm/360 at all FOVs).
- Hor+ examples: 90 at 4:3 = 73.74 vertical = 106.26 at 16:9. 103 at 16:9 = 70.53 vertical.
- Interpretation: focal-length scaling preserves the hand distance needed per on-screen pixel near the crosshair (micro-corrections and tracking feel the same); 360-distance preserves hand distance per world angle (turns and navigation feel the same); p > 0 matching preserves a flick to one particular screen eccentricity. No method preserves everything, and none has been empirically compared.
- Since Fitts' ID depends on D/W and FOV scales D and W on screen equally, FOV leaves on-screen ID unchanged but changes absolute pixel size, peripheral coverage and edge distortion. At fixed cm/360, higher FOV makes each target subtend fewer pixels while requiring the same hand movement, so visual precision falls while motor demand stays the same.
- For a trainer: store sensitivity as cm/360 at a stated FOV, convert scoped sensitivities with focal-length scaling by default, expose the monitor-distance percentage as an advanced option, and when importing game settings, reproduce both the game's FOV convention and its yaw.

### Gaps
- No controlled study of FOV versus mouse aiming performance (hit rate, time to kill, target detection) in desktop FPS was found, from NVIDIA or elsewhere. The "0% for tracking, higher for flicks" claim is community reasoning only.
- Per-game FOV conventions (for example Apex's FOV slider scale, COD's "affected/independent" ADS FOV, Battlefield's uniform soldier aiming coefficient) and per-game ADS multipliers were not verified; mouse-sensitivity.com and Liquipedia were inaccessible (HTTP 403). These need verification before implementing game presets.
- The R6 and Fortnite yaw constants have conflicting or single sources; games with percent sliders also change scale between versions.

---

## 6. Latency, refresh rate and implications for browser vs native

### Takeaway
End-to-end latency has a large, well-replicated effect on aiming; refresh rate above 60 Hz matters mostly because it lowers latency, with a small independent benefit for tracking. Latency benefits continue below 20 ms for some players. A trainer must measure and report its own latency, and a browser build needs raw (unaccelerated) pointer-lock input.

### Cited Findings
- [PR] 8 ranked players, 4 refresh rates (60/120/240/360 Hz) x 3 click-to-photon latencies (about 22 to 25, 52 to 58, 82 to 91 ms). Latency had a large effect on completion time for one-shot flicks (partial eta squared 0.88) and tracking (0.92). Refresh rate was not significant for flicks (p = .44) and modest for tracking (p = .018, partial eta squared 0.48). Authors: high refresh matters "largely because of the latency reduction it provides." — [Spjut et al. 2019](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- [PP] 12 ms vs 20 ms, 8 users x 400 trials each on a moving-target click task: median completion 1.348 s vs 1.530 s (182 ms difference from 8 ms of latency), Cohen's d = 0.319, significant over pooled trials; only 3 of 8 users were individually significant, and a comparison of per-user medians was not significant. — [Spjut, Boudaoud, Kim 2021, CHI EHPHCI workshop](https://arxiv.org/pdf/2105.10498)
- [PR, as cited] Ivkovic et al. (CHI 2015) found degradation across 23 to 243 ms of local latency, including at 41 ms, with apparent diminishing returns below about 50 ms; NVIDIA notes its lowest point was confounded by a V-Sync change and subjects had no adaptation time. — [Spjut et al. 2021](https://arxiv.org/pdf/2105.10498); [Spjut et al. 2019](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- [PR] Human sensorimotor delay for hand movements is about 150 to 200 ms; flicking is described as largely open-loop and tracking as closed-loop. — [Spjut et al. 2019](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- [PR] 44-person study, 7 to 500 f/s in a custom FPS: performance (score) rose sharply from 7 f/s and levelled out after about 90 f/s, while perceived smoothness kept improving through 500 f/s. A 2026 ACM TOMM journal extension exists. — [Tokey, Boudaoud, Kim, Spjut, Claypool, NOSSDAV 2025](https://web.cs.wpi.edu/~claypool/papers/fps-500-25/)
- [PR/PP] The NVIDIA low-latency rig: 240 Hz G-Sync display, wired Logitech G203, custom engine loop, achieving 12 ms click-to-photon as the lowest consistent figure. — [Spjut et al. 2021](https://arxiv.org/pdf/2105.10498)
- [Vendor doc] In browsers, `requestPointerLock({ unadjustedMovement: true })` disables OS pointer acceleration for mousemove deltas; the returned promise indicates success; as of the article (2020) only Chromium-based browsers supported it, with Windows having the most direct platform API. — [web.dev, Disable mouse acceleration](https://web.dev/articles/disable-mouse-acceleration); [MDN Pointer Lock API](https://developer.mozilla.org/en-US/docs/Web/API/Pointer_Lock_API)

### Inferences
- Practical thresholds: differences of about 30 ms are large and visible in small samples; 8 ms differences near the floor are detectable only with hundreds of trials and only for some players. A trainer adding even one or two frames of latency (compositor, V-Sync) relative to the target game will bias both scores and any sensitivity recommendation, because higher latency penalizes closed-loop corrections, which are more frequent at high sensitivity.
- Scores are only comparable across sessions if frame rate and latency are stable; log frame time distribution per session and flag sessions with degraded pacing (Boudaoud et al. excluded a subject for frame-rate degradation).
- Browser build: request unadjusted movement and verify the promise; fall back with a visible warning when it is refused, since OS acceleration silently invalidates cm/360. Native build: use raw input and an uncapped or low-latency present mode.

### Gaps
- No published measurement of browser (WebGL/WebGPU) click-to-photon latency versus native engines was found; the size of the browser penalty is unknown here and should be measured directly (for example with a photodiode or high-speed camera).
- Current (2026) browser support for `unadjustedMovement`, and behavior of `getCoalescedEvents()` / `pointerrawupdate` for sub-frame mouse sampling, were not confirmed by search; check current MDN compatibility tables.
- Exact Ivkovic et al. degradation percentages were not retrieved.

---

## 7. Mouse hardware factors

### Takeaway
Hardware evidence is thin. The peer-reviewed results that exist show small effects: sensor position is worth a few percent of throughput, and a small weight difference showed no measurable effect. Polling rate above 1000 Hz has no controlled performance evidence.

### Cited Findings
- [PR] Sensor position: a centered sensor is the best overall compromise; per-user calibration of sensor position should add about 4% throughput over center. — [Kim, Lee, van Gemert, Oulasvirta, CHI 2020](https://userinterfaces.aalto.fi/mouse_sensor_position)
- [PR, SNIPPET] Mouse weight: a Berkeley ergonomics study had 12 participants use six mice from 40 g to 140 g in Fitts and gaming tasks with EMG. Reported results were not retrieved. — [UC Berkeley COEH](https://www.coeh.berkeley.edu/node/1708)
- [COMM, measured reviews] 8000 Hz polling reports every 0.125 ms; reviewers estimate about 0.5 ms latency benefit over 1000 Hz in typical use, note it takes fast movement to saturate, and that stability above 2000 Hz depends on the system. — [TechPowerUp EVGA X17](https://techpowerup.com/review/evga-x17/6.html); [TechPowerUp Razer Viper 8K](https://techpowerup.com/review/razer-viper-8k/6.html)
- [PR] Device quantization bound: the maximum useful gain from resolution is mouse DPI / display DPI; a 1600 DPI mouse was not the limiting factor even at gain 12 (hand precision was). — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [DESC] 93% of CS2 pros use 400 or 800 DPI. — [csdb.gg](https://csdb.gg/data/pro-sensitivity/)

### Inferences
- [MATH] DPI only matters through quantization: the smallest view step is yaw x in-game sensitivity degrees per count. At a fixed cm/360, raising DPI and lowering in-game sensitivity makes steps finer. At 400 DPI and 52 cm/360 one count is 0.044 degrees, well below hand precision (about 0.2 mm = 0.14 degrees at that sensitivity), so pros' low DPI is habit, not a performance requirement.
- A 0.5 ms polling gain is far below the 8 ms difference that took 3200 trials to detect in the NVIDIA study, so polling rate above 1000 Hz is unlikely to be measurable in a trainer.

### Gaps
- A 2023 study reported in search summaries (16 professional Overwatch players, 80 g vs 87 g mice, no significant performance difference, pros preferred the lighter mouse) could not be tied to a verified primary URL.
- A paper titled "Influence of Mouse Grip Type on Flicking and Tracking Tasks Performance" and a CHI 2024 paper on wrist-aiming (search summary: pros showed a 20.2% higher wrist-aiming index than amateurs) surfaced but were not read; grip and wrist/arm findings are therefore unreported.
- No controlled studies were found on mousepad friction, mouse shape, or polling rate versus aiming performance.

---

## 8. Adaptive procedures for finding a player's sensitivity range

### Takeaway
No published, validated FPS sensitivity-finding procedure exists. The ingredients do: Casiez's reach/precision bounds, Boudaoud's protocol and submovement metrics, and AutoGain's use of per-submovement overshoot/undershoot as the optimization signal. The flat plateau means the method must be built around noise and adaptation control and should output a range.

### Cited Findings
- [PR/PP] Workable protocol precedent: 500 trials (about 10 minutes) per sensitivity, discard the first half, bracket with the preferred setting at start and end to detect drift, log-spaced sensitivities (factor of 2 steps), targets spanning ID 0.83 to 5.5 bits. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Diagnostic signals: first-submovement peak velocity falls at low sensitivity; submovement count rises at high sensitivity; completion-time variance is lowest in the optimal band. Segmentation parameters: 7 Hz 5th-order low-pass Butterworth, start 8 deg/s, end 4 deg/s, minimum 80 ms. — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PR/PP] Optimal sensitivity depends on target difficulty (higher for low-ID, lower for high-ID). — [Boudaoud et al.](https://ar5iv.labs.arxiv.org/html/2203.12050)
- [PP] AutoGain updates gain to minimize per-submovement aiming error (undershoot/overshoot), converging in under 30 minutes of use for desktop pointing. — [arXiv 1611.08154](https://arxiv.org/abs/1611.08154v2)
- [PR] Hard bounds computable in advance: minimum gain from largest required movement over about 30 cm usable travel; maximum from smallest target over about 0.2 mm hand resolution. — [Casiez et al. 2008](https://Www.Gwern.net/doc/design/2008-casiez.pdf)
- [PR] Counterbalanced condition order plus a full adaptation session before each measured session is the standard used for latency conditions with skilled players. — [Spjut et al. 2019](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- [PP] Statistical power warning: an effect of d = 0.32 required thousands of pooled trials and was not significant at the per-user level with 400 trials per condition. — [Spjut et al. 2021](https://arxiv.org/pdf/2105.10498)
- [COMM] Feel-based bisection (PSA) gives non-repeatable results that depend on warm-up. — [mouse-sensitivity.com forum](https://mouse-sensitivity.com/forums/topic/6013-need-a-sensitivity-finding-method-that-isnt-psa)

### Inferences
A principled design assembled from the above (none of it validated as a whole):
1. **Bound the search space first.** Ask for pad width and usual targets; compute the Casiez-style floor (largest routine turn, for example 180 degrees, must fit in usable pad travel) and ceiling (smallest target angle over 0.2 mm). Clip to roughly 15 to 90 cm/360.
2. **Passive diagnosis at the current sensitivity before changing anything.** From normal training data compute: signed first-submovement endpoint error (overshoot vs undershoot) by flick amplitude; number of corrective submovements; first-submovement peak velocity relative to the player's fastest observed; clutch/lift frequency; tracking error and reversal count. Persistent overshoot with many corrections on small targets suggests too high; slow ballistic phase, undershoot on large flicks, or frequent lifts suggests too low. This costs no adaptation.
3. **Active test only when diagnosis suggests a move.** Use an interleaved A/B/A/B (or ABBA) design between the current setting and one candidate about 1.25 to 1.5x away, in blocks of several minutes, discarding the early part of each block. Interleaving controls fatigue, warm-up and day effects that single-pass comparisons confound; returning to A repeatedly gives a baseline drift check, as in Boudaoud's first/last sessions.
4. **Model rather than bisect.** Fit a smooth curve (for example quadratic in log cm/360, or a Gaussian-process / Bayesian optimization over log sensitivity) to a composite score, and report the range where predicted performance is within noise of the optimum. Expect that range to be wide. Choose the next sensitivity to test by expected information, with a cap on step size so adaptation cost stays small.
5. **Separate task families.** Fit flicks (by amplitude and target size), micro-corrections and tracking separately; they may disagree, and the recommendation should be weighted by the player's game (tactical: small targets and small corrections; movement shooters: large turns and tracking). Tracking is absent from the published sensitivity evidence, so this weighting is a design assumption.
6. **Guard against confounds.** Novelty (a new setting can briefly raise effort and scores), adaptation (first few hundred trials), fatigue, time of day, and hardware drift (frame pacing, latency). Require the advantage to replicate on a second day before recommending a change; never claim a difference smaller than session-to-session variation.
7. **Use speed and accuracy jointly.** Throughput or score-at-fixed-accuracy, not raw time or hit rate alone, since sensitivity shifts the speed-accuracy operating point.
8. **Communicate honestly.** Output: "your data are consistent with X to Y cm/360; you are at Z; evidence for moving is weak/moderate/strong," plus the bias pattern that motivated it.

FOV can be handled as a second, mostly non-empirical step: match the target game's FOV exactly for transfer, and scale scoped sensitivity by focal length unless the player opts otherwise.

### Gaps
- No published Bayesian-optimization or bandit procedure for FPS sensitivity was found; step 4 is a design proposal.
- No evidence on how well trainer-derived optimal sensitivity transfers to in-game performance, where movement, recoil and target behavior differ.
- Required trial counts per comparison are unknown; the latency study suggests several hundred to thousands per condition for small effects, which may exceed what casual users will tolerate.
- Whether per-task optima differ enough within a player to matter (flick vs tracking) is untested.
