using System;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using SevenKeyboard;

internal static class Program
{
    private static readonly Func<string, string>[] Selectors =
    [
        GetKoreanSubjectParticles.EunNeun, GetKoreanSubjectParticles.IGa,
        GetKoreanSubjectParticles.EulReul, GetKoreanSubjectParticles.GwaWa,
        GetKoreanSubjectParticles.AYa
    ];
    private static readonly string[] Pairs = ["은(는)", "이(가)", "을(를)", "과(와)", "아(야)"];

    private static int Main()
    {
        try
        {
            CheckOriginalCases();
            CheckAllHangulSyllables();
            CheckDefaultAndNull();
            Console.WriteLine($"PASS: {OriginalCases.Values.Length} original cases, 11,172 syllables x 5 pairs " +
                $"(direct + AutoFormat), default/null contracts; {RuntimeInformation.ProcessArchitecture}.");
            return 0;
        }
        catch (Exception error)
        {
            Console.Error.WriteLine(error);
            return 1;
        }
    }

    private static void CheckOriginalCases()
    {
        for (int index = 0; index < OriginalCases.Values.Length; index++)
        {
            var item = OriginalCases.Values[index];
            for (int pair = 0; pair < Selectors.Length; pair++)
                Equal(item.Particles[pair], Selectors[pair](item.Input), $"Original case {index + 1}, pair {pair}");
            Equal(item.Formatted, GetKoreanSubjectParticles.AutoFormat(item.Input), $"Original case {index + 1}, AutoFormat");
        }
    }

    private static void CheckAllHangulSyllables()
    {
        StringBuilder direct = new();
        StringBuilder formatted = new();
        for (int codeUnit = 0xAC00; codeUnit <= 0xD7A3; codeUnit++)
        {
            string syllable = ((char)codeUnit).ToString();
            for (int pair = 0; pair < Selectors.Length; pair++)
            {
                direct.Append(Selectors[pair](syllable));
                formatted.Append(GetKoreanSubjectParticles.AutoFormat(syllable + Pairs[pair]));
            }
        }

        // SHA-256 of raw UTF-16LE outputs captured from original AHK 1.0.0,
        // main-ahkv1.1 HEAD 6951c7e, on AHK 1.1.37.02 x64 and x86 (identical).
        Equal("E2B90D1E0B9FD50B238393FA4873EB54A1B7EC16CEBC1A494437847864BD0B7E",
            Digest(direct), "All original direct outputs");
        Equal("C2FDA97E1F98037DEC055310FCCB2B722C495D00C9C40E581CFBBC280F90F808",
            Digest(formatted), "All original AutoFormat outputs");
    }

    private static string Digest(StringBuilder output) =>
        Convert.ToHexString(SHA256.HashData(Encoding.Unicode.GetBytes(output.ToString())));

    private static void CheckDefaultAndNull()
    {
        Equal("", GetKoreanSubjectParticles.AutoFormat(), "Default AutoFormat");
        foreach (Func<string, string> selector in Selectors)
            ExpectNull(() => selector(null!), "previous");
        ExpectNull(() => GetKoreanSubjectParticles.AutoFormat(null!), "text");
    }

    private static void ExpectNull(Func<string> action, string parameter)
    {
        try
        {
            action();
        }
        catch (ArgumentNullException error) when (error.ParamName == parameter)
        {
            return;
        }
        throw new InvalidOperationException($"Expected ArgumentNullException for {parameter}.");
    }

    private static void Equal(string expected, string actual, string context)
    {
        if (!string.Equals(expected, actual, StringComparison.Ordinal))
            throw new InvalidOperationException($"{context}: expected '{expected}', actual '{actual}'.");
    }
}
