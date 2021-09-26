# Github::To::Canvas::Quiz

## Refactor

Features:

- In Builder, initialize new repo (optional?)
  - probably not necessary to save repo name to YAML, and may cause more issues
    if repo URL changes...
  - can read the repo data from the directory (local) or url (GitHub API)
- In Align, take snapshots of Canvas API response JSON before and after
- rename `build` to `backup` in CLI

Question:

- what is public API for this library, besides the CLI?
- What class is responsible for loading a quiz from the API?
- What class is responsible for saving a quiz to the file system?
- use Capybara/HTML matchers for testing HTML strings?

```rb
quiz = Quiz.from(:canvas, course_id: 1, quiz_id: 2)
quiz = Quiz.from(:markdown, path: '')

class Quiz
  def self.from(loader, options)
    case loader
    when :api
      # where does the API call happen?
      Parser::Canvas::Quiz.new()
    when :file
      Parser::Markdown::Quiz.new(options[:path])
    end
  end
end
```
