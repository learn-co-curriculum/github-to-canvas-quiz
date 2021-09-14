# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::MarkdownParser::Question do
  describe '#parse' do
    context 'with a multiple choice question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question_multiple_choice.md')
        expect(described_class.new(input).parse).to eq({
          id: 123906,
          type: 'multiple_choice_question',
          name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          description: '<p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>',
          comment: '<p><strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></strong></p>',
          answers: [
            {
              text: '<p>useHistory</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            },
            {
              text: '<p>useParams</p>',
              comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            },
            {
              text: '<p>useState</p>',
              comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            },
            {
              text: '<p>I don&#39;t know.</p>',
              comments: '<p>Comment</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a matching question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question_matching.md')
        expect(described_class.new(input).parse).to eq({
          id: 144189,
          type: 'matching_question',
          name: 'Matching Question',
          description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
          comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          answers: [
            {
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            },
            {
              text: 'Answer 2',
              comments: '',
              left: 'Answer 2',
              right: 'Value 2',
              title: 'Correct'
            }
          ],
          distractors: ['Incorrect 1', 'Incorrect 2']
        })
      end
    end

    context 'with a matching question and no distractors' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question_matching_no_distractors.md')
        expect(described_class.new(input).parse).to eq({
          id: 144189,
          type: 'matching_question',
          name: 'Matching Question',
          description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
          comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          answers: [
            {
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            },
            {
              text: 'Answer 2',
              comments: '',
              left: 'Answer 2',
              right: 'Value 2',
              title: 'Correct'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a true/false question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question_true_false.md')
        expect(described_class.new(input).parse).to eq({
          id: 123906,
          type: 'true_false_question',
          name: 'Question 1',
          description: '<p>Answer true</p>',
          comment: '',
          answers: [
            {
              text: 'True',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            },
            {
              text: 'False',
              comments: '',
              left: '',
              right: '',
              title: 'Incorrect'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a code block in the description' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question_code_description.md')
        description = <<~HTML
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

          <p>Take a <em>look</em> at this <strong>code</strong> :</p>
          <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
            <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
          <span class="p">}</span>
          </code></pre></div>
        HTML
        expect(described_class.new(input).parse).to eq({
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description.strip,
          comment: '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></p>',
          answers: [
            {
              text: '<p>This one!</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            }
          ],
          distractors: []
        })
      end
    end
  end
end
