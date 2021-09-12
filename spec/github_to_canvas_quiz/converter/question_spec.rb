# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Question do
  let(:multiple_choice) do
    described_class.new(
      id: 123906,
      type: 'multiple_choice_question',
      name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
      description: '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
      comment: '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useHistory</p>',
          comments: '',
          left: '',
          right: '',
          title: 'Correct'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useParams</p>',
          comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
          left: '',
          right: '',
          title: 'Incorrect'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useState</p>',
          comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
          left: '',
          right: '',
          title: 'Incorrect'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>I don&#39;t know.</p>',
          comments: '',
          left: '',
          right: '',
          title: 'Incorrect'
        )
      ],
      distractors: []
    )
  end
  let(:matching) do
    described_class.new(
      id: 144189,
      type: 'matching_question',
      name: 'Matching Question',
      description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
      comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'Answer 1',
          comments: '',
          left: 'Answer 1',
          right: 'Value 1',
          title: 'Correct'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'Answer 2',
          comments: '',
          left: 'Answer 2',
          right: 'Value 2',
          title: 'Correct'
        )
      ],
      distractors: ['Incorrect 1', 'Incorrect 2']
    )
  end

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
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useHistory</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useParams</p>',
              comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useState</p>',
              comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>I don&#39;t know.</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Incorrect'
            )
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
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'Answer 2',
              comments: '',
              left: 'Answer 2',
              right: 'Value 2',
              title: 'Correct'
            )
          ],
          distractors: ['Incorrect 1', 'Incorrect 2']
        )
      end
    end
  end

  describe '#to_markdown' do
    context 'with a multiple choice question' do
      it 'produces the correct markdown' do
        output = multiple_choice.to_markdown
        match = File.read('spec/fixtures/markdown/question_multiple_choice.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        output = matching.to_markdown
        match = File.read('spec/fixtures/markdown/question_matching.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a code block in the description' do
      it 'produces the correct markdown' do
        output = described_class.new(
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: "<p class=\"code-line code-line\" data-line=\"59\">Which variables does the function&nbsp;<code>inner2</code> have access to?</p>\n<div>\n<div>\n<pre><code><span>const part1 = 'hello'</span></code><br><br><code><span>function demoChain(name) {</span></code><br><code><span>  &nbsp; let part2 = 'hi'</span></code><br><code><span>  &nbsp; return function inner1() {</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; let part3 = 'there'</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; return function inner2() {</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; console.log(`${part1.toUpperCase()} ${part2} ${name}`);</span></code><br><code><span>  &nbsp; &nbsp; &nbsp; }</span></code><br><code><span>  &nbsp; }</span></code><br><code><span>}</span></code><br><br><code><span>demoChain(\"Dr. Stephen Strange\")()()</span></code><br><br><code><span>//=&gt; HELLO hi Dr. Stephen Strange<br></span></code></pre>\n</div>\n</div>",
          comment: '<p><strong>Source/s:&nbsp;</strong><a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></p>',
          answers: [],
          distractors: ''
        ).to_markdown
        match = File.read('spec/fixtures/markdown/question_code_description.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end

  describe '#to_h' do
    context 'with a multiple choice question' do
      it 'produces the correct hash' do
        output = multiple_choice.to_h
        expect(output).to eq({
          'id' => 123906,
          'question' => {
            'question_name' => 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
            'question_text' => '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
            'question_type' => 'multiple_choice_question',
            'points_possible' => 1,
            'neutral_comments_html' => '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
            'answers' => multiple_choice.answers.map(&:to_h),
            'matching_answer_incorrect_matches' => ''
          }
        })
      end
    end

    context 'with a matching question' do
      it 'produces the correct hash' do
        output = matching.to_h
        expect(output).to eq({
          'id' => 144189,
          'question' => {
            'question_name' => 'Matching Question',
            'question_text' => '<p>Match the value on the left to the correct value from the dropdown.</p>',
            'question_type' => 'matching_question',
            'points_possible' => 1,
            'neutral_comments_html' => '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
            'answers' => matching.answers.map(&:to_h),
            'matching_answer_incorrect_matches' => "Incorrect 1\nIncorrect 2"
          }
        })
      end
    end
  end
end
