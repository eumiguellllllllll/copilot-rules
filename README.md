# Copilot Rules

Community-maintained GitHub Copilot instructions for Visual Studio Code. A comprehensive collection of rules designed to improve code generation accuracy, prevent common errors, and enforce best practices.

## Purpose

GitHub Copilot is powerful but can hallucinate non-existent APIs, lose context in long sessions, and generate inconsistent code. This project provides a battle-tested set of instructions that:

- Prevent AI hallucinations (inventing functions, methods, or APIs that don't exist)
- Maintain context across long coding sessions
- Enforce consistent code patterns and architecture
- Catch potential bugs before they're written
- Improve code quality and security

## What's Included

**`instructions/global.instructions.md`** - Copilot instruction file (Markdown + frontmatter) ready to copy into user or workspace profiles.

**`.vscode/settings.json`** - Configures VS Code to consume instruction files and applies default Copilot/editor safeguards.

**`scripts/install-copilot-instructions.bat`** & **`scripts/install-copilot-instructions.sh`** - Automation scripts that install the instruction file into the global VS Code profile on Windows, macOS, and Linux.

## Installation

### Option 1: Workspace Settings (Recommended)

Copy `.vscode/settings.json` to your project's `.vscode` folder:

```bash
mkdir -p .vscode
cp settings.json /path/to/your/project/.vscode/settings.json
```

### Option 2: Global User Settings

1. Open VSCode Settings (`Ctrl+,` or `Cmd+,`)
2. Click "Open Settings (JSON)" icon (top right)
3. Merge content from `.vscode/settings.json` with your existing settings

### Option 3: Global Copilot Instructions (User Profile)

Run the helper script that matches your platform to copy `instructions/global.instructions.md` into the VS Code profile `prompts` folder. Supply an alternate URL or output filename if you need a different branch or custom naming.

```powershell
# Windows (PowerShell or Command Prompt)
scripts\install-copilot-instructions.bat

# Override the download URL or output file name (optional)
scripts\install-copilot-instructions.bat "https://raw.githubusercontent.com/LightZirconite/copilot-rules/main/instructions/global.instructions.md" my-team.instructions.md
```

```bash
# macOS / Linux
bash scripts/install-copilot-instructions.sh

# Override the download URL or output file name (optional)
bash scripts/install-copilot-instructions.sh "https://raw.githubusercontent.com/LightZirconite/copilot-rules/main/instructions/global.instructions.md" my-team.instructions.md
```

The scripts detect the correct profile directory automatically:

- Windows: `%APPDATA%\Code\User\prompts` (or `Code - Insiders`)
- macOS: `~/Library/Application Support/Code/User/prompts`
- Linux: `${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/prompts`

### Usage

Reload VSCode: `Ctrl+Shift+P` → `Developer: Reload Window`

Copilot will now follow all instructions automatically.

## Contributing

Found a Copilot error pattern or instruction that improves code quality? Share it.

1. Fork this repository
2. Edit `instructions/global.instructions.md` (and `.vscode/settings.json` if tooling defaults need changes)
3. Test your changes
4. Submit a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### What to Contribute

- Instructions that fix specific Copilot behaviors
- Language-specific rules (Python, TypeScript, C#, Go, Rust)
- Framework patterns (React, Next.js, Express, FastAPI)
- Real-world examples of prevented bugs

## Examples

### Before
```typescript
// Copilot invents non-existent method
user.getFullName(); // Method doesn't exist
```

### After
```typescript
// Copilot verifies first
// VERIFY: User class doesn't have getFullName()
const fullName = `${user.firstName} ${user.lastName}`;
```

## License

MIT License - See [LICENSE](LICENSE)

## Links

- [Issues](https://github.com/LightZirconite/copilot-rules/issues)
- [Discussions](https://github.com/LightZirconite/copilot-rules/discussions)
- [Pull Requests](https://github.com/LightZirconite/copilot-rules/pulls)
