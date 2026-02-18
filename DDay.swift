import Foundation

/// [1단계] DDay 모델 정의
/// 디데이 앱에서 사용할 '데이터의 형식'을 정의하는 파일입니다.
struct DDay: Identifiable, Codable {
    var id: UUID = UUID() // 각 디데이를 구별하기 위한 고유 아이디
    var title: String      // 디데이 제목 (예: 생일, 커플 기념일)
    var date: Date        // 목표 날짜
    
    // 왜 이렇게 짰나요?
    // 1. Identifiable: 리스트에 뿌려줄 때 "얘가 그 애구나"라고 앱이 인식하게 해줍니다.
    // 2. Codable: 나중에 UserDefaults에 저장할 때 데이터를 변환하기 쉽게 해줍니다.
}

extension DDay {
    /// 오늘 날짜로부터 며칠이 남았는지 계산하는 함수입니다.
    /// 위젯에서도 이 함수만 호출하면 되도록 모델 안에 만들었습니다.
    func daysFromToday() -> Int {
        let calendar = Calendar.current
        
        // 날짜 부분만 추출 (시/분/초 제외)
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTargetDate = calendar.startOfDay(for: self.date)
        
        // 두 날짜 사이의 '일(day)' 차이 계산
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTargetDate)
        
        return components.day ?? 0
    }
    
    /// 화면에 보여줄 디데이 텍스트 (예: D-10, D-Day, D+5)
    var dDayText: String {
        let days = daysFromToday()
        
        if days == 0 {
            return "D-Day"
        } else if days > 0 {
            return "D-\(days)"
        } else {
            return "D+\(abs(days))"
        }
    }
}
