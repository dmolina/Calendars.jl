# ---------------------------------------------------------------
# Parts of the Julia code in this package is ported from the Lisp
# and C++ code in 'Calendrical Calculations' by Nachum Dershowitz
# and Edward M. Reingold, Software---Practice & Experience,
# vol. 20, no. 9 (September, 1990), pp. 899--928.
# This code is in the public domain, but any use of it should 
# publicly acknowledge the above sources, which is done herewith.
# Copyright of this port Peter Luschny, 2022. 
# Licensed under the MIT license.
# ---------------------------------------------------------------

module Calendars

export DayNumberFromDate, DateFromDayNumber, ConvertDate, CalendarDates 
export CDate, CDateStr, DateStr, DateTable, PrintDateTable, isValidDate
export Duration, DayOfYear, IDate, RDToJulianNumber, JulianNumberToRD

include("CalendarUtils.jl")
include("GregorianCalendar.jl")
include("JulianCalendar.jl")
include("HistoricalCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")
include("IsoCalendar.jl")
include("REPLCalendar.jl")

"""

```julia
DayNumberFromDate(date::Cdate, show::Bool)
```

Return the day number correspondig to the calendar date.
If the optional parameter 'show' is set to 'true', date 
and number are printed. 'show' is 'false' by default.

```julia
julia> DayNumberFromDate(("Gregorian", 1756, 1, 27)) 
```

Alternatively you can also write

```julia
julia> DayNumberFromDate("CE", 1756, 1, 27) 
```

This returns the day number 641027. If 'show' is 'true'
the line "CE 1756-01-27 -> RD 641027" is printed.

If an error occurs 0 (representing the invalid day 
number) is returned.
"""
function DayNumberFromDate(d::CDate, show=false)
    calendar = CName(d[1])
    if calendar == CE 
        dn = DayNumberGregorian(d)
    elseif calendar == AD
        dn = DayNumberJulian(d)
    elseif calendar == HC
        dn = DayNumberHistorical(d)    
    elseif calendar == AM
        dn = DayNumberHebrew(d)
    elseif calendar == AH
        dn = DayNumberIslamic(d)
    elseif calendar == ID
        dn = DayNumberIso(d)
    elseif calendar == RD
        dn = d[4]    
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayNumber
    end

    if show
        println(CDateStr(d), " -> ", CDateStr(dn))
    end
    return dn 
end

DayNumberFromDate(calendar::String, year::DPart, month::DPart, day::DPart, 
show=false) = DayNumberFromDate((calendar, year, month, day), show)

DayNumberFromDate(calendar::String, d::Tuple{DPart, DPart, DPart}, 
show=false) = DayNumberFromDate((calendar, d[1], d[2], d[3]), show)


"""

```julia
DateFromDayNumber(calendar::String, dn::DPart, show::Bool)
```

Return the calendar date from a day number.

The day number 'dn' must be an integer >= 1. If the optional 
parameter 'show' is set to 'true', date and number are printed.
'show' is 'false' by default.

```julia
julia> DateFromDayNumber("Gregorian", 641027) 
```

Alternatively you can also write

```julia
julia> DateFromDayNumber("CE", 641027) 
```

This returns the date ("CE", 1756, 1, 27). If 'show' is 
'true' the line "RD 0641027 -> CE 1756-01-27" is printed.

If an error occurs ("00", 0, 0, 0) (representing the 
invalid date) is returned.
"""
function DateFromDayNumber(calendar::String, dn::DPart, show=false)
    if dn <= 0
        @warn("Day number must be > 0: $calendar $dn")
        return InvalidDate
    end

    # Use a symbol for the calendar name.
    cal = CName(calendar)
    if cal == CE
        date = DateGregorian(dn)
    elseif cal == AD
        date = DateJulian(dn)
    elseif cal == HC
        date = DateHistorical(dn)    
    elseif cal == AM
        date = DateHebrew(dn)
    elseif cal == AH
        date = DateIslamic(dn) 
    elseif cal == ID
        date = DateIso(dn) 
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDate
    end

    if show 
        println(CDateStr(dn), " -> ", CDateStr(date))
    end
    return date 
end

"""

```julia
ConvertDate(date::CDate, to::String, show::Bool)
```

Convert the given date to a date in the calendar 'to'.
'to' is the name of a calendar where admissible names
are listed in the CDate docstring. If the optional 
parameter 'show' is set to 'true', both dates are printed. 
'show' is 'false' by default.

```julia
julia> ConvertDate(("Gregorian", 1756, 1, 27), "Hebrew") 
```

Alternatively you can also write

```julia
julia> ConvertDate("CE", 1756, 1, 27, "AM") 
```

This converts the Gregorian date ("CE", 1756, 1, 27) to the 
Hebrew date ("AM", 5516, 11, 25). If 'show' is 'true' the 
following line is printed:

```julia
    "CE 1756-01-27 -> AM 5516-11-25"
```

If an error occurs ("00", 0, 0, 0) (representing the invalid 
date) is returned.    
"""
function ConvertDate(date::CDate, to::String, show=false)
    cal, year, month, day = date
    inc = CName(cal) 
    toc = CName(to)
    (inc == XX || toc == XX) && return InvalidDate
    d = (inc, year, month, day)
    ! isValidDate(d) && return InvalidDate
    dn = DayNumberFromDate(d)
    rdate = DateFromDayNumber(toc, dn)  
    show && println(CDateStr(date), " -> ", CDateStr(rdate))

    return rdate 
end

ConvertDate(calendar::String, year::Int, month::Int, day::Int, to::String, 
show=false) = ConvertDate((calendar, year, month, day), to, show)

ConvertDate(calendar::String, d::Tuple{DPart, DPart, DPart}, to::String, 
show=false) = ConvertDate((calendar, d[1], d[2], d[3]), to, show)


"""

```julia
CalendarDates(date::CDate, show::Bool)
```

Return a table of the dates of all supported calendars 
corresponding to 'date'. If the optional parameter 'show' 
is set to 'true', the date table is printed. 'show' is 
'false' by default.

```julia
julia> CalendarDates(("Gregorian", 1756, 1, 27),  true) 
```

Alternatively you can also write

```julia
julia> CalendarDates("CE", 1756, 1, 27, true) 
```

This computes a 'DateTable', which is a tuple of six
calendar dates plus the day number. If 'show' is 'true'
the table below will be printed.
```julia
    CurrentEpoch  CE 1756-01-27
    Julian        AD 1756-01-16
    Historical    HC 1756-01-27
    Hebrew        AM 5516-11-25
    Islamic       AH 1169-04-24
    IsoDate       ID 1756-05-02
    DayNumber     RD 641027
```
"""
function CalendarDates(date::CDate, show=false)

    dn = DayNumberFromDate(date)
    Table = (
        DateFromDayNumber(CE, dn),
        DateFromDayNumber(AD, dn),
        DateFromDayNumber(HC, dn),
        DateFromDayNumber(AM, dn),
        DateFromDayNumber(AH, dn),
        DateFromDayNumber(ID, dn),
        (RD, 0, 0, dn)
    )
    show && PrintDateTable(Table)
    return Table
end

CalendarDates(calendar::String, year::DPart, month::DPart, day::DPart, 
show=false) = CalendarDates((calendar, year, month, day), show)

CalendarDates(calendar::String, d::Tuple{DPart, DPart, DPart}, 
show=false) = CalendarDates((calendar, d[1], d[2], d[3]), show) 


"""

```julia
isValidDate(date::CDate)::Bool
```

Query if the given date is a valid calendar date for the 
given calendar.

```julia
julia> isValidDate(("Gregorian", 1756, 1, 27)) 
```

Alternatively you can also write

```julia
julia> isValidDate("CE", 1756, 1, 27) 
```

In this example the query affirms that 1756-01-27 is a 
valid Gregorian date.
"""
function isValidDate(d::CDate)  
    calendar = CName(d[1])
    if calendar == CE
        val = isValidDateGregorian(d)
    elseif calendar == AD
        val = isValidDateJulian(d)
    elseif calendar == HC
        val = isValidDateGregorian(d)    
    elseif calendar == AM
        val = isValidDateHebrew(d)
    elseif calendar == AH
        val = isValidDateIslamic(d)
    elseif calendar == ID
        val = isValidDateIso(d)
    elseif calendar == RD
        val = d[4] > 0   
    else
        @warn("Unknown calendar: $calendar")
        return false
    end
    return val
end

isValidDate(calendar::String, year::DPart, month::DPart, 
day::DPart) = isValidDate((calendar, year, month, day))

isValidDate(calendar::String, d::Tuple{DPart, DPart, DPart}) = 
isValidDate((calendar, d[1], d[2], d[3]))

"""

```julia
DayOfYear(date::CDate)
```

Return the ordinal of the day in the given calendar. Also known 
as the 'ordinal date'. 

```julia
julia> DayOfYear(("CE", 1756, 1, 27)) 
```

Alternatively you can write

```julia
julia> DayOfYear("Gregorian", 1756,  1, 27) 
julia> DayOfYear("Hebrew",    5516, 11, 25) 
```

From the output we see that CE 1756-01-27 is the 27-th day 
of the year 1756 in the Gregorian calendar. The same day
is in the Hebrew calendar the 144-th day of the year.

If an error occurs 0 (representing the invalid day of the year)
is returned.
"""
function DayOfYear(date::CDate)
    if ! isValidDate(date)
        @warn(Warning(date))
        return InvalidDayOfYear
    end

    calendar, year, month, day = date
    cname = CName(calendar)
    if cname == CE
        val = DayOfYearGregorian(year, month, day)
    elseif cname == AD
        val = DayOfYearJulian(year, month, day)
    elseif cname == HC
        val = DayOfYearHistorical(year, month, day)    
    elseif cname == AM
        val = DayOfYearHebrew(year, month, day)
    elseif cname == AH
        val = DayOfYearIslamic(year, month, day)
    elseif cname == ID
        val = DayOfYearIso(year, month, day)
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayOfYear
    end
    return val
end

DayOfYear(calendar::String, year::DPart, month::DPart, day::DPart) = 
DayOfYear((calendar, year, month, day)) 

DayOfYear(calendar::String, d::Tuple{DPart, DPart, DPart}) = 
DayOfYear((calendar, d[1], d[2], d[3])) 


"""

```julia
Duration(a::CDate, b::CDate, show=false)
``` 

The duration gives the number of days between two dates, counting 
the first date but not the second. So it describes a right half-open
time interval. The start and end dates can be given in different 
calendars.

If the optional parameter 'show' is set to 'true', both dates are 
printed. 'show' is 'false' by default.

```julia
julia> Duration(("CE", 2022, 1, 1), ("ID", 2022, 1, 1), true)
``` 
Perhaps to the surprise of some, these dates are two days apart.

    CE 2022-01-01 -- ID 2022-01-01 -> Duration 2
"""
function Duration(a::CDate, b::CDate, show=false)
    if isValidDate(a) && isValidDate(b)
        an = DayNumberFromDate(a)
        bn = DayNumberFromDate(b)
        dur = abs(bn - an)
        
        if show
            ad = CDateStr(a)
            bd = CDateStr(b)
            show && println(ad, " <-> ", bd, " -> Duration ", dur)
        end
        return dur 
    end
    @warn("Invalid Date: $a $b")
    return InvalidDuration
end

end # module
