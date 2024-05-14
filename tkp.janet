#!/usr/bin/env janet

(import spork/argparse)

### lookups

# source markers:
(def entry-sources
  '{
    :pu "pu"
    :ku-suli "ku suli"
    :ku-lili "ku lili"
    :none "no book"
    :sandbox "sandbox"
  })

(def entry-sources-default [:pu :ku-suli :ku-lili])

(defn entry-sources-find [text]
  (filter (fn [key] (string/find text (entry-sources key))) (keys entry-sources)))

# type markers:
(def entry-types
  '{
    :cwd "content"
    :pro "pronoun"
    :prv "pre-verb"
    :pre "preposition"
    :par "pure particle"
    :psp "pseudo-particle"
    :emo "emotive particle"
    :kwe "question"
  })

(defn entry-types-find [text]
  (filter (fn [key] (string/find text (entry-types key))) (keys entry-sources)))

(def dictionary
  '{
    ### pu
    # pure particles
    :li  ("li"  :pu :par "(between any subject except mi alone or sina alone and its verb; also to introduce a new verb for the same subject)")
    :o   ("o"   :pu :par "hey! O! (vocative, imperative, or optative)")
    :la  ("la"  :pu :par "(between the context phrase and the main sentence)")
    :anu ("anu" :pu :par "or | ALT choose, decide")
    :pi  ("pi"  :pu :par "of (used to divide a second noun group that describes a first noun group) | ALT (introduces a genitive noun)")
    :en  ("en"  :pu :par "(between multiple subjects)")
    :e   ("e"   :pu :par "(before the direct object)")
    # emotive particle
    :a   ("a"   :pu :emo "(emphasis, emotion or confirmation)")
    # pseudo-particles
    :nanpa ("nanpa" :pu :psp "-th (ordinal number); numbers")
    :ala   ("ala"   :pu :psp "no, not, zero; [~ ala ~] (used to form a yes-no question); nothing")
    :taso  ("taso"  :pu :psp "but, however; only")
    # prepositions
    :lon     ("lon"     :pu :pre "located at, present at, real, true, existing | ALT (affirmative response)")
    :tawa    ("tawa"    :pu :pre "going to, toward; for; from the perspective of; moving | ALT (pv.) going to")
    :tan     ("tan"     :pu :pre "by, from, because of; origin, cause")
    :sama    ("sama"    :pu :pre "same, similar; each other; sibling, peer, fellow; as, like")
    :kepeken ("kepeken" :pu :pre "to use, with, by means of")
    # question
    :seme ("seme" :pu :kwe "what? which?")
    # pronouns
    :mi   ("mi"   :pu :pro "I, me, we, us")
    :sina ("sina" :pu :pro "you")
    :ona  ("ona"  :pu :pro "he, she, it, they")
    :ni   ("ni"   :pu :pro "that, this")
    # content words
    :akesi   ("akesi"   :pu :cwd "reptile, amphibian")
    :alasa   ("alasa"   :pu :cwd "to hunt, forage, seek | ALT (pv.) try to, attempt")
    :ale     ("ale"     :pu :cwd "all; abundant, countless, bountiful, every, plentiful; abundance, everything, life, universe; one hundred | ALT 100")
    :ali     ("ali"     :pu :cwd "[alternate form of ale]")
    :anpa    ("anpa"    :pu :cwd "bowing down, downward, humble, lowly, dependent | ALT bottom, lower part, under, below, floor, beneath; low, lower, bottom, down")
    :ante    ("ante"    :pu :cwd "different, altered, changed, other")
    :awen    ("awen"    :pu :cwd "enduring, kept, protected, safe, waiting, staying; (pv.) to continue to, to keep")
    :esun    ("esun"    :pu :cwd "market, shop, fair, bazaar, business transaction")
    :ijo     ("ijo"     :pu :cwd "thing, phenomenon, object, matter")
    :ike     ("ike"     :pu :cwd "bad, negative; non-essential, irrelevant | ALT complicated, complex")
    :ilo     ("ilo"     :pu :cwd "tool, implement, machine, device")
    :insa    ("insa"    :pu :cwd "centre, content, inside, between; internal organ, stomach")
    :jaki    ("jaki"    :pu :cwd "disgusting, obscene, sickly, toxic, unclean, unsanitary")
    :jan     ("jan"     :pu :cwd "human being, person, somebody")
    :jelo    ("jelo"    :pu :cwd "yellow, yellowish")
    :jo      ("jo"      :pu :cwd "to have, carry, contain, hold")
    :kala    ("kala"    :pu :cwd "fish, marine animal, sea creature")
    :kalama  ("kalama"  :pu :cwd "to produce a sound; recite, utter aloud")
    :kama    ("kama"    :pu :cwd "arriving, coming, future, summoned; (pv.) to become, manage to, succeed in")
    :kasi    ("kasi"    :pu :cwd "plant, vegetation; herb, leaf")
    :ken     ("ken"     :pu :cwd "to be able to, be allowed to, can, may; possible")
    :kili    ("kili"    :pu :cwd "fruit, vegetable, mushroom")
    :kiwen   ("kiwen"   :pu :cwd "hard object, metal, rock, stone")
    :ko      ("ko"      :pu :cwd "clay, clinging form, dough, semi-solid, paste, powder")
    :kon     ("kon"     :pu :cwd "air, breath; essence, spirit; hidden reality, unseen agent")
    :kule    ("kule"    :pu :cwd "colorful, pigmented, painted | ALT of or relating to the LGBT+ community")
    :kulupu  ("kulupu"  :pu :cwd "community, company, group, nation, society, tribe")
    :kute    ("kute"    :pu :cwd "ear; to hear, listen; pay attention to, obey")
    :lape    ("lape"    :pu :cwd "sleeping, resting")
    :laso    ("laso"    :pu :cwd "blue, green")
    :lawa    ("lawa"    :pu :cwd "head, mind; to control, direct, guide, lead, own, plan, regulate, rule")
    :len     ("len"     :pu :cwd "cloth, clothing, fabric, textile; cover, layer of privacy")
    :lete    ("lete"    :pu :cwd "cold, cool; uncooked, raw")
    :lili    ("lili"    :pu :cwd "little, small, short; few; a bit; young")
    :linja   ("linja"   :pu :cwd "long and flexible thing; cord, hair, rope, thread, yarn | ALT line, connection")
    :lipu    ("lipu"    :pu :cwd "flat object; book, document, card, paper, record, website")
    :loje    ("loje"    :pu :cwd "red, reddish")
    :luka    ("luka"    :pu :cwd "arm, hand, tactile organ; five | ALT touch/feel physically, interact, press")
    :lukin   ("lukin"   :pu :cwd "eye; look at, see, examine, observe, read, watch; look for, seek; (pv.) try to")
    :lupa    ("lupa"    :pu :cwd "door, hole, orifice, window")
    :ma      ("ma"      :pu :cwd "earth, land; outdoors, world; country, territory; soil")
    :mama    ("mama"    :pu :cwd "parent, ancestor; creator, originator; caretaker, sustainer")
    :mani    ("mani"    :pu :cwd "money, cash, savings, wealth; large domesticated animal")
    :meli    ("meli"    :pu :cwd "woman, female, feminine person; wife")
    :mije    ("mije"    :pu :cwd "man, male, masculine person; husband")
    :moku    ("moku"    :pu :cwd "to eat, drink, consume, swallow, ingest")
    :moli    ("moli"    :pu :cwd "dead, dying")
    :monsi   ("monsi"   :pu :cwd "back, behind, rear")
    :mu      ("mu"      :pu :cwd "(animal noise or communication) | ALT (non-speech vocalization)")
    :mun     ("mun"     :pu :cwd "moon, night sky object, star | ALT glow, glowing light, light in the dark")
    :musi    ("musi"    :pu :cwd "artistic, entertaining, frivolous, playful, recreation")
    :mute    ("mute"    :pu :cwd "many, a lot, more, much, several, very; quantity | ALT three (or more), 20")
    :nasa    ("nasa"    :pu :cwd "unusual, strange; silly; drunk, intoxicated")
    :nasin   ("nasin"   :pu :cwd "way, custom, doctrine, method, path, road")
    :nena    ("nena"    :pu :cwd "bump, button, hill, mountain, nose, protuberance")
    :nimi    ("nimi"    :pu :cwd "name, word")
    :noka    ("noka"    :pu :cwd "foot, leg, organ of locomotion; bottom, lower part")
    :olin    ("olin"    :pu :cwd "love, have compassion for, respect, show affection to")
    :open    ("open"    :pu :cwd "begin, start; open; turn on")
    :pakala  ("pakala"  :pu :cwd "botched, broken, damaged, harmed, messed up | ALT (curse expletive, e.g. fuck!)")
    :pali    ("pali"    :pu :cwd "do, take action on, work on; build, make, prepare")
    :palisa  ("palisa"  :pu :cwd "long hard thing; branch, rod, stick")
    :pan     ("pan"     :pu :cwd "cereal, grain; barley, corn, oat, rice, wheat; bread, pasta")
    :pana    ("pana"    :pu :cwd "give, send, emit, provide, put, release")
    :pilin   ("pilin"   :pu :cwd "heart (physical or emotional); feeling (an emotion, a direct experience)")
    :pimeja  ("pimeja"  :pu :cwd "black, dark, unlit")
    :pini    ("pini"    :pu :cwd "ago, completed, ended, finished, past")
    :pipi    ("pipi"    :pu :cwd "bug, insect, ant, spider")
    :poka    ("poka"    :pu :cwd "hip, side; next to, nearby, vicinity | ALT along with (comitative), beside")
    :poki    ("poki"    :pu :cwd "container, bag, bowl, box, cup, cupboard, drawer, vessel")
    :pona    ("pona"    :pu :cwd "good, positive, useful; friendly, peaceful; simple")
    :pu      ("pu"      :pu :cwd "interacting with the official Toki Pona book")
    :seli    ("seli"    :pu :cwd "fire; cooking element, chemical reaction, heat source")
    :selo    ("selo"    :pu :cwd "outer form, outer layer; bark, peel, shell, skin; boundary")
    :sewi    ("sewi"    :pu :cwd "area above, highest part, something elevated; awe-inspiring, divine, sacred, supernatural")
    :sijelo  ("sijelo"  :pu :cwd "body (of person or animal), physical state, torso")
    :sike    ("sike"    :pu :cwd "round or circular thing; ball, circle, cycle, sphere, wheel; of one year")
    :sin     ("sin"     :pu :cwd "new, fresh; additional, another, extra")
    :sinpin  ("sinpin"  :pu :cwd "face, foremost, front, wall")
    :sitelen ("sitelen" :pu :cwd "image, picture, representation, symbol, mark, writing")
    :sona    ("sona"    :pu :cwd "know, be skilled in, be wise about, have information on; (pv.) know how to")
    :soweli  ("soweli"  :pu :cwd "animal, beast, land mammal")
    :suli    ("suli"    :pu :cwd "big, heavy, large, long, tall; important; adult")
    :suno    ("suno"    :pu :cwd "sun; light, brightness, glow, radiance, shine; light source")
    :supa    ("supa"    :pu :cwd "horizontal surface, thing to put or rest something on")
    :suwi    ("suwi"    :pu :cwd "sweet, fragrant; cute, innocent, adorable")
    :telo    ("telo"    :pu :cwd "water, liquid, fluid, wet substance; beverages")
    :tenpo   ("tenpo"   :pu :cwd "time, duration, moment, occasion, period, situation")
    :toki    ("toki"    :pu :cwd "communicate, say, speak, talk, use language, think; hello")
    :tomo    ("tomo"    :pu :cwd "indoor space; building, home, house, room")
    :tu      ("tu"      :pu :cwd "two | ALT separate, cut")
    :unpa    ("unpa"    :pu :cwd "have sexual relations with")
    :uta     ("uta"     :pu :cwd "mouth, lips, oral cavity, jaw")
    :utala   ("utala"   :pu :cwd "battle, challenge, compete against, struggle against")
    :walo    ("walo"    :pu :cwd "white, whitish; light-coloured, pale")
    :wan     ("wan"     :pu :cwd "unique, united; one")
    :waso    ("waso"    :pu :cwd "bird, flying creature, winged animal")
    :wawa    ("wawa"    :pu :cwd "strong, powerful; confident, sure; energetic, intense")
    :weka    ("weka"    :pu :cwd "absent, away, ignored")
    :wile    ("wile"    :pu :cwd "must, need, require, should, want, wish")

    ### ku suli
    # pseudo-particle
    :kin ("kin" :ku-suli :psp "{see a} | ALT indeed, too, also, as well")
    # content words
    :epiku           ("epiku"           :ku-suli :cwd "epic, cool, awesome, amazing")
    :jasima          ("jasima"          :ku-suli :cwd "reflect, resound, mirror, be on the opposite/polar end of")
    :kijetesantakalu ("kijetesantakalu" :ku-suli :cwd "any animal from the Procyonidae family, such as raccoons, coatis, kinkajous, olingos, ringtails and cacomistles | ALT any animal from the Musteloidea superfamily, including raccoons, weasels, otters, skunks, and red pandas")
    :kipisi          ("kipisi"          :ku-suli :cwd "split, cut, slice, sever; sharp")
    :kokosila        ("kokosila"        :ku-suli :cwd "to speak a non-Toki Pona language in an environment where Toki Pona is more appropriate")
    :ku              ("ku"              :ku-suli :cwd "interacting with the Toki Pona Dictionary by Sonja Lang")
    :lanpan          ("lanpan"          :ku-suli :cwd "take, seize, catch, receive, get")
    :leko            ("leko"            :ku-suli :cwd "stairs, square, block, corner, cube")
    :meso            ("meso"            :ku-suli :cwd "midpoint, medium, mediocre; neither one not the other, neither fully is nor isn't")
    :misikeke        ("misikeke"        :ku-suli :cwd "medicine, medical")
    :monsuta         ("monsuta"         :ku-suli :cwd "fear, dread; monster, predator; threat, danger")
    :n               ("n"               :ku-suli :cwd "(indicates thinking, pondering, recognition, agreement, or humming)")
    :namako          ("namako"          :ku-suli :cwd "{see sin} | ALT embellishment, spice; extra, additional")
    :oko             ("oko"             :ku-suli :cwd "{see lukin} | ALT eye, ocular, visual {cf. lukin}")
    :soko            ("soko"            :ku-suli :cwd "fungus, fungi")
    :tonsi           ("tonsi"           :ku-suli :cwd "non-binary, gender-non-conforming | ALT trans, non-cisgender")

    ### ku lili
    # pure particles
    :te ("te" :ku-lili :cwd "(particle introducing a quote)")
    :to ("to" :ku-lili :cwd "(particle closing a quote)")
    # content words
    :apeja        ("apeja"        :ku-lili :cwd "guilt, shame, shun, stigma, disgrace; to accuse, to single out, to expose, to dishonor, to embarrass")
    :isipin       ("isipin"       :ku-lili :cwd "to think, brainstorm, rationalize, conclude, ponder")
    :kamalawala   ("kamalawala"   :ku-lili :cwd "anarchy, uprising, revolt, rebellion")
    :kapesi       ("kapesi"       :ku-lili :cwd "brown, gray")
    :kiki         ("kiki"         :ku-lili :cwd "spiky, sharp, angle, point, triangular")
    :kulijo       ("kulijo"       :ku-lili :cwd "[interjection] casual expression of appreciation or acknowledgement; cool, fine, okay")
    :linluwi      ("linluwi"      :ku-lili :cwd "network, internet, connection; weave, braid, interlace")
    :majuna       ("majuna"       :ku-lili :cwd "old, aged, ancient")
    :misa         ("misa"         :ku-lili :cwd "Glires or Eulipotyphla; rat, mouse, squirrel, rabbit, rodent; {~ suli} capybara")
    :mulapisu     ("mulapisu"     :ku-lili :cwd "pizza")
    :oke          ("oke"          :ku-lili :cwd "(acknowledgement or acceptance)")
    :pake         ("pake"         :ku-lili :cwd "stop, cease, halt; to block the way, to interrupt; to prevent")
    :po           ("po"           :ku-lili :cwd "four")
    :powe         ("powe"         :ku-lili :cwd "unreal, false, untrue; pretend; deceive, trick")
    :san          ("san"          :ku-lili :cwd "three")
    :soto         ("soto"         :ku-lili :cwd "left, left side, port side")
    :su           ("su"           :ku-lili :cwd "interacting with a book from the illustrated story book series that began with The Wonderful Wizard of Oz, produced by Sonja Lang")
    :sutopatikuna ("sutopatikuna" :ku-lili :cwd "platypus")
    :taki         ("taki"         :ku-lili :cwd "sticky, magnetic; bond, attract, attach, clip")
    :teje         ("teje"         :ku-lili :cwd "right, right side, starboard")
    :unu          ("unu"          :ku-lili :cwd "purple")
    :usawi        ("usawi"        :ku-lili :cwd "magic, sorcery; enchant; magical, supernatural, occult, incomprehensible")
    :wa           ("wa"           :ku-lili :cwd "[interjection] indicating awe or amazement")
    :wasoweli     ("wasoweli"     :ku-lili :cwd "animal with qualities of both waso & soweli")
    :yupekosi     ("yupekosi"     :ku-lili :cwd "to behave like George Lucas and revise your old creative works and actually make them worse")

    ### no book
    :jami     ("jami"     :none :cwd "yummy; eliciting or stimulating a positive sensory experience")
    :jonke    ("jonke"    :none :cwd "goose, goose noise")
    :konwe    ("konwe"    :none :cwd "animacy, life, autonomy; autonomous being, living thing, organism; alive, animate, dynamic; to animate, to bring to life")
    :melome   ("melome"   :none :cwd "sapphic, lesbian, wlw")
    :mijomi   ("mijomi"   :none :cwd "gay, mlm")
    :nimisin  ("nimisin"  :none :cwd "any non-pu word; any new word; any joke word")
    :nja      ("nja"      :none :cwd "meow, feline sound")
    :ojuta    ("ojuta"    :none :cwd "toki pona adaptation of English meme \"ligma\"")
    :omekapo  ("omekapo"  :none :cwd "goodbye, farewell, see you later, eat a good fish")
    :owe      ("owe"      :none :cwd "Orwellian, totalitarian, of or relating to Big Brother (from 1984), antonym of kamalawala")
    :pika     ("pika"     :none :cwd "electric, electronic, conductive, mechanical, online; electricity, lightning, thunder, network")
    :puwa     ("puwa"     :none :cwd "fluffy, soft, squishy (something that can be compressed and will try to go back to its original shape)")
    :wekama   ("wekama"   :none :cwd "leave and come back, be temporarily absent with the expectation of returning")
    :wuwojiti ("wuwojiti" :none :cwd "to use one or more of the \"banned\" syllables wu, wo, ji, or ti; to break toki pona phonotactics")

    ### sandboxed
    # reserved
    :ju ("ju" :sandbox :cwd "(word reserved for future use by Sonja Lang)")
    :lu ("lu" :sandbox :cwd "(word reserved for future use by Sonja Lang)")
    :nu ("nu" :sandbox :cwd "(word reserved for future use by Sonja Lang)")
    :u  ("u"  :sandbox :cwd "(word reserved for future use by Sonja Lang)")
    # particles
    :ako ("ako" :sandbox :par "(general interjection, context-dependent)")
    :alu ("alu" :sandbox :par "(between the main sentence and the context phrase)")
    :je  ("je"  :sandbox :par "[interjection] (indicating excitement)")
    :ke  ("ke"  :sandbox :cwd "(acknowledgement or acceptance)")
    :ki  ("ki"  :sandbox :par "(relative clause marker)")
    :lo  ("lo"  :sandbox :par "(before the prepositional phrase)")
    :oki ("oki" :sandbox :cwd "(acknowledgement or acceptance)")
    :pa  ("pa"  :sandbox :cwd "[interjection] bruh; expression of disbelief, exasperation, or excitement")
    :ta  ("ta"  :sandbox :par "(pre-predicate marker)")
    :we  ("we"  :sandbox :par "(acts as a transition from one complete sentence to another)")
    # pronouns
    :i   ("i"   :sandbox :pro "he, she, it, they [alternate form of ona]")
    :iki ("iki" :sandbox :pro "he, she, it, they [alternate form of ona]")
    :ipi ("ipi" :sandbox :pro "he, she, it, they [alternate form of ona]")
    :wi  ("wi"  :sandbox :pro "we (excluding you, i.e. 1st person exclusive)")
    # numbers
    :jaku         ("jaku"         :sandbox :cwd "one hundred")
    :neja         ("neja"         :sandbox :cwd "four")
    :tuli         ("tuli"         :sandbox :cwd "three")
    # colours
    :nalanja      ("nalanja"      :sandbox :cwd "orange (colour)")
    # other
    :aku          ("aku"          :sandbox :cwd "shocking, surprising, unexpected; sour, bitter, acidic")
    :alente       ("alente"       :sandbox :cwd "the set of every possible human concept subtracted from the set of concepts already covered by established toki pona words weighted by their relative usage")
    :anta         ("anta"         :sandbox :cwd "oil, fat, grease; slippery; salty, savory")
    :awase        ("awase"        :sandbox :cwd "bump, knock, jolt")
    :eliki        ("eliki"        :sandbox :cwd "trial, adversity; bittersweet")
    :enko         ("enko"         :sandbox :cwd "(spatial equivalents of tenpo constructions) space, place, distance, size (length, width, height, depth, area, volume)")
    :ete          ("ete"          :sandbox :cwd "beyond, exceeding, outside of, more than")
    :ewe          ("ewe"          :sandbox :cwd "stone, gravel, rock, pebble, lava, magma")
    :inta         ("inta"         :sandbox :cwd "at least, definitely; still, yet, even")
    :iseki        ("iseki"        :sandbox :cwd "flower; adornment, accessory, garnish, spice; ornamental, aesthetic, beauty, flourish")
    :itomi        ("itomi"        :sandbox :cwd "Schadenfreude, indirect insult, disrespect, shade")
    :jans         ("jans"         :sandbox :cwd "a particular group of early members of the ma pona Discord")
    :jule         ("jule"         :sandbox :cwd "indeterminate, inconclusive, tentative; unpredictable, unstable, volatile; to waver; to vibrate, to tremble, to wobble, to shake")
    :jume         ("jume"         :sandbox :cwd "dream")
    :kalijopilale ("kalijopilale" :sandbox :cwd "member of the order Caryophyllales, including all cacti as well as carnations, beets, and many carnivorous plants")
    :kan          ("kan"          :sandbox :cwd "with, among, in the company of")
    :kana         ("kana"         :sandbox :cwd "dream; trance, hypnosis, hallucination; illusion, fantasy, imaginary; narrative, story, myth")
    :kapa         ("kapa"         :sandbox :cwd "extrusion, protrusion, hill, mountain, button")
    :kese         ("kese"         :sandbox :cwd "queer, LGBT+")
    :kisa         ("kisa"         :sandbox :cwd "cat")
    :konsi        ("konsi"        :sandbox :cwd "to notify, to let know")
    :kosan        ("kosan"        :sandbox :cwd "guard, protect, defend, shield, brace, fortify from outside")
    :kuntu        ("kuntu"        :sandbox :cwd "laughter, chuckle, laugh, comedy, humor")
    :kutopoma     ("kutopoma"     :sandbox :cwd "the Korean group chat \"kulupu pi toki pona pi ma Anku\"")
    :lijokuku     ("lijokuku"     :sandbox :cwd "to agree (with laughter)")
    :likujo       ("likujo"       :sandbox :cwd "collection, assortment, menagerie, arrangement, handful, harvest; seven")
    :loka         ("loka"         :sandbox :cwd "limb")
    :molusa       ("molusa"       :sandbox :cwd "squishy animal, e.g., snail, slug, sponge")
    :natu         ("natu"         :sandbox :cwd "relationship, correlation, commonality; cross, knot, junction, intersection; to overlap, to fold; to overstep, to exceed to a point")
    :nele         ("nele"         :sandbox :cwd "transparent material/object, lack of privacy; clear, transparent, unobstructed; to make clear, to make transparent, to remove obstructions")
    :nowi         ("nowi"         :sandbox :cwd "connected, related, joined; complementary, mutual; exchange")
    :okepuma      ("okepuma"      :sandbox :cwd "boomer, Baby Boomer, inconsiderate elder; [interjection/insult]")
    :omekalike    ("omekalike"    :sandbox :cwd "(proper name) a song by jan Usawi")
    :omen         ("omen"         :sandbox :cwd "sarcasm, irony")
    :oni          ("oni"          :sandbox :cwd "dream, daydream, imaginative play, vision, mystical state; to entrance")
    :pasila       ("pasila"       :sandbox :cwd "good, easy; simple, relaxed, peaceful, uncomplicated")
    :pata         ("pata"         :sandbox :cwd "brother, sister, sibling")
    :peta         ("peta"         :sandbox :cwd "green, greenish; verdant, alive; ecofriendly")
    :peto         ("peto"         :sandbox :cwd "cry, tears; sad, sadness")
    :pipo         ("pipo"         :sandbox :cwd "annoy, annoyance, bothersome, boring")
    :polinpin     ("polinpin"     :sandbox :cwd "bowling pin")
    :pomotolo     ("pomotolo"     :sandbox :cwd "effective, useful, give good results")
    :poni         ("poni"         :sandbox :cwd "pony")
    :samu         ("samu"         :sandbox :cwd "wanting to create new words")
    :sikomo       ("sikomo"       :sandbox :cwd "on a higher tier/plane, enlighten(ed), epic; to an exceedingly great extent")
    :sipi         ("sipi"         :sandbox :cwd "ego, self, own")
    :sole         ("sole"         :sandbox :cwd "pattern, constant, unchanged, unaltered, unaffected; instinct, habit, to use to, to tend to")
    :tokana       ("tokana"       :sandbox :cwd "focus, attention, concentrate, resolution, fineness; focus on")
    :umesu        ("umesu"        :sandbox :cwd "amaze people by being on the top of the leaderboard of a toki pona game")
    :waleja       ("waleja"       :sandbox :cwd "context, topic, salience, pertinent, topical, pertain to, be relevant")
    :wawajete     ("wawajete"     :sandbox :cwd "something that appears to break the rules but doesn't; faux edginess, provocation")
    :we           ("we"           :sandbox :cwd "guy, pal, friend, buddy")
    :yutu         ("yutu"         :sandbox :cwd "the star emoji used for the starboard #pona-kulupu in the ma pona pi toki pona Discord server")
    # alternate forms
    :aka    ("aka"    :sandbox :cwd "cross-like shape, intersection, overlap [alternative form of natu]")
    :eki    ("eki"    :sandbox :cwd "cross-like shape, intersection, overlap [alternative form of natu]")
    :jalan  ("jalan"  :sandbox :cwd "foot [alternate form of noka]")
    :kepen  ("kepen"  :sandbox :cwd "(shortened variant of kepeken)")
    :kulu   ("kulu"   :sandbox :cwd "(shortened variant of kulupu); six (particularly in senary base)")
    :lokon  ("lokon"  :sandbox :cwd "{a compromise between lukin & oko}")
    :slape  ("slape"  :sandbox :cwd "[humorous synonym of lape]")
    :ten    ("ten"    :sandbox :cwd "(shortened variant of tenpo)")
    # typos
    :pakola ("pakola" :sandbox :cwd "[misspelling of pakala]")
    :suke   ("suke"   :sandbox :cwd "[typo of sike]")
    :toma   ("toma"   :sandbox :cwd "[typo of tomo]")
})

# unused
(defn entry-filter [sources types body key]
  (def entry (dictionary key))
  (and
    (or (nil? sources) (has-value? sources (get entry 1)))
    (or (nil? types) (has-value? types (get entry 2)))
    (or (nil? body) (string/find body (get entry 0)) (string/find body (get entry 3)))))

# unused
(defn dictionary-filter [source-text type-text body-text]
  (let [source-keys (-?> source-text entry-sources-find)
        type-keys (-?> type-text entry-types-find)]
    (filter (partial entry-filter source-keys type-keys body-text) (keys dictionary))))

(defn entry-rank [sources types body key]
  (let [entry (dictionary key)
        sources-match? (or (nil? sources) (has-value? sources (get entry 1)))
        types-match? (or (nil? types) (has-value? types (get entry 2)))
        word (get entry 0)
        body-match? (or (nil? body) (string/find body word))
        word-rank (if body-match? (math/ceil (* 10 (/ (length body) (length word)))))
        desc-match (or (nil? body) (string/find-all body (get entry 3)))
        desc-rank (-?> desc-match length)
        body-rank (+ (or word-rank 0) (or desc-rank 0))
        rank (and sources-match? types-match? body-rank)]
    (if (and (truthy? rank) (> rank 0)) (tuple key rank))))

(defn dictionary-rank [source-text type-text body-text]
  (let [source-keys (or (-?> source-text entry-sources-find) entry-sources-default)
        type-keys (-?> type-text entry-types-find)
        ranks (keep (partial entry-rank source-keys type-keys body-text) (keys dictionary))]
    (sort-by (fn [[key rank]] rank) ranks)))

(defn entry-pp [key &opt rank brief]
  (let [entry (dictionary key)
        rank-fmt (fn [r] (string "(" rank ") "))
        rank-str (-?> rank rank-fmt)
        w-name (get entry 0)
        w-source (if brief (get entry 1) (get entry-sources (get entry 1)))
        w-type (if brief (get entry 2) (get entry-types (get entry 2)))
        w-desc (get entry 3)]
    (print rank-str w-name " - " w-type " from " w-source " - " (get entry 3))))

### parsing

# creates a prettier error, if `patt` matches
(defn- %error [msg patt]
  ~(error (% (* (constant ,msg) (<- ,patt) (constant " at char #") (position)))))

# creates a splicable pattern for `patt ~ (inter-patt ~ patt)*`
(defn- some-inter [patt inter-patt]
  ~(,patt (any (* ,inter-patt ,patt))))

(def grammar 
  ~{:main :sentence

    # sentences
    :sentence (* :f_subject :ws :f_predicate (? :f_object))
    :interjection (*)

    # fragments
    :f_subject (+ (* ,;(some-inter :phrase '(* :ws :p_en :ws)) :ws :p_li) "mi" "sina")
    :f_predicate (* (? (* :ncw_preverb :ws)) :phrase)
    :f_object (* :p_e :ws :phrase)

    # phrases
    :phrase (group (* :cw_head (any (* :ws :cw_mod)) (any (* :ws :phrase_pi))))
    :phrase_pi (* :p_pi :ws :cw_head (* :ws :cw_mod))

    # content words
    :cw_mod (* (! :p_pure) (+ :cw_head :u_word) :we)
    :cw_head (* (! :p_pure) (+ :cw_ncw :cw_pu :cw_ku_suli :cw_ku_lili :l_word) :we)
    # missing: mi sina ona ni lon tawa tan sama kepeken li o la anu e pi en nanpa ala taso a seme
    :cw_pu (% (* (<- (+ "akesi" "ala" "alasa" "ale" "ali" "anpa" "ante" "anu" "awen" "esun" "ijo" "ike" "ilo" "insa" "jaki" "jan" "jelo" "jo" "kala" "kalama" "kama" "kasi" "ken" "kili" "kiwen" "ko" "kon" "kule" "kulupu" "kute" "la" "lape" "laso" "lawa" "len" "lete" "li" "lili" "linja" "lipu" "loje" "luka" "lukin" "lupa" "ma" "mama" "mani" "meli" "mije" "moku" "moli" "monsi" "mu" "mun" "musi" "mute" "nanpa" "nasa" "nasin" "nena" "ni" "nimi" "noka" "olin" "ona" "open" "pakala" "pali" "palisa" "pan" "pana" "pi" "pilin" "pimeja" "pini" "pipi" "poka" "poki" "pona" "pu" "seli" "selo" "sewi" "sijelo" "sike" "sin" "sinpin" "sitelen" "sona" "soweli" "suli" "suno" "supa" "suwi" "taso" "telo" "tenpo" "toki" "tomo" "tu" "unpa" "uta" "utala" "walo" "wan" "waso" "wawa" "weka" "wile")) :we (constant "(p)")))
    # missing: kin
    :cw_ku_suli (% (* (<- (+ "epiku" "jasima" "kijetesantakalu" "kipisi" "kokosila" "ku" "lanpan" "leko" "meso" "misikeke" "monsuta" "n" "namako" "oko" "soko" "tonsi")) :we (constant "(ks)")))
    # missing: te to
    :cw_ku_lili (% (* (<- (+ "apeja" "isipin" "kamalawala" "kapesi" "kiki" "kulijo" "linluwi" "majuna" "misa" "mulapisu" "oke" "pake" "po" "powe" "san" "soto" "su" "sutopatikuna" "taki" "te" "teje" "to" "unu" "usawi" "wa" "wasoweli" "yupekosi")) :we (constant "(kl)")))
    :cw_other (% (* (<- (+ "jami" "jonke" "konwe" "melome" "mijomi" "nimisin" "nja" "ojuta" "omekapo" "owe" "pike" "puwa" "wekama" "wuwojiti")) :we (constant "(oth)")))
    :cw_ncw (* (+ :ncw_pronoun :ncw_seme) :we)
    :cw_p (* (+ :p_pseudo :p_emote) :we)

    # non-content words
    :ncw_pronoun (<- (* (+ "mi" "sina" "ona" "ni") :we))
    :ncw_preposition (<- (* (+ "lon" "tawa" "tan" "sama" "kepeken") :we))
    :ncw_preverb (<- (* (+ "wile" "sona" "awen" "kama" "ken" "lukin") :we))
    :ncw_seme (<- (* "seme" :we))

    # particle words
    :p_pure (* (+ :p_li :p_e :p_pi :p_en :p_la :p_anu) :we)
    :p_li (<- (* (+ "li" "o") :we))
    :p_la (<- (* "la" :we))
    :p_anu (<- (* "anu" :we))
    :p_e (<- (* "e" :we))
    :p_pi (<- (* "pi" :we))
    :p_en (<- (* "en" :we))
    :p_pseudo (<- (* (+ "nanpa" "kin" "ala" "taso") :we))
    :p_emote (<- (* "a" :we))
    :p_te (<- (* "te" :we))
    :p_to (<- (* "to" :we))

    # upper-case words (loan words)
    :u_word (<- (* (+ (* :u_vowel_part (any :l_syllable)) (* :u_syllable (any :l_syllable))) :we))
    :u_syllable (* :u_consonant :l_vowel_part)
    :u_vowel_part (* :u_vowel (? :l_ending_n))
    :u_vowel (+ "A" "E" "I" "O" "U")
    :u_consonant (+ :u_j "K" "L" "M" :u_n "P" "S" :u_t :u_w)
    :u_n (* "N" ,(%error "unexpected " '(+ "n" "m")))
    :u_w (* "W" ,(%error "unexpected " '(+ "u" "o")))
    :u_j (* "J" ,(%error "unexpected " "i"))
    :u_t (* "T" ,(%error "unexpected " "i"))

    # lower-case words (non-standard words)
    :l_word (<- (* (+ (* :l_vowel_part (any :l_syllable)) (some :l_syllable) :l_word_exceptions) :we))
    :l_word_exceptions (* "n")
    :l_syllable (* :l_consonant :l_vowel_part)
    :l_vowel_part (* :l_vowel (? :l_ending_n))
    :l_ending_n (* "n" (! :l_vowel))
    :l_vowel (+ "a" "e" "i" "o" "u")
    :l_consonant (+ :l_j "k" "l" "m" :l_n "p" "s" :l_t :l_w)
    :l_n (* "n" ,(%error "unexpected " '(+ "n" "m")))
    :l_w (* "w" ,(%error "unexpected " '(+ "u" "o")))
    :l_j (* "j" ,(%error "unexpected " "i"))
    :l_t (* "t" ,(%error "unexpected " "i"))

    # whitespace
    :ws (some :s)
    :we (look 0 (+ :s "." -1)) # word ending

    # miscellaneous rules
    :null "\0" # won't match
})

(def grammar-cmp (peg/compile grammar))

(defn grammar-check [text]
  (pp text)
  (pp (peg/match grammar-cmp text)))

### main functions

(defn main-parse [cmd-args]
  (each arg (array/slice cmd-args 1)
    (grammar-check arg)))

(defn main-lookup [cmd-args]
  (def res (argparse/argparse
             "Toki Pona dictionary lookup"
             "source" {:kind :option
                       :short "s"
                       :help "filters by word source"}
             "type" {:kind :option
                     :short "t"
                     :help "filters by word category"}
             "brief" {:kind :flag
                     :short "b"
                     :help "shortens output"}
             :default {:kind :accumulate}
             :args cmd-args))
  (when res
    (def text (string/join (res :default)))
    (def ranked-words (dictionary-rank (res "source") (res "type") text))
    (each [word rank] ranked-words (entry-pp word rank (res "brief")))))

(defn main-help [cmd-args]
  (print "Help!"))

(defn main-error [cmd & cmd-args]
  (print "Unknown command " cmd)
  (main-help cmd-args))

(defn main [& args]
  (if-let [[exec cmd & args-rest] args]
    (do
      (def cmd-args (tuple (string exec " " cmd) ;args-rest))
      (case cmd
        "lookup" (main-lookup cmd-args)
        "parse" (main-parse cmd-args)
        "help" (main-help cmd-args)
        (main-error args)))
    (main-error args)))



