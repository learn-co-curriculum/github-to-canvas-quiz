# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::Matching do
  let(:answer) do
    described_class.new(
      title: 'Correct',
      text: 'Hoisting',
      comments: '',
      left: 'Hoisting',
      right: "JavaScript's ability to call functions before they appear in the code is called ___."
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/answer/matching_question.md')
      expect(answer.to_markdown.chomp).to eq(match.chomp)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(answer.to_h).to eq({
        'answer_text' => 'Hoisting',
        'answer_weight' => 100,
        'answer_comment_html' => '',
        'answer_match_left' => 'Hoisting',
        'answer_match_right' => "JavaScript's ability to call functions before they appear in the code is called ___."
      })
    end
  end
end
