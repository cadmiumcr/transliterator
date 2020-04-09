require "./spec_helper"

describe Cadmium::Transliterator do
  subject = Cadmium::Transliterator

  describe ".transliterate" do
    it "should keep strings without special characters the same" do
      tests = [
        "",
        "Hello, world",
        "I love Crystal! It's the best language.",
        "http://www.crystal-lang.org",
      ]

      tests.each do |test|
        subject.transliterate(test).should eq(test)
      end
    end

    it "should successfully transliterate strings with special characters" do
      tests = [
        {"\u00C6neid", "AEneid"},
        {"\u00E9tude", "etude"},
        {"\u5317\u4EB0", "Bei Jing"},
        # Chinese
        {"\u1515\u14c7\u14c7", "shanana"},
        # Canadian syllabics
        {"\u13d4\u13b5\u13c6", "taliqua"},
        # Cherokee
        {"\u0726\u071b\u073d\u0710\u073a", "ptu'i"},
        # Syriac
        {"\u0905\u092d\u093f\u091c\u0940\u0924", "abhijiit"},
        # Devanagari
        {"\u0985\u09ad\u09bf\u099c\u09c0\u09a4", "abhijiit"},
        # Bengali
        {"\u0d05\u0d2d\u0d3f\u0d1c\u0d40\u0d24", "abhijiit"},
        # Malayalaam
        {"\u0d2e\u0d32\u0d2f\u0d3e\u0d32\u0d2e\u0d4d", "mlyaalm"},
        # the Malayaalam word for 'Malayaalam'
        # Yes, if we were doing it right, that'd be 'malayaalam', not 'mlyaalm'
        {"\u3052\u3093\u307e\u3044\u8336", "genmai Cha"},
        # Japanese
        {"\u0800\u1400", "[?][?]"},
        # Unknown characters
      ]

      tests.each do |test|
        subject.transliterate(test[0]).should eq(test[1])
      end
    end

    # it "should work with ignore option" do
    #   tests = [
    #     {"\u00C6neid", {"\u00C6"}, "\u00C6neid"},
    #     {"\u4F60\u597D\uFF0C\u4E16\u754C\uFF01", {"\uFF0C", "\uFF01"}, "Ni Hao \uFF0CShi Jie \uFF01"},
    #     {"\u4F60\u597D\uFF0C\u4E16\u754C\uFF01", {"\u4F60\u597D", "\uFF01"}, "\u4F60\u597D,Shi Jie \uFF01"},
    #   ]

    #   tests.each do |(str, ignore, result)|
    #     subject.transliterate(str, ignore: ignore).should eq(result)
    #   end
    # end

    it "should work with replace option" do
      tests = [
        {"\u4F60\u597D\uFF0C\u4E16\u754C\uFF01", [["\u4F60\u597D", "Hola"]], "Hola, Shi Jie !"},
        {"\u4F60\u597D\uFF0C\u4E16\u754C\uFF01", {"\u4F60\u597D" => "Hola"}, "Hola, Shi Jie !"},
      ]

      tests.each do |(str, replace, result)|
        subject.transliterate(str, replace: replace).should eq(result)
      end
    end
  end

  describe ".replace_str" do
    it "should replace instances in a string" do
      tests = [
        {"abbc", [["a", "aa"], [/b+/, "B"]], "aaBc"},
        {"abc123", [["a", "aa"], ["bc", "bbcc"], [/[0-9]+/, "#"]], "aabbcc#"},
      ]

      tests.each do |(str, replace, result)|
        subject.replace_str(str, replace).should eq(result)
      end
    end
  end

  describe ".parameterize" do
    it "should convert a string to a URL save variant" do
      test_cases = {
        "Donald E. Knuth"                     => "donald-e-knuth",
        "Random text with *(bad)* characters" => "random-text-with-bad-characters",
        "Allow_Under_Scores"                  => "allow_under_scores",
        "Trailing bad characters!@#"          => "trailing-bad-characters",
        "!@#Leading bad characters"           => "leading-bad-characters",
        "Squeeze   separators"                => "squeeze-separators",
        "Test with + sign"                    => "test-with-sign",
        "Test with malformed utf8 \251"       => "test-with-malformed-utf8",
      }

      test_cases.each do |from, to|
        subject.parameterize(from).should eq(to)
      end
    end

    it "allows underscores to be converted as well" do
      test_cases = {
        "simply_underscored"   => "simply-underscored",
        "__lead__and__trail__" => "lead-and-trail",
      }

      test_cases.each do |from, to|
        subject.parameterize(from, convert_underscores: true).should eq(to)
      end
    end
  end
end
