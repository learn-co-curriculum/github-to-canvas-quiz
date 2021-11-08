# GithubToCanvasQuiz

A tool for resizing and uploading images to AWS S3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'github-to-canvas-quiz'
```

And then execute:

```console
$ bundle install
```

Or install it yourself as:

```console
$ gem install github-to-canvas-quiz
```

## Configuration

Interacting with the Canvas API requires that you have the following environment
variables set:

- `ENV['CANVAS_API_PATH']`
  - The base URL for your institution's Canvas API
    (`https://flatironlearn.beta.instructure.com/api/v1`)
- `ENV['CANVAS_API_KEY']`
  - Your
    [Canvas Access Token](https://canvas.instructure.com/doc/api/file.oauth.html#manual-token-generation)

## Usage

This gem provides two key features via the CLI: backing up Canvas quizzes to
markdown, and updating a Canvas quiz from an existing directory of markdown
files.

### Backup

To backup a Canvas quiz to the current directory:

```console
$ github-to-canvas-quiz backup --course $COURSE_ID --quiz $QUIZ_ID
```

This will create a set of markdown files representing the quiz data (one for the
quiz itself, and one for each question).

### Align

To update a Canvas quiz based on the markdown files in the current directory:

```console
$ github-to-canvas-quiz align
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rspec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/learn-co-curriculum/github-to-canvas-quiz. This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[code of conduct](https://github.com/learn-co-curriculum/github-to-canvas-quiz/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlatironS3Uploader project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/learn-co-curriculum/github-to-canvas-quiz/blob/main/CODE_OF_CONDUCT.md).
