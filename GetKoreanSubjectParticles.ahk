#Requires AutoHotkey v2.0.0+
;==============================================================
; GetKoreanSubjectParticles — Auto-select Korean particles based on final consonant
;
; GitHub: https://github.com/SevenKeyboard/get-korean-subject-particles
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;==============================================================

/*
msgbox GetKoreanSubjectParticles.aYa("길동")
msgbox GetKoreanSubjectParticles.aYa("순이")
msgbox GetKoreanSubjectParticles.autoFormat("길동아(야) 순이아(야)")

msgbox GetKoreanSubjectParticles.gwaWa("김철수")
msgbox GetKoreanSubjectParticles.iGa("임꺽정")
msgbox GetKoreanSubjectParticles.eulReul("Johnson")
msgbox GetKoreanSubjectParticles.autoFormat(&str:="김철수과(와) 임꺽정이(가) Johnson을(를) ") ;  1. 
msgbox GetKoreanSubjectParticles.autoFormat("김철수과(와) 임꺽정이(가) Johnson을(를) ") ;  2.
*/

class VersionManager_GetKoreanSubjectParticles
{
    static _ := this._init()
    static _init()    {
        global
        GETKOREANSUBJECTPARTICLES_VERSION := "1.0.0"
	}
}
class GetKoreanSubjectParticles
{
	static autoFormat(param)    {
		rawStr:=(param is VarRef?param:&param)
		spo:=1, out:=""
		while (regExMatch(%rawStr%,"s)(.)"
			. "((*MARK:eunNeun)은\(는\)"
			. "|(*MARK:iGa)이\(가\)"
			. "|(*MARK:eulReul)을\(를\)"
			. "|(*MARK:gwaWa)과\(와\)"
			. "|(*MARK:aYa)아\(야\)"
			. ")",&m,spo))    {
			out.=subStr(%rawStr%,spo,m.pos[0]-spo) . m[1] . this.%m.Mark%(m[1])
			, spo:=m.pos[0]+m.len[0]
		}
		return out . subStr(%rawStr%,spo)
	}
	;---------------------------------------------
	static eunNeun(prevStr)    {
		switch (this._determineBatchim(&prevStr))
		{
			case 0:		return "은(는)"
			case 1:		return "은"
			case 2:		return "는"
		}
	}
	static iGa(prevStr)    {
		switch (this._determineBatchim(&prevStr))
		{
			case 0:		return "이(가)"
			case 1:		return "이"
			case 2:		return "가"
		}
	}
	static eulReul(prevStr)    {
		switch (this._determineBatchim(&prevStr))
		{
			case 0:		return "을(를)"
			case 1:		return "을"
			case 2:		return "를"
		}
	}
	static gwaWa(prevStr)    {
		switch (this._determineBatchim(&prevStr))
		{
			case 0:		return "과(와)"
			case 1:		return "과"
			case 2:		return "와"
		}
	}
	static aYa(prevStr)    {
		switch (this._determineBatchim(&prevStr))
		{
			case 0:		return "아(야)"
			case 1:		return "아"
			case 2:		return "야"
		}
	}
	;---------------------------------------------
	static _determineBatchim(&prevStr)    {
		prevChar:=subStr(prevStr,-1,1)
		return !(prevChar~="[가-힣]")?0:mod(ord(prevChar)-0xAC00,28)?1:2
	}
}