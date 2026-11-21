//
//  L10n.swift
//  翻译字典：中文作 key，提供应用内多语言翻译
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
        "使用教程": [.en: "How to Use", .ja: "使い方ガイド", .ko: "사용 가이드"],
        "跳过": [.en: "Skip", .ja: "スキップ", .ko: "건너뛰기"],
        "下一步": [.en: "Next", .ja: "次へ", .ko: "다음"],
        "开始整理": [.en: "Start Organizing", .ja: "整理を始める", .ko: "정리 시작"],
        "私密且安心": [.en: "Private by Design", .ja: "プライバシーを第一に", .ko: "안심할 수 있는 개인정보 보호"],
        "所有照片分析都在设备上完成，不会上传你的照片库。": [
            .en: "All photo analysis happens on your device. Your library is never uploaded.",
            .ja: "写真の分析はすべて端末内で行われ、ライブラリはアップロードされません。",
            .ko: "모든 사진 분석은 기기에서 처리되며 사진 보관함은 업로드되지 않습니다."
        ],
        "选择整理入口": [.en: "Choose Where to Begin", .ja: "整理する項目を選択", .ko: "정리할 항목 선택"],
        "从智能建议、照片分类或时间线开始审核。": [
            .en: "Start with Smart Picks, a photo category, or your timeline.",
            .ja: "おすすめ、写真カテゴリ、またはタイムラインから確認を始められます。",
            .ko: "스마트 추천, 사진 분류 또는 타임라인에서 검토를 시작하세요."
        ],
        "简单滑动即可整理": [.en: "Organize with Simple Swipes", .ja: "スワイプでかんたん整理", .ko: "간단한 스와이프로 정리"],
        "左右滑动浏览，上滑把照片加入待删除列表。": [
            .en: "Swipe left or right to browse, then swipe up to mark a photo for deletion.",
            .ja: "左右にスワイプして閲覧し、上にスワイプして削除予定へ追加します。",
            .ko: "좌우로 넘겨 보고 위로 스와이프해 삭제 대기 목록에 추가하세요."
        ],
        "确认后才会删除": [.en: "Nothing Deletes Without You", .ja: "確認するまで削除されません", .ko: "확인해야만 삭제"],
        "先检查待删除列表，再通过系统照片确认完成删除。": [
            .en: "Review the pending list, then confirm deletion through the system Photos prompt.",
            .ja: "削除予定リストを確認し、システムの写真ダイアログで削除を確定します。",
            .ko: "삭제 대기 목록을 확인한 뒤 시스템 사진 안내에서 삭제를 승인하세요."
        ],
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
        "使用条款 (EULA)": [.en: "Terms of Use (EULA)", .ja: "利用規約 (EULA)", .ko: "이용 약관 (EULA)"],

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

        "免费开源": [.en: "Free & Open Source", .ja: "無料・オープンソース", .ko: "무료 오픈 소스"],
        "官方网站": [.en: "Official Website", .ja: "公式サイト", .ko: "공식 웹사이트"],
        "问题反馈": [.en: "Report an Issue", .ja: "問題を報告", .ko: "문제 신고"],
        "查看源代码": [.en: "View Source Code", .ja: "ソースコードを見る", .ko: "소스 코드 보기"],
        "开源许可 (GPLv3)": [.en: "Open Source License (GPLv3)", .ja: "オープンソースライセンス (GPLv3)", .ko: "오픈 소스 라이선스 (GPLv3)"],
        "全部功能免费使用，无订阅、无内购、无使用额度限制。": [
            .en: "All features are free, with no subscriptions, in-app purchases, or usage limits.",
            .ja: "すべての機能が無料。サブスクリプション、アプリ内課金、利用制限はありません。",
            .ko: "모든 기능이 무료이며 구독, 앱 내 구매, 사용량 제한이 없습니다."
        ],

    ]
}

/// 新增地区语言的核心界面翻译；未覆盖文案由 LanguageManager 回退到英语。
enum L10nRegional {
    static let dict: [AppLanguage: [String: String]] = [
        .fr: [
            "关闭": "Fermer", "取消": "Annuler", "确认": "Confirmer", "整理": "Trier",
            "照片": "Photos", "相簿": "Albums", "更多": "Plus", "设置": "Réglages",
            "外观": "Apparence", "主题": "Thème", "语言": "Langue", "跟随系统": "Système",
            "浏览体验": "Expérience", "数据": "Données", "关于": "À propos", "版本": "Version",
            "使用教程": "Guide d’utilisation", "跳过": "Passer", "下一步": "Suivant", "开始整理": "Commencer",
            "私密且安心": "Privé par conception", "所有照片分析都在设备上完成，不会上传你的照片库。": "Toute l’analyse se fait sur votre appareil. Vos photos ne sont jamais importées.",
            "选择整理入口": "Choisissez par où commencer", "从智能建议、照片分类或时间线开始审核。": "Commencez par les suggestions, une catégorie ou la chronologie.",
            "简单滑动即可整理": "Triez d’un simple geste", "左右滑动浏览，上滑把照片加入待删除列表。": "Balayez horizontalement pour parcourir et vers le haut pour marquer une photo.",
            "确认后才会删除": "Rien sans votre confirmation", "先检查待删除列表，再通过系统照片确认完成删除。": "Vérifiez la liste, puis confirmez la suppression dans Photos.",
            "支持我们": "Nous soutenir", "给个好评": "Noter l’app", "分享给朋友": "Partager avec des amis",
            "隐私政策": "Politique de confidentialité", "使用条款 (EULA)": "Conditions d’utilisation (EULA)",
            "整理你的照片库，腾出存储空间": "Organisez vos photos et libérez de l’espace",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Organisez vos photos avec RollKeep et libérez de l’espace.",
        ],
        .de: [
            "关闭": "Schließen", "取消": "Abbrechen", "确认": "Bestätigen", "整理": "Sortieren",
            "照片": "Fotos", "相簿": "Alben", "更多": "Mehr", "设置": "Einstellungen",
            "外观": "Darstellung", "主题": "Design", "语言": "Sprache", "跟随系统": "System",
            "浏览体验": "Nutzung", "数据": "Daten", "关于": "Über", "版本": "Version",
            "使用教程": "Kurzanleitung", "跳过": "Überspringen", "下一步": "Weiter", "开始整理": "Jetzt sortieren",
            "私密且安心": "Privat entwickelt", "所有照片分析都在设备上完成，不会上传你的照片库。": "Alle Analysen erfolgen auf deinem Gerät. Deine Fotos werden nie hochgeladen.",
            "选择整理入口": "Wähle deinen Start", "从智能建议、照片分类或时间线开始审核。": "Starte mit Vorschlägen, einer Kategorie oder der Zeitleiste.",
            "简单滑动即可整理": "Mit Wischen sortieren", "左右滑动浏览，上滑把照片加入待删除列表。": "Wische seitlich zum Blättern und nach oben zum Markieren.",
            "确认后才会删除": "Nur mit deiner Bestätigung", "先检查待删除列表，再通过系统照片确认完成删除。": "Prüfe die Liste und bestätige das Löschen anschließend in Fotos.",
            "支持我们": "Unterstützen", "给个好评": "App bewerten", "分享给朋友": "Mit Freunden teilen",
            "隐私政策": "Datenschutz", "使用条款 (EULA)": "Nutzungsbedingungen (EULA)",
            "整理你的照片库，腾出存储空间": "Fotomediathek ordnen und Speicher freigeben",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Ordne deine Fotos mit RollKeep und schaffe mehr Platz.",
        ],
        .it: [
            "关闭": "Chiudi", "取消": "Annulla", "确认": "Conferma", "整理": "Organizza",
            "照片": "Foto", "相簿": "Album", "更多": "Altro", "设置": "Impostazioni",
            "外观": "Aspetto", "主题": "Tema", "语言": "Lingua", "跟随系统": "Sistema",
            "浏览体验": "Esperienza", "数据": "Dati", "关于": "Informazioni", "版本": "Versione",
            "使用教程": "Guida all’uso", "跳过": "Salta", "下一步": "Avanti", "开始整理": "Inizia a organizzare",
            "私密且安心": "Privato per natura", "所有照片分析都在设备上完成，不会上传你的照片库。": "L’analisi avviene sul dispositivo. La libreria non viene mai caricata.",
            "选择整理入口": "Scegli da dove iniziare", "从智能建议、照片分类或时间线开始审核。": "Inizia dai suggerimenti, da una categoria o dalla cronologia.",
            "简单滑动即可整理": "Organizza con un gesto", "左右滑动浏览，上滑把照片加入待删除列表。": "Scorri lateralmente per sfogliare e verso l’alto per contrassegnare.",
            "确认后才会删除": "Elimini solo dopo la conferma", "先检查待删除列表，再通过系统照片确认完成删除。": "Controlla l’elenco e conferma l’eliminazione in Foto.",
            "支持我们": "Sostienici", "给个好评": "Valuta l’app", "分享给朋友": "Condividi con gli amici",
            "隐私政策": "Informativa sulla privacy", "使用条款 (EULA)": "Termini di utilizzo (EULA)",
            "整理你的照片库，腾出存储空间": "Organizza le foto e libera spazio",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Organizza le foto con RollKeep e libera spazio.",
        ],
        .es: [
            "关闭": "Cerrar", "取消": "Cancelar", "确认": "Confirmar", "整理": "Organizar",
            "照片": "Fotos", "相簿": "Álbumes", "更多": "Más", "设置": "Ajustes",
            "外观": "Apariencia", "主题": "Tema", "语言": "Idioma", "跟随系统": "Sistema",
            "浏览体验": "Experiencia", "数据": "Datos", "关于": "Acerca de", "版本": "Versión",
            "使用教程": "Guía de uso", "跳过": "Omitir", "下一步": "Siguiente", "开始整理": "Empezar a organizar",
            "私密且安心": "Privacidad por diseño", "所有照片分析都在设备上完成，不会上传你的照片库。": "Todo el análisis se hace en tu dispositivo. Tus fotos nunca se suben.",
            "选择整理入口": "Elige por dónde empezar", "从智能建议、照片分类或时间线开始审核。": "Empieza con sugerencias, una categoría o la cronología.",
            "简单滑动即可整理": "Organiza deslizando", "左右滑动浏览，上滑把照片加入待删除列表。": "Desliza a los lados para explorar y hacia arriba para marcar.",
            "确认后才会删除": "Nada se borra sin confirmar", "先检查待删除列表，再通过系统照片确认完成删除。": "Revisa la lista y confirma la eliminación en Fotos.",
            "支持我们": "Apóyanos", "给个好评": "Valorar la app", "分享给朋友": "Compartir con amigos",
            "隐私政策": "Política de privacidad", "使用条款 (EULA)": "Términos de uso (EULA)",
            "整理你的照片库，腾出存储空间": "Organiza tus fotos y libera espacio",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Organiza tus fotos con RollKeep y libera espacio.",
        ],
        .pt: [
            "关闭": "Fechar", "取消": "Cancelar", "确认": "Confirmar", "整理": "Organizar",
            "照片": "Fotos", "相簿": "Álbuns", "更多": "Mais", "设置": "Definições",
            "外观": "Aparência", "主题": "Tema", "语言": "Idioma", "跟随系统": "Sistema",
            "浏览体验": "Experiência", "数据": "Dados", "关于": "Sobre", "版本": "Versão",
            "使用教程": "Guia de utilização", "跳过": "Ignorar", "下一步": "Seguinte", "开始整理": "Começar a organizar",
            "私密且安心": "Privacidade de origem", "所有照片分析都在设备上完成，不会上传你的照片库。": "Toda a análise é feita no dispositivo. As suas fotos nunca são enviadas.",
            "选择整理入口": "Escolha por onde começar", "从智能建议、照片分类或时间线开始审核。": "Comece pelas sugestões, por uma categoria ou pela cronologia.",
            "简单滑动即可整理": "Organize com gestos", "左右滑动浏览，上滑把照片加入待删除列表。": "Deslize para os lados e para cima para marcar uma foto.",
            "确认后才会删除": "Só elimina após confirmar", "先检查待删除列表，再通过系统照片确认完成删除。": "Reveja a lista e confirme a eliminação em Fotos.",
            "支持我们": "Apoie-nos", "给个好评": "Avaliar a app", "分享给朋友": "Partilhar com amigos",
            "隐私政策": "Política de privacidade", "使用条款 (EULA)": "Termos de utilização (EULA)",
            "整理你的照片库，腾出存储空间": "Organize as fotos e liberte espaço",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Organize as fotos com o RollKeep e liberte espaço.",
        ],
        .nl: [
            "关闭": "Sluiten", "取消": "Annuleren", "确认": "Bevestigen", "整理": "Ordenen",
            "照片": "Foto’s", "相簿": "Albums", "更多": "Meer", "设置": "Instellingen",
            "外观": "Weergave", "主题": "Thema", "语言": "Taal", "跟随系统": "Systeem",
            "浏览体验": "Ervaring", "数据": "Gegevens", "关于": "Info", "版本": "Versie",
            "使用教程": "Gebruiksaanwijzing", "跳过": "Overslaan", "下一步": "Volgende", "开始整理": "Begin met ordenen",
            "私密且安心": "Privacy voorop", "所有照片分析都在设备上完成，不会上传你的照片库。": "Alle analyses gebeuren op je apparaat. Je foto’s worden nooit geüpload.",
            "选择整理入口": "Kies waar je begint", "从智能建议、照片分类或时间线开始审核。": "Begin met suggesties, een categorie of je tijdlijn.",
            "简单滑动即可整理": "Orden met veegbewegingen", "左右滑动浏览，上滑把照片加入待删除列表。": "Veeg opzij om te bladeren en omhoog om een foto te markeren.",
            "确认后才会删除": "Alleen na jouw bevestiging", "先检查待删除列表，再通过系统照片确认完成删除。": "Controleer de lijst en bevestig daarna in Foto’s.",
            "支持我们": "Steun ons", "给个好评": "Beoordeel de app", "分享给朋友": "Delen met vrienden",
            "隐私政策": "Privacybeleid", "使用条款 (EULA)": "Gebruiksvoorwaarden (EULA)",
            "整理你的照片库，腾出存储空间": "Orden je foto’s en maak ruimte vrij",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Orden je foto’s met RollKeep en maak ruimte vrij.",
        ],
        .pl: [
            "关闭": "Zamknij", "取消": "Anuluj", "确认": "Potwierdź", "整理": "Porządkuj",
            "照片": "Zdjęcia", "相簿": "Albumy", "更多": "Więcej", "设置": "Ustawienia",
            "外观": "Wygląd", "主题": "Motyw", "语言": "Język", "跟随系统": "System",
            "浏览体验": "Obsługa", "数据": "Dane", "关于": "Informacje", "版本": "Wersja",
            "使用教程": "Jak korzystać", "跳过": "Pomiń", "下一步": "Dalej", "开始整理": "Zacznij porządkować",
            "私密且安心": "Prywatność od podstaw", "所有照片分析都在设备上完成，不会上传你的照片库。": "Analiza odbywa się na urządzeniu. Twoje zdjęcia nie są wysyłane.",
            "选择整理入口": "Wybierz, od czego zacząć", "从智能建议、照片分类或时间线开始审核。": "Zacznij od sugestii, kategorii lub osi czasu.",
            "简单滑动即可整理": "Porządkuj gestami", "左右滑动浏览，上滑把照片加入待删除列表。": "Przesuwaj na boki, a w górę, aby oznaczyć zdjęcie.",
            "确认后才会删除": "Usuwanie tylko po potwierdzeniu", "先检查待删除列表，再通过系统照片确认完成删除。": "Sprawdź listę i potwierdź usuwanie w aplikacji Zdjęcia.",
            "支持我们": "Wesprzyj nas", "给个好评": "Oceń aplikację", "分享给朋友": "Udostępnij znajomym",
            "隐私政策": "Polityka prywatności", "使用条款 (EULA)": "Warunki użytkowania (EULA)",
            "整理你的照片库，腾出存储空间": "Uporządkuj zdjęcia i zwolnij miejsce",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Uporządkuj zdjęcia z RollKeep i zwolnij miejsce.",
        ],
        .ru: [
            "关闭": "Закрыть", "取消": "Отмена", "确认": "Подтвердить", "整理": "Разобрать",
            "照片": "Фото", "相簿": "Альбомы", "更多": "Ещё", "设置": "Настройки",
            "外观": "Оформление", "主题": "Тема", "语言": "Язык", "跟随系统": "Системный",
            "浏览体验": "Интерфейс", "数据": "Данные", "关于": "О приложении", "版本": "Версия",
            "使用教程": "Как пользоваться", "跳过": "Пропустить", "下一步": "Далее", "开始整理": "Начать разбор",
            "私密且安心": "Конфиденциальность прежде всего", "所有照片分析都在设备上完成，不会上传你的照片库。": "Анализ выполняется на устройстве. Ваши фото никуда не загружаются.",
            "选择整理入口": "Выберите, с чего начать", "从智能建议、照片分类或时间线开始审核。": "Начните с рекомендаций, категории или временной шкалы.",
            "简单滑动即可整理": "Разбирайте жестами", "左右滑动浏览，上滑把照片加入待删除列表。": "Листайте в стороны, а вверх — чтобы отметить фото.",
            "确认后才会删除": "Удаление только с подтверждением", "先检查待删除列表，再通过系统照片确认完成删除。": "Проверьте список и подтвердите удаление в приложении «Фото».",
            "支持我们": "Поддержать", "给个好评": "Оценить приложение", "分享给朋友": "Поделиться с друзьями",
            "隐私政策": "Политика конфиденциальности", "使用条款 (EULA)": "Условия использования (EULA)",
            "整理你的照片库，腾出存储空间": "Разберите фото и освободите место",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Разберите фото с RollKeep и освободите место.",
        ],
        .uk: [
            "关闭": "Закрити", "取消": "Скасувати", "确认": "Підтвердити", "整理": "Упорядкувати",
            "照片": "Фото", "相簿": "Альбоми", "更多": "Більше", "设置": "Налаштування",
            "外观": "Вигляд", "主题": "Тема", "语言": "Мова", "跟随系统": "Системна",
            "浏览体验": "Інтерфейс", "数据": "Дані", "关于": "Про програму", "版本": "Версія",
            "使用教程": "Як користуватися", "跳过": "Пропустити", "下一步": "Далі", "开始整理": "Почати впорядкування",
            "私密且安心": "Конфіденційність понад усе", "所有照片分析都在设备上完成，不会上传你的照片库。": "Аналіз виконується на пристрої. Ваші фото нікуди не завантажуються.",
            "选择整理入口": "Оберіть, із чого почати", "从智能建议、照片分类或时间线开始审核。": "Почніть із рекомендацій, категорії або часової шкали.",
            "简单滑动即可整理": "Упорядковуйте жестами", "左右滑动浏览，上滑把照片加入待删除列表。": "Гортайте вбік, а вгору — щоб позначити фото.",
            "确认后才会删除": "Видалення лише після підтвердження", "先检查待删除列表，再通过系统照片确认完成删除。": "Перевірте список і підтвердьте видалення у програмі «Фото».",
            "支持我们": "Підтримати", "给个好评": "Оцінити програму", "分享给朋友": "Поділитися з друзями",
            "隐私政策": "Політика конфіденційності", "使用条款 (EULA)": "Умови використання (EULA)",
            "整理你的照片库，腾出存储空间": "Упорядкуйте фото та звільніть місце",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "Упорядкуйте фото з RollKeep і звільніть місце.",
        ],
        .ar: [
            "关闭": "إغلاق", "取消": "إلغاء", "确认": "تأكيد", "整理": "تنظيم",
            "照片": "الصور", "相簿": "الألبومات", "更多": "المزيد", "设置": "الإعدادات",
            "外观": "المظهر", "主题": "السمة", "语言": "اللغة", "跟随系统": "النظام",
            "浏览体验": "التجربة", "数据": "البيانات", "关于": "حول", "版本": "الإصدار",
            "使用教程": "دليل الاستخدام", "跳过": "تخطي", "下一步": "التالي", "开始整理": "بدء التنظيم",
            "私密且安心": "الخصوصية أولاً", "所有照片分析都在设备上完成，不会上传你的照片库。": "يتم تحليل الصور على جهازك ولا يتم رفع مكتبة الصور.",
            "选择整理入口": "اختر نقطة البداية", "从智能建议、照片分类或时间线开始审核。": "ابدأ بالاقتراحات أو فئة صور أو المخطط الزمني.",
            "简单滑动即可整理": "نظّم بالسحب", "左右滑动浏览，上滑把照片加入待删除列表。": "اسحب جانبياً للتصفح ولأعلى لإضافة الصورة إلى قائمة الحذف.",
            "确认后才会删除": "لن يُحذف شيء دون تأكيدك", "先检查待删除列表，再通过系统照片确认完成删除。": "راجع القائمة ثم أكّد الحذف من خلال تطبيق الصور.",
            "支持我们": "ادعمنا", "给个好评": "قيّم التطبيق", "分享给朋友": "مشاركة مع الأصدقاء",
            "隐私政策": "سياسة الخصوصية", "使用条款 (EULA)": "شروط الاستخدام (EULA)",
            "整理你的照片库，腾出存储空间": "نظّم صورك ووفّر مساحة",
            "用 RollKeep 整理你的照片库，腾出更多空间。": "نظّم صورك باستخدام RollKeep ووفّر مساحة.",
        ]
    ]
}
