//==============================================================
// GetKoreanSubjectParticles — Auto-select Korean particles based on final consonant
//
// GitHub: https://github.com/SevenKeyboard/get-korean-subject-particles
// Author: SevenKeyboard Ltd. (2025-2026)
// License: The Unlicense
//==============================================================

using System;
using System.Text;

namespace SevenKeyboard;

public static class GetKoreanSubjectParticles
{
    public static string EunNeun(string previous) => Select(previous, "은(는)", "은", "는");
    public static string IGa(string previous) => Select(previous, "이(가)", "이", "가");
    public static string EulReul(string previous) => Select(previous, "을(를)", "을", "를");
    public static string GwaWa(string previous) => Select(previous, "과(와)", "과", "와");
    public static string AYa(string previous) => Select(previous, "아(야)", "아", "야");

    public static string AutoFormat(string text = "")
    {
        ArgumentNullException.ThrowIfNull(text);
        StringBuilder? output = null;
        int copiedThrough = 0;
        int index = 0;

        // Each original match consumes one UTF-16 code unit and a four-unit pair.
        // Resume after that source match, without scanning replacement text.
        while (index <= text.Length - 5)
        {
            string? replacement = text.AsSpan(index + 1, 4) switch
            {
                "은(는)" => Select(text[index], "은(는)", "은", "는"),
                "이(가)" => Select(text[index], "이(가)", "이", "가"),
                "을(를)" => Select(text[index], "을(를)", "을", "를"),
                "과(와)" => Select(text[index], "과(와)", "과", "와"),
                "아(야)" => Select(text[index], "아(야)", "아", "야"),
                _ => null
            };
            if (replacement is null)
            {
                index++;
                continue;
            }

            output ??= new StringBuilder(text.Length);
            output.Append(text, copiedThrough, index - copiedThrough + 1);
            output.Append(replacement);
            index += 5;
            copiedThrough = index;
        }

        return output is null ? text : output.Append(text, copiedThrough, text.Length - copiedThrough).ToString();
    }

    private static string Select(string previous, string unresolved, string consonant, string vowel)
    {
        ArgumentNullException.ThrowIfNull(previous);
        return previous.Length == 0 ? unresolved : Select(previous[^1], unresolved, consonant, vowel);
    }

    private static string Select(char previous, string unresolved, string consonant, string vowel)
    {
        if (previous is < '\uAC00' or > '\uD7A3')
            return unresolved;

        return (previous - 0xAC00) % 28 == 0 ? vowel : consonant;
    }
}
