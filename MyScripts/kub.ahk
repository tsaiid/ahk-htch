﻿; For KUB
;; Protocol
::/k::Routine supine abdomen:{Enter 2}
::/sk::Standing abdomen radiograph:{Enter 2}
::/kd::Decubitus view of the abdomen:{Enter 2}

::nbp::Non-specific bowel gas pattern.
::k::The bowel gas pattern, bilateral kidney shadows and psoas muscle contours are unremarkable.
::kk::The bowel gas pattern is unremarkable.{Enter}No obvious bony lesion.+{Tab}The bowel gas pattern is unremarkable.
::k2::The bilateral kidney shadows are unremarkable.
::k2n::The bilateral kidney shadows are not well depicted due to bowel gas.
::k3::The psoas muscle contours are unremarkable.
::k3n::The psoas muscle contours are not well depicted.
::k23::The bilateral kidney shadows and psoas muscle contours are unremarkable.
::k23n::The bilateral kidney shadows and psoas muscle contours are not well depicted.
::kb::the bowel gas pattern is unremarkable.
::kb1::the bowel gas pattern is normal.
::kob::The other bowel gas pattern is unremarkable.
::kbok::No abnormal bowel dilatation.
::ks::Mottled gas pattern along colon course is noted, implying fecal residues retention.
::kp::Several small calcified nodules in the pelvic cavity are mostly due to phleboliths of the vein.
::kfn::Small oval nodules with egg-shell calcification in the pelvis, in favor of old fat necrosis.
::kgbs::A round opacity over RUQ of abdomen, suspicious a gallstone. Suggest correlation with sonography.
::kgbss::Round opacities over RUQ of abdomen, suspicious gallstones. Suggest correlation with sonography.
::lpcn::s/p left side percutaneous nephrostomy.
::rpcn::s/p right side percutaneous nephrostomy.
::bpcn::s/p bilateral percutaneous nephrostomies.
::rfcvp::On central venous catheter via right femoral vein.
::lfcvp::On central venous catheter via left femoral vein.
::bfcvp::On central venous catheters via bilateral femoral veins.
::ki::Obvious small bowel gas, may be due to paralytic ileus.
::ki2::Focal dilated bowel loops, probably ileus or partial bowel obstruction.
::kiafl::Mild dilated bowel loops with several air-fluid levels, probably partial bowel obstruction or ileus.
::kbo::Obvious dilated bowel loops, suspicious bowel obstruction.
::kmi::Mild distended small bowel gas, may be due to mild paralytic ileus.
::rdj::s/p right side double-J ureteral stent.
::ldj::s/p left side double-J ureteral stent.
::bdj::s/p bilateral double-J ureteral stents.
::rfdl::On double-lumen catheter via right femoral vein.
::lfdl::On double-lumen catheter via left femoral vein.
::nfa::No evidence of subphrenic free air.
:c:F::s/p Foley catheterization.
:c:F1::s/p Foley catheterization. The urinary bladder is not distended enough, and the evaluation is limited.
::spiud::s/p intrauterine device implantation.
::haicok::On HAIC. The tip position shows no migration as compared with previous angiography.
::spa::Surgical clips at RLQ of abdomen, in favor of post appendectomy.
::spa0::s/p appendectomy.
::sphaic::Coils at the upper abdomen, may be due to previous hepatic arterial infusion chemotherapy.
::maacal::Mild calcification of abdominal aortic wall.
::aacal::Calcification of abdominal aortic wall.
::aacal1::Calcification of abdominal aortic and branches wall.
::ka::Increased opacity of the abdomen with centralization of the bowel gas, probably due to ascites.
::kc::Contrast medium retention in the urinary tract, may be due to recent imaging study.
::kns::No definite stone-like radiopacity along the urinary tract.
::kbrs::Several tiny radiopacities superimposed on bilateral renal shadows, suspicious renal stones.
::kbrss::Several small radiopacities superimposed on bilateral renal shadows, suspicious renal stones.
::klrs::A tiny radiopacity superimposed on left renal shadow, suspicious a renal stone.
::klrss::Small radiopacities superimposed on left renal shadow, suspicious renal stones.
::krrs::A tiny radiopacity superimposed on right renal shadow, suspicious a renal stone.
::krrss::Small radiopacities superimposed on right renal shadow, suspicious renal stones.
::klus::A small stone-like opacity at left paraspinal region at L3 level, possibly a ureter stone.
::krus::A small stone-like opacity at right paraspinal region at L3 level, possibly a ureter stone.
::kllus::A small stone-like opacity superimposed on left sacral ala region, suspicious a lower ureter stone.
::krlus::A small stone-like opacity superimposed on right sacral ala region, possibly a lower ureter stone.
::kluvjs::A small stone-like opacity at left side of pelvis, possibly a UVJ stone.
::kruvjs::A small stone-like opacity at right side of pelvis, possibly a UVJ stone.
::kuf::Calcified nodules in the pelvis, suspicious degenerated uterine fibroids.
::lptcd::S/P PTCD via left side approach.
::rptcd::S/P PTCD via right side approach.
::bptcd::S/P PTCD via left and right side approach.
::ruq::RUQ of abdomen
::ruqw::RUQ of abdominal wall
::luq::LUQ of abdomen
::luqw::LUQ of abdominal wall
::rlq::RLQ of abdomen
::rlqw::RLQ of abdominal wall
::llq::LLQ of abdomen
::llqw::LLQ of abdominal wall
::rabd::right side of abdomen
::labd::left side of abdomen
::uabd::upper abdomen
::kis0::inspissated fecal materials
::kis::Presence of inspissated fecal material in the rectum with gaseous dilated bowel loops, probably stool impaction.
::ks1::
  MyForm =
(
Mottled gas pattern along colon course is noted, implying fecal residues retention. Otherwise, the bowel gas pattern is unremarkable.
)
  Paste(MyForm)
Return
::ks2::
  MyForm =
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention. Otherwise, the bowel gas pattern is unremarkable.
- Bilateral kidney shadows and psoas muscle contours are unremarkable.
)
  Paste(MyForm)
Return
::kss::
  MyForm =
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention.
- The stone evaluation is limited.
)
  Paste(MyForm)
Return
::ksi::
  MyForm =
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention.
- Obvious small bowel gas, c/w stool impaction.
)
  Paste(MyForm)
Return
::sk::
  MyForm =
(
- The bowel gas pattern, bilateral kidney shadows and psoas muscle contours are unremarkable.
- No evidence of subphrenic free air.
- No obvious air-fluid level in the bowel.
)
  Paste(MyForm)
Return

::nafl::No obvious air-fluid level in the bowel.