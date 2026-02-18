import SwiftUI

/// [3단계] 메인 리스트 화면
/// 저장된 디데이들을 리스트 형태로 보여주는 메인 화면입니다.
struct ContentView: View {
    // 우리가 만든 '창고 관리자'를 불러옵니다.
    @StateObject var store = DDayStore()
    
    // 새 디데이를 추가하는 화면을 띄울지 결정하는 변수
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                // 저장된 디데이들을 하나씩 꺼내서 보여줍니다.
                ForEach(store.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // 디데이 계산 결과 표시 (D-Day, D-10 등)
                        Text(item.dDayText)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
                // 옆으로 밀어서 삭제하는 기능
                .onDelete(perform: store.deleteItem)
            }
            .navigationTitle("내 디데이")
            .toolbar {
                // 상단 우측에 '+' 버튼 추가
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 4단계에서 구현할 '추가 화면'을 띄웁니다.
                        showingAddView = true 
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            // 4단계에서 만든 화면을 여기에 연결했습니다!
            .sheet(isPresented: $showingAddView) {
                AddDDayView(store: store)
            }
        }
    }
}

// 미리보기 화면
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
