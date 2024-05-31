::b::bilateral `
::lt::left `
::rt::right `
::ifo::in favor of `
::mfo::more favor of `
::acw::as compared with `
::acwpi::as compared with the previous images, `
::cpf::compression fracture
::vcpf::vertebral compression fracture
::cmf::comminuted fracture `
::bfr::burst fracture `
::cal::calcification
:c:mcal::microcalcification
:c:Mcal::macrocalcification
::si::(Srs/Img: ){Left}
::sao::small amount of `
::smao::small to moderate amount of `
::mao::moderate amount of `
::lao::large amount of `
::ntbd::nature to be determined
::stbd::significance to be determined
::ctbd::cause to be determined
::otbd::origin to be determined
::het::heterogeneous `
::hom::homogenous `
::p::presence of `
::h::however, `
::t::tiny `
::r::residual `
::reg::regular `
::ireg::irregular `
::i::increased `
::d::decreased `
::e::enhancement
::ec::enhancing `
::rec::recurrence
::ret::retention
:c:imp::improvement
::imp2::As aforementioned.
::impd::improved
::w::with `
::wo::without `
::woo::without obvious `
::wos::without significant `
::wod::without definite `
::esp::especially `
::asp::aspiration
::cw::consistent with `
::ow::otherwise, `
::rm::remarkable `
::urm::unremarkable
::cnbd::cannot be determined
::cnbe::cannot be excluded
::cnbte::cannot be totally excluded
::sbe::should be excluded
::mbs::may be suspected
::mabs::may also be suspected
::mcnbe::malignancy cannot be excluded.
::msbe::malignancy should be excluded.
::m::multiple `
::mf::multifocal `
::ml::multilocular `
::mp::most prominent at `
::af::a few `
::s::several `
::n::nodule
::nr::nodular `
::lr::linear `
::sn::solid nodule
::psn::part-solid nodule
::cn::calcified nodule
::cg::calcified granuloma
::rol::radiopaque lesion
::o::opacity
::g::granuloma
::gl::gland
::l::lesion
::nl::nodular lesion
::cl::cystic lesion
::cdl::consolidative lesion
::mod::moderate `
::sv::severe `
::stm::small to moderate `
::mtm::mild to moderate `
::mts::moderate to severe `
::sl::slightly `
::sip::superimposed `
::pos::position
::pd::progressive disease
::sd::stable disease
::pr::partial response
::cr::complete response
::ap::arterial phase
::pvp::portal venous phase
::dp::delayed phase
::pvdp::portal venous and delayed phases
::ep::equilibrium phase
::hbp::hepatobiliary phase
::bd::bone density
::ndlg::Nearly dislodgement is considered.
::eva::evaluation
::fb::foreign body
::hd::high density
::ld::low density
::pbi::previous brain insults
::pii::previous ischemic insults
::ech::edematous change
::sps::spinal stenosis
::sps0::mild indentation on anterior dural sac
::csps::central spinal stenosis
::nfs::neuroforaminal stenosis
::snfs::spinal and neuroforaminal stenosis
::lrn::lateral recess narrowing
::vp::vacuum phenomenon
::smn::Schmorl's node
::att::attenuation
::d-::density
::pcm::parenchyma
::pnb::pneumobilia
::sta::stationary
::gsta::grossly stationary
::oh::obstructive hydrocephalus
::cex::contrast medium extravasation
::woc::without IV contrast medium
::wowc::without and with IV contrast medium
::pvfs::perivesical fat stranding
::cpd::chronic parenchymal disease
::aw::abdominal wall
::um::uterine myoma
::pbv::peribronchovascular
::ivd::intervertebral disc
::vd::varying degree of `
::vs::varying sized `
::ltls::lower T- to L-spine
::ije::increased joint effusion
::mije::mildly increased joint effusion
::ijbe::increased joint and bursal effusion
::mijbe::mildly increased joint and bursal effusion

::pl::possibly `
::pb::probably `
::sf::suspicious for `
::ll::less likely

:c:f::findings

;:c:IND::INDICATION: `
:c:IND::
  Send INDICATION: ^!i
Return
;:c:IND::
;  tmpClip := ClipboardAll
;  str := "INDICATION: "
;  o := GetObjectiveFromRIS()
;  If (RegExMatch(o, "檢查目的：(.+)", SubPat)) {
;    str .= Trim(SubPat1)
;  }
;  Paste(str)
;  Sleep 300
;  Clipboard := tmpClip
;Return

;:c:CMP::COMPARISON: `
:c:CMP::
  Send COMPARISON: ^!d
Return
:c:IM::IMPRESSION:`n
:c:IM2::IMPRESSION:`nAs aforementioned.
:c:SG::SUGGESTION:`n
:c:FD::FINDINGS:
::ci::clinical information: `

; recommendations
::sg::suggest
::cc::Suggest clinical correlation.
::cc0::clinical correlation
::fe::Suggest further evaluation.
::fe0::further evaluation
::feci::Suggest further evaluation if clinically indicated.
::fu::Suggest follow-up.
::cfu::Suggest close follow-up.
::fu0::follow-up
::ccfu::Suggest clinical correlation and follow-up.
::fufe::Suggest follow-up or further evaluation.
::cpes::Suggest correlate with panendoscopy.
::csono::Suggest correlate with sonography.
::ccsono::Suggest clinical and sonographic correlation.
::ctrus::Suggest correlate with transrectal ultrasonography.
::cdsa::Suggest correlate with DSA.
::clab::Suggest correlate with Lab data.
::coi::Suggest correlate with other imaging modality.
::cbs::Suggest correlate with bone scan.
::cercp::Suggest correlate with ERCP.
::cmrcp::Suggest correlate with MRCP.
::sgyn::Suggest GYN check-up.
::cgynsono::Suggest GYN check-up and sonographic correlation.
::scmp::Suggest compare with previous images if available.
::slr3::Suggest repeat or alternative diagnostic imaging 3-6 months later.
::slr4::Suggest multidisciplinary discussion for tailored workup (may include biopsy).
::sop::Suggest correlate with OP history.
::sfna::Suggest FNA.

;; Limitations
::olnd::However, the obstruction level cannot be demonstrated in this study.
::tstc::too small to categorize
::motion::* Obvious motion artifacts may limit the interpretation.
::mart::* Obvious metallic artifact may limit the evaluation.
::ubl::(* Limited evaluation due to collapsed UB.)
::gil::(* limited evaluation due to peristalsis, susceptibility artifact from gas, etc.)
::ncl::
  MyForm =
(
* The evaluation is limited due to absence of contrast enhancement, especially for solid organs and vascular structure.
* The detection of tiny or occult metastasis is limited due to absence of contrast enhancement.
* The detection of tiny or occult residual/recurrent tumor and the evaluation of vascular structure are limited due to absence of contrast enhancement.
)
  Paste(MyForm)
Return

::sgo::suggestive of `
::obv::obvious `
::sig::significant `
::nob::no obvious `
::nobl::no obviously `
::nod::no definite `
::noe::no evident `
::nos::no significant `
::nosa::no significant abnormality
::noa::no abnormal `
::hyperi::hyperintensity
::hypoi::hypointensity
::isoi::isointensity
::isig::intermediate signal intensity
::T1h::T1 hyperintensity
::T1l::T1 hypointensity
::T2h::T2 hyperintensity
::T2l::T2 hypointensity
::hyperd::hyperdense `
::hypod::hypodense `
::isod::isodense `
::hia::high-attenuation `
::loa::low-attenuation `
::ae::arterial enhancement
::hypere::hyperechoic
::isoe::isoechoic
::hypoe::hypoechoic
:c:fd::filling defect
::pg::progression
::pgv::progressive
::rg::regression
::rgv::regressive
::csd::considered
::spd::suspected
::sp::suspicious `
::ic::inflammatory change
::infl::inflammation
::cd::consolidation
::cdv::consolidative `
::nc::noncontrast-enhanced study
::ce::contrast-enhanced study
::sc::surgical clips
::ss::surgical staples
::mrt::more on right side
::mlt::more on left side
::adj::adjacent `
::std::soft tissue density
::stdl::soft tissue density lesion
::sol::space-occupying lesion
::ddx::differential diagnoses
::nd::newly developed `
::ws::wedge-shaped `
::wr::wedge resection
::ift::infiltration
::ifm::inflammation
::me::mediastinal `
::men::mediastinum
::fa::fibroadenoma
::fac::fluid accumulation
::fc::fluid collection
::fs::fat stranding
::hop::hollow organ perforation
::nrf::No remarkable finding.
::us::unspecific
::usf::unspecific finding
::ol::obstruction level
::tz::transitional zone
::nobs::nonobstructive `
::obs::obstruction
::hypoec::hypo-enhanced `
::hyperec::hyper-enhanced `
::pce::post-contrast enhancement
::fl::fatty liver
::mfl::mild fatty liver
::mfl1::mild fatty liver without focal lesion.
::sfl::severe fatty liver
::sfl1::severe fatty liver with focal fatty sparing around the GB fossa.
::duf::degenerative uterine fibroid
::eso::esophagus
::gd::The greatest dimension is about  cm.{Left 4}
::pvs::(Previously,  mm.){Left 5}
::abn::abnormal `
::sb::small bowel
::div::diverticula
::elg::enlargement
::elgd::enlarged
::pci::postcontrast images
::bdl::borderline `
::bsmg::borderline splenomegaly
:c:ls::luminal stenosis
::ada::as detailed above
::ntn::not true nodule
::wofl::without focal lesion
::vrt::3D VRT reconstruction
::iev::in the extension view
::ifv::in the flexion view
:c:Cs::C-spine
:c:Ts::T-spine
:c:Ls::L-spine
::stcs::Straight C-spine.
::lkup::upper portion of left kidney
::lklp::lower portion of left kidney
::rkup::upper portion of right kidney
::rklp::lower portion of right kidney
::md::maximum diameter
::msag::(measured in the sagittal view)
::mcor::(measured in the coronal view)

::fn::FOOTNOTE:{Enter}[{^}1]: `

::ar::
  FormatTime, currDateStr, L1033, yyyy/M/d
  MyForm =
(
----
Additional report on %currDateStr%:


)
  Paste(MyForm)
Return

; common hotstrings
::rcs::renal cysts
::rcs1::renal cysts, size up to `
::rss::renal stones
::lrc::A -cm renal cyst at the left kidney.
::rrc::A -cm renal cyst at the right kidney.
::srcs::Some small renal cysts in both kidneys.
::shcs::Some small hepatic cysts.
::fcs::fibrocysts

; 資源共享
::share::
  MyForm =
(
The study has been uploaded to our PACS system.
Original report has been attached as a picture file.
For second opinion, please submit a formal consultation request to our department.

IMPRESSION:
The study has been uploaded to our PACS system.
)
  Paste(MyForm)
Return