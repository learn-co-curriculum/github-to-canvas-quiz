# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Quiz do
  describe '.from_markdown' do
    it 'creates a Quiz instance with the correct data' do
      input = File.read('spec/fixtures/markdown/quiz.md')
      expect(described_class.from_markdown(input)).to have_attributes(
        course_id: 4236,
        id: 18396,
        title: 'Client-Side Routing Quiz',
        description: "<p>It&#39;s time to check your knowledge!</p>\n\n<p>If you don&#39;t know..</p>"
      )
    end
  end

  describe '#to_markdown' do
    let(:quiz_hash) do
      {
        'id' => 18396,
        'title' => 'Client-Side Routing Quiz',
        'description' => "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>"
      }
    end

    it 'produces the correct markdown' do
      output = described_class.from_canvas(4236, quiz_hash).to_markdown
      match = File.read('spec/fixtures/markdown/quiz.md')
      expect(output.chomp).to eq(match.chomp)
    end
  end
end
