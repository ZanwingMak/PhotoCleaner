//
//  L10n.swift
//  翻译字典：中文作 key，提供英 / 日 / 韩 翻译
//

import Foundation

enum L10n {
    static let dict: [String: [AppLanguage: String]] = [
        // 通用
        "RollKeep": [.zh: "RollKeep", .en: "RollKeep", .ja: "RollKeep", .ko: "RollKeep"],
        "整理你的照片库，腾出存储空间": [.en: "Tidy your photo library, free up space", .ja: "写真ライブラリを整理して空き容量を確保", .ko: "사진 라이브러리 정리, 저장 공간 확보"],

        // 退出确认
        "有 %d 张待删除": [
            .en: "%d Pending Delete",
            .ja: "削除予定 %d 枚",
            .ko: "삭제 대기 %d 장"
        ],
        "有待删除的照片未处理。继续退出会清空当前选择。": [
            .en: "You have unprocessed photos pending delete. Exiting will discard them.",
            .ja: "未処理の削除予定があります。退出すると選択がクリアされます。",
            .ko: "처리되지 않은 삭제 대기 사진이 있습니다. 종료하면 선택이 사라집니다."
        ],
        "继续审核": [
            .en: "Keep Reviewing",
            .ja: "続けて確認",
            .ko: "계속 검토"
        ],
        "点错了": [
            .en: "Misclicked",
            .ja: "誤タップ",
            .ko: "잘못 눌렀음"
        ],
        "放弃并退出": [
            .en: "Discard & Exit",
            .ja: "破棄して退出",
            .ko: "버리고 나가기"
        ],
        "刷新": [
            .en: "Refresh",
            .ja: "更新",
            .ko: "새로고침"
        ],
        "关闭": [.en: "Close", .ja: "閉じる", .ko: "닫기"],
        "取消": [.en: "Cancel", .ja: "キャンセル", .ko: "취소"],
        "确认": [.en: "Confirm", .ja: "確認", .ko: "확인"],
        "返回": [.en: "Back", .ja: "戻る", .ko: "뒤로"],
        "保留": [.en: "Keep", .ja: "保留", .ko: "유지"],
        "删除": [.en: "Delete", .ja: "削除", .ko: "삭제"],
        "撤销": [.en: "Undo", .ja: "取り消し", .ko: "되돌리기"],
        "信息": [.en: "Info", .ja: "情報", .ko: "정보"],
        "分享": [.en: "Share", .ja: "共有", .ko: "공유"],
        "张": [.en: " items", .ja: "枚", .ko: "장"],

        // Tab Bar
        "整理": [.en: "Sort", .ja: "整理", .ko: "정리"],
        "照片": [.en: "Photos", .ja: "写真", .ko: "사진"],
        "相簿": [.en: "Albums", .ja: "アルバム", .ko: "앨범"],
        "更多": [.en: "More", .ja: "もっと", .ko: "더보기"],

        // 问候
        "早上好": [.en: "Good Morning", .ja: "おはよう", .ko: "좋은 아침"],
        "中午好": [.en: "Good Noon", .ja: "こんにちは", .ko: "안녕하세요"],
        "下午好": [.en: "Good Afternoon", .ja: "こんにちは", .ko: "좋은 오후"],
        "晚上好": [.en: "Good Evening", .ja: "こんばんは", .ko: "좋은 저녁"],
        "夜深了": [.en: "It's late", .ja: "夜更け", .ko: "밤이 깊었어요"],

        // 首页
        "潜在可释放": [.en: "Reclaimable", .ja: "解放可能", .ko: "확보 가능"],
        "智能建议": [.en: "Smart Picks", .ja: "おすすめ", .ko: "스마트 추천"],
        "先清这些最划算": [.en: "Best value to clean first", .ja: "ここから片付けるのがお得", .ko: "여기부터 정리하면 효율적"],
        "左右滑动": [.en: "Swipe", .ja: "スワイプ", .ko: "스와이프"],
        "陈年截图": [.en: "Old Screenshots", .ja: "古いスクショ", .ko: "오래된 스크린샷"],
        "占空间大户": [.en: "Storage Hogs", .ja: "容量の大物", .ko: "용량 차지"],
        "视频清理": [.en: "Clean Videos", .ja: "動画整理", .ko: "동영상 정리"],
        "自拍清理": [.en: "Clean Selfies", .ja: "自撮り整理", .ko: "셀카 정리"],
        "低清图片": [.en: "Low-res Images", .ja: "低解像度画像", .ko: "저해상도 이미지"],
        "时间游戏": [.en: "Time Lens", .ja: "時間の遊び", .ko: "시간 놀이"],
        "换个角度看你的相册": [.en: "See your library differently", .ja: "別の角度から見る", .ko: "다른 각도로 보기"],
        "分类": [.en: "Categories", .ja: "カテゴリ", .ko: "분류"],
        "时间线": [.en: "Timeline", .ja: "タイムライン", .ko: "타임라인"],
        "按月份回顾": [.en: "Review by month", .ja: "月別に見る", .ko: "월별 보기"],
        "显示全部": [.en: "Show All", .ja: "すべて表示", .ko: "전체 보기"],
        "显示全部时间线": [.en: "Show Full Timeline", .ja: "タイムラインをすべて表示", .ko: "전체 타임라인 보기"],

        // 快速合集
        "随机": [.en: "Random", .ja: "ランダム", .ko: "랜덤"],
        "本周": [.en: "This Week", .ja: "今週", .ko: "이번 주"],
        "这一天": [.en: "On This Day", .ja: "今日", .ko: "오늘"],
        "去年": [.en: "Last Year", .ja: "去年", .ko: "작년"],

        // 分类
        "全部照片": [.en: "All Photos", .ja: "すべての写真", .ko: "모든 사진"],
        "全部": [.en: "All", .ja: "すべて", .ko: "전체"],
        "收藏": [.en: "Favorites", .ja: "お気に入り", .ko: "즐겨찾기"],
        "视频": [.en: "Videos", .ja: "ビデオ", .ko: "동영상"],
        "截图": [.en: "Screenshots", .ja: "スクリーンショット", .ko: "스크린샷"],
        "实况照片": [.en: "Live Photos", .ja: "Live Photos", .ko: "라이브 사진"],
        "最近添加": [.en: "Recents", .ja: "最近の項目", .ko: "최근 항목"],
        "自拍": [.en: "Selfies", .ja: "自撮り", .ko: "셀카"],
        "相机原图": [.en: "Camera Originals", .ja: "カメラ原画", .ko: "카메라 원본"],
        "社交媒体": [.en: "Social Media", .ja: "SNS", .ko: "소셜 미디어"],
        "横屏照片": [.en: "Landscape", .ja: "横向き", .ko: "가로 사진"],
        "竖屏照片": [.en: "Portrait", .ja: "縦向き", .ko: "세로 사진"],
        "大文件": [.en: "Large Files", .ja: "大容量ファイル", .ko: "큰 파일"],
        "所有未整理": [.en: "All Unsorted", .ja: "未整理すべて", .ko: "정리 안 됨"],
        "未整理的视频": [.en: "Unsorted Videos", .ja: "未整理ビデオ", .ko: "정리 안 된 동영상"],
        "未整理的截图": [.en: "Unsorted Screenshots", .ja: "未整理スクショ", .ko: "정리 안 된 스크린샷"],

        // 滑动审核
        "前一张": [.en: "Previous", .ja: "前へ", .ko: "이전"],
        "下一张": [.en: "Next", .ja: "次へ", .ko: "다음"],
        "加入待删除": [.en: "Mark Delete", .ja: "削除へ", .ko: "삭제 대기"],
        "已加入待删除": [.en: "Added to Delete", .ja: "削除に追加", .ko: "삭제에 추가됨"],
        "这个分类没有照片": [.en: "No photos in this category", .ja: "このカテゴリは空", .ko: "이 분류에 사진 없음"],
        "换一个分类试试": [.en: "Try another category", .ja: "別のカテゴリへ", .ko: "다른 분류를 시도"],
        "已审核完成": [.en: "Review Complete", .ja: "確認完了", .ko: "검토 완료"],
        "没有标记任何照片待删除。": [.en: "No photos marked for deletion.", .ja: "削除予定はありません。", .ko: "삭제 표시된 사진 없음."],
        "查看待删除列表": [.en: "View Delete List", .ja: "削除リストを見る", .ko: "삭제 목록 보기"],
        "切换分类": [.en: "Switch Category", .ja: "カテゴリ切替", .ko: "분류 전환"],
        "快速合集": [.en: "Quick Sets", .ja: "クイック集", .ko: "빠른 모음"],
        "智能分类": [.en: "Smart Categories", .ja: "スマート分類", .ko: "스마트 분류"],
        "系统相册": [.en: "System Albums", .ja: "システム", .ko: "시스템 앨범"],

        // 待删除
        "待删除": [.en: "Pending Delete", .ja: "削除予定", .ko: "삭제 대기"],
        "暂无待删除照片": [.en: "No photos to delete", .ja: "削除予定なし", .ko: "삭제할 사진 없음"],
        "上滑照片可加入此列表": [.en: "Swipe up to add", .ja: "上スワイプで追加", .ko: "위로 스와이프하여 추가"],
        "可释放": [.en: "Free up", .ja: "解放", .ko: "확보"],
        "确认删除": [.en: "Confirm Delete", .ja: "削除確認", .ko: "삭제 확인"],
        "删除中…": [.en: "Deleting…", .ja: "削除中…", .ko: "삭제 중…"],

        // 设置
        "设置": [.en: "Settings", .ja: "設定", .ko: "설정"],
        "外观": [.en: "Appearance", .ja: "外観", .ko: "외관"],
        "主题": [.en: "Theme", .ja: "テーマ", .ko: "테마"],
        "语言": [.en: "Language", .ja: "言語", .ko: "언어"],
        "跟随系统": [.en: "System", .ja: "システム", .ko: "시스템"],
        "深色": [.en: "Dark", .ja: "ダーク", .ko: "다크"],
        "浅色": [.en: "Light", .ja: "ライト", .ko: "라이트"],
        "焦糖暖": [.en: "Caramel", .ja: "キャラメル", .ko: "카라멜"],
        "冷色调": [.en: "Cool", .ja: "クール", .ko: "쿨"],

        "浏览体验": [.en: "Experience", .ja: "体験", .ko: "사용 경험"],
        "触觉反馈": [.en: "Haptics", .ja: "触覚フィードバック", .ko: "햅틱"],
        "高清缩略图": [.en: "HD Thumbnails", .ja: "高画質サムネイル", .ko: "고화질 썸네일"],
        "删除前二次确认": [.en: "Confirm Before Delete", .ja: "削除前に確認", .ko: "삭제 전 확인"],

        "数据": [.en: "Data", .ja: "データ", .ko: "데이터"],
        "已扫描照片": [.en: "Scanned Photos", .ja: "スキャン済み", .ko: "스캔됨"],
        "重新扫描分类": [.en: "Rescan Categories", .ja: "再スキャン", .ko: "재스캔"],
        "正在扫描…": [.en: "Scanning…", .ja: "スキャン中…", .ko: "스캔 중…"],
        "扫描完成": [.en: "Scan Complete", .ja: "スキャン完了", .ko: "스캔 완료"],

        "关于": [.en: "About", .ja: "について", .ko: "정보"],
        "版本": [.en: "Version", .ja: "バージョン", .ko: "버전"],
        "GitHub 仓库": [.en: "GitHub Repo", .ja: "GitHub", .ko: "GitHub"],
        "反馈问题": [.en: "Report Issue", .ja: "問題報告", .ko: "문제 신고"],
        "更新日志": [.en: "Changelog", .ja: "更新履歴", .ko: "변경 사항"],
        "赞助支持": [.en: "Sponsor", .ja: "スポンサー", .ko: "후원"],
        "扫码赞助": [.en: "Scan to sponsor", .ja: "スキャンして支援", .ko: "스캔하여 후원"],
        "微信赞赏码": [.en: "WeChat Reward Code", .ja: "WeChat 投げ銭コード", .ko: "WeChat 후원 코드"],
        "支付宝": [.en: "Alipay", .ja: "Alipay", .ko: "Alipay"],
        "发现新版本 %@": [
            .en: "Update available · %@",
            .ja: "新バージョン %@ あり",
            .ko: "새 버전 %@ 사용 가능"
        ],
        "查看更新": [.en: "Tap to view release", .ja: "リリースを見る", .ko: "릴리스 보기"],

        // 隐私
        "RollKeep 在本地处理你的所有照片\n绝不上传任何数据": [
            .en: "RollKeep handles all photos on-device.\nNothing is uploaded.",
            .ja: "RollKeep はすべて端末内で処理\nアップロードは一切しません",
            .ko: "RollKeep는 모든 사진을 기기에서 처리\n업로드 전혀 없음"
        ],

        // 权限页
        "整理你的照片库": [.en: "Tidy Your Photos", .ja: "写真を整理", .ko: "사진 정리"],
        "快速滑动审核每张照片，腾出存储空间。\n所有删除操作都需要你手动确认。": [
            .en: "Swipe through each photo to reclaim space.\nAll deletions need your confirmation.",
            .ja: "スワイプで写真を確認し、容量を解放。\n削除は必ず手動で確認します。",
            .ko: "스와이프로 각 사진을 검토하고 공간 확보.\n삭제는 수동 확인이 필요합니다."
        ],
        "允许访问照片": [.en: "Allow Photo Access", .ja: "写真へのアクセスを許可", .ko: "사진 접근 허용"],
        "无法访问照片": [.en: "Photo Access Denied", .ja: "アクセス不可", .ko: "사진 접근 불가"],
        "打开设置": [.en: "Open Settings", .ja: "設定を開く", .ko: "설정 열기"],

        // 照片浏览
        "查看大图": [.en: "View Full Size", .ja: "拡大表示", .ko: "크게 보기"],
        "照片信息": [.en: "Photo Info", .ja: "写真情報", .ko: "사진 정보"],
        "在 照片 App 中打开": [.en: "Open in Photos App", .ja: "写真 App で開く", .ko: "사진 앱에서 열기"],
        "没有符合的照片": [.en: "No matching photos", .ja: "該当する写真なし", .ko: "일치하는 사진 없음"],
        "换个筛选条件试试": [.en: "Try another filter", .ja: "別のフィルタで", .ko: "다른 필터로"],

        // 元数据
        "照片详情": [.en: "Photo Details", .ja: "写真の詳細", .ko: "사진 세부정보"],
        "文件名": [.en: "Filename", .ja: "ファイル名", .ko: "파일명"],
        "尺寸": [.en: "Size", .ja: "サイズ", .ko: "크기"],
        "大小": [.en: "File Size", .ja: "ファイルサイズ", .ko: "파일 크기"],
        "类型": [.en: "Type", .ja: "種類", .ko: "유형"],
        "创建": [.en: "Created", .ja: "作成", .ko: "생성"],
        "修改": [.en: "Modified", .ja: "変更", .ko: "수정"],
        "位置": [.en: "Location", .ja: "位置情報", .ko: "위치"],
        "时长": [.en: "Duration", .ja: "長さ", .ko: "재생시간"],
        "已收藏 ❤︎": [.en: "Favorited ❤︎", .ja: "お気に入り ❤︎", .ko: "즐겨찾기 ❤︎"],
        "未知": [.en: "Unknown", .ja: "不明", .ko: "알 수 없음"],

        // 元数据补充
        "全景照片": [.en: "Panorama", .ja: "パノラマ", .ko: "파노라마"],
        "HDR 照片": [.en: "HDR Photo", .ja: "HDR写真", .ko: "HDR 사진"],

        "将把 %d 张照片移入系统「最近删除」相册，30 天内可恢复。": [
            .en: "%d photos will move to the system Recently Deleted album, recoverable within 30 days.",
            .ja: "%d 枚を「最近削除した項目」に移動します。30 日以内に復元可能です。",
            .ko: "%d 장의 사진을 시스템 「최근 삭제됨」으로 이동, 30일 내 복원 가능."
        ],
        "删除 %d 张": [.en: "Delete %d", .ja: "%d 枚を削除", .ko: "%d 장 삭제"],

        // 横向 quick pick 提示
        "首页统计副标": [.en: "Based on %d photos", .ja: "%d 枚から推定", .ko: "%d 장 기준 추정"],
        "基于 %d 张照片估算": [.en: "Based on %d photos", .ja: "%d 枚から推定", .ko: "%d 장 기준 추정"],

        // RootView 权限
        "需要访问您的照片以便整理与释放存储空间。所有操作都需您手动确认。": [
            .en: "We need photo library access to help you tidy up. All deletions stay manual.",
            .ja: "整理と空き容量確保のため写真ライブラリへのアクセスが必要です。削除は全て手動確認です。",
            .ko: "정리와 저장 공간 확보를 위해 사진 라이브러리 접근이 필요합니다. 모든 작업은 수동 확인입니다."
        ],
        "请在「设置 → 隐私与安全性 → 照片」中允许 RollKeep 访问。": [
            .en: "Allow RollKeep access via Settings → Privacy → Photos.",
            .ja: "「設定 → プライバシーとセキュリティ → 写真」で RollKeep を許可してください。",
            .ko: "설정 → 개인정보 보호 및 보안 → 사진 에서 RollKeep 접근을 허용하세요."
        ],

        // 加载中
        "加载中…": [.en: "Loading…", .ja: "読み込み中…", .ko: "로딩 중…"],
        "扫描中…": [.en: "Scanning…", .ja: "スキャン中…", .ko: "스캔 중…"],
        "正在扫描照片库…": [.en: "Scanning photo library…", .ja: "ライブラリをスキャン中…", .ko: "라이브러리 스캔 중…"],

        // 滑动审核完成
        "已标记 %d 张待删除": [.en: "%d marked for deletion", .ja: "%d 枚を削除予定", .ko: "%d 장 삭제 대기"],

        // toast 文本（带数量的复合文案）
        "已加入待删除 · %d": [
            .en: "Marked for delete · %d",
            .ja: "削除へ追加 · %d",
            .ko: "삭제 대기에 추가 · %d"
        ],
        "扫描完成 · %d 张": [
            .en: "Scan complete · %d",
            .ja: "スキャン完了 · %d 枚",
            .ko: "스캔 완료 · %d 장"
        ],
        "刷新成功 · %d 张": [
            .en: "Refreshed · %d",
            .ja: "更新完了 · %d 枚",
            .ko: "새로고침 완료 · %d 장"
        ],
        "「%@」功能开发中": [
            .en: "“%@” coming soon",
            .ja: "「%@」開発中",
            .ko: "「%@」 개발 중"
        ],
        "设置面板开发中": [.en: "Settings panel coming soon", .ja: "設定パネルは開発中", .ko: "설정 패널 개발 중"],

        // 首页 hero/section
        "潜在可释放副标": [.en: "Potential space to free up", .ja: "空けられる容量", .ko: "확보 가능한 용량"],

        // 错误/状态文案
        "返回首页": [.en: "Back Home", .ja: "ホームへ", .ko: "홈으로"],

        // 多选
        "全选": [.en: "Select All", .ja: "全選択", .ko: "전체 선택"],
        "全不选": [.en: "Deselect All", .ja: "全解除", .ko: "전체 해제"],
        "选择": [.en: "Select", .ja: "選択", .ko: "선택"],
        "已选 %d 张": [.en: "%d Selected", .ja: "%d 枚選択", .ko: "%d 장 선택됨"],

        // 月份 + 量词
        "%d 月": [.en: "%d", .ja: "%d 月", .ko: "%d월"],

        // MARK: - 内购 / 付费墙 / 会员

        "升级 Pro": [.en: "Upgrade to Pro", .ja: "Pro にアップグレード", .ko: "Pro로 업그레이드"],
        "解锁 RollKeep Pro": [.en: "Unlock RollKeep Pro", .ja: "RollKeep Pro を解除", .ko: "RollKeep Pro 해제"],
        "RollKeep Pro": [.en: "RollKeep Pro", .ja: "RollKeep Pro", .ko: "RollKeep Pro"],
        "已解锁全部功能": [.en: "All features unlocked", .ja: "すべての機能がアンロック", .ko: "모든 기능 잠금 해제됨"],
        "解锁全部主题与整理上限": [.en: "Unlock all themes & remove daily limits",
                          .ja: "全テーマと整理上限を解除",
                          .ko: "모든 테마와 정리 제한 해제"],

        // 5 档商品名 + 副标
        "周订阅":   [.en: "Weekly",    .ja: "週額", .ko: "주간 구독"],
        "月订阅":   [.en: "Monthly",   .ja: "月額", .ko: "월간 구독"],
        "季订阅":   [.en: "Quarterly", .ja: "3 ヶ月", .ko: "분기 구독"],
        "年订阅":   [.en: "Yearly",    .ja: "年額", .ko: "연간 구독"],
        "终身版":   [.en: "Lifetime",  .ja: "ライフタイム", .ko: "평생"],
        "每周续订":   [.en: "Renews weekly",     .ja: "毎週更新",   .ko: "매주 자동 갱신"],
        "每月续订":   [.en: "Renews monthly",    .ja: "毎月更新",   .ko: "매월 자동 갱신"],
        "每 3 个月续订": [.en: "Renews every 3 months", .ja: "3 ヶ月ごとに更新", .ko: "3개월마다 자동 갱신"],
        "每年续订":   [.en: "Renews yearly",     .ja: "毎年更新",   .ko: "매년 자동 갱신"],
        "一次买断，永久使用": [.en: "One-time purchase, forever", .ja: "一回購入、永続利用", .ko: "1회 결제, 평생 사용"],
        "最划算": [.en: "Best Value", .ja: "お得", .ko: "최고 혜택"],
        "含 %d 天免费试用": [.en: "Includes %d-day free trial",
                       .ja: "%d 日間の無料体験つき",
                       .ko: "%d일 무료 체험 포함"],
        "免费试用 %d 天": [.en: "Start %d-Day Free Trial",
                     .ja: "%d 日間無料で試す",
                     .ko: "%d일 무료 체험 시작"],
        "立即解锁": [.en: "Unlock Now", .ja: "今すぐ解除", .ko: "지금 해제"],
        "正在加载商品…": [.en: "Loading products…", .ja: "商品を読み込み中…", .ko: "상품 불러오는 중…"],
        "可随时在 App Store 取消": [.en: "Cancel anytime in App Store",
                            .ja: "App Store でいつでも解約可能",
                            .ko: "App Store에서 언제든 취소 가능"],

        // Paywall 特性
        "无限审核": [.en: "Unlimited Reviews", .ja: "無制限の整理", .ko: "무제한 정리"],
        "每天可整理的张数不再受限": [.en: "Remove the 300-photos daily cap",
                          .ja: "1 日 300 枚の上限を解除",
                          .ko: "하루 300장 제한 해제"],
        "待删除列表无上限": [.en: "Unlimited Pending List", .ja: "削除予定リストが無制限", .ko: "삭제 대기 무제한"],
        "一次性堆积任意张数照片再统一清理": [.en: "Stack any number of photos, then clean in one go",
                             .ja: "任意の枚数を溜めてから一括削除",
                             .ko: "원하는 만큼 쌓아두고 한 번에 정리"],
        "单次审核无上限": [.en: "Unlimited per session", .ja: "1 セッションが無制限", .ko: "세션당 무제한"],
        "打开分类后加载全部照片，不再被截断": [.en: "Load the full category, not just the first 50",
                                .ja: "カテゴリ全体を読み込み（先頭 50 枚で打ち切らない）",
                                .ko: "카테고리 전체 로드 (앞 50장으로 잘리지 않음)"],
        "解锁时间线": [.en: "Unlock Timeline", .ja: "タイムラインを解除", .ko: "타임라인 해제"],
        "按月份回顾你的相册": [.en: "Browse your library month by month",
                       .ja: "月別にライブラリを振り返る",
                       .ko: "월별로 라이브러리 돌아보기"],
        "解锁全部主题": [.en: "All Themes Unlocked", .ja: "全テーマを解除", .ko: "모든 테마 해제"],
        "自由切换深色/浅色/暖色/冷色": [.en: "Switch among Dark / Light / Warm / Cool freely",
                              .ja: "ダーク / ライト / ウォーム / クールを自由に切替",
                              .ko: "다크/라이트/웜/쿨 자유 전환"],

        // Paywall 触发副标
        "解锁全部分类整理与主题": [.en: "Unlock the full library and all themes",
                          .ja: "全カテゴリ整理とテーマを解除",
                          .ko: "전체 분류 정리와 모든 테마 해제"],
        "免费版待删除列表上限 20 张，升级后无上限": [.en: "Free tier caps pending at 20. Upgrade for unlimited.",
                                       .ja: "無料版は削除予定 20 枚まで。アップグレードで無制限。",
                                       .ko: "무료 버전은 삭제 대기 20장까지. 업그레이드 시 무제한."],
        "免费版单次最多加载 50 张，升级后加载全部": [.en: "Free tier loads up to 50 per session. Upgrade to load all.",
                                       .ja: "無料版は 1 セッション 50 枚まで。アップグレードで全件読込。",
                                       .ko: "무료 버전은 세션당 50장까지. 업그레이드 시 전체 로드."],
        "已达今日 300 张免费上限，升级后无限审核": [.en: "Hit today's free cap of 300. Upgrade for unlimited.",
                                       .ja: "本日 300 枚の上限に到達。アップグレードで無制限。",
                                       .ko: "오늘 300장 한도 도달. 업그레이드 시 무제한."],
        "时间线为 Pro 专属功能": [.en: "Timeline is a Pro feature", .ja: "タイムラインは Pro 限定", .ko: "타임라인은 Pro 전용"],
        "切换主题为 Pro 专属功能": [.en: "Theme switching is a Pro feature",
                          .ja: "テーマ切替は Pro 限定",
                          .ko: "테마 전환은 Pro 전용"],

        // Paywall 法务
        "付款将在确认后从你的 Apple ID 账户中扣款；订阅会自动续订，可在 App Store 账户中随时取消。": [
            .en: "Payment is charged to your Apple ID upon confirmation. Subscriptions auto-renew until cancelled in the App Store account settings.",
            .ja: "確認後に Apple ID から請求されます。購読は自動更新され、App Store アカウントでいつでも解約できます。",
            .ko: "확인 후 Apple ID에서 결제됩니다. 구독은 자동 갱신되며 App Store 계정에서 언제든 취소할 수 있습니다."
        ],

        // 已经购买 / 兑换码 / 管理订阅
        "已经购买?": [.en: "Already Purchased?", .ja: "購入済み?", .ko: "이미 구매했나요?"],
        "使用兑换码": [.en: "Redeem Code", .ja: "コードを使う", .ko: "코드 사용"],
        "管理订阅": [.en: "Manage Subscriptions", .ja: "サブスク管理", .ko: "구독 관리"],
        "已恢复 Pro 权益": [.en: "Pro restored", .ja: "Pro を復元しました", .ko: "Pro 복원됨"],
        "未找到可恢复的购买记录": [.en: "No purchases to restore", .ja: "復元可能な購入はありません", .ko: "복원할 구매 내역 없음"],

        // 支持 + 分享 + 评分
        "支持我们": [.en: "Support Us", .ja: "応援する", .ko: "응원하기"],
        "给个好评": [.en: "Rate the App", .ja: "アプリを評価", .ko: "앱 평가하기"],
        "分享给朋友": [.en: "Share with Friends", .ja: "友だちにシェア", .ko: "친구에게 공유"],
        "用 RollKeep 整理你的照片库，腾出更多空间。": [
            .en: "Use RollKeep to tidy your photo library and free up space.",
            .ja: "RollKeep で写真ライブラリを整理して空き容量を増やそう。",
            .ko: "RollKeep로 사진 라이브러리를 정리하고 공간을 확보해보세요."
        ],

        // 关于 / 法务
        "账户": [.en: "Account", .ja: "アカウント", .ko: "계정"],
        "隐私政策": [.en: "Privacy Policy", .ja: "プライバシーポリシー", .ko: "개인정보 처리방침"],
        "使用条款": [.en: "Terms of Use", .ja: "利用規約", .ko: "이용 약관"],

        // 免费版上限 toast
        "免费版单次仅加载前 %d 张": [.en: "Free tier loads only the first %d",
                            .ja: "無料版は先頭 %d 枚のみ",
                            .ko: "무료 버전은 앞 %d장만 로드"],
        "今日剩余可整理": [.en: "Remaining Today", .ja: "本日の残り", .ko: "오늘 남은 정리"],
        "Pro 解锁按月份回顾": [.en: "Unlock month-by-month review with Pro",
                       .ja: "Pro で月別レビューを解除",
                       .ko: "Pro로 월별 리뷰 해제"],

        // MARK: - 1.2 整理能力与洞察

        "大视频": [.en: "Large Videos", .ja: "大容量ビデオ", .ko: "대용량 비디오"],
        "连拍照片": [.en: "Burst Photos", .ja: "バースト写真", .ko: "연사 사진"],
        "整理进度": [.en: "Cleanup Progress", .ja: "整理の進捗", .ko: "정리 진행"],
        "连续 %d 天 · 已审核 %d 张": [
            .en: "%d-day streak · %d reviewed",
            .ja: "%d 日連続 · %d 枚確認済み",
            .ko: "%d일 연속 · %d장 검토"
        ],
        "查看最近整理趋势": [.en: "View recent cleanup trends", .ja: "最近の整理傾向を見る", .ko: "최근 정리 추세 보기"],
        "升级 Pro 查看完整趋势": [.en: "Upgrade to Pro for full trends", .ja: "Pro で完全な傾向を表示", .ko: "Pro로 전체 추세 보기"],
        "Pro 解锁完整时间线": [.en: "Unlock Full Timeline with Pro", .ja: "Pro で全タイムラインを解除", .ko: "Pro로 전체 타임라인 잠금 해제"],
        "整理洞察": [.en: "Cleanup Insights", .ja: "整理インサイト", .ko: "정리 인사이트"],
        "累计释放空间": [.en: "Total Space Reclaimed", .ja: "解放した合計容量", .ko: "누적 확보 공간"],
        "已审核": [.en: "Reviewed", .ja: "確認済み", .ko: "검토 완료"],
        "已清理": [.en: "Cleaned", .ja: "削除済み", .ko: "정리 완료"],
        "连续天数": [.en: "Day Streak", .ja: "連続日数", .ko: "연속 일수"],
        "最近 7 天": [.en: "Last 7 Days", .ja: "過去 7 日間", .ko: "최근 7일"],
        "每天审核的照片数量": [.en: "Photos reviewed each day", .ja: "日ごとの確認枚数", .ko: "일별 검토 사진 수"],
        "整理统计仅保存在这台设备上": [
            .en: "Cleanup stats stay only on this device",
            .ja: "整理統計はこの端末にのみ保存されます",
            .ko: "정리 통계는 이 기기에만 저장됩니다"
        ],
        "排序": [.en: "Sort", .ja: "並べ替え", .ko: "정렬"],
        "最新优先": [.en: "Newest First", .ja: "新しい順", .ko: "최신순"],
        "最早优先": [.en: "Oldest First", .ja: "古い順", .ko: "오래된순"],
        "空间优先": [.en: "Largest First", .ja: "容量順", .ko: "용량순"],
        "请先处理待删除列表": [
            .en: "Finish the pending list before changing sort",
            .ja: "並べ替え前に削除予定を処理してください",
            .ko: "정렬 변경 전에 삭제 대기 목록을 처리하세요"
        ],
        "预计释放": [.en: "Est. Space", .ja: "推定容量", .ko: "예상 공간"],

        // MARK: - 1.2 付费墙

        "空间优先整理": [.en: "Largest First", .ja: "容量優先の整理", .ko: "용량 우선 정리"],
        "优先查看最占空间的照片和视频": [
            .en: "Review the biggest photos and videos first",
            .ja: "容量の大きい写真とビデオから確認",
            .ko: "용량이 큰 사진과 비디오부터 검토"
        ],
        "完整时间线": [.en: "Full Timeline", .ja: "全タイムライン", .ko: "전체 타임라인"],
        "回顾全部月份，不限最近半年": [
            .en: "Browse every month, beyond the recent six",
            .ja: "直近 6 か月を超えてすべての月を表示",
            .ko: "최근 6개월을 넘어 모든 월 보기"
        ],
        "查看释放空间、连续天数和趋势": [
            .en: "Track reclaimed space, streaks, and trends",
            .ja: "解放容量、連続日数、傾向を確認",
            .ko: "확보 공간, 연속 일수, 추세 확인"
        ],
        "解锁焦糖暖与冷色主题": [
            .en: "Unlock Caramel and Cool themes",
            .ja: "キャラメルとクールテーマを解除",
            .ko: "캐러멜 및 쿨 테마 잠금 해제"
        ],
        "暂时无法加载商品": [.en: "Products are temporarily unavailable", .ja: "商品を読み込めません", .ko: "상품을 불러올 수 없습니다"],
        "重新加载": [.en: "Try Again", .ja: "再読み込み", .ko: "다시 불러오기"],
        "最受欢迎": [.en: "Most Popular", .ja: "人気", .ko: "인기"],
        "一次购买，永久使用": [.en: "One purchase, yours forever", .ja: "一度の購入で永久利用", .ko: "한 번 구매로 평생 사용"],
        "解锁无限整理与深度洞察": [
            .en: "Unlock unlimited cleanup and deeper insights",
            .ja: "無制限の整理と詳細インサイトを解除",
            .ko: "무제한 정리와 심층 인사이트 잠금 해제"
        ],
        "免费版待删除列表上限 50 张，升级后无上限": [
            .en: "Free tier holds 50 pending items. Pro is unlimited.",
            .ja: "無料版は削除予定 50 枚まで。Pro は無制限です。",
            .ko: "무료 버전은 삭제 대기 50장까지, Pro는 무제한입니다."
        ],
        "升级后可回顾完整月份时间线": [
            .en: "Upgrade to browse your complete monthly timeline",
            .ja: "アップグレードですべての月を振り返る",
            .ko: "업그레이드하여 전체 월별 타임라인 보기"
        ],
        "升级后优先清理最占空间的内容": [
            .en: "Upgrade to clean the largest items first",
            .ja: "アップグレードで大容量項目から整理",
            .ko: "업그레이드하여 용량이 큰 항목부터 정리"
        ],
        "升级后查看完整整理趋势": [
            .en: "Upgrade to view your full cleanup trends",
            .ja: "アップグレードで整理傾向をすべて表示",
            .ko: "업그레이드하여 전체 정리 추세 보기"
        ],
        "焦糖暖与冷色调为 Pro 专属主题": [
            .en: "Caramel and Cool are Pro themes",
            .ja: "キャラメルとクールは Pro 限定テーマです",
            .ko: "캐러멜과 쿨은 Pro 전용 테마입니다"
        ],
        "会员": [.en: "Member", .ja: "メンバー", .ko: "멤버십"],
        "升级会员": [.en: "Unlock Membership", .ja: "メンバーシップを解除", .ko: "멤버십 잠금 해제"],
        "RollKeep 会员": [.en: "RollKeep Membership", .ja: "RollKeep メンバーシップ", .ko: "RollKeep 멤버십"],
        "解锁完整体验": [.en: "Unlock the Full Experience", .ja: "すべての機能を解除", .ko: "전체 경험 잠금 해제"],
        "升级会员查看完整趋势": [
            .en: "Unlock membership for full trends",
            .ja: "メンバーシップで完全な傾向を表示",
            .ko: "멤버십으로 전체 추세 보기"
        ],
        "会员解锁完整时间线": [
            .en: "Membership Unlocks Full Timeline",
            .ja: "メンバーシップで全タイムラインを解除",
            .ko: "멤버십으로 전체 타임라인 잠금 해제"
        ],
        "已恢复会员权益": [.en: "Membership restored", .ja: "メンバーシップを復元しました", .ko: "멤버십 복원됨"],
        "焦糖暖与冷色调为会员专属主题": [
            .en: "Caramel and Cool are membership themes",
            .ja: "キャラメルとクールはメンバー限定テーマです",
            .ko: "캐러멜과 쿨은 멤버십 전용 테마입니다"
        ],

    ]
}
