# frozen_string_literal: true

module GithubToCanvasQuiz
  class CLI < Thor
    option :course, type: :numeric, required: true, desc: 'Canvas Course ID'
    option :quiz, type: :numeric, required: true, desc: 'Canvas Quiz ID'
    option :directory, default: '.', desc: '(optional) Directory to output markdown files. Defaults to current directory'
    desc 'build', 'Creates Markdown files for a Canvas quiz and its questions'
    def build
      # get the quiz data from Canvas (with question data)
      quiz_data = client.get_single_quiz(options[:course], options[:quiz])
      questions_data = client.list_questions(options[:course], options[:quiz])
      puts "⬇️ Converting Quiz: #{quiz_data['title']}"
      # convert the quiz data to markdown, including any metadata, and output
      quiz = Converter::Quiz.from_canvas(options[:course], quiz_data)
      questions = questions_data.map do |question_data|
        Converter::Question.from_canvas(options[:course], options[:quiz], question_data)
      end
      # output files to directory
      puts '📃 Creating Files...'
      RepoBuilder.new(quiz, questions).build(options[:directory])
      puts '✅ Done'
    end

    option :directory, default: '.', desc: '(optional) Directory with markdown files to align. Defaults to current directory'
    desc 'align', 'Updates a Canvas quiz from Markdown files.'
    def align
      puts '⬆️ Aligning quiz...'
      Synchronizer::Repo.new(client).sync(options[:directory])
      puts '✅ Done'
    end

    private

    def client
      @client ||= CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
    end
  end
end
