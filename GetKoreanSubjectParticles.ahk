#Requires AutoHotkey v1.1.05+
;==============================================================
; GetKoreanSubjectParticles — Auto-select Korean particles based on final consonant
;
; GitHub: https://github.com/SevenKeyboard/get-korean-subject-particles
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;==============================================================

/*
msgbox % GetKoreanSubjectParticles.aYa("길동")
msgbox % GetKoreanSubjectParticles.aYa("순이")
msgbox % GetKoreanSubjectParticles.autoFormat("길동아(야) 순이아(야)")

msgbox % GetKoreanSubjectParticles.gwaWa("김철수")
msgbox % GetKoreanSubjectParticles.iGa("임꺽정")
msgbox % GetKoreanSubjectParticles.eulReul("Johnson")
msgbox % GetKoreanSubjectParticles.autoFormat("김철수과(와) 임꺽정이(가) Johnson을(를) ")
*/

class VersionManager_GetKoreanSubjectParticles
{
    static _ := VersionManager_GetKoreanSubjectParticles._init()
    _init()    {
        global
        GETKOREANSUBJECTPARTICLES_VERSION := "1.0.0"
	}
}
class GetKoreanSubjectParticles
{
	autoFormat(ByRef rawStr:="")    {
		spo:=1, out:=""
		while (regExMatch(rawStr,"sO)(.)"
			. "((*MARK:eunNeun)은\(는\)"
			. "|(*MARK:iGa)이\(가\)"
			. "|(*MARK:eulReul)을\(를\)"
			. "|(*MARK:gwaWa)과\(와\)"
			. "|(*MARK:aYa)아\(야\)"
			. ")",m,spo))    {
			out.=subStr(rawStr,spo,m.pos(0)-spo) . m[1] . this[m.mark()](m[1])
			, spo:=m.pos(0)+m.len(0)
		}
		return out . subStr(rawStr,spo)
	}
	;---------------------------------------------
	eunNeun(prevStr)    {
		switch (this._determineBatchim(prevStr))
		{
			case 0:		return "은(는)"
			case 1:		return "은"
			case 2:		return "는"
		}
	}
	iGa(prevStr)    {
		switch (this._determineBatchim(prevStr))
		{
			case 0:		return "이(가)"
			case 1:		return "이"
			case 2:		return "가"
		}
	}
	eulReul(prevStr)    {
		switch (this._determineBatchim(prevStr))
		{
			case 0:		return "을(를)"
			case 1:		return "을"
			case 2:		return "를"
		}
	}
	gwaWa(prevStr)    {
		switch (this._determineBatchim(prevStr))
		{
			case 0:		return "과(와)"
			case 1:		return "과"
			case 2:		return "와"
		}
	}
	aYa(prevStr)    {
		switch (this._determineBatchim(prevStr))
		{
			case 0:		return "아(야)"
			case 1:		return "아"
			case 2:		return "야"
		}
	}
	;---------------------------------------------
	_determineBatchim(ByRef prevStr)    {
		prevChar:=subStr(prevStr,0,1)
		return !(prevChar~="[가-힣]")?0:mod(ord(prevChar)-0xAC00,28)?1:2
	}
}