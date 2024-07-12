; For CXR
;; Protocol
::/c::PA view of the Chest:{Enter 2}
::/cl::PA and Lat views of the Chest:{Enter 2}
::/ca::AP view of the Chest:{Enter 2}

::nall::No active lung lesion.
::ncm::No cardiomegaly.
::bcm::Borderline cardiomegaly.
::bcms::Borderline enlarged cardiac shadow, possibly supine position related.
::cm::cardiomegaly.
::cm1::enlarged cardiac shadow.
::cm2::Enlarged cardiac shadow. However, it could be due to supine.
::np::No abnormal patch opacity in lung fields.
::nn::No nodular opacities (> 1cm) noted over bilateral lung fields.
::cpok::Bilateral CP angles are clear and sharp.

::0::
  MyForm =
(
Chest film:
Normal heart size.
No active lung lesions.
Normal hili.
Normal bony thorax.

Impression:
Normal heart and lungs. 胸部X光判讀正常.
)
  Paste(MyForm)
Return

::1::
  MyForm =
(
- The heart size is normal.
- No specific finding in the bilateral lung fields.
- Bilateral CP angles are clear and sharp.
- The thoracic cage and bones are generally intact.

)

  Paste(MyForm)
Return

::11::
  MyForm =
(
- The heart size is normal.
- No specific finding in the bilateral lung fields.
- Bilateral CP angles are clear and sharp.

)

  Paste(MyForm)
Return

::111::
  MyForm =
(
No abnormal patch opacity in lung fields.
No cardiomegaly.
Bilateral CP angles are clear and sharp.
The thoracic cage and bones are generally intact.

)

  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Normal chest X-ray.
)
  Paste(MyForm)
  SleepThenTab()
Return

::selm1::
  MyForm =
(
Slightly exaggerated lung markings.
Bilateral CP angles are clear and sharp.
The heart size is normal.
The thoracic cage and bones are generally intact.

)

  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
As the above descriptions.

)
  Paste(MyForm)
Return

::ii1::
  MyForm =
(
Slightly enlarged cardiac shadow.
Exaggerated lung markings at bilateral lowers, may be due to insufficient inspiration. Suggest clinical correlation.


IMPRESSION:
Insufficient inspiration related findings.

)
  Paste(MyForm)
Return

::ii2::
  MyForm =
(
Slightly enlarged cardiac shadow.
Exaggerated lung markings at bilateral lowers, may be due to insufficient inspiration and/or supine. Suggest clinical correlation.


IMPRESSION:
Insufficient inspiration and/or supine related findings.

)
  Paste(MyForm)
Return

::2::Increased linear opacity over bilateral lower lungs, in favor of chronic inflammatory change. {Enter}No cardiomegaly.+{Tab}No active lung lesion.
::3::No abnormal patch opacity in lung fields.{Enter}No cardiomegaly.{Enter}The bowel gas pattern is normal.+{Tab}Normal.
::4::Increased linear opacity and peribronchial thickening over bilateral lung fields, r/o bronchiolitis.{Enter}No cardiomegaly.+{Tab}Suspicious bronchiolitis.
::clnic::The condition of lung shows no obvious change as compared with previous study.
::clat::Suggest correlation with lateral view.
::ett0::On endotracheal tube.
::ett::On endotracheal tube with tip at proper location.
::ett-c::On endotracheal tube. The tip is near the carina. Suggest adjusting the depth.
::ett-b::On endotracheal tube. The tip is in right main bronchus. Suggest adjusting the depth.
::ett-t::On endotracheal tube. The tip is in the upper trachea. Suggest adjusting the depth.
::tr::On tracheostomy tube.
::ng::On NG tube.
::og::On NG/OG tube.
::vps::s/p VP shunting.
::lps::s/p LP shunting.
::rpig::s/p right chest pigtail drainage.
::rpig1::s/p right chest pigtail drainage, with decreased pleural effusion.
::lpig::s/p left chest pigtail drainage.
::lpig1::s/p left chest pigtail drainage, with decreased pleural effusion.
::bpig::s/p bilateral chest pigtail drainage.
::bpig1::s/p bilateral chest pigtail drainage, with decreased pleural effusion.
::elm::Exaggerated lung markings.
::selm::Slightly exaggerated lung markings.
::lop0::s/p instrument fixation of L-spine.
::lple::Left costophrenic angle blunting, suspect pleural effusion or changes.
::lple1::Left costophrenic angle blunting and diffuse ground glass opacity in left lung, suspect pleural effusion.
::rple::Right costophrenic angle blunting, suspect pleural effusion or changes.
::rple1::Right costophrenic angle blunting and diffuse ground glass opacity in right lung, suspect pleural effusion.
::bple::Bilateral costophrenic angles blunting, suspect pleural effusion or changes.
::mbple::Mild bilateral costophrenic angles blunting, suspect mild pleural effusion or changes.
::bple0::Bilateral costophrenic angles blunting, suspect pleural effusion.
::mbple0::Mild bilateral costophrenic angles blunting, suspect mild pleural effusion.
::bple1::Bilateral costophrenic angles blunting and diffuse ground glass opacity in both lungs, suspect pleural effusion.
::mbple1::Mild bilateral costophrenic angles blunting and diffuse ground glass opacity in both lungs, suspect mild pleural effusion.
::bple2::Diffuse ground glass opacity in both lungs with supine position, suspect pleural effusion.
::mbple2::Mild diffuse ground glass opacity in both lungs with supine position, suspect mild pleural effusion.
::spster::Post median sternotomy with wire fixation.
::spster1::Post median sternotomy with wire fixation. Several drains in the thorax.
::spc::Surgical clips at RUQ of abdomen, in favor of post cholecystectomy.
::spc0::S/P cholecystectomy.
::spc1::S/P cholecystectomy, with mild secondary dilatation of the biliary tract.
::sph0::S/P hysterectomy.
::sptae::Lipiodol retention in the liver, probably due to previous TACE.
::p/tae::Lipiodol retention in liver.
::ricvp::On central venous catheter via right internal jugular vein with tip at superior vena cava.
::licvp::On central venous catheter via left internal jugular vein with tip at superior vena cava.
::bicvp::On central venous catheters via right and left internal jugular veins with tips at superior vena cava.
::rscvp::On central venous catheter via right subclavian vein with tip at superior vena cava.
::lscvp::On central venous catheter via left subclavian vein with tip at superior vena cava.
::ridl::On double lumen catheter via right internal jugular vein.
::lidl::On double lumen catheter via left internal jugular vein.
::rsdl::On double lumen catheter via right subclavian vein.
::lsdl::On double lumen catheter via left subclavian vein.
::sppok::s/p chemo port implantation, without immediate complication.
::rport::s/p chemo port implantation via right subclavian vein.
::rport1::s/p chemo port implantation via right subclavian vein with tip at the SVC.
::riport::s/p chemo port implantation via right internal jugular vein.
::lport::s/p chemo port implantation via left subclavian vein.
::lport1::s/p chemo port implantation via left subclavian vein with tip at the SVC.
::liport::s/p chemo port implantation via left internal jugular vein.
::lipport::s/p IP chemo port implantation at LUQ of abdomen.
::ripport::s/p IP chemo port implantation at RUQ of abdomen.
::rsperm::On Permcath via right subclavian vein.
::lsperm::On Permcath catheter via left subclavian vein.
::riperm::On Permcath catheter via right internal jugular vein.
::liperm::On Permcath catheter via left internal jugular vein.
::rpicc::On PICC via right arm.
::lpicc::On PICC via left arm.
::spppm::s/p PPM implantation.
::rppm::s/p PPM implantation at right upper chest with lead tips in the RA and RV.
::rsppm::s/p PPM implantation at right upper chest with lead tip in the RV.
::lppm::s/p PPM implantation at left upper chest with lead tips in the RA and RV.
::lsppm::s/p PPM implantation at left upper chest with lead tip in the RV.
::rppm0::s/p PPM implantation at right upper chest.
::rsppm0::s/p PPM implantation at right upper chest.
::lppm0::s/p PPM implantation at left upper chest.
::lsppm0::s/p PPM implantation at left upper chest.
::ldbs::s/p deep brain stimulation device implantation at the left chest.
::rdbs::s/p deep brain stimulation device implantation at the right chest.
::ile::Insufficient inspiration crowds lung markings.
::pe::Increased vascular markings and ill-defined vascular contours indicating pulmonary edema.
::mpe::Mildly increased vascular markings and ill-defined vascular contours indicating mild pulmonary edema.
::pe0::pulmonary edema
::mpe0::mild pulmonary edema
::clc::Increased interstitial markings over bilateral lower lung fields, in favor of chronic inflammatory change.
::lla::Linear atelectasis of left lower lung.
::rla::Linear atelectasis of right lower lung.
::bla::Linear atelectasis of bilateral lower lungs.
::plef::pleural effusion
::inef::interlobar effusion
::pcef::pericardial effusion
::xpcef::Enlarged cardiac shadow with water bottle configuration. Pericardial effusion may be suspected.
::iabp::On IABP, with tip in the thoracic aorta.
::mssl0::Mild spondylosis and scoliosis of L-spine.
::ssl0::Spondylosis and scoliosis of L-spine.
::sl0::Scoliosis of L-spine.
::sll::Scoliosis of L-spine with convexity to the left.
::slr::Scoliosis of L-spine with convexity to the right.
::msl0::Mild scoliosis of L-spine.
::msll::Mild scoliosis of L-spine with convexity to the left.
::mslr::Mild scoliosis of L-spine with convexity to the right.
::mss0::Mild spondylosis and scoliosis.
::msst0::Mild spondylosis and scoliosis of T-spine.
::sst0::Spondylosis and scoliosis of T-spine.
::st0::Scoliosis of T-spine.
::stl::Scoliosis of T-spine with convexity to the left.
::str::Scoliosis of T-spine with convexity to the right.
::mst0::Mild scoliosis of T-spine.
::mstl::Mild scoliosis of T-spine with convexity to the left.
::mstr::Mild scoliosis of T-spine with convexity to the right.
::sstl0::Spondylosis and scoliosis of T- and L-spine.
::msstl0::Mild spondylosis and scoliosis of T- and L-spine.
::stl0::Scoliosis of T- and L-spine.
::mstl0::Mild scoliosis of T- and L-spine.
::pi::ill-defined pulmonary infiltration over `
::pi0::pulmonary infiltration
::po::patchy opacity
::no::nodular opacity
::lo::linear opacity
::flo::fibrolinear opacities
::buflo::Fibrolinear opacities over bilateral upper lung fields, in favor of chronic inflammatory change.
::ruflo::Fibrolinear opacities over right upper lung field, in favor of chronic inflammatory change.
::luflo::Fibrolinear opacities over left upper lung field, in favor of chronic inflammatory change.
::baflo::Fibrolinear opacities over bilateral apical lung fields, in favor of chronic inflammatory change.
::raflo::Fibrolinear opacities over right apical lung field, in favor of chronic inflammatory change.
::laflo::Fibrolinear opacities over left apical lung field, in favor of chronic inflammatory change.
::fno::fibronodular opacities
::fnl::fibronodular lesions
::rno::reticulonodular opacities
::bafno::Fibronodular opacities over bilateral apical lung fields, in favor of chronic inflammatory change.
::rafno::Fibronodular opacities over right apical lung fields, in favor of chronic inflammatory change.
::lafno::Fibronodular opacities over left apical lung fields, in favor of chronic inflammatory change.
::bufno::Fibronodular opacities over bilateral upper lung fields, in favor of chronic inflammatory change.
::rufno::Fibronodular opacities over right upper lung fields, in favor of chronic inflammatory change.
::lufno::Fibronodular opacities over left upper lung fields, in favor of chronic inflammatory change.
::ip::inflammatory process
::cic::chronic inflammatory change
::cgc::chronic granulomatous change
::abg::air-bronchogram
::blf::bilateral lung fields
::llf::left lung field
::rlf::right lung field
::bulf::bilateral upper lung fields
::lulf::left upper lung field
::rulf::right upper lung field
::bllf::bilateral lower lung fields
::lllf::left lower lung field
::rllf::right lower lung field
::rll::right lower lung
::lll::left lower lung
::bll::bilateral lower lungs
::bbl::bilateral basal lungs
::rul::right upper lung
::lul::left upper lung
::bul::bilateral upper lungs
::phr::perihilar regions
::nnp::No newly developed patch opacity in lung fields.
::ii::Exaggerated lung markings at bilateral lowers, may be due to insufficient inspiration.
::ii0::insufficient inspiration
::iir::insufficient inspiration related
::rrf::Old fractures of the right ribs.
::rrf1::Fractures of the right ribs.
::lrf::Old fractures of the left ribs.
::lrf1::Fractures of the left ribs.
::brf::Old fractures of the bilateral ribs.
::brf1::Fractures of the bilateral ribs.
::rok::No evident rib fracture.
::rcf::Old fracture of the right clavicle.
::lcf::Old fracture of the left clavicle.
::sprcf::Previous fracture of the right clavicle, s/p internal fixation.
::splcf::Previous fracture of the left clavicle, s/p internal fixation.
::rdia::Elevation of the right hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::rdia0::Elevation of the right hemidiaphragm.
::ldia::Elevation of the left hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::ldia0::Elevation of the left hemidiaphragm.
::copd::Hyperinflation with flattening of the bilateral hemidiaphragms, suggestive the possibility of COPD.
::tta::Tortuous thoracic descending aorta.
::mtta::Mild tortuous thoracic descending aorta.
::bronchio::Increased linear opacity and peribronchial thickening over the bilateral lung fields, r/o bronchiolitis.
::ilo::increased linear opacity `
::ao::acinar opacity `
::ldia::Elevation of the left hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::rdia::Elevation of the right hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::id::ill-defined `
::wd::well-defined `
::luqd::A drain in the LUQ of abdomen.
::ruqd::A drain in the RUQ of abdomen.
::prrct::Post removal of right chest tube. No pneumothorax noted.
::prlct::Post removal of left chest tube. No pneumothorax noted.
::prrpg::Post removal of right pigtail drain. No pneumothorax noted.
::prlpg::Post removal of left pigtail drain. No pneumothorax noted.
::ate::atelectasis
::late::linear atelectasis
::sate::subsegmental atelectasis
::spate::subpleural atelectasis
::bsate::subsegmental atelectasis of the bilateral lower lungs.
::mrsoa::Mild OA change of the right shoulder.
::mlsoa::Mild OA change of the left shoulder.
::mbsoa::Mild OA change of the bilateral shoulders.
::rsoa::OA change of the right shoulder.
::lsoa::OA change of the left shoulder.
::bsoa::OA change of the bilateral shoulders.
::racjoa::OA change of the right acromioclavicular joint.
::mracjoa::Mild OA change of the right acromioclavicular joint.
::lacjoa::OA change of the left acromioclavicular joint.
::mlacjoa::Mild OA change of the left acromioclavicular joint.
::bacjoa::OA change of the bilateral acromioclavicular joints.
::mbacjoa::Mild OA change of the bilateral acromioclavicular joints.
::blfgs::Few tiny dense nodules over the bilateral lung fields, in favor of granulomas.
::rlfg::A small calcified nodule over the right lung field, possibly a granuloma.
::rulfg::A small calcified nodule over the right upper lung field, possibly a granuloma.
::rllfg::A small calcified nodule over the right lower lung field, possibly a granuloma.
::llfg::A small calcified nodule over the left lung field, possibly a granuloma.
::lulfg::A small calcified nodule over the left upper lung field, possibly a granuloma.
::lllfg::A small calcified nodule over the left lower lung field, possibly a granuloma.
::plbok::Post lung biopsy, and no obvious pneumothorax is noted.
::aak::Atherosclerotic change of the aortic knob.
::maak::Mild atherosclerotic change of the aortic knob.
::rci::Anterior interposition of the colon to the liver reaching the under-surface of the right hemidiaphragm.
::cpftl::Compression fracture of several lower T- and L-spine.
::mw::Mediastinal widening, possibly due to tortuosity of the thoracic aorta. Suggest clinical correlation.
::rotb::Fibrilinear and nodular opacities over right apical region, in favor of old TB.
::lotb::Fibrilinear and nodular opacities over left apical region, in favor of old TB.
::botb::Fibrilinear and nodular opacities over bilateral apical regions, in favor of old TB.
::splm::s/p left mastectomy.
::splpm::s/p left partial mastectomy.
::sprm::s/p right mastectomy.
::sprpm::s/p right partial mastectomy.
::spcs::s/p coronary stenting.
::bns::Symmetrical small nodular opacities over bilateral lower lung fields, in favor of nipple shadows.
::lns::A small nodular opacity over left lower lung field, in favor of nipple shadow.
::rns::A small nodular opacity over right lower lung field, in favor of nipple shadow.
::seg::segment
::bapt::Bilateral apical pleural thickening, in favor of chronic inflammatory change.
::mbapt::Mild bilateral apical pleural thickening, in favor of chronic inflammatory change.
::rapt::Right apical pleural thickening, in favor of chronic inflammatory change.
::lapt::Left apical pleural thickening, in favor of chronic inflammatory change.
::chok::The thoracic cage and bones are generally intact.
::wgr::wedge resection

; Neck
::croup::Presence of steeple sign and hypopharyngeal distention, c/w croup.
::nocroup::No evidence of steeple sign and hypopharyngeal distention.