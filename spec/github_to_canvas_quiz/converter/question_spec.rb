# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Question do
  describe '.from_markdown' do
    context 'with a multiple choice question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_multiple_choice.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 123906,
          type: 'multiple_choice_question',
          name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          description: '<p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>',
          comment: '<p><strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></strong></p>',
          answers: [
            {
              'html' => '<p>useHistory</p>',
              'comments_html' => '',
              'weight' => 100,
              'title' => 'Correct'
            },
            {
              'html' => '<p>useParams</p>',
              'comments_html' => '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
              'weight' => 0,
              'title' => 'Incorrect'
            },
            {
              'html' => '<p>useState</p>',
              'comments_html' => '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
              'weight' => 0,
              'title' => 'Incorrect'
            },
            {
              'html' => '<p>I don&#39;t know.</p>',
              'comments_html' => '',
              'weight' => 0,
              'title' => 'Incorrect'
            }
          ]
        )
      end
    end

    context 'with a matching question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_matching.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 144189,
          type: 'matching_question',
          name: 'Matching Question',
          description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
          comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          answers: [
            {
              'text' => 'Answer 1',
              'left' => 'Answer 1',
              'right' => 'Value 1',
              'comments_html' => '',
              'title' => 'Correct'
            },
            {
              'text' => 'Answer 2',
              'left' => 'Answer 2',
              'right' => 'Value 2',
              'comments_html' => '',
              'title' => 'Correct'
            }
          ],
          distractors: ['Incorrect 1', 'Incorrect 2']
        )
      end
    end
  end

  describe '#to_markdown' do
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
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        question_hash = {
          'id' => 144189,
          'question_name' => 'Matching Question',
          'question_type' => 'matching_question',
          'question_text' => '<p>Match the value on the left to the correct value from the dropdown.</p>',
          'neutral_comments_html' => '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          'answers' => [
            {
              'text' => 'Answer 1',
              'left' => 'Answer 1',
              'right' => 'Value 1'
            },
            {
              'text' => 'Answer 2',
              'left' => 'Answer 2',
              'right' => 'Value 2'
            }
          ],
          'matching_answer_incorrect_matches' => "Incorrect 1\nIncorrect 2"
        }
        output = described_class.from_canvas(question_hash).to_markdown
        match = File.read('spec/fixtures/markdown/question_matching.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end
end
