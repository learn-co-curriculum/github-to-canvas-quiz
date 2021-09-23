# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks do
  describe '.from_canvas' do
    it 'creates an instance of the class with the correct attributes' do
      answer = described_class.from_canvas({
        'id' => '6457',
        'text' => '&&',
        'comments' => '',
        'comments_html' => '<p>Nice one!</p>',
        'weight' => 100.0,
        'blank_id' => 'value1'
      })
      expect(answer).to have_attributes(
        title: 'Correct',
        text: '&&',
        comments: '<p>Nice one!</p>',
        blank_id: 'value1'
      )
    end
  end

  describe 'instance methods' do
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
        match = File.read('spec/fixtures/markdown/answer/fill_in_multiple_blanks_question.md')
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
end
