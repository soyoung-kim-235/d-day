import SwiftUI

/// [4단계] 디데이 추가 화면
/// 사용자가 새로운 디데이를 입력하는 화면입니다.
struct AddDDayView: View {
    // 창고 관리자를 전달받습니다.
    @ObservedObject var store: DDayStore
    
    // 현재 화면을 닫기 위한 변수 (iOS 15 이상 버전 방식)
    @Environment(\.dismiss) var dismiss
    
    // 입력받을 데이터들을 담는 임시 변수
    @State private var title: String = ""
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("디데이 정보")) {
                    // 제목 입력창
                    TextField("제목을 입력하세요 (예: 커플 기념일)", text: $title)
                    
                    // 날짜 선택기 (휠 스타일)
                    DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical) // 달력 모양으로 보여주기
                }
            }
            .navigationTitle("새 디데이 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss() // 화면 닫기
                    }
                }
                
                // 저장 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        // 제목이 비어있지 않을 때만 저장
                        if !title.isEmpty {
                            store.addItem(title: title, date: selectedDate)
                            dismiss() // 저장 후 화면 닫기
                        }
                    }
                    .disabled(title.isEmpty) // 제목 안 쓰면 버튼 비활성화
                }
            }
        }
    }
}

struct AddDDayView_Previews: PreviewProvider {
    static var previews: some View {
        AddDDayView(store: DDayStore())
    }
}
