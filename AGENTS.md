# AGENTS.md

## Validation Rule
- 每次修改 AHK code 後，都必須通過 `powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1` 驗證。
- 若驗證失敗，先修正再提交結果，不可略過。

## Line Ending Rule
- Follow `.gitattributes` line endings.
- `*.ahk` and `*.ps1` files must remain CRLF in the working tree.
- After editing any `*.ahk` or `*.ps1` file, always run `powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\normalize-line-endings.ps1` before validation.
- `Utilities\compile-check.ps1` does not normalize line endings; run normalize first, then run compile-check before delivery.
- Before delivery, check `git ls-files --eol` and ensure touched AHK or PowerShell files are not `w/mixed`.

## Commit Rule
- Always use **Traditional Chinese**.
- Commit message follows Conventional Commits.

## WebRIS Text Editing Rule
- 在 WebRIS 裡做文字處理功能時，只考慮 `.ql-editor` 的 DOM 結構與 selection 操作。
- 不需要支援 textarea 編輯目標，也不要嘗試使用 Quill instance API。
