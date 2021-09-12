# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer do
  let(:multiple_choice) do
    described_class.new(
      text: 'useParams',
      comments: '<p><span>We use the <a class="external" href="https://reactrouter.com/web/api/Hooks/useparams" target="_blank"><code>useParams</code><span class="screenreader-only">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>',
      left: '',
      right: '',
      title: 'Incorrect'
    )
  end

  let(:matching) do
    described_class.new(
      text: 'Hoisting',
      comments: '',
      left: 'Hoisting',
      right: "JavaScript's ability to call functions before they appear in the code is called ___.",
      title: 'Correct'
    )
  end

  describe '#to_markdown' do
    context 'with a multiple choice question' do
      it 'produces the correct markdown' do
        output = multiple_choice.to_markdown
        match = File.read('spec/fixtures/markdown/multiple_choice_answer.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        output = matching.to_markdown
        match = File.read('spec/fixtures/markdown/matching_answer.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end

  describe '#to_h' do
    context 'with a multiple choice question' do
      it 'produces the correct hash' do
        expect(multiple_choice.to_h).to eq({
          'answer_text' => 'useParams',
          'answer_weight' => 0,
          'answer_comments' => '<p><span>We use the <a class="external" href="https://reactrouter.com/web/api/Hooks/useparams" target="_blank"><code>useParams</code><span class="screenreader-only">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>'
        })
      end
    end

    context 'with a matching question' do
      it 'produces the correct hash' do
        expect(matching.to_h).to eq({
          'answer_text' => 'Hoisting',
          'answer_weight' => 100,
          'answer_comments' => '',
          'answer_match_left' => 'Hoisting',
          'answer_match_right' => "JavaScript's ability to call functions before they appear in the code is called ___."
        })
      end
    end
  end
end
