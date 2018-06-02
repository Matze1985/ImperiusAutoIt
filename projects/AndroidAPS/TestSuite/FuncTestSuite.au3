;FuncTestSuite.au3
;
;Author:
;Matze1985
;
;Description:
;TestSuite:...FuncTestSuite:
;...............- TC-Issue-880 - Dev branch - temp targets in mg/dl while rest is in mmol
;...............- TC-Issue-978 - No ExtendedBolus in AAPS
;..........................................................................................
#include <../../../imperius.au3>

#Region AUTData
Local $sAUTPath = "TestData/app-full-release.apk"
Local $sLocalPath = "TestData/info.nightscout.androidaps"
Local $sPackage = "info.nightscout.androidaps"
Local $sActivity = ".MainActivity"
Local $sResultArchiv = "Results/" & @YEAR & "-" & @MON & "-" & @MDAY & "_"
Local $sImg = ".png"
#EndRegion AUTData

#Region Suite
Local $oImperius = ImperiusServer("127.0.0.1", 3007)
Local $oDevice = $oImperius.getDevice()
Local $oLogger = $oImperius.getLogger()

; Start and ini
$oImperius.start()
$oImperius.getAdb().install($sAUTPath, 1, True) ; Install app
;$oImperius.getAdb().push($sLocalPath, "/sdcard/Android/data/" & $sPackage) ; TestSettings

; Log device
$oLogger.info("Device Name: " & $oDevice.getDeviceName())
$oLogger.info("Device Version: " & $oDevice.getDeviceVersion())
$oLogger.info("Device Manufacturer: " & $oDevice.getDeviceManufacturer())
$oLogger.info("Device Model: " & $oDevice.getDeviceModel())

Local $oTestSuite = newTestSuite("AndroidAPSFuncTestSuite")
$oTestSuite.addTest(TestTemporaryTarget($oDevice))
$oTestSuite.addTest(TestExtendedBolus($oDevice))
$oTestSuite.finish()
$oImperius.stop()
$oImperius = 0
#EndRegion Suite

#Region Tests
; Author: Matze1985
; TC-Issue-880 - Dev branch - temp targets in mg/dl while rest is in mmol.
Func TestTemporaryTarget($oDevice)
	Local $sTestCaseId = "TC-Issue-880"
	Local $oTest = newTest($sTestCaseId & " - Dev branch - temp targets in mg/dl while rest is in mmol")
	Local $fExpectedValue = 6.5
	Local $iExpectedMin = 10
	Local $iExpectedScreenMin = $iExpectedMin - 1
	With $oDevice
		.startActivity($sPackage, $sActivity)
		.click("Careportal")
		.click("Temporary Target")
		.enterText("0", $fExpectedValue)
		.enterText("1", $iExpectedMin)
		.click("OK")
		.click("OK")
		.pressBack()
     .startActivity($sPackage, $sActivity)
	EndWith
	$oTest.assertTrue("Check text for " & $fExpectedValue & " (" & $iExpectedScreenMin & "')", $oDevice.waitForTextExist($fExpectedValue & " (" & $iExpectedScreenMin & "')"))
	$oDevice.getScreenshot($sResultArchiv & $sTestCaseId & $sImg)
	Return $oTest
EndFunc   ;==>TestTemporaryTarget

; Author: Matze1985
; TC-Issue-978 - No ExtendedBolus in AAPS
Func TestExtendedBolus($oDevice)
	Local $sTestCaseId = "TC-Issue-978"
	Local $oTest = newTest($sTestCaseId & " - No ExtendedBolus in AAPS")
	Local $fExpected = 0.1
	With $oDevice
		.startActivity($sPackage, $sActivity)
		.click("Actions")
		.click("Extended Bolus")
		.enterText("0", $fExpected)
		.click("OK")
		.click("OK")
		.click("Careportal")
		.click("Treatments")
		.click("ExtendedBolus")
	EndWith
	$oTest.assertTrue("Check ExtendedBolus entry: " & $fExpected & " U", $oDevice.waitForTextExist($fExpected & " U"))
	$oDevice.getScreenshot($sResultArchiv & $sTestCaseId & $sImg)
	$oDevice.clickAndWait("Remove")
	$oDevice.clickAndWait("OK")
	Return $oTest
EndFunc   ;==>TestExtendedBolus
#EndRegion Tests