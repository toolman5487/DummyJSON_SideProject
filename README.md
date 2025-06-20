專案說明
DummyJSONProject 是一個示範性購物平台 App，使用 Swift + UIKit + MVVM + Combine 架構，串接 DummyJSON API，並搭配 SnapKit、SDWebImage 等常用第三方套件。

目前已實作並驗證的功能包括：

	1.	使用者驗證
	•	使用 DummyJSON 提供的 /auth/login 完成 JWT 登入，取得 accessToken、refreshToken
	•	自動刷新過期的 Token，並可在 app 重啟時維持登入狀態
	•	登出功能：清除 Token 並回到登入畫面
 
	2.	商品清單（Products）
	•	使用 Combine 與 Protocol 注入方式，透過 ProductService 拿取產品列表
	•	支援分頁查詢（limit + skip），並在 UI 端具備 Pull-to-Refresh 與右上按鈕刷新功能
	•	TableView 動態高度、自動計算，顯示縮略圖、名稱、描述、價格、庫存等資訊
 
	3.	商品詳情（Product Detail）
	•	以 UITableView + tableHeaderView 呈現商品大圖、標題、詳細描述、價格、庫存、評分
	•	底部浮貼「查看評論」按鈕，點擊後以 iOS 15+ pageSheet 形式彈出評論清單
	•	使用建構子注入 (init(product: ProductModel), init(reviews: [ProductReview])) 傳遞資料，確保初始化時即有完整模型
 
	4.	評論模組（Reviews）
	•	ReviewsViewController 繼承 UITableViewController，使用自訂 ReviewTableViewCell 列表呈現
	•	支援半高、全高兩種 detent，可拖曳切換顯示，並顯示抓手提示器
 
	5.	使用者資訊（Profile）
	•	UsersViewController 顯示會員資料：頭像（圓形＋邊框）、使用者名稱、全名、Email
	•	無資料時提供預設佔位文字與圖片
	•	可點選「登出」按鈕清除 Token，並回到登入頁面
 
	6.	技術棧與架構
	•	語言／UI：Swift 5 + UIKit + SnapKit
	•	架構：MVVM + Combine + Protocol-Oriented（Service + ViewModel）
	•	第三方套件：
	•	SDWebImage：非同步載入與快取圖片
	•	CombineCocoa（未來擴充）
	•	版本管理：所有 API 統一由 APIConfig.baseURL 動態組合，易於切換環境
