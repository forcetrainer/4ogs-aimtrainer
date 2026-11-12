# Empirical Evidence on Aim-Trainer Transfer to In-Game FPS Performance (as of Nov 2026)

Evidence labels used throughout: **[PEER]** peer-reviewed; **[VENDOR]** authored/funded by an aim-trainer company (conflict of interest); **[COMMUNITY]** coach/player/blog opinion, non-empirical; **[SNIPPET]** I only saw a search-result summary, not the primary text (treat as lower confidence).

Bottom line up front: I found **no controlled or quasi-experimental study showing that practice in a standalone aim trainer (KovaaK's, Aim Lab, 3D Aim Trainer, osu!) improves in-game outcomes (K/D, HS%, rank, damage)** in CS/Valorant/Apex/COD/Overwatch with an adequate sample and control group. The published literature demonstrates (a) people get better at trainer tasks with practice, (b) trainer scores are reliable measurements, (c) skilled FPS players score better on aiming tasks than unskilled ones (cross-sectional). Everything about transfer is inference, anecdote, or marketing.

---

## Q1. What peer-reviewed/preprint studies use Aim Lab or KovaaK's data, and what did they actually measure?

### Takeaway
Every study located measures performance **inside the trainer task** (learning curves, reliability, kinematics); none measures in-game transfer. The flagship Aim Lab paper (Listman et al. 2021) is vendor-funded, observational, single-task (Gridshot), and explicitly had no data on what games players played.

### Cited Findings

**Listman, Tsay, Kim, Mackey, Heeger (2021), Frontiers in Human Neuroscience 15:777779 — [PEER][VENDOR]**
- N = 7,174 players, 62,170 game days, 682,564 runs of the 60 s Aim Lab **Gridshot** task (pistol, compete mode), up to 100 days per player; observational/exploratory "proof of concept". — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Outcomes are trainer-internal only: hit rate (% shots hitting) and hits per second ("motor acuity"). **No transfer measured**; authors state they had no information on "other video games they play or how long they play them." — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Improvement: hits/sec median 2.72 (day 1) to 3.78 (day 60), no clear plateau; hit rate 86.10% to 89.60%, plateauing within ~5 days (i.e., gains were mostly speed, not accuracy). — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Dose: median 7 runs/day (mean 9.35). Abstract says "90% of the learning benefit was achieved by practicing 30 min per day"; the Results section says greatest benefit at ~75 runs (~1 hour) and 90% of benefit at 49 runs (~50 min). **Abstract and Results are inconsistent on the dose figure** — cite with caution. Diminishing returns beyond that, possibly fatigue. — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Days-per-week optimum: **not reported** in this paper (the fetch found no such analysis). — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Baseline effect: higher-baseline players gained less per additional day and less from extra same-day practice (nonlinear learning rate). — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Retention: ~40-60% of within-day gains retained to the next day (hits/sec 65% +/- 52% day 1 to day 2, falling to ~40% after day 10). — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Warm-up decrement: performance rises rapidly over the first few runs each day; ~3 warm-up runs; authors hypothesize re-adaptation to mouse sensitivity. — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Reliability: ICC(A,1) 0.88-0.96 for hits/sec, 0.62-0.86 for hit rate. Compete-mode runs scored higher than practice-mode (motivation/effort). — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- COI: Listman and Mackey employed by Statespace Labs, Heeger a paid consultant; Statespace (maker of Aim Lab) funded the study and paid publication fees; data proprietary/not public. No demographics, hardware, or other-game data. — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)

**Donovan, Saul, DeSimone, Listman, Mackey, Heeger (2022), Frontiers in Human Neuroscience 16:979293 — [PEER][VENDOR]**
- 32 male pro/semi-pro players (4 Valorant, 10 PUBG, 18 R6 Siege); 6 runs each of Aim Lab Gridshot and Sixshot; post hoc reanalysis of commercially collected data. — [Frontiers](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2022.979293/full)
- Findings are kinematic: task demands change movement strategy (Gridshot produces faster, "swipier" shooting; Sixshot more hypometric landings); higher motor acuity associated with shorter reaction time, less swiping, higher precision. Fitts's law fit each task alone but poorly across both tasks combined. Only p-values reported, no correlation coefficients. — [Frontiers](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2022.979293/full)
- **Does not correlate Aim Lab scores with rank or in-game results**; describes that as future work. Notes in-game metrics (K/D, damage, win rate) are confounded by teammates and opponents. All six authors are Statespace employees/officers. — [PMC9744923](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923)

**Rogers, Trotter, Johnson, Desbrow, King (2024), Frontiers in Sports and Active Living 6:1309991 — [PEER], independent (no funding, no COI declared)**
- n = 10 FPS players (2 current pros, 3 ex-pros, 5 recreational); test-retest of four KovaaK's tasks (Micro Flicking, Macro Flicking, Strafe Tracking, Wall Peeking), two trials 3-5 days apart. ICCs 0.947-0.995. — [PMC10925653](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/)
- Practice effects appeared even across two sessions (Macro Flicking accuracy and hits/sec higher in Trial 2, p = .005 / .009); authors recommend more familiarization. — [PMC10925653](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/)
- Authors explicitly caution that extrapolating to in-game performance requires care because KovaaK's isolates aiming, whereas real play adds cognitive load. — [PMC10925653](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/)

**Warburton, Campagnoli, Mon-Williams, Mushtaq, Morehead (2023), PNAS Nexus 2(8):pgad249 — [PEER], independent (no funding, no COI)**
- Custom browser aim-trainer-style task (not Aim Lab/KovaaK's). Exp 1 n = 50; Exp 2 n = 86 (Prolific; mouse and trackpad users; mostly non-FPS players). — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)
- Aiming in FPS "look" (camera pan) context vs ordinary cursor pointing: spatial kinematics nearly identical; look context ~53 ms slower (d = 0.73). Implies FPS flicking draws on the general point-and-click motor system. — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)
- Acquire time improved 317 ms over 20 rounds (d = 0.99) — again within-task learning. Primary-submovement extent, its variability, peak speed, and direction variability predicted acquire time (marginal R2 = 0.22). — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)
- Self-reported FPS players were faster at end of experiment (588 ms vs 727 ms, p = .004); gaming hours did not predict performance (p = .197). No rank data. — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)

**Other trainer-as-instrument studies (not about transfer)**
- PLOS ONE 2023: 43 volunteers in Aim Lab; external focus of attention gave no benefit over internal focus. — [PMC10368276](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10368276/) [SNIPPET]
- NVIDIA / The Meta: latency experiment inside KovaaK's with >15,000 players (Dec 2021-Apr 2022) reporting better task scores at lower latency. Vendor (NVIDIA) blog, trainer-internal outcome. — [NVIDIA developer blog](https://developer.nvidia.com/blog/improving-player-performance-with-low-latency-as-evident-from-fps-aim-trainer-experiments/) [SNIPPET][VENDOR]
- KovaaK's used as outcome measure in a caffeine dose-response study. — [Frontiers Sports Act. Living 2024](https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2024.1437700/full) [SNIPPET]
- Registered trial using Aim Lab as an outcome for mental-fatigue effects (registration only, no results). — [ClinicalTrials.gov NCT06729060](https://clinicaltrials.gov/study/NCT06729060) [SNIPPET]

### Inferences
- The scientific use of aim trainers so far is as a **measurement instrument** (reliable dependent variable) and a **motor-learning dataset**, not as an intervention whose in-game efficacy has been tested.
- Listman's dose figures (30-60 min/day; ~3 warm-up runs; 40-60% overnight retention) describe how to get better at **Gridshot**, not how to get better at a game. They are reasonable priors for session structure but not transfer evidence.
- Listman's result that gains were mostly speed (hits/sec) while accuracy plateaued in ~5 days, plus Donovan's finding that Gridshot elicits "swipier" strategy, is consistent with the community critique that Gridshot-style scores can rise through task-specific strategy rather than general precision. This is my inference; neither paper states it that way.

### Gaps
- No follow-up from Statespace linking Aim Lab scores to Valorant/CS in-game stats was found, despite Statespace having ranked-integration data in principle. Absence in my search is not proof of non-existence.
- "Optimal days per week" claims circulating in marketing could not be traced to the Listman paper.
- I could not access the full text of "Unlocking the Untapped Potential of Video Game Data: A Case Study of Aim Trainers" (appeared as a ResearchGate title only); contents unverified.
- No published studies found using 3D Aim Trainer or osu! data for FPS transfer.

---

## Q2. Is there any controlled or quasi-experimental study showing transfer from aim-trainer practice to in-game outcomes?

### Takeaway
None of adequate quality was found. The closest items are (1) a tiny, hard-to-verify IEEE conference paper on Aim Lab and Valorant, (2) a small RCT of in-game CS:GO bot training (not an aim trainer) and (3) a CS:GO aim-map training study with tDCS — all trainer-like or in-engine outcomes, small n, no real-match outcomes.

### Cited Findings
- **"Evaluating the Effects of Aim Lab Training on Filipino Valorant Players' Shooting Accuracy"** (IEEE conference, ~2021): reportedly a one-week Aim Lab routine before Valorant play with a reported gain in damage per round. Secondary summaries conflict on the sample (one says 6 participants; a ResearchGate abstract summary says 30). I could not retrieve the primary text (403 / empty page). Treat as **weak, unverified, apparently uncontrolled pre/post**. — [IEEE Xplore 9436822](https://ieeexplore.ieee.org/document/9436822/) [SNIPPET]
- **Neri et al. (2021), Frontiers in Psychology 12:598410** [PEER]: randomized, n = 21 novices (11 adaptive vs 10 default), ~30 h of CS:GO deathmatch vs bots over 3 weeks. Adaptive-difficulty group progressed faster on difficulty-corrected K/D (Time x Group F = 4.22, p = .017). Both groups improved on in-engine aim courses and firing-range tasks with **no group difference**. No aim-trainer arm, no no-training control, outcomes vs bots not ranked matches. Shows in-game practice improves in-game aiming tests; says nothing about standalone trainers. — [PMC8224404](https://pmc.ncbi.nlm.nih.gov/articles/PMC8224404/)
- **Toth, Ramsbottom, Constantin, Milliet, Campbell (2021), Computers in Human Behavior 121:106782** [PEER]: CS:GO players trained on an in-game target-shooting task; the task discriminated novice from skilled players (cross-sectional validity), training improved task performance at all expertise levels, and tDCS accelerated gains in novices only. Outcome is the trained task itself; press coverage framed it as "10 minutes a day". Sample size and effect sizes not verified. — [University of Limerick record](https://pure.ul.ie/en/publications/the-effect-of-expertise-training-and-neurostimulation-on-sensory-/) [SNIPPET]
- Thai study (Srimuang et al.) combining visualization training with Aim Lab: pre 22.98 vs post 28.58 hits out of 30 targets in a Valorant target-shooting test; pre/post without evident control; outcome is a range-style test, not match performance. — [RDI RMU journal](https://so03.tci-thaijo.org/index.php/rdirmu/article/view/305447) [SNIPPET]
- Cross-sectional evidence that aiming-task performance tracks expertise: Toth et al. (task separates novice vs skilled, above); Warburton et al. (FPS players faster, 588 vs 727 ms) — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/); Park et al. 2021 "Secrets of Gosu" (CS:GO pros vs amateurs differ on crosshair-enemy stickiness, mouse angular velocity, recoil-compensation amplitude, etc.) — [ResearchGate record](https://www.researchgate.net/publication/351419062_Secrets_of_Gosu_Understanding_Physical_Combat_Skills_of_Professional_Players_in_First-Person_Shooters) [SNIPPET].
- Trainer-rank vs game-rank "data" available publicly is anecdotal: Steam forum threads and a Riot-devtracker-archived player "experiment" comparing Aim Lab rank with Valorant rank for a handful of people. — [Steam discussion](https://steamcommunity.com/app/714010/discussions/0/3130541122083379046/), [devtrackers.gg](https://devtrackers.gg/valorant/p/5b1b2b97-what-is-the-difference-in-aim-between-ranks-in-valorant-experiment) [COMMUNITY]
- Marketing pages assert transfer with unverifiable citations (e.g., a "2021 Bednarski et al." study and a "73% first-shot" statistic on fpstrain.us; a "Skill Score correlates with Valorant rank" claim on fpsaim.com). I could not verify any of these; treat as unsupported. — [fpstrain.us](https://fpstrain.us/valorant-aim-trainer.html), [fpsaim.com](https://fpsaim.com/aim-lab-alternative.html) [VENDOR/marketing]

### Inferences
- The cross-sectional pattern (better players score better on aim tasks) is compatible with transfer but equally with reverse causation (playing the game builds aim) and selection. It cannot establish that trainer practice causes in-game gains.
- Neri et al. is indirect evidence for the alternative hypothesis designers must beat: **structured in-game practice against bots already improves in-engine aim tests**, so a trainer must show added value over simply playing/deathmatching for the same time (opportunity cost).
- A properly powered RCT (aim trainer vs time-matched deathmatch vs no-training, with blinded in-game outcomes over many matches) appears to be an open gap in the literature.

### Gaps
- No study found with in-game K/D, HS%, ADR, or rank as a preregistered outcome and a time-matched active control.
- No published correlation (with r and n) between KovaaK's/Voltaic/Aim Lab rank and competitive rank was found. Vendors likely hold such data privately.
- Full text of Toth et al. and the IEEE paper not retrieved; sample sizes/effect sizes unverified.

---

## Q3. What does the transfer-of-training literature predict?

### Takeaway
Decades of evidence say practice gains are largest on the trained task, moderate on closely related tasks (near transfer), and small-to-null on dissimilar tasks (far transfer). Motor-skill research adds that skills can be remarkably specific to practiced conditions. Prediction: aim drills will transfer to the degree they share the game's perceptual information, movement parameters, and decision context.

### Cited Findings
- Simons et al. (2016, Psychological Science in the Public Interest) reviewed the studies brain-training companies cite: people improve on the trained tasks, but there is no compelling evidence of broader cognitive or real-world benefit; few studies even measured the real-world tasks users care about. Advice: training helps if your goal is the trained task itself. — [APS summary](https://www.psychologicalscience.org/publications/brain-training.html)
- Sala & Gobet (2017, Current Directions in Psychological Science): across chess, music, and working-memory training, far transfer "rarely occurs". — [SAGE](https://journals.sagepub.com/doi/10.1177/0963721417712760)
- Sala et al. (2019, Collabra) second-order meta-analysis: working-memory training produces near transfer; far-transfer effects are small or null regardless of population or program; near-transfer effects weaken for measures less directly related to trained tasks. — [Fujita Health Univ. record](https://pure.fujita-hu.ac.jp/en/publications/near-and-far-transfer-in-cognitive-training-a-second-order-meta-a/)
- Motor specificity: Keetch, Schmidt, Lee & Young (2005, JEP:HPP) found skilled basketball players shoot better from the free-throw line than predicted from neighboring distances — an "especial skill" tied to the exact heavily practiced distance/angle. Later work suggests such specificity can emerge with relatively little constant practice. — [Keetch et al. 2005 PDF](https://www.Gwern.net/doc/psychology/spaced-repetition/2005-keetch.pdf); follow-up discussion in [Frontiers in Psychology 2016](https://frontiersin.org/articles/10.3389/fpsyg.2016.01178/full) [SNIPPET]
- Representative learning design (ecological dynamics / nonlinear pedagogy): practice should preserve the perception-action couplings present in competition; low-fidelity drills can decouple information from movement and impair transfer. — [Davids, Principles of Nonlinear Pedagogy](https://shura.shu.ac.uk/22691/1/Davids-PrinciplesOfNonlinearPedagogy(AM).pdf); [Chow et al. 2023, PMC10244496](https://pmc.ncbi.nlm.nih.gov/articles/PMC10244496) [SNIPPET]
- HCI/esports perspective: Boudaoud, Spjut, Kim, Madhusudan, Watson (NVIDIA; ACM Interactions 2022) argue skilled competitive gamers "rarely succeed solely by completing individual mouse movements" and instead optimize task-specific skills deep in the learning curve of their specific game. — [arXiv 2507.05446](https://arxiv.org/abs/2507.05446)
- Supporting generality at the motor level: FPS camera-aiming and ordinary pointing share near-identical spatial kinematics (Warburton et al.). — [PMC10411933](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)
- Even within a trainer, changing target size/count changes strategy enough that one Fitts's-law model fails across tasks (Donovan et al.) — task-specific strategies form quickly. — [Frontiers](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2022.979293/full)

### Inferences
- What makes a drill "near": same sensitivity/FOV/cm-per-360 and input device; same target angular sizes, distances, speeds and hitbox shapes as the game; same weapon model (fire rate, recoil, first-shot accuracy, movement inaccuracy); same information sources (enemy appearing from cover/angles, visual clutter); same response requirements (stop-then-shoot, burst length); and some decision component. This list is derived from identical-elements/specificity logic, not directly tested for aim trainers.
- Warburton suggests raw mouse control is a fairly general capacity, so some transfer of basic pointing precision is plausible; the especial-skills and Donovan findings suggest score gains on a repeated fixed scenario will substantially overstate that general gain.
- Variable practice (varying target size/distance/speed) should produce more generalizable aim than grinding one fixed scenario. Standard motor-learning expectation; not verified in an aim-trainer study.

### Gaps
- I did not retrieve Simons et al. full text or a primary source for Thorndike's identical-elements theory; cited via summaries.
- No aim-trainer study manipulates task fidelity and measures transfer.
- Action-video-game transfer literature (e.g., Bediou et al. meta-analyses, which argue for some cognitive transfer from playing action games) was not searched; it would be a relevant counterpoint.

---

## Q4. Critiques of benchmark/rank systems (Voltaic, Aim Lab ranks, etc.)

### Takeaway
There is no public quantitative data relating benchmark rank to in-game rank. Critiques (scenario-specific learning, opportunity cost, benchmark obsession) come from coaches and the benchmark authors themselves, who explicitly say benchmarks measure raw mouse control and are only one piece of in-game performance.

### Cited Findings
- Voltaic's own Season 5 announcement: the benchmarks "measure your raw aiming abilities" but "represent just one piece of the puzzle for in-game performance"; use as a supplementary tool, and practice game sense and movement in your FPS alongside. — [Voltaic blog](https://blog.voltaic.gg/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/) [COMMUNITY, benchmark author] [SNIPPET]
- Voltaic routine documentation warns against over-focusing on the benchmark ranking system. — [Voltaic fundamentals routines doc](https://docs.google.com/document/d/1BPiDxbaqQVxInKwFfdr_AJdJDYVGKbUBGHJDKOeUy-Q/mobilebasic) [COMMUNITY] [SNIPPET]
- Coach/content creator Bruhskey (X post): rarely uses aim trainers; fine for mouse control or warm-up, but for improving at the actual game, mouse control is usually not what is holding a player back (he states "75% chance"). An accompanying claim of at best ~0.6:1 transfer in tactical shooters and "no scenario" giving 1:1 replication appeared in the search summary. These numbers are opinion, not measured. — [X post](https://x.com/bruhskey/status/1992307610263933332?lang=en) [COMMUNITY] [SNIPPET; post not retrievable]
- Voltaic member "sini" published a thread on aim-training misconceptions, advising aim training as a supplement balanced with in-game time. — [X thread](https://x.com/sinizap/status/1734652450080989497?lang=en) [COMMUNITY] [SNIPPET; not retrievable]
- Blog argument (no data, two anecdotes): trainers only help if mechanical aim is the bottleneck; a rising trainer score with flat rank is a warning sign; pure speed-flick drills transfer poorly to tactical shooters; warm-up maintains rather than raises skill. — [gamehatchy, July 2026](https://gamehatchy.com/do-aim-trainers-actually-work/) [COMMUNITY]
- Reddit r/Voltaic users ask what benchmark scores correspond to Valorant ranks without an authoritative answer; beginners are steered to structured routines over benchmarks. — [r/Voltaic thread mirror](https://axebps-redlib.hf.space/r/Voltaic/comments/1hbb9ej/valorant_benchmarks) [COMMUNITY]
- Empirical facts consistent with "learning the scenario": score gains across just two sessions in experienced players (Rogers) — [PMC10925653](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/); Gridshot gains driven by speed with accuracy flat (Listman) — [PMC8720934](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934); Gridshot elicits a distinct swipe strategy (Donovan) — [Frontiers](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2022.979293/full).
- In-game rank itself is a noisy criterion: rank calculation is opaque (noted in a CS:GO esports study) and visible rank is separated from hidden MMR in Valorant. — [PMC10598391](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10598391/) [SNIPPET]; [Riot support](https://support.riotgames.com/hu-hu/valorant/gameplay/how-rank-rating-rr-is-calculated) [SNIPPET]

### Inferences
- A benchmark made of a fixed scenario set, replayed for high scores, is structurally a "teaching to the test" setup: high-score chasing rewards scenario-specific strategies (pathing memorization, bot-pattern reading, swipe-shooting) and best-of-N scores inflate via variance. Follows from the specificity literature and the observed practice effects; not directly quantified anywhere I found.
- Design implication: separate **training tasks** from **assessment tasks**; assess with median/typical performance rather than personal bests; randomize scenario parameters so the pattern cannot be memorized.

### Gaps
- No data found on benchmark-rank vs game-rank correlation, on score inflation across benchmark seasons, or on overtraining/RSI incidence among aim trainers.
- "Revosect" and Aim Lab rank-system-specific critiques were not found in searchable sources (much of this discourse lives in Discord/YouTube).
- The primary X posts could not be fetched (HTTP 402); wording is from search summaries.

---

## Q5. What do pros and credible coaches say about aim training relative to other skills? (ANECDOTAL)

### Takeaway
The informed-community consensus is that aim trainers build raw mouse control and are useful as supplement/warm-up, but positioning, crosshair placement, game sense, and movement are usually the binding constraint, and trainer time has an opportunity cost. None of this is measured.

### Cited Findings
- Bruhskey (coach/creator): mouse control is usually not the limiting factor for in-game improvement; aim trainers fine for mouse control and warm-up. — [X](https://x.com/bruhskey/status/1992307610263933332?lang=en) [COMMUNITY][SNIPPET]
- Voltaic (the leading aim-training organization) itself frames aim as "one piece of the puzzle" and tells users to train game sense and movement in-game. — [Voltaic blog](https://blog.voltaic.gg/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/) [COMMUNITY][SNIPPET]
- Blogs converge on: trainers "cannot fix decision-making, positioning, or game sense"; transfer conditional on matched sensitivity; over-investing in trainers can reduce in-game improvement. — [gamehatchy](https://gamehatchy.com/do-aim-trainers-actually-work/); [aiming.pro (vendor)](https://aiming.pro/does-aim-training-work) [COMMUNITY/VENDOR]
- Journalist self-experiment: 100 hours in an aim trainer, asking whether it helped (single-person anecdote; contents not reviewed). — [mein-mmo.de](https://mein-mmo.de/en/i-played-an-aim-trainer-for-100-hours-to-get-better-at-shooters-but-did-it-really-help,1062732) [COMMUNITY][SNIPPET]
- Survey context: Nagorsky & Wiemeyer (2020, PLOS ONE), n = 1,835 esports players across five titles including Counter-Strike: mean ~20 h/week play, of which ~39% (7.75 h) was training; competence and training structures are game-specific, so training "should always consider the specific competence profile" of the game. — [PMC7447068](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7447068/) [PEER][SNIPPET]
- Academic framing that agrees with coaches: experts optimize game-specific skills, not isolated mouse movements. — [arXiv 2507.05446](https://arxiv.org/abs/2507.05446)

### Inferences
- Value of aim training likely varies by game: more plausible in high-TTK tracking-heavy games (Apex, Overwatch) where sustained mouse control decides fights, less in low-TTK tactical shooters (CS, Valorant) where pre-aim/crosshair placement and peeking reduce the required mouse movement. Community belief echoed in sources above; untested.

### Gaps
- I did not locate direct, attributable quotes from named professional players (e.g., pros who do or do not use KovaaK's); such statements are scattered across interviews/streams and not reliably searchable.
- No survey quantifying what share of pros use dedicated aim trainers vs in-game deathmatch/aim maps.

---

## Q6. What properties of in-game aiming are NOT represented in standard trainer scenarios?

### Takeaway
Researchers themselves note trainers strip out cognitive load, self-movement, moving/multi-aim-point targets, and rich visual scenes; instrumented studies of CS:GO pros show combat skill includes recoil compensation, keyboard-mouse coordination, and gaze behavior. A complete enumerated list is mostly design inference.

### Cited Findings
- Real FPS play adds cognitive load absent in KovaaK's; the one KovaaK's task requiring movement (Wall Peeking) was noted as not isolating shooting skill. — [Rogers et al. 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/)
- Real games have moving targets, multiple ideal aim points, simultaneous character movement, and richer visual cues than aim-trainer tasks. — [Warburton et al. 2023](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411933/)
- Pro vs amateur CS:GO differences span crosshair-enemy "stickiness", mouse angular velocity, **amplitude of recoil-compensating movement**, shooting duration, force efficiency, plus gaze, keyboard, and posture measures (motion capture, eye tracking, EMG). — [Park et al. 2021, "Secrets of Gosu"](https://www.researchgate.net/publication/351419062_Secrets_of_Gosu_Understanding_Physical_Combat_Skills_of_Professional_Players_in_First-Person_Shooters) [SNIPPET]
- Experienced FPS players show faster, more efficient eye movements on a CS-training-map-derived task (28 experienced vs 35 inexperienced). — [PsyPost summary](https://www.psypost.org/experienced-fps-gamers-show-faster-more-efficient-eye-movements-during-aiming-tasks-study-finds/) [SNIPPET]
- In-game outcomes depend on teammates/opponents, not just mechanics. — [Donovan et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923)
- Mechanical profiles differ by game (stop-and-tap precision in CS-style vs sustained tracking while moving in Apex-style). — [gamehatchy](https://gamehatchy.com/do-aim-trainers-actually-work/) [COMMUNITY]

### Inferences
Elements typically missing or weak in standard trainer scenarios (design checklist; inferred from above plus game mechanics, not individually sourced):
- Recoil/spray patterns, first-shot inaccuracy, burst/tap discipline, weapon-specific fire rate and reload.
- Movement-accuracy coupling: counter-strafing, stop-shoot timing, jiggle/wide peeking, crouch timing; coordinated WASD + mouse.
- Crosshair placement / pre-aim: in-game, good players minimize flick distance before the target appears; trainers reward large reactive flicks from a neutral start.
- Target acquisition under uncertainty: unknown spawn position, timing, and number; partial exposure behind cover; head-level geometry of real maps.
- Visual search under clutter: low-contrast character models, effects, smokes/flashes, ability VFX; trainers use high-contrast spheres.
- Target behavior: humans strafing adaptively, shooting back, using peeker's advantage; network latency.
- Threat and time pressure: being damaged, one-life rounds, stakes, arousal; trainers have no cost for slowness other than score.
- Audio cues for pre-aiming; minimap/team information.
- TTK structure: one-tap/low TTK (first-bullet precision) vs high TTK (tracking through armor/shields) changes the optimal speed-accuracy trade-off; trainer scoring (hits/sec) may reward a different trade-off than the game does.
- Decision layer: whether to take the fight, target prioritization, when to reposition.

### Gaps
- Could not open the Park et al. PDF (size limit); details via secondary summaries.
- No study quantifies how much each missing element contributes to in-game outcome variance.

---

## Q7. How could a small private trainer check whether training transfers for its own users?

### Takeaway
No off-the-shelf validated protocol exists; the brain-training critique literature and the reliability studies give the ingredients: objective real-world outcomes, baselines, active comparison, held-out tasks, and attention to practice/warm-up effects and noisy rank metrics.

### Cited Findings
- Best-practice criticisms from Simons et al.: need objective measures of the real-world tasks users care about, not just trained-task gains; adequate controls. — [APS summary](https://www.psychologicalscience.org/publications/brain-training.html)
- Trainer metrics are reliable enough to detect change (ICC 0.95-0.99 KovaaK's; 0.88-0.96 for Aim Lab hits/sec, lower 0.62-0.86 for hit rate) — speed-weighted metrics are more stable than raw accuracy. — [Rogers](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/); [Listman](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Practice effects occur on mere re-testing, so probes need familiarization and/or controls. — [Rogers](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653/)
- Within-day warm-up effect (~3 runs) and only 40-60% overnight retention: test timing and warm-up state must be standardized. — [Listman](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- Motivation/mode affects scores (compete > practice mode). — [Listman](https://pmc.ncbi.nlm.nih.gov/articles/PMC8720934)
- K/D, damage, win rate are confounded by teammates/opponents; rank computation is opaque. — [Donovan](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923); [PMC10598391](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10598391/) [SNIPPET]
- Example of graded in-engine outcomes used in an RCT: difficulty-corrected K/D vs bots, in-game aim-course completion time, firing-range hits (Neri et al.). — [PMC8224404](https://pmc.ncbi.nlm.nih.gov/articles/PMC8224404/)

### Inferences (proposed measurement design; not validated)
1. **Transfer ladder of outcomes**, from nearest to farthest: (a) trained scenarios; (b) held-out parameter variants of trained scenarios (new sizes/speeds/distances); (c) **never-practiced transfer probes** of a different structure, administered rarely (e.g., every 2 weeks, 2-3 runs after fixed warm-up) so they are not themselves trained; (d) standardized in-game tests (fixed bot/range/aim-map drill, deathmatch stats); (e) real-match stats. Report gains at each rung; shrinking gains down the ladder quantify specificity.
2. **In-game metrics less teammate-confounded than K/D or rank**: headshot %, first-bullet accuracy, time-to-damage/time-to-kill after first sight, opening-duel win rate, ADR, accuracy by range — pulled from match APIs/demo parsers (e.g., CS2 demos, Valorant trackers) over large match windows (dozens of matches) to beat noise. Rank/MMR only as a slow secondary indicator.
3. **Baseline window** of 2-4 weeks of in-game stats before training starts, so each user has a pre-trend (controls for natural improvement from simply playing).
4. **Within-user designs for small n**: multiple-baseline/staggered start, ABAB (train/withhold) blocks, or training one skill category (e.g., tracking) while holding another (e.g., click-timing) as an untrained within-person control and checking that the matching in-game metric moves selectively.
5. **Log total play time** in game and trainer so trainer time can be compared with the opportunity cost of equal in-game time; ideally randomize users/weeks to "trainer + game" vs "time-matched deathmatch".
6. **Scoring hygiene**: use median of several runs, not personal best; fixed warm-up before probes; same sensitivity/FOV as the target game; record hardware changes; pre-register the primary metric to avoid cherry-picking among many stats.
7. **Guard against Goodhart**: do not show transfer-probe leaderboards or ranks; keep probe parameters randomized.

### Gaps
- No published validation of any in-game metric as a sensitive, reliable indicator of mechanical aim change (test-retest reliability of HS% or opening-duel rate over N matches is unknown from sources found).
- Number of matches needed for stable in-game stats was not found in the literature; needs to be estimated empirically from the trainer's own users.
- Feasibility/ToS constraints of pulling per-match data from each game's API were not researched.
