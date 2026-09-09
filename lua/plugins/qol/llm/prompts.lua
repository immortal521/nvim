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
- Infer the intent of the changes and describe their purpose or behavioral impact, not just implementation details.
- Choose the type and wording that best reflect the actual change.
- Add concise bullets only when useful to clarify important changes; otherwise omit them.
- Leave one blank line before bullets.
- Be factual, specific, and terse.
- Use recent commits only as a style reference.
- Base the message on the diff; do not invent intent or changes unsupported by it.
- Output only the commit message. No explanation, Markdown, quotes, or code fences.

```diff
%s
```]],
			vim.fn.system("git diff --no-ext-diff --staged")
		)
	end,
}
