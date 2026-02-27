# Lekturnik — Go-to-Market Plan

## Launch Timing

| Phase | Timing | Audience | Goal |
|-------|--------|----------|------|
| Soft Launch / Beta | Late Feb - early Mar 2026 | 50-100 beta testers | Validate, fix bugs, testimonials |
| Public Launch | Mid-March 2026 | Matura students (kl. 3-4) | Capture probna matura panic (Mar 4-6) |
| Matura Peak Push | April - May 5, 2026 | All matura + osmoklasisty | Max marketing before May 4 (matura) and May 11 (egzamin) |
| Summer Content Build | Jun - Aug 2026 | Internal | Expand to 30+ lektury, v1.1 features |
| Back-to-School | Late Aug 2026 | All students kl. 7 - liceum 3 | Full feature set, new school year |

## Distribution Channels (Ranked by ROI)

### Tier 0: Web PWA as Install Funnel (ZERO COST — highest leverage)

**The web app IS the top of the funnel.** Every marketing channel links to lekturnik.pl (not app stores). Why:

- **Zero friction:** Student sees TikTok -> taps link -> using app in 3 seconds. No store download wait.
- **Hooks before asking for install:** Student tries free quiz, browses lektury, sees value. THEN gets prompted to install.
- **SEO captures intent traffic:** "streszczenie Lalka" searches land on lekturnik.pl/lalka -> student uses app -> install CTA

**Web-to-install conversion points:**
1. **Smart banner** (sticky bottom on mobile browsers): "Lepsze doswiadczenie w aplikacji. Pobierz za darmo."
2. **Post-quiz prompt:** After completing 3rd free quiz: "Chcesz wiecej? W aplikacji masz nielimitowane quizy AI."
3. **Paywall redirect:** When hitting premium gate: "Premium dostepne w aplikacji" + store badges
4. **Post-session nudge:** After good quiz score: "Pobierz aplikacje zeby sledzic postepy i nie stracic serii"
5. **PWA "Add to Home Screen":** For users who don't want to visit the store — lightweight install

**Metrics to track:**
- Web MAU -> app install conversion rate (target: 15-25%)
- Time-on-web before install (optimize for "hook within 5 minutes")
- Which CTA drives most installs (A/B test banner vs post-quiz vs paywall)

### Tier 1: Organic TikTok + Instagram Reels (ZERO COST)

Primary channel. Polish students 14-19 spend ~90 min/day on TikTok.

**All links go to lekturnik.pl** (not app stores). Web gives instant gratification; store links add friction.

**Content calendar (3-5 posts/week):**
- Monday: "Bohater w jednym zdaniu" — character roasts
- Wednesday: "Streszczenie w 60 sekund" — fast lektura summaries
- Friday: "Czy rozpoznasz lekture?" — quiz-format engagement
- Bonus: "Matura tip" — exam tips, app demos
- Bonus: "AI vs student" — AI quiz catching non-readers

**Funnel:** TikTok bio link -> lekturnik.pl -> use free tier -> install app CTA -> Premium

**Target:** 10K TikTok followers in 3 months. 2-3 viral videos (50K+ views) can drive 500-1,000 web visitors -> 100-250 app installs.

### Tier 2: App Store Optimization (ZERO COST)

**App title:** "Lekturnik — Lektury AI | Matura Polski"
**Subtitle:** "Streszczenia, quizy AI, cytaty, motywy"

**Primary keywords:** lektury, streszczenie lektur, matura polski, lektury szkolne, sprawdzian z lektury, opracowanie lektur, egzamin osmoklasisty polski

Localized screenshots with Polish content, matura branding, AI quiz UI. Request reviews after positive quiz sessions.

### Tier 3: SEO / Content Marketing (FREE — web app IS the content)

The web app itself serves as SEO content. Flutter HTML renderer is indexable to some extent, but for maximum SEO:

- **Static landing pages per lektura:** lekturnik.pl/lalka, lekturnik.pl/dziady (can be server-rendered or static HTML with CTA to open the Flutter web app)
- **Target queries:** "streszczenie Lalka" (~10K-30K monthly), "bohaterowie Wesele", "motywy Pan Tadeusz"
- **Blog content:** "10 najwazniejszych cytatow z Lalki na mature", "Motyw buntu w literaturze" — each links into the web app
- **SEO advantage over Bryk.pl:** Modern, fast, mobile-friendly, no intrusive ads. Google rewards UX.

### Tier 4: YouTube/Influencer (200-500 PLN/mo after PMF)

Channels: Wiedza z Wami (~200K subs), Lekturek (~160K), Matura na Maksa, Babka od Polskiego, Polina

Approach: free lifetime Premium + discount code. Links go to lekturnik.pl (try it now) + app stores (get full version).

TikTok nano-influencers (5K-50K): 40-250 PLN per video.

### Tier 5: Community & Word of Mouth

Referral: "Zapros znajomego -> oboje dostajecie 7 dni Premium"

Sharing lekturnik.pl links is frictionless — recipient can use the app immediately without downloading anything. This lowers the sharing barrier vs "download this app."

Channels: Reddit, Facebook groups ("Matura 2026"), Wykop.pl, Discord, student forums. Share direct web links to specific lektury.

## Pricing Structure

| Tier | Price | Includes |
|------|-------|----------|
| Free | 0 PLN | Basic summaries (truncated), 3 characters/lektura, 3 AI quizzes/day, ads |
| Premium Monthly | 9.99 PLN/mo | Full content, unlimited AI, no ads, SRS, matura stats, offline |
| Premium Annual | 79.99 PLN/yr (6.67/mo) | Same, 33% savings |
| Matura Season Pass | 39.99 PLN (Mar-Jun) | 4-month access |

- 7-day free trial for all new Premium users
- Consider promo: 4.99 PLN/month for first 1,000 subscribers
- No student verification (too much friction)

## ASO Checklist

- [ ] Title includes "Lektury AI" and "Matura Polski"
- [ ] Subtitle includes key features
- [ ] Screenshots show Polish content on key screens
- [ ] Description mentions specific popular lektury by name
- [ ] Keywords target both generic ("lektury") and long-tail ("streszczenie Lalka")
- [ ] In-app review prompt after positive quiz scores
