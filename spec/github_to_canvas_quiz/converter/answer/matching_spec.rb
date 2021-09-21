# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer::Matching do
  describe '.from_canvas' do
    it 'creates an instance of the class with the correct attributes' do
      answer = described_class.from_canvas({
        'id' => 6031,
        'text' => 'Declarative Programming',
        'left' => 'Declarative Programming',
        'right' => 'Describes what a program should accomplish (or what the end result should be) Leaves the determination of how to get to the end result up to the program.',
        'comments' => '',
        'comments_html' => "<p><span>Be sure to study the source/s for this question. You'll get it next time.</span></p>",
        'match_id' => 3761
      })
      expect(answer).to have_attributes(
        text: 'Declarative Programming',
        left: 'Declarative Programming',
        right: 'Describes what a program should accomplish (or what the end result should be) Leaves the determination of how to get to the end result up to the program.',
        comments: "<p><span>Be sure to study the source/s for this question. You'll get it next time.</span></p>",
        title: 'Correct'
      )
    end
  end

  describe 'instance methods' do
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
end
