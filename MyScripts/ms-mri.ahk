; MS MRI Forms

;; Hotstrings
::kmrok::The anterior cruciate ligament, posterior cruciate ligament, medial collateral ligament, lateral collateral ligament, medial meniscus, and lateral meniscus, quadricep tendon and patellar tendon are unremarkable.
::mrarok::No arthrographic evidence of full-thickness tear of rotator cuff or adhesive capsulitis.
::pt::partial tear
::ct::complete tear
::ftt::full-thickness tear `
::ptt::partial-thickness tear `
::je::joint effusion
::be::bursal effusion
::jbe::joint and bursal effusion
::jbeok::No obviously increased joint or bursal effusion.
::bme::bone marrow edema
::mpp::mediopatellar plica
::mppok::Presence of mediopatellar plica. The adjacent patellar and femoral cartilages are normal.
::cmp1::focal areas of hyperintensity on PDWI with normal contour
::cmp2::blister-like swelling/fraying of articular cartilage extending to surface
::cmp3::partial thickness cartilage loss with focal ulceration
::cmp4::full thickness cartilage loss with underlying bone reactive changes
::aclsp::Edematous change and increased signal intensity over the anterior cruciate ligament (ACL) with preserved fiber continuity. Sprain is considered.
::pclsp::Edematous change and increased signal intensity over the posterior cruciate ligament (PCL) with preserved fiber continuity. Sprain is considered.
::aclct::Edematous change and increased signal intensity over the anterior cruciate ligament (ACL) with incontinuous fiber. Complete tear is considered.
::pclct::Edematous change and increased signal intensity over the posterior cruciate ligament (PCL) with incontinuous fiber. Complete tear is considered.
::aclpt::Edematous change and increased signal intensity over the anterior cruciate ligament (ACL) with focally incontinuous fiber. Partial tear is considered.
::pclpt::Edematous change and increased signal intensity over the posterior cruciate ligament (PCL) with focally incontinuous fiber. Partial tear is considered.
::mrsab::Presence of Hill Sachs deformity manifesting an impaction lesion of the posterolateral aspect of the humeral head, and under MR-arthrogram, the anteroinferior labrum is frayed and absence that considered Bankart lesion, the findings c/w secondary to anterior glenohumeral dislocation.
::ssftt::full-thickness tear of the supraspinatus.
::isftt::full-thickness tear of the infraspinatus.
::ssptt::partial-thickness tear of the supraspinatus.
::isptt::partial-thickness tear of the infraspinatus.
::sscptt::partial-thickness tear of the subscapularis.
::mroa::marginal osteophyte formation, irregular joint space narrowing, cartilage loss, subchondral signal intensity change in the pancompartment of knee, especially the medial compartment, in favor of osteoarthrosis.
::bb::bone bruise

;; MRI of Knee
::mrkr::
  MyForm =
(
MRI of right knee in
Axial T2*
Coronal T2+FS, PD
Sagittal T2 STIR, T2, T1
Sagittal ACL T2, PCL T2

PREVIOUS MRI of knee: none.

FINDINGS:

)
  Paste(MyForm)
Return

::mrkl::
  MyForm =
(
MRI of left knee in
Axial T2*
Coronal T2+FS, PD
Sagittal T2 STIR, T2, T1
Sagittal ACL T2, PCL T2

PREVIOUS MRI of knee: none.

FINDINGS:

)
  Paste(MyForm)
Return

; MRI of shoulder
::mrsa::
  MyForm =
(
MRI of right / left shoulder in:
axial plane: T2WI
oblique coronal plane: T2WI, PDWI
oblique sagittal plane: T1WI, PDWI with fat saturation
with MR arthrography in oblique coronal plane:

PREVIOUS MRI of shoulder: none.

FINDINGS:
)
  Paste(MyForm)
Return

::mrsr::
  MyForm =
(
MRI of right shoulder in:
axial plane: T2WI
oblique coronal plane: T2WI, PDWI
oblique sagittal plane: T1WI, PDWI with fat saturation

PREVIOUS MRI of shoulder: none.

FINDINGS:

)
  Paste(MyForm)
Return

::mrsl::
  MyForm =
(
MRI of left shoulder in:
axial plane: T2WI
oblique coronal plane: T2WI, PDWI
oblique sagittal plane: T1WI, PDWI with fat saturation

PREVIOUS MRI of shoulder: none.

FINDINGS:

)
  Paste(MyForm)
Return

; MRI of ankle
::mrar::
  MyForm =
(
MRI of right ankle in:
axial plane: GRE T2*WI, FSE T1WI
coronal plane: T2WI+FS, PDWI
sagittal plane: T2WI, STIR, T1WI

PREVIOUS MRI: none.

FINDINGS:

)
  Paste(MyForm)
Return

::mral::
  MyForm =
(
MRI of left ankle in:
axial plane: GRE T2*WI, FSE T1WI
coronal plane: T2WI+FS, PDWI
sagittal plane: T2WI, STIR, T1WI

PREVIOUS MRI: none.

FINDINGS:

)
  Paste(MyForm)
Return

; MRI of wrist
::mrwr::
  MyForm =
(
MRI of right wrist in
coronal plane: PDWI, T2WI, T2 STIR
axial plane: T1WI, T2WI, fat-suppressed T2WI
sagittal plane: T2WI

PREVIOUS MRI of wrist: none.

FINDINGS:

)
  Paste(MyForm)
Return

::mrwl::
  MyForm =
(
MRI of left wrist in
coronal plane: PDWI, T2WI, T2 STIR
axial plane: T1WI, T2WI, fat-suppressed T2WI
sagittal plane: T2WI

PREVIOUS MRI of wrist: none.

FINDINGS:

)
  Paste(MyForm)
Return
