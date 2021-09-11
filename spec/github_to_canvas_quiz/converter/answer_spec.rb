# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer do
  describe '#to_markdown' do
    context 'with a multiple choice question' do
      it 'produces the correct markdown' do
        answer_hash = {
          'text' => 'useParams',
          'comments_html' => "<p><span>We use the <a class=\"external\" href=\"https://reactrouter.com/web/api/Hooks/useparams\" target=\"_blank\"><code>useParams</code><span class=\"screenreader-only\">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>",
          'weight' => 0.0
        }
        output = described_class.from_canvas(answer_hash).to_markdown
        match = File.read('spec/fixtures/markdown/multiple_choice_answer.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        answer_hash = {
          'text' => 'Hoisting',
          'left' => 'Hoisting',
          'right' => "JavaScript's ability to call functions before they appear in the code is called ___.",
          'comments' => '',
          'comments_html' => ''
        }
        output = described_class.from_canvas(answer_hash).to_markdown
        match = File.read('spec/fixtures/markdown/matching_answer.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end
end
