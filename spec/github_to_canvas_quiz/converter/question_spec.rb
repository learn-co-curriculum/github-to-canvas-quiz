# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Question do
  let(:question_hash) do
    {
      'id' => 123906,
      'question_name' => 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
      'question_type' => 'multiple_choice_question',
      'question_text' => '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
      'neutral_comments_html' => '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
      'answers' => [
        {
          'text' => 'useHistory',
          'comments_html' => '',
          'weight' => 100.0
        },
        {
          'text' => 'useParams',
          'comments_html' => "<p><span>We use the <a class=\"external\" href=\"https://reactrouter.com/web/api/Hooks/useparams\" target=\"_blank\"><code>useParams</code><span class=\"screenreader-only\">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>",
          'weight' => 0.0
        },
        {
          'text' => 'useState',
          'comments_html' => "<p><span>We use the&nbsp;<a class=\"inline_disabled\" href=\"https://reactjs.org/docs/hooks-reference.html#usestate\" target=\"_blank\">useState</a> hook to return a stateful value, and a function to update it.</span></p>",
          'weight' => 0.0
        },
        {
          'text' => "I don't know.",
          'comments_html' => '',
          'weight' => 0.0
        }
      ]
    }
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      output = described_class.from_canvas(question_hash).to_markdown
      match = File.read('spec/fixtures/markdown/question_multiple_choice.md')
      expect(output.chomp).to eq(match.chomp)
    end

    context 'with a code block in the description' do
      it 'produces the correct markdown' do
        question_hash = {
          'id' => 126509,
          'question_name' => 'Functions: Scope',
          'question_type' => 'multiple_choice_question',
          'question_text' => "<p class=\"code-line code-line\" data-line=\"59\">Which variables does the function&nbsp;<code>inner2</code> have access to?</p>\n<div>\n<div>\n<pre><code><span>const part1 = 'hello'</span></code><br><br><code><span>function demoChain(name) {</span></code><br><code><span>  &nbsp; let part2 = 'hi'</span></code><br><code><span>  &nbsp; return function inner1() {</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; let part3 = 'there'</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; return function inner2() {</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; console.log(`${part1.toUpperCase()} ${part2} ${name}`);</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; }</span></code><br><code><span>  &nbsp; }</span></code><br><code><span>}</span></code><br><br><code><span>demoChain(\"Dr. Stephen Strange\")()()</span></code><br><br><code><span>//=&gt; HELLO hi Dr. Stephen Strange<br></span></code></pre>\n</div>\n</div>",
          'neutral_comments_html' => "<p><strong>Source/s:&nbsp;</strong><a class=\"inline_disabled\" href=\"https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565\" target=\"_blank\">Functions: Continued</a></p>",
          'answers' => []
        }
        output = described_class.from_canvas(question_hash).to_markdown
        match = File.read('spec/fixtures/markdown/question_code_description.md')
        File.write('tmp/out.md', output)
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end
end
