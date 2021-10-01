; Sono-guide
::0sg-ptccd::
  MyForm =
(
PTCCD is indicated and has been arranged.
)
  Paste(MyForm)
Return

::1sg-ptccd::
  FormatTime, currDateStr, L1033, M/d tt
  MyForm =
(
PTCCD was performed in %currDateStr%. A 6 Fr pigtail drain with safety lock was inserted. 10 ml of aspirated bile was collected for Lab exam.
)
  Paste(MyForm)
Return

::sg-ptccd::
  MyForm =
(
Under sonography guidance, the gallbladder was localized.
The skin was prepared and the area was draped.
After local anesthesia, a 6 Fr one-step pigtail catheter (with string lock) was placed transhepatically into the gallbladder.
After local anesthesia, a 18G Chiba needle was introduced transhepatically into the gallbladder, followed by J-curve guiding wire, and a 6Fr pigtail catheter was placed using Seldinger technique.

Dark green, mucinous fluid was aspirated and collected for examination.
Brown, sandy, mucinous, pus like fluid was aspirated and collected for examination.

The fluoroscopy confirmed the drain's location. Then, the drain was fixed with Nylon.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
PTCCD was done.
)
  Paste(MyForm)
Return

:*:sg-a::
  MyForm =
(
Under sonography guidance, ascites was noted in RLQ of abdomen.
The skin was prepared and the area was draped.
Under local anesthesia, a 6 Fr pigtail catheter, using Seldinger technique, was placed into the peritoneal cavity.
Light yellow, serous fluid was aspirated and collected for Lab examination.
Then, the drain was fixed with 3-0 Nylon.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Percutaneous drainage for ascites was performed.
)
  Paste(MyForm)
Return

:*:sg-rpig::
  MyForm =
(
Under sonography guidance, pleural effusion and lung atelectasis were noted in right chest.
The skin was prepared and the area was draped.
Under local anesthesia, a 8 Fr pigtail catheter, using Seldinger technique, was placed through intercostal space into the pleural cavity.
Light yellow, serous fluid was aspirated.
Then, the drain was fixed with Mefix.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
Return

:*:sg-lpig::
  MyForm =
(
Under sonography guidance, pleural effusion and lung atelectasis were noted in left chest.
The skin was prepared and the area was draped.
Under local anesthesia, a 8 Fr pigtail catheter, using Seldinger technique, was placed through intercostal space into the pleural cavity.
Light yellow, serous fluid was aspirated.
Then, the drain was fixed with Mefix.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
Return

:*:sg-bpig::
  MyForm =
(
Under sonography guidance, pleural effusion and lung atelectasis were noted in bilateral chests.
The skin was prepared and the area was draped.
Under local anesthesia, a 8 Fr pigtail catheter, using Seldinger technique, was placed through intercostal space into the right pleural cavity.
Light yellow, serous fluid was aspirated.
The drain was fixed with Mefix.

Then, the same procedure was performed at left side.

The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
Return

:*:sg-npig::
  MyForm =
(
Due to the small amount of right/left side pleural effusion(<2cm thickness), pigtail drainage was not recommended.
)
  Paste(MyForm)
Return

:*:sg-lpb::
  MyForm =
(
The skin was prepared, the area was draped, and the rectum was filled with Povidone.
Under sonography guidance, the hypoechoic tumor was localized at left lobe of prostate.
A 18G biopsy needle was used and 12 pieces of specimen (3 from the tumor, 3 from left lobe, 6 from right lobe) were harvested.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
Return

:*:sg-rpb::
  MyForm =
(
The skin was prepared, the area was draped, and the rectum was filled with Povidone.
Under sonography guidance, the hypoechoic tumor was localized at right lobe of prostate.
A 18G biopsy needle was used and 12 pieces of specimen (3 from the tumor, 3 from right lobe, 6 from left lobe) were harvested.
The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
Return

:*:sg-lb::
  MyForm =
(
Sono-Guiding Liver Biopsy:

Biopsy region: Left lobe
Biopsy procedure: freehand technique, guided by 4C convex transducer
Biopsy device: 18G Merit Temno biopsy device in 17G coaxial needle.
Biopsy device: 18G Merit Temno biopsy device.
Number of core samples: 4
Use of Gelfoam slurry: yes
Complication: nil
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding liver biopsy was successfully performed.
)
  Paste(MyForm)
Return

:*:0sg-ld::Percutaneous drainage for liver abscess has been arranged.

:*:sg-ld::
  MyForm =
(
Under sonography guidance, the hypoechoic lesion was localized at S4 of liver.
The skin was prepared and the area was draped.
After local anesthesia, a 6 Fr one-step pigtail catheter (without safety lock) was placed transhepatically into the abscess.
Milky pus about 10 ml was aspirated. (10 ml was collected for Lab study.)
Then, the drain was fixed with 3-0 Nylon.

After local anesthesia, a 18G Chiba needle was introduced transhepatically into the abscess, followed by J-curve guiding wire.
Milky pus about 4 ml was aspirated. (collected for Lab study.)
A 6Fr pigtail catheter was placed using Seldinger technique. The fluoroscopy confirmed the drain's location.
Then, the drain was fixed with 3-0 Nylon.

The whole procedure was smooth, the patient tolerated well, and no immediate complication was noted.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Percutaneous drain for liver abscess was performed.
)
  Paste(MyForm)
Return

:*:sg-bb::
  MyForm =
(
Sono-Guiding Breast Biopsy:

Biopsy region: Left 2/0
Biopsy procedure: freehand technique, guided by 10-MHz linear array transducer
Biopsy device: 16G BARD MAX-CORE Disposable Core Biopsy Instrument.
Biopsy device: 14G BARD MAX-CORE Disposable Core Biopsy Instrument.
Biopsy device: 16G Merit Temno biopsy device in 15G coaxial needle.
Number of core samples: 4
Complication: nil
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding breast biopsy was successfully performed.
)
  Paste(MyForm)
Return

:*:sg-kb::
  MyForm =
(
Sono-Guiding Kidney Biopsy:

Biopsy region: Graft kidney at right iliac fossa, upper portion, cortex. corticomedullary junction.
Biopsy procedure: freehand technique, guided by 3.5-MHz convex probe
Biopsy device: 17G coaxial needle, 18G Temno Biopsy Device
Number of samples: 3 (1 immersed in normal saline, and the other 2 in Formalin.)
Number of samples: 4 (1 immersed in normal saline, 1 in electron microscope preservation fluid, and the other 2 in Formalin.)
Embolization: Yes, Gelfoam slurry
Complication: nil
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding kidney biopsy was successfully performed.
)
  Paste(MyForm)
Return

:*:sg-ta::
  MyForm =
(
Sono-Guiding Fine Needle Aspiration of Thyroid:

Under sonography, the mass lesion was identified at the left/right thyroid lobe.
Fine needle aspiration was then performed.
About 30 ml of light brown serous fluid was aspirated.
The sample was smeared and fixed.
The sample was injected into the thin layer cytology fluid.
The patient tolerated wall, and no immediate complication was noted.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding find needle aspiration of thyroid was successfully performed.
)
  Paste(MyForm)
Return

:*:sg-lnb::
  MyForm =
(
Sono-Guiding Lymph Node Biopsy:

Biopsy region: Left axillary
Biopsy procedure: freehand technique, guided by 10-MHz linear array transducer
Biopsy device: 18G Merit Temno biopsy device in 17G coaxial needle.
Biopsy device: 18G Merit Temno biopsy device.
Number of core samples: 4
Complication: nil
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding lymph node biopsy was successfully performed.
)
  Paste(MyForm)
Return

:*:sg-lna::
  MyForm =
(
Sono-Guiding Fine Needle Aspiration of Lymph Node:

Under sonography, the mass lesion was identified at the left/right neck.
Fine needle aspiration was then performed.
The sample was smeared and fixed.
The patient tolerated wall, and no immediate complication was noted.
)
  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Sono-guiding find needle aspiration of lymph node was successfully performed.
)
  Paste(MyForm)
Return
