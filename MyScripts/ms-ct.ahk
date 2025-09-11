; MS CT Forms

;; Hotstrings
::l12::L1-L2
::l13::L1 through L3
::l14::L1 through L4
::l15::L1 through L5
::l11::L1 through S1
::l23::L2-L3
::l24::L2 through L4
::l25::L2 through L5
::l21::L2 through S1
::l34::L3-L4
::l35::L3 through L5
::l31::L3 through S1
::l45::L4-L5
::l41::L4 through S1
::l51::L5-S1

::c12::C1-C2
::c13::C1 through C3
::c14::C1 through C4
::c15::C1 through C5
::c16::C1 through C6
::c17::C1 through C7
::c11::C1 through T1
::c23::C2-C3
::c24::C2 through C4
::c25::C2 through C5
::c26::C2 through C6
::c27::C2 through C7
::c21::C2 through T1
::c34::C3-C4
::c35::C3 through C5
::c36::C3 through C6
::c37::C3 through C7
::c31::C3 through T1
::c45::C4-C5
::c46::C4 through C6
::c47::C4 through C7
::c41::C4 through T1
::c56::C5-C6
::c57::C5 through C7
::c51::C5 through T1
::c67::C6-C7
::c61::C6 through T1
::c71::C7-T1

::t12::T1-T2
::t13::T1 through T3
::t14::T1 through T4
::t15::T1 through T5
::t16::T1 through T6
::t17::T1 through T7
::t18::T1 through T8
::t19::T1 through T9
::t110::T1 through T10
::t111::T1 through T11
::t112::T1 through T12
::t23::T2-T3
::t24::T2 through T4
::t25::T2 through T5
::t26::T2 through T6
::t27::T2 through T7
::t28::T2 through T8
::t29::T2 through T9
::t210::T2 through T10
::t211::T2 through T11
::t212::T2 through T12
::t34::T3-T4
::t35::T3 through T5
::t36::T3 through T6
::t37::T3 through T7
::t38::T3 through T8
::t39::T3 through T9
::t310::T3 through T10
::t311::T3 through T11
::t312::T3 through T12
::t45::T4-T5
::t46::T4 through T6
::t47::T4 through T7
::t48::T4 through T8
::t49::T4 through T9
::t410::T4 through T10
::t411::T4 through T11
::t412::T4 through T12
::t56::T5-T6
::t57::T5 through T7
::t58::T5 through T8
::t59::T5 through T9
::t510::T5 through T10
::t511::T5 through T11
::t512::T5 through T12
::t67::T6-T7
::t68::T6 through T8
::t69::T6 through T9
::t610::T6 through T10
::t611::T6 through T11
::t612::T6 through T12
::t78::T7-T8
::t79::T7 through T9
::t710::T7 through T10
::t711::T7 through T11
::t712::T7 through T12
::t89::T8-T9
::t810::T8 through T10
::t811::T8 through T11
::t812::T8 through T12
::t910::T9-T10
::t911::T9 through T11
::t912::T9 through T12
::t1011::T10-T11
::t1012::T10 through T12
::t1112::T11-T12

::t11::T1 through L1
::t21::T2 through L1
::t31::T3 through L1
::t41::T4 through L1
::t51::T5 through L1
::t61::T6 through L1
::t71::T7 through L1
::t81::T8 through L1
::t91::T9 through L1
::t101::T10 through L1
::t111::T11 through L1
::t121::T12-L1

::g1::grade 1 `
::g2::grade 2 `
::g3::grade 3 `

;; CT Extremity - Colles Fracture
::ectcf::
  MyForm =
(
CT Upper Extremity:
Scanning from right forearm to finger, axial, coronal, sagittal, and 3D VRT views

FINDINGS:
Right distal radial fracture
- dorsal angulation
- dorsal displacement
- no involvement of the radioulnar joint
- intra-articular fracture: (+)
- other fracture: nil

IMPRESSION:
Right Colles fracture, with intra-articular involvement.
)
  Paste(MyForm)
Return

;; CT Extremity - Lower Limbs
::ectl::
  MyForm =
(
CT Lower Extremity:
Non-contrast study.
Pre- and post-contrast study.
Scanning from thigh to foot, axial, coronal, sagittal, and 3D VRT views
Scanning from thigh to foot, axial, coronal, sagittal views

FINDINGS:
)
  Paste(MyForm)
Return

;; CTA - Lower limb
::ectal::
  MyForm =
(
CTA of Lower Extremity:
Pre and post contrast-enhanced axial scanning from kidney to foot
Axial and coronal reconstruction with MIP technique

COMPARISON: no

FINDINGS:

Atrophic changes of bilateral kidneys, in favor of chronic kidney disease.
Some small nonobstructive bilateral renal stones.

The lower abdomen and pelvis are unremarkable.
No retroperitoneal or mesenteric lymphadenopathy.
)
  Paste(MyForm)
Return

;; CT Extremity - Lower Limbs, DVT
::ectldvt::
  MyForm =
(
CT Lower Extremity:
Pre and post contrast-enhanced study.
Axial Scanning from lower abdomen to foot, with coronal reconstruction

FINDINGS:
Mild subcutaneous soft tissue edema over the left lower extremity.
Presence of engorged vessel with intraluminal filling defects, consistent with deep venous thrombosis.
Extent: left external iliac, common femoral, great saphenous vein (proximal part).

The skeleton of lower limb is unremarkable.

IMPRESSION:
C/W DVT.
)
  Paste(MyForm)
Return

;; CT Extremity - Lower Limbs, Knee OA
::ectloa::
  MyForm =
(
CT Lower Extremity:
Non-contrast study.
Scanning from pelvis to foot, axial, coronal, sagittal views

FINDINGS:
- Bilateral knees show joint space narrowing, marginal osteophyte formation, subchondral sclerosis, especially at medial compartment of knee joint, consistent with osteoarthrosis.
- Left moderate and right small suprapatellar effusion.
- Mild bilateral genu varum is noted.
- No obvious dislocation or fracture.
- The visible intraabdominal organs are unremarkable.

IMPRESSION:
OA changes of bilateral knees.
)
  Paste(MyForm)
Return

;; CTA - PAOD
::ectapaod::
  MyForm =
(
CTA of Lower Extremity:
Pre and post contrast-enhanced axial scanning from kidney to foot
Axial and coronal reconstruction with MIP technique
3D VRT reconstruction

COMPARISON: no

FINDINGS:
Atherosclerotic changes and calcification of the arterial wall, from abdominal aorta to the peripheral arteries of foot.
Because too small diameter of arteries and the severe calcification, the patency below the popliteal level is difficult to evaluate.

Multifocal luminal stenosis in the bilateral anterior tibial, posterior tibial, and peroneal arteries, c/w peripheral arterial disease. They are relatively patent to at least ankle level.
Because too small diameter of arteries and the severe calcification, the evaluation may be limited.

Atrophic changes of bilateral kidneys, in favor of chronic kidney disease.
Some small nonobstructive bilateral renal stones.

The lower abdomen and pelvis are unremarkable.
No retroperitoneal or mesenteric lymphadenopathy.

IMPRESSION:
Severe arterial wall calcification from abdominal aorta to feet.
Because too small diameter of arteries and the severe calcification, the patency below the popliteal level is difficult to evaluate.
)
  Paste(MyForm)
Return

;; CT Extremity - Upper Limbs
::ectu::
  MyForm =
(
CT Upper Extremity:
Non-contrast enhanced study.
Pre and post contrast-enhanced study.
Scanning from arm to finger, axial, coronal, sagittal views
Scanning from arm to finger, axial, coronal, sagittal, and 3D VRT views

FINDINGS:
)
  Paste(MyForm)
Return

::ectau::
  MyForm =
(
CTA of Upper Extremity:
Pre and post contrast-enhanced axial scanning from aortic arch to hand
Axial and coronal reconstruction with MIP technique

COMPARISON: no

FINDINGS:

)
  Paste(MyForm)
Return

;; CT Shoulder
::ects::
  MyForm =
(
CT Shoulder:
Non-contrast study.
Pre and post contrast-enhanced study.
Scanning from neck to upper chest, centering at shoulder, axial, coronal, sagittal views
Scanning from neck to upper chest, centering at shoulder, axial, coronal, sagittal, and 3D VRT views

FINDINGS:
)
  Paste(MyForm)
Return

;; CT Knee
::ectk::
  MyForm =
(
CT Knee:
Non-contrast study.
Pre and post contrast-enhanced study.

FINDINGS:
)
  Paste(MyForm)
Return

;; CT Ankle
::ecta::
  MyForm =
(
CT Ankle:
Non-contrast study.
Pre- and post-contrast study.
Scanning from leg to foot, axial, coronal, sagittal, and 3D VRT views
Scanning from leg to foot, axial, coronal, sagittal views

FINDINGS:
)
  Paste(MyForm)
Return
