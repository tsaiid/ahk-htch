# AutoHotKey Scripts for Helios

這個 repository 收錄為院內影像醫學科報告系統 Helios / WebRIS 使用的 AutoHotkey scripts。內容主要由常用報告片語、檢查範本、RIS 操作熱鍵與輔助函式組成，並由 [tsaiid/ahk-smartwonder](https://github.com/tsaiid/ahk-smartwonder) 衍生而來。

## 需求

- Windows
- AutoHotkey v2.0
- 若仍需使用舊版入口，需另外安裝 AutoHotkey v1.1

## 專案結構

- `AutoHotkey.v2.ahk`: AHK v2 主要入口，載入目前維護中的 scripts。
- `AutoHotkey.ahk`: AHK v1 舊版入口，保留供相容使用。
- `Lib/`: 共用 AutoHotkey libraries。
- `MyScripts/`: 報告範本、hotstrings、hotkeys 與自訂 helper scripts。
- `MyScripts/hotkey/`: RIS / PACS 操作相關熱鍵。
- `MyScripts/lib/`: 專案內部共用函式。
- `Utilities/compile-check.ps1`: AHK v2 驗證與選擇性編譯腳本。
- `others/`: 其他輔助 scripts，例如 user script / user style。

## 安裝與使用

1. 安裝 AutoHotkey v2。
2. 將本 repository 放在固定位置。
3. 執行或建立捷徑指向 `AutoHotkey.v2.ahk`。
4. 需要個人化設定時，可建立 `MyScripts/private.v2.ahk`。此檔案以 optional include 載入，未存在時不會影響主程式啟動。

主要功能會在 `RIS` 視窗群組中啟用。視窗群組定義於 `AutoHotkey.v2.ahk`，目前包含 WebRIS、報告管理系統與相關院內系統視窗。

## 驗證

修改 AHK code 後，請執行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1
```

此腳本會解析 `AutoHotkey.v2.ahk` 的 include dependency，並以 AutoHotkey v2 的 `/Validate` 模式檢查語法。若要同時編譯，可加上 `-Compile`：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1 -Compile
```

## 開發注意事項

- 新增或修改功能時，優先更新 AHK v2 檔案。
- 若仍需支援 AHK v1，請同步確認對應的 `.ahk` 舊版檔案。
- 個人或院內私有設定應放在 `MyScripts/private.v2.ahk` 或 `MyScripts/private.ahk`，不要提交敏感資訊。
- 修改 AHK code 後必須通過 `Utilities\compile-check.ps1`。
