# Adaptive difficulty, skill diagnosis, and automated coaching for an FPS aim trainer (as of Nov 2026)

Reading notes for the report writer:
- "Established" = peer-reviewed and replicated in its home domain. "Speculative for aiming" = my extrapolation to mouse aiming; these are confined to the Inferences sub-sections.
- Items I could not source in this session (but which are standard textbook knowledge) are listed under Gaps and marked "background knowledge, unverified here". Do not present them as cited facts.
- Several sources were read only as abstracts/search snippets; this is flagged per item ("abstract only" / "secondary").

## 1. Optimal difficulty: what success rate should training target?

### Takeaway
There is no single evidence-backed "ideal success rate" for human motor learning; the 85% figure is a theoretical result for gradient-descent binary classifiers, and motor-learning theory (challenge point, desirable difficulties) says the optimum depends on skill level and that harder practice can depress in-session performance while improving retention. A defensible design is to hold players in a band of roughly 70-90% hit success, adjusted per player and per task, and judge learning by delayed retention tests rather than in-session scores.

### Cited Findings
- Wilson, Shenhav, Straccia & Cohen (2019) derive that for stochastic gradient-descent learning on binary classification, learning is fastest at about 85% training accuracy (optimal error rate ~15.87%, varying somewhat with the noise distribution); demonstrated on artificial neural networks and a biologically plausible network model — [Nature Communications](https://doi.org/10.1038/s41467-019-12552-4)
- Scope limit stated by the lead author: the rule explicitly applies only to binary classification tasks with clear right/wrong answers; it is not claimed to transfer directly to complex human learning — [University of Arizona News](https://news.arizona.edu/news/learning-optimized-when-we-fail-15-time)
- Challenge point framework (Guadagnoli & Lee 2004, J Motor Behavior 36(2):212-224): the optimal challenge point is the level of functional task difficulty at which a learner of a given skill optimises learning; it shifts upward as the learner's information-processing ability grows; more challenging practice can reduce practice performance while benefiting long-term learning — [Wikipedia summary of the framework](https://en.wikipedia.org/wiki/Challenge_point_framework); [scoping review of 100 applications](https://eprints.leedsbeckett.ac.uk/id/eprint/12281/1/ChallengeAcceptedASystematicScopingReviewOfTheapplicationsOfTheChallengePointFrameworkPV-JONES.pdf)
- Learning vs performance (Soderstrom & Bjork 2015): learning = relatively permanent change supporting retention and transfer; in-session performance is an unreliable index of learning, and conditions producing more errors during acquisition often produce more learning; learners and teachers routinely mistake performance for learning (secondary summaries read; full text not retrieved) — [Perspectives on Psychological Science, DOI](https://doi.org/10.1177/1745691615569000)
- Errorless vs errorful motor learning (Maxwell, Masters, Kerr & Weedon 2001, golf putting): "errorless" practice (start easy/short putts, progress gradually) produced performance that was robust under a secondary-task load, whereas errorful learners' performance deteriorated under load; interpreted as more implicit, less attention-demanding learning (abstract only) — [QJEP](https://journals.sagepub.com/doi/10.1080/713756014); [Birmingham record](https://research.birmingham.ac.uk/en/publications/the-implicit-benefit-of-learning-without-errors)
- Real aim-trainer data: in 7,174 Aim Lab Gridshot players, hit rate rose from a median 86.1% (day 1) to 89.6% (day 60) and plateaued within 3-5 days, while hits per second (speed x accuracy) kept improving (2.72 to 3.78 by day 60). The authors note players self-settle near ~85% hit rate and speculate that this may balance learning and engagement; high-accuracy players' accuracy actually declined with practice as they traded it for speed — [Listman et al. 2021, Frontiers in Human Neuroscience](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- Dynamic difficulty adjustment (DDA) in games: a 2024 systematic review reports most studies find positive effects of DDA on enjoyment, flow, motivation, engagement and immersion — [Mortazavi, Moradi & Vahabie 2024](https://ouci.dntb.gov.ua/works/4MWoyDN9). A separate systematic mapping found about one third of DDA papers did not measure player experience at all and four reported disadvantages — [Karhunen 2024, Univ. Jyväskylä](https://jyx.jyu.fi/handle/123456789/95499). A 2025 chapter flags transparency and the risk of undermining the player's sense of competence as DDA limitations — [Fisher & Kulshreshth, IntechOpen](https://www.intechopen.com/online-first/1228576)
- Practice structure with evidence in motor learning: spaced beats massed practice (Donovan & Radosevich 1999 meta-analysis, 63 studies, overall d = 0.46; task type and inter-trial interval moderate the effect) — [Donovan & Radosevich 1999](https://www.gwern.net/docs/spaced-repetition/1999-donovan.pdf). Contextual interference (random/interleaved vs blocked practice): medium effect in lab studies (d = 0.57) but negligible in applied settings per Brady 2004 — [Brady 2004](https://www.gwern.net/docs/spaced-repetition/2004-brady.pdf); a 2024 meta-analysis found a medium transfer benefit for random practice (SMD = 0.55) — [Czyż et al. 2024, Frontiers in Psychology](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2024.1377122/pdf)

### Inferences
- The 85% rule is best used as a sane default, not a law. Its assumptions (binary outcome, a single difficulty parameter, gradient-based learner) loosely match a click-timing hit/miss task, which is probably why it is so often quoted for aim training, but nobody has validated it for mouse aiming. The Aim Lab observation that players self-select ~85-90% hit rate is suggestive, not causal.
- Challenge point + errorless learning suggest a skill-dependent schedule: novices at a higher success band (~85-90%, gentler ramps, fewer walls), experienced players pushed lower (~70-80%) on the specific sub-skill being trained. This is a design hypothesis.
- Because aiming has a speed-accuracy trade-off, "success rate" alone is gameable: a player can hit 95% by slowing down. Difficulty should be controlled on a throughput-like quantity (e.g. time allowed, or target size at a fixed time budget) so the adaptive loop holds hit rate constant while the system reads the resulting speed/size threshold as the skill estimate.
- DDA's known failure mode (player notices rubber-banding, feels patronised) argues for transparent adaptation: show the player the difficulty level as their personal metric ("your threshold target size is now 1.1 degrees"), which doubles as non-leaderboard progress feedback.
- Schedule a short fixed-difficulty probe block (no adaptation, no augmented feedback) at session start or after a delay to measure learning rather than performance.

### Gaps
- No controlled study was found that manipulates target success rate in mouse aiming (or any FPS aim task) and measures retention. The optimal band for aiming is unknown.
- Flow theory (Csikszentmihalyi) and Hunicke's Hamlet DDA system were not retrieved as primary sources; one dissertation snippet criticises DDA research for relying narrowly on flow theory without solid theoretical grounding (not verified further).
- Zohaib & Nakanishi 2018 DDA review appeared only in reference lists; findings not verified.
- Success rates actually used in perceptual-learning studies (commonly staircase convergence points of 70.7-79.4%, see section 2) are documented, but I found no meta-analysis comparing training at different convergence levels.

## 2. Adaptive procedures from psychophysics (staircases, PEST, QUEST/QUEST+, psi)

### Takeaway
Simple transformed or weighted up-down staircases are the practical choice for live difficulty control (robust, no model, converge on a fixed success rate); Bayesian methods (QUEST+, psi) are far more trial-efficient for estimating a player's threshold (tens of trials) but assume a stationary psychometric function, which is violated when the player is learning, warming up or fatiguing.

### Cited Findings
- Transformed up-down rules converge where the probability of a "down" sequence equals 0.5: 2-down/1-up targets sqrt(0.5) = 70.7% correct and 3-down/1-up targets cube-root(0.5) = 79.4% (derivation restated in patent literature describing the Levitt method; one patent misprints 79.7%) — [USPTO patent 9795335](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/9795335)
- García-Pérez (1998, Vision Research 38:1861-1881), by simulation: the convergence point of fixed-step-size staircases depends much more on the ratio of down-step to up-step size than on the up/down rule; the absolute step size does not change the convergence percent-correct if the ratio is constant; convergence to the nominal Levitt targets is not guaranteed and has not been rigorously proved (abstract only) — [García-Pérez 1998](https://doi.org/10.1016/s0042-6989(97)00340-4)
- Stochastic-approximation staircases (shrinking step sizes) have been characterised for small samples in forced-choice threshold estimation — [PubMed 17557595](https://pubmed.ncbi.nlm.nih.gov/17557595/)
- Psi method (Kontsevich & Tyler 1999, Vision Research 39:2729-2737): Bayesian updating over a 2-D threshold x slope posterior with stimulus selection by expected entropy reduction; threshold to within 2 dB (~23%) in fewer than 30 trials for a typical 2AFC task, but equivalent precision on slope needs about 300 trials — [Palamedes toolbox documentation](https://www.palamedestoolbox.org/pal_ampm_demo.html); [Prins research page (psi-marginal variant treats slope/lapse as nuisance parameters)](https://home.olemiss.edu/~nprins/Research.html)
- QUEST+ (Watson 2017, Journal of Vision 17(3):10): generalises QUEST to arbitrary numbers of stimulus dimensions, psychometric parameters (threshold, slope, lapse) and response outcomes — [Watson 2017](https://doi.org/10.1167/17.3.10)
- Independent validation (72 adults): QUEST+ accelerated point-of-subjective-equality estimation relative to constant stimuli and staircases, but sensitivity (slope/JND) from a 64-trial QUEST+ run was overestimated; authors advise caution on slope estimates and note the method is rarely used in practice — [Paire et al., HAL hal-03909075](https://integ04-cnspfv.archimed.fr/doc/OAI_1/oai-HAL-hal-03909075v1)

### Inferences
- Mapping to an aim trainer (speculative): the "stimulus level" can be target angular size, target speed, time-to-live/exposure, flick distance, or strafe unpredictability; the "response" is hit/miss within the time budget. One staircase per (task type x parameter) per player.
- Recommended split: (a) a weighted up-down staircase for moment-to-moment difficulty during training; (b) a Bayesian threshold fit (QUEST+-style, or simply a logistic regression on the accumulated trial log) offline for the skill estimate shown to the player.
- To hit an arbitrary target such as 85% with a 1-up/1-down rule, use asymmetric steps: up-step (harder after hit) = delta, down-step (easier after miss) = delta x p/(1-p), i.e. about 5.7x larger for p = 0.85. This follows the García-Pérez point that the step ratio sets the convergence point (the weighted up-down rule is attributed to Kaernbach 1991; original not retrieved).
- Expect roughly 30-60 trials for a usable threshold; a 60 s flicking run yields 60-200 shots, so one or two runs per parameter is enough for a threshold, but not for slope.
- Bayesian methods assume the threshold is fixed during the run. For a learner, either down-weight old trials (exponential forgetting on the posterior) or re-initialise the prior each session from the previous posterior with inflated variance.
- Interleave two staircases (one starting easy, one hard) so the player cannot perceive and game the rule, and to check convergence.
- Staircases create a visible sawtooth; clamp the maximum change per step to avoid the "steep wall" feeling the project wants to avoid, and never adapt more than one parameter at once within a block.

### Gaps
- Levitt (1971) and Leek (2001) originals were not retrieved; the convergence values above rest on arithmetic plus secondary restatement.
- PEST (Taylor & Creelman 1967) and the original QUEST (Watson & Pelli 1983) were not retrieved. Background knowledge, unverified here: PEST adjusts step size by heuristic rules based on run statistics; QUEST places each trial at the current posterior mode/mean of threshold assuming a fixed Weibull slope.
- No published application of QUEST+/psi to mouse-aiming difficulty was found; all applications above are perceptual thresholds.
- Trial-count benchmarks from Watson's own QUEST+ paper were not extracted.

## 3. Skill modeling and task selection with small data

### Takeaway
For 5-20 users, favour models with very few parameters and strong priors: Elo/Glicko-style player-vs-task ratings, per-skill thresholds from section 2, and a learning-progress bandit (ZPDES-style) over a hand-authored task graph. Full IRT calibration, knowledge tracing fitted by EM, and deep RL need hundreds or more learners and are not practical here.

### Cited Findings
- Elo for education (Pelánek 2016, Computers & Education): treat each attempt as a "match" between learner and item, estimating learner skill and item difficulty online; simple to implement, few parameters, competitive with more complex models; paper surveys variants and gives implementation guidelines — [Pelánek 2016 manuscript](https://www.fi.muni.cz/~xpelanek/publications/CAE-elo.pdf)
- IRT sample size: small samples mainly inflate standard errors; Rasch/1PL is commonly said to give reasonably stable item estimates from about 100 respondents, with several hundred recommended for high-stakes calibration; repeated measurements over many time points partly compensate for few persons — [Rasch Measurement Transactions](https://rasch.org/rmt/rmt74m.htm); [Frontiers in Psychology 2021 small-sample IRT comparison](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2021.633896/pdf)
- Bayesian knowledge tracing: Beck & Chang (2007) reported that different parameter sets can yield the same performance curve; Doroudi & Brunskill (EDM 2017) argue BKT is identifiable under mild conditions and that the real issue is semantic model degeneracy (best-fit parameters contradict the model's conceptual meaning); EM fitting can stick in local optima — [Doroudi & Brunskill 2017](https://bibtex.github.io/EDM-2017-DoroudiB.html); [Properties of the BKT model, JEDM](https://jedm.educationaldatamining.org/index.php/JEDM/article/download/35/pdf_27)
- ZPDES (Clement, Roy, Oudeyer & Lopes 2015, JEDM 7(2):20-48): multi-armed bandit that proposes the activity currently yielding the fastest learning progress, restricted to an expert-defined zone of proximal development graph; requires little prior knowledge of the learner or a cognitive model; evaluated with simulated students and ~400 schoolchildren aged 7-8 — [arXiv 1310.3174](https://arxiv.org/abs/1310.3174)
- ZPDES follow-up RCT (265 children): ZPDES improved learning and learning experience versus a hand-designed curriculum; a variant giving learners some choice was also tested — [Clément et al. 2024, arXiv 2402.01669](https://arxiv.org/html/2402.01669v2)
- Aim-trainer learning dynamics relevant to scheduling: within a day, gains are fastest in the first runs (warm-up); about 65% of day-1 hits-per-second gains were retained to day 2, falling to ~40% after day 10; next-day benefit showed diminishing returns, with 90% of benefit by ~49 one-minute runs and no further benefit beyond ~1 hour; days since last play had near-zero effect on hits per second — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- Spacing in motor tasks: meta-analytic support for distributed over massed practice (overall d = 0.46; effect varies with task and interval) — [Donovan & Radosevich 1999](https://www.gwern.net/docs/spaced-repetition/1999-donovan.pdf)

### Inferences
- Practical stack for a handful of friends (speculative but low-risk):
  1. Each scenario variant gets a difficulty rating; each player gets a rating per skill dimension (e.g. static flick small/large angle, dynamic click-timing, smooth tracking, reactive tracking, target switching). Update with Elo/Glicko-like rules where "win" = beating a par score or, per shot, hit/miss. Glicko-style uncertainty is useful because it tells the UI when an estimate is too uncertain to coach from.
  2. With so few players, task difficulty should be mostly parametric (computed from size, distance, speed, time budget — e.g. a Fitts-style index of difficulty) rather than learned from population data; ratings then only fine-tune.
  3. Task selection: ZPDES-style bandit whose reward is recent learning progress (change in threshold or success rate over the last N attempts) on each skill, with a hand-authored prerequisite graph. Works per player with no population data.
  4. Scheduling: daily sessions capped at about 30-60 minutes; revisit each skill on an expanding interval and use the first block after a gap as the retention probe.
- Multi-dimensional skill models are identifiable only if tasks are designed to isolate dimensions (one varied parameter per task); with N of 5-20, do not attempt to learn the dimensional structure from data (factor analysis), define it by design.
- Spaced-repetition schedulers built for declarative memory (SM-2, FSRS) have no validated mapping to motor skill; the Listman finding that gap length barely affected hits per second suggests forgetting curves are shallow, so the scheduler should be driven by where learning progress is, not by predicted forgetting.

### Gaps
- No published use of Elo/IRT/BKT/ZPDES in aim training was found; all of this is transfer from educational data mining.
- Glicko/Glicko-2 and TrueSkill primary sources not retrieved (background knowledge, unverified here: both add a per-player uncertainty term that grows with inactivity).
- No evidence on spaced-repetition scheduling specifically for motor skills beyond the generic spacing meta-analysis.
- Vendor adaptive engines (Aimlabs, KovaaK's) do not publish their algorithms.

## 4. Kinematic diagnosis from mouse trajectories

### Takeaway
Raw mouse deltas support a well-grounded feature set from motor-control and HCI research: reaction time, primary-submovement speed and endpoint error (under/overshoot), corrective-submovement count, click timing relative to movement, and smoothness. FPS-specific peer-reviewed work exists but is thin (essentially Aim Lab/Statespace papers on 32 pros, a Korean CHI 2021 pro-vs-amateur study, and NVIDIA-affiliated modelling), and the link from any single kinematic feature to a prescriptive drill is not validated.

### Cited Findings
- Donovan et al. 2022 (Frontiers in Human Neuroscience; Statespace-affiliated), 32 professional/semi-pro players, Aim Lab Gridshot (large targets, 1.3-1.7 degrees, speed-rewarding) and Sixshot (targets ~14% of that size, precision-rewarding), camera orientation sampled at 120 Hz — [Donovan et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923)
  - Parsing: velocity thresholds over consecutive samples label in-motion epochs; the largest movement toward the target is the primary movement, later ones are corrective; each epoch is fit with a sigmoid to x(t), y(t); fits with r-squared < 0.5 discarded.
  - Metrics: peak speed (cm/s, from sigmoid derivative); accuracy = signed landing error as % of target distance (negative = hypometric/undershoot, positive = overshoot); precision = variability of that error (median absolute deviation); reaction time = time until movement reaches 5% of its endpoint; "swipiness" = shot time relative to movement midpoint (~0.5 = shooting mid-swipe, >= 1 = flick-and-land).
  - Results: every player was faster and more variable on the large-target task; small-target movements were more hypometric, slower, with later shots and longer reaction times; precision did not differ between tasks. A per-player "motor acuity" (position on the speed-accuracy trade-off) correlated negatively with reaction time and swipiness and positively with speed and precision in both tasks. Fitts' law fit within a task but not across tasks.
  - Conversion: degrees per count from sensitivity, cm from counts/CPI x 2.54; maximum target distance 5.6 cm (wrist/finger range); mouse sensitivity had to be regressed out.
  - Limits: elite-only sample, own hardware, post hoc, proprietary data and algorithm, no directional analysis, no validation against in-game performance.
- Submovement detection in FPS aiming: Ham & Boudaoud (arXiv, April 2026) propose a wavelet-inspired detector for overlapping submovements in 1-D speed profiles, validated on ~6,400 synthetic FPS aim trials modelled on 13 real users, compared against dual-threshold and persistence-based segmentation; background notes extra submovements cost super-linear completion time. Preprint, not peer-reviewed — [arXiv 2604.20673](https://arxiv.org/abs/2604.20673)
- Aim-and-shoot model (Yoon, Moon, Boudaoud, Spjut, Frosio, Lee, Kim; IJHCS 2025): a cognitive-motor simulation model fitted by amortised inference reproduces behaviour of 20 FPS players (10 professionals) on key measures; yields per-player latent parameters rather than descriptive features — [NVIDIA Research](https://research.nvidia.com/publication/2025-04_modeling-visually-guided-aim-and-shoot-behavior-first-person-shoters)
- Pro vs amateur (Park, Lee, Ham, Choi, Kim, Lee; CHI 2021, "Secrets of Gosu"): CS:GO professionals vs amateurs with motion capture, eye tracking and mouse data; only 6 of 13 community conjectures about what distinguishes pros were statistically supported (search snippet only; page did not load) — [DGIST record](https://dgist.elsevierpure.com/en/publications/secrets-of-gosu-understanding-physical-combat-skills-of-professio/)
- Classical motor control basis: Meyer et al. (1988) optimized-submovement model — a fast primary submovement plus optional corrective submovement, trading speed against endpoint variability; Elliott et al. multiple-process model — early impulse regulation plus late limb-target control; primary submovements systematically undershoot because overshoots cost more time/energy to correct — [Multiple Process Model revisited (LJMU)](https://researchonline.ljmu.ac.uk/id/eprint/5736/3/The%20Multiple%20Process%20Model%20of%20Goal-Directed%20Reaching%20Revisited.pdf); [Exp Brain Res 2020](https://link.springer.com/10.1007/s00221-020-05750-w)
- Caution on submovement parsing: a 2024 study questions whether velocity zero-crossing ("type 1") submovements are true corrections or by-products of movement termination — [Roberts et al. 2024](https://researchonline.ljmu.ac.uk/id/eprint/22512/1/s00221-024-06784-0.pdf)
- Smoothness metrics: among common measures only spectral arc length (SPARC) and log dimensionless jerk on velocity (LDLJ-V) meet validity/robustness criteria (Balasubramanian 2012, 2015); both must be computed from velocity; time-domain (jerk) and frequency-domain (SPARC) metrics do not always agree — [Melendez-Calderon et al. 2021](https://pmc.ncbi.nlm.nih.gov/articles/PMC7841375); [comparison study](https://pmc.ncbi.nlm.nih.gov/articles/PMC9919347); [reference implementation docs](https://monalysa.readthedocs.io/en/latest/smoothness.html)
- Attentional focus: instructing an external vs internal focus of attention gave no performance benefit in Aim Lab (43 volunteers, 6 excluded) — [PMC10368276](https://pmc.ncbi.nlm.nih.gov/articles/PMC10368276)

### Inferences
Feature catalogue for a 1000 Hz+ raw-input logger. "Basis" indicates whether the feature itself is established; every "possible reading" is a hypothesis for aiming unless noted.

| Feature | How to compute | Basis | Possible reading |
|---|---|---|---|
| Reaction time | target onset to movement onset (speed threshold or 5% of displacement) | Established (Donovan 2022) | Slow detection/decision; correlates with acuity in pros |
| Time to peak velocity, peak velocity vs distance | from filtered speed profile; regress peak speed on target distance | Established in motor control; used in Donovan 2022 | Flat scaling = under-driving long flicks |
| Primary submovement endpoint error (signed, % of distance) | endpoint of first submovement vs target centre | Established (Meyer; Elliott; Donovan) | Mild undershoot is normal/efficient; consistent overshoot or large undershoot = miscalibrated gain/sensitivity or range effect |
| Endpoint variability (MAD) | spread of primary endpoints | Established | "Precision" independent of bias |
| Corrective submovement count and duration | segment speed profile after primary | Established concept; parsing method contested | Many corrections = time lost in homing phase |
| Path efficiency | straight-line distance / path length | Common HCI measure | Curved paths = axis decoupling, arm-wrist coordination |
| Smoothness | SPARC or LDLJ-V on speed profile | Established in rehab; not validated for mouse aiming | Jerky tracking; tension |
| Click timing | click time relative to movement midpoint/stop and to crosshair entering target | Established (swipiness, Donovan) | Early clicks (pre-arrival misses) vs late clicks (hesitation, over-confirmation) |
| Stop jitter | residual speed/position variance in the 50-150 ms before click | Speculative | Tension, grip, tremor |
| Tracking error, lag, gain | cross-correlation lag between target and crosshair angular velocity; ratio of velocities; time-on-target | Standard manual-control analysis; no FPS paper found | Lagging = reactive rather than predictive tracking; gain <1 or >1 = under/over-following |
| Directional asymmetry | all of the above binned by 8 directions and by distance | Speculative for mouse (vertical asymmetry is established for limb aiming) | Posture/pad/sensitivity issues; weak axis |
| Within-session drift | slope of RT, hit rate, variability over runs | Warm-up established (Listman 2021); fatigue signature speculative | Warm-up needed; stop when declining |

- Sampling: published FPS kinematics used 120 Hz camera samples; a 1000 Hz raw-input logger exceeds the research standard. Low-pass filter (e.g. ~20-50 Hz) before differentiating; raw count quantisation makes jerk very noisy.
- Always convert to physical units (cm on the pad, degrees on screen) using CPI and sensitivity; otherwise players on different sensitivities are not comparable (Donovan had to regress sensitivity out).
- Diagnosis should be relative to the player's own baseline across task conditions (e.g. "your undershoot grows from 4% to 15% on flicks beyond 30 degrees"), because population norms do not exist for N of 5-20 and the published norms are for pros only.
- Given the Roberts 2024 caveat and the CHI 2021 result that most folk conjectures about pro mechanics failed, treat each feature-to-advice mapping as a hypothesis to be tested per player (prescribe a drill, check whether the feature moves).
- Per-trial sigmoid or minimum-jerk fitting is cheap and gives robust speed/endpoint estimates even with noisy data; wavelet/overlapping-submovement decomposition is optional refinement.

### Gaps
- No peer-reviewed work found on direction-specific asymmetries, stop tremor, or tilt/fatigue signatures in mouse aiming specifically.
- No peer-reviewed study of tracking-task kinematics (lag/gain/phase) in FPS aim trainers was found; the manual-control tracking literature (McRuer crossover model) was not retrieved.
- Fitts' law effective width/throughput (ISO 9241-9; MacKenzie; Wobbrock) not retrieved in this session — background knowledge, unverified here: effective width We = 4.133 x SD of endpoints gives a per-player throughput that normalises for the speed-accuracy trade-off.
- AutoGain (Lee, Nancel, Kim, Oulasvirta, CHI 2020) is cited by the wavelet preprint as submovement-efficiency-based gain adaptation; not read directly.
- A direct fatigue/time-on-task study of aim performance was not found. A 2024 Frontiers in Sports and Active Living caffeine study in FPS players (measurements at 60-100 minutes) and a perceived-exertion study were surfaced but not read; exact citations unverified.
- Mouse-dynamics biometrics literature (feature sets for user authentication) not searched; it is a further source of feature definitions.

## 5. Existing "AI coaching" products: marketing vs evidence

### Takeaway
No independent, controlled evidence was found that any commercial AI esports coach (Aimlabs, KovaaK's analytics, Voltaic routines, SenpAI, Mobalytics, Omnic, iTero) improves skill or rank beyond practice itself. What exists is vendor description, community convention, and two vendor-affiliated observational/kinematic papers from the Aim Lab team plus a small independent reliability pilot on KovaaK's.

### Cited Findings
- Aimlabs (Statespace) — VENDOR CLAIM: guided training plans with daily missions matched to the player's skill — [aimlabs.com](https://aimlabs.com). Third-party directory descriptions (unverified, derivative of marketing): an AI coach that analyses performance data to flag weaknesses such as a side bias or slow reaction time and recommends drills/playlists; premium tier (Aimlabs+) — [G2 listing](https://www.g2.com/products/aimlabs/reviews)
- Statespace describes itself as using neuroscience and AI to build a personal esports trainer (company/investor framing) — [Expa portfolio page](https://www.expa.com/companies/statespace)
- Evidence produced by the Aim Lab team: observational learning curves (N = 7,174; no control group, proprietary data) — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full); kinematic skill assessment in 32 pros (proprietary parsing algorithm) — [Donovan et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923). Neither tests whether the product's recommendations cause improvement.
- KovaaK's — independent pilot: 10 FPS players, two sessions 3-5 days apart, four task types (micro flick, macro flick, strafe tracking, wall peeking); ICCs about 0.95-0.995; macro-flick accuracy and hits/s still improved between sessions (learning effect). The paper's literature review cites Aim Lab Gridshot hit-accuracy ICC of 0.62-0.86 — [Rogers et al. 2024, Frontiers in Sports and Active Living](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653)
- Voltaic — community organisation, not AI: publishes benchmark scenario sets for KovaaK's and Aimlabs with score thresholds mapped to ranks (Iron through Celestial across novice/intermediate/advanced tiers) plus training routines; ranks were added to give an incentive to improve; leaderboards rebuilt daily — [Voltaic season 5 announcement](https://blog.voltaic.gg/announcing-the-voltaic-season-5-aiming-benchmarks-beta-for-kovaaks/); [Voltaic leaderboards about page](https://app.voltaic.gg/leaderboards/about)
- iTero (League of Legends) — VENDOR CLAIM: AI coach analysing drafts and recommending runes — [itero.gg](https://www.itero.gg/articles). Mobalytics, SenpAI, Omnic: described as analytics/"personal AI coach" platforms in aggregator listings; no outcome data located — [TechRadar overview](https://techradar.com/computing/artificial-intelligence/can-an-ai-coach-help-your-esports-team-clinch-the-championship)
- The peer-reviewed literature on whether aim training transfers to in-game performance is thin; the only peer-reviewed Aim Lab intervention study found concerned attentional-focus instructions (null result) — [PMC10368276](https://pmc.ncbi.nlm.nih.gov/articles/PMC10368276)

### Inferences
- Commercial "AI coaching" in aim trainers appears to be rule/threshold-based weakness flags over per-task scores plus playlist recommendation. Whether anything more sophisticated runs underneath is undisclosed; treat "AI" as a marketing label unless a method is published.
- The valuable, replicable ideas from these products are structural, not algorithmic: a benchmark battery covering distinct sub-skills (Voltaic's categories), per-category profiles, and routines targeted at the weakest category.
- A small-group trainer can exceed these products on transparency: show the raw evidence behind each coaching statement and track whether the prescribed drill moved the metric.

### Gaps
- No RCT or controlled study of any AI coach's effect on skill or rank was found. No independent audit of Aimlabs' insight accuracy.
- Details of Aimlabs' current coaching features, KovaaK's built-in analytics, and any 2025-2026 LLM-based coach launches could not be verified from primary vendor documentation in this session.
- Transfer from aim-trainer scores to in-game results: no controlled study found; claims in gaming blogs are opinion.

## 6. Feedback design and motivation without leaderboards

### Takeaway
Feedback that helps performance in the moment can hurt learning if the player comes to rely on it (guidance hypothesis); terminal, summarised, reduced-frequency feedback is the safer default once basics are in place. Popular claims about self-controlled feedback and gamification are weaker than usually stated: the self-control benefit largely vanishes after bias correction, and leaderboards/points raise output quantity without clear gains in intrinsic motivation.

### Cited Findings
- Guidance hypothesis: augmented feedback helps when used to reduce error but harms learning when relied upon; learners can come to depend on it at the expense of their own intrinsic feedback; high-frequency feedback produced the poorest retention in Winstein, Pohl & Lewthwaite (1994) — [NAU record](https://experts.nau.edu/en/publications/effects-of-physical-guidance-and-knowledge-of-results-on-motor-le/). Findings on relative feedback frequency are not fully consistent with the guidance view — [PMC3153799](https://pmc.ncbi.nlm.nih.gov/articles/PMC3153799)
- Sigrist, Rauter, Riener & Wolf (2013) review of augmented visual/auditory/haptic feedback: effectiveness depends on task complexity and modality; (full text not read — the specific claim that concurrent feedback helps complex tasks early but risks dependence should be checked against the paper) — [Psychonomic Bulletin & Review](https://doi.org/10.3758/s13423-012-0333-8)
- Self-controlled practice/feedback: naive pooled effect g = 0.44 (52 studies), but only published studies showed a benefit; bias-corrected estimate g = 0.107 and p-curve showed no evidential value — [McKay et al. 2022, Meta-Psychology](https://conferences.lnu.se/index.php/metapsychology/article/view/2803). Robust Bayesian reanalysis: effects of self-controlled practice and enhanced expectancies are small, uncertain and possibly null; average power of included studies ~6% — [McKay et al., Int Rev Sport Exerc Psychol](https://experts.mcmaster.ca/scholarly-works/3559795)
- Gamification of learning meta-analysis (Sailer & Homner 2020, 38 publications/40 experiments): small positive effects on cognitive (g = 0.49), motivational (g = 0.36) and behavioural (g = 0.25) outcomes; designs combining competition with collaboration outperformed those with no social interaction; game fiction helped (effect sizes via secondary summary) — [Educational Psychology Review record](https://opus.bibliothek.uni-augsburg.de/opus4/frontdoor/index/index/docId/109056)
- Mekler, Brühlmann, Tuch & Opwis (2017) experiment isolating points, levels and leaderboards: none significantly affected intrinsic motivation or competence need satisfaction versus control; they increased quantity of output (not quality), i.e. functioned as extrinsic incentives — [Computers in Human Behavior](https://glassmanlab.seas.harvard.edu/annotated_works/mekler17.pdf)
- Leaderboard-specific studies are few and mixed (some positive, some null), and not all participants benefit — [Mekler 2017 and later review cited in search](https://glassmanlab.seas.harvard.edu/annotated_works/mekler17.pdf)
- Aim Lab data: scores were lower in "practice" mode than "compete" mode on the same day, so mode framing changes effort/performance — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- Competition plus collaboration framing (team/cooperative leaderboard) was associated with better motivation outcomes in a gamified flipped classroom (Sailer & Sailer 2021, as cited in secondary review) — [Sailer & Homner record](https://opus.bibliothek.uni-augsburg.de/opus4/frontdoor/index/index/docId/109056)

### Inferences
- Separate two feedback channels: (a) intrinsic task feedback the real game also gives (hit marker, sound) — keep always; (b) augmented coaching feedback (overshoot arrows, ghost paths, live stats) — show terminally after a run or block, summarised over many trials, and fade it as skill grows. Avoid always-on live overlays that will not exist in the real game.
- Bandwidth-style rule (speculative for aiming): only surface a coaching note when a metric is outside the player's own normal band (ties in with section 7 noise thresholds), which naturally reduces feedback frequency as the player improves.
- One or two knowledge-of-performance cues per session, phrased as what happened plus one thing to try; the null attentional-focus result in Aim Lab cautions against assuming any particular cue wording matters.
- Give players choice (drill selection within a recommended set, when to see details) for autonomy and enjoyment, but do not expect a learning benefit from choice itself. ZPDES-with-choice was at least not harmful.
- For a friend group: replace rank leaderboards with personal-progress views (own threshold over time, personal bests with noise bands, streaks of completed sessions) and cooperative goals (group total improvement, shared challenges). This matches the "competition + collaboration" moderator and avoids the pure-extrinsic pattern Mekler observed. Evidence that leaderboards harm learning is not established; the supported claim is only that they are not needed for intrinsic motivation.
- Practice-mode scores are lower than compete-mode scores, so assessment probes should be framed consistently (always the same "test" framing) to keep measurements comparable.

### Gaps
- Self-determination theory primary sources (Deci & Ryan; Ryan, Rigby & Przybylski 2006 on games) and achievement-goal literature (mastery vs performance goals) were not retrieved; no cited effect sizes for mastery-goal framing here.
- Summary/bandwidth feedback primary studies (e.g. Sherwood 1988; Schmidt et al. 1989) not retrieved — background knowledge, unverified here: both generally improved retention relative to every-trial feedback in simple lab tasks.
- No study of feedback schedules in mouse aiming or aim trainers was found.
- No leaderboard-vs-no-leaderboard experiment in a skill-training game with retention outcomes was found.

## 7. Measurement reliability and detecting true improvement

### Takeaway
Composite speed-accuracy scores from short aim tasks are highly reliable day to day (ICC ~0.9+ from 3-5 one-minute runs), raw hit rate much less so; warm-up effects are real, so the first runs of a session should be excluded or modelled. Individual improvement should be declared only when a change exceeds the player's own measurement noise (typical error) and a smallest worthwhile change, not on single personal bests.

### Cited Findings
- Aim Lab Gridshot consecutive-day reliability: hits per second ICC 0.89-0.96 using five runs and 0.88-0.94 using three runs; hit rate ICC 0.74-0.86 (five runs) and 0.62-0.83 (three runs) — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- Variance structure: mixed models explained hits per second with marginal R-squared 0.71 / conditional 0.93; hit rate marginal 0.26 / conditional 0.80 (most hit-rate variance is between players) — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- Warm-up: within a day, performance rises fastest in the first runs (day 1: +0.32 hits/s by run 25); authors hypothesise re-adaptation to sensitivity; with three warm-up runs the maximal next-day benefit occurred at about one hour of practice. Abstract and results disagree on the practice time that yields 90% of benefit (30 min vs ~49 runs/50 min) — [Listman et al. 2021](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2021.777779/full)
- KovaaK's test-retest (10 players, 3-5 days apart): ICC ~0.947-0.995 across four tasks, yet macro-flick accuracy (p = .005) and hits/s (p = .009) improved between sessions, showing practice effects contaminate retests — [Rogers et al. 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC10925653)
- Pro kinematic study used 6 one-minute runs per task after familiarisation and per-player medians with median absolute deviation, because distributions were non-normal — [Donovan et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9744923)
- Sports-science framework for individuals (Hopkins): express noise as the typical error (within-subject SD from repeated tests); define a smallest worthwhile change (default 0.2 x between-athlete SD for test scores; 0.3 x within-athlete competition variability for performance times); when noise exceeds the smallest worthwhile change, report likelihoods that the true change is beneficial/trivial/harmful rather than a point claim — [Hopkins 2004, Sportscience](https://sportsci.org/jour/04/wghtests.htm)
- Establish your own typical error with your own athletes and equipment rather than borrowing published values — [Gore commentary, Sportscience](https://sportscience.sportsci.org/jour/04/cjg.htm)
- Monitoring reviews recommend interpreting individual change against both smallest worthwhile change and typical error together — [Sports Medicine 2015](https://link.springer.com/doi/10.1007/s40279-015-0446-0)
- Threshold estimates need about 30 trials for ~23% precision with Bayesian adaptive methods; slope needs ~300 — [Palamedes/Kontsevich & Tyler](https://www.palamedestoolbox.org/pal_ampm_demo.html)

### Inferences
- Minimum assessment dose per skill per session: discard 2-3 warm-up runs, then 3-5 scored one-minute runs (or about 100+ trials); summarise with median and MAD. This matches the designs that produced ICCs around 0.9.
- Prefer composite or threshold metrics (hits/s, throughput, staircase threshold) for progress tracking; raw accuracy alone is both less reliable and confounded with speed strategy.
- Per-player noise model: after about 5-8 sessions, compute each player's own session-to-session SD per metric (typical error). Flag improvement only when the smoothed estimate (e.g. EWMA or a Bayesian local-level/Kalman model over session medians) moves more than roughly 1.5-2 typical errors and stays there for 2+ sessions. This is the individual-level analogue of smallest worthwhile change and reliable change; with N of 5-20 the between-person SD is unstable, so use within-person noise as the yardstick.
- A simple Bayesian approach suited to small data: model session scores as a latent skill following a random walk plus session noise; report posterior probability that current skill exceeds skill k sessions ago. This directly yields statements like "85% likely you have truly improved since October" and covers the change-detection need without formal change-point machinery.
- Log context to explain variance (time of day, warm-up done, session length, self-rated tiredness, hardware/sensitivity changes); treat a sensitivity or mouse change as a discontinuity that resets the baseline.
- Kinematic sub-features (overshoot bias, corrective count) will be noisier than scores; their reliability is unpublished, so compute split-half reliability on the group's own data before coaching from them.

### Gaps
- Jacobson & Truax reliable change index was not retrieved — background knowledge, unverified here: RCI = (x2 - x1) / (SEM x sqrt(2)), SEM = SD x sqrt(1 - r), |RCI| > 1.96 taken as reliable change.
- Bayesian online change-point detection (Adams & MacKay 2007) not retrieved; no application to aim data found.
- No published reliability figures for kinematic features (endpoint bias, submovement counts, smoothness) in mouse aiming, nor for tracking-task metrics.
- No direct study of time-of-day or fatigue effects on aim-trainer scores was verified.

## 8. A realistic role for LLMs

### Takeaway
The credible role for an LLM is the language layer: turning a deterministic, pre-computed diagnostic profile into plain-language summaries and structured training plans. Diagnosis, statistics and difficulty adaptation should stay in conventional code; evidence from health-coaching LLMs shows quality depends on grounding in the user's actual data and that ungrounded generation can invent events.

### Cited Findings
- PH-LLM (Google; Gemini fine-tuned on wearable data): evaluated on 857 expert-curated sleep and fitness case studies with rubrics covering domain knowledge, use of user data, personalisation and potential harm; base Gemini Ultra approached expert performance on fitness, fine-tuning narrowed the gap on sleep. Inputs were aggregated/textualised sensor summaries, not raw streams — [arXiv 2406.06474](https://arxiv.org/html/2406.06474v1)
- An LLM running-coach thesis (Univ. Twente) concluded that a carefully designed, controlled pipeline around the LLM was preferable to free-form agentic behaviour for reliability (secondary summary of public abstract) — [Univ. Twente thesis summary](https://essay.utwente.nl/fileshare/file/107941/Aliyev%2C%20Vagif_Public_Summary.pdf)
- Reported failure mode in a consumer product: a press report (headline only; article body not retrieved) states Google's AI health coach hallucinated workouts that never happened — [WebProNews](https://www.webpronews.com/googles-ai-health-coach-already-hallucinates-workouts-that-never-happened/)
- Model-based alternatives to LLM diagnosis exist for aiming: simulation models fitted per player by amortised inference recover interpretable motor/perceptual parameters — [Yoon et al. 2025, NVIDIA Research](https://research.nvidia.com/publication/2025-04_modeling-visually-guided-aim-and-shoot-behavior-first-person-shoters)
- Evidence base for the advice content itself is thin (sections 4-6), e.g. attentional-focus cueing showed no benefit in Aim Lab — [PMC10368276](https://pmc.ncbi.nlm.nih.gov/articles/PMC10368276)

### Inferences
Proposed architecture and guardrails (design recommendation; not validated in any aim-training study):
- Pipeline: raw telemetry -> deterministic feature extraction -> statistical layer (baselines, typical error, change probabilities, flags) -> compact JSON "player profile" -> LLM -> rendered coaching note and plan. The LLM never sees raw trajectories and never computes numbers.
- Profile contents: per-skill thresholds with uncertainty, flagged deviations with effect size and confidence, n trials behind each number, trend status (improved / unchanged / unclear), recent drill history and compliance, player-stated goals.
- Guardrails:
  1. Closed drill catalogue: the plan is structured output selecting drill IDs and parameters from an allowed schema; the adaptive engine, not the LLM, sets actual difficulty.
  2. Evidence binding: every claim must reference a metric ID in the profile; a post-check rejects any number or metric name not present in the input.
  3. Uncertainty passthrough: flags below a confidence threshold must be worded as tentative or omitted; "no reliable change yet" is an allowed and expected output.
  4. Advice library: map each flag type to a small set of vetted, hedged explanations and drills written by the developers; the LLM selects, sequences and personalises wording rather than inventing biomechanics.
  5. No medical/ergonomic diagnosis (pain, tremor) beyond suggesting a break or professional advice.
  6. Tone constraints for the "works with the player" goal: self-referenced comparisons only, no ranking against friends unless the player opts in.
- Deterministic fallback: template-based text generated from the same profile should always be available; the LLM is an enhancement, and the comparison (template vs LLM) is an easy internal A/B.
- On-device option: profiles are tiny, so a small local model can do the summarisation; a cloud model needs only the anonymised profile, never raw input logs.
- Closed-loop honesty: record each recommendation and later report whether the targeted metric moved beyond noise; over time this gives the group its own evidence about which drills work for whom, which no vendor currently publishes.
- Other credible ML roles besides LLMs: Bayesian threshold estimation, bandit task selection, state-space trend models (sections 2, 3, 7). Not credible at this scale: end-to-end deep models that diagnose from raw trajectories, or RL coaches, which need orders of magnitude more data than 5-20 users.

### Gaps
- No peer-reviewed evaluation of LLM coaching in esports or aim training was found; no quantified hallucination rate for sensor-grounded coaching LLMs was found.
- Whether the PH-LLM work's journal version exists and its final numbers were not verified against the journal.
- No user study on whether players act on or benefit from LLM-written coaching versus templated feedback in a motor-skill context.
