#Requires AutoHotkey v2.0

#Include ..\Lib\Paste.v2.ahk
#Include lib\ris-common.v2.ahk

; Special

::vcug::
{
    MyForm := "
    (
Voiding cystourethrography was performed under fluoroscopy by using contrast medium dripping into the urinary bladder through Foley catheter with supine position:

1. No evidence of bil. vesico-ureteral reflux during straining, voiding and post-voiding.
2. Normal contour of the urinary bladder without filling defect noted.
3. No definite structural anomaly or fistula identified in this study.

IMPRESSION:
No vesicoureteral reflux or fistula.
    )"
    Paste(MyForm)
}

::vur1::Reflux limited to the ureter. Grade 1 vesicoureteric reflux is considered.
::vur2::Reflux up to the renal pelvis. Grade 2 vesicoureteric reflux is considered.
::vur3::Reflux with mild dilatation of the ureter and pelvicalyceal system. Grade 3 vesicoureteric reflux is considered.
::vur4::Reflux with moderately dilated, tortuous ureter and blunting of fornices but preserved papillary impressions. Grade 4 vesicoureteric reflux is considered.
::vur5::Reflux with severely dilated, tortuous ureter, dilatation of the pelvicalyceal system, and loss of fornices and papillary impressions. Grade 5 vesicoureteric reflux is considered.

::hsg::
{
    MyForm := "
    (
Hysterosalpingography was performed under fluoroscopy by using contrast medium injected into patient's uterus:

- Uterine cavity: Normal size, triangular shape, and smooth mucosal contour. No evidence of filling defect, synechiae, or congenital uterine anomaly.
- Fallopian tubes: Both fallopian tubes are well visualized, normal in caliber throughout their course, with no dilatation or obstruction.
- Peritoneal spill: Prompt, free, and symmetrical peritoneal spillage of contrast is demonstrated bilaterally without loculation.
    )"
    Paste(MyForm)
    SleepThenTab()
    MyForm := "
    (
1. Normal contour and capacity of the uterine cavity.
2. Bilateral patent fallopian tubes with free peritoneal spill.
    )"
    Paste(MyForm)
}

::hsgnfs::opacification to the fimbrial level, however, no free spillage is noted.
::hsggb::small movable filling defects in the uterine cavity, in favor of gas bubbles.
::hsga::mild irregularity of the uterine contour with small projections of contrast material, adenomyosis may be suspected.
::hsgok::Bilateral fallopian tubes are patent.

::t-tube::
{
    MyForm := "
    (
T-tube cholangiography was performed via PTGBD/PTCD:

Some small filling defects in the gallbladder, c/w gallbladder stones.
No definite filling defect in the common bile duct and intrahepatic ducts.
Normal passage of contrast medium through the ampulla of Vater into the duodenum.
    )"
    Paste(MyForm)
}

::agp::
{
    MyForm := "
    (
Antegrade pyelography was performed under fluoroscopy by using contrast medium through right/left/bilateral PCN catheters with prone/supine position:

    )"
    Paste(MyForm)
}

::vpg::
{
    MyForm := "
    (
Pharyngography
-Functional components of Swallowing
  -oropharyngeal phase
  -laryngeal dynamic
  -epiglottic tilt
  -cricopharyngeal opening
  -


Functional abnormality:

Leakage: Nil. Yes, due to: weakness, atrophy or resection of tongue, poor dentures, paralysis of soft palate.

Nasal regurgitation: Nil.  Yes, due to: weakness of soft palate, or superior constrictor

Barium aspiration: Nil., Yes, due to : impairment or absence of (epiglottic tilting, elevation of larynx, closure of larynx).

Retention: Nil.

-Swallowing stages analysis:
  -Control of junction of mouth and pharynx (stage 1): normal, (tongue deficiency, palatal deficiency with compensation; decompensation with leakage).
  -Closure of the palatopharyngeal isthmus (stage 2): normal, (deficiency of the pharyngeal palate with comensation, decompensation with nasopharyngeal regurgitation).
  -Compression of the bolus (stage 3): normal, (deficiency of the tongus, constrictor muscle, with barium retention in valleculae or piriform sinuses after swallowing).
  -Closure of the larynx (stage 4): . normal, laryngeal penetration.
       -Opening of the pharyngoesophageal segment (stage 5): : normal, overflow aspiration, retained bolus.

-Aspiration: Nil. Yes, during stage ///

-Structural anomaly: Nil. Yes, diverticulum (lateral pharyngeal pouch, diverticulum, laryngocele, Zenker's diverticulum, brachial cleft fistula, sinus, lymphoid hyperplasia,
    )"
    Paste(MyForm)
}

::vfss::
{
    MyForm := "
    (
Videofluoroscopic swallowing study (VFSS) shows:
- Status post Tracheostomy

Contrast:
 - Barium with thin, thick and paste consistency.

Oral phase:
 - Oral drooling: no
 - Bolus holding: normal
 - Oral stasis: no
 - Oral mucosal coating: normal
 - Premature oral leakage: no
 - Piecemeal swallowing: no
 - Tongue-palate contact: normal

Pharyngeal phase:
 - Swallowing trigger: general normal
 - Vallecular stasis: mild amount
 - Pyriform sinus stasis: no
 - Velar elevation: normal and complete
 - Pharyngeal contraction: normal
 - Hyoid bone elevation: normal and complete
 - Epiglottic movement: normal
 - Laryngeal penetration: no
 - Aspiration: no
 - Pharyngeal mucosal coating: normal
 - Pharyngo-oral reflux: no
 - Pharyngo-nasal reflux: no
 - Symmetry of bolus passage from the pharynx to esophagus: symmetric
 - Increased retropharyngeal soft tissue: no
    )"
    Paste(MyForm)
}

; UGI & Small Intestine

::ugi::
{
    MyForm := "
(
Double-contrast upper GI study from esophagus to proximal duodenum was performed smoothly and showed:

- Normal elasticity and distensibility of stomach.
- No significant filling defect or mass lesion noted in the stomach.
- The mucosal folds of the esophagus and stomach show no significant abnormality.
- Good distension of the duodenal bulb without definite mass effect.

IMPRESSION:
No abnormal findings noted in this UGI study.
)"
    Paste(MyForm)
}

::ugipcu::
{
    MyForm := "
(
Double-contrast upper GI study from esophagus to proximal duodenum was performed smoothly.
Esophagography was performed under fluoroscopy and showed:

FINDINGS:
- No significant filling defect or mass lesion noted in the stomach.
- The mucosal folds of the esophagus and stomach show no significant abnormality.
- Good distension of the duodenal bulb without definite mass effect.
- Smooth passage of the barium without definite mass effect or abnormal mucosal pattern of the esophagus.
- Normal elasticity and distensibility of the stomach.

IMPRESSION:
No abnormal findings noted in this UGI study.
)"
    Paste(MyForm)
}

::ugieso::
{
    MyForm := "
(
Double-contrast upper GI study from esophagus to proximal duodenum was performed smoothly and showed:
Esophagography was performed under fluoroscopy:

FINDINGS:
- Normal elasticity and distensibility of the stomach.
- No significant filling defect or mass lesion noted in the stomach.
- The mucosal folds of the esophagus and stomach show no significant abnormality.
- Good distension of the duodenal bulb without definite mass effect.
- Smooth passage of the barium without definite mass effect or abnormal mucosal pattern of the esophagus.

IMPRESSION:
No abnormal findings noted in this UGI study.
)"
    Paste(MyForm)
}

::smint::
{
    MyForm := "
(
SMALL INTESTINE:

CLINICAL HISTORY:
[Indication, e.g., Suspected bowel obstruction, abdominal pain, or status post-procedure evaluation]

COMPARISON:
[None / Prior exam date and modality]

TECHNIQUE:
Serial abdominal radiographs were obtained following oral administration of water-soluble contrast medium (e.g., Gastrografin / Meglumine diatrizoate).

FINDINGS:
1. Contrast Transit: Smooth and unimpeded transit of contrast material through the stomach, duodenum, and jejunum/ileum. Contrast reaches the cecum and proximal colon at 60 minutes post-ingestion.
2. Bowel Loops: The small bowel loops show normal caliber, mucosal fold patterns, and wall thickness throughout. No significant luminal narrowing, stricture, or dilatation is identified.
3. Mass / Lesion: No filling defect, intraluminal mass, or extrinsic compression is seen along the small bowel loops.
4. Extravasation: No evidence of contrast extravasation, fistulae, or sinus tract formation.

IMPRESSION:
1. Unremarkable small bowel follow-through study with water-soluble contrast.
2. Normal transit time, with contrast reaching the colon at 60 minutes.
3. No small bowel obstruction, stricture, mass, or extravasation identified.
)"
    Paste(MyForm)
}

::ugisi::
{
    MyForm := "
(
Double-contrast upper GI study from esophagus to proximal duodenum, and single-contrast small intestine examination with compressed spot views were performed smoothly and showed:

- Normal elasticity and distensibility of the stomach.
- No significant filling defect or mass lesion noted in the stomach.
- The mucosal folds of the esophagus and stomach show no significant abnormality.
- Good distension of the duodenal bulb without definite mass effect.
- Normal appearance of mucosa and peristalsis of small intestine without definite mass lesion.

IMPRESSION: No abnormal findings noted in this UGI and small intestine study.
)"
    Paste(MyForm)
}