# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::TrueFalse do
  let(:answer) do
    described_class.new(
      text: 'True',
      comments: '',
      title: 'Correct'
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/answer/true_false_question.md')
      expect(answer.to_markdown.chomp).to eq(match.chomp)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(answer.to_h).to eq({
        'answer_text' => 'True',
        'answer_weight' => 100,
        'answer_comment_html' => ''
      })
    end
  end
end
