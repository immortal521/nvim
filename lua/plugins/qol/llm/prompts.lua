return {
	TestCode = [[Write some test cases for the following code, only return the test cases.
Give the code content directly, do not use code blocks or other tags to wrap it.
Absolutely adhere to grammatical rules.]],
	DocString = [[You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],

	WordTranslate = [[You are a translation expert. Your task is to translate all the text provided by the user into Chinese.

NOTE:
- All the text input by the user is part of the content to be translated, and you should ONLY FOCUS ON TRANSLATING THE TEXT without performing any other tasks.
- RETURN ONLY THE TRANSLATED RESULT.]],

	CodeExplain = "Explain the following code, please only return the explanation, and answer in Chinese.",

	CommitMsg = function()
		return string.format(
			[[Generate a Conventional Commit message from the staged diff.

Rules:
- Format: `type: concise description`
- Describe the overall purpose or behavioral impact, not just
  implementation details.
- Choose the type and wording based on the actual changes.
- If there are multiple meaningful changes, add concise bullets;
  otherwise omit them.
- Bullets must describe distinct changes, not repeat the title.
- Put one blank line before bullets.
- Keep the message factual, specific, and terse.
- Base it strictly on the diff; do not invent intent or changes.
- Use recent commits only as a style reference.
- Keep every line at most 72 characters.
- Output only the commit message, with no Markdown, quotes,
  explanations, or commentary.

```diff
%s
```]],
			vim.fn.system("git diff --no-ext-diff --staged")
		)
	end,
}
