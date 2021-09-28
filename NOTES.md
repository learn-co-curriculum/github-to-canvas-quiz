## Refactor

Features:

- Add a RepositoryInterface class to allow easier testing of repo commit etc
  functionality and slim down builder/synchronizer classes
- can read the repo data from the directory (local) or url (GitHub API)
- rename `build` to `backup` in CLI
- move a bunch of methods from build/sync to models?? would make more testable.
  questionable if the models should be responsible for saving to file
  system/working with git/interacting with API...
- issue when syncing: points not updated when questions added/removed?

Question:

- what is public API for this library, besides the CLI?
- What class is responsible for loading a quiz from the API?
- What class is responsible for saving a quiz to the file system?
- use Capybara/HTML matchers for testing HTML strings?
- probably not necessary to save repo name to YAML, and may cause more issues
  if repo URL changes...

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

Syncing notes:

- When a question is **removed** and a blueprint is synced:
  - students who have already taken the quiz keep their old score unless the
    quiz is re-graded
    - 11/12 => 11/11
  - Canvas sez: "The quiz has changed significantly since this submission was
    made. This submission may need re-grading."
- When a question is **added** and a blueprint is synced:
  - students who have already taken the quiz keep their old score unless the
    quiz is re-graded
    - 5/6 => 5/7
  - Canvas sez: "The quiz has changed significantly since this submission was
    made. This submission may need re-grading."
