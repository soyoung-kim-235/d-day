import Foundation
import SwiftUI

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
    
    init() {
        // 앱이 시작될 때 저장된 데이터를 불러옵니다.
        loadItems()
    }
    
    /// 데이터를 폰(UserDefaults)에 저장합니다.
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    /// 저장된 데이터를 불러옵니다.
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
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
