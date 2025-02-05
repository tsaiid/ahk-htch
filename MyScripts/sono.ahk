; Sono
;; Hotstrings
::hel::hypoechoic lesion
:c:hen::hypoechoic nodule
:c:Hen::hyperechoic nodule
::cp::calcified plaque

;; Sono, Upper Abdomen
::slcpd::Heterogeneous hyperechoic liver parenchyma echo pattern, suspicious chronic parenchymal disease.
::slfl::Coarsening and hyperechoic liver parenchyma echo pattern, in favor of fatty liver changes.
::slfll::Coarsening and hyperechoic liver parenchyma echo pattern without focal lesion noted, in favor of fatty liver changes. It may mask lesions, especially in the deep region.
::slmfl::Slightly increased hyperechoic liver parenchyma, in favor of mild fatty liver changes.
::slc::Irregular surface of the liver and coarsening changes of the parenchyma, indicating cirrhosis.
::slmc::Mildly irregular surface of the liver and coarsening changes of the parenchyma, indicating mild cirrhosis.
::sngb::The gallbladder is not seen, may be due to previous cholecystectomy.
::sckd::Cortical thinning, increased echogenicity, and small sizes of both kidneys, in favor of chronic kidney disease.
::smckd::Mild cortical thinning, increased echogenicity, and small sizes of both kidneys, in favor of chronic kidney disease.
::sspc::The gallbladder was not found, most likely resected at the previous operation.
::sgbnnpo::Probably due to non-NPO status, the gallbladder is not distended enough for evaluation. However, no focal lesion is noted.
::subnf::The urinary bladder is not distended enough for evaluation. However, no focal lesion is noted.
::sgbsp::Absence of gallbladder, probably post cholecystectomy.
::sgbp::A tiny echogenic polyp, __ cm in size, in the gallbladder noted. Cholesterol polyp is considered.
::sgbps::Several tiny echogenic polyps, size up to __ cm, in the gallbladder noted. Cholesterol polyps are considered.
::sgbs::A __-cm echogenic lesion in GB with acoustic shadow, in favor gallstone.
::sgbss::Several echogenic lesions in GB with acoustic shadow, in favor gallstones.
::sgbss1::Several echogenic lesions in GB with postural changes and acoustic shadow, in favor gallstones.
::sgba::Comet tail artifacts from the gallbladder wall, adenomyomatosis should be considered.
::sgba1::Presence of tiny GB adenomyomatoses with RA (Rokitanski-Aschoff) sinus noted.
::sgbcc::Mild gallbladder wall thickening, suspicious chronic cholecystitis.
::srbcs::Several renal cysts in the both kidneys, size up to  cm.{Left 4}
::srrc::A __-cm renal cyst in the right kidney.
::srrcs::Several renal cysts in the right kidney, size up to  cm.{Left 4}
::srlc::A __-cm renal cyst in the left kidney.
::srlcs::Several renal cysts in the left kidney, size up to  cm.{Left 4}
::spb::The pancreas can not be well evaluated because of gas blockage.
::spaok::The visualized portion of pancreas is normal.
::bsm::Borderline splenomegaly, size about  cm.{Left 4}
::rllv::right lobe of liver
::lllv::left lobe of liver
::bllv::bilateral lobes of liver
::rk::right kidney
::lk::left kidney
::lok::No evidence of liver metastasis.
::aacp::Calcified plaques at the abdominal aorta, suspicious atherosclerosis.

;; Sono, Lower Abdomen
::s-foley::status post Foley catheterization. The urinary bladder is not distended enough for evaluation.
::sruus::A tiny stone at upper third of right ureter, with mild hydronephrosis.
::srlus::A tiny stone at lower third of right ureter, with mild hydronephrosis and hydroureter.
::sluus::A tiny stone at upper third of left ureter, with mild hydronephrosis.
::sllus::A tiny stone at lower third of left ureter, with mild hydronephrosis and hydroureter.
::sscrok::The size and vascularity of bilateral testes and epididymides are within normal limits.

;; Sono, Thyroid
::etg::Enlarged thyroid gland.
::metg::Mildly enlarged thyroid gland.
::rtl::right thyroid lobe
::rutl::upper portion of right thyroid lobe
::rltl::lower portion of right thyroid lobe
::ltl::left thyroid lobe
::lutl::upper portion of left thyroid lobe
::lltl::lower portion of left thyroid lobe
::btl::bilateral thyroid lobes
::stwnl::The sizes of thyroid gland are within normal limits.
::stlok::The left thyroid lobe is unremarkable.
::strok::The right thyroid lobe is unremarkable.
::stblnok::Bilateral neck lymph nodes noted with hila, favored benign lymph nodes.
::stblnok1::No definite bulky neck lymphadenopathy is noted.
::stbrln::Some slightly enlarged lymph nodes with preserved hilar structure at the bilateral neck regions are noted, probably reactive lymph nodes.
::tr1::TI-RADS TR1, benign.
::tr2::TI-RADS TR2, not suspicious.
::tr3::TI-RADS TR3, mildly suspicious.
::tr4::TI-RADS TR4, moderately suspicious.
::tr5::TI-RADS TR5, highly suspicious.
::trnofu::Because the size does not reach the lower limit in this TI-RADS category, routine follow-up may not be recommended.
::trnofus::Because the sizes do not reach the lower limits in each TI-RADS category, routine follow-up may not be recommended.
::trnofus1::Several other tiny cystic, spongiform, and solid nodules in the bilateral thyroid lobes. Because the sizes do not reach the lower limits in each TI-RADS category, routine follow-up may not be recommended.
::trnofna::Because the size does not reach the lower limit in this TI-RADS category, FNA may not be recommended.
::trnofna1::Several other small cystic, spongiform, and solid nodules in the bilateral thyroid lobes. Because the sizes do not reach the lower limits in each TI-RADS category, FNA may not be recommended.
::nofna::No FNA is recommended.
::pef::punctate echogenic foci
::ttw::taller-than-wide
::stgd::
  MyForm =
(
The thyroid gland is diffusely enlarged and shows hyperechoic, heterogeneous echotexture, and demonstrate a thyroid inferno pattern on color Doppler. Graves disease may be suspected. DDx: other acute or subacute thyroiditis. Suggest correlate with Lab data.
)
  Paste(MyForm)
Return

::stgd1::
  MyForm =
(
The thyroid gland is diffusely enlarged and shows hyperechoic, heterogeneous echotexture, and demonstrate an increased vascularity pattern on color Doppler, suspicious thyroiditis.
)
  Paste(MyForm)
Return

::stgd2::
  MyForm =
(
The thyroid gland is diffusely enlarged and shows hyperechoic, heterogeneous echotexture. No obvious increased vascularity pattern is noted on color Doppler. Subacute thyroiditis may be suspected.
)
  Paste(MyForm)
Return

::stgd3::
  MyForm =
(
The thyroid gland size is within normal limits and shows hyperechoic, heterogeneous echotexture. No obvious increased vascularity pattern is noted on color Doppler. Chronic thyroiditis may be suspected.
)
  Paste(MyForm)
Return

::stst::
  MyForm =
(
The thyroid gland size is within normal limits and there is no abnormal flow pattern noted on color Doppler. However, the thyroid gland shows mild heterogeneous echotexture. Subacute thyroiditis cannot be excluded. Suggest clinical correlation.

Small bilateral neck lymph nodes noted with hila, favored benign lymph nodes.
)
  Paste(MyForm)
Return

::stg::
  MyForm =
(
- The thyroid gland is slightly diffusely enlarged without focal lesion.
- There is no abnormal flow pattern noted on color Doppler.
- No definite bulky neck lymphadenopathy is noted.
)
  Paste(MyForm)
Return

::stg1::
  MyForm =
(
- The thyroid gland is slightly diffusely enlarged.
- There is no abnormal flow pattern noted on color Doppler.
- Several tiny cystic, spongiform, and solid nodules in the bilateral thyroid lobes.
- A few small cystic or spongiform nodules in the bilateral thyroid lobes, probably benign.
- No definite bulky neck lymphadenopathy is noted.
)
  Paste(MyForm)
Return

::stok::
  MyForm =
(
- The thyroid sizes are within normal limits without focal lesion.
- There is no abnormal flow pattern noted on color Doppler.
- No definite bulky neck lymphadenopathy is noted.
)
  Paste(MyForm)
Return

::stok1::
  MyForm =
(
- The thyroid sizes are within normal limits.
- There is no abnormal flow pattern noted on color Doppler.
- Several tiny cystic, spongiform, and solid nodules in the bilateral thyroid lobes. Because the sizes do not reach the lower limits in each TI-RADS category, FNA may not be recommended.
- No definite bulky neck lymphadenopathy is noted.
)
  Paste(MyForm)
Return

;; Sono, Breast
::Is::INDICATION: breast cancer, s/p OP, follow-up.
::pm::partial mastectomy
::tm::total mastectomy
::sbbsp::Scars at the bilateral breasts.
::sbrsp::A scar at the right breast.
::sblsp::A scar at the left breast.
::sbrspp::status post previous right BCS (Breast conservation surgery) without evidence of local recurrence.
::sblspp::status post previous left BCS (Breast conservation surgery) without evidence of local recurrence.
::sbbspp::status post previous bilateral BCS (Breast conservation surgery) without evidence of local recurrence.
::sbrspm::status post previous right modified radical mastectomy without evidence of local recurrence.
::sblspm::status post previous left modified radical mastectomy without evidence of local recurrence.
::sbbspm::status post previous bilateral modified radical mastectomy without evidence of local recurrence.
::sbbrlns::Slightly enlarged lymph nodes with preserved hilar structure at the bilateral axillae noted, probably reactive lymph nodes.
::sbrrln::A slightly enlarged lymph node with preserved hilar structure at the right axilla noted, probably a reactive lymph node.
::sblrln::A slightly enlarged lymph node with preserved hilar structure at the left axilla noted, probably a reactive lymph node.
::sbrrlns::Slightly enlarged lymph nodes with preserved hilar structure at the right axilla noted, probably reactive lymph nodes.
::sblrlns::Slightly enlarged lymph nodes with preserved hilar structure at the left axilla noted, probably reactive lymph nodes.
::sbrlnok::Some right axillary lymph nodes with preserved hilar structure and no cortical thickening, in favor of benign nature.
::sbllnok::Some left axillary lymph nodes with preserved hilar structure and no cortical thickening, in favor of benign nature.
::sbblnok::Some bilateral axillary lymph nodes with preserved hilar structure and no cortical thickening, in favor of benign nature.
::sbblnok1::No bulky hilum absent lymph node noted at the bilateral axillae.
::sbblnok2::No definite lymphadenopathy at both axillae noted.
::sbrs::A scar at the right breast.
::sbls::A scar at the left breast.
::sbrc::Presence of an anechoic cyst at __ o'clock position of right breast, measuring about __ cm in size. Fibrocystic disease considered.
::sblc::Presence of an anechoic cyst at __ o'clock position of left breast, measuring about __ cm in size. Fibrocystic disease considered.
::sbrcs::Presence of several small anechoic cysts at right breast noted. Fibrocystic changes considered.
::sblcs::Presence of several small anechoic cysts at left breast noted. Fibrocystic changes considered.
;::sbbcs::Presence of several small anechoic cysts at bilateral breasts noted. Fibrocystic changes considered.
::sbbhen::Several small hypoechoic nodular lesions at the bilateral breasts, probably benign.
::sblhen::Several small hypoechoic nodular lesions at the left breast, probably benign.
::sbrhen::Several small hypoechoic nodular lesions at the right breast, probably benign.
::sbbcs::Several small anechoic or hypoechoic nodular lesions in the bilateral breasts, probably fibrocystic changes.
::sbbcs1::Several small anechoic or hypoechoic lesions in the bilateral breasts, probably fibrocysts and/or fibroadenomas.
::sbbcs2::Several small anechoic or hypoechoic lesions in the bilateral breasts, probably fibrocysts and/or fibroadenomas. The largest one is about `
::sbbcs3::Fibrocystic changes over the bilateral breasts.
::sbbcsfas::Small fibrocysts and fibroadenomas in the bilateral breasts, size up to  cm.{Left 4}
::sblcsfas::Small fibrocysts and fibroadenomas in the left breast, size up to __ cm.
::sbrcsfas::Small fibrocysts and fibroadenomas in the right breast, size up to __ cm.
::sbbd::Mild dilatation of the lactiferous ducts in the bilateral breasts.
::sbrd::Mild dilatation of the lactiferous ducts in the right breast.
::sbld::Mild dilatation of the lactiferous ducts in the left breast.
::sbb1::ACR-BIRADS 5th ed., category 1. Negative.
::sbb2::ACR-BIRADS 5th ed., category 2. Follow up as routine screening is recommended.
::sbb3::ACR-BIRADS 5th ed., category 3. Probably benign. Suggest short-interval (3-6 months) follow-up.
::sbb4a::ACR-BIRADS 5th ed., category 4a. Biopsy is recommended to exclude benign-looking malignancy.
::sbb4b::ACR-BIRADS 5th ed., category 4b. Suspicious abnormality carrying intermediate probability of malignancy was noted. Biopsy recommended.
::sbb4c::ACR-BIRADS 5th ed., category 4c. Highly suspicious malignancy. Biopsy recommended.
::sbb5::ACR-BIRADS 5th ed., category 5. Highly suspicious malignancy. Biopsy recommended.
::sbb6::ACR-BIRADS 5th ed., category 6: Known biopsy-proven malignancy.
::sbrfa::Presence of an oval, smooth-bordered, hypoechoic nodular lesion, measuring about __ x __ cm in size, at __ o'clock position of right breast, __ cm from the nipple. More likely benign nature such as fibroadenoma.
::sblfa::Presence of an oval, smooth-bordered, hypoechoic nodular lesion, measuring about __ x __ cm in size, at __ o'clock position of left breast, __ cm from the nipple. More likely benign nature such as fibroadenoma.
::sbrfas::Presence of several oval, smooth-bordered, hypoechoic nodular lesions, up to __ cm in size, in the right breast. More likely benign nature such as fibroadenomas.
::sblfas::Presence of several oval, smooth-bordered, hypoechoic nodular lesions, up to __ cm in size, in the left breast. More likely benign nature such as fibroadenomas.
::sbbfas::Presence of several oval, smooth-bordered, hypoechoic nodular lesions, up to __ cm in size, in the bilateral breasts. More likely benign nature such as fibroadenomas.
::sblok::The left breast is unremarkable.
::sbrok::The right breast is unremarkable.
::sbbok::The bilateral breasts are unremarkable.
::sblok1::No focal lesion in the left breast.
::sbrok1::No focal lesion in the right breast.
::sbbok1::No focal lesion in the bilateral breasts.
::sbrl::at __ o'clock position of right breast, __ cm from the nipple.
::sbll::at __ o'clock position of left breast, __ cm from the nipple.
::sbrca::
  MyForm =
(
An irregular, hypoechoic nodule, measuring about __ cm in size, is noted at right breast, __ o'clock position / __  cm from nipple.
Relatively increased intratumoral flow noted.
Breast cancer is suspected.
)
  Paste(MyForm)
Return
::sblca::
  MyForm =
(
An irregular, hypoechoic nodule, measuring about __ cm in size, is noted at left breast, __ o'clock position / __  cm from nipple.
Relatively increased intratumoral flow noted.
Breast cancer is suspected.
)
  Paste(MyForm, false)
Return

::sbok::
  MyForm =
(
- Breast composition: a. homogeneous - fat
- Breast composition: b. homogeneous - fibroglandular
- Breast composition: c. heterogeneous
- Mass: no
- Calcifications: no
- Associated features: no
- Associated features: architectural distortion, duct changes, skin thickening, skin retraction, edema, vascularity (absent, internal, rim), elasticity
- Special cases: simple cyst, clustered microcysts, complicated cyst, mass in or on skin, foreign body (including implants), intramammary lymph node, AVM, Mondor disease, postsurgical fluid collection, fat necrosis.
)
  Paste(MyForm)
Return

::sbl::
  MyForm =
(
- Breast composition: a. homogeneous - fat
- Breast composition: b. homogeneous - fibroglandular
- Breast composition: c. heterogeneous
- Mass: no
- Mass:
--> shape: oval, round, irregular
--> margin: circumscribed, indistinct, angular, microlobulated, spiculated
--> orientation: parallel, not parallel
--> echo pattern: anechoic, hyperechoic, complex cystic/solid, hypoechoic, isoechoic, heterogeneous
--> posterior features: no features, enhancement, shadowing, combined pattern
- Calcifications: no
- Calcifications: in mass, outside mass, intraductal
- Associated features: no
- Associated features: architectural distortion, duct changes, skin thickening, skin retraction, edema, vascularity (absent, internal, rim), elasticity
- Special cases: bilateral microcysts
- Special cases: simple cyst, clustered microcysts, complicated cyst, mass in or on skin, foreign body (including implants), intramammary lymph node, AVM, Mondor disease, postsurgical fluid collection, fat necrosis.
)
  Paste(MyForm)
Return

::plo::parallel orientation
::nplo::non-parallel orientation
::mlm::microlobulated margin
::idm::indistinct margin
::ps::posterior shadowing
::pec::posterior enhancement

;; Forms
::sla::
  wb := WBGet()
  tabIframe2 := wb.document.frames["frameWork"].document.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  parsedSR := GetSonoSR_Local(AccNo)

  ;sometimes need to debug
  If (parsedSR.status.error) {
    MsgBox % parsedSR.status.message
  }

  measure := parsedSR.result
  LeftKidney := measure["kidney"]["left"] ? measure["kidney"]["left"] : "__ cm"
  RightKidney := measure["kidney"]["right"] ? measure["kidney"]["right"] : "__ cm"

  Sex := StrSplit(tabIframe2.document.getElementById("tabPatient").children(0).children(0).children(0).children(0).innerText, "/")[2]
  Prostate := measure["Prostate Vol"] ? measure["Prostate Vol"] : "__ ml"

  MyForm =
(
No obvious bulky retroperitoneal mass lesion.

Right renal size about %RightKidney%; left renal size about %LeftKidney%.
Normal size and echogenicity of bilateral kidneys without hydronephrosis nor nephrolithiasis noted.

Normal appearance of urinary bladder. No stones nor sludge is noted.

)

  If (Sex = "M") {
    MyForm .= "`nProstate volume is about " . Prostate . "."
  }

  Paste(MyForm, false)
Return

::sua::
  wb := WBGet()
  tabIframe2 := wb.document.frames["frameWork"].document.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  parsedSR := GetSonoSR_Local(AccNo)

  ;sometimes need to debug
  If (parsedSR.status.error) {
    MsgBox % parsedSR.status.message
  }

  measure := parsedSR.result
  LeftKidney := measure["kidney"]["left"] ? measure["kidney"]["left"] : "__ cm"
  RightKidney := measure["kidney"]["right"] ? measure["kidney"]["right"] : "__ cm"
  Spleen := measure["spleen"] ? measure["spleen"] : "__ cm"

  MyForm =
(
The visualized portion of pancreas is normal.

Normal liver parenchyma echo pattern without focal lesion noted.

The gallbladder is well distended with smooth wall.
No abnormal dilatation of IHDs and CBD noted.

The visualized portion of spleen is normal. Spleen size about %Spleen%.

Bilateral kidneys are normal in echogenicity.
Right kidney size about %RightKidney%; left kidney size about %LeftKidney%.
No abnormal dilatation of bilateral urinary collecting systems noted.
)

  Sleep 300 ; Probably more than enough. Depends on the system.
  Paste(MyForm)
Return

::sua0::
  MyForm =
(
Normal liver parenchyma echo pattern without focal lesion noted.

The gallbladder is well distended with smooth wall.
No abnormal dilatation of IHDs and CBD noted.

The visualized portion of spleen is normal.
The visualized portion of pancreas is normal.

Bilateral kidneys are normal in size and echogenicity.
No abnormal dilatation of bilateral urinary collecting systems noted.
)
  Paste(MyForm)
Return

::suaok::
  MyForm =
(
No focal lesion in the liver, GB, spleen, kidney, visible pancreas, and paraaortic region.
)
  Paste(MyForm)
Return

::suaok0::
  MyForm =
(
No focal lesion in upper abdomen survey, including liver, GB, spleen, kidney, and visible pancreas.
The sizes, surfaces and echo pattern of both kidneys are WNL.
)
  Paste(MyForm)
Return

::suaok1::
  MyForm =
(
No focal lesion in the liver, GB, spleen, kidney, visible pancreas, and paraaortic region.
The sizes, surfaces and echo pattern of both kidneys are WNL.
)
  Paste(MyForm)
Return

::stas::
  wb := WBGet()
  tabIframe2 := wb.document.frames["frameWork"].document.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  parsedSR := GetSonoSR_Local(AccNo)

  ;sometimes need to debug
  If (parsedSR.status.error) {
    MsgBox % parsedSR.status.message
  }

  measure := parsedSR.result
  LeftOvaryL := measure["sr_leftOvaryL"]
              ? StrSplit(measure["sr_leftOvaryL"], A_Space)[1] : "_"
  LeftOvaryW := measure["sr_leftOvaryW"]
              ? StrSplit(measure["sr_leftOvaryW"], A_Space)[1] : "_"
  LeftOvaryH := measure["sr_leftOvaryH"]
              ? StrSplit(measure["sr_leftOvaryH"], A_Space)[1] : "_"
  LeftOvaryVol := measure["sr_leftOvaryVol"]
                ? StrSplit(measure["sr_leftOvaryVol"], A_Space)[1] : "_"
  RightOvaryL := measure["sr_rightOvaryL"]
               ? StrSplit(measure["sr_rightOvaryL"], A_Space)[1] : "_"
  RightOvaryW := measure["sr_rightOvaryW"]
               ? StrSplit(measure["sr_rightOvaryW"], A_Space)[1] : "_"
  RightOvaryH := measure["sr_rightOvaryH"]
               ? StrSplit(measure["sr_rightOvaryH"], A_Space)[1] : "_"
  RightOvaryVol := measure["sr_rightOvaryVol"]
                 ? StrSplit(measure["sr_rightOvaryVol"], A_Space)[1] : "_"
  UterusL := measure["sr_UterusL"]
           ? StrSplit(measure["sr_UterusL"], A_Space)[1] : "_"
  UterusW := measure["sr_UterusW"]
           ? StrSplit(measure["sr_UterusW"], A_Space)[1] : "_"
  UterusH := measure["sr_UterusH"]
           ? StrSplit(measure["sr_UterusH"], A_Space)[1] : "_"
  UterusVol := measure["sr_UterusVol"]
             ? StrSplit(measure["sr_UterusVol"], A_Space)[1] : "_"
  Endometrium := measure["sr_Endometrium"]
               ? StrSplit(measure["sr_Endometrium"], A_Space)[1] : "_"

  ; Chief Huang seems like to use cm as unit
  If (Endometrium != "_" && StrSplit(measure["sr_Endometrium"], A_Space)[2] = "mm") {
    Endometrium := Round(Endometrium / 10, 1)
  }

  MyForm =
(
Transabdominal ultrasonography of the pelvis

Well distended bladder. No focal lesion of the UB noted.
The uterus was measured as %UterusL% x %UterusH% x %UterusW% cm in size.

The endometrium was measured about %Endometrium% cm in thickness.

The RT ovary was measured as %RightOvaryL% x %RightOvaryH% x %RightOvaryW% cm (%RightOvaryVol% ml) in size.

The LT ovary was measured as %LeftOvaryL% x %LeftOvaryH% x %LeftOvaryW% cm (%LeftOvaryVol% ml) in size.


Impression: Essentially normal study.
)
  Paste(MyForm)
Return

::scar::
  MyForm =
(
Presence of RT calcified plaques measuring up to 0. x 0. cm (length x thickness) at right __carotid bulb and extracranial ICA__ without significant luminal stenosis.
Normal RT CCA and ICA.

Presence of a calcified plaque measuring about 0. x 0. cm (length x thickness) at left __ICA orifice__ without significant luminal stenosis.
Normal left CCA and ICA.

No significant luminal stenosis.

Carotid Intima-media thickness (CIMT): right carotid 0. mm; left carotid 0. mm (referenced threshold: 0.9 mm)
)
  Paste(MyForm)
Return

::sdvt::
  MyForm =
(
There are intraluminal echogenic materials in the femoral vein to popliteal vein, with decreased blood flow, and loss of compressibility, c/w deep vein thrombosis.

The deep veins of lower limb are engorged and non-compressible, with intraluminal echogenicity and decreased blood flow, from femoral to popliteal level, c/w deep vein thrombosis.
)
  Paste(MyForm)
Return

::sdvtok::
  MyForm =
(
The deep veins of lower limb are patent, from femoral to popliteal level. No evidence of deep vein thrombosis.
)
  Paste(MyForm)
Return

::spad::
  MyForm =
(
Some calcified plaques are noted over the lower limb arteries with mild irregular luminal stenosis, suggestive of peripheral artery disease. There is no definite arterial occlusion.
)
  Paste(MyForm)
Return

::spadok::
  MyForm =
(
The major arteries of lower limb are patent, without significant luminal stenosis. The dorsalis pedis and plantar arterial flow are also detected.
)
  Paste(MyForm)
Return

; TRUS related
GetProstateVol()
{
  wb := WBGet()
  tabIframe2 := wb.document.frames["frameWork"].document.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  parsedSR := GetSonoSR_Local(AccNo)

  measure := parsedSR.result
  Prostate := measure["Prostate Vol"] ? measure["Prostate Vol"] : "__ ml"

  Return Prostate
}

::sprca::
  MyForm =
(
Presence of a focal hypoechoic nodular lesion about __ cm in diameter at the peripheral zone of __ lobe of prostate.
CA of prostate is suspected.
Further evaluation recommended.
)
  Paste(MyForm)
Return

::sprbph::
  ProstateVol := GetProstateVol()

  MyForm =
(
Nodular hyperechoic changes in the transitional zone noted. Nodular hyperplasia considered.
The prostate is measured about %ProstateVol% in volume.

Normal appearance of the seminal vesicles.
)
  Paste(MyForm)
Return

::sprok::
  ProstateVol := GetProstateVol()

  MyForm =
(
No definite focal lesion in the peripheral zone of prostate, normal appearance of the inner glands, with the prostate measured about %ProstateVol% in volume.
Normal appearance of the seminal vesicles.
)
  Paste(MyForm)
Return

::sprsp::
  MyForm =
(
Status post previous TURP with a central cleft of the prostate noted.
The prostate was measured about __ cc in volume.
)
  Paste(MyForm)
Return

::sprsok::Normal appearance of the seminal vesicles.

::ssv::
  MyForm =
(
Presence of convoluted vascular structure within bilateral hemiscrotums with back flow noted in Valsalva maneuver.
More promient of the left/right, with the vascular diameter measuring up to __ cm in diameter.
Varicoceles considered.

Normal size of the testes. Normal epididymides.
)
  Paste(MyForm)
Return

::spel::
  MyForm =
(
The maximal thickness of uterine fundus is __ cm. The uterine cervix is __ cm thick.
The endometrium was mild visible under sonography.

The volume of RT ovary is about __ ml, and LT is about __ ml.

No obvious abnormal soft tissue mass noted under the sonography.
)
  Paste(MyForm)
Return

::sdrasok::
  MyForm =
(
Color doppler evaluation measured at the segmental arteries of both kidneys shows:

Normal perfusion of bilateral renal parenchyma.
Normal size and echogenicit of both kidneys.
Normal accleration time of bilateral renal segmental arteries, measuring between 30-60 msec, with the accleration index about 410-1330 cm/s2.
No evidence of upstream renal arterial stenosis.
)
  Paste(MyForm)
Return

::sdras+::
  MyForm =
(
Color doppler evaluation measured at the segmental arteries of both kidneys shows:

Relatively prolonged accleration time of -- renal segmental arteries, measuring between 130-180 msec, with the accleration index about 90-100cm/s2. Tardus-parvus waves suspected. The possibility of ---. upstream renal arterial stenosis can not be R/O.
Suggest further evaluation.
)
  Paste(MyForm)
Return

::scduk::
  MyForm =
(
Sono CDU Kideny:

- The kidney graft is at the left iliac fossa.
- The maximum dimension of the kidney graft is about 13.4 cm.
- Mild pelvicalyceal dilation is noted.
- Increased renal cortical echogenicity. Parenchymal abnormality may be suspected. Suggest clinical correlation.
- Preserved corticomedullary differentiation.
- No hydronephrosis or peri-graft fluid collection.
- Preserved renal blood flow without significant abnormal waveform pattern noted.

IMPRESSION:
Good condition of the kidney graft.
)
  Paste(MyForm)
Return

GetRecentMammo(accno) {
  if (accno) {
    r := WinHttpRequest("http://localhost:50000/recent-mammo/" + accno, InOutData := "", InOutHeaders := "", "Timeout: 15`nNO_AUTO_REDIRECT")
    parsedResult := JSON.Load(InOutData)

    If (debug) {
      MsgBox % parsedResult.debug[1].patid
    } Else If (parsedResult.report.accno) {
      ;global prevExamDate, prevPatID
      ;prevExamDate := StrSplit(parsedResult.report.examdate, A_Space)[1]
      ;prevPatID := parsedResult.debug[1].patid
      ;prevAccNo := parsedResult.report.accno

      ;ControlGet, hFdEdit, Hwnd,, TMemo6
      ;ControlGet, hImpEdit, Hwnd,, TMemo7
      ;if (hFdEdit && hImpEdit) {
      ;new_findings_text := Edit_GetText(hFdEdit) . parsedResult.report.findings
      ;new_impression_text := Edit_GetText(hImpEdit) . parsedResult.report.impression

      Return "date: " . parsedResult.report.examdate . "; impressions: `r`n" . parsedResult.report.impression
      ;Edit_SetText(hFdEdit, new_findings_text)
      ;Edit_SetText(hImpEdit, new_impression_text)
    } Else {
      Return "nil"
    }
  }
}
