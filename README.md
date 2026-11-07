# get-korean-subject-particles

Select Korean particles from the last UTF-16 code unit of a string. C# version
1.0.0 preserves the AHK helper's behavior and targets .NET 10 on Windows.

```csharp
using SevenKeyboard;

GetKoreanSubjectParticles.EunNeun("길동"); // "은"
GetKoreanSubjectParticles.IGa("순이");    // "가"
GetKoreanSubjectParticles.EulReul("책");  // "을"
GetKoreanSubjectParticles.GwaWa("나무");  // "와"
GetKoreanSubjectParticles.AYa("길동");    // "아"
GetKoreanSubjectParticles.AutoFormat("길동아(야) 순이아(야)"); // "길동아 순이야"
```

Only precomposed Hangul syllables (`가`–`힣`) determine the final consonant.
Empty strings and other final characters keep the unresolved pair, such as
`은(는)`. Input is not trimmed or normalized. Null arguments throw
`ArgumentNullException`.

`AutoFormat` supports all five exact pairs shown above, returns a new result
without changing the input, and defaults to an empty string. Matches consume
the preceding UTF-16 code unit and the pair in the original input; replacements
are not rescanned. For example, `가은(는)이(가)` becomes `가는이(가)`.

Reference `src/SevenKeyboard.GetKoreanSubjectParticles/SevenKeyboard.GetKoreanSubjectParticles.csproj`.
Run the original-derived compatibility checks with:

```powershell
dotnet run --project tests/GetKoreanSubjectParticles.Smoke -c Release
```

The library supports x64, x86, and NativeAOT. License: The Unlicense.
