#Requires AutoHotkey v2.0

#Include ..\Lib\Paste.v2.ahk

; For KUB
;; Protocol
::/k::Routine supine abdomen:{Enter 2}
::/sk::Standing abdomen radiograph:{Enter 2}
::/kd::Decubitus view of the abdomen:{Enter 2}

::nbp::Non-specific bowel gas pattern.
::k::Bowel gas pattern, kidney outlines, and psoas muscle contours are unremarkable.
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
::ks::Mottled gas pattern along the course of the colon is noted, suggestive of fecal residue retention.
::kp::Several small calcified nodules in the pelvic cavity are mostly pelvic phleboliths.
::kfn::Small oval nodules with egg-shell calcification in the pelvis, in favor of old fat necrosis.
::kgbs::A round opacity in the RUQ of abdomen, suspicious for a gallstone. Correlation with sonography is suggested.
::kgbss::Round opacities in the RUQ of abdomen, suspicious for gallstones. Correlation with sonography is suggested.
::lpcn::Status post left side percutaneous nephrostomy.
::rpcn::Status post right side percutaneous nephrostomy.
::bpcn::Status post bilateral percutaneous nephrostomies.
::rfcvp::Central venous catheter is in place via the right femoral vein.
::lfcvp::Central venous catheter is in place via the left femoral vein.
::bfcvp::Central venous catheters are in place via both femoral veins.
::ki::Prominent small bowel gas, may be due to paralytic ileus.
::ki2::Focally dilated bowel loops, probably ileus or partial bowel obstruction.
::kiafl::Mildly dilated bowel loops with several air-fluid levels, probably partial bowel obstruction or ileus.
::kbo::Markedly dilated bowel loops, suspicious for bowel obstruction.
::kmi::Mildly distended small bowel gas, may be due to mild paralytic ileus.
::rdj::Status post right side double-J ureteral stent.
::ldj::Status post left side double-J ureteral stent.
::bdj::Status post bilateral double-J ureteral stents.
::rfdl::On double-lumen catheter via right femoral vein.
::lfdl::On double-lumen catheter via left femoral vein.
::nfa::No evidence of subphrenic free air.
:c:F::Status post Foley catheterization.
:c:F1::Status post Foley catheterization. The urinary bladder is not distended enough, and the evaluation is limited.
::spiud::Status post intrauterine device implantation.
::haicok::On HAIC. The tip position shows no migration compared to the previous angiography.
::spa::Surgical clips at RLQ of abdomen, in favor of post appendectomy.
::spa0::Status post appendectomy.
::sphaic::Coils at the upper abdomen, may be due to previous hepatic arterial infusion chemotherapy.
::maacal::Mild calcification of the abdominal aortic wall.
::aacal::Calcification of the abdominal aortic wall.
::aacal1::Calcification of the abdominal aorta and its branches.
::ka::Increased opacity of the abdomen with centralization of the bowel gas, probably due to ascites.
::kc::Contrast medium retention in the urinary tract, may be due to recent imaging study.
::kns::No definite stone-like radiopacity along the urinary tract.
::kbrs::Several tiny radiopacities superimposed on bilateral renal shadows, suspicious for renal stones.
::kbrss::Several small radiopacities superimposed on bilateral renal shadows, suspicious for renal stones.
::klrs::A tiny radiopacity superimposed on the left renal shadow, suspicious for a renal stone.
::klrss::Small radiopacities superimposed on the left renal shadow, suspicious for renal stones.
::krrs::A tiny radiopacity superimposed on the right renal shadow, suspicious for a renal stone.
::krrss::Small radiopacities superimposed on the right renal shadow, suspicious for renal stones.
::klus::A small stone-like opacity at the left paraspinal region at L3 level, possibly a ureter stone.
::krus::A small stone-like opacity at the right paraspinal region at L3 level, possibly a ureter stone.
::kllus::A small stone-like opacity superimposed on the left sacral ala region, suspicious for a lower ureter stone.
::krlus::A small stone-like opacity superimposed on the right sacral ala region, possibly a lower ureter stone.
::kluvjs::A small stone-like opacity at the left side of the pelvis, possibly a UVJ stone.
::kruvjs::A small stone-like opacity at the right side of the pelvis, possibly a UVJ stone.
::kuf::Calcified nodules in the pelvis, suspicious for degenerated uterine fibroids.
::lptcd::status post PTCD via left side approach.
::rptcd::status post PTCD via right side approach.
::bptcd::status post PTCD via left and right side approach.
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

::ks1:: {
    MyForm := "
(
Mottled gas pattern along colon course is noted, implying fecal residues retention. Otherwise, the bowel gas pattern is unremarkable.
)"
    Paste(MyForm)
}

::ks2:: {
    MyForm := "
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention. Otherwise, the bowel gas pattern is unremarkable.
- Bilateral kidney shadows and psoas muscle contours are unremarkable.
)"
    Paste(MyForm)
}

::kss:: {
    MyForm := "
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention.
- The stone evaluation is limited.
)"
    Paste(MyForm)
}

::ksi:: {
    MyForm := "
(
- Mottled gas pattern along colon course is noted, implying fecal residues retention.
- Prominent small bowel gas, c/w stool impaction.
)"
    Paste(MyForm)
}

::sk:: {
    MyForm := "
(
- The bowel gas pattern, bilateral kidney shadows and psoas muscle contours are unremarkable.
- No evidence of subphrenic free air.
- No abnormal air-fluid levels in the bowel.
)"
    Paste(MyForm)
}

::nafl::No abnormal air-fluid levels in the bowel.