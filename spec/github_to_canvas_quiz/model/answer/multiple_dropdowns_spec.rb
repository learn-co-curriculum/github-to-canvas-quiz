# # frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::MultipleDropdowns do
  let(:answer) do
    described_class.new(
      title: 'Correct',
      text: '&&',
      comments: '<p>Nice one!</p>',
      blank_id: 'value1'
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/answer/multiple_dropdowns.md')
      expect(answer.to_markdown).to eq(match)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(answer.to_h).to eq({
        'answer_text' => '&&',
        'answer_weight' => 100,
        'answer_comment_html' => '<p>Nice one!</p>',
        'blank_id' => 'value1'
      })
    end
  end
end
