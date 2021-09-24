# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::ShortAnswer do
  let(:answer) do
    described_class.new(
      type: 'short_answer_question',
      text: '"addEventListener"',
      comments: '',
      title: 'Correct'
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/answer/short_answer_question.md')
      expect(answer.to_markdown.chomp).to eq(match.chomp)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(answer.to_h).to eq({
        'answer_text' => '"addEventListener"',
        'answer_weight' => 100,
        'answer_comment_html' => ''
      })
    end
  end
end
