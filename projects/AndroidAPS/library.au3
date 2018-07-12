;library.au3
;
;Author:
; Matze1985
;
;Description:
; This object represents a command library for AndroidAPS.

;Function: AndroidAPSLibrary
;
;Parameters:
;	$oDevice- Object. An UiDevice instance.
;
;Returns:
;   Object. An InputsScreen instance.
Func Library($oDevice)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("pressMenuButton", "_PressMenuButton")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("oDevice", $ELSCOPE_PRIVATE, $oDevice)
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>InputsScreen

#Region Methods
;Function: _PressMenuButton
;Press the menu button in overview.
;
;Parameters:
;   $oSelf - Object reference.
;
;Example:
; 	In TestCase:
;		Local $oLibrary = Library($oDevice)
;
;	In TestStep:
;		$oLibrary.pressMenuButton()
Func _PressMenuButton($oSelf)
    $oSelf.oDevice.inputMouseSwipe(51.6, 6.7, 56.3, 14.8)
EndFunc   ;==>_PressMenuButton
#EndRegion Methods