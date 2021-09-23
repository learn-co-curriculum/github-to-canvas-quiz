# Github::To::Canvas::Quiz

## Refactor

- Model
  - underlying data needed for Canvas/Markdown
  - methods: `.from_canvas`, `.from_markdown`, `#to_h`, `#to_markdown`
  - `.from_markdown` calls the associated Markdown Parser, which returns a hash
    used for initialization?
  - `.from_canvas` calls the associated Canvas Parser, which returns a hash
    used for initialization?
  - `#to_markdown` calls the associated Markdown Converter, which returns a
    markdown string
  - `#to_h` returns a hash that can be used with the CanvasAPI
- Parser
  - parse Markdown or JSON to a hash that can be used by the associated
    class for initialization
- Converter
  - convert data from the associated model to JSON or Markdown

```rb
quiz = Quiz.load(:api, course_id: 1, quiz_id: 2)
quiz = Quiz.load(:file, path: '')

class Quiz
  def self.load(loader, options)
    case loader
    when :api then Loader::API::Quiz.new(self, options)
    when :file then Loader::File::Quiz.new(self, options)
    end
  end
end
```
