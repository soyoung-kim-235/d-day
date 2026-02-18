import Foundation
import SwiftUI
import WidgetKit // 위젯 새로고침을 위해 필요합니다.

/// [2단계] 데이터 저장소 구현
/// 앱의 데이터를 폰에 저장하고, 다시 불러오는 '창고' 역할을 하는 클래스입니다.
class DDayStore: ObservableObject {
    // 앱 전체에서 이 리스트를 관찰(Observe)하여 화면을 자동으로 업데이트합니다.
    @Published var items: [DDay] = [] {
        didSet {
            // 리스트 내용이 바뀔 때마다 자동으로 저장합니다.
            saveItems()
        }
    }
    
    // 데이터 저장 위치의 이름 (열쇠 이름)
    private let saveKey = "dday_list"
    
    // 중요: 앱과 위젯이 데이터를 공유하기 위한 그룹 ID입니다.
    // 'group.com.yourname.dday' 형식으로 나중에 Xcode에서 설정해야 합니다.
    private let appGroupID = "group.com.soyoung.dday" 
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    init() {
        // 앱이 시작될 때 저장된 데이터를 불러옵니다.
        loadItems()
    }
    
    /// 데이터를 폰(App Group 공유 영역)에 저장합니다.
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            sharedDefaults?.set(encoded, forKey: saveKey)
            
            // 위젯에게 데이터가 바뀌었으니 새로고침하라고 알려줍니다.
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    /// 저장된 데이터를 불러옵니다.
    private func loadItems() {
        if let data = sharedDefaults?.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([DDay].self, from: data) {
            self.items = decoded
        }
    }
    
    /// 새로운 디데이를 추가합니다.
    func addItem(title: String, date: Date) {
        let newItem = DDay(title: title, date: date)
        items.append(newItem)
    }
    
    /// 특정 위치의 디데이를 삭제합니다.
    func deleteItem(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
}
