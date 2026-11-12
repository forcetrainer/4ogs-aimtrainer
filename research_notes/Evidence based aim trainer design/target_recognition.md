# Target Recognition: Visual Search, Camouflage Detection, and Perceptual Learning for FPS Enemy Spotting

Researcher notes, compiled 2026-11-11.

Source-status legend (applies to every bullet):
- No tag = source was retrieved by search/fetch in this session (mostly abstract- or snippet-level; full texts were generally NOT read).
- **[recalled]** = classic paper cited from the researcher's prior knowledge; the DOI link was not re-fetched this session. Numbers in these bullets should be spot-checked before being quoted in a final report.
- **[attribution uncertain]** = the search tool's summary linked a claim to a URL, but the mapping between claim and exact paper could not be confirmed.

---

## 1. Core visual search findings: why players fail to see targets ("I didn't see him")

### Takeaway
"I didn't see him" has at least five separable causes that are each well established in the lab: (a) the target was never fixated and was too crowded/low-contrast to be resolved in the periphery, (b) the target resembled the background/distractors so guidance was poor, (c) the player quit searching early because targets are rare in that spot (prevalence), (d) attention was committed elsewhere (inattentional blindness, subsequent-search misses after finding a first enemy), and (e) the player was not looking where scene context said to look. Most of these are strong, replicated effects; none has been measured directly inside a commercial FPS.

### Cited Findings

**Feature vs conjunction search, guidance, similarity (strong, replicated)**
- Feature Integration Theory: targets defined by a single unique feature (e.g., colour) are found with little set-size cost ("pop-out"), while conjunction targets show search time rising with the number of items. **[recalled]** — [Treisman & Gelade 1980, Cognitive Psychology](https://doi.org/10.1016/0010-0285(80)90005-5)
- Search efficiency falls continuously as target-distractor similarity rises and as distractor-distractor similarity falls (heterogeneous backgrounds); there is no sharp serial/parallel dichotomy. **[recalled]** — [Duncan & Humphreys 1989, Psychological Review](https://doi.org/10.1037/0033-295X.96.3.433)
- Guided Search 6.0: attention is steered by a priority map combining bottom-up salience, top-down feature guidance, history/priming, reward, and scene guidance; a "functional visual field" around fixation limits what can be identified per fixation; and a quitting threshold decides when to give up. **[recalled]** — [Wolfe 2021, Psychonomic Bulletin & Review](https://doi.org/10.3758/s13423-020-01859-9)

**Clutter, crowding, eccentricity (strong, replicated)**
- Crowding is not just peripheral acuity loss; it reflects peripheral vision's vulnerability to clutter and affects search, object recognition and reading. — [Rosenholtz, Annual Review of Vision Science 2016 (listing)](https://annualreviews.org/doi/abs/10.1146/annurev-vision-082114-035733)
- Bouma's rule: critical spacing for identifying an object among neighbours is roughly half its eccentricity; Pelli & Tillman argued identification among similar objects depends on the spacing/eccentricity ratio. — [Pelli & Tillman 2008, Nature Neuroscience (PDF)](https://www.cns.nyu.edu/~msl/courses/2223/Readings/Pelli-NatNeurosci2008.pdf)
- The "law" status is contested: later reviews question whether critical spacing is independent of stimulus, task and attention, and show crowding depends on configural/grouping factors. — [Nature Reviews Psychology review (s44159-022-00097-1)](https://link.springer.com/10.1038/s44159-022-00097-1); [PMC4429926](https://pmc.ncbi.nlm.nih.gov/articles/PMC4429926)
- Clutter can be quantified from the image (feature congestion, subband entropy, edge density) and these measures predict search difficulty. **[recalled]** — [Rosenholtz, Li & Nakano 2007, Journal of Vision](https://doi.org/10.1167/7.2.17)
- Eccentricity effect: search RT and errors rise as the target appears farther from fixation, even with set size held constant. **[recalled]** — [Carrasco et al. 1995, Perception & Psychophysics](https://doi.org/10.3758/BF03208380)

**Target prevalence (strong, replicated; mechanism debated)**
- Wolfe, Horowitz & Kenner (2005): miss rate was about 0.46 at 2% prevalence vs about 0.20 at 50% prevalence (figures as summarised by a secondary source). — [Prevalence effect (Wikipedia summary)](https://en.wikipedia.org/wiki/Prevalence_effect); original **[recalled]**: [Nature 2005](https://doi.org/10.1038/435439a)
- Leading account: low prevalence lowers the quitting threshold (fewer items inspected before "absent") and shifts decision criterion; Rich et al. (2008) found premature termination in spatial-configuration search and response errors in feature search. — [Prevalence effect (Wikipedia summary)](https://en.wikipedia.org/wiki/Prevalence_effect)
- Competing account: part of the effect is motor/response error (habitual "absent" keypress); allowing correction reduces it. — [Fleck & Mitroff 2007 (PDF)](https://psych.unl.edu/mdodd/Psy498/FleckMitroff.pdf)
- Prevalence effect is "stubborn" (survives many manipulations) but brief bursts of high-prevalence trials with feedback can reset the criterion. **[recalled]** — [Wolfe et al. 2007, JEP: General](https://doi.org/10.1037/0096-3445.136.4.623)
- A 2026 VSS poster reported the low-prevalence effect appeared only when trial feedback was given (unreviewed conference abstract; treat as preliminary). — [VSS 2026 presentation 4228](https://www.visionsciences.org/presentation/?id=4228)
- In a very large mobile-game dataset (Airport Scanner), "ultra-rare" targets (very low prevalence) were missed far more than common ones. **[recalled]** — [Mitroff & Biggs 2014, Psychological Science](https://doi.org/10.1177/0956797613504221)

**Satisfaction of search / subsequent search misses (strong in radiology and lab)**
- Finding one target makes a second target in the same display less likely to be found; Adamo, Cain & Mitroff (2013) renamed this "Subsequent Search Misses" because early quitting is not the full explanation (Berbaum et al. 1991). — [Cognitive Research: Principles and Implications 2017 (s41235-017-0072-5)](https://cognitiveresearchjournal.springeropen.com/track/pdf/10.1186/s41235-017-0072-5)

**Inattentional blindness, change blindness (strong, replicated)**
- 24 radiologists searching chest CTs for nodules: 83% failed to notice an inserted gorilla 48x the size of an average nodule; expertise did not protect. — [Radiology Today summary of Drew, Võ & Wolfe 2013](https://www.radiologytoday.net/archive/rt0421p22.shtml); original **[recalled]**: [Psychological Science 2013](https://doi.org/10.1177/0956797613479386)
- About half of observers counting basketball passes missed a person in a gorilla suit crossing the scene. **[recalled]** — [Simons & Chabris 1999, Perception](https://doi.org/10.1068/p281059)
- Large scene changes go unnoticed when the motion transient is masked (flicker paradigm); attention is required to perceive change. **[recalled]** — [Rensink, O'Regan & Clark 1997, Psychological Science](https://doi.org/10.1111/j.1467-9280.1997.tb00427.x)

**Attentional capture by onsets/motion (strong; details debated)**
- Abrupt onsets capture attention relatively automatically. **[recalled]** — [Yantis & Jonides 1984, JEP:HPP](https://doi.org/10.1037/0096-1523.10.5.601)
- Motion onset and looming capture attention; continuous motion per se is weaker. **[recalled]** — [Franconeri & Simons 2003, Perception & Psychophysics](https://doi.org/10.3758/BF03194829)
- Consistent applied result: for camouflaged moving soldiers, "motion onset and not motion itself" was the important attention-capturing feature. — [Adaptive camouflage of moving targets, Journal of Perceptual Imaging 2021 (VU listing)](https://research.vu.nl/en/publications/adaptive-camouflage-of-moving-targets/)

**Scene context guidance (strong)**
- The Contextual Guidance model combines bottom-up saliency with global scene "gist" to predict where observers fixate when searching real scenes, without requiring object segmentation. — [Torralba, Oliva, Castelhano & Henderson 2006, Psychological Review](https://people.csail.mit.edu/torralba/GlobalFeaturesAndAttention)
- In a person-detection search over 912 outdoor scenes, saliency, target features, and scene context each independently predicted human fixations above a cross-image control (combined model best). — [Ehinger et al. 2009 (PMC2790194)](https://pmc.ncbi.nlm.nih.gov/articles/PMC2790194)

### Inferences
- A mapping from mechanism to FPS failure, useful as a drill taxonomy: (1) **peripheral/crowding miss** — enemy visible but in clutter away from crosshair; (2) **similarity/guidance miss** — operator skin matches wall/foliage; (3) **prevalence/quitting miss** — player glances at a rarely occupied angle and leaves too early; (4) **subsequent-search miss** — second enemy missed after engaging the first; (5) **inattentional miss** — attention on HUD/minimap/reload/looting; (6) **context miss** — enemy in an "off-angle" where scene priors do not send gaze. Off-angles exploit exactly the contextual-guidance mechanism.
- Because the central functional visual field is small in clutter, the crosshair-relative eccentricity of a target at appearance is likely the single most important controllable variable in a detection drill.
- Motion onset (a peek) should be far easier to detect than a static holder; "static, partially occluded, low-contrast" is the hard case and where training value is highest.
- Trial feedback itself may shape quitting thresholds (per the 2026 poster), so feedback design is not neutral.

### Gaps
- No study was found that decomposes real FPS deaths into these miss categories; the taxonomy is an extrapolation from lab/radiology/baggage data.
- Võ's "scene grammar" work was searched for but not retrieved; not cited.
- Quantitative crowding/clutter data for rendered 3D game scenes (as opposed to letters, Gabors, or photographs) were not found.

---

## 2. Camouflage detection: what makes it hard, and is camouflage-breaking trainable?

### Takeaway
Camouflage works through background matching and disruption of the outline; both reliably slow human detection of static targets, and motion (especially motion onset) largely removes the detection advantage though not the identification cost among similar distractors. Camouflage-breaking is trainable in the lab with gains that last months, but transfer is strongest to backgrounds/targets resembling the trained ones — the strongest direct argument for game-like art in a trainer.

### Cited Findings

**What makes camouflaged targets hard**
- In four touch-screen experiments with human searchers, disruptive coloration was the most effective concealment overall, especially with relatively high-contrast patterns; camouflage types also differed in how quickly searchers learned to defeat them. — [Troscianko et al. 2013, PLoS ONE (PMC3769369)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3769369)
- Field study with human targets: camouflage patches disrupting the head outline significantly increased detection time compared with a similar target concealed only by background matching. — [Selj 2015, SPIE / FFI](https://www.ffi.no/publikasjoner/arkiv/disruptive-camouflage-tricks-the-human-eye-a-study-of-detection-times-of-two-near-similar-targets-in-natural-backgrounds)
- Observers were slower to find targets with "fake" depth edges, but the effect disappeared when binocular depth cues were available (on a flat monitor there is no stereo, so edge-disruption effects should apply fully). — [Adams, Graf & Anderson 2019, Proc. R. Soc. B (Southampton eprint)](https://eprints.soton.ac.uk/427679)
- Hall et al. (2013), static targets: all camouflage patterns lengthened response times vs plain control (pattern effect F(7,63)=31.21, p<.001; n=10, 240 trials each); background matching and disruptive patterns were best, especially for larger targets (sizes 1.0°, 1.4°, 2.0°). — [Hall et al. 2013, Proc. R. Soc. B (PMC3619462)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3619462)

**Motion and camouflage**
- Same study, moving targets: no effect of camouflage pattern on capture time (F(7,63)=1.62, p=.146); responses were roughly tenfold faster than for static targets; target size still mattered. — [Hall et al. 2013 (PMC3619462)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3619462)
- But identification of a moving camouflaged target among similarly patterned moving distractors was significantly impaired (5 distractors F(7,77)=4.74; 10 distractors F(7,77)=6.06; median RT 1365 ms vs 1886 ms; n=12). Authors: motion does not entirely "break" camouflage. — [Hall et al. 2013 (PMC3619462)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3619462)
- Increasing the rate of biological motion increased detectability even for the least salient camouflage patterns; a very salient pattern was easy regardless of motion. — [Visual salience and biological motion interact to determine camouflaged target detectability, Applied Ergonomics 2018 (listing)](https://katalog.lib.cas.cz/KNAV/EdsRecord/edsair,edsair.doi.dedup.....6c13e6f5f172f192dbb8533e3d2ad6eb)
- Dynamic soldiers were easier to detect than static ones; motion onset was the key capture feature. — [Adaptive camouflage of moving targets (VU listing)](https://research.vu.nl/en/publications/adaptive-camouflage-of-moving-targets/)

**Trainability and transfer**
- Chen & Hegdé (2012, Psychological Science 23(11):1395-1403): trained subjects improved at detecting camouflaged targets, including previously unseen instances of a scene type and scenes with novel targets, and even judged target-less scenes with "target-present" background statistics differently — supporting the claim that observers learn background statistics rather than specific targets. Sample size, trial counts and d' values are behind the paywall and were not retrieved. — [Chen & Hegdé 2012, APS journal page](https://www.psychologicalscience.org/journals/psychological-science/0956797612445315/)
- Hegdé lab follow-up: six volunteers trained to break camouflage (no explicit instruction on localisation) could detect targets from very brief exposures (news coverage says "less than a second"). Very small n; press-release level. — [Augusta University news 2021](https://jagwire.augusta.edu/camouflage-breakers-can-find-a-target-in-less-than-a-second/)
- Lab training with camouflage search displays improved performance, and participants trained on camouflage suffered no cost on novel camouflage displays; authors attributed gains to perceptual tuning rather than changes in overt eye-movement strategy. **[attribution uncertain: search summary credited "Neider et al. 2013 PLoS One"; the same title stem also belongs to Boot, Neider & Kramer 2009, Attention, Perception & Psychophysics]** — [Training and transfer of training in the search for camouflaged targets (Iowa record)](https://iro.uiowa.edu/esploro/outputs/journalArticle/Training-and-transfer-of-training-in/9984002335602771); [Weill Cornell record](https://vivo.weill.cornell.edu/display/pubid19429971)
- Neider and colleagues (2021, Acta Psychologica): 14 sessions of adaptive or massed camouflage-detection training in natural scenes; both trained groups detected camouflaged targets better than controls up to 3 months later, but **only for backgrounds and targets similar to those trained**. Authors' recommendation: train with stimuli similar to the operational environment. — [Training detection of camouflaged targets in natural scenes: Backgrounds and targets both matter (record)](https://libmast.utm.my/Record/doaj.art-b33ad66db74443bd8119e6d893728f4b); [AMiner record](https://www.aminer.cn/pub/611a3e455244ab9dcbfffb7c/training-detection-of-camouflaged-targets-in-natural-scenes-backgrounds-and-targets-both)

### Inferences
- The two transfer results are in tension: Chen & Hegdé and the earlier camouflage-search study report generalisation to novel targets/displays (within a synthetic texture family), while the 2021 natural-scene study finds similarity-bound transfer. The reconcilable reading: learning is of **background statistics**, so it transfers across targets and instances within a background family but weakly across background families. Design consequence: one "biome"/art-style pack per target game family (urban concrete, foliage, desert, interior) rather than abstract textures.
- Since motion removes most of the detection cost, drills should deliberately include static and slow/onset-only targets; a trainer in which every target pops or strafes trains the easy case.
- Identification among similar moving distractors remains hard under motion — relevant to friend/foe discrimination in team modes and to third-party fights.

### Gaps
- No effect sizes (d' pre/post), trial counts, or n could be extracted for Chen & Hegdé 2012 (paywalled); the same applies to exact n for the 2021 Acta Psychologica study.
- No human-subject military camouflage *training* study with soldiers was found (DTIC/ARL searches were not run specifically; search returned only computer-vision camouflage work).
- No study was found on training detection of partially occluded human figures ("head-glitch" exposures) specifically.

---

## 3. Perceptual learning: specificity, transfer, training structure, and applied evidence

### Takeaway
Perceptual learning is real and durable but defaults to being specific to the trained stimuli, location and task; transfer improves with stimulus variability, multiple locations/tasks ("double training"), and avoiding long blocks at a single threshold condition. Applied analogues (baggage screening, hazard perception) show solid near transfer and transfer to novel-but-similar items; far transfer claims (NeuroTracker, general "vision training") are weak or rest on single uncontrolled studies.

### Cited Findings

**Basic science**
- Review-level consensus: visual perceptual learning produces large, long-lasting threshold improvements that are often specific to trained retinal location, orientation, etc.; specificity depends on task difficulty, training procedure, and amount of training. **[recalled]** — [Dosher & Lu 2017, Annual Review of Vision Science](https://doi.org/10.1146/annurev-vision-102016-061249)
- Double training (Xiao et al. 2008): pairing feature training at one location with training of a different task at a second location produced complete transfer of the feature learning to the second location. Described here from later papers. Original **[recalled]**: [Current Biology 2008](https://doi.org/10.1016/j.cub.2008.10.030); secondary description — [Xiong et al. 2016, eLife](https://elifesciences.org/articles/14614v2)
- Boundary conditions: Hung & Seitz (2014) found prolonged training at threshold preserved location specificity even with double training; Liang et al. (2015) reported specificity of motion-discrimination learning under double training. — [Hung & Seitz 2014, J. Neuroscience (PMC4061387)](https://pmc.ncbi.nlm.nih.gov/articles/PMC4061387) **[attribution uncertain for PMC id]**; [Xiong et al. 2016, eLife](https://elifesciences.org/articles/14614v2)
- Xiong et al.: specificity may reflect under-activation of untrained neural populations from insufficient bottom-up stimulation and/or top-down attention to untrained conditions during training. — [Xiong et al. 2016, eLife](https://elifesciences.org/articles/14614v2)
- Zhu & Zhang (2024, Journal of Vision): high feature variability during training (45° orientation deviation) produced significant generalisation of orientation learning. **[attribution uncertain for URL]** — [PKU lab PDF](https://czgclinic.pku.edu.cn/docs/20240523105340365077.pdf)

**Baggage screening / X-ray search**
- Computer-based X-ray training (X-Ray Tutor line; Koller, Schwaninger and colleagues; Madhavan & Gonzalez) produces transfer to novel threat items; one design withheld half of test threat objects from training specifically to measure transfer to untrained but similar-looking objects. — [Review (PMC6647488)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6647488); [Schwaninger-group repository PDF](https://irf.fhnw.ch/server/api/core/bitstreams/5678cd6c-8215-4e94-be36-8fd6f5cb539d/content)
- Training affected mostly the non-search components (recognition/decision) rather than search/scanning itself (Koller, Drury & Schwaninger). — [Review (PMC6647488)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6647488)
- Gonzalez & Madhavan (2011): training with high diversity of object categories produced higher hit rate, lower false alarms, and faster detection of **novel** targets than low-diversity training. — [Review (PMC6647488)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6647488)
- "Targetless" training (learning the distractors/backgrounds only) produced significant gains in detection sensitivity (d') in simulated X-ray search relative to target-based training in novices, largest for less-occluded stimuli; mechanism proposed: better distractor rejection. — [Cognitive Research: Principles and Implications 2021](https://link.springer.com/article/10.1186/s41235-021-00295-0)

**Sports vision and perceptual-cognitive training**
- Deveau, Ozer & Seitz (2014, Current Biology): 19 UC Riverside baseball players did 30 x 25-min sessions of a perceptual-learning video game; 18 teammates untrained. Reported: acuity gains (some to 20/7.5), 4.4% lower strikeout rate, 41 more runs than projected (est. 4-5 wins). Not randomised, single team; authors themselves cautioned that unmeasured factors could contribute. — [Deveau et al. 2014 (PMC3932179)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3932179); [UC news summary](https://universityofcalifornia.edu/news/better-batting-through-brain-training)
- NeuroTracker / 3D-MOT (Vater, Gray & Holcombe 2021, critical systematic review): only three studies tested far transfer to ecologically valid tasks and two found none; no preregistered studies; evidence for working memory/sustained attention gains "very weak"; abilities trained are not those advertised. — [Vater et al. 2021, Psychonomic Bulletin & Review](https://link.springer.com/10.3758/s13423-021-01892-2)
- Later work finds near transfer (MOT-like tracking, processing speed) but still-unclear transfer to game performance; e.g., a soccer study where the 3D-MOT group improved on 3D-MOT only. Abstract-level. — [MOT review hosted by vendor, 2025](https://www.neurotrackerx.com/science/broadening-the-lens-a-review-of-multi-object-tracking-task-and-its-use-in-cognitive-training) (vendor-hosted; conflict of interest); [ÉTS thesis/paper 2025](https://espace2.etsmtl.ca/30218/1/Labbe-D-2025-30218.pdf)
- Stroboscopic training: early Duke studies reported improvements in central motion sensitivity and transient attention after training with strobe eyewear. **[recalled; small studies, evidence base generally considered preliminary]** — [Appelbaum et al. 2011, Frontiers in Psychology](https://doi.org/10.3389/fpsyg.2011.00276)

**Driving hazard perception**
- Meta-analysis (Prabhakharan et al. 2024): hazard-perception training yields moderate-to-large gains on hazard perception measures (pooled g = 0.78 for drivers; smaller for motorcyclists); active training and even single sessions were effective; authors say on-road translation still needs study. — [NTU repository record](https://irep.ntu.ac.uk/id/eprint/51376)
- Most outcomes in the literature are computer/simulator tests; few on-road evaluations and none on crashes in one young-driver review. — [PMC4483194](https://pmc.ncbi.nlm.nih.gov/articles/PMC4483194)
- One randomised trial using in-car telematics found an online hazard perception course reduced heavy braking, speeding and over-revving in real driving. — [Online hazard perception training course (SWOV record)](https://swov.nl/nl/publicatie/online-hazard-perception-training-course-reduces-heavy-braking-speeding-and-over-revving)

**Threat / shoot-don't-shoot**
- Response-inhibition training reduced civilian casualties in a simulated shooting task, and inhibitory control predicted such errors. **[recalled]** — [Biggs, Cain & Mitroff 2015, Psychological Science](https://doi.org/10.1177/0956797615579274)

### Inferences
- Structure that the evidence favours for a recognition mode: (1) high variability of backgrounds, target appearances, and screen locations within a session; (2) interleave at least two task types at the same locations (detect + identify/friend-foe) rather than one long threshold staircase; (3) keep a share of easy, above-threshold trials rather than sitting at threshold; (4) immediate trial feedback showing where the target was; (5) consider background-only "learn the map/biome" exposure blocks, by analogy with targetless training and Chen & Hegdé.
- Realistic dose: lab effects cited here come from roughly 10-30 short sessions (14 sessions camouflage; 30 x 25 min baseball; 50 h for action-game contrast sensitivity, see Q4). Marketing should not promise effects from a few minutes.
- Baggage-screening results suggest most trainable gain is in **recognising what a target looks like when found** (templates of partial/occluded views), less in scan pattern — consistent with the camouflage-training claim of perceptual tuning rather than eye-movement strategy. That favours large libraries of partial silhouettes over scan-path coaching.
- The honest expected outcome is near transfer (to similar visuals) plus recognition of novel-but-similar exposures; game-level outcome claims (K/D) would be far transfer and are unsupported by analogue fields.

### Gaps
- No controlled study exists (found) of perceptual-learning-style training transferring to FPS match performance.
- Optimal session length/spacing for search training specifically was not retrieved; "typical dose" above is a range read off individual studies, not a meta-analytic estimate.
- Stroboscopic and "sports vision" literature was not re-searched this session; treat as low-confidence.

---

## 4. Action video game research and its critiques

### Takeaway
Habitual action-game players outperform non-players on attention/perception tests by roughly half a standard deviation, but causal training effects are smaller (about a third of an SD by proponents' estimate) and may shrink toward zero after publication-bias correction. Simply "playing FPS games" is therefore weak evidence that spotting ability improves in general; the trainer should claim task-specific learning, not general visual enhancement.

### Cited Findings
- First demonstration: action game players showed better attentional capacity, spatial distribution of attention (UFOV-type task) and temporal attention; 10 h of action-game training improved non-players. **[recalled]** — [Green & Bavelier 2003, Nature](https://doi.org/10.1038/nature01647)
- Li, Polat, Makous & Bavelier (2009, Nature Neuroscience): 50 h of action games (Unreal Tournament 2004, Call of Duty 2) over ~9 weeks vs The Sims 2; action group's contrast sensitivity improved (press release: on average 43%, "up to 58%"), with gains persisting at later retest. Training groups were tiny (reported as 6 action vs 7 control; press coverage's "22 students" appears to combine groups). — [University of Rochester release](https://www.rochester.edu/news/printable.php?id=3342); [National Geographic coverage](https://www.nationalgeographic.com/science/article/playing-shoot-em-up-video-games-can-improve-some-aspects-of-vision); paper **[recalled DOI]**: [Nature Neuroscience](https://doi.org/10.1038/nn.2296)
- Bediou et al. (2018, Psychological Bulletin): cross-sectional g = 0.55; intervention studies g = 0.34; strongest for top-down attention and spatial cognition, "encouraging signs" for perception. — [UNIGE archive record](https://archive-ouverte.unige.ch/unige:101941)
- Hilgard, Sala, Boot & Simons (2019, Collabra): reanalysis with better bias correction finds minimal evidence of training transfer; notes Bavelier-lab studies report larger effects than other labs and that overlapping samples were split across publications ("salami slicing"). — [Illinois record](https://experts.illinois.edu/en/publications/overestimation-of-action-game-training-effects-publication-bias-a/); [Liverpool repository](https://livrepository.liverpool.ac.uk/id/eprint/3063630)
- Failed replication of training effects and methodological critique (differential expectations/placebo, overt recruitment of gamers). **[recalled]** — [Boot et al. 2008, Acta Psychologica](https://doi.org/10.1016/j.actpsy.2008.09.005); [Boot, Blakely & Simons 2011, Frontiers in Psychology](https://doi.org/10.3389/fpsyg.2011.00226)
- Sala, Tatlidil & Gobet (2018, Psychological Bulletin): meta-analysis concluding video-game training has negligible effects on cognitive ability once design quality is considered. **[recalled; search this session did not retrieve it]** — [Psychological Bulletin](https://doi.org/10.1037/bul0000139)
- Bediou et al. (2023, Technology, Mind, and Behavior) updated meta-analysis: recalled as reporting a larger cross-sectional effect (about g = 0.64) and a small intervention effect (about g = 0.30) after stricter inclusion. **[recalled; not retrieved this session — verify numbers]** — [Technology, Mind, and Behavior](https://doi.org/10.1037/tmb0000102)
- Esports-expert meta-analysis (PeerJ 2024, three-level model) concludes gaming experience is associated with cognitive advantages, citing the Bediou 2023 taxonomy. Cross-sectional. — [PeerJ 17857](https://peerj.com/articles/17857)

### Inferences
- Strong: gamers differ from non-gamers (correlational). Contested: that games cause it, and by how much. Weak: contrast-sensitivity gain (n=6 trained, not independently replicated at scale as far as found).
- For product framing: avoid "improves your vision/attention"; defensible framing is "practise the specific perceptual decisions your game demands, with measurement".
- Because cross-sectional differences may partly reflect self-selection, baseline detection ability in the trainer is likely to vary widely across users, so adaptive difficulty is necessary.

### Gaps
- Bediou 2023 and Sala & Gobet 2018 numbers were not verified this session.
- No meta-analysis specific to detection of low-contrast/camouflaged targets in gamers was found.

---

## 5. Expert FPS / esports player studies

### Takeaway
Esports eye-tracking evidence is thin, small-sample and partly conflicting, but it converges on better players keeping gaze near screen centre/crosshair, making fewer fixations and saccades, and relying more on peripheral vision; simple reaction speed scales with skill, while inhibition/friend-foe findings are mixed.

### Cited Findings
- CS:GO sensing study: professional players spent more time looking at screen centre; amateurs spent more time on UI elements, especially the radar. Small sample. — [arXiv 1908.06403](https://arxiv.org/pdf/1908.06403)
- 2025 Computers in Human Behavior study (63 participants, 28 experienced FPS players; task adapted from Counter-Strike 2): experienced players made significantly fewer fixations and saccades, interpreted as more efficient visual search during aiming. — [PsyPost coverage](https://www.psypost.org/experienced-fps-gamers-show-faster-more-efficient-eye-movements-during-aiming-tasks-study-finds/)
- VALORANT gaze study (2023): middle-skill players had significantly wider horizontal gaze distribution than high-skill players; gaze distribution and reaction time were negatively correlated; authors suggest high-skill players use peripheral vision. Preprint. — [arXiv 2310.15542](https://arxiv.org/pdf/2310.15542)
- CS:GO fixation study: fixation durations can discriminate skill; higher skill associated with more variable fixation durations; low-skill group n=10. Preprint. — [arXiv 1906.01699](https://arxiv.org/pdf/1906.01699)
- "Secrets of Gosu" (CHI 2021): 8 professional vs 8 amateur CS:GO players with multiple sensors incl. eye tracker; only 6 of 13 folk conjectures about pro skill were statistically supported. — [DGIST record](https://dgist.elsevierpure.com/en/publications/secrets-of-gosu-understanding-physical-combat-skills-of-professio/)
- Reaction/inhibition: Deleuze et al. (2017) found FPS players faster but with weaker inhibitory control than MOBA players; another study found the opposite pattern on inhibition; two studies found no stop-signal RT difference between heavy FPS players and controls. — [UCLouvain repository](https://research.dial.uclouvain.be/bitstreams/a482c0a2-5232-4f2d-8faa-9366c5dd355f/download); [esports meta-analysis PeerJ (PMC11316462)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11316462)
- Small Valorant study (10 amateur players vs 9 controls) used Go/No-go; players better on game and tracking measures. Too small to generalise. — [Current Psychology 2024](https://link.springer.com/article/10.1007/s12144-024-05750-x)
- Systematic-review observation: skill-level boundaries in esports research are not clearly defined, limiting cross-study comparison. — [PeerJ 17857](https://peerj.com/articles/17857)

### Inferences
- If experts park gaze near the crosshair and detect peripherally, then a valid drill should require detection at controlled eccentricities **while the player maintains a central task** (e.g., holding an angle or tracking a central target), rather than free scanning of a static picture.
- Amateurs' radar/UI dwell suggests a dual-task variant (HUD glance + world detection) trains the inattentional-miss case.
- Friend/foe (go/no-go) should be measured as its own skill; it does not reliably come "for free" with FPS experience.

### Gaps
- No study found relating go/no-go or choice RT to rank within CS/Valorant; no eye-tracking data for large-map camouflage-heavy titles (Warzone, PUBG, Tarkov, Battlefield).
- The 2025 CS2 study was read only via press coverage; effect sizes not extracted.
- Without an eye tracker, gaze position must be proxied by crosshair position — valid only to the extent that gaze sits on the crosshair (supported for experts, less so for novices). A webcam gaze estimate would add value mainly for distinguishing "never looked there" from "looked but did not recognise".

---

## 6. Display and settings factors affecting visibility

### Takeaway
Peer-reviewed evidence exists for latency, refresh rate and display size effects on *aiming*, not on *detection*; claims about FOV, stretched resolution, digital vibrance, colour-blind filters, motion blur and anti-aliasing improving enemy visibility are essentially untested in the literature and rest on geometry, basic psychophysics, and community lore.

### Cited Findings
- Refresh rate (University of Florida 2024, n=26; 30/60/120/144/240 Hz): refresh rate significantly affected FPS task performance only at 30 Hz. — [arXiv 2406.13027](https://arxiv.org/pdf/2406.13027)
- NVIDIA 2019 (8 skilled players): reduced latency clearly improved task completion time; higher refresh rate had relatively minor effects once its inherent latency reduction was controlled. — [NVIDIA Research PDF](https://research.nvidia.com/sites/default/files/pubs/2019-11_Latency-of-30/FPS_Tasks_sa2019_AuthorVersion.pdf)
- Display size at constant FOV: about 3% faster aiming time at 26 in vs 13 in diagonal; follow-up (FDG 2025) found improvement with size that diminishes near 30 in under typical desktop conditions; a small-target experiment found a small but significant benefit of the larger monitor. — [NVIDIA 2023](https://research.nvidia.com/publication/2023-10_constant-field-view-display-size-effects-first-person-aiming-time); [arXiv 2305.16953](https://arxiv.org/pdf/2305.16953)
- Target angular size matters for detection as well as aiming: camouflage and capture effects varied across 1.0°-2.0° targets in Hall et al. — [PMC3619462](https://pmc.ncbi.nlm.nih.gov/articles/PMC3619462)
- FOV: only hobbyist guides/polls were found; they assert that wider FOV shrinks distant targets and lower FOV helps spotting at range. Not experimental evidence. — [Esports Tales FOV guide (Tarkov)](https://esportstales.com/escape-from-tarkov/the-best-fov-field-of-view)
- Action-game play has been linked to improved contrast sensitivity (see Q4), implying contrast-limited detection is a relevant, measurable dimension. — [University of Rochester release](https://www.rochester.edu/news/printable.php?id=3342)

### Inferences
- Geometry (not an empirical finding): at fixed viewing distance and resolution, the on-screen linear size of a centre-screen target scales with 1/tan(hFOV/2). Going from 80° to 120° horizontal FOV roughly halves linear size (tan40°/tan60° ≈ 0.48) and quarters pixel area, pushing distant heads toward the acuity/pixel limit while bringing more of the world into the (crowded) periphery. This is the principled reason FOV must be a matched setting in the trainer.
- Stretched resolution (e.g., 4:3 stretched to 16:9) makes models about 1.33x wider on screen while narrowing horizontal FOV; any benefit should be modelled as a target-angular-width increase, traded against lost peripheral coverage. No controlled study was found, so the trainer could be the first to measure it per-user.
- Gamma/brightness/vibrance/colour filters change luminance and chromatic contrast between target and background; by the similarity principle (Q1) they can plausibly help for specific skin/background pairs but there is no general evidence. Safe design: let users replicate their in-game filter settings and measure d' with and without.
- Motion blur and temporal anti-aliasing reduce high-spatial-frequency edge information during camera motion; expected to hurt detection of small targets while turning, but this is untested (found no study).
- Viewing distance and monitor size jointly set visual angle; the trainer should ask for both (or calibrate with a credit-card sizing step) so thresholds are stored in degrees, not pixels.

### Gaps
- No peer-reviewed experiments found on: FOV setting vs detection; stretched resolution; digital vibrance/saturation; colour-blind filters; motion blur; anti-aliasing mode; resolution/upscalers (DLSS/FSR) vs target visibility. A dedicated search on colour-vision-deficiency modes and on motion-clarity (MPRT/strobing backlight) was not run.
- Refresh-rate studies measured aiming/hit performance, not detection of low-contrast targets.

---

## 7. Design implications for a perceptually valid "target recognition" mode

### Takeaway
Build the mode as a parametric psychophysics task wearing game-like art: control and log contrast, clutter, occlusion fraction, eccentricity, exposure duration, prevalence and distractor similarity; score with signal-detection measures including target-absent trials; separate detect / identify / acquire stages; and prioritise variability and game-similar visuals because camouflage learning transfers mainly within similar backgrounds.

### Cited Findings (evidence each design choice rests on)
- Train with stimuli similar to the operational environment; camouflage training gains lasted 3 months but were limited to similar backgrounds/targets. — [Acta Psychologica 2021 record](https://libmast.utm.my/Record/doaj.art-b33ad66db74443bd8119e6d893728f4b)
- Learning background statistics generalises to novel targets and unseen instances within a background type. — [Chen & Hegdé 2012](https://www.psychologicalscience.org/journals/psychological-science/0956797612445315/)
- High category diversity in training improves hits, false alarms and speed on novel targets. — [Review (PMC6647488)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6647488)
- Background/distractor-only exposure can raise d'. — [CRPI 2021](https://link.springer.com/article/10.1186/s41235-021-00295-0)
- Low prevalence raises misses via criterion and quitting-threshold shifts, so hit rate alone is uninterpretable without false alarms and target-absent trials. — [Prevalence effect summary](https://en.wikipedia.org/wiki/Prevalence_effect)
- Standard computation of d', criterion and corrections for extreme hit/false-alarm rates. **[recalled]** — [Stanislaw & Todorov 1999, Behavior Research Methods](https://doi.org/10.3758/BF03207704)
- Training mostly improves recognition/decision rather than scanning in X-ray search. — [Review (PMC6647488)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6647488)
- Variability and multi-task/multi-location training promote transfer; prolonged single-condition threshold training promotes specificity. — [Xiong et al. 2016, eLife](https://elifesciences.org/articles/14614v2); [Hung & Seitz 2014 (PMC4061387)](https://pmc.ncbi.nlm.nih.gov/articles/PMC4061387)
- Adaptive and massed training schedules both worked for camouflage detection. — [AMiner record](https://www.aminer.cn/pub/611a3e455244ab9dcbfffb7c/training-detection-of-camouflaged-targets-in-natural-scenes-backgrounds-and-targets-both)
- Motion onset captures attention; static camouflaged targets are the hard case; identification among similar movers stays hard. — [Hall et al. 2013](https://pmc.ncbi.nlm.nih.gov/articles/PMC3619462); [VU listing](https://research.vu.nl/en/publications/adaptive-camouflage-of-moving-targets/)
- Inhibition training reduces friendly-fire-type errors in simulated shooting. **[recalled]** — [Biggs et al. 2015](https://doi.org/10.1177/0956797615579274)
- Experts keep gaze central and use the periphery. — [arXiv 1908.06403](https://arxiv.org/pdf/1908.06403); [arXiv 2310.15542](https://arxiv.org/pdf/2310.15542)

### Inferences (proposed operationalisation; these are design recommendations, not findings)

**Parameters to expose and log per trial**
- Target-background contrast: luminance (Weber/Michelson on mean target vs local background) and colour difference (e.g., CIELAB delta-E), computed from the rendered frame, not from asset metadata.
- Clutter: local edge density / feature-congestion style measure in a window around the target, plus global scene clutter.
- Occlusion fraction: percent of the silhouette visible (e.g., 100%, 50% torso, 15% head-and-shoulders, about 5% head-glitch), and which part is visible.
- Eccentricity: degrees from crosshair at onset (requires monitor size + viewing distance + FOV); also direction (horizontal vs vertical).
- Angular size: degrees of visual angle, derived from simulated range and the user's game-matched FOV.
- Exposure duration: from brief (about 100-250 ms peeks) to unlimited (static holder), plus onset type (pop-in, slide-in, already present when the view turns).
- Target prevalence per location/trial: include genuine target-absent trials (suggest 30-50% absent in assessment blocks; a separate "rare threat" block at about 5-10% to train against early quitting).
- Distractor similarity: friendlies, civilians, mannequin-like props, and enemy-coloured scenery; number of targets per scene (0, 1, 2+) to probe subsequent-search misses.
- Motion state: static, micro-movement, onset-only, continuous.

**Three separable response stages**
- Detect: present/absent or "ping the location" (click anywhere within a tolerance) with no aiming precision required; yields hit, miss, false alarm, correct rejection, localisation error, RT.
- Identify: friend/foe or class decision (go/no-go or 2AFC) on a detected figure; yields identification d' and commission errors.
- Acquire: time from detection to first on-target shot — this is ordinary aim-trainer territory and should be reported separately so slow aim is not misread as poor perception. A useful derived metric: detection RT = time-to-kill minus the user's own flick time to a fully visible target at the same eccentricity/size.

**Scoring**
- Report d' and criterion c (with a standard correction for 0/1 rates) per condition; show false alarms prominently so users cannot "improve" by spamming. For localisation tasks, count clicks outside tolerance as false alarms. Use search time on correct trials and time-to-quit on absent trials (quitting threshold) as secondary metrics.
- Estimate thresholds (e.g., 75%-correct contrast, occlusion, or duration) per eccentricity band to give each user a "visibility profile".

**Difficulty adaptation**
- Use an adaptive staircase or Bayesian method on one dimension at a time for assessment, but in training blocks interleave conditions and keep roughly a quarter to a third of trials clearly above threshold (variability and easy trials favour transfer; sitting at threshold favours specificity). Rotate locations and biomes within a session.

**Drill ideas mapped to mechanisms (Q1)**
- Peripheral hold: keep crosshair on a central angle/track target while detecting peripheral peeks (eccentricity x clutter).
- Static-holder sweep: pan across a scene containing 0-2 static partially occluded figures (prevalence, quitting, subsequent-search misses).
- Blend-in: operator skins matched to backgrounds at graded contrast (similarity/camouflage).
- Head-glitch library: many variations of small visible fractions over cover edges (recognition templates).
- Off-angle: targets placed against scene priors (context miss).
- Friend/foe flash: brief exposures with go/no-go (identification, inhibition).
- HUD dual-task: detect while reading a minimap/ammo prompt (inattentional miss).
- Background-only familiarisation: explore empty scenes of a biome before the block (targetless/background learning).

**Risks and mitigations**
- Risk: synthetic scenes do not transfer to a specific game's renderer/art. Mitigation: per-game-family art packs (lighting model, palette, foliage density, post-processing), user-matched FOV/resolution/filters, wide within-family variety; state clearly that evidence supports near transfer.
- Risk: users learn fixed spawn spots (memorisation instead of perception). Mitigation: procedural placement, large location pools, novel held-out scenes for assessment.
- Risk: criterion shift mistaken for sensitivity gain. Mitigation: SDT scoring and absent trials.
- Risk: expectancy/placebo in self-reported improvement (the Boot et al. critique). Mitigation: held-out transfer test scenes never used in training; optional pre/post protocol.
- Risk: frame-timing errors invalidate brief exposures. Mitigation: specify exposure in frames, log actual presented frames and refresh rate.
- Optional gaze: webcam gaze estimation is coarse (several degrees) but enough to classify "target was/was not within central vision when missed"; without it, use crosshair position as proxy and flag the limitation.

### Gaps
- No published validation of any commercial aim trainer's "perception" or "target recognition" mode was found; the claim that existing aim trainers largely lack this capability was not independently checked this session.
- No evidence base exists for specific numeric settings proposed above (percent absent trials, share of easy trials, tolerance radii); they are starting points to be tuned with user data.
- Whether detection thresholds measured in the trainer predict in-game outcomes (e.g., first-shot rate, deaths to unseen enemies) is unknown and is the key validation study the product itself could run.
