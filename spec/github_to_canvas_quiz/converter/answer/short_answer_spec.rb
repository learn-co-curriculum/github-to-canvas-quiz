# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer::ShortAnswer do
  describe '.from_canvas' do
    it 'creates an instance of the class with the correct attributes' do
      answer = described_class.from_canvas({
        'id' => '2002',
        'text' => 'props',
        'comments' => '',
        'comments_html' => '',
        'weight' => 100
      })
      expect(answer).to have_attributes(
        text: 'props',
        comments: '',
        title: 'Correct'
      )
    end
  end

  describe 'instance methods' do
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
end
