# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Parser::Markdown::Quiz do
  describe '#parse' do
    it 'returns a hash of quiz data' do
      markdown = File.read('spec/fixtures/markdown/quiz.md')
      expect(described_class.new(markdown).parse).to have_attributes(
        class: GithubToCanvasQuiz::Model::Quiz,
        course_id: 4236,
        id: 18396,
        repo: 'phase-2-quiz-client-side-routing',
        title: 'Client-Side Routing Quiz',
        description: "<p>It's time to check your knowledge!</p>\n\n<p>If you don't know..</p>"
      )
    end
  end
end
