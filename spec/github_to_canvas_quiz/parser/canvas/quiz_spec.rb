# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Parser::Canvas::Quiz do
  describe '#load' do
    it 'creates a Quiz instance with the correct data' do
      VCR.use_cassette 'quiz' do
        client = GithubToCanvasQuiz::CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
        data = client.get_single_quiz(4091, 21982)
        data.merge!({ 'course_id' => 4091 })
        expect(described_class.new(data).parse).to have_attributes(
          class: GithubToCanvasQuiz::Model::Quiz,
          course_id: 4091,
          id: 21982,
          title: 'Test for Gem',
          description: '<p>Description!</p>'
        )
      end
    end
    it 'parses a repo from the quiz description' do
      VCR.use_cassette 'quiz_with_repo_header' do
        client = GithubToCanvasQuiz::CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
        data = client.get_single_quiz(4091, 21961)
        data.merge!({ 'course_id' => 4091 })
        expect(described_class.new(data).parse).to have_attributes(
          class: GithubToCanvasQuiz::Model::Quiz,
          course_id: 4091,
          id: 21961,
          repo: 'example-repo',
          title: 'Enumerators Quiz',
          description: '<p>Description!</p>'
        )
      end
    end
  end
end
