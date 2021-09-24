# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::MultipleAnswers do
  let(:answer) do
    described_class.new(
      text: '<code>const</code>',
      comments: '<p>Correct!</code>',
      title: 'Correct'
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/answer/multiple_answers_question.md')
      expect(answer.to_markdown.chomp).to eq(match.chomp)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(answer.to_h).to eq({
        'answer_html' => '<code>const</code>',
        'answer_weight' => 100,
        'answer_comment_html' => '<p>Correct!</code>'
      })
    end
  end
end
