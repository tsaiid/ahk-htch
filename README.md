# AutoHotKey Scripts for Helios

這個 repository 收錄為院內影像醫學科報告系統 Helios / WebRIS 使用的 AutoHotkey scripts。內容主要由常用報告片語、檢查範本、RIS 操作熱鍵與輔助函式組成，並由 [tsaiid/ahk-smartwonder](https://github.com/tsaiid/ahk-smartwonder) 衍生而來。

## 需求

- Windows
- AutoHotkey v2.0

## 專案結構

- `RisTools.v2.ahk`: AHK v2 主要入口，載入目前維護中的 scripts。
- `Lib/`: 共用 AutoHotkey libraries。
- `Hotstrings/`: 各影像次專科與模板 hotstrings。
- `Hotstrings/lib/`: 專案內部共用函式。
- `Hotkeys/`: RIS / PACS 操作相關熱鍵。
- `Utilities/compile-check.ps1`: AHK v2 驗證與選擇性編譯腳本。
- `userscripts/`: WebRIS userscript 與輔助工具。

## 安裝與使用

1. 安裝 AutoHotkey v2。
2. 將本 repository 放在固定位置。
3. 執行或建立捷徑指向 `RisTools.v2.ahk`。
4. 需要個人化設定時，可建立 `Hotstrings/private.v2.ahk`。此檔案以 optional include 載入，未存在時不會影響主程式啟動。

主要功能會在 `RIS` 視窗群組中啟用。視窗群組定義於 `RisTools.v2.ahk`，目前包含 WebRIS、報告管理系統與相關院內系統視窗。

## 驗證

修改 AHK code 後，請執行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1
```

此腳本會解析 `RisTools.v2.ahk` 的 include dependency，並以 AutoHotkey v2 的 `/Validate` 模式檢查語法。若要同時編譯，可加上 `-Compile`：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1 -Compile
```

## 開發注意事項

- 個人或院內私有設定應放在 `Hotstrings/private.v2.ahk`，不要提交敏感資訊。
- 修改 AHK code 後必須通過 `Utilities\compile-check.ps1`。
