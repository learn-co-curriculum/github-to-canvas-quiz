# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Parser::Markdown::Question do
  describe '#parse' do
    context 'with a multiple choice question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/multiple_choice.md')
        expect(described_class.new(input).parse).to eq({
          course_id: 4091,
          quiz_id: 21962,
          id: 123906,
          type: 'multiple_choice_question',
          name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          description: '<p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>',
          sources: [
            {
              'name' => 'Functions: Continued',
              'url' => 'https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565'
            }
          ],
          answers: [
            {
              type: 'multiple_choice_question',
              text: '<p>useHistory</p>',
              comments: '',
              title: 'Correct'
            },
            {
              type: 'multiple_choice_question',
              text: '<p>useParams</p>',
              comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
              title: 'Incorrect'
            },
            {
              type: 'multiple_choice_question',
              text: '<p>useState</p>',
              comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
              title: 'Incorrect'
            },
            {
              type: 'multiple_choice_question',
              text: "<p>I don't know.</p>",
              comments: '<p>Comment</p>',
              title: 'Incorrect'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a matching question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/matching.md')
        expect(described_class.new(input).parse).to eq({
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
            {
              type: 'matching_question',
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            },
            {
              type: 'matching_question',
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
        input = File.read('spec/fixtures/markdown/question/matching_no_distractors.md')
        expect(described_class.new(input).parse).to eq({
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
            {
              type: 'matching_question',
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            },
            {
              type: 'matching_question',
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
        input = File.read('spec/fixtures/markdown/question/true_false.md')
        expect(described_class.new(input).parse).to eq({
          course_id: 4091,
          quiz_id: 21962,
          id: 123906,
          type: 'true_false_question',
          name: 'Question 1',
          description: '<p>Answer true</p>',
          sources: nil,
          answers: [
            {
              type: 'true_false_question',
              text: 'True',
              comments: '',
              title: 'Correct'
            },
            {
              type: 'true_false_question',
              text: 'False',
              comments: '',
              title: 'Incorrect'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a short answer question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/short_answer.md')
        expect(described_class.new(input).parse).to eq({
          course_id: 3297,
          quiz_id: 12282,
          id: 144185,
          type: 'short_answer_question',
          name: 'Events: Forms',
          description: '<p>The ______ event fires when a form is submitted.</p>',
          sources: [
            {
              'name' => 'Video: Forms',
              'url' => 'https://learning.flatironschool.com/courses/3297/pages/video-forms?module_item_id=270739'
            }
          ],
          answers: [
            {
              type: 'short_answer_question',
              text: 'submit',
              comments: '',
              title: 'Correct'
            },
            {
              type: 'short_answer_question',
              text: 'Submit',
              comments: '',
              title: 'Correct'
            },
            {
              type: 'short_answer_question',
              text: "'submit'",
              comments: '',
              title: 'Correct'
            },
            {
              type: 'short_answer_question',
              text: '"submit"',
              comments: '',
              title: 'Correct'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a fill in multiple blanks question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/fill_in_multiple_blanks.md')
        expect(described_class.new(input).parse).to eq({
          course_id: 3297,
          quiz_id: 12020,
          id: 130145,
          type: 'fill_in_multiple_blanks_question',
          name: 'Fundamentals: Logical Operators',
          description: "<p>How do we declare JavaScript's 3 logical operators?</p>\n\n<p>[value1] AND</p>\n\n<p>[value2] OR</p>\n\n<p>[value3] NOT</p>",
          sources: [
            {
              'name' => 'Logical Operators',
              'url' => 'https://learning.flatironschool.com/courses/3297/pages/logical-operators?module_item_id=143560'
            }
          ],
          answers: [
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '&&',
              comments: '<p>Nice one!</p>',
              blank_id: 'value1'
            },
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '"&&"',
              comments: '<p>Nice one!</p>',
              blank_id: 'value1'
            },
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '||',
              comments: '<p>Correct!</p>',
              blank_id: 'value2'
            },
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '"||"',
              comments: '<p>Correct!</p>',
              blank_id: 'value2'
            },
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '!',
              comments: '<p>Nailed it!</p>',
              blank_id: 'value3'
            },
            {
              type: 'fill_in_multiple_blanks_question',
              title: 'Correct',
              text: '"!"',
              comments: '<p>Nailed it!</p>',
              blank_id: 'value3'
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a multiple answers question' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/multiple_answers.md')
        expect(described_class.new(input).parse).to eq({
          course_id: 3264,
          quiz_id: 18302,
          id: 123916,
          type: 'multiple_answers_question',
          name: 'Exporting',
          description: "<p>I want to render the Card component inside of my Container component. How would\nI properly export the Card component?</p>\n<div class=\"highlight\"><pre class=\"highlight jsx\"><code><span class=\"kd\">function</span> <span class=\"nx\">Card</span><span class=\"p\">({</span> <span class=\"nx\">title</span><span class=\"p\">,</span> <span class=\"nx\">subtitle</span> <span class=\"p\">})</span> <span class=\"p\">{</span>\n  <span class=\"k\">return</span> <span class=\"p\">(</span>\n    <span class=\"p\">&lt;</span><span class=\"nt\">div</span><span class=\"p\">&gt;</span>\n      <span class=\"p\">&lt;</span><span class=\"nt\">h1</span><span class=\"p\">&gt;</span><span class=\"si\">{</span><span class=\"nx\">title</span><span class=\"si\">}</span><span class=\"p\">&lt;/</span><span class=\"nt\">h1</span><span class=\"p\">&gt;</span>\n      <span class=\"p\">&lt;</span><span class=\"nt\">p</span><span class=\"p\">&gt;</span><span class=\"si\">{</span><span class=\"nx\">subtitle</span><span class=\"si\">}</span><span class=\"p\">&lt;/</span><span class=\"nt\">p</span><span class=\"p\">&gt;</span>\n    <span class=\"p\">&lt;/</span><span class=\"nt\">div</span><span class=\"p\">&gt;</span>\n  <span class=\"p\">);</span>\n<span class=\"p\">}</span>\n</code></pre></div>",
          sources: nil,
          answers: [
            {
              type: 'multiple_answers_question',
              title: 'Correct',
              text: "<div class=\"highlight\"><pre class=\"highlight jsx\"><code><span class=\"kd\">function</span> <span class=\"nx\">Card</span><span class=\"p\">({</span> <span class=\"nx\">title</span><span class=\"p\">,</span> <span class=\"nx\">subtitle</span> <span class=\"p\">})</span> <span class=\"p\">{</span> <span class=\"p\">...</span> <span class=\"p\">}</span>\n\n<span class=\"k\">export</span> <span class=\"k\">default</span> <span class=\"nx\">Card</span><span class=\"p\">;</span>\n</code></pre></div>",
              comments: ''
            },
            {
              type: 'multiple_answers_question',
              title: 'Correct',
              text: "<div class=\"highlight\"><pre class=\"highlight jsx\"><code><span class=\"k\">export</span> <span class=\"k\">default</span> <span class=\"kd\">function</span> <span class=\"nx\">Card</span><span class=\"p\">({</span> <span class=\"nx\">title</span><span class=\"p\">,</span> <span class=\"nx\">subtitle</span> <span class=\"p\">})</span> <span class=\"p\">{</span> <span class=\"p\">...</span> <span class=\"p\">}</span>\n</code></pre></div>",
              comments: ''
            },
            {
              type: 'multiple_answers_question',
              title: 'Incorrect',
              text: "<div class=\"highlight\"><pre class=\"highlight jsx\"><code><span class=\"kd\">function</span> <span class=\"nx\">Card</span><span class=\"p\">({</span> <span class=\"nx\">title</span><span class=\"p\">,</span> <span class=\"nx\">subtitle</span> <span class=\"p\">})</span> <span class=\"p\">{</span> <span class=\"p\">...</span> <span class=\"p\">}</span>\n<span class=\"k\">export</span> <span class=\"nx\">cardComponent</span><span class=\"p\">;</span>\n</code></pre></div>",
              comments: '<p>Be sure you are exporting the correct function!</p>'
            },
            {
              type: 'multiple_answers_question',
              title: 'Incorrect',
              text: "<p>I don't know.</p>",
              comments: ''
            }
          ],
          distractors: []
        })
      end
    end

    context 'with a code block in the description' do
      it 'returns a hash of question data' do
        input = File.read('spec/fixtures/markdown/question/code_description.md')
        description = <<~HTML
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

          <p>Take a <em>look</em> at this <strong>code</strong> :</p>
          <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
            <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
          <span class="p">}</span>
          </code></pre></div>
        HTML
        expect(described_class.new(input).parse).to eq({
          course_id: 4091,
          quiz_id: 21962,
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description.strip,
          sources: [
            {
              'name' => 'Functions: Continued',
              'url' => 'https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565'
            }
          ],
          answers: [
            {
              type: 'multiple_choice_question',
              text: '<p>This one!</p>',
              comments: '',
              title: 'Correct'
            }
          ],
          distractors: []
        })
      end
    end
  end
end
