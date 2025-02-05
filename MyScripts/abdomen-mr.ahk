; Abdomen MR Forms

;; Hotstrings
::amrhcc::A _ cm nodule in the S of liver, shows mild T2 hyperintensity, T1 hypointensity, signal drop on out-of-phase images, mild restricted diffusion, arterial phase hyperenhancement, washout and enhancing capsule in portal venous phase, suggestive of hepatocellular carcinoma.
::amrfnh::A _ cm mass lesion at the S of liver, with arterial enhancement, mild persistent enhancement into delayed phase, fading toward background liver intensity on the delayed hepatobiliary phase, suggest focal nodular hyperplasia.
::amrhh::A _ cm nodule in the S of liver, shows hyperintensity on T2WI, and the dynamic study shows discontinuous, nodular, peripheral enhancement, with progressive peripheral enhancement with centripetal fill in. Hepatic hemangioma is considered.
::amraps::A small wedge-shaped subcapsular arterial enhancement at S_ of liver with isointense in the portal venous and delay phases, in favor of AP shunting.
::amrfl::Marked diffuse signal drop of the liver parenchyma in the opposed-phase images, suggestive of hepatic steatosis.
::amrmfl::Mild diffuse signal drop of the liver parenchyma in the opposed-phase images, suggestive of mild hepatic steatosis.
::amrgbsg::T1 hyperintensity material in the gallbladder with layering, in favor of GB sludge.
::dwil::* Due to susceptibility artifact from the rectal fecal material, the evaluation in DWI/ADC may be limited.
::amrbph::Enlarged transition zone with heterogeneous nodular signal intensity and an intact low signal pseudocapsule in the periphery, suggestive of benign prostatic hyperplasia.
::amrsptrus::Focal T1 hyperintensities at bilateral lobes, probably post-biopsy changes.
::amrbok::No DWI (b=400) hyperintense bone lesion detected.
::amrhc::The liver shows diffuse T2 hypointensity, lower signal intensity on in-phase sequence, and higher signal intensity on out-of-phase sequence. Hemochromatosis may be suspected.
::panok::No space-occupying pancreatic lesion. No pancreatic duct dilatation.
::panok1::No definite pancreatic tumor as expected.
::pz::peripheral zone
::jz::junctional zone

;; General
::amrpan::
  MyForm =
(
MRI of the Pancreas and MRCP.

SCANNING PROTOCOL:
- Axial T2, T2+FS, DWI, ADC, T1 IP/OOP, T1+FS, dynamic T1+C+FS A/V/D phases
- Coronal T2, T1+C+FS
- Sagittal T2, T1+C+FS
- MRCP, Coronal and MIP reconstruction

COMPARISON: no

FINDINGS:

)
  Paste(MyForm)
Return

::amrmrcp::
  MyForm =
(
MRCP without IV Gd enhancement

SCANNING PROTOCOL:
- Axi T2, T2+FS, DWI, ADC maps, T1 IP/OOP, LAVA T1.
- Cor, Sag SSFSE T2
- MRCP, Cor, MIP reconstruction

COMPARISON: no

FINDINGS:
Liver and Biliary tree:
- Cirrhotic changes: nil, portosystemic collaterals (-)

Pancreas: Unremarkable

Adrenals: Unremarkable
Spleen: Unremarkable
Kidneys and ureters: Unremarkable

No obvious upper abdominal retroperitoneal lymphadenopathy identified.
)
  Paste(MyForm)
Return

;; MRI liver, MRCP
::amrliv::
  MyForm =
(
MRI of the Liver with Gd enhancement, and MRCP.

SCANNING PROTOCOL:
- Axi T2, T2+FS, DWI, ADC maps, T1 IP/OOP.
- Cor, Sag LAVA water, SSFSE T2
- Axi T1+FS: dynamic A/PV/delayed phases.
- Cor, Sag T1+C+FS
- MRCP, Cor, MIP reconstruction

COMPARISON: no

FINDINGS:
* A case of HCC, s/p OP, s/p RFA.
Liver:
- S/p right hepatectomy. Hypertrophic changes of the lateral segment.
- Cirrhotic changes: nil, portosystemic collaterals (-)
- A 8-mm nodule at the S2 (Se/Im: 11,12,13/26) shows slightly enhancement in the arterial but prominent washout in portal venous, equilibrium, and hepatobiliary phases. Recurrence HCC is suspected.
- Two mass lesions, about 4.8 and 4.2 cm, at the S4, show T1 slightly hypointensity, T2 slightly hyperintensity, restricted diffusion. The dynamic study shows mild peripheral enhancement in the arterial phase, and no Primovist uptake in the hepatobiliary phase. Metastasis is first considered. DDx: atypical HCC, CCC.
- The major hepatic and portal veins are patent.

Adrenals: Unremarkable
Spleen: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable

Kidneys and ureters: Unremarkable

No obvious upper abdominal retroperitoneal lymphadenopathy identified.

Lower thorax: Unremarkable

)
  Paste(MyForm)
Return

;; MRI liver, Primovist
::amrlivp::
  MyForm =
(
MRI of the Liver with Primovist enhancement, and MRCP.

SCANNING PROTOCOL:
- Axi T2, T2+FS, DWI, ADC maps, T1 IP/OOP.
- Cor, Sag LAVA water, SSFSE T2
- Axi, Cor VIBE T1+FS: dynamic A/PV/delayed phases, 10/20/30 mins delayed images.
- MRCP, Cor, MIP reconstruction

COMPARISON: no

FINDINGS:
* A case of HCC, s/p OP, s/p RFA.
Liver:
- S/p right hepatectomy. Hypertrophic changes of the lateral segment.
- Cirrhotic changes: nil, portosystemic collaterals (-)
- A 8-mm nodule at the S2 (Se/Im: 11,12,13/26) shows slightly enhancement in the arterial but prominent washout in portal venous, equilibrium, and hepatobiliary phases. Recurrence HCC is suspected.
- Two mass lesions, about 4.8 and 4.2 cm, at the S4, show T1 slightly hypointensity, T2 slightly hyperintensity, restricted diffusion. The dynamic study shows mild peripheral enhancement in the arterial phase, and no Primovist uptake in the hepatobiliary phase. Metastasis is first considered. DDx: atypical HCC, CCC.
- The major hepatic and portal veins are patent.


Adrenals: Unremarkable
Spleen: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable

Kidneys and ureters: Unremarkable

No obvious upper abdominal retroperitoneal lymphadenopathy identified.

Lower thorax: Unremarkable

)
  Paste(MyForm)
Return

;; MRI Kidney
::amrrcc::
  MyForm =
(
MRI of the Kidney

SCANNING PROTOCOL:
- Cor TrueFISP, DWI (b=400): whole abdomen
- Axi, Cor TrueFISP thin slice: liver+kidney
- Axi TSE T2, T2+FS, DWI (b=1000), ADC maps, T1 IP/OOP
- Axi VIBE T1+FS: pre- and post-contrast artery and delayed phases
- MRU Cor, MIP reconstruction

COMPARISON: no

FINDINGS:
* A case of right RCC (pT3N0), s/p OP.
Kidneys and ureters: Unremarkable
Urinary bladder: Unremarkable

No pelvic, retroperitoneal or mesenteric lymphadenopathy.

Adrenals: Unremarkable
Spleen: Unremarkable
Liver: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable
Lower thorax: Unremarkable

)
  Paste(MyForm)
Return

;; MRI Adrenal
::amrad::
  MyForm =
(
MRI of the Adrenal glands

SCANNING PROTOCOL:
- Axial T2, T2+FS, DWI/ADC, T1 IP/OOP, post-contrast T1+FS artery, venous, and delayed phases
- Coronal T2, T1+FS
- Sagittal T1+FS

COMPARISON: no

FINDINGS:
Adrenals: No definite space-occupying lesion in the adrenal glands nor abnormal adrenal limb thickening.
Kidneys and ureters: Unremarkable.

Liver: Unremarkable
Spleen: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable

No obvious upper abdominal retroperitoneal lymphadenopathy identified.
)
  Paste(MyForm)
Return

;; MRI UB
::amrub::
  MyForm =
(
MRI of the Urinary bladder

SCANNING PROTOCOL:
- Distended rectum with jelly
- Abdomen and pelvis:
  * HASTE T2: axial, coronal
  * DWI: coronal
  * T1+C: axial
- Urinary bladder and Prostate:
  * TSE T2, DWI, ADC: axial
  * T1+FS: axial, sagittal
  * T1+C+FS: axial, coronal, sagittal
- MRU Cor, MIP reconstruction

COMPARISON: 2017-10-30 (CTU)

FINDINGS:
* A case of UB cancer, s/p TURBT, s/p CCRT.
Urinary bladder: Unremarkable
Kidneys and ureters: Unremarkable
Prostate: Unremarkable

No pelvic, retroperitoneal or mesenteric lymphadenopathy.

Adrenals: Unremarkable
Spleen: Unremarkable
Liver: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable
Lower thorax: Unremarkable
)
  Paste(MyForm)
Return

::mmrpc::  ; template for prostatic cancer

Send,  MRI of the abdomen & pelvis for prostatic cancer evaluation.  It was performed before and after Gd-DTPA enhancement.{Enter}
Send, MR protocols: T1WI, T2WI, DWI (b=1000 axial; b=400  coronal ) pulse sequences in axial, coronal, and sagittal views.  T1WI-FS pulse sequence  with iv. contrast administration.{Enter}
Send, Prostate:{Enter}
Send, 1. Size:{Enter}
Send,    Zonal demarction: clear (  ).{Enter}
Send,     Capsule: intact (  ).   {Enter}
Send, 2.  Lesions: {Enter}
Send,     L:             :-cen/junctional(  ) or peripheral (  ).  Sign of diffusional restriction (   )*. Enhancement (  ) {Enter}
Send,     R:             :-cen/junctional(  ) or peripheral (  ).  Sign of diffusional restriction (   ). Enhancement (  ) {Enter}
Send, {Enter}
Send, Seminal vesicles:intact (  ){Enter}
Send, {Enter}
Send, Urinary bladder: unremarkable (  ){Enter}
Send, {Enter}
Send, Rectum: intact (  ){Enter}
Send, {Enter}
Send, Lymphadenopathy: pelvic (  ) or para-aortic ( ).{Enter}
Send, - site: Obturator (  R/L), Internal iliac (  R/L), External iliac (  R/L), Sacral (  R/L), para-aortic (yes/no). {Enter}
Send, {Enter}
Send, 6. Other sites of metastasis ( ). (Regional/non-regional. Location: ){Enter}
Send, {Enter}
Send, 7. Focal bony lesion ( ).** {Enter}
Send, {Enter}
Send, {Enter}
Send, * DWI/ADC pulse sequence (b=1000){Enter}
Send,** DWI/ADC pulse sequence (b=400)

Send, {Tab}Prostatic cancer. (Pi-Rad)***.
Send, {Enter}
Send, {Enter}
Send, ***Pi-RAD score{Enter}
Send, PI-RADS 1: very low (clinically significant cancer is highly unlikely to be present){Enter}
Send, PI-RADS 2: low (clinically significant cancer is unlikely to be present){Enter}
Send, PI-RADS 3: intermediate (the presence of clinically significant cancer is equivocal){Enter}
Send, PI-RADS 4: high (clinically significant cancer is likely to be present){Enter}
Send, PI-RADS 5: very high (clinically significant cancer is highly likely to be present){Enter}

Return

::amrprcs::
  MyForm =
(
Prostate Cancer Staging Form

1. MR protocol
- Distended rectum with jelly
- Abdomen and pelvis:
  * HASTE T2: axial, coronal
  * DWI: coronal
  * T1+C: axial
- Prostate:
  * TSE T2, DWI, ADC: axial
  * T1+FS: axial, sagittal
  * T1+C+FS: axial, coronal, sagittal

2. Tumor location / Size
---Visible tumor
Not assessable
No or Equivocal
Yes:
Location: Right lobe or left lobe / Size _______cm (largest diameter of the biggest tumor)

3. Tumor invasion
---No or Equivocal
---Yes:
Prostate (
One-half of one lobe or less
More than one-half of one lobe but not both lobes
Involves both lobes)
Extracapsular extension (neurovascular bundle invasion: Rt___, Lt ____)
Seminal vesicle invasion (Rt ___, Lt ___)
Pelvic side wall
Pelvic organs invasion (If yes,
Bladder
Rectum
Others __________)

4. Regional nodal metastasis
---No or Equivocal
---Yes:
Obturator- Rt/Lt
Internal iliac- Rt/Lt
External iliac- Rt/Lt
Sacral
Others:

5. Distant metastasis (In this study)
---No or Equivocal
---Yes (location; regional or non-regional)

6. Others

)
  Paste(MyForm)
Return

::amrpr::
  MyForm =
(
MRI of Prostate

SCANNING PROTOCOL:
- Abdomen:
  * Axial: T2+FS, T1 IP/OOP, T1+C+FS
  * Coronal: T2, T1+C+FS
- Pelvis:
  * Axial: T2, T1+C+FS
- Prostate (small FOV):
  * Axial: T2, T1, T1+C dynamic, T1+C+FS, DWI, ADC
  * Coronal: T2, T1+C+FS
  * Sagittal: T2, T1+C+FS
  * MRS

COMPARISON: no

FINDINGS:
Prostate:
- Size: 5.5 x 3.4 x 4.7 cm
- Volume: 45.7 ml (length x width x height x 0.52)
- Focal T1 hyperintensities at left lobe, probably post-biopsy changes.
- Enlarged transition zone with heterogeneous nodular signal intensity and an intact low signal pseudocapsule in the periphery, suggestive of benign prostatic hyperplasia.
- Circumscribed hypointense or heterogeneous encapsulated nodule(s) (BPH)
- status post TURP appearance.

Lesion 1:
- location: peripheral zone of right base (PZpl)
- size: 0.9 cm
- T2WI: Heterogeneous signal intensity, moderate hypointensity
- DWI: Focal mildly hyperintense
- ADC: Focal mildly hypointense
- DCE: negative
= PI-RADS 3

* Peripheral Zone (PZ)
- T2WI: Uniform hyperintense signal intensity. (score 1)
- T2WI: Linear or wedge-shaped hypointensity, or diffuse mild hypointensity, usually indistinct margin. (score 2)
- T2WI: Heterogeneous signal intensity or non-circumscribed, rounded, moderate hypointensity. (score 3)
- T2WI: Circumscribed, homogenous moderate hypointense focus/mass confined to prostate and <1.5 cm in greatest dimension. (score 4)
- T2WI: Same as 4 but >=1.5 cm in greatest dimension or definite extraprostatic extension/invasive behavior. (score 5)

* Transition Zone (TZ)
- T2WI: Normal appearing TZ (rare) or a round, completely encapsulated nodule. ("typical nodule") (score 1)
- T2WI: A mostly encapsulated nodule OR a homogeneous circumscribed nodule without encapsulation. ("atypical nodule") OR a homogeneous mildly hypointense area between nodules. (score 2)
- T2WI: Heterogeneous signal intensity with obscured margins. (score 3)
- T2WI: Lenticular or non-circumscribed, homogeneous, moderately hypointense, and <1.5 cm in greatest dimension. (score 4)
- T2WI: Same as 4, but >=1.5 cm in greatest dimension or definite extraprostatic extension/invasive behavior. (score 5)

* DWI/ADC
- DWI/ADC: No abnormality on ADC and high b-valueDWI (score 1)
- DWI/ADC: Linear/wedge shaped hypointense on ADC and/or linear/wedge shaped hyperintense on high b-value DWI. (score 2)
- DWI/ADC: Focal (discrete and different from the background) hypointense on ADC and/or focal hyperintense on high b-value DWI; may be markedly hypointense on ADC or markedly hyperintense on high b-value DWI, but not both. (score 3)
- DWI/ADC: Focal markedly hypontense on ADC and markedly hyperintense on high b-value DWI; <1.5cm in greatest dimension. (score 4)
- DWI/ADC: Same as 4 but ≥1.5cm in greatest dimension or definite extraprostatic extension/invasive behavior. (score 5)

* DCE
- DCE: no early or contemporaneous enhancement; or diffuse multifocal enhancement NOT corresponding to a focal finding on T2W and/or DWI or focal enhancement corresponding to a lesion demonstrating features of BPH on T2WI (including features of extruded BPH in the PZ) (-)
- DCE: focal,and; earlierthan or contemporaneously with enhancement ofadjacent normal prostatic tissues, and; corresponds to suspicious finding on T2Wand/orDWI (+)


Lymphadenopathy:
- No regional lymphadenopathy.

Distant metastasis:
- No retroperitoneal or mesenteric lymphadenopathy.
- No evidence of bone metastasis.
- No evidence of distant metastasis in the liver, spleen, pancreas, adrenals, and kidneys.

Seminal vesicles: unremarkable
Seminal vesicles: bilateral cystic dilatation, probably related with benign prostatic hypertrophy.

Others: unremarkable

----
Footnotes:
T2WI = T2-weighted imaging; DWI = diffusion-weighted imaging; ADC = apparent diffusion coefficient; DCE = dynamic contrast enhanced.

----
PI-RADS v2.1 Assessment Categories:
* PI-RADS 1 - Very low (clinically significant cancer is highly unlikely to be present)
* PI-RADS 2 - Low (clinically significant cancer is unlikely to be present)
* PI-RADS 3 - Intermediate (the presence of clinically significant cancer is equivocal)
* PI-RADS 4 - High (clinically significant cancer is likely to be present)
* PI-RADS 5 - Very high (clinically significant cancer is highly likely to be present)
)
  Paste(MyForm)
Return

::prsz::
  Sleep, 100
  ProstateSizeCalForm()
Return

::amrcxca::
  MyForm =
(
Cervical Cancer Staging Form

1. MR protocol
- Abdomen and pelvis:
  * T2: axial, coronal  * DWI (b=400): coronal  * T1+C: axial
- Uterus:
  * TSE T2: axial, coronal, sagittal  * DWI (b=1000), ADC: axial
  * T1+FS: axial, sagittal  * T1+C+FS: axial, coronal, sagittal

2. Tumor Size:
---Measurable: ______cm (in maximal diameter)
---Non-measurable

3. Tumor invasion
---Not assessable
---No or Equivocal
---Yes
Cervix
Uterine body
Parametrial invasion (Rt ___, Lt ___)
Vaginal invasion (upper 2/3 ___, lower1/3 ___)
Pelvic side wall or floor
Hydronephrosis or Hydroureter (Rt ___, Lt ___)
Pelvic organs invasion (If yes, □ Bladder □ Rectum □ Sigmoid colon □ Others
_________)

4. Regional nodal metastasis
---No or Equivocal
---Yes
Right or left
Parametrial, obturator, internal iliac, external iliac, common iliac, sacral.

5. Distant metastasis (In this study)
---No or Equivocal
---Yes

6. Others:
- A 6.1-cm pedunculated uterine myoma at anterior wall.
- A 3.2-cm left ovarian cyst.
- Multiple small cystic lesions within the cervical stroma, in favor of Nabothian cysts.
- Small amount of ascites in the Cul-de-sac.

- Liver: Unremarkable
- Biliary tree: Unremarkable
- Spleen: Unremarkable
- Pancreas: Unremarkable
- GI tract: Unremarkable
- Kidneys and ureters: Unremarkable
- Urinary bladder: Unremarkable
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Cervical cancer,
)
  Paste(MyForm)
Return

::amrcx::
  MyForm =
(
MRI of the Uterine Cervix.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * T2: axial, coronal
  * DWI (b=400): coronal
  * T1+C: axial
- Uterus:
  * TSE T2: axial, coronal, sagittal
  * DWI (b=1000), ADC: axial
  * T1+FS: axial, sagittal
  * T1+C+FS: axial, coronal, sagittal

COMPARISON: no

FINDINGS:
Cervical tumor:
- A large lobulated infiltrative enhancing tumor at the uterine cervix, size about 6.5 x 4.9 x 6.4 cm, with right pelvic wall invasion, c/w cervical cancer. [T3b]
- Signal intensity: isointense on T1WI, slightly hyperintense on T2WI to myometrium, with diffusion restriction.
- Extent: whole uterine cavity, extending to the cervix.
- Invasion: disruption of low T2 signal cervical stroma

Lymph node:
- No regional lymph node metastasis. [N0]

Distant metastasis:
- No liver, adrenal metastasis.
- No non-regional lymph node metastasis.

Others:
- A 6.1-cm pedunculated uterine myoma at anterior wall.
- A 3.2-cm left ovarian cyst.
- Multiple small cystic lesions within the cervical stroma, in favor of Nabothian cysts.
- Small amount of ascites in the Cul-de-sac.

- Liver: Unremarkable
- Biliary tree: Unremarkable
- Spleen: Unremarkable
- Pancreas: Unremarkable
- GI tract: Unremarkable
- Kidneys and ureters: Unremarkable
- Urinary bladder: Unremarkable
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Cervical cancer,
)
  Paste(MyForm)
Return

::amrrec::
  MyForm =
(
MRI of the Pelvis and Rectum.

SCANNING PROTOCOL:
Pelvis:
- Axial T2+FS, T2, T1+FS, DWI, ADC, T1+C+FS
- Coronal T2, T1+C+FS,
- Sagittal T2, T1+C+FS
Abdomen:
- Axial T1+C+FS,
- Coronal T2, T1+C+FS

COMPARISON: no

FINDINGS:

)
  Paste(MyForm)
Return

::amrub::
  MyForm =
(
MRI of the Urinary bladder.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * T2: axial, coronal  * DWI (b=400): coronal
  * MRU
- Urinary bladder:
  * TSE T2: axial, coronal, sagittal  * DWI (b=1000), ADC: axial  * T1+FS: axial, sagittal

COMPARISON: no

FINDINGS:

)
  Paste(MyForm)
Return

::amrras::
  MyForm =
(
MRA of the renal arteries with 1.5T Avanto.

SCANNING PROTOCOL:
- Axial: T2, T2+FS, T1 IP/OOP, DWI/ADC, T1+C+FS
- Coronal: T2, T2+FS, T1+C+FS
- Sagittal: T2, T1+C+FS
- MRA: coronal, MIP coronal, 3D VRT

COMPARISON: no

FINDINGS:
Right renal artery:
- Presence of two superior renal arteries and one inferior renal artery.
- Presence of fusiform vascular ectasia, multifocal irregular luminal stenosis, and a string-of-beads appearance at the segmental branches of right renal artery suggests fibromuscular dysplasia.
- Mild narrowing at proximal (< 2 cm from the orifice)
- No definite luminal stenosis.
- No accessory renal artery or other variant.

Left renal artery:
- Presence of two superior renal arteries and one inferior renal artery.
- Mild narrowing at proximal (< 2 cm from the orifice)

Kidneys:
- A few small cysts in both kidneys.
- The sizes and shapes are within normal limits.

Adrenals: Unremarkable
Liver: several hepatic cysts.
Biliary tree: Unremarkable
Spleen: Unremarkable
Pancreas: Unremarkable
Lymphadenopathy: No
Lower lungs: Unremarkable
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
C/W renal artery stenosis, bilateral, mild.
No obvious renal artery stenosis.
)
  Paste(MyForm)
Return

::pirads::
  MyForm =
(
PI-RADS v2 Assessment Categories:
* PI-RADS 1 - Very low (clinically significant cancer is highly unlikely to be present)
* PI-RADS 2 - Low (clinically significant cancer is unlikely to be present)
* PI-RADS 3 - Intermediate (the presence of clinically significant cancer is equivocal)
* PI-RADS 4 - High (clinically significant cancer is likely to be present)
* PI-RADS 5 - Very high (clinically significant cancer is highly likely to be present)
)
  Paste(MyForm)
Return

::amrgynpa::
  MyForm =
(
MRI of the Uterus.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * TrueFISP T2 Cor; HASTE T2 Sag, Axi
  * DWI (b=400): Cor
- Uterus:
  * TSE T2 Axi, Cor, Sag
  * TSE T1 Axi, Cor, Sag; TSE T1+FS Axi
  * VIBE T1+FS Axi
  * DWI (b=1000), ADC: Axi

COMPARISON: no

FINDINGS:
A gravid uterus with abnormally low position of the placenta, completely covering the internal cervical os, c/w placenta previa, grade IV (complete placenta previa).

T2 HASTE and true FISP images show
- Heterogeneous signal intensity in the placenta
- Abnormal intraplacental dark bands
- Abnormal dilated intraplacental vascularity
- Focal thinning of myometrium
- Loss of triple-layered appearance of normal myometrium
at the lower anterior uterine segment, c/w placenta accreta. Suggest correlation with placental sonography and clinical history.

The fetus is in vertex presentation, and the images show no hydrocephalus, no hydronephrosis, and no obvious structural anomaly.
The amniotic fluid volume is within normal limits.


REF:
Imaging findings of PA, Cardinal signs
- Dark intraplacental bands on T2-weighted images
- Heterogeneity within the placenta
- Abnormal disorganized placental vascularity
- Others – less sensitive signs
- Uterine bulging
- Focal interruptions of the myometrial wall (high specificity for increta and percreta)
- Tenting of urinary bladder (highly specific for percreta)

- Irregular dark bands on T2 HASTE images showing decreased signal on true FISP images, representing abnormal fibrin deposition;
- Dilated tortuous signal voids on T2 HASTE images deep within the placenta showing increased signal on true FISP images, which is indicative of abnormal vascular lacunae.


Key imaging features of normal placentation
- Homogeneous T2-intermediate signal intensity of placenta
- Subtle thin, regularly spaced placental septi
- Normal subplacental vascularity
- Triple-layered sandwich appearance of myometrium
- Pear-shape of normal gravid uterus with smooth contour.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
C/W complete placenta previa, with placenta accreta. Suggest correlation with placental sonography and clinical history.
No obvious fetal anomaly.
)
  Paste(MyForm)
Return

::amremca::
  MyForm =
(
MRI of the Uterus.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * HASTE T2: coronal
- Abdomen:
  * T1 IP/OOP, T2+FS: axial
  * T1+C+FS: axial
- Uterus:
  * T2: axial, coronal
  * T2+FS: sagittal
  * DWI (b=50, 400, 800), ADC: axial
  * T1: axial, coronal, sagittal
  * T1+C+FS: axial, coronal, sagittal

COMPARISON: no

FINDINGS:
Endometrial tumor:
- Signal intensity: isointense on T1WI, slightly hyperintense on T2WI, with diffusion restriction; relative less enhancement.
- Extent: whole uterine cavity, extending to the cervix.
- Invasion: disruption of low T2 signal cervical stroma
- Invasion: intact low signal intensity junctional zone and preserved low T2 signal cervical stroma

Lymph node:
- No regional lymph node metastasis.

Distant metastasis:
- No liver, adrenal, or bone metastasis.
- No non-regional lymph node metastasis.

Others:
- A 6.1-cm pedunculated uterine myoma at anterior wall.
- A 3.2-cm left ovarian cyst.
- Multiple small cystic lesions within the cervical stroma, in favor of Nabothian cysts.
- Small amount of ascites in the Cul-de-sac.

- Adrenals: Unremarkable
- Liver: Unremarkable
- Biliary tree: Unremarkable
- Spleen: Unremarkable
- Pancreas: Unremarkable
- GI tract: Unremarkable
- Kidneys and ureters: Unremarkable
- Urinary bladder: Unremarkable
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Endometrial cancer, FIGO Stage II.
)
  Paste(MyForm)
Return

; Acute appendicitis
::amrapp::
  MyForm =
(
MRI of the Abdomen for r/o acute appendicitis in pregnancy.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * TrueFISP T2 Cor, Sag; HASTE T2+FS Cor
  * DWI (b=400): Cor
- Upper abdomen:
  * Axi: TSE T2, FL2D T1+FS
- Lower abdomen and pelvis:
  * Axi: TrueFISP T2, HASTE T2+FS, TSE T2, FL2D T1_FS
- Thin slice focusing on RLQ:
  * TSE T2 Axi, Cor, Sag

COMPARISON: no

FINDINGS:
The appendix cannot be depicted well. However, no definite swollen tubular structure or inflammatory changes over the pericecal region. No strong evidence of acute appendicitis.

A gravid uterus with normal position of the placenta.
The fetus is in breech presentation, and the images show no hydrocephalus, no hydronephrosis, and no obvious structural anomaly.
The amniotic fluid volume is within normal limits.

A small left renal cyst.
Mild right renal pelvic and calyceal dilatation, probably secondary to the pregnancy.
The liver, gallbladder, spleen, and pancreas are unremarkable.
No retroperitoneal or mesenteric lymphadenopathy.
No obvious ascites.
The lungs covered in the scanning range are unremarkable.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
No strong evidence of acute appendicitis.
)
  Paste(MyForm)
Return

; PCU Abd Tumor Screening
::amrpcu::
  MyForm =
(
MRI of the abdomen and pelvis

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * T2: axial, coronal; * Heavy T2: axial; * DWI (b=400): coronal
  * T1 postcontrast delay phase + FS: axial
- Abdomen
  * Coronal T2
  * Axial T2+FS, DWI (b=50,400,1000)/ADC, In/Out phase
  * Precontrast T1+FS axial; postcontrast T1+FS axial, coronal
  * MRA
- Biliary
  * Coronal 3D MRCP
- Pelvis
  * Higher resolution T2: axial, sagittal; T1 axial
  * DWI(b=50,400,1000)/ADC: axial
  * Postcontrast T1+FS: axial, sagittal

COMPARISON: no

FINDINGS:
Liver: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable
Spleen: Unremarkable

GI tract: Unremarkable (* limited evaluation due to peristalsis, susceptibility artifact from gas, etc.)

Adrenals: Unremarkable
Kidneys and ureters: Unremarkable
Urinary bladder: Unremarkable

Prostate: Unremarkable
GYN organ: Unremarkable

No pelvic, retroperitoneal or mesenteric lymphadenopathy.
The abdominal aorta and its major branches are unremarkable.
)
  Paste(MyForm)
Return

; PCU GYN Tumor Screening
::amrpcugyn::
  MyForm =
(
MRI of the abdomen and pelvis with 3T Skyra.

SCANNING PROTOCOL:
- Abdomen and pelvis:
  * HASTE T2: coronal; * DWI (b=400): coronal
- Pelvis
  * Higher resolution T2 TSE, T1 Precontrast, postcontrast +FS: axial, sagittal
  * DWI/ADC: axial

COMPARISON: no

FINDINGS:
GYN organ: Unremarkable

Liver: Unremarkable
Biliary tree: Unremarkable
Pancreas: Unremarkable
Spleen: Unremarkable

GI tract: Unremarkable

Adrenals: Unremarkable
Kidneys and ureters: Unremarkable
Urinary bladder: Unremarkable

No pelvic, retroperitoneal or mesenteric lymphadenopathy.
)
  Paste(MyForm)
Return
