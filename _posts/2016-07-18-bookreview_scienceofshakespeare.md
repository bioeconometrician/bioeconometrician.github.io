---
title: 'The Science of Shakespeare by Dan Falk (Book Review)'
output: html_document
fontsize: 12pt
published: true
status: publish
mathjax: true
---

<p align="center">
<img src="http://centreforinquiry.ca/wp-content/uploads/2014/05/The-SCience-of-Shakespeare.png" width=300 />
</p>

After having seen *Othello* performed at *Bard on the Beach*, I was put in quite a Shakespearean mood and decided to pick up Dan Falk's *The Science of Shakespeare* off my bookshelf. The book gives both a brief history of scientific progress during the Elizabethan/Jacobean eras in which Shakespeare lived as well as an analysis of how much the Bard may have known about the scientific developments that were occuring at the time. The book's takeaways are threefold:

 * The state of scientific developments, mainly cosmological, were well-known throughout Europe even if many believed them to be incorrect.
 * There is historic evidence that many of Shakespeare's contemporaries were familiar with scientific developments that were occurring on the continent.[^n]
 * It is possible that some of Shakespeare's plays *may* make reference to contemporary cosmological events.

### A Brief History of Cosmology: Copernicus, Brahe, and Kepler

When Shakespeare was born in 1564, the same birth year as Galileo coincidentally, Nicolaus Copernicus (1473-1543) had already published his intellectually ground-breaking *De revolutionibus* twenty-one years earlier. The book proposed that our conception of the solar system was wrong: the earth was the third planet from the sun (see Figure 1), and not in the center as had been previously imagined. Whilst knowledge traveled much slower in 16th century Europe than it does today, there is no chronological problem with the idea that Will may have been abreast of these developments. It's interesting to note that while *De rev.* was likely the first book to visually present the proper order of the universe,[^n] it is more a continuation of the existing Ptolemaic order; swapping the earth for the sun. For example, the planets still had circular orbits augmented by additional complex movements defined by 'eccentrics' and 'epicycles' in order to align the observational evidence with the underlying theory. It would be more than a hundred years before Newton would introduce the theory of gravity to fully explain these movements (although Kepler would identify the true elliptical nature of orbits some years earlier).

<h5> Figure 1: Copernicus' schemata wrought a new cosmological conception </h5>
<p align="center">
<img src="https://s-media-cache-ak0.pinimg.com/564x/03/5e/71/035e7163d9ab7714de7c5a7887c48526.jpg" width=300 />
</p>

Tycho Brahe (1546-1601), an ambitious Danish nobleman, was perhaps the luckiest scientist in the 16th century as he won favor with the Danish Crown as was given a large sum of money to set up an observatory on the island of Hven. The observatory, called Uraniborg, generated the most important observational data on the sun, moon, stars, comets, and other planets during this period. The project on Hven was impressive, and according to Falk its costs was around 1-1.5% of the Danish national budget. The data generated from Uraniborg would ultimately prove instrumental for cosmology by allowing Kepler to correctly deduce the actual shape of planetary orbits. 

I was able to find a [dataset](http://www.pafko.com/tycho/observe.html) of Tycho's the angle of declination of Mars (from the perspective of Uraniborg) over 18 years from 1582 to 1600 (note Hamlet was published around 1600), with an obvious sinusoidal relationship in the data (see Figure 2).

<h5> Figure 2: Observational data generated from Tycho's observatory on the island of Hven</h5>
<p align="center">
<img src="/content/images/2016/07/raw_dat.png" width=500>
</p>

After trying to fit the data to a simple sinusoidal relationship of the form: \\$y=a+b \times sin(t/d)\\$, I found the fitted values to be unsatisfactory and instead tried a more complicated angular relationship as I suspected that the tilting of the Earth's axis may cause another trigonometric relationship to enter the data. This time, in my model I included both a sine and a cosine term: \\$y=a+b \times cos(t/d) + c \times sin(t/d)\\$, and found the fit to be much better, as shown in Figure 3. I suspect that the outliers may be driven by measurement error or a more complicated underlying model! The data can be fitted using the `nls` function in R:[^n]

```r
# Estimate n.ols
k.nols <-  nls(D/scale ~ a+b*cos(Idx/d)+c*sin(Idx/d),
                 start=list(a=mean(idx.dat\\$D)/scale,b=1,c=1,d=w),data=idx.dat,
               control=list(maxiter=5000))
```

<h5> Figure 3: A simple model predicts the position of Mars in the night sky </h5>
<p align="center">
<img src="/content/images/2016/07/model-1.png" width=500>
</p>

In a somewhat striking coincidence, the 16th century had a collection of exceedingly rare astronomical events. For example, the arrival of the Great Comet of 1577 allowed Tycho to calculate that this comet was farther away from Earth than the moon was, a direct affront to the existing theories at the time. More importantly, in November 1572 astronomers throughout Europe noticed a brand new star in the heavens that shone with unparalleled incandescence. What astronomers were seeing at the time was a supernova from the Cassiopeia constellation that had exploded some 9000 years previously. What came to be known as 'Tycho's star', was another revolution in cosmology as it violated the Aristotelian view of the unchangeable heavens. Falk highlights that many scholars attribute this supernova as an incredibly important event in unraveling the existing medieval worldview:

> Those who wanted to cling to the universe of Aristotle and Ptolemy may have dismissed the Copernican model of the solar system as a mathematical convenience but there was no escape from the implications of Tycho's new star, observed by skywatchers across Europe and found to lie in the supposedly immutable heavens.

Brahe also correctly understood that because the stars have no parallax,[^n] they must either be so far away that the visual effect is imperceptible or the Earth is motionless at the center of the universe (and the stars perfectly revolve around us). Unfortunately, Brahe decided the latter was more plausible and found a way to square the geocentric Ptolemaic view with some of the conceptual improvements Copernicus had discussed in *De rev* as shown in Figure 4 below.

<h5> Figure 4: Brahe puts the theories of Copernicus and Ptolemy in a Procrustean bed </h5>
<p align="center">
<img src="https://www.imcce.fr/langues/en/grandpublic/systeme/promenade-en/images/jpg8/822.jpg" width=300 />
</p>

### Science in Elizabethan England

What is the likelihood that Shakespeare knew about of these developments à la Copernicus, Brahe, and Kepler? Well we know that contemporaries of Shakespeare certainly were aware of the advances that were going on in cosmology. For example we know a gentleman-scientist by the name of the Thomas Diggs was writing to continental scientists agreeing with the Copernican world view in the 1570s. Diggs published *A Prognostication Everlasting* in 1576 with a translation of *De rev.* in the Appendix, and he pretty much hit the cosmological nail on the head:

> ... that devine Copernicus of more that human talent ... a rate wit .... who has recently proposed that the Earth resteth not in the Center of the whole word, but ... is carried yearly round about the sun, which like a king in the midst of all reigneth and giveth laws of motion to the rest, spherically dispersing his glorious beams of light through all this sacred celestial temple.

Furthermore in Diggs visualization of the solar system he included this text in the concentric ring which contained the stars:[^n]

> This orb of fixed starts infinitely extends itself in spherical altitude, and is therefore an immovable palace garnished with perpetual shining and innumerable glorious lights that far exceed our sun both in quantity and quality of the court of celestial angels devoid of grief and replenished with with perfect and endless joy for the habitation of the elect. (*Translation mine*)

This statement in addition to sounding very new age, echoes some lines from Hamlet:

> O God, I could be bounded in a nutshell, 

> And count myself a king of infinite space-

> Were it not that I have bad dreams. (Hamlet II.ii.254-257)

The other figure in Elizabethan science who is of note is John Dee, a man who is speculated to have been the inspiration for both Prospero in *The Tempest* as well as the title characters in Ben Johnson's *The Alchemist* and Christopher Marlowe's *Dr. Faustus* (as well as Dumbledore in more recent times). Dr. Dee was an odd bird, who believed that he owned a magic crystal which acted as a direct line to the holy ghost and he straddled the profession of magician-fraud and scientific Renaissance man. Like Diggs, we have written evidence that Dee was familiar with the Copernican model of the solar system. Could Shakespeare have known Dee and been subsequently explained the Copernican worldview? Falk puts forward three pieces of evidence for this proposition:

 * Dee was widely well regarded in his country "[A]nyone who was anyone in Elizabethan natural philosophy knew Dee."
 * Shakespeare and Dee both lived in Mortlake briefly in 1603 during an outbreak of the plague.
 * Dee was known to be a fan of the theatre and may have met Will post-production.

Yet another interesting figure in England at the time Shakespeare was acting and writing plays was Giordano Bruno, a philosopher who was forced to leave Italy due to his heretical views on an infinite universe. Bruno has re-entered the public's imagination due to his story being highlighted in the new *Cosmos* TV series.

<iframe src="https://player.vimeo.com/video/89241669" width="525" height="358" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

In 1585, Bruno lectured at Oxford (in an Italian-accented Latin no doubt difficult for the locals to understand) where he indubitably aligned himself with the Copernican worldview, and had no qualms about discarding the fusty theories that had been perpetuated since antiquity.

> For he [Copernicus] had a profound, subtle, keen, and mature mind. He was a man not inferior to any of the astronomers who preceded him ... his natural judgement was far superior to that of Ptolemy, Hipparchus, Eudoxus, and all the others who followed them, and this allowed him to free himself from many false axioms of the common philosophy, which- although I hesitate to say so - had made us blind. 

Bruno also clearly allied himself with the infinite universe theory and expounded upon it in an even more clear manner than Digges.

> There is a single general space, a single vast immensity which we may freely call Void: in it are innumerable globes like this on which we live and grow: this space we declare to be infinite, since neither reason, convenience, sense-perception nor nature assign to it a limit.

Unfortunately Bruno decided to return to Italy (despite being excommunicated) and was shortly thereafter tried and found guilty of heresy, and he received the punishment of being burned alive at the stake for his intellectual sacrilege. Again, might Will have known about an eccentric Italian, banned by the Catholic church, who was roaming England and expostulating radical views about the universe? It all depends on how likely one believes it was that Shakespeare kept abreast of developments in natural philosophy. Alternatively, one could invert the question and ask how could Shakespeare not have known about such developments? After all he lived in a London that was teeming with all and sundry; as Dekker put it:

> For at one time, in one and the same rank, yea, foot by foot and elbow by elbow, shall you see walking [in London], the knight, the gull, the gallant, the upstart, the gentleman, the clown, the captain, the apple-squire, the lawyer, the usurer, the citizen, the bankrupt, the scholar, the beggar, the doctor, the idiot, the ruffian, the cheater, the puritan, the cut-throat, the high man, the low man, the true man, and the thief.

### Evidence in the canon?

Conditional on Shakespeare having known about the state of scientific knowledge, is there any evidence he put any of it in his plays? Starting with *Hamlet*, we hear the guard Bernardo describe the night's sky: "Last night of all, / When young same star that's westward from the pole". Falk cites research from Donald Olsen that has attempted to identify which star Bernardo may have been referring to. Olsen's research suggests it may have been Tycho's star. If so, was the Bard making reference to a cosmological event that was known to have undermined the existing world view? Given that the play is about the usurpation of the existing order in the Danish kingdom this would seem likely. 

Any other clues? Well, a portrait of Brahe known to have been owned by Thomas Digges included two crests of his extended family: "Rosenkrans" and "Guildensteren". Sound familiar? And let us not forget the "King of infinite space" comment. Is any of this convincing? My initial instinct is no for two reasons. First, there are hundreds of interpretations of *Hamlet*, and therefore *a priori* most of the analyses must be wrong (in the sense that Shakespeare deliberately meant the play to be read in a specific way).[^n] Second, researchers interested in finding links between the canon and scientific developments are poring over the text and then *ex-post* reasoning about connections. We should expect that in a literary canon written in poetic and sometimes cryptic language we would expect some phrases to sound like they could be making reference to the Copernican model of the solar system by chance alone.

The most famous development in early-modern astronomy were of course the discoveries of Galileo in 1610. By looking at the moon and Jupiter through a telescope he found two things: (i) the moon has topological features just like the earth, and (ii) Jupiter has moons just like the earth. The uniqueness of *Terre* was waning, and fast. News of these discoveries were instantly communicated throughout Europe. Outside of Hamlet, the strongest evidence for 'Science in Shakespeare' comes from the play *Cymbeline* which was performed one year after Galileo's discoveries. In it, there is an odd scene where the god Jupiter descends with four ghosts to dispense judicial wisdom to the characters of the play. Given that Galileo's discoveries were intimately linked to finding four moons orbiting Jupiter, it seems highly likely this was a symbolic reference. However, just as one can subconsciously adopt the mannerisms of the person one is talking with, this need not mean anything more than Jupiter was on the Bard's mind at the time. To many Shakespearean scholars though, if this were accepted it would represent a departure from the view that Will was ignorant of the Copernican/Galilean revolutions and/or made no reference to it in his plays (which is the mainstream view currently). 

Whilst astrological references abound throughout the Shakespearean canon, it's also clear that Will was skeptical of astrology himself, or at least aware of the justification for why it was a suspect art.[^n] There is the highly-rational Edmond in *King Lear*, who like the villainous Iago, employs ruthless cunning to manipulate those around him. After his father makes a comment about the bad "portends" of the heavens, he deliver's a famous soliloquy:

> This is the excellent foppery of the world, that when we are sick in fortune, often the surfeits of our own behavior, we make guilty of our disasters the sun, the moon, and the stars; as if we were villains by necessity, fools by heavenly compulsion, knaves, thieves, and treachers by spherical predominance, and all that we are evil in by a divine thrusting on. 

Or consider Hotspur poking fun at the Welsh rebel captain Glendower's bluster on his nativity:

> **Glendower**: At my nativity / The front of heaven was full of fiery shapes, / Of burning cressets, and at my birth / The frame and huge foundation of the earth / Shakes like a coward.

> **Hotspur**: Why, so it would have done at the same season, if your mother's cat / had but kittened, though yourself had never been born.

> **Glendower**: I say the earth did shake when I was born.

> **Hotspur**: O, then the earth shook to see the heavens on fire, / And not in fear of your nativity. / Diseased Nature oftentimes breaks forth / In strange eruptions; oft that the teeming earth / Is with a kind of colic inched and vexed / By the imprisoning of unruly wind / Within her womb, which, for enlargement striving, / Shakes the old beldam earth and topples down / Steeples and moss-grown towers. At your birth / Our grandam earth, having this distemperature, / In passion shook.

What makes this speech resonate with us today is that is both disregards superstitious thinking and mocks it with the vehemence we associate with the [New Atheist](https://en.wikipedia.org/wiki/New_Atheism) movement. Again, Falk makes the point that whether or not Shakespeare was a religious skeptic is irrelevant in the sense that his understanding of the arguments shows that he was likely aware of the scientific developments of the time.

### In toto..

Returning to our the three original hypotheses that Falk seeks to address the informed reader leaves feeling the balance of evidence is on side of those who believe Shakespeare was more aware of the scientific developments at the time than modern scholars likely appreciate. However, most of the evidence for this comes from the general Elizabethan intellectual milieu, which modern research suggests was more scientific than many assume. Of course, as Falk points out, we must always understand that there was no idea of *science* in the way we understand it today:

> Magic and science were deeply intertwined, and it would take more than a century for chemistry and alchemy to permanently part ways. Still, when natural philosophy rose in stature toward the middle of the seventeenth century it owed an enormous debt to the natural magic of an earlier age. Francis Bacon, like Kepler, was a figure influenced by the magical tradition, but was crafty enough to try to separate the intellectual wheat from the pseudoscientific chaff. 

For both Shakespeare lovers and those interested in the history of science I highly recommend *The Science of Shakespeare*. After reading the book, one will have a new take on some of plays, especially *Hamlet*, as well as some of the characters, like Edmond and Hotspur, as well as a better understanding of how the age in which Shakespeare lived coincided with important events in the chronology of scientific advancements.

* * *

[^n]: Note that the word 'scientist' is an anachronism both etymologically (the word was coined in 1833 by William Whewell) but also conceptually as individuals who we would regard as scientists like Galileo or Copernicus thought of themselves as 'natural philosophers' and did not draw clear distinctions between true astronomy and other artistic forms. 

[^n]: Note that Copernicus was not the first person to propose a heliocentric universe, as the ancient Greeks like Aristarchus had already put the  idea forward.

[^n]: Note that when doing non-linear OLS, its wise to test how stable the parameters are depending on the initial conditions. Additionally a scaling term is introduced to quasi-normalize the data (as this is easier for Gauss-Newton search algorithms). As Figure A1 shows below, the \\$d\\$ parameter converges to around 100 quickly, although higher equilibrium point are found but the results are not intuitive (i.e. why would the periodicity occur ever 1400 days for example?). Note the estimated results are as follows: \\$a=-0.12\\$, \\$b=0.57\\$, \\$c=0.62\\$, and \\$d=107\\$.

<h5> Figure A1: Parameter stabality </h5>
<p align="center">
<img src="/content/images/2016/07/nls.png" width=500 />
</p>

[^n]: Parallax is the change in visual perception depending on the angle you view an object. For example, if I were to Skype call my Ontario friends at midnight my time and ask where the moon was on the horizon for them, they would measure an different angle than I would, of course, as they are 5000km or so the east of me. Indeed we could use these three data points (my angle, your angle, and the distance between us) to gage the actual distance of the moon. 

[^n]: I have done my best to translate from the Renaissance print. The original text reads: "THIS ORBE OF STARRES FIXED INFINITELY UP EXTENDETH HIT SELF IN ALTITVDE SPHERICALLYE, AND THEREFORE IMMOVABLE THE PALLACE OF FOELICITYE GARNISHED WITH THE PERPETVALL SHININGE GLORIOVS LIGHTES INNVMERABLE FARR EXCELLINGE OVR SONNE BOTH IN QVANTITYE AND QVALITYE THE VERY COVRT OF COELESTIALL ANGELLES DEVOYD OF GREEFE AND REPLENISHED WITH PERFITE ENDLESSE IOYE THE HABITACLE FOR THE ELECT."

[^n]: This is just an appropriation of the argument I've heard Lawrence Krauss make against organized religion.

[^n]: Although poking fun at astrologers goes all the way back in English literature to Chaucer in *The Miller's Tale*:

> So fared another clerk with astronomy; / He walked into the meadows for to pry / Into the stars, to learn what should befall, / Until into a clay-pit he did fall; / He saw not that.
