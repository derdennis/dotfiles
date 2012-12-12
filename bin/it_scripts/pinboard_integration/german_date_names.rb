# This makes ruby give out german formats for 
# strftime objects
#
# Original via:
# http://www.pixel-webarts.de/blogspot/deutsche-monatsnamen-und-wochentage-in-ruby-on-rails
#
# Replaced the silence_warnings method with the verbosity construct seen below.
# 
# Found that one via:
# http://stackoverflow.com/questions/5591509/suppress-ruby-warnings-when-running-specs
# 
# Also interesting read:
# http://forum.ruby-portal.de/viewtopic.php?f=12&t=1403

original_verbosity = $VERBOSE
$VERBOSE = nil

    Date::MONTHNAMES = [nil] + %w(Januar Februar März April Mai Juni Juli August September Oktober November Dezember)
    Date::DAYNAMES = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)
    Date::ABBR_MONTHNAMES = [nil] + %w(Jan Feb März Apr Mai Jun Jul Aug Sep Okt Nov Dez)
    Date::ABBR_DAYNAMES = %w(So Mo Di Mi Do Fr Sa)
    Time::MONTHNAMES = Date::MONTHNAMES
    Time::DAYNAMES = Date::DAYNAMES
    Time::ABBR_MONTHNAMES = Date::ABBR_MONTHNAMES
    Time::ABBR_DAYNAMES = Date::ABBR_DAYNAMES
$VERBOSE = original_verbosity
 
class Time
    alias_method :strftime_old, :strftime
    def strftime(format)
        format = format.dup
        format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])
        format.gsub!(/%A/, Date::DAYNAMES[self.wday])
        format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])
        format.gsub!(/%B/, Date::MONTHNAMES[self.mon])
        self.strftime_old(format)
    end
end
