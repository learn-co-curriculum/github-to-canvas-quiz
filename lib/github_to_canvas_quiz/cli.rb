# frozen_string_literal: true

module GithubToCanvasQuiz
  class CLI < Thor
    option :course, type: :numeric, required: true, desc: 'Canvas Course ID'
    option :quiz, type: :numeric, required: true, desc: 'Canvas Quiz ID'
    option :directory,
           default: '.',
           desc:
             '(optional) Directory to output markdown files. Defaults to current directory'
    desc 'backup', 'Backup a Canvas quiz and its questions as markdown'
    def backup
      puts '⬇️ Converting quiz...'
      Builder::Quiz.new(
        client,
        options[:course],
        options[:quiz],
        options[:directory],
      ).build
      puts '✅ Done'
    end

    option :directory,
           default: '.',
           desc:
             '(optional) Directory with markdown files to align. Defaults to current directory'
    desc 'align', 'Updates a Canvas quiz from Markdown files.'
    def align
      puts '⬆️ Aligning quiz...'
      Synchronizer::Quiz.new(client, options[:directory]).sync
      puts '✅ Done'
    end

    desc 'version', 'Display the Gem version'
    def version
      puts VERSION
    end

    private

    def client
      @client ||=
        CanvasAPI::Client.new(
          api_key: ENV['CANVAS_API_KEY'],
          host: ENV['CANVAS_API_PATH'],
        )
    end
  end
end
