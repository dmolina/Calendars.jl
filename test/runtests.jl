# This is part of Calendars.jl. See the copyright note there.
# ============================ Tests ========================

using Calendars
using Dates: yearmonthday, now
using Test 

# Planetary week
sunday    = 0 
monday    = 1 
tuesday   = 2 
wednesday = 3 
thursday  = 4 
friday    = 5 
saturday  = 6 
weeklen   = 7

function TestDateGregorian()
    SomeDateGregorian = [ 
        (CE,    1, 1,  1)::CDate, 
        (CE, 1756, 1, 27)::CDate, 
        (CE, 2022, 1,  1)::CDate, 
        (CE, 2022, 9, 26)::CDate 
    ] 

    @testset "DateGregorian" begin
    for date in SomeDateGregorian
        dn = DayNumberFromDate(date)
        gdate = DateFromDayNumber("Gregorian", dn)
        @test gdate == (CE, date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(EN, dn), " -> ", CDateStr(gdate))
    end
    end
end

function TestDateJulian()
    SomeDateJulian = [ 
        (JD,    1,  1,  3)::CDate,
        (JD, 1756,  1, 16)::CDate,
        (JD, 2021, 12, 19)::CDate,
        (JD, 2022,  9, 13)::CDate
    ] 

    @testset "DateJulian" begin
    for date in SomeDateJulian
        dn = DayNumberFromDate(date)
        jdate = DateFromDayNumber("Julian", dn)
        @test jdate == (JD, date[2], date[3], date[4]) 
        println(CDateStr(date), " -> ", CDateStr(EN, dn), " -> ", CDateStr(jdate))
    end
    end
end

function TestDateHebrew()
    SomeDateHebrew  = [ 
        (AM, 5516, 11, 25)::CDate, 
        (AM, 5782,  7,  1)::CDate,
        (AM, 5782, 10, 27)::CDate,
        (AM, 5782,  6, 29)::CDate,
        (AM, 5783,  7,  1)::CDate
    ]

    @testset "DateHebrew" begin
    for date in SomeDateHebrew
        dn = DayNumberFromDate(date)
        hdate = DateFromDayNumber("Hebrew", dn)
        @test hdate == (AM, date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(EN, dn), " -> ", CDateStr(hdate))
    end
    end
end

function TestDateIslamic()
    SomeDateIslamic = [ 
        (AH,    1, 1,  1)::CDate,
        (AH, 1756, 1, 27)::CDate,
        (AH, 2022, 1,  1)::CDate,
        (AH, 2022, 9, 26)::CDate 
    ] 

    @testset "DateIslamic" begin
    for date in SomeDateIslamic
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber("Islamic", dn)
        @test idate == (AH, date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(EN, dn), " -> ", CDateStr(idate))
    end
    end
end

function TestDateIso()
    SomeDateIso = [ 
        (ID,    1,  1, 1)::CDate,
        (ID, 1756,  5, 2)::CDate,
        (ID, 2021, 52, 6)::CDate,
        (ID, 2022, 39, 1)::CDate 
    ] 

    @testset "DateIso" begin
    for date in SomeDateIso
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber("IsoDate", dn)
        @test idate == (ID, date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(EN, dn), " -> ", CDateStr(idate))
    end
    end
end

function TestConversions()
    
    @testset "Conversions" begin
    @test (AM, 9543, 7,24) == ConvertDate("Gregorian", 5782, 10, 28, "Hebrew") 
    @test (AH, 5319, 8,25) == ConvertDate("Gregorian", 5782, 10, 28, "Islamic") 
    @test (AM, 5516,11,25) == ConvertDate("Gregorian", 1756,  1, 27, "Hebrew") 
    @test (AH,    1, 1, 1) == ConvertDate("Gregorian", 622,   7, 19, "Islamic") 

    println("=")
    @test (AH, 1443, 5,27) == ConvertDate("Hebrew", 5782, 10, 28, "Islamic") 
    @test (CE, 5782,10,28) == ConvertDate("Hebrew", 9543,  7, 24, "Gregorian") 
    @test (AH, 4501, 8, 3) == ConvertDate("Hebrew", 8749, 11, 03, "Islamic") 

    println("==")
    @test (AM, 7025,11,23) == ConvertDate("Islamic", 2724, 08, 23, "Hebrew") 
    @test (CE, 7025,11,29) == ConvertDate("Islamic", 6600, 11, 21, "Gregorian") 
    @test (AM, 9992,12,27) == ConvertDate("Islamic", 5782, 10, 28, "Hebrew") 

    @test (AM, 9543, 7,24) == ConvertDate(CE, 5782, 10, 28, AM) 
    @test (AH, 5319, 8,25) == ConvertDate(CE, 5782, 10, 28, AH) 
    @test (AM, 5516,11,25) == ConvertDate(CE, 1756,  1, 27, AM) 
    @test (AH,    1, 1, 1) == ConvertDate(CE, 622,   7, 19, AH) 

    println("===")
    @test (AH, 1443, 5,27) == ConvertDate(AM, 5782, 10, 28, AH) 
    @test (CE, 5782,10,28) == ConvertDate(AM, 9543,  7, 24, CE) 
    @test (AH, 4501, 8, 3) == ConvertDate(AM, 8749, 11, 03, AH) 

    println("====")
    @test (AM, 7025,11,23) == ConvertDate(AH, 2724, 08, 23, AM) 
    @test (CE, 7025,11,29) == ConvertDate(AH, 6600, 11, 21, CE) 
    @test (AM, 9992,12,27) == ConvertDate(AH, 5782, 10, 28, AM) 

    end

    println("\nThe following 3 conversions test warnings, so worry only if you do not see them.\n")
    println("This Hebrew date is before the Julian epoch.")
    ConvertDate("Hebrew", 2022,  1,  1, "Gregorian") |> println
    ConvertDate("Hebrew", 5782, 10, 28, "Georgian")  |> println
    ConvertDate("Homebrew", 2022, 1, 1, "Gregorian") |> println
end

function TestIso()

    ISO = [
        ((CE, 1977,01,01 ), (ID, 1976,53,6 )),
        ((CE, 1977,01,02 ), (ID, 1976,53,7 )),
        ((CE, 1977,12,31 ), (ID, 1977,52,6 )),
        ((CE, 1978,01,01 ), (ID, 1977,52,7 )),
        ((CE, 1978,01,02 ), (ID, 1978,01,1 )),
        ((CE, 1978,12,31 ), (ID, 1978,52,7 )),
        ((CE, 1979,01,01 ), (ID, 1979,01,1 )),
        ((CE, 1979,12,30 ), (ID, 1979,52,7 )),
        ((CE, 1979,12,31 ), (ID, 1980,01,1 )),
        ((CE, 1980,01,01 ), (ID, 1980,01,2 )),
        ((CE, 1980,12,28 ), (ID, 1980,52,7 )),
        ((CE, 1980,12,29 ), (ID, 1981,01,1 )),
        ((CE, 1980,12,30 ), (ID, 1981,01,2 )),
        ((CE, 1980,12,31 ), (ID, 1981,01,3 )),
        ((CE, 1981,01,01 ), (ID, 1981,01,4 )),
        ((CE, 1981,12,31 ), (ID, 1981,53,4 )),
        ((CE, 1982,01,01 ), (ID, 1981,53,5 )),
        ((CE, 1982,01,02 ), (ID, 1981,53,6 )),
        ((CE, 1982,01,03 ), (ID, 1981,53,7 ))
    ]

    @testset "ISODates" begin
    for iso in ISO
        a = DayNumberFromDate(iso[1])
        b = DayNumberFromDate(iso[2])
        @test a == b
        println(a, " = ", b)
    end
    end
end

function TestDateTables()

TestDates = [
((EN,0,0,405735),(CE,1111,11,11),(JD,1111,11,4), (EC,1111,11,4),(ID,1111,45,6),(AM,4872,9,2),  (AH, 505,4,29), (JN,0,0,2127158))::DateTable,
((EN,0,0,811258),(CE,2222,2,22), (JD,2222,2,7),  (EC,2222,2,22),(ID,2222,8,5), (AM,5982,12,10),(AH,1649,9,10), (JN,0,0,2532681))::DateTable,
((EN,0,0,641029),(CE,1756,1,27), (JD,1756,1,16), (EC,1756,1,27),(ID,1756,5,2), (AM,5516,11,25),(AH,1169,4,24), (JN,0,0,2362452))::DateTable,
((EN,0,0,738158),(CE,2022,1,1),  (JD,2021,12,19),(EC,2022,1,1), (ID,2021,52,6),(AM,5782,10,28),(AH,1443,5,27), (JN,0,0,2459581))::DateTable,
((EN,0,0,738426),(CE,2022,9,26), (JD,2022,9,13), (EC,2022,9,26),(ID,2022,39,1),(AM,5783,7,1),  (AH,1444,2,29), (JN,0,0,2459849))::DateTable,
((EN,0,0,1146992),(CE, 3141,5,9),(JD,3141,4,17), (EC,3141,5,9), (ID,3141,19,5),(AM,6901,2,9),  (AH,2597,2,10), (JN,0,0,2868415))::DateTable
]
    @testset "DayNumbers" begin
    for D in TestDates
        println()
        PrintDateTable(D)
        num = D[1][4]
        
        for d in D[1:end]
            dn = DayNumberFromDate(d)
            if dn > 0
                @test dn == num 
            end
        end
    end
    end
end

function TestDuration()
    @testset "Duration" begin
    @test 2 == Duration((CE, 2022, 1, 1), (ID, 2022, 1, 1), true) 
    @test 2 == Duration((ID, 2022, 1, 1), (CE, 2022, 1, 1), true) 
    @test 0 == Duration((CE, 2022, 1, 1), (CE, 2022, 1, 1), true) 
    @test 0 == Duration((ID, 2022, 1, 1), (CE, 2022, 1, 3), true) 
    # Nota bene, not 365! Duration is a paradise for off-by-one errors.
    @test 364 == Duration((CE, 2022, 1, 1), (CE, 2022, 12, 31), true) 
    @test 365 == Duration((CE, 2022, 1, 1), (CE, 2023,  1,  1), true) 
    end
end

function TestDayOfYear()
    DOY = [
        ((CE, 1000,02,28),  59), 
        ((CE, 1000,02,29),   0), 
        ((CE, 1111,11,11), 315),
        ((CE, 1756,01,27),  27),
        ((CE, 1900,02,28),  59), 
        ((CE, 1900,02,29),   0), 
        ((CE, 1901,02,28),  59), 
        ((CE, 1901,02,29),   0), 
        ((CE, 1949,11,29), 333),
        ((CE, 1990,10,20), 293),
        ((CE, 2000,02,28),  59), 
        ((CE, 2000,02,29),  60), 
        ((CE, 2020,02,28),  59), 
        ((CE, 2020,02,29),  60), 
        ((CE, 2020,07,30), 212), 
        ((CE, 2020,08,20), 233), 
        ((CE, 2021,09,07), 250),  
        ((CE, 2022,01,01),   1),
        ((CE, 2022,09,26), 269),
        ((CE, 2023,07,19), 200),
        ((CE, 2040,02,28),  59), 
        ((CE, 2040,02,29),  60), 
        ((CE, 2040,09,08), 252), 
        ((CE, 2222,02,22),  53),
        ((CE, 3141,05,09), 129)
    ]

    println("\n====================\n")

    @testset "DayOfYear" begin
    for x in DOY
        date, num = x
        doy = DayOfYear(date)
        print(CDateStr(date), " ::", lpad(num, 4, " "), lpad(doy, 4, " "))
        println(" ", doy == num)
        @test doy == num
    end
    end
end

function ShowDayOfYear()

    Dates = [ (22, 1, 1), (756, 1, 27), (949, 11, 29), (990, 10, 20), 
    (2022, 1, 1), (1756, 1, 27), (1949, 11, 29), (1990, 10, 20)]  

    @testset "DayOfYear2" begin
    for date in Dates
        ce = DayOfYear(CE, date)
        jd = DayOfYear(JD, date)
        ec = DayOfYear(EC, date)
        @test ce == jd
        @test ec == jd
        println(CDateStr(EC, date), " ::", lpad(DayOfYear(EC, date),  4, " "))
    end
    end
end

# Checked with https://www.arc.id.au/Calendar.html
function TestJulianDayNumbers1()
  
    test = [  #  EC,       EuroNum, JulianNum, ModJulianNum
    ((EC,800,12,25)::CDate, 292194, 2013617, -386384),  # Coronation of Carolus Magnus
    ((EC, 843,8,10)::CDate, 307762, 2029185, -370816),  # Treaty of Verdun
    ((EC,1204,4,12)::CDate, 439498, 2160921, -239080),  # Sack of Constantinople
    ((EC,1452,4,15)::CDate, 530083, 2251506, -148495),  # Birth of Leonardo da Vinci
    ((EC,1666,9, 2)::CDate, 608376, 2329799, -70202),   # Great Fire of London
    ((EC,1789,7,14)::CDate, 653251, 2374674, -25327),   # The Storming of the Bastille
    ((EC,1906,4,28)::CDate, 695906, 2417329, 17328)]    # Birth of Kurt Gödel

    @testset "JulianDayNumbers1" begin
    for t in test
        println()
        edn  = DayNumberFromDate(t[1])
        jdn  = ConvertOrdinalDate(edn, EN, JN)
        @test jdn  == t[3] 
        println(edn, " ", jdn, " ")
        edn  = ConvertOrdinalDate(jdn, JN, EN)
        @test edn  == t[2] 
        println(jdn, " ", edn)
    end

    en = ConvertOrdinalDate(2440423, JN, EN) 
    jn = ConvertOrdinalDate(719000,  EN, JN) 
    @test en  == 719000
    @test jn  == 2440423
    println(en, " ", jn)
    end
end

function TestSaveCalendars()
    SaveEuropeanMonth(1, 1)
    SaveEuropeanMonth(1111, 11)
    SaveEuropeanMonth(1582, 10)
    SaveEuropeanMonth(9999, 12)
    println("Note the jump in the European calendar!")
    PrintIsoWeek(1582, 41)
    PrintIsoWeek(2525, 25)
end

function DayOfLife(birthdate::CDate) 
    if isValidDate(birthdate) 
        y, m, d = yearmonthday(now())
        return Duration(birthdate, (CE, y, m, d)) + 1
    end
    @warn("Invalid Date: $birthdate")
    return InvalidDuration
end

function TestToday()
    println("\nMozart would be ", DayOfLife((EC, 1756, 1, 27)), " days old today.")
    println("\nToday on all calendars:\n")
    (year, month, day) = yearmonthday(now())
    date = (EC, year, month, day)
    CalendarDates(date, true)
    doy = DayOfYear(date)
    println("\nThis is the $doy-th day of a EC-year.")
end

# Test values from Dershowitz & Reingold.
function TestJulianDayNumbers()
# RD,      Weekday,  Julian Day,    Gregorian,      ISODate      Islamic  
RD = [
[ 25469, wednesday, 1746893.5, ( 70,  9, 24),   (70, 39, 3),  ( -568,  4,  1)],
[ 49217, sunday,    1770641.5, ( 135, 10,  2),  (135, 39, 7), ( -501,  4,  6)],
[171307, wednesday, 1892731.5, ( 470,  1,  8),  (470,  2, 3), ( -157, 10, 17)],
[210155, monday,    1931579.5, ( 576,  5, 20),  (576, 21, 1), (  -47,  6,  3)],
[253427, saturday,  1974851.5, ( 694, 11, 10),  (694, 45, 6), (   75,  7, 13)],
[369740, sunday,    2091164.5, (1013,  4, 25), (1013, 16, 7), (  403, 10,  5)],
[400085, sunday,    2121509.5, (1096,  5, 24), (1096, 21, 7), (  489,  5, 22)],
[434355, friday,    2155779.5, (1190,  3, 23), (1190, 12, 5), (  586,  2,  7)],
[452605, saturday,  2174029.5, (1240,  3, 10), (1240, 10, 6), (  637,  8,  7)],
[470160, friday,    2191584.5, (1288,  4,  2), (1288, 14, 5), (  687,  2, 20)],
[473837, sunday,    2195261.5, (1298,  4, 27), (1298, 17, 7), (  697,  7,  7)],
[507850, sunday,    2229274.5, (1391,  6, 12), (1391, 23, 7), (  793,  7,  1)],
[524156, wednesday, 2245580.5, (1436,  2,  3), (1436,  5, 3), (  839,  7,  6)],
[544676, saturday,  2266100.5, (1492,  4,  9), (1492, 14, 6), (  897,  6,  1)],
[567118, saturday,  2288542.5, (1553,  9, 19), (1553, 38, 6), (  960,  9, 30)],
[569477, saturday,  2290901.5, (1560,  3,  5), (1560,  9, 6), (  967,  5, 27)],
[601716, wednesday, 2323140.5, (1648,  6, 10), (1648, 24, 3), ( 1058,  5, 18)],
[613424, sunday,    2334848.5, (1680,  6, 30), (1680, 26, 7), ( 1091,  6,  2)],
[626596, friday,    2348020.5, (1716,  7, 24), (1716, 30, 5), ( 1128,  8,  4)],
[645554, sunday,    2366978.5, (1768,  6, 19), (1768, 24, 7), ( 1182,  2,  3)],
[664224, monday,    2385648.5, (1819,  8,  2), (1819, 31, 1), ( 1234, 10, 10)],
[671401, wednesday, 2392825.5, (1839,  3, 27), (1839, 13, 3), ( 1255,  1, 11)],
[694799, sunday,    2416223.5, (1903,  4, 19), (1903, 16, 7), ( 1321,  1, 21)],
[704424, sunday,    2425848.5, (1929,  8, 25), (1929, 34, 7), ( 1348,  3, 19)],
[708842, monday,    2430266.5, (1941,  9, 29), (1941, 40, 1), ( 1360,  9,  8)],
[709409, monday,    2430833.5, (1943,  4, 19), (1943, 16, 1), ( 1362,  4, 13)],
[709580, thursday,  2431004.5, (1943, 10,  7), (1943, 40, 4), ( 1362, 10,  7)],
[727274, tuesday,   2448698.5, (1992,  3, 17), (1992, 12, 2), ( 1412,  9, 13)],
[728714, sunday,    2450138.5, (1996,  2, 25), (1996,  8, 7), ( 1416, 10,  5)],
[744313, wednesday, 2465737.5, (2038, 11, 10), (2038, 45, 3), ( 1460, 10, 12)],
[764652, sunday,    2486076.5, (2094,  7, 18), (2094, 28, 7), ( 1518,  3,  5)]
] 

RDN = [ 25469, 49217, 171307, 210155, 253427, 369740, 400085, 434355, 452605, 470160, 
    473837, 507850, 524156, 544676, 567118, 569477, 601716, 613424, 626596, 645554, 
    664224, 671401, 694799, 704424, 708842, 709409, 709580, 727274, 728714, 744313, 764652]

@testset "JulianDayNumbers" begin
    for rd in RD
        rdn = rd[1]
        local jn = ConvertOrdinalDate(rdn + 2, EN, JN)
        CEdate = DateFromDayNumber(CE, rdn + 2)
        IDdate = DateFromDayNumber(ID, rdn + 2)
        @test Int64(rd[3] + 0.5) == jn  # Note: +0.5
        @test rd[4] == (CEdate[2], CEdate[3], CEdate[4])
        @test rd[5] == (IDdate[2], IDdate[3], IDdate[4])
   
        # We do rnot handle preleptic Ismlam dates.
        if rdn >= 253427
            AHdate = DateFromDayNumber(AH, rdn + 2)
            @test rd[6] == (AHdate[2], AHdate[3], AHdate[4])
            println(rdn, " ", jn, " -> ", CDateStr(AHdate))
        end
        println(rdn, " ", jn, " -> ", CDateStr(CEdate), " / ", CDateStr(IDdate))
        println(WeekDays[rd[2]], WeekDay(rdn))
    end
end
end

function ShowProfileYear()
    ProfileYearAsEuropean(EC, 2022, true) 
    ProfileYearAsEuropean(CE, 2022, true) 
    ProfileYearAsEuropean(JD, 2022, true) 
    ProfileYearAsEuropean(AM, 5783, true) 
    ProfileYearAsEuropean(AH, 1444, true) 
    ProfileYearAsEuropean(ID, 2022, true) 
end

function TestStartEndYear() 

    RHstart = [  # Dates for Rosh Hashana
    ((CE, 1842, 09, 05), (AM, 5603, 7, 1)),
    ((CE, 2020, 09, 19), (AM, 5781, 7, 1)),
    ((CE, 2021, 09, 07), (AM, 5782, 7, 1)),
    ((CE, 2022, 09, 26), (AM, 5783, 7, 1)),
    ((CE, 2023, 09, 16), (AM, 5784, 7, 1)),
    ((CE, 2024, 10, 03), (AM, 5785, 7, 1)),
    ((CE, 2025, 09, 23), (AM, 5786, 7, 1)),
    ((CE, 2026, 09, 12), (AM, 5787, 7, 1)),
    ((CE, 2027, 10, 02), (AM, 5788, 7, 1)),
    ((CE, 2043, 10, 05), (AM, 5804, 7, 1))
    ]

    RHend = [
    ((CE, 1843, 09, 24), (AM, 5603, 6, 29)),
    ((CE, 2021, 09, 06), (AM, 5781, 6, 29)),
    ((CE, 2022, 09, 25), (AM, 5782, 6, 29)),
    ((CE, 2023, 09, 15), (AM, 5783, 6, 29)),
    ((CE, 2024, 10, 02), (AM, 5784, 6, 29)),
    ((CE, 2025, 09, 22), (AM, 5785, 6, 29)),
    ((CE, 2026, 09, 11), (AM, 5786, 6, 29)),
    ((CE, 2027, 10, 01), (AM, 5787, 6, 29)),
    ((CE, 2028, 09, 20), (AM, 5788, 6, 29)),
    ((CE, 2044, 09, 21), (AM, 5804, 6, 29))
    ]

    @testset "RoshHashana" begin
    for rh in RHstart
        d = ConvertDate(rh[1], AM)
        @test rh[2] == d
    end
    for rh in RHend
        d = ConvertDate(rh[1], AM)
        @test rh[2] == d
    end
    end
end

function TestAll()
    TestDateGregorian(); println() 
    TestDateJulian();    println()
    TestDateHebrew();    println()
    TestDateIslamic();   println()
    TestDateIso();       println()
    TestIso();           println()
    TestConversions();   println()
    TestDateTables();    println()
    TestDuration();      println()
    TestJulianDayNumbers1(); println()
    TestJulianDayNumbers(); println()
    TestDayOfYear();     println()
    TestStartEndYear();  println()
    ShowDayOfYear();     println()
    ShowProfileYear();   println()
    TestToday();         println()
    # TestSaveCalendars()
end

TestAll()

