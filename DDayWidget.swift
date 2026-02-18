import WidgetKit
import SwiftUI

/// [6단계] 홈 화면 위젯 구현
/// 앱에서 저장된 디데이를 위젯에 보여주는 코드입니다.

struct Provider: TimelineProvider {
    // 위젯이 처음 보일 때나 가짜 데이터를 보여줄 때 사용
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dday: DDay(title: "생일", date: Date()))
    }

    // 위젯 선택 화면에서 미리보기로 보여줄 때
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dday: DDay(title: "생일", date: Date()))
        completion(entry)
    }

    // 실제로 위젯을 그리기 위한 데이터를 가져올 때
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // 앱 그룹에서 저장된 데이터 불러오기
        let saveKey = "dday_list"
        let appGroupID = "group.com.soyoung.dday"
        let defaults = UserDefaults(suiteName: appGroupID)
        
        var firstDDay: DDay? = nil
        if let data = defaults?.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([DDay].self, from: data) {
            // 가장 첫 번째 디데이를 보여줍니다.
            firstDDay = decoded.first
        }

        let entry = SimpleEntry(date: Date(), dday: firstDDay)
        
        // 1시간마다 위젯을 업데이트하도록 설정
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// 위젯에 전달될 데이터 모델
struct SimpleEntry: TimelineEntry {
    let date: Date
    let dday: DDay?
}

// 위젯의 디자인(UI)
struct DDayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let dday = entry.dday {
                Text(dday.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(dday.dDayText)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            } else {
                Text("디데이를 추가해주세요")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// 위젯 설정
struct DDayWidget: Widget {
    let kind: String = "DDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("디데이 위젯")
        .description("가장 가까운 디데이를 보여줍니다.")
        .supportedFamilies([.systemSmall]) // 작은 사이즈 위젯만 지원
    }
}

struct DDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        DDayWidgetEntryView(entry: SimpleEntry(date: Date(), dday: DDay(title: "축하해!", date: Date())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
