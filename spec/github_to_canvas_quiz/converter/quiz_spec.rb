# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Quiz do
  let(:quiz_hash) do
    {
      'id' => 18396,
      'title' => 'Client-Side Routing Quiz',
      'description' => "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>"
    }
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      output = described_class.from_canvas(4236, quiz_hash).to_markdown
      match = File.read('spec/fixtures/markdown/quiz.md')
      expect(output.chomp).to eq(match.chomp)
    end
  end
end
