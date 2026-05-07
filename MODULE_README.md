# FCMS â€” SHOP Module

## Your Files
- `src\main\java\com\antigravity\fcms\modules\shop\` â€” Backend (model, repository, service, controller)
- `src\main\webapp\modules\shop\` â€” Frontend (html, css, js)
- `src\main\webapp\WEB-INF\views\` â€” JSP views for this module
- `data\` â€” CSV data files for this module

## Architecture Flow
`Frontend HTML â†’ JavaScript â†’ Controller â†’ Service â†’ Repository â†’ Database`

## Git Workflow
1. Clone the shared repository
2. Create your branch: `git checkout -b feature/shop-module`
3. Work ONLY in your module folder
4. Commit: `git commit -m "feat(shop): your message"`
5. Push and open a Pull Request to main

## Rules
- Only modify files inside `modules/shop/`
- Coordinate with the team before changing shared files
- Always `git pull origin main` before starting work
