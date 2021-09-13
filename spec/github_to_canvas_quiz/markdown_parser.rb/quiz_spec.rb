# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::MarkdownParser::Quiz do
  describe '#parse' do
    it 'returns a hash of quiz data' do
      input = File.read('spec/fixtures/markdown/quiz.md')
      expect(described_class.new(input).parse).to eq({
        course_id: 4236,
        id: 18396,
        title: 'Client-Side Routing Quiz',
        description: "<p>It&#39;s time to check your knowledge!</p>\n\n<p>If you don&#39;t know..</p>"
      })
    end
  end
end
