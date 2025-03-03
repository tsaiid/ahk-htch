; For CXR
;; Protocol
::/c::PA view of the Chest:{Enter 2}
::/cl::PA and Lat views of the Chest:{Enter 2}
::/ca::AP view of the Chest:{Enter 2}

::napd::No active pulmonary disease.
::nsll::No suspicious lung lesion.
::ncm::No cardiomegaly.
::bcm::Borderline cardiomegaly.
::bcms::Borderline enlarged cardiac shadow, possibly supine position related.
::cm::cardiomegaly.
::cm1::enlarged cardiac shadow.
::cm2::Enlarged cardiac shadow. However, it could be due to supine.
::np::No abnormal patch opacity in lung fields.
::nn::No nodular opacities (> 1cm) noted in both lung fields.
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
- No specific findings in both lung fields.
- The bilateral costophrenic angles are clear and well-defined.
- The thoracic cage and bones appear intact.


)

  Paste(MyForm)
Return

::11::
  MyForm =
(
- The heart size is normal.
- No specific findings in both lung fields.
- The bilateral costophrenic angles are clear and well-defined.


)

  Paste(MyForm)
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
Prominent lung markings at bilateral lowers, may be due to insufficient inspiration. Clinical correlation is suggested.


IMPRESSION:
Insufficient inspiration related findings.

)
  Paste(MyForm)
Return

::ii2::
  MyForm =
(
Slightly enlarged cardiac shadow.
Prominent lung markings at bilateral lowers, may be due to insufficient inspiration and/or supine. Clinical correlation is suggested.


IMPRESSION:
Insufficient inspiration and/or supine related findings.

)
  Paste(MyForm)
Return

::2::Increased linear opacity in both lower lungs, in favor of chronic inflammatory changes. {Enter}No cardiomegaly.+{Tab}No active lung lesion.
::3::No abnormal patch opacity in lung fields.{Enter}No cardiomegaly.{Enter}The bowel gas pattern is normal.+{Tab}Normal.
::4::Increased linear opacity and peribronchial thickening in both lung fields, r/o bronchiolitis.{Enter}No cardiomegaly.+{Tab}Suspicious bronchiolitis.
::clnic::The condition of lung shows no obvious changes compared to the previous study.
::clat::Correlation with lateral view is suggested.
::ett0::Endotracheal tube in place.
::ett::Endotracheal tube in place, with the tip at an appropriate position.
::ett-c::Endotracheal tube in place. The tip is near the carina. Adjusting the depth is suggested.
::ett-b::Endotracheal tube in place. The tip is in right main bronchus. Adjusting the depth is suggested.
::ett-t::Endotracheal tube in place. The tip is in the upper trachea. Adjusting the depth is suggested.
::tr::Tracheostomy tube in place.
::ng::NG tube in place.
::og::NG/OG tube in place.
::vps::Status post VP shunting.
::lps::Status post LP shunting.
::rpig::Status post right chest pigtail drainage.
::rpig1::Status post right chest pigtail drainage, with decreased pleural effusion.
::lpig::Status post left chest pigtail drainage.
::lpig1::Status post left chest pigtail drainage, with decreased pleural effusion.
::bpig::Status post bilateral chest pigtail drainage.
::bpig1::Status post bilateral chest pigtail drainage, with decreased pleural effusion.
::plm::Prominent lung markings.
::mplm::Mildly prominent lung markings.
::lop0::Status post instrument fixation of L-spine.
::lple::Blunting of the left costophrenic angle is noted, suspicious for pleural effusion or pleural thickening.
::lple1::Blunting of the left costophrenic angle and ground-glass opacities in the left lung are noted, suggestive of pleural effusion.
::rple::Blunting of the right costophrenic angle is noted, suspicious for pleural effusion or pleural thickening.
::rple1::Blunting of the right costophrenic angle and ground-glass opacities in the right lung are noted, suggestive of pleural effusion.
::bple::Bilateral costophrenic angle blunting is noted, suspicious for pleural effusion or pleural thickening.
::mbple::Mild bilateral costophrenic angle blunting is noted, suspicious for pleural effusion or pleural thickening.
::bple0::Bilateral costophrenic angle blunting is noted, suggestive of pleural effusion.
::mbple0::Mild bilateral costophrenic angle blunting is noted, suggestive of mild pleural effusion.
::bple1::Bilateral costophrenic angle blunting and diffuse ground-glass opacity in both lungs are noted, suggestive of pleural effusion.
::mbple1::Mild bilateral costophrenic angle blunting and diffuse ground-glass opacity in both lungs are noted, suggestive of mild pleural effusion.
::bple2::Diffuse ground-glass opacity in both lungs with supine position, suspect pleural effusion.
::mbple2::Mild diffuse ground-glass opacity in both lungs with supine position, suspect mild pleural effusion.
::spster::Status post median sternotomy with wire fixation.
::spster1::Status post median sternotomy with wire fixation. Several drains in the thorax.
::spc::Surgical clips at RUQ of abdomen, in favor of post cholecystectomy.
::spc0::Status post cholecystectomy.
::spc1::Status post cholecystectomy, with mild secondary dilatation of the biliary tract.
::sptae::Lipiodol retention in the liver, probably due to previous TACE.
::p/tae::Lipiodol retention in liver.
::ricvp::Central venous catheter in place via the right internal jugular vein, with the tip at the superior vena cava.
::licvp::Central venous catheter in place via the left internal jugular vein, with the tip at the superior vena cava.
::bicvp::Central venous catheters in place via both internal jugular veins, with the tips at the superior vena cava.
::rscvp::Central venous catheter in place via the right subclavian vein, with the tip at the superior vena cava.
::lscvp::Central venous catheter in place via the right subclavian vein, with the tip at the superior vena cava.
::ridl::Double-lumen catheter in place via the right internal jugular vein.
::lidl::Double-lumen catheter in place via the left internal jugular vein.
::rsdl::Double-lumen catheter in place via the right subclavian vein.
::lsdl::Double-lumen catheter in place via the left subclavian vein.
::sppok::Status post chemo port implantation, without immediate complication.
::rport::Status post chemo port implantation via right subclavian vein.
::rport1::Status post chemo port implantation via right subclavian vein with tip at the SVC.
::riport::Status post chemo port implantation via right internal jugular vein.
::lport::Status post chemo port implantation via left subclavian vein.
::lport1::Status post chemo port implantation via left subclavian vein with tip at the SVC.
::liport::Status post chemo port implantation via left internal jugular vein.
::lipport::Status post IP chemo port implantation at LUQ of abdomen.
::ripport::Status post IP chemo port implantation at RUQ of abdomen.
::rsperm::On Permcath via the right subclavian vein.
::lsperm::On Permcath catheter via the left subclavian vein.
::riperm::On Permcath catheter via the right internal jugular vein.
::liperm::On Permcath catheter via the left internal jugular vein.
::rpicc::PICC line in place via the right arm.
::lpicc::PICC line in place via the left arm.
::spppm::Status post PPM implantation.
::rppm::Status post PPM implantation at right upper chest with lead tips in the RA and RV.
::rsppm::Status post PPM implantation at right upper chest with lead tip in the RV.
::lppm::Status post PPM implantation at left upper chest with lead tips in the RA and RV.
::lsppm::Status post PPM implantation at left upper chest with lead tip in the RV.
::rppm0::Status post PPM implantation at right upper chest.
::rsppm0::Status post PPM implantation at right upper chest.
::lppm0::Status post PPM implantation at left upper chest.
::lsppm0::Status post PPM implantation at left upper chest.
::ldbs::Status post deep brain stimulation device implantation at the left chest.
::rdbs::Status post deep brain stimulation device implantation at the right chest.
::ile::Insufficient inspiration crowds lung markings.
::pe::Increased vascular markings and hazy vascular outlines, suggestive of pulmonary edema.
::mpe::Mildly increased vascular markings and hazy vascular outlines, suggestive of mild pulmonary edema.
::pe0::pulmonary edema
::mpe0::mild pulmonary edema
::clc::Increased interstitial markings in both lower lung fields, in favor of chronic inflammatory changes.
::lla::Linear atelectasis of left lower lung.
::rla::Linear atelectasis of right lower lung.
::bla::Linear atelectasis of bilateral lower lungs.
::plef::pleural effusion
::inef::interlobar effusion
::pcef::pericardial effusion
::xpcef::Enlarged cardiac shadow with water bottle configuration. Pericardial effusion may be suspected.
::iabp::On IABP, with tip in the thoracic aorta.
::mssl0::Mild spondylosis and scoliosis of the L-spine.
::ssl0::Spondylosis and scoliosis of the L-spine.
::sl0::Scoliosis of the L-spine.
::sll::Scoliosis of the L-spine with left convexity.
::slr::Scoliosis of the L-spine with right convexity.
::msl0::Mild scoliosis of the L-spine.
::msll::Mild scoliosis of the L-spine with left convexity.
::mslr::Mild scoliosis of the L-spine with right convexity.
::mss0::Mild spondylosis and scoliosis.
::msst0::Mild spondylosis and scoliosis of the T-spine.
::sst0::Spondylosis and scoliosis of the T-spine.
::st0::Scoliosis of the T-spine.
::stl::Scoliosis of the T-spine with left convexity.
::str::Scoliosis of the T-spine with right convexity.
::mst0::Mild scoliosis of the T-spine.
::mstl::Mild scoliosis of the T-spine with left convexity.
::mstr::Mild scoliosis of the T-spine with right convexity.
::sstl0::Spondylosis and scoliosis of the T- and L-spine.
::msstl0::Mild spondylosis and scoliosis of the T- and L-spine.
::stl0::Scoliosis of the T- and L-spine.
::mstl0::Mild scoliosis of the T- and L-spine.
::pi::ill-defined infiltrate in the `
::pi0::infiltrate
::po::patchy opacity
::no::nodular opacity
::lo::linear opacity
::flo::fibrolinear opacities
::buflo::Fibrolinear opacities in both upper lung fields, in favor of chronic inflammatory changes.
::ruflo::Fibrolinear opacities in the right upper lung field, in favor of chronic inflammatory changes.
::luflo::Fibrolinear opacities in the left upper lung field, in favor of chronic inflammatory changes.
::baflo::Fibrolinear opacities in both apical lung fields, in favor of chronic inflammatory changes.
::raflo::Fibrolinear opacities in the right apical lung field, in favor of chronic inflammatory changes.
::laflo::Fibrolinear opacities in the left apical lung field, in favor of chronic inflammatory changes.
::fno::fibronodular opacities
::fnl::fibronodular lesions
::rno::reticulonodular opacities
::bafno::Fibronodular opacities in both apical lung fields, in favor of chronic inflammatory changes.
::rafno::Fibronodular opacities in the right apical lung fields, in favor of chronic inflammatory changes.
::lafno::Fibronodular opacities in the left apical lung fields, in favor of chronic inflammatory changes.
::bufno::Fibronodular opacities in both upper lung fields, in favor of chronic inflammatory changes.
::rufno::Fibronodular opacities in the right upper lung fields, in favor of chronic inflammatory changes.
::lufno::Fibronodular opacities in the left upper lung fields, in favor of chronic inflammatory changes.
::ip::inflammatory process
::cic::chronic inflammatory changes
::cgc::chronic granulomatous changes
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
::rok::No obvious rib fracture.
::rcf::Old fracture of the right clavicle.
::lcf::Old fracture of the left clavicle.
::sprcf::Previous fracture of the right clavicle, status post internal fixation.
::splcf::Previous fracture of the left clavicle, status post internal fixation.
::rdia::Elevation of the right hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::rdia0::Elevation of the right hemidiaphragm.
::ldia::Elevation of the left hemidiaphragm. Phrenic nerve palsy, diaphragmatic eventration, or intraabdominal process is considered.
::ldia0::Elevation of the left hemidiaphragm.
::copd::Hyperinflation with flattening of both hemidiaphragms, suggestive the possibility of COPD.
::tta::Tortuous thoracic descending aorta.
::mtta::Mild tortuous thoracic descending aorta.
::bronchio::Increased linear opacity and peribronchial thickening over both lung fields, r/o bronchiolitis.
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
::bsate::subsegmental atelectasis of both lower lungs.
::mrsoa::Mild OA changes of the right shoulder.
::mlsoa::Mild OA changes of the left shoulder.
::mbsoa::Mild OA changes of both shoulders.
::rsoa::OA changes of the right shoulder.
::lsoa::OA changes of the left shoulder.
::bsoa::OA changes of both shoulders.
::racjoa::OA changes of the right acromioclavicular joint.
::mracjoa::Mild OA changes of the right acromioclavicular joint.
::lacjoa::OA changes of the left acromioclavicular joint.
::mlacjoa::Mild OA changes of the left acromioclavicular joint.
::bacjoa::OA changes of both acromioclavicular joints.
::mbacjoa::Mild OA changes of both acromioclavicular joints.
::blfgs::Few tiny dense nodules over both lung fields, in favor of granulomas.
::rlfg::A small calcified nodule over the right lung field, possibly a granuloma.
::rulfg::A small calcified nodule over the right upper lung field, possibly a granuloma.
::rllfg::A small calcified nodule over the right lower lung field, possibly a granuloma.
::llfg::A small calcified nodule over the left lung field, possibly a granuloma.
::lulfg::A small calcified nodule over the left upper lung field, possibly a granuloma.
::lllfg::A small calcified nodule over the left lower lung field, possibly a granuloma.
::plbok::Post lung biopsy, and no obvious pneumothorax is noted.
::aak::Atherosclerotic changes of the aortic knob.
::maak::Mild atherosclerotic changes of the aortic knob.
::rci::Anterior interposition of the colon to the liver reaching the under-surface of the right hemidiaphragm.
::cpftl::Compression fracture of several lower T- and L-spine.
::mw::Mediastinal widening, possibly due to tortuosity of the thoracic aorta. Clinical correlation is suggested.
::rotb::Fibrilinear and nodular opacities in the right apical region, in favor of old TB.
::lotb::Fibrilinear and nodular opacities in the left apical region, in favor of old TB.
::botb::Fibrilinear and nodular opacities in both apical regions, in favor of old TB.
::splm::status post left mastectomy.
::splpm::status post left partial mastectomy.
::sprm::status post right mastectomy.
::sprpm::status post right partial mastectomy.
::spcs::status post coronary stenting.
::bns::Symmetrical small nodular opacities in both lower lung fields, in favor of nipple shadows.
::lns::A small nodular opacity in the left lower lung field, in favor of nipple shadow.
::rns::A small nodular opacity in the right lower lung field, in favor of nipple shadow.
::seg::segment
::bapt::Bilateral apical pleural thickening, in favor of chronic inflammatory changes.
::mbapt::Mild bilateral apical pleural thickening, in favor of chronic inflammatory changes.
::rapt::Right apical pleural thickening, in favor of chronic inflammatory changes.
::lapt::Left apical pleural thickening, in favor of chronic inflammatory changes.
::chok::The thoracic cage and bones are generally intact.
::wgr::wedge resection

; Neck
::croup::Presence of steeple sign and hypopharyngeal distention, c/w croup.
::nocroup::No evidence of steeple sign and hypopharyngeal distention.