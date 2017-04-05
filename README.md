## LEDBackpack Swift Driver
* Swift 3 driver and example for the [Adafruit Bicolor 8x8 I2C LED Backpack](https://www.adafruit.com/products/902)
* Requires the [SMBus-swift](https://github.com/Sephiroth87) library written by Fabio Ritrovato
* The ∏ generation and display app (Pi.swift) requires [BigInt library](https://github.com/lorentey/BigInt), as well as the [SipHash library](https://github.com/lorentey/SipHash) written by Károly Lőrentey
* Hooked up to my Raspberry Pi Zero W with Swift 3.0.2 installed from [www.uraimo.com](https://www.uraimo.com/2016/12/30/Swift-3-0-2-for-raspberrypi-zero-1-2-3/) (these will need to be patched locally to remove the 'include' statement in order to build on the RaspberryPi using Swift 3.0.2 since it does not support the Package Manager.
* Here's a quick demo video:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=636hou_Y_Fg
" target="_blank"><img src="http://img.youtube.com/vi/636hou_Y_Fg/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="480" height="360" border="10" /></a>
