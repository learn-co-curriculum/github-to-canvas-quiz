# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer::TrueFalse do
  describe '.from_canvas' do
    it 'creates an instance of the class with the correct attributes' do
      answer = described_class.from_canvas({
        'comments' => '',
        'comments_html' => '',
        'text' => 'True',
        'weight' => 100,
        'id' => 6103
      })
      expect(answer).to have_attributes(
        title: 'Correct',
        text: 'True',
        comments: ''
      )
    end
  end

  describe 'instance methods' do
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
end
