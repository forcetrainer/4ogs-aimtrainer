# Audio awareness: sound localisation over headphones and audio-cued target acquisition

Research date: 2026-11-11. Evidence labels used on every finding: **[PR]** peer-reviewed, **[PP]** preprint, **[DEV]** developer or vendor statement, **[COM]** community or press, **[SNIP]** search-snippet only (page not opened by me). "Full text" means I fetched and read the paper body; "abstract" means abstract only. Several primary pages could not be fetched (Nature 303 redirect, Acta Acustica 403, callofduty.com connection reset); those findings are marked [SNIP] and should be treated as leads, not settled facts.

## 1. Human sound localisation basics relevant to headphones

### Takeaway
Left-right (lateral) judgement over headphones is robust (about 11 to 18 degrees error in the studies read), but front-back and up-down judgement with a non-individual HRTF is poor: roughly 40% of static trials start as front-back confusions. Listener-controlled movement of the sound scene, not physical head movement as such, is what resolves front-back ambiguity, which is the single most useful finding for a mouse-driven game.

### Cited Findings
- [PP, full text of bioRxiv v3; published version is PR in Sci Rep 9:18284] Untrained listeners with a non-individual HRTF (IRCAM Listen IRC0008), head held still: mean spherical error about 43 degrees, lateral error about 15 degrees, front-back confusion rate about 41%. n = 36. — [Steadman et al. bioRxiv v3](https://www.biorxiv.org/content/10.1101/207753v3.full); published record [PubMed 31798004](https://www.pubmed.gov/31798004/)
- [PR, full text] With each listener's perceptually worst-rated HRTF (ITD individualised from head circumference), lateral error averaged 17 to 18 degrees versus 11 degrees for listeners using their own measured HRTF; polar (front-back/up-down) error was far larger, e.g. one listener's mean absolute polar error was 70.7 degrees at session 1, and the individual-HRTF control group's was 47.0 degrees at session 1. Up-down errors were rare; front-back confusions dominated early sessions. — [Stitt, Picinali & Katz 2019, Sci Rep, PMC6355836](https://pmc.ncbi.nlm.nih.gov/articles/PMC6355836/)
- [PR, abstract via search] Front-back confusions nearly vanished when head movement was encouraged. With the head still, confusions disappeared only when the listener controlled the source's movement (key presses), not when the experimenter moved it. The authors conclude head movements are not required to produce the dynamic cues. — [Wightman & Kistler 1999, JASA 105:2841, bibliographic record](https://data.zhenzhi.com/details/1/861554450); related NASA report describing the keyboard set-up, with reversing listeners moving the source about 40 degrees versus about 5 degrees for others [NTRS 19960047531](https://ntrs.nasa.gov/api/citations/19960047531/downloads/19960047531.pdf) [SNIP]
- [PR, SNIP] Small yaw rotations (below plus or minus 10 degrees) substantially reduce front-back confusion rate; pitch rotations do little. n = 7. — [McLachlan et al. 2023, Frontiers in Neuroscience](https://www.frontiersin.org/articles/10.3389/fnins.2023.1027827/full)
- [PR, SNIP] The dynamic change in interaural time difference during head rotation is the robust front-back cue; dynamic level difference is less clear. — [Pöntynen & Salminen 2019, Hearing Research (Aalto copy)](https://acris.aalto.fi/ws/portalfiles/portal/32944099/ELEC_Pontynen_resolving_front_back_ambiguity_HR.pdf)
- [PP, SNIP] Dynamic (head-tracked) reproduction mattered more for localisation accuracy than using individually measured HRTFs, and was "fundamental" for reducing front-back confusion and in-head localisation. — [Oberem et al. bioRxiv 2020](https://www.biorxiv.org/content/biorxiv/early/2020/03/31/2020.03.31.011650.full.pdf)
- [PR, SNIP] Wenzel et al. 1993 (JASA): with non-individual HRTFs, horizontal accuracy stayed close to free-field for most listeners, but front-back and up-down confusions increased significantly. — [NASA NTRS record](https://ntrs.nasa.gov/citations/19930067961). A blog compilation attributes 31% front-back confusions (non-individual headphone) versus 19% (free field) to this paper; unverified secondary figure. — [voxbooster blog](https://voxbooster.com/blog/gaming-headset-hrtf-virtual-surround-localization-statistics-2026/) [COM]
- [PR, SNIP] Auditory distance estimates are generally poorer than azimuth estimates; the main cues are sound level, reverberation (direct-to-reverberant ratio) and spectrum. — [Kolarik et al. 2016 review, Atten Percept Psychophys, PMC4744263](https://pmc.ncbi.nlm.nih.gov/articles/PMC4744263)
- [PR, SNIP] Conveying elevation by spatial audio alone is poor enough that an ICAD 2019 targeting study added explicit height cues. — [ICAD 2019 paper 8](https://icad2019.icad.org/wp-content/uploads/2019/06/ICAD_2019_paper_8.pdf)

### Inferences
- A mouse flick is a listener-controlled rotation of the sound scene. Wightman & Kistler's result (strong, but a single old study with virtual sources and key presses) supports the claim that turning the game camera can substitute for head movement in resolving front-back ambiguity, provided the cue is still sounding during the turn and the renderer updates ITD with low latency. A single footstep impulse that ends before the turn gives no dynamic cue; a footstep train does. This is extrapolation from keyboard-moved sources to mouse-rotated listeners; no study found tests mouse rotation directly.
- Because lateral error is small and front-back error is large, the natural skill hierarchy is: (1) left versus right (easy), (2) front versus back (hard, the main training target), (3) fine azimuth, (4) elevation and distance (weakest, least trustworthy).
- In CoD, above/below (multi-storey buildings) is likely to stay unreliable for most players regardless of training; evidence for elevation over generic HRTFs is weak.

### Gaps
- Classic free-field accuracy figures (e.g. Makous & Middlebrooks 1990; minimum audible angle about 1 degree frontally) and Zahorik's distance-compression power-law figures were not retrieved this session; do not quote numbers for them without checking.
- Kolarik 2016 full text was not read; specific statements on compression/underestimation and headphone presentation are unverified.
- No sourced data on how occlusion or game-style reverb changes localisation error over headphones.
- No study found on mouse-driven camera rotation as a substitute for head rotation.

## 2. Binaural rendering: generic vs individual HRTFs, training and specificity

### Takeaway
Short active training with feedback (tens of minutes to about two hours) reliably improves localisation with a non-individual HRTF, mostly by cutting front-back confusions, and gains last weeks to months. The best direct evidence says the learning carried over to a second untrained HRTF, to untrained positions and to untrained sounds, but that is one or two small studies; transfer to a different game engine's whole audio pipeline (attenuation curves, occlusion filters, mix) is untested.

### Cited Findings
- [PP full text; PR published] Steadman et al.: nine 12-minute blocks (108 minutes) over three days with visual position feedback. Pooled trained groups cut spherical error by about 18 degrees from about 43 degrees; front-back confusions fell by about 15 percentage points from about 41%. Control change (6.25 degrees) not significant. Half-error time about 1.6 sessions (about 19 minutes). Groups: control 9, non-gamified 9, gamified 7, active-gamified 11. — [bioRxiv v3](https://www.biorxiv.org/content/10.1101/207753v3.full)
- [PP full text; PR published] Gamification alone added nothing (gamified group not significantly different from control); "active listening" (stimulus looped until response, head free and tracked) gave the largest gains and was the only group with a significant polar-angle improvement. — [bioRxiv v3](https://www.biorxiv.org/content/10.1101/207753v3.full); abstract-level confirmation [Imperial Spiral record](https://spiral.imperial.ac.uk/entities/publication/5c306f89-26bf-4827-aa5c-6f9921b7c348)
- [PP full text; PR published] Generalisation: improvement transferred to an untrained HRTF (IRC0013) with no significant trained/untrained difference for spherical, lateral or front-back measures; only polar-angle error showed a trained-HRTF-specific component (minus 6.74 degrees trained vs minus 2.9 degrees untrained), which did not survive controlling for baseline. Test stimulus was a sound not used in training. — [bioRxiv v3](https://www.biorxiv.org/content/10.1101/207753v3.full)
- [PR, full text] Stitt, Picinali & Katz: 12-minute game sessions (find hidden target with tracked hand; noise pulse rate rises near target; no explicit localisation task). Median polar error fell 11.9 degrees over sessions 1 to 4 (weekly). Lateral error showed little or no learning. Group that stopped at session 4 held its performance for the following three months. Continued training to 10 sessions kept improving at about 1.34 degrees per session. — [PMC6355836](https://pmc.ncbi.nlm.nih.gov/articles/PMC6355836/)
- [PR, full text] Large individual differences: improvement rates 0.5 to 4.6 degrees per session; 3 of 8 long-trained listeners approached individual-HRTF control performance; one listener never resolved front-back confusions; no predictor of who learns was found. The authors reject the hypothesis that everyone can adapt and recommend HRTF selection. — [PMC6355836](https://pmc.ncbi.nlm.nih.gov/articles/PMC6355836/)
- [PR, as summarised within Stitt 2019 full text] Parseihian & Katz 2012: three sessions on successive days; worst-rated HRTF improved by at least 10 degrees polar error. — [PMC6355836](https://pmc.ncbi.nlm.nih.gov/articles/PMC6355836/)
- [PR, abstract] Mendonça et al. 2013 (PLoS ONE): training with non-individual HRTFs improved localisation; benefit generalised to untrained positions and sound types; still present one month later; training with white noise beat training with speech. — [PLoS ONE PDF, Aalto](https://acris.aalto.fi/ws/portalfiles/portal/12865609/journal.pone.0077900.pdf)
- [PR, abstract] Mendonça et al. 2012 (JAES): mere exposure to generic-HRTF sounds did not improve localisation; short active training with feedback did. — [U. Minho repository](https://repositorium.sdum.uminho.pt/handle/1822/26405)
- [PR, SNIP] Poirier-Quinot & Katz 2021 (Acta Acustica) review material states retention has been shown up to 4 months after training. I could not open the paper (403). — [Acta Acustica](https://acta-acustica.edpsciences.org/10.1051/aacus/2021019)

### Inferences
- Dose guidance supported by evidence: 10 to 12 minute blocks; most of the gain arrives within the first 20 to 60 minutes of active practice; continued slow gains to at least 2 hours. Feedback showing the true source position after each response is the common ingredient; passive listening does nothing.
- Transfer to CoD is plausible but unproven. Supporting: cross-HRTF, cross-position and cross-sound generalisation in Steadman and Mendonça. Against: the polar-angle (spectral) component showed some renderer specificity; all studies used anechoic HRTF rendering of broadband sounds, whereas a game adds distance curves, occlusion filtering, reverb, dynamic mixing and compression. What probably transfers is the strategy (use left-right first, turn to disambiguate front-back, re-weight spectral cues) rather than a fine spectral map.
- Because ITD/ILD-based lateral judgement is renderer-independent and already good, the trainer should not claim large gains there; the trainable deficit is front-back.
- Expect some users not to improve; the trainer should detect non-responders (flat front-back error after about an hour) and suggest trying a different HRTF or the user's in-game personalised profile rather than more reps.

### Gaps
- Published Sci Rep version of Steadman not read directly (redirect); numbers above are from preprint v3 and could differ slightly.
- No study tests transfer from a trained research spatialiser to a commercial game engine, or from trainer to in-game outcomes.
- Size of the generic-versus-individual penalty is only indirectly evidenced here (11 vs 17 to 18 degrees lateral; control polar 47 degrees at session 1 vs worse for worst-rated HRTFs). Note Stitt deliberately used each person's worst HRTF, so it overstates the penalty of a typical generic HRTF.
- Parseihian & Katz 2012 and Majdak/Carlile-style long-term mould studies not read.

## 3. Audio-visual orienting, out-of-view targets, and FPS/esports-specific studies

### Takeaway
Spatial sound substantially shortens the time to find a visual target, with the biggest savings for targets outside the field of view, and a cue that keeps updating as the viewer turns is as good as a visual arrow. Peer-reviewed evidence specific to FPS games is thin: one AES conference-type study reporting faster reactions with immersive audio than stereo, and nothing rigorous on footstep detection or on stereo versus virtual surround versus HRTF modes in CoD, CS or Valorant.

### Cited Findings
- [PR, abstract via search] Perrott et al. 1990 (Perception & Psychophysics): a 10 Hz click train co-located with the visual target reduced visual search time by 175 to 1,200 ms. — [Perrott et al. 1990 PDF](https://sites.socsci.uci.edu/~saberi/perrottetal1990.pdf)
- [PR conference abstract, SNIP] ASA 1994 abstract (Perrott and colleagues): search times rose for targets in the rear hemifield, 780 vs 1,325 ms in one condition and 934 vs 3,310 ms in another; condition labels (SCS, SUS) were not defined in the snippet, but the pattern is that the audio-cued condition suffers far less in the rear than the uncued one. — [ASA 127th meeting abstract 3aPP11](https://auditory.org/asamtgs/asa94mit/3aPP/3aPP11.html)
- [PR, SNIP] Bolia et al. 1999 (Human Factors 41:664): free-field and virtual (HRTF) audio cues tested against no audio across 1 to 50 visual distractors; effect sizes not retrieved. — [DTIC copy](https://apps.dtic.mil/sti/tr/pdf/ADA430240.pdf)
- [PR, abstract via search] Flanagan et al. 1998 (Human Factors), helmet-mounted display, out-of-view targets: both visual and auditory spatial cues "reduced search time dramatically" versus unaided search; an audio cue updated with head movement beat a transient one-shot cue and matched the visual cue. — [bibliographic record](https://scilit.com/publications/1eb24625dc9c5e431e805f3b46f356de)
- [PP, SNIP] 2026 arXiv paper (IEEE VR workshop) on rapid localisation of brief spatial sounds frames spatial audio as a fast orienting cue rather than a precise locator, insufficient alone for precise tasks. — [arXiv 2601.21264](https://arxiv.org/html/2601.21264v3)
- [PR, SNIP] A 2025 Frontiers in Virtual Reality paper cites a 35% search-time reduction for an out-of-view virtual element with auditory guidance; original source not checked. — [Frontiers in VR 2025](https://www.frontiersin.org/journals/virtual-reality/articles/10.3389/frvir.2025.1598776/epub)
- [Non-peer-reviewed course review, SNIP] Commonly cited simple reaction times: about 160 ms to sound versus about 190 ms to light (auditory 140 to 160 ms); reaction time shortens with intensity (Piéron's law). — [Kosinski-style review hosted at Masaryk Univ.](https://is.muni.cz/el/fsps/jaro2020/bp4017/um/Factors-Affecting-Reaction-Time1.pdf?lang=en)
- [PR conference, SNIP] Brandmeyer et al., "Benefits of immersive spatial audio on athlete reaction times in e-sports" (AES): simple first-person game; two commercial immersive spatial-audio solutions gave faster reaction times than plain stereo, with differences between the two products. Sample size, products and effect size not retrieved (paywalled). — [author page summary](https://www.bohrium.com/scholar/8w3703x7/Alex_Brandmeyer)
- [PR conference, SNIP] An AES 2017 study found virtual 7.0 surround was not perceived as significantly different in spatial quality from a stereo downmix for games (quality rating, not performance). — [AES e-library 18648](https://www.aes.org/e-lib/browse.cfm?elib=18648)
- [PR, SNIP] University of Florence study, n = 22, audio-enhanced ViZDoom in sound-only scenarios: prior gaming experience may reduce disorientation and improve spatial audio recognition. — [Florence repository PDF](https://flore.unifi.it/retrieve/76f710d5-7f01-41ff-a937-a7a2db226cb3/Familiarity_Vs_Performance_the_Link_Between_Gaming_Experience_and_Audio_Recognition.pdf)
- [COM, SNIP] A blog compilation states it found no published study measuring auditory reaction time in professional CS2 or Valorant rosters with calibrated equipment. — [voxbooster blog](https://voxbooster.com/blog/fps-footstep-audio-sound-cue-reaction-time-statistics-2026/)

### Inferences
- The user's premise (sound is often the first indicator and should speed turn-acquire-fire) is consistent with decades of aurally-aided visual search work. The transferable design rule from Flanagan: continuous or repeated cues that update as the player turns outperform a single transient. Footstep trains are naturally of that type.
- Largest expected benefit, and so the most valuable drill content, is targets behind or far to the side; in-FOV targets gain little from audio.
- Audio's precision is coarse (tens of degrees), so the realistic chain is: sound gives hemisphere and rough bearing, a fast coarse turn brings the target into view, vision takes over. The drill should score the coarse turn separately from the final aim.
- The raw auditory reaction-time advantage (about 30 ms on simple RT) is small next to the hundreds of milliseconds saved by not having to search.

### Gaps
- No peer-reviewed study found on playing CoD/CS/Valorant with versus without sound, on footstep detection thresholds in games, or comparing stereo, virtual 7.1 and in-game HRTF modes on performance.
- Brandmeyer effect sizes unknown; Bolia 1999 numbers unknown.
- No turn-to-target timing study with mouse input found; all are head/eye movement studies.
- Simple reaction-time figures come from a non-peer-reviewed review; a primary citation is needed before quoting.

## 4. Auditory perceptual learning: detection in noise, attention, and specificity

### Takeaway
Hearing a faint sound is partly an attention problem: under high visual load people miss clearly audible tones at high rates, with reduced sensitivity, not only a shifted criterion. Auditory detection and discrimination improve with practice, but how far the learning generalises depends on the task and stimulus, and I found no study of training footstep-in-masker detection.

### Cited Findings
- [PR, abstract via search] Macdonald & Lavie 2011: failure to notice a tone reached 79% under high visual load, significantly more than under low load. — [PMC3152714](https://pmc.ncbi.nlm.nih.gov/articles/PMC3152714)
- [PR, abstract via search] Raveh & Lavie 2015: with repeated trials and signal-detection analysis, detection sensitivity (d') for a 100 ms tone was lower during high-load visual search. — [UCL Discovery PDF](https://discovery-pp.ucl.ac.uk/1454101/1/art_10.3758_s13414-014-0776-2.pdf)
- [PR, abstract via search] Molloy et al. 2015 (J Neurosci): high visual load reduced early (about 100 ms) auditory evoked responses. — [UCL Discovery PDF](https://discovery-pp.ucl.ac.uk/1477601/1/16046.full.pdf)
- [PR, SNIP] Tellinghuisen, Cohen & Cooper 2016 reported mixed results; whether inattentional deafness appears depends on the relation between the auditory stimulus and the visual task. — [Atten Percept Psychophys](https://link.springer.com/10.3758/s13414-016-1169-5)
- [PR, SNIP, via citing papers] Wright & Zhang 2009 review: specificity versus transfer of auditory learning depends on multiple factors; some learning generalises across frequency, ear and duration, while brief-tone tasks need multiple sessions and are more specific. Wright, Wilson & Sabin 2010: generalisation lags behind stimulus-specific learning. Fitzgerald & Wright: no transfer between amplitude-modulation detection and rate discrimination. — [PMC3070992](https://pmc.ncbi.nlm.nih.gov/articles/PMC3070992); [Frontiers in Psychology 2012](https://public-pages-files-2025.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2012.00508/xml)

### Inferences
- A player tracking a target or in a gunfight is under high visual load, which is exactly when a second enemy's footsteps are missed. That argues for a drill variant where the audio cue arrives during a demanding visual task (dual-task), not only in silence. This is extrapolation; inattentional deafness studies use tones, not meaningful learned sounds.
- Raising the footstep level relative to the masker (in-game mix, EQ) addresses energetic masking; it does not address attentional misses. Both need separate manipulation in the drill (signal-to-noise ratio and concurrent visual load).
- By analogy with the visual camouflage findings in the existing report (learning within similar scenery), detection learning is likely to be specific to the sound class and masker type. To have any chance of transfer, stimuli should resemble game footsteps and game maskers in spectrum and rhythm, and vary widely.

### Gaps
- No study found on training detection of footsteps or similar impulsive sounds under gunfire/music/voice maskers, or on its transfer.
- No evidence on whether attentional misses under visual load are reduced by training.
- Informational masking literature (speech-on-speech, voice chat as masker) not searched.

## 5. Call of Duty audio specifics, with CS2 and Valorant for contrast

### Takeaway
Footstep audibility in CoD is a tuning decision that changes every title and often mid-season, is gated by perks, and has been a constant complaint; the trainer should therefore train across a range of footstep levels rather than emulate one build. Since Black Ops 6 the game has shipped an Embody Immerse HRTF mode with a free generic profile and a paid personalised one, which means a CoD player's in-game renderer is not the same HRTF as any trainer would use.

### Cited Findings
- [DEV, SNIP: official patch notes surfaced by search, page not opened] Warzone Season 1 (BO6 integration, Nov 2024): reduced first-person (own) footstep volume, increased enemy footstep volume, reduced environmental reverb on all footsteps. — [callofduty.com Season 01 patch notes](https://callofduty.com/patchnotes/2024/11/call-of-duty-bo6-warzone-season-01-patch-notes)
- [DEV, SNIP] Warzone Season 2 Reloaded (BO6): Tracker perk no longer live-pings; it outlines enemies (not through walls); a Cold Blooded fix lets footsteps be "appropriately countered". — [callofduty.com Season 02 Reloaded notes](https://callofduty.com/patchnotes/2025/01/call-of-duty-black-ops-6-season-02-patch-notes)
- [DEV via press, SNIP] BO6 uses Microsoft Project Acoustics for propagation; example given that snow absorbs footstep audio and trees reflect gunfire. Enhanced Headphone Mode uses Embody's Immerse Spatial Audio (HRTF) for directional accuracy. — [GamingTrend](https://gamingtrend.com/news/listen-closely-call-of-duty-black-ops-6-introduces-new-audio-improvements-in-latest-update); primary source (could not fetch): [Call of Duty blog, BO6 audio intel](https://www.callofduty.com/ca/en/blog/2024/10/call-of-duty-black-ops-6-dynamic-soundscape-audio-intel)
- [DEV (Embody support page), read] Universal profile: free, generic HRTF "based on average head and ear shapes", tuned to CoD's audio design. Personalised profile: USD 19.99 one-time with 30-day trial, described as a 5-year licence per platform; requires video capture of head and ears; tuned for 140+ headphone models; marketed as "Highest Spatial Precision" with no quantified or independent accuracy data. The page also lists "Modern Warfare 4 exclusives: Spatial Voice Chat and Multibus Spatial Tuning". — [Embody support KB](https://support.embody.co/portal/en/kb/articles/universal-vs-personalized-profiles-key-differences)
- [COM/press] PC Gamer characterised the personalised tier as a USD 20 paid tier lasting five years after a 30-day trial, which drew "pay to hear" criticism. — [PC Gamer](https://pcgamer.com/games/call-of-duty/what-exactly-is-up-with-black-ops-6s-enhanced-headphone-mode-and-its-usd20-paid-tier)
- [COM/press reporting a pro player's claim, SNIP] BO6: pros complained about footstep audio; Dexerto reported, second-hand via a pro player, that Treyarch was looking at the Ninja perk. — [Dexerto](https://dexerto.com/call-of-duty/black-ops-6-devs-buffing-ninja-perk-as-pros-complain-over-footstep-audio-2982614)
- [COM, SNIP] BO6 Season 5 Reloaded (Sept 2025): players reported Ninja no longer silenced footsteps; not in the patch notes. — [Beebom](https://beebom.com/latest-black-ops-6-reloaded-update-completely-breaks-this-fan-favorite-perk/)
- [DEV via press, SNIP] Black Ops 7 pre-launch (Oct 2025 dev talk after beta): Treyarch slightly increased multiplayer footstep volume because beta footsteps were nearly undetectable, which had made Ninja pointless; intent stated as Ninja being an option rather than a necessity. — [GamesRadar](https://www.gamesradar.com/games/call-of-duty/call-of-duty-black-ops-7-will-now-let-players-aim-down-sights-while-sliding-diving-and-wall-jumping-without-hated-dexterity-perk-and-its-also-adding-louder-footsteps); [esports.gg](https://esports.gg/news/call-of-duty/black-ops-7-makes-huge-changes-to-perks-aim-assist-and-more-before-launch/)
- [COM/press, SNIP] Modern Warfare 2019: Dead Silence was a timed field upgrade (about 15 s), not a perk; widespread complaints that footsteps were too loud; Infinity Ward's Joe Cecot said the team was working on it; a later patch tweaked footstep volume. — [Upcomer](https://upcomer.com/modern-warfare-dead-silence-footsteps); [Stevivor](https://stevivor.com/news/new-call-duty-modern-warfare-patch-tweaks-footstep-volume/)
- [DEV via press, SNIP] Modern Warfare II (2022): Dead Silence again a field upgrade; launch patch made players quieter after beta feedback and "drastically decreased" the Dead Silence activation sound range; a later patch adjusted crouch-walk and ADS-walk sounds. — [NME](https://www.nme.com/news/modern-warfare-2-launch-patch-makes-players-much-quieter-3337490); [Charlie Intel](https://www.charlieintel.com/call-of-duty-modern-warfare-2/dead-silence-is-a-field-upgrade-in-modern-warfare-2-not-a-perk-198383/)
- [COM] Windows "Loudness Equalization" (playback device enhancements) is widely recommended in guides to hear footsteps; it lifts quiet sounds and limits loud peaks across everything, not just footsteps. Counter-claims in the community: it flattens level differences, hurts distance/direction judgement and can pump or fatigue. No measurements offered either way. — [esports.gg guide](https://esports.gg/guides/call-of-duty/how-to-use-loudness-equalization-to-your-advantage-in-mw2-and-warzone-2); [TheSpike](https://www.thespike.gg/warzone/beginner-guides/how-to-make-footsteps-louder); [Steam discussion](https://steamcommunity.com/app/1938090/discussions/0/6589423683861843746)
- [COM, SNIP] Typical community preset advice for current Warzone: "Treyarch Mix", effects 100, music 0, dialogue 40 to 50, mono off. Affiliate-style sites publish specific EQ curves without evidence. — [setup.gg](https://www.setup.gg/game/warzone/best-audio-settings/)
- [COM, SNIP] CS2: Steam Audio-based 3D positional audio is always on with no HRTF toggle (unlike CS:GO); guides advise stereo output and no external virtual surround. Source is a fan site, not Valve. — [csdb.gg audio guide](https://csdb.gg/guides/audio-guide/)
- [DEV] Valorant patch 2.06 (March 2021) added an optional HRTF toggle; Riot's notes say it helps pinpoint footsteps, reloads and Deathmatch respawns, i.e. HRTF is applied to a limited set of sounds. Current behaviour not re-verified. — [Riot patch notes 2.06](https://playvalorant.com/en-us/news/game-updates/valorant-patch-notes-2-06)

### Inferences
- Loudness equalisation is dynamic range compression. Level is the primary distance cue (section 1), so compression should, in principle, trade detection (quiet footsteps become audible) against distance judgement (near and far sound more alike). That is reasoning from psychoacoustics, not a measured result in CoD.
- Because footstep level, perk gating and renderer change by title and season, the durable trainable skills are detection at low signal-to-noise, left/right and front/back resolution, and the turn response, not memorising one title's footstep sound.
- The existence of perks that silence footsteps means some in-game enemies give no audio cue at all; drills should include no-cue trials so players do not over-rely on sound, and to measure the audio benefit as a within-player difference.
- A sensible recommendation to users is to train with the same headphones and Windows enhancement state they play with.

### Gaps
- The official BO6 audio blog could not be fetched; statements about sound prioritisation, mix presets and hearing-accessibility options are not verified. Official names and descriptions of current audio mix presets were not confirmed.
- No sourced information on MW3 (2023) Covert Sneakers, Vanguard, Cold War Ninja, or on the 2026 title (the Embody page implies it is Modern Warfare 4; an Insider Gaming link about an MW4 footstep patch appeared in results but was not read).
- No technical description of how CoD attenuates footsteps with distance, or of occlusion behaviour, from a developer source.
- No independent test of Embody personalised versus universal profile accuracy.
- CS2 "always-on HRTF" lacks a Valve primary source in what I retrieved.

## 6. Technical options on Windows (Godot 4 and alternatives)

### Takeaway
Godot's built-in 3D audio is panning and attenuation without HRTF, so a perceptually valid drill needs a spatialiser add-on, and the best-known one (stechyo/godot-steam-audio) was archived on 7 October 2026. Audio onset time in Godot can only be estimated (next mix chunk plus output latency), and the engine's reported latency has been shown to be inaccurate, so onset timing must be calibrated with a physical loopback measurement.

### Cited Findings
- [DEV (repo README), read] stechyo/godot-steam-audio: GDExtension integrating Steam Audio into Godot 4.4; features listed are spatial ambisonics audio, occlusion and transmission through geometry, distance attenuation, reflections/reverb, dynamic geometry; self-described alpha ("may crash"); Windows and Linux working; MIT licence (Steam Audio itself Apache with some proprietary libraries); README does not mention custom SOFA loading; repository archived read-only on 2026-10-07 with the author inviting forks. — [GitHub](https://github.com/stechyo/godot-steam-audio)
- [DEV/store listing, SNIP] "Nexus Resonance" on the Godot asset store bundles Steam Audio, lists HRTF/binaural spatialisation and occlusion/transmission through mesh geometry, requires Godot 4.6+, MIT. Not evaluated; store reviews may be promotional. — [Godot asset store](https://store.godotengine.org/asset/movec/nexus-resonance/)
- [DEV, SNIP] vespergamedev/godot_steamaudio is an engine module (requires building Godot) rather than an add-on. — [GitHub](https://github.com/vespergamedev/godot_steamaudio)
- [DEV, SNIP] Valve's documentation: Steam Audio supports custom HRTFs from SOFA files (a restricted subset of the AES SOFA format); models ray-cast occlusion, partial occlusion for non-point sources and transmission. The Unreal plugin does not support custom HRTFs, so SOFA support is per-integration. — [Steam Audio FMOD guide](https://valvesoftware.github.io/steam-audio/doc/fmod/guide.html); [Steam Audio Unreal guide](https://valvesoftware.github.io/steam-audio/doc/unreal/guide.html)
- [COM, SNIP] A Godot forum thread on native HRTF points to a proposal that went nowhere (thread is old). — [Godot forum](https://forum.godotengine.org/t/no-hrtf-positional-audio/17372)
- [DEV (Godot docs), read] Audio is mixed in chunks; `play()` takes effect at the next mix. `AudioServer.get_time_to_next_mix()` estimates the wait to the next chunk; `AudioServer.get_output_latency()` estimates mix-to-ear delay. Heard-time estimate = system time at `play()` + time_to_next_mix + output_latency. Smaller buffers cut latency but risk dropouts. No typical values given. — [Godot docs: Sync the gameplay with audio and music](https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html)
- [COM (engine issue), SNIP] Godot issue: `get_output_latency()` and the output-latency project setting are inaccurate; reporter estimated about 23 ms real at the default 15 ms setting and 44.1 kHz, and the function returns the same value regardless. Fix status unknown. — [godotengine/godot issue 38215](https://github.com/godotengine/godot/issues/38215)
- [DEV (source mirror), SNIP] Godot's WASAPI driver requests IAudioClient3, used for adjustable output latency, which indicates a shared-mode low-period path; no evidence of an exclusive-mode option. — [audio_driver_wasapi.cpp mirror](https://remotebranch.eu/Stowage/godot/src/commit/0505b08a5607d2f488ec69cf2bd4e8b83bd97ede/drivers/wasapi/audio_driver_wasapi.cpp)
- [DEV (Microsoft)] Microsoft documents low-latency shared-mode streams (IAudioClient3) and advises evaluating them before committing to exclusive mode, in which the app has sole use of the endpoint. — [Microsoft: Low Latency Audio](https://learn.microsoft.com/en-sg/WINDOWS-HARDWARE/DRIVERS/audio/low-latency-audio); [Microsoft: Exclusive-mode streams](https://learn.microsoft.com/en-ie/Windows/Win32/coreaudio/exclusive-mode-streams)
- [COM, SNIP] CC0 footstep sets exist on OpenGameArt (wood, stone, leaves, gravel, mud). Licences vary per pack; one free itch.io footstep collection is CC BY-SA 4.0. — [OpenGameArt: different steps](https://opengameart.org/content/different-steps-on-wood-stone-leaves-gravel-and-mud); [OpenGameArt: footsteps 0](https://opengameart.org/content/footsteps-0); [audioelk itch.io licence note](https://audioelk.itch.io/free-sounds-footsteps-collection/devlog/863623/now-licensed-under-cc-by-sa-40-deed)

### Inferences
- Minimum viable renderer for a valid drill: true HRTF convolution with per-ear ITD, distance attenuation, and a simple low-pass/level occlusion model. Reflections and pathing are optional for a first version; the training literature in section 2 used anechoic HRTF rendering.
- Given the archived plugin, three workable routes: (a) fork godot-steam-audio or use Nexus Resonance after verifying it does real HRTF and checking latency; (b) write a small GDExtension around Steam Audio's C API (`iplBinauralEffect`) or OpenAL Soft feeding an `AudioStreamGenerator`, which also gives control over SOFA loading; (c) pre-render: because drill sources are scripted, convolve footstep clips offline with a SOFA HRTF at a grid of directions and play back the nearest/crossfaded result. Route (c) is simplest and gives exact timing, but cannot update smoothly during fast camera turns unless the grid is dense or the convolution runs live, and the live update during the turn is what resolves front-back (section 1). These are engineering judgements, not sourced facts.
- Being able to load several SOFA HRTFs matters for the specificity risk: training across multiple HRTFs is the obvious hedge against renderer-specific learning (analogy to variability-of-practice; Steadman's cross-HRTF transfer makes it plausible).
- Timing: log `Time.get_ticks_usec()` at `play()`, plus `get_time_to_next_mix()` and `get_output_latency()`, then correct with a one-off measured offset. Calibrate by loopback: play a click with a simultaneous screen flash or known input event, record headphone output with a microphone or line loopback, and measure the offset and jitter. Jitter of up to one mix chunk is the floor on per-trial reaction-time precision unless audio is scheduled sample-accurately in a generator callback. USB and especially Bluetooth headsets add unknown fixed delay; recommend wired and record the device name per session.
- Windows spatial sound (Sonic/Atmos/DTS), headset virtual surround and Loudness Equalization would double-process the trainer's HRTF output; the trainer should instruct users to output plain stereo for the HRTF drills, and record whether enhancements are on.

### Gaps
- Not verified: whether any current Godot add-on performs HRTF binaural rendering with SOFA loading (the archived README lists "spatial ambisonics audio", not HRTF explicitly); Nexus Resonance quality and maintenance; Godot 4.7.x compatibility of any of these.
- No measured Godot audio output latency figures on Windows for current versions; no confirmation of whether the latency-reporting issue was fixed.
- Resonance Audio, Meta XR Audio, Microsoft Spatial Sound and OpenAL Soft integration with Godot 4 not researched; no results surfaced.
- Sonniss GDC bundles, Freesound (CC0 filter) and Kenney audio licences were not confirmed this session; check each pack's licence before shipping. Free gunfire/ambient sources not researched.

## 7. Design implications for an audio-cued drill

### Takeaway
The evidence supports a drill built around coarse, fast orienting to an unseen target: sound gives hemisphere and rough bearing, the player turns, vision finishes. The measurable, trainable weak point is front-back resolution, and the main validity risk is that gains are specific to the trainer's renderer, so the design should vary renderers and sounds and measure the audio benefit within-player.

### Cited Findings
- Active responding with position feedback is required; passive exposure does not help. — [Mendonça et al. 2012](https://repositorium.sdum.uminho.pt/handle/1822/26405) [PR, abstract]
- 12-minute blocks; most gain within the first few blocks; game dressing alone adds nothing; letting the listener move while the sound continues gives the biggest gains. — [Steadman et al.](https://www.biorxiv.org/content/10.1101/207753v3.full) [PP full text; PR published]
- Individual response varies widely and some listeners do not adapt to a given HRTF. — [Stitt et al. 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6355836/) [PR, full text]
- Continuous/updating cues beat one-shot cues for out-of-view search. — [Flanagan et al. 1998](https://scilit.com/publications/1eb24625dc9c5e431e805f3b46f356de) [PR, abstract via search]
- Listener-controlled movement resolves front-back ambiguity without head movement. — [Wightman & Kistler 1999](https://data.zhenzhi.com/details/1/861554450) [PR, abstract via search]
- High visual load lowers auditory detection sensitivity. — [Raveh & Lavie 2015](https://discovery-pp.ucl.ac.uk/1454101/1/art_10.3758_s13414-014-0776-2.pdf) [PR, abstract via search]
- Training with broadband noise produced better learning than speech. — [Mendonça et al. 2013](https://acris.aalto.fi/ws/portalfiles/portal/12865609/journal.pone.0077900.pdf) [PR, abstract]

### Inferences
All items below are design extrapolations from the cited evidence, not tested designs.

Parameters to control and log per trial:
- Source azimuth relative to current view (bins: front in-FOV, side out-of-FOV, rear), elevation (same floor, above, below), distance.
- Cue type: single step, step train (rate, number of steps), surface material; stationary versus moving source and its path.
- Level: footstep level relative to masker (signal-to-noise ratio), masker type (none, ambient, distant gunfire, own gunfire, music, voice chatter).
- Occlusion state (clear, behind wall), reverb preset.
- Renderer: HRTF set identifier, any Windows/headset processing declared by user, output device.
- Cue-to-visible delay (how long after cue onset the target becomes visible or rounds the corner), and no-cue control trials.
- Concurrent visual load (none versus a tracking/shooting task in progress).

Measures:
- Cue onset (latency-corrected) to first mouse movement.
- Direction of the initial turn: correct side (left/right) and correct hemisphere (front/back), reported separately; front-back error rate is the headline learning metric.
- Angular error at the end of the first ballistic turn, before visual correction.
- Time to target entering FOV, time to crosshair on target, time to first hit; plus the same measures on no-cue trials so the audio benefit is a within-player difference.
- Detection rate and false alarms at each signal-to-noise level (signal-detection d' and criterion), since guessing turns will otherwise inflate apparent detection.

Difficulty adaptation:
- Staircase on signal-to-noise ratio for detection; separate staircase on cue duration/number of steps for localisation (shorter cue means less dynamic information).
- Progress from left/right only, to front/back in quiet, to front/back with maskers, to moving and occluded sources, to dual-task.
- Keep stimulus variety high (surfaces, HRTFs, maskers) rather than drilling one sound.

Risks:
- Renderer-specific learning: partial evidence of cross-HRTF transfer, none for transfer to CoD. Mitigate with multiple HRTFs and by tracking an in-game outcome (the existing report's transfer-measurement principle applies).
- Non-responders: detect and redirect rather than prescribe more reps.
- User hardware variance: headphone frequency response, EQ, loudness equalisation and virtual surround change the spectral cues; record them and advise consistency with the play set-up.
- Timing validity: audio onset uncertainty of roughly a mix chunk plus unknown device delay; calibrate per device.
- Elevation and distance scores will be noisy and may not improve; avoid making them headline metrics.
- Over-reliance: silent-enemy perks mean audio is not always available; include no-cue trials.
- Hearing safety: users raise volume to hear faint footsteps; the trainer should fix or cap output level, improve detection via practice at a set level rather than via loudness, and avoid sudden loud maskers.

### Gaps
- No sourced safe-listening figures were retrieved (e.g. WHO/NIOSH exposure limits); add a primary citation before stating any dB or duration limit.
- No evidence on optimal no-cue trial proportion, staircase rules for this task, or how many HRTFs to rotate.
- No existing aim trainer with an audio-cued mode was identified or ruled out; the "no aim trainer trains this" premise was not checked this session.
