# Contributing to Copilot Rules# Contributing to Copilot Rules



**Thank you for helping build the best GitHub Copilot instruction set!****Thank you for helping build the best GitHub Copilot instruction set!**



## 🎯 Why Contribute?## 🎯 Why Contribute?



Every time you encounter a Copilot error, find a way to improve its output, or discover a pattern that generates better code - **the entire community benefits** when you share it.Every time you encounter a Copilot error, find a way to improve its output, or discover a pattern that generates better code - **the entire community benefits** when you share it.



This project's goal is simple: **create the most comprehensive set of instructions** to make GitHub Copilot as accurate and helpful as possible for everyone.This project's goal is simple: **create the most comprehensive set of instructions** to make GitHub Copilot as accurate and helpful as possible for everyone.



## 💡 The Philosophy## 💡 The Philosophy



GitHub Copilot is powerful, but it can:GitHub Copilot is powerful, but it can:

- Invent non-existent functions or APIs (hallucinations)- Invent non-existent functions or APIs (hallucinations)

- Lose context in long conversations- Lose context in long conversations

- Generate inconsistent code patterns- Generate inconsistent code patterns

- Miss edge cases or security issues- Miss edge cases or security issues



**Your contributions fix these problems for thousands of developers.****Your contributions fix these problems for thousands of developers.**



## 🤝 How to Share Your Improvements## 🤝 How to Share Your Improvements



### Simple Process### Simple Process



1. **Fork** this repository (click "Fork" button on GitHub)1. **Fork** this repository (click "Fork" button on GitHub)

2. **Edit** `instructions/global.instructions.md` - add or improve instructions2. **Edit** `.vscode/settings.json` - add or improve instructions

3. **Test** - verify your changes actually improve Copilot's behavior3. **Test** - verify your changes actually improve Copilot's behavior

4. **Submit a Pull Request** - explain what problem you solved4. **Submit a Pull Request** - explain what problem you solved



That's it! No complex setup needed.That's it! No complex setup needed.



### What We Need### What We Need



#### 🔥 High Priority#### 🔥 High Priority

- **Copilot hallucinations** you've encountered (inventing non-existent functions, APIs, methods)- **Copilot hallucinations** you've encountered (inventing non-existent functions, APIs, methods)

- **Instructions that fixed a bug** or prevented an error in your code- **Instructions that fixed a bug** or prevented an error in your code

- **Context management** - ways to keep Copilot accurate across long conversations- **Context management** - ways to keep Copilot accurate across long conversations

- **Language-specific patterns** - TypeScript, Python, C#, Go, Rust, etc.- **Language-specific patterns** - TypeScript, Python, C#, Go, Rust, etc.

- **Framework guidelines** - React, Next.js, Express, FastAPI, Django, etc.- **Framework guidelines** - React, Next.js, Express, FastAPI, Django, etc.



#### 💡 Also Welcome#### 💡 Also Welcome

- Better workflow patterns- Better workflow patterns

- Security best practices- Security best practices

- Performance optimizations- Performance optimizations

- Error handling improvements- Error handling improvements

- Code quality standards- Code quality standards



## 🌟 What Makes a Great Contribution### Examples of Great Contributions



### ✅ Good Examples**✅ Specific & Actionable**

```json

**Specific & Actionable**{

```markdown  "text": "- For TypeScript: ALWAYS verify interface properties exist before using them. Check the actual type definition before suggesting properties."

- For TypeScript: ALWAYS verify interface properties exist before using them. Check the actual type definition before suggesting properties.}

``````



**Solves Real Problems****✅ Solves Real Problems**

```markdown```json

- Before suggesting useState hooks: verify React is imported. Never assume imports exist.{

```  "text": "- Before suggesting useState hooks: verify React is imported. Never assume imports exist."

}

### ❌ Bad Examples```



**Too Vague****❌ Too Vague**

```markdown```json

- Write clean code. // Not actionable{

```  "text": "- Write clean code." // Not actionable

}

## 📝 Submitting Your Changes```



### Quick Method (GitHub Web UI)### How to Format Your Contribution

1. Go to https://github.com/LightZirconite/copilot-rules

2. Click on `instructions/global.instructions.md`Instructions go in `.vscode/settings.json` under `github.copilot.chat.codeGeneration.instructions`:

3. Click the edit (pencil) icon```json

4. Make your changes{

5. Scroll down, describe your changes, and click "Propose changes"```json

6. Click "Create pull request"{

  "text": "- Your new instruction here. Be specific and explain the WHY when possible."

### Advanced Method (Git)}

```bash```

git clone https://github.com/YOUR_USERNAME/copilot-rules.git

cd copilot-rules## 📝 Submitting Your Changes

# Make your changes to instructions/global.instructions.md

git add .### Quick Method (GitHub Web UI)

git commit -m "feat: add XYZ instruction to fix [problem]"1. Go to https://github.com/LightZirconite/copilot-rules

git push2. Click on `.vscode/settings.json`

# Create Pull Request on GitHub3. Click the edit (pencil) icon

```4. Make your changes

5. Scroll down, describe your changes, and click "Propose changes"

## 🔍 Review Process6. Click "Create pull request"



Pull requests will be reviewed based on:### Advanced Method (Git)

1. **Effectiveness**: Does it actually improve Copilot's output?```bash

2. **Specificity**: Is it clear and unambiguous?git clone https://github.com/YOUR_USERNAME/copilot-rules.git

3. **Scope**: Does it address a real problem or common error?cd copilot-rules

4. **Compatibility**: Does it work well with existing instructions?# Make your changes to .vscode/settings.json

5. **Documentation**: Is the purpose clear?git add .

git commit -m "feat: add XYZ instruction to fix [problem]"

## 💬 Not Ready to Code?git push

# Create Pull Request on GitHub

**Still want to help?** Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues) to:```

- Report Copilot errors or hallucinations you've encountered

- Suggest new instruction categories## 🎯 What We Look For

- Share problematic Copilot outputs (we'll create instructions to fix them)

- Discuss ideas for improvementsWhen reviewing Pull Requests, we check:

- **Does it solve a real problem?** Based on actual Copilot behavior

## 🌍 Community Impact- **Is it specific?** Clear, actionable instructions

- **Is it tested?** You've verified it improves Copilot's output

Every instruction you add helps **thousands of developers** worldwide:- **Is it well-explained?** We understand why this instruction matters

- Fewer bugs in production

- Less time debugging AI-generated code## 💬 Not Ready to Code?

- More confidence in Copilot suggestions

- Better code quality across the board**Still want to help?** Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues) to:

- Report Copilot errors or hallucinations you've encountered

**Your 5-minute contribution = hours saved for the community.**- Suggest new instruction categories

- Share problematic Copilot outputs (we'll create instructions to fix them)

## ❓ Questions?- Discuss ideas for improvements



- Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues)## 🌍 Community Impact

- Start a [Discussion](https://github.com/LightZirconite/copilot-rules/discussions)

- Check existing PRs for examplesEvery instruction you add helps **thousands of developers** worldwide:

- Fewer bugs in production

---- Less time debugging AI-generated code

- More confidence in Copilot suggestions

**Thank you for making GitHub Copilot better for everyone!** 🙏- Better code quality across the board



Remember: Every time you encounter a Copilot issue and fix it with an instruction - **share it**. That's how we build the most powerful instruction set together.**Your 5-minute contribution = hours saved for the community.**


## ❓ Questions?

- Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues)
- Start a [Discussion](https://github.com/LightZirconite/copilot-rules/discussions)
- Check existing PRs for examples

---

**Thank you for making GitHub Copilot better for everyone!** 🙏

Remember: Every time you encounter a Copilot issue and fix it with an instruction - **share it**. That's how we build the most powerful instruction set together.
}
```

## 🔍 Review Process

Pull requests will be reviewed based on:
1. **Effectiveness**: Does it actually improve Copilot's output?
2. **Specificity**: Is it clear and unambiguous?
3. **Scope**: Does it address a real problem or common error?
4. **Compatibility**: Does it work well with existing instructions?
5. **Documentation**: Is the purpose clear?

## 💡 Ideas & Suggestions

Not ready to submit code? Open an **Issue** to:
- Report Copilot behaviors that need addressing
- Suggest instruction categories or patterns
- Share examples of problematic Copilot outputs
- Discuss potential improvements to existing rules

## 🌟 What Makes a Great Contribution

### ✅ Good Examples
```json
{
  "text": "- For TypeScript: ALWAYS verify interface properties exist before using them. Check the actual type definition before suggesting properties."
}
```

**✅ Solves Real Problems**
```json
{
  "text": "- Before suggesting useState hooks: verify React is imported. Never assume imports exist."
}
```

**❌ Too Vague**
```json
{
  "text": "- Write clean code." // Not actionable
}
```

### How to Format Your Contribution

Instructions go in `.vscode/settings.json` under `github.copilot.chat.codeGeneration.instructions`:

```json
{
  "text": "- Your new instruction here. Be specific and explain the WHY when possible."
}
```

## � Submitting Your Changes

### Quick Method (GitHub Web UI)
1. Go to https://github.com/LightZirconite/copilot-rules
2. Click on `.vscode/settings.json`
3. Click the edit (pencil) icon
4. Make your changes
5. Scroll down, describe your changes, and click "Propose changes"
6. Click "Create pull request"

### Advanced Method (Git)
```bash
git clone https://github.com/YOUR_USERNAME/copilot-rules.git
cd copilot-rules
# Make your changes to .vscode/settings.json
git add .
git commit -m "feat: add XYZ instruction to fix [problem]"
git push
# Create Pull Request on GitHub
```

## 🎯 What We Look For

When reviewing Pull Requests, we check:
- **Does it solve a real problem?** Based on actual Copilot behavior
- **Is it specific?** Clear, actionable instructions
- **Is it tested?** You've verified it improves Copilot's output
- **Is it well-explained?** We understand why this instruction matters

## 💬 Not Ready to Code?

**Still want to help?** Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues) to:
- Report Copilot errors or hallucinations you've encountered
- Suggest new instruction categories
- Share problematic Copilot outputs (we'll create instructions to fix them)
- Discuss ideas for improvements

## 🌍 Community Impact

Every instruction you add helps **thousands of developers** worldwide:
- Fewer bugs in production
- Less time debugging AI-generated code
- More confidence in Copilot suggestions
- Better code quality across the board

**Your 5-minute contribution = hours saved for the community.**

## ❓ Questions?

- Open an [Issue](https://github.com/LightZirconite/copilot-rules/issues)
- Start a [Discussion](https://github.com/LightZirconite/copilot-rules/discussions)
- Check existing PRs for examples

---

**Thank you for making GitHub Copilot better for everyone!** 🙏

Remember: Every time you encounter a Copilot issue and fix it with an instruction - **share it**. That's how we build the most powerful instruction set together.
