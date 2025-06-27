; CT-guide Forms
::0ctg-lb::
  MyForm =
(
CT-guide lung biopsy is indicated and has been scheduled on / PM. If specimen for tissue culture is needed, please prepare other specimen collecting bottles and send to CT room with the patient. Otherwise, only specimen immersed in formalin will be harvested.
)
  Paste(MyForm)
Return

::1ctg-lb::
  FormatTime, currDateStr, L1033, M/d tt
  MyForm =
(
CT guide lung biopsy was performed in %currDateStr%. Please follow up CXR if pneumothorax develops or progresses.
)
  Paste(MyForm)
Return

::1ctg-b::
  FormatTime, currDateStr, L1033, M/d tt
  MyForm =
(
CT guide biopsy was performed in %currDateStr%. Please keep bed rest and check if internal bleeding occurs.
)
  Paste(MyForm)
Return


;; Lung Biopsy
::ctg-lb::
  MyForm =
(
CT guide biopsy was performed under clinical request. The operation procedure and potential risk were well explained. Patient agreement and consensus were obtained.
Under CT guide, tissue specimens were smoothly taken for pathology examination.

1. Position:
2. Target lesions
-> A. Location lobe:
-> B. Main lesion size:  mm
-> C. Cavity or central necrosis: Yes / No
-> D. Pleural distance:  mm
3. Focal emphysema of lung parenchyma: No / Mild / Moderate / Severe
4. Patient cooperation: good / fair / poor
5. Complications:
-> A. Pneumothorax: No / Minimal / Mild / Moderate / Severe; Aspiration for pneumothorax: Yes / No
-> B. Focal hemorrhage: Yes, mild / No
-> C. Hemoptysis: No
-> D. Chest tightness: No
-> E. Asthma: No
6. Specimen: (4 attempts to biopsy)
-> Formalin: x3; normal saline: x1 (part of one sample);
-> Bacterial culture swab: aerobic x1; anaerobic x1.

The patient was sent back to the ward under stable condition without complaint.
Recommend close f/u patient's vital signs, bed rest and compression for at least 4 hours.
F/U CXR 6 hours later.

IMPRESSION:
CT guide lung biopsy of  tumor was performed.
Mild pneumothorax was noted. Follow-up is suggested.
)
  Paste(MyForm)
Return


;; Lung Biopsy, pigtail for pneumothorax
::ctg-lb-p::
  MyForm =
(
CT guide biopsy was performed under clinical request. The operation procedure and potential risk were well explained. Patient agreement and consensus were obtained.
Under CT guide, tissue specimens were smoothly taken for pathology examination.

1. Position:
2. Target lesions
   A. Location lobe:
   B. Main lesion size:  mm
   C. Cavity or central necrosis: Yes/No
   D. Pleural distance:  mm
3. Focal emphysema of lung parenchyma: No/Mild/Moderate/Severe
4. Patient cooperation: good/fair/poor
5. Complications:
   A. Pneumothorax: Mild/Moderate/Severe; Pigtail for pneumothorax: Yes, 6Fr.
   B. Focal hemorrhage: Yes
   C. Hemoptysis: No
   D. Chest tightness: No
   E. Asthma: No
6. Specimen: (4 attempts to biopsy)
   Formalin: x2; normal saline: x1; TB culture: x1.
   Bacterial culture swab: aerobic x1; anaerobic x1.

The patient was sent back to the ward under stable condition without complaint.
Recommend close f/u patient's vital signs, oxygen supplement, chest bottle with Emerson, bed rest and compression for at least 4 hours.
F/U CXR 6 hours later.
)
  Paste(MyForm)
Return


;; Drainage
::1ctg-d::
  FormatTime, currDateStr, L1033, M/d tt
  MyForm =
(
CT guide drainage was performed in %currDateStr%. A 8 Fr pigtail drain was inserted. 10 ml of aspirated pus was collected for Lab exam.
)
  Paste(MyForm)
Return

::ctg-d::
  MyForm =
(
CT guide drainage was performed under clinical request. The operation procedure and potential risk were well explained. Patient agreement and consensus were obtained.
Under CT guide, tissue specimens were smoothly taken for pathology examination.

1. Position:
2. Target lesion:
3. Patient cooperation: good/fair/poor
4. Complications: nil.
5. Drain: 6F one-step pigtail drain.
6. Specimen: pus.

The patient was sent back to the ward under stable condition without complaint.

IMPRESSION:
CT guide drainage for  was performed.
)
  Paste(MyForm)
Return


;; Drainage
::ctg-b::
  MyForm =
(
CT guide biopsy was performed under clinical request. The operation procedure and potential risk were well explained. Patient agreement and consensus were obtained.

Under CT guide, tissue specimens were smoothly taken for pathology examination.

1. Position:
2. Target lesion:
3. Patient cooperation: good
4. Complications: nil.
5. Instrument: 18G Biopsy needle in 17G coaxial needle.
6. Specimen: Formalin: x4

Gelfoam slurry was injected through the coaxial needle after biopsy.

The patient was sent back to the ward under stable condition without complaint. Recommend close f/u patient's vital signs, bed rest and compression for at least 4 hours.

IMPRESSION:
CT guide biopsy for  was performed.
)
  Paste(MyForm)
Return


;; RFA
::ctg-rfa::
  MyForm =
(
Radiofrequency ablation of liver tumor(RFA<=2cm):
Radiofrequency ablation of liver tumor(>2cm;<=4cm):

Anesthesia: general
Device: Medtronic Cool-tip RF ablation single, 15 cm x 3 cm.
Ablation session: 1
Tumor location and size: S8, 2 cm.
Complication: nil.

IMPRESSION:
RFA for S8 hepatic tumor was performed.
)
  Paste(MyForm)
Return

;; MWA
::ctg-mwa::
  MyForm =
(
Microwave ablation of renal tumor(>2cm;<=4cm):
Microwave ablation of liver tumor(>2cm;<=4cm):

Anesthesia: general
Position: prone
Position: right semi-decubitus
Position: supine

Device: ECO 16G ceramic antenna, 12 mm exposed tip, 15 cm shaft.
Device: ECO 14G ceramic antenna, 12 mm exposed tip, 15 cm shaft.
Device: Canyon Suretip antennas, 15G, 11 mm active tip, 18 cm shaft.

Ablation parameter: 40W x 8 min, ablation zone: diameter 33 mm, length 47 mm.

Ablation parameter:
1. 40W x 5 min, ablation zone: diameter 25 mm, length 35 mm
2. 20W x 12 min, ablation zone: diameter 30 mm, length 33 mm

Tumor location and size: left kidney, 31 x 24 x 34 mm.
Tumor location and size: S3, 30 x 21 x 20 mm.

Complication: nil.

IMPRESSION:
MWA for left kidney RCC was performed.
MWA for S3 HCC was performed.
)
  Paste(MyForm)
Return
