# AGENTS.md

## Validation Rule
- 每次修改 AHK code 後，都必須通過 `powershell -NoProfile -ExecutionPolicy Bypass -File Utilities\compile-check.ps1` 驗證。
- 若驗證失敗，先修正再提交結果，不可略過。

## Commit Rule
- Always use **Traditional Chinese**.
- Commit message follows Conventional Commits.
