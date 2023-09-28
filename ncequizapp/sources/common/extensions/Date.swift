import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.compare(self, to: Date(), toGranularity: .day) == .orderedSame
    }
    var midnight:Date{
        let cal = Calendar(identifier: .gregorian)
        let nextday = Calendar.current.date(byAdding: .day, value: 1, to: self)!
        let midnightDate = cal.startOfDay(for: nextday)
        
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let correctedMidnightDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: midnightDate) else {return Date()}
        
        return correctedMidnightDate
    }
    var localDate: Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        
        return localDate
    }
    
    func daysBetween(date: Date) -> Int {
        abs(Calendar.current.dateComponents([.day], from: self, to: date).day!)
    }
    
    func addDays(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func addMinutes(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func addHours(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    func isPastMidnight() -> Bool {
        return Date().localDate > self.midnight
    }
    
    func getDateComponents()  -> DateComponents{
        return Calendar.current.dateComponents([.minute, .hour, .day, .year, .month], from: self)
    }
    
    func isBetween(_ start: Date, _ end: Date) -> Bool {
        start...end ~= self
    }
}
