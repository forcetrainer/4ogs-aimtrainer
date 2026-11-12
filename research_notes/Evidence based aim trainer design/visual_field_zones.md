# Visual Field Structure, Tunnel Vision and Scanning: Evidence for Target Spawn Zones in an FPS Drill

Researcher notes, compiled 2026-11-11. Complements `target_recognition.md` (crowding, clutter, camouflage, prevalence and esports gaze studies are covered there and only cross-referenced here).

Source-status legend (applies to every bullet):
- **[full text]** = the paper's text was read this session (PDF extracted locally or PMC page fetched; long pages were read only to about 100k characters).
- **[abstract/snippet]** = only an abstract, search snippet or a secondary description was seen.
- **[recalled]** = cited from the researcher's prior knowledge; not re-fetched this session. Spot-check numbers before quoting.
- Publication type is given as peer-reviewed / review / preprint / conference / vendor.
- All angles are degrees of visual angle. "Eccentricity" = angular distance from the point of gaze (not from the crosshair) unless stated.

Reference geometry used in inferences (calculated, not sourced): 27-inch 16:9 panel = 59.8 x 33.6 cm. At 60 cm: 26.5 deg to each side, 15.6 deg up/down, 29.8 deg to a corner. 24.5-inch at 60 cm: 24.3 x 14.3 deg half-extents; 24.5-inch at 40 cm: 34.1 x 20.9 deg.

---

## 1. Divisions of the visual field by eccentricity, and how performance falls off

### Takeaway
Anatomical labels exist (fovea, parafovea, perifovea) but performance falls off as a smooth, roughly linear-in-threshold (hyperbolic-in-performance) gradient that is steepest in the first few degrees; there is no natural breakpoint at 5 or 15 deg. For simple detection of a clearly visible onset the eccentricity cost is tiny (about 0.5-2 ms per degree); the large costs are in resolution, crowding and identification.

### Cited Findings

**Named regions (strong, but conventions differ and are diameters, not radii)**
- Strasburger, Rentschler & Jüttner state that the transition from fovea to surround "is smooth" with no well-defined boundary. Following Wandell (1995): foveola 1 deg diameter; fovea 5.2 deg diameter (2.6 deg radius); parafovea about 5-9 deg diameter (to about 4.5 deg radius); perifovea about 9-17 deg diameter (to about 8.5 deg radius); macula about 17 deg diameter. Perimetry calls the central 60 deg diameter the "central visual field". The authors themselves use: foveal < 2 deg eccentricity, "central" < 8 deg radius, peripheral = anything beyond 2 deg. Review, **[full text]** — [Strasburger et al. 2011, Journal of Vision 11(5):13 (PDF)](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Functional differences for form recognition "already occur at a few degrees eccentricity" (Korte 1923, as cited). Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Pöppel & Harvey (1973) perimetry scheme (light-increment thresholds): (A) fovea; (B) perifovea to about 10 deg radius where thresholds rise; (C) a **performance plateau extending to about 20 deg vertically and 35 deg horizontally**; (D) periphery where thresholds rise again to the binocular border; (E) monocular temporal crescent. This is the closest thing in the literature to "breakpoints", and it applies to luminance detection, not to form. Review describing primary data, **[full text]** — [Strasburger et al. 2011, Fig. 8](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- A similar plateau on the horizontal meridian between about 10 and 25 deg is noted for contrast thresholds in the same review (figure caption; exact task context not re-read). Review, **[full text, figure caption only]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- A 2024 correction by the same authors withdraws the common claim that the horizontal field extends only about 90 deg from fixation (it extends further temporally). Not relevant at monitor eccentricities. Peer-reviewed correction, **[abstract/snippet]** — [Corrections to Strasburger et al. (PMC11033599)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11033599/)

**Cortical magnification and E2 (strong, replicated)**
- Thresholds scale approximately as S(E) = S0 (1 + E/E2); E2 is the eccentricity at which the threshold doubles. Human V1 linear magnification estimates: M0 about 18.5-25 mm/deg with E2 about 0.75-0.83 deg (Horton & Hoyt 1991: E2 = 0.75, M0 = 23.07 mm/deg; Schira et al. 2007: E2 = 0.77, M0 = 24.9 mm/deg). Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- E2 values by task (Table 4 of the review; the table extracted with scrambled columns, so per-row source attribution should be re-checked): grating acuity about 2.5-3.0 deg; Landolt-C acuity about 1.0-2.6 deg; vernier acuity about 0.6-0.8 deg; letter acuity 2.3 deg (derived from Anstis 1974: threshold letter height = 0.031 + 0.046 E deg); letter identification 3.3 deg (Higgins et al. 1996); differential motion 1.77 deg (McKee & Nakayama 1984). The review warns against over-interpreting ratios of E2 values. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Size scaling by cortical magnification accounts for 85-97% of variance across seven spatial threshold tasks (Virsu et al. 1987, as cited), but contrast must also be scaled for pattern recognition. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Contrast sensitivity roughly doubles moving from 10 deg to 5 deg eccentricity (Virsu & Rovamo 1979, as cited). Peer-reviewed, **[full text of citing paper]** — [Abrams, Nizam & Carrasco 2012 (PMC3345502)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- Retinal basis: cone density falls about 3.5-fold within the central 1 deg and about 10-fold between 1 and 20 deg; midget retinal ganglion cell density falls about 80-fold between 1 and 20 deg. Peer-reviewed modelling paper, **[full text, first 100k chars]** — [Kupers et al. 2022 (PMC8782511)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8782511/)
- Retinal receptive-field centres of broadband cells grow about 13-fold from fovea (0.1 deg) to 30 deg (1.2 deg). Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)

**Simple reaction time vs eccentricity (moderately strong: several consistent data sets, small effect)**
- Schiefer et al. (2001; 12 young adults): mean slope 1.8 ms/deg out to 30 deg, but non-uniform: **0.5 ms/deg from 0-15 deg, 3.6 ms/deg from 15-20 deg, 1.6 ms/deg from 20-30 deg**. Eccentricity explained 6% of RT variance; between-subject differences explained 13%. Review reporting primary data, **[full text]** — [Strasburger et al. 2011, section 3.6.1](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Poggel et al. (95 subjects aged 10-90; 474 locations to ±27 deg horizontal, ±22.5 deg vertical): 1.66 ms/deg on average. Review reporting primary data, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Osaka (1976, 1978; targets 0.3-1.9 deg, fovea to 50 deg): 1.08-1.56 ms/deg temporal field, 0.84-1.42 ms/deg nasal field. Poffenberger (1912): 0.53 and 0.33 ms/deg. Rains (1963) reported a much steeper 5 ms/deg near the fovea. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Carrasco & Frieder (1997): an RT increase of 0.15 ms/deg between 1.5 and 7 deg was fully neutralised by magnification-scaling the stimuli, i.e. the eccentricity cost is largely a stimulus-size/summation effect. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- A 2022 preprint testing out to 60 deg horizontally reports the added RT delay is proportional to eccentricity. Preprint, **[abstract/snippet]** — [bioRxiv 2022.03.01.482161](https://www.biorxiv.org/content/biorxiv/early/2022/03/05/2022.03.01.482161.full.pdf)

**Temporal resolution**
- Double-pulse resolution thresholds rose from 32.0 ms at the fovea to 51.5 ms at 20 deg (95 subjects; 1.15 deg targets): steep (4.96 ms/deg) to 2.5 deg, shallow (0.5 ms/deg) beyond 5 deg; fairly isotropic. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)

**Eccentricity effect in search and speed of processing**
- Visual search RT and errors rise with target eccentricity at fixed set size; much of the effect disappears with magnification scaling. Peer-reviewed, **[recalled]** — [Carrasco et al. 1995, Perception & Psychophysics](https://doi.org/10.3758/BF03208380)
- Speed of information accrual is not simply slower in the periphery: processing was reported about 22% slower at 4 deg than at 9 deg (Carrasco et al. 2003, as cited) even though sensitivity is lower at 9 deg. Peer-reviewed, **[full text of citing paper]** — [Abrams et al. 2012 (PMC3345502)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- Crowding critical spacing is about 0.5 x eccentricity (Bouma); see `target_recognition.md` for sources and caveats.

### Inferences
- The existing "central < 5 deg" boundary corresponds roughly to fovea + parafovea (4.5 deg radius); there is no anatomical or functional landmark at 15 deg. The perifovea ends about 8.5 deg; the Pöppel-Harvey luminance plateau spans about 10 to 20 deg vertically / 35 deg horizontally. So "5" is defensible as a label, "15" is arbitrary, and a 27-inch monitor at 60 cm lies almost wholly inside the plateau region for plain luminance detection.
- Worked scaling (calculation from S = S0(1+E/E2) with acuity E2 = 2.5 deg): a target must be about 3x larger at 5 deg, 7x at 15 deg and about 11.6x at 26.5 deg to be as resolvable as at fixation. With Bouma spacing, a target at 15 deg is crowded by anything within about 7.5 deg of it.
- Cortical-distance view (calculation using M proportional to 1/(E+0.75)): cortical distance from fixation is proportional to ln(1 + E/0.75). On that scale 0-5 deg is about 57% of the distance to the screen edge at 26.5 deg, 5-15 deg about 28%, and 15-26.5 deg about 15%. Zones of equal width in degrees are therefore very unequal neurally; log-spaced bins (e.g. 0-2, 2-5, 5-10, 10-20, 20+) are more principled than 5/15.
- For a high-contrast pop-in target, the pure sensory RT penalty from centre to the screen edge is on the order of 15-45 ms (26 deg x 0.5-1.8 ms/deg). Any larger eccentricity effect in the drill's time-to-kill is motor (flick distance) or identification/crowding, not detection.
- Schiefer's steeper segment at 15-20 deg (3.6 ms/deg) is the only hint of a kink near 15 deg; it is one n=12 study and should not be treated as a boundary.

### Gaps
- Ringer-style or Carrasco-style eccentricity data for rendered 3D human-shaped targets were not found.
- Strasburger Table 4 column alignment was lost in extraction; per-row E2 source attributions need re-checking against the PDF.
- Contrast sensitivity function by eccentricity (full CSF surfaces, e.g. Baldwin, Meese & Baker 2012 "witch's hat") was seen only as a search snippet: [Aston record](https://publications.aston.ac.uk/id/eprint/17690).

---

## 2. Useful / functional field of view, tunnel vision and trainability

### Takeaway
The functional field is not a fixed disc: it is task-dependent, probabilistic and ranges from about 2-4 deg (hard foveal load, low-contrast targets) through roughly 5-10 deg radius (attentional selection in dense search) to 30 deg (detecting a lone conspicuous target). Load reliably degrades peripheral performance, but whether it narrows the field (tunnelling) or lowers it uniformly (general interference) depends on the load: foveal/visual load tends to tunnel, auditory/cognitive load tends to produce a uniform loss. UFOV-type performance is trainable with large near-transfer; far transfer is real but modest in older drivers and contested for action-game players.

### Cited Findings

**Size and definition**
- Sanders (1970): in a simple detection task observers "barely made eye movements" when the target was within 30 deg of fixation. Kundel et al. (1987): radiologists most effective within 3.5 deg radius for low-contrast nodules; Carmody et al. (1980): detection fell by about half at 5 deg with 300 ms exposures. Peer-reviewed, **[full text]** — [Wu & Wolfe 2022, Vision Research 190:107965 (PMC8976560)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8976560)
- Wu & Wolfe propose three functional visual fields per fixation: Resolution, Attentional, and Exploratory. In dense letter search (1 deg letters, 2.5 deg spacing, display 40.2 x 22.6 deg at 47 cm; Exp 1 n=18, Exp 2 n=12, Exp 3 n=12) a simulated **Attentional FVF of about 8 deg radius (plausible range 5-10 deg)** reproduced hit rates; the field is probabilistic (about 50% chance the next saccade lands on a target 2 deg away; an item at 4 deg has about a 20% chance of being selected in a fixation). Mean search saccades were 4.2-5.1 deg. Guided (conjunction) search enlarged the FVF; harder discrimination lowered hit probability. A horizontal bias in target finding was noted. Peer-reviewed, **[full text]** — [Wu & Wolfe 2022 (PMC8976560)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8976560)
- Ikeda & Takeuchi (1975) as described by later authors: functional field about 4 deg diameter under low foveal load vs about 2 deg under high load in one description; narrower with foveal load and wider horizontally than vertically in another. Peer-reviewed original, **[abstract/snippet of citing papers; numbers second-hand]** — [search summary citing Krasovskaya et al.]; [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)
- UFOV test (Ball et al.): measures the display duration needed to (1) identify a central object, (2) also localise a simultaneous peripheral target, (3) do so among distractors; original research versions placed targets at 10, 20 and 30 deg. Peer-reviewed, **[recalled]** — [Ball, Beard, Roenker, Miller & Griggs 1988, JOSA A](https://doi.org/10.1364/JOSAA.5.002210)

**Shrinkage under load: tunnel vision vs general interference**
- Williams (1985, Human Factors 27:221-227): foveal load (naming letters at fixation) produced "moderate" tunnelling of peripheral detection; some later authors call the evidence only mild. Peer-reviewed, **[abstract/snippet]** — [Human Factors reference page](https://journals.sagepub.com/doi/ref/10.1177/154193128502901209)
- Ringer, Throneburg, Johnson, Kramer & Loschky (2016, Journal of Vision 16(2):7): peripheral Gabors were size-scaled to equate single-task performance across eccentricity, removing the usual confound. Both a foveal load and an auditory working-memory load reduced orientation sensitivity, but **only the foveal load interacted with eccentricity (tunnel vision); auditory load gave a uniform loss (general interference)**. Peer-reviewed, **[abstract/snippet; full text could not be fetched — sample sizes, eccentricities and effect sizes not verified]** — [Ringer et al. 2016 (K-State PDF, link returned 404 on redirect)](https://www.ksu.edu/psych/research/loschky/Ringer_et_al_2016.pdf)
- Gaspar et al. (2016, Human Factors), simulated driving: cognitive-load costs were similar across eccentricities, i.e. general interference. Peer-reviewed, **[abstract/snippet]** — [Gaspar et al. 2016 (PDF)](https://www.ksu.edu/psych/research/loschky/Gaspar_et_al_2016.pdf)
- Rantanen & Goldberg (1999, Ergonomics 42:816-834; n=13; Goldmann perimetry with concurrent tone counting): visual-field **area fell to 92.2% under medium and 86.4% under heavy workload** relative to light load; shape also changed. Peer-reviewed, **[abstract/snippet]** — [Ergonomics abstract](https://informahealthcare.com/doi/abs/10.1080/001401399185315)
- Crundall, Underwood & Chapman (1999, Perception 28:1075-1087; 2002): peripheral-target hit rates fell when driving clips became demanding (hazards); less-experienced viewers had lower hit rates; in the 2002 study the drop was larger but recovered faster in experienced drivers. Peer-reviewed, **[second-hand via full text of citing paper; no numbers]** — [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)
- Seya, Nakayasu & Yagi (2013, i-Perception; n=7 male drivers; gaze-contingent targets at 2.5, 5.0, 7.5 deg in 8 directions during simulated driving): discrimination RT rose with eccentricity (F(2,12)=12.69, p<.01), was slower for upper and upper-left targets and for leftward vs rightward targets; trials with a saccade within 100 ms of target onset were much slower (F(1,6)=106.22). No load manipulation. Peer-reviewed, **[full text]** — [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)
- Easterbrook's (1959) cue-utilisation hypothesis (arousal narrows the range of cues used) is the classical basis for "perceptual narrowing" under stress. Theoretical review, **[recalled]** — [Easterbrook 1959, Psychological Review](https://doi.org/10.1037/h0047707)

**Trainability and transfer**
- Speed-of-processing (UFOV) training in older adults: large gains on the UFOV itself (one small trial: mean change -45.8 ms vs controls, omega-squared = 0.21); in ACTIVE, at-fault state-recorded crash rate was roughly halved over about 6 years and driving cessation was less likely in at-risk participants (HR = 0.51); but transfer to other lab driving measures is mixed (Cars RT yes; hazard perception and maze tests no) and the mechanism for delayed functional effects is unclear. Peer-reviewed, **[abstract/snippet]** — [Frontiers in Aging Neuroscience 2017](https://www.frontiersin.org/journals/aging-neuroscience/articles/10.3389/fnagi.2017.00338/pdf); [PMC3947605](https://pmc.ncbi.nlm.nih.gov/articles/PMC3947605/); [PMC5881723](https://pmc.ncbi.nlm.nih.gov/articles/PMC5881723)
- Green & Bavelier (2006, JEP:HPP 32:1465-1478). Exp 2 (8 action-game players vs 8 non-players, all men; 22 cm viewing distance, chin rest; targets at 10, 20, 30 deg for 6.7-13.4 ms): localisation accuracy 84.3% vs 31.8% without distractors and 73.6% vs 30.0% with distractors; adding a central task dropped non-players from 33.8% to 25.3% but left players unchanged (77.9% to 76.3%). Exp 3 (32 non-players; 30 h Unreal Tournament 2004 vs Tetris): action group improved more in distractor conditions, including at 30 deg. Peer-reviewed, **[full text, first 100k chars]** — [Green & Bavelier 2006 (PMC2896828)](https://pmc.ncbi.nlm.nih.gov/articles/PMC2896828)
- Critiques: Murphy & Spencer (2009) failed to find gamer advantages on UFOV and other tasks; Boot et al. (2008, 2011) failed to replicate training effects and raised expectancy/recruitment confounds. Peer-reviewed, **[abstract/snippet]** — [JASNH Vol 6 No 1](https://www.jasnh.com/pdf/Vol6-No1.pdf); [Boot, Blakely & Simons 2011](https://frontiersin.org/articles/10.3389/fpsyg.2011.00226/full). Meta-analytic estimates and bias corrections are in `target_recognition.md` section 4.

### Inferences
- "Tunnel vision" in FPS play is best modelled as two separable costs: an eccentricity-dependent loss when the *central visual* task gets harder (tracking a target, recoil control, reading a small HUD element), and a uniform loss from non-visual load (comms, planning). The drill can distinguish them: tunnelling = steeper latency/miss slope against eccentricity under load; general interference = intercept shift with unchanged slope.
- Rantanen & Goldberg's area reductions correspond to about 4% and 7% reductions in linear radius if shrinkage were uniform (square root of 0.922 and 0.864; calculation). Load effects on plain detection are small; expect bigger effects on discrimination among distractors (as in UFOV subtest 3 and Green & Bavelier's distractor conditions).
- The non-gamer accuracy of about 30% for 7-13 ms targets among distractors at 10-30 deg versus about 75-85% for gamers is a huge cross-sectional gap (tiny n, selected groups); it suggests a brief-exposure, distractor-laden localisation task has plenty of headroom and individual variation, which is what a per-player "functional field" estimate needs.
- Expect near transfer (to the drill and similar displays) with confidence; do not promise in-game transfer.

### Gaps
- Ringer et al. 2016 and Williams 1985/1988/1995 full texts were not obtained: degrees tested and effect sizes are unverified. Williams 1995 was not located at all.
- No study of functional-field narrowing under *physiological arousal/stress or fatigue* was retrieved this session (Easterbrook is theory; applied stress studies not searched in depth). No data on time-pressure specifically.
- No meta-analysis of UFOV training was fetched (Edwards et al. 2018 is recalled to exist but not verified).
- No functional-field measurement in esports players at monitor distances was found (Green & Bavelier used 22 cm viewing to reach 30 deg).

---

## 3. Visual field asymmetries (horizontal vs vertical, upper vs lower, left vs right)

### Takeaway
At equal eccentricity, vision is best on the horizontal meridian, worse on the vertical, and worst directly above fixation; in threshold contrast tasks the vertical-meridian cost is large (comparable to doubling eccentricity). The effect is strongest within about 30 deg of polar angle from the vertical meridian, grows with eccentricity, spatial frequency and clutter, and is not removed by attention. Evidence that it matters for suprathreshold, abrupt-onset targets on a game screen is thin. Left-right differences are small and inconsistent.

### Cited Findings

**Horizontal-vertical anisotropy (HVA) and vertical meridian asymmetry (VMA) (strong, replicated for contrast sensitivity)**
- Abrams, Nizam & Carrasco (2012; n=14; 6 cpd Gabors at 6 deg eccentricity, 20 polar angles, 4,000 trials each): contrast sensitivity about 63% higher on the horizontal than the vertical meridian; about 65% higher at the lower than the upper vertical meridian (mean sensitivities: North 2.89, South 4.45, East 5.42, West 6.18; East vs West not reliably different). The upper-lower difference declines roughly linearly with angular distance from vertical: reliable at 0, 15 and 30 deg of polar angle, marginal at 45 deg, absent at 67.5 deg. Peer-reviewed, **[full text, first 100k chars]** — [Abrams et al. 2012, Vision Research (PMC3345502)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- At 4.5 deg eccentricity (4 cpd), contrast thresholds on the upper vertical meridian are close to double those on the horizontal meridian, similar to the effect of moving from 4.5 to 9 deg along the horizontal. Himmelberg et al. (2020, n=9): sensitivity about 40% higher horizontal vs vertical and about 20% higher lower vs upper vertical. Peer-reviewed, **[full text, first 100k chars]** — [Kupers et al. 2022 (PMC8782511)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8782511/)
- Prior work (Carrasco, Talgar & Cameron 2001; Cameron, Tai & Carrasco 2002) reports HVA and VMA become **more pronounced with increasing eccentricity, spatial frequency and number of distractors**; the VMA may vanish at low spatial frequencies while the HVA remains. Peer-reviewed, **[second-hand via full text of citing paper]** — [Abrams et al. 2012 (PMC3345502)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- Covert attention improves performance about equally at all iso-eccentric locations, so it does not eliminate the asymmetries. Peer-reviewed, **[full text]** — [Kupers et al. 2022 (PMC8782511)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8782511/)
- Speed: information accrual is faster on the horizontal than vertical meridian and faster below than above; at 4 deg, processing is about 14% slower at North than on the horizontal meridian (Carrasco, Giordano & McElree 2004, as cited). Crowding is stronger in the upper than lower vertical meridian (He, Cavanagh & Intriligator 1996, as cited). Peer-reviewed, **[second-hand via citing paper]** — [Abrams et al. 2012 (PMC3345502)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- Neural/anatomical basis: V1 surface area about 60% larger for horizontal than vertical meridian within the central 8 deg; at 3.5 deg V1 magnification is about 52% higher horizontal vs vertical and about 41% higher lower vs upper; midget ganglion-cell HVA rises from about 20% at 3.5 deg to about 60% at 40 deg and the lower-over-upper asymmetry from about 15% to about 50%. Retinal factors explain only about half of the behavioural HVA and about one-sixth of the VMA. Peer-reviewed, **[full text]** — [Kupers et al. 2022 (PMC8782511)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8782511/); preprint of the cortical study: [bioRxiv 2020.08.26.268383](https://www.biorxiv.org/content/10.1101/2020.08.26.268383.full.pdf)
- Classical perimetry: isopters are elliptical with the long axis horizontal (Aubert & Foerster 1857); the Pöppel-Harvey plateau extends to about 35 deg horizontally but only about 20 deg vertically. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- The functional field under foveal load is wider horizontally than vertically (Ikeda & Takeuchi 1975, as described). **[second-hand]** — [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)

**Upper vs lower field in search and dynamic tasks (mixed)**
- Previc's account: an upper-field bias for visual search/far space and a lower-field bias for near/manual space; Previc & Blume (1993) reported an upper-field advantage in search RT, but reviews note that not all studies show an upward bias and a few show a lower-field bias. Peer-reviewed/reviews, **[abstract/snippet]** — [Previc & Blume, Visual search asymmetries in three-dimensional space](https://researchgate.net/profile/Fred-Previc/publication/14901765_Visual_search_asymmetries_in_three-dimensional_space/links/626df6f10df856128f8bfb44/Visual-search-asymmetries-in-three-dimensional-space.pdf); [PMC6870500](https://pmc.ncbi.nlm.nih.gov/articles/PMC6870500)
- In simulated driving, RT to gaze-contingent targets at 2.5-7.5 deg was slower for upper and upper-left directions (n=7). Peer-reviewed, **[full text]** — [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)

**Left vs right (weak/small)**
- Pseudoneglect: neurologically normal observers show a small leftward spatial bias (Jewell & McCourt 2000 meta-analysis); whether it is stronger in upper or lower field is inconsistent across studies. Review, **[abstract/snippet; effect size not retrieved]** — [PMC6870500](https://pmc.ncbi.nlm.nih.gov/articles/PMC6870500); [Thomas & Elias, upper/lower field differences in perceptual asymmetries](https://researchonline.jcu.edu.au/52466/)
- East vs West contrast sensitivity did not differ reliably (n=14); leftward targets were slower than rightward in simulated driving (n=7). Peer-reviewed, **[full text]** — [Abrams et al. 2012](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502); [Seya et al. 2013](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)

### Inferences
- Yes: performance drops faster vertically than horizontally, and fastest upward. A target 10 deg straight above fixation is, for threshold-level vision, roughly as hard as one well beyond 10 deg to the side. But the asymmetry is concentrated in a wedge of about ±30 deg of polar angle around the vertical meridian; "up-left" or "up-right" diagonals at 45 deg show little of it.
- The big numbers (40-65% sensitivity differences) come from near-threshold Gabors at 4.5-6 deg. For a high-contrast pop-in target the expected directional difference in *detection latency* is small (a few to low tens of ms by analogy with the 14% accrual-speed difference); it should grow when targets are small, low-contrast, brief or surrounded by clutter. Behavioural asymmetry data at 10-25 deg are sparse; the claim that asymmetries keep growing to monitor-edge eccentricities is extrapolation supported by the retinal ganglion-cell trend.
- Because a 16:9 screen at 60 cm only reaches about 16 deg vertically, the "outer" (>15 deg) ring is almost purely lateral (plus corners). Vertical performance can only be compared with horizontal performance inside about 15 deg; ring-level comparisons that pool directions will confound direction with eccentricity.
- Left-right differences are not worth designing around; just balance sides and report a left-right index per player (handedness of mouse movement is likely the larger left-right factor for time-to-kill, which is a motor issue outside this note).

### Gaps
- No study retrieved measured HVA/VMA beyond about 10 deg with suprathreshold onsets, or in game-like scenes.
- Jewell & McCourt effect size not retrieved (recalled as small-to-moderate; verify).
- Himmelberg/Carrasco reviews on polar-angle asymmetries (e.g. Trends in Neurosciences 2023) were not fetched; the Kupers et al. modelling paper and Abrams et al. were used instead.

---

## 4. Gaze and scanning behaviour: where people look, in scenes and in games

### Takeaway
People viewing screens fixate near the centre, move their eyes mainly horizontally, and make mostly small saccades (typically about 4-10 deg, rarely beyond 15 deg); larger re-orientations are done with the head, or in an FPS with the camera. In the one FPS eye-tracking study with numbers, 82-88% of gaze stayed in the central quarter of the screen. The user's observation that people rarely look up or down is consistent with the horizontal saccade bias and with real-world gaze data, but no study quantifying camera pitch or vertical checking in FPS play was found.

### Cited Findings

**Central and horizontal biases (strong, replicated)**
- Central fixation bias persists when image content is not centred and is not explained by a motor bias for small saccades; the first response at scene onset is to orient to screen centre. Peer-reviewed, **[abstract/snippet via later papers]** — [Tatler 2007 as discussed in Frontiers in Psychology 2013](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2013.00624/pdf)
- An anisotropic (horizontally elongated) Gaussian centred on the screen is a good image-independent baseline for fixation distributions across 10 eye-tracking data sets. Peer-reviewed, **[abstract/snippet]** — [Clarke & Tatler 2014, Vision Research (Essex repository)](https://repository.essex.ac.uk/19291/1/1-s2.0-S0042698914001552-main.pdf)
- Viewers of natural images make predominantly horizontal saccades; the bias rotates with the image, so it is tied to scene layout (horizon), and is present even in square images. Peer-reviewed, **[abstract/snippet]** — [Foulsham, Kingstone & Underwood 2008, Vision Research (Essex record)](https://repository.essex.ac.uk/1177/)
- In head-free virtual reality scene viewing, saccade directions were biased parallel to the image horizon regardless of image shape or content; a 2022 follow-up found head orientation also influences saccade directions. Peer-reviewed, **[abstract/snippet]** — [Anderson, Bischof, Foulsham & Kingstone 2020 (PMC7443121)](https://pmc.ncbi.nlm.nih.gov/articles/7443121/); [eNeuro 2022](https://www.eneuro.org/content/eneuro/9/6/ENEURO.0273-22.2022.full.pdf)
- When walking in the real world, gaze is concentrated in a narrow horizontal band around the horizon/path and the head does much of the re-orienting; lab viewing of the same footage spreads gaze differently. Peer-reviewed, **[recalled; not retrieved this session]** — [Foulsham, Walker & Kingstone 2011, Vision Research](https://doi.org/10.1016/j.visres.2011.07.002)

**Saccade amplitudes and eye-head coordination (strong)**
- "Most naturally occurring human saccades have magnitudes of 15 degrees or less" (Bahill, Adler & Stark 1975; title-level only); head-fixed scene exploration typically uses saccades of about 5-10 deg. Peer-reviewed, **[abstract/snippet]** — [PMC2605952 (citing Bahill et al.)](https://pmc.ncbi.nlm.nih.gov/articles/PMC2605952)
- In dense search displays, mean saccade amplitude was about 4-5 deg. Peer-reviewed, **[full text]** — [Wu & Wolfe 2022 (PMC8976560)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8976560)
- Stahl (1999, Exp Brain Res 126:41-54): there is an "eye-only range" of predicted eye eccentricity within which the head does not move, averaging 35.8 deg but with huge individual spread (SD 31.9 deg); beyond it, head movement scales linearly with slope 0.77 ± 0.16. A 2001 follow-up reported an eye-only range of about 30 deg in ten adults. Peer-reviewed, **[abstract/snippet]** — [Stahl 1999 (PubMed)](https://pubmed.ncbi.nlm.nih.gov/10333006)

**Gaze in first-person shooters (small studies; consistent direction)**
- Kenny, Koesling, Delaney, McLoone & Ward (2005, ECMS conference; EyeLink II at up to 500 Hz; custom Torque-engine FPS; twelve data sets, participant count not confirmed from extraction): "near centre" defined as the inner 400x300 px of an 800x600 screen (central half of width and height, 25% of area) received **about 88% of fixations, 86% of fixation time and 82% of game time**; HUD regions (health, messages, score) received about 2% of fixations; the best players averaged 91% near-centre fixations. Authors' interpretation: the crosshair is a natural fixation point and the player uses camera control "as a virtual eye". Conference paper, **[full text; monitor size and viewing distance not stated in extracted text, so degrees unknown]** — [Kenny et al. 2005 (PDF)](https://mural.maynoothuniversity.ie/id/eprint/282/1/Paper04_ECMS_2005.pdf)
- El-Nasr & Yan ("Visual Attention in 3D Video Games"): FPS players concentrate gaze on screen centre, whereas action-adventure players explore the whole screen. Conference paper, **[abstract/snippet]** — [search result summary; see also arXiv 1801.01565 for related FPS eye-tracking](https://arxiv.org/pdf/1801.01565)
- A Computers in Human Behavior study adapted from Counter-Strike 2 reported that targets farther from screen centre were harder to hit quickly and that the final saccade before a shot corresponded to the crosshair's path (i.e. the eyes go to the target and the crosshair follows). Peer-reviewed, **[snippet/press coverage only]** — [PsyPost coverage](https://www.psypost.org/experienced-fps-gamers-show-faster-more-efficient-eye-movements-during-aiming-tasks-study-finds/)
- Pros look at screen centre more and at the radar less; higher-skill VALORANT players have narrower horizontal gaze spread — see `target_recognition.md` section 5 (arXiv 1908.06403; arXiv 2310.15542).

### Inferences
- In Kenny et al.'s terms, "near centre" on a 27-inch monitor at 60 cm would be about ±14 deg horizontally by ±8 deg vertically (calculation; their actual monitor is unknown). So even in FPS play, gaze is typically within roughly 8-14 deg of the crosshair, not locked onto it. Treating crosshair position as gaze position carries an error of several degrees — comparable to the width of the current "central" zone.
- The scanning regime implied by the saccade literature: targets within about 10-15 deg of gaze are normally reached by a single eye saccade and then a mouse flick; beyond that, in real life the head would turn, and in an FPS the camera turns. On a monitor that subtends ±26 deg the eyes alone can reach every on-screen target (within Stahl's average eye-only range), so the drill tests eye-then-mouse orienting, not the "turn the camera to find it" behaviour that off-screen threats require.
- "People rarely look up or down" is supported indirectly (horizontal saccade bias tied to the horizon; elliptical functional field; real-world gaze band) but its FPS-specific form (camera pitch held near the horizon; failure to check elevated positions) is, as far as this search found, design folklore without published measurement. The trainer could log pitch and vertical first-look latency and be the first to quantify it.
- The horizontal bias is partly a property of the scene (it rotates with the image). In a game it will therefore be reinforced by level layouts where threats lie along the horizon band, which argues for treating vertical placement as a scenario property (windows, rooftops, stairs) rather than a fixed percentage.

### Gaps
- No published distribution of camera pitch or vertical gaze in FPS play; no study of players failing to check verticality was found.
- No eye-tracking data for Call of Duty specifically.
- Kenny et al.'s viewing geometry is unknown, so the 82-88% figure cannot be converted to degrees with confidence. The El-Nasr & Yan paper itself was not fetched.
- Real-world walking gaze distributions ('t Hart et al. 2009; Foulsham et al. 2011) were not retrieved; vertical spread numbers are missing.

---

## 5. Detecting abrupt onsets and motion in the periphery

### Takeaway
The periphery is comparatively good at exactly what a pop-in target provides: a luminance transient or motion. Simple RT to a visible onset rises only about 0.5-2 ms per degree, saccadic latency is roughly flat across the mid-range of eccentricities (rising at very small and very large ones), and motion thresholds scale with eccentricity more gently than form acuity when stimuli are large enough. A drill built on abrupt onsets therefore under-measures the eccentricity gradient that matters for recognising a static or slowly emerging enemy.

### Cited Findings
- Simple manual RT slopes with eccentricity: 0.5 ms/deg (0-15 deg) to about 1.8 ms/deg overall; see section 1. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Part of the RT increase reflects reduced spatial summation for small targets (0.43 deg and 1 deg targets are a fraction of peripheral receptive-field size); magnification-scaled stimuli abolish small RT slopes. Review, **[full text]** — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Saccadic latency vs eccentricity: latencies increase at very small and at large eccentricities (U-/bowl-shaped); some non-gap studies report increases up to about 60 ms with eccentricity, while others find latency invariant over a wide range of target displacements; target size relative to step size and the gap paradigm (fixation offset before target) modulate latency. Peer-reviewed/review, **[abstract/snippet]** — [BMC Neuroscience 2001, 2:13](https://bmcneurosci.biomedcentral.com/counter/pdf/10.1186/1471-2202-2-13); [review (HAL)](https://hal.univ-lille.fr/hal-03272217/document)
- Motion: differential motion thresholds are smaller than the minimum angle of resolution at every retinal location tested, but the stimulus size needed for the best threshold grows from about 1 deg at the fovea to about 20 deg at 40 deg eccentricity. E2 for differential motion about 1.77 deg (as tabulated by Strasburger). Peer-reviewed, **[abstract]** — [McKee & Nakayama 1984, Vision Research (PubMed)](https://pubmed.ncbi.nlm.nih.gov/6695503/); [Strasburger et al. 2011, Table 4](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- A lone conspicuous target is detected without eye movements out to about 30 deg (Sanders 1970, as cited). Peer-reviewed, **[full text of citing paper]** — [Wu & Wolfe 2022 (PMC8976560)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8976560)
- Discrimination RT is strongly slowed when a saccade happens to occur within 100 ms of target onset (saccadic suppression/intrusion), n=7. Peer-reviewed, **[full text]** — [Seya et al. 2013 (PMC3859571)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)
- Abrupt onsets and motion onsets capture attention; continuous motion is weaker — covered in `target_recognition.md` section 1 (Yantis & Jonides 1984; Franconeri & Simons 2003; [recalled] there).

### Inferences
- With pop-in spawning, the measured "eccentricity effect" on first-movement latency should be nearly flat (tens of ms across the whole screen). A flat slope in the drill would not show that the player has a wide functional field; it would show that onsets are easy. To expose the functional field the target's appearance must not hand the visual system a unique transient: e.g. fade-in over about 0.5-1 s, spawn during a whole-screen transient or camera cut, spawn simultaneously with distractor onsets, or require a discrimination (enemy vs friendly) rather than detection.
- Because saccadic latency is not shortest for the nearest targets, very small eccentricities (under about 1-2 deg) may show slightly *slower* eye responses; do not expect monotonic behaviour right at the crosshair.
- Trials on which the player was mid-saccade or mid-flick at spawn time will be slow for reasons unrelated to eccentricity; spawn timing should be conditioned on a stable crosshair (and ideally stable gaze), or such trials flagged.

### Gaps
- No direct study of detection/orienting latency to abrupt onsets at 5-25 deg on a gaming monitor with game-like stimuli was found.
- Motion-onset detection thresholds vs eccentricity (as opposed to differential motion) were not retrieved in quantitative form; "motion holds up better than form" rests on McKee & Nakayama's abstract plus E2 comparisons and is moderately supported, not precisely quantified here.
- Kalesnykas & Hallett (1994) and Wyman & Steinman (1973) primary data on latency by eccentricity were not read.

---

## 6. Monitor-specific considerations

### Takeaway
There is no measured data set of gamers' viewing distances; vendor guidance clusters around 50-75 cm for 24-27-inch monitors, which puts the screen edge at roughly 20-30 deg horizontally and 12-18 deg vertically. Research on monitor size concerns aiming, not peripheral detection; nothing was found on curvature. Game FOV compresses the world onto the screen, so retinal eccentricity must be computed from screen position and viewing distance, never from in-game angles.

### Cited Findings
- Vendor/SEO guides recommend about 50-75 cm (some 60-90 cm) for 24-24.5-inch esports monitors and assert players settle near 60 cm; these are recommendations, not measurements. Vendor content, **[snippet]** — [KTC guide](https://us.ktcplay.com/blogs/desk-setups/ideal-viewing-distance-24-5-inch-fps-monitor)
- Spjut et al. (NVIDIA; 12.5- to 27-inch displays, FPS aiming): larger displays gave small aiming-time benefits attributed to a combination of size, resolution and the player's natural viewing distance. Preprint/conference, **[abstract/snippet]** — [arXiv 2305.16953](https://doi.org/10.48550/arXiv.2305.16953) (also in `target_recognition.md` section 6)
- Lab UFOV studies reach 30 deg by seating observers very close (22 cm with chin rest), which is not a gaming posture. Peer-reviewed, **[full text]** — [Green & Bavelier 2006 (PMC2896828)](https://pmc.ncbi.nlm.nih.gov/articles/PMC2896828)

### Inferences (geometry; calculated, not sourced)
- Half-extents in degrees: 24.5-inch at 60 cm = 24.3 H x 14.3 V; 27-inch at 60 cm = 26.5 H x 15.6 V; 27-inch at 50 cm = 30.9 H x 18.6 V; 27-inch at 75 cm = 21.7 H x 12.6 V; 24.5-inch at 40 cm (a close "tournament" posture) = 34.1 H x 20.9 V. A ±10 cm change in viewing distance moves the screen edge by about 4-5 deg, so viewing distance must be measured or calibrated, and a fixed 15-deg boundary means different screen positions for different players.
- Retinal eccentricity on a flat screen is atan(r/d) where r is the on-screen distance from the gaze point and d the viewing distance; equal pixel steps are smaller angular steps toward the edges (at 60 cm, the outer 5 cm of a 27-inch panel spans about 3.7 deg versus 4.8 deg for 5 cm at the centre).
- Game FOV: with horizontal FOV F on a screen of half-width W, a world direction at angle theta from the view axis lands at x = W tan(theta)/tan(F/2), and its retinal eccentricity is atan(x/d). Example (27-inch, 60 cm, F = 120 deg): an enemy 30 deg off-axis in the world appears only 9.4 deg from the crosshair on the retina; 60 deg off-axis appears at the 26.5 deg screen edge. High FOV therefore pulls flanking enemies *into* nearer retinal eccentricities but shrinks them (see the FOV size geometry in `target_recognition.md` section 6): eccentricity gets easier, size and crowding get harder.
- A flat monitor cannot stimulate beyond about 25-35 deg, i.e. it never reaches the far periphery (the field extends past 90 deg temporally). "Outer zone" on a monitor is mid-periphery in vision-science terms.

### Gaps
- No peer-reviewed measurement of esports players' viewing distance or subtended angle was found.
- No research found on curved or ultrawide monitors and peripheral target detection in games, nor on game FOV setting versus detection (same gap as in `target_recognition.md`).

---

## 7. Design implications for the drill (all inference unless a citation is attached)

### Takeaway
Log eccentricity and polar angle continuously per trial and fit a per-player curve; use zones only as reporting bins, preferably log-spaced. Sample directions so vertical vs horizontal can be compared at matched eccentricity, separate first-movement latency from flick time, add a central-load condition to measure narrowing, and remove the abrupt-onset shortcut on a subset of trials. Without gaze data, eccentricity is known only to within several degrees, so either constrain gaze with a central task or add an eye tracker.

### Cited Findings (evidence each recommendation rests on)
- No sharp boundaries; thresholds scale as (1 + E/E2); luminance-detection plateau from about 10 to 20 deg V / 35 deg H. — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Simple RT slope about 0.5 ms/deg inside 15 deg, 1.7-1.8 ms/deg overall; subject differences exceed eccentricity effects. — [Strasburger et al. 2011](https://publications.aston.ac.uk/id/eprint/23648/1/jov_11_5_13.pdf)
- Attentional functional field about 5-10 deg radius in dense search and probabilistic; a lone target detectable to 30 deg. — [Wu & Wolfe 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC8976560)
- Foveal load tunnels; auditory load interferes uniformly. — [Ringer et al. 2016 (abstract)](https://www.ksu.edu/psych/research/loschky/Ringer_et_al_2016.pdf); [Gaspar et al. 2016](https://www.ksu.edu/psych/research/loschky/Gaspar_et_al_2016.pdf)
- Vertical meridian (especially upward) is worst; asymmetry confined to about ±30 deg polar angle; grows with eccentricity, spatial frequency, distractors. — [Abrams et al. 2012](https://pmc.ncbi.nlm.nih.gov/articles/PMC3345502)
- FPS gaze: 82-88% within the central half-width/half-height of the screen; eyes lead the crosshair to targets. — [Kenny et al. 2005](https://mural.maynoothuniversity.ie/id/eprint/282/1/Paper04_ECMS_2005.pdf); [PsyPost coverage of CS2 study](https://www.psypost.org/experienced-fps-gamers-show-faster-more-efficient-eye-movements-during-aiming-tasks-study-finds/)
- Webcam gaze estimation (WebGazer-class) error is typically about 4 deg (4.17 deg in the original benchmark; 3.65 ± 0.77 deg in one validation, with drift), versus about 0.5-1 deg for infrared trackers; one Gorilla-based study reported under 1 deg validation error, which conflicts and probably reflects a different error definition. Mixed peer-reviewed/thesis/vendor, **[snippet]** — [WebGazer paper (NSF PAR)](https://par.nsf.gov/servlets/purl/10024076); [Utrecht thesis](https://studenttheses.uu.nl/handle/20.500.12932/40709); [arXiv 2608.08947](https://arxiv.org/pdf/2608.08947)
- Saccades overlapping target onset slow responses. — [Seya et al. 2013](https://pmc.ncbi.nlm.nih.gov/articles/PMC3859571)

### Inferences

**Zone boundaries**
- Strength of evidence for the current scheme: "central < 5 deg" = reasonable label (fovea + parafovea radius 4.5 deg); "mid 5-15" and "outer > 15" = convention, not evidence. If fixed zones are kept, more defensible reporting bins are: 0-2.5 deg (foveal), 2.5-5 (parafoveal), 5-10 (perifoveal / typical attentional field in clutter), 10-20 (single-saccade range, plateau region), > 20 (screen edge, lateral only). These are roughly equal steps on a cortical/log scale.
- Preferred: store exact eccentricity (deg), polar angle, target angular size and screen position per trial; spawn eccentricities from a continuous distribution (uniform in log(1 + E/0.75) or stratified across the bins above so that central trials are not starved by area weighting); fit per player latency = a + b*E (and miss probability as a logistic in E) separately by direction sector. Bins are then just a display choice.
- Define zones in degrees from the *crosshair at spawn* but record them as "crosshair eccentricity", and reserve "retinal eccentricity" for trials with gaze data.

**Direction weighting**
- There is no evidence for "30% above". Two separate goals need different sampling: (a) *measurement* — sample polar angle uniformly (or equal counts in 8 sectors) at matched eccentricities up to the vertical limit (about 14-15 deg), so upper/lower/left/right can be compared without confounding by eccentricity; (b) *training* — over-sample each player's weak sectors and, ideally, mirror the vertical distribution of threats in the target game's maps (unknown; would have to be measured from the game).
- Expect the largest deficit straight up, a smaller one straight down, little on the 45-deg diagonals (by extrapolation from contrast-sensitivity data at 6 deg). Include targets within ±30 deg of the vertical meridian specifically, not just "upper half".
- Outer-ring trials are necessarily left/right (and corners); report them separately from vertical performance.

**What to measure**
- Per trial: spawn time, first-movement latency (first mouse movement exceeding a small velocity threshold toward the target), movement time, time-to-hit, initial movement direction error, hit/miss/timeout, crosshair stability before spawn, target size (deg), eccentricity, polar angle, onset type, load condition, frame timing.
- Per player: (1) intercept and slope of first-movement latency vs eccentricity (ms/deg); benchmark: for pure onsets expect roughly 0.5-2 ms/deg, so much steeper slopes indicate something other than sensory detection; (2) a "functional field" estimate = eccentricity at which detection (or correct discrimination) within a deadline falls to a criterion such as 75%, measured with brief, small or non-transient targets among distractors, in the spirit of UFOV subtest 3; (3) asymmetry indices: (horizontal - vertical)/(horizontal + vertical) and (lower - upper)/(lower + upper) at matched eccentricity, plus left-right; (4) load effects (below).
- Separate perception from aiming: time-to-kill grows with distance mainly through flick amplitude (Fitts-type motor cost), so use first-movement latency and initial direction accuracy, not time-to-kill, as the perceptual measures.

**Testing narrowing under load**
- Dual-task design: a central task at the crosshair at two difficulty levels (e.g. track a small moving target and respond to a subtle feature change; or a rapid digit/letter stream discrimination) while peripheral targets appear at varied eccentricity. Compare slope and intercept of the latency/miss functions between load levels: slope increase = tunnelling (predicted for central visual load), intercept shift = general interference (predicted for an auditory/cognitive load such as counting tones or callouts). Size-scale peripheral targets with eccentricity (factor 1 + E/E2) in at least one condition so that baseline visibility is equated, as Ringer et al. did; otherwise floor effects at far eccentricities masquerade as tunnelling.
- Require central-task accuracy to be maintained and report it, to rule out trade-offs (Green & Bavelier's centre-task comparison is the model).
- Expect modest effects for plain detection (field-area reductions of about 8-14% in perimetry under tone-counting load) and larger ones for discrimination among distractors.

**Gaze: is a webcam estimate or eye tracker needed?**
- Without gaze data the drill measures eccentricity relative to the crosshair, which is wrong by the gaze-crosshair offset. FPS gaze stays within the central quarter of the screen most of the time but that region is itself about ±14 x ±8 deg on a 27-inch monitor at 60 cm, so the error can equal or exceed the 5-deg central zone.
- Options, cheapest first: (1) behavioural control — make the player hold a central task on the crosshair and spawn only when the crosshair (and central-task performance) has been stable for a few hundred ms; this makes crosshair eccentricity a fair proxy and matches the "gaze parked on crosshair, detect peripherally" expert pattern; (2) webcam gaze (about 4 deg error, drift) — good enough to label trials "gaze near crosshair" vs "gaze elsewhere" and to tell which side of the screen gaze was on, not good enough to place a 5-deg boundary; (3) a consumer infrared tracker (about 0.5-1 deg class per the sources above) — needed only if the goal is true retinal-eccentricity curves or gaze-contingent spawning.
- In serial target drills the eyes normally jump to the next target before the mouse does; if the next target spawns while the eyes are still on the previous target, gaze is approximately at the crosshair at spawn time. If several targets are visible at once, gaze will already be on a later target and crosshair eccentricity is meaningless for it. Prefer one-at-a-time spawning with a randomised foreperiod for measurement blocks.

**Limits because spawns are abrupt onsets**
- Pop-in targets are detected nearly equally fast across the monitor; they measure orienting and motor speed and will make the functional field look as large as the screen. Keep them as the "easy" baseline and add non-transient reveals for the recognition measure (slow fade-in, reveal during a global transient or camera move, target already present when the view turns, several simultaneous onsets with only one enemy, static low-contrast targets).
- Do not interpret a flat latency-eccentricity slope under pop-in as wide awareness; and do not interpret differences of under about 20-40 ms between zones without many trials, because between-subject and trial-to-trial RT variance dwarfs the eccentricity effect (eccentricity explained 6% of RT variance in Schiefer et al.).
- Mask or exclude trials where the player was moving the crosshair at spawn, since saccades/flicks around onset inflate latency.

### Gaps
- None of the proposed bins, criteria (75%), stability windows or scaling factors has been validated in a game setting; they are starting values.
- No evidence was found on what proportion of real CoD engagements occur at which retinal eccentricities or elevations; "ecological" spawn weighting cannot yet be set from data.
- Consumer infrared eye-tracker accuracy during fast FPS play (head movement, close viewing distance) was not researched this session.
- Whether a per-player functional-field or asymmetry index is stable across sessions (test-retest reliability) is unknown and should be checked before showing it to users as a trait.
