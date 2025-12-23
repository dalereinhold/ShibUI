# 🍂 Shibui Color Palette: Muted & Light

| Color Name	| Hex Code	| Description	|
|:--------------|:-----------|:----------------|
| **Kaki (柿色)**	| ` #E6A57E`	| Soft persimmon orange—warm, understated, and inviting	|
| **Byakuroku (白緑)**	| ` #B7D3B2`	| Pale green with a hint of mint—fresh but subdued	|
| **Usuzumi (薄墨)**	| ` #D4D4D4`	| Light grey with a whisper of cool tone—clean and neutral	|
| **Tōryoku (淡緑)**	| ` #C9D8C5`	| Muted sage—adds depth without heaviness	|
| **Shirocha (白茶)**	| ` #EDE6DB`	| Off-white with a warm beige tint—great for background balance	|

# Analysis Summary: ZO_PlayerAttribute Control Structure
Health Bar (ZO_PlayerAttributeHealth)
StatusBars:

BarLeft - inherits ZO_PlayerAttributeStatusBar, barAlignment="REVERSE"
Contains: Gloss child (also REVERSE)
BarRight - inherits ZO_PlayerAttributeStatusBar, normal alignment
Contains: Gloss child
Decorative Elements:

BgContainer with children: BgLeft (arrow), BgRight (arrow), BgCenter
FrameLeft (arrow), FrameRight (arrow), FrameCenter
Warner control with Left (arrow), Right (arrow), Center
ResourceNumbers label
Magicka Bar (ZO_PlayerAttributeMagicka)
StatusBars:

Bar - inherits ZO_PlayerAttributeStatusBar, barAlignment="REVERSE"
Contains: Gloss child (also REVERSE)
Decorative Elements:

BgContainer with children: BgLeft (arrow), BgRight (no arrow), BgCenter
FrameLeft (arrow), FrameRight (no arrow), FrameCenter
Warner control with Left (arrow), Right (no arrow), Center
ResourceNumbers label
Stamina Bar (ZO_PlayerAttributeStamina)
StatusBars:

Bar - inherits ZO_PlayerAttributeStatusBar, normal alignment (no REVERSE)
Contains: Gloss child
Decorative Elements:

BgContainer with children: BgLeft (no arrow), BgRight (arrow), BgCenter
FrameLeft (no arrow), FrameRight (arrow), FrameCenter
Warner control with Left (no arrow), Right (arrow), Center
ResourceNumbers label
Key Differences:
Health has TWO StatusBars (BarLeft + BarRight) that meet in center for bidirectional depletion
Magicka has ONE StatusBar with REVERSE alignment (depletes right-to-left)
Stamina has ONE StatusBar with normal alignment (depletes left-to-right)
Arrow decorations are on different sides: Magicka (left), Health (both), Stamina (right)
All StatusBars inherit from ZO_PlayerAttributeStatusBar template which likely defines the bar texture with arrow shapes built-in