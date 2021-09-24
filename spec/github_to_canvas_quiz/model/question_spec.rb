# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Question do
  let(:multiple_choice) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 123906,
      type: 'multiple_choice_question',
      name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
      description: '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
      sources: [
        {
          'name' => 'Functions: Continued',
          'url' => 'https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565'
        }
      ],
      answers: [
        GithubToCanvasQuiz::Model::Answer::MultipleChoice.new(
          title: 'Correct',
          text: '<p>useHistory</p>',
          comments: ''
        ),
        GithubToCanvasQuiz::Model::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>useParams</p>',
          comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>'
        ),
        GithubToCanvasQuiz::Model::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>useState</p>',
          comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>'
        ),
        GithubToCanvasQuiz::Model::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>I don&#39;t know.</p>',
          comments: '<p>Comment</p>'
        )
      ],
      distractors: []
    )
  end
  let(:matching) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 144189,
      type: 'matching_question',
      name: 'Matching Question',
      description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
      sources: [
        {
          'name' => 'A Quick Tour Of The Web',
          'url' => 'https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web'
        }
      ],
      answers: [
        GithubToCanvasQuiz::Model::Answer::Matching.new(
          title: 'Correct',
          text: 'Answer 1',
          comments: '',
          left: 'Answer 1',
          right: 'Value 1'
        ),
        GithubToCanvasQuiz::Model::Answer::Matching.new(
          title: 'Correct',
          text: 'Answer 2',
          comments: '',
          left: 'Answer 2',
          right: 'Value 2'
        )
      ],
      distractors: ['Incorrect 1', 'Incorrect 2']
    )
  end
  let(:true_false) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 144189,
      type: 'true_false_question',
      name: 'Question 1',
      description: '<p>Answer true</p>',
      answers: [
        GithubToCanvasQuiz::Model::Answer::TrueFalse.new(
          title: 'Correct',
          text: 'True',
          comments: ''
        ),
        GithubToCanvasQuiz::Model::Answer::Matching.new(
          title: 'Incorrect',
          text: 'False',
          comments: ''
        )
      ],
      distractors: []
    )
  end
  let(:fill_in_multiple_blanks) do
    described_class.new(
      course_id: 3297,
      quiz_id: 12020,
      id: 130145,
      type: 'fill_in_multiple_blanks_question',
      name: 'Fundamentals: Logical Operators',
      description: "<p>How do we declare JavaScript&#39;s 3 logical operators?</p>\n\n<p>[value1] AND</p>\n\n<p>[value2] OR</p>\n\n<p>[value3] NOT</p>",
      sources: [
        {
          'name' => 'Logical Operators',
          'url' => 'https://learning.flatironschool.com/courses/3297/pages/logical-operators?module_item_id=143560'
        }
      ],
      answers: [
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '&&',
          comments: '<p>Nice one!</p>',
          blank_id: 'value1'
        ),
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"&&"',
          comments: '<p>Nice one!</p>',
          blank_id: 'value1'
        ),
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '||',
          comments: '<p>Correct!</p>',
          blank_id: 'value2'
        ),
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"||"',
          comments: '<p>Correct!</p>',
          blank_id: 'value2'
        ),
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '!',
          comments: '<p>Nailed it!</p>',
          blank_id: 'value3'
        ),
        GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"!"',
          comments: '<p>Nailed it!</p>',
          blank_id: 'value3'
        )
      ],
      distractors: []
    )
  end
  let(:code_description) do
    description = <<~HTML
      <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

      <p>Take a <em>look</em> at this <strong>code</strong> :</p>
      <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
        <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
      <span class="p">}</span>
      </code></pre></div>
    HTML
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 126509,
      type: 'multiple_choice_question',
      name: 'Functions: Scope',
      description: description,
      sources: [
        {
          'name' => 'Functions: Continued',
          'url' => 'https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565'
        }
      ],
      answers: [
        GithubToCanvasQuiz::Model::Answer::MultipleChoice.new(
          title: 'Correct',
          text: '<p>This one!</p>',
          comments: ''
        )
      ],
      distractors: []
    )
  end

  describe '#to_markdown' do
    context 'with a multiple choice question' do
      it 'produces the correct markdown' do
        match = File.read('spec/fixtures/markdown/question/multiple_choice.md')
        expect(multiple_choice.to_markdown).to eq(match)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        match = File.read('spec/fixtures/markdown/question/matching.md')
        expect(matching.to_markdown).to eq(match)
      end
    end

    context 'with a fill in multple blanks question' do
      it 'produces the correct markdown' do
        match = File.read('spec/fixtures/markdown/question/fill_in_multiple_blanks.md')
        expect(fill_in_multiple_blanks.to_markdown).to eq(match)
      end
    end

    context 'with a code block in the description' do
      it 'produces the correct markdown' do
        match = File.read('spec/fixtures/markdown/question/code_description.md')
        expect(code_description.to_markdown).to eq(match)
      end
    end
  end

  describe '#to_h' do
    context 'with a multiple choice question' do
      it 'produces the correct hash' do
        expect(multiple_choice.to_h).to eq({
          'question_name' => 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          'question_text' => '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
          'question_type' => 'multiple_choice_question',
          'points_possible' => 1,
          'neutral_comments_html' => '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></p>',
          'answers' => multiple_choice.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => ''
        })
      end
    end

    context 'with a matching question' do
      it 'produces the correct hash' do
        expect(matching.to_h).to eq({
          'question_name' => 'Matching Question',
          'question_text' => '<p>Match the value on the left to the correct value from the dropdown.</p>',
          'question_type' => 'matching_question',
          'points_possible' => 1,
          'neutral_comments_html' => '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          'answers' => matching.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => "Incorrect 1\nIncorrect 2"
        })
      end
    end

    context 'with a true/false question' do
      it 'produces the correct hash' do
        expect(true_false.to_h).to eq({
          'question_name' => 'Question 1',
          'question_text' => '<p>Answer true</p>',
          'question_type' => 'true_false_question',
          'points_possible' => 1,
          'neutral_comments_html' => '',
          'answers' => true_false.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => ''
        })
      end
    end
  end
end
