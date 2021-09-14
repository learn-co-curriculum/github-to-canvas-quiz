# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::RepoBuilder do
  let(:quiz) do
    instance_double(GithubToCanvasQuiz::Converter::Quiz, to_markdown: '# Quiz')
  end

  let(:questions) do
    [
      instance_double(GithubToCanvasQuiz::Converter::Question, to_markdown: '# Question 1'),
      instance_double(GithubToCanvasQuiz::Converter::Question, to_markdown: '# Question 2')
    ]
  end

  describe '.new' do
    it 'is initialized with a quiz and questions' do
      builder = described_class.new(quiz, questions)
      expect(builder).to have_attributes(
        quiz: quiz,
        questions: questions
      )
    end
  end

  describe '#build' do
    let(:tmp_path) { 'spec/tmp' }

    let(:builder) do
      described_class.new(quiz, questions)
    end

    before do
      Dir.mkdir(tmp_path) unless File.directory? tmp_path
    end

    after do
      FileUtils.rm_rf("#{tmp_path}/.", secure: true)
    end

    it 'calls #to_markdown on the quiz and questions' do
      builder.build(tmp_path)
      expect(builder.quiz).to have_received(:to_markdown)
      expect(builder.questions).to all(have_received(:to_markdown))
    end

    it 'outputs a README.md file in the given directory' do
      builder.build(tmp_path)
      expect(File.read("#{tmp_path}/README.md")).to eq('# Quiz')
    end

    it 'outputs a .md file for each question to a /questions subfolder in the given directory' do
      builder.build(tmp_path)
      expect(File.read("#{tmp_path}/questions/00.md")).to eq('# Question 1')
      expect(File.read("#{tmp_path}/questions/01.md")).to eq('# Question 2')
    end
  end
end
