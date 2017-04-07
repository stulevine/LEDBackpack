## LEDBackpack Swift Driver

### To clone this repo on your respberry pi with LEDBackpack: 
`git clone --recursive git@github.com:stulevine/LEDBackpack.git`
### Details:
* Swift 3 driver and example for the [Adafruit Bicolor 8x8 I2C LED Backpack](https://www.adafruit.com/products/902)
* Requires the [SMBus-swift](https://github.com/Sephiroth87) library written by Fabio Ritrovato
* The ∏ generation and display app (Pi.swift) requires [BigInt library](https://github.com/lorentey/BigInt), as well as the [SipHash library](https://github.com/lorentey/SipHash) written by Károly Lőrentey - make sure to run the shell script 'raspberryPiPatch.sh' in the libs directory before attempting to build since swift on Raspberry Pi does not yet have support for the Package Manager.
* Hooked up to my Raspberry Pi Zero W with Swift 3.0.2 installed from [www.uraimo.com](https://www.uraimo.com/2016/12/30/Swift-3-0-2-for-raspberrypi-zero-1-2-3/).
* Uses Coroutine.swift class from [Jaden Geller](https://github.com/JadenGeller/Yield) that has been converted to Swift 3 syntax
* Uses [Bill Abt](https://github.com/IBM-Swift/BlueSignals) Signals.swift
* To build the LEDFun app in the video below, run the buildLEDFun.sh script
* To build the Pi app, run the buildPi.sh script
* Here's a quick demo video:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=636hou_Y_Fg
" target="_blank"><img src="http://img.youtube.com/vi/636hou_Y_Fg/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="480" height="360" border="10" /></a>
