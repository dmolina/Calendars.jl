# This is part of Calendars.jl. See the copyright note there.
# ===================== European calendar ===================

# The Gregorian calendar is used for dates on and after 
# CE 1582-10-15, otherwise the Julian calendar is used. 


# Is the date a valid European date?
function isValidDateEuropean(cd::CDate)
    cal, year, month, day = cd
    if CName(cal) != EC 
        @warn(Warning(cd))
        return false
    end

    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return isValidDateJulian((RC, year, month, day))
    end
    return isValidDateGregorian((CE, year, month, day))
end

# Computes the day number from a date.
# All dates prior to CE 1582-10-15 are interpreted as Julian dates.
function DayNumberEuropean(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayNumberJulian(year, month, day)
    end
    return dn
end

# Computes the day number from a date.
function DayNumberEuropean(cd::CDate)
    cal, year, month, day = cd
    return DayNumberEuropean(year, month, day) 
end

# Computes the historic date from a day number.
# All dates prior to CE 1582-10-15 are returned as Julian dates.
function DateEuropean(dn::DPart)
    d = dn < GregorysBreak ? DateJulian(dn) : DateGregorian(dn)
    cal, year, month, day = d
    return (EC, year, month, day)
end

# Return the days this year so far.
function DayOfYearEuropean(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayOfYearJulian(year, month, day)
    end
    return DayOfYearGregorian(year, month, day)
end