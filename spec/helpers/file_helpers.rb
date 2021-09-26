# frozen_string_literal: true

module FileHelpers
  def create_quiz_repo!(path, quiz, *questions)
    File.write(File.join(path, 'README.md'), quiz.to_markdown)

    question_dir = File.join(path, 'questions')
    Dir.mkdir(question_dir)
    questions.each.with_index do |question, index|
      filename = "#{index.to_s.rjust(2, '0')}.md"
      File.write(File.join(question_dir, filename), question.to_markdown)
    end

    git = Git.init(path)
    git.add(all: true)
    git.commit('Initial commit')
  end

  def in_temp_dir(remove_after: true)
    tmp_path = nil
    while tmp_path.nil? || File.directory?(tmp_path)
      filename = "test#{Time.now.to_i}#{rand(300).to_s.rjust(3, '0')}"
      tmp_path = File.expand_path(File.join('./tmp/', filename))
    end
    FileUtils.mkdir(tmp_path)
    FileUtils.cd tmp_path do
      yield tmp_path
    end
    FileUtils.rm_r(tmp_path) if remove_after
  end
end
