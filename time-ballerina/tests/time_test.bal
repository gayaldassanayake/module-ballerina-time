// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/jballerina.java;


@test:Config {}
function testCurrentTime() {
    Time time = currentTime();
    int timeValue = time.time;
    test:assertTrue(timeValue > 1498621376460);
}

@test:Config {}
function testNanoTime() {
     int nt = nanoTime();
     int ntime = systemNanoTime();
     test:assertTrue(nt > 0, "nanoTime returned should be greater than zero");
     test:assertTrue(nt < ntime, "nanoTime returned should be less than the current system nano time");
}

@test:Config {}
function testCreateTimeWithZoneID() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382000, zone: zoneValue };
    int timeValue = time.time;
    string zoneId = time.zone.id;
    int zoneoffset = time.zone.offset;
    test:assertEquals(timeValue, 1498488382000);
    test:assertEquals(zoneId, "America/Panama");
}

@test:Config {}
function testCreateTimeWithOffset() {
    TimeZone zoneValue = {id:"-05:00"};
    Time time = { time: 1498488382000, zone: zoneValue };
    int timeValue = time.time;
    string zoneId = time.zone.id;
    test:assertEquals(timeValue, 1498488382000);
    test:assertEquals(zoneId, "-05:00");
}

@test:Config {}
function testCreateTimeWithNoZone() {
    TimeZone zoneValue = {id:""};
    Time time = { time: 1498488382000, zone: zoneValue };
    int timeValue = time.time;
    test:assertEquals(timeValue, 1498488382000);
}

@test:Config {}
function testParseTime() {
    var timeRet = parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (timeRet is Time) {
        test:assertEquals(timeRet.time, 1498488382444);
        test:assertEquals(timeRet.zone.id, "-05:00");
        test:assertEquals(timeRet.zone.offset, -18000);
    } else {
        test:assertFail("Error parsing time!");
    }
}

@test:Config {}
function testParseTimeWithTimePartOnly() {
    var timeRet = parse("09:46:22", "HH:mm:ss");
    if (timeRet is Time) {
        test:assertTrue(timeRet.time > 0);
        string|Error formattedRet = format(timeRet, "HH:mm:ss");
        if (formattedRet is string) {
            test:assertEquals(formattedRet, "09:46:22");
        } else {
            test:assertFail("Error formatting time!");
        }
    } else {
        test:assertFail("Error parsing time!");
    }
}

@test:Config {}
function testParseRFC1123Time() {
    var timeRet = parse("Wed, 28 Mar 2018 11:56:23 +0530", RFC_1123_DATE_TIME);
    if (timeRet is Time) {
        test:assertEquals(timeRet.time, 1522218383000);
        test:assertEquals(timeRet.zone.id, "+05:30");
        test:assertEquals(timeRet.zone.offset, 19800);
    } else {
        test:assertFail("Error parsing time!");
    }
}

@test:Config {}
function testCreateDateTime() {
    var  retTime = createTime(2017, 3, 28, 23, 42, 45, 554, "America/Panama");
    if (retTime is Time) {
        string|Error timeValue = toString(retTime);
        test:assertEquals(timeValue, "2017-03-28T23:42:45.554-05:00");
    } else {
        test:assertFail("Error creating time!");
    }
}

@test:Config {}
function testCreateDateTimeWithInvalidZone() {
    var retTime = createTime(2017, 3, 28, 23, 42, 45, 554, "TEST");
    if (retTime is Error) {
        test:assertTrue(retTime.message().includes("Invalid timezone id: TEST"));
    } else {
        test:assertFail("Invalid time created!");
    }
}

@test:Config {}
function testToStringWithCreateTime() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382000, zone: zoneValue };
    string|Error timetoStr = toString(time);
    test:assertEquals(timetoStr, "2017-06-26T09:46:22-05:00");
}

@test:Config {}
function testFormatTime() {
    string retValue = "";
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382444, zone: zoneValue };
    var ret =  format(time, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (ret is string ) {
        retValue = ret;
        test:assertEquals(ret, "2017-06-26T09:46:22.444-0500");
    } else {
        test:assertFail("Error formatting time!");
    }
}

@test:Config {}
function testFormatTimeToRFC1123() {
    string retValue = "";
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382444, zone: zoneValue };
    var ret = format(time, RFC_1123_DATE_TIME);
    if (ret is string ) {
        retValue = ret;
        test:assertEquals(ret, "Mon, 26 Jun 2017 09:46:22 -0500");
    } else {
        test:assertFail("Error formatting time!");
    }
}

@test:Config {}
function testGetFunctions() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1456876583555, zone: zoneValue };
    int|Error year = getYear(time);
    int|Error month = getMonth(time);
    int|Error day = getDay(time);
    int|Error hour = getHour(time);
    int|Error minute = getMinute(time);
    int|Error second = getSecond(time);
    int|Error milliSecond = getMilliSecond(time);
    DayOfWeek|Error weekday = getWeekday(time);
    test:assertEquals(year, 2016);
    test:assertEquals(month, 3);
    test:assertEquals(day, 1);
    test:assertEquals(hour, 18);
    test:assertEquals(minute, 56);
    test:assertEquals(second, 23);
    test:assertEquals(milliSecond, 555);
    test:assertEquals(weekday, "TUESDAY");
}

@test:Config {}
function testGetDateFunction() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1456876583555, zone: zoneValue };
    [int, int, int]|Error date = getDate(time);
    if (date is Error) {
        test:assertFail("Error retrieving date");
    } else {
        test:assertEquals(date[0], 2016);
        test:assertEquals(date[1], 3);
        test:assertEquals(date[2], 1);
    }
}

@test:Config {}
function testGetTimeFunction() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1456876583555, zone: zoneValue };
    [int, int, int, int]|Error timeVal = getTime(time);
    if (timeVal is Error) {
        test:assertFail("Error retrieving time");
    } else {
        test:assertEquals(timeVal[0], 18);
        test:assertEquals(timeVal[1], 56);
        test:assertEquals(timeVal[2], 23);
        test:assertEquals(timeVal[3], 555);
    }
}

@test:Config {}
function testAddDuration() {
    var timeRet = parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (timeRet is Time) {
        Duration d = {
                years: 1,
                months: 1,
                days: 1,
                hours: 1,
                minutes: 1,
                seconds: 1,
                milliSeconds: 1
            };
        Time|Error timeAdded = addDuration(timeRet, d);
        if (timeAdded is Time) {
            var retStr = format(timeAdded, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
            if (retStr is string) {
                test:assertEquals(retStr, "2018-07-27T10:47:23.445-0500");
            } else {
                test:assertFail("Error formatting time");
            }
        } else {
            test:assertFail("Error adding duration");
        }
    } else {
        test:assertFail("Error parsing time");
    }
}

@test:Config {}
function testSubtractDuration() {
    var timeRet = parse("2016-03-01T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (timeRet is Time) {
        Duration d = {
                years: 1,
                months: 1,
                days: 1,
                hours: 1,
                minutes: 1,
                seconds: 1,
                milliSeconds: 1
            };
        Time|Error timeSubs = subtractDuration(timeRet, d);
        if (timeSubs is Time) {
            var retStr = format(timeSubs, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
            if (retStr is string) {
                test:assertEquals(retStr, "2015-01-31T08:45:21.443-0500");
            } else {
                test:assertFail("Error formatting time");
            }
        } else {
            test:assertFail("Error subtracting duration");
        }
    } else {
        test:assertFail("Error parsing time");
    }
}

@test:Config {}
function testToTimezone() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1456876583555, zone: zoneValue };
    string|Error timeStrBefore = toString(time);
    var retTime = toTimeZone(time, "Asia/Colombo");
    if (retTime is Time) {
        string|Error timeStrAfter = toString(time);
        test:assertEquals(timeStrBefore, "2016-03-01T18:56:23.555-05:00");
        test:assertEquals(timeStrAfter, "2016-03-02T05:26:23.555+05:30");
    } else {
        test:assertFail("Error creating time");
    }

}

@test:Config {}
function testToTimezoneWithInvalidZone() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1456876583555, zone: zoneValue };
    var retTime = toTimeZone(time, "test");
    if (retTime is Time) {
        test:assertFail("Invalid time created");
    } else {
        test:assertTrue(retTime.message().includes("Invalid timezone id: test"));
    }
}

@test:Config {}
function testToTimezoneWithDateTime() {
    var timeRet = parse("2016-03-01T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (timeRet is Time) {
        var newTime = toTimeZone(timeRet, "Asia/Colombo");
        if (newTime is Time) {
            var retStr = format(newTime, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
            if (retStr is string) {
                test:assertEquals(retStr, "2016-03-01T20:16:22.444+0530");
            } else {
                test:assertFail("Error formatting time");
            }
        } else {
            test:assertFail("Error creating timezone");
        }
    } else {
        test:assertFail("Error parsing time");
    }
}

@test:Config {}
function testManualTimeCreate() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382000, zone: zoneValue };
    string|Error timeStr = toString(time);
    test:assertEquals(timeStr, "2017-06-26T09:46:22-05:00");
}

@test:Config {}
function testManualTimeCreateWithNoZone() {
    TimeZone zoneValue = {id:""};
    Time time = { time: 1498488382555, zone: zoneValue };
    int|Error year = getYear(time);
    test:assertEquals(year, 2017);
}

@test:Config {}
function testManualTimeCreateWithEmptyZone() {
    TimeZone zoneValue = {id:""};
    Time time = { time: 1498488382555, zone: zoneValue };
    int|Error year = getYear(time);
    test:assertEquals(year, 2017);
}

@test:Config {}
function testManualTimeCreateWithInvalidZone() {
    TimeZone zoneValue = {id:"test"};
    Time time = { time: 1498488382555, zone: zoneValue };
    int|Error year = getYear(time);
    if (year is Error) {
        test:assertTrue(year.message().includes("Invalid timezone id: test"));
    }
}

@test:Config {}
function testParseTimeValidPattern() {
    var timeRet = parse("2017-06-26T09:46:22.444-0500", "test");
    if (timeRet is Error) {
        test:assertTrue(timeRet.message().includes("Invalid pattern: test"));
    } else {
        test:assertFail("Invalid time created!");
    }

}

@test:Config {}
function testParseTimeFormatMismatch() {
    var timeRet = parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd");
    int timeValue = 0;
    string zoneId = "";
    int zoneoffset = 0;
    if (timeRet is Error) {
        test:assertTrue(timeRet.message().includes("could not be parsed"));
    } else {
        test:assertFail("Invalid time created!");
    }
}

@test:Config {}
function testFormatTimeInvalidPattern() {
    TimeZone zoneValue = {id:"America/Panama"};
    Time time = { time: 1498488382444, zone: zoneValue };
    string|Error fmtTime = format(time, "test");
    if (fmtTime is Error) {
        test:assertTrue(fmtTime.message().includes("Invalid Pattern: test"));
    } else {
        test:assertFail("Invalid time created!");
    }
}

@test:Config {}
function testParseTimeWithDifferentFormats() {
    int|Error year = 0;
    int|Error month = 0;
    int|Error day = 0;
    int|Error hour = 0;
    int|Error minute = 0;
    int|Error second = 0;
    int|Error milliSecond = 0;
    string dateStr = "";
    string dateZoneStr = "";
    string timeZoneStr = "";
    string datetimeStr = "";

    var timeRet = parse("2017", "yyyy");
    if (timeRet is Time) {
        year = getYear(timeRet);
    }
    timeRet = parse("03", "MM");
    if (timeRet is Time) {
        month = getMonth(timeRet);
    }
    timeRet = parse("31", "dd");
    if (timeRet is Time) {
        day = getDay(timeRet);
    }
    timeRet = parse("16", "HH");
    if (timeRet is Time) {
        hour = getHour(timeRet);
    }
    timeRet = parse("59", "mm");
    if (timeRet is Time) {
        minute = getMinute(timeRet);
    }
    timeRet = parse("58", "ss");
    if (timeRet is Time) {
        second = getSecond(timeRet);
    }
    timeRet = parse("999", "SSS");
    if (timeRet is Time) {
        milliSecond = getMilliSecond(timeRet);
    }
    timeRet = parse("2017/09/23", "yyyy/MM/dd");
    if (timeRet is Time) {
        var retStr = format(timeRet, "yyyy-MM-dd");
        if (retStr is string) {
            dateStr = retStr;
        }
    }
    timeRet = parse("2015/02/15+0800", "yyyy/MM/ddZ");
    if (timeRet is Time) {
        var retStr = format(timeRet, "yyyy-MM-ddZ");
        if (retStr is string) {
            dateZoneStr = retStr;
        }
    }
    timeRet = parse("08/23/59.544+0700", "HH/mm/ss.SSSZ");
    if (timeRet is Time) {
        var retStr = format(timeRet, "HH-mm-ss-SSS:Z");
        if (retStr is string) {
            timeZoneStr = retStr;
        }
    }
    timeRet = parse("2014/05/29-23:44:59.544", "yyyy/MM/dd-HH:mm:ss.SSS");
    if (timeRet is Time) {
        var retStr = format(timeRet, "yyyy-MM-dd-HH:mm:ss.SSS");
        if (retStr is string) {
            datetimeStr = retStr;
        }
    }
    test:assertEquals(year, 2017);
    test:assertEquals(month, 3);
    test:assertEquals(day, 31);
    test:assertEquals(hour, 16);
    test:assertEquals(minute, 59);
    test:assertEquals(second, 58);
    test:assertEquals(milliSecond, 999);
    test:assertEquals(dateStr, "2017-09-23");
    test:assertEquals(dateZoneStr, "2015-02-15+0800");
    test:assertEquals(timeZoneStr, "08-23-59-544:+0700");
    test:assertEquals(datetimeStr, "2014-05-29-23:44:59.544");
}

@test:Config {}
function testGetDifference() {
    Time|Error timeone = createTime(2020, 1,1);
    Time|Error timetwo = createTime(2021, 1,1);
    if (timeone is Time && timetwo is Time) {
        Duration|Error delta = getDifference(timeone, timetwo);
        if (delta is Duration) {
            test:assertEquals(delta.years, 1);
        } else {
            test:assertFail("Error obtaining difference. " + delta.message());
        }
    } else {
        test:assertFail("Error creating time to obtain difference!");
    }
}

@test:Config {}
function testGetTimezones() {
    string[] zones = getTimezones(-36000000);
    test:assertEquals(zones.indexOf("Pacific/Honolulu"), 4);
}

 function systemNanoTime() returns int = @java:Method {
     name: "nanoTime",
     'class:"java.lang.System"
 } external;

